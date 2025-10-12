#!/usr/bin/env python3
"""
Test SQL Migration Against Supabase Schema
Validates generated SQL against actual schema requirements
"""

import json
import re
import sys

def load_schema(schema_path):
    """Load Supabase schema JSON"""
    with open(schema_path, 'r') as f:
        return json.load(f)

def load_sql(sql_path):
    """Load SQL migration file"""
    with open(sql_path, 'r') as f:
        return f.read()

def extract_inserts(sql_content):
    """Extract INSERT statements from SQL"""
    # Match INSERT INTO ... VALUES statements
    pattern = r'INSERT INTO\s+(\w+)\s*\((.*?)\)\s*VALUES\s*\((.*?)\);'
    matches = re.findall(pattern, sql_content, re.DOTALL | re.IGNORECASE)

    inserts = []
    for table, columns, values in matches:
        cols = [c.strip() for c in columns.split(',')]
        inserts.append({
            'table': table,
            'columns': cols,
            'values': values
        })

    return inserts

def validate_table_columns(inserts, schema):
    """Validate that INSERT columns match schema"""
    errors = []
    warnings = []

    # Build schema lookup
    tables_schema = {}
    for table_def in schema.get('tables', []):
        table_name = table_def.get('name')
        tables_schema[table_name] = {
            'columns': {col['name']: col for col in table_def.get('columns', [])},
            'primary_key': table_def.get('primary_key', [])
        }

    # Check each INSERT
    for insert in inserts:
        table = insert['table']
        columns = insert['columns']

        if table not in tables_schema:
            warnings.append(f"Table '{table}' not found in schema (may be created by migration)")
            continue

        schema_cols = tables_schema[table]['columns']

        # Check for unknown columns
        for col in columns:
            if col not in schema_cols:
                errors.append(f"{table}: Column '{col}' does not exist in schema")

        # Check for missing NOT NULL columns
        for col_name, col_def in schema_cols.items():
            if col_def.get('is_nullable') is False and col_def.get('default_value') is None:
                # This is a required column with no default
                if col_name not in columns:
                    errors.append(f"{table}: Missing required column '{col_name}' (NOT NULL, no default)")

    return errors, warnings

def validate_data_types(inserts, schema):
    """Validate data types in INSERT values"""
    errors = []

    # This is complex - for now just check for obvious issues
    for insert in inserts:
        table = insert['table']
        values_str = insert['values']

        # Check for unquoted UUIDs (should be quoted)
        uuid_pattern = r'\b[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}\b'
        if re.search(uuid_pattern, values_str, re.IGNORECASE):
            # Check if it's quoted
            if not re.search(r"'[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}'", values_str, re.IGNORECASE):
                errors.append(f"{table}: Unquoted UUID found (must be quoted)")

    return errors

def main():
    schema_path = '/Users/ellie/onboardingblociq/supabase_current_schema.json'
    sql_path = '/Users/ellie/Desktop/BlocIQ_Output/migration.sql'

    print("Loading schema and SQL...")
    try:
        schema = load_schema(schema_path)
        sql_content = load_sql(sql_path)
    except FileNotFoundError as e:
        print(f"❌ File not found: {e}")
        return 1

    print(f"✓ Loaded schema with {len(schema.get('tables', []))} tables")

    print("\nExtracting INSERT statements...")
    inserts = extract_inserts(sql_content)
    print(f"✓ Found {len(inserts)} INSERT statements")

    # Group by table
    tables = {}
    for insert in inserts:
        table = insert['table']
        if table not in tables:
            tables[table] = 0
        tables[table] += 1

    print("\nINSERT statement breakdown:")
    for table, count in sorted(tables.items()):
        print(f"  {table}: {count} inserts")

    print("\n" + "="*60)
    print("VALIDATION RESULTS")
    print("="*60)

    # Validate columns
    print("\n1. Validating columns against schema...")
    col_errors, col_warnings = validate_table_columns(inserts, schema)

    if col_errors:
        print(f"\n❌ Found {len(col_errors)} column errors:")
        for error in col_errors[:20]:  # Limit to first 20
            print(f"  • {error}")
        if len(col_errors) > 20:
            print(f"  ... and {len(col_errors) - 20} more")
    else:
        print("✓ No column errors found")

    if col_warnings:
        print(f"\n⚠️  Found {len(col_warnings)} warnings:")
        for warning in col_warnings[:10]:
            print(f"  • {warning}")
        if len(col_warnings) > 10:
            print(f"  ... and {len(col_warnings) - 10} more")

    # Validate data types
    print("\n2. Validating data types...")
    type_errors = validate_data_types(inserts, schema)

    if type_errors:
        print(f"❌ Found {len(type_errors)} type errors:")
        for error in type_errors[:10]:
            print(f"  • {error}")
        if len(type_errors) > 10:
            print(f"  ... and {len(type_errors) - 10} more")
    else:
        print("✓ No type errors found")

    # Summary
    print("\n" + "="*60)
    total_errors = len(col_errors) + len(type_errors)
    if total_errors > 0:
        print(f"❌ VALIDATION FAILED: {total_errors} errors found")
        return 1
    else:
        print("✅ VALIDATION PASSED: SQL is schema-compliant")
        return 0

if __name__ == '__main__':
    sys.exit(main())
