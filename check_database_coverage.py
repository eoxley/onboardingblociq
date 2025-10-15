#!/usr/bin/env python3
"""Check what data is already loaded in Supabase"""

import psycopg2

DATABASE_URL = "postgresql://postgres:GizmoFrank2025!@db.aewixchhykxyhqjvqoek.supabase.co:5432/postgres"
BUILDING_ID = '2667e33e-b493-499f-ae8d-2de07b7bb707'

print("\n" + "="*80)
print("🔍 CHECKING WHAT'S ALREADY IN DATABASE")
print("="*80)

try:
    conn = psycopg2.connect(DATABASE_URL)
    cursor = conn.cursor()
    
    checks = [
        ("Buildings", f"SELECT COUNT(*) FROM buildings WHERE id = '{BUILDING_ID}'"),
        ("Units", f"SELECT COUNT(*) FROM units WHERE building_id = '{BUILDING_ID}'"),
        ("Leaseholders", f"SELECT COUNT(*) FROM leaseholders WHERE building_id = '{BUILDING_ID}'"),
        ("Compliance Assets", f"SELECT COUNT(*) FROM compliance_assets WHERE building_id = '{BUILDING_ID}'"),
        ("Maintenance Contracts", f"SELECT COUNT(*) FROM maintenance_contracts WHERE building_id = '{BUILDING_ID}'"),
        ("Budgets", f"SELECT COUNT(*) FROM budgets WHERE building_id = '{BUILDING_ID}'"),
        ("Budget Line Items", f"SELECT COUNT(*) FROM budget_line_items WHERE budget_id IN (SELECT id FROM budgets WHERE building_id = '{BUILDING_ID}')"),
        ("Maintenance Schedules", f"SELECT COUNT(*) FROM maintenance_schedules WHERE building_id = '{BUILDING_ID}'"),
        ("Insurance Policies", f"SELECT COUNT(*) FROM insurance_policies WHERE building_id = '{BUILDING_ID}'"),
        ("Leases", f"SELECT COUNT(*) FROM leases WHERE building_id = '{BUILDING_ID}'"),
        ("Lease Clauses", f"SELECT COUNT(*) FROM lease_clauses WHERE building_id = '{BUILDING_ID}'"),
        ("Contractors", "SELECT COUNT(*) FROM contractors"),
        ("Major Works", f"SELECT COUNT(*) FROM major_works_projects WHERE building_id = '{BUILDING_ID}'"),
    ]
    
    print(f"\n{'Entity':<25} {'Count':<10} {'Status'}")
    print("-" * 60)
    
    total = 0
    missing = []
    
    for entity, query in checks:
        try:
            cursor.execute(query)
            count = cursor.fetchone()[0]
            status = "✅ Loaded" if count > 0 else "⚠️  Missing"
            print(f"{entity:<25} {count:<10} {status}")
            total += count
            
            if count == 0:
                missing.append(entity)
        except Exception as e:
            print(f"{entity:<25} {'ERROR':<10} ❌ {str(e)[:30]}")
    
    print("-" * 60)
    print(f"{'TOTAL RECORDS':<25} {total:<10}")
    
    if missing:
        print(f"\n⚠️  MISSING DATA: {', '.join(missing)}")
        print(f"\n💡 To load missing data:")
        print(f"   python3 apply_with_new_credentials.py output/connaught_COMPLETE.sql")
    else:
        print(f"\n✅ ALL DATA LOADED!")
    
    # Check for contractor fields
    print(f"\n{'Checking contractor fields...'}")
    cursor.execute("""
        SELECT column_name 
        FROM information_schema.columns 
        WHERE table_name = 'buildings' 
        AND column_name IN ('cleaning_contractor', 'lift_contractor', 'heating_contractor')
    """)
    
    contractor_cols = cursor.fetchall()
    if contractor_cols:
        print(f"✅ Contractor fields exist: {len(contractor_cols)} columns")
        
        # Check if they have values
        cursor.execute(f"""
            SELECT cleaning_contractor, lift_contractor, heating_contractor
            FROM buildings WHERE id = '{BUILDING_ID}'
        """)
        vals = cursor.fetchone()
        if vals and any(vals):
            print(f"✅ Contractor data populated: {[v for v in vals if v]}")
        else:
            print(f"⚠️  Contractor fields empty - need to update building record")
    else:
        print(f"⚠️  Contractor fields missing - run add_contractor_fields.sql")
    
    cursor.close()
    conn.close()
    
    print("\n" + "="*80 + "\n")

except Exception as e:
    print(f"\n❌ Error: {e}\n")

