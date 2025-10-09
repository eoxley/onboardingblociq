"""
BlocIQ Comprehensive Lease Data Extractor
Extracts financial terms, insurance, covenants, and restrictions from lease documents
"""

import re
import uuid
from typing import Dict, List, Optional, Tuple
from datetime import datetime
import json


class LeaseDataExtractor:
    """Extract comprehensive lease data from OCR text"""

    def __init__(self, lease_id: str, building_id: str, unit_id: Optional[str], ocr_text: str):
        """
        Initialize extractor

        Args:
            lease_id: UUID of the lease record
            building_id: UUID of the building
            unit_id: UUID of the unit (optional)
            ocr_text: Full OCR extracted text from lease document
        """
        self.lease_id = lease_id
        self.building_id = building_id
        self.unit_id = unit_id
        self.text = ocr_text
        self.text_lower = ocr_text.lower() if ocr_text else ''

    def extract_all(self) -> Dict:
        """
        Extract all lease data components

        Returns:
            Dictionary with financial_terms, insurance_terms, covenants, restrictions
        """
        return {
            'financial_terms': self.extract_financial_terms(),
            'insurance_terms': self.extract_insurance_terms(),
            'covenants': self.extract_covenants(),
            'restrictions': self.extract_restrictions()
        }

    # =========================================
    # FINANCIAL TERMS EXTRACTION
    # =========================================

    def extract_financial_terms(self) -> Dict:
        """Extract all financial terms from lease"""
        financial_terms = {
            'id': str(uuid.uuid4()),
            'lease_id': self.lease_id,
            'building_id': self.building_id,
            'unit_id': self.unit_id
        }

        # Ground rent
        ground_rent, gr_clause = self._extract_ground_rent()
        financial_terms['ground_rent'] = ground_rent
        financial_terms['raw_ground_rent_clause'] = gr_clause
        financial_terms['ground_rent_frequency'] = self._extract_ground_rent_frequency(gr_clause or '')
        financial_terms['ground_rent_due_dates'] = self._extract_payment_dates(gr_clause or '')

        # Service charge
        sc_year_start, sc_year_end, sc_clause = self._extract_service_charge_year()
        financial_terms['service_charge_year_start'] = sc_year_start
        financial_terms['service_charge_year_end'] = sc_year_end
        financial_terms['raw_service_charge_clause'] = sc_clause
        financial_terms['service_charge_frequency'] = self._extract_payment_frequency(sc_clause or '')
        financial_terms['service_charge_advance'] = 'in advance' in (sc_clause or '').lower()

        # Reserve fund
        financial_terms['reserve_fund_provided'] = self._check_reserve_fund()
        financial_terms['reserve_fund_percentage'] = self._extract_reserve_fund_percentage()

        # Interest on arrears
        interest_type, interest_value = self._extract_interest_rate()
        financial_terms['interest_rate_type'] = interest_type
        financial_terms['interest_rate_value'] = interest_value

        # Rent review
        review_freq, review_basis, review_clause = self._extract_rent_review()
        financial_terms['rent_review_frequency_years'] = review_freq
        financial_terms['rent_review_basis'] = review_basis
        financial_terms['raw_review_clause'] = review_clause

        return financial_terms

    def _extract_ground_rent(self) -> Tuple[Optional[float], Optional[str]]:
        """Extract ground rent amount and clause"""
        patterns = [
            r'ground rent[:\s]+(?:of\s+)?[£$]?(\d+(?:,\d{3})*(?:\.\d{2})?)\s*(?:per\s+annum|p\.a\.|yearly)',
            r'[£$](\d+(?:,\d{3})*(?:\.\d{2})?)\s+(?:per\s+annum|p\.a\.)\s+ground rent',
            r'paying\s+[£$](\d+(?:,\d{3})*(?:\.\d{2})?)\s+(?:per\s+annum|yearly)',
        ]

        # Search for full clause (up to 200 chars)
        clause_pattern = r'(?:ground rent|rent)[^.]{10,200}?(?:per annum|yearly|p\.a\.)[^.]{0,100}?\.'
        clause_match = re.search(clause_pattern, self.text_lower, re.IGNORECASE)
        full_clause = clause_match.group(0) if clause_match else None

        # Extract amount
        for pattern in patterns:
            match = re.search(pattern, self.text_lower, re.IGNORECASE)
            if match:
                try:
                    amount_str = match.group(1).replace(',', '')
                    amount = float(amount_str)
                    return amount, full_clause
                except ValueError:
                    continue

        # Check for peppercorn rent
        if 'peppercorn' in self.text_lower or 'nominal rent' in self.text_lower:
            return 0.00, full_clause

        return None, full_clause

    def _extract_ground_rent_frequency(self, clause: str) -> Optional[str]:
        """Determine payment frequency from clause"""
        if not clause:
            return None

        clause_lower = clause.lower()
        if 'quarterly' in clause_lower:
            return 'quarterly'
        elif 'semi-annual' in clause_lower or 'half-yearly' in clause_lower or 'two equal' in clause_lower:
            return 'semi_annual'
        elif 'monthly' in clause_lower:
            return 'monthly'
        elif 'annual' in clause_lower or 'per annum' in clause_lower:
            return 'annual'

        return None

    def _extract_payment_dates(self, clause: str) -> Optional[List[str]]:
        """Extract specific payment due dates"""
        if not clause:
            return None

        # Pattern: "25 March and 29 September", "the usual quarter days"
        date_pattern = r'(\d{1,2}(?:st|nd|rd|th)?\s+(?:January|February|March|April|May|June|July|August|September|October|November|December))'
        matches = re.findall(date_pattern, clause, re.IGNORECASE)

        if matches:
            return matches

        # Check for quarter days
        if 'quarter days' in clause.lower():
            return ["25 March", "24 June", "29 September", "25 December"]

        return None

    def _extract_service_charge_year(self) -> Tuple[Optional[str], Optional[str], Optional[str]]:
        """Extract service charge accounting year"""
        patterns = [
            r'(?:accounting|service charge)\s+year\s+(?:ending|to)\s+(\d{1,2}(?:st|nd|rd|th)?\s+\w+)',
            r'year\s+ending\s+on\s+(?:the\s+)?(\d{1,2}(?:st|nd|rd|th)?\s+\w+)',
            r'(\d{1,2})\s+(January|February|March|April|May|June|July|August|September|October|November|December)\s+to\s+(\d{1,2})\s+(January|February|March|April|May|June|July|August|September|October|November|December)'
        ]

        # Find full clause
        clause_pattern = r'(?:service charge|accounting)[^.]{10,200}?(?:year|annual)[^.]{0,100}?\.'
        clause_match = re.search(clause_pattern, self.text_lower, re.IGNORECASE)
        full_clause = clause_match.group(0) if clause_match else None

        for pattern in patterns:
            match = re.search(pattern, self.text, re.IGNORECASE)
            if match:
                if len(match.groups()) == 1:
                    # Year ending format
                    end_date_str = match.group(1)
                    # Assume year starts day after year end
                    # For now, return as text - SQL generator can parse
                    return None, end_date_str, full_clause
                elif len(match.groups()) == 4:
                    # Full range format
                    start_date = f"{match.group(1)} {match.group(2)}"
                    end_date = f"{match.group(3)} {match.group(4)}"
                    return start_date, end_date, full_clause

        return None, None, full_clause

    def _extract_payment_frequency(self, clause: str) -> Optional[str]:
        """Extract payment frequency (quarterly, monthly, etc.)"""
        if not clause:
            return None

        clause_lower = clause.lower()
        if 'quarterly' in clause_lower:
            return 'quarterly'
        elif 'monthly' in clause_lower:
            return 'monthly'
        elif 'annual' in clause_lower:
            return 'annual'

        return None

    def _check_reserve_fund(self) -> bool:
        """Check if reserve fund is provided"""
        reserve_keywords = ['reserve fund', 'sinking fund', 'reserve account']
        return any(keyword in self.text_lower for keyword in reserve_keywords)

    def _extract_reserve_fund_percentage(self) -> Optional[float]:
        """Extract reserve fund percentage if specified"""
        pattern = r'reserve fund[^.]{0,100}?(\d+(?:\.\d+)?)\s*%'
        match = re.search(pattern, self.text_lower, re.IGNORECASE)
        if match:
            try:
                return float(match.group(1))
            except ValueError:
                pass
        return None

    def _extract_interest_rate(self) -> Tuple[Optional[str], Optional[float]]:
        """Extract interest rate on arrears"""
        patterns = [
            r'interest[^.]{0,100}?(\d+(?:\.\d+)?)\s*%\s*(?:above|over)\s+(?:base rate|bank rate)',
            r'interest[^.]{0,100}?(\d+(?:\.\d+)?)\s*%\s*(?:per annum|p\.a\.)',
        ]

        for pattern in patterns:
            match = re.search(pattern, self.text_lower, re.IGNORECASE)
            if match:
                try:
                    rate = float(match.group(1))
                    # Get full description
                    full_match = match.group(0)
                    return full_match, rate
                except ValueError:
                    continue

        return None, None

    def _extract_rent_review(self) -> Tuple[Optional[int], Optional[str], Optional[str]]:
        """Extract rent review frequency and basis"""
        # Find clause
        clause_pattern = r'(?:rent review|review of|reviewed)[^.]{10,200}?(?:year|rpi|index|market)[^.]{0,100}?\.'
        clause_match = re.search(clause_pattern, self.text_lower, re.IGNORECASE)
        full_clause = clause_match.group(0) if clause_match else None

        # Extract frequency
        freq_pattern = r'(?:every|each)\s+(\d+)\s+year'
        freq_match = re.search(freq_pattern, self.text_lower, re.IGNORECASE)
        frequency = int(freq_match.group(1)) if freq_match else None

        # Determine basis
        basis = None
        if full_clause:
            if 'rpi' in full_clause or 'retail price' in full_clause:
                basis = 'RPI-linked'
            elif 'open market' in full_clause or 'market rent' in full_clause:
                basis = 'Open market'
            elif 'fixed' in full_clause:
                basis = 'Fixed increase'

        return frequency, basis, full_clause

    # =========================================
    # INSURANCE TERMS EXTRACTION
    # =========================================

    def extract_insurance_terms(self) -> Dict:
        """Extract insurance obligations"""
        insurance_terms = {
            'id': str(uuid.uuid4()),
            'lease_id': self.lease_id,
            'building_id': self.building_id,
            'unit_id': self.unit_id
        }

        # Find insurance clause
        clause_pattern = r'(?:insurance|insure)[^.]{10,300}?(?:building|premises|property)[^.]{0,200}?\.'
        clause_match = re.search(clause_pattern, self.text_lower, re.IGNORECASE)
        full_clause = clause_match.group(0) if clause_match else None
        insurance_terms['raw_insurance_clause'] = full_clause

        if not full_clause:
            return insurance_terms

        clause_lower = full_clause.lower()

        # Determine who insures
        landlord_insures = any(phrase in clause_lower for phrase in ['landlord', 'lessor']) and 'insure' in clause_lower
        tenant_insures = any(phrase in clause_lower for phrase in ['tenant', 'lessee']) and 'insure' in clause_lower

        insurance_terms['landlord_insures'] = landlord_insures
        insurance_terms['tenant_insures'] = tenant_insures
        insurance_terms['shared_insurance'] = landlord_insures and tenant_insures

        # Coverage types
        coverage = []
        if 'fire' in clause_lower:
            coverage.append('fire')
        if 'flood' in clause_lower:
            coverage.append('flood')
        if 'public liability' in clause_lower:
            coverage.append('public_liability')
        if 'storm' in clause_lower:
            coverage.append('storm')
        insurance_terms['coverage_types'] = coverage if coverage else None

        # Tenant contribution
        if 'service charge' in clause_lower or 'through the service charge' in clause_lower:
            insurance_terms['tenant_contribution_method'] = 'via service charge'
        elif 'direct' in clause_lower:
            insurance_terms['tenant_contribution_method'] = 'direct payment'

        # Excess
        excess_pattern = r'excess[^.]{0,50}?[£$](\d+(?:,\d{3})*(?:\.\d{2})?)'
        excess_match = re.search(excess_pattern, clause_lower)
        if excess_match:
            try:
                insurance_terms['excess_amount'] = float(excess_match.group(1).replace(',', ''))
            except ValueError:
                pass

        # Contents insurance requirement
        insurance_terms['tenants_contents_insurance_required'] = 'contents insurance' in clause_lower

        return insurance_terms

    # =========================================
    # COVENANTS EXTRACTION
    # =========================================

    def extract_covenants(self) -> List[Dict]:
        """Extract tenant and landlord covenants"""
        covenants = []

        # Repairing covenant
        repair_covenant = self._extract_repair_covenant()
        if repair_covenant:
            covenants.append(repair_covenant)

        # Alteration covenant
        alteration_covenant = self._extract_alteration_covenant()
        if alteration_covenant:
            covenants.append(alteration_covenant)

        # Use covenant
        use_covenant = self._extract_use_covenant()
        if use_covenant:
            covenants.append(use_covenant)

        # Nuisance covenant
        nuisance_covenant = self._extract_nuisance_covenant()
        if nuisance_covenant:
            covenants.append(nuisance_covenant)

        return covenants

    def _extract_repair_covenant(self) -> Optional[Dict]:
        """Extract repairing obligations"""
        pattern = r'(?:lessee|tenant)\s+(?:shall|must|to)[^.]{10,200}?(?:repair|maintain|keep in (?:good )?repair)[^.]{0,100}?\.'
        match = re.search(pattern, self.text_lower, re.IGNORECASE)

        if match:
            full_text = match.group(0)
            return {
                'id': str(uuid.uuid4()),
                'lease_id': self.lease_id,
                'building_id': self.building_id,
                'unit_id': self.unit_id,
                'covenant_type': 'repair',
                'obligated_party': 'tenant',
                'covenant_summary': 'Lessee to keep premises in good repair',
                'covenant_full_text': full_text,
                'is_repairing_covenant': True
            }

        return None

    def _extract_alteration_covenant(self) -> Optional[Dict]:
        """Extract alteration restrictions"""
        pattern = r'(?:not|shall not)[^.]{0,100}?(?:alter|alteration|structural changes?)[^.]{0,100}?(?:without|unless)[^.]{0,50}?(?:consent|permission)[^.]{0,100}?\.'
        match = re.search(pattern, self.text_lower, re.IGNORECASE)

        if match:
            full_text = match.group(0)
            return {
                'id': str(uuid.uuid4()),
                'lease_id': self.lease_id,
                'building_id': self.building_id,
                'unit_id': self.unit_id,
                'covenant_type': 'alterations',
                'obligated_party': 'tenant',
                'covenant_summary': 'No structural changes without consent',
                'covenant_full_text': full_text,
                'is_alteration_restriction': True
            }

        return None

    def _extract_use_covenant(self) -> Optional[Dict]:
        """Extract use restrictions"""
        pattern = r'(?:use|used)[^.]{0,100}?(?:private|residential|dwelling)[^.]{0,100}?\.'
        match = re.search(pattern, self.text_lower, re.IGNORECASE)

        if match:
            full_text = match.group(0)
            return {
                'id': str(uuid.uuid4()),
                'lease_id': self.lease_id,
                'building_id': self.building_id,
                'unit_id': self.unit_id,
                'covenant_type': 'use',
                'obligated_party': 'tenant',
                'covenant_summary': 'Use restricted to private residential',
                'covenant_full_text': full_text,
                'is_use_restriction': True
            }

        return None

    def _extract_nuisance_covenant(self) -> Optional[Dict]:
        """Extract nuisance prohibition"""
        pattern = r'(?:not|shall not)[^.]{0,50}?(?:nuisance|annoyance)[^.]{0,100}?\.'
        match = re.search(pattern, self.text_lower, re.IGNORECASE)

        if match:
            full_text = match.group(0)
            return {
                'id': str(uuid.uuid4()),
                'lease_id': self.lease_id,
                'building_id': self.building_id,
                'unit_id': self.unit_id,
                'covenant_type': 'nuisance',
                'obligated_party': 'tenant',
                'covenant_summary': 'Not to cause nuisance or annoyance',
                'covenant_full_text': full_text
            }

        return None

    # =========================================
    # RESTRICTIONS EXTRACTION
    # =========================================

    def extract_restrictions(self) -> List[Dict]:
        """Extract specific lease restrictions"""
        restrictions = []

        # Pets
        pets_restriction = self._extract_pets_restriction()
        if pets_restriction:
            restrictions.append(pets_restriction)

        # Subletting
        sublet_restriction = self._extract_subletting_restriction()
        if sublet_restriction:
            restrictions.append(sublet_restriction)

        # Assignment
        assignment_restriction = self._extract_assignment_restriction()
        if assignment_restriction:
            restrictions.append(assignment_restriction)

        # Short lets
        short_lets_restriction = self._extract_short_lets_restriction()
        if short_lets_restriction:
            restrictions.append(short_lets_restriction)

        return restrictions

    def _extract_pets_restriction(self) -> Optional[Dict]:
        """Extract pets policy"""
        pattern = r'(?:pets?|animals?)[^.]{0,100}?\.'
        match = re.search(pattern, self.text_lower, re.IGNORECASE)

        if match:
            full_text = match.group(0)
            not_permitted = 'not' in full_text or 'no pets' in full_text.lower()

            return {
                'id': str(uuid.uuid4()),
                'lease_id': self.lease_id,
                'building_id': self.building_id,
                'unit_id': self.unit_id,
                'restriction_category': 'pets',
                'restriction_text': full_text,
                'is_absolute_prohibition': not_permitted,
                'consent_required': 'consent' in full_text.lower(),
                'pets_permitted': not not_permitted
            }

        return None

    def _extract_subletting_restriction(self) -> Optional[Dict]:
        """Extract subletting policy"""
        pattern = r'(?:sublet|sub-let|underletting)[^.]{0,150}?\.'
        match = re.search(pattern, self.text_lower, re.IGNORECASE)

        if match:
            full_text = match.group(0)
            absolute_prohibition = 'not' in full_text and 'sublet' in full_text.lower()
            consent_required = 'consent' in full_text.lower() or 'permission' in full_text.lower()

            return {
                'id': str(uuid.uuid4()),
                'lease_id': self.lease_id,
                'building_id': self.building_id,
                'unit_id': self.unit_id,
                'restriction_category': 'subletting',
                'restriction_text': full_text,
                'is_absolute_prohibition': absolute_prohibition,
                'consent_required': consent_required,
                'subletting_permitted': not absolute_prohibition
            }

        return None

    def _extract_assignment_restriction(self) -> Optional[Dict]:
        """Extract assignment policy"""
        pattern = r'(?:assign|assignment)[^.]{0,150}?\.'
        match = re.search(pattern, self.text_lower, re.IGNORECASE)

        if match:
            full_text = match.group(0)
            consent_required = 'consent' in full_text.lower() or 'permission' in full_text.lower()
            not_unreasonably_withheld = 'not' in full_text and 'unreasonably withheld' in full_text.lower()

            return {
                'id': str(uuid.uuid4()),
                'lease_id': self.lease_id,
                'building_id': self.building_id,
                'unit_id': self.unit_id,
                'restriction_category': 'assignment',
                'restriction_text': full_text,
                'consent_required': consent_required,
                'consent_conditions': 'Not to be unreasonably withheld' if not_unreasonably_withheld else None,
                'assignment_permitted': True,
                'assignment_consent_required': consent_required
            }

        return None

    def _extract_short_lets_restriction(self) -> Optional[Dict]:
        """Extract short-term letting policy"""
        pattern = r'(?:short.{0,5}let|airbnb|holiday let)[^.]{0,100}?\.'
        match = re.search(pattern, self.text_lower, re.IGNORECASE)

        if match:
            full_text = match.group(0)
            not_permitted = 'not' in full_text or 'prohibited' in full_text.lower()

            return {
                'id': str(uuid.uuid4()),
                'lease_id': self.lease_id,
                'building_id': self.building_id,
                'unit_id': self.unit_id,
                'restriction_category': 'short_lets',
                'restriction_text': full_text,
                'is_absolute_prohibition': not_permitted,
                'short_lets_permitted': not not_permitted
            }

        return None
