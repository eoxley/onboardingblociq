#!/usr/bin/env python3
"""
Lease Analysis & Covenant Extraction
====================================
Automatically extracts and standardises core legal, financial, and covenant data
from lease documents (and related deeds or variations).

Output is structured (JSON/SQL-ready), explainable (with clause references),
searchable (for Ask BlocIQ natural language queries), and resilient (works with
missing pages or scanned OCR text).

Author: SQL Generator Team
Date: 2025-10-14
"""

import re
from datetime import datetime, timedelta
from dateutil import parser as date_parser
from typing import Dict, List, Optional, Any, Tuple
import json
from pathlib import Path


# ============================================================================
# REGEX PATTERNS FOR LEASE EXTRACTION
# ============================================================================

LEASE_PATTERNS = {
    # Lease Identity
    'lease_date': r'(?i)(?:lease\s*(?:is\s*)?dated)\s*(?:the\s*)?(\d{1,2}(?:st|nd|rd|th)?\s+\w+\s+\d{4})',
    'lease_term': r'(?i)(?:TERM|term\s*of|for\s*a\s*term\s*of)[:\-]?\s*(\d{1,3})\s*(?:years|yrs)',
    'lease_start': r'(?i)(?:from\s*and\s*including|commencing|from)\s+(?:the\s*)?(\d{1,2}(?:st|nd|rd|th)?\s+\w+\s+\d{4})',
    'lease_end': r'(?i)(?:expiring|to|until|ending)\s*(?:on\s*)?(?:the\s*)?(\d{1,2}(?:st|nd|rd|th)?\s+\w+\s+\d{4})',
    'title_number': r'(?i)(?:TITLE\s*NUMBER|title\s*number|title\s*no\.?)\s*[:\-]?\s*([A-Z]{2,3}\d{5,7})',
    'landlord': r'(?i)\(\d\)\s+([A-Z][A-Z\s&\.]+(?:LTD|LIMITED|LLP|COMPANY)?)\s*\([Cc]ompany',
    'tenant': r'(?i)\(\d\)\s+([A-Z][A-Z\s]+)\s+of\s+\d',
    'demised_premises': r'(?i)(?:DEMISED\s*PREMISES|demised\s*premises)[:\-]?\s*([A-Za-z0-9][A-Za-z0-9\s,\.\-]+?)(?:\s*$|\n)',
    'lease_type': r'(?i)(underlease|under-lease|headlease|head\s*lease|long\s*leasehold)',

    # Ground Rent
    'ground_rent': r'(?i)(?:ground\s*rent)[:\-]?\s*£?\s*([\d,]+(?:\.\d{2})?)\s*(?:per\s*annum|p\.?a\.?)?',
    'ground_rent_review': r'(?i)(?:review|increase|revised)\s*(?:every|each)\s*(\d{1,2})\s*(?:years|yrs)',
    'ground_rent_pattern': r'(?i)(double|doubling|doubles|rpi|r\.p\.i\.|cpi|c\.p\.i\.|index-linked|retail\s*price\s*index)',
    'ground_rent_payable_to': r'(?i)(?:payable\s*to|paid\s*to)\s*(?:the\s*)?(freeholder|landlord|superior\s*landlord|headlessor)',

    # Service Charge
    'service_charge_percentage': r'(?i)service\s*charge\s*equal\s*to\s*(\d{1,3}(?:\.\d{2})?)%',
    'service_charge_fixed': r'(?i)(?:fixed|specified)\s*(?:service\s*charge|sum)\s*of\s*£?\s*([\d,]+(?:\.\d{2})?)',
    'service_charge_variable': r'(?i)(variable\s*service\s*charge|fair\s*proportion|reasonable\s*proportion)',
    'service_charge_exclusions': r'(?i)(?:excluding|does\s*not\s*include)\s+([^\.]+)',

    # Repair & Maintenance
    'tenant_repairs': r'(?i)To\s+keep\s+and\s+maintain\s+the\s+internal\s+parts[^\.]+',
    'landlord_repairs': r'(?i)To\s+keep\s+in\s+repair.*?(?:structure|roof|foundations|external|common\s*parts)[^\.]+',
    'decorations': r'(?i)(?:decorate|paint|decoration).*?every\s*(\d{1,2})\s*(?:years|yrs)',

    # Use & Restrictions
    'use_clause': r'(?i)To\s+use\s+the\s+Demised\s+Premises\s+as\s+([^\.]+)',
    'pets': r'(?i)Not\s+to\s+keep\s+any\s+(?:pets|animals)[^\.]+\.',
    'flooring': r'(?i)Not\s+to\s+lay\s+any\s+(?:timber|wooden|laminate)[^\.]+\.',
    'subletting': r'(?i)Not\s+to\s+underlet[^\.]+\.',
    'alterations': r'(?i)Not\s+to.*?(?:alterations|improvements|structural)[^\.]+\.',
    'business_use': r'(?i)Not\s+to\s+carry\s+on\s+any\s+(?:trade|business|profession)[^\.]+\.',
    'nuisance': r'(?i)Not\s+to\s+cause\s+any\s+(?:nuisance|noise|annoyance)[^\.]+\.',

    # Insurance
    'insurance_by': r'(?i)(?:landlord|lessor)\s*(?:shall|must|to)\s*(?:insure|effect\s*insurance|maintain\s*insurance)',
    'insurance_reinstatement': r'(?i)(?:full\s*(?:reinstatement\s*)?value|replacement\s*value|rebuild\s*value)',
    'insurance_excess': r'(?i)(?:excess|deductible)\s*[:\-]?\s*£?\s*([\d,]+)',

    # Enforcement
    'forfeiture': r'(?i)(?:forfeiture|re-entry|reentry)\s*[:\-]?\s*([^\.]+?)(?:days?\s*notice|\d{1,2}\s*days)',
    'interest_arrears': r'(?i)(?:interest)\s*(?:at|of)\s*(\d{1,2}(?:\.\d+)?%?)\s*(?:above|over)?\s*(?:base\s*rate)?',

    # Miscellaneous
    'car_space': r'(?i)(parking\s*space|car\s*space|garage)[:\-]?\s*([^\.]+)',
    'storage': r'(?i)(storage|store|locker|cellar)[:\-]?\s*([^\.]+)',
    'garden_balcony': r'(?i)(garden|balcony|terrace|patio)[:\-]?\s*([^\.]+)',
    'alienation': r'(?i)(assign|assignment|transfer)[^\.]+?(consent\s*not\s*to\s*be\s*unreasonably\s*withheld|subject\s*to\s*consent)',
}


