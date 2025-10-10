#!/usr/bin/env python3
"""
Test Viable Health Score (MVP) - Required-Only Approach
"""

from datetime import date, timedelta
from compliance_requirements import (
    BuildingAssets, score_compliance, detect_building_assets
)
from generate_health_check_from_supabase_v3 import fetch_building_data_v3


def test_with_connaught_square():
    """Test scoring with actual Connaught Square data"""

    print("="*80)
    print("🏢 VIABLE HEALTH SCORE - Connaught Square")
    print("="*80)

    # Fetch actual data
    building_data = fetch_building_data_v3(building_name='Connaught Square')

    # Auto-detect assets
    assets = detect_building_assets(building_data)

    print(f"\n📊 BUILDING ASSETS (Auto-Detected):")
    print(f"   Emergency Lighting: {'Yes' if assets.em_lighting else 'No'}")
    print(f"   Fire Alarm: {'Yes' if assets.fire_alarm else 'No'}")
    print(f"   AOV System: {'Yes' if assets.aov else 'No'}")
    print(f"   Fire Doors: {'Yes' if assets.fire_doors else 'No'}")
    print(f"   Lifts: {assets.lifts}")
    print(f"   Gas Plant: {'Yes' if assets.gas_plant else 'No'}")
    print(f"   Lightning Protection: {'Yes' if assets.lightning else 'No'}")
    print(f"   Water System: {'Yes' if assets.water_system else 'No'}")
    print(f"   Pre-2000 Common Parts: {'Yes' if assets.pre2000_common else 'No'}")
    print(f"   Is HRB: {'Yes' if assets.is_hrb else 'No'}")

    # Build evidence dictionary from current data
    # (This would normally come from parsed documents)
    evidence = {}

    # Check compliance assets for dates
    for asset in building_data.get('compliance_assets', []):
        asset_name = (asset.get('asset_name') or '').lower()

        # Map to evidence keys
        if 'fra' in asset_name or 'fire risk' in asset_name:
            if asset.get('last_inspection_date'):
                evidence['FRA_date'] = asset['last_inspection_date']

        elif 'emergency light' in asset_name:
            if asset.get('last_inspection_date'):
                evidence['EM_LIGHT_CERT_date'] = asset['last_inspection_date']

        elif 'fire alarm' in asset_name:
            if asset.get('last_inspection_date'):
                evidence['FIRE_ALARM_CERT_date'] = asset['last_inspection_date']

        elif 'fire door' in asset_name:
            if asset.get('last_inspection_date'):
                evidence['FIRE_DOOR_REPORT_date'] = asset['last_inspection_date']

        elif 'eicr' in asset_name or 'electrical' in asset_name:
            if asset.get('last_inspection_date'):
                evidence['EICR_date'] = asset['last_inspection_date']

        elif 'loler' in asset_name or 'lift' in asset_name:
            if asset.get('last_inspection_date'):
                evidence['LOLER_PASS_date'] = asset['last_inspection_date']

        elif 'legionella' in asset_name or 'water' in asset_name:
            if asset.get('last_inspection_date'):
                evidence['LEGIONELLA_RA_date'] = asset['last_inspection_date']
            if asset.get('next_due_date'):
                evidence['LEGIONELLA_MONITOR_date'] = asset['last_inspection_date']

        elif 'gas' in asset_name:
            if asset.get('last_inspection_date'):
                evidence['GAS_SAFE_date'] = asset['last_inspection_date']

        elif 'lightning' in asset_name:
            if asset.get('last_inspection_date'):
                evidence['LIGHTNING_CERT_date'] = asset['last_inspection_date']

        elif 'asbestos' in asset_name:
            if asset.get('last_inspection_date'):
                evidence['ASBESTOS_REVIEW_date'] = asset['last_inspection_date']

    # Calculate score
    result = score_compliance(assets, evidence)

    print(f"\n{'='*80}")
    print(f"📈 VIABLE HEALTH SCORE")
    print(f"{'='*80}")
    print(f"\n🎯 Score: {result['score']:.1f}/100")
    print(f"✅ Requirements Met: {result['points_earned']:.1f}/{result['total_requirements']}")

    # Breakdown
    print(f"\n{'='*80}")
    print(f"📋 REQUIREMENT BREAKDOWN")
    print(f"{'='*80}")

    ok_items = []
    grace_items = []
    missing_items = []

    for item in result['breakdown']:
        if item['status'] == 'OK':
            ok_items.append(item)
        elif item['status'] == 'GRACE':
            grace_items.append(item)
        else:
            missing_items.append(item)

    if ok_items:
        print(f"\n✅ IN DATE ({len(ok_items)}):")
        for item in ok_items:
            print(f"   - {item['label']} (1.0 points)")

    if grace_items:
        print(f"\n⚠️  GRACE PERIOD ({len(grace_items)}):")
        for item in grace_items:
            print(f"   - {item['label']} (0.5 points - expired ≤ 30 days)")

    if missing_items:
        print(f"\n❌ MISSING/EXPIRED ({len(missing_items)}):")
        for item in missing_items:
            print(f"   - {item['label']} (0.0 points)")

    # Not applicable
    if result['not_applicable']:
        print(f"\n⏭️  NOT APPLICABLE ({len(result['not_applicable'])}):")
        for item in result['not_applicable']:
            print(f"   - {item}")

    # Compare to old score
    print(f"\n{'='*80}")
    print(f"📊 COMPARISON")
    print(f"{'='*80}")

    old_score = building_data['health_metrics']['health_score']
    old_compliance = building_data['health_metrics']['compliance_score']

    print(f"\nOLD APPROACH (weighted composite):")
    print(f"   Overall: {old_score:.1f}/100")
    print(f"   Compliance component: {old_compliance:.1f}%")
    print(f"   Includes: Insurance, Budgets, Leases, Contractors")

    print(f"\nNEW APPROACH (required-only):")
    print(f"   Compliance: {result['score']:.1f}/100")
    print(f"   Based on: {result['total_requirements']} applicable requirements")
    print(f"   Excludes: Budgets, Insurance, Contracts, Leases")

    print(f"\n💡 KEY DIFFERENCES:")
    print(f"   - Old: Penalizes for missing leases (not a compliance requirement)")
    print(f"   - Old: Includes insurance certificates (separate from safety compliance)")
    print(f"   - New: Scores ONLY statutory/safety compliance requirements")
    print(f"   - New: Only applies requirements relevant to this building")


if __name__ == "__main__":
    test_with_connaught_square()
