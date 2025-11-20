@echo off
title SAK WhatsApp Agent
color 0B

:: Change to the directory where this script is located
cd /d "%~dp0"

:: Clear screen and start agent
cls
echo ========================================
echo   SAK WhatsApp Agent
echo ========================================
echo.
echo Starting agent...
echo.
echo If this is your first time:
echo - Browser will open for login/registration
echo - After login, return here to scan QR code
echo.
echo Keep this window open while agent is running
echo Press Ctrl+C to stop the agent
echo.
echo ========================================
echo.

:: Run the agent (keeps window open)
sak-whatsapp-agent-windows.exe

echo.
echo.
echo Agent stopped.
echo Press any key to exit...
pause >nul