# ============================================================================
# HELPER FUNCTIONS
# ============================================================================

def clean_extracted_text(text: str) -> str:
    """Clean extracted text by removing extra whitespace and normalizing."""
    if not text:
        return ""

    # Remove multiple spaces
    text = re.sub(r'\s+', ' ', text)
    # Remove leading/trailing whitespace
    text = text.strip()
    # Remove common OCR artifacts
    text = re.sub(r'[_\*]{3,}', '', text)

    return text


def parse_lease_date(date_str: str) -> Optional[str]:
    """Parse various date formats into ISO format (YYYY-MM-DD)."""
    if not date_str:
        return None

    try:
        # Remove ordinal indicators (st, nd, rd, th)
        date_str = re.sub(r'(\d+)(?:st|nd|rd|th)', r'\1', date_str)

        # Parse with dateutil (UK format preferred)
        dt = date_parser.parse(date_str, dayfirst=True)
        return dt.strftime('%Y-%m-%d')
    except:
        return None


def extract_with_context(text: str, pattern: str, context_lines: int = 3) -> List[Tuple[str, str]]:
    """
    Extract pattern matches with surrounding context.

    Returns: List of (match, context) tuples
    """
    results = []

    # Split text into lines for context
    lines = text.split('\n')

    for i, line in enumerate(lines):
        matches = re.finditer(pattern, line, re.IGNORECASE)
        for match in matches:
            # Get context (±3 lines)
            start_idx = max(0, i - context_lines)
            end_idx = min(len(lines), i + context_lines + 1)
            context = '\n'.join(lines[start_idx:end_idx])

            results.append((match.group(0), clean_extracted_text(context)))

    return results


def determine_consent_required(clause_text: str) -> bool:
    """Check if a restriction allows action with consent."""
    clause_lower = clause_text.lower()

    # Check for absolute prohibitions first
    if 'not to' in clause_lower and 'without' not in clause_lower:
        return False

    consent_phrases = [
        'with consent', 'with prior consent', 'with written consent',
        'subject to consent', 'consent not to be unreasonably withheld',
        'landlord\'s consent', 'lessor\'s consent', 'save that'
    ]

    return any(phrase in clause_lower for phrase in consent_phrases)


