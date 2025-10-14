#!/usr/bin/env python3
"""
Compliance Cycle Evaluator
==========================
Groups documents into compliance categories, calculates next due dates,
assesses status (current/due_soon/expired/missing/not_required),
and produces a Building Health Check JSON for dashboards & alerts.

Author: SQL Generator Team
Date: 2025-10-14
"""

from datetime import datetime, timedelta
from dateutil.relativedelta import relativedelta
from collections import defaultdict
import json
from typing import Dict, List, Optional, Any
from pathlib import Path


# ============================================================================
# CANONICAL CATEGORIES WITH DEFAULTS (UK-typical)
# ============================================================================

CATEGORY_DEFAULTS = {
    "FRA": {
        "name": "Fire Risk Assessment",
        "cycle_months": 12,
        "lead_time_days": 30,
        "grace_days": 0,
        "criticality": "High"
    },
    "FIRE_DOOR": {
        "name": "Fire Door Inspection",
        "cycle_months": 12,
        "lead_time_days": 30,
        "grace_days": 0,
        "criticality": "High"
    },
    "FRAEW_EWS": {
        "name": "FRAEW / EWS1",
        "cycle_months": 36,
        "lead_time_days": 60,
        "grace_days": 0,
        "criticality": "High"
    },
    "EICR": {
        "name": "Electrical Installation Condition Report",
        "cycle_months": 60,
        "lead_time_days": 60,
        "grace_days": 0,
        "criticality": "High"
    },
    "EM_LIGHT": {
        "name": "Emergency Lighting Certificate",
        "cycle_months": 12,
        "lead_time_days": 30,
        "grace_days": 0,
        "criticality": "High"
    },
    "FIRE_ALARM": {
        "name": "Fire Alarm Service",
        "cycle_months": 6,
        "lead_time_days": 30,
        "grace_days": 0,
        "criticality": "High"
    },
    "ASBESTOS": {
        "name": "Asbestos Re-inspection",
        "cycle_months": 12,
        "lead_time_days": 30,
        "grace_days": 0,
        "criticality": "High"
    },
    "LEGIONELLA_RA": {
        "name": "Legionella Risk Assessment",
        "cycle_months": 24,
        "lead_time_days": 30,
        "grace_days": 0,
        "criticality": "Medium"
    },
    "WATER_MONITORING": {
        "name": "Water Monitoring (Flushing/Temps)",
        "cycle_months": 1,
        "lead_time_days": 7,
        "grace_days": 0,
        "criticality": "High"
    },
    "LOLER_LIFT": {
        "name": "Lift Thorough Examination (LOLER)",
        "cycle_months": 6,
        "lead_time_days": 30,
        "grace_days": 0,
        "criticality": "High"
    },
    "GAS_SAFETY": {
        "name": "Gas Safety (Communal Plant)",
        "cycle_months": 12,
        "lead_time_days": 30,
        "grace_days": 0,
        "criticality": "High"
    },
    "INSURANCE_POLICY": {
        "name": "Buildings Insurance Policy",
        "cycle_months": 12,
        "lead_time_days": 30,
        "grace_days": 0,
        "criticality": "High"
    },
    "INS_VALUATION": {
        "name": "Rebuild Valuation",
        "cycle_months": 36,
        "lead_time_days": 60,
        "grace_days": 0,
        "criticality": "Medium"
    },
    "HS_AUDIT": {
        "name": "H&S/General Safety Audit",
        "cycle_months": 12,
        "lead_time_days": 30,
        "grace_days": 0,
        "criticality": "Medium"
    }
}


