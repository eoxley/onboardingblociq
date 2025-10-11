"""
BlocIQ Onboarder - Lease Document Extractor
Extracts comprehensive lease information from individual lease documents and tenancy schedules
"""

import re
import uuid
from typing import Dict, List, Optional
from datetime import datetime, timedelta


class LeaseExtractor:
    """Extracts lease information from lease documents and tenancy schedules"""

    def __init__(self):
        pass

    def extract(self, file_data: Dict, building_id: str, unit_id: Optional[str] = None, leaseholder_id: Optional[str] = None) -> Optional[Dict]:
        """
        Extract lease data from parsed document

        Args:
            file_data: Parsed file dictionary
            building_id: UUID of the building
            unit_id: UUID of the unit (if known)
            leaseholder_id: UUID of the leaseholder (if known)

        Returns:
            Dict with lease record, or None
        """
        file_name = file_data.get('file_name', '')
        full_text = file_data.get('full_text', '')

        if not full_text:
            # Try to extract from data field (for Excel files)
            full_text = self._extract_text_from_data(file_data)

        if not full_text or len(full_text) < 200:
            return None

        # Extract lease details
        lessor = self._extract_lessor(full_text)
        leaseholder_name = self._extract_leaseholder_name(full_text)

        # Extract dates
        lease_start_date = self._extract_lease_start_date(full_text)
        original_term_years = self._extract_original_term(full_text)
        lease_expiry_date = self._calculate_expiry_date(lease_start_date, original_term_years, full_text)

        # Extract financial terms
        ground_rent = self._extract_ground_rent(full_text)
        service_charge_amount = self._extract_service_charge(full_text)
        ground_rent_review_frequency = self._extract_review_frequency(full_text)

        # Extract clauses
        major_clauses = self._extract_major_clauses(full_text)
        covenants = self._extract_covenants(full_text)

        # Extract property details
        demise_description = self._extract_demise_description(full_text)

        # Build lease record
        lease = {
            'id': str(uuid.uuid4()),
            'building_id': building_id,
            'unit_id': unit_id,
            'leaseholder_id': leaseholder_id,
            'lessor': lessor,
            'leaseholder_name': leaseholder_name,
            'lease_start_date': lease_start_date,
            'original_term_years': original_term_years,
            'lease_expiry_date': lease_expiry_date,
            'ground_rent': ground_rent,
            'service_charge_amount': service_charge_amount,
            'ground_rent_review_frequency': ground_rent_review_frequency,
            'major_clauses': major_clauses,
            'covenants': covenants,
            'demise_description': demise_description,
            'lease_document_url': None,  # Will be set when uploaded to storage
        }

        # Calculate confidence
        confidence = self._calculate_confidence(lease)

        return {
            'lease': lease,
            'metadata': {
                'extracted_from': file_name,
                'extraction_confidence': confidence
            }
        }

    def _extract_text_from_data(self, file_data: Dict) -> str:
        """Extract text from data field if full_text is missing"""
        content_parts = []

        if 'data' in file_data:
            data = file_data['data']

            # Handle Excel files
            if isinstance(data, dict):
                for sheet_name, sheet_data in data.items():
                    if isinstance(sheet_data, dict) and 'raw_data' in sheet_data:
                        for row in sheet_data['raw_data'][:200]:  # First 200 rows
                            if isinstance(row, (list, dict)):
                                content_parts.append(str(row))

            # Handle text data
            elif isinstance(data, str):
                content_parts.append(data)

        return ' '.join(content_parts)

    def _extract_lessor(self, text: str) -> Optional[str]:
        """Extract lessor (landlord) name"""
        patterns = [
            r'(?:LESSOR|LANDLORD|FREEHOLDER)[:\s]*([A-Z][A-Za-z\s&]+(?:Ltd|Limited|LLP|plc)?)',
            r'(?:granted by|demised by)[:\s]*([A-Z][A-Za-z\s&]+(?:Ltd|Limited|LLP|plc)?)',
            r'(?:between)\s+([A-Z][A-Za-z\s&]+(?:Ltd|Limited|LLP|plc)?)\s+(?:and|as lessor)',
        ]

        for pattern in patterns:
            match = re.search(pattern, text, re.IGNORECASE)
            if match:
                lessor = match.group(1).strip()
                if len(lessor) > 3 and lessor not in ['THE', 'AND', 'THIS']:
                    return lessor[:100]

        return None

    def _extract_leaseholder_name(self, text: str) -> Optional[str]:
        """Extract leaseholder (tenant) name"""
        patterns = [
            r'(?:LEASEHOLDER|TENANT|LESSEE)[:\s]*([A-Z][A-Za-z\s&]+(?:Ltd|Limited|LLP)?)',
            r'(?:demised to|granted to)[:\s]*([A-Z][A-Za-z\s&]+(?:Ltd|Limited|LLP)?)',
            r'(?:and)\s+([A-Z][A-Za-z\s&]+(?:Ltd|Limited|LLP)?)\s+(?:as lessee|as tenant)',
        ]

        for pattern in patterns:
            match = re.search(pattern, text, re.IGNORECASE)
            if match:
                leaseholder = match.group(1).strip()
                if len(leaseholder) > 3 and leaseholder not in ['THE', 'AND', 'THIS']:
                    return leaseholder[:100]

        return None

    def _extract_lease_start_date(self, text: str) -> Optional[str]:
        """Extract lease start date (inception date)"""
        patterns = [
            r'(?:dated|date of lease|lease dated|granted on|demised on)[:\s]*(\d{1,2}[\s\w]*\s+\w+\s+\d{2,4})',
            r'(?:commencement date|term commenced|term commences)[:\s]*(\d{1,2}[\s\w]*\s+\w+\s+\d{2,4})',
            r'(?:from)\s+(\d{1,2}[\s\w]*\s+\w+\s+\d{2,4})\s+(?:for a term)',
        ]

        for pattern in patterns:
            match = re.search(pattern, text, re.IGNORECASE)
            if match:
                date_str = match.group(1)
                normalized = self._normalize_date(date_str)
                if normalized:
                    return normalized

        # Try numeric format
        patterns_numeric = [
            r'(?:dated|date of lease|lease dated)[:\s]*(\d{1,2}[/-]\d{1,2}[/-]\d{2,4})',
            r'(?:commencement date)[:\s]*(\d{1,2}[/-]\d{1,2}[/-]\d{2,4})',
        ]

        for pattern in patterns_numeric:
            match = re.search(pattern, text, re.IGNORECASE)
            if match:
                date_str = match.group(1)
                normalized = self._normalize_date(date_str)
                if normalized:
                    return normalized

        return None

    def _extract_original_term(self, text: str) -> Optional[int]:
        """Extract original lease term in years"""
        patterns = [
            r'(?:term of|for a term of|granted for)\s+(\d+)\s+years?',
            r'(\d+)\s+years?\s+(?:from|commencing)',
            r'(?:term:?\s*)(\d+)\s+years?',
        ]

        for pattern in patterns:
            match = re.search(pattern, text, re.IGNORECASE)
            if match:
                try:
                    years = int(match.group(1))
                    if 50 <= years <= 999:  # Typical UK lease terms
                        return years
                except ValueError:
                    continue

        return None

    def _calculate_expiry_date(self, start_date: Optional[str], term_years: Optional[int], text: str) -> Optional[str]:
        """Calculate or extract lease expiry date"""
        # Try to find explicit expiry date first
        patterns = [
            r'(?:expiry date|expires on|expiring)[:\s]*(\d{1,2}[\s\w]*\s+\w+\s+\d{2,4})',
            r'(?:until|ending on)[:\s]*(\d{1,2}[\s\w]*\s+\w+\s+\d{2,4})',
        ]

        for pattern in patterns:
            match = re.search(pattern, text, re.IGNORECASE)
            if match:
                date_str = match.group(1)
                normalized = self._normalize_date(date_str)
                if normalized:
                    return normalized

        # Calculate from start date + term
        if start_date and term_years:
            try:
                start = datetime.fromisoformat(start_date)
                expiry = start + timedelta(days=365.25 * term_years)
                return expiry.date().isoformat()
            except:
                pass

        return None

    def _extract_ground_rent(self, text: str) -> Optional[float]:
        """Extract ground rent amount"""
        patterns = [
            r'(?:ground rent)[:\s]*£\s*([0-9,]+(?:\.[0-9]{2})?)\s*(?:per annum|pa|annually)?',
            r'(?:rent)[:\s]*£\s*([0-9,]+(?:\.[0-9]{2})?)\s*(?:per annum|pa)',
            r'(?:annual rent)[:\s]*£\s*([0-9,]+(?:\.[0-9]{2})?)',
        ]

        for pattern in patterns:
            match = re.search(pattern, text, re.IGNORECASE)
            if match:
                value_str = match.group(1).replace(',', '')
                try:
                    value = float(value_str)
                    if 0 <= value <= 10000:  # Reasonable ground rent range
                        return value
                except ValueError:
                    continue

        return None

    def _extract_service_charge(self, text: str) -> Optional[float]:
        """Extract service charge amount"""
        patterns = [
            r'(?:service charge)[:\s]*£\s*([0-9,]+(?:\.[0-9]{2})?)\s*(?:per annum|pa|annually)?',
            r'(?:maintenance charge)[:\s]*£\s*([0-9,]+(?:\.[0-9]{2})?)',
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

    def _extract_review_frequency(self, text: str) -> Optional[str]:
        """Extract ground rent review frequency"""
        patterns = [
            r'(?:review|reviewed)\s+(?:every\s+)?(\d+)\s+years?',
            r'(\d+)[-\s]?yearly?\s+review',
            r'(?:every|each)\s+(\d+)(?:th|st|nd|rd)\s+anniversary',
        ]

        for pattern in patterns:
            match = re.search(pattern, text, re.IGNORECASE)
            if match:
                years = match.group(1)
                return f"{years} years"

        # Check for specific frequencies
        if re.search(r'\bannual(?:ly)?\s+review\b', text, re.IGNORECASE):
            return "1 year"
        elif re.search(r'\b(?:every|each)\s+year\b', text, re.IGNORECASE):
            return "1 year"

        return None

    def _extract_major_clauses(self, text: str) -> Optional[str]:
        """Extract major lease clauses"""
        clauses = []

        # Look for common clause headings
        clause_keywords = [
            'forfeiture', 'break clause', 'right to manage', 'enfranchisement',
            'alterations', 'subletting', 'assignment', 'insurance'
        ]

        for keyword in clause_keywords:
            pattern = rf'(?:{keyword})[:\s]*([^\n]{{50,300}})'
            match = re.search(pattern, text, re.IGNORECASE)
            if match:
                clause_text = match.group(1).strip()
                clauses.append(f"{keyword.title()}: {clause_text[:200]}")

        if clauses:
            return ' | '.join(clauses[:5])  # Top 5 clauses

        return None

    def _extract_covenants(self, text: str) -> Optional[str]:
        """Extract leaseholder covenants"""
        covenants = []

        # Look for covenant sections
        covenant_patterns = [
            r'(?:lessee covenants?)[:\s]*([^\n]{{50,300}})',
            r'(?:tenant(?:\'s)? obligations?)[:\s]*([^\n]{{50,300}})',
            r'(?:covenants by the lessee)[:\s]*([^\n]{{50,300}})',
        ]

        for pattern in covenant_patterns:
            matches = re.findall(pattern, text, re.IGNORECASE)
            for match in matches[:3]:  # First 3 matches
                covenant_text = match.strip()
                if len(covenant_text) > 20:
                    covenants.append(covenant_text[:200])

        if covenants:
            return ' | '.join(covenants)

        return None

    def _extract_demise_description(self, text: str) -> Optional[str]:
        """Extract property demise description"""
        patterns = [
            r'(?:demise|demised premises?)[:\s]*([^\n]{{50,300}})',
            r'(?:property|premises? comprised)[:\s]*([^\n]{{50,300}})',
            r'(?:being)[:\s]*((?:flat|apartment|unit)\s+[^\n]{{20,200}})',
        ]

        for pattern in patterns:
            match = re.search(pattern, text, re.IGNORECASE)
            if match:
                description = match.group(1).strip()
                if len(description) > 10:
                    return description[:300]

        return None

    def _normalize_date(self, date_string: str) -> Optional[str]:
        """Normalize date to ISO format YYYY-MM-DD"""
        # Try various date formats

        # Format: "1st January 2000" or "1 January 2000"
        month_names = {
            'january': 1, 'february': 2, 'march': 3, 'april': 4,
            'may': 5, 'june': 6, 'july': 7, 'august': 8,
            'september': 9, 'october': 10, 'november': 11, 'december': 12
        }

        pattern = r'(\d{1,2})(?:st|nd|rd|th)?\s+(\w+)\s+(\d{2,4})'
        match = re.match(pattern, date_string, re.IGNORECASE)
        if match:
            day = int(match.group(1))
            month_name = match.group(2).lower()
            year = match.group(3)

            if month_name in month_names:
                month = month_names[month_name]
                if len(year) == 2:
                    year = f"20{year}" if int(year) < 50 else f"19{year}"

                try:
                    date_obj = datetime(int(year), month, day)
                    return date_obj.date().isoformat()
                except ValueError:
                    pass

        # Format: "01/01/2000" or "01-01-2000"
        for sep in ['/', '-']:
            pattern = f'(\\d{{1,2}}){sep}(\\d{{1,2}}){sep}(\\d{{2,4}})'
            match = re.match(pattern, date_string)
            if match:
                day, month, year = match.groups()
                if len(year) == 2:
                    year = f"20{year}" if int(year) < 50 else f"19{year}"

                try:
                    date_obj = datetime(int(year), int(month), int(day))
                    return date_obj.date().isoformat()
                except ValueError:
                    continue

        return None

    def _calculate_confidence(self, lease: Dict) -> float:
        """Calculate extraction confidence score"""
        score = 0.0
        max_score = 9.0

        if lease.get('lessor'):
            score += 1.0
        if lease.get('leaseholder_name'):
            score += 1.0
        if lease.get('lease_start_date'):
            score += 1.5
        if lease.get('original_term_years'):
            score += 1.5
        if lease.get('lease_expiry_date'):
            score += 1.0
        if lease.get('ground_rent'):
            score += 1.0
        if lease.get('service_charge_amount'):
            score += 1.0
        if lease.get('ground_rent_review_frequency'):
            score += 0.5
        if lease.get('major_clauses'):
            score += 0.5

        return round(score / max_score, 2)
