"""
Compliance Extractor - Deep parsing of compliance certificates
Extracts: category, name, dates, status
"""

import re
from datetime import datetime, timedelta
from typing import List, Optional, Dict, Any

from ..types import ComplianceAssetData


class ComplianceExtractor:
    """Extract compliance asset data from certificates and reports"""

    def __init__(self):
        self.categories = {
            'Fire Safety': [
                'FRA', 'Fire Risk Assessment', 'Fire Door', 'Fire Alarm',
                'Emergency Lighting', 'AOV', 'Smoke Control', 'Sprinkler',
                'Dry Riser', 'Wet Riser', 'Fire Extinguisher', 'Fire Safety'
            ],
            'Electrical': [
                'EICR', 'Electrical Installation', 'Condition Report',
                'PAT', 'Portable Appliance', 'Lightning Protection',
                'Electrical Safety', 'Fixed Wire'
            ],
            'Water Safety': [
                'Legionella', 'Water Hygiene', 'Water Risk Assessment',
                'TMV', 'Thermostatic Mixing Valve', 'Water Safety',
                'Water Temperature', 'Water Sampling'
            ],
            'Lifts': [
                'LOLER', 'Lift Inspection', 'Thorough Examination',
                'Lift Maintenance', 'Elevator', 'Passenger Lift'
            ],
            'Gas Safety': [
                'Gas Safety', 'Gas Certificate', 'CP12', 'Boiler',
                'Gas Appliance', 'Landlord Gas Safety'
            ],
            'Asbestos': [
                'Asbestos', 'ACM', 'Asbestos Survey', 'Asbestos Register',
                'Asbestos Management'
            ],
        }

        self.date_patterns = [
            r'(?:date|inspected|tested|carried out)[:\s]+(\d{1,2}[/\-]\d{1,2}[/\-]\d{4})',
            r'(\d{1,2}[/\-]\d{1,2}[/\-]\d{4})',
            r'(\d{1,2}\s+\w+\s+\d{4})',
        ]

        self.next_due_patterns = [
            r'next\s+(?:due|inspection|test)[:\s]+(\d{1,2}[/\-]\d{1,2}[/\-]\d{4})',
            r'due\s+date[:\s]+(\d{1,2}[/\-]\d{1,2}[/\-]\d{4})',
            r'valid\s+until[:\s]+(\d{1,2}[/\-]\d{1,2}[/\-]\d{4})',
            r'expires?[:\s]+(\d{1,2}[/\-]\d{1,2}[/\-]\d{4})',
        ]

        self.frequency_patterns = [
            r'(?:annual|yearly|12\s*months)',
            r'(?:6\s*months|bi-annual|six monthly)',
            r'(?:quarterly|3\s*months)',
            r'(?:monthly|1\s*month)',
        ]

    def extract(self, text: str, filename: str) -> List[ComplianceAssetData]:
        """Extract compliance assets from certificate text"""
        assets = []

        # Categorize
        category = self._categorize(text, filename)

        # Extract name
        name = self._extract_name(text, filename, category)

        # Extract dates
        last_inspection = self._extract_last_inspection(text)
        next_due = self._extract_next_due(text, last_inspection)

        # Extract location if present
        location = self._extract_location(text)

        # Extract responsible party
        responsible_party = self._extract_responsible_party(text)

        # Extract frequency
        frequency = self._extract_frequency(text)

        # Determine status (CONSERVATIVE)
        status = self._determine_status(last_inspection, next_due)

        # Calculate confidence
        confidence = self._calculate_confidence(
            category, name, last_inspection, next_due
        )

        asset = ComplianceAssetData(
            category=category,
            name=name,
            last_inspection=last_inspection,
            next_due=next_due,
            status=status,
            location=location,
            responsible_party=responsible_party,
            inspection_frequency=frequency,
            source_file=filename,
            confidence=confidence
        )

        assets.append(asset)
        return assets

    def _categorize(self, text: str, filename: str) -> str:
        """Categorize by keywords"""
        combined = (text + ' ' + filename).lower()

        for category, keywords in self.categories.items():
            for keyword in keywords:
                if keyword.lower() in combined:
                    return category

        return 'General'

    def _extract_name(self, text: str, filename: str, category: str) -> str:
        """Extract asset name"""
        # Try to find specific name from keywords
        combined = (text + ' ' + filename).lower()

        if category in self.categories:
            for keyword in self.categories[category]:
                if keyword.lower() in combined:
                    return keyword

        # Fallback to category
        return category

    def _extract_last_inspection(self, text: str) -> Optional[str]:
        """Extract last inspection date"""
        # Look for explicit "date" or "inspected" keywords first
        for pattern in self.date_patterns:
            if 'date' in pattern or 'inspected' in pattern or 'tested' in pattern or 'carried out' in pattern:
                match = re.search(pattern, text, re.IGNORECASE)
                if match:
                    date = self._parse_date(match.group(1))
                    if date:
                        return date

        # If not found, look for any date in first 500 chars
        first_section = text[:500]
        dates = re.findall(r'\d{1,2}[/\-]\d{1,2}[/\-]\d{4}', first_section)
        if dates:
            date = self._parse_date(dates[0])
            if date:
                return date

        return None

    def _extract_next_due(
        self,
        text: str,
        last_inspection: Optional[str]
    ) -> Optional[str]:
        """Extract next due date"""
        # Look for explicit next due keywords
        for pattern in self.next_due_patterns:
            match = re.search(pattern, text, re.IGNORECASE)
            if match:
                date = self._parse_date(match.group(1))
                if date:
                    return date

        # If last inspection exists and frequency detected, calculate
        if last_inspection:
            frequency_months = self._detect_frequency_months(text)
            if frequency_months:
                try:
                    last_dt = datetime.fromisoformat(last_inspection)
                    next_dt = last_dt + timedelta(days=frequency_months * 30)
                    return next_dt.date().isoformat()
                except:
                    pass

        return None

    def _detect_frequency_months(self, text: str) -> Optional[int]:
        """Detect inspection frequency in months"""
        text_lower = text.lower()

        if re.search(r'annual|yearly|12\s*months', text_lower):
            return 12
        elif re.search(r'6\s*months|bi-annual|six monthly', text_lower):
            return 6
        elif re.search(r'quarterly|3\s*months', text_lower):
            return 3
        elif re.search(r'monthly|1\s*month', text_lower):
            return 1

        return None

    def _extract_location(self, text: str) -> Optional[str]:
        """Extract location/address"""
        location_pattern = r'(?:location|address|property)[:\s]+(.+?)(?:\n|$)'
        match = re.search(location_pattern, text, re.IGNORECASE)
        if match:
            return match.group(1).strip()[:100]

        return None

    def _extract_responsible_party(self, text: str) -> Optional[str]:
        """Extract responsible party/contractor"""
        party_pattern = r'(?:contractor|inspector|company|carried out by)[:\s]+(.+?)(?:\n|$)'
        match = re.search(party_pattern, text, re.IGNORECASE)
        if match:
            return match.group(1).strip()[:100]

        return None

    def _extract_frequency(self, text: str) -> Optional[str]:
        """Extract inspection frequency as text"""
        text_lower = text.lower()

        if 'annual' in text_lower or 'yearly' in text_lower or '12 month' in text_lower:
            return '12 months'
        elif '6 month' in text_lower or 'bi-annual' in text_lower:
            return '6 months'
        elif 'quarterly' in text_lower or '3 month' in text_lower:
            return '3 months'
        elif 'monthly' in text_lower:
            return '1 month'

        return None

    def _parse_date(self, date_str: str) -> Optional[str]:
        """Parse date string to ISO format"""
        formats = [
            '%d/%m/%Y',      # 01/10/2025
            '%d-%m-%Y',      # 01-10-2025
            '%d %B %Y',      # 1 October 2025
            '%d %b %Y',      # 1 Oct 2025
            '%Y-%m-%d',      # 2025-10-01
        ]

        date_str = date_str.strip()

        for fmt in formats:
            try:
                dt = datetime.strptime(date_str, fmt)
                return dt.date().isoformat()
            except:
                continue

        return None

    def _determine_status(
        self,
        last_inspection: Optional[str],
        next_due: Optional[str]
    ) -> str:
        """
        CONSERVATIVE status determination:
        - Overdue ONLY if next_due < today
        - OK ONLY if last AND next exist and next_due >= today
        - Unknown otherwise (do NOT assume Overdue)
        """
        if not next_due:
            return "Unknown"

        try:
            today = datetime.now().date()
            next_date = datetime.fromisoformat(next_due).date()

            if next_date < today:
                return "Overdue"
            elif last_inspection:
                # Both last and next exist, and next is future
                return "OK"
            else:
                # Next is future but no last inspection
                return "Unknown"
        except:
            pass

        return "Unknown"

    def _calculate_confidence(
        self,
        category: Optional[str],
        name: str,
        last_inspection: Optional[str],
        next_due: Optional[str]
    ) -> float:
        """Calculate confidence score 0-1"""
        score = 0.0

        if category and category != 'General':
            score += 0.2
        if name:
            score += 0.2
        if last_inspection:
            score += 0.3
        if next_due:
            score += 0.3

        return min(1.0, score)