# Document type to category mapping
DOCUMENT_TYPE_TO_CATEGORY = {
    # Fire Risk Assessment
    "FRA": "FRA",
    "Fire Risk Assessment": "FRA",
    "Type 1": "FRA",
    "Type 2": "FRA",
    "Type 3": "FRA",
    "Type 4": "FRA",

    # Fire Door
    "Fire Door": "FIRE_DOOR",
    "Fire Door Inspection": "FIRE_DOOR",
    "Fire Door Survey": "FIRE_DOOR",

    # FRAEW/EWS
    "FRAEW": "FRAEW_EWS",
    "EWS1": "FRAEW_EWS",
    "EWS": "FRAEW_EWS",
    "External Wall Assessment": "FRAEW_EWS",

    # EICR
    "EICR": "EICR",
    "Electrical": "EICR",
    "Electrical Test": "EICR",

    # Emergency Lighting
    "Emergency Lighting": "EM_LIGHT",
    "EM Light": "EM_LIGHT",
    "Emergency Light": "EM_LIGHT",

    # Fire Alarm
    "Fire Alarm": "FIRE_ALARM",
    "Fire Alarm Service": "FIRE_ALARM",
    "Fire Detection": "FIRE_ALARM",

    # Asbestos
    "Asbestos": "ASBESTOS",
    "Asbestos Survey": "ASBESTOS",
    "Asbestos Register": "ASBESTOS",

    # Legionella
    "Legionella": "LEGIONELLA_RA",
    "Legionella Risk Assessment": "LEGIONELLA_RA",
    "Water Risk Assessment": "LEGIONELLA_RA",

    # Water Monitoring
    "Water Monitoring": "WATER_MONITORING",
    "Water Testing": "WATER_MONITORING",
    "Water Hygiene": "WATER_MONITORING",

    # LOLER
    "LOLER": "LOLER_LIFT",
    "Lift": "LOLER_LIFT",
    "Lift Inspection": "LOLER_LIFT",

    # Gas Safety
    "Gas Safety": "GAS_SAFETY",
    "Gas": "GAS_SAFETY",
    "Gas Certificate": "GAS_SAFETY",

    # Insurance
    "Insurance": "INSURANCE_POLICY",
    "Insurance Policy": "INSURANCE_POLICY",
    "Buildings Insurance": "INSURANCE_POLICY",

    # Insurance Valuation
    "Valuation": "INS_VALUATION",
    "Rebuild Valuation": "INS_VALUATION",
    "Insurance Valuation": "INS_VALUATION",

    # H&S Audit
    "H&S": "HS_AUDIT",
    "Health and Safety": "HS_AUDIT",
    "Safety Audit": "HS_AUDIT"
}


# ============================================================================
# HELPER FUNCTIONS
# ============================================================================

def add_months(date_obj: datetime, months: int) -> datetime:
    """Add months to a date using relativedelta."""
    if isinstance(date_obj, str):
        date_obj = datetime.fromisoformat(date_obj.replace('Z', '+00:00'))
    return date_obj + relativedelta(months=months)


def parse_date(date_input: Any) -> Optional[datetime]:
    """Parse various date formats into datetime object."""
    if not date_input:
        return None

    if isinstance(date_input, datetime):
        return date_input

    if isinstance(date_input, str):
        # Try ISO format first
        try:
            return datetime.fromisoformat(date_input.replace('Z', '+00:00'))
        except:
            pass

        # Try common UK formats
        formats = [
            '%Y-%m-%d',
            '%d/%m/%Y',
            '%d-%m-%Y',
            '%d %B %Y',
            '%d %b %Y',
            '%B %d, %Y'
        ]

        for fmt in formats:
            try:
                return datetime.strptime(date_input, fmt)
            except:
                continue

    return None


def map_to_category(document_type: str) -> Optional[str]:
    """Map document type to canonical category key."""
    if not document_type:
        return None

    # Direct lookup
    if document_type in DOCUMENT_TYPE_TO_CATEGORY:
        return DOCUMENT_TYPE_TO_CATEGORY[document_type]

    # Case-insensitive partial match
    doc_lower = document_type.lower()
    for key, category in DOCUMENT_TYPE_TO_CATEGORY.items():
        if key.lower() in doc_lower or doc_lower in key.lower():
            return category

    return None


def apply_overrides(base_config: Dict, overrides: Dict) -> Dict:
    """Apply site-specific overrides to base category configuration."""
    config = base_config.copy()
    config.update(overrides)
    return config


def confidence_score(doc: Dict) -> float:
    """
    Calculate confidence score based on available data.

    Scoring:
    +0.4 valid inspection_date
    +0.3 explicit next_due_date or unambiguous cycle
    +0.2 recognised assessor/provider
    +0.1 consistent category keywords in text
    """
    score = 0.0

    # Valid inspection date
    if doc.get('inspection_date'):
        score += 0.4

    # Explicit next due or clear cycle
    if doc.get('next_due_date'):
        score += 0.3
    elif doc.get('expiry_date'):
        score += 0.3

    # Recognized assessor/provider
    if doc.get('contractor') or doc.get('assessor') or doc.get('prepared_by'):
        score += 0.2

    # Category keywords in text (check metadata)
    metadata = doc.get('extracted_metadata', {})
    if metadata and len(metadata) > 2:  # Has substantial metadata
        score += 0.1

    return min(score, 1.0)


def determine_applicable_categories(building_profile: Dict, detected_categories: set) -> set:
    """
    Determine which categories apply to this building.

    Rules:
    - Remove LOLER_LIFT if has_lifts=false
    - Add FRAEW_EWS if over_11m=true or FRA mentions external walls
    - Remove GAS_SAFETY if has_gas=false
    - Allow agency/site rules to add/remove categories
    """
    applicable = set(CATEGORY_DEFAULTS.keys())

    # Remove based on building profile
    if not building_profile.get('has_lifts', True):
        applicable.discard('LOLER_LIFT')

    if not building_profile.get('has_gas', True):
        applicable.discard('GAS_SAFETY')

    # Add FRAEW_EWS if building is over 11m
    if building_profile.get('over_11m', False):
        applicable.add('FRAEW_EWS')

    # Apply explicit inclusions/exclusions from profile
    inclusions = building_profile.get('include_categories', [])
    exclusions = building_profile.get('exclude_categories', [])

    for cat in inclusions:
        applicable.add(cat)

    for cat in exclusions:
        applicable.discard(cat)

    return applicable


