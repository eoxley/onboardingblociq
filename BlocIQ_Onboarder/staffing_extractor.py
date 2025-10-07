"""
BlocIQ Onboarder - Staffing Data Extractor
Automatically detects and extracts building staff information from documents
"""

import re
from datetime import datetime
from typing import Dict, List, Optional, Tuple
import uuid


class StaffingExtractor:
    """Extract building staff data from parsed documents"""

    # Staff role keywords for detection
    ROLE_KEYWORDS = {
        'caretaker': ['caretaker', 'estate manager', 'building manager', 'site manager'],
        'concierge': ['concierge', 'receptionist', 'front desk'],
        'cleaner': ['cleaner', 'cleaning', 'housekeeper', 'housekeeping'],
        'porter': ['porter', 'doorman', 'door staff'],
        'security': ['security', 'security officer', 'security guard'],
        'maintenance': ['maintenance', 'handyman', 'facilities'],
        'gardener': ['gardener', 'groundskeeper', 'landscaper'],
        'general_staff': ['staff', 'employee', 'personnel']
    }

    def __init__(self, parsed_files: List[Dict], mapped_data: Dict):
        """
        Initialize staffing extractor

        Args:
            parsed_files: List of parsed file dictionaries
            mapped_data: Mapped data with building info
        """
        self.parsed_files = parsed_files
        self.mapped_data = mapped_data
        self.building_id = mapped_data.get('building', {}).get('id')

        # Results
        self.staff_members = []
        self.contractor_enrichment_data = {}

    def extract_all(self) -> Dict:
        """
        Extract all staffing data

        Returns:
            Dictionary with extracted staff data
        """
        print("  👤 Extracting building staffing data...")

        # First pass: Extract from dedicated staff documents
        for parsed_file in self.parsed_files:
            file_name = parsed_file.get('file_name', '').lower()

            # Check if this is a staff-related file
            if self._is_staff_file(file_name):
                self._extract_staff_from_file(parsed_file)

        # Second pass: Look for staff mentions in other documents
        for parsed_file in self.parsed_files:
            file_name = parsed_file.get('file_name', '').lower()

            # Skip if already processed as staff file
            if not self._is_staff_file(file_name):
                self._scan_for_staff_mentions(parsed_file)

        # Third pass: Enrich with contractor data
        self._enrich_with_contractor_data()

        print(f"     ✅ Staff members found: {len(self.staff_members)}")

        return {
            'staff_members': self.staff_members
        }

    def _is_staff_file(self, file_name: str) -> bool:
        """Check if file is likely to contain staff information"""
        staff_file_keywords = [
            'staff', 'caretaker', 'concierge', 'cleaner', 'porter',
            'employee', 'personnel', 'contractor', 'service provider',
            'team', 'schedule', 'rota'
        ]
        return any(keyword in file_name for keyword in staff_file_keywords)

    def _extract_staff_from_file(self, parsed_file: Dict):
        """Extract staff information from dedicated staff file"""
        text = parsed_file.get('text_content', '')
        file_name = parsed_file.get('file_name', '')
        storage_path = parsed_file.get('storage_path', '')

        # Ensure text is a string
        if not isinstance(text, str):
            return

        if not text:
            return

        # Look for patterns like:
        # "Caretaker: Rex (8am-12pm weekdays)"
        # "Cleaning: New Step - Cecile Abah"
        # "Security: Managed by Banham"

        # Pattern 1: Role: Name (details)
        pattern1 = r'(caretaker|concierge|cleaner|porter|security|maintenance|gardener)[:\s]+([A-Z][a-z]+(?:\s+[A-Z][a-z]+)*)\s*(?:\(([^)]+)\))?'
        matches1 = re.findall(pattern1, text, re.IGNORECASE)

        for match in matches1:
            role, name, details = match

            # Extract hours from details
            hours = self._extract_hours(details)

            staff_member = {
                'id': str(uuid.uuid4()),
                'building_id': self.building_id,
                'name': name.strip(),
                'role': role.lower(),
                'hours': hours,
                'contact_info': None,
                'company_name': None,
                'source_document': file_name,
                'document_path': storage_path,
                'notes': details if details else None
            }

            self.staff_members.append(staff_member)

        # Pattern 2: Role: Company - Contact Name
        pattern2 = r'(caretaker|concierge|cleaner|porter|security|maintenance|gardener)[:\s]+([A-Z][a-z\s]+)(?:\s*-\s*|\s+by\s+)([A-Z][a-z]+(?:\s+[A-Z][a-z]+)*)'
        matches2 = re.findall(pattern2, text, re.IGNORECASE)

        for match in matches2:
            role, company, contact = match

            # Check if this isn't a duplicate from pattern1
            if not any(s['name'] == contact.strip() for s in self.staff_members):
                staff_member = {
                    'id': str(uuid.uuid4()),
                    'building_id': self.building_id,
                    'name': contact.strip(),
                    'role': role.lower(),
                    'company_name': company.strip(),
                    'source_document': file_name,
                    'document_path': storage_path
                }

                self.staff_members.append(staff_member)

    def _scan_for_staff_mentions(self, parsed_file: Dict):
        """Scan document for staff mentions"""
        text = parsed_file.get('text_content', '')
        file_name = parsed_file.get('file_name', '')

        if not text:
            return

        # Look for table-like structures with staff info
        # Common in property forms or handover documents

        lines = text.split('\n')

        for i, line in enumerate(lines):
            line_lower = line.lower()

            # Check if line mentions staff role
            for role_type, keywords in self.ROLE_KEYWORDS.items():
                if any(keyword in line_lower for keyword in keywords):
                    # Look in surrounding lines for contact details
                    context_start = max(0, i - 2)
                    context_end = min(len(lines), i + 3)
                    context = '\n'.join(lines[context_start:context_end])

                    # Extract name
                    name = self._extract_name_from_context(context)

                    # Extract phone
                    phone = self._extract_phone_from_context(context)

                    # Extract email
                    email = self._extract_email_from_context(context)

                    if name:
                        # Check for duplicates
                        if not any(s['name'] == name for s in self.staff_members):
                            staff_member = {
                                'id': str(uuid.uuid4()),
                                'building_id': self.building_id,
                                'name': name,
                                'role': role_type if role_type != 'general_staff' else 'staff',
                                'contact_info': phone or email,
                                'source_document': file_name
                            }

                            self.staff_members.append(staff_member)

    def _extract_hours(self, text: str) -> Optional[str]:
        """Extract working hours from text"""
        if not text:
            return None

        # Patterns like "8am-12pm", "9:00-17:00", "Mon-Fri 8-4"
        patterns = [
            r'(\d{1,2}(?::\d{2})?\s*(?:am|pm)?)\s*[-–to]+\s*(\d{1,2}(?::\d{2})?\s*(?:am|pm)?)',
            r'(\d{1,2})\s*[-–]\s*(\d{1,2})'
        ]

        for pattern in patterns:
            match = re.search(pattern, text, re.IGNORECASE)
            if match:
                return match.group(0)

        # Look for day patterns
        days_pattern = r'(monday|tuesday|wednesday|thursday|friday|saturday|sunday|weekday|weekend|mon|tue|wed|thu|fri|sat|sun)'
        if re.search(days_pattern, text, re.IGNORECASE):
            return text[:100]  # Return first 100 chars containing schedule

        return None

    def _extract_name_from_context(self, text: str) -> Optional[str]:
        """Extract person name from text context"""
        # Look for capitalized names
        # Pattern: Firstname Lastname (both capitalized)
        pattern = r'\b([A-Z][a-z]+)\s+([A-Z][a-z]+)\b'
        match = re.search(pattern, text)

        if match:
            full_name = match.group(0)

            # Filter out common false positives
            false_positives = ['New Step', 'First Floor', 'Ground Floor', 'Flat Number']
            if full_name not in false_positives:
                return full_name

        # Try single name
        pattern_single = r'\b([A-Z][a-z]{2,})\b'
        match_single = re.search(pattern_single, text)
        if match_single:
            name = match_single.group(0)
            # Filter out common words
            common_words = ['The', 'Ltd', 'Limited', 'Company', 'Building', 'Street', 'Road']
            if name not in common_words:
                return name

        return None

    def _extract_phone_from_context(self, text: str) -> Optional[str]:
        """Extract phone number from text"""
        # UK phone patterns
        patterns = [
            r'0\d{10}',  # 11 digit UK number
            r'0\d{4}\s?\d{6}',  # Formatted UK number
            r'\+44\s?\d{10}',  # International format
            r'\(\d{3,5}\)\s?\d{6,8}'  # (020) 1234567
        ]

        for pattern in patterns:
            match = re.search(pattern, text)
            if match:
                return match.group(0)

        return None

    def _extract_email_from_context(self, text: str) -> Optional[str]:
        """Extract email from text"""
        pattern = r'[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}'
        match = re.search(pattern, text)

        if match:
            return match.group(0)

        return None

    def _enrich_with_contractor_data(self):
        """Enrich staff data with contractor information"""
        # Look for contractors.xlsx or similar contractor data
        contractors = self.mapped_data.get('contractors', [])

        if not contractors:
            return

        # Build contractor lookup by company name
        contractor_lookup = {}
        for contractor in contractors:
            company = contractor.get('company_name', '').lower()
            if company:
                contractor_lookup[company] = contractor

        # Enrich staff members
        for staff in self.staff_members:
            company = staff.get('company_name', '').lower()

            if company in contractor_lookup:
                contractor = contractor_lookup[company]

                # Enrich with contractor data
                if not staff.get('contact_info') and contractor.get('phone'):
                    staff['contact_info'] = contractor['phone']

                if not staff.get('email'):
                    staff['email'] = contractor.get('email')

                # Add contractor reference
                staff['contractor_id'] = contractor.get('id')

        print(f"     ✅ Enriched {len([s for s in self.staff_members if s.get('contractor_id')])} staff with contractor data")
