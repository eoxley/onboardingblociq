#!/usr/bin/env python3
"""
Apply SQL via Supabase REST API
Uses the supabase-py client to execute SQL
"""

import sys
import os
from supabase import create_client, Client
import requests

# Supabase credentials
SUPABASE_URL = "https://xqxaatvykmaaynqeoemy.supabase.co"
SUPABASE_SERVICE_KEY = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InhxeGFhdHZ5a21hYXlucWVvZW15Iiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTc1MTE5Mzk5NCwiZXhwIjoyMDY2NzY5OTk0fQ.4Qza6DOdmF8s6jFMIkMwKgaU_DkIUspap8bOVldwMmk"


def execute_sql_via_api(sql_content: str):
    """Execute SQL via Supabase REST API"""
    
    # Use the PostgREST SQL function endpoint
    url = f"{SUPABASE_URL}/rest/v1/rpc/exec"
    
    headers = {
        "apikey": SUPABASE_SERVICE_KEY,
        "Authorization": f"Bearer {SUPABASE_SERVICE_KEY}",
        "Content-Type": "application/json"
    }
    
    # Try to execute via raw SQL endpoint
    # Note: This may not work - Supabase REST API doesn't directly support arbitrary SQL
    
    print("⚠️  Note: Supabase REST API doesn't support arbitrary SQL execution")
    print("   The SQL needs to be run in the Supabase SQL Editor")
    print()
    print("📋 SQL content has been prepared. Please:")
    print("   1. Open: https://supabase.com/dashboard/project/xqxaatvykmaaynqeoemy/sql/new")
    print("   2. Paste the SQL (already in clipboard)")
    print("   3. Click 'Run'")
    
    return False


def apply_sql_file(filepath: str):
    """Apply SQL file"""
    
    print(f"\n{'='*80}")
    print(f"📄 File: {filepath}")
    print(f"{'='*80}\n")
    
    # Read SQL
    with open(filepath, 'r', encoding='utf-8') as f:
        sql_content = f.read()
    
    line_count = sql_content.count('\n')
    size_kb = len(sql_content) / 1024
    
    print(f"📊 Size: {line_count} lines, {size_kb:.1f} KB")
    print(f"🔄 Attempting to apply...")
    print()
    
    # Try Supabase API
    result = execute_sql_via_api(sql_content)
    
    return result


def main():
    if len(sys.argv) < 2:
        print("Usage: python3 apply_via_supabase_api.py <sql_file>")
        sys.exit(1)
    
    filepath = sys.argv[1]
    
    if not os.path.exists(filepath):
        print(f"❌ File not found: {filepath}")
        sys.exit(1)
    
    # Copy to clipboard first
    os.system(f"cat {filepath} | pbcopy")
    print(f"✅ SQL copied to clipboard!")
    
    # Try to apply
    success = apply_sql_file(filepath)
    
    sys.exit(0 if success else 1)


if __name__ == '__main__':
    main()

