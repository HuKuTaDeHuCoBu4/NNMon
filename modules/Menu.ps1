# Menu.ps1 — все меню и дополнительные проверки

function Show-About {
    # На канал зайди ко мне
    $easterEggArt1 = @'
	░░░░░░░░░░░░░░░░░░▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒░░
░░░░░░░░░░░░░░░░▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒░
░░░░░░░░░░░░░░░░▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒
░░░░░░░░░░░░░░░░░░░░▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒░▒▒▒▒▒
░░░░░░░░░░░░░░░░░░░░░▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▓▓█████████████████▓▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒░▒▒▒▒▒
░░░░░░░░░░░░░░░░░░░░░▒▒▒▒▒▒▒▒▒▒▒▒▒▓▓████████████████████████████▓▓▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒
░░░░░░░░░░░░░▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▓████████████████████████████████████▓▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒
░░░░░░░▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▓▓█████████▓▓▓▓▓▓▓▓▓▓▒▒▒▒▒▓▓▓▓████████████▓▓▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▓▓▓▓
░░░░░░░▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▓█████▓▓▒▒▒▒▒▒▒▓▓▓▓▓▓▓▒▒▒▒▒▒▒▒▓▓▓▓▓▒▓▓▓██████▓▓▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒
░░░░░░░░░░░▒▒▒▒▒▒▒▒▒▒▒▒▒▒▓███▓▓▒▒▒▒▒▒▒▒▒▒▒▒▓▓▓▓▓█████▓▒▒▒▒▒▓▓▓▒▒▒▒▓▓█████▓▓▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒
░░░░▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▓██▓▒▒▒▒▒▒▒▒▒▒▒▒▒▓█▓▓▒▒▒▒▒▒▓▓▓▓██▓▓▒▒▒▒▒▒▒▒▒▓████▓▓▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒
▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▓▓▓▓▓▓▓▓▓▒▒▒▒▒▒▒▒▓▓▓▓▓▓▓███▓▓▒▒▒▒▒▒▒▒▒▒▒▓▓▓▒▒▒▒▒▒▒▒▓▓██▓▓▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒░░░
░░░░░░░░░▒▒▒▒▒▒▒▒▒▓███████▓▓▓▒▒▓▓███▓▓▓▓▓█▓▓▓▓▓▓▓▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▓██▓▒▒▒▒▒▒▒▒▒▒▒▒░░░░░░░░░░░░
░░░░░░░░░░░░▒▒▒▒▓█████████▓▓▒▓▓█████▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▒▒▒▒▒▒▒▒▒▒▒▒▒▒▓▓▓█████████▓▓▒▒▒▒▒▒▒░░░░░░░░░░░░░░
░░░░░░░░░░░░▒▒▒▓▓█████████▓▓▓▓█████▓██▓▓███▓▓▓▓▓▓▓▓▓▓▓▓▓█████████▓▓▓█████████▓▓▓▓▒▒▒▒░░░░░░░░░░░░░░░
░░░░░░░░░░░▒▒▒▒▓▓████████▓▓▓████████████▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓██▓▓▓▓▓███████████▓▓▓▓▒▒▒▒░░░░░░░░░░░░░░░
░░░░░░░░░░▒▒▒▒▒▓█████████▓▓▓████▓▓████▓▓▓▓▓▓▒▒▒▒▒▒▒▓▓▓▓███▓▓▓▓▓▓▓▓███████████▓▓▓▓▒▒▒▒▒░░░░░░▒▒▒▒▒▒▒▒
░░░░░░░░░▒▒▒▒▒▓█████████████████▓▓███▓▓▓▓▓▓▓▒▒▒▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▒▓███████████▓▓▓▒▒▒▒▒░░░░░▒▒▒▒▒▒▒▒▒▒
░░░░░░░░░░▒▒▒▒▓█████████████▓▓▓▓▓█████▓▓▓▓▓▓▓▓▒▒▒▒▒▒▒▒▒▓▓▓▓▓▓▓▓▓▒▒▓█████████▓▓▓▒▒▒▒▒▒▒░░░▒▒▒░░░░░░░░
░░░░░░░░░░░░▒▒▓█████████▓▓█▓▓▒▒▒▒▒▓███▓▓▓▓▓▓▒▒▒▒▒▒▒▒▒▒▒▒▒▒▓▓▓▓▓▒▒▒▓█████████▓▓▓▒▒▒▒▒▒▒░░░░░░░░░░░░░░
░░░░░░░░░░░░▒▒▓█████████▓▓█▓▓▒▒▒▒▒▓███▓▓▓▓▓▒▒▒▒░░░░░▒▒▒▒▒▒▒▒▓▓▓▓▓▓▓████████▓▓▓▒▒▒▒▒▒▒░░░░░░░░░░░░░░░
░░░░░░░░░░░░░▒▒▓████████▓▓███▓▒▒▒▒▓▓▓██▓▓▓▒▒▒░░░░░░▒▒▒▒▒▒▒▒▒▒▒▒▒▓▓█████████▓▓▓▒▒▒▒▒░░░░░░░░░░░░░░░░░
░░░░░░░░░░░░░░░▒▒▒▓▓▓▓▓▓▓███▓▓▓▓▓▓▓▓▓▓▓▓▓▒▒▒▒▒▒░░░▒▒▒▒▒▒▒▒▒▒▒▒▒▒▓██████████▓▓▒▒▒▒▒▒░░░░░░░░░░░░░░░░░
░░░░░░░░░░░░░░░░░░░░▒▒▒▓▓█████████▓▓▓▓▓▒▒▒▒▒▒▒▓▓▓▓▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▓████████▓▓▒▒▒▒▒▒▒░░░░░░░░░░░░░░░░░
░░░░░░░░░░░░░░░░░░░░░▒▒▒▒▓█████████▓▓▒▒▒▒▒▓▓▓▓▓▓▓▓▓▓▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▓▓▓▒▒▒▒▒▒▒▒▒░░░░░░░░░░░░░░░░░
░░░░░░░░░░░░░░░░░░░░░▒▒▒▒▓████████▓▓▓▒▒▒▒▒▓▓▓▓▓▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒░░░░░░░░░░▒▒░░░░░░░░░░░░░░░░░░░░░░░░░░
░░░░░░░░░░░░░░░░░░░░░░▒▒▒▒▒▓████▓▓▓▓▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒░░░░░░░░░░▒▒▒░░░░░░░░░░░░░░░░░░░░░░░░░░
▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▓▓▓▓▓▓▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒░░░░░░░░░░░░░▒▒░░░░░░░░░░░░░░░░░░░░░░░░░░
░░░░░░░▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒░░░░▒▒▒▒▒▒▓▓▓▓▓▓▓▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒░░░░░░░░░░░░░░░▒▒▒▒░░░░░░░░░░░░░░░░░░░░░░░░
░░░░░░░░░░░░░░░░░░░░░░░░░░░▒▒▒▒▒▓▓▓▓▓▓▓▓▓▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒░░░░░░░▒▓▓▓▒▒░░░░░▒▒░░░░░░░░░░░░░░░░░░░░░░░░
░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░▒▓▓▓█▓▓▓▓▓▓▓▓▓▓▓▓▓▓▒▒▒▒▒▒▒░░░░░░░░▒▓▓▒░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░
░░░░░░░░░░░░░░░░░░░░░░░░░░░░░▒▒▒▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▒▒▒▒▒░░░░░░░░▒▒▒▒▓▓▒▒▒▒▒▒▒▒▒▒▒░░░░░░░░░░░░░░░░░░░░░
░░░░░░░░░░░░░░░░░░░░░░░░░░░░▒▒▓▓▓▓▓▓▓▓▓▓▓▓▓▒▓▓▒▒▒▒▒▒▒░░░░░░░░░░▒█▓▒▒▒▒░░▒▒▒▒▒▒▒░░░░░░░░░░░░░░░░░░░░░
░░░░░░░░░░░░░░░░░░░░░░░░░░▒▒▒▒▓▓▓▓▓▓▓▓▓▓▓▒▒▒▒▒▒▒▒▒▒▒░░░░░░░░░░░░░▒▒▓▓▓▒░░░▒▒▒▒▒░░░░░░░░░░░░░░░░░░░░░
░░░░░░░░░░░░░░░░░░░░░░░░▒▒▒▒▓▓█████▓▓▓▓▒▒▒▒▒▒▒▒▒▒▒▒░░░░░░░░░░░░░░▒▒▒▒▒▒▒░░▒▒▒▒▒░░░░░░░░░░░░░░░░░░░░░
░░░░░░░░░░░░░░░░░░░░░░░░▒▒▒▓████████▓▓▓▓▓▒▒▒▒▒▒▒▒░░░░░░░░░░░░░░░░░░░░░░░░░░░░▒░░░░░░░░░░░░░░░░░░░░░░
░░░░░░░░░░░░░░░░░░░░░░░▒▒▒▒▓████████▓▓▓▓▓▓▒▒▒▒▒▒▒▒░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░
▒▒▒░░░░░░░░░░░░░▒▒▒▒▒▒▒▒▒▒▒▓▓▓▓▓▓▓█████▓▓▓▒▒▒▒▒▒▒▒▒▒░░░░░░░░░░░░░░░░░░░░░░░▒░░░░░░░░░░░░░░░░░░░░░░░░
▒▒▒▒░░░░░░░░░░░░░░░░▒▒▒▒▒▒▒▒▓▓▓▓▓▓██▓▓▓▓▓▓▓▓▒▒▒▒▒▒▒▒▒▒░░░░░░░░░░░░░░░░░░░░░▒░░░░░░░░░░░░░░░░░░░░░░░░
▒▒▒▒▒░░░░░░░░░░░░░░░░░░░▒▒▒▒▓▓▓▓▓▓████▓▓▒▒▒▒▒▒▒▒▒▒▒░░░░░░░░░░░░░░░░░░░░░░▒▒▒░░░░░░░░░░░░░░░░░░░░░░░░
▒▒▒▒▒░░░░░░░░░░░░░░░░░▒▒▒▒▒▓▓▓▓▓▓▓▓▓▓▓▓▓▒▒▒▒▒▒▒▒▒▒▒░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░
▒▒▒▒▒░░░░░░░░░░░░░░░░░░░░░▒▒▓▓▓▓▒▒▒░▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░▒▒▒▒▒▒▒░░▒▒░▒▒▒
░░░░░░░░░░░░░░░░░░░░░░░░░▒▒▒▓▓▓▒▒▒░░░░░░░▒▒▒▒▒▒▒▒▒░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░
▒▒▒░░░░░░░░░░░░░░▒▒▒▒▒▒▒▒▒▒▒▓▓▓▒▒▒░░░░░░░░░▒▒▒▒▒▒░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░
▒▒▒▒▒▒▒▒▒░░░░░░░░░░░░░░░░▒▒▒▓▓▓▒▒▒░░░░░░░░▒▒▒▒▒▒▒▒▒░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░▒▓▓▓▓▒▒▒▒
░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░▒░░░░░░░▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒░░░░░░░░░░▒▒▒▒▒▒▒▓▓▓▓▒░░░░░░░░░░░░░░░░░░░░░░░░░
░▒▒▒▓█▒░░░░░░▒▒▒▒▒░░░░░░░░░░░░░░░░░▒▒▒▒▒▒░░░░▒▒▒▒░░░░░░░░░░░░░░░░░░░░░░░▒▒▒▒▒▒▒░░░░░░░░░░░░░░░░░░░░░
░░░░▒▒▒▒▒▓▒▒▒▒▒▒▒▒░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░
░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒░░░░░░░░░░░▒▒▒▒▒▒▒▒▒░░░░░░░░░░░░░░░░░░░
░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░
'@

    $easterEggArt2 = @'
░░░░▒▒▒▒▒▒▒▒░░░░░░░░░░░░░░▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒
░░░░▒▒▒▒▒▒▒▒░░░░░▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒
▒▒▒▒▒▒▒▒▒▒░░░░▒▒▒▒▒▒▒▒▒▒▒░▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒
▒▒░░░░░░░░░░░░░▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒
░░░░░░░░░░░░░░░░░░░░░░░░░░▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▓▓▓▓██████▓▓▓▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒
░░░░░░░░░░░░░░░░░░░░░░░░░░▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▓███▓▒▒▒▒▒▒▒▒▓▓██▓▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒
░░░░░░░░░▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▓███▓▓▒▒▒▒▒▒▒▒▒▒▒▒▒▒▓▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒
░░░▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▓██▓▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▓▓▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒
▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▓▓▓▓▓▓▒▒▒▒▒▒▒▒▒▒▒▒▒▓▓▓▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒
▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▓▓███████████████████▓▓▒▒▒▒▓▓▓▓▓███████▓▓▓▒▒▒▒▓▓▓▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒
▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▓▓██████████████████████████████████████▓▓▒▒▓▓▓▓▓▓██▓▓▓▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒
▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▓███████████████████████████████████████████████▓▓▒▒▒▒▒▒▒▓▓▓▓▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒
▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▓████████████████████████████████████████████████████▓▓▓▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒
▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▓█████████████████████████████████████████████████████▓▓▓▓▓▓▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒
░░░░▒▒▒▒▒▒▒▒▒▓████████████████████████████████████████████████████████▓▓▓▓▓▓▓▓▓▓▓██████▓▓▒▒▒▒▒▒▒▒▒▒▒
░░░░░░▒▒▒▒▒▒▓▓██████▓▓▓▓▓▓▓▓▓▓▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▓▓▓▓▓████████████▓▓▓▓▓▓▓▓▓███████▓▓▓▓▒▒▒▒▒▒▒▒▒
░░░░░▒▒▒▒▒▒▓▓▓▓▓▓▒▓▓▓▓▓▓▓▓▓▓▓▒▒▒▒▒▒▓▓▓▓▒▒▒▒▒▒▒▒▓▓▓▓▓▓▓▓▓▓▓▒▒▒▒▒▒▒▓▓██████▓▓▓▓▓███████▓▓▓▓▓▓▒▒▒▒▒▒▒▒▒
░░░░▒▒▒▒▒▒▓█████▓▓▓▓▓▓▓▓▓▓▓██▓▓▓▓▓▓▓▓▓▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▓▓▓▓▓▓▓▓▓▒▒▒▒▓▓▓██████████████▓▓▓▓▓▓▓▓▓▒▒▒▒▒▒▒
░░░▒▒▒▒▒▓██████████▓▓▓▓▓▓██▓▓▓▓▓▓▓▓▓▓▓▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▓▓▓▓▓▓▒▒▒▒▒▒▒▒▒▓██████████████▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
░░░▒▒▒▒▓███████████▓▓▓▓▓███▓▓▓▓▓▓▓▓▓▓▓▓▒▒▒▒▒▒▒▒▒▒▒▒▓▓▓▓▓▓▓▓▓▓▓▓▓▒▒▒▓▓█████████████▓▓▓▓▓▓▓▓▓▒▒▒▓▓▓███
░░░▒▒▒▒▓███████████▓▓▓█████▓▓▓▓▓▓▓▓▓▓▓▒▒▒▒▒▒▒▒▒▒▒▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▒▒▓▓██████████████▓▓▓▓▓▓▓▓▓▒▒▒▓▓▓▒▒▒
░░░░▒▒▓████████████▓▓▓█████▓▓▓▓▓▓▓▓▓▓▓▓▒▒▒▒▒▒▒▒▒▓▓▓▓▓▓▓▓▓▒▒▒▒▒▒▒▒▒▒▓██████████████▓▓▓▓▓▓▓▒▒▒▒▒▓█████
░░░▒▒▒▓▓███████████▓▓▓█████▓▓▓▓▓▓▓▓▓▓▓▓▓▒▒▒▓▓▓▓▓▓▓▓▓▓▓▓▓▒▒▒▒▒▒▓▓▓████████████████▓▓▓▓▓▓▓▒▒▒▒▒▒▒▒▒▒▒▒
░░░▒▒▒▒▓███████████▓▓▓██████▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▒▒▒▓▓██████▓▓▓▓███████████▓▓▓▓▓▒▒▒▒▒▒▒▒▒▒▒▒▒▒
░░░░░▒▒▒▓▓██████████▓████████▓▓▓▓▓▓█████████▓▓▓▓▓▓▓▓▒▓▓▓████████▓▓▓▓▓▓███████████▓▓▓▓▓▒▒▒▒▒▒▒▒▒▒▒▒▒▒
░░░░░░░▒▒▒▓█████████████████▓▓▓▓▓▓▓▓█▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓██████▓▓▓▓▓▓▒▒▒▒▓▓██████████▓▓▓▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒
░░░░░░░░░▒▒▓████████████████▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓██▓▓▓▓▓▓▓▓▒▒▒▒▓▓██████████▓▓▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒
░░░░░░░░░░░░▒▒▓▒▒▒▒▒▒▒▒▓▓███▓▓▓▓▓▓▓▓█▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓████▓▓▓▓▓▓▓▒▒▒▒▒▒▒▓▓███████▓▓▒▒▒▒▒▒▒▒▒▒▒░░░░
░░░░░░░░░░░░░░░░░░░░░░░▒▓▓███▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▒▒▒▒▒▒▒▒▒▒▒▓▓▓▓▓▓▓▓▓▓▒▒▒▒░░░░░░░░▒▒▓█▓▒▒▒▒▒▒▒▒▒▒▒▒▒▒░░
░░░░░░░░░░░░░░░░░░░░░░░░▒▒▒▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒░░░░░░░░░▒▒▓▓▓▓▒▒▒▒░░░░░░░░░░
░░░░░░░░░░░░░░░░░░░░░░░░░░▒▒▓▒▒▒▓▓▓▓▓▓▓▒▒▒▒▒▒▒▒▒░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░▒▒▒▓██▓▒▒░░░▒▒▒▒░░░░
░░░░░░░░░░░░░░░░░░░░░░░░░░░░▒▒▓▓▒▒▒▒▓▓▓▓▒▒▒▒▒▒▒░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░▒▒▒▓▓▓▓▒▒▒▒▒░░▒▒▒▒░░░░
░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒░░░░░░░░░░░░░░▒░░░░░░░░░░░░░░░░▒▓▓▓▒▒▒▒▒░░▒▒▒▒░░░░░
░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░▒▒▒▒▒▒▒▓▓█▓▓▒▒▒▒▒▒▒▒▒▒▒▒▒▒░░░░░░░░░░░░░░░░░░░░░░░░▒▒▓▓████▓▒▒▒░░░░░░░░
░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░▒▒▒▒▒▓▓████████▓▓▓▓▓▒▒▒▒▒▒▒▒▒▒▒▒▒▒░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░
░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░▒▒▒▒▒▓██████████▓▓▓▓▓▓▒▒▒▒▒▒▒▒▒▒▒▒░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░
░░░░░░░░░░░░░░░░░░░░░░░▒▒▒▒▒▒▒▒▒▒▒▒▓██████████▓▓▓▓▓▓▓▒▒▒▒▒▒▒▒▒▒▒▒░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░
░░░░░░░░░░░░░░░░░░░░▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▒▒▒▒▒▒▒▒▒▒▒▒▒░░░░░░░░░░░░░░░░░░░░░░░░░░░▒▒░░░
░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░▒▒▒▒▓▓▓▓▓▓▓▓▓██▓▓▓▓▓▓▓▓▓▓▒▒▒▒▒▒▒▒▒▒▒░░░░░░░░░░░░░░░░░░░░░░░░░▒▒▒░░░░░
░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░▒▒▒▒▒▓█▓▓▓▓▓▓▓████▓▓▓▓▒▒▒▒▒▒▒▒▒▒▒▒▒░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░
▒▒▒▒▒▒▒▒▒░░░░░░░░░░░░░░░░░░░░░░░▒▒▒▓█▓▓▓▓▒▒▒▒▒▓▓▓▓▓▒▒▒▒▒▒▒▒▒▒▒▒▒▒░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░
░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░▒▓▓▓▓▓▓▒▒▒░░░░░▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░
░░░░░░░░░░░░░░░░░░░░░▒▒▒▒▒▒▒▒▒▒▒▒▒▓▓▓▓▓▓▓▒▒▒░░░░░░░░░░▒▒▒▒▒▒▒▒▒▒░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░
▓▓▒▒▒▒▒▒▒▒▒▒░░░░░░░░░░░░░░░░░▒▒▒▒▒▓▓▓▓▓▓▓▒▒▒░░░░░░░░░░▒▒▒▒▒▒▒▒▒▒░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░
░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░▒▒▒▒▒▒▒▒▒░░░░░░░░░░▒▒▒▒▒▒▒▒▒▒▒▒▒▒░░░░░░░░░░░░░░░░░░░▒▒▒▒░░░░░░░░░░
░░░░░░░▒▒▒▓▓█▓▒▒▒▒▒▒░░░░░░░░░░░░░░░░░░░░░░░░▒▒▒▒▒▓▓▒▒▒▒▓▒▒▒▒▒▒▒▒▒▒░░░░░░░░▒▒▓▓▓▓▓▓▓▓▒▒▓▓▓▓▓▓▒▒▒▒▒▒░░
░░░░▒▒▒▒▒▒▒▓▓▒▒▒▒▒▒▒▒▒▒▒▒░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░
░░░░░░░░░░░░░░░▒▒▒▒▒░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░▒▒▒▒▒▒▒▒░░░░░░░░░░░░░░░░░░░░░░░░░▒▒▒▒▒
░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒░░░░░░░░░░░░░░░░░░░░░░░
░░░░░░░░░░░░░░░░▒▒▒▓▓▓▒▒▒▒▒▒░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░▒▒▒▒▒░░░░░░░░░░░░░░░░░░░░░░
'@

    # Подготовка: приводим арты к одинаковой высоте и ширине
    $art1Lines = $easterEggArt1 -split "`r`n|`n|`r"
    $art2Lines = $easterEggArt2 -split "`r`n|`n|`r"
    $maxHeight = [Math]::Max($art1Lines.Count, $art2Lines.Count)
    $maxWidth  = [Math]::Max(($art1Lines | ForEach-Object { $_.Length } | Measure-Object -Maximum).Maximum,
                            ($art2Lines | ForEach-Object { $_.Length } | Measure-Object -Maximum).Maximum)

    function Pad-ArtLines($lines) {
        $result = @()
        for ($i = 0; $i -lt $maxHeight; $i++) {
            if ($i -lt $lines.Count) {
                $line = $lines[$i]
            } else {
                $line = ""
            }
            $result += $line.PadRight($maxWidth)
        }
        return $result
    }

    $art1Padded = Pad-ArtLines $art1Lines
    $art2Padded = Pad-ArtLines $art2Lines

    function Draw-AboutScreen {
        Clear-Host
        Write-Host "======= О ПРОГРАММЕ =======" -ForegroundColor Cyan
        Write-Host ""
        Write-Host "NNMon"
        Write-Host "Версия: 1.0.0"
        Write-Host ""
        Write-Host "Детальный мониторинг интернет-соединения"
        Write-Host "с понятными объяснениями причин лагов."
        Write-Host ""
        Write-Host "Автор: HuKuTa_0"
        Write-Host ""
        Write-Host "[Enter] возврат в меню" -ForegroundColor DarkGray
    }

    Draw-AboutScreen

    while ($true) {
        if ([Console]::KeyAvailable) {
            $key = [Console]::ReadKey($true)
            if ($key.Key -eq "Enter") {
                return
            }
elseif ($key.Key -eq "H") {
    # Попытка показать арты полностью (с растягиванием окна) или обрезать при необходимости
    $resized = $false
    try {
        # Максимально возможные размеры окна консоли
        $maxWindowWidth  = [Console]::LargestWindowWidth
        $maxWindowHeight = [Console]::LargestWindowHeight

        # Нужные размеры для отображения всего арта
        $needWidth  = $maxWidth
        $needHeight = $maxHeight

        # Если текущее окно меньше нужного И растягивание в пределах допустимого
        if (([Console]::WindowHeight -lt $needHeight) -and ($needHeight -le $maxWindowHeight) -and
            ([Console]::WindowWidth  -lt $needWidth)  -and ($needWidth  -le $maxWindowWidth)) {

            # Запоминаем исходные размеры
            $origWidth  = [Console]::WindowWidth
            $origHeight = [Console]::WindowHeight
            $origBufferWidth  = [Console]::BufferWidth
            $origBufferHeight = [Console]::BufferHeight
            $origTop = [Console]::WindowTop

            # Сначала увеличиваем буфер, потом окно
            [Console]::BufferWidth  = $needWidth
            [Console]::BufferHeight = $needHeight
            [Console]::WindowWidth  = $needWidth
            [Console]::WindowHeight = $needHeight

            $resized = $true
            Clear-Host  # очищаем, чтобы мусор не мешал
        }

        # Выбираем, что показывать: полные арты или обрезанные
        if ($resized) {
            $art1ToShow = $art1Padded
            $art2ToShow = $art2Padded
        } else {
            # Обрезаем до текущей высоты окна
            $winHeight = [Console]::WindowHeight
            $art1ToShow = $art1Padded[0..($winHeight - 1)]
            $art2ToShow = $art2Padded[0..($winHeight - 1)]
        }

        # Плавная анимация
        do {
            [Console]::SetCursorPosition(0, 0)
            $art1ToShow | ForEach-Object { Write-Host $_ -ForegroundColor DarkGreen }
            Start-Sleep -Milliseconds 200
            if ([Console]::KeyAvailable) { $null = [Console]::ReadKey($true); break }

            [Console]::SetCursorPosition(0, 0)
            $art2ToShow | ForEach-Object { Write-Host $_ -ForegroundColor DarkGreen }
            Start-Sleep -Milliseconds 200
            if ([Console]::KeyAvailable) { $null = [Console]::ReadKey($true); break }
        } while ($true)

    } catch {
        # Если что-то пошло не так – просто проигнорируем ошибку
    } finally {
        if ($resized) {
            # Возвращаем исходный размер (сначала окно, потом буфер)
            try {
                [Console]::WindowWidth   = $origWidth
                [Console]::WindowHeight  = $origHeight
                [Console]::BufferWidth   = $origBufferWidth
                [Console]::BufferHeight  = $origBufferHeight
                [Console]::WindowTop     = $origTop
            } catch {}
        }
        # Перерисовываем «О программе»
        Draw-AboutScreen
    }
}
}
        Start-Sleep -Milliseconds 50
    }
}

