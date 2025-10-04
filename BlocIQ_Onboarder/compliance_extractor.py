"""
BlocIQ Onboarder - Compliance Asset Extractor
Intelligently detects and extracts compliance-related documents and their data
"""

import re
from typing import Dict, List, Optional, Tuple
from datetime import datetime, timedelta
import uuid


class ComplianceAssetExtractor:
    """Extracts compliance assets from parsed documents using industry knowledge"""

    def __init__(self):
        # Define compliance asset types based on BlocIQ frontend schema
        self.asset_patterns = {
            'fire_risk_assessment': {
                'patterns': [
                    r'fire\s*risk\s*assessment',
                    r'\bfra\b',
                    r'fire\s*safety\s*assessment',
                    r'fire\s*risk\s*appraisal'
                ],
                'asset_type': 'fire_risk_assessment',
                'asset_name': 'Fire Risk Assessment (FRA)',
                'category': 'fire_safety',
                'inspection_frequency': 'annual',
                'frequency_months': 12,
                'is_required': True
            },
            'electrical_installation_report': {
                'patterns': [
                    r'\beicr\b',
                    r'electrical\s*installation\s*condition\s*report',
                    r'electrical\s*inspection',
                    r'periodic\s*inspection'
                ],
                'asset_type': 'electrical_installation_report',
                'asset_name': 'Electrical Installation Condition Report (EICR)',
                'category': 'electrical',
                'inspection_frequency': 'quinquennial',
                'frequency_months': 60,
                'is_required': True
            },
            'gas_safety_certificate': {
                'patterns': [
                    r'gas\s*safety\s*certificate',
                    r'gas\s*safety\s*record',
                    r'landlord\s*gas\s*safety',
                    r'\blgsr\b'
                ],
                'asset_type': 'gas_safety_certificate',
                'asset_name': 'Gas Safety Certificate',
                'category': 'gas',
                'inspection_frequency': 'annual',
                'frequency_months': 12,
                'is_required': True
            },
            'asbestos_survey': {
                'patterns': [
                    r'asbestos\s*survey',
                    r'asbestos\s*management\s*survey',
                    r'asbestos\s*refurbishment',
                    r'asbestos\s*register'
                ],
                'asset_type': 'asbestos_survey',
                'asset_name': 'Asbestos Management Survey',
                'category': 'environmental',
                'inspection_frequency': 'annual',
                'frequency_months': 12,
                'is_required': True
            },
            'legionella_risk_assessment': {
                'patterns': [
                    r'legionella\s*risk\s*assessment',
                    r'legionella\s*control',
                    r'water\s*hygiene',
                    r'l8\s*assessment'
                ],
                'asset_type': 'legionella_assessment',
                'asset_name': 'Legionella Risk Assessment',
                'category': 'health_safety',
                'inspection_frequency': 'biennial',
                'frequency_months': 24,
                'is_required': True
            },
            'lift_inspection': {
                'patterns': [
                    r'lift\s*inspection',
                    r'elevator\s*inspection',
                    r'lift\s*thorough\s*examination',
                    r'loler\s*inspection'
                ],
                'asset_type': 'lift_inspection',
                'asset_name': 'Lift Inspection (LOLER)',
                'category': 'structural',
                'inspection_frequency': 'biannual',
                'frequency_months': 6,
                'is_required': False
            },
            'fire_alarm_certificate': {
                'patterns': [
                    r'fire\s*alarm\s*certificate',
                    r'fire\s*alarm\s*test',
                    r'fire\s*detection\s*system',
                    r'bs\s*5839'
                ],
                'asset_type': 'fire_alarm_system',
                'asset_name': 'Fire Alarm System Maintenance',
                'category': 'fire_safety',
                'inspection_frequency': 'quarterly',
                'frequency_months': 3,
                'is_required': True
            },
            'emergency_lighting': {
                'patterns': [
                    r'emergency\s*lighting',
                    r'emergency\s*light\s*test',
                    r'bs\s*5266'
                ],
                'asset_type': 'emergency_lighting',
                'asset_name': 'Emergency Lighting Testing',
                'category': 'fire_safety',
                'inspection_frequency': 'annual',
                'frequency_months': 12,
                'is_required': True
            },
            'fire_extinguisher': {
                'patterns': [
                    r'fire\s*extinguisher',
                    r'portable\s*fire\s*equipment',
                    r'fire\s*fighting\s*equipment'
                ],
                'asset_type': 'fire_extinguisher_service',
                'asset_name': 'Fire Extinguisher Servicing',
                'category': 'fire_safety',
                'inspection_frequency': 'annual',
                'frequency_months': 12,
                'is_required': True
            },
            'pat_testing': {
                'patterns': [
                    r'\bpat\b',
                    r'portable\s*appliance\s*test',
                    r'electrical\s*appliance\s*test'
                ],
                'asset_type': 'pat_testing',
                'asset_name': 'Portable Appliance Testing (PAT)',
                'category': 'electrical',
                'inspection_frequency': 'annual',
                'frequency_months': 12,
                'is_required': False
            },
            'building_insurance': {
                'patterns': [
                    r'building\s*insurance',
                    r'property\s*insurance',
                    r'insurance\s*policy',
                    r'insurance\s*schedule'
                ],
                'asset_type': 'building_insurance',
                'asset_name': 'Building Insurance',
                'category': 'other',
                'inspection_frequency': 'annual',
                'frequency_months': 12,
                'is_required': True
            },
            'epc': {
                'patterns': [
                    r'\bepc\b',
                    r'energy\s*performance\s*certificate',
                    r'energy\s*rating'
                ],
                'asset_type': 'energy_performance_certificate',
                'asset_name': 'Energy Performance Certificate (EPC)',
                'category': 'environmental',
                'inspection_frequency': 'one_time',
                'frequency_months': 120,
                'is_required': False
            }
        }

    def detect_compliance_assets(self, parsed_files: List[Dict], building_id: str, user_id: str = None) -> Tuple[List[Dict], List[Dict]]:
        """
        Detect compliance assets AND inspections from all parsed files

        Args:
            parsed_files: List of parsed file dictionaries
            building_id: UUID of the building
            user_id: UUID of the user (optional, will use placeholder if not provided)

        Returns:
            Tuple of (compliance_assets, compliance_inspections) - both as lists of dicts ready for SQL
        """
        compliance_assets = []
        compliance_inspections = []

        for file_data in parsed_files:
            asset, inspection = self._analyze_file_for_compliance(file_data, building_id, user_id)
            if asset:
                compliance_assets.append(asset)
            if inspection:
                compliance_inspections.append(inspection)

        return compliance_assets, compliance_inspections

    def _analyze_file_for_compliance(self, file_data: Dict, building_id: str, user_id: str = None) -> Tuple[Optional[Dict], Optional[Dict]]:
        """Analyze a single file to detect compliance asset type and extract data

        Returns:
            Tuple of (asset, inspection) - both optional dicts
        """

        file_name = file_data.get('file_name', '').lower()
        file_content = self._extract_text_content(file_data)

        # Try to match against known compliance asset types
        for asset_key, asset_config in self.asset_patterns.items():
            if self._matches_patterns(file_name, file_content, asset_config['patterns']):
                # Found a match! Extract detailed data
                asset = self._create_compliance_asset(
                    file_data,
                    asset_config,
                    building_id,
                    user_id
                )

                # Also create inspection record with findings/actions
                inspection = self._create_compliance_inspection(
                    file_data,
                    asset,
                    building_id,
                    user_id
                )

                return asset, inspection

        return None, None

    def _matches_patterns(self, file_name: str, content: str, patterns: List[str]) -> bool:
        """Check if filename or content matches any of the patterns"""
        search_text = f"{file_name} {content}".lower()

        for pattern in patterns:
            if re.search(pattern, search_text, re.IGNORECASE):
                return True

        return False

    def _create_compliance_asset(self, file_data: Dict, asset_config: Dict, building_id: str, user_id: str = None) -> Dict:
        """Create a compliance asset record with extracted data"""

        file_content = self._extract_text_content(file_data)
        file_name = file_data.get('file_name', '')

        # Extract dates
        inspection_date = self._extract_inspection_date(file_content, file_name)
        expiry_date = self._extract_expiry_date(file_content, file_name)

        # Extract inspector/contractor details
        inspector_name, inspector_company = self._extract_inspector_details(file_content)

        # Calculate next due date
        next_due_date = self._calculate_next_due_date(inspection_date, expiry_date, asset_config['frequency_months'])

        # Determine status
        status = self._determine_status(next_due_date)

        # Extract certificate number
        cert_number = self._extract_certificate_number(file_content)

        # BlocIQ V2 Schema - compliance_assets table (minimal schema)
        # Convert frequency_months to PostgreSQL interval format
        frequency_interval = f"{asset_config['frequency_months']} months" if asset_config.get('frequency_months') else None

        asset = {
            'id': str(uuid.uuid4()),
            'building_id': building_id,  # REQUIRED - NOT NULL
            'asset_name': asset_config['asset_name'],  # REQUIRED
            'asset_type': asset_config['asset_type'],  # REQUIRED
            'inspection_frequency': frequency_interval,  # interval type
            'description': f"Imported from: {file_name}"
        }

        # Store certificate reference for linking
        if cert_number:
            asset['compliance_reference'] = cert_number

        return asset

    def _extract_text_content(self, file_data: Dict) -> str:
        """Extract all text content from parsed file data"""
        content_parts = []

        if 'data' in file_data:
            data = file_data['data']

            # Handle Excel files (dict of sheets)
            if isinstance(data, dict):
                for sheet_name, sheet_data in data.items():
                    if isinstance(sheet_data, dict) and 'raw_data' in sheet_data:
                        for row in sheet_data['raw_data']:
                            if isinstance(row, (list, dict)):
                                content_parts.append(str(row))

            # Handle PDF/Word files (text)
            elif isinstance(data, str):
                content_parts.append(data)

        return ' '.join(content_parts)[:5000]  # Limit to first 5000 chars for performance

    def _extract_inspection_date(self, content: str, filename: str) -> Optional[str]:
        """Extract inspection/issue date from content"""

        # Common date field labels
        date_patterns = [
            r'(?:inspection\s*date|date\s*of\s*inspection|inspected\s*on|survey\s*date)[:\s]*(\d{1,2}[/-]\d{1,2}[/-]\d{2,4})',
            r'(?:issue\s*date|date\s*issued|issued)[:\s]*(\d{1,2}[/-]\d{1,2}[/-]\d{2,4})',
            r'(?:test\s*date|date\s*of\s*test)[:\s]*(\d{1,2}[/-]\d{1,2}[/-]\d{2,4})',
            r'(?:certificate\s*date)[:\s]*(\d{1,2}[/-]\d{1,2}[/-]\d{2,4})'
        ]

        # Try to extract from content first
        for pattern in date_patterns:
            match = re.search(pattern, content, re.IGNORECASE)
            if match:
                return self._normalize_date(match.group(1))

        # Try to extract year from filename
        year_match = re.search(r'(20\d{2})', filename)
        if year_match:
            year = year_match.group(1)
            # Use mid-year as default
            return f"{year}-06-01"

        return None

    def _extract_expiry_date(self, content: str, filename: str) -> Optional[str]:
        """Extract expiry/next due date from content"""

        expiry_patterns = [
            r'(?:expiry\s*date|expires\s*on|valid\s*until)[:\s]*(\d{1,2}[/-]\d{1,2}[/-]\d{2,4})',
            r'(?:next\s*due|due\s*date|next\s*inspection)[:\s]*(\d{1,2}[/-]\d{1,2}[/-]\d{2,4})',
            r'(?:valid\s*to|certificate\s*valid\s*to)[:\s]*(\d{1,2}[/-]\d{1,2}[/-]\d{2,4})'
        ]

        for pattern in expiry_patterns:
            match = re.search(pattern, content, re.IGNORECASE)
            if match:
                return self._normalize_date(match.group(1))

        return None

    def _extract_inspector_details(self, content: str) -> Tuple[Optional[str], Optional[str]]:
        """Extract inspector name and company"""

        inspector_name = None
        inspector_company = None

        # Try to extract inspector name
        name_patterns = [
            r'(?:inspector|surveyor|engineer)[:\s]*([A-Z][a-z]+\s+[A-Z][a-z]+)',
            r'(?:carried\s*out\s*by|inspected\s*by)[:\s]*([A-Z][a-z]+\s+[A-Z][a-z]+)',
            r'(?:name)[:\s]*([A-Z][a-z]+\s+[A-Z][a-z]+)'
        ]

        for pattern in name_patterns:
            match = re.search(pattern, content)
            if match:
                inspector_name = match.group(1).strip()
                break

        # Try to extract company
        company_patterns = [
            r'(?:company|contractor|firm)[:\s]*([A-Z][A-Za-z\s&]+(?:Ltd|Limited|LLP|plc))',
            r'([A-Z][A-Za-z\s&]+(?:Ltd|Limited|LLP|plc))'
        ]

        for pattern in company_patterns:
            match = re.search(pattern, content)
            if match:
                company = match.group(1).strip()
                # Exclude common false positives
                if len(company) > 5 and company not in ['Building Ltd', 'Property Limited']:
                    inspector_company = company
                    break

        return inspector_name, inspector_company

    def _extract_certificate_number(self, content: str) -> Optional[str]:
        """Extract certificate/reference number"""

        cert_patterns = [
            r'(?:certificate\s*number|cert\s*no|reference)[:\s]*([A-Z0-9/-]+)',
            r'(?:report\s*number|report\s*ref)[:\s]*([A-Z0-9/-]+)'
        ]

        for pattern in cert_patterns:
            match = re.search(pattern, content, re.IGNORECASE)
            if match:
                cert_num = match.group(1).strip()
                if len(cert_num) >= 4:  # Reasonable length check
                    return cert_num

        return None

    def _normalize_date(self, date_string: str) -> str:
        """Normalize date string to ISO format YYYY-MM-DD"""

        # Try common UK formats: DD/MM/YYYY, DD-MM-YYYY
        for separator in ['/', '-']:
            pattern = f'(\\d{{1,2}}){separator}(\\d{{1,2}}){separator}(\\d{{2,4}})'
            match = re.match(pattern, date_string)
            if match:
                day, month, year = match.groups()

                # Handle 2-digit years
                if len(year) == 2:
                    year = f"20{year}"

                try:
                    # Validate and format
                    date_obj = datetime(int(year), int(month), int(day))
                    return date_obj.date().isoformat()
                except ValueError:
                    continue

        return None

    def _calculate_next_due_date(self, inspection_date: Optional[str], expiry_date: Optional[str], frequency_months: int) -> Optional[str]:
        """Calculate next due date based on inspection date and frequency"""

        # If we have an explicit expiry date, use it
        if expiry_date:
            return expiry_date

        # Otherwise calculate from inspection date
        if inspection_date:
            try:
                last_date = datetime.fromisoformat(inspection_date)
                next_date = last_date + timedelta(days=frequency_months * 30)  # Approximate
                return next_date.date().isoformat()
            except:
                pass

        return None

    def _determine_status(self, next_due_date: Optional[str]) -> str:
        """Determine compliance status based on next due date"""

        if not next_due_date:
            return 'pending'

        try:
            due_date = datetime.fromisoformat(next_due_date).date()
            today = datetime.now().date()
            days_until_due = (due_date - today).days

            if days_until_due < 0:
                return 'overdue'
            elif days_until_due <= 30:
                return 'due_soon'
            else:
                return 'compliant'
        except:
            return 'pending'

    def _create_compliance_inspection(self, file_data: Dict, asset: Dict, building_id: str, user_id: str = None) -> Optional[Dict]:
        """
        Create a compliance inspection record with findings, actions, and recommendations
        This captures the DETAIL of what was found in the inspection report
        """

        file_content = self._extract_text_content(file_data)
        file_name = file_data.get('file_name', '')

        # Extract inspection date (same as asset)
        inspection_date = asset.get('last_inspection_date')
        if not inspection_date:
            return None  # Can't create inspection without a date

        # Extract result/outcome
        result, compliant = self._extract_inspection_result(file_content)

        # Extract findings, actions, and recommendations
        findings = self._extract_findings(file_content)
        actions_required = self._extract_actions_required(file_content)
        recommendations = self._extract_recommendations(file_content)

        # Extract score if present (e.g., Fire Risk Assessment ratings)
        score = self._extract_risk_score(file_content)

        # Extract certificate details
        cert_number = self._extract_certificate_number(file_content)

        # Determine if follow-up is required
        follow_up_required = self._determine_follow_up_required(result, actions_required)

        inspection = {
            'id': str(uuid.uuid4()),
            'compliance_asset_id': asset['id'],
            'building_id': building_id,
            'user_id': user_id or '00000000-0000-0000-0000-000000000001',
            'inspection_date': inspection_date,
            'inspection_type': 'routine',
            'result': result,
            'compliant': compliant,
            'score': score,
            'inspector_name': asset.get('inspector_name'),
            'inspector_company': asset.get('inspector_company'),
            'certificate_number': cert_number,
            'certificate_url': None,  # Will be set when uploaded
            'findings': findings,
            'recommendations': recommendations,
            'actions_required': actions_required,
            'follow_up_required': follow_up_required,
            'next_inspection_due': asset.get('next_due_date'),
            'created_at': datetime.now().isoformat(),
            'updated_at': datetime.now().isoformat(),
            'compliance_notes': f'Imported from: {file_name}'
        }

        return inspection

    def _extract_inspection_result(self, content: str) -> Tuple[str, bool]:
        """Extract inspection result (pass/fail/advisory) and compliance status"""

        content_lower = content.lower()

        # Look for fail indicators
        if re.search(r'\bfail(?:ed)?\b|\bun(?:satisfactory)\b|\bnon[- ]compliant\b', content_lower):
            return 'fail', False

        # Look for pass indicators
        if re.search(r'\bpass(?:ed)?\b|\bsatisfactory\b|\bcompliant\b', content_lower):
            return 'pass', True

        # Look for advisory/observations
        if re.search(r'\badvisory\b|\bobservations?\b|\brecommendations?\b', content_lower):
            return 'advisory', True

        # Default to pass if we found the certificate
        return 'pass', True

    def _extract_findings(self, content: str) -> Optional[str]:
        """Extract findings/observations from inspection report"""

        findings_sections = []

        # Look for findings/observations sections
        patterns = [
            r'(?:findings?|observations?)[:\s]*([^\n]{50,1000})',
            r'(?:issues? (?:identified|found))[:\s]*([^\n]{50,1000})',
            r'(?:defects?)[:\s]*([^\n]{50,1000})'
        ]

        for pattern in patterns:
            matches = re.findall(pattern, content, re.IGNORECASE | re.DOTALL)
            for match in matches:
                cleaned = re.sub(r'\s+', ' ', match.strip())
                if len(cleaned) > 20:
                    findings_sections.append(cleaned[:500])

        if findings_sections:
            return ' | '.join(findings_sections[:3])  # Limit to first 3 findings

        return None

    def _extract_actions_required(self, content: str) -> Optional[str]:
        """Extract required actions from inspection report"""

        actions_sections = []

        # Look for actions/remedial work sections
        patterns = [
            r'(?:actions? required|remedial (?:work|actions?))[:\s]*([^\n]{50,1000})',
            r'(?:recommendations?)[:\s]*([^\n]{50,1000})',
            r'(?:must be|should be|needs? to be)[:\s]*([^\n]{50,500})'
        ]

        for pattern in patterns:
            matches = re.findall(pattern, content, re.IGNORECASE | re.DOTALL)
            for match in matches:
                cleaned = re.sub(r'\s+', ' ', match.strip())
                if len(cleaned) > 20:
                    actions_sections.append(cleaned[:500])

        if actions_sections:
            return ' | '.join(actions_sections[:5])  # Limit to first 5 actions

        return None

    def _extract_recommendations(self, content: str) -> Optional[str]:
        """Extract recommendations from inspection report"""

        recommendations = []

        # Look for recommendation sections
        patterns = [
            r'(?:we recommend|it is recommended)[:\s]*([^\n]{50,500})',
            r'(?:suggestion|advisory)[:\s]*([^\n]{50,500})'
        ]

        for pattern in patterns:
            matches = re.findall(pattern, content, re.IGNORECASE | re.DOTALL)
            for match in matches:
                cleaned = re.sub(r'\s+', ' ', match.strip())
                if len(cleaned) > 20:
                    recommendations.append(cleaned[:500])

        if recommendations:
            return ' | '.join(recommendations[:3])

        return None

    def _extract_risk_score(self, content: str) -> Optional[int]:
        """Extract risk score/rating (e.g., for Fire Risk Assessments)"""

        # Look for numerical risk ratings
        patterns = [
            r'(?:risk\s*rating|overall\s*rating|score)[:\s]*(\d+)',
            r'(?:rated)[:\s]*(\d+)\s*(?:out of|/)\s*(\d+)'
        ]

        for pattern in patterns:
            match = re.search(pattern, content, re.IGNORECASE)
            if match:
                try:
                    return int(match.group(1))
                except:
                    continue

        return None

    def _determine_follow_up_required(self, result: str, actions: Optional[str]) -> bool:
        """Determine if follow-up is required based on result and actions"""

        if result == 'fail':
            return True

        if actions and len(actions) > 50:  # Substantial actions required
            return True

        return False
