"""
Compliance Requirements - Viable Health Score (MVP)
Applicability-first approach: score only what applies to the building
"""

from datetime import datetime, date, timedelta
from typing import Dict, List, Optional, Callable
from dataclasses import dataclass


@dataclass
class BuildingAssets:
    """What's present in the building (determines applicability)"""
    # Core systems (most residential blocks)
    em_lighting: bool = False          # Emergency lighting installed
    fire_alarm: bool = False           # Fire alarm/detection system
    aov: bool = False                  # AOV/smoke control system
    fire_doors: bool = False           # Fire doors present
    lifts: int = 0                     # Number of lifts (0 = none)
    gas_plant: bool = False            # Communal gas plant/appliances
    lightning: bool = False            # Lightning protection system
    water_system: bool = True          # Water system (assume true for most)
    pre2000_common: bool = True        # Pre-2000 common parts (asbestos)

    # HRB (High-Rise Building) flag
    is_hrb: bool = False               # Is this a High-Rise Building?


@dataclass
class Requirement:
    """A compliance requirement"""
    key: str
    label: str
    applies: Callable[[BuildingAssets], bool]
    valid: Callable[[Dict], float]     # Returns 0.0, 0.5, or 1.0
    description: str = ""


def in_date(doc_date: Optional[date], months: int, grace_half: bool = False) -> float:
    """
    Check if document is in date

    Args:
        doc_date: Date of document/certificate
        months: Validity period in months
        grace_half: If True, give 0.5 points for expired ≤ 30 days

    Returns:
        1.0 if in date, 0.5 if grace period, 0.0 if expired/missing
    """
    if not doc_date:
        return 0.0

    today = date.today()
    expiry = doc_date + timedelta(days=months * 30.44)  # Average month length

    if today <= expiry:
        return 1.0

    # Grace period: expired ≤ 30 days
    if grace_half and (today - expiry).days <= 30:
        return 0.5

    return 0.0


def present(doc: Optional[any]) -> float:
    """
    Check if document is present

    Returns:
        1.0 if present, 0.0 if missing
    """
    return 1.0 if doc else 0.0


def half_if(condition: bool) -> float:
    """
    Return 0.5 if condition is true (for draft/partial compliance)

    Returns:
        0.5 if true, 0.0 if false
    """
    return 0.5 if condition else 0.0


# Core compliance requirements (non-HRB)
CORE_REQUIREMENTS = [
    Requirement(
        key='FRA',
        label='Fire Risk Assessment',
        applies=lambda a: True,  # Always applies
        valid=lambda docs: in_date(docs.get('FRA_date'), 12),
        description='Fire Risk Assessment reviewed annually'
    ),

    Requirement(
        key='EM_LIGHT',
        label='Emergency Lighting (Annual Certificate)',
        applies=lambda a: a.em_lighting,
        valid=lambda docs: in_date(docs.get('EM_LIGHT_CERT_date'), 12),
        description='BS 5266 annual test certificate'
    ),

    Requirement(
        key='FIRE_ALARM',
        label='Fire Alarm / AOV System',
        applies=lambda a: a.fire_alarm or a.aov,
        valid=lambda docs: in_date(
            docs.get('FIRE_ALARM_CERT_date') or docs.get('AOV_CERT_date'), 12
        ),
        description='BS 5839 / system-specific maintenance certificate'
    ),

    Requirement(
        key='FIRE_DOORS',
        label='Fire Door Inspection (Annual)',
        applies=lambda a: a.fire_doors,
        valid=lambda docs: in_date(docs.get('FIRE_DOOR_REPORT_date'), 12),
        description='Annual competent person inspection'
    ),

    Requirement(
        key='EICR',
        label='EICR (Common Parts)',
        applies=lambda a: True,  # Always applies
        valid=lambda docs: in_date(docs.get('EICR_date'), 60, grace_half=True),
        description='BS 7671 electrical installation certificate (5-yearly)'
    ),

    Requirement(
        key='LOLER',
        label='LOLER (Lift Thorough Examination)',
        applies=lambda a: a.lifts > 0,
        valid=lambda docs: (
            in_date(docs.get('LOLER_PASS_date'), 6) or    # Passenger lifts: 6 months
            in_date(docs.get('LOLER_GOODS_date'), 12)     # Goods lifts: 12 months
        ),
        description='PUWER/LOLER thorough examination (6-monthly passenger, 12-monthly goods)'
    ),

    Requirement(
        key='LEGIONELLA',
        label='Legionella Risk Assessment + Monitoring',
        applies=lambda a: a.water_system,
        valid=lambda docs: (
            in_date(docs.get('LEGIONELLA_RA_date'), 24) *
            (0.5 if docs.get('LEGIONELLA_MONITOR_date') else 0.0) +
            (0.5 if in_date(docs.get('LEGIONELLA_MONITOR_date'), 12) else 0.0)
        ),
        description='Risk assessment ≤ 24 months + monitoring records ≤ 12 months'
    ),

    Requirement(
        key='GAS',
        label='Gas Safety (Communal Plant)',
        applies=lambda a: a.gas_plant,
        valid=lambda docs: in_date(docs.get('GAS_SAFE_date'), 12),
        description='Annual Gas Safe certification'
    ),

    Requirement(
        key='LPS',
        label='Lightning Protection',
        applies=lambda a: a.lightning,
        valid=lambda docs: in_date(docs.get('LIGHTNING_CERT_date'), 12),
        description='Annual lightning protection test'
    ),

    Requirement(
        key='ASBESTOS',
        label='Asbestos Management',
        applies=lambda a: a.pre2000_common,
        valid=lambda docs: in_date(docs.get('ASBESTOS_REVIEW_date'), 12),
        description='Management survey + plan reviewed annually (pre-2000 buildings)'
    ),
]