function Show-MainMenu {
    while ($true) {
        Clear-Host
        Write-Host "========== МЕНЮ ==========" -ForegroundColor Cyan
        Write-Host ""
        Write-Host "1. Продолжить мониторинг"
        Write-Host "2. Статистика сессии"
        Write-Host "3. Мега-диагностика (полный анализ)"
        Write-Host "4. Дополнительная проверка"
        Write-Host "5. Настройки"
        Write-Host "6. О программе"
        Write-Host "7. Помощь"
        Write-Host "8. Выход"
        Write-Host ""
        $choice = Read-Host "Ваш выбор"
        switch ($choice) {
            "1" { Clear-Host; return $true }
            "2" { Show-SessionStats }
            "3" { Show-DiagnosticMenu }
            "4" { Show-AdvancedCheck }
            "5" { Show-Settings }
            "6" { Show-About }
            "7" { Show-Help }
            "8" {
                Clear-Host
                Write-Host "Завершение программы..." -ForegroundColor Cyan
                Start-Sleep -Milliseconds 500
                [Environment]::Exit(0)
            }
            default {
                Write-Host "Неверный ввод." -ForegroundColor Red
                Start-Sleep 1
            }
        }
    }
}

function Show-Settings {
    while ($true) {
        Clear-Host
        $summaryStatus = if ($config.sessionSummaryToLog) { "Вкл" } else { "Выкл" }
        Write-Host "======= НАСТРОЙКИ =======" -ForegroundColor Yellow
        Write-Host ""
        Write-Host "1. Сменить IP"
        Write-Host "2. Пороги пинга"
        Write-Host "3. Интервал проверки: $($config.interval) сек."
        Write-Host "4. Мин. строк для сохранения: $($config.minSessionLinesToSave)"
        Write-Host "5. Настройки звука"
        Write-Host "6. Управление логами"
        Write-Host "7. Запись сводки в лог: $summaryStatus"
        Write-Host "0. Назад"
        Write-Host ""
        $choice = Read-Host "Ваш выбор"
        switch ($choice) {
            "1" { Show-IPMenu }
            "2" { Show-ThresholdMenu }
            "3" {
                $newInt = Read-Host "Введите новый интервал (1-3600 секунд)"
                if ($newInt -match '^\d+$' -and [int]$newInt -ge 1 -and [int]$newInt -le 3600) {
                    $config.interval = [int]$newInt
                    Save-Config
                    Write-Host "Интервал изменён." -ForegroundColor Green
                } else { Write-Host "Введите целое число от 1 до 3600." -ForegroundColor Red }
                Start-Sleep 1
            }
            "4" {
                Clear-Host
                Write-Host "Минимальное число строк для сохранения:"
                Write-Host "1`n3`n5`n10`n25"
                $value = Read-Host "Введите значение"
                if ($value -match '^(1|3|5|10|25)$') {
                    $config.minSessionLinesToSave = [int]$value
                    Save-Config
                    Write-Host "Настройка сохранена." -ForegroundColor Green
                } else { Write-Host "Неверное значение." -ForegroundColor Red }
                Start-Sleep 1
            }
            "5" { Show-SoundSettings }
            "6" { Show-LogManager }
            "7" {
                $config.sessionSummaryToLog = -not $config.sessionSummaryToLog
                Save-Config
                Write-Host "Запись сводки в лог $(if ($config.sessionSummaryToLog) {'включена'} else {'выключена'})." -ForegroundColor Green
                Start-Sleep 1
            }
            "0" { return }
            default {
                Write-Host "Неверный ввод." -ForegroundColor Red
                Start-Sleep 1
            }
        }
    }
}

