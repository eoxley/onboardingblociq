#!/usr/bin/env python3
"""
Dry-run generated SQL in a transaction (rollback at end).
Tests that generated SQL matches live schema without side effects.
"""
import os
import sys
import psycopg2

def dryrun_sql(sql_file='generated_seed.sql'):
    """Execute SQL in a transaction and rollback"""
    database_url = os.getenv('DATABASE_URL')
    if not database_url:
        raise ValueError("DATABASE_URL environment variable not set")

    if not os.path.exists(sql_file):
        print(f"❌ SQL file not found: {sql_file}")
        sys.exit(1)

    with open(sql_file, 'r') as f:
        sql = f.read()

    conn = psycopg2.connect(database_url)
    conn.autocommit = False  # Ensure transaction mode
    cur = conn.cursor()

    try:
        print(f"🔄 Dry-running SQL from {sql_file}...")
        cur.execute("BEGIN")
        cur.execute("SET LOCAL search_path TO public")
        cur.execute(sql)

        # Get row count if possible
        if cur.rowcount >= 0:
            print(f"   Affected {cur.rowcount} rows (will be rolled back)")

        cur.execute("ROLLBACK")
        conn.commit()  # Commit the rollback

        print("✅ Dry-run PASSED: Generated SQL is compatible with current schema")

    except psycopg2.Error as e:
        print(f"❌ Dry-run FAILED:")
        print(f"   {e.pgerror if hasattr(e, 'pgerror') else str(e)}")
        conn.rollback()
        sys.exit(1)

    finally:
        cur.close()
        conn.close()

if __name__ == '__main__':
    sql_file = sys.argv[1] if len(sys.argv) > 1 else 'generated_seed.sql'
    dryrun_sql(sql_file)
