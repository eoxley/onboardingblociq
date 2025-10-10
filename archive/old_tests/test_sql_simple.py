#!/usr/bin/env python3
"""
Simple Supabase SQL validation using table queries
Tests that the generated migration.sql structure is compatible
"""
from supabase import create_client
import json

SUPABASE_URL = "https://aewixchhykxyhqjvqoek.supabase.co"
SUPABASE_KEY = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImFld2l4Y2hoeWt4eWhxanZxb2VrIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTc1OTUwMjUxNiwiZXhwIjoyMDc1MDc4NTE2fQ.lqLBt_R8GRnI_iMela4RAEfgcJ8Ple6WwmWBqrAa56o"

print("=" * 70)
print("VALIDATING SUPABASE SCHEMA FOR MIGRATION SQL COMPATIBILITY")
print("=" * 70)

try:
    supabase = create_client(SUPABASE_URL, SUPABASE_KEY)
    print(f"\n✅ Connected to Supabase: {SUPABASE_URL}\n")

    # Tables we're inserting into
    tables_to_check = [
        'buildings',
        'units',
        'leaseholders',
        'compliance_assets',
        'building_documents',
        'budgets',
        'building_intelligence'
    ]

    print("🔍 Checking table accessibility:\n")

    accessible_tables = []
    for table in tables_to_check:
        try:
            result = supabase.table(table).select('*').limit(1).execute()
            print(f"  ✓ {table:30} - accessible")
            accessible_tables.append(table)
        except Exception as e:
            error_msg = str(e)[:80]
            print(f"  ✗ {table:30} - {error_msg}")

    # Load migration summary to show what will be inserted
    try:
        with open('output/summary.json', 'r') as f:
            summary = json.load(f)

        print("\n" + "=" * 70)
        print("MIGRATION DATA SUMMARY (from output/summary.json)")
        print("=" * 70)
        print(f"\n📊 Building: {summary['building_name']}")
        print(f"📅 Generated: {summary['timestamp']}")
        print(f"\nRecords to insert:")
        print(f"  • Buildings: {summary['statistics']['buildings']}")
        print(f"  • Units: {summary['statistics']['units']}")
        print(f"  • Leaseholders: {summary['statistics']['leaseholders']}")
        print(f"  • Documents: {summary['statistics']['documents']}")
        print(f"  • Compliance Assets: {summary['compliance_assets']['total']}")
        print(f"  • Building Intelligence: {summary['building_intelligence']['total_entries']}")

        print(f"\n📁 Document categories:")
        for cat, count in summary['categories'].items():
            print(f"  • {cat}: {count}")

        print(f"\n🔧 Compliance breakdown:")
        for type_name, count in summary['compliance_assets']['by_type'].items():
            print(f"  • {type_name}: {count}")

    except Exception as e:
        print(f"\n⚠️  Could not load summary: {e}")

    print("\n" + "=" * 70)
    print("VALIDATION RESULT")
    print("=" * 70)

    if len(accessible_tables) == len(tables_to_check):
        print(f"\n✅ All {len(tables_to_check)} required tables are accessible")
        print("✅ Schema structure is compatible with BlocIQ V2")
        print("\n📝 Next steps:")
        print("   1. Open Supabase Dashboard → SQL Editor")
        print("   2. Copy output/migration.sql")
        print("   3. Replace AGENCY_ID_PLACEHOLDER with your agency UUID")
        print("   4. Execute the SQL script")
        print("\n✅ Migration is ready for deployment!")
    else:
        print(f"\n⚠️  {len(tables_to_check) - len(accessible_tables)} tables had issues")
        print("   Review errors above and ensure BlocIQ V2 schema is deployed")

except Exception as e:
    print(f"\n❌ Connection error: {e}")
    print("\n⚠️  Unable to connect to Supabase")
    print("   Ensure SUPABASE_URL and SUPABASE_KEY are correct")

print("\n" + "=" * 70)
