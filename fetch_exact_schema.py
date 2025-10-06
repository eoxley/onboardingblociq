#!/usr/bin/env python3
"""
Fetch exact column definitions from Supabase information_schema
This will show us EXACTLY what columns exist in each table
"""
from supabase import create_client
import json

SUPABASE_URL = "https://aewixchhykxyhqjvqoek.supabase.co"
SUPABASE_KEY = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImFld2l4Y2hoeWt4eWhxanZxb2VrIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTc1OTUwMjUxNiwiZXhwIjoyMDc1MDc4NTE2fQ.lqLBt_R8GRnI_iMela4RAEfgcJ8Ple6WwmWBqrAa56o"

print("=" * 80)
print("FETCHING EXACT SUPABASE SCHEMA FROM information_schema")
print("=" * 80)

supabase = create_client(SUPABASE_URL, SUPABASE_KEY)

# Tables we care about for migration
tables_to_check = [
    'buildings',
    'units',
    'leaseholders',
    'compliance_assets',
    'building_compliance_assets',
    'building_documents',
    'major_works_projects'
]

schema_map = {}

for table_name in tables_to_check:
    print(f"\n📋 {table_name.upper()}")
    print("-" * 80)

    # Query information_schema.columns
    query = f"""
    SELECT column_name, data_type, is_nullable, column_default
    FROM information_schema.columns
    WHERE table_schema = 'public'
    AND table_name = '{table_name}'
    ORDER BY ordinal_position;
    """

    try:
        result = supabase.rpc('exec_sql', {'query': query}).execute()

        if result.data:
            columns = {}
            print(f"Columns:")
            for row in result.data:
                col_name = row.get('column_name')
                data_type = row.get('data_type')
                nullable = row.get('is_nullable')
                default = row.get('column_default')

                columns[col_name] = {
                    'type': data_type,
                    'nullable': nullable,
                    'default': default
                }

                null_marker = '' if nullable == 'YES' else ' NOT NULL'
                default_marker = f' DEFAULT {default[:30]}' if default else ''
                print(f"  • {col_name:30} {data_type:20}{null_marker}{default_marker}")

            schema_map[table_name] = columns
        else:
            print("  (Could not fetch schema)")

    except Exception as e:
        print(f"  ⚠️  Error: {str(e)[:100]}")
        print("  Trying alternative method...")

        # Alternative: Try to get from a sample record
        try:
            sample = supabase.table(table_name).select('*').limit(1).execute()
            if sample.data and len(sample.data) > 0:
                columns = list(sample.data[0].keys())
                schema_map[table_name] = {col: {'type': 'unknown', 'nullable': 'unknown', 'default': None} for col in columns}
                print(f"  Columns (from sample data):")
                for col in sorted(columns):
                    print(f"  • {col}")
            else:
                print("  (No data available to infer schema)")
        except Exception as e2:
            print(f"  ✗ Could not access table: {str(e2)[:80]}")

# Save to JSON for reference
with open('output/supabase_actual_schema.json', 'w') as f:
    json.dump(schema_map, f, indent=2)

print("\n" + "=" * 80)
print("✅ Schema saved to output/supabase_actual_schema.json")
print("=" * 80)
