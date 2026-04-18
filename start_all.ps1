# Frontend build and Rails static serving
# This serves the frontend from the Rails public folder

# Build frontend
Write-Host "Building frontend..."
cd frontend
npm run build

# Copy build to Rails public
if (Test-Path "../backend/public/frontend") {
    Remove-Item -Recurse -Force "../backend/public/frontend"
}
Copy-Item "build" -Destination "../backend/public/frontend" -Recurse

Write-Host "Frontend built and copied to backend/public/frontend"
Write-Host "Starting backend..."

# Start Rails - it will serve frontend from public/frontend
cd ../backend
. .\start.ps1