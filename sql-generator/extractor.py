"""
SQL Generator - Metadata Extraction
Extract dates, contractors, risk levels, and other metadata from document text
"""

import re
from datetime import datetime
from typing import Dict, Optional, List
from dateutil import parser as date_parser


class MetadataExtractor:
    """Extract structured metadata from document text"""

    # Date patterns
    DATE_PATTERNS = [
        # DD/MM/YYYY or DD-MM-YYYY
        r'(\d{1,2}[\/\-\.]\d{1,2}[\/\-\.]\d{2,4})',
        # DD Month YYYY
        r'(\d{1,2}\s+(?:Jan|Feb|Mar|Apr|May|Jun|Jul|Aug|Sep|Oct|Nov|Dec)[a-z]*\s+\d{2,4})',
        # Month DD, YYYY
        r'((?:Jan|Feb|Mar|Apr|May|Jun|Jul|Aug|Sep|Oct|Nov|Dec)[a-z]*\s+\d{1,2},?\s+\d{4})',
        # YYYY-MM-DD (ISO)
        r'(\d{4}[-\/]\d{1,2}[-\/]\d{1,2})',
    ]

    # Date context keywords
    DATE_CONTEXTS = {
        'inspection': [
            'inspection date', 'inspected on', 'survey date', 'surveyed on',
            'assessment date', 'assessed on', 'date of inspection', 'date of survey',
            'completion date', 'completed on', 'carried out on'
        ],
        'issue': [
            'issue date', 'issued on', 'date issued', 'date of issue',
            'report date', 'dated'
        ],
        'expiry': [
            'expiry date', 'expires on', 'expiration date', 'valid until',
            'renewal date', 'next due', 'due date', 'review date',
            'next inspection', 'next survey', 'next assessment'
        ],
        'next_inspection': [
            'next inspection', 'next survey', 'next assessment',
            'reinspection', 're-inspection', 'follow-up'
        ]
    }

    # Risk level patterns
    RISK_PATTERNS = [
        r'risk\s*(?:level|rating|score)?\s*:?\s*(low|medium|high|critical|negligible)',
        r'(low|medium|high|critical)\s*risk',
        r'overall\s*risk\s*:?\s*(low|medium|high|critical)',
        r'risk\s*classification\s*:?\s*(low|medium|high|critical)'
    ]

    # Contractor/assessor patterns
    CONTRACTOR_PATTERNS = [
        r'(?:carried out by|undertaken by|completed by|assessed by|surveyed by|inspected by)\s*:?\s*([A-Z][A-Za-z\s&\-\.]+(?:Ltd|Limited|LLP|plc)?)',
        r'(?:contractor|assessor|surveyor|inspector)\s*:?\s*([A-Z][A-Za-z\s&\-\.]+(?:Ltd|Limited|LLP|plc)?)',
        r'(?:company name|trading name|business name)\s*:?\s*([A-Z][A-Za-z\s&\-\.]+(?:Ltd|Limited|LLP|plc)?)',
    ]

    # Cost/premium patterns
    COST_PATTERNS = [
        r'(?:total|cost|premium|price|fee|charge)\s*:?\s*£?\s*([\d,]+\.?\d*)',
        r'£\s*([\d,]+\.?\d*)',
    ]

    # Policy/certificate number patterns
    REFERENCE_PATTERNS = [
        r'(?:policy|certificate|reference|reg(?:istration)?)\s*(?:no|number|#)?\s*:?\s*([A-Z0-9\-\/]+)',
    ]

    def extract_dates(self, text: str) -> Dict[str, Optional[str]]:
        """
        Extract dates from text with context awareness

        Returns:
            Dictionary with inspection_date, issue_date, expiry_date, next_due_date
        """
        dates = {
            'inspection_date': None,
            'issue_date': None,
            'expiry_date': None,
            'next_due_date': None
        }

        # Search for dates with context
        text_lower = text.lower()

        for date_type, keywords in self.DATE_CONTEXTS.items():
            for keyword in keywords:
                # Find keyword in text
                pattern = f"{re.escape(keyword)}\\s*:?\\s*(.{{0,100}})"
                match = re.search(pattern, text_lower, re.IGNORECASE)

                if match:
                    context = match.group(1)
                    # Extract date from context
                    date_str = self._extract_date_from_text(context)
                    if date_str:
                        # Map to appropriate field
                        if date_type == 'inspection':
                            dates['inspection_date'] = date_str
                        elif date_type == 'issue':
                            dates['issue_date'] = date_str
                        elif date_type in ['expiry', 'next_inspection']:
                            if not dates['expiry_date']:
                                dates['expiry_date'] = date_str
                            if not dates['next_due_date']:
                                dates['next_due_date'] = date_str
                        break

        return dates

    def _extract_date_from_text(self, text: str) -> Optional[str]:
        """Extract first date from text and normalize to ISO format"""
        for pattern in self.DATE_PATTERNS:
            match = re.search(pattern, text, re.IGNORECASE)
            if match:
                date_str = match.group(1)
                try:
                    # Parse and normalize to ISO format
                    dt = date_parser.parse(date_str, dayfirst=True)
                    return dt.strftime('%Y-%m-%d')
                except:
                    continue
        return None

    def extract_contractor(self, text: str) -> Optional[str]:
        """Extract contractor or assessor name"""
        for pattern in self.CONTRACTOR_PATTERNS:
            match = re.search(pattern, text, re.IGNORECASE)
            if match:
                contractor = match.group(1).strip()
                # Clean up
                contractor = re.sub(r'\s+', ' ', contractor)
                # Ensure it's a reasonable length (not just a word)
                if 5 <= len(contractor) <= 100:
                    return contractor
        return None

    def extract_risk_level(self, text: str) -> Optional[str]:
        """Extract risk level/rating"""
        text_lower = text.lower()
        for pattern in self.RISK_PATTERNS:
            match = re.search(pattern, text_lower)
            if match:
                risk = match.group(1).capitalize()
                return risk
        return None

    def extract_cost(self, text: str) -> Optional[float]:
        """Extract cost/premium amount"""
        for pattern in self.COST_PATTERNS:
            match = re.search(pattern, text, re.IGNORECASE)
            if match:
                cost_str = match.group(1).replace(',', '')
                try:
                    return float(cost_str)
                except:
                    continue
        return None

    def extract_reference_number(self, text: str) -> Optional[str]:
        """Extract policy/certificate reference number"""
        for pattern in self.REFERENCE_PATTERNS:
            match = re.search(pattern, text, re.IGNORECASE)
            if match:
                ref = match.group(1).strip()
                if 3 <= len(ref) <= 50:
                    return ref
        return None

    def extract_all(self, text: str, document_type: str = None) -> Dict:
        """
        Extract all metadata from text

        Args:
            text: Document text
            document_type: Type of document (for context-specific extraction)

        Returns:
            Dictionary with all extracted metadata
        """
        metadata = {}

        # Extract dates
        dates = self.extract_dates(text)
        metadata.update(dates)

        # Extract contractor
        contractor = self.extract_contractor(text)
        if contractor:
            metadata['contractor'] = contractor

        # Extract risk level (mainly for FRA, Asbestos, etc.)
        if document_type in ['FRA', 'Asbestos', 'Legionella']:
            risk = self.extract_risk_level(text)
            if risk:
                metadata['risk_rating'] = risk

        # Extract cost (mainly for Insurance, Major Works)
        if document_type in ['Insurance', 'Major_Works', 'Budget']:
            cost = self.extract_cost(text)
            if cost:
                metadata['cost'] = cost

        # Extract reference number
        ref = self.extract_reference_number(text)
        if ref:
            metadata['reference_number'] = ref

        return metadata


