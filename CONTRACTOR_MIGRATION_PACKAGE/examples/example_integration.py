#!/usr/bin/env python3
"""
Example Integration: Contractor Onboarding with Building Onboarding
====================================================================
Shows how to integrate contractor onboarding into your existing
building onboarding system.
"""

import sys
from pathlib import Path
from typing import Dict, List

# Add parent directory to path
sys.path.insert(0, str(Path(__file__).parent.parent))

from consolidators.contractor_consolidator import ContractorConsolidator
from extractors.budget_contractor_extractor import BudgetContractorExtractor
from validators.contractor_name_validator import ContractorNameValidator
from generators.supplier_sql_generator import SupplierSQLGenerator


class BuildingOnboarderWithContractors:
    """
    Example: Extend your building onboarding to include contractor extraction
    """
    
    def __init__(self):
        self.contractor_consolidator = ContractorConsolidator()
        self.budget_extractor = BudgetContractorExtractor()
        self.validator = ContractorNameValidator()
    
    def onboard_building(self, building_data: Dict) -> Dict:
        """
        Complete building onboarding with contractor extraction
        
        Args:
            building_data: Dictionary with building information including:
                - building_name
                - budget_line_items (list)
                - maintenance_contracts (list)
                - units (list)
                - etc.
        
        Returns:
            Dictionary with building data + consolidated contractors
        """
        print(f"\n🏢 Onboarding Building: {building_data.get('building_name')}")
        
        # ====================================================================
        # Your existing building onboarding logic here
        # ====================================================================
        
        # Process building details
        building_id = self._process_building_details(building_data)
        
        # Process units
        units = self._process_units(building_data.get('units', []), building_id)
        
        # ====================================================================
        # NEW: Extract and consolidate contractors
        # ====================================================================
        
        print(f"\n👷 Extracting contractors...")
        
        # Extract from budget
        if building_data.get('budget_line_items'):
            self.contractor_consolidator.add_from_budget(
                building_data['budget_line_items']
            )
            print(f"   ✓ Processed {len(building_data['budget_line_items'])} budget items")
        
        # Extract from contracts
        if building_data.get('maintenance_contracts'):
            self.contractor_consolidator.add_from_contracts(
                building_data['maintenance_contracts']
            )
            print(f"   ✓ Processed {len(building_data['maintenance_contracts'])} contracts")
        
        # Get consolidated contractors
        contractors = self.contractor_consolidator.get_consolidated_contractors()
        
        print(f"\n   📊 Found {len(contractors)} unique contractors")
        
        # Store contractors in database
        contractor_ids = self._store_contractors(contractors, building_id)
        
        # ====================================================================
        # Return complete building data
        # ====================================================================
        
        return {
            'building_id': building_id,
            'building_name': building_data.get('building_name'),
            'units': units,
            'contractors': contractors,
            'contractor_ids': contractor_ids,
            'status': 'success'
        }
    
    def _process_building_details(self, building_data: Dict) -> str:
        """Process building details (your existing logic)"""
        # Your existing building processing code
        print(f"   ✓ Building details processed")
        return "building_id_123"  # Return actual building ID
    
    def _process_units(self, units: List[Dict], building_id: str) -> List[Dict]:
        """Process units (your existing logic)"""
        # Your existing unit processing code
        print(f"   ✓ Processed {len(units)} units")
        return units
    
    def _store_contractors(self, contractors: List[Dict], building_id: str) -> List[str]:
        """
        Store contractors in database
        
        This is where you would:
        1. Check if contractor already exists
        2. Insert new contractors
        3. Link contractors to building
        4. Return list of contractor IDs
        """
        contractor_ids = []
        
        for contractor in contractors:
            # Check if contractor exists
            existing_id = self._find_existing_contractor(contractor['contractor_name'])
            
            if existing_id:
                print(f"   • {contractor['contractor_name']} (existing)")
                contractor_ids.append(existing_id)
            else:
                # Insert new contractor
                new_id = self._insert_contractor(contractor)
                print(f"   • {contractor['contractor_name']} (new)")
                contractor_ids.append(new_id)
            
            # Link to building
            self._link_contractor_to_building(contractor_ids[-1], building_id)
        
        return contractor_ids
    
    def _find_existing_contractor(self, name: str) -> str:
        """Check if contractor already exists in database"""
        # Query your database
        # SELECT id FROM suppliers WHERE contractor_name = name
        return None  # Replace with actual query
    
    def _insert_contractor(self, contractor_data: Dict) -> str:
        """Insert new contractor into database"""
        # Generate SQL and execute
        generator = SupplierSQLGenerator()
        sql = generator.generate_sql(contractor_data)
        
        # Execute SQL (your database connection)
        # execute_sql(sql)
        
        return generator.supplier_id
    
    def _link_contractor_to_building(self, contractor_id: str, building_id: str):
        """Link contractor to building"""
        # INSERT INTO building_contractors (building_id, contractor_id, ...)
        pass


