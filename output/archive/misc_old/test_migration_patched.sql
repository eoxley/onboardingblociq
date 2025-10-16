-- ============================================================
-- PATCHED: BlocIQ Onboarder - Auto-generated Migration (Schema-Corrected)
-- Generated at: 2025-10-08T22:24:04.041985
-- ============================================================

-- =====================================
-- REQUIRED: Replace AGENCY_ID_PLACEHOLDER with your agency UUID
-- =====================================

-- =====================================
-- EXTENSION: Ensure UUID generation
-- =====================================
CREATE EXTENSION IF NOT EXISTS pgcrypto;

-- =====================================
-- SCHEMA MIGRATIONS: Add missing columns if they don't exist
-- =====================================

-- Remove deprecated role column from building_staff (if exists)
ALTER TABLE building_staff DROP COLUMN IF EXISTS role;

-- Add building_id to leaseholders (if not exists)
ALTER TABLE leaseholders ADD COLUMN IF NOT EXISTS building_id uuid;

-- Add unit_number to leaseholders (if not exists)
ALTER TABLE leaseholders ADD COLUMN IF NOT EXISTS unit_number VARCHAR(50);

-- Add year_start and year_end to budgets (if not exists) - ensure before index
ALTER TABLE budgets ADD COLUMN IF NOT EXISTS year_start DATE;
ALTER TABLE budgets ADD COLUMN IF NOT EXISTS year_end DATE;

-- Add expiry_date to building_insurance (if not exists)
ALTER TABLE building_insurance ADD COLUMN IF NOT EXISTS expiry_date DATE;

-- Add expiry_date to leases (if not exists)
ALTER TABLE leases ADD COLUMN IF NOT EXISTS expiry_date DATE;

-- Add building_id to apportionments (if not exists)
ALTER TABLE apportionments ADD COLUMN IF NOT EXISTS building_id uuid;

-- Add building_id to major_works_notices (if not exists)
ALTER TABLE major_works_notices ADD COLUMN IF NOT EXISTS building_id uuid;

-- Add foreign key constraints (if not exist)
DO $$ BEGIN
  ALTER TABLE leaseholders ADD CONSTRAINT fk_leaseholders_building FOREIGN KEY (building_id) REFERENCES buildings(id);
EXCEPTION WHEN duplicate_object THEN NULL;
END $$;

DO $$ BEGIN
  ALTER TABLE apportionments ADD CONSTRAINT fk_apportionments_building FOREIGN KEY (building_id) REFERENCES buildings(id);
EXCEPTION WHEN duplicate_object THEN NULL;
END $$;

DO $$ BEGIN
  ALTER TABLE major_works_notices ADD CONSTRAINT fk_major_works_notices_building FOREIGN KEY (building_id) REFERENCES buildings(id);
EXCEPTION WHEN duplicate_object THEN NULL;
END $$;

-- Create indexes for performance (if not exist)
CREATE INDEX IF NOT EXISTS idx_leaseholders_building_id ON leaseholders(building_id);
CREATE INDEX IF NOT EXISTS idx_apportionments_building_id ON apportionments(building_id);
CREATE INDEX IF NOT EXISTS idx_major_works_notices_building_id ON major_works_notices(building_id);

-- Add compliance tracking columns to compliance_assets
ALTER TABLE compliance_assets ADD COLUMN IF NOT EXISTS last_inspection_date DATE, ADD COLUMN IF NOT EXISTS next_due_date DATE, ADD COLUMN IF NOT EXISTS compliance_status VARCHAR(50) DEFAULT 'unknown', ADD COLUMN IF NOT EXISTS location VARCHAR(255), ADD COLUMN IF NOT EXISTS responsible_party VARCHAR(255), ADD COLUMN IF NOT EXISTS notes TEXT;

-- Create index on compliance status for quick filtering
CREATE INDEX IF NOT EXISTS idx_compliance_assets_status ON compliance_assets(compliance_status);
CREATE INDEX IF NOT EXISTS idx_compliance_assets_next_due ON compliance_assets(next_due_date);

-- Add contract lifecycle tracking columns to building_contractors
ALTER TABLE building_contractors ADD COLUMN IF NOT EXISTS retender_status text DEFAULT 'not_scheduled', ADD COLUMN IF NOT EXISTS retender_due_date date, ADD COLUMN IF NOT EXISTS next_review_date date, ADD COLUMN IF NOT EXISTS renewal_notice_period interval DEFAULT interval '90 days';

