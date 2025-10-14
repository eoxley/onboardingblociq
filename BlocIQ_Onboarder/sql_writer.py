"""
BlocIQ SQL Writer - Enhanced V2
================================
Generates INSERT statements for the comprehensive Supabase schema.
Handles buildings, units, leaseholders, compliance, contracts, and documents.

Features:
- UUIDs for all primary keys
- Clean SQL generation
- References Supabase schema
- Document registry with storage bucket paths
- Extraction run metadata

Integrated with BlocIQ Onboarder
Author: BlocIQ Team
Date: 2025-10-14
"""

import json
import uuid
from typing import Dict, List, Optional, Any
from pathlib import Path
from datetime import datetime


class SQLWriter:
    """Generate SQL for Supabase comprehensive schema (Compatible with BlocIQ Onboarder)"""

    def __init__(self):
        self.building_id = None
        self.extraction_run_id = None
        self.storage_bucket = "building-documents"  # Supabase storage bucket name
        self.agency_id = '11111111-1111-1111-1111-111111111111'  # BlocIQ agency ID

        # Track UUIDs for foreign keys
        self.unit_ids = {}  # unit_number -> UUID
        self.leaseholder_ids = {}  # leaseholder key -> UUID
        self.compliance_asset_ids = {}  # asset key -> UUID
        self.contract_ids = {}  # contract key -> UUID
        self.asset_type_ids = {}  # Pre-loaded from reference table
        self.contract_type_ids = {}  # Pre-loaded from reference table
        
        # For compatibility with onboarder
        self.sql_statements = []

    def generate_migration(self, mapped_data: Dict) -> str:
        """
        Generate SQL migration script (BlocIQ Onboarder Interface)
        
        Args:
            mapped_data: Dictionary containing mapped data for all tables from the onboarder
            
        Returns:
            SQL migration script as string
        """
        # This method needs to convert the onboarder's mapped_data format
        # to the format that generate_sql_file() expects
        
        # Convert mapped_data to the format expected by generate_sql_file()
        data = self._convert_mapped_data_to_extraction_format(mapped_data)
        
        # Use the full generate_sql_file() method with in-memory output
        sql_statements = []
        
        self.building_id = data.get('id') or str(uuid.uuid4())
        self.extraction_run_id = str(uuid.uuid4())
        
        # Header
        sql_statements.append(self._generate_header(data, None))
        
        # 1. Building
        building_sql = self._generate_building_insert(data, None)
        if building_sql:
            sql_statements.append(building_sql)
        
        # 2. Building Blocks (if multi-block)
        if data.get('num_blocks', 0) > 1:
            blocks_sql = self._generate_blocks_insert(data)
            if blocks_sql:
                sql_statements.append(blocks_sql)
        
        # 3. Units
        units_sql = self._generate_units_insert(data)
        if units_sql:
            sql_statements.append(units_sql)
        
        # 4. Leaseholders
        leaseholders_sql = self._generate_leaseholders_insert(data)
        if leaseholders_sql:
            sql_statements.append(leaseholders_sql)
        
        # 5. Compliance Assets
        compliance_sql = self._generate_compliance_insert(data)
        if compliance_sql:
            sql_statements.append(compliance_sql)
        
        # 6. Maintenance Contracts
        contracts_sql = self._generate_contracts_insert(data)
        if contracts_sql:
            sql_statements.append(contracts_sql)
        
        # 7. Budgets + Budget Line Items
        budget_result = self._generate_budgets_with_line_items(data)
        if budget_result:
            sql_statements.append(budget_result)
        
        # 7b. Maintenance Schedules (inferred from contracts)
        schedules_sql = self._generate_maintenance_schedules(data)
        if schedules_sql:
            sql_statements.append(schedules_sql)
        
        # 8. Insurance (if available)
        if data.get('insurance_policies'):
            insurance_sql = self._generate_insurance_insert(data)
            if insurance_sql:
                sql_statements.append(insurance_sql)
        
        # 8a. Leases
        if data.get('leases'):
            leases_sql = self._generate_leases_insert(data)
            if leases_sql:
                sql_statements.append(leases_sql)
        
        # 8b. Contractors
        if data.get('contractors'):
            contractors_sql = self._generate_contractors_insert(data)
            if contractors_sql:
                sql_statements.append(contractors_sql)
        
        # 8c. Major Works
        if data.get('major_works'):
            major_works_sql = self._generate_major_works_insert(data)
            if major_works_sql:
                sql_statements.append(major_works_sql)
        
        # 9. Documents Registry
        documents_sql = self._generate_documents_insert(data, None)
        if documents_sql:
            sql_statements.append(documents_sql)
        
        # 10. Extraction Run Metadata
        stats = {
            'units': len(data.get('units', [])),
            'leaseholders': len(data.get('leaseholders', [])),
            'compliance_assets': len(data.get('compliance_assets_all', [])),
            'contracts': len(data.get('maintenance_contracts', []))
        }
        extraction_sql = self._generate_extraction_run(data, stats, None)
        if extraction_sql:
            sql_statements.append(extraction_sql)
        
        # Footer
        sql_statements.append("COMMIT;")
        
        return "\n\n".join(sql_statements)
    
    def _convert_mapped_data_to_extraction_format(self, mapped_data: Dict) -> Dict:
        """Convert onboarder's mapped_data format to extraction format"""
        # The onboarder uses different field names than the extraction scripts
        # This method bridges the gap
        
        building = mapped_data.get('building', {})
        
        # Start with building data
        data = {
            'building_name': building.get('name', 'Unknown Building'),
            'building_address': building.get('address', ''),
            'postcode': building.get('postcode', ''),
            'city': building.get('city', 'London'),
            'id': building.get('id'),
            
            # Add all building fields
            **building,
            
            # Core entity lists
            'units': mapped_data.get('units', []),
            'leaseholders': mapped_data.get('leaseholders', []),
            'compliance_assets_all': mapped_data.get('compliance_assets', []),
            'maintenance_contracts': mapped_data.get('maintenance_contracts', []),
            
            # Financial data
            'insurance_policies': mapped_data.get('insurance_policies', []),
            
            # Summary
            'summary': mapped_data.get('summary', {}),
            
            # Metadata
            'extraction_version': '6.0',
            'data_quality': 'production',
            'confidence_score': 0.99
        }
        
        # Handle budget data - convert from onboarder format
        if 'annual_service_charge_budget' in building or 'budgets' in mapped_data:
            budget_amount = building.get('annual_service_charge_budget') or \
                          (mapped_data.get('budgets', [{}])[0].get('total_amount') if mapped_data.get('budgets') else None)
            if budget_amount:
                data['summary']['service_charge_budget'] = budget_amount
        
        return data
    
    def _generate_insurance_insert(self, data: Dict) -> str:
        """Generate insurance policies INSERT statements (SCHEMA ALIGNED)"""
        policies = data.get('insurance_policies', [])
        if not policies:
            return ""
        
        sql_parts = ["""
-- ============================================================================
-- Insurance Policies (Supabase: insurance_policies table)
-- ============================================================================"""]
        
        for policy in policies:
            policy_id = str(uuid.uuid4())
            
            # Map extracted fields to schema fields
            policy_type = policy.get('policy_type') or policy.get('insurance_type', 'General')
            insurer = policy.get('insurer') or policy.get('insurer_name', '')
            annual_premium = policy.get('annual_premium') or policy.get('estimated_premium') or policy.get('premium_amount')
            
            sql_parts.append(f"""
INSERT INTO insurance_policies (
    id, building_id, policy_type, insurer,
    renewal_date, annual_premium, policy_number
)
VALUES (
    '{policy_id}',
    '{self.building_id}',
    '{self._sql_escape(policy_type)}',
    '{self._sql_escape(insurer)}',
    {self._sql_date(policy.get('renewal_date'))},
    {annual_premium or 'NULL'},
    '{self._sql_escape(policy.get('policy_number', ''))}'
);""")
        
        return "\n".join(sql_parts)
    
    def _generate_budgets_with_line_items(self, data: Dict) -> str:
        """Generate budgets INSERT with line items (COMPLETE BUDGET DATA)"""
        budgets = data.get('budgets', [])
        if not budgets or len(budgets) == 0:
            return ""
        
        budget = budgets[0]  # Take first budget
        budget_id = str(uuid.uuid4())
        
        sql_parts = []
        
        # 1. Main Budget Record
        financial_year = budget.get('financial_year', '2025/2026')
        year = int(financial_year.split('/')[0]) if '/' in financial_year else datetime.now().year
        
        # Calculate total from line items
        line_items = budget.get('line_items', [])
        total_budget = sum(item.get('budget_2025_26', 0) for item in line_items if item.get('category') != 'Total')
        
        sql_parts.append(f"""
-- ============================================================================
-- Budget (with {len(line_items)} line items)
-- ============================================================================
INSERT INTO budgets (
    id, building_id, budget_year, total_budget, 
    status, source_document
)
VALUES (
    '{budget_id}',
    '{self.building_id}',
    {year},
    {total_budget},
    '{self._sql_escape(budget.get('status', 'draft'))}',
    '{self._sql_escape(budget.get('source_document', ''))}'
);""")
        
        # 2. Budget Line Items
        if line_items:
            sql_parts.append(f"""
-- Budget Line Items ({len(line_items)} items)""")
            
            for item in line_items:
                # Skip the "Total" row
                if item.get('category') == 'Total':
                    continue
                
                item_id = str(uuid.uuid4())
                category = item.get('category', 'Unknown')
                section = item.get('section', '')
                budgeted_amount = item.get('budget_2025_26', 0)
                actual_amount = item.get('actual_2024_25', 0)
                variance = item.get('variance_from_actual', 0)
                variance_pct = item.get('variance_percentage')
                
                sql_parts.append(f"""
INSERT INTO budget_line_items (
    id, budget_id, category, subcategory, 
    budgeted_amount, actual_amount, variance, variance_percentage
)
VALUES (
    '{item_id}',
    '{budget_id}',
    '{self._sql_escape(category)}',
    '{self._sql_escape(section)}',
    {budgeted_amount},
    {actual_amount or 0},
    {variance or 0},
    {variance_pct or 'NULL'}
);""")
        
        return "\n".join(sql_parts)
    
    def _generate_maintenance_schedules(self, data: Dict) -> str:
        """Generate maintenance schedules from contracts (INFERRED SCHEDULES)"""
        contracts = data.get('maintenance_contracts', [])
        if not contracts:
            return ""
        
        # Map contract types to service frequencies
        FREQUENCY_MAP = {
            'Lift Maintenance': ('annual', 12),
            'Fire Alarm': ('biannual', 6),
            'Emergency Lighting': ('annual', 12),
            'EICR': ('five_yearly', 60),
            'Legionella': ('annual', 12),
            'Water Hygiene': ('quarterly', 3),
            'Gas Safety': ('annual', 12),
            'Boiler Maintenance': ('annual', 12),
            'PAT Testing': ('biannual', 6),
            'Pest Control': ('quarterly', 3),
            'Cleaning': ('weekly', 0.25),
            'Gardening': ('monthly', 1),
            'CCTV': ('annual', 12),
            'Door Entry': ('biannual', 6)
        }
        
        # Track created schedules by contract_id
        self.schedule_ids = {}
        
        sql_parts = [f"""
-- ============================================================================
-- Maintenance Schedules (inferred from {len(contracts)} contracts)
-- ============================================================================"""]
        
        for contract in contracts:
            contract_type = contract.get('contract_type', 'General Maintenance')
            contract_id = self.contract_ids.get(contract.get('contractor_name', ''))
            
            if not contract_id:
                continue  # Skip if contract wasn't generated
            
            # Get frequency for this contract type
            frequency_info = FREQUENCY_MAP.get(contract_type, ('annual', 12))
            frequency, frequency_months = frequency_info
            
            schedule_id = str(uuid.uuid4())
            self.schedule_ids[contract.get('contractor_name', '')] = schedule_id
            
            # Determine priority based on contract type
            priority = 'critical' if contract_type in ['Fire Alarm', 'Lift Maintenance', 'Gas Safety', 'EICR'] else 'high' if contract_type in ['Legionella', 'Water Hygiene', 'Emergency Lighting'] else 'medium'
            
            # Status: active if contract is active, otherwise cancelled
            status = 'active' if contract.get('contract_status', '').lower() == 'active' else 'upcoming'
            
            sql_parts.append(f"""
INSERT INTO maintenance_schedules (
    id, building_id, contract_id, service_type,
    frequency, frequency_months, priority, status,
    responsible_contractor, description
)
VALUES (
    '{schedule_id}',
    '{self.building_id}',
    '{contract_id}',
    '{self._sql_escape(contract_type)}',
    '{frequency}',
    {frequency_months},
    '{priority}',
    '{status}',
    '{self._sql_escape(contract.get('contractor_name', 'Unknown'))}',
    'Scheduled {frequency} maintenance for {self._sql_escape(contract_type)}'
);""")
        
        return "\n".join(sql_parts)
    
    def _generate_leases_insert(self, data: Dict) -> str:
        """Generate leases INSERT statements"""
        leases = data.get('leases', [])
        if not leases:
            return ""
        
        sql_parts = [f"""
-- ============================================================================
-- Leases ({len(leases)} lease documents)
-- ============================================================================"""]
        
        for lease in leases:
            lease_id = str(uuid.uuid4())
            
            sql_parts.append(f"""
INSERT INTO leases (
    id, building_id, title_number, lease_type,
    source_document, document_location, page_count,
    file_size_mb, extraction_timestamp, extracted_successfully
)
VALUES (
    '{lease_id}',
    '{self.building_id}',
    '{self._sql_escape(lease.get('title_number', ''))}',
    '{self._sql_escape(lease.get('document_type', 'Lease'))}',
    '{self._sql_escape(lease.get('source_document', ''))}',
    '{self._sql_escape(lease.get('document_location', ''))}',
    {lease.get('page_count') or 'NULL'},
    {lease.get('file_size_mb') or 'NULL'},
    {self._sql_nullable(lease.get('extraction_timestamp'))},
    {self._sql_bool(lease.get('extracted_successfully', True))}
);""")
        
        return "\n".join(sql_parts)
    
    def _generate_contractors_insert(self, data: Dict) -> str:
        """Generate contractors INSERT statements"""
        contractors = data.get('contractors', [])
        if not contractors:
            return ""
        
        sql_parts = [f"""
-- ============================================================================
-- Contractors ({len(contractors)} contractors)
-- ============================================================================"""]
        
        for contractor in contractors:
            contractor_id = str(uuid.uuid4())
            
            # Extract service type from folder path
            folder_path = contractor.get('folder_path', '')
            service_type = contractor.get('service_type', 'General Maintenance')
            
            sql_parts.append(f"""
INSERT INTO contractors (
    id, company_name, services_offered, is_active, notes
)
VALUES (
    '{contractor_id}',
    '{self._sql_escape(contractor.get('contractor_name', 'Unknown'))}',
    ARRAY['{self._sql_escape(service_type)}'],
    TRUE,
    'Folder: {self._sql_escape(folder_path)}, Documents: {contractor.get('contract_documents_count', 0)}'
);""")
        
        return "\n".join(sql_parts)
    
    def _generate_major_works_insert(self, data: Dict) -> str:
        """Generate major works projects INSERT statements"""
        major_works = data.get('major_works', [])
        if not major_works:
            return ""
        
        sql_parts = [f"""
-- ============================================================================
-- Major Works Projects ({len(major_works)} projects detected)
-- ============================================================================"""]
        
        for project in major_works:
            project_id = str(uuid.uuid4())
            
            # Extract from major_works structure
            detected = project.get('major_works_detected', False)
            if not detected:
                continue
            
            total_docs = project.get('total_documents', 0)
            s20_docs = project.get('s20_consultation_documents', 0)
            folder_path = project.get('folder_path', '')
            
            sql_parts.append(f"""
INSERT INTO major_works_projects (
    id, building_id, project_name, description,
    status, s20_consultation_required, s20_documents_count,
    folder_path, total_documents
)
VALUES (
    '{project_id}',
    '{self.building_id}',
    'Major Works Project',
    'Detected from documents folder',
    'planned',
    {self._sql_bool(s20_docs > 0)},
    {s20_docs},
    '{self._sql_escape(folder_path)}',
    {total_docs}
);""")
        
        return "\n".join(sql_parts)

    def generate_sql_file(self, data: Dict, output_file: str, source_folder: str = None) -> Dict:
        """
        Generate complete SQL file from extraction data

        Args:
            data: Extracted building data (from JSON)
            output_file: Path to output SQL file
            source_folder: Original source folder path

        Returns:
            Dict with statistics
        """
        print(f"\n🔄 Generating SQL for Supabase schema...")

        self.building_id = str(uuid.uuid4())
        self.extraction_run_id = str(uuid.uuid4())

        sql_statements = []
        stats = {
            'buildings': 0,
            'units': 0,
            'leaseholders': 0,
            'compliance_assets': 0,
            'contracts': 0,
            'budgets': 0,
            'documents': 0,
        }

        # Header
        sql_statements.append(self._generate_header(data, source_folder))

        # 1. Building
        building_sql = self._generate_building_insert(data, source_folder)
        if building_sql:
            sql_statements.append(building_sql)
            stats['buildings'] = 1

        # 2. Building Blocks (if multi-block)
        if data.get('num_blocks', 0) > 1:
            blocks_sql = self._generate_blocks_insert(data)
            if blocks_sql:
                sql_statements.append(blocks_sql)

        # 3. Units
        units_sql = self._generate_units_insert(data)
        if units_sql:
            sql_statements.append(units_sql)
            stats['units'] = len(data.get('units', []))

        # 4. Leaseholders
        leaseholders_sql = self._generate_leaseholders_insert(data)
        if leaseholders_sql:
            sql_statements.append(leaseholders_sql)
            stats['leaseholders'] = len(data.get('leaseholders', []))

        # 5. Compliance Assets
        compliance_sql = self._generate_compliance_insert(data)
        if compliance_sql:
            sql_statements.append(compliance_sql)
            stats['compliance_assets'] = len(data.get('compliance_assets_all', []))

        # 6. Maintenance Contracts
        contracts_sql = self._generate_contracts_insert(data)
        if contracts_sql:
            sql_statements.append(contracts_sql)
            stats['contracts'] = len(data.get('maintenance_contracts', []))

        # 7. Budgets
        budgets_sql = self._generate_budgets_insert(data)
        if budgets_sql:
            sql_statements.append(budgets_sql)
            stats['budgets'] += 1

        # 8. Documents Registry
        documents_sql = self._generate_documents_insert(data, source_folder)
        if documents_sql:
            sql_statements.append(documents_sql)
            stats['documents'] = documents_sql.count('INSERT INTO documents')

        # 9. Extraction Run Metadata
        extraction_sql = self._generate_extraction_run(data, stats, source_folder)
        if extraction_sql:
            sql_statements.append(extraction_sql)

        # Write to file
        full_sql = "\n\n".join(sql_statements)

        with open(output_file, 'w', encoding='utf-8') as f:
            f.write(full_sql)

        print(f"\n✅ SQL generated successfully!")
        print(f"   Output: {output_file}")
        print(f"   Building ID: {self.building_id}")
        print(f"\n📊 Statistics:")
        for key, value in stats.items():
            if value > 0:
                print(f"   {key}: {value}")

        return stats

    def _generate_header(self, data: Dict, source_folder: str = None) -> str:
        """Generate SQL file header"""
        building_name = data.get('building_name', 'Unknown Building')
        extraction_date = datetime.now().strftime('%Y-%m-%d %H:%M:%S')

        return f"""-- ============================================================================
-- BlocIQ Property Data Import - Supabase
-- ============================================================================
-- Building: {building_name}
-- Extraction Date: {extraction_date}
-- Extraction Version: {data.get('extraction_version', 'Unknown')}
-- Source Folder: {source_folder or 'N/A'}
-- Building ID: {self.building_id}
-- ============================================================================
--
-- INSTRUCTIONS:
-- 1. Run this SQL script in Supabase SQL Editor
-- 2. Manually upload building documents to Supabase Storage bucket: {self.storage_bucket}
-- 3. Documents should be uploaded to: {self.storage_bucket}/{{building_id}}/...
-- 4. The documents table entries below reference where files SHOULD be uploaded
--
-- ============================================================================

BEGIN;"""

    def _generate_building_insert(self, data: Dict, source_folder: str = None) -> str:
        """Generate building INSERT statement"""

        # Extract building data
        building = {
            'id': self.building_id,
            'building_name': self._sql_escape(data.get('building_name', 'Unknown')),
            'building_address': self._sql_escape(data.get('building_address', '')),
            'postcode': self._sql_escape(data.get('postcode', '')),
            'city': self._sql_escape(data.get('city', 'London')),
            'country': 'United Kingdom',

            # Physical
            'num_units': data.get('num_units', 0),
            'num_floors': data.get('num_floors'),
            'num_blocks': data.get('num_blocks', 1),
            'building_height_meters': data.get('building_height_meters'),

            # Construction
            'construction_era': self._sql_escape(data.get('construction_era', '')),
            'year_built': data.get('year_built'),

            # Systems (from building profile)
            'has_lifts': self._sql_bool(data.get('has_lifts', False)),
            'num_lifts': data.get('num_lifts'),
            'has_communal_heating': self._sql_bool(data.get('has_communal_heating', False)),
            'heating_type': self._sql_escape(data.get('heating_type', '')),
            'has_hot_water': self._sql_bool(data.get('has_hot_water', False)),
            'has_hvac': self._sql_bool(data.get('has_hvac', False)),
            'has_plant_room': self._sql_bool(data.get('has_plant_room', False)),
            'has_mechanical_ventilation': self._sql_bool(data.get('has_mechanical_ventilation', False)),
            'has_water_pumps': self._sql_bool(data.get('has_water_pumps', False)),
            'has_gas': self._sql_bool(data.get('has_gas', False)),
            'has_sprinklers': self._sql_bool(data.get('has_sprinklers', False)),
            'has_lightning_conductor': self._sql_bool(data.get('has_lightning_conductor', False)),

            # Special Facilities
            'has_gym': self._sql_bool(data.get('has_gym', False)),
            'has_pool': self._sql_bool(data.get('has_pool', False)),
            'has_sauna': self._sql_bool(data.get('has_sauna', False)),
            'has_squash_court': self._sql_bool(data.get('has_squash_court', False)),
            'has_communal_showers': self._sql_bool(data.get('has_communal_showers', False)),
            'has_ev_charging': self._sql_bool(data.get('has_ev_charging', False)),
            'has_balconies': self._sql_bool(data.get('has_balconies', False)),

            # Cladding
            'has_cladding': self._sql_bool(data.get('has_cladding', False)),

            # BSA
            'bsa_registration_required': self._sql_bool(data.get('bsa_registration_required', False)),
            'bsa_status': self._sql_escape(data.get('bsa_status', '')),

            # Metadata
            'data_quality': self._sql_escape(data.get('data_quality', 'production')),
            'confidence_score': data.get('confidence_score', 0.98),
            'source_folder': self._sql_escape(source_folder or ''),
            'extraction_version': self._sql_escape(data.get('extraction_version', 'v6.0')),
        }

        # Build INSERT statement
        fields = []
        values = []

        for field, value in building.items():
            if value is not None and value != '':
                fields.append(field)
                if isinstance(value, (int, float)) or value in ['TRUE', 'FALSE']:
                    values.append(str(value))
                else:
                    values.append(f"'{value}'")

        sql = f"""
-- ============================================================================
-- Building Insert
-- ============================================================================
INSERT INTO buildings (
    {', '.join(fields)}
)
VALUES (
    {', '.join(values)}
);"""

        return sql

    def _generate_blocks_insert(self, data: Dict) -> str:
        """Generate building blocks INSERT for multi-block developments"""
        blocks = data.get('blocks', [])
        if not blocks or not isinstance(blocks, list):
            return ""

        sql_parts = ["""
-- ============================================================================
-- Building Blocks
-- ============================================================================"""]

        for block in blocks:
            block_id = str(uuid.uuid4())

            sql_parts.append(f"""
INSERT INTO building_blocks (
    id, building_id, block_identifier, num_units
)
VALUES (
    '{block_id}', '{self.building_id}', '{block}', NULL
);""")

        return "\n".join(sql_parts)

    def _generate_units_insert(self, data: Dict) -> str:
        """Generate units INSERT statements"""
        units = data.get('units', [])
        if not units:
            return ""

        sql_parts = ["""
-- ============================================================================
-- Units
-- ============================================================================"""]

        for unit in units:
            unit_id = str(uuid.uuid4())
            unit_number = unit.get('unit_number', 'Unknown')
            self.unit_ids[unit_number] = unit_id

            sql_parts.append(f"""
INSERT INTO units (
    id, building_id, unit_number, unit_reference, unit_type,
    apportionment_percentage, apportionment_method,
    source_document, data_quality
)
VALUES (
    '{unit_id}',
    '{self.building_id}',
    '{self._sql_escape(unit_number)}',
    '{self._sql_escape(unit.get('unit_reference', ''))}',
    '{self._sql_escape(unit.get('unit_type', 'Flat'))}',
    {unit.get('apportionment_percentage', 0)},
    '{self._sql_escape(unit.get('apportionment_method', ''))}',
    '{self._sql_escape(unit.get('source_document', ''))}',
    '{self._sql_escape(unit.get('data_quality', 'high'))}'
);""")

        return "\n".join(sql_parts)

    def _generate_leaseholders_insert(self, data: Dict) -> str:
        """Generate leaseholders INSERT statements"""
        leaseholders = data.get('leaseholders', [])
        if not leaseholders:
            return ""

        sql_parts = ["""
-- ============================================================================
-- Leaseholders
-- ============================================================================"""]

        for lh in leaseholders:
            lh_id = str(uuid.uuid4())
            unit_number = lh.get('unit_number', '')
            unit_id = self.unit_ids.get(unit_number)

            if not unit_id:
                continue  # Skip if unit not found

            self.leaseholder_ids[f"{unit_number}_{lh.get('leaseholder_name', '')}"] = lh_id

            sql_parts.append(f"""
INSERT INTO leaseholders (
    id, unit_id, leaseholder_name, correspondence_address,
    telephone, email, status, current_balance,
    data_source, data_quality
)
VALUES (
    '{lh_id}',
    '{unit_id}',
    '{self._sql_escape(lh.get('leaseholder_name', 'Unknown'))}',
    '{self._sql_escape(lh.get('correspondence_address', ''))}',
    '{self._sql_escape(lh.get('telephone', ''))}',
    '{self._sql_escape(lh.get('email', ''))}',
    '{self._sql_escape(lh.get('status', 'Current'))}',
    {lh.get('balance', 0)},
    '{self._sql_escape(lh.get('data_source', ''))}',
    '{self._sql_escape(lh.get('data_quality', 'high'))}'
);""")

        return "\n".join(sql_parts)

    def _generate_compliance_insert(self, data: Dict) -> str:
        """Generate compliance assets INSERT statements"""
        assets = data.get('compliance_assets_all', [])
        if not assets:
            return ""

        sql_parts = ["""
-- ============================================================================
-- Compliance Assets
-- ============================================================================
-- Note: asset_type_id references compliance_asset_types table
-- Map asset_type to correct UUID from compliance_asset_types table
"""]

        for asset in assets:
            asset_id = str(uuid.uuid4())
            asset_type = asset.get('asset_type', 'Unknown')

            # Create lookup comment
            sql_parts.append(f"""
-- {asset_type}
INSERT INTO compliance_assets (
    id, building_id,
    asset_type_id, -- TODO: Replace with actual UUID from compliance_asset_types WHERE asset_type_code = '{self._get_asset_type_code(asset_type)}'
    inspection_date, expiry_date, next_due_date,
    status, days_overdue,
    is_inferred, inference_reason, last_known_inspection, evidence_found,
    source_document, data_quality
)
VALUES (
    '{asset_id}',
    '{self.building_id}',
    (SELECT id FROM compliance_asset_types WHERE asset_type_code = '{self._get_asset_type_code(asset_type)}' LIMIT 1),
    {self._sql_date(asset.get('inspection_date'))},
    {self._sql_date(asset.get('expiry_date'))},
    {self._sql_date(asset.get('next_due_date'))},
    '{self._sql_escape(asset.get('status', 'unknown'))}',
    {asset.get('days_overdue') or 'NULL'},
    {self._sql_bool(asset.get('is_inferred', False))},
    '{self._sql_escape(asset.get('inference_reason', ''))}',
    {self._sql_date(asset.get('last_known_inspection'))},
    {self._sql_bool(asset.get('evidence_found', False))},
    '{self._sql_escape(asset.get('source_document', ''))}',
    '{self._sql_escape(asset.get('data_quality', 'medium'))}'
);""")

        return "\n".join(sql_parts)

    def _generate_contracts_insert(self, data: Dict) -> str:
        """Generate maintenance contracts INSERT statements"""
        contracts = data.get('maintenance_contracts', [])
        if not contracts:
            return ""

        sql_parts = ["""
-- ============================================================================
-- Maintenance Contracts
-- ============================================================================
-- Note: contract_type_id references contract_types table
"""]

        for contract in contracts:
            contract_id = str(uuid.uuid4())
            contract_type = contract.get('contract_type', 'General Maintenance')
            contractor_name = contract.get('contractor_name', 'Unknown')
            
            # Track contract_id for schedules
            self.contract_ids[contractor_name] = contract_id

            sql_parts.append(f"""
-- {contract_type}
INSERT INTO maintenance_contracts (
    id, building_id,
    contract_type_id, -- TODO: Replace with actual UUID from contract_types
    contractor_name, contractor_company,
    contract_start_date, contract_end_date, contract_auto_renew,
    contract_value_annual, maintenance_frequency, contract_status,
    detection_confidence, is_new_type, requires_review,
    source_folder, data_quality
)
VALUES (
    '{contract_id}',
    '{self.building_id}',
    (SELECT id FROM contract_types WHERE contract_type_code = '{self._get_contract_type_code(contract_type)}' LIMIT 1),
    '{self._sql_escape(contract.get('contractor_name', 'Unknown'))}',
    '{self._sql_escape(contract.get('contractor_company', ''))}',
    {self._sql_date(contract.get('contract_start_date'))},
    {self._sql_date(contract.get('contract_end_date'))},
    {self._sql_bool(contract.get('contract_auto_renew', False))},
    {contract.get('contract_cost_pa') or 'NULL'},
    '{self._sql_escape(contract.get('maintenance_frequency', ''))}',
    '{self._sql_escape(contract.get('contract_status', 'Unknown'))}',
    {contract.get('detection_confidence', 0)},
    {self._sql_bool(contract.get('is_new_type', False))},
    {self._sql_bool(contract.get('requires_review', False))},
    '{self._sql_escape(contract.get('contract_source_path', ''))}',
    '{self._sql_escape(contract.get('data_quality', 'medium'))}'
);""")

        return "\n".join(sql_parts)

    def _generate_budgets_insert(self, data: Dict) -> str:
        """Generate budgets INSERT statement"""
        # Extract budget from data
        summary = data.get('summary', {})
        budget_total = summary.get('service_charge_budget') or summary.get('total_budget')

        if not budget_total:
            return ""

        budget_id = str(uuid.uuid4())
        current_year = datetime.now().year

        sql = f"""
-- ============================================================================
-- Budget
-- ============================================================================
INSERT INTO budgets (
    id, building_id, budget_year, total_budget, status
)
VALUES (
    '{budget_id}',
    '{self.building_id}',
    {current_year},
    {budget_total},
    'Approved'
);"""

        return sql

    def _generate_documents_insert(self, data: Dict, source_folder: str = None) -> str:
        """Generate documents registry INSERT statements (metadata only, no uploads)"""
        if not source_folder:
            return ""

        sql_parts = [f"""
-- ============================================================================
-- Documents Registry
-- ============================================================================
-- Documents reference where files SHOULD be uploaded in Supabase Storage
-- Bucket: {self.storage_bucket}
-- Path structure: {self.storage_bucket}/{self.building_id}/...
--
-- MANUAL UPLOAD REQUIRED:
-- 1. Upload all files from: {source_folder}
-- 2. To Supabase Storage bucket: {self.storage_bucket}
-- 3. Preserve folder structure under building_id
-- ============================================================================
"""]

        # Example document entries for key folders
        folder_types = [
            ('1. CLIENT INFORMATION', 'Client Information'),
            ('4. HEALTH & SAFETY', 'Health & Safety'),
            ('7. CONTRACTS', 'Contracts'),
        ]

        for folder_name, doc_category in folder_types:
            doc_id = str(uuid.uuid4())
            storage_path = f"{self.building_id}/{folder_name}"

            sql_parts.append(f"""
-- {doc_category} Folder
INSERT INTO documents (
    id, building_id, document_name, document_type, document_category,
    storage_bucket, storage_path
)
VALUES (
    '{doc_id}',
    '{self.building_id}',
    '{folder_name}',
    'Folder',
    '{doc_category}',
    '{self.storage_bucket}',
    '{storage_path}'
);""")

        sql_parts.append("""
-- Additional documents to be added after manual upload
-- You can query uploaded files and insert document records programmatically
""")

        return "\n".join(sql_parts)

    def _generate_extraction_run(self, data: Dict, stats: Dict, source_folder: str = None) -> str:
        """Generate extraction run metadata"""

        sql = f"""
-- ============================================================================
-- Extraction Run Metadata
-- ============================================================================
INSERT INTO extraction_runs (
    id, building_id, extraction_date, extraction_version,
    units_extracted, leaseholders_extracted,
    compliance_assets_extracted, contracts_extracted,
    data_quality, confidence_score,
    new_types_discovered, low_confidence_detections,
    source_folder, extraction_status
)
VALUES (
    '{self.extraction_run_id}',
    '{self.building_id}',
    NOW(),
    '{self._sql_escape(data.get('extraction_version', 'v6.0'))}',
    {stats.get('units', 0)},
    {stats.get('leaseholders', 0)},
    {stats.get('compliance_assets', 0)},
    {stats.get('contracts', 0)},
    '{self._sql_escape(data.get('data_quality', 'production'))}',
    {data.get('confidence_score', 0.98)},
    {data.get('summary', {}).get('new_contract_types_discovered', 0)},
    {data.get('contract_summary', {}).get('low_confidence_detections', 0)},
    '{self._sql_escape(source_folder or '')}',
    'Success'
);"""

        return sql

    # ========================================================================
    # Helper Methods
    # ========================================================================

    def _sql_escape(self, value: Any) -> str:
        """Escape SQL string values"""
        if value is None:
            return ''
        value = str(value).replace("'", "''")  # Escape single quotes
        return value

    def _sql_bool(self, value: bool) -> str:
        """Convert Python bool to SQL boolean"""
        return 'TRUE' if value else 'FALSE'

    def _sql_date(self, date_value: Any) -> str:
        """Format date for SQL"""
        if not date_value or date_value in ['', 'None', None]:
            return 'NULL'
        # Assume date is already in YYYY-MM-DD format
        return f"'{date_value}'"

    def _get_asset_type_code(self, asset_type: str) -> str:
        """Map asset type name to database code"""
        mapping = {
            'FRA': 'FRA',
            'Fire Risk Assessment': 'FRA',
            'EICR': 'EICR',
            'Electrical Certificate': 'EICR',
            'Legionella': 'LEGIONELLA',
            'Water Hygiene': 'LEGIONELLA',
            'Asbestos': 'ASBESTOS',
            'Fire Door': 'FIRE_DOOR',
            'Fire Alarm': 'FIRE_ALARM',
            'Emergency Lighting': 'EMERGENCY_LIGHTING',
            'Lift': 'LIFT_LOLER',
            'LOLER': 'LIFT_LOLER',
            'Gas Safety': 'GAS_SAFETY',
            'PAT Testing': 'PAT',
            'Lightning Protection': 'LIGHTNING',
            'Sprinkler System': 'SPRINKLER',
            'AOV': 'AOV',
            'Dry Riser': 'DRY_RISER',
        }
        return mapping.get(asset_type, 'UNKNOWN')

    def _get_contract_type_code(self, contract_type: str) -> str:
        """Map contract type name to database code"""
        mapping = {
            'Lift Maintenance': 'LIFT_MAINTENANCE',
            'Fire Alarm': 'FIRE_ALARM',
            'Cleaning': 'CLEANING',
            'Gardening': 'GARDENING',
            'Pest Control': 'PEST_CONTROL',
            'Water Hygiene': 'WATER_HYGIENE',
            'CCTV': 'CCTV',
            'Door Entry': 'DOOR_ENTRY',
            'Swimming Pool': 'POOL',
            'Gym': 'GYM',
            'EV Charging': 'EV_CHARGING',
        }
        return mapping.get(contract_type, 'GENERAL_MAINTENANCE')


# ============================================================================
# CLI Interface
# ============================================================================

def main():
    """CLI entry point"""
    import argparse

    parser = argparse.ArgumentParser(description='Generate Supabase SQL from BlocIQ extraction data')
    parser.add_argument('json_file', help='Input JSON file from extraction')
    parser.add_argument('-o', '--output', help='Output SQL file', default=None)
    parser.add_argument('--source-folder', help='Original source folder path', default=None)

    args = parser.parse_args()

    # Load JSON data
    with open(args.json_file, 'r') as f:
        data = json.load(f)

    # Determine output file
    if args.output:
        output_file = args.output
    else:
        output_file = args.json_file.replace('.json', '_supabase.sql')

    # Generate SQL
    generator = SQLGeneratorV2()
    stats = generator.generate_sql_file(data, output_file, args.source_folder)

    print(f"\n✅ Complete!")
    print(f"\n📝 Next Steps:")
    print(f"   1. Review SQL file: {output_file}")
    print(f"   2. Run SQL in Supabase SQL Editor")
    print(f"   3. Manually upload documents to Supabase Storage bucket: {generator.storage_bucket}")
    print(f"   4. Upload to path: {generator.storage_bucket}/{generator.building_id}/")


if __name__ == '__main__':
    main()
