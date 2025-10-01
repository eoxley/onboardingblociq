#!/bin/bash
# BlocIQ Onboarder - Build Script for Mac Desktop App
# This script packages the Python application into a standalone .app file

echo "🏗️  Building BlocIQ Onboarder Desktop App"
echo "=========================================="

# Check if PyInstaller is installed
if ! python3 -c "import PyInstaller" 2>/dev/null; then
    echo "❌ PyInstaller not found. Installing..."
    pip3 install pyinstaller
fi

# Clean previous builds
echo "🧹 Cleaning previous builds..."
rm -rf dist/BlocIQOnboarder.app build/BlocIQOnboarder BlocIQOnboarder.spec

# Build the app
echo "🔨 Building application..."
python3 -m PyInstaller --onedir --windowed \
    --add-data "icon.png:." \
    --icon "icon.png" \
    app.py --name BlocIQOnboarder --clean

# Check if build was successful
if [ -d "dist/BlocIQOnboarder.app" ]; then
    echo "✅ Build successful!"
    echo "📱 Application created: dist/BlocIQOnboarder.app"
    echo ""
    echo "🚀 To launch the app:"
    echo "   open dist/BlocIQOnboarder.app"
    echo ""
    echo "📁 To install to Applications folder:"
    echo "   cp -r dist/BlocIQOnboarder.app /Applications/"
    echo ""
    echo "📦 To create a zip for distribution:"
    echo "   cd dist && zip -r BlocIQOnboarder.zip BlocIQOnboarder.app"
else
    echo "❌ Build failed!"
    exit 1
fi
