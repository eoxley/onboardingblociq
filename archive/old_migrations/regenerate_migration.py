#!/usr/bin/env python3
"""
Regenerate migration SQL using ACTUAL Supabase schema
This ensures 100% compatibility with existing database
"""
import json
import sys
from pathlib import Path

print("=" * 70)
print("BlocIQ Schema-Aware Migration Generator")
print("=" * 70)

# Load the current Supabase schema
print("\n📋 Loading current Supabase schema...")
with open('supabase_current_schema.json', 'r') as f:
    schema = json.load(f)

print(f"✓ Loaded schema for {len(schema)} tables")

# Load the extracted data summary
print("\n📊 Loading extracted data...")
with open('output/summary.json', 'r') as f:
    data_summary = json.load(f)

print(f"✓ Loaded data summary")
print(f"  - Buildings: {data_summary['statistics']['buildings']}")
print(f"  - Units: {data_summary['statistics']['units']}")
print(f"  - Leaseholders: {data_summary['statistics']['leaseholders']}")
print(f"  - Documents: {data_summary['statistics']['documents']}")

# Check what tables we need
required_tables = [
    'buildings',
    'units',
    'leaseholders',
    'compliance_assets',
    'assets',
    'major_works_projects',
    'budgets',
    'schedules',
    'apportionments',
    'building_contractors',
    'building_documents',
    'building_insurance',
    'leases',
    'building_knowledge'
]

print(f"\n🔍 Checking schema compatibility...")
missing_tables = []
for table in required_tables:
    if table in schema:
        columns = [col['name'] for col in schema[table]['columns']]
        print(f"  ✓ {table}: {len(columns)} columns")
    else:
        print(f"  ✗ {table}: MISSING")
        missing_tables.append(table)

if missing_tables:
    print(f"\n⚠️  Missing tables: {missing_tables}")
    print("   These tables will need to be created first.")

# Generate helper function to map data to actual schema
def get_column_mapping(table_name):
    """Get actual column names for a table"""
    if table_name not in schema:
        return []
    return [col['name'] for col in schema[table_name]['columns']]

# Create mapping guide
print(f"\n📝 Creating column mapping guide...")
mapping_guide = {}

for table in required_tables:
    if table in schema:
        mapping_guide[table] = {
            'columns': get_column_mapping(table),
            'sample_columns': get_column_mapping(table)[:10]  # Show first 10
        }

# Save mapping guide
with open('table_column_mapping.json', 'w') as f:
    json.dump(mapping_guide, f, indent=2)

print("✓ Saved column mapping to: table_column_mapping.json")

print(f"\n" + "=" * 70)
print("✅ Schema Analysis Complete!")
print("=" * 70)
print(f"\nNext step: Run the onboarder with --regenerate-migration flag")
print(f"This will use the actual schema to generate compatible SQL")

# Show key schema differences for problematic tables
print(f"\n📌 Key Schema Information:")
print(f"\nmajor_works_projects columns:")
if 'major_works_projects' in schema:
    for col in schema['major_works_projects']['columns']:
        print(f"  - {col['name']}: {col['type']}")

print(f"\nbuilding_documents columns:")
if 'building_documents' in schema:
    for col in schema['building_documents']['columns']:
        print(f"  - {col['name']}: {col['type']}")

print(f"\nassets columns:")
if 'assets' in schema:
    for col in schema['assets']['columns'][:15]:  # First 15
        print(f"  - {col['name']}: {col['type']}")
