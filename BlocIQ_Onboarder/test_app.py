#!/usr/bin/env python3
"""
Test script for BlocIQ Onboarder Desktop App
Tests core functionality without GUI
"""

import sys
from pathlib import Path
from onboarder import BlocIQOnboarder

def test_onboarder():
    """Test the onboarder with sample data"""
    print("🧪 Testing BlocIQ Onboarder Core Functionality")
    print("=" * 50)
    
    # Test with the existing Connaught Square data
    client_folder = "/Users/ellie/Desktop/BlocIQ Buildings/2.Connaught Square"
    building_name = "Connaught Square"
    
    if not Path(client_folder).exists():
        print(f"❌ Test folder not found: {client_folder}")
        print("Please update the path in test_app.py")
        return False
    
    try:
        # Create onboarder instance
        onboarder = BlocIQOnboarder(client_folder, building_name)
        
        # Run the onboarder
        print(f"📁 Processing: {client_folder}")
        print(f"🏢 Building: {building_name}")
        print()
        
        onboarder.run()
        
        # Check output files
        output_dir = Path("output")
        if output_dir.exists():
            print("\n✅ Generated Files:")
            for file_path in output_dir.rglob("*"):
                if file_path.is_file():
                    size = file_path.stat().st_size
                    print(f"  • {file_path.relative_to(output_dir)} ({size:,} bytes)")
        else:
            print("❌ No output directory created")
            return False
        
        print("\n✅ Test completed successfully!")
        return True
        
    except Exception as e:
        print(f"❌ Test failed: {str(e)}")
        import traceback
        traceback.print_exc()
        return False

if __name__ == "__main__":
    success = test_onboarder()
    sys.exit(0 if success else 1)
