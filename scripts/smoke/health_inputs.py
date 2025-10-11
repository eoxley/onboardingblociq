#!/usr/bin/env python3
"""
Smoke test: Print key input counts for a building.
Quick sanity check of data available for health check generation.
"""
import os
import sys
import psycopg2
from psycopg2.extras import RealDictCursor


def check_health_inputs(building_id):
    """Print counts of health check inputs"""
    database_url = os.getenv('DATABASE_URL')
    if not database_url:
        raise ValueError("DATABASE_URL not set")

    conn = psycopg2.connect(database_url)
    cur = conn.cursor(cursor_factory=RealDictCursor)

    # Get building name
    cur.execute("SELECT name FROM buildings WHERE id = %s", (building_id,))
    building = cur.fetchone()
    if not building:
        print(f"❌ Building {building_id} not found")
        sys.exit(1)

    building_name = building['name']
    print(f"\n🏢 Building: {building_name}")
    print(f"   ID: {building_id}")
    print("=" * 60)

    # Documents
    cur.execute("""
        SELECT
            COUNT(*) as total,
            COUNT(*) FILTER (WHERE status='active') as active,
            COUNT(*) FILTER (WHERE status='archived') as archived,
            COUNT(*) FILTER (WHERE has_text=true) as has_text,
            COUNT(*) FILTER (WHERE needs_ocr=true) as needs_ocr
        FROM documents WHERE building_id = %s
    """, (building_id,))
    docs = cur.fetchone()

    print(f"\n📄 Documents:")
    print(f"   Total: {docs['total']}")
    print(f"   Active: {docs['active']}")
    print(f"   Archived: {docs['archived']}")
    print(f"   Has text: {docs['has_text']}")
    print(f"   Needs OCR: {docs['needs_ocr']}")

    # Insurance certificates
    cur.execute("""
        SELECT COUNT(*) as count
        FROM insurance_policies
        WHERE building_id = %s
    """, (building_id,))
    insurance = cur.fetchone()

    print(f"\n🛡️  Insurance Policies:")
    print(f"   Certificates: {insurance['count']}")

    # Compliance assets
    cur.execute("""
        SELECT
            COUNT(*) as total,
            COUNT(*) FILTER (WHERE status='OK') as ok,
            COUNT(*) FILTER (WHERE status='Overdue') as overdue,
            COUNT(*) FILTER (WHERE status='Unknown' OR status IS NULL) as unknown,
            COUNT(*) FILTER (WHERE dates_missing=true) as dates_missing,
            COUNT(*) FILTER (WHERE has_evidence=true) as has_evidence
        FROM compliance_assets WHERE building_id = %s
    """, (building_id,))
    compliance = cur.fetchone()

    print(f"\n✅ Compliance Assets:")
    print(f"   Total: {compliance['total']}")
    print(f"   OK: {compliance['ok']}")
    print(f"   Overdue: {compliance['overdue']}")
    print(f"   Unknown: {compliance['unknown']}")
    print(f"   Dates missing: {compliance['dates_missing']}")
    print(f"   Has evidence: {compliance['has_evidence']}")

    # Leases
    cur.execute("""
        SELECT
            COUNT(DISTINCT u.id) as leased_units,
            (SELECT COUNT(*) FROM units WHERE building_id = %s) as total_units,
            COUNT(l.id) as total_leases
        FROM units u
        LEFT JOIN leases l ON l.unit_id = u.id
        WHERE u.building_id = %s
    """, (building_id, building_id))
    leases = cur.fetchone()

    lease_pct = 0
    if leases['total_units'] > 0:
        lease_pct = round(100.0 * leases['leased_units'] / leases['total_units'], 1)

    print(f"\n📋 Leases:")
    print(f"   Total units: {leases['total_units']}")
    print(f"   Leased units: {leases['leased_units']}")
    print(f"   Lease coverage: {lease_pct}%")
    print(f"   Total lease records: {leases['total_leases']}")

    # Budget years
    cur.execute("""
        SELECT DISTINCT service_charge_year
        FROM budget_items
        WHERE building_id = %s AND service_charge_year IS NOT NULL
        ORDER BY service_charge_year DESC
    """, (building_id,))
    years = cur.fetchall()

    print(f"\n💰 Budget Years:")
    print(f"   Years present: {len(years)}")
    if years:
        for year in years[:5]:  # Show top 5
            print(f"     - {year['service_charge_year']}")

    # Compliance requirements status
    cur.execute("""
        SELECT
            COUNT(*) as total_requirements,
            ROUND(AVG(points), 2) as avg_points,
            COUNT(*) FILTER (WHERE points >= 1.0) as fully_met
        FROM compliance_requirements_status
        WHERE building_id = %s
    """, (building_id,))
    req_status = cur.fetchone()

    print(f"\n⚖️  Compliance Requirements:")
    print(f"   Total requirements: {req_status['total_requirements']}")
    print(f"   Avg points: {req_status['avg_points']}")
    print(f"   Fully met: {req_status['fully_met']}")

    cur.close()
    conn.close()

    print("\n" + "=" * 60)
    print("✅ Health inputs check complete\n")


if __name__ == '__main__':
    if len(sys.argv) < 2:
        print("Usage: python health_inputs.py <building_id>")
        sys.exit(1)

    building_id = sys.argv[1]
    check_health_inputs(building_id)
