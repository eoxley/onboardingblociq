#!/usr/bin/env python3
"""
BlocIQ Building Health Check Generator - From Extraction Data
Generates PDF directly from onboarder extraction (no Supabase query needed)
Uses: summary.json + mapped_data.json (to be created)
"""

import json
from pathlib import Path
from datetime import datetime, date
from typing import Dict, List
from reporting.building_health_check_v3 import generate_health_check_v3


def load_extraction_data(output_dir: str) -> Dict:
    """
    Load all extracted data from onboarder output directory

    Args:
        output_dir: Path to BlocIQ_Output folder

    Returns:
        Dictionary with all building data
    """
    output_path = Path(output_dir)

    # Load summary
    summary_file = output_path / 'summary.json'
    if not summary_file.exists():
        raise FileNotFoundError(f"Summary file not found: {summary_file}")

    with open(summary_file, 'r') as f:
        summary = json.load(f)

    # Load mapped data (if exists)
    mapped_data_file = output_path / 'mapped_data.json'
    if mapped_data_file.exists():
        with open(mapped_data_file, 'r') as f:
            mapped_data = json.load(f)
    else:
        print("⚠️  mapped_data.json not found - will use summary.json only")
        mapped_data = {}

    # Load audit log for additional context
    audit_file = output_path / 'audit_log.json'
    audit_log = []
    if audit_file.exists():
        with open(audit_file, 'r') as f:
            audit_log = json.load(f)

    # Build comprehensive data structure
    data = {
        'timestamp': summary.get('timestamp'),
        'building': {
            'name': summary.get('building_name', 'Unknown Building'),
            'address': mapped_data.get('building', {}).get('address', '—'),
            'managing_agent': mapped_data.get('building', {}).get('managing_agent', '—'),
            'year_built': mapped_data.get('building', {}).get('year_built'),
            'number_of_units': summary['statistics'].get('units', 0)
        },
        'units': mapped_data.get('units', []),
        'leaseholders': mapped_data.get('leaseholders', []),
        'leases': mapped_data.get('leases', []),
        'budgets': mapped_data.get('budgets', []),
        'compliance_assets': _build_compliance_from_summary(summary),
        'insurance_policies': mapped_data.get('building_insurance', []),
        'contractors': mapped_data.get('building_contractors', []),
        'major_works': mapped_data.get('major_works_projects', []),
        'documents': mapped_data.get('building_documents', []),
        'categories': summary.get('categories', {}),
        'audit_log': audit_log
    }

    # Calculate health metrics from extracted data
    data['health_metrics'] = _calculate_health_metrics(data)

    return data


def _build_compliance_from_summary(summary: Dict) -> List[Dict]:
    """
    Build compliance assets list from summary compliance section
    """
    compliance_section = summary.get('compliance_assets', {})
    details = compliance_section.get('details', [])

    # Enhance with calculated fields
    for asset in details:
        # Add is_active flag
        asset['is_active'] = True

        # Map fields to expected schema
        asset['asset_name'] = asset.get('name', 'Unknown Asset')
        asset['asset_type'] = asset.get('type', 'general')
        asset['compliance_status'] = asset.get('status', 'unknown')
        asset['last_inspection_date'] = asset.get('last_inspection')
        asset['next_due_date'] = asset.get('next_due')
        asset['compliance_category'] = asset.get('type', 'general')

    return details


