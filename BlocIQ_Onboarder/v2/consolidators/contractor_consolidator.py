"""
Contractor Consolidator
=======================
Removes duplicates, aggregates services per contractor
Sources: budgets, contracts, invoices, property bible

One entry per unique contractor with all services listed
"""

import re
from typing import Dict, List, Set, Optional
from difflib import SequenceMatcher
import sys
import os
sys.path.insert(0, os.path.dirname(__file__) + '/../extractors')
from budget_contractor_extractor import BudgetContractorExtractor


class ContractorConsolidator:
    """
    Consolidate contractors from multiple sources
    Remove duplicates (fuzzy matching)
    Aggregate all services per contractor
    """
    
    def __init__(self):
        self.contractors = {}  # canonical_name -> contractor_data
        self.aliases = {}  # alias -> canonical_name
        self.budget_contractor_extractor = BudgetContractorExtractor()
    
    def add_from_budget(self, budget_line_items: List[Dict]):
        """Extract contractors from budget line items - ENHANCED to use PM Comments"""
        for item in budget_line_items:
            description = item.get('description', '')
            category = item.get('category', '')
            amount = item.get('annual_amount', 0)
            notes = item.get('notes', '')  # PM Comments - THE KEY SOURCE!
            
            # Skip utilities/insurance providers (not maintenance contractors)
            if category in ['insurance', 'professional_fees', 'management']:
                continue
            
            # PRIORITY 1: Extract from notes/PM Comments (most accurate!)
            contractor_name = None
            if notes:
                contractor_name = self.budget_contractor_extractor.extract_contractor_from_notes(notes)
            
            # FALLBACK: Try description if notes don't have contractor
            if not contractor_name:
                contractor_match = re.search(r'([A-Z][A-Za-z\s&]+(?:Ltd|Limited|LLP|Services))', description)
                if contractor_match:
                    contractor_name = contractor_match.group(1).strip()
            
            # Add contractor if found
            if contractor_name:
                service_type = category or self._infer_service_from_description(description)
                
                self._add_contractor(
                    contractor_name,
                    service_type,
                    source='budget',
                    annual_value=amount
                )
    
    def _infer_service_from_description(self, description: str) -> str:
        """Infer service type from description"""
        desc_lower = description.lower()
        
        if 'clean' in desc_lower:
            return 'cleaning'
        elif 'lift' in desc_lower or 'elevator' in desc_lower:
            return 'lifts'
        elif 'heat' in desc_lower or 'boiler' in desc_lower:
            return 'heating'
        elif 'fire' in desc_lower:
            return 'fire_safety'
        elif 'garden' in desc_lower or 'landscape' in desc_lower:
            return 'gardening'
        elif 'drain' in desc_lower or 'gutter' in desc_lower:
            return 'drainage'
        elif 'pest' in desc_lower:
            return 'pest_control'
        elif 'water' in desc_lower or 'hygiene' in desc_lower:
            return 'water_hygiene'
        elif 'light' in desc_lower:
            return 'lighting'
        else:
            return 'general'
    
    def add_from_contracts(self, contracts: List[Dict]):
        """Extract contractors from contract documents"""
        for contract in contracts:
            contractor_name = (
                contract.get('contractor_name') or
                contract.get('company_name') or
                contract.get('name')
            )
            
            if not contractor_name or contractor_name == 'N/A':
                continue
            
            service_type = (
                contract.get('service_type') or
                contract.get('contract_type') or
                'General'
            )
            
            contract_start = contract.get('start_date')
            contract_end = contract.get('end_date')
            contract_value = contract.get('annual_value') or contract.get('contract_value')
            
            self._add_contractor(
                contractor_name,
                service_type,
                source='contract',
                contract_start=contract_start,
                contract_end=contract_end,
                annual_value=contract_value
            )
    
    def add_from_property_bible(self, contractors: List[Dict]):
        """Add contractors from Property Bible"""
        for contractor in contractors:
            contractor_name = contractor.get('company_name')
            service_type = contractor.get('service', 'General')
            
            if contractor_name and contractor_name != 'N/A':
                self._add_contractor(
                    contractor_name,
                    service_type,
                    source='property_bible',
                    last_service_date=contractor.get('last_date')
                )
    
    def _add_contractor(self, name: str, service: str, source: str, **metadata):
        """
        Add contractor with fuzzy deduplication
        
        Handles aliases like:
        - "New Step" vs "New Step Ltd" vs "New Step Cleaning Ltd"
        - "ISS" vs "ISS Facility Services Ltd"
        """
        # Clean name
        name_clean = name.strip()
        
        # Find canonical name (check for aliases)
        canonical = self._find_canonical_name(name_clean)
        
        if canonical not in self.contractors:
            self.contractors[canonical] = {
                'canonical_name': canonical,
                'aliases': set(),
                'services': set(),
                'sources': set(),
                'contract_start': None,
                'contract_end': None,
                'annual_value': 0,
                'last_service_date': None,
                'contact_details': {}
            }
        
        contractor = self.contractors[canonical]
        
        # Add alias if different
        if name_clean != canonical:
            contractor['aliases'].add(name_clean)
        
        # Add service
        contractor['services'].add(service.lower().strip())
        contractor['sources'].add(source)
        
        # Update metadata
        if metadata.get('contract_start'):
            contractor['contract_start'] = metadata['contract_start']
        if metadata.get('contract_end'):
            contractor['contract_end'] = metadata['contract_end']
        if metadata.get('annual_value'):
            contractor['annual_value'] += metadata['annual_value']
        if metadata.get('last_service_date'):
            contractor['last_service_date'] = metadata['last_service_date']
    
    def _find_canonical_name(self, name: str) -> str:
        """
        Find canonical name for contractor (fuzzy matching)
        Handles variations like "New Step" vs "New Step Ltd"
        """
        # Check exact match
        if name in self.contractors:
            return name
        
        # Check aliases
        if name in self.aliases:
            return self.aliases[name]
        
        # Fuzzy match against existing contractors
        name_lower = name.lower()
        name_core = self._extract_core_name(name_lower)
        
        for canonical in self.contractors.keys():
            canonical_core = self._extract_core_name(canonical.lower())
            
            # If core names match, it's the same contractor
            if name_core == canonical_core:
                self.aliases[name] = canonical
                return canonical
            
            # If very similar (>0.85 similarity), same contractor
            similarity = SequenceMatcher(None, name_lower, canonical.lower()).ratio()
            if similarity > 0.85:
                self.aliases[name] = canonical
                return canonical
        
        # New contractor
        return name
    
    def _extract_core_name(self, name: str) -> str:
        """
        Extract core company name (remove Ltd, Limited, etc.)
        "New Step Cleaning Ltd" -> "new step cleaning"
        """
        # Remove common suffixes
        core = re.sub(r'\b(ltd|limited|llp|plc|services|limited company)\b', '', name, flags=re.IGNORECASE)
        core = re.sub(r'\s+', ' ', core).strip()
        return core
    
    def get_consolidated_contractors(self) -> List[Dict]:
        """
        Get final consolidated contractor list
        One entry per unique contractor with all services
        """
        consolidated = []
        
        for canonical, data in self.contractors.items():
            contractor = {
                'contractor_name': data['canonical_name'],
                'services_provided': sorted(list(data['services'])),
                'aliases': sorted(list(data['aliases'])),
                'sources': sorted(list(data['sources'])),
                'contract_start_date': data['contract_start'],
                'contract_end_date': data['contract_end'],
                'annual_value': data['annual_value'],
                'last_service_date': data['last_service_date'],
                'is_active': self._is_contract_active(data['contract_end']),
                'service_count': len(data['services'])
            }
            
            consolidated.append(contractor)
        
        # Sort by service count (most services first)
        consolidated.sort(key=lambda x: -x['service_count'])
        
        return consolidated
    
    def _is_contract_active(self, end_date: Optional[str]) -> bool:
        """Check if contract is still active"""
        if not end_date:
            return True  # Assume active if no end date
        
        try:
            from datetime import datetime
            end = datetime.strptime(end_date, '%Y-%m-%d')
            return end >= datetime.now()
        except:
            return True
    
    def print_summary(self):
        """Print consolidation summary"""
        contractors = self.get_consolidated_contractors()
        
        print(f"\n👷 CONTRACTOR CONSOLIDATION SUMMARY:")
        print(f"   Total unique contractors: {len(contractors)}")
        print(f"   Total aliases resolved: {len(self.aliases)}")
        print()
        
        for contractor in contractors[:10]:
            print(f"   • {contractor['contractor_name']}")
            print(f"     Services: {', '.join(contractor['services_provided'])}")
            if contractor['aliases']:
                print(f"     Aliases: {', '.join(list(contractor['aliases'])[:3])}")
            if contractor['annual_value'] > 0:
                print(f"     Annual value: £{contractor['annual_value']:,.0f}")
        
        if len(contractors) > 10:
            print(f"   ... and {len(contractors) - 10} more contractors")

