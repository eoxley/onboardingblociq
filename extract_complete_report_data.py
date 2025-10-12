#!/usr/bin/env python3
"""
Extract Complete Report Data
Extracts apportionments with unit linkage and lease reference numbers
"""

import re
import json
import pandas as pd
from pathlib import Path

def extract_apportionments_from_excel(excel_path: str):
    """Extract apportionments with unit numbers from Excel"""
    try:
        df = pd.read_excel(excel_path)
        print(f"✓ Loaded {excel_path}")
        print(f"  Columns: {list(df.columns)}")
        print(f"  Shape: {df.shape}")
        print("\nFirst few rows:")
        print(df.head(10))

        # Try to find unit and percentage columns
        apportionments = []

        # Look for common patterns
        unit_col = None
        pct_col = None

        for col in df.columns:
            col_lower = str(col).lower()
            if 'unit' in col_lower or 'flat' in col_lower:
                if 'description' in col_lower or 'ref' in col_lower:
                    unit_col = col
            if 'percent' in col_lower or '%' in col_lower or 'apport' in col_lower or 'rate' in col_lower:
                pct_col = col

        print(f"  Unit column: {unit_col}")
        print(f"  Percentage column: {pct_col}")

        if unit_col and pct_col:
            for _, row in df.iterrows():
                unit_desc = str(row[unit_col]).strip()
                pct = row[pct_col]

                # Extract "Flat 1" from "Flat 1 32-34 Connaught Square"
                flat_match = re.search(r'(Flat \d+)', unit_desc, re.IGNORECASE)
                unit = flat_match.group(1) if flat_match else unit_desc

                if pd.notna(unit) and pd.notna(pct) and unit:
                    try:
                        percentage = float(pct) if isinstance(pct, (int, float)) else float(str(pct).replace('%', ''))
                        apportionments.append({
                            'unit': unit,
                            'percentage': percentage
                        })
                    except (ValueError, AttributeError):
                        pass

        return apportionments

    except Exception as e:
        print(f"❌ Error reading Excel: {e}")
        return []


def extract_lease_references_from_filenames(property_folder: str):
    """Extract lease title numbers and dates from filenames"""
    property_path = Path(property_folder)
    lease_refs = []

    # Pattern: Official Copy (Lease) DD.MM.YYYY - NGLXXXXXX
    pattern = r'Official Copy.*?(\d{2}\.\d{2}\.\d{4}).*?(NGL\d+)'

    # Search for lease PDFs
    for pdf_file in property_path.rglob("*.pdf"):
        filename = pdf_file.name

        if 'official' in filename.lower() and 'lease' in filename.lower():
            date_match = re.search(r'(\d{2}\.\d{2}\.\d{4})', filename)
            title_match = re.search(r'(NGL\d+)', filename)

            if date_match or title_match:
                lease_refs.append({
                    'document': 'Official Copy (Lease)',
                    'title_number': title_match.group(1) if title_match else 'TBC',
                    'date': date_match.group(1) if date_match else 'TBC',
                    'flat': 'Flat 4' if 'flat 4' in filename.lower() else None,
                    'filename': filename
                })

    # Remove duplicates based on title number
    unique_refs = {}
    for ref in lease_refs:
        title = ref['title_number']
        if title not in unique_refs:
            unique_refs[title] = ref

    return list(unique_refs.values())


if __name__ == '__main__':
    property_folder = "/Users/ellie/Downloads/219.01 CONNAUGHT SQUARE"
    excel_path = f"{property_folder}/connaught apportionment.xlsx"

    print("="*70)
    print("EXTRACTING APPORTIONMENTS")
    print("="*70)
    apportionments = extract_apportionments_from_excel(excel_path)

    print(f"\n✅ Found {len(apportionments)} apportionments:")
    for app in apportionments:
        print(f"  {app['unit']}: {app['percentage']}%")

    print("\n" + "="*70)
    print("EXTRACTING LEASE REFERENCES")
    print("="*70)
    lease_refs = extract_lease_references_from_filenames(property_folder)

    print(f"\n✅ Found {len(lease_refs)} lease references:")
    for ref in lease_refs:
        flat_info = f" ({ref['flat']})" if ref['flat'] else ""
        print(f"  {ref['title_number']} - {ref['date']}{flat_info}")

    # Save to JSON
    output_data = {
        'apportionments': apportionments,
        'lease_references': lease_refs
    }

    output_path = '/Users/ellie/Desktop/BlocIQ_Output/extracted_report_data.json'
    with open(output_path, 'w') as f:
        json.dump(output_data, f, indent=2)

    print(f"\n✅ Data saved to: {output_path}")
