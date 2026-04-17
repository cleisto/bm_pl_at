# BTC Monitor — Keystore Setup for Google Play
# Run this ONCE to create your signing key. Keep the keystore file safe!
# If you lose it, you can NEVER update your app on Google Play.

$ErrorActionPreference = "Stop"
$root = "$HOME\bm_pl_at\btc-monitor-apk"
$keystorePath = "$root\btc-monitor-release.keystore"
$propsPath = "$root\keystore.properties"

if (Test-Path $keystorePath) {
    Write-Host "Keystore already exists: $keystorePath" -ForegroundColor Yellow
    Write-Host "Delete it manually if you want to recreate."
    exit 0
}

Write-Host "=== BTC Monitor Keystore Setup ===" -ForegroundColor Cyan
Write-Host ""
Write-Host "This creates a signing key for Google Play." -ForegroundColor White
Write-Host "You will be asked for a password — remember it!" -ForegroundColor Yellow
Write-Host ""

$password = Read-Host "Enter a keystore password (min 6 characters)"
if ($password.Length -lt 6) {
    Write-Host "Password must be at least 6 characters." -ForegroundColor Red
    exit 1
}

$name = Read-Host "Your name (for the certificate, e.g. 'Max Mustermann')"
if ([string]::IsNullOrWhiteSpace($name)) { $name = "BTC Monitor Developer" }

Write-Host ""
Write-Host "Generating keystore..." -ForegroundColor Cyan

keytool -genkeypair `
    -v `
    -keystore "$keystorePath" `
    -alias "btcmonitor" `
    -keyalg RSA `
    -keysize 2048 `
    -validity 10000 `
    -storepass "$password" `
    -keypass "$password" `
    -dname "CN=$name, O=BTC Monitor, C=DE"

if ($LASTEXITCODE -ne 0) {
    Write-Host "keytool failed. Is Java installed?" -ForegroundColor Red
    exit 1
}

# Write keystore.properties (not committed to git)
@"
storeFile=btc-monitor-release.keystore
storePassword=$password
keyAlias=btcmonitor
keyPassword=$password
"@ | Set-Content -Path $propsPath -Encoding UTF8

Write-Host ""
Write-Host "Done!" -ForegroundColor Green
Write-Host "Keystore: $keystorePath" -ForegroundColor White
Write-Host "Properties: $propsPath" -ForegroundColor White
Write-Host ""
Write-Host "IMPORTANT: Back up these files! If you lose the keystore," -ForegroundColor Yellow
Write-Host "you can NEVER update your app on Google Play." -ForegroundColor Yellow
Write-Host ""
Write-Host "Next step: Run build_release.ps1 to build the AAB." -ForegroundColor Cyan
