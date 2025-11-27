@echo off
echo ========================================
echo   Clean Start - Delete Old Sessions
echo ========================================
echo.

REM Delete old session data
if exist ".wwebjs_auth" (
    echo Deleting old WhatsApp session...
    rmdir /s /q ".wwebjs_auth"
    echo Done!
) else (
    echo No old session found.
)

if exist ".wwebjs_cache" (
    echo Deleting cache...
    rmdir /s /q ".wwebjs_cache"
    echo Done!
)

echo.
echo Starting agent with clean session...
echo.

REM Start the agent
node index.js

pause
