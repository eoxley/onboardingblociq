"""
BlocIQ Comprehensive Lease Extractor
Handles all 28 index points from lease documents
Based on LeaseClear extraction methodology
"""

import re
import uuid
from typing import Dict, List, Optional, Tuple
from datetime import datetime, timedelta
from lease_data_extractor import LeaseDataExtractor


class ComprehensiveLease Extractor(LeaseDataExtractor):
    """
    Comprehensive lease extraction covering all 28 index points
    Extends base LeaseDataExtractor with additional fields
    """

    def __init__(self, lease_id: str, building_id: str, unit_id: Optional[str], ocr_text: str):
        super().__init__(lease_id, building_id, unit_id, ocr_text)

    def extract_comprehensive_lease(self) -> Dict:
        """
        Extract all lease data including 28 index points

        Returns:
            Complete lease data structure with all tables
        """
        return {
            # Core lease record (updated)
            'lease': self.extract_lease_core(),

            # Index Points 3, 4, 27, 26
            'parties': self.extract_parties(),  # IP 3

            # Index Point 5
            'demise': self.extract_demise(),

            # Index Points 12-14, 21-24
            'financial_terms': self.extract_financial_terms(),

            # Index Point 14
            'insurance_terms': self.extract_insurance_terms(),

            # Index Points 6, 8-11, 17-19
            'covenants': self.extract_covenants(),
            'restrictions': self.extract_restrictions(),

            # Index Point 20
            'rights': self.extract_rights(),

            # Index Points 15-16
            'enforcement': self.extract_enforcement(),

            # Index Point 25
            'clauses': self.extract_clause_references(),

            # JSON summary for PDF
            'summary': self.generate_lease_summary()
        }

    # =========================================
    # INDEX POINTS 1-2: Property Identity & Title
    # =========================================

    def extract_lease_core(self) -> Dict:
        """Extract core lease fields (Index Points 1, 2, 4, 26, 27)"""
        lease = {
            'id': self.lease_id,
            'building_id': self.building_id,
            'unit_id': self.unit_id
        }

        # IP 1: Property address/unit ref
        lease['property_address'] = self._extract_property_address()
        lease['floor_description'] = self._extract_floor_description()
        lease['plot_number'] = self._extract_plot_number()

        # IP 2: Title number
        lease['title_number'] = self._extract_title_number()

        # IP 4: Term dates (from base class + expiry)
        lease['term_start'] = self._extract_term_start(self.text)
        lease['term_years'] = self._extract_term_years(self.text)
        lease['expiry_date'] = self._calculate_expiry_date(lease['term_start'], lease['term_years'])

        # IP 26: Head lease link
        lease['head_lease_reference'] = self._extract_head_lease_reference()
        lease['is_underlease'] = self._check_is_underlease()

        # IP 27: Legal dates
        lease['deed_date'] = self._extract_deed_date()

        return lease

    def _extract_property_address(self) -> Optional[str]:
        """Extract full property address from demise"""
        patterns = [
            r'(?:known as|being|situate at)\s+([^(]{20,150}?)(?:\(Plot|\sand)',
            r'((?:Flat|Apartment|Unit)\s+\d+[^.]{10,100}?[A-Z]{2}\d{1,2}\s+\d[A-Z]{2})',
            r'([A-Z][a-z]+\s+(?:Floor|level)\s+(?:Flat|Apartment)[^.]{10,100}?)'
        ]

        for pattern in patterns:
            match = re.search(pattern, self.text, re.IGNORECASE)
            if match:
                address = match.group(1).strip()
                # Clean up
                address = re.sub(r'\s+', ' ', address)
                return address

        return None

    def _extract_floor_description(self) -> Optional[str]:
        """Extract floor level (e.g., 'First Floor', 'Ground Floor')"""
        pattern = r'((?:Ground|First|Second|Third|Fourth|Fifth|Top)\s+Floor)'
        match = re.search(pattern, self.text, re.IGNORECASE)
        return match.group(1) if match else None

    def _extract_plot_number(self) -> Optional[str]:
        """Extract plot number from property description"""
        pattern = r'\(Plot\s+(\d+)\)'
        match = re.search(pattern, self.text, re.IGNORECASE)
        return match.group(1) if match else None

    def _extract_title_number(self) -> Optional[str]:
        """Extract Land Registry title number (IP 2)"""
        patterns = [
            r'[Tt]itle\s+[Nn]umber[:\s]+([A-Z]{2,3}\d+)',
            r'registered\s+under\s+[Tt]itle\s+[Nn]umber\s+([A-Z]{2,3}\d+)',
            r'([A-Z]{2,3}\d{4,8})'  # Generic title format
        ]

        for pattern in patterns:
            match = re.search(pattern, self.text)
            if match:
                title = match.group(1)
                # Validate format (2-3 letters + 4-8 digits)
                if re.match(r'^[A-Z]{2,3}\d{4,8}$', title):
                    return title

        return None

    def _extract_head_lease_reference(self) -> Optional[str]:
        """Extract reference to head/superior lease (IP 26)"""
        patterns = [
            r'(?:Underlease|[Ss]ub-lease)\s+of\s+(?:a\s+)?(?:[Hh]ead\s+)?[Ll]ease\s+dated\s+([^.]{10,80})',
            r'[Hh]ead\s+[Ll]ease\s+dated\s+(\d{1,2}\s+\w+\s+\d{4})',
            r'[Ss]ubject to\s+(?:a\s+)?[Ll]ease\s+dated\s+([^.]{10,60})'
        ]

        for pattern in patterns:
            match = re.search(pattern, self.text)
            if match:
                return match.group(1).strip()

        return None

    def _check_is_underlease(self) -> bool:
        """Check if this is an underlease/sub-lease"""
        indicators = ['underlease', 'sub-lease', 'subject to a lease', 'head lease']
        return any(indicator in self.text_lower for indicator in indicators)

    def _extract_deed_date(self) -> Optional[str]:
        """Extract deed execution date (IP 27)"""
        patterns = [
            r'[Dd]ated\s+(?:this\s+)?(\d{1,2}(?:st|nd|rd|th)?\s+\w+\s+\d{4})',
            r'[Ee]xecuted\s+on\s+(\d{1,2}[/-]\d{1,2}[/-]\d{4})',
            r'[Dd]eed\s+[Dd]ate[:\s]+(\d{1,2}[/-]\d{1,2}[/-]\d{4})'
        ]

        for pattern in patterns:
            match = re.search(pattern, self.text)
            if match:
                date_str = match.group(1)
                return self._parse_date(date_str)

        return None

    def _calculate_expiry_date(self, start_date: Optional[str], term_years: Optional[int]) -> Optional[str]:
        """Calculate lease expiry date"""
        if not start_date or not term_years:
            return None

        try:
            start_dt = datetime.strptime(start_date, '%Y-%m-%d')
            expiry_dt = start_dt + timedelta(days=365.25 * term_years)
            return expiry_dt.strftime('%Y-%m-%d')
        except:
            return None

    def _parse_date(self, date_str: str) -> Optional[str]:
        """Parse date to YYYY-MM-DD format"""
        # Remove ordinal indicators
        date_str = re.sub(r'(\d+)(st|nd|rd|th)', r'\1', date_str)

        date_formats = ['%d %B %Y', '%d %b %Y', '%d/%m/%Y', '%d-%m-%Y', '%Y-%m-%d']

        for fmt in date_formats:
            try:
                parsed = datetime.strptime(date_str, fmt)
                return parsed.strftime('%Y-%m-%d')
            except ValueError:
                continue

        return None

    # =========================================
    # INDEX POINT 3: Parties
    # =========================================

    def extract_parties(self) -> List[Dict]:
        """Extract all parties (lessor, lessee, management company)"""
        parties = []

        # Extract lessors
        lessors = self._extract_lessors()
        parties.extend(lessors)

        # Extract lessees
        lessees = self._extract_lessees()
        parties.extend(lessees)

        # Extract management company
        mgmt_co = self._extract_management_company()
        if mgmt_co:
            parties.append(mgmt_co)

        return parties

    def _extract_lessors(self) -> List[Dict]:
        """Extract lessor(s)"""
        parties = []
        pattern = r'(?:[Ll]essor|[Gg]rantor)[:\s]+([A-Z][a-zA-Z\s&]+(?:Ltd|Limited|LLP|plc)?)'
        matches = re.finditer(pattern, self.text)

        for idx, match in enumerate(matches):
            name = match.group(1).strip()
            # Clean up
            name = re.sub(r'\s+', ' ', name)
            name = name.split(' (')[0]  # Remove bracketed info

            parties.append({
                'id': str(uuid.uuid4()),
                'lease_id': self.lease_id,
                'building_id': self.building_id,
                'unit_id': self.unit_id,
                'party_type': 'lessor',
                'party_name': name,
                'party_order': idx + 1,
                'is_joint_party': idx > 0
            })

        return parties

    def _extract_lessees(self) -> List[Dict]:
        """Extract lessee(s)"""
        parties = []
        pattern = r'(?:[Ll]essee|[Gg]rantee)[:\s]+([A-Z][a-z]+(?: [A-Z][a-z]+)+(?:\s+(?:and|&)\s+[A-Z][a-z]+(?: [A-Z][a-z]+)+)*)'
        match = re.search(pattern, self.text)

        if match:
            lessee_text = match.group(1)
            # Split on "and" or "&"
            names = re.split(r'\s+(?:and|&)\s+', lessee_text)

            for idx, name in enumerate(names):
                name = name.strip()
                parties.append({
                    'id': str(uuid.uuid4()),
                    'lease_id': self.lease_id,
                    'building_id': self.building_id,
                    'unit_id': self.unit_id,
                    'party_type': 'lessee',
                    'party_name': name,
                    'party_order': idx + 1,
                    'is_joint_party': len(names) > 1
                })

        return parties

    def _extract_management_company(self) -> Optional[Dict]:
        """Extract management company / RMC"""
        patterns = [
            r'([A-Z][a-zA-Z\s]+(?:RMC|Management Company|Residents Management))',
            r'([A-Z][a-zA-Z\s]+(?:RTM|Right to Manage))',
            r'managed by\s+([A-Z][a-zA-Z\s]+(?:Ltd|Limited|LLP))'
        ]

        for pattern in patterns:
            match = re.search(pattern, self.text)
            if match:
                name = match.group(1).strip()
                name = re.sub(r'\s+', ' ', name)

                return {
                    'id': str(uuid.uuid4()),
                    'lease_id': self.lease_id,
                    'building_id': self.building_id,
                    'unit_id': self.unit_id,
                    'party_type': 'management_company',
                    'party_name': name,
                    'party_order': 1,
                    'is_joint_party': False
                }

        return None

    # =========================================
    # INDEX POINT 5: Demise Definition
    # =========================================

    def extract_demise(self) -> Dict:
        """Extract detailed demise description"""
        demise = {
            'id': str(uuid.uuid4()),
            'lease_id': self.lease_id,
            'building_id': self.building_id,
            'unit_id': self.unit_id
        }

        # Find demise clause
        demise_pattern = r'(?:[Dd]emise|[Dd]emised [Pp]remises)[^.]{20,500}?\.'
        match = re.search(demise_pattern, self.text)
        demise['raw_demise_clause'] = match.group(0) if match else None

        if match:
            clause_text = match.group(0).lower()

            # Check specific inclusions
            demise['includes_external_walls'] = 'external wall' in clause_text or 'outer wall' in clause_text
            demise['includes_windows'] = 'window' in clause_text
            demise['includes_balcony'] = 'balcony' in clause_text or 'terrace' in clause_text
            demise['includes_roof'] = 'roof' in clause_text
            demise['includes_letterbox'] = 'letterbox' in clause_text or 'letter box' in clause_text
            demise['includes_parking'] = 'parking' in clause_text or 'garage' in clause_text

            # Extract floor level
            demise['floor_level'] = self._extract_floor_description()

            # Extract inclusions/exclusions arrays
            demise['inclusions'] = self._extract_demise_inclusions(clause_text)
            demise['exclusions'] = self._extract_demise_exclusions(clause_text)

        demise['property_description'] = self._extract_property_address()

        return demise

    def _extract_demise_inclusions(self, clause_text: str) -> Optional[List[str]]:
        """Extract list of included items"""
        inclusions = []

        inclusion_items = [
            'external walls', 'windows', 'balcony', 'terrace', 'roof',
            'letterbox', 'internal walls', 'floors', 'ceilings',
            'doors', 'fixtures', 'fittings'
        ]

        for item in inclusion_items:
            if item in clause_text:
                inclusions.append(item)

        return inclusions if inclusions else None

    def _extract_demise_exclusions(self, clause_text: str) -> Optional[List[str]]:
        """Extract list of excluded items"""
        exclusions = []

        # Look for "excluding" or "except" patterns
        exclusion_pattern = r'(?:exclud(?:ing|es)|except|save for)\s+([^.]{10,150})'
        match = re.search(exclusion_pattern, clause_text)

        if match:
            exclusion_text = match.group(1)
            # Split on commas and "and"
            items = re.split(r',\s*(?:and\s+)?|\s+and\s+', exclusion_text)
            exclusions = [item.strip() for item in items if len(item.strip()) > 3]

        return exclusions if exclusions else None

    # =========================================
    # INDEX POINT 20: Access Rights & Easements
    # =========================================

    def extract_rights(self) -> List[Dict]:
        """Extract access rights, easements, rights of way"""
        rights = []

        # Hallway/common area access
        hallway_right = self._extract_hallway_access_right()
        if hallway_right:
            rights.append(hallway_right)

        # Garden use
        garden_right = self._extract_garden_use_right()
        if garden_right:
            rights.append(garden_right)

        # Parking rights
        parking_right = self._extract_parking_right()
        if parking_right:
            rights.append(parking_right)

        # Landlord entry rights
        entry_right = self._extract_landlord_entry_right()
        if entry_right:
            rights.append(entry_right)

        return rights

    def _extract_hallway_access_right(self) -> Optional[Dict]:
        """Extract right to use hallways/stairs"""
        pattern = r'(?:right to use|entitled to use)\s+(?:the\s+)?(?:hallway|corridor|staircase|common parts)[^.]{0,100}?\.'
        match = re.search(pattern, self.text_lower)

        if match:
            return {
                'id': str(uuid.uuid4()),
                'lease_id': self.lease_id,
                'building_id': self.building_id,
                'unit_id': self.unit_id,
                'right_type': 'access',
                'right_description': 'Right to use hallways, stairs, and common parts',
                'beneficiary': 'tenant',
                'hallway_access': True,
                'raw_rights_clause': match.group(0)
            }

        return None

    def _extract_garden_use_right(self) -> Optional[Dict]:
        """Extract garden usage rights"""
        pattern = r'(?:right to use|enjoy)\s+(?:the\s+)?(?:garden|communal garden|grounds)[^.]{0,100}?\.'
        match = re.search(pattern, self.text_lower)

        if match:
            return {
                'id': str(uuid.uuid4()),
                'lease_id': self.lease_id,
                'building_id': self.building_id,
                'unit_id': self.unit_id,
                'right_type': 'garden_use',
                'right_description': 'Right to use communal gardens',
                'beneficiary': 'tenant',
                'garden_access': True,
                'raw_rights_clause': match.group(0)
            }

        return None

    def _extract_parking_right(self) -> Optional[Dict]:
        """Extract parking rights"""
        pattern = r'(?:parking|garage)\s+(?:space|bay)[^.]{0,100}?\.'
        match = re.search(pattern, self.text_lower)

        if match:
            return {
                'id': str(uuid.uuid4()),
                'lease_id': self.lease_id,
                'building_id': self.building_id,
                'unit_id': self.unit_id,
                'right_type': 'parking',
                'right_description': match.group(0),
                'beneficiary': 'tenant',
                'parking_rights': True,
                'raw_rights_clause': match.group(0)
            }

        return None

    def _extract_landlord_entry_right(self) -> Optional[Dict]:
        """Extract landlord's right to enter"""
        pattern = r'(?:lessor|landlord)\s+may\s+enter[^.]{10,200}?\.'
        match = re.search(pattern, self.text_lower)

        if match:
            full_clause = match.group(0)

            # Extract notice period
            notice_pattern = r'(\d+)\s+(?:days?|hours?|months?)\s*(?:notice|\'notice)'
            notice_match = re.search(notice_pattern, full_clause)
            notice_days = None
            if notice_match:
                unit = 'day' if 'day' in full_clause else ('month' if 'month' in full_clause else 'hour')
                value = int(notice_match.group(1))
                if unit == 'month':
                    notice_days = value * 30
                elif unit == 'hour':
                    notice_days = max(1, value // 24)
                else:
                    notice_days = value

            return {
                'id': str(uuid.uuid4()),
                'lease_id': self.lease_id,
                'building_id': self.building_id,
                'unit_id': self.unit_id,
                'right_type': 'emergency_access',
                'right_description': 'Landlord may enter with notice',
                'beneficiary': 'landlord',
                'emergency_entry': True,
                'notice_required': notice_days is not None,
                'notice_period_days': notice_days,
                'raw_rights_clause': full_clause
            }

        return None

    # =========================================
    # INDEX POINTS 15-16: Enforcement
    # =========================================

    def extract_enforcement(self) -> List[Dict]:
        """Extract forfeiture and landlord remedy clauses"""
        enforcement = []

        # Forfeiture
        forfeiture = self._extract_forfeiture_clause()
        if forfeiture:
            enforcement.append(forfeiture)

        # Landlord repair remedy
        repair_remedy = self._extract_landlord_repair_remedy()
        if repair_remedy:
            enforcement.append(repair_remedy)

        return enforcement

    def _extract_forfeiture_clause(self) -> Optional[Dict]:
        """Extract forfeiture/re-entry clause (IP 15)"""
        pattern = r'(?:forfeiture|re-enter|re-entry)[^.]{10,300}?\.'
        match = re.search(pattern, self.text_lower)

        if not match:
            return None

        clause_text = match.group(0)

        # Extract notice periods
        notice_pattern = r'(\d+)\s+(?:month|day)s?\s*(?:notice|\'notice)'
        notice_matches = re.findall(notice_pattern, clause_text)

        notice_to_mortgagee = 'mortgagee' in clause_text or 'lender' in clause_text

        return {
            'id': str(uuid.uuid4()),
            'lease_id': self.lease_id,
            'building_id': self.building_id,
            'unit_id': self.unit_id,
            'enforcement_type': 'forfeiture',
            'forfeiture_permitted': True,
            'notice_period_days': int(notice_matches[0]) if notice_matches else None,
            'notice_to_mortgagee_required': notice_to_mortgagee,
            'mortgagee_notice_period_days': int(notice_matches[1]) if len(notice_matches) > 1 else None,
            'forfeiture_grounds': self._extract_forfeiture_grounds(clause_text),
            'raw_enforcement_clause': clause_text
        }

    def _extract_forfeiture_grounds(self, clause_text: str) -> Optional[List[str]]:
        """Extract grounds for forfeiture"""
        grounds = []

        if 'rent' in clause_text or 'arrears' in clause_text:
            grounds.append('rent_arrears')
        if 'breach' in clause_text or 'covenant' in clause_text:
            grounds.append('covenant_breach')
        if 'bankrupt' in clause_text:
            grounds.append('bankruptcy')
        if 'insolvency' in clause_text:
            grounds.append('insolvency')

        return grounds if grounds else None

    def _extract_landlord_repair_remedy(self) -> Optional[Dict]:
        """Extract landlord's power to repair and recover costs (IP 16)"""
        pattern = r'(?:lessor|landlord)\s+may[^.]{10,200}?(?:enter|carry out|execute)\s+(?:works|repairs)[^.]{0,100}?\.'
        match = re.search(pattern, self.text_lower)

        if not match:
            return None

        clause_text = match.group(0)

        # Extract notice period
        notice_pattern = r'(\d+)\s+(?:month|day)s?\s*(?:notice|\'notice)'
        notice_match = re.search(notice_pattern, clause_text)
        notice_days = int(notice_match.group(1)) if notice_match else None

        # Check if costs recoverable as rent
        costs_as_rent = 'as rent' in clause_text or 'additional rent' in clause_text or 'recoverable as rent' in clause_text

        return {
            'id': str(uuid.uuid4()),
            'lease_id': self.lease_id,
            'building_id': self.building_id,
            'unit_id': self.unit_id,
            'enforcement_type': 'landlord_remedy',
            'landlord_can_enter_and_repair': True,
            'repair_notice_period_days': notice_days,
            'costs_recoverable_as_rent': costs_as_rent,
            'raw_enforcement_clause': clause_text
        }

    # =========================================
    # INDEX POINT 25: Clause References
    # =========================================

    def extract_clause_references(self) -> List[Dict]:
        """Extract structured clause references for traceability"""
        clauses = []

        # Find all numbered clauses
        clause_pattern = r'(?:Clause|Section|Schedule)\s+(\d+(?:\(\d+\))?(?:\.\d+)?)\s*[-:]?\s*([A-Z][^.\n]{10,100})'
        matches = re.finditer(clause_pattern, self.text)

        for match in matches:
            clause_number = match.group(1)
            clause_title = match.group(2).strip()

            # Categorize clause
            category = self._categorize_clause(clause_title)

            clauses.append({
                'id': str(uuid.uuid4()),
                'lease_id': self.lease_id,
                'building_id': self.building_id,
                'clause_number': clause_number,
                'clause_title': clause_title,
                'clause_category': category,
                'clause_summary': clause_title[:200]
            })

            # Limit to avoid excessive extraction
            if len(clauses) >= 50:
                break

        return clauses

    def _categorize_clause(self, title: str) -> str:
        """Categorize clause by title"""
        title_lower = title.lower()

        categories = {
            'rent': ['rent', 'ground rent'],
            'service_charge': ['service charge', 'maintenance charge'],
            'insurance': ['insurance', 'insure'],
            'repair': ['repair', 'maintenance', 'decoration'],
            'alterations': ['alteration', 'improvement', 'structural'],
            'use': ['use', 'occupation', 'business'],
            'assignment': ['assignment', 'transfer'],
            'subletting': ['sublet', 'underlease'],
            'forfeiture': ['forfeiture', 're-entry', 'breach'],
            'parking': ['parking', 'vehicle', 'garage'],
            'demise': ['demise', 'premises'],
            'covenants': ['covenant', 'obligation']
        }

        for category, keywords in categories.items():
            if any(keyword in title_lower for keyword in keywords):
                return category

        return 'other'

    # =========================================
    # INDEX POINTS 12, 21-24: Enhanced Financial Terms
    # =========================================

    def extract_financial_terms(self) -> Dict:
        """Override parent method with enhanced extraction"""
        financial_terms = super().extract_financial_terms()

        # IP 21: Apportionments
        internal_pct, external_pct = self._extract_apportionments()
        financial_terms['internal_apportionment_percentage'] = internal_pct
        financial_terms['external_apportionment_percentage'] = external_pct
        financial_terms['apportionment_basis'] = self._extract_apportionment_basis()

        # IP 12: Service charge payment terms
        financial_terms['payment_notice_days'] = self._extract_payment_notice_days()
        financial_terms['monthly_instalments_permitted'] = self._check_monthly_instalments()

        # Service charge year details
        start_month, start_day = self._extract_service_charge_start_details()
        financial_terms['service_charge_year_start_month'] = start_month
        financial_terms['service_charge_year_start_day'] = start_day

        return financial_terms

    def _extract_apportionments(self) -> Tuple[Optional[float], Optional[float]]:
        """Extract internal and external apportionment percentages (IP 21)"""
        internal_pct = None
        external_pct = None

        # Internal apportionment
        internal_pattern = r'internal[^.]{0,50}?(\d+(?:\.\d+)?)\s*%'
        internal_match = re.search(internal_pattern, self.text_lower)
        if internal_match:
            internal_pct = float(internal_match.group(1))

        # External apportionment
        external_pattern = r'external[^.]{0,50}?(\d+(?:\.\d+)?)\s*%'
        external_match = re.search(external_pattern, self.text_lower)
        if external_match:
            external_pct = float(external_match.group(1))

        return internal_pct, external_pct

    def _extract_apportionment_basis(self) -> Optional[str]:
        """Determine basis of apportionment"""
        if 'per schedule' in self.text_lower or 'as set out in schedule' in self.text_lower:
            return 'per schedule'
        elif 'equal' in self.text_lower and 'share' in self.text_lower:
            return 'equal shares'
        elif 'floor area' in self.text_lower:
            return 'floor area'

        return None

    def _extract_payment_notice_days(self) -> Optional[int]:
        """Extract payment deadline after notice (IP 12)"""
        pattern = r'pay(?:able)?\s+within\s+(\d+)\s+days?\s+of\s+(?:notice|demand)'
        match = re.search(pattern, self.text_lower)
        return int(match.group(1)) if match else None

    def _check_monthly_instalments(self) -> bool:
        """Check if monthly instalments permitted (IP 12)"""
        indicators = ['monthly instalments', 'monthly payments', 'pay monthly']
        return any(indicator in self.text_lower for indicator in indicators)

    def _extract_service_charge_start_details(self) -> Tuple[Optional[str], Optional[int]]:
        """Extract service charge year start month and day"""
        pattern = r'(?:year|period)\s+(?:commencing|starting|beginning)\s+(\d{1,2})(?:st|nd|rd|th)?\s+(\w+)'
        match = re.search(pattern, self.text_lower)

        if match:
            day = int(match.group(1))
            month = match.group(2).capitalize()
            return month, day

        return None, None

    # =========================================
    # Enhanced Restrictions (IP 8-11, 17-19)
    # =========================================

    def extract_restrictions(self) -> List[Dict]:
        """Override parent with enhanced restrictions"""
        restrictions = super().extract_restrictions()

        # IP 18: Parking/vehicles
        parking_restriction = self._extract_parking_restriction()
        if parking_restriction:
            restrictions.append(parking_restriction)

        # IP 19: Washing/exterior use
        washing_restriction = self._extract_washing_restriction()
        if washing_restriction:
            restrictions.append(washing_restriction)

        # IP 17: RMC membership
        rmc_restriction = self._extract_rmc_membership_restriction()
        if rmc_restriction:
            restrictions.append(rmc_restriction)

        return restrictions

    def _extract_parking_restriction(self) -> Optional[Dict]:
        """Extract parking and vehicle restrictions (IP 18)"""
        pattern = r'(?:parking|vehicle|motor car)[^.]{10,200}?\.'
        match = re.search(pattern, self.text_lower)

        if not match:
            return None

        clause_text = match.group(0)

        # Extract number of permitted vehicles
        number_pattern = r'(?:only|maximum of|not more than)\s+(\d+)\s+(?:vehicle|car|motor)'
        number_match = re.search(number_pattern, clause_text)
        spaces_allocated = int(number_match.group(1)) if number_match else None

        # Check for roadworthy requirement
        roadworthy = 'roadworthy' in clause_text or 'working order' in clause_text

        # Time limit for unroadworthy vehicles
        time_pattern = r'(\d+)\s+hours?'
        time_match = re.search(time_pattern, clause_text)
        time_limit = int(time_match.group(1)) if time_match else None

        return {
            'id': str(uuid.uuid4()),
            'lease_id': self.lease_id,
            'building_id': self.building_id,
            'unit_id': self.unit_id,
            'restriction_category': 'parking',
            'restriction_text': clause_text,
            'parking_spaces_allocated': spaces_allocated,
            'vehicle_roadworthy_requirement': roadworthy,
            'vehicle_time_limit_hours': time_limit
        }

    def _extract_washing_restriction(self) -> Optional[Dict]:
        """Extract washing/exterior use restrictions (IP 19)"""
        pattern = r'(?:washing|laundry|clothes|sign|board)[^.]{10,150}?\.'
        match = re.search(pattern, self.text_lower)

        if not match:
            return None

        clause_text = match.group(0)

        washing_allowed = not ('not' in clause_text or 'no washing' in clause_text)
        signage_allowed = 'for sale' in clause_text or 'to let' in clause_text
        for_sale_board = 'for sale' in clause_text and 'board' in clause_text

        return {
            'id': str(uuid.uuid4()),
            'lease_id': self.lease_id,
            'building_id': self.building_id,
            'unit_id': self.unit_id,
            'restriction_category': 'other',
            'restriction_text': clause_text,
            'washing_on_balcony_permitted': washing_allowed,
            'signage_permitted': signage_allowed,
            'for_sale_board_permitted': for_sale_board
        }

    def _extract_rmc_membership_restriction(self) -> Optional[Dict]:
        """Extract RMC membership requirements (IP 17)"""
        pattern = r'(?:member|membership)[^.]{10,200}?(?:management company|rmc)[^.]{0,100}?\.'
        match = re.search(pattern, self.text_lower)

        if not match:
            return None

        clause_text = match.group(0)

        membership_required = 'must' in clause_text or 'shall' in clause_text
        buyer_must_join = 'buyer' in clause_text or 'purchaser' in clause_text or 'transferee' in clause_text

        return {
            'id': str(uuid.uuid4()),
            'lease_id': self.lease_id,
            'building_id': self.building_id,
            'unit_id': self.unit_id,
            'restriction_category': 'other',
            'restriction_text': clause_text,
            'rmc_membership_required': membership_required,
            'buyer_must_join_rmc': buyer_must_join
        }

    # =========================================
    # JSON SUMMARY FOR PDF
    # =========================================

    def generate_lease_summary(self) -> Dict:
        """Generate JSON summary for Building Health Check PDF"""
        lease_core = self.extract_lease_core()
        financial = self.extract_financial_terms()
        insurance = self.extract_insurance_terms()
        restrictions = self.extract_restrictions()
        rights = self.extract_rights()

        # Build readable restrictions summary
        restrictions_summary = []
        for r in restrictions:
            if r.get('pets_permitted') is False:
                restrictions_summary.append('No pets')
            if r.get('subletting_permitted') is False:
                restrictions_summary.append('No subletting')
            if r.get('short_lets_permitted') is False:
                restrictions_summary.append('No short lets')
            if r.get('parking_spaces_allocated'):
                restrictions_summary.append(f"{r['parking_spaces_allocated']} parking space(s)")

        summary = {
            'unit': lease_core.get('property_address', 'Unknown'),
            'term': f"{lease_core.get('term_years', 0)}y ({lease_core.get('term_start', '')} – {lease_core.get('expiry_date', '')})",
            'ground_rent': f"£{financial.get('ground_rent', 0)}" if financial.get('ground_rent') else 'Peppercorn',
            'sc_year': f"{financial.get('service_charge_year_start_month', 'Apr')}–{financial.get('service_charge_year_start_month', 'Mar')}",
            'restrictions': ', '.join(restrictions_summary) if restrictions_summary else 'None',
            'internal_share': f"{financial.get('internal_apportionment_percentage', 0)}%" if financial.get('internal_apportionment_percentage') else None,
            'insurance': 'Landlord insures; Tenant contributes' if insurance.get('landlord_insures') else 'Unknown',
            'review': f"Every {financial.get('rent_review_frequency_years')} years" if financial.get('rent_review_frequency_years') else None
        }

        return summary
