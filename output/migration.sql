-- ============================================================
-- PATCHED: BlocIQ Onboarder - Auto-generated Migration (Schema-Corrected)
-- Generated at: 2025-10-09T18:56:06.227558
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

-- Using BlocIQ agency ID: 11111111-1111-1111-1111-111111111111
-- Agency already exists in Supabase, no INSERT needed

BEGIN;

-- Insert building
INSERT INTO buildings (id, name, address) VALUES ('355128d6-4439-41b8-8979-640037f68e02', 'Connaught Square', 'CONNAUGHT SQUARE');

-- Insert 1 schedule(s)
INSERT INTO schedules (id, building_id, name, description) VALUES ('e35a180d-72c0-4274-b36d-280b52ff27d8', '355128d6-4439-41b8-8979-640037f68e02', 'Main Schedule', 'Auto-detected schedule from onboarding');
-- Created schedules: Main Schedule

-- Insert 8 units
INSERT INTO units (id, building_id, unit_number) VALUES
('2401eef1-2086-4b1f-987a-ac80e44bf3b3', '355128d6-4439-41b8-8979-640037f68e02', 'Flat 1'),
('b867eddd-0cb8-4945-8bfd-a5ec2d257539', '355128d6-4439-41b8-8979-640037f68e02', 'Flat 2'),
('dbb6e64d-4ba4-4a7a-b873-f1549c8ec8b0', '355128d6-4439-41b8-8979-640037f68e02', 'Flat 3'),
('bf39f804-d25e-4dbe-a1b1-1e7b79bbf51a', '355128d6-4439-41b8-8979-640037f68e02', 'Flat 4'),
('c9a89e0d-d73a-42cc-a0d4-f528ef8355aa', '355128d6-4439-41b8-8979-640037f68e02', 'Flat 5'),
('d0c7b364-6fa5-427d-952b-6468c0ebde75', '355128d6-4439-41b8-8979-640037f68e02', 'Flat 6'),
('89608b80-17d2-4c36-8604-6ae5d4bcbda9', '355128d6-4439-41b8-8979-640037f68e02', 'Flat 7'),
('ed748379-3501-4883-8129-837aacbbdfbc', '355128d6-4439-41b8-8979-640037f68e02', 'Flat 8')
ON CONFLICT (id) DO NOTHING;

-- Insert 8 leaseholders (schema has building_id and unit_number)
INSERT INTO leaseholders (id, building_id, unit_id, unit_number, name) VALUES
('26d2bd08-9585-4656-a691-f7ca75c824ae', '355128d6-4439-41b8-8979-640037f68e02', '2401eef1-2086-4b1f-987a-ac80e44bf3b3', 'Flat 1', 'Marmotte Holdings Limited'),
('6b9801c3-566f-403c-be6a-d2551e2ec62b', '355128d6-4439-41b8-8979-640037f68e02', 'b867eddd-0cb8-4945-8bfd-a5ec2d257539', 'Flat 2', 'Ms V Rebulla'),
('923addf3-a597-4fa5-a35b-0fcb613b6e31', '355128d6-4439-41b8-8979-640037f68e02', 'dbb6e64d-4ba4-4a7a-b873-f1549c8ec8b0', 'Flat 3', 'Ms V Rebulla'),
('419f390f-a117-4dd4-9e35-0661bdbd8f18', '355128d6-4439-41b8-8979-640037f68e02', 'bf39f804-d25e-4dbe-a1b1-1e7b79bbf51a', 'Flat 4', 'Mr P J J Reynish & Ms C A O''Loughlin'),
('b149c6fc-bf7a-4c6b-8a20-7e5a23dc7b5e', '355128d6-4439-41b8-8979-640037f68e02', 'c9a89e0d-d73a-42cc-a0d4-f528ef8355aa', 'Flat 5', 'Mr & Mrs M D Samworth'),
('bbe8a53a-9065-4149-a078-d0a19b1fc7ab', '355128d6-4439-41b8-8979-640037f68e02', 'd0c7b364-6fa5-427d-952b-6468c0ebde75', 'Flat 6', 'Mr M D & Mrs C P Samworth'),
('d0a8e2b5-4467-44d8-900c-49b8673c4909', '355128d6-4439-41b8-8979-640037f68e02', '89608b80-17d2-4c36-8604-6ae5d4bcbda9', 'Flat 7', 'Ms J Gomm'),
('9660fa6b-4ae2-429c-b301-e6e89b8d3907', '355128d6-4439-41b8-8979-640037f68e02', 'ed748379-3501-4883-8129-837aacbbdfbc', 'Flat 8', 'Miss T V Samwoth & Miss G E Samworth')
ON CONFLICT (id) DO NOTHING;

-- Insert 56 compliance assets
INSERT INTO compliance_assets (id, building_id, description, asset_name, asset_type, inspection_frequency, last_inspection_date, next_due_date, compliance_status, is_active) VALUES ('07e56800-e8a7-4f7c-8198-23e48e9287d5', '355128d6-4439-41b8-8979-640037f68e02', 'Extracted from 2024 Directors Meeting-Notes.docx', 'Compliance Asset', 'general', '12 months', '2024-01-01', '2025-01-01', 'overdue', TRUE);
INSERT INTO compliance_assets (id, building_id, description, asset_name, asset_type, inspection_frequency, compliance_status, location, is_active) VALUES ('cee230aa-76fa-4821-965d-dd0c9a1c8d16', '355128d6-4439-41b8-8979-640037f68e02', 'Extracted from Fire Door (Communal) Inspection (11m +) (7).pdf', 'Fire Door Inspection', 'fire_safety', '12 months', 'unknown', 'Communal', TRUE);
INSERT INTO compliance_assets (id, building_id, description, asset_name, asset_type, inspection_frequency, compliance_status, is_active) VALUES ('609bcffc-d083-46de-91f3-ddb0c789f60f', '355128d6-4439-41b8-8979-640037f68e02', 'Extracted from Fire Door (Flats) Inspection (11m +) (13).pdf', 'Fire Door Inspection', 'fire_safety', '12 months', 'unknown', TRUE);
INSERT INTO compliance_assets (id, building_id, description, asset_name, asset_type, inspection_frequency, compliance_status, is_active) VALUES ('00814b9d-5210-4ccd-86b3-60f183baeb1d', '355128d6-4439-41b8-8979-640037f68e02', 'Extracted from Fire Door (Flats) Inspection (11m +) (18).pdf', 'Fire Door Inspection', 'fire_safety', '12 months', 'unknown', TRUE);
INSERT INTO compliance_assets (id, building_id, description, asset_name, asset_type, inspection_frequency, compliance_status, is_active) VALUES ('7369311c-be82-4492-9274-f76f4cca4bf8', '355128d6-4439-41b8-8979-640037f68e02', 'Extracted from Fire Door (Flats) Inspection (11m +) (14).pdf', 'Fire Door Inspection', 'fire_safety', '12 months', 'unknown', TRUE);
INSERT INTO compliance_assets (id, building_id, description, asset_name, asset_type, inspection_frequency, compliance_status, is_active) VALUES ('b25a1fea-50ac-400e-a39b-11ad5f5a2053', '355128d6-4439-41b8-8979-640037f68e02', 'Extracted from EICR Cuanku 32-34 conaught square.pdf', 'Electrical Installation Condition Report (EICR)', 'electrical', '60 months', 'unknown', TRUE);
INSERT INTO compliance_assets (id, building_id, description, asset_name, asset_type, inspection_frequency, compliance_status, is_active) VALUES ('23a9736a-618e-43db-8f72-a4f6cb1d60c1', '355128d6-4439-41b8-8979-640037f68e02', 'Extracted from Fire Door (Flats) Inspection (11m +) (15).pdf', 'Fire Door Inspection', 'fire_safety', '12 months', 'unknown', TRUE);
INSERT INTO compliance_assets (id, building_id, description, asset_name, asset_type, inspection_frequency, last_inspection_date, next_due_date, compliance_status, is_active) VALUES ('01eb677b-7320-4f58-9d06-685fb9acbd40', '355128d6-4439-41b8-8979-640037f68e02', 'Extracted from 221037_Fra1-L-394697-071223 32-34 Connaught Square_2024-01-02_163759 (1).pdf', 'Fire Risk Assessment (FRA)', 'fire_safety', '12 months', '2024-01-02', '2025-01-02', 'overdue', TRUE);
INSERT INTO compliance_assets (id, building_id, description, asset_name, asset_type, inspection_frequency, compliance_status, is_active) VALUES ('0f759d4d-d6bd-42ab-a0e7-202dbe3a6c02', '355128d6-4439-41b8-8979-640037f68e02', 'Extracted from Fire Door (Flats) Inspection (11m +) (19).pdf', 'Fire Door Inspection', 'fire_safety', '12 months', 'unknown', TRUE);
INSERT INTO compliance_assets (id, building_id, description, asset_name, asset_type, inspection_frequency, compliance_status, is_active) VALUES ('8c2a1040-dc28-475b-b754-c7bfebff4559', '355128d6-4439-41b8-8979-640037f68e02', 'Extracted from 001132-3234-Connaught-Square-London.pdf', 'Compliance Asset', 'general', '12 months', 'unknown', TRUE);
INSERT INTO compliance_assets (id, building_id, description, asset_name, asset_type, inspection_frequency, last_inspection_date, next_due_date, compliance_status, is_active) VALUES ('f1c3e1b4-9bda-417f-a092-e16d06e2db8f', '355128d6-4439-41b8-8979-640037f68e02', 'Extracted from 221038_Hsra1-L-394697-071223 32-34 Connaught Square_2024-01-02_163759 (1).pdf', 'Compliance Asset', 'general', '12 months', '2024-01-02', '2025-01-02', 'overdue', TRUE);
INSERT INTO compliance_assets (id, building_id, description, asset_name, asset_type, inspection_frequency, compliance_status, is_active) VALUES ('a5dfd650-79e9-4287-805f-adc200e3d721', '355128d6-4439-41b8-8979-640037f68e02', 'Extracted from TETRA - Asbestos Re-Inspection Survey 14.06.22.pdf', 'Compliance Asset', 'general', '12 months', 'unknown', TRUE);
INSERT INTO compliance_assets (id, building_id, description, asset_name, asset_type, inspection_frequency, compliance_status, is_active) VALUES ('4e23ccc1-a91a-4030-a718-0e236804b883', '355128d6-4439-41b8-8979-640037f68e02', 'Extracted from Fire Door (Flats) Inspection (11m +) (16).pdf', 'Fire Door Inspection', 'fire_safety', '12 months', 'unknown', TRUE);
INSERT INTO compliance_assets (id, building_id, description, asset_name, asset_type, inspection_frequency, compliance_status, is_active) VALUES ('3c873469-a802-4e5b-b30b-88e9aa8416bf', '355128d6-4439-41b8-8979-640037f68e02', 'Extracted from Fire Door (Flats) Inspection (11m +) (17).pdf', 'Fire Door Inspection', 'fire_safety', '12 months', 'unknown', TRUE);
INSERT INTO compliance_assets (id, building_id, description, asset_name, asset_type, inspection_frequency, compliance_status, is_active) VALUES ('3455ff30-5bb1-47d8-ba55-213efbf32d86', '355128d6-4439-41b8-8979-640037f68e02', 'Extracted from WHM Legionella Risk Assessment 07.06.22.pdf', 'Legionella Risk Assessment', 'water_safety', '24 months', 'unknown', TRUE);
INSERT INTO compliance_assets (id, building_id, description, asset_name, asset_type, inspection_frequency, last_inspection_date, next_due_date, compliance_status, is_active) VALUES ('ba6304ef-93c7-43eb-b397-94413dd5db4b', '355128d6-4439-41b8-8979-640037f68e02', 'Extracted from EICR Report Cunaku SATISFACTORY 2023 .pdf', 'Electrical Installation Condition Report (EICR)', 'electrical', '60 months', '2023-01-01', '2028-01-01', 'compliant', TRUE);
INSERT INTO compliance_assets (id, building_id, description, asset_name, asset_type, inspection_frequency, last_inspection_date, next_due_date, compliance_status, is_active) VALUES ('f7e1cc78-56a4-4d44-b629-fc03090a91a3', '355128d6-4439-41b8-8979-640037f68e02', 'Extracted from 2024 Directors Meeting-Notes.docx', 'Compliance Asset', 'general', '12 months', '2024-01-01', '2025-01-01', 'overdue', TRUE);
INSERT INTO compliance_assets (id, building_id, description, asset_name, asset_type, inspection_frequency, compliance_status, is_active) VALUES ('c8b56c1c-33bb-4c87-a63e-c0ae7c803668', '355128d6-4439-41b8-8979-640037f68e02', 'Extracted from 001457-3234-Connaught-Square-London Certificate.pdf', 'Compliance Asset', 'general', '12 months', 'unknown', TRUE);
INSERT INTO compliance_assets (id, building_id, description, asset_name, asset_type, inspection_frequency, compliance_status, is_active) VALUES ('8c0a1dfb-d6d8-4140-8223-2cbc9e6dff71', '355128d6-4439-41b8-8979-640037f68e02', 'Extracted from TC0001V31 General Terms and Conditions.pdf', 'Compliance Asset', 'general', '12 months', 'unknown', TRUE);
INSERT INTO compliance_assets (id, building_id, description, asset_name, asset_type, inspection_frequency, last_inspection_date, next_due_date, compliance_status, is_active) VALUES ('4599de83-60e7-4c80-9b1f-cc55cd55bf57', '355128d6-4439-41b8-8979-640037f68e02', 'Extracted from Jobcard_For_Job_No_28992_24-01-2025_1545.pdf', 'Compliance Asset', 'general', '12 months', '2025-01-24', '2026-01-24', 'compliant', TRUE);
INSERT INTO compliance_assets (id, building_id, description, asset_name, asset_type, inspection_frequency, compliance_status, is_active) VALUES ('d1fd750e-db81-4df6-887f-3122e33171b4', '355128d6-4439-41b8-8979-640037f68e02', 'Extracted from Connaught Square (32-34) - 09.12.24 LRA.pdf', 'Compliance Asset', 'general', '12 months', 'unknown', TRUE);
INSERT INTO compliance_assets (id, building_id, description, asset_name, asset_type, inspection_frequency, compliance_status, is_active) VALUES ('a02bf7eb-e467-4478-9ba6-7d39f69bf092', '355128d6-4439-41b8-8979-640037f68e02', 'Extracted from SC Certificate - 10072023.pdf', 'Compliance Asset', 'general', '12 months', 'unknown', TRUE);
INSERT INTO compliance_assets (id, building_id, description, asset_name, asset_type, inspection_frequency, compliance_status, location, is_active) VALUES ('57721142-07f9-49f6-a1e5-e6efffe4b9dc', '355128d6-4439-41b8-8979-640037f68e02', 'Extracted from Fire Door (Communal) Inspection (11m +) (7).pdf', 'Fire Door Inspection', 'fire_safety', '12 months', 'unknown', 'Communal', TRUE);
INSERT INTO compliance_assets (id, building_id, description, asset_name, asset_type, inspection_frequency, compliance_status, is_active) VALUES ('b20d0f7b-3d9e-4276-827a-b894466e66ac', '355128d6-4439-41b8-8979-640037f68e02', 'Extracted from Fire Door (Flats) Inspection (11m +) (13).pdf', 'Fire Door Inspection', 'fire_safety', '12 months', 'unknown', TRUE);
INSERT INTO compliance_assets (id, building_id, description, asset_name, asset_type, inspection_frequency, compliance_status, is_active) VALUES ('0e83b5e4-9f65-47f8-8b96-bd7da54233db', '355128d6-4439-41b8-8979-640037f68e02', 'Extracted from Fire Door (Flats) Inspection (11m +) (18).pdf', 'Fire Door Inspection', 'fire_safety', '12 months', 'unknown', TRUE);
INSERT INTO compliance_assets (id, building_id, description, asset_name, asset_type, inspection_frequency, compliance_status, is_active) VALUES ('fb5f4423-417f-469c-b668-f842023c1c5a', '355128d6-4439-41b8-8979-640037f68e02', 'Extracted from Fire Door (Flats) Inspection (11m +) (14).pdf', 'Fire Door Inspection', 'fire_safety', '12 months', 'unknown', TRUE);
INSERT INTO compliance_assets (id, building_id, description, asset_name, asset_type, inspection_frequency, compliance_status, is_active) VALUES ('6a1a8490-29d5-43be-9979-505d40b125a3', '355128d6-4439-41b8-8979-640037f68e02', 'Extracted from Fire Door (Flats) Inspection (11m +) (15).pdf', 'Fire Door Inspection', 'fire_safety', '12 months', 'unknown', TRUE);
INSERT INTO compliance_assets (id, building_id, description, asset_name, asset_type, inspection_frequency, compliance_status, is_active) VALUES ('f012dc8c-d991-48ee-9d74-0e4042a17fee', '355128d6-4439-41b8-8979-640037f68e02', 'Extracted from Fire Door (Flats) Inspection (11m +) (19).pdf', 'Fire Door Inspection', 'fire_safety', '12 months', 'unknown', TRUE);
INSERT INTO compliance_assets (id, building_id, description, asset_name, asset_type, inspection_frequency, compliance_status, is_active) VALUES ('71f8367d-6655-4ff4-8393-db938102f993', '355128d6-4439-41b8-8979-640037f68e02', 'Extracted from Fire Door (Flats) Inspection (11m +) (16).pdf', 'Fire Door Inspection', 'fire_safety', '12 months', 'unknown', TRUE);
INSERT INTO compliance_assets (id, building_id, description, asset_name, asset_type, inspection_frequency, compliance_status, is_active) VALUES ('65454bac-74fa-4775-a7f6-aa14952cec29', '355128d6-4439-41b8-8979-640037f68e02', 'Extracted from Fire Door (Flats) Inspection (11m +) (17).pdf', 'Fire Door Inspection', 'fire_safety', '12 months', 'unknown', TRUE);
INSERT INTO compliance_assets (id, building_id, description, asset_name, asset_type, inspection_frequency, last_inspection_date, next_due_date, compliance_status, is_active) VALUES ('87809563-739c-44ce-99a6-4e3cb6fd0a7c', '355128d6-4439-41b8-8979-640037f68e02', 'Extracted from 221037_Fra1-L-394697-071223 32-34 Connaught Square_2024-01-02_163759.pdf', 'Fire Risk Assessment (FRA)', 'fire_safety', '12 months', '2024-01-02', '2025-01-02', 'overdue', TRUE);
INSERT INTO compliance_assets (id, building_id, description, asset_name, asset_type, inspection_frequency, last_inspection_date, next_due_date, compliance_status, is_active) VALUES ('3c692eec-cc26-41d0-8946-812652e4c556', '355128d6-4439-41b8-8979-640037f68e02', 'Extracted from Fire Door (Flats) Inspection (11m +) - 2024-01-24T120747.552.pdf', 'Fire Door Inspection', 'fire_safety', '12 months', '2024-01-24', '2025-01-24', 'overdue', TRUE);
INSERT INTO compliance_assets (id, building_id, description, asset_name, asset_type, inspection_frequency, compliance_status, is_active) VALUES ('ea9f1853-3161-4417-896a-b9a02b28a504', '355128d6-4439-41b8-8979-640037f68e02', 'Extracted from Connaught Square (32-34) - 15.11.23 (886) wa.pdf', 'Compliance Asset', 'general', '12 months', 'unknown', TRUE);
INSERT INTO compliance_assets (id, building_id, description, asset_name, asset_type, inspection_frequency, last_inspection_date, next_due_date, compliance_status, is_active) VALUES ('599d35c3-ecfe-40ba-9dfe-c904a07c2d82', '355128d6-4439-41b8-8979-640037f68e02', 'Extracted from Fire Door (Flats) Inspection (11m +) - 2024-01-24T120745.875.pdf', 'Fire Door Inspection', 'fire_safety', '12 months', '2024-01-24', '2025-01-24', 'overdue', TRUE);
INSERT INTO compliance_assets (id, building_id, description, asset_name, asset_type, inspection_frequency, last_inspection_date, next_due_date, compliance_status, is_active) VALUES ('70eef117-db12-4b34-ae95-60081aef0e12', '355128d6-4439-41b8-8979-640037f68e02', 'Extracted from Fire Door (Flats) Inspection (11m +) - 2024-01-24T120746.424.pdf', 'Fire Door Inspection', 'fire_safety', '12 months', '2024-01-24', '2025-01-24', 'overdue', TRUE);
INSERT INTO compliance_assets (id, building_id, description, asset_name, asset_type, inspection_frequency, last_inspection_date, next_due_date, compliance_status, location, is_active) VALUES ('54d37f06-80f3-4261-8111-837762769550', '355128d6-4439-41b8-8979-640037f68e02', 'Extracted from Fire Door (Communal) Inspection (11m +) - 2024-01-24T120743.986.pdf', 'Fire Door Inspection', 'fire_safety', '12 months', '2024-01-24', '2025-01-24', 'overdue', 'Communal', TRUE);
INSERT INTO compliance_assets (id, building_id, description, asset_name, asset_type, inspection_frequency, last_inspection_date, next_due_date, compliance_status, is_active) VALUES ('7f34e35e-4318-4c57-83c7-5759668e69b3', '355128d6-4439-41b8-8979-640037f68e02', 'Extracted from Fire Door (Flats) Inspection (11m +) - 2024-01-24T120744.738.pdf', 'Fire Door Inspection', 'fire_safety', '12 months', '2024-01-24', '2025-01-24', 'overdue', TRUE);
INSERT INTO compliance_assets (id, building_id, description, asset_name, asset_type, inspection_frequency, last_inspection_date, next_due_date, compliance_status, is_active) VALUES ('61ae141d-054b-43b5-85e1-3314068cccf2', '355128d6-4439-41b8-8979-640037f68e02', 'Extracted from Fire Door (Flats) Inspection (11m +) - 2024-01-24T120747.015.pdf', 'Fire Door Inspection', 'fire_safety', '12 months', '2024-01-24', '2025-01-24', 'overdue', TRUE);
INSERT INTO compliance_assets (id, building_id, description, asset_name, asset_type, inspection_frequency, last_inspection_date, next_due_date, compliance_status, is_active) VALUES ('9b5c3198-6f19-4045-b6cd-eef6ce70f086', '355128d6-4439-41b8-8979-640037f68e02', 'Extracted from 221038_Hsra1-L-394697-071223 32-34 Connaught Square_2024-01-02_163759.pdf', 'Compliance Asset', 'general', '12 months', '2024-01-02', '2025-01-02', 'overdue', TRUE);
INSERT INTO compliance_assets (id, building_id, description, asset_name, asset_type, inspection_frequency, last_inspection_date, next_due_date, compliance_status, is_active) VALUES ('c5b22c09-fc90-4f03-b45f-049f71ca616f', '355128d6-4439-41b8-8979-640037f68e02', 'Extracted from Fire Door (Flats) Inspection (11m +) - 2024-01-24T120745.174.pdf', 'Fire Door Inspection', 'fire_safety', '12 months', '2024-01-24', '2025-01-24', 'overdue', TRUE);
INSERT INTO compliance_assets (id, building_id, description, asset_name, asset_type, inspection_frequency, compliance_status, is_active) VALUES ('a98611f2-4bec-4c78-9359-ad317490cd7c', '355128d6-4439-41b8-8979-640037f68e02', 'Extracted from Hsfra1-L-422971-210225 32-34 Connaught Square.pdf', 'Fire Risk Assessment (FRA)', 'fire_safety', '12 months', 'unknown', TRUE);
INSERT INTO compliance_assets (id, building_id, description, asset_name, asset_type, inspection_frequency, compliance_status, is_active) VALUES ('d3671ee8-7a50-49cd-90e6-e4282d540aac', '355128d6-4439-41b8-8979-640037f68e02', 'Extracted from Hsfra1-L-422971-210225 32-34 Connaught Square.docx', 'Fire Risk Assessment (FRA)', 'fire_safety', '12 months', 'unknown', TRUE);
INSERT INTO compliance_assets (id, building_id, description, asset_name, asset_type, inspection_frequency, last_inspection_date, next_due_date, compliance_status, is_active) VALUES ('b5117f00-cb79-441b-aaae-0474267a3ed4', '355128d6-4439-41b8-8979-640037f68e02', 'Extracted from 221037_Fra1-L-394697-071223 32-34 Connaught Square_2024-01-02_163759 (1).pdf', 'Fire Risk Assessment (FRA)', 'fire_safety', '12 months', '2024-01-02', '2025-01-02', 'overdue', TRUE);
INSERT INTO compliance_assets (id, building_id, description, asset_name, asset_type, inspection_frequency, last_inspection_date, next_due_date, compliance_status, is_active) VALUES ('1d5a3633-c39c-4019-b70d-41f588095923', '355128d6-4439-41b8-8979-640037f68e02', 'Extracted from 221038_Hsra1-L-394697-071223 32-34 Connaught Square_2024-01-02_163759 (1).pdf', 'Compliance Asset', 'general', '12 months', '2024-01-02', '2025-01-02', 'overdue', TRUE);
INSERT INTO compliance_assets (id, building_id, description, asset_name, asset_type, inspection_frequency, compliance_status, is_active) VALUES ('e083564d-5cc9-4334-99ce-d632fc9569b7', '355128d6-4439-41b8-8979-640037f68e02', 'Extracted from FRA-Connaught Square Reccommendations.xlsx', 'Fire Risk Assessment (FRA)', 'fire_safety', '12 months', 'unknown', TRUE);
INSERT INTO compliance_assets (id, building_id, description, asset_name, asset_type, inspection_frequency, compliance_status, is_active) VALUES ('456d0c82-b6c4-4f06-b4c3-505f1667f38c', '355128d6-4439-41b8-8979-640037f68e02', 'Extracted from 001534-3234-Connaught-Square-London.pdf', 'Compliance Asset', 'general', '12 months', 'unknown', TRUE);
INSERT INTO compliance_assets (id, building_id, description, asset_name, asset_type, inspection_frequency, compliance_status, is_active) VALUES ('fd94dbcb-151a-46fc-bdb4-a1a9b6a48d40', '355128d6-4439-41b8-8979-640037f68e02', 'Extracted from C1047 - Job card.pdf', 'Compliance Asset', 'general', '12 months', 'unknown', TRUE);
INSERT INTO compliance_assets (id, building_id, description, asset_name, asset_type, inspection_frequency, compliance_status, is_active) VALUES ('f966ac2e-c2f9-42c6-b540-7df54a6e9040', '355128d6-4439-41b8-8979-640037f68e02', 'Extracted from WHM Legionella Risk Assessment 09.12.25.pdf', 'Legionella Risk Assessment', 'water_safety', '24 months', 'unknown', TRUE);
INSERT INTO compliance_assets (id, building_id, description, asset_name, asset_type, inspection_frequency, compliance_status, is_active) VALUES ('51124b8d-6d3b-41bd-b667-e285bf74c289', '355128d6-4439-41b8-8979-640037f68e02', 'Extracted from WHM Legionella Risk Assessment 07.06.22.pdf', 'Legionella Risk Assessment', 'water_safety', '24 months', 'unknown', TRUE);
INSERT INTO compliance_assets (id, building_id, description, asset_name, asset_type, inspection_frequency, compliance_status, is_active) VALUES ('3edaeaa7-dde8-4758-bcd8-70577c9b939b', '355128d6-4439-41b8-8979-640037f68e02', 'Extracted from Connaught Square (32-34) - 29.05.25 (201) wa.pdf', 'Compliance Asset', 'general', '12 months', 'unknown', TRUE);
INSERT INTO compliance_assets (id, building_id, description, asset_name, asset_type, inspection_frequency, compliance_status, is_active) VALUES ('9bc4c428-3b19-4c5c-a67e-49394b1c6d6d', '355128d6-4439-41b8-8979-640037f68e02', 'Extracted from EICR Cuanku 32-34 conaught square.pdf', 'Electrical Installation Condition Report (EICR)', 'electrical', '60 months', 'unknown', TRUE);
INSERT INTO compliance_assets (id, building_id, description, asset_name, asset_type, inspection_frequency, last_inspection_date, next_due_date, compliance_status, is_active) VALUES ('d89acd63-357e-4335-affc-9e4832e313a2', '355128d6-4439-41b8-8979-640037f68e02', 'Extracted from EICR Report Cunaku SATISFACTORY 2023 .pdf', 'Electrical Installation Condition Report (EICR)', 'electrical', '60 months', '2023-01-01', '2028-01-01', 'compliant', TRUE);
INSERT INTO compliance_assets (id, building_id, description, asset_name, asset_type, inspection_frequency, compliance_status, is_active) VALUES ('d06f926c-cfbc-427e-b9ff-09c6958e3740', '355128d6-4439-41b8-8979-640037f68e02', 'Extracted from 001132-3234-Connaught-Square-London.pdf', 'Compliance Asset', 'general', '12 months', 'unknown', TRUE);
INSERT INTO compliance_assets (id, building_id, description, asset_name, asset_type, inspection_frequency, compliance_status, is_active) VALUES ('83b171ff-3e7b-4dad-bcd0-f469b4bf1cea', '355128d6-4439-41b8-8979-640037f68e02', 'Extracted from 001534-3234-Connaught-Square-London.pdf', 'Compliance Asset', 'general', '12 months', 'unknown', TRUE);
INSERT INTO compliance_assets (id, building_id, description, asset_name, asset_type, inspection_frequency, compliance_status, is_active) VALUES ('492719c6-1b0b-436f-bcbb-1740e6a02b49', '355128d6-4439-41b8-8979-640037f68e02', 'Extracted from FINAL L-432900 32-34 Connaught Square Management Survey Report Issue 1.pdf', 'Compliance Asset', 'general', '12 months', 'unknown', TRUE);
INSERT INTO compliance_assets (id, building_id, description, asset_name, asset_type, inspection_frequency, compliance_status, is_active) VALUES ('1de4d19c-d7e0-4f0d-a511-74a74a721a89', '355128d6-4439-41b8-8979-640037f68e02', 'Extracted from TETRA - Asbestos Re-Inspection Survey 14.06.22.pdf', 'Compliance Asset', 'general', '12 months', 'unknown', TRUE);

-- Insert 4 major works projects
INSERT INTO major_works_projects (id, building_id, project_name, status, start_date) VALUES ('6cf957e0-8ab3-4fad-b322-2f9ce3edb3e8', '355128d6-4439-41b8-8979-640037f68e02', 'External Decoration - 2025', 'planned', '2025-01-01');
INSERT INTO major_works_projects (id, building_id, project_name, status, start_date) VALUES ('2840a082-9c31-45c4-98e8-2fffaa79cb75', '355128d6-4439-41b8-8979-640037f68e02', 'Section 20 Consultation (SOE) - 2025', 'planned', '2025-01-01');
INSERT INTO major_works_projects (id, building_id, project_name, status, start_date) VALUES ('cabca1a1-2f6b-4e43-89b8-da9245434786', '355128d6-4439-41b8-8979-640037f68e02', 'Lift - Section 20 (NOI) - 2025', 'planned', '2025-01-01');
INSERT INTO major_works_projects (id, building_id, project_name, status, start_date) VALUES ('08933699-a154-4745-bdd7-7c10677582fd', '355128d6-4439-41b8-8979-640037f68e02', 'Major Works Project - 2025', 'planned', '2025-01-01');

-- Insert 22 budgets
INSERT INTO budgets (id, building_id, year_start, year_end, period) VALUES ('0b5374bb-98fb-48e6-93fc-a566e6f5238d', '355128d6-4439-41b8-8979-640037f68e02', '2025-04-01', '2026-03-31', '2025');
INSERT INTO budgets (id, building_id, year_start, year_end, period) VALUES ('1bfd78e0-eb1e-497d-8a40-5aebc3b7896e', '355128d6-4439-41b8-8979-640037f68e02', '2025-04-01', '2026-03-31', '2025');
INSERT INTO budgets (id, building_id, year_start, year_end, period) VALUES ('d026a16f-4809-45b2-bfeb-e09d031e0a33', '355128d6-4439-41b8-8979-640037f68e02', '2025-04-01', '2026-03-31', '2025');
INSERT INTO budgets (id, building_id, year_start, year_end, period) VALUES ('3c87864f-133b-4f31-8647-bac800cbc9f1', '355128d6-4439-41b8-8979-640037f68e02', '2025-04-01', '2026-03-31', '2025');
INSERT INTO budgets (id, building_id, year_start, year_end, period) VALUES ('13fa66b7-2e1d-4999-be95-f69c744a3384', '355128d6-4439-41b8-8979-640037f68e02', '2025-04-01', '2026-03-31', '2025');
INSERT INTO budgets (id, building_id, year_start, year_end, period) VALUES ('ff00aca9-59bc-45a7-bc0e-2fdc64fec821', '355128d6-4439-41b8-8979-640037f68e02', '2025-04-01', '2026-03-31', '2025');
INSERT INTO budgets (id, building_id, year_start, year_end, period) VALUES ('cd82fd63-5932-486f-ab31-e8e81dcecd45', '355128d6-4439-41b8-8979-640037f68e02', '2025-04-01', '2026-03-31', '2025');
INSERT INTO budgets (id, building_id, year_start, year_end, period) VALUES ('1f9854fc-85f1-4944-9f49-b7df5c73dfa2', '355128d6-4439-41b8-8979-640037f68e02', '2025-04-01', '2026-03-31', '2025');
INSERT INTO budgets (id, building_id, year_start, year_end, period) VALUES ('0cd2993a-7068-4b75-b6a3-1e57b979a482', '355128d6-4439-41b8-8979-640037f68e02', '2025-04-01', '2026-03-31', '2025');
INSERT INTO budgets (id, building_id, year_start, year_end, period) VALUES ('a258a1d9-6d18-4d7f-a337-0f88cc34e565', '355128d6-4439-41b8-8979-640037f68e02', '2025-04-01', '2026-03-31', '2025');
INSERT INTO budgets (id, building_id, year_start, year_end, period) VALUES ('bf92f89f-e585-405e-a1ba-aaeaae237f3c', '355128d6-4439-41b8-8979-640037f68e02', '2025-04-01', '2026-03-31', '2025');
INSERT INTO budgets (id, building_id, year_start, year_end, period) VALUES ('4fc21cc3-7445-4540-a974-7309c049f512', '355128d6-4439-41b8-8979-640037f68e02', '2025-04-01', '2026-03-31', '2025');
INSERT INTO budgets (id, building_id, year_start, year_end, period) VALUES ('74ea1b0e-2254-40bb-aa62-30a99a728399', '355128d6-4439-41b8-8979-640037f68e02', '2025-04-01', '2026-03-31', '2025');
INSERT INTO budgets (id, building_id, year_start, year_end, period) VALUES ('a05649c7-5895-44ab-aec6-c92cced78898', '355128d6-4439-41b8-8979-640037f68e02', '2025-04-01', '2026-03-31', '2025');
INSERT INTO budgets (id, building_id, year_start, year_end, period) VALUES ('cdbf97ec-0f54-4190-a10d-a3b7a1adffc7', '355128d6-4439-41b8-8979-640037f68e02', '2025-04-01', '2026-03-31', '2025');
INSERT INTO budgets (id, building_id, year_start, year_end, period) VALUES ('5c440fe1-e701-4044-a5de-c807ef9f6366', '355128d6-4439-41b8-8979-640037f68e02', '2025-04-01', '2026-03-31', '2025');
INSERT INTO budgets (id, building_id, year_start, year_end, period) VALUES ('1667987b-0faa-46de-a19f-df22f207a620', '355128d6-4439-41b8-8979-640037f68e02', '2025-04-01', '2026-03-31', '2025');
INSERT INTO budgets (id, building_id, year_start, year_end, period) VALUES ('06844271-e1b3-4a08-8a39-9fe74c288c11', '355128d6-4439-41b8-8979-640037f68e02', '2025-04-01', '2026-03-31', '2025');
INSERT INTO budgets (id, building_id, year_start, year_end, period) VALUES ('a7255e6e-be67-4cd1-97f8-0be77e71ed44', '355128d6-4439-41b8-8979-640037f68e02', '2025-04-01', '2026-03-31', '2025');
INSERT INTO budgets (id, building_id, year_start, year_end, period) VALUES ('9b10d40c-64ad-4a54-a4b0-69e923c82a6c', '355128d6-4439-41b8-8979-640037f68e02', '2025-04-01', '2026-03-31', '2025');
INSERT INTO budgets (id, building_id, year_start, year_end, period) VALUES ('7ccfd16f-b268-4f96-b682-c167a103069b', '355128d6-4439-41b8-8979-640037f68e02', '2025-04-01', '2026-03-31', '2025');
INSERT INTO budgets (id, building_id, year_start, year_end, period) VALUES ('751deedf-ce67-40d4-a55a-80f3f62fc54a', '355128d6-4439-41b8-8979-640037f68e02', '2025-04-01', '2026-03-31', '2025');

