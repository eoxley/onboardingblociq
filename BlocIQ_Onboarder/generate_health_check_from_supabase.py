#!/usr/bin/env python3
"""
BlocIQ Building Health Check Generator - From Supabase
Generates a professional PDF health check report using live data from Supabase
"""

import pg8000
import json
from datetime import datetime
from pathlib import Path
from reporting.building_health_check_v2 import generate_health_check_v2

# Supabase connection details
SUPABASE_CONFIG = {
    'host': 'aws-1-eu-west-1.pooler.supabase.com',
    'port': 6543,
    'user': 'postgres.aewixchhykxyhqjvqoek',
    'password': '1Poppydog!234',
    'database': 'postgres'
}


def fetch_building_data(building_name: str = None, building_id: str = None):
    """Fetch complete building data from Supabase"""

    conn = pg8000.connect(**SUPABASE_CONFIG)
    cursor = conn.cursor()

    try:
        # Find building
        if building_id:
            cursor.execute("SELECT * FROM buildings WHERE id = %s", (building_id,))
        elif building_name:
            cursor.execute("SELECT * FROM buildings WHERE name ILIKE %s", (f"%{building_name}%",))
        else:
            raise ValueError("Must provide either building_name or building_id")

        building_row = cursor.fetchone()
        if not building_row:
            raise ValueError(f"Building not found: {building_name or building_id}")

        # Get column names
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

        # Fetch units
        cursor.execute("""
            SELECT * FROM units WHERE building_id = %s
        """, (building_id,))
        cursor.execute("SELECT column_name FROM information_schema.columns WHERE table_name = 'units' ORDER BY ordinal_position")
        unit_columns = [row[0] for row in cursor.fetchall()]
        cursor.execute("SELECT * FROM units WHERE building_id = %s", (building_id,))
        units = [dict(zip(unit_columns, row)) for row in cursor.fetchall()]
        print(f"   Units: {len(units)}")

        # Fetch leaseholders
        cursor.execute("SELECT column_name FROM information_schema.columns WHERE table_name = 'leaseholders' ORDER BY ordinal_position")
        lh_columns = [row[0] for row in cursor.fetchall()]
        cursor.execute("SELECT * FROM leaseholders WHERE building_id = %s", (building_id,))
        leaseholders = [dict(zip(lh_columns, row)) for row in cursor.fetchall()]
        print(f"   Leaseholders: {len(leaseholders)}")

        # Fetch leases
        cursor.execute("SELECT column_name FROM information_schema.columns WHERE table_name = 'leases' ORDER BY ordinal_position")
        lease_columns = [row[0] for row in cursor.fetchall()]
        cursor.execute("SELECT * FROM leases WHERE building_id = %s", (building_id,))
        leases = [dict(zip(lease_columns, row)) for row in cursor.fetchall()]
        print(f"   Leases: {len(leases)}")

        # Fetch maintenance schedules
        cursor.execute("SELECT column_name FROM information_schema.columns WHERE table_name = 'schedules' ORDER BY ordinal_position")
        schedule_columns = [row[0] for row in cursor.fetchall()]
        cursor.execute("SELECT * FROM schedules WHERE building_id = %s", (building_id,))
        schedules = [dict(zip(schedule_columns, row)) for row in cursor.fetchall()]
        print(f"   Maintenance Schedules: {len(schedules)}")

        # Fetch compliance assets
        cursor.execute("SELECT column_name FROM information_schema.columns WHERE table_name = 'compliance_assets' ORDER BY ordinal_position")
        compliance_columns = [row[0] for row in cursor.fetchall()]
        cursor.execute("SELECT * FROM compliance_assets WHERE building_id = %s", (building_id,))
        compliance_assets = [dict(zip(compliance_columns, row)) for row in cursor.fetchall()]
        print(f"   Compliance Assets: {len(compliance_assets)}")

        # Fetch building contractors
        cursor.execute("SELECT column_name FROM information_schema.columns WHERE table_name = 'building_contractors' ORDER BY ordinal_position")
        contractor_columns = [row[0] for row in cursor.fetchall()]
        cursor.execute("SELECT * FROM building_contractors WHERE building_id = %s", (building_id,))
        contractors = [dict(zip(contractor_columns, row)) for row in cursor.fetchall()]
        print(f"   Contractors: {len(contractors)}")

        # Fetch insurance
        cursor.execute("SELECT column_name FROM information_schema.columns WHERE table_name = 'building_insurance' ORDER BY ordinal_position")
        insurance_columns = [row[0] for row in cursor.fetchall()]
        cursor.execute("SELECT * FROM building_insurance WHERE building_id = %s", (building_id,))
        insurance = [dict(zip(insurance_columns, row)) for row in cursor.fetchall()]
        print(f"   Insurance Policies: {len(insurance)}")

        # Fetch budgets
        cursor.execute("SELECT column_name FROM information_schema.columns WHERE table_name = 'budgets' ORDER BY ordinal_position")
        budget_columns = [row[0] for row in cursor.fetchall()]
        cursor.execute("SELECT * FROM budgets WHERE building_id = %s", (building_id,))
        budgets = [dict(zip(budget_columns, row)) for row in cursor.fetchall()]
        print(f"   Budgets: {len(budgets)}")

        # Fetch assets
        cursor.execute("SELECT column_name FROM information_schema.columns WHERE table_name = 'assets' ORDER BY ordinal_position")
        asset_columns = [row[0] for row in cursor.fetchall()]
        cursor.execute("SELECT * FROM assets WHERE building_id = %s", (building_id,))
        assets = [dict(zip(asset_columns, row)) for row in cursor.fetchall()]
        print(f"   Assets: {len(assets)}")

        # Fetch major works
        cursor.execute("SELECT column_name FROM information_schema.columns WHERE table_name = 'major_works_projects' ORDER BY ordinal_position")
        mw_columns = [row[0] for row in cursor.fetchall()]
        cursor.execute("SELECT * FROM major_works_projects WHERE building_id = %s", (building_id,))
        major_works = [dict(zip(mw_columns, row)) for row in cursor.fetchall()]
        print(f"   Major Works: {len(major_works)}")

        # Build structured data
        building_data = {
            'building': building,
            'units': units,
            'leaseholders': leaseholders,
            'leases': leases,
            'maintenance_schedules': schedules,
            'compliance_assets': compliance_assets,
            'building_contractors': contractors,
            'insurance_policies': insurance,
            'budgets': budgets,
            'assets': assets,
            'major_works_projects': major_works
        }

        return building_data

    finally:
        cursor.close()
        conn.close()


def generate_health_check(building_name: str = None, building_id: str = None, output_path: str = None):
    """Generate health check PDF from Supabase data"""

    print(f"\n📊 Fetching data from Supabase...")
    building_data = fetch_building_data(building_name=building_name, building_id=building_id)

    # Default output path
    if not output_path:
        building_slug = building_data['building']['name'].replace(' ', '_').lower()
        output_path = f"/Users/ellie/Desktop/BlocIQ_Output/{building_slug}_health_check_{datetime.now().strftime('%Y%m%d')}.pdf"

    print(f"\n📄 Generating Building Health Check PDF...")
    pdf_path = generate_health_check_v2(building_data, output_path)

    if pdf_path:
        print(f"\n✅ Health Check PDF generated successfully!")
        print(f"📁 Location: {pdf_path}")
        return pdf_path
    else:
        print(f"\n❌ PDF generation failed")
        return None


if __name__ == "__main__":
    import sys

    if len(sys.argv) < 2:
        print("Usage: python3 generate_health_check_from_supabase.py <building_name>")
        print("Example: python3 generate_health_check_from_supabase.py 'Connaught Square'")
        sys.exit(1)

    building_name = sys.argv[1]
    generate_health_check(building_name=building_name)
