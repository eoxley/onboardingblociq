#!/usr/bin/env python3
"""
Comprehensive Compliance Asset Taxonomy
========================================
Complete UK compliance framework with 50+ asset types across 8 categories.

Based on:
- Building Safety Act 2022
- Fire Safety (England) Regulations 2022
- HHSRS (Housing Health and Safety Rating System)
- Industry best practices

Author: BlocIQ Team
Date: 2025-10-14
"""

from typing import Dict, List, Callable
from datetime import datetime, timedelta
from collections import defaultdict


class ComplianceAssetTaxonomy:
    """
    Comprehensive compliance asset registry with regulatory requirements
    """

    # ========================================================================
    # COMPLETE TAXONOMY - 50+ ASSET TYPES
    # ========================================================================

    COMPLIANCE_ASSETS = {

        # ====================================================================
        # 🔥 FIRE SAFETY (10 assets)
        # ====================================================================
        "FRA": {
            "full_name": "Fire Risk Assessment",
            "category": "Fire Safety",
            "frequency_months": 12,
            "regulatory_basis": "Regulatory Reform (Fire Safety) Order 2005",
            "required_if": lambda b: True,  # All buildings
            "priority": "critical",
            "keywords": ["FRA", "fire risk", "fire safety", "fire assessment"],
            "description": "Assessment of fire risks and mitigation measures",
        },

        "Fire Alarm": {
            "full_name": "Fire Alarm Test & Maintenance",
            "category": "Fire Safety",
            "frequency_months": 6,  # Test weekly, service 6-monthly
            "regulatory_basis": "BS 5839-1",
            "required_if": lambda b: b.get("has_fire_alarm") or b.get("num_units", 0) >= 4,
            "priority": "critical",
            "keywords": ["fire alarm", "fire detection", "smoke detector", "heat detector"],
            "description": "Fire alarm system testing and maintenance",
        },

        "Emergency Lighting": {
            "full_name": "Emergency Lighting Test",
            "category": "Fire Safety",
            "frequency_months": 12,  # Monthly flash test, annual 3HR
            "regulatory_basis": "BS 5266-1",
            "required_if": lambda b: b.get("has_lifts") or b.get("num_units", 0) >= 4,
            "priority": "high",
            "keywords": ["emergency light", "exit sign", "3HR", "emergency exit"],
            "description": "Emergency lighting functionality test",
        },

        "Fire Door": {
            "full_name": "Fire Doors Inspection",
            "category": "Fire Safety",
            "frequency_months": 12,
            "regulatory_basis": "Building Safety Act 2022",
            "required_if": lambda b: b.get("building_height_meters", 0) >= 11 or b.get("num_units", 0) > 1,
            "priority": "critical",
            "keywords": ["fire door", "FD30", "FD60", "door inspection"],
            "description": "Fire door integrity inspection",
        },

        "AOV": {
            "full_name": "AOV / Smoke Vent",
            "category": "Fire Safety",
            "frequency_months": 6,
            "regulatory_basis": "BS 9991 / BS 9999",
            "required_if": lambda b: b.get("has_smoke_shaft") or b.get("num_floors", 0) >= 3,
            "priority": "high",
            "keywords": ["AOV", "smoke vent", "automatic opening vent", "smoke shaft"],
            "description": "Automatic Opening Vent system test",
        },

        "Sprinkler System": {
            "full_name": "Sprinkler System",
            "category": "Fire Safety",
            "frequency_months": 6,
            "regulatory_basis": "BS 9251 / BS EN 12845",
            "required_if": lambda b: b.get("has_sprinklers") or b.get("building_height_meters", 0) >= 30,
            "priority": "critical",
            "keywords": ["sprinkler", "fire suppression", "deluge"],
            "description": "Sprinkler system testing and maintenance",
        },

        "Fire Extinguishers": {
            "full_name": "Fire Extinguishers",
            "category": "Fire Safety",
            "frequency_months": 12,
            "regulatory_basis": "BS 5306-3",
            "required_if": lambda b: b.get("has_communal_areas", True),
            "priority": "medium",
            "keywords": ["fire extinguisher", "fire blanket", "hose reel"],
            "description": "Annual fire extinguisher service",
        },

        "Fire Stopping": {
            "full_name": "Fire Stopping / Compartmentation",
            "category": "Fire Safety",
            "frequency_months": 36,
            "regulatory_basis": "Building Regulations Part B",
            "required_if": lambda b: b.get("year_built", 9999) >= 2000 or b.get("bsa_registration_required"),
            "priority": "high",
            "keywords": ["fire stopping", "compartmentation", "cavity barrier"],
            "description": "Fire compartmentation inspection",
        },

        "Dry Riser": {
            "full_name": "Fire Hydrants / Dry Risers",
            "category": "Fire Safety",
            "frequency_months": 12,
            "regulatory_basis": "BS 9990",
            "required_if": lambda b: b.get("building_height_meters", 0) >= 18,
            "priority": "critical",
            "keywords": ["dry riser", "wet riser", "fire hydrant", "fire main"],
            "description": "Dry/wet riser pressure test",
        },

        "Smoke Detectors": {
            "full_name": "Smoke Detectors / CO Alarms",
            "category": "Fire Safety",
            "frequency_months": 12,
            "regulatory_basis": "Smoke and Carbon Monoxide Alarm Regulations 2015",
            "required_if": lambda b: b.get("has_individual_units", True),
            "priority": "high",
            "keywords": ["smoke detector", "CO alarm", "carbon monoxide"],
            "description": "Smoke and CO alarm testing",
        },

        # ====================================================================
        # ⚡ ELECTRICAL SAFETY (5 assets)
        # ====================================================================
        "EICR": {
            "full_name": "EICR (Fixed Wiring)",
            "category": "Electrical Safety",
            "frequency_months": 60,
            "regulatory_basis": "BS 7671:2018",
            "required_if": lambda b: True,  # All buildings
            "priority": "critical",
            "keywords": ["EICR", "electrical", "wiring", "electrical certificate"],
            "description": "Electrical Installation Condition Report",
        },

        "PAT Testing": {
            "full_name": "PAT Testing",
            "category": "Electrical Safety",
            "frequency_months": 12,
            "regulatory_basis": "Electricity at Work Regulations 1989",
            "required_if": lambda b: b.get("has_landlord_equipment", True),
            "priority": "medium",
            "keywords": ["PAT", "portable appliance", "appliance testing"],
            "description": "Portable Appliance Testing",
        },

        "Lightning Protection": {
            "full_name": "Lightning Protection Test",
            "category": "Electrical Safety",
            "frequency_months": 12,
            "regulatory_basis": "BS EN 62305",
            "required_if": lambda b: b.get("building_height_meters", 0) >= 18 or b.get("has_lightning_conductor"),
            "priority": "medium",
            "keywords": ["lightning", "earthing", "surge protection"],
            "description": "Lightning protection system test",
        },

        "Emergency Generator": {
            "full_name": "Emergency Power / Backup Generator",
            "category": "Electrical Safety",
            "frequency_months": 3,
            "regulatory_basis": "BS 7671",
            "required_if": lambda b: b.get("has_generator") or b.get("has_emergency_power"),
            "priority": "high",
            "keywords": ["generator", "emergency power", "backup power"],
            "description": "Backup generator testing",
        },

        "Distribution Board": {
            "full_name": "Communal Meter / Distribution Board Inspection",
            "category": "Electrical Safety",
            "frequency_months": 12,
            "regulatory_basis": "BS 7671",
            "required_if": lambda b: b.get("has_communal_systems", True),
            "priority": "medium",
            "keywords": ["distribution board", "consumer unit", "fuse board"],
            "description": "Distribution board inspection",
        },

        # ====================================================================
        # 💧 WATER HYGIENE (5 assets)
        # ====================================================================
        "Legionella": {
            "full_name": "Legionella Risk Assessment",
            "category": "Water Hygiene",
            "frequency_months": 24,
            "regulatory_basis": "L8 ACOP - Legionnaires' disease",
            "required_if": lambda b: b.get("has_hot_water") or b.get("has_communal_heating"),
            "priority": "high",
            "keywords": ["legionella", "L8", "water hygiene"],
            "description": "Legionella risk assessment",
        },

        "Water Tank Cleaning": {
            "full_name": "Cold Water Tank Clean & Chlorination",
            "category": "Water Hygiene",
            "frequency_months": 12,
            "regulatory_basis": "Water Supply Regulations 1999",
            "required_if": lambda b: b.get("has_water_tanks"),
            "priority": "high",
            "keywords": ["water tank", "cold water tank", "chlorination"],
            "description": "Water tank cleaning and disinfection",
        },

        "Temperature Monitoring": {
            "full_name": "Temperature Monitoring",
            "category": "Water Hygiene",
            "frequency_months": 1,  # Monthly
            "regulatory_basis": "L8 ACOP",
            "required_if": lambda b: b.get("has_hot_water_system"),
            "priority": "medium",
            "keywords": ["temperature", "hot water", "cold water", "monitoring"],
            "description": "Water temperature monitoring",
        },

        "TMV Servicing": {
            "full_name": "TMV Servicing (Thermostatic Mixing Valves)",
            "category": "Water Hygiene",
            "frequency_months": 12,
            "regulatory_basis": "NHS D08",
            "required_if": lambda b: b.get("has_tmv"),
            "priority": "medium",
            "keywords": ["TMV", "thermostatic", "mixing valve"],
            "description": "Thermostatic mixing valve service",
        },

        "Shower Descaling": {
            "full_name": "Shower Head Descaling",
            "category": "Water Hygiene",
            "frequency_months": 3,
            "regulatory_basis": "L8 ACOP",
            "required_if": lambda b: b.get("has_communal_showers") or b.get("has_gym"),
            "priority": "low",
            "keywords": ["shower", "descale", "shower head"],
            "description": "Shower head cleaning and descaling",
        },

        # ====================================================================
        # 🧱 STRUCTURAL & FABRIC (7 assets)
        # ====================================================================
        "Asbestos": {
            "full_name": "Asbestos Survey / Reinspection",
            "category": "Structural & Fabric",
            "frequency_months": 36,
            "regulatory_basis": "Control of Asbestos Regulations 2012",
            "required_if": lambda b: b.get("year_built", 9999) < 2000,
            "priority": "high",
            "keywords": ["asbestos", "ACM", "asbestos survey"],
            "description": "Asbestos survey and re-inspection",
        },

        "Roof Inspection": {
            "full_name": "Roof / Gutter Inspection",
            "category": "Structural & Fabric",
            "frequency_months": 12,
            "regulatory_basis": "RICS Building Surveying",
            "required_if": lambda b: True,
            "priority": "medium",
            "keywords": ["roof", "gutter", "downpipe", "roof inspection"],
            "description": "Roof and rainwater goods inspection",
        },

        "Balcony Inspection": {
            "full_name": "Balcony / Façade Inspection",
            "category": "Structural & Fabric",
            "frequency_months": 60,
            "regulatory_basis": "Building Safety Act 2022",
            "required_if": lambda b: b.get("has_balconies") or b.get("building_height_meters", 0) >= 18,
            "priority": "high",
            "keywords": ["balcony", "balustrade", "facade", "external"],
            "description": "Balcony structural inspection",
        },

        "Cladding": {
            "full_name": "Cladding Remediation / FRAEW",
            "category": "Structural & Fabric",
            "frequency_months": 0,  # As required
            "regulatory_basis": "Building Safety Act 2022",
            "required_if": lambda b: b.get("has_combustible_cladding") or b.get("building_height_meters", 0) >= 18,
            "priority": "critical",
            "keywords": ["cladding", "ACM", "EWS1", "facade", "rainscreen"],
            "description": "External wall cladding assessment",
        },

        "Safety Case": {
            "full_name": "Safety Case Report",
            "category": "Structural & Fabric",
            "frequency_months": 12,
            "regulatory_basis": "Building Safety Act 2022",
            "required_if": lambda b: b.get("bsa_registration_required") and b.get("building_height_meters", 0) >= 18,
            "priority": "critical",
            "keywords": ["safety case", "building safety case", "BSA"],
            "description": "Building Safety Act safety case",
        },

        "Resident Engagement": {
            "full_name": "Resident Engagement Strategy",
            "category": "Structural & Fabric",
            "frequency_months": 12,
            "regulatory_basis": "Building Safety Act 2022",
            "required_if": lambda b: b.get("bsa_registration_required"),
            "priority": "medium",
            "keywords": ["resident engagement", "consultation", "BSA"],
            "description": "BSA resident engagement requirements",
        },

        "Compartmentation Survey": {
            "full_name": "Compartmentation Survey",
            "category": "Structural & Fabric",
            "frequency_months": 36,
            "regulatory_basis": "Building Regulations Part B",
            "required_if": lambda b: b.get("bsa_registration_required") or b.get("building_height_meters", 0) >= 18,
            "priority": "high",
            "keywords": ["compartmentation", "fire stopping", "cavity barrier"],
            "description": "Fire compartmentation survey",
        },

        # ====================================================================
        # 🧰 MECHANICAL & HVAC (7 assets)
        # ====================================================================
        "Lift": {
            "full_name": "Lift LOLER Inspection",
            "category": "Mechanical & HVAC",
            "frequency_months": 6,
            "regulatory_basis": "LOLER 1998",
            "required_if": lambda b: b.get("has_lifts") or b.get("num_lifts", 0) > 0,
            "priority": "critical",
            "keywords": ["lift", "LOLER", "elevator", "thorough examination"],
            "description": "Lift thorough examination (LOLER)",
        },

        "Lift Maintenance": {
            "full_name": "Lift Maintenance",
            "category": "Mechanical & HVAC",
            "frequency_months": 1,  # Monthly
            "regulatory_basis": "BS EN 81-80",
            "required_if": lambda b: b.get("has_lifts"),
            "priority": "critical",
            "keywords": ["lift maintenance", "lift service", "elevator"],
            "description": "Monthly lift maintenance",
        },

        "Pressure Systems": {
            "full_name": "Pressure Systems (PSSR)",
            "category": "Mechanical & HVAC",
            "frequency_months": 12,
            "regulatory_basis": "PSSR 2000",
            "required_if": lambda b: b.get("has_pressure_systems") or b.get("has_plant_room"),
            "priority": "high",
            "keywords": ["pressure", "PSSR", "boiler pressure", "vessel"],
            "description": "Pressure systems examination",
        },

        "Gas Safety": {
            "full_name": "Gas Safety Certificate (CP12)",
            "category": "Mechanical & HVAC",
            "frequency_months": 12,
            "regulatory_basis": "Gas Safety (Installation and Use) Regulations 1998",
            "required_if": lambda b: b.get("has_gas") or b.get("heating_type", "").lower() == "gas boiler",
            "priority": "critical",
            "keywords": ["gas safety", "CP12", "gas certificate", "boiler"],
            "description": "Annual gas safety check",
        },

        "Ventilation": {
            "full_name": "Ventilation Cleaning / Duct Hygiene",
            "category": "Mechanical & HVAC",
            "frequency_months": 12,
            "regulatory_basis": "HVCA TR19",
            "required_if": lambda b: b.get("has_mechanical_ventilation") or b.get("has_hvac"),
            "priority": "medium",
            "keywords": ["ventilation", "duct", "HVAC", "extract"],
            "description": "Ventilation system cleaning",
        },

        "HVAC": {
            "full_name": "HVAC Servicing",
            "category": "Mechanical & HVAC",
            "frequency_months": 12,
            "regulatory_basis": "F-Gas Regulations 2014",
            "required_if": lambda b: b.get("has_hvac") or b.get("has_air_conditioning"),
            "priority": "medium",
            "keywords": ["HVAC", "air conditioning", "climate control", "F-gas"],
            "description": "HVAC system service",
        },

        "Water Pump": {
            "full_name": "Water Pump / Booster Set Maintenance",
            "category": "Mechanical & HVAC",
            "frequency_months": 3,
            "regulatory_basis": "Water Supply Regulations 1999",
            "required_if": lambda b: b.get("has_water_pumps") or b.get("has_booster_set"),
            "priority": "high",
            "keywords": ["pump", "booster", "water pump", "pressure"],
            "description": "Water pump maintenance",
        },

        # ====================================================================
        # 🧯 HEALTH & SAFETY / INSURANCE (6 assets)
        # ====================================================================
        "Buildings Insurance": {
            "full_name": "Buildings Insurance Policy",
            "category": "H&S / Insurance",
            "frequency_months": 12,
            "regulatory_basis": "Landlord and Tenant Act 1985",
            "required_if": lambda b: True,
            "priority": "critical",
            "keywords": ["insurance", "buildings insurance", "property insurance"],
            "description": "Buildings insurance renewal",
        },

        "Employers Liability": {
            "full_name": "Employers' Liability Certificate",
            "category": "H&S / Insurance",
            "frequency_months": 12,
            "regulatory_basis": "Employers' Liability (Compulsory Insurance) Act 1969",
            "required_if": lambda b: b.get("has_staff") or b.get("has_contractors"),
            "priority": "high",
            "keywords": ["employers liability", "EL insurance"],
            "description": "Employers' liability insurance",
        },

        "Public Liability": {
            "full_name": "Public Liability Certificate",
            "category": "H&S / Insurance",
            "frequency_months": 12,
            "regulatory_basis": "Common Law",
            "required_if": lambda b: True,
            "priority": "high",
            "keywords": ["public liability", "PL insurance"],
            "description": "Public liability insurance",
        },

        "Health & Safety Risk": {
            "full_name": "Health & Safety Risk Assessment",
            "category": "H&S / Insurance",
            "frequency_months": 12,
            "regulatory_basis": "Management of Health and Safety at Work Regulations 1999",
            "required_if": lambda b: True,
            "priority": "medium",
            "keywords": ["risk assessment", "H&S", "health and safety"],
            "description": "General H&S risk assessment",
        },

        "DSEAR": {
            "full_name": "DSEAR / COSHH",
            "category": "H&S / Insurance",
            "frequency_months": 12,
            "regulatory_basis": "DSEAR 2002 / COSHH 2002",
            "required_if": lambda b: b.get("has_plant_room") or b.get("has_chemicals"),
            "priority": "medium",
            "keywords": ["DSEAR", "COSHH", "hazardous substances"],
            "description": "Dangerous substances assessment",
        },

        "H&S Audit": {
            "full_name": "Accident Log & H&S Audit",
            "category": "H&S / Insurance",
            "frequency_months": 12,
            "regulatory_basis": "RIDDOR 2013",
            "required_if": lambda b: True,
            "priority": "low",
            "keywords": ["accident log", "RIDDOR", "H&S audit"],
            "description": "Health & safety audit",
        },

        # ====================================================================
        # 🧹 CLEANING & ENVIRONMENTAL (4 assets)
        # ====================================================================
        "Cleaning Contract": {
            "full_name": "Cleaning Contract / Specification",
            "category": "Cleaning & Environmental",
            "frequency_months": 12,
            "regulatory_basis": "ARMA / RICS Standards",
            "required_if": lambda b: True,
            "priority": "low",
            "keywords": ["cleaning", "cleaner", "housekeeping"],
            "description": "Cleaning service contract",
        },

        "Pest Control": {
            "full_name": "Pest Control",
            "category": "Cleaning & Environmental",
            "frequency_months": 3,
            "regulatory_basis": "Prevention of Damage by Pests Act 1949",
            "required_if": lambda b: True,
            "priority": "medium",
            "keywords": ["pest", "rodent", "vermin", "pest control"],
            "description": "Pest control service",
        },

        "Waste Management": {
            "full_name": "Waste Management / Bin Store Audit",
            "category": "Cleaning & Environmental",
            "frequency_months": 12,
            "regulatory_basis": "Environmental Protection Act 1990",
            "required_if": lambda b: True,
            "priority": "low",
            "keywords": ["waste", "bin", "refuse", "recycling"],
            "description": "Waste management arrangements",
        },

        "Grounds Maintenance": {
            "full_name": "Grounds Maintenance",
            "category": "Cleaning & Environmental",
            "frequency_months": 12,
            "regulatory_basis": "ARMA Standards",
            "required_if": lambda b: b.get("has_grounds") or b.get("has_gardens"),
            "priority": "low",
            "keywords": ["grounds", "garden", "landscaping", "lawn"],
            "description": "Grounds maintenance contract",
        },

        # ====================================================================
        # 🧾 GOVERNANCE / MANAGEMENT (6 assets)
        # ====================================================================
        "Directors Meeting": {
            "full_name": "Directors' Meeting Minutes",
            "category": "Governance / Management",
            "frequency_months": 3,
            "regulatory_basis": "Companies Act 2006",
            "required_if": lambda b: b.get("is_rmc") or b.get("is_rtm"),
            "priority": "low",
            "keywords": ["directors", "meeting", "board meeting", "RMC"],
            "description": "Directors' meeting minutes",
        },

        "AGM": {
            "full_name": "AGM Minutes",
            "category": "Governance / Management",
            "frequency_months": 12,
            "regulatory_basis": "Companies Act 2006",
            "required_if": lambda b: b.get("is_rmc") or b.get("is_rtm"),
            "priority": "low",
            "keywords": ["AGM", "annual general meeting", "general meeting"],
            "description": "Annual General Meeting",
        },

        "Insurance Schedule": {
            "full_name": "Insurance Schedule",
            "category": "Governance / Management",
            "frequency_months": 12,
            "regulatory_basis": "Landlord and Tenant Act 1985",
            "required_if": lambda b: True,
            "priority": "medium",
            "keywords": ["insurance schedule", "policy schedule"],
            "description": "Insurance policy schedule",
        },

        "Budget Approval": {
            "full_name": "Budget Approval",
            "category": "Governance / Management",
            "frequency_months": 12,
            "regulatory_basis": "Commonhold and Leasehold Reform Act 2002",
            "required_if": lambda b: True,
            "priority": "medium",
            "keywords": ["budget", "service charge budget", "accounts"],
            "description": "Annual budget approval",
        },

        "EWS1": {
            "full_name": "FRAEW (EWS1) Certificate",
            "category": "Governance / Management",
            "frequency_months": 0,  # As required
            "regulatory_basis": "Building Safety Act 2022",
            "required_if": lambda b: b.get("building_height_meters", 0) >= 18 or b.get("has_cladding"),
            "priority": "high",
            "keywords": ["EWS1", "external wall", "FRAEW"],
            "description": "External Wall System certificate",
        },

        "Resident Communication": {
            "full_name": "Resident Communication Record",
            "category": "Governance / Management",
            "frequency_months": 1,  # Ongoing
            "regulatory_basis": "Building Safety Act 2022",
            "required_if": lambda b: b.get("bsa_registration_required"),
            "priority": "medium",
            "keywords": ["resident", "communication", "engagement"],
            "description": "Resident communication log",
        },
    }

    @classmethod
    def get_asset_count(cls) -> int:
        """Return total number of asset types"""
        return len(cls.COMPLIANCE_ASSETS)

    @classmethod
    def get_by_category(cls) -> Dict[str, List[str]]:
        """Group assets by category"""
        categories = defaultdict(list)
        for asset_name, asset_info in cls.COMPLIANCE_ASSETS.items():
            categories[asset_info['category']].append(asset_name)
        return dict(categories)

    @classmethod
    def get_category_counts(cls) -> Dict[str, int]:
        """Get count of assets per category"""
        by_category = cls.get_by_category()
        return {cat: len(assets) for cat, assets in by_category.items()}

    @classmethod
    def get_critical_assets(cls) -> List[str]:
        """Get all critical priority assets"""
        return [
            name for name, info in cls.COMPLIANCE_ASSETS.items()
            if info['priority'] == 'critical'
        ]

    @classmethod
    def get_required_assets(cls, building_profile: Dict) -> List[str]:
        """Get all assets required for a specific building"""
        required = []
        for asset_name, asset_info in cls.COMPLIANCE_ASSETS.items():
            if asset_info['required_if'](building_profile):
                required.append(asset_name)
        return required