-- Insert 318 document records
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('f6cc7f51-acff-4720-9299-f4d7182a0437', '355128d6-4439-41b8-8979-640037f68e02', 'lease', 'Important Information .pdf', 'lease/Important Information .pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('508029aa-cc41-48bc-a65f-fa1e48619501', '355128d6-4439-41b8-8979-640037f68e02', 'finance', 'ACCOUNTS - YE 31.03.21 - Service Charge Accounts (1).pdf', 'finance/ACCOUNTS - YE 31.03.21 - Service Charge Accounts (1).pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('eeb84dc9-bf78-46af-af02-25628609276e', '355128d6-4439-41b8-8979-640037f68e02', 'lease', 'Official Copy (Lease) 04.08.2022 - NGL809841 (1).pdf', 'lease/Official Copy (Lease) 04.08.2022 - NGL809841 (1).pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('24231761-4e85-42f7-857c-c1e793e54895', '355128d6-4439-41b8-8979-640037f68e02', 'lease', 'Official Copy (Lease) 04.08.2022 - NGL809841 (2).pdf', 'lease/Official Copy (Lease) 04.08.2022 - NGL809841 (2).pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('3a1f8943-d9ef-40d4-b3c6-1f85a61483a0', '355128d6-4439-41b8-8979-640037f68e02', 'lease', 'Official Copy (Lease) 13.06.2003 - NGL827422.pdf', 'lease/Official Copy (Lease) 13.06.2003 - NGL827422.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('a7efa7ff-7917-4f89-ac22-807078d70c2e', '355128d6-4439-41b8-8979-640037f68e02', 'lease', 'Official Copy (Lease) 04.08.2022 - NGL809841.pdf', 'lease/Official Copy (Lease) 04.08.2022 - NGL809841.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('c16ba577-4c44-48c0-95e1-966565988d83', '355128d6-4439-41b8-8979-640037f68e02', 'lease', 'Signed April 2025 Arrears Collection Procedure.pdf', 'lease/Signed April 2025 Arrears Collection Procedure.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('96b158f2-59d7-4a3c-a377-f04f73ecf9c0', '355128d6-4439-41b8-8979-640037f68e02', 'lease', 'WP0005V17 Welcome Pack.pdf', 'lease/WP0005V17 Welcome Pack.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('955e077f-2e37-4e84-a520-b8da55acf9c9', '355128d6-4439-41b8-8979-640037f68e02', 'lease', 'Jobcard_For_Job_No_33844_07-04-2025_1143.pdf', 'lease/Jobcard_For_Job_No_33844_07-04-2025_1143.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('4681327b-9f7a-41ad-91e5-a5af411b2d1f', '355128d6-4439-41b8-8979-640037f68e02', 'lease', 'Jobcard_For_Job_No_37675_25-07-2025_1549.pdf', 'lease/Jobcard_For_Job_No_37675_25-07-2025_1549.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('fc501aae-22aa-4285-91a4-a901c800f819', '355128d6-4439-41b8-8979-640037f68e02', 'lease', 'Jobcard_For_Job_No_34012_01-05-2025_1616.pdf', 'lease/Jobcard_For_Job_No_34012_01-05-2025_1616.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('4ab88ecc-7277-4ad7-991a-eaa32a0c8821', '355128d6-4439-41b8-8979-640037f68e02', 'lease', 'Jobcard_For_Job_No_32759_17-03-2025_1145.pdf', 'lease/Jobcard_For_Job_No_32759_17-03-2025_1145.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('aa9cdcb4-b68c-46c6-8f09-ad9ac18c44b4', '355128d6-4439-41b8-8979-640037f68e02', 'lease', 'Jobcard_For_Job_No_32810_17-03-2025_1311.pdf', 'lease/Jobcard_For_Job_No_32810_17-03-2025_1311.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('7729b873-15a5-418d-aa26-64815518fc5c', '355128d6-4439-41b8-8979-640037f68e02', 'contracts', 'Quote_No_23550 - Connaught Square (32-34) 2023-2024.pdf', 'contracts/Quote_No_23550 - Connaught Square (32-34) 2023-2024.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('2e98aa64-5bb2-4751-9f6d-194d28699828', '355128d6-4439-41b8-8979-640037f68e02', 'lease', 'Licence_Document_352024.pdf', 'lease/Licence_Document_352024.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('39b5c348-3d88-482f-a668-de02bd5a082d', '355128d6-4439-41b8-8979-640037f68e02', 'lease', 'JLGServiceVisit-M00813-12-09-2024.pdf', 'lease/JLGServiceVisit-M00813-12-09-2024.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('d4c4c6e1-0484-4187-a7cb-b166c8592b11', '355128d6-4439-41b8-8979-640037f68e02', 'lease', 'JLGServiceVisit-M00813-13-11-2024.pdf', 'lease/JLGServiceVisit-M00813-13-11-2024.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('121b6fca-8b57-4662-8e41-2bc258498a83', '355128d6-4439-41b8-8979-640037f68e02', 'lease', 'JLGServiceVisit-M00813-02-12-2024.pdf', 'lease/JLGServiceVisit-M00813-02-12-2024.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('c5158b46-22d7-4d06-96b5-08443b9f960b', '355128d6-4439-41b8-8979-640037f68e02', 'lease', 'JLGServiceVisit-M00813-08-07-2024.pdf', 'lease/JLGServiceVisit-M00813-08-07-2024.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('407e1098-beab-4f33-aedd-cda849ce35ae', '355128d6-4439-41b8-8979-640037f68e02', 'lease', 'JLGServiceVisit-M00813-08-10-2024.pdf', 'lease/JLGServiceVisit-M00813-08-10-2024.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('07c56232-746b-4194-ae00-d93ec233129f', '355128d6-4439-41b8-8979-640037f68e02', 'lease', 'JLGServiceVisit-M00813-12-02-2025.pdf', 'lease/JLGServiceVisit-M00813-12-02-2025.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('7e182323-464b-4a69-b7ea-d2aa6ac70412', '355128d6-4439-41b8-8979-640037f68e02', 'lease', 'JLGServiceVisit-M00813-17-03-2025.pdf', 'lease/JLGServiceVisit-M00813-17-03-2025.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('b1829a05-f626-4b01-beda-d576d95412af', '355128d6-4439-41b8-8979-640037f68e02', 'lease', 'JLGServiceVisit-M00813-14-04-2025.pdf', 'lease/JLGServiceVisit-M00813-14-04-2025.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('da3b771c-3634-4c17-a155-4da7edac4261', '355128d6-4439-41b8-8979-640037f68e02', 'lease', 'REP-40343473-L1.pdf', 'lease/REP-40343473-L1.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('00564d6e-a9c4-47a3-b55a-26a62f79575a', '355128d6-4439-41b8-8979-640037f68e02', 'lease', 'JLGServiceVisit-M00813-13-05-2025.pdf', 'lease/JLGServiceVisit-M00813-13-05-2025.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('c0803995-6a0f-4896-9f49-271e29409f0a', '355128d6-4439-41b8-8979-640037f68e02', 'lease', 'Communal Cleaning-First Port.pdf', 'lease/Communal Cleaning-First Port.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('f5e4b5ba-bfc5-47dd-86a7-548b966072f1', '355128d6-4439-41b8-8979-640037f68e02', 'lease', 'SC Health and Safety Product - Accredited 10072023.pdf', 'lease/SC Health and Safety Product - Accredited 10072023.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('d4fc4015-b428-4997-9c8c-e516e2a7f5cc', '355128d6-4439-41b8-8979-640037f68e02', 'lease', 'Tenancy Schedule by Property.pdf', 'lease/Tenancy Schedule by Property.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('708b9c91-9cc3-4428-9a6b-961af2cbb82f', '355128d6-4439-41b8-8979-640037f68e02', 'finance', 'Accounts YE 31.03.2022 32-34 Connaught Square MJP.pdf', 'finance/Accounts YE 31.03.2022 32-34 Connaught Square MJP.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('26ddd617-021c-46d2-9cb7-fea4749fa8c6', '355128d6-4439-41b8-8979-640037f68e02', 'finance', '197-YE 31.03.22 SC Accs FINAL MAY 2023.pdf', 'finance/197-YE 31.03.22 SC Accs FINAL MAY 2023.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('03106a34-0937-468e-b178-38914a5513d7', '355128d6-4439-41b8-8979-640037f68e02', 'finance', 'ACCOUNTS - YE 31.03.21 - Service Charge Accounts (1).pdf', 'finance/ACCOUNTS - YE 31.03.21 - Service Charge Accounts (1).pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('9869de3d-8227-4a42-a6a6-5a584f364b27', '355128d6-4439-41b8-8979-640037f68e02', 'finance', '27039 Accounts Pack - YE 2023.pdf', 'finance/27039 Accounts Pack - YE 2023.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('daf5b37f-ac6e-48a4-8b72-d7302d52058a', '355128d6-4439-41b8-8979-640037f68e02', 'finance', 'Connaught Sq SC YE 23.pdf', 'finance/Connaught Sq SC YE 23.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('de314ec7-329a-4b1a-90b0-5cae8618cfa1', '355128d6-4439-41b8-8979-640037f68e02', 'lease', 'Connaught Square-House Rules.docx', 'lease/Connaught Square-House Rules.docx');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('a7992ffd-8b93-485d-87cf-bfbc135a61c0', '355128d6-4439-41b8-8979-640037f68e02', 'correspondence', 'Garden Notice-Connaught Square.docx', 'correspondence/Garden Notice-Connaught Square.docx');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('543db337-fc0d-454e-bd5f-889aa8719139', '355128d6-4439-41b8-8979-640037f68e02', 'correspondence', 'Connaught Square-Key Cut Authorisation Letter.docx', 'correspondence/Connaught Square-Key Cut Authorisation Letter.docx');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('df5a79e7-0f16-49e8-b2cd-53a91d6b4304', '355128d6-4439-41b8-8979-640037f68e02', 'lease', 'House Rules-Connaught Square.pdf', 'lease/House Rules-Connaught Square.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('5abc0951-11c5-4cb7-9120-78fee65a1b45', '355128d6-4439-41b8-8979-640037f68e02', 'lease', 'REP-39659654.pdf', 'lease/REP-39659654.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('0329235e-2334-44ce-94fb-986b0fb6f49a', '355128d6-4439-41b8-8979-640037f68e02', 'lease', 'Important Information .pdf', 'lease/Important Information .pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('a554343e-393f-4c6a-8a8a-519f67029db0', '355128d6-4439-41b8-8979-640037f68e02', 'lease', 'StG_Certificate_32-34 Connaught Square W2 2HL.pdf', 'lease/StG_Certificate_32-34 Connaught Square W2 2HL.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('a1016bff-d326-42f3-b600-a521812c7ff1', '355128d6-4439-41b8-8979-640037f68e02', 'contracts', 'CM434.AnnualServiceAgreement2025-2026.pdf', 'contracts/CM434.AnnualServiceAgreement2025-2026.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('dea7564d-bdc6-448d-92f3-6dafc8c2ca65', '355128d6-4439-41b8-8979-640037f68e02', 'contracts', 'CM434.AnnualServiceAgreement2024-2025.pdf', 'contracts/CM434.AnnualServiceAgreement2024-2025.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('79824073-81d9-428e-a136-7996f3f02940', '355128d6-4439-41b8-8979-640037f68e02', 'lease', 'REP-40324834-E3.pdf', 'lease/REP-40324834-E3.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('eed2510d-93fb-432a-be4f-867cf67c8f2b', '355128d6-4439-41b8-8979-640037f68e02', 'lease', 'Ellie@mihproperty.co.uk - BES Group - E-Report.pdf', 'lease/Ellie@mihproperty.co.uk - BES Group - E-Report.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('38bb7d39-e6f1-4580-b446-ecb8d026b4a2', '355128d6-4439-41b8-8979-640037f68e02', 'lease', 'Jobcard_For_Job_No_38609_26-08-2025_0741.pdf', 'lease/Jobcard_For_Job_No_38609_26-08-2025_0741.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('d49db2b5-1b69-43db-8c58-e36ecdf7c56a', '355128d6-4439-41b8-8979-640037f68e02', 'lease', 'Jobcard_For_Job_No_28737_25-11-2024_0907.pdf', 'lease/Jobcard_For_Job_No_28737_25-11-2024_0907.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('113815ec-8cc9-4e24-9a6c-294dc27f67e3', '355128d6-4439-41b8-8979-640037f68e02', 'lease', 'Jobcard_For_Job_No_35402_03-06-2025_0916.pdf', 'lease/Jobcard_For_Job_No_35402_03-06-2025_0916.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('f46a0190-fea3-4c41-a5e0-56e2dc3055b7', '355128d6-4439-41b8-8979-640037f68e02', 'lease', 'Jobcard_For_Job_No_35654_03-06-2025_0911.pdf', 'lease/Jobcard_For_Job_No_35654_03-06-2025_0911.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('65757ef8-6779-4794-8718-176e2538d30b', '355128d6-4439-41b8-8979-640037f68e02', 'lease', 'Jobcard_For_Job_No_37675_25-07-2025_1549.pdf', 'lease/Jobcard_For_Job_No_37675_25-07-2025_1549.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('59849edd-d0a1-4981-9156-ac94fa29fc80', '355128d6-4439-41b8-8979-640037f68e02', 'lease', 'Jobcard_For_Job_No_35146_03-06-2025_0906.pdf', 'lease/Jobcard_For_Job_No_35146_03-06-2025_0906.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('008599f5-df43-43f3-babd-bcb2623ad5df', '355128d6-4439-41b8-8979-640037f68e02', 'lease', 'Jobcard_For_Job_No_31162_30-01-2025_1602.pdf', 'lease/Jobcard_For_Job_No_31162_30-01-2025_1602.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('df9ce830-4df8-42e1-9610-07969aa38358', '355128d6-4439-41b8-8979-640037f68e02', 'lease', 'Jobcard_For_Job_No_36465_20-06-2025_1037.pdf', 'lease/Jobcard_For_Job_No_36465_20-06-2025_1037.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path, entity_type, linked_entity_id) VALUES ('47c6d61e-1d1e-4674-9716-379c21a07236', '355128d6-4439-41b8-8979-640037f68e02', 'finance', 'connaught apportionment.xlsx', 'finance/connaught apportionment.xlsx', 'budget', 'b4916e33-3c84-4318-9af4-b5e6c5998727');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path, entity_type, linked_entity_id) VALUES ('a6760db5-083b-47e1-bfc3-3c34917e7211', '355128d6-4439-41b8-8979-640037f68e02', 'finance', 'ACCOUNTS - YE 31.03.21 - Service Charge Accounts.pdf', 'finance/ACCOUNTS - YE 31.03.21 - Service Charge Accounts.pdf', 'budget', 'ae4348f3-7536-4244-bbcd-d0004ae8a17f');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path, entity_type, linked_entity_id) VALUES ('4af2f099-3af6-4be6-ad35-4e109ed34e01', '355128d6-4439-41b8-8979-640037f68e02', 'finance', 'Connaught Square Budget 2025-6 Draft.xlsx', 'finance/Connaught Square Budget 2025-6 Draft.xlsx', 'budget', 'c68154af-dd2f-4f44-92b8-6c9abeea485f');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path, entity_type, linked_entity_id) VALUES ('8c8bc444-a8d2-4566-b112-abb4b05cc5be', '355128d6-4439-41b8-8979-640037f68e02', 'finance', 'Connaught Square Budget 2025-Final.pdf', 'finance/Connaught Square Budget 2025-Final.pdf', 'budget', '428d8608-37c7-4016-b077-8ca24c4ae4eb');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path, entity_type, linked_entity_id) VALUES ('7045bbf8-3140-40a6-acdb-f061b4a7c506', '355128d6-4439-41b8-8979-640037f68e02', 'finance', 'Connaught Square Budget 2025-Final.xlsx', 'finance/Connaught Square Budget 2025-Final.xlsx', 'budget', '3051d87e-8707-4994-b6c0-fd140865d155');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path, entity_type, linked_entity_id) VALUES ('177ab854-b370-4af0-b90f-0a98088de8e0', '355128d6-4439-41b8-8979-640037f68e02', 'finance', 'ACCOUNTS - YE 31.03.21 - Service Charge Accounts.pdf', 'finance/ACCOUNTS - YE 31.03.21 - Service Charge Accounts.pdf', 'budget', '7daea184-8952-41cc-8fc9-63cc16881a00');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path, entity_type, linked_entity_id) VALUES ('d79d3d52-c921-484c-aa27-a9ed92db05ee', '355128d6-4439-41b8-8979-640037f68e02', 'finance', 'Connaught Square YE 24 Accounts.pdf', 'finance/Connaught Square YE 24 Accounts.pdf', 'budget', '4408d951-ebd6-4939-875e-f41cf9c69b66');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path, entity_type, linked_entity_id) VALUES ('89c3e41d-db8c-4aff-93a4-1c89636f58b6', '355128d6-4439-41b8-8979-640037f68e02', 'compliance', '2024 Directors Meeting-Notes.docx', 'compliance/2024 Directors Meeting-Notes.docx', 'compliance_asset', '07e56800-e8a7-4f7c-8198-23e48e9287d5');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path, entity_type, linked_entity_id) VALUES ('ce4c0e29-c0fe-4e34-bea0-83a799636b0b', '355128d6-4439-41b8-8979-640037f68e02', 'compliance', 'Fire Door (Communal) Inspection (11m +) (7).pdf', 'compliance/Fire Door (Communal) Inspection (11m +) (7).pdf', 'compliance_asset', 'cee230aa-76fa-4821-965d-dd0c9a1c8d16');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path, entity_type, linked_entity_id) VALUES ('0e9e0a5e-c60b-4ae3-886b-9d101b37f013', '355128d6-4439-41b8-8979-640037f68e02', 'compliance', 'Fire Door (Flats) Inspection (11m +) (13).pdf', 'compliance/Fire Door (Flats) Inspection (11m +) (13).pdf', 'compliance_asset', '609bcffc-d083-46de-91f3-ddb0c789f60f');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path, entity_type, linked_entity_id) VALUES ('287b72c3-377c-4c9b-9580-c293cd5b585a', '355128d6-4439-41b8-8979-640037f68e02', 'compliance', 'Fire Door (Flats) Inspection (11m +) (18).pdf', 'compliance/Fire Door (Flats) Inspection (11m +) (18).pdf', 'compliance_asset', '00814b9d-5210-4ccd-86b3-60f183baeb1d');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path, entity_type, linked_entity_id) VALUES ('c9dde9d0-858c-4b4b-ae5f-874a6b52bb13', '355128d6-4439-41b8-8979-640037f68e02', 'compliance', 'Fire Door (Flats) Inspection (11m +) (14).pdf', 'compliance/Fire Door (Flats) Inspection (11m +) (14).pdf', 'compliance_asset', '7369311c-be82-4492-9274-f76f4cca4bf8');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path, entity_type, linked_entity_id) VALUES ('32ea2782-e008-4930-b24d-d7182ec000f3', '355128d6-4439-41b8-8979-640037f68e02', 'compliance', 'EICR Cuanku 32-34 conaught square.pdf', 'compliance/EICR Cuanku 32-34 conaught square.pdf', 'compliance_asset', 'b25a1fea-50ac-400e-a39b-11ad5f5a2053');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path, entity_type, linked_entity_id) VALUES ('359009a5-1f15-4065-afd1-fa8dcafd4443', '355128d6-4439-41b8-8979-640037f68e02', 'compliance', 'Fire Door (Flats) Inspection (11m +) (15).pdf', 'compliance/Fire Door (Flats) Inspection (11m +) (15).pdf', 'compliance_asset', '23a9736a-618e-43db-8f72-a4f6cb1d60c1');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path, entity_type, linked_entity_id) VALUES ('d0f721df-42a6-4890-a5d7-60458d44d23e', '355128d6-4439-41b8-8979-640037f68e02', 'compliance', '221037_Fra1-L-394697-071223 32-34 Connaught Square_2024-01-02_163759 (1).pdf', 'compliance/221037_Fra1-L-394697-071223 32-34 Connaught Square_2024-01-02_163759 (1).pdf', 'compliance_asset', '01eb677b-7320-4f58-9d06-685fb9acbd40');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path, entity_type, linked_entity_id) VALUES ('6e437f78-24c9-4d6f-a8bf-613066aca457', '355128d6-4439-41b8-8979-640037f68e02', 'compliance', 'Fire Door (Flats) Inspection (11m +) (19).pdf', 'compliance/Fire Door (Flats) Inspection (11m +) (19).pdf', 'compliance_asset', '0f759d4d-d6bd-42ab-a0e7-202dbe3a6c02');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path, entity_type, linked_entity_id) VALUES ('b605932e-b2fc-4d20-b459-c5edebde85f9', '355128d6-4439-41b8-8979-640037f68e02', 'compliance', '001132-3234-Connaught-Square-London.pdf', 'compliance/001132-3234-Connaught-Square-London.pdf', 'compliance_asset', '8c2a1040-dc28-475b-b754-c7bfebff4559');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path, entity_type, linked_entity_id) VALUES ('bd99211f-36e3-4e67-9595-c2fbcba40bda', '355128d6-4439-41b8-8979-640037f68e02', 'compliance', '221038_Hsra1-L-394697-071223 32-34 Connaught Square_2024-01-02_163759 (1).pdf', 'compliance/221038_Hsra1-L-394697-071223 32-34 Connaught Square_2024-01-02_163759 (1).pdf', 'compliance_asset', 'f1c3e1b4-9bda-417f-a092-e16d06e2db8f');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path, entity_type, linked_entity_id) VALUES ('63915c66-3a3c-4504-8f02-189d2172ec5b', '355128d6-4439-41b8-8979-640037f68e02', 'compliance', 'TETRA - Asbestos Re-Inspection Survey 14.06.22.pdf', 'compliance/TETRA - Asbestos Re-Inspection Survey 14.06.22.pdf', 'compliance_asset', 'a5dfd650-79e9-4287-805f-adc200e3d721');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path, entity_type, linked_entity_id) VALUES ('cad0b5ca-76df-4459-95c3-95924acb6de2', '355128d6-4439-41b8-8979-640037f68e02', 'compliance', 'Fire Door (Flats) Inspection (11m +) (16).pdf', 'compliance/Fire Door (Flats) Inspection (11m +) (16).pdf', 'compliance_asset', '4e23ccc1-a91a-4030-a718-0e236804b883');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path, entity_type, linked_entity_id) VALUES ('cbf4e39f-aa16-4c42-ad05-e5f10f820e39', '355128d6-4439-41b8-8979-640037f68e02', 'compliance', 'Fire Door (Flats) Inspection (11m +) (17).pdf', 'compliance/Fire Door (Flats) Inspection (11m +) (17).pdf', 'compliance_asset', '3c873469-a802-4e5b-b30b-88e9aa8416bf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path, entity_type, linked_entity_id) VALUES ('f1958eaf-c9d2-473a-ad39-791bda1637a6', '355128d6-4439-41b8-8979-640037f68e02', 'compliance', 'WHM Legionella Risk Assessment 07.06.22.pdf', 'compliance/WHM Legionella Risk Assessment 07.06.22.pdf', 'compliance_asset', '3455ff30-5bb1-47d8-ba55-213efbf32d86');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path, entity_type, linked_entity_id) VALUES ('4a01e766-9193-46f2-af10-41a97f4b03a0', '355128d6-4439-41b8-8979-640037f68e02', 'compliance', 'EICR Report Cunaku SATISFACTORY 2023 .pdf', 'compliance/EICR Report Cunaku SATISFACTORY 2023 .pdf', 'compliance_asset', 'ba6304ef-93c7-43eb-b397-94413dd5db4b');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path, entity_type, linked_entity_id) VALUES ('e185b8cf-56d7-47ce-98b8-1cbd13091b37', '355128d6-4439-41b8-8979-640037f68e02', 'compliance', '2024 Directors Meeting-Notes.docx', 'compliance/2024 Directors Meeting-Notes.docx', 'compliance_asset', 'f7e1cc78-56a4-4d44-b629-fc03090a91a3');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path, entity_type, linked_entity_id) VALUES ('a2a69c7c-f9c3-4c2e-93f7-5e64a664f471', '355128d6-4439-41b8-8979-640037f68e02', 'compliance', '001457-3234-Connaught-Square-London Certificate.pdf', 'compliance/001457-3234-Connaught-Square-London Certificate.pdf', 'compliance_asset', 'c8b56c1c-33bb-4c87-a63e-c0ae7c803668');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path, entity_type, linked_entity_id) VALUES ('e0bf2497-50c3-482e-a081-26c541fb1049', '355128d6-4439-41b8-8979-640037f68e02', 'compliance', 'TC0001V31 General Terms and Conditions.pdf', 'compliance/TC0001V31 General Terms and Conditions.pdf', 'compliance_asset', '8c0a1dfb-d6d8-4140-8223-2cbc9e6dff71');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path, entity_type, linked_entity_id) VALUES ('cae2d8bc-1ef0-4748-a50d-48c9556cd850', '355128d6-4439-41b8-8979-640037f68e02', 'compliance', 'Jobcard_For_Job_No_28992_24-01-2025_1545.pdf', 'compliance/Jobcard_For_Job_No_28992_24-01-2025_1545.pdf', 'compliance_asset', '4599de83-60e7-4c80-9b1f-cc55cd55bf57');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path, entity_type, linked_entity_id) VALUES ('eb2e0a30-931c-4be6-8c85-7cb2fa138720', '355128d6-4439-41b8-8979-640037f68e02', 'compliance', 'Connaught Square (32-34) - 09.12.24 LRA.pdf', 'compliance/Connaught Square (32-34) - 09.12.24 LRA.pdf', 'compliance_asset', 'd1fd750e-db81-4df6-887f-3122e33171b4');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path, entity_type, linked_entity_id) VALUES ('14b36df9-0c11-4cf7-95f5-90fbd74fe5cc', '355128d6-4439-41b8-8979-640037f68e02', 'compliance', 'SC Certificate - 10072023.pdf', 'compliance/SC Certificate - 10072023.pdf', 'compliance_asset', 'a02bf7eb-e467-4478-9ba6-7d39f69bf092');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path, entity_type, linked_entity_id) VALUES ('d047786c-3bc8-4c92-a905-cf3cb560e16c', '355128d6-4439-41b8-8979-640037f68e02', 'compliance', 'Fire Door (Communal) Inspection (11m +) (7).pdf', 'compliance/Fire Door (Communal) Inspection (11m +) (7).pdf', 'compliance_asset', '57721142-07f9-49f6-a1e5-e6efffe4b9dc');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path, entity_type, linked_entity_id) VALUES ('25430614-36d2-462a-9b10-c0c02b93a058', '355128d6-4439-41b8-8979-640037f68e02', 'compliance', 'Fire Door (Flats) Inspection (11m +) (13).pdf', 'compliance/Fire Door (Flats) Inspection (11m +) (13).pdf', 'compliance_asset', 'b20d0f7b-3d9e-4276-827a-b894466e66ac');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path, entity_type, linked_entity_id) VALUES ('3f0fcc5b-9ddf-4381-857c-dc055af94081', '355128d6-4439-41b8-8979-640037f68e02', 'compliance', 'Fire Door (Flats) Inspection (11m +) (18).pdf', 'compliance/Fire Door (Flats) Inspection (11m +) (18).pdf', 'compliance_asset', '0e83b5e4-9f65-47f8-8b96-bd7da54233db');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path, entity_type, linked_entity_id) VALUES ('bf0cd2b5-6e9b-486f-bb5e-6a49b7036af3', '355128d6-4439-41b8-8979-640037f68e02', 'compliance', 'Fire Door (Flats) Inspection (11m +) (14).pdf', 'compliance/Fire Door (Flats) Inspection (11m +) (14).pdf', 'compliance_asset', 'fb5f4423-417f-469c-b668-f842023c1c5a');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path, entity_type, linked_entity_id) VALUES ('9462257d-04a3-489b-b142-02a2915e0b5e', '355128d6-4439-41b8-8979-640037f68e02', 'compliance', 'Fire Door (Flats) Inspection (11m +) (15).pdf', 'compliance/Fire Door (Flats) Inspection (11m +) (15).pdf', 'compliance_asset', '6a1a8490-29d5-43be-9979-505d40b125a3');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path, entity_type, linked_entity_id) VALUES ('a206dd05-2b80-4d13-a19a-dd956198d9db', '355128d6-4439-41b8-8979-640037f68e02', 'compliance', 'Fire Door (Flats) Inspection (11m +) (19).pdf', 'compliance/Fire Door (Flats) Inspection (11m +) (19).pdf', 'compliance_asset', 'f012dc8c-d991-48ee-9d74-0e4042a17fee');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path, entity_type, linked_entity_id) VALUES ('8604166f-e797-434b-93c9-0745913e8d5a', '355128d6-4439-41b8-8979-640037f68e02', 'compliance', 'Fire Door (Flats) Inspection (11m +) (16).pdf', 'compliance/Fire Door (Flats) Inspection (11m +) (16).pdf', 'compliance_asset', '71f8367d-6655-4ff4-8393-db938102f993');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path, entity_type, linked_entity_id) VALUES ('ecda9276-7a0d-488e-ac81-84bd8a276a42', '355128d6-4439-41b8-8979-640037f68e02', 'compliance', 'Fire Door (Flats) Inspection (11m +) (17).pdf', 'compliance/Fire Door (Flats) Inspection (11m +) (17).pdf', 'compliance_asset', '65454bac-74fa-4775-a7f6-aa14952cec29');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path, entity_type, linked_entity_id) VALUES ('33d773a5-2a4b-4a6c-bdf2-2efa62197dfe', '355128d6-4439-41b8-8979-640037f68e02', 'compliance', '221037_Fra1-L-394697-071223 32-34 Connaught Square_2024-01-02_163759.pdf', 'compliance/221037_Fra1-L-394697-071223 32-34 Connaught Square_2024-01-02_163759.pdf', 'compliance_asset', '87809563-739c-44ce-99a6-4e3cb6fd0a7c');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path, entity_type, linked_entity_id) VALUES ('889081bc-b1da-4f33-9d13-862c2b0e5e4b', '355128d6-4439-41b8-8979-640037f68e02', 'compliance', 'Fire Door (Flats) Inspection (11m +) - 2024-01-24T120747.552.pdf', 'compliance/Fire Door (Flats) Inspection (11m +) - 2024-01-24T120747.552.pdf', 'compliance_asset', '3c692eec-cc26-41d0-8946-812652e4c556');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path, entity_type, linked_entity_id) VALUES ('7cdc9e96-3e74-4bcb-b9c3-faf24756674b', '355128d6-4439-41b8-8979-640037f68e02', 'compliance', 'Connaught Square (32-34) - 15.11.23 (886) wa.pdf', 'compliance/Connaught Square (32-34) - 15.11.23 (886) wa.pdf', 'compliance_asset', 'ea9f1853-3161-4417-896a-b9a02b28a504');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path, entity_type, linked_entity_id) VALUES ('4849455b-f366-4f1b-ab57-1f4fca001ffb', '355128d6-4439-41b8-8979-640037f68e02', 'compliance', 'Fire Door (Flats) Inspection (11m +) - 2024-01-24T120745.875.pdf', 'compliance/Fire Door (Flats) Inspection (11m +) - 2024-01-24T120745.875.pdf', 'compliance_asset', '599d35c3-ecfe-40ba-9dfe-c904a07c2d82');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path, entity_type, linked_entity_id) VALUES ('d472b928-9bfc-45a4-a90d-3bc8190634a6', '355128d6-4439-41b8-8979-640037f68e02', 'compliance', 'Fire Door (Flats) Inspection (11m +) - 2024-01-24T120746.424.pdf', 'compliance/Fire Door (Flats) Inspection (11m +) - 2024-01-24T120746.424.pdf', 'compliance_asset', '70eef117-db12-4b34-ae95-60081aef0e12');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path, entity_type, linked_entity_id) VALUES ('b9c9e42b-cb46-4969-bdd7-6f30f51dfba2', '355128d6-4439-41b8-8979-640037f68e02', 'compliance', 'Fire Door (Communal) Inspection (11m +) - 2024-01-24T120743.986.pdf', 'compliance/Fire Door (Communal) Inspection (11m +) - 2024-01-24T120743.986.pdf', 'compliance_asset', '54d37f06-80f3-4261-8111-837762769550');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path, entity_type, linked_entity_id) VALUES ('8fa69b0d-10d8-412d-b863-f4afbc6c169a', '355128d6-4439-41b8-8979-640037f68e02', 'compliance', 'Fire Door (Flats) Inspection (11m +) - 2024-01-24T120744.738.pdf', 'compliance/Fire Door (Flats) Inspection (11m +) - 2024-01-24T120744.738.pdf', 'compliance_asset', '7f34e35e-4318-4c57-83c7-5759668e69b3');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path, entity_type, linked_entity_id) VALUES ('3247fc52-d46a-4989-ba89-d5d54ad5f0d3', '355128d6-4439-41b8-8979-640037f68e02', 'compliance', 'Fire Door (Flats) Inspection (11m +) - 2024-01-24T120747.015.pdf', 'compliance/Fire Door (Flats) Inspection (11m +) - 2024-01-24T120747.015.pdf', 'compliance_asset', '61ae141d-054b-43b5-85e1-3314068cccf2');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path, entity_type, linked_entity_id) VALUES ('b656eba2-7e69-4ba1-9f01-82fa9729add8', '355128d6-4439-41b8-8979-640037f68e02', 'compliance', '221038_Hsra1-L-394697-071223 32-34 Connaught Square_2024-01-02_163759.pdf', 'compliance/221038_Hsra1-L-394697-071223 32-34 Connaught Square_2024-01-02_163759.pdf', 'compliance_asset', '9b5c3198-6f19-4045-b6cd-eef6ce70f086');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path, entity_type, linked_entity_id) VALUES ('325ff28a-fd65-4ca9-ba94-bb798dd6151d', '355128d6-4439-41b8-8979-640037f68e02', 'compliance', 'Fire Door (Flats) Inspection (11m +) - 2024-01-24T120745.174.pdf', 'compliance/Fire Door (Flats) Inspection (11m +) - 2024-01-24T120745.174.pdf', 'compliance_asset', 'c5b22c09-fc90-4f03-b45f-049f71ca616f');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path, entity_type, linked_entity_id) VALUES ('ce6a164b-3b04-41c7-8d4f-0c678f7533b0', '355128d6-4439-41b8-8979-640037f68e02', 'compliance', 'Hsfra1-L-422971-210225 32-34 Connaught Square.pdf', 'compliance/Hsfra1-L-422971-210225 32-34 Connaught Square.pdf', 'compliance_asset', 'a98611f2-4bec-4c78-9359-ad317490cd7c');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path, entity_type, linked_entity_id) VALUES ('1befae36-cdbc-440b-a23c-cf07a0737bb7', '355128d6-4439-41b8-8979-640037f68e02', 'compliance', 'Hsfra1-L-422971-210225 32-34 Connaught Square.docx', 'compliance/Hsfra1-L-422971-210225 32-34 Connaught Square.docx', 'compliance_asset', 'd3671ee8-7a50-49cd-90e6-e4282d540aac');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path, entity_type, linked_entity_id) VALUES ('675b4449-f440-4d5a-87fb-92a57fd8901c', '355128d6-4439-41b8-8979-640037f68e02', 'compliance', '221037_Fra1-L-394697-071223 32-34 Connaught Square_2024-01-02_163759 (1).pdf', 'compliance/221037_Fra1-L-394697-071223 32-34 Connaught Square_2024-01-02_163759 (1).pdf', 'compliance_asset', 'b5117f00-cb79-441b-aaae-0474267a3ed4');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path, entity_type, linked_entity_id) VALUES ('2d3c6ee9-d82e-4e32-9866-f6413c5ee8da', '355128d6-4439-41b8-8979-640037f68e02', 'compliance', '221038_Hsra1-L-394697-071223 32-34 Connaught Square_2024-01-02_163759 (1).pdf', 'compliance/221038_Hsra1-L-394697-071223 32-34 Connaught Square_2024-01-02_163759 (1).pdf', 'compliance_asset', '1d5a3633-c39c-4019-b70d-41f588095923');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path, entity_type, linked_entity_id) VALUES ('8b9fdc26-18c6-4778-99af-3787a398eea3', '355128d6-4439-41b8-8979-640037f68e02', 'compliance', 'FRA-Connaught Square Reccommendations.xlsx', 'compliance/FRA-Connaught Square Reccommendations.xlsx', 'compliance_asset', 'e083564d-5cc9-4334-99ce-d632fc9569b7');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path, entity_type, linked_entity_id) VALUES ('8a905bd9-f096-40b1-aea0-153a80598cff', '355128d6-4439-41b8-8979-640037f68e02', 'compliance', '001534-3234-Connaught-Square-London.pdf', 'compliance/001534-3234-Connaught-Square-London.pdf', 'compliance_asset', '456d0c82-b6c4-4f06-b4c3-505f1667f38c');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path, entity_type, linked_entity_id) VALUES ('dec84b7f-a13b-4cfe-bd05-1b9fb9ab9f0e', '355128d6-4439-41b8-8979-640037f68e02', 'compliance', 'C1047 - Job card.pdf', 'compliance/C1047 - Job card.pdf', 'compliance_asset', 'fd94dbcb-151a-46fc-bdb4-a1a9b6a48d40');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path, entity_type, linked_entity_id) VALUES ('d51ad461-9e74-453b-91fe-070dac8c89b6', '355128d6-4439-41b8-8979-640037f68e02', 'compliance', 'WHM Legionella Risk Assessment 09.12.25.pdf', 'compliance/WHM Legionella Risk Assessment 09.12.25.pdf', 'compliance_asset', 'f966ac2e-c2f9-42c6-b540-7df54a6e9040');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path, entity_type, linked_entity_id) VALUES ('1402548e-f3eb-4b71-9eca-1497b2a4bf95', '355128d6-4439-41b8-8979-640037f68e02', 'compliance', 'WHM Legionella Risk Assessment 07.06.22.pdf', 'compliance/WHM Legionella Risk Assessment 07.06.22.pdf', 'compliance_asset', '51124b8d-6d3b-41bd-b667-e285bf74c289');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path, entity_type, linked_entity_id) VALUES ('a6b687fb-4214-4134-a03e-d980f69bb5c6', '355128d6-4439-41b8-8979-640037f68e02', 'compliance', 'Connaught Square (32-34) - 29.05.25 (201) wa.pdf', 'compliance/Connaught Square (32-34) - 29.05.25 (201) wa.pdf', 'compliance_asset', '3edaeaa7-dde8-4758-bcd8-70577c9b939b');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path, entity_type, linked_entity_id) VALUES ('10281fde-66d1-423c-b9ca-3c1f9a61c1c2', '355128d6-4439-41b8-8979-640037f68e02', 'compliance', 'EICR Cuanku 32-34 conaught square.pdf', 'compliance/EICR Cuanku 32-34 conaught square.pdf', 'compliance_asset', '9bc4c428-3b19-4c5c-a67e-49394b1c6d6d');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path, entity_type, linked_entity_id) VALUES ('443e8baa-b84b-49f5-a454-518647a2a492', '355128d6-4439-41b8-8979-640037f68e02', 'compliance', 'EICR Report Cunaku SATISFACTORY 2023 .pdf', 'compliance/EICR Report Cunaku SATISFACTORY 2023 .pdf', 'compliance_asset', 'd89acd63-357e-4335-affc-9e4832e313a2');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path, entity_type, linked_entity_id) VALUES ('8afcaa15-7bc3-4b7b-91ed-ced93898ca42', '355128d6-4439-41b8-8979-640037f68e02', 'compliance', '001132-3234-Connaught-Square-London.pdf', 'compliance/001132-3234-Connaught-Square-London.pdf', 'compliance_asset', 'd06f926c-cfbc-427e-b9ff-09c6958e3740');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path, entity_type, linked_entity_id) VALUES ('69cb181f-ece2-43ad-9545-cfc03824118d', '355128d6-4439-41b8-8979-640037f68e02', 'compliance', '001534-3234-Connaught-Square-London.pdf', 'compliance/001534-3234-Connaught-Square-London.pdf', 'compliance_asset', '83b171ff-3e7b-4dad-bcd0-f469b4bf1cea');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path, entity_type, linked_entity_id) VALUES ('4ce46746-6f81-450f-99b5-57bfd094ce87', '355128d6-4439-41b8-8979-640037f68e02', 'compliance', 'FINAL L-432900 32-34 Connaught Square Management Survey Report Issue 1.pdf', 'compliance/FINAL L-432900 32-34 Connaught Square Management Survey Report Issue 1.pdf', 'compliance_asset', '492719c6-1b0b-436f-bcbb-1740e6a02b49');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path, entity_type, linked_entity_id) VALUES ('b8ac8c36-abeb-4c60-896c-546cd983ea2d', '355128d6-4439-41b8-8979-640037f68e02', 'compliance', 'TETRA - Asbestos Re-Inspection Survey 14.06.22.pdf', 'compliance/TETRA - Asbestos Re-Inspection Survey 14.06.22.pdf', 'compliance_asset', '1de4d19c-d7e0-4f0d-a511-74a74a721a89');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('25d0f251-2592-4d95-bfc5-1e1c4884d748', '355128d6-4439-41b8-8979-640037f68e02', 'finance', 'British Gas Invoice-862451083.pdf', 'finance/British Gas Invoice-862451083.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('ccd4450c-b9ab-4e59-9c7e-00806742ec6e', '355128d6-4439-41b8-8979-640037f68e02', 'contracts', 'Signed 2025 Connaught Square Management Agreement.docx.pdf', 'contracts/Signed 2025 Connaught Square Management Agreement.docx.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('e01c8406-1412-4b2d-9653-f8e950c4e75e', '355128d6-4439-41b8-8979-640037f68e02', 'contracts', 'Connaught Square Management Agreement.docx', 'contracts/Connaught Square Management Agreement.docx');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('7b774b6c-e4d0-4684-bf33-533290356f9d', '355128d6-4439-41b8-8979-640037f68e02', 'contracts', '2025 Connaught Square Management Agreement.docx', 'contracts/2025 Connaught Square Management Agreement.docx');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('f7e0a885-4358-4b57-a758-a0cb61883fdb', '355128d6-4439-41b8-8979-640037f68e02', 'contracts', 'Signed Connaught Square Management Agreement.pdf', 'contracts/Signed Connaught Square Management Agreement.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('a3a79a55-c94d-4898-b7fa-9749fa74896d', '355128d6-4439-41b8-8979-640037f68e02', 'contracts', 'Contractors list.xlsx', 'contracts/Contractors list.xlsx');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('fd7db9ed-ac8f-4935-8912-1288f5bad01b', '355128d6-4439-41b8-8979-640037f68e02', 'contracts', 'Contractors list.xlsx', 'contracts/Contractors list.xlsx');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('159716ba-12a3-4fea-95e8-142d73cf7451', '355128d6-4439-41b8-8979-640037f68e02', 'contracts', 'EMERGENCY CALL OUT DETAILS 2024.pdf', 'contracts/EMERGENCY CALL OUT DETAILS 2024.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('53c23295-4095-4247-b99e-22f61cdbd2db', '355128d6-4439-41b8-8979-640037f68e02', 'contracts', 'CM434.PRO 2024-2025.pdf', 'contracts/CM434.PRO 2024-2025.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('d303a2ab-da58-4ee1-a528-f3d69a5fe155', '355128d6-4439-41b8-8979-640037f68e02', 'contracts', 'CM434.PRO.pdf', 'contracts/CM434.PRO.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('f403607f-82ce-412c-80d0-289ec84541bc', '355128d6-4439-41b8-8979-640037f68e02', 'contracts', 'Gas Contract 24-5.pdf', 'contracts/Gas Contract 24-5.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('3fa312b7-6a94-4d66-8870-32fe8c426785', '355128d6-4439-41b8-8979-640037f68e02', 'contracts', 'Contract_10-03-2025.pdf', 'contracts/Contract_10-03-2025.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('dbffe036-0427-415b-b42e-19d2386115fe', '355128d6-4439-41b8-8979-640037f68e02', 'contracts', 'Gas Contract 25-26.pdf', 'contracts/Gas Contract 25-26.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('839ce263-2452-40a8-a234-b9258acceb56', '355128d6-4439-41b8-8979-640037f68e02', 'correspondence', 'Welcome Letter - CG1885574.pdf', 'correspondence/Welcome Letter - CG1885574.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('1b237262-77d5-4926-841d-2665ab08688d', '355128d6-4439-41b8-8979-640037f68e02', 'contracts', 'Job 67141.pdf', 'contracts/Job 67141.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('95031539-f4da-4eb2-8e26-0d9d3f541f3a', '355128d6-4439-41b8-8979-640037f68e02', 'contracts', 'BLENHEIMS, 32-34 CONNAUGHT, W2 2HL - 19.05.23.pdf', 'contracts/BLENHEIMS, 32-34 CONNAUGHT, W2 2HL - 19.05.23.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('9df53ae5-04ba-4b97-878b-0239e22a51a1', '355128d6-4439-41b8-8979-640037f68e02', 'contracts', 'BLENHEIMS, 32-34 CONNAUGHT, W2 2HL - 22.03.23.pdf', 'contracts/BLENHEIMS, 32-34 CONNAUGHT, W2 2HL - 22.03.23.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('7869ee32-022e-46ee-94a0-0e886a2fa9de', '355128d6-4439-41b8-8979-640037f68e02', 'contracts', 'BLENHEIMS, 32-34 CONNAUGHT, W2 2HL - 26.06.23.pdf', 'contracts/BLENHEIMS, 32-34 CONNAUGHT, W2 2HL - 26.06.23.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('494c2976-d63b-4149-a927-9d2a809ba748', '355128d6-4439-41b8-8979-640037f68e02', 'contracts', 'BLENHEIMS, 32-34 CONNAUGHT, W2 2HL - 19.05.23.pdf', 'contracts/BLENHEIMS, 32-34 CONNAUGHT, W2 2HL - 19.05.23.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('c2efc957-b15b-4626-ad94-ddb24a3a7f92', '355128d6-4439-41b8-8979-640037f68e02', 'contracts', 'BLENHEIMS, 32-34 CONNAUGHT, W2 2HL - 22.03.23.pdf', 'contracts/BLENHEIMS, 32-34 CONNAUGHT, W2 2HL - 22.03.23.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('98674791-adc1-4312-a390-801e31fe5863', '355128d6-4439-41b8-8979-640037f68e02', 'contracts', 'BLENHEIMS, 32-34 CONNAUGHT, W2 2HL - 26.06.23.pdf', 'contracts/BLENHEIMS, 32-34 CONNAUGHT, W2 2HL - 26.06.23.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('e34e0201-3686-4c82-a27c-1b88b3e57c0d', '355128d6-4439-41b8-8979-640037f68e02', 'contracts', 'Jobcard_For_Job_No_27067_07-10-2024_1147.pdf', 'contracts/Jobcard_For_Job_No_27067_07-10-2024_1147.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('18d8f613-cfa4-40c9-b03e-9441029dc93b', '355128d6-4439-41b8-8979-640037f68e02', 'contracts', 'Jobcard_For_Job_No_19665_28-03-2024_0936.pdf', 'contracts/Jobcard_For_Job_No_19665_28-03-2024_0936.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('b2ffb147-bbbf-4707-b095-fc0f9fa75daf', '355128d6-4439-41b8-8979-640037f68e02', 'contracts', 'Jobcard_For_Job_No_22634_03-07-2024_1649.pdf', 'contracts/Jobcard_For_Job_No_22634_03-07-2024_1649.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('4b8548fe-76cc-4323-9157-a6b419adf7e1', '355128d6-4439-41b8-8979-640037f68e02', 'contracts', 'Jobcard_For_Job_No_25732_03-10-2024_1337.pdf', 'contracts/Jobcard_For_Job_No_25732_03-10-2024_1337.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('50dd5223-82aa-41ed-83e9-c551d3f6c380', '355128d6-4439-41b8-8979-640037f68e02', 'contracts', 'Lift Contract-Jacksons lift.pdf', 'contracts/Lift Contract-Jacksons lift.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('54948249-009e-4e35-a31e-89a57907ad39', '355128d6-4439-41b8-8979-640037f68e02', 'contracts', 'JLGCalloutVisit-5455045-12-07-2024.pdf', 'contracts/JLGCalloutVisit-5455045-12-07-2024.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('df6499f4-b063-4f52-a244-5446d196fcda', '355128d6-4439-41b8-8979-640037f68e02', 'contracts', 'JLGCalloutVisit-5483206-26-10-2024.pdf', 'contracts/JLGCalloutVisit-5483206-26-10-2024.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('02870e33-1df3-429e-84da-58806a776fb6', '355128d6-4439-41b8-8979-640037f68e02', 'contracts', 'JLGCalloutVisit-5498439-16-12-2024.pdf', 'contracts/JLGCalloutVisit-5498439-16-12-2024.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('76cdb2e5-2ad0-4b4e-84f5-dd0551354a89', '355128d6-4439-41b8-8979-640037f68e02', 'contracts', 'JLGCalloutVisit-5455462-16-07-2024.pdf', 'contracts/JLGCalloutVisit-5455462-16-07-2024.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('3e5a600b-81f9-42da-9d03-efc088e0b3c5', '355128d6-4439-41b8-8979-640037f68e02', 'contracts', 'JLGCalloutVisit-5497480-13-12-2024.pdf', 'contracts/JLGCalloutVisit-5497480-13-12-2024.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('6688fc1a-6385-49b0-966b-f2ecd1f81dae', '355128d6-4439-41b8-8979-640037f68e02', 'contracts', 'Engineering Report - 32-34 CONNAUGHT SQUARE.pdf', 'contracts/Engineering Report - 32-34 CONNAUGHT SQUARE.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('8b01477c-31fe-440b-b9ca-4c11ff46fe2c', '355128d6-4439-41b8-8979-640037f68e02', 'contracts', 'Arch Directors and Officers Liability Insurance for Residents Associations (12.22).pdf', 'contracts/Arch Directors and Officers Liability Insurance for Residents Associations (12.22).pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('88866068-084d-4ce2-b99c-75fd5d192ea4', '355128d6-4439-41b8-8979-640037f68e02', 'contracts', 'StG_Policy Wording_32-34 Connaught Square W2 2HL.pdf', 'contracts/StG_Policy Wording_32-34 Connaught Square W2 2HL.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('0b28dde8-d27f-4f4d-a88c-89776ce646ba', '355128d6-4439-41b8-8979-640037f68e02', 'compliance', 'Fire Extinguisher Signed Contract- Connaught Square.pdf', 'compliance/Fire Extinguisher Signed Contract- Connaught Square.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('a404f80d-3b8a-45db-959e-5d563c541da1', '355128d6-4439-41b8-8979-640037f68e02', 'contracts', 'Q51691 - 32-34 Connaught Square Contract.pdf', 'contracts/Q51691 - 32-34 Connaught Square Contract.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('b540bd58-8b3b-42c9-a8a1-c78e9ebf13ad', '355128d6-4439-41b8-8979-640037f68e02', 'contracts', 'Engineering Report - 32-34 CONNAUGHT SQUARE.pdf', 'contracts/Engineering Report - 32-34 CONNAUGHT SQUARE.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('0a5fce05-e90b-45e3-80b2-65954fd50995', '355128d6-4439-41b8-8979-640037f68e02', 'compliance', 'Fire Alarm+Emergency Lighting Signed Contract-3234 Connaught Square.pdf', 'compliance/Fire Alarm+Emergency Lighting Signed Contract-3234 Connaught Square.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('42d9159e-7632-4b54-82b9-3919930bb4a8', '355128d6-4439-41b8-8979-640037f68e02', 'compliance', 'Fire Alarm+Emergency Lighting Contract Connaught Square.pdf', 'compliance/Fire Alarm+Emergency Lighting Contract Connaught Square.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('414b521c-c7b7-4c57-b48e-30bc387508ca', '355128d6-4439-41b8-8979-640037f68e02', 'contracts', 'BT3205 03072025.pdf', 'contracts/BT3205 03072025.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('5038d5bf-675a-42ee-9254-e29fda1ac470', '355128d6-4439-41b8-8979-640037f68e02', 'contracts', 'FA7817 SERVICE 08042025.pdf', 'contracts/FA7817 SERVICE 08042025.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('386a9fec-4084-408c-af93-c63b26cf6c26', '355128d6-4439-41b8-8979-640037f68e02', 'contracts', 'Engineer Report - 32-34 Connaught Square Flat 5.pdf', 'contracts/Engineer Report - 32-34 Connaught Square Flat 5.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('bfb9a096-7640-4f2a-84f3-b9b8b8b97abf', '355128d6-4439-41b8-8979-640037f68e02', 'contracts', 'Engineering Report - 32-34 CONNAUGHT SQUARE.pdf', 'contracts/Engineering Report - 32-34 CONNAUGHT SQUARE.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('f3c48d6d-83aa-4ba1-bcca-377d8aba7534', '355128d6-4439-41b8-8979-640037f68e02', 'contracts', 'Jobcard_For_Job_No_22171_14-05-2024_1202.pdf', 'contracts/Jobcard_For_Job_No_22171_14-05-2024_1202.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('0d056575-3933-4684-8cdb-ceab0a6dac2f', '355128d6-4439-41b8-8979-640037f68e02', 'finance', 'British Gas Invoice-862451083.pdf', 'finance/British Gas Invoice-862451083.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('4652210e-4756-4cad-bd73-b6806fe56e12', '355128d6-4439-41b8-8979-640037f68e02', 'contracts', 'MT8825 03072025.pdf', 'contracts/MT8825 03072025.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('7f8399a4-590a-4e69-9e4b-b6472e80046e', '355128d6-4439-41b8-8979-640037f68e02', 'contracts', 'January Monthly Test For EL-Connaught Square.pdf', 'contracts/January Monthly Test For EL-Connaught Square.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('18431e92-76df-4719-98d5-73dbcda316b6', '355128d6-4439-41b8-8979-640037f68e02', 'contracts', 'February Monthly Test For EL-Connaught Square.pdf', 'contracts/February Monthly Test For EL-Connaught Square.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path, entity_type, linked_entity_id) VALUES ('dc987627-094e-479b-af7c-0c27de7017f5', '355128d6-4439-41b8-8979-640037f68e02', 'major_works', 'External Decorations SOI - 28042025.docx', 'major_works/External Decorations SOI - 28042025.docx', 'major_works_project', '6cf957e0-8ab3-4fad-b322-2f9ce3edb3e8');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path, entity_type, linked_entity_id) VALUES ('21e9c729-2cea-4f4b-a35b-ea5830721612', '355128d6-4439-41b8-8979-640037f68e02', 'major_works', 'External Dec SOE 03072025.docx', 'major_works/External Dec SOE 03072025.docx', 'major_works_project', '2840a082-9c31-45c4-98e8-2fffaa79cb75');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path, entity_type, linked_entity_id) VALUES ('fc2c17c3-c11b-40b0-810f-f53a1cf8807b', '355128d6-4439-41b8-8979-640037f68e02', 'major_works', 'Notice of intention for lift.docx', 'major_works/Notice of intention for lift.docx', 'major_works_project', 'cabca1a1-2f6b-4e43-89b8-da9245434786');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path, entity_type, linked_entity_id) VALUES ('46208d3b-08ac-459a-b58e-ec4a57be0f44', '355128d6-4439-41b8-8979-640037f68e02', 'major_works', 'Connaught Square (32-34) - 09.12.24 Schematic.pdf', 'major_works/Connaught Square (32-34) - 09.12.24 Schematic.pdf', 'major_works_project', '08933699-a154-4745-bdd7-7c10677582fd');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('1e3201c2-67a0-480f-b681-9621528f4d41', '355128d6-4439-41b8-8979-640037f68e02', 'compliance', 'CGBI3964546XB6-Cunaku Construction Ltd-Business-Certificate of insurance.pdf', 'compliance/CGBI3964546XB6-Cunaku Construction Ltd-Business-Certificate of insurance.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('2fdd4938-dd73-4839-bbae-aa2ba3440277', '355128d6-4439-41b8-8979-640037f68e02', 'compliance', 'CGBI3964546XB7-Cunaku Construction Ltd-Business-Certificate of insurance.pdf', 'compliance/CGBI3964546XB7-Cunaku Construction Ltd-Business-Certificate of insurance.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('e532da53-e943-4425-a126-a1a4e4f57caa', '355128d6-4439-41b8-8979-640037f68e02', 'compliance', 'Real Estate Insurance NTP (01.23).pdf', 'compliance/Real Estate Insurance NTP (01.23).pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('1aa5c335-45dc-4c8a-a4c8-32566bb5c41c', '355128d6-4439-41b8-8979-640037f68e02', 'compliance', 'Real Estate Policy (01.23).pdf', 'compliance/Real Estate Policy (01.23).pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('295a4e03-1942-4f39-bab7-e87f56fce714', '355128d6-4439-41b8-8979-640037f68e02', 'compliance', 'Summary of Cover (01.23).pdf', 'compliance/Summary of Cover (01.23).pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('e7d8c1d8-0e21-4dc6-8ed2-a5dfef610b4d', '355128d6-4439-41b8-8979-640037f68e02', 'compliance', '2023 Allianz VOC - 32-34 Connuaght Square (Freehold) Limited.pdf', 'compliance/2023 Allianz VOC - 32-34 Connuaght Square (Freehold) Limited.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('dee91cc3-eeca-4f81-a260-51e2e3b63181', '355128d6-4439-41b8-8979-640037f68e02', 'correspondence', '2023 Engineering Renewal Notice - 32 34 Connuaght Square (Freehold) Limited.pdf', 'correspondence/2023 Engineering Renewal Notice - 32 34 Connuaght Square (Freehold) Limited.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('506ac3d0-3439-4120-b082-5786e6be7f8b', '355128d6-4439-41b8-8979-640037f68e02', 'compliance', '32-34 Connaught Square Freehold Limited - Arch D&O Schedule.pdf', 'compliance/32-34 Connaught Square Freehold Limited - Arch D&O Schedule.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('a0da4a90-612a-4678-af33-da8c440fb32d', '355128d6-4439-41b8-8979-640037f68e02', 'compliance', '32-34 Connaught Sq Buildings Insurance 2023-2024.pdf', 'compliance/32-34 Connaught Sq Buildings Insurance 2023-2024.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('9da9b529-ac47-4872-8d76-f026213edfe8', '355128d6-4439-41b8-8979-640037f68e02', 'compliance', 'Policy Limits Document.pdf', 'compliance/Policy Limits Document.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('433f3877-45b7-492e-9434-8afff34c1a0d', '355128d6-4439-41b8-8979-640037f68e02', 'lease', 'Official Copy (Lease) 13.06.2003 - NGL823646-Flat 4.pdf', 'lease/Official Copy (Lease) 13.06.2003 - NGL823646-Flat 4.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('0be5a45e-b97d-43fd-910a-a2616965c577', '355128d6-4439-41b8-8979-640037f68e02', 'correspondence', 'Letter of Authority - Connaught Square.doc.pdf', 'correspondence/Letter of Authority - Connaught Square.doc.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('eb6fd8db-874c-4eb4-812b-7d06e74d69df', '355128d6-4439-41b8-8979-640037f68e02', 'correspondence', 'Letter to report - Connaught Square.doc.pdf', 'correspondence/Letter to report - Connaught Square.doc.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('7dd0b80f-2cdf-4b2a-ba09-72fed15bbddf', '355128d6-4439-41b8-8979-640037f68e02', 'contracts', 'Pricing Quote - 32_34 Connaught Square Freehold Ltd - 109 - Gas - 10.03.2025.pdf', 'contracts/Pricing Quote - 32_34 Connaught Square Freehold Ltd - 109 - Gas - 10.03.2025.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('d89b0b02-86f3-4294-9c0e-f028447644b2', '355128d6-4439-41b8-8979-640037f68e02', 'compliance', 'Allianz - Lift Report 14.03.23.pdf', 'compliance/Allianz - Lift Report 14.03.23.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('bec4d915-c81d-48c1-988c-34184a1ee713', '355128d6-4439-41b8-8979-640037f68e02', 'compliance', 'Allianz-Lift Report 18.03.2024.pdf', 'compliance/Allianz-Lift Report 18.03.2024.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('42b40664-bcf0-4040-8864-39855cf54caa', '355128d6-4439-41b8-8979-640037f68e02', 'compliance', 'Allianz - Lift Report - 15.09.21.pdf', 'compliance/Allianz - Lift Report - 15.09.21.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('4714c604-9e78-46a0-9ea2-a8c798571294', '355128d6-4439-41b8-8979-640037f68e02', 'compliance', 'Allianz - Lift Report 27.09.23.pdf', 'compliance/Allianz - Lift Report 27.09.23.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('29418bc8-d259-492d-9e15-6a1f0d802471', '355128d6-4439-41b8-8979-640037f68e02', 'compliance', 'Allianz - Lift Report 10.03.22.pdf', 'compliance/Allianz - Lift Report 10.03.22.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('e50177ed-5235-44de-98ac-ed3ae1eec295', '355128d6-4439-41b8-8979-640037f68e02', 'compliance', 'Allianz - Lift Report 09.09.22.pdf', 'compliance/Allianz - Lift Report 09.09.22.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('0f1f09be-3350-42fa-b925-2680f6bb2968', '355128d6-4439-41b8-8979-640037f68e02', 'compliance', 'LXBI3559280XB2-NEW STEP-Business-Certificate of insurance.pdf', 'compliance/LXBI3559280XB2-NEW STEP-Business-Certificate of insurance.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('370f7c3b-f56b-4f8f-9098-878de83edb21', '355128d6-4439-41b8-8979-640037f68e02', 'compliance', '2023 Allianz VOC - 32-34 Connuaght Square (Freehold) Limited.pdf', 'compliance/2023 Allianz VOC - 32-34 Connuaght Square (Freehold) Limited.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('ba67dd3b-d761-4ac8-9209-91057955b959', '355128d6-4439-41b8-8979-640037f68e02', 'correspondence', '2023 Engineering Renewal Notice - 32 34 Connuaght Square (Freehold) Limited.pdf', 'correspondence/2023 Engineering Renewal Notice - 32 34 Connuaght Square (Freehold) Limited.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('3540b29a-be63-459d-9305-71397bb71462', '355128d6-4439-41b8-8979-640037f68e02', 'compliance', 'MO - Policy Wording - NZ0411.pdf', 'compliance/MO - Policy Wording - NZ0411.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('1f3c94e0-809f-4a0c-a6c0-756facf69150', '355128d6-4439-41b8-8979-640037f68e02', 'compliance', 'Feature and Benefits of Allianz Engineering Inspection Service.pdf', 'compliance/Feature and Benefits of Allianz Engineering Inspection Service.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('c6162dd0-a000-4603-835c-e06a4c243192', '355128d6-4439-41b8-8979-640037f68e02', 'compliance', 'StG_Insurer pack_32-34 Connaught Square Freehold Limited.pdf', 'compliance/StG_Insurer pack_32-34 Connaught Square Freehold Limited.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('a1f19fab-375a-4145-ac7d-71886623a33c', '355128d6-4439-41b8-8979-640037f68e02', 'compliance', 'StG_Statement of Facts_32-34 Connaught Square W2 2HL.pdf', 'compliance/StG_Statement of Facts_32-34 Connaught Square W2 2HL.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('91cebf73-6589-41a0-b5e9-a3baec614540', '355128d6-4439-41b8-8979-640037f68e02', 'compliance', 'StG_Insurance Report_32-34 Connaught Square W2 2HL.pdf', 'compliance/StG_Insurance Report_32-34 Connaught Square W2 2HL.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('6bb5e0a5-3a3d-4c60-84c2-dfb79424bac5', '355128d6-4439-41b8-8979-640037f68e02', 'compliance', 'StG_Insurer pack_32-34 Connaught Square Freehold Limited.pdf', 'compliance/StG_Insurer pack_32-34 Connaught Square Freehold Limited.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('a7fa2bc8-2791-499c-b593-4b66c4a2cf9f', '355128d6-4439-41b8-8979-640037f68e02', 'compliance', 'StG_Statement of Facts_32-34 Connaught Square W2 2HL.pdf', 'compliance/StG_Statement of Facts_32-34 Connaught Square W2 2HL.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('0eb4b504-0f25-4085-b20b-4b103d21bdf9', '355128d6-4439-41b8-8979-640037f68e02', 'compliance', 'StG_Insurance Report_32-34 Connaught Square W2 2HL.pdf', 'compliance/StG_Insurance Report_32-34 Connaught Square W2 2HL.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('6cfa2ce2-b109-4970-a31e-0c663348c97f', '355128d6-4439-41b8-8979-640037f68e02', 'finance', 'StG_Invoice_32-34 Connaught Square W2 2HL.pdf', 'finance/StG_Invoice_32-34 Connaught Square W2 2HL.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('0f2c8c06-8266-4d69-b371-a6d1264053c3', '355128d6-4439-41b8-8979-640037f68e02', 'compliance', 'StG_Certificate_32-34 Connaught Square W2 2HL.pdf', 'compliance/StG_Certificate_32-34 Connaught Square W2 2HL.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('a729565c-294f-4d71-b10a-0d18e6f7e610', '355128d6-4439-41b8-8979-640037f68e02', 'compliance', 'StG_Insurer pack_32-34 Connaught Square Freehold Limited.pdf', 'compliance/StG_Insurer pack_32-34 Connaught Square Freehold Limited.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('27950e4d-7b7e-4681-8dda-af20076e2029', '355128d6-4439-41b8-8979-640037f68e02', 'compliance', 'StG_Statement of Fact_32-34 Connaught Square W2 2HL.pdf', 'compliance/StG_Statement of Fact_32-34 Connaught Square W2 2HL.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('e9e897ae-3fc2-4094-8220-c9df13020177', '355128d6-4439-41b8-8979-640037f68e02', 'finance', 'StG_Invoice_32-34 Connaught Square Freehold Limited.pdf', 'finance/StG_Invoice_32-34 Connaught Square Freehold Limited.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('e5af4c6f-6ce2-4899-abd4-dd2dc8923e97', '355128d6-4439-41b8-8979-640037f68e02', 'compliance', '32-34 Connaught Square Freehold Limited - Arch D&O Schedule.pdf', 'compliance/32-34 Connaught Square Freehold Limited - Arch D&O Schedule.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('bed09d9f-f4a3-4df5-9ee4-f0f88191ec4a', '355128d6-4439-41b8-8979-640037f68e02', 'compliance', 'StG_Certificate_32-34 Connaught Square Freehold Limited.pdf', 'compliance/StG_Certificate_32-34 Connaught Square Freehold Limited.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('64996250-0ba6-4d72-a475-e8eae804c558', '355128d6-4439-41b8-8979-640037f68e02', 'compliance', 'StG_Policy Wording_32-34 Connaught Square Freehold Limited.pdf', 'compliance/StG_Policy Wording_32-34 Connaught Square Freehold Limited.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('88daa995-cced-46db-b9f3-9d454d710247', '355128d6-4439-41b8-8979-640037f68e02', 'compliance', 'StG_D&O Endorsements_32-34 Connaught Square Freehold Limited.pdf', 'compliance/StG_D&O Endorsements_32-34 Connaught Square Freehold Limited.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('d972c1cb-053d-4e04-899a-77840279f79b', '355128d6-4439-41b8-8979-640037f68e02', 'finance', 'StG_Demands & Needs_32-34 Connaught Square Freehold Limited.pdf', 'finance/StG_Demands & Needs_32-34 Connaught Square Freehold Limited.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('7885740c-26b8-408e-a834-3063a1c28a70', '355128d6-4439-41b8-8979-640037f68e02', 'contracts', 'StG_Quote_32-34 Connaught Square Freehold Limited.pdf', 'contracts/StG_Quote_32-34 Connaught Square Freehold Limited.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('b59e639a-ad86-46ff-86f3-6b9d134d1103', '355128d6-4439-41b8-8979-640037f68e02', 'compliance', 'StG_Insurance Report_32-34 Connaught Square W2 2HL.pdf', 'compliance/StG_Insurance Report_32-34 Connaught Square W2 2HL.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('89726d8e-47c9-485c-8847-514c9bdef008', '355128d6-4439-41b8-8979-640037f68e02', 'compliance', 'FBR113382303-20230405-B.pdf', 'compliance/FBR113382303-20230405-B.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('373b9b2f-856c-4fce-9b60-8b5653b4f9cb', '355128d6-4439-41b8-8979-640037f68e02', 'compliance', 'Real Estate Insurance NTP (01.23).pdf', 'compliance/Real Estate Insurance NTP (01.23).pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('d963eef6-6f04-41ed-8ddd-d8bcc89f207b', '355128d6-4439-41b8-8979-640037f68e02', 'compliance', 'Real Estate Policy (01.23).pdf', 'compliance/Real Estate Policy (01.23).pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('4a0f3290-ee64-4fe9-a214-1ca3a6ec6f4a', '355128d6-4439-41b8-8979-640037f68e02', 'compliance', 'Summary of Cover (01.23).pdf', 'compliance/Summary of Cover (01.23).pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('8496f98c-a4c4-4c5b-aee7-4d784bfb57b7', '355128d6-4439-41b8-8979-640037f68e02', 'compliance', '32-34 Connaught Sq Buildings Insurance 2023-2024.pdf', 'compliance/32-34 Connaught Sq Buildings Insurance 2023-2024.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('8fea87ff-62ae-4992-b413-eb79f26b7b3e', '355128d6-4439-41b8-8979-640037f68e02', 'compliance', 'Policy Limits Document.pdf', 'compliance/Policy Limits Document.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('50a44d0a-fae6-422f-9c6c-9b886b479d20', '355128d6-4439-41b8-8979-640037f68e02', 'compliance', 'Zurich Real Estate Policy Summary.pdf', 'compliance/Zurich Real Estate Policy Summary.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('5223e44f-a9d4-4854-8bad-9e9d0d58d12e', '355128d6-4439-41b8-8979-640037f68e02', 'compliance', 'Zurich Real Estate Policy Wording.pdf', 'compliance/Zurich Real Estate Policy Wording.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('5fbb5058-4bde-4ae2-83b1-24fefcbec995', '355128d6-4439-41b8-8979-640037f68e02', 'compliance', 'Zurich Real Estate Insurance NTP (01.23) ZCYP895.02.pdf', 'compliance/Zurich Real Estate Insurance NTP (01.23) ZCYP895.02.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('346c8ac6-6795-492b-8e08-b0857ed1a163', '355128d6-4439-41b8-8979-640037f68e02', 'finance', 'StG_Invoice_32-34 Connaught Square W2 2HL.pdf', 'finance/StG_Invoice_32-34 Connaught Square W2 2HL.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('4d77d7cb-864f-4696-b90f-91e49fe2bbfb', '355128d6-4439-41b8-8979-640037f68e02', 'compliance', 'StG_Certificate_32-34 Connaught Square W2 2HL.pdf', 'compliance/StG_Certificate_32-34 Connaught Square W2 2HL.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('bd7c8241-8a84-4d32-b54c-d99989ee87ae', '355128d6-4439-41b8-8979-640037f68e02', 'compliance', 'StG_Supporting Docs_32-34 Connaught Square W2 2HL.pdf', 'compliance/StG_Supporting Docs_32-34 Connaught Square W2 2HL.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('c9da4f0f-48a2-413f-ab66-4f8f7d0875c1', '355128d6-4439-41b8-8979-640037f68e02', 'finance', 'StG_Invoice_32-34 Connaught Square W2 2HL.pdf', 'finance/StG_Invoice_32-34 Connaught Square W2 2HL.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('1cc33093-9739-4875-95af-d15d102d1799', '355128d6-4439-41b8-8979-640037f68e02', 'compliance', 'StG_Certificate_32-34 Connaught Square W2 2HL.pdf', 'compliance/StG_Certificate_32-34 Connaught Square W2 2HL.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('97a4761c-a0e4-4a23-9f82-70e02910166f', '355128d6-4439-41b8-8979-640037f68e02', 'compliance', 'StG_Statement of Fact_32-34 Connaught Square W2 2HL.pdf', 'compliance/StG_Statement of Fact_32-34 Connaught Square W2 2HL.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('8c6ef93d-ba7a-4a61-afbe-5a83f9766195', '355128d6-4439-41b8-8979-640037f68e02', 'finance', 'StG_Invoice_32-34 Connaught Square W2 2HL.pdf', 'finance/StG_Invoice_32-34 Connaught Square W2 2HL.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('d820510b-86aa-4457-9656-52cc0f91b343', '355128d6-4439-41b8-8979-640037f68e02', 'compliance', 'StG_Statement of Fact_32-34 Connaught Square W2 2HL.pdf', 'compliance/StG_Statement of Fact_32-34 Connaught Square W2 2HL.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('563c6d93-7759-45da-addb-4bc860fa9c64', '355128d6-4439-41b8-8979-640037f68e02', 'uncategorised', 'Connaught Square New property information.xlsx', 'uncategorised/Connaught Square New property information.xlsx');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('24a95e88-b95f-4042-8e9f-4d0aca88cdda', '355128d6-4439-41b8-8979-640037f68e02', 'uncategorised', 'Connaught Square Meeting Minutes 2.docx', 'uncategorised/Connaught Square Meeting Minutes 2.docx');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('0f65b0e3-daff-489e-bdd0-42d21b27276a', '355128d6-4439-41b8-8979-640037f68e02', 'uncategorised', 'connaught.xlsx', 'uncategorised/connaught.xlsx');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('54eec044-9037-4f2b-aa37-d4a56e68339e', '355128d6-4439-41b8-8979-640037f68e02', 'uncategorised', 'matrix - pp.xlsx', 'uncategorised/matrix - pp.xlsx');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('220f0188-43a4-4195-b9e0-2f42388b4de4', '355128d6-4439-41b8-8979-640037f68e02', 'uncategorised', '12. Change of Tenancy - EDF supporting document.docx', 'uncategorised/12. Change of Tenancy - EDF supporting document.docx');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('d8f22ee7-cb59-4414-9bea-0d345d7c6695', '355128d6-4439-41b8-8979-640037f68e02', 'correspondence', 'Correspondence letter.pdf', 'correspondence/Correspondence letter.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('486a6791-f0b3-4fcd-88de-b7c1bdb858f8', '355128d6-4439-41b8-8979-640037f68e02', 'uncategorised', 'tenant list - pp.xlsx', 'uncategorised/tenant list - pp.xlsx');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('26a12a38-d197-4e33-90ad-e627fd97262e', '355128d6-4439-41b8-8979-640037f68e02', 'uncategorised', 'Report - 32-34 Connaught Square BCH 78350.pdf', 'uncategorised/Report - 32-34 Connaught Square BCH 78350.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('bd2bc5dc-a3f8-4c3d-b390-bcd3eb5474c5', '355128d6-4439-41b8-8979-640037f68e02', 'uncategorised', 'Connaught Square Meeting Minutes 2.docx', 'uncategorised/Connaught Square Meeting Minutes 2.docx');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('238c8192-a9cb-4c74-bb12-782562b4519b', '355128d6-4439-41b8-8979-640037f68e02', 'uncategorised', 'Connaught Square Meeting Minutes 20241120.docx', 'uncategorised/Connaught Square Meeting Minutes 20241120.docx');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('a1fa138f-939f-403d-a34a-cf7ed4162ca0', '355128d6-4439-41b8-8979-640037f68e02', 'uncategorised', 'Connaught Square Meeting Minutes.docx', 'uncategorised/Connaught Square Meeting Minutes.docx');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('775058a9-f6a8-4832-b3e8-950f8399def1', '355128d6-4439-41b8-8979-640037f68e02', 'uncategorised', 'Connaught Square Admin Duties of Co Sec.docx', 'uncategorised/Connaught Square Admin Duties of Co Sec.docx');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('83b741d9-0598-4e0b-9c71-4088b9bf7d80', '355128d6-4439-41b8-8979-640037f68e02', 'uncategorised', 'Signed Connaught Square Admin Duties of Co Sec.pdf', 'uncategorised/Signed Connaught Square Admin Duties of Co Sec.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('de258762-22cd-4fe0-963d-ef050ee32c7d', '355128d6-4439-41b8-8979-640037f68e02', 'uncategorised', '32_34 CONNAUGHT SQUARE FREEHOLD LIMITED - Statutory Registers on 22.03.2024.pdf', 'uncategorised/32_34 CONNAUGHT SQUARE FREEHOLD LIMITED - Statutory Registers on 22.03.2024.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('9b9f4901-83fd-4e50-8372-1a81a5e13c0d', '355128d6-4439-41b8-8979-640037f68e02', 'correspondence', 'Memorandum of Association.pdf', 'correspondence/Memorandum of Association.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('c922709d-e76e-43b7-8856-43049abed0e0', '355128d6-4439-41b8-8979-640037f68e02', 'uncategorised', 'Incorporation documents.pdf', 'uncategorised/Incorporation documents.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('d1e56ebb-7c02-4b8e-bd02-3851baceb558', '355128d6-4439-41b8-8979-640037f68e02', 'uncategorised', 'B25676 RS 21.05.24 RM CM.pdf', 'uncategorised/B25676 RS 21.05.24 RM CM.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('460814d9-71c3-445d-b578-258fb50f356c', '355128d6-4439-41b8-8979-640037f68e02', 'uncategorised', 'Report-20.08.2024.pdf', 'uncategorised/Report-20.08.2024.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('1b5d4c0d-4d93-4654-9de2-1a1aa0fc58b5', '355128d6-4439-41b8-8979-640037f68e02', 'correspondence', 'PN0119V1.7 Privacy Notice (Website).pdf', 'correspondence/PN0119V1.7 Privacy Notice (Website).pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('0349144a-42c6-4e6e-90eb-b7425ed0eb95', '355128d6-4439-41b8-8979-640037f68e02', 'correspondence', 'PN0119V1.8 Privacy Notice (Website).pdf', 'correspondence/PN0119V1.8 Privacy Notice (Website).pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('dea8cb3d-d12a-4d0c-9013-9d39365cc3ce', '355128d6-4439-41b8-8979-640037f68e02', 'uncategorised', 'REPORT 31-07-25.pdf', 'uncategorised/REPORT 31-07-25.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('7cb1cd57-16f9-4fc6-856c-34cfb606d04b', '355128d6-4439-41b8-8979-640037f68e02', 'uncategorised', '32-34 Connought Square Condtion Assessments.pdf', 'uncategorised/32-34 Connought Square Condtion Assessments.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('860fcdcb-3385-4319-8fe5-72e270eb42be', '355128d6-4439-41b8-8979-640037f68e02', 'uncategorised', 'Signed Conract.pdf', 'uncategorised/Signed Conract.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('593a60eb-79c1-4ba0-82cf-1462baa3cd75', '355128d6-4439-41b8-8979-640037f68e02', 'uncategorised', 'BLENHEIMS, CONNAUGHT, W2 2HL PHOTO - 22.01.24.pdf', 'uncategorised/BLENHEIMS, CONNAUGHT, W2 2HL PHOTO - 22.01.24.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('163b7455-e4c1-4903-a1dc-4a186c1576db', '355128d6-4439-41b8-8979-640037f68e02', 'uncategorised', 'BLENHEIMS, CONNAUGHT, W2 2HL PHOTO - 22.03.24.pdf', 'uncategorised/BLENHEIMS, CONNAUGHT, W2 2HL PHOTO - 22.03.24.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('c17851e7-3c24-4ef4-a2a7-b51dce6882e3', '355128d6-4439-41b8-8979-640037f68e02', 'uncategorised', 'Latest Report.pdf', 'uncategorised/Latest Report.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('28c0a5cc-ee9b-4816-ba81-eb73258940e4', '355128d6-4439-41b8-8979-640037f68e02', 'uncategorised', 'Latest Report 24.04.2024.pdf', 'uncategorised/Latest Report 24.04.2024.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('e13ff3ac-ab56-41a8-b3ca-bfb90303aca8', '355128d6-4439-41b8-8979-640037f68e02', 'uncategorised', 'Latest Report 19.09.2024.pdf', 'uncategorised/Latest Report 19.09.2024.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('f9d19814-274b-44ba-95b0-dddd930665e8', '355128d6-4439-41b8-8979-640037f68e02', 'uncategorised', 'BLENHEIMS, 32-34 CONNAUGHT, W2 2HL - 25.09.23.pdf', 'uncategorised/BLENHEIMS, 32-34 CONNAUGHT, W2 2HL - 25.09.23.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('0e494c9d-6a9c-46b8-b93a-b412ed1b3503', '355128d6-4439-41b8-8979-640037f68e02', 'uncategorised', 'BLENHEIMS, 32-34 CONNAUGHT, W2 2HL PHOTO - 29.11.23.pdf', 'uncategorised/BLENHEIMS, 32-34 CONNAUGHT, W2 2HL PHOTO - 29.11.23.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('6c02e2a2-13bb-472c-a115-cd3a453ffd55', '355128d6-4439-41b8-8979-640037f68e02', 'uncategorised', 'BLENHEIMS, 32-34 CONNAUGHT, W2 2HL PHOTO - 18.12.23.pdf', 'uncategorised/BLENHEIMS, 32-34 CONNAUGHT, W2 2HL PHOTO - 18.12.23.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('be8b85ae-efa2-4eac-b918-7f2f5be85e98', '355128d6-4439-41b8-8979-640037f68e02', 'uncategorised', 'BLENHEIMS, CONNAUGHT, W2 2HL PHOTO - 23.02.24.pdf', 'uncategorised/BLENHEIMS, CONNAUGHT, W2 2HL PHOTO - 23.02.24.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('123f82a2-3eb4-493f-a10b-933cc0851fcf', '355128d6-4439-41b8-8979-640037f68e02', 'uncategorised', '10.02.25-Pest Control.pdf', 'uncategorised/10.02.25-Pest Control.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('9554d532-4c2e-496e-bf6c-0d1ccab6032e', '355128d6-4439-41b8-8979-640037f68e02', 'uncategorised', 'Latest Report.pdf', 'uncategorised/Latest Report.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('c4721fa8-77b7-4973-bf0a-86a17d7cb3e1', '355128d6-4439-41b8-8979-640037f68e02', 'uncategorised', '17.01.2025-Pest Control.pdf', 'uncategorised/17.01.2025-Pest Control.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('d1dc810c-4083-46ee-8983-afb636da3f09', '355128d6-4439-41b8-8979-640037f68e02', 'uncategorised', 'J18503 - MIH, CONNAUGHT SQR, W2 - 04.04.25.pdf', 'uncategorised/J18503 - MIH, CONNAUGHT SQR, W2 - 04.04.25.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('3c8d1010-1934-4feb-b227-add46b140a86', '355128d6-4439-41b8-8979-640037f68e02', 'uncategorised', 'J18502 - MIH, CONNAUGHT SQR, W2 - 04.04.25.pdf', 'uncategorised/J18502 - MIH, CONNAUGHT SQR, W2 - 04.04.25.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('976dba22-2cac-40ea-82b4-d9a0799152ee', '355128d6-4439-41b8-8979-640037f68e02', 'uncategorised', 'BLENHEIMS, CONNAUGHT, W2 2HL PHOTO - 22.01.24.pdf', 'uncategorised/BLENHEIMS, CONNAUGHT, W2 2HL PHOTO - 22.01.24.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('f4712fab-5d21-43a1-97c4-1580150a174e', '355128d6-4439-41b8-8979-640037f68e02', 'uncategorised', 'BLENHEIMS, CONNAUGHT, W2 2HL PHOTO - 22.03.24.pdf', 'uncategorised/BLENHEIMS, CONNAUGHT, W2 2HL PHOTO - 22.03.24.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('451f22b5-56f0-44a8-9611-b6138be0a1be', '355128d6-4439-41b8-8979-640037f68e02', 'uncategorised', 'BLENHEIMS, 32-34 CONNAUGHT, W2 2HL - 25.09.23.pdf', 'uncategorised/BLENHEIMS, 32-34 CONNAUGHT, W2 2HL - 25.09.23.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('0fe19f51-28d3-40d5-bce6-b4ae3e236b7d', '355128d6-4439-41b8-8979-640037f68e02', 'uncategorised', 'BLENHEIMS, 32-34 CONNAUGHT, W2 2HL PHOTO - 29.11.23.pdf', 'uncategorised/BLENHEIMS, 32-34 CONNAUGHT, W2 2HL PHOTO - 29.11.23.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('d3044e55-41f7-41da-b396-dae09546fbb3', '355128d6-4439-41b8-8979-640037f68e02', 'uncategorised', 'BLENHEIMS, 32-34 CONNAUGHT, W2 2HL PHOTO - 18.12.23.pdf', 'uncategorised/BLENHEIMS, 32-34 CONNAUGHT, W2 2HL PHOTO - 18.12.23.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('84bb682b-7e9d-4862-b1a6-29bee6839030', '355128d6-4439-41b8-8979-640037f68e02', 'uncategorised', 'BLENHEIMS, CONNAUGHT, W2 2HL PHOTO - 23.02.24.pdf', 'uncategorised/BLENHEIMS, CONNAUGHT, W2 2HL PHOTO - 23.02.24.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('e690df75-f10c-471a-9556-d5f9fb41fde4', '355128d6-4439-41b8-8979-640037f68e02', 'uncategorised', 'INV 11546 Mr Martin Samworth.xlsx', 'uncategorised/INV 11546 Mr Martin Samworth.xlsx');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('677461ab-fee4-4ebb-a22a-c04f41bd6993', '355128d6-4439-41b8-8979-640037f68e02', 'uncategorised', 'QB4126 Mr Martin Samworth.docx', 'uncategorised/QB4126 Mr Martin Samworth.docx');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('2aa13258-c3cd-435c-8c52-0ed85df81726', '355128d6-4439-41b8-8979-640037f68e02', 'uncategorised', 'CQ2879 Mr Martin Samworth   (IP) CCTV.docx', 'uncategorised/CQ2879 Mr Martin Samworth   (IP) CCTV.docx');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('626a5893-b8e5-4e61-8d19-127b197d6344', '355128d6-4439-41b8-8979-640037f68e02', 'uncategorised', 'Asset_Record_For_Job_No_32810_17-03-2025_1311.pdf', 'uncategorised/Asset_Record_For_Job_No_32810_17-03-2025_1311.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('90a2e44a-063d-467e-b18b-07416a35be11', '355128d6-4439-41b8-8979-640037f68e02', 'uncategorised', 'Asset_Record_For_Job_No_32344_12-03-2025_1426.pdf', 'uncategorised/Asset_Record_For_Job_No_32344_12-03-2025_1426.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('bbc90072-68eb-4495-b40b-80409d8e0692', '355128d6-4439-41b8-8979-640037f68e02', 'uncategorised', 'Asset_Record_For_Job_No_37675_25-07-2025_1549.pdf', 'uncategorised/Asset_Record_For_Job_No_37675_25-07-2025_1549.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('4c00e5d2-0afc-4075-a67c-47af94a2d19f', '355128d6-4439-41b8-8979-640037f68e02', 'uncategorised', 'Asset_Record_For_Job_No_34012_01-05-2025_1616.pdf', 'uncategorised/Asset_Record_For_Job_No_34012_01-05-2025_1616.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('99201665-95c2-413d-8634-0828bc903a89', '355128d6-4439-41b8-8979-640037f68e02', 'uncategorised', 'Asset_Record_For_Job_No_32759_17-03-2025_1147.pdf', 'uncategorised/Asset_Record_For_Job_No_32759_17-03-2025_1147.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('fca54970-5733-435c-bb8b-3ca8375ca5d6', '355128d6-4439-41b8-8979-640037f68e02', 'uncategorised', 'Jobcard_For_Job_No_32344_12-03-2025_1426.pdf', 'uncategorised/Jobcard_For_Job_No_32344_12-03-2025_1426.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('90cbea81-a6fb-4043-a3ff-3177327f3f6f', '355128d6-4439-41b8-8979-640037f68e02', 'uncategorised', 'Asset_Record_For_Job_No_33844_07-04-2025_1143.pdf', 'uncategorised/Asset_Record_For_Job_No_33844_07-04-2025_1143.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('779d36e4-583b-42ec-bb50-d78efa4bf82e', '355128d6-4439-41b8-8979-640037f68e02', 'uncategorised', 'Asset_Record_For_Job_No_25732_03-10-2024_1337.pdf', 'uncategorised/Asset_Record_For_Job_No_25732_03-10-2024_1337.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('8c137423-aede-403a-ab90-fbfd90ce5e29', '355128d6-4439-41b8-8979-640037f68e02', 'uncategorised', 'Asset_Record_For_Job_No_22634_03-07-2024_1650.pdf', 'uncategorised/Asset_Record_For_Job_No_22634_03-07-2024_1650.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('460c56bd-2a71-4ef6-b467-df66db0fbad2', '355128d6-4439-41b8-8979-640037f68e02', 'uncategorised', 'Asset_Record_For_Job_No_27067_07-10-2024_1147.pdf', 'uncategorised/Asset_Record_For_Job_No_27067_07-10-2024_1147.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('1a26cfcf-3175-4f0d-a171-3defd51c8a30', '355128d6-4439-41b8-8979-640037f68e02', 'uncategorised', 'Asset_Record_For_Job_No_19665_05-04-2024_1048.pdf', 'uncategorised/Asset_Record_For_Job_No_19665_05-04-2024_1048.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('4ab984e6-2353-44a7-ac62-fe8610c8804c', '355128d6-4439-41b8-8979-640037f68e02', 'contracts', 'Connaught Square-Lift Quotes.xlsx', 'contracts/Connaught Square-Lift Quotes.xlsx');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('287d84d4-41fb-485b-9322-6fa92ab79b43', '355128d6-4439-41b8-8979-640037f68e02', 'uncategorised', 'LXBI3559280XB2-NEW STEP-Business-Certificate of el insurance.pdf', 'uncategorised/LXBI3559280XB2-NEW STEP-Business-Certificate of el insurance.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('9f7f805f-ee84-44d5-a7c4-3e6f39bb0e55', '355128d6-4439-41b8-8979-640037f68e02', 'uncategorised', 'New Step - Cleaning of Com Part- Jan- 2023.pdf', 'uncategorised/New Step - Cleaning of Com Part- Jan- 2023.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('9232733b-a93b-4b55-a122-676175461eb4', '355128d6-4439-41b8-8979-640037f68e02', 'uncategorised', 'Aged debtors by property.pdf', 'uncategorised/Aged debtors by property.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('34ecbfac-3b92-4b9d-a405-92d518545890', '355128d6-4439-41b8-8979-640037f68e02', 'uncategorised', 'Connaught Square, 32-34 Approved xlsx.xlsx', 'uncategorised/Connaught Square, 32-34 Approved xlsx.xlsx');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('283e5402-6c34-47e6-841d-1fea1230d357', '355128d6-4439-41b8-8979-640037f68e02', 'uncategorised', 'BvA 24 Jan 25.xlsx', 'uncategorised/BvA 24 Jan 25.xlsx');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('26a4cadd-605c-4629-b30e-d115e80d0633', '355128d6-4439-41b8-8979-640037f68e02', 'uncategorised', 'pdf.pdf', 'uncategorised/pdf.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('7cb4a243-40a2-4a97-bcb1-cbcbc9787019', '355128d6-4439-41b8-8979-640037f68e02', 'uncategorised', 'Connaught Square-Agenda 20.11.24.docx', 'uncategorised/Connaught Square-Agenda 20.11.24.docx');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('023ef08d-4014-455d-9257-d782af7a6216', '355128d6-4439-41b8-8979-640037f68e02', 'uncategorised', 'Connaught Square-Agenda 26.04.2024.docx', 'uncategorised/Connaught Square-Agenda 26.04.2024.docx');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('da24c98b-d301-4ba5-9ae6-277f9ec03db9', '355128d6-4439-41b8-8979-640037f68e02', 'uncategorised', 'Connaught Square 26.04.24.docx', 'uncategorised/Connaught Square 26.04.24.docx');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('e12433a0-2dec-4c55-b858-0cba4b661c48', '355128d6-4439-41b8-8979-640037f68e02', 'contracts', 'StG_Quote_32-34 Connaught Square W2 2HL.pdf', 'contracts/StG_Quote_32-34 Connaught Square W2 2HL.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('61a35265-fa70-4156-9ee3-70564a4339e8', '355128d6-4439-41b8-8979-640037f68e02', 'uncategorised', 'StG_Policy Wording_32-34 Connaught Square W2 2HL.pdf', 'uncategorised/StG_Policy Wording_32-34 Connaught Square W2 2HL.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('3bae3eee-99df-485f-88d2-875171799332', '355128d6-4439-41b8-8979-640037f68e02', 'contracts', 'StG_Quote_32-34 Connaught Square W2 2HL.pdf', 'contracts/StG_Quote_32-34 Connaught Square W2 2HL.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('12f05047-33d5-46e3-ba11-31da5f0edd4f', '355128d6-4439-41b8-8979-640037f68e02', 'uncategorised', 'StG_Policy Wording_32-34 Connaught Square W2 2HL.pdf', 'uncategorised/StG_Policy Wording_32-34 Connaught Square W2 2HL.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('07d6136f-aa33-42b0-be98-65cbd62ae663', '355128d6-4439-41b8-8979-640037f68e02', 'uncategorised', 'Report - 32-34 Connaught Square BCH 78350.pdf', 'uncategorised/Report - 32-34 Connaught Square BCH 78350.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('66d5ad64-5688-4491-97ed-37998e69b690', '355128d6-4439-41b8-8979-640037f68e02', 'uncategorised', 'Asset_Record_For_Job_No_16617_27-11-2023_1522.pdf', 'uncategorised/Asset_Record_For_Job_No_16617_27-11-2023_1522.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('e83c1596-f915-4d71-93b9-eaeba48a6e63', '355128d6-4439-41b8-8979-640037f68e02', 'uncategorised', 'Asset_Record_For_Job_No_16808_28-11-2023_1340.pdf', 'uncategorised/Asset_Record_For_Job_No_16808_28-11-2023_1340.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('e51f648e-36fe-4200-bc61-9828272b837c', '355128d6-4439-41b8-8979-640037f68e02', 'uncategorised', 'EX-NC (CONNAUGHT SQUARE) EXTRA 01102024.pdf', 'uncategorised/EX-NC (CONNAUGHT SQUARE) EXTRA 01102024.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('31d8124b-a1d0-4933-bf18-92f0dc8f7865', '355128d6-4439-41b8-8979-640037f68e02', 'uncategorised', 'H&S recomendations - Spreadsheet with comments.xlsx', 'uncategorised/H&S recomendations - Spreadsheet with comments.xlsx');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('3a386d23-84d3-4029-8e53-efe919bf4bbc', '355128d6-4439-41b8-8979-640037f68e02', 'uncategorised', 'CM434 RS 32-34 Connaught Square - VISIT 1 OF 2 - 30-04-25.pdf', 'uncategorised/CM434 RS 32-34 Connaught Square - VISIT 1 OF 2 - 30-04-25.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('08b0f4b0-ba50-4d20-940a-f985e3f211cb', '355128d6-4439-41b8-8979-640037f68e02', 'uncategorised', 'Q49511 - 32-34 Connaught Square.pdf', 'uncategorised/Q49511 - 32-34 Connaught Square.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('7e94d68f-d0c0-4a54-bff4-f792ac2f0696', '355128d6-4439-41b8-8979-640037f68e02', 'uncategorised', 'FA7817 CALL OUT 26032025.pdf', 'uncategorised/FA7817 CALL OUT 26032025.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('7aa6c9b5-909d-421e-9001-c39ea5120af1', '355128d6-4439-41b8-8979-640037f68e02', 'uncategorised', '32 Connaught Sq - PAT .pdf', 'uncategorised/32 Connaught Sq - PAT .pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('de4d9026-1657-4ae9-a785-22d3a11d75ce', '355128d6-4439-41b8-8979-640037f68e02', 'uncategorised', 'Asset_Record_For_Job_No_35146_03-06-2025_0906.pdf', 'uncategorised/Asset_Record_For_Job_No_35146_03-06-2025_0906.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('65dd7629-251b-45b8-893e-0fbf23601f64', '355128d6-4439-41b8-8979-640037f68e02', 'uncategorised', 'Asset_Record_For_Job_No_31162_30-01-2025_1603.pdf', 'uncategorised/Asset_Record_For_Job_No_31162_30-01-2025_1603.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('f1f3972e-5499-41e4-bc86-1f4972743f45', '355128d6-4439-41b8-8979-640037f68e02', 'uncategorised', 'Asset_Record_For_Job_No_37675_25-07-2025_1549.pdf', 'uncategorised/Asset_Record_For_Job_No_37675_25-07-2025_1549.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('01c9b7eb-bfb3-4ded-918b-33c68939b274', '355128d6-4439-41b8-8979-640037f68e02', 'uncategorised', 'Asset_Record_For_Job_No_28737_25-11-2024_0907.pdf', 'uncategorised/Asset_Record_For_Job_No_28737_25-11-2024_0907.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('b322bf73-f598-4fb7-b04c-fa5c171cca69', '355128d6-4439-41b8-8979-640037f68e02', 'uncategorised', 'Asset_Record_For_Job_No_35402_03-06-2025_0916.pdf', 'uncategorised/Asset_Record_For_Job_No_35402_03-06-2025_0916.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('eafbdf6e-d576-46f7-b3d1-73789a0da6b7', '355128d6-4439-41b8-8979-640037f68e02', 'uncategorised', 'Asset_Record_For_Job_No_22171_14-05-2024_1202.pdf', 'uncategorised/Asset_Record_For_Job_No_22171_14-05-2024_1202.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('eb79a1d9-a5de-4855-a7da-f58a231a59df', '355128d6-4439-41b8-8979-640037f68e02', 'uncategorised', 'Asset_Record_For_Job_No_35654_03-06-2025_0912.pdf', 'uncategorised/Asset_Record_For_Job_No_35654_03-06-2025_0912.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('3119e359-368e-496a-8700-596cbb1eed66', '355128d6-4439-41b8-8979-640037f68e02', 'uncategorised', 'Asset_Record_For_Job_No_38609_26-08-2025_0740.pdf', 'uncategorised/Asset_Record_For_Job_No_38609_26-08-2025_0740.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('c62fe5f8-5e3a-4928-a460-cdc66a65e2d6', '355128d6-4439-41b8-8979-640037f68e02', 'uncategorised', 'Asset_Record_For_Job_No_36465_20-06-2025_1038.pdf', 'uncategorised/Asset_Record_For_Job_No_36465_20-06-2025_1038.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('1c037124-5a06-4a89-b7b7-b3f0ef75c50a', '355128d6-4439-41b8-8979-640037f68e02', 'uncategorised', '26368 Report.pdf', 'uncategorised/26368 Report.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('eb054d4e-7b8a-4061-ab81-93fc723bcc49', '355128d6-4439-41b8-8979-640037f68e02', 'uncategorised', '26474 Report.pdf', 'uncategorised/26474 Report.pdf');

-- Insert 26 apportionments
INSERT INTO apportionments (id, building_id, percentage) VALUES ('e400cadd-6b53-44bf-93b8-4fb98580680c', '355128d6-4439-41b8-8979-640037f68e02', 32.0);
INSERT INTO apportionments (id, building_id, percentage) VALUES ('8e7df089-5dd8-422f-87fc-b0bec869c5a1', '355128d6-4439-41b8-8979-640037f68e02', 10.0);
INSERT INTO apportionments (id, building_id, percentage) VALUES ('a8938c67-fc21-4ea2-8a6c-4a95ab9e24fb', '355128d6-4439-41b8-8979-640037f68e02', 32.0);
INSERT INTO apportionments (id, building_id, percentage) VALUES ('a4837cb7-589d-4bcc-80cd-2fcf3fe6aa1f', '355128d6-4439-41b8-8979-640037f68e02', 19.0);
INSERT INTO apportionments (id, building_id, percentage) VALUES ('893d5cfa-00c3-4e69-a5f6-61ca3afd1b36', '355128d6-4439-41b8-8979-640037f68e02', 2.0);
INSERT INTO apportionments (id, building_id, percentage) VALUES ('913adc83-df73-4889-ab50-a3acec0cd8a1', '355128d6-4439-41b8-8979-640037f68e02', 2.0);
INSERT INTO apportionments (id, building_id, percentage) VALUES ('b3ca179c-9dc5-470c-8e6a-9b219693af98', '355128d6-4439-41b8-8979-640037f68e02', 2.0);
INSERT INTO apportionments (id, building_id, percentage) VALUES ('d2651958-7e1d-48e5-a8ac-352337bfe7cf', '355128d6-4439-41b8-8979-640037f68e02', 2.0);
INSERT INTO apportionments (id, building_id, percentage) VALUES ('7fa3aba0-90ca-4d29-a1f7-318a8a27f79c', '355128d6-4439-41b8-8979-640037f68e02', 2.0);
INSERT INTO apportionments (id, building_id, percentage) VALUES ('de82ee18-3e19-44e2-ba4d-149505355463', '355128d6-4439-41b8-8979-640037f68e02', 8.0);
INSERT INTO apportionments (id, building_id, percentage) VALUES ('eeb59796-4b17-4d4c-9e49-a0e4917eee46', '355128d6-4439-41b8-8979-640037f68e02', 3.0);
INSERT INTO apportionments (id, building_id, percentage) VALUES ('a253375e-1e05-461b-b0de-9ad723d88ebd', '355128d6-4439-41b8-8979-640037f68e02', 3.0);
INSERT INTO apportionments (id, building_id, percentage) VALUES ('d8489d97-f67c-446f-be2a-352c2b4e185e', '355128d6-4439-41b8-8979-640037f68e02', 3.0);
INSERT INTO apportionments (id, building_id, percentage) VALUES ('6ee43385-db59-4184-9e78-d9787319b96a', '355128d6-4439-41b8-8979-640037f68e02', 3.0);
INSERT INTO apportionments (id, building_id, percentage) VALUES ('13c4a990-cc9a-4d65-8a16-f9206ea6a684', '355128d6-4439-41b8-8979-640037f68e02', 3.0);
INSERT INTO apportionments (id, building_id, percentage) VALUES ('75aa0cce-f7ba-47db-ba48-e6d11be96963', '355128d6-4439-41b8-8979-640037f68e02', 3.0);
INSERT INTO apportionments (id, building_id, percentage) VALUES ('7c1daf0c-d4aa-4f2d-8c48-325506362127', '355128d6-4439-41b8-8979-640037f68e02', 3.0);
INSERT INTO apportionments (id, building_id, percentage) VALUES ('2d32fff8-e3a5-47c4-b9cb-9b9e317cbf70', '355128d6-4439-41b8-8979-640037f68e02', 3.0);
INSERT INTO apportionments (id, building_id, percentage) VALUES ('5c13e998-68e4-45ab-ad75-c1b00dd4684e', '355128d6-4439-41b8-8979-640037f68e02', 8.0);
INSERT INTO apportionments (id, building_id, percentage) VALUES ('bffc084c-da65-42cf-bec6-ae55ecfbc684', '355128d6-4439-41b8-8979-640037f68e02', 3.0);
INSERT INTO apportionments (id, building_id, percentage) VALUES ('5d8dab4f-6a12-4d28-affa-d1d0446c89a4', '355128d6-4439-41b8-8979-640037f68e02', 8.0);
INSERT INTO apportionments (id, building_id, percentage) VALUES ('ccc4927c-54a7-466d-ab90-3aab9c6bd254', '355128d6-4439-41b8-8979-640037f68e02', 8.0);
INSERT INTO apportionments (id, building_id, percentage) VALUES ('cf090f32-39a9-498b-9962-217e0ba7d177', '355128d6-4439-41b8-8979-640037f68e02', 8.0);
INSERT INTO apportionments (id, building_id, percentage) VALUES ('6f30a993-d94b-4d94-8146-ee5b4eebd9a6', '355128d6-4439-41b8-8979-640037f68e02', 8.0);
INSERT INTO apportionments (id, building_id, percentage) VALUES ('3ea713ba-6323-40ab-9fcd-3bd3efed6f1e', '355128d6-4439-41b8-8979-640037f68e02', 8.0);
INSERT INTO apportionments (id, building_id, percentage) VALUES ('5db3a3f3-b910-440e-92e4-a6125b1ae2ce', '355128d6-4439-41b8-8979-640037f68e02', 8.0);

-- Insert 131 insurance records
INSERT INTO building_insurance (id, building_id, policy_number, insurance_type) VALUES ('55c7d1f7-d471-49cd-b3aa-21ac87bb4dcb', '355128d6-4439-41b8-8979-640037f68e02', 'CGBI3964546XB', 'general');
INSERT INTO building_insurance (id, building_id, policy_number, insurance_type) VALUES ('be0f871a-2ea7-429e-a07a-4a23008623d5', '355128d6-4439-41b8-8979-640037f68e02', 'CGBI3964546XB', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('8e7fe653-b502-42e5-90fb-4784563b8df2', '355128d6-4439-41b8-8979-640037f68e02', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('72187eac-95f0-42b4-8c2f-1ac0a1c1aef8', '355128d6-4439-41b8-8979-640037f68e02', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('a2560d56-f976-4ac6-8837-5bb231431740', '355128d6-4439-41b8-8979-640037f68e02', 'general');
INSERT INTO building_insurance (id, building_id, policy_number, insurance_type) VALUES ('23ef5867-ff17-4a8e-ae7d-8fcd009d1cba', '355128d6-4439-41b8-8979-640037f68e02', 'and', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('dc6a3eea-50f8-4ff7-be41-9fa430193ff5', '355128d6-4439-41b8-8979-640037f68e02', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('69f69a3c-4413-47ab-bed8-a1a8330df037', '355128d6-4439-41b8-8979-640037f68e02', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('3cbc289c-7b08-4462-92bf-4c285c89d21c', '355128d6-4439-41b8-8979-640037f68e02', 'general');
INSERT INTO building_insurance (id, building_id, policy_number, insurance_type) VALUES ('48e28a14-2306-441d-a517-9529fdfcb2d1', '355128d6-4439-41b8-8979-640037f68e02', 'NZ23346712', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('278341e2-05f5-46b5-8ba0-2fc610012801', '355128d6-4439-41b8-8979-640037f68e02', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('96dd158f-d94e-4fbc-b095-d36b0579b66f', '355128d6-4439-41b8-8979-640037f68e02', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('11b340ee-0da7-4eea-9c12-30d40ca21a24', '355128d6-4439-41b8-8979-640037f68e02', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('04baf2b6-09bb-4cfe-8a7d-58ef003d6eab', '355128d6-4439-41b8-8979-640037f68e02', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('26641bfc-a1a3-481b-a9a6-18fe8d8dca30', '355128d6-4439-41b8-8979-640037f68e02', 'general');
INSERT INTO building_insurance (id, building_id, policy_number, insurance_type) VALUES ('4bde6a65-8fbd-428f-a808-6d431816fcf3', '355128d6-4439-41b8-8979-640037f68e02', 'ARCH', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('6d468e3d-21d0-4713-bd8a-1179423496ae', '355128d6-4439-41b8-8979-640037f68e02', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('a695dcbd-e841-45b2-959a-89d572411b5a', '355128d6-4439-41b8-8979-640037f68e02', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('8ea1afda-b387-4954-b8f9-ae0b2da88dee', '355128d6-4439-41b8-8979-640037f68e02', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('ed9e0c71-4f5f-42ce-8711-e4dbeb99278e', '355128d6-4439-41b8-8979-640037f68e02', 'general');
INSERT INTO building_insurance (id, building_id, policy_number, insurance_type) VALUES ('46060f5c-a6bf-4e08-b85f-ffc298cac358', '355128d6-4439-41b8-8979-640037f68e02', 'FU117816', 'general');
INSERT INTO building_insurance (id, building_id, policy_number, insurance_type) VALUES ('01548344-483c-48ab-8558-4116d5051869', '355128d6-4439-41b8-8979-640037f68e02', 'FU117816', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('d4365668-e8dd-422b-9777-730f6f66ac28', '355128d6-4439-41b8-8979-640037f68e02', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('9c711a4e-c269-4709-88c8-1b041c468dbb', '355128d6-4439-41b8-8979-640037f68e02', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('d2bb2108-6909-4ea1-81af-8231fb06facb', '355128d6-4439-41b8-8979-640037f68e02', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('21ea084b-e97c-4f74-9af8-3bccfafbde36', '355128d6-4439-41b8-8979-640037f68e02', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('da3f2d31-e18b-460a-9cd3-656533f2fed5', '355128d6-4439-41b8-8979-640037f68e02', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('7f1458ff-00cd-41e0-a203-6d96440d978b', '355128d6-4439-41b8-8979-640037f68e02', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('ccbdae03-5a27-4b9f-82db-5e51f62550a8', '355128d6-4439-41b8-8979-640037f68e02', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('47216e2e-9ce0-4d77-99c3-88980971fd93', '355128d6-4439-41b8-8979-640037f68e02', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('0fdc1a04-a094-4220-9591-ec74713967d0', '355128d6-4439-41b8-8979-640037f68e02', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('1e8842a7-0343-4bbf-951e-896e2cd0a2aa', '355128d6-4439-41b8-8979-640037f68e02', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('051bd1ed-6593-4115-b53b-ca41e4e02379', '355128d6-4439-41b8-8979-640037f68e02', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('e59a0b94-372d-42d6-b05d-658fbdeb953f', '355128d6-4439-41b8-8979-640037f68e02', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('e4317900-8031-430a-8d00-145b0693de58', '355128d6-4439-41b8-8979-640037f68e02', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('ebfee51d-9c50-4f29-9eed-e173614e9e1a', '355128d6-4439-41b8-8979-640037f68e02', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('0c37ab36-3863-4ea8-b9da-753c13061cfd', '355128d6-4439-41b8-8979-640037f68e02', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('d4982b56-bc5b-4c05-8034-38ecc52fca0b', '355128d6-4439-41b8-8979-640037f68e02', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('5036a312-34b4-44fb-a510-ee6976ba0535', '355128d6-4439-41b8-8979-640037f68e02', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('bd82a2d1-ad81-4b60-abf8-66bdba159baf', '355128d6-4439-41b8-8979-640037f68e02', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('ee00c622-9e3f-432e-8973-44e78d96f50c', '355128d6-4439-41b8-8979-640037f68e02', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('9ad32677-3349-47e0-940d-cf4ca77ab21a', '355128d6-4439-41b8-8979-640037f68e02', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('36d3157f-0fc3-413d-ba35-eb59d6cb2f8f', '355128d6-4439-41b8-8979-640037f68e02', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('ebecc406-75ed-4913-afd1-5321a0fd30f1', '355128d6-4439-41b8-8979-640037f68e02', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('174698db-8405-4ea0-acdc-ef309e07900e', '355128d6-4439-41b8-8979-640037f68e02', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('44bfb869-ea0e-49cc-aa16-1c0c8e2d3df0', '355128d6-4439-41b8-8979-640037f68e02', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('6386b05f-4458-44c8-bf30-74a960952c7b', '355128d6-4439-41b8-8979-640037f68e02', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('7a50766b-3596-4fcf-af17-888f53552c1f', '355128d6-4439-41b8-8979-640037f68e02', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('d13a9913-aba7-446e-8949-014f8bb4dcc1', '355128d6-4439-41b8-8979-640037f68e02', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('8a4f3645-6733-485e-9e93-3b563313442c', '355128d6-4439-41b8-8979-640037f68e02', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('e2260e0d-5fed-427d-a0c5-83e2e54673d0', '355128d6-4439-41b8-8979-640037f68e02', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('2021d853-1438-4424-87c4-b175291e88c2', '355128d6-4439-41b8-8979-640037f68e02', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('15679e83-9d69-4f74-b5a3-8b4479501bb3', '355128d6-4439-41b8-8979-640037f68e02', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('62ccbcc6-31f1-48cf-8765-e9345531d697', '355128d6-4439-41b8-8979-640037f68e02', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('9de57f77-8af7-4bc0-9043-86d849d8d5da', '355128d6-4439-41b8-8979-640037f68e02', 'general');
INSERT INTO building_insurance (id, building_id, policy_number, insurance_type) VALUES ('38b80c66-9b2e-428a-b32d-aa8165049b9c', '355128d6-4439-41b8-8979-640037f68e02', 'LXBI3559280XB', 'general');
INSERT INTO building_insurance (id, building_id, policy_number, insurance_type) VALUES ('5e0bc190-e116-457f-b50f-4f93ea1e0365', '355128d6-4439-41b8-8979-640037f68e02', 'LXBI3559280XB', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('8db962da-81d9-4dd9-95a0-bcfb0279503b', '355128d6-4439-41b8-8979-640037f68e02', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('408f1078-cc18-41ff-8095-72e6a82cfa6a', '355128d6-4439-41b8-8979-640037f68e02', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('70449d1c-45f9-42f2-8c99-ea4eaeaf480c', '355128d6-4439-41b8-8979-640037f68e02', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('df4d977c-bbb2-4e2f-bf5e-6175768ce86f', '355128d6-4439-41b8-8979-640037f68e02', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('b7cc8d2f-751b-45be-9b49-7e6cde79c08b', '355128d6-4439-41b8-8979-640037f68e02', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('22ed2845-17d1-4810-9970-468f43b41656', '355128d6-4439-41b8-8979-640037f68e02', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('a64b0c63-719a-4fa0-ae2a-f202abc476c0', '355128d6-4439-41b8-8979-640037f68e02', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('62c965ea-bee9-4f26-bf2a-9b3e2a41639d', '355128d6-4439-41b8-8979-640037f68e02', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('ca01391b-0e97-4dde-b7d8-101c15efdbaf', '355128d6-4439-41b8-8979-640037f68e02', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('2f4c94bf-8fd3-4f11-9f6f-8e1081b90306', '355128d6-4439-41b8-8979-640037f68e02', 'general');
INSERT INTO building_insurance (id, building_id, policy_number, insurance_type) VALUES ('003aefda-14a9-44d2-8084-9802a78d8939', '355128d6-4439-41b8-8979-640037f68e02', 'NZ23346712', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('2412a930-8fa4-434f-a7a3-1a686472e12c', '355128d6-4439-41b8-8979-640037f68e02', 'general');
INSERT INTO building_insurance (id, building_id, policy_number, insurance_type) VALUES ('aecb2339-e933-4891-b530-c85cb0eaa6cb', '355128d6-4439-41b8-8979-640037f68e02', 'and', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('2ffa757b-8821-447a-b75c-1371c3ecc9ca', '355128d6-4439-41b8-8979-640037f68e02', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('6541e634-d864-421b-8521-f0ef25be1958', '355128d6-4439-41b8-8979-640037f68e02', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('8c13a5cb-24ab-493b-ad48-c865ad05e17f', '355128d6-4439-41b8-8979-640037f68e02', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('b3062e4e-7707-4313-8c2d-ddf0e6541b99', '355128d6-4439-41b8-8979-640037f68e02', 'general');
INSERT INTO building_insurance (id, building_id, policy_number, insurance_type) VALUES ('7e45bd69-a35c-4f8d-b87a-726e3776a4c1', '355128d6-4439-41b8-8979-640037f68e02', 'STGLON', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('9ca8c15c-963d-4c1e-915d-742421c67052', '355128d6-4439-41b8-8979-640037f68e02', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('94dca686-c87f-4e62-8f8b-5e991b029077', '355128d6-4439-41b8-8979-640037f68e02', 'general');
INSERT INTO building_insurance (id, building_id, policy_number, insurance_type) VALUES ('a04fd71d-97c8-4dfc-abed-946bb5c759b0', '355128d6-4439-41b8-8979-640037f68e02', 'STGLON', 'general');
INSERT INTO building_insurance (id, building_id, policy_number, insurance_type) VALUES ('68d6e197-abc7-4ab9-a1c8-4390111c09ae', '355128d6-4439-41b8-8979-640037f68e02', 'STGLON', 'general');
INSERT INTO building_insurance (id, building_id, policy_number, insurance_type) VALUES ('e2646948-e431-413d-9eb2-de2d458d162b', '355128d6-4439-41b8-8979-640037f68e02', 'BERTSTGLON', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('0e9d3754-4852-4310-babd-a87a4ad64f37', '355128d6-4439-41b8-8979-640037f68e02', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('870fa383-1daa-4cf5-b385-ee53d8d60351', '355128d6-4439-41b8-8979-640037f68e02', 'general');
INSERT INTO building_insurance (id, building_id, policy_number, insurance_type) VALUES ('f0575517-ba44-4a15-bc06-40c58fbad6e2', '355128d6-4439-41b8-8979-640037f68e02', 'LP', 'general');
INSERT INTO building_insurance (id, building_id, policy_number, insurance_type) VALUES ('e4719603-b286-49e6-b07f-8cb6c19c585e', '355128d6-4439-41b8-8979-640037f68e02', 'HL', 'general');
INSERT INTO building_insurance (id, building_id, policy_number, insurance_type) VALUES ('e416e5a4-9699-4664-872b-941bfea614f8', '355128d6-4439-41b8-8979-640037f68e02', 'ARCH', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('f1b04658-82a7-4381-91da-458386887880', '355128d6-4439-41b8-8979-640037f68e02', 'general');
INSERT INTO building_insurance (id, building_id, policy_number, insurance_type) VALUES ('8d6a7417-fcba-4132-954c-2eb68d590f77', '355128d6-4439-41b8-8979-640037f68e02', 'and', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('b361446b-7ef4-4e42-9de0-ac26f4fb15d8', '355128d6-4439-41b8-8979-640037f68e02', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('719433d9-121f-422a-801d-845f26613018', '355128d6-4439-41b8-8979-640037f68e02', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('1bfe0e11-d677-4f30-af91-20bc4f02ae30', '355128d6-4439-41b8-8979-640037f68e02', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('308f510a-3dc9-4fbf-9672-ff21e928a268', '355128d6-4439-41b8-8979-640037f68e02', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('7b7564ef-bca5-4be4-b989-291448fe8a0f', '355128d6-4439-41b8-8979-640037f68e02', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('07f80a58-e811-4f03-bcf1-2982db6c64c4', '355128d6-4439-41b8-8979-640037f68e02', 'general');
INSERT INTO building_insurance (id, building_id, policy_number, insurance_type) VALUES ('a1b7031d-ac22-4472-98ff-d42c33b42e24', '355128d6-4439-41b8-8979-640037f68e02', 'and', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('0aa9115d-eec7-4ce2-9b13-1abacff77846', '355128d6-4439-41b8-8979-640037f68e02', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('539f7e70-327c-4868-9bec-2d2e3340ac7e', '355128d6-4439-41b8-8979-640037f68e02', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('83006b39-38df-4bcf-b8e3-99d955beba15', '355128d6-4439-41b8-8979-640037f68e02', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('5f6284c3-ce7a-411c-be72-3aed5bedc4b6', '355128d6-4439-41b8-8979-640037f68e02', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('afc9926c-b0e9-4f41-bf7d-a135f4d607ff', '355128d6-4439-41b8-8979-640037f68e02', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('75659fc8-1c28-465e-b9c5-eaad4e401062', '355128d6-4439-41b8-8979-640037f68e02', 'general');
INSERT INTO building_insurance (id, building_id, policy_number, insurance_type) VALUES ('113f6b09-3616-40f6-8263-bfe885356e63', '355128d6-4439-41b8-8979-640037f68e02', 'and', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('65bd4e05-7c92-47a6-a867-e8e8978558cd', '355128d6-4439-41b8-8979-640037f68e02', 'general');
INSERT INTO building_insurance (id, building_id, policy_number, insurance_type) VALUES ('8db2e7c9-d35d-4fc3-beeb-e358f75781f0', '355128d6-4439-41b8-8979-640037f68e02', 'BP13228-2501', 'general');
INSERT INTO building_insurance (id, building_id, policy_number, insurance_type) VALUES ('93fd2e9f-ecb8-4f3b-bb6b-6ce4df9962ca', '355128d6-4439-41b8-8979-640037f68e02', 'BP13228-2501', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('b52e37dd-5ea6-4f22-8df6-3e48bed07055', '355128d6-4439-41b8-8979-640037f68e02', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('4c95eeef-6a17-4ab9-98fa-6cdce6996ebc', '355128d6-4439-41b8-8979-640037f68e02', 'general');
INSERT INTO building_insurance (id, building_id, policy_number, insurance_type) VALUES ('c18ad628-b9f0-4adb-8017-e4d0c492ac2b', '355128d6-4439-41b8-8979-640037f68e02', 'TA0604600', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('da8a27e7-5c42-448b-87d7-51248b20aeee', '355128d6-4439-41b8-8979-640037f68e02', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('76657419-e441-42c8-bf57-05892ec1f07c', '355128d6-4439-41b8-8979-640037f68e02', 'general');
INSERT INTO building_insurance (id, building_id, policy_number, insurance_type) VALUES ('08c2c955-d310-41e6-8c1f-ff9d70e46e05', '355128d6-4439-41b8-8979-640037f68e02', 'HL', 'general');
INSERT INTO building_insurance (id, building_id, policy_number, insurance_type) VALUES ('890fb546-c098-4ece-911d-d96738e46d83', '355128d6-4439-41b8-8979-640037f68e02', 'Camberford', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('d086dca8-8300-438c-9946-36653669b7fc', '355128d6-4439-41b8-8979-640037f68e02', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('19c10988-ad2b-440c-beb6-a7f51ef8c913', '355128d6-4439-41b8-8979-640037f68e02', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('979d8a8f-98c3-4b2e-8beb-02126a303de5', '355128d6-4439-41b8-8979-640037f68e02', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('e58117a8-7edd-4702-8f58-74860a3c59d0', '355128d6-4439-41b8-8979-640037f68e02', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('ba4e7952-7b82-43e4-825e-147cdf934adf', '355128d6-4439-41b8-8979-640037f68e02', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('ba8f1d46-9303-4d66-a1c2-b90ae815302c', '355128d6-4439-41b8-8979-640037f68e02', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('d62ba775-f194-4e67-aebe-3eb2d05852d9', '355128d6-4439-41b8-8979-640037f68e02', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('73803df0-84d2-4337-a6bb-e5b3a8d75b57', '355128d6-4439-41b8-8979-640037f68e02', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('90f756eb-743a-42bf-9813-9bbf43639c68', '355128d6-4439-41b8-8979-640037f68e02', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('d530b7e7-8b64-4e1d-a41f-d0a6d1b96322', '355128d6-4439-41b8-8979-640037f68e02', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('207463a3-f5c6-45aa-ac1f-86b1af755af6', '355128d6-4439-41b8-8979-640037f68e02', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('a36adbc4-49e6-46e1-8831-e9247183f4a2', '355128d6-4439-41b8-8979-640037f68e02', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('8ba6fc76-83eb-4001-99b6-1703fb826308', '355128d6-4439-41b8-8979-640037f68e02', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('4dda0e46-73ba-4aa6-8875-d4716643e582', '355128d6-4439-41b8-8979-640037f68e02', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('06c33c8a-5936-4d36-9509-87741ac942d8', '355128d6-4439-41b8-8979-640037f68e02', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('0c86bb7b-b511-4b16-aa48-048e5944b265', '355128d6-4439-41b8-8979-640037f68e02', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('637cfe13-e929-4f7b-96f8-61619bdb620c', '355128d6-4439-41b8-8979-640037f68e02', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('630d5637-b1f8-4a96-ba71-81e790fd5fd8', '355128d6-4439-41b8-8979-640037f68e02', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('c8d0efca-52ab-412d-a9b6-e5cc3f5ad72b', '355128d6-4439-41b8-8979-640037f68e02', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('1b029155-3e7e-483d-b519-5a3df6672a1e', '355128d6-4439-41b8-8979-640037f68e02', 'general');

-- ===========================
-- CONTRACTORS
-- ===========================

INSERT INTO contractors (id, name, phone, address) VALUES
('c403e7f3-0998-4ddc-8549-5cf159e63d37', 'ISS', '083603538855', 'London, We''re available on Live Chat here., W1S 1RS')
ON CONFLICT (id) DO NOTHING;

INSERT INTO contractors (id, name, email, phone, address) VALUES
('0433c62b-963b-455d-937c-683f0b83203c', 'Quotehedge', 'info@quotehedge-heating.co.uk', '07801 799118', '182 Revelstoke Road, Wandsworth, London, SW18 5NW')
ON CONFLICT (id) DO NOTHING;

INSERT INTO contractors (id, name, email, address) VALUES
('9423d88d-3d36-4020-bcd8-8fdc13be53e3', 'WHM', 'enquiries@whmltd.org', 'WATER HYGIENE MANAGEMENT L TD, 2 Churchill Court, Hortons Way,, Westerham, Kent, TN16 1BT')
ON CONFLICT (id) DO NOTHING;

INSERT INTO contractors (id, name, email, address) VALUES
('c5760267-eb5b-4e7f-97d3-78f5c77b0701', 'Capita', 'DPO@archinsurance.co.uk', 'f Arch Insurance (UK) Limited, Arch Insurance (UK) Limited, 5th Floor, 60 Great Tower Street, London EC3R 5AZ')
ON CONFLICT (id) DO NOTHING;


-- ===========================
-- BUILDING_CONTRACTORS
-- ===========================

INSERT INTO building_contractors (id, building_id, contractor_type)
VALUES ('7db1750a-b954-4f76-8d3c-39d5ff10d2e4', '355128d6-4439-41b8-8979-640037f68e02', 'service_provider')
ON CONFLICT (id) DO NOTHING;

INSERT INTO building_contractors (id, building_id, contractor_type)
VALUES ('3e6da2e6-c8c5-432f-a0e8-f9bc2b664a66', '355128d6-4439-41b8-8979-640037f68e02', 'service_provider')
ON CONFLICT (id) DO NOTHING;

INSERT INTO building_contractors (id, building_id, contractor_type)
VALUES ('299e039a-7225-4d3a-a3e0-6f471c05d98b', '355128d6-4439-41b8-8979-640037f68e02', 'service_provider')
ON CONFLICT (id) DO NOTHING;

INSERT INTO building_contractors (id, building_id, contractor_type)
VALUES ('07d1f511-35b2-4924-97e3-3744307e7b21', '355128d6-4439-41b8-8979-640037f68e02', 'service_provider')
ON CONFLICT (id) DO NOTHING;

INSERT INTO building_contractors (id, building_id, contractor_type)
VALUES ('572019d1-950d-4e58-b101-731745a9b8a3', '355128d6-4439-41b8-8979-640037f68e02', 'service_provider')
ON CONFLICT (id) DO NOTHING;

INSERT INTO building_contractors (id, building_id, contractor_type)
VALUES ('28ccf0a6-c0b3-4cbb-ab3c-c8a6ae8bb3ed', '355128d6-4439-41b8-8979-640037f68e02', 'service_provider')
ON CONFLICT (id) DO NOTHING;

INSERT INTO building_contractors (id, building_id, contractor_type)
VALUES ('4e202d69-f335-4e32-97df-2663b9fb490a', '355128d6-4439-41b8-8979-640037f68e02', 'service_provider')
ON CONFLICT (id) DO NOTHING;

INSERT INTO building_contractors (id, building_id, contractor_type)
VALUES ('71d4eeb1-a423-4e41-9044-eb489bd0f21a', '355128d6-4439-41b8-8979-640037f68e02', 'service_provider')
ON CONFLICT (id) DO NOTHING;

INSERT INTO building_contractors (id, building_id, contractor_type)
VALUES ('5796712f-ff03-4faa-85df-e2d27c296ccf', '355128d6-4439-41b8-8979-640037f68e02', 'service_provider')
ON CONFLICT (id) DO NOTHING;

INSERT INTO building_contractors (id, building_id, contractor_type)
VALUES ('7282afb0-1a7d-4473-a376-33cc7cf27333', '355128d6-4439-41b8-8979-640037f68e02', 'service_provider')
ON CONFLICT (id) DO NOTHING;

INSERT INTO building_contractors (id, building_id, contractor_type)
VALUES ('303cfc66-2287-48de-8910-0b8d0ec32f6e', '355128d6-4439-41b8-8979-640037f68e02', 'service_provider')
ON CONFLICT (id) DO NOTHING;

INSERT INTO building_contractors (id, building_id, contractor_type)
VALUES ('213cfb6d-5a60-4f33-a74b-96ec42ed60e5', '355128d6-4439-41b8-8979-640037f68e02', 'service_provider')
ON CONFLICT (id) DO NOTHING;

INSERT INTO building_contractors (id, building_id, contractor_type)
VALUES ('3db4cccf-3fa9-4a90-a95a-f641f70a07be', '355128d6-4439-41b8-8979-640037f68e02', 'service_provider')
ON CONFLICT (id) DO NOTHING;

INSERT INTO building_contractors (id, building_id, contractor_type)
VALUES ('3283c836-6c73-4e3a-a8f5-39fc1f877d8a', '355128d6-4439-41b8-8979-640037f68e02', 'service_provider')
ON CONFLICT (id) DO NOTHING;

INSERT INTO building_contractors (id, building_id, contractor_type)
VALUES ('4a3c8153-7ba2-439c-a14d-c88d8a5c7aab', '355128d6-4439-41b8-8979-640037f68e02', 'service_provider')
ON CONFLICT (id) DO NOTHING;

INSERT INTO building_contractors (id, building_id, contractor_type)
VALUES ('f06ea0bd-fdfe-4b0f-8b63-49b961eb069b', '355128d6-4439-41b8-8979-640037f68e02', 'service_provider')
ON CONFLICT (id) DO NOTHING;

INSERT INTO building_contractors (id, building_id, contractor_type)
VALUES ('32489040-da3c-4422-b94e-4536d9480e44', '355128d6-4439-41b8-8979-640037f68e02', 'service_provider')
ON CONFLICT (id) DO NOTHING;

INSERT INTO building_contractors (id, building_id, contractor_type)
VALUES ('d113f22c-4060-4893-afc7-d15edc5ee124', '355128d6-4439-41b8-8979-640037f68e02', 'service_provider')
ON CONFLICT (id) DO NOTHING;

INSERT INTO building_contractors (id, building_id, contractor_type)
VALUES ('d21afed3-7dff-4fed-a236-2683f21ef4e9', '355128d6-4439-41b8-8979-640037f68e02', 'service_provider')
ON CONFLICT (id) DO NOTHING;

INSERT INTO building_contractors (id, building_id, contractor_type)
VALUES ('e518ebe8-a19e-426b-a259-5b94299651d6', '355128d6-4439-41b8-8979-640037f68e02', 'service_provider')
ON CONFLICT (id) DO NOTHING;

INSERT INTO building_contractors (id, building_id, contractor_type)
VALUES ('be004be3-4ede-4bc1-b69e-c97a1035541f', '355128d6-4439-41b8-8979-640037f68e02', 'service_provider')
ON CONFLICT (id) DO NOTHING;


-- Insert 214 assets
INSERT INTO assets (id, building_id, asset_type, asset_name, location_description, compliance_category, linked_documents) VALUES ('f5b4bb39-d60f-4622-a27b-a2c903ef11fd', '355128d6-4439-41b8-8979-640037f68e02', 'fire_alarm', 'Fire Alarm Works', 'Works-Following from latest leak', 'fire_safety', ARRAY['2024 Directors Meeting-Notes.docx']);
INSERT INTO assets (id, building_id, asset_type, asset_name, location_description, compliance_category, linked_documents) VALUES ('a0f7356a-dc82-4cdf-a1db-60deb7dffc08', '355128d6-4439-41b8-8979-640037f68e02', 'lift', 'Lift Works', 'Works-Following from latest leak', 'lifts_safety', ARRAY['2024 Directors Meeting-Notes.docx']);
INSERT INTO assets (id, building_id, asset_type, asset_name, location_description, model_number, compliance_category, linked_documents) VALUES ('6e3b1a54-e61d-4a37-9570-3bdfad898079', '355128d6-4439-41b8-8979-640037f68e02', 'boiler', 'Boiler Room', 'Basement', 'Fire', 'gas_safety', ARRAY['Fire Door (Communal) Inspection (11m +) (7).pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('73bd032a-2323-494e-97b0-922bec2236be', '355128d6-4439-41b8-8979-640037f68e02', 'fire_alarm', 'Fire Alarm A', 'fire_safety', ARRAY['EICR Cuanku 32-34 conaught square.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, location_description, compliance_category, linked_documents) VALUES ('40a24ab1-5ccc-4190-bdd3-f1c2f41e34c4', '355128d6-4439-41b8-8979-640037f68e02', 'lift', 'LIFT SHAFT', 'CONTROL CIRCUITS', 'lifts_safety', ARRAY['EICR Cuanku 32-34 conaught square.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, model_number, compliance_category, linked_documents) VALUES ('4d812cd2-d42e-484e-9ecb-b462c0467ddd', '355128d6-4439-41b8-8979-640037f68e02', 'lightning_protection', 'To lightning protection', 'B', 'electrical_safety', ARRAY['EICR Cuanku 32-34 conaught square.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('e5f9713f-ad21-4317-a42e-487d83c56df5', '355128d6-4439-41b8-8979-640037f68e02', 'generator', 'generators', 'electrical_safety', ARRAY['EICR Cuanku 32-34 conaught square.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, location_description, compliance_category, linked_documents) VALUES ('e0a446db-b625-46fe-a0a1-49dc9d68489c', '355128d6-4439-41b8-8979-640037f68e02', 'boiler', 'Boiler room', 'terrace - lift', 'gas_safety', ARRAY['221037_Fra1-L-394697-071223 32-34 Connaught Square_2024-01-02_163759 (1).pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, location_description, condition_rating, compliance_category, linked_documents) VALUES ('8eb7fca5-4461-4665-8a24-12c950564008', '355128d6-4439-41b8-8979-640037f68e02', 'fire_alarm', 'Fire Alarm', 'in appropriate X Breaches to compartmentation observed', 'good', 'fire_safety', ARRAY['221037_Fra1-L-394697-071223 32-34 Connaught Square_2024-01-02_163759 (1).pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, location_description, compliance_category, linked_documents) VALUES ('05192e0c-8e46-49a0-98a6-6bb5182082c8', '355128d6-4439-41b8-8979-640037f68e02', 'lift', 'lift
motor', 'terrace - lift', 'lifts_safety', ARRAY['221037_Fra1-L-394697-071223 32-34 Connaught Square_2024-01-02_163759 (1).pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, location_description, model_number, compliance_category, linked_documents) VALUES ('e03a935f-9f1b-4268-b8db-6a88fa371001', '355128d6-4439-41b8-8979-640037f68e02', 'door_entry', 'Intercom door entry', 'to 3rd floor', '1', 'security', ARRAY['221037_Fra1-L-394697-071223 32-34 Connaught Square_2024-01-02_163759 (1).pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('a70351a1-89e5-44ce-b564-07765ce22b92', '355128d6-4439-41b8-8979-640037f68e02', 'emergency_lighting', 'emergency lighting present', 'fire_safety', ARRAY['221037_Fra1-L-394697-071223 32-34 Connaught Square_2024-01-02_163759 (1).pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('8f5fcca6-5cdf-4af9-919f-e296291c0402', '355128d6-4439-41b8-8979-640037f68e02', 'fire_extinguisher', 'fire extinguishers', 'fire_safety', ARRAY['221037_Fra1-L-394697-071223 32-34 Connaught Square_2024-01-02_163759 (1).pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, condition_rating, compliance_category, linked_documents) VALUES ('958e9ae0-a7f5-4abe-bbe9-10f7f7084d8b', '355128d6-4439-41b8-8979-640037f68e02', 'lightning_protection', 'Lightning protection available', 'good', 'electrical_safety', ARRAY['221037_Fra1-L-394697-071223 32-34 Connaught Square_2024-01-02_163759 (1).pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, location_description, model_number, condition_rating, compliance_category, linked_documents) VALUES ('8f66aed4-72cc-427b-929d-58c4af176c66', '355128d6-4439-41b8-8979-640037f68e02', 'boiler', 'Boiler Hanworthy', 'Condensing Boiler Hanworthy Purewell variheat m k2 110 21 Mbar 110 0', 'pressure', 'fair', 'gas_safety', ARRAY['001132-3234-Connaught-Square-London.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, location_description, compliance_category, linked_documents) VALUES ('341cf490-be34-4297-9fb0-54d6d8f9fc7f', '355128d6-4439-41b8-8979-640037f68e02', 'boiler', 'Boiler room', 'terrace - lift', 'gas_safety', ARRAY['221038_Hsra1-L-394697-071223 32-34 Connaught Square_2024-01-02_163759 (1).pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('1b668b7e-f30b-4b44-87e2-7a0fbb1ccdec', '355128d6-4439-41b8-8979-640037f68e02', 'lift', 'LIFTS', 'lifts_safety', ARRAY['221038_Hsra1-L-394697-071223 32-34 Connaught Square_2024-01-02_163759 (1).pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('9cd0e7f5-bd7d-461a-8486-6e5393a55eb3', '355128d6-4439-41b8-8979-640037f68e02', 'cctv', 'CCTV equipment', 'security', ARRAY['221038_Hsra1-L-394697-071223 32-34 Connaught Square_2024-01-02_163759 (1).pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, location_description, compliance_category, linked_documents) VALUES ('01b3d78a-fcf9-4d73-95e1-471d88722335', '355128d6-4439-41b8-8979-640037f68e02', 'door_entry', 'Intercom door entry', 'to 3rd floor', 'security', ARRAY['221038_Hsra1-L-394697-071223 32-34 Connaught Square_2024-01-02_163759 (1).pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('5ae98e70-54a2-4e5b-bcd2-cd6626c01763', '355128d6-4439-41b8-8979-640037f68e02', 'emergency_lighting', 'Emergency lighting provided', 'fire_safety', ARRAY['221038_Hsra1-L-394697-071223 32-34 Connaught Square_2024-01-02_163759 (1).pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('81367efc-f350-499d-ae93-a78c977987d6', '355128d6-4439-41b8-8979-640037f68e02', 'water_tank', 'water storage tank', 'water_safety', ARRAY['221038_Hsra1-L-394697-071223 32-34 Connaught Square_2024-01-02_163759 (1).pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, location_description, compliance_category, linked_documents) VALUES ('b5f1f5c7-a814-497d-bd7e-9de2bca56104', '355128d6-4439-41b8-8979-640037f68e02', 'boiler', 'Boiler Room', 'exits', 'gas_safety', ARRAY['TETRA - Asbestos Re-Inspection Survey 14.06.22.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, location_description, compliance_category, linked_documents) VALUES ('9f71cb53-8c95-4cda-a240-f977f19f5515', '355128d6-4439-41b8-8979-640037f68e02', 'lift', 'Lift Motor', 'Description Assessment', 'lifts_safety', ARRAY['TETRA - Asbestos Re-Inspection Survey 14.06.22.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, location_description, compliance_category, linked_documents) VALUES ('e59a6132-ad19-4c3e-8ebb-fb6ad363f6a7', '355128d6-4439-41b8-8979-640037f68e02', 'pump', 'pumps', 'exits', 'water_safety', ARRAY['TETRA - Asbestos Re-Inspection Survey 14.06.22.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, model_number, compliance_category, linked_documents) VALUES ('706f0598-50eb-49dc-9536-4fbf1d59ec8b', '355128d6-4439-41b8-8979-640037f68e02', 'boiler', 'Boilers', 'Total', 'gas_safety', ARRAY['WHM Legionella Risk Assessment 07.06.22.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('3930c5b9-692f-42b0-967c-182b5e4f0e1a', '355128d6-4439-41b8-8979-640037f68e02', 'sprinkler', 'Sprinklers', 'fire_safety', ARRAY['WHM Legionella Risk Assessment 07.06.22.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('e7eb6214-661e-4782-ae4a-1eba18827c07', '355128d6-4439-41b8-8979-640037f68e02', 'pump', 'pump is', 'water_safety', ARRAY['WHM Legionella Risk Assessment 07.06.22.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, service_frequency, compliance_category, linked_documents) VALUES ('03af7e16-4e4c-4845-83a0-8cf5713e0fe9', '355128d6-4439-41b8-8979-640037f68e02', 'water_tank', 'water tanks', 'annually', 'water_safety', ARRAY['WHM Legionella Risk Assessment 07.06.22.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('ef24679c-4b0a-42cb-81ba-498c827da471', '355128d6-4439-41b8-8979-640037f68e02', 'fire_alarm', 'Fire Alarm A', 'fire_safety', ARRAY['EICR Report Cunaku SATISFACTORY 2023 .pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, location_description, compliance_category, linked_documents) VALUES ('9dd08f4c-0b36-4c3e-a4b4-d41d573f7d08', '355128d6-4439-41b8-8979-640037f68e02', 'lift', 'LIFT SHAFT', 'CONTROL CIRCUITS', 'lifts_safety', ARRAY['EICR Report Cunaku SATISFACTORY 2023 .pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, model_number, compliance_category, linked_documents) VALUES ('48b801de-5f40-47eb-8ed0-b5f97cf00552', '355128d6-4439-41b8-8979-640037f68e02', 'lightning_protection', 'To lightning protection', 'B', 'electrical_safety', ARRAY['EICR Report Cunaku SATISFACTORY 2023 .pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('f5d6c516-f3ac-464a-8c0c-073774a4e80a', '355128d6-4439-41b8-8979-640037f68e02', 'generator', 'generators', 'electrical_safety', ARRAY['EICR Report Cunaku SATISFACTORY 2023 .pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, location_description, compliance_category, linked_documents) VALUES ('d0315e54-ef9a-4a58-a4ee-fd17ffb6f9c0', '355128d6-4439-41b8-8979-640037f68e02', 'fire_alarm', 'Fire Alarm Works', 'Works-Following from latest leak', 'fire_safety', ARRAY['2024 Directors Meeting-Notes.docx']);
INSERT INTO assets (id, building_id, asset_type, asset_name, location_description, compliance_category, linked_documents) VALUES ('27f7f348-e272-43ea-a3f1-fa7156885f75', '355128d6-4439-41b8-8979-640037f68e02', 'lift', 'Lift Works', 'Works-Following from latest leak', 'lifts_safety', ARRAY['2024 Directors Meeting-Notes.docx']);
INSERT INTO assets (id, building_id, asset_type, asset_name, location_description, model_number, condition_rating, compliance_category, linked_documents) VALUES ('5555d1f0-3e7a-4ccf-b3bd-6790ef0c9abd', '355128d6-4439-41b8-8979-640037f68e02', 'boiler', 'Boiler Hanworthy', 'Condensing Boiler Hanworthy Wessex modumaxO mFk2 110c 20 Mbar 1', 'pressure', 'fair', 'gas_safety', ARRAY['001457-3234-Connaught-Square-London Certificate.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, location_description, manufacturer, compliance_category, linked_documents) VALUES ('5b8c9310-a5bb-4cbe-a744-b3e62097eb06', '355128d6-4439-41b8-8979-640037f68e02', 'lift', 'lift to', 'of Commission is', 'Crown to the Customer', 'lifts_safety', ARRAY['TC0001V31 General Terms and Conditions.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, model_number, compliance_category, linked_documents) VALUES ('8905c3ad-bfdc-48bc-b623-ea8a6f628e96', '355128d6-4439-41b8-8979-640037f68e02', 'boiler', 'Boilers', 'Total', 'gas_safety', ARRAY['Connaught Square (32-34) - 09.12.24 LRA.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('6495f61f-3e33-4bd1-99d7-72dd2e38e34b', '355128d6-4439-41b8-8979-640037f68e02', 'sprinkler', 'Sprinklers', 'fire_safety', ARRAY['Connaught Square (32-34) - 09.12.24 LRA.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('f02f63b8-aa13-46d2-9986-02178b3c386a', '355128d6-4439-41b8-8979-640037f68e02', 'pump', 'pump is', 'water_safety', ARRAY['Connaught Square (32-34) - 09.12.24 LRA.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, service_frequency, compliance_category, linked_documents) VALUES ('7679d9e7-dd9d-4a86-bfcf-66b8239cc28c', '355128d6-4439-41b8-8979-640037f68e02', 'water_tank', 'water tanks', 'annually', 'water_safety', ARRAY['Connaught Square (32-34) - 09.12.24 LRA.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, location_description, model_number, compliance_category, linked_documents) VALUES ('1282f2ba-1bf9-4068-8e77-92e9aafd2745', '355128d6-4439-41b8-8979-640037f68e02', 'boiler', 'Boiler Room', 'Basement', 'Fire', 'gas_safety', ARRAY['Fire Door (Communal) Inspection (11m +) (7).pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, location_description, compliance_category, linked_documents) VALUES ('12b39ea7-bf20-4663-a935-c1e36a54eb89', '355128d6-4439-41b8-8979-640037f68e02', 'boiler', 'Boiler room', 'terrace - lift', 'gas_safety', ARRAY['221037_Fra1-L-394697-071223 32-34 Connaught Square_2024-01-02_163759.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, location_description, condition_rating, compliance_category, linked_documents) VALUES ('a5f44939-d564-434f-a709-a4f9b93c0c0b', '355128d6-4439-41b8-8979-640037f68e02', 'fire_alarm', 'Fire Alarm', 'in appropriate X Breaches to compartmentation observed', 'good', 'fire_safety', ARRAY['221037_Fra1-L-394697-071223 32-34 Connaught Square_2024-01-02_163759.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, location_description, compliance_category, linked_documents) VALUES ('8c05649e-05bb-4927-86e1-ff15b1c90938', '355128d6-4439-41b8-8979-640037f68e02', 'lift', 'lift
motor', 'terrace - lift', 'lifts_safety', ARRAY['221037_Fra1-L-394697-071223 32-34 Connaught Square_2024-01-02_163759.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, location_description, model_number, compliance_category, linked_documents) VALUES ('e73c51f5-2573-4bb1-9bbc-e4b41811bd1e', '355128d6-4439-41b8-8979-640037f68e02', 'door_entry', 'Intercom door entry', 'to 3rd floor', '1', 'security', ARRAY['221037_Fra1-L-394697-071223 32-34 Connaught Square_2024-01-02_163759.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('1e8564f1-3c54-480f-9fbe-fbf098ab4aa1', '355128d6-4439-41b8-8979-640037f68e02', 'emergency_lighting', 'emergency lighting present', 'fire_safety', ARRAY['221037_Fra1-L-394697-071223 32-34 Connaught Square_2024-01-02_163759.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('41fa9218-c7d2-43d8-9b29-d2fee6699d03', '355128d6-4439-41b8-8979-640037f68e02', 'fire_extinguisher', 'fire extinguishers', 'fire_safety', ARRAY['221037_Fra1-L-394697-071223 32-34 Connaught Square_2024-01-02_163759.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, condition_rating, compliance_category, linked_documents) VALUES ('ee81f97d-1b3f-4491-a8af-33c98f86c9ca', '355128d6-4439-41b8-8979-640037f68e02', 'lightning_protection', 'Lightning protection available', 'good', 'electrical_safety', ARRAY['221037_Fra1-L-394697-071223 32-34 Connaught Square_2024-01-02_163759.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, location_description, model_number, compliance_category, linked_documents) VALUES ('06b32b56-9977-4ecc-a339-21570e7d9bb4', '355128d6-4439-41b8-8979-640037f68e02', 'boiler', 'Boiler Room', 'Basement', 'Fire', 'gas_safety', ARRAY['Fire Door (Communal) Inspection (11m +) - 2024-01-24T120743.986.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, location_description, compliance_category, linked_documents) VALUES ('4e456ea5-8297-47f1-b9cd-537d8894b365', '355128d6-4439-41b8-8979-640037f68e02', 'boiler', 'Boiler room', 'terrace - lift', 'gas_safety', ARRAY['221038_Hsra1-L-394697-071223 32-34 Connaught Square_2024-01-02_163759.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('61cf4952-3e1c-4bd4-85b0-1467c167f0a9', '355128d6-4439-41b8-8979-640037f68e02', 'lift', 'LIFTS', 'lifts_safety', ARRAY['221038_Hsra1-L-394697-071223 32-34 Connaught Square_2024-01-02_163759.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('088fc7ae-459e-4db6-a81b-18b396a6c062', '355128d6-4439-41b8-8979-640037f68e02', 'cctv', 'CCTV equipment', 'security', ARRAY['221038_Hsra1-L-394697-071223 32-34 Connaught Square_2024-01-02_163759.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, location_description, compliance_category, linked_documents) VALUES ('be55b406-ff9e-480a-8ada-415920820248', '355128d6-4439-41b8-8979-640037f68e02', 'door_entry', 'Intercom door entry', 'to 3rd floor', 'security', ARRAY['221038_Hsra1-L-394697-071223 32-34 Connaught Square_2024-01-02_163759.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('f3c05e2b-3fe1-4251-ad22-73c11bfc7c81', '355128d6-4439-41b8-8979-640037f68e02', 'emergency_lighting', 'Emergency lighting provided', 'fire_safety', ARRAY['221038_Hsra1-L-394697-071223 32-34 Connaught Square_2024-01-02_163759.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('85ae15c7-0500-4bbb-91f8-c1ae2842f7ad', '355128d6-4439-41b8-8979-640037f68e02', 'water_tank', 'water storage tank', 'water_safety', ARRAY['221038_Hsra1-L-394697-071223 32-34 Connaught Square_2024-01-02_163759.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, location_description, compliance_category, linked_documents) VALUES ('1d62a847-e783-454d-acaa-4ff97020266b', '355128d6-4439-41b8-8979-640037f68e02', 'boiler', 'Boiler room', 'terrace - lift', 'gas_safety', ARRAY['Hsfra1-L-422971-210225 32-34 Connaught Square.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, location_description, condition_rating, compliance_category, linked_documents) VALUES ('6a33ebf5-f8b4-44f1-b639-16703c154a32', '355128d6-4439-41b8-8979-640037f68e02', 'fire_alarm', 'Fire Alarm', 'in appropriate X Breaches to compartmentation observed', 'good', 'fire_safety', ARRAY['Hsfra1-L-422971-210225 32-34 Connaught Square.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('64c984e0-7ecb-449b-b166-942b19e8726b', '355128d6-4439-41b8-8979-640037f68e02', 'lift', 'LIFTS', 'lifts_safety', ARRAY['Hsfra1-L-422971-210225 32-34 Connaught Square.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('7d3a44c2-8ed8-413e-b9c7-6540bf8b748f', '355128d6-4439-41b8-8979-640037f68e02', 'cctv', 'CCTV equipment', 'security', ARRAY['Hsfra1-L-422971-210225 32-34 Connaught Square.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, location_description, compliance_category, linked_documents) VALUES ('b400d603-c075-41fc-ba30-e5f0cabcc9df', '355128d6-4439-41b8-8979-640037f68e02', 'door_entry', 'Intercom door entry', 'to 3rd floor', 'security', ARRAY['Hsfra1-L-422971-210225 32-34 Connaught Square.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('c8867992-837e-4259-bda7-811629b52746', '355128d6-4439-41b8-8979-640037f68e02', 'emergency_lighting', 'Emergency lighting provided', 'fire_safety', ARRAY['Hsfra1-L-422971-210225 32-34 Connaught Square.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('dcdbc094-11ed-4c78-b9a1-59c9e81d75c6', '355128d6-4439-41b8-8979-640037f68e02', 'fire_extinguisher', 'fire extinguishers', 'fire_safety', ARRAY['Hsfra1-L-422971-210225 32-34 Connaught Square.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, condition_rating, compliance_category, linked_documents) VALUES ('e648020c-b577-42bb-8f75-bfb698e4c840', '355128d6-4439-41b8-8979-640037f68e02', 'lightning_protection', 'Lightning protection available', 'good', 'electrical_safety', ARRAY['Hsfra1-L-422971-210225 32-34 Connaught Square.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('b5bcaa67-aa77-49b9-9a1e-4be72239d7fe', '355128d6-4439-41b8-8979-640037f68e02', 'water_tank', 'water storage tank', 'water_safety', ARRAY['Hsfra1-L-422971-210225 32-34 Connaught Square.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('34617eea-5d52-449e-9f44-109a675b1a79', '355128d6-4439-41b8-8979-640037f68e02', 'fire_alarm', 'ESCAPE

FIRE DETECTION', 'fire_safety', ARRAY['Hsfra1-L-422971-210225 32-34 Connaught Square.docx']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('587c7a0f-18a9-4bc5-8b63-dd864adea8c6', '355128d6-4439-41b8-8979-640037f68e02', 'lift', 'LIFTS', 'lifts_safety', ARRAY['Hsfra1-L-422971-210225 32-34 Connaught Square.docx']);
INSERT INTO assets (id, building_id, asset_type, asset_name, location_description, compliance_category, linked_documents) VALUES ('5c291222-0907-4ffd-81da-64528efd2ec2', '355128d6-4439-41b8-8979-640037f68e02', 'boiler', 'Boiler room', 'terrace - lift', 'gas_safety', ARRAY['221037_Fra1-L-394697-071223 32-34 Connaught Square_2024-01-02_163759 (1).pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, location_description, condition_rating, compliance_category, linked_documents) VALUES ('5aa54f99-cfa1-4ab8-aa01-bd8c397e7419', '355128d6-4439-41b8-8979-640037f68e02', 'fire_alarm', 'Fire Alarm', 'in appropriate X Breaches to compartmentation observed', 'good', 'fire_safety', ARRAY['221037_Fra1-L-394697-071223 32-34 Connaught Square_2024-01-02_163759 (1).pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, location_description, compliance_category, linked_documents) VALUES ('1c6ccea0-2504-48b6-9619-4b6d96b87f3a', '355128d6-4439-41b8-8979-640037f68e02', 'lift', 'lift
motor', 'terrace - lift', 'lifts_safety', ARRAY['221037_Fra1-L-394697-071223 32-34 Connaught Square_2024-01-02_163759 (1).pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, location_description, model_number, compliance_category, linked_documents) VALUES ('14cf439c-1f6a-40fe-a078-79e0f333e227', '355128d6-4439-41b8-8979-640037f68e02', 'door_entry', 'Intercom door entry', 'to 3rd floor', '1', 'security', ARRAY['221037_Fra1-L-394697-071223 32-34 Connaught Square_2024-01-02_163759 (1).pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('a992cc10-58dd-4372-84c9-b30b6e7f976e', '355128d6-4439-41b8-8979-640037f68e02', 'emergency_lighting', 'emergency lighting present', 'fire_safety', ARRAY['221037_Fra1-L-394697-071223 32-34 Connaught Square_2024-01-02_163759 (1).pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('b9df0eef-3ca7-4332-b954-e8390800bf85', '355128d6-4439-41b8-8979-640037f68e02', 'fire_extinguisher', 'fire extinguishers', 'fire_safety', ARRAY['221037_Fra1-L-394697-071223 32-34 Connaught Square_2024-01-02_163759 (1).pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, condition_rating, compliance_category, linked_documents) VALUES ('815c4990-939a-43c9-b8ad-f0276895fc37', '355128d6-4439-41b8-8979-640037f68e02', 'lightning_protection', 'Lightning protection available', 'good', 'electrical_safety', ARRAY['221037_Fra1-L-394697-071223 32-34 Connaught Square_2024-01-02_163759 (1).pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, location_description, compliance_category, linked_documents) VALUES ('ead8c21b-4dc6-4a2a-8e5e-d1896bd2d2f5', '355128d6-4439-41b8-8979-640037f68e02', 'boiler', 'Boiler room', 'terrace - lift', 'gas_safety', ARRAY['221038_Hsra1-L-394697-071223 32-34 Connaught Square_2024-01-02_163759 (1).pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('d04d529e-d70e-4332-91d9-25ec678faaef', '355128d6-4439-41b8-8979-640037f68e02', 'lift', 'LIFTS', 'lifts_safety', ARRAY['221038_Hsra1-L-394697-071223 32-34 Connaught Square_2024-01-02_163759 (1).pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('013d1c01-5dc4-49dc-a7ae-a63c68f77c09', '355128d6-4439-41b8-8979-640037f68e02', 'cctv', 'CCTV equipment', 'security', ARRAY['221038_Hsra1-L-394697-071223 32-34 Connaught Square_2024-01-02_163759 (1).pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, location_description, compliance_category, linked_documents) VALUES ('5d098470-72a0-47ca-93b0-36375ca38f7a', '355128d6-4439-41b8-8979-640037f68e02', 'door_entry', 'Intercom door entry', 'to 3rd floor', 'security', ARRAY['221038_Hsra1-L-394697-071223 32-34 Connaught Square_2024-01-02_163759 (1).pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('993a298b-efdd-4941-9c27-373c417fc233', '355128d6-4439-41b8-8979-640037f68e02', 'emergency_lighting', 'Emergency lighting provided', 'fire_safety', ARRAY['221038_Hsra1-L-394697-071223 32-34 Connaught Square_2024-01-02_163759 (1).pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('61506e6a-abf2-4142-bae5-1de77340bb34', '355128d6-4439-41b8-8979-640037f68e02', 'water_tank', 'water storage tank', 'water_safety', ARRAY['221038_Hsra1-L-394697-071223 32-34 Connaught Square_2024-01-02_163759 (1).pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, location_description, model_number, condition_rating, compliance_category, linked_documents) VALUES ('6f55afeb-06c3-4e59-951a-08f2f9f2cd82', '355128d6-4439-41b8-8979-640037f68e02', 'boiler', 'Boiler Hamworthy', 'Plant Room Condensing', 'pressure', 'fair', 'gas_safety', ARRAY['001534-3234-Connaught-Square-London.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, location_description, compliance_category, linked_documents) VALUES ('7f87c7cd-bbe7-4a20-8842-d6cfac6329f2', '355128d6-4439-41b8-8979-640037f68e02', 'boiler', 'boiler number', 'new gas valve', 'gas_safety', ARRAY['C1047 - Job card.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, model_number, compliance_category, linked_documents) VALUES ('1cdb283e-2906-46f1-af7e-8e9052db1977', '355128d6-4439-41b8-8979-640037f68e02', 'boiler', 'Boilers', 'Total', 'gas_safety', ARRAY['WHM Legionella Risk Assessment 09.12.25.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('d49257a2-5afd-4243-89d8-096879742b75', '355128d6-4439-41b8-8979-640037f68e02', 'sprinkler', 'Sprinklers', 'fire_safety', ARRAY['WHM Legionella Risk Assessment 09.12.25.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('cee69796-9d45-444e-a706-7b1a44d5e350', '355128d6-4439-41b8-8979-640037f68e02', 'pump', 'pump is', 'water_safety', ARRAY['WHM Legionella Risk Assessment 09.12.25.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, service_frequency, compliance_category, linked_documents) VALUES ('82a3a180-eb62-4dfe-9bce-52d2f76cc399', '355128d6-4439-41b8-8979-640037f68e02', 'water_tank', 'water tanks', 'annually', 'water_safety', ARRAY['WHM Legionella Risk Assessment 09.12.25.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, model_number, compliance_category, linked_documents) VALUES ('3fa9b7b1-e5cf-42ba-b22c-ddba9ee0f9d3', '355128d6-4439-41b8-8979-640037f68e02', 'boiler', 'Boilers', 'Total', 'gas_safety', ARRAY['WHM Legionella Risk Assessment 07.06.22.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('7a70b840-4bf8-425e-ad16-aec2e62d4c94', '355128d6-4439-41b8-8979-640037f68e02', 'sprinkler', 'Sprinklers', 'fire_safety', ARRAY['WHM Legionella Risk Assessment 07.06.22.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('af969ba8-2fff-488f-be8a-1375755ee7df', '355128d6-4439-41b8-8979-640037f68e02', 'pump', 'pump is', 'water_safety', ARRAY['WHM Legionella Risk Assessment 07.06.22.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, service_frequency, compliance_category, linked_documents) VALUES ('3118b240-c49e-4030-ab2a-bbdaf60e54a3', '355128d6-4439-41b8-8979-640037f68e02', 'water_tank', 'water tanks', 'annually', 'water_safety', ARRAY['WHM Legionella Risk Assessment 07.06.22.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('5d93ab65-07bd-445e-84f0-141bbe3aeb45', '355128d6-4439-41b8-8979-640037f68e02', 'fire_alarm', 'Fire Alarm A', 'fire_safety', ARRAY['EICR Cuanku 32-34 conaught square.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, location_description, compliance_category, linked_documents) VALUES ('2bd3773f-16f6-4584-80c7-61b214266c9f', '355128d6-4439-41b8-8979-640037f68e02', 'lift', 'LIFT SHAFT', 'CONTROL CIRCUITS', 'lifts_safety', ARRAY['EICR Cuanku 32-34 conaught square.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, model_number, compliance_category, linked_documents) VALUES ('f7c1e8f2-024a-4f8d-a813-e527c97dffda', '355128d6-4439-41b8-8979-640037f68e02', 'lightning_protection', 'To lightning protection', 'B', 'electrical_safety', ARRAY['EICR Cuanku 32-34 conaught square.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('f359e723-c47e-48e1-8261-05822b09c9ba', '355128d6-4439-41b8-8979-640037f68e02', 'generator', 'generators', 'electrical_safety', ARRAY['EICR Cuanku 32-34 conaught square.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('e184fa77-f6e2-4337-832b-7da0e2d8dcec', '355128d6-4439-41b8-8979-640037f68e02', 'fire_alarm', 'Fire Alarm A', 'fire_safety', ARRAY['EICR Report Cunaku SATISFACTORY 2023 .pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, location_description, compliance_category, linked_documents) VALUES ('308403be-84bf-4a3b-807d-caa6ee86acb6', '355128d6-4439-41b8-8979-640037f68e02', 'lift', 'LIFT SHAFT', 'CONTROL CIRCUITS', 'lifts_safety', ARRAY['EICR Report Cunaku SATISFACTORY 2023 .pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, model_number, compliance_category, linked_documents) VALUES ('f460245f-9327-4b16-867b-664cd128307a', '355128d6-4439-41b8-8979-640037f68e02', 'lightning_protection', 'To lightning protection', 'B', 'electrical_safety', ARRAY['EICR Report Cunaku SATISFACTORY 2023 .pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('c618ea13-f590-4cf0-90e0-0f9e2b919259', '355128d6-4439-41b8-8979-640037f68e02', 'generator', 'generators', 'electrical_safety', ARRAY['EICR Report Cunaku SATISFACTORY 2023 .pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, location_description, model_number, condition_rating, compliance_category, linked_documents) VALUES ('8bb593a7-b3f7-4716-a973-efe25b6f0ed4', '355128d6-4439-41b8-8979-640037f68e02', 'boiler', 'Boiler Hanworthy', 'Condensing Boiler Hanworthy Purewell variheat m k2 110 21 Mbar 110 0', 'pressure', 'fair', 'gas_safety', ARRAY['001132-3234-Connaught-Square-London.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, location_description, model_number, condition_rating, compliance_category, linked_documents) VALUES ('285c1fa6-4cf9-434f-9fde-e3c0c1cffec9', '355128d6-4439-41b8-8979-640037f68e02', 'boiler', 'Boiler Hamworthy', 'Plant Room Condensing', 'pressure', 'fair', 'gas_safety', ARRAY['001534-3234-Connaught-Square-London.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, location_description, compliance_category, linked_documents) VALUES ('46965d79-0f31-42fd-af94-aa711a222e76', '355128d6-4439-41b8-8979-640037f68e02', 'boiler', 'Boiler Room', 'pipework', 'gas_safety', ARRAY['FINAL L-432900 32-34 Connaught Square Management Survey Report Issue 1.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, location_description, compliance_category, linked_documents) VALUES ('5972fd5e-4be5-4b6c-9c1d-7c6b47bf501a', '355128d6-4439-41b8-8979-640037f68e02', 'lift', 'Lift Motor', 'Room brake shoe to lift motor', 'lifts_safety', ARRAY['FINAL L-432900 32-34 Connaught Square Management Survey Report Issue 1.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, location_description, compliance_category, linked_documents) VALUES ('e25d4c8a-0df6-4014-855f-59385941ee80', '355128d6-4439-41b8-8979-640037f68e02', 'boiler', 'Boiler Room', 'exits', 'gas_safety', ARRAY['TETRA - Asbestos Re-Inspection Survey 14.06.22.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, location_description, compliance_category, linked_documents) VALUES ('0f208af0-090c-4cdc-be08-9c5c738e831c', '355128d6-4439-41b8-8979-640037f68e02', 'lift', 'Lift Motor', 'Description Assessment', 'lifts_safety', ARRAY['TETRA - Asbestos Re-Inspection Survey 14.06.22.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, location_description, compliance_category, linked_documents) VALUES ('1114a0bd-e7f4-446a-bb4b-8a195de9b431', '355128d6-4439-41b8-8979-640037f68e02', 'pump', 'pumps', 'exits', 'water_safety', ARRAY['TETRA - Asbestos Re-Inspection Survey 14.06.22.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, service_frequency, compliance_category, linked_documents) VALUES ('df6063f4-68ba-4a00-8bde-329a4ee9b440', '355128d6-4439-41b8-8979-640037f68e02', 'lift', 'lifts', 'monthly', 'lifts_safety', ARRAY['Signed 2025 Connaught Square Management Agreement.docx.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, service_frequency, compliance_category, linked_documents) VALUES ('23efa6a8-0547-4cf5-bb05-d77063a66769', '355128d6-4439-41b8-8979-640037f68e02', 'lift', 'lifts', 'monthly', 'lifts_safety', ARRAY['Signed Connaught Square Management Agreement.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, model_number, compliance_category, linked_documents) VALUES ('34c1627d-6fb7-4a09-871c-4c6c016c8ad1', '355128d6-4439-41b8-8979-640037f68e02', 'boiler', 'BOILER SERVICE', 'OF', 'gas_safety', ARRAY['CM434.PRO 2024-2025.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, model_number, compliance_category, linked_documents) VALUES ('609b0fed-e353-47ac-a9ec-b85a57530ff2', '355128d6-4439-41b8-8979-640037f68e02', 'boiler', 'BOILER SERVICE', 'OF', 'gas_safety', ARRAY['CM434.PRO.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('2203e66b-32b3-4de1-a76e-5da97aa8d652', '355128d6-4439-41b8-8979-640037f68e02', 'lift', 'lift in', 'lifts_safety', ARRAY['Gas Contract 24-5.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('285a592b-09ed-46d7-83ec-5891d30fce86', '355128d6-4439-41b8-8979-640037f68e02', 'lift', 'LIFT INCORPORATED', 'lifts_safety', ARRAY['Contract_10-03-2025.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('2a61b6a8-0095-4c2e-bf3d-1d324fbc80d7', '355128d6-4439-41b8-8979-640037f68e02', 'lift', 'LIFT INCORPORATED', 'lifts_safety', ARRAY['Gas Contract 25-26.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('9da621eb-4413-4404-95b8-ff0105e30224', '355128d6-4439-41b8-8979-640037f68e02', 'lift', 'lift to', 'lifts_safety', ARRAY['Welcome Letter - CG1885574.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, location_description, service_frequency, compliance_category, linked_documents) VALUES ('1cbcc8a6-712a-4fcf-a429-6b84d6cf1587', '355128d6-4439-41b8-8979-640037f68e02', 'lift', 'lift accessible', 'To clean out silt from the outlet and bagged it up', 'monthly', 'lifts_safety', ARRAY['Job 67141.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, model_number, compliance_category, linked_documents) VALUES ('7fa3c6ee-fb0d-4e0f-954b-3764769ee794', '355128d6-4439-41b8-8979-640037f68e02', 'lift', 'Lift Ref', 'BRONZE', 'lifts_safety', ARRAY['JLGCalloutVisit-5455045-12-07-2024.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, model_number, compliance_category, linked_documents) VALUES ('1e252704-80db-4216-9b9a-cf01f7ba279b', '355128d6-4439-41b8-8979-640037f68e02', 'lift', 'Lift Ref', 'BRONZE', 'lifts_safety', ARRAY['JLGCalloutVisit-5483206-26-10-2024.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, model_number, compliance_category, linked_documents) VALUES ('beb11a8c-db06-4431-9237-115fdee544be', '355128d6-4439-41b8-8979-640037f68e02', 'lift', 'Lift Ref', 'BRONZE', 'lifts_safety', ARRAY['JLGCalloutVisit-5498439-16-12-2024.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, location_description, compliance_category, linked_documents) VALUES ('8168693d-cf1e-476d-b00c-a1142ad5b701', '355128d6-4439-41b8-8979-640037f68e02', 'emergency_lighting', 'emergency lighting
The', 'The fault status has been classified as Faulty', 'fire_safety', ARRAY['JLGCalloutVisit-5498439-16-12-2024.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, model_number, compliance_category, linked_documents) VALUES ('f4d546a5-9607-4e60-a049-23d47a44fc05', '355128d6-4439-41b8-8979-640037f68e02', 'lift', 'Lift Ref', 'BRONZE', 'lifts_safety', ARRAY['JLGCalloutVisit-5455462-16-07-2024.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, model_number, compliance_category, linked_documents) VALUES ('95780672-11d1-4369-9001-d3677c1bad09', '355128d6-4439-41b8-8979-640037f68e02', 'lift', 'Lift Ref', 'BRONZE', 'lifts_safety', ARRAY['JLGCalloutVisit-5497480-13-12-2024.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, model_number, compliance_category, linked_documents) VALUES ('327aa9cd-7776-47bd-9ada-41ed3c63453e', '355128d6-4439-41b8-8979-640037f68e02', 'fire_alarm', 'Fire Alarm', 'SMALL', 'fire_safety', ARRAY['Engineering Report - 32-34 CONNAUGHT SQUARE.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, model_number, compliance_category, linked_documents) VALUES ('d15dae1d-6592-495f-a210-62bc70b0d1c7', '355128d6-4439-41b8-8979-640037f68e02', 'emergency_lighting', 'Emergency Lights - FA7817', 'SMALL', 'fire_safety', ARRAY['Engineering Report - 32-34 CONNAUGHT SQUARE.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, location_description, compliance_category, linked_documents) VALUES ('633b9f87-fb0c-4905-b7ce-7b43a62e45ba', '355128d6-4439-41b8-8979-640037f68e02', 'boiler', 'a boiler', 'but this sha', 'gas_safety', ARRAY['StG_Policy Wording_32-34 Connaught Square W2 2HL.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('3ae987cc-9a51-4c09-b8a2-92b77f397962', '355128d6-4439-41b8-8979-640037f68e02', 'fire_alarm', 'fire alarm
The', 'fire_safety', ARRAY['StG_Policy Wording_32-34 Connaught Square W2 2HL.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('95de660f-cf9c-4be2-aaf1-eee17b15ab96', '355128d6-4439-41b8-8979-640037f68e02', 'sprinkler', 'sprinkler leakage', 'fire_safety', ARRAY['StG_Policy Wording_32-34 Connaught Square W2 2HL.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('d7ba0874-c5f3-4a92-8b76-1a89279ac417', '355128d6-4439-41b8-8979-640037f68e02', 'lift', 'lift in', 'lifts_safety', ARRAY['StG_Policy Wording_32-34 Connaught Square W2 2HL.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('9ee23df3-bcfa-420f-bd20-55ac48de8dcc', '355128d6-4439-41b8-8979-640037f68e02', 'pump', 'pumping', 'water_safety', ARRAY['StG_Policy Wording_32-34 Connaught Square W2 2HL.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, location_description, compliance_category, linked_documents) VALUES ('8cc17b58-67b4-40d3-9a26-7516341214d9', '355128d6-4439-41b8-8979-640037f68e02', 'cctv', 'cameras', 'on or', 'security', ARRAY['StG_Policy Wording_32-34 Connaught Square W2 2HL.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('60089c71-6d3a-4a6c-99e4-b9dc49d85938', '355128d6-4439-41b8-8979-640037f68e02', 'water_tank', 'water tanks', 'water_safety', ARRAY['StG_Policy Wording_32-34 Connaught Square W2 2HL.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('eac66269-c1c9-4a17-80a0-d5be513ce38d', '355128d6-4439-41b8-8979-640037f68e02', 'fire_extinguisher', 'fire extinguishers', 'fire_safety', ARRAY['Q51691 - 32-34 Connaught Square Contract.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, model_number, compliance_category, linked_documents) VALUES ('d54ff07f-4bc5-4d66-90f1-277a76917d58', '355128d6-4439-41b8-8979-640037f68e02', 'fire_alarm', 'Fire Alarm', 'SMALL', 'fire_safety', ARRAY['Engineering Report - 32-34 CONNAUGHT SQUARE.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, model_number, compliance_category, linked_documents) VALUES ('904f20dc-b208-4d7e-9e2d-f316f944435f', '355128d6-4439-41b8-8979-640037f68e02', 'emergency_lighting', 'Emergency Lights - FA7817', 'SMALL', 'fire_safety', ARRAY['Engineering Report - 32-34 CONNAUGHT SQUARE.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, location_description, model_number, compliance_category, linked_documents) VALUES ('39c35967-9bc1-4056-9df0-058b82df3a6c', '355128d6-4439-41b8-8979-640037f68e02', 'fire_alarm', 'uk
FIRE ALARM', 'LONDON', 'LIGHTS', 'fire_safety', ARRAY['Fire Alarm+Emergency Lighting Contract Connaught Square.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, service_frequency, compliance_category, linked_documents) VALUES ('224c6edf-2e4b-427b-b0bd-9412120fc3c7', '355128d6-4439-41b8-8979-640037f68e02', 'emergency_lighting', 'EMERGENCY LIGHTS
MT8825', 'monthly', 'fire_safety', ARRAY['Fire Alarm+Emergency Lighting Contract Connaught Square.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, service_frequency, compliance_category, linked_documents) VALUES ('479749b5-8aec-4f78-ae88-257f4a297aff', '355128d6-4439-41b8-8979-640037f68e02', 'fire_alarm', 'FIRE ALARM BELL', 'monthly', 'fire_safety', ARRAY['BT3205 03072025.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, model_number, service_frequency, compliance_category, linked_documents) VALUES ('53bf0d99-f378-4354-a099-5c13b7f7559e', '355128d6-4439-41b8-8979-640037f68e02', 'fire_alarm', 'fire alarm service', 'MAINTENANCE', 'monthly', 'fire_safety', ARRAY['FA7817 SERVICE 08042025.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, model_number, service_frequency, compliance_category, linked_documents) VALUES ('6da5c1b4-a9fd-4361-8bc0-09da6a33c2a5', '355128d6-4439-41b8-8979-640037f68e02', 'emergency_lighting', 'Emergency Lights - FA7817', 'MAINTENANCE', 'monthly', 'fire_safety', ARRAY['FA7817 SERVICE 08042025.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, model_number, compliance_category, linked_documents) VALUES ('a6764f9e-2f37-4ab2-bbc9-aaca2dd1a0c6', '355128d6-4439-41b8-8979-640037f68e02', 'fire_alarm', 'Fire Alarm', 'SMALL', 'fire_safety', ARRAY['Engineer Report - 32-34 Connaught Square Flat 5.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, model_number, compliance_category, linked_documents) VALUES ('e54d3006-7949-482c-b9c3-76516bfc4ca4', '355128d6-4439-41b8-8979-640037f68e02', 'emergency_lighting', 'Emergency Lights - FA7817', 'SMALL', 'fire_safety', ARRAY['Engineer Report - 32-34 Connaught Square Flat 5.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, model_number, compliance_category, linked_documents) VALUES ('338ce9d8-d1a5-4c57-8f68-bfe8b96b9340', '355128d6-4439-41b8-8979-640037f68e02', 'fire_alarm', 'Fire Alarm', 'SMALL', 'fire_safety', ARRAY['Engineering Report - 32-34 CONNAUGHT SQUARE.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, model_number, compliance_category, linked_documents) VALUES ('afbfc568-c4f3-4d2b-bf22-2d062f5d37a2', '355128d6-4439-41b8-8979-640037f68e02', 'emergency_lighting', 'Emergency Lights - FA7817', 'SMALL', 'fire_safety', ARRAY['Engineering Report - 32-34 CONNAUGHT SQUARE.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, model_number, service_frequency, compliance_category, linked_documents) VALUES ('17e49a89-6fbf-41f0-beb3-8fb61b5f262e', '355128d6-4439-41b8-8979-640037f68e02', 'emergency_lighting', 'Emergency Lights Testing', 'MONTHLY', 'monthly', 'fire_safety', ARRAY['MT8825 03072025.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, model_number, service_frequency, compliance_category, linked_documents) VALUES ('856a4750-8d68-4e21-a7b2-b05c10065d2d', '355128d6-4439-41b8-8979-640037f68e02', 'emergency_lighting', 'Emergency Lights Testing', 'MONTHLY', 'monthly', 'fire_safety', ARRAY['January Monthly Test For EL-Connaught Square.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, model_number, service_frequency, compliance_category, linked_documents) VALUES ('df50c2fa-c567-42f2-9d57-e2f534c76a98', '355128d6-4439-41b8-8979-640037f68e02', 'emergency_lighting', 'Emergency Lights Testing', 'MONTHLY', 'monthly', 'fire_safety', ARRAY['February Monthly Test For EL-Connaught Square.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('f7b091f6-7ca6-49a8-a0b5-d495cc698b5c', '355128d6-4439-41b8-8979-640037f68e02', 'boiler', 'boilers', 'gas_safety', ARRAY['Real Estate Policy (01.23).pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('3338985e-097e-4538-a2e0-685c7f5838d8', '355128d6-4439-41b8-8979-640037f68e02', 'sprinkler', 'sprinkler leakage', 'fire_safety', ARRAY['Real Estate Policy (01.23).pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('8b0f22a5-7bbd-4511-8b6b-5f0444eb3797', '355128d6-4439-41b8-8979-640037f68e02', 'pump', 'pumping', 'water_safety', ARRAY['Real Estate Policy (01.23).pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('e3717efe-11f3-47e8-9682-b3d19a6e3602', '355128d6-4439-41b8-8979-640037f68e02', 'cctv', 'cameras', 'security', ARRAY['Real Estate Policy (01.23).pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('156186a7-3a4f-43d0-b09e-a2dc761ccdf5', '355128d6-4439-41b8-8979-640037f68e02', 'fire_extinguisher', 'fire extinguishers', 'fire_safety', ARRAY['Real Estate Policy (01.23).pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('03e535bb-02e7-428a-b222-179b84d98260', '355128d6-4439-41b8-8979-640037f68e02', 'communal_aerial', 'satellite dishes', 'other', ARRAY['Real Estate Policy (01.23).pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('439a8155-ff31-45e2-989b-700f8d3d3852', '355128d6-4439-41b8-8979-640037f68e02', 'water_tank', 'water tanks', 'water_safety', ARRAY['Real Estate Policy (01.23).pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('2fe5327d-0d64-4877-a68a-78392195dca1', '355128d6-4439-41b8-8979-640037f68e02', 'sprinkler', 'sprinkler installation', 'fire_safety', ARRAY['Summary of Cover (01.23).pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('5978604d-5634-4493-96ec-63c4f6c7ba31', '355128d6-4439-41b8-8979-640037f68e02', 'lift', 'lift in', 'lifts_safety', ARRAY['Summary of Cover (01.23).pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('684056da-9b13-472c-ab06-2c22b52d7aa3', '355128d6-4439-41b8-8979-640037f68e02', 'boiler', 'Boilers', 'gas_safety', ARRAY['2023 Allianz VOC - 32-34 Connuaght Square (Freehold) Limited.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('d124adc8-1cce-4bbc-8eaa-5ac01d3d9fa9', '355128d6-4439-41b8-8979-640037f68e02', 'lift', 'Lift - Powered', 'lifts_safety', ARRAY['2023 Allianz VOC - 32-34 Connuaght Square (Freehold) Limited.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('e34dcfbd-ba81-4363-9234-31c7d6e6cd9f', '355128d6-4439-41b8-8979-640037f68e02', 'pump', 'Pumps', 'water_safety', ARRAY['2023 Allianz VOC - 32-34 Connuaght Square (Freehold) Limited.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('4d461dce-df9f-4e4a-a25c-ed8d055bec7a', '355128d6-4439-41b8-8979-640037f68e02', 'boiler', 'Boilers', 'gas_safety', ARRAY['2023 Engineering Renewal Notice - 32 34 Connuaght Square (Freehold) Limited.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('b5e67009-2c09-47cf-8aa2-ff197fe711dd', '355128d6-4439-41b8-8979-640037f68e02', 'lift', 'Lift -
Powered', 'lifts_safety', ARRAY['2023 Engineering Renewal Notice - 32 34 Connuaght Square (Freehold) Limited.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('45287123-38cc-47bf-ba63-f61c37bc711a', '355128d6-4439-41b8-8979-640037f68e02', 'pump', 'Pumps', 'water_safety', ARRAY['2023 Engineering Renewal Notice - 32 34 Connuaght Square (Freehold) Limited.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('ddd1c5f2-6933-4f55-b39b-2f7ce89744df', '355128d6-4439-41b8-8979-640037f68e02', 'lift', 'Lift', 'lifts_safety', ARRAY['32-34 Connaught Sq Buildings Insurance 2023-2024.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('a41c1ff3-0720-42c1-a144-32a3773fcdd9', '355128d6-4439-41b8-8979-640037f68e02', 'lift', 'Lift Report', 'lifts_safety', ARRAY['Allianz - Lift Report 14.03.23.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('7724c32d-5132-4a66-b4ae-2e18acefb001', '355128d6-4439-41b8-8979-640037f68e02', 'lift', 'Lift Report', 'lifts_safety', ARRAY['Allianz-Lift Report 18.03.2024.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('6c9a3609-56f5-40a4-8617-1913986be994', '355128d6-4439-41b8-8979-640037f68e02', 'lift', 'Lift Report', 'lifts_safety', ARRAY['Allianz - Lift Report - 15.09.21.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('af765a7c-a4fc-4ee2-aaa9-d22b8135e85c', '355128d6-4439-41b8-8979-640037f68e02', 'lift', 'Lift Report', 'lifts_safety', ARRAY['Allianz - Lift Report 10.03.22.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('7c3a1712-fb20-4f75-b1dd-f94515d41197', '355128d6-4439-41b8-8979-640037f68e02', 'boiler', 'Boilers', 'gas_safety', ARRAY['2023 Allianz VOC - 32-34 Connuaght Square (Freehold) Limited.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('bfd587f6-3287-4ac6-93ae-b4e882a7280e', '355128d6-4439-41b8-8979-640037f68e02', 'lift', 'Lift - Powered', 'lifts_safety', ARRAY['2023 Allianz VOC - 32-34 Connuaght Square (Freehold) Limited.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('25fa45e4-f70a-4835-90e1-69c80795c1fe', '355128d6-4439-41b8-8979-640037f68e02', 'pump', 'Pumps', 'water_safety', ARRAY['2023 Allianz VOC - 32-34 Connuaght Square (Freehold) Limited.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('04e43d12-5666-4aa2-8c72-3578ef4ac6a5', '355128d6-4439-41b8-8979-640037f68e02', 'boiler', 'Boilers', 'gas_safety', ARRAY['2023 Engineering Renewal Notice - 32 34 Connuaght Square (Freehold) Limited.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('4244c8b9-2116-488d-b967-b8d1a52fe022', '355128d6-4439-41b8-8979-640037f68e02', 'lift', 'Lift -
Powered', 'lifts_safety', ARRAY['2023 Engineering Renewal Notice - 32 34 Connuaght Square (Freehold) Limited.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('8d118bf6-74f9-47a3-98e4-6932586c4dce', '355128d6-4439-41b8-8979-640037f68e02', 'pump', 'Pumps', 'water_safety', ARRAY['2023 Engineering Renewal Notice - 32 34 Connuaght Square (Freehold) Limited.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, location_description, compliance_category, linked_documents) VALUES ('bc0dd73b-23e9-4f0f-bbad-ed0647562999', '355128d6-4439-41b8-8979-640037f68e02', 'boiler', 'Boiler and', 'owned by or leased', 'gas_safety', ARRAY['MO - Policy Wording - NZ0411.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('cd79194d-7cb3-48ea-a778-c17be9e0450a', '355128d6-4439-41b8-8979-640037f68e02', 'lift', 'Lift and', 'lifts_safety', ARRAY['MO - Policy Wording - NZ0411.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('f3d2d15c-9b14-4295-8260-1465e21cd609', '355128d6-4439-41b8-8979-640037f68e02', 'pump', 'pumps', 'water_safety', ARRAY['MO - Policy Wording - NZ0411.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('ef449332-81da-4edd-a32b-339c73dde73f', '355128d6-4439-41b8-8979-640037f68e02', 'water_tank', 'Storage Tanks', 'water_safety', ARRAY['MO - Policy Wording - NZ0411.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('d0e4aab8-4583-44ce-ba94-fbfca8ef142c', '355128d6-4439-41b8-8979-640037f68e02', 'generator', 'generator sets', 'electrical_safety', ARRAY['MO - Policy Wording - NZ0411.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('b0efc6a0-9608-4ca1-b79b-b36f553f81a7', '355128d6-4439-41b8-8979-640037f68e02', 'lift', 'Lift and', 'lifts_safety', ARRAY['Feature and Benefits of Allianz Engineering Inspection Service.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('5e2261fc-5e1b-4964-8e3b-a3b72114541a', '355128d6-4439-41b8-8979-640037f68e02', 'boiler', 'Boilers', 'gas_safety', ARRAY['StG_Statement of Facts_32-34 Connaught Square W2 2HL.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('dfa89573-8883-4661-bb0f-d61979690755', '355128d6-4439-41b8-8979-640037f68e02', 'lift', 'Lifts', 'lifts_safety', ARRAY['StG_Statement of Facts_32-34 Connaught Square W2 2HL.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('e26523b4-2aca-492e-a16d-0a7073f75ad4', '355128d6-4439-41b8-8979-640037f68e02', 'pump', 'Centrifugal pump', 'water_safety', ARRAY['StG_Statement of Facts_32-34 Connaught Square W2 2HL.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('f5d0383c-4acc-40b8-b11e-c29597954800', '355128d6-4439-41b8-8979-640037f68e02', 'boiler', 'Boilers', 'gas_safety', ARRAY['StG_Insurance Report_32-34 Connaught Square W2 2HL.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('ee9ff76a-9b82-40a3-a0a0-4d6ba9c8b65a', '355128d6-4439-41b8-8979-640037f68e02', 'lift', 'Lifts', 'lifts_safety', ARRAY['StG_Insurance Report_32-34 Connaught Square W2 2HL.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('7d0f536b-1d6d-4c41-88cc-374eea5d19d3', '355128d6-4439-41b8-8979-640037f68e02', 'pump', 'Centrifugal pump', 'water_safety', ARRAY['StG_Insurance Report_32-34 Connaught Square W2 2HL.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('9e359f74-a7e3-4a1f-8199-15deaab0db13', '355128d6-4439-41b8-8979-640037f68e02', 'boiler', 'Boilers', 'gas_safety', ARRAY['StG_Statement of Facts_32-34 Connaught Square W2 2HL.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('69ac33b3-c13e-436f-8fd0-b5fa97466ebd', '355128d6-4439-41b8-8979-640037f68e02', 'lift', 'Lifts', 'lifts_safety', ARRAY['StG_Statement of Facts_32-34 Connaught Square W2 2HL.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('615fc046-3b3f-4f0c-a341-fe1fc1666415', '355128d6-4439-41b8-8979-640037f68e02', 'pump', 'Centrifugal pump', 'water_safety', ARRAY['StG_Statement of Facts_32-34 Connaught Square W2 2HL.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('9fc0e7f8-9217-4379-9032-797787603bea', '355128d6-4439-41b8-8979-640037f68e02', 'boiler', 'Boilers', 'gas_safety', ARRAY['StG_Insurance Report_32-34 Connaught Square W2 2HL.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('9213fc9f-55c1-4a16-8ffd-47ce71f605e5', '355128d6-4439-41b8-8979-640037f68e02', 'lift', 'Lifts', 'lifts_safety', ARRAY['StG_Insurance Report_32-34 Connaught Square W2 2HL.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('0edd3440-88b8-4918-bb86-88b6b0c1b11e', '355128d6-4439-41b8-8979-640037f68e02', 'pump', 'Centrifugal pump', 'water_safety', ARRAY['StG_Insurance Report_32-34 Connaught Square W2 2HL.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('320f290c-4009-49d2-95b4-25b0aed8a05d', '355128d6-4439-41b8-8979-640037f68e02', 'boiler', 'water boiler', 'gas_safety', ARRAY['StG_Certificate_32-34 Connaught Square W2 2HL.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('9cab6b8b-4aa0-4abe-8fe4-e8082e8f6400', '355128d6-4439-41b8-8979-640037f68e02', 'lift', 'Passenger Lift', 'lifts_safety', ARRAY['StG_Certificate_32-34 Connaught Square W2 2HL.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('bcb3733b-dfd7-42c6-8d60-892ca2738a14', '355128d6-4439-41b8-8979-640037f68e02', 'pump', 'Centrifugal pump', 'water_safety', ARRAY['StG_Certificate_32-34 Connaught Square W2 2HL.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('a14f4cf1-fc3a-439e-a5ea-72982eb1a360', '355128d6-4439-41b8-8979-640037f68e02', 'boiler', 'Boilers', 'gas_safety', ARRAY['StG_Statement of Fact_32-34 Connaught Square W2 2HL.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('491a092c-e2ca-4499-9c97-11a9fd8d4bc8', '355128d6-4439-41b8-8979-640037f68e02', 'lift', 'Lifts', 'lifts_safety', ARRAY['StG_Statement of Fact_32-34 Connaught Square W2 2HL.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('e0a2fb70-7b94-4f57-ac0c-b3d8c738502d', '355128d6-4439-41b8-8979-640037f68e02', 'pump', '1x Pump', 'water_safety', ARRAY['StG_Statement of Fact_32-34 Connaught Square W2 2HL.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('f4a3559e-dea4-46da-97f2-5beac81fdd62', '355128d6-4439-41b8-8979-640037f68e02', 'lift', 'Lift', 'lifts_safety', ARRAY['FBR113382303-20230405-B.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('32d9b5f3-c185-4ef0-bd37-6fff9cfa37aa', '355128d6-4439-41b8-8979-640037f68e02', 'boiler', 'boilers', 'gas_safety', ARRAY['Real Estate Policy (01.23).pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('5adad312-622c-462d-94ec-e7b34d9d40f1', '355128d6-4439-41b8-8979-640037f68e02', 'sprinkler', 'sprinkler leakage', 'fire_safety', ARRAY['Real Estate Policy (01.23).pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('344e22d5-b2d0-4592-9e4f-17e17c64a57f', '355128d6-4439-41b8-8979-640037f68e02', 'pump', 'pumping', 'water_safety', ARRAY['Real Estate Policy (01.23).pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('e07f98b1-182b-4bf0-8a54-899d4f660bf7', '355128d6-4439-41b8-8979-640037f68e02', 'cctv', 'cameras', 'security', ARRAY['Real Estate Policy (01.23).pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('c247577a-779f-4e7b-9cc6-6bd8a972930a', '355128d6-4439-41b8-8979-640037f68e02', 'fire_extinguisher', 'fire extinguishers', 'fire_safety', ARRAY['Real Estate Policy (01.23).pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('3ff5aa5a-7c9f-43a6-9ed6-f9a09d746205', '355128d6-4439-41b8-8979-640037f68e02', 'communal_aerial', 'satellite dishes', 'other', ARRAY['Real Estate Policy (01.23).pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('df5fd46e-3731-4084-a304-6e7fe2e80ecf', '355128d6-4439-41b8-8979-640037f68e02', 'water_tank', 'water tanks', 'water_safety', ARRAY['Real Estate Policy (01.23).pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('1c6c22e8-d65a-4dae-85aa-a860ac476738', '355128d6-4439-41b8-8979-640037f68e02', 'sprinkler', 'sprinkler installation', 'fire_safety', ARRAY['Summary of Cover (01.23).pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('d5f34043-96a1-48e4-aac4-291d8ef3f8b4', '355128d6-4439-41b8-8979-640037f68e02', 'lift', 'lift in', 'lifts_safety', ARRAY['Summary of Cover (01.23).pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('b53684f2-7ddd-4b19-ab57-97c306adb239', '355128d6-4439-41b8-8979-640037f68e02', 'lift', 'Lift', 'lifts_safety', ARRAY['32-34 Connaught Sq Buildings Insurance 2023-2024.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('05b41629-6131-4d49-bd64-f30074beda0b', '355128d6-4439-41b8-8979-640037f68e02', 'sprinkler', 'sprinkler installation', 'fire_safety', ARRAY['Zurich Real Estate Policy Summary.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('9dc01e8e-0e92-4dfb-b571-e094e723b177', '355128d6-4439-41b8-8979-640037f68e02', 'lift', 'lift in', 'lifts_safety', ARRAY['Zurich Real Estate Policy Summary.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('72a09e7f-e383-4981-8f5c-2bd793a142d8', '355128d6-4439-41b8-8979-640037f68e02', 'boiler', 'boilers', 'gas_safety', ARRAY['Zurich Real Estate Policy Wording.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('7ae5165b-505e-4102-b2a8-000ce1b9a419', '355128d6-4439-41b8-8979-640037f68e02', 'sprinkler', 'sprinkler leakage', 'fire_safety', ARRAY['Zurich Real Estate Policy Wording.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('48082518-13ce-46bc-85b3-d9ed2af66dfc', '355128d6-4439-41b8-8979-640037f68e02', 'pump', 'pumping', 'water_safety', ARRAY['Zurich Real Estate Policy Wording.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('67ca7e1c-fa69-404e-9c25-7e92bfd7c7a9', '355128d6-4439-41b8-8979-640037f68e02', 'cctv', 'cameras', 'security', ARRAY['Zurich Real Estate Policy Wording.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('1f2f430a-e7f1-4826-a95b-074cfdf3da72', '355128d6-4439-41b8-8979-640037f68e02', 'fire_extinguisher', 'fire extinguishers', 'fire_safety', ARRAY['Zurich Real Estate Policy Wording.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('b4309533-3440-42a5-af98-2e90a6adc1d4', '355128d6-4439-41b8-8979-640037f68e02', 'communal_aerial', 'satellite dishes', 'other', ARRAY['Zurich Real Estate Policy Wording.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('65b9abc4-f2d5-4d6b-8c8e-6333461edf29', '355128d6-4439-41b8-8979-640037f68e02', 'water_tank', 'water tanks', 'water_safety', ARRAY['Zurich Real Estate Policy Wording.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('b3bee753-a1a7-4256-8841-88c288c626fd', '355128d6-4439-41b8-8979-640037f68e02', 'lift', 'Lift', 'lifts_safety', ARRAY['StG_Certificate_32-34 Connaught Square W2 2HL.pdf']);

-- Insert 22 maintenance schedules
INSERT INTO maintenance_schedules (id, building_id, contract_id, service_type, description, frequency, frequency_interval, next_due_date, estimated_duration, priority, status) VALUES ('a2646fe9-e188-49f2-ae99-466a98736a0c', '355128d6-4439-41b8-8979-640037f68e02', '1dcbebad-beee-444f-9cc3-083abd80f8b1', 'lifts', 'lifts - ISS', 'monthly', '1 month', '2025-11-09', '4 hours', 'high', 'scheduled');
INSERT INTO maintenance_schedules (id, building_id, contract_id, service_type, description, frequency, frequency_interval, next_due_date, estimated_duration, priority, status) VALUES ('974af462-9f14-4735-a014-b21192b431c7', '355128d6-4439-41b8-8979-640037f68e02', 'ba88a564-0565-449a-b2d4-f7d270925778', 'security', 'security - ISS', 'quarterly', '3 months', '2026-01-09', '8 hours', 'medium', 'scheduled');
INSERT INTO maintenance_schedules (id, building_id, contract_id, service_type, description, frequency, frequency_interval, next_due_date, estimated_duration, priority, status) VALUES ('3242fdde-4c8e-46be-93fa-4a0875abc9ef', '355128d6-4439-41b8-8979-640037f68e02', 'c15522e3-952b-4542-81ef-ee1f9533dcef', 'security', 'security - ISS', 'quarterly', '3 months', '2026-01-09', '8 hours', 'medium', 'scheduled');
INSERT INTO maintenance_schedules (id, building_id, contract_id, service_type, description, frequency, frequency_interval, next_due_date, estimated_duration, priority, status) VALUES ('0da312b3-8163-4b2c-b1b3-8a666419e13b', '355128d6-4439-41b8-8979-640037f68e02', 'd1963503-3242-4568-bca6-fc495591715f', 'lifts', 'lifts - ISS', 'monthly', '1 month', '2025-11-09', '4 hours', 'high', 'scheduled');
INSERT INTO maintenance_schedules (id, building_id, contract_id, service_type, description, frequency, frequency_interval, next_due_date, estimated_duration, priority, status) VALUES ('abaf4890-752a-4453-898a-3fa400395cbe', '355128d6-4439-41b8-8979-640037f68e02', '85243a63-af4a-4929-b7b0-5c142ccd96da', 'lifts', 'lifts - ISS', 'monthly', '1 month', '2025-11-09', '4 hours', 'high', 'scheduled');
INSERT INTO maintenance_schedules (id, building_id, contract_id, service_type, description, frequency, frequency_interval, next_due_date, estimated_duration, priority, status) VALUES ('06d6ca50-7e60-44b5-a8cb-f949ddfaeacf', '355128d6-4439-41b8-8979-640037f68e02', '82d250e1-7f51-4877-8c11-dd5146a89fb1', 'lifts', 'lifts - ISS', 'monthly', '1 month', '2025-11-09', '4 hours', 'high', 'scheduled');
INSERT INTO maintenance_schedules (id, building_id, contract_id, service_type, description, frequency, frequency_interval, next_due_date, estimated_duration, priority, status) VALUES ('188461ed-f59a-44fd-87f0-92640f31a0d1', '355128d6-4439-41b8-8979-640037f68e02', 'c1d9e78d-d966-4b9f-804f-c335550d3a90', 'lifts', 'lifts - ISS', 'monthly', '1 month', '2025-11-09', '4 hours', 'high', 'scheduled');
INSERT INTO maintenance_schedules (id, building_id, contract_id, service_type, description, frequency, frequency_interval, next_due_date, estimated_duration, priority, status) VALUES ('1716bcd8-6aa0-4f04-9f1a-df5f3320c9ec', '355128d6-4439-41b8-8979-640037f68e02', '09e60b8a-3567-4e65-be98-8276ddadd6ea', 'lifts', 'lifts - ISS', 'annual', '12 months', '2026-03-14', '4 hours', 'high', 'scheduled');
INSERT INTO maintenance_schedules (id, building_id, contract_id, service_type, description, frequency, frequency_interval, next_due_date, estimated_duration, priority, status) VALUES ('a0fd2e0a-b14b-47d0-8630-da8f8be5e416', '355128d6-4439-41b8-8979-640037f68e02', 'd8300e4c-f8b7-4fc9-a47b-05d0281f94ad', 'lifts', 'lifts - None', 'monthly', '1 month', '2025-02-13', '4 hours', 'high', 'scheduled');
INSERT INTO maintenance_schedules (id, building_id, contract_id, description, frequency, frequency_interval, next_due_date, priority, status) VALUES ('0197fddf-f39c-4c1e-8740-4e8674515359', '355128d6-4439-41b8-8979-640037f68e02', 'c3efc332-711f-41a1-90bc-e578c9459be7', 'None - WHM', 'monthly', '1 month', '2025-11-09', 'medium', 'scheduled');
INSERT INTO maintenance_schedules (id, building_id, contract_id, description, frequency, frequency_interval, next_due_date, priority, status) VALUES ('6025c1b1-672a-425d-bcaf-8bcf91b03429', '355128d6-4439-41b8-8979-640037f68e02', '324e7718-994c-40bb-97b4-17f32d63365d', 'None - WHM', 'monthly', '1 month', '2025-11-09', 'medium', 'scheduled');
INSERT INTO maintenance_schedules (id, building_id, contract_id, description, frequency, frequency_interval, next_due_date, priority, status) VALUES ('dbeb66fb-c678-4677-af54-fa999e4073a1', '355128d6-4439-41b8-8979-640037f68e02', '1725d31d-47dd-4baf-8a75-14479d531143', 'None - WHM', 'monthly', '1 month', '2025-11-09', 'medium', 'scheduled');
INSERT INTO maintenance_schedules (id, building_id, contract_id, description, frequency, frequency_interval, next_due_date, priority, status) VALUES ('7b7c502c-972c-4571-a360-b234e6ef097e', '355128d6-4439-41b8-8979-640037f68e02', '4dee083c-6aab-4dd9-b04b-04bb35be6f67', 'None - WHM', 'monthly', '1 month', '2025-11-09', 'medium', 'scheduled');
INSERT INTO maintenance_schedules (id, building_id, contract_id, service_type, description, frequency, frequency_interval, next_due_date, estimated_duration, priority, status) VALUES ('f979ebd7-fe90-442f-89fc-e48a7b604e15', '355128d6-4439-41b8-8979-640037f68e02', 'f781c9ce-b787-4ff0-947b-f4f2ddfd0623', 'security', 'security - Capita', 'monthly', '1 month', '2025-11-09', '8 hours', 'medium', 'scheduled');
INSERT INTO maintenance_schedules (id, building_id, contract_id, service_type, description, frequency, frequency_interval, next_due_date, estimated_duration, priority, status) VALUES ('e4951696-564d-489e-8977-1a39f4d7ff9e', '355128d6-4439-41b8-8979-640037f68e02', '1e7d8d39-6415-4e77-b46b-02311a1aa406', 'fire_alarm', 'fire_alarm - Capita', 'monthly', '1 month', '2025-11-09', '2 hours', 'high', 'scheduled');
INSERT INTO maintenance_schedules (id, building_id, contract_id, service_type, description, frequency, frequency_interval, next_due_date, estimated_duration, priority, status) VALUES ('582b019f-e784-4a19-9fd8-9b22f60578b3', '355128d6-4439-41b8-8979-640037f68e02', '43464c4c-60af-4f3e-8640-9cf4f6368517', 'fire_alarm', 'fire_alarm - None', 'monthly', '1 month', '2025-11-09', '2 hours', 'high', 'scheduled');
INSERT INTO maintenance_schedules (id, building_id, contract_id, service_type, description, frequency, frequency_interval, next_due_date, estimated_duration, priority, status) VALUES ('f3aaef12-23db-49af-9f24-927298232cb3', '355128d6-4439-41b8-8979-640037f68e02', '2e1d8158-3ed4-4ac7-9295-45b23406c091', 'fire_alarm', 'fire_alarm - None', 'monthly', '1 month', '2025-11-09', '2 hours', 'high', 'scheduled');
INSERT INTO maintenance_schedules (id, building_id, contract_id, service_type, description, frequency, frequency_interval, next_due_date, estimated_duration, priority, status) VALUES ('1daf319d-bdbb-45c1-a1c7-220cf85aed48', '355128d6-4439-41b8-8979-640037f68e02', 'b369e024-60e1-4b3a-983b-9bff0fbafcc2', 'fire_alarm', 'fire_alarm - None', 'monthly', '1 month', '2025-11-09', '2 hours', 'high', 'scheduled');
INSERT INTO maintenance_schedules (id, building_id, contract_id, description, frequency, frequency_interval, next_due_date, priority, status) VALUES ('0511b9aa-2af0-4a36-8ccd-3b853bd5d52f', '355128d6-4439-41b8-8979-640037f68e02', '25e10782-b97b-472c-9a80-25a927994aea', 'None - WHM', 'monthly', '1 month', '2025-11-09', 'medium', 'scheduled');
INSERT INTO maintenance_schedules (id, building_id, contract_id, description, frequency, frequency_interval, next_due_date, priority, status) VALUES ('a4b3f5e6-672b-4d90-bc74-a69e3777ffc0', '355128d6-4439-41b8-8979-640037f68e02', 'a0cde4a6-7841-475f-8833-d2f3c97bef6e', 'None - None', 'monthly', '1 month', '2025-11-09', 'medium', 'scheduled');
INSERT INTO maintenance_schedules (id, building_id, contract_id, description, frequency, frequency_interval, next_due_date, priority, status) VALUES ('ccf0f30f-82c7-47d6-9105-0ac406dfc94b', '355128d6-4439-41b8-8979-640037f68e02', '79b0414a-4fa2-4cd4-a4c7-d8f5efcf6946', 'None - None', 'monthly', '1 month', '2025-11-09', 'medium', 'scheduled');
INSERT INTO maintenance_schedules (id, building_id, contract_id, description, frequency, frequency_interval, next_due_date, priority, status) VALUES ('4203e169-9b31-40e9-94ae-3b61b7852c26', '355128d6-4439-41b8-8979-640037f68e02', '95a6c3f4-7808-4f65-bc04-f9274c013e6b', 'None - None', 'monthly', '1 month', '2025-11-09', 'medium', 'scheduled');

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
    '73e0a866-bd35-4f0e-aef8-486b1ea3ef6a',
    '355128d6-4439-41b8-8979-640037f68e02',
    '508029aa-cc41-48bc-a65f-fa1e48619501',
    'Unknown',
    'service_charge',
    NULL  -- Requires manual entry
)
ON CONFLICT (id) DO NOTHING;

-- Fallback budget for unstructured PDF
INSERT INTO budgets (id, building_id, document_id, period, budget_type, total_amount)
VALUES (
    'fa4cbb4a-3007-4eec-8e03-5c92a0fd27f1',
    '355128d6-4439-41b8-8979-640037f68e02',
    '03106a34-0937-468e-b178-38914a5513d7',
    'Unknown',
    'service_charge',
    NULL  -- Requires manual entry
)
ON CONFLICT (id) DO NOTHING;

-- Fallback budget for unstructured PDF
INSERT INTO budgets (id, building_id, document_id, period, budget_type, total_amount)
VALUES (
    '70fd2bb6-900b-4154-808e-c97df84f23ee',
    '355128d6-4439-41b8-8979-640037f68e02',
    '47c6d61e-1d1e-4674-9716-379c21a07236',
    'Unknown',
    'service_charge',
    NULL  -- Requires manual entry
)
ON CONFLICT (id) DO NOTHING;

-- Fallback budget for unstructured PDF
INSERT INTO budgets (id, building_id, document_id, period, budget_type, total_amount)
VALUES (
    '868ddeef-3805-4f17-b6fb-47fb157748a9',
    '355128d6-4439-41b8-8979-640037f68e02',
    'a6760db5-083b-47e1-bfc3-3c34917e7211',
    'Unknown',
    'service_charge',
    NULL  -- Requires manual entry
)
ON CONFLICT (id) DO NOTHING;

-- Fallback budget for unstructured PDF
INSERT INTO budgets (id, building_id, document_id, period, budget_type, total_amount)
VALUES (
    'be0cce5b-44a5-4396-aaf5-c885c2790e9e',
    '355128d6-4439-41b8-8979-640037f68e02',
    '4af2f099-3af6-4be6-ad35-4e109ed34e01',
    '2025',
    'service_charge',
    NULL  -- Requires manual entry
)
ON CONFLICT (id) DO NOTHING;

-- Fallback budget for unstructured PDF
INSERT INTO budgets (id, building_id, document_id, period, budget_type, total_amount)
VALUES (
    '3229c03b-f5b4-4cdc-8caf-6db227c2b756',
    '355128d6-4439-41b8-8979-640037f68e02',
    '8c8bc444-a8d2-4566-b112-abb4b05cc5be',
    '2025',
    'service_charge',
    NULL  -- Requires manual entry
)
ON CONFLICT (id) DO NOTHING;

-- Fallback budget for unstructured PDF
INSERT INTO budgets (id, building_id, document_id, period, budget_type, total_amount)
VALUES (
    '3568f454-7d47-46cd-b4a1-59bfa28d13c9',
    '355128d6-4439-41b8-8979-640037f68e02',
    '7045bbf8-3140-40a6-acdb-f061b4a7c506',
    '2025',
    'service_charge',
    NULL  -- Requires manual entry
)
ON CONFLICT (id) DO NOTHING;

-- Fallback budget for unstructured PDF
INSERT INTO budgets (id, building_id, document_id, period, budget_type, total_amount)
VALUES (
    'e4e2bf6a-ce24-424f-8727-3cb5e67c148b',
    '355128d6-4439-41b8-8979-640037f68e02',
    '177ab854-b370-4af0-b90f-0a98088de8e0',
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
    'b72ad23a-5523-4d60-bdf1-35f609185587',
    '355128d6-4439-41b8-8979-640037f68e02',
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
    '384ef776-e6ad-4d88-bcf9-c12a46db1b31',
    '355128d6-4439-41b8-8979-640037f68e02',
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
    'dec7fac0-0100-4661-9dab-c9ed16ee5694',
    '355128d6-4439-41b8-8979-640037f68e02',
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
    '3c345a9b-4e5a-4010-8aa1-d9c55c12dfce',
    '355128d6-4439-41b8-8979-640037f68e02',
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
    'c78f8414-39a7-4c3f-8697-c0f503c45ce8',
    '355128d6-4439-41b8-8979-640037f68e02',
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
    '9b834b3b-ff19-420a-86fc-ef097e483682',
    '355128d6-4439-41b8-8979-640037f68e02',
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
    'bfd90ddb-10a4-4802-b03e-7d37b0c08e75',
    '355128d6-4439-41b8-8979-640037f68e02',
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
    '0b53d620-6a50-4cdc-ba97-d9d21a905e19',
    '355128d6-4439-41b8-8979-640037f68e02',
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
    'f9651d2e-1ad6-45dc-baf4-9b65cc4bd7a1',
    '355128d6-4439-41b8-8979-640037f68e02',
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
    '8bd3a710-0e3b-4656-b251-831cf88aade6',
    '355128d6-4439-41b8-8979-640037f68e02',
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
    '7f874a17-877c-4a88-a522-84cea64d46c2',
    '355128d6-4439-41b8-8979-640037f68e02',
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
    'b5ccd913-b419-4267-b132-7d1557bc638c',
    '355128d6-4439-41b8-8979-640037f68e02',
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
    '3d7647ce-2864-439c-8ccf-4c1a0114d2d2',
    '355128d6-4439-41b8-8979-640037f68e02',
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
    '35e42d17-3931-45b4-983d-7b50ea4dffc5',
    '355128d6-4439-41b8-8979-640037f68e02',
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
    'fb4807a5-56d6-402f-adb8-07677479d40b',
    '355128d6-4439-41b8-8979-640037f68e02',
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
    '609e631f-9666-418a-ae93-bfd2ebb8d5da',
    '355128d6-4439-41b8-8979-640037f68e02',
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
    'eb9b24e9-9266-4d6f-b905-9f03bfde2bcd',
    '355128d6-4439-41b8-8979-640037f68e02',
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
    '38369312-b58e-442d-b5ca-bb00719fd9ab',
    '355128d6-4439-41b8-8979-640037f68e02',
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
    '6b79aec6-4408-4197-ba6b-edd167647098',
    '355128d6-4439-41b8-8979-640037f68e02',
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
    '33f14d61-796a-4503-8797-5d768a958740',
    '355128d6-4439-41b8-8979-640037f68e02',
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
    '9b3216e4-3742-461b-9667-2d736edca55a',
    '355128d6-4439-41b8-8979-640037f68e02',
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
    '8bb0200f-78d7-49c5-a684-ead1f4e418ab',
    '355128d6-4439-41b8-8979-640037f68e02',
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
    'b67f131a-6817-4445-a206-f1ed018ef436',
    '355128d6-4439-41b8-8979-640037f68e02',
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
    '779b33fc-03af-4c10-bef1-288ecaebc239',
    '355128d6-4439-41b8-8979-640037f68e02',
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
    '59b8a08c-3ef8-4c83-bae1-47bf379d8f22',
    '355128d6-4439-41b8-8979-640037f68e02',
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
    '38496f04-643b-4f94-a134-ee19275c36c2',
    '355128d6-4439-41b8-8979-640037f68e02',
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
    'fbbdae4f-f853-49ef-9df6-3594a45beeb9',
    '355128d6-4439-41b8-8979-640037f68e02',
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
    'a16c8135-dfd6-4741-829f-96cdfabb54a4',
    '355128d6-4439-41b8-8979-640037f68e02',
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
    '99e25eb3-fef8-4114-964c-8ebd59fff4ca',
    '355128d6-4439-41b8-8979-640037f68e02',
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
    '315ba67f-54af-4699-b1db-a838c122eb42',
    '355128d6-4439-41b8-8979-640037f68e02',
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
    'a227b27a-18e9-4d48-9e5e-2ee9c1a1457c',
    '355128d6-4439-41b8-8979-640037f68e02',
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
    'ac5c4be6-7c64-41a4-a409-e619a3a1a1e2',
    '355128d6-4439-41b8-8979-640037f68e02',
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
    'fcf308a7-92e8-49c1-ac8f-6d731a8e9548',
    '355128d6-4439-41b8-8979-640037f68e02',
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
    '24424df2-1874-4af5-aa85-eca80be57b51',
    '355128d6-4439-41b8-8979-640037f68e02',
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
    'acfe0415-3580-4de8-86f8-fb3bbf6bf73c',
    '355128d6-4439-41b8-8979-640037f68e02',
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
    '93771cf8-87a6-43e3-8cfb-294cec845326',
    '355128d6-4439-41b8-8979-640037f68e02',
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
    '673691de-a7c5-4abe-b306-f9f566ca13d0',
    '355128d6-4439-41b8-8979-640037f68e02',
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
    'f6d5ff24-7ab8-4116-8929-1f70e681270f',
    '355128d6-4439-41b8-8979-640037f68e02',
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
    'b1c3002f-702f-446c-ab78-18d84b697e1d',
    '355128d6-4439-41b8-8979-640037f68e02',
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
    'c0a9b139-e0e0-4664-bacc-839204102636',
    '355128d6-4439-41b8-8979-640037f68e02',
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
    '85992b7c-c93f-41ac-baa7-37c8894d06c0',
    '355128d6-4439-41b8-8979-640037f68e02',
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
    '3e961040-543c-4273-979d-e5f6ab6de7cf',
    '355128d6-4439-41b8-8979-640037f68e02',
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
    '715c8adb-a723-41cc-b0ca-a38f32748c20',
    '355128d6-4439-41b8-8979-640037f68e02',
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
    '996224de-4ccd-4b78-93a5-167543e3a734',
    '355128d6-4439-41b8-8979-640037f68e02',
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
    'a0be58ff-48b2-480e-a002-2fb127ece2e1',
    '355128d6-4439-41b8-8979-640037f68e02',
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
    '33261157-a0dc-414e-bfd4-a3fcd23c2627',
    '355128d6-4439-41b8-8979-640037f68e02',
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
    '1d9e2531-6996-4d34-9336-8794e6075938',
    '355128d6-4439-41b8-8979-640037f68e02',
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
    '7a8cb4e5-6229-4e9a-9575-507533803fd4',
    '355128d6-4439-41b8-8979-640037f68e02',
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
    'ccbc5b63-78e8-4112-9998-559411d5a5d7',
    '355128d6-4439-41b8-8979-640037f68e02',
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
    'f9ce85fe-f9b6-463a-a8dd-b86cdafd9b5a',
    '355128d6-4439-41b8-8979-640037f68e02',
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
    '7bc26c33-4aac-499d-88b8-c1dc936ea32f',
    '355128d6-4439-41b8-8979-640037f68e02',
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
    '70b73069-bf8f-4ed4-be31-de64b3a9802a',
    '355128d6-4439-41b8-8979-640037f68e02',
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
    '2f73ef59-d4dc-4f4c-8994-31c0b5ae4ce4',
    '355128d6-4439-41b8-8979-640037f68e02',
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
    'bf57dc52-e51d-4d8b-96fb-27ba14d9b41c',
    '355128d6-4439-41b8-8979-640037f68e02',
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
    'e1658af7-ea46-4ae3-9efb-e20d4ac918af',
    '355128d6-4439-41b8-8979-640037f68e02',
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
    '36d16668-a2af-4d57-ba11-0e5e30d6e668',
    '355128d6-4439-41b8-8979-640037f68e02',
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
    '83847645-d527-4567-acee-e26f052144eb',
    '355128d6-4439-41b8-8979-640037f68e02',
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
    'e9270f95-bd8b-473f-87fa-500a5696c45f',
    '355128d6-4439-41b8-8979-640037f68e02',
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
    '66fac24f-70a2-49dc-baaa-dfe0e19253b8',
    '355128d6-4439-41b8-8979-640037f68e02',
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
    'cfc51f8b-404c-4002-a697-e8792df7949f',
    '355128d6-4439-41b8-8979-640037f68e02',
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
    '4179be55-248c-4e4c-9799-ccd4425eab9a',
    '355128d6-4439-41b8-8979-640037f68e02',
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
    '0f944223-9941-4052-894c-425a8830ce15',
    '355128d6-4439-41b8-8979-640037f68e02',
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
    '78eef62d-d7ce-4b94-890d-ac31edabe5b9',
    '355128d6-4439-41b8-8979-640037f68e02',
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
    'acadead6-cc1f-4831-aa49-4c5a5c02ce3d',
    '355128d6-4439-41b8-8979-640037f68e02',
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
    '3a277982-34bb-4789-8ddb-27453741d18f',
    '355128d6-4439-41b8-8979-640037f68e02',
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
    'da45de6d-9067-4362-ac31-d418dd40d3ea',
    '355128d6-4439-41b8-8979-640037f68e02',
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
    '54da7fec-bd9c-4fdf-ab01-c4673460aeed',
    '355128d6-4439-41b8-8979-640037f68e02',
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
    '7f37659a-c29c-4075-af1c-bcb60726fb8f',
    '355128d6-4439-41b8-8979-640037f68e02',
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
    '9e141e56-035c-4659-bbff-58b53f3c30b2',
    '355128d6-4439-41b8-8979-640037f68e02',
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
    'cc5ca696-f73a-41e9-a9aa-ab135a23d9e9',
    '355128d6-4439-41b8-8979-640037f68e02',
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
    '56bbf6fd-00cb-424d-afd1-fa9e2cfe2cf1',
    '355128d6-4439-41b8-8979-640037f68e02',
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
    '2a87cbc3-bbdb-470b-a961-c04a1fda454d',
    '355128d6-4439-41b8-8979-640037f68e02',
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
    'a706ede5-1607-442b-ac96-c8f1f47ab9ce',
    '355128d6-4439-41b8-8979-640037f68e02',
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
    '2fabcb1f-fcc2-49ac-9d52-a53f6101b8bd',
    '355128d6-4439-41b8-8979-640037f68e02',
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
    '66e605f8-db05-4e9d-91e3-cb7b6811c9d3',
    '355128d6-4439-41b8-8979-640037f68e02',
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
    'ff4d4716-0b02-4ce6-9873-164961cb57d9',
    '355128d6-4439-41b8-8979-640037f68e02',
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
    '05ee3823-ef07-462a-9767-ffb069807545',
    '355128d6-4439-41b8-8979-640037f68e02',
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
    'e6b4c3c2-06ec-4fbd-9dd1-31a921d6280c',
    '355128d6-4439-41b8-8979-640037f68e02',
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
    'a967ee67-248f-4121-88d9-9414cd3052af',
    '355128d6-4439-41b8-8979-640037f68e02',
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
    'f17ee94d-ab57-4a31-afa7-6faa90361bd6',
    '355128d6-4439-41b8-8979-640037f68e02',
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
    'b89d0b1a-2c70-4d35-bebd-48e6f0cfc3cb',
    '355128d6-4439-41b8-8979-640037f68e02',
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
    '9019d513-914a-4953-8a39-8b9822374189',
    '355128d6-4439-41b8-8979-640037f68e02',
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
    '98488a35-68c8-4d08-a3e4-74a9dc317a07',
    '355128d6-4439-41b8-8979-640037f68e02',
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
    '22e6f0f7-dbd9-43f8-ad77-cbb7b88be69e',
    '355128d6-4439-41b8-8979-640037f68e02',
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
    'aab2759d-95fb-4339-9753-229665a6be90',
    '355128d6-4439-41b8-8979-640037f68e02',
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
    'c8cedb84-877e-4f5c-85fa-987a0e9dc5ea',
    '355128d6-4439-41b8-8979-640037f68e02',
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
    'd4b23199-5ec3-4677-aefa-9d1a8434289b',
    '355128d6-4439-41b8-8979-640037f68e02',
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
    '5f729f56-cb0c-4fd3-96cd-369b62323c54',
    '355128d6-4439-41b8-8979-640037f68e02',
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
    '79791fdc-3f0a-4513-9942-b5a76a56349a',
    '355128d6-4439-41b8-8979-640037f68e02',
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
    'db3654c5-8e2f-4f4d-9526-9d282e606834',
    '355128d6-4439-41b8-8979-640037f68e02',
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
    '1ebf509e-2d3d-4ed0-a5ac-955ee66d96db',
    '355128d6-4439-41b8-8979-640037f68e02',
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
    '9fa8a399-de0f-407c-92be-9e4e54be8040',
    '355128d6-4439-41b8-8979-640037f68e02',
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
    'fb1c62ed-3107-4904-a1d4-0118d5b41bfd',
    '355128d6-4439-41b8-8979-640037f68e02',
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
    '919ae016-f3dd-4c44-923a-d03c2d69adbe',
    '355128d6-4439-41b8-8979-640037f68e02',
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
    '550ca686-286d-4db4-af28-b1a13c3c2184',
    '355128d6-4439-41b8-8979-640037f68e02',
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
    '33e48041-8653-4609-97a1-d73ed4837876',
    '355128d6-4439-41b8-8979-640037f68e02',
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
    'e0a503ca-83e7-484b-9fdc-39d2c899f481',
    '355128d6-4439-41b8-8979-640037f68e02',
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
    'ce5617a8-49d5-44e8-81ba-61abc34e9807',
    '355128d6-4439-41b8-8979-640037f68e02',
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
    '6fc61ecd-6485-4dd5-9484-ab76e6b7c62c',
    '355128d6-4439-41b8-8979-640037f68e02',
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
    'ca12b3f9-be1f-4bcb-99a3-647769fe951e',
    '355128d6-4439-41b8-8979-640037f68e02',
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
    '06fa5102-4ce8-4bf1-b07b-219613aac887',
    '355128d6-4439-41b8-8979-640037f68e02',
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
    '8d2e70c8-6a3e-4342-ab30-fbb43db5493c',
    '355128d6-4439-41b8-8979-640037f68e02',
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
    'ecc0c5fc-ba32-410f-9957-015dc0aa4e5c',
    '355128d6-4439-41b8-8979-640037f68e02',
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
    '0bdc316f-8afc-4cc4-bae1-49acb4bcdac7',
    '355128d6-4439-41b8-8979-640037f68e02',
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
    'afea359c-84ac-41cc-be3f-734ca81de38e',
    '355128d6-4439-41b8-8979-640037f68e02',
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
    '371a7b47-b085-45df-b325-ee18ef788efe',
    '355128d6-4439-41b8-8979-640037f68e02',
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
    '422152bb-428e-4ce1-bfb1-0ce801e39bd8',
    '355128d6-4439-41b8-8979-640037f68e02',
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
    '3c02465d-38de-4d75-83f7-719f20308c92',
    '355128d6-4439-41b8-8979-640037f68e02',
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
    'd0fad51a-c7c5-4b8f-bb96-a68aa6e71f82',
    '355128d6-4439-41b8-8979-640037f68e02',
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
    '0d5b09ae-ee60-404d-add8-6c4da5ae5721',
    '355128d6-4439-41b8-8979-640037f68e02',
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
    '2f5f3012-ab42-4b77-a5ce-36191750ed31',
    '355128d6-4439-41b8-8979-640037f68e02',
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
    'eaff0dff-419c-4434-8d59-8a024599c2db',
    '355128d6-4439-41b8-8979-640037f68e02',
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
    'b37c4185-ce06-4583-bce0-ae1cd4f4cb70',
    '355128d6-4439-41b8-8979-640037f68e02',
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
    'fe053698-a5ea-4877-af25-bbcae66e131f',
    '355128d6-4439-41b8-8979-640037f68e02',
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
    '4a82c42e-a747-4781-9530-f40fe9aa58f9',
    '355128d6-4439-41b8-8979-640037f68e02',
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
    'a9dc7f5a-6625-423a-8a92-32bcc80e956d',
    '355128d6-4439-41b8-8979-640037f68e02',
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
    '51aa6098-e301-4620-8de0-0bb573e7dff2',
    '355128d6-4439-41b8-8979-640037f68e02',
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
    '838de7f7-b7e4-4adc-a88c-1eaa0298497f',
    '355128d6-4439-41b8-8979-640037f68e02',
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
    'e849fef3-db77-4268-a5be-0f6d93e0d1f5',
    '355128d6-4439-41b8-8979-640037f68e02',
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
    '92034394-8eff-4340-af16-362ae400b245',
    '355128d6-4439-41b8-8979-640037f68e02',
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
    'ddc00335-e3a2-4aff-89ba-0c92aedff08b',
    '355128d6-4439-41b8-8979-640037f68e02',
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
    'd9f0da48-fd8c-4a5e-8f23-48292d542766',
    '355128d6-4439-41b8-8979-640037f68e02',
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
    'b87f1460-acac-41f3-9a22-e18c6307bad2',
    '355128d6-4439-41b8-8979-640037f68e02',
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
    '7c9cb186-b254-4041-ba7f-f200cf0ebbe0',
    '355128d6-4439-41b8-8979-640037f68e02',
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
    'ab68c92b-d62e-45e7-8c2c-d85f1832d560',
    '355128d6-4439-41b8-8979-640037f68e02',
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
    '40788be5-d69e-4ef9-9200-4978d194d85c',
    '355128d6-4439-41b8-8979-640037f68e02',
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
    'e5248bec-34cb-4fd1-8ad9-23b8d5a108bc',
    '355128d6-4439-41b8-8979-640037f68e02',
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
    'b61b8f8e-2791-41dd-953a-2f6c6bb59079',
    '355128d6-4439-41b8-8979-640037f68e02',
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
    '88e87c21-23c5-453e-802b-41ca9eb27e8a',
    '355128d6-4439-41b8-8979-640037f68e02',
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
    '92d34ce9-e8f8-478f-97e3-e2f44c9d8d8a',
    '355128d6-4439-41b8-8979-640037f68e02',
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
    'ef6d8d60-03b2-4854-bb56-afa785985119',
    '355128d6-4439-41b8-8979-640037f68e02',
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
    'e03bd2bc-1122-4657-88bf-79358ee2d6c6',
    '355128d6-4439-41b8-8979-640037f68e02',
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
    '3be0eb3e-c47d-4047-b628-9dd9d8857f4d',
    '355128d6-4439-41b8-8979-640037f68e02',
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
    '8cadbc91-19b7-4a92-93ee-395237a35eca',
    '355128d6-4439-41b8-8979-640037f68e02',
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
    '93c8b6a2-1c38-49df-9f0f-15a3ce9f25cd',
    '355128d6-4439-41b8-8979-640037f68e02',
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
    '18bc106e-d901-44a1-8bce-854b17bd3c44',
    '355128d6-4439-41b8-8979-640037f68e02',
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
    'd4c09613-0a99-49b9-8c33-d112c24628bb',
    '355128d6-4439-41b8-8979-640037f68e02',
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
    '110a7ea0-1da4-4087-adb8-8bbcf143f1c3',
    '355128d6-4439-41b8-8979-640037f68e02',
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
    '8d995187-bb2f-4fda-8abd-15ea74212ce4',
    '355128d6-4439-41b8-8979-640037f68e02',
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
    '2a337603-e3dd-4581-afc2-330ecb2cd1e1',
    '355128d6-4439-41b8-8979-640037f68e02',
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
    '22399881-bd4b-4851-ba1f-64fc9d54bcbc',
    '355128d6-4439-41b8-8979-640037f68e02',
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
    '282f0f65-a5ea-4ea3-b295-46b8b5d58e5c',
    '355128d6-4439-41b8-8979-640037f68e02',
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
    'c8192fe0-c573-45e5-a058-197b5d47101c',
    '355128d6-4439-41b8-8979-640037f68e02',
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
    '1af31ac5-9a35-4e95-af01-ba072102847d',
    '355128d6-4439-41b8-8979-640037f68e02',
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
    '24a86df5-afee-43a0-ae73-f3c659377e01',
    '355128d6-4439-41b8-8979-640037f68e02',
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
    'e9dc0560-0f3e-40aa-87ee-c110d7d699f2',
    '355128d6-4439-41b8-8979-640037f68e02',
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
    '58552f37-9fad-4e21-ab2a-c1f5e5ce3626',
    '355128d6-4439-41b8-8979-640037f68e02',
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
    '986f56d9-aa93-4dae-ba7d-af13b912b2a0',
    '355128d6-4439-41b8-8979-640037f68e02',
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
    '914b5d92-0b9c-4012-9e69-531b6e8f238e',
    '355128d6-4439-41b8-8979-640037f68e02',
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
    '38629189-f4d1-4401-adb3-aa2cd3aafeee',
    '355128d6-4439-41b8-8979-640037f68e02',
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
    '6c329ee7-647e-4a7a-9386-19705c452bc3',
    '355128d6-4439-41b8-8979-640037f68e02',
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
    'b89688e3-8f48-4aea-9b24-3a3a6f0c5ccf',
    '355128d6-4439-41b8-8979-640037f68e02',
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
    '55ea5352-2c88-4bce-8cc8-9000fb5afb65',
    '355128d6-4439-41b8-8979-640037f68e02',
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
    '3a185aa1-815f-4f67-b8d7-290caf0899ee',
    '355128d6-4439-41b8-8979-640037f68e02',
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
    '8d16d6c5-b795-4439-a969-dded6d139b2e',
    '355128d6-4439-41b8-8979-640037f68e02',
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
    'f7397771-98a4-4c7d-bcfb-027edd3acccf',
    '355128d6-4439-41b8-8979-640037f68e02',
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
    'ebee9bd3-5c21-4d31-9a9e-f21a827179ef',
    '355128d6-4439-41b8-8979-640037f68e02',
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
    '4b5c00ce-e1b1-412e-8b4c-672813782a70',
    '355128d6-4439-41b8-8979-640037f68e02',
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
    '9a79b590-8509-4066-9347-b5a90f0056da',
    '355128d6-4439-41b8-8979-640037f68e02',
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
    '56307cf9-2565-45af-9489-99102629abf1',
    '355128d6-4439-41b8-8979-640037f68e02',
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
    '5d35d0b6-617e-44bb-8087-3dc8ac17efdf',
    '355128d6-4439-41b8-8979-640037f68e02',
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
    'e0f979ae-f7ad-4e24-a6b8-45e7ad950528',
    '355128d6-4439-41b8-8979-640037f68e02',
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
    '185d0391-cc45-459a-a3f4-9bec7fcf403c',
    '355128d6-4439-41b8-8979-640037f68e02',
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
    'f0e54da7-23d3-4626-9077-eebff0288a5d',
    '355128d6-4439-41b8-8979-640037f68e02',
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
    '2bfea816-240e-4d79-8488-1818239fb125',
    '355128d6-4439-41b8-8979-640037f68e02',
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
    'b41a3a05-00e7-4b7e-b799-21f870bd4a9a',
    '355128d6-4439-41b8-8979-640037f68e02',
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
    'c7a8c843-0a98-45d1-b523-07d021055c8d',
    '355128d6-4439-41b8-8979-640037f68e02',
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
    '51a91145-914f-460f-a9a4-5736c6305f58',
    '355128d6-4439-41b8-8979-640037f68e02',
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
    '404345b6-f212-4858-8bd3-7441de9346a7',
    '355128d6-4439-41b8-8979-640037f68e02',
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
    '2d7d6085-261f-41ec-b4b0-c1745ea443bc',
    '355128d6-4439-41b8-8979-640037f68e02',
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
    '0a372df5-0221-4f18-a988-06f0bfe0ba97',
    '355128d6-4439-41b8-8979-640037f68e02',
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
    'bb4b931a-9c47-410d-bd0f-481126d664ba',
    '355128d6-4439-41b8-8979-640037f68e02',
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
    'f78ee496-6b59-4a37-ba7b-30543a023d63',
    '355128d6-4439-41b8-8979-640037f68e02',
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
    'd722d2a0-a22b-47df-b408-cbeb15e6bb59',
    '355128d6-4439-41b8-8979-640037f68e02',
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
    '8cca9c25-50c7-494f-9e11-a2034bf73bdb',
    '355128d6-4439-41b8-8979-640037f68e02',
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
    '094cce1b-34e9-417d-acce-864e197995ec',
    '355128d6-4439-41b8-8979-640037f68e02',
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
    '6dabafbc-fb1b-4cc0-9a19-b968a8f5cdd3',
    '355128d6-4439-41b8-8979-640037f68e02',
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
    '12fbc48b-6108-4f21-962f-bd49a2ff3bcd',
    '355128d6-4439-41b8-8979-640037f68e02',
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
    '6914b8cb-6d1c-44ed-ac73-a6c2eac89b1c',
    '355128d6-4439-41b8-8979-640037f68e02',
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
    '62b19088-6266-4376-a9dc-02ae9e70f91c',
    '355128d6-4439-41b8-8979-640037f68e02',
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
    '021fb4b9-8227-4717-84a2-a73658a6eb1c',
    '355128d6-4439-41b8-8979-640037f68e02',
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
    '5562ac7d-92bb-41fc-9445-6600cb650bdd',
    '355128d6-4439-41b8-8979-640037f68e02',
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
    'f0f16a29-c5d3-4714-917a-124002068a6d',
    '355128d6-4439-41b8-8979-640037f68e02',
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
    'c4fbd738-b2ba-430c-b463-b18297ec8d00',
    '355128d6-4439-41b8-8979-640037f68e02',
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
    '0195eba4-8328-4e3e-bb35-9951c521d855',
    '355128d6-4439-41b8-8979-640037f68e02',
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
    '31e37aa1-86db-4739-b4f4-32dc0738f31e',
    '355128d6-4439-41b8-8979-640037f68e02',
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
    'c58cd940-c376-4ae6-a2ea-09c5f42fb6c7',
    '355128d6-4439-41b8-8979-640037f68e02',
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
    '35d81237-bbce-4897-9885-e5af2fc751a6',
    '355128d6-4439-41b8-8979-640037f68e02',
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
    '7c0aac1c-c901-402e-a924-9a29158fa4ce',
    '355128d6-4439-41b8-8979-640037f68e02',
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
    '55575531-198d-48a0-89a8-c2b9c548b36f',
    '355128d6-4439-41b8-8979-640037f68e02',
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
    '74bb4fa3-9396-4325-a231-57013e8e6b80',
    '355128d6-4439-41b8-8979-640037f68e02',
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
    'e2dff66c-72d9-4b5b-a44e-cc8519a2a871',
    '355128d6-4439-41b8-8979-640037f68e02',
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
    '0efc6353-f6d6-4958-b603-d35ea3c1f11f',
    '355128d6-4439-41b8-8979-640037f68e02',
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
    '7e6f9173-9b4d-4919-9390-1a00846229a7',
    '355128d6-4439-41b8-8979-640037f68e02',
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
    'f42d5a62-40d2-451c-ac24-19883db7ffaf',
    '355128d6-4439-41b8-8979-640037f68e02',
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
    '89bd5f66-1aad-45e3-ac0d-9161db744733',
    '355128d6-4439-41b8-8979-640037f68e02',
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
    '9bf6d654-07b4-4cf1-883d-f6848ff14a1e',
    '355128d6-4439-41b8-8979-640037f68e02',
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
    '08bd0826-cfcc-42fd-a517-544e3638c0fd',
    '355128d6-4439-41b8-8979-640037f68e02',
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
    'b15b815e-3a3e-4d55-946b-3d8ae9323309',
    '355128d6-4439-41b8-8979-640037f68e02',
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
    'f3d34eb5-e197-44cc-a181-34b860533505',
    '355128d6-4439-41b8-8979-640037f68e02',
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
    '3a09b951-eb69-4527-8e5e-e9c12c914ad0',
    '355128d6-4439-41b8-8979-640037f68e02',
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
    '0f59db82-844e-4a91-9a1d-67af39d436bb',
    '355128d6-4439-41b8-8979-640037f68e02',
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
    '9d7e6587-befa-42ff-9a04-9da3ce8b9fc0',
    '355128d6-4439-41b8-8979-640037f68e02',
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
    '8dfd5a9d-b477-4046-92fb-ec9e9558fa1b',
    '355128d6-4439-41b8-8979-640037f68e02',
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
    '3a3fcf03-6215-4508-9e2a-d9bc4d50ef0d',
    '355128d6-4439-41b8-8979-640037f68e02',
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
    '1048aca5-86cd-446d-9815-8a861c8db4a6',
    '355128d6-4439-41b8-8979-640037f68e02',
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
    '403d0e2f-dd64-46b3-a604-4124d7c14d67',
    '355128d6-4439-41b8-8979-640037f68e02',
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
    'bfe33b43-d2c4-484f-89f6-c344b42c76b5',
    '355128d6-4439-41b8-8979-640037f68e02',
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
    '6d5a7048-b330-49a2-af0c-79888b23c700',
    '355128d6-4439-41b8-8979-640037f68e02',
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
    'c21ebf7c-bdfa-4c5d-904b-a13778eb98bd',
    '355128d6-4439-41b8-8979-640037f68e02',
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
    '515fee09-ce76-40bc-9a20-08e6e30d1315',
    '355128d6-4439-41b8-8979-640037f68e02',
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
    '364111a2-08b7-435c-867a-115ce76115e1',
    '355128d6-4439-41b8-8979-640037f68e02',
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
    'c3eccbd1-5172-436a-94e1-8caf82e854dd',
    '355128d6-4439-41b8-8979-640037f68e02',
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
    'f53d5044-095d-4673-a3a4-3f23f5d71078',
    '355128d6-4439-41b8-8979-640037f68e02',
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
    '11d7b8bc-0091-4a00-8fc4-f972902ad509',
    '355128d6-4439-41b8-8979-640037f68e02',
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
    'c2d39420-7150-4591-b1e5-5773f25424a2',
    '355128d6-4439-41b8-8979-640037f68e02',
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
    '17f1264c-26d6-4847-80ca-c439ec0f3d8f',
    '355128d6-4439-41b8-8979-640037f68e02',
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
    '6715d2b2-f649-4653-af04-8952e65d0a04',
    '355128d6-4439-41b8-8979-640037f68e02',
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
    'c9f570d1-1bf0-4611-bdc4-8647a30a0812',
    '355128d6-4439-41b8-8979-640037f68e02',
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
    '1acf503a-9fa8-457e-b52a-1562f265ffad',
    '355128d6-4439-41b8-8979-640037f68e02',
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
    'd35aed8b-d7bd-44b3-9b71-fee29c6dfa27',
    '355128d6-4439-41b8-8979-640037f68e02',
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
    'e50d79de-1583-4479-be82-0aeca487cdbc',
    '355128d6-4439-41b8-8979-640037f68e02',
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
    '10c66d86-a4ab-4594-b952-87af8469524f',
    '355128d6-4439-41b8-8979-640037f68e02',
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
    'e5c1f11f-3aba-4283-bbaf-13e509752133',
    '355128d6-4439-41b8-8979-640037f68e02',
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
    'd0ab2ae8-f16b-4211-8056-0d14a11c6e6e',
    '355128d6-4439-41b8-8979-640037f68e02',
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
    '33361055-b8a9-43b0-ab69-346ba307489e',
    '355128d6-4439-41b8-8979-640037f68e02',
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
    'e23387d5-a916-41c3-bc48-1caa6d6caac4',
    '355128d6-4439-41b8-8979-640037f68e02',
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
    'c2c9f474-3298-4ade-b355-b7211ab399a3',
    '355128d6-4439-41b8-8979-640037f68e02',
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
    '6cac1ddb-c5ed-44f2-b1b7-b53d32a710f7',
    '355128d6-4439-41b8-8979-640037f68e02',
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
    '4acd06ae-af2b-4c94-bf89-799eadb91a75',
    '355128d6-4439-41b8-8979-640037f68e02',
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
    'ee7623f7-2942-4898-afe2-db0814fc97c4',
    '355128d6-4439-41b8-8979-640037f68e02',
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
    '8e77b5ee-daba-4664-b19e-08a36d1c2499',
    '355128d6-4439-41b8-8979-640037f68e02',
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
    'bee09e74-95a8-4d5d-9de3-0db891e6abef',
    '355128d6-4439-41b8-8979-640037f68e02',
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
    '2f4a671d-ae99-4cb7-801d-a919bab91b1e',
    '355128d6-4439-41b8-8979-640037f68e02',
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
    '072f0589-fd5a-40c1-a633-3b088644cf8a',
    '355128d6-4439-41b8-8979-640037f68e02',
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
    '76c7e067-2046-4b65-8ba5-2e9059b0ddb1',
    '355128d6-4439-41b8-8979-640037f68e02',
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
    'e536d856-f278-4c9b-8b04-9e0124e71f8f',
    '355128d6-4439-41b8-8979-640037f68e02',
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
    '200648e5-7759-42b1-865e-d28feb69f7be',
    '355128d6-4439-41b8-8979-640037f68e02',
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
    'adc69d9d-8fe3-4791-a3dd-1dca7570e5aa',
    '355128d6-4439-41b8-8979-640037f68e02',
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
    '1a2014f5-de51-4aae-a973-397054de4615',
    '355128d6-4439-41b8-8979-640037f68e02',
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
    '8f158dcb-5064-474f-8981-b3fb94b43f78',
    '355128d6-4439-41b8-8979-640037f68e02',
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
    'b5a6b085-a0df-4f73-b0ea-d9b613ece6c3',
    '355128d6-4439-41b8-8979-640037f68e02',
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
    '78894032-6526-4ab1-b737-4a4d9e557170',
    '355128d6-4439-41b8-8979-640037f68e02',
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
    'b55285a5-171f-4cb9-b018-c13f50fc448c',
    '355128d6-4439-41b8-8979-640037f68e02',
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
    'bea165f4-5013-452e-af72-051960c9bf34',
    '355128d6-4439-41b8-8979-640037f68e02',
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
    '086e7212-87f6-441b-a015-1bb3c34834c5',
    '355128d6-4439-41b8-8979-640037f68e02',
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
    'c140509b-326b-463c-a397-5dc21297c57a',
    '355128d6-4439-41b8-8979-640037f68e02',
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
    'a3683a5e-d4c5-4169-b623-71b618a74a14',
    '355128d6-4439-41b8-8979-640037f68e02',
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
    '1eef0f44-8072-4678-a414-f8e86e317152',
    '355128d6-4439-41b8-8979-640037f68e02',
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
    '5e6cad5d-9fd1-4fa4-80c5-1a17f8badcd5',
    '355128d6-4439-41b8-8979-640037f68e02',
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
    'ad78f49a-70d0-426b-8655-92a8ab553d5c',
    '355128d6-4439-41b8-8979-640037f68e02',
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
    '54866283-fdd2-47a4-8634-978e4695c490',
    '355128d6-4439-41b8-8979-640037f68e02',
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
    '3e3a0123-d74a-47ab-8d19-0605fbbc4049',
    '355128d6-4439-41b8-8979-640037f68e02',
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
    '6a46f0a8-3e0b-44d3-b167-9e82f27c2a32',
    '355128d6-4439-41b8-8979-640037f68e02',
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
    'e591f0c4-0c4a-4875-9112-12c26cce053c',
    '355128d6-4439-41b8-8979-640037f68e02',
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
    '5c4276cb-0e74-452c-a56c-5eede5654165',
    '355128d6-4439-41b8-8979-640037f68e02',
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
    '8d9c7049-4b7a-4f56-ba6c-edfb993e7d3a',
    '355128d6-4439-41b8-8979-640037f68e02',
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
    '82c8614a-626c-4578-9632-86f1f4741fa1',
    '355128d6-4439-41b8-8979-640037f68e02',
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
    '2ddafdcc-12f6-4043-9250-79102a4f496b',
    '355128d6-4439-41b8-8979-640037f68e02',
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
    'f6419d33-821e-49d6-8f5b-d0de453b0e19',
    '355128d6-4439-41b8-8979-640037f68e02',
    'boiler_location',
    'utilities',
    'Boiler',
    NULL,
    'Gaskets Very Very',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;
