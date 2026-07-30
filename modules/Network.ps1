# Network.ps1 — функции сетевых проверок

# Классический пинг (работает без прав администратора)
function Get-PingTime {
    param([string]$IP)
    try {
        $ping = Test-Connection $IP -Count 1 -ErrorAction Stop
        return $ping.ResponseTime
    } catch {
        return -1
    }
}

# Простой UDP-тест (отправка DNS-запроса к 1.1.1.1)
function Test-UDP {
    param(
        [int]$Count = 10,
        [int]$Timeout = 2000
    )
    $dnsServer = "1.1.1.1"
    $dnsPort = 53
    $dnsQuery = [byte[]]@(0x00,0x01,0x01,0x00,0x00,0x01,0x00,0x00,0x00,0x00,0x00,0x00,
                          0x06,0x67,0x6f,0x6f,0x67,0x6c,0x65,0x03,0x63,0x6f,0x6d,0x00,
                          0x00,0x01,0x00,0x01)

    $results = @()
    $client = New-Object System.Net.Sockets.UdpClient
    try {
        $client.Connect($dnsServer, $dnsPort)
        for ($i = 0; $i -lt $Count; $i++) {
            $sw = [System.Diagnostics.Stopwatch]::StartNew()
            try {
                $client.Send($dnsQuery, $dnsQuery.Length) | Out-Null
                $remoteEp = $null
                $recv = $client.Receive([ref]$remoteEp)
                $sw.Stop()
                $results += [PSCustomObject]@{ RTT = $sw.Elapsed.TotalMilliseconds; Lost = $false }
            } catch {
                $sw.Stop()
                $results += [PSCustomObject]@{ RTT = -1; Lost = $true }
            }
            Start-Sleep -Milliseconds 200
        }
    } finally {
        $client.Close()
    }
    return $results
}

# TCP-тест (проверка доступности порта)
function Test-TCP {
    param(
        [string]$IP,
        [int]$Port = 443,
        [int]$Timeout = 2000
    )
    try {
        $client = New-Object System.Net.Sockets.TcpClient
        $async = $client.BeginConnect($IP, $Port, $null, $null)
        $wait = $async.AsyncWaitHandle.WaitOne($Timeout, $false)
        if ($client.Connected) {
            $client.Close()
            return $true
        }
        $client.Close()
        return $false
    } catch {
        return $false
    }
}

# Возвращает хеш с AnsiCode и ColorName для цветового отображения
function Get-StatusColor {
    param(
        [int]$Ping,
        [int]$Threshold,
        [bool]$OK
    )
    if (-not $OK) {
        return @{ AnsiCode = 31; ColorName = "Red" }
    } elseif ($Ping -gt $Threshold) {
        return @{ AnsiCode = 33; ColorName = "Yellow" }
    } else {
        return @{ AnsiCode = 32; ColorName = "Green" }
    }
}