-- Create index on contract lifecycle for quick filtering
CREATE INDEX IF NOT EXISTS idx_building_contractors_retender_due ON building_contractors(retender_due_date);
CREATE INDEX IF NOT EXISTS idx_building_contractors_retender_status ON building_contractors(retender_status);

-- =====================================
-- FINANCIAL & COMPLIANCE INTELLIGENCE TABLES
-- =====================================

-- Fire Door Inspections
CREATE TABLE IF NOT EXISTS fire_door_inspections (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  building_id uuid REFERENCES buildings(id),
  unit_id uuid REFERENCES units(id),
  location text,
  inspection_date date,
  status text CHECK (status IN ('compliant','non-compliant','overdue','unknown')),
  notes text,
  document_path text,
  created_at timestamptz DEFAULT now()
);

CREATE INDEX IF NOT EXISTS idx_fire_door_inspections_building ON fire_door_inspections(building_id);
CREATE INDEX IF NOT EXISTS idx_fire_door_inspections_status ON fire_door_inspections(status);

-- Budgets (leave existing and rely on ALTERs above)
CREATE TABLE IF NOT EXISTS budgets (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  building_id uuid REFERENCES buildings(id),
  document_id uuid,
  period text NOT NULL,
  start_date date,
  end_date date,
  total_amount numeric,
  demand_date_1 date,
  demand_date_2 date,
  year_end_date date,
  budget_type text,
  agency_id uuid,
  schedule_id uuid,
  year integer,
  name text,
  confidence_score numeric DEFAULT 1.00,
  created_at timestamptz DEFAULT now()
);

-- Safe now to index year_start
CREATE INDEX IF NOT EXISTS idx_budgets_building ON budgets(building_id);
CREATE INDEX IF NOT EXISTS idx_budgets_year ON budgets(year_start);

-- Building Insurance
CREATE TABLE IF NOT EXISTS building_insurance (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  building_id uuid NOT NULL REFERENCES buildings(id),
  insurance_type text NOT NULL,
  broker_name text,
  insurer_name text,
  policy_number text,
  renewal_date date,
  coverage_amount numeric,
  premium_amount numeric,
  document_id uuid,
  notes text,
  created_at timestamptz DEFAULT now()
);

CREATE INDEX IF NOT EXISTS idx_building_insurance_building ON building_insurance(building_id);
CREATE INDEX IF NOT EXISTS idx_building_insurance_expiry ON building_insurance(expiry_date);

-- Building Staff
CREATE TABLE IF NOT EXISTS building_staff (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  building_id uuid NOT NULL REFERENCES buildings(id),
  staff_type text,
  description text,
  employee_name text,
  position text,
  start_date date,
  end_date date,
  document_id uuid,
  notes text,
  created_at timestamptz DEFAULT now()
);

CREATE INDEX IF NOT EXISTS idx_building_staff_building ON building_staff(building_id);

-- Timeline Events (for error logging and audit trail)
CREATE TABLE IF NOT EXISTS timeline_events (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  building_id uuid REFERENCES buildings(id),
  event_type text NOT NULL,
  event_date timestamptz DEFAULT now(),
  description text,
  metadata jsonb,
  severity text CHECK (severity IN ('info','warning','error')) DEFAULT 'info',
  created_at timestamptz DEFAULT now()
);

CREATE INDEX IF NOT EXISTS idx_timeline_events_building ON timeline_events(building_id);
CREATE INDEX IF NOT EXISTS idx_timeline_events_type ON timeline_events(event_type);
CREATE INDEX IF NOT EXISTS idx_timeline_events_date ON timeline_events(event_date);

-- Leases
CREATE TABLE IF NOT EXISTS leases (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  building_id uuid REFERENCES buildings(id),
  unit_id uuid REFERENCES units(id),
  term_start date,
  term_years integer,
  expiry_date date,
  ground_rent numeric(10,2),
  rent_review_period integer,
  leaseholder_name text,
  lessor_name text,
  source_document text,
  notes text,
  created_at timestamptz DEFAULT now()
);

CREATE INDEX IF NOT EXISTS idx_leases_building ON leases(building_id);
CREATE INDEX IF NOT EXISTS idx_leases_unit ON leases(unit_id);
CREATE INDEX IF NOT EXISTS idx_leases_expiry ON leases(expiry_date);

