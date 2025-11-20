# Build Desktop Agent for All Platforms
Write-Host "================================================" -ForegroundColor Green
Write-Host "  Building SAK WhatsApp AI Desktop Agent" -ForegroundColor Green
Write-Host "================================================" -ForegroundColor Green
Write-Host ""

# Create download directory
New-Item -ItemType Directory -Force -Path "public/download" | Out-Null

# Navigate to desktop-agent
Set-Location desktop-agent

# Install dependencies
Write-Host "[1/6] Installing dependencies..." -ForegroundColor Cyan
npm install --silent

# Install pkg globally if not installed
Write-Host "[2/6] Checking pkg installation..." -ForegroundColor Cyan
npm list -g pkg | Out-Null
if ($LASTEXITCODE -ne 0) {
    Write-Host "      Installing pkg globally..." -ForegroundColor Yellow
    npm install -g pkg
}

# Build for Windows
Write-Host "[3/6] Building for Windows..." -ForegroundColor Cyan
pkg . --targets node18-win-x64 --output ../public/download/sak-whatsapp-agent-windows.exe

# Build for macOS (optional, comment out if not needed)
# Write-Host "[4/6] Building for macOS..." -ForegroundColor Cyan
# pkg . --targets node18-macos-x64 --output ../public/download/sak-whatsapp-agent-macos

# Build for Linux (optional, comment out if not needed)
# Write-Host "[5/6] Building for Linux..." -ForegroundColor Cyan
# pkg . --targets node18-linux-x64 --output ../public/download/sak-whatsapp-agent-linux

# Go back to root
Set-Location ..

# Create README
Write-Host "[4/6] Creating README..." -ForegroundColor Cyan
@"
╔═══════════════════════════════════════════════════════════════╗
║        SAK WhatsApp AI Desktop Agent - Setup Guide           ║
╚═══════════════════════════════════════════════════════════════╝

📋 QUICK SETUP (3 Steps):

1️⃣  CONFIGURE:
   • Open the .env file with Notepad
   • Find: TENANT_ID=your-tenant-id-here
   • Replace with YOUR Tenant ID from the dashboard
   • Find: API_KEY=your-secure-api-key-here  
   • Replace with YOUR API Key
   • Save and close

2️⃣  RUN:
   • Double-click: sak-whatsapp-agent-windows.exe
   • A command window will open with a QR code

3️⃣  CONNECT:
   • Open WhatsApp on your phone
   • Go to: Settings → Linked Devices
   • Tap: "Link a Device"
   • Scan the QR code shown in the command window
   • Done! ✅

🎯 WHAT HAPPENS NEXT:
   ✓ Your AI bot is now live 24/7
   ✓ It will respond to customer messages automatically
   ✓ Take orders, answer questions, recommend products
   ✓ Check your dashboard for analytics and reports

⚙️  IMPORTANT NOTES:
   • Keep the agent running on your computer
   • Don't close the command window
   • Minimize it if you want
   • Internet connection required
   • The agent uses ~50MB RAM (very light!)

🔧 TROUBLESHOOTING:

Problem: QR code doesn't appear
Solution: 
   • Check your internet connection
   • Make sure Tenant ID is correct in .env file
   • Restart the agent

Problem: "Module not found" error
Solution:
   • Make sure all files are in the same folder
   • Re-download if files are missing

Problem: WhatsApp won't scan
Solution:
   • Make sure you're using WhatsApp Business or regular WhatsApp
   • Try scanning with better lighting
   • Ensure QR code is fully visible on screen

Problem: Port 3001 is already in use
Solution:
   • Edit .env file and change LOCAL_PORT=3001 to 3002
   • Restart the agent

📞 NEED HELP?
   Email:    support@sakwhatsapp.com
   Phone:    +966-XXX-XXXX
   WhatsApp: +966-XXX-XXXX
   Website:  https://sakwhatsapp.com

📚 MORE RESOURCES:
   • Video Tutorial: https://sakwhatsapp.com/tutorials
   • FAQ: https://sakwhatsapp.com/faq
   • Dashboard: https://sakwhatsapp.com/customer-dashboard

═══════════════════════════════════════════════════════════════
  Thank you for choosing SAK WhatsApp AI! 🚀
  We're here to help you succeed!
═══════════════════════════════════════════════════════════════
"@ | Out-File -FilePath "public/download/README.txt" -Encoding UTF8

# Copy .env.example
Write-Host "[5/6] Copying configuration template..." -ForegroundColor Cyan
Copy-Item "desktop-agent/.env.example" "public/download/.env" -Force

# Create ZIP package
Write-Host "[6/6] Creating ZIP package..." -ForegroundColor Cyan
$files = @(
    "public/download/sak-whatsapp-agent-windows.exe",
    "public/download/.env",
    "public/download/README.txt"
)

Compress-Archive -Path $files -DestinationPath "public/download/desktop-agent-windows.zip" -Force

Write-Host ""
Write-Host "================================================" -ForegroundColor Green
Write-Host "  ✅ BUILD COMPLETE!" -ForegroundColor Green
Write-Host "================================================" -ForegroundColor Green
Write-Host ""
Write-Host "📦 Package created: public/download/desktop-agent-windows.zip" -ForegroundColor Yellow
Write-Host "📝 Includes:" -ForegroundColor White
Write-Host "   • Desktop Agent (Windows .exe)" -ForegroundColor White
Write-Host "   • Configuration file (.env)" -ForegroundColor White
Write-Host "   • Setup instructions (README.txt)" -ForegroundColor White
Write-Host ""
Write-Host "🌐 Next steps:" -ForegroundColor Cyan
Write-Host "   1. Deploy your cloud server" -ForegroundColor White
Write-Host "   2. Customers can download from: /download/desktop-agent-windows.zip" -ForegroundColor White
Write-Host "   3. They follow the README.txt instructions" -ForegroundColor White
Write-Host ""
Write-Host "🚀 Ready to go live!" -ForegroundColor Green
Write-Host ""
