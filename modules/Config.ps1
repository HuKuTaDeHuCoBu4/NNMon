# Config.ps1 — централизованные настройки и пути

# Папки и файлы (автоматически относительно скрипта)
$scriptRoot   = Split-Path $PSScriptRoot -Parent   # поднимаемся на уровень выше (в корень программы)
$logFolder    = Join-Path $scriptRoot "logs"
$configFolder = Join-Path $scriptRoot "configs"

$logFile       = Join-Path $logFolder "network_log.txt"
$csvFile       = Join-Path $logFolder "network_stats.csv"
$lossFile      = Join-Path $logFolder "network_loss.txt"
$errorLog      = Join-Path $logFolder "error.log"
$diagnosticLog = Join-Path $logFolder "diagnostic_log.txt"
$configFile    = Join-Path $configFolder "config.json"
$gatewayConfigFile = Join-Path $configFolder "gateway.txt"

# Создаём папки, если их нет
foreach ($dir in @($logFolder, $configFolder)) {
    if (-not (Test-Path $dir)) {
        New-Item -ItemType Directory -Path $dir -Force | Out-Null
    }
}

# Ширина консоли (для форматирования разделителей)
$global:consoleWidth = if ([Console]::WindowWidth -gt 0) { [Console]::WindowWidth } else { 80 }

# === ГЛОБАЛЬНЫЙ КОНФИГ (единственный источник настроек) ===
$config = @{
    minSessionLinesToSave   = 1
    internetIP              = "8.8.8.8"
    internetIP2             = "1.1.1.1"
    interval                = 5
    historySize             = 10
    contextLines            = 5
    goodPingThresholdRouter = 50
    goodPingThresholdInet1  = 50
    goodPingThresholdInet2  = 50
    routerIP                = $null
    soundEnabled            = $true
    soundCondition          = "LossOrBadPing"
    sessionSummaryToLog     = $false
    jitterThreshold         = 30   # порог джиттера в мс для предупреждения
    vpnServers = @(
        @{Name="Польша"; IP="78.17.6.26"},
        @{Name="Нидерланды"; IP="138.124.67.185"},
        @{Name="Германия"; IP="139.28.241.37"},
        @{Name="Франция"; IP="86.104.74.231"}
    )
    diagnosticTargets = @(
        @{Name="Роутер"; IP=$routerIP; TCP=$false; HTTPS=$false; Domain=""},
        @{Name="Google DNS"; IP="8.8.8.8"; TCP=$true; HTTPS=$true; Domain="8.8.8.8"},
        @{Name="Cloudflare DNS"; IP="1.1.1.1"; TCP=$true; HTTPS=$true; Domain="1.1.1.1"},
        @{Name="Quad9 DNS"; IP="9.9.9.9"; TCP=$true; HTTPS=$false; Domain=""},
        @{Name="Яндекс.DNS"; IP="77.88.8.8"; TCP=$true; HTTPS=$false; Domain=""},
        @{Name="OpenDNS"; IP="208.67.222.222"; TCP=$true; HTTPS=$false; Domain=""},
        @{Name="Discord"; IP="162.159.135.234"; TCP=$true; HTTPS=$true; Domain="discord.com"}
    )
}

# Словарь известных IP-адресов (можно дополнять через меню)
$knownIPs = @{
    "8.8.8.8"           = "Google DNS"
    "8.8.4.4"           = "Google DNS (вторичный)"
    "1.1.1.1"           = "Cloudflare DNS"
    "1.0.0.1"           = "Cloudflare DNS (вторичный)"
    "9.9.9.9"           = "Quad9 DNS"
    "208.67.222.222"    = "OpenDNS"
    "77.88.8.8"         = "Яндекс.DNS"
    "77.88.8.1"         = "Яндекс.DNS (вторичный)"
    "162.159.135.234"   = "Discord"
    "78.17.6.26"        = "VPN Польша"
    "138.124.67.185"    = "VPN Нидерланды"
    "139.28.241.37"     = "VPN Германия"
    "86.104.74.231"     = "VPN Франция"
    # Добавляй свои IP сюда по мере необходимости
}

# === ФУНКЦИИ РАБОТЫ С КОНФИГОМ ===
function Load-Config {
    if (Test-Path $configFile) {
        try {
            $loaded = Get-Content -Path $configFile -ErrorAction Stop | ConvertFrom-Json
            foreach ($key in $config.Keys) {
                if ($null -ne $loaded.$key) {
                    $config[$key] = $loaded.$key
                }
            }
            # Приводим IP-адреса к строкам на всякий случай
            if ($config.routerIP)    { $config.routerIP    = $config.routerIP.ToString() }
            if ($config.internetIP)  { $config.internetIP  = $config.internetIP.ToString() }
            if ($config.internetIP2) { $config.internetIP2 = $config.internetIP2.ToString() }
        } catch {
            # Файл повреждён — останутся значения по умолчанию
        }
    }
}

function Save-Config {
    $config | ConvertTo-Json | Set-Content -Path $configFile -Encoding UTF8
}

# === ЗАГРУЗКА КОНФИГА И НАСТРОЙКА IP РОУТЕРА ===
Load-Config

# Обновляем IP роутера в диагностических целях (если он изменился)
if ($config.diagnosticTargets) {
    $routerTarget = $config.diagnosticTargets | Where-Object { $_.Name -eq "Роутер" }
    if ($routerTarget) {
        $routerTarget.IP = $config.routerIP
    }
}

if (-not $config.routerIP) {
    if (Test-Path $gatewayConfigFile) {
        $config.routerIP = (Get-Content -Path $gatewayConfigFile -First 1 -ErrorAction SilentlyContinue).Trim()
        if ($config.routerIP -notmatch "^\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}$") {
            Write-Host "Файл gateway.txt повреждён." -ForegroundColor Yellow
            $config.routerIP = $null
        }
    }
}

if (-not $config.routerIP) {
    $config.routerIP = Read-Host "Введите IP-адрес вашего роутера (например 192.168.0.1). Подсказка: посмотрите на наклейку роутера или выполните в командной строке 'ipconfig' и найдите 'Основной шлюз'"
    if (-not $config.routerIP -or $config.routerIP.Trim() -eq "") {
        $config.routerIP = "192.168.0.1"
        Write-Host "Использован стандартный адрес: $($config.routerIP)" -ForegroundColor Yellow
    }
    $config.routerIP | Out-File -FilePath $gatewayConfigFile -Encoding UTF8
    Save-Config
    # Обновим IP роутера в целях диагностики
    if ($routerTarget) { $routerTarget.IP = $config.routerIP }
}