-- =====================================
-- CONTRACTOR_CONTRACTS: Ensure service_category allows 'unspecified'
-- =====================================
DO $$
BEGIN
  -- Drop existing CHECK constraint if present
  IF EXISTS (
    SELECT 1 FROM pg_constraint
    WHERE conname = 'contractor_contracts_service_category_check'
  ) THEN
    ALTER TABLE contractor_contracts DROP CONSTRAINT contractor_contracts_service_category_check;
  END IF;

  -- Add CHECK constraint allowing 'unspecified' sentinel
  ALTER TABLE contractor_contracts
    ADD CONSTRAINT contractor_contracts_service_category_check
    CHECK (service_category IN ('lifts','security','fire_alarm','cleaning','maintenance','insurance','legal','utilities','grounds','waste','other','unspecified'));
EXCEPTION WHEN undefined_table THEN
  -- Table doesn't exist yet, will be created with constraint later
  NULL;
END $$;

-- =====================================
-- DATA MIGRATION: Insert building data
-- =====================================

-- Insert agency (required for portfolios foreign key)
-- NOTE: Replace 'AGENCY_ID_PLACEHOLDER' with your actual agency UUID
-- and 'Your Agency Name' with your agency name
INSERT INTO agencies (id, name)
VALUES ('AGENCY_ID_PLACEHOLDER', 'Your Agency Name')
ON CONFLICT (id) DO NOTHING;

-- Insert portfolio (linked to agency above)
INSERT INTO portfolios (id, agency_id, name)
VALUES ('48b7e216-fe76-4bc6-96fb-0c5e139bbeaf', 'AGENCY_ID_PLACEHOLDER', 'Default Portfolio')
ON CONFLICT (id) DO NOTHING;

BEGIN;

-- Insert building
INSERT INTO buildings (id, name, address, portfolio_id) VALUES ('ecf49f28-c1bd-4427-ab8b-1d89f9ff0a89', 'Connaught Square', 'CONNAUGHT SQUARE', '48b7e216-fe76-4bc6-96fb-0c5e139bbeaf');

-- Insert 1 schedule(s)
INSERT INTO schedules (id, building_id, name, description) VALUES ('a31a10c8-44f3-4bba-885f-eec7e7aeb286', 'ecf49f28-c1bd-4427-ab8b-1d89f9ff0a89', 'Main Schedule', 'Auto-detected schedule from onboarding');
-- Created schedules: Main Schedule

-- Insert 3 units
INSERT INTO units (id, building_id, unit_number) VALUES
('d64a537c-a289-42ce-8f02-2d8d2a57c543', 'ecf49f28-c1bd-4427-ab8b-1d89f9ff0a89', 'Flat 1'),
('4dc0e3c3-01e5-4da2-ae66-7abb8f545a26', 'ecf49f28-c1bd-4427-ab8b-1d89f9ff0a89', 'Flat 2'),
('d9a4a8dd-1937-4149-bf9c-d838805f3ffc', 'ecf49f28-c1bd-4427-ab8b-1d89f9ff0a89', 'Flat 3')
ON CONFLICT (id) DO NOTHING;

-- Insert 2 leaseholders (schema has building_id and unit_number)
INSERT INTO leaseholders (id, building_id, unit_id, unit_number, name) VALUES
('c249bdb8-1ed1-4bd6-92ca-bed8c4e37077', 'ecf49f28-c1bd-4427-ab8b-1d89f9ff0a89', NULL, 'Flat 1', 'Marmotte Holdings Limited'),
('6d90a6ae-f7c0-43ab-91c9-45156904be87', 'ecf49f28-c1bd-4427-ab8b-1d89f9ff0a89', NULL, 'Flat 2', 'Ms V Rebulla')
ON CONFLICT (id) DO NOTHING;

-- Insert 1 budgets
INSERT INTO budgets (id, building_id, period, year_start, year_end, total_amount) VALUES ('4b6d4b01-07ab-4917-978c-5217741cf13a', 'ecf49f28-c1bd-4427-ab8b-1d89f9ff0a89', '2025', '2025-01-01', '2025-12-31', 50000.0);

-- ===========================
-- CONTRACTORS
-- ===========================

INSERT INTO contractors (id, name, phone, address) VALUES
('345f9497-5fd6-4cf6-a414-7244bb666112', 'ISS', '083603538855', 'London, We''re available on Live Chat here., W1S 1RS')
ON CONFLICT (id) DO NOTHING;

INSERT INTO contractors (id, name, email, phone, address) VALUES
('79797fdd-d52b-4ec1-92ac-61f37eb04f39', 'Quotehedge', 'info@quotehedge-heating.co.uk', '07801 799118', '182 Revelstoke Road, Wandsworth, London, SW18 5NW')
ON CONFLICT (id) DO NOTHING;

