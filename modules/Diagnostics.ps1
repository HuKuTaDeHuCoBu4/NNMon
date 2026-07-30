# Diagnostics.ps1 — мега-диагностика

function Show-MegaDiagnostics {
    Clear-Host
    Write-Host "=============================================" -ForegroundColor Cyan
    Write-Host "   МЕГА-ДИАГНОСТИКА (ПОЛНЫЙ АНАЛИЗ)" -ForegroundColor Yellow
    Write-Host "=============================================" -ForegroundColor Cyan
    Write-Host ""

    $diagLines = @()
    $diagLines += "=== Мега-диагностика от $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss') ==="

    # Инициализация переменных
    $bufferbloatWarning = $false
    $bufferbloatPossible = $false
    $beforeAvg = 0
    $duringAvg = 0
    $beforeLoss = 0
    $duringLoss = 0
    $maxPingIncrease = 0

    try {
        # Цели
        $targets = @()
        $targets += @{Name="Роутер"; IP=$config.routerIP; TCP=$false; HTTPS=$false}
        $targets += @{Name="Google DNS"; IP="8.8.8.8"; TCP=$true; HTTPS=$true; Domain="8.8.8.8"}
        $targets += @{Name="Cloudflare DNS"; IP="1.1.1.1"; TCP=$true; HTTPS=$true; Domain="1.1.1.1"}
        $targets += @{Name="Quad9 DNS"; IP="9.9.9.9"; TCP=$true; HTTPS=$false}
        $targets += @{Name="Яндекс.DNS"; IP="77.88.8.8"; TCP=$true; HTTPS=$false}
        $targets += @{Name="OpenDNS"; IP="208.67.222.222"; TCP=$true; HTTPS=$false}
        try {
            $discordIP = ([System.Net.Dns]::GetHostAddresses("discord.com") | Where-Object { $_.AddressFamily -eq 'InterNetwork' })[0].IPAddressToString
        } catch { $discordIP = "162.159.135.234" }
        $targets += @{Name="Discord"; IP=$discordIP; TCP=$true; HTTPS=$true; Domain="discord.com"}

        # Общее количество шагов для прогресс-бара
        $script:totalSteps = 50 + 5 + 5 + 10 + ($targets | Where-Object { $_.TCP }).Count + ($targets | Where-Object { $_.HTTPS }).Count + 5 + 1 + 40
        $script:currentStep = 0

        Write-Host ""
        Write-Host "Общий прогресс: [-------------------------] 0%"
        $script:progressBarRow = [Console]::CursorTop - 1

        # ----- 1. ICMP-тест -----
        Write-Host "`n[1/8] ICMP-тест (пинг каждые 200 мс, 10 секунд)..." -ForegroundColor Cyan
        $icmpResults = @{}
        foreach ($t in $targets) { $icmpResults[$t.Name] = @() }

        for ($i=0; $i -lt 50; $i++) {
            foreach ($t in $targets) {
                $p = Get-PingTime $t.IP
                $icmpResults[$t.Name] += $p
            }
            Start-Sleep -Milliseconds 200
            Update-Progress
        }

        # ----- 2. DNS-тест -----
        Write-Host "`n[2/8] DNS-тест (разрешение google.com)..." -ForegroundColor Cyan
        $dnsResults = @()
        for ($i=0; $i -lt 5; $i++) {
            $sw = [System.Diagnostics.Stopwatch]::StartNew()
            try {
                $null = Resolve-DnsName -Name google.com -Type A -NoHostsFile -ErrorAction Stop
                $sw.Stop()
                $dnsResults += [PSCustomObject]@{Time=$sw.Elapsed.TotalMilliseconds; OK=$true}
            } catch {
                $sw.Stop()
                $dnsResults += [PSCustomObject]@{Time=-1; OK=$false}
            }
            Start-Sleep -Milliseconds 300
            Update-Progress
        }

        # ----- 3. HTTP-тест google.com -----
        Write-Host "`n[3/8] HTTP-тест (HEAD-запрос к google.com)..." -ForegroundColor Cyan
        $httpResults = @()
        for ($i=0; $i -lt 5; $i++) {
            $sw = [System.Diagnostics.Stopwatch]::StartNew()
            try {
                $req = [System.Net.WebRequest]::Create("https://google.com")
                $req.Method = "HEAD"
                $req.Timeout = 3000
                $resp = $req.GetResponse()
                $resp.Close()
                $sw.Stop()
                $httpResults += [PSCustomObject]@{Time=$sw.Elapsed.TotalMilliseconds; OK=$true}
            } catch {
                $sw.Stop()
                $httpResults += [PSCustomObject]@{Time=-1; OK=$false}
            }
            Start-Sleep -Milliseconds 300
            Update-Progress
        }

        # ----- 4. UDP-тест -----
        Write-Host "`n[4/8] UDP-тест (DNS-запросы к 1.1.1.1)..." -ForegroundColor Cyan
        $udpResults = @()
        $udpTestPossible = $true
        try {
            $udpResults = Test-UDP -Count 10
        } catch {
            Write-Host "UDP-тест недоступен (не могу подключиться к 1.1.1.1:53)" -ForegroundColor Yellow
            $udpTestPossible = $false
            $script:currentStep += 10
        }

        # ----- 5. TCP-тест (блокировки) -----
        Write-Host "`n[5/8] Проверка доступности сервисов (TCP порт 443)..." -ForegroundColor Cyan
        $tcpResults = @{}
        foreach ($t in ($targets | Where-Object { $_.TCP })) {
            $tcpResults[$t.Name] = Test-TCP -IP $t.IP
            Update-Progress
        }

        # ----- 6. HTTPS-тест для избранных сервисов -----
        Write-Host "`n[6/8] HTTPS-тест (DPI-блокировки)..." -ForegroundColor Cyan
        $httpsResults = @{}
        foreach ($t in ($targets | Where-Object { $_.HTTPS })) {
            $httpsResults[$t.Name] = $false
            if ($t.Domain) {
                try {
                    $req = [System.Net.WebRequest]::Create("https://$($t.Domain)")
                    $req.Method = "HEAD"
                    $req.Timeout = 3000
                    $resp = $req.GetResponse()
                    $resp.Close()
                    $httpsResults[$t.Name] = $true
                } catch {}
            }
            Update-Progress
        }

        # ----- 7. Загрузка CPU -----
        Write-Host "`n[7/8] Загрузка ЦП..." -ForegroundColor Cyan
        $cpuSamples = @()
        for ($i=0; $i -lt 5; $i++) {
            $load = (Get-CimInstance Win32_Processor | Measure-Object -Property LoadPercentage -Average).Average
            $cpuSamples += $load
            Start-Sleep -Milliseconds 600
            Update-Progress
        }
        $avgCpu = [math]::Round(($cpuSamples | Measure-Object -Average).Average, 1)

        # ----- 8. Wi-Fi + Адаптивный буферблоат -----
        Write-Host "`n[8/8] Проверка Wi-Fi и адаптивный буферблоат..." -ForegroundColor Cyan
        $wifiInfo = ""
        $wifiSignal = 100
        try {
            $wlan = netsh wlan show interfaces
            $signalLine = $wlan | Select-String "Сигнал" | Select-Object -First 1
            $rateLine   = $wlan | Select-String "Скорость приема" | Select-Object -First 1
            $errorLine  = $wlan | Select-String "Ошибки" | Select-Object -First 1
            if ($signalLine) {
                $signalStr = ($signalLine -split ':')[1].Trim().TrimEnd('%')
                if ($signalStr -match '^\d+$') { $wifiSignal = [int]$signalStr }
                $rate   = if ($rateLine) { ($rateLine -split ':')[1].Trim() } else { "неизв." }
                $errors = if ($errorLine) { ($errorLine -split ':')[1].Trim() } else { "0" }
                $wifiInfo = "Сигнал: $signalStr%, Скорость: $rate, Ошибки: $errors"
            }
        } catch { $wifiInfo = "Не удалось определить." }

        # Буферблоат
        $pingBefore = @()
        for ($i=0; $i -lt 20; $i++) {
            $p = Get-PingTime "1.1.1.1"
            $pingBefore += $p
            Start-Sleep -Milliseconds 200
            Update-Progress
        }
        $beforeAvg = ($pingBefore | Where-Object { $_ -ge 0 } | Measure-Object -Average).Average
        $beforeLoss = ($pingBefore | Where-Object { $_ -lt 0 }).Count

        $loadJob = Start-Job -ScriptBlock {
            try {
                $wc = New-Object System.Net.WebClient
                $wc.DownloadFile("https://speed.cloudflare.com/__down?bytes=1073741824", "$env:TEMP\bufferbloat_test.tmp")
            } catch {}
        }
        Start-Sleep -Milliseconds 300

        $pingDuring = @()
        for ($i=0; $i -lt 20; $i++) {
            $p = Get-PingTime "1.1.1.1"
            $pingDuring += $p
            Start-Sleep -Milliseconds 500
            Update-Progress
        }

        $loadJob | Stop-Job | Remove-Job -Force
        Remove-Item "$env:TEMP\bufferbloat_test.tmp" -ErrorAction SilentlyContinue

        $duringAvg = ($pingDuring | Where-Object { $_ -ge 0 } | Measure-Object -Average).Average
        $duringLoss = ($pingDuring | Where-Object { $_ -lt 0 }).Count

        if ($duringAvg -gt 0 -and $beforeAvg -gt 0) {
            $ratio = $duringAvg / $beforeAvg
            $maxPingIncrease = [math]::Round(($ratio - 1) * 100, 1)
            $bufferbloatPossible = $true
            # Исправлено: буферблоат только если пинг под нагрузкой > 30 мс и при этом рост >100% или есть потери
            if (($duringAvg -gt 30) -and (($maxPingIncrease -gt 100) -or ($duringLoss -gt $beforeLoss))) {
                $bufferbloatWarning = $true
            }
        }

        # --- ПРИНУДИТЕЛЬНОЕ ЗАВЕРШЕНИЕ ПРОГРЕССА ---
        $script:currentStep = $script:totalSteps
        Update-Progress -increment 0
        Write-Host ""

        # --- ВЫЧИСЛЕНИЕ МЕТРИК DNS, HTTP, UDP ДО ВЕРДИКТА ---
        $dnsErrors = ($dnsResults | Where-Object { -not $_.OK }).Count
        $dnsValid  = $dnsResults | Where-Object { $_.OK }
        $dnsAvg    = if ($dnsValid.Count -gt 0) { [math]::Round(($dnsValid | Measure-Object -Property Time -Average).Average,1) } else { "N/A" }

        $httpErrors = ($httpResults | Where-Object { -not $_.OK }).Count
        $httpValid  = $httpResults | Where-Object { $_.OK }
        $httpAvg    = if ($httpValid.Count -gt 0) { [math]::Round(($httpValid | Measure-Object -Property Time -Average).Average,1) } else { "N/A" }

        if ($udpTestPossible) {
            $udpLost = ($udpResults | Where-Object { $_.Lost }).Count
        } else {
            $udpLost = 0
        }

        # ----- АНАЛИЗ И ВЫВОД (вердикт) -----
        $problems = @()
        $possible = @()
        $excluded = @()

        $catScores = @{
            "Пинг"        = 100
            "Джиттер"     = 100
            "DNS"         = 100
            "HTTP"        = 100
            "UDP"         = 100
            "Блокировки"  = 100
            "Маршрутизация" = 100
            "Буферблоат"  = 100
            "Система"     = 100
        }

        $weights = @{
            "Пинг"        = 25
            "Джиттер"     = 20
            "DNS"         = 5
            "HTTP"        = 5
            "UDP"         = 15
            "Блокировки"  = 10
            "Маршрутизация" = 5
            "Буферблоат"  = 15
            "Система"     = 5
        }

        # Локальная сеть
        $routerLoss = ($icmpResults["Роутер"] | Where-Object { $_ -lt 0 }).Count
        if ($routerLoss -gt 0) {
            $problems += "Потери до роутера ($routerLoss из 50) – вероятная проблема дома."
            $catScores["Пинг"] -= 30
        } else {
            $excluded += "Локальная сеть без потерь"
        }

        # Внешние ICMP-потери
        $externalLoss = $false
        foreach ($t in $targets) {
            if ($t.Name -ne "Роутер") {
                $loss = ($icmpResults[$t.Name] | Where-Object { $_ -lt 0 }).Count
                if ($loss -gt 0) {
                    $externalLoss = $true
                    break
                }
            }
        }
        if ($externalLoss) {
            $problems += "Потери пакетов до интернет-серверов – возможны проблемы у провайдера."
            $catScores["Пинг"] -= 25
        }

        # Джиттер
        $highJitter = $false
        $maxJitter = 0
        foreach ($t in $targets) {
            $valid = $icmpResults[$t.Name] | Where-Object { $_ -ge 0 }
            if ($valid) {
                $avgVal = ($valid | Measure-Object -Average).Average
                $sumSq = 0
                foreach ($v in $valid) { $sumSq += ($v - $avgVal) * ($v - $avgVal) }
                $jitter = [math]::Sqrt($sumSq / $valid.Count)
                if ($jitter -gt $maxJitter) { $maxJitter = $jitter }
                if ($jitter -gt $config.jitterThreshold) {
                    $highJitter = $true
                }
            }
        }
        if ($highJitter) {
            $possible += "Высокий джиттер (>{0} мс, макс {1} мс) – возможно, влияет на голос/игры." -f $config.jitterThreshold, [math]::Round($maxJitter,1)
            $catScores["Джиттер"] -= 30
        }

        # DNS (теперь переменные инициализированы)
        if ($dnsErrors -gt 0 -or ($dnsAvg -ne "N/A" -and $dnsAvg -gt 200)) {
            $possible += "Медленная работа DNS ({0} мс, ошибок {1}) – возможны задержки при открытии сайтов." -f $dnsAvg, $dnsErrors
            $catScores["DNS"] -= 30
        } else {
            $excluded += "DNS работает нормально"
        }

        # HTTP google
        if ($httpErrors -gt 0) {
            $possible += "HTTP-запросы к google.com не проходят ({0} из 5) – возможно, сайт недоступен." -f $httpErrors
            $catScores["HTTP"] -= 30
        } elseif ($httpAvg -ne "N/A" -and $httpAvg -gt 1000) {
            $possible += "Медленный ответ сайтов ({0} мс) – возможно, перегружен канал." -f $httpAvg
            $catScores["HTTP"] -= 15
        } else {
            $excluded += "HTTP доступен"
        }

        # UDP
        if ($udpTestPossible) {
            if ($udpLost -gt 1) {
                $possible += "Возможны проблемы с UDP (потери {0} из 10) – это может вызывать лаги в голосе/играх." -f $udpLost
                $catScores["UDP"] -= 30
            } else {
                $excluded += "UDP работает стабильно"
            }
        }

        # Блокировки (TCP/DPI)
        $blockedServices = @()
        foreach ($t in ($targets | Where-Object { $_.TCP })) {
            if (-not $tcpResults[$t.Name] -and ($icmpResults[$t.Name] | Where-Object { $_ -ge 0 }).Count -gt 0) {
                $blockedServices += $t.Name
            }
        }
        if ($blockedServices.Count -gt 0) {
            $problems += "TCP-порт 443 закрыт для: {0} – вероятна блокировка." -f ($blockedServices -join ', ')
            $catScores["Блокировки"] -= 30
        }
        $dpiBlocked = @()
        foreach ($t in ($targets | Where-Object { $_.HTTPS })) {
            if (-not $httpsResults[$t.Name] -and $tcpResults[$t.Name] -and ($icmpResults[$t.Name] | Where-Object { $_ -ge 0 }).Count -gt 0) {
                $dpiBlocked += $t.Name
            }
        }
        if ($dpiBlocked.Count -gt 0) {
            $problems += "DPI-блокировка (Роскомнадзор) для: {0} – вероятно, потребуется VPN." -f ($dpiBlocked -join ', ')
            $catScores["Блокировки"] -= 30
        } else {
            $excluded += "HTTPS доступен (DPI-блокировок не обнаружено)"
        }

        # Маршрутизация
        $traceChanged = $false
        $baselineFile = Join-Path $logFolder "traceroute_baseline.txt"
        if (Test-Path $baselineFile) {
            try {
                $currentTrace = tracert -d -h 15 -w 1000 8.8.8.8 2>&1
                $baselineTrace = Get-Content $baselineFile
                if ($currentTrace.Count -ne $baselineTrace.Count) {
                    $traceChanged = $true
                } else {
                    for ($i=0; $i -lt $currentTrace.Count; $i++) {
                        if ($currentTrace[$i] -ne $baselineTrace[$i]) {
                            $traceChanged = $true
                            break
                        }
                    }
                }
            } catch {
                $traceChanged = $false
            }
        }
        if ($traceChanged) {
            $possible += "Маршрут до 8.8.8.8 изменился – возможно, смена маршрутизации у провайдера."
            $catScores["Маршрутизация"] -= 20
        }

        # Буферблоат
        if ($bufferbloatWarning) {
            $problems += "Буферблоат: пинг возрастает при загрузке (до {0}%) – вероятно, роутер перегружен." -f $maxPingIncrease
            $catScores["Буферблоат"] -= 40
        } elseif ($bufferbloatPossible) {
            $excluded += "Буферблоат не обнаружен"
        }

        # Система
        if ($avgCpu -gt 90) {
            $possible += "Высокая загрузка процессора ({0}%) – возможно, влияет на сетевые приложения." -f $avgCpu
            $catScores["Система"] -= 20
        }
        if ($wifiSignal -lt 60) {
            $possible += "Слабый Wi-Fi сигнал ({0}%) – возможно, стоит приблизиться к роутеру." -f $wifiSignal
            $catScores["Система"] -= 20
        }

        if ($problems.Count -eq 0 -and $possible.Count -eq 0) {
            $excluded += "Сеть полностью стабильна"
        }

        # Ограничение баллов
        $keys = @($catScores.Keys)
        foreach ($cat in $keys) {
            $catScores[$cat] = [math]::Max(0, [math]::Min(100, $catScores[$cat]))
        }

        # --- ВЫВОД ВЕРДИКТА (обязательно) ---
        Write-Host "`n============== ВЕРДИКТ ==============" -ForegroundColor Cyan
        if ($problems.Count -gt 0) {
            Write-Host "`n🟥 Обнаруженные проблемы (высокая уверенность):" -ForegroundColor Red
            foreach ($issue in $problems) { Write-Host "  • $issue" -ForegroundColor Red }
        }
        if ($possible.Count -gt 0) {
            Write-Host "`n🟨 Возможные причины (средняя уверенность):" -ForegroundColor Yellow
            foreach ($issue in $possible) { Write-Host "  • $issue" -ForegroundColor Yellow }
        }
        if ($excluded.Count -gt 0) {
            Write-Host "`n🟦 Исключено (проверено и работает):" -ForegroundColor Cyan
            foreach ($issue in $excluded) { Write-Host "  • $issue" -ForegroundColor Cyan }
        }

        # Взвешенная оценка
        Write-Host "`n──────────────────────────────────────" -ForegroundColor DarkGray
        Write-Host "Оценка по категориям:" -ForegroundColor Gray
        $weightedSum = 0
        $totalWeight = 0
        foreach ($cat in ($catScores.Keys | Sort-Object)) {
            $sc = $catScores[$cat]
            $color = if ($sc -ge 80) { "Green" } elseif ($sc -ge 50) { "Yellow" } else { "Red" }
            Write-Host ("  {0,-15} {1,4}/100 (вес {2})" -f $cat, $sc, $weights[$cat]) -ForegroundColor $color
            $weightedSum += $sc * $weights[$cat]
            $totalWeight += $weights[$cat]
        }
        $avgScore = if ($totalWeight -gt 0) { [math]::Round($weightedSum / $totalWeight, 1) } else { 0 }
        $avgColor = if ($avgScore -ge 80) { "Green" } elseif ($avgScore -ge 50) { "Yellow" } else { "Red" }
        Write-Host "  ─────────────────────────" -ForegroundColor DarkGray
        Write-Host ("  Взвешенная оценка: {0}/100" -f $avgScore) -ForegroundColor $avgColor
        Write-Host "──────────────────────────────────────" -ForegroundColor DarkGray

        # Меню показа подробностей
        Write-Host ""
        Write-Host "1. Показать подробные результаты"
        Write-Host "0. Возврат в меню"
        $detailChoice = Read-Host "Ваш выбор"

        if ($detailChoice -eq "1") {
            # ----- ВЫВОД ТЕХНИЧЕСКИХ РЕЗУЛЬТАТОВ -----
            Write-Host "`n============== РЕЗУЛЬТАТЫ ==============" -ForegroundColor Cyan
            Write-Host "--- ICMP (пинг) ---" -ForegroundColor Gray
            foreach ($t in $targets) {
                $data = $icmpResults[$t.Name]
                $valid = $data | Where-Object { $_ -ge 0 }
                $lost = ($data | Where-Object { $_ -lt 0 }).Count
                $total = $data.Count
                $lossPercent = if ($total -gt 0) { [math]::Round(($lost/$total)*100,1) } else { 0 }
                $min = if ($valid) { ($valid | Measure-Object -Minimum).Minimum } else { "N/A" }
                $max = if ($valid) { ($valid | Measure-Object -Maximum).Maximum } else { "N/A" }
                $avg = if ($valid) { [math]::Round(($valid | Measure-Object -Average).Average,1) } else { "N/A" }
                $jitter = if ($valid) {
                    $avgVal = $avg
                    $sumSq = 0
                    foreach ($v in $valid) { $sumSq += ($v - $avgVal) * ($v - $avgVal) }
                    [math]::Round([math]::Sqrt($sumSq / $valid.Count), 1)
                } else { "N/A" }
                Write-Host "$($t.Name): мин/макс/сред $min/$max/$avg мс, джиттер $jitter мс, потери $lossPercent%"
            }

            Write-Host "`n--- DNS ---" -ForegroundColor Gray
            Write-Host "Разрешение google.com: среднее время $dnsAvg мс, ошибок $dnsErrors/5"
            if ($dnsAvg -ne "N/A" -and $dnsAvg -gt 200) {
                Write-Host "  ⚠ DNS-запросы выполняются медленно ($dnsAvg мс) – возможны задержки при открытии сайтов." -ForegroundColor Yellow
            } elseif ($dnsErrors -gt 0) {
                Write-Host "  ⚠ DNS-запросы завершились ошибкой – проверьте DNS-сервер." -ForegroundColor Red
            } else {
                Write-Host "  ✓ DNS работает нормально" -ForegroundColor Green
            }

            Write-Host "`n--- HTTP (HEAD) ---" -ForegroundColor Gray
            Write-Host "HEAD google.com: среднее время $httpAvg мс, ошибок $httpErrors/5"
            if ($httpErrors -gt 0) {
                Write-Host "  ⚠ Сайт google.com не отвечает на HTTP (возможна блокировка или нет интернета)." -ForegroundColor Red
            } elseif ($httpAvg -ne "N/A" -and $httpAvg -gt 1000) {
                Write-Host "  ⚠ Сайт отвечает медленно ($httpAvg мс) – возможны проблемы с каналом." -ForegroundColor Yellow
            } else {
                Write-Host "  ✓ HTTP работает нормально" -ForegroundColor Green
            }

            Write-Host "`n--- UDP (DNS) ---" -ForegroundColor Gray
            if ($udpTestPossible) {
                $udpLost = ($udpResults | Where-Object { $_.Lost }).Count
                $udpValid = $udpResults | Where-Object { -not $_.Lost }
                $udpAvg = if ($udpValid.Count -gt 0) { [math]::Round(($udpValid | Measure-Object -Property RTT -Average).Average,1) } else { "N/A" }
                Write-Host "Потери: $udpLost/10, средний RTT: $udpAvg мс"
                if ($udpLost -ge 5) {
                    Write-Host "  ⚠ Возможны проблемы с UDP (потери $udpLost/10) – это может вызывать лаги в голосе/играх." -ForegroundColor Red
                } elseif ($udpLost -gt 1) {
                    Write-Host "  ⚠ Небольшие потери UDP ($udpLost/10) – могут быть микро-лаги." -ForegroundColor Yellow
                } else {
                    Write-Host "  ✓ UDP работает стабильно" -ForegroundColor Green
                }
            } else {
                Write-Host "Тест не выполнен (1.1.1.1:53 недоступен) – проверь интернет." -ForegroundColor Red
            }

            Write-Host "`n--- Доступность сервисов (TCP 443) ---" -ForegroundColor Gray
            foreach ($t in ($targets | Where-Object { $_.TCP })) {
                $status = if ($tcpResults[$t.Name]) { "Доступен" } else { "Закрыт (возможна блокировка)" }
                Write-Host "$($t.Name): $status"
            }

            Write-Host "`n--- HTTPS (DPI-блокировки) ---" -ForegroundColor Gray
            foreach ($t in ($targets | Where-Object { $_.HTTPS })) {
                $status = if ($httpsResults[$t.Name]) { "✓ Пройден" } else { "⚠ Заблокирован (DPI)" }
                Write-Host "$($t.Name): $status"
            }

            Write-Host "`n--- Буферблоат ---" -ForegroundColor Gray
            if ($bufferbloatPossible) {
                Write-Host "Средний пинг в покое: $([math]::Round($beforeAvg,1)) мс, потери: $beforeLoss/20"
                Write-Host "Средний пинг под нагрузкой: $([math]::Round($duringAvg,1)) мс, потери: $duringLoss/20"
                if ($bufferbloatWarning) {
                    Write-Host "  ⚠ Буферблоат обнаружен! Пинг вырос на $maxPingIncrease%." -ForegroundColor Red
                } else {
                    Write-Host "  ✓ Буферблоат не обнаружен." -ForegroundColor Green
                }
            } else {
                Write-Host "Тест не выполнен (недостаточно данных)." -ForegroundColor Yellow
            }

            Write-Host "`n--- Система ---" -ForegroundColor Gray
            Write-Host "Загрузка ЦП: $avgCpu%"
            Write-Host "Wi-Fi: $wifiInfo"

            Write-Host "`n=========================================" -ForegroundColor Cyan
            Read-Host "Нажмите Enter для возврата в меню"
        }

        # Логирование (всегда, даже без показа подробностей)
        $diagLines += "Проблемы:"
        $diagLines += $problems | ForEach-Object { "- $_" }
        $diagLines += "Возможные причины:"
        $diagLines += $possible | ForEach-Object { "- $_" }
        $diagLines += "Исключено:"
        $diagLines += $excluded | ForEach-Object { "- $_" }
        $diagLines += "Оценка по категориям:"
        foreach ($cat in ($catScores.Keys | Sort-Object)) {
            $diagLines += "  $cat : $($catScores[$cat])/100"
        }
        $diagLines += "Взвешенная: $avgScore/100"
        $diagLines += "========================================="
        Add-Content -Path $diagnosticLog -Value $diagLines -Encoding UTF8
        Add-Content -Path $diagnosticLog -Value "" -Encoding UTF8

    } catch {
        Write-Host "`nОшибка во время диагностики: $_" -ForegroundColor Red
        Add-Content -Path $errorLog -Value "$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss') - Ошибка мега-диагностики: $_" -Encoding UTF8
    }

    if ($detailChoice -ne "1") {
        # Если не смотрели подробности, даём возможность вернуться без лишнего Enter
        Write-Host ""
        Read-Host "Нажмите Enter для возврата в меню"
    }
}