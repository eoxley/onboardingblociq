"""
BlocIQ Onboarder - Schema Mapper
Maps data to exact Supabase schema column names and types
Based on Supabase schema metadata analysis
"""

from typing import Dict, List, Any, Optional
from datetime import datetime
import uuid


class SupabaseSchemaMapper:
    """Maps data to exact Supabase table schemas"""

    def __init__(self, agency_id: str = '00000000-0000-0000-0000-000000000001', folder_name: str = None):
        self.agency_id = agency_id
        self.folder_name = folder_name
        
        # Define exact column mappings for each table - COMPLETE SCHEMA
        self.table_schemas = {
            'buildings': {
                'id': 'uuid PRIMARY KEY DEFAULT gen_random_uuid()',
                'name': 'text NOT NULL',
                'address': 'text',
                'building_type': 'text',
                'structure_type': 'text',
                'client_name': 'text',
                'client_contact': 'text',
                'is_hrb': 'boolean DEFAULT false',
                'unit_count': 'integer',
                'total_floors': 'varchar',
                'lift_available': 'varchar',
                'agency_id': 'uuid REFERENCES agencies(id)',
                'council_borough': 'varchar',
                'building_manager_name': 'varchar',
                'building_manager_email': 'varchar',
                'building_manager_phone': 'varchar',
                'emergency_contact_name': 'varchar',
                'emergency_contact_phone': 'varchar',
                'building_age': 'varchar',
                'construction_type': 'varchar',
                'heating_type': 'varchar',
                'hot_water_type': 'varchar',
                'waste_collection_day': 'varchar',
                'recycling_info': 'text',
                'building_insurance_provider': 'varchar',
                'building_insurance_expiry': 'date',
                'fire_safety_status': 'varchar',
                'asbestos_status': 'varchar',
                'energy_rating': 'varchar',
                'service_charge_frequency': 'varchar',
                'ground_rent_amount': 'decimal',
                'ground_rent_frequency': 'varchar',
                'operational_notes': 'text',
                'notes': 'text',
                'key_access_notes': 'text',
                'entry_code': 'varchar',
                'fire_panel_location': 'varchar',
                'access_notes': 'text',
                'demo_ready': 'boolean DEFAULT false',
                'sites_staff': 'text',
                'created_at': 'timestamp with time zone DEFAULT now()',
                'updated_at': 'timestamp with time zone DEFAULT now()',
                'created_by': 'uuid REFERENCES users(id)'
            },
            'units': {
                'id': 'uuid PRIMARY KEY DEFAULT gen_random_uuid()',
                'building_id': 'uuid NOT NULL REFERENCES buildings(id)',
                'unit_number': 'varchar NOT NULL',
                'type': 'varchar',  # 'flat', 'commercial', etc.
                'floor': 'varchar',
                'leaseholder_id': 'uuid REFERENCES leaseholders(id)',
                'apportionment_percent': 'decimal(5,2)'
            },
            'leaseholders': {
                'id': 'uuid PRIMARY KEY DEFAULT gen_random_uuid()',
                'unit_id': 'uuid NOT NULL REFERENCES units(id)',
                'name': 'text NOT NULL',
                'full_name': 'text',
                'phone': 'text',
                'phone_number': 'text',
                'email': 'text',
                'correspondence_address': 'text',
                'is_director': 'boolean DEFAULT false'
            },
            'building_documents': {
                'id': 'uuid PRIMARY KEY DEFAULT gen_random_uuid()',
                'building_id': 'uuid NOT NULL REFERENCES buildings(id)',
                'file_name': 'text NOT NULL',
                'file_type': 'text',
                'storage_path': 'text NOT NULL',
                'file_size': 'bigint',
                'category': 'text NOT NULL',  # compliance, finance, major_works, lease, contracts, correspondence, uncategorised
                'linked_entity_id': 'uuid',
                'entity_type': 'text',  # compliance_asset, budget, major_works_project, unit, leaseholder
                'document_id': 'text',  # FK to linked record
                'uploaded_at': 'timestamp with time zone DEFAULT now()',
                'uploaded_by': 'uuid REFERENCES users(id)',
                'confidence': 'numeric',
                'confidence_level': 'text',
                'type': 'text',  # DEPRECATED: use category instead
                'is_unlinked': 'boolean DEFAULT false',
                'auto_linked_building_id': 'uuid REFERENCES buildings(id)',
                'unit_id': 'uuid REFERENCES units(id)',
                'leaseholder_id': 'uuid REFERENCES leaseholders(id)'
            },
            'compliance_assets': {
                'id': 'uuid PRIMARY KEY DEFAULT gen_random_uuid()',
                'building_id': 'uuid REFERENCES buildings(id)',
                'user_id': 'uuid REFERENCES users(id)',
                'asset_name': 'varchar NOT NULL',
                'asset_type': 'varchar NOT NULL',
                'category': 'varchar NOT NULL',
                'description': 'text',
                'is_required': 'boolean DEFAULT false',
                'is_active': 'boolean DEFAULT true',
                'inspection_frequency': 'varchar NOT NULL',
                'frequency_months': 'integer',
                'status': 'varchar DEFAULT pending',
                'last_inspection_date': 'date',
                'next_due_date': 'date',
                'certificate_expiry': 'date',
                'inspector_name': 'varchar',
                'inspector_company': 'varchar',
                'inspector_contact': 'varchar',
                'certificate_url': 'text',
                'notes': 'text',
                'compliance_reference': 'varchar',
                'custom_asset': 'boolean DEFAULT false'
            },
            'compliance_inspections': {
                'id': 'uuid PRIMARY KEY DEFAULT gen_random_uuid()',
                'compliance_asset_id': 'uuid REFERENCES compliance_assets(id)',
                'building_id': 'uuid REFERENCES buildings(id)',
                'user_id': 'uuid REFERENCES users(id)',
                'inspection_date': 'date NOT NULL',
                'inspection_type': 'varchar DEFAULT routine',
                'result': 'varchar NOT NULL',
                'compliant': 'boolean NOT NULL',
                'score': 'integer',
                'inspector_name': 'varchar',
                'inspector_company': 'varchar',
                'certificate_number': 'varchar',
                'certificate_url': 'text',
                'report_url': 'text',
                'findings': 'text',
                'recommendations': 'text',
                'actions_required': 'text',
                'next_inspection_due': 'date',
                'follow_up_required': 'boolean DEFAULT false',
                'compliance_notes': 'text'
            },
            'major_works_projects': {
                'id': 'uuid PRIMARY KEY DEFAULT gen_random_uuid()',
                'building_id': 'uuid REFERENCES buildings(id)',
                'user_id': 'uuid REFERENCES users(id)',
                'title': 'varchar NOT NULL',
                'name': 'varchar',
                'description': 'text',
                'project_type': 'varchar',
                'status': 'varchar',
                'start_date': 'date',
                'end_date': 'date',
                'expected_completion_date': 'date',
                'actual_completion_date': 'date',
                'estimated_cost': 'decimal',
                'actual_cost': 'decimal',
                'contractor_name': 'varchar',
                'project_manager': 'varchar',
                'completion_percentage': 'integer DEFAULT 0',
                'notice_of_intention_date': 'date',
                'statement_of_estimates_date': 'date',
                'contractor_appointed_date': 'date',
                'is_active': 'boolean DEFAULT true',
                'notes': 'text'
            },
            'budgets': {
                'id': 'uuid PRIMARY KEY DEFAULT gen_random_uuid()',
                'building_id': 'uuid NOT NULL REFERENCES buildings(id)',
                'period': 'varchar NOT NULL',  # e.g., '2024-2025', 'YE2024'
                'total_amount': 'decimal',
                'document_id': 'uuid REFERENCES building_documents(id)',
                'status': 'varchar DEFAULT \'draft\'',  # draft, approved, archived
                'created_at': 'timestamp with time zone DEFAULT now()',
                'notes': 'text'
            },
            'apportionments': {
                'id': 'uuid PRIMARY KEY DEFAULT gen_random_uuid()',
                'unit_id': 'uuid NOT NULL REFERENCES units(id)',
                'budget_id': 'uuid NOT NULL REFERENCES budgets(id)',
                'amount': 'decimal NOT NULL',
                'percentage': 'decimal',
                'created_at': 'timestamp with time zone DEFAULT now()'
            },
            'major_works_notices': {
                'id': 'uuid PRIMARY KEY DEFAULT gen_random_uuid()',
                'project_id': 'uuid NOT NULL REFERENCES major_works_projects(id)',
                'type': 'varchar NOT NULL',  # NOI, SOE, contractor_quote, final_account
                'document_id': 'uuid REFERENCES building_documents(id)',
                'notice_date': 'date',
                'created_at': 'timestamp with time zone DEFAULT now()'
            },
            'building_compliance_assets': {
                'id': 'uuid PRIMARY KEY DEFAULT gen_random_uuid()',
                'building_id': 'uuid NOT NULL REFERENCES buildings(id)',
                'compliance_asset_id': 'uuid REFERENCES compliance_assets(id)',
                'document_id': 'uuid REFERENCES building_documents(id)',
                'last_test_date': 'date',
                'next_due_date': 'date',
                'status': 'varchar',  # compliant, overdue, due_soon, pending
                'frequency': 'varchar',  # annual, biennial, quinquennial
                'created_at': 'timestamp with time zone DEFAULT now()',
                'notes': 'text'
            },
            'uncategorised_docs': {
                'id': 'uuid PRIMARY KEY DEFAULT gen_random_uuid()',
                'building_id': 'uuid NOT NULL REFERENCES buildings(id)',
                'document_id': 'uuid REFERENCES building_documents(id)',
                'file_name': 'text NOT NULL',
                'storage_path': 'text',
                'review_status': 'varchar DEFAULT \'pending\'',  # pending, reviewed, categorized
                'suggested_category': 'text',
                'manual_category': 'text',
                'created_at': 'timestamp with time zone DEFAULT now()',
                'reviewed_at': 'timestamp with time zone',
                'notes': 'text'
            }
        }
    
    def _normalize_category(self, raw_category: str, filename: str = None) -> str:
        """
        Normalize category to BlocIQ V2 standard categories.
        Returns one of: compliance, finance, major_works, lease, contracts, correspondence, uncategorised

        Uses both classifier category AND filename for accurate mapping
        """
        if not raw_category:
            raw_category = 'uncategorised'

        raw_lower = raw_category.lower()
        filename_lower = filename.lower() if filename else ''

        # PRIORITY 1: Filename-based detection (most accurate)
        if filename:
            # Compliance keywords
            if any(kw in filename_lower for kw in ['eicr', 'electrical', 'fire risk', 'fra', 'fire door',
                                                     'legionella', 'insurance', 'pat test', 'gas safety',
                                                     'emergency light', 'fire extinguish', 'loler', 'lift inspection']):
                return 'compliance'

            # Finance keywords
            elif any(kw in filename_lower for kw in ['budget', 'account', 'invoice', 'apportionment',
                                                       'demand', 'service charge', 'finance']):
                return 'finance'

            # Major works keywords
            elif any(kw in filename_lower for kw in ['section 20', 's20', 'noi', 'soe', 'statement of estimate',
                                                       'notice of intention', 'major works', 'contractor quote']):
                return 'major_works'

            # Lease keywords
            elif any(kw in filename_lower for kw in ['lease', 'deed', 'covenant', 'lpe1', 'official copy']):
                return 'lease'

            # Contract keywords
            elif any(kw in filename_lower for kw in ['contract', 'agreement', 'proposal', 'quotation', 'quote']):
                return 'contracts'

            # Correspondence keywords
            elif any(kw in filename_lower for kw in ['letter', 'memo', 'notice', 'correspondence']):
                return 'correspondence'

        # PRIORITY 2: Classifier category mapping
        category_map = {
            'compliance': 'compliance',
            'budgets': 'finance',
            'apportionments': 'finance',
            'major_works': 'major_works',
            'units_leaseholders': 'lease',
            'contracts': 'contracts',
            'insurance': 'compliance',
            'correspondence': 'correspondence',
            'uncategorized': 'uncategorised'
        }

        # Direct mapping
        if raw_lower in category_map:
            return category_map[raw_lower]

        # PRIORITY 3: Fuzzy matching on category name
        if 'compliance' in raw_lower or 'eicr' in raw_lower or 'fra' in raw_lower:
            return 'compliance'
        elif 'budget' in raw_lower or 'finance' in raw_lower or 'apport' in raw_lower:
            return 'finance'
        elif 'major' in raw_lower or 'works' in raw_lower or 'section' in raw_lower:
            return 'major_works'
        elif 'lease' in raw_lower or 'leaseholder' in raw_lower:
            return 'lease'
        elif 'contract' in raw_lower:
            return 'contracts'
        elif 'letter' in raw_lower or 'correspondence' in raw_lower:
            return 'correspondence'

        return 'uncategorised'

    def map_building(self, property_form_data: Dict, leaseholder_data: Dict = None) -> Dict:
        """Map to buildings table with exact column names - ENHANCED to capture all available fields"""
        building = {
            'id': str(uuid.uuid4()),
            'agency_id': self.agency_id,
            'building_type': 'residential'
        }

        # Extract from property form
        if property_form_data:
            # Core fields
            building['name'] = self._extract_building_name(property_form_data)
            building['client_name'] = self._extract_field(property_form_data, ['client name', 'management company', 'freeholder'])
            building['unit_count'] = self._extract_number(property_form_data, ['number of units', 'total units', 'units'])
            building['operational_notes'] = self._build_operational_notes(property_form_data)

            # Financial fields
            building['service_charge_frequency'] = self._extract_field(property_form_data, ['demand dates', 'service charge frequency'])
            building['ground_rent_amount'] = self._extract_currency(property_form_data, ['ground rent', 'ground rent amount'])
            building['ground_rent_frequency'] = self._extract_field(property_form_data, ['ground rent frequency', 'rent frequency'])

            # Location & Council
            building['council_borough'] = self._extract_field(property_form_data, ['borough', 'council', 'local authority'])

            # Building Manager & Emergency Contacts
            building['building_manager_name'] = self._extract_field(property_form_data, ['building manager', 'site manager', 'property manager'])
            building['building_manager_email'] = self._extract_field(property_form_data, ['manager email', 'building manager email'])
            building['building_manager_phone'] = self._extract_field(property_form_data, ['manager phone', 'building manager phone', 'manager telephone'])
            building['emergency_contact_name'] = self._extract_field(property_form_data, ['emergency contact', 'emergency name'])
            building['emergency_contact_phone'] = self._extract_field(property_form_data, ['emergency phone', 'emergency number', 'emergency telephone'])

            # Physical characteristics
            building['building_age'] = self._extract_field(property_form_data, ['year built', 'building age', 'construction year', 'built'])
            building['construction_type'] = self._extract_field(property_form_data, ['construction type', 'construction', 'building construction'])
            building['total_floors'] = self._extract_field(property_form_data, ['total floors', 'number of floors', 'floors', 'storeys'])
            building['lift_available'] = self._extract_boolean(property_form_data, ['lift', 'elevator', 'lift available'])
            building['heating_type'] = self._extract_field(property_form_data, ['heating', 'heating type', 'heating system'])
            building['hot_water_type'] = self._extract_field(property_form_data, ['hot water', 'hot water type', 'water heating'])

            # Waste & Recycling
            building['waste_collection_day'] = self._extract_field(property_form_data, ['waste collection', 'bin day', 'rubbish collection'])
            building['recycling_info'] = self._extract_field(property_form_data, ['recycling', 'recycling info', 'recycling collection'])

            # Insurance
            building['building_insurance_provider'] = self._extract_field(property_form_data, ['insurance provider', 'insurer', 'insurance company'])
            building['building_insurance_expiry'] = self._extract_date(property_form_data, ['insurance expiry', 'insurance renewal', 'insurance expires'])

            # Compliance statuses
            building['fire_safety_status'] = self._extract_field(property_form_data, ['fire safety', 'fire safety status', 'fire risk'])
            building['asbestos_status'] = self._extract_field(property_form_data, ['asbestos', 'asbestos status', 'asbestos register'])
            building['energy_rating'] = self._extract_field(property_form_data, ['epc', 'energy rating', 'energy performance'])

            # Access & Security
            building['notes'] = self._extract_field(property_form_data, ['notes', 'additional notes', 'comments'])
            building['key_access_notes'] = self._extract_field(property_form_data, ['key access', 'access notes', 'keys'])
            building['entry_code'] = self._extract_field(property_form_data, ['entry code', 'door code', 'access code'])
            building['fire_panel_location'] = self._extract_field(property_form_data, ['fire panel', 'fire alarm panel', 'fire control'])

        # Extract address - try property form first, then leaseholder data, then folder name
        address = None
        if property_form_data:
            address = self._extract_building_address_from_property_form(property_form_data)
        if not address and leaseholder_data:
            address = self._extract_building_address(leaseholder_data)
        if not address and self.folder_name:
            # Extract from folder name like "219.01 CONNAUGHT SQUARE"
            import re
            match = re.search(r'([A-Z][A-Za-z\s]+SQUARE|[A-Z][A-Za-z\s]+ROAD|[A-Z][A-Za-z\s]+STREET)', self.folder_name)
            if match:
                address = match.group(1).strip()
        building['address'] = address or ''

        return building
    
    def map_units(self, leaseholder_data: Dict, building_id: str) -> List[Dict]:
        """Map to units table with exact column names - ENHANCED to capture apportionment"""
        units = []

        # Handle Excel sheet structure: extract raw_data from first sheet if nested
        raw_data = leaseholder_data.get('raw_data', [])

        if not raw_data and 'data' in leaseholder_data:
            # Excel files have nested structure: data -> {sheet_name} -> raw_data
            data_value = leaseholder_data['data']
            if isinstance(data_value, dict):
                for sheet_name, sheet_data in data_value.items():
                    if isinstance(sheet_data, dict) and 'raw_data' in sheet_data:
                        raw_data = sheet_data['raw_data']
                        break  # Use first sheet with data

        for row in raw_data:
            unit_number = self._extract_unit_number(row)
            if not unit_number or self._is_special_unit(unit_number):
                continue

            unit = {
                'id': str(uuid.uuid4()),
                'building_id': building_id,
                'unit_number': unit_number,
                'type': 'flat',
                'floor': self._calculate_floor(unit_number)
            }

            # Extract apportionment percentage if available
            apportionment = self._extract_field_from_row(row, ['rate', 'percentage', 'apportionment', '%', 'percent'])
            if apportionment:
                # Clean the value - remove % sign and convert to decimal
                try:
                    apportionment_clean = str(apportionment).replace('%', '').strip()
                    unit['apportionment_percent'] = float(apportionment_clean)
                except (ValueError, AttributeError):
                    pass

            units.append(unit)

        return units
    
    def map_leaseholders(self, leaseholder_data: Dict, unit_map: Dict[str, str]) -> List[Dict]:
        """Map to leaseholders table with exact column names"""
        leaseholders = []

        # Check if this is a Tenancy Schedule PDF (text-based extraction)
        file_name = leaseholder_data.get('file_name', '')
        if 'tenancy schedule' in file_name.lower() and 'full_text' in leaseholder_data:
            return self._extract_leaseholders_from_tenancy_schedule(leaseholder_data, unit_map)

        # Handle Excel sheet structure: extract raw_data from first sheet if nested
        raw_data = leaseholder_data.get('raw_data', [])
        if not raw_data and 'data' in leaseholder_data:
            # Excel files have nested structure: data -> {sheet_name} -> raw_data
            for sheet_name, sheet_data in leaseholder_data['data'].items():
                if 'raw_data' in sheet_data:
                    raw_data = sheet_data['raw_data']
                    break  # Use first sheet with data

        for row in raw_data:
            unit_number = self._extract_unit_number(row)
            if not unit_number or self._is_special_unit(unit_number):
                continue
                
            unit_id = unit_map.get(unit_number)
            if not unit_id:
                continue
                
            name = self._extract_field_from_row(row, ['name', 'leaseholder', 'owner'])
            if not name:
                continue
                
            leaseholder = {
                'id': str(uuid.uuid4()),
                'unit_id': unit_id,
                'name': name,
                'full_name': name,
                'phone': self._extract_field_from_row(row, ['telephone', 'phone', 'mobile']),
                'phone_number': self._extract_field_from_row(row, ['telephone', 'phone', 'mobile']),
                'email': self._extract_field_from_row(row, ['email', 'email address']),
                'correspondence_address': self._extract_field_from_row(row, ['address', 'correspondence address']),
                'is_director': False
            }
            leaseholders.append(leaseholder)
        
        return leaseholders
    
    def map_building_documents(self, file_metadata: Dict, building_id: str, category: str = None,
                               linked_entity_id: str = None, entity_type: str = None, document_id: str = None) -> Dict:
        """
        Map to building_documents table - BlocIQ V2 compliant
        ALWAYS sets a valid category (compliance, finance, major_works, lease, contracts, correspondence, uncategorised)
        Uses filename-based detection for accurate categorization
        """
        filename = file_metadata['file_name']

        # Normalize category to V2 standards using both category and filename - NEVER None
        normalized_category = self._normalize_category(category, filename)

        # Build structured storage path
        storage_path = f"/building_documents/{building_id}/{normalized_category}/{filename}"

        doc_record = {
            'id': str(uuid.uuid4()),
            'building_id': building_id,
            'file_name': filename,
            'file_type': self._get_file_extension(filename),
            'storage_path': storage_path,
            'file_size': file_metadata.get('file_size', 0),
            'category': normalized_category,  # REQUIRED - never NULL, filename-aware
            'linked_entity_id': linked_entity_id,
            'entity_type': entity_type,
            'document_id': document_id,
            'confidence': file_metadata.get('confidence', 0.0),
            'confidence_level': self._get_confidence_level(file_metadata.get('confidence', 0.0)),
            'type': category,  # DEPRECATED: keep for backward compat
            'is_unlinked': False
        }

        return doc_record
    
    def get_table_columns(self, table_name: str) -> List[str]:
        """Get list of column names for a table"""
        return list(self.table_schemas.get(table_name, {}).keys())
    
    def validate_data(self, table_name: str, data: Dict) -> Dict:
        """Validate and filter data to only include valid columns"""
        valid_columns = self.get_table_columns(table_name)
        return {k: v for k, v in data.items() if k in valid_columns}
    
    # Helper methods (same as before)
    def _extract_building_name(self, data: Dict) -> str:
        """Extract building name from various sources with priority order"""
        import re

        # Priority 1: Extract from folder name (e.g., "219.01 CONNAUGHT SQUARE" -> "Connaught Square")
        if self.folder_name:
            # Remove common prefixes like numbers, dots, and clean up
            folder_cleaned = re.sub(r'^\d+(\.\d+)?\s+', '', self.folder_name, flags=re.IGNORECASE)
            folder_cleaned = folder_cleaned.strip()
            if folder_cleaned and len(folder_cleaned) > 3:
                return folder_cleaned.title()

        # Priority 2: Extract from property form filename
        if 'file_name' in data:
            filename = data['file_name']
            name = re.sub(r'\s*(property|form|setup|information).*', '', filename, flags=re.IGNORECASE)
            name = re.sub(r'\.(xlsx|xls|pdf|docx)$', '', name, flags=re.IGNORECASE)
            # Only use filename if it's not a generic placeholder and doesn't contain "important"
            if name and len(name) > 3 and 'important' not in name.lower():
                return name.strip().title()

        # Priority 3: Extract from property form data fields
        name = self._extract_field(data, ['property', 'building', 'name', 'address'])
        if name and 'important' not in name.lower():
            return name

        # Fallback
        return 'Unknown Building'
    
    def _extract_building_address(self, leaseholder_data: Dict) -> str:
        """Extract building address from leaseholder records"""
        raw_data = leaseholder_data.get('raw_data', [])
        for row in raw_data:
            address = self._extract_field_from_row(row, ['address'])
            if address and ',' in address:
                import re
                match = re.search(r'(\d+\s+[^,]+),', address)
                if match:
                    street = match.group(1)
                    postcode_match = re.search(r'[A-Z]{1,2}\d{1,2}[A-Z]?\s*\d[A-Z]{2}', address)
                    postcode = postcode_match.group(0) if postcode_match else ''
                    return f"{street}, London, {postcode}".strip()
        return ''

    def _extract_building_address_from_property_form(self, property_form_data: Dict) -> Optional[str]:
        """Extract building address from property information form"""
        # Try to extract from 'Client Name & Address' field
        address = self._extract_field(property_form_data, ['client name & address', 'address', 'property address'])
        if address:
            import re
            # Clean up the address - remove company name, keep actual address
            lines = address.split('\n')
            if len(lines) >= 2:
                # Second line is usually the actual address
                return lines[1].strip()
            # Try to extract address pattern
            match = re.search(r'(\d+[-/]?\d*\s+[A-Z][a-z]+\s+[A-Z][a-z]+(?:\s+[A-Z][a-z]+)?[^,\n]*(?:,\s*[^,\n]+)?(?:,\s*London)?(?:,?\s*[A-Z]{1,2}\d{1,2}[A-Z]?\s*\d[A-Z]{2})?)', address, re.IGNORECASE)
            if match:
                return match.group(1).strip()
        return None

    def _extract_leaseholders_from_tenancy_schedule(self, file_data: Dict, unit_map: Dict[str, str]) -> List[Dict]:
        """Extract leaseholders from Tenancy Schedule PDF text"""
        leaseholders = []
        text = file_data.get('full_text', '')

        # Parse lines like: "Flat 1, 32-34 Connaught Square Marmotte Holdings Limited n/a"
        # Pattern: "Flat X, [address] [Name] n/a"
        import re
        # Match: Flat X, then skip address (number + street name), capture only the name before "n/a"
        # The pattern skips "32-34 Connaught Square" and captures "Marmotte Holdings Limited"
        pattern = r'(Flat\s+\d+),\s+[\d\-]+\s+[A-Za-z\s]+?Square\s+([^\n]+?)\s+n/a'

        for match in re.finditer(pattern, text):
            unit_number = match.group(1).strip()  # "Flat 1"
            leaseholder_name = match.group(2).strip()  # "Marmotte Holdings Limited"

            unit_id = unit_map.get(unit_number)
            if not unit_id:
                continue

            leaseholder = {
                'id': str(uuid.uuid4()),
                'unit_id': unit_id,
                'name': leaseholder_name,
                'full_name': leaseholder_name,
                'phone': None,
                'phone_number': None,
                'email': None,
                'correspondence_address': None,
                'is_director': False
            }
            leaseholders.append(leaseholder)

        return leaseholders

    def _extract_unit_number(self, row: Dict) -> Optional[str]:
        """Extract unit number from row data"""
        # First try 'Unit description' column (priority for apportionment files)
        unit_field = self._extract_field_from_row(row, ['unit description', 'unit_description', 'description', 'unit', 'flat', 'property'])

        # If not found, try 'Unit reference' column
        if not unit_field:
            unit_field = self._extract_field_from_row(row, ['unit reference', 'unit_reference', 'reference', 'ref'])

        if not unit_field:
            return None

        import re
        # Try pattern: "Flat 1", "Flat 2", etc.
        match = re.search(r'Flat\s+(\d+)', unit_field, re.IGNORECASE)
        if match:
            return f"Flat {match.group(1)}"

        # Try pattern: "Flat A1", "Flat B2", etc.
        match = re.search(r'Flat\s+([A-Z]\d+)', unit_field, re.IGNORECASE)
        if match:
            return match.group(1).upper()

        # Try pattern: "A1", "B2", etc.
        match = re.search(r'\b([A-Z]\d+)\b', unit_field)
        if match:
            return match.group(1).upper()

        # Try reference number pattern: "219-01-001" -> extract number and format as Flat X
        match = re.search(r'\d+-\d+-(\d+)', unit_field)
        if match:
            unit_num = int(match.group(1))
            return f"Flat {unit_num}"

        return None
    
    def _is_special_unit(self, unit_number: str) -> bool:
        """Check if unit is parking, storage, etc."""
        special_keywords = ['parking', 'storage', 'garage', 'space', 'shared', 'court']
        return any(keyword in unit_number.lower() for keyword in special_keywords)
    
    def _calculate_floor(self, unit_number: str) -> int:
        """Calculate floor from unit number (A=1, B=2, etc.)"""
        if unit_number and unit_number[0].isalpha():
            return ord(unit_number[0].upper()) - ord('A') + 1
        return 0
    
    def _extract_field(self, data: Dict, keywords: List[str]) -> Optional[str]:
        """Extract field value from parsed data using keywords"""
        if 'data' in data and isinstance(data['data'], dict):
            for sheet_data in data['data'].values():
                if 'raw_data' in sheet_data:
                    for row in sheet_data['raw_data']:
                        # Handle dict rows (modern Excel format)
                        if isinstance(row, dict):
                            # Look for keywords in VALUES of first column
                            row_values = list(row.values())
                            if len(row_values) >= 2:
                                first_col = str(row_values[0]).lower().strip() if row_values[0] is not None else ''
                                for keyword in keywords:
                                    if keyword.lower() in first_col:
                                        # Return value from second column
                                        if row_values[1] is not None and str(row_values[1]) != 'nan':
                                            return str(row_values[1]).strip()
                                        return None
                        # Handle list rows (legacy format)
                        elif isinstance(row, list) and len(row) >= 2:
                            for keyword in keywords:
                                if keyword.lower() in str(row[0]).lower():
                                    return str(row[1]).strip()
        return None
    
    def _extract_field_from_row(self, row: Dict, keywords: List[str]) -> Optional[str]:
        """Extract field from a single row by matching keywords"""
        for keyword in keywords:
            for key, value in row.items():
                if keyword.lower() in str(key).lower():
                    return str(value).strip() if value else None
        return None
    
    def _extract_number(self, data: Dict, keywords: List[str]) -> Optional[int]:
        """Extract numeric value"""
        value = self._extract_field(data, keywords)
        if value:
            import re
            match = re.search(r'\d+', value)
            return int(match.group()) if match else None
        return None
    
    def _extract_currency(self, data: Dict, keywords: List[str]) -> Optional[float]:
        """Extract currency value"""
        value = self._extract_field(data, keywords)
        if value:
            import re
            cleaned = re.sub(r'[£$,]', '', value)
            match = re.search(r'[\d.]+', cleaned)
            return float(match.group()) if match else None
        return None
    
    def _build_operational_notes(self, data: Dict) -> str:
        """Build operational notes from property form data"""
        notes_parts = []
        fields_to_extract = [
            ('Date of Commencement', ['commencement', 'start date', 'commenced']),
            ('Year End', ['year end']),
            ('Demand Dates', ['demand dates']),
            ('Ground Rent', ['ground rent']),
            ('Previous Agents', ['previous agents']),
            ('Management Fee', ['management fee'])
        ]
        
        for label, keywords in fields_to_extract:
            value = self._extract_field(data, keywords)
            if value:
                notes_parts.append(f"{label}: {value}")
        
        return '\n'.join(notes_parts)
    
    def _get_file_extension(self, filename: str) -> str:
        """Extract file extension from filename"""
        import os
        return os.path.splitext(filename)[1].lower().lstrip('.')
    
    def _get_confidence_level(self, confidence: float) -> str:
        """Convert confidence score to level"""
        if confidence >= 0.8:
            return 'high'
        elif confidence >= 0.6:
            return 'medium'
        elif confidence >= 0.4:
            return 'low'
        else:
            return 'very_low'

    def _extract_boolean(self, data: Dict, keywords: List[str]) -> Optional[bool]:
        """Extract boolean value from text"""
        value = self._extract_field(data, keywords)
        if value:
            value_lower = str(value).lower().strip()
            if value_lower in ['yes', 'y', 'true', '1', 'available', 'present']:
                return True
            elif value_lower in ['no', 'n', 'false', '0', 'not available', 'none']:
                return False
        return None

    def _extract_date(self, data: Dict, keywords: List[str]) -> Optional[str]:
        """Extract and normalize date value to ISO format"""
        value = self._extract_field(data, keywords)
        if value:
            # Try to parse common date formats
            import re
            from datetime import datetime

            # Try DD/MM/YYYY or DD-MM-YYYY
            match = re.search(r'(\d{1,2})[/-](\d{1,2})[/-](\d{4})', value)
            if match:
                day, month, year = match.groups()
                try:
                    date_obj = datetime(int(year), int(month), int(day))
                    return date_obj.date().isoformat()
                except ValueError:
                    pass

            # Try YYYY-MM-DD (ISO format)
            match = re.search(r'(\d{4})-(\d{1,2})-(\d{1,2})', value)
            if match:
                year, month, day = match.groups()
                try:
                    date_obj = datetime(int(year), int(month), int(day))
                    return date_obj.date().isoformat()
                except ValueError:
                    pass

        return None

    def map_compliance_asset(self, file_metadata: Dict, building_id: str, category: str) -> Dict:
        """
        Map compliance document to compliance_assets table - BlocIQ V2 DUAL-WRITE PATTERN
        Detects compliance subtype: EICR (5yr), FRA (annual), Fire Door (annual), LOLER (6mo), Insurance (annual)
        """
        import re
        from datetime import datetime, timedelta
        from dateutil.relativedelta import relativedelta

        # Extract compliance type from filename/category
        file_name = file_metadata['file_name'].lower()

        # BlocIQ V2 Compliance Subtype Detection with Frequencies
        # EICR: 5 years, FRA: annual, Fire Door: annual, LOLER: 6 months, Insurance: annual
        asset_type_map = {
            'loler': ('Lift Inspection (LOLER)', 'lift_safety', 'biannual', 6),
            'lift inspection': ('Lift Inspection (LOLER)', 'lift_safety', 'biannual', 6),
            'lift': ('Lift Inspection (LOLER)', 'lift_safety', 'biannual', 6),
            'eicr': ('Electrical Installation Condition Report (EICR)', 'electrical', 'quinquennial', 60),
            'electrical': ('Electrical Installation Condition Report (EICR)', 'electrical', 'quinquennial', 60),
            'fire door': ('Fire Door Inspection', 'fire_safety', 'annual', 12),
            'fra': ('Fire Risk Assessment (FRA)', 'fire_safety', 'annual', 12),
            'fire risk': ('Fire Risk Assessment (FRA)', 'fire_safety', 'annual', 12),
            'insurance': ('Building Insurance Policy', 'insurance', 'annual', 12),
            'legionella': ('Legionella Risk Assessment', 'water_safety', 'biennial', 24),
            'water': ('Legionella Risk Assessment', 'water_safety', 'biennial', 24),
            'gas': ('Gas Safety Certificate', 'gas_safety', 'annual', 12),
            'emergency light': ('Emergency Lighting Testing', 'electrical', 'annual', 12),
            'fire extinguisher': ('Fire Extinguisher Servicing', 'fire_safety', 'annual', 12),
            'pat': ('Portable Appliance Testing (PAT)', 'electrical', 'annual', 12)
        }

        asset_name = 'Compliance Asset'
        asset_type = 'general'
        frequency = 'annual'
        frequency_months = 12

        # Priority order: most specific first (LOLER > lift, fire door > fire)
        for key, (name, type_, freq, freq_months) in asset_type_map.items():
            if key in file_name:
                asset_name = name
                asset_type = type_
                frequency = freq
                frequency_months = freq_months
                break

        # Try to extract dates from filename
        # Patterns: 2023, 2023-2024, 01.23, DD.MM.YY, etc.
        last_inspection_date = None
        next_due_date = None

        # Try to find year in filename (prioritize 4-digit years)
        year_match = re.search(r'20(\d{2})', file_name)
        if year_match:
            year = int(f"20{year_match.group(1)}")
            # Assume inspection was in January of that year
            try:
                last_inspection_date = f"{year}-01-01"
                # Calculate next due date using frequency_months
                inspection_date = datetime(year, 1, 1)
                next_due = inspection_date + relativedelta(months=frequency_months)
                next_due_date = next_due.date().isoformat()
            except:
                pass

        # Determine status based on next_due_date
        status = 'pending'
        if next_due_date:
            try:
                due_date_obj = datetime.fromisoformat(next_due_date)
                today = datetime.now()
                if due_date_obj < today:
                    status = 'overdue'
                elif (due_date_obj - today).days < 30:
                    status = 'due_soon'
                else:
                    status = 'compliant'
            except:
                pass

        return {
            'id': str(uuid.uuid4()),
            'building_id': building_id,
            'asset_name': asset_name,
            'asset_type': asset_type,
            'category': category if category == 'compliance' else 'compliance',
            'description': f"Extracted from {file_metadata['file_name']}",
            'is_required': True,
            'is_active': True,
            'inspection_frequency': frequency,
            'frequency_months': frequency_months,
            'status': status,
            'last_inspection_date': last_inspection_date,
            'next_due_date': next_due_date,
            'notes': f"Auto-imported from document: {file_metadata['file_name']}"
        }

    def map_budget(self, file_metadata: Dict, building_id: str, document_id: str) -> Dict:
        """
        Map budget document to budgets table - BlocIQ V2
        Detects finance subtype: Budget, Service Charge Account, Invoice
        """
        import re

        file_name = file_metadata['file_name']
        file_name_lower = file_name.lower()

        # Detect finance subtype
        finance_subtype = 'budget'  # Default
        if 'account' in file_name_lower or 'year end' in file_name_lower:
            finance_subtype = 'service_charge_account'
        elif 'invoice' in file_name_lower or 'demand' in file_name_lower:
            finance_subtype = 'invoice'
        elif 'budget' in file_name_lower:
            finance_subtype = 'budget'

        # Extract period from filename (YE24, 2024-2025, etc.)
        period = 'Unknown'

        # Try YE format (YE24, YE 2024, etc.)
        ye_match = re.search(r'YE\s*(\d{2,4})', file_name, re.IGNORECASE)
        if ye_match:
            year = ye_match.group(1)
            if len(year) == 2:
                year = f"20{year}"
            period = f"YE{year}"
        else:
            # Try year range (2024-2025, 2024/2025)
            range_match = re.search(r'(\d{4})[-/](\d{4})', file_name)
            if range_match:
                period = f"{range_match.group(1)}-{range_match.group(2)}"
            else:
                # Try single year
                year_match = re.search(r'20(\d{2})', file_name)
                if year_match:
                    period = f"20{year_match.group(1)}"

        # Determine status based on subtype
        status = 'draft'
        if finance_subtype == 'service_charge_account':
            status = 'approved'  # Accounts are typically finalized
        elif finance_subtype == 'invoice':
            status = 'approved'  # Invoices are typically sent/approved

        return {
            'id': str(uuid.uuid4()),
            'building_id': building_id,
            'period': period,
            'document_id': document_id,
            'status': status,
            'finance_subtype': finance_subtype,  # budget, service_charge_account, invoice
            'notes': f"Auto-imported from {file_name} (Type: {finance_subtype})"
        }

    def map_major_works(self, file_metadata: Dict, building_id: str) -> Dict:
        """
        Map major works document to major_works_projects table - BlocIQ V2
        Detects notice type: NOI (Notice of Intention), SOE (Statement of Estimates), Final Notice
        """
        import re
        from datetime import datetime

        file_name = file_metadata['file_name']
        file_name_lower = file_name.lower()

        # BlocIQ V2: Determine notice type from filename
        project_type = 'general'
        notice_type = None

        # Priority detection for notice types
        if 'final notice' in file_name_lower or 'final account' in file_name_lower:
            project_type = 'section_20'
            notice_type = 'final_notice'
        elif 'soe' in file_name_lower or 'statement of estimate' in file_name_lower:
            project_type = 'section_20'
            notice_type = 'SOE'
        elif 'noi' in file_name_lower or 'notice of intention' in file_name_lower:
            project_type = 'section_20'
            notice_type = 'NOI'
        elif 'section 20' in file_name_lower or 's20' in file_name_lower:
            project_type = 'section_20'
            notice_type = 'NOI'  # Default Section 20 to NOI
        elif 'contractor' in file_name_lower or 'quote' in file_name_lower or 'quotation' in file_name_lower:
            notice_type = 'contractor_quote'

        # Extract year if present
        year_match = re.search(r'20(\d{2})', file_name)
        year = f"20{year_match.group(1)}" if year_match else datetime.now().year

        # Create descriptive title based on notice type
        if notice_type == 'NOI':
            title = f"Section 20 Consultation (NOI) - {year}"
        elif notice_type == 'SOE':
            title = f"Section 20 Consultation (SOE) - {year}"
        elif notice_type == 'final_notice':
            title = f"Section 20 Consultation (Final) - {year}"
        elif 'section 20' in file_name_lower:
            title = f"Section 20 Consultation - {year}"
        else:
            title = f"Major Works Project - {year}"

        return {
            'id': str(uuid.uuid4()),
            'building_id': building_id,
            'title': title,
            'name': title,
            'description': f"Extracted from {file_name}",
            'project_type': project_type,
            'status': 'planned',
            'start_date': f"{year}-01-01",
            'is_active': True,
            'notice_type': notice_type,  # NOI, SOE, final_notice, contractor_quote
            'notes': f"Auto-imported from document: {file_name} (Notice Type: {notice_type})"
        }, notice_type

    def map_major_works_notice(self, project_id: str, document_id: str, notice_type: str = 'NOI') -> Dict:
        """Map major works notice - links project to document"""
        return {
            'id': str(uuid.uuid4()),
            'project_id': project_id,
            'document_id': document_id,
            'type': notice_type,
            'notice_date': datetime.now().date().isoformat()
        }

    def map_building_compliance_asset(self, building_id: str, compliance_asset_id: str, document_id: str,
                                      last_test_date: str = None, next_due_date: str = None,
                                      status: str = 'pending', frequency: str = 'annual') -> Dict:
        """Map building compliance asset - links compliance to building and document"""
        return {
            'id': str(uuid.uuid4()),
            'building_id': building_id,
            'compliance_asset_id': compliance_asset_id,
            'document_id': document_id,
            'last_test_date': last_test_date,
            'next_due_date': next_due_date,
            'status': status,
            'frequency': frequency,
            'notes': 'Auto-imported from onboarding'
        }

    def map_uncategorised_doc(self, building_id: str, document_id: str, file_name: str,
                             storage_path: str, raw_category: str = None) -> Dict:
        """
        Map uncategorised document for manual review - BlocIQ V2
        Tracks documents that couldn't be automatically categorized
        """
        return {
            'id': str(uuid.uuid4()),
            'building_id': building_id,
            'document_id': document_id,
            'file_name': file_name,
            'storage_path': storage_path,
            'review_status': 'pending',
            'suggested_category': raw_category,  # Original classifier category for reference
            'notes': f"Auto-imported but could not be categorized. Original category: {raw_category}"
        }
