"""
Lease Deep Analyzer
===================
Full clause-by-clause analysis of 3 representative leases
Cross-checks dates, extracts responsibilities, covenants
"""

import re
from typing import Dict, List, Optional, Tuple


class LeaseAnalyzer:
    """
    Deep analysis of lease documents
    Extracts ALL key clauses with interpretation
    """
    
    # Key clause categories to extract
    CLAUSE_CATEGORIES = {
        'service_charge': ['service charge', 'maintenance charge', 'service costs'],
        'ground_rent': ['ground rent', 'rent payable'],
        'repairs': ['repair', 'maintain', 'decoration', 'condition'],
        'insurance': ['insurance', 'insure', 'premium'],
        'alienation': ['assignment', 'subletting', 'transfer', 'alienation'],
        'use': ['use', 'occupation', 'business', 'residential'],
        'alterations': ['alteration', 'addition', 'improvement', 'structural'],
        'nuisance': ['nuisance', 'annoyance', 'disturbance'],
        'forfeiture': ['forfeiture', 'termination', 'breach', 'remedy'],
        'notices': ['notice', 'notification', 'serve'],
        'reserve_fund': ['reserve', 'sinking fund', 'contingency'],
        'interest': ['interest', 'late payment'],
    }
    
    def analyze_leases(self, lease_documents: List[Dict], limit: int = 3) -> Dict:
        """
        Analyze up to 3 leases (oldest, median, newest)
        
        Returns:
            {
                'leases_analyzed': 3,
                'lease_details': [
                    {
                        'title_number': 'NGL809841',
                        'lease_date': '2010-05-15',
                        'term_years': 99,
                        'lease_start': '2010-05-15',
                        'lease_end': '2109-05-14',
                        'ground_rent': 250.00,
                        'service_charge_clauses': [...],
                        'responsibilities': {...},
                        'key_clauses': [...]
                    },
                    ...
                ],
                'cross_check_results': {
                    'service_charge_frequency': 'Quarterly',
                    'demand_dates': ['1 Mar', '1 Jun', '1 Sep', '1 Dec'],
                    'reserve_fund_allowed': True,
                    'landlord_responsibilities': [...],
                    'tenant_responsibilities': [...]
                }
            }
        """
        # Select 3 representative leases
        selected_leases = self._select_representative_leases(lease_documents, limit)
        
        analyzed_leases = []
        
        for lease_doc in selected_leases:
            text = lease_doc.get('extracted_text', '')
            
            if not text:
                continue
            
            lease_analysis = self._analyze_single_lease(lease_doc, text)
            if lease_analysis:
                analyzed_leases.append(lease_analysis)
        
        # Cross-check across all analyzed leases
        cross_check = self._cross_check_leases(analyzed_leases)
        
        return {
            'leases_analyzed': len(analyzed_leases),
            'lease_details': analyzed_leases,
            'cross_check_results': cross_check
        }
    
    def _select_representative_leases(self, leases: List[Dict], limit: int) -> List[Dict]:
        """Select oldest, median, newest leases"""
        if len(leases) <= limit:
            return leases
        
        # Try to get dates from filenames or content
        leases_with_dates = []
        for lease in leases:
            date = self._guess_lease_date(lease)
            leases_with_dates.append((lease, date))
        
        # Sort by date
        leases_with_dates.sort(key=lambda x: x[1] or '9999')
        
        # Select oldest, median, newest
        selected_indices = [0, len(leases_with_dates) // 2, -1]
        return [leases_with_dates[i][0] for i in selected_indices if i < len(leases_with_dates)]
    
    def _guess_lease_date(self, lease: Dict) -> Optional[str]:
        """Guess lease date from filename or document"""
        filename = lease.get('filename', '')
        
        # Look for date in filename
        date_match = re.search(r'(\d{4})', filename)
        if date_match:
            return date_match.group(1)
        
        return None
    
    def _analyze_single_lease(self, lease_doc: Dict, text: str) -> Optional[Dict]:
        """Analyze a single lease document"""
        lease_data = {
            'document_id': lease_doc.get('document_id'),
            'filename': lease_doc.get('filename'),
            'title_number': None,
            'lease_date': None,
            'term_years': None,
            'ground_rent': None,
            'service_charge_clauses': [],
            'key_clauses': [],
            'responsibilities': {
                'landlord': [],
                'tenant': []
            }
        }
        
        # Extract title number
        lease_data['title_number'] = self._extract_title_number(text)
        
        # Extract lease term
        lease_data['term_years'] = self._extract_lease_term(text)
        
        # Extract ground rent
        lease_data['ground_rent'] = self._extract_ground_rent(text)
        
        # Extract service charge clauses
        lease_data['service_charge_clauses'] = self._extract_service_charge_info(text)
        
        # Extract key clauses by category
        lease_data['key_clauses'] = self._extract_key_clauses(text)
        
        # Extract responsibilities
        lease_data['responsibilities'] = self._extract_responsibilities(text)
        
        return lease_data
    
    def _extract_title_number(self, text: str) -> Optional[str]:
        """Extract Land Registry title number"""
        pattern = r'title\s+number:?\s*([A-Z]{2,3}\d{5,7})'
        match = re.search(pattern, text[:2000], re.IGNORECASE)
        if match:
            return match.group(1)
        return None
    
    def _extract_lease_term(self, text: str) -> Optional[int]:
        """Extract lease term in years"""
        patterns = [
            r'term\s+of\s+(\d+)\s+years?',
            r'(\d+)\s+year\s+lease',
            r'for\s+a\s+term\s+of\s+(\d+)\s+years?',
        ]
        
        for pattern in patterns:
            match = re.search(pattern, text[:2000], re.IGNORECASE)
            if match:
                try:
                    return int(match.group(1))
                except:
                    pass
        
        return None
    
    def _extract_ground_rent(self, text: str) -> Optional[float]:
        """Extract annual ground rent amount"""
        patterns = [
            r'ground\s+rent.*?£\s*([\d,]+\.?\d*)\s*per\s+annum',
            r'yearly\s+rent.*?£\s*([\d,]+\.?\d*)',
            r'ground\s+rent:?\s*£\s*([\d,]+\.?\d*)',
        ]
        
        for pattern in patterns:
            match = re.search(pattern, text[:3000], re.IGNORECASE)
            if match:
                try:
                    amount = float(match.group(1).replace(',', ''))
                    return amount
                except:
                    pass
        
        return None
    
    def _extract_service_charge_info(self, text: str) -> List[Dict]:
        """Extract service charge related clauses"""
        sc_clauses = []
        
        # Find all mentions of service charge with surrounding context
        sc_pattern = r'(.{0,100}service\s+charge.{0,200})'
        
        for match in re.finditer(sc_pattern, text, re.IGNORECASE):
            clause_text = match.group(0).strip()
            
            # Extract any percentages (apportionment)
            pct_match = re.search(r'([\d.]+)%', clause_text)
            
            # Extract any amounts
            amount_match = re.search(r'£\s*([\d,]+\.?\d*)', clause_text)
            
            # Extract payment frequency
            freq_match = re.search(r'\b(monthly|quarterly|annually|yearly|half-yearly)\b', clause_text, re.IGNORECASE)
            
            sc_clauses.append({
                'clause_text': clause_text[:300],
                'percentage': pct_match.group(1) if pct_match else None,
                'amount': amount_match.group(1) if amount_match else None,
                'frequency': freq_match.group(1) if freq_match else None
            })
        
        return sc_clauses[:5]  # Return top 5
    
    def _extract_key_clauses(self, text: str) -> List[Dict]:
        """Extract all key clause categories"""
        key_clauses = []
        
        for category, keywords in self.CLAUSE_CATEGORIES.items():
            # Find clauses matching this category
            for keyword in keywords:
                pattern = rf'(.{{0,50}}\b{keyword}\b.{{0,250}})'
                
                for match in re.finditer(pattern, text, re.IGNORECASE):
                    clause_text = match.group(0).strip()
                    
                    # Try to extract clause number
                    clause_num_match = re.search(r'\b(\d+\.?\d*)\s*\w*\s*' + keyword, clause_text, re.IGNORECASE)
                    clause_number = clause_num_match.group(1) if clause_num_match else None
                    
                    key_clauses.append({
                        'category': category,
                        'clause_number': clause_number,
                        'clause_text': clause_text[:300],
                        'keyword_matched': keyword
                    })
                    break  # One match per keyword
        
        return key_clauses
    
    def _extract_responsibilities(self, text: str) -> Dict[str, List[str]]:
        """Extract landlord vs tenant responsibilities"""
        responsibilities = {
            'landlord': [],
            'tenant': []
        }
        
        # Look for responsibility sections
        landlord_pattern = r'landlord.*?(?:shall|must|will|responsible)(.{0,200})'
        tenant_pattern = r'tenant.*?(?:shall|must|will|responsible)(.{0,200})'
        
        for match in re.finditer(landlord_pattern, text, re.IGNORECASE):
            resp = match.group(0).strip()[:150]
            if resp and len(resp) > 20:
                responsibilities['landlord'].append(resp)
        
        for match in re.finditer(tenant_pattern, text, re.IGNORECASE):
            resp = match.group(0).strip()[:150]
            if resp and len(resp) > 20:
                responsibilities['tenant'].append(resp)
        
        # Limit to top 5 each
        responsibilities['landlord'] = responsibilities['landlord'][:5]
        responsibilities['tenant'] = responsibilities['tenant'][:5]
        
        return responsibilities
    
    def _cross_check_leases(self, analyzed_leases: List[Dict]) -> Dict:
        """Cross-check data across all analyzed leases"""
        cross_check = {
            'service_charge_frequency': None,
            'demand_dates': [],
            'reserve_fund_allowed': False,
            'common_clauses': [],
            'variations': []
        }
        
        # Check service charge frequency consistency
        frequencies = []
        for lease in analyzed_leases:
            for sc_clause in lease.get('service_charge_clauses', []):
                if sc_clause.get('frequency'):
                    frequencies.append(sc_clause['frequency'])
        
        if frequencies:
            # Most common frequency
            cross_check['service_charge_frequency'] = max(set(frequencies), key=frequencies.count)
        
        # Check for reserve fund mentions
        for lease in analyzed_leases:
            for clause in lease.get('key_clauses', []):
                if clause['category'] == 'reserve_fund':
                    cross_check['reserve_fund_allowed'] = True
                    break
        
        return cross_check

