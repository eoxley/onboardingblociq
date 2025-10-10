#!/usr/bin/env python3
"""
Generate Building Intelligence Report from output data
Uses the new V2 intelligent report generator
"""

import json
import sys
from pathlib import Path

# Add BlocIQ_Onboarder to path
sys.path.insert(0, str(Path(__file__).parent / 'BlocIQ_Onboarder'))

from reporting.building_intelligence_report import generate_building_intelligence_report
from sql_parser import load_data_from_migration_sql


def main():
    """Generate Building Intelligence Report from output folder"""
    
    # Check for output directory
    output_dir = Path(__file__).parent / 'output'
    if not output_dir.exists():
        print(f"❌ Output directory not found: {output_dir}")
        return 1
    
    print("\n🎨 Generating Building Intelligence Report V2...")
    print(f"📁 Output directory: {output_dir}")
    
    # Load data from migration.sql
    migration_sql = output_dir / 'migration.sql'
    if migration_sql.exists():
        print("\n📊 Loading data from migration.sql...")
        try:
            mapped_data = load_data_from_migration_sql(str(migration_sql))
            
            # Enhance with summary.json if available
            summary_file = output_dir / 'summary.json'
            if summary_file.exists():
                with open(summary_file, 'r') as f:
                    summary = json.load(f)
                
                if mapped_data.get('building'):
                    mapped_data['building']['units_count'] = len(mapped_data.get('units', []))
                    mapped_data['building']['leaseholders_count'] = len(mapped_data.get('leaseholders', []))
            
            print(f"   ✅ Loaded complete data from SQL")
            
        except Exception as e:
            print(f"   ❌ Error parsing migration.sql: {e}")
            return 1
    else:
        print(f"   ❌ migration.sql not found in {output_dir}")
        return 1
    
    # Display loaded data summary
    print(f"\n📋 Data Summary:")
    print(f"   • Building: {mapped_data.get('building', {}).get('name', 'Unknown')}")
    print(f"   • Units: {len(mapped_data.get('units', []))}")
    print(f"   • Leaseholders: {len(mapped_data.get('leaseholders', []))}")
    print(f"   • Compliance Assets: {len(mapped_data.get('compliance_assets', []))}")
    print(f"   • Contractors: {len(mapped_data.get('contractors', []))}")
    print(f"   • Contracts: {len(mapped_data.get('contracts', []))}")
    print(f"   • Insurance Policies: {len(mapped_data.get('insurance_policies', []))}")
    print(f"   • Budgets: {len(mapped_data.get('budgets', []))}")
    
    # Generate the report
    print(f"\n📄 Generating Building Intelligence Report...")
    
    try:
        building_id = mapped_data.get('building', {}).get('id', 'temp-building-id')
        
        report_file = generate_building_intelligence_report(
            building_id=building_id,
            output_dir=str(output_dir),
            local_data=mapped_data
        )
        
        if report_file:
            print(f"\n✅ SUCCESS! Building Intelligence Report created:")
            print(f"   📄 {report_file}")
            print(f"\n📊 Report Features:")
            print(f"   • Professional cover page with overall score")
            print(f"   • Executive summary with key metrics")
            print(f"   • Visual charts (pie & bar charts)")
            print(f"   • Intelligent category breakdown")
            print(f"   • Smart compliance aggregation (deduplicated)")
            print(f"   • Insurance & contractor overview")
            print(f"   • Auto-generated recommendations")
            print(f"   • Technical appendix")
            print(f"\n🎯 This report is ready to send to clients!")
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
