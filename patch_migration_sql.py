#!/usr/bin/env python3
"""
Patch the existing migration.sql with the new CREATE TABLE statements
This adds the missing table definitions without re-running the entire onboarding
"""

import re

# Read the old migration SQL
old_sql_path = '/Users/ellie/Desktop/BlocIQ_Output/migration_old.sql'
new_sql_path = '/Users/ellie/Desktop/BlocIQ_Output/migration.sql'
header_path = '/Users/ellie/Desktop/BlocIQ_Output/sql_header_test.sql'

print("Reading files...")
with open(old_sql_path, 'r') as f:
    old_sql = f.read()

with open(header_path, 'r') as f:
    new_header = f.read()

print(f"Old SQL size: {len(old_sql)} bytes")
print(f"New header size: {len(new_header)} bytes")

# Find the BEGIN; statement - this is where data INSERTs start
begin_match = re.search(r'^BEGIN;$', old_sql, re.MULTILINE)

if not begin_match:
    print("ERROR: Could not find BEGIN; statement in old SQL")
    exit(1)

begin_pos = begin_match.start()
print(f"Found BEGIN; at position {begin_pos}")

# Get the INSERT portion (everything after BEGIN;)
insert_section = old_sql[begin_pos:]

print(f"INSERT section size: {len(insert_section)} bytes")

# Combine new header with old INSERTs
new_sql = new_header + "\n\n" + insert_section

# Save the patched SQL
with open(new_sql_path, 'w') as f:
    f.write(new_sql)

print(f"\n✅ Patched SQL written to: {new_sql_path}")
print(f"   New size: {len(new_sql)} bytes")
print(f"   Old size: {len(old_sql)} bytes")
print(f"   Difference: {len(new_sql) - len(old_sql):+d} bytes")

# Validate the patch
create_count_old = old_sql.count('CREATE TABLE IF NOT EXISTS')
create_count_new = new_sql.count('CREATE TABLE IF NOT EXISTS')

print(f"\n   CREATE TABLE statements:")
print(f"     Old: {create_count_old}")
print(f"     New: {create_count_new}")
print(f"     Added: {create_count_new - create_count_old}")
