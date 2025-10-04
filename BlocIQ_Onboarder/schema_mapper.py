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
                'portfolio_id': 'uuid REFERENCES portfolios(id)',
                'name': 'text NOT NULL',
                'address': 'text',
                # Basic Info
                'number_of_units': 'integer',
                'previous_agents': 'text',
                # Accountants
                'current_accountants': 'text',
                'accountant_contact': 'text',
                # Financial Config
                'demand_date_1': 'date',
                'demand_date_2': 'date',
                'year_end_date': 'date',
                'management_fee_ex_vat': 'numeric',
                'management_fee_inc_vat': 'numeric',
                'company_secretary_fee_ex_vat': 'numeric',
                'company_secretary_fee_inc_vat': 'numeric',
                # Ground Rent
                'ground_rent_applicable': 'boolean',
                'ground_rent_charges': 'text',
                # Insurance
                'insurance_broker': 'text',
                'insurance_renewal_date': 'date',
                # Section 20 Limits
                'section_20_limit_inc_vat': 'numeric',
                'expenditure_limit': 'numeric',
                # Other
                'additional_info': 'text',
                'created_at': 'timestamp with time zone DEFAULT now()'
            },
            'units': {
                'id': 'uuid PRIMARY KEY DEFAULT gen_random_uuid()',
                'building_id': 'uuid NOT NULL REFERENCES buildings(id)',
                'unit_number': 'text NOT NULL',
                'created_at': 'timestamp with time zone DEFAULT now()'
            },
            'leaseholders': {
                'id': 'uuid PRIMARY KEY DEFAULT gen_random_uuid()',
                'unit_id': 'uuid NOT NULL REFERENCES units(id)',
                'name': 'text NOT NULL',
                'email': 'text',
                'correspondence_address': 'text',
                'created_at': 'timestamp with time zone DEFAULT now()'
            },
            'building_documents': {
                'id': 'uuid PRIMARY KEY DEFAULT gen_random_uuid()',
                'building_id': 'uuid NOT NULL REFERENCES buildings(id)',
                'category': 'text NOT NULL',  # compliance, finance, major_works, lease, contracts, correspondence, uncategorised
                'file_name': 'text NOT NULL',
                'storage_path': 'text NOT NULL',
                'entity_type': 'text',  # compliance_asset, budget, major_works_project, unit, leaseholder
                'linked_entity_id': 'uuid',
                'uploaded_at': 'timestamp with time zone DEFAULT now()'
            },
            'compliance_assets': {
                'id': 'uuid PRIMARY KEY DEFAULT gen_random_uuid()',
                'building_id': 'uuid NOT NULL REFERENCES buildings(id)',
                'asset_name': 'text NOT NULL',
                'asset_type': 'text NOT NULL',
                'inspection_frequency': 'interval',
                'description': 'text'
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
                'document_id': 'uuid REFERENCES building_documents(id)',
                'project_name': 'text NOT NULL',
                'status': 'text',
                'start_date': 'date',
                'end_date': 'date',
                'created_at': 'timestamp with time zone DEFAULT now()'
            },
            'budgets': {
                'id': 'uuid PRIMARY KEY DEFAULT gen_random_uuid()',
                'building_id': 'uuid NOT NULL REFERENCES buildings(id)',
                'document_id': 'uuid REFERENCES building_documents(id)',
                'period': 'text NOT NULL',  # e.g., '2024-2025', 'YE2024'
                'start_date': 'date',  # Budget period start
                'end_date': 'date',  # Budget period end
                'demand_date_1': 'date',  # First service charge demand date
                'demand_date_2': 'date',  # Second service charge demand date (if applicable)
                'year_end_date': 'date',  # Financial year end date
                'total_amount': 'numeric',
                'budget_type': 'text',  # 'service_charge', 'reserve_fund', 'sinking_fund'
                'created_at': 'timestamp with time zone DEFAULT now()'
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
            },
            'building_contractors': {
                'id': 'uuid PRIMARY KEY DEFAULT gen_random_uuid()',
                'building_id': 'uuid NOT NULL REFERENCES buildings(id)',
                'contractor_type': 'text NOT NULL',  # cleaning, gardening, lift, pumps, drains, gutters, aov, emergency_lighting, fire_alarm, ventilation, gates, entryphone, parking, water_tanks, solar_panels, window_cleaning
                'company_name': 'text',
                'contact_person': 'text',
                'phone': 'text',
                'email': 'text',
                'contract_start': 'date',
                'contract_end': 'date',
                'document_id': 'uuid REFERENCES building_documents(id)',
                'notes': 'text',
                'created_at': 'timestamp with time zone DEFAULT now()'
            },
            'building_utilities': {
                'id': 'uuid PRIMARY KEY DEFAULT gen_random_uuid()',
                'building_id': 'uuid NOT NULL REFERENCES buildings(id)',
                'utility_type': 'text NOT NULL',  # electricity, water, gas, phone, lift_line, meters_access, stopcock_location
                'provider_name': 'text',
                'account_number': 'text',
                'meter_numbers': 'text',
                'contact_phone': 'text',
                'location': 'text',
                'notes': 'text',
                'created_at': 'timestamp with time zone DEFAULT now()'
            },
            'building_insurance': {
                'id': 'uuid PRIMARY KEY DEFAULT gen_random_uuid()',
                'building_id': 'uuid NOT NULL REFERENCES buildings(id)',
                'insurance_type': 'text NOT NULL',  # building_terrorism, engineering, directors_and_officers, revaluation
                'broker_name': 'text',
                'insurer_name': 'text',
                'policy_number': 'text',
                'renewal_date': 'date',
                'coverage_amount': 'numeric',
                'premium_amount': 'numeric',
                'document_id': 'uuid REFERENCES building_documents(id)',
                'notes': 'text',
                'created_at': 'timestamp with time zone DEFAULT now()'
            },
            'building_legal': {
                'id': 'uuid PRIMARY KEY DEFAULT gen_random_uuid()',
                'building_id': 'uuid NOT NULL REFERENCES buildings(id)',
                'record_type': 'text NOT NULL',  # lease_dispute, contractor_dispute, litigation, solicitor, arrears
                'description': 'text',
                'party_name': 'text',
                'solicitor_name': 'text',
                'solicitor_contact': 'text',
                'status': 'text',  # active, resolved, pending
                'date_opened': 'date',
                'date_closed': 'date',
                'document_id': 'uuid REFERENCES building_documents(id)',
                'notes': 'text',
                'created_at': 'timestamp with time zone DEFAULT now()'
            },
            'building_statutory_reports': {
                'id': 'uuid PRIMARY KEY DEFAULT gen_random_uuid()',
                'building_id': 'uuid NOT NULL REFERENCES buildings(id)',
                'report_type': 'text NOT NULL',  # lift_reports, gas_safety, eicr, pat_testing, hsfra, water_hygiene, asbestos_register, fire_doors, emergency_lighting, aovs, fire_equipment, lightning_protection
                'document_id': 'uuid REFERENCES building_documents(id)',
                'report_date': 'date',
                'next_due_date': 'date',
                'status': 'text',  # current, overdue, due_soon
                'notes': 'text',
                'created_at': 'timestamp with time zone DEFAULT now()'
            },
            'building_keys_access': {
                'id': 'uuid PRIMARY KEY DEFAULT gen_random_uuid()',
                'building_id': 'uuid NOT NULL REFERENCES buildings(id)',
                'access_type': 'text NOT NULL',  # labelled_keys, gate_codes, entrance_codes, bin_store, bike_store
                'description': 'text',
                'code': 'text',  # Should be encrypted in production
                'location': 'text',
                'notes': 'text',
                'created_at': 'timestamp with time zone DEFAULT now()'
            },
            'building_warranties': {
                'id': 'uuid PRIMARY KEY DEFAULT gen_random_uuid()',
                'building_id': 'uuid NOT NULL REFERENCES buildings(id)',
                'item_type': 'text NOT NULL',  # pumps, boilers, gates, fire_alarm, damp_proofing, roofing
                'supplier': 'text',
                'installation_date': 'date',
                'warranty_expiry': 'date',
                'document_id': 'uuid REFERENCES building_documents(id)',
                'notes': 'text',
                'created_at': 'timestamp with time zone DEFAULT now()'
            },
            'company_secretary': {
                'id': 'uuid PRIMARY KEY DEFAULT gen_random_uuid()',
                'building_id': 'uuid NOT NULL REFERENCES buildings(id)',
                'company_house_filing_code': 'text',
                'memorandum_articles': 'text',
                'stock_transfer_forms': 'boolean',
                'certificate_of_incorporation': 'boolean',
                'seal_available': 'boolean',
                'audited_accounts_years': 'integer',
                'document_id': 'uuid REFERENCES building_documents(id)',
                'notes': 'text',
                'created_at': 'timestamp with time zone DEFAULT now()'
            },
            'building_staff': {
                'id': 'uuid PRIMARY KEY DEFAULT gen_random_uuid()',
                'building_id': 'uuid NOT NULL REFERENCES buildings(id)',
                'staff_type': 'text',  # employment_contracts, job_descriptions, paye_details, pension_provider, disciplinary_action, accidents_book
                'description': 'text',
                'employee_name': 'text',
                'position': 'text',
                'start_date': 'date',
                'end_date': 'date',
                'document_id': 'uuid REFERENCES building_documents(id)',
                'notes': 'text',
                'created_at': 'timestamp with time zone DEFAULT now()'
            },
            'building_title_deeds': {
                'id': 'uuid PRIMARY KEY DEFAULT gen_random_uuid()',
                'building_id': 'uuid NOT NULL REFERENCES buildings(id)',
                'record_type': 'text NOT NULL',  # freehold_title, head_lease, individual_leases, building_plans, as_built_drawings, om_manuals, cdm_manual, plant_machinery_docs, ongoing_major_works, planned_major_works
                'title_number': 'text',
                'description': 'text',
                'document_id': 'uuid REFERENCES building_documents(id)',
                'notes': 'text',
                'created_at': 'timestamp with time zone DEFAULT now()'
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
            # FALSE POSITIVE PREVENTION: Check finance keywords FIRST to prevent misclassification
            # "Accounts.xlsx" should NOT be classified as compliance even if it contains "fra" substring
            finance_keywords = ['budget', 'account', 'invoice', 'apportionment',
                               'demand', 'service charge', 'finance', 'year end', 'ye']
            if any(kw in filename_lower for kw in finance_keywords):
                return 'finance'

            # Compliance keywords - STRICT matching to prevent false positives
            # Only match if file explicitly contains compliance-specific terms
            compliance_keywords = {
                'eicr', 'electrical inspection', 'electrical installation',
                'fire risk assessment', 'fire risk', 'fra ',  # Note: "fra " with space to avoid "FRAming"
                'fire door inspection', 'fire door',
                'legionella risk', 'legionella assessment', 'legionella',
                'insurance certificate', 'insurance policy', 'building insurance',
                'pat test', 'portable appliance',
                'gas safety certificate', 'gas safety',
                'emergency light', 'emergency lighting',
                'fire extinguish',
                'loler', 'lift inspection', 'lift safety'
            }
            if any(kw in filename_lower for kw in compliance_keywords):
                return 'compliance'

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
        """
        Map to buildings table with exact column names - ENHANCED for full property form extraction

        Note: portfolio_id is added by SQL writer, not here
        Extracts all available fields from property information form
        """
        building = {
            'id': str(uuid.uuid4())
            # portfolio_id will be added by SQL writer
        }

        # Extract building name
        if property_form_data:
            building['name'] = self._extract_building_name(property_form_data)
        else:
            building['name'] = 'Unknown Building'

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

        # Extract additional fields from property form
        if property_form_data:
            # Basic Info
            building['number_of_units'] = self._extract_number(property_form_data, ['number of units', 'no. of units', 'total units'])
            building['previous_agents'] = self._extract_field(property_form_data, ['previous agents', 'previous agent'])

            # Accountants
            building['current_accountants'] = self._extract_field(property_form_data, ['current accountants', 'accountant'])
            building['accountant_contact'] = self._extract_field(property_form_data, ['accountant contact', 'accountant details'])

            # Financial Config - Demand Dates
            building['demand_date_1'] = self._extract_date(property_form_data, ['demand date 1', 'first demand', 'demand dates'])
            building['demand_date_2'] = self._extract_date(property_form_data, ['demand date 2', 'second demand'])
            building['year_end_date'] = self._extract_date(property_form_data, ['year end date', 'year end', 'financial year end'])

            # Financial Config - Fees
            building['management_fee_ex_vat'] = self._extract_currency(property_form_data, ['management fee (ex vat)', 'management fee ex vat', 'mgmt fee ex vat'])
            building['management_fee_inc_vat'] = self._extract_currency(property_form_data, ['management fee (inc vat)', 'management fee inc vat', 'mgmt fee inc vat'])
            building['company_secretary_fee_ex_vat'] = self._extract_currency(property_form_data, ['company secretary fee (ex vat)', 'co sec fee ex vat'])
            building['company_secretary_fee_inc_vat'] = self._extract_currency(property_form_data, ['company secretary fee (inc vat)', 'co sec fee inc vat'])

            # Ground Rent
            building['ground_rent_applicable'] = self._extract_boolean(property_form_data, ['ground rent applicable'])
            building['ground_rent_charges'] = self._extract_field(property_form_data, ['ground rent', 'additional ground rent', 'ground rent charges'])

            # Insurance
            building['insurance_broker'] = self._extract_field(property_form_data, ['insurance broker', 'broker & insurer contact', 'broker'])
            building['insurance_renewal_date'] = self._extract_date(property_form_data, ['insurance renewal date', 'renewal date', 'insurance & renewal date'])

            # Section 20 Limits
            building['section_20_limit_inc_vat'] = self._extract_currency(property_form_data, ['section 20 limit (inc vat)', 's20 limit inc vat', 'section 20 limit inc vat'])
            building['expenditure_limit'] = self._extract_currency(property_form_data, ['expenditure limit'])

            # Other
            building['additional_info'] = self._extract_field(property_form_data, ['any other relevant information', 'additional information', 'notes'])

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
                'unit_number': unit_number
            }

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
                'email': self._extract_field_from_row(row, ['email', 'email address']),
                'correspondence_address': self._extract_field_from_row(row, ['address', 'correspondence address', 'postal address'])
            }
            leaseholders.append(leaseholder)
        
        return leaseholders
    
    def map_building_documents(self, file_metadata: Dict, building_id: str, category: str = None,
                               linked_entity_id: str = None, entity_type: str = None, document_id: str = None,
                               upload_info: Dict = None) -> Dict:
        """
        Map to building_documents table - BlocIQ V2 compliant
        ALWAYS sets a valid category (compliance, finance, major_works, lease, contracts, correspondence, uncategorised)
        Uses filename-based detection for accurate categorization

        Args:
            file_metadata: File metadata from parser
            building_id: UUID of the building
            category: Document category
            linked_entity_id: Optional entity ID this doc is linked to
            entity_type: Optional entity type
            document_id: Optional document ID
            upload_info: Optional upload info from Supabase Storage with 'public_url' and 'storage_path'
        """
        filename = file_metadata['file_name']

        # Normalize category to V2 standards using both category and filename - NEVER None
        normalized_category = self._normalize_category(category, filename)

        # Use actual Supabase Storage path if available, otherwise use placeholder
        if upload_info and 'storage_path' in upload_info:
            storage_path = upload_info['storage_path']
        else:
            # Fallback to logical path structure
            storage_path = f"{normalized_category}/{filename}"

        doc_record = {
            'id': str(uuid.uuid4()),
            'building_id': building_id,
            'category': normalized_category,  # REQUIRED - never NULL, filename-aware
            'file_name': filename,
            'storage_path': storage_path,
            'entity_type': entity_type,
            'linked_entity_id': linked_entity_id
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
                'email': None,
                'correspondence_address': None
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

        IMPORTANT: Creates a NEW compliance_assets record for EACH document.
        - Multiple FRAs across years (FRA 2022, FRA 2023, FRA 2024) are all stored
        - Supports full historical compliance trail
        - Only true duplicates (same building + asset + test_date) should be blocked at SQL level
        """
        import re
        from datetime import datetime, timedelta
        from dateutil.relativedelta import relativedelta

        # Extract compliance type from filename/category
        file_name = file_metadata['file_name'].lower()
        original_filename = file_metadata['file_name']  # Keep original for better date parsing

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
        for key, (name_from_map, type_, freq, freq_months) in asset_type_map.items():
            if key in file_name:
                asset_name = name_from_map
                asset_type = type_
                frequency = freq
                frequency_months = freq_months
                break

        # ENHANCED DATE EXTRACTION: Try multiple patterns
        # Patterns: 2023, 2023-2024, 01.23, DD.MM.YY, DD-MM-YYYY, etc.
        last_inspection_date = None
        next_due_date = None

        # Try full date patterns first (DD-MM-YYYY, DD.MM.YYYY, DD/MM/YYYY)
        date_patterns = [
            r'(\d{1,2})[-./](\d{1,2})[-./](20\d{2})',  # DD-MM-YYYY or DD.MM.YYYY
            r'(20\d{2})[-./](\d{1,2})[-./](\d{1,2})',  # YYYY-MM-DD
        ]

        for pattern in date_patterns:
            match = re.search(pattern, original_filename)
            if match:
                try:
                    groups = match.groups()
                    if len(groups) == 3:
                        # Check if first group is year (YYYY-MM-DD format)
                        if len(groups[0]) == 4:
                            year, month, day = int(groups[0]), int(groups[1]), int(groups[2])
                        else:
                            # DD-MM-YYYY format
                            day, month, year = int(groups[0]), int(groups[1]), int(groups[2])

                        date_obj = datetime(year, month, day)
                        last_inspection_date = date_obj.date().isoformat()
                        next_due = date_obj + relativedelta(months=frequency_months)
                        next_due_date = next_due.date().isoformat()
                        break
                except (ValueError, IndexError):
                    continue

        # If no full date found, try year-only extraction
        if not last_inspection_date:
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

        # Convert frequency_months to PostgreSQL interval format
        frequency_interval = f"{frequency_months} months" if frequency_months else None

        # Ensure asset_name is never None or empty - CRITICAL!
        if asset_name is None or (isinstance(asset_name, str) and asset_name.strip() == ''):
            print(f"DEBUG: asset_name was None/empty for file: {file_metadata.get('file_name', 'unknown')}")
            asset_name = 'Compliance Asset'

        # Ensure asset_type is never None
        if asset_type is None or (isinstance(asset_type, str) and asset_type.strip() == ''):
            asset_type = 'general'

        result = {
            'id': str(uuid.uuid4()),
            'building_id': building_id,  # REQUIRED - links to building
            'asset_name': asset_name,  # REQUIRED - never null (BlocIQ V2 schema)
            'asset_type': asset_type,  # REQUIRED - never null (BlocIQ V2 schema)
            'inspection_frequency': frequency_interval,  # BlocIQ V2 schema
            'description': f"Extracted from {file_metadata.get('file_name', 'unknown')}"
        }

        # FINAL SAFETY CHECK - This should NEVER trigger
        if result['asset_name'] is None:
            print(f"CRITICAL ERROR: asset_name is still None after all checks!")
            print(f"  File: {file_metadata.get('file_name', 'unknown')}")
            print(f"  Result dict: {result}")
            raise ValueError(f"Compliance asset_name cannot be None")

        return result

    def map_budget(self, file_metadata: Dict, building_id: str, document_id: str) -> Dict:
        """
        Map finance document to budgets table - BlocIQ V2

        Detects finance subtype: Budget, Service Charge Account, Invoice, Apportionment

        IMPORTANT: Creates a NEW budgets record for EACH document.
        - Multiple years of budgets (2022, 2023, 2024) are all stored
        - Multiple years of accounts are all stored
        - Supports full historical financial trail
        - Only true duplicates (same building + period + subtype + document) should be blocked at SQL level
        """
        import re
        from datetime import datetime

        file_name = file_metadata['file_name']
        file_name_lower = file_name.lower()

        # Detect finance subtype - PRIORITY ORDER MATTERS
        finance_subtype = 'service_charge'  # Default

        # Check for apportionment first (most specific)
        if 'apportionment' in file_name_lower or 'apportion' in file_name_lower:
            finance_subtype = 'service_charge'
        # Reserve/sinking funds
        elif 'reserve' in file_name_lower or 'sinking' in file_name_lower:
            finance_subtype = 'reserve_fund' if 'reserve' in file_name_lower else 'sinking_fund'
        # Then check for accounts
        elif ('account' in file_name_lower and 'service charge' in file_name_lower) or 'year end' in file_name_lower:
            finance_subtype = 'service_charge'
        # Then invoices/demands
        elif 'invoice' in file_name_lower or 'demand' in file_name_lower:
            finance_subtype = 'service_charge'
        # Finally budgets
        elif 'budget' in file_name_lower:
            finance_subtype = 'service_charge'

        # Extract period from filename (YE24, 2024-2025, etc.)
        period = 'Unknown'
        start_date = None
        end_date = None
        year_end_date = None

        # Try YE format (YE24, YE 2024, etc.)
        ye_match = re.search(r'YE\s*(\d{2,4})', file_name, re.IGNORECASE)
        if ye_match:
            year = ye_match.group(1)
            if len(year) == 2:
                year = f"20{year}"
            period = f"YE{year}"
            # Assume UK financial year ending 31st March
            year_end_date = f"{year}-03-31"
            # Start date is one year before
            start_year = int(year) - 1
            start_date = f"{start_year}-04-01"
            end_date = year_end_date
        else:
            # Try year range (2024-2025, 2024/2025)
            range_match = re.search(r'(\d{4})[-/](\d{4})', file_name)
            if range_match:
                start_year = range_match.group(1)
                end_year = range_match.group(2)
                period = f"{start_year}-{end_year}"
                start_date = f"{start_year}-04-01"  # Assume April start (UK standard)
                end_date = f"{end_year}-03-31"
                year_end_date = end_date
            else:
                # Try single year
                year_match = re.search(r'20(\d{2})', file_name)
                if year_match:
                    year = f"20{year_match.group(1)}"
                    period = year
                    start_date = f"{year}-04-01"
                    end_year = int(year) + 1
                    end_date = f"{end_year}-03-31"
                    year_end_date = end_date

        # Try to extract demand dates from filename
        # Common patterns: "Demand 1st April", "1st & 2nd Demands", etc.
        demand_date_1 = None
        demand_date_2 = None

        # Look for explicit dates in filename
        date_patterns = [
            r'(\d{1,2})[/-](\d{1,2})[/-](20\d{2})',  # DD-MM-YYYY or DD/MM/YYYY
            r'(20\d{2})[/-](\d{1,2})[/-](\d{1,2})',  # YYYY-MM-DD
        ]

        dates_found = []
        for pattern in date_patterns:
            for match in re.finditer(pattern, file_name):
                try:
                    groups = match.groups()
                    if len(groups) == 3:
                        if len(groups[0]) == 4:  # YYYY-MM-DD format
                            year_val, month_val, day_val = int(groups[0]), int(groups[1]), int(groups[2])
                        else:  # DD-MM-YYYY format
                            day_val, month_val, year_val = int(groups[0]), int(groups[1]), int(groups[2])

                        date_obj = datetime(year_val, month_val, day_val)
                        dates_found.append(date_obj.date().isoformat())
                except (ValueError, IndexError):
                    continue

        # Assign first two dates as demand dates
        if len(dates_found) >= 1:
            demand_date_1 = dates_found[0]
        if len(dates_found) >= 2:
            demand_date_2 = dates_found[1]

        return {
            'id': str(uuid.uuid4()),
            'building_id': building_id,
            'document_id': document_id,
            'period': period,
            'start_date': start_date,
            'end_date': end_date,
            'demand_date_1': demand_date_1,
            'demand_date_2': demand_date_2,
            'year_end_date': year_end_date,
            'total_amount': None,  # Will need to be extracted from document or set manually
            'budget_type': finance_subtype
        }

    def map_major_works(self, file_metadata: Dict, building_id: str) -> Dict:
        """
        Map major works document to major_works_projects table - BlocIQ V2

        Detects notice type: NOI (Notice of Intention), SOE (Statement of Estimates), Final Notice, Quotes

        IMPORTANT: Creates a NEW major_works_projects record for EACH Section 20 document set.
        - Multiple projects per building (Roof 2022, External Decorations 2023, etc.)
        - Supports full historical major works trail
        - Multiple notices per project (NOI → SOE → Final Notice)
        - Only true duplicates (same building + project_name + year) should be blocked at SQL level
        """
        import re
        from datetime import datetime

        file_name = file_metadata['file_name']
        file_name_lower = file_name.lower()

        # BlocIQ V2: Determine notice type from filename - STRICT matching
        project_type = 'general'
        notice_type = None

        # Priority detection for notice types (most specific first)
        if 'final notice' in file_name_lower or 'final account' in file_name_lower or 'award of contract' in file_name_lower:
            project_type = 'section_20'
            notice_type = 'final_notice'
        elif 'soe' in file_name_lower or 'statement of estimate' in file_name_lower:
            project_type = 'section_20'
            notice_type = 'SOE'
        elif 'noi' in file_name_lower or 'notice of intention' in file_name_lower:
            project_type = 'section_20'
            notice_type = 'NOI'
        elif 'section 20' in file_name_lower or 's20' in file_name_lower or 's.20' in file_name_lower:
            project_type = 'section_20'
            notice_type = 'NOI'  # Default Section 20 to NOI
        elif 'contractor' in file_name_lower or 'tender' in file_name_lower:
            notice_type = 'contractor_quote'
        elif 'quote' in file_name_lower or 'quotation' in file_name_lower:
            # Only classify as major works quote if clearly related to major works
            if any(kw in file_name_lower for kw in ['roof', 'external', 'decoration', 'repair', 'works']):
                notice_type = 'contractor_quote'

        # Extract year if present
        year_match = re.search(r'20(\d{2})', file_name)
        year = f"20{year_match.group(1)}" if year_match else datetime.now().year

        # Try to extract project name from filename (e.g. "Roof", "External Decorations")
        project_name = None
        project_keywords = ['roof', 'external decoration', 'decoration', 'painting', 'window', 'door',
                           'balcony', 'lift', 'elevator', 'communal', 'fire safety', 'cladding']
        for keyword in project_keywords:
            if keyword in file_name_lower:
                project_name = keyword.title()
                break

        # Create descriptive title based on notice type and project name
        if project_name:
            if notice_type == 'NOI':
                title = f"{project_name} - Section 20 (NOI) - {year}"
            elif notice_type == 'SOE':
                title = f"{project_name} - Section 20 (SOE) - {year}"
            elif notice_type == 'final_notice':
                title = f"{project_name} - Section 20 (Final) - {year}"
            else:
                title = f"{project_name} - {year}"
        else:
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
            'document_id': None,  # Will be set later when document is created
            'project_name': title,
            'status': 'planned',
            'start_date': f"{year}-01-01",
            'end_date': None
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

    def extract_property_form_data(self, property_form_data: Dict, building_id: str) -> Dict:
        """
        Extract all structured data from property information form
        Returns data for multiple tables: contractors, utilities, insurance, legal, etc.
        """
        extracted_data = {
            'contractors': [],
            'utilities': [],
            'insurance': [],
            'legal': [],
            'statutory_reports': [],
            'keys_access': [],
            'warranties': [],
            'company_secretary': None,
            'staff': [],
            'title_deeds': []
        }

        if not property_form_data:
            return extracted_data

        # Extract contractors (from "Contracts & Regular Contractors" section)
        contractor_types = [
            ('cleaning', ['cleaning']),
            ('window_cleaning', ['window cleaning']),
            ('gardening', ['gardening']),
            ('lift', ['lift company']),
            ('pumps', ['pumps service company']),
            ('drains', ['drains']),
            ('gutters', ['gutters']),
            ('aov', ['aov', 'automatic opening vents']),
            ('emergency_lighting', ['emergency lighting']),
            ('fire_alarm', ['fire alarm']),
            ('ventilation', ['ventilation system']),
            ('gates', ['gates']),
            ('entryphone', ['entryphone']),
            ('parking', ['parking company']),
            ('water_tanks', ['water tanks']),
            ('solar_panels', ['solar panels'])
        ]

        for contractor_type, keywords in contractor_types:
            company_name = self._extract_field(property_form_data, keywords)
            if company_name:
                extracted_data['contractors'].append({
                    'id': str(uuid.uuid4()),
                    'building_id': building_id,
                    'contractor_type': contractor_type,
                    'company_name': company_name,
                    'notes': f'Extracted from property form'
                })

        # Extract utilities
        utility_types = [
            ('electricity', ['electricity provider']),
            ('water', ['water company']),
            ('gas', ['gas provider']),
            ('phone', ['phone line for lift']),
            ('meters_access', ['meters access']),
            ('stopcock_location', ['location of stopcock'])
        ]

        for utility_type, keywords in utility_types:
            provider_name = self._extract_field(property_form_data, keywords)
            if provider_name:
                # Also try to extract meter numbers
                meter_numbers = self._extract_field(property_form_data, ['meter numbers', 'meter number'])

                extracted_data['utilities'].append({
                    'id': str(uuid.uuid4()),
                    'building_id': building_id,
                    'utility_type': utility_type,
                    'provider_name': provider_name,
                    'meter_numbers': meter_numbers,
                    'notes': f'Extracted from property form'
                })

        # Extract insurance records
        insurance_types = [
            ('building_terrorism', ['building & terrorism insurance', 'buildings & terrorism insurance']),
            ('engineering', ['engineering insurance']),
            ('directors_and_officers', ['directors insurance', 'd&o']),
        ]

        for insurance_type, keywords in insurance_types:
            insurer_info = self._extract_field(property_form_data, keywords)
            if insurer_info:
                extracted_data['insurance'].append({
                    'id': str(uuid.uuid4()),
                    'building_id': building_id,
                    'insurance_type': insurance_type,
                    'broker_name': insurer_info,
                    'notes': f'Extracted from property form'
                })

        # Extract legal records
        legal_record_types = [
            ('lease_dispute', ['lease disputes (if any)', 'lease dispute']),
            ('contractor_dispute', ['contractor disputes (if any)', 'contractor dispute']),
            ('litigation', ['litigation against the client (if any)', 'litigation']),
            ('solicitor', ['solicitor details (if applicable)', 'solicitor']),
            ('arrears', ['lessee arrears info', 'arrears'])
        ]

        for record_type, keywords in legal_record_types:
            description = self._extract_field(property_form_data, keywords)
            if description:
                extracted_data['legal'].append({
                    'id': str(uuid.uuid4()),
                    'building_id': building_id,
                    'record_type': record_type,
                    'description': description,
                    'status': 'active',
                    'notes': f'Extracted from property form'
                })

        # Extract statutory reports
        report_types = [
            ('lift_reports', ['lift reports for the last 3 years', 'lift report']),
            ('gas_safety', ['gas safety']),
            ('eicr', ['eicr']),
            ('pat_testing', ['pat testing']),
            ('hsfra', ['hsfra']),
            ('water_hygiene', ['water hygiene']),
            ('asbestos_register', ['asbestos register']),
            ('fire_doors', ['fire doors']),
            ('emergency_lighting', ['emergency lighting']),
            ('aovs', ['aovs']),
            ('fire_equipment', ['fire equipment']),
            ('lightning_protection', ['lightning protection'])
        ]

        for report_type, keywords in report_types:
            report_info = self._extract_field(property_form_data, keywords)
            if report_info:
                extracted_data['statutory_reports'].append({
                    'id': str(uuid.uuid4()),
                    'building_id': building_id,
                    'report_type': report_type,
                    'notes': report_info
                })

        # Extract keys and access codes
        access_types = [
            ('labelled_keys', ['full set of labelled keys', 'labelled keys']),
            ('gate_codes', ['gate codes']),
            ('entrance_codes', ['entrance codes']),
            ('bin_store', ['bin store']),
            ('bike_store', ['bike store'])
        ]

        for access_type, keywords in access_types:
            access_info = self._extract_field(property_form_data, keywords)
            if access_info:
                extracted_data['keys_access'].append({
                    'id': str(uuid.uuid4()),
                    'building_id': building_id,
                    'access_type': access_type,
                    'description': access_info,
                    'notes': f'Extracted from property form'
                })

        # Extract warranties
        warranty_types = [
            ('pumps', ['pumps']),
            ('boilers', ['boilers']),
            ('gates', ['gates']),
            ('fire_alarm', ['fire alarm']),
            ('damp_proofing', ['damp proofing']),
            ('roofing', ['roofing'])
        ]

        for item_type, keywords in warranty_types:
            warranty_info = self._extract_field(property_form_data, [f'{keywords[0]} warranty', f'any other warranties'])
            if warranty_info:
                extracted_data['warranties'].append({
                    'id': str(uuid.uuid4()),
                    'building_id': building_id,
                    'item_type': item_type,
                    'notes': warranty_info
                })

        # Extract company secretary data
        company_house_code = self._extract_field(property_form_data, ['companies house filing code', 'company house code'])
        if company_house_code:
            extracted_data['company_secretary'] = {
                'id': str(uuid.uuid4()),
                'building_id': building_id,
                'company_house_filing_code': company_house_code,
                'stock_transfer_forms': self._extract_boolean(property_form_data, ['stock transfer forms']),
                'certificate_of_incorporation': self._extract_boolean(property_form_data, ['certificate of incorporation']),
                'seal_available': self._extract_boolean(property_form_data, ['seal']),
                'notes': f'Extracted from property form'
            }

        # Extract title deed records
        deed_types = [
            ('freehold_title', ['freehold title/title register']),
            ('head_lease', ['head lease (if applicable)']),
            ('individual_leases', ['individual leases']),
            ('building_plans', ['building plans (if held)']),
            ('as_built_drawings', ['as built drawings']),
            ('om_manuals', ['o & m manuals']),
            ('cdm_manual', ['cdm (construction & design manual)']),
            ('ongoing_major_works', ['ongoing major works']),
            ('planned_major_works', ['planned major works'])
        ]

        for record_type, keywords in deed_types:
            deed_info = self._extract_field(property_form_data, keywords)
            if deed_info:
                extracted_data['title_deeds'].append({
                    'id': str(uuid.uuid4()),
                    'building_id': building_id,
                    'record_type': record_type,
                    'description': deed_info,
                    'notes': f'Extracted from property form'
                })

        return extracted_data
