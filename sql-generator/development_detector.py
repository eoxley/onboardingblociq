#!/usr/bin/env python3
"""
Development Detection & Relational Framework
============================================
Recognizes that a Development (named estate or scheme) may consist of multiple
Buildings, each with different names, compliance assets, units, budgets, and
apportionments, but all under one master management structure.

Hierarchy: DEVELOPMENT → BUILDINGS → UNITS → LEASES

Author: SQL Generator Team
Date: 2025-10-14
"""

import re
from typing import Dict, List, Optional, Any, Set, Tuple
from collections import defaultdict
import json
from pathlib import Path


# ============================================================================
# DETECTION PATTERNS
# ============================================================================

DEVELOPMENT_PATTERNS = {
    # Development Names
    'development_name': r'(?i)(?:development|estate|scheme)\s+name[:\-]?\s*([A-Z][A-Za-z\s\'\-&,]+)',
    'estate_name': r'(?i)([A-Z][A-Za-z\s]+)\s+(?:Estate|Development|Scheme|Gardens)',
    'rtm_company': r'(?i)([A-Z][A-Za-z\s]+)\s+(?:RTM|RMC)\s+(?:Company|Co\.?)\s+(?:Ltd|Limited)',

    # Building/Block Identifiers
    'block_name': r'(?i)(Block|Core|Wing|Tower|Building)\s+([A-Z0-9]+)',
    'address_range': r'(\d+)[–\-](\d+)\s+([A-Z][A-Za-z\s]+)',
    'numbered_building': r'(\d+)\s+([A-Z][A-Za-z\s]+(?:Square|Street|Road|Avenue|Close|Place|Court|Gardens|Way|Lane))',

    # Shared Assets
    'estate_gardens': r'(?i)(?:estate|communal|shared)\s+(?:gardens?|grounds)',
    'estate_parking': r'(?i)(?:estate|communal|shared)\s+(?:car\s+park|parking)',
    'shared_services': r'(?i)(?:shared|communal|estate)\s+(?:boiler|heating|bin\s+store|entrance)',

    # Insurance & Policies
    'insurance_policy': r'(?i)(?:policy|certificate)\s+(?:number|no\.?|ref\.?)[:\-]?\s*([\w\d\-]+)',
    'shared_insurance': r'(?i)(?:joint|combined|estate|block)\s+insurance',

    # BSA Registration
    'bsa_registration': r'(?i)(?:BSA|Building\s+Safety\s+Act)\s+(?:registration|reference)[:\-]?\s*([\w\d\-]+)',

    # Master Apportionment
    'master_schedule': r'(?i)(?:master|overall|estate)\s+(?:schedule|apportionment)',
    'schedule_letter': r'(?i)Schedule\s+([A-Z])',

    # Tenure
    'tenure_type': r'(?i)(freehold|leasehold|mixed\s+tenure|commonhold)',
}


# ============================================================================
# ADDRESS PARSING & CLUSTERING
# ============================================================================

def extract_postcode(text: str) -> Optional[str]:
    """Extract UK postcode from text."""
    pattern = r'\b([A-Z]{1,2}\d{1,2}[A-Z]?)\s*(\d[A-Z]{2})\b'
    match = re.search(pattern, text)
    if match:
        return f"{match.group(1)} {match.group(2)}"
    return None


def extract_postcode_area(postcode: str) -> Optional[str]:
    """Extract postcode area (e.g., W2 from W2 4BA)."""
    if not postcode:
        return None
    match = re.match(r'([A-Z]{1,2}\d{1,2})', postcode)
    return match.group(1) if match else None


def normalize_address(address: str) -> str:
    """Normalize address for comparison."""
    # Remove flat/unit numbers
    address = re.sub(r'(?i)(?:Flat|Unit|Apartment)\s+\d+[A-Z]?,?\s*', '', address)
    # Remove punctuation
    address = re.sub(r'[,\.]', '', address)
    # Normalize whitespace
    address = re.sub(r'\s+', ' ', address).strip()
    return address.upper()


