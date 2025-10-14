#!/usr/bin/env python3
"""
Adaptive Contract & Compliance Detector
========================================
Self-learning system that captures NEW contract and compliance types
without requiring hardcoded additions.

APPROACH:
1. Use folder/filename patterns as hints
2. Extract keywords from document content
3. Apply fuzzy matching to known categories
4. Auto-create new categories for unknown types
5. Flag for human review/validation

Author: BlocIQ Team
Date: 2025-10-14
"""

import re
from pathlib import Path
from typing import Dict, List, Optional, Tuple
from collections import defaultdict
from datetime import datetime
import json


class AdaptiveDetector:
    """Detects and categorizes contracts/compliance assets adaptively"""

    # COMPREHENSIVE KNOWN LISTS (user-provided reference)
    KNOWN_CONTRACTS = {
        # Building Services
        "Lift Maintenance": ["lift", "elevator", "loler", "passenger lift", "goods lift"],
        "Escalator Maintenance": ["escalator", "moving stairs"],
        "Door Entry System": ["door entry", "intercom", "access control", "fob system", "entry phone"],
        "Automatic Doors": ["automatic door", "auto door", "sliding door"],
        "Gates & Barriers": ["gate", "barrier", "bollard", "vehicle access"],

        # Fire & Safety
        "Fire Alarm": ["fire alarm", "fire detection", "smoke detector", "heat detector", "fire panel"],
        "Fire Equipment": ["fire extinguisher", "fire blanket", "hose reel", "fire fighting"],
        "Fire Door Maintenance": ["fire door", "FD30", "FD60", "door inspection"],
        "Emergency Lighting": ["emergency light", "exit sign", "emergency exit", "3HR test"],
        "AOV System": ["AOV", "smoke vent", "automatic opening vent", "smoke shaft"],
        "Dry Riser": ["dry riser", "wet riser", "fire riser"],
        "Sprinkler System": ["sprinkler", "fire suppression", "deluge system"],
        "Fire Curtain": ["fire curtain", "smoke curtain"],
        "Fire Damper": ["fire damper", "smoke damper"],

        # M&E Services
        "Boiler Maintenance": ["boiler", "heating", "warmth", "gas boiler", "oil boiler"],
        "HVAC": ["HVAC", "air conditioning", "ventilation", "climate control"],
        "BMS": ["BMS", "building management system", "controls"],
        "Electrical Maintenance": ["electrical", "electrics", "wiring", "distribution board"],
        "Generator": ["generator", "emergency power", "backup power", "standby power"],
        "UPS": ["UPS", "uninterruptible power"],
        "Lightning Protection": ["lightning", "earthing", "surge protection"],

        # Water Services
        "Water Hygiene": ["water hygiene", "legionella", "TMV", "temperature monitoring"],
        "Pump Maintenance": ["pump", "water pump", "booster pump", "pressure pump"],
        "Water Tank Cleaning": ["water tank", "cold water tank", "storage tank"],
        "Irrigation": ["irrigation", "watering system", "sprinkler system"],

        # Cleaning & Grounds
        "Cleaning": ["cleaning", "cleaner", "housekeeping", "janitorial"],
        "Window Cleaning": ["window clean", "glass clean", "exterior clean"],
        "Carpet Cleaning": ["carpet", "upholstery", "fabric clean"],
        "Gardening": ["garden", "landscaping", "grounds", "tree", "hedge", "lawn"],
        "Snow Clearance": ["snow", "ice", "gritting", "winter"],

        # Waste & Drainage
        "Waste Collection": ["waste", "refuse", "bin", "rubbish", "recycling"],
        "Grease Trap": ["grease trap", "fat trap"],
        "Drainage": ["drain", "gutter", "downpipe", "sewer", "gulley"],

        # Pest & Vermin
        "Pest Control": ["pest", "rodent", "vermin", "mouse", "rat", "insect"],
        "Bird Proofing": ["bird", "pigeon", "netting", "spikes"],

        # Security & Monitoring
        "CCTV": ["CCTV", "camera", "surveillance", "security camera"],
        "Security Patrols": ["security", "patrol", "guard", "concierge"],
        "Alarm Monitoring": ["alarm", "intruder", "burglar alarm"],

        # Specialist Areas
        "Swimming Pool": ["pool", "swimming", "chlorine", "filtration"],
        "Gym Equipment": ["gym", "fitness", "treadmill", "weights"],
        "Sauna/Steam": ["sauna", "steam room", "spa"],
        "Car Park Maintenance": ["car park", "parking", "vehicle"],
        "EV Charging": ["EV", "electric vehicle", "charging point"],

        # Professional Services
        "Legal Services": ["legal", "solicitor", "lawyer"],
        "Insurance Broker": ["insurance broker", "insurance advisor"],
        "Health & Safety Consultant": ["H&S", "health and safety"],
        "Fire Safety Consultant": ["fire safety", "fire engineer"],
        "Accountancy": ["accountant", "accounting", "bookkeeping"],

        # Utilities
        "Electricity": ["electric", "electricity", "power supply"],
        "Gas": ["gas", "gas supply"],
        "Water": ["water supply", "mains water"],
        "Broadband": ["broadband", "internet", "wifi"],
        "Phone Lines": ["phone", "telephone", "landline"],

        # Other
        "Staff Payroll": ["payroll", "staff", "employees"],
        "General Maintenance": ["maintenance", "handyman", "repairs"],
    }

    KNOWN_COMPLIANCE = {
        # Fire Safety
        "FRA": ["FRA", "fire risk assessment", "fire safety", "fire risk"],
        "Fire Alarm Certificate": ["fire alarm", "fire detection certificate"],
        "Fire Door Inspection": ["fire door", "FD30", "FD60"],
        "Emergency Lighting Test": ["emergency lighting", "emergency light"],
        "Fire Equipment Service": ["fire extinguisher", "fire equipment"],
        "Fire Strategy": ["fire strategy", "fire engineering"],
        "AOV Service": ["AOV", "smoke vent"],
        "Dry Riser Test": ["dry riser", "wet riser"],
        "Sprinkler Test": ["sprinkler test", "sprinkler certificate"],

        # Electrical
        "EICR": ["EICR", "electrical certificate", "electrical inspection"],
        "PAT Testing": ["PAT", "portable appliance"],
        "Lightning Protection Test": ["lightning protection", "earthing test"],
        "Emergency Lighting 3HR": ["3HR", "emergency lighting duration"],

        # Water Safety
        "Legionella Risk Assessment": ["legionella", "L8", "water hygiene"],
        "Water Tank Inspection": ["water tank", "cold water storage"],
        "TMV Service": ["TMV", "thermostatic mixing valve"],

        # Gas Safety
        "Gas Safety Certificate": ["gas safety", "CP12", "gas certificate"],
        "Boiler Service": ["boiler service", "boiler inspection"],

        # Lift & Equipment
        "LOLER": ["LOLER", "lift inspection", "thorough examination"],
        "Lift Insurance Inspection": ["lift insurance", "lift engineer"],

        # Environmental
        "Asbestos Survey": ["asbestos", "ACM", "asbestos survey"],
        "Asbestos Register": ["asbestos register", "asbestos management"],
        "Legionella Risk Assessment": ["legionella", "L8"],
        "EPC": ["EPC", "energy performance certificate"],
        "Air Quality": ["air quality", "ventilation test"],

        # Building Safety Act
        "BSA Registration": ["BSA", "building safety act", "accountable person"],
        "Building Safety Case": ["safety case", "building safety case"],
        "Fire & Emergency File": ["fire emergency file", "FEF"],
        "Resident Engagement": ["resident engagement", "resident consultation"],

        # Cladding & External
        "EWS1": ["EWS1", "external wall", "cladding"],
        "Cladding Survey": ["cladding", "facade", "rainscreen"],
        "Balcony Inspection": ["balcony", "balustrade"],
        "Roof Inspection": ["roof inspection", "roof survey"],

        # Other
        "Insurance Valuation": ["insurance valuation", "reinstatement cost"],
        "Structural Survey": ["structural survey", "structural inspection"],
        "Drone Survey": ["drone", "aerial survey"],
        "Stock Condition Survey": ["stock condition", "building condition"],
    }

    def __init__(self):
        """Initialize detector with known categories"""
        self.known_contracts = self.KNOWN_CONTRACTS
        self.known_compliance = self.KNOWN_COMPLIANCE

        # Track newly discovered types
        self.new_contract_types = {}
        self.new_compliance_types = {}

        # Track uncertainty for human review
        self.uncertain_items = []

    def detect_contract_type(self, folder_name: str, file_names: List[str], confidence_threshold: float = 0.6) -> Dict:
        """
        Detect contract type adaptively

        Returns:
            {
                'type': str,
                'confidence': float,
                'is_new': bool,
                'matched_keywords': List[str],
                'suggested_category': str,
                'requires_review': bool
            }
        """
        all_text = f"{folder_name} {' '.join(file_names)}".lower()

        # Try to match known types
        best_match = None
        best_score = 0
        matched_keywords = []

        for contract_type, keywords in self.known_contracts.items():
            score = 0
            local_matches = []

            for keyword in keywords:
                if keyword.lower() in all_text:
                    score += 1
                    local_matches.append(keyword)

            # Calculate confidence (percentage of keywords matched)
            if len(keywords) > 0:
                confidence = score / len(keywords)

                if confidence > best_score:
                    best_score = confidence
                    best_match = contract_type
                    matched_keywords = local_matches

        # If we found a good match
        if best_score >= confidence_threshold:
            return {
                'type': best_match,
                'confidence': round(best_score, 2),
                'is_new': False,
                'matched_keywords': matched_keywords,
                'suggested_category': best_match,
                'requires_review': False
            }

        # If partial match, flag for review
        elif best_score > 0.3:
            return {
                'type': best_match or "Unknown",
                'confidence': round(best_score, 2),
                'is_new': False,
                'matched_keywords': matched_keywords,
                'suggested_category': best_match,
                'requires_review': True,  # Low confidence - needs review
                'review_reason': f"Low confidence match ({best_score:.1%})"
            }

        # Completely new type - extract potential category from folder name
        else:
            suggested_name = self._extract_category_name(folder_name)

            # Check if we've seen this before
            if suggested_name in self.new_contract_types:
                self.new_contract_types[suggested_name]['count'] += 1
            else:
                self.new_contract_types[suggested_name] = {
                    'count': 1,
                    'folder_name': folder_name,
                    'first_seen': folder_name,
                }

            return {
                'type': suggested_name,
                'confidence': 0.0,
                'is_new': True,
                'matched_keywords': [],
                'suggested_category': suggested_name,
                'requires_review': True,
                'review_reason': "NEW contract type - not in known list"
            }

    def detect_compliance_type(self, folder_name: str, file_names: List[str], confidence_threshold: float = 0.6) -> Dict:
        """
        Detect compliance asset type adaptively

        Same return structure as detect_contract_type
        """
        all_text = f"{folder_name} {' '.join(file_names)}".lower()

        # Try to match known types
        best_match = None
        best_score = 0
        matched_keywords = []

        for compliance_type, keywords in self.known_compliance.items():
            score = 0
            local_matches = []

            for keyword in keywords:
                if keyword.lower() in all_text:
                    score += 1
                    local_matches.append(keyword)

            if len(keywords) > 0:
                confidence = score / len(keywords)

                if confidence > best_score:
                    best_score = confidence
                    best_match = compliance_type
                    matched_keywords = local_matches

        # Good match
        if best_score >= confidence_threshold:
            return {
                'type': best_match,
                'confidence': round(best_score, 2),
                'is_new': False,
                'matched_keywords': matched_keywords,
                'suggested_category': best_match,
                'requires_review': False
            }

        # Partial match
        elif best_score > 0.3:
            return {
                'type': best_match or "Unknown",
                'confidence': round(best_score, 2),
                'is_new': False,
                'matched_keywords': matched_keywords,
                'suggested_category': best_match,
                'requires_review': True,
                'review_reason': f"Low confidence match ({best_score:.1%})"
            }

        # New type
        else:
            suggested_name = self._extract_category_name(folder_name)

            if suggested_name in self.new_compliance_types:
                self.new_compliance_types[suggested_name]['count'] += 1
            else:
                self.new_compliance_types[suggested_name] = {
                    'count': 1,
                    'folder_name': folder_name,
                    'first_seen': folder_name,
                }

            return {
                'type': suggested_name,
                'confidence': 0.0,
                'is_new': True,
                'matched_keywords': [],
                'suggested_category': suggested_name,
                'requires_review': True,
                'review_reason': "NEW compliance type - not in known list"
            }

    def _extract_category_name(self, folder_name: str) -> str:
        """
        Extract a sensible category name from folder name
        Removes numbering, cleans up formatting
        """
        # Remove numbering prefix (e.g., "7.04 PEST CONTROL" -> "PEST CONTROL")
        name = re.sub(r'^[\d\.]+\s*[-\s]*', '', folder_name)

        # Remove file extensions
        name = re.sub(r'\.(pdf|docx|xlsx|zip)$', '', name, flags=re.IGNORECASE)

        # Title case
        name = name.strip().title()

        # If it's all caps or all lowercase, clean it up
        if name.isupper():
            name = name.title()

        return name if name else "Unknown"

    def generate_review_report(self) -> Dict:
        """
        Generate a report of items requiring human review
        """
        report = {
            'uncertain_items': self.uncertain_items,
            'new_contract_types': self.new_contract_types,
            'new_compliance_types': self.new_compliance_types,
            'total_requiring_review': len(self.uncertain_items) + len(self.new_contract_types) + len(self.new_compliance_types)
        }

        return report

    def export_new_categories_for_approval(self, output_file: str):
        """
        Export newly discovered categories to JSON for human review/approval
        """
        export_data = {
            'metadata': {
                'generated_at': datetime.now().isoformat(),
                'total_new_contracts': len(self.new_contract_types),
                'total_new_compliance': len(self.new_compliance_types),
            },
            'new_contracts': self.new_contract_types,
            'new_compliance': self.new_compliance_types,
            'instructions': {
                'step_1': "Review each new category",
                'step_2': "Add appropriate keywords",
                'step_3': "Merge to KNOWN_CONTRACTS or KNOWN_COMPLIANCE",
                'step_4': "Re-run extraction"
            }
        }

        with open(output_file, 'w') as f:
            json.dump(export_data, f, indent=2)

        return output_file


