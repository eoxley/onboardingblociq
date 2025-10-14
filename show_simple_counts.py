#!/usr/bin/env python3
"""
Simple database contents - just show counts
"""

import psycopg2

DATABASE_URL = "postgresql://postgres:GizmoFrank2025!@db.aewixchhykxyhqjvqoek.supabase.co:5432/postgres"
BUILDING_ID = '2667e33e-b493-499f-ae8d-2de07b7bb707'

print("\n" + "="*100)
print("📊 CONNAUGHT SQUARE - DATABASE CONTENTS SUMMARY")
print("="*100)

try:
    conn = psycopg2.connect(DATABASE_URL)
    cursor = conn.cursor()
    
    # Get all counts
    queries = [
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
        ("Lease Parties", f"SELECT COUNT(*) FROM lease_parties WHERE lease_id IN (SELECT id FROM leases WHERE building_id = '{BUILDING_ID}')"),
        ("Lease Financial Terms", f"SELECT COUNT(*) FROM lease_financial_terms WHERE lease_id IN (SELECT id FROM leases WHERE building_id = '{BUILDING_ID}')"),
        ("Contractors", "SELECT COUNT(*) FROM contractors"),
        ("Major Works", f"SELECT COUNT(*) FROM major_works_projects WHERE building_id = '{BUILDING_ID}'"),
    ]
    
    print(f"\n{'Entity Type':<35} {'Count':<10} {'Status'}")
    print("-" * 70)
    
    total = 0
    for entity, query in queries:
        try:
            cursor.execute(query)
            count = cursor.fetchone()[0]
            status = "✅" if count > 0 else "⚠️ "
            print(f"{entity:<35} {count:<10} {status}")
            total += count
        except Exception as e:
            print(f"{entity:<35} {'ERROR':<10} ❌ ({str(e)[:30]})")
    
    print("-" * 70)
    print(f"{'TOTAL RECORDS':<35} {total:<10} {'✅' if total > 0 else '❌'}")
    
    # Building details
    print("\n" + "="*100)
    print("🏢 BUILDING DETAILS")
    print("="*100)
    
    cursor.execute(f"SELECT building_name, postcode, num_units FROM buildings WHERE id = '{BUILDING_ID}'")
    b = cursor.fetchone()
    if b:
        print(f"Name: {b[0]}")
        print(f"Postcode: {b[1]}")
        print(f"Units: {b[2]}")
    
    # Lease clause breakdown
    print("\n" + "="*100)
    print("📋 LEASE CLAUSE BREAKDOWN")
    print("="*100)
    
    cursor.execute(f"""
        SELECT clause_category, COUNT(*), 
               STRING_AGG(DISTINCT importance_level, ', ') as importance_levels
        FROM lease_clauses 
        WHERE building_id = '{BUILDING_ID}'
        GROUP BY clause_category
        ORDER BY COUNT(*) DESC
    """)
    
    clauses = cursor.fetchall()
    if clauses:
        print(f"\nTotal Clauses: {sum(c[1] for c in clauses)}\n")
        for cat, count, levels in clauses:
            print(f"  • {cat.title()}: {count} clauses (Levels: {levels})")
    else:
        print("\nNo lease clauses found")
    
    cursor.close()
    conn.close()
    
    print("\n" + "="*100)
    
except Exception as e:
    print(f"\n❌ Error: {e}")