def extract_base_address(address: str) -> str:
    """
    Extract base building address without flat/unit numbers.

    Examples:
    "Flat 4, 50 Kensington Gardens Square" → "50 Kensington Gardens Square"
    "1-6 Barrow Close" → "Barrow Close"
    """
    # Remove flat/unit prefix
    address = re.sub(r'(?i)^(?:Flat|Unit|Apartment)\s+\d+[A-Z]?,?\s*', '', address)

    # Check for address range (1-6 Barrow Close)
    range_match = re.search(r'(\d+)[–\-](\d+)\s+([A-Za-z\s]+)', address)
    if range_match:
        return range_match.group(3).strip()

    # Extract street name (50 Kensington Gardens Square)
    street_match = re.search(r'\d+\s+([A-Za-z\s]+(?:Square|Street|Road|Avenue|Close|Place|Court|Gardens|Way|Lane))', address, re.IGNORECASE)
    if street_match:
        return f"{street_match.group(0).strip()}"

    return address.strip()


def cluster_addresses_by_proximity(addresses: List[str]) -> Dict[str, List[str]]:
    """
    Cluster addresses that likely belong to same development.

    Clustering rules:
    1. Same base address (street name)
    2. Same postcode area
    3. Sequential numbers on same street
    """
    clusters = defaultdict(list)

    for address in addresses:
        base = extract_base_address(address)
        postcode = extract_postcode(address)
        area = extract_postcode_area(postcode) if postcode else None

        # Create cluster key
        cluster_key = f"{base}_{area}" if area else base

        clusters[cluster_key].append(address)

    return dict(clusters)


# ============================================================================
# DEVELOPMENT DETECTOR CLASS
# ============================================================================

