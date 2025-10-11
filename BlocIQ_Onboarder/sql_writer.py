"""
BlocIQ Onboarder - SQL Writer
Generates Supabase-ready SQL migration scripts with exact schema compliance
"""

from typing import Dict, List, Any
import json
from schema_mapper import SupabaseSchemaMapper
from schema_validator import SchemaValidator


class SQLWriter:
    """Generates SQL INSERT statements for Supabase with exact schema compliance"""

    def __init__(self):
        self.sql_statements = []
        self.schema_mapper = SupabaseSchemaMapper()
        self.schema_validator = SchemaValidator()
        self.agency_id = '11111111-1111-1111-1111-111111111111'  # BlocIQ agency ID

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
        # Use fixed agency ID for BlocIQ
        # self.agency_id is set in __init__

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

        # New tables: contractors, contractor_contracts, building_contractors, assets, maintenance_schedules
        if 'contractors' in mapped_data:
            self._generate_contractors_inserts(mapped_data['contractors'])

        if 'contractor_contracts' in mapped_data:
            self._generate_contractor_contracts_inserts(mapped_data['contractor_contracts'])

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

        # Comprehensive Lease Extraction (28 Index Points)
        if 'document_texts' in mapped_data:
            self._generate_document_texts_inserts(mapped_data['document_texts'])

        if 'lease_parties' in mapped_data:
            self._generate_lease_parties_inserts(mapped_data['lease_parties'])

        if 'lease_demise' in mapped_data:
            self._generate_lease_demise_inserts(mapped_data['lease_demise'])

        if 'lease_financial_terms' in mapped_data:
            self._generate_lease_financial_terms_inserts(mapped_data['lease_financial_terms'])

        if 'lease_insurance_terms' in mapped_data:
            self._generate_lease_insurance_terms_inserts(mapped_data['lease_insurance_terms'])

        if 'lease_covenants' in mapped_data:
            self._generate_lease_covenants_inserts(mapped_data['lease_covenants'])

        if 'lease_restrictions' in mapped_data:
            self._generate_lease_restrictions_inserts(mapped_data['lease_restrictions'])

        if 'lease_rights' in mapped_data:
            self._generate_lease_rights_inserts(mapped_data['lease_rights'])

        if 'lease_enforcement' in mapped_data:
            self._generate_lease_enforcement_inserts(mapped_data['lease_enforcement'])

        if 'lease_clauses' in mapped_data:
            self._generate_lease_clauses_inserts(mapped_data['lease_clauses'])

        if 'building_safety_reports' in mapped_data:
            self._generate_building_safety_reports_inserts(mapped_data['building_safety_reports'])

        # Add health check views for PDF report generation
        self._add_health_check_views()

        # Footer
        self._add_footer()

        return '\n'.join(self.sql_statements)

    def _add_header(self):
        """Add migration header with agency placeholder block and schema migrations"""
        self.sql_statements.extend([
            "-- ============================================================",
            "-- PATCHED: BlocIQ Onboarder - Auto-generated Migration (Schema-Corrected)",
            f"-- Generated at: {self._now()}",
            "-- ============================================================",
            "",
            "-- =====================================",
            "-- REQUIRED: Replace AGENCY_ID_PLACEHOLDER with your agency UUID",
            "-- =====================================",
            "",
            "-- =====================================",
            "-- EXTENSION: Ensure UUID generation",
            "-- =====================================",
            "CREATE EXTENSION IF NOT EXISTS pgcrypto;",
            "",
            "-- =====================================",
            "-- SCHEMA MIGRATIONS: Add missing columns if they don't exist",
            "-- =====================================",
            "",
            "-- Remove deprecated role column from building_staff (if exists)",
            "ALTER TABLE building_staff DROP COLUMN IF EXISTS role;",
            "",
            "-- Add building_id to leaseholders (if not exists)",
            "ALTER TABLE leaseholders ADD COLUMN IF NOT EXISTS building_id uuid;",
            "",
            "-- Add unit_number to leaseholders (if not exists)",
            "ALTER TABLE leaseholders ADD COLUMN IF NOT EXISTS unit_number VARCHAR(50);",
            "",
            "-- Add year_start and year_end to budgets (if not exists) - ensure before index",
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
            "-- Budgets (leave existing and rely on ALTERs above)",
            "CREATE TABLE IF NOT EXISTS budgets (",
            "  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),",
            "  building_id uuid REFERENCES buildings(id),",
            "  document_id uuid,",
            "  period text NOT NULL,",
            "  start_date date,",
            "  end_date date,",
            "  year_start date,",
            "  year_end date,",
            "  total_amount numeric,",
            "  demand_date_1 date,",
            "  demand_date_2 date,",
            "  year_end_date date,",
            "  budget_type text,",
            "  agency_id uuid,",
            "  schedule_id uuid,",
            "  year integer,",
            "  name text,",
            "  confidence_score numeric DEFAULT 1.00,",
            "  created_at timestamptz DEFAULT now()",
            ");",
            "",
            "-- Safe now to index year_start",
            "CREATE INDEX IF NOT EXISTS idx_budgets_building ON budgets(building_id);",
            "CREATE INDEX IF NOT EXISTS idx_budgets_year ON budgets(year_start);",
            "",
            "-- Building Insurance",
            "CREATE TABLE IF NOT EXISTS building_insurance (",
            "  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),",
            "  building_id uuid NOT NULL REFERENCES buildings(id),",
            "  insurance_type text NOT NULL,",
            "  broker_name text,",
            "  insurer_name text,",
            "  policy_number text,",
            "  renewal_date date,",
            "  coverage_amount numeric,",
            "  premium_amount numeric,",
            "  document_id uuid,",
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
            "  building_id uuid NOT NULL REFERENCES buildings(id),",
            "  staff_type text,",
            "  description text,",
            "  employee_name text,",
            "  position text,",
            "  start_date date,",
            "  end_date date,",
            "  document_id uuid,",
            "  notes text,",
            "  created_at timestamptz DEFAULT now()",
            ");",
            "",
            "CREATE INDEX IF NOT EXISTS idx_building_staff_building ON building_staff(building_id);",
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
            "-- CONTRACTOR_CONTRACTS: Ensure service_category allows 'unspecified'",
            "-- =====================================",
            "DO $$",
            "BEGIN",
            "  -- Drop existing CHECK constraint if present",
            "  IF EXISTS (",
            "    SELECT 1 FROM pg_constraint",
            "    WHERE conname = 'contractor_contracts_service_category_check'",
            "  ) THEN",
            "    ALTER TABLE contractor_contracts DROP CONSTRAINT contractor_contracts_service_category_check;",
            "  END IF;",
            "",
            "  -- Add CHECK constraint allowing 'unspecified' sentinel",
            "  ALTER TABLE contractor_contracts",
            "    ADD CONSTRAINT contractor_contracts_service_category_check",
            "    CHECK (service_category IN ('lifts','security','fire_alarm','cleaning','maintenance','insurance','legal','utilities','grounds','waste','other','unspecified'));",
            "EXCEPTION WHEN undefined_table THEN",
            "  -- Table doesn't exist yet, will be created with constraint later",
            "  NULL;",
            "END $$;",
            "",
            "-- =====================================",
            "-- DATA MIGRATION: Insert building data",
            "-- =====================================",
            "",
            "-- Using BlocIQ agency ID: 11111111-1111-1111-1111-111111111111",
            "-- Agency already exists in Supabase, no INSERT needed",
            "",
            "BEGIN;",
            ""
        ])

    def _add_health_check_views(self):
        """Add database views for health check report generation"""
        views_sql = """
-- ============================================================
-- BlocIQ Health Check Database Views
-- Creates computed views for health score calculation
-- ============================================================

-- =====================================
-- VIEW: v_compliance_rollup
-- Aggregates compliance asset status by building
-- =====================================
CREATE OR REPLACE VIEW v_compliance_rollup AS
SELECT
    building_id,
    COUNT(*) as total_assets,
    COUNT(*) FILTER (WHERE compliance_status = 'compliant') as ok_count,
    COUNT(*) FILTER (WHERE compliance_status = 'overdue') as overdue_count,
    COUNT(*) FILTER (WHERE compliance_status = 'unknown' OR compliance_status IS NULL) as unknown_count,
    ROUND(
        (COUNT(*) FILTER (WHERE compliance_status = 'compliant')::numeric / NULLIF(COUNT(*), 0)) * 100,
        1
    ) as ok_pct
FROM compliance_assets
WHERE is_active = TRUE
GROUP BY building_id;

-- =====================================
-- VIEW: v_lease_coverage
-- Calculates lease coverage by building
-- =====================================
CREATE OR REPLACE VIEW v_lease_coverage AS
SELECT
    u.building_id,
    COUNT(DISTINCT u.id) as total_units,
    COUNT(DISTINCT l.unit_id) as leased_units,
    ROUND(
        (COUNT(DISTINCT l.unit_id)::numeric / NULLIF(COUNT(DISTINCT u.id), 0)) * 100,
        1
    ) as lease_pct
FROM units u
LEFT JOIN leases l ON u.id = l.unit_id
GROUP BY u.building_id;

-- =====================================
-- VIEW: v_building_health_score
-- Calculates overall health score with weighted components
-- Compliance: 40% | Insurance: 20% | Budget: 20% | Lease: 10% | Contractor: 10%
-- =====================================
CREATE OR REPLACE VIEW v_building_health_score AS
WITH compliance_scores AS (
    SELECT
        building_id,
        CASE
            WHEN total_assets = 0 THEN 0
            WHEN ok_pct >= 90 THEN 100
            WHEN ok_pct >= 75 THEN 80
            WHEN ok_pct >= 50 THEN 60
            WHEN ok_pct >= 25 THEN 40
            ELSE 20
        END as compliance_score
    FROM v_compliance_rollup
),
insurance_scores AS (
    SELECT
        building_id,
        CASE
            WHEN COUNT(*) = 0 THEN 0
            WHEN COUNT(*) FILTER (WHERE expiry_date > CURRENT_DATE) = COUNT(*) THEN 100
            WHEN COUNT(*) FILTER (WHERE expiry_date > CURRENT_DATE) >= COUNT(*) * 0.5 THEN 50
            ELSE 25
        END as insurance_score
    FROM building_insurance
    GROUP BY building_id
),
budget_scores AS (
    SELECT
        building_id,
        CASE
            WHEN COUNT(*) = 0 THEN 0
            WHEN COUNT(*) FILTER (WHERE year_start IS NOT NULL AND year_end IS NOT NULL) = COUNT(*) THEN 100
            WHEN COUNT(*) FILTER (WHERE year_start IS NOT NULL OR year_end IS NOT NULL) >= COUNT(*) * 0.5 THEN 60
            ELSE 30
        END as budget_score
    FROM budgets
    GROUP BY building_id
),
lease_scores AS (
    SELECT
        building_id,
        CASE
            WHEN lease_pct >= 90 THEN 100
            WHEN lease_pct >= 75 THEN 80
            WHEN lease_pct >= 50 THEN 60
            WHEN lease_pct >= 25 THEN 40
            ELSE 20
        END as lease_score
    FROM v_lease_coverage
),
contractor_scores AS (
    SELECT
        building_id,
        CASE
            WHEN COUNT(*) = 0 THEN 0
            WHEN COUNT(*) FILTER (WHERE retender_status = 'not_scheduled' OR retender_status IS NULL) = COUNT(*) THEN 100
            WHEN COUNT(*) FILTER (WHERE retender_status = 'due') >= COUNT(*) * 0.5 THEN 50
            ELSE 75
        END as contractor_score
    FROM building_contractors
    GROUP BY building_id
)
SELECT
    b.id as building_id,
    b.name as building_name,
    COALESCE(cs.compliance_score, 0) as compliance_score,
    COALESCE(ins.insurance_score, 0) as insurance_score,
    COALESCE(bud.budget_score, 0) as budget_score,
    COALESCE(ls.lease_score, 0) as lease_score,
    COALESCE(cont.contractor_score, 0) as contractor_score,
    -- Weighted overall score
    ROUND(
        (COALESCE(cs.compliance_score, 0) * 0.40) +
        (COALESCE(ins.insurance_score, 0) * 0.20) +
        (COALESCE(bud.budget_score, 0) * 0.20) +
        (COALESCE(ls.lease_score, 0) * 0.10) +
        (COALESCE(cont.contractor_score, 0) * 0.10),
        1
    ) as health_score,
    -- Rating based on overall score
    CASE
        WHEN ROUND(
            (COALESCE(cs.compliance_score, 0) * 0.40) +
            (COALESCE(ins.insurance_score, 0) * 0.20) +
            (COALESCE(bud.budget_score, 0) * 0.20) +
            (COALESCE(ls.lease_score, 0) * 0.10) +
            (COALESCE(cont.contractor_score, 0) * 0.10),
            1
        ) >= 90 THEN 'Excellent'
        WHEN ROUND(
            (COALESCE(cs.compliance_score, 0) * 0.40) +
            (COALESCE(ins.insurance_score, 0) * 0.20) +
            (COALESCE(bud.budget_score, 0) * 0.20) +
            (COALESCE(ls.lease_score, 0) * 0.10) +
            (COALESCE(cont.contractor_score, 0) * 0.10),
            1
        ) >= 75 THEN 'Good'
        WHEN ROUND(
            (COALESCE(cs.compliance_score, 0) * 0.40) +
            (COALESCE(ins.insurance_score, 0) * 0.20) +
            (COALESCE(bud.budget_score, 0) * 0.20) +
            (COALESCE(ls.lease_score, 0) * 0.10) +
            (COALESCE(cont.contractor_score, 0) * 0.10),
            1
        ) >= 50 THEN 'Fair'
        WHEN ROUND(
            (COALESCE(cs.compliance_score, 0) * 0.40) +
            (COALESCE(ins.insurance_score, 0) * 0.20) +
            (COALESCE(bud.budget_score, 0) * 0.20) +
            (COALESCE(ls.lease_score, 0) * 0.10) +
            (COALESCE(cont.contractor_score, 0) * 0.10),
            1
        ) >= 25 THEN 'Poor'
        ELSE 'Critical'
    END as rating
FROM buildings b
LEFT JOIN compliance_scores cs ON b.id = cs.building_id
LEFT JOIN insurance_scores ins ON b.id = ins.building_id
LEFT JOIN budget_scores bud ON b.id = bud.building_id
LEFT JOIN lease_scores ls ON b.id = ls.building_id
LEFT JOIN contractor_scores cont ON b.id = cont.building_id;

-- =====================================
-- Indexes for Performance (with defensive column checks)
-- =====================================
DO $$
BEGIN
    -- Index on compliance_assets (compliance_status, is_active)
    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name='compliance_assets' AND column_name='compliance_status')
       AND EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name='compliance_assets' AND column_name='is_active') THEN
        CREATE INDEX IF NOT EXISTS idx_compliance_assets_status_building ON compliance_assets(building_id, compliance_status) WHERE is_active = TRUE;
    END IF;

    -- Index on leases (unit_id)
    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name='leases' AND column_name='unit_id') THEN
        CREATE INDEX IF NOT EXISTS idx_leases_unit ON leases(unit_id);
    END IF;

    -- Index on building_insurance (expiry_date)
    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name='building_insurance' AND column_name='expiry_date') THEN
        CREATE INDEX IF NOT EXISTS idx_insurance_expiry ON building_insurance(building_id, expiry_date);
    END IF;

    -- Index on budgets (year_start, year_end)
    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name='budgets' AND column_name='year_start')
       AND EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name='budgets' AND column_name='year_end') THEN
        CREATE INDEX IF NOT EXISTS idx_budgets_dates ON budgets(building_id, year_start, year_end);
    END IF;

    -- Index on building_contractors (retender_status)
    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name='building_contractors' AND column_name='retender_status') THEN
        CREATE INDEX IF NOT EXISTS idx_contractors_retender ON building_contractors(building_id, retender_status);
    END IF;
END $$;
"""
        self.sql_statements.append(views_sql)

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
        """Generate INSERT for buildings table with agency_id"""
        # Add agency_id to building data
        building_with_agency = building.copy()
        building_with_agency['agency_id'] = self.agency_id

        self.sql_statements.append("-- Insert building")
        self.sql_statements.append(
            self._create_insert_statement('buildings', building_with_agency, use_upsert=False)
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
        """Generate bulk INSERT for units table"""
        if not units:
            return

        self.sql_statements.append(f"-- Insert {len(units)} units")

        # Use bulk multi-row VALUES syntax for efficiency
        if len(units) <= 10:  # Use bulk insert for reasonable sizes
            values_rows = []
            for unit in units:
                validated = self.schema_mapper.validate_data('units', unit)
                id_val = self._format_value(validated.get('id'))
                building_id_val = self._format_value(validated.get('building_id'))
                unit_number_val = self._format_value(validated.get('unit_number'))
                values_rows.append(f"({id_val}, {building_id_val}, {unit_number_val})")

            bulk_insert = "INSERT INTO units (id, building_id, unit_number) VALUES\n" + ",\n".join(values_rows)
            bulk_insert += "\nON CONFLICT (id) DO NOTHING;"
            self.sql_statements.append(bulk_insert)
        else:
            # Fall back to individual inserts for very large sets
            for unit in units:
                self.sql_statements.append(
                    self._create_insert_statement('units', unit, use_upsert=False)
                )

        self.sql_statements.append("")

    def _generate_leaseholders_inserts(self, leaseholders: List[Dict]):
        """Generate bulk INSERT for leaseholders table"""
        if not leaseholders:
            return

        self.sql_statements.append(f"-- Insert {len(leaseholders)} leaseholders (schema has building_id and unit_number)")

        # Use bulk multi-row VALUES syntax
        if len(leaseholders) <= 20:  # Reasonable bulk size
            values_rows = []
            for lh in leaseholders:
                validated = self.schema_mapper.validate_data('leaseholders', lh)
                id_val = self._format_value(validated.get('id'))
                building_id_val = self._format_value(validated.get('building_id'))
                unit_id_val = self._format_value(validated.get('unit_id'))
                unit_number_val = self._format_value(validated.get('unit_number'))
                name_val = self._format_value(validated.get('name') or validated.get('first_name', '') + ' ' + validated.get('last_name', ''))
                values_rows.append(f"({id_val}, {building_id_val}, {unit_id_val}, {unit_number_val}, {name_val})")

            bulk_insert = "INSERT INTO leaseholders (id, building_id, unit_id, unit_number, name) VALUES\n" + ",\n".join(values_rows)
            bulk_insert += "\nON CONFLICT (id) DO NOTHING;"
            self.sql_statements.append(bulk_insert)
        else:
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
            # Create a copy to avoid mutating original data
            budget_data = budget.copy()

            # CRITICAL: Ensure period field exists (NOT NULL constraint)
            if 'period' not in budget_data or not budget_data['period']:
                # Try to infer period from year fields or dates
                if budget_data.get('year'):
                    budget_data['period'] = str(budget_data['year'])
                elif budget_data.get('year_start'):
                    # Extract year from date string
                    year_str = str(budget_data['year_start'])[:4]
                    budget_data['period'] = year_str
                else:
                    budget_data['period'] = 'Unknown'

            self.sql_statements.append(
                self._create_insert_statement('budgets', budget_data, use_upsert=False)
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
            # Ensure insurance_type field exists (required NOT NULL constraint)
            if 'insurance_type' not in record or not record['insurance_type']:
                record['insurance_type'] = 'general'

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
        # First validate with legacy schema mapper (for compatibility)
        validated_data = self.schema_mapper.validate_data(table, data)

        # Then apply strict schema validation and transformation
        validated_data = self.schema_validator.validate_and_transform(table, validated_data)

        # DEBUG: Print for major_works_projects and compliance_assets
        if table == 'major_works_projects':
            print(f"DEBUG major_works_projects:")
            print(f"  Original data keys: {list(data.keys())}")
            print(f"  Validated data keys: {list(validated_data.keys())}")
            if 'project_name' in data:
                print(f"  Mapped project_name -> name: {data.get('project_name')}")
        if table == 'compliance_assets':
            print(f"DEBUG compliance_assets:")
            print(f"  Original data: {data}")
            print(f"  Validated data: {validated_data}")

        # Define required NOT NULL columns per table
        required_columns = {
            'buildings': ['id', 'name'],
            'units': ['id', 'building_id', 'unit_number'],
            'leaseholders': ['id', 'building_id', 'first_name', 'last_name'],
            'leases': ['id', 'building_id'],
            'building_documents': ['id', 'building_id', 'category', 'file_name', 'storage_path'],
            'compliance_assets': ['id', 'building_id', 'asset_name', 'asset_type'],
            'budgets': ['id', 'building_id', 'period'],
            'building_insurance': ['id', 'building_id', 'insurance_type'],
            'contractors': ['id', 'name'],
            'major_works_projects': ['id', 'building_id', 'project_name'],
            'schedules': ['id', 'building_id', 'name']
        }

        # Filter out None values, but keep required columns even if None (will error early)
        table_required = required_columns.get(table, [])
        filtered_data = {
            k: v for k, v in validated_data.items()
            if v is not None or k in table_required
        }

        # CRITICAL: Ensure NOT NULL columns always have values
        if table == 'budgets':
            # Budget period is NOT NULL - ensure it's always set
            if 'period' not in filtered_data or not filtered_data.get('period'):
                # Try to infer from other fields
                if filtered_data.get('year'):
                    filtered_data['period'] = str(filtered_data['year'])
                elif filtered_data.get('year_start'):
                    year_str = str(filtered_data['year_start'])[:4]
                    filtered_data['period'] = year_str
                else:
                    filtered_data['period'] = 'Unknown'

        if table == 'schedules':
            # Schedule name is NOT NULL - ensure it's always set
            if 'name' not in filtered_data or not filtered_data.get('name'):
                # Try to infer from description or other fields
                if filtered_data.get('description'):
                    # Use first 50 chars of description as name
                    desc = filtered_data['description']
                    filtered_data['name'] = desc[:50] if len(desc) > 50 else desc
                else:
                    filtered_data['name'] = 'Unnamed Schedule'

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
        """Generate INSERT statements for contractors table (use 'name' field)"""
        if not contractors:
            return

        self.sql_statements.append(f"-- ===========================")
        self.sql_statements.append(f"-- CONTRACTORS")
        self.sql_statements.append(f"-- ===========================")
        self.sql_statements.append("")

        for contractor in contractors:
            validated = self.schema_mapper.validate_data('contractors', contractor)

            # Build INSERT with only non-NULL values
            columns = []
            values = []

            if validated.get('id'):
                columns.append('id')
                values.append(self._format_value(validated['id']))

            # IMPORTANT: Use 'name' instead of 'company_name' (NOT NULL constraint)
            if validated.get('name'):
                columns.append('name')
                values.append(self._format_value(validated['name']))
            elif validated.get('company_name'):
                columns.append('name')
                values.append(self._format_value(validated['company_name']))

            if validated.get('email'):
                columns.append('email')
                values.append(self._format_value(validated['email']))

            if validated.get('phone'):
                columns.append('phone')
                values.append(self._format_value(validated['phone']))

            if validated.get('address'):
                columns.append('address')
                values.append(self._format_value(validated['address']))

            if columns and 'name' in columns:  # Only insert if we have name
                cols_str = ', '.join(columns)
                vals_str = ', '.join(values)
                self.sql_statements.append(f"INSERT INTO contractors ({cols_str}) VALUES")
                self.sql_statements.append(f"({vals_str})")
                self.sql_statements.append(f"ON CONFLICT (id) DO NOTHING;")
                self.sql_statements.append("")

        self.sql_statements.append("")

    def _generate_contractor_contracts_inserts(self, contracts: List[Dict]):
        """
        Generate INSERT statements for contractor_contracts table
        Uses SELECT subqueries to lookup contractor_id by name
        Handles NULL service_category by using 'unspecified' default
        """
        if not contracts:
            return

        self.sql_statements.append(f"-- ===========================")
        self.sql_statements.append(f"-- CONTRACTS -> CONTRACTOR_CONTRACTS")
        self.sql_statements.append(f"-- ===========================")
        self.sql_statements.append(f"-- Map:")
        self.sql_statements.append(f"--   contractor_name -> contractor_id (lookup by contractors.name)")
        self.sql_statements.append(f"--   service_type -> service_category")
        self.sql_statements.append(f"--   frequency -> payment_frequency")
        self.sql_statements.append(f"--   contract_status -> is_active (active -> TRUE; expired/others -> FALSE)")
        self.sql_statements.append(f"--   NULL service_category -> 'unspecified'")
        self.sql_statements.append("")

        for contract in contracts:
            # Don't validate contractor_contracts (not in schema yet) - preserve all fields
            # validated = self.schema_mapper.validate_data('contractor_contracts', contract)

            # Skip if no contractor_name (can't lookup contractor_id)
            contractor_name = contract.get('contractor_name')
            if not contractor_name:
                self.sql_statements.append(f"-- Skipped contract {contract.get('id', 'unknown')} - no contractor_name")
                continue

            # Extract fields
            contract_id = contract.get('id')
            building_id = contract.get('building_id')
            service_category = contract.get('service_category') or contract.get('service_type') or 'unspecified'
            payment_frequency = contract.get('payment_frequency') or contract.get('frequency')
            start_date = contract.get('start_date') or contract.get('contract_start')
            end_date = contract.get('end_date') or contract.get('contract_end')

            # CRITICAL: start_date and end_date are NOT NULL in contractor_contracts schema
            # Use current date as default if not provided
            if not start_date:
                start_date = 'CURRENT_DATE'  # Use PostgreSQL function for default

            # CRITICAL: end_date is also NOT NULL - default to 1 year from start_date
            if not end_date:
                if start_date == 'CURRENT_DATE':
                    end_date = "CURRENT_DATE + INTERVAL '1 year'"
                else:
                    # If we have a specific start_date, add 1 year to it
                    end_date = f"DATE '{start_date}' + INTERVAL '1 year'"

            # Map contract_status to is_active
            contract_status = contract.get('contract_status', 'active').lower()
            is_active = 'TRUE' if contract_status == 'active' else 'FALSE'

            # Build INSERT with SELECT subquery
            insert_parts = []
            insert_parts.append("INSERT INTO contractor_contracts (")

            # ALWAYS include start_date and end_date (NOT NULL constraints)
            columns = ['id', 'building_id', 'contractor_id', 'service_category', 'start_date', 'end_date']
            if payment_frequency:
                columns.append('payment_frequency')
            columns.append('is_active')

            insert_parts.append(f"  {', '.join(columns)}")
            insert_parts.append(")")
            insert_parts.append("SELECT")

            # Build SELECT values
            select_values = [
                f"  {self._format_value(contract_id)}",
                f"  {self._format_value(building_id)}",
                f"  c.id",
                f"  {self._format_value(service_category)}",
                f"  {start_date if start_date in ['CURRENT_DATE', 'NULL'] else self._format_value(start_date)}",  # Don't quote PostgreSQL functions
                f"  {end_date if 'CURRENT_DATE' in str(end_date) or 'INTERVAL' in str(end_date) else self._format_value(end_date)}"  # Don't quote date expressions
            ]
            if payment_frequency:
                select_values.append(f"  {self._format_value(payment_frequency)}")
            select_values.append(f"  {is_active}")

            insert_parts.append(",\n".join(select_values))
            insert_parts.append(f"FROM contractors c WHERE c.name = {self._format_value(contractor_name)}")

            # Add ON CONFLICT for idempotency (use id as primary key)
            insert_parts.append("ON CONFLICT (id) DO NOTHING;")

            self.sql_statements.append("\n".join(insert_parts))
            self.sql_statements.append("")

        self.sql_statements.append("")

    def _generate_building_contractor_links_inserts(self, links: List[Dict]):
        """
        Generate INSERT statements for building_contractors table
        Maps to schema: id, building_id, contractor_type, company_name, contact_person,
        phone, email, contract_start, contract_end, document_id, notes, created_at,
        retender_status, retender_due_date, next_review_date, renewal_notice_period
        """
        if not links:
            return

        self.sql_statements.append(f"-- ===========================")
        self.sql_statements.append(f"-- BUILDING_CONTRACTORS")
        self.sql_statements.append(f"-- ===========================")
        self.sql_statements.append("")

        for link in links:
            # Preserve all fields without validation
            # validated = self.schema_mapper.validate_data('building_contractors', link)

            # Build INSERT with non-NULL values
            columns = []
            values = []

            if link.get('id'):
                columns.append('id')
                values.append(self._format_value(link['id']))

            if link.get('building_id'):
                columns.append('building_id')
                values.append(self._format_value(link['building_id']))

            # contractor_type defaults to 'service_provider'
            contractor_type = link.get('contractor_type', 'service_provider')
            columns.append('contractor_type')
            values.append(self._format_value(contractor_type))

            # company_name is required for building_contractors
            company_name = link.get('company_name') or link.get('name')
            if company_name:
                columns.append('company_name')
                values.append(self._format_value(company_name))

            if link.get('email'):
                columns.append('email')
                values.append(self._format_value(link['email']))

            if link.get('phone'):
                columns.append('phone')
                values.append(self._format_value(link['phone']))

            if link.get('notes'):
                columns.append('notes')
                values.append(self._format_value(link['notes']))

            if columns:
                cols_str = ', '.join(columns)
                vals_str = ', '.join(values)
                self.sql_statements.append(f"INSERT INTO building_contractors ({cols_str})")
                self.sql_statements.append(f"VALUES ({vals_str})")
                self.sql_statements.append(f"ON CONFLICT (id) DO NOTHING;")
                self.sql_statements.append("")

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
        """Generate INSERT statements for schedules table (maintenance_schedules mapped to schedules)"""
        if not schedules:
            return

        self.sql_statements.append(f"-- Insert {len(schedules)} maintenance schedules (into schedules table)")
        for schedule in schedules:
            # Map maintenance_schedules to schedules table
            self.sql_statements.append(
                self._create_insert_statement('schedules', schedule, use_upsert=False)
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
            print("  ⚠️  No leases to generate SQL for")
            return

        print(f"  📜 Generating SQL for {len(leases)} leases")
        self.sql_statements.append(f"-- Insert {len(leases)} lease records")
        for lease in leases:
            # Filter out ocr_text - it's used for comprehensive extraction but not stored in leases table
            lease_data = {k: v for k, v in lease.items() if k != 'ocr_text'}
            self.sql_statements.append(
                self._create_insert_statement('leases', lease_data, use_upsert=False)
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

    # =========================================
    # COMPREHENSIVE LEASE EXTRACTION METHODS (28 Index Points)
    # =========================================

    def _generate_document_texts_inserts(self, documents: List[Dict]):
        """Generate INSERT statements for document_texts table (OCR storage)"""
        if not documents:
            return

        self.sql_statements.append(f"-- Insert {len(documents)} document_texts records (OCR storage)")
        for doc in documents:
            self.sql_statements.append(
                self._create_insert_statement('document_texts', doc, use_upsert=False)
            )
        self.sql_statements.append("")

    def _generate_lease_parties_inserts(self, parties: List[Dict]):
        """Generate INSERT statements for lease_parties table (Index Point 3)"""
        if not parties:
            return

        self.sql_statements.append(f"-- Insert {len(parties)} lease_parties records (Lessor, Lessee, Management Co.)")
        for party in parties:
            self.sql_statements.append(
                self._create_insert_statement('lease_parties', party, use_upsert=False)
            )
        self.sql_statements.append("")

    def _generate_lease_demise_inserts(self, demise_records: List[Dict]):
        """Generate INSERT statements for lease_demise table (Index Point 5)"""
        if not demise_records:
            return

        self.sql_statements.append(f"-- Insert {len(demise_records)} lease_demise records (Demise Definition)")
        for demise in demise_records:
            self.sql_statements.append(
                self._create_insert_statement('lease_demise', demise, use_upsert=False)
            )
        self.sql_statements.append("")

    def _generate_lease_financial_terms_inserts(self, financial_terms: List[Dict]):
        """Generate INSERT statements for lease_financial_terms table (Index Points 12-14, 21-24)"""
        if not financial_terms:
            return

        self.sql_statements.append(f"-- Insert {len(financial_terms)} lease_financial_terms records")
        for terms in financial_terms:
            self.sql_statements.append(
                self._create_insert_statement('lease_financial_terms', terms, use_upsert=False)
            )
        self.sql_statements.append("")

    def _generate_lease_insurance_terms_inserts(self, insurance_terms: List[Dict]):
        """Generate INSERT statements for lease_insurance_terms table (Index Point 14)"""
        if not insurance_terms:
            return

        self.sql_statements.append(f"-- Insert {len(insurance_terms)} lease_insurance_terms records")
        for terms in insurance_terms:
            self.sql_statements.append(
                self._create_insert_statement('lease_insurance_terms', terms, use_upsert=False)
            )
        self.sql_statements.append("")

    def _generate_lease_covenants_inserts(self, covenants: List[Dict]):
        """Generate INSERT statements for lease_covenants table (Index Points 6, 8-11)"""
        if not covenants:
            return

        self.sql_statements.append(f"-- Insert {len(covenants)} lease_covenants records (Repair, Use, etc.)")
        for covenant in covenants:
            self.sql_statements.append(
                self._create_insert_statement('lease_covenants', covenant, use_upsert=False)
            )
        self.sql_statements.append("")

    def _generate_lease_restrictions_inserts(self, restrictions: List[Dict]):
        """Generate INSERT statements for lease_restrictions table (Index Points 9-11, 17-19)"""
        if not restrictions:
            return

        self.sql_statements.append(f"-- Insert {len(restrictions)} lease_restrictions records (Pets, Subletting, RMC, etc.)")
        for restriction in restrictions:
            self.sql_statements.append(
                self._create_insert_statement('lease_restrictions', restriction, use_upsert=False)
            )
        self.sql_statements.append("")

    def _generate_lease_rights_inserts(self, rights: List[Dict]):
        """Generate INSERT statements for lease_rights table (Index Point 20)"""
        if not rights:
            return

        self.sql_statements.append(f"-- Insert {len(rights)} lease_rights records (Access, Easements)")
        for right in rights:
            self.sql_statements.append(
                self._create_insert_statement('lease_rights', right, use_upsert=False)
            )
        self.sql_statements.append("")

    def _generate_lease_enforcement_inserts(self, enforcement: List[Dict]):
        """Generate INSERT statements for lease_enforcement table (Index Points 15-16)"""
        if not enforcement:
            return

        self.sql_statements.append(f"-- Insert {len(enforcement)} lease_enforcement records (Forfeiture, Remedies)")
        for record in enforcement:
            self.sql_statements.append(
                self._create_insert_statement('lease_enforcement', record, use_upsert=False)
            )
        self.sql_statements.append("")

    def _generate_lease_clauses_inserts(self, clauses: List[Dict]):
        """Generate INSERT statements for lease_clauses table (Index Point 25)"""
        if not clauses:
            return

        self.sql_statements.append(f"-- Insert {len(clauses)} lease_clauses records (Clause References for Traceability)")
        for clause in clauses:
            self.sql_statements.append(
                self._create_insert_statement('lease_clauses', clause, use_upsert=False)
            )
        self.sql_statements.append("")

    def _generate_building_safety_reports_inserts(self, reports: List[Dict]):
        """Generate INSERT statements for building_safety_reports table"""
        if not reports:
            return

        self.sql_statements.append(f"-- Insert {len(reports)} building_safety_reports records (FRAs, BSCs)")
        for report in reports:
            self.sql_statements.append(
                self._create_insert_statement('building_safety_reports', report, use_upsert=False)
            )
        self.sql_statements.append("")


def _csv_escape(value: str) -> str:
    """Escape value for CSV"""
    if not value:
        return ''

    # Quote if contains comma, quote, or newline
    if ',' in value or '"' in value or '\n' in value:
        return f'"{value.replace(chr(34), chr(34)+chr(34))}"'

    return value
