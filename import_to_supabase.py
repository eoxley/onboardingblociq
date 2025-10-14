#!/usr/bin/env python3
"""
Import SQL directly to Supabase using Python client
"""

import os
import sys
from supabase import create_client, Client

# Supabase connection details
SUPABASE_URL = "https://aewixchhykxyhqjvqoek.supabase.co"
SUPABASE_KEY = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImFld2l4Y2hoeWt4eWhxanZxb2VrIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTk1MDI1MTYsImV4cCI6MjA3NTA3ODUxNn0.HoIyRPGRL__ol033r1Pu-UAyKYyAKdr-qXsOQUSSITU"

def import_sql_file(sql_file: str):
    """Import SQL file to Supabase"""

    print(f"🔄 Reading SQL file: {sql_file}")

    with open(sql_file, 'r') as f:
        sql_content = f.read()

    print(f"✅ SQL file loaded ({len(sql_content)} characters)")
    print(f"\n🔄 Connecting to Supabase...")

    # Create Supabase client
    supabase: Client = create_client(SUPABASE_URL, SUPABASE_KEY)

    print(f"✅ Connected to Supabase")
    print(f"\n🔄 Executing SQL...")

    try:
        # Execute the SQL using RPC call
        result = supabase.rpc('execute_sql', {'sql_query': sql_content}).execute()

        print(f"✅ SQL executed successfully!")
        print(f"\nResult: {result}")

    except Exception as e:
        print(f"❌ Error executing SQL: {e}")
        print(f"\n📝 Alternative: Copy the SQL file and paste it into Supabase SQL Editor:")
        print(f"   https://supabase.com/dashboard/project/aewixchhykxyhqjvqoek/sql/new")
        return False

    return True


if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("Usage: python3 import_to_supabase.py <sql_file>")
        sys.exit(1)

    sql_file = sys.argv[1]

    if not os.path.exists(sql_file):
        print(f"❌ File not found: {sql_file}")
        sys.exit(1)

    import_sql_file(sql_file)
