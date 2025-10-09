-- ============================================================
-- PATCHED: BlocIQ Onboarder - Auto-generated Migration (Schema-Corrected)
-- Generated at: 2025-10-09T17:19:58.080793
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
VALUES ('eb0ba9ba-f405-4617-8abf-7864c4a9ccf9', 'AGENCY_ID_PLACEHOLDER', 'Default Portfolio')
ON CONFLICT (id) DO NOTHING;

BEGIN;

-- Insert building
INSERT INTO buildings (id, name, address, portfolio_id) VALUES ('e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'Connaught Square', 'CONNAUGHT SQUARE', 'eb0ba9ba-f405-4617-8abf-7864c4a9ccf9');

-- Insert 1 schedule(s)
INSERT INTO schedules (id, building_id, name, description) VALUES ('2c922416-3e98-400d-84a4-f7ecc3c37b01', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'Main Schedule', 'Auto-detected schedule from onboarding');
-- Created schedules: Main Schedule

-- Insert 8 units
INSERT INTO units (id, building_id, unit_number) VALUES
('ce5de5a6-3d9c-4811-a865-689a9b76b273', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'Flat 1'),
('34d05e69-2f83-4ea2-91ae-21ed12c2f1e7', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'Flat 2'),
('f88a8907-3e75-433d-9520-5669b52b5360', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'Flat 3'),
('1e7ab66f-fa59-43a5-9444-915b30444fda', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'Flat 4'),
('51d6aa42-b827-4614-9c6c-8a9dc00e1bd5', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'Flat 5'),
('7dbcae82-a59a-496d-8e70-51dc0f838d06', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'Flat 6'),
('36633f77-4543-417c-8dde-9bd3f29bdfe6', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'Flat 7'),
('6caa675e-81ab-4a87-a842-32a5d71aa33e', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'Flat 8')
ON CONFLICT (id) DO NOTHING;

-- Insert 8 leaseholders (schema has building_id and unit_number)
INSERT INTO leaseholders (id, building_id, unit_id, unit_number, name) VALUES
('00ecce67-5327-461e-85db-32a8e2c1b3bb', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'ce5de5a6-3d9c-4811-a865-689a9b76b273', 'Flat 1', 'Marmotte Holdings Limited'),
('80256cf0-60f4-4216-93e6-147a2498a6b3', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', '34d05e69-2f83-4ea2-91ae-21ed12c2f1e7', 'Flat 2', 'Ms V Rebulla'),
('07731af1-61f0-47ee-bbee-91748835ef9e', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'f88a8907-3e75-433d-9520-5669b52b5360', 'Flat 3', 'Ms V Rebulla'),
('28e4cd96-6d9a-45eb-8f88-8e66a0fb46d5', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', '1e7ab66f-fa59-43a5-9444-915b30444fda', 'Flat 4', 'Mr P J J Reynish & Ms C A O''Loughlin'),
('062d5d4e-f4b6-466a-b667-8df3506e5532', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', '51d6aa42-b827-4614-9c6c-8a9dc00e1bd5', 'Flat 5', 'Mr & Mrs M D Samworth'),
('e2059b17-3d80-4efa-8379-c58f500b87b9', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', '7dbcae82-a59a-496d-8e70-51dc0f838d06', 'Flat 6', 'Mr M D & Mrs C P Samworth'),
('6e58cebb-df1c-4026-9885-ace07a82c677', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', '36633f77-4543-417c-8dde-9bd3f29bdfe6', 'Flat 7', 'Ms J Gomm'),
('91bd3921-0b48-47fe-b8d4-c106ae1ec969', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', '6caa675e-81ab-4a87-a842-32a5d71aa33e', 'Flat 8', 'Miss T V Samwoth & Miss G E Samworth')
ON CONFLICT (id) DO NOTHING;

-- Insert 56 compliance assets
INSERT INTO compliance_assets (id, building_id, description, asset_name, asset_type, inspection_frequency, last_inspection_date, next_due_date, compliance_status, is_active) VALUES ('5ca83e99-40d9-48cf-8d35-c72f05b3ce94', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'Extracted from 2024 Directors Meeting-Notes.docx', 'Compliance Asset', 'general', '12 months', '2024-01-01', '2025-01-01', 'overdue', TRUE);
INSERT INTO compliance_assets (id, building_id, description, asset_name, asset_type, inspection_frequency, compliance_status, location, is_active) VALUES ('df46879d-9224-4d5a-9c91-df8ebab00db9', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'Extracted from Fire Door (Communal) Inspection (11m +) (7).pdf', 'Fire Door Inspection', 'fire_safety', '12 months', 'unknown', 'Communal', TRUE);
INSERT INTO compliance_assets (id, building_id, description, asset_name, asset_type, inspection_frequency, compliance_status, is_active) VALUES ('fad3292e-a57d-4c84-8f72-3a5967669012', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'Extracted from Fire Door (Flats) Inspection (11m +) (13).pdf', 'Fire Door Inspection', 'fire_safety', '12 months', 'unknown', TRUE);
INSERT INTO compliance_assets (id, building_id, description, asset_name, asset_type, inspection_frequency, compliance_status, is_active) VALUES ('db221dae-173b-4c18-81c9-20916654c5df', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'Extracted from Fire Door (Flats) Inspection (11m +) (18).pdf', 'Fire Door Inspection', 'fire_safety', '12 months', 'unknown', TRUE);
INSERT INTO compliance_assets (id, building_id, description, asset_name, asset_type, inspection_frequency, compliance_status, is_active) VALUES ('bc41afeb-d85c-4970-87d3-9e53707c219f', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'Extracted from Fire Door (Flats) Inspection (11m +) (14).pdf', 'Fire Door Inspection', 'fire_safety', '12 months', 'unknown', TRUE);
INSERT INTO compliance_assets (id, building_id, description, asset_name, asset_type, inspection_frequency, compliance_status, is_active) VALUES ('1f22a32d-8f22-4295-b7f6-dbcef6f6263e', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'Extracted from EICR Cuanku 32-34 conaught square.pdf', 'Electrical Installation Condition Report (EICR)', 'electrical', '60 months', 'unknown', TRUE);
INSERT INTO compliance_assets (id, building_id, description, asset_name, asset_type, inspection_frequency, compliance_status, is_active) VALUES ('2aa48fc6-af3c-4e62-bc1b-a8c740b9fd66', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'Extracted from Fire Door (Flats) Inspection (11m +) (15).pdf', 'Fire Door Inspection', 'fire_safety', '12 months', 'unknown', TRUE);
INSERT INTO compliance_assets (id, building_id, description, asset_name, asset_type, inspection_frequency, last_inspection_date, next_due_date, compliance_status, is_active) VALUES ('b71adc07-5192-4608-b672-33770344e9dc', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'Extracted from 221037_Fra1-L-394697-071223 32-34 Connaught Square_2024-01-02_163759 (1).pdf', 'Fire Risk Assessment (FRA)', 'fire_safety', '12 months', '2024-01-02', '2025-01-02', 'overdue', TRUE);
INSERT INTO compliance_assets (id, building_id, description, asset_name, asset_type, inspection_frequency, compliance_status, is_active) VALUES ('66b930cd-f8fb-4c4d-b98f-095f0c603b5f', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'Extracted from Fire Door (Flats) Inspection (11m +) (19).pdf', 'Fire Door Inspection', 'fire_safety', '12 months', 'unknown', TRUE);
INSERT INTO compliance_assets (id, building_id, description, asset_name, asset_type, inspection_frequency, compliance_status, is_active) VALUES ('247d2f1a-dae4-432a-bc23-5b16b230df9e', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'Extracted from 001132-3234-Connaught-Square-London.pdf', 'Compliance Asset', 'general', '12 months', 'unknown', TRUE);
INSERT INTO compliance_assets (id, building_id, description, asset_name, asset_type, inspection_frequency, last_inspection_date, next_due_date, compliance_status, is_active) VALUES ('3ae9e695-9bc3-4a51-b439-9a09fdfaaa60', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'Extracted from 221038_Hsra1-L-394697-071223 32-34 Connaught Square_2024-01-02_163759 (1).pdf', 'Compliance Asset', 'general', '12 months', '2024-01-02', '2025-01-02', 'overdue', TRUE);
INSERT INTO compliance_assets (id, building_id, description, asset_name, asset_type, inspection_frequency, compliance_status, is_active) VALUES ('7906df7a-13e9-44c1-88cd-f91487a58022', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'Extracted from TETRA - Asbestos Re-Inspection Survey 14.06.22.pdf', 'Compliance Asset', 'general', '12 months', 'unknown', TRUE);
INSERT INTO compliance_assets (id, building_id, description, asset_name, asset_type, inspection_frequency, compliance_status, is_active) VALUES ('00c3eedb-aaea-4d1e-b1f6-39aa0196ba65', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'Extracted from Fire Door (Flats) Inspection (11m +) (16).pdf', 'Fire Door Inspection', 'fire_safety', '12 months', 'unknown', TRUE);
INSERT INTO compliance_assets (id, building_id, description, asset_name, asset_type, inspection_frequency, compliance_status, is_active) VALUES ('cdae0416-1de9-488b-8369-634d035f70f1', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'Extracted from Fire Door (Flats) Inspection (11m +) (17).pdf', 'Fire Door Inspection', 'fire_safety', '12 months', 'unknown', TRUE);
INSERT INTO compliance_assets (id, building_id, description, asset_name, asset_type, inspection_frequency, compliance_status, is_active) VALUES ('57c990a1-9aef-46a8-bfdc-3b19d84ab39e', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'Extracted from WHM Legionella Risk Assessment 07.06.22.pdf', 'Legionella Risk Assessment', 'water_safety', '24 months', 'unknown', TRUE);
INSERT INTO compliance_assets (id, building_id, description, asset_name, asset_type, inspection_frequency, last_inspection_date, next_due_date, compliance_status, is_active) VALUES ('8d62c047-5e07-4635-b0ea-3b21265a061d', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'Extracted from EICR Report Cunaku SATISFACTORY 2023 .pdf', 'Electrical Installation Condition Report (EICR)', 'electrical', '60 months', '2023-01-01', '2028-01-01', 'compliant', TRUE);
INSERT INTO compliance_assets (id, building_id, description, asset_name, asset_type, inspection_frequency, last_inspection_date, next_due_date, compliance_status, is_active) VALUES ('cd1539f6-1261-47cb-a0fd-18ec3f18b4b7', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'Extracted from 2024 Directors Meeting-Notes.docx', 'Compliance Asset', 'general', '12 months', '2024-01-01', '2025-01-01', 'overdue', TRUE);
INSERT INTO compliance_assets (id, building_id, description, asset_name, asset_type, inspection_frequency, compliance_status, is_active) VALUES ('56e62bfb-8644-46de-b8f0-7379b7c3b6a9', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'Extracted from 001457-3234-Connaught-Square-London Certificate.pdf', 'Compliance Asset', 'general', '12 months', 'unknown', TRUE);
INSERT INTO compliance_assets (id, building_id, description, asset_name, asset_type, inspection_frequency, compliance_status, is_active) VALUES ('a3a26b20-969b-4618-bfcf-e78014bc3d0d', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'Extracted from TC0001V31 General Terms and Conditions.pdf', 'Compliance Asset', 'general', '12 months', 'unknown', TRUE);
INSERT INTO compliance_assets (id, building_id, description, asset_name, asset_type, inspection_frequency, last_inspection_date, next_due_date, compliance_status, is_active) VALUES ('73a91837-178a-462b-bcb5-fa91184ae482', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'Extracted from Jobcard_For_Job_No_28992_24-01-2025_1545.pdf', 'Compliance Asset', 'general', '12 months', '2025-01-24', '2026-01-24', 'compliant', TRUE);
INSERT INTO compliance_assets (id, building_id, description, asset_name, asset_type, inspection_frequency, compliance_status, is_active) VALUES ('edbd5680-76ad-4cbb-857d-a70f0765ab72', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'Extracted from Connaught Square (32-34) - 09.12.24 LRA.pdf', 'Compliance Asset', 'general', '12 months', 'unknown', TRUE);
INSERT INTO compliance_assets (id, building_id, description, asset_name, asset_type, inspection_frequency, compliance_status, is_active) VALUES ('1a52dae6-9cd9-4fa6-8cd1-50d2d4bf5e6f', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'Extracted from SC Certificate - 10072023.pdf', 'Compliance Asset', 'general', '12 months', 'unknown', TRUE);
INSERT INTO compliance_assets (id, building_id, description, asset_name, asset_type, inspection_frequency, compliance_status, location, is_active) VALUES ('eac9f41e-c213-4ce4-873a-4639c0da81dc', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'Extracted from Fire Door (Communal) Inspection (11m +) (7).pdf', 'Fire Door Inspection', 'fire_safety', '12 months', 'unknown', 'Communal', TRUE);
INSERT INTO compliance_assets (id, building_id, description, asset_name, asset_type, inspection_frequency, compliance_status, is_active) VALUES ('02f13562-9c43-4982-826a-52185efdf40d', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'Extracted from Fire Door (Flats) Inspection (11m +) (13).pdf', 'Fire Door Inspection', 'fire_safety', '12 months', 'unknown', TRUE);
INSERT INTO compliance_assets (id, building_id, description, asset_name, asset_type, inspection_frequency, compliance_status, is_active) VALUES ('80cda00b-bb3f-49ad-b3ee-c62d3c4eff21', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'Extracted from Fire Door (Flats) Inspection (11m +) (18).pdf', 'Fire Door Inspection', 'fire_safety', '12 months', 'unknown', TRUE);
INSERT INTO compliance_assets (id, building_id, description, asset_name, asset_type, inspection_frequency, compliance_status, is_active) VALUES ('880a4890-25de-4a9e-92b9-40aee75e6fb3', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'Extracted from Fire Door (Flats) Inspection (11m +) (14).pdf', 'Fire Door Inspection', 'fire_safety', '12 months', 'unknown', TRUE);
INSERT INTO compliance_assets (id, building_id, description, asset_name, asset_type, inspection_frequency, compliance_status, is_active) VALUES ('2dacd6bf-cf23-474f-bb14-6c17e9c0d462', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'Extracted from Fire Door (Flats) Inspection (11m +) (15).pdf', 'Fire Door Inspection', 'fire_safety', '12 months', 'unknown', TRUE);
INSERT INTO compliance_assets (id, building_id, description, asset_name, asset_type, inspection_frequency, compliance_status, is_active) VALUES ('d0947519-7893-440f-ab53-ecfbc1e19831', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'Extracted from Fire Door (Flats) Inspection (11m +) (19).pdf', 'Fire Door Inspection', 'fire_safety', '12 months', 'unknown', TRUE);
INSERT INTO compliance_assets (id, building_id, description, asset_name, asset_type, inspection_frequency, compliance_status, is_active) VALUES ('2cc3402a-775a-453f-958c-33c6413e565a', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'Extracted from Fire Door (Flats) Inspection (11m +) (16).pdf', 'Fire Door Inspection', 'fire_safety', '12 months', 'unknown', TRUE);
INSERT INTO compliance_assets (id, building_id, description, asset_name, asset_type, inspection_frequency, compliance_status, is_active) VALUES ('f143e6bf-b107-4035-8612-1681197b67d3', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'Extracted from Fire Door (Flats) Inspection (11m +) (17).pdf', 'Fire Door Inspection', 'fire_safety', '12 months', 'unknown', TRUE);
INSERT INTO compliance_assets (id, building_id, description, asset_name, asset_type, inspection_frequency, last_inspection_date, next_due_date, compliance_status, is_active) VALUES ('26d8a580-5dce-4911-a8ac-3fd736b1bb24', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'Extracted from 221037_Fra1-L-394697-071223 32-34 Connaught Square_2024-01-02_163759.pdf', 'Fire Risk Assessment (FRA)', 'fire_safety', '12 months', '2024-01-02', '2025-01-02', 'overdue', TRUE);
INSERT INTO compliance_assets (id, building_id, description, asset_name, asset_type, inspection_frequency, last_inspection_date, next_due_date, compliance_status, is_active) VALUES ('7b32663e-056b-4578-899d-475cf57eedc7', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'Extracted from Fire Door (Flats) Inspection (11m +) - 2024-01-24T120747.552.pdf', 'Fire Door Inspection', 'fire_safety', '12 months', '2024-01-24', '2025-01-24', 'overdue', TRUE);
INSERT INTO compliance_assets (id, building_id, description, asset_name, asset_type, inspection_frequency, compliance_status, is_active) VALUES ('a60d1042-102c-4f16-8e75-9b7015e98483', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'Extracted from Connaught Square (32-34) - 15.11.23 (886) wa.pdf', 'Compliance Asset', 'general', '12 months', 'unknown', TRUE);
INSERT INTO compliance_assets (id, building_id, description, asset_name, asset_type, inspection_frequency, last_inspection_date, next_due_date, compliance_status, is_active) VALUES ('5f4dfb92-2ae8-4b47-bcd0-6592c7613642', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'Extracted from Fire Door (Flats) Inspection (11m +) - 2024-01-24T120745.875.pdf', 'Fire Door Inspection', 'fire_safety', '12 months', '2024-01-24', '2025-01-24', 'overdue', TRUE);
INSERT INTO compliance_assets (id, building_id, description, asset_name, asset_type, inspection_frequency, last_inspection_date, next_due_date, compliance_status, is_active) VALUES ('06a414dd-a735-4b96-8a22-3f0cc6f686bf', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'Extracted from Fire Door (Flats) Inspection (11m +) - 2024-01-24T120746.424.pdf', 'Fire Door Inspection', 'fire_safety', '12 months', '2024-01-24', '2025-01-24', 'overdue', TRUE);
INSERT INTO compliance_assets (id, building_id, description, asset_name, asset_type, inspection_frequency, last_inspection_date, next_due_date, compliance_status, location, is_active) VALUES ('dfe36e9f-c954-4a77-ae18-81ad457a2e22', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'Extracted from Fire Door (Communal) Inspection (11m +) - 2024-01-24T120743.986.pdf', 'Fire Door Inspection', 'fire_safety', '12 months', '2024-01-24', '2025-01-24', 'overdue', 'Communal', TRUE);
INSERT INTO compliance_assets (id, building_id, description, asset_name, asset_type, inspection_frequency, last_inspection_date, next_due_date, compliance_status, is_active) VALUES ('f2957112-a5c1-4b65-96e4-c0fb88db6172', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'Extracted from Fire Door (Flats) Inspection (11m +) - 2024-01-24T120744.738.pdf', 'Fire Door Inspection', 'fire_safety', '12 months', '2024-01-24', '2025-01-24', 'overdue', TRUE);
INSERT INTO compliance_assets (id, building_id, description, asset_name, asset_type, inspection_frequency, last_inspection_date, next_due_date, compliance_status, is_active) VALUES ('1db76f63-fee8-425b-8f92-57ef59a55475', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'Extracted from Fire Door (Flats) Inspection (11m +) - 2024-01-24T120747.015.pdf', 'Fire Door Inspection', 'fire_safety', '12 months', '2024-01-24', '2025-01-24', 'overdue', TRUE);
INSERT INTO compliance_assets (id, building_id, description, asset_name, asset_type, inspection_frequency, last_inspection_date, next_due_date, compliance_status, is_active) VALUES ('3152b66f-c1ff-4fa7-9499-d8ad04982166', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'Extracted from 221038_Hsra1-L-394697-071223 32-34 Connaught Square_2024-01-02_163759.pdf', 'Compliance Asset', 'general', '12 months', '2024-01-02', '2025-01-02', 'overdue', TRUE);
INSERT INTO compliance_assets (id, building_id, description, asset_name, asset_type, inspection_frequency, last_inspection_date, next_due_date, compliance_status, is_active) VALUES ('06d36d15-b0b3-4170-99d9-d2715caaf0c1', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'Extracted from Fire Door (Flats) Inspection (11m +) - 2024-01-24T120745.174.pdf', 'Fire Door Inspection', 'fire_safety', '12 months', '2024-01-24', '2025-01-24', 'overdue', TRUE);
INSERT INTO compliance_assets (id, building_id, description, asset_name, asset_type, inspection_frequency, compliance_status, is_active) VALUES ('df55713d-a74d-40f7-af42-efbe20fe972f', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'Extracted from Hsfra1-L-422971-210225 32-34 Connaught Square.pdf', 'Fire Risk Assessment (FRA)', 'fire_safety', '12 months', 'unknown', TRUE);
INSERT INTO compliance_assets (id, building_id, description, asset_name, asset_type, inspection_frequency, compliance_status, is_active) VALUES ('29a2946d-2bea-4c2e-be80-6fffa408d5a2', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'Extracted from Hsfra1-L-422971-210225 32-34 Connaught Square.docx', 'Fire Risk Assessment (FRA)', 'fire_safety', '12 months', 'unknown', TRUE);
INSERT INTO compliance_assets (id, building_id, description, asset_name, asset_type, inspection_frequency, last_inspection_date, next_due_date, compliance_status, is_active) VALUES ('40419323-f51c-489d-bfad-4943c4132056', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'Extracted from 221037_Fra1-L-394697-071223 32-34 Connaught Square_2024-01-02_163759 (1).pdf', 'Fire Risk Assessment (FRA)', 'fire_safety', '12 months', '2024-01-02', '2025-01-02', 'overdue', TRUE);
INSERT INTO compliance_assets (id, building_id, description, asset_name, asset_type, inspection_frequency, last_inspection_date, next_due_date, compliance_status, is_active) VALUES ('1782f2c8-4696-4290-b982-a8446ce55aa2', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'Extracted from 221038_Hsra1-L-394697-071223 32-34 Connaught Square_2024-01-02_163759 (1).pdf', 'Compliance Asset', 'general', '12 months', '2024-01-02', '2025-01-02', 'overdue', TRUE);
INSERT INTO compliance_assets (id, building_id, description, asset_name, asset_type, inspection_frequency, compliance_status, is_active) VALUES ('8c317290-1a17-4d87-8335-f34380ccf626', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'Extracted from FRA-Connaught Square Reccommendations.xlsx', 'Fire Risk Assessment (FRA)', 'fire_safety', '12 months', 'unknown', TRUE);
INSERT INTO compliance_assets (id, building_id, description, asset_name, asset_type, inspection_frequency, compliance_status, is_active) VALUES ('a0d3b8cb-bc05-479d-b090-fe3fe1c7f7d3', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'Extracted from 001534-3234-Connaught-Square-London.pdf', 'Compliance Asset', 'general', '12 months', 'unknown', TRUE);
INSERT INTO compliance_assets (id, building_id, description, asset_name, asset_type, inspection_frequency, compliance_status, is_active) VALUES ('9924adfe-a5d4-46b9-a427-b8de70d78522', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'Extracted from C1047 - Job card.pdf', 'Compliance Asset', 'general', '12 months', 'unknown', TRUE);
INSERT INTO compliance_assets (id, building_id, description, asset_name, asset_type, inspection_frequency, compliance_status, is_active) VALUES ('fa82ed27-f507-4420-9733-89e6f9a648fd', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'Extracted from WHM Legionella Risk Assessment 09.12.25.pdf', 'Legionella Risk Assessment', 'water_safety', '24 months', 'unknown', TRUE);
INSERT INTO compliance_assets (id, building_id, description, asset_name, asset_type, inspection_frequency, compliance_status, is_active) VALUES ('fc44604d-7b72-49fa-95a7-4283a9b26171', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'Extracted from WHM Legionella Risk Assessment 07.06.22.pdf', 'Legionella Risk Assessment', 'water_safety', '24 months', 'unknown', TRUE);
INSERT INTO compliance_assets (id, building_id, description, asset_name, asset_type, inspection_frequency, compliance_status, is_active) VALUES ('5f7ccbda-1c55-488c-b64d-4f782a8480b8', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'Extracted from Connaught Square (32-34) - 29.05.25 (201) wa.pdf', 'Compliance Asset', 'general', '12 months', 'unknown', TRUE);
INSERT INTO compliance_assets (id, building_id, description, asset_name, asset_type, inspection_frequency, compliance_status, is_active) VALUES ('0cbf35d8-253c-476e-a74d-3f482fce02b8', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'Extracted from EICR Cuanku 32-34 conaught square.pdf', 'Electrical Installation Condition Report (EICR)', 'electrical', '60 months', 'unknown', TRUE);
INSERT INTO compliance_assets (id, building_id, description, asset_name, asset_type, inspection_frequency, last_inspection_date, next_due_date, compliance_status, is_active) VALUES ('1bbf46c2-0ec7-466a-b44a-fd877c42923c', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'Extracted from EICR Report Cunaku SATISFACTORY 2023 .pdf', 'Electrical Installation Condition Report (EICR)', 'electrical', '60 months', '2023-01-01', '2028-01-01', 'compliant', TRUE);
INSERT INTO compliance_assets (id, building_id, description, asset_name, asset_type, inspection_frequency, compliance_status, is_active) VALUES ('6858c1b4-47bc-4ecc-a043-41cabe1bba2d', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'Extracted from 001132-3234-Connaught-Square-London.pdf', 'Compliance Asset', 'general', '12 months', 'unknown', TRUE);
INSERT INTO compliance_assets (id, building_id, description, asset_name, asset_type, inspection_frequency, compliance_status, is_active) VALUES ('c34c3526-78d7-40ac-93a4-f53ffdd76ba0', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'Extracted from 001534-3234-Connaught-Square-London.pdf', 'Compliance Asset', 'general', '12 months', 'unknown', TRUE);
INSERT INTO compliance_assets (id, building_id, description, asset_name, asset_type, inspection_frequency, compliance_status, is_active) VALUES ('dd3a24eb-a4eb-4381-aa93-3d11d2dfd318', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'Extracted from FINAL L-432900 32-34 Connaught Square Management Survey Report Issue 1.pdf', 'Compliance Asset', 'general', '12 months', 'unknown', TRUE);
INSERT INTO compliance_assets (id, building_id, description, asset_name, asset_type, inspection_frequency, compliance_status, is_active) VALUES ('f5a8d6b0-8cc8-49c9-9f48-257c3100a8ca', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'Extracted from TETRA - Asbestos Re-Inspection Survey 14.06.22.pdf', 'Compliance Asset', 'general', '12 months', 'unknown', TRUE);

-- Insert 4 major works projects
INSERT INTO major_works_projects (id, building_id, project_name, status, start_date) VALUES ('0ddb9bb7-348a-4636-b3fa-19267e0688e9', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'External Decoration - 2025', 'planned', '2025-01-01');
INSERT INTO major_works_projects (id, building_id, project_name, status, start_date) VALUES ('994e8cc5-0c4a-4161-9bd8-edf52c0a0e4b', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'Section 20 Consultation (SOE) - 2025', 'planned', '2025-01-01');
INSERT INTO major_works_projects (id, building_id, project_name, status, start_date) VALUES ('1ca52d11-f6be-4317-9340-de3f3e98a337', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'Lift - Section 20 (NOI) - 2025', 'planned', '2025-01-01');
INSERT INTO major_works_projects (id, building_id, project_name, status, start_date) VALUES ('35a9ab5a-0fdd-47ee-82f6-d02665e7adf1', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'Major Works Project - 2025', 'planned', '2025-01-01');

-- Insert 22 budgets
INSERT INTO budgets (id, building_id, year_start, year_end, period) VALUES ('b875c2f5-1c5f-423a-b7b0-a47d6d374b17', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', '2025-04-01', '2026-03-31', '2025');
INSERT INTO budgets (id, building_id, year_start, year_end, period) VALUES ('be9d6c8c-440b-42db-b2e7-16b5c00530f7', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', '2025-04-01', '2026-03-31', '2025');
INSERT INTO budgets (id, building_id, year_start, year_end, period) VALUES ('803dafdd-102a-4e81-b441-0f1aada8eecf', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', '2025-04-01', '2026-03-31', '2025');
INSERT INTO budgets (id, building_id, year_start, year_end, period) VALUES ('30ce5e44-b860-4a91-8c2c-c93800d497c7', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', '2025-04-01', '2026-03-31', '2025');
INSERT INTO budgets (id, building_id, year_start, year_end, period) VALUES ('d9a71ea2-c817-48a2-abfb-8492835d1850', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', '2025-04-01', '2026-03-31', '2025');
INSERT INTO budgets (id, building_id, year_start, year_end, period) VALUES ('b27f0744-7de0-4e5c-8dde-11657d51f27c', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', '2025-04-01', '2026-03-31', '2025');
INSERT INTO budgets (id, building_id, year_start, year_end, period) VALUES ('db7bc062-6b77-4256-992a-e1f0b2001689', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', '2025-04-01', '2026-03-31', '2025');
INSERT INTO budgets (id, building_id, year_start, year_end, period) VALUES ('c8417294-26da-4882-aee7-fa7ff1d054ce', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', '2025-04-01', '2026-03-31', '2025');
INSERT INTO budgets (id, building_id, year_start, year_end, period) VALUES ('0b05f70f-db40-48f8-896d-95d4a22c6ac9', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', '2025-04-01', '2026-03-31', '2025');
INSERT INTO budgets (id, building_id, year_start, year_end, period) VALUES ('06918f5a-9310-4dd0-8af1-7b732d374637', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', '2025-04-01', '2026-03-31', '2025');
INSERT INTO budgets (id, building_id, year_start, year_end, period) VALUES ('abe75575-6c5a-42b4-ac28-31cbfed1a7e6', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', '2025-04-01', '2026-03-31', '2025');
INSERT INTO budgets (id, building_id, year_start, year_end, period) VALUES ('b110be35-3919-4182-a2ce-8c7bded6ad63', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', '2025-04-01', '2026-03-31', '2025');
INSERT INTO budgets (id, building_id, year_start, year_end, period) VALUES ('c5dad7f0-f2b9-498f-b1e9-af29bd583ece', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', '2025-04-01', '2026-03-31', '2025');
INSERT INTO budgets (id, building_id, year_start, year_end, period) VALUES ('297f6f79-bf03-47ed-af96-cb28606f9039', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', '2025-04-01', '2026-03-31', '2025');
INSERT INTO budgets (id, building_id, year_start, year_end, period) VALUES ('c4761802-58c1-4b1e-ba0e-7c5b822fd426', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', '2025-04-01', '2026-03-31', '2025');
INSERT INTO budgets (id, building_id, year_start, year_end, period) VALUES ('db787f99-6e7f-45ca-ad60-ad1925fefc63', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', '2025-04-01', '2026-03-31', '2025');
INSERT INTO budgets (id, building_id, year_start, year_end, period) VALUES ('fcc72930-30d1-473d-8608-f588617e2830', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', '2025-04-01', '2026-03-31', '2025');
INSERT INTO budgets (id, building_id, year_start, year_end, period) VALUES ('072a39c4-bd25-4ec7-8c8d-346cc0d6eeff', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', '2025-04-01', '2026-03-31', '2025');
INSERT INTO budgets (id, building_id, year_start, year_end, period) VALUES ('ef9c7ea8-f5dc-400c-94b1-3b540b75ad2c', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', '2025-04-01', '2026-03-31', '2025');
INSERT INTO budgets (id, building_id, year_start, year_end, period) VALUES ('a11d9729-6ba9-4bc6-870e-2724c75c137b', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', '2025-04-01', '2026-03-31', '2025');
INSERT INTO budgets (id, building_id, year_start, year_end, period) VALUES ('86c643ab-949d-4600-b5e0-06babfd650a6', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', '2025-04-01', '2026-03-31', '2025');
INSERT INTO budgets (id, building_id, year_start, year_end, period) VALUES ('aa10e50b-073b-490b-95d6-b3a343c65faa', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', '2025-04-01', '2026-03-31', '2025');

-- Insert 318 document records
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('9b158594-b4fc-4431-9602-f99f34070d00', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'lease', 'Important Information .pdf', 'lease/Important Information .pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('05f67652-c22e-4bd4-a3fc-c78e1111d8a0', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'finance', 'ACCOUNTS - YE 31.03.21 - Service Charge Accounts (1).pdf', 'finance/ACCOUNTS - YE 31.03.21 - Service Charge Accounts (1).pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('4fa4bffa-e517-441a-8579-2f179e1d0275', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'lease', 'Official Copy (Lease) 04.08.2022 - NGL809841 (1).pdf', 'lease/Official Copy (Lease) 04.08.2022 - NGL809841 (1).pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('f09543b6-3927-4401-9f66-063a49e99884', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'lease', 'Official Copy (Lease) 04.08.2022 - NGL809841 (2).pdf', 'lease/Official Copy (Lease) 04.08.2022 - NGL809841 (2).pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('ef082d9b-697b-4720-900f-38128e074204', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'lease', 'Official Copy (Lease) 13.06.2003 - NGL827422.pdf', 'lease/Official Copy (Lease) 13.06.2003 - NGL827422.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('e470af26-14fe-47c5-a62c-27f69d4b8ad3', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'lease', 'Official Copy (Lease) 04.08.2022 - NGL809841.pdf', 'lease/Official Copy (Lease) 04.08.2022 - NGL809841.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('0f39b1d5-8c7b-453e-88c9-dfccc7f798f2', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'lease', 'Signed April 2025 Arrears Collection Procedure.pdf', 'lease/Signed April 2025 Arrears Collection Procedure.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('cc30395c-8658-4e93-830b-f5715e078cf3', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'lease', 'WP0005V17 Welcome Pack.pdf', 'lease/WP0005V17 Welcome Pack.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('98b471bb-7233-4ff6-80e9-b4895e046eaa', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'lease', 'Jobcard_For_Job_No_33844_07-04-2025_1143.pdf', 'lease/Jobcard_For_Job_No_33844_07-04-2025_1143.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('99087d00-aede-41e6-b376-a692aa81d06e', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'lease', 'Jobcard_For_Job_No_37675_25-07-2025_1549.pdf', 'lease/Jobcard_For_Job_No_37675_25-07-2025_1549.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('cc87eefa-6db3-4714-82e9-4f9983d62393', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'lease', 'Jobcard_For_Job_No_34012_01-05-2025_1616.pdf', 'lease/Jobcard_For_Job_No_34012_01-05-2025_1616.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('184fb8a8-b82c-4fac-88ad-698d76f6cbf4', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'lease', 'Jobcard_For_Job_No_32759_17-03-2025_1145.pdf', 'lease/Jobcard_For_Job_No_32759_17-03-2025_1145.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('1f75c937-2922-4e07-80be-ec4ef2d3e392', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'lease', 'Jobcard_For_Job_No_32810_17-03-2025_1311.pdf', 'lease/Jobcard_For_Job_No_32810_17-03-2025_1311.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('dcf85f1d-2c85-4d5c-818c-a2054219e15f', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'contracts', 'Quote_No_23550 - Connaught Square (32-34) 2023-2024.pdf', 'contracts/Quote_No_23550 - Connaught Square (32-34) 2023-2024.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('0a5b513f-a7b0-4412-b601-08c9078f0782', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'lease', 'Licence_Document_352024.pdf', 'lease/Licence_Document_352024.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('f6473840-cfc2-4cef-a1bf-4b37327a8d40', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'lease', 'JLGServiceVisit-M00813-12-09-2024.pdf', 'lease/JLGServiceVisit-M00813-12-09-2024.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('42a9718b-062f-4562-ae3a-4d1caea189e6', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'lease', 'JLGServiceVisit-M00813-13-11-2024.pdf', 'lease/JLGServiceVisit-M00813-13-11-2024.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('24aa52e5-f842-4d2b-8234-ae67923ac382', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'lease', 'JLGServiceVisit-M00813-02-12-2024.pdf', 'lease/JLGServiceVisit-M00813-02-12-2024.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('f3f9e681-71d7-4238-9a20-a58bb7d0c676', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'lease', 'JLGServiceVisit-M00813-08-07-2024.pdf', 'lease/JLGServiceVisit-M00813-08-07-2024.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('0d345cef-83c7-4049-9958-f112b9deccca', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'lease', 'JLGServiceVisit-M00813-08-10-2024.pdf', 'lease/JLGServiceVisit-M00813-08-10-2024.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('05af2aa6-a523-4692-8562-1abba09f680f', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'lease', 'JLGServiceVisit-M00813-12-02-2025.pdf', 'lease/JLGServiceVisit-M00813-12-02-2025.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('30c0a3fa-63e7-434f-8873-5fef86e51af0', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'lease', 'JLGServiceVisit-M00813-17-03-2025.pdf', 'lease/JLGServiceVisit-M00813-17-03-2025.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('bb868d39-5a15-4a67-950a-8788a2973e15', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'lease', 'JLGServiceVisit-M00813-14-04-2025.pdf', 'lease/JLGServiceVisit-M00813-14-04-2025.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('8ff6cec7-56a0-4e87-ab1a-a631daa00bc3', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'lease', 'REP-40343473-L1.pdf', 'lease/REP-40343473-L1.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('95f2718c-1ed5-4bb7-ae32-435d5f60117c', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'lease', 'JLGServiceVisit-M00813-13-05-2025.pdf', 'lease/JLGServiceVisit-M00813-13-05-2025.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('10696033-ba0f-478a-96f4-eedb6385971f', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'lease', 'Communal Cleaning-First Port.pdf', 'lease/Communal Cleaning-First Port.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('def0e0ea-cede-43d2-8992-5c756d250d46', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'lease', 'SC Health and Safety Product - Accredited 10072023.pdf', 'lease/SC Health and Safety Product - Accredited 10072023.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('ff589d47-8e37-4b61-8b94-071b67d80225', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'lease', 'Tenancy Schedule by Property.pdf', 'lease/Tenancy Schedule by Property.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('659b9265-88f4-4128-a3d5-ce6f253bbb4d', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'finance', 'Accounts YE 31.03.2022 32-34 Connaught Square MJP.pdf', 'finance/Accounts YE 31.03.2022 32-34 Connaught Square MJP.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('c8fd20f2-b4ae-48bb-a595-d76931f1a19e', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'finance', '197-YE 31.03.22 SC Accs FINAL MAY 2023.pdf', 'finance/197-YE 31.03.22 SC Accs FINAL MAY 2023.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('d1bbbe3d-e1d4-4db0-a53e-191571bcb43a', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'finance', 'ACCOUNTS - YE 31.03.21 - Service Charge Accounts (1).pdf', 'finance/ACCOUNTS - YE 31.03.21 - Service Charge Accounts (1).pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('c4e2cd8f-f40f-492e-aa4b-df60d39e2fb1', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'finance', '27039 Accounts Pack - YE 2023.pdf', 'finance/27039 Accounts Pack - YE 2023.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('6e142c5a-3eb7-4bbe-9f51-e314adeabef8', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'finance', 'Connaught Sq SC YE 23.pdf', 'finance/Connaught Sq SC YE 23.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('d4b51e67-e2d4-4465-b042-66f499ee6b55', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'lease', 'Connaught Square-House Rules.docx', 'lease/Connaught Square-House Rules.docx');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('acdea426-34fc-442e-817a-8b326b1bca33', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'correspondence', 'Garden Notice-Connaught Square.docx', 'correspondence/Garden Notice-Connaught Square.docx');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('73b49ed4-eaf6-4473-b064-d83ebd9f5b48', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'correspondence', 'Connaught Square-Key Cut Authorisation Letter.docx', 'correspondence/Connaught Square-Key Cut Authorisation Letter.docx');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('b2be811d-b6fc-4c46-bcd7-d15b938de7bd', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'lease', 'House Rules-Connaught Square.pdf', 'lease/House Rules-Connaught Square.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('a9227bec-5a1e-4aff-a35c-a98a91f3ba38', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'lease', 'REP-39659654.pdf', 'lease/REP-39659654.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('b8e83659-8624-4a82-8d4a-e01778b124db', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'lease', 'Important Information .pdf', 'lease/Important Information .pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('f42e7537-918a-4479-b512-ade63c1d5df7', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'lease', 'StG_Certificate_32-34 Connaught Square W2 2HL.pdf', 'lease/StG_Certificate_32-34 Connaught Square W2 2HL.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('db489188-7ced-4353-b4e0-3bedecd5f5ac', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'contracts', 'CM434.AnnualServiceAgreement2025-2026.pdf', 'contracts/CM434.AnnualServiceAgreement2025-2026.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('72591bdf-fcc7-4fca-909b-9e8c8314d721', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'contracts', 'CM434.AnnualServiceAgreement2024-2025.pdf', 'contracts/CM434.AnnualServiceAgreement2024-2025.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('361eb1a5-b0d8-4cf0-9c1e-ee76263c5e56', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'lease', 'REP-40324834-E3.pdf', 'lease/REP-40324834-E3.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('91e6b171-4547-4d3c-9640-a41bc9c1bd84', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'lease', 'Ellie@mihproperty.co.uk - BES Group - E-Report.pdf', 'lease/Ellie@mihproperty.co.uk - BES Group - E-Report.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('1685d822-6f4f-4c76-9225-ffb0339e1c7a', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'lease', 'Jobcard_For_Job_No_38609_26-08-2025_0741.pdf', 'lease/Jobcard_For_Job_No_38609_26-08-2025_0741.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('1f33e8f4-353d-4933-ad92-5060f5d78ac1', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'lease', 'Jobcard_For_Job_No_28737_25-11-2024_0907.pdf', 'lease/Jobcard_For_Job_No_28737_25-11-2024_0907.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('c83d5933-578d-4ec8-90e4-51ba2dc1fb9d', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'lease', 'Jobcard_For_Job_No_35402_03-06-2025_0916.pdf', 'lease/Jobcard_For_Job_No_35402_03-06-2025_0916.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('6ff7a862-e988-4819-9c0e-e16bcc2aafdb', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'lease', 'Jobcard_For_Job_No_35654_03-06-2025_0911.pdf', 'lease/Jobcard_For_Job_No_35654_03-06-2025_0911.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('12324754-3b83-4505-9904-f8be569c4094', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'lease', 'Jobcard_For_Job_No_37675_25-07-2025_1549.pdf', 'lease/Jobcard_For_Job_No_37675_25-07-2025_1549.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('c02dacb1-9617-4dec-a368-61ad13b0c47b', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'lease', 'Jobcard_For_Job_No_35146_03-06-2025_0906.pdf', 'lease/Jobcard_For_Job_No_35146_03-06-2025_0906.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('b20ea4fa-0608-4c87-b864-5d8beea441f6', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'lease', 'Jobcard_For_Job_No_31162_30-01-2025_1602.pdf', 'lease/Jobcard_For_Job_No_31162_30-01-2025_1602.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('e2d3ad71-9436-454b-a01a-ecc45abbea19', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'lease', 'Jobcard_For_Job_No_36465_20-06-2025_1037.pdf', 'lease/Jobcard_For_Job_No_36465_20-06-2025_1037.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path, entity_type, linked_entity_id) VALUES ('5ce11d0a-d1ab-4c67-aea2-a0cb400a9318', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'finance', 'connaught apportionment.xlsx', 'finance/connaught apportionment.xlsx', 'budget', '163ec0a0-279b-4958-82a9-86bf2cb1c36b');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path, entity_type, linked_entity_id) VALUES ('6dee7a03-45d7-4b86-8ec8-102a682db615', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'finance', 'ACCOUNTS - YE 31.03.21 - Service Charge Accounts.pdf', 'finance/ACCOUNTS - YE 31.03.21 - Service Charge Accounts.pdf', 'budget', '546005ce-a8d9-4b03-93ce-16292c038405');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path, entity_type, linked_entity_id) VALUES ('95775d01-07bc-4491-a97d-15480bd18a23', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'finance', 'Connaught Square Budget 2025-6 Draft.xlsx', 'finance/Connaught Square Budget 2025-6 Draft.xlsx', 'budget', 'b4c87a04-e65d-47fd-bbf6-93b6cf1ad42e');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path, entity_type, linked_entity_id) VALUES ('7dd76afe-cdb2-41a2-8e4b-430bb5dc392c', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'finance', 'Connaught Square Budget 2025-Final.pdf', 'finance/Connaught Square Budget 2025-Final.pdf', 'budget', '3b5e1c2d-4d8b-42a5-96db-551f51d30d05');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path, entity_type, linked_entity_id) VALUES ('f6f3cc6e-83b9-4614-beca-b2fdfe576b32', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'finance', 'Connaught Square Budget 2025-Final.xlsx', 'finance/Connaught Square Budget 2025-Final.xlsx', 'budget', '2d3c43c2-f37a-41d1-87d7-ad7f5d54f499');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path, entity_type, linked_entity_id) VALUES ('24cb74ee-2caa-41c0-b1f4-1fd1595351d5', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'finance', 'ACCOUNTS - YE 31.03.21 - Service Charge Accounts.pdf', 'finance/ACCOUNTS - YE 31.03.21 - Service Charge Accounts.pdf', 'budget', '07f6e0c8-2d2f-4701-9c9a-8b20e347d726');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path, entity_type, linked_entity_id) VALUES ('3725c053-d4fa-49c5-9e12-d48d8eab42b0', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'finance', 'Connaught Square YE 24 Accounts.pdf', 'finance/Connaught Square YE 24 Accounts.pdf', 'budget', '355a463a-6126-4730-879f-0f3f3aacd74b');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path, entity_type, linked_entity_id) VALUES ('e38b783f-efe2-4d0a-b78c-d1446fb7b0a4', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'compliance', '2024 Directors Meeting-Notes.docx', 'compliance/2024 Directors Meeting-Notes.docx', 'compliance_asset', '5ca83e99-40d9-48cf-8d35-c72f05b3ce94');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path, entity_type, linked_entity_id) VALUES ('59411c9b-8e1b-4275-9069-8306b91a1728', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'compliance', 'Fire Door (Communal) Inspection (11m +) (7).pdf', 'compliance/Fire Door (Communal) Inspection (11m +) (7).pdf', 'compliance_asset', 'df46879d-9224-4d5a-9c91-df8ebab00db9');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path, entity_type, linked_entity_id) VALUES ('7f3273bc-8823-43d2-ac56-5c376183e36d', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'compliance', 'Fire Door (Flats) Inspection (11m +) (13).pdf', 'compliance/Fire Door (Flats) Inspection (11m +) (13).pdf', 'compliance_asset', 'fad3292e-a57d-4c84-8f72-3a5967669012');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path, entity_type, linked_entity_id) VALUES ('1fe117b4-7faa-49a2-822c-763f7dd6f1a9', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'compliance', 'Fire Door (Flats) Inspection (11m +) (18).pdf', 'compliance/Fire Door (Flats) Inspection (11m +) (18).pdf', 'compliance_asset', 'db221dae-173b-4c18-81c9-20916654c5df');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path, entity_type, linked_entity_id) VALUES ('a737d45d-ef33-4325-b81e-f443d47bd97d', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'compliance', 'Fire Door (Flats) Inspection (11m +) (14).pdf', 'compliance/Fire Door (Flats) Inspection (11m +) (14).pdf', 'compliance_asset', 'bc41afeb-d85c-4970-87d3-9e53707c219f');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path, entity_type, linked_entity_id) VALUES ('d433066c-8581-431a-af6f-243bd1a307d6', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'compliance', 'EICR Cuanku 32-34 conaught square.pdf', 'compliance/EICR Cuanku 32-34 conaught square.pdf', 'compliance_asset', '1f22a32d-8f22-4295-b7f6-dbcef6f6263e');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path, entity_type, linked_entity_id) VALUES ('47c64596-ae63-459a-bed3-e0ff00e81f9b', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'compliance', 'Fire Door (Flats) Inspection (11m +) (15).pdf', 'compliance/Fire Door (Flats) Inspection (11m +) (15).pdf', 'compliance_asset', '2aa48fc6-af3c-4e62-bc1b-a8c740b9fd66');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path, entity_type, linked_entity_id) VALUES ('fa789d7c-b2d7-4529-adec-dcb2346db955', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'compliance', '221037_Fra1-L-394697-071223 32-34 Connaught Square_2024-01-02_163759 (1).pdf', 'compliance/221037_Fra1-L-394697-071223 32-34 Connaught Square_2024-01-02_163759 (1).pdf', 'compliance_asset', 'b71adc07-5192-4608-b672-33770344e9dc');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path, entity_type, linked_entity_id) VALUES ('34b1eb9c-18e8-43f9-bf82-8da8fdbcd2e8', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'compliance', 'Fire Door (Flats) Inspection (11m +) (19).pdf', 'compliance/Fire Door (Flats) Inspection (11m +) (19).pdf', 'compliance_asset', '66b930cd-f8fb-4c4d-b98f-095f0c603b5f');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path, entity_type, linked_entity_id) VALUES ('b19ccb4a-4c7c-4812-bfff-17e7123199ef', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'compliance', '001132-3234-Connaught-Square-London.pdf', 'compliance/001132-3234-Connaught-Square-London.pdf', 'compliance_asset', '247d2f1a-dae4-432a-bc23-5b16b230df9e');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path, entity_type, linked_entity_id) VALUES ('3da69ff8-152a-4ba6-b2f4-0dc093ae0362', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'compliance', '221038_Hsra1-L-394697-071223 32-34 Connaught Square_2024-01-02_163759 (1).pdf', 'compliance/221038_Hsra1-L-394697-071223 32-34 Connaught Square_2024-01-02_163759 (1).pdf', 'compliance_asset', '3ae9e695-9bc3-4a51-b439-9a09fdfaaa60');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path, entity_type, linked_entity_id) VALUES ('1d0d4f35-fa0f-4914-bc51-5472cf3241cd', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'compliance', 'TETRA - Asbestos Re-Inspection Survey 14.06.22.pdf', 'compliance/TETRA - Asbestos Re-Inspection Survey 14.06.22.pdf', 'compliance_asset', '7906df7a-13e9-44c1-88cd-f91487a58022');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path, entity_type, linked_entity_id) VALUES ('f736995a-f7b2-40d3-a5e5-d9647be72d13', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'compliance', 'Fire Door (Flats) Inspection (11m +) (16).pdf', 'compliance/Fire Door (Flats) Inspection (11m +) (16).pdf', 'compliance_asset', '00c3eedb-aaea-4d1e-b1f6-39aa0196ba65');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path, entity_type, linked_entity_id) VALUES ('db5a8d58-dd70-4bdd-9f8f-93a7e02479a0', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'compliance', 'Fire Door (Flats) Inspection (11m +) (17).pdf', 'compliance/Fire Door (Flats) Inspection (11m +) (17).pdf', 'compliance_asset', 'cdae0416-1de9-488b-8369-634d035f70f1');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path, entity_type, linked_entity_id) VALUES ('b7465425-5afd-47fd-8563-3eb3bbc5edcb', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'compliance', 'WHM Legionella Risk Assessment 07.06.22.pdf', 'compliance/WHM Legionella Risk Assessment 07.06.22.pdf', 'compliance_asset', '57c990a1-9aef-46a8-bfdc-3b19d84ab39e');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path, entity_type, linked_entity_id) VALUES ('06df0854-8bef-42f4-99b9-a6bdc4bb18ea', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'compliance', 'EICR Report Cunaku SATISFACTORY 2023 .pdf', 'compliance/EICR Report Cunaku SATISFACTORY 2023 .pdf', 'compliance_asset', '8d62c047-5e07-4635-b0ea-3b21265a061d');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path, entity_type, linked_entity_id) VALUES ('c5f8136e-330c-4acd-a15d-8001befe49d4', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'compliance', '2024 Directors Meeting-Notes.docx', 'compliance/2024 Directors Meeting-Notes.docx', 'compliance_asset', 'cd1539f6-1261-47cb-a0fd-18ec3f18b4b7');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path, entity_type, linked_entity_id) VALUES ('94161338-341a-4276-9bbf-91f46687c587', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'compliance', '001457-3234-Connaught-Square-London Certificate.pdf', 'compliance/001457-3234-Connaught-Square-London Certificate.pdf', 'compliance_asset', '56e62bfb-8644-46de-b8f0-7379b7c3b6a9');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path, entity_type, linked_entity_id) VALUES ('3df379dc-1a81-42e8-abc8-b832c6fb5791', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'compliance', 'TC0001V31 General Terms and Conditions.pdf', 'compliance/TC0001V31 General Terms and Conditions.pdf', 'compliance_asset', 'a3a26b20-969b-4618-bfcf-e78014bc3d0d');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path, entity_type, linked_entity_id) VALUES ('6b37c4b7-4f64-4c11-ab92-4c7b81389d21', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'compliance', 'Jobcard_For_Job_No_28992_24-01-2025_1545.pdf', 'compliance/Jobcard_For_Job_No_28992_24-01-2025_1545.pdf', 'compliance_asset', '73a91837-178a-462b-bcb5-fa91184ae482');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path, entity_type, linked_entity_id) VALUES ('cbc783f4-5c36-4f1c-a87c-a202dc2b0682', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'compliance', 'Connaught Square (32-34) - 09.12.24 LRA.pdf', 'compliance/Connaught Square (32-34) - 09.12.24 LRA.pdf', 'compliance_asset', 'edbd5680-76ad-4cbb-857d-a70f0765ab72');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path, entity_type, linked_entity_id) VALUES ('c1041220-88ce-4904-95cd-1fd9a44336f5', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'compliance', 'SC Certificate - 10072023.pdf', 'compliance/SC Certificate - 10072023.pdf', 'compliance_asset', '1a52dae6-9cd9-4fa6-8cd1-50d2d4bf5e6f');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path, entity_type, linked_entity_id) VALUES ('ba70f082-45d9-48d6-a90e-a809ddb1d56a', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'compliance', 'Fire Door (Communal) Inspection (11m +) (7).pdf', 'compliance/Fire Door (Communal) Inspection (11m +) (7).pdf', 'compliance_asset', 'eac9f41e-c213-4ce4-873a-4639c0da81dc');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path, entity_type, linked_entity_id) VALUES ('dc618b20-a047-40c7-bf4e-04cd09a81b32', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'compliance', 'Fire Door (Flats) Inspection (11m +) (13).pdf', 'compliance/Fire Door (Flats) Inspection (11m +) (13).pdf', 'compliance_asset', '02f13562-9c43-4982-826a-52185efdf40d');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path, entity_type, linked_entity_id) VALUES ('1df9bc75-41bd-48fd-b286-8f6d0218fc52', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'compliance', 'Fire Door (Flats) Inspection (11m +) (18).pdf', 'compliance/Fire Door (Flats) Inspection (11m +) (18).pdf', 'compliance_asset', '80cda00b-bb3f-49ad-b3ee-c62d3c4eff21');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path, entity_type, linked_entity_id) VALUES ('14d92746-22dc-49d8-84e3-603de5cde2f5', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'compliance', 'Fire Door (Flats) Inspection (11m +) (14).pdf', 'compliance/Fire Door (Flats) Inspection (11m +) (14).pdf', 'compliance_asset', '880a4890-25de-4a9e-92b9-40aee75e6fb3');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path, entity_type, linked_entity_id) VALUES ('53efb259-8682-4e30-b3f3-64f266f21eb9', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'compliance', 'Fire Door (Flats) Inspection (11m +) (15).pdf', 'compliance/Fire Door (Flats) Inspection (11m +) (15).pdf', 'compliance_asset', '2dacd6bf-cf23-474f-bb14-6c17e9c0d462');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path, entity_type, linked_entity_id) VALUES ('5f44dd27-f424-4374-82ed-47f41584b08f', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'compliance', 'Fire Door (Flats) Inspection (11m +) (19).pdf', 'compliance/Fire Door (Flats) Inspection (11m +) (19).pdf', 'compliance_asset', 'd0947519-7893-440f-ab53-ecfbc1e19831');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path, entity_type, linked_entity_id) VALUES ('49877fbc-b29a-4694-a420-a1b07ee61b01', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'compliance', 'Fire Door (Flats) Inspection (11m +) (16).pdf', 'compliance/Fire Door (Flats) Inspection (11m +) (16).pdf', 'compliance_asset', '2cc3402a-775a-453f-958c-33c6413e565a');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path, entity_type, linked_entity_id) VALUES ('43b39d58-aad5-4204-b992-413e6609edba', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'compliance', 'Fire Door (Flats) Inspection (11m +) (17).pdf', 'compliance/Fire Door (Flats) Inspection (11m +) (17).pdf', 'compliance_asset', 'f143e6bf-b107-4035-8612-1681197b67d3');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path, entity_type, linked_entity_id) VALUES ('590715f8-fa6e-49c9-b609-d43ce9418ee9', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'compliance', '221037_Fra1-L-394697-071223 32-34 Connaught Square_2024-01-02_163759.pdf', 'compliance/221037_Fra1-L-394697-071223 32-34 Connaught Square_2024-01-02_163759.pdf', 'compliance_asset', '26d8a580-5dce-4911-a8ac-3fd736b1bb24');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path, entity_type, linked_entity_id) VALUES ('d4498e9f-b456-4c77-a86c-b66c7426ecfa', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'compliance', 'Fire Door (Flats) Inspection (11m +) - 2024-01-24T120747.552.pdf', 'compliance/Fire Door (Flats) Inspection (11m +) - 2024-01-24T120747.552.pdf', 'compliance_asset', '7b32663e-056b-4578-899d-475cf57eedc7');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path, entity_type, linked_entity_id) VALUES ('f44cea37-fd58-4620-9c76-7d219cad0452', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'compliance', 'Connaught Square (32-34) - 15.11.23 (886) wa.pdf', 'compliance/Connaught Square (32-34) - 15.11.23 (886) wa.pdf', 'compliance_asset', 'a60d1042-102c-4f16-8e75-9b7015e98483');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path, entity_type, linked_entity_id) VALUES ('b248f90f-08a7-4a7c-8b6e-29a9b633e30b', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'compliance', 'Fire Door (Flats) Inspection (11m +) - 2024-01-24T120745.875.pdf', 'compliance/Fire Door (Flats) Inspection (11m +) - 2024-01-24T120745.875.pdf', 'compliance_asset', '5f4dfb92-2ae8-4b47-bcd0-6592c7613642');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path, entity_type, linked_entity_id) VALUES ('23cf5d54-add8-4423-a068-c8a71b252b53', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'compliance', 'Fire Door (Flats) Inspection (11m +) - 2024-01-24T120746.424.pdf', 'compliance/Fire Door (Flats) Inspection (11m +) - 2024-01-24T120746.424.pdf', 'compliance_asset', '06a414dd-a735-4b96-8a22-3f0cc6f686bf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path, entity_type, linked_entity_id) VALUES ('4713b6ad-effe-44fd-85c9-8b6022dcdb53', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'compliance', 'Fire Door (Communal) Inspection (11m +) - 2024-01-24T120743.986.pdf', 'compliance/Fire Door (Communal) Inspection (11m +) - 2024-01-24T120743.986.pdf', 'compliance_asset', 'dfe36e9f-c954-4a77-ae18-81ad457a2e22');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path, entity_type, linked_entity_id) VALUES ('7e4ad217-7a4a-4861-8be2-4336126a666d', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'compliance', 'Fire Door (Flats) Inspection (11m +) - 2024-01-24T120744.738.pdf', 'compliance/Fire Door (Flats) Inspection (11m +) - 2024-01-24T120744.738.pdf', 'compliance_asset', 'f2957112-a5c1-4b65-96e4-c0fb88db6172');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path, entity_type, linked_entity_id) VALUES ('c821d0f3-f45a-41ce-85b8-8a7289f795b3', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'compliance', 'Fire Door (Flats) Inspection (11m +) - 2024-01-24T120747.015.pdf', 'compliance/Fire Door (Flats) Inspection (11m +) - 2024-01-24T120747.015.pdf', 'compliance_asset', '1db76f63-fee8-425b-8f92-57ef59a55475');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path, entity_type, linked_entity_id) VALUES ('1a89f7c3-6a2b-4b03-98e8-08904e796743', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'compliance', '221038_Hsra1-L-394697-071223 32-34 Connaught Square_2024-01-02_163759.pdf', 'compliance/221038_Hsra1-L-394697-071223 32-34 Connaught Square_2024-01-02_163759.pdf', 'compliance_asset', '3152b66f-c1ff-4fa7-9499-d8ad04982166');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path, entity_type, linked_entity_id) VALUES ('2f218401-e713-42f6-b38b-77dc59fa91ec', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'compliance', 'Fire Door (Flats) Inspection (11m +) - 2024-01-24T120745.174.pdf', 'compliance/Fire Door (Flats) Inspection (11m +) - 2024-01-24T120745.174.pdf', 'compliance_asset', '06d36d15-b0b3-4170-99d9-d2715caaf0c1');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path, entity_type, linked_entity_id) VALUES ('3e8044e6-cb8b-4e9a-a2a3-554f961cc61b', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'compliance', 'Hsfra1-L-422971-210225 32-34 Connaught Square.pdf', 'compliance/Hsfra1-L-422971-210225 32-34 Connaught Square.pdf', 'compliance_asset', 'df55713d-a74d-40f7-af42-efbe20fe972f');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path, entity_type, linked_entity_id) VALUES ('02e65cc0-deee-414c-a957-00c4d7c2982f', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'compliance', 'Hsfra1-L-422971-210225 32-34 Connaught Square.docx', 'compliance/Hsfra1-L-422971-210225 32-34 Connaught Square.docx', 'compliance_asset', '29a2946d-2bea-4c2e-be80-6fffa408d5a2');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path, entity_type, linked_entity_id) VALUES ('26936a1f-eb6a-4f90-94f9-833f55712b55', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'compliance', '221037_Fra1-L-394697-071223 32-34 Connaught Square_2024-01-02_163759 (1).pdf', 'compliance/221037_Fra1-L-394697-071223 32-34 Connaught Square_2024-01-02_163759 (1).pdf', 'compliance_asset', '40419323-f51c-489d-bfad-4943c4132056');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path, entity_type, linked_entity_id) VALUES ('fd8a4054-4e0c-4680-9507-53ad07fac6c9', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'compliance', '221038_Hsra1-L-394697-071223 32-34 Connaught Square_2024-01-02_163759 (1).pdf', 'compliance/221038_Hsra1-L-394697-071223 32-34 Connaught Square_2024-01-02_163759 (1).pdf', 'compliance_asset', '1782f2c8-4696-4290-b982-a8446ce55aa2');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path, entity_type, linked_entity_id) VALUES ('bd26c6b1-6947-434c-91ba-17f7d909086c', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'compliance', 'FRA-Connaught Square Reccommendations.xlsx', 'compliance/FRA-Connaught Square Reccommendations.xlsx', 'compliance_asset', '8c317290-1a17-4d87-8335-f34380ccf626');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path, entity_type, linked_entity_id) VALUES ('6dc2857c-f4f8-499e-871f-922faf12dc2b', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'compliance', '001534-3234-Connaught-Square-London.pdf', 'compliance/001534-3234-Connaught-Square-London.pdf', 'compliance_asset', 'a0d3b8cb-bc05-479d-b090-fe3fe1c7f7d3');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path, entity_type, linked_entity_id) VALUES ('ea02c83e-7b81-4171-b336-6a7349def0de', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'compliance', 'C1047 - Job card.pdf', 'compliance/C1047 - Job card.pdf', 'compliance_asset', '9924adfe-a5d4-46b9-a427-b8de70d78522');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path, entity_type, linked_entity_id) VALUES ('0f4cc106-1005-4a10-be12-10349186f031', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'compliance', 'WHM Legionella Risk Assessment 09.12.25.pdf', 'compliance/WHM Legionella Risk Assessment 09.12.25.pdf', 'compliance_asset', 'fa82ed27-f507-4420-9733-89e6f9a648fd');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path, entity_type, linked_entity_id) VALUES ('8f7ef18f-55e8-401b-abbb-60648265a424', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'compliance', 'WHM Legionella Risk Assessment 07.06.22.pdf', 'compliance/WHM Legionella Risk Assessment 07.06.22.pdf', 'compliance_asset', 'fc44604d-7b72-49fa-95a7-4283a9b26171');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path, entity_type, linked_entity_id) VALUES ('7047bae5-dc95-4ae4-add8-9e1edd9c4244', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'compliance', 'Connaught Square (32-34) - 29.05.25 (201) wa.pdf', 'compliance/Connaught Square (32-34) - 29.05.25 (201) wa.pdf', 'compliance_asset', '5f7ccbda-1c55-488c-b64d-4f782a8480b8');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path, entity_type, linked_entity_id) VALUES ('49ea66ca-86b2-49e4-ab29-4b42ce61ac6b', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'compliance', 'EICR Cuanku 32-34 conaught square.pdf', 'compliance/EICR Cuanku 32-34 conaught square.pdf', 'compliance_asset', '0cbf35d8-253c-476e-a74d-3f482fce02b8');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path, entity_type, linked_entity_id) VALUES ('5a46d897-3641-4630-8e14-95e4f3113fa9', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'compliance', 'EICR Report Cunaku SATISFACTORY 2023 .pdf', 'compliance/EICR Report Cunaku SATISFACTORY 2023 .pdf', 'compliance_asset', '1bbf46c2-0ec7-466a-b44a-fd877c42923c');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path, entity_type, linked_entity_id) VALUES ('947901af-a150-4365-a228-ec20adec31c2', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'compliance', '001132-3234-Connaught-Square-London.pdf', 'compliance/001132-3234-Connaught-Square-London.pdf', 'compliance_asset', '6858c1b4-47bc-4ecc-a043-41cabe1bba2d');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path, entity_type, linked_entity_id) VALUES ('a4597fc0-b5b1-4c22-80a1-b54846993462', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'compliance', '001534-3234-Connaught-Square-London.pdf', 'compliance/001534-3234-Connaught-Square-London.pdf', 'compliance_asset', 'c34c3526-78d7-40ac-93a4-f53ffdd76ba0');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path, entity_type, linked_entity_id) VALUES ('f724c49a-8db3-4f85-bdc5-15e702987759', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'compliance', 'FINAL L-432900 32-34 Connaught Square Management Survey Report Issue 1.pdf', 'compliance/FINAL L-432900 32-34 Connaught Square Management Survey Report Issue 1.pdf', 'compliance_asset', 'dd3a24eb-a4eb-4381-aa93-3d11d2dfd318');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path, entity_type, linked_entity_id) VALUES ('277a0ff1-0cec-4a13-8fbc-4778418ff647', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'compliance', 'TETRA - Asbestos Re-Inspection Survey 14.06.22.pdf', 'compliance/TETRA - Asbestos Re-Inspection Survey 14.06.22.pdf', 'compliance_asset', 'f5a8d6b0-8cc8-49c9-9f48-257c3100a8ca');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('53af03a4-0d34-43f6-8ccf-5da591302890', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'finance', 'British Gas Invoice-862451083.pdf', 'finance/British Gas Invoice-862451083.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('0299411f-61bb-4040-a8b6-4eb45ef6b3e5', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'contracts', 'Signed 2025 Connaught Square Management Agreement.docx.pdf', 'contracts/Signed 2025 Connaught Square Management Agreement.docx.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('c9092990-6c4b-4fe3-869e-faaca5ae4ac3', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'contracts', 'Connaught Square Management Agreement.docx', 'contracts/Connaught Square Management Agreement.docx');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('a6cd28d1-5a08-4b18-b8b6-b8e92fdb08b6', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'contracts', '2025 Connaught Square Management Agreement.docx', 'contracts/2025 Connaught Square Management Agreement.docx');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('80219d0e-2916-4bd0-82f2-dd2e4ae985d7', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'contracts', 'Signed Connaught Square Management Agreement.pdf', 'contracts/Signed Connaught Square Management Agreement.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('b0f33578-7497-494b-8586-844d22a88c8a', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'contracts', 'Contractors list.xlsx', 'contracts/Contractors list.xlsx');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('9c0435d8-77f2-45b2-bc7a-59373cb01c10', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'contracts', 'Contractors list.xlsx', 'contracts/Contractors list.xlsx');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('976591a6-6d34-4151-b665-b5ce38688997', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'contracts', 'EMERGENCY CALL OUT DETAILS 2024.pdf', 'contracts/EMERGENCY CALL OUT DETAILS 2024.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('74589a65-8a9a-4279-a3d1-6ea33b089c95', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'contracts', 'CM434.PRO 2024-2025.pdf', 'contracts/CM434.PRO 2024-2025.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('83b10dcf-2e2e-44c9-bba9-642b82e68e96', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'contracts', 'CM434.PRO.pdf', 'contracts/CM434.PRO.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('4a391acb-e62d-4dd6-b9ca-e68f87bde9a8', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'contracts', 'Gas Contract 24-5.pdf', 'contracts/Gas Contract 24-5.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('062c6e08-f337-421b-9079-698307d4f6d4', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'contracts', 'Contract_10-03-2025.pdf', 'contracts/Contract_10-03-2025.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('40ed5c24-0244-4347-9838-b08c854f4145', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'contracts', 'Gas Contract 25-26.pdf', 'contracts/Gas Contract 25-26.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('b8d17614-77d9-4f8c-991f-dc884f472944', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'correspondence', 'Welcome Letter - CG1885574.pdf', 'correspondence/Welcome Letter - CG1885574.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('fbd7726a-2b38-46bd-9db9-823783ccbcec', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'contracts', 'Job 67141.pdf', 'contracts/Job 67141.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('8e9b62e6-13d2-4f87-a4ac-4881ca09b0f0', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'contracts', 'BLENHEIMS, 32-34 CONNAUGHT, W2 2HL - 19.05.23.pdf', 'contracts/BLENHEIMS, 32-34 CONNAUGHT, W2 2HL - 19.05.23.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('771b53b3-853f-4ca0-9a81-ce478b028be8', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'contracts', 'BLENHEIMS, 32-34 CONNAUGHT, W2 2HL - 22.03.23.pdf', 'contracts/BLENHEIMS, 32-34 CONNAUGHT, W2 2HL - 22.03.23.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('4bc6e8e4-3474-4da4-baa1-d695559c8ed1', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'contracts', 'BLENHEIMS, 32-34 CONNAUGHT, W2 2HL - 26.06.23.pdf', 'contracts/BLENHEIMS, 32-34 CONNAUGHT, W2 2HL - 26.06.23.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('de2fe0d4-48cd-4402-b71a-cda532a17c92', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'contracts', 'BLENHEIMS, 32-34 CONNAUGHT, W2 2HL - 19.05.23.pdf', 'contracts/BLENHEIMS, 32-34 CONNAUGHT, W2 2HL - 19.05.23.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('4dc31a54-fdf2-45c0-8821-3170bdc0052c', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'contracts', 'BLENHEIMS, 32-34 CONNAUGHT, W2 2HL - 22.03.23.pdf', 'contracts/BLENHEIMS, 32-34 CONNAUGHT, W2 2HL - 22.03.23.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('e11560ef-a18d-4a94-aaa6-14f4f358df86', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'contracts', 'BLENHEIMS, 32-34 CONNAUGHT, W2 2HL - 26.06.23.pdf', 'contracts/BLENHEIMS, 32-34 CONNAUGHT, W2 2HL - 26.06.23.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('bc5f6eac-c67d-49f7-a711-855d3455fe1c', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'contracts', 'Jobcard_For_Job_No_27067_07-10-2024_1147.pdf', 'contracts/Jobcard_For_Job_No_27067_07-10-2024_1147.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('d677a329-d4b3-4b40-837d-fb99debf2932', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'contracts', 'Jobcard_For_Job_No_19665_28-03-2024_0936.pdf', 'contracts/Jobcard_For_Job_No_19665_28-03-2024_0936.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('e1cda065-a5b8-4d7b-be91-41015ebee68e', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'contracts', 'Jobcard_For_Job_No_22634_03-07-2024_1649.pdf', 'contracts/Jobcard_For_Job_No_22634_03-07-2024_1649.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('0f6eb13d-3836-42cd-b3f3-e983707857b6', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'contracts', 'Jobcard_For_Job_No_25732_03-10-2024_1337.pdf', 'contracts/Jobcard_For_Job_No_25732_03-10-2024_1337.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('44cea0fe-af44-434b-ba4a-09316cebf416', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'contracts', 'Lift Contract-Jacksons lift.pdf', 'contracts/Lift Contract-Jacksons lift.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('f360fa56-546e-453a-bc3f-a9b1bba9c86c', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'contracts', 'JLGCalloutVisit-5455045-12-07-2024.pdf', 'contracts/JLGCalloutVisit-5455045-12-07-2024.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('8eace9ee-7eb3-4c2d-b6e7-a8eba6bda9b1', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'contracts', 'JLGCalloutVisit-5483206-26-10-2024.pdf', 'contracts/JLGCalloutVisit-5483206-26-10-2024.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('10b4ef63-1b24-4384-b21c-a4a8a87febb2', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'contracts', 'JLGCalloutVisit-5498439-16-12-2024.pdf', 'contracts/JLGCalloutVisit-5498439-16-12-2024.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('f4b8380c-b4fa-45b8-b916-cbd43d47852a', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'contracts', 'JLGCalloutVisit-5455462-16-07-2024.pdf', 'contracts/JLGCalloutVisit-5455462-16-07-2024.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('dc3dd414-c39d-4766-9b63-9f5f12daf281', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'contracts', 'JLGCalloutVisit-5497480-13-12-2024.pdf', 'contracts/JLGCalloutVisit-5497480-13-12-2024.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('5d464a29-cc10-42bb-a752-a26566770f3b', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'contracts', 'Engineering Report - 32-34 CONNAUGHT SQUARE.pdf', 'contracts/Engineering Report - 32-34 CONNAUGHT SQUARE.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('2311b374-d7af-4b16-a32a-1dc5ef3aca6f', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'contracts', 'Arch Directors and Officers Liability Insurance for Residents Associations (12.22).pdf', 'contracts/Arch Directors and Officers Liability Insurance for Residents Associations (12.22).pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('560f39fe-4d6f-4129-a977-3a47d5b07fa7', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'contracts', 'StG_Policy Wording_32-34 Connaught Square W2 2HL.pdf', 'contracts/StG_Policy Wording_32-34 Connaught Square W2 2HL.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('f8f7a0e6-3757-46a7-ac8c-1acfcc3f193d', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'compliance', 'Fire Extinguisher Signed Contract- Connaught Square.pdf', 'compliance/Fire Extinguisher Signed Contract- Connaught Square.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('3877a6b9-d212-4335-a767-bca1a695a195', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'contracts', 'Q51691 - 32-34 Connaught Square Contract.pdf', 'contracts/Q51691 - 32-34 Connaught Square Contract.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('0b80fdaa-f408-4340-9de6-79b88edf5bda', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'contracts', 'Engineering Report - 32-34 CONNAUGHT SQUARE.pdf', 'contracts/Engineering Report - 32-34 CONNAUGHT SQUARE.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('38008678-76da-468e-964c-e3e08a2c3a4f', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'compliance', 'Fire Alarm+Emergency Lighting Signed Contract-3234 Connaught Square.pdf', 'compliance/Fire Alarm+Emergency Lighting Signed Contract-3234 Connaught Square.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('ac6d8fb5-8e96-44b5-be0e-58b9cd27b4f7', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'compliance', 'Fire Alarm+Emergency Lighting Contract Connaught Square.pdf', 'compliance/Fire Alarm+Emergency Lighting Contract Connaught Square.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('90140001-b4a0-4f20-bd4f-14341a590be5', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'contracts', 'BT3205 03072025.pdf', 'contracts/BT3205 03072025.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('41fd638f-c3ef-4fe1-b89e-cfcbaa81bee7', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'contracts', 'FA7817 SERVICE 08042025.pdf', 'contracts/FA7817 SERVICE 08042025.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('2c1c4b5d-d447-467f-be89-1c3c8c889edc', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'contracts', 'Engineer Report - 32-34 Connaught Square Flat 5.pdf', 'contracts/Engineer Report - 32-34 Connaught Square Flat 5.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('a8524805-b8cd-4c6d-8434-f3138aee70e5', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'contracts', 'Engineering Report - 32-34 CONNAUGHT SQUARE.pdf', 'contracts/Engineering Report - 32-34 CONNAUGHT SQUARE.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('4a07ecef-e4a9-4a14-89f2-82fd947ca1b5', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'contracts', 'Jobcard_For_Job_No_22171_14-05-2024_1202.pdf', 'contracts/Jobcard_For_Job_No_22171_14-05-2024_1202.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('ab79bc43-20d3-4f2d-bc7d-80e994310ffe', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'finance', 'British Gas Invoice-862451083.pdf', 'finance/British Gas Invoice-862451083.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('92b8167a-fcec-4fe7-a101-e01ea4cb4d02', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'contracts', 'MT8825 03072025.pdf', 'contracts/MT8825 03072025.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('ccc8792b-4350-4729-9344-8d0e06e27c8e', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'contracts', 'January Monthly Test For EL-Connaught Square.pdf', 'contracts/January Monthly Test For EL-Connaught Square.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('0d374578-ed5b-4961-9fd1-d59ea13880a4', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'contracts', 'February Monthly Test For EL-Connaught Square.pdf', 'contracts/February Monthly Test For EL-Connaught Square.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path, entity_type, linked_entity_id) VALUES ('07cfa3f5-145e-4c2e-ad75-bef8be652391', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'major_works', 'External Decorations SOI - 28042025.docx', 'major_works/External Decorations SOI - 28042025.docx', 'major_works_project', '0ddb9bb7-348a-4636-b3fa-19267e0688e9');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path, entity_type, linked_entity_id) VALUES ('9e77b1f2-db93-4cb4-a562-4105f6235fd4', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'major_works', 'External Dec SOE 03072025.docx', 'major_works/External Dec SOE 03072025.docx', 'major_works_project', '994e8cc5-0c4a-4161-9bd8-edf52c0a0e4b');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path, entity_type, linked_entity_id) VALUES ('e6d61be7-66d9-4f52-8d43-fde72cfb6921', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'major_works', 'Notice of intention for lift.docx', 'major_works/Notice of intention for lift.docx', 'major_works_project', '1ca52d11-f6be-4317-9340-de3f3e98a337');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path, entity_type, linked_entity_id) VALUES ('dab27319-3a4e-4a96-a1a5-6132c3e9feb1', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'major_works', 'Connaught Square (32-34) - 09.12.24 Schematic.pdf', 'major_works/Connaught Square (32-34) - 09.12.24 Schematic.pdf', 'major_works_project', '35a9ab5a-0fdd-47ee-82f6-d02665e7adf1');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('7d943de5-7fdf-4291-bc91-056b1a33d3e6', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'compliance', 'CGBI3964546XB6-Cunaku Construction Ltd-Business-Certificate of insurance.pdf', 'compliance/CGBI3964546XB6-Cunaku Construction Ltd-Business-Certificate of insurance.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('41d8a64d-1600-4057-80a6-630dd7aca9fc', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'compliance', 'CGBI3964546XB7-Cunaku Construction Ltd-Business-Certificate of insurance.pdf', 'compliance/CGBI3964546XB7-Cunaku Construction Ltd-Business-Certificate of insurance.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('5bb79dcd-72b1-4f6d-bbbe-0fc4531d93da', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'compliance', 'Real Estate Insurance NTP (01.23).pdf', 'compliance/Real Estate Insurance NTP (01.23).pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('b1bd1ae9-10a7-4225-806b-750c87092062', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'compliance', 'Real Estate Policy (01.23).pdf', 'compliance/Real Estate Policy (01.23).pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('19ce4f4e-f5a2-482e-aaf9-ac08ab186ea1', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'compliance', 'Summary of Cover (01.23).pdf', 'compliance/Summary of Cover (01.23).pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('f93be42c-e0a8-4c1b-91fb-79ecadbd97ae', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'compliance', '2023 Allianz VOC - 32-34 Connuaght Square (Freehold) Limited.pdf', 'compliance/2023 Allianz VOC - 32-34 Connuaght Square (Freehold) Limited.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('141fcb24-ffb5-404d-9dbe-8c5a8f045776', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'correspondence', '2023 Engineering Renewal Notice - 32 34 Connuaght Square (Freehold) Limited.pdf', 'correspondence/2023 Engineering Renewal Notice - 32 34 Connuaght Square (Freehold) Limited.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('4af48b9c-b805-40d9-90b6-4f0f4fcb501a', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'compliance', '32-34 Connaught Square Freehold Limited - Arch D&O Schedule.pdf', 'compliance/32-34 Connaught Square Freehold Limited - Arch D&O Schedule.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('e0b37e8d-22b5-41a5-92bd-42952df7a6d5', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'compliance', '32-34 Connaught Sq Buildings Insurance 2023-2024.pdf', 'compliance/32-34 Connaught Sq Buildings Insurance 2023-2024.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('2d7d7ad4-2da8-45d9-9c5f-d9626fdfa329', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'compliance', 'Policy Limits Document.pdf', 'compliance/Policy Limits Document.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('bd77a185-870f-4600-af2b-9b1df8dd742c', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'lease', 'Official Copy (Lease) 13.06.2003 - NGL823646-Flat 4.pdf', 'lease/Official Copy (Lease) 13.06.2003 - NGL823646-Flat 4.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('4a415f41-2c96-4930-b999-3d774fc6365e', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'correspondence', 'Letter of Authority - Connaught Square.doc.pdf', 'correspondence/Letter of Authority - Connaught Square.doc.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('0b089289-d9a0-41b9-bbfa-4bcc8014a4d5', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'correspondence', 'Letter to report - Connaught Square.doc.pdf', 'correspondence/Letter to report - Connaught Square.doc.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('f9ef4f58-ec67-4a55-878b-73e2570bcbf0', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'contracts', 'Pricing Quote - 32_34 Connaught Square Freehold Ltd - 109 - Gas - 10.03.2025.pdf', 'contracts/Pricing Quote - 32_34 Connaught Square Freehold Ltd - 109 - Gas - 10.03.2025.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('1d6995fa-4118-46b7-8864-256c3931ea78', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'compliance', 'Allianz - Lift Report 14.03.23.pdf', 'compliance/Allianz - Lift Report 14.03.23.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('ee99bc4b-3ec6-4821-b579-713f41d15da8', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'compliance', 'Allianz-Lift Report 18.03.2024.pdf', 'compliance/Allianz-Lift Report 18.03.2024.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('52bcd6be-1b3e-4014-a26f-5cdda48039e3', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'compliance', 'Allianz - Lift Report - 15.09.21.pdf', 'compliance/Allianz - Lift Report - 15.09.21.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('72b02347-de57-4b36-887a-d3f7899b309c', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'compliance', 'Allianz - Lift Report 27.09.23.pdf', 'compliance/Allianz - Lift Report 27.09.23.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('ff27de55-c79b-447d-bfaa-c31e98898c7f', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'compliance', 'Allianz - Lift Report 10.03.22.pdf', 'compliance/Allianz - Lift Report 10.03.22.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('c8d88c39-5309-43db-8f6e-d48550eb1f3d', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'compliance', 'Allianz - Lift Report 09.09.22.pdf', 'compliance/Allianz - Lift Report 09.09.22.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('3b003391-e46c-42c4-875f-50fdee27a7f9', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'compliance', 'LXBI3559280XB2-NEW STEP-Business-Certificate of insurance.pdf', 'compliance/LXBI3559280XB2-NEW STEP-Business-Certificate of insurance.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('5f8f4d5e-206e-4928-be49-db9c35ffbe6f', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'compliance', '2023 Allianz VOC - 32-34 Connuaght Square (Freehold) Limited.pdf', 'compliance/2023 Allianz VOC - 32-34 Connuaght Square (Freehold) Limited.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('ccc44f9f-93ad-4b1e-a1a6-b254c5dceb2c', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'correspondence', '2023 Engineering Renewal Notice - 32 34 Connuaght Square (Freehold) Limited.pdf', 'correspondence/2023 Engineering Renewal Notice - 32 34 Connuaght Square (Freehold) Limited.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('d3319a58-63f3-4221-96ae-9180936fb21d', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'compliance', 'MO - Policy Wording - NZ0411.pdf', 'compliance/MO - Policy Wording - NZ0411.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('644f06b6-b5c3-4b69-b29a-c98eaf81d7a0', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'compliance', 'Feature and Benefits of Allianz Engineering Inspection Service.pdf', 'compliance/Feature and Benefits of Allianz Engineering Inspection Service.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('8d5d40b3-240a-4496-ae2a-a675dcc1ad22', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'compliance', 'StG_Insurer pack_32-34 Connaught Square Freehold Limited.pdf', 'compliance/StG_Insurer pack_32-34 Connaught Square Freehold Limited.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('55c8a5c9-8903-4327-9653-c52c8c7f19d1', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'compliance', 'StG_Statement of Facts_32-34 Connaught Square W2 2HL.pdf', 'compliance/StG_Statement of Facts_32-34 Connaught Square W2 2HL.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('6321afc5-7ac7-4fdc-bd32-3a9284caf0cf', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'compliance', 'StG_Insurance Report_32-34 Connaught Square W2 2HL.pdf', 'compliance/StG_Insurance Report_32-34 Connaught Square W2 2HL.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('d56a530e-9c2b-4ec1-95ac-c5d01b820d75', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'compliance', 'StG_Insurer pack_32-34 Connaught Square Freehold Limited.pdf', 'compliance/StG_Insurer pack_32-34 Connaught Square Freehold Limited.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('12779d9d-dc4d-47cf-a3d6-1dd160fc7cb5', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'compliance', 'StG_Statement of Facts_32-34 Connaught Square W2 2HL.pdf', 'compliance/StG_Statement of Facts_32-34 Connaught Square W2 2HL.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('5e75747a-9bd3-485d-b6c8-4b391bf64cad', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'compliance', 'StG_Insurance Report_32-34 Connaught Square W2 2HL.pdf', 'compliance/StG_Insurance Report_32-34 Connaught Square W2 2HL.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('d260e829-a4d1-4611-aad9-c27810757661', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'finance', 'StG_Invoice_32-34 Connaught Square W2 2HL.pdf', 'finance/StG_Invoice_32-34 Connaught Square W2 2HL.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('62d2ca64-6081-4cbf-8f9d-a1b976c7384e', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'compliance', 'StG_Certificate_32-34 Connaught Square W2 2HL.pdf', 'compliance/StG_Certificate_32-34 Connaught Square W2 2HL.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('2b891f46-c106-4d1e-b91b-1dfe207032e1', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'compliance', 'StG_Insurer pack_32-34 Connaught Square Freehold Limited.pdf', 'compliance/StG_Insurer pack_32-34 Connaught Square Freehold Limited.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('8ee138cd-f705-4704-94a7-de44bba3bc66', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'compliance', 'StG_Statement of Fact_32-34 Connaught Square W2 2HL.pdf', 'compliance/StG_Statement of Fact_32-34 Connaught Square W2 2HL.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('dcdfd276-64c8-4ae5-b13b-f14ec7f6d6dd', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'finance', 'StG_Invoice_32-34 Connaught Square Freehold Limited.pdf', 'finance/StG_Invoice_32-34 Connaught Square Freehold Limited.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('7291b0d3-03c8-4210-8829-24d03d578b81', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'compliance', '32-34 Connaught Square Freehold Limited - Arch D&O Schedule.pdf', 'compliance/32-34 Connaught Square Freehold Limited - Arch D&O Schedule.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('f669b0b9-7a65-460b-8c8c-7ef0383a83a5', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'compliance', 'StG_Certificate_32-34 Connaught Square Freehold Limited.pdf', 'compliance/StG_Certificate_32-34 Connaught Square Freehold Limited.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('1694ce30-eb19-4251-9621-eea415cb50d2', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'compliance', 'StG_Policy Wording_32-34 Connaught Square Freehold Limited.pdf', 'compliance/StG_Policy Wording_32-34 Connaught Square Freehold Limited.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('e0f959ad-c54c-478a-87ef-809e16971e98', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'compliance', 'StG_D&O Endorsements_32-34 Connaught Square Freehold Limited.pdf', 'compliance/StG_D&O Endorsements_32-34 Connaught Square Freehold Limited.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('fa35c20c-2125-4751-b2ee-831d7d95dde7', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'finance', 'StG_Demands & Needs_32-34 Connaught Square Freehold Limited.pdf', 'finance/StG_Demands & Needs_32-34 Connaught Square Freehold Limited.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('a410510c-515b-4040-9cc8-755eb273ce90', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'contracts', 'StG_Quote_32-34 Connaught Square Freehold Limited.pdf', 'contracts/StG_Quote_32-34 Connaught Square Freehold Limited.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('5e18b1ec-4406-4b31-b766-5497245fe586', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'compliance', 'StG_Insurance Report_32-34 Connaught Square W2 2HL.pdf', 'compliance/StG_Insurance Report_32-34 Connaught Square W2 2HL.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('6775755a-af52-45f3-b0e2-0db4272a41c2', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'compliance', 'FBR113382303-20230405-B.pdf', 'compliance/FBR113382303-20230405-B.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('878cb6bf-80a5-4e8b-b75a-221ba63231fd', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'compliance', 'Real Estate Insurance NTP (01.23).pdf', 'compliance/Real Estate Insurance NTP (01.23).pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('a1fbb48b-ba6b-42fd-a9be-460b3d345737', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'compliance', 'Real Estate Policy (01.23).pdf', 'compliance/Real Estate Policy (01.23).pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('26fbc337-d24c-43c0-af4d-1a61b0624a72', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'compliance', 'Summary of Cover (01.23).pdf', 'compliance/Summary of Cover (01.23).pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('33f0ae89-08a6-43d9-b577-6a87b564de8e', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'compliance', '32-34 Connaught Sq Buildings Insurance 2023-2024.pdf', 'compliance/32-34 Connaught Sq Buildings Insurance 2023-2024.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('b246e5a1-3695-4105-a219-5476327dc194', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'compliance', 'Policy Limits Document.pdf', 'compliance/Policy Limits Document.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('534bb77e-d153-4482-8ee6-d57f0e077c55', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'compliance', 'Zurich Real Estate Policy Summary.pdf', 'compliance/Zurich Real Estate Policy Summary.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('4d1bafe4-dac6-4d02-94cc-cbfd7a4cf20d', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'compliance', 'Zurich Real Estate Policy Wording.pdf', 'compliance/Zurich Real Estate Policy Wording.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('9be4976c-7a8f-41e2-bb16-ab464504393c', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'compliance', 'Zurich Real Estate Insurance NTP (01.23) ZCYP895.02.pdf', 'compliance/Zurich Real Estate Insurance NTP (01.23) ZCYP895.02.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('8f690396-6605-4328-b712-182be018fcdb', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'finance', 'StG_Invoice_32-34 Connaught Square W2 2HL.pdf', 'finance/StG_Invoice_32-34 Connaught Square W2 2HL.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('87a3d1d1-794a-4f19-91d7-257f7c6d3a68', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'compliance', 'StG_Certificate_32-34 Connaught Square W2 2HL.pdf', 'compliance/StG_Certificate_32-34 Connaught Square W2 2HL.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('6a9a6325-0585-47e8-bda5-d5fe14afc505', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'compliance', 'StG_Supporting Docs_32-34 Connaught Square W2 2HL.pdf', 'compliance/StG_Supporting Docs_32-34 Connaught Square W2 2HL.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('36d5c023-b694-4fa9-82cd-176cdc7f74f4', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'finance', 'StG_Invoice_32-34 Connaught Square W2 2HL.pdf', 'finance/StG_Invoice_32-34 Connaught Square W2 2HL.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('d890b358-db50-4ae2-a22f-5cc94ab36003', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'compliance', 'StG_Certificate_32-34 Connaught Square W2 2HL.pdf', 'compliance/StG_Certificate_32-34 Connaught Square W2 2HL.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('41c4e552-fe3a-451c-8d7b-729ff7230868', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'compliance', 'StG_Statement of Fact_32-34 Connaught Square W2 2HL.pdf', 'compliance/StG_Statement of Fact_32-34 Connaught Square W2 2HL.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('cc28d1fa-0bff-4382-b217-02813e3875bf', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'finance', 'StG_Invoice_32-34 Connaught Square W2 2HL.pdf', 'finance/StG_Invoice_32-34 Connaught Square W2 2HL.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('f95a20d4-4504-4895-9d65-63e115fdbe98', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'compliance', 'StG_Statement of Fact_32-34 Connaught Square W2 2HL.pdf', 'compliance/StG_Statement of Fact_32-34 Connaught Square W2 2HL.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('4bfcbded-6aec-4436-87ee-8902453b9dc0', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'uncategorised', 'Connaught Square New property information.xlsx', 'uncategorised/Connaught Square New property information.xlsx');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('02ccd0e8-f72c-4bd1-aabe-a8359f490de4', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'uncategorised', 'Connaught Square Meeting Minutes 2.docx', 'uncategorised/Connaught Square Meeting Minutes 2.docx');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('0adf2423-60eb-462b-b2d3-35d9775b9c02', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'uncategorised', 'connaught.xlsx', 'uncategorised/connaught.xlsx');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('788cbe06-c963-48ae-adf7-819375e4e1af', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'uncategorised', 'matrix - pp.xlsx', 'uncategorised/matrix - pp.xlsx');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('a9794a6d-cbac-466e-81da-8f6078b67a81', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'uncategorised', '12. Change of Tenancy - EDF supporting document.docx', 'uncategorised/12. Change of Tenancy - EDF supporting document.docx');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('df9b1969-b800-40af-8129-ecc5a282e77b', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'correspondence', 'Correspondence letter.pdf', 'correspondence/Correspondence letter.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('5005eb95-c304-43a9-8c2d-c8a7193741f2', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'uncategorised', 'tenant list - pp.xlsx', 'uncategorised/tenant list - pp.xlsx');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('e6597141-fdb2-4e46-9042-09a22478c750', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'uncategorised', 'Report - 32-34 Connaught Square BCH 78350.pdf', 'uncategorised/Report - 32-34 Connaught Square BCH 78350.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('eed6d6f7-c407-49d5-96d3-d14a53b1c85c', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'uncategorised', 'Connaught Square Meeting Minutes 2.docx', 'uncategorised/Connaught Square Meeting Minutes 2.docx');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('e735b454-f45e-4fe3-abc6-94357fa611c5', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'uncategorised', 'Connaught Square Meeting Minutes 20241120.docx', 'uncategorised/Connaught Square Meeting Minutes 20241120.docx');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('79fcea77-bf33-4c79-b5c4-636d96ea2432', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'uncategorised', 'Connaught Square Meeting Minutes.docx', 'uncategorised/Connaught Square Meeting Minutes.docx');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('62a9c1c3-7e31-4dbf-87f5-dd5a34f788a5', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'uncategorised', 'Connaught Square Admin Duties of Co Sec.docx', 'uncategorised/Connaught Square Admin Duties of Co Sec.docx');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('36b45b11-6256-4f49-967e-459c9a66400e', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'uncategorised', 'Signed Connaught Square Admin Duties of Co Sec.pdf', 'uncategorised/Signed Connaught Square Admin Duties of Co Sec.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('0c9d923a-4e5c-4bd6-a455-73384c3a75f6', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'uncategorised', '32_34 CONNAUGHT SQUARE FREEHOLD LIMITED - Statutory Registers on 22.03.2024.pdf', 'uncategorised/32_34 CONNAUGHT SQUARE FREEHOLD LIMITED - Statutory Registers on 22.03.2024.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('4e396da7-8c63-4b33-9dc3-48bbecdbdd59', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'correspondence', 'Memorandum of Association.pdf', 'correspondence/Memorandum of Association.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('4c546288-f4a8-4c6f-8bfa-d0a79712650a', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'uncategorised', 'Incorporation documents.pdf', 'uncategorised/Incorporation documents.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('f5dcfde1-e662-443d-94a4-8709d12bab9a', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'uncategorised', 'B25676 RS 21.05.24 RM CM.pdf', 'uncategorised/B25676 RS 21.05.24 RM CM.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('b79e11ae-dfcc-46b8-8fd0-dab817fc3c8e', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'uncategorised', 'Report-20.08.2024.pdf', 'uncategorised/Report-20.08.2024.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('59648bb5-9c95-4270-8481-4a102ae3826c', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'correspondence', 'PN0119V1.7 Privacy Notice (Website).pdf', 'correspondence/PN0119V1.7 Privacy Notice (Website).pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('3b4ae4eb-17c5-45b2-b660-75c49cb1da69', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'correspondence', 'PN0119V1.8 Privacy Notice (Website).pdf', 'correspondence/PN0119V1.8 Privacy Notice (Website).pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('e84de078-16f0-4e14-9183-160554796c7b', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'uncategorised', 'REPORT 31-07-25.pdf', 'uncategorised/REPORT 31-07-25.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('d8b03f01-0a49-4469-b841-6417cf4c24de', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'uncategorised', '32-34 Connought Square Condtion Assessments.pdf', 'uncategorised/32-34 Connought Square Condtion Assessments.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('94986f2c-06c2-4c55-a85b-a5b0ac038257', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'uncategorised', 'Signed Conract.pdf', 'uncategorised/Signed Conract.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('a4dc31e6-b1d2-493a-b13d-b0f768b45de0', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'uncategorised', 'BLENHEIMS, CONNAUGHT, W2 2HL PHOTO - 22.01.24.pdf', 'uncategorised/BLENHEIMS, CONNAUGHT, W2 2HL PHOTO - 22.01.24.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('5679a8d0-7d51-41ff-8b0d-962a067ab213', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'uncategorised', 'BLENHEIMS, CONNAUGHT, W2 2HL PHOTO - 22.03.24.pdf', 'uncategorised/BLENHEIMS, CONNAUGHT, W2 2HL PHOTO - 22.03.24.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('52cd0b92-0283-40c4-95c7-373cabb7f05b', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'uncategorised', 'Latest Report.pdf', 'uncategorised/Latest Report.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('d401182f-e8de-4ea5-8e0d-0aa0b0936ac2', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'uncategorised', 'Latest Report 24.04.2024.pdf', 'uncategorised/Latest Report 24.04.2024.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('6ec6afed-e17c-4c26-b6bb-ec7c94dec689', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'uncategorised', 'Latest Report 19.09.2024.pdf', 'uncategorised/Latest Report 19.09.2024.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('6273a4d3-b9b9-4e97-9985-3f5dea4f6324', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'uncategorised', 'BLENHEIMS, 32-34 CONNAUGHT, W2 2HL - 25.09.23.pdf', 'uncategorised/BLENHEIMS, 32-34 CONNAUGHT, W2 2HL - 25.09.23.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('cff44eb3-cc36-42c6-8f22-3f70c2c4813f', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'uncategorised', 'BLENHEIMS, 32-34 CONNAUGHT, W2 2HL PHOTO - 29.11.23.pdf', 'uncategorised/BLENHEIMS, 32-34 CONNAUGHT, W2 2HL PHOTO - 29.11.23.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('7b037c44-4e97-44d7-9a9b-d0036d8a79bd', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'uncategorised', 'BLENHEIMS, 32-34 CONNAUGHT, W2 2HL PHOTO - 18.12.23.pdf', 'uncategorised/BLENHEIMS, 32-34 CONNAUGHT, W2 2HL PHOTO - 18.12.23.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('db6f8c83-c077-468e-9037-2bf652ed4f0f', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'uncategorised', 'BLENHEIMS, CONNAUGHT, W2 2HL PHOTO - 23.02.24.pdf', 'uncategorised/BLENHEIMS, CONNAUGHT, W2 2HL PHOTO - 23.02.24.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('6603ada1-7f21-4ccb-90d9-c052f468e6db', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'uncategorised', '10.02.25-Pest Control.pdf', 'uncategorised/10.02.25-Pest Control.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('7f0391f3-0559-4d2e-b31c-002d45fdf401', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'uncategorised', 'Latest Report.pdf', 'uncategorised/Latest Report.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('dd082d03-26f2-496a-a220-ad1733047c6a', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'uncategorised', '17.01.2025-Pest Control.pdf', 'uncategorised/17.01.2025-Pest Control.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('a3cda3ed-262a-4844-9411-b6c8200bee5d', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'uncategorised', 'J18503 - MIH, CONNAUGHT SQR, W2 - 04.04.25.pdf', 'uncategorised/J18503 - MIH, CONNAUGHT SQR, W2 - 04.04.25.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('7d0707d1-af9b-425f-97ff-4c2a77c80cc7', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'uncategorised', 'J18502 - MIH, CONNAUGHT SQR, W2 - 04.04.25.pdf', 'uncategorised/J18502 - MIH, CONNAUGHT SQR, W2 - 04.04.25.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('b73005bc-7dc0-4b55-9c22-b3dd7d89e6ae', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'uncategorised', 'BLENHEIMS, CONNAUGHT, W2 2HL PHOTO - 22.01.24.pdf', 'uncategorised/BLENHEIMS, CONNAUGHT, W2 2HL PHOTO - 22.01.24.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('25741741-1b10-477c-8ad7-e5a4ab3e2811', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'uncategorised', 'BLENHEIMS, CONNAUGHT, W2 2HL PHOTO - 22.03.24.pdf', 'uncategorised/BLENHEIMS, CONNAUGHT, W2 2HL PHOTO - 22.03.24.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('46572e6a-fd44-4434-a58a-0e6926217f50', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'uncategorised', 'BLENHEIMS, 32-34 CONNAUGHT, W2 2HL - 25.09.23.pdf', 'uncategorised/BLENHEIMS, 32-34 CONNAUGHT, W2 2HL - 25.09.23.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('94f51be3-ba75-44ff-9b5f-031faf687328', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'uncategorised', 'BLENHEIMS, 32-34 CONNAUGHT, W2 2HL PHOTO - 29.11.23.pdf', 'uncategorised/BLENHEIMS, 32-34 CONNAUGHT, W2 2HL PHOTO - 29.11.23.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('997cba2a-f3bf-4f84-b1ba-2599c97a70e4', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'uncategorised', 'BLENHEIMS, 32-34 CONNAUGHT, W2 2HL PHOTO - 18.12.23.pdf', 'uncategorised/BLENHEIMS, 32-34 CONNAUGHT, W2 2HL PHOTO - 18.12.23.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('f719f092-ad86-4b1c-a04c-e2ef548c7d52', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'uncategorised', 'BLENHEIMS, CONNAUGHT, W2 2HL PHOTO - 23.02.24.pdf', 'uncategorised/BLENHEIMS, CONNAUGHT, W2 2HL PHOTO - 23.02.24.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('6f0313b3-3b10-4f8c-88d9-631ddd2f0a1f', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'uncategorised', 'INV 11546 Mr Martin Samworth.xlsx', 'uncategorised/INV 11546 Mr Martin Samworth.xlsx');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('b008c4cb-897c-4a78-805e-f28daf7a57ce', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'uncategorised', 'QB4126 Mr Martin Samworth.docx', 'uncategorised/QB4126 Mr Martin Samworth.docx');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('a1a5839d-1702-4642-8ba7-48a8a3ea5abb', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'uncategorised', 'CQ2879 Mr Martin Samworth   (IP) CCTV.docx', 'uncategorised/CQ2879 Mr Martin Samworth   (IP) CCTV.docx');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('55040a91-8168-4b53-a316-bd323f476ae1', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'uncategorised', 'Asset_Record_For_Job_No_32810_17-03-2025_1311.pdf', 'uncategorised/Asset_Record_For_Job_No_32810_17-03-2025_1311.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('9e7b0410-c04f-4045-be4f-aba2d88bb528', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'uncategorised', 'Asset_Record_For_Job_No_32344_12-03-2025_1426.pdf', 'uncategorised/Asset_Record_For_Job_No_32344_12-03-2025_1426.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('e62e3790-52c6-46ff-a849-37ca1d893c2d', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'uncategorised', 'Asset_Record_For_Job_No_37675_25-07-2025_1549.pdf', 'uncategorised/Asset_Record_For_Job_No_37675_25-07-2025_1549.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('9b5591ee-4d65-4d08-a4bd-4c171cf3f2d4', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'uncategorised', 'Asset_Record_For_Job_No_34012_01-05-2025_1616.pdf', 'uncategorised/Asset_Record_For_Job_No_34012_01-05-2025_1616.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('c4f3e03a-e28b-4c36-b23c-a5525d701ca9', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'uncategorised', 'Asset_Record_For_Job_No_32759_17-03-2025_1147.pdf', 'uncategorised/Asset_Record_For_Job_No_32759_17-03-2025_1147.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('c35b07aa-c332-4cd5-afc8-1deee5e399ca', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'uncategorised', 'Jobcard_For_Job_No_32344_12-03-2025_1426.pdf', 'uncategorised/Jobcard_For_Job_No_32344_12-03-2025_1426.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('738b9070-7aac-41d9-b225-6a998fb6f50f', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'uncategorised', 'Asset_Record_For_Job_No_33844_07-04-2025_1143.pdf', 'uncategorised/Asset_Record_For_Job_No_33844_07-04-2025_1143.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('97c73e07-8ea3-4350-82cc-e5af12b96f20', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'uncategorised', 'Asset_Record_For_Job_No_25732_03-10-2024_1337.pdf', 'uncategorised/Asset_Record_For_Job_No_25732_03-10-2024_1337.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('117c46c1-a32e-4d9e-b2ad-cc30f2e3536f', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'uncategorised', 'Asset_Record_For_Job_No_22634_03-07-2024_1650.pdf', 'uncategorised/Asset_Record_For_Job_No_22634_03-07-2024_1650.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('29fc6040-d8e2-4bfc-bd9a-df650cd8aa50', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'uncategorised', 'Asset_Record_For_Job_No_27067_07-10-2024_1147.pdf', 'uncategorised/Asset_Record_For_Job_No_27067_07-10-2024_1147.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('c6c4579c-13b8-4463-bd6c-3ea97c5cc508', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'uncategorised', 'Asset_Record_For_Job_No_19665_05-04-2024_1048.pdf', 'uncategorised/Asset_Record_For_Job_No_19665_05-04-2024_1048.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('a2961442-1381-4397-8a74-6a49cdf75884', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'contracts', 'Connaught Square-Lift Quotes.xlsx', 'contracts/Connaught Square-Lift Quotes.xlsx');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('d53dead9-d551-4acf-9c2a-9a49a3aac10d', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'uncategorised', 'LXBI3559280XB2-NEW STEP-Business-Certificate of el insurance.pdf', 'uncategorised/LXBI3559280XB2-NEW STEP-Business-Certificate of el insurance.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('a4a22194-69a4-4977-9e83-f53a0aa99634', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'uncategorised', 'New Step - Cleaning of Com Part- Jan- 2023.pdf', 'uncategorised/New Step - Cleaning of Com Part- Jan- 2023.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('d1c6c487-ca06-481f-9a88-53f9f57e4136', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'uncategorised', 'Aged debtors by property.pdf', 'uncategorised/Aged debtors by property.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('2d3ee805-6e2d-4dd3-b1b9-f6b5b06fdbd6', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'uncategorised', 'Connaught Square, 32-34 Approved xlsx.xlsx', 'uncategorised/Connaught Square, 32-34 Approved xlsx.xlsx');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('5f8f8b99-2704-4d2c-a3b8-ae2d21c4511d', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'uncategorised', 'BvA 24 Jan 25.xlsx', 'uncategorised/BvA 24 Jan 25.xlsx');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('d90d3702-d275-4174-9e41-0d85ee00ab1e', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'uncategorised', 'pdf.pdf', 'uncategorised/pdf.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('360c3708-cd8b-4370-8b81-4ddb695cd798', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'uncategorised', 'Connaught Square-Agenda 20.11.24.docx', 'uncategorised/Connaught Square-Agenda 20.11.24.docx');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('a0521679-c398-4146-867a-fcf99a32e809', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'uncategorised', 'Connaught Square-Agenda 26.04.2024.docx', 'uncategorised/Connaught Square-Agenda 26.04.2024.docx');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('fd607946-1171-4007-ae57-0d3d4d9a0ac0', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'uncategorised', 'Connaught Square 26.04.24.docx', 'uncategorised/Connaught Square 26.04.24.docx');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('17ea1926-0730-4c3e-b7bd-8f097b4bce1a', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'contracts', 'StG_Quote_32-34 Connaught Square W2 2HL.pdf', 'contracts/StG_Quote_32-34 Connaught Square W2 2HL.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('f6463477-e62b-4324-8eee-1a239fd2ec5c', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'uncategorised', 'StG_Policy Wording_32-34 Connaught Square W2 2HL.pdf', 'uncategorised/StG_Policy Wording_32-34 Connaught Square W2 2HL.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('fe25318f-cefe-43df-82c4-ec68d8083ef2', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'contracts', 'StG_Quote_32-34 Connaught Square W2 2HL.pdf', 'contracts/StG_Quote_32-34 Connaught Square W2 2HL.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('59f2f020-93fe-43b7-99ab-3a2d03ad034d', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'uncategorised', 'StG_Policy Wording_32-34 Connaught Square W2 2HL.pdf', 'uncategorised/StG_Policy Wording_32-34 Connaught Square W2 2HL.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('b418b633-e37c-410c-a5f9-c3223ad9c5cd', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'uncategorised', 'Report - 32-34 Connaught Square BCH 78350.pdf', 'uncategorised/Report - 32-34 Connaught Square BCH 78350.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('9fe110ad-678a-4db2-a0fa-1e7cc2e88ca9', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'uncategorised', 'Asset_Record_For_Job_No_16617_27-11-2023_1522.pdf', 'uncategorised/Asset_Record_For_Job_No_16617_27-11-2023_1522.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('86e4a7c5-9d89-4134-b9dd-ea26d9ec61f9', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'uncategorised', 'Asset_Record_For_Job_No_16808_28-11-2023_1340.pdf', 'uncategorised/Asset_Record_For_Job_No_16808_28-11-2023_1340.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('2e7ce480-c831-4f19-acdb-bf3182c45591', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'uncategorised', 'EX-NC (CONNAUGHT SQUARE) EXTRA 01102024.pdf', 'uncategorised/EX-NC (CONNAUGHT SQUARE) EXTRA 01102024.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('6f17c455-5e08-482a-b3e4-5e6d8f45f147', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'uncategorised', 'H&S recomendations - Spreadsheet with comments.xlsx', 'uncategorised/H&S recomendations - Spreadsheet with comments.xlsx');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('18cd1c84-6331-45e2-8f40-261807d88006', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'uncategorised', 'CM434 RS 32-34 Connaught Square - VISIT 1 OF 2 - 30-04-25.pdf', 'uncategorised/CM434 RS 32-34 Connaught Square - VISIT 1 OF 2 - 30-04-25.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('60827528-8a4c-4d2b-85af-48a4d8aee36d', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'uncategorised', 'Q49511 - 32-34 Connaught Square.pdf', 'uncategorised/Q49511 - 32-34 Connaught Square.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('ec9badf6-9e8d-4451-b619-2f3f2f9cdfac', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'uncategorised', 'FA7817 CALL OUT 26032025.pdf', 'uncategorised/FA7817 CALL OUT 26032025.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('32df7122-0c9c-4a9c-af52-58c57a3f306f', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'uncategorised', '32 Connaught Sq - PAT .pdf', 'uncategorised/32 Connaught Sq - PAT .pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('71264fe0-b799-4e60-99f5-808967a9e203', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'uncategorised', 'Asset_Record_For_Job_No_35146_03-06-2025_0906.pdf', 'uncategorised/Asset_Record_For_Job_No_35146_03-06-2025_0906.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('4e29731f-d0ae-47dd-aa9e-5ce7ca2d2c0e', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'uncategorised', 'Asset_Record_For_Job_No_31162_30-01-2025_1603.pdf', 'uncategorised/Asset_Record_For_Job_No_31162_30-01-2025_1603.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('42ad7998-eed2-420a-a356-8f243310949d', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'uncategorised', 'Asset_Record_For_Job_No_37675_25-07-2025_1549.pdf', 'uncategorised/Asset_Record_For_Job_No_37675_25-07-2025_1549.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('ba4626c1-853b-4264-98bf-dc07bee339fe', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'uncategorised', 'Asset_Record_For_Job_No_28737_25-11-2024_0907.pdf', 'uncategorised/Asset_Record_For_Job_No_28737_25-11-2024_0907.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('5fea96c2-1d6c-4765-b172-860470a14143', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'uncategorised', 'Asset_Record_For_Job_No_35402_03-06-2025_0916.pdf', 'uncategorised/Asset_Record_For_Job_No_35402_03-06-2025_0916.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('1e921bc4-9ea6-4341-bdba-7d7de6a7780d', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'uncategorised', 'Asset_Record_For_Job_No_22171_14-05-2024_1202.pdf', 'uncategorised/Asset_Record_For_Job_No_22171_14-05-2024_1202.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('45d95f06-7153-4b46-8918-a4d3b96337fd', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'uncategorised', 'Asset_Record_For_Job_No_35654_03-06-2025_0912.pdf', 'uncategorised/Asset_Record_For_Job_No_35654_03-06-2025_0912.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('c0679584-38e3-416f-82ff-7d7821585e3c', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'uncategorised', 'Asset_Record_For_Job_No_38609_26-08-2025_0740.pdf', 'uncategorised/Asset_Record_For_Job_No_38609_26-08-2025_0740.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('78721d8e-c347-4557-82ec-6cc179b79c87', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'uncategorised', 'Asset_Record_For_Job_No_36465_20-06-2025_1038.pdf', 'uncategorised/Asset_Record_For_Job_No_36465_20-06-2025_1038.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('35863611-6729-4d49-85c4-54efec630841', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'uncategorised', '26368 Report.pdf', 'uncategorised/26368 Report.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('9ea0330d-3cd1-4654-b560-c07fe5bdee6f', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'uncategorised', '26474 Report.pdf', 'uncategorised/26474 Report.pdf');

-- Insert 26 apportionments
INSERT INTO apportionments (id, building_id, percentage) VALUES ('39aec80c-9ddb-4059-93e6-8d59b4580e67', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 32.0);
INSERT INTO apportionments (id, building_id, percentage) VALUES ('439d1fb1-0c02-4c0d-aaea-76ef94d248a9', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 10.0);
INSERT INTO apportionments (id, building_id, percentage) VALUES ('ad6b61c7-34ad-4b14-8df1-8e8ef15fa7b4', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 32.0);
INSERT INTO apportionments (id, building_id, percentage) VALUES ('8be0cc14-5ea7-403a-adc9-baa2c8822f5e', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 19.0);
INSERT INTO apportionments (id, building_id, percentage) VALUES ('0bab214a-c03c-43e8-850c-ec06c7d3173d', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 2.0);
INSERT INTO apportionments (id, building_id, percentage) VALUES ('c95b405b-3918-42bf-a538-4320bf979451', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 2.0);
INSERT INTO apportionments (id, building_id, percentage) VALUES ('cfedbd2a-3d22-44ae-9484-e3c084c4ca99', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 2.0);
INSERT INTO apportionments (id, building_id, percentage) VALUES ('47057865-d944-477a-944a-f42292a3eb7c', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 2.0);
INSERT INTO apportionments (id, building_id, percentage) VALUES ('9e5c9d74-5b30-491a-aca1-c0e6fbe0813f', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 2.0);
INSERT INTO apportionments (id, building_id, percentage) VALUES ('7af89073-2558-4ece-8829-17feb9f2bbbb', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 8.0);
INSERT INTO apportionments (id, building_id, percentage) VALUES ('965c7221-733f-45e8-a646-33256ecd5646', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 3.0);
INSERT INTO apportionments (id, building_id, percentage) VALUES ('bbe0aee7-f418-45c3-8c4c-af73d3afd17b', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 3.0);
INSERT INTO apportionments (id, building_id, percentage) VALUES ('fa5cbd0c-58b1-4c40-89f9-9d49826289b5', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 3.0);
INSERT INTO apportionments (id, building_id, percentage) VALUES ('d5a35929-88e8-43f2-8772-626d727daee0', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 3.0);
INSERT INTO apportionments (id, building_id, percentage) VALUES ('bae478f3-2898-4b30-81c2-065ebbc8bb2e', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 3.0);
INSERT INTO apportionments (id, building_id, percentage) VALUES ('f553b1f3-df51-4fd8-94a5-5f5462761888', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 3.0);
INSERT INTO apportionments (id, building_id, percentage) VALUES ('b65a136d-4c65-4fef-ac3e-59558c1921ef', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 3.0);
INSERT INTO apportionments (id, building_id, percentage) VALUES ('dbc60969-acd5-4333-9662-0d1f05244dd4', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 3.0);
INSERT INTO apportionments (id, building_id, percentage) VALUES ('cbf39610-4bb3-4c7e-82a9-4d1db9e84682', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 8.0);
INSERT INTO apportionments (id, building_id, percentage) VALUES ('a2ecbaea-d42b-4fea-b010-62f6d41033fb', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 3.0);
INSERT INTO apportionments (id, building_id, percentage) VALUES ('ab93d6d2-f0e6-47e1-a4b1-f56114ca43e4', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 8.0);
INSERT INTO apportionments (id, building_id, percentage) VALUES ('a4fb5868-f01b-4957-9c80-e0ae6339da55', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 8.0);
INSERT INTO apportionments (id, building_id, percentage) VALUES ('2c602bf2-478b-4036-9c56-aec9c1d02343', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 8.0);
INSERT INTO apportionments (id, building_id, percentage) VALUES ('5b30d3c7-207a-473a-91a4-c08efcb4f896', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 8.0);
INSERT INTO apportionments (id, building_id, percentage) VALUES ('dbb78521-c7f4-40ef-b169-85d4f2d6f6cd', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 8.0);
INSERT INTO apportionments (id, building_id, percentage) VALUES ('d8c5cc97-e3b4-482d-a30a-6ea991e5ec7c', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 8.0);

-- Insert 131 insurance records
INSERT INTO building_insurance (id, building_id, policy_number, insurance_type) VALUES ('105d32de-031d-4c77-a8b1-f829353647f0', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'CGBI3964546XB', 'general');
INSERT INTO building_insurance (id, building_id, policy_number, insurance_type) VALUES ('50254af0-4f0f-4d73-8de5-6c87db09615d', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'CGBI3964546XB', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('9eaaeba3-dbbf-4f68-876a-3972eca56488', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('fcb40945-21ae-45b0-8cba-47e3ffa21659', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('0495ed19-504f-48d6-93c1-7b6f5af9cde7', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'general');
INSERT INTO building_insurance (id, building_id, policy_number, insurance_type) VALUES ('32a78303-0115-4c08-b2d2-d189c1de187d', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'and', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('7100f4e1-1f08-4376-993a-cd6531a0ac1f', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('51026455-d515-4dc7-b05e-88548f7a9c94', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('444f9d06-1133-466c-8d0d-7dd127f3238d', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'general');
INSERT INTO building_insurance (id, building_id, policy_number, insurance_type) VALUES ('435af180-0073-4ba6-ab82-2fc1d8ff59e7', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'NZ23346712', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('50504da1-0640-4fc0-bb2e-8de72c538478', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('262052f1-77cb-4ae9-bb96-4148a5eb485a', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('b8a6b3d0-035a-4b6e-8cfc-c6dc9ee3d0aa', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('02e55aba-3e58-4855-a8a2-f35f7b9836ef', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('a1dd2876-1206-4106-971f-9343d82ef768', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'general');
INSERT INTO building_insurance (id, building_id, policy_number, insurance_type) VALUES ('d9086520-b79b-44b8-842a-b4666bf18a1c', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'ARCH', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('9baad7cf-cf40-4837-9891-722ee15b8f05', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('2813fea9-c102-47e0-8505-b60eda51f5ab', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('ed34c0e2-72df-4619-b0c0-b6653f1f4e15', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('1bceaf80-be7f-4e52-b16b-624bab5bbc97', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'general');
INSERT INTO building_insurance (id, building_id, policy_number, insurance_type) VALUES ('e7b7a203-7f7b-4076-bf41-4bfc32ed84c0', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'FU117816', 'general');
INSERT INTO building_insurance (id, building_id, policy_number, insurance_type) VALUES ('31881c0d-5661-4db2-a463-5551c3655396', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'FU117816', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('201ee038-9542-458f-aea3-47d33ea661a9', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('9b28409e-e91f-4b95-96f0-4ce82d3f3f62', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('ee6b6897-205a-4b7b-8a5f-ba69b692a13d', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('d5b3f03e-e796-4826-85e1-172ad77357a4', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('0b21d68a-4f28-4bee-a1d4-2fd2f006578b', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('4daa1bdb-8dd3-490a-8e22-d8a8ab44b122', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('9c6c9a9b-527f-4712-b036-ee35e762e414', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('de76b982-ea5b-4716-a661-f13804308c8e', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('72da8f63-9f20-48e7-95ea-429ff42cb62d', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('dbda4ca7-3a78-4c6f-baa5-2385589bc025', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('16008ed5-efab-431c-9659-f55858ee445f', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('8fa1574e-c035-4cf0-b5f7-30c572f662fb', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('a802cf5a-f3d0-46db-959e-b14ae5e565bf', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('acdf8163-e88f-4260-b0d8-783c52c36711', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('1c7a8c44-b5d0-40cc-b720-ea70ee7112af', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('79285c71-39ee-4569-9105-5ed4a27cbed4', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('a28ab950-b389-49c0-a883-2e3e356b47fe', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('9021086b-9c1e-47a3-b410-f16785c72ac0', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('d93c1061-95b7-45a7-9be3-e6e7255de8c6', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('ea8e79e6-dd3c-4ab4-b0ba-6e2d91ada130', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('428183d5-748d-44b6-98fe-459e3a83da26', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('355537f9-5c41-45a5-80e1-f93ba837842d', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('fd111086-6f68-4524-b7f0-7a09ace3dcfb', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('6be80abf-1c0e-40ac-aa6c-352815a003f8', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('2be46e7f-caaa-403d-a9ea-edc65173f590', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('62b9141a-8782-4ecd-bfbf-94aaa7ea4371', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('1fa620f3-5121-4048-8884-beb67af36ce4', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('12bc1c4e-7226-4ff9-9c79-ef474a949c42', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('a65313ab-158a-49ec-abd2-75f08629d5aa', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('3666d4f7-dce7-4336-9894-a05cdd872588', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('941a79ec-f2ae-4130-bb15-ab0ce3589774', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('167cabf1-ba73-4b54-be44-5ca9fa70533e', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('7762ffac-d45a-4b09-8422-730350dc2382', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'general');
INSERT INTO building_insurance (id, building_id, policy_number, insurance_type) VALUES ('7a87434f-dfcd-4776-9ff1-03bb3c2d92b4', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'LXBI3559280XB', 'general');
INSERT INTO building_insurance (id, building_id, policy_number, insurance_type) VALUES ('10149e66-823e-4520-8abd-484224339e12', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'LXBI3559280XB', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('79ede350-660e-4591-a5eb-370dcfa58558', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('823c67d2-989c-4052-9e97-19314059bfb0', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('c531a0e0-119c-48dd-b64b-ce7a4d70bee3', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('18e91993-78d8-4ae6-9da8-85da043fd2b4', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('cc2f47af-8584-442c-a787-abdb6445bae0', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('c5c9e10d-8a82-4932-80c4-378b03372f72', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('c6e4feff-1b9e-424a-8b1f-dca5a95c7a17', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('a89950a9-1410-4396-b37c-1008875f306d', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('950496d8-2dae-4d17-9781-593c2341dfcc', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('4c38ef18-f9ec-474c-813b-4ac8312000af', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'general');
INSERT INTO building_insurance (id, building_id, policy_number, insurance_type) VALUES ('1accccca-498f-44e6-a8c0-81a6f7dacad3', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'NZ23346712', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('ccfde659-99d5-41d3-9eda-5db2ede3142a', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'general');
INSERT INTO building_insurance (id, building_id, policy_number, insurance_type) VALUES ('d4ae39fb-5614-4bfa-a123-7e1dd0a1d291', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'and', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('0863b12c-5142-46a6-9041-361bbc0d73cf', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('d395bcf6-264c-482c-954a-501a6985fb42', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('7a824931-2ca1-42b7-976e-f56694eaf5a7', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('754073ff-a8fb-4ed6-b977-7bd045adea69', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'general');
INSERT INTO building_insurance (id, building_id, policy_number, insurance_type) VALUES ('0325d9fc-7479-4efe-9556-a44d2366a2a7', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'STGLON', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('184eb1aa-057d-4376-924f-8040f1ae85bd', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('8a145ce8-5622-4c0c-ad06-76e9a759f796', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'general');
INSERT INTO building_insurance (id, building_id, policy_number, insurance_type) VALUES ('eac1a619-c14d-4db6-bb73-b9ff36e671de', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'STGLON', 'general');
INSERT INTO building_insurance (id, building_id, policy_number, insurance_type) VALUES ('0d62a6c1-4cc8-4f35-a8af-6a5befb0435d', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'STGLON', 'general');
INSERT INTO building_insurance (id, building_id, policy_number, insurance_type) VALUES ('390d3968-96c6-43c9-8af9-928b8d50e54b', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'BERTSTGLON', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('c3aa0667-abfd-44bf-86a4-b30c953e77f3', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('0981ad7c-790f-4625-99ea-65a81b4d53bf', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'general');
INSERT INTO building_insurance (id, building_id, policy_number, insurance_type) VALUES ('ebdbacc7-5725-4fc5-8c48-b5be4c1a15eb', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'LP', 'general');
INSERT INTO building_insurance (id, building_id, policy_number, insurance_type) VALUES ('1e21524d-94aa-42f1-b5a1-c471d756d588', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'HL', 'general');
INSERT INTO building_insurance (id, building_id, policy_number, insurance_type) VALUES ('e3f06164-364b-42d4-b233-02e430f81c0a', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'ARCH', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('07523982-f1cc-4cbf-b6c6-843fc37797c9', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'general');
INSERT INTO building_insurance (id, building_id, policy_number, insurance_type) VALUES ('790a6dce-9d04-468d-97ba-0166210d5987', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'and', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('72195067-d3b0-4de5-a0ce-702f90d6f069', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('078e984b-aa1f-4e46-a56d-95b7e949c6d6', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('5ee711d3-7613-4d51-9d2f-032715860379', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('1a47e466-7647-458f-8d59-46f455341309', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('5d1a4f9f-6775-4f68-ad82-062cdd13275e', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('b06b43b4-1a9d-488e-a06a-4dbc8cfb4a9f', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'general');
INSERT INTO building_insurance (id, building_id, policy_number, insurance_type) VALUES ('2f08a5d1-7070-49a3-8326-48a4ef362f45', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'and', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('ccdc6aa3-f708-484e-b4cf-52ca430a7fb4', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('368f95bd-8237-4355-aa30-60bbbec5a6e4', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('5b9a6022-02fb-4373-a530-397c9a45e9d8', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('9ee5dc96-1132-4923-bd08-fea44549f4aa', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('ddbfa899-72e2-40f5-976f-b69b5774a6ea', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('8321aa34-9deb-4f82-82e3-bdacfd311de5', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'general');
INSERT INTO building_insurance (id, building_id, policy_number, insurance_type) VALUES ('fe974a95-c0db-4ad4-8d75-6c98411ce684', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'and', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('992bd29f-4c72-4084-9833-25a9e3747ea3', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'general');
INSERT INTO building_insurance (id, building_id, policy_number, insurance_type) VALUES ('7e3c2a26-0373-4728-8fe3-7152585251bf', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'BP13228-2501', 'general');
INSERT INTO building_insurance (id, building_id, policy_number, insurance_type) VALUES ('6f8a16ee-293b-4f52-aa5c-9449dd80d950', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'BP13228-2501', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('c3cd4298-2e98-4d6f-9488-ea7d105b68d1', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('19e19198-0b78-4075-9a59-b97d8c06edee', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'general');
INSERT INTO building_insurance (id, building_id, policy_number, insurance_type) VALUES ('1409fca9-e572-4b83-bd74-3b2184dcef6b', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'TA0604600', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('d363deca-bdc2-40af-9785-a1833bd86dc8', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('2ac3b1ff-9757-4284-a2b4-0d43013393c5', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'general');
INSERT INTO building_insurance (id, building_id, policy_number, insurance_type) VALUES ('a3115141-53ba-468c-93a8-846d47dca580', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'HL', 'general');
INSERT INTO building_insurance (id, building_id, policy_number, insurance_type) VALUES ('6d8f78f2-c102-4b72-a7d2-ccf264606bf8', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'Camberford', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('24f3cac7-967a-43ca-ad2e-d4f90727f4d6', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('ec710c94-4764-4ccb-9c44-0b419020da43', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('da4bcbfb-76a0-4fdf-9d1f-21f54e3828ab', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('3bf6cd24-b8b4-4ce2-ace9-fc9d9bece4a9', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('b3d3358f-2b5c-4b81-b6a6-bd52923c4ec9', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('f9671c80-ea32-4ba4-a14e-5a0ee9aff1bd', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('4abdd810-c01e-449b-93e2-b67530debd4a', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('26b5b271-4859-4dd1-927a-5a73efbee3f9', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('be5773cd-0ffe-495e-b538-f65f92feeccb', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('c33da688-089e-4002-809d-d8f78afd8ae9', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('7c65030c-65ba-4f8e-9fd4-7881582e81d2', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('894e4181-8b45-4176-837f-09031b820624', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('014628e7-722b-44b8-a0d8-d8ee99f22029', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('3d4ce620-fb8e-4b93-ad63-8abf7308e9f3', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('803cf99b-6a3b-4481-9aac-171724ce6b6e', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('13f2c2c6-770f-4539-a829-701c76fb32e4', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('7d5bbf9d-9e81-4e87-be04-6f0a12d85e03', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('dd7522f2-7d19-41a3-be5e-a69aa6a2fc5f', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('44355cc9-032e-46de-a2dc-65442ca26d71', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('e7d5747c-872c-45f8-ae95-e8c00d3cfa80', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'general');

-- ===========================
-- CONTRACTORS
-- ===========================

INSERT INTO contractors (id, name, phone, address) VALUES
('78a65025-86d6-4814-beae-d2be2889dc81', 'ISS', '083603538855', 'London, We''re available on Live Chat here., W1S 1RS')
ON CONFLICT (id) DO NOTHING;

INSERT INTO contractors (id, name, email, phone, address) VALUES
('d48f5e72-0d88-485f-bf2a-6945ed879bd6', 'Quotehedge', 'info@quotehedge-heating.co.uk', '07801 799118', '182 Revelstoke Road, Wandsworth, London, SW18 5NW')
ON CONFLICT (id) DO NOTHING;

INSERT INTO contractors (id, name, email, address) VALUES
('171764a1-fe95-4f9c-91ce-218fc0c75528', 'WHM', 'enquiries@whmltd.org', 'WATER HYGIENE MANAGEMENT L TD, 2 Churchill Court, Hortons Way,, Westerham, Kent, TN16 1BT')
ON CONFLICT (id) DO NOTHING;

INSERT INTO contractors (id, name, email, address) VALUES
('922ba560-a604-41f4-8368-e2462894d824', 'Capita', 'DPO@archinsurance.co.uk', 'f Arch Insurance (UK) Limited, Arch Insurance (UK) Limited, 5th Floor, 60 Great Tower Street, London EC3R 5AZ')
ON CONFLICT (id) DO NOTHING;


-- ===========================
-- BUILDING_CONTRACTORS
-- ===========================

INSERT INTO building_contractors (id, building_id, contractor_type)
VALUES ('d40524fd-84ae-470c-aca9-6dd238d9ef54', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'service_provider')
ON CONFLICT (id) DO NOTHING;

INSERT INTO building_contractors (id, building_id, contractor_type)
VALUES ('6b9a3bab-5e47-480b-8ded-00bedacd94fd', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'service_provider')
ON CONFLICT (id) DO NOTHING;

INSERT INTO building_contractors (id, building_id, contractor_type)
VALUES ('620a274b-776a-4483-b7e3-f4f41e9ee6d0', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'service_provider')
ON CONFLICT (id) DO NOTHING;

INSERT INTO building_contractors (id, building_id, contractor_type)
VALUES ('061cf4dc-9125-4008-a7dc-4a1060327b7b', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'service_provider')
ON CONFLICT (id) DO NOTHING;

INSERT INTO building_contractors (id, building_id, contractor_type)
VALUES ('97b24d90-66e3-45d5-bcd8-c1e5b15f4223', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'service_provider')
ON CONFLICT (id) DO NOTHING;

INSERT INTO building_contractors (id, building_id, contractor_type)
VALUES ('838a4d9a-f1e0-4133-af84-7f0849937164', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'service_provider')
ON CONFLICT (id) DO NOTHING;

INSERT INTO building_contractors (id, building_id, contractor_type)
VALUES ('833c01c5-a7e5-4e9d-aa7f-b3acac3173b8', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'service_provider')
ON CONFLICT (id) DO NOTHING;

INSERT INTO building_contractors (id, building_id, contractor_type)
VALUES ('e0ec172d-7671-4fcc-ae43-4d3c954cb8bb', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'service_provider')
ON CONFLICT (id) DO NOTHING;

INSERT INTO building_contractors (id, building_id, contractor_type)
VALUES ('88e5586b-f984-42a4-82b0-977e3618235e', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'service_provider')
ON CONFLICT (id) DO NOTHING;

INSERT INTO building_contractors (id, building_id, contractor_type)
VALUES ('494b75ed-dd02-4a63-ae03-6a29d3dbb8e0', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'service_provider')
ON CONFLICT (id) DO NOTHING;

INSERT INTO building_contractors (id, building_id, contractor_type)
VALUES ('ec1f6956-c43c-4b0e-b249-8a0cad9f318f', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'service_provider')
ON CONFLICT (id) DO NOTHING;

INSERT INTO building_contractors (id, building_id, contractor_type)
VALUES ('d0e1bfc1-2fe0-41aa-8fc0-06512abb25b5', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'service_provider')
ON CONFLICT (id) DO NOTHING;

INSERT INTO building_contractors (id, building_id, contractor_type)
VALUES ('5bbad5e0-ad29-4410-920b-ece57a49c0f3', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'service_provider')
ON CONFLICT (id) DO NOTHING;

INSERT INTO building_contractors (id, building_id, contractor_type)
VALUES ('24150a94-4e26-4d9c-a925-501ac97f1276', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'service_provider')
ON CONFLICT (id) DO NOTHING;

INSERT INTO building_contractors (id, building_id, contractor_type)
VALUES ('83f4b160-4273-4de6-b012-e7f0ae4b494e', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'service_provider')
ON CONFLICT (id) DO NOTHING;

INSERT INTO building_contractors (id, building_id, contractor_type)
VALUES ('266a043d-729b-41f4-bdb2-b6a4d783dcd2', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'service_provider')
ON CONFLICT (id) DO NOTHING;

INSERT INTO building_contractors (id, building_id, contractor_type)
VALUES ('8c3792f0-4d4e-4668-a68d-a5f68b2608bf', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'service_provider')
ON CONFLICT (id) DO NOTHING;

INSERT INTO building_contractors (id, building_id, contractor_type)
VALUES ('04f6b8c3-d0c5-42b4-b372-cc42bded100f', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'service_provider')
ON CONFLICT (id) DO NOTHING;

INSERT INTO building_contractors (id, building_id, contractor_type)
VALUES ('738739bc-3311-4cd5-889b-d917539ffe28', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'service_provider')
ON CONFLICT (id) DO NOTHING;

INSERT INTO building_contractors (id, building_id, contractor_type)
VALUES ('9b230909-6ec5-4982-aeb5-8896a2d0aef3', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'service_provider')
ON CONFLICT (id) DO NOTHING;

INSERT INTO building_contractors (id, building_id, contractor_type)
VALUES ('7ec6bcd7-72b5-466d-8727-d6adcb628dcb', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'service_provider')
ON CONFLICT (id) DO NOTHING;


-- Insert 214 assets
INSERT INTO assets (id, building_id, asset_type, asset_name, location_description, compliance_category, linked_documents) VALUES ('626bac30-5b00-4b3e-bdbf-a33f5ec594dc', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'fire_alarm', 'Fire Alarm Works', 'Works-Following from latest leak', 'fire_safety', ARRAY['2024 Directors Meeting-Notes.docx']);
INSERT INTO assets (id, building_id, asset_type, asset_name, location_description, compliance_category, linked_documents) VALUES ('c49ba702-4d55-43c3-9dcd-ac8f20ff2dda', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'lift', 'Lift Works', 'Works-Following from latest leak', 'lifts_safety', ARRAY['2024 Directors Meeting-Notes.docx']);
INSERT INTO assets (id, building_id, asset_type, asset_name, location_description, model_number, compliance_category, linked_documents) VALUES ('85d5b59b-83a6-45e5-8483-4faa86040813', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'boiler', 'Boiler Room', 'Basement', 'Fire', 'gas_safety', ARRAY['Fire Door (Communal) Inspection (11m +) (7).pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('058d16d6-12cf-458e-a855-5e2db340bd1d', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'fire_alarm', 'Fire Alarm A', 'fire_safety', ARRAY['EICR Cuanku 32-34 conaught square.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, location_description, compliance_category, linked_documents) VALUES ('2e11aabc-d5a2-473e-9260-f03f7b8cab4b', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'lift', 'LIFT SHAFT', 'CONTROL CIRCUITS', 'lifts_safety', ARRAY['EICR Cuanku 32-34 conaught square.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, model_number, compliance_category, linked_documents) VALUES ('db38025e-6f3f-4af1-917c-01e45939dfc6', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'lightning_protection', 'To lightning protection', 'B', 'electrical_safety', ARRAY['EICR Cuanku 32-34 conaught square.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('76c07985-0830-4f14-ba98-f3bccbb58aa8', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'generator', 'generators', 'electrical_safety', ARRAY['EICR Cuanku 32-34 conaught square.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, location_description, compliance_category, linked_documents) VALUES ('7a54000a-ccf3-4786-ae45-1810b4e4e413', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'boiler', 'Boiler room', 'terrace - lift', 'gas_safety', ARRAY['221037_Fra1-L-394697-071223 32-34 Connaught Square_2024-01-02_163759 (1).pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, location_description, condition_rating, compliance_category, linked_documents) VALUES ('bdf2d8a1-e8df-4d19-8984-616a79625d50', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'fire_alarm', 'Fire Alarm', 'in appropriate X Breaches to compartmentation observed', 'good', 'fire_safety', ARRAY['221037_Fra1-L-394697-071223 32-34 Connaught Square_2024-01-02_163759 (1).pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, location_description, compliance_category, linked_documents) VALUES ('69dae6ca-65ac-478d-b82a-55791c56ca5a', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'lift', 'lift
motor', 'terrace - lift', 'lifts_safety', ARRAY['221037_Fra1-L-394697-071223 32-34 Connaught Square_2024-01-02_163759 (1).pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, location_description, model_number, compliance_category, linked_documents) VALUES ('21049285-ed2d-4393-b297-52e4fa1a6eb0', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'door_entry', 'Intercom door entry', 'to 3rd floor', '1', 'security', ARRAY['221037_Fra1-L-394697-071223 32-34 Connaught Square_2024-01-02_163759 (1).pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('4f34ee89-dc73-4faf-8135-9ceb4de44ccc', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'emergency_lighting', 'emergency lighting present', 'fire_safety', ARRAY['221037_Fra1-L-394697-071223 32-34 Connaught Square_2024-01-02_163759 (1).pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('a9621722-6954-4aa2-ad4b-d062df41df0e', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'fire_extinguisher', 'fire extinguishers', 'fire_safety', ARRAY['221037_Fra1-L-394697-071223 32-34 Connaught Square_2024-01-02_163759 (1).pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, condition_rating, compliance_category, linked_documents) VALUES ('19e58f2f-550a-49b1-9bc1-4b949c490ea9', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'lightning_protection', 'Lightning protection available', 'good', 'electrical_safety', ARRAY['221037_Fra1-L-394697-071223 32-34 Connaught Square_2024-01-02_163759 (1).pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, location_description, model_number, condition_rating, compliance_category, linked_documents) VALUES ('990f1786-f50e-4ae3-9942-4dc37e4a5a03', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'boiler', 'Boiler Hanworthy', 'Condensing Boiler Hanworthy Purewell variheat m k2 110 21 Mbar 110 0', 'pressure', 'fair', 'gas_safety', ARRAY['001132-3234-Connaught-Square-London.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, location_description, compliance_category, linked_documents) VALUES ('508867fa-bd7f-4d45-9ab7-98aee71cc3f9', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'boiler', 'Boiler room', 'terrace - lift', 'gas_safety', ARRAY['221038_Hsra1-L-394697-071223 32-34 Connaught Square_2024-01-02_163759 (1).pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('e3f73e48-8f5b-41c6-944b-72a61cf11e5c', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'lift', 'LIFTS', 'lifts_safety', ARRAY['221038_Hsra1-L-394697-071223 32-34 Connaught Square_2024-01-02_163759 (1).pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('cc3e36d7-a860-47df-9c1e-969e34f0462a', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'cctv', 'CCTV equipment', 'security', ARRAY['221038_Hsra1-L-394697-071223 32-34 Connaught Square_2024-01-02_163759 (1).pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, location_description, compliance_category, linked_documents) VALUES ('4f83a7c4-1690-4bc2-aeb2-afe3b33e29fa', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'door_entry', 'Intercom door entry', 'to 3rd floor', 'security', ARRAY['221038_Hsra1-L-394697-071223 32-34 Connaught Square_2024-01-02_163759 (1).pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('459ba532-2a0a-4148-9b4e-c6444d479467', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'emergency_lighting', 'Emergency lighting provided', 'fire_safety', ARRAY['221038_Hsra1-L-394697-071223 32-34 Connaught Square_2024-01-02_163759 (1).pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('90a914eb-03e3-4c1f-a039-08422d80f153', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'water_tank', 'water storage tank', 'water_safety', ARRAY['221038_Hsra1-L-394697-071223 32-34 Connaught Square_2024-01-02_163759 (1).pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, location_description, compliance_category, linked_documents) VALUES ('7d6dd14b-c4d8-44bd-b68e-6d834364e434', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'boiler', 'Boiler Room', 'exits', 'gas_safety', ARRAY['TETRA - Asbestos Re-Inspection Survey 14.06.22.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, location_description, compliance_category, linked_documents) VALUES ('84fdfadd-8cf1-47ee-a3b0-d5452b6a6e2e', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'lift', 'Lift Motor', 'Description Assessment', 'lifts_safety', ARRAY['TETRA - Asbestos Re-Inspection Survey 14.06.22.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, location_description, compliance_category, linked_documents) VALUES ('b3140662-723f-438a-bf4c-fd63f7e58b76', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'pump', 'pumps', 'exits', 'water_safety', ARRAY['TETRA - Asbestos Re-Inspection Survey 14.06.22.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, model_number, compliance_category, linked_documents) VALUES ('9f2dbaa9-67ee-43fe-a369-8faf670a0538', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'boiler', 'Boilers', 'Total', 'gas_safety', ARRAY['WHM Legionella Risk Assessment 07.06.22.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('29e679e3-662c-42d6-8c73-fbfe5d8ba671', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'sprinkler', 'Sprinklers', 'fire_safety', ARRAY['WHM Legionella Risk Assessment 07.06.22.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('7fb635b6-e652-4bbd-8a4f-aefa633a1339', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'pump', 'pump is', 'water_safety', ARRAY['WHM Legionella Risk Assessment 07.06.22.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, service_frequency, compliance_category, linked_documents) VALUES ('cf7fd40b-504c-41ca-ab5a-ccc7b0074728', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'water_tank', 'water tanks', 'annually', 'water_safety', ARRAY['WHM Legionella Risk Assessment 07.06.22.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('b121d01e-25c2-48bb-90b5-dcdcc08f4458', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'fire_alarm', 'Fire Alarm A', 'fire_safety', ARRAY['EICR Report Cunaku SATISFACTORY 2023 .pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, location_description, compliance_category, linked_documents) VALUES ('f2fe20fb-bdd5-4ac4-80b3-002ebee8c391', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'lift', 'LIFT SHAFT', 'CONTROL CIRCUITS', 'lifts_safety', ARRAY['EICR Report Cunaku SATISFACTORY 2023 .pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, model_number, compliance_category, linked_documents) VALUES ('8f66fc63-5b7c-44af-bda0-17cbfb558f2f', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'lightning_protection', 'To lightning protection', 'B', 'electrical_safety', ARRAY['EICR Report Cunaku SATISFACTORY 2023 .pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('6f8458db-2c6f-4f3f-b3f1-a84e6eeffeda', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'generator', 'generators', 'electrical_safety', ARRAY['EICR Report Cunaku SATISFACTORY 2023 .pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, location_description, compliance_category, linked_documents) VALUES ('86af4bb5-7cb9-48e3-b50d-3fc030242337', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'fire_alarm', 'Fire Alarm Works', 'Works-Following from latest leak', 'fire_safety', ARRAY['2024 Directors Meeting-Notes.docx']);
INSERT INTO assets (id, building_id, asset_type, asset_name, location_description, compliance_category, linked_documents) VALUES ('f218cb38-a395-415a-9e99-c23e87e3ed38', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'lift', 'Lift Works', 'Works-Following from latest leak', 'lifts_safety', ARRAY['2024 Directors Meeting-Notes.docx']);
INSERT INTO assets (id, building_id, asset_type, asset_name, location_description, model_number, condition_rating, compliance_category, linked_documents) VALUES ('7a07facc-5d81-4bbc-94c9-73788247b31c', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'boiler', 'Boiler Hanworthy', 'Condensing Boiler Hanworthy Wessex modumaxO mFk2 110c 20 Mbar 1', 'pressure', 'fair', 'gas_safety', ARRAY['001457-3234-Connaught-Square-London Certificate.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, location_description, manufacturer, compliance_category, linked_documents) VALUES ('0669db1d-b712-47a3-b629-7353e7ef1f76', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'lift', 'lift to', 'of Commission is', 'Crown to the Customer', 'lifts_safety', ARRAY['TC0001V31 General Terms and Conditions.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, model_number, compliance_category, linked_documents) VALUES ('8bc3d53c-98e3-4e5b-aac3-8c18f582f1c3', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'boiler', 'Boilers', 'Total', 'gas_safety', ARRAY['Connaught Square (32-34) - 09.12.24 LRA.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('22478142-e7b6-4046-83d5-6ed6f900e5e3', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'sprinkler', 'Sprinklers', 'fire_safety', ARRAY['Connaught Square (32-34) - 09.12.24 LRA.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('71e97349-34d7-465b-9087-1877637c43a6', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'pump', 'pump is', 'water_safety', ARRAY['Connaught Square (32-34) - 09.12.24 LRA.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, service_frequency, compliance_category, linked_documents) VALUES ('538eec70-b330-4cb4-a90a-37480ef3a6bf', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'water_tank', 'water tanks', 'annually', 'water_safety', ARRAY['Connaught Square (32-34) - 09.12.24 LRA.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, location_description, model_number, compliance_category, linked_documents) VALUES ('d9f5dbf3-d09e-43c4-9940-a51df5d02888', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'boiler', 'Boiler Room', 'Basement', 'Fire', 'gas_safety', ARRAY['Fire Door (Communal) Inspection (11m +) (7).pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, location_description, compliance_category, linked_documents) VALUES ('b57afa70-e99a-4580-938d-8e95f905b633', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'boiler', 'Boiler room', 'terrace - lift', 'gas_safety', ARRAY['221037_Fra1-L-394697-071223 32-34 Connaught Square_2024-01-02_163759.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, location_description, condition_rating, compliance_category, linked_documents) VALUES ('caef87b3-4868-4e6a-b679-929648761c04', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'fire_alarm', 'Fire Alarm', 'in appropriate X Breaches to compartmentation observed', 'good', 'fire_safety', ARRAY['221037_Fra1-L-394697-071223 32-34 Connaught Square_2024-01-02_163759.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, location_description, compliance_category, linked_documents) VALUES ('bb2dace5-bcfa-40bc-9c8f-136c433d034e', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'lift', 'lift
motor', 'terrace - lift', 'lifts_safety', ARRAY['221037_Fra1-L-394697-071223 32-34 Connaught Square_2024-01-02_163759.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, location_description, model_number, compliance_category, linked_documents) VALUES ('2c0ca1c0-548c-4675-b579-e25c9606e2d3', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'door_entry', 'Intercom door entry', 'to 3rd floor', '1', 'security', ARRAY['221037_Fra1-L-394697-071223 32-34 Connaught Square_2024-01-02_163759.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('6bec865a-e186-4cc3-9e90-fa55f5d4f4c7', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'emergency_lighting', 'emergency lighting present', 'fire_safety', ARRAY['221037_Fra1-L-394697-071223 32-34 Connaught Square_2024-01-02_163759.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('58335ee9-252c-4983-afc2-f21a2cf9e815', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'fire_extinguisher', 'fire extinguishers', 'fire_safety', ARRAY['221037_Fra1-L-394697-071223 32-34 Connaught Square_2024-01-02_163759.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, condition_rating, compliance_category, linked_documents) VALUES ('653dfd48-d610-4a94-b8a1-acb5064f3672', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'lightning_protection', 'Lightning protection available', 'good', 'electrical_safety', ARRAY['221037_Fra1-L-394697-071223 32-34 Connaught Square_2024-01-02_163759.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, location_description, model_number, compliance_category, linked_documents) VALUES ('a1b09df8-c90f-41b8-b9b5-42244de755e8', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'boiler', 'Boiler Room', 'Basement', 'Fire', 'gas_safety', ARRAY['Fire Door (Communal) Inspection (11m +) - 2024-01-24T120743.986.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, location_description, compliance_category, linked_documents) VALUES ('c3ecce3e-8243-4773-b272-bfda9056c627', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'boiler', 'Boiler room', 'terrace - lift', 'gas_safety', ARRAY['221038_Hsra1-L-394697-071223 32-34 Connaught Square_2024-01-02_163759.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('4c6e6fda-2cf2-4a73-bc2b-0bc55aca5cbd', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'lift', 'LIFTS', 'lifts_safety', ARRAY['221038_Hsra1-L-394697-071223 32-34 Connaught Square_2024-01-02_163759.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('81309210-b82f-4f04-8787-4a463dba911d', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'cctv', 'CCTV equipment', 'security', ARRAY['221038_Hsra1-L-394697-071223 32-34 Connaught Square_2024-01-02_163759.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, location_description, compliance_category, linked_documents) VALUES ('c2382223-7b59-438d-8b94-a3daa29b6d44', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'door_entry', 'Intercom door entry', 'to 3rd floor', 'security', ARRAY['221038_Hsra1-L-394697-071223 32-34 Connaught Square_2024-01-02_163759.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('b0cf4eda-0c29-4ab1-84bd-3139b35abb6b', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'emergency_lighting', 'Emergency lighting provided', 'fire_safety', ARRAY['221038_Hsra1-L-394697-071223 32-34 Connaught Square_2024-01-02_163759.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('b844701a-1a48-401f-b087-d15b9fc6c0d1', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'water_tank', 'water storage tank', 'water_safety', ARRAY['221038_Hsra1-L-394697-071223 32-34 Connaught Square_2024-01-02_163759.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, location_description, compliance_category, linked_documents) VALUES ('f351beab-743e-44e1-9aec-3aa8aa08ce79', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'boiler', 'Boiler room', 'terrace - lift', 'gas_safety', ARRAY['Hsfra1-L-422971-210225 32-34 Connaught Square.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, location_description, condition_rating, compliance_category, linked_documents) VALUES ('f6baa89d-3ead-4ceb-9240-02611265a65c', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'fire_alarm', 'Fire Alarm', 'in appropriate X Breaches to compartmentation observed', 'good', 'fire_safety', ARRAY['Hsfra1-L-422971-210225 32-34 Connaught Square.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('5149f819-ffa5-41fb-8996-b2458fbe2199', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'lift', 'LIFTS', 'lifts_safety', ARRAY['Hsfra1-L-422971-210225 32-34 Connaught Square.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('9400b581-333e-4790-9bd3-eb00ae208aec', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'cctv', 'CCTV equipment', 'security', ARRAY['Hsfra1-L-422971-210225 32-34 Connaught Square.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, location_description, compliance_category, linked_documents) VALUES ('f3ea4ea3-41f0-4627-8d38-734c5913cec7', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'door_entry', 'Intercom door entry', 'to 3rd floor', 'security', ARRAY['Hsfra1-L-422971-210225 32-34 Connaught Square.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('b239cd6f-dbc0-4f43-ad3d-f253d2e18937', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'emergency_lighting', 'Emergency lighting provided', 'fire_safety', ARRAY['Hsfra1-L-422971-210225 32-34 Connaught Square.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('df5eff94-37f1-46fb-9fde-88fe6e77563c', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'fire_extinguisher', 'fire extinguishers', 'fire_safety', ARRAY['Hsfra1-L-422971-210225 32-34 Connaught Square.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, condition_rating, compliance_category, linked_documents) VALUES ('985ed65a-eb82-4a52-ba81-7b230aef10aa', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'lightning_protection', 'Lightning protection available', 'good', 'electrical_safety', ARRAY['Hsfra1-L-422971-210225 32-34 Connaught Square.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('41e59caf-0961-4ebe-9ca0-28fb38a4901b', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'water_tank', 'water storage tank', 'water_safety', ARRAY['Hsfra1-L-422971-210225 32-34 Connaught Square.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('894d74b3-2d03-4cac-b936-2ea53546aa96', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'fire_alarm', 'ESCAPE

FIRE DETECTION', 'fire_safety', ARRAY['Hsfra1-L-422971-210225 32-34 Connaught Square.docx']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('df4b525b-ce32-4136-9903-4fc468d85dc0', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'lift', 'LIFTS', 'lifts_safety', ARRAY['Hsfra1-L-422971-210225 32-34 Connaught Square.docx']);
INSERT INTO assets (id, building_id, asset_type, asset_name, location_description, compliance_category, linked_documents) VALUES ('7dcedbe9-03f4-4e64-b84a-d0dcec2ebaae', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'boiler', 'Boiler room', 'terrace - lift', 'gas_safety', ARRAY['221037_Fra1-L-394697-071223 32-34 Connaught Square_2024-01-02_163759 (1).pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, location_description, condition_rating, compliance_category, linked_documents) VALUES ('a10ea7b6-00f6-4941-bc41-8b191a9d6d6f', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'fire_alarm', 'Fire Alarm', 'in appropriate X Breaches to compartmentation observed', 'good', 'fire_safety', ARRAY['221037_Fra1-L-394697-071223 32-34 Connaught Square_2024-01-02_163759 (1).pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, location_description, compliance_category, linked_documents) VALUES ('41b85ed1-d2d9-4d23-a619-9bd3d61597b4', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'lift', 'lift
motor', 'terrace - lift', 'lifts_safety', ARRAY['221037_Fra1-L-394697-071223 32-34 Connaught Square_2024-01-02_163759 (1).pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, location_description, model_number, compliance_category, linked_documents) VALUES ('353d4da8-8511-4446-8b58-9afeff6bbd9f', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'door_entry', 'Intercom door entry', 'to 3rd floor', '1', 'security', ARRAY['221037_Fra1-L-394697-071223 32-34 Connaught Square_2024-01-02_163759 (1).pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('f7c440f8-8c38-4f0c-ba84-80f97ea41dbf', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'emergency_lighting', 'emergency lighting present', 'fire_safety', ARRAY['221037_Fra1-L-394697-071223 32-34 Connaught Square_2024-01-02_163759 (1).pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('358711f6-cb3c-4e51-afb7-b975fdd79a24', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'fire_extinguisher', 'fire extinguishers', 'fire_safety', ARRAY['221037_Fra1-L-394697-071223 32-34 Connaught Square_2024-01-02_163759 (1).pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, condition_rating, compliance_category, linked_documents) VALUES ('503d9d0c-9a7f-4a0d-a239-88f0affd60fb', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'lightning_protection', 'Lightning protection available', 'good', 'electrical_safety', ARRAY['221037_Fra1-L-394697-071223 32-34 Connaught Square_2024-01-02_163759 (1).pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, location_description, compliance_category, linked_documents) VALUES ('54d1b9d9-b4e6-46e5-8a13-c31064e518b1', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'boiler', 'Boiler room', 'terrace - lift', 'gas_safety', ARRAY['221038_Hsra1-L-394697-071223 32-34 Connaught Square_2024-01-02_163759 (1).pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('1092c127-ed87-485c-b291-86ef354a7fab', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'lift', 'LIFTS', 'lifts_safety', ARRAY['221038_Hsra1-L-394697-071223 32-34 Connaught Square_2024-01-02_163759 (1).pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('4b02f958-e772-4918-8b93-142a90ebc9c2', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'cctv', 'CCTV equipment', 'security', ARRAY['221038_Hsra1-L-394697-071223 32-34 Connaught Square_2024-01-02_163759 (1).pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, location_description, compliance_category, linked_documents) VALUES ('cb617b30-07ae-48a8-afbd-2730d5f12835', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'door_entry', 'Intercom door entry', 'to 3rd floor', 'security', ARRAY['221038_Hsra1-L-394697-071223 32-34 Connaught Square_2024-01-02_163759 (1).pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('4d32c1e7-3561-49c3-807b-dae6619821b5', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'emergency_lighting', 'Emergency lighting provided', 'fire_safety', ARRAY['221038_Hsra1-L-394697-071223 32-34 Connaught Square_2024-01-02_163759 (1).pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('2c9347cb-e420-4c0a-aa5a-98d1e68285da', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'water_tank', 'water storage tank', 'water_safety', ARRAY['221038_Hsra1-L-394697-071223 32-34 Connaught Square_2024-01-02_163759 (1).pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, location_description, model_number, condition_rating, compliance_category, linked_documents) VALUES ('d11cb845-2046-4a9a-87b6-5aa981b14cbd', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'boiler', 'Boiler Hamworthy', 'Plant Room Condensing', 'pressure', 'fair', 'gas_safety', ARRAY['001534-3234-Connaught-Square-London.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, location_description, compliance_category, linked_documents) VALUES ('73e6c24a-df6f-42fc-be1f-30a5b8800866', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'boiler', 'boiler number', 'new gas valve', 'gas_safety', ARRAY['C1047 - Job card.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, model_number, compliance_category, linked_documents) VALUES ('c4bb4fdf-f1ba-4b0f-b3df-7959fccf2ee4', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'boiler', 'Boilers', 'Total', 'gas_safety', ARRAY['WHM Legionella Risk Assessment 09.12.25.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('4d955e4c-2201-4589-ac22-1ecd427a77e4', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'sprinkler', 'Sprinklers', 'fire_safety', ARRAY['WHM Legionella Risk Assessment 09.12.25.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('dcd95a47-5cf0-445e-8d48-66a4f88f982a', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'pump', 'pump is', 'water_safety', ARRAY['WHM Legionella Risk Assessment 09.12.25.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, service_frequency, compliance_category, linked_documents) VALUES ('a0bbae65-8c8a-4fdb-9aed-7b4253771986', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'water_tank', 'water tanks', 'annually', 'water_safety', ARRAY['WHM Legionella Risk Assessment 09.12.25.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, model_number, compliance_category, linked_documents) VALUES ('ef0c4bce-c0aa-4d2f-b1a6-8842395d4cad', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'boiler', 'Boilers', 'Total', 'gas_safety', ARRAY['WHM Legionella Risk Assessment 07.06.22.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('01dc2d70-d9ba-4e1b-ab79-2035ed463f36', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'sprinkler', 'Sprinklers', 'fire_safety', ARRAY['WHM Legionella Risk Assessment 07.06.22.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('01856091-ec12-4072-83d9-55a17bf5fb26', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'pump', 'pump is', 'water_safety', ARRAY['WHM Legionella Risk Assessment 07.06.22.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, service_frequency, compliance_category, linked_documents) VALUES ('7033f833-d732-4244-b0ad-29472590db9a', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'water_tank', 'water tanks', 'annually', 'water_safety', ARRAY['WHM Legionella Risk Assessment 07.06.22.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('ac2f0884-f912-47e6-a6ac-83bda0c98d38', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'fire_alarm', 'Fire Alarm A', 'fire_safety', ARRAY['EICR Cuanku 32-34 conaught square.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, location_description, compliance_category, linked_documents) VALUES ('11c005fd-1de2-4cc7-93fb-1ed9be57cbce', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'lift', 'LIFT SHAFT', 'CONTROL CIRCUITS', 'lifts_safety', ARRAY['EICR Cuanku 32-34 conaught square.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, model_number, compliance_category, linked_documents) VALUES ('8f896663-2e76-4b97-aae7-9aa096c5e99b', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'lightning_protection', 'To lightning protection', 'B', 'electrical_safety', ARRAY['EICR Cuanku 32-34 conaught square.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('734541c3-b584-45e9-8d0f-6751c52bb98f', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'generator', 'generators', 'electrical_safety', ARRAY['EICR Cuanku 32-34 conaught square.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('52f207ef-3a69-4414-a5de-e7730799c0f7', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'fire_alarm', 'Fire Alarm A', 'fire_safety', ARRAY['EICR Report Cunaku SATISFACTORY 2023 .pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, location_description, compliance_category, linked_documents) VALUES ('ecda8647-0e4e-463f-85bf-50927fa23ba1', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'lift', 'LIFT SHAFT', 'CONTROL CIRCUITS', 'lifts_safety', ARRAY['EICR Report Cunaku SATISFACTORY 2023 .pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, model_number, compliance_category, linked_documents) VALUES ('a2d16da5-f445-4441-a69c-ef9ad66ec58c', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'lightning_protection', 'To lightning protection', 'B', 'electrical_safety', ARRAY['EICR Report Cunaku SATISFACTORY 2023 .pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('f35d3f66-aa4a-44f2-8b28-7037f17bf10c', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'generator', 'generators', 'electrical_safety', ARRAY['EICR Report Cunaku SATISFACTORY 2023 .pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, location_description, model_number, condition_rating, compliance_category, linked_documents) VALUES ('9ceeb3b9-0706-470a-9a0d-95d8704ff8c5', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'boiler', 'Boiler Hanworthy', 'Condensing Boiler Hanworthy Purewell variheat m k2 110 21 Mbar 110 0', 'pressure', 'fair', 'gas_safety', ARRAY['001132-3234-Connaught-Square-London.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, location_description, model_number, condition_rating, compliance_category, linked_documents) VALUES ('5560d327-d251-4211-b1d2-e822f3e9f25b', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'boiler', 'Boiler Hamworthy', 'Plant Room Condensing', 'pressure', 'fair', 'gas_safety', ARRAY['001534-3234-Connaught-Square-London.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, location_description, compliance_category, linked_documents) VALUES ('f56c3d8b-05ff-4ca7-9530-f360126a5dbd', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'boiler', 'Boiler Room', 'pipework', 'gas_safety', ARRAY['FINAL L-432900 32-34 Connaught Square Management Survey Report Issue 1.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, location_description, compliance_category, linked_documents) VALUES ('ea360b9d-977d-4407-8ac5-a98a84902c2e', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'lift', 'Lift Motor', 'Room brake shoe to lift motor', 'lifts_safety', ARRAY['FINAL L-432900 32-34 Connaught Square Management Survey Report Issue 1.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, location_description, compliance_category, linked_documents) VALUES ('253cddcf-ee25-4e2f-aba4-fbd6411d8536', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'boiler', 'Boiler Room', 'exits', 'gas_safety', ARRAY['TETRA - Asbestos Re-Inspection Survey 14.06.22.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, location_description, compliance_category, linked_documents) VALUES ('987fef09-8069-4aec-9ac7-3fb94c2a63fe', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'lift', 'Lift Motor', 'Description Assessment', 'lifts_safety', ARRAY['TETRA - Asbestos Re-Inspection Survey 14.06.22.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, location_description, compliance_category, linked_documents) VALUES ('501ca354-70a4-4286-9e34-7713076963be', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'pump', 'pumps', 'exits', 'water_safety', ARRAY['TETRA - Asbestos Re-Inspection Survey 14.06.22.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, service_frequency, compliance_category, linked_documents) VALUES ('40854bb4-e85a-4c2a-a8b8-d37c462b77be', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'lift', 'lifts', 'monthly', 'lifts_safety', ARRAY['Signed 2025 Connaught Square Management Agreement.docx.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, service_frequency, compliance_category, linked_documents) VALUES ('78d8b5e4-4641-4f11-ade6-17b134340ec3', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'lift', 'lifts', 'monthly', 'lifts_safety', ARRAY['Signed Connaught Square Management Agreement.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, model_number, compliance_category, linked_documents) VALUES ('f72a87e9-b6a8-4ca9-8316-63301acb32bd', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'boiler', 'BOILER SERVICE', 'OF', 'gas_safety', ARRAY['CM434.PRO 2024-2025.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, model_number, compliance_category, linked_documents) VALUES ('e87838f7-48c5-45ec-bd19-cccef7858b65', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'boiler', 'BOILER SERVICE', 'OF', 'gas_safety', ARRAY['CM434.PRO.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('446afe79-4096-42d9-a563-8d2dc8e4ea31', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'lift', 'lift in', 'lifts_safety', ARRAY['Gas Contract 24-5.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('5d6ef6a1-4692-4292-9f0a-442efe35d21d', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'lift', 'LIFT INCORPORATED', 'lifts_safety', ARRAY['Contract_10-03-2025.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('e593ecba-dbe6-494c-b8db-d96d088f185e', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'lift', 'LIFT INCORPORATED', 'lifts_safety', ARRAY['Gas Contract 25-26.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('76fcfb28-6a9c-4771-9640-b1eb21eec03a', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'lift', 'lift to', 'lifts_safety', ARRAY['Welcome Letter - CG1885574.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, location_description, service_frequency, compliance_category, linked_documents) VALUES ('ca8b412c-75d9-4ba7-8fcf-60b2aae406eb', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'lift', 'lift accessible', 'To clean out silt from the outlet and bagged it up', 'monthly', 'lifts_safety', ARRAY['Job 67141.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, model_number, compliance_category, linked_documents) VALUES ('b971c71e-588e-44ba-ad4e-4d98b9adb3f7', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'lift', 'Lift Ref', 'BRONZE', 'lifts_safety', ARRAY['JLGCalloutVisit-5455045-12-07-2024.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, model_number, compliance_category, linked_documents) VALUES ('ed6ac24f-5c2d-45dc-9d76-d945c4f27120', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'lift', 'Lift Ref', 'BRONZE', 'lifts_safety', ARRAY['JLGCalloutVisit-5483206-26-10-2024.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, model_number, compliance_category, linked_documents) VALUES ('78a481fb-e67c-42cd-b0c0-73175b14c5e2', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'lift', 'Lift Ref', 'BRONZE', 'lifts_safety', ARRAY['JLGCalloutVisit-5498439-16-12-2024.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, location_description, compliance_category, linked_documents) VALUES ('602fdaba-d778-4605-9943-aa6ebbd13766', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'emergency_lighting', 'emergency lighting
The', 'The fault status has been classified as Faulty', 'fire_safety', ARRAY['JLGCalloutVisit-5498439-16-12-2024.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, model_number, compliance_category, linked_documents) VALUES ('32b28001-8611-4bc5-a530-63fceb6207e3', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'lift', 'Lift Ref', 'BRONZE', 'lifts_safety', ARRAY['JLGCalloutVisit-5455462-16-07-2024.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, model_number, compliance_category, linked_documents) VALUES ('363ad035-5555-4293-810f-4fa7b2077a3f', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'lift', 'Lift Ref', 'BRONZE', 'lifts_safety', ARRAY['JLGCalloutVisit-5497480-13-12-2024.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, model_number, compliance_category, linked_documents) VALUES ('39743789-d9b2-466c-98ce-34bc2267b653', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'fire_alarm', 'Fire Alarm', 'SMALL', 'fire_safety', ARRAY['Engineering Report - 32-34 CONNAUGHT SQUARE.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, model_number, compliance_category, linked_documents) VALUES ('983a2271-b17c-4c45-ab88-d10348162ce5', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'emergency_lighting', 'Emergency Lights - FA7817', 'SMALL', 'fire_safety', ARRAY['Engineering Report - 32-34 CONNAUGHT SQUARE.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, location_description, compliance_category, linked_documents) VALUES ('19b33f74-fc7c-408b-8e28-5ab9d1bb18dd', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'boiler', 'a boiler', 'but this sha', 'gas_safety', ARRAY['StG_Policy Wording_32-34 Connaught Square W2 2HL.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('44ca59fa-57f9-4186-a2cf-18237e73c7dd', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'fire_alarm', 'fire alarm
The', 'fire_safety', ARRAY['StG_Policy Wording_32-34 Connaught Square W2 2HL.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('b65e06f6-33b4-4e74-83e4-6ef699fdb106', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'sprinkler', 'sprinkler leakage', 'fire_safety', ARRAY['StG_Policy Wording_32-34 Connaught Square W2 2HL.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('19c22730-0d4a-4609-819e-6627e3bb81d3', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'lift', 'lift in', 'lifts_safety', ARRAY['StG_Policy Wording_32-34 Connaught Square W2 2HL.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('fe1d1cd1-68e9-43fa-a2b6-4336c3557e6f', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'pump', 'pumping', 'water_safety', ARRAY['StG_Policy Wording_32-34 Connaught Square W2 2HL.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, location_description, compliance_category, linked_documents) VALUES ('cac04170-c44f-4cd6-afc1-a2a8fbd19531', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'cctv', 'cameras', 'on or', 'security', ARRAY['StG_Policy Wording_32-34 Connaught Square W2 2HL.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('87811ff2-bf3c-4856-a05b-42fa57f46b66', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'water_tank', 'water tanks', 'water_safety', ARRAY['StG_Policy Wording_32-34 Connaught Square W2 2HL.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('48a84a8b-5ac1-4883-b6f9-c95639785786', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'fire_extinguisher', 'fire extinguishers', 'fire_safety', ARRAY['Q51691 - 32-34 Connaught Square Contract.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, model_number, compliance_category, linked_documents) VALUES ('5187d6ea-c3df-4c3d-9968-ec4b27ad768f', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'fire_alarm', 'Fire Alarm', 'SMALL', 'fire_safety', ARRAY['Engineering Report - 32-34 CONNAUGHT SQUARE.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, model_number, compliance_category, linked_documents) VALUES ('90f1e856-cb8f-4a50-a75f-50769d6bd061', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'emergency_lighting', 'Emergency Lights - FA7817', 'SMALL', 'fire_safety', ARRAY['Engineering Report - 32-34 CONNAUGHT SQUARE.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, location_description, model_number, compliance_category, linked_documents) VALUES ('be08f77a-fd2b-49fd-930c-885253196a95', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'fire_alarm', 'uk
FIRE ALARM', 'LONDON', 'LIGHTS', 'fire_safety', ARRAY['Fire Alarm+Emergency Lighting Contract Connaught Square.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, service_frequency, compliance_category, linked_documents) VALUES ('fbcd3b97-1916-472d-8289-42abe040881f', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'emergency_lighting', 'EMERGENCY LIGHTS
MT8825', 'monthly', 'fire_safety', ARRAY['Fire Alarm+Emergency Lighting Contract Connaught Square.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, service_frequency, compliance_category, linked_documents) VALUES ('4a0d4acd-395f-4c8b-8e5f-729cd09b602d', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'fire_alarm', 'FIRE ALARM BELL', 'monthly', 'fire_safety', ARRAY['BT3205 03072025.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, model_number, service_frequency, compliance_category, linked_documents) VALUES ('05629c3c-1c5c-48c4-b7e3-804f8fe26b84', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'fire_alarm', 'fire alarm service', 'MAINTENANCE', 'monthly', 'fire_safety', ARRAY['FA7817 SERVICE 08042025.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, model_number, service_frequency, compliance_category, linked_documents) VALUES ('20ed1518-62db-4273-ab6c-13edfcfdee3d', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'emergency_lighting', 'Emergency Lights - FA7817', 'MAINTENANCE', 'monthly', 'fire_safety', ARRAY['FA7817 SERVICE 08042025.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, model_number, compliance_category, linked_documents) VALUES ('c0ae761e-5dfb-431e-8ed2-91fc882b67fc', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'fire_alarm', 'Fire Alarm', 'SMALL', 'fire_safety', ARRAY['Engineer Report - 32-34 Connaught Square Flat 5.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, model_number, compliance_category, linked_documents) VALUES ('7d379dc4-c590-465b-9856-81787d28b0e8', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'emergency_lighting', 'Emergency Lights - FA7817', 'SMALL', 'fire_safety', ARRAY['Engineer Report - 32-34 Connaught Square Flat 5.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, model_number, compliance_category, linked_documents) VALUES ('081f7990-b2f8-4f3a-a514-7e286de0ce7d', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'fire_alarm', 'Fire Alarm', 'SMALL', 'fire_safety', ARRAY['Engineering Report - 32-34 CONNAUGHT SQUARE.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, model_number, compliance_category, linked_documents) VALUES ('eecbc4ab-cc07-4bdd-a668-f2309e9af71a', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'emergency_lighting', 'Emergency Lights - FA7817', 'SMALL', 'fire_safety', ARRAY['Engineering Report - 32-34 CONNAUGHT SQUARE.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, model_number, service_frequency, compliance_category, linked_documents) VALUES ('c3c4dbd1-c557-41ab-9363-9680947af984', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'emergency_lighting', 'Emergency Lights Testing', 'MONTHLY', 'monthly', 'fire_safety', ARRAY['MT8825 03072025.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, model_number, service_frequency, compliance_category, linked_documents) VALUES ('34fd9982-863e-4313-9b31-befc5e22eaf2', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'emergency_lighting', 'Emergency Lights Testing', 'MONTHLY', 'monthly', 'fire_safety', ARRAY['January Monthly Test For EL-Connaught Square.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, model_number, service_frequency, compliance_category, linked_documents) VALUES ('85df2959-6aa1-43ef-a376-d0a82f96483c', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'emergency_lighting', 'Emergency Lights Testing', 'MONTHLY', 'monthly', 'fire_safety', ARRAY['February Monthly Test For EL-Connaught Square.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('dfb19498-468e-443a-bc40-d35709f0504d', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'boiler', 'boilers', 'gas_safety', ARRAY['Real Estate Policy (01.23).pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('9a22a3e8-54a1-4394-b0a7-67c6148b3b09', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'sprinkler', 'sprinkler leakage', 'fire_safety', ARRAY['Real Estate Policy (01.23).pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('98adb5d2-374f-4ce8-b5ca-a97da40d538f', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'pump', 'pumping', 'water_safety', ARRAY['Real Estate Policy (01.23).pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('3c985366-d45c-458a-ad8f-499055e48ce5', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'cctv', 'cameras', 'security', ARRAY['Real Estate Policy (01.23).pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('b6c7578c-cdc7-438a-9fd5-c100c902ea71', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'fire_extinguisher', 'fire extinguishers', 'fire_safety', ARRAY['Real Estate Policy (01.23).pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('92008baa-dd99-4474-a5fa-4962ebf5ff64', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'communal_aerial', 'satellite dishes', 'other', ARRAY['Real Estate Policy (01.23).pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('1f1bddf3-e397-4f2b-8f83-f5aa004b9f9b', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'water_tank', 'water tanks', 'water_safety', ARRAY['Real Estate Policy (01.23).pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('79b9e26a-e024-4e41-9220-bf1a649a786f', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'sprinkler', 'sprinkler installation', 'fire_safety', ARRAY['Summary of Cover (01.23).pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('3209d268-8b4e-44b2-a24b-e67a718938c3', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'lift', 'lift in', 'lifts_safety', ARRAY['Summary of Cover (01.23).pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('386e9214-6c7e-4bcb-be8a-b86849ef1797', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'boiler', 'Boilers', 'gas_safety', ARRAY['2023 Allianz VOC - 32-34 Connuaght Square (Freehold) Limited.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('fc19a75b-35ac-489f-b087-cd63e4f572c3', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'lift', 'Lift - Powered', 'lifts_safety', ARRAY['2023 Allianz VOC - 32-34 Connuaght Square (Freehold) Limited.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('902b6147-0d24-4703-9778-0ef70ceb5bca', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'pump', 'Pumps', 'water_safety', ARRAY['2023 Allianz VOC - 32-34 Connuaght Square (Freehold) Limited.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('d057543a-fec3-49eb-a037-9abf46fd0561', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'boiler', 'Boilers', 'gas_safety', ARRAY['2023 Engineering Renewal Notice - 32 34 Connuaght Square (Freehold) Limited.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('69df445d-7c89-42d3-be97-874d198c2b02', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'lift', 'Lift -
Powered', 'lifts_safety', ARRAY['2023 Engineering Renewal Notice - 32 34 Connuaght Square (Freehold) Limited.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('939d5c0d-343f-47b5-a829-e08f89e359ab', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'pump', 'Pumps', 'water_safety', ARRAY['2023 Engineering Renewal Notice - 32 34 Connuaght Square (Freehold) Limited.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('d228fffc-822f-4259-a231-2bed3e9b70cf', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'lift', 'Lift', 'lifts_safety', ARRAY['32-34 Connaught Sq Buildings Insurance 2023-2024.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('a98112d0-bea0-4125-8955-96621a76760f', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'lift', 'Lift Report', 'lifts_safety', ARRAY['Allianz - Lift Report 14.03.23.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('b7828c3b-aac7-4331-aa73-71d061f0e4b9', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'lift', 'Lift Report', 'lifts_safety', ARRAY['Allianz-Lift Report 18.03.2024.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('734d10b8-e56d-42a5-ab10-f74f6492a4d4', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'lift', 'Lift Report', 'lifts_safety', ARRAY['Allianz - Lift Report - 15.09.21.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('63aa2fe7-21eb-4e22-90c1-4a075c42b0dd', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'lift', 'Lift Report', 'lifts_safety', ARRAY['Allianz - Lift Report 10.03.22.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('176e6fb6-f7e6-4dd8-b17b-ef34a4edb9ba', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'boiler', 'Boilers', 'gas_safety', ARRAY['2023 Allianz VOC - 32-34 Connuaght Square (Freehold) Limited.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('5a289179-64e5-4fdf-9e7a-da67791a9cd8', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'lift', 'Lift - Powered', 'lifts_safety', ARRAY['2023 Allianz VOC - 32-34 Connuaght Square (Freehold) Limited.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('6b88ba5c-2a0a-4ec4-9d17-dfe4a93ba260', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'pump', 'Pumps', 'water_safety', ARRAY['2023 Allianz VOC - 32-34 Connuaght Square (Freehold) Limited.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('629036a8-e295-4299-837a-d4b76058fc15', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'boiler', 'Boilers', 'gas_safety', ARRAY['2023 Engineering Renewal Notice - 32 34 Connuaght Square (Freehold) Limited.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('4bd7034e-2b2d-4577-a516-75257621a5b3', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'lift', 'Lift -
Powered', 'lifts_safety', ARRAY['2023 Engineering Renewal Notice - 32 34 Connuaght Square (Freehold) Limited.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('c4a994f0-0263-4865-8fa2-61fcfb9da3be', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'pump', 'Pumps', 'water_safety', ARRAY['2023 Engineering Renewal Notice - 32 34 Connuaght Square (Freehold) Limited.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, location_description, compliance_category, linked_documents) VALUES ('96dbef57-9fb6-41b5-9157-c2a3a1ffbc26', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'boiler', 'Boiler and', 'owned by or leased', 'gas_safety', ARRAY['MO - Policy Wording - NZ0411.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('60ddd1b4-7ad9-45cd-ae39-a91f9114397d', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'lift', 'Lift and', 'lifts_safety', ARRAY['MO - Policy Wording - NZ0411.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('989c7d19-b408-4a98-b709-3f6d68089c31', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'pump', 'pumps', 'water_safety', ARRAY['MO - Policy Wording - NZ0411.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('6f77c631-db16-4b78-870e-205a30642a16', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'water_tank', 'Storage Tanks', 'water_safety', ARRAY['MO - Policy Wording - NZ0411.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('4f32ae41-7662-4159-b4d5-b8817dfc07ce', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'generator', 'generator sets', 'electrical_safety', ARRAY['MO - Policy Wording - NZ0411.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('0ed9d31c-ecb4-4c24-92c2-c9be3606b643', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'lift', 'Lift and', 'lifts_safety', ARRAY['Feature and Benefits of Allianz Engineering Inspection Service.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('9446fac6-b414-485b-bcc9-80b8f3a0e202', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'boiler', 'Boilers', 'gas_safety', ARRAY['StG_Statement of Facts_32-34 Connaught Square W2 2HL.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('b47d7554-8ef5-44f3-ba75-85ba3783ddc3', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'lift', 'Lifts', 'lifts_safety', ARRAY['StG_Statement of Facts_32-34 Connaught Square W2 2HL.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('62fecdfa-4b41-442e-83b5-93aec00c183e', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'pump', 'Centrifugal pump', 'water_safety', ARRAY['StG_Statement of Facts_32-34 Connaught Square W2 2HL.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('9c52a354-5a8b-4f32-a19c-6deb4f596714', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'boiler', 'Boilers', 'gas_safety', ARRAY['StG_Insurance Report_32-34 Connaught Square W2 2HL.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('acd8532a-45e0-439e-ad28-2ac1a0100466', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'lift', 'Lifts', 'lifts_safety', ARRAY['StG_Insurance Report_32-34 Connaught Square W2 2HL.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('7d842c4f-2ca5-44fb-a5af-7601939bb730', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'pump', 'Centrifugal pump', 'water_safety', ARRAY['StG_Insurance Report_32-34 Connaught Square W2 2HL.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('55427fb3-001e-4e6d-bce4-97bdf58a1dd0', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'boiler', 'Boilers', 'gas_safety', ARRAY['StG_Statement of Facts_32-34 Connaught Square W2 2HL.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('969ddbac-98f4-4c3b-b9ab-2d30b4b1511d', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'lift', 'Lifts', 'lifts_safety', ARRAY['StG_Statement of Facts_32-34 Connaught Square W2 2HL.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('8dee0351-7502-40b1-a689-11899766b8e1', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'pump', 'Centrifugal pump', 'water_safety', ARRAY['StG_Statement of Facts_32-34 Connaught Square W2 2HL.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('a2e5db12-3141-447c-8214-f5441a740df3', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'boiler', 'Boilers', 'gas_safety', ARRAY['StG_Insurance Report_32-34 Connaught Square W2 2HL.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('804aed0a-8baf-4b04-a8f9-4bb37365b26c', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'lift', 'Lifts', 'lifts_safety', ARRAY['StG_Insurance Report_32-34 Connaught Square W2 2HL.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('cc3016e4-e2ee-4b52-90b1-82e5585bebc7', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'pump', 'Centrifugal pump', 'water_safety', ARRAY['StG_Insurance Report_32-34 Connaught Square W2 2HL.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('188ded95-9700-45b1-a70c-414f3ff274e1', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'boiler', 'water boiler', 'gas_safety', ARRAY['StG_Certificate_32-34 Connaught Square W2 2HL.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('8e43fd26-ba45-403b-b534-6cd723363d93', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'lift', 'Passenger Lift', 'lifts_safety', ARRAY['StG_Certificate_32-34 Connaught Square W2 2HL.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('c95daf12-8918-42d7-96f3-c357e7804f24', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'pump', 'Centrifugal pump', 'water_safety', ARRAY['StG_Certificate_32-34 Connaught Square W2 2HL.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('69bdc4aa-27cc-4cc9-bbcd-d81264069b63', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'boiler', 'Boilers', 'gas_safety', ARRAY['StG_Statement of Fact_32-34 Connaught Square W2 2HL.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('47213242-1c92-4735-8570-6c6128735a19', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'lift', 'Lifts', 'lifts_safety', ARRAY['StG_Statement of Fact_32-34 Connaught Square W2 2HL.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('da5f90d1-379d-4116-bfcb-c90203ad9070', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'pump', '1x Pump', 'water_safety', ARRAY['StG_Statement of Fact_32-34 Connaught Square W2 2HL.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('913af2a2-dca5-4f66-8e26-c704173a5a28', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'lift', 'Lift', 'lifts_safety', ARRAY['FBR113382303-20230405-B.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('ff75e396-9bc9-4bb3-9ca8-d32955b81f2b', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'boiler', 'boilers', 'gas_safety', ARRAY['Real Estate Policy (01.23).pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('482db81c-3bf5-4b0e-8da7-047719596df9', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'sprinkler', 'sprinkler leakage', 'fire_safety', ARRAY['Real Estate Policy (01.23).pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('ebb83b9a-cb8d-469b-b0e2-c58a90e10005', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'pump', 'pumping', 'water_safety', ARRAY['Real Estate Policy (01.23).pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('89bc0daa-cd50-483b-94aa-5bf9047a2655', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'cctv', 'cameras', 'security', ARRAY['Real Estate Policy (01.23).pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('29dba4e7-63c4-4b20-ad77-a182683b0150', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'fire_extinguisher', 'fire extinguishers', 'fire_safety', ARRAY['Real Estate Policy (01.23).pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('18c82694-83cb-47e5-a474-72283ecc24c1', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'communal_aerial', 'satellite dishes', 'other', ARRAY['Real Estate Policy (01.23).pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('1e2e25c3-7e6e-411e-ac78-4af8f76ce1b4', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'water_tank', 'water tanks', 'water_safety', ARRAY['Real Estate Policy (01.23).pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('aca53990-ad71-4d99-903b-7d8c77389a58', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'sprinkler', 'sprinkler installation', 'fire_safety', ARRAY['Summary of Cover (01.23).pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('fa6174d7-a3ac-4c7f-9f5e-9ea2abd9ef06', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'lift', 'lift in', 'lifts_safety', ARRAY['Summary of Cover (01.23).pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('ed872a82-4221-49e9-9146-6f13e26d3088', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'lift', 'Lift', 'lifts_safety', ARRAY['32-34 Connaught Sq Buildings Insurance 2023-2024.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('83b5a67e-e1d4-4b09-93e3-1dfa7355834f', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'sprinkler', 'sprinkler installation', 'fire_safety', ARRAY['Zurich Real Estate Policy Summary.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('a5ad50fe-e48e-4b96-8602-98642ab0c1b3', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'lift', 'lift in', 'lifts_safety', ARRAY['Zurich Real Estate Policy Summary.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('b0c446f1-104d-422b-84c9-117e3057603d', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'boiler', 'boilers', 'gas_safety', ARRAY['Zurich Real Estate Policy Wording.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('74557e73-595f-46d5-a031-1b15f28d935d', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'sprinkler', 'sprinkler leakage', 'fire_safety', ARRAY['Zurich Real Estate Policy Wording.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('330e60fe-1bbc-488b-8a93-c18ac03b0a9c', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'pump', 'pumping', 'water_safety', ARRAY['Zurich Real Estate Policy Wording.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('d0fe4014-9492-4081-b692-362f7b43d493', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'cctv', 'cameras', 'security', ARRAY['Zurich Real Estate Policy Wording.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('159f8872-5bfa-4521-9003-80e9db2ca00c', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'fire_extinguisher', 'fire extinguishers', 'fire_safety', ARRAY['Zurich Real Estate Policy Wording.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('c7e10a9b-4472-4b49-85c0-c310c6f19a37', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'communal_aerial', 'satellite dishes', 'other', ARRAY['Zurich Real Estate Policy Wording.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('c47aeec9-a837-4a1a-92b6-f5c234c65747', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'water_tank', 'water tanks', 'water_safety', ARRAY['Zurich Real Estate Policy Wording.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('bd175ed6-8e73-4bf8-a1ed-b220d96245e4', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'lift', 'Lift', 'lifts_safety', ARRAY['StG_Certificate_32-34 Connaught Square W2 2HL.pdf']);

-- Insert 22 maintenance schedules
INSERT INTO maintenance_schedules (id, building_id, contract_id, service_type, description, frequency, frequency_interval, next_due_date, estimated_duration, priority, status) VALUES ('d32d6a0a-728f-46b9-9864-9f13274e65be', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'bf30ed62-fbc8-4b32-aa82-57141ec9f225', 'lifts', 'lifts - ISS', 'monthly', '1 month', '2025-11-09', '4 hours', 'high', 'scheduled');
INSERT INTO maintenance_schedules (id, building_id, contract_id, service_type, description, frequency, frequency_interval, next_due_date, estimated_duration, priority, status) VALUES ('fb0a7c71-e4c9-4256-9bcc-65b082d30b71', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'a90aadaa-a346-446e-aa8a-f85496a9655c', 'security', 'security - ISS', 'quarterly', '3 months', '2026-01-09', '8 hours', 'medium', 'scheduled');
INSERT INTO maintenance_schedules (id, building_id, contract_id, service_type, description, frequency, frequency_interval, next_due_date, estimated_duration, priority, status) VALUES ('0ad26832-7f10-4eb2-84ca-571000ab8d53', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', '1987c751-dafd-4f62-92f2-772c02272c8e', 'security', 'security - ISS', 'quarterly', '3 months', '2026-01-09', '8 hours', 'medium', 'scheduled');
INSERT INTO maintenance_schedules (id, building_id, contract_id, service_type, description, frequency, frequency_interval, next_due_date, estimated_duration, priority, status) VALUES ('9b86ce5a-5a2c-4c13-ad80-aa054ca2e80f', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', '8a2f9b04-617e-4b98-ac01-2abf6fdae285', 'lifts', 'lifts - ISS', 'monthly', '1 month', '2025-11-09', '4 hours', 'high', 'scheduled');
INSERT INTO maintenance_schedules (id, building_id, contract_id, service_type, description, frequency, frequency_interval, next_due_date, estimated_duration, priority, status) VALUES ('fcc71e34-6c5d-4b26-8ad5-2bbd49048e29', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'a03cce09-a211-4367-a224-6e01dee072f9', 'lifts', 'lifts - ISS', 'monthly', '1 month', '2025-11-09', '4 hours', 'high', 'scheduled');
INSERT INTO maintenance_schedules (id, building_id, contract_id, service_type, description, frequency, frequency_interval, next_due_date, estimated_duration, priority, status) VALUES ('9fd8d23d-cffd-44e5-91bd-af9eebdd52e6', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', '2010ab54-6cf2-48fa-9b96-ae90037d6093', 'lifts', 'lifts - ISS', 'monthly', '1 month', '2025-11-09', '4 hours', 'high', 'scheduled');
INSERT INTO maintenance_schedules (id, building_id, contract_id, service_type, description, frequency, frequency_interval, next_due_date, estimated_duration, priority, status) VALUES ('6056983c-21af-45c2-93aa-6e5e2b5cc8c3', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', '09951f77-5103-4c15-86dd-91b3b8fb80f7', 'lifts', 'lifts - ISS', 'monthly', '1 month', '2025-11-09', '4 hours', 'high', 'scheduled');
INSERT INTO maintenance_schedules (id, building_id, contract_id, service_type, description, frequency, frequency_interval, next_due_date, estimated_duration, priority, status) VALUES ('a5af91d5-2b93-4a98-9134-73a9b46c0060', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', '58ff6582-6613-4cfe-a6da-8f2ab87d454b', 'lifts', 'lifts - ISS', 'annual', '12 months', '2026-03-14', '4 hours', 'high', 'scheduled');
INSERT INTO maintenance_schedules (id, building_id, contract_id, service_type, description, frequency, frequency_interval, next_due_date, estimated_duration, priority, status) VALUES ('31af5f14-712a-4d40-aefa-09fd2edcfdfa', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', '9472f734-8914-4d64-9346-331d5997ea06', 'lifts', 'lifts - None', 'monthly', '1 month', '2025-02-13', '4 hours', 'high', 'scheduled');
INSERT INTO maintenance_schedules (id, building_id, contract_id, description, frequency, frequency_interval, next_due_date, priority, status) VALUES ('64b70210-671e-495f-ba22-b325bf038b3c', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', '94d980f5-d9ec-4fc9-8388-4e569e8bd1dc', 'None - WHM', 'monthly', '1 month', '2025-11-09', 'medium', 'scheduled');
INSERT INTO maintenance_schedules (id, building_id, contract_id, description, frequency, frequency_interval, next_due_date, priority, status) VALUES ('2a4bbb62-6f8f-4fb9-a4a2-2c6ec2687fbf', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', '0593984e-172c-42da-84db-e3d2e0d75de7', 'None - WHM', 'monthly', '1 month', '2025-11-09', 'medium', 'scheduled');
INSERT INTO maintenance_schedules (id, building_id, contract_id, description, frequency, frequency_interval, next_due_date, priority, status) VALUES ('84a7809d-d088-4ee4-8194-7f0440e4dd6a', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'ed7e6329-75cc-458f-9ce6-05c4260ce347', 'None - WHM', 'monthly', '1 month', '2025-11-09', 'medium', 'scheduled');
INSERT INTO maintenance_schedules (id, building_id, contract_id, description, frequency, frequency_interval, next_due_date, priority, status) VALUES ('ec5146f6-616f-47b1-b4cb-2ec625554bcb', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'a7700783-7e9b-4e51-a5d2-cbee56a1fdb8', 'None - WHM', 'monthly', '1 month', '2025-11-09', 'medium', 'scheduled');
INSERT INTO maintenance_schedules (id, building_id, contract_id, service_type, description, frequency, frequency_interval, next_due_date, estimated_duration, priority, status) VALUES ('c47dbbd0-347d-455f-af76-605e96a0ff75', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'b8b494cd-1ac0-40fc-8256-d5d475fc25a1', 'security', 'security - Capita', 'monthly', '1 month', '2025-11-09', '8 hours', 'medium', 'scheduled');
INSERT INTO maintenance_schedules (id, building_id, contract_id, service_type, description, frequency, frequency_interval, next_due_date, estimated_duration, priority, status) VALUES ('49963bd9-2e2d-4802-bd69-6069bdfa7bc1', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', '8305ec69-1952-4a49-a57d-65567259c9b0', 'fire_alarm', 'fire_alarm - Capita', 'monthly', '1 month', '2025-11-09', '2 hours', 'high', 'scheduled');
INSERT INTO maintenance_schedules (id, building_id, contract_id, service_type, description, frequency, frequency_interval, next_due_date, estimated_duration, priority, status) VALUES ('46620318-0218-47b8-b985-4406c84a1be8', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', '0580df13-c8ad-4b98-a044-2e24a8bf2712', 'fire_alarm', 'fire_alarm - None', 'monthly', '1 month', '2025-11-09', '2 hours', 'high', 'scheduled');
INSERT INTO maintenance_schedules (id, building_id, contract_id, service_type, description, frequency, frequency_interval, next_due_date, estimated_duration, priority, status) VALUES ('bff35780-e238-44bc-820c-7c0aa6510f93', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'e62c6340-f23d-49f9-9937-a6d264974373', 'fire_alarm', 'fire_alarm - None', 'monthly', '1 month', '2025-11-09', '2 hours', 'high', 'scheduled');
INSERT INTO maintenance_schedules (id, building_id, contract_id, service_type, description, frequency, frequency_interval, next_due_date, estimated_duration, priority, status) VALUES ('a00dafe5-0e4b-49e6-8c3a-52aa4996d750', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', '1f1f6606-9dfe-4291-b560-2935cb1d8dff', 'fire_alarm', 'fire_alarm - None', 'monthly', '1 month', '2025-11-09', '2 hours', 'high', 'scheduled');
INSERT INTO maintenance_schedules (id, building_id, contract_id, description, frequency, frequency_interval, next_due_date, priority, status) VALUES ('6188c171-176e-4cb1-8fcb-7d3b5e11a645', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'ca405363-6b5a-433a-a558-8eb5af4a9cef', 'None - WHM', 'monthly', '1 month', '2025-11-09', 'medium', 'scheduled');
INSERT INTO maintenance_schedules (id, building_id, contract_id, description, frequency, frequency_interval, next_due_date, priority, status) VALUES ('f1dc916c-b4d7-417b-8d04-baa9d3eae40a', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'be0c3023-b086-4479-8df8-9c8e85244228', 'None - None', 'monthly', '1 month', '2025-11-09', 'medium', 'scheduled');
INSERT INTO maintenance_schedules (id, building_id, contract_id, description, frequency, frequency_interval, next_due_date, priority, status) VALUES ('0ba0cfac-bfc3-4760-b95f-347f8de53b80', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', '328aa331-8de9-46df-b98c-41f43d2e6cfa', 'None - None', 'monthly', '1 month', '2025-11-09', 'medium', 'scheduled');
INSERT INTO maintenance_schedules (id, building_id, contract_id, description, frequency, frequency_interval, next_due_date, priority, status) VALUES ('189c331e-38f6-41fa-8494-4f07c369b2c4', 'e44d99d4-556d-4644-9e08-4bc01a4bf90e', 'ee89edb0-6963-46ba-a605-e06eb1bece95', 'None - None', 'monthly', '1 month', '2025-11-09', 'medium', 'scheduled');

-- Insert 28 lease records
-- Skipped empty insert for leases
-- Skipped empty insert for leases
-- Skipped empty insert for leases
-- Skipped empty insert for leases
-- Skipped empty insert for leases
-- Skipped empty insert for leases
-- Skipped empty insert for leases
-- Skipped empty insert for leases
-- Skipped empty insert for leases
-- Skipped empty insert for leases
-- Skipped empty insert for leases
-- Skipped empty insert for leases
-- Skipped empty insert for leases
-- Skipped empty insert for leases
-- Skipped empty insert for leases
-- Skipped empty insert for leases
-- Skipped empty insert for leases
-- Skipped empty insert for leases
-- Skipped empty insert for leases
-- Skipped empty insert for leases
-- Skipped empty insert for leases
-- Skipped empty insert for leases
-- Skipped empty insert for leases
-- Skipped empty insert for leases
-- Skipped empty insert for leases
-- Skipped empty insert for leases
-- Skipped empty insert for leases
-- Skipped empty insert for leases


-- Migration complete
COMMIT;

-- Rollback command (if needed):
-- ROLLBACK;

-- ============================================================
-- POST-PROCESSING ENRICHMENT
-- Auto-generated corrections and enhancements
-- ============================================================

-- ============================================================
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


-- Fallback budget for unstructured PDF
INSERT INTO budgets (id, building_id, document_id, period, budget_type, total_amount)
VALUES (
    '49f4bb22-ddec-4a97-99e4-8d794b27ba0e',
    'e44d99d4-556d-4644-9e08-4bc01a4bf90e',
    '05f67652-c22e-4bd4-a3fc-c78e1111d8a0',
    'Unknown',
    'service_charge',
    NULL  -- Requires manual entry
)
ON CONFLICT (id) DO NOTHING;

-- Fallback budget for unstructured PDF
INSERT INTO budgets (id, building_id, document_id, period, budget_type, total_amount)
VALUES (
    '2bb07c1e-e29d-41f2-a629-42df60e2c2b5',
    'e44d99d4-556d-4644-9e08-4bc01a4bf90e',
    'd1bbbe3d-e1d4-4db0-a53e-191571bcb43a',
    'Unknown',
    'service_charge',
    NULL  -- Requires manual entry
)
ON CONFLICT (id) DO NOTHING;

-- Fallback budget for unstructured PDF
INSERT INTO budgets (id, building_id, document_id, period, budget_type, total_amount)
VALUES (
    '9f081da6-56ff-40f3-8b2a-e6c8a45ad098',
    'e44d99d4-556d-4644-9e08-4bc01a4bf90e',
    '5ce11d0a-d1ab-4c67-aea2-a0cb400a9318',
    'Unknown',
    'service_charge',
    NULL  -- Requires manual entry
)
ON CONFLICT (id) DO NOTHING;

-- Fallback budget for unstructured PDF
INSERT INTO budgets (id, building_id, document_id, period, budget_type, total_amount)
VALUES (
    '5e6ddb9e-e5fc-41e4-85b0-2415d7ddff5a',
    'e44d99d4-556d-4644-9e08-4bc01a4bf90e',
    '6dee7a03-45d7-4b86-8ec8-102a682db615',
    'Unknown',
    'service_charge',
    NULL  -- Requires manual entry
)
ON CONFLICT (id) DO NOTHING;

-- Fallback budget for unstructured PDF
INSERT INTO budgets (id, building_id, document_id, period, budget_type, total_amount)
VALUES (
    '3b16a442-410c-463c-b2f0-447a9b2bfbce',
    'e44d99d4-556d-4644-9e08-4bc01a4bf90e',
    '95775d01-07bc-4491-a97d-15480bd18a23',
    '2025',
    'service_charge',
    NULL  -- Requires manual entry
)
ON CONFLICT (id) DO NOTHING;

-- Fallback budget for unstructured PDF
INSERT INTO budgets (id, building_id, document_id, period, budget_type, total_amount)
VALUES (
    '7f0cb20e-7be5-495c-9526-bb67eff4d06c',
    'e44d99d4-556d-4644-9e08-4bc01a4bf90e',
    '7dd76afe-cdb2-41a2-8e4b-430bb5dc392c',
    '2025',
    'service_charge',
    NULL  -- Requires manual entry
)
ON CONFLICT (id) DO NOTHING;

-- Fallback budget for unstructured PDF
INSERT INTO budgets (id, building_id, document_id, period, budget_type, total_amount)
VALUES (
    'd8746fa1-6d18-47c4-a956-cbc5fcf77786',
    'e44d99d4-556d-4644-9e08-4bc01a4bf90e',
    'f6f3cc6e-83b9-4614-beca-b2fdfe576b32',
    '2025',
    'service_charge',
    NULL  -- Requires manual entry
)
ON CONFLICT (id) DO NOTHING;

-- Fallback budget for unstructured PDF
INSERT INTO budgets (id, building_id, document_id, period, budget_type, total_amount)
VALUES (
    '827a71da-3f46-4622-a436-54ede28493bc',
    'e44d99d4-556d-4644-9e08-4bc01a4bf90e',
    '24cb74ee-2caa-41c0-b1f4-1fd1595351d5',
    'Unknown',
    'service_charge',
    NULL  -- Requires manual entry
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Caretaker
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    'a5346e4a-14c0-4766-92fd-675cc34f7d53',
    'e44d99d4-556d-4644-9e08-4bc01a4bf90e',
    'caretaker',
    'general',
    'Caretaker',
    NULL,
    NULL,
    'Duties/Next Meeting:',
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Fire Alarm
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    'f1d446d6-bb0e-4c4d-95cb-2fa96b9834ee',
    'e44d99d4-556d-4644-9e08-4bc01a4bf90e',
    'fire_alarm_location',
    'safety',
    'Fire Alarm',
    NULL,
    'Works',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Boiler
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '34db1f08-551d-40d1-b32a-39ca5d5b1db2',
    'e44d99d4-556d-4644-9e08-4bc01a4bf90e',
    'boiler_location',
    'utilities',
    'Boiler',
    NULL,
    'Room',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Fire Alarm
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '0f2045da-3eff-4819-91e2-af310a6f7a56',
    'e44d99d4-556d-4644-9e08-4bc01a4bf90e',
    'fire_alarm_location',
    'safety',
    'Fire Alarm',
    NULL,
    'A B 1 1.5 1.5 0.4 61009 B 6 10 30 5.82 N/A N/A N/A N/A 0.52 N/A 500 >200 >200 ü 0.72 17.7 10 ü N/A',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Sprinkler
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    'd660ee5d-6439-47c0-acb6-b8f95dcabe71',
    'e44d99d4-556d-4644-9e08-4bc01a4bf90e',
    'sprinkler_location',
    'safety',
    'Sprinkler',
    NULL,
    'leakage, impact by Landlords’ Contents',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Sprinkler
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '617677ca-ec6a-498b-8694-99889ee791f5',
    'e44d99d4-556d-4644-9e08-4bc01a4bf90e',
    'sprinkler_location',
    'safety',
    'Sprinkler',
    NULL,
    'installation in undamaged portions of the',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Sprinkler
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    'b66b4fca-5379-428f-9203-e6ea06127344',
    'e44d99d4-556d-4644-9e08-4bc01a4bf90e',
    'sprinkler_location',
    'safety',
    'Sprinkler',
    NULL,
    'a) DAMAGE or CONSEQUENTIAL LOSS resulting from any:',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Sprinkler
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '47de259e-692c-469e-896b-d5c6c5364aa7',
    'e44d99d4-556d-4644-9e08-4bc01a4bf90e',
    'sprinkler_location',
    'safety',
    'Sprinkler',
    NULL,
    'Leakage',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Sprinkler
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    'c7ca99f5-a64b-40a3-b110-92d9d05101a2',
    'e44d99d4-556d-4644-9e08-4bc01a4bf90e',
    'sprinkler_location',
    'safety',
    'Sprinkler',
    NULL,
    'installation in the Premises excluding:',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Sprinkler
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '1a24c74f-bb7b-4f2c-91d4-913fec9681fa',
    'e44d99d4-556d-4644-9e08-4bc01a4bf90e',
    'sprinkler_location',
    'safety',
    'Sprinkler',
    NULL,
    'heads',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Sprinkler
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    'b8cd657f-0a15-4944-87cb-0ec61463c96d',
    'e44d99d4-556d-4644-9e08-4bc01a4bf90e',
    'sprinkler_location',
    'safety',
    'Sprinkler',
    NULL,
    'tanks where costs are metered',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Sprinkler
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '3fe246b5-af48-4802-9508-572ded52bdff',
    'e44d99d4-556d-4644-9e08-4bc01a4bf90e',
    'sprinkler_location',
    'safety',
    'Sprinkler',
    NULL,
    'Leakage if',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Sprinkler
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    'c535930a-0f85-42ae-bbf9-145a8223a7c2',
    'e44d99d4-556d-4644-9e08-4bc01a4bf90e',
    'sprinkler_location',
    'safety',
    'Sprinkler',
    NULL,
    'Installations G35 Payments on Account',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Sprinkler
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    'e0031152-aecc-4036-8928-40275a175348',
    'e44d99d4-556d-4644-9e08-4bc01a4bf90e',
    'sprinkler_location',
    'safety',
    'Sprinkler',
    NULL,
    'installation at the Premises by any Cover insured hereby in the event that on repair or reinstatement necessary adjustments at the end of the Indemnity Period.',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Sprinkler
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '48be6b39-be7f-437e-9f49-474b1ecd1757',
    'e44d99d4-556d-4644-9e08-4bc01a4bf90e',
    'sprinkler_location',
    'safety',
    'Sprinkler',
    NULL,
    'Installations current at that time. G36 Renewal',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Sprinkler
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '8fdeae9a-c2f6-486d-8224-fc68df334c99',
    'e44d99d4-556d-4644-9e08-4bc01a4bf90e',
    'sprinkler_location',
    'safety',
    'Sprinkler',
    NULL,
    'Leakage or Theft if insured will be £500 or the Excess stated in the Schedule or Folio',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Sprinkler
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    'ac6a7e79-70c8-49c2-98dc-6b8714c77110',
    'e44d99d4-556d-4644-9e08-4bc01a4bf90e',
    'sprinkler_location',
    'safety',
    'Sprinkler',
    NULL,
    'systems are installed and water supplies must be maintained heating is being maintained',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Sprinkler
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    'f409801d-48b5-4250-8a04-1c92c63b9962',
    'e44d99d4-556d-4644-9e08-4bc01a4bf90e',
    'sprinkler_location',
    'safety',
    'Sprinkler',
    NULL,
    'Leakage or Theft if insured will then be £500 or the Excess',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Sprinkler
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '0fb27c3b-a273-4d99-b811-ed8e1870a355',
    'e44d99d4-556d-4644-9e08-4bc01a4bf90e',
    'sprinkler_location',
    'safety',
    'Sprinkler',
    NULL,
    'Leakage or Theft if insured will then be £500 or the Excess at a minimum temperature of 5 degrees Celsius; and',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Sprinkler
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '316a970f-26a7-4ebe-8903-d2ffb196df0b',
    'e44d99d4-556d-4644-9e08-4bc01a4bf90e',
    'sprinkler_location',
    'safety',
    'Sprinkler',
    NULL,
    'systems are installed and water supplies must be maintained heating is being maintained ix) any new accumulations of combustible materials including but not limited to junk mail found during such',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Sprinkler
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '1d735666-4826-4746-b676-7b84af16dbbd',
    'e44d99d4-556d-4644-9e08-4bc01a4bf90e',
    'sprinkler_location',
    'safety',
    'Sprinkler',
    NULL,
    'system), impact of aircraft or any aerial devices or',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Parking
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '3f18f59f-204e-4da3-a71a-234b3ddb3660',
    'e44d99d4-556d-4644-9e08-4bc01a4bf90e',
    'parking',
    'general',
    'Parking',
    NULL,
    NULL,
    'contracted where such liability arises under contract except where such liability is wider or more extensive',
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Parking
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '8e417915-b817-474a-9c81-172ce3eee596',
    'e44d99d4-556d-4644-9e08-4bc01a4bf90e',
    'parking',
    'general',
    'Parking',
    NULL,
    NULL,
    'service. Channel Islands or work carried out by or on behalf of the Insured outside Great Britain, Northern Ireland, the',
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Sprinkler
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    'f4fed8b9-0156-409c-9eec-103ab55ca45c',
    'e44d99d4-556d-4644-9e08-4bc01a4bf90e',
    'sprinkler_location',
    'safety',
    'Sprinkler',
    NULL,
    'installation.',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Parking
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    'cf859eb7-cdb2-4d1c-9d61-fedc58d7a84e',
    'e44d99d4-556d-4644-9e08-4bc01a4bf90e',
    'parking',
    'general',
    'Parking',
    NULL,
    NULL,
    'service.',
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Gas Meter
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    'b0279f8f-4725-4668-bfd7-586f116e81ce',
    'e44d99d4-556d-4644-9e08-4bc01a4bf90e',
    'gas_meter_location',
    'utilities',
    'Gas Meter',
    NULL,
    'cupboards',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Gas Meter
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '29921ac6-1f0d-4acc-9ca0-b4f32d432a62',
    'e44d99d4-556d-4644-9e08-4bc01a4bf90e',
    'gas_meter_location',
    'utilities',
    'Gas Meter',
    NULL,
    'cupboards ',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Gas Meter
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    'a0f69a08-91dd-4b63-98f0-063d592ec5d6',
    'e44d99d4-556d-4644-9e08-4bc01a4bf90e',
    'gas_meter_location',
    'utilities',
    'Gas Meter',
    NULL,
    'cupboards. adequately enclosed in a fire & warning available. upgraded to meet a minimum half hour',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Boiler
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    'e2c29fc8-0976-4222-901e-b9027f34d914',
    'e44d99d4-556d-4644-9e08-4bc01a4bf90e',
    'boiler_location',
    'utilities',
    'Boiler',
    NULL,
    'room. Gas meter',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Boiler
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '80f30355-5d9f-43e4-b840-78359010530b',
    'e44d99d4-556d-4644-9e08-4bc01a4bf90e',
    'boiler_location',
    'utilities',
    'Boiler',
    NULL,
    'room.',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Boiler
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    'b3e4651d-6ab4-4923-8938-dae74c1141a5',
    'e44d99d4-556d-4644-9e08-4bc01a4bf90e',
    'boiler_location',
    'utilities',
    'Boiler',
    NULL,
    'room',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Boiler
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '50b17d32-c617-45e0-a66e-68204ac56155',
    'e44d99d4-556d-4644-9e08-4bc01a4bf90e',
    'boiler_location',
    'utilities',
    'Boiler',
    NULL,
    'room. Gas',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Alarm Panel
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    'ebc3672c-7946-4a0d-b7b4-06548c602be6',
    'e44d99d4-556d-4644-9e08-4bc01a4bf90e',
    'alarm_panel_location',
    'safety',
    'Alarm Panel',
    NULL,
    'The fire detection and warning system appears consistent with a category L3 system and confirmed to',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Fire Alarm
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    'f6641d55-70f4-4b00-9fa1-38478aa341bd',
    'e44d99d4-556d-4644-9e08-4bc01a4bf90e',
    'fire_alarm_location',
    'safety',
    'Fire Alarm',
    NULL,
    'panel',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Fire Alarm
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '5418f8af-cf68-4edf-8417-5ce938bfda1d',
    'e44d99d4-556d-4644-9e08-4bc01a4bf90e',
    'fire_alarm_location',
    'safety',
    'Fire Alarm',
    NULL,
    'activation  No issues identified.',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Fire Alarm
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '47c90c3f-65a9-4101-9e82-3efe5887bf18',
    'e44d99d4-556d-4644-9e08-4bc01a4bf90e',
    'fire_alarm_location',
    'safety',
    'Fire Alarm',
    NULL,
    'is audible / visible in all areas  No issues identified.',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Fire Alarm
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '72ad80c1-c632-4816-8bc7-7f922d5e3177',
    'e44d99d4-556d-4644-9e08-4bc01a4bf90e',
    'fire_alarm_location',
    'safety',
    'Fire Alarm',
    NULL,
    'may not to date records in fire log book.',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Fire Assembly Point
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    'ec577f62-0923-4204-b482-7a125fde59cc',
    'e44d99d4-556d-4644-9e08-4bc01a4bf90e',
    'assembly_point',
    'safety',
    'Fire Assembly Point',
    NULL,
    NULL,
    'identified? N/A Residential property - assembly point is',
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Parking
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '8aa65b72-60f4-441a-8374-af0c03b0e2bc',
    'e44d99d4-556d-4644-9e08-4bc01a4bf90e',
    'parking',
    'general',
    'Parking',
    NULL,
    NULL,
    'Security measures: Intercom door entry. Key access',
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Boiler
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    'b802f303-3a58-4454-897c-72ff27cf9e7f',
    'e44d99d4-556d-4644-9e08-4bc01a4bf90e',
    'boiler_location',
    'utilities',
    'Boiler',
    NULL,
    'Hanworthy Purewell varihear m k2 110 21 Mbar 110 kW/h 0.0004 Yes Yes Yes Pass Yes',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Boiler
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '0bd2bbb9-b1a1-434c-8187-39389d69dd75',
    'e44d99d4-556d-4644-9e08-4bc01a4bf90e',
    'boiler_location',
    'utilities',
    'Boiler',
    NULL,
    'Hanworthy Purewell variheat m k2 110 21 Mbar 110 0.0004 Yes Yes Yes Pass Yes',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Boiler
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '84967d13-6ac3-4d42-884d-bc7f32d29369',
    'e44d99d4-556d-4644-9e08-4bc01a4bf90e',
    'boiler_location',
    'utilities',
    'Boiler',
    NULL,
    'Hanworthy Purewell variheat m k2 110 21 Mbar 110 kW/h 0.0005 Yes Yes Yes Pass Yes',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Boiler
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '45cbf806-2235-4bed-9b7f-c84455d331a9',
    'e44d99d4-556d-4644-9e08-4bc01a4bf90e',
    'boiler_location',
    'utilities',
    'Boiler',
    NULL,
    'room(s)',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: CCTV
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    'bcd57624-0196-4ad2-92ec-36bd5384f65e',
    'e44d99d4-556d-4644-9e08-4bc01a4bf90e',
    'cctv_location',
    'safety',
    'CCTV',
    NULL,
    'equipment',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: CCTV
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '7522d60a-9829-43c1-8220-b24ae33cfc87',
    'e44d99d4-556d-4644-9e08-4bc01a4bf90e',
    'cctv_location',
    'safety',
    'CCTV',
    NULL,
    'equipment. Electrical equipment does not    Restricted access to this 2 2 M Carry out inventory of all portable electrical',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: CCTV
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '5753cbf1-e087-4147-88c2-fc7e22a9f31a',
    'e44d99d4-556d-4644-9e08-4bc01a4bf90e',
    'cctv_location',
    'safety',
    'CCTV',
    NULL,
    'equipment. Carry out inventory of all portable',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Boiler
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    'b4439c4d-86dd-41a6-bfde-8dcb577d25ad',
    'e44d99d4-556d-4644-9e08-4bc01a4bf90e',
    'boiler_location',
    'utilities',
    'Boiler',
    NULL,
    'Room. joints of pipework where pumps',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Boiler
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '818b4e1a-8f06-4b5e-a4e6-f96a3dcc2443',
    'e44d99d4-556d-4644-9e08-4bc01a4bf90e',
    'boiler_location',
    'utilities',
    'Boiler',
    NULL,
    'Room.',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Boiler
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '14beaf09-b028-4977-82f3-e218ab8f8f7a',
    'e44d99d4-556d-4644-9e08-4bc01a4bf90e',
    'boiler_location',
    'utilities',
    'Boiler',
    NULL,
    'Room. electrical switches/isolators and',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Boiler
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '8cd5ff7e-a4f8-4b4a-8c71-e5a9447a451c',
    'e44d99d4-556d-4644-9e08-4bc01a4bf90e',
    'boiler_location',
    'utilities',
    'Boiler',
    NULL,
    'PS545920 Composite Chrysotile 0 - Good Manage 0 - Good Manage 3 - Very Low concealed areas of',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Boiler
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '49f988b0-4ee9-4adf-867b-6074dfee14ee',
    'e44d99d4-556d-4644-9e08-4bc01a4bf90e',
    'boiler_location',
    'utilities',
    'Boiler',
    NULL,
    'PS545924 lagging or & 1 - Fair Manage 1 - Fair Manage 8 - Medium',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Boiler
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '8415cba7-b831-465c-92cd-8a2bd178aa38',
    'e44d99d4-556d-4644-9e08-4bc01a4bf90e',
    'boiler_location',
    'utilities',
    'Boiler',
    NULL,
    'SP545933 within electrical board or Chrysotile 1 - Fair Manage 1 - Fair Manage 6 - Low',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Boiler
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '9ac9f5aa-6cee-4f29-bd30-0f617ef21e12',
    'e44d99d4-556d-4644-9e08-4bc01a4bf90e',
    'boiler_location',
    'utilities',
    'Boiler',
    NULL,
    'room 3 x Boilers - - - - - -',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Boiler
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '1b88e514-ea05-46c0-b494-e5b0aaf4c7ce',
    'e44d99d4-556d-4644-9e08-4bc01a4bf90e',
    'boiler_location',
    'utilities',
    'Boiler',
    NULL,
    'room. Each vessel also has an electrical element fitted.',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Sprinkler
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '3459a410-58d0-4550-a01a-43d4a45bb9df',
    'e44d99d4-556d-4644-9e08-4bc01a4bf90e',
    'sprinkler_location',
    'safety',
    'Sprinkler',
    NULL,
    'and When witnessing tests of sprinkler blow-down and hose reels ensure that there is minimum risk As directed',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Boiler
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '25c9bb84-67e8-49c0-9f44-839fec35b5f5',
    'e44d99d4-556d-4644-9e08-4bc01a4bf90e',
    'boiler_location',
    'utilities',
    'Boiler',
    NULL,
    '2,460 1,980',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Boiler
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    'f3f4f44e-67e6-4075-afb2-9dd6f9ff537e',
    'e44d99d4-556d-4644-9e08-4bc01a4bf90e',
    'boiler_location',
    'utilities',
    'Boiler',
    NULL,
    'Replacement Contribution - 96,04',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Boiler
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '33eefd0d-615c-46bb-80cc-8e62ac970e35',
    'e44d99d4-556d-4644-9e08-4bc01a4bf90e',
    'boiler_location',
    'utilities',
    'Boiler',
    NULL,
    'Replacement (15,840) (72,217)',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Boiler
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '3ddbe0d9-50ff-4400-aeac-c06044db08d1',
    'e44d99d4-556d-4644-9e08-4bc01a4bf90e',
    'boiler_location',
    'utilities',
    'Boiler',
    NULL,
    'replacement. The',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Fire Alarm
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '9331f73b-340c-4b39-81fb-db9e31a6c09f',
    'e44d99d4-556d-4644-9e08-4bc01a4bf90e',
    'fire_alarm_location',
    'safety',
    'Fire Alarm',
    NULL,
    '- (19,752)',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Boiler
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '84e10192-8b69-46b6-92b8-3471da25bc8b',
    'e44d99d4-556d-4644-9e08-4bc01a4bf90e',
    'boiler_location',
    'utilities',
    'Boiler',
    NULL,
    'SERVICE',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Boiler
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '512790e6-778f-4ebf-b45b-3b9382f685cf',
    'e44d99d4-556d-4644-9e08-4bc01a4bf90e',
    'boiler_location',
    'utilities',
    'Boiler',
    NULL,
    'ROOM MAIN CONTROL PANEL',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Boiler
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '766a5ec0-0659-4778-8ccc-c405057ca655',
    'e44d99d4-556d-4644-9e08-4bc01a4bf90e',
    'boiler_location',
    'utilities',
    'Boiler',
    NULL,
    'SERVICE & ISSUE A GAS',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Parking
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '3fa5609f-1bc4-4f10-afc2-a98fe6f36ec0',
    'e44d99d4-556d-4644-9e08-4bc01a4bf90e',
    'parking',
    'general',
    'Parking',
    NULL,
    NULL,
    '£24.00 CONGESTION CHARGE: £15.00 £39.00',
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Boiler
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '0738b747-1377-4545-a487-4d242014c4d6',
    'e44d99d4-556d-4644-9e08-4bc01a4bf90e',
    'boiler_location',
    'utilities',
    'Boiler',
    NULL,
    'Hanworthy Wessex modumaxO mFk2 110c n/a Yes Yes n/a No',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Boiler
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '6b283ec6-c2cc-48fe-b507-f5bfde3a85e3',
    'e44d99d4-556d-4644-9e08-4bc01a4bf90e',
    'boiler_location',
    'utilities',
    'Boiler',
    NULL,
    'Hanworthy Wessex modumaxO mFk2 110c 20 Mbar 110 kW/h 0.0004 Yes Yes Yes Pass Yes',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Boiler
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '6f44c2c0-0b11-499f-98ab-0b644935b5f2',
    'e44d99d4-556d-4644-9e08-4bc01a4bf90e',
    'boiler_location',
    'utilities',
    'Boiler',
    NULL,
    'Hanworthy Wessex modumaxO mFk2 110c 20 Mbar 110 kW/h 0.0003 Yes Yes Yes Pass Yes',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Boiler
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    'ec21d115-1c96-4ef6-a13b-02f8bbd7a4cd',
    'e44d99d4-556d-4644-9e08-4bc01a4bf90e',
    'boiler_location',
    'utilities',
    'Boiler',
    NULL,
    'Hanworthy Wessex modumax mk2 110c',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Boiler
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '895268ea-320f-4e9b-870c-81a5e5b7ca1b',
    'e44d99d4-556d-4644-9e08-4bc01a4bf90e',
    'boiler_location',
    'utilities',
    'Boiler',
    NULL,
    'requires a new gas value so won''t fire up so unable to commission',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Gas Meter
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '661a3432-c296-4f63-90f8-82ab2809cf62',
    'e44d99d4-556d-4644-9e08-4bc01a4bf90e',
    'gas_meter_location',
    'utilities',
    'Gas Meter',
    NULL,
    'reads, monitor your gas',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Gas Meter
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    'd02fb812-a3c8-4b26-9f27-4e8000f75434',
    'e44d99d4-556d-4644-9e08-4bc01a4bf90e',
    'gas_meter_location',
    'utilities',
    'Gas Meter',
    NULL,
    'You can access this data by logging onto your',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Gas Meter
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '124731e4-609d-4760-b21d-b1aecdb4cbf5',
    'e44d99d4-556d-4644-9e08-4bc01a4bf90e',
    'gas_meter_location',
    'utilities',
    'Gas Meter',
    NULL,
    'location and has some knowledge of your',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Gas Meter
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    'dbbb90f7-1ca4-4aee-b253-3e1b97ea96b4',
    'e44d99d4-556d-4644-9e08-4bc01a4bf90e',
    'gas_meter_location',
    'utilities',
    'Gas Meter',
    NULL,
    'Point Ref (MPRN):',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Gas Meter
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '4e2b9f42-0cc2-489f-9afc-5e44d9c99991',
    'e44d99d4-556d-4644-9e08-4bc01a4bf90e',
    'gas_meter_location',
    'utilities',
    'Gas Meter',
    NULL,
    'Point Reference Number: 49431109',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: CCTV
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    'e4a31407-cb57-40d2-bbff-f5b6460da82e',
    'e44d99d4-556d-4644-9e08-4bc01a4bf90e',
    'cctv_location',
    'safety',
    'CCTV',
    NULL,
    'survey completed post drain cleaning works to confirm sewers are left in an operational condition.',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Parking
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '797f4049-6f9e-41ae-8793-514b95544430',
    'e44d99d4-556d-4644-9e08-4bc01a4bf90e',
    'parking',
    'general',
    'Parking',
    NULL,
    NULL,
    'available next to the property to use van mounted jetting',
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Parking
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '0a43510d-b716-4ee6-80f8-8480acd4e563',
    'e44d99d4-556d-4644-9e08-4bc01a4bf90e',
    'parking',
    'general',
    'Parking',
    NULL,
    NULL,
    'tickets are very likely due to parking on this street being Resident permit holders only.',
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Parking
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '86262ded-a06a-4494-ac2f-3c24ed188af3',
    'e44d99d4-556d-4644-9e08-4bc01a4bf90e',
    'parking',
    'general',
    'Parking',
    NULL,
    NULL,
    'tickets that may be issued.',
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Boiler
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '1c622d2c-bb71-4d88-9087-8a4d961a8463',
    'e44d99d4-556d-4644-9e08-4bc01a4bf90e',
    'boiler_location',
    'utilities',
    'Boiler',
    NULL,
    'room and under doors. Found one basement',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Caretaker
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '7f35c06c-3cb2-4356-8018-90c9b583b2c1',
    'e44d99d4-556d-4644-9e08-4bc01a4bf90e',
    'caretaker',
    'general',
    'Caretaker',
    NULL,
    NULL,
    'was not in site but Monitoring visits to continue',
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Caretaker
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '675c5322-6177-42c3-bddc-1fee4595a3b0',
    'e44d99d4-556d-4644-9e08-4bc01a4bf90e',
    'caretaker',
    'general',
    'Caretaker',
    NULL,
    NULL,
    'considering that site has Gap in radiator void on left side still requires to',
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Parking
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    'd742ac33-df09-40ed-9a43-93e749128c5a',
    'e44d99d4-556d-4644-9e08-4bc01a4bf90e',
    'parking',
    'general',
    'Parking',
    NULL,
    NULL,
    '*Customer to supply double socket in plant room. *',
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Boiler
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    'a60909fa-4f6f-4904-a35a-31f2be2ade80',
    'e44d99d4-556d-4644-9e08-4bc01a4bf90e',
    'boiler_location',
    'utilities',
    'Boiler',
    NULL,
    'Room Calorifier WH-01 11/03/2025 Monthly Pass',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Boiler
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '79000fcc-a3c5-4f58-b08c-903c13050c0d',
    'e44d99d4-556d-4644-9e08-4bc01a4bf90e',
    'boiler_location',
    'utilities',
    'Boiler',
    NULL,
    'Room Calorifier WH-02 11/03/2025 Monthly Pass',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Boiler
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '79385267-b42d-4a8b-9ae8-4b0e99a98ab2',
    'e44d99d4-556d-4644-9e08-4bc01a4bf90e',
    'boiler_location',
    'utilities',
    'Boiler',
    NULL,
    'Room Calorifier WH-01 21/07/2025 Monthly Pass',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Boiler
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '9baed851-62f0-4007-859f-7bf2f40811de',
    'e44d99d4-556d-4644-9e08-4bc01a4bf90e',
    'boiler_location',
    'utilities',
    'Boiler',
    NULL,
    'Room Calorifier WH-02 21/07/2025 Monthly Fail',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Boiler
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    'f46e04da-f231-4300-9d49-71f4742c80ca',
    'e44d99d4-556d-4644-9e08-4bc01a4bf90e',
    'boiler_location',
    'utilities',
    'Boiler',
    NULL,
    'Room Calorifier WH-01 30/04/2025 Monthly Pass',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Boiler
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '665f79a3-e560-457a-bbeb-2e43f967ce15',
    'e44d99d4-556d-4644-9e08-4bc01a4bf90e',
    'boiler_location',
    'utilities',
    'Boiler',
    NULL,
    'Room Calorifier WH-02 30/04/2025 Monthly Pass',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Boiler
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    'a69459cf-a12e-4ef4-b8d1-1589c58cd28d',
    'e44d99d4-556d-4644-9e08-4bc01a4bf90e',
    'boiler_location',
    'utilities',
    'Boiler',
    NULL,
    'Room Calorifier WH-01 30/09/2024 Monthly Pass',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Boiler
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '5cacd7ff-e4d9-4e62-bc96-ef3e6e4802e7',
    'e44d99d4-556d-4644-9e08-4bc01a4bf90e',
    'boiler_location',
    'utilities',
    'Boiler',
    NULL,
    'Room Calorifier WH-02 30/09/2024 Monthly Pass',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Boiler
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    'e5a585a7-d4e3-4e50-be68-dbc3f9dd2f52',
    'e44d99d4-556d-4644-9e08-4bc01a4bf90e',
    'boiler_location',
    'utilities',
    'Boiler',
    NULL,
    'Room Calorifier WH-01 26/06/2024 Monthly Pass',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Boiler
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '32d803ff-d86b-4068-b570-233879b6af7e',
    'e44d99d4-556d-4644-9e08-4bc01a4bf90e',
    'boiler_location',
    'utilities',
    'Boiler',
    NULL,
    'Room Calorifier WH-02 26/06/2024 Monthly Pass',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Boiler
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    'cc082547-94e6-422f-8a0a-b286b863d4b3',
    'e44d99d4-556d-4644-9e08-4bc01a4bf90e',
    'boiler_location',
    'utilities',
    'Boiler',
    NULL,
    'Room Calorifier WH-01 02/10/2024 Monthly Pass',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Boiler
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '9eb23832-4a16-4735-a5b1-ab103f78a902',
    'e44d99d4-556d-4644-9e08-4bc01a4bf90e',
    'boiler_location',
    'utilities',
    'Boiler',
    NULL,
    'Room Calorifier WH-02 02/10/2024 Monthly Pass',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Boiler
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '904a92f7-0023-4fe9-a514-55edd46c44be',
    'e44d99d4-556d-4644-9e08-4bc01a4bf90e',
    'boiler_location',
    'utilities',
    'Boiler',
    NULL,
    'Room Calorifier WH-01 28/03/2024 Monthly Pass',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Boiler
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    'fbf0d0db-221c-4029-afd2-e1f764dc45c6',
    'e44d99d4-556d-4644-9e08-4bc01a4bf90e',
    'boiler_location',
    'utilities',
    'Boiler',
    NULL,
    'Room Calorifier WH-02 28/03/2024 Monthly Fail',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Water Meter
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '5e2a2e8c-e659-4ddf-afda-9569596650cc',
    'e44d99d4-556d-4644-9e08-4bc01a4bf90e',
    'water_meter_location',
    'utilities',
    'Water Meter',
    NULL,
    'NON-RETURN DOUBLE CHECK VALVE TEMPERATURE PRESSURE GAUGE IWH: INSTANTANEOUS WATER HEATER PRESSURE RELIEF VALVE H PO IU U : W HE H A : T P O IN IN TE T R O F F A U C S E E U W NI A T TER HEATER CWH COM...',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Boiler
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '2d900391-f277-4f24-b9f8-99a886f13f02',
    'e44d99d4-556d-4644-9e08-4bc01a4bf90e',
    'boiler_location',
    'utilities',
    'Boiler',
    NULL,
    'MIXER TAP EXPANSION VESSEL',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Boiler
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '5e1f7892-d9ba-40d8-83ff-bff69821d8ad',
    'e44d99d4-556d-4644-9e08-4bc01a4bf90e',
    'boiler_location',
    'utilities',
    'Boiler',
    NULL,
    'WM WASHING MACHINE WATER SOFTENER IM ICE MACHINE',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Boiler
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '25383fb3-e8cb-42e8-80b0-b108888c120a',
    'e44d99d4-556d-4644-9e08-4bc01a4bf90e',
    'boiler_location',
    'utilities',
    'Boiler',
    NULL,
    'ROOM',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Fire Alarm
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '2bb11730-3713-43f1-b985-5226f191cb80',
    'e44d99d4-556d-4644-9e08-4bc01a4bf90e',
    'fire_alarm_location',
    'safety',
    'Fire Alarm',
    NULL,
    'Return/Recall: Is a fire alarm return/recall facility fitted? No',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Fire Alarm
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '64edc8c6-23a2-43ba-b5d0-05d72364701c',
    'e44d99d4-556d-4644-9e08-4bc01a4bf90e',
    'fire_alarm_location',
    'safety',
    'Fire Alarm',
    NULL,
    '& Emergency Lights - FA7817',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Fire Alarm
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    'd51d7f45-ea84-43a3-8f50-4e6f1c06b51e',
    'e44d99d4-556d-4644-9e08-4bc01a4bf90e',
    'fire_alarm_location',
    'safety',
    'Fire Alarm',
    NULL,
    'contract which consists of x2 6 Monthly Visits Fire Alarm-Firetech. The increase on costs is based on the',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Boiler
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '7f6e38d8-0f5e-4026-9a13-ba25aba897d9',
    'e44d99d4-556d-4644-9e08-4bc01a4bf90e',
    'boiler_location',
    'utilities',
    'Boiler',
    NULL,
    'Maint - -4,027.20 -4,027.20',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Boiler
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    'b08804c4-b00b-4cc9-b357-9dd4cd068be3',
    'e44d99d4-556d-4644-9e08-4bc01a4bf90e',
    'boiler_location',
    'utilities',
    'Boiler',
    NULL,
    'Repairs & Maintenance - SCHEDULE 1',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Boiler
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    'e00741d4-2bb7-49a1-9a08-4bcbc94be19b',
    'e44d99d4-556d-4644-9e08-4bc01a4bf90e',
    'boiler_location',
    'utilities',
    'Boiler',
    NULL,
    '- - 2,100.00 2,100.00',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Boiler
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '12833f05-5b38-4f40-9329-9bf5acda3e0a',
    'e44d99d4-556d-4644-9e08-4bc01a4bf90e',
    'boiler_location',
    'utilities',
    'Boiler',
    NULL,
    'Repairs At 32/34 Connaught Square - 290.54 290.54',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Boiler
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    'adeaceb8-313c-482f-abce-c9232f98fb7b',
    'e44d99d4-556d-4644-9e08-4bc01a4bf90e',
    'boiler_location',
    'utilities',
    'Boiler',
    NULL,
    'Repairs At 32/34 Connaught Square - 814.80 814.80',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Boiler
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    'ec075665-ef7e-481b-9ce6-4e3d5df515d5',
    'e44d99d4-556d-4644-9e08-4bc01a4bf90e',
    'boiler_location',
    'utilities',
    'Boiler',
    NULL,
    '- 705.60 705.60',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Fire Alarm
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    'dba2f21a-a52d-442d-af89-02d9c4404949',
    'e44d99d4-556d-4644-9e08-4bc01a4bf90e',
    'fire_alarm_location',
    'safety',
    'Fire Alarm',
    NULL,
    'maintenance - 172.80 172.80',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Fire Alarm
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '47de828c-b9b8-4d72-9b90-e715ac8b45ca',
    'e44d99d4-556d-4644-9e08-4bc01a4bf90e',
    'fire_alarm_location',
    'safety',
    'Fire Alarm',
    NULL,
    'Works At 32/34 Connaught - 828.00 828.00',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Fire Alarm
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '28e61042-cb6e-42a6-9f88-ebd8507e854c',
    'e44d99d4-556d-4644-9e08-4bc01a4bf90e',
    'fire_alarm_location',
    'safety',
    'Fire Alarm',
    NULL,
    'Call Out At 32/34 Connaught Square - 243.60 243.60',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Fire Alarm
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '8edbd532-70dc-400d-9611-a04648278822',
    'e44d99d4-556d-4644-9e08-4bc01a4bf90e',
    'fire_alarm_location',
    'safety',
    'Fire Alarm',
    NULL,
    'At 32/34 Connaught Square - 213.60 213.60',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Fire Alarm
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '0aa24d63-fa08-4e99-908b-c458f20ebb25',
    'e44d99d4-556d-4644-9e08-4bc01a4bf90e',
    'fire_alarm_location',
    'safety',
    'Fire Alarm',
    NULL,
    '- 213.60 213.60',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Fire Alarm
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    'c9c75519-7b82-47a0-b2e3-47227cdee15c',
    'e44d99d4-556d-4644-9e08-4bc01a4bf90e',
    'fire_alarm_location',
    'safety',
    'Fire Alarm',
    NULL,
    'service - Aug 24 - 504.00 504.00',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Fire Alarm
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    'd50c63a1-b5a6-4aa7-95f4-ab3f57f61f0c',
    'e44d99d4-556d-4644-9e08-4bc01a4bf90e',
    'fire_alarm_location',
    'safety',
    'Fire Alarm',
    NULL,
    'testing 01.06.24-31.08.24 - 72.00 72.00',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Fire Alarm
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '0265b59d-5fc9-4d18-b16b-f319ebf2c2bd',
    'e44d99d4-556d-4644-9e08-4bc01a4bf90e',
    'fire_alarm_location',
    'safety',
    'Fire Alarm',
    NULL,
    '& Emergency Light Service - 624.00 624.00',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Fire Alarm
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '98a5b1d5-61fb-4f00-a151-40bc4e9748f4',
    'e44d99d4-556d-4644-9e08-4bc01a4bf90e',
    'fire_alarm_location',
    'safety',
    'Fire Alarm',
    NULL,
    'Maintenance - 172.80 172.80',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Fire Alarm
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '3304480f-713f-4db2-8c88-bf410bbfb55a',
    'e44d99d4-556d-4644-9e08-4bc01a4bf90e',
    'fire_alarm_location',
    'safety',
    'Fire Alarm',
    NULL,
    'Bell - 72.00 72.00',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: CCTV
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '0a4c6e7c-2573-45e4-9971-d4dd02ff2760',
    'e44d99d4-556d-4644-9e08-4bc01a4bf90e',
    'cctv_location',
    'safety',
    'CCTV',
    NULL,
    'Survey to leaking stack - 1,020.00 1,020.00',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Boiler
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '2dcedf28-2d92-4bb1-a3d1-f46db93a16d4',
    'e44d99d4-556d-4644-9e08-4bc01a4bf90e',
    'boiler_location',
    'utilities',
    'Boiler',
    NULL,
    '4,998 2,460',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Boiler
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '296a8c64-0960-4bc2-b5d3-3b6cdeabdc2c',
    'e44d99d4-556d-4644-9e08-4bc01a4bf90e',
    'boiler_location',
    'utilities',
    'Boiler',
    NULL,
    'Replacement - (15,840)',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Boiler
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    'f070c40b-ec95-44b6-b124-4b18b0660d6d',
    'e44d99d4-556d-4644-9e08-4bc01a4bf90e',
    'boiler_location',
    'utilities',
    'Boiler',
    NULL,
    'replacement (1,501) -',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Boiler
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '21d1e513-7011-494f-bf93-1f21fd435aef',
    'e44d99d4-556d-4644-9e08-4bc01a4bf90e',
    'boiler_location',
    'utilities',
    'Boiler',
    NULL,
    'maintenance 2,100.00 9,101.14 3,054.13',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: CCTV
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    'c3cec338-d32c-4a5e-a811-7edbf3df8859',
    'e44d99d4-556d-4644-9e08-4bc01a4bf90e',
    'cctv_location',
    'safety',
    'CCTV',
    NULL,
    'that has been installed on the basement floor which now ensures that we have 4 CCTV cameras which cost Martin a total of £3500. The other directors had also requested the costing that it would be to i...',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Caretaker
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    'fcbebf12-cfe4-4071-906b-5b6f1860c90c',
    'e44d99d4-556d-4644-9e08-4bc01a4bf90e',
    'caretaker',
    'general',
    'Caretaker',
    NULL,
    NULL,
    'as to why this may be opened, as the directors would prefer that this is permanently closed for the safety of the residents. Also to improve safety, the door between the basement floor and ground floo...',
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Boiler
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '5444d593-484a-40e1-bc21-ef7234c005cb',
    'e44d99d4-556d-4644-9e08-4bc01a4bf90e',
    'boiler_location',
    'utilities',
    'Boiler',
    NULL,
    'and Pressure Plant at the Location owned by or leased',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Boiler
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '70d82831-2e4e-44cf-9f91-4a76d4a8d97b',
    'e44d99d4-556d-4644-9e08-4bc01a4bf90e',
    'boiler_location',
    'utilities',
    'Boiler',
    NULL,
    'and Pressure Plant',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Boiler
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    'e621ff0b-b8c3-4f81-a068-e1befa5c3692',
    'e44d99d4-556d-4644-9e08-4bc01a4bf90e',
    'boiler_location',
    'utilities',
    'Boiler',
    NULL,
    'Boiler and Pressure Plant itemised in the Plant Schedule unless',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Boiler
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '63cc7921-0dfc-4158-9431-fa38ee3ddb8d',
    'e44d99d4-556d-4644-9e08-4bc01a4bf90e',
    'boiler_location',
    'utilities',
    'Boiler',
    NULL,
    'and Pressure Plant)',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Boiler
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '90d06faf-0c8f-437b-9689-ad53f6a11f6d',
    'e44d99d4-556d-4644-9e08-4bc01a4bf90e',
    'boiler_location',
    'utilities',
    'Boiler',
    NULL,
    'will',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Boiler
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '6587b90d-aebf-40cf-9ff0-62d659958d24',
    'e44d99d4-556d-4644-9e08-4bc01a4bf90e',
    'boiler_location',
    'utilities',
    'Boiler',
    NULL,
    'and Pressure Plant) while in use arising a tanks or similar containers other than Fuel Storage Tanks',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Boiler
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '50b138a6-c845-4d9b-8c1f-d46cf70ebf4e',
    'e44d99d4-556d-4644-9e08-4bc01a4bf90e',
    'boiler_location',
    'utilities',
    'Boiler',
    NULL,
    'and Pressure Plant) causing sudden stoppage',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Boiler
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '1a414d48-e3ed-4998-a517-b1f49e2798c4',
    'e44d99d4-556d-4644-9e08-4bc01a4bf90e',
    'boiler_location',
    'utilities',
    'Boiler',
    NULL,
    'and Pressure Plant caused by',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Boiler
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '9e2bbf09-27de-49c7-a377-4f5696cb470a',
    'e44d99d4-556d-4644-9e08-4bc01a4bf90e',
    'boiler_location',
    'utilities',
    'Boiler',
    NULL,
    'and Pressure Plant by force',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Boiler
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '6445b95a-ee82-4f80-8f9a-a472342b455b',
    'e44d99d4-556d-4644-9e08-4bc01a4bf90e',
    'boiler_location',
    'utilities',
    'Boiler',
    NULL,
    'and Pressure A fixing bolts or appliances that the track or the supporting',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Boiler
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    'bd79c73a-987a-4532-8264-9bca004a8eb9',
    'e44d99d4-556d-4644-9e08-4bc01a4bf90e',
    'boiler_location',
    'utilities',
    'Boiler',
    NULL,
    'Pressure and Mechanical Plant',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Boiler
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    'ed120342-ac33-4ea5-a8b1-2a262183b40c',
    'e44d99d4-556d-4644-9e08-4bc01a4bf90e',
    'boiler_location',
    'utilities',
    'Boiler',
    NULL,
    'and Pressure Plant insured by Cover Options One or Two.',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Boiler
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '4b42e00c-aba8-4d8c-9ff0-2325d1c4bf3e',
    'e44d99d4-556d-4644-9e08-4bc01a4bf90e',
    'boiler_location',
    'utilities',
    'Boiler',
    NULL,
    'and Pressure Plant this clause',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Boiler
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '16dd04ce-2e5e-4656-b7ec-311eb681f48e',
    'e44d99d4-556d-4644-9e08-4bc01a4bf90e',
    'boiler_location',
    'utilities',
    'Boiler',
    NULL,
    '2 x Hot water calorifier',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Boiler
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '6e36b11f-bc03-4274-a379-bc4135163aa6',
    'e44d99d4-556d-4644-9e08-4bc01a4bf90e',
    'boiler_location',
    'utilities',
    'Boiler',
    NULL,
    'EV Charging Points 0',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Boiler
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    'c69317e9-994b-44c8-a4b9-2e5c32a904ad',
    'e44d99d4-556d-4644-9e08-4bc01a4bf90e',
    'boiler_location',
    'utilities',
    'Boiler',
    NULL,
    '(electrode) < 500,000 BTUs 12mth 1 1',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Boiler
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '41fa72d6-096a-4f83-b529-92ec0d83b62d',
    'e44d99d4-556d-4644-9e08-4bc01a4bf90e',
    'boiler_location',
    'utilities',
    'Boiler',
    NULL,
    '1x Motorised Valve',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Sprinkler
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '53232231-c819-42c1-b8bf-d9d829c3b463',
    'e44d99d4-556d-4644-9e08-4bc01a4bf90e',
    'sprinkler_location',
    'safety',
    'Sprinkler',
    NULL,
    'leakage, impact by',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Sprinkler
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    'e9aa33e8-9275-449e-9fa8-4767b60fd268',
    'e44d99d4-556d-4644-9e08-4bc01a4bf90e',
    'sprinkler_location',
    'safety',
    'Sprinkler',
    NULL,
    'Installation',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Sprinkler
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '6881e802-cc8a-4a5c-ad2f-9e75972cc35f',
    'e44d99d4-556d-4644-9e08-4bc01a4bf90e',
    'sprinkler_location',
    'safety',
    'Sprinkler',
    NULL,
    'Installations adjustments at the end of the Indemnity Period.',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Sprinkler
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '3d23462c-4412-4ee0-b46e-e9717cd3eab0',
    'e44d99d4-556d-4644-9e08-4bc01a4bf90e',
    'sprinkler_location',
    'safety',
    'Sprinkler',
    NULL,
    'installation at the Premises by any Cover insured hereby in the event that on repair or reinstatement thereof G37 Renewal',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Sprinkler
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '422f42c4-5330-45cf-8a8a-2b79d71b9c8a',
    'e44d99d4-556d-4644-9e08-4bc01a4bf90e',
    'sprinkler_location',
    'safety',
    'Sprinkler',
    NULL,
    'The Insured will prior to each renewal provide the Insurers with the Estimated Rent Receivable for the financial year',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Sprinkler
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '1a008f71-70cb-47f8-98f1-ee416c0a7beb',
    'e44d99d4-556d-4644-9e08-4bc01a4bf90e',
    'sprinkler_location',
    'safety',
    'Sprinkler',
    NULL,
    'Leakage or Theft if insured will then be £500 or the Excess stated in the',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Sprinkler
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    'a8797df3-a880-4dfd-befe-9847c48699b4',
    'e44d99d4-556d-4644-9e08-4bc01a4bf90e',
    'sprinkler_location',
    'safety',
    'Sprinkler',
    NULL,
    'systems are installed and water supplies must be maintained heating is being maintained at a',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Sprinkler
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '26127edf-abab-4b56-88a9-e1e9bacb7f53',
    'e44d99d4-556d-4644-9e08-4bc01a4bf90e',
    'sprinkler_location',
    'safety',
    'Sprinkler',
    NULL,
    'Leakage or Theft if insured will be £500 or the Excess stated in the Schedule or Folio whichever is',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Sprinkler
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    'dac7592d-5f38-4412-ad0f-e24f8e3a373a',
    'e44d99d4-556d-4644-9e08-4bc01a4bf90e',
    'sprinkler_location',
    'safety',
    'Sprinkler',
    NULL,
    'systems are installed and water supplies must be maintained heating is being maintained at a Unoccupied area becoming evident or known to the Insured or their authorised representative.',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Sprinkler
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '494f2049-08d9-46e1-9802-7ede133e8d6d',
    'e44d99d4-556d-4644-9e08-4bc01a4bf90e',
    'sprinkler_location',
    'safety',
    'Sprinkler',
    NULL,
    'systems are installed and water supplies must be maintained heating is being maintained at a property in course of construction or erection other than as specifically allowed for under the Contract Al...',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Sprinkler
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    'd0b92838-b365-4d61-ac84-1261818a921a',
    'e44d99d4-556d-4644-9e08-4bc01a4bf90e',
    'sprinkler_location',
    'safety',
    'Sprinkler',
    NULL,
    'system), impact of aircraft or any aerial devices or articles',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Parking
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    'ad6d3b31-41ce-4304-af0a-9a4b90e80453',
    'e44d99d4-556d-4644-9e08-4bc01a4bf90e',
    'parking',
    'general',
    'Parking',
    NULL,
    NULL,
    'current Period of Insurance the Insured had become aware of circumstances which have or may give rise to such The Insurers will indemnify the Insured named in the Schedule and no other for the purpose...',
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Stopcock
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '83c4bca7-2aa2-48dd-8c6c-d02faa886ef4',
    'e44d99d4-556d-4644-9e08-4bc01a4bf90e',
    'stopcock_location',
    'utilities',
    'Stopcock',
    NULL,
    'serving the Premises',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Boiler
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '1ac852a3-864e-4e5d-837c-dbc1f276a771',
    'e44d99d4-556d-4644-9e08-4bc01a4bf90e',
    'boiler_location',
    'utilities',
    'Boiler',
    NULL,
    '(not being used for domestic purposes',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Boiler
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '910f748a-3694-4433-9c01-92dbcf9d072c',
    'e44d99d4-556d-4644-9e08-4bc01a4bf90e',
    'boiler_location',
    'utilities',
    'Boiler',
    NULL,
    'or economiser on the Premises.',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Fire Alarm
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '2a50371d-8805-4308-8575-57327df26f4d',
    'e44d99d4-556d-4644-9e08-4bc01a4bf90e',
    'fire_alarm_location',
    'safety',
    'Fire Alarm',
    NULL,
    'The Policyholder undertakes the following when there is an automatic fire alarm system in any of the Premises',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Fire Alarm
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '6eaf6cd8-d895-459d-9227-761d10237683',
    'e44d99d4-556d-4644-9e08-4bc01a4bf90e',
    'fire_alarm_location',
    'safety',
    'Fire Alarm',
    NULL,
    'system using the Company’s proper',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Fire Alarm
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '593d0bf8-fdba-441a-b7fc-b1e6721046e0',
    'e44d99d4-556d-4644-9e08-4bc01a4bf90e',
    'fire_alarm_location',
    'safety',
    'Fire Alarm',
    NULL,
    'and promptly to carry out such',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Fire Alarm
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '1f9a0292-e206-40d1-a6e6-be5065037479',
    'e44d99d4-556d-4644-9e08-4bc01a4bf90e',
    'fire_alarm_location',
    'safety',
    'Fire Alarm',
    NULL,
    'system due to',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Sprinkler
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '41b117ed-6c51-4642-8231-8e86213f3543',
    'e44d99d4-556d-4644-9e08-4bc01a4bf90e',
    'sprinkler_location',
    'safety',
    'Sprinkler',
    NULL,
    'leakage impact by any road vehicle or',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Sprinkler
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    'c2f373f0-4b60-4d27-8f98-934745d83086',
    'e44d99d4-556d-4644-9e08-4bc01a4bf90e',
    'sprinkler_location',
    'safety',
    'Sprinkler',
    NULL,
    'tanks',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Parking
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '40f877bb-93d8-4a5e-a338-92fa90891087',
    'e44d99d4-556d-4644-9e08-4bc01a4bf90e',
    'parking',
    'general',
    'Parking',
    NULL,
    NULL,
    'offence.',
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Parking
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '11eaec19-546a-475d-a68c-97be25ff2e23',
    'e44d99d4-556d-4644-9e08-4bc01a4bf90e',
    'parking',
    'general',
    'Parking',
    NULL,
    NULL,
    'offence',
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Boiler
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    'a63d7e86-4b1f-4449-87c4-5cddc92f25a7',
    'e44d99d4-556d-4644-9e08-4bc01a4bf90e',
    'boiler_location',
    'utilities',
    'Boiler',
    NULL,
    'Room Calorifier WH-01 15/11/2023 Monthly Pass',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Boiler
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '60c48fab-e059-4e84-b5e4-213665a612ad',
    'e44d99d4-556d-4644-9e08-4bc01a4bf90e',
    'boiler_location',
    'utilities',
    'Boiler',
    NULL,
    'Room Calorifier WH-02 15/11/2023 Monthly Pass',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Boiler
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '3632dd61-a678-4f29-8e54-00acd66e6d83',
    'e44d99d4-556d-4644-9e08-4bc01a4bf90e',
    'boiler_location',
    'utilities',
    'Boiler',
    NULL,
    'Room Calorifier WH-01 15/11/2023 Six Monthly Pass',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Boiler
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    'f3ea9e1a-e1d7-4c41-a545-6b9b769f2a16',
    'e44d99d4-556d-4644-9e08-4bc01a4bf90e',
    'boiler_location',
    'utilities',
    'Boiler',
    NULL,
    'Room Calorifier WH-02 15/11/2023 Six Monthly Pass',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Gas Meter
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    'c1982936-13b4-4187-b61c-6f340b759a4d',
    'e44d99d4-556d-4644-9e08-4bc01a4bf90e',
    'gas_meter_location',
    'utilities',
    'Gas Meter',
    NULL,
    'cupboards. adequately enclosed in a fire & warning available. a minimum half hour standard of fire',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Boiler
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '3639c437-5a40-4bc9-bccd-4244373caaf9',
    'e44d99d4-556d-4644-9e08-4bc01a4bf90e',
    'boiler_location',
    'utilities',
    'Boiler',
    NULL,
    'room - Missing Deficiencies observed in    Automatic fire detection 2 1 L Install intumescent strips and smoke seals in',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Boiler
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '47d159d6-fece-4618-aece-c99b2cb4e291',
    'e44d99d4-556d-4644-9e08-4bc01a4bf90e',
    'boiler_location',
    'utilities',
    'Boiler',
    NULL,
    'room - Missing',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Boiler
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '59391147-d660-4521-a94d-724bceb5158b',
    'e44d99d4-556d-4644-9e08-4bc01a4bf90e',
    'boiler_location',
    'utilities',
    'Boiler',
    NULL,
    'room - Missing Install intumescent strips and smoke',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Alarm Panel
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '9a9e7f55-1fcc-4b66-a8d3-d8fb73a4be1b',
    'e44d99d4-556d-4644-9e08-4bc01a4bf90e',
    'alarm_panel_location',
    'safety',
    'Alarm Panel',
    NULL,
    'The fire detection and warning system appears consistent with a category L4 system with no confirmation',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Alarm Panel
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '0938a997-e669-4935-a443-4a9f64754c8e',
    'e44d99d4-556d-4644-9e08-4bc01a4bf90e',
    'alarm_panel_location',
    'safety',
    'Alarm Panel',
    NULL,
    'for ease of reference. The',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Fire Alarm
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    'cd1f3dbb-50b4-43ad-9b5b-2b1981f23aac',
    'e44d99d4-556d-4644-9e08-4bc01a4bf90e',
    'fire_alarm_location',
    'safety',
    'Fire Alarm',
    NULL,
    'activation X Not checked.',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Fire Alarm
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    'e8674fb5-496d-426b-8a9e-c0e04b22a9b5',
    'e44d99d4-556d-4644-9e08-4bc01a4bf90e',
    'fire_alarm_location',
    'safety',
    'Fire Alarm',
    NULL,
    'is audible / visible in all areas N/A Unable to confirm due to the alarm not',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Fire Alarm
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '1dfe1f50-65ff-4032-b7fb-ebbf95275196',
    'e44d99d4-556d-4644-9e08-4bc01a4bf90e',
    'fire_alarm_location',
    'safety',
    'Fire Alarm',
    NULL,
    'service engineer to',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Fire Alarm
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '8991db71-7bd5-47c9-b0dd-73f195c6aca7',
    'e44d99d4-556d-4644-9e08-4bc01a4bf90e',
    'fire_alarm_location',
    'safety',
    'Fire Alarm',
    NULL,
    'alarm system and locate on or adjacent to the',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Fire Alarm
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '14ac1efc-5487-4935-9955-f8e51ce63f4a',
    'e44d99d4-556d-4644-9e08-4bc01a4bf90e',
    'fire_alarm_location',
    'safety',
    'Fire Alarm',
    NULL,
    'panel for ease of reference. The',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Fire Alarm
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    'fd1a3a11-3895-4b21-9c6f-a8bd1661f67e',
    'e44d99d4-556d-4644-9e08-4bc01a4bf90e',
    'fire_alarm_location',
    'safety',
    'Fire Alarm',
    NULL,
    'service',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Fire Alarm
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '73953782-80fd-4942-8697-eb1c420f3d68',
    'e44d99d4-556d-4644-9e08-4bc01a4bf90e',
    'fire_alarm_location',
    'safety',
    'Fire Alarm',
    NULL,
    'system and locate on',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: CCTV
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '0a7a6d51-4832-4722-8c9b-08c136a2070d',
    'e44d99d4-556d-4644-9e08-4bc01a4bf90e',
    'cctv_location',
    'safety',
    'CCTV',
    NULL,
    'equipment. Electrical equipment does not    Restricted access to this 2 2 M Carry out inventory of all portable electrical',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Boiler
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '74e8b0cb-9f7a-48a3-8a3b-af207c135c41',
    'e44d99d4-556d-4644-9e08-4bc01a4bf90e',
    'boiler_location',
    'utilities',
    'Boiler',
    NULL,
    'ROOM VENTILATION ITEM 6M (2 VISITS) INCL.',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Parking
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    'f2132ff7-f768-45a6-8947-4ac5c46ce299',
    'e44d99d4-556d-4644-9e08-4bc01a4bf90e',
    'parking',
    'general',
    'Parking',
    NULL,
    NULL,
    'facility for use by Quotehedge’s personnel',
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Parking
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '9c1c41cb-350c-41bd-81ad-48f6be0622c2',
    'e44d99d4-556d-4644-9e08-4bc01a4bf90e',
    'parking',
    'general',
    'Parking',
    NULL,
    NULL,
    'and Congestion charges will be added at cost where applicable.',
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Boiler
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '50f7506a-07cc-49eb-9867-8ba941ca157b',
    'e44d99d4-556d-4644-9e08-4bc01a4bf90e',
    'boiler_location',
    'utilities',
    'Boiler',
    NULL,
    'Hamworthy Purewell Variheat OMFK2 110 kW/h Yes Yes Yes Pass Yes',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Boiler
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '38002e2c-c6e5-4bb6-b40c-96f4c8fff1db',
    'e44d99d4-556d-4644-9e08-4bc01a4bf90e',
    'boiler_location',
    'utilities',
    'Boiler',
    NULL,
    'number one.',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Boiler
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '94bafd04-b5a4-4761-96ec-6250f5200eef',
    'e44d99d4-556d-4644-9e08-4bc01a4bf90e',
    'boiler_location',
    'utilities',
    'Boiler',
    NULL,
    'with isolated on arrival so removed defective gas valve and installed new gas valve.',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Boiler
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '72d6c558-3743-4ae8-8334-bd114081a1f2',
    'e44d99d4-556d-4644-9e08-4bc01a4bf90e',
    'boiler_location',
    'utilities',
    'Boiler',
    NULL,
    'and fired up boiler to purge gas supply.',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Boiler
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '5ad3b92b-9049-40d7-b22a-54c636fe7439',
    'e44d99d4-556d-4644-9e08-4bc01a4bf90e',
    'boiler_location',
    'utilities',
    'Boiler',
    NULL,
    'and set up gas valve so that boiler is burning within manufacturers',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Boiler
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    'ce19191a-43b0-4be5-a6c5-ecc122176bfb',
    'e44d99d4-556d-4644-9e08-4bc01a4bf90e',
    'boiler_location',
    'utilities',
    'Boiler',
    NULL,
    'safety device all ok.',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Boiler
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '86d16a20-e880-41aa-9699-4810f873eabd',
    'e44d99d4-556d-4644-9e08-4bc01a4bf90e',
    'boiler_location',
    'utilities',
    'Boiler',
    NULL,
    'temperatures to 80 degrees Celsius.',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Boiler
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    'ea01fc4b-0bbb-42f9-baae-00399780821c',
    'e44d99d4-556d-4644-9e08-4bc01a4bf90e',
    'boiler_location',
    'utilities',
    'Boiler',
    NULL,
    'gas valve',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Boiler
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '26ca6028-b502-4931-af19-0e4dd8e115e6',
    'e44d99d4-556d-4644-9e08-4bc01a4bf90e',
    'boiler_location',
    'utilities',
    'Boiler',
    NULL,
    'MOTORISED VALVE The cables should be provided with a gland where they enter the square section of',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Boiler
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    'bc93c760-19c6-4dfc-8d9d-a2325223f077',
    'e44d99d4-556d-4644-9e08-4bc01a4bf90e',
    'boiler_location',
    'utilities',
    'Boiler',
    NULL,
    'HWS PUMP & MOTOR The cable is overly long and is tangled up with other cables - we recommend that it be',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Boiler
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '5b6cbc6c-99e9-4d4b-8acc-77f51b2ce218',
    'e44d99d4-556d-4644-9e08-4bc01a4bf90e',
    'boiler_location',
    'utilities',
    'Boiler',
    NULL,
    'ROOM MOTORISED VALVE S2860P10 3A 24/06/2025 24/06/2026',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Boiler
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '39dbbf35-96c7-4fb2-9120-c4ae2fb05d38',
    'e44d99d4-556d-4644-9e08-4bc01a4bf90e',
    'boiler_location',
    'utilities',
    'Boiler',
    NULL,
    'ROOM HEATING PUMP & MOTOR 10001822 1.1KW 24/06/2025 24/06/2026',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Boiler
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '3e3fb460-cff5-4d9e-8083-e52245135a2a',
    'e44d99d4-556d-4644-9e08-4bc01a4bf90e',
    'boiler_location',
    'utilities',
    'Boiler',
    NULL,
    'ROOM HWS PUMP & MOTOR 10063193 0.75KW 24/06/2025 24/06/2026',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Boiler
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    'edfe3f83-d294-4fab-b089-f4c8eda006d1',
    'e44d99d4-556d-4644-9e08-4bc01a4bf90e',
    'boiler_location',
    'utilities',
    'Boiler',
    NULL,
    'ROOM HEATING PUMP & MOTOR 10000610 0.75 24/06/2025 24/06/2026',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Boiler
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    'bf8c83f1-72ea-4a9d-998c-880bc9aa391b',
    'e44d99d4-556d-4644-9e08-4bc01a4bf90e',
    'boiler_location',
    'utilities',
    'Boiler',
    NULL,
    'rooms etc. Thereafter for the',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Fire Alarm
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    'd51dc143-5204-4504-8c36-4019d3a04369',
    'e44d99d4-556d-4644-9e08-4bc01a4bf90e',
    'fire_alarm_location',
    'safety',
    'Fire Alarm',
    NULL,
    'system and emergency lights at the',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Fire Alarm
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '96756e8b-478a-447c-a92a-4d41efc6288d',
    'e44d99d4-556d-4644-9e08-4bc01a4bf90e',
    'fire_alarm_location',
    'safety',
    'Fire Alarm',
    NULL,
    '& Emergency Lights Maintenance Proposal',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Fire Alarm
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '17e5ac62-bc29-4da5-befe-a8f817b0a24c',
    'e44d99d4-556d-4644-9e08-4bc01a4bf90e',
    'fire_alarm_location',
    'safety',
    'Fire Alarm',
    NULL,
    'system be serviced on a six-monthly basis (2 visits',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Fire Alarm
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '3adf89b8-21f7-4697-91a8-03c968097ade',
    'e44d99d4-556d-4644-9e08-4bc01a4bf90e',
    'fire_alarm_location',
    'safety',
    'Fire Alarm',
    NULL,
    'Periodic Maintenance',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Fire Alarm
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '2358595f-4819-425c-a643-7fbfd55e831e',
    'e44d99d4-556d-4644-9e08-4bc01a4bf90e',
    'fire_alarm_location',
    'safety',
    'Fire Alarm',
    NULL,
    'systems for buildings —Part 1: Code of practice for system design, installation,',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Fire Alarm
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '4139d38c-59d6-45a7-829f-913fc383b08e',
    'e44d99d4-556d-4644-9e08-4bc01a4bf90e',
    'fire_alarm_location',
    'safety',
    'Fire Alarm',
    NULL,
    'panel. Should these not be available our engineer will',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Fire Alarm
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '4664989a-f819-425a-aebd-0c1872e72453',
    'e44d99d4-556d-4644-9e08-4bc01a4bf90e',
    'fire_alarm_location',
    'safety',
    'Fire Alarm',
    NULL,
    'system to the relevant British Standards;',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Fire Alarm
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    'e1b730c5-e000-47a4-8faa-f594e45c92be',
    'e44d99d4-556d-4644-9e08-4bc01a4bf90e',
    'fire_alarm_location',
    'safety',
    'Fire Alarm',
    NULL,
    'system logbook for each system will be completed and any defect logged and',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Fire Alarm
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    'b037953f-dd4d-4983-8e94-eabab22eb3e5',
    'e44d99d4-556d-4644-9e08-4bc01a4bf90e',
    'fire_alarm_location',
    'safety',
    'Fire Alarm',
    NULL,
    'Servicing will be undertaken either quarterly or Bi-annually dependent on the size',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Fire Alarm
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    'da1b5e25-b8df-438a-b20e-7a98f833f932',
    'e44d99d4-556d-4644-9e08-4bc01a4bf90e',
    'fire_alarm_location',
    'safety',
    'Fire Alarm',
    NULL,
    'System.',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Fire Alarm
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    'df9885c4-23e7-482d-a319-15e59f1043f6',
    'e44d99d4-556d-4644-9e08-4bc01a4bf90e',
    'fire_alarm_location',
    'safety',
    'Fire Alarm',
    NULL,
    'Monthly Bell Testing',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Fire Alarm
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '55f3d0f9-282d-441f-ad63-f022c159c087',
    'e44d99d4-556d-4644-9e08-4bc01a4bf90e',
    'fire_alarm_location',
    'safety',
    'Fire Alarm',
    NULL,
    'system is',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Fire Alarm
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '42466299-4297-481d-aa90-98b74c0652a3',
    'e44d99d4-556d-4644-9e08-4bc01a4bf90e',
    'fire_alarm_location',
    'safety',
    'Fire Alarm',
    NULL,
    'signal(s). Please contact us if you feel this is',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Fire Alarm
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '73c74224-e889-4276-bec7-331bbdebba9d',
    'e44d99d4-556d-4644-9e08-4bc01a4bf90e',
    'fire_alarm_location',
    'safety',
    'Fire Alarm',
    NULL,
    'signal and',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Fire Alarm
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    'a40d9b1c-1d74-4357-b970-d52ce0c24e60',
    'e44d99d4-556d-4644-9e08-4bc01a4bf90e',
    'fire_alarm_location',
    'safety',
    'Fire Alarm',
    NULL,
    'sounders, and to ensure that the fire alarm signal is correctly',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Fire Alarm
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '651eaa97-a7a6-42dc-aa38-060cb89f18ea',
    'e44d99d4-556d-4644-9e08-4bc01a4bf90e',
    'fire_alarm_location',
    'safety',
    'Fire Alarm',
    NULL,
    'signals are transmitted.',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Fire Alarm
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '2cc6aa6f-8fa7-488a-9ce9-457414bf6a23',
    'e44d99d4-556d-4644-9e08-4bc01a4bf90e',
    'fire_alarm_location',
    'safety',
    'Fire Alarm',
    NULL,
    'signal.',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Fire Alarm
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '35ac30e0-bae6-40a3-ae67-76ad2f0f5d03',
    'e44d99d4-556d-4644-9e08-4bc01a4bf90e',
    'fire_alarm_location',
    'safety',
    'Fire Alarm',
    NULL,
    'System, and to allow testing co-',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Fire Alarm
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    'c4d83e20-3be6-4a46-bda7-3e11d69de3c1',
    'e44d99d4-556d-4644-9e08-4bc01a4bf90e',
    'fire_alarm_location',
    'safety',
    'Fire Alarm',
    NULL,
    'and detection system is',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Fire Alarm
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '95bd1d4d-422f-4ac9-af23-5593cac033c9',
    'e44d99d4-556d-4644-9e08-4bc01a4bf90e',
    'fire_alarm_location',
    'safety',
    'Fire Alarm',
    NULL,
    'contract a further 100% test is carried out and detection system scheme may no',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Fire Alarm
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '3a6c91c5-e854-44c6-888e-55ec40e69fa7',
    'e44d99d4-556d-4644-9e08-4bc01a4bf90e',
    'fire_alarm_location',
    'safety',
    'Fire Alarm',
    NULL,
    '& EMERGENCY',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Fire Alarm
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    'e1d178d8-280a-43eb-8e26-5ddfbc2e1af1',
    'e44d99d4-556d-4644-9e08-4bc01a4bf90e',
    'fire_alarm_location',
    'safety',
    'Fire Alarm',
    NULL,
    'SYSTEM & SM1 04/03/24 £520.00',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Fire Alarm
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '7c954734-8f7c-4fe6-bad9-ecafa12e66c8',
    'e44d99d4-556d-4644-9e08-4bc01a4bf90e',
    'fire_alarm_location',
    'safety',
    'Fire Alarm',
    NULL,
    'SM1 04/03/24 £240.00',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Fire Alarm
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '0b7f5ce1-67d4-4c42-b3a0-11c13b0ba853',
    'e44d99d4-556d-4644-9e08-4bc01a4bf90e',
    'fire_alarm_location',
    'safety',
    'Fire Alarm',
    NULL,
    'BELL TEST REPORT',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Fire Alarm
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    'd8fef288-9183-4cfb-a2d5-325836cf54b8',
    'e44d99d4-556d-4644-9e08-4bc01a4bf90e',
    'fire_alarm_location',
    'safety',
    'Fire Alarm',
    NULL,
    'service. Tested common parts ok. Key is required for panel door',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Boiler
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    'f443bacf-9f44-4267-92e1-467b8f01a437',
    'e44d99d4-556d-4644-9e08-4bc01a4bf90e',
    'boiler_location',
    'utilities',
    'Boiler',
    NULL,
    'Room Calorifier WH-01 22/11/2024 Six Monthly Pass',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Boiler
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '57879c51-dc51-440b-b4cc-0efd070e3244',
    'e44d99d4-556d-4644-9e08-4bc01a4bf90e',
    'boiler_location',
    'utilities',
    'Boiler',
    NULL,
    'Room Calorifier WH-02 22/11/2024 Six Monthly Pass',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Boiler
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '706c5109-e951-446c-9c82-6bea3ee8670f',
    'e44d99d4-556d-4644-9e08-4bc01a4bf90e',
    'boiler_location',
    'utilities',
    'Boiler',
    NULL,
    'Room Calorifier WH-01 29/05/2025 Monthly Pass',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Boiler
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '67728bb0-2c2a-4110-b1e9-a3b971152101',
    'e44d99d4-556d-4644-9e08-4bc01a4bf90e',
    'boiler_location',
    'utilities',
    'Boiler',
    NULL,
    'Room Calorifier WH-02 29/05/2025 Monthly Pass',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Boiler
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    'b718060a-da6a-4d22-884b-249201c56f43',
    'e44d99d4-556d-4644-9e08-4bc01a4bf90e',
    'boiler_location',
    'utilities',
    'Boiler',
    NULL,
    'Room Calorifier WH-01 14/05/2024 Monthly Pass',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Boiler
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    'a1b7de16-8936-4c41-b4d9-46efe4f3959c',
    'e44d99d4-556d-4644-9e08-4bc01a4bf90e',
    'boiler_location',
    'utilities',
    'Boiler',
    NULL,
    'Room Calorifier WH-02 14/05/2024 Monthly Pass',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Boiler
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '7acb3cda-e66d-457f-9b68-8c3c638f218e',
    'e44d99d4-556d-4644-9e08-4bc01a4bf90e',
    'boiler_location',
    'utilities',
    'Boiler',
    NULL,
    'Room Calorifier WH-01 29/05/2025 Six Monthly Pass',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Boiler
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    'd152ec1a-2fa0-49fa-96bd-8f9b5f5b1003',
    'e44d99d4-556d-4644-9e08-4bc01a4bf90e',
    'boiler_location',
    'utilities',
    'Boiler',
    NULL,
    'Room Calorifier WH-02 29/05/2025 Six Monthly Pass',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Boiler
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    'd8181603-440a-4e59-8e9d-cf72b47a6ca3',
    'e44d99d4-556d-4644-9e08-4bc01a4bf90e',
    'boiler_location',
    'utilities',
    'Boiler',
    NULL,
    'Room Calorifier WH-01 29/05/2025 Annual Pass',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Boiler
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '7cdf7b95-bf82-459b-8440-eda44817bbe7',
    'e44d99d4-556d-4644-9e08-4bc01a4bf90e',
    'boiler_location',
    'utilities',
    'Boiler',
    NULL,
    'Room Calorifier WH-02 29/05/2025 Annual Pass',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Boiler
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    'db04438a-d1c3-44e4-94c8-cd6212464b88',
    'e44d99d4-556d-4644-9e08-4bc01a4bf90e',
    'boiler_location',
    'utilities',
    'Boiler',
    NULL,
    'Room Calorifier WH-01 21/08/2025 Monthly Pass',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Boiler
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '3c006f28-9fbf-49aa-8796-ae52c5b2718b',
    'e44d99d4-556d-4644-9e08-4bc01a4bf90e',
    'boiler_location',
    'utilities',
    'Boiler',
    NULL,
    'Room Calorifier WH-02 21/08/2025 Monthly Pass',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Boiler
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    'a1a7d651-7287-44ac-8103-9f44477350f4',
    'e44d99d4-556d-4644-9e08-4bc01a4bf90e',
    'boiler_location',
    'utilities',
    'Boiler',
    NULL,
    'Room Calorifier WH-01 17/06/2025 Monthly Pass',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Boiler
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '178bcfcb-cd17-4789-abb9-cd86e4304b43',
    'e44d99d4-556d-4644-9e08-4bc01a4bf90e',
    'boiler_location',
    'utilities',
    'Boiler',
    NULL,
    'Room Calorifier WH-02 17/06/2025 Monthly Pass',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: CCTV
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '39668165-6f7f-44df-a706-94392a31a283',
    'e44d99d4-556d-4644-9e08-4bc01a4bf90e',
    'cctv_location',
    'safety',
    'CCTV',
    NULL,
    'survey can be carried out into the pipework',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: CCTV
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '02f14238-3995-4102-9d37-705dde6ba02b',
    'e44d99d4-556d-4644-9e08-4bc01a4bf90e',
    'cctv_location',
    'safety',
    'CCTV',
    NULL,
    'survey in order to confirm the area of ingress from the already',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: CCTV
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    'ba26dad7-05fa-42bd-ad7e-b87ceaf115f1',
    'e44d99d4-556d-4644-9e08-4bc01a4bf90e',
    'cctv_location',
    'safety',
    'CCTV',
    NULL,
    'survey in order to ascertain the cause of water escaping through',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: CCTV
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '11d8d2bc-dc3f-462c-85f2-96c21d77ca22',
    'e44d99d4-556d-4644-9e08-4bc01a4bf90e',
    'cctv_location',
    'safety',
    'CCTV',
    NULL,
    'survey as requested.',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: CCTV
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    'da460990-5c87-4cba-a622-82846370eec7',
    'e44d99d4-556d-4644-9e08-4bc01a4bf90e',
    'cctv_location',
    'safety',
    'CCTV',
    NULL,
    'survey.',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: CCTV
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '6ccd089a-98ce-4cda-b188-0da599680ee5',
    'e44d99d4-556d-4644-9e08-4bc01a4bf90e',
    'cctv_location',
    'safety',
    'CCTV',
    NULL,
    'survey on the soil downpipe that services the kitchen and utility room',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: CCTV
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '9310373a-feed-40dd-a725-d58ac5af983d',
    'e44d99d4-556d-4644-9e08-4bc01a4bf90e',
    'cctv_location',
    'safety',
    'CCTV',
    NULL,
    'survey it has been',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: CCTV
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '08a70074-94b8-479b-9d32-9d6fde6ef5d3',
    'e44d99d4-556d-4644-9e08-4bc01a4bf90e',
    'cctv_location',
    'safety',
    'CCTV',
    NULL,
    'survey is not possible we would refer back to our',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Gas Meter
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '0a042767-c64c-4fe4-ad0b-a53e6d63a673',
    'e44d99d4-556d-4644-9e08-4bc01a4bf90e',
    'gas_meter_location',
    'utilities',
    'Gas Meter',
    NULL,
    'units',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Boiler
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '398d234e-53ed-4532-a984-bc175fbcf2c5',
    'e44d99d4-556d-4644-9e08-4bc01a4bf90e',
    'boiler_location',
    'utilities',
    'Boiler',
    NULL,
    'Room gaskets within foil wrapped',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Boiler
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '5c424fe2-daf6-4458-9e80-b3836c960a5d',
    'e44d99d4-556d-4644-9e08-4bc01a4bf90e',
    'boiler_location',
    'utilities',
    'Boiler',
    NULL,
    'Room residue to brick walls (previously',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Boiler
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '7dc3d81a-3488-4e71-b16a-466b296cc7f8',
    'e44d99d4-556d-4644-9e08-4bc01a4bf90e',
    'boiler_location',
    'utilities',
    'Boiler',
    NULL,
    'Room asbestos containing materials',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Boiler
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    'e97e8eb8-7278-4163-83a4-5bced71c88cc',
    'e44d99d4-556d-4644-9e08-4bc01a4bf90e',
    'boiler_location',
    'utilities',
    'Boiler',
    NULL,
    'Room residue to brick walls',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Boiler
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '4b5b6fbb-83fc-4fd3-92e7-d883fb051e95',
    'e44d99d4-556d-4644-9e08-4bc01a4bf90e',
    'boiler_location',
    'utilities',
    'Boiler',
    NULL,
    'Room asbestos containing',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Boiler
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '1b24be07-f68c-4eb3-bea5-17f7bae0b17f',
    'e44d99d4-556d-4644-9e08-4bc01a4bf90e',
    'boiler_location',
    'utilities',
    'Boiler',
    NULL,
    'Room residue to brick walls suitably maintained and',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Boiler
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '999f4c07-a9a2-466e-b284-d148cc31e1b4',
    'e44d99d4-556d-4644-9e08-4bc01a4bf90e',
    'boiler_location',
    'utilities',
    'Boiler',
    NULL,
    'Room presumed gaskets within foil suitably maintained and',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Boiler
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '43d11f88-1d96-4972-a150-a8ce8272062f',
    'e44d99d4-556d-4644-9e08-4bc01a4bf90e',
    'boiler_location',
    'utilities',
    'Boiler',
    NULL,
    'Room asbestos containing materials suitably maintained and',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Boiler
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '23e09a3a-7250-4722-a58e-9064c89f68d8',
    'e44d99d4-556d-4644-9e08-4bc01a4bf90e',
    'boiler_location',
    'utilities',
    'Boiler',
    NULL,
    'Very',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Boiler
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '33c547dd-db7a-41cc-a60d-b33221504149',
    'e44d99d4-556d-4644-9e08-4bc01a4bf90e',
    'boiler_location',
    'utilities',
    'Boiler',
    NULL,
    'Gaskets Very Very',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;
