#!/bin/bash
# Regenerates index.html for both android-app/ and btc-monitor-apk/ from JSX source
set -e
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
JSX_SRC="$ROOT/btc_power_law_monitor_v6.1.jsx"
HTML_OUT_APP="$ROOT/android-app/assets/index.html"
HTML_OUT_APK="$ROOT/btc-monitor-apk/app/src/main/assets/index.html"

{
cat << 'HEADER'
<!DOCTYPE html>
<html lang="de">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no" />
  <title>BTC Power Law Monitor</title>
  <script src="https://unpkg.com/react@18/umd/react.production.min.js" crossorigin></script>
  <script src="https://unpkg.com/react-dom@18/umd/react-dom.production.min.js" crossorigin></script>
  <script src="https://unpkg.com/@babel/standalone/babel.min.js"></script>
  <script src="https://cdn.tailwindcss.com"></script>
  <style>
    * { -webkit-tap-highlight-color: transparent; box-sizing: border-box; }
    body { margin: 0; padding: 0; background: #020617; overscroll-behavior: none; }
    input[type="number"]::-webkit-inner-spin-button,
    input[type="number"]::-webkit-outer-spin-button { -webkit-appearance: none; margin: 0; }
  </style>
</head>
<body>
  <div id="root"></div>
  <script type="text/babel">
    const { useState, useMemo, useEffect, useCallback, useRef } = React;

HEADER

grep -v '^import ' "$JSX_SRC" \
  | sed 's/^export default function BTCPowerLawMonitor/function BTCPowerLawMonitor/'

cat << 'FOOTER'

    const rootEl = document.getElementById('root');
    const root = ReactDOM.createRoot(rootEl);
    root.render(React.createElement(BTCPowerLawMonitor));
  </script>
</body>
</html>
FOOTER
} > "$HTML_OUT_APP"

cp "$HTML_OUT_APP" "$HTML_OUT_APK"

echo "Generated: $HTML_OUT_APP ($(wc -l < "$HTML_OUT_APP") lines)"
echo "Copied to: $HTML_OUT_APK"