function Show-IPMenu {
    while ($true) {
        Clear-Host
        Write-Host "======= СМЕНА IP =======" -ForegroundColor Cyan
        Write-Host ""
        Write-Host "1. IP роутера          (сейчас: $($config.routerIP))"
        Write-Host "2. Первый внешний сервер (сейчас: $($config.internetIP))"
        Write-Host "3. Второй внешний сервер (сейчас: $($config.internetIP2))"
        Write-Host "4. Управление VPN-серверами"
        Write-Host "0. Назад"
        Write-Host ""
        $choice = Read-Host "Ваш выбор"
        switch ($choice) {
            "1" {
                $new = Read-Host "Введите IP роутера"
                if ($new -match "^\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}$") {
                    $config.routerIP = $new
                    $new | Out-File -FilePath $gatewayConfigFile -Encoding UTF8
                    Save-Config
                    Write-Host "IP роутера обновлён." -ForegroundColor Green
                } else { Write-Host "Неверный формат IP." -ForegroundColor Red }
                Start-Sleep 1
            }
            "2" { Show-ServerIPMenu -ServerNum 1 }
            "3" { Show-ServerIPMenu -ServerNum 2 }
            "4" { Show-VPNServerManager }
            "0" { return }
            default {
                Write-Host "Неверный ввод." -ForegroundColor Red
                Start-Sleep 1
            }
        }
    }
}

