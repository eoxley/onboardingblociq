"""
BlocIQ Onboarder - SQL Writer
Generates Supabase-ready SQL migration scripts with exact schema compliance
"""

from typing import Dict, List, Any
import json
from schema_mapper import SupabaseSchemaMapper


class SQLWriter:
    """Generates SQL INSERT statements for Supabase with exact schema compliance"""

    def __init__(self):
        self.sql_statements = []
        self.schema_mapper = SupabaseSchemaMapper()
        self.portfolio_id = None  # Will be generated per migration

    def generate_migration(self, mapped_data: Dict) -> str:
        """
        Generate complete SQL migration script

        Args:
            mapped_data: Dictionary containing mapped data for all tables

        Returns:
            SQL migration script as string
        """
        import uuid

        self.sql_statements = []
        # Generate unique portfolio ID for this migration
        self.portfolio_id = str(uuid.uuid4())

        # Header (includes agency placeholder)
        self._add_header()

        # Generate INSERTs in dependency order
        if 'building' in mapped_data:
            self._generate_building_insert(mapped_data['building'])

        # Generate schedules (must be after building, before budgets/units/assets)
        if 'schedules' in mapped_data:
            self._generate_schedules_inserts(mapped_data['schedules'])

        if 'units' in mapped_data:
            self._generate_units_inserts(mapped_data['units'])

        if 'leaseholders' in mapped_data:
            self._generate_leaseholders_inserts(mapped_data['leaseholders'])

        # BlocIQ V2: Compliance assets (must be before building_compliance_assets)
        if 'compliance_assets' in mapped_data:
            self._generate_compliance_assets_inserts(mapped_data['compliance_assets'])

        # BlocIQ V2: Major works projects (must be before notices)
        if 'major_works_projects' in mapped_data:
            self._generate_major_works_inserts(mapped_data['major_works_projects'])

        # BlocIQ V2: Budgets (must be before documents)
        if 'budgets' in mapped_data:
            self._generate_budgets_inserts(mapped_data['budgets'])

        # BlocIQ V2: Building documents (includes all original files with category)
        if 'building_documents' in mapped_data:
            self._generate_documents_inserts(mapped_data['building_documents'])

        # BlocIQ V2: Building compliance assets (links building to compliance + document)
        if 'building_compliance_assets' in mapped_data:
            self._generate_building_compliance_assets_inserts(mapped_data['building_compliance_assets'])

        # BlocIQ V2: Major works notices (links project to document)
        if 'major_works_notices' in mapped_data:
            self._generate_major_works_notices_inserts(mapped_data['major_works_notices'])

        # BlocIQ V2: Apportionments (links units to budgets)
        if 'apportionments' in mapped_data:
            self._generate_apportionments_inserts(mapped_data['apportionments'])

        # BlocIQ V2: Uncategorised documents (for manual review)
        if 'uncategorised_docs' in mapped_data:
            self._generate_uncategorised_docs_inserts(mapped_data['uncategorised_docs'])

        # Compliance inspections (legacy)
        if 'compliance_inspections' in mapped_data:
            self._generate_compliance_inspections_inserts(mapped_data['compliance_inspections'])

        # Property form structured data tables
        if 'building_contractors' in mapped_data:
            self._generate_building_contractors_inserts(mapped_data['building_contractors'])

        if 'building_utilities' in mapped_data:
            self._generate_building_utilities_inserts(mapped_data['building_utilities'])

        if 'building_insurance' in mapped_data:
            self._generate_building_insurance_inserts(mapped_data['building_insurance'])

        if 'building_legal' in mapped_data:
            self._generate_building_legal_inserts(mapped_data['building_legal'])

        if 'building_statutory_reports' in mapped_data:
            self._generate_building_statutory_reports_inserts(mapped_data['building_statutory_reports'])

        if 'building_keys_access' in mapped_data:
            self._generate_building_keys_access_inserts(mapped_data['building_keys_access'])

        if 'building_warranties' in mapped_data:
            self._generate_building_warranties_inserts(mapped_data['building_warranties'])

        if 'company_secretary' in mapped_data and mapped_data['company_secretary']:
            self._generate_company_secretary_insert(mapped_data['company_secretary'])

        if 'building_staff' in mapped_data:
            self._generate_building_staff_inserts(mapped_data['building_staff'])

        if 'building_title_deeds' in mapped_data:
            self._generate_building_title_deeds_inserts(mapped_data['building_title_deeds'])

        # New tables: contractors, contracts, assets, maintenance_schedules
        if 'contractors' in mapped_data:
            self._generate_contractors_inserts(mapped_data['contractors'])

        if 'contracts' in mapped_data:
            self._generate_contracts_inserts(mapped_data['contracts'])

        if 'building_contractor_links' in mapped_data:
            self._generate_building_contractor_links_inserts(mapped_data['building_contractor_links'])

        if 'assets' in mapped_data:
            self._generate_assets_inserts(mapped_data['assets'])

        if 'maintenance_schedules' in mapped_data:
            self._generate_maintenance_schedules_inserts(mapped_data['maintenance_schedules'])

        # Financial & Compliance Intelligence
        if 'fire_door_inspections' in mapped_data:
            self._generate_fire_door_inspections_inserts(mapped_data['fire_door_inspections'])

        # Timeline Events (error logging and audit trail)
        if 'timeline_events' in mapped_data:
            self._generate_timeline_events_inserts(mapped_data['timeline_events'])

        # Leases
        if 'leases' in mapped_data:
            self._generate_leases_inserts(mapped_data['leases'])

        # Footer
        self._add_footer()

        return '\n'.join(self.sql_statements)

    def _add_header(self):
        """Add migration header with agency placeholder block and schema migrations"""
        self.sql_statements.extend([
            "-- BlocIQ Onboarder - Auto-generated Migration",
            f"-- Generated at: {self._now()}",
            "-- Review this script before executing!",
            "",
            "-- =====================================",
            "-- REQUIRED: Replace AGENCY_ID_PLACEHOLDER with your agency UUID",
            "-- =====================================",
            "",
            "-- =====================================",
            "-- SCHEMA MIGRATIONS: Add missing columns if they don't exist",
            "-- =====================================",
            "",
            "-- Add building_id to leaseholders (if not exists)",
            "ALTER TABLE leaseholders ADD COLUMN IF NOT EXISTS building_id uuid;",
            "",
            "-- Add unit_number to leaseholders (if not exists)",
            "ALTER TABLE leaseholders ADD COLUMN IF NOT EXISTS unit_number VARCHAR(50);",
            "",
            "-- Add year_start and year_end to budgets (if not exists)",
            "ALTER TABLE budgets ADD COLUMN IF NOT EXISTS year_start DATE;",
            "ALTER TABLE budgets ADD COLUMN IF NOT EXISTS year_end DATE;",
            "",
            "-- Add expiry_date to building_insurance (if not exists)",
            "ALTER TABLE building_insurance ADD COLUMN IF NOT EXISTS expiry_date DATE;",
            "",
            "-- Add expiry_date to leases (if not exists)",
            "ALTER TABLE leases ADD COLUMN IF NOT EXISTS expiry_date DATE;",
            "",
            "-- Add building_id to apportionments (if not exists)",
            "ALTER TABLE apportionments ADD COLUMN IF NOT EXISTS building_id uuid;",
            "",
            "-- Add building_id to major_works_notices (if not exists)",
            "ALTER TABLE major_works_notices ADD COLUMN IF NOT EXISTS building_id uuid;",
            "",
            "-- Add foreign key constraints (if not exist)",
            "DO $$ BEGIN",
            "  ALTER TABLE leaseholders ADD CONSTRAINT fk_leaseholders_building FOREIGN KEY (building_id) REFERENCES buildings(id);",
            "EXCEPTION WHEN duplicate_object THEN NULL;",
            "END $$;",
            "",
            "DO $$ BEGIN",
            "  ALTER TABLE apportionments ADD CONSTRAINT fk_apportionments_building FOREIGN KEY (building_id) REFERENCES buildings(id);",
            "EXCEPTION WHEN duplicate_object THEN NULL;",
            "END $$;",
            "",
            "DO $$ BEGIN",
            "  ALTER TABLE major_works_notices ADD CONSTRAINT fk_major_works_notices_building FOREIGN KEY (building_id) REFERENCES buildings(id);",
            "EXCEPTION WHEN duplicate_object THEN NULL;",
            "END $$;",
            "",
            "-- Create indexes for performance (if not exist)",
            "CREATE INDEX IF NOT EXISTS idx_leaseholders_building_id ON leaseholders(building_id);",
            "CREATE INDEX IF NOT EXISTS idx_apportionments_building_id ON apportionments(building_id);",
            "CREATE INDEX IF NOT EXISTS idx_major_works_notices_building_id ON major_works_notices(building_id);",
            "",
            "-- Add compliance tracking columns to compliance_assets",
            "ALTER TABLE compliance_assets "
            "ADD COLUMN IF NOT EXISTS last_inspection_date DATE, "
            "ADD COLUMN IF NOT EXISTS next_due_date DATE, "
            "ADD COLUMN IF NOT EXISTS compliance_status VARCHAR(50) DEFAULT 'unknown', "
            "ADD COLUMN IF NOT EXISTS location VARCHAR(255), "
            "ADD COLUMN IF NOT EXISTS responsible_party VARCHAR(255), "
            "ADD COLUMN IF NOT EXISTS notes TEXT;",
            "",
            "-- Create index on compliance status for quick filtering",
            "CREATE INDEX IF NOT EXISTS idx_compliance_assets_status ON compliance_assets(compliance_status);",
            "CREATE INDEX IF NOT EXISTS idx_compliance_assets_next_due ON compliance_assets(next_due_date);",
            "",
            "-- Add contract lifecycle tracking columns to building_contractors",
            "ALTER TABLE building_contractors "
            "ADD COLUMN IF NOT EXISTS retender_status text DEFAULT 'not_scheduled', "
            "ADD COLUMN IF NOT EXISTS retender_due_date date, "
            "ADD COLUMN IF NOT EXISTS next_review_date date, "
            "ADD COLUMN IF NOT EXISTS renewal_notice_period interval DEFAULT interval '90 days';",
            "",
            "-- Create index on contract lifecycle for quick filtering",
            "CREATE INDEX IF NOT EXISTS idx_building_contractors_retender_due ON building_contractors(retender_due_date);",
            "CREATE INDEX IF NOT EXISTS idx_building_contractors_retender_status ON building_contractors(retender_status);",
            "",
            "-- =====================================",
            "-- FINANCIAL & COMPLIANCE INTELLIGENCE TABLES",
            "-- =====================================",
            "",
            "-- Fire Door Inspections",
            "CREATE TABLE IF NOT EXISTS fire_door_inspections (",
            "  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),",
            "  building_id uuid REFERENCES buildings(id),",
            "  unit_id uuid REFERENCES units(id),",
            "  location text,",
            "  inspection_date date,",
            "  status text CHECK (status IN ('compliant','non-compliant','overdue','unknown')),",
            "  notes text,",
            "  document_path text,",
            "  created_at timestamptz DEFAULT now()",
            ");",
            "",
            "CREATE INDEX IF NOT EXISTS idx_fire_door_inspections_building ON fire_door_inspections(building_id);",
            "CREATE INDEX IF NOT EXISTS idx_fire_door_inspections_status ON fire_door_inspections(status);",
            "",
            "-- Budgets",
            "CREATE TABLE IF NOT EXISTS budgets (",
            "  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),",
            "  building_id uuid REFERENCES buildings(id),",
            "  year_start date,",
            "  year_end date,",
            "  total_amount numeric(15,2),",
            "  status text CHECK (status IN ('draft','final','approved')),",
            "  source_document text,",
            "  notes text,",
            "  created_at timestamptz DEFAULT now()",
            ");",
            "",
            "CREATE INDEX IF NOT EXISTS idx_budgets_building ON budgets(building_id);",
            "CREATE INDEX IF NOT EXISTS idx_budgets_year ON budgets(year_start);",
            "",
            "-- Building Insurance",
            "CREATE TABLE IF NOT EXISTS building_insurance (",
            "  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),",
            "  building_id uuid REFERENCES buildings(id),",
            "  provider text,",
            "  policy_number text,",
            "  expiry_date date,",
            "  premium_amount numeric(15,2),",
            "  source_document text,",
            "  notes text,",
            "  created_at timestamptz DEFAULT now()",
            ");",
            "",
            "CREATE INDEX IF NOT EXISTS idx_building_insurance_building ON building_insurance(building_id);",
            "CREATE INDEX IF NOT EXISTS idx_building_insurance_expiry ON building_insurance(expiry_date);",
            "",
            "-- Building Staff",
            "CREATE TABLE IF NOT EXISTS building_staff (",
            "  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),",
            "  building_id uuid REFERENCES buildings(id),",
            "  name text NOT NULL,",
            "  role text,",
            "  contact_info text,",
            "  hours text,",
            "  company_name text,",
            "  contractor_id uuid REFERENCES building_contractors(id),",
            "  source_document text,",
            "  notes text,",
            "  created_at timestamptz DEFAULT now()",
            ");",
            "",
            "CREATE INDEX IF NOT EXISTS idx_building_staff_building ON building_staff(building_id);",
            "CREATE INDEX IF NOT EXISTS idx_building_staff_role ON building_staff(role);",
            "",
            "-- Timeline Events (for error logging and audit trail)",
            "CREATE TABLE IF NOT EXISTS timeline_events (",
            "  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),",
            "  building_id uuid REFERENCES buildings(id),",
            "  event_type text NOT NULL,",
            "  event_date timestamptz DEFAULT now(),",
            "  description text,",
            "  metadata jsonb,",
            "  severity text CHECK (severity IN ('info','warning','error')) DEFAULT 'info',",
            "  created_at timestamptz DEFAULT now()",
            ");",
            "",
            "CREATE INDEX IF NOT EXISTS idx_timeline_events_building ON timeline_events(building_id);",
            "CREATE INDEX IF NOT EXISTS idx_timeline_events_type ON timeline_events(event_type);",
            "CREATE INDEX IF NOT EXISTS idx_timeline_events_date ON timeline_events(event_date);",
            "",
            "-- Leases",
            "CREATE TABLE IF NOT EXISTS leases (",
            "  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),",
            "  building_id uuid REFERENCES buildings(id),",
            "  unit_id uuid REFERENCES units(id),",
            "  term_start date,",
            "  term_years integer,",
            "  expiry_date date,",
            "  ground_rent numeric(10,2),",
            "  rent_review_period integer,",
            "  leaseholder_name text,",
            "  lessor_name text,",
            "  source_document text,",
            "  notes text,",
            "  created_at timestamptz DEFAULT now()",
            ");",
            "",
            "CREATE INDEX IF NOT EXISTS idx_leases_building ON leases(building_id);",
            "CREATE INDEX IF NOT EXISTS idx_leases_unit ON leases(unit_id);",
            "CREATE INDEX IF NOT EXISTS idx_leases_expiry ON leases(expiry_date);",
            "",
            "-- =====================================",
            "-- DATA MIGRATION: Insert building data",
            "-- =====================================",
            "",
            "-- Insert agency (required for portfolios foreign key)",
            "-- NOTE: Replace 'AGENCY_ID_PLACEHOLDER' with your actual agency UUID",
            "-- and 'Your Agency Name' with your agency name",
            "INSERT INTO agencies (id, name)",
            "VALUES ('AGENCY_ID_PLACEHOLDER', 'Your Agency Name')",
            "ON CONFLICT (id) DO NOTHING;",
            "",
            "-- Insert portfolio (linked to agency above)",
            "INSERT INTO portfolios (id, agency_id, name)",
            f"VALUES ('{self.portfolio_id}', 'AGENCY_ID_PLACEHOLDER', 'Default Portfolio')",
            "ON CONFLICT (id) DO NOTHING;",
            "",
            "BEGIN;",
            ""
        ])

    def _add_footer(self):
        """Add migration footer"""
        self.sql_statements.extend([
            "",
            "-- Migration complete",
            "COMMIT;",
            "",
            "-- Rollback command (if needed):",
            "-- ROLLBACK;"
        ])

    def _generate_building_insert(self, building: Dict):
        """Generate INSERT for buildings table with portfolio_id"""
        # Add portfolio_id to building data
        building_with_portfolio = building.copy()
        building_with_portfolio['portfolio_id'] = self.portfolio_id

        self.sql_statements.append("-- Insert building")
        self.sql_statements.append(
            self._create_insert_statement('buildings', building_with_portfolio, use_upsert=False)
        )
        self.sql_statements.append("")

    def _generate_schedules_inserts(self, schedules: List[Dict]):
        """Generate INSERTs for schedules table"""
        if not schedules:
            return

        self.sql_statements.append(f"-- Insert {len(schedules)} schedule(s)")

        for schedule in schedules:
            self.sql_statements.append(
                self._create_insert_statement('schedules', schedule, use_upsert=False)
            )

        # Log created schedules
        schedule_names = [s.get('name', 'Unknown') for s in schedules]
        self.sql_statements.append(f"-- Created schedules: {', '.join(schedule_names)}")
        self.sql_statements.append("")

    def _generate_units_inserts(self, units: List[Dict]):
        """Generate INSERTs for units table"""
        if not units:
            return

        self.sql_statements.append(f"-- Insert {len(units)} units")

        for unit in units:
            self.sql_statements.append(
                self._create_insert_statement('units', unit, use_upsert=False)
            )

        self.sql_statements.append("")

    def _generate_leaseholders_inserts(self, leaseholders: List[Dict]):
        """Generate INSERTs for leaseholders table"""
        if not leaseholders:
            return

        self.sql_statements.append(f"-- Insert {len(leaseholders)} leaseholders")

        for leaseholder in leaseholders:
            self.sql_statements.append(
                self._create_insert_statement('leaseholders', leaseholder, use_upsert=False)
            )

        self.sql_statements.append("")

    def _generate_documents_inserts(self, documents: List[Dict]):
        """Generate INSERTs for building_documents table"""
        if not documents:
            return

        self.sql_statements.append(f"-- Insert {len(documents)} document records")

        for doc in documents:
            self.sql_statements.append(
                self._create_insert_statement('building_documents', doc, use_upsert=False)
            )

        self.sql_statements.append("")

    def _generate_compliance_assets_inserts(self, assets: List[Dict]):
        """Generate INSERTs for compliance_assets table"""
        if not assets:
            return

        self.sql_statements.append(f"-- Insert {len(assets)} compliance assets")

        # DEBUG: Check first asset
        if assets:
            print(f"\n🔍 DEBUG: First compliance_asset before SQL generation:")
            print(f"  Keys: {list(assets[0].keys())}")
            print(f"  building_id present: {'building_id' in assets[0]}")
            print(f"  building_id value: {assets[0].get('building_id')}")
            print()

        for asset in assets:
            self.sql_statements.append(
                self._create_insert_statement('compliance_assets', asset, use_upsert=False)
            )

        self.sql_statements.append("")

    def _generate_compliance_inspections_inserts(self, inspections: List[Dict]):
        """Generate INSERTs for compliance_inspections table"""
        if not inspections:
            return

        self.sql_statements.append(f"-- Insert {len(inspections)} compliance inspections")

        for inspection in inspections:
            self.sql_statements.append(
                self._create_insert_statement('compliance_inspections', inspection, use_upsert=False)
            )

        self.sql_statements.append("")

    def _generate_major_works_inserts(self, projects: List[Dict]):
        """Generate INSERTs for major_works_projects table"""
        if not projects:
            return

        self.sql_statements.append(f"-- Insert {len(projects)} major works projects")

        for project in projects:
            self.sql_statements.append(
                self._create_insert_statement('major_works_projects', project, use_upsert=False)
            )

        self.sql_statements.append("")

    def _generate_budgets_inserts(self, budgets: List[Dict]):
        """Generate INSERTs for budgets table"""
        if not budgets:
            return

        self.sql_statements.append(f"-- Insert {len(budgets)} budgets")

        for budget in budgets:
            self.sql_statements.append(
                self._create_insert_statement('budgets', budget, use_upsert=False)
            )

        self.sql_statements.append("")

    def _generate_apportionments_inserts(self, apportionments: List[Dict]):
        """Generate INSERTs for apportionments table"""
        if not apportionments:
            return

        self.sql_statements.append(f"-- Insert {len(apportionments)} apportionments")

        for apportionment in apportionments:
            self.sql_statements.append(
                self._create_insert_statement('apportionments', apportionment, use_upsert=False)
            )

        self.sql_statements.append("")

    def _generate_building_compliance_assets_inserts(self, assets: List[Dict]):
        """Generate INSERTs for building_compliance_assets table"""
        if not assets:
            return

        self.sql_statements.append(f"-- Insert {len(assets)} building compliance asset links")

        for asset in assets:
            self.sql_statements.append(
                self._create_insert_statement('building_compliance_assets', asset, use_upsert=False)
            )

        self.sql_statements.append("")

    def _generate_major_works_notices_inserts(self, notices: List[Dict]):
        """Generate INSERTs for major_works_notices table"""
        if not notices:
            return

        self.sql_statements.append(f"-- Insert {len(notices)} major works notices")

        for notice in notices:
            self.sql_statements.append(
                self._create_insert_statement('major_works_notices', notice, use_upsert=False)
            )

        self.sql_statements.append("")

    def _generate_uncategorised_docs_inserts(self, docs: List[Dict]):
        """Generate INSERTs for uncategorised_docs table - BlocIQ V2"""
        if not docs:
            return

        self.sql_statements.append(f"-- Insert {len(docs)} uncategorised documents for manual review")

        for doc in docs:
            self.sql_statements.append(
                self._create_insert_statement('uncategorised_docs', doc, use_upsert=False)
            )

        self.sql_statements.append("")

    def _generate_building_contractors_inserts(self, contractors: List[Dict]):
        """Generate INSERTs for building_contractors table"""
        if not contractors:
            return

        self.sql_statements.append(f"-- Insert {len(contractors)} building contractors")

        for contractor in contractors:
            self.sql_statements.append(
                self._create_insert_statement('building_contractors', contractor, use_upsert=False)
            )

        self.sql_statements.append("")

    def _generate_building_utilities_inserts(self, utilities: List[Dict]):
        """Generate INSERTs for building_utilities table"""
        if not utilities:
            return

        self.sql_statements.append(f"-- Insert {len(utilities)} building utilities")

        for utility in utilities:
            self.sql_statements.append(
                self._create_insert_statement('building_utilities', utility, use_upsert=False)
            )

        self.sql_statements.append("")

    def _generate_building_insurance_inserts(self, insurance_records: List[Dict]):
        """Generate INSERTs for building_insurance table"""
        if not insurance_records:
            return

        self.sql_statements.append(f"-- Insert {len(insurance_records)} insurance records")

        for record in insurance_records:
            self.sql_statements.append(
                self._create_insert_statement('building_insurance', record, use_upsert=False)
            )

        self.sql_statements.append("")

    def _generate_building_legal_inserts(self, legal_records: List[Dict]):
        """Generate INSERTs for building_legal table"""
        if not legal_records:
            return

        self.sql_statements.append(f"-- Insert {len(legal_records)} legal records")

        for record in legal_records:
            self.sql_statements.append(
                self._create_insert_statement('building_legal', record, use_upsert=False)
            )

        self.sql_statements.append("")

    def _generate_building_statutory_reports_inserts(self, reports: List[Dict]):
        """Generate INSERTs for building_statutory_reports table"""
        if not reports:
            return

        self.sql_statements.append(f"-- Insert {len(reports)} statutory reports")

        for report in reports:
            self.sql_statements.append(
                self._create_insert_statement('building_statutory_reports', report, use_upsert=False)
            )

        self.sql_statements.append("")

    def _generate_building_keys_access_inserts(self, access_records: List[Dict]):
        """Generate INSERTs for building_keys_access table"""
        if not access_records:
            return

        self.sql_statements.append(f"-- Insert {len(access_records)} keys/access records")

        for record in access_records:
            self.sql_statements.append(
                self._create_insert_statement('building_keys_access', record, use_upsert=False)
            )

        self.sql_statements.append("")

    def _generate_building_warranties_inserts(self, warranties: List[Dict]):
        """Generate INSERTs for building_warranties table"""
        if not warranties:
            return

        self.sql_statements.append(f"-- Insert {len(warranties)} warranties")

        for warranty in warranties:
            self.sql_statements.append(
                self._create_insert_statement('building_warranties', warranty, use_upsert=False)
            )

        self.sql_statements.append("")

    def _generate_company_secretary_insert(self, company_secretary: Dict):
        """Generate INSERT for company_secretary table"""
        if not company_secretary:
            return

        self.sql_statements.append("-- Insert company secretary data")
        self.sql_statements.append(
            self._create_insert_statement('company_secretary', company_secretary, use_upsert=False)
        )
        self.sql_statements.append("")

    def _generate_building_staff_inserts(self, staff_records: List[Dict]):
        """Generate INSERTs for building_staff table"""
        if not staff_records:
            return

        self.sql_statements.append(f"-- Insert {len(staff_records)} staff records")

        for record in staff_records:
            self.sql_statements.append(
                self._create_insert_statement('building_staff', record, use_upsert=False)
            )

        self.sql_statements.append("")

    def _generate_building_title_deeds_inserts(self, title_deeds: List[Dict]):
        """Generate INSERTs for building_title_deeds table"""
        if not title_deeds:
            return

        self.sql_statements.append(f"-- Insert {len(title_deeds)} title deed records")

        for record in title_deeds:
            self.sql_statements.append(
                self._create_insert_statement('building_title_deeds', record, use_upsert=False)
            )

        self.sql_statements.append("")

    def _create_insert_statement(self, table: str, data: Dict, use_upsert: bool = True) -> str:
        """
        Create an INSERT or UPSERT statement with schema validation

        Args:
            table: Table name
            data: Dictionary of column: value pairs
            use_upsert: If True, generate UPSERT (INSERT ... ON CONFLICT DO UPDATE)

        Returns:
            SQL INSERT/UPSERT statement
        """
        # Validate data against schema
        validated_data = self.schema_mapper.validate_data(table, data)

        # DEBUG: Print for compliance_assets
        if table == 'compliance_assets':
            print(f"DEBUG compliance_assets:")
            print(f"  Original data: {data}")
            print(f"  Validated data: {validated_data}")

        # Define required NOT NULL columns per table
        required_columns = {
            'buildings': ['id', 'name'],
            'units': ['id', 'building_id', 'unit_number'],
            'leaseholders': ['id', 'building_id', 'first_name', 'last_name'],
            'building_documents': ['id', 'building_id', 'category', 'file_name', 'storage_path'],
            'compliance_assets': ['id', 'building_id', 'asset_name', 'asset_type'],
            'budgets': ['id', 'building_id', 'period'],
            'major_works_projects': ['id', 'building_id', 'project_name']
        }

        # Filter out None values, but keep required columns even if None (will error early)
        table_required = required_columns.get(table, [])
        filtered_data = {
            k: v for k, v in validated_data.items()
            if v is not None or k in table_required
        }

        if table == 'compliance_assets':
            print(f"  Filtered data: {filtered_data}")
            print()

        if not filtered_data:
            return f"-- Skipped empty insert for {table}"

        columns = ', '.join(filtered_data.keys())
        values = ', '.join(self._format_value(v) for v in filtered_data.values())

        # Basic INSERT statement
        insert_sql = f"INSERT INTO {table} ({columns}) VALUES ({values})"

        # Add UPSERT clause if requested and we have a unique constraint
        if use_upsert and table == 'building_documents':
            # For documents, use id for idempotency (content_hash not yet in schema)
            update_cols = [k for k in filtered_data.keys() if k not in ['id', 'created_at']]
            if update_cols:
                updates = ', '.join(f"{col} = EXCLUDED.{col}" for col in update_cols)
                insert_sql += f"\nON CONFLICT (id) DO UPDATE SET {updates}"
            else:
                insert_sql += "\nON CONFLICT (id) DO NOTHING"

        elif use_upsert and table == 'buildings':
            # For buildings, update on ID conflict (re-running onboarding)
            update_cols = [k for k in filtered_data.keys() if k not in ['id', 'created_at', 'agency_id']]
            if update_cols:
                updates = ', '.join(f"{col} = EXCLUDED.{col}" for col in update_cols)
                insert_sql += f"\nON CONFLICT (id) DO UPDATE SET {updates}"
            else:
                insert_sql += "\nON CONFLICT (id) DO NOTHING"

        elif use_upsert and table == 'units':
            # For units, update on building_id + unit_number
            # Requires: CREATE UNIQUE INDEX ON units(building_id, unit_number);
            update_cols = [k for k in filtered_data.keys() if k not in ['id', 'building_id', 'unit_number', 'created_at']]
            if update_cols:
                updates = ', '.join(f"{col} = EXCLUDED.{col}" for col in update_cols)
                insert_sql += f"\nON CONFLICT (building_id, unit_number) DO UPDATE SET {updates}"
            else:
                insert_sql += "\nON CONFLICT (building_id, unit_number) DO NOTHING"

        elif use_upsert and table == 'compliance_assets':
            # For compliance assets, update on building_id + compliance_asset_id
            update_cols = [k for k in filtered_data.keys() if k not in ['id', 'building_id', 'created_at']]
            if update_cols:
                # Update next_due_date to earliest date
                updates = ', '.join(f"{col} = EXCLUDED.{col}" for col in update_cols if col != 'next_due_date')
                if 'next_due_date' in update_cols:
                    updates += ", next_due_date = LEAST(COALESCE(compliance_assets.next_due_date, '9999-12-31'), COALESCE(EXCLUDED.next_due_date, '9999-12-31'))"
                insert_sql += f"\nON CONFLICT (id) DO UPDATE SET {updates}"
            else:
                insert_sql += "\nON CONFLICT (id) DO NOTHING"

        insert_sql += ";"
        return insert_sql

    def _generate_contractors_inserts(self, contractors: List[Dict]):
        """Generate INSERT statements for contractors table"""
        if not contractors:
            return

        self.sql_statements.append(f"-- Insert {len(contractors)} contractors")
        for contractor in contractors:
            self.sql_statements.append(
                self._create_insert_statement('contractors', contractor, use_upsert=False)
            )
        self.sql_statements.append("")

    def _generate_contracts_inserts(self, contracts: List[Dict]):
        """Generate INSERT statements for contracts table"""
        if not contracts:
            return

        self.sql_statements.append(f"-- Insert {len(contracts)} contracts")
        for contract in contracts:
            self.sql_statements.append(
                self._create_insert_statement('contracts', contract, use_upsert=False)
            )
        self.sql_statements.append("")

    def _generate_building_contractor_links_inserts(self, links: List[Dict]):
        """Generate INSERT statements for building_contractors junction table"""
        if not links:
            return

        self.sql_statements.append(f"-- Insert {len(links)} building-contractor links")
        for link in links:
            self.sql_statements.append(
                self._create_insert_statement('building_contractors', link, use_upsert=False)
            )
        self.sql_statements.append("")

    def _generate_assets_inserts(self, assets: List[Dict]):
        """Generate INSERT statements for assets table"""
        if not assets:
            return

        self.sql_statements.append(f"-- Insert {len(assets)} assets")
        for asset in assets:
            self.sql_statements.append(
                self._create_insert_statement('assets', asset, use_upsert=False)
            )
        self.sql_statements.append("")

    def _generate_maintenance_schedules_inserts(self, schedules: List[Dict]):
        """Generate INSERT statements for maintenance_schedules table"""
        if not schedules:
            return

        self.sql_statements.append(f"-- Insert {len(schedules)} maintenance schedules")
        for schedule in schedules:
            self.sql_statements.append(
                self._create_insert_statement('maintenance_schedules', schedule, use_upsert=False)
            )
        self.sql_statements.append("")

    def _generate_fire_door_inspections_inserts(self, inspections: List[Dict]):
        """Generate INSERT statements for fire_door_inspections table"""
        if not inspections:
            return

        self.sql_statements.append(f"-- Insert {len(inspections)} fire door inspections")
        for inspection in inspections:
            self.sql_statements.append(
                self._create_insert_statement('fire_door_inspections', inspection, use_upsert=False)
            )
        self.sql_statements.append("")

    def _generate_timeline_events_inserts(self, events: List[Dict]):
        """Generate INSERT statements for timeline_events table (error logging)"""
        if not events:
            return

        self.sql_statements.append(f"-- Insert {len(events)} timeline events (import logs)")
        for event in events:
            self.sql_statements.append(
                self._create_insert_statement('timeline_events', event, use_upsert=False)
            )
        self.sql_statements.append("")

    def _generate_leases_inserts(self, leases: List[Dict]):
        """Generate INSERT statements for leases table"""
        if not leases:
            return

        self.sql_statements.append(f"-- Insert {len(leases)} lease records")
        for lease in leases:
            self.sql_statements.append(
                self._create_insert_statement('leases', lease, use_upsert=False)
            )
        self.sql_statements.append("")

    def _format_value(self, value: Any) -> str:
        """Format a value for SQL with proper type handling"""
        if value is None:
            return 'NULL'

        if isinstance(value, bool):
            return 'TRUE' if value else 'FALSE'

        if isinstance(value, (int, float)):
            return str(value)

        if isinstance(value, str):
            # Handle UUID strings - don't quote them
            if self._is_uuid_string(value):
                return f"'{value}'"

            # Handle timestamps - ensure proper format
            if self._is_timestamp_string(value):
                return f"'{value}'"

            # Escape single quotes for regular strings
            escaped = value.replace("'", "''")
            return f"'{escaped}'"

        # Handle lists (PostgreSQL arrays)
        if isinstance(value, list):
            # Format as PostgreSQL array
            formatted_items = [self._format_value(item) for item in value]
            return f"ARRAY[{', '.join(formatted_items)}]"

        # JSON for complex types
        return f"'{json.dumps(value)}'"
    
    def _is_uuid_string(self, value: str) -> bool:
        """Check if string is a valid UUID format"""
        import re
        uuid_pattern = r'^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$'
        return bool(re.match(uuid_pattern, value, re.IGNORECASE))
    
    def _is_timestamp_string(self, value: str) -> bool:
        """Check if string is a timestamp format"""
        import re
        timestamp_pattern = r'^\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}'
        return bool(re.match(timestamp_pattern, value))

    def _now(self) -> str:
        """Get current timestamp"""
        from datetime import datetime
        return datetime.now().isoformat()


def generate_document_log_csv(documents: List[Dict]) -> str:
    """
    Generate CSV log of all documents

    Args:
        documents: List of document metadata dictionaries

    Returns:
        CSV string
    """
    if not documents:
        return "file_name,category,confidence,file_size,file_path,notes\n"

    # CSV header
    csv_lines = ["file_name,category,confidence,file_size,file_path,notes"]

    # CSV rows
    for doc in documents:
        row = [
            _csv_escape(doc.get('file_name', '')),
            _csv_escape(doc.get('category', '')),
            str(doc.get('confidence', 0.0)),
            str(doc.get('file_size', 0)),
            _csv_escape(doc.get('file_path', '')),
            _csv_escape(doc.get('notes', ''))
        ]
        csv_lines.append(','.join(row))

    return '\n'.join(csv_lines)


def _csv_escape(value: str) -> str:
    """Escape value for CSV"""
    if not value:
        return ''

    # Quote if contains comma, quote, or newline
    if ',' in value or '"' in value or '\n' in value:
        return f'"{value.replace(chr(34), chr(34)+chr(34))}"'

    return value
