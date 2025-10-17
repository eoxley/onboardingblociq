"""
Health & Safety Report Analyzer
================================
Extracts building description from H&S reports
Floors, height, construction, systems
"""

import re
from typing import Dict, Optional, List, Any


class HSReportAnalyzer:
    """
    Analyze Health & Safety reports to extract building characteristics
    Reads FRA, H&S assessments for physical description
    """
    
    def extract_building_description(self, text: str) -> Dict[str, any]:
        """
        Extract building description from H&S report text
        
        Returns:
            {
                'number_of_floors': 4,
                'building_height_meters': 14.5,
                'construction_type': 'Victorian conversion',
                'construction_era': 'Victorian',
                'year_built': 1880,
                'has_basement': True,
                'has_roof_access': True,
                'wall_construction': 'Solid brick',
                'floor_construction': 'Timber',
                'roof_construction': 'Pitched slate'
            }
        """
        if not text:
            return {}
        
        description = {}
        
        # Extract floors
        floors = self._extract_floors(text)
        if floors:
            description['number_of_floors'] = floors
        
        # Extract height
        height = self._extract_height(text)
        if height:
            description['building_height_meters'] = height
        
        # Extract construction type
        construction = self._extract_construction_type(text)
        if construction:
            description['construction_type'] = construction
        
        # Extract era
        era = self._extract_construction_era(text)
        if era:
            description['construction_era'] = era
        
        # Extract year built
        year = self._extract_year_built(text)
        if year:
            description['year_built'] = year
        
        # Extract building features
        description['has_basement'] = self._has_feature(text, ['basement', 'lower ground', 'cellar'])
        description['has_roof_access'] = self._has_feature(text, ['roof access', 'roof space', 'loft'])
        
        return description
    
    def _extract_floors(self, text: str) -> Optional[int]:
        """Extract number of floors from text"""
        patterns = [
            r'(\d+)\s*(?:storey|story|storied|floor)',
            r'building\s+of\s+(\d+)\s+floors',
            r'floors?:?\s*(\d+)',
            r'(\d+)[-\s]storey',
        ]
        
        for pattern in patterns:
            match = re.search(pattern, text[:2000], re.IGNORECASE)
            if match:
                try:
                    floors = int(match.group(1))
                    if 1 <= floors <= 50:  # Sanity check
                        return floors
                except:
                    pass
        
        # Try counting floor mentions: "ground floor", "first floor", etc.
        floor_names = ['ground', 'first', 'second', 'third', 'fourth', 'fifth']
        found_floors = set()
        
        for idx, floor_name in enumerate(floor_names):
            if re.search(rf'\b{floor_name}\s+floor\b', text[:3000], re.IGNORECASE):
                found_floors.add(idx)
        
        if found_floors:
            return max(found_floors) + 1  # Convert to floor count
        
        return None
    
    def _extract_height(self, text: str) -> Optional[float]:
        """Extract building height in meters"""
        patterns = [
            r'height:?\s*([\d.]+)\s*m(?:eter|eters|etres|tre)?',
            r'([\d.]+)\s*m(?:eter|etre)?s?\s*(?:high|tall)',
            r'building\s+height:?\s*([\d.]+)',
        ]
        
        for pattern in patterns:
            match = re.search(pattern, text[:2000], re.IGNORECASE)
            if match:
                try:
                    height = float(match.group(1))
                    if 3 <= height <= 200:  # Sanity check (3m to 200m)
                        return height
                except:
                    pass
        
        return None
    
    def _extract_construction_type(self, text: str) -> Optional[str]:
        """Extract construction type description"""
        patterns = [
            r'construction:?\s*([^.\n]{10,100})',
            r'building\s+type:?\s*([^.\n]{10,100})',
            r'description:?\s*([^.\n]{10,100}(?:brick|stone|concrete|timber)[^.\n]{0,50})',
        ]
        
        for pattern in patterns:
            match = re.search(pattern, text[:3000], re.IGNORECASE)
            if match:
                desc = match.group(1).strip()
                if len(desc) > 10:
                    return desc[:150]
        
        return None
    
    def _extract_construction_era(self, text: str) -> Optional[str]:
        """Extract construction era (Victorian, Georgian, Modern, etc.)"""
        eras = {
            'Victorian': r'\bvictorian\b',
            'Georgian': r'\bgeorgian\b',
            'Edwardian': r'\bedwardian\b',
            'Post-War': r'\bpost[- ]war\b',
            'Modern': r'\bmodern\b',
            '1960s': r'\b1960s?\b',
            '1970s': r'\b1970s?\b',
            '1980s': r'\b1980s?\b',
        }
        
        for era, pattern in eras.items():
            if re.search(pattern, text[:2000], re.IGNORECASE):
                return era
        
        return None
    
    def _extract_year_built(self, text: str) -> Optional[int]:
        """Extract year built"""
        patterns = [
            r'built:?\s*in\s*(\d{4})',
            r'constructed:?\s*in\s*(\d{4})',
            r'year\s+(?:of\s+)?construction:?\s*(\d{4})',
            r'circa\s+(\d{4})',
        ]
        
        for pattern in patterns:
            match = re.search(pattern, text[:2000], re.IGNORECASE)
            if match:
                try:
                    year = int(match.group(1))
                    if 1700 <= year <= 2025:  # Sanity check
                        return year
                except:
                    pass
        
        return None
    
    def _has_feature(self, text: str, keywords: List[str]) -> bool:
        """Check if building has a feature based on keywords"""
        text_lower = text.lower()
        return any(kw in text_lower for kw in keywords)
    
    def extract_asset_list(self, text: str) -> List[Dict]:
        """
        Extract list of assets/facilities from H&S report
        Creates comprehensive asset register
        """
        assets = []
        
        # Look for asset mentions
        asset_patterns = {
            'Fire Alarm System': r'\bfire\s+alarm\s+system\b',
            'Emergency Lighting': r'\bemergency\s+light',
            'Fire Extinguishers': r'\bfire\s+extinguisher',
            'Fire Doors': r'\bfire\s+door',
            'Sprinkler System': r'\bsprinkler',
            'Dry Riser': r'\bdry\s+riser',
            'CCTV System': r'\bcctv\b',
            'Door Entry System': r'\bdoor\s+entry|intercom',
            'Lift': r'\blift\b|elevator',
            'Boiler': r'\bboiler',
            'Water Tank': r'\bwater\s+tank',
            'Electrical Panel': r'\b(?:distribution|electrical)\s+(?:panel|board)',
            'Gas Meter': r'\bgas\s+meter',
            'Car Park': r'\bcar\s+park|parking',
            'Bin Store': r'\bbin\s+store|refuse',
            'Bike Store': r'\bbike\s+(?:store|rack|shed)',
        }
        
        text_lower = text.lower()
        
        for asset_name, pattern in asset_patterns.items():
            if re.search(pattern, text_lower):
                # Try to extract quantity
                qty_pattern = rf'(\d+)\s+{pattern}'
                qty_match = re.search(qty_pattern, text_lower)
                quantity = int(qty_match.group(1)) if (qty_match and qty_match.group(1)) else 1
                
                assets.append({
                    'asset_name': asset_name,
                    'asset_type': self._categorize_asset(asset_name),
                    'quantity': quantity,
                    'detected_from': 'hs_report'
                })
        
        return assets
    
    def _categorize_asset(self, asset_name: str) -> str:
        """Categorize asset type"""
        name_lower = asset_name.lower()
        
        if any(term in name_lower for term in ['fire', 'smoke', 'extinguisher']):
            return 'fire_safety'
        elif any(term in name_lower for term in ['lift', 'elevator']):
            return 'mechanical'
        elif any(term in name_lower for term in ['electrical', 'panel', 'lighting']):
            return 'electrical'
        elif any(term in name_lower for term in ['boiler', 'heating', 'water']):
            return 'plant'
        elif any(term in name_lower for term in ['cctv', 'security', 'door entry']):
            return 'security'
        elif any(term in name_lower for term in ['car park', 'bike', 'bin']):
            return 'facilities'
        else:
            return 'general'

