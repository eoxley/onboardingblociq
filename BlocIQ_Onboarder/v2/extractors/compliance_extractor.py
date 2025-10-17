"""
Compliance Date Extractor
=========================
Finds current/latest assessments with accurate dates
Uses freshness + authority scoring
"""

import re
from typing import Dict, List, Optional, Tuple
from datetime import datetime, timedelta
from dateutil.relativedelta import relativedelta


class ComplianceExtractor:
    """
    Extract compliance assessment data with accurate dates
    Finds CURRENT assessment, falls back to latest if no current
    """
    
    # Standard compliance cycles (UK regulations)
    COMPLIANCE_CYCLES = {
        'fire_risk_assessment': {'months': 12, 'type': 'FRA'},
        'fire_door_inspection': {'months': 12, 'type': 'Fire Doors'},
        'eicr': {'months': 60, 'type': 'EICR'},  # 5 years
        'emergency_lighting': {'months': 12, 'type': 'Emergency Lighting'},
        'legionella': {'months': 24, 'type': 'Legionella'},  # Risk-based, 24m typical
        'lift_loler': {'months': 6, 'type': 'Lift LOLER'},
        'asbestos': {'months': 12, 'type': 'Asbestos'},  # Re-inspection
        'gas_safety': {'months': 12, 'type': 'Gas Safety'},
        'water_hygiene': {'months': 24, 'type': 'Water Hygiene'},
    }
    
    def extract(self, document: Dict, text: str) -> Optional[Dict]:
        """
        Extract compliance data from document
        
        Returns:
            {
                'asset_type': 'Fire Risk Assessment',
                'assessment_date': '2024-01-24',
                'next_due_date': '2025-01-24',
                'assessor_company': 'ABC Safety Ltd',
                'status': 'Pass',  # Pass/Advisories/Unsatisfactory
                'recommendations': '3 actions required',
                'certificate_number': 'FRA-2024-001',
                'is_current': True,
                'authority_score': 0.95,  # Signed > Draft
                'source_document_id': '...',
                'page_reference': 1
            }
        """
        filename = document.get('filename', '').lower()
        
        # Identify asset type
        asset_type, compliance_key = self._identify_asset_type(filename, text)
        
        if not asset_type:
            return None
        
        # Extract assessment date
        assessment_date = self._extract_assessment_date(text, filename)
        
        # Calculate/extract next due date
        next_due = self._calculate_next_due(
            assessment_date,
            compliance_key,
            text
        )
        
        # Extract assessor/company
        assessor = self._extract_assessor(text, asset_type)
        
        # Extract status/result
        status = self._extract_status(text, asset_type)
        
        # Extract certificate/report number
        cert_number = self._extract_certificate_number(text)
        
        # Calculate authority score (final > draft, signed > unsigned)
        authority = self._calculate_authority_score(filename, text)
        
        # Determine if current (based on next_due vs today)
        is_current = self._is_current(next_due)
        
        return {
            'asset_type': asset_type,
            'asset_key': compliance_key,
            'assessment_date': assessment_date,
            'next_due_date': next_due,
            'assessor_company': assessor,
            'status': status,
            'certificate_number': cert_number,
            'is_current': is_current,
            'authority_score': authority,
            'source_document_id': document.get('document_id'),
            'source_filename': document.get('filename'),
            'extraction_confidence': 0.85 if assessment_date else 0.50
        }
    
    def _identify_asset_type(self, filename: str, text: str) -> Tuple[Optional[str], Optional[str]]:
        """Identify compliance asset type"""
        text_lower = text.lower() if text else ''
        
        patterns = {
            'fire_risk_assessment': (r'\b(fire\s*risk\s*assessment|fra)\b', 'Fire Risk Assessment'),
            'eicr': (r'\b(eicr|electrical\s+installation\s+condition\s+report)\b', 'EICR'),
            'legionella': (r'\b(legionella|water\s+hygiene|l8)\b', 'Legionella Risk Assessment'),
            'lift_loler': (r'\b(loler|lift.*inspection|thorough\s+examination)\b', 'Lift LOLER Inspection'),
            'asbestos': (r'\b(asbestos.*survey|asbestos.*inspection)\b', 'Asbestos Survey'),
            'gas_safety': (r'\b(gas\s+safety|lgsr)\b', 'Gas Safety Certificate'),
            'emergency_lighting': (r'\b(emergency\s+light|emer.*light.*test)\b', 'Emergency Lighting Test'),
            'fire_door_inspection': (r'\b(fire\s+door|door.*inspect)\b', 'Fire Door Inspection'),
        }
        
        for key, (pattern, display_name) in patterns.items():
            if re.search(pattern, filename, re.IGNORECASE) or re.search(pattern, text_lower):
                return display_name, key
        
        return None, None
    
    def _extract_assessment_date(self, text: str, filename: str) -> Optional[str]:
        """Extract assessment/inspection date - ENHANCED for better accuracy"""
        if not text:
            return None
        
        # Look for dates in MUCH MORE text (first 10000 chars to catch multiple pages)
        content_start = text[:10000]
        
        # EXPANDED patterns for assessment dates (based on real documents)
        patterns = [
            # Date of assessment patterns
            r'date\s+of\s+assessment:?\s*(\d{1,2}\s+\w+\s+\d{4})',  # "22 July 2025"
            r'assessment\s+date:?\s*(\d{1,2}[-/]\d{1,2}[-/]\d{2,4})',
            
            # Inspection date patterns
            r'inspection\s+and\s+testing\s+were\s+carried\s+out\s+(\d{1,2}[-/]\d{1,2}[-/]\d{4})',  # EICR specific
            r'date\s+of\s+inspection:?\s*(\d{1,2}[-/]\d{1,2}[-/]\d{2,4})',
            r'inspection\s+date:?\s*(\d{1,2}[-/]\d{1,2}[-/]\d{2,4})',
            
            # Issue/report date patterns
            r'issue\s+date:?\s*(\d{1,2}\s+\w+\s+\d{4})',  # "5 August 2025"
            r'report\s+date:?\s*(\d{1,2}[-/]\d{1,2}[-/]\d{2,4})',
            
            # Generic patterns
            r'carried\s+out\s+on:?\s*(\d{1,2}[-/]\d{1,2}[-/]\d{2,4})',
            r'dated:?\s*(\d{1,2}[-/]\d{1,2}[-/]\d{2,4})',
            r'date:?\s*(\d{1,2}[-/]\d{1,2}[-/]\d{4})',
            
            # Test date patterns
            r'test\s+date:?\s*(\d{1,2}[-/]\d{1,2}[-/]\d{2,4})',
            r'tested\s+on:?\s*(\d{1,2}[-/]\d{1,2}[-/]\d{2,4})',
        ]
        
        for pattern in patterns:
            match = re.search(pattern, content_start, re.IGNORECASE)
            if match:
                date_str = match.group(1)
                normalized = self._normalize_date(date_str)
                if normalized:
                    return normalized
        
        # Fallback: look for any date in YYYY-MM-DD format
        match = re.search(r'(\d{4}-\d{2}-\d{2})', content_start)
        if match:
            return match.group(1)
        
        return None
    
    def _normalize_date(self, date_str: str) -> Optional[str]:
        """Normalize date string to YYYY-MM-DD - ENHANCED to handle text dates"""
        
        # Month name to number mapping
        months = {
            'january': 1, 'jan': 1,
            'february': 2, 'feb': 2,
            'march': 3, 'mar': 3,
            'april': 4, 'apr': 4,
            'may': 5,
            'june': 6, 'jun': 6,
            'july': 7, 'jul': 7,
            'august': 8, 'aug': 8,
            'september': 9, 'sep': 9, 'sept': 9,
            'october': 10, 'oct': 10,
            'november': 11, 'nov': 11,
            'december': 12, 'dec': 12
        }
        
        # Pattern 1: "22 July 2025" or "5 August 2025"
        match = re.match(r'(\d{1,2})\s+(\w+)\s+(\d{4})', date_str, re.IGNORECASE)
        if match:
            day, month_name, year = match.groups()
            month_num = months.get(month_name.lower())
            if month_num:
                return f"{year}-{month_num:02d}-{int(day):02d}"
        
        # Pattern 2: DD/MM/YYYY (UK format - most common)
        match = re.match(r'(\d{1,2})[-/](\d{1,2})[-/](\d{4})', date_str)
        if match:
            day, month, year = match.groups()
            return f"{year}-{int(month):02d}-{int(day):02d}"
        
        # Pattern 3: DD/MM/YY (2-digit year)
        match = re.match(r'(\d{1,2})[-/](\d{1,2})[-/](\d{2})$', date_str)
        if match:
            day, month, year = match.groups()
            full_year = f"20{year}"  # Assume 20xx
            return f"{full_year}-{int(month):02d}-{int(day):02d}"
        
        # Pattern 4: YYYY-MM-DD (already normalized)
        match = re.match(r'(\d{4})[-/](\d{1,2})[-/](\d{1,2})', date_str)
        if match:
            year, month, day = match.groups()
            return f"{year}-{int(month):02d}-{int(day):02d}"
        
        return None
    
    def _calculate_next_due(self, assessment_date: Optional[str], 
                           compliance_key: str, text: str) -> Optional[str]:
        """Calculate next due date based on cycle OR extract from document"""
        
        # FIRST: Try to find explicitly stated review/due date in document
        explicit_due = self._extract_next_due_from_text(text)
        if explicit_due:
            return explicit_due
        
        # FALLBACK: Calculate based on standard cycles
        if not assessment_date:
            return None
        
        try:
            date_obj = datetime.strptime(assessment_date, '%Y-%m-%d')
        except:
            return None
        
        # Get cycle for this asset type
        cycle_info = self.COMPLIANCE_CYCLES.get(compliance_key, {})
        months = cycle_info.get('months', 12)  # Default 12 months
        
        # Calculate next due
        next_due = date_obj + relativedelta(months=months)
        
        return next_due.strftime('%Y-%m-%d')
    
    def _extract_next_due_from_text(self, text: str) -> Optional[str]:
        """Extract explicitly stated next due/review date from document"""
        if not text:
            return None
        
        # Look in first 10000 chars
        content = text[:10000]
        
        # Patterns for next due/review dates
        patterns = [
            r'recommended\s+review\s+date:?\s*(\d{1,2}\s+\w+\s+\d{4})',  # "22 July 2026"
            r'next\s+(?:review|due)\s+date:?\s*(\d{1,2}\s+\w+\s+\d{4})',
            r'review\s+date:?\s*(\d{1,2}\s+\w+\s+\d{4})',
            r'next\s+(?:review|due):?\s*(\d{1,2}[-/]\d{1,2}[-/]\d{4})',
            r'due\s+date:?\s*(\d{1,2}[-/]\d{1,2}[-/]\d{4})',
        ]
        
        for pattern in patterns:
            match = re.search(pattern, content, re.IGNORECASE)
            if match:
                date_str = match.group(1)
                normalized = self._normalize_date(date_str)
                if normalized:
                    return normalized
        
        return None
    
    def _extract_assessor(self, text: str, asset_type: str) -> Optional[str]:
        """Extract assessor/company name"""
        if not text:
            return None
        
        # Look for company patterns
        patterns = [
            r'assessor:?\s*([A-Z][A-Za-z\s&]+(?:Ltd|Limited|LLP))',
            r'carried\s+out\s+by:?\s*([A-Z][A-Za-z\s&]+(?:Ltd|Limited|LLP))',
            r'inspector:?\s*([A-Z][A-Za-z\s&]+(?:Ltd|Limited|LLP))',
        ]
        
        for pattern in patterns:
            match = re.search(pattern, text[:2000])
            if match:
                return match.group(1).strip()
        
        return None
    
    def _extract_status(self, text: str, asset_type: str) -> str:
        """Extract assessment result/status"""
        if not text:
            return 'Unknown'
        
        text_lower = text.lower()
        
        if any(term in text_lower for term in ['satisfactory', 'pass', 'compliant', 'acceptable']):
            return 'Pass'
        elif any(term in text_lower for term in ['unsatisfactory', 'fail', 'non-compliant', 'unacceptable']):
            return 'Fail'
        elif any(term in text_lower for term in ['advisory', 'recommendation', 'action required']):
            return 'Advisories'
        
        return 'Unknown'
    
    def _extract_certificate_number(self, text: str) -> Optional[str]:
        """Extract certificate/report number"""
        if not text:
            return None
        
        # Look for reference numbers
        patterns = [
            r'report\s+(?:no|number|ref|reference):?\s*([A-Z0-9-]+)',
            r'certificate\s+(?:no|number):?\s*([A-Z0-9-]+)',
            r'ref:?\s*([A-Z0-9-]{5,})',
        ]
        
        for pattern in patterns:
            match = re.search(pattern, text[:1000], re.IGNORECASE)
            if match:
                return match.group(1).strip()
        
        return None
    
    def _calculate_authority_score(self, filename: str, text: str) -> float:
        """
        Calculate authority score (0-1)
        Signed > Unsigned, Final > Draft, Board-approved > Proposal
        """
        score = 0.5  # Base score
        
        filename_lower = filename.lower()
        text_lower = (text or '').lower()
        
        # Final/Approved boost
        if 'final' in filename_lower or 'approved' in filename_lower:
            score += 0.3
        
        # Signed boost
        if 'signed' in text_lower or 'signature' in text_lower:
            score += 0.2
        
        # Draft penalty
        if 'draft' in filename_lower:
            score -= 0.2
        
        # Quote/Proposal penalty
        if any(term in filename_lower for term in ['quote', 'proposal', 'estimate']):
            score -= 0.3
        
        return max(0.1, min(1.0, score))
    
    def _is_current(self, next_due_date: Optional[str]) -> bool:
        """Check if assessment is still current"""
        if not next_due_date:
            return False
        
        try:
            due = datetime.strptime(next_due_date, '%Y-%m-%d')
            today = datetime.now()
            return due >= today
        except:
            return False