# Example usage
if __name__ == "__main__":
    taxonomy = ComplianceAssetTaxonomy()

    print("="*80)
    print("COMPREHENSIVE COMPLIANCE ASSET TAXONOMY")
    print("="*80)

    print(f"\n📊 TOTAL ASSETS: {taxonomy.get_asset_count()}")

    print("\n📋 BY CATEGORY:")
    for category, count in taxonomy.get_category_counts().items():
        print(f"   {category}: {count} assets")

    print("\n🔴 CRITICAL ASSETS:")
    for asset in taxonomy.get_critical_assets():
        info = taxonomy.COMPLIANCE_ASSETS[asset]
        print(f"   - {asset}: {info['full_name']}")

    print("\n🏢 EXAMPLE: Small Building (8 units, no lifts)")
    small_building = {
        "num_units": 8,
        "has_lifts": False,
        "has_hot_water": True,
        "year_built": 1850,
        "building_height_meters": 12,
    }
    required = taxonomy.get_required_assets(small_building)
    print(f"   Required assets: {len(required)}")
    for asset in required[:10]:
        print(f"      - {asset}")

    print("\n🏢 EXAMPLE: Large BSA Building (82 units, 30m high)")
    large_building = {
        "num_units": 82,
        "has_lifts": True,
        "num_lifts": 2,
        "has_hot_water": True,
        "year_built": 2010,
        "building_height_meters": 30,
        "bsa_registration_required": True,
        "has_cladding": True,
        "has_hvac": True,
        "has_plant_room": True,
    }
    required = taxonomy.get_required_assets(large_building)
    print(f"   Required assets: {len(required)}")

    print("\n" + "="*80)
