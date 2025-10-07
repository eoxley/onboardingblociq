"""
BlocIQ Onboarder - Contractor Deduplication
Prevents duplicate contractor entries by matching company names
"""

import re
from typing import Dict, List, Optional
from rapidfuzz import fuzz


class ContractorDeduplicator:
    """Deduplicates contractors by company name matching"""

    def __init__(self, existing_contractors: List[Dict] = None):
        """
        Initialize deduplicator

        Args:
            existing_contractors: List of existing contractor records from database
        """
        self.existing_contractors = existing_contractors or []
        self.contractor_cache = {}
        self._build_cache()

    def _build_cache(self):
        """Build normalized name cache for fast lookups"""
        for contractor in self.existing_contractors:
            company_name = contractor.get('company_name', '')
            if company_name:
                normalized = self._normalize_company_name(company_name)
                self.contractor_cache[normalized] = contractor

    def find_match(self, contractor_data: Dict) -> Optional[Dict]:
        """
        Find matching existing contractor

        Args:
            contractor_data: Contractor dict to check

        Returns:
            Matching contractor dict if found, None otherwise
        """
        company_name = contractor_data.get('company_name', '')
        if not company_name:
            return None

        # Normalize incoming name
        normalized_name = self._normalize_company_name(company_name)

        # Exact match check
        if normalized_name in self.contractor_cache:
            return self.contractor_cache[normalized_name]

        # Fuzzy match check (threshold: 85% similarity)
        for cached_name, contractor in self.contractor_cache.items():
            similarity = fuzz.ratio(normalized_name, cached_name)
            if similarity >= 85:
                return contractor

        return None

    def deduplicate(self, new_contractors: List[Dict]) -> Dict[str, List[Dict]]:
        """
        Deduplicate a list of contractors

        Args:
            new_contractors: List of contractor dicts to deduplicate

        Returns:
            Dict with 'new' and 'existing' lists
        """
        result = {
            'new': [],
            'existing': [],
            'updated': []
        }

        for contractor in new_contractors:
            match = self.find_match(contractor)

            if match:
                # Contractor already exists
                result['existing'].append({
                    'new': contractor,
                    'match': match
                })

                # Check if we should update existing record with new info
                if self._should_update(match, contractor):
                    updated = self._merge_contractor_data(match, contractor)
                    result['updated'].append(updated)

            else:
                # New contractor
                result['new'].append(contractor)
                # Add to cache for subsequent checks in this batch
                normalized = self._normalize_company_name(contractor.get('company_name', ''))
                if normalized:
                    self.contractor_cache[normalized] = contractor

        return result

    def _should_update(self, existing: Dict, new: Dict) -> bool:
        """Determine if existing record should be updated with new data"""

        # Update if new record has more information
        new_fields = [k for k, v in new.items() if v and k not in ['id', 'created_at', 'updated_at']]
        existing_fields = [k for k, v in existing.items() if v and k not in ['id', 'created_at', 'updated_at']]

        # If new record has more populated fields, consider updating
        return len(new_fields) > len(existing_fields)

    def _merge_contractor_data(self, existing: Dict, new: Dict) -> Dict:
        """Merge new data into existing contractor record"""

        merged = existing.copy()

        # Update fields that are empty in existing but present in new
        for key, value in new.items():
            if key in ['id', 'created_at']:
                continue  # Don't update these

            if not merged.get(key) and value:
                merged[key] = value

            # Special handling for accreditations - merge arrays
            elif key == 'accreditations' and isinstance(value, list):
                existing_accreds = merged.get('accreditations', [])
                if isinstance(existing_accreds, list):
                    # Merge and deduplicate
                    all_accreds = list(set(existing_accreds + value))
                    merged['accreditations'] = all_accreds

        return merged

    def _normalize_company_name(self, company_name: str) -> str:
        """
        Normalize company name for matching

        Removes:
        - Legal suffixes (Ltd, Limited, plc, etc.)
        - Punctuation
        - Extra whitespace
        - Case differences
        """
        if not company_name:
            return ''

        # Handle non-string input
        if not isinstance(company_name, str):
            return ''

        normalized = company_name.lower().strip()

        # Remove common legal suffixes
        suffixes = [
            r'\s+ltd\.?$',
            r'\s+limited$',
            r'\s+plc\.?$',
            r'\s+llc\.?$',
            r'\s+llp\.?$',
            r'\s+inc\.?$',
            r'\s+corp\.?$',
            r'\s+co\.?$',
            r'\s+&\s+co\.?$'
        ]

        for suffix_pattern in suffixes:
            normalized = re.sub(suffix_pattern, '', normalized, flags=re.IGNORECASE)

        # Remove punctuation except &
        normalized = re.sub(r'[^\w\s&]', '', normalized)

        # Remove extra whitespace
        normalized = ' '.join(normalized.split())

        return normalized

    def link_contractor_to_building(self, contractor_id: str, building_id: str,
                                     relationship_type: str = 'service_provider',
                                     is_preferred: bool = False) -> Dict:
        """
        Create building-contractor link record

        Args:
            contractor_id: Contractor UUID
            building_id: Building UUID
            relationship_type: Type of relationship (service_provider, consultant, etc.)
            is_preferred: Whether this is a preferred contractor

        Returns:
            building_contractors record dict
        """
        import uuid

        return {
            'id': str(uuid.uuid4()),
            'building_id': building_id,
            'contractor_id': contractor_id,
            'relationship_type': relationship_type,
            'is_preferred': is_preferred,
            'notes': None
        }

    def get_contractor_by_name(self, company_name: str) -> Optional[Dict]:
        """
        Get contractor by company name (normalized matching)

        Args:
            company_name: Company name to search

        Returns:
            Contractor dict if found
        """
        normalized = self._normalize_company_name(company_name)
        return self.contractor_cache.get(normalized)

    def add_contractor(self, contractor: Dict):
        """
        Add contractor to cache (after successful insert)

        Args:
            contractor: Contractor dict with id
        """
        company_name = contractor.get('company_name', '')
        if company_name:
            normalized = self._normalize_company_name(company_name)
            self.contractor_cache[normalized] = contractor


# Helper function for standalone usage
def deduplicate_contractors(new_contractors: List[Dict],
                            existing_contractors: List[Dict] = None) -> Dict[str, List[Dict]]:
    """
    Convenience function for deduplication

    Args:
        new_contractors: List of new contractor dicts
        existing_contractors: List of existing contractor dicts from database

    Returns:
        Dict with 'new', 'existing', and 'updated' lists
    """
    deduplicator = ContractorDeduplicator(existing_contractors)
    return deduplicator.deduplicate(new_contractors)
