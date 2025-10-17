"""
Budget Contractor Extractor
===========================
Extracts contractor names from budget PM Comments field
The most accurate source for contractor information
"""

import re
from typing import Optional


class BudgetContractorExtractor:
    """
    Extract contractor names from budget line item notes/comments
    Patterns: "contract with ABC Ltd", "currently with XYZ", etc.
    """
    
    def extract_contractor_from_notes(self, notes: str) -> Optional[str]:
        """
        Extract contractor name from PM comments/notes
        
        Examples:
        - "This is the current cleaning contract with New Step"
        - "This contract is with Jacksons Lift"
        - "currently with Positive Energy"
        - "The contract is with Water Hygiene Maintenance"
        """
        if not notes:
            return None
        
        # Patterns for contractor extraction
        patterns = [
            # "contract with ABC Ltd"
            r'contract\s+(?:is\s+)?with\s+([A-Z][A-Za-z\s&]+(?:Ltd|Limited|LLP|PLC|Services|Maintenance|Energy|Power)?)',
            
            # "currently with ABC"
            r'currently\s+with\s+([A-Z][A-Za-z\s&]+(?:Ltd|Limited|LLP|PLC|Services|Maintenance|Energy|Power)?)',
            
            # "by ABC Ltd" or "by ABC Maintenance"
            r'by\s+([A-Z][A-Za-z\s&]+(?:Ltd|Limited|LLP|PLC|Services|Maintenance|Cleaning|Lift))',
            
            # "with ABC which consists"
            r'with\s+([A-Z][A-Za-z\s&]+)\s+which',
            
            # "ABC Ltd charge" or "ABC provides"
            r'([A-Z][A-Za-z\s&]+(?:Ltd|Limited|LLP|Services))\s+(?:charge|provide)',
        ]
        
        for pattern in patterns:
            match = re.search(pattern, notes, re.IGNORECASE)
            if match:
                contractor = match.group(1).strip()
                
                # Clean up contractor name
                contractor = self._clean_contractor_name(contractor)
                
                # Validate it's not a generic word
                if self._is_valid_contractor(contractor):
                    return contractor
        
        return None
    
    def _clean_contractor_name(self, name: str) -> str:
        """Clean up extracted contractor name"""
        # Remove trailing words that aren't part of the name
        cleanup_words = [
            ' who charge', ' which consists', ' and is', ' and are',
            ' charge a', ' this is', ' who are', ' who provide',
            ' and have', ' ad have'  # typo in actual data
        ]
        
        for word in cleanup_words:
            if word in name.lower():
                name = name[:name.lower().index(word)]
        
        # Capitalize properly
        name = ' '.join(word.capitalize() for word in name.split())
        
        # Fix common company suffixes
        name = re.sub(r'\bLtd\b', 'Ltd', name, flags=re.IGNORECASE)
        name = re.sub(r'\bLimited\b', 'Limited', name, flags=re.IGNORECASE)
        name = re.sub(r'\bLlp\b', 'LLP', name, flags=re.IGNORECASE)
        
        return name.strip()
    
    def _is_valid_contractor(self, name: str) -> bool:
        """Validate contractor name is not a generic word"""
        if not name or len(name) < 3:
            return False
        
        # Reject generic words
        invalid_words = [
            'the', 'this', 'that', 'with', 'from', 'and', 'or',
            'gas', 'cleaning', 'lift', 'boiler', 'heating',
            'service', 'contract', 'maintenance', 'currently'
        ]
        
        name_lower = name.lower().strip()
        
        if name_lower in invalid_words:
            return False
        
        # Must have at least one letter
        if not re.search(r'[a-zA-Z]', name):
            return False
        
        return True

