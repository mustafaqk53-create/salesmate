# ============================================================
# SAK WhatsApp AI - Client Distribution Package Creator
# Creates ready-to-distribute ZIP package for clients
# ============================================================

Write-Host ""
Write-Host "================================================================" -ForegroundColor Cyan
Write-Host "     SAK WhatsApp AI - Client Package Creator" -ForegroundColor Cyan
Write-Host "================================================================" -ForegroundColor Cyan
Write-Host ""

# Configuration
$PackageName = "SAK-WhatsApp-Agent"
# Read version from package.json
$packageJson = Get-Content "desktop-agent\package.json" -Raw | ConvertFrom-Json
$Version = "v" + $packageJson.version
$newVersion = $packageJson.version
$OutputDir = "client-distribution"
$TempDir = "$OutputDir\temp"

# Clean up old packages
Write-Host "[1/7] Cleaning old packages..." -ForegroundColor Yellow
if (Test-Path $OutputDir) {
    Remove-Item $OutputDir -Recurse -Force
}
New-Item -ItemType Directory -Force -Path $TempDir | Out-Null

# Build the EXE
Write-Host "[2/7] Building Windows executable...\" -ForegroundColor Yellow
Set-Location desktop-agent

# Install dependencies
Write-Host "      Installing dependencies..." -ForegroundColor Gray
npm install --silent --no-progress 2>&1 | Out-Null

# Install pkg if needed
$pkgInstalled = npm list -g pkg 2>$null
if ($LASTEXITCODE -ne 0) {
    Write-Host "      Installing pkg globally..." -ForegroundColor Gray
    npm install -g pkg --silent 2>&1 | Out-Null
}

# Build the executable
Write-Host "      Compiling executable..." -ForegroundColor Gray
pkg . --targets node18-win-x64 --output ..\$TempDir\sak-whatsapp-agent-windows.exe --compress GZip 2>&1 | Out-Null

Set-Location ..

Write-Host "[3/7] Copying configuration files..." -ForegroundColor Yellow

# Create .env file
$envContent = @'
# ============================================================
# SAK WhatsApp AI - Desktop Agent Configuration
# ============================================================

# STEP 1: Get your credentials from the dashboard
# Login at: http://43.205.192.171:8080 (or your custom domain)
# Go to: Settings -> Desktop Agent

# STEP 2: Copy your Tenant ID from the dashboard
TENANT_ID=your-tenant-id-here

# STEP 3: Enter your WhatsApp Business phone number
# Format: Country code + number (no + or spaces)
# Example: 971507055253 for UAE, 966XXXXXXXXX for Saudi Arabia
WHATSAPP_PHONE=

# STEP 4: API Key (OPTIONAL - leave empty if not needed)
API_KEY=

# Cloud Server URL (Usually no need to change)
CLOUD_SERVER_URL=http://43.205.192.171:8080

# Local Port (Usually no need to change)
LOCAL_PORT=3001

# ============================================================
# After filling above details, save this file and run START-AGENT.bat
# ============================================================
'@
$envContent | Out-File -FilePath "$TempDir\.env" -Encoding UTF8

# Copy START-AGENT.bat
Copy-Item "desktop-agent\START-AGENT.bat" "$TempDir\START-AGENT.bat"

# Create RESET-SESSION.bat for troubleshooting
$resetSessionContent = @'
@echo off
echo.
echo ================================================================
echo     SAK WhatsApp AI - Session Reset Tool
echo ================================================================
echo.
echo This will delete your saved WhatsApp session.
echo You will need to scan the QR code again.
echo.
echo Press Ctrl+C to cancel, or
pause

echo.
echo Deleting session folders...
if exist ".wwebjs_auth" (
    rmdir /s /q ".wwebjs_auth"
    echo   Deleted: .wwebjs_auth
)
if exist ".wwebjs_cache" (
    rmdir /s /q ".wwebjs_cache"
    echo   Deleted: .wwebjs_cache
)

echo.
echo ================================================================
echo Session reset complete!
echo Run START-AGENT.bat to generate a new QR code.
echo ================================================================
echo.
pause
'@
$resetSessionContent | Out-File -FilePath "$TempDir\RESET-SESSION.bat" -Encoding UTF8

Write-Host "[4/7] Creating user documentation..." -ForegroundColor Yellow

# Create README
$readmeContent = @'
================================================================
        SAK WhatsApp AI Desktop Agent - Setup Guide
                      Windows Edition
================================================================

Thank you for choosing SAK WhatsApp AI!

WHAT'S INCLUDED:
   * sak-whatsapp-agent-windows.exe - Main application
   * START-AGENT.bat - Easy launcher
   * RESET-SESSION.bat - Fix connection issues
   * .env - Configuration file
   * README.txt - This guide