def classify_clause_type(clause_text: str) -> str:
    """Classify clause into standard types for Ask BlocIQ."""
    clause_lower = clause_text.lower()

    if any(word in clause_lower for word in ['pet', 'animal', 'dog', 'cat', 'bird']):
        return 'Pets'
    elif any(word in clause_lower for word in ['floor', 'flooring', 'timber', 'laminate', 'wooden']):
        return 'Flooring'
    elif any(word in clause_lower for word in ['sublet', 'underlet', 'subletting', 'underletting']):
        return 'Subletting'
    elif any(word in clause_lower for word in ['alteration', 'improvement', 'structural']):
        return 'Alterations'
    elif any(word in clause_lower for word in ['business', 'trade', 'profession', 'calling']):
        return 'Business Use'
    elif any(word in clause_lower for word in ['nuisance', 'noise', 'annoyance']):
        return 'Nuisance'
    elif any(word in clause_lower for word in ['repair', 'maintain', 'decoration']):
        return 'Repairs'
    elif any(word in clause_lower for word in ['insurance', 'insure']):
        return 'Insurance'
    elif any(word in clause_lower for word in ['assign', 'transfer', 'alienation']):
        return 'Alienation'
    else:
        return 'General'


def extract_amount(text: str) -> Optional[float]:
    """Extract monetary amount from text."""
    pattern = r'£?\s*([\d,]+(?:\.\d{2})?)'
    match = re.search(pattern, text)

    if match:
        amount_str = match.group(1).replace(',', '')
        try:
            return float(amount_str)
        except:
            return None

    return None


# ============================================================================
# MAIN EXTRACTION CLASS
# ============================================================================

