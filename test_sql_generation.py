#!/usr/bin/env python3
"""
Test SQL Generation and Validation
Tests the complete SQL generation pipeline with real extraction data
"""

import sys
import os
from pathlib import Path
import json

# Add BlocIQ_Onboarder to path
sys.path.insert(0, str(Path(__file__).parent / 'BlocIQ_Onboarder'))

def test_sql_generation_from_extraction():
    """Test SQL generation using real extraction data"""
    print("=" * 70)
    print("TEST: SQL Generation from Real Extraction Data")
    print("=" * 70)

    # Check if we have extraction data
    output_dir = Path.home() / "Desktop" / "BlocIQ_Output"

    if not output_dir.exists():
        print(f"❌ No extraction data found at {output_dir}")
        print("   Please run the onboarder first to generate extraction data")
        return False

    # Load mapped_data.json
    mapped_data_file = output_dir / 'mapped_data.json'
    if not mapped_data_file.exists():
        print(f"❌ No mapped_data.json found at {mapped_data_file}")
        return False

    print(f"✅ Loading mapped data from {mapped_data_file}")
    with open(mapped_data_file, 'r') as f:
        mapped_data = json.load(f)

    # Print summary of what we have
    print(f"\n📊 Extraction Summary:")
    print(f"   Building: {mapped_data.get('building', {}).get('name', 'Unknown')}")
    print(f"   Units: {len(mapped_data.get('units', []))}")
    print(f"   Leaseholders: {len(mapped_data.get('leaseholders', []))}")
    print(f"   Leases: {len(mapped_data.get('leases', []))}")
    print(f"   Lease Clauses: {len(mapped_data.get('lease_clauses', []))}")
    print(f"   Budgets: {len(mapped_data.get('budgets', []))}")
    print(f"   Compliance Assets: {len(mapped_data.get('compliance_assets', []))}")
    print(f"   Building Documents: {len(mapped_data.get('building_documents', []))}")

    # Generate SQL
    print(f"\n📝 Generating SQL migration script...")
    from sql_writer import SQLWriter

    sql_writer = SQLWriter()
    sql_script = sql_writer.generate_migration(mapped_data)

    # Save to file
    output_sql = output_dir / 'test_migration.sql'
    with open(output_sql, 'w') as f:
        f.write(sql_script)

    print(f"✅ SQL script generated: {output_sql}")
    print(f"   Script size: {len(sql_script):,} characters")

    # Count statements
    insert_count = sql_script.count('INSERT INTO')
    create_count = sql_script.count('CREATE TABLE')
    alter_count = sql_script.count('ALTER TABLE')

    print(f"\n📊 SQL Statement Summary:")
    print(f"   INSERT statements: {insert_count}")
    print(f"   CREATE statements: {create_count}")
    print(f"   ALTER statements: {alter_count}")

    # Check for lease_clauses
    if 'INSERT INTO lease_clauses' in sql_script:
        lease_clause_inserts = sql_script.count('INSERT INTO lease_clauses')
        print(f"   ✅ Lease clause inserts: {lease_clause_inserts}")
    else:
        print(f"   ⚠️  No lease_clauses inserts found")

    return True


def test_schema_validation():
    """Test schema validation of generated SQL"""
    print("\n" + "=" * 70)
    print("TEST: Schema Validation")
    print("=" * 70)

    output_dir = Path.home() / "Desktop" / "BlocIQ_Output"
    mapped_data_file = output_dir / 'mapped_data.json'

    if not mapped_data_file.exists():
        print(f"❌ No mapped_data.json found")
        return False

    print(f"✅ Loading mapped data...")
    with open(mapped_data_file, 'r') as f:
        mapped_data = json.load(f)

    # Validate against schema
    print(f"\n🔍 Validating data against Supabase schema...")
    from schema_validator import SchemaValidator

    validator = SchemaValidator()

    # Check tables individually
    validation_result = {
        'valid': True,
        'errors': [],
        'warnings': [],
        'tables_validated': 0
    }

    # Validate each table in mapped_data
    for table_name, records in mapped_data.items():
        if table_name == 'building':
            # Building is a single dict, not a list
            records = [records] if isinstance(records, dict) else []

        if not isinstance(records, list):
            continue

        validation_result['tables_validated'] += 1

        for i, record in enumerate(records):
            try:
                validated = validator.validate_and_transform(table_name, record)
                if not validated:
                    validation_result['valid'] = False
                    validation_result['errors'].append({
                        'table': table_name,
                        'record': i,
                        'error': 'Validation returned empty result'
                    })
            except Exception as e:
                validation_result['valid'] = False
                validation_result['errors'].append({
                    'table': table_name,
                    'record': i,
                    'error': str(e)
                })

    # Print results
    if validation_result['valid']:
        print(f"✅ Validation PASSED!")
        print(f"   All {validation_result['tables_validated']} tables validated successfully")
    else:
        print(f"⚠️  Validation found {len(validation_result['errors'])} errors:")
        for error in validation_result['errors'][:10]:  # Show first 10
            print(f"   • {error['table']}.{error.get('field', 'N/A')}: {error['error']}")

        if len(validation_result['errors']) > 10:
            print(f"   ... and {len(validation_result['errors']) - 10} more errors")

    # Save validation report
    validation_file = output_dir / 'test_validation_report.json'
    with open(validation_file, 'w') as f:
        json.dump(validation_result, f, indent=2)

    print(f"\n📄 Full validation report: {validation_file}")

    return validation_result['valid']