QUICK START (5 Minutes):

STEP 1: Get Your Credentials
   1. Open your web browser
   2. Go to: http://43.205.192.171:8080
   3. Login with your credentials
   4. Go to Dashboard -> Settings -> Desktop Agent
   5. Copy your Tenant ID

STEP 2: Configure the Agent
   1. Right-click on ".env" file
   2. Select "Open with Notepad"
   3. Replace "your-tenant-id-here" with YOUR Tenant ID
   4. Enter your WhatsApp phone number (with country code)
   5. API Key is OPTIONAL - leave empty if not needed
   6. Save the file (Ctrl+S) and close Notepad

STEP 3: Start the Agent
   1. Double-click "START-AGENT.bat"
   2. A window will open with a QR code
   3. Keep this window open

STEP 4: Connect WhatsApp
   1. Open WhatsApp on your phone
   2. Tap: Menu -> Linked Devices
   3. Tap: "Link a Device"
   4. Point your phone camera at the QR code
   5. Wait for connection... Done!

YOU'RE ALL SET!
   * Your AI assistant is now live 24/7
   * It will respond to customers automatically
   * Process orders, answer questions, recommend products
   * View analytics in your web dashboard

IMPORTANT TIPS:
   * Keep the agent window open (minimize if needed)
   * Your computer must be on and connected to internet
   * The agent uses minimal resources (~50MB RAM)

SYSTEM REQUIREMENTS:
   * Windows 10 or later (64-bit)
   * Google Chrome or Microsoft Edge browser
   * Active internet connection
   * WhatsApp mobile app

TROUBLESHOOTING:

Problem: QR code doesn't appear
Solution: 
   * Run RESET-SESSION.bat first, then START-AGENT.bat
   * Check your internet connection
   * Verify Tenant ID in .env file is correct
   * Make sure you saved the .env file after editing

Problem: Agent keeps disconnecting or won't connect
Solution:
   1. Close the agent window
   2. Run RESET-SESSION.bat
   3. Run START-AGENT.bat
   4. Scan the new QR code

Problem: "Chrome not found" error
Solution:
   * Install Google Chrome: https://www.google.com/chrome/

Problem: WhatsApp won't scan QR code
Solution:
   * Ensure QR code is fully visible on screen
   * Increase screen brightness
   * Hold phone steady while scanning

Problem: Agent disconnects frequently
Solution:
   * Check your internet stability
   * Disable computer sleep mode
   * Restart the agent

NEED HELP?
   Email: support@sakwhatsapp.com
   WhatsApp: +971 50 705 5253
   Dashboard: http://43.205.192.171:8080

UPDATING THE AGENT:
   * Download the latest version from your dashboard
   * Stop the old agent (close the window)
   * Replace sak-whatsapp-agent-windows.exe with new version
   * Keep your .env file
   * Start the agent again

================================================================
SAK WhatsApp AI - 2025 | All Rights Reserved | Version $newVersion
================================================================
'@
$readmeContent | Out-File -FilePath "$TempDir\README.txt" -Encoding UTF8

Write-Host "[5/7] Creating quick start guide..." -ForegroundColor Yellow

# Create QUICK-START
$quickStartContent = @'
================================================================
QUICK START - For Users Who Don't Read Manuals
================================================================

