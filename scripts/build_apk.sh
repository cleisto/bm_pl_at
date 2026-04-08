#!/bin/bash
# Build BTC Monitor APK (debug or release)
# Usage: ./scripts/build_apk.sh [debug|release]
#
# Prerequisites:
#   - Android SDK with platform 34 and build-tools 34.0.0
#   - Java 11+ (JDK)
#   - ANDROID_HOME or ANDROID_SDK_ROOT set
#
# The output APK will be at:
#   Debug:   btc-monitor-apk/app/build/outputs/apk/debug/app-debug.apk
#   Release: btc-monitor-apk/app/build/outputs/apk/release/app-release.apk

set -e
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
BUILD_TYPE="${1:-debug}"

echo "=== BTC Monitor APK Builder ==="
echo "Build type: $BUILD_TYPE"
echo ""

# Step 1: Regenerate HTML from JSX (if script exists and JSX is newer)
JSX_SRC="$ROOT/btc_power_law_monitor_v6.1.jsx"
HTML_OUT="$ROOT/btc-monitor-apk/app/src/main/assets/index.html"
if [ -f "$ROOT/scripts/generate_html.sh" ] && [ -f "$JSX_SRC" ]; then
  if [ "$JSX_SRC" -nt "$HTML_OUT" ] || [ ! -f "$HTML_OUT" ]; then
    echo "[1/3] Regenerating index.html from JSX..."
    bash "$ROOT/scripts/generate_html.sh"
  else
    echo "[1/3] index.html is up to date."
  fi
else
  echo "[1/3] Skipping HTML generation (files not found)."
fi

# Step 2: Build with Gradle
echo "[2/3] Building APK with Gradle ($BUILD_TYPE)..."
cd "$ROOT/btc-monitor-apk"

if [ "$BUILD_TYPE" = "release" ]; then
  ./gradlew assembleRelease --no-daemon
  APK_PATH="$ROOT/btc-monitor-apk/app/build/outputs/apk/release/app-release-unsigned.apk"
else
  ./gradlew assembleDebug --no-daemon
  APK_PATH="$ROOT/btc-monitor-apk/app/build/outputs/apk/debug/app-debug.apk"
fi

# Step 3: Copy to root
if [ -f "$APK_PATH" ]; then
  VERSION=$(grep 'versionName' "$ROOT/btc-monitor-apk/app/build.gradle" | head -1 | grep -oP '"[^"]*"' | tr -d '"')
  OUTPUT="$ROOT/BTC-Monitor_v${VERSION}.apk"
  cp "$APK_PATH" "$OUTPUT"
  echo ""
  echo "[3/3] APK built successfully!"
  echo "  Output: $OUTPUT"
  echo "  Size:   $(du -h "$OUTPUT" | cut -f1)"
else
  echo "[3/3] ERROR: APK not found at $APK_PATH"
  echo "  Check the Gradle build output above for errors."
  exit 1
fi