class DevelopmentDetector:
    """Detects development hierarchies and establishes relational structure."""

    def __init__(self):
        self.patterns = DEVELOPMENT_PATTERNS

    def detect_development_name(self, documents: List[Dict]) -> Optional[str]:
        """
        Detect development/estate name from documents.

        Priority:
        1. Explicit "Development name: X"
        2. RTM/RMC company name
        3. Estate name from insurance/budget
        4. Inferred from folder name or address clustering
        """
        combined_text = ""
        folder_names = []

        for doc in documents:
            if doc.get('text'):
                combined_text += " " + doc['text'][:5000]  # First 5000 chars
            if doc.get('folder_name'):
                folder_names.append(doc['folder_name'])

        # 1. Explicit development name
        match = re.search(self.patterns['development_name'], combined_text, re.IGNORECASE)
        if match:
            return match.group(1).strip()

        # 2. RTM Company name
        match = re.search(self.patterns['rtm_company'], combined_text, re.IGNORECASE)
        if match:
            return match.group(1).strip() + " Estate"

        # 3. Estate name
        match = re.search(self.patterns['estate_name'], combined_text, re.IGNORECASE)
        if match:
            return match.group(0).strip()

        # 4. Infer from folder name
        if folder_names:
            # Use most common folder name
            return folder_names[0]

        return None

    def detect_buildings(self, documents: List[Dict]) -> List[Dict]:
        """
        Detect distinct buildings within the development.

        Returns list of building dictionaries with:
        - building_name
        - building_alias (Block A, Core 2, etc.)
        - address
        - postcode
        """
        buildings = []
        addresses_found = set()

        for doc in documents:
            text = doc.get('text', '')

            # Extract addresses from document
            # Method 1: Numbered buildings (50 Kensington Gardens Square)
            for match in re.finditer(self.patterns['numbered_building'], text):
                number = match.group(1)
                street = match.group(2)
                address = f"{number} {street}"

                if address not in addresses_found:
                    addresses_found.add(address)

                    postcode = extract_postcode(text)

                    buildings.append({
                        'building_name': address,
                        'building_alias': None,
                        'address': address,
                        'postcode': postcode,
                        'source_document': doc.get('file_name', 'unknown')
                    })

            # Method 2: Block names
            for match in re.finditer(self.patterns['block_name'], text):
                block_type = match.group(1)
                block_id = match.group(2)
                alias = f"{block_type} {block_id}"

                # Try to find associated address
                # Look within 200 chars of block mention
                context_start = max(0, match.start() - 200)
                context_end = min(len(text), match.end() + 200)
                context = text[context_start:context_end]

                address_match = re.search(self.patterns['numbered_building'], context)
                if address_match:
                    number = address_match.group(1)
                    street = address_match.group(2)
                    address = f"{number} {street}"
                else:
                    address = alias

                if address not in addresses_found:
                    addresses_found.add(address)

                    postcode = extract_postcode(context)

                    buildings.append({
                        'building_name': address,
                        'building_alias': alias,
                        'address': address,
                        'postcode': postcode,
                        'source_document': doc.get('file_name', 'unknown')
                    })

            # Method 3: Address ranges (1-6 Barrow Close)
            for match in re.finditer(self.patterns['address_range'], text):
                start_num = match.group(1)
                end_num = match.group(2)
                street = match.group(3)
                address = f"{start_num}-{end_num} {street}"

                if address not in addresses_found:
                    addresses_found.add(address)

                    postcode = extract_postcode(text)

                    buildings.append({
                        'building_name': address,
                        'building_alias': None,
                        'address': address,
                        'postcode': postcode,
                        'source_document': doc.get('file_name', 'unknown')
                    })

        return buildings

    def detect_estate_assets(self, documents: List[Dict]) -> List[Dict]:
        """
        Detect shared estate-level assets (gardens, parking, services).

        Returns list of estate assets with type and description.
        """
        assets = []

        combined_text = ""
        for doc in documents:
            if doc.get('text'):
                combined_text += " " + doc['text']

        asset_patterns = {
            'Gardens': 'estate_gardens',
            'Parking': 'estate_parking',
            'Shared Services': 'shared_services'
        }

        for asset_type, pattern_key in asset_patterns.items():
            if re.search(self.patterns[pattern_key], combined_text, re.IGNORECASE):
                match = re.search(self.patterns[pattern_key], combined_text, re.IGNORECASE)
                assets.append({
                    'asset_type': asset_type,
                    'description': match.group(0).strip() if match else asset_type,
                    'shared_by_all_buildings': True
                })

        return assets

    def detect_tenure_type(self, documents: List[Dict]) -> Optional[str]:
        """Detect tenure type (Freehold/Leasehold/Mixed)."""
        combined_text = ""
        for doc in documents:
            if doc.get('text'):
                combined_text += " " + doc['text'][:5000]

        match = re.search(self.patterns['tenure_type'], combined_text, re.IGNORECASE)
        if match:
            return match.group(1).title()

        return None

    def detect_insurance_policy(self, documents: List[Dict]) -> Optional[Dict]:
        """Detect shared insurance policy details."""
        combined_text = ""
        for doc in documents:
            if doc.get('text'):
                combined_text += " " + doc['text']

        insurance_data = {}

        # Policy number
        match = re.search(self.patterns['insurance_policy'], combined_text, re.IGNORECASE)
        if match:
            insurance_data['policy_reference'] = match.group(1).strip()

        # Shared insurance indicator
        if re.search(self.patterns['shared_insurance'], combined_text, re.IGNORECASE):
            insurance_data['shared_across_buildings'] = True

        return insurance_data if insurance_data else None

    def detect_bsa_registration(self, documents: List[Dict]) -> Optional[str]:
        """Detect BSA registration number at development level."""
        combined_text = ""
        for doc in documents:
            if doc.get('text'):
                combined_text += " " + doc['text']

        match = re.search(self.patterns['bsa_registration'], combined_text, re.IGNORECASE)
        if match:
            return match.group(1).strip()

        return None

    def detect_master_apportionment(self, documents: List[Dict]) -> bool:
        """Detect if master/estate-level apportionment exists."""
        combined_text = ""
        for doc in documents:
            if doc.get('text'):
                combined_text += " " + doc['text']

        return bool(re.search(self.patterns['master_schedule'], combined_text, re.IGNORECASE))

    def classify_document_level(self, doc: Dict, buildings: List[Dict]) -> str:
        """
        Classify whether document attaches at development or building level.

        Development-level: insurance, estate budgets, master apportionments, management agreements
        Building-level: compliance (FRA, EICR), building budgets, repairs

        Returns: 'development' or 'building' or 'unit'
        """
        text = doc.get('text', '')
        doc_type = doc.get('document_type', '').lower()
        filename = doc.get('file_name', '').lower()

        # Development-level indicators
        development_indicators = [
            'estate', 'master', 'development', 'insurance policy',
            'management agreement', 'rtm', 'rmc', 'overall'
        ]

        # Building-level indicators
        building_indicators = [
            'fra', 'fire risk', 'eicr', 'electrical', 'asbestos',
            'legionella', 'loler', 'lift', 'block', 'building'
        ]

        # Unit-level indicators
        unit_indicators = [
            'lease', 'flat', 'unit', 'apartment', 'leaseholder'
        ]

        # Check filename and doc type
        text_lower = (text[:1000] + filename + doc_type).lower()

        # Count indicators
        dev_score = sum(1 for ind in development_indicators if ind in text_lower)
        building_score = sum(1 for ind in building_indicators if ind in text_lower)
        unit_score = sum(1 for ind in unit_indicators if ind in text_lower)

        if unit_score > max(dev_score, building_score):
            return 'unit'
        elif building_score > dev_score:
            return 'building'
        else:
            return 'development'

    def analyze_development(self, documents: List[Dict], folder_path: Optional[str] = None) -> Dict[str, Any]:
        """
        Main analysis method - detects development structure.

        Args:
            documents: List of document dicts with 'text', 'file_name', 'document_type'
            folder_path: Optional folder path for additional context

        Returns:
            Complete development structure with buildings, assets, and classifications
        """
        # 1. Detect development name
        development_name = self.detect_development_name(documents)
        if not development_name and folder_path:
            development_name = Path(folder_path).name

        # 2. Detect buildings
        buildings = self.detect_buildings(documents)

        # If no explicit buildings detected, infer from addresses in documents
        if not buildings:
            # Extract all addresses from documents
            all_addresses = []
            for doc in documents:
                text = doc.get('text', '')
                for match in re.finditer(self.patterns['numbered_building'], text):
                    address = match.group(0)
                    all_addresses.append(address)

            # Cluster addresses
            if all_addresses:
                clusters = cluster_addresses_by_proximity(list(set(all_addresses)))

                # Create building entry for each cluster
                for cluster_key, addresses in clusters.items():
                    # Use first address as representative
                    address = addresses[0]
                    postcode = extract_postcode(address)

                    buildings.append({
                        'building_name': extract_base_address(address),
                        'building_alias': None,
                        'address': address,
                        'postcode': postcode,
                        'source_document': 'inferred'
                    })

        # 3. Assign building IDs
        for i, building in enumerate(buildings):
            building['building_id'] = f"BLD-{i+1:03d}"

        # 4. Detect estate assets
        estate_assets = self.detect_estate_assets(documents)

        # 5. Detect tenure
        tenure_type = self.detect_tenure_type(documents)

        # 6. Detect insurance
        insurance = self.detect_insurance_policy(documents)

        # 7. Detect BSA registration
        bsa_registration = self.detect_bsa_registration(documents)

        # 8. Detect master apportionment
        has_master_apportionment = self.detect_master_apportionment(documents)

        # 9. Classify documents
        document_classifications = []
        for doc in documents:
            level = self.classify_document_level(doc, buildings)
            document_classifications.append({
                'file_name': doc.get('file_name', 'unknown'),
                'document_type': doc.get('document_type', 'unknown'),
                'attachment_level': level
            })

        # 10. Build development structure
        development = {
            'development_name': development_name or 'Unknown Development',
            'tenure_type': tenure_type,
            'num_buildings': len(buildings),
            'buildings': buildings,
            'estate_assets': estate_assets,
            'has_estate_service_charge': len(estate_assets) > 0,
            'has_master_apportionment': has_master_apportionment,
            'insurance_policy': insurance,
            'bsa_registration_number': bsa_registration,
            'document_classifications': document_classifications
        }

        return development


