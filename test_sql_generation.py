#!/usr/bin/env python3
"""
Test SQL generation with updated schema validator
"""
import sys
sys.path.insert(0, 'BlocIQ_Onboarder')

from sql_writer import SQLWriter

print("=" * 70)
print("Testing SQL Generation with Schema Validation")
print("=" * 70)

# Create test data
test_mapped_data = {
    'building': {
        'id': '731b3369-8d8a-4506-9946-ff45c139e31c',
        'name': 'Connaught Square',
        'address': 'CONNAUGHT SQUARE'
    },
    'major_works_projects': [
        {
            'id': '79844a2a-f245-4b5a-921b-2bc0c234b2dc',
            'building_id': '731b3369-8d8a-4506-9946-ff45c139e31c',
            'name': 'External Decoration - 2025',  # Should be mapped to project_name
            'status': 'planning',  # Should be mapped to 'planned'
            'start_date': '2025-01-01'
        }
    ],
    'building_documents': [
        {
            'id': 'b1b74dae-62c7-4ba0-b98a-0c41cc6c5bc7',
            'building_id': '731b3369-8d8a-4506-9946-ff45c139e31c',
            'category': 'leases',
            'file_name': 'Important Information .pdf',
            'file_path': 'lease/Important Information .pdf'  # Should be mapped to storage_path
        }
    ],
    'assets': [
        {
            'id': 'd16a3f9f-3d44-4f88-8a05-776a3e73acc3',
            'building_id': '731b3369-8d8a-4506-9946-ff45c139e31c',
            'asset_type': 'fire_alarm',
            'asset_name': 'Fire Alarm Works',
            'location_description': 'Works-Following from latest leak',
            'compliance_category': 'fire_safety',
            'condition_rating': 'good',  # Should be filtered out (not in schema)
            'service_frequency': '12 months'  # Should be filtered out (not in schema)
        }
    ]
}

print("\n🔨 Generating SQL...")
writer = SQLWriter()
sql = writer.generate_migration(test_mapped_data)

print("\n✅ SQL Generated!")
print("\n" + "=" * 70)
print("Generated SQL (first 2000 chars):")
print("=" * 70)
print(sql[:2000])

# Check for proper mappings
print("\n" + "=" * 70)
print("Validation Checks:")
print("=" * 70)

if 'project_name' in sql and 'INSERT INTO major_works_projects' in sql:
    print("✓ major_works_projects uses 'project_name'")
else:
    print("✗ major_works_projects missing 'project_name'")

if 'storage_path' in sql and 'INSERT INTO building_documents' in sql:
    print("✓ building_documents uses 'storage_path'")
else:
    print("✗ building_documents missing 'storage_path'")

if "'planned'" in sql and 'major_works_projects' in sql:
    print("✓ major_works_projects status mapped to 'planned'")
else:
    print("✗ major_works_projects status not mapped correctly")

if 'condition_rating' not in sql or '-- Skipped' in sql:
    print("✓ Invalid columns filtered out")
else:
    print("✗ Invalid columns NOT filtered")

print("\n" + "=" * 70)
