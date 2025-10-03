#!/usr/bin/env python3
"""
Test using EXACT same classes as onboarder
"""
from parsers import ExcelParser
from classifier import DocumentClassifier
from mapper import SupabaseMapper
import uuid

print("Test using EXACT onboarder classes")
print("="*60)

# Parse
file_path = '/Users/ellie/Downloads/219.01 CONNAUGHT SQUARE/connaught apportionment.xlsx'
parser = ExcelParser(file_path)
parsed = parser.parse()

# Classify
classifier = DocumentClassifier()
categorized = classifier.classify_folder([parsed])

# Get the budget files
budgets = categorized.get('budgets', [])
print(f"Budget files: {len(budgets)}")

if budgets:
    # Create mapper (same way onboarder does)
    mapper = SupabaseMapper(folder_name='219.01 CONNAUGHT SQUARE')
    building_id = str(uuid.uuid4())

    for file_data in budgets:
        print(f"\nProcessing: {file_data['file_name']}")
        print(f"Keys in file_data: {list(file_data.keys())}")
        print(f"Has 'data' key: {'data' in file_data}")

        # Call map_units (same way onboarder does)
        units = mapper.map_units(file_data, building_id)

        print(f"Extracted units: {len(units)}")

        if units:
            for u in units:
                print(f"  - {u['unit_number']}: {u.get('apportionment_percent', 'N/A')}%")
        else:
            print("  NO UNITS EXTRACTED!")
            print(f"\n  DEBUG: Checking file_data structure...")
            if 'data' in file_data:
                print(f"  'data' type: {type(file_data['data'])}")
                if isinstance(file_data['data'], dict):
                    for sheet_name, sheet_data in file_data['data'].items():
                        print(f"  Sheet '{sheet_name}':")
                        print(f"    Type: {type(sheet_data)}")
                        if isinstance(sheet_data, dict):
                            print(f"    Keys: {list(sheet_data.keys())}")
                            if 'raw_data' in sheet_data:
                                print(f"    raw_data length: {len(sheet_data['raw_data'])}")

print("\n" + "="*60)