function Show-ServerIPMenu {
    param($ServerNum)
    $current = if ($ServerNum -eq 1) { $config.internetIP } else { $config.internetIP2 }
    while ($true) {
        Clear-Host
        Write-Host "=== Внешний сервер $ServerNum ===" -ForegroundColor Cyan
        Write-Host "Текущий: $current"
        Write-Host ""
        Write-Host "1. Ввести IP вручную"
        Write-Host "2. Выбрать из предложенных"
        Write-Host "0. Назад"
        Write-Host ""
        $choice = Read-Host "Ваш выбор"
        switch ($choice) {
            "1" {
                $ip = Read-Host "Введите IP"
                if ($ip -match "^\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}$") {
                    if ($ServerNum -eq 1) { $config.internetIP = $ip } else { $config.internetIP2 = $ip }
                    Save-Config
                    Write-Host "Сервер $ServerNum обновлён." -ForegroundColor Green
                } else { Write-Host "Неверный формат IP." -ForegroundColor Red }
                Start-Sleep 1
                return
            }
            "2" {
                Clear-Host
                Write-Host "Популярные DNS-серверы:" -ForegroundColor Yellow
                $dns = @(
                    @{Num="1"; IP="8.8.8.8"; Text="1. Google DNS        (8.8.8.8)"},
                    @{Num="2"; IP="8.8.4.4"; Text="2. Google DNS вторичный (8.8.4.4)"},
                    @{Num="3"; IP="1.1.1.1"; Text="3. Cloudflare        (1.1.1.1)"},
                    @{Num="4"; IP="1.0.0.1"; Text="4. Cloudflare вторичный (1.0.0.1)"},
                    @{Num="5"; IP="9.9.9.9"; Text="5. Quad9             (9.9.9.9)"},
                    @{Num="6"; IP="208.67.222.222"; Text="6. OpenDNS           (208.67.222.222)"},
                    @{Num="7"; IP="77.88.8.8"; Text="7. Яндекс.DNS        (77.88.8.8)"},
                    @{Num="8"; IP="77.88.8.1"; Text="8. Яндекс.DNS вторичный (77.88.8.1)"}
                )
                foreach ($d in $dns) { Write-Host $d.Text }
                Write-Host "0. Назад"
                $sel = Read-Host "Выберите номер"
                if ($sel -eq "0") { return }
                $chosen = $dns | Where-Object { $_.Num -eq $sel }
                if ($chosen) {
                    if ($ServerNum -eq 1) { $config.internetIP = $chosen.IP } else { $config.internetIP2 = $chosen.IP }
                    Save-Config
                    Write-Host "Сервер $ServerNum изменён на $($chosen.IP)" -ForegroundColor Green
                    Start-Sleep 1
                    return
                } else {
                    Write-Host "Неверный номер." -ForegroundColor Red
                    Start-Sleep 1
                }
            }
            "0" { return }
            default {
                Write-Host "Неверный ввод." -ForegroundColor Red
                Start-Sleep 1
            }
        }
    }
}

function Show-ThresholdMenu {
    while ($true) {
        Clear-Host
        Write-Host "===== ПОРОГИ ПИНГА =====" -ForegroundColor Cyan
        Write-Host ""
        Write-Host "1. Порог для роутера: $($config.goodPingThresholdRouter) мс"
        Write-Host "2. Порог для сервера 1: $($config.goodPingThresholdInet1) мс"
        Write-Host "3. Порог для сервера 2: $($config.goodPingThresholdInet2) мс"
        Write-Host "4. Порог джиттера: $($config.jitterThreshold) мс"
        Write-Host "0. Назад"
        Write-Host ""
        $choice = Read-Host "Ваш выбор"
        switch ($choice) {
            "1" {
                $v = Read-Host "Новый порог (мс)"
                if ($v -match '^\d+$') { $config.goodPingThresholdRouter = [int]$v; Save-Config; Write-Host "Порог обновлён." -ForegroundColor Green }
                else { Write-Host "Неверное значение." -ForegroundColor Red }
                Start-Sleep 1
            }
            "2" {
                $v = Read-Host "Новый порог (мс)"
                if ($v -match '^\d+$') { $config.goodPingThresholdInet1 = [int]$v; Save-Config; Write-Host "Порог обновлён." -ForegroundColor Green }
                else { Write-Host "Неверное значение." -ForegroundColor Red }
                Start-Sleep 1
            }
            "3" {
                $v = Read-Host "Новый порог (мс)"
                if ($v -match '^\d+$') { $config.goodPingThresholdInet2 = [int]$v; Save-Config; Write-Host "Порог обновлён." -ForegroundColor Green }
                else { Write-Host "Неверное значение." -ForegroundColor Red }
                Start-Sleep 1
            }
            "4" {
                $v = Read-Host "Новый порог джиттера (мс)"
                if ($v -match '^\d+$') { $config.jitterThreshold = [int]$v; Save-Config; Write-Host "Порог джиттера обновлён." -ForegroundColor Green }
                else { Write-Host "Неверное значение." -ForegroundColor Red }
                Start-Sleep 1
            }
            "0" { return }
            default {
                Write-Host "Неверный ввод." -ForegroundColor Red
                Start-Sleep 1
            }
        }
    }
}

function Show-Help {
    Clear-Host
    Write-Host "======= ПОМОЩЬ =======" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "NNMon — программа для проверки интернета и поиска причин лагов."
    Write-Host ""
    Write-Host "Главное окно показывает пинг до роутера и двух DNS-серверов."
    Write-Host "Цвета: зелёный — всё хорошо, жёлтый — пинг выше порога, красный — потери."
    Write-Host "Клавиши: [Q] Меню, [E] Свернуть, [P] Остановить."
    Write-Host ""
    Write-Host "В меню «Мега-диагностика» проводится полная проверка сети."
    Write-Host "После неё вы увидите вердикт с разделением на проблемы, возможные причины"
    Write-Host "и то, что проверено и работает. Оценка в баллах подскажет, насколько всё хорошо."
    Write-Host ""
    Write-Host "«Дополнительная проверка» позволяет проверить VPN-серверы, конкретный сайт"
    Write-Host "или игру, а также посмотреть, какие программы сейчас используют интернет."
    Write-Host ""
    Write-Host "Все результаты сохраняются в папке logs."
    Write-Host "Настройки — в папке configs."
    Write-Host ""
    Write-Host "Если что-то непонятно, обратитесь к автору: HuKuTa_0."
    Write-Host ""
    Read-Host "Нажмите Enter для возврата"
}

