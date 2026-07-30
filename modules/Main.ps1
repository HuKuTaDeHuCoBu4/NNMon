# Main.ps1 – точка входа

# Защита от повторного запуска
$mutex = New-Object System.Threading.Mutex($false, "Global\NetworkMonitorByNikitaMutex")
if (-not $mutex.WaitOne(0, $false)) {
    Write-Host "Программа уже запущена. Пожалуйста, разверните её из системного трея." -ForegroundColor Yellow
    Start-Sleep -Seconds 2
    # Попробуем найти и развернуть существующее окно
    try {
        $existingProcess = Get-Process powershell | Where-Object { $_.Id -ne $pid -and $_.MainWindowTitle -match "Мониторинг сети от Никиты" }
        if ($existingProcess) {
            # Показать окно
            $hwnd = $existingProcess.MainWindowHandle
            if ($hwnd -ne [IntPtr]::Zero) {
                [Console.Window]::ShowWindow($hwnd, 5)  # SW_SHOW
                $global:windowVisible = $true
            }
        }
    } catch {}
    exit
}

# Подключаем модули
. "$PSScriptRoot\Config.ps1"
. "$PSScriptRoot\Network.ps1"
. "$PSScriptRoot\Logging.ps1"
. "$PSScriptRoot\Statistics.ps1"
. "$PSScriptRoot\Sound.ps1"
. "$PSScriptRoot\UI.ps1"
. "$PSScriptRoot\Menu.ps1"
. "$PSScriptRoot\Diagnostics.ps1"
. "$PSScriptRoot\Quest.ps1"

# === ИНИЦИАЛИЗАЦИЯ ПЕРЕМЕННЫХ ===
$routerHistory = @()
$inetHistory   = @()
$inet2History  = @()
$preBuffer     = @()

$lossActive    = $false
$postCapture   = $false
$lossStartTime = $null
$lossLines     = @()
$preLossLines  = @()
$postLossLines = @()

$beepPlayed    = $false
$exitFromMenu  = $false
$script:outageCount = 0
$script:lastTraceTime = $null
$script:lastBaselineTime = $null

$initialLogLineCount = 0
if (Test-Path $logFile) {
    $initialLogLineCount = (Get-Content -Path $logFile -ErrorAction SilentlyContinue | Measure-Object -Line).Lines
}

