#!/usr/bin/env python3
"""
Simple Contractor Onboarding Tool
==================================
One command to onboard a contractor:
1. Extract data from documents (Excel, PDF, Word)
2. Generate SQL for Supabase
3. Create summary report

Usage:
    python3 onboard_contractor.py <contractor_folder>
    
Example:
    python3 onboard_contractor.py "/path/to/contractor/documents"
"""

import sys
import json
from pathlib import Path
from datetime import datetime

# Import our extractors
from contractor_extractor import ContractorExtractor
from contractor_sql_generator import SupplierSQLGenerator


def onboard_contractor(folder_path: str):
    """Complete contractor onboarding workflow"""
    
    folder = Path(folder_path)
    if not folder.exists():
        print(f"❌ Folder not found: {folder_path}")
        return False
    
    contractor_folder_name = folder.name
    
    print("\n" + "="*80)
    print("🚀 CONTRACTOR ONBOARDING")
    print("="*80)
    print(f"Folder: {contractor_folder_name}")
    print(f"Started: {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}")
    print("="*80)
    
    # ========================================================================
    # STEP 1: Extract Data
    # ========================================================================
    print("\n📥 STEP 1: EXTRACTING DATA FROM DOCUMENTS")
    print("-" * 80)
    
    try:
        extractor = ContractorExtractor()
        contractor_data = extractor.extract_from_folder(folder_path)
        
        print(f"\n   ✅ Extraction complete!")
        print(f"   📊 Confidence: {contractor_data.get('extraction_confidence', 0):.0%}")
        
    except Exception as e:
        print(f"\n   ❌ Extraction failed: {e}")
        return False
    
    # ========================================================================
    # STEP 2: Generate SQL
    # ========================================================================
    print("\n💾 STEP 2: GENERATING SQL FOR SUPABASE")
    print("-" * 80)
    
    try:
        # Save intermediate JSON
        json_file = Path('output') / f"{contractor_folder_name}_contractor_data.json"
        json_file.parent.mkdir(exist_ok=True)
        
        with open(json_file, 'w') as f:
            json.dump(contractor_data, f, indent=2)
        
        print(f"   📄 Saved data: {json_file}")
        
        # Generate SQL
        generator = SupplierSQLGenerator()
        sql_file = Path('output') / f"{contractor_folder_name}_supplier.sql"
        sql = generator.generate_sql(contractor_data, str(sql_file))
        
        print(f"   💾 SQL generated: {sql_file}")
        print(f"   🆔 Supplier ID: {generator.supplier_id}")
        
    except Exception as e:
        print(f"\n   ❌ SQL generation failed: {e}")
        return False
    
    # ========================================================================
    # STEP 3: Summary Report
    # ========================================================================
    print("\n📊 STEP 3: CONTRACTOR ONBOARDING SUMMARY")
    print("="*80)
    
    # Summary
    print(f"\n✅ Contractor Information:")
    print(f"   • Name: {contractor_data.get('contractor_name') or '❌ Not found'}")
    print(f"   • Email: {contractor_data.get('email') or '❌ Not found'}")
    print(f"   • Telephone: {contractor_data.get('telephone') or '❌ Not found'}")
    print(f"   • Postcode: {contractor_data.get('postcode') or '❌ Not found'}")
    
    services = contractor_data.get('services_provided', [])
    if services:
        print(f"\n✅ Services Provided ({len(services)}):")
        for service in services[:5]:
            print(f"   • {service}")
        if len(services) > 5:
            print(f"   • ... and {len(services) - 5} more")
    else:
        print(f"\n⚠️  Services: Not detected")
    
    print(f"\n✅ Banking Details:")
    print(f"   • Account Name: {contractor_data.get('bank_account_name') or '❌ Not found'}")
    print(f"   • Sort Code: {contractor_data.get('bank_sort_code') or '❌ Not found'}")
    
    print(f"\n✅ Compliance:")
    print(f"   • PLI Expiry: {contractor_data.get('pli_expiry_date') or '❌ Not found'}")
    print(f"   • Audited Accounts: {'✓ Yes' if contractor_data.get('has_audited_accounts') else '✗ No'}")
    print(f"   • Certificate of Incorporation: {'✓ Yes' if contractor_data.get('has_certificate_of_incorporation') else '✗ No'}")
    
    print(f"\n📁 Documents:")
    print(f"   • Total files: {len(contractor_data.get('documents_found', []))}")
    for doc in contractor_data.get('documents_found', [])[:5]:
        print(f"   • {doc.get('file_name')} ({doc.get('file_type')})")
    
    # Data Quality
    confidence = contractor_data.get('extraction_confidence', 0)
    if confidence >= 0.8:
        quality = "🟢 Excellent"
    elif confidence >= 0.6:
        quality = "🟡 Good"
    else:
        quality = "🔴 Needs Review"
    
    print(f"\n📊 Data Quality: {quality} ({confidence:.0%})")
    
    # ========================================================================
    # STEP 4: Next Steps
    # ========================================================================
    print("\n" + "="*80)
    print("🎯 NEXT STEPS")
    print("="*80)
    
    print(f"\n1. Review extracted data:")
    print(f"   {json_file}")
    
    print(f"\n2. Upload supplier documents to Supabase Storage:")
    print(f"   Bucket: {generator.storage_bucket}")
    print(f"   Path: {generator.storage_bucket}/{generator.supplier_id}/")
    
    print(f"\n3. Apply SQL to Supabase:")
    print(f"   python3 apply_with_new_credentials.py {sql_file}")
    
    print(f"\n4. Review and approve supplier in database:")
    print(f"   UPDATE suppliers SET onboarding_status = 'approved' WHERE id = '{generator.supplier_id}';")
    
    print("\n" + "="*80)
    print("✅ CONTRACTOR ONBOARDING COMPLETE!")
    print("="*80 + "\n")
    
    return True


def main():
    """CLI entry point"""
    
    if len(sys.argv) != 2:
        print("\n🔨 Contractor Onboarding Tool")
        print("=" * 80)
        print("\nUsage: python3 onboard_contractor.py <contractor_folder>")
        print("\nExample:")
        print('  python3 onboard_contractor.py "/Users/ellie/Downloads/NewContractor"')
        print("\nThe folder should contain:")
        print("  • Contractor information (Excel/PDF/Word)")
        print("  • PLI certificate (PDF)")
        print("  • Audited accounts (PDF/Excel)")
        print("  • Certificate of incorporation (PDF)")
        print("  • Bank details (any format)")
        print("\n" + "="*80 + "\n")
        sys.exit(1)
    
    folder_path = sys.argv[1]
    success = onboard_contractor(folder_path)
    
    sys.exit(0 if success else 1)


if __name__ == '__main__':
    main()

