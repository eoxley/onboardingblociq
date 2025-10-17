"""
Data Deduplicator
=================
Filters extracted data to keep only MOST RECENT/CURRENT versions
No historical duplicates in SQL output
"""

from typing import Dict, List, Any
from datetime import datetime


class DataDeduplicator:
    """
    Deduplicate extracted data - keep only current/most recent
    
    Rules:
    - Compliance assets: One per asset_type (most recent assessment_date)
    - Budgets: Only current budget year
    - Accounts: Only most recent approved accounts
    - Contracts: Only current contracts (not expired)
    """
    
    def __init__(self):
        self.stats = {
            'compliance_before': 0,
            'compliance_after': 0,
            'budgets_before': 0,
            'budgets_after': 0,
            'accounts_before': 0,
            'accounts_after': 0,
        }
    
    def deduplicate_all(self, extracted_data: Dict) -> Dict:
        """
        Deduplicate all extracted data
        Returns filtered data with only current/most recent versions
        """
        print("\n🔍 PHASE 4.5: DEDUPLICATING DATA")
        print("-"*70)
        
        # Deduplicate compliance assets
        extracted_data['compliance_assets'] = self._deduplicate_compliance(
            extracted_data.get('compliance_assets', [])
        )
        
        # Deduplicate budgets
        extracted_data['budgets'] = self._deduplicate_budgets(
            extracted_data.get('budgets', [])
        )
        
        # Deduplicate accounts
        extracted_data['accounts'] = self._deduplicate_accounts(
            extracted_data.get('accounts', [])
        )
        
        # Filter contracts to current only
        extracted_data['contracts'] = self._filter_current_contracts(
            extracted_data.get('contracts', [])
        )
        
        self._print_summary()
        
        return extracted_data
    
    def _deduplicate_compliance(self, assets: List[Dict]) -> List[Dict]:
        """
        Keep only ONE compliance asset per asset_type
        Priority: is_current=True > most recent assessment_date > highest authority_score
        """
        self.stats['compliance_before'] = len(assets)
        
        # Group by asset_type
        by_type = {}
        for asset in assets:
            asset_type = asset.get('asset_type', 'Unknown')
            if asset_type not in by_type:
                by_type[asset_type] = []
            by_type[asset_type].append(asset)
        
        # Keep best one per type
        deduplicated = []
        for asset_type, asset_list in by_type.items():
            # Sort by: is_current (desc), assessment_date (desc), authority_score (desc)
            sorted_assets = sorted(
                asset_list,
                key=lambda a: (
                    a.get('is_current', False),
                    a.get('assessment_date') or '1900-01-01',
                    a.get('authority_score', 0)
                ),
                reverse=True
            )
            
            # Keep only the best one
            best = sorted_assets[0]
            deduplicated.append(best)
        
        self.stats['compliance_after'] = len(deduplicated)
        
        print(f"   Compliance: {self.stats['compliance_before']} → {self.stats['compliance_after']} (removed {self.stats['compliance_before'] - self.stats['compliance_after']} historical)")
        
        return deduplicated
    
    def _deduplicate_budgets(self, budgets: List[Dict]) -> List[Dict]:
        """
        Keep only the MOST RECENT budget
        Priority: status='final' > status='approved' > most recent year > highest total
        """
        self.stats['budgets_before'] = len(budgets)
        
        if not budgets:
            return []
        
        # Sort by: status (final > approved > draft), year (desc), total (desc)
        status_priority = {'final': 3, 'approved': 2, 'draft': 1}
        
        sorted_budgets = sorted(
            budgets,
            key=lambda b: (
                status_priority.get(b.get('status', 'draft'), 0),
                b.get('budget_year', 0),
                b.get('total_budget', 0)
            ),
            reverse=True
        )
        
        # Keep only the best one
        deduplicated = [sorted_budgets[0]]
        
        self.stats['budgets_after'] = len(deduplicated)
        
        print(f"   Budgets: {self.stats['budgets_before']} → {self.stats['budgets_after']} (kept most recent)")
        
        return deduplicated
    
    def _deduplicate_accounts(self, accounts: List[Dict]) -> List[Dict]:
        """
        Keep only the MOST RECENT APPROVED accounts
        Priority: is_approved=True > is_final=True > most recent year
        """
        self.stats['accounts_before'] = len(accounts)
        
        if not accounts:
            return []
        
        # Filter to approved only first
        approved = [a for a in accounts if a.get('is_approved')]
        
        if not approved:
            # If no approved, take most recent final
            approved = [a for a in accounts if a.get('is_final')]
        
        if not approved:
            # If still nothing, take all
            approved = accounts
        
        # Sort by year (desc)
        sorted_accounts = sorted(
            approved,
            key=lambda a: a.get('financial_year', '0000'),
            reverse=True
        )
        
        # Keep only the most recent
        deduplicated = [sorted_accounts[0]] if sorted_accounts else []
        
        self.stats['accounts_after'] = len(deduplicated)
        
        print(f"   Accounts: {self.stats['accounts_before']} → {self.stats['accounts_after']} (kept most recent approved)")
        
        return deduplicated
    
    def _filter_current_contracts(self, contracts: List[Dict]) -> List[Dict]:
        """
        Keep only CURRENT contracts (not expired)
        """
        before = len(contracts)
        
        current = [c for c in contracts if c.get('is_current', True)]
        
        after = len(current)
        
        print(f"   Contracts: {before} → {after} (removed {before - after} expired)")
        
        return current
    
    def _print_summary(self):
        """Print deduplication summary"""
        total_before = (
            self.stats['compliance_before'] + 
            self.stats['budgets_before'] + 
            self.stats['accounts_before']
        )
        total_after = (
            self.stats['compliance_after'] + 
            self.stats['budgets_after'] + 
            self.stats['accounts_after']
        )
        
        print(f"\n   ✅ Total records: {total_before} → {total_after} (removed {total_before - total_after} duplicates)")

