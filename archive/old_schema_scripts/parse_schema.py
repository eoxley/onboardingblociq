"""
Parse the schema export and generate correct schema mappings
"""

import json

# Parse the schema export text
with open('/Users/ellie/onboardingblociq/supabase_schema_export.txt', 'r') as f:
    lines = f.readlines()

schemas = {}
current_table = None

for line in lines[1:]:  # Skip header
    line = line.strip()
    if not line or line.startswith('(') or line.startswith('-'):
        continue

    parts = [p.strip() for p in line.split('|')]
    if len(parts) < 4:
        continue

    table_name = parts[0].strip()
    column_name = parts[1].strip()
    data_type = parts[2].strip()
    is_nullable = parts[3].strip()
    column_default = parts[4].strip() if len(parts) > 4 else ''

    if not table_name or not column_name:
        continue

    if table_name not in schemas:
        schemas[table_name] = {}

    # Build schema string
    schema_str = data_type

    # Add NOT NULL
    if is_nullable == 'NO':
        schema_str += " NOT NULL"

    # Add default
    if column_default and column_default != '':
        schema_str += f" DEFAULT {column_default}"

    schemas[table_name][column_name] = schema_str

# Generate Python code
python_lines = []
python_lines.append("# AUTO-GENERATED FROM ACTUAL SUPABASE DATABASE SCHEMA")
python_lines.append("# Source: supabase_schema_export.txt")
python_lines.append("")
python_lines.append("SUPABASE_ACTUAL_SCHEMAS = {")

for table_name in sorted(schemas.keys()):
    python_lines.append(f"    '{table_name}': {{")
    for col_name, col_schema in sorted(schemas[table_name].items()):
        # Escape single quotes in schema string
        escaped_schema = col_schema.replace("'", "\\'")
        python_lines.append(f"        '{col_name}': '{escaped_schema}',")
    python_lines.append("    },")

python_lines.append("}")

python_code = "\n".join(python_lines)

# Write to file
with open('/Users/ellie/onboardingblociq/supabase_actual_schema.py', 'w') as f:
    f.write(python_code)

print(f"✅ Generated schema mappings for {len(schemas)} tables")
print(f"📝 Written to supabase_actual_schema.py")

# Also write JSON
with open('/Users/ellie/onboardingblociq/supabase_schema.json', 'w') as f:
    json.dump(schemas, f, indent=2)

print(f"📋 Written JSON to supabase_schema.json")

# Print key mismatches
print("\n🔍 Key schema mismatches found:")
print("\n1. major_works_projects:")
print("   - Actual column: 'name' (nullable)")
print("   - Generator uses: 'project_name'")
print("   - Both columns exist in actual schema!")

print("\n2. budgets:")
print("   - period: text NOT NULL")
print("   - Many other fields are nullable")

print("\n3. leases:")
print("   - unit_number: text NOT NULL")
print("   - leaseholder_name: text NOT NULL")
print("   - start_date: date NOT NULL")
print("   - end_date: date NOT NULL")
print("   - ground_rent: text NOT NULL")
print("   - service_charge_percentage: numeric NOT NULL")
print("   - file_path: text NOT NULL")

print("\n4. compliance_assets:")
print("   - asset_name: character varying NOT NULL")
print("   - asset_type: character varying NOT NULL")
print("   - inspection_frequency: character varying NOT NULL")
print("   - category: character varying (nullable)")

print("\n5. building_documents:")
print("   - category: text NOT NULL DEFAULT 'other'::text")
print("   - file_size: bigint NOT NULL DEFAULT 0")
print("   - uploaded_at: timestamptz NOT NULL DEFAULT now()")
print("   - uploaded_by: text NOT NULL DEFAULT 'Unknown'::text")
print("   - ocr_status: text NOT NULL DEFAULT 'pending'::text")