# Additional helper functions for specific document types

def extract_insurance_details(text: str) -> Dict:
    """Extract insurance-specific details"""
    extractor = MetadataExtractor()
    details = extractor.extract_all(text, 'Insurance')

    # Extract sum insured
    sum_insured_pattern = r'(?:sum insured|rebuild cost|reinstatement value)\s*:?\s*£?\s*([\d,]+\.?\d*)'
    match = re.search(sum_insured_pattern, text, re.IGNORECASE)
    if match:
        try:
            details['sum_insured'] = float(match.group(1).replace(',', ''))
        except:
            pass

    # Extract excess
    excess_pattern = r'excess\s*:?\s*£?\s*([\d,]+\.?\d*)'
    match = re.search(excess_pattern, text, re.IGNORECASE)
    if match:
        try:
            details['excess'] = float(match.group(1).replace(',', ''))
        except:
            pass

    return details


def extract_eicr_details(text: str) -> Dict:
    """Extract EICR-specific details"""
    extractor = MetadataExtractor()
    details = extractor.extract_all(text, 'EICR')

    # Extract result (satisfactory/unsatisfactory)
    result_pattern = r'(?:overall|result|outcome)\s*:?\s*(satisfactory|unsatisfactory)'
    match = re.search(result_pattern, text, re.IGNORECASE)
    if match:
        details['result'] = match.group(1).capitalize()

    # Extract code violations (C1, C2, C3)
    code_pattern = r'(C[123])\s*(?:code|observation|defect)'
    codes = re.findall(code_pattern, text, re.IGNORECASE)
    if codes:
        details['code_violations'] = list(set(codes))

    return details


# Test function
if __name__ == '__main__':
    extractor = MetadataExtractor()

    # Test text
    test_text = """
    Fire Risk Assessment Report

    Inspection Date: 4th March 2025
    Carried out by: TriFire Safety Ltd

    Overall Risk Rating: Low

    Next Inspection Due: 4th March 2026

    Reference Number: FRA-2025-001
    """

    result = extractor.extract_all(test_text, 'FRA')
    print("Extracted metadata:")
    for key, value in result.items():
        print(f"  {key}: {value}")
