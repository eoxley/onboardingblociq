#!/usr/bin/env python3
"""
Get complete Supabase schema for tables we're using
This will show all columns and their NOT NULL constraints
"""

import os
import sys
from dotenv import load_dotenv
from supabase import create_client

load_dotenv()

def get_table_schema(supabase, table_name):
    """Get schema for a specific table"""
    try:
        # Query information_schema to get column details
        result = supabase.rpc('exec_sql', {
            'query': f"""
                SELECT 
                    column_name,
                    data_type,
                    is_nullable,
                    column_default
                FROM information_schema.columns
                WHERE table_name = '{table_name}'
                AND table_schema = 'public'
                ORDER BY ordinal_position;
            """
        }).execute()
        
        return result.data
    except:
        # Alternative: Use postgrest to describe table
        try:
            # Get first row to see structure
            result = supabase.table(table_name).select('*').limit(1).execute()
            if result.data:
                return list(result.data[0].keys())
            return []
        except Exception as e:
            print(f"  ❌ Error getting schema for {table_name}: {e}")
            return []

def main():
    # Connect to Supabase
    supabase_url = os.getenv('SUPABASE_URL')
    supabase_key = os.getenv('SUPABASE_SERVICE_ROLE_KEY') or os.getenv('SUPABASE_KEY')
    
    if not supabase_url or not supabase_key:
        print("❌ SUPABASE_URL and SUPABASE_KEY required in .env")
        print("\nPlease run this SQL in Supabase SQL Editor and share the output:")
        print("\n" + "="*80)
        print("""
-- Get schema for all our tables
SELECT 
    table_name,
    column_name,
    data_type,
    is_nullable,
    column_default
FROM information_schema.columns
WHERE table_schema = 'public'
AND table_name IN (
    'budgets',
    'building_insurance', 
    'building_staff',
    'fire_door_inspections',
    'leases',
    'compliance_assets',
    'contractors',
    'contracts'
)
ORDER BY table_name, ordinal_position;
        """)
        print("="*80)
        sys.exit(1)
    
    print("🔌 Connecting to Supabase...")
    supabase = create_client(supabase_url, supabase_key)
    print("✅ Connected\n")
    
    tables = [
        'budgets',
        'building_insurance',
        'building_staff',
        'fire_door_inspections',
        'leases',
        'compliance_assets',
        'contractors',
        'contracts',
        'units',
        'leaseholders',
        'buildings'
    ]
    
    print("📊 Fetching schema for tables...")
    print("="*80)
    
    for table in tables:
        print(f"\n### {table.upper()}")
        schema = get_table_schema(supabase, table)
        
        if isinstance(schema, list) and schema and isinstance(schema[0], dict):
            # Got full schema info
            for col in schema:
                nullable = "NULL" if col['is_nullable'] == 'YES' else "NOT NULL"
                default = f" DEFAULT {col['column_default']}" if col['column_default'] else ""
                print(f"  {col['column_name']}: {col['data_type']} {nullable}{default}")
        elif isinstance(schema, list):
            # Got column names only
            for col in schema:
                print(f"  {col}")
        else:
            print(f"  ⚠️  Could not retrieve schema")
    
    print("\n" + "="*80)

if __name__ == '__main__':
    main()
