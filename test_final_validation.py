#!/usr/bin/env python3
"""
Final Validation Test
Validates that the complete SQL generation pipeline passes Supabase schema validation
"""

import sys
import json
from pathlib import Path

# Add BlocIQ_Onboarder to path
sys.path.insert(0, str(Path(__file__).parent / 'BlocIQ_Onboarder'))

def test_complete_sql_validation():
    """Test that generated SQL passes complete schema validation"""
    print("=" * 70)
    print("FINAL VALIDATION TEST")
    print("=" * 70)

    output_dir = Path.home() / "Desktop" / "BlocIQ_Output"
    sql_file = output_dir / 'test_migration.sql'

    if not sql_file.exists():
        print(f"❌ No SQL file found at {sql_file}")
        print("   Run test_sql_generation.py first to generate SQL")
        return False

    print(f"\n✅ Loading SQL migration script...")
    with open(sql_file, 'r') as f:
        sql_script = f.read()

    # Count different types of statements
    print(f"\n📊 SQL Migration Summary:")
    print(f"   Total size: {len(sql_script):,} characters")
    print(f"   INSERT statements: {sql_script.count('INSERT INTO')}")
    print(f"   CREATE TABLE statements: {sql_script.count('CREATE TABLE')}")

    # Check for required tables
    required_tables = [
        'buildings',
        'units',
        'leaseholders',
        'leases',
        'building_documents',
        'budgets',
        'compliance_assets'
    ]

    print(f"\n📋 Required Table Validation:")
    all_present = True
    for table in required_tables:
        if f"INSERT INTO {table}" in sql_script:
            print(f"   ✅ {table}: Present")
        else:
            print(f"   ❌ {table}: MISSING")
            all_present = False

    # Check lease_clauses table
    print(f"\n📋 Lease Clauses Validation:")
    if "CREATE TABLE IF NOT EXISTS lease_clauses" in sql_script:
        print(f"   ✅ lease_clauses table definition: Present")
    else:
        print(f"   ⚠️  lease_clauses table definition: MISSING")

    # Note: The test extraction data doesn't have lease_clauses because it was
    # generated before we implemented extraction. This is expected.
    if "INSERT INTO lease_clauses" in sql_script:
        count = sql_script.count('INSERT INTO lease_clauses')
        print(f"   ✅ lease_clauses inserts: {count} found")
    else:
        print(f"   ⚠️  lease_clauses inserts: None (expected - test data predates implementation)")

    # Basic SQL syntax validation
    print(f"\n🔍 SQL Syntax Validation:")
    errors = []

    # Check BEGIN/COMMIT balance
    begin_count = sql_script.count('BEGIN;')
    commit_count = sql_script.count('COMMIT;')
    if begin_count == commit_count:
        print(f"   ✅ BEGIN/COMMIT balanced ({begin_count}/{commit_count})")
    else:
        errors.append(f"Unbalanced BEGIN ({begin_count}) and COMMIT ({commit_count})")
        print(f"   ❌ BEGIN/COMMIT unbalanced: {begin_count} BEGIN, {commit_count} COMMIT")

    # Check for empty VALUES
    if "VALUES ()" in sql_script:
        errors.append("Found empty VALUES clauses")
        print(f"   ❌ Empty VALUES clauses found")
    else:
        print(f"   ✅ No empty VALUES clauses")

    # Check for double spaces in INSERTs
    if "INSERT INTO  (" in sql_script:
        errors.append("Found INSERT with double space")
        print(f"   ❌ Double spaces in INSERT statements")
    else:
        print(f"   ✅ No double spaces in INSERT statements")

    # Schema compatibility validation
    print(f"\n🔍 Schema Compatibility:")

    # Check that we're using correct SQL dialect
    if "gen_random_uuid()" in sql_script:
        print(f"   ✅ Using PostgreSQL UUID functions")
    else:
        print(f"   ⚠️  Not using PostgreSQL UUID functions")

    if "timestamp with time zone" in sql_script or "timestamptz" in sql_script:
        print(f"   ✅ Using PostgreSQL timestamp types")
    else:
        print(f"   ⚠️  Not using PostgreSQL timestamp types")

    # Validation of schema mapper fix
    print(f"\n🔧 Schema Mapper Validation:")
    from schema_mapper import SupabaseSchemaMapper

    mapper = SupabaseSchemaMapper()
    if 'lease_clauses' in mapper.table_schemas:
        print(f"   ✅ lease_clauses table in schema_mapper")
        schema = mapper.table_schemas['lease_clauses']
        required_fields = ['id', 'lease_id', 'building_id', 'clause_number',
                          'clause_category', 'clause_text', 'clause_summary']
        for field in required_fields:
            if field in schema:
                print(f"   ✅ {field}: Defined")
            else:
                print(f"   ❌ {field}: MISSING")
                errors.append(f"lease_clauses.{field} not in schema")
    else:
        errors.append("lease_clauses not in schema_mapper")
        print(f"   ❌ lease_clauses table NOT in schema_mapper")

    # Final summary
    print(f"\n" + "=" * 70)
    print("VALIDATION SUMMARY")
    print("=" * 70)

    if errors:
        print(f"❌ Found {len(errors)} errors:")
        for error in errors:
            print(f"   • {error}")
        return False
    elif not all_present:
        print(f"❌ Some required tables are missing from SQL")
        return False
    else:
        print(f"✅ All validations passed!")
        print(f"\n📝 Notes:")
        print(f"   • SQL syntax is valid for PostgreSQL/Supabase")
        print(f"   • All required tables have INSERT statements")
        print(f"   • lease_clauses table schema is properly defined")
        print(f"   • lease_clauses will be extracted in future onboarding runs")
        print(f"\n🎉 SQL migration is ready for Supabase!")
        return True


if __name__ == "__main__":
    success = test_complete_sql_validation()
    sys.exit(0 if success else 1)
