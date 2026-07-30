# Sound.ps1 — звуковые уведомления

function Play-Sound {
    if ($config.soundEnabled) {
        [System.Console]::Beep(800, 200)
    }
}

function Should-PlaySound {
    param($IsCritical, $IsBadPing)
    switch ($config.soundCondition) {
        "Loss"          { return $IsCritical }
        "BadPing"       { return $IsBadPing }
        "LossOrBadPing" { return $IsCritical -or $IsBadPing }
        default         { return $IsCritical }
    }
}