@echo off
title Get Tenant Info
color 0E

echo ========================================
echo   Get Your Tenant ID and API Key
echo ========================================
echo.
echo 1. Make sure you are logged in to the dashboard
echo 2. Open this URL in your browser:
echo.
echo    http://43.205.192.171:8080/dashboard.html
echo.
echo 3. Look for "Settings" or "Desktop Agent" section
echo    to find your:
echo    - Tenant ID
echo    - API Key
echo.
echo 4. Copy those values and paste them into the .env file
echo.
echo ========================================
echo.
echo Opening notepad to edit .env file...
echo.
timeout /t 2 >nul

notepad .env

echo.
echo Done! After updating .env file, run START-AGENT.bat
echo.
pause
