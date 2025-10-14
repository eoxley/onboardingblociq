#!/usr/bin/env python3
"""
Verify Supabase data import
"""

from supabase import create_client, Client

# Supabase connection
SUPABASE_URL = "https://aewixchhykxyhqjvqoek.supabase.co"
SUPABASE_KEY = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImFld2l4Y2hoeWt4eWhxanZxb2VrIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTc1OTUwMjUxNiwiZXhwIjoyMDc1MDc4NTE2fQ.lqLBt_R8GRnI_iMela4RAEfgcJ8Ple6WwmWBqrAa56o"

print("🔄 Connecting to Supabase...")
supabase: Client = create_client(SUPABASE_URL, SUPABASE_KEY)

print("✅ Connected!\n")

# Check buildings
print("📊 Checking Buildings...")
buildings = supabase.table('buildings').select('*').execute()
print(f"   Found {len(buildings.data)} building(s)")
if buildings.data:
    for b in buildings.data:
        print(f"   - {b['building_name']} ({b['num_units']} units)")

# Check units
print("\n📊 Checking Units...")
units = supabase.table('units').select('*').execute()
print(f"   Found {len(units.data)} unit(s)")

# Check leaseholders
print("\n📊 Checking Leaseholders...")
leaseholders = supabase.table('leaseholders').select('*').execute()
print(f"   Found {len(leaseholders.data)} leaseholder(s)")
total_balance = sum(float(lh.get('current_balance', 0)) for lh in leaseholders.data)
print(f"   Total outstanding balance: £{total_balance:,.2f}")

# Check compliance
print("\n📊 Checking Compliance Assets...")
compliance = supabase.table('compliance_assets').select('*, compliance_asset_types(*)').execute()
print(f"   Found {len(compliance.data)} compliance asset(s)")
current = sum(1 for c in compliance.data if c.get('status') == 'current')
expired = sum(1 for c in compliance.data if c.get('status') == 'expired')
missing = sum(1 for c in compliance.data if c.get('status') == 'missing')
print(f"   - Current: {current}")
print(f"   - Expired: {expired}")
print(f"   - Missing: {missing}")

# Check contracts
print("\n📊 Checking Maintenance Contracts...")
contracts = supabase.table('maintenance_contracts').select('*').execute()
print(f"   Found {len(contracts.data)} contract(s)")

print("\n✅ Data verification complete!")
print(f"\n📝 Summary:")
print(f"   Buildings: {len(buildings.data)}")
print(f"   Units: {len(units.data)}")
print(f"   Leaseholders: {len(leaseholders.data)}")
print(f"   Compliance Assets: {len(compliance.data)}")
print(f"   Contracts: {len(contracts.data)}")
