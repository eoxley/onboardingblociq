#!/usr/bin/env python3
"""
Test Script: Complete Lease Extraction Pipeline
Tests: Lease Extractor → SQL Generation → Health Check PDF
"""

import sys
import os
from pathlib import Path

# Add BlocIQ_Onboarder to path
sys.path.insert(0, str(Path(__file__).parent / 'BlocIQ_Onboarder'))

def test_lease_extraction():
    """Test the deep parser lease extractor with clause extraction"""
    from deep_parser.extractors.lease_extractor import LeaseExtractor
    from deep_parser.types import LeaseData

    print("=" * 60)
    print("TEST 1: Deep Parser Lease Extractor with Clauses")
    print("=" * 60)

    # Sample lease text
    sample_lease_text = """
    LEASE AGREEMENT

    Flat 5A, Connaught Square, London W2 2HL

    PARTIES:
    Lessor: Connaught Square Management Ltd
    Lessee: John Smith and Jane Smith

    TERM: 125 years from 1 January 1990

    GROUND RENT: £50 per annum

    SERVICE CHARGE APPORTIONMENT: 2.5%

    RENT REVIEW: Every 10 years

    CLAUSES:

    1.1 The Lessee shall pay the Ground Rent promptly without demand or deduction

    2.1 The Lessee covenants to keep the demised premises in good and tenantable repair

    3.1 The Lessee shall insure the premises for their full reinstatement value

    4.1 The Lessee shall pay the service charge proportion as specified in the schedule

    5.1 The Lessee shall not make any structural alterations without prior consent

    6.1 Assignment or subletting requires prior written consent of the Lessor

    7.1 Forfeiture: The Lessor may re-enter if rent remains unpaid for 21 days
    """

    extractor = LeaseExtractor()
    leases = extractor.extract(sample_lease_text, "test_lease.pdf")

    if leases:
        lease = leases[0]
        print(f"✅ Extracted lease for unit: {lease.unit_ref}")
        print(f"   Lessee: {', '.join(lease.lessee_names)}")
        print(f"   Lessor: {lease.lessor_name}")
        print(f"   Term: {lease.term_years} years")
        print(f"   Start: {lease.start_date}")
        print(f"   End: {lease.end_date}")
        print(f"   Ground Rent: {lease.ground_rent_text}")
        print(f"   Apportionment: {lease.apportionment_pct}%")
        print(f"   Rent Review Period: {lease.rent_review_period} years")
        print(f"   Clauses Extracted: {len(lease.clauses)}")

        # Show sample clauses
        for i, clause in enumerate(lease.clauses[:3]):
            print(f"\n   Clause {clause['clause_number']} ({clause['clause_category']}):")
            print(f"      {clause['clause_text'][:100]}...")

        print(f"\n   Confidence: {lease.confidence:.2f}")
        return True
    else:
        print("❌ No leases extracted")
        return False


def test_sql_lease_extraction():
    """Test the SQL-level lease extractor"""
    from extractors.lease_extractor import LeaseExtractor
    import uuid

    print("\n" + "=" * 60)
    print("TEST 2: SQL-Level Lease Extractor with lease_clauses")
    print("=" * 60)

    sample_file_data = {
        'file_name': 'flat_5a_lease.pdf',
        'full_text': """
        LEASE dated 1 January 1990
        LESSOR: Connaught Square Estates Limited
        LESSEE: Mr. John Smith

        Property: Flat 5A, 32 Connaught Square, London W2 2HL

        Term: 125 years from 1 January 1990
        Ground Rent: £100 per annum
        Service Charge: £2,500 per annum

        CLAUSES:

        1.1 RENT: The Lessee shall pay the Ground Rent on the usual quarter days

        2.1 REPAIR: The Lessee covenants to keep the demised premises in good repair

        3.1 INSURANCE: The Lessor shall insure and the Lessee shall pay the proportion

        4.1 ALTERATIONS: No structural alterations without Lessor consent

        5.1 ASSIGNMENT: Assignment permitted with Lessor consent not unreasonably withheld
        """
    }

    building_id = str(uuid.uuid4())
    unit_id = str(uuid.uuid4())

    extractor = LeaseExtractor()
    result = extractor.extract(sample_file_data, building_id, unit_id)

    if result:
        lease = result['lease']
        lease_clauses = result.get('lease_clauses', [])

        print(f"✅ Extracted lease:")
        print(f"   ID: {lease['id']}")
        print(f"   Lessor: {lease['lessor']}")
        print(f"   Leaseholder: {lease['leaseholder_name']}")
        print(f"   Start Date: {lease['lease_start_date']}")
        print(f"   Term: {lease['original_term_years']} years")
        print(f"   Expiry: {lease['lease_expiry_date']}")
        print(f"   Ground Rent: £{lease['ground_rent']}")
        print(f"   Service Charge: £{lease['service_charge_amount']}")
        print(f"\n✅ Extracted {len(lease_clauses)} lease_clauses records:")

        for clause in lease_clauses[:5]:
            print(f"\n   Clause {clause['clause_number']} ({clause['clause_category']}):")
            print(f"      {clause['clause_summary']}")

        return True
    else:
        print("❌ No lease extracted")
        return False


