#!/usr/bin/env python3
"""
Verify Supabase data using direct PostgreSQL connection
"""

import psycopg2
from psycopg2.extras import RealDictCursor

# Direct PostgreSQL connection
conn_params = {
    'host': 'db.aewixchhykxyhqjvqoek.supabase.co',
    'port': 5432,
    'database': 'postgres',
    'user': 'postgres',
    'password': 'GizmoFrank2025!'
}

print("🔄 Connecting to PostgreSQL directly...")

try:
    conn = psycopg2.connect(**conn_params)
    cur = conn.cursor(cursor_factory=RealDictCursor)

    print("✅ Connected!\n")

    # Check buildings
    print("📊 Checking Buildings...")
    cur.execute("SELECT * FROM buildings")
    buildings = cur.fetchall()
    print(f"   Found {len(buildings)} building(s)")
    for b in buildings:
        print(f"   - {b['building_name']} ({b['num_units']} units)")

    # Check units
    print("\n📊 Checking Units...")
    cur.execute("SELECT COUNT(*) as count FROM units")
    result = cur.fetchone()
    print(f"   Found {result['count']} unit(s)")

    # Check leaseholders
    print("\n📊 Checking Leaseholders...")
    cur.execute("SELECT COUNT(*) as count, SUM(current_balance) as total FROM leaseholders")
    result = cur.fetchone()
    print(f"   Found {result['count']} leaseholder(s)")
    print(f"   Total outstanding balance: £{float(result['total'] or 0):,.2f}")

    # Check compliance
    print("\n📊 Checking Compliance Assets...")
    cur.execute("""
        SELECT
            COUNT(*) as total,
            COUNT(*) FILTER (WHERE status = 'current') as current,
            COUNT(*) FILTER (WHERE status = 'expired') as expired,
            COUNT(*) FILTER (WHERE status = 'missing') as missing
        FROM compliance_assets
    """)
    result = cur.fetchone()
    print(f"   Found {result['total']} compliance asset(s)")
    print(f"   - Current: {result['current']}")
    print(f"   - Expired: {result['expired']}")
    print(f"   - Missing: {result['missing']}")

    # Check contracts
    print("\n📊 Checking Maintenance Contracts...")
    cur.execute("SELECT COUNT(*) as count FROM maintenance_contracts")
    result = cur.fetchone()
    print(f"   Found {result['count']} contract(s)")

    print("\n✅ Data verification complete!")

    cur.close()
    conn.close()

except Exception as e:
    print(f"❌ Error: {e}")
