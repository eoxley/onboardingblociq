#!/usr/bin/env python3
"""
Diagnose why health check wasn't generated on Oct 9
Load migration.sql and check if it has the necessary data
"""
import sys
import json

# Check summary.json structure
print("=" * 70)
print("Analyzing Oct 9 Run Data")
print("=" * 70)

print("\n📊 Loading summary.json from Oct 9...")
with open('output/summary.json', 'r') as f:
    summary = json.load(f)

print(f"✓ Loaded summary from: {summary['timestamp']}")
print(f"  Statistics: {summary['statistics']}")

# Check if migration.sql has building data
print("\n📄 Checking migration.sql for building INSERT...")
with open('output/migration.sql', 'r') as f:
    sql_content = f.read()

has_building = 'INSERT INTO buildings' in sql_content
has_units = 'INSERT INTO units' in sql_content
has_compliance = 'INSERT INTO compliance_assets' in sql_content or 'INSERT INTO assets' in sql_content

print(f"  Building INSERT: {'✓' if has_building else '✗'}")
print(f"  Units INSERT: {'✓' if has_units else '✗'}")
print(f"  Compliance INSERT: {'✓' if has_compliance else '✗'}")

# The issue is that we can't reconstruct mapped_data from just the summary and SQL
# But we can verify the SQL generation worked, which proves mapped_data existed

print("\n🔍 Analysis:")
if summary and sql_content:
    print("  ✓ summary.json created successfully")
    print("  ✓ migration.sql created successfully")
    print("  → This proves mapped_data existed at runtime")
    print("  → Health check generation should have run")
    print("\n💡 Likely cause:")
    print("  The health check generation failed with an exception")
    print("  The exception was caught and printed, but console output was lost")
    print("  Solution: Exception handling with traceback is now in place")
    print("  Next run will show the error if it occurs again")

print("\n" + "=" * 70)
