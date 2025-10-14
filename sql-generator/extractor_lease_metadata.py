#!/usr/bin/env python3
"""
Maximum Lease Data Extraction for Database Population
=====================================================
Extracts EVERY data point that can be structurally useful to a property management
database from lease and related legal documents.

Mission: "If it's written in the lease, it belongs in our database."

Outputs comprehensive structured data for multiple database tables:
- leases (core metadata)
- lease_repair_obligations (component-level)
- lease_restrictions (one per restriction)
- lease_rights (one per right/easement)
- lease_linked_documents (variations, licences)
- lease_parties (landlord, tenant, guarantor)

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
# COMPREHENSIVE REGEX PATTERNS
# ============================================================================

COMPREHENSIVE_PATTERNS = {
    # Core Lease Metadata
    'lease_date': r'(?i)(?:THIS\s+LEASE|lease)\s+(?:is\s+)?(?:dated|made)\s+(?:the\s+)?(\d{1,2}(?:st|nd|rd|th)?\s+\w+\s+\d{4})',
    'execution_type': r'(?i)(DEED|deed\s+of\s+variation|licence\s+to\s+alter|licence\s+to\s+underlet|transfer|assignment)',
    'lease_term': r'(?i)(?:TERM|term\s+of|for\s+a\s+term\s+of)[:\-]?\s*(\d{1,3})\s*(?:years|yrs)',
    'lease_start': r'(?i)(?:from\s+and\s+including|commencing|from)\s+(?:the\s+)?(\d{1,2}(?:st|nd|rd|th)?\s+\w+\s+\d{4})',
    'lease_end': r'(?i)(?:expiring|to|until|ending)\s+(?:on\s+)?(?:the\s+)?(\d{1,2}(?:st|nd|rd|th)?\s+\w+\s+\d{4})',

    # Parties & Execution
    'landlord_detailed': r'(?i)\(1\)\s+([A-Z][A-Z\s&\.]+(?:LTD|LIMITED|LLP|PLC)?)\s*(?:\(Company\s+No\.?\s*(\d{8})\))?',
    'tenant_detailed': r'(?i)\(2\)\s+([A-Z][A-Z\s]+)\s+of\s+([\d\w\s,]+[A-Z]{1,2}\d{1,2}\s?\d?[A-Z]{2})',
    'superior_landlord': r'(?i)(?:The\s+)?(?:superior\s+landlord|headlessor|freeholder)\s+is\s+([A-Z][A-Z\s&\.]+)',
    'witness': r'(?i)(?:Witness|witness)[:\-]?\s*([A-Z][A-Za-z\s]+),\s*[\d\w\s]+',
    'guarantor': r'(?i)(?:guarantor|surety)[:\-]?\s*([A-Z][A-Za-z\s&\.]+)',

    # Term & Demise (Enhanced)
    'title_number': r'(?i)(?:TITLE\s+NUMBER|title\s+number|Land\s+Registry\s+Title)[:\-]?\s*([A-Z]{2,3}\d{5,7})',
    'demised_premises': r'(?i)(?:DEMISED\s+PREMISES|demised\s+premises|THE\s+PROPERTY)[:\-]?\s*([A-Za-z0-9][A-Za-z0-9\s,\.\-]+?)(?:\s*$|\n|TERM)',
    'demised_parts': r'(?i)(?:together\s+with|including)[:\-]?\s*([\w\s,]+)(?:as\s+shown|more\s+particularly)',
    'plan_reference': r'(?i)(?:edged\s+red|shown\s+on)\s+(?:plan\s+)?([A-Z]\d?)',
    'lease_type': r'(?i)(underlease|under-lease|headlease|head\s+lease|long\s+leasehold)',

    # Financial Terms (Enhanced)
    'ground_rent_amount': r'(?i)(?:GROUND\s+RENT|ground\s+rent)[:\-]?\s*£?\s*([\d,]+(?:\.\d{2})?)\s*(?:per\s+annum|p\.?a\.?)?',
    'ground_rent_frequency': r'(?i)(?:payable\s+)?(?:annually|yearly|half[- ]yearly|quarterly|monthly)',
    'ground_rent_review': r'(?i)(?:review(?:ed)?|increase(?:d)?|revised?)\s+(?:every|each)\s+(\d{1,2})\s+(?:years|yrs)',
    'ground_rent_pattern': r'(?i)(double(?:s|ing)?|rpi|r\.p\.i\.|cpi|c\.p\.i\.|index[- ]linked|retail\s+price\s+index)',
    'ground_rent_payable_to': r'(?i)(?:payable\s+to|paid\s+to)\s+(?:the\s+)?(freeholder|landlord|superior\s+landlord|headlessor)',
    'ground_rent_payment_dates': r'(?i)(?:payable\s+on|due\s+on)\s+(\d{1,2}(?:st|nd|rd|th)?\s+\w+)',

    # Service Charge (Enhanced)
    'service_charge_percentage': r'(?i)service\s+charge.*?(\d{1,3}(?:\.\d{2})?)%',
    'service_charge_fixed': r'(?i)(?:fixed|specified)\s+(?:service\s+charge|sum)\s+of\s+£?\s*([\d,]+(?:\.\d{2})?)',
    'service_charge_frequency': r'(?i)service\s+charge.*?(?:payable\s+)?(annually|yearly|half[- ]yearly|quarterly|monthly)',
    'service_charge_basis': r'(?i)(variable|fair\s+proportion|reasonable\s+proportion|fixed\s+percentage)',
    'service_charge_exclusions': r'(?i)(?:excluding|save\s+for|does\s+not\s+include)\s+([^\.]+)',
    'service_charge_on_account': r'(?i)(on\s+account|estimated|interim)',

    # Insurance (Enhanced)
    'insurance_responsibility': r'(?i)(?:landlord|lessor)\s+(?:shall|must|to)\s+(?:insure|effect\s+insurance|maintain\s+insurance)',
    'insurance_reinstatement': r'(?i)(?:full\s+(?:reinstatement\s+)?value|replacement\s+value|rebuild\s+value)',
    'insurance_types': r'(?i)(?:fire|flood|storm|impact|subsidence|terrorism|employer)',
    'insurance_excess': r'(?i)(?:excess|deductible)\s*[:\-]?\s*£?\s*([\d,]+)',
    'insurance_contribution': r'(?i)(?:insurance\s+premium|insurance\s+contribution).*?£?\s*([\d,]+)',

    # Repair & Maintenance (Component-level)
    'tenant_internal': r'(?i)tenant.*?(?:repair|maintain|keep).*?(internal|inside|plaster|paint|decoration|floor(?:ing)?|ceiling|door|window)',
    'landlord_structure': r'(?i)landlord.*?(?:repair|maintain|keep).*?(structure|roof|foundation|external|main\s+walls?|common\s+parts)',
    'landlord_services': r'(?i)landlord.*?(?:repair|maintain|keep).*?(pipes?|drains?|sewers?|cables?|wires?|conduits?)',
    'decorations_frequency': r'(?i)(?:decorate|paint|redecorate).*?(?:every|at\s+least\s+every)\s+(\d{1,2})\s+(?:years|yrs)',
    'decorations_specification': r'(?i)(?:decorate|paint).*?(?:with|using)\s+([^\.]+)',

    # Rights & Easements
    'right_of_way': r'(?i)(right\s+of\s+way|access).*?(?:over|to|across)\s+([^\.]+)',
    'right_of_support': r'(?i)(right\s+of\s+support|shelter)',
    'right_of_use': r'(?i)(?:right\s+to\s+use|use\s+of)\s+(?:the\s+)?(garden|balcony|terrace|car\s+park|parking|store|bin|gym|pool|roof)',
    'reserved_rights': r'(?i)(?:landlord\s+reserves?|reserved\s+to\s+the\s+landlord).*?(right\s+to\s+[^\.]+)',

    # Restrictions & Covenants (Enhanced)
    'pets_restriction': r'(?i)(?:Not\s+to|shall\s+not)\s+keep\s+any\s+(?:pets|animals|dogs|cats|birds)[^\.]+\.',
    'flooring_restriction': r'(?i)(?:Not\s+to|shall\s+not)\s+lay\s+any\s+(?:timber|wooden|laminate|hard)[^\.]+\.',
    'subletting_restriction': r'(?i)(?:Not\s+to|shall\s+not)\s+(?:underlet|sublet|sub-let)[^\.]+\.',
    'alterations_restriction': r'(?i)(?:Not\s+to|shall\s+not).*?(?:alter|alteration|improvement|structural)[^\.]+\.',
    'business_restriction': r'(?i)(?:Not\s+to|shall\s+not)\s+(?:carry\s+on|use.*?for)\s+any\s+(?:trade|business|profession)[^\.]+\.',
    'nuisance_restriction': r'(?i)(?:Not\s+to|shall\s+not)\s+(?:cause|permit)\s+any\s+(?:nuisance|noise|annoyance|disturbance)[^\.]+\.',
    'signs_restriction': r'(?i)(?:Not\s+to|shall\s+not).*?(?:sign|advertisement|board|notice)[^\.]+\.',
    'parking_restriction': r'(?i)(?:Not\s+to|shall\s+not).*?(?:park|parking|vehicle)[^\.]+\.',

    # Enforcement & Default (Enhanced)
    'forfeiture_notice': r'(?i)(?:forfeit(?:ure)?|re-?enter).*?(\d{1,2})\s+(?:days?|clear\s+days?).*?notice',
    'forfeiture_conditions': r'(?i)(?:forfeit(?:ure)?|re-?enter).*?(?:if|where|when)\s+([^\.]+)',
    'interest_rate': r'(?i)(?:interest).*?(?:at|of)\s+(\d{1,2}(?:\.\d+)?)%',
    'interest_base': r'(?i)(?:interest).*?(\d{1,2}(?:\.\d+)?)%?\s+(?:above|over|plus)\s+(?:base\s+rate|Bank\s+of\s+England)',
    'breach_remedies': r'(?i)(?:breach|default).*?(?:landlord\s+may|entitled\s+to)\s+([^\.]+)',

    # Legal Metadata
    'plan_attached': r'(?i)(?:plan\s+annexed|attached\s+plan|edged\s+red)',
    'prescribed_clauses': r'(?i)(?:prescribed\s+clauses|LR\s+clauses)',

    # Ancillary Documents
    'deed_of_variation': r'(?i)(deed\s+of\s+variation|supplemental\s+deed).*?(?:dated|made)\s+(\d{1,2}\s+\w+\s+\d{4})',
    'licence_to_alter': r'(?i)(licence\s+to\s+alter).*?(?:dated|granted)\s+(\d{1,2}\s+\w+\s+\d{4})',
    'licence_to_underlet': r'(?i)(licence\s+to\s+(?:under)?let).*?(?:dated|granted)\s+(\d{1,2}\s+\w+\s+\d{4})',
}


# ============================================================================
# HELPER FUNCTIONS
# ============================================================================

def clean_text(text: str) -> str:
    """Clean extracted text."""
    if not text:
        return ""
    text = re.sub(r'\s+', ' ', text).strip()
    text = re.sub(r'[_\*]{3,}', '', text)
    return text


def parse_date(date_str: str) -> Optional[str]:
    """Parse date to ISO format."""
    if not date_str:
        return None
    try:
        date_str = re.sub(r'(\d+)(?:st|nd|rd|th)', r'\1', date_str)
        dt = date_parser.parse(date_str, dayfirst=True)
        return dt.strftime('%Y-%m-%d')
    except:
        return None


def extract_amount(text: str) -> Optional[float]:
    """Extract monetary amount."""
    pattern = r'£?\s*([\d,]+(?:\.\d{2})?)'
    match = re.search(pattern, text)
    if match:
        try:
            return float(match.group(1).replace(',', ''))
        except:
            pass
    return None


def detect_consent_allowed(text: str) -> bool:
    """Check if restriction allows with consent."""
    consent_phrases = [
        'with consent', 'with prior consent', 'with written consent',
        'subject to consent', 'not to be unreasonably withheld',
        'landlord\'s consent', 'save that', 'provided that'
    ]
    return any(phrase in text.lower() for phrase in consent_phrases)


# ============================================================================
# COMPREHENSIVE LEASE EXTRACTOR CLASS
# ============================================================================

class ComprehensiveLeaseExtractor:
    """Extracts maximum data from lease documents for database population."""

    def __init__(self):
        self.patterns = COMPREHENSIVE_PATTERNS

    def extract_execution_metadata(self, text: str) -> Dict[str, Any]:
        """Extract execution type, dates, and signatories."""
        data = {}

        # Execution type
        match = re.search(self.patterns['execution_type'], text, re.IGNORECASE)
        if match:
            data['execution_type'] = match.group(1).upper()

        # Lease date
        match = re.search(self.patterns['lease_date'], text, re.IGNORECASE)
        if match:
            data['lease_date'] = parse_date(match.group(1))
            data['execution_date'] = data['lease_date']

        # Witnesses
        witnesses = []
        for match in re.finditer(self.patterns['witness'], text, re.IGNORECASE):
            witness_name = clean_text(match.group(1))
            if witness_name and len(witness_name) > 2:
                witnesses.append(witness_name)
        if witnesses:
            data['witnesses'] = witnesses[:2]  # Usually 2 witnesses

        return data

    def extract_parties(self, text: str) -> Dict[str, Any]:
        """Extract all parties with details."""
        parties = []

        # Landlord
        match = re.search(self.patterns['landlord_detailed'], text, re.IGNORECASE)
        if match:
            landlord = {
                'role': 'Landlord',
                'name': clean_text(match.group(1)),
                'company_number': match.group(2) if len(match.groups()) > 1 else None
            }
            parties.append(landlord)

        # Tenant
        match = re.search(self.patterns['tenant_detailed'], text, re.IGNORECASE)
        if match:
            tenant = {
                'role': 'Tenant',
                'name': clean_text(match.group(1)),
                'address': clean_text(match.group(2)) if len(match.groups()) > 1 else None
            }
            parties.append(tenant)

        # Superior landlord
        match = re.search(self.patterns['superior_landlord'], text, re.IGNORECASE)
        if match:
            parties.append({
                'role': 'Superior Landlord',
                'name': clean_text(match.group(1))
            })

        # Guarantor
        match = re.search(self.patterns['guarantor'], text, re.IGNORECASE)
        if match:
            parties.append({
                'role': 'Guarantor',
                'name': clean_text(match.group(1))
            })

        return {'parties': parties}

    def extract_term_and_demise(self, text: str) -> Dict[str, Any]:
        """Extract lease term and demised premises details."""
        data = {}

        # Lease type
        match = re.search(self.patterns['lease_type'], text, re.IGNORECASE)
        if match:
            data['lease_type'] = match.group(1).title()

        # Term years
        match = re.search(self.patterns['lease_term'], text, re.IGNORECASE)
        if match:
            data['lease_term_years'] = int(match.group(1))

        # Start date
        match = re.search(self.patterns['lease_start'], text, re.IGNORECASE)
        if match:
            data['lease_term_start'] = parse_date(match.group(1))

        # End date or calculate
        match = re.search(self.patterns['lease_end'], text, re.IGNORECASE)
        if match:
            data['lease_term_end'] = parse_date(match.group(1))
        elif data.get('lease_term_start') and data.get('lease_term_years'):
            start = datetime.strptime(data['lease_term_start'], '%Y-%m-%d')
            end = start + timedelta(days=data['lease_term_years'] * 365)
            data['lease_term_end'] = end.strftime('%Y-%m-%d')

        # Title number
        match = re.search(self.patterns['title_number'], text, re.IGNORECASE)
        if match:
            data['title_number'] = match.group(1).upper()

        # Demised premises
        match = re.search(self.patterns['demised_premises'], text, re.IGNORECASE)
        if match:
            data['demised_premises'] = clean_text(match.group(1))

        # Demised parts
        demised_parts = []
        for match in re.finditer(self.patterns['demised_parts'], text, re.IGNORECASE):
            parts = clean_text(match.group(1))
            if parts:
                demised_parts.append(parts)
        if demised_parts:
            data['demised_parts'] = demised_parts

        # Plan reference
        match = re.search(self.patterns['plan_reference'], text, re.IGNORECASE)
        if match:
            data['plan_reference'] = clean_text(match.group(1))

        return data

    def extract_financial_terms(self, text: str) -> Dict[str, Any]:
        """Extract comprehensive financial terms."""
        data = {}

        # Ground rent amount
        match = re.search(self.patterns['ground_rent_amount'], text, re.IGNORECASE)
        if match:
            data['ground_rent_amount'] = extract_amount(match.group(0))

        # Ground rent frequency
        match = re.search(self.patterns['ground_rent_frequency'], text, re.IGNORECASE)
        if match:
            data['ground_rent_frequency'] = match.group(0).title()

        # Ground rent review interval
        match = re.search(self.patterns['ground_rent_review'], text, re.IGNORECASE)
        if match:
            data['ground_rent_review_interval_years'] = int(match.group(1))

        # Ground rent review pattern
        match = re.search(self.patterns['ground_rent_pattern'], text, re.IGNORECASE)
        if match:
            pattern = match.group(1).lower()
            if 'double' in pattern:
                years = data.get('ground_rent_review_interval_years', '')
                data['ground_rent_review_basis'] = f"Doubles every {years} years" if years else "Doubles"
            elif 'rpi' in pattern:
                data['ground_rent_review_basis'] = "RPI-linked"
            elif 'cpi' in pattern:
                data['ground_rent_review_basis'] = "CPI-linked"

        # Ground rent payable to
        match = re.search(self.patterns['ground_rent_payable_to'], text, re.IGNORECASE)
        if match:
            data['ground_rent_payable_to'] = match.group(1).title()

        # Ground rent payment dates
        match = re.search(self.patterns['ground_rent_payment_dates'], text, re.IGNORECASE)
        if match:
            data['ground_rent_payment_dates'] = match.group(1)

        # Service charge percentage
        match = re.search(self.patterns['service_charge_percentage'], text, re.IGNORECASE)
        if match:
            data['service_charge_percentage'] = float(match.group(1))
            data['service_charge_basis'] = 'Percentage'

        # Service charge fixed
        match = re.search(self.patterns['service_charge_fixed'], text, re.IGNORECASE)
        if match:
            data['service_charge_fixed_amount'] = extract_amount(match.group(0))
            data['service_charge_basis'] = 'Fixed'

        # Service charge frequency
        match = re.search(self.patterns['service_charge_frequency'], text, re.IGNORECASE)
        if match:
            data['service_charge_frequency'] = match.group(1).title()

        # Service charge basis (variable)
        if re.search(self.patterns['service_charge_basis'], text, re.IGNORECASE):
            if 'service_charge_basis' not in data:
                data['service_charge_basis'] = 'Variable'

        # Service charge exclusions
        match = re.search(self.patterns['service_charge_exclusions'], text, re.IGNORECASE)
        if match:
            data['service_charge_exclusions'] = clean_text(match.group(1))

        # Service charge on account
        if re.search(self.patterns['service_charge_on_account'], text, re.IGNORECASE):
            data['service_charge_on_account'] = True

        # Insurance contribution
        match = re.search(self.patterns['insurance_contribution'], text, re.IGNORECASE)
        if match:
            data['insurance_contribution'] = extract_amount(match.group(0))

        return data

    def extract_repair_obligations(self, text: str) -> Dict[str, List[Dict]]:
        """Extract component-level repair obligations."""
        obligations = []

        # Tenant internal repairs
        for match in re.finditer(self.patterns['tenant_internal'], text, re.IGNORECASE):
            component_match = re.search(r'(internal|plaster|paint|decoration|floor|ceiling|door|window)',
                                       match.group(0), re.IGNORECASE)
            if component_match:
                obligations.append({
                    'responsible_party': 'Tenant',
                    'component': component_match.group(1).title(),
                    'obligation': 'Repair and maintain',
                    'full_text': clean_text(match.group(0)[:100])
                })

        # Landlord structure repairs
        for match in re.finditer(self.patterns['landlord_structure'], text, re.IGNORECASE):
            component_match = re.search(r'(structure|roof|foundation|external|walls?|common\s+parts)',
                                       match.group(0), re.IGNORECASE)
            if component_match:
                obligations.append({
                    'responsible_party': 'Landlord',
                    'component': component_match.group(1).title(),
                    'obligation': 'Repair and maintain',
                    'full_text': clean_text(match.group(0)[:100])
                })

        # Landlord services
        for match in re.finditer(self.patterns['landlord_services'], text, re.IGNORECASE):
            component_match = re.search(r'(pipes?|drains?|sewers?|cables?|wires?|conduits?)',
                                       match.group(0), re.IGNORECASE)
            if component_match:
                obligations.append({
                    'responsible_party': 'Landlord',
                    'component': component_match.group(1).title(),
                    'obligation': 'Repair and maintain',
                    'full_text': clean_text(match.group(0)[:100])
                })

        # Decorations
        match = re.search(self.patterns['decorations_frequency'], text, re.IGNORECASE)
        if match:
            years = match.group(1)
            obligations.append({
                'responsible_party': 'Tenant',
                'component': 'Decorations',
                'obligation': f'Redecorate every {years} years',
                'frequency_years': int(years)
            })

        return {'repair_obligations': obligations}

    def extract_rights_and_easements(self, text: str) -> Dict[str, List[Dict]]:
        """Extract all rights and easements."""
        rights = []

        # Right of way
        for match in re.finditer(self.patterns['right_of_way'], text, re.IGNORECASE):
            rights.append({
                'right_type': 'Access',
                'description': clean_text(match.group(0)),
                'granted_to': 'Tenant'
            })

        # Right of support
        if re.search(self.patterns['right_of_support'], text, re.IGNORECASE):
            rights.append({
                'right_type': 'Support',
                'description': 'Right of support and shelter',
                'granted_to': 'Tenant'
            })

        # Right of use (facilities)
        for match in re.finditer(self.patterns['right_of_use'], text, re.IGNORECASE):
            facility_match = re.search(r'(garden|balcony|terrace|car\s+park|parking|store|bin|gym|pool|roof)',
                                      match.group(0), re.IGNORECASE)
            if facility_match:
                rights.append({
                    'right_type': 'Use of Facility',
                    'facility': facility_match.group(1).title(),
                    'description': clean_text(match.group(0)),
                    'granted_to': 'Tenant'
                })

        # Reserved rights (to landlord)
        for match in re.finditer(self.patterns['reserved_rights'], text, re.IGNORECASE):
            rights.append({
                'right_type': 'Reserved Right',
                'description': clean_text(match.group(1)),
                'granted_to': 'Landlord'
            })

        return {'rights_and_easements': rights}

    def extract_restrictions(self, text: str) -> Dict[str, List[Dict]]:
        """Extract all restrictions with consent flags."""
        restrictions = []

        restriction_patterns = [
            ('Pets', 'pets_restriction'),
            ('Flooring', 'flooring_restriction'),
            ('Subletting', 'subletting_restriction'),
            ('Alterations', 'alterations_restriction'),
            ('Business Use', 'business_restriction'),
            ('Nuisance', 'nuisance_restriction'),
            ('Signs/Advertising', 'signs_restriction'),
            ('Parking', 'parking_restriction')
        ]

        for rest_type, pattern_key in restriction_patterns:
            match = re.search(self.patterns[pattern_key], text, re.IGNORECASE)
            if match:
                clause_text = clean_text(match.group(0))
                restrictions.append({
                    'restriction_type': rest_type,
                    'clause_text': clause_text,
                    'allows_with_consent': detect_consent_allowed(clause_text),
                    'absolute_prohibition': not detect_consent_allowed(clause_text)
                })

        return {'restrictions': restrictions}

    def extract_insurance_details(self, text: str) -> Dict[str, Any]:
        """Extract comprehensive insurance details."""
        data = {}

        # Insurance responsibility
        if re.search(self.patterns['insurance_responsibility'], text, re.IGNORECASE):
            data['insurance_responsibility'] = 'Landlord'

        # Reinstatement basis
        if re.search(self.patterns['insurance_reinstatement'], text, re.IGNORECASE):
            data['insurance_reinstatement_basis'] = 'Full reinstatement value'

        # Insurance types covered
        types_covered = []
        for match in re.finditer(self.patterns['insurance_types'], text, re.IGNORECASE):
            types_covered.append(match.group(0).title())
        if types_covered:
            data['insurance_types_covered'] = list(set(types_covered))

        # Insurance excess
        match = re.search(self.patterns['insurance_excess'], text, re.IGNORECASE)
        if match:
            data['insurance_excess'] = extract_amount(match.group(0))

        return data

    def extract_enforcement_terms(self, text: str) -> Dict[str, Any]:
        """Extract enforcement and default terms."""
        data = {}

        # Forfeiture notice period
        match = re.search(self.patterns['forfeiture_notice'], text, re.IGNORECASE)
        if match:
            data['forfeiture_notice_days'] = int(match.group(1))
            data['forfeiture_clause'] = f"{match.group(1)} days' notice required"

        # Forfeiture conditions
        match = re.search(self.patterns['forfeiture_conditions'], text, re.IGNORECASE)
        if match:
            data['forfeiture_conditions'] = clean_text(match.group(1))

        # Interest rate
        match = re.search(self.patterns['interest_rate'], text, re.IGNORECASE)
        if match:
            data['interest_rate_on_arrears'] = f"{match.group(1)}%"

        # Interest above base rate
        match = re.search(self.patterns['interest_base'], text, re.IGNORECASE)
        if match:
            data['interest_rate_on_arrears'] = f"{match.group(1)}% above base rate"

        return data

    def extract_linked_documents(self, text: str) -> Dict[str, List[Dict]]:
        """Extract references to ancillary documents."""
        linked_docs = []

        doc_patterns = [
            ('Deed of Variation', 'deed_of_variation'),
            ('Licence to Alter', 'licence_to_alter'),
            ('Licence to Underlet', 'licence_to_underlet')
        ]

        for doc_type, pattern_key in doc_patterns:
            match = re.search(self.patterns[pattern_key], text, re.IGNORECASE)
            if match:
                linked_docs.append({
                    'document_type': doc_type,
                    'date': parse_date(match.group(2)) if len(match.groups()) > 1 else None
                })

        return {'linked_documents': linked_docs}

    def calculate_confidence(self, data: Dict) -> float:
        """Calculate extraction confidence score."""
        score = 0.0

        # Core metadata
        if data.get('lease_term_start') and data.get('lease_term_years'):
            score += 0.2

        # Parties
        parties = data.get('parties', [])
        if len(parties) >= 2:
            score += 0.2

        # Financial terms
        if data.get('ground_rent_amount') or data.get('service_charge_percentage'):
            score += 0.15

        # Repair obligations
        if data.get('repair_obligations') and len(data['repair_obligations']) >= 2:
            score += 0.15

        # Restrictions
        if data.get('restrictions') and len(data['restrictions']) >= 3:
            score += 0.15

        # Rights
        if data.get('rights_and_easements'):
            score += 0.1

        # Title number
        if data.get('title_number'):
            score += 0.05

        return min(score, 1.0)

    def extract_from_documents(self, documents: List[Dict]) -> Dict[str, Any]:
        """
        Main extraction method - comprehensive lease data extraction.

        Args:
            documents: List of document dicts with 'text' and metadata

        Returns:
            Complete lease metadata for database population
        """
        # Merge all text
        combined_text = ""
        source_files = []

        for doc in documents:
            if doc.get('text'):
                combined_text += "\n\n" + doc['text']
                source_files.append(doc.get('file_path', doc.get('file_name', 'unknown')))

        # Extract all components
        data = {}

        # Core metadata
        exec_data = self.extract_execution_metadata(combined_text)
        data.update(exec_data)

        # Parties
        parties_data = self.extract_parties(combined_text)
        data.update(parties_data)

        # Term and demise
        term_data = self.extract_term_and_demise(combined_text)
        data.update(term_data)

        # Financial
        financial_data = self.extract_financial_terms(combined_text)
        data.update(financial_data)

        # Repairs
        repairs_data = self.extract_repair_obligations(combined_text)
        data.update(repairs_data)

        # Rights
        rights_data = self.extract_rights_and_easements(combined_text)
        data.update(rights_data)

        # Restrictions
        restrictions_data = self.extract_restrictions(combined_text)
        data.update(restrictions_data)

        # Insurance
        insurance_data = self.extract_insurance_details(combined_text)
        data.update(insurance_data)

        # Enforcement
        enforcement_data = self.extract_enforcement_terms(combined_text)
        data.update(enforcement_data)

        # Linked documents
        linked_data = self.extract_linked_documents(combined_text)
        data.update(linked_data)

        # Metadata
        data['source_files'] = source_files
        data['confidence'] = self.calculate_confidence(data)

        return data


# ============================================================================
# CONVENIENCE FUNCTION
# ============================================================================

def extract_full_lease_metadata(documents: List[Dict]) -> Dict[str, Any]:
    """
    Main entry point for comprehensive lease extraction.

    Args:
        documents: List of document dicts with 'text' and metadata

    Returns:
        Complete lease metadata for database population
    """
    extractor = ComprehensiveLeaseExtractor()
    return extractor.extract_from_documents(documents)


# ============================================================================
# CLI & TESTING
# ============================================================================

if __name__ == "__main__":
    # Enhanced sample lease text
    sample_lease_text = """
    THIS LEASE is dated 25 March 1996 and made as a DEED

    BETWEEN:

    (1) CONNAUGHT ESTATES LTD (Company No. 12345678) whose registered office is at
        50 Kensington Gardens Square, London W2 4BG ("the Landlord")

    (2) JOHN SMITH of 42 High Street, Oxford OX1 1AB ("the Tenant")

    (3) MARY SMITH of 42 High Street, Oxford OX1 1AB ("the Guarantor")

    BACKGROUND:
    The Superior Landlord is THE PORTMAN ESTATE

    DEMISED PREMISES: Flat 4, 50 Kensington Gardens Square, London W2 4BG
    together with the balcony and parking space number 4 as shown edged red on Plan A

    TERM: 125 years from and including 25 March 1996

    TITLE NUMBER: NGL123456

    GROUND RENT: £250.00 per annum payable annually in advance on 25 March, such rent
    to double every 25 years on the anniversary of the commencement date.

    SERVICE CHARGE: The Tenant shall pay a service charge equal to 12.45% of the
    total expenditure incurred by the Landlord, payable half-yearly in advance on
    24 March and 29 September, excluding insurance and reserve fund contributions.

    INSURANCE: The Tenant shall contribute to the insurance premium for fire, flood,
    and storm damage in the proportion of 12.45%.

    TENANT'S COVENANTS:

    To keep and maintain the internal parts of the Demised Premises including all
    internal plaster, internal paint and internal decorations in good repair and
    to decorate the interior every 5 years with two coats of good quality paint.

    To use the Demised Premises as a private residential dwelling only.

    Not to keep any pets or animals without the prior written consent of the Landlord.

    Not to lay any timber, wooden or laminate flooring without the prior written
    consent of the Landlord, such consent not to be unreasonably withheld.

    Not to underlet the whole or any part save that the Tenant may underlet the
    whole with the Landlord's consent.

    Not to carry on any trade, business or profession from the Demised Premises.

    Not to cause any nuisance, noise or annoyance to neighbouring occupiers.

    Not to display any signs, advertisements or boards visible from outside.

    LANDLORD'S COVENANTS:

    To keep in repair and properly maintain the structure, roof, foundations,
    external walls and all common parts including entrance halls and staircases.

    To maintain and repair all pipes, drains, sewers, cables and conduits serving
    the building.

    To insure the building for its full reinstatement value against fire, flood,
    storm, impact and subsidence.

    RIGHTS GRANTED:

    Right of way over the entrance hall and staircase
    Right of support from adjoining premises
    Use of the bin storage area and communal garden

    RIGHTS RESERVED TO LANDLORD:

    Right to enter for inspection and repair on 24 hours' notice

    FORFEITURE:

    If the rent is unpaid for 14 days after becoming due, the Landlord may re-enter.
    Interest shall accrue on arrears at 4% above the Bank of England base rate.

    SIGNED as a DEED by the Landlord in the presence of:
    Witness: Sarah Johnson, 10 Park Lane, London

    SIGNED as a DEED by the Tenant in the presence of:
    Witness: Robert Williams, 5 High Street, Oxford

    This Lease was varied by Deed of Variation dated 15 June 2010 regarding
    flooring restrictions.
    """

    # Test documents
    test_docs = [
        {
            'text': sample_lease_text,
            'file_path': 'Lease_Flat_4_Enhanced.pdf'
        }
    ]

    # Run extraction
    result = extract_full_lease_metadata(test_docs)

    # Pretty print results
    print("\n" + "="*70)
    print("COMPREHENSIVE LEASE METADATA EXTRACTION")
    print("="*70)

    print("\n📋 EXECUTION METADATA:")
    print(f"  Type: {result.get('execution_type', 'N/A')}")
    print(f"  Date: {result.get('lease_date', 'N/A')}")
    if result.get('witnesses'):
        print(f"  Witnesses: {', '.join(result['witnesses'])}")

    print("\n👥 PARTIES:")
    for party in result.get('parties', []):
        print(f"  {party['role']}: {party['name']}")
        if party.get('company_number'):
            print(f"    Company No: {party['company_number']}")
        if party.get('address'):
            print(f"    Address: {party['address']}")

    print("\n📍 TERM & DEMISE:")
    print(f"  Type: {result.get('lease_type', 'N/A')}")
    print(f"  Term: {result.get('lease_term_years', 'N/A')} years")
    print(f"  Start: {result.get('lease_term_start', 'N/A')}")
    print(f"  End: {result.get('lease_term_end', 'N/A')}")
    print(f"  Title: {result.get('title_number', 'N/A')}")
    print(f"  Premises: {result.get('demised_premises', 'N/A')}")
    if result.get('demised_parts'):
        print(f"  Parts: {', '.join(result['demised_parts'])}")
    if result.get('plan_reference'):
        print(f"  Plan: {result['plan_reference']}")

    print("\n💰 FINANCIAL TERMS:")
    print(f"  Ground Rent: £{result.get('ground_rent_amount', 'N/A')}")
    print(f"  Frequency: {result.get('ground_rent_frequency', 'N/A')}")
    print(f"  Review: {result.get('ground_rent_review_basis', 'N/A')}")
    print(f"  Payable to: {result.get('ground_rent_payable_to', 'N/A')}")
    print(f"  Service Charge: {result.get('service_charge_percentage', 'N/A')}%")
    print(f"  SC Basis: {result.get('service_charge_basis', 'N/A')}")
    print(f"  SC Frequency: {result.get('service_charge_frequency', 'N/A')}")

    print("\n🔧 REPAIR OBLIGATIONS:")
    for obligation in result.get('repair_obligations', [])[:5]:
        print(f"  {obligation['responsible_party']}: {obligation['component']} - {obligation['obligation']}")

    print("\n✅ RIGHTS & EASEMENTS:")
    for right in result.get('rights_and_easements', [])[:5]:
        print(f"  {right['right_type']}: {right.get('description', right.get('facility', 'N/A'))}")

    print("\n🚫 RESTRICTIONS:")
    for restriction in result.get('restrictions', []):
        consent = "✅ (with consent)" if restriction['allows_with_consent'] else "❌ (absolute)"
        print(f"  {restriction['restriction_type']}: {consent}")

    print("\n🛡️ INSURANCE & ENFORCEMENT:")
    print(f"  Insured by: {result.get('insurance_responsibility', 'N/A')}")
    print(f"  Basis: {result.get('insurance_reinstatement_basis', 'N/A')}")
    print(f"  Forfeiture: {result.get('forfeiture_clause', 'N/A')}")
    print(f"  Interest: {result.get('interest_rate_on_arrears', 'N/A')}")

    if result.get('linked_documents'):
        print("\n📎 LINKED DOCUMENTS:")
        for doc in result['linked_documents']:
            print(f"  {doc['document_type']}: {doc.get('date', 'N/A')}")

    print(f"\n✨ Confidence Score: {result.get('confidence', 0):.2f}")
    print(f"📁 Source Files: {', '.join(result.get('source_files', []))}")

    # Save JSON
    output_path = Path(__file__).parent / "output" / "comprehensive_lease_metadata.json"
    output_path.parent.mkdir(exist_ok=True)

    with open(output_path, 'w') as f:
        json.dump(result, f, indent=2)

    print(f"\n✅ Comprehensive lease metadata saved to: {output_path}")
    print("="*70 + "\n")
