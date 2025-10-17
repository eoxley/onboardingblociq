"""
Contract Extractor
==================
Extracts contractor details, service types, dates from contract documents
Uses latest if current not available
"""

import re
from typing import Dict, List, Optional
from datetime import datetime


class ContractExtractor:
    """
    Extract structured data from contract documents
    Contractor name, service, dates, costs, KPIs
    """
    
    def extract(self, document: Dict, text: str) -> Optional[Dict]:
        """
        Extract contract data from document
        
        Returns:
            {
                'contractor_name': 'ABC Cleaning Ltd',
                'service_type': 'cleaning',
                'start_date': '2023-01-01',
                'end_date': '2025-12-31',
                'renewal_date': '2025-11-01',
                'contract_value': 16000.00,  # Annual
                'frequency': 'weekly',
                'notice_period': '3 months',
                'kpis': ['Response time: 24h', 'Quality score: 95%'],
                'is_current': True,
                'authority_score': 0.9,
                'source_document_id': '...'
            }
        """
        if not text:
            return None
        
        # Extract contractor name
        contractor_name = self._extract_contractor_name(text, document.get('filename', ''))
        
        if not contractor_name:
            return None
        
        # Extract service type
        service_type = self._extract_service_type(text, document.get('filename', ''))
        
        # Extract dates
        start_date = self._extract_start_date(text)
        end_date = self._extract_end_date(text)
        renewal_date = self._extract_renewal_date(text)
        
        # Extract contract value
        contract_value = self._extract_contract_value(text)
        
        # Extract frequency/schedule
        frequency = self._extract_frequency(text)
        
        # Extract notice period
        notice = self._extract_notice_period(text)
        
        # Determine if current
        is_current = self._is_current_contract(end_date)
        
        # Calculate authority score
        authority = self._calculate_authority_score(document.get('filename', ''), text)
        
        return {
            'contractor_name': contractor_name,
            'service_type': service_type,
            'start_date': start_date,
            'end_date': end_date,
            'renewal_date': renewal_date,
            'contract_value': contract_value,
            'frequency': frequency,
            'notice_period': notice,
            'is_current': is_current,
            'authority_score': authority,
            'source_document_id': document.get('document_id'),
            'source_filename': document.get('filename')
        }
    
    def _extract_contractor_name(self, text: str, filename: str) -> Optional[str]:
        """Extract contractor/company name from contract"""
        # Look for company name patterns
        patterns = [
            r'contractor:?\s*([A-Z][A-Za-z\s&]+(?:Ltd|Limited|LLP|PLC|Services))',
            r'company:?\s*([A-Z][A-Za-z\s&]+(?:Ltd|Limited|LLP|PLC|Services))',
            r'supplier:?\s*([A-Z][A-Za-z\s&]+(?:Ltd|Limited|LLP|PLC|Services))',
            r'between.*and\s+([A-Z][A-Za-z\s&]+(?:Ltd|Limited|LLP|PLC))',  # "between X and Y Ltd"
        ]
        
        for pattern in patterns:
            match = re.search(pattern, text[:2000], re.IGNORECASE)
            if match:
                return match.group(1).strip()
        
        # Fallback: extract from filename
        # "ISS Contract.pdf" -> "ISS"
        match = re.search(r'^([A-Z][A-Za-z\s&]+)(?:\s+Contract|\s+Agreement)', filename, re.IGNORECASE)
        if match:
            return match.group(1).strip()
        
        return None
    
    def _extract_service_type(self, text: str, filename: str) -> str:
        """Extract service type from contract"""
        text_lower = text.lower()
        filename_lower = filename.lower()
        
        # Service keywords
        services = {
            'cleaning': ['cleaning', 'cleaner', 'porter', 'caretaker'],
            'gardening': ['garden', 'landscape', 'grounds', 'horticulture'],
            'lifts': ['lift', 'elevator'],
            'security': ['security', 'cctv', 'concierge'],
            'mne': ['electrical', 'plumbing', 'mechanical', 'm&e', 'heating', 'boiler'],
            'fire': ['fire', 'extinguisher', 'alarm'],
            'pest_control': ['pest', 'vermin'],
            'window_cleaning': ['window clean'],
            'waste': ['waste', 'refuse', 'bin'],
        }
        
        # Check filename first
        for service_type, keywords in services.items():
            if any(kw in filename_lower for kw in keywords):
                return service_type
        
        # Check text content
        for service_type, keywords in services.items():
            if any(kw in text_lower for kw in keywords):
                return service_type
        
        return 'general'
    
    def _extract_start_date(self, text: str) -> Optional[str]:
        """Extract contract start/commencement date"""
        patterns = [
            r'commencement\s+date:?\s*(\d{1,2}[-/]\w+[-/]\d{2,4})',
            r'start\s+date:?\s*(\d{1,2}[-/]\w+[-/]\d{2,4})',
            r'commencing:?\s*(\d{1,2}[-/]\w+[-/]\d{2,4})',
            r'from:?\s*(\d{1,2}[-/]\w+[-/]\d{2,4})',
        ]
        
        for pattern in patterns:
            match = re.search(pattern, text[:3000], re.IGNORECASE)
            if match:
                return self._normalize_date(match.group(1))
        
        return None
    
    def _extract_end_date(self, text: str) -> Optional[str]:
        """Extract contract end/expiry date"""
        patterns = [
            r'expiry\s+date:?\s*(\d{1,2}[-/]\w+[-/]\d{2,4})',
            r'end\s+date:?\s*(\d{1,2}[-/]\w+[-/]\d{2,4})',
            r'termination:?\s*(\d{1,2}[-/]\w+[-/]\d{2,4})',
            r'until:?\s*(\d{1,2}[-/]\w+[-/]\d{2,4})',
        ]
        
        for pattern in patterns:
            match = re.search(pattern, text[:3000], re.IGNORECASE)
            if match:
                return self._normalize_date(match.group(1))
        
        return None
    
    def _extract_renewal_date(self, text: str) -> Optional[str]:
        """Extract renewal date"""
        pattern = r'renewal:?\s*(\d{1,2}[-/]\w+[-/]\d{2,4})'
        match = re.search(pattern, text[:3000], re.IGNORECASE)
        if match:
            return self._normalize_date(match.group(1))
        return None
    
    def _extract_contract_value(self, text: str) -> Optional[float]:
        """Extract annual contract value"""
        # Look for annual cost
        patterns = [
            r'annual\s+(?:cost|fee|charge):?\s*£?\s*([\d,]+\.?\d*)',
            r'per\s+annum:?\s*£?\s*([\d,]+\.?\d*)',
            r'yearly:?\s*£?\s*([\d,]+\.?\d*)',
        ]
        
        for pattern in patterns:
            match = re.search(pattern, text[:5000], re.IGNORECASE)
            if match:
                amount_str = match.group(1).replace(',', '')
                try:
                    return float(amount_str)
                except:
                    pass
        
        return None
    
    def _extract_frequency(self, text: str) -> Optional[str]:
        """Extract service frequency (weekly, monthly, etc.)"""
        patterns = [
            (r'\b(daily)\b', 'daily'),
            (r'\b(weekly|once\s+a\s+week)\b', 'weekly'),
            (r'\b(fortnightly|bi-weekly)\b', 'fortnightly'),
            (r'\b(monthly|once\s+a\s+month)\b', 'monthly'),
            (r'\b(quarterly)\b', 'quarterly'),
            (r'\b(annual|yearly|once\s+a\s+year)\b', 'annual'),
        ]
        
        text_lower = text.lower()
        for pattern, freq in patterns:
            if re.search(pattern, text_lower):
                return freq
        
        return None
    
    def _extract_notice_period(self, text: str) -> Optional[str]:
        """Extract notice period for termination"""
        pattern = r'notice:?\s*(\d+)\s*(month|week|day)s?'
        match = re.search(pattern, text[:5000], re.IGNORECASE)
        if match:
            return f"{match.group(1)} {match.group(2)}s"
        return None
    
    def _normalize_date(self, date_str: str) -> Optional[str]:
        """Normalize date to YYYY-MM-DD"""
        # Handle formats: 15/03/2024, 15-Mar-2024, etc.
        # TODO: Implement proper date parsing
        return date_str  # Placeholder
    
    def _is_current_contract(self, end_date: Optional[str]) -> bool:
        """Check if contract is current"""
        if not end_date:
            return True  # Assume current if no end date
        
        try:
            end = datetime.strptime(end_date, '%Y-%m-%d')
            return end >= datetime.now()
        except:
            return True
    
    def _calculate_authority_score(self, filename: str, text: str) -> float:
        """Calculate authority score for contract"""
        score = 0.5
        
        filename_lower = filename.lower()
        text_lower = text.lower()
        
        # Signed contract
        if 'signed' in text_lower or 'signature' in text_lower:
            score += 0.3
        
        # Final/Executed
        if 'final' in filename_lower or 'executed' in filename_lower:
            score += 0.2
        
        # Draft penalty
        if 'draft' in filename_lower:
            score -= 0.2
        
        # Quote/Proposal penalty
        if any(term in filename_lower for term in ['quote', 'quotation', 'proposal']):
            score -= 0.4
        
        return max(0.1, min(1.0, score))

