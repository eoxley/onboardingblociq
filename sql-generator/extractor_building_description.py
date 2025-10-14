"""
SQL Generator - Building Description Extractor
Aggregates building metadata from multiple documents to create comprehensive building profile
"""

import re
from typing import Dict, List, Optional, Set, Tuple
from collections import Counter


class BuildingDescriptionExtractor:
    """Extract and aggregate building description data from multiple documents"""

    # Building age/type patterns
    AGE_TYPE_PATTERNS = [
        r'(?i)(victorian|georgian|edwardian|post[\-\s]?war|new[\s\-]?build|modern|converted\s*(?:house|building|terrace))',
        r'(?i)(pre[\-\s]?(?:war|1970s?|1980s?)|heritage|listed\s*building)',
    ]

    # Construction material keywords
    MATERIAL_KEYWORDS = [
        'brick', 'masonry', 'concrete', 'timber', 'steel', 'cladding',
        'render', 'insulated panel', 'ACM', 'HPL', 'stone', 'glass',
        'aluminium', 'wood', 'plaster', 'drywall'
    ]

    # Amenity keywords
    AMENITY_KEYWORDS = [
        'gym', 'concierge', 'garden', 'bike store', 'bicycle storage',
        'communal terrace', 'residents lounge', 'resident lounge',
        'pool', 'swimming pool', 'lift', 'elevator', 'fob access',
        'CCTV', 'security', 'roof terrace', 'parking', 'car park',
        'storage', 'post room', 'meeting room', 'cinema room'
    ]

    # Fire strategy patterns
    FIRE_STRATEGY_PATTERNS = [
        (r'(?i)stay[\s\-]?put', 'Stay Put'),
        (r'(?i)simultaneous\s*evacuation', 'Simultaneous Evacuation'),
        (r'(?i)phased\s*evacuation', 'Phased Evacuation'),
        (r'(?i)progressive\s*horizontal\s*evacuation', 'Progressive Horizontal Evacuation')
    ]

    # Number word to digit mapping
    NUMBER_WORDS = {
        'one': 1, 'two': 2, 'three': 3, 'four': 4, 'five': 5,
        'six': 6, 'seven': 7, 'eight': 8, 'nine': 9, 'ten': 10,
        'eleven': 11, 'twelve': 12, 'thirteen': 13, 'fourteen': 14, 'fifteen': 15,
        'twenty': 20, 'thirty': 30, 'forty': 40, 'fifty': 50
    }

    def __init__(self):
        """Initialize extractor"""
        pass

    def extract_from_documents(self, documents: List[Dict]) -> Dict:
        """
        Extract building description from all documents

        Args:
            documents: List of document dictionaries with 'text' and 'document_type'

        Returns:
            Dictionary with building description fields and confidence score
        """
        # Aggregate data from all documents
        descriptions = []
        age_types = []
        materials = []
        amenities = set()
        floors_counts = []
        blocks_counts = []
        cores_counts = []
        lifts_counts = []
        access_texts = []
        parking_texts = []
        heating_texts = []
        cladding_texts = []
        fire_strategies = []

        confidence_signals = {
            'description_found': False,
            'numeric_counts': False,
            'materials_found': False,
            'access_parking': False
        }

        # Process each document
        for doc in documents:
            text = doc.get('text', '')
            doc_type = doc.get('document_type', '')

            if not text:
                continue

            # Extract description paragraphs (prioritize FRA)
            desc = self._extract_description(text, doc_type)
            if desc:
                descriptions.append((desc, doc_type))
                confidence_signals['description_found'] = True

            # Extract age/type
            age_type = self._extract_age_type(text)
            if age_type:
                age_types.append(age_type)

            # Extract materials
            mats = self._extract_materials(text)
            materials.extend(mats)
            if mats:
                confidence_signals['materials_found'] = True

            # Extract numeric counts
            floors = self._extract_floors(text)
            blocks = self._extract_blocks(text)
            cores = self._extract_cores(text)
            lifts = self._extract_lifts(text)

            if floors: floors_counts.append(floors)
            if blocks: blocks_counts.append(blocks)
            if cores: cores_counts.append(cores)
            if lifts: lifts_counts.append(lifts)

            if floors or blocks or cores or lifts:
                confidence_signals['numeric_counts'] = True

            # Extract access details
            access = self._extract_access(text)
            if access:
                access_texts.append(access)
                confidence_signals['access_parking'] = True

            # Extract parking
            parking = self._extract_parking(text)
            if parking:
                parking_texts.append(parking)
                confidence_signals['access_parking'] = True

            # Extract amenities
            found_amenities = self._extract_amenities(text)
            amenities.update(found_amenities)

            # Extract heating system
            heating = self._extract_heating(text)
            if heating:
                heating_texts.append(heating)

            # Extract cladding/EWS status
            cladding = self._extract_cladding(text)
            if cladding:
                cladding_texts.append(cladding)

            # Extract fire strategy
            fire_strat = self._extract_fire_strategy(text)
            if fire_strat:
                fire_strategies.append(fire_strat)

        # Aggregate results
        result = {
            'building_description': self._select_best_description(descriptions),
            'building_age_or_type': self._select_most_common(age_types),
            'num_floors': self._select_max(floors_counts),
            'num_blocks_or_cores': self._select_max(blocks_counts + cores_counts),
            'num_lifts': self._select_max(lifts_counts),
            'access_details': self._select_best_text(access_texts),
            'parking_arrangements': self._select_best_text(parking_texts),
            'amenities': sorted(list(amenities)),
            'construction_materials': self._deduplicate_materials(materials),
            'heating_system': self._select_best_text(heating_texts),
            'cladding_or_ews_status': self._select_best_text(cladding_texts),
            'fire_strategy': self._select_most_common(fire_strategies)
        }

        # Calculate confidence
        result['confidence'] = self._calculate_confidence(confidence_signals)

        return result

    def _extract_description(self, text: str, doc_type: str) -> Optional[str]:
        """Extract building description paragraph"""
        # Priority patterns for description
        patterns = [
            r'(?i)description\s*of\s*(?:premises|property|building|the\s*building)[:\-]?\s*(.+?)(?=\n{2,}|section\s*\d|\Z)',
            r'(?i)(?:the\s*)?building\s*comprises[:\-]?\s*(.+?)(?=\n{2,}|section\s*\d|\Z)',
            r'(?i)(?:the\s*)?property\s*consists\s*of[:\-]?\s*(.+?)(?=\n{2,}|section\s*\d|\Z)',
            r'(?i)(?:the\s*)?premises[:\-]?\s*(.+?)(?=\n{2,}|section\s*\d|\Z)'
        ]

        for pattern in patterns:
            match = re.search(pattern, text, re.DOTALL)
            if match:
                desc = match.group(1).strip()
                # Clean up and limit to ~3 sentences
                sentences = re.split(r'[.!?]\s+', desc)
                desc = '. '.join(sentences[:3])
                if len(desc) > 50:  # Ensure it's substantial
                    return desc

        return None

    def _extract_age_type(self, text: str) -> Optional[str]:
        """Extract building age or type"""
        for pattern in self.AGE_TYPE_PATTERNS:
            match = re.search(pattern, text)
            if match:
                return match.group(1).strip().title()

        # Try to extract from construction year
        year_pattern = r'(?i)(?:constructed|built|erected)\s*(?:in|around|circa)\s*(\d{4})'
        match = re.search(year_pattern, text)
        if match:
            year = int(match.group(1))
            if year < 1900:
                return "Victorian/Georgian"
            elif year < 1945:
                return "Pre-War"
            elif year < 1970:
                return "Post-War"
            elif year < 2000:
                return "Late 20th Century"
            else:
                return "Modern/New Build"

        return None

    def _extract_materials(self, text: str) -> List[str]:
        """Extract construction materials"""
        found = []
        text_lower = text.lower()

        for material in self.MATERIAL_KEYWORDS:
            if material.lower() in text_lower:
                found.append(material.title())

        return found

    def _extract_floors(self, text: str) -> Optional[int]:
        """Extract number of floors"""
        patterns = [
            r'(?i)(\d+)\s*(?:storey|storeys|floor|floors|levels?)',
            r'(?i)(one|two|three|four|five|six|seven|eight|nine|ten|eleven|twelve)\s*(?:storey|storeys|floor|floors)',
        ]

        for pattern in patterns:
            match = re.search(pattern, text)
            if match:
                num_str = match.group(1)
                # Convert word to number
                if num_str.lower() in self.NUMBER_WORDS:
                    return self.NUMBER_WORDS[num_str.lower()]
                # Try to parse as integer
                try:
                    return int(num_str)
                except:
                    continue

        return None

    def _extract_blocks(self, text: str) -> Optional[int]:
        """Extract number of blocks"""
        pattern = r'(?i)(\d+|one|two|three|four|five|six|seven|eight)\s*blocks?'
        match = re.search(pattern, text)
        if match:
            num_str = match.group(1)
            if num_str.lower() in self.NUMBER_WORDS:
                return self.NUMBER_WORDS[num_str.lower()]
            try:
                return int(num_str)
            except:
                pass
        return None

    def _extract_cores(self, text: str) -> Optional[int]:
        """Extract number of cores"""
        pattern = r'(?i)(\d+|one|two|three|four|five|six|seven|eight)\s*cores?'
        match = re.search(pattern, text)
        if match:
            num_str = match.group(1)
            if num_str.lower() in self.NUMBER_WORDS:
                return self.NUMBER_WORDS[num_str.lower()]
            try:
                return int(num_str)
            except:
                pass
        return None

    def _extract_lifts(self, text: str) -> Optional[int]:
        """Extract number of lifts"""
        patterns = [
            r'(?i)(\d+)\s*(?:lift|lifts|elevator)s?',
            r'(?i)(one|two|three|four|five|six|seven|eight|nine|ten)\s*(?:lift|lifts|elevator)s?'
        ]

        for pattern in patterns:
            match = re.search(pattern, text)
            if match:
                num_str = match.group(1)
                if num_str.lower() in self.NUMBER_WORDS:
                    return self.NUMBER_WORDS[num_str.lower()]
                try:
                    return int(num_str)
                except:
                    continue

        return None

    def _extract_access(self, text: str) -> Optional[str]:
        """Extract access details"""
        patterns = [
            r'(?i)access\s*(?:to|via|from|is|:)\s*([^\n]{20,200})',
            r'(?i)(pedestrian|vehicular|fire)\s*access[:\-]?\s*([^\n]{20,200})',
            r'(?i)(main\s*entrance|entry\s*(?:point|system))[:\-]?\s*([^\n]{20,150})'
        ]

        for pattern in patterns:
            match = re.search(pattern, text)
            if match:
                # Get the captured text (last group)
                access_text = match.group(match.lastindex).strip()
                # Clean up
                access_text = re.sub(r'\s+', ' ', access_text)
                if len(access_text) > 20:
                    return access_text[:300]  # Limit length

        return None

    def _extract_parking(self, text: str) -> Optional[str]:
        """Extract parking arrangements"""
        pattern = r'(?i)(?:parking|car\s*park)(?:\s*(?:is|:))?\s*([^\n]{20,200})'
        match = re.search(pattern, text)
        if match:
            parking_text = match.group(1).strip()
            parking_text = re.sub(r'\s+', ' ', parking_text)
            if len(parking_text) > 20:
                return parking_text[:300]

        # Check for specific types
        text_lower = text.lower()
        if 'underground' in text_lower and 'parking' in text_lower:
            return "Underground parking"
        elif 'basement' in text_lower and ('parking' in text_lower or 'car park' in text_lower):
            return "Basement parking"
        elif 'no parking' in text_lower or 'parking: none' in text_lower:
            return "No parking provided"

        return None

    def _extract_amenities(self, text: str) -> Set[str]:
        """Extract amenities"""
        found = set()
        text_lower = text.lower()

        for amenity in self.AMENITY_KEYWORDS:
            if amenity.lower() in text_lower:
                # Normalize name
                found.add(amenity.title())

        return found

    def _extract_heating(self, text: str) -> Optional[str]:
        """Extract heating system description"""
        patterns = [
            r'(?i)heating\s*(?:system|is|:)\s*([^\n]{20,200})',
            r'(?i)(?:central|communal)\s*(?:boiler|heating)[:\-]?\s*([^\n]{20,150})',
            r'(?i)(?:HIU|heat\s*interface\s*unit)s?[:\-]?\s*([^\n]{20,150})'
        ]

        for pattern in patterns:
            match = re.search(pattern, text)
            if match:
                heating_text = match.group(1).strip()
                heating_text = re.sub(r'\s+', ' ', heating_text)
                if len(heating_text) > 20:
                    return heating_text[:300]

        return None

    def _extract_cladding(self, text: str) -> Optional[str]:
        """Extract cladding/EWS status"""
        patterns = [
            r'(?i)(?:no\s*)?combustible\s*cladding[:\-]?\s*([^\n]{0,150})',
            r'(?i)EWS1?\s*(?:form|certificate)[:\-]?\s*([^\n]{20,200})',
            r'(?i)external\s*wall\s*system[:\-]?\s*([^\n]{20,200})',
            r'(?i)cladding[:\-]?\s*([^\n]{20,200})'
        ]

        for pattern in patterns:
            match = re.search(pattern, text)
            if match:
                cladding_text = match.group(0).strip()  # Include matched prefix
                cladding_text = re.sub(r'\s+', ' ', cladding_text)
                if len(cladding_text) > 15:
                    return cladding_text[:300]

        return None

    def _extract_fire_strategy(self, text: str) -> Optional[str]:
        """Extract fire evacuation strategy"""
        for pattern, strategy_name in self.FIRE_STRATEGY_PATTERNS:
            if re.search(pattern, text):
                return strategy_name

        return None

    def _select_best_description(self, descriptions: List[Tuple[str, str]]) -> Optional[str]:
        """Select best description from multiple sources"""
        if not descriptions:
            return None

        # Prioritize by document type
        priority_order = ['FRA', 'EICR', 'Asbestos', 'Insurance', 'Valuation']

        # Sort by priority and length
        descriptions.sort(key=lambda x: (
            priority_order.index(x[1]) if x[1] in priority_order else 999,
            -len(x[0])
        ))

        # Return longest from highest priority document
        return descriptions[0][0]

    def _select_most_common(self, values: List[str]) -> Optional[str]:
        """Select most common value"""
        if not values:
            return None

        counter = Counter(values)
        return counter.most_common(1)[0][0]

    def _select_max(self, values: List[int]) -> Optional[int]:
        """Select maximum value"""
        if not values:
            return None
        return max(values)

    def _select_best_text(self, texts: List[str]) -> Optional[str]:
        """Select best text from multiple sources"""
        if not texts:
            return None

        # Return longest unique text
        texts = list(set(texts))  # Remove duplicates
        texts.sort(key=len, reverse=True)
        return texts[0]

    def _deduplicate_materials(self, materials: List[str]) -> List[str]:
        """Deduplicate and prioritize materials"""
        if not materials:
            return []

        # Count occurrences
        counter = Counter(m.lower() for m in materials)

        # Keep materials mentioned at least once, normalize case
        unique = []
        seen = set()
        for material in materials:
            mat_lower = material.lower()
            if mat_lower not in seen:
                unique.append(material.title())
                seen.add(mat_lower)

        return sorted(unique)

    def _calculate_confidence(self, signals: Dict[str, bool]) -> float:
        """Calculate confidence score"""
        score = 0.0

        if signals['description_found']:
            score += 0.4
        if signals['numeric_counts']:
            score += 0.2
        if signals['materials_found']:
            score += 0.2
        if signals['access_parking']:
            score += 0.2

        return round(score, 2)


# Test function
if __name__ == '__main__':
    extractor = BuildingDescriptionExtractor()

    # Test data
    test_docs = [
        {
            'text': """
            FIRE RISK ASSESSMENT REPORT

            Description of Premises:
            Converted Victorian terrace building comprising 4 storeys with basement.
            The building features traditional masonry walls and timber floors throughout.
            Main access is via coded pedestrian gate on Queensway.

            The building has four cores and nine lifts serving all floors.
            Parking is available in the undercroft car park with 25 allocated bays.

            Amenities include a concierge, bike store, and roof terrace.

            Fire Strategy: Stay Put policy in operation.
            """,
            'document_type': 'FRA'
        },
        {
            'text': """
            External Wall Survey

            The building is a concrete frame structure with brick facade.
            No combustible cladding present. EWS1 form issued.

            Central boiler with individual HIUs in each flat.
            """,
            'document_type': 'EWS1'
        }
    ]

    result = extractor.extract_from_documents(test_docs)

    print("Building Description Extraction Results:")
    print("="*60)
    for key, value in result.items():
        print(f"{key}: {value}")
