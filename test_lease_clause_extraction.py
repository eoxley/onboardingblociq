#!/usr/bin/env python3
"""
Quick Test: Verify lease clause extraction works end-to-end
"""

import sys
from pathlib import Path

# Add BlocIQ_Onboarder to path
sys.path.insert(0, str(Path(__file__).parent / 'BlocIQ_Onboarder'))

def test_lease_clause_extraction():
    """Test that lease clauses are extracted and propagated correctly"""
    print("=" * 70)
    print("TEST: Lease Clause Extraction & SQL Generation")
    print("=" * 70)

    from extractors.lease_extractor import LeaseExtractor
    from sql_writer import SQLWriter
    import uuid

    # Sample lease document text
    sample_lease_text = """
    LEASE AGREEMENT

    Flat 5A, 32 Connaught Square, London W2 2HL

    Date: 1st January 1990

    PARTIES:
    LESSOR: Connaught Square Estates Limited
    LESSEE: Mr. John Smith and Mrs. Jane Smith

    TERM: 125 years from the date hereof

    GROUND RENT: £150 per annum

    CLAUSES:

    1.1 RENT PAYMENT
    The Lessee shall pay the Ground Rent on the usual quarter days without demand or deduction.

    2.1 REPAIR AND MAINTENANCE
    The Lessee covenants to keep the demised premises in good and tenantable repair and condition.

    3.1 INSURANCE
    The Lessor shall insure the building and the Lessee shall pay the proportion of the premium.

    4.1 SERVICE CHARGE
    The Lessee shall pay a fair proportion of the costs of repair and maintenance of the common parts.

    5.1 ALTERATIONS
    No structural alterations shall be made without the prior written consent of the Lessor.

    6.1 ASSIGNMENT AND SUBLETTING
    Assignment is permitted with the Lessor's consent, such consent not to be unreasonably withheld.

    7.1 FORFEITURE
    The Lessor may re-enter the premises if any rent remains unpaid for 21 days after becoming due.
    """

    building_id = str(uuid.uuid4())
    unit_id = str(uuid.uuid4())

    print("\n1. Testing LeaseExtractor...")
    extractor = LeaseExtractor()

    file_data = {
        'file_name': 'Flat_5A_Lease.pdf',
        'full_text': sample_lease_text
    }

    result = extractor.extract(file_data, building_id, unit_id)

    if not result:
        print("❌ No result from extractor")
        return False

    lease = result.get('lease')
    lease_clauses = result.get('lease_clauses', [])

    print(f"✅ Extracted lease:")
    print(f"   Lessor: {lease.get('lessor')}")
    print(f"   Start Date: {lease.get('lease_start_date')}")
    print(f"   Term: {lease.get('original_term_years')} years")
    print(f"   Ground Rent: £{lease.get('ground_rent')}")

    print(f"\n✅ Extracted {len(lease_clauses)} lease clauses:")
    for clause in lease_clauses:
        print(f"   • Clause {clause['clause_number']}: {clause['clause_category']}")
        print(f"     {clause['clause_summary']}")

    # Debug: Show full clause structure
    if lease_clauses:
        print(f"\n   🔍 Debug: First clause structure:")
        for key, value in lease_clauses[0].items():
            print(f"      {key}: {type(value).__name__} = {str(value)[:50]}")

    if not lease_clauses:
        print("❌ No lease clauses extracted!")
        return False

    # Test SQL generation
    print("\n2. Testing SQL Generation with lease_clauses...")
    mapped_data = {
        'building': {
            'id': building_id,
            'name': 'Test Building',
            'address': '32 Connaught Square'
        },
        'leases': [lease],
        'lease_clauses': lease_clauses
    }

    print(f"\n   📊 Mapped data contains:")
    print(f"   • building: {mapped_data.get('building', {}).get('name')}")
    print(f"   • leases: {len(mapped_data.get('leases', []))} records")
    print(f"   • lease_clauses: {len(mapped_data.get('lease_clauses', []))} records")

    # Debug: Check if schema validator knows about lease_clauses
    from schema_validator import SchemaValidator
    validator = SchemaValidator()
    print(f"\n   🔍 Schema validator has lease_clauses: {'lease_clauses' in validator.schema}")
    if 'lease_clauses' in validator.schema:
        print(f"      Columns: {list(validator.schema['lease_clauses'].keys())[:5]}")

    sql_writer = SQLWriter()
    sql = sql_writer.generate_migration(mapped_data)

    # Save SQL to file for inspection
    with open('/tmp/test_lease_clauses.sql', 'w') as f:
        f.write(sql)
    print(f"   💾 SQL saved to /tmp/test_lease_clauses.sql for inspection")

    # Check for lease_clauses inserts
    if 'INSERT INTO lease_clauses' in sql:
        clause_count = sql.count('INSERT INTO lease_clauses')
        print(f"✅ Found {clause_count} lease_clauses INSERT statements in SQL")

        # Show sample SQL
        lines = sql.split('\n')
        for i, line in enumerate(lines):
            if 'INSERT INTO lease_clauses' in line:
                print(f"\n   Sample SQL:")
                for j in range(i, min(i+3, len(lines))):
                    print(f"   {lines[j][:100]}")
                break

        return True
    else:
        print("❌ No lease_clauses INSERT statements found in SQL!")
        return False


if __name__ == "__main__":
    success = test_lease_clause_extraction()
    if success:
        print("\n🎉 SUCCESS: Lease clause extraction and SQL generation working!")
    else:
        print("\n❌ FAILED: Lease clause extraction or SQL generation not working")
    sys.exit(0 if success else 1)