class LeaseAnalyzer:
    """Main class for lease document analysis and covenant extraction."""

    def __init__(self):
        self.patterns = LEASE_PATTERNS

    def extract_lease_metadata(self, text: str) -> Dict[str, Any]:
        """Extract core lease identity and metadata."""
        data = {}

        # Lease type
        match = re.search(self.patterns['lease_type'], text, re.IGNORECASE)
        if match:
            data['lease_type'] = match.group(1).title()

        # Lease date
        match = re.search(self.patterns['lease_date'], text, re.IGNORECASE)
        if match:
            data['lease_date'] = parse_lease_date(match.group(1))

        # Lease term (years)
        match = re.search(self.patterns['lease_term'], text, re.IGNORECASE)
        if match:
            data['lease_term_years'] = int(match.group(1))

        # Start date
        match = re.search(self.patterns['lease_start'], text, re.IGNORECASE)
        if match:
            data['lease_term_start'] = parse_lease_date(match.group(1))

        # End date (explicit or calculated)
        match = re.search(self.patterns['lease_end'], text, re.IGNORECASE)
        if match:
            data['lease_term_end'] = parse_lease_date(match.group(1))
        elif data.get('lease_term_start') and data.get('lease_term_years'):
            # Calculate end date
            start_date = datetime.strptime(data['lease_term_start'], '%Y-%m-%d')
            end_date = start_date + timedelta(days=data['lease_term_years'] * 365)
            data['lease_term_end'] = end_date.strftime('%Y-%m-%d')

        # Title number
        match = re.search(self.patterns['title_number'], text, re.IGNORECASE)
        if match:
            data['title_number'] = match.group(1).upper()

        # Landlord
        match = re.search(self.patterns['landlord'], text, re.IGNORECASE)
        if match:
            landlord = clean_extracted_text(match.group(1))
            # Remove trailing prepositions
            landlord = re.sub(r'\s+(of|whose|registered)\s*$', '', landlord, flags=re.IGNORECASE)
            data['landlord_name'] = landlord

        # Tenant
        match = re.search(self.patterns['tenant'], text, re.IGNORECASE)
        if match:
            tenant = clean_extracted_text(match.group(1))
            tenant = re.sub(r'\s+(of|whose|registered)\s*$', '', tenant, flags=re.IGNORECASE)
            data['tenant_name'] = tenant

        # Demised premises
        match = re.search(self.patterns['demised_premises'], text, re.IGNORECASE)
        if match:
            premises = clean_extracted_text(match.group(1))
            premises = re.sub(r'\s+(in|at|London|comprised)\s*$', '', premises, flags=re.IGNORECASE)
            data['demised_premises'] = premises

        return data

    def extract_ground_rent(self, text: str) -> Dict[str, Any]:
        """Extract ground rent details and review patterns."""
        data = {}

        # Ground rent amount
        match = re.search(self.patterns['ground_rent'], text, re.IGNORECASE)
        if match:
            amount_str = match.group(1).replace(',', '')
            try:
                data['ground_rent_amount'] = float(amount_str)
            except:
                pass

        # Review period
        review_years = None
        match = re.search(self.patterns['ground_rent_review'], text, re.IGNORECASE)
        if match:
            review_years = int(match.group(1))

        # Review pattern
        match = re.search(self.patterns['ground_rent_pattern'], text, re.IGNORECASE)
        if match:
            pattern_type = match.group(1).lower()
            if 'double' in pattern_type or 'doubling' in pattern_type:
                if review_years:
                    data['ground_rent_review_pattern'] = f"Doubles every {review_years} years"
                else:
                    data['ground_rent_review_pattern'] = "Doubles periodically"
            elif 'rpi' in pattern_type or 'retail price index' in pattern_type:
                data['ground_rent_review_pattern'] = "RPI-linked"
            elif 'cpi' in pattern_type:
                data['ground_rent_review_pattern'] = "CPI-linked"
            elif 'index' in pattern_type:
                data['ground_rent_review_pattern'] = "Index-linked"

        # Payable to
        match = re.search(self.patterns['ground_rent_payable_to'], text, re.IGNORECASE)
        if match:
            data['ground_rent_payable_to'] = match.group(1).title()

        return data

    def extract_service_charge(self, text: str) -> Dict[str, Any]:
        """Extract service charge basis, percentage, and exclusions."""
        data = {}

        # Percentage-based
        match = re.search(self.patterns['service_charge_percentage'], text, re.IGNORECASE)
        if match:
            data['service_charge_basis'] = 'Percentage'
            data['service_charge_percentage'] = float(match.group(1))

        # Fixed amount
        match = re.search(self.patterns['service_charge_fixed'], text, re.IGNORECASE)
        if match:
            data['service_charge_basis'] = 'Fixed'
            amount = extract_amount(match.group(0))
            if amount:
                data['service_charge_fixed_amount'] = amount

        # Variable
        if re.search(self.patterns['service_charge_variable'], text, re.IGNORECASE):
            if 'service_charge_basis' not in data:
                data['service_charge_basis'] = 'Variable'

        # Exclusions
        match = re.search(self.patterns['service_charge_exclusions'], text, re.IGNORECASE)
        if match:
            exclusion_text = clean_extracted_text(match.group(0))
            data['service_charge_exclusions'] = exclusion_text

        return data

    def extract_repair_obligations(self, text: str) -> Dict[str, Any]:
        """Extract repair and maintenance obligations."""
        data = {}

        # Tenant repairs
        match = re.search(self.patterns['tenant_repairs'], text, re.IGNORECASE)
        if match:
            repairs = clean_extracted_text(match.group(0))
            data['tenant_repairs'] = repairs

        # Landlord repairs
        match = re.search(self.patterns['landlord_repairs'], text, re.IGNORECASE)
        if match:
            repairs = clean_extracted_text(match.group(0))
            data['landlord_repairs'] = repairs

        # Decorations
        match = re.search(self.patterns['decorations'], text, re.IGNORECASE)
        if match:
            years = match.group(1)
            data['decorations_required'] = f"Every {years} years internal"

        # Combined repair obligation summary
        if data.get('tenant_repairs') or data.get('landlord_repairs'):
            parts = []
            if data.get('tenant_repairs'):
                parts.append(f"Tenant: {data['tenant_repairs']}")
            if data.get('landlord_repairs'):
                parts.append(f"Landlord: {data['landlord_repairs']}")
            data['repair_obligation'] = '; '.join(parts)

        return data

    def extract_use_restrictions(self, text: str) -> Dict[str, Any]:
        """Extract use and restriction clauses."""
        data = {}
        clauses = []

        # Use clause
        match = re.search(self.patterns['use_clause'], text, re.IGNORECASE)
        if match:
            use_text = clean_extracted_text(match.group(0))
            data['use_clause'] = use_text
            clauses.append({
                'type': 'Use',
                'text': use_text,
                'allows_with_consent': False
            })

        # Pets
        match = re.search(self.patterns['pets'], text, re.IGNORECASE)
        if match:
            pets_text = clean_extracted_text(match.group(0))
            data['pets_clause'] = pets_text
            clauses.append({
                'type': 'Pets',
                'text': pets_text,
                'allows_with_consent': determine_consent_required(pets_text)
            })

        # Flooring
        match = re.search(self.patterns['flooring'], text, re.IGNORECASE)
        if match:
            flooring_text = clean_extracted_text(match.group(0))
            data['flooring_clause'] = flooring_text
            clauses.append({
                'type': 'Flooring',
                'text': flooring_text,
                'allows_with_consent': determine_consent_required(flooring_text)
            })

        # Subletting
        match = re.search(self.patterns['subletting'], text, re.IGNORECASE)
        if match:
            subletting_text = clean_extracted_text(match.group(0))
            data['subletting_clause'] = subletting_text
            clauses.append({
                'type': 'Subletting',
                'text': subletting_text,
                'allows_with_consent': determine_consent_required(subletting_text)
            })

        # Alterations
        match = re.search(self.patterns['alterations'], text, re.IGNORECASE)
        if match:
            alterations_text = clean_extracted_text(match.group(0))
            data['alterations_clause'] = alterations_text
            clauses.append({
                'type': 'Alterations',
                'text': alterations_text,
                'allows_with_consent': determine_consent_required(alterations_text)
            })

        # Business use
        match = re.search(self.patterns['business_use'], text, re.IGNORECASE)
        if match:
            business_text = clean_extracted_text(match.group(0))
            data['business_use_clause'] = business_text
            clauses.append({
                'type': 'Business Use',
                'text': business_text,
                'allows_with_consent': False
            })

        # Nuisance
        match = re.search(self.patterns['nuisance'], text, re.IGNORECASE)
        if match:
            nuisance_text = clean_extracted_text(match.group(0))
            data['nuisance_clause'] = nuisance_text
            clauses.append({
                'type': 'Nuisance',
                'text': nuisance_text,
                'allows_with_consent': False
            })

        data['clauses'] = clauses
        return data

    def extract_insurance_enforcement(self, text: str) -> Dict[str, Any]:
        """Extract insurance and enforcement clauses."""
        data = {}

        # Insurance by landlord
        if re.search(r'(?i)To\s+insure\s+the\s+building', text):
            data['insured_by'] = 'Landlord'

        # Reinstatement basis
        if re.search(self.patterns['insurance_reinstatement'], text, re.IGNORECASE):
            data['reinstatement_basis'] = 'Full value'

        # Insurance excess
        match = re.search(self.patterns['insurance_excess'], text, re.IGNORECASE)
        if match:
            excess = extract_amount(match.group(0))
            if excess:
                data['insurance_excess'] = excess

        # Forfeiture clause
        match = re.search(r'(?i)If\s+the\s+rent\s+is\s+unpaid\s+for\s+(\d{1,2})\s+days', text)
        if match:
            days = match.group(1)
            data['forfeiture_clause'] = f"{days} days' notice after arrears"

        # Interest on arrears
        match = re.search(self.patterns['interest_arrears'], text, re.IGNORECASE)
        if match:
            interest_text = match.group(1)
            if '%' not in interest_text:
                interest_text += '%'
            data['interest_on_arrears'] = f"{interest_text} above base rate"

        return data

    def extract_miscellaneous(self, text: str) -> Dict[str, Any]:
        """Extract miscellaneous rights and features."""
        data = {}

        # Car space
        match = re.search(self.patterns['car_space'], text, re.IGNORECASE)
        if match:
            data['car_space_included'] = 'Yes'
            data['car_space_details'] = clean_extracted_text(match.group(0))

        # Storage
        match = re.search(self.patterns['storage'], text, re.IGNORECASE)
        if match:
            data['storage_included'] = 'Yes'
            data['storage_details'] = clean_extracted_text(match.group(0))

        # Garden/balcony
        match = re.search(self.patterns['garden_balcony'], text, re.IGNORECASE)
        if match:
            data['garden_or_balcony_rights'] = clean_extracted_text(match.group(0))

        # Alienation
        match = re.search(self.patterns['alienation'], text, re.IGNORECASE)
        if match:
            data['alienation_clause'] = clean_extracted_text(match.group(0))

        return data

    def calculate_confidence(self, data: Dict) -> float:
        """
        Calculate confidence score based on extracted signals.

        Scoring:
        +0.3 Dates & term found
        +0.2 Ground rent or service charge found
        +0.2 Landlord/tenant names extracted
        +0.2 At least 3 covenants parsed
        +0.1 Variation/deed detected
        """
        score = 0.0

        # Dates and term
        if data.get('lease_term_start') and data.get('lease_term_years'):
            score += 0.3

        # Financial terms
        if data.get('ground_rent_amount') or data.get('service_charge_basis'):
            score += 0.2

        # Parties
        if data.get('landlord_name') and data.get('tenant_name'):
            score += 0.2

        # Covenants (count clauses)
        clause_count = len(data.get('clauses', []))
        if clause_count >= 3:
            score += 0.2
        elif clause_count >= 1:
            score += 0.1

        # Document type detection
        if data.get('lease_type'):
            score += 0.1

        return min(score, 1.0)

    def extract_from_documents(self, documents: List[Dict]) -> Dict[str, Any]:
        """
        Main extraction method - processes multiple lease-related documents.

        Args:
            documents: List of document dicts with 'text' and 'file_path' keys

        Returns:
            Complete lease analysis with all extracted data
        """
        # Merge all lease-related text
        combined_text = ""
        source_files = []

        for doc in documents:
            if doc.get('text'):
                combined_text += "\n\n" + doc['text']
                source_files.append(doc.get('file_path', doc.get('file_name', 'unknown')))

        # Extract all components
        data = {}

        # Metadata
        metadata = self.extract_lease_metadata(combined_text)
        data.update(metadata)

        # Ground rent
        ground_rent = self.extract_ground_rent(combined_text)
        data.update(ground_rent)

        # Service charge
        service_charge = self.extract_service_charge(combined_text)
        data.update(service_charge)

        # Repairs
        repairs = self.extract_repair_obligations(combined_text)
        data.update(repairs)

        # Use restrictions
        restrictions = self.extract_use_restrictions(combined_text)
        data.update(restrictions)

        # Insurance and enforcement
        insurance = self.extract_insurance_enforcement(combined_text)
        data.update(insurance)

        # Miscellaneous
        misc = self.extract_miscellaneous(combined_text)
        data.update(misc)

        # Add metadata
        data['source_files'] = source_files
        data['confidence'] = self.calculate_confidence(data)

        return data


