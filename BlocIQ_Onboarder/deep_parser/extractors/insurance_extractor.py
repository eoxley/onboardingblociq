"""
Insurance Extractor - Deep parsing of insurance schedules
Extracts: provider, policy_number, period dates, amounts, status
"""

import re
from datetime import datetime
from typing import List, Optional, Dict, Any

from ..types import InsurancePolicyData


class InsuranceExtractor:
    """Extract insurance policy data from schedules and documents"""

    def __init__(self):
        self.providers = [
            'Allianz', 'Aviva', 'Zurich', 'Arch', 'QBE', 'RSA',
            'Hiscox', 'NFU', 'Camberford', 'AIG', 'Ecclesiastical',
            'LV=', 'Direct Line', 'AXA', 'Gallagher', 'Marsh',
            'AON', 'Willis', 'Howden', 'Arthur J. Gallagher'
        ]

        # Strict alphanumeric policy number pattern
        self.policy_number_pattern = r'\b[A-Z]{2,4}[-/]?\d{6,10}[A-Z]{0,3}\b'

        self.period_patterns = [
            r'(\d{2}[/\-]\d{2}[/\-]\d{4})\s*[-–to]+\s*(\d{2}[/\-]\d{2}[/\-]\d{4})',
            r'from\s+(\d{1,2}\s+\w+\s+\d{4})\s+to\s+(\d{1,2}\s+\w+\s+\d{4})',
            r'period[:\s]+(\d{1,2}\s+\w+\s+\d{4})\s+to\s+(\d{1,2}\s+\w+\s+\d{4})',
        ]

        self.amount_patterns = [
            r'sum\s+insured[:\s]+£?([\d,]+(?:\.\d{2})?)',
            r'cover[:\s]+£?([\d,]+(?:\.\d{2})?)',
            r'premium[:\s]+£?([\d,]+(?:\.\d{2})?)',
        ]

        self.policy_types = {
            'buildings': ['buildings', 'property damage', 'block policy'],
            'terrorism': ['terrorism', 'pool re'],
            'engineering': ['engineering', 'boiler', 'pressure vessel', 'lift'],
            'liability': ['liability', 'public liability', 'employers'],
            'legal': ['legal expenses', 'directors'],
        }

    def extract(self, text: str, filename: str) -> List[InsurancePolicyData]:
        """Extract insurance policies from document text"""
        policies = []

        # Try to extract a single comprehensive policy
        policy = self._extract_single_policy(text, filename)
        if policy:
            policies.append(policy)
        else:
            # Try to extract multiple policies from schedule
            policies = self._extract_multiple_policies(text, filename)

        return policies

    def _extract_single_policy(self, text: str, filename: str) -> Optional[InsurancePolicyData]:
        """Extract single policy from document"""

        # Detect provider
        provider = self._find_provider(text)

        # Extract policy number
        policy_numbers = re.findall(self.policy_number_pattern, text)
        policy_number = policy_numbers[0] if policy_numbers else None

        # Detect policy type
        policy_type = self._detect_policy_type(text, filename)

        # Extract period dates
        period_start, period_end = self._extract_period(text)

        if not period_start and not period_end and not policy_number:
            return None  # Not enough data

        # Extract amounts
        sum_insured = self._extract_sum_insured(text)
        premium = self._extract_premium(text)

        # Compute status
        status = self._compute_status(period_start, period_end)

        # Calculate confidence
        confidence = self._calculate_confidence(
            provider, policy_number, period_start, period_end, sum_insured
        )

        return InsurancePolicyData(
            provider=provider,
            policy_number=policy_number,
            policy_type=policy_type,
            period_start=period_start,
            period_end=period_end,
            sum_insured=sum_insured,
            premium=premium,
            status=status,
            source_file=filename,
            confidence=confidence
        )

    def _extract_multiple_policies(self, text: str, filename: str) -> List[InsurancePolicyData]:
        """Extract multiple policies from insurance schedule"""
        policies = []

        # Split into sections by policy type
        lines = text.split('\n')

        current_type = None
        current_section = []

        for line in lines:
            # Check if line indicates new policy type
            line_type = self._detect_policy_type(line, filename)
            if line_type and line_type != current_type:
                # Process previous section
                if current_section:
                    policy = self._extract_from_section(
                        '\n'.join(current_section),
                        current_type,
                        filename
                    )
                    if policy:
                        policies.append(policy)

                current_type = line_type
                current_section = [line]
            else:
                current_section.append(line)

        # Process last section
        if current_section:
            policy = self._extract_from_section(
                '\n'.join(current_section),
                current_type,
                filename
            )
            if policy:
                policies.append(policy)

        return policies

    def _extract_from_section(
        self,
        text: str,
        policy_type: Optional[str],
        filename: str
    ) -> Optional[InsurancePolicyData]:
        """Extract policy from text section"""

        provider = self._find_provider(text)
        policy_numbers = re.findall(self.policy_number_pattern, text)
        policy_number = policy_numbers[0] if policy_numbers else None

        period_start, period_end = self._extract_period(text)
        sum_insured = self._extract_sum_insured(text)
        premium = self._extract_premium(text)
        status = self._compute_status(period_start, period_end)

        if not policy_number and not period_start:
            return None

        confidence = self._calculate_confidence(
            provider, policy_number, period_start, period_end, sum_insured
        )

        return InsurancePolicyData(
            provider=provider,
            policy_number=policy_number,
            policy_type=policy_type,
            period_start=period_start,
            period_end=period_end,
            sum_insured=sum_insured,
            premium=premium,
            status=status,
            source_file=filename,
            confidence=confidence
        )

    def _find_provider(self, text: str) -> Optional[str]:
        """Find insurance provider in text"""
        text_lower = text.lower()

        for provider in self.providers:
            if provider.lower() in text_lower:
                return provider

        return None

    def _detect_policy_type(self, text: str, filename: str) -> Optional[str]:
        """Detect policy type from text or filename"""
        text_lower = (text + ' ' + filename).lower()

        for type_name, keywords in self.policy_types.items():
            for keyword in keywords:
                if keyword in text_lower:
                    return type_name

        # Default to 'general' if nothing specific found
        if 'insurance' in text_lower or 'policy' in text_lower:
            return 'general'

        return None

    def _extract_period(self, text: str) -> tuple[Optional[str], Optional[str]]:
        """Extract policy period dates"""
        for pattern in self.period_patterns:
            match = re.search(pattern, text, re.IGNORECASE)
            if match:
                start_str = match.group(1)
                end_str = match.group(2)

                start_date = self._parse_date(start_str)
                end_date = self._parse_date(end_str)

                return start_date, end_date

        return None, None

    def _parse_date(self, date_str: str) -> Optional[str]:
        """Parse date string to ISO format"""
        formats = [
            '%d/%m/%Y',      # 01/10/2025
            '%d-%m-%Y',      # 01-10-2025
            '%d %B %Y',      # 1 October 2025
            '%d %b %Y',      # 1 Oct 2025
        ]

        date_str = date_str.strip()

        for fmt in formats:
            try:
                dt = datetime.strptime(date_str, fmt)
                return dt.date().isoformat()
            except:
                continue

        return None

    def _extract_sum_insured(self, text: str) -> Optional[float]:
        """Extract sum insured amount"""
        for pattern in self.amount_patterns:
            if 'sum insured' in pattern or 'cover' in pattern:
                match = re.search(pattern, text, re.IGNORECASE)
                if match:
                    amount_str = match.group(1).replace(',', '')
                    try:
                        return float(amount_str)
                    except:
                        pass

        return None

    def _extract_premium(self, text: str) -> Optional[float]:
        """Extract premium amount"""
        for pattern in self.amount_patterns:
            if 'premium' in pattern:
                match = re.search(pattern, text, re.IGNORECASE)
                if match:
                    amount_str = match.group(1).replace(',', '')
                    try:
                        return float(amount_str)
                    except:
                        pass

        return None

    def _compute_status(
        self,
        start: Optional[str],
        end: Optional[str]
    ) -> str:
        """
        Compute policy status:
        - Active if now ∈ [start, end]
        - Expired if end < now
        - Unknown otherwise
        """
        if not end:
            return "Unknown"

        try:
            today = datetime.now().date()
            end_date = datetime.fromisoformat(end).date()

            if end_date >= today:
                # Check if started
                if start:
                    start_date = datetime.fromisoformat(start).date()
                    if start_date <= today:
                        return "Active"
                    else:
                        return "Unknown"  # Future policy
                else:
                    # No start date, but end is future
                    return "Active"
            else:
                return "Expired"
        except:
            pass

        return "Unknown"

    def _calculate_confidence(
        self,
        provider: Optional[str],
        policy_number: Optional[str],
        period_start: Optional[str],
        period_end: Optional[str],
        sum_insured: Optional[float]
    ) -> float:
        """Calculate confidence score 0-1"""
        score = 0.0

        if provider:
            score += 0.15
        if policy_number:
            score += 0.25
        if period_start:
            score += 0.25
        if period_end:
            score += 0.25
        if sum_insured:
            score += 0.10

        return min(1.0, score)
