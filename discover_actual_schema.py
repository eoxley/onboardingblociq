#!/usr/bin/env python3
"""
Discover the actual Supabase schema columns for each table
"""
from supabase import create_client

SUPABASE_URL = "https://aewixchhykxyhqjvqoek.supabase.co"
SUPABASE_KEY = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImFld2l4Y2hoeWt4eWhxanZxb2VrIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTc1OTUwMjUxNiwiZXhwIjoyMDc1MDc4NTE2fQ.lqLBt_R8GRnI_iMela4RAEfgcJ8Ple6WwmWBqrAa56o"

print("=" * 70)
print("DISCOVERING ACTUAL SUPABASE SCHEMA")
print("=" * 70)

supabase = create_client(SUPABASE_URL, SUPABASE_KEY)

tables = ['buildings', 'units', 'leaseholders', 'compliance_assets', 'building_documents', 'portfolios', 'budgets']

for table in tables:
    print(f"\n📋 Table: {table}")
    print("-" * 70)
    try:
        # Get one record to see the structure
        result = supabase.table(table).select('*').limit(1).execute()

        if result.data and len(result.data) > 0:
            columns = list(result.data[0].keys())
            print(f"Columns ({len(columns)}):")
            for col in sorted(columns):
                print(f"  • {col}")
        else:
            print("  (No data in table - cannot infer schema)")

    except Exception as e:
        print(f"  Error: {str(e)[:100]}")

print("\n" + "=" * 70)