def overall_health(results: List[Dict]) -> float:
    """
    Calculate portfolio health score (0-100).

    Scoring:
    current = +1.0
    due_soon = +0.5
    expired = 0
    missing = 0
    weight by criticality: High×1.0, Medium×0.7
    """
    total_weight = 0.0
    total_score = 0.0

    for item in results:
        if not item.get('applicable', True):
            continue

        criticality_weight = 1.0 if item.get('criticality') == 'High' else 0.7
        total_weight += criticality_weight

        status = item.get('status')
        if status == 'current':
            total_score += 1.0 * criticality_weight
        elif status == 'due_soon':
            total_score += 0.5 * criticality_weight
        # expired and missing = 0

    if total_weight == 0:
        return 100.0

    return round((total_score / total_weight) * 100, 1)


def missing_item(category: str, config: Dict) -> Dict:
    """Create a missing item result."""
    return {
        "category": category,
        "status": "missing",
        "inspection_date": None,
        "next_due_date": None,
        "days_to_due": None,
        "criticality": config['criticality'],
        "applicable": True,
        "source_file": None,
        "confidence": 0.0,
        "notes": ["no_document_found"]
    }


def not_required_item(category: str, config: Dict, reason: str = "building_profile") -> Dict:
    """Create a not-required item result."""
    return {
        "category": category,
        "status": "not_required",
        "inspection_date": None,
        "next_due_date": None,
        "days_to_due": None,
        "criticality": config['criticality'],
        "applicable": False,
        "source_file": None,
        "confidence": 1.0,
        "notes": [f"not_required_{reason}"]
    }


# ============================================================================
# MAIN EVALUATION FUNCTION
# ============================================================================

def evaluate_compliance_cycles(
    docs: List[Dict],
    building_profile: Dict,
    today: Optional[datetime] = None
) -> Dict:
    """
    Main compliance cycle evaluation function.

    Args:
        docs: List of document dictionaries with metadata
        building_profile: Building characteristics and overrides
        today: Reference date (defaults to now)

    Returns:
        Building Health Check JSON with compliance summary
    """
    if today is None:
        today = datetime.now()

    # Load config and overrides
    config = CATEGORY_DEFAULTS.copy()
    site_overrides = building_profile.get('site_overrides', {})

    # 1) Map docs to canonical categories
    buckets = defaultdict(list)
    for doc in docs:
        doc_type = doc.get('document_type') or doc.get('classification')
        if not doc_type:
            continue

        category = map_to_category(doc_type)
        if category:
            buckets[category].append(doc)

    # 2) Determine applicable categories
    applicable = determine_applicable_categories(building_profile, set(buckets.keys()))

    # 3) Evaluate each category
    results = []

    for cat in applicable:
        cat_cfg = apply_overrides(config[cat], site_overrides.get(cat, {}))
        items = buckets.get(cat, [])

        if not items:
            results.append(missing_item(cat, cat_cfg))
            continue

        # Get most recent document
        def get_sort_date(doc):
            date = parse_date(doc.get('inspection_date'))
            if not date:
                date = parse_date(doc.get('file_modified'))
            return date or datetime.min

        items_sorted = sorted(items, key=get_sort_date, reverse=True)
        current = items_sorted[0]

        # Parse dates
        base_date = parse_date(current.get('inspection_date'))
        if not base_date:
            base_date = parse_date(current.get('file_modified'))

        explicit_next = parse_date(current.get('next_due_date')) or parse_date(current.get('expiry_date'))

        notes = []

        # Calculate next due
        if explicit_next:
            next_due = explicit_next
            notes.append("explicit_next_due_detected")
        elif base_date:
            cycle_months = cat_cfg['cycle_months']
            next_due = add_months(base_date, cycle_months)
            notes.append("default_cycle_applied")

            if cat in site_overrides:
                notes.append("site_override_cycle")
        else:
            # No dates available
            notes.append("incomplete_date")
            results.append({
                "category": cat,
                "status": "missing",
                "inspection_date": None,
                "next_due_date": None,
                "days_to_due": None,
                "criticality": cat_cfg['criticality'],
                "applicable": True,
                "source_file": current.get('file_name') or current.get('file_path'),
                "confidence": confidence_score(current),
                "notes": notes
            })
            continue

        # Calculate days to due
        days_to_due = (next_due.date() - today.date()).days

        # Determine status with grace period and lead time
        grace_days = cat_cfg['grace_days']
        lead_time_days = cat_cfg['lead_time_days']

        if days_to_due < -grace_days:
            status = "expired"
        elif days_to_due <= lead_time_days:
            status = "due_soon"
        else:
            status = "current"

        # Build result
        conf = confidence_score(current)

        results.append({
            "category": cat,
            "status": status,
            "inspection_date": base_date.strftime('%Y-%m-%d') if base_date else None,
            "next_due_date": next_due.strftime('%Y-%m-%d') if next_due else None,
            "days_to_due": days_to_due,
            "criticality": cat_cfg['criticality'],
            "applicable": True,
            "source_file": current.get('file_name') or current.get('file_path'),
            "confidence": conf,
            "notes": notes
        })

    # 4) Mark not-required categories explicitly
    all_categories = set(config.keys())
    evaluated_categories = {r['category'] for r in results}

    for cat in all_categories - evaluated_categories:
        results.append(not_required_item(cat, config[cat]))

    # 5) Calculate health summary
    health_summary = {
        "current": sum(1 for r in results if r['status'] == 'current'),
        "due_soon": sum(1 for r in results if r['status'] == 'due_soon'),
        "expired": sum(1 for r in results if r['status'] == 'expired'),
        "missing": sum(1 for r in results if r['status'] == 'missing')
    }

    portfolio_score = overall_health(results)

    # 6) Build final output
    return {
        "generated_at": today.strftime('%Y-%m-%d'),
        "health": health_summary,
        "portfolio_score": portfolio_score,
        "items": sorted(results, key=lambda x: (
            0 if x['status'] == 'expired' else 1 if x['status'] == 'due_soon' else 2 if x['status'] == 'current' else 3,
            x['category']
        ))
    }


