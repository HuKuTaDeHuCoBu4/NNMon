# UI.ps1 — интерфейс: трей, консоль, прогресс-бар

Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# Функция управления окном консоли
$winApi = Add-Type -Name Window -Namespace Console -MemberDefinition '
    [DllImport("kernel32.dll")]
    public static extern IntPtr GetConsoleWindow();
    [DllImport("user32.dll")]
    public static extern bool ShowWindow(IntPtr hWnd, int nCmdShow);
' -PassThru

# ========== ЧИСТИМ ЗАВИСШИЕ ПРОЦЕССЫ (чтобы не копились иконки) ==========
$currentPid = $pid
Get-Process -Name powershell -ErrorAction SilentlyContinue | Where-Object {
    $_.Id -ne $currentPid -and $_.MainWindowTitle -match "NNMon"
} | ForEach-Object {
    try {
        $_.Kill()
        Start-Sleep -Milliseconds 100
    } catch {}
}
# Небольшая пауза, чтобы система успела удалить иконки из трея
Start-Sleep -Milliseconds 200

# Иконка в трее
$customIconPath = Join-Path $scriptRoot "tray.ico"
if (Test-Path $customIconPath) {
    $icon = New-Object System.Drawing.Icon($customIconPath)
} else {
    $icon = [System.Drawing.Icon]::ExtractAssociatedIcon((Get-Command powershell).Source)
}

$notifyIcon = New-Object System.Windows.Forms.NotifyIcon
$notifyIcon.Icon = $icon
$notifyIcon.Text = "NNMon"
$notifyIcon.Visible = $true

$contextMenu = New-Object System.Windows.Forms.ContextMenuStrip
$toggleItem = New-Object System.Windows.Forms.ToolStripMenuItem("Показать/Скрыть окно")
$toggleItem.Add_Click({
    $hwnd = [Console.Window]::GetConsoleWindow()
    if ($hwnd -eq [IntPtr]::Zero) { return }
    if ($global:windowVisible) {
        [Console.Window]::ShowWindow($hwnd, 0) | Out-Null
        $global:windowVisible = $false
    } else {
        [Console.Window]::ShowWindow($hwnd, 5) | Out-Null
        $global:windowVisible = $true
    }
})
$exitItem = New-Object System.Windows.Forms.ToolStripMenuItem("Выход")
$exitItem.Add_Click({
    $notifyIcon.Visible = $false
    [System.Windows.Forms.Application]::Exit()
    exit
})
$contextMenu.Items.Add($toggleItem) | Out-Null
$contextMenu.Items.Add("-") | Out-Null
$contextMenu.Items.Add($exitItem) | Out-Null
$notifyIcon.ContextMenuStrip = $contextMenu

$notifyIcon.Add_Click({
    if ($_.Button -eq [System.Windows.Forms.MouseButtons]::Left) {
        $hwnd = [Console.Window]::GetConsoleWindow()
        if ($hwnd -eq [IntPtr]::Zero) { return }
        if ($global:windowVisible) {
            [Console.Window]::ShowWindow($hwnd, 0) | Out-Null
            $global:windowVisible = $false
        } else {
            [Console.Window]::ShowWindow($hwnd, 5) | Out-Null
            $global:windowVisible = $true
        }
    }
})

# На всякий случай оставим событие Exiting
Register-EngineEvent -SourceIdentifier PowerShell.Exiting -SupportEvent -Action {
    if ($notifyIcon) {
        $notifyIcon.Visible = $false
        $notifyIcon.Dispose()
    }
    [System.Windows.Forms.Application]::Exit()
} | Out-Null

$global:windowVisible = $true

# Обновление главного экрана
function Update-Console {
    param(
        [string]$statusRouterText, [string]$statusRouterColor,
        [string]$statusInternetText, [string]$statusInternetColor,
        [string]$lossPercentStr, [string]$sessionTimeStr,
        [int]$outages, [array]$historyLines
    )
    Clear-Host
    Write-Host "─────────────────────────────────────────────────────────────" -ForegroundColor DarkGray
    Write-Host " Интернет : " -NoNewline -ForegroundColor Gray
    Write-Host "● " -NoNewline -ForegroundColor $statusInternetColor
    Write-Host $statusInternetText -ForegroundColor Gray
    Write-Host " Роутер   : " -NoNewline -ForegroundColor Gray
    Write-Host "● " -NoNewline -ForegroundColor $statusRouterColor
    Write-Host $statusRouterText -ForegroundColor Gray
    Write-Host " Потери   : $lossPercentStr" -ForegroundColor Gray
    Write-Host " Время    : $sessionTimeStr" -ForegroundColor Gray
    Write-Host " Обрывов  : $outages" -ForegroundColor Gray
    Write-Host "─────────────────────────────────────────────────────────────" -ForegroundColor DarkGray
    Write-Host " [Q] Меню   [E] Свернуть   [P] Остановить" -ForegroundColor Cyan
    Write-Host ""
    foreach ($line in $historyLines) { Write-Host $line }
}

# Обновление прогресс-бара (для диагностики)
function Update-Progress {
    param($increment=1)
    $script:currentStep += $increment
    $pct = [math]::Min(100, [math]::Round($script:currentStep / $totalSteps * 100))
    $filled = [math]::Floor($pct / 4)
    $empty  = 25 - $filled
    $bar   = "#" * $filled + "-" * $empty
    $origLeft = [Console]::CursorLeft
    $origTop  = [Console]::CursorTop
    [Console]::SetCursorPosition(0, $progressBarRow)
    Write-Host "`rОбщий прогресс: [$bar] $pct%" -NoNewline
    [Console]::SetCursorPosition($origLeft, $origTop)
}