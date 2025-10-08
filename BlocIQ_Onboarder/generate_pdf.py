#!/usr/bin/env python3
"""
Generate Building Health Check PDF after data is uploaded to Supabase
"""

import os
import sys
from dotenv import load_dotenv
from supabase import create_client
from reporting.building_health_check import BuildingHealthCheckGenerator

# Load environment
load_dotenv()

def main():
    """Generate PDF from Supabase data"""

    # Get building ID (either from command line or prompt)
    if len(sys.argv) > 1:
        building_id = sys.argv[1]
    else:
        building_id = input("Enter building ID (from Supabase): ").strip()

    if not building_id:
        print("❌ Building ID is required")
        sys.exit(1)

    # Connect to Supabase
    supabase_url = os.getenv('SUPABASE_URL')
    supabase_key = os.getenv('SUPABASE_SERVICE_ROLE_KEY') or os.getenv('SUPABASE_KEY')

    if not supabase_url or not supabase_key:
        print("❌ SUPABASE_URL and SUPABASE_KEY must be set in .env")
        sys.exit(1)

    print(f"\n🔌 Connecting to Supabase...")
    print(f"   URL: {supabase_url}")

    try:
        supabase_client = create_client(supabase_url, supabase_key)
        print("   ✅ Connected")
    except Exception as e:
        print(f"   ❌ Connection failed: {e}")
        sys.exit(1)

    # Generate PDF
    print(f"\n📊 Generating Building Health Check PDF...")
    print(f"   Building ID: {building_id}")

    generator = BuildingHealthCheckGenerator(supabase_client=supabase_client)

    # Output to Desktop
    output_dir = "/Users/ellie/Desktop/BlocIQ_Output"
    os.makedirs(output_dir, exist_ok=True)

    try:
        report_file = generator.generate_report(
            building_id=building_id,
            output_dir=output_dir,
            local_data=None  # Use Supabase data
        )

        if report_file:
            print(f"\n✅ SUCCESS!")
            print(f"   PDF: {report_file}")
            print(f"\n📄 Report includes:")
            print(f"   • Building summary and key metrics")
            print(f"   • Contractor overview with status")
            print(f"   • Asset register with compliance tracking")
            print(f"   • Compliance matrix by category")
            print(f"   • Major works projects")
            print(f"   • Financial summary")
        else:
            print(f"\n❌ PDF generation failed")
            sys.exit(1)

    except Exception as e:
        print(f"\n❌ Error: {e}")
        import traceback
        traceback.print_exc()
        sys.exit(1)


if __name__ == '__main__':
    main()
