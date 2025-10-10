#!/usr/bin/env python3
"""
BlocIQ Building Health Check Generator V3 - From Supabase
Complete rewrite with proper JOINs and real data validation
"""

import pg8000
import json
from datetime import datetime, date
from pathlib import Path
from reporting.building_health_check_v3 import generate_health_check_v3

# Supabase connection details
SUPABASE_CONFIG = {
    'host': 'aws-1-eu-west-1.pooler.supabase.com',
    'port': 6543,
    'user': 'postgres.aewixchhykxyhqjvqoek',
    'password': '1Poppydog!234',
    'database': 'postgres'
}


def fetch_building_data_v3(building_name: str = None, building_id: str = None):
    """Fetch complete building data from Supabase with proper JOINs"""

    conn = pg8000.connect(**SUPABASE_CONFIG)
    cursor = conn.cursor()

    try:
        # ===== FIND BUILDING =====
        if building_id:
            cursor.execute("SELECT * FROM buildings WHERE id = %s", (building_id,))
        elif building_name:
            cursor.execute("SELECT * FROM buildings WHERE name ILIKE %s", (f"%{building_name}%",))
        else:
            raise ValueError("Must provide either building_name or building_id")

        building_row = cursor.fetchone()
        if not building_row:
            raise ValueError(f"Building not found: {building_name or building_id}")

        # Get column names for buildings
        cursor.execute("""
            SELECT column_name
            FROM information_schema.columns
            WHERE table_name = 'buildings'
            ORDER BY ordinal_position
        """)
        building_columns = [row[0] for row in cursor.fetchall()]
        building = dict(zip(building_columns, building_row))
        building_id = building['id']

        print(f"✅ Found building: {building['name']}")

        # ===== FETCH HEALTH SCORE FROM VIEW =====
        cursor.execute("""
            SELECT
                health_score, rating,
                compliance_score, insurance_score, budget_score,
                lease_score, contractor_score
            FROM v_building_health_score
            WHERE building_id = %s
        """, (building_id,))
        health_row = cursor.fetchone()
        health_metrics = {
            'health_score': float(health_row[0]) if health_row and health_row[0] else 0.0,
            'rating': health_row[1] if health_row else 'Unknown',
            'compliance_score': float(health_row[2]) if health_row and health_row[2] else 0.0,
            'insurance_score': float(health_row[3]) if health_row and health_row[3] else 0.0,
            'budget_score': float(health_row[4]) if health_row and health_row[4] else 0.0,
            'lease_score': float(health_row[5]) if health_row and health_row[5] else 0.0,
            'contractor_score': float(health_row[6]) if health_row and health_row[6] else 0.0
        } if health_row else {
            'health_score': 0.0,
            'rating': 'Unknown',
            'compliance_score': 0.0,
            'insurance_score': 0.0,
            'budget_score': 0.0,
            'lease_score': 0.0,
            'contractor_score': 0.0
        }
        print(f"   Health Score: {health_metrics['health_score']:.1f}/100 ({health_metrics['rating']})")

        # ===== FETCH UNITS =====
        cursor.execute("""
            SELECT id, building_id, unit_number, created_at
            FROM units WHERE building_id = %s
            ORDER BY unit_number
        """, (building_id,))
        units = [
            {
                'id': row[0],
                'building_id': row[1],
                'unit_number': row[2],
                'created_at': row[3]
            }
            for row in cursor.fetchall()
        ]
        print(f"   Units: {len(units)}")

        # ===== FETCH LEASEHOLDERS (with unit linkage) =====
        cursor.execute("""
            SELECT
                l.id,
                l.unit_id,
                l.name,
                l.email,
                l.correspondence_address,
                l.unit_number,
                u.unit_number as unit_ref
            FROM leaseholders l
            LEFT JOIN units u ON l.unit_id = u.id
            WHERE l.building_id = %s
            ORDER BY l.name
        """, (building_id,))
        leaseholders = [
            {
                'id': row[0],
                'unit_id': row[1],
                'full_name': row[2],
                'name': row[2],
                'email': row[3],
                'correspondence_address': row[4],
                'unit_number': row[5] or row[6]
            }
            for row in cursor.fetchall()
        ]
        print(f"   Leaseholders: {len(leaseholders)}")

        # ===== FETCH LEASES (with full JOINs) =====
        cursor.execute("""
            SELECT
                l.id,
                l.unit_id,
                l.leaseholder_id,
                l.lease_type,
                l.start_date,
                l.end_date,
                l.expiry_date,
                l.confidence_score,
                u.unit_number,
                lh.name as leaseholder_name
            FROM leases l
            LEFT JOIN units u ON l.unit_id = u.id
            LEFT JOIN leaseholders lh ON l.leaseholder_id = lh.id
            WHERE l.building_id = %s
            ORDER BY u.unit_number
        """, (building_id,))
        leases = [
            {
                'id': row[0],
                'unit_id': row[1],
                'leaseholder_id': row[2],
                'lease_type': row[3],
                'term_start': row[4],
                'start_date': row[4],
                'term_end': row[5],
                'end_date': row[5],
                'expiry_date': row[6],
                'confidence_score': float(row[7]) if row[7] else 0.0,
                'unit_name': row[8],
                'unit_number': row[8],
                'leaseholder_name': row[9],
                # Calculate term years
                'term_years': ((row[5] - row[4]).days // 365) if row[4] and row[5] else None,
                'ground_rent': 0.0,  # Not in current schema
                'service_charge_period': None  # Not in current schema
            }
            for row in cursor.fetchall()
        ]
        print(f"   Leases: {len(leases)}")

        # ===== FETCH LEASE COVERAGE FROM VIEW =====
        cursor.execute("""
            SELECT
                total_units, leased_units, lease_pct
            FROM v_lease_coverage
            WHERE building_id = %s
        """, (building_id,))
        coverage_row = cursor.fetchone()
        lease_coverage = {
            'total_units': int(coverage_row[0]) if coverage_row else 0,
            'leased_units': int(coverage_row[1]) if coverage_row else 0,
            'lease_pct': float(coverage_row[2]) if coverage_row and coverage_row[2] else 0.0
        } if coverage_row else {
            'total_units': 0,
            'leased_units': 0,
            'lease_pct': 0.0
        }
        print(f"   Lease Coverage: {lease_coverage['leased_units']}/{lease_coverage['total_units']} units ({lease_coverage['lease_pct']:.0f}%)")

        # ===== FETCH MAINTENANCE SCHEDULES =====
        cursor.execute("""
            SELECT
                id, building_id, name, contract_id, service_type,
                frequency, frequency_interval, next_due_date,
                priority, status, estimated_duration, created_at
            FROM schedules
            WHERE building_id = %s
            ORDER BY priority DESC, next_due_date
        """, (building_id,))
        schedules = [
            {
                'id': row[0],
                'building_id': row[1],
                'name': row[2],
                'contract_id': row[3],
                'service_type': row[4],
                'frequency': row[5],
                'frequency_interval': row[6],
                'next_due_date': row[7],
                'priority': row[8],
                'status': row[9],
                'estimated_duration': row[10],
                'created_at': row[11]
            }
            for row in cursor.fetchall()
        ]
        print(f"   Maintenance Schedules: {len(schedules)}")

        # ===== FETCH COMPLIANCE ROLLUP FROM VIEW =====
        cursor.execute("""
            SELECT
                total_assets, ok_count, overdue_count, unknown_count, ok_pct
            FROM v_compliance_rollup
            WHERE building_id = %s
        """, (building_id,))
        rollup_row = cursor.fetchone()
        compliance_rollup = {
            'total_assets': int(rollup_row[0]) if rollup_row else 0,
            'ok_count': int(rollup_row[1]) if rollup_row else 0,
            'overdue_count': int(rollup_row[2]) if rollup_row else 0,
            'unknown_count': int(rollup_row[3]) if rollup_row else 0,
            'ok_pct': float(rollup_row[4]) if rollup_row and rollup_row[4] else 0.0
        } if rollup_row else {
            'total_assets': 0,
            'ok_count': 0,
            'overdue_count': 0,
            'unknown_count': 0,
            'ok_pct': 0.0
        }
        print(f"   Compliance: {compliance_rollup['ok_count']} OK, {compliance_rollup['overdue_count']} Overdue, {compliance_rollup['unknown_count']} Unknown")

        # ===== FETCH COMPLIANCE ASSETS =====
        cursor.execute("""
            SELECT
                id, asset_name, asset_type, description,
                inspection_frequency, last_inspection_date, next_due_date,
                compliance_status, location, responsible_party,
                notes, is_active, confidence_score,
                reinspection_date, inspection_contractor
            FROM compliance_assets
            WHERE building_id = %s
            ORDER BY compliance_status, next_due_date
        """, (building_id,))
        compliance_assets = [
            {
                'id': row[0],
                'asset_name': row[1],
                'asset_type': row[2],
                'description': row[3],
                'inspection_frequency': row[4],
                'last_inspection_date': row[5],
                'next_due_date': row[6],
                'compliance_status': row[7],
                'compliance_category': row[2],  # Use asset_type as category
                'location': row[8],
                'responsible_party': row[9],
                'notes': row[10],
                'is_active': row[11],
                'confidence_score': float(row[12]) if row[12] else 0.0,
                'reinspection_date': row[13],
                'inspection_contractor': row[14]
            }
            for row in cursor.fetchall()
        ]
        print(f"   Compliance Assets: {len(compliance_assets)}")

        # ===== FETCH BUILDING CONTRACTORS =====
        cursor.execute("""
            SELECT
                id, contractor_type, company_name, contact_person,
                phone, email, contract_start, contract_end,
                notes, retender_status, retender_due_date,
                next_review_date, confidence_score
            FROM building_contractors
            WHERE building_id = %s
            ORDER BY company_name
        """, (building_id,))
        contractors = [
            {
                'id': row[0],
                'contractor_type': row[1],
                'contractor_name': row[2],
                'company_name': row[2],
                'contact_person': row[3],
                'phone': row[4],
                'email': row[5],
                'start_date': row[6],
                'contract_start': row[6],
                'end_date': row[7],
                'contract_end': row[7],
                'notes': row[8],
                'retender_status': row[9],
                'retender_due_date': row[10],
                'next_review_date': row[11],
                'confidence_score': float(row[12]) if row[12] else 0.0,
                'service_type': row[1],  # Use contractor_type as service_type
                'contract_status': 'active' if row[7] and row[7] >= date.today() else 'expired'
            }
            for row in cursor.fetchall()
        ]
        print(f"   Contractors: {len(contractors)}")

        # ===== FETCH INSURANCE FROM VIEW (with computed status) =====
        cursor.execute("""
            SELECT
                id, building_id, provider, policy_number, policy_type,
                period_start, period_end, sum_insured, premium_amount, status
            FROM v_insurance_status
            WHERE building_id = %s
            ORDER BY
                CASE status
                    WHEN 'Active' THEN 1
                    WHEN 'Expired' THEN 2
                    ELSE 3
                END,
                period_end DESC NULLS LAST
        """, (building_id,))
        insurance = [
            {
                'id': row[0],
                'building_id': row[1],
                'provider': row[2],
                'policy_number': row[3],
                'insurance_type': row[4],
                'policy_type': row[4],
                'period_start': row[5],
                'renewal_date': row[5],
                'policy_start_date': row[5],
                'period_end': row[6],
                'expiry_date': row[6],
                'sum_insured': float(row[7]) if row[7] else None,
                'coverage_amount': float(row[7]) if row[7] else None,
                'premium_amount': float(row[8]) if row[8] else None,
                'status': row[9],
                'insurance_status': row[9]
            }
            for row in cursor.fetchall()
        ]

        # Count by status
        active_count = sum(1 for i in insurance if i['status'] == 'Active')
        expired_count = sum(1 for i in insurance if i['status'] == 'Expired')
        unknown_count = sum(1 for i in insurance if i['status'] == 'Unknown')
        print(f"   Insurance: {len(insurance)} policies ({active_count} Active, {expired_count} Expired, {unknown_count} Unknown)")

        # ===== FETCH BUDGETS FROM VIEW (by service charge year) =====
        cursor.execute("""
            SELECT
                building_id, service_charge_year, line_items, total_amount
            FROM v_budget_years
            WHERE building_id = %s
            ORDER BY service_charge_year DESC
        """, (building_id,))
        budget_years = [
            {
                'building_id': row[0],
                'service_charge_year': row[1],
                'period': row[1],
                'year': row[1],
                'line_items': int(row[2]),
                'total_amount': float(row[3]) if row[3] else 0.0,
                'status': 'active'
            }
            for row in cursor.fetchall()
        ]

        # Also fetch individual budget items for detail view
        cursor.execute("""
            SELECT
                id, period, total_amount, start_date, end_date,
                demand_date_1, demand_date_2, year_end_date,
                budget_type, year, name, confidence_score,
                year_start, year_end
            FROM budgets
            WHERE building_id = %s
            ORDER BY period DESC, name
        """, (building_id,))
        budgets = [
            {
                'id': row[0],
                'period': row[1],
                'total_amount': float(row[2]) if row[2] else None,
                'start_date': row[3],
                'end_date': row[4],
                'demand_date_1': row[5],
                'demand_date_2': row[6],
                'year_end_date': row[7],
                'budget_type': row[8],
                'year': row[9],
                'name': row[10],
                'cost_heading': row[10] or row[1],  # Use name or period
                'confidence_score': float(row[11]) if row[11] else 0.0,
                'year_start': row[12],
                'year_end': row[13],
                'status': 'active'
            }
            for row in cursor.fetchall()
        ]
        print(f"   Budgets: {len(budget_years)} years, {len(budgets)} items")

        # ===== FETCH ASSETS =====
        cursor.execute("""
            SELECT id, building_id, created_at
            FROM assets
            WHERE building_id = %s
        """, (building_id,))
        assets = [
            {
                'id': row[0],
                'building_id': row[1],
                'created_at': row[2]
            }
            for row in cursor.fetchall()
        ]
        print(f"   Assets: {len(assets)}")

        # ===== FETCH MAJOR WORKS =====
        cursor.execute("""
            SELECT
                id, project_name, status, start_date, end_date
            FROM major_works_projects
            WHERE building_id = %s
            ORDER BY start_date DESC NULLS LAST
        """, (building_id,))
        major_works = [
            {
                'id': row[0],
                'title': row[1],
                'project_name': row[1],
                'status': row[2],
                'start_date': row[3],
                'end_date': row[4],
                'estimated_cost': None  # Not in current schema
            }
            for row in cursor.fetchall()
        ]
        print(f"   Major Works: {len(major_works)}")

        # ===== BUILD STRUCTURED DATA =====
        building_data = {
            'building': building,
            'units': units,
            'leaseholders': leaseholders,
            'leases': leases,
            'lease_coverage': lease_coverage,  # FROM VIEW
            'maintenance_schedules': schedules,
            'compliance_assets': compliance_assets,
            'compliance_rollup': compliance_rollup,  # FROM VIEW
            'building_contractors': contractors,
            'contracts': contractors,  # Alias for compatibility
            'insurance_policies': insurance,
            'budgets': budgets,
            'budget_years': budget_years,  # FROM VIEW (summary by year)
            'assets': assets,
            'major_works_projects': major_works,
            'health_metrics': health_metrics  # FROM VIEW (overall health score)
        }

        return building_data

    finally:
        cursor.close()
        conn.close()


def generate_health_check_v3_wrapper(building_name: str = None, building_id: str = None, output_path: str = None):
    """Generate health check PDF from Supabase data (V3)"""

    print(f"\n📊 Fetching data from Supabase (V3)...")
    building_data = fetch_building_data_v3(building_name=building_name, building_id=building_id)

    # Default output path
    if not output_path:
        building_slug = building_data['building']['name'].replace(' ', '_').lower()
        output_dir = Path("/Users/ellie/Desktop/BlocIQ_Output")
        output_dir.mkdir(exist_ok=True)
        output_path = output_dir / f"{building_slug}_health_check_v3_{datetime.now().strftime('%Y%m%d')}.pdf"

    print(f"\n📄 Generating Building Health Check PDF V3...")
    pdf_path = generate_health_check_v3(building_data, str(output_path))

    if pdf_path:
        print(f"\n✅ Health Check PDF V3 generated successfully!")
        print(f"📁 Location: {pdf_path}")
        return pdf_path
    else:
        print(f"\n❌ PDF generation failed")
        return None


if __name__ == "__main__":
    import sys

    if len(sys.argv) < 2:
        print("Usage: python3 generate_health_check_from_supabase_v3.py <building_name>")
        print("Example: python3 generate_health_check_from_supabase_v3.py 'Connaught Square'")
        sys.exit(1)

    building_name = sys.argv[1]
    generate_health_check_v3_wrapper(building_name=building_name)
