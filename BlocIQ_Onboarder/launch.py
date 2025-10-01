#!/usr/bin/env python3
"""
BlocIQ Onboarder Launcher
Simple launcher script with dependency checking
"""

import sys
import subprocess
import importlib.util

def check_dependencies():
    """Check if required dependencies are installed"""
    required_modules = [
        'pandas', 'openpyxl', 'docx', 'PyPDF2', 'pdfplumber'
    ]
    
    missing = []
    for module in required_modules:
        spec = importlib.util.find_spec(module)
        if spec is None:
            missing.append(module)
    
    if missing:
        print("❌ Missing required dependencies:")
        for module in missing:
            print(f"  • {module}")
        print("\n📦 Install dependencies with:")
        print("  pip install -r requirements.txt")
        return False
    
    return True

def main():
    """Main launcher function"""
    print("🚀 BlocIQ Onboarder Launcher")
    print("=" * 30)
    
    # Check dependencies
    if not check_dependencies():
        sys.exit(1)
    
    print("✅ All dependencies found")
    print("🎯 Launching BlocIQ Onboarder...")
    print()
    
    try:
        # Import and run the app
        from app import main as app_main
        app_main()
    except ImportError as e:
        print(f"❌ Import error: {e}")
        print("Make sure all files are in the correct directory")
        sys.exit(1)
    except Exception as e:
        print(f"❌ Error launching app: {e}")
        sys.exit(1)

if __name__ == "__main__":
    main()