1. Open ".env" with Notepad
2. Replace "your-tenant-id-here" and "your-api-key-here" 
   (Get these from http://13.62.57.240:8080 dashboard)
3. Save the file
4. Double-click "START-AGENT.bat"
5. Scan QR code with WhatsApp on your phone

That's it!

If you get stuck, read README.txt for detailed help.

================================================================
'@
$quickStartContent | Out-File -FilePath "$TempDir\QUICK-START.txt" -Encoding UTF8

Write-Host "[6/7] Creating installation helper..." -ForegroundColor Yellow

# Create SETUP.bat
$setupBatContent = @'
@echo off
title SAK WhatsApp Agent - First Time Setup
color 0A

echo ===============================================
echo   SAK WhatsApp AI - First Time Setup
echo ===============================================
echo.
echo This wizard will help you set up your agent.
echo.
echo Press any key to begin...
pause >nul
cls

echo ===============================================
echo   Step 1: Configuration
echo ===============================================
echo.
echo Opening configuration file...
echo.
echo Please:
echo 1. Replace 'your-tenant-id-here' with your Tenant ID
echo 2. Replace 'your-api-key-here' with your API Key
echo 3. Save the file (Ctrl+S) and close Notepad
echo.
echo (Get credentials from dashboard)
echo.
echo Press any key to open configuration file...
pause >nul

notepad .env

cls
echo ===============================================
echo   Step 2: Verify Configuration
echo ===============================================
echo.
echo Did you:
echo   - Enter your Tenant ID?
echo   - Enter your API Key?
echo   - Save the file?
echo.
set /p confirm="Type YES if you completed the configuration: "

if /i not "%confirm%"=="YES" (
    echo.
    echo Please complete the configuration first.
    echo Run SETUP.bat again when ready.
    pause
    exit
)

cls
echo ===============================================
echo   Step 3: Starting Agent
echo ===============================================
echo.
echo Starting the agent for the first time...
echo.
echo A QR code will appear shortly.
echo Scan it with WhatsApp on your phone.
echo.
echo Press any key to start...
pause >nul

START-AGENT.bat
'@
$setupBatContent | Out-File -FilePath "$TempDir\SETUP.bat" -Encoding UTF8

# Create uninstall guide
$uninstallContent = @'
================================================================
HOW TO UNINSTALL
================================================================

To uninstall SAK WhatsApp Agent:

1. Close the agent window (if running)
2. Delete the entire folder containing these files
3. That's it! No registry entries or system files.

To reinstall:
- Extract the ZIP file again
- Configure .env file
- Run START-AGENT.bat

Note: If you want to keep your WhatsApp session:
- Backup the .wwebjs_auth folder before deleting
- Copy it back after reinstalling

================================================================
'@
$uninstallContent | Out-File -FilePath "$TempDir\UNINSTALL.txt" -Encoding UTF8

# Create LICENSE
$licenseContent = @'
SAK WhatsApp AI Desktop Agent
End User License Agreement (EULA)

Copyright (C) 2025 SAK Solutions. All Rights Reserved.

This software is licensed, not sold. By using this software, you agree to:

1. PERMITTED USE
   - Use this software for business purposes only
   - Run the agent on computers you own or control
   - Connect your own WhatsApp Business account

2. RESTRICTIONS
   - Do not reverse engineer, decompile, or disassemble
   - Do not distribute, sell, or rent this software
   - Do not use for spam or illegal activities

3. SUPPORT
   - Updates and support available through dashboard
   - Technical assistance via email and WhatsApp

4. WARRANTY DISCLAIMER
   - Provided "AS IS" without warranty of any kind

5. LIMITATION OF LIABILITY
   - Maximum liability limited to fees paid

For full terms: http://13.62.57.240:8080/terms

Questions? Contact: support@sakwhatsapp.com
'@
$licenseContent | Out-File -FilePath "$TempDir\LICENSE.txt" -Encoding UTF8

# Create the ZIP package
Write-Host "[7/7] Creating distribution package..." -ForegroundColor Yellow
$ZipFileName = "$OutputDir\$PackageName-Windows-$Version.zip"
Compress-Archive -Path "$TempDir\*" -DestinationPath $ZipFileName -Force

# Cleanup
Remove-Item $TempDir -Recurse -Force

# Get file size
$fileSize = (Get-Item $ZipFileName).Length / 1MB
$fileSizeStr = "{0:N2}" -f $fileSize

# Summary
Write-Host ""
Write-Host "================================================================" -ForegroundColor Green
Write-Host "                    SUCCESS!" -ForegroundColor Green
Write-Host "================================================================" -ForegroundColor Green
Write-Host ""
Write-Host "Client package created:" -ForegroundColor Cyan
Write-Host "   Version: $Version" -ForegroundColor Yellow
Write-Host "   Location: $ZipFileName" -ForegroundColor White
Write-Host "   Size: $fileSizeStr MB" -ForegroundColor White
Write-Host ""
Write-Host "Package includes:" -ForegroundColor Cyan
Write-Host "   * sak-whatsapp-agent-windows.exe (Main application)" -ForegroundColor Gray
Write-Host "   * START-AGENT.bat (Easy launcher)" -ForegroundColor Gray
Write-Host "   * SETUP.bat (First-time setup wizard)" -ForegroundColor Gray
Write-Host "   * .env (Configuration template)" -ForegroundColor Gray
Write-Host "   * README.txt (Detailed guide)" -ForegroundColor Gray
Write-Host "   * QUICK-START.txt (Quick reference)" -ForegroundColor Gray
Write-Host "   * LICENSE.txt (Legal terms)" -ForegroundColor Gray
Write-Host "   * UNINSTALL.txt (Removal instructions)" -ForegroundColor Gray
Write-Host ""
Write-Host "Next steps:" -ForegroundColor Cyan
Write-Host "   1. Test the package by extracting and running SETUP.bat" -ForegroundColor White
Write-Host "   2. Send $ZipFileName to your clients" -ForegroundColor White
Write-Host "   3. Provide them with their Tenant ID and API Key" -ForegroundColor White
Write-Host ""
Write-Host "Press any key to exit..." -ForegroundColor Gray
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
