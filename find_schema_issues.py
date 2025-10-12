#!/usr/bin/env python3
"""
Find common Supabase schema validation issues in generated SQL
"""

import re

sql_path = '/Users/ellie/Desktop/BlocIQ_Output/migration.sql'

with open(sql_path, 'r') as f:
    sql_content = f.read()

print("="*70)
print("SUPABASE SCHEMA ISSUE DETECTOR")
print("="*70)
print()

issues = []

# Issue 1: Check for tables that don't exist in schema
print("1. Checking for references to non-existent tables...")
print()

# Common tables that should exist
existing_tables = ['buildings', 'units', 'leaseholders', 'leases', 'schedules',
                  'budgets', 'compliance_assets', 'building_documents',
                  'building_insurance', 'contractors', 'contractor_contracts',
                  'major_works_projects', 'apportionments', 'assets',
                  'building_contractors', 'building_utilities', 'building_legal',
                  'building_statutory_reports', 'building_keys_access',
                  'building_warranties', 'company_secretary', 'building_staff',
                  'building_title_deeds', 'fire_door_inspections', 'timeline_events',
                  'lease_clauses', 'building_safety_reports',
                  'lease_parties', 'lease_demise', 'lease_financial_terms',
                  'lease_insurance_terms', 'lease_covenants', 'lease_restrictions',
                  'lease_rights', 'lease_enforcement', 'document_texts',
                  'building_compliance_assets', 'major_works_notices',
                  'uncategorised_docs']

# Find all INSERTs
insert_pattern = r'INSERT INTO\s+(\w+)'
all_inserts = re.findall(insert_pattern, sql_content, re.IGNORECASE)
tables_used = set(all_inserts)

print(f"   Tables used in INSERTs: {len(tables_used)}")
for table in sorted(tables_used):
    print(f"     - {table}")
print()

# Issue 2: Check for missing CREATE TABLE statements
print("2. Checking if CREATE TABLE exists for each INSERT target...")
print()

create_pattern = r'CREATE TABLE\s+(?:IF NOT EXISTS\s+)?(\w+)'
created_tables = set(re.findall(create_pattern, sql_content, re.IGNORECASE))

print(f"   Tables created in SQL: {len(created_tables)}")
for table in sorted(created_tables):
    print(f"     - {table}")
print()

missing_creates = tables_used - created_tables
if missing_creates:
    print(f"   ⚠️  Tables with INSERTs but no CREATE TABLE:")
    for table in sorted(missing_creates):
        print(f"     - {table}")
        issues.append(f"Table '{table}' has INSERTs but no CREATE TABLE statement")
    print()
else:
    print("   ✓ All INSERT tables have CREATE statements")
    print()

# Issue 3: Check for column mismatches
print("3. Checking for common column errors...")
print()

# Extract first few INSERTs per table and check columns
checked = {}
for table in tables_used:
    pattern = rf'INSERT INTO\s+{table}\s*\((.*?)\)\s*VALUES'
    matches = re.findall(pattern, sql_content, re.DOTALL | re.IGNORECASE)
    if matches:
        first_insert_cols = [c.strip() for c in matches[0].split(',')]
        checked[table] = first_insert_cols[:10]  # First 10 columns

# Known schema columns for key tables
known_columns = {
    'buildings': ['id', 'agency_id', 'name', 'address', 'postcode', 'city', 'country'],
    'units': ['id', 'building_id', 'unit_number'],
    'leases': ['id', 'building_id', 'unit_id', 'term_start', 'term_years', 'expiry_date'],
    'budgets': ['id', 'building_id', 'period', 'start_date', 'end_date', 'year_start', 'year_end'],
    'compliance_assets': ['id', 'building_id', 'asset_name', 'asset_type'],
}

for table, insert_cols in checked.items():
    if table in known_columns:
        expected = known_columns[table]
        for col in expected:
            if col not in insert_cols and col != 'id':  # ID might be generated
                issues.append(f"{table}: Missing expected column '{col}' in INSERT")
                print(f"   ⚠️  {table}: Missing column '{col}'")

if not any(table in checked for table in known_columns):
    print("   ✓ No obvious column issues detected")
print()

# Issue 4: Check for quote escaping issues
print("4. Checking for quote escaping issues...")
print()

# Find strings with apostrophes that might not be escaped
unescaped_pattern = r"'[^']*'[^',)\s][^']*'"
potential_issues = re.findall(unescaped_pattern, sql_content)[:10]

if potential_issues:
    print(f"   ⚠️  Found {len(potential_issues)} potential unescaped quotes")
    for issue in potential_issues[:5]:
        print(f"     {issue[:60]}...")
    print()
else:
    print("   ✓ No obvious quote escaping issues")
    print()

# Issue 5: Check for foreign key constraint errors
print("5. Checking for foreign key issues...")
print()

# building_id should always be present for building-related tables
fk_dependent_tables = ['units', 'leases', 'schedules', 'budgets', 'compliance_assets',
                       'building_documents', 'building_insurance']

for table in fk_dependent_tables:
    if table in checked:
        if 'building_id' not in checked[table]:
            issues.append(f"{table}: Missing required foreign key 'building_id'")
            print(f"   ❌ {table}: Missing 'building_id'")

if not issues:
    print("   ✓ No foreign key issues detected")
print()

# SUMMARY
print("="*70)
print("SUMMARY")
print("="*70)
print()

if issues:
    print(f"❌ Found {len(issues)} potential schema issues:")
    print()
    for i, issue in enumerate(issues[:20], 1):
        print(f"{i}. {issue}")
    if len(issues) > 20:
        print(f"   ... and {len(issues) - 20} more")
else:
    print("✅ No major schema issues detected")
    print()
    print("If Supabase is still rejecting the SQL, the issue may be:")
    print("  1. Check Supabase error logs for specific error message")
    print("  2. Schema differences between local and Supabase")
    print("  3. Permission issues or table ownership")
    print("  4. Unique constraint violations")

print()
print("="*70)
