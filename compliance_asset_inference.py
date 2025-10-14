#!/usr/bin/env python3
"""
Compliance Asset Inference Engine
==================================
Intelligently infers missing/forgotten compliance assets based on:
- Building characteristics (height, age, services)
- Document evidence (old inspections, expired certificates)
- Regulatory requirements
- Industry best practices

Uses comprehensive UK compliance taxonomy (50+ asset types).

Author: BlocIQ Team
Date: 2025-10-14
"""

from datetime import datetime, timedelta
from typing import Dict, List, Optional
import re
from comprehensive_compliance_taxonomy import ComplianceAssetTaxonomy


class ComplianceAssetInference:
    """Infer missing compliance assets based on building profile"""

    def __init__(self, building_profile: Dict, detected_assets: List[Dict], all_documents: List[Dict] = None):
        """
        Initialize inference engine

        Args:
            building_profile: Dict with building characteristics
            detected_assets: List of already detected compliance assets
            all_documents: List of all documents found (for evidence searching)
        """
        self.building = building_profile
        self.detected_assets = detected_assets
        self.all_documents = all_documents or []

        # Import comprehensive taxonomy
        self.taxonomy = ComplianceAssetTaxonomy()
        self.ASSET_REQUIREMENTS = self._convert_taxonomy_to_requirements()

        # Results
        self.inferred_assets = []
        self.missing_assets = []
        self.expired_assets = []
        self.evidence_found = {}

    def _convert_taxonomy_to_requirements(self) -> Dict:
        """
        Convert comprehensive taxonomy to inference requirements format
        """
        requirements = {}

        for asset_name, asset_info in self.taxonomy.COMPLIANCE_ASSETS.items():
            requirements[asset_name] = {
                "required_if": asset_info['required_if'],
                "frequency_months": asset_info['frequency_months'],
                "regulatory_basis": asset_info['regulatory_basis'],
                "evidence_keywords": asset_info['keywords'],
                "priority": asset_info['priority'],
                "full_name": asset_info['full_name'],
                "category": asset_info['category'],
            }

        return requirements

    def infer_all_assets(self) -> Dict:
        """
        Main inference method - checks all possible compliance assets

        Returns:
            Dict with inferred_assets, missing_assets, expired_assets, recommendations
        """
        print("\n" + "="*80)
        print("COMPLIANCE ASSET INFERENCE ENGINE")
        print("="*80)

        print(f"\nBuilding Profile:")
        print(f"  Name: {self.building.get('building_name', 'Unknown')}")
        print(f"  Height: {self.building.get('building_height_meters', 'Unknown')}m")
        print(f"  Units: {self.building.get('num_units', 'Unknown')}")
        print(f"  Lifts: {self.building.get('has_lifts', False)}")
        print(f"  Construction: {self.building.get('construction_era', 'Unknown')}")

        print(f"\n✅ Currently detected assets: {len(self.detected_assets)}")

        # Build map of detected asset types
        detected_types = {asset['asset_type']: asset for asset in self.detected_assets}

        print("\n" + "-"*80)
        print("CHECKING REGULATORY REQUIREMENTS")
        print("-"*80)

        today = datetime.now()

        for asset_type, requirements in self.ASSET_REQUIREMENTS.items():
            # Check if this asset is required for this building
            is_required = requirements['required_if'](self.building)

            if not is_required:
                print(f"\n⏭️  {asset_type}: Not required for this building")
                continue

            print(f"\n🔍 {asset_type}: REQUIRED ({requirements['priority']} priority)")

            # Check if we have a current record
            if asset_type in detected_types:
                asset = detected_types[asset_type]
                status = asset.get('status', 'unknown')
                inspection_date = asset.get('inspection_date', '')
                next_due = asset.get('next_due_date', '')

                if status == 'expired':
                    print(f"   ⚠️  EXPIRED: Last inspection {inspection_date}, was due {next_due}")
                    self.expired_assets.append({
                        **asset,
                        'inference': 'Asset detected but expired - likely forgotten',
                        'recommendation': f'Urgent renewal required (due {next_due})'
                    })
                elif status == 'current':
                    print(f"   ✅ CURRENT: Last inspection {inspection_date}, due {next_due}")
                else:
                    print(f"   ⚠️  UNKNOWN STATUS: {inspection_date}")

            else:
                # Asset NOT detected - search for evidence
                print(f"   ❌ NOT DETECTED in current records")

                evidence = self._search_for_evidence(asset_type, requirements)

                if evidence['found']:
                    print(f"   🔍 EVIDENCE FOUND: {evidence['description']}")

                    # Infer asset with estimated dates
                    inferred_asset = {
                        'asset_type': asset_type,
                        'status': 'missing',
                        'inference_reason': 'Required by regulation + evidence found',
                        'evidence': evidence,
                        'regulatory_basis': requirements['regulatory_basis'],
                        'priority': requirements['priority'],
                        'recommended_action': 'Commission inspection immediately',
                        'frequency_months': requirements['frequency_months'],
                    }

                    # If we have old inspection evidence, estimate when it expired
                    if evidence.get('old_inspection_date'):
                        old_date = datetime.fromisoformat(evidence['old_inspection_date'])
                        expected_due = old_date + timedelta(days=requirements['frequency_months'] * 30)
                        days_overdue = (today - expected_due).days

                        inferred_asset['last_known_inspection'] = evidence['old_inspection_date']
                        inferred_asset['estimated_expiry_date'] = expected_due.strftime('%Y-%m-%d')
                        inferred_asset['estimated_days_overdue'] = days_overdue

                        print(f"   📅 Last known inspection: {evidence['old_inspection_date']}")
                        print(f"   ⏰ Estimated expiry: {expected_due.strftime('%Y-%m-%d')} ({days_overdue} days ago)")

                    self.inferred_assets.append(inferred_asset)

                else:
                    print(f"   ⚠️  NO EVIDENCE FOUND - assuming asset should exist")

                    # Still infer based on regulation requirement
                    missing_asset = {
                        'asset_type': asset_type,
                        'status': 'missing',
                        'inference_reason': 'Required by regulation (no historical evidence found)',
                        'regulatory_basis': requirements['regulatory_basis'],
                        'priority': requirements['priority'],
                        'recommended_action': f'Verify if {asset_type} exists and commission inspection',
                        'frequency_months': requirements['frequency_months'],
                    }

                    self.missing_assets.append(missing_asset)

        # Summary
        print("\n" + "="*80)
        print("INFERENCE SUMMARY")
        print("="*80)

        print(f"\n✅ Current/Valid Assets: {sum(1 for a in self.detected_assets if a.get('status') == 'current')}")
        print(f"⚠️  Expired Assets: {len(self.expired_assets)}")
        print(f"🔍 Inferred (Evidence Found): {len(self.inferred_assets)}")
        print(f"❌ Missing (No Evidence): {len(self.missing_assets)}")

        return {
            'detected_assets': self.detected_assets,
            'expired_assets': self.expired_assets,
            'inferred_assets': self.inferred_assets,
            'missing_assets': self.missing_assets,
            'summary': {
                'total_required': len([k for k, v in self.ASSET_REQUIREMENTS.items() if v['required_if'](self.building)]),
                'current': sum(1 for a in self.detected_assets if a.get('status') == 'current'),
                'expired': len(self.expired_assets),
                'inferred': len(self.inferred_assets),
                'missing': len(self.missing_assets),
                'compliance_rate': round(sum(1 for a in self.detected_assets if a.get('status') == 'current') / max(1, len([k for k, v in self.ASSET_REQUIREMENTS.items() if v['required_if'](self.building)])) * 100, 1)
            }
        }

    def _search_for_evidence(self, asset_type: str, requirements: Dict) -> Dict:
        """
        Search through all documents for evidence of this asset

        Returns:
            Dict with 'found', 'description', 'source_files', 'old_inspection_date'
        """
        evidence = {
            'found': False,
            'description': '',
            'source_files': [],
            'old_inspection_date': None,
        }

        keywords = requirements.get('evidence_keywords', [])

        for doc in self.all_documents:
            doc_name = doc.get('file_name', '') + ' ' + doc.get('file_path', '')
            doc_text = doc.get('text_content', '')

            # Check filename and text for keywords
            matches = []
            for keyword in keywords:
                if keyword.lower() in doc_name.lower() or keyword.lower() in doc_text.lower():
                    matches.append(keyword)

            if matches:
                evidence['found'] = True
                evidence['source_files'].append(doc.get('file_name', ''))

                # Try to extract date from filename or content
                date_patterns = [
                    r'(\d{4}-\d{2}-\d{2})',
                    r'(\d{2}\.\d{2}\.\d{2,4})',
                    r'(\d{2}/\d{2}/\d{4})',
                ]

                for pattern in date_patterns:
                    match = re.search(pattern, doc_name + doc_text)
                    if match:
                        try:
                            # Try to parse date
                            date_str = match.group(1)
                            # Attempt ISO format first
                            if '-' in date_str:
                                evidence['old_inspection_date'] = date_str
                            elif '.' in date_str:
                                parts = date_str.split('.')
                                if len(parts) == 3:
                                    # DD.MM.YY or DD.MM.YYYY
                                    year = parts[2] if len(parts[2]) == 4 else f"20{parts[2]}"
                                    evidence['old_inspection_date'] = f"{year}-{parts[1]}-{parts[0]}"
                            break
                        except:
                            pass

        if evidence['found']:
            evidence['description'] = f"Found {len(evidence['source_files'])} document(s) mentioning {asset_type}"
            if evidence['old_inspection_date']:
                evidence['description'] += f" (dated {evidence['old_inspection_date']})"

        return evidence