function Show-SoundSettings {
    $condNames = @{
        "Loss"          = "При потере/разрыве"
        "BadPing"       = "При плохом пинге"
        "LossOrBadPing" = "При потере или плохом пинге"
    }
    while ($true) {
        Clear-Host
        $soundStatus = if ($config.soundEnabled) { "Вкл" } else { "Выкл" }
        Write-Host "===== НАСТРОЙКИ ЗВУКА =====" -ForegroundColor Cyan
        Write-Host ""
        Write-Host "1. Звук: $soundStatus"
        Write-Host "2. Прослушать сигнал"
        Write-Host "3. Условие: $($condNames[$config.soundCondition])"
        Write-Host "0. Назад"
        Write-Host ""
        $choice = Read-Host "Ваш выбор"
        switch ($choice) {
            "1" {
                $config.soundEnabled = -not $config.soundEnabled
                Save-Config
                Write-Host "Звук $(if ($config.soundEnabled) {'включён'} else {'выключен'})." -ForegroundColor Green
                Start-Sleep 1
            }
            "2" {
                Write-Host "Прослушивание..." -ForegroundColor Yellow
                Play-Sound
                Start-Sleep 1
            }
            "3" {
                Clear-Host
                Write-Host "Когда проигрывать звук:" -ForegroundColor Yellow
                Write-Host "1. $($condNames['Loss'])"
                Write-Host "2. $($condNames['BadPing'])"
                Write-Host "3. $($condNames['LossOrBadPing'])"
                Write-Host "0. Отмена"
                $sel = Read-Host "Ваш выбор"
                switch ($sel) {
                    "1" { $config.soundCondition = "Loss"; Save-Config; Write-Host "Условие изменено." -ForegroundColor Green }
                    "2" { $config.soundCondition = "BadPing"; Save-Config; Write-Host "Условие изменено." -ForegroundColor Green }
                    "3" { $config.soundCondition = "LossOrBadPing"; Save-Config; Write-Host "Условие изменено." -ForegroundColor Green }
                    "0" { }
                    default { Write-Host "Неверный ввод." -ForegroundColor Red }
                }
                Start-Sleep 1
            }
            "0" { return }
            default {
                Write-Host "Неверный ввод." -ForegroundColor Red
                Start-Sleep 1
            }
        }
    }
}

function Reset-ToFactory {
    Write-Host "ВНИМАНИЕ: Будут удалены файлы программы (логи и настройки) в папках logs и configs." -ForegroundColor Red
    Write-Host "Ваши личные файлы (документы, фото, игры) НЕ будут затронуты." -ForegroundColor Yellow
    Write-Host "Программа перезапустится с чистыми настройками." -ForegroundColor Cyan
    Write-Host ""
    Write-Host "1. Да, сбросить всё"
    Write-Host "0. Отмена"
    $confirm = Read-Host "Ваш выбор"
    if ($confirm -ne "1") {
        Write-Host "Сброс отменён." -ForegroundColor Green
        Start-Sleep 1
        return
    }

    # Очищаем папки logs и configs
    @($logFolder, $configFolder) | ForEach-Object {
        if (Test-Path $_) {
            Get-ChildItem $_ -File | Remove-Item -Force -ErrorAction SilentlyContinue
        }
    }

    # Пересоздаём папки
    foreach ($dir in @($logFolder, $configFolder)) {
        if (-not (Test-Path $dir)) {
            New-Item -ItemType Directory -Path $dir -Force | Out-Null
        }
    }

    Write-Host "Заводские настройки восстановлены. Программа будет перезапущена." -ForegroundColor Green
    Start-Sleep 2
    # Завершаем текущий процесс и запускаем новый
    $batPath = Join-Path $scriptRoot "START.bat"
    if (Test-Path $batPath) {
        Start-Process -FilePath $batPath -WindowStyle Normal
    }
    [Environment]::Exit(0)
}

function Show-LogManager {
    while ($true) {
        Clear-Host
        Write-Host "===== УПРАВЛЕНИЕ ЛОГАМИ =====" -ForegroundColor Cyan
        Write-Host ""
        Write-Host "1. Открыть папку логов"
        Write-Host "2. Удалить ВСЕ логи"
        Write-Host "3. Удаление по дате"
        Write-Host "4. Сброс к заводским настройкам"
        Write-Host "5. Подключение к гифе LE-332-1P2"
        Write-Host "0. Назад"
        Write-Host ""
        $choice = Read-Host "Ваш выбор"
        switch ($choice) {
            "1" { Invoke-Item $logFolder }
            "2" {
                Write-Host "Удалить ВСЕ логи?" -ForegroundColor Yellow
                Write-Host "1. Да"
                Write-Host "0. Отмена"
                $confirm = Read-Host "Ваш выбор"
                if ($confirm -eq "1") {
                    Get-ChildItem $logFolder -File | Remove-Item -Force
                    Write-Host "Логи удалены." -ForegroundColor Green
                } else {
                    Write-Host "Удаление отменено." -ForegroundColor Yellow
                }
                Start-Sleep 1
            }
            "3" {
                Clear-Host
                Write-Host "Поиск доступных дат в логах..." -ForegroundColor Cyan

                $dates = @()
                $pattern = "^=+ (\d{2}\.\d{2}\.\d{4}) =+$"
                foreach ($file in @($logFile, $lossFile)) {
                    if (Test-Path $file) {
                        $content = Get-Content -Path $file -Encoding UTF8
                        foreach ($line in $content) {
                            if ($line -match $pattern) {
                                $dates += $Matches[1]
                            }
                        }
                    }
                }
                $dates = $dates | Sort-Object -Unique

                if ($dates.Count -eq 0) {
                    Write-Host "Нет логов с разделителями дат." -ForegroundColor Yellow
                    Start-Sleep 1.5
                    continue
                }

                Write-Host "Доступные даты для удаления:" -ForegroundColor Cyan
                $i = 1
                $dateMenu = @{}
                foreach ($d in $dates) {
                    Write-Host "$i. $d"
                    $dateMenu[$i.ToString()] = $d
                    $i++
                }
                Write-Host "0. Назад"
                Write-Host ""
                $choice = Read-Host "Выберите номер даты"
                if ($choice -eq "0") { continue }
                if ($dateMenu.ContainsKey($choice)) {
                    $selectedDate = $dateMenu[$choice]
                    Write-Host ""
                    Write-Host "Удалить все записи за $selectedDate ?" -ForegroundColor Yellow
                    Write-Host "1. Да"
                    Write-Host "0. Отмена"
                    $confirm = Read-Host "Ваш выбор"
                    if ($confirm -eq "1") {
                        Remove-LogsByDate -DateStr $selectedDate
                    } else {
                        Write-Host "Удаление отменено." -ForegroundColor Yellow
                    }
                } else {
                    Write-Host "Неверный номер." -ForegroundColor Red
                }
                Start-Sleep 1.5
            }
            "4" {
                Reset-ToFactory
            }
            "5" { Show-Quest 
            }
            "0" { return }
            default {
                Write-Host "Неверный ввод." -ForegroundColor Red
                Start-Sleep 1
            }
        }
    }
}

function Show-VPNMenu {
    while ($true) {
        Clear-Host
        Write-Host "======= ПРОВЕРКА VPN-СЕРВЕРОВ =======" -ForegroundColor Cyan
        Write-Host ""
        Write-Host "1. Запустить проверку (без VPN)"
        Write-Host "2. Посмотреть текущие IP"
        Write-Host "3. Добавить / Удалить IP"
        Write-Host "0. Назад"
        Write-Host ""
        $choice = Read-Host "Ваш выбор"
        switch ($choice) {
            "1" { Show-VPNServerTest }
            "2" {
                Clear-Host
                if ($config.vpnServers.Count -eq 0) {
                    Write-Host "Нет сохранённых VPN-серверов." -ForegroundColor Red
                } else {
                    Write-Host "Текущие VPN-серверы:" -ForegroundColor Yellow
                    $index = 1
                    foreach ($vpn in $config.vpnServers) {
                        Write-Host "$index. $($vpn.Name) — $($vpn.IP)"
                        $index++
                    }
                }
                Write-Host ""
                Read-Host "Нажмите Enter для возврата"
            }
            "3" { Show-VPNServerManager }
            "0" { return }
            default {
                Write-Host "Неверный ввод." -ForegroundColor Red
                Start-Sleep 1
            }
        }
    }
}

