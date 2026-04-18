
# Create Open Notebook Desktop Shortcut
$DesktopPath = [System.Environment]::GetFolderPath('Desktop')
$ShortcutPath = Join-Path $DesktopPath 'Open Notebook.lnk'

$WshShell = New-Object -ComObject WScript.Shell
$Shortcut = $WshShell.CreateShortcut($ShortcutPath)

# Use chrome/msedge to open the URL - this allows pinning to taskbar
# Detect which browser is available
$EdgePath = "C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe"
$ChromePath = "C:\Program Files\Google\Chrome\Application\chrome.exe"

if (Test-Path $EdgePath) {
    $Shortcut.TargetPath = $EdgePath
    $Shortcut.Arguments = '--app=http://localhost:8502'
    $Shortcut.IconLocation = $EdgePath + ',0'
} elseif (Test-Path $ChromePath) {
    $Shortcut.TargetPath = $ChromePath
    $Shortcut.Arguments = '--app=http://localhost:8502'
    $Shortcut.IconLocation = $ChromePath + ',0'
} else {
    # Fallback: use rundll32 to open in default browser
    $Shortcut.TargetPath = 'C:\Windows\System32\rundll32.exe'
    $Shortcut.Arguments = 'url.dll,FileProtocolHandler http://localhost:8502'
    $Shortcut.IconLocation = 'C:\Windows\System32\shell32.dll,14'
}

$Shortcut.Description = 'Open Notebook - AI Knowledge Base'
$Shortcut.WorkingDirectory = 'C:\Users\steve\Documents\dev\projects\open-notebook'
$Shortcut.Save()

Write-Host "Shortcut created at: $ShortcutPath"
Write-Host "Target: $($Shortcut.TargetPath)"
Write-Host "Done!"