# Example usage function
def analyze_building_compliance(building_profile: Dict, detected_assets: List[Dict], all_documents: List[Dict] = None) -> Dict:
    """
    Main function to analyze compliance for a building

    Args:
        building_profile: Building characteristics
        detected_assets: Currently detected compliance assets
        all_documents: All parsed documents (for evidence search)

    Returns:
        Dict with comprehensive compliance analysis
    """
    engine = ComplianceAssetInference(building_profile, detected_assets, all_documents)
    return engine.infer_all_assets()


if __name__ == "__main__":
    # Test with Connaught Square
    building = {
        "building_name": "32-34 Connaught Square",
        "building_height_meters": 14,
        "num_units": 8,
        "num_floors": 4,
        "has_lifts": True,
        "num_lifts": 1,
        "has_communal_heating": True,
        "heating_type": "Gas boiler",
        "construction_era": "Victorian",
        "year_built": 1850,
        "bsa_registration_required": True,
    }

    detected = [
        {"asset_type": "FRA", "status": "expired", "inspection_date": "2023-12-07", "next_due_date": "2024-12-31"},
        {"asset_type": "EICR", "status": "current", "inspection_date": "2023-01-01", "next_due_date": "2028-01-01"},
        {"asset_type": "Legionella", "status": "expired", "inspection_date": "2022-06-07", "next_due_date": "2024-06-07"},
        {"asset_type": "Asbestos", "status": "current", "inspection_date": "2022-06-14", "next_due_date": "2025-06-14"},
        {"asset_type": "Fire Door", "status": "current", "inspection_date": "2024-01-24", "next_due_date": "2025-01-24"},
    ]

    result = analyze_building_compliance(building, detected)

    print("\n" + "="*80)
    print("RECOMMENDATIONS")
    print("="*80)

    if result['expired_assets']:
        print("\n🔴 URGENT - Expired Assets:")
        for asset in result['expired_assets']:
            print(f"   - {asset['asset_type']}: {asset.get('recommendation', 'Renew immediately')}")

    if result['inferred_assets']:
        print("\n🟠 HIGH PRIORITY - Inferred Missing Assets:")
        for asset in result['inferred_assets']:
            print(f"   - {asset['asset_type']}: {asset.get('recommended_action', 'Commission inspection')}")
            if 'estimated_days_overdue' in asset:
                print(f"     Estimated {asset['estimated_days_overdue']} days overdue")

    if result['missing_assets']:
        print("\n🟡 INVESTIGATE - Potentially Missing Assets:")
        for asset in result['missing_assets']:
            print(f"   - {asset['asset_type']}: {asset.get('recommended_action', 'Verify existence')}")

    print(f"\n📊 Overall Compliance Rate: {result['summary']['compliance_rate']}%")
    print("\n" + "="*80)
