#!/bin/bash
# ============================================================================
# Create Mac Application for Supplier Onboarding
# ============================================================================

APP_NAME="Supplier Onboarding"
APP_DIR="/Users/ellie/onboardingblociq/$APP_NAME.app"
SCRIPT_PATH="/Users/ellie/onboardingblociq/supplier_onboarding_app.py"

echo "🚀 Creating Mac Application..."

# Remove old app if exists
rm -rf "$APP_DIR"

# Create app bundle structure
mkdir -p "$APP_DIR/Contents/MacOS"
mkdir -p "$APP_DIR/Contents/Resources"

# Create Info.plist
cat > "$APP_DIR/Contents/Info.plist" << 'EOF'
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>CFBundleName</key>
    <string>Supplier Onboarding</string>
    <key>CFBundleDisplayName</key>
    <string>Supplier Onboarding</string>
    <key>CFBundleIdentifier</key>
    <string>com.blociq.supplier-onboarding</string>
    <key>CFBundleVersion</key>
    <string>1.0</string>
    <key>CFBundlePackageType</key>
    <string>APPL</string>
    <key>CFBundleSignature</key>
    <string>????</string>
    <key>CFBundleExecutable</key>
    <string>launch</string>
    <key>CFBundleIconFile</key>
    <string>AppIcon.icns</string>
    <key>LSMinimumSystemVersion</key>
    <string>10.13</string>
</dict>
</plist>
EOF

# Create launch script
cat > "$APP_DIR/Contents/MacOS/launch" << EOF
#!/bin/bash
cd /Users/ellie/onboardingblociq
/usr/local/bin/python3 supplier_onboarding_app.py
EOF

chmod +x "$APP_DIR/Contents/MacOS/launch"

# Create simple icon using sips (built-in Mac tool)
# Create a PNG icon
cat > "$APP_DIR/Contents/Resources/create_icon.py" << 'ICONPY'
from PIL import Image, ImageDraw, ImageFont

# Create 512x512 icon
size = 512
img = Image.new('RGB', (size, size), '#2c5aa0')  # Blue background
draw = ImageDraw.Draw(img)

# Draw hammer emoji representation (simple geometric shape)
# Draw hammer head
draw.rectangle([150, 180, 280, 250], fill='#cccccc', outline='#888888', width=3)
# Draw hammer handle
draw.rectangle([190, 250, 240, 400], fill='#8B4513', outline='#654321', width=3)

# Add text
try:
    font_size = 48
    text = "Supplier\nOnboarding"
    draw.text((size//2, 430), text, fill='white', anchor='mm', align='center')
except:
    pass

img.save('/tmp/supplier_icon.png')
print("Icon created!")
ICONPY

# Try to create icon with Python
python3 "$APP_DIR/Contents/Resources/create_icon.py" 2>/dev/null

# Convert PNG to ICNS using built-in tools
if [ -f /tmp/supplier_icon.png ]; then
    mkdir -p /tmp/AppIcon.iconset
    
    # Create different sizes
    sips -z 16 16 /tmp/supplier_icon.png --out /tmp/AppIcon.iconset/icon_16x16.png >/dev/null 2>&1
    sips -z 32 32 /tmp/supplier_icon.png --out /tmp/AppIcon.iconset/icon_16x16@2x.png >/dev/null 2>&1
    sips -z 32 32 /tmp/supplier_icon.png --out /tmp/AppIcon.iconset/icon_32x32.png >/dev/null 2>&1
    sips -z 64 64 /tmp/supplier_icon.png --out /tmp/AppIcon.iconset/icon_32x32@2x.png >/dev/null 2>&1
    sips -z 128 128 /tmp/supplier_icon.png --out /tmp/AppIcon.iconset/icon_128x128.png >/dev/null 2>&1
    sips -z 256 256 /tmp/supplier_icon.png --out /tmp/AppIcon.iconset/icon_128x128@2x.png >/dev/null 2>&1
    sips -z 256 256 /tmp/supplier_icon.png --out /tmp/AppIcon.iconset/icon_256x256.png >/dev/null 2>&1
    sips -z 512 512 /tmp/supplier_icon.png --out /tmp/AppIcon.iconset/icon_256x256@2x.png >/dev/null 2>&1
    sips -z 512 512 /tmp/supplier_icon.png --out /tmp/AppIcon.iconset/icon_512x512.png >/dev/null 2>&1
    
    # Convert to ICNS
    iconutil -c icns /tmp/AppIcon.iconset -o "$APP_DIR/Contents/Resources/AppIcon.icns" 2>/dev/null
    
    # Cleanup
    rm -rf /tmp/AppIcon.iconset /tmp/supplier_icon.png
fi

echo "✅ Application created: $APP_DIR"
echo ""
echo "📁 You can now:"
echo "   1. Drag 'Supplier Onboarding.app' to your Desktop"
echo "   2. Or drag to Applications folder"
echo "   3. Double-click to launch!"
echo ""
echo "Location: /Users/ellie/onboardingblociq/$APP_NAME.app"

