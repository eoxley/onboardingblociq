#!/usr/bin/env python3
"""
Diagnose why onboarder isn't extracting units
"""
import json
from pathlib import Path

# Load the actual audit log to see what was parsed
audit_path = '/Users/ellie/Desktop/BlocIQ_Output/audit_log.json'
with open(audit_path) as f:
    audit = json.load(f)

# Find the apportionment file parsing event
for entry in audit:
    if entry.get('file') == 'connaught apportionment.xlsx' and entry.get('action') == 'parse':
        print(f"Apportionment file parsing:")
        print(f"  Success: {entry['success']}")
        print(f"  Error: {entry.get('error')}")
        print()

# Find the classification event
for entry in audit:
    if entry.get('action') == 'classify' and entry.get('category') == 'budgets':
        print(f"Budget category classification:")
        print(f"  File count: {entry['file_count']}")
        print()

# Find the mapping event
for entry in audit:
    if entry.get('action') == 'map':
        print(f"Mapping results:")
        print(f"  Tables: {entry['tables']}")
        print(f"  Record counts: {json.dumps(entry['record_counts'], indent=4)}")
        print()

# Now let's manually parse and check the file
from parsers import ExcelParser
from classifier import DocumentClassifier

print("="*60)
print("MANUAL TEST:")
print("="*60)

file_path = '/Users/ellie/Downloads/219.01 CONNAUGHT SQUARE/connaught apportionment.xlsx'
parser = ExcelParser(file_path)
parsed = parser.parse()

print(f"\n1. Parsed file structure:")
print(f"   Keys: {list(parsed.keys())}")
print(f"   Has 'data': {'data' in parsed}")

if 'data' in parsed:
    print(f"   data type: {type(parsed['data'])}")
    if isinstance(parsed['data'], dict):
        print(f"   Sheets: {list(parsed['data'].keys())}")
        for sheet_name in parsed['data'].keys():
            sheet = parsed['data'][sheet_name]
            print(f"   Sheet '{sheet_name}':")
            print(f"     Type: {type(sheet)}")
            print(f"     Keys: {list(sheet.keys()) if isinstance(sheet, dict) else 'N/A'}")
            if isinstance(sheet, dict) and 'raw_data' in sheet:
                print(f"     raw_data length: {len(sheet['raw_data'])}")
                if len(sheet['raw_data']) > 0:
                    print(f"     First row: {sheet['raw_data'][0]}")

# Classify it
classifier = DocumentClassifier()
category, confidence = classifier.classify(parsed)
print(f"\n2. Classification:")
print(f"   Category: {category}")
print(f"   Confidence: {confidence:.2f}")

# Now check what classify_folder would produce
categorized = classifier.classify_folder([parsed])
print(f"\n3. After classify_folder:")
for cat, files in categorized.items():
    if files:
        print(f"   {cat}: {len(files)} files")
        for f in files:
            fname = f.get('file_name', 'unknown')
            print(f"     - {fname}")
            print(f"       Has 'data' key: {'data' in f}")
            if 'data' in f:
                print(f"       data type: {type(f['data'])}")
                if isinstance(f['data'], dict):
                    print(f"       Sheets: {list(f['data'].keys())}")