# Example usage and testing
if __name__ == "__main__":
    detector = AdaptiveDetector()

    print("="*80)
    print("ADAPTIVE CONTRACT & COMPLIANCE DETECTOR - TEST")
    print("="*80)

    # Test known types
    print("\n1. TESTING KNOWN TYPES:")

    test_cases = [
        ("7.04 LIFTS", ["Ardent contract 2023.pdf"]),
        ("FIRE ALARM", ["Fire alarm contract.pdf", "Monthly inspection.pdf"]),
        ("Water Hygiene", ["Legionella assessment 2024.pdf"]),
    ]

    for folder, files in test_cases:
        result = detector.detect_contract_type(folder, files)
        print(f"\n📁 {folder}")
        print(f"   Type: {result['type']}")
        print(f"   Confidence: {result['confidence']}")
        print(f"   Is New: {result['is_new']}")
        print(f"   Requires Review: {result['requires_review']}")

    # Test new/unknown types
    print("\n\n2. TESTING NEW/UNKNOWN TYPES:")

    new_test_cases = [
        ("SOLAR PANEL MAINTENANCE", ["Solar inverter check.pdf"]),
        ("QUANTUM FLUX CAPACITOR", ["Flux readings 2024.xlsx"]),
        ("MAGIC CARPET REPAIR", ["Flying carpet service.pdf"]),
    ]

    for folder, files in new_test_cases:
        result = detector.detect_contract_type(folder, files)
        print(f"\n📁 {folder}")
        print(f"   Type: {result['type']}")
        print(f"   Confidence: {result['confidence']}")
        print(f"   Is New: ✅ {result['is_new']}")
        print(f"   Requires Review: {result['requires_review']}")
        print(f"   Reason: {result.get('review_reason', 'N/A')}")

    # Generate review report
    print("\n\n3. REVIEW REPORT:")
    report = detector.generate_review_report()
    print(f"   New contract types discovered: {len(report['new_contract_types'])}")
    print(f"   New compliance types discovered: {len(report['new_compliance_types'])}")
    print(f"   Total requiring review: {report['total_requiring_review']}")

    if report['new_contract_types']:
        print("\n   New Contract Types:")
        for cat_name, info in report['new_contract_types'].items():
            print(f"      - {cat_name} (seen {info['count']} times)")

    # Export for review
    export_file = "output/new_categories_for_review.json"
    detector.export_new_categories_for_approval(export_file)
    print(f"\n✅ Exported new categories to: {export_file}")

    print("\n" + "="*80)
