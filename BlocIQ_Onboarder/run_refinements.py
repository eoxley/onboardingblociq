"""
BlocIQ Onboarder - Health Check PDF Refinements
Enhances the Building Health Check PDF with intelligent insights
"""

import json
import sys
from pathlib import Path
from datetime import datetime
from collections import defaultdict, Counter
from typing import Dict, List, Tuple

def load_summary_data():
    """Load summary.json from output directory"""
    summary_path = Path('output/summary.json')
    if not summary_path.exists():
        print("❌ summary.json not found in output/")
        return None

    with open(summary_path, 'r') as f:
        return json.load(f)

def analyze_compliance_by_category(summary: Dict) -> Dict:
    """
    Analyze compliance assets by category with intelligent grouping
    Returns categorized breakdown with scores
    """

    # Map the summary.json type names to our category names
    type_to_category = {
        'fire_safety': 'Fire Safety',
        'electrical': 'Electrical',
        'water_safety': 'Water Safety',
        'gas_safety': 'Gas Safety',
        'lift_mechanical': 'Lift & Mechanical',
        'asbestos': 'Asbestos',
        'general': 'General Building'
    }

    # Get compliance data from summary
    compliance_data = summary.get('compliance_assets', {})
    assets_list = compliance_data.get('details', [])

    categorized = defaultdict(lambda: {
        'assets': [],
        'compliant': 0,
        'overdue': 0,
        'due_soon': 0,
        'unknown': 0,
        'total': 0
    })

    # Categorize each asset
    for asset in assets_list:
        asset_type = asset.get('type', 'general')
        category_name = type_to_category.get(asset_type, 'General Building')

        cat_data = categorized[category_name]
        cat_data['assets'].append(asset)
        cat_data['total'] += 1

        # Count by status
        status = asset.get('status', 'unknown')
        if status in cat_data:
            cat_data[status] += 1
        else:
            cat_data['unknown'] += 1

    # Calculate scores for each category
    for category, data in categorized.items():
        total = data['total']
        if total == 0:
            data['score'] = 0
            continue

        # Weighted score:
        # Compliant = 100%, Due Soon = 70%, Unknown = 40%, Overdue = 0%
        score = (
            (data['compliant'] * 100) +
            (data['due_soon'] * 70) +
            (data['unknown'] * 40) +
            (data['overdue'] * 0)
        ) / total

        data['score'] = round(score, 1)
        data['percent_compliant'] = round((data['compliant'] / total) * 100, 1)
        data['percent_overdue'] = round((data['overdue'] / total) * 100, 1)

    return dict(categorized)

def identify_top_risks(categorized: Dict) -> List[Dict]:
    """
    Identify top 3 most critical risks based on:
    - Overdue compliance items
    - Critical asset types (Fire, Water, Electrical)
    - Recentness of last inspection
    """

    risks = []

    for category, data in categorized.items():
        if data['overdue'] > 0:
            # Get the most overdue asset in this category
            overdue_assets = [a for a in data['assets'] if a.get('status') == 'overdue']

            if overdue_assets:
                # Sort by how overdue they are
                for asset in overdue_assets:
                    next_due = asset.get('next_due')
                    if next_due:
                        try:
                            due_date = datetime.fromisoformat(next_due.replace('Z', '+00:00'))
                            days_overdue = (datetime.now() - due_date).days
                        except:
                            days_overdue = 0
                    else:
                        days_overdue = 999  # Unknown = assume very overdue

                    # Priority multiplier for critical categories
                    priority_multiplier = 1.0
                    if 'Fire' in category:
                        priority_multiplier = 3.0
                    elif 'Water' in category or 'Electrical' in category:
                        priority_multiplier = 2.5
                    elif 'Gas' in category or 'Lift' in category:
                        priority_multiplier = 2.0

                    risk_score = days_overdue * priority_multiplier

                    risks.append({
                        'category': category,
                        'asset_type': asset.get('type', 'Unknown'),
                        'asset_name': asset.get('name', 'Unnamed'),
                        'days_overdue': days_overdue,
                        'next_due_date': next_due,
                        'last_inspection_date': asset.get('last_inspection'),
                        'risk_score': risk_score,
                        'recommendation': generate_recommendation(category, asset, days_overdue)
                    })

    # Sort by risk score and return top 3
    risks.sort(key=lambda x: x['risk_score'], reverse=True)
    return risks[:3]