def example_integration_workflow():
    """Example: Complete integration workflow"""
    
    # Sample building data
    building_data = {
        'building_name': 'Connaught Square',
        'address': '123 Connaught Square, London',
        'num_units': 8,
        'budget_line_items': [
            {
                'description': 'Cleaning services - communal areas',
                'category': 'cleaning',
                'annual_amount': 12000,
                'notes': 'This is the current cleaning contract with New Step'
            },
            {
                'description': 'Lift maintenance contract',
                'category': 'lifts',
                'annual_amount': 8500,
                'notes': 'Contract is with Jacksons Lift Services Ltd'
            },
            {
                'description': 'Heating system maintenance',
                'category': 'heating',
                'annual_amount': 6000,
                'notes': 'Currently with Positive Energy for boiler servicing'
            }
        ],
        'maintenance_contracts': [
            {
                'contractor_name': 'New Step',
                'service_type': 'Cleaning',
                'start_date': '2024-01-01',
                'end_date': '2025-12-31',
                'annual_value': 12000
            }
        ],
        'units': [
            {'unit_number': 'Flat 1', 'apportionment': 12.5},
            {'unit_number': 'Flat 2', 'apportionment': 12.5},
            # ... more units
        ]
    }
    
    # Create onboarder
    onboarder = BuildingOnboarderWithContractors()
    
    # Onboard building (with contractors)
    result = onboarder.onboard_building(building_data)
    
    # Print results
    print(f"\n" + "="*80)
    print("ONBOARDING RESULTS")
    print("="*80)
    print(f"Building ID: {result['building_id']}")
    print(f"Building Name: {result['building_name']}")
    print(f"Units: {len(result['units'])}")
    print(f"Contractors: {len(result['contractors'])}")
    print(f"\nContractors found:")
    for contractor in result['contractors']:
        print(f"  • {contractor['contractor_name']}")
        print(f"    Services: {', '.join(contractor['services_provided'])}")
        if contractor['annual_value'] > 0:
            print(f"    Annual value: £{contractor['annual_value']:,.0f}")


def example_batch_processing():
    """Example: Process multiple buildings"""
    
    buildings = [
        {
            'building_name': 'Connaught Square',
            'budget_line_items': [
                # ... budget data ...
            ]
        },
        {
            'building_name': 'Pimlico Place',
            'budget_line_items': [
                # ... budget data ...
            ]
        },
        # ... more buildings
    ]
    
    onboarder = BuildingOnboarderWithContractors()
    
    results = []
    for building_data in buildings:
        result = onboarder.onboard_building(building_data)
        results.append(result)
    
    # Summary
    print(f"\n" + "="*80)
    print(f"BATCH PROCESSING COMPLETE")
    print("="*80)
    print(f"Buildings processed: {len(results)}")
    print(f"Total contractors: {sum(len(r['contractors']) for r in results)}")


def example_contractor_lookup():
    """Example: Find contractors by service"""
    
    # Your database query
    query = """
    SELECT 
        contractor_name,
        email,
        telephone,
        services_provided,
        rating
    FROM suppliers
    WHERE 'Cleaning' = ANY(services_provided)
        AND is_approved_contractor = true
        AND pli_status = 'current'
    ORDER BY rating DESC;
    """
    
    print(f"\n📊 SQL Query for Finding Contractors by Service:")
    print(query)


def example_sync_contractor_data():
    """Example: Sync contractor data from building to suppliers table"""
    
    def sync_contractors_from_building(building_id: str):
        """
        Extract contractors from existing building data
        and sync to suppliers table
        """
        print(f"\n🔄 Syncing contractors for building {building_id}")
        
        # 1. Get budget data for building
        budget_items = get_budget_items(building_id)
        
        # 2. Extract contractors
        consolidator = ContractorConsolidator()
        consolidator.add_from_budget(budget_items)
        contractors = consolidator.get_consolidated_contractors()
        
        # 3. Sync to suppliers table
        for contractor in contractors:
            sync_to_suppliers_table(contractor, building_id)
        
        print(f"   ✓ Synced {len(contractors)} contractors")
    
    def get_budget_items(building_id: str) -> List[Dict]:
        """Get budget items from database"""
        # SELECT * FROM budget_line_items WHERE building_id = ?
        return []
    
    def sync_to_suppliers_table(contractor: Dict, building_id: str):
        """Insert or update supplier record"""
        # Check if exists, then insert or update
        pass


if __name__ == '__main__':
    print("\n" + "="*80)
    print("CONTRACTOR ONBOARDING - INTEGRATION EXAMPLES")
    print("="*80)
    
    print("\n1. Complete integration workflow:")
    example_integration_workflow()
    
    print("\n2. Contractor lookup:")
    example_contractor_lookup()
    
    print("\n" + "="*80)
    print("✅ INTEGRATION EXAMPLES COMPLETED")
    print("="*80 + "\n")