# === ЗАСТАВКА ===
Clear-Host
$host.UI.RawUI.WindowTitle = "NNMon"
$width = [Console]::WindowWidth
if (-not $width) { $width = 80 }
$lines = @(
" ",
" ███╗   ██╗███╗   ██╗███╗   ███╗ ██████╗ ███╗   ██╗",
" ████╗  ██║████╗  ██║████╗ ████║██╔═══██╗████╗  ██║",
" ██╔██╗ ██║██╔██╗ ██║██╔████╔██║██║   ██║██╔██╗ ██║",
" ██║╚██╗██║██║╚██╗██║██║╚██╔╝██║██║   ██║██║╚██╗██║",
" ██║ ╚████║██║ ╚████║██║ ╚═╝ ██║╚██████╔╝██║ ╚████║",
" ╚═╝  ╚═══╝╚═╝  ╚═══╝╚═╝     ╚═╝ ╚═════╝ ╚═╝  ╚═══╝",
" ",
"                   СЕТЕВОЙ МОНИТОРИНГ от HuKuTa_0",
" "
)
$maxLineLength = ($lines | ForEach-Object { $_.Length } | Measure-Object -Maximum).Maximum
$leftPad = [math]::Max(0, [math]::Floor(($width - $maxLineLength) / 2))
foreach ($line in $lines) {
    if ($line.Trim() -eq "") { Write-Host "" }
    else {
        Write-Host (" " * $leftPad) -NoNewline
        Write-Host $line -ForegroundColor Cyan
    }
}
Write-Host ""
Write-Host (" " * $leftPad) -NoNewline
Write-Host "Загрузка " -NoNewline -ForegroundColor DarkGray
$spinner = @('|','/','-','\')
for ($i = 0; $i -lt 6; $i++) {
    Write-Host $spinner[$i % 4] -NoNewline -ForegroundColor Cyan
    Start-Sleep -Milliseconds 200
    Write-Host "`b" -NoNewline
}

Clear-Host

[Console]::TreatControlCAsInput = $true

# Разделители по дням (сначала добавляем разделители, потом проверяем целостность)
$todayInternal = Get-Date -Format "yyyy-MM-dd"
$todayFormatted = Get-Date -Format "dd.MM.yyyy"
Add-DateSeparator -FilePath $logFile -TodayInternal $todayInternal -TodayFormatted $todayFormatted
Add-DateSeparator -FilePath $lossFile -TodayInternal $todayInternal -TodayFormatted $todayFormatted

# Проверка целостности лога (быстрая) – после разделителей
Check-LogIntegrity

# Стартовый маркер
$startTime = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
Add-Content -Path $logFile -Value "$startTime --- Запуск Проверки ---" -Encoding UTF8

$sessionStopwatch = [System.Diagnostics.Stopwatch]::StartNew()
$script:stats.TotalTime = $sessionStopwatch
$script:stats.LossTime.Reset()

$displayBuffer = @()

# === ОСНОВНОЙ ЦИКЛ ===
$esc = [char]27
try {
    while ($true) {
        $time = Get-Date -Format "yyyy-MM-dd HH:mm:ss"

        $routerPing = Get-PingTime $config.routerIP
        $inetPing   = Get-PingTime $config.internetIP
        $inet2Ping  = Get-PingTime $config.internetIP2

        $routerOK = $routerPing -ge 0
        $inetOK   = $inetPing   -ge 0
        $inet2OK  = $inet2Ping  -ge 0

        Update-Stats -Ping $routerPing -OK $routerOK -HostName "Router"
        Update-Stats -Ping $inetPing   -OK $inetOK   -HostName "Internet1"
        Update-Stats -Ping $inet2Ping  -OK $inet2OK  -HostName "Internet2"

        $routerHistory += $routerOK
        $inetHistory   += $inetOK
        $inet2History  += $inet2OK
        $hSize = $config.historySize
        if ($routerHistory.Count -gt $hSize) { $routerHistory = $routerHistory[-$hSize..-1] }
        if ($inetHistory.Count   -gt $hSize) { $inetHistory   = $inetHistory[-$hSize..-1] }
        if ($inet2History.Count  -gt $hSize) { $inet2History  = $inet2History[-$hSize..-1] }

        $routerLoss = [math]::Round((($routerHistory | Where-Object { $_ -eq $false }).Count / $routerHistory.Count) * 100, 1)
        $inetLoss   = [math]::Round((($inetHistory   | Where-Object { $_ -eq $false }).Count / $inetHistory.Count)   * 100, 1)
        $inet2Loss  = [math]::Round((($inet2History  | Where-Object { $_ -eq $false }).Count / $inet2History.Count)  * 100, 1)

        $rStat = Get-StatusColor -Ping $routerPing -Threshold $config.goodPingThresholdRouter -OK $routerOK
        $i1Stat = Get-StatusColor -Ping $inetPing -Threshold $config.goodPingThresholdInet1 -OK $inetOK
        $i2Stat = Get-StatusColor -Ping $inet2Ping -Threshold $config.goodPingThresholdInet2 -OK $inet2OK

        $routerDisplay = if ($routerPing -eq 0) { "<1ms" } else { "${routerPing}ms" }
        $inetDisplay   = if ($inetPing   -eq 0) { "<1ms" } else { "${inetPing}ms"   }
        $inet2Display  = if ($inet2Ping  -eq 0) { "<1ms" } else { "${inet2Ping}ms"  }

        $coloredLine = "$time | Router: $esc[$($rStat.AnsiCode)m${routerDisplay} (Loss: ${routerLoss}%)$esc[0m | Internet1: $esc[$($i1Stat.AnsiCode)m${inetDisplay} (Loss: ${inetLoss}%)$esc[0m | Internet2: $esc[$($i2Stat.AnsiCode)m${inet2Display} (Loss: ${inet2Loss}%)$esc[0m"
        $plainLine = "$time | Router: ${routerDisplay} (Loss: ${routerLoss}%) | Internet1: ${inetDisplay} (Loss: ${inetLoss}%) | Internet2: ${inet2Display} (Loss: ${inet2Loss}%)"

        $isCritical = (-not $routerOK) -or (-not $inetOK) -or $routerLoss -gt 0 -or $inetLoss -gt 0
        $isBadPing = ($routerOK -and $routerPing -gt $config.goodPingThresholdRouter) -or
                     ($inetOK   -and $inetPing   -gt $config.goodPingThresholdInet1)

        if (Should-PlaySound -IsCritical $isCritical -IsBadPing $isBadPing) {
            if (-not $beepPlayed) {
                Play-Sound
                $beepPlayed = $true
            }
        } else {
            $beepPlayed = $false
        }

        if ($isCritical) {
            if ($notifyIcon.Icon -ne [System.Drawing.SystemIcons]::Error) {
                try { $notifyIcon.Icon = [System.Drawing.SystemIcons]::Error } catch {}
            }
        } else {
            if ($notifyIcon.Icon -ne $icon) { try { $notifyIcon.Icon = $icon } catch {} }
        }

        Add-Content -Path $logFile -Value $plainLine -Encoding UTF8
        "$time,$routerPing,$inetPing,$inet2Ping,$routerLoss,$inetLoss,$inet2Loss" | Add-Content -Path $csvFile -Encoding UTF8

        $isLoss = (-not $routerOK) -or (-not $inetOK)
        if ($isLoss -and -not $lossActive) {
            $script:outageCount++
            $script:stats.LossTime.Start()
        }

                                 # Трассировка при начале обрыва (не чаще раза в 60 секунд, фоновая)
            $now = Get-Date
            if (-not $script:lastTraceTime -or ($now - $script:lastTraceTime).TotalSeconds -ge 60) {
                $traceIP = if (-not $routerOK) { $config.routerIP } else { $config.internetIP }
                $script:lastTraceTime = $now
                Start-Job -Name "TraceJob" -ArgumentList $traceIP, $lossFile -ScriptBlock {
                    param($ip, $file)
                    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
                    $header = "`n--- Трассировка до $ip (обрыв пинга) [$timestamp] ---"
                    Add-Content -Path $file -Value $header -Encoding UTF8
                    try {
                        $trace = tracert -d -h 15 -w 1000 $ip 2>&1
                        foreach ($line in $trace) { Add-Content -Path $file -Value $line -Encoding UTF8 }
                    } catch {
                        Add-Content -Path $file -Value "Не удалось выполнить tracert: $_" -Encoding UTF8
                    }
                    Add-Content -Path $file -Value "--- Конец трассировки ---`r`n" -Encoding UTF8
                } | Out-Null
            }

        if (-not $isLoss -and $lossActive) {
            $script:stats.LossTime.Stop()
        }

        if (-not $isLoss) {
            $preBuffer += $plainLine
            if ($preBuffer.Count -gt $config.contextLines) { $preBuffer = $preBuffer[-$config.contextLines..-1] }
        }
        if ($isLoss) {
            if ($postCapture) {
                Write-LossEvent -StartTime $lossStartTime -PreLines $preLossLines -LossLines $lossLines -PostLines $postLossLines
                $postCapture = $false; $postLossLines = @(); $lossLines = @(); $preLossLines = @()
            }
            if (-not $lossActive) {
                $lossActive = $true; $lossStartTime = $time; $preLossLines = @() + $preBuffer; $lossLines = @($plainLine)
            } else { $lossLines += $plainLine }
        } else {
            if ($lossActive) { $lossActive = $false; $postCapture = $true; $postLossLines = @($plainLine) }
            elseif ($postCapture) {
                $postLossLines += $plainLine
                if ($postLossLines.Count -ge $config.contextLines) {
                    Write-LossEvent -StartTime $lossStartTime -PreLines $preLossLines -LossLines $lossLines -PostLines $postLossLines
                    $postCapture = $false; $postLossLines = @(); $lossLines = @(); $preLossLines = @()
                }
            }
        }

        $routerText = if ($routerOK) { "Онлайн" } else { "Офлайн" }
        $inetText   = if ($inetOK)   { "Онлайн" } else { "Офлайн" }
        $lossPercentStr = if ($inetLoss -gt 0 -or $routerLoss -gt 0) { "$inetLoss%/$routerLoss%" } else { "0.0%" }
        $sessionTimeStr = $sessionStopwatch.Elapsed.ToString("hh\:mm")

        $displayBuffer = @($coloredLine) + $displayBuffer
        if ($displayBuffer.Count -gt 10) { $displayBuffer = $displayBuffer[0..9] }

        Update-Console -statusRouterText $routerText -statusRouterColor $rStat.ColorName `
                       -statusInternetText $inetText -statusInternetColor $i1Stat.ColorName `
                       -lossPercentStr $lossPercentStr -sessionTimeStr $sessionTimeStr `
                       -outages $script:outageCount -historyLines $displayBuffer

        # --- Автообновление эталонного traceroute (раз в 5 минут) ---
        $now = Get-Date
        if (-not $script:lastBaselineTime -or ($now - $script:lastBaselineTime).TotalMinutes -ge 5) {
            $script:lastBaselineTime = $now
            Start-Job -Name "BaselineJob" -ScriptBlock {
                param($logFolder)
                $out = tracert -d -h 15 -w 1000 8.8.8.8 2>&1
                $tmpFile = Join-Path $logFolder "traceroute_tmp.txt"
                $baselineFile = Join-Path $logFolder "traceroute_baseline.txt"
                $out | Out-File -FilePath $tmpFile -Encoding UTF8

                # Простейшая оценка «качества»: считаем хопы и среднее время
                $hops = ($out | Select-String "\d+ ms").Count
                if (-not (Test-Path $baselineFile)) {
                    Move-Item $tmpFile $baselineFile -Force
                } else {
                    $oldHops = (Get-Content $baselineFile | Select-String "\d+ ms").Count
                    if ($hops -lt $oldHops) {
                        Move-Item $tmpFile $baselineFile -Force
                    } else {
                        Remove-Item $tmpFile -Force
                    }
                }
            } -ArgumentList $logFolder | Out-Null
        }


        # --- Обработка клавиш ---
        [System.Windows.Forms.Application]::DoEvents()
        $sleepRemaining = $config.interval * 1000
        while ($sleepRemaining -gt 0) {
            if ([Console]::KeyAvailable) {
                $key = [Console]::ReadKey($true)
                if ($key.Key -eq "P") {
                    break 2
                } elseif ($key.Key -eq "E") {
                    if ($global:windowVisible) {
                        $hwnd = [Console.Window]::GetConsoleWindow()
                        if ($hwnd -ne [IntPtr]::Zero) {
                            [Console.Window]::ShowWindow($hwnd, 0) | Out-Null
                            $global:windowVisible = $false
                        }
                    }
                } elseif ($key.Key -eq "Q") {
                    $continue = Show-MainMenu
                    if (-not $continue) {
                        $exitFromMenu = $true
                        break 2
                    } else {
                        Clear-Host
                        $sleepRemaining = 0
                        break
                    }
                }
            }
            Start-Sleep -Milliseconds 200
            $sleepRemaining -= 200
            [System.Windows.Forms.Application]::DoEvents()
        }
        if ($sleepRemaining -gt 0 -and $exitFromMenu) { break }
    }
}
finally {
    if ($notifyIcon) { $notifyIcon.Visible = $false }

    if ($lossActive -or $postCapture) {
        try { Write-LossEvent -StartTime $lossStartTime -PreLines $preLossLines -LossLines $lossLines -PostLines $postLossLines } catch {}
    }

    if ($script:stats.LossTime.IsRunning) { $script:stats.LossTime.Stop() }

    if ($config.sessionSummaryToLog) {
        $summary = Format-SessionSummary
        Add-Content -Path $logFile -Value "`r`n$summary`r`n" -Encoding UTF8
    }

    $currentLineCount = 0
    if (Test-Path $logFile) {
        try { $currentLineCount = (Get-Content -Path $logFile -ErrorAction Stop | Measure-Object -Line).Lines } catch {}
    }
    $sessionLines = $currentLineCount - $initialLogLineCount

    if ($sessionLines -lt $config.minSessionLinesToSave) {
        try {
            if ($initialLogLineCount -gt 0) {
                $content = Get-Content -Path $logFile -ErrorAction Stop
                $content[0..($initialLogLineCount - 1)] | Set-Content -Path $logFile -Encoding UTF8
            } else { Clear-Content -Path $logFile -ErrorAction SilentlyContinue }
            Write-Host "Короткая сессия удалена из лога." -ForegroundColor Cyan
        } catch { Write-Host "Ошибка очистки лога: $_" -ForegroundColor Red }
    } else {
        try {
            $endTime = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
            Add-Content -Path $logFile -Value "$endTime --- Завершение Проверки ---" -Encoding UTF8
        } catch { Write-Host "Ошибка записи маркера завершения: $_" -ForegroundColor Red }
    }

    try {
        $hwnd = [Console.Window]::GetConsoleWindow()
        if ($hwnd -ne [IntPtr]::Zero -and -not $global:windowVisible) {
            [Console.Window]::ShowWindow($hwnd, 5) | Out-Null
            $global:windowVisible = $true
        }
    } catch {}

    Write-Host "Мониторинг остановлен. Окно закроется через 1 секунду..." -ForegroundColor Cyan
    Start-Sleep -Seconds 1
    if ($mutex) { $mutex.ReleaseMutex() }
    [Environment]::Exit(0)
}