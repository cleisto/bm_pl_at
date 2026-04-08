# BTC Monitor ProGuard Rules
# Keep WebView JavaScript interface (if we ever add one)
-keepclassmembers class * {
    @android.webkit.JavascriptInterface <methods>;
}

# Keep MainActivity
-keep class com.btcmonitor.app.MainActivity { *; }
