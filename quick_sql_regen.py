#!/usr/bin/env python3
"""
Quick SQL regeneration test - uses cached extraction data
"""

import sys
sys.path.insert(0, '/Users/ellie/onboardingblociq/BlocIQ_Onboarder')

from sql_writer import SQLWriter
from schema_mapper import SupabaseSchemaMapper
import uuid

# Create minimal test data
test_data = {
    'building': {
        'id': str(uuid.uuid4()),
        'name': 'Test Building',
        'address': '123 Test St',
        'postcode': 'W1 1AA',
        'city': 'London',
        'country': 'UK'
    },
    'units': [
        {
            'id': str(uuid.uuid4()),
            'building_id': None,  # Will be set by mapper
            'unit_number': 'Flat 1'
        }
    ],
    'schedules': [],
    'compliance_assets': [],
    'building_documents': [],
    'budgets': [],
    'leases': []
}

print("Initializing SQL Writer...")
sql_writer = SQLWriter()
schema_mapper = SupabaseSchemaMapper()

print("Mapping data...")
# Set building_id
building_id = test_data['building']['id']
for unit in test_data['units']:
    unit['building_id'] = building_id

mapped_data = schema_mapper.map_all(test_data, building_id=building_id)

print("Generating SQL...")
sql = sql_writer.generate_migration(mapped_data)

# Save to file
output_path = '/Users/ellie/Desktop/BlocIQ_Output/migration_test.sql'
with open(output_path, 'w') as f:
    f.write(sql)

print(f"\n✅ SQL written to: {output_path}")
print(f"   Size: {len(sql)} bytes")

# Count CREATE TABLE statements
create_count = sql.count('CREATE TABLE IF NOT EXISTS')
print(f"   CREATE TABLE statements: {create_count}")

# Show first 100 lines
print("\nFirst 100 lines:")
print("="*70)
lines = sql.split('\n')
for i, line in enumerate(lines[:100], 1):
    print(f"{i:4d} | {line}")
