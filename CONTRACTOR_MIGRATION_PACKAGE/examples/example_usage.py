#!/usr/bin/env python3
"""
Example Usage: Contractor Onboarding System
============================================
Shows how to use each component of the contractor onboarding system.
"""

import sys
import os
from pathlib import Path

# Add parent directory to path
sys.path.insert(0, str(Path(__file__).parent.parent))

from extractors.contractor_extractor import ContractorExtractor
from extractors.budget_contractor_extractor import BudgetContractorExtractor
from consolidators.contractor_consolidator import ContractorConsolidator
from validators.contractor_name_validator import ContractorNameValidator
from generators.supplier_sql_generator import SupplierSQLGenerator


def example_1_extract_from_folder():
    """Example 1: Extract contractor data from a folder"""
    print("\n" + "="*80)
    print("EXAMPLE 1: Extract from Folder")
    print("="*80)
    
    folder_path = "/path/to/contractor/folder"  # Change this to your test folder
    
    if not os.path.exists(folder_path):
        print(f"⚠️  Folder not found: {folder_path}")
        print("   Update folder_path in this example to test")
        return
    
    # Create extractor
    extractor = ContractorExtractor()
    
    # Extract data
    data = extractor.extract_from_folder(folder_path)
    
    # Print results
    print(f"\n📊 EXTRACTED DATA:")
    print(f"   Contractor Name: {data.get('contractor_name', 'Not found')}")
    print(f"   Email: {data.get('email', 'Not found')}")
    print(f"   Telephone: {data.get('telephone', 'Not found')}")
    print(f"   Services: {', '.join(data.get('services_provided', []))}")
    print(f"   Confidence: {data.get('extraction_confidence', 0):.0%}")


def example_2_extract_from_budget():
    """Example 2: Extract contractor names from budget notes"""
    print("\n" + "="*80)
    print("EXAMPLE 2: Extract from Budget Notes")
    print("="*80)
    
    extractor = BudgetContractorExtractor()
    
    # Test with different note patterns
    test_notes = [
        "This is the current cleaning contract with New Step",
        "Contract is with Jacksons Lift Services Ltd",
        "Currently with Positive Energy for heating maintenance",
        "Provided by Water Hygiene Maintenance Ltd",
    ]
    
    print("\n📝 Testing extraction from notes:\n")
    for note in test_notes:
        contractor = extractor.extract_contractor_from_notes(note)
        status = "✅" if contractor else "❌"
        print(f"{status} '{note[:50]}...'")
        if contractor:
            print(f"   → {contractor}\n")


def example_3_consolidate_contractors():
    """Example 3: Consolidate and deduplicate contractors"""
    print("\n" + "="*80)
    print("EXAMPLE 3: Consolidate Contractors")
    print("="*80)
    
    # Create consolidator
    consolidator = ContractorConsolidator()
    
    # Simulate budget line items
    budget_items = [
        {
            'description': 'Cleaning services',
            'category': 'cleaning',
            'annual_amount': 12000,
            'notes': 'This contract is with New Step'
        },
        {
            'description': 'Additional cleaning',
            'category': 'cleaning',
            'annual_amount': 3000,
            'notes': 'Contract with New Step Ltd'  # Same contractor, different name
        },
        {
            'description': 'Lift maintenance',
            'category': 'lifts',
            'annual_amount': 8500,
            'notes': 'Currently with Jacksons Lift Services'
        }
    ]
    
    # Add budget items
    consolidator.add_from_budget(budget_items)
    
    # Get consolidated list
    contractors = consolidator.get_consolidated_contractors()
    
    print(f"\n📊 CONSOLIDATION RESULTS:")
    print(f"   Total unique contractors: {len(contractors)}\n")
    
    for contractor in contractors:
        print(f"   • {contractor['contractor_name']}")
        print(f"     Services: {', '.join(contractor['services_provided'])}")
        if contractor['aliases']:
            print(f"     Aliases: {', '.join(contractor['aliases'])}")
        if contractor['annual_value'] > 0:
            print(f"     Annual value: £{contractor['annual_value']:,.0f}")
        print()


