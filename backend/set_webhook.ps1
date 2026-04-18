$token = "8780193190:AAEEPxgMPvUvEUw7G8Vnk1kwVMi-9B3KNf4"
$appUrl = "https://nam-labradoritic-tawanna.ngrok-free.dev"
$webhookUrl = "$appUrl/webhooks/telegram"

Write-Host "Setting webhook to: $webhookUrl"
Write-Host "Using token: $($token.Substring(0, 20))..."

$encodedUrl = [Uri]::EscapeDataString($webhookUrl)
$url = "https://api.telegram.org/bot$token/setWebhook?url=$encodedUrl"

try {
    $response = Invoke-WebRequest -Uri $url -Method Get
    Write-Host "Response: $($response.Content)"
} catch {
    Write-Host "Error: $($_.Exception.Response.StatusCode.value__)"
    Write-Host "Error: $($_.Exception.Message)"
}