# ============================================================================
# CONVENIENCE FUNCTION
# ============================================================================

def extract_lease_data(documents: List[Dict]) -> Dict[str, Any]:
    """
    Main entry point for lease extraction.

    Args:
        documents: List of document dicts with 'text' and metadata

    Returns:
        Structured JSON with lease data and covenants
    """
    analyzer = LeaseAnalyzer()
    return analyzer.extract_from_documents(documents)


# ============================================================================
# CLI & TESTING
# ============================================================================

if __name__ == "__main__":
    # Sample lease text for testing
    sample_lease_text = """
    THIS LEASE is dated 25 March 1996

    BETWEEN:

    (1) CONNAUGHT ESTATES LTD (Company No. 12345678) whose registered office is at
        50 Kensington Gardens Square, London W2 4BG ("the Landlord")

    (2) JOHN SMITH of 42 High Street, Oxford OX1 1AB ("the Tenant")

    DEMISED PREMISES: Flat 4, 50 Kensington Gardens Square, London W2 4BG

    TERM: 125 years from and including 25 March 1996

    TITLE NUMBER: NGL123456

    GROUND RENT: £250.00 per annum payable to the Freeholder, such rent to double
    every 25 years on the anniversary of the commencement date.

    SERVICE CHARGE: The Tenant shall pay a service charge equal to 12.45% of the
    total expenditure incurred by the Landlord in maintaining and repairing the
    building, excluding insurance and sinking fund contributions.

    TENANT'S COVENANTS:

    To keep and maintain the internal parts of the Demised Premises including all
    plaster, paint and decorations in good repair.

    To decorate the interior every 5 years with appropriate materials.

    To use the Demised Premises as a private residential dwelling only and for no
    other purpose.

    Not to keep any pets or animals without the prior written consent of the Landlord.

    Not to lay any timber, wooden or laminate flooring without the prior written
    consent of the Landlord, such consent not to be unreasonably withheld.

    Not to underlet the whole or any part of the Demised Premises save that the
    Tenant may underlet the whole (but not part) of the premises with the Landlord's
    prior written consent.

    Not to carry on any trade, business or profession from the Demised Premises.

    Not to cause any nuisance, noise or annoyance to neighbouring occupiers.

    LANDLORD'S COVENANTS:

    To keep in repair and properly maintain the structure, roof, foundations and
    external parts of the building and all common parts.

    To insure the building for its full reinstatement value.

    FORFEITURE:

    If the rent is unpaid for 14 days after becoming due, the Landlord may re-enter
    the premises. Interest shall accrue on arrears at 4% above the Bank of England
    base rate.

    PARKING: One allocated parking space (Space 4) is included with the Demised Premises.

    STORAGE: Basement Store 3 is allocated to the Tenant.

    IN WITNESS WHEREOF the parties have executed this Lease as a Deed.
    """

    # Create test document
    test_docs = [
        {
            'text': sample_lease_text,
            'file_path': 'Lease_Flat_4_1996.pdf'
        }
    ]

    # Run extraction
    result = extract_lease_data(test_docs)

    # Pretty print
    print("\n" + "="*60)
    print("LEASE ANALYSIS RESULTS")
    print("="*60)

    # Lease Identity
    print("\n📋 LEASE IDENTITY:")
    print(f"  Type: {result.get('lease_type', 'N/A')}")
    print(f"  Term: {result.get('lease_term_years', 'N/A')} years")
    print(f"  Start: {result.get('lease_term_start', 'N/A')}")
    print(f"  End: {result.get('lease_term_end', 'N/A')}")
    print(f"  Title: {result.get('title_number', 'N/A')}")
    print(f"  Landlord: {result.get('landlord_name', 'N/A')}")
    print(f"  Tenant: {result.get('tenant_name', 'N/A')}")
    print(f"  Premises: {result.get('demised_premises', 'N/A')}")

    # Financial
    print("\n💰 FINANCIAL:")
    print(f"  Ground Rent: £{result.get('ground_rent_amount', 'N/A')}")
    print(f"  Review Pattern: {result.get('ground_rent_review_pattern', 'N/A')}")
    print(f"  Service Charge: {result.get('service_charge_basis', 'N/A')}")
    if result.get('service_charge_percentage'):
        print(f"  SC Percentage: {result.get('service_charge_percentage')}%")

    # Repairs
    print("\n🔧 REPAIRS:")
    print(f"  {result.get('repair_obligation', 'N/A')}")
    if result.get('decorations_required'):
        print(f"  Decorations: {result.get('decorations_required')}")

    # Covenants & Restrictions
    print("\n📜 COVENANTS & RESTRICTIONS:")
    for clause in result.get('clauses', []):
        consent = "✅ (with consent)" if clause.get('allows_with_consent') else "❌"
        print(f"  {clause['type']}: {clause['text'][:60]}... {consent}")

    # Insurance & Enforcement
    print("\n🛡️ INSURANCE & ENFORCEMENT:")
    print(f"  Insured By: {result.get('insured_by', 'N/A')}")
    print(f"  Forfeiture: {result.get('forfeiture_clause', 'N/A')}")
    print(f"  Interest: {result.get('interest_on_arrears', 'N/A')}")

    # Miscellaneous
    print("\n🏠 ADDITIONAL RIGHTS:")
    if result.get('car_space_included'):
        print(f"  Parking: {result.get('car_space_details', 'Included')}")
    if result.get('storage_included'):
        print(f"  Storage: {result.get('storage_details', 'Included')}")

    # Confidence
    print(f"\n✨ Confidence Score: {result.get('confidence', 0):.2f}")
    print(f"📁 Source Files: {', '.join(result.get('source_files', []))}")

    # Save JSON
    output_path = Path(__file__).parent / "output" / "lease_analysis.json"
    output_path.parent.mkdir(exist_ok=True)

    with open(output_path, 'w') as f:
        json.dump(result, f, indent=2)

    print(f"\n✅ Lease analysis saved to: {output_path}")
    print("="*60 + "\n")
