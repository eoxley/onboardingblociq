"""
Contractor Name Validator
=========================
Filters out garbage text extracted from contracts
Ensures only real contractor names are kept
"""

import re
from typing import Optional


class ContractorNameValidator:
    """
    Validate contractor names to filter garbage text
    
    Rejects:
    - Clause text ("s and each contractor engaged...")
    - Generic words ("Gas", "Cleaning")
    - Incomplete extractions
    - Contract boilerplate
    """
    
    # Patterns that indicate garbage text (not real contractor names)
    GARBAGE_PATTERNS = [
        r'^s and',  # "s and each contractor"
        r'^is undertaking',  # "is undertaking works"
        r'^shall',  # "shall provide"
        r'^must',  # "must consult"
        r'^should',  # "should take"
        r'^asked',  # "asked voestalpine"
        r'^or consultants',  # "or consultants are"
        r'engaged to provide',  # Contract clause text
        r'in respect of',  # Contract clause text
        r'undertaking works',  # Contract clause text
        r'necessary steps',  # Contract clause text
        r'hereby',  # Legal text
        r'whereas',  # Legal text
    ]
    
    # Single generic words (not contractor names)
    GENERIC_WORDS = [
        'gas', 'cleaning', 'lift', 'lifts', 'boiler', 'heating',
        'security', 'maintenance', 'service', 'contract', 'the',
        'this', 'that', 'with', 'from', 'and', 'or'
    ]
    
    # Minimum requirements for valid contractor name
    MIN_LENGTH = 3
    MAX_LENGTH = 100
    
    def is_valid_contractor(self, name: Optional[str]) -> bool:
        """
        Check if contractor name is valid
        
        Returns:
            True if valid contractor name
            False if garbage text or invalid
        """
        if not name:
            return False
        
        name = name.strip()
        
        # Length checks
        if len(name) < self.MIN_LENGTH or len(name) > self.MAX_LENGTH:
            return False
        
        # Check for garbage patterns
        name_lower = name.lower()
        for pattern in self.GARBAGE_PATTERNS:
            if re.search(pattern, name_lower):
                return False
        
        # Check if it's just a generic word
        if name_lower in self.GENERIC_WORDS:
            return False
        
        # Must contain at least one letter
        if not re.search(r'[a-zA-Z]', name):
            return False
        
        # Reject if it's mostly lowercase (likely clause text)
        # Real company names usually have capitals
        if name[0].islower():
            return False
        
        # Reject if contains too many lowercase words (likely sentence fragment)
        words = name.split()
        lowercase_words = sum(1 for w in words if w.islower() and len(w) > 2)
        if len(words) > 3 and lowercase_words > len(words) / 2:
            return False
        
        # Looks valid!
        return True
    
    def filter_contractors(self, contractors: list) -> list:
        """
        Filter contractor list to remove invalid names
        
        Args:
            contractors: List of contractor dicts
        
        Returns:
            Filtered list with only valid contractors
        """
        valid_contractors = []
        
        for contractor in contractors:
            name = contractor.get('contractor_name', '')
            
            if self.is_valid_contractor(name):
                valid_contractors.append(contractor)
        
        return valid_contractors
    
    def print_filtering_summary(self, before: list, after: list):
        """Print filtering summary"""
        removed = len(before) - len(after)
        
        if removed > 0:
            print(f"\n   🔍 Contractor Validation:")
            print(f"      Before: {len(before)} contractors")
            print(f"      After: {len(after)} contractors")
            print(f"      Filtered out: {removed} invalid names")

