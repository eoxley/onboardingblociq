#!/usr/bin/env python3
"""
Leaseholder & Contact Details Extractor
========================================
Extracts leaseholder information from multiple sources:
1. Leases (tenant names, demised premises)
2. Correspondence folders (unit-specific files)
3. Service charge accounts/invoices (billing addresses)
4. Meeting minutes (directors/shareholders)
5. Company information (registered addresses)

Links units to leaseholders with contact details.

Author: BlocIQ Team
Date: 2025-10-14
"""

import re
import sys
from pathlib import Path
from typing import Dict, List, Optional
from collections import defaultdict
import pdfplumber


class LeaseholderExtractor:
    """Extract and link leaseholder information to units"""

    def __init__(self, building_folder: Path, units: List[Dict]):
        """
        Initialize extractor

        Args:
            building_folder: Path to building document folder
            units: List of unit dictionaries from apportionment
        """
        self.building_folder = building_folder
        self.units = units

        # Results
        self.leaseholders = []
        self.unit_leaseholder_links = {}

    def extract_all(self) -> Dict:
        """
        Extract all leaseholder data from all sources

        Returns:
            Dict with leaseholders and unit links
        """
        print("\n" + "="*80)
        print("LEASEHOLDER & CONTACT DETAILS EXTRACTION")
        print("="*80)

        # 1. Extract from leases
        lease_data = self._extract_from_leases()

        # 2. Extract from correspondence folders
        correspondence_data = self._extract_from_correspondence()

        # 3. Extract from service charge accounts
        account_data = self._extract_from_accounts()

        # 4. Merge and link to units
        self._merge_and_link(lease_data, correspondence_data, account_data)

        return {
            'leaseholders': self.leaseholders,
            'unit_leaseholder_links': self.unit_leaseholder_links,
            'summary': {
                'total_leaseholders': len(self.leaseholders),
                'units_with_leaseholders': len(self.unit_leaseholder_links),
                'units_without_leaseholders': len(self.units) - len(self.unit_leaseholder_links),
            }
        }

    def _extract_from_leases(self) -> Dict:
        """Extract leaseholder names from lease documents"""
        print("\n" + "-"*80)
        print("1. EXTRACTING FROM LEASE DOCUMENTS")
        print("-"*80)

        lease_data = {}
        lease_folder = self.building_folder / "1. CLIENT INFORMATION" / "1.02 LEASES"

        if not lease_folder.exists():
            print("⚠️  Lease folder not found")
            return lease_data

        lease_files = list(lease_folder.glob("*.pdf"))
        print(f"Found {len(lease_files)} lease documents")

        for lease_file in lease_files:
            print(f"\n📄 {lease_file.name}")

            try:
                with pdfplumber.open(lease_file) as pdf:
                    # Extract first 10 pages
                    text = ""
                    for page in pdf.pages[:10]:
                        text += (page.extract_text() or "") + "\n"

                    # Extract leaseholder name
                    leaseholder = None

                    # Pattern 1: (2) NAME format
                    match = re.search(r'\(2\)\s+([A-Z][a-z]+(?:\s+[A-Z][a-z]+){1,3})', text)
                    if match:
                        leaseholder = match.group(1).strip()
                        print(f"   Leaseholder: {leaseholder}")

                    # Pattern 2: TENANT: NAME
                    if not leaseholder:
                        match = re.search(r'(?:TENANT|LEASEHOLDER)[:\s]+([A-Z][a-z]+(?:\s+[A-Z][a-z]+)+)', text, re.IGNORECASE)
                        if match:
                            leaseholder = match.group(1).strip()
                            print(f"   Leaseholder: {leaseholder}")

                    # Extract demised premises (unit reference)
                    unit_ref = None

                    # Pattern: Flat X, Unit X, Apartment X
                    premises_patterns = [
                        r'(Flat\s+\d+)',
                        r'(Unit\s+\d+)',
                        r'(Apartment\s+\d+)',
                    ]

                    for pattern in premises_patterns:
                        match = re.search(pattern, text, re.IGNORECASE)
                        if match:
                            unit_ref = match.group(1).title()  # "Flat 4"
                            print(f"   Unit: {unit_ref}")
                            break

                    # Extract title number
                    title_match = re.search(r'Title\s+Number[:\s]*([A-Z]{2,4}\d{6})', text, re.IGNORECASE)
                    title_number = title_match.group(1) if title_match else None

                    # Extract correspondence address (if present)
                    address = None
                    # Look for address after tenant name
                    if leaseholder:
                        # Pattern: Name, followed by address with postcode
                        address_pattern = rf'{re.escape(leaseholder)}[,\s]+([^,]+,[^,]+,[A-Z0-9]{2,4}\s+\d[A-Z]{{2}})'
                        match = re.search(address_pattern, text)
                        if match:
                            address = match.group(1).strip()
                            print(f"   Address: {address}")

                    if unit_ref and leaseholder:
                        lease_data[unit_ref] = {
                            'leaseholder_name': leaseholder,
                            'unit_reference': unit_ref,
                            'title_number': title_number,
                            'correspondence_address': address,
                            'source_document': lease_file.name,
                            'data_source': 'lease',
                        }

            except Exception as e:
                print(f"   ⚠️  Error: {e}")

        print(f"\n✅ Extracted {len(lease_data)} leaseholders from leases")
        return lease_data

    def _extract_from_correspondence(self) -> Dict:
        """Extract from flat correspondence folders"""
        print("\n" + "-"*80)
        print("2. EXTRACTING FROM CORRESPONDENCE FOLDERS")
        print("-"*80)

        correspondence_data = {}
        corr_folder = self.building_folder / "8. FLAT CORRESPONDENCE"

        if not corr_folder.exists():
            print("⚠️  Correspondence folder not found")
            return correspondence_data

        # Each subfolder should be named after a unit
        unit_folders = [f for f in corr_folder.iterdir() if f.is_dir()]
        print(f"Found {len(unit_folders)} unit folders")

        for folder in unit_folders:
            # Extract unit number from folder name
            unit_match = re.search(r'(Flat|Unit|Apartment)\s*(\d+)', folder.name, re.IGNORECASE)
            if not unit_match:
                continue

            unit_ref = f"{unit_match.group(1).title()} {unit_match.group(2)}"
            print(f"\n📁 {unit_ref}:")

            # Look for documents with leaseholder info
            pdf_files = list(folder.glob("*.pdf"))

            if pdf_files:
                # Try first PDF for contact info
                try:
                    with pdfplumber.open(pdf_files[0]) as pdf:
                        text = (pdf.pages[0].extract_text() or "") if pdf.pages else ""

                        # Extract name (look for "Dear X" or names at top)
                        name = None
                        name_patterns = [
                            r'Dear\s+(?:Mr|Mrs|Ms|Miss|Dr)?\s*([A-Z][a-z]+(?:\s+[A-Z][a-z]+)+)',
                            r'^([A-Z][a-z]+\s+[A-Z][a-z]+)',  # First line
                        ]

                        for pattern in name_patterns:
                            match = re.search(pattern, text, re.MULTILINE)
                            if match:
                                name = match.group(1).strip()
                                print(f"   Name: {name}")
                                break

                        # Extract address (look for UK postcode)
                        address = None
                        postcode_pattern = r'([A-Z0-9]{2,4}\s+\d[A-Z]{2})'
                        match = re.search(postcode_pattern, text)
                        if match:
                            postcode = match.group(1)
                            # Get 2-3 lines before postcode
                            lines = text.split('\n')
                            for i, line in enumerate(lines):
                                if postcode in line:
                                    # Get previous 2-3 lines as address
                                    address_lines = lines[max(0, i-2):i+1]
                                    address = ', '.join(l.strip() for l in address_lines if l.strip())
                                    print(f"   Address: {address}")
                                    break

                        # Extract email
                        email = None
                        email_match = re.search(r'([a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,})', text)
                        if email_match:
                            email = email_match.group(1)
                            print(f"   Email: {email}")

                        # Extract phone
                        phone = None
                        phone_patterns = [
                            r'(?:Tel|Phone|Mobile)[:\s]*(\+?\d[\d\s-]{9,})',
                            r'(\+44\s*\d{10})',
                            r'(0\d{10})',
                        ]
                        for pattern in phone_patterns:
                            match = re.search(pattern, text, re.IGNORECASE)
                            if match:
                                phone = match.group(1).strip()
                                print(f"   Phone: {phone}")
                                break

                        if name or address or email or phone:
                            correspondence_data[unit_ref] = {
                                'leaseholder_name': name,
                                'correspondence_address': address,
                                'email': email,
                                'phone': phone,
                                'unit_reference': unit_ref,
                                'source_document': pdf_files[0].name,
                                'data_source': 'correspondence',
                            }

                except Exception as e:
                    print(f"   ⚠️  Error: {e}")

        print(f"\n✅ Extracted {len(correspondence_data)} leaseholder details from correspondence")
        return correspondence_data

    def _extract_from_accounts(self) -> Dict:
        """Extract from service charge accounts/invoices"""
        print("\n" + "-"*80)
        print("3. EXTRACTING FROM SERVICE CHARGE ACCOUNTS")
        print("-"*80)

        account_data = {}
        finance_folder = self.building_folder / "2. FINANCE"

        if not finance_folder.exists():
            print("⚠️  Finance folder not found")
            return account_data

        # Look for aged debtors or account files
        account_files = list(finance_folder.glob("**/*debtors*.pdf")) + \
                       list(finance_folder.glob("**/*account*.pdf"))

        print(f"Found {len(account_files)} account documents")

        # For now, return empty - would need to parse account PDFs
        # This would extract billing addresses and payment status

        return account_data

    def _merge_and_link(self, lease_data: Dict, correspondence_data: Dict, account_data: Dict):
        """Merge data from all sources and link to units"""
        print("\n" + "-"*80)
        print("4. MERGING DATA AND LINKING TO UNITS")
        print("-"*80)

        # Create map of all leaseholder data by unit
        all_data = defaultdict(dict)

        # Merge lease data
        for unit_ref, data in lease_data.items():
            all_data[unit_ref].update(data)

        # Merge correspondence data (overwrite/supplement)
        for unit_ref, data in correspondence_data.items():
            for key, value in data.items():
                if value and (key not in all_data[unit_ref] or not all_data[unit_ref].get(key)):
                    all_data[unit_ref][key] = value

        # Merge account data
        for unit_ref, data in account_data.items():
            for key, value in data.items():
                if value and (key not in all_data[unit_ref] or not all_data[unit_ref].get(key)):
                    all_data[unit_ref][key] = value

        # Link to units
        for unit in self.units:
            unit_number = unit.get('unit_number')  # "Flat 1"

            if unit_number in all_data:
                leaseholder_data = all_data[unit_number]

                # Create leaseholder record
                leaseholder = {
                    'unit_number': unit_number,
                    'unit_reference': unit.get('unit_reference'),
                    'leaseholder_name': leaseholder_data.get('leaseholder_name'),
                    'correspondence_address': leaseholder_data.get('correspondence_address'),
                    'email': leaseholder_data.get('email'),
                    'phone': leaseholder_data.get('phone'),
                    'title_number': leaseholder_data.get('title_number'),
                    'data_sources': [leaseholder_data.get('data_source', 'unknown')],
                    'data_quality': 'high' if leaseholder_data.get('leaseholder_name') else 'medium',
                }

                self.leaseholders.append(leaseholder)
                self.unit_leaseholder_links[unit_number] = leaseholder

                print(f"\n✅ {unit_number}:")
                print(f"   Name: {leaseholder.get('leaseholder_name', 'Unknown')}")
                if leaseholder.get('email'):
                    print(f"   Email: {leaseholder['email']}")
                if leaseholder.get('phone'):
                    print(f"   Phone: {leaseholder['phone']}")
                if leaseholder.get('correspondence_address'):
                    print(f"   Address: {leaseholder['correspondence_address'][:50]}...")
            else:
                print(f"\n⚠️  {unit_number}: No leaseholder data found")

        print(f"\n✅ Linked {len(self.unit_leaseholder_links)} units to leaseholders")


