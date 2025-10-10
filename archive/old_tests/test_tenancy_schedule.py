#!/usr/bin/env python3
"""
Test Tenancy Schedule unit and leaseholder extraction
"""
import sys
import os

# Add BlocIQ_Onboarder to path
sys.path.insert(0, os.path.join(os.path.dirname(__file__), 'BlocIQ_Onboarder'))

from parsers import PDFParser
from schema_mapper import SupabaseSchemaMapper
import uuid

# Parse the Tenancy Schedule PDF
pdf_path = "/Users/ellie/Desktop/BlocIQ Buildings/2.Connaught Square/219.01 CONNAUGHT SQUARE/2. FINANCE/Tenancy Schedule by Property.pdf"

print("=" * 60)
print("TESTING TENANCY SCHEDULE EXTRACTION")
print("=" * 60)

# Step 1: Parse PDF
print("\n1. Parsing PDF...")
parser = PDFParser(pdf_path)
file_data = parser.parse()

print(f"   ✓ Parsed successfully")
print(f"   - Has 'full_text': {'full_text' in file_data}")
if 'full_text' in file_data:
    print(f"   - Full text length: {len(file_data['full_text'])}")
    print(f"   - First 500 chars: {file_data['full_text'][:500]}")

# Step 2: Extract units
print("\n2. Extracting units...")
building_id = str(uuid.uuid4())
mapper = SupabaseSchemaMapper()
units = mapper.map_units(file_data, building_id)

print(f"   ✓ Extracted {len(units)} units")
for unit in units:
    print(f"     - {unit['unit_number']} (ID: {unit['id'][:8]}...)")

# Step 3: Build unit_map
print("\n3. Building unit_map...")
unit_map = {unit['unit_number']: unit['id'] for unit in units}
print(f"   ✓ Created unit_map with {len(unit_map)} entries")

# Step 4: Extract leaseholders
print("\n4. Extracting leaseholders...")
leaseholders = mapper.map_leaseholders(file_data, unit_map, building_id)

print(f"   ✓ Extracted {len(leaseholders)} leaseholders")
for lh in leaseholders:
    print(f"     - {lh.get('first_name', '')} {lh.get('last_name', '')} @ {lh.get('unit_number', 'N/A')}")
    print(f"       unit_id: {lh.get('unit_id', 'MISSING')[:8] if lh.get('unit_id') else 'MISSING'}...")

# Summary
print("\n" + "=" * 60)
print("SUMMARY")
print("=" * 60)
print(f"Units extracted: {len(units)}")
print(f"Leaseholders extracted: {len(leaseholders)}")
print(f"Leaseholders with unit_id: {sum(1 for lh in leaseholders if lh.get('unit_id'))}")
print("=" * 60)
