#!/usr/bin/env python3
"""
Run SQL file directly via PostgreSQL connection
"""

import psycopg2
import sys

# Connection params
conn_params = {
    'host': 'db.aewixchhykxyhqjvqoek.supabase.co',
    'port': 5432,
    'database': 'postgres',
    'user': 'postgres',
    'password': 'GizmoFrank2025!'
}

sql_file = 'output/connaught_supabase.sql'

print(f"🔄 Reading SQL file: {sql_file}")
with open(sql_file, 'r') as f:
    sql_content = f.read()

print(f"✅ SQL file loaded ({len(sql_content)} characters)")
print(f"\n🔄 Connecting to PostgreSQL...")

try:
    conn = psycopg2.connect(**conn_params)
    cur = conn.cursor()

    print("✅ Connected!")
    print(f"\n🔄 Executing SQL...")

    # Execute the SQL
    cur.execute(sql_content)

    print(f"✅ SQL executed successfully!")
    print(f"   Rows affected: {cur.rowcount}")

    cur.close()
    conn.close()

    print("\n✅ Import complete!")

except Exception as e:
    print(f"❌ Error: {e}")
    sys.exit(1)