# HRB (High-Rise Building) requirements
HRB_REQUIREMENTS = [
    Requirement(
        key='BSR_REG',
        label='BSR Registration',
        applies=lambda a: a.is_hrb,
        valid=lambda docs: present(docs.get('BSR_REG_doc')),
        description='Building Safety Regulator registration'
    ),

    Requirement(
        key='SCR',
        label='Safety Case Report',
        applies=lambda a: a.is_hrb,
        valid=lambda docs: (
            present(docs.get('SCR_FINAL_doc')) or
            half_if(present(docs.get('SCR_DRAFT_doc')))
        ),
        description='Safety Case Report (draft = 0.5, final = 1.0)'
    ),

    Requirement(
        key='RES',
        label='Resident Engagement Strategy',
        applies=lambda a: a.is_hrb,
        valid=lambda docs: present(docs.get('RES_POLICY_doc')),
        description='Resident Engagement Strategy in place'
    ),

    Requirement(
        key='MOR',
        label='Mandatory Occurrence Reporting',
        applies=lambda a: a.is_hrb,
        valid=lambda docs: present(docs.get('MOR_POLICY_doc')),
        description='MOR policy in place'
    ),
]


def get_all_requirements() -> List[Requirement]:
    """Get all requirements (core + HRB)"""
    return CORE_REQUIREMENTS + HRB_REQUIREMENTS


def score_compliance(
    assets: BuildingAssets,
    evidence: Dict
) -> Dict:
    """
    Calculate compliance score based on applicability

    Args:
        assets: Building assets/systems (determines what applies)
        evidence: Dictionary of evidence documents/dates

    Returns:
        Dictionary with score, breakdown, and details
    """
    all_requirements = get_all_requirements()

    # Filter to applicable requirements
    applicable = [req for req in all_requirements if req.applies(assets)]

    # Calculate points for each requirement
    breakdown = []
    total_points = 0.0

    for req in applicable:
        points = req.valid(evidence)
        total_points += points

        status = 'OK' if points >= 1.0 else ('GRACE' if points == 0.5 else 'MISSING')

        breakdown.append({
            'key': req.key,
            'label': req.label,
            'points': points,
            'status': status,
            'description': req.description
        })

    # Calculate score
    total_applicable = len(applicable)
    score = round((total_points / total_applicable) * 100, 1) if total_applicable > 0 else 0.0

    return {
        'score': score,
        'total_requirements': total_applicable,
        'points_earned': total_points,
        'breakdown': breakdown,
        'not_applicable': [
            req.label for req in all_requirements
            if not req.applies(assets)
        ]
    }


