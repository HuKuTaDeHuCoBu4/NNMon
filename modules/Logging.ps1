# Logging.ps1 — запись и обслуживание логов

function Write-LossEvent {
    param($StartTime, $PreLines, $LossLines, $PostLines)
    $out = @()
    $out += "В $StartTime зафиксированы потери пакетов"
    if ($PreLines.Count -gt 0) {
        $out += "--- Последние $($PreLines.Count) строк до потери ---"
        $out += $PreLines
    }
    if ($LossLines.Count -gt 0) {
        $out += "--- Строки с потерями ---"
        $out += $LossLines
    }
    if ($PostLines.Count -gt 0) {
        $out += "--- Первые $($PostLines.Count) строк после восстановления ---"
        $out += $PostLines
    }
    $out += "----------"
    Add-Content -Path $logFile -Value $out -Encoding UTF8
    Add-Content -Path $logFile -Value "" -Encoding UTF8
}

function Add-DateSeparator {
    param($FilePath, $TodayInternal, $TodayFormatted)
    $needSep = $true
    if (Test-Path $FilePath) {
        $last = Get-Content -Path $FilePath -Tail 1 -ErrorAction SilentlyContinue
        if ($last -and $last.Length -ge 10) {
            $lastDate = $last.Substring(0, 10)
            $needSep = ($lastDate -ne $TodayInternal)
        }
    }
    if ($needSep) {
        # Пока используем фиксированную ширину, чтобы исключить влияние переменной
        $sep = "============================= $TodayFormatted ============================="
        Add-Content -Path $FilePath -Value $sep -Encoding UTF8
    }
}

function Remove-LogsByDate {
    param([string]$DateStr)
    if ($DateStr -notmatch "^\d{2}\.\d{2}\.\d{4}$") {
        Write-Host "Неверный формат даты. Используйте дд.мм.гггг." -ForegroundColor Red
        return $false
    }
    $targetDate = $DateStr
    $separatorPattern = "^=+ $targetDate =+$"
    $anySeparatorPattern = "^=+ \d{2}\.\d{2}\.\d{4} =+$"
    $filesToClean = @($logFile, $lossFile)

    foreach ($file in $filesToClean) {
        if (-not (Test-Path $file)) { continue }
        $lines = Get-Content -Path $file -Encoding UTF8
        $newLines = @()
        $skipBlock = $false
        $removed = 0

        foreach ($line in $lines) {
            if ($line -match $separatorPattern) {
                $skipBlock = $true
                $removed++
                continue
            }
            if ($line -match $anySeparatorPattern) {
                $skipBlock = $false
            }
            if (-not $skipBlock) {
                $newLines += $line
            } else {
                $removed++
            }
        }

        if ($removed -gt 0) {
            Start-Sleep -Milliseconds 200
            $newLines | Out-File -FilePath $file -Encoding UTF8 -Force
            Write-Host "Из файла '$file' удалено $removed строк за $targetDate." -ForegroundColor Green
        } else {
            Write-Host "В файле '$file' записей за $targetDate не найдено." -ForegroundColor Gray
        }
    }
    return $true
}

function Add-TraceRoute {
    param(
        [string]$IP,
        [string]$FilePath,
        [string]$Reason = "обрыв связи"
    )
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $header = "`n--- Трассировка до $IP ($Reason) [$timestamp] ---"
    Add-Content -Path $FilePath -Value $header -Encoding UTF8

    try {
        $trace = tracert -d -h 15 -w 1000 $IP 2>&1
        foreach ($line in $trace) {
            Add-Content -Path $FilePath -Value $line -Encoding UTF8
        }
    } catch {
        Add-Content -Path $FilePath -Value "Не удалось выполнить tracert: $_" -Encoding UTF8
    }
    Add-Content -Path $FilePath -Value "--- Конец трассировки ---" -Encoding UTF8
    Add-Content -Path $FilePath -Value "" -Encoding UTF8
}

function Check-LogIntegrity {
    # Быстрое чтение последней строки без загрузки всего файла
    function Get-LastLineFast {
        param([string]$Path)
        if (-not (Test-Path $Path)) { return $null }
        $stream = [System.IO.File]::Open($Path, [System.IO.FileMode]::Open, [System.IO.FileAccess]::Read, [System.IO.FileShare]::ReadWrite)
        try {
            $len = $stream.Length
            if ($len -eq 0) { return $null }
            # Читаем последние 512 байт (достаточно для одной строки)
            $bytesToRead = [math]::Min(512, $len)
            $buffer = New-Object byte[] $bytesToRead
            $stream.Seek(-$bytesToRead, [System.IO.SeekOrigin]::End) | Out-Null
            $stream.Read($buffer, 0, $bytesToRead) | Out-Null
            $text = [System.Text.Encoding]::UTF8.GetString($buffer)
            # Берём последнюю строку из полученного фрагмента
            $lines = $text -split "`r`n|`n|`r"
            $last = $lines[-1]
            # Если последняя строка пустая (из-за переноса), берём предыдущую
            if ($last -eq "" -and $lines.Count -ge 2) { $last = $lines[-2] }
            return $last.TrimEnd()
        } finally {
            $stream.Close()
        }
    }

    $lastLine = Get-LastLineFast -Path $logFile
    if ($lastLine -and $lastLine -notmatch "--- (Завершение|Запуск)") {
        $abendTime = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
        Add-Content -Path $logFile -Value "$abendTime --- Завершение Проверки (внезапное завершение) ---" -Encoding UTF8
        $lossLastLine = Get-LastLineFast -Path $lossFile
        if ($lossLastLine -and $lossLastLine -ne "----------") {
            Add-Content -Path $lossFile -Value "--- Потеря не завершена (внезапное завершение) ---" -Encoding UTF8
            Add-Content -Path $lossFile -Value "----------" -Encoding UTF8
        }
    }
}