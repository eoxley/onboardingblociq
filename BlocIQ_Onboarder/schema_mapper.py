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
    
    def __init__(self, agency_id: str = '00000000-0000-0000-0000-000000000001'):
        self.agency_id = agency_id
        
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
                'apportionment_percent': 'numeric',
                'created_at': 'timestamp with time zone DEFAULT now()',
                'updated_at': 'timestamp with time zone DEFAULT now()'
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
                'is_director': 'boolean DEFAULT false',
                'created_at': 'timestamp with time zone DEFAULT now()',
                'updated_at': 'timestamp with time zone DEFAULT now()'
            },
            'building_documents': {
                'id': 'uuid PRIMARY KEY DEFAULT gen_random_uuid()',
                'building_id': 'uuid NOT NULL REFERENCES buildings(id)',
                'file_name': 'text NOT NULL',  # NOT document_name
                'file_type': 'text',  # NOT document_type
                'storage_path': 'text',  # NOT file_path
                'file_size': 'bigint',
                'type': 'text',  # category/classification
                'confidence': 'numeric',
                'confidence_level': 'text',
                'is_unlinked': 'boolean DEFAULT false',
                'auto_linked_building_id': 'uuid REFERENCES buildings(id)',
                'unit_id': 'uuid REFERENCES units(id)',
                'leaseholder_id': 'uuid REFERENCES leaseholders(id)',
                'uploaded_by': 'uuid REFERENCES users(id)',
                'created_at': 'timestamp with time zone DEFAULT now()',
                'updated_at': 'timestamp with time zone DEFAULT now()'
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
                'custom_asset': 'boolean DEFAULT false',
                'created_at': 'timestamp with time zone DEFAULT now()',
                'updated_at': 'timestamp with time zone DEFAULT now()'
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
                'compliance_notes': 'text',
                'created_at': 'timestamp with time zone DEFAULT now()',
                'updated_at': 'timestamp with time zone DEFAULT now()'
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
                'notes': 'text',
                'created_at': 'timestamp with time zone DEFAULT now()',
                'updated_at': 'timestamp with time zone DEFAULT now()'
            }
        }
    
    def map_building(self, property_form_data: Dict, leaseholder_data: Dict = None) -> Dict:
        """Map to buildings table with exact column names - ENHANCED to capture all available fields"""
        building = {
            'id': str(uuid.uuid4()),
            'agency_id': self.agency_id,
            'building_type': 'residential',
            'created_at': datetime.now().isoformat(),
            'updated_at': datetime.now().isoformat()
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

        # Extract address from leaseholder data
        if leaseholder_data:
            building['address'] = self._extract_building_address(leaseholder_data)

        return building
    
    def map_units(self, leaseholder_data: Dict, building_id: str) -> List[Dict]:
        """Map to units table with exact column names - ENHANCED to capture apportionment"""
        units = []
        raw_data = leaseholder_data.get('raw_data', [])

        for row in raw_data:
            unit_number = self._extract_unit_number(row)
            if not unit_number or self._is_special_unit(unit_number):
                continue

            unit = {
                'id': str(uuid.uuid4()),
                'building_id': building_id,
                'unit_number': unit_number,
                'type': 'flat',
                'floor': self._calculate_floor(unit_number),
                'created_at': datetime.now().isoformat(),
                'updated_at': datetime.now().isoformat()
            }

            # Extract apportionment percentage (critical for service charge calculations)
            apportionment = self._extract_field_from_row(row, ['apportionment', 'apportionment %', 'percentage', '%'])
            if apportionment:
                import re
                # Extract numeric value, remove % sign
                cleaned = re.sub(r'[%\s]', '', str(apportionment))
                match = re.search(r'[\d.]+', cleaned)
                if match:
                    unit['apportionment_percent'] = float(match.group())

            units.append(unit)

        return units
    
    def map_leaseholders(self, leaseholder_data: Dict, unit_map: Dict[str, str]) -> List[Dict]:
        """Map to leaseholders table with exact column names"""
        leaseholders = []
        raw_data = leaseholder_data.get('raw_data', [])
        
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
                'is_director': False,
                'created_at': datetime.now().isoformat(),
                'updated_at': datetime.now().isoformat()
            }
            leaseholders.append(leaseholder)
        
        return leaseholders
    
    def map_building_documents(self, file_metadata: Dict, building_id: str, category: str = 'uncategorized') -> Dict:
        """Map to building_documents table with exact column names"""
        return {
            'id': str(uuid.uuid4()),
            'building_id': building_id,
            'file_name': file_metadata['file_name'],  # NOT document_name
            'file_type': self._get_file_extension(file_metadata['file_name']),  # NOT document_type
            'storage_path': file_metadata['file_path'],  # NOT file_path
            'file_size': file_metadata.get('file_size', 0),
            'type': category,  # classification/category
            'confidence': file_metadata.get('confidence', 0.0),
            'confidence_level': self._get_confidence_level(file_metadata.get('confidence', 0.0)),
            'is_unlinked': False,
            'created_at': datetime.now().isoformat(),
            'updated_at': datetime.now().isoformat()
        }
    
    def get_table_columns(self, table_name: str) -> List[str]:
        """Get list of column names for a table"""
        return list(self.table_schemas.get(table_name, {}).keys())
    
    def validate_data(self, table_name: str, data: Dict) -> Dict:
        """Validate and filter data to only include valid columns"""
        valid_columns = self.get_table_columns(table_name)
        return {k: v for k, v in data.items() if k in valid_columns}
    
    # Helper methods (same as before)
    def _extract_building_name(self, data: Dict) -> str:
        """Extract building name from various sources"""
        if 'file_name' in data:
            filename = data['file_name']
            import re
            name = re.sub(r'\s*(property|form|setup|information).*', '', filename, flags=re.IGNORECASE)
            name = re.sub(r'\.(xlsx|xls|pdf|docx)$', '', name, flags=re.IGNORECASE)
            if name and len(name) > 3:
                return name.strip().title()
        
        name = self._extract_field(data, ['property', 'building', 'name', 'address'])
        return name if name else 'Unknown Building'
    
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
    
    def _extract_unit_number(self, row: Dict) -> Optional[str]:
        """Extract unit number from row data"""
        unit_field = self._extract_field_from_row(row, ['unit', 'flat', 'property'])
        if not unit_field:
            return None
        
        import re
        match = re.search(r'Flat\s+([A-Z]\d+)', unit_field, re.IGNORECASE)
        if match:
            return match.group(1).upper()
        
        match = re.search(r'\b([A-Z]\d+)\b', unit_field)
        if match:
            return match.group(1).upper()
        
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
                        if isinstance(row, list) and len(row) >= 2:
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
