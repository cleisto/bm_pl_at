# BTC Power Law Monitor — Android App

React Native / Expo app that wraps the BTC Power Law Monitor dashboard in a native Android shell.

## Features
- Live BTC price via CoinGecko API (auto-refresh every 60s)
- Power Law Bands chart (log-scale SVG)
- Log-Periodic Oscillation model (discrete scale invariance)
- Zone indicator + DCA multiplier
- Take-Profit trigger levels
- Fair-Value projections (6M – 10Y)
- Cycle phase indicator

## Prerequisites
- Node.js 18+
- Expo CLI: `npm install -g expo-cli`
- EAS CLI (for builds): `npm install -g eas-cli`
- Android Studio (for local builds) or Expo Go app (for dev)

## Quick Start (Development)

```bash
cd android-app
npm install
npx expo start --android
```

## Build APK (Preview)

```bash
npm install -g eas-cli
eas login
eas build --platform android --profile preview
```

## Build AAB (Production / Play Store)

```bash
eas build --platform android --profile production
```

## Architecture

The app uses a **React Native WebView** to render the existing JSX dashboard:

```
App.js
  └── WebView
        └── assets/index.html        ← Self-contained web app
              ├── React 18 (CDN)
              ├── ReactDOM (CDN)
              ├── Babel Standalone (CDN, JSX transpiler)
              ├── Tailwind CSS (CDN)
              └── btc_power_law_monitor.jsx (embedded, modified)
```

The JSX is transpiled client-side by Babel in the WebView, so no build step is required for the web layer. The only native dependency is `react-native-webview`.

## Asset Generation

The `assets/index.html` is generated from `../btc_power_law_monitor.jsx.txt` by:
1. Removing the ES6 `import` statement (React hooks available globally)
2. Replacing `export default function` with `function`
3. Wrapping with HTML boilerplate + CDN script tags

To regenerate after updating the JSX source:
```bash
# From the BTC-Monitor root directory
./scripts/generate_html.sh
```
