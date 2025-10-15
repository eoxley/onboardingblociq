#!/usr/bin/env python3
"""
Simple Command-Line Supplier Onboarding (No GUI)
=================================================
Use this if the GUI app has issues
"""

import sys
from pathlib import Path
from contractor_extractor import ContractorExtractor
from contractor_sql_generator import SupplierSQLGenerator

def main():
    print("\n" + "="*80)
    print("🔨 SUPPLIER ONBOARDING (Command Line)")
    print("="*80)
    
    if len(sys.argv) < 2:
        print("\nUsage: python3 supplier_cli.py <file_or_folder>")
        print("\nExamples:")
        print("  python3 supplier_cli.py supplier.xlsx")
        print("  python3 supplier_cli.py /path/to/supplier/folder")
        print("  python3 supplier_cli.py supplier_info.pdf")
        sys.exit(1)
    
    path = Path(sys.argv[1])
    
    if not path.exists():
        print(f"\n❌ Path not found: {path}")
        sys.exit(1)
    
    print(f"\n📁 Processing: {path.name}")
    print(f"   Type: {'File' if path.is_file() else 'Folder'}")
    
    # Extract
    print("\n📥 Extracting data...")
    extractor = ContractorExtractor()
    
    try:
        if path.is_file():
            data = extractor.extract_from_files([path])
        else:
            data = extractor.extract_from_folder(str(path))
        
        print("\n✅ EXTRACTION COMPLETE!\n")
        print("="*80)
        print("📊 EXTRACTED DATA")
        print("="*80)
        print(f"\n✅ Contractor Name: {data.get('contractor_name') or '❌ Not found'}")
        print(f"✅ Email: {data.get('email') or '❌ Not found'}")
        print(f"✅ Telephone: {data.get('telephone') or '❌ Not found'}")
        print(f"✅ Postcode: {data.get('postcode') or '❌ Not found'}")
        
        services = data.get('services_provided', [])
        if services:
            print(f"\n✅ Services ({len(services)}):")
            for s in services:
                print(f"   • {s}")
        else:
            print(f"\n⚠️  Services: None detected")
        
        print(f"\n✅ Bank Account Name: {data.get('bank_account_name') or '❌ Not found'}")
        print(f"✅ Bank Sort Code: {data.get('bank_sort_code') or '❌ Not found'}")
        print(f"✅ PLI Expiry: {data.get('pli_expiry_date') or '❌ Not found'}")
        print(f"\n✅ Audited Accounts: {'Yes' if data.get('has_audited_accounts') else 'No'}")
        print(f"✅ Certificate of Incorporation: {'Yes' if data.get('has_certificate_of_incorporation') else 'No'}")
        
        print(f"\n📊 Confidence: {data.get('extraction_confidence', 0):.0%}")
        print(f"📁 Documents: {len(data.get('documents_found', []))}")
        
        # Generate SQL
        print("\n" + "="*80)
        print("💾 GENERATING SQL")
        print("="*80)
        
        generator = SupplierSQLGenerator()
        sql = generator.generate_sql(data, "output/supplier_temp.sql")
        
        print(f"\n✅ SQL generated!")
        print(f"   File: output/supplier_temp.sql")
        print(f"   Supplier ID: {generator.supplier_id}")
        
        # Apply?
        print("\n" + "="*80)
        print("🚀 APPLY TO DATABASE?")
        print("="*80)
        print(f"\nTo apply to Supabase, run:")
        print(f"  python3 apply_with_new_credentials.py output/supplier_temp.sql")
        
        print("\n✅ SUCCESS!\n")
        
    except Exception as e:
        print(f"\n❌ ERROR: {e}")
        import traceback
        traceback.print_exc()
        sys.exit(1)

if __name__ == '__main__':
    main()

