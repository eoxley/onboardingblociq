"""
BlocIQ Onboarder - Major Works Extractor
Intelligently detects and extracts major works projects and their data
"""

import re
from typing import Dict, List, Optional
from datetime import datetime
import uuid


class MajorWorksExtractor:
    """Extracts major works projects from parsed documents"""

    def __init__(self):
        # Define major works indicators
        self.major_works_patterns = {
            'section_20': {
                'patterns': [
                    r'section\s*20',
                    r's20\s*notice',
                    r'consultation\s*notice',
                    r'notice\s*of\s*intention',
                    r'statement\s*of\s*estimates'
                ],
                'project_type': 'major_works'
            },
            'roof_works': {
                'patterns': [
                    r'roof\s*works',
                    r'roof\s*replacement',
                    r'roof\s*repair',
                    r're-roofing',
                    r'reroofing'
                ],
                'project_type': 'roof_works'
            },
            'external_decoration': {
                'patterns': [
                    r'external\s*decoration',
                    r'external\s*redecoration',
                    r'external\s*painting',
                    r'facade\s*works'
                ],
                'project_type': 'external_decoration'
            },
            'window_replacement': {
                'patterns': [
                    r'window\s*replacement',
                    r'window\s*renewal',
                    r'new\s*windows'
                ],
                'project_type': 'window_replacement'
            },
            'lift_replacement': {
                'patterns': [
                    r'lift\s*replacement',
                    r'lift\s*modernisation',
                    r'lift\s*refurbishment',
                    r'elevator\s*replacement'
                ],
                'project_type': 'lift_replacement'
            },
            'heating_works': {
                'patterns': [
                    r'heating\s*replacement',
                    r'boiler\s*replacement',
                    r'central\s*heating\s*works'
                ],
                'project_type': 'heating_replacement'
            },
            'fire_safety_works': {
                'patterns': [
                    r'fire\s*safety\s*works',
                    r'fire\s*door\s*replacement',
                    r'fire\s*stopping',
                    r'compartmentation'
                ],
                'project_type': 'fire_safety_works'
            },
            'cladding_works': {
                'patterns': [
                    r'cladding\s*works',
                    r'cladding\s*replacement',
                    r'external\s*wall\s*system',
                    r'ews\s*works'
                ],
                'project_type': 'cladding_works'
            }
        }

    def detect_major_works(self, parsed_files: List[Dict], building_id: str, user_id: str = None) -> List[Dict]:
        """
        Detect major works projects from all parsed files

        Args:
            parsed_files: List of parsed file dictionaries
            building_id: UUID of the building
            user_id: UUID of the user (optional)

        Returns:
            List of major works project dictionaries ready for SQL insertion
        """
        major_works_projects = []
        seen_projects = set()  # Track project names to avoid duplicates

        for file_data in parsed_files:
            project = self._analyze_file_for_major_works(file_data, building_id, user_id)

            if project:
                # Use project name + year as unique identifier
                project_key = f"{project.get('title', 'Unknown')}_{project.get('start_date', '')[:4]}"

                if project_key not in seen_projects:
                    major_works_projects.append(project)
                    seen_projects.add(project_key)

        return major_works_projects

    def _analyze_file_for_major_works(self, file_data: Dict, building_id: str, user_id: str = None) -> Optional[Dict]:
        """Analyze a single file to detect major works project"""

        file_name = file_data.get('file_name', '').lower()
        file_content = self._extract_text_content(file_data)

        # Try to match against known major works types
        for works_key, works_config in self.major_works_patterns.items():
            if self._matches_patterns(file_name, file_content, works_config['patterns']):
                # Found a match! Extract detailed data
                return self._create_major_works_project(
                    file_data,
                    works_config,
                    building_id,
                    user_id
                )

        return None

    def _matches_patterns(self, file_name: str, content: str, patterns: List[str]) -> bool:
        """Check if filename or content matches any of the patterns"""
        search_text = f"{file_name} {content}".lower()

        for pattern in patterns:
            if re.search(pattern, search_text, re.IGNORECASE):
                return True

        return False

    def _create_major_works_project(self, file_data: Dict, works_config: Dict, building_id: str, user_id: str = None) -> Dict:
        """Create a major works project record with extracted data"""

        file_content = self._extract_text_content(file_data)
        file_name = file_data.get('file_name', '')

        # Extract project details
        project_title = self._extract_project_title(file_name, file_content, works_config['project_type'])
        description = self._extract_description(file_content)

        # Extract dates
        start_date = self._extract_start_date(file_content, file_name)
        end_date = self._extract_end_date(file_content, file_name)
        notice_date = self._extract_notice_date(file_content)
        estimates_date = self._extract_estimates_date(file_content)
        contractor_date = self._extract_contractor_appointed_date(file_content)

        # Extract costs
        estimated_cost = self._extract_estimated_cost(file_content)
        actual_cost = self._extract_actual_cost(file_content)

        # Extract contractor
        contractor_name = self._extract_contractor_name(file_content)
        project_manager = self._extract_project_manager(file_content)

        # Determine status
        status = self._determine_project_status(file_content, start_date, end_date)

        # Calculate completion percentage
        completion = self._estimate_completion(status, start_date, end_date)

        project = {
            'id': str(uuid.uuid4()),
            'building_id': building_id,
            'user_id': user_id or '00000000-0000-0000-0000-000000000001',
            'title': project_title,
            'name': project_title,  # Some schemas use 'name' instead of 'title'
            'description': description,
            'project_type': works_config['project_type'],
            'status': status,
            'start_date': start_date,
            'end_date': end_date,
            'expected_completion_date': end_date,
            'estimated_cost': estimated_cost,
            'actual_cost': actual_cost,
            'contractor_name': contractor_name,
            'project_manager': project_manager,
            'completion_percentage': completion,
            'notice_of_intention_date': notice_date,
            'statement_of_estimates_date': estimates_date,
            'contractor_appointed_date': contractor_date,
            'is_active': True,
            'created_at': datetime.now().isoformat(),
            'updated_at': datetime.now().isoformat(),
            'notes': f'Imported from: {file_name}'
        }

        return project

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

        return ' '.join(content_parts)[:10000]  # Limit to first 10000 chars

    def _extract_project_title(self, filename: str, content: str, project_type: str) -> str:
        """Extract or generate project title"""

        # Try to extract from filename first
        title_from_filename = re.sub(r'\.(pdf|xlsx|docx|doc)$', '', filename, flags=re.IGNORECASE)
        title_from_filename = re.sub(r'[_-]', ' ', title_from_filename)

        # If filename is descriptive enough, use it
        if len(title_from_filename) > 10:
            return title_from_filename.title()

        # Try to extract from content
        title_patterns = [
            r'(?:project|works)[:\s]*([A-Z][A-Za-z\s-]+)',
            r'(?:subject|re)[:\s]*([A-Z][A-Za-z\s-]+)'
        ]

        for pattern in title_patterns:
            match = re.search(pattern, content)
            if match:
                title = match.group(1).strip()
                if len(title) > 10 and len(title) < 100:
                    return title

        # Fallback: Generate from project type
        type_to_title = {
            'major_works': 'Major Works Project',
            'roof_works': 'Roof Works',
            'external_decoration': 'External Redecoration',
            'window_replacement': 'Window Replacement',
            'lift_replacement': 'Lift Replacement',
            'heating_replacement': 'Heating System Replacement',
            'fire_safety_works': 'Fire Safety Works',
            'cladding_works': 'Cladding Works'
        }

        return type_to_title.get(project_type, 'Major Works Project')

    def _extract_description(self, content: str) -> Optional[str]:
        """Extract project description"""

        # Look for description or scope sections
        desc_patterns = [
            r'(?:description|scope|summary)[:\s]*([A-Za-z0-9\s,.-]{50,500})',
            r'(?:works\s*to\s*be\s*carried\s*out)[:\s]*([A-Za-z0-9\s,.-]{50,500})'
        ]

        for pattern in desc_patterns:
            match = re.search(pattern, content, re.IGNORECASE | re.DOTALL)
            if match:
                desc = match.group(1).strip()
                # Clean up
                desc = re.sub(r'\s+', ' ', desc)
                return desc[:500]  # Limit length

        return None

    def _extract_start_date(self, content: str, filename: str) -> Optional[str]:
        """Extract project start date"""

        date_patterns = [
            r'(?:start\s*date|commencement\s*date|commenced)[:\s]*(\d{1,2}[/-]\d{1,2}[/-]\d{2,4})',
            r'(?:works\s*commenced|work\s*started)[:\s]*(\d{1,2}[/-]\d{1,2}[/-]\d{2,4})'
        ]

        for pattern in date_patterns:
            match = re.search(pattern, content, re.IGNORECASE)
            if match:
                return self._normalize_date(match.group(1))

        # Try to extract year from filename
        year_match = re.search(r'(20\d{2})', filename)
        if year_match:
            year = year_match.group(1)
            return f"{year}-01-01"  # Use start of year as default

        return None

    def _extract_end_date(self, content: str, filename: str) -> Optional[str]:
        """Extract project end/completion date"""

        date_patterns = [
            r'(?:completion\s*date|end\s*date|finished)[:\s]*(\d{1,2}[/-]\d{1,2}[/-]\d{2,4})',
            r'(?:expected\s*completion|due\s*to\s*complete)[:\s]*(\d{1,2}[/-]\d{1,2}[/-]\d{2,4})'
        ]

        for pattern in date_patterns:
            match = re.search(pattern, content, re.IGNORECASE)
            if match:
                return self._normalize_date(match.group(1))

        return None

    def _extract_notice_date(self, content: str) -> Optional[str]:
        """Extract Section 20 Notice of Intention date"""

        patterns = [
            r'(?:notice\s*of\s*intention)[:\s]*(\d{1,2}[/-]\d{1,2}[/-]\d{2,4})',
            r'(?:noi\s*date)[:\s]*(\d{1,2}[/-]\d{1,2}[/-]\d{2,4})'
        ]

        for pattern in patterns:
            match = re.search(pattern, content, re.IGNORECASE)
            if match:
                return self._normalize_date(match.group(1))

        return None

    def _extract_estimates_date(self, content: str) -> Optional[str]:
        """Extract Section 20 Statement of Estimates date"""

        patterns = [
            r'(?:statement\s*of\s*estimates)[:\s]*(\d{1,2}[/-]\d{1,2}[/-]\d{2,4})',
            r'(?:soe\s*date)[:\s]*(\d{1,2}[/-]\d{1,2}[/-]\d{2,4})'
        ]

        for pattern in patterns:
            match = re.search(pattern, content, re.IGNORECASE)
            if match:
                return self._normalize_date(match.group(1))

        return None

    def _extract_contractor_appointed_date(self, content: str) -> Optional[str]:
        """Extract contractor appointment date"""

        patterns = [
            r'(?:contractor\s*appointed)[:\s]*(\d{1,2}[/-]\d{1,2}[/-]\d{2,4})',
            r'(?:contract\s*awarded)[:\s]*(\d{1,2}[/-]\d{1,2}[/-]\d{2,4})'
        ]

        for pattern in patterns:
            match = re.search(pattern, content, re.IGNORECASE)
            if match:
                return self._normalize_date(match.group(1))

        return None

    def _extract_estimated_cost(self, content: str) -> Optional[float]:
        """Extract estimated project cost"""

        cost_patterns = [
            r'(?:estimated\s*cost|budget|total\s*cost)[:\s]*£?([\d,]+\.?\d*)',
            r'(?:contract\s*sum)[:\s]*£?([\d,]+\.?\d*)'
        ]

        for pattern in cost_patterns:
            match = re.search(pattern, content, re.IGNORECASE)
            if match:
                cost_str = match.group(1).replace(',', '')
                try:
                    return float(cost_str)
                except ValueError:
                    continue

        return None

    def _extract_actual_cost(self, content: str) -> Optional[float]:
        """Extract actual project cost"""

        cost_patterns = [
            r'(?:actual\s*cost|final\s*cost|total\s*spend)[:\s]*£?([\d,]+\.?\d*)',
            r'(?:final\s*account)[:\s]*£?([\d,]+\.?\d*)'
        ]

        for pattern in cost_patterns:
            match = re.search(pattern, content, re.IGNORECASE)
            if match:
                cost_str = match.group(1).replace(',', '')
                try:
                    return float(cost_str)
                except ValueError:
                    continue

        return None

    def _extract_contractor_name(self, content: str) -> Optional[str]:
        """Extract contractor name"""

        contractor_patterns = [
            r'(?:contractor|appointed\s*contractor)[:\s]*([A-Z][A-Za-z\s&]+(?:Ltd|Limited|LLP))',
            r'(?:carried\s*out\s*by|undertaken\s*by)[:\s]*([A-Z][A-Za-z\s&]+(?:Ltd|Limited|LLP))'
        ]

        for pattern in contractor_patterns:
            match = re.search(pattern, content)
            if match:
                contractor = match.group(1).strip()
                if len(contractor) > 5:
                    return contractor

        return None

    def _extract_project_manager(self, content: str) -> Optional[str]:
        """Extract project manager name"""

        pm_patterns = [
            r'(?:project\s*manager|pm)[:\s]*([A-Z][a-z]+\s+[A-Z][a-z]+)',
            r'(?:managed\s*by)[:\s]*([A-Z][a-z]+\s+[A-Z][a-z]+)'
        ]

        for pattern in pm_patterns:
            match = re.search(pattern, content)
            if match:
                return match.group(1).strip()

        return None

    def _determine_project_status(self, content: str, start_date: Optional[str], end_date: Optional[str]) -> str:
        """Determine project status"""

        # Check for explicit status mentions
        if re.search(r'completed|finished|final\s*account', content, re.IGNORECASE):
            return 'completed'

        if re.search(r'in\s*progress|ongoing|current', content, re.IGNORECASE):
            return 'works_in_progress'

        # Infer from dates
        if end_date:
            try:
                end = datetime.fromisoformat(end_date).date()
                if end < datetime.now().date():
                    return 'completed'
            except:
                pass

        if start_date:
            try:
                start = datetime.fromisoformat(start_date).date()
                if start > datetime.now().date():
                    return 'planning'
                else:
                    return 'works_in_progress'
            except:
                pass

        return 'notice_of_intention'  # Default for Section 20 docs

    def _estimate_completion(self, status: str, start_date: Optional[str], end_date: Optional[str]) -> int:
        """Estimate completion percentage"""

        if status == 'completed':
            return 100

        if status in ['planning', 'notice_of_intention', 'statement_of_estimates']:
            return 0

        if status == 'contractor_appointed':
            return 10

        # Try to calculate from dates
        if start_date and end_date:
            try:
                start = datetime.fromisoformat(start_date).date()
                end = datetime.fromisoformat(end_date).date()
                today = datetime.now().date()

                if today >= end:
                    return 100

                total_days = (end - start).days
                elapsed_days = (today - start).days

                if total_days > 0:
                    percentage = int((elapsed_days / total_days) * 100)
                    return max(0, min(100, percentage))
            except:
                pass

        return 50  # Default for in-progress

    def _normalize_date(self, date_string: str) -> Optional[str]:
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
