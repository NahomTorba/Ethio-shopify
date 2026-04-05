@echo off
cd /d "%~dp0"

echo ========================================
echo   Starting Ethio Shopify Backend
echo ========================================
echo.

if not exist secret_key.txt (
    echo ERROR: secret_key.txt not found!
    pause
    exit /b 1
)

set /p SECRET_KEY_BASE=<secret_key.txt

set DATABASE_URL=postgresql://postgres:alazar1234%401234@db.xgrdqkhrtuhxqntmvuxy.supabase.co:5432/postgres
set RAILS_ENV=production
set RAILS_SERVE_STATIC_FILES=true
set TELEGRAM_BOT_TOKEN=8780193190:AAEH-L6NA4nFZNklwYLsjKumKTvpIKEREFg
set RAILS_LOG_LEVEL=debug

echo Database: Supabase
echo Environment: production
echo TELEGRAM_BOT_TOKEN: Set
echo RAILS_LOG_LEVEL: debug
echo.
echo Starting Puma server...
echo.

start cmd /k "bundle exec puma -C config/puma.rb"