INSERT INTO contractors (id, name, email, address) VALUES
('cb72e610-a228-4827-8c91-e6897bb0cb29', 'WHM', 'enquiries@whmltd.org', 'WATER HYGIENE MANAGEMENT L TD, 2 Churchill Court, Hortons Way,, Westerham, Kent, TN16 1BT')
ON CONFLICT (id) DO NOTHING;


-- ===========================
-- CONTRACTS -> CONTRACTOR_CONTRACTS
-- ===========================
-- Map:
--   contractor_name -> contractor_id (lookup by contractors.name)
--   service_type -> service_category
--   frequency -> payment_frequency
--   contract_status -> is_active (active -> TRUE; expired/others -> FALSE)
--   NULL service_category -> 'unspecified'

INSERT INTO contractor_contracts (
  id, building_id, contractor_id, service_category, start_date, end_date, is_active
)
SELECT
  '05954c7c-b27d-40cf-99b6-1ec1730a7252',
  'ecf49f28-c1bd-4427-ab8b-1d89f9ff0a89',
  c.id,
  'unspecified',
  CURRENT_DATE,
  CURRENT_DATE + INTERVAL '1 year',
  TRUE
FROM contractors c WHERE c.name = 'ISS'
ON CONFLICT (id) DO NOTHING;

INSERT INTO contractor_contracts (
  id, building_id, contractor_id, service_category, start_date, end_date, payment_frequency, is_active
)
SELECT
  'd4a4523c-9254-424f-8614-89eb55632496',
  'ecf49f28-c1bd-4427-ab8b-1d89f9ff0a89',
  c.id,
  'lifts',
  CURRENT_DATE,
  CURRENT_DATE + INTERVAL '1 year',
  'monthly',
  TRUE
FROM contractors c WHERE c.name = 'ISS'
ON CONFLICT (id) DO NOTHING;

INSERT INTO contractor_contracts (
  id, building_id, contractor_id, service_category, start_date, end_date, payment_frequency, is_active
)
SELECT
  '596fb01e-6dab-4522-acf6-df9f93eddb98',
  'ecf49f28-c1bd-4427-ab8b-1d89f9ff0a89',
  c.id,
  'security',
  CURRENT_DATE,
  CURRENT_DATE + INTERVAL '1 year',
  'quarterly',
  TRUE
FROM contractors c WHERE c.name = 'ISS'
ON CONFLICT (id) DO NOTHING;

INSERT INTO contractor_contracts (
  id, building_id, contractor_id, service_category, start_date, end_date, is_active
)
SELECT
  'd2a40592-3c0c-4bf7-ae66-16b4a0634fcc',
  'ecf49f28-c1bd-4427-ab8b-1d89f9ff0a89',
  c.id,
  'unspecified',
  CURRENT_DATE,
  CURRENT_DATE + INTERVAL '1 year',
  TRUE
FROM contractors c WHERE c.name = 'Quotehedge'
ON CONFLICT (id) DO NOTHING;

INSERT INTO contractor_contracts (
  id, building_id, contractor_id, service_category, start_date, end_date, payment_frequency, is_active
)
SELECT
  '792e267f-0838-4495-b327-185f7f2d2805',
  'ecf49f28-c1bd-4427-ab8b-1d89f9ff0a89',
  c.id,
  'unspecified',
  CURRENT_DATE,
  CURRENT_DATE + INTERVAL '1 year',
  'monthly',
  TRUE
FROM contractors c WHERE c.name = 'WHM'
ON CONFLICT (id) DO NOTHING;


-- ===========================
-- BUILDING_CONTRACTORS
-- ===========================

INSERT INTO building_contractors (id, building_id, contractor_type, company_name)
VALUES ('8d7a347c-801d-4efa-8648-f13e0fbb3643', 'ecf49f28-c1bd-4427-ab8b-1d89f9ff0a89', 'service_provider', 'ISS')
ON CONFLICT (id) DO NOTHING;

INSERT INTO building_contractors (id, building_id, contractor_type, company_name, email, phone)
VALUES ('7dd04a6c-7971-4182-abf5-30b19a5fa97c', 'ecf49f28-c1bd-4427-ab8b-1d89f9ff0a89', 'service_provider', 'Quotehedge', 'info@quotehedge-heating.co.uk', '07801 799118')
ON CONFLICT (id) DO NOTHING;



-- Migration complete
COMMIT;

-- Rollback command (if needed):
-- ROLLBACK;