def generate_recommendation(category: str, asset: Dict, days_overdue: int) -> str:
    """Generate actionable recommendation for an overdue asset"""

    asset_type = asset.get('type', 'Asset')
    asset_name = asset.get('name', asset_type)

    if days_overdue > 180:  # 6 months
        urgency = "IMMEDIATE ACTION REQUIRED"
    elif days_overdue > 90:  # 3 months
        urgency = "URGENT"
    elif days_overdue > 30:  # 1 month
        urgency = "Action needed soon"
    else:
        urgency = "Schedule inspection"

    # Category-specific recommendations
    if 'Fire' in category:
        if 'FRA' in asset_type or 'Risk Assessment' in asset_type:
            return f"{urgency}: Book Fire Risk Assessment immediately – compliance breach since {days_overdue} days."
        elif 'door' in asset_type.lower():
            return f"{urgency}: Fire door inspection overdue – verify all compartmentation."
        else:
            return f"{urgency}: {asset_type} inspection required for fire safety compliance."

    elif 'Water' in category:
        return f"{urgency}: Legionella risk assessment overdue – schedule WHM or approved contractor."

    elif 'Electrical' in category:
        if 'EICR' in asset_type:
            return f"{urgency}: Electrical Installation Condition Report due – engage NICEIC contractor."
        else:
            return f"{urgency}: {asset_type} testing required for electrical safety."

    elif 'Gas' in category:
        return f"{urgency}: Gas safety check overdue – legal requirement for landlords."

    elif 'Lift' in category:
        return f"{urgency}: Lift inspection overdue – LOLER compliance required."

    else:
        return f"{urgency}: Schedule {asset_type} inspection with approved contractor."

def generate_timeline_data(categorized: Dict) -> List[Dict]:
    """
    Generate timeline of key upcoming inspections
    Returns list of inspection milestones
    """

    timeline = []
    today = datetime.now()

    for category, data in categorized.items():
        for asset in data['assets']:
            next_due = asset.get('next_due')
            last_inspection = asset.get('last_inspection')

            if next_due:
                try:
                    due_date = datetime.fromisoformat(next_due.replace('Z', '+00:00'))
                    days_until = (due_date - today).days

                    # Categorize urgency
                    if days_until < 0:
                        urgency = 'OVERDUE'
                        icon = '❌'
                    elif days_until <= 30:
                        urgency = 'URGENT'
                        icon = '⚠️'
                    elif days_until <= 90:
                        urgency = 'DUE SOON'
                        icon = '⏰'
                    else:
                        urgency = 'SCHEDULED'
                        icon = '✅'

                    timeline.append({
                        'category': category,
                        'asset_type': asset.get('type', 'Unknown'),
                        'asset_name': asset.get('name', 'Unnamed'),
                        'last_inspection': last_inspection,
                        'next_due': next_due,
                        'days_until': days_until,
                        'urgency': urgency,
                        'icon': icon
                    })
                except:
                    pass

    # Sort by days until due (most urgent first)
    timeline.sort(key=lambda x: x['days_until'])

    return timeline[:10]  # Top 10 upcoming

