"""
Lease Extractor - Deep parsing of lease documents
Extracts: unit_ref, lessees, term, dates, ground rent, apportionment
"""

import re
from datetime import datetime, timedelta
from typing import List, Optional, Dict, Any
from pathlib import Path

from ..types import LeaseData


class LeaseExtractor:
    """Extract lease data from PDF/text content"""

    def __init__(self):
        self.unit_patterns = [
            r'(?:Flat|Apartment|Unit)\s*(?:No\.?\s*)?(\d+[A-Z]?)',
            r'(?:Flat|Apartment|Unit)\s*([A-Z]\d*)',
            r'(\d+[A-Z]?)\s+(?:.*?)\s+(?:Road|Street|Square|Gardens|Avenue)',
        ]

        self.term_patterns = [
            r'(?:Term|Demise)[\s:]+(\d+)\s*years?\s+from\s+(\d{1,2}[\/\s]\w+[\/\s]\d{4})',
            r'(?:Term|Demise)[\s:]+(\d+)\s*years?\s+commencing\s+(\d{1,2}[\/\s]\w+[\/\s]\d{4})',
            r'for\s+a\s+term\s+of\s+(\d+)\s*years?\s+from\s+(\d{1,2}[\/\s]\w+[\/\s]\d{4})',
        ]

        self.ground_rent_patterns = [
            r'ground\s+rent[\s:]+peppercorn',
            r'peppercorn\s+(?:rent|if demanded)',
            r'ground\s+rent[\s:]+£?(\d+(?:,\d{3})*(?:\.\d{2})?)\s*(?:per annum|p\.?a\.?|yearly)?',
        ]

        self.apportionment_patterns = [
            r'apportionment[\s:]+(\d+(?:\.\d+)?)\s*%',
            r'service\s+charge[\s:]+(\d+(?:\.\d+)?)\s*%',
            r'(\d+(?:\.\d+)?)\s*%\s+(?:of|share)',
        ]

    def extract(self, text: str, filename: str) -> List[LeaseData]:
        """Extract lease data from document text"""
        leases = []

        # Extract unit reference
        unit_ref = self._extract_unit_ref(text)
        if not unit_ref:
            return leases  # Can't proceed without unit

        # Extract lessees (parties)
        lessees = self._extract_lessees(text)

        # Extract lessor
        lessor = self._extract_lessor(text)

        # Extract term and dates
        term_years, start_date, end_date = self._extract_term_and_dates(text)

        # Extract ground rent
        ground_rent_text = self._extract_ground_rent(text)

        # Extract apportionment
        apportionment_pct = self._extract_apportionment(text)

        # Extract rent review period
        rent_review_period = self._extract_rent_review_period(text)

        # Extract lease clauses
        clauses = self._extract_clauses(text)

        # Calculate confidence
        confidence = self._calculate_confidence(
            unit_ref, lessees, term_years, start_date, ground_rent_text
        )

        lease = LeaseData(
            unit_ref=unit_ref,
            lessee_names=lessees,
            lessor_name=lessor,
            term_years=term_years,
            start_date=start_date,
            end_date=end_date,
            ground_rent_text=ground_rent_text,
            apportionment_pct=apportionment_pct,
            rent_review_period=rent_review_period,
            clauses=clauses,
            source_file=filename,
            confidence=confidence
        )

        leases.append(lease)
        return leases

    def _extract_unit_ref(self, text: str) -> Optional[str]:
        """Extract unit reference from text"""
        # Try each pattern
        for pattern in self.unit_patterns:
            match = re.search(pattern, text, re.IGNORECASE)
            if match:
                unit = match.group(1).strip()
                # Normalize
                return self._normalize_unit_ref(unit)

        return None

    def _normalize_unit_ref(self, unit: str) -> str:
        """Normalize unit reference"""
        # Remove leading zeros: "001" -> "1"
        unit = re.sub(r'^0+(\d)', r'\1', unit)

        # Uppercase letters
        unit = unit.upper()

        return unit

    def _extract_lessees(self, text: str) -> List[str]:
        """Extract lessee names from parties section"""
        lessees = []

        # Look for "Lessee" or "Tenant" section
        lessee_section_pattern = r'(?:Lessee|Tenant)[\s:]+(.+?)(?:Lessor|Landlord|\n\n)'
        match = re.search(lessee_section_pattern, text, re.IGNORECASE | re.DOTALL)

        if match:
            section = match.group(1)

            # Extract names (Surname, Forename format or Forename Surname)
            name_patterns = [
                r'([A-Z][a-z]+),\s*([A-Z][a-z]+(?:\s+[A-Z][a-z]+)?)',  # Surname, Forename
                r'([A-Z][a-z]+)\s+([A-Z][a-z]+)',  # Forename Surname
            ]

            for pattern in name_patterns:
                matches = re.finditer(pattern, section)
                for m in matches:
                    if len(m.groups()) == 2:
                        # Format as "Surname, Forename"
                        if ',' in m.group(0):
                            name = f"{m.group(1)}, {m.group(2)}"
                        else:
                            name = f"{m.group(2)}, {m.group(1)}"
                        lessees.append(name)

        return list(set(lessees))  # Dedupe

    def _extract_term_and_dates(self, text: str) -> tuple[Optional[int], Optional[str], Optional[str]]:
        """Extract lease term and dates"""
        term_years = None
        start_date = None
        end_date = None

        for pattern in self.term_patterns:
            match = re.search(pattern, text, re.IGNORECASE)
            if match:
                term_years = int(match.group(1))
                date_str = match.group(2)

                # Parse start date
                start_date = self._parse_date(date_str)

                # Calculate end date
                if start_date and term_years:
                    try:
                        start_dt = datetime.fromisoformat(start_date)
                        end_dt = start_dt + timedelta(days=term_years * 365)
                        # Set to last day of year
                        end_dt = end_dt.replace(month=12, day=31)
                        end_date = end_dt.date().isoformat()
                    except:
                        pass

                break

        return term_years, start_date, end_date

    def _parse_date(self, date_str: str) -> Optional[str]:
        """Parse date string to ISO format"""
        # Try various formats
        formats = [
            '%d %B %Y',      # 1 January 1992
            '%d %b %Y',      # 1 Jan 1992
            '%d/%m/%Y',      # 01/01/1992
            '%d-%m-%Y',      # 01-01-1992
        ]

        date_str = date_str.strip()

        for fmt in formats:
            try:
                dt = datetime.strptime(date_str, fmt)
                return dt.date().isoformat()
            except:
                continue

        return None

    def _extract_ground_rent(self, text: str) -> Optional[str]:
        """Extract ground rent text"""
        for pattern in self.ground_rent_patterns:
            match = re.search(pattern, text, re.IGNORECASE)
            if match:
                if 'peppercorn' in match.group(0).lower():
                    return 'peppercorn'
                elif len(match.groups()) > 0:
                    amount = match.group(1)
                    return f"£{amount} pa"

        return None

    def _extract_apportionment(self, text: str) -> Optional[float]:
        """Extract service charge apportionment percentage"""
        for pattern in self.apportionment_patterns:
            match = re.search(pattern, text, re.IGNORECASE)
            if match:
                try:
                    return float(match.group(1))
                except:
                    pass

        return None

    def _extract_lessor(self, text: str) -> Optional[str]:
        """Extract lessor (landlord) name from text"""
        # Look for "Lessor" or "Landlord" section
        lessor_pattern = r'(?:Lessor|Landlord)[\s:]+(.+?)(?:Lessee|Tenant|of\s+the\s+(?:second|other)\s+part|\n\n)'
        match = re.search(lessor_pattern, text, re.IGNORECASE | re.DOTALL)

        if match:
            lessor_text = match.group(1).strip()
            # Extract first reasonable name (up to 100 chars)
            lessor = lessor_text[:100].strip()
            return lessor if lessor else None

        return None

    def _extract_rent_review_period(self, text: str) -> Optional[int]:
        """Extract rent review period in years"""
        patterns = [
            r'rent\s+review[\s:]+(?:every\s+)?(\d+)\s*years?',
            r'reviewed\s+every\s+(\d+)\s*years?',
            r'(\d+)\s*(?:year|yearly)\s+rent\s+review',
        ]

        for pattern in patterns:
            match = re.search(pattern, text, re.IGNORECASE)
            if match:
                try:
                    return int(match.group(1))
                except:
                    pass

        return None

    def _extract_clauses(self, text: str) -> List[Dict[str, Any]]:
        """Extract lease clauses with clause numbers and text"""
        clauses = []

        # Pattern to match numbered clauses (e.g., "1.1", "2.3.4", "Clause 5")
        clause_patterns = [
            r'(?:^|\n)\s*(\d+(?:\.\d+)*)\s+([A-Z][^\n]{20,200})',  # Numbered clauses
            r'(?:^|\n)\s*Clause\s+(\d+(?:\.\d+)*)[:\s]+([^\n]{20,200})',  # "Clause X:" format
        ]

        for pattern in clause_patterns:
            matches = re.finditer(pattern, text, re.MULTILINE)
            for match in matches:
                clause_number = match.group(1)
                clause_text = match.group(2).strip()

                # Skip if looks like a heading or too short
                if len(clause_text) < 20:
                    continue

                # Categorize clause by keywords
                clause_category = self._categorize_clause(clause_text)

                clauses.append({
                    'clause_number': clause_number,
                    'clause_text': clause_text[:500],  # Limit length
                    'clause_category': clause_category,
                })

        return clauses[:50]  # Limit to 50 clauses max

    def _categorize_clause(self, text: str) -> str:
        """Categorize clause by content"""
        text_lower = text.lower()

        if any(word in text_lower for word in ['rent', 'payment', 'ground rent']):
            return 'rent'
        elif any(word in text_lower for word in ['repair', 'maintain', 'maintenance']):
            return 'repair'
        elif any(word in text_lower for word in ['insurance', 'insure']):
            return 'insurance'
        elif any(word in text_lower for word in ['service charge', 'apportionment']):
            return 'service_charge'
        elif any(word in text_lower for word in ['use', 'user covenant', 'permitted']):
            return 'use'
        elif any(word in text_lower for word in ['alterations', 'alter']):
            return 'alterations'
        elif any(word in text_lower for word in ['assignment', 'sublet', 'subletting']):
            return 'assignment'
        elif any(word in text_lower for word in ['forfeiture', 'termination', 're-entry']):
            return 'forfeiture'
        elif any(word in text_lower for word in ['covenant', 'obligation']):
            return 'covenant'
        else:
            return 'other'

    def _calculate_confidence(
        self,
        unit_ref: Optional[str],
        lessees: List[str],
        term_years: Optional[int],
        start_date: Optional[str],
        ground_rent: Optional[str]
    ) -> float:
        """Calculate confidence score 0-1"""
        score = 0.0

        if unit_ref:
            score += 0.3
        if lessees:
            score += 0.2
        if term_years:
            score += 0.2
        if start_date:
            score += 0.2
        if ground_rent:
            score += 0.1

        return min(1.0, score)
