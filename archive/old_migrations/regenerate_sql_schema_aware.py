#!/usr/bin/env python3
"""
Regenerate SQL migration with FULL schema validation
Extracts data from existing migration and rebuilds with actual schema
"""
import json
import re
from datetime import datetime

print("=" * 70)
print("BlocIQ Schema-Validated SQL Regenerator")
print("=" * 70)

# Load schema
print("\n📋 Loading Supabase schema...")
with open('supabase_current_schema.json', 'r') as f:
    schema = json.load(f)

def get_valid_columns(table_name):
    """Get list of valid column names for a table"""
    if table_name not in schema:
        return None
    return [col['name'] for col in schema[table_name]['columns']]

def validate_insert_statement(line):
    """
    Validate and fix an INSERT statement against actual schema
    Returns (fixed_line, warnings)
    """
    # Extract table name
    table_match = re.match(r'INSERT INTO (\w+)\s*\(([^)]+)\)', line)
    if not table_match:
        return line, []

    table_name = table_match.group(1)
    columns_str = table_match.group(2)

    # Get valid columns for this table
    valid_columns = get_valid_columns(table_name)
    if valid_columns is None:
        return line, [f"Table {table_name} not in schema"]

    # Parse column list
    columns = [c.strip() for c in columns_str.split(',')]

    # Check which columns are invalid
    invalid_columns = []
    valid_column_indices = []
    for i, col in enumerate(columns):
        if col in valid_columns:
            valid_column_indices.append(i)
        else:
            invalid_columns.append(col)

    if not invalid_columns:
        return line, []  # All columns are valid

    # If we have invalid columns, we need to remove them and their corresponding values
    # This is complex for multi-line INSERTS, so for now, comment out the line
    warnings = [f"Table {table_name} has invalid columns: {', '.join(invalid_columns)}"]
    return f"-- SKIPPED (invalid columns): {line}", warnings

# Read the existing migration
print("\n📄 Reading existing migration...")
with open('output/migration_final3.sql', 'r') as f:
    original_sql = f.read()

# Process line by line
print("\n🔧 Validating and fixing SQL statements...")
fixed_lines = []
total_warnings = []
skipped_count = 0

for line in original_sql.split('\n'):
    if line.strip().startswith('INSERT INTO'):
        fixed_line, warnings = validate_insert_statement(line)
        fixed_lines.append(fixed_line)
        if warnings:
            total_warnings.extend(warnings)
            if fixed_line.startswith('--'):
                skipped_count += 1
    else:
        fixed_lines.append(line)

fixed_sql = '\n'.join(fixed_lines)

# Apply known fixes
print("\n🔨 Applying known schema corrections...")

# Fix 1: major_works_projects
fixed_sql = fixed_sql.replace(
    "INSERT INTO major_works_projects (id, building_id, name,",
    "INSERT INTO major_works_projects (id, building_id, project_name,"
)
fixed_sql = re.sub(
    r"(INSERT INTO major_works_projects[^;]+)'planning'",
    lambda m: m.group(0).replace("'planning'", "'planned'"),
    fixed_sql
)

# Fix 2: building_documents
fixed_sql = fixed_sql.replace("file_path)", "storage_path)")
fixed_sql = fixed_sql.replace("file_path,", "storage_path,")

# Remove CREATE TABLE statements for tables that already exist
fixed_sql = re.sub(
    r'-- ={50,}\n-- CREATE (MAJOR_WORKS_PROJECTS|ASSETS) TABLE.*?(?=\n-- Insert)',
    '',
    fixed_sql,
    flags=re.DOTALL
)

# Save the validated migration
output_file = 'output/migration_validated.sql'
with open(output_file, 'w') as f:
    f.write(f"-- BlocIQ Schema-Validated Migration\n")
    f.write(f"-- Generated: {datetime.now().isoformat()}\n")
    f.write(f"-- Validated against actual Supabase schema\n")
    f.write(f"-- Skipped {skipped_count} statements with invalid columns\n")
    f.write(f"--\n\n")
    f.write(fixed_sql)

print(f"\n✅ Generated: {output_file}")
print(f"\n📊 Summary:")
print(f"  - Total warnings: {len(total_warnings)}")
print(f"  - Skipped statements: {skipped_count}")
print(f"  - Fixed major_works_projects column names")
print(f"  - Fixed building_documents column names")

if total_warnings:
    print(f"\n⚠️  Unique issues found:")
    unique_warnings = list(set(total_warnings))[:10]  # Show first 10 unique
    for warning in unique_warnings:
        print(f"  - {warning}")

print(f"\n" + "=" * 70)
print("✅ Validation Complete!")
print("=" * 70)
print(f"\nNext step: Execute the validated migration")
print(f"  python3 execute_migration_pg8000.py")
