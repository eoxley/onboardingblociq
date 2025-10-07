"""
BlocIQ Onboarder - Asset Detection Extractor
Detects and extracts building assets (AOV, Boiler, Lifts, Fire Systems, etc.)
"""

import re
import uuid
from typing import Dict, List, Optional
from datetime import datetime


class AssetsExtractor:
    """Extracts building asset information from documents"""

    # Asset type definitions with keywords
    ASSET_TYPES = {
        'aov': {
            'keywords': ['aov', 'automatic opening vent', 'smoke vent', 'aov system'],
            'compliance_category': 'fire_safety'
        },
        'boiler': {
            'keywords': ['boiler', 'heating system', 'gas boiler', 'combi boiler'],
            'compliance_category': 'gas_safety'
        },
        'roller_shutter': {
            'keywords': ['roller shutter', 'shutter door', 'rolling door'],
            'compliance_category': 'fire_safety'
        },
        'fire_alarm': {
            'keywords': ['fire alarm', 'fire detection', 'fire panel', 'smoke detector'],
            'compliance_category': 'fire_safety'
        },
        'sprinkler': {
            'keywords': ['sprinkler', 'fire suppression', 'wet riser', 'dry riser'],
            'compliance_category': 'fire_safety'
        },
        'lift': {
            'keywords': ['lift', 'elevator', 'passenger lift', 'service lift'],
            'compliance_category': 'lifts_safety'
        },
        'pump': {
            'keywords': ['pump', 'water pump', 'booster pump', 'sump pump'],
            'compliance_category': 'water_safety'
        },
        'cctv': {
            'keywords': ['cctv', 'camera', 'surveillance', 'security camera'],
            'compliance_category': 'security'
        },
        'door_entry': {
            'keywords': ['door entry', 'intercom', 'access control', 'entry system'],
            'compliance_category': 'security'
        },
        'emergency_lighting': {
            'keywords': ['emergency lighting', 'emergency lights', 'exit sign'],
            'compliance_category': 'fire_safety'
        },
        'fire_extinguisher': {
            'keywords': ['fire extinguisher', 'extinguisher', 'fire equipment'],
            'compliance_category': 'fire_safety'
        },
        'lightning_protection': {
            'keywords': ['lightning protection', 'lightning conductor', 'earth bonding'],
            'compliance_category': 'electrical_safety'
        },
        'communal_aerial': {
            'keywords': ['communal aerial', 'tv aerial', 'satellite dish'],
            'compliance_category': 'other'
        },
        'waste_chute': {
            'keywords': ['waste chute', 'refuse chute', 'bin chute'],
            'compliance_category': 'other'
        },
        'water_tank': {
            'keywords': ['water tank', 'cold water tank', 'storage tank'],
            'compliance_category': 'water_safety'
        },
        'generator': {
            'keywords': ['generator', 'backup generator', 'emergency power'],
            'compliance_category': 'electrical_safety'
        }
    }

    def __init__(self):
        pass

    def extract(self, file_data: Dict, building_id: str) -> List[Dict]:
        """
        Extract asset information from document

        Args:
            file_data: Parsed document data
            building_id: Building UUID

        Returns:
            List of detected assets
        """
        file_name = file_data.get('file_name', '')
        full_text = file_data.get('full_text', '')

        if not full_text:
            full_text = self._extract_text_from_data(file_data)

        if not full_text or len(full_text) < 50:
            return []

        assets = []

        # Detect each asset type
        for asset_type, config in self.ASSET_TYPES.items():
            detected = self._detect_asset_type(
                text=full_text,
                asset_type=asset_type,
                keywords=config['keywords'],
                compliance_category=config['compliance_category'],
                building_id=building_id,
                source_file=file_name
            )
            assets.extend(detected)

        return assets

    def _extract_text_from_data(self, file_data: Dict) -> str:
        """Extract text from data field"""
        if 'data' in file_data and isinstance(file_data['data'], str):
            return file_data['data']
        return ''

    def _detect_asset_type(self, text: str, asset_type: str, keywords: List[str],
                           compliance_category: str, building_id: str,
                           source_file: str) -> List[Dict]:
        """Detect specific asset type in text"""

        assets = []
        text_lower = text.lower()

        # Check if any keyword matches
        for keyword in keywords:
            if keyword in text_lower:
                # Extract details around the keyword
                asset = self._extract_asset_details(
                    text=text,
                    asset_type=asset_type,
                    keyword=keyword,
                    compliance_category=compliance_category,
                    building_id=building_id,
                    source_file=source_file
                )
                if asset:
                    assets.append(asset)
                break  # Only extract once per asset type per document

        return assets

    def _extract_asset_details(self, text: str, asset_type: str, keyword: str,
                                compliance_category: str, building_id: str,
                                source_file: str) -> Optional[Dict]:
        """Extract detailed information about detected asset"""

        # Find keyword position
        keyword_lower = keyword.lower()
        text_lower = text.lower()
        pos = text_lower.find(keyword_lower)

        if pos == -1:
            return None

        # Extract context (500 chars around keyword)
        start = max(0, pos - 250)
        end = min(len(text), pos + 250)
        context = text[start:end]

        # Extract asset details from context
        asset_name = self._extract_asset_name(context, keyword)
        location = self._extract_location(context)
        manufacturer = self._extract_manufacturer(context)
        model_number = self._extract_model_number(context)
        serial_number = self._extract_serial_number(context)
        installation_date = self._extract_date(context, 'installation')
        last_service = self._extract_date(context, 'service')
        next_due = self._extract_date(context, 'next')
        condition = self._extract_condition(context)
        service_frequency = self._extract_service_frequency(context)

        asset = {
            'id': str(uuid.uuid4()),
            'building_id': building_id,
            'contractor_id': None,  # To be linked later
            'compliance_asset_id': None,  # To be linked later
            'asset_type': asset_type,
            'asset_name': asset_name or keyword.title(),
            'location_description': location,
            'manufacturer': manufacturer,
            'model_number': model_number,
            'serial_number': serial_number,
            'installation_date': installation_date,
            'service_frequency': service_frequency,
            'last_service_date': last_service,
            'next_due_date': next_due,
            'condition_rating': condition,
            'compliance_category': compliance_category,
            'linked_documents': [source_file],
            'notes': None
        }

        return asset

    def _extract_asset_name(self, context: str, keyword: str) -> Optional[str]:
        """Extract specific asset name/identifier"""
        # Look for patterns like "AOV-01", "Boiler Unit 3", etc.
        patterns = [
            rf'{keyword}\s*[-:]?\s*([A-Z0-9\-]+)',
            rf'{keyword}\s+(?:unit|system|no\.?)\s*(\d+)',
            rf'([A-Z0-9\-]+)\s+{keyword}'
        ]

        for pattern in patterns:
            match = re.search(pattern, context, re.IGNORECASE)
            if match:
                return match.group(0).strip()

        return None

    def _extract_location(self, context: str) -> Optional[str]:
        """Extract location description"""
        location_keywords = [
            'located', 'location', 'situated', 'installed', 'position',
            'roof', 'basement', 'plant room', 'core', 'floor', 'level',
            'car park', 'entrance', 'lobby', 'corridor'
        ]

        for keyword in location_keywords:
            pattern = rf'{keyword}[:\s]+([A-Za-z0-9\s,\-]+?)(?:\.|,|\n|$)'
            match = re.search(pattern, context, re.IGNORECASE)
            if match:
                location = match.group(1).strip()
                # Limit length
                if len(location) <= 100:
                    return location

        # Look for specific location patterns
        location_patterns = [
            r'(?:roof|basement|ground|first|second|third)\s+(?:floor|level|core)',
            r'plant room [A-Z0-9]+',
            r'core [A-Z]+',
            r'level \d+'
        ]

        for pattern in location_patterns:
            match = re.search(pattern, context, re.IGNORECASE)
            if match:
                return match.group(0).strip()

        return None

    def _extract_manufacturer(self, context: str) -> Optional[str]:
        """Extract manufacturer name"""
        patterns = [
            r'(?:manufacturer|made by|manufactured by)[:\s]+([A-Z][A-Za-z\s&]+(?:Ltd|Limited|plc)?)',
            r'(?:brand|make)[:\s]+([A-Z][A-Za-z\s]+)'
        ]

        for pattern in patterns:
            match = re.search(pattern, context, re.IGNORECASE)
            if match:
                manufacturer = match.group(1).strip()
                if len(manufacturer) <= 50:
                    return manufacturer

        return None

    def _extract_model_number(self, context: str) -> Optional[str]:
        """Extract model number"""
        patterns = [
            r'(?:model|type)[:\s]+([A-Z0-9\-]+)',
            r'model no\.?\s*[:\s]*([A-Z0-9\-]+)'
        ]

        for pattern in patterns:
            match = re.search(pattern, context, re.IGNORECASE)
            if match:
                return match.group(1).strip()

        return None

    def _extract_serial_number(self, context: str) -> Optional[str]:
        """Extract serial number"""
        patterns = [
            r'(?:serial|s/n|serial no\.?)[:\s]+([A-Z0-9\-]+)',
            r'serial number[:\s]+([A-Z0-9\-]+)'
        ]

        for pattern in patterns:
            match = re.search(pattern, context, re.IGNORECASE)
            if match:
                return match.group(1).strip()

        return None

    def _extract_date(self, context: str, date_type: str) -> Optional[str]:
        """Extract date (installation/service/next)"""
        if date_type == 'installation':
            keywords = ['installed', 'installation date', 'commissioned']
        elif date_type == 'service':
            keywords = ['last service', 'serviced', 'last inspected', 'inspection date']
        elif date_type == 'next':
            keywords = ['next service', 'next due', 'due date', 'next inspection']
        else:
            keywords = []

        for keyword in keywords:
            pattern = rf'{keyword}[:\s]*(\d{{1,2}}[/-]\d{{1,2}}[/-]\d{{2,4}})'
            match = re.search(pattern, context, re.IGNORECASE)
            if match:
                return self._normalize_date(match.group(1))

        return None

    def _normalize_date(self, date_string: str) -> Optional[str]:
        """Normalize date to ISO format"""
        for sep in ['/', '-']:
            pattern = f'(\\d{{1,2}}){sep}(\\d{{1,2}}){sep}(\\d{{2,4}})'
            match = re.match(pattern, date_string)
            if match:
                day, month, year = match.groups()
                if len(year) == 2:
                    year = f"20{year}"
                try:
                    date_obj = datetime(int(year), int(month), int(day))
                    return date_obj.date().isoformat()
                except ValueError:
                    continue
        return None

    def _extract_condition(self, context: str) -> Optional[str]:
        """Extract condition rating"""
        condition_patterns = {
            'excellent': r'\bexcellent\b',
            'good': r'\bgood condition\b',
            'fair': r'\bfair\b|\bsatisfactory\b',
            'poor': r'\bpoor\b|\bunsatisfactory\b',
            'failed': r'\bfailed\b|\bunserviceable\b'
        }

        for condition, pattern in condition_patterns.items():
            if re.search(pattern, context, re.IGNORECASE):
                return condition

        return None

    def _extract_service_frequency(self, context: str) -> Optional[str]:
        """Extract service frequency"""
        frequency_patterns = [
            r'\bmonthly\b',
            r'\bquarterly\b',
            r'\bsemi-annual\b',
            r'\bannual(?:ly)?\b',
            r'\b6-monthly\b',
            r'\bweekly\b',
            r'every\s+\d+\s+(?:days?|weeks?|months?|years?)'
        ]

        for pattern in frequency_patterns:
            match = re.search(pattern, context, re.IGNORECASE)
            if match:
                return match.group(0).lower().strip()

        return None

    def link_to_compliance(self, asset: Dict, compliance_assets: List[Dict]) -> Optional[str]:
        """
        Link asset to compliance_asset record by matching asset name/type

        Args:
            asset: Asset dict
            compliance_assets: List of compliance asset dicts

        Returns:
            compliance_asset_id if match found
        """
        asset_type = asset.get('asset_type', '').lower()
        asset_name = asset.get('asset_name', '').lower()

        # Mapping of asset types to compliance asset types
        compliance_mapping = {
            'fire_alarm': ['fire_alarm', 'fire detection'],
            'emergency_lighting': ['emergency_lighting', 'emergency lights'],
            'lift': ['lift', 'passenger lift', 'goods lift'],
            'aov': ['aov', 'smoke vent'],
            'sprinkler': ['sprinkler', 'fire suppression'],
            'boiler': ['gas safety', 'boiler']
        }

        # Find matching compliance asset
        search_terms = compliance_mapping.get(asset_type, [asset_type])

        for compliance_asset in compliance_assets:
            comp_name = compliance_asset.get('asset_name', '').lower()
            comp_type = compliance_asset.get('asset_type', '').lower()

            for term in search_terms:
                if term in comp_name or term in comp_type:
                    return compliance_asset.get('id')

        return None
