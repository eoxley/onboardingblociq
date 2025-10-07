"""
BlocIQ Onboarder - Service Contract Extractor
Extracts service agreement and maintenance contract data
"""

import re
import uuid
from typing import Dict, Optional
from datetime import datetime


class ContractsExtractor:
    """Extracts service contract information from documents"""

    SERVICE_TYPES = [
        'fire_alarm', 'lifts', 'cleaning', 'grounds_maintenance', 'security',
        'emergency_lighting', 'cctv', 'door_entry', 'gate_maintenance',
        'pest_control', 'window_cleaning', 'communal_lighting', 'drainage'
    ]

    CONTRACTORS = [
        'Tetra', 'WHM', 'Quotehedge', 'Cuanku', 'BES Group', 'Capita',
        'Mitie', 'ISS', 'CBRE', 'JLL', 'Savills', 'Knight Frank'
    ]

    def __init__(self):
        pass

    def extract(self, file_data: Dict, building_id: str) -> Optional[Dict]:
        """Extract contract data and contractor details from parsed document"""
        file_name = file_data.get('file_name', '')
        full_text = file_data.get('full_text', '')

        if not full_text:
            full_text = self._extract_text_from_data(file_data)

        if not full_text or len(full_text) < 50:
            return None

        # Extract contract data
        contractor_name = self._extract_contractor_name(full_text, file_name)
        service_type = self._detect_service_type(full_text, file_name)
        start_date = self._extract_date(full_text, 'start')
        end_date = self._extract_date(full_text, 'end')
        renewal_date = self._extract_date(full_text, 'renewal')
        frequency = self._extract_frequency(full_text)
        value = self._extract_value(full_text)
        status = self._determine_status(end_date)

        contract = {
            'id': str(uuid.uuid4()),
            'building_id': building_id,
            'contractor_name': contractor_name,
            'service_type': service_type,
            'start_date': start_date,
            'end_date': end_date,
            'renewal_date': renewal_date,
            'frequency': frequency,
            'value': value,
            'contract_status': status
        }

        # Extract detailed contractor information
        contractor = None
        if contractor_name:
            contractor = self._extract_contractor_details(full_text, contractor_name, service_type)

        result = {
            'contract': contract,
            'contractor': contractor,
            'metadata': {'extracted_from': file_name}
        }

        return result

    def _extract_text_from_data(self, file_data: Dict) -> str:
        """Extract text from data field"""
        if 'data' in file_data and isinstance(file_data['data'], str):
            return file_data['data']
        return ''

    def _extract_contractor_name(self, text: str, filename: str) -> Optional[str]:
        """Extract contractor/supplier name"""
        # Check known contractors
        for contractor in self.CONTRACTORS:
            if contractor.lower() in text.lower() or contractor.lower() in filename.lower():
                return contractor

        # Generic pattern
        pattern = r'(?:contractor|supplier|company)[:\s]*([A-Z][A-Za-z\s&]+(?:Ltd|Limited|plc))'
        match = re.search(pattern, text, re.IGNORECASE)
        if match:
            return match.group(1).strip()

        return None

    def _detect_service_type(self, text: str, filename: str) -> Optional[str]:
        """Detect service type from content"""
        search_text = f"{filename} {text}".lower()

        type_patterns = {
            'fire_alarm': ['fire alarm', 'fire detection'],
            'lifts': ['lift', 'elevator'],
            'cleaning': ['cleaning', 'cleaner'],
            'security': ['security', 'guard'],
            'pest_control': ['pest control', 'pest management']
        }

        for service_type, patterns in type_patterns.items():
            for pattern in patterns:
                if pattern in search_text:
                    return service_type

        return None

    def _extract_date(self, text: str, date_type: str) -> Optional[str]:
        """Extract date (start/end/renewal)"""
        patterns = {
            'start': [r'(?:start\s*date|commencement)[:\s]*(\d{1,2}[/-]\d{1,2}[/-]\d{2,4})'],
            'end': [r'(?:end\s*date|expiry|expires)[:\s]*(\d{1,2}[/-]\d{1,2}[/-]\d{2,4})'],
            'renewal': [r'(?:renewal\s*date)[:\s]*(\d{1,2}[/-]\d{1,2}[/-]\d{2,4})']
        }

        for pattern in patterns.get(date_type, []):
            match = re.search(pattern, text, re.IGNORECASE)
            if match:
                return self._normalize_date(match.group(1))

        return None

    def _extract_frequency(self, text: str) -> Optional[str]:
        """Extract service frequency"""
        if re.search(r'\bmonthly\b', text, re.IGNORECASE):
            return 'monthly'
        elif re.search(r'\bquarterly\b', text, re.IGNORECASE):
            return 'quarterly'
        elif re.search(r'\bannual(?:ly)?\b', text, re.IGNORECASE):
            return 'annual'
        return None

    def _extract_value(self, text: str) -> Optional[float]:
        """Extract contract value"""
        pattern = r'(?:value|amount|cost)[:\s]*£([0-9,]+(?:\.[0-9]{2})?)'
        match = re.search(pattern, text, re.IGNORECASE)
        if match:
            value_str = match.group(1).replace(',', '')
            try:
                return float(value_str)
            except ValueError:
                pass
        return None

    def _normalize_date(self, date_string: str) -> Optional[str]:
        """Normalize date to ISO format"""
        for sep in ['/', '-']:
            pattern = f'(\\d{{1,2}}){sep}(\\d{{1,2}}){sep}(\\d{{2,4}})'
            match = re.match(pattern, date_string)
            if match:
                day, month, year = match.groups()
                if len(year) == 2:
                    year = f"20{year}"
                try:
                    date_obj = datetime(int(year), int(month), int(day))
                    return date_obj.date().isoformat()
                except ValueError:
                    continue
        return None

    def _determine_status(self, end_date: Optional[str]) -> str:
        """Determine contract status"""
        if not end_date:
            return 'active'
        try:
            expiry = datetime.fromisoformat(end_date).date()
            today = datetime.now().date()
            if expiry < today:
                return 'expired'
            elif (expiry - today).days <= 90:
                return 'expiring_soon'
            else:
                return 'active'
        except:
            return 'active'

    def _extract_contractor_details(self, text: str, company_name: str, service_type: Optional[str]) -> Dict:
        """Extract detailed contractor information"""
        contractor = {
            'id': str(uuid.uuid4()),
            'company_name': company_name,
            'contact_person': self._extract_contact_person(text),
            'email': self._extract_email(text),
            'phone': self._extract_phone(text),
            'address': self._extract_address(text),
            'specialization': service_type,
            'accreditations': self._extract_accreditations(text),
            'insurance_expiry': self._extract_insurance_expiry(text),
            'vat_number': self._extract_vat_number(text),
            'notes': None
        }
        return contractor

    def _extract_contact_person(self, text: str) -> Optional[str]:
        """Extract contact person name"""
        patterns = [
            r'(?:contact|representative|manager)[:\s]*([A-Z][a-z]+\s[A-Z][a-z]+)',
            r'(?:attn:|attention:)\s*([A-Z][a-z]+\s[A-Z][a-z]+)',
            r'(?:signed by|prepared by)[:\s]*([A-Z][a-z]+\s[A-Z][a-z]+)'
        ]
        for pattern in patterns:
            match = re.search(pattern, text, re.IGNORECASE)
            if match:
                return match.group(1).strip()
        return None

    def _extract_email(self, text: str) -> Optional[str]:
        """Extract email address"""
        pattern = r'[\w\.-]+@[\w\.-]+\.\w+'
        match = re.search(pattern, text)
        if match:
            email = match.group(0)
            # Filter out common false positives
            if not any(x in email.lower() for x in ['example.com', 'email.com', 'test.com']):
                return email
        return None

    def _extract_phone(self, text: str) -> Optional[str]:
        """Extract phone number (UK format)"""
        patterns = [
            r'\+?44\s?\d{3,4}\s?\d{6,7}',  # +44 format
            r'0\d{3,4}\s?\d{6,7}',  # 01/02 format
            r'\d{5}\s?\d{6}'  # 5-6 format
        ]
        for pattern in patterns:
            match = re.search(pattern, text)
            if match:
                return match.group(0).strip()
        return None

    def _extract_address(self, text: str) -> Optional[str]:
        """Extract company address"""
        # Look for postcode patterns (UK)
        postcode_pattern = r'([A-Z]{1,2}\d{1,2}[A-Z]?\s?\d[A-Z]{2})'
        match = re.search(postcode_pattern, text)
        if match:
            # Get surrounding context (up to 100 chars before postcode)
            pos = match.start()
            start = max(0, pos - 100)
            address_text = text[start:match.end()]
            # Clean up
            lines = [l.strip() for l in address_text.split('\n') if l.strip()]
            return ', '.join(lines[-3:]) if len(lines) >= 3 else ', '.join(lines)
        return None

    def _extract_accreditations(self, text: str) -> list:
        """Extract accreditations/certifications"""
        accreditations = []
        patterns = [
            r'ISO\s?\d{4,5}',
            r'CHAS\s?(?:accredited|certified)?',
            r'SafeContractor',
            r'Constructionline',
            r'NICEIC',
            r'Gas Safe',
            r'BAFE',
            r'FIA'
        ]
        for pattern in patterns:
            matches = re.findall(pattern, text, re.IGNORECASE)
            accreditations.extend([m.strip() for m in matches])
        return list(set(accreditations)) if accreditations else []

    def _extract_insurance_expiry(self, text: str) -> Optional[str]:
        """Extract insurance expiry date"""
        patterns = [
            r'(?:insurance|liability).*?(?:expires?|expiry)[:\s]*(\d{1,2}[/-]\d{1,2}[/-]\d{2,4})',
            r'(?:valid until)[:\s]*(\d{1,2}[/-]\d{1,2}[/-]\d{2,4})'
        ]
        for pattern in patterns:
            match = re.search(pattern, text, re.IGNORECASE | re.DOTALL)
            if match:
                return self._normalize_date(match.group(1))
        return None

    def _extract_vat_number(self, text: str) -> Optional[str]:
        """Extract VAT registration number"""
        pattern = r'(?:VAT|vat).*?(?:no\.|number|reg)[:\s]*(GB\s?\d{9}|\d{9})'
        match = re.search(pattern, text, re.IGNORECASE)
        if match:
            vat = match.group(1).strip()
            if not vat.startswith('GB'):
                vat = f"GB{vat}"
            return vat
        return None
