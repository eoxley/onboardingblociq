#!/usr/bin/env python3
"""
Apply SQL using Supabase Service Role via PostgREST
Uses direct HTTP API with service role key
"""

import sys
import os
import requests
import json

SUPABASE_URL = "https://xqxaatvykmaaynqeoemy.supabase.co"
SUPABASE_SERVICE_KEY = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InhxeGFhdHZ5a21hYXlucWVvZW15Iiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTc1MTE5Mzk5NCwiZXhwIjoyMDY2NzY5OTk0fQ.4Qza6DOdmF8s6jFMIkMwKgaU_DkIUspap8bOVldwMmk"

def execute_sql_statements(sql_content: str):
    """Execute SQL statements using Supabase Management API"""
    
    print(f"\n🔄 Executing SQL via Supabase Management API...")
    
    # Try using the database query endpoint
    url = f"{SUPABASE_URL}/rest/v1/rpc"
    
    headers = {
        "apikey": SUPABASE_SERVICE_KEY,
        "Authorization": f"Bearer {SUPABASE_SERVICE_KEY}",
        "Content-Type": "application/json",
        "Prefer": "return=representation"
    }
    
    # Split SQL into individual CREATE TABLE statements
    statements = []
    current = []
    
    for line in sql_content.split('\n'):
        if line.strip().startswith('--') or not line.strip():
            continue
        current.append(line)
        if line.strip().endswith(';'):
            statements.append('\n'.join(current))
            current = []
    
    print(f"📊 Found {len(statements)} SQL statements")
    
    # Try to execute using raw SQL
    # Note: This requires pgtle or similar extension
    print(f"\n⚠️  Supabase REST API doesn't support arbitrary SQL execution")
    print(f"   Service role key provides elevated access but SQL must still be run via SQL Editor")
    
    return False


def main():
    if len(sys.argv) < 2:
        print("Usage: python3 apply_with_service_role.py <sql_file>")
        sys.exit(1)
    
    filepath = sys.argv[1]
    
    print(f"\n{'='*80}")
    print(f"🚀 Attempting SQL Application with Service Role")
    print(f"{'='*80}")
    print(f"File: {filepath}")
    
    # Read SQL
    with open(filepath, 'r') as f:
        sql_content = f.read()
    
    # Execute
    success = execute_sql_statements(sql_content)
    
    if not success:
        print(f"\n{'='*80}")
        print(f"💡 SOLUTION: Manual Application Required")
        print(f"{'='*80}")
        print(f"\nSupabase requires SQL to be run through their SQL Editor:")
        print(f"1. URL: https://supabase.com/dashboard/project/xqxaatvykmaaynqeoemy/sql/new")
        print(f"2. The SQL is already in your clipboard")
        print(f"3. Paste (Cmd+V) and click 'Run'")
        print(f"\nThis is a Supabase platform limitation, not a permissions issue.")
        
        # Copy to clipboard as backup
        os.system(f"cat {filepath} | pbcopy")
        print(f"\n✅ SQL re-copied to clipboard for easy pasting")
    
    sys.exit(0 if success else 1)


if __name__ == '__main__':
    main()