def example_4_validate_names():
    """Example 4: Validate contractor names"""
    print("\n" + "="*80)
    print("EXAMPLE 4: Validate Contractor Names")
    print("="*80)
    
    validator = ContractorNameValidator()
    
    test_names = [
        "New Step Cleaning Ltd",           # Valid
        "Gas",                              # Generic word - invalid
        "s and each contractor engaged",   # Clause text - invalid
        "Positive Energy",                  # Valid
        "Jacksons Lift Services",          # Valid
        "the contractor shall",            # Legal text - invalid
    ]
    
    print("\n🔍 Testing name validation:\n")
    for name in test_names:
        is_valid = validator.is_valid_contractor(name)
        status = "✅ VALID" if is_valid else "❌ INVALID"
        print(f"{status}  {name}")


def example_5_generate_sql():
    """Example 5: Generate SQL for Supabase"""
    print("\n" + "="*80)
    print("EXAMPLE 5: Generate SQL")
    print("="*80)
    
    # Sample contractor data
    contractor_data = {
        'contractor_name': 'New Step Cleaning Ltd',
        'email': 'info@newstep.co.uk',
        'telephone': '020 1234 5678',
        'postcode': 'SW1A 1AA',
        'address': '123 Example Street, London',
        'services_provided': ['Cleaning', 'Facilities Management'],
        'bank_account_name': 'New Step Cleaning Ltd',
        'bank_sort_code': '12-34-56',
        'pli_expiry_date': '31/03/2025',
        'has_audited_accounts': True,
        'has_certificate_of_incorporation': True,
        'extraction_confidence': 0.9,
        'documents_found': [
            {
                'file_name': 'Company Profile.xlsx',
                'file_type': '.xlsx',
                'file_size': 52480
            },
            {
                'file_name': 'PLI Certificate.pdf',
                'file_type': '.pdf',
                'file_size': 124800
            }
        ]
    }
    
    # Generate SQL
    generator = SupplierSQLGenerator()
    sql = generator.generate_sql(contractor_data)
    
    print(f"\n📊 SQL GENERATED:")
    print(f"   Supplier ID: {generator.supplier_id}")
    print(f"   Storage bucket: {generator.storage_bucket}")
    print(f"   Storage path: {generator.storage_bucket}/{generator.supplier_id}/")
    print(f"\n   SQL preview (first 500 chars):")
    print(f"   {sql[:500]}...")


def example_6_full_workflow():
    """Example 6: Complete end-to-end workflow"""
    print("\n" + "="*80)
    print("EXAMPLE 6: Complete Workflow")
    print("="*80)
    
    print("""
    Complete workflow:
    
    1. Place contractor documents in a folder
    2. Run: python3 onboard_contractor.py "/path/to/folder"
    3. Review output JSON and SQL files
    4. Apply SQL to Supabase
    5. Upload documents to Supabase Storage
    6. Approve contractor in database
    
    See onboard_contractor.py for the complete implementation.
    """)


def main():
    """Run all examples"""
    print("\n" + "="*80)
    print("CONTRACTOR ONBOARDING SYSTEM - USAGE EXAMPLES")
    print("="*80)
    
    examples = [
        ("Extract from Folder", example_1_extract_from_folder),
        ("Extract from Budget", example_2_extract_from_budget),
        ("Consolidate Contractors", example_3_consolidate_contractors),
        ("Validate Names", example_4_validate_names),
        ("Generate SQL", example_5_generate_sql),
        ("Full Workflow", example_6_full_workflow),
    ]
    
    print("\n📋 AVAILABLE EXAMPLES:\n")
    for i, (name, _) in enumerate(examples, 1):
        print(f"   {i}. {name}")
    
    print("\n" + "="*80)
    
    # Run all examples
    for name, func in examples:
        try:
            func()
        except Exception as e:
            print(f"\n⚠️  Example '{name}' failed: {e}")
    
    print("\n" + "="*80)
    print("✅ ALL EXAMPLES COMPLETED")
    print("="*80 + "\n")


if __name__ == '__main__':
    main()


