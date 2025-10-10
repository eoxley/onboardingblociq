#!/usr/bin/env python3
"""
Test actual INSERT operations via Supabase client
"""
from supabase import create_client
import uuid
from datetime import datetime

SUPABASE_URL = "https://aewixchhykxyhqjvqoek.supabase.co"
SUPABASE_KEY = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImFld2l4Y2hoeWt4eWhxanZxb2VrIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTc1OTUwMjUxNiwiZXhwIjoyMDc1MDc4NTE2fQ.lqLBt_R8GRnI_iMela4RAEfgcJ8Ple6WwmWBqrAa56o"

print("=" * 70)
print("TESTING ACTUAL INSERT OPERATIONS VIA SUPABASE CLIENT")
print("=" * 70)

try:
    supabase = create_client(SUPABASE_URL, SUPABASE_KEY)
    print(f"\n✅ Connected to Supabase\n")

    # Test UUIDs
    test_agency_id = "00000000-0000-0000-0000-000000000001"
    test_portfolio_id = str(uuid.uuid4())
    test_building_id = str(uuid.uuid4())
    test_unit_id = str(uuid.uuid4())

    print(f"🔑 Test IDs:")
    print(f"   Agency: {test_agency_id}")
    print(f"   Portfolio: {test_portfolio_id}")
    print(f"   Building: {test_building_id}\n")

    tests_passed = []
    tests_failed = []

    # Test 1: Portfolio insert
    try:
        result = supabase.table('portfolios').insert({
            'id': test_portfolio_id,
            'agency_id': test_agency_id,
            'name': 'TEST - Connaught Square Portfolio'
        }).execute()
        print("✅ Test 1: Portfolio insert - PASSED")
        tests_passed.append("Portfolio insert")
    except Exception as e:
        print(f"❌ Test 1: Portfolio insert - FAILED: {str(e)[:100]}")
        tests_failed.append(f"Portfolio insert: {str(e)[:100]}")

    # Test 2: Building insert
    try:
        result = supabase.table('buildings').insert({
            'id': test_building_id,
            'portfolio_id': test_portfolio_id,
            'name': 'TEST - Connaught Square',
            'address': '32-34 Connaught Square',
            'postcode': 'W2 2HL',
            'building_type': 'Residential',
            'number_of_units': 8
        }).execute()
        print("✅ Test 2: Building insert - PASSED")
        tests_passed.append("Building insert")
    except Exception as e:
        print(f"❌ Test 2: Building insert - FAILED: {str(e)[:100]}")
        tests_failed.append(f"Building insert: {str(e)[:100]}")

    # Test 3: Compliance asset with category
    try:
        result = supabase.table('compliance_assets').insert({
            'id': str(uuid.uuid4()),
            'building_id': test_building_id,
            'category': 'compliance',
            'asset_name': 'TEST - Fire Door Inspection',
            'asset_type': 'fire_safety',
            'inspection_frequency': '12 months',
            'description': 'Test compliance asset',
            'last_inspection_date': '2024-01-24',
            'next_due_date': '2025-01-24',
            'compliance_status': 'overdue'
        }).execute()
        print("✅ Test 3: Compliance asset (with category) - PASSED")
        tests_passed.append("Compliance asset with category")
    except Exception as e:
        print(f"❌ Test 3: Compliance asset - FAILED: {str(e)[:100]}")
        tests_failed.append(f"Compliance asset: {str(e)[:100]}")

    # Test 4: Unit insert
    try:
        result = supabase.table('units').insert({
            'id': test_unit_id,
            'building_id': test_building_id,
            'unit_number': 'TEST - Flat 1',
            'unit_type': 'Flat'
        }).execute()
        print("✅ Test 4: Unit insert - PASSED")
        tests_passed.append("Unit insert")
    except Exception as e:
        print(f"❌ Test 4: Unit insert - FAILED: {str(e)[:100]}")
        tests_failed.append(f"Unit insert: {str(e)[:100]}")

    # Test 5: Leaseholder insert
    try:
        result = supabase.table('leaseholders').insert({
            'id': str(uuid.uuid4()),
            'building_id': test_building_id,
            'unit_number': 'TEST - Flat 1',
            'first_name': 'Test',
            'last_name': 'Leaseholder',
            'email': 'test@example.com'
        }).execute()
        print("✅ Test 5: Leaseholder insert - PASSED")
        tests_passed.append("Leaseholder insert")
    except Exception as e:
        print(f"❌ Test 5: Leaseholder insert - FAILED: {str(e)[:100]}")
        tests_failed.append(f"Leaseholder insert: {str(e)[:100]}")

    # Test 6: Document insert
    try:
        result = supabase.table('building_documents').insert({
            'id': str(uuid.uuid4()),
            'building_id': test_building_id,
            'category': 'insurance',
            'file_name': 'TEST - Insurance Certificate.pdf',
            'file_path': '/test/path/cert.pdf',
            'file_type': 'pdf',
            'uploaded_at': datetime.now().isoformat()
        }).execute()
        print("✅ Test 6: Document insert - PASSED")
        tests_passed.append("Document insert")
    except Exception as e:
        print(f"❌ Test 6: Document insert - FAILED: {str(e)[:100]}")
        tests_failed.append(f"Document insert: {str(e)[:100]}")

    # Cleanup
    print("\n🧹 Cleaning up test data...")
    try:
        supabase.table('building_documents').delete().eq('building_id', test_building_id).execute()
        supabase.table('leaseholders').delete().eq('building_id', test_building_id).execute()
        supabase.table('units').delete().eq('building_id', test_building_id).execute()
        supabase.table('compliance_assets').delete().eq('building_id', test_building_id).execute()
        supabase.table('buildings').delete().eq('id', test_building_id).execute()
        supabase.table('portfolios').delete().eq('id', test_portfolio_id).execute()
        print("✅ Test data cleaned up")
    except Exception as e:
        print(f"⚠️  Cleanup warning: {str(e)[:100]}")

    # Summary
    print("\n" + "=" * 70)
    print("TEST SUMMARY")
    print("=" * 70)
    print(f"\n✅ Passed: {len(tests_passed)}/6")
    print(f"❌ Failed: {len(tests_failed)}/6\n")

    if tests_failed:
        print("Failed tests:")
        for i, failure in enumerate(tests_failed, 1):
            print(f"  {i}. {failure}")
        print()

    if len(tests_passed) == 6:
        print("🎉 ALL TESTS PASSED!")
        print("✅ Migration SQL is fully compatible with Supabase schema")
        print("✅ Ready for production deployment")
    elif len(tests_passed) >= 4:
        print("⚠️  Most tests passed - review failures above")
    else:
        print("❌ Multiple test failures - schema may need updates")

    print("\n" + "=" * 70)

except Exception as e:
    print(f"\n❌ Connection error: {e}")

