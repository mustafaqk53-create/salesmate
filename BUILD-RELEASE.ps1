# SAK WhatsApp AI - Build Release Package
# Automatic version management and package creation

param(
    [Parameter(Mandatory=$false)]
    [ValidateSet("patch", "minor", "major")]
    [string]$VersionType = "patch"
)

Write-Host ""
Write-Host "================================================================" -ForegroundColor Cyan
Write-Host "     SAK WhatsApp AI - Build Release" -ForegroundColor Cyan
Write-Host "================================================================" -ForegroundColor Cyan
Write-Host ""

# Get current version
$packageJsonPath = "desktop-agent\package.json"
$packageJson = Get-Content $packageJsonPath -Raw | ConvertFrom-Json
$oldVersion = $packageJson.version

Write-Host "Current version: v$oldVersion" -ForegroundColor Yellow
Write-Host "Version type: $VersionType" -ForegroundColor Yellow
Write-Host ""

# Ask for confirmation
Write-Host "This will:" -ForegroundColor Cyan
Write-Host "  1. Increment version ($VersionType)" -ForegroundColor White
Write-Host "  2. Build new executable" -ForegroundColor White
Write-Host "  3. Create distribution package" -ForegroundColor White
Write-Host ""

$confirmation = Read-Host "Continue? (Y/N)"
if ($confirmation -ne "Y" -and $confirmation -ne "y") {
    Write-Host "Build cancelled." -ForegroundColor Red
    exit
}

Write-Host ""
Write-Host "Building release..." -ForegroundColor Green
Write-Host ""

# Update version in package.json
Set-Location desktop-agent
switch ($VersionType) {
    "patch" { npm run version:patch --silent 2>&1 | Out-Null }
    "minor" { npm run version:minor --silent 2>&1 | Out-Null }
    "major" { npm run version:major --silent 2>&1 | Out-Null }
}

# Get new version
$packageJson = Get-Content "package.json" -Raw | ConvertFrom-Json
$newVersion = $packageJson.version
Set-Location ..

Write-Host "Version updated: v$oldVersion -> v$newVersion" -ForegroundColor Green
Write-Host ""

# Build the package
& .\create-client-package-fixed.ps1

Write-Host ""
Write-Host "================================================================" -ForegroundColor Cyan
Write-Host "Release v$newVersion is ready!" -ForegroundColor Green
Write-Host "================================================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Package location:" -ForegroundColor Yellow
Write-Host "  client-distribution\SAK-WhatsApp-Agent-Windows-v$newVersion.zip" -ForegroundColor White
Write-Host ""
Write-Host "Git commands:" -ForegroundColor Yellow
Write-Host "  git add ." -ForegroundColor Gray
Write-Host "  git commit -m 'Release v$newVersion'" -ForegroundColor Gray
Write-Host "  git tag v$newVersion" -ForegroundColor Gray
Write-Host "  git push origin main --tags" -ForegroundColor Gray
Write-Host ""
