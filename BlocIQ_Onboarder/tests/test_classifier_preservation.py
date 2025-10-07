#!/usr/bin/env python3
"""
Test if classifier preserves the 'data' key from parsed files
"""
from parsers import ExcelParser
from classifier import DocumentClassifier

# Parse the apportionment file
file_path = '/Users/ellie/Downloads/219.01 CONNAUGHT SQUARE/connaught apportionment.xlsx'
parser = ExcelParser(file_path)
parsed = parser.parse()

print("BEFORE CLASSIFICATION:")
print(f"  Has 'data' key: {'data' in parsed}")
print(f"  Keys: {list(parsed.keys())}")

# Classify
classifier = DocumentClassifier()
categorized = classifier.classify_folder([parsed])

# Check all categories for the file
for cat, files in categorized.items():
    if files:
        print(f"\nCategory '{cat}': {len(files)} files")
        for f in files:
            print(f"  File: {f['file_name']}")
            print(f"  Has 'data' key: {'data' in f}")
            print(f"  Keys: {list(f.keys())}")

            # Check if data structure is intact
            if 'data' in f:
                print(f"  Data type: {type(f['data'])}")
                if isinstance(f['data'], dict):
                    print(f"  Sheets: {list(f['data'].keys())}")
