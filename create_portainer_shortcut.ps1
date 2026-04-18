# Create Portainer Desktop Shortcut
$DesktopPath = [System.Environment]::GetFolderPath('Desktop')
$ShortcutPath = Join-Path $DesktopPath 'Docker Dashboard.lnk'

$WshShell = New-Object -ComObject WScript.Shell
$Shortcut = $WshShell.CreateShortcut($ShortcutPath)

# Use Edge or Chrome in app mode for a clean desktop-app feel
$EdgePath = "C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe"
$ChromePath = "C:\Program Files\Google\Chrome\Application\chrome.exe"

if (Test-Path $EdgePath) {
    $Shortcut.TargetPath = $EdgePath
    $Shortcut.Arguments = '--app=https://localhost:9443'
    $Shortcut.IconLocation = $EdgePath + ',0'
} elseif (Test-Path $ChromePath) {
    $Shortcut.TargetPath = $ChromePath
    $Shortcut.Arguments = '--app=https://localhost:9443'
    $Shortcut.IconLocation = $ChromePath + ',0'
} else {
    $Shortcut.TargetPath = 'C:\Windows\System32\rundll32.exe'
    $Shortcut.Arguments = 'url.dll,FileProtocolHandler https://localhost:9443'
    $Shortcut.IconLocation = 'C:\Windows\System32\shell32.dll,14'
}

$Shortcut.Description = 'Docker Dashboard (Portainer)'
$Shortcut.Save()

Write-Host "Shortcut created at: $ShortcutPath"
Write-Host "Done!"
