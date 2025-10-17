"""
Accounts Extractor
==================
Extracts year-end accounts data: issue date, approval date, financial year
Authority ranking: Approved Final > Draft > Board Pack
"""

import re
from typing import Dict, Optional
from datetime import datetime


class AccountsExtractor:
    """
    Extract structured data from year-end accounts
    Focus: financial year, issue date, approval date, approved status
    """
    
    def extract(self, document: Dict, text: str) -> Optional[Dict]:
        """
        Extract accounts data
        
        Returns:
            {
                'financial_year': '2024',  # Or '2023-2024'
                'year_end_date': '2024-03-31',
                'issue_date': '2024-05-15',
                'approval_date': '2024-06-20',
                'approved_by': 'Board of Directors',
                'accountant': 'ABC Accountants Ltd',
                'is_final': True,
                'is_approved': True,
                'total_expenditure': 92786.00,
                'authority_score': 0.95,
                'source_document_id': '...'
            }
        """
        if not text:
            return None
        
        accounts_data = {
            'financial_year': None,
            'year_end_date': None,
            'issue_date': None,
            'approval_date': None,
            'approved_by': None,
            'accountant': None,
            'is_final': False,
            'is_approved': False,
            'total_expenditure': None,
            'authority_score': 0.5,
            'source_document_id': document.get('document_id'),
            'source_filename': document.get('filename')
        }
        
        # Extract financial year
        accounts_data['financial_year'] = self._extract_financial_year(text, document.get('filename', ''))
        
        # Extract year end date
        accounts_data['year_end_date'] = self._extract_year_end_date(text)
        
        # Extract approval status
        accounts_data['is_approved'] = self._is_approved(text)
        accounts_data['is_final'] = self._is_final(document.get('filename', ''), text)
        
        # Extract approval date
        if accounts_data['is_approved']:
            accounts_data['approval_date'] = self._extract_approval_date(text)
            accounts_data['approved_by'] = self._extract_approved_by(text)
        
        # Extract accountant
        accounts_data['accountant'] = self._extract_accountant(text)
        
        # Extract total expenditure
        accounts_data['total_expenditure'] = self._extract_total_expenditure(text)
        
        # Calculate authority score
        accounts_data['authority_score'] = self._calculate_authority_score(
            accounts_data['is_final'],
            accounts_data['is_approved'],
            document.get('filename', '')
        )
        
        return accounts_data if accounts_data['financial_year'] else None
    
    def _extract_financial_year(self, text: str, filename: str) -> Optional[str]:
        """Extract financial year (e.g., '2024' or '2023-2024')"""
        # Check filename first: "YE 31.03.24", "Accounts 2023-2024"
        filename_patterns = [
            r'ye\s*(\d{2})',  # YE 24
            r'ye\s*(\d{4})',  # YE 2024
            r'(\d{4})\s*-\s*(\d{4})',  # 2023-2024
            r'accounts?\s+(\d{4})',
        ]
        
        for pattern in filename_patterns:
            match = re.search(pattern, filename, re.IGNORECASE)
            if match:
                year = match.group(1)
                if len(year) == 2:
                    year = '20' + year
                return year
        
        # Check text content
        text_patterns = [
            r'year\s+ended?\s+(\d{1,2}\s+\w+\s+\d{4})',
            r'financial\s+year:?\s*(\d{4})',
            r'period:?\s*(\d{4})\s*-\s*(\d{4})',
        ]
        
        for pattern in text_patterns:
            match = re.search(pattern, text[:1000], re.IGNORECASE)
            if match:
                # Extract year from date or period
                year_match = re.search(r'\d{4}', match.group(0))
                if year_match:
                    return year_match.group(0)
        
        return None
    
    def _extract_year_end_date(self, text: str) -> Optional[str]:
        """Extract year end date"""
        patterns = [
            r'year\s+ended?\s+(\d{1,2})\s+(\w+)\s+(\d{4})',
            r'year\s+end:?\s*(\d{1,2}[-/]\d{1,2}[-/]\d{2,4})',
            r'period\s+ended?:?\s*(\d{1,2}[-/]\d{1,2}[-/]\d{2,4})',
        ]
        
        for pattern in patterns:
            match = re.search(pattern, text[:1000], re.IGNORECASE)
            if match:
                # TODO: Parse to YYYY-MM-DD
                return match.group(0)
        
        return None
    
    def _is_approved(self, text: str) -> bool:
        """Check if accounts are approved"""
        text_lower = text.lower()
        
        approval_indicators = [
            r'approved\s+by\s+the\s+board',
            r'board\s+approved',
            r'approved\s+at\s+(?:agm|egm|board\s+meeting)',
            r'directors?\s+approved',
            r'signed\s+on\s+behalf',
        ]
        
        return any(re.search(pattern, text_lower) for pattern in approval_indicators)
    
    def _is_final(self, filename: str, text: str) -> bool:
        """Check if accounts are final (not draft)"""
        filename_lower = filename.lower()
        text_lower = text.lower()
        
        if 'final' in filename_lower:
            return True
        
        if 'draft' in filename_lower or 'draft' in text[:500]:
            return False
        
        # If approved, likely final
        if self._is_approved(text):
            return True
        
        return False
    
    def _extract_approval_date(self, text: str) -> Optional[str]:
        """Extract date when accounts were approved"""
        patterns = [
            r'approved\s+(?:by\s+the\s+board\s+)?on:?\s*(\d{1,2}[-/]\w+[-/]\d{2,4})',
            r'approved:?\s*(\d{1,2}[-/]\w+[-/]\d{2,4})',
            r'board\s+meeting:?\s*(\d{1,2}[-/]\w+[-/]\d{2,4})',
        ]
        
        for pattern in patterns:
            match = re.search(pattern, text[:2000], re.IGNORECASE)
            if match:
                # TODO: Normalize date
                return match.group(1)
        
        return None
    
    def _extract_approved_by(self, text: str) -> Optional[str]:
        """Extract who approved the accounts"""
        patterns = [
            r'approved\s+by:?\s*([A-Z][A-Za-z\s]{5,50})',
            r'signed\s+on\s+behalf\s+of:?\s*([A-Z][A-Za-z\s]{5,50})',
        ]
        
        for pattern in patterns:
            match = re.search(pattern, text[:2000])
            if match:
                return match.group(1).strip()
        
        # Default
        if 'board' in text.lower()[:2000]:
            return 'Board of Directors'
        
        return None
    
    def _extract_accountant(self, text: str) -> Optional[str]:
        """Extract accountant/auditor name"""
        patterns = [
            r'accountants?:?\s*([A-Z][A-Za-z\s&]+(?:LLP|Ltd|Limited))',
            r'prepared\s+by:?\s*([A-Z][A-Za-z\s&]+(?:LLP|Ltd|Limited))',
            r'accountant.?s\s+report.*?to\s+the\s+members\s+of\s+([A-Z][A-Za-z\s&]+)',
        ]
        
        for pattern in patterns:
            match = re.search(pattern, text[:2000])
            if match:
                return match.group(1).strip()
        
        return None
    
    def _extract_total_expenditure(self, text: str) -> Optional[float]:
        """Extract total expenditure from accounts"""
        patterns = [
            r'total\s+expenditure:?\s*£?\s*([\d,]+\.?\d*)',
            r'total\s+outgoings:?\s*£?\s*([\d,]+\.?\d*)',
            r'total\s+costs?:?\s*£?\s*([\d,]+\.?\d*)',
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
    
    def _calculate_authority_score(self, is_final: bool, is_approved: bool, filename: str) -> float:
        """Calculate authority score for accounts"""
        score = 0.3  # Base
        
        if is_final:
            score += 0.3
        if is_approved:
            score += 0.4
        
        if 'draft' in filename.lower():
            score -= 0.3
        
        return max(0.1, min(1.0, score))