def _calculate_health_metrics(data: Dict) -> Dict:
    """
    Calculate health scores from extracted data
    """
    # Compliance score
    compliance = data.get('compliance_assets', [])
    total_compliance = len(compliance)

    if total_compliance > 0:
        compliant = sum(1 for a in compliance if a.get('compliance_status') == 'compliant')
        overdue = sum(1 for a in compliance if a.get('compliance_status') == 'overdue')
        compliance_pct = (compliant / total_compliance) * 100

        if compliance_pct >= 90:
            compliance_score = 100
        elif compliance_pct >= 75:
            compliance_score = 80
        elif compliance_pct >= 50:
            compliance_score = 60
        elif compliance_pct >= 25:
            compliance_score = 40
        else:
            compliance_score = 20
    else:
        compliance_score = 0

    # Insurance score
    insurance = data.get('insurance_policies', [])
    if len(insurance) > 0:
        today = date.today()
        active = 0
        for policy in insurance:
            expiry = policy.get('expiry_date')
            if expiry:
                try:
                    if isinstance(expiry, str):
                        expiry_date = datetime.fromisoformat(expiry).date()
                    else:
                        expiry_date = expiry
                    if expiry_date > today:
                        active += 1
                except:
                    pass

        if active == len(insurance):
            insurance_score = 100
        elif active >= len(insurance) * 0.5:
            insurance_score = 50
        else:
            insurance_score = 25
    else:
        insurance_score = 0

    # Budget score
    budgets = data.get('budgets', [])
    if len(budgets) > 0:
        with_dates = sum(1 for b in budgets if b.get('year_start') and b.get('year_end'))
        if with_dates == len(budgets):
            budget_score = 100
        elif with_dates >= len(budgets) * 0.5:
            budget_score = 60
        else:
            budget_score = 30
    else:
        budget_score = 0

    # Lease score
    units = data.get('units', [])
    leases = data.get('leases', [])
    if len(units) > 0:
        lease_pct = (len(leases) / len(units)) * 100
        if lease_pct >= 90:
            lease_score = 100
        elif lease_pct >= 75:
            lease_score = 80
        elif lease_pct >= 50:
            lease_score = 60
        elif lease_pct >= 25:
            lease_score = 40
        else:
            lease_score = 20
    else:
        lease_score = 0

    # Contractor score
    contractors = data.get('contractors', [])
    if len(contractors) > 0:
        contractor_score = 100  # Simple: if contractors exist, score is good
    else:
        contractor_score = 0

    # Overall weighted score
    health_score = (
        (compliance_score * 0.40) +
        (insurance_score * 0.20) +
        (budget_score * 0.20) +
        (lease_score * 0.10) +
        (contractor_score * 0.10)
    )

    # Rating
    if health_score >= 90:
        rating = 'Excellent'
    elif health_score >= 75:
        rating = 'Good'
    elif health_score >= 50:
        rating = 'Fair'
    elif health_score >= 25:
        rating = 'Poor'
    else:
        rating = 'Critical'

    return {
        'health_score': round(health_score, 1),
        'rating': rating,
        'compliance_score': compliance_score,
        'insurance_score': insurance_score,
        'budget_score': budget_score,
        'lease_score': lease_score,
        'contractor_score': contractor_score
    }


def generate_health_check(output_dir: str, output_pdf: str = None):
    """
    Generate health check PDF from extraction data

    Args:
        output_dir: Path to BlocIQ_Output folder containing summary.json
        output_pdf: Optional path for output PDF (default: output_dir/building_health_check.pdf)
    """
    print("=" * 60)
    print("BlocIQ Building Health Check Generator")
    print("Source: Extraction Data (No Database Query)")
    print("=" * 60)

    # Load data
    print("\n📂 Loading extraction data...")
    data = load_extraction_data(output_dir)

    building_name = data['building']['name']
    print(f"✅ Building: {building_name}")
    print(f"   Units: {len(data.get('units', []))}")
    print(f"   Leaseholders: {len(data.get('leaseholders', []))}")
    print(f"   Leases: {len(data.get('leases', []))}")
    print(f"   Compliance Assets: {len(data.get('compliance_assets', []))}")
    print(f"   Budgets: {len(data.get('budgets', []))}")
    print(f"   Insurance Policies: {len(data.get('insurance_policies', []))}")

    health = data['health_metrics']
    print(f"\n📊 Health Score: {health['health_score']}/100 ({health['rating']})")
    print(f"   Compliance: {health['compliance_score']}/100")
    print(f"   Insurance: {health['insurance_score']}/100")
    print(f"   Budget: {health['budget_score']}/100")
    print(f"   Lease: {health['lease_score']}/100")
    print(f"   Contractor: {health['contractor_score']}/100")

    # Set output path
    if not output_pdf:
        output_path = Path(output_dir)
        safe_name = building_name.replace(' ', '_').replace('/', '_')
        output_pdf = output_path / f"{safe_name}_HealthCheck.pdf"

    # Generate PDF
    print(f"\n📄 Generating PDF: {output_pdf}")
    generate_health_check_v3(data, str(output_pdf))

    print(f"\n✅ Health Check PDF generated successfully!")
    print(f"   Location: {output_pdf}")
    print("=" * 60)

    return str(output_pdf)


if __name__ == "__main__":
    import sys

    if len(sys.argv) > 1:
        output_dir = sys.argv[1]
    else:
        # Default to Desktop output
        output_dir = "/Users/ellie/Desktop/BlocIQ_Output"

    try:
        generate_health_check(output_dir)
    except Exception as e:
        print(f"\n❌ Error generating health check: {e}")
        import traceback
        traceback.print_exc()
        sys.exit(1)
