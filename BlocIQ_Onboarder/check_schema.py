#!/usr/bin/env python3
"""Check actual Supabase schema"""

import pg8000

SUPABASE_CONFIG = {
    'host': 'aws-1-eu-west-1.pooler.supabase.com',
    'port': 6543,
    'user': 'postgres.aewixchhykxyhqjvqoek',
    'password': '1Poppydog!234',
    'database': 'postgres'
}

def check_tables():
    conn = pg8000.connect(**SUPABASE_CONFIG)
    cursor = conn.cursor()

    tables = ['units', 'leases', 'leaseholders', 'compliance_assets', 'building_insurance', 'budgets', 'building_contractors']

    for table in tables:
        print(f"\n📋 {table.upper()} Columns:")
        cursor.execute("""
            SELECT column_name, data_type
            FROM information_schema.columns
            WHERE table_name = %s
            ORDER BY ordinal_position
        """, (table,))
        columns = cursor.fetchall()
        for col in columns:
            print(f"   - {col[0]} ({col[1]})")

    cursor.close()
    conn.close()

if __name__ == "__main__":
    check_tables()
