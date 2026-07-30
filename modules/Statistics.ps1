# Statistics.ps1 — статистика сессии и сводка

$script:stats = @{
    Router    = @{ Min = $null; Max = $null; Sum = 0; Count = 0; Lost = 0 }
    Internet1 = @{ Min = $null; Max = $null; Sum = 0; Count = 0; Lost = 0 }
    Internet2 = @{ Min = $null; Max = $null; Sum = 0; Count = 0; Lost = 0 }
    LossTime  = [System.Diagnostics.Stopwatch]::new()
    TotalTime = $null
}

function Update-Stats {
    param($Ping, $OK, $HostName)
    $s = $script:stats[$HostName]
    if ($OK) {
        if ($s.Min -eq $null -or $Ping -lt $s.Min) { $s.Min = $Ping }
        if ($s.Max -eq $null -or $Ping -gt $s.Max) { $s.Max = $Ping }
        $s.Sum += $Ping
        $s.Count++
    } else {
        $s.Lost++
    }
}

function Show-SessionStats {
    $totalSec = if ($script:stats.TotalTime) { $script:stats.TotalTime.Elapsed.TotalSeconds } else { 0 }
    $lossSec = $script:stats.LossTime.Elapsed.TotalSeconds
    $uptimePercent = if ($totalSec -gt 0) { [math]::Round(100 * (1 - $lossSec / $totalSec), 2) } else { 100 }

    $lines = @()
    $lines += "===== СТАТИСТИКА ТЕКУЩЕЙ СЕССИИ ====="
    $lines += "Время работы: $([TimeSpan]::FromSeconds($totalSec).ToString('hh\:mm\:ss'))"
    $lines += "Время с потерями: $([TimeSpan]::FromSeconds($lossSec).ToString('hh\:mm\:ss'))"
    $lines += "Аптайм: $uptimePercent%"
    $lines += "Обрывов: $script:outageCount"
    $lines += ""
    foreach ($hName in @("Router", "Internet1", "Internet2")) {
        $s = $script:stats[$hName]
        $ip = if ($hName -eq "Router") { $config.routerIP } elseif ($hName -eq "Internet1") { $config.internetIP } else { $config.internetIP2 }
        $min = if ($s.Min -ne $null) { "$($s.Min)ms" } else { "N/A" }
        $max = if ($s.Max -ne $null) { "$($s.Max)ms" } else { "N/A" }
        $avg = if ($s.Count -gt 0) { "$([math]::Round($s.Sum / $s.Count, 1))ms" } else { "N/A" }
        $losses = $s.Lost
        $lines += "$($hName) ($ip)"
        $lines += "  Мин/Макс/Сред: $min / $max / $avg  | Потерь: $losses"
    }

    Clear-Host
    foreach ($l in $lines) { Write-Host $l }
    Write-Host ""
    Read-Host "Нажмите Enter для возврата"
}

function Format-SessionSummary {
    $totalSec = if ($script:stats.TotalTime) { $script:stats.TotalTime.Elapsed.TotalSeconds } else { 0 }
    $lossSec = $script:stats.LossTime.Elapsed.TotalSeconds
    $uptimePercent = if ($totalSec -gt 0) { [math]::Round(100 * (1 - $lossSec / $totalSec), 2) } else { 100 }

    $text = @()
    $text += "======= СВОДКА СЕССИИ ======="
    $text += "Завершена: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')"
    $text += "Длительность: $([TimeSpan]::FromSeconds($totalSec).ToString('hh\:mm\:ss'))"
    $text += "Время с потерями: $([TimeSpan]::FromSeconds($lossSec).ToString('hh\:mm\:ss'))"
    $text += "Аптайм: $uptimePercent%"
    $text += "Обрывов: $script:outageCount"
    foreach ($hName in @("Router", "Internet1", "Internet2")) {
        $s = $script:stats[$hName]
        $ip = if ($hName -eq "Router") { $config.routerIP } elseif ($hName -eq "Internet1") { $config.internetIP } else { $config.internetIP2 }
        $min = if ($s.Min -ne $null) { "$($s.Min)ms" } else { "N/A" }
        $max = if ($s.Max -ne $null) { "$($s.Max)ms" } else { "N/A" }
        $avg = if ($s.Count -gt 0) { "$([math]::Round($s.Sum / $s.Count, 1))ms" } else { "N/A" }
        $text += "$($hName) ($ip): Min=$min Max=$max Avg=$avg Потерь=$($s.Lost)"
    }
    $text += "=============================="
    return $text -join "`r`n"
}