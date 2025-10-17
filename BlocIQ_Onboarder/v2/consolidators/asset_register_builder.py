"""
Asset Register Builder
======================
Creates comprehensive asset register for property management
Master list of "what the building is made of" and "what needs maintaining"

Consolidates from multiple sources:
- H&S reports (FRA, EICR, etc.)
- Compliance assessments
- Contract documents
- Budget line items
- Building description documents
"""

from typing import Dict, List, Optional
from datetime import datetime


class AssetRegisterBuilder:
    """
    Build comprehensive asset register from all extracted data
    Structured for property management use
    """
    
    def __init__(self):
        self.assets = {}  # asset_key -> asset_data
    
    def build_register(self, extracted_data: Dict) -> List[Dict]:
        """
        Build complete asset register from all sources
        
        Each asset includes:
        - Asset Name (e.g., "Passenger Lift", "Fire Alarm System")
        - Asset Type/Category (Mechanical, Electrical, Fire Safety, etc.)
        - Location (if known)
        - Quantity
        - Install Date / Age
        - Manufacturer / Model
        - Last Inspection Date
        - Next Inspection Due
        - Maintenance Frequency
        - Responsible Contractor
        - Compliance Status
        - Replacement Date (expected)
        - Estimated Value
        - Condition
        - Notes
        """
        
        # Source 1: H&S reports (basic asset detection)
        hs_assets = extracted_data.get('asset_register', [])
        for asset in hs_assets:
            self._add_asset_basic(asset)
        
        # Source 2: Compliance assets (add inspection dates)
        compliance_assets = extracted_data.get('compliance_assets', [])
        for compliance in compliance_assets:
            self._enhance_with_compliance(compliance)
        
        # Source 3: Maintenance contracts (add contractor and frequency)
        contracts = extracted_data.get('contracts', [])
        for contract in contracts:
            self._enhance_with_contract(contract)
        
        # Source 4: Budget line items (add costs)
        budgets = extracted_data.get('budgets', [])
        for budget in budgets:
            for line_item in budget.get('line_items', []):
                self._enhance_with_budget(line_item)
        
        # Return final register
        return self.get_final_register()
    
    def _add_asset_basic(self, asset: Dict):
        """Add basic asset from H&S report detection"""
        asset_name = asset.get('asset_name', 'Unknown')
        asset_key = self._generate_asset_key(asset_name)
        
        if asset_key not in self.assets:
            self.assets[asset_key] = {
                'asset_name': asset_name,
                'asset_type': asset.get('asset_type', 'general'),
                'category': self._categorize_for_pm(asset.get('asset_type', 'general')),
                'quantity': asset.get('quantity', 1),
                'location': None,
                'install_date': None,
                'age_years': None,
                'manufacturer': None,
                'model': None,
                'last_inspection_date': None,
                'next_inspection_due': None,
                'maintenance_frequency': None,
                'responsible_contractor': None,
                'compliance_status': None,
                'replacement_due': None,
                'estimated_value': None,
                'condition': None,
                'annual_maintenance_cost': None,
                'notes': [],
                'sources': ['hs_report']
            }
    
    def _enhance_with_compliance(self, compliance: Dict):
        """Enhance asset with compliance inspection data"""
        asset_type = compliance.get('asset_type', '')
        asset_key = self._generate_asset_key(asset_type)
        
        # Create asset if doesn't exist
        if asset_key not in self.assets:
            self.assets[asset_key] = {
                'asset_name': asset_type,
                'asset_type': compliance.get('asset_key', 'general'),
                'category': self._categorize_for_pm(compliance.get('asset_key', 'general')),
                'quantity': 1,
                'location': None,
                'sources': []
            }
        
        asset = self.assets[asset_key]
        
        # Add compliance data
        asset['last_inspection_date'] = compliance.get('assessment_date')
        asset['next_inspection_due'] = compliance.get('next_due_date')
        asset['compliance_status'] = compliance.get('status')
        asset['responsible_contractor'] = compliance.get('assessor_company')
        
        # Determine maintenance frequency from compliance cycle
        frequency_map = {
            'fire_risk_assessment': 'Annual',
            'eicr': 'Every 5 years',
            'legionella': 'Every 24 months',
            'lift_loler': 'Every 6 months',
            'gas_safety': 'Annual',
            'asbestos': 'Annual re-inspection',
            'fire_door_inspection': 'Annual',
            'emergency_lighting': 'Annual',
        }
        asset['maintenance_frequency'] = frequency_map.get(compliance.get('asset_key'), 'As per regulations')
        
        if 'compliance' not in asset['sources']:
            asset['sources'].append('compliance')
    
    def _enhance_with_contract(self, contract: Dict):
        """Enhance asset with contract/contractor data"""
        service_type = contract.get('service_type', '').lower()
        
        # Map service type to asset
        asset_mappings = {
            'lifts': 'Passenger Lift',
            'lift': 'Passenger Lift',
            'cleaning': 'Cleaning Service',
            'security': 'Security System',
            'mne': 'M&E Systems',
            'fire': 'Fire Safety Systems',
            'heating': 'Heating System',
            'boiler': 'Boiler',
        }
        
        asset_name = None
        for key, name in asset_mappings.items():
            if key in service_type:
                asset_name = name
                break
        
        if not asset_name:
            return
        
        asset_key = self._generate_asset_key(asset_name)
        
        # Create or enhance
        if asset_key not in self.assets:
            self.assets[asset_key] = {
                'asset_name': asset_name,
                'asset_type': service_type,
                'category': 'Service',
                'quantity': 1,
                'sources': []
            }
        
        asset = self.assets[asset_key]
        asset['responsible_contractor'] = contract.get('contractor_name')
        asset['maintenance_frequency'] = contract.get('frequency', 'As per contract')
        
        if contract.get('contract_value'):
            asset['annual_maintenance_cost'] = contract.get('contract_value')
        
        if 'contract' not in asset['sources']:
            asset['sources'].append('contract')
    
    def _enhance_with_budget(self, line_item: Dict):
        """Enhance asset with budget cost data"""
        description = line_item.get('description', '').lower()
        category = line_item.get('category', '')
        amount = line_item.get('annual_amount', 0)
        
        # Map budget items to assets
        asset_mappings = {
            'lift': 'Passenger Lift',
            'elevator': 'Passenger Lift',
            'fire': 'Fire Safety Systems',
            'heating': 'Heating System',
            'boiler': 'Boiler',
            'clean': 'Cleaning Service',
            'garden': 'Gardening/Landscaping',
            'drain': 'Drainage System',
            'gutter': 'Guttering',
            'light': 'Lighting System',
            'water': 'Water Systems',
            'pest': 'Pest Control',
            'asbestos': 'Asbestos Management',
        }
        
        asset_name = None
        for key, name in asset_mappings.items():
            if key in description:
                asset_name = name
                break
        
        if not asset_name:
            return
        
        asset_key = self._generate_asset_key(asset_name)
        
        if asset_key not in self.assets:
            self.assets[asset_key] = {
                'asset_name': asset_name,
                'asset_type': category,
                'category': category,
                'quantity': 1,
                'sources': []
            }
        
        asset = self.assets[asset_key]
        asset['annual_maintenance_cost'] = amount
        
        if 'budget' not in asset['sources']:
            asset['sources'].append('budget')
    
    def _generate_asset_key(self, asset_name: str) -> str:
        """Generate unique key for asset"""
        return asset_name.lower().replace(' ', '_').replace('/', '_')
    
    def _categorize_for_pm(self, asset_type: str) -> str:
        """Categorize for property management purposes"""
        type_lower = asset_type.lower()
        
        if 'fire' in type_lower:
            return 'Fire Safety'
        elif 'electrical' in type_lower or 'light' in type_lower:
            return 'Electrical'
        elif 'lift' in type_lower or 'elevator' in type_lower:
            return 'Mechanical - Lifts'
        elif 'boiler' in type_lower or 'heating' in type_lower or 'plant' in type_lower:
            return 'Mechanical - Plant'
        elif 'water' in type_lower or 'legionella' in type_lower:
            return 'Water Systems'
        elif 'security' in type_lower or 'cctv' in type_lower:
            return 'Security'
        elif 'asbestos' in type_lower:
            return 'Asbestos Management'
        elif 'gas' in type_lower:
            return 'Gas Systems'
        else:
            return 'General'
    
    def get_final_register(self) -> List[Dict]:
        """Get final consolidated asset register"""
        assets_list = list(self.assets.values())
        
        # Sort by category then name
        assets_list.sort(key=lambda a: (a.get('category', 'Z'), a.get('asset_name', '')))
        
        return assets_list
    
    def print_summary(self):
        """Print asset register summary"""
        assets = self.get_final_register()
        
        print(f"\n🏗️  ASSET REGISTER SUMMARY:")
        print(f"   Total assets: {len(assets)}")
        print()
        
        # Group by category
        by_category = {}
        for asset in assets:
            cat = asset.get('category', 'General')
            if cat not in by_category:
                by_category[cat] = []
            by_category[cat].append(asset)
        
        for category, asset_list in sorted(by_category.items()):
            print(f"   {category}: {len(asset_list)} assets")
            for asset in asset_list[:3]:
                cost = f"£{asset.get('annual_maintenance_cost', 0):,.0f}" if asset.get('annual_maintenance_cost') else '—'
                contractor = asset.get('responsible_contractor') or '—'
                print(f"      • {asset['asset_name']}: {cost}/year, {contractor}")
            
            if len(asset_list) > 3:
                print(f"      ... and {len(asset_list) - 3} more")