def test_sql_generation():
    """Test SQL generation with lease_clauses"""
    from sql_writer import SQLWriter
    import uuid

    print("\n" + "=" * 60)
    print("TEST 3: SQL Generation with lease_clauses table")
    print("=" * 60)

    building_id = str(uuid.uuid4())
    lease_id = str(uuid.uuid4())

    # Mock mapped data
    mapped_data = {
        'building': {
            'id': building_id,
            'name': 'Connaught Square',
            'address': '32 Connaught Square, London W2 2HL'
        },
        'leases': [{
            'id': lease_id,
            'building_id': building_id,
            'lessor': 'Connaught Square Estates Ltd',
            'leaseholder_name': 'John Smith',
            'lease_start_date': '1990-01-01',
            'original_term_years': 125,
            'lease_expiry_date': '2115-01-01',
            'ground_rent': 100.00,
        }],
        'lease_clauses': [
            {
                'id': str(uuid.uuid4()),
                'lease_id': lease_id,
                'building_id': building_id,
                'clause_number': '1.1',
                'clause_category': 'rent',
                'clause_text': 'The Lessee shall pay the Ground Rent on the usual quarter days',
                'clause_summary': 'Payment of ground rent quarterly'
            },
            {
                'id': str(uuid.uuid4()),
                'lease_id': lease_id,
                'building_id': building_id,
                'clause_number': '2.1',
                'clause_category': 'repair',
                'clause_text': 'The Lessee covenants to keep the demised premises in good repair',
                'clause_summary': 'Maintain premises in good repair'
            }
        ]
    }

    writer = SQLWriter()
    sql = writer.generate_migration(mapped_data)

    # Check if lease_clauses INSERT statements are present
    if 'lease_clauses' in sql:
        print("✅ SQL generation includes lease_clauses table")

        # Count INSERT statements for lease_clauses
        clause_inserts = sql.count('INSERT INTO lease_clauses')
        print(f"✅ Found {clause_inserts} lease_clauses INSERT statements")

        # Show sample SQL
        lines = sql.split('\n')
        for i, line in enumerate(lines):
            if 'lease_clauses' in line.lower():
                print(f"\n   Sample SQL (line {i}):")
                print(f"   {line[:100]}...")
                break

        return True
    else:
        print("❌ SQL generation missing lease_clauses table")
        return False


def test_health_check_pdf():
    """Test health check PDF generation"""
    from generate_health_check_from_extraction import load_extraction_data

    print("\n" + "=" * 60)
    print("TEST 4: Health Check PDF with Lease Data")
    print("=" * 60)

    # Check if there's an output directory to test with
    test_output_dir = Path.home() / "Desktop" / "BlocIQ_Output"

    if not test_output_dir.exists():
        print(f"⚠️  No test output directory found at {test_output_dir}")
        print(f"   Skipping PDF generation test")
        return None

    try:
        print(f"📂 Loading extraction data from {test_output_dir}")
        data = load_extraction_data(str(test_output_dir))

        print(f"✅ Data loaded successfully:")
        print(f"   Building: {data['building']['name']}")
        print(f"   Units: {len(data.get('units', []))}")
        print(f"   Leases: {len(data.get('leases', []))}")
        print(f"   Compliance: {len(data.get('compliance_assets', []))}")

        # Check health metrics
        if 'health_metrics' in data:
            metrics = data['health_metrics']
            print(f"\n📊 Health Metrics:")
            print(f"   Overall Score: {metrics['health_score']}/100")
            print(f"   Lease Score: {metrics['lease_score']}/100")

        return True

    except Exception as e:
        print(f"❌ Error loading extraction data: {e}")
        return False


def main():
    """Run all tests"""
    print("\n🧪 BlocIQ Complete Lease Extraction Test Suite")
    print("=" * 60)

    results = []

    # Test 1: Deep parser extractor
    try:
        result = test_lease_extraction()
        results.append(("Deep Parser Lease Extractor", result))
    except Exception as e:
        print(f"❌ Test 1 failed with error: {e}")
        import traceback
        traceback.print_exc()
        results.append(("Deep Parser Lease Extractor", False))

    # Test 2: SQL-level extractor
    try:
        result = test_sql_lease_extraction()
        results.append(("SQL-Level Lease Extractor", result))
    except Exception as e:
        print(f"❌ Test 2 failed with error: {e}")
        import traceback
        traceback.print_exc()
        results.append(("SQL-Level Lease Extractor", False))

    # Test 3: SQL generation
    try:
        result = test_sql_generation()
        results.append(("SQL Generation", result))
    except Exception as e:
        print(f"❌ Test 3 failed with error: {e}")
        import traceback
        traceback.print_exc()
        results.append(("SQL Generation", False))

    # Test 4: Health check PDF
    try:
        result = test_health_check_pdf()
        results.append(("Health Check PDF", result))
    except Exception as e:
        print(f"❌ Test 4 failed with error: {e}")
        import traceback
        traceback.print_exc()
        results.append(("Health Check PDF", False))

    # Summary
    print("\n" + "=" * 60)
    print("TEST SUMMARY")
    print("=" * 60)

    for test_name, result in results:
        status = "✅ PASS" if result else "❌ FAIL" if result is False else "⚠️  SKIP"
        print(f"{status}: {test_name}")

    passed = sum(1 for _, r in results if r is True)
    failed = sum(1 for _, r in results if r is False)
    skipped = sum(1 for _, r in results if r is None)

    print(f"\nTotal: {passed} passed, {failed} failed, {skipped} skipped")

    return failed == 0


if __name__ == "__main__":
    success = main()
    sys.exit(0 if success else 1)
