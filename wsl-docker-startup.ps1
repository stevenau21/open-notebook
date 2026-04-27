# WSL Docker Startup Script
# Ensures WSL Docker is running and port forwarding is set up
# Run this as a scheduled task on login (requires admin for netsh)

$LogFile = "$PSScriptRoot\wsl-docker-startup.log"
$Timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"

function Log($msg) {
    "$Timestamp | $msg" | Out-File -Append $LogFile
    Write-Host $msg
}

Log "=== WSL Docker Startup Script ==="

# 1. Start WSL if not running
Log "Starting WSL Ubuntu..."
wsl -d Ubuntu-24.04 -- echo "WSL is running" 2>&1 | Out-Null

# 2. Ensure Docker daemon is running inside WSL
Log "Ensuring Docker daemon is running..."
$dockerStatus = wsl -d Ubuntu-24.04 -- docker info 2>&1
if ($LASTEXITCODE -ne 0) {
    Log "Docker not running, starting daemon..."
    wsl -d Ubuntu-24.04 -- sudo service docker start 2>&1 | Out-Null
    Start-Sleep -Seconds 5
} else {
    Log "Docker daemon already running."
}

# 3. Get current WSL IP
$wslIp = (wsl -d Ubuntu-24.04 -- hostname -I).Trim().Split(" ")[0]
Log "WSL IP: $wslIp"

if (-not $wslIp) {
    Log "ERROR: Could not get WSL IP. Exiting."
    exit 1
}

# 4. Set up port forwarding (remove old rules first)
$ports = @(5055, 8502, 9000, 9443, 8000, 8001, 8888, 3002)

Log "Setting up port forwarding..."
foreach ($port in $ports) {
    # Remove existing rule
    netsh interface portproxy delete v4tov4 listenport=$port listenaddress=0.0.0.0 2>&1 | Out-Null
    # Add new rule
    netsh interface portproxy add v4tov4 listenport=$port listenaddress=0.0.0.0 connectport=$port connectaddress=$wslIp 2>&1 | Out-Null
    Log "  Port $port -> $($wslIp):$port"
}

# 5. Verify
Log "Port forwarding rules:"
netsh interface portproxy show v4tov4 | Out-File -Append $LogFile

# 6. Wait for containers to be healthy
Log "Waiting for Open Notebook API to be ready..."
$maxAttempts = 30
for ($i = 1; $i -le $maxAttempts; $i++) {
    try {
        $response = Invoke-WebRequest -Uri "http://localhost:5055/health" -UseBasicParsing -TimeoutSec 2 -ErrorAction Stop
        if ($response.StatusCode -eq 200) {
            Log "Open Notebook API is healthy!"
            break
        }
    } catch {
        if ($i % 5 -eq 0) { Log "  Attempt $i/$maxAttempts..." }
        Start-Sleep -Seconds 2
    }
}

Log "=== Startup complete ==="
