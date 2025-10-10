#!/usr/bin/env python3
"""
Query Supabase to understand actual data structure and relationships
"""

import pg8000
import json

SUPABASE_CONFIG = {
    'host': 'aws-1-eu-west-1.pooler.supabase.com',
    'port': 6543,
    'user': 'postgres.aewixchhykxyhqjvqoek',
    'password': '1Poppydog!234',
    'database': 'postgres'
}

def inspect_data():
    conn = pg8000.connect(**SUPABASE_CONFIG)
    cursor = conn.cursor()

    try:
        # Find Connaught Square
        cursor.execute("SELECT id, name, address FROM buildings WHERE name ILIKE '%Connaught%' LIMIT 1")
        building = cursor.fetchone()
        if not building:
            print("❌ Building not found")
            return

        building_id = building[0]
        print(f"✅ Found: {building[1]}")
        print(f"   ID: {building_id}\n")

        # Check units
        cursor.execute("""
            SELECT id, unit_number, unit_type, property_address
            FROM units WHERE building_id = %s LIMIT 3
        """, (building_id,))
        units = cursor.fetchall()
        print(f"📦 Units: {len(units)} found")
        if units:
            for u in units:
                print(f"   - {u[1]}: {u[2]} at {u[3]}")

        # Check leaseholders with JOIN to units
        cursor.execute("""
            SELECT l.id, l.full_name, l.unit_id, u.unit_number
            FROM leaseholders l
            LEFT JOIN units u ON l.unit_id = u.id
            WHERE l.building_id = %s LIMIT 5
        """, (building_id,))
        leaseholders = cursor.fetchall()
        print(f"\n👤 Leaseholders: {len(leaseholders)} found")
        if leaseholders:
            for lh in leaseholders:
                print(f"   - {lh[1]} (Unit: {lh[3] or 'Not linked'})")

        # Check leases with JOINs
        cursor.execute("""
            SELECT l.id, l.leaseholder_id, l.unit_id, l.term_start, l.term_years, l.ground_rent
            FROM leases l
            WHERE l.building_id = %s LIMIT 5
        """, (building_id,))
        leases = cursor.fetchall()
        print(f"\n📄 Leases: {len(leases)} found")
        if leases:
            for lease in leases:
                print(f"   - Lease {lease[0][:8]}... Term: {lease[4]} years, Ground Rent: £{lease[5] or 0}")

        # Check complete lease data with full JOIN
        cursor.execute("""
            SELECT
                l.id,
                u.unit_number,
                lh.full_name as leaseholder_name,
                l.term_start,
                l.term_years,
                l.expiry_date,
                l.ground_rent,
                l.service_charge_period
            FROM leases l
            LEFT JOIN units u ON l.unit_id = u.id
            LEFT JOIN leaseholders lh ON l.leaseholder_id = lh.id
            WHERE l.building_id = %s
            LIMIT 3
        """, (building_id,))
        full_leases = cursor.fetchall()
        print(f"\n📋 Full Lease Records (with JOINs): {len(full_leases)}")
        if full_leases:
            for fl in full_leases:
                print(f"   - {fl[1]}: {fl[2]}, {fl[4]} years, £{fl[6] or 0}/year")

        # Check compliance
        cursor.execute("""
            SELECT asset_name, compliance_category, compliance_status, last_inspection_date, next_due_date
            FROM compliance_assets WHERE building_id = %s LIMIT 5
        """, (building_id,))
        compliance = cursor.fetchall()
        print(f"\n✅ Compliance Assets: {len(compliance)} found")
        if compliance:
            for c in compliance:
                print(f"   - {c[0]}: {c[1]} ({c[2]})")

        # Check insurance
        cursor.execute("""
            SELECT provider, policy_number, policy_start_date, expiry_date, sum_insured, premium_amount
            FROM building_insurance WHERE building_id = %s LIMIT 5
        """, (building_id,))
        insurance = cursor.fetchall()
        print(f"\n🛡️  Insurance: {len(insurance)} found")
        if insurance:
            for ins in insurance:
                print(f"   - {ins[0]}: {ins[1]} (£{ins[4] or 0} sum insured)")

        # Check budgets
        cursor.execute("""
            SELECT period, cost_heading, total_amount, status
            FROM budgets WHERE building_id = %s LIMIT 5
        """, (building_id,))
        budgets = cursor.fetchall()
        print(f"\n💰 Budgets: {len(budgets)} found")
        if budgets:
            for b in budgets:
                print(f"   - {b[0]}: {b[1]} = £{b[2] or 0}")

        # Check contractors - look for 'contracts' table
        try:
            cursor.execute("""
                SELECT contractor_name, service_type, contract_end_date, contract_status
                FROM building_contractors WHERE building_id = %s LIMIT 5
            """, (building_id,))
            contractors = cursor.fetchall()
            print(f"\n🔧 Contractors: {len(contractors)} found")
            if contractors:
                for c in contractors:
                    print(f"   - {c[0]}: {c[1]}")
        except Exception as e:
            print(f"\n🔧 Contractors table error: {e}")

        # Check major works
        cursor.execute("""
            SELECT title, status, start_date, end_date, estimated_cost
            FROM major_works_projects WHERE building_id = %s LIMIT 5
        """, (building_id,))
        major_works = cursor.fetchall()
        print(f"\n🏗️  Major Works: {len(major_works)} found")
        if major_works:
            for mw in major_works:
                print(f"   - {mw[0]}: {mw[1]} (£{mw[4] or 0})")

    finally:
        cursor.close()
        conn.close()

if __name__ == "__main__":
    inspect_data()
