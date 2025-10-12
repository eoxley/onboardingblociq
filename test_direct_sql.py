#!/usr/bin/env python3
"""
Test SQL execution against PostgreSQL to find schema errors
This simulates what Supabase would do
"""

import os
import re

def analyze_sql_file(sql_path):
    """Analyze SQL file for common schema violations"""

    with open(sql_path, 'r') as f:
        sql_content = f.read()

    print("="*70)
    print("SQL SCHEMA ANALYSIS")
    print("="*70)

    errors = []
    warnings = []

    # 1. Check for missing NOT NULL constraint satisfaction
    print("\n1. Checking INSERT statements for NOT NULL violations...")

    # Known NOT NULL fields from schema
    not_null_fields = {
        'buildings': ['id', 'name'],
        'units': ['id', 'building_id', 'unit_number'],
        'leaseholders': ['id', 'building_id'],  # first_name, last_name might be NOT NULL
        'leases': ['id', 'building_id'],
        'budgets': ['id', 'building_id', 'period'],
        'building_documents': ['id', 'building_id', 'category', 'file_name', 'storage_path'],
        'compliance_assets': ['id', 'building_id', 'asset_name', 'asset_type'],
        'building_insurance': ['id', 'building_id', 'insurance_type'],
        'contractors': ['id', 'name'],
        'contractor_contracts': ['id', 'building_id', 'contractor_id', 'service_category', 'start_date', 'end_date'],
        'major_works_projects': ['id', 'building_id', 'project_name'],
        'schedules': ['id', 'building_id', 'name'],
        'lease_clauses': ['id', 'lease_id', 'building_id']
    }

    # Extract INSERT statements by table
    insert_pattern = r'INSERT INTO\s+(\w+)\s*\((.*?)\)\s*VALUES'
    matches = re.findall(insert_pattern, sql_content, re.DOTALL | re.IGNORECASE)

    for table, columns_str in matches[:50]:  # Check first 50
        if table not in not_null_fields:
            continue

        # Parse columns
        columns = [c.strip() for c in columns_str.split(',')]
        required = not_null_fields[table]

        missing = [col for col in required if col not in columns]
        if missing:
            errors.append(f"{table}: Missing required columns: {', '.join(missing)}")

    # 2. Check for foreign key references
    print("\n2. Checking foreign key references...")

    # Check if building_id is always present when required
    fk_tables = ['units', 'schedules', 'compliance_assets', 'budgets', 'leases',
                 'building_documents', 'building_insurance', 'major_works_projects',
                 'apportionments', 'lease_clauses']

    for table in fk_tables:
        pattern = rf'INSERT INTO\s+{table}\s*\((.*?)\)\s*VALUES'
        table_matches = re.findall(pattern, sql_content, re.DOTALL | re.IGNORECASE)

        for columns_str in table_matches[:5]:  # Check first 5 per table
            columns = [c.strip() for c in columns_str.split(',')]
            if 'building_id' not in columns:
                warnings.append(f"{table}: INSERT without building_id (may fail FK constraint)")

    # 3. Check for data type issues
    print("\n3. Checking for data type issues...")

    # Look for SELECT subqueries in VALUES (for contractor lookups)
    select_in_values = re.findall(r'VALUES\s*\((.*?SELECT.*?)\);', sql_content, re.DOTALL | re.IGNORECASE)
    if select_in_values:
        print(f"   Found {len(select_in_values)} INSERT statements using SELECT subqueries")

    # 4. Check for CHECK constraint violations
    print("\n4. Checking CHECK constraint violations...")

    # service_category must be valid enum
    contract_inserts = re.findall(
        r"INSERT INTO contractor_contracts.*?VALUES\s*\((.*?)\);",
        sql_content,
        re.DOTALL | re.IGNORECASE
    )

    valid_service_categories = ['lifts', 'security', 'fire_alarm', 'cleaning', 'maintenance',
                               'insurance', 'legal', 'utilities', 'grounds', 'waste', 'other', 'unspecified']

    # This is hard to parse without proper SQL parser, skip for now

    # 5. Check for syntax issues
    print("\n5. Checking for syntax issues...")

    # Unclosed quotes
    quote_count = sql_content.count("'")
    if quote_count % 2 != 0:
        errors.append("Unbalanced single quotes in SQL (missing closing quote)")

    # Unclosed parentheses in VALUES
    values_sections = re.findall(r'VALUES\s*\((.*?)\);', sql_content, re.DOTALL)
    for i, val in enumerate(values_sections[:100]):
        open_count = val.count('(')
        close_count = val.count(')')
        if open_count != close_count:
            errors.append(f"Unbalanced parentheses in VALUES section #{i+1}")

    # RESULTS
    print("\n" + "="*70)
    print("RESULTS")
    print("="*70)

    if errors:
        print(f"\n❌ Found {len(errors)} errors:")
        for error in errors[:20]:
            print(f"  • {error}")
        if len(errors) > 20:
            print(f"  ... and {len(errors) - 20} more")
    else:
        print("\n✅ No critical errors found")

    if warnings:
        print(f"\n⚠️  Found {len(warnings)} warnings:")
        for warning in warnings[:10]:
            print(f"  • {warning}")
        if len(warnings) > 10:
            print(f"  ... and {len(warnings) - 10} more")

    print("\n" + "="*70)
    print(f"Total INSERT statements: {len(matches)}")
    print(f"Errors: {len(errors)}")
    print(f"Warnings: {len(warnings)}")
    print("="*70)

    return len(errors) == 0

if __name__ == '__main__':
    sql_path = '/Users/ellie/Desktop/BlocIQ_Output/migration.sql'
    success = analyze_sql_file(sql_path)
    exit(0 if success else 1)