function Show-VPNServerManager {
    while ($true) {
        Clear-Host
        Write-Host "===== УПРАВЛЕНИЕ VPN-СЕРВЕРАМИ =====" -ForegroundColor Cyan
        Write-Host ""
        if ($config.vpnServers.Count -eq 0) {
            Write-Host "Список пуст." -ForegroundColor Gray
        } else {
            $index = 1
            foreach ($vpn in $config.vpnServers) {
                Write-Host "$index. $($vpn.Name) — $($vpn.IP)"
                $index++
            }
        }
        Write-Host ""
        Write-Host "1. Добавить сервер"
        Write-Host "2. Удалить сервер"
        Write-Host "0. Назад"
        Write-Host ""
        $choice = Read-Host "Ваш выбор"
        switch ($choice) {
            "1" {
                $name = Read-Host "Введите название (страна/город)"
                if (-not $name) { Write-Host "Название не может быть пустым." -ForegroundColor Red; Start-Sleep 1; continue }
                $ip = Read-Host "Введите IP-адрес"
                if ($ip -notmatch "^\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}$") {
                    Write-Host "Неверный формат IP." -ForegroundColor Red
                    Start-Sleep 1
                    continue
                }
                $config.vpnServers += @{Name=$name; IP=$ip}
                Save-Config
                Write-Host "Сервер '$name' добавлен." -ForegroundColor Green
                Start-Sleep 1
            }
            "2" {
                if ($config.vpnServers.Count -eq 0) {
                    Write-Host "Нечего удалять." -ForegroundColor Yellow
                    Start-Sleep 1
                    continue
                }
                $num = Read-Host "Введите номер сервера для удаления"
                if ($num -match '^\d+$' -and [int]$num -ge 1 -and [int]$num -le $config.vpnServers.Count) {
                    $removed = $config.vpnServers[[int]$num - 1]
                    $config.vpnServers = @($config.vpnServers | Where-Object { $_ -ne $removed })
                    Save-Config
                    Write-Host "Сервер '$($removed.Name)' удалён." -ForegroundColor Green
                } else {
                    Write-Host "Неверный номер." -ForegroundColor Red
                }
                Start-Sleep 1
            }
            "0" { return }
            default {
                Write-Host "Неверный ввод." -ForegroundColor Red
                Start-Sleep 1
            }
        }
    }
}

function Resolve-IPDetails {
    param([string]$IP)
    # 0. Локальные адреса
    if ($IP -match "^(10\.|172\.(1[6-9]|2[0-9]|3[01])\.|192\.168\.)") {
        return "Локальная сеть"
    }
    # 1. Статический словарь
    if ($knownIPs.ContainsKey($IP)) {
        return $knownIPs[$IP]
    }
    # 2. Обратный DNS (PTR)
    try {
        $ptr = (Resolve-DnsName -Name $IP -Type PTR -ErrorAction SilentlyContinue -DnsOnly).NameHost
        if ($ptr) {
            $friendly = Resolve-FriendlyName -PTR $ptr
            if ($friendly) { return $friendly }
            else { return $ptr }
        }
    } catch {}
    return $null
}

function Resolve-FriendlyName {
    param([string]$PTR)
    # Известные шаблоны PTR
    switch -Regex ($PTR) {
        "1e100\.net$" { return "Google" }
        "cloudfront\.net$" { return "Amazon CloudFront" }
        "akamai\.net$" { return "Akamai CDN" }
        "steamserver\.net$" { return "Steam" }
        "discord\.com$" { return "Discord" }
        "valve\.net$" { return "Valve" }
        "ea\.com$" { return "Electronic Arts" }
        "blizzard\.com$" { return "Blizzard" }
        "amazonaws\.com$" { return "AWS" }
        default { return $null }
    }
}

function Show-IPDetails {
    param([string]$IP)
    Write-Host "`nПолучение Whois-информации..." -ForegroundColor Cyan
    try {
        $info = Invoke-RestMethod -Uri "https://ipinfo.io/$IP/json" -TimeoutSec 5
        $hasData = $false
        Write-Host "Подробная информация о $IP :" -ForegroundColor Cyan
        if ($info.org) { Write-Host "  Организация : $($info.org)" -ForegroundColor Gray; $hasData = $true }
        if ($info.country) { Write-Host "  Страна      : $($info.country)" -ForegroundColor Gray; $hasData = $true }
        if ($info.city) { Write-Host "  Город       : $($info.city)" -ForegroundColor Gray; $hasData = $true }
        if ($info.isp) { Write-Host "  Провайдер   : $($info.isp)" -ForegroundColor Gray; $hasData = $true }
        if (-not $hasData) {
            Write-Host "  Информация не найдена для этого IP." -ForegroundColor Yellow
        }
    } catch {
        Write-Host "Не удалось получить Whois-информацию." -ForegroundColor Red
    }
}

function Show-ActiveConnections {
    Clear-Host
    Write-Host "=============================================" -ForegroundColor Cyan
    Write-Host "   АКТИВНЫЕ TCP-СОЕДИНЕНИЯ (ESTABLISHED)" -ForegroundColor Yellow
    Write-Host "=============================================" -ForegroundColor Cyan
    Write-Host ""

    $connections = Get-NetTCPConnection -State Established -ErrorAction SilentlyContinue |
                   Where-Object { $_.RemoteAddress -ne "127.0.0.1" -and $_.RemoteAddress -ne "0.0.0.0" } |
                   Sort-Object RemoteAddress -Unique

    if (-not $connections) {
        Write-Host "Нет активных соединений." -ForegroundColor Gray
        Read-Host "Нажмите Enter для возврата"
        return
    }

    # Подготовка списка IP и предварительное определение локальных
    $ipList = $connections | ForEach-Object { $_.RemoteAddress }
    $resolved = @{}
    $total = $ipList.Count
    $done = 0
    $jobs = @()

    Write-Host "Определение серверов..." -NoNewline -ForegroundColor DarkGray

    foreach ($ip in $ipList) {
        # Локальные адреса
        if ($ip -match "^(10\.|172\.(1[6-9]|2[0-9]|3[01])\.|192\.168\.)") {
            $resolved[$ip] = "Локальная сеть"
            $done++
            continue
        }
        # Статический словарь
        if ($knownIPs.ContainsKey($ip)) {
            $resolved[$ip] = $knownIPs[$ip]
            $done++
            continue
        }
        # Асинхронный PTR-запрос
        $job = Start-Job -ScriptBlock {
            param($ip)
            try {
                $ptr = (Resolve-DnsName -Name $ip -Type PTR -ErrorAction Stop -DnsOnly).NameHost
                return $ptr
            } catch { return $null }
        } -ArgumentList $ip
        $jobs += @{IP=$ip; Job=$job}
    }

    # Ожидание заданий с индикатором
    while ($jobs.Count -gt 0) {
        $completed = @()
        foreach ($j in $jobs) {
            if ($j.Job.State -eq "Completed") {
                $result = $j.Job | Receive-Job
                if ($result) {
                    $friendly = Resolve-FriendlyName -PTR $result
                    $resolved[$j.IP] = if ($friendly) { $friendly } else { $result }
                } else {
                    $resolved[$j.IP] = $null
                }
                $j.Job | Remove-Job -Force
                $completed += $j
                $done++
            }
        }
        $jobs = $jobs | Where-Object { $_ -notin $completed }
        $pct = [math]::Round($done / $total * 100)
        Write-Host "`rОпределение серверов... $pct%" -NoNewline -ForegroundColor DarkGray
        Start-Sleep -Milliseconds 200
    }
    Write-Host "`rОпределение серверов... готово.   " -ForegroundColor Green
    Start-Sleep -Milliseconds 500

    # Основной цикл показа списка
    while ($true) {
        Clear-Host
        Write-Host "=============================================" -ForegroundColor Cyan
        Write-Host "   АКТИВНЫЕ TCP-СОЕДИНЕНИЯ (ESTABLISHED)" -ForegroundColor Yellow
        Write-Host "=============================================" -ForegroundColor Cyan
        Write-Host ""

        $index = 1
        $connMenu = @{}
        foreach ($ip in $ipList) {
            $desc = $resolved[$ip]
            if ($desc) {
                Write-Host "$index. $ip — $desc"
            } else {
                Write-Host "$index. $ip — Неизвестный сервер"
            }
            $connMenu[$index.ToString()] = @{IP=$ip; Known=($desc -ne $null -and $desc -ne "Локальная сеть")}
            $index++
        }
        Write-Host ""
        Write-Host "Выберите номер для действий." -ForegroundColor Cyan
        Write-Host "0. Назад"
        Write-Host ""

        $choice = Read-Host "Ваш выбор"
        if ($choice -eq "0") { return }
        if (-not $connMenu.ContainsKey($choice)) {
            Write-Host "Неверный номер." -ForegroundColor Red
            Start-Sleep 1
            continue
        }

        $selected = $connMenu[$choice]
        $selectedIP = $selected.IP
        Write-Host ""
        Write-Host "1. Проверить сейчас (пинг + TCP)"
        Write-Host "2. Добавить в цели диагностики"
        if (-not $selected.Known -and $selectedIP -notmatch "^(10\.|172\.(1[6-9]|2[0-9]|3[01])\.|192\.168\.)") {
            Write-Host "3. Подробно (Whois)"
        }
        Write-Host "0. Отмена"
        $action = Read-Host "Ваш выбор"
        switch ($action) {
            "1" {
                Write-Host "Проверка $selectedIP ..." -ForegroundColor Cyan
                $pingResults = @()
                for ($i=0; $i -lt 5; $i++) {
                    $p = Get-PingTime $selectedIP
                    $pingResults += $p
                    Start-Sleep -Milliseconds 200
                }
                $pingLost = ($pingResults | Where-Object { $_ -lt 0 }).Count
                $pingValid = $pingResults | Where-Object { $_ -ge 0 }
                $pingMin = if ($pingValid) { ($pingValid | Measure-Object -Minimum).Minimum } else { "N/A" }
                $pingMax = if ($pingValid) { ($pingValid | Measure-Object -Maximum).Maximum } else { "N/A" }
                $pingAvg = if ($pingValid) { [math]::Round(($pingValid | Measure-Object -Average).Average,1) } else { "N/A" }
                $tcpOk = Test-TCP -IP $selectedIP
                Write-Host "Пинг: мин/макс/сред $pingMin/$pingMax/$pingAvg мс, потери $pingLost/5"
                Write-Host "TCP порт 443: $(if ($tcpOk) {'Доступен'} else {'Закрыт'})"
                Read-Host "Нажмите Enter для продолжения"
            }
            "2" {
                $name = Read-Host "Введите название для цели (или Enter для IP)"
                if (-not $name) { $name = $selectedIP }
                $config.diagnosticTargets += @{
                    Name = $name
                    IP = $selectedIP
                    TCP = $true
                    HTTPS = $false
                    Domain = ""
                }
                Save-Config
                Write-Host "Цель '$name' добавлена." -ForegroundColor Green
                Start-Sleep 1
            }
            "3" {
                if (-not $selected.Known -and $selectedIP -notmatch "^(10\.|172\.(1[6-9]|2[0-9]|3[01])\.|192\.168\.)") {
                    Show-IPDetails -IP $selectedIP
                    Read-Host "Нажмите Enter для продолжения"
                }
            }
        }
    }
}