def create_enhanced_summary(summary: Dict) -> Dict:
    """
    Create enhanced summary with intelligent categorization and insights
    """

    print("\n🧠 Analyzing compliance data by category...")
    categorized = analyze_compliance_by_category(summary)

    print("🚨 Identifying top risks...")
    top_risks = identify_top_risks(categorized)

    print("📅 Generating inspection timeline...")
    timeline = generate_timeline_data(categorized)

    # Calculate overall stats
    total_assets = sum(cat['total'] for cat in categorized.values())
    total_compliant = sum(cat['compliant'] for cat in categorized.values())
    total_overdue = sum(cat['overdue'] for cat in categorized.values())
    total_unknown = sum(cat['unknown'] for cat in categorized.values())

    overall_compliance_rate = (total_compliant / total_assets * 100) if total_assets > 0 else 0

    # Overall score (weighted by category)
    category_weights = {
        'Fire Safety': 0.35,
        'Electrical': 0.20,
        'Water Safety': 0.20,
        'Gas Safety': 0.10,
        'Lift & Mechanical': 0.05,
        'Asbestos': 0.05,
        'General Building': 0.03,
        'Other': 0.02
    }

    weighted_score = 0
    for category, data in categorized.items():
        weight = category_weights.get(category, 0.02)
        weighted_score += data['score'] * weight

    enhanced = {
        'timestamp': datetime.now().isoformat(),
        'building_name': summary.get('building_name', 'Unknown'),
        'overall_score': round(weighted_score, 1),
        'total_assets': total_assets,
        'total_compliant': total_compliant,
        'total_overdue': total_overdue,
        'total_unknown': total_unknown,
        'overall_compliance_rate': round(overall_compliance_rate, 1),
        'categories': categorized,
        'top_risks': top_risks,
        'inspection_timeline': timeline,
        'score_interpretation': interpret_score(weighted_score)
    }

    return enhanced

def interpret_score(score: float) -> Dict:
    """Interpret health score and provide context"""
    if score >= 85:
        return {
            'rating': 'EXCELLENT',
            'color': '#10b981',
            'message': 'Building is in excellent health with strong compliance.',
            'icon': '🟢'
        }
    elif score >= 70:
        return {
            'rating': 'GOOD',
            'color': '#22c55e',
            'message': 'Building health is good with minor attention needed.',
            'icon': '🟡'
        }
    elif score >= 50:
        return {
            'rating': 'NEEDS ATTENTION',
            'color': '#f59e0b',
            'message': 'Several compliance items require attention.',
            'icon': '🟠'
        }
    else:
        return {
            'rating': 'CRITICAL',
            'color': '#ef4444',
            'message': 'Immediate action required on multiple compliance fronts.',
            'icon': '🔴'
        }

def main():
    """Main refinement runner"""
    print("🧬 BlocIQ Health Check PDF Refinements")
    print("=" * 60)

    # Load summary data
    print("\n📂 Loading summary data...")
    summary = load_summary_data()

    if not summary:
        print("❌ Cannot proceed without summary data.")
        return 1

    # Create enhanced summary
    enhanced = create_enhanced_summary(summary)

    # Save enhanced summary
    output_path = Path('output/enhanced_health_summary.json')
    with open(output_path, 'w') as f:
        json.dump(enhanced, f, indent=2)

    print(f"\n✅ Enhanced summary saved to: {output_path}")

    # Print summary
    print("\n" + "=" * 60)
    print("📊 ENHANCED HEALTH CHECK SUMMARY")
    print("=" * 60)
    print(f"\n🏢 Building: {enhanced['building_name']}")
    print(f"⚡ Overall Score: {enhanced['overall_score']}/100 – {enhanced['score_interpretation']['rating']} {enhanced['score_interpretation']['icon']}")
    print(f"📊 Total Assets: {enhanced['total_assets']}")
    print(f"   ✅ Compliant: {enhanced['total_compliant']}")
    print(f"   ❌ Overdue: {enhanced['total_overdue']}")
    print(f"   ❔ Unknown: {enhanced['total_unknown']}")
    print(f"📈 Compliance Rate: {enhanced['overall_compliance_rate']}%")

    print("\n🚨 TOP 3 RISKS:")
    for i, risk in enumerate(enhanced['top_risks'], 1):
        print(f"\n{i}. {risk['category']}: {risk['asset_type']}")
        print(f"   Days Overdue: {risk['days_overdue']}")
        print(f"   💡 {risk['recommendation']}")

    print("\n📊 COMPLIANCE BY CATEGORY:")
    for category, data in enhanced['categories'].items():
        if data['total'] > 0:
            print(f"\n{category}: {data['score']}/100")
            print(f"   Assets: {data['total']} | Compliant: {data['compliant']} | Overdue: {data['overdue']} | Unknown: {data['unknown']}")

    print("\n" + "=" * 60)
    print("✅ Refinements complete!")

    return 0

if __name__ == '__main__':
    sys.exit(main())
