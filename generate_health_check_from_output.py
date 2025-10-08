#!/usr/bin/env python3
"""
Generate Building Health Check PDF from existing output data
This reads the output folder and generates the health check PDF
"""

import json
import sys
from pathlib import Path

# Add BlocIQ_Onboarder to path
sys.path.insert(0, str(Path(__file__).parent / 'BlocIQ_Onboarder'))

from reporting.building_health_check import BuildingHealthCheckGenerator
from sql_parser import load_data_from_migration_sql

def load_mapped_data_from_output(output_dir):
    """
    Reconstruct mapped_data from output folder files
    Prioritizes migration.sql for complete data, falls back to summary.json
    """
    output_path = Path(output_dir)

    # Try to load from migration.sql first (most complete data)
    migration_sql = output_path / 'migration.sql'
    if migration_sql.exists():
        print("   📊 Loading data from migration.sql (complete data)...")
        try:
            mapped_data = load_data_from_migration_sql(str(migration_sql))
            
            # Enhance with summary.json metadata
            summary_file = output_path / 'summary.json'
            if summary_file.exists():
                with open(summary_file, 'r') as f:
                    summary = json.load(f)
                
                # Update building metadata if available
                if mapped_data.get('building'):
                    mapped_data['building']['units_count'] = len(mapped_data.get('units', []))
                    mapped_data['building']['leaseholders_count'] = len(mapped_data.get('leaseholders', []))
            
            print(f"   ✅ Loaded complete data from SQL")
            return mapped_data
            
        except Exception as e:
            print(f"   ⚠️  Error parsing migration.sql: {e}")
            print(f"   📊 Falling back to summary.json...")

    # Fallback: Load summary.json (minimal data)
    summary_file = output_path / 'summary.json'
    if not summary_file.exists():
        print(f"❌ No data source found in {output_dir}")
        return None

    with open(summary_file, 'r') as f:
        summary = json.load(f)

    # Reconstruct mapped_data structure from summary
    mapped_data = {
        'building': {
            'id': 'temp-building-id',
            'name': summary.get('building_name', 'Unknown Building'),
            'address': summary.get('client_folder', ''),
            'units_count': summary.get('statistics', {}).get('units', 0),
            'leaseholders_count': summary.get('statistics', {}).get('leaseholders', 0)
        },
        'units': [],
        'leaseholders': [],
        'compliance_assets': [],
        'building_contractors': [],
        'major_works_projects': [],
        'budgets': [],
        'building_documents': [],
        'contracts': [],
        'insurance_policies': [],
        'assets': [],
        'contractors': []
    }

    # Extract compliance assets from summary
    compliance_summary = summary.get('compliance_assets', {})
    if 'details' in compliance_summary:
        for asset in compliance_summary['details']:
            mapped_data['compliance_assets'].append({
                'asset_name': asset.get('name', 'Unknown Asset'),
                'asset_type': asset.get('type', 'general'),
                'compliance_status': asset.get('status', 'unknown'),
                'last_inspection_date': asset.get('last_inspection'),
                'next_due_date': asset.get('next_due'),
                'location': asset.get('location'),
                'responsible_party': asset.get('responsible_party')
            })

    print(f"   ⚠️  Using minimal data from summary.json")
    return mapped_data


def main():
    """Generate Building Health Check PDF from output folder"""

    # Check for output directory
    output_dir = Path(__file__).parent / 'output'
    if not output_dir.exists():
        print(f"❌ Output directory not found: {output_dir}")
        return 1

    print("\n🏥 Generating Building Health Check PDF from existing data...")
    print(f"📁 Output directory: {output_dir}")

    # Load mapped data from output files
    print("\n📊 Loading data from output folder...")
    mapped_data = load_mapped_data_from_output(output_dir)

    if not mapped_data:
        print("❌ Failed to load data from output folder")
        return 1

    print(f"  ✅ Loaded mapped data with {len(mapped_data)} keys")
    print(f"  📋 Data includes:")
    for key, value in mapped_data.items():
        if isinstance(value, list):
            print(f"     • {key}: {len(value)} items")
        elif isinstance(value, dict):
            print(f"     • {key}: {len(value)} fields")
        else:
            print(f"     • {key}: {value}")

    # Generate the report
    print("\n📄 Generating Building Health Check PDF...")
    generator = BuildingHealthCheckGenerator(supabase_client=None)

    try:
        report_file = generator.generate_report(
            building_id=mapped_data['building']['id'],
            output_dir=str(output_dir),
            local_data=mapped_data
        )

        if report_file:
            print(f"\n✅ SUCCESS! Building Health Check PDF created:")
            print(f"   📄 {report_file}")
            print(f"\n📊 Report includes:")
            print(f"   • Full letterhead template on all pages")
            print(f"   • Building summary and key metrics")
            print(f"   • Contractor overview with status icons")
            print(f"   • Asset register with compliance tracking")
            print(f"   • Compliance matrix by category")
            print(f"   • Auto-generated recommendations")
            return 0
        else:
            print("\n❌ Report generation returned None")
            return 1

    except Exception as e:
        print(f"\n❌ Error generating report: {e}")
        import traceback
        traceback.print_exc()
        return 1


if __name__ == '__main__':
    sys.exit(main())
