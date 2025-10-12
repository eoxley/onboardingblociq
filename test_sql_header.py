#!/usr/bin/env python3
"""Test the SQL header generation"""

import sys
sys.path.insert(0, '/Users/ellie/onboardingblociq/BlocIQ_Onboarder')

from sql_writer import SQLWriter

writer = SQLWriter()

# Generate just the header
writer._add_header()

# Get the SQL
header_sql = '\n'.join(writer.sql_statements)

print("SQL Header Generated:")
print("="*70)
print(header_sql)
print("="*70)

# Count CREATE TABLE statements
create_count = header_sql.count('CREATE TABLE IF NOT EXISTS')
print(f"\n CREATE TABLE statements in header: {create_count}")

# Check for key tables
key_tables = ['buildings', 'units', 'leaseholders', 'schedules',
              'compliance_assets', 'building_documents', 'contractors',
              'assets', 'apportionments', 'major_works_projects']

print("\nChecking for key tables:")
for table in key_tables:
    if f'CREATE TABLE IF NOT EXISTS {table}' in header_sql:
        print(f"  ✓ {table}")
    else:
        print(f"  ✗ {table} MISSING")

# Save to file
output_path = '/Users/ellie/Desktop/BlocIQ_Output/sql_header_test.sql'
with open(output_path, 'w') as f:
    f.write(header_sql)

print(f"\n✅ Header saved to: {output_path}")
