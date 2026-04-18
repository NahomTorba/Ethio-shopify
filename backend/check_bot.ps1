$env:TELEGRAM_BOT_TOKEN = "8780193190:AAEH-L6NA4nFZNklwYLsjKumKTvpIKEREFg"

$token = $env:TELEGRAM_BOT_TOKEN
$url = "https://api.telegram.org/bot$token/getMe"

Write-Host "Checking bot info..."
try {
    $response = Invoke-WebRequest -Uri $url -Method Get
    Write-Host "Response: $($response.Content)"
} catch {
    Write-Host "Error: $_"
}