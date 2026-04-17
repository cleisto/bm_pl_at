# BTC Monitor — Release Build for Google Play
# Creates a signed AAB (Android App Bundle) ready for upload.

$ErrorActionPreference = "Stop"
$root = "$HOME\bm_pl_at\btc-monitor-apk"
$propsPath = "$root\keystore.properties"
$aabOutput = "$root\app\build\outputs\bundle\release\app-release.aab"
$desktop = "$HOME\Desktop"

# Check prerequisites
if (-not (Test-Path $propsPath)) {
    Write-Host "No keystore.properties found." -ForegroundColor Red
    Write-Host "Run setup_keystore.ps1 first!" -ForegroundColor Yellow
    exit 1
}

Write-Host "=== BTC Monitor Release Build ===" -ForegroundColor Cyan

# Build signed AAB
cd $root
Write-Host "Building signed AAB..." -ForegroundColor White
.\gradlew.bat bundleRelease

if ($LASTEXITCODE -ne 0) {
    Write-Host "Build failed!" -ForegroundColor Red
    exit 1
}

# Copy to desktop
if (Test-Path $aabOutput) {
    Copy-Item $aabOutput "$desktop\BTC-Monitor_v8.1.aab"
    Write-Host ""
    Write-Host "Build successful!" -ForegroundColor Green
    Write-Host "AAB: $desktop\BTC-Monitor_v8.1.aab" -ForegroundColor White
    Write-Host ""
    Write-Host "Upload this file to Google Play Console:" -ForegroundColor Cyan
    Write-Host "https://play.google.com/console" -ForegroundColor White
} else {
    Write-Host "AAB not found at expected path." -ForegroundColor Red
    Write-Host "Check: $aabOutput" -ForegroundColor Yellow
}

# Also build debug APK for local testing
Write-Host ""
Write-Host "Also building debug APK for testing..." -ForegroundColor White
.\gradlew.bat assembleDebug
$apkOutput = "$root\app\build\outputs\apk\debug\app-debug.apk"
if (Test-Path $apkOutput) {
    Copy-Item $apkOutput "$desktop\BTC-Monitor_v8.1-debug.apk"
    Write-Host "Debug APK: $desktop\BTC-Monitor_v8.1-debug.apk" -ForegroundColor White
}
