#!/usr/bin/env python3
"""
Maintenance Contract Extractor
===============================
Extracts maintenance contracts from contracts folder with:
- Contractor name
- Contract type (Lift, Fire, Cleaning, M&E, etc.)
- Contract dates (start, end, renewal)
- Auto-renew status
- Annual cost
- Maintenance frequency
- Contract status (Active/Expired)
- Links to compliance assets

Uses adaptive detection for unknown contract types.

Author: BlocIQ Team
Date: 2025-10-14
"""

import re
from pathlib import Path
from typing import Dict, List, Optional
from datetime import datetime, timedelta
from collections import defaultdict
from adaptive_contract_compliance_detector import AdaptiveDetector


class MaintenanceContractExtractor:
    """Extract maintenance contracts from contracts folder with adaptive detection"""

    # Compliance asset links (maps contract types to compliance assets)
    COMPLIANCE_LINKS = {
        "Lift Maintenance": "Lift",
        "Fire Alarm": "Fire Alarm",
        "Fire Equipment": "FRA",
        "Fire Door Maintenance": "Fire Door",
        "Emergency Lighting": "Emergency Lighting",
        "Boiler Maintenance": "Gas Safety",
        "Water Hygiene": "Legionella",
        "HVAC": "HVAC",
        "Door Entry System": "Door Entry",
        "Sprinkler System": "Sprinkler System",
        "AOV System": "AOV",
        "Dry Riser": "Dry Riser",
        "Automatic Doors": "Automatic Doors",
        "Gas Safety": "Gas Safety",
        "Electrical Maintenance": "EICR",
        "Lightning Protection": "Lightning Protection",
        "Generator": "Emergency Generator",
    }

    def __init__(self, building_folder: Path):
        """Initialize extractor with adaptive detector"""
        self.building_folder = building_folder
        self.contracts = []

        # Initialize adaptive detector
        self.adaptive_detector = AdaptiveDetector()

        # Track detection results
        self.new_types_detected = []
        self.low_confidence_detections = []

    def extract_all(self) -> Dict:
        """
        Extract all maintenance contracts

        Returns:
            Dict with contracts list and summary
        """
        print("\n" + "="*80)
        print("MAINTENANCE CONTRACT EXTRACTION")
        print("="*80)

        contracts_folder = self.building_folder / "7. CONTRACTS"

        if not contracts_folder.exists():
            print("⚠️  Contracts folder not found")
            return {
                'contracts': [],
                'summary': {'total_contracts': 0}
            }

        # Extract from each contract subfolder
        contract_folders = [f for f in contracts_folder.iterdir() if f.is_dir()]
        print(f"\nFound {len(contract_folders)} contract folders")

        for folder in contract_folders:
            contract_data = self._extract_from_folder(folder)
            if contract_data:
                self.contracts.append(contract_data)

        # Summary
        print(f"\n✅ Extracted {len(self.contracts)} maintenance contracts")

        # Group by type
        by_type = defaultdict(int)
        active = 0
        expired = 0

        for contract in self.contracts:
            by_type[contract['contract_type']] += 1
            if contract.get('contract_status') == 'Active':
                active += 1
            elif contract.get('contract_status') == 'Expired':
                expired += 1

        print(f"\n📊 Contract Summary:")
        print(f"   Active: {active}")
        print(f"   Expired: {expired}")
        print(f"   Unknown: {len(self.contracts) - active - expired}")

        print(f"\n📋 By Type:")
        for ctype, count in sorted(by_type.items()):
            print(f"   {ctype}: {count}")

        # Adaptive detection summary
        if self.new_types_detected:
            print(f"\n⚠️  NEW Contract Types Detected: {len(self.new_types_detected)}")
            for item in self.new_types_detected:
                print(f"   - {item['detected_type']} (from: {item['folder']})")

        if self.low_confidence_detections:
            print(f"\n⚠️  Low Confidence Detections: {len(self.low_confidence_detections)}")
            for item in self.low_confidence_detections:
                print(f"   - {item['detected_type']}: {item['reason']}")

        # Export new types for review if any found
        if self.new_types_detected or self.low_confidence_detections:
            output_file = self.building_folder / "output" / "new_contract_types_for_review.json"
            if not output_file.parent.exists():
                output_file.parent.mkdir(parents=True, exist_ok=True)

            self.adaptive_detector.export_new_categories_for_approval(str(output_file))
            print(f"\n✅ Exported new types for review: {output_file}")

        return {
            'contracts': self.contracts,
            'summary': {
                'total_contracts': len(self.contracts),
                'active': active,
                'expired': expired,
                'by_type': dict(by_type),
                'new_types_detected': len(self.new_types_detected),
                'low_confidence_detections': len(self.low_confidence_detections),
            },
            'adaptive_detection': {
                'new_types': self.new_types_detected,
                'low_confidence': self.low_confidence_detections,
            }
        }

    def _extract_from_folder(self, folder: Path) -> Optional[Dict]:
        """Extract contract details from a folder using adaptive detection"""
        folder_name = folder.name
        print(f"\n📁 {folder_name}")

        # Get all files for better detection
        pdf_files = list(folder.glob("*.pdf"))
        xlsx_files = list(folder.glob("*.xlsx")) + list(folder.glob("*.xls"))
        docx_files = list(folder.glob("*.docx"))
        all_files = pdf_files + xlsx_files + docx_files

        file_names = [f.name for f in all_files] if all_files else []

        # Use adaptive detector to identify contract type
        detection_result = self.adaptive_detector.detect_contract_type(
            folder_name,
            file_names,
            confidence_threshold=0.6
        )

        contract_type = detection_result['type']
        confidence = detection_result['confidence']
        is_new = detection_result['is_new']
        requires_review = detection_result['requires_review']

        # Print detection info
        if is_new:
            print(f"   Type: {contract_type} ⚠️  NEW TYPE (confidence: {confidence})")
            self.new_types_detected.append({
                'folder': folder_name,
                'detected_type': contract_type,
                'confidence': confidence,
            })
        elif requires_review:
            print(f"   Type: {contract_type} ⚠️  LOW CONFIDENCE ({confidence})")
            self.low_confidence_detections.append({
                'folder': folder_name,
                'detected_type': contract_type,
                'confidence': confidence,
                'reason': detection_result.get('review_reason', 'Unknown'),
            })
        else:
            print(f"   Type: {contract_type} (confidence: {confidence})")

        # Extract contractor name from folder name
        contractor_name = self._extract_contractor_name(folder_name)

        if not all_files:
            print(f"   ⚠️  No contract documents found")
            return None

        print(f"   Documents: {len(all_files)}")

        # Try to extract dates from filenames
        start_date, end_date = self._extract_dates_from_files(all_files)

        # Detect auto-renew from filenames
        auto_renew = self._detect_auto_renew(all_files, folder_name)

        # Extract frequency from folder/file names
        frequency = self._extract_frequency(folder_name, [f.name for f in all_files])

        # Calculate status
        status = self._calculate_status(end_date)

        # Get compliance link
        compliance_link = self.COMPLIANCE_LINKS.get(contract_type)

        contract_data = {
            'contractor_name': contractor_name or "Unknown",
            'contract_type': contract_type,
            'contract_start_date': start_date,
            'contract_end_date': end_date,
            'contract_auto_renew': auto_renew,
            'contract_cost_pa': None,  # Would need to parse documents
            'maintenance_frequency': frequency,
            'contract_status': status,
            'contract_source_path': str(folder.relative_to(self.building_folder)),
            'contract_folder_detected': True,
            'document_count': len(all_files),
            'compliance_asset_link': compliance_link,
            'detection_confidence': confidence,
            'is_new_type': is_new,
            'requires_review': requires_review,
        }

        # Print summary
        print(f"   Contractor: {contract_data['contractor_name']}")
        if start_date:
            print(f"   Start: {start_date}")
        if end_date:
            print(f"   End: {end_date} ({status})")
        if frequency:
            print(f"   Frequency: {frequency}")
        if compliance_link:
            print(f"   Links to: {compliance_link} compliance asset")

        return contract_data

    def _extract_contractor_name(self, folder_name: str) -> Optional[str]:
        """Extract contractor name from folder name"""
        # Pattern: "7.XX CONTRACTOR NAME" or "SERVICE - Contractor"

        # Remove numbering prefix
        name = re.sub(r'^[\d\.]+\s*[-\s]*', '', folder_name)

        # If it's just a service type, return None
        if name.upper() == name or len(name.split()) == 1:
            return None

        # Clean up
        name = name.strip()

        # If name looks like it's just keywords, return None
        service_keywords = ['STAFF', 'UTILITIES', 'DRAINAGE', 'REPORTS', 'LIFTS', 'CLEANING']
        if name.upper() in service_keywords:
            return None

        return name if len(name) > 2 else None

    def _extract_dates_from_files(self, files: List[Path]) -> tuple:
        """Extract start and end dates from filenames"""
        start_date = None
        end_date = None

        date_pattern = r'(\d{4})[-_](\d{2})[-_](\d{2})'
        year_pattern = r'(\d{4})'

        for file in files:
            filename = file.name

            # Look for full dates
            matches = re.findall(date_pattern, filename)
            if matches:
                # Assume first date is start, last is end
                if not start_date:
                    year, month, day = matches[0]
                    start_date = f"{year}-{month}-{day}"
                if len(matches) > 1:
                    year, month, day = matches[-1]
                    end_date = f"{year}-{month}-{day}"

            # Look for year ranges like "2023-2026"
            year_range = re.search(r'(\d{4})\s*[-to]+\s*(\d{4})', filename)
            if year_range:
                start_year = year_range.group(1)
                end_year = year_range.group(2)
                if not start_date:
                    start_date = f"{start_year}-01-01"
                if not end_date:
                    end_date = f"{end_year}-12-31"

        return start_date, end_date

    def _detect_auto_renew(self, files: List[Path], folder_name: str) -> bool:
        """Detect if contract auto-renews"""
        auto_renew_keywords = [
            'rolling', 'auto-renew', 'automatic renewal', 'annual renewal',
            'evergreen', 'continuous'
        ]

        all_text = folder_name + ' ' + ' '.join(f.name for f in files)
        all_text_lower = all_text.lower()

        return any(keyword in all_text_lower for keyword in auto_renew_keywords)

    def _extract_frequency(self, folder_name: str, file_names: List[str]) -> Optional[str]:
        """Extract maintenance frequency"""
        all_text = folder_name + ' ' + ' '.join(file_names)
        all_text_lower = all_text.lower()

        frequency_patterns = [
            (r'monthly', 'Monthly'),
            (r'quarterly', 'Quarterly'),
            (r'6\s*month|six\s*month|bi-annual', '6-Monthly'),
            (r'annual|yearly|12\s*month', 'Annual'),
            (r'weekly', 'Weekly'),
            (r'daily', 'Daily'),
        ]

        for pattern, frequency in frequency_patterns:
            if re.search(pattern, all_text_lower):
                return frequency

        return None

    def _calculate_status(self, end_date: Optional[str]) -> str:
        """Calculate contract status"""
        if not end_date:
            return "Unknown"

        try:
            end_dt = datetime.fromisoformat(end_date)
            today = datetime.now()

            if end_dt < today:
                return "Expired"
            elif end_dt < today + timedelta(days=90):
                return "Expiring Soon"
            else:
                return "Active"
        except:
            return "Unknown"


if __name__ == "__main__":
    from pathlib import Path

    BUILDING_FOLDER = Path("/Users/ellie/Downloads/219.01 CONNAUGHT SQUARE")

    extractor = MaintenanceContractExtractor(BUILDING_FOLDER)
    result = extractor.extract_all()

    print("\n" + "="*80)
    print("ALL CONTRACTS")
    print("="*80)

    for contract in result['contracts']:
        print(f"\n{contract['contract_type']} - {contract['contractor_name']}")
        print(f"  Status: {contract['contract_status']}")
        print(f"  Dates: {contract.get('contract_start_date', 'Unknown')} → {contract.get('contract_end_date', 'Unknown')}")
        print(f"  Frequency: {contract.get('maintenance_frequency', 'Unknown')}")
        print(f"  Auto-renew: {contract.get('contract_auto_renew', False)}")
        print(f"  Documents: {contract.get('document_count', 0)}")
        print(f"  Path: {contract['contract_source_path']}")
        if contract.get('compliance_asset_link'):
            print(f"  ✅ Links to {contract['compliance_asset_link']} compliance")

    print("\n" + "="*80)
