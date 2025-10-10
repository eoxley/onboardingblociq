#!/usr/bin/env python3
"""
Test Building Health Check PDF generation
"""
import sys
import json
sys.path.insert(0, 'BlocIQ_Onboarder')

from reporting.building_health_check_v2 import generate_health_check_v2

print("=" * 70)
print("Testing Building Health Check PDF Generation")
print("=" * 70)

# Load the existing summary data
print("\n📊 Loading summary data...")
with open('output/summary.json', 'r') as f:
    summary_data = json.load(f)

# Create a minimal building_data structure
building_data = {
    'building': {
        'id': '731b3369-8d8a-4506-9946-ff45c139e31c',
        'name': 'Connaught Square',
        'address': 'CONNAUGHT SQUARE'
    },
    'units': [],  # Will be populated if data exists
    'leaseholders': [],
    'compliance_assets': [],
    'budgets': [],
    'building_insurance': [],
    'building_contractors': [],
    'major_works_projects': []
}

print(f"✓ Loaded summary with {summary_data['statistics']} statistics")

# Try to generate the PDF
print("\n🔨 Generating PDF...")
try:
    output_path = 'output/test_building_health_check.pdf'
    result = generate_health_check_v2(
        building_data=building_data,
        output_path=output_path
    )

    if result:
        print(f"\n✅ SUCCESS! PDF generated at: {result}")
        import os
        file_size = os.path.getsize(result)
        print(f"   File size: {file_size:,} bytes ({file_size/1024:.1f} KB)")
    else:
        print(f"\n❌ FAILED: generate_health_check_v2 returned None")

except Exception as e:
    print(f"\n❌ ERROR: {e}")
    import traceback
    traceback.print_exc()

print("\n" + "=" * 70)