# ============================================================================
# CONVENIENCE FUNCTION
# ============================================================================

def detect_development_structure(documents: List[Dict], folder_path: Optional[str] = None) -> Dict[str, Any]:
    """
    Main entry point for development detection.

    Args:
        documents: List of document dicts
        folder_path: Optional folder path

    Returns:
        Development structure with hierarchy
    """
    detector = DevelopmentDetector()
    return detector.analyze_development(documents, folder_path)


# ============================================================================
# CLI & TESTING
# ============================================================================

if __name__ == "__main__":
    # Test with multi-building development
    test_docs = [
        {
            'text': """
            Kensington Gardens Estate RTM Company Limited

            Development comprising 50, 52, and 54 Kensington Gardens Square, London W2 4BA

            Block A: 50 Kensington Gardens Square (8 units)
            Block B: 52 Kensington Gardens Square (10 units)
            Block C: 54 Kensington Gardens Square (6 units)

            Estate Insurance Policy No: KGE-INS-2025

            Shared facilities include:
            - Estate gardens
            - Communal car park
            - Bin storage area
            - Shared heating system

            Master apportionment schedule applies across all three buildings.

            BSA Registration: BSA-KGE-12345

            Tenure: Leasehold
            """,
            'file_name': 'Estate_Overview.pdf',
            'document_type': 'Management Agreement'
        },
        {
            'text': """
            Fire Risk Assessment - Block A
            50 Kensington Gardens Square
            Date: 15 March 2025
            Risk Rating: Low
            Next review: 15 March 2026
            """,
            'file_name': 'FRA_Block_A.pdf',
            'document_type': 'FRA'
        },
        {
            'text': """
            EICR - Block B
            52 Kensington Gardens Square
            Inspection Date: 20 June 2022
            Result: Satisfactory
            Next due: 20 June 2027
            """,
            'file_name': 'EICR_Block_B.pdf',
            'document_type': 'EICR'
        },
        {
            'text': """
            Lease for Flat 4, 50 Kensington Gardens Square
            Tenant: John Smith
            Term: 125 years from 1996
            Ground Rent: £250 p.a.
            Service Charge: 12.45%
            """,
            'file_name': 'Lease_Flat_4.pdf',
            'document_type': 'Lease'
        }
    ]

    # Run detection
    result = detect_development_structure(test_docs, "/handover/Kensington Gardens Estate")

    # Pretty print
    print("\n" + "="*70)
    print("DEVELOPMENT STRUCTURE DETECTION")
    print("="*70)

    print(f"\n🏘️ DEVELOPMENT: {result['development_name']}")
    print(f"   Tenure: {result.get('tenure_type', 'N/A')}")
    print(f"   Buildings: {result['num_buildings']}")
    print(f"   Master Apportionment: {'Yes' if result['has_master_apportionment'] else 'No'}")
    print(f"   Estate Service Charge: {'Yes' if result['has_estate_service_charge'] else 'No'}")

    if result.get('bsa_registration_number'):
        print(f"   BSA Registration: {result['bsa_registration_number']}")

    if result.get('insurance_policy'):
        print(f"   Insurance Policy: {result['insurance_policy'].get('policy_reference', 'N/A')}")

    print(f"\n🏢 BUILDINGS ({len(result['buildings'])}):")
    for building in result['buildings']:
        alias = f" ({building['building_alias']})" if building.get('building_alias') else ""
        print(f"   {building['building_id']}: {building['building_name']}{alias}")
        print(f"      Address: {building['address']}")
        print(f"      Postcode: {building.get('postcode', 'N/A')}")

    if result['estate_assets']:
        print(f"\n🌳 ESTATE ASSETS ({len(result['estate_assets'])}):")
        for asset in result['estate_assets']:
            print(f"   {asset['asset_type']}: {asset['description']}")

    print(f"\n📄 DOCUMENT CLASSIFICATIONS ({len(result['document_classifications'])}):")
    for doc_class in result['document_classifications']:
        level_emoji = {'development': '🏘️', 'building': '🏢', 'unit': '🏠'}.get(doc_class['attachment_level'], '📄')
        print(f"   {level_emoji} {doc_class['file_name']}: {doc_class['attachment_level']}")

    # Save JSON
    output_path = Path(__file__).parent / "output" / "development_structure.json"
    output_path.parent.mkdir(exist_ok=True)

    with open(output_path, 'w') as f:
        json.dump(result, f, indent=2)

    print(f"\n✅ Development structure saved to: {output_path}")
    print("="*70 + "\n")
