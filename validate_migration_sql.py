#!/usr/bin/env python3
"""
Validate generated migration.sql against BlocIQ V2 schema
Checks for required columns and proper structure
"""
import re
from collections import defaultdict

# BlocIQ V2 Required Columns
SCHEMA_V2 = {
    'buildings': ['id', 'name', 'address'],
    'units': ['id', 'building_id', 'unit_number'],
    'leaseholders': ['id', 'building_id', 'unit_number'],  # Note: unit_id removed in favor of building_id + unit_number
    'portfolios': ['id', 'agency_id', 'name'],
    'building_documents': ['id', 'building_id', 'category'],
    'compliance_assets': ['id', 'building_id', 'category'],
    'building_compliance_assets': ['building_id', 'compliance_asset_id'],
    'major_works_projects': ['id', 'building_id'],
    'major_works_notices': ['building_id', 'project_id', 'document_id'],
    'budgets': ['id', 'building_id'],
    'apportionments': ['id', 'building_id', 'unit_id', 'budget_id']
}

def extract_insert_statements(sql_content):
    """Extract INSERT statements from SQL"""
    # Match INSERT INTO table_name (...) VALUES (...)
    pattern = r'INSERT INTO\s+(\w+)\s*\(([^)]+)\)\s*VALUES'
    matches = re.finditer(pattern, sql_content, re.IGNORECASE)

    inserts = defaultdict(list)
    for match in matches:
        table = match.group(1).lower()
        columns = [col.strip() for col in match.group(2).split(',')]
        inserts[table].append(columns)

    return inserts

def validate_migration_sql(sql_path):
    """Validate migration SQL against BlocIQ V2 schema"""
    print("=" * 70)
    print("VALIDATING MIGRATION SQL AGAINST BlocIQ V2 SCHEMA")
    print("=" * 70)

    with open(sql_path, 'r') as f:
        sql_content = f.read()

    # Extract INSERT statements
    inserts = extract_insert_statements(sql_content)

    print(f"\n📊 Found INSERT statements for {len(inserts)} tables:\n")

    errors = []
    warnings = []

    for table, column_sets in inserts.items():
        print(f"  ✓ {table}: {len(column_sets)} INSERT(s)")

        # Check if table is in expected schema
        if table not in SCHEMA_V2:
            warnings.append(f"Table '{table}' not in BlocIQ V2 schema (might be OK if custom table)")
            continue

        # Check required columns
        required_cols = SCHEMA_V2[table]

        for idx, columns in enumerate(column_sets):
            missing_cols = [col for col in required_cols if col not in columns]
            if missing_cols:
                errors.append(
                    f"Table '{table}' INSERT #{idx+1} missing required columns: {missing_cols}\n"
                    f"   Has: {columns}\n"
                    f"   Needs: {required_cols}"
                )

    # Check for agency/portfolio placeholders
    print("\n🔍 Checking for placeholders...")
    if 'AGENCY_ID_PLACEHOLDER' in sql_content:
        print("  ⚠️  AGENCY_ID_PLACEHOLDER found (needs replacement)")
        warnings.append("AGENCY_ID_PLACEHOLDER needs to be replaced with actual agency UUID")
    else:
        print("  ✓ No AGENCY_ID_PLACEHOLDER (already replaced or using hardcoded value)")

    if 'PORTFOLIO_ID_PLACEHOLDER' in sql_content:
        print("  ⚠️  PORTFOLIO_ID_PLACEHOLDER found (needs replacement)")
        warnings.append("PORTFOLIO_ID_PLACEHOLDER needs to be replaced with actual portfolio UUID")
    else:
        print("  ✓ No PORTFOLIO_ID_PLACEHOLDER")

    # Summary
    print("\n" + "=" * 70)
    print("VALIDATION SUMMARY")
    print("=" * 70)

    if errors:
        print(f"\n❌ {len(errors)} ERROR(S) FOUND:\n")
        for i, error in enumerate(errors, 1):
            print(f"{i}. {error}\n")
    else:
        print("\n✅ No schema errors found!")

    if warnings:
        print(f"\n⚠️  {len(warnings)} WARNING(S):\n")
        for i, warning in enumerate(warnings, 1):
            print(f"{i}. {warning}")

    print("\n" + "=" * 70)

    return len(errors) == 0

if __name__ == "__main__":
    sql_path = "output/migration.sql"
    valid = validate_migration_sql(sql_path)

    if valid:
        print("\n✅ Migration SQL is valid and ready for insertion!")
        print("\n📝 Next steps:")
        print("   1. Replace AGENCY_ID_PLACEHOLDER with your agency UUID")
        print("   2. Replace PORTFOLIO_ID_PLACEHOLDER with your portfolio UUID")
        print("   3. Run the SQL in Supabase SQL Editor")
        exit(0)
    else:
        print("\n❌ Migration SQL has errors - fix before inserting!")
        exit(1)
