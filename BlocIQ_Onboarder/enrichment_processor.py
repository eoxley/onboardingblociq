"""
BlocIQ Onboarder - Enrichment Post-Processor
Enhances generated SQL with:
1. Building metadata filling (address extraction)
2. Major works project type inference
3. Budget fallback for unstructured PDFs
4. Building knowledge extraction (access, utilities, safety, general)
"""

import re
import json
from typing import Dict, List, Any, Optional, Tuple
import uuid


class EnrichmentProcessor:
    """Post-processes generated SQL to fill gaps and enrich data"""

    def __init__(self):
        # Project type classification patterns
        self.PROJECT_TYPE_MAP = {
            'lift': 'Lift Renewal',
            'elevator': 'Lift Renewal',
            'roof': 'Roof Works',
            'roofing': 'Roof Works',
            'facade': 'Cladding / Façade',
            'cladding': 'Cladding / Façade',
            'external wall': 'Cladding / Façade',
            'redecoration': 'Internal / External Redecoration',
            'decoration': 'Internal / External Redecoration',
            'painting': 'Internal / External Redecoration',
            'window': 'Window Replacement',
            'glazing': 'Window Replacement',
            'fire': 'Fire Safety / FRA Works',
            'fire safety': 'Fire Safety / FRA Works',
            'fire door': 'Fire Safety / FRA Works',
            'm&e': 'Mechanical & Electrical',
            'mechanical': 'Mechanical & Electrical',
            'electrical': 'Mechanical & Electrical',
            'heating': 'Mechanical & Electrical',
            'boiler': 'Mechanical & Electrical',
            'door': 'Door Replacement',
            'entrance': 'Door Replacement',
            'balcony': 'Balcony Refurbishment',
            'communal': 'Communal Area Works',
            'drainage': 'Drainage Works',
            'drains': 'Drainage Works'
        }

        # Building knowledge extraction patterns
        self.KNOWLEDGE_PATTERNS = {
            'access': [
                (r'gate\s*code[:\s]*([0-9#*]+)', 'gate_code', 'Gate Code'),
                (r'entry\s*code[:\s]*([0-9#*]+)', 'entry_code', 'Entry Code'),
                (r'keypad\s*code[:\s]*([0-9#*]+)', 'keypad_code', 'Keypad Code'),
                (r'access\s*code[:\s]*([0-9#*]+)', 'access_code', 'Access Code'),
            ],
            'utilities': [
                (r'stopcock[:\s]+(.+?)(?:\n|$)', 'stopcock_location', 'Stopcock'),
                (r'stop\s*valve[:\s]+(.+?)(?:\n|$)', 'stopcock_location', 'Stopcock'),
                (r'gas\s*meter[:\s]+(.+?)(?:\n|$)', 'gas_meter_location', 'Gas Meter'),
                (r'electric(?:al)?\s*meter[:\s]+(.+?)(?:\n|$)', 'electric_meter_location', 'Electric Meter'),
                (r'water\s*meter[:\s]+(.+?)(?:\n|$)', 'water_meter_location', 'Water Meter'),
                (r'boiler[:\s]+(.+?)(?:\n|$)', 'boiler_location', 'Boiler'),
                (r'main\s*valve[:\s]+(.+?)(?:\n|$)', 'main_valve_location', 'Main Valve'),
            ],
            'safety': [
                (r'alarm\s*panel[:\s]+(.+?)(?:\n|$)', 'alarm_panel_location', 'Alarm Panel'),
                (r'fire\s*alarm[:\s]+(.+?)(?:\n|$)', 'fire_alarm_location', 'Fire Alarm'),
                (r'cctv[:\s]+(.+?)(?:\n|$)', 'cctv_location', 'CCTV'),
                (r'sprinkler[:\s]+(.+?)(?:\n|$)', 'sprinkler_location', 'Sprinkler'),
                (r'assembly\s*point[:\s]+(.+?)(?:\n|$)', 'assembly_point', 'Fire Assembly Point'),
            ],
            'general': [
                (r'bin\s*store[:\s]+(.+?)(?:\n|$)', 'bin_store', 'Bin Store'),
                (r'post\s*room[:\s]+(.+?)(?:\n|$)', 'post_room', 'Post Room'),
                (r'caretaker[:\s]+(.+?)(?:\n|$)', 'caretaker', 'Caretaker'),
                (r'parking[:\s]+(.+?)(?:\n|$)', 'parking', 'Parking'),
                (r'bike\s*store[:\s]+(.+?)(?:\n|$)', 'bike_store', 'Bike Store'),
            ]
        }

        # Address extraction patterns
        self.ADDRESS_PATTERNS = [
            # Full UK address pattern
            r'(\d+[-/]?\d*\s+[A-Z][a-z]+(?:\s+[A-Z][a-z]+)*(?:\s+(?:Street|Road|Square|Avenue|Place|Gardens|Court|Lane|Drive))?[^,\n]*(?:,\s*London)?(?:,?\s*[A-Z]{1,2}\d{1,2}[A-Z]?\s*\d[A-Z]{2})?)',
            # Street name with number
            r'(\d+\s+[A-Z][a-z]+\s+[A-Z][a-z]+)',
            # Named locations
            r'([A-Z][a-z]+\s+Square)',
            r'([A-Z][a-z]+\s+Road)',
            r'([A-Z][a-z]+\s+Street)',
        ]

        # Stats tracking
        self.stats = {
            'building_metadata_filled': 0,
            'major_works_tagged': 0,
            'budget_placeholders_created': 0,
            'building_intelligence_entries': 0,
            'addresses_extracted': 0,
            'addresses_skipped': 0,
        }

    def process(self, mapped_data: Dict, parsed_files: List[Dict], folder_name: str = None) -> Dict:
        """
        Main enrichment pipeline

        Args:
            mapped_data: Output from schema_mapper
            parsed_files: List of parsed file metadata
            folder_name: Original folder name

        Returns:
            Enrichment data with SQL statements and stats
        """
        enrichment = {
            'sql_statements': [],
            'building_knowledge': [],
            'metadata_corrections': [],
            'validation_notes': [],
        }

        building_id = mapped_data.get('building', {}).get('id')

        if not building_id:
            return enrichment

        # 1. Building metadata enrichment
        self._enrich_building_metadata(
            building_id,
            mapped_data.get('building', {}),
            parsed_files,
            folder_name,
            enrichment
        )

        # 2. Major works project type inference
        self._enrich_major_works_types(
            building_id,
            mapped_data.get('major_works_projects', []),
            parsed_files,
            enrichment
        )

        # 3. Budget fallback for unstructured PDFs
        self._create_budget_fallbacks(
            building_id,
            mapped_data.get('building_documents', []),
            mapped_data.get('budgets', []),
            enrichment
        )

        # 4. Building knowledge extraction
        self._extract_building_knowledge(
            building_id,
            parsed_files,
            enrichment
        )

        # 5. Create building_knowledge table DDL
        enrichment['sql_statements'].insert(0, self._get_building_knowledge_ddl())

        return enrichment

    def _enrich_building_metadata(self, building_id: str, building: Dict,
                                   parsed_files: List[Dict], folder_name: str,
                                   enrichment: Dict):
        """Extract and fill missing building metadata (address)"""
        current_address = building.get('address', '').strip()

        if current_address:
            return  # Already has address

        # Try to extract from folder name first
        extracted_address = None

        if folder_name:
            for pattern in self.ADDRESS_PATTERNS:
                match = re.search(pattern, folder_name, re.IGNORECASE)
                if match:
                    extracted_address = match.group(1).strip()
                    break

        # If not found in folder, search parsed files
        if not extracted_address:
            for file_data in parsed_files:
                # Check file name
                file_name = file_data.get('file_name', '')
                if 'property' in file_name.lower() or 'information' in file_name.lower():
                    # Try to extract from full text
                    full_text = file_data.get('full_text', '')

                    # Look for "Address:", "Property Address:", etc.
                    address_match = re.search(
                        r'(?:property\s+)?address[:\s]+(.+?)(?:\n|$)',
                        full_text,
                        re.IGNORECASE
                    )
                    if address_match:
                        extracted_address = address_match.group(1).strip()
                        break

                    # Try general patterns
                    for pattern in self.ADDRESS_PATTERNS:
                        match = re.search(pattern, full_text)
                        if match:
                            extracted_address = match.group(1).strip()
                            break

                if extracted_address:
                    break

        if extracted_address:
            # Clean up the address
            extracted_address = extracted_address.replace('\n', ', ')
            extracted_address = re.sub(r'\s+', ' ', extracted_address)

            sql = f"""-- Update building address
UPDATE buildings
SET address = '{self._escape_sql(extracted_address)}'
WHERE id = '{building_id}';
"""
            enrichment['sql_statements'].append(sql)
            enrichment['metadata_corrections'].append({
                'type': 'address',
                'value': extracted_address,
                'source': 'auto_extracted'
            })
            self.stats['building_metadata_filled'] += 1
            self.stats['addresses_extracted'] += 1
        else:
            self.stats['addresses_skipped'] += 1
            enrichment['validation_notes'].append(
                f"⚠️ Skipped: Could not extract address for building {building_id}"
            )

    def _enrich_major_works_types(self, building_id: str, projects: List[Dict],
                                   parsed_files: List[Dict], enrichment: Dict):
        """Infer and set project_type for major works projects"""
        for project in projects:
            project_name = project.get('project_name', '').lower()
            project_id = project.get('id')

            # Skip if already has project_type
            if project.get('project_type'):
                continue

            # Try to match project type from project name
            matched_type = None
            for keyword, project_type in self.PROJECT_TYPE_MAP.items():
                if keyword in project_name:
                    matched_type = project_type
                    break

            # If not matched, check related document filenames
            if not matched_type:
                document_id = project.get('document_id')
                if document_id:
                    for file_data in parsed_files:
                        if file_data.get('id') == document_id:
                            file_name = file_data.get('file_name', '').lower()
                            for keyword, project_type in self.PROJECT_TYPE_MAP.items():
                                if keyword in file_name:
                                    matched_type = project_type
                                    break
                            break

            # Default to "General Major Work"
            if not matched_type:
                matched_type = 'General Major Work'

            # DISABLED: project_type column doesn't exist in production schema
            # sql = f"""-- Classify major works project type
            # UPDATE major_works_projects
            # SET project_type = '{self._escape_sql(matched_type)}'
            # WHERE id = '{project_id}';
            # """
            # enrichment['sql_statements'].append(sql)
            # self.stats['major_works_tagged'] += 1

    def _create_budget_fallbacks(self, building_id: str, documents: List[Dict],
                                  budgets: List[Dict], enrichment: Dict):
        """Create placeholder budget records for unstructured PDF files"""
        # Find budget-related documents that don't have budget records
        budget_doc_ids = {b.get('document_id') for b in budgets if b.get('document_id')}

        unstructured_budgets = []

        for doc in documents:
            doc_id = doc.get('id')
            file_name = doc.get('file_name', '').lower()
            category = doc.get('category', '')

            # Check if it's a finance document without a budget record
            if category == 'finance' and doc_id not in budget_doc_ids:
                # Check if filename suggests it's a budget
                if any(kw in file_name for kw in ['budget', 'service charge', 'apportionment']):
                    unstructured_budgets.append(doc)

        # Create fallback budget records
        for doc in unstructured_budgets:
            doc_id = doc.get('id')
            file_name = doc.get('file_name')

            # Try to extract year
            financial_year = None
            year_match = re.search(r'20(\d{2})', file_name)
            if year_match:
                financial_year = f"20{year_match.group(1)}"

            # Determine budget type from filename
            budget_type = 'service_charge'
            if 'reserve' in file_name.lower():
                budget_type = 'reserve_fund'
            elif 'sinking' in file_name.lower():
                budget_type = 'sinking_fund'

            budget_id = str(uuid.uuid4())
            period = financial_year or 'Unknown'

            sql = f"""-- Fallback budget for unstructured PDF
INSERT INTO budgets (id, building_id, document_id, period, budget_type, total_amount)
VALUES (
    '{budget_id}',
    '{building_id}',
    '{doc_id}',
    '{period}',
    '{budget_type}',
    NULL  -- Requires manual entry
)
ON CONFLICT (id) DO NOTHING;
"""
            enrichment['sql_statements'].append(sql)
            self.stats['budget_placeholders_created'] += 1

    def _extract_building_knowledge(self, building_id: str, parsed_files: List[Dict],
                                     enrichment: Dict):
        """Extract building knowledge (access codes, utility locations, etc.)"""
        extracted_knowledge = []

        for file_data in parsed_files:
            file_name = file_data.get('file_name', '')
            full_text = file_data.get('full_text', '')

            # Skip if no text
            if not full_text:
                continue

            # Extract by category
            for category, patterns in self.KNOWLEDGE_PATTERNS.items():
                for pattern, key, label in patterns:
                    matches = re.finditer(pattern, full_text, re.IGNORECASE)

                    for match in matches:
                        value = match.group(1).strip()

                        # Clean up value
                        value = value.replace('\n', ' ')
                        value = re.sub(r'\s+', ' ', value)

                        # Limit length
                        if len(value) > 200:
                            value = value[:200] + '...'

                        # Skip if too short or generic
                        if len(value) < 2 or value.lower() in ['n/a', 'none', 'nil']:
                            continue

                        # Determine visibility
                        visibility = 'team'
                        if category == 'access':
                            visibility = 'contractors'

                        # Determine which column to use
                        access_type = key
                        code = None
                        location = None
                        description = None

                        if 'code' in key:
                            code = value
                        elif 'location' in key:
                            location = value
                        else:
                            description = value

                        knowledge_id = str(uuid.uuid4())

                        # Avoid duplicates
                        duplicate = False
                        for existing in extracted_knowledge:
                            if (existing['category'] == category and
                                existing['key'] == key and
                                existing['value'] == value):
                                duplicate = True
                                break

                        if not duplicate:
                            sql = f"""-- Building knowledge: {label}
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '{knowledge_id}',
    '{building_id}',
    '{access_type}',
    '{category}',
    '{self._escape_sql(label)}',
    {f"'{self._escape_sql(code)}'" if code else 'NULL'},
    {f"'{self._escape_sql(location)}'" if location else 'NULL'},
    {f"'{self._escape_sql(description)}'" if description else 'NULL'},
    '{visibility}'
)
ON CONFLICT (id) DO NOTHING;
"""
                            enrichment['sql_statements'].append(sql)
                            extracted_knowledge.append({
                                'category': category,
                                'key': key,
                                'label': label,
                                'value': value,
                                'visibility': visibility
                            })
                            self.stats['building_intelligence_entries'] += 1

        enrichment['building_knowledge'] = extracted_knowledge

    def _get_building_knowledge_ddl(self) -> str:
        """Return DDL for building_knowledge table (uses existing building_keys_access)"""
        return """-- ============================================================
-- Building Knowledge Enhancement
-- ============================================================
-- Note: Uses existing building_keys_access table with enhanced columns
-- This DDL ensures the table has the required columns for building knowledge

-- Add missing columns if they don't exist
DO $$
BEGIN
    -- Add category column if missing
    IF NOT EXISTS (
        SELECT 1 FROM information_schema.columns
        WHERE table_name = 'building_keys_access' AND column_name = 'category'
    ) THEN
        ALTER TABLE building_keys_access ADD COLUMN category text;
    END IF;

    -- Add label column if missing
    IF NOT EXISTS (
        SELECT 1 FROM information_schema.columns
        WHERE table_name = 'building_keys_access' AND column_name = 'label'
    ) THEN
        ALTER TABLE building_keys_access ADD COLUMN label text;
    END IF;

    -- Add visibility column if missing
    IF NOT EXISTS (
        SELECT 1 FROM information_schema.columns
        WHERE table_name = 'building_keys_access' AND column_name = 'visibility'
    ) THEN
        ALTER TABLE building_keys_access ADD COLUMN visibility text DEFAULT 'team';
    END IF;
END $$;

-- Create indexes if missing
CREATE INDEX IF NOT EXISTS idx_building_keys_access_category
    ON building_keys_access(building_id, category);

CREATE INDEX IF NOT EXISTS idx_building_keys_access_search
    ON building_keys_access USING gin(
        to_tsvector('english',
            COALESCE(label, '') || ' ' ||
            COALESCE(description, '') || ' ' ||
            COALESCE(location, '')
        )
    );

"""

    def _escape_sql(self, value: str) -> str:
        """Escape single quotes for SQL"""
        if not value:
            return ''
        return str(value).replace("'", "''")

    def get_stats(self) -> Dict:
        """Return enrichment statistics"""
        return self.stats

    def get_validation_summary(self) -> str:
        """Generate validation summary for report"""
        summary = []

        if self.stats['addresses_extracted'] > 0:
            summary.append(f"✅ Enrichment Passed: {self.stats['addresses_extracted']} address(es) extracted")

        if self.stats['addresses_skipped'] > 0:
            summary.append(f"⚠️ Skipped {self.stats['addresses_skipped']} missing address(es) (no match found)")

        if self.stats['major_works_tagged'] > 0:
            summary.append(f"✅ Tagged {self.stats['major_works_tagged']} major works project(s) with types")

        if self.stats['budget_placeholders_created'] > 0:
            summary.append(f"✅ Created {self.stats['budget_placeholders_created']} budget placeholder(s) for unstructured PDFs")

        if self.stats['building_intelligence_entries'] > 0:
            summary.append(f"✅ Extracted {self.stats['building_intelligence_entries']} building knowledge entrie(s)")

        if not summary:
            summary.append("ℹ️ No enrichments needed")

        return '\n'.join(summary)
