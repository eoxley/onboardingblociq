#!/usr/bin/env python3
"""
Smoke test: Regenerate PDF for a building from Supabase data.
One-shot end-to-end test using views.
"""
import os
import sys
from pathlib import Path
from datetime import datetime

# Add parent to path
sys.path.insert(0, str(Path(__file__).parent.parent.parent))

from generate_health_check_from_supabase_v3 import generate_health_check


def regenerate_pdf(building_id):
    """Regenerate PDF and print key metrics"""
    print(f"\n🔄 Regenerating PDF for building {building_id}...")

    try:
        # Generate PDF (should use views internally)
        result = generate_health_check(building_id)

        if result.get('success'):
            pdf_path = result.get('pdf_path', 'Unknown')
            metrics = result.get('metrics', {})

            print("\n✅ PDF Generated Successfully")
            print(f"   Path: {pdf_path}")
            print("\n📊 Key Metrics:")
            print(f"   Health Score: {metrics.get('health_score', 'N/A')}")
            print(f"   Compliance Score: {metrics.get('compliance_score', 'N/A')}")
            print(f"   Lease Coverage: {metrics.get('lease_coverage_pct', 'N/A')}%")
            print(f"   Leased Units: {metrics.get('leased_units', 'N/A')}")
            print(f"   Total Units: {metrics.get('total_units', 'N/A')}")
            print(f"   Compliance Items: {metrics.get('compliance_items', 'N/A')}")
            print(f"   Budget Years: {metrics.get('budget_years', 'N/A')}")

            # Check for warnings
            warnings = result.get('warnings', [])
            if warnings:
                print("\n⚠️  Warnings:")
                for warn in warnings:
                    print(f"   - {warn}")

        else:
            error = result.get('error', 'Unknown error')
            print(f"\n❌ PDF Generation Failed: {error}")
            sys.exit(1)

    except Exception as e:
        print(f"\n❌ Error generating PDF: {e}")
        import traceback
        traceback.print_exc()
        sys.exit(1)


if __name__ == '__main__':
    if len(sys.argv) < 2:
        print("Usage: python regenerate_pdf.py <building_id>")
        sys.exit(1)

    building_id = sys.argv[1]
    regenerate_pdf(building_id)
