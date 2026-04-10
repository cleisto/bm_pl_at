#!/usr/bin/env python3
"""Resize an icon image to all required Android mipmap sizes."""
import sys
import os

try:
    from PIL import Image
except ImportError:
    print("Installing Pillow...")
    os.system(sys.executable + " -m pip install Pillow")
    from PIL import Image

SIZES = {
    "mipmap-mdpi":    48,
    "mipmap-hdpi":    72,
    "mipmap-xhdpi":   96,
    "mipmap-xxhdpi":  144,
    "mipmap-xxxhdpi": 192,
}

def main():
    if len(sys.argv) < 2:
        print("Usage: python resize_icon.py <path-to-icon-image>")
        print("Example: python resize_icon.py icon.png")
        sys.exit(1)

    src = sys.argv[1]
    if not os.path.exists(src):
        print(f"Error: File not found: {src}")
        sys.exit(1)

    # Find the res directory
    script_dir = os.path.dirname(os.path.abspath(__file__))
    res_dir = os.path.join(script_dir, "..", "btc-monitor-apk", "app", "src", "main", "res")
    res_dir = os.path.normpath(res_dir)

    if not os.path.isdir(res_dir):
        print(f"Error: res directory not found at {res_dir}")
        sys.exit(1)

    img = Image.open(src).convert("RGBA")
    print(f"Source image: {src} ({img.width}x{img.height})")

    for folder, size in SIZES.items():
        out_dir = os.path.join(res_dir, folder)
        os.makedirs(out_dir, exist_ok=True)
        out_path = os.path.join(out_dir, "ic_launcher.png")
        resized = img.resize((size, size), Image.LANCZOS)
        resized.save(out_path, "PNG")
        print(f"  {folder}/ic_launcher.png -> {size}x{size}")

    print("\nDone! All icons updated.")
    print("Run 'gradlew.bat assembleDebug' to rebuild the APK with the new icon.")

if __name__ == "__main__":
    main()
