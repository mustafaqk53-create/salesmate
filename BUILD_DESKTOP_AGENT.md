# SAK WhatsApp AI - Desktop Agent Distribution

## Building Desktop Agent for Customers

### For Windows:
```bash
cd desktop-agent
npm install
npm install -g pkg
pkg . --targets node18-win-x64 --output ../public/download/sak-whatsapp-agent-windows.exe
```

### For macOS:
```bash
cd desktop-agent
npm install
npm install -g pkg
pkg . --targets node18-macos-x64 --output ../public/download/sak-whatsapp-agent-macos
```

### For Linux:
```bash
cd desktop-agent
npm install
npm install -g pkg
pkg . --targets node18-linux-x64 --output ../public/download/sak-whatsapp-agent-linux
```

## Creating ZIP Packages

### Windows:
```powershell
cd public/download
Compress-Archive -Path sak-whatsapp-agent-windows.exe,.env.example,README.txt -DestinationPath desktop-agent-windows.zip
```

### macOS:
```bash
cd public/download
zip desktop-agent-macos.zip sak-whatsapp-agent-macos .env.example README.txt
```

### Linux:
```bash
cd public/download
tar -czf desktop-agent-linux.tar.gz sak-whatsapp-agent-linux .env.example README.txt
```

## Customer Instructions (README.txt)

Create a README.txt file with setup instructions:

```
SAK WhatsApp AI Desktop Agent
==============================

SETUP INSTRUCTIONS:

1. Extract this ZIP file to a folder on your computer

2. Edit the .env file:
   - Open .env with Notepad
   - Replace "your-tenant-id-here" with YOUR Tenant ID from the dashboard
   - Replace "your-secure-api-key-here" with YOUR API Key
   - Save the file

3. Run the agent:
   - Windows: Double-click sak-whatsapp-agent-windows.exe
   - macOS: Open Terminal, navigate to folder, run: ./sak-whatsapp-agent-macos
   - Linux: Open Terminal, run: ./sak-whatsapp-agent-linux

4. Scan QR Code:
   - A QR code will appear in the terminal/command window
   - Open WhatsApp on your phone
   - Go to Settings → Linked Devices
   - Tap "Link a Device"
   - Scan the QR code

5. Done!
   - Your AI bot is now live and responding to customers 24/7
   - Keep the agent running on your computer
   - Check your dashboard for analytics

SUPPORT:
Email: support@sakwhatsapp.com
Phone: +966-XXX-XXXX
WhatsApp: +966-XXX-XXXX

TROUBLESHOOTING:
- If QR code doesn't appear, check your internet connection
- Make sure your Tenant ID is correct
- Ensure port 3001 is not blocked by firewall
- Contact support if issues persist
```

## Auto-Build Script (build-desktop-agent.ps1)

```powershell
# Build Desktop Agent for All Platforms
Write-Host "Building Desktop Agent..." -ForegroundColor Green

# Create download directory
New-Item -ItemType Directory -Force -Path "public/download"

# Navigate to desktop-agent
Set-Location desktop-agent

# Install dependencies
npm install

# Install pkg globally if not installed
npm list -g pkg | Out-Null
if ($LASTEXITCODE -ne 0) {
    Write-Host "Installing pkg..." -ForegroundColor Yellow
    npm install -g pkg
}

# Build for Windows
Write-Host "Building for Windows..." -ForegroundColor Cyan
pkg . --targets node18-win-x64 --output ../public/download/sak-whatsapp-agent-windows.exe

# Build for macOS
Write-Host "Building for macOS..." -ForegroundColor Cyan
pkg . --targets node18-macos-x64 --output ../public/download/sak-whatsapp-agent-macos

# Build for Linux
Write-Host "Building for Linux..." -ForegroundColor Cyan
pkg . --targets node18-linux-x64 --output ../public/download/sak-whatsapp-agent-linux

# Go back to root
Set-Location ..

# Create README
@"
SAK WhatsApp AI Desktop Agent
==============================

SETUP INSTRUCTIONS:

1. Extract this ZIP file to a folder on your computer

2. Edit the .env file:
   - Replace "your-tenant-id-here" with YOUR Tenant ID
   - Replace "your-secure-api-key-here" with YOUR API Key
   - Save the file

3. Run the agent (double-click the executable)

4. Scan QR Code with WhatsApp

5. Done! Your AI bot is live 24/7

SUPPORT: support@sakwhatsapp.com
"@ | Out-File -FilePath "public/download/README.txt" -Encoding UTF8

# Copy .env.example
Copy-Item "desktop-agent/.env.example" "public/download/.env.example"

# Create ZIP packages
Write-Host "Creating ZIP packages..." -ForegroundColor Yellow

Compress-Archive -Path "public/download/sak-whatsapp-agent-windows.exe","public/download/.env.example","public/download/README.txt" -DestinationPath "public/download/desktop-agent-windows.zip" -Force

Write-Host "Build complete!" -ForegroundColor Green
Write-Host "Packages created in public/download/" -ForegroundColor Green
```

Save this as `build-desktop-agent.ps1` in your project root and run it to create distributable packages.
