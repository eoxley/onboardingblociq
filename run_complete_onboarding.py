#!/usr/bin/env python3
"""
Complete BlocIQ Onboarding Workflow
====================================
1. Runs onboarder to extract all data
2. Generates SQL migration for Supabase
3. Generates comprehensive PDF report
4. Saves both outputs

This ensures every onboarding run produces:
- SQL for database insertion
- Client-ready PDF report
"""

import sys
import os
import json
import subprocess
from pathlib import Path
from datetime import datetime

# Add BlocIQ_Onboarder to path
sys.path.insert(0, os.path.join(os.path.dirname(__file__), 'BlocIQ_Onboarder'))

def run_complete_onboarding(building_folder: str):
    """
    Complete onboarding workflow: Extract → SQL → PDF
    
    Args:
        building_folder: Path to building documents folder
    """
    
    print("\n" + "="*80)
    print("🚀 COMPLETE BLOCIQ ONBOARDING WORKFLOW")
    print("="*80)
    print(f"Building Folder: {building_folder}")
    print(f"Started: {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}")
    print("="*80 + "\n")
    
    building_path = Path(building_folder)
    if not building_path.exists():
        print(f"❌ Error: Folder not found: {building_folder}")
        return False
    
    # Extract building name
    building_name = building_path.name.replace('219.01 ', '').replace('_', ' ')
    safe_name = building_name.replace(' ', '_').lower()
    
    output_dir = Path("output")
    output_dir.mkdir(exist_ok=True)
    
    # File paths
    json_file = output_dir / f"{safe_name}_production_final.json"
    sql_file = output_dir / f"{safe_name}_complete.sql"
    pdf_file = output_dir / f"{safe_name.title().replace('_', ' ')}_COMPLETE_REPORT.pdf"
    
    print("📁 Output files:")
    print(f"   JSON: {json_file}")
    print(f"   SQL:  {sql_file}")
    print(f"   PDF:  {pdf_file}\n")
    
    # ========================================================================
    # STEP 1: Run BlocIQ Onboarder (Extract Data)
    # ========================================================================
    print("="*80)
    print("📥 STEP 1: EXTRACTING DATA (BlocIQ Onboarder)")
    print("="*80)
    
    try:
        # Run the onboarder
        result = subprocess.run(
            ["python3", "BlocIQ_Onboarder/main.py", building_folder],
            capture_output=True,
            text=True,
            timeout=300  # 5 minute timeout
        )
        
        if result.returncode != 0:
            print(f"❌ Onboarder failed: {result.stderr}")
            return False
        
        print("✅ Data extraction complete!")
        
        # Check if JSON was created
        if not json_file.exists():
            print(f"❌ JSON file not found: {json_file}")
            return False
            
    except subprocess.TimeoutExpired:
        print("❌ Onboarder timed out (5 minutes)")
        return False
    except Exception as e:
        print(f"❌ Onboarder error: {e}")
        return False
    
    # ========================================================================
    # STEP 2: Generate SQL Migration
    # ========================================================================
    print("\n" + "="*80)
    print("💾 STEP 2: GENERATING SQL MIGRATION")
    print("="*80)
    
    try:
        result = subprocess.run(
            ["python3", "sql_generator_v2.py", str(json_file), "-o", str(sql_file)],
            capture_output=True,
            text=True,
            timeout=60
        )
        
        if result.returncode != 0:
            print(f"❌ SQL generation failed: {result.stderr}")
            return False
        
        print(result.stdout)
        print("✅ SQL migration generated!")
        
    except Exception as e:
        print(f"❌ SQL generation error: {e}")
        return False
    
    # ========================================================================
    # STEP 3: Generate PDF Report
    # ========================================================================
    print("\n" + "="*80)
    print("📄 STEP 3: GENERATING COMPREHENSIVE PDF REPORT")
    print("="*80)
    
    try:
        result = subprocess.run(
            ["python3", "generate_ultimate_report.py", str(json_file), "-o", str(pdf_file)],
            capture_output=True,
            text=True,
            timeout=60
        )
        
        if result.returncode != 0:
            print(f"❌ PDF generation failed: {result.stderr}")
            return False
        
        print(result.stdout)
        print("✅ PDF report generated!")
        
    except Exception as e:
        print(f"❌ PDF generation error: {e}")
        return False
    
    # ========================================================================
    # STEP 4: Summary
    # ========================================================================
    print("\n" + "="*80)
    print("🎉 ONBOARDING COMPLETE!")
    print("="*80)
    
    # Load JSON to get stats
    try:
        with open(json_file, 'r') as f:
            data = json.load(f)
        
        summary = data.get('summary', {})
        
        print(f"\n📊 Extracted Data:")
        print(f"   • Building: {data.get('building_name', 'Unknown')}")
        print(f"   • Units: {summary.get('total_units', 0)}")
        print(f"   • Leaseholders: {summary.get('total_leaseholders', 0)}")
        print(f"   • Compliance Assets: {summary.get('total_compliance_assets', 0)}")
        print(f"   • Maintenance Contracts: {summary.get('total_contracts', 0)}")
        print(f"   • Budget Line Items: {summary.get('total_budget_line_items', 0)}")
        print(f"   • Insurance Policies: {len(data.get('insurance_policies', []))}")
        print(f"   • Leases: {len(data.get('leases', []))}")
        print(f"   • Contractors: {len(data.get('contractors', []))}")
        
        # Check for contractor names
        cleaning = data.get('cleaning_contractor', 'Not detected')
        lift = data.get('lift_contractor', 'Not detected')
        print(f"\n🔨 Key Contractors:")
        print(f"   • Cleaning: {cleaning}")
        print(f"   • Lift: {lift}")
        
    except Exception as e:
        print(f"⚠️  Could not load summary: {e}")
    
    print(f"\n✅ Files Created:")
    print(f"   📊 JSON: {json_file} ({json_file.stat().st_size // 1024} KB)")
    print(f"   💾 SQL:  {sql_file} ({sql_file.stat().st_size // 1024} KB)")
    print(f"   📄 PDF:  {pdf_file} ({pdf_file.stat().st_size // 1024} KB)")
    
    print(f"\n🎯 Next Steps:")
    print(f"   1. Review PDF report: open {pdf_file}")
    print(f"   2. Apply SQL to Supabase")
    print(f"   3. Deliver PDF to client")
    
    print("\n" + "="*80)
    print(f"Completed: {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}")
    print("="*80 + "\n")
    
    # Auto-open PDF
    try:
        subprocess.run(["open", str(pdf_file)])
    except:
        pass
    
    return True


if __name__ == '__main__':
    if len(sys.argv) != 2:
        print("Usage: python3 run_complete_onboarding.py <building_folder>")
        print("\nExample:")
        print('  python3 run_complete_onboarding.py "/Users/ellie/Downloads/219.01 CONNAUGHT SQUARE"')
        sys.exit(1)
    
    building_folder = sys.argv[1]
    success = run_complete_onboarding(building_folder)
    
    sys.exit(0 if success else 1)

