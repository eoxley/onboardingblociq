"""
SQL Generator - Enhanced Unit & Leaseholder Extractor
Extracts demised property addresses AND correspondence/service addresses
Differentiates between where the property is and where the leaseholder lives
"""

import re
from typing import Dict, List, Optional, Tuple, Set
from collections import defaultdict


class UnitsLeaseholdersExtractor:
    """Extract units and leaseholder data with correspondence address detection"""

    # UK postcode pattern
    UK_POSTCODE_PATTERN = r'\b[A-Z]{1,2}\d{1,2}[A-Z]?\s*\d[A-Z]{2}\b'

    # Demised property patterns (subject property)
    DEMISED_PATTERNS = [
        r'(?i)(flat|apartment|unit|premises|dwelling)\s*(\d+[A-Z]?)',
        r'(?i)(flat|apartment|unit)\s*([A-Z]\d+)',
        r'(?i)(penthouse|studio)\s*(\d+)?',
    ]

    # Correspondence address context keywords
    CORRESPONDENCE_KEYWORDS = [
        'correspondence address',
        'service address',
        'registered address',
        'address for correspondence',
        'address for service',
        'address for notices',
        'care of',
        'c/o',
        'residing at',
        'resides at',
        'resident at',
        'of ',  # As in "John Smith of 14 Priory Road"
    ]

    # Ownership type indicators
    CORPORATE_INDICATORS = [
        'ltd', 'limited', 'llp', 'plc', 'inc', 'corporation',
        'company', 'trust', 'nominee', 'holdings', 'ventures',
        'properties', 'investments', 'offshore', 'developments'
    ]

    # Non-resident indicators
    NON_RESIDENT_INDICATORS = [
        'care of managing agent',
        'c/o managing agent',
        'via agent',
        'overseas',
        'abroad'
    ]

    # Common countries (for foreign ownership detection)
    COUNTRIES = [
        'france', 'spain', 'italy', 'germany', 'usa', 'united states',
        'dubai', 'uae', 'singapore', 'hong kong', 'china', 'india',
        'australia', 'canada', 'ireland', 'switzerland', 'netherlands',
        'belgium', 'portugal', 'greece', 'cyprus', 'malta'
    ]

    def __init__(self):
        """Initialize extractor"""
        pass

    def extract_units_from_documents(self, documents: List[Dict]) -> List[Dict]:
        """
        Extract units and leaseholder data from all documents

        Args:
            documents: List of document dicts with 'text' and 'document_type'

        Returns:
            List of unit records with leaseholder information
        """
        units = []

        for doc in documents:
            text = doc.get('text', '')
            doc_type = doc.get('document_type', '')
            file_name = doc.get('file_name', '')

            if not text:
                continue

            # Extract units based on document type
            if doc_type == 'Lease':
                extracted = self._extract_from_lease(text, file_name)
            elif 'leaseholder' in file_name.lower() or 'unit' in file_name.lower():
                extracted = self._extract_from_schedule(text)
            elif doc_type == 'Budget':
                extracted = self._extract_from_budget(text)
            else:
                # Try general extraction
                extracted = self._extract_general(text)

            units.extend(extracted)

        # Deduplicate and merge
        units = self._deduplicate_units(units)

        return units

    def _extract_from_lease(self, text: str, file_name: str) -> List[Dict]:
        """Extract unit and leaseholder from lease document"""
        units = []

        # Extract unit number from filename first
        unit_number = self._extract_unit_from_filename(file_name)

        # Extract demised address
        demised = self._extract_demised_address(text)

        # Extract leaseholder names
        leaseholders = self._extract_leaseholder_names(text)

        # Extract correspondence address
        correspondence = self.detect_correspondence_address(text, demised)

        # Extract title number
        title_number = self._extract_title_number(text)

        # Extract tenure
        tenure = self._extract_tenure(text)

        # Extract apportionment
        apportionment = self._extract_apportionment(text)

        if unit_number or demised or leaseholders:
            unit = {
                'unit_number': unit_number or demised.get('unit_number'),
                'demised_address': demised.get('full_address') if demised else None,
                'demised_postcode': demised.get('postcode') if demised else None,
                'leaseholders': leaseholders,
                'ownership_type': self._determine_ownership_type(leaseholders),
                'title_number': title_number,
                'tenure_flag': tenure,
                'apportionment': apportionment,
                **correspondence  # Includes correspondence_address, is_resident_owner, etc.
            }
            units.append(unit)

        return units

    def _extract_from_schedule(self, text: str) -> List[Dict]:
        """Extract units from leaseholder schedule or list"""
        units = []

        # Split into lines
        lines = text.split('\n')

        for line in lines:
            # Skip headers and empty lines
            if not line.strip() or len(line.strip()) < 10:
                continue

            # Look for unit number + name pattern
            unit_match = re.search(r'(?i)(flat|unit|apartment)\s*(\d+[A-Z]?)', line)

            if unit_match:
                unit_number = f"{unit_match.group(1).title()} {unit_match.group(2)}"

                # Extract name from same line
                names = self._extract_names_from_line(line)

                # Extract any addresses
                addresses = self._extract_all_addresses(line)

                # First address = demised, second = correspondence
                demised_addr = addresses[0] if len(addresses) > 0 else None
                corresp_addr = addresses[1] if len(addresses) > 1 else addresses[0] if addresses else None

                # Extract apportionment percentage
                apportionment = self._extract_apportionment(line)

                unit = {
                    'unit_number': unit_number,
                    'demised_address': demised_addr,
                    'leaseholders': names,
                    'ownership_type': self._determine_ownership_type(names),
                    'correspondence_address': corresp_addr,
                    'is_resident_owner': demised_addr == corresp_addr if demised_addr and corresp_addr else None,
                    'apportionment': apportionment
                }
                units.append(unit)

        return units

    def _extract_from_budget(self, text: str) -> List[Dict]:
        """Extract units from budget/service charge schedule"""
        units = []

        lines = text.split('\n')

        for line in lines:
            # Look for unit + percentage/amount pattern
            unit_match = re.search(r'(?i)(flat|unit|apartment)\s*(\d+[A-Z]?)', line)

            if unit_match:
                unit_number = f"{unit_match.group(1).title()} {unit_match.group(2)}"

                # Extract apportionment
                apportionment = self._extract_apportionment(line)

                # Try to extract name
                names = self._extract_names_from_line(line)

                unit = {
                    'unit_number': unit_number,
                    'leaseholders': names if names else None,
                    'apportionment': apportionment
                }
                units.append(unit)

        return units

    def _extract_general(self, text: str) -> List[Dict]:
        """General extraction from any document"""
        units = []

        # Look for clear unit + leaseholder patterns
        pattern = r'(?i)(flat|unit|apartment)\s*(\d+[A-Z]?)[:\-\s]+(.*?)(?:\n|$)'
        matches = re.finditer(pattern, text)

        for match in matches:
            unit_type = match.group(1).title()
            unit_num = match.group(2)
            context = match.group(3)

            unit_number = f"{unit_type} {unit_num}"

            # Extract names from context
            names = self._extract_names_from_line(context)

            if names:
                unit = {
                    'unit_number': unit_number,
                    'leaseholders': names
                }
                units.append(unit)

        return units

    def detect_correspondence_address(self, text: str, demised_info: Dict = None) -> Dict:
        """
        Detect leaseholder correspondence or service address separate from demised property

        Args:
            text: Document text
            demised_info: Dict with demised address info (if already extracted)

        Returns:
            Dict with correspondence_address, correspondence_postcode,
            correspondence_country, is_resident_owner
        """
        result = {
            'correspondence_address': None,
            'correspondence_postcode': None,
            'correspondence_country': 'UK',
            'is_resident_owner': None,
            'correspondence_email': None,
            'correspondence_phone': None
        }

        # Extract all addresses from text
        all_addresses = self._extract_all_addresses(text)

        if not all_addresses:
            return result

        demised_address = demised_info.get('full_address') if demised_info else None

        # Look for correspondence address with context
        correspondence_address = None

        for keyword in self.CORRESPONDENCE_KEYWORDS:
            # Build pattern to find address after keyword
            pattern = f'(?i){re.escape(keyword)}[:\\s]+(.{{20,200}}?{self.UK_POSTCODE_PATTERN})'
            match = re.search(pattern, text)

            if match:
                correspondence_address = match.group(1).strip()
                correspondence_address = self._clean_address(correspondence_address)
                break

        # If no explicit correspondence keyword, use heuristic
        if not correspondence_address and len(all_addresses) > 1:
            # Assume first address is demised, second is correspondence
            correspondence_address = all_addresses[1]

        elif not correspondence_address and len(all_addresses) == 1:
            # Only one address - could be either
            # Check if it looks like a unit address
            if demised_address:
                correspondence_address = demised_address
            else:
                correspondence_address = all_addresses[0]

        # Extract postcode from correspondence address
        if correspondence_address:
            postcode_match = re.search(self.UK_POSTCODE_PATTERN, correspondence_address)
            if postcode_match:
                result['correspondence_postcode'] = postcode_match.group(0)

        # Check for foreign country
        text_lower = text.lower()
        for country in self.COUNTRIES:
            if country in text_lower:
                result['correspondence_country'] = country.title()
                break

        # Detect if owner is resident
        if demised_address and correspondence_address:
            # Normalize and compare
            demised_norm = self._normalize_address(demised_address)
            corresp_norm = self._normalize_address(correspondence_address)

            if demised_norm == corresp_norm:
                result['is_resident_owner'] = True
            else:
                result['is_resident_owner'] = False

        # Check for non-resident indicators
        for indicator in self.NON_RESIDENT_INDICATORS:
            if indicator in text_lower:
                result['is_resident_owner'] = False
                break

        # Extract contact details near correspondence address
        if correspondence_address:
            # Get text around correspondence address
            addr_pos = text.find(correspondence_address)
            if addr_pos != -1:
                context = text[max(0, addr_pos - 200):min(len(text), addr_pos + 200)]

                # Extract email
                email_match = re.search(r'[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}', context)
                if email_match:
                    result['correspondence_email'] = email_match.group(0)

                # Extract phone
                phone_match = re.search(r'\+?\d[\d\s\-\(\)]{7,15}\d', context)
                if phone_match:
                    result['correspondence_phone'] = phone_match.group(0).strip()

        result['correspondence_address'] = correspondence_address

        return result

    def _extract_demised_address(self, text: str) -> Optional[Dict]:
        """Extract demised property address (the actual flat/unit address)"""
        # Look for patterns like "Flat 3, 50 Kensington Gardens Square, London W2 4BA"
        for pattern in self.DEMISED_PATTERNS:
            match = re.search(pattern, text, re.IGNORECASE)

            if match:
                unit_type = match.group(1).title()
                unit_num = match.group(2)
                unit_number = f"{unit_type} {unit_num}"

                # Try to extract full address after unit
                pos = match.end()
                context = text[pos:pos + 200]

                # Look for address with postcode
                addr_match = re.search(f'([^\\n]{{20,150}}?{self.UK_POSTCODE_PATTERN})', context)

                if addr_match:
                    full_address = unit_number + addr_match.group(1).strip()
                    full_address = self._clean_address(full_address)

                    # Extract postcode
                    postcode_match = re.search(self.UK_POSTCODE_PATTERN, full_address)
                    postcode = postcode_match.group(0) if postcode_match else None

                    return {
                        'unit_number': unit_number,
                        'full_address': full_address,
                        'postcode': postcode
                    }

        return None

    def _extract_all_addresses(self, text: str) -> List[str]:
        """Extract all addresses with postcodes from text"""
        addresses = []

        # Find all postcodes and extract surrounding context
        postcode_matches = re.finditer(self.UK_POSTCODE_PATTERN, text)

        for match in postcode_matches:
            postcode = match.group(0)
            end_pos = match.end()

            # Get text before postcode (up to 150 chars)
            start_pos = max(0, match.start() - 150)
            addr_text = text[start_pos:end_pos]

            # Clean up - take last line or last comma-separated part
            addr_parts = addr_text.split('\n')
            address = addr_parts[-1].strip()

            # Clean and validate
            address = self._clean_address(address)

            if len(address) > 20:  # Ensure substantial address
                addresses.append(address)

        return addresses

    def _extract_leaseholder_names(self, text: str) -> List[str]:
        """Extract leaseholder names from lease text"""
        names = []

        # Common patterns in leases
        patterns = [
            r'(?i)THE LESSEE[S]?:\s+([A-Z][A-Z\s]+?)(?:\s+(?:and|of|residing)\s+)',
            r'(?i)lessee[s]?[:\-\s]+([A-Z][a-z]+(?:\s+[A-Z][a-z]+)+?)(?:\s+(?:and|of)\s+)',
            r'(?i)tenant[s]?[:\-\s]+([A-Z][a-z]+(?:\s+[A-Z][a-z]+)+?)(?:\s+(?:and|of)\s+)',
            r'(?i)proprietor[:\-\s]+([A-Z][a-z]+(?:\s+[A-Z][a-z]+)+?)(?:\s+of\s+)',
        ]

        for pattern in patterns:
            matches = re.finditer(pattern, text)
            for match in matches:
                name = match.group(1).strip()
                name = self._clean_name(name)

                # Remove trailing "Of", "And" etc
                name = re.sub(r'\s+(Of|And|The)$', '', name, flags=re.IGNORECASE)

                if self._is_valid_name(name):
                    # Split on "and" for joint ownership
                    if ' and ' in name.lower():
                        parts = re.split(r'\s+and\s+', name, flags=re.IGNORECASE)
                        for part in parts:
                            clean_part = self._clean_name(part)
                            if self._is_valid_name(clean_part):
                                names.append(clean_part)
                    else:
                        names.append(name)

        return list(set(names))  # Deduplicate

    def _extract_names_from_line(self, line: str) -> List[str]:
        """Extract person/company names from a line of text"""
        names = []

        # Pattern: Capital letter followed by lowercase, 2+ words
        pattern = r'\b([A-Z][a-z]+(?:\s+[A-Z][a-z]+)+(?:\s+(?:Ltd|Limited|LLP|PLC))?)\b'
        matches = re.finditer(pattern, line)

        for match in matches:
            name = match.group(1).strip()
            if self._is_valid_name(name):
                names.append(name)

        return names

    def _extract_unit_from_filename(self, filename: str) -> Optional[str]:
        """Extract unit number from filename"""
        pattern = r'(?i)(flat|unit|apartment)\s*(\d+[A-Z]?)'
        match = re.search(pattern, filename)

        if match:
            return f"{match.group(1).title()} {match.group(2)}"

        return None

    def _extract_title_number(self, text: str) -> Optional[str]:
        """Extract Land Registry title number"""
        patterns = [
            r'(?i)title\s*(?:no|number)[:\-\s]+([A-Z]{2,4}\d{4,7})',
            r'\b([A-Z]{2,4}\d{4,7})\b'  # Generic pattern
        ]

        for pattern in patterns:
            match = re.search(pattern, text)
            if match:
                title = match.group(1)
                # Validate format (2-4 letters, 4-7 digits)
                if re.match(r'^[A-Z]{2,4}\d{4,7}$', title):
                    return title

        return None

    def _extract_tenure(self, text: str) -> Optional[str]:
        """Extract tenure type"""
        text_lower = text.lower()

        if 'share of freehold' in text_lower or 'share of the freehold' in text_lower:
            return 'Share of Freehold'
        elif 'underlease' in text_lower or 'under-lease' in text_lower:
            return 'Underlease'
        elif 'leasehold' in text_lower:
            return 'Leasehold'
        elif 'freehold' in text_lower:
            return 'Freehold'

        return None

    def _extract_apportionment(self, text: str) -> Optional[float]:
        """Extract apportionment percentage or ratio"""
        # Look for percentage
        percent_match = re.search(r'(\d+\.?\d*)\s*%', text)
        if percent_match:
            return float(percent_match.group(1))

        # Look for ratio like "12.45" or "1/80"
        ratio_match = re.search(r'(\d+\.?\d*)/(\d+)', text)
        if ratio_match:
            numerator = float(ratio_match.group(1))
            denominator = float(ratio_match.group(2))
            return round((numerator / denominator) * 100, 2)

        # Look for standalone decimal that might be percentage
        decimal_match = re.search(r'\b(\d{1,2}\.\d{2})\b', text)
        if decimal_match:
            value = float(decimal_match.group(1))
            if 0 < value < 100:  # Likely a percentage
                return value

        return None

    def _determine_ownership_type(self, names: List[str]) -> str:
        """Determine if ownership is Individual or Corporate"""
        if not names:
            return 'Unknown'

        for name in names:
            name_lower = name.lower()
            for indicator in self.CORPORATE_INDICATORS:
                if indicator in name_lower:
                    return 'Corporate'

        return 'Individual'

    def _clean_address(self, address: str) -> str:
        """Clean and normalize address string"""
        # Remove multiple spaces
        address = re.sub(r'\s+', ' ', address)

        # Remove leading/trailing punctuation
        address = address.strip(',;:- ')

        # Capitalize properly
        # (Keep as-is for now to preserve original formatting)

        return address

    def _clean_name(self, name: str) -> str:
        """Clean and normalize name string"""
        # Remove extra spaces
        name = re.sub(r'\s+', ' ', name)

        # Remove trailing punctuation
        name = name.strip(',;:- ')

        # Title case (but preserve all-caps company suffixes)
        parts = name.split()
        cleaned_parts = []

        for part in parts:
            if part.upper() in ['LTD', 'LIMITED', 'LLP', 'PLC', 'INC']:
                cleaned_parts.append(part.upper())
            else:
                cleaned_parts.append(part.title())

        return ' '.join(cleaned_parts)

    def _is_valid_name(self, name: str) -> bool:
        """Check if string looks like a valid person/company name"""
        if not name or len(name) < 3:
            return False

        # Must have at least 2 words (or be a company with Ltd etc)
        words = name.split()
        if len(words) < 2 and not any(ind in name.lower() for ind in self.CORPORATE_INDICATORS):
            return False

        # Must start with capital letter
        if not name[0].isupper():
            return False

        # Exclude common false positives
        false_positives = ['The Property', 'The Premises', 'The Building', 'The Flat']
        if name in false_positives:
            return False

        return True

    def _normalize_address(self, address: str) -> str:
        """Normalize address for comparison"""
        # Remove punctuation, lowercase, remove extra spaces
        normalized = re.sub(r'[^\w\s]', '', address.lower())
        normalized = re.sub(r'\s+', ' ', normalized)
        return normalized.strip()

    def _deduplicate_units(self, units: List[Dict]) -> List[Dict]:
        """Deduplicate and merge unit records"""
        # Group by unit_number
        units_by_number = defaultdict(list)

        for unit in units:
            unit_num = unit.get('unit_number')
            if unit_num:
                units_by_number[unit_num].append(unit)

        # Merge duplicates
        merged = []

        for unit_num, unit_list in units_by_number.items():
            if len(unit_list) == 1:
                merged.append(unit_list[0])
            else:
                # Merge multiple records for same unit
                merged_unit = self._merge_unit_records(unit_list)
                merged.append(merged_unit)

        return merged

    def _merge_unit_records(self, units: List[Dict]) -> Dict:
        """Merge multiple records for the same unit"""
        merged = {}

        for unit in units:
            for key, value in unit.items():
                if value is not None:
                    if key not in merged or merged[key] is None:
                        merged[key] = value
                    elif key == 'leaseholders':
                        # Merge lists
                        if isinstance(merged[key], list) and isinstance(value, list):
                            merged[key] = list(set(merged[key] + value))

        return merged


# Test function
if __name__ == '__main__':
    extractor = UnitsLeaseholdersExtractor()

    # Test data
    test_lease_text = """
    LEASE AGREEMENT

    Between THE LANDLORD and THE LESSEE:
    JOHN SMITH and MARY SMITH

    Of Flat 3, 50 Kensington Gardens Square, London W2 4BA

    Correspondence Address:
    14 Priory Road, Richmond, TW9 3AB

    Title Number: NGL123456

    Apportionment: 12.45%

    The property is held on leasehold terms.
    """

    test_doc = {
        'text': test_lease_text,
        'document_type': 'Lease',
        'file_name': 'Lease_Flat_3.pdf'
    }

    results = extractor.extract_units_from_documents([test_doc])

    print("Unit & Leaseholder Extraction Results:")
    print("=" * 60)
    for unit in results:
        for key, value in unit.items():
            print(f"{key}: {value}")
        print()
