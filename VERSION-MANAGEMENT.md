# Version Management Guide

## Quick Commands

### Build a Release (Recommended)
```powershell
# Build with automatic patch version bump (1.0.2 → 1.0.3)
.\BUILD-RELEASE.ps1

# Build with minor version bump (1.0.3 → 1.1.0)
.\BUILD-RELEASE.ps1 -VersionType minor

# Build with major version bump (1.1.0 → 2.0.0)
.\BUILD-RELEASE.ps1 -VersionType major
```

### Just Build (No Version Change)
```powershell
.\create-client-package-fixed.ps1
```

## Version Types

### Patch (1.0.2 → 1.0.3)
Use for:
- Bug fixes
- Small improvements
- Configuration updates

### Minor (1.0.3 → 1.1.0)
Use for:
- New features
- Significant improvements
- API additions

### Major (1.1.0 → 2.0.0)
Use for:
- Breaking changes
- Complete rewrites
- Major architecture changes

## Current Version
Check `desktop-agent/package.json` for the current version.

## What Gets Updated
When you run BUILD-RELEASE.ps1:
1. ✓ Version number in package.json
2. ✓ Package filename includes version
3. ✓ README.txt footer shows version
4. ✓ Success message shows version

## Example Workflow

```powershell
# 1. Make your changes to the code
# 2. Test everything works
# 3. Build the release
.\BUILD-RELEASE.ps1

# 4. (Optional) Commit to git
git add .
git commit -m "Release v1.0.3"
git tag v1.0.3
git push origin main --tags
```

## Package Location
After building, find your package at:
```
client-distribution\SAK-WhatsApp-Agent-Windows-v{VERSION}.zip
```

For example:
- `SAK-WhatsApp-Agent-Windows-v1.0.2.zip`
- `SAK-WhatsApp-Agent-Windows-v1.1.0.zip`
- `SAK-WhatsApp-Agent-Windows-v2.0.0.zip`
