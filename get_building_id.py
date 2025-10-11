#!/usr/bin/env python3
"""Quick script to get a building ID using Supabase API"""
import os
import sys

try:
    from supabase import create_client
except ImportError:
    print("Installing supabase client...")
    os.system("pip3 install supabase")
    from supabase import create_client

# Load from env or use defaults
supabase_url = os.getenv('SUPABASE_URL', 'https://xqxaatvykmaaynqeoemy.supabase.co')
supabase_key = os.getenv('SUPABASE_SERVICE_KEY', 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InhxeGFhdHZ5a21hYXlucWVvZW15Iiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTc1MTE5Mzk5NCwiZXhwIjoyMDY2NzY5OTk0fQ.4Qza6DOdmF8s6jFMIkMwKgaU_DkIUspap8bOVldwMmk')

try:
    # Create Supabase client
    supabase = create_client(supabase_url, supabase_key)

    # Query buildings
    response = supabase.table('buildings').select('id, name').limit(5).execute()

    if response.data:
        print("\n✅ Found buildings:\n")
        for building in response.data:
            print(f"  ID: {building['id']}")
            print(f"  Name: {building['name']}")
            print()

        # Use first building
        first_id = response.data[0]['id']
        print(f"✅ Using building ID: {first_id}")
        print(f"\nUpdate your .env file with:")
        print(f"BUILDING_ID={first_id}")

    else:
        print("❌ No buildings found in database")
        sys.exit(1)

except Exception as e:
    print(f"❌ Error querying Supabase: {e}")
    sys.exit(1)
