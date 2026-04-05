@echo off
cd /d "%~dp0backend"

echo ========================================
echo   Generating SECRET_KEY_BASE
echo ========================================
echo.

echo Generating key...
echo.

REM Run Ruby directly and display the key
bundle exec ruby -e "require 'securerandom'; key = SecureRandom.hex(64); puts key; File.write('secret_key.txt', key)"

echo.
echo ========================================
echo   Key saved to secret_key.txt
echo ========================================
echo.
echo Press any key to exit...
pause >nul