function Show-DiagnosticMenu {
    while ($true) {
        Clear-Host
        Write-Host "======= МЕГА-ДИАГНОСТИКА =======" -ForegroundColor Cyan
        Write-Host ""
        Write-Host "1. Запустить диагностику"
        Write-Host "2. Управление IP-адресами (добавить / удалить)"
        Write-Host "3. Посмотреть текущий список IP"
        Write-Host "0. Назад"
        Write-Host ""
        $choice = Read-Host "Ваш выбор"
        switch ($choice) {
            "1" { Show-MegaDiagnostics }
            "2" { Show-DiagnosticTargetManager }
            "3" { Show-DiagnosticTargetList }
            "0" { return }
            default {
                Write-Host "Неверный ввод." -ForegroundColor Red
                Start-Sleep 1
            }
        }
    }
}

function Show-DiagnosticTargetManager {
    while ($true) {
        Clear-Host
        Write-Host "===== УПРАВЛЕНИЕ ЦЕЛЯМИ ДИАГНОСТИКИ =====" -ForegroundColor Cyan
        Write-Host ""
        if ($config.diagnosticTargets.Count -eq 0) {
            Write-Host "Список пуст." -ForegroundColor Gray
        } else {
            $index = 1
            foreach ($target in $config.diagnosticTargets) {
                $tcpMark = if ($target.TCP) { "TCP" } else { "---" }
                $httpsMark = if ($target.HTTPS) { "HTTPS" } else { "---" }
                Write-Host "$index. $($target.Name) — $($target.IP) [$tcpMark/$httpsMark]"
                $index++
            }
        }
        Write-Host ""
        Write-Host "1. Добавить цель"
        Write-Host "2. Удалить цель"
        Write-Host "0. Назад"
        Write-Host ""
        $choice = Read-Host "Ваш выбор"
        switch ($choice) {
            "1" {
                $name = Read-Host "Введите название (например, Мой сервер)"
                if (-not $name) { Write-Host "Название не может быть пустым." -ForegroundColor Red; Start-Sleep 1; continue }
                $ip = Read-Host "Введите IP-адрес"
                if ($ip -notmatch "^\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}$") {
                    Write-Host "Неверный формат IP." -ForegroundColor Red
                    Start-Sleep 1
                    continue
                }
                $tcpYes = Read-Host "Проверять TCP порт 443? (1-Да, 0-Нет)"
                $tcp = ($tcpYes -eq "1")
                $https = $false
                $domain = ""
                if ($tcpYes -eq "1") {
                    $httpsYes = Read-Host "Проверять HTTPS (DPI-блокировку)? (1-Да, 0-Нет)"
                    if ($httpsYes -eq "1") {
                        $domain = Read-Host "Введите домен для HTTPS-проверки (например, myserver.com)"
                        if ($domain -notmatch "^(?!-)[A-Za-z0-9-]{1,63}(?<!-)(\.[A-Za-z0-9-]{1,63})*\.[A-Za-z]{2,}$") {
                            Write-Host "Домен выглядит некорректно, HTTPS-проверка будет отключена." -ForegroundColor Yellow
                            $https = $false
                            $domain = ""
                        } else {
                            $https = $true
                        }
                    }
                }
                $config.diagnosticTargets += @{
                    Name = $name
                    IP = $ip
                    TCP = $tcp
                    HTTPS = $https
                    Domain = $domain
                }
                Save-Config
                Write-Host "Цель '$name' добавлена." -ForegroundColor Green
                Start-Sleep 1
            }
            "2" {
                if ($config.diagnosticTargets.Count -eq 0) {
                    Write-Host "Нечего удалять." -ForegroundColor Yellow
                    Start-Sleep 1
                    continue
                }
                $num = Read-Host "Введите номер цели для удаления"
                if ($num -match '^\d+$' -and [int]$num -ge 1 -and [int]$num -le $config.diagnosticTargets.Count) {
                    $removed = $config.diagnosticTargets[[int]$num - 1]
                    $config.diagnosticTargets = @($config.diagnosticTargets | Where-Object { $_ -ne $removed })
                    Save-Config
                    Write-Host "Цель '$($removed.Name)' удалена." -ForegroundColor Green
                } else {
                    Write-Host "Неверный номер." -ForegroundColor Red
                }
                Start-Sleep 1
            }
            "0" { return }
            default {
                Write-Host "Неверный ввод." -ForegroundColor Red
                Start-Sleep 1
            }
        }
    }
}

function Show-DiagnosticTargetList {
    Clear-Host
    Write-Host "===== ТЕКУЩИЙ СПИСОК ЦЕЛЕЙ ДИАГНОСТИКИ =====" -ForegroundColor Cyan
    Write-Host ""
    if ($config.diagnosticTargets.Count -eq 0) {
        Write-Host "Список пуст." -ForegroundColor Gray
    } else {
        $index = 1
        foreach ($target in $config.diagnosticTargets) {
            $tcpMark = if ($target.TCP) { "TCP" } else { "---" }
            $httpsMark = if ($target.HTTPS) { "HTTPS ($($target.Domain))" } else { "---" }
            Write-Host "$index. $($target.Name) — $($target.IP) [$tcpMark / $httpsMark]"
            $index++
        }
    }
    Write-Host ""
    Read-Host "Нажмите Enter для возврата"
}

function Show-AdvancedCheck {
    while ($true) {
        Clear-Host
        Write-Host "=============================================" -ForegroundColor Cyan
        Write-Host "       ДОПОЛНИТЕЛЬНАЯ ПРОВЕРКА" -ForegroundColor Yellow
        Write-Host "=============================================" -ForegroundColor Cyan
        Write-Host ""
        Write-Host "1. Проверить VPN-серверы (вне туннеля)"
        Write-Host "2. Проверить конкретный сервер (игра / Discord / свой)"
        Write-Host "3. Анализ фоновых процессов (ЦП)"
        Write-Host "4. Анализ текущих соединений"
        Write-Host "0. Назад"
        Write-Host ""
        $choice = Read-Host "Ваш выбор"
        switch ($choice) {
            "1" { Show-VPNMenu }
            "2" { Show-ServerCheck }
            "3" { Show-ProcessAnalysis }
            "4" { Show-ActiveConnections }
            "0" { return }
            default {
                Write-Host "Неверный ввод." -ForegroundColor Red
                Start-Sleep 1
            }
        }
    }
}