if __name__ == "__main__":
    from pathlib import Path
    import pandas as pd

    BUILDING_FOLDER = Path("/Users/ellie/Downloads/219.01 CONNAUGHT SQUARE")

    # Load units from apportionment
    apportionment_df = pd.read_excel(BUILDING_FOLDER / "connaught apportionment.xlsx")
    units = []
    for idx, row in apportionment_df.iterrows():
        unit_desc = row['Unit description']
        parts = unit_desc.split()
        units.append({
            "unit_number": f"{parts[0]} {parts[1]}",
            "unit_reference": row['Unit reference'],
        })

    # Extract leaseholders
    extractor = LeaseholderExtractor(BUILDING_FOLDER, units)
    result = extractor.extract_all()

    # Summary
    print("\n" + "="*80)
    print("SUMMARY")
    print("="*80)
    print(f"\nTotal Units: {len(units)}")
    print(f"Leaseholders Found: {result['summary']['total_leaseholders']}")
    print(f"Units Linked: {result['summary']['units_with_leaseholders']}")
    print(f"Units Missing Data: {result['summary']['units_without_leaseholders']}")

    # Show all leaseholders
    print("\n" + "="*80)
    print("ALL LEASEHOLDERS")
    print("="*80)
    for lh in result['leaseholders']:
        print(f"\n{lh['unit_number']}:")
        print(f"  Name: {lh.get('leaseholder_name', 'Unknown')}")
        print(f"  Email: {lh.get('email', 'Not found')}")
        print(f"  Phone: {lh.get('phone', 'Not found')}")
        print(f"  Address: {lh.get('correspondence_address', 'Not found')}")
        print(f"  Title: {lh.get('title_number', 'Not found')}")
        print(f"  Sources: {', '.join(lh.get('data_sources', []))}")

    print("\n" + "="*80)
