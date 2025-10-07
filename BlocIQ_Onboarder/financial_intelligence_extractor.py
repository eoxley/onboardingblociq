"""
BlocIQ Onboarder - Financial & Compliance Intelligence Extractor
Automatically detects and extracts:
- Apportionments
- Budgets
- Insurance policies
- Fire door inspections
"""

import re
from datetime import datetime, timedelta
from typing import Dict, List, Optional, Tuple
import uuid


class FinancialIntelligenceExtractor:
    """Extract financial and compliance data from parsed documents"""

    def __init__(self, parsed_files: List[Dict], mapped_data: Dict):
        """
        Initialize extractor

        Args:
            parsed_files: List of parsed file dictionaries
            mapped_data: Mapped data with buildings, units, etc.
        """
        self.parsed_files = parsed_files
        self.mapped_data = mapped_data
        self.building_id = mapped_data.get('building', {}).get('id')

        # Build unit lookup map
        self.units_map = self._build_units_map()

        # Results
        self.apportionments = []
        self.budgets = []
        self.insurance = []
        self.fire_door_inspections = []
        self.alerts = []

    def _build_units_map(self) -> Dict:
        """Build lookup map for units by name/reference"""
        units_map = {}
        units = self.mapped_data.get('units', [])

        for unit in units:
            unit_id = unit.get('id')

            # Map by name
            if unit.get('name'):
                name = unit['name'].lower().strip()
                units_map[name] = unit_id

                # Also map variations
                # "Flat 1" -> "flat1", "flat 1", "1"
                variations = [
                    name.replace(' ', ''),
                    name.replace('flat', '').strip(),
                    name.replace('apartment', '').strip(),
                    name.replace('unit', '').strip()
                ]
                for var in variations:
                    if var:
                        units_map[var] = unit_id

            # Map by reference
            if unit.get('reference'):
                ref = unit['reference'].lower().strip()
                units_map[ref] = unit_id

        return units_map

    def extract_all(self) -> Dict:
        """
        Extract all financial and compliance data

        Returns:
            Dictionary with extracted data
        """
        print("  🔍 Extracting financial & compliance intelligence...")

        for parsed_file in self.parsed_files:
            file_name = parsed_file.get('file_name', '')
            file_ext = parsed_file.get('file_extension', '')
            text_content = parsed_file.get('text_content', '')

            # Skip if no content or if text_content is a list (already processed)
            if not text_content:
                continue

            # Convert list to string if needed
            if isinstance(text_content, list):
                text_content = ' '.join(str(item) for item in text_content if item)

            text_lower = str(text_content).lower()

            # Detect apportionments
            if self._is_apportionment_file(file_name, text_lower):
                self._extract_apportionments(parsed_file)

            # Detect budgets
            if self._is_budget_file(file_name, text_lower):
                self._extract_budget(parsed_file)

            # Detect insurance
            if self._is_insurance_file(file_name, text_lower):
                self._extract_insurance(parsed_file)

            # Detect fire door inspections
            if self._is_fire_door_inspection(file_name, text_lower):
                self._extract_fire_door_inspections(parsed_file)

        # Summary
        print(f"     ✅ Apportionments: {len(self.apportionments)}")
        print(f"     ✅ Budgets: {len(self.budgets)}")
        print(f"     ✅ Insurance policies: {len(self.insurance)}")
        print(f"     ✅ Fire door inspections: {len(self.fire_door_inspections)}")

        if self.alerts:
            print(f"     ⚠️  Alerts: {len(self.alerts)}")

        return {
            'apportionments': self.apportionments,
            'budgets': self.budgets,
            'insurance': self.insurance,
            'fire_door_inspections': self.fire_door_inspections,
            'alerts': self.alerts
        }

    # ============================================================
    # APPORTIONMENTS
    # ============================================================

    def _is_apportionment_file(self, file_name: str, text_lower: str) -> bool:
        """Check if file contains apportionment data"""
        keywords = ['apportionment', 'schedule', 'percentage', 'unit', 'flat']
        return any(kw in file_name.lower() for kw in keywords) or \
               any(kw in text_lower for kw in keywords)

    def _extract_apportionments(self, parsed_file: Dict):
        """Extract apportionment data from file"""
        text = parsed_file.get('text_content', '')
        file_name = parsed_file.get('file_name', '')

        # Convert list to string if needed
        if isinstance(text, list):
            text = ' '.join(str(item) for item in text if item)
        text = str(text)

        # Look for schedule name
        schedule_name = self._extract_schedule_name(text)

        # Look for percentage patterns
        # Format: "Flat 1    12.345%"
        pattern = r'(flat|apartment|unit)\s*(\d+[a-z]?)\s*[:\-\s]*(\d+\.?\d*)\s*%?'
        matches = re.findall(pattern, text.lower(), re.IGNORECASE)

        total_percentage = 0

        for match in matches:
            unit_type, unit_num, percentage = match

            # Try to match unit
            unit_search = f"{unit_type} {unit_num}".strip()
            unit_id = self._find_unit_id(unit_search)

            try:
                pct = float(percentage)
                total_percentage += pct

                apportionment = {
                    'id': str(uuid.uuid4()),
                    'unit_id': unit_id,
                    'building_id': self.building_id,
                    'schedule_name': schedule_name,
                    'percentage': pct,
                    'notes': f"Extracted from {file_name}"
                }

                self.apportionments.append(apportionment)

            except ValueError:
                continue

        # Check if total is not 100%
        if self.apportionments and abs(total_percentage - 100.0) > 0.1:
            self.alerts.append({
                'type': 'apportionment_total_mismatch',
                'message': f'Apportionment total is {total_percentage:.2f}%, expected 100%',
                'file': file_name
            })

    def _extract_schedule_name(self, text: str) -> Optional[str]:
        """Extract schedule name from text"""
        # Look for "Schedule A", "Schedule of Apportionment", etc.
        pattern = r'schedule\s+([A-Z0-9]+|of\s+\w+)'
        match = re.search(pattern, text, re.IGNORECASE)
        if match:
            return match.group(0).strip()
        return 'General Schedule'

    def _find_unit_id(self, unit_search: str) -> Optional[str]:
        """Find unit ID by name/reference"""
        unit_key = unit_search.lower().strip()

        # Try direct lookup
        if unit_key in self.units_map:
            return self.units_map[unit_key]

        # Try without spaces
        unit_key_no_space = unit_key.replace(' ', '')
        if unit_key_no_space in self.units_map:
            return self.units_map[unit_key_no_space]

        # Try just the number
        numbers = re.findall(r'\d+', unit_key)
        if numbers:
            if numbers[0] in self.units_map:
                return self.units_map[numbers[0]]

        return None

    # ============================================================
    # BUDGETS
    # ============================================================

    def _is_budget_file(self, file_name: str, text_lower: str) -> bool:
        """Check if file contains budget data"""
        keywords = ['budget', 'financial year', 'service charge', 'estimated expenditure']
        return any(kw in file_name.lower() for kw in keywords) or \
               any(kw in text_lower for kw in keywords)

    def _extract_budget(self, parsed_file: Dict):
        """Extract budget data from file"""
        text = parsed_file.get('text_content', '')
        file_name = parsed_file.get('file_name', '')
        storage_path = parsed_file.get('storage_path', '')

        # Convert list to string if needed
        if isinstance(text, list):
            text = ' '.join(str(item) for item in text if item)
        text = str(text)

        # Extract date range
        year_start, year_end = self._extract_budget_dates(text)

        # Extract total amount
        total = self._extract_budget_total(text)

        budget = {
            'id': str(uuid.uuid4()),
            'building_id': self.building_id,
            'year_start': year_start,
            'year_end': year_end,
            'total': total,
            'status': 'approved',
            'document_path': storage_path,
            'notes': f"Extracted from {file_name}"
        }

        self.budgets.append(budget)

    def _extract_budget_dates(self, text: str) -> Tuple[Optional[str], Optional[str]]:
        """Extract budget year start and end dates"""
        # Look for date ranges like "01/04/2025 – 31/03/2026"
        pattern = r'(\d{1,2}[\/\-]\d{1,2}[\/\-]\d{4})\s*[–\-to]+\s*(\d{1,2}[\/\-]\d{1,2}[\/\-]\d{4})'
        match = re.search(pattern, text)

        if match:
            start_str, end_str = match.groups()

            # Parse dates
            for fmt in ['%d/%m/%Y', '%d-%m-%Y', '%m/%d/%Y']:
                try:
                    start_date = datetime.strptime(start_str, fmt).date()
                    end_date = datetime.strptime(end_str, fmt).date()
                    return str(start_date), str(end_date)
                except ValueError:
                    continue

        # Default to current financial year
        today = datetime.now().date()
        if today.month >= 4:
            year_start = datetime(today.year, 4, 1).date()
            year_end = datetime(today.year + 1, 3, 31).date()
        else:
            year_start = datetime(today.year - 1, 4, 1).date()
            year_end = datetime(today.year, 3, 31).date()

        return str(year_start), str(year_end)

    def _extract_budget_total(self, text: str) -> Optional[float]:
        """Extract total budget amount"""
        # Look for "Total: £98,450" or "Total Expenditure £98450.00"
        patterns = [
            r'total[:\s]+£\s*([\d,]+\.?\d*)',
            r'£\s*([\d,]+\.?\d*)\s*total',
            r'estimated\s+expenditure[:\s]+£\s*([\d,]+\.?\d*)'
        ]

        for pattern in patterns:
            match = re.search(pattern, text.lower())
            if match:
                amount_str = match.group(1).replace(',', '')
                try:
                    return float(amount_str)
                except ValueError:
                    continue

        return None

    # ============================================================
    # INSURANCE
    # ============================================================

    def _is_insurance_file(self, file_name: str, text_lower: str) -> bool:
        """Check if file contains insurance data"""
        keywords = ['certificate', 'policy', 'insurance', 'insurer', 'expiry', 'premium']
        return any(kw in file_name.lower() for kw in keywords) or \
               any(kw in text_lower for kw in keywords)

    def _extract_insurance(self, parsed_file: Dict):
        """Extract insurance policy data from file"""
        text = parsed_file.get('text_content', '')
        file_name = parsed_file.get('file_name', '')
        storage_path = parsed_file.get('storage_path', '')

        # Convert list to string if needed
        if isinstance(text, list):
            text = ' '.join(str(item) for item in text if item)
        text = str(text)

        # Extract provider
        provider = self._extract_insurance_provider(text)

        # Extract policy number
        policy_number = self._extract_policy_number(text)

        # Extract expiry date
        expiry_date = self._extract_expiry_date(text)

        # Extract premium
        premium = self._extract_premium(text)

        insurance = {
            'id': str(uuid.uuid4()),
            'building_id': self.building_id,
            'provider': provider,
            'policy_number': policy_number,
            'expiry_date': expiry_date,
            'coverage_details': 'Building insurance',
            'premium': premium,
            'document_path': storage_path
        }

        self.insurance.append(insurance)

        # Check if expired
        if expiry_date:
            try:
                expiry = datetime.strptime(expiry_date, '%Y-%m-%d').date()
                if expiry < datetime.now().date():
                    self.alerts.append({
                        'type': 'insurance_expired',
                        'message': f'Insurance policy expired on {expiry_date}',
                        'provider': provider,
                        'policy_number': policy_number
                    })
            except ValueError:
                pass

    def _extract_insurance_provider(self, text: str) -> Optional[str]:
        """Extract insurance provider name"""
        # Look for "Insurer: St Giles Insurance"
        patterns = [
            r'insurer[:\s]+([A-Za-z\s]+)(?:limited|ltd|plc)?',
            r'provider[:\s]+([A-Za-z\s]+)(?:limited|ltd|plc)?',
            r'([A-Za-z\s]+)\s+insurance'
        ]

        for pattern in patterns:
            match = re.search(pattern, text, re.IGNORECASE)
            if match:
                provider = match.group(1).strip()
                if len(provider) > 3:  # Avoid short matches
                    return provider

        return 'Unknown Provider'

    def _extract_policy_number(self, text: str) -> Optional[str]:
        """Extract policy number"""
        # Look for "Policy No: SG-558920" or "Policy Number: ABC123456"
        pattern = r'policy\s+(?:no|number)[:\s]+([A-Z0-9\-]+)'
        match = re.search(pattern, text, re.IGNORECASE)
        if match:
            return match.group(1).strip()

        return None

    def _extract_expiry_date(self, text: str) -> Optional[str]:
        """Extract expiry date"""
        # Look for "Expiry: 01/10/2025" or "Valid until: 01/10/2025"
        patterns = [
            r'expiry[:\s]+(\d{1,2}[\/\-]\d{1,2}[\/\-]\d{4})',
            r'valid\s+until[:\s]+(\d{1,2}[\/\-]\d{1,2}[\/\-]\d{4})',
            r'expires[:\s]+(\d{1,2}[\/\-]\d{1,2}[\/\-]\d{4})'
        ]

        for pattern in patterns:
            match = re.search(pattern, text, re.IGNORECASE)
            if match:
                date_str = match.group(1)

                # Parse date
                for fmt in ['%d/%m/%Y', '%d-%m-%Y', '%m/%d/%Y']:
                    try:
                        date_obj = datetime.strptime(date_str, fmt).date()
                        return str(date_obj)
                    except ValueError:
                        continue

        return None

    def _extract_premium(self, text: str) -> Optional[float]:
        """Extract insurance premium amount"""
        # Look for "Premium: £5,000" or "Annual Premium £5000.00"
        patterns = [
            r'premium[:\s]+£\s*([\d,]+\.?\d*)',
            r'£\s*([\d,]+\.?\d*)\s*premium'
        ]

        for pattern in patterns:
            match = re.search(pattern, text.lower())
            if match:
                amount_str = match.group(1).replace(',', '')
                try:
                    return float(amount_str)
                except ValueError:
                    continue

        return None

    # ============================================================
    # FIRE DOOR INSPECTIONS
    # ============================================================

    def _is_fire_door_inspection(self, file_name: str, text_lower: str) -> bool:
        """Check if file contains fire door inspection data"""
        keywords = ['fire door', 'inspection', 'compliant', 'non-compliant', 'remedial']
        return any(kw in file_name.lower() for kw in keywords) or \
               any(kw in text_lower for kw in keywords)

    def _extract_fire_door_inspections(self, parsed_file: Dict):
        """Extract fire door inspection data from file"""
        text = parsed_file.get('text_content', '')
        file_name = parsed_file.get('file_name', '')
        storage_path = parsed_file.get('storage_path', '')

        # Convert list to string if needed
        if isinstance(text, list):
            text = ' '.join(str(item) for item in text if item)
        text = str(text)

        # Extract inspection date
        inspection_date = self._extract_inspection_date(text)

        # Look for individual inspections
        # Format: "Flat 2: Non-compliant" or "Core A: Compliant"
        pattern = r'(flat|apartment|unit|core|stair)\s*([A-Z0-9]+)[:\s]*(compliant|non-compliant|pass|fail|requires\s+remedial)'
        matches = re.findall(pattern, text, re.IGNORECASE)

        for match in matches:
            location_type, location_num, status_text = match
            location = f"{location_type.title()} {location_num}"

            # Determine status
            status = self._parse_inspection_status(status_text)

            # Try to match unit
            unit_id = None
            if location_type.lower() in ['flat', 'apartment', 'unit']:
                unit_id = self._find_unit_id(location)

            inspection = {
                'id': str(uuid.uuid4()),
                'building_id': self.building_id,
                'unit_id': unit_id,
                'location': location,
                'inspection_date': inspection_date,
                'status': status,
                'notes': f"Extracted from {file_name}",
                'document_path': storage_path
            }

            self.fire_door_inspections.append(inspection)

            # Alert for non-compliant
            if status == 'non-compliant':
                self.alerts.append({
                    'type': 'fire_door_non_compliant',
                    'message': f'Fire door at {location} is non-compliant',
                    'location': location,
                    'inspection_date': inspection_date
                })

    def _extract_inspection_date(self, text: str) -> Optional[str]:
        """Extract inspection date"""
        # Look for "Inspection Date: 10/06/2025"
        pattern = r'inspection\s+date[:\s]+(\d{1,2}[\/\-]\d{1,2}[\/\-]\d{4})'
        match = re.search(pattern, text, re.IGNORECASE)

        if match:
            date_str = match.group(1)

            # Parse date
            for fmt in ['%d/%m/%Y', '%d-%m-%Y', '%m/%d/%Y']:
                try:
                    date_obj = datetime.strptime(date_str, fmt).date()
                    return str(date_obj)
                except ValueError:
                    continue

        # Default to today
        return str(datetime.now().date())

    def _parse_inspection_status(self, status_text: str) -> str:
        """Parse inspection status from text"""
        status_lower = status_text.lower()

        if 'non-compliant' in status_lower or 'fail' in status_lower or 'remedial' in status_lower:
            return 'non-compliant'
        elif 'compliant' in status_lower or 'pass' in status_lower:
            return 'compliant'
        else:
            return 'unknown'