function Show-ServerCheck {
    Clear-Host
    Write-Host "=============================================" -ForegroundColor Cyan
    Write-Host "   ПРОВЕРКА КОНКРЕТНОГО СЕРВЕРА" -ForegroundColor Yellow
    Write-Host "=============================================" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "1. Ввести IP-адрес или домен вручную"
    Write-Host "2. Выбрать из популярных игровых серверов"
    Write-Host "0. Назад"
    Write-Host ""
    $choice = Read-Host "Ваш выбор"

    $target = ""
    if ($choice -eq "1") {
        Write-Host ""
        Write-Host "Введите IP-адрес или домен сервера, который хотите проверить." -ForegroundColor Gray
        Write-Host "Примеры: discord.com, 8.8.8.8, mc.hypixel.net, myserver.com" -ForegroundColor Gray
        Write-Host ""
        Write-Host "Совет: чтобы узнать IP-адрес игрового сервера, можно:" -ForegroundColor DarkGray
        Write-Host "  - Пропинговать домен командой 'ping servername.com'" -ForegroundColor DarkGray
        Write-Host "  - Посмотреть в настройках подключения игры" -ForegroundColor DarkGray
        Write-Host "  - Спросить у администратора сервера" -ForegroundColor DarkGray
        Write-Host ""
        $target = Read-Host "Введите адрес"
    }
    elseif ($choice -eq "2") {
        Write-Host ""
        Write-Host "Популярные игровые серверы (будет проверен пинг, TCP и HTTPS):" -ForegroundColor Yellow
        Write-Host "1. Hypixel Minecraft (mc.hypixel.net)"
        Write-Host "2. Steam / Valve (steamcommunity.com)"
        Write-Host "3. Blizzard / WoW (blizzard.com)"
        Write-Host "4. Call of Duty (callofduty.com)"
        Write-Host "5. Roblox (roblox.com)"
        Write-Host "6. Discord (discord.com)"
        Write-Host "0. Отмена"
        Write-Host ""
        $game = Read-Host "Выберите номер"
        switch ($game) {
            "1" { $target = "mc.hypixel.net" }
            "2" { $target = "steamcommunity.com" }
            "3" { $target = "blizzard.com" }
            "4" { $target = "callofduty.com" }
            "5" { $target = "roblox.com" }
            "6" { $target = "discord.com" }
            "0" { return }
            default {
                Write-Host "Неверный номер." -ForegroundColor Red
                Start-Sleep 1
                return
            }
        }
    }
    else {
        return
    }

    if (-not $target) { return }

    # Разрешаем домен в IP, если введён не IP
    $ip = $target
    if ($target -notmatch "^\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}$") {
        try {
            $ip = ([System.Net.Dns]::GetHostAddresses($target) | Where-Object { $_.AddressFamily -eq 'InterNetwork' })[0].IPAddressToString
            Write-Host "Домен $target разрешён в $ip" -ForegroundColor Green
        } catch {
            Write-Host "Не удалось разрешить домен $target. Проверьте адрес." -ForegroundColor Red
            Read-Host "Нажмите Enter для возврата"
            return
        }
    }

    Write-Host ""
    Write-Host "Выполняется проверка $ip ..." -ForegroundColor Cyan

    # ICMP (пинг) – 10 пакетов
    $pingResults = @()
    for ($i=0; $i -lt 10; $i++) {
        $p = Get-PingTime $ip
        $pingResults += $p
        Start-Sleep -Milliseconds 150
    }
    $pingLost = ($pingResults | Where-Object { $_ -lt 0 }).Count
    $pingValid = $pingResults | Where-Object { $_ -ge 0 }
    $pingMin = if ($pingValid) { ($pingValid | Measure-Object -Minimum).Minimum } else { "N/A" }
    $pingMax = if ($pingValid) { ($pingValid | Measure-Object -Maximum).Maximum } else { "N/A" }
    $pingAvg = if ($pingValid) { [math]::Round(($pingValid | Measure-Object -Average).Average,1) } else { "N/A" }

    # TCP (443)
    $tcpOk = Test-TCP -IP $ip

    # HTTPS-тест (DPI)
    $httpsOk = $false
    if ($target -match "\.com$|\.net$|\.org$|\.ru$|\.co$") {   # если это домен
        try {
            $req = [System.Net.WebRequest]::Create("https://$target")
            $req.Method = "HEAD"
            $req.Timeout = 3000
            $resp = $req.GetResponse()
            $resp.Close()
            $httpsOk = $true
        } catch {}
    }

    Write-Host "`n============== РЕЗУЛЬТАТЫ ==============" -ForegroundColor Cyan
    Write-Host "ICMP-пинг: мин/макс/сред $pingMin/$pingMax/$pingAvg мс, потери $pingLost/10" -ForegroundColor Gray
    Write-Host "TCP порт 443: " -NoNewline -ForegroundColor Gray
    if ($tcpOk) {
        Write-Host "Доступен" -ForegroundColor Green
    } else {
        Write-Host "Закрыт или таймаут" -ForegroundColor Red
    }

    if ($httpsOk) {
        Write-Host "HTTPS-запрос: ✓ Пройден" -ForegroundColor Green
    } elseif ($target -match "\.com$|\.net$|\.org$|\.ru$|\.co$") {
        Write-Host "HTTPS-запрос: ⚠ Заблокирован (DPI)" -ForegroundColor Red
    }

    Write-Host ""
    if ($pingLost -le 1 -and $tcpOk -and ($httpsOk -or -not ($target -match "\.com$|\.net$|\.org$|\.ru$|\.co$"))) {
        Write-Host "Сервер доступен и отвечает. Задержка: $pingAvg мс." -ForegroundColor Green
        Write-Host "Если в игре/приложении лаги, проблема может быть в самом приложении, а не в сети." -ForegroundColor Yellow
    } elseif ($pingLost -gt 5) {
        Write-Host "Сервер не отвечает на пинг (возможна блокировка ICMP)." -ForegroundColor Red
        if (-not $tcpOk) {
            Write-Host "TCP порт 443 также закрыт. Сервер, вероятно, недоступен." -ForegroundColor Red
            Write-Host "Попробуйте использовать VPN или проверьте, не заблокирован ли IP." -ForegroundColor Yellow
        } else {
            Write-Host "Но TCP порт 443 открыт. Сервер работает, но пинг блокируется." -ForegroundColor Yellow
        }
    } elseif (-not $tcpOk) {
        Write-Host "TCP порт 443 закрыт. Приложение может не работать." -ForegroundColor Red
        Write-Host "Возможна блокировка или файрвол. Попробуйте VPN." -ForegroundColor Yellow
    } else {
        Write-Host "Небольшие потери пинга ($pingLost/10). Могут быть микро-лаги." -ForegroundColor Yellow
    }

    if (-not $httpsOk -and $target -match "\.com$|\.net$|\.org$|\.ru$|\.co$") {
        Write-Host "Сервер не отвечает на HTTPS – вероятна DPI-блокировка. Используйте VPN." -ForegroundColor Red
    }

    Write-Host "=========================================" -ForegroundColor Cyan
    Read-Host "Нажмите Enter для возврата"
}

function Show-ProcessAnalysis {
    Clear-Host
    Write-Host "=============================================" -ForegroundColor Cyan
    Write-Host "   АНАЛИЗ ФОНОВЫХ ПРОЦЕССОВ (ЦП)" -ForegroundColor Yellow
    Write-Host "=============================================" -ForegroundColor Cyan
    Write-Host ""

    $totalCpu = (Get-CimInstance Win32_Processor | Measure-Object -Property LoadPercentage -Average).Average
    Write-Host "Общая загрузка ЦП: $totalCpu%" -ForegroundColor Gray
    Write-Host ""

    Write-Host "Процессы, потребляющие больше всего ЦП:" -ForegroundColor Gray

    $procData = Get-CimInstance Win32_PerfFormattedData_PerfProc_Process | Where-Object { $_.Name -ne "_Total" -and $_.Name -notmatch "^Idle$" }

    if (-not $procData) {
        Write-Host "Не удалось получить данные процессов." -ForegroundColor Red
        Read-Host "Нажмите Enter для возврата"
        return
    }

    $top5 = $procData | Sort-Object PercentProcessorTime -Descending | Select-Object -First 5

    $index = 1
    foreach ($proc in $top5) {
        $name = $proc.Name
        $cpuPercent = [math]::Round($proc.PercentProcessorTime, 1)
        $color = if ($cpuPercent -gt 50) { "Red" } else { "Gray" }
        Write-Host "$index. $name — ЦП: $cpuPercent%" -ForegroundColor $color
        $index++
    }

    Write-Host ""
    Write-Host "Если какой-то процесс потребляет >50% ЦП, это может вызывать фризы и лаги." -ForegroundColor Yellow
    Write-Host "=========================================" -ForegroundColor Cyan
    Read-Host "Нажмите Enter для возврата"
}

# Вспомогательная функция для проверки VPN-серверов
function Show-VPNServerTest {
    Clear-Host
    Write-Host "=============================================" -ForegroundColor Cyan
    Write-Host "   ПРОВЕРКА VPN-СЕРВЕРОВ (ВНЕ ТУННЕЛЯ)" -ForegroundColor Yellow
    Write-Host "=============================================" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "Для получения реальных задержек VPN должен быть ОТКЛЮЧЕН." -ForegroundColor Yellow
    Write-Host "После теста включите его обратно." -ForegroundColor Yellow
    Write-Host ""

    if ($config.vpnServers.Count -eq 0) {
        Write-Host "Нет сохранённых VPN-серверов. Добавьте их в конфиг." -ForegroundColor Red
        Read-Host "Нажмите Enter для возврата"
        return
    }

    Read-Host "Нажмите Enter для начала проверки"
    Write-Host ""

    $results = @()
    foreach ($vpn in $config.vpnServers) {
        Write-Host "Пинг $($vpn.Name) ($($vpn.IP))..." -NoNewline
        $times = @()
        for ($i=0; $i -lt 5; $i++) {
            $p = Get-PingTime $vpn.IP
            $times += $p
            Start-Sleep -Milliseconds 300
        }
        $lost = ($times | Where-Object { $_ -lt 0 }).Count
        $valid = $times | Where-Object { $_ -ge 0 }
        $min = if ($valid) { ($valid | Measure-Object -Minimum).Minimum } else { "N/A" }
        $max = if ($valid) { ($valid | Measure-Object -Maximum).Maximum } else { "N/A" }
        $avg = if ($valid) { [math]::Round(($valid | Measure-Object -Average).Average,1) } else { "N/A" }
        Write-Host " готово" -ForegroundColor Green
        $results += @{
            Name = $vpn.Name
            IP = $vpn.IP
            Min = $min
            Max = $max
            Avg = $avg
            Lost = $lost
        }
    }

    Write-Host "`n============== РЕЗУЛЬТАТЫ ==============" -ForegroundColor Cyan
    foreach ($r in $results) {
        Write-Host ("{0} ({1}): мин/макс/сред {2}/{3}/{4} мс, потери {5}/5" -f $r.Name, $r.IP, $r.Min, $r.Max, $r.Avg, $r.Lost)
    }
    Write-Host "=========================================" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "Не забудьте включить VPN обратно!" -ForegroundColor Yellow
    Read-Host "Нажмите Enter для возврата в меню"
}