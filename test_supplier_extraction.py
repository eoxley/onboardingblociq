#!/usr/bin/env python3
"""Test supplier extraction with detailed error output"""

import sys
from pathlib import Path

print("\n" + "="*80)
print("🧪 TESTING SUPPLIER EXTRACTION")
print("="*80)

try:
    print("\n1. Testing imports...")
    from contractor_extractor import ContractorExtractor
    from contractor_sql_generator import SupplierSQLGenerator
    print("   ✅ Imports successful")
    
    print("\n2. Creating extractor...")
    extractor = ContractorExtractor()
    print("   ✅ Extractor created")
    
    print("\n3. Testing with a sample file...")
    print("   Please provide a file path:")
    
    if len(sys.argv) > 1:
        test_path = sys.argv[1]
    else:
        print("\n   Usage: python3 test_supplier_extraction.py <path_to_file_or_folder>")
        print("   Example: python3 test_supplier_extraction.py /path/to/supplier.xlsx")
        sys.exit(1)
    
    path = Path(test_path)
    print(f"   Path: {path}")
    print(f"   Exists: {path.exists()}")
    print(f"   Is file: {path.is_file()}")
    print(f"   Is dir: {path.is_dir()}")
    
    if path.is_file():
        print(f"\n4. Extracting from single file: {path.name}")
        data = extractor.extract_from_files([path])
    elif path.is_dir():
        print(f"\n4. Extracting from folder: {path.name}")
        data = extractor.extract_from_folder(str(path))
    else:
        print(f"\n   ❌ Path is neither file nor directory")
        sys.exit(1)
    
    print("\n5. Extraction results:")
    print(f"   • Contractor Name: {data.get('contractor_name')}")
    print(f"   • Email: {data.get('email')}")
    print(f"   • Telephone: {data.get('telephone')}")
    print(f"   • Postcode: {data.get('postcode')}")
    print(f"   • Services: {data.get('services_provided')}")
    print(f"   • Confidence: {data.get('extraction_confidence'):.0%}")
    
    print("\n6. Generating SQL...")
    generator = SupplierSQLGenerator()
    sql = generator.generate_sql(data)
    
    print(f"   ✅ SQL generated ({len(sql)} chars)")
    print(f"   🆔 Supplier ID: {generator.supplier_id}")
    
    print("\n" + "="*80)
    print("✅ TEST SUCCESSFUL!")
    print("="*80 + "\n")
    
except Exception as e:
    print(f"\n❌ ERROR: {e}")
    import traceback
    traceback.print_exc()
    print("\n" + "="*80 + "\n")
    sys.exit(1)

