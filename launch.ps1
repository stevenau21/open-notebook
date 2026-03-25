# Open Notebook Launcher
# Starts the app via Docker Compose and opens the browser

$ProjectDir = Split-Path -Parent $MyInvocation.MyCommand.Path
Set-Location $ProjectDir

# Start Docker Compose services (will pull/start as needed)
docker compose up -d

# Wait for the web UI to become available
$MaxAttempts = 60
$Attempt = 0
$Ready = $false

while (-not $Ready -and $Attempt -lt $MaxAttempts) {
    $Attempt++
    try {
        $response = Invoke-WebRequest -Uri "http://localhost:8502" -UseBasicParsing -TimeoutSec 2 -ErrorAction Stop
        if ($response.StatusCode -eq 200) {
            $Ready = $true
        }
    } catch {
        Start-Sleep -Seconds 2
    }
}

# Open browser to the app
Start-Process "http://localhost:8502"