# ============================================================================
# CLI & TESTING
# ============================================================================

if __name__ == "__main__":
    # Sample test data
    sample_docs = [
        {
            "document_type": "FRA",
            "inspection_date": "2025-03-04",
            "next_due_date": "2026-03-04",
            "file_path": "FRA_2025.pdf",
            "extracted_metadata": {"risk_rating": "Low", "assessor": "TriFire Safety Ltd"}
        },
        {
            "document_type": "EICR",
            "inspection_date": "2022-06-22",
            "next_due_date": "2027-06-22",
            "file_path": "EICR_2022.pdf",
            "extracted_metadata": {"result": "Satisfactory"}
        },
        {
            "document_type": "LOLER",
            "inspection_date": "2025-07-15",
            "file_path": "LOLER_2025.pdf",
            "extracted_metadata": {"contractor": "Ardent Lift Consultancy"}
        },
        {
            "document_type": "Fire Alarm",
            "inspection_date": "2025-09-10",
            "file_path": "FireAlarm_Sept2025.pdf",
            "extracted_metadata": {"test_result": "Pass"}
        }
    ]

    sample_building_profile = {
        "has_lifts": True,
        "over_11m": True,
        "has_gas": False,
        "site_overrides": {
            "FIRE_ALARM": {"cycle_months": 3}  # Quarterly servicing
        }
    }

    # Run evaluation
    result = evaluate_compliance_cycles(sample_docs, sample_building_profile)

    # Pretty print
    print("\n" + "="*60)
    print("BUILDING HEALTH CHECK")
    print("="*60)
    print(f"\nGenerated: {result['generated_at']}")
    print(f"Portfolio Score: {result['portfolio_score']}%")
    print(f"\nHealth Summary:")
    print(f"  Current: {result['health']['current']}")
    print(f"  Due Soon: {result['health']['due_soon']}")
    print(f"  Expired: {result['health']['expired']}")
    print(f"  Missing: {result['health']['missing']}")

    print(f"\nCompliance Items:")
    print("-" * 60)

    for item in result['items']:
        if not item['applicable']:
            continue

        status_emoji = {
            'current': '✅',
            'due_soon': '⚠️',
            'expired': '❌',
            'missing': '❓'
        }.get(item['status'], '·')

        print(f"\n{status_emoji} {item['category']} ({item['criticality']})")
        print(f"   Status: {item['status']}")
        if item['inspection_date']:
            print(f"   Last Inspection: {item['inspection_date']}")
        if item['next_due_date']:
            print(f"   Next Due: {item['next_due_date']} ({item['days_to_due']} days)")
        if item['source_file']:
            print(f"   Source: {item['source_file']}")
        print(f"   Confidence: {item['confidence']:.1f}")
        if item['notes']:
            print(f"   Notes: {', '.join(item['notes'])}")

    # Save JSON
    output_path = Path(__file__).parent / "output" / "building_health_check.json"
    output_path.parent.mkdir(exist_ok=True)

    with open(output_path, 'w') as f:
        json.dump(result, f, indent=2)

    print(f"\n\n✅ Building Health Check saved to: {output_path}")
    print("="*60 + "\n")