def _detect_hrb_status(building_data: Dict) -> bool:
    """
    Detect if building is a High-Rise Building (HRB) based on available data.

    HRB indicators:
    - Building Safety Case (BSC) documents
    - References to "high rise" or "HRB"
    - References to Building Safety Act 2022
    - Gateway 3 documents
    - Principal Accountable Person (PAP) references

    Args:
        building_data: Building data with documents, compliance, etc.

    Returns:
        True if building is detected as HRB, False otherwise
    """
    hrb_keywords = [
        'building safety case',
        'bsc',
        'high rise building',
        'high-rise building',
        'hrb',
        'gateway 3',
        'gateway three',
        'principal accountable person',
        'pap',
        'building safety act 2022',
        'accountable person',
        'responsible person',
        '18 metres',
        '18m',
        'seven storeys',
        '7 storeys'
    ]

    # Check building documents
    for doc in building_data.get('building_documents', []):
        # Check document category
        category = (doc.get('category') or '').lower()
        if 'building safety' in category or 'bsc' in category:
            return True

        # Check file name
        file_name = (doc.get('file_name') or '').lower()
        for keyword in hrb_keywords:
            if keyword in file_name:
                return True

        # Check document metadata if available
        metadata = doc.get('metadata', {})
        if isinstance(metadata, dict):
            metadata_text = str(metadata).lower()
            for keyword in hrb_keywords:
                if keyword in metadata_text:
                    return True

    # Check building metadata if available
    building_info = building_data.get('building', {})
    if isinstance(building_info, dict):
        # Check building type
        building_type = (building_info.get('building_type') or '').lower()
        if 'high rise' in building_type or 'hrb' in building_type:
            return True

        # Check building notes/description
        notes = (building_info.get('operational_notes') or '').lower()
        for keyword in hrb_keywords:
            if keyword in notes:
                return True

    # Check compliance assets for HRB-specific items
    for asset in building_data.get('compliance_assets', []):
        asset_name = (asset.get('asset_name') or '').lower()
        asset_type = (asset.get('asset_type') or '').lower()

        # Look for HRB-specific assets
        if any(keyword in asset_name or keyword in asset_type for keyword in hrb_keywords):
            return True

    return False


def detect_building_assets(
    building_data: Dict
) -> BuildingAssets:
    """
    Auto-detect building assets from database

    Args:
        building_data: Building data with contractors, compliance, etc.

    Returns:
        BuildingAssets object
    """
    # Count lifts
    lifts = len([
        c for c in building_data.get('building_contractors', [])
        if 'lift' in (c.get('service_type') or '').lower()
    ])

    # Detect gas
    gas_plant = any(
        'gas' in (c.get('service_type') or '').lower()
        for c in building_data.get('building_contractors', [])
    )

    # Detect fire systems
    fire_alarm = any(
        'fire alarm' in (c.get('asset_name') or '').lower()
        for c in building_data.get('compliance_assets', [])
    )

    em_lighting = any(
        'emergency light' in (c.get('asset_name') or '').lower()
        for c in building_data.get('compliance_assets', [])
    )

    fire_doors = any(
        'fire door' in (c.get('asset_name') or '').lower()
        for c in building_data.get('compliance_assets', [])
    )

    # Detect building age (for asbestos)
    # Assume pre-2000 unless we have data
    pre2000_common = True

    # Detect if HRB (High-Rise Building) based on documents
    # Look for Building Safety Case, BSC, or HRB-specific documents
    is_hrb = _detect_hrb_status(building_data)

    return BuildingAssets(
        em_lighting=em_lighting,
        fire_alarm=fire_alarm,
        aov=False,  # Hard to auto-detect
        fire_doors=fire_doors,
        lifts=lifts,
        gas_plant=gas_plant,
        lightning=False,  # Hard to auto-detect
        water_system=True,  # Assume true
        pre2000_common=pre2000_common,
        is_hrb=is_hrb
    )
