$wslIp = (wsl -d Ubuntu-24.04 -- hostname -I).Trim().Split(' ')[0]
$Url = "http://$wslIp:9000"
$EdgePath = "C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe"
$ChromePath = "C:\Program Files\Google\Chrome\Application\chrome.exe"

if (Test-Path $EdgePath) {
    Start-Process $EdgePath -ArgumentList "--app=$Url"
} elseif (Test-Path $ChromePath) {
    Start-Process $ChromePath -ArgumentList "--app=$Url"
} else {
    Start-Process "http://$wslIp:9000"
}
