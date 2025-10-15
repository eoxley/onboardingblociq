#!/usr/bin/env python3
"""Verify the fresh data load with contractor names"""

import psycopg2

DATABASE_URL = "postgresql://postgres:GizmoFrank2025!@db.aewixchhykxyhqjvqoek.supabase.co:5432/postgres"

print("\n" + "="*80)
print("🎉 VERIFYING FRESH DATA LOAD WITH CONTRACTOR NAMES")
print("="*80)

try:
    conn = psycopg2.connect(DATABASE_URL)
    cursor = conn.cursor()
    
    # Find the latest building
    cursor.execute("""
        SELECT id, building_name, cleaning_contractor, lift_contractor, heating_contractor
        FROM buildings 
        ORDER BY created_at DESC 
        LIMIT 1
    """)
    
    building = cursor.fetchone()
    if building:
        building_id = building[0]
        print(f"\n🏢 Latest Building:")
        print(f"   ID: {building_id}")
        print(f"   Name: {building[1]}")
        print(f"   Cleaning: {building[2] or 'Not set'}")
        print(f"   Lift: {building[3] or 'Not set'}")
        print(f"   Heating: {building[4] or 'Not set'}")
        
        # Count all entities
        queries = [
            ("Units", f"SELECT COUNT(*) FROM units WHERE building_id = '{building_id}'"),
            ("Leaseholders", f"SELECT COUNT(*) FROM leaseholders WHERE unit_id IN (SELECT id FROM units WHERE building_id = '{building_id}')"),
            ("Compliance Assets", f"SELECT COUNT(*) FROM compliance_assets WHERE building_id = '{building_id}'"),
            ("Maintenance Contracts", f"SELECT COUNT(*) FROM maintenance_contracts WHERE building_id = '{building_id}'"),
            ("Budgets", f"SELECT COUNT(*) FROM budgets WHERE building_id = '{building_id}'"),
            ("Budget Line Items", f"SELECT COUNT(*) FROM budget_line_items WHERE budget_id IN (SELECT id FROM budgets WHERE building_id = '{building_id}')"),
            ("Maintenance Schedules", f"SELECT COUNT(*) FROM maintenance_schedules WHERE building_id = '{building_id}'"),
            ("Insurance Policies", f"SELECT COUNT(*) FROM insurance_policies WHERE building_id = '{building_id}'"),
            ("Leases", f"SELECT COUNT(*) FROM leases WHERE building_id = '{building_id}'"),
            ("Lease Clauses", f"SELECT COUNT(*) FROM lease_clauses WHERE building_id = '{building_id}'"),
            ("Contractors", "SELECT COUNT(*) FROM contractors"),
            ("Major Works", f"SELECT COUNT(*) FROM major_works_projects WHERE building_id = '{building_id}'"),
        ]
        
        print(f"\n📊 Data Loaded:")
        total = 0
        for entity, query in queries:
            cursor.execute(query)
            count = cursor.fetchone()[0]
            status = "✅" if count > 0 else "⚠️ "
            print(f"   {status} {entity}: {count}")
            total += count
        
        print(f"\n   TOTAL RECORDS: {total}")
        
        # Show contractor names being used
        if building[2] or building[3]:
            print(f"\n🔨 Contractor Names Successfully Loaded:")
            if building[2]:
                print(f"   ✅ Cleaning Contractor: {building[2]}")
            if building[3]:
                print(f"   ✅ Lift Contractor: {building[3]}")
            if building[4]:
                print(f"   ✅ Heating Contractor: {building[4]}")
        
        print("\n" + "="*80)
        print("✅ DATA LOAD COMPLETE WITH CONTRACTOR NAMES!")
        print("="*80 + "\n")
    
    cursor.close()
    conn.close()

except Exception as e:
    print(f"\n❌ Error: {e}\n")

