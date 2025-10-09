"""
BlocIQ Building Safety Report Extractor
Extracts compliance data from fire risk assessments, BSC documents, and safety reports
"""

import re
import uuid
import json
from typing import Dict, List, Optional, Tuple
from datetime import datetime, timedelta


class SafetyReportExtractor:
    """Extract building safety and compliance data from OCR text"""

    def __init__(self, building_id: str, ocr_text: str, document_name: str):
        """
        Initialize extractor

        Args:
            building_id: UUID of the building
            ocr_text: Full OCR extracted text from safety document
            document_name: Original document filename
        """
        self.building_id = building_id
        self.text = ocr_text
        self.text_lower = ocr_text.lower() if ocr_text else ''
        self.document_name = document_name

    def extract_safety_report(self) -> Optional[Dict]:
        """
        Extract all safety report data

        Returns:
            Dictionary with safety report fields, or None if not a safety report
        """
        # Determine report type
        report_type = self._determine_report_type()
        if not report_type:
            return None

        report = {
            'id': str(uuid.uuid4()),
            'building_id': self.building_id,
            'report_type': report_type,
            'source_document_name': self.document_name
        }

        # Extract dates
        report['report_date'] = self._extract_report_date()
        report['completion_date'] = self._extract_completion_date()
        report['next_review_date'] = self._extract_next_review_date()

        # Extract responsible parties
        report['responsible_person'] = self._extract_responsible_person()
        report['principal_accountable_person'] = self._extract_principal_accountable_person()
        report['assessor_name'] = self._extract_assessor_name()
        report['assessor_company'] = self._extract_assessor_company()

        # Fire strategy (for FRAs)
        if report_type in ['fire_risk_assessment', 'fire_safety_case']:
            report['fire_strategy_date'] = self._extract_fire_strategy_date()
            report['fire_strategy_compliant'] = self._check_fire_strategy_compliance()

        # BSC details (for BSC documents)
        if report_type == 'building_safety_certificate':
            report['bsc_reference'] = self._extract_bsc_reference()
            report['bsc_status'] = self._extract_bsc_status()

        # Action items
        report['action_items'] = self._extract_action_items()

        # Risk rating
        report['overall_risk_rating'] = self._extract_risk_rating()
        report['compliance_status'] = self._determine_compliance_status()

        return report

    def _determine_report_type(self) -> Optional[str]:
        """Identify the type of safety report"""
        type_keywords = {
            'fire_risk_assessment': ['fire risk assessment', 'fra', 'fire safety audit'],
            'fire_safety_case': ['fire safety case', 'fire safety strategy'],
            'building_safety_certificate': ['building safety certificate', 'bsc'],
            'gateway_3': ['gateway 3', 'gateway three'],
            'eicr': ['electrical installation condition report', 'eicr'],
            'gas_safety': ['gas safety certificate', 'gas safety record', 'landlord gas safety']
        }

        for report_type, keywords in type_keywords.items():
            if any(keyword in self.text_lower for keyword in keywords):
                return report_type

        # Default to other if contains safety keywords
        safety_indicators = ['safety', 'compliance', 'inspection', 'assessment']
        if any(indicator in self.text_lower for indicator in safety_indicators):
            return 'other'

        return None

    def _extract_report_date(self) -> Optional[str]:
        """Extract report creation/issue date"""
        patterns = [
            r'(?:report date|date of report|issued)[:\s]+(\d{1,2}[/-]\d{1,2}[/-]\d{4})',
            r'(?:dated)[:\s]+(\d{1,2}(?:st|nd|rd|th)?\s+\w+\s+\d{4})',
            r'(\d{1,2}\s+(?:January|February|March|April|May|June|July|August|September|October|November|December)\s+\d{4})'
        ]

        for pattern in patterns:
            match = re.search(pattern, self.text, re.IGNORECASE)
            if match:
                return self._parse_date(match.group(1))

        return None

    def _extract_completion_date(self) -> Optional[str]:
        """Extract assessment completion date"""
        patterns = [
            r'(?:completed|completion date|assessment carried out)[:\s]+(\d{1,2}[/-]\d{1,2}[/-]\d{4})',
            r'(?:inspection date)[:\s]+(\d{1,2}[/-]\d{1,2}[/-]\d{4})'
        ]

        for pattern in patterns:
            match = re.search(pattern, self.text, re.IGNORECASE)
            if match:
                return self._parse_date(match.group(1))

        return None

    def _extract_next_review_date(self) -> Optional[str]:
        """Extract next review due date"""
        patterns = [
            r'(?:next review|review date|next assessment)[:\s]+(\d{1,2}[/-]\d{1,2}[/-]\d{4})',
            r'(?:valid until|expiry date)[:\s]+(\d{1,2}[/-]\d{1,2}[/-]\d{4})',
            r'(?:reviewed by|review by)[:\s]+(\d{1,2}(?:st|nd|rd|th)?\s+\w+\s+\d{4})'
        ]

        for pattern in patterns:
            match = re.search(pattern, self.text, re.IGNORECASE)
            if match:
                return self._parse_date(match.group(1))

        # If completion date found, assume annual review
        completion_date = self._extract_completion_date()
        if completion_date:
            try:
                comp_dt = datetime.strptime(completion_date, '%Y-%m-%d')
                next_review = comp_dt + timedelta(days=365)
                return next_review.strftime('%Y-%m-%d')
            except:
                pass

        return None

    def _extract_responsible_person(self) -> Optional[str]:
        """Extract responsible person name"""
        patterns = [
            r'(?:responsible person)[:\s]+([A-Z][a-z]+ [A-Z][a-z]+)',
            r'(?:duty holder)[:\s]+([A-Z][a-z]+ [A-Z][a-z]+)'
        ]

        for pattern in patterns:
            match = re.search(pattern, self.text)
            if match:
                return match.group(1)

        return None

    def _extract_principal_accountable_person(self) -> Optional[str]:
        """Extract Principal Accountable Person (BSA 2022)"""
        patterns = [
            r'(?:principal accountable person|pap)[:\s]+([A-Z][a-z]+ [A-Z][a-z]+)',
            r'(?:accountable person)[:\s]+([A-Z][a-z]+ [A-Z][a-z]+)'
        ]

        for pattern in patterns:
            match = re.search(pattern, self.text)
            if match:
                return match.group(1)

        return None

    def _extract_assessor_name(self) -> Optional[str]:
        """Extract assessor/surveyor name"""
        patterns = [
            r'(?:assessor|surveyor|inspector|carried out by)[:\s]+([A-Z][a-z]+ [A-Z][a-z]+)',
            r'(?:prepared by)[:\s]+([A-Z][a-z]+ [A-Z][a-z]+)'
        ]

        for pattern in patterns:
            match = re.search(pattern, self.text)
            if match:
                return match.group(1)

        return None

    def _extract_assessor_company(self) -> Optional[str]:
        """Extract assessing company name"""
        patterns = [
            r'(?:company|firm)[:\s]+([A-Z][a-zA-Z\s&]+(?:Ltd|Limited|LLP))',
            r'([A-Z][a-zA-Z\s&]+(?:Ltd|Limited|LLP))[^.]{0,50}?(?:fire risk|assessment)'
        ]

        for pattern in patterns:
            match = re.search(pattern, self.text)
            if match:
                return match.group(1).strip()

        return None

    def _extract_fire_strategy_date(self) -> Optional[str]:
        """Extract fire strategy review date"""
        pattern = r'(?:fire strategy|fire safety strategy)[^.]{0,100}?(\d{1,2}[/-]\d{1,2}[/-]\d{4})'
        match = re.search(pattern, self.text_lower, re.IGNORECASE)
        if match:
            return self._parse_date(match.group(1))
        return None

    def _check_fire_strategy_compliance(self) -> Optional[bool]:
        """Check if fire strategy is compliant"""
        if 'fire strategy' not in self.text_lower:
            return None

        compliant_indicators = ['compliant', 'adequate', 'suitable', 'satisfactory']
        non_compliant_indicators = ['non-compliant', 'inadequate', 'unsuitable', 'requires update']

        if any(indicator in self.text_lower for indicator in compliant_indicators):
            return True
        elif any(indicator in self.text_lower for indicator in non_compliant_indicators):
            return False

        return None

    def _extract_bsc_reference(self) -> Optional[str]:
        """Extract BSC reference number"""
        pattern = r'(?:bsc|building safety certificate)[:\s]+([A-Z0-9/-]+)'
        match = re.search(pattern, self.text, re.IGNORECASE)
        if match:
            return match.group(1)
        return None

    def _extract_bsc_status(self) -> Optional[str]:
        """Determine BSC application status"""
        if 'bsc' not in self.text_lower and 'building safety certificate' not in self.text_lower:
            return None

        status_keywords = {
            'granted': ['granted', 'approved', 'issued'],
            'applied': ['applied', 'application submitted'],
            'conditional': ['conditional', 'conditions attached'],
            'refused': ['refused', 'rejected', 'declined']
        }

        for status, keywords in status_keywords.items():
            if any(keyword in self.text_lower for keyword in keywords):
                return status

        return 'not_applicable'

    def _extract_action_items(self) -> Optional[List[Dict]]:
        """Extract action items and recommendations"""
        action_items = []

        # Common action patterns in FRAs
        action_patterns = [
            r'(?:action|recommendation)[:\s]+([^.\n]{20,200}?)\.',
            r'(?:priority|high|medium|low)[:\s]+([^.\n]{20,200}?)\.',
            r'(?:install|replace|repair|review)[:\s]+([^.\n]{20,200}?)\.'
        ]

        seen_actions = set()  # Avoid duplicates

        for pattern in action_patterns:
            matches = re.finditer(pattern, self.text, re.IGNORECASE)
            for match in matches:
                action_text = match.group(1).strip()

                # Skip if too short or already seen
                if len(action_text) < 20 or action_text in seen_actions:
                    continue

                seen_actions.add(action_text)

                # Determine priority
                priority = 'medium'
                action_lower = action_text.lower()
                if 'high' in action_lower or 'urgent' in action_lower or 'immediate' in action_lower:
                    priority = 'high'
                elif 'low' in action_lower or 'minor' in action_lower:
                    priority = 'low'

                action_items.append({
                    'action': action_text,
                    'priority': priority,
                    'status': 'open',
                    'due_date': None  # Could be extracted if date pattern found
                })

                # Limit to 10 actions
                if len(action_items) >= 10:
                    break

            if len(action_items) >= 10:
                break

        return action_items if action_items else None

    def _extract_risk_rating(self) -> Optional[str]:
        """Extract overall risk rating"""
        rating_keywords = {
            'trivial': ['trivial', 'very low'],
            'tolerable': ['tolerable', 'low risk'],
            'moderate': ['moderate'],
            'substantial': ['substantial', 'high'],
            'intolerable': ['intolerable', 'very high', 'critical']
        }

        # Search for risk rating section
        risk_section_pattern = r'(?:overall risk|risk rating|risk level)[:\s]+(\w+)'
        match = re.search(risk_section_pattern, self.text_lower, re.IGNORECASE)

        if match:
            rating_text = match.group(1).lower()
            for rating, keywords in rating_keywords.items():
                if any(keyword in rating_text for keyword in keywords):
                    return rating

        # Fallback: check full text
        for rating, keywords in rating_keywords.items():
            if any(keyword in self.text_lower for keyword in keywords):
                return rating

        return None

    def _determine_compliance_status(self) -> str:
        """Determine overall compliance status"""
        # Check for explicit compliance statements
        if 'compliant' in self.text_lower and 'non-compliant' not in self.text_lower:
            return 'compliant'

        if 'non-compliant' in self.text_lower or 'non compliant' in self.text_lower:
            return 'non_compliant'

        # Check action items
        action_items = self._extract_action_items()
        if not action_items:
            return 'compliant'

        # If high priority actions, mark as major issues
        high_priority_count = sum(1 for item in action_items if item.get('priority') == 'high')
        if high_priority_count >= 3:
            return 'major_issues'
        elif len(action_items) >= 5:
            return 'major_issues'
        elif action_items:
            return 'minor_issues'

        return 'unknown'

    def _parse_date(self, date_str: str) -> Optional[str]:
        """Parse various date formats to YYYY-MM-DD"""
        date_formats = [
            '%d/%m/%Y',
            '%d-%m-%Y',
            '%d %B %Y',
            '%d %b %Y',
            '%Y-%m-%d'
        ]

        # Clean up ordinal indicators
        date_str = re.sub(r'(\d+)(st|nd|rd|th)', r'\1', date_str)

        for fmt in date_formats:
            try:
                parsed = datetime.strptime(date_str, fmt)
                return parsed.strftime('%Y-%m-%d')
            except ValueError:
                continue

        return None
