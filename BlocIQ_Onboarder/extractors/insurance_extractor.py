"""
BlocIQ Onboarder - Insurance Policy Extractor
Extracts comprehensive insurance policy data from policy schedules and certificates
"""

import re
import uuid
from typing import Dict, List, Optional, Tuple
from datetime import datetime


class InsuranceExtractor:
    """Extracts insurance policy information from documents"""

    # Common UK insurers for pattern matching
    KNOWN_INSURERS = [
        'Zurich', 'Aviva', 'AXA', 'Allianz', 'RSA', 'Hiscox', 'Sedgwick',
        'Crawford', 'Gallagher', 'Marsh', 'Aon', 'Willis Towers Watson',
        'Direct Line', 'LV=', 'NFU Mutual', 'Ecclesiastical'
    ]

    # Common cover types
    COVER_TYPES = {
        'buildings': ['buildings insurance', 'property insurance', 'building cover'],
        'terrorism': ['terrorism', 'terror', 'pool re'],
        'engineering': ['engineering inspection', 'boiler', 'pressure vessel', 'lift'],
        'employers_liability': ['employers liability', 'el', "employer's liability"],
        'public_liability': ['public liability', 'pl', 'third party'],
        'directors_officers': ['directors and officers', 'd&o', 'management liability'],
        'cyber': ['cyber', 'data breach', 'cyber liability']
    }

    def __init__(self):
        pass

    def extract(self, file_data: Dict, building_id: str) -> Optional[Dict]:
        """
        Extract insurance policy data from parsed document

        Args:
            file_data: Parsed file dictionary
            building_id: UUID of the building

        Returns:
            Dict with insurance_policies record, or None
        """
        file_name = file_data.get('file_name', '')
        full_text = file_data.get('full_text', '')

        if not full_text:
            # Try to extract from data field
            full_text = self._extract_text_from_data(file_data)

        if not full_text or len(full_text) < 100:
            return None

        # Extract policy details
        insurer = self._extract_insurer(full_text, file_name)
        broker = self._extract_broker(full_text)
        policy_number = self._extract_policy_number(full_text)
        cover_type = self._detect_cover_type(full_text, file_name)

        # Extract financial details
        sum_insured = self._extract_sum_insured(full_text)
        reinstatement_value = self._extract_reinstatement_value(full_text)
        valuation_date = self._extract_valuation_date(full_text)

        # Extract dates
        start_date = self._extract_start_date(full_text)
        end_date = self._extract_end_date(full_text)

        # Extract excesses
        excess_json = self._extract_excesses(full_text)

        # Extract endorsements and conditions
        endorsements = self._extract_endorsements(full_text)
        conditions = self._extract_conditions(full_text)

        # Extract claims
        claims_json = self._extract_claims(full_text)

        # Determine policy status
        policy_status = self._determine_status(end_date)

        # Build policy record
        policy = {
            'id': str(uuid.uuid4()),
            'building_id': building_id,
            'insurer': insurer,
            'broker': broker,
            'policy_number': policy_number,
            'cover_type': cover_type,
            'sum_insured': sum_insured,
            'reinstatement_value': reinstatement_value,
            'valuation_date': valuation_date,
            'start_date': start_date,
            'end_date': end_date,
            'excess_json': excess_json,
            'endorsements': endorsements,
            'conditions': conditions,
            'claims_json': claims_json,
            'evidence_url': None,  # Will be set when uploaded to storage
            'policy_status': policy_status
        }

        # Build metadata with matched snippets for debugging
        metadata = {
            'extracted_from': file_name,
            'extraction_confidence': self._calculate_confidence(policy),
            'raw_snippets': {
                'insurer_match': self._find_snippet(full_text, insurer) if insurer else None,
                'policy_number_match': self._find_snippet(full_text, policy_number) if policy_number else None
            }
        }

        return {'policy': policy, 'metadata': metadata}

    def _extract_text_from_data(self, file_data: Dict) -> str:
        """Extract text from data field if full_text is missing"""
        content_parts = []

        if 'data' in file_data:
            data = file_data['data']

            # Handle Excel files
            if isinstance(data, dict):
                for sheet_data in data.values():
                    if isinstance(sheet_data, dict) and 'raw_data' in sheet_data:
                        for row in sheet_data['raw_data'][:100]:  # First 100 rows
                            if isinstance(row, (list, dict)):
                                content_parts.append(str(row))

            # Handle text data
            elif isinstance(data, str):
                content_parts.append(data)

        return ' '.join(content_parts)

    def _extract_insurer(self, text: str, file_name: str) -> Optional[str]:
        """Extract insurer name"""
        # Check filename first
        for insurer in self.KNOWN_INSURERS:
            if insurer.lower() in file_name.lower():
                return insurer

        # Check text content
        for insurer in self.KNOWN_INSURERS:
            if re.search(rf'\b{insurer}\b', text, re.IGNORECASE):
                return insurer

        # Generic pattern
        pattern = r'(?:insurer|underwriter)[:\s]*([A-Z][A-Za-z\s&]+(?:Ltd|Limited|plc|Insurance))'
        match = re.search(pattern, text, re.IGNORECASE)
        if match:
            return match.group(1).strip()

        return None

    def _extract_broker(self, text: str) -> Optional[str]:
        """Extract broker name"""
        patterns = [
            r'(?:broker|intermediary)[:\s]*([A-Z][A-Za-z\s&]+(?:Ltd|Limited|LLP))',
            r'(?:arranged\s+by|placed\s+by)[:\s]*([A-Z][A-Za-z\s&]+(?:Ltd|Limited|LLP))'
        ]

        for pattern in patterns:
            match = re.search(pattern, text, re.IGNORECASE)
            if match:
                broker = match.group(1).strip()
                if len(broker) > 3:
                    return broker

        return None

    def _extract_policy_number(self, text: str) -> Optional[str]:
        """Extract policy number"""
        patterns = [
            r'(?:policy\s*(?:no\.|number|ref)[:\s]*|policy[:\s]*)([A-Z0-9]{6,}[-/]?[A-Z0-9]*)',
            r'(?:certificate\s*(?:no\.|number)[:\s]*)([A-Z0-9]{6,}[-/]?[A-Z0-9]*)',
            r'(?:ref(?:erence)?[:\s]*)([A-Z0-9]{6,}[-/]?[A-Z0-9]*)'
        ]

        for pattern in patterns:
            match = re.search(pattern, text, re.IGNORECASE)
            if match:
                policy_no = match.group(1).strip()
                if len(policy_no) >= 6:
                    return policy_no

        return None

    def _detect_cover_type(self, text: str, file_name: str) -> Optional[str]:
        """Detect primary cover type"""
        search_text = f"{file_name} {text}".lower()

        for cover_type, patterns in self.COVER_TYPES.items():
            for pattern in patterns:
                if pattern.lower() in search_text:
                    return cover_type

        return None

    def _extract_sum_insured(self, text: str) -> Optional[float]:
        """Extract sum insured value"""
        patterns = [
            r'(?:sum\s*insured|total\s*sum\s*insured)[:\s]*£([0-9,]+(?:\.[0-9]{2})?)',
            r'(?:limit\s*of\s*indemnity|policy\s*limit)[:\s]*£([0-9,]+(?:\.[0-9]{2})?)'
        ]

        for pattern in patterns:
            match = re.search(pattern, text, re.IGNORECASE)
            if match:
                value_str = match.group(1).replace(',', '')
                try:
                    return float(value_str)
                except ValueError:
                    continue

        return None

    def _extract_reinstatement_value(self, text: str) -> Optional[float]:
        """Extract reinstatement value"""
        patterns = [
            r'(?:reinstatement\s*value)[:\s]*£([0-9,]+(?:\.[0-9]{2})?)',
            r'(?:rebuild\s*(?:cost|value))[:\s]*£([0-9,]+(?:\.[0-9]{2})?)'
        ]

        for pattern in patterns:
            match = re.search(pattern, text, re.IGNORECASE)
            if match:
                value_str = match.group(1).replace(',', '')
                try:
                    return float(value_str)
                except ValueError:
                    continue

        return None

    def _extract_valuation_date(self, text: str) -> Optional[str]:
        """Extract valuation date"""
        patterns = [
            r'(?:valuation\s*date)[:\s]*(\d{1,2}[/-]\d{1,2}[/-]\d{2,4})',
            r'(?:valued\s*on)[:\s]*(\d{1,2}[/-]\d{1,2}[/-]\d{2,4})'
        ]

        for pattern in patterns:
            match = re.search(pattern, text, re.IGNORECASE)
            if match:
                return self._normalize_date(match.group(1))

        return None

    def _extract_start_date(self, text: str) -> Optional[str]:
        """Extract policy start date"""
        patterns = [
            r'(?:period\s*of\s*insurance|cover)[:\s]*(?:from\s*)?(\d{1,2}[/-]\d{1,2}[/-]\d{2,4})',
            r'(?:effective\s*(?:from|date))[:\s]*(\d{1,2}[/-]\d{1,2}[/-]\d{2,4})',
            r'(?:inception\s*date)[:\s]*(\d{1,2}[/-]\d{1,2}[/-]\d{2,4})'
        ]

        for pattern in patterns:
            match = re.search(pattern, text, re.IGNORECASE)
            if match:
                return self._normalize_date(match.group(1))

        return None

    def _extract_end_date(self, text: str) -> Optional[str]:
        """Extract policy end date"""
        patterns = [
            r'(?:to|until|expiry)[:\s]*(\d{1,2}[/-]\d{1,2}[/-]\d{2,4})',
            r'(?:expires?\s*(?:on)?)[:\s]*(\d{1,2}[/-]\d{1,2}[/-]\d{2,4})',
            r'(?:renewal\s*date)[:\s]*(\d{1,2}[/-]\d{1,2}[/-]\d{2,4})'
        ]

        for pattern in patterns:
            match = re.search(pattern, text, re.IGNORECASE)
            if match:
                return self._normalize_date(match.group(1))

        return None

    def _extract_excesses(self, text: str) -> Optional[Dict]:
        """Extract excess amounts by peril"""
        excesses = {}

        # Common excess patterns
        patterns = [
            (r'(?:escape\s*of\s*water)\s*(?:excess|deductible)[:\s]*£([0-9,]+)', 'escape_of_water'),
            (r'(?:subsidence)\s*(?:excess|deductible)[:\s]*£([0-9,]+)', 'subsidence'),
            (r'(?:malicious\s*damage)\s*(?:excess|deductible)[:\s]*£([0-9,]+)', 'malicious_damage'),
            (r'(?:standard|general)\s*(?:excess|deductible)[:\s]*£([0-9,]+)', 'standard'),
            (r'(?:excess|deductible)[:\s]*£([0-9,]+)\s*(?:per\s*claim)', 'per_claim')
        ]

        for pattern, peril_type in patterns:
            match = re.search(pattern, text, re.IGNORECASE)
            if match:
                value_str = match.group(1).replace(',', '')
                try:
                    excesses[peril_type] = float(value_str)
                except ValueError:
                    continue

        return excesses if excesses else None

    def _extract_endorsements(self, text: str) -> Optional[str]:
        """Extract policy endorsements"""
        # Look for endorsements section
        patterns = [
            r'(?:endorsements?|special\s*conditions?)[:\s]*([^\n]{50,500})',
            r'(?:the\s*following\s*(?:endorsements?|conditions?))[:\s]*([^\n]{50,500})'
        ]

        endorsements = []
        for pattern in patterns:
            matches = re.findall(pattern, text, re.IGNORECASE | re.DOTALL)
            for match in matches:
                cleaned = re.sub(r'\s+', ' ', match.strip())
                if len(cleaned) > 20:
                    endorsements.append(cleaned[:300])

        if endorsements:
            return ' | '.join(endorsements[:3])

        return None

    def _extract_conditions(self, text: str) -> Optional[str]:
        """Extract policy conditions"""
        patterns = [
            r'(?:conditions?|terms?)[:\s]*([^\n]{50,500})',
            r'(?:subject\s*to)[:\s]*([^\n]{50,300})'
        ]

        conditions = []
        for pattern in patterns:
            matches = re.findall(pattern, text, re.IGNORECASE | re.DOTALL)
            for match in matches:
                cleaned = re.sub(r'\s+', ' ', match.strip())
                if len(cleaned) > 20:
                    conditions.append(cleaned[:300])

        if conditions:
            return ' | '.join(conditions[:2])

        return None

    def _extract_claims(self, text: str) -> Optional[List[Dict]]:
        """Extract claims information if present"""
        claims = []

        # Look for claims references
        claim_patterns = [
            r'(?:claim\s*(?:ref|number|no\.?)[:\s]*)([A-Z0-9]{6,})',
            r'(?:claim\s*date)[:\s]*(\d{1,2}[/-]\d{1,2}[/-]\d{2,4})',
            r'(?:claim\s*(?:amount|value))[:\s]*£([0-9,]+)'
        ]

        # This is a simplified extraction - real claims data often in separate documents
        for pattern in claim_patterns:
            matches = re.findall(pattern, text, re.IGNORECASE)
            if matches:
                # Create placeholder claim entry
                claims.append({
                    'reference': matches[0] if matches else None,
                    'status': 'historical',
                    'note': 'Claim reference found in policy document'
                })
                break

        return claims if claims else None

    def _normalize_date(self, date_string: str) -> Optional[str]:
        """Normalize date to ISO format YYYY-MM-DD"""
        for separator in ['/', '-']:
            pattern = f'(\\d{{1,2}}){separator}(\\d{{1,2}}){separator}(\\d{{2,4}})'
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
        """Determine policy status based on end date"""
        if not end_date:
            return 'unknown'

        try:
            expiry = datetime.fromisoformat(end_date).date()
            today = datetime.now().date()

            if expiry < today:
                return 'expired'
            elif (expiry - today).days <= 60:  # Expiring within 60 days
                return 'expiring_soon'
            else:
                return 'active'
        except:
            return 'unknown'

    def _calculate_confidence(self, policy: Dict) -> float:
        """Calculate extraction confidence score"""
        score = 0.0
        max_score = 7.0

        if policy.get('insurer'):
            score += 1.0
        if policy.get('policy_number'):
            score += 1.5
        if policy.get('cover_type'):
            score += 1.0
        if policy.get('sum_insured'):
            score += 1.0
        if policy.get('start_date'):
            score += 1.0
        if policy.get('end_date'):
            score += 1.0
        if policy.get('broker'):
            score += 0.5

        return round(score / max_score, 2)

    def _find_snippet(self, text: str, search_term: Optional[str], context: int = 50) -> Optional[str]:
        """Find snippet of text containing search term"""
        if not search_term:
            return None

        match = re.search(re.escape(search_term), text, re.IGNORECASE)
        if match:
            start = max(0, match.start() - context)
            end = min(len(text), match.end() + context)
            return text[start:end].strip()

        return None
