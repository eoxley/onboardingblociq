"""
Leaseholder Contact Extractor
==============================
Extracts leaseholder names and contact details from:
- Contact forms (including OCR from images)
- Flat correspondence folders
- Property information files
- Lease documents

Links contact details to units
"""

import re
from typing import Dict, List, Optional


class LeaseholderContactExtractor:
    """
    Extract and consolidate leaseholder contact information
    Links to units via flat numbers
    """
    
    def __init__(self):
        self.leaseholder_data = {}  # unit_number -> contact_data
    
    def extract_from_contact_form(self, text: str, document: Dict) -> Optional[Dict]:
        """
        Extract from contact information form
        
        Looks for:
        - Name
        - Address
        - Email
        - Phone/Mobile
        - Unit/Flat number
        """
        if not text:
            return None
        
        # Extract flat/unit number from path or text
        flat_number = self._extract_flat_number(document.get('file_path', ''), text)
        
        if not flat_number:
            return None
        
        # Extract contact details
        name = self._extract_name(text)
        email = self._extract_email(text)
        phone = self._extract_phone(text)
        address = self._extract_address(text)
        
        contact_data = {
            'unit_number': flat_number,
            'leaseholder_name': name,
            'email': email,
            'phone': phone,
            'correspondence_address': address,
            'source': 'contact_form',
            'source_document': document.get('filename'),
            'authority_score': 0.9  # Contact forms are authoritative
        }
        
        # Store in lookup
        self.leaseholder_data[flat_number] = contact_data
        
        return contact_data
    
    def extract_from_lease(self, text: str, document: Dict) -> Optional[Dict]:
        """Extract leaseholder from lease document"""
        if not text:
            return None
        
        # Extract flat number
        flat_number = self._extract_flat_number(document.get('file_path', ''), text)
        
        # Extract tenant/leaseholder name
        name = self._extract_lessee_name(text)
        
        # Extract property address (may contain correspondence address)
        address = self._extract_demised_premises(text)
        
        if flat_number and name:
            contact_data = {
                'unit_number': flat_number,
                'leaseholder_name': name,
                'correspondence_address': address,
                'source': 'lease',
                'authority_score': 0.7  # Leases are good but may be old
            }
            
            # Merge with existing data (higher authority wins)
            if flat_number in self.leaseholder_data:
                self._merge_contact_data(flat_number, contact_data)
            else:
                self.leaseholder_data[flat_number] = contact_data
            
            return contact_data
        
        return None
    
    def _extract_flat_number(self, filepath: str, text: str) -> Optional[str]:
        """Extract flat/unit number from path or text"""
        # Try from filepath: "Flat 7/..." or "Flat 4-Lease/..."
        flat_match = re.search(r'flat\s*(\d+)', filepath, re.IGNORECASE)
        if flat_match:
            return f"Flat {flat_match.group(1)}"
        
        # Try from text
        flat_match = re.search(r'(?:flat|unit|apartment)\s*(?:no\.?|number)?\s*[:.]?\s*(\d+)', text, re.IGNORECASE)
        if flat_match:
            return f"Flat {flat_match.group(1)}"
        
        return None
    
    def _extract_name(self, text: str) -> Optional[str]:
        """Extract leaseholder name from contact form"""
        # Look for name fields
        patterns = [
            r'name:?\s*([A-Z][A-Za-z\s]+(?:[A-Z][A-Za-z]+))',  # "Name: John Smith"
            r'leaseholder:?\s*([A-Z][A-Za-z\s]+)',
            r'tenant:?\s*([A-Z][A-Za-z\s]+)',
            r'mr\s+([A-Z][A-Za-z\s]+)',
            r'mrs\s+([A-Z][A-Za-z\s]+)',
            r'ms\s+([A-Z][A-Za-z\s]+)',
        ]
        
        for pattern in patterns:
            match = re.search(pattern, text[:2000], re.IGNORECASE)
            if match:
                name = match.group(1).strip()
                if len(name) > 3:
                    return name[:100]
        
        return None
    
    def _extract_email(self, text: str) -> Optional[str]:
        """Extract email address"""
        pattern = r'\b[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Z|a-z]{2,}\b'
        match = re.search(pattern, text)
        if match:
            return match.group(0)
        return None
    
    def _extract_phone(self, text: str) -> Optional[str]:
        """Extract phone number (UK format)"""
        patterns = [
            r'(?:phone|tel|mobile):?\s*(\+?44\s*\d{10})',  # +44 format
            r'(?:phone|tel|mobile):?\s*(0\d{10})',  # 07... format
            r'(\d{5}\s?\d{6})',  # UK landline
            r'(0\d{4}\s?\d{6})',  # Various UK formats
        ]
        
        for pattern in patterns:
            match = re.search(pattern, text, re.IGNORECASE)
            if match:
                return match.group(1).strip()
        
        return None
    
    def _extract_address(self, text: str) -> Optional[str]:
        """Extract correspondence address"""
        # Look for address fields
        patterns = [
            r'address:?\s*([^\n]{10,150})',
            r'correspondence\s+address:?\s*([^\n]{10,150})',
        ]
        
        for pattern in patterns:
            match = re.search(pattern, text, re.IGNORECASE)
            if match:
                addr = match.group(1).strip()
                if len(addr) > 10:
                    return addr[:200]
        
        return None
    
    def _extract_lessee_name(self, text: str) -> Optional[str]:
        """Extract lessee/tenant name from lease"""
        patterns = [
            r'lessee:?\s*([A-Z][A-Za-z\s]+)',
            r'tenant:?\s*([A-Z][A-Za-z\s]+)',
        ]
        
        for pattern in patterns:
            match = re.search(pattern, text[:5000], re.IGNORECASE)
            if match:
                return match.group(1).strip()[:100]
        
        return None
    
    def _extract_demised_premises(self, text: str) -> Optional[str]:
        """Extract demised premises/property address from lease"""
        pattern = r'demised\s+premises:?\s*([^\n]{10,150})'
        match = re.search(pattern, text[:5000], re.IGNORECASE)
        if match:
            return match.group(1).strip()[:200]
        return None
    
    def _merge_contact_data(self, flat_number: str, new_data: Dict):
        """Merge contact data with authority scoring"""
        existing = self.leaseholder_data[flat_number]
        
        # Merge fields based on authority score
        for field in ['leaseholder_name', 'email', 'phone', 'correspondence_address']:
            new_value = new_data.get(field)
            existing_value = existing.get(field)
            
            if new_value:
                if not existing_value or new_data['authority_score'] >= existing['authority_score']:
                    existing[field] = new_value
    
    def enrich_units(self, units: List[Dict]) -> List[Dict]:
        """
        Enrich units with leaseholder contact data
        Links by flat number matching
        """
        enriched = []
        
        for unit in units:
            unit_number = unit.get('unit_number', '')
            
            # Try to match with collected leaseholder data
            # Match by flat number (e.g., "219-01-007" contains "Flat 7")
            matched_data = None
            
            for flat_key, leaseholder in self.leaseholder_data.items():
                # Extract number from flat key and unit number
                flat_num = re.search(r'\d+', flat_key)
                unit_num = re.search(r'0*(\d+)$', unit_number)  # Get last digits
                
                if flat_num and unit_num:
                    if flat_num.group(0) == unit_num.group(1):
                        matched_data = leaseholder
                        break
            
            # Enrich unit with leaseholder data
            if matched_data:
                unit['leaseholder_name'] = matched_data.get('leaseholder_name')
                unit['email'] = matched_data.get('email')
                unit['phone'] = matched_data.get('phone')
                if not unit.get('correspondence_address'):
                    unit['correspondence_address'] = matched_data.get('correspondence_address')
            
            enriched.append(unit)
        
        return enriched
    
    def print_summary(self):
        """Print leaseholder extraction summary"""
        print(f"\n👥 LEASEHOLDER DATA SUMMARY:")
        print(f"   Contact details found for: {len(self.leaseholder_data)} units")
        
        for flat, data in sorted(self.leaseholder_data.items()):
            print(f"   • {flat}: {data.get('leaseholder_name', 'No name')}")
            if data.get('email'):
                print(f"     Email: {data['email']}")
            if data.get('phone'):
                print(f"     Phone: {data['phone']}")

