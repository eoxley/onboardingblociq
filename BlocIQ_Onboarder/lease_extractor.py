"""
BlocIQ Onboarder - Lease Document Extractor
Detects and extracts lease information using OCR integration with Render.com service
"""

import re
import requests
import os
from pathlib import Path
from datetime import datetime, timedelta
from typing import Dict, List, Optional, Tuple
import uuid


class LeaseExtractor:
    """Extract lease data from documents using OCR"""

    # Lease detection keywords
    LEASE_KEYWORDS = [
        'lease', 'leasehold', 'tenancy', 'official copy', 'transfer',
        'assignment', 'demise', 'lessor', 'lessee'
    ]

    # OCR Service configuration (from BlocIQ frontend)
    RENDER_OCR_URL = os.getenv('RENDER_OCR_URL', 'https://ocr-server-2-ykmk.onrender.com/upload')
    RENDER_OCR_TOKEN = os.getenv('RENDER_OCR_TOKEN', 'blociq-dev-token-2024')

    def __init__(self, parsed_files: List[Dict], mapped_data: Dict):
        """
        Initialize lease extractor

        Args:
            parsed_files: List of parsed file dictionaries
            mapped_data: Mapped data with building and unit info
        """
        self.parsed_files = parsed_files
        self.mapped_data = mapped_data
        self.building_id = mapped_data.get('building', {}).get('id')

        # Results
        self.leases = []
        self.errors = []

        # Statistics
        self.files_processed = 0
        self.files_with_ocr = 0
        self.leases_extracted = 0

    def extract_all(self) -> Dict:
        """
        Extract all lease data from documents
        Limited to 1 OCR operation per run to avoid timeouts

        Returns:
            Dictionary with extracted lease data and errors
        """
        print("  📜 Extracting lease information...")
        ocr_limit = 1
        ocr_count = 0

        for parsed_file in self.parsed_files:
            file_path = parsed_file.get('file_path', '')
            file_name = parsed_file.get('file_name', '')
            text_content = parsed_file.get('text_content', '')

            # Check if this is a lease document
            if not self._is_lease_document(file_name, text_content):
                continue

            self.files_processed += 1

            # Skip OCR if we've hit the limit
            needs_ocr = not text_content or len(text_content) < 100
            if needs_ocr and ocr_count >= ocr_limit:
                print(f"     ⚠️  Skipping OCR for {file_name} (limit reached: {ocr_limit} per run)")
                continue

            # Extract lease data
            lease_data = self._extract_lease_from_document(
                file_path, file_name, text_content
            )

            if lease_data:
                self.leases.append(lease_data)
                self.leases_extracted += 1

                # Track if OCR was used
                if needs_ocr and self.files_with_ocr > ocr_count:
                    ocr_count = self.files_with_ocr

        print(f"     ✅ Lease files found: {self.files_processed}")
        print(f"     ✅ Leases extracted: {self.leases_extracted}")
        if self.files_with_ocr > 0:
            print(f"     ✅ Files processed with OCR: {self.files_with_ocr} (limit: {ocr_limit})")
        if self.errors:
            print(f"     ⚠️  Errors: {len(self.errors)}")

        return {
            'leases': self.leases,
            'errors': self.errors,
            'statistics': {
                'files_processed': self.files_processed,
                'files_with_ocr': self.files_with_ocr,
                'leases_extracted': self.leases_extracted
            }
        }

    def _is_lease_document(self, file_name: str, text_content: str) -> bool:
        """Check if document is likely a lease"""
        file_name_lower = file_name.lower()
        text_lower = text_content.lower() if text_content else ''

        # Check filename
        if any(keyword in file_name_lower for keyword in self.LEASE_KEYWORDS):
            return True

        # Check text content for lease markers
        lease_text_markers = [
            'this lease', 'lease agreement', 'demise', 'lessor and lessee',
            'official copy', 'land registry', 'title number'
        ]

        if any(marker in text_lower for marker in lease_text_markers):
            return True

        return False

    def _extract_lease_from_document(self, file_path: str, file_name: str, text_content: str) -> Optional[Dict]:
        """Extract lease data from a single document"""
        try:
            # If no text content or very short, try OCR
            if not text_content or len(text_content) < 100:
                ocr_text = self._perform_ocr(file_path)
                if ocr_text:
                    text_content = ocr_text
                    self.files_with_ocr += 1
                else:
                    # Create partial record with filename info only
                    return self._create_partial_lease_record(file_name)

            # Extract all lease fields
            term_start = self._extract_term_start(text_content)
            term_years = self._extract_term_years(text_content)
            ground_rent = self._extract_ground_rent(text_content)
            rent_review_period = self._extract_rent_review_period(text_content)
            leaseholder_name = self._extract_leaseholder_name(text_content)
            lessor_name = self._extract_lessor_name(text_content)
            unit_reference = self._extract_unit_reference(file_name, text_content)

            # Find matching unit_id
            unit_id = self._find_unit_id(unit_reference)

            # Create lease record
            lease = {
                'id': str(uuid.uuid4()),
                'building_id': self.building_id,
                'unit_id': unit_id,
                'term_start': term_start,
                'term_years': term_years,
                'ground_rent': ground_rent,
                'rent_review_period': rent_review_period,
                'leaseholder_name': leaseholder_name,
                'lessor_name': lessor_name,
                'source_document': file_name
            }

            # Calculate expiry date if we have start date and term
            if term_start and term_years:
                try:
                    start_date = datetime.strptime(term_start, '%Y-%m-%d')
                    expiry_date = start_date + timedelta(days=365.25 * term_years)
                    lease['expiry_date'] = expiry_date.strftime('%Y-%m-%d')
                except:
                    pass

            return lease

        except Exception as e:
            self.errors.append({
                'file': file_name,
                'error': str(e),
                'type': 'lease_extraction'
            })
            return None

    def _perform_ocr(self, file_path: str) -> Optional[str]:
        """Perform OCR on document using Render.com service"""
        if not os.path.exists(file_path):
            return None

        try:
            # Check if service is configured
            if not self.RENDER_OCR_URL or not self.RENDER_OCR_TOKEN:
                print(f"     ⚠️  OCR service not configured, skipping {os.path.basename(file_path)}")
                return None

            # Prepare file for upload
            with open(file_path, 'rb') as f:
                files = {'file': (os.path.basename(file_path), f, 'application/pdf')}
                data = {'use_google_vision': 'false'}  # Use Tesseract by default

                headers = {
                    'Authorization': f'Bearer {self.RENDER_OCR_TOKEN}'
                }

                # Call OCR service
                print(f"     🔍 Performing OCR on {os.path.basename(file_path)}...")
                response = requests.post(
                    self.RENDER_OCR_URL,
                    files=files,
                    data=data,
                    headers=headers,
                    timeout=60
                )

                if response.status_code == 200:
                    result = response.json()
                    text = result.get('text', '')
                    print(f"        ✅ OCR complete: {len(text)} characters extracted")
                    return text
                else:
                    print(f"        ⚠️  OCR failed: {response.status_code}")
                    return None

        except requests.exceptions.Timeout:
            print(f"     ⚠️  OCR timeout for {os.path.basename(file_path)}")
            return None
        except Exception as e:
            print(f"     ⚠️  OCR error: {str(e)}")
            return None

    def _create_partial_lease_record(self, file_name: str) -> Dict:
        """Create lease record with filename info only"""
        unit_reference = self._extract_unit_reference_from_filename(file_name)
        unit_id = self._find_unit_id(unit_reference)

        return {
            'id': str(uuid.uuid4()),
            'building_id': self.building_id,
            'unit_id': unit_id,
            'term_start': None,
            'term_years': None,
            'ground_rent': None,
            'rent_review_period': None,
            'leaseholder_name': None,
            'lessor_name': None,
            'source_document': file_name,
            'notes': 'Partial record created from filename only - OCR not available'
        }

    def _extract_term_start(self, text: str) -> Optional[str]:
        """Extract lease start date"""
        # Pattern: "commencing on 1st January 2003"
        patterns = [
            r'commencing (?:on |from )?(\d{1,2}(?:st|nd|rd|th)?\s+\w+\s+\d{4})',
            r'from (?:the )?(\d{1,2}(?:st|nd|rd|th)?\s+\w+\s+\d{4})',
            r'dated (?:the )?(\d{1,2}(?:st|nd|rd|th)?\s+\w+\s+\d{4})',
            r'(\d{1,2}[/-]\d{1,2}[/-]\d{4})',  # DD/MM/YYYY or DD-MM-YYYY
            r'(\d{4}[/-]\d{1,2}[/-]\d{1,2})'   # YYYY-MM-DD
        ]

        for pattern in patterns:
            match = re.search(pattern, text, re.IGNORECASE)
            if match:
                date_str = match.group(1)
                parsed_date = self._parse_date(date_str)
                if parsed_date:
                    return parsed_date

        return None

    def _extract_term_years(self, text: str) -> Optional[int]:
        """Extract lease term in years"""
        # Pattern: "for a term of 125 years", "for 99 years"
        patterns = [
            r'(?:for a term of|for)\s+(\d+)\s+years?',
            r'term[:\s]+(\d+)\s+years?',
            r'(\d+)[- ]year[s]?\s+lease'
        ]

        for pattern in patterns:
            match = re.search(pattern, text, re.IGNORECASE)
            if match:
                try:
                    years = int(match.group(1))
                    # Sanity check: typical lease terms are 99, 125, 999 years
                    if 1 <= years <= 9999:
                        return years
                except ValueError:
                    continue

        return None

    def _extract_ground_rent(self, text: str) -> Optional[float]:
        """Extract ground rent amount"""
        # Pattern: "ground rent of £250 per annum", "£50 ground rent"
        patterns = [
            r'ground rent[^£\d]{0,20}£\s*([\d,]+(?:\.\d{2})?)',
            r'£\s*([\d,]+(?:\.\d{2})?)[^a-zA-Z]{0,10}ground rent',
            r'rent[:\s]+£\s*([\d,]+(?:\.\d{2})?)\s+(?:per annum|annually|pa)'
        ]

        for pattern in patterns:
            match = re.search(pattern, text, re.IGNORECASE)
            if match:
                try:
                    amount_str = match.group(1).replace(',', '')
                    amount = float(amount_str)
                    if 0 <= amount <= 100000:  # Sanity check
                        return amount
                except ValueError:
                    continue

        return None

    def _extract_rent_review_period(self, text: str) -> Optional[int]:
        """Extract rent review period in years"""
        # Pattern: "reviewed every 25 years", "review period of 33 years"
        patterns = [
            r'reviewed? every\s+(\d+)\s+years?',
            r'review period[^0-9]{0,10}(\d+)\s+years?',
            r'(?:rent )?review[:\s]+(\d+)\s+years?'
        ]

        for pattern in patterns:
            match = re.search(pattern, text, re.IGNORECASE)
            if match:
                try:
                    years = int(match.group(1))
                    if 1 <= years <= 999:
                        return years
                except ValueError:
                    continue

        return None

    def _extract_leaseholder_name(self, text: str) -> Optional[str]:
        """Extract leaseholder/lessee name"""
        # Pattern: "between ... and [NAME] (hereinafter called the Lessee)"
        patterns = [
            r'and\s+([A-Z][a-z]+(?:\s+[A-Z][a-z]+){1,3})\s+\(hereinafter[^)]*(?:Lessee|Tenant)',
            r'(?:Lessee|Tenant)[:\s]+([A-Z][a-z]+(?:\s+[A-Z][a-z]+){1,3})',
            r'granted to\s+([A-Z][a-z]+(?:\s+[A-Z][a-z]+){1,3})',
        ]

        for pattern in patterns:
            match = re.search(pattern, text, re.IGNORECASE)
            if match:
                name = match.group(1).strip()
                # Filter out common false positives
                if name and len(name) > 2 and name not in ['The Landlord', 'The Tenant', 'The Lessee']:
                    return name

        return None

    def _extract_lessor_name(self, text: str) -> Optional[str]:
        """Extract lessor/landlord name"""
        # Pattern: "[NAME] (hereinafter called the Landlord)"
        patterns = [
            r'([A-Z][a-z]+(?:\s+[A-Z][a-z]+){1,5}(?:\s+Ltd|Limited)?)\s+\(hereinafter[^)]*(?:Lessor|Landlord)',
            r'(?:Lessor|Landlord)[:\s]+([A-Z][a-z]+(?:\s+[A-Z][a-z]+){1,5}(?:\s+Ltd|Limited)?)',
            r'between\s+([A-Z][a-z]+(?:\s+[A-Z][a-z]+){1,5}(?:\s+Ltd|Limited)?)\s+and',
        ]

        for pattern in patterns:
            match = re.search(pattern, text)
            if match:
                name = match.group(1).strip()
                if name and len(name) > 2:
                    return name

        return None

    def _extract_unit_reference(self, file_name: str, text: str) -> Optional[str]:
        """Extract unit reference from filename or text"""
        # Try filename first
        unit_ref = self._extract_unit_reference_from_filename(file_name)
        if unit_ref:
            return unit_ref

        # Try text content
        patterns = [
            r'(?:Flat|Apartment|Unit) No[.\s]*([A-Z0-9]+)',
            r'(?:Flat|Apartment|Unit)[:\s]+([A-Z0-9]+)',
            r'property known as[^0-9A-Z]{0,20}([0-9A-Z]+[a-z]?)',
        ]

        for pattern in patterns:
            match = re.search(pattern, text, re.IGNORECASE)
            if match:
                return match.group(1).strip()

        return None

    def _extract_unit_reference_from_filename(self, file_name: str) -> Optional[str]:
        """Extract unit reference from filename"""
        # Patterns: "Flat 3.pdf", "Flat3.pdf", "Unit_5A.pdf", "Apartment 12.pdf"
        patterns = [
            r'(?:flat|apartment|unit)[_\s-]*([0-9]+[a-z]?)',
            r'([0-9]+[a-z]?)[_\s-]*(?:flat|apartment|unit)',
        ]

        for pattern in patterns:
            match = re.search(pattern, file_name, re.IGNORECASE)
            if match:
                return match.group(1).upper()

        return None

    def _find_unit_id(self, unit_reference: Optional[str]) -> Optional[str]:
        """Find unit ID by matching unit reference"""
        if not unit_reference:
            return None

        units = self.mapped_data.get('units', [])

        # Try exact match
        for unit in units:
            unit_name = unit.get('name', '').upper()
            if unit_reference.upper() in unit_name or unit_name in unit_reference.upper():
                return unit.get('id')

        # Try numeric match
        unit_number = re.search(r'\d+', unit_reference)
        if unit_number:
            num = unit_number.group()
            for unit in units:
                if num in str(unit.get('name', '')):
                    return unit.get('id')

        return None

    def _parse_date(self, date_str: str) -> Optional[str]:
        """Parse date string to ISO format"""
        try:
            # Try common formats
            formats = [
                '%d %B %Y', '%d %b %Y',  # "1 January 2003", "1 Jan 2003"
                '%dst %B %Y', '%dnd %B %Y', '%drd %B %Y', '%dth %B %Y',  # With ordinals
                '%d/%m/%Y', '%d-%m-%Y',  # "01/01/2003", "01-01-2003"
                '%Y-%m-%d', '%Y/%m/%d'   # "2003-01-01", "2003/01/01"
            ]

            # Remove ordinal suffixes
            clean_date = re.sub(r'(\d+)(?:st|nd|rd|th)', r'\1', date_str)

            for fmt in formats:
                try:
                    dt = datetime.strptime(clean_date, fmt)
                    return dt.strftime('%Y-%m-%d')
                except ValueError:
                    continue

        except Exception:
            pass

        return None