def test_sql_syntax():
    """Test SQL syntax by attempting to parse it"""
    print("\n" + "=" * 70)
    print("TEST: SQL Syntax Check")
    print("=" * 70)

    output_dir = Path.home() / "Desktop" / "BlocIQ_Output"
    sql_file = output_dir / 'test_migration.sql'

    if not sql_file.exists():
        print(f"❌ No SQL file found at {sql_file}")
        return False

    print(f"✅ Reading SQL file...")
    with open(sql_file, 'r') as f:
        sql_script = f.read()

    # Basic syntax checks
    errors = []

    # Check for balanced BEGIN/COMMIT
    begin_count = sql_script.count('BEGIN;')
    commit_count = sql_script.count('COMMIT;')
    if begin_count != commit_count:
        errors.append(f"Unbalanced BEGIN ({begin_count}) and COMMIT ({commit_count})")

    # Check for common SQL errors
    if "INSERT INTO  (" in sql_script:
        errors.append("Found INSERT with double space before parenthesis")

    if "VALUES ()" in sql_script:
        errors.append("Found empty VALUES clause")

    # Check for required tables
    required_tables = ['buildings', 'units', 'leases', 'building_documents']
    for table in required_tables:
        if f"INSERT INTO {table}" not in sql_script:
            errors.append(f"Missing INSERT for required table: {table}")

    if errors:
        print(f"⚠️  Found {len(errors)} syntax issues:")
        for error in errors:
            print(f"   • {error}")
        return False
    else:
        print(f"✅ SQL syntax checks PASSED!")
        return True


def test_lease_clauses_schema():
    """Test that lease_clauses data matches schema requirements"""
    print("\n" + "=" * 70)
    print("TEST: Lease Clauses Schema Compliance")
    print("=" * 70)

    output_dir = Path.home() / "Desktop" / "BlocIQ_Output"
    mapped_data_file = output_dir / 'mapped_data.json'

    if not mapped_data_file.exists():
        print(f"❌ No mapped_data.json found")
        return False

    with open(mapped_data_file, 'r') as f:
        mapped_data = json.load(f)

    lease_clauses = mapped_data.get('lease_clauses', [])

    if not lease_clauses:
        print(f"⚠️  No lease_clauses found in mapped data")
        return False

    print(f"✅ Found {len(lease_clauses)} lease clauses")

    # Check required fields
    required_fields = ['id', 'lease_id', 'building_id']
    errors = []

    for i, clause in enumerate(lease_clauses[:5]):  # Check first 5
        for field in required_fields:
            if field not in clause or not clause[field]:
                errors.append(f"Clause {i}: missing required field '{field}'")

        # Check field types
        if 'clause_number' in clause and clause['clause_number']:
            if not isinstance(clause['clause_number'], str):
                errors.append(f"Clause {i}: clause_number should be string, got {type(clause['clause_number'])}")

    if errors:
        print(f"⚠️  Found {len(errors)} schema issues:")
        for error in errors[:10]:
            print(f"   • {error}")
        return False
    else:
        print(f"✅ Lease clauses schema checks PASSED!")
        print(f"\n   Sample clause:")
        if lease_clauses:
            sample = lease_clauses[0]
            print(f"   • Clause {sample.get('clause_number', 'N/A')}: {sample.get('clause_category', 'N/A')}")
            print(f"   • Text: {sample.get('clause_text', 'N/A')[:60]}...")
        return True


def main():
    """Run all SQL generation tests"""
    print("\n🧪 BlocIQ SQL Generation Test Suite")
    print("=" * 70)

    results = []

    # Test 1: Generate SQL from extraction data
    try:
        result = test_sql_generation_from_extraction()
        results.append(("SQL Generation", result))
    except Exception as e:
        print(f"❌ SQL Generation test failed with error: {e}")
        import traceback
        traceback.print_exc()
        results.append(("SQL Generation", False))

    # Test 2: Validate schema
    try:
        result = test_schema_validation()
        results.append(("Schema Validation", result))
    except Exception as e:
        print(f"❌ Schema validation test failed with error: {e}")
        import traceback
        traceback.print_exc()
        results.append(("Schema Validation", False))

    # Test 3: Check SQL syntax
    try:
        result = test_sql_syntax()
        results.append(("SQL Syntax Check", result))
    except Exception as e:
        print(f"❌ SQL syntax test failed with error: {e}")
        import traceback
        traceback.print_exc()
        results.append(("SQL Syntax Check", False))

    # Test 4: Check lease clauses
    try:
        result = test_lease_clauses_schema()
        results.append(("Lease Clauses Schema", result))
    except Exception as e:
        print(f"❌ Lease clauses test failed with error: {e}")
        import traceback
        traceback.print_exc()
        results.append(("Lease Clauses Schema", False))

    # Summary
    print("\n" + "=" * 70)
    print("TEST SUMMARY")
    print("=" * 70)

    for test_name, result in results:
        status = "✅ PASS" if result else "❌ FAIL"
        print(f"{status}: {test_name}")

    passed = sum(1 for _, r in results if r)
    failed = sum(1 for _, r in results if not r)

    print(f"\nTotal: {passed} passed, {failed} failed")

    if failed == 0:
        print("\n🎉 All tests passed! SQL is ready for Supabase.")
    else:
        print("\n⚠️  Some tests failed. Review errors above.")

    return failed == 0


if __name__ == "__main__":
    success = main()
    sys.exit(0 if success else 1)
