-- ============================================================
-- PATCHED: BlocIQ Onboarder - Auto-generated Migration (Schema-Corrected)
-- Generated at: 2025-10-09T19:55:54.154928
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
INSERT INTO buildings (id, name, address) VALUES ('ee49577b-36b0-4594-8406-65f3fc6c4eef', 'Connaught Square', 'CONNAUGHT SQUARE');

-- Insert 1 schedule(s)
INSERT INTO schedules (id, building_id, name, description) VALUES ('df790d95-6088-4bf7-8a36-0877d0688250', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'Main Schedule', 'Auto-detected schedule from onboarding');
-- Created schedules: Main Schedule

-- Insert 8 units
INSERT INTO units (id, building_id, unit_number) VALUES
('8dc85ff6-155b-43cc-bd6e-7e5e70811d12', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'Flat 1'),
('6ef836eb-316b-4c65-aa59-b8b5a361ee25', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'Flat 2'),
('1ee42f91-eee9-455b-90a4-f31c52af5495', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'Flat 3'),
('d7c90af9-0e68-46d1-a9b3-06cc80ed2620', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'Flat 4'),
('5723550b-5c34-45df-aaa6-6d4d747e4ecd', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'Flat 5'),
('61a34adc-a2eb-4b76-8129-4b31103a80ff', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'Flat 6'),
('eebbe9ca-ab44-4098-9e4a-ef995d1740f2', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'Flat 7'),
('0063d517-65b2-4c57-bcbd-021f0814c53c', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'Flat 8')
ON CONFLICT (id) DO NOTHING;

-- Insert 8 leaseholders (schema has building_id and unit_number)
INSERT INTO leaseholders (id, building_id, unit_id, unit_number, name) VALUES
('41dbdd56-c8dc-40ca-b171-bc8c7676adeb', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', '8dc85ff6-155b-43cc-bd6e-7e5e70811d12', 'Flat 1', 'Marmotte Holdings Limited'),
('8740dbe3-a056-4f69-9fa1-19e29f5b4ace', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', '6ef836eb-316b-4c65-aa59-b8b5a361ee25', 'Flat 2', 'Ms V Rebulla'),
('0df5553b-09d7-435f-a078-d77e07caf760', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', '1ee42f91-eee9-455b-90a4-f31c52af5495', 'Flat 3', 'Ms V Rebulla'),
('9de7aaf1-953e-4d56-aa7a-4633b0f3ff3e', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'd7c90af9-0e68-46d1-a9b3-06cc80ed2620', 'Flat 4', 'Mr P J J Reynish & Ms C A O''Loughlin'),
('212eb92a-60ee-4ba0-b478-aa78cc7adc32', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', '5723550b-5c34-45df-aaa6-6d4d747e4ecd', 'Flat 5', 'Mr & Mrs M D Samworth'),
('d30e477b-f9de-4f10-b2ff-f178263981df', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', '61a34adc-a2eb-4b76-8129-4b31103a80ff', 'Flat 6', 'Mr M D & Mrs C P Samworth'),
('93554fd1-d940-4e4a-a928-d3d0f53492cb', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'eebbe9ca-ab44-4098-9e4a-ef995d1740f2', 'Flat 7', 'Ms J Gomm'),
('9b8faea0-c2ca-4eb1-bfcc-d087a979d385', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', '0063d517-65b2-4c57-bcbd-021f0814c53c', 'Flat 8', 'Miss T V Samwoth & Miss G E Samworth')
ON CONFLICT (id) DO NOTHING;

-- Insert 56 compliance assets
INSERT INTO compliance_assets (id, building_id, description, asset_name, asset_type, inspection_frequency, last_inspection_date, next_due_date, compliance_status, is_active) VALUES ('177dbade-27d9-46c3-90a3-f027b1bce06c', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'Extracted from 2024 Directors Meeting-Notes.docx', 'Compliance Asset', 'general', '12 months', '2024-01-01', '2025-01-01', 'overdue', TRUE);
INSERT INTO compliance_assets (id, building_id, description, asset_name, asset_type, inspection_frequency, compliance_status, location, is_active) VALUES ('a58a92eb-6eec-4471-ab50-c281e690cdef', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'Extracted from Fire Door (Communal) Inspection (11m +) (7).pdf', 'Fire Door Inspection', 'fire_safety', '12 months', 'unknown', 'Communal', TRUE);
INSERT INTO compliance_assets (id, building_id, description, asset_name, asset_type, inspection_frequency, compliance_status, is_active) VALUES ('4c746423-26ce-40ed-a91d-fa65351ccf7c', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'Extracted from Fire Door (Flats) Inspection (11m +) (13).pdf', 'Fire Door Inspection', 'fire_safety', '12 months', 'unknown', TRUE);
INSERT INTO compliance_assets (id, building_id, description, asset_name, asset_type, inspection_frequency, compliance_status, is_active) VALUES ('4abc23e1-e1a4-4cfb-8dde-5f5567e456a2', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'Extracted from Fire Door (Flats) Inspection (11m +) (18).pdf', 'Fire Door Inspection', 'fire_safety', '12 months', 'unknown', TRUE);
INSERT INTO compliance_assets (id, building_id, description, asset_name, asset_type, inspection_frequency, compliance_status, is_active) VALUES ('89da6ea4-0116-4a9d-9d4a-7e65bceb28b8', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'Extracted from Fire Door (Flats) Inspection (11m +) (14).pdf', 'Fire Door Inspection', 'fire_safety', '12 months', 'unknown', TRUE);
INSERT INTO compliance_assets (id, building_id, description, asset_name, asset_type, inspection_frequency, compliance_status, is_active) VALUES ('dbeb3f68-10b1-44e1-b9c6-f26a1918757b', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'Extracted from EICR Cuanku 32-34 conaught square.pdf', 'Electrical Installation Condition Report (EICR)', 'electrical', '60 months', 'unknown', TRUE);
INSERT INTO compliance_assets (id, building_id, description, asset_name, asset_type, inspection_frequency, compliance_status, is_active) VALUES ('e5146877-bab7-41b6-88d9-957ce51153d8', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'Extracted from Fire Door (Flats) Inspection (11m +) (15).pdf', 'Fire Door Inspection', 'fire_safety', '12 months', 'unknown', TRUE);
INSERT INTO compliance_assets (id, building_id, description, asset_name, asset_type, inspection_frequency, last_inspection_date, next_due_date, compliance_status, is_active) VALUES ('7f48aa73-ca33-49fd-986b-9b48c0355a5d', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'Extracted from 221037_Fra1-L-394697-071223 32-34 Connaught Square_2024-01-02_163759 (1).pdf', 'Fire Risk Assessment (FRA)', 'fire_safety', '12 months', '2024-01-02', '2025-01-02', 'overdue', TRUE);
INSERT INTO compliance_assets (id, building_id, description, asset_name, asset_type, inspection_frequency, compliance_status, is_active) VALUES ('50ef640c-e18b-4fee-a288-bca8d3b89199', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'Extracted from Fire Door (Flats) Inspection (11m +) (19).pdf', 'Fire Door Inspection', 'fire_safety', '12 months', 'unknown', TRUE);
INSERT INTO compliance_assets (id, building_id, description, asset_name, asset_type, inspection_frequency, compliance_status, is_active) VALUES ('1780a05c-50db-48e6-b619-9c79fe258bf5', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'Extracted from 001132-3234-Connaught-Square-London.pdf', 'Compliance Asset', 'general', '12 months', 'unknown', TRUE);
INSERT INTO compliance_assets (id, building_id, description, asset_name, asset_type, inspection_frequency, last_inspection_date, next_due_date, compliance_status, is_active) VALUES ('156ea3f4-7b12-4f42-9a5b-c2c8a6d91e71', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'Extracted from 221038_Hsra1-L-394697-071223 32-34 Connaught Square_2024-01-02_163759 (1).pdf', 'Compliance Asset', 'general', '12 months', '2024-01-02', '2025-01-02', 'overdue', TRUE);
INSERT INTO compliance_assets (id, building_id, description, asset_name, asset_type, inspection_frequency, compliance_status, is_active) VALUES ('7e673f80-3d6d-47be-bf96-d7f69f9662be', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'Extracted from TETRA - Asbestos Re-Inspection Survey 14.06.22.pdf', 'Compliance Asset', 'general', '12 months', 'unknown', TRUE);
INSERT INTO compliance_assets (id, building_id, description, asset_name, asset_type, inspection_frequency, compliance_status, is_active) VALUES ('0496cd34-5e55-4274-930c-6e92d533ab03', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'Extracted from Fire Door (Flats) Inspection (11m +) (16).pdf', 'Fire Door Inspection', 'fire_safety', '12 months', 'unknown', TRUE);
INSERT INTO compliance_assets (id, building_id, description, asset_name, asset_type, inspection_frequency, compliance_status, is_active) VALUES ('8859cac3-edef-4562-a122-67e9688b6cde', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'Extracted from Fire Door (Flats) Inspection (11m +) (17).pdf', 'Fire Door Inspection', 'fire_safety', '12 months', 'unknown', TRUE);
INSERT INTO compliance_assets (id, building_id, description, asset_name, asset_type, inspection_frequency, compliance_status, is_active) VALUES ('0ef512b6-bbac-4e02-a4d8-fefc2888b7fa', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'Extracted from WHM Legionella Risk Assessment 07.06.22.pdf', 'Legionella Risk Assessment', 'water_safety', '24 months', 'unknown', TRUE);
INSERT INTO compliance_assets (id, building_id, description, asset_name, asset_type, inspection_frequency, last_inspection_date, next_due_date, compliance_status, is_active) VALUES ('35ba0d10-6493-4d0f-ad96-866ec8e821d3', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'Extracted from EICR Report Cunaku SATISFACTORY 2023 .pdf', 'Electrical Installation Condition Report (EICR)', 'electrical', '60 months', '2023-01-01', '2028-01-01', 'compliant', TRUE);
INSERT INTO compliance_assets (id, building_id, description, asset_name, asset_type, inspection_frequency, last_inspection_date, next_due_date, compliance_status, is_active) VALUES ('65a5cf2c-fe36-4153-83ef-86b4c79ed10f', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'Extracted from 2024 Directors Meeting-Notes.docx', 'Compliance Asset', 'general', '12 months', '2024-01-01', '2025-01-01', 'overdue', TRUE);
INSERT INTO compliance_assets (id, building_id, description, asset_name, asset_type, inspection_frequency, compliance_status, is_active) VALUES ('d7c936ae-e351-4cc4-ab27-8b757c3aa3c5', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'Extracted from 001457-3234-Connaught-Square-London Certificate.pdf', 'Compliance Asset', 'general', '12 months', 'unknown', TRUE);
INSERT INTO compliance_assets (id, building_id, description, asset_name, asset_type, inspection_frequency, compliance_status, is_active) VALUES ('de31ad8a-d6a1-4be8-8147-8cf25a17b6ed', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'Extracted from TC0001V31 General Terms and Conditions.pdf', 'Compliance Asset', 'general', '12 months', 'unknown', TRUE);
INSERT INTO compliance_assets (id, building_id, description, asset_name, asset_type, inspection_frequency, last_inspection_date, next_due_date, compliance_status, is_active) VALUES ('8574cfa7-7a12-4b7d-9a6b-0df8881a9ddb', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'Extracted from Jobcard_For_Job_No_28992_24-01-2025_1545.pdf', 'Compliance Asset', 'general', '12 months', '2025-01-24', '2026-01-24', 'compliant', TRUE);
INSERT INTO compliance_assets (id, building_id, description, asset_name, asset_type, inspection_frequency, compliance_status, is_active) VALUES ('85d88188-a93e-41e5-9f06-91de4f7af89a', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'Extracted from Connaught Square (32-34) - 09.12.24 LRA.pdf', 'Compliance Asset', 'general', '12 months', 'unknown', TRUE);
INSERT INTO compliance_assets (id, building_id, description, asset_name, asset_type, inspection_frequency, compliance_status, is_active) VALUES ('45f72088-bdc0-484c-b4d3-542d45eed951', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'Extracted from SC Certificate - 10072023.pdf', 'Compliance Asset', 'general', '12 months', 'unknown', TRUE);
INSERT INTO compliance_assets (id, building_id, description, asset_name, asset_type, inspection_frequency, compliance_status, location, is_active) VALUES ('7169ee50-753d-4d02-a32b-a54686416d90', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'Extracted from Fire Door (Communal) Inspection (11m +) (7).pdf', 'Fire Door Inspection', 'fire_safety', '12 months', 'unknown', 'Communal', TRUE);
INSERT INTO compliance_assets (id, building_id, description, asset_name, asset_type, inspection_frequency, compliance_status, is_active) VALUES ('c04fba11-b59b-49ea-89cc-db1b7217b8ac', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'Extracted from Fire Door (Flats) Inspection (11m +) (13).pdf', 'Fire Door Inspection', 'fire_safety', '12 months', 'unknown', TRUE);
INSERT INTO compliance_assets (id, building_id, description, asset_name, asset_type, inspection_frequency, compliance_status, is_active) VALUES ('215c9576-ce36-4f52-a980-afa3c796f72f', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'Extracted from Fire Door (Flats) Inspection (11m +) (18).pdf', 'Fire Door Inspection', 'fire_safety', '12 months', 'unknown', TRUE);
INSERT INTO compliance_assets (id, building_id, description, asset_name, asset_type, inspection_frequency, compliance_status, is_active) VALUES ('31c080d0-9f3c-4e19-99d6-4d3b4d11ee76', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'Extracted from Fire Door (Flats) Inspection (11m +) (14).pdf', 'Fire Door Inspection', 'fire_safety', '12 months', 'unknown', TRUE);
INSERT INTO compliance_assets (id, building_id, description, asset_name, asset_type, inspection_frequency, compliance_status, is_active) VALUES ('cc70e513-6558-4bf3-8996-8130e9ba7487', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'Extracted from Fire Door (Flats) Inspection (11m +) (15).pdf', 'Fire Door Inspection', 'fire_safety', '12 months', 'unknown', TRUE);
INSERT INTO compliance_assets (id, building_id, description, asset_name, asset_type, inspection_frequency, compliance_status, is_active) VALUES ('369bc951-2d7f-4d82-8f77-91431a44482d', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'Extracted from Fire Door (Flats) Inspection (11m +) (19).pdf', 'Fire Door Inspection', 'fire_safety', '12 months', 'unknown', TRUE);
INSERT INTO compliance_assets (id, building_id, description, asset_name, asset_type, inspection_frequency, compliance_status, is_active) VALUES ('c50cd44a-c0d5-43e9-90d6-a6ae7c7e02d6', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'Extracted from Fire Door (Flats) Inspection (11m +) (16).pdf', 'Fire Door Inspection', 'fire_safety', '12 months', 'unknown', TRUE);
INSERT INTO compliance_assets (id, building_id, description, asset_name, asset_type, inspection_frequency, compliance_status, is_active) VALUES ('77c37ad1-72c6-43ca-ab42-73ab8c180644', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'Extracted from Fire Door (Flats) Inspection (11m +) (17).pdf', 'Fire Door Inspection', 'fire_safety', '12 months', 'unknown', TRUE);
INSERT INTO compliance_assets (id, building_id, description, asset_name, asset_type, inspection_frequency, last_inspection_date, next_due_date, compliance_status, is_active) VALUES ('24cdebbd-db30-4a06-986d-1011f230a327', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'Extracted from 221037_Fra1-L-394697-071223 32-34 Connaught Square_2024-01-02_163759.pdf', 'Fire Risk Assessment (FRA)', 'fire_safety', '12 months', '2024-01-02', '2025-01-02', 'overdue', TRUE);
INSERT INTO compliance_assets (id, building_id, description, asset_name, asset_type, inspection_frequency, last_inspection_date, next_due_date, compliance_status, is_active) VALUES ('2fd4cb34-d9d2-4208-a48d-4d0b777da9f1', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'Extracted from Fire Door (Flats) Inspection (11m +) - 2024-01-24T120747.552.pdf', 'Fire Door Inspection', 'fire_safety', '12 months', '2024-01-24', '2025-01-24', 'overdue', TRUE);
INSERT INTO compliance_assets (id, building_id, description, asset_name, asset_type, inspection_frequency, compliance_status, is_active) VALUES ('743cd409-5abf-406a-92dc-990a20700670', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'Extracted from Connaught Square (32-34) - 15.11.23 (886) wa.pdf', 'Compliance Asset', 'general', '12 months', 'unknown', TRUE);
INSERT INTO compliance_assets (id, building_id, description, asset_name, asset_type, inspection_frequency, last_inspection_date, next_due_date, compliance_status, is_active) VALUES ('e0d44c2c-9d3a-4e61-88be-403751655135', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'Extracted from Fire Door (Flats) Inspection (11m +) - 2024-01-24T120745.875.pdf', 'Fire Door Inspection', 'fire_safety', '12 months', '2024-01-24', '2025-01-24', 'overdue', TRUE);
INSERT INTO compliance_assets (id, building_id, description, asset_name, asset_type, inspection_frequency, last_inspection_date, next_due_date, compliance_status, is_active) VALUES ('63da0f1f-b2d3-4b3b-b4b9-5aec7d6f6115', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'Extracted from Fire Door (Flats) Inspection (11m +) - 2024-01-24T120746.424.pdf', 'Fire Door Inspection', 'fire_safety', '12 months', '2024-01-24', '2025-01-24', 'overdue', TRUE);
INSERT INTO compliance_assets (id, building_id, description, asset_name, asset_type, inspection_frequency, last_inspection_date, next_due_date, compliance_status, location, is_active) VALUES ('8d60bb71-15fc-435e-9585-856d18f9e746', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'Extracted from Fire Door (Communal) Inspection (11m +) - 2024-01-24T120743.986.pdf', 'Fire Door Inspection', 'fire_safety', '12 months', '2024-01-24', '2025-01-24', 'overdue', 'Communal', TRUE);
INSERT INTO compliance_assets (id, building_id, description, asset_name, asset_type, inspection_frequency, last_inspection_date, next_due_date, compliance_status, is_active) VALUES ('fcf6ce07-08e3-4e9b-b8b3-52efa4d7ecab', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'Extracted from Fire Door (Flats) Inspection (11m +) - 2024-01-24T120744.738.pdf', 'Fire Door Inspection', 'fire_safety', '12 months', '2024-01-24', '2025-01-24', 'overdue', TRUE);
INSERT INTO compliance_assets (id, building_id, description, asset_name, asset_type, inspection_frequency, last_inspection_date, next_due_date, compliance_status, is_active) VALUES ('bf55efd8-f02b-4373-9776-32544b65f870', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'Extracted from Fire Door (Flats) Inspection (11m +) - 2024-01-24T120747.015.pdf', 'Fire Door Inspection', 'fire_safety', '12 months', '2024-01-24', '2025-01-24', 'overdue', TRUE);
INSERT INTO compliance_assets (id, building_id, description, asset_name, asset_type, inspection_frequency, last_inspection_date, next_due_date, compliance_status, is_active) VALUES ('faa0f441-2f63-42ed-a1b0-c2408810bfaa', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'Extracted from 221038_Hsra1-L-394697-071223 32-34 Connaught Square_2024-01-02_163759.pdf', 'Compliance Asset', 'general', '12 months', '2024-01-02', '2025-01-02', 'overdue', TRUE);
INSERT INTO compliance_assets (id, building_id, description, asset_name, asset_type, inspection_frequency, last_inspection_date, next_due_date, compliance_status, is_active) VALUES ('ca9b3f77-fd8a-48bd-97fe-80c50d14e47c', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'Extracted from Fire Door (Flats) Inspection (11m +) - 2024-01-24T120745.174.pdf', 'Fire Door Inspection', 'fire_safety', '12 months', '2024-01-24', '2025-01-24', 'overdue', TRUE);
INSERT INTO compliance_assets (id, building_id, description, asset_name, asset_type, inspection_frequency, compliance_status, is_active) VALUES ('17747942-5371-4d44-bbd8-8235d1f60490', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'Extracted from Hsfra1-L-422971-210225 32-34 Connaught Square.pdf', 'Fire Risk Assessment (FRA)', 'fire_safety', '12 months', 'unknown', TRUE);
INSERT INTO compliance_assets (id, building_id, description, asset_name, asset_type, inspection_frequency, compliance_status, is_active) VALUES ('54e2b9f1-154a-480d-9e2d-0af763e0bd09', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'Extracted from Hsfra1-L-422971-210225 32-34 Connaught Square.docx', 'Fire Risk Assessment (FRA)', 'fire_safety', '12 months', 'unknown', TRUE);
INSERT INTO compliance_assets (id, building_id, description, asset_name, asset_type, inspection_frequency, last_inspection_date, next_due_date, compliance_status, is_active) VALUES ('83db42a5-374e-441c-b470-796170206af5', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'Extracted from 221037_Fra1-L-394697-071223 32-34 Connaught Square_2024-01-02_163759 (1).pdf', 'Fire Risk Assessment (FRA)', 'fire_safety', '12 months', '2024-01-02', '2025-01-02', 'overdue', TRUE);
INSERT INTO compliance_assets (id, building_id, description, asset_name, asset_type, inspection_frequency, last_inspection_date, next_due_date, compliance_status, is_active) VALUES ('c02bb89c-8692-4392-924c-148fed4d5989', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'Extracted from 221038_Hsra1-L-394697-071223 32-34 Connaught Square_2024-01-02_163759 (1).pdf', 'Compliance Asset', 'general', '12 months', '2024-01-02', '2025-01-02', 'overdue', TRUE);
INSERT INTO compliance_assets (id, building_id, description, asset_name, asset_type, inspection_frequency, compliance_status, is_active) VALUES ('b4e512b6-29c7-4532-b2bf-30b3e019a7f0', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'Extracted from FRA-Connaught Square Reccommendations.xlsx', 'Fire Risk Assessment (FRA)', 'fire_safety', '12 months', 'unknown', TRUE);
INSERT INTO compliance_assets (id, building_id, description, asset_name, asset_type, inspection_frequency, compliance_status, is_active) VALUES ('65217918-f175-4a3c-a554-92603268843d', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'Extracted from 001534-3234-Connaught-Square-London.pdf', 'Compliance Asset', 'general', '12 months', 'unknown', TRUE);
INSERT INTO compliance_assets (id, building_id, description, asset_name, asset_type, inspection_frequency, compliance_status, is_active) VALUES ('c36cbbc0-98be-46b6-9987-091c81f83e52', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'Extracted from C1047 - Job card.pdf', 'Compliance Asset', 'general', '12 months', 'unknown', TRUE);
INSERT INTO compliance_assets (id, building_id, description, asset_name, asset_type, inspection_frequency, compliance_status, is_active) VALUES ('d395fb9b-3f82-411c-8058-03552a5e0088', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'Extracted from WHM Legionella Risk Assessment 09.12.25.pdf', 'Legionella Risk Assessment', 'water_safety', '24 months', 'unknown', TRUE);
INSERT INTO compliance_assets (id, building_id, description, asset_name, asset_type, inspection_frequency, compliance_status, is_active) VALUES ('96ec533c-0456-4c2f-8430-e303893f5a9c', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'Extracted from WHM Legionella Risk Assessment 07.06.22.pdf', 'Legionella Risk Assessment', 'water_safety', '24 months', 'unknown', TRUE);
INSERT INTO compliance_assets (id, building_id, description, asset_name, asset_type, inspection_frequency, compliance_status, is_active) VALUES ('d1e0171c-e44b-4e16-9f19-08c910819e6d', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'Extracted from Connaught Square (32-34) - 29.05.25 (201) wa.pdf', 'Compliance Asset', 'general', '12 months', 'unknown', TRUE);
INSERT INTO compliance_assets (id, building_id, description, asset_name, asset_type, inspection_frequency, compliance_status, is_active) VALUES ('46455e5b-1460-4f48-a8a2-52101da120d8', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'Extracted from EICR Cuanku 32-34 conaught square.pdf', 'Electrical Installation Condition Report (EICR)', 'electrical', '60 months', 'unknown', TRUE);
INSERT INTO compliance_assets (id, building_id, description, asset_name, asset_type, inspection_frequency, last_inspection_date, next_due_date, compliance_status, is_active) VALUES ('8f3e45f9-898f-4def-9867-54db1108a64a', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'Extracted from EICR Report Cunaku SATISFACTORY 2023 .pdf', 'Electrical Installation Condition Report (EICR)', 'electrical', '60 months', '2023-01-01', '2028-01-01', 'compliant', TRUE);
INSERT INTO compliance_assets (id, building_id, description, asset_name, asset_type, inspection_frequency, compliance_status, is_active) VALUES ('2fa36057-6984-4d18-a761-a70d8e2505e0', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'Extracted from 001132-3234-Connaught-Square-London.pdf', 'Compliance Asset', 'general', '12 months', 'unknown', TRUE);
INSERT INTO compliance_assets (id, building_id, description, asset_name, asset_type, inspection_frequency, compliance_status, is_active) VALUES ('a7a66729-3492-4c1f-8cd2-722b5e952485', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'Extracted from 001534-3234-Connaught-Square-London.pdf', 'Compliance Asset', 'general', '12 months', 'unknown', TRUE);
INSERT INTO compliance_assets (id, building_id, description, asset_name, asset_type, inspection_frequency, compliance_status, is_active) VALUES ('6f80df2e-a613-4059-ac1a-602fc14e9eef', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'Extracted from FINAL L-432900 32-34 Connaught Square Management Survey Report Issue 1.pdf', 'Compliance Asset', 'general', '12 months', 'unknown', TRUE);
INSERT INTO compliance_assets (id, building_id, description, asset_name, asset_type, inspection_frequency, compliance_status, is_active) VALUES ('2257ae39-2008-4f77-830a-c183a06dcaee', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'Extracted from TETRA - Asbestos Re-Inspection Survey 14.06.22.pdf', 'Compliance Asset', 'general', '12 months', 'unknown', TRUE);

-- Insert 4 major works projects
INSERT INTO major_works_projects (id, building_id, name, status, start_date) VALUES ('838f23a4-e2ba-4cbf-a318-0395f0188fb8', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'External Decoration - 2025', 'planning', '2025-01-01');
INSERT INTO major_works_projects (id, building_id, name, status, start_date) VALUES ('5f8faf93-bbff-4fd9-8cfb-2f83d4ce545d', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'Section 20 Consultation (SOE) - 2025', 'planning', '2025-01-01');
INSERT INTO major_works_projects (id, building_id, name, status, start_date) VALUES ('333e2c19-eaf5-4000-9809-73521215f769', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'Lift - Section 20 (NOI) - 2025', 'planning', '2025-01-01');
INSERT INTO major_works_projects (id, building_id, name, status, start_date) VALUES ('e2ef6a7c-0f1e-40f5-8c5f-cd0610c55419', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'Major Works Project - 2025', 'planning', '2025-01-01');

-- Insert 22 budgets
INSERT INTO budgets (id, building_id, year_start, year_end, period) VALUES ('a282abc2-a3a5-48a6-ab31-a2af434785da', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', '2025-04-01', '2026-03-31', '2025');
INSERT INTO budgets (id, building_id, year_start, year_end, period) VALUES ('416124a8-9161-4a58-8f40-742127f33199', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', '2025-04-01', '2026-03-31', '2025');
INSERT INTO budgets (id, building_id, year_start, year_end, period) VALUES ('fabcdc3e-0210-40fc-b3d8-6292983da71c', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', '2025-04-01', '2026-03-31', '2025');
INSERT INTO budgets (id, building_id, year_start, year_end, period) VALUES ('42f0b0c4-8431-48e8-abf4-903a9780a923', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', '2025-04-01', '2026-03-31', '2025');
INSERT INTO budgets (id, building_id, year_start, year_end, period) VALUES ('6481c55f-7366-4c38-959e-04efca968443', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', '2025-04-01', '2026-03-31', '2025');
INSERT INTO budgets (id, building_id, year_start, year_end, period) VALUES ('b439b1aa-aa9c-49a0-b57a-266fccdb2416', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', '2025-04-01', '2026-03-31', '2025');
INSERT INTO budgets (id, building_id, year_start, year_end, period) VALUES ('df3d537f-20ec-4f3b-947c-5fb42b84411a', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', '2025-04-01', '2026-03-31', '2025');
INSERT INTO budgets (id, building_id, year_start, year_end, period) VALUES ('bd01e65b-165d-4291-ac49-1eec9ed97df3', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', '2025-04-01', '2026-03-31', '2025');
INSERT INTO budgets (id, building_id, year_start, year_end, period) VALUES ('9377cf17-64ab-4b03-94df-bd5465ca1d02', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', '2025-04-01', '2026-03-31', '2025');
INSERT INTO budgets (id, building_id, year_start, year_end, period) VALUES ('8507f678-a55c-429c-bb72-2b1763361d28', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', '2025-04-01', '2026-03-31', '2025');
INSERT INTO budgets (id, building_id, year_start, year_end, period) VALUES ('3835f76c-56c7-4f37-a4b3-e30317ed2624', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', '2025-04-01', '2026-03-31', '2025');
INSERT INTO budgets (id, building_id, year_start, year_end, period) VALUES ('79f763b5-3ee6-4f70-ab83-745177cba653', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', '2025-04-01', '2026-03-31', '2025');
INSERT INTO budgets (id, building_id, year_start, year_end, period) VALUES ('4b2cf9ed-ac73-4d49-993e-bcf2fa1b1e5d', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', '2025-04-01', '2026-03-31', '2025');
INSERT INTO budgets (id, building_id, year_start, year_end, period) VALUES ('212b3294-d5c9-4908-b923-79cdd5f7f0d6', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', '2025-04-01', '2026-03-31', '2025');
INSERT INTO budgets (id, building_id, year_start, year_end, period) VALUES ('c5968312-b315-43d1-9c26-a2e47535db48', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', '2025-04-01', '2026-03-31', '2025');
INSERT INTO budgets (id, building_id, year_start, year_end, period) VALUES ('111b2333-a563-4f5a-8fed-e1793eb66c20', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', '2025-04-01', '2026-03-31', '2025');
INSERT INTO budgets (id, building_id, year_start, year_end, period) VALUES ('0ca1e95a-8e23-4679-ad93-d9163bd9ca96', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', '2025-04-01', '2026-03-31', '2025');
INSERT INTO budgets (id, building_id, year_start, year_end, period) VALUES ('687a01e0-2fe0-43bd-ae08-b2dd4971d0f4', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', '2025-04-01', '2026-03-31', '2025');
INSERT INTO budgets (id, building_id, year_start, year_end, period) VALUES ('475278e1-4511-4b7a-bcdd-16bf8808d2c3', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', '2025-04-01', '2026-03-31', '2025');
INSERT INTO budgets (id, building_id, year_start, year_end, period) VALUES ('51a734c3-5ab8-4331-a52f-9ca591fb7989', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', '2025-04-01', '2026-03-31', '2025');
INSERT INTO budgets (id, building_id, year_start, year_end, period) VALUES ('89c6374f-fbe8-48b6-a5d1-a35d705e6724', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', '2025-04-01', '2026-03-31', '2025');
INSERT INTO budgets (id, building_id, year_start, year_end, period) VALUES ('87ce6b49-1fce-4d69-8986-995d6aca1b35', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', '2025-04-01', '2026-03-31', '2025');

-- Insert 318 document records
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('0808e6f0-51d8-4352-82e2-b611655e2c5a', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'lease', 'Important Information .pdf', 'lease/Important Information .pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('ab9e548c-2513-41b0-b7a5-df79c2a81f82', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'finance', 'ACCOUNTS - YE 31.03.21 - Service Charge Accounts (1).pdf', 'finance/ACCOUNTS - YE 31.03.21 - Service Charge Accounts (1).pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('8aa4f5fd-ba97-45ce-ab8c-f18a45065b1f', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'lease', 'Official Copy (Lease) 04.08.2022 - NGL809841 (1).pdf', 'lease/Official Copy (Lease) 04.08.2022 - NGL809841 (1).pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('5fdca6ce-2af4-4423-83bf-f226c03af1f4', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'lease', 'Official Copy (Lease) 04.08.2022 - NGL809841 (2).pdf', 'lease/Official Copy (Lease) 04.08.2022 - NGL809841 (2).pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('1b5ba6d0-c958-40c0-9929-50e87c308f59', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'lease', 'Official Copy (Lease) 13.06.2003 - NGL827422.pdf', 'lease/Official Copy (Lease) 13.06.2003 - NGL827422.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('b7ceeda5-797b-47f5-a4ef-842e3a308a34', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'lease', 'Official Copy (Lease) 04.08.2022 - NGL809841.pdf', 'lease/Official Copy (Lease) 04.08.2022 - NGL809841.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('66a61f83-3b67-4b77-830e-f9dc1aecf5ce', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'lease', 'Signed April 2025 Arrears Collection Procedure.pdf', 'lease/Signed April 2025 Arrears Collection Procedure.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('67cca949-c343-425d-8a73-adb37c6b674c', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'lease', 'WP0005V17 Welcome Pack.pdf', 'lease/WP0005V17 Welcome Pack.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('2b02d495-d5fc-4e0c-8584-61dfcfcfe2fa', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'lease', 'Jobcard_For_Job_No_33844_07-04-2025_1143.pdf', 'lease/Jobcard_For_Job_No_33844_07-04-2025_1143.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('0aa45285-eefe-4b5a-b384-b77f25bc960c', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'lease', 'Jobcard_For_Job_No_37675_25-07-2025_1549.pdf', 'lease/Jobcard_For_Job_No_37675_25-07-2025_1549.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('44126180-8640-4822-901a-479936457f76', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'lease', 'Jobcard_For_Job_No_34012_01-05-2025_1616.pdf', 'lease/Jobcard_For_Job_No_34012_01-05-2025_1616.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('0fa327b9-b4ae-4b32-b0be-f7c35c50cddc', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'lease', 'Jobcard_For_Job_No_32759_17-03-2025_1145.pdf', 'lease/Jobcard_For_Job_No_32759_17-03-2025_1145.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('9fc2ebf7-d525-4191-a1ee-5c906753e77a', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'lease', 'Jobcard_For_Job_No_32810_17-03-2025_1311.pdf', 'lease/Jobcard_For_Job_No_32810_17-03-2025_1311.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('0d12a866-e502-4938-b13a-2e7df2bf0a6f', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'contracts', 'Quote_No_23550 - Connaught Square (32-34) 2023-2024.pdf', 'contracts/Quote_No_23550 - Connaught Square (32-34) 2023-2024.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('fcdd3b2b-a517-48e3-a0ab-b6488bed739e', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'lease', 'Licence_Document_352024.pdf', 'lease/Licence_Document_352024.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('4009cbb8-eedf-498f-b91f-48267481e464', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'lease', 'JLGServiceVisit-M00813-12-09-2024.pdf', 'lease/JLGServiceVisit-M00813-12-09-2024.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('1e6b3b79-f70d-4d95-be1f-abc8e2da9071', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'lease', 'JLGServiceVisit-M00813-13-11-2024.pdf', 'lease/JLGServiceVisit-M00813-13-11-2024.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('01395e37-d867-484b-b913-e764048f8604', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'lease', 'JLGServiceVisit-M00813-02-12-2024.pdf', 'lease/JLGServiceVisit-M00813-02-12-2024.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('5343cb71-3261-40ea-aabf-811aa3ceba5b', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'lease', 'JLGServiceVisit-M00813-08-07-2024.pdf', 'lease/JLGServiceVisit-M00813-08-07-2024.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('17c9dc02-dfdb-467b-8086-e832df9fc340', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'lease', 'JLGServiceVisit-M00813-08-10-2024.pdf', 'lease/JLGServiceVisit-M00813-08-10-2024.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('001e42cf-45e5-4d74-89ec-f40e1eb9f18a', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'lease', 'JLGServiceVisit-M00813-12-02-2025.pdf', 'lease/JLGServiceVisit-M00813-12-02-2025.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('1c494690-fdbe-4947-b21c-1f7207bfb13e', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'lease', 'JLGServiceVisit-M00813-17-03-2025.pdf', 'lease/JLGServiceVisit-M00813-17-03-2025.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('44025c43-e84f-4fc6-90f3-6627e5182619', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'lease', 'JLGServiceVisit-M00813-14-04-2025.pdf', 'lease/JLGServiceVisit-M00813-14-04-2025.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('2e5d42e2-e5dd-4da3-8160-aca47dbfa000', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'lease', 'REP-40343473-L1.pdf', 'lease/REP-40343473-L1.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('9e2bc2bf-28bd-46ed-995b-6656dd9cb6eb', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'lease', 'JLGServiceVisit-M00813-13-05-2025.pdf', 'lease/JLGServiceVisit-M00813-13-05-2025.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('540a2b68-b678-420c-9403-90fb68672d2d', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'lease', 'Communal Cleaning-First Port.pdf', 'lease/Communal Cleaning-First Port.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('2c13100c-c90f-44ea-83ba-eeba6f7206a9', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'lease', 'SC Health and Safety Product - Accredited 10072023.pdf', 'lease/SC Health and Safety Product - Accredited 10072023.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('bc97d562-f3ae-4e22-b6f9-befceae27a6a', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'lease', 'Tenancy Schedule by Property.pdf', 'lease/Tenancy Schedule by Property.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('562eae9f-a0b0-4256-b72e-7319571b4fab', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'finance', 'Accounts YE 31.03.2022 32-34 Connaught Square MJP.pdf', 'finance/Accounts YE 31.03.2022 32-34 Connaught Square MJP.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('bf21632e-cda5-41ec-bb4b-454dc7e067e2', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'finance', '197-YE 31.03.22 SC Accs FINAL MAY 2023.pdf', 'finance/197-YE 31.03.22 SC Accs FINAL MAY 2023.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('6ad02838-a8a6-4fbc-ae4e-550762b00b9b', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'finance', 'ACCOUNTS - YE 31.03.21 - Service Charge Accounts (1).pdf', 'finance/ACCOUNTS - YE 31.03.21 - Service Charge Accounts (1).pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('1484e802-053d-40e0-8e2c-e0d878e80ce6', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'finance', '27039 Accounts Pack - YE 2023.pdf', 'finance/27039 Accounts Pack - YE 2023.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('c6af291d-de13-40fd-a76a-8aac81c18d6a', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'finance', 'Connaught Sq SC YE 23.pdf', 'finance/Connaught Sq SC YE 23.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('b3231ebc-3e57-4cd6-a283-ca836f52666f', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'lease', 'Connaught Square-House Rules.docx', 'lease/Connaught Square-House Rules.docx');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('a0cf72c1-fc29-4696-aeee-a8710222ebfc', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'correspondence', 'Garden Notice-Connaught Square.docx', 'correspondence/Garden Notice-Connaught Square.docx');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('bafd2559-343a-428b-9452-2bfbfbf2d88c', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'correspondence', 'Connaught Square-Key Cut Authorisation Letter.docx', 'correspondence/Connaught Square-Key Cut Authorisation Letter.docx');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('f636b2e8-7d17-4fcd-9d69-77033e26a272', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'lease', 'House Rules-Connaught Square.pdf', 'lease/House Rules-Connaught Square.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('04032c27-fe81-4b76-ae83-cceb2e540033', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'lease', 'REP-39659654.pdf', 'lease/REP-39659654.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('98413044-2f22-4c48-8595-76618a8db214', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'lease', 'Important Information .pdf', 'lease/Important Information .pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('636ddc93-453d-496b-b0d9-9ecd48baf2a0', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'lease', 'StG_Certificate_32-34 Connaught Square W2 2HL.pdf', 'lease/StG_Certificate_32-34 Connaught Square W2 2HL.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('20abdb5c-62fd-4990-8c76-e7f88be84a30', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'contracts', 'CM434.AnnualServiceAgreement2025-2026.pdf', 'contracts/CM434.AnnualServiceAgreement2025-2026.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('4eb0e18e-1429-4740-8638-274689ad787a', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'contracts', 'CM434.AnnualServiceAgreement2024-2025.pdf', 'contracts/CM434.AnnualServiceAgreement2024-2025.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('93bcd1dd-2fe8-4676-84f3-bb49370c8ad3', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'lease', 'REP-40324834-E3.pdf', 'lease/REP-40324834-E3.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('27bc3344-8944-4930-8e2c-f6a7a8691163', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'lease', 'Ellie@mihproperty.co.uk - BES Group - E-Report.pdf', 'lease/Ellie@mihproperty.co.uk - BES Group - E-Report.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('9793e3a1-2410-481e-a5b9-2b69fc5f4264', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'lease', 'Jobcard_For_Job_No_38609_26-08-2025_0741.pdf', 'lease/Jobcard_For_Job_No_38609_26-08-2025_0741.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('21985e82-1309-4b53-ba57-f46b5f9acab1', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'lease', 'Jobcard_For_Job_No_28737_25-11-2024_0907.pdf', 'lease/Jobcard_For_Job_No_28737_25-11-2024_0907.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('e675c291-00db-4024-8b50-cc0b851d9d1c', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'lease', 'Jobcard_For_Job_No_35402_03-06-2025_0916.pdf', 'lease/Jobcard_For_Job_No_35402_03-06-2025_0916.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('6fa3b2c1-e2bb-477e-8de2-324f3ae891c6', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'lease', 'Jobcard_For_Job_No_35654_03-06-2025_0911.pdf', 'lease/Jobcard_For_Job_No_35654_03-06-2025_0911.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('7067e842-cbfa-49f7-bd20-9d8973b0941d', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'lease', 'Jobcard_For_Job_No_37675_25-07-2025_1549.pdf', 'lease/Jobcard_For_Job_No_37675_25-07-2025_1549.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('f546b254-733b-464a-a196-e0420dce115c', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'lease', 'Jobcard_For_Job_No_35146_03-06-2025_0906.pdf', 'lease/Jobcard_For_Job_No_35146_03-06-2025_0906.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('b9c739d1-4864-4613-acbf-03bc54ad3af6', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'lease', 'Jobcard_For_Job_No_31162_30-01-2025_1602.pdf', 'lease/Jobcard_For_Job_No_31162_30-01-2025_1602.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('20fac1cd-6e12-4e3b-90bb-b9b555abe024', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'lease', 'Jobcard_For_Job_No_36465_20-06-2025_1037.pdf', 'lease/Jobcard_For_Job_No_36465_20-06-2025_1037.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path, entity_type, linked_entity_id) VALUES ('53912b96-ccce-4dc4-ac4e-997962ba95b7', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'finance', 'connaught apportionment.xlsx', 'finance/connaught apportionment.xlsx', 'budget', '26d1252d-7563-49ed-bc54-2c307b061265');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path, entity_type, linked_entity_id) VALUES ('486f923f-6293-47c0-9d9f-6ca1ed058976', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'finance', 'ACCOUNTS - YE 31.03.21 - Service Charge Accounts.pdf', 'finance/ACCOUNTS - YE 31.03.21 - Service Charge Accounts.pdf', 'budget', 'f76a05af-207f-443b-8b48-203b2625a3dc');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path, entity_type, linked_entity_id) VALUES ('e46a99c2-48ea-42bf-815e-18a8d0222fe2', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'finance', 'Connaught Square Budget 2025-6 Draft.xlsx', 'finance/Connaught Square Budget 2025-6 Draft.xlsx', 'budget', '1e00bb10-f6ce-4d66-9cfe-4a63c89a3cc8');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path, entity_type, linked_entity_id) VALUES ('765596f6-65a9-4fc2-a116-d5b4acc1c856', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'finance', 'Connaught Square Budget 2025-Final.pdf', 'finance/Connaught Square Budget 2025-Final.pdf', 'budget', '369c0534-9cb2-408f-b274-062002cc4374');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path, entity_type, linked_entity_id) VALUES ('125b87b0-1a64-4b04-9ac8-10327a3c0227', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'finance', 'Connaught Square Budget 2025-Final.xlsx', 'finance/Connaught Square Budget 2025-Final.xlsx', 'budget', '06f6f58f-fecf-44d1-bd0c-17e031243344');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path, entity_type, linked_entity_id) VALUES ('f42a4b14-0273-4642-bb9e-1ceb87e143b5', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'finance', 'ACCOUNTS - YE 31.03.21 - Service Charge Accounts.pdf', 'finance/ACCOUNTS - YE 31.03.21 - Service Charge Accounts.pdf', 'budget', '6fcfe9ec-5a83-4e9d-a66c-0708ac6af14a');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path, entity_type, linked_entity_id) VALUES ('d0f8a482-176b-4588-a33f-e52954f1a466', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'finance', 'Connaught Square YE 24 Accounts.pdf', 'finance/Connaught Square YE 24 Accounts.pdf', 'budget', 'ca553c2f-9b60-463f-bfd2-7c6321bee172');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path, entity_type, linked_entity_id) VALUES ('a6bcf14b-3ff4-47df-b439-98e6370e315e', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'compliance', '2024 Directors Meeting-Notes.docx', 'compliance/2024 Directors Meeting-Notes.docx', 'compliance_asset', '177dbade-27d9-46c3-90a3-f027b1bce06c');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path, entity_type, linked_entity_id) VALUES ('43f1f95a-c5f4-4f30-8e23-6f4ac50ad859', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'compliance', 'Fire Door (Communal) Inspection (11m +) (7).pdf', 'compliance/Fire Door (Communal) Inspection (11m +) (7).pdf', 'compliance_asset', 'a58a92eb-6eec-4471-ab50-c281e690cdef');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path, entity_type, linked_entity_id) VALUES ('c66ea921-13ec-4e35-8d73-029646f540bd', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'compliance', 'Fire Door (Flats) Inspection (11m +) (13).pdf', 'compliance/Fire Door (Flats) Inspection (11m +) (13).pdf', 'compliance_asset', '4c746423-26ce-40ed-a91d-fa65351ccf7c');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path, entity_type, linked_entity_id) VALUES ('d8abe1a8-59cf-40f5-b154-66ac3d468f62', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'compliance', 'Fire Door (Flats) Inspection (11m +) (18).pdf', 'compliance/Fire Door (Flats) Inspection (11m +) (18).pdf', 'compliance_asset', '4abc23e1-e1a4-4cfb-8dde-5f5567e456a2');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path, entity_type, linked_entity_id) VALUES ('b686f3ca-067f-4591-8c24-a7a1c82d6a09', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'compliance', 'Fire Door (Flats) Inspection (11m +) (14).pdf', 'compliance/Fire Door (Flats) Inspection (11m +) (14).pdf', 'compliance_asset', '89da6ea4-0116-4a9d-9d4a-7e65bceb28b8');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path, entity_type, linked_entity_id) VALUES ('b76996af-4066-41c2-9492-ec3e4eb79cee', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'compliance', 'EICR Cuanku 32-34 conaught square.pdf', 'compliance/EICR Cuanku 32-34 conaught square.pdf', 'compliance_asset', 'dbeb3f68-10b1-44e1-b9c6-f26a1918757b');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path, entity_type, linked_entity_id) VALUES ('8db0e80d-d655-4132-bdb4-9d573d811ba6', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'compliance', 'Fire Door (Flats) Inspection (11m +) (15).pdf', 'compliance/Fire Door (Flats) Inspection (11m +) (15).pdf', 'compliance_asset', 'e5146877-bab7-41b6-88d9-957ce51153d8');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path, entity_type, linked_entity_id) VALUES ('5961d54c-9be9-46e2-a7fc-d53f1c33abce', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'compliance', '221037_Fra1-L-394697-071223 32-34 Connaught Square_2024-01-02_163759 (1).pdf', 'compliance/221037_Fra1-L-394697-071223 32-34 Connaught Square_2024-01-02_163759 (1).pdf', 'compliance_asset', '7f48aa73-ca33-49fd-986b-9b48c0355a5d');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path, entity_type, linked_entity_id) VALUES ('e47e7479-41d0-47ad-a0c3-a09934b9ef06', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'compliance', 'Fire Door (Flats) Inspection (11m +) (19).pdf', 'compliance/Fire Door (Flats) Inspection (11m +) (19).pdf', 'compliance_asset', '50ef640c-e18b-4fee-a288-bca8d3b89199');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path, entity_type, linked_entity_id) VALUES ('247a164b-83e7-45b1-9597-613a7459db82', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'compliance', '001132-3234-Connaught-Square-London.pdf', 'compliance/001132-3234-Connaught-Square-London.pdf', 'compliance_asset', '1780a05c-50db-48e6-b619-9c79fe258bf5');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path, entity_type, linked_entity_id) VALUES ('3cf73021-ba0d-4fdf-a0fe-36eba6b8fc49', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'compliance', '221038_Hsra1-L-394697-071223 32-34 Connaught Square_2024-01-02_163759 (1).pdf', 'compliance/221038_Hsra1-L-394697-071223 32-34 Connaught Square_2024-01-02_163759 (1).pdf', 'compliance_asset', '156ea3f4-7b12-4f42-9a5b-c2c8a6d91e71');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path, entity_type, linked_entity_id) VALUES ('af80d00d-cb1a-4797-a833-999a7cc418ec', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'compliance', 'TETRA - Asbestos Re-Inspection Survey 14.06.22.pdf', 'compliance/TETRA - Asbestos Re-Inspection Survey 14.06.22.pdf', 'compliance_asset', '7e673f80-3d6d-47be-bf96-d7f69f9662be');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path, entity_type, linked_entity_id) VALUES ('5e782f39-1a31-4dfa-b8dd-3f17e166aa51', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'compliance', 'Fire Door (Flats) Inspection (11m +) (16).pdf', 'compliance/Fire Door (Flats) Inspection (11m +) (16).pdf', 'compliance_asset', '0496cd34-5e55-4274-930c-6e92d533ab03');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path, entity_type, linked_entity_id) VALUES ('46e44056-7901-45bf-a058-e5fb55dd1762', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'compliance', 'Fire Door (Flats) Inspection (11m +) (17).pdf', 'compliance/Fire Door (Flats) Inspection (11m +) (17).pdf', 'compliance_asset', '8859cac3-edef-4562-a122-67e9688b6cde');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path, entity_type, linked_entity_id) VALUES ('40d3088c-8cec-4da3-839d-48388c388647', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'compliance', 'WHM Legionella Risk Assessment 07.06.22.pdf', 'compliance/WHM Legionella Risk Assessment 07.06.22.pdf', 'compliance_asset', '0ef512b6-bbac-4e02-a4d8-fefc2888b7fa');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path, entity_type, linked_entity_id) VALUES ('c39e34f5-7d45-461c-b418-2a5ec39e991b', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'compliance', 'EICR Report Cunaku SATISFACTORY 2023 .pdf', 'compliance/EICR Report Cunaku SATISFACTORY 2023 .pdf', 'compliance_asset', '35ba0d10-6493-4d0f-ad96-866ec8e821d3');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path, entity_type, linked_entity_id) VALUES ('235680e1-9546-4eeb-aa50-d1b6b1942b4f', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'compliance', '2024 Directors Meeting-Notes.docx', 'compliance/2024 Directors Meeting-Notes.docx', 'compliance_asset', '65a5cf2c-fe36-4153-83ef-86b4c79ed10f');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path, entity_type, linked_entity_id) VALUES ('93a507cc-f7d6-46c0-a878-d2bf82b155fa', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'compliance', '001457-3234-Connaught-Square-London Certificate.pdf', 'compliance/001457-3234-Connaught-Square-London Certificate.pdf', 'compliance_asset', 'd7c936ae-e351-4cc4-ab27-8b757c3aa3c5');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path, entity_type, linked_entity_id) VALUES ('a3d77686-5f2c-457c-a332-4c199ece8ff4', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'compliance', 'TC0001V31 General Terms and Conditions.pdf', 'compliance/TC0001V31 General Terms and Conditions.pdf', 'compliance_asset', 'de31ad8a-d6a1-4be8-8147-8cf25a17b6ed');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path, entity_type, linked_entity_id) VALUES ('3bb52f76-b49a-4c38-b781-9ed3324cd5d3', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'compliance', 'Jobcard_For_Job_No_28992_24-01-2025_1545.pdf', 'compliance/Jobcard_For_Job_No_28992_24-01-2025_1545.pdf', 'compliance_asset', '8574cfa7-7a12-4b7d-9a6b-0df8881a9ddb');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path, entity_type, linked_entity_id) VALUES ('1a2cae2c-5827-4cf3-ab30-fb6aebe61f2a', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'compliance', 'Connaught Square (32-34) - 09.12.24 LRA.pdf', 'compliance/Connaught Square (32-34) - 09.12.24 LRA.pdf', 'compliance_asset', '85d88188-a93e-41e5-9f06-91de4f7af89a');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path, entity_type, linked_entity_id) VALUES ('f3ad740a-0cfd-444b-8ac5-dbf32530aeaf', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'compliance', 'SC Certificate - 10072023.pdf', 'compliance/SC Certificate - 10072023.pdf', 'compliance_asset', '45f72088-bdc0-484c-b4d3-542d45eed951');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path, entity_type, linked_entity_id) VALUES ('798b9002-bdb7-4608-9a4e-a5bdf9358ec4', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'compliance', 'Fire Door (Communal) Inspection (11m +) (7).pdf', 'compliance/Fire Door (Communal) Inspection (11m +) (7).pdf', 'compliance_asset', '7169ee50-753d-4d02-a32b-a54686416d90');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path, entity_type, linked_entity_id) VALUES ('500b2679-0d78-4e73-91ed-04bea3bc9fd4', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'compliance', 'Fire Door (Flats) Inspection (11m +) (13).pdf', 'compliance/Fire Door (Flats) Inspection (11m +) (13).pdf', 'compliance_asset', 'c04fba11-b59b-49ea-89cc-db1b7217b8ac');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path, entity_type, linked_entity_id) VALUES ('b1df23ca-5639-43e2-93a3-1b347b6ca110', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'compliance', 'Fire Door (Flats) Inspection (11m +) (18).pdf', 'compliance/Fire Door (Flats) Inspection (11m +) (18).pdf', 'compliance_asset', '215c9576-ce36-4f52-a980-afa3c796f72f');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path, entity_type, linked_entity_id) VALUES ('ab5d85b8-3d1b-4d7e-9a72-f3c6e999dcbd', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'compliance', 'Fire Door (Flats) Inspection (11m +) (14).pdf', 'compliance/Fire Door (Flats) Inspection (11m +) (14).pdf', 'compliance_asset', '31c080d0-9f3c-4e19-99d6-4d3b4d11ee76');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path, entity_type, linked_entity_id) VALUES ('6294efff-67e0-4bfb-8525-8ff2faa0e082', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'compliance', 'Fire Door (Flats) Inspection (11m +) (15).pdf', 'compliance/Fire Door (Flats) Inspection (11m +) (15).pdf', 'compliance_asset', 'cc70e513-6558-4bf3-8996-8130e9ba7487');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path, entity_type, linked_entity_id) VALUES ('61f697f5-1d0a-4932-9a9d-4ce2bace213a', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'compliance', 'Fire Door (Flats) Inspection (11m +) (19).pdf', 'compliance/Fire Door (Flats) Inspection (11m +) (19).pdf', 'compliance_asset', '369bc951-2d7f-4d82-8f77-91431a44482d');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path, entity_type, linked_entity_id) VALUES ('01f3e98e-9919-4083-8744-188b115ab030', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'compliance', 'Fire Door (Flats) Inspection (11m +) (16).pdf', 'compliance/Fire Door (Flats) Inspection (11m +) (16).pdf', 'compliance_asset', 'c50cd44a-c0d5-43e9-90d6-a6ae7c7e02d6');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path, entity_type, linked_entity_id) VALUES ('05e8971a-af1e-4265-bed9-d31cf56dcc27', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'compliance', 'Fire Door (Flats) Inspection (11m +) (17).pdf', 'compliance/Fire Door (Flats) Inspection (11m +) (17).pdf', 'compliance_asset', '77c37ad1-72c6-43ca-ab42-73ab8c180644');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path, entity_type, linked_entity_id) VALUES ('e583eeb7-9a5e-433b-83ea-b784fb940485', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'compliance', '221037_Fra1-L-394697-071223 32-34 Connaught Square_2024-01-02_163759.pdf', 'compliance/221037_Fra1-L-394697-071223 32-34 Connaught Square_2024-01-02_163759.pdf', 'compliance_asset', '24cdebbd-db30-4a06-986d-1011f230a327');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path, entity_type, linked_entity_id) VALUES ('610b02d8-ff6c-4432-a31a-ca4d314762d1', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'compliance', 'Fire Door (Flats) Inspection (11m +) - 2024-01-24T120747.552.pdf', 'compliance/Fire Door (Flats) Inspection (11m +) - 2024-01-24T120747.552.pdf', 'compliance_asset', '2fd4cb34-d9d2-4208-a48d-4d0b777da9f1');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path, entity_type, linked_entity_id) VALUES ('c35a93f3-441c-4a11-b4e0-3ee15496cf3a', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'compliance', 'Connaught Square (32-34) - 15.11.23 (886) wa.pdf', 'compliance/Connaught Square (32-34) - 15.11.23 (886) wa.pdf', 'compliance_asset', '743cd409-5abf-406a-92dc-990a20700670');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path, entity_type, linked_entity_id) VALUES ('36cc5e79-e15a-4ed6-a6bd-e118df9af1c2', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'compliance', 'Fire Door (Flats) Inspection (11m +) - 2024-01-24T120745.875.pdf', 'compliance/Fire Door (Flats) Inspection (11m +) - 2024-01-24T120745.875.pdf', 'compliance_asset', 'e0d44c2c-9d3a-4e61-88be-403751655135');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path, entity_type, linked_entity_id) VALUES ('cb244990-b10b-4f94-9630-a18a9dac88ad', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'compliance', 'Fire Door (Flats) Inspection (11m +) - 2024-01-24T120746.424.pdf', 'compliance/Fire Door (Flats) Inspection (11m +) - 2024-01-24T120746.424.pdf', 'compliance_asset', '63da0f1f-b2d3-4b3b-b4b9-5aec7d6f6115');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path, entity_type, linked_entity_id) VALUES ('0498c147-7be7-452c-bc51-8c52c9272909', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'compliance', 'Fire Door (Communal) Inspection (11m +) - 2024-01-24T120743.986.pdf', 'compliance/Fire Door (Communal) Inspection (11m +) - 2024-01-24T120743.986.pdf', 'compliance_asset', '8d60bb71-15fc-435e-9585-856d18f9e746');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path, entity_type, linked_entity_id) VALUES ('6fa9d957-dfe5-4e9b-8089-0c78771c44ae', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'compliance', 'Fire Door (Flats) Inspection (11m +) - 2024-01-24T120744.738.pdf', 'compliance/Fire Door (Flats) Inspection (11m +) - 2024-01-24T120744.738.pdf', 'compliance_asset', 'fcf6ce07-08e3-4e9b-b8b3-52efa4d7ecab');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path, entity_type, linked_entity_id) VALUES ('aa5dcfa2-7c12-41c1-b4c1-78e1e24b04e7', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'compliance', 'Fire Door (Flats) Inspection (11m +) - 2024-01-24T120747.015.pdf', 'compliance/Fire Door (Flats) Inspection (11m +) - 2024-01-24T120747.015.pdf', 'compliance_asset', 'bf55efd8-f02b-4373-9776-32544b65f870');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path, entity_type, linked_entity_id) VALUES ('07ab0850-6ca8-4051-a41d-27d4b3e6621c', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'compliance', '221038_Hsra1-L-394697-071223 32-34 Connaught Square_2024-01-02_163759.pdf', 'compliance/221038_Hsra1-L-394697-071223 32-34 Connaught Square_2024-01-02_163759.pdf', 'compliance_asset', 'faa0f441-2f63-42ed-a1b0-c2408810bfaa');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path, entity_type, linked_entity_id) VALUES ('4cc0bb8e-88e4-418a-ae51-d95166ffa0b1', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'compliance', 'Fire Door (Flats) Inspection (11m +) - 2024-01-24T120745.174.pdf', 'compliance/Fire Door (Flats) Inspection (11m +) - 2024-01-24T120745.174.pdf', 'compliance_asset', 'ca9b3f77-fd8a-48bd-97fe-80c50d14e47c');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path, entity_type, linked_entity_id) VALUES ('aca36379-2f62-447d-9e1b-3a67643bdde6', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'compliance', 'Hsfra1-L-422971-210225 32-34 Connaught Square.pdf', 'compliance/Hsfra1-L-422971-210225 32-34 Connaught Square.pdf', 'compliance_asset', '17747942-5371-4d44-bbd8-8235d1f60490');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path, entity_type, linked_entity_id) VALUES ('72c386c3-38c7-4491-8b4e-861f86728a80', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'compliance', 'Hsfra1-L-422971-210225 32-34 Connaught Square.docx', 'compliance/Hsfra1-L-422971-210225 32-34 Connaught Square.docx', 'compliance_asset', '54e2b9f1-154a-480d-9e2d-0af763e0bd09');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path, entity_type, linked_entity_id) VALUES ('6eeeef3a-8c59-405a-a0c7-df32e966a2bd', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'compliance', '221037_Fra1-L-394697-071223 32-34 Connaught Square_2024-01-02_163759 (1).pdf', 'compliance/221037_Fra1-L-394697-071223 32-34 Connaught Square_2024-01-02_163759 (1).pdf', 'compliance_asset', '83db42a5-374e-441c-b470-796170206af5');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path, entity_type, linked_entity_id) VALUES ('693aa4f7-e209-4b6e-a777-1fb0dbad8be6', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'compliance', '221038_Hsra1-L-394697-071223 32-34 Connaught Square_2024-01-02_163759 (1).pdf', 'compliance/221038_Hsra1-L-394697-071223 32-34 Connaught Square_2024-01-02_163759 (1).pdf', 'compliance_asset', 'c02bb89c-8692-4392-924c-148fed4d5989');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path, entity_type, linked_entity_id) VALUES ('1f03562a-9a6c-4a81-be56-e660ed913a23', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'compliance', 'FRA-Connaught Square Reccommendations.xlsx', 'compliance/FRA-Connaught Square Reccommendations.xlsx', 'compliance_asset', 'b4e512b6-29c7-4532-b2bf-30b3e019a7f0');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path, entity_type, linked_entity_id) VALUES ('ec40f401-661a-4513-89bf-b747f6a0c1a8', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'compliance', '001534-3234-Connaught-Square-London.pdf', 'compliance/001534-3234-Connaught-Square-London.pdf', 'compliance_asset', '65217918-f175-4a3c-a554-92603268843d');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path, entity_type, linked_entity_id) VALUES ('16dba879-9128-4162-b011-db0505e9f164', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'compliance', 'C1047 - Job card.pdf', 'compliance/C1047 - Job card.pdf', 'compliance_asset', 'c36cbbc0-98be-46b6-9987-091c81f83e52');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path, entity_type, linked_entity_id) VALUES ('dddf3aa2-59bc-43dd-8b55-36794da34450', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'compliance', 'WHM Legionella Risk Assessment 09.12.25.pdf', 'compliance/WHM Legionella Risk Assessment 09.12.25.pdf', 'compliance_asset', 'd395fb9b-3f82-411c-8058-03552a5e0088');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path, entity_type, linked_entity_id) VALUES ('5aaf9001-373f-4e23-a4cc-f60a30ea6a64', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'compliance', 'WHM Legionella Risk Assessment 07.06.22.pdf', 'compliance/WHM Legionella Risk Assessment 07.06.22.pdf', 'compliance_asset', '96ec533c-0456-4c2f-8430-e303893f5a9c');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path, entity_type, linked_entity_id) VALUES ('680ec3ca-ac3c-4e8d-a3cf-5e0a3f3d5540', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'compliance', 'Connaught Square (32-34) - 29.05.25 (201) wa.pdf', 'compliance/Connaught Square (32-34) - 29.05.25 (201) wa.pdf', 'compliance_asset', 'd1e0171c-e44b-4e16-9f19-08c910819e6d');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path, entity_type, linked_entity_id) VALUES ('7aee49c7-a093-4f5c-a5d0-bd4372e0e2f4', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'compliance', 'EICR Cuanku 32-34 conaught square.pdf', 'compliance/EICR Cuanku 32-34 conaught square.pdf', 'compliance_asset', '46455e5b-1460-4f48-a8a2-52101da120d8');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path, entity_type, linked_entity_id) VALUES ('5db34193-f549-4541-b1a7-adb87128d05c', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'compliance', 'EICR Report Cunaku SATISFACTORY 2023 .pdf', 'compliance/EICR Report Cunaku SATISFACTORY 2023 .pdf', 'compliance_asset', '8f3e45f9-898f-4def-9867-54db1108a64a');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path, entity_type, linked_entity_id) VALUES ('3745deb6-2a54-405f-8019-be38f5d99c2a', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'compliance', '001132-3234-Connaught-Square-London.pdf', 'compliance/001132-3234-Connaught-Square-London.pdf', 'compliance_asset', '2fa36057-6984-4d18-a761-a70d8e2505e0');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path, entity_type, linked_entity_id) VALUES ('97b58508-9121-4cb3-a8b7-32f110fa158e', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'compliance', '001534-3234-Connaught-Square-London.pdf', 'compliance/001534-3234-Connaught-Square-London.pdf', 'compliance_asset', 'a7a66729-3492-4c1f-8cd2-722b5e952485');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path, entity_type, linked_entity_id) VALUES ('d3c571bd-5bab-4489-bc8b-b2cce49d312a', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'compliance', 'FINAL L-432900 32-34 Connaught Square Management Survey Report Issue 1.pdf', 'compliance/FINAL L-432900 32-34 Connaught Square Management Survey Report Issue 1.pdf', 'compliance_asset', '6f80df2e-a613-4059-ac1a-602fc14e9eef');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path, entity_type, linked_entity_id) VALUES ('2a29b535-fd84-4c64-b4b2-bb85c0d98523', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'compliance', 'TETRA - Asbestos Re-Inspection Survey 14.06.22.pdf', 'compliance/TETRA - Asbestos Re-Inspection Survey 14.06.22.pdf', 'compliance_asset', '2257ae39-2008-4f77-830a-c183a06dcaee');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('2a2985fa-adc0-4dd7-a9bb-9b5120714414', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'finance', 'British Gas Invoice-862451083.pdf', 'finance/British Gas Invoice-862451083.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('03664cef-8560-47a2-abd1-5f79d04ff089', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'contracts', 'Signed 2025 Connaught Square Management Agreement.docx.pdf', 'contracts/Signed 2025 Connaught Square Management Agreement.docx.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('36a9c696-bc85-43bc-86a8-59478572f932', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'contracts', 'Connaught Square Management Agreement.docx', 'contracts/Connaught Square Management Agreement.docx');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('d11cd003-42de-41ca-be0e-04e429faee46', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'contracts', '2025 Connaught Square Management Agreement.docx', 'contracts/2025 Connaught Square Management Agreement.docx');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('ee0ef165-e378-41ed-b2e4-bd1c5b227fd1', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'contracts', 'Signed Connaught Square Management Agreement.pdf', 'contracts/Signed Connaught Square Management Agreement.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('107990af-1d10-46e4-b7fb-f9439f3f8898', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'contracts', 'Contractors list.xlsx', 'contracts/Contractors list.xlsx');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('25e2b6c9-364e-4965-b640-9ce3a07323aa', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'contracts', 'Contractors list.xlsx', 'contracts/Contractors list.xlsx');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('17bff959-c11e-472e-89ec-3c866793c68b', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'contracts', 'EMERGENCY CALL OUT DETAILS 2024.pdf', 'contracts/EMERGENCY CALL OUT DETAILS 2024.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('941be061-5894-4ff6-aa1a-cca57db83dd7', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'contracts', 'CM434.PRO 2024-2025.pdf', 'contracts/CM434.PRO 2024-2025.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('943443e7-6c6d-44f3-82e2-593fb4de41cf', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'contracts', 'CM434.PRO.pdf', 'contracts/CM434.PRO.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('f7ec478d-5326-40b8-b2e4-3faedc97c6dd', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'contracts', 'Gas Contract 24-5.pdf', 'contracts/Gas Contract 24-5.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('bbdbdf06-3a0d-49c1-a585-0f9a59585bae', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'contracts', 'Contract_10-03-2025.pdf', 'contracts/Contract_10-03-2025.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('158d5d58-245d-4877-965b-d171dece9c5d', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'contracts', 'Gas Contract 25-26.pdf', 'contracts/Gas Contract 25-26.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('82208787-c2d5-446d-879d-540d13db015f', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'correspondence', 'Welcome Letter - CG1885574.pdf', 'correspondence/Welcome Letter - CG1885574.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('a1195523-f371-430c-b66c-57c21f102af2', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'contracts', 'Job 67141.pdf', 'contracts/Job 67141.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('978192a2-915e-4f94-8c61-f8ae9c7e392b', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'contracts', 'BLENHEIMS, 32-34 CONNAUGHT, W2 2HL - 19.05.23.pdf', 'contracts/BLENHEIMS, 32-34 CONNAUGHT, W2 2HL - 19.05.23.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('0d7fc9e7-332d-42da-9945-4c6cf4338ec8', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'contracts', 'BLENHEIMS, 32-34 CONNAUGHT, W2 2HL - 22.03.23.pdf', 'contracts/BLENHEIMS, 32-34 CONNAUGHT, W2 2HL - 22.03.23.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('75663d64-5304-4c34-b62a-5be15f8a6437', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'contracts', 'BLENHEIMS, 32-34 CONNAUGHT, W2 2HL - 26.06.23.pdf', 'contracts/BLENHEIMS, 32-34 CONNAUGHT, W2 2HL - 26.06.23.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('45713174-ba39-4b1e-aa46-04cd940283d4', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'contracts', 'BLENHEIMS, 32-34 CONNAUGHT, W2 2HL - 19.05.23.pdf', 'contracts/BLENHEIMS, 32-34 CONNAUGHT, W2 2HL - 19.05.23.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('4222e2f8-1a59-44e3-8768-75d54f2c6187', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'contracts', 'BLENHEIMS, 32-34 CONNAUGHT, W2 2HL - 22.03.23.pdf', 'contracts/BLENHEIMS, 32-34 CONNAUGHT, W2 2HL - 22.03.23.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('6ef068f4-f444-4b14-b501-91597451941e', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'contracts', 'BLENHEIMS, 32-34 CONNAUGHT, W2 2HL - 26.06.23.pdf', 'contracts/BLENHEIMS, 32-34 CONNAUGHT, W2 2HL - 26.06.23.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('34ca425d-2d00-4e96-8ee7-9a0c617ace5a', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'contracts', 'Jobcard_For_Job_No_27067_07-10-2024_1147.pdf', 'contracts/Jobcard_For_Job_No_27067_07-10-2024_1147.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('059e7985-9aaa-4c23-87a5-f707e73500a3', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'contracts', 'Jobcard_For_Job_No_19665_28-03-2024_0936.pdf', 'contracts/Jobcard_For_Job_No_19665_28-03-2024_0936.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('aa372a14-14e7-4caa-9486-cf4f337ee77e', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'contracts', 'Jobcard_For_Job_No_22634_03-07-2024_1649.pdf', 'contracts/Jobcard_For_Job_No_22634_03-07-2024_1649.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('99c3a2f4-2b6f-4059-9804-f980e24808b2', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'contracts', 'Jobcard_For_Job_No_25732_03-10-2024_1337.pdf', 'contracts/Jobcard_For_Job_No_25732_03-10-2024_1337.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('995d20bf-be00-4dfc-aab1-5f56797de1a2', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'contracts', 'Lift Contract-Jacksons lift.pdf', 'contracts/Lift Contract-Jacksons lift.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('ffae3db8-df46-4d08-a26a-6032e9d9e817', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'contracts', 'JLGCalloutVisit-5455045-12-07-2024.pdf', 'contracts/JLGCalloutVisit-5455045-12-07-2024.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('40e87607-4ea1-422e-8743-040753c43e2b', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'contracts', 'JLGCalloutVisit-5483206-26-10-2024.pdf', 'contracts/JLGCalloutVisit-5483206-26-10-2024.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('4d33c281-174c-42ff-ac9a-952ae3aa540d', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'contracts', 'JLGCalloutVisit-5498439-16-12-2024.pdf', 'contracts/JLGCalloutVisit-5498439-16-12-2024.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('f020f2e9-3784-40f3-9ea0-1ae17a0da056', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'contracts', 'JLGCalloutVisit-5455462-16-07-2024.pdf', 'contracts/JLGCalloutVisit-5455462-16-07-2024.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('8710d723-5bc0-41dc-af18-8b1d1598a242', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'contracts', 'JLGCalloutVisit-5497480-13-12-2024.pdf', 'contracts/JLGCalloutVisit-5497480-13-12-2024.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('33b841c7-f32b-4fe4-8645-853502a4f775', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'contracts', 'Engineering Report - 32-34 CONNAUGHT SQUARE.pdf', 'contracts/Engineering Report - 32-34 CONNAUGHT SQUARE.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('baaad021-243c-408e-b323-70e2acbeef80', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'contracts', 'Arch Directors and Officers Liability Insurance for Residents Associations (12.22).pdf', 'contracts/Arch Directors and Officers Liability Insurance for Residents Associations (12.22).pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('12c847db-a68c-4d4f-8fee-eb3428163274', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'contracts', 'StG_Policy Wording_32-34 Connaught Square W2 2HL.pdf', 'contracts/StG_Policy Wording_32-34 Connaught Square W2 2HL.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('21c3b507-aea6-415f-93e3-28cbdb42e273', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'compliance', 'Fire Extinguisher Signed Contract- Connaught Square.pdf', 'compliance/Fire Extinguisher Signed Contract- Connaught Square.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('cdfe0118-3c59-402e-90c4-4573e41ca5a9', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'contracts', 'Q51691 - 32-34 Connaught Square Contract.pdf', 'contracts/Q51691 - 32-34 Connaught Square Contract.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('6f7e7fd5-e8a1-44d8-bbba-39eef58ee99a', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'contracts', 'Engineering Report - 32-34 CONNAUGHT SQUARE.pdf', 'contracts/Engineering Report - 32-34 CONNAUGHT SQUARE.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('f71906cc-91c9-48cd-8731-d9f640fbd13e', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'compliance', 'Fire Alarm+Emergency Lighting Signed Contract-3234 Connaught Square.pdf', 'compliance/Fire Alarm+Emergency Lighting Signed Contract-3234 Connaught Square.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('19355680-b944-4cd2-a04a-2d82e82bd11f', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'compliance', 'Fire Alarm+Emergency Lighting Contract Connaught Square.pdf', 'compliance/Fire Alarm+Emergency Lighting Contract Connaught Square.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('66941480-29e4-4c4d-b7c7-3c82a157be2f', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'contracts', 'BT3205 03072025.pdf', 'contracts/BT3205 03072025.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('a24235bb-f80d-4039-b8fd-b2640f32c55f', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'contracts', 'FA7817 SERVICE 08042025.pdf', 'contracts/FA7817 SERVICE 08042025.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('fa78773f-a2e6-463d-880f-440a5025d149', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'contracts', 'Engineer Report - 32-34 Connaught Square Flat 5.pdf', 'contracts/Engineer Report - 32-34 Connaught Square Flat 5.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('3bd96522-4eec-4722-a281-78e7b11222f7', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'contracts', 'Engineering Report - 32-34 CONNAUGHT SQUARE.pdf', 'contracts/Engineering Report - 32-34 CONNAUGHT SQUARE.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('cc335859-1451-4bca-a838-aa2a8c23ef8a', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'contracts', 'Jobcard_For_Job_No_22171_14-05-2024_1202.pdf', 'contracts/Jobcard_For_Job_No_22171_14-05-2024_1202.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('4fdeb93b-bc64-4598-9db9-7794c67a7588', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'finance', 'British Gas Invoice-862451083.pdf', 'finance/British Gas Invoice-862451083.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('05effc0e-02e0-4905-b09d-fb37cbed0a6b', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'contracts', 'MT8825 03072025.pdf', 'contracts/MT8825 03072025.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('b88e197c-ce7b-4299-bfe3-a44ad7a99322', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'contracts', 'January Monthly Test For EL-Connaught Square.pdf', 'contracts/January Monthly Test For EL-Connaught Square.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('df748b94-a4ae-4c2a-87bc-a645af4c0f04', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'contracts', 'February Monthly Test For EL-Connaught Square.pdf', 'contracts/February Monthly Test For EL-Connaught Square.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path, entity_type, linked_entity_id) VALUES ('e747080c-beb0-4265-b4bb-9a056e7f75f3', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'major_works', 'External Decorations SOI - 28042025.docx', 'major_works/External Decorations SOI - 28042025.docx', 'major_works_project', '838f23a4-e2ba-4cbf-a318-0395f0188fb8');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path, entity_type, linked_entity_id) VALUES ('fe64e7d6-5feb-493c-8472-cd1d8242760b', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'major_works', 'External Dec SOE 03072025.docx', 'major_works/External Dec SOE 03072025.docx', 'major_works_project', '5f8faf93-bbff-4fd9-8cfb-2f83d4ce545d');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path, entity_type, linked_entity_id) VALUES ('ad9de0bf-b26a-478b-b02c-d125a9f5d924', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'major_works', 'Notice of intention for lift.docx', 'major_works/Notice of intention for lift.docx', 'major_works_project', '333e2c19-eaf5-4000-9809-73521215f769');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path, entity_type, linked_entity_id) VALUES ('9342e6c7-20ed-4f70-9753-98b0910203b1', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'major_works', 'Connaught Square (32-34) - 09.12.24 Schematic.pdf', 'major_works/Connaught Square (32-34) - 09.12.24 Schematic.pdf', 'major_works_project', 'e2ef6a7c-0f1e-40f5-8c5f-cd0610c55419');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('b20fda30-56ea-4f18-8355-492f3169e8d1', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'compliance', 'CGBI3964546XB6-Cunaku Construction Ltd-Business-Certificate of insurance.pdf', 'compliance/CGBI3964546XB6-Cunaku Construction Ltd-Business-Certificate of insurance.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('1a4b7439-5e1c-40e5-83f8-90fe639b8d39', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'compliance', 'CGBI3964546XB7-Cunaku Construction Ltd-Business-Certificate of insurance.pdf', 'compliance/CGBI3964546XB7-Cunaku Construction Ltd-Business-Certificate of insurance.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('6f5c104b-33a8-4c1b-9128-430e086e2cd3', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'compliance', 'Real Estate Insurance NTP (01.23).pdf', 'compliance/Real Estate Insurance NTP (01.23).pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('9780867f-539a-4191-b090-e04c7b31fc6c', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'compliance', 'Real Estate Policy (01.23).pdf', 'compliance/Real Estate Policy (01.23).pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('d5b3e74a-80d4-4389-8130-8861f44e1735', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'compliance', 'Summary of Cover (01.23).pdf', 'compliance/Summary of Cover (01.23).pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('1bcdd0c8-52f7-4a79-8c17-f0bea137b444', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'compliance', '2023 Allianz VOC - 32-34 Connuaght Square (Freehold) Limited.pdf', 'compliance/2023 Allianz VOC - 32-34 Connuaght Square (Freehold) Limited.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('8a008e20-3d8b-4c48-9865-32974ecda172', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'correspondence', '2023 Engineering Renewal Notice - 32 34 Connuaght Square (Freehold) Limited.pdf', 'correspondence/2023 Engineering Renewal Notice - 32 34 Connuaght Square (Freehold) Limited.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('fe96b9e0-5b27-4c48-b16d-91b7cc012c34', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'compliance', '32-34 Connaught Square Freehold Limited - Arch D&O Schedule.pdf', 'compliance/32-34 Connaught Square Freehold Limited - Arch D&O Schedule.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('d8cb035c-578b-4017-a112-c4765f9e3abe', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'compliance', '32-34 Connaught Sq Buildings Insurance 2023-2024.pdf', 'compliance/32-34 Connaught Sq Buildings Insurance 2023-2024.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('691f78a4-080d-46c5-8be4-1db87ad85ce5', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'compliance', 'Policy Limits Document.pdf', 'compliance/Policy Limits Document.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('f072b248-927d-4c91-925e-3a68d0e13b60', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'lease', 'Official Copy (Lease) 13.06.2003 - NGL823646-Flat 4.pdf', 'lease/Official Copy (Lease) 13.06.2003 - NGL823646-Flat 4.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('3054babd-fac7-46d7-ad54-72ea924e1d20', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'correspondence', 'Letter of Authority - Connaught Square.doc.pdf', 'correspondence/Letter of Authority - Connaught Square.doc.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('180b976d-ca21-4ef1-93cd-7f7c59b7f429', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'correspondence', 'Letter to report - Connaught Square.doc.pdf', 'correspondence/Letter to report - Connaught Square.doc.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('cf37076d-a2a1-4c3d-ad13-78587bc91b26', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'contracts', 'Pricing Quote - 32_34 Connaught Square Freehold Ltd - 109 - Gas - 10.03.2025.pdf', 'contracts/Pricing Quote - 32_34 Connaught Square Freehold Ltd - 109 - Gas - 10.03.2025.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('3ab23da7-3900-466f-a7cd-14d6f24208c6', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'compliance', 'Allianz - Lift Report 14.03.23.pdf', 'compliance/Allianz - Lift Report 14.03.23.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('0e261056-73a0-42df-95e6-afe35eb195b1', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'compliance', 'Allianz-Lift Report 18.03.2024.pdf', 'compliance/Allianz-Lift Report 18.03.2024.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('f450f4c5-404a-4135-b8d9-c5a5e341e1f6', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'compliance', 'Allianz - Lift Report - 15.09.21.pdf', 'compliance/Allianz - Lift Report - 15.09.21.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('77bba36e-9a5d-43f7-ba71-fca1e8f87277', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'compliance', 'Allianz - Lift Report 27.09.23.pdf', 'compliance/Allianz - Lift Report 27.09.23.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('014b14b9-50b8-4f04-9321-d473459d2272', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'compliance', 'Allianz - Lift Report 10.03.22.pdf', 'compliance/Allianz - Lift Report 10.03.22.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('41be723c-dc5a-43f1-b272-59cac05c2b71', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'compliance', 'Allianz - Lift Report 09.09.22.pdf', 'compliance/Allianz - Lift Report 09.09.22.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('8f61f0f4-98b1-4233-8617-3ea322cadeb6', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'compliance', 'LXBI3559280XB2-NEW STEP-Business-Certificate of insurance.pdf', 'compliance/LXBI3559280XB2-NEW STEP-Business-Certificate of insurance.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('1e3fa7af-780c-4130-b2f5-89268cda1a2f', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'compliance', '2023 Allianz VOC - 32-34 Connuaght Square (Freehold) Limited.pdf', 'compliance/2023 Allianz VOC - 32-34 Connuaght Square (Freehold) Limited.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('7a993e62-cea3-45c8-a277-7370227836ac', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'correspondence', '2023 Engineering Renewal Notice - 32 34 Connuaght Square (Freehold) Limited.pdf', 'correspondence/2023 Engineering Renewal Notice - 32 34 Connuaght Square (Freehold) Limited.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('d9d04241-e6db-4963-bf91-c2ab0812b2db', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'compliance', 'MO - Policy Wording - NZ0411.pdf', 'compliance/MO - Policy Wording - NZ0411.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('27c41cb3-6c5c-4b19-9ece-e004527ae67d', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'compliance', 'Feature and Benefits of Allianz Engineering Inspection Service.pdf', 'compliance/Feature and Benefits of Allianz Engineering Inspection Service.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('65d24700-af92-4274-9667-1eac17fed45f', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'compliance', 'StG_Insurer pack_32-34 Connaught Square Freehold Limited.pdf', 'compliance/StG_Insurer pack_32-34 Connaught Square Freehold Limited.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('ddb702e2-c7bc-4cf9-8f78-839f8b88a49c', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'compliance', 'StG_Statement of Facts_32-34 Connaught Square W2 2HL.pdf', 'compliance/StG_Statement of Facts_32-34 Connaught Square W2 2HL.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('cc257a48-a3b8-4b5c-8da6-fe311b9310df', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'compliance', 'StG_Insurance Report_32-34 Connaught Square W2 2HL.pdf', 'compliance/StG_Insurance Report_32-34 Connaught Square W2 2HL.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('d13c6c9a-56ef-4981-b885-6b5b3949b9c9', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'compliance', 'StG_Insurer pack_32-34 Connaught Square Freehold Limited.pdf', 'compliance/StG_Insurer pack_32-34 Connaught Square Freehold Limited.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('cb352f99-5414-43d5-a60d-0ad9e24784ed', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'compliance', 'StG_Statement of Facts_32-34 Connaught Square W2 2HL.pdf', 'compliance/StG_Statement of Facts_32-34 Connaught Square W2 2HL.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('5f97e8cb-30c0-4900-ac0f-0af236f91221', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'compliance', 'StG_Insurance Report_32-34 Connaught Square W2 2HL.pdf', 'compliance/StG_Insurance Report_32-34 Connaught Square W2 2HL.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('bc99cb67-bcb4-4486-9425-0280ec45a789', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'finance', 'StG_Invoice_32-34 Connaught Square W2 2HL.pdf', 'finance/StG_Invoice_32-34 Connaught Square W2 2HL.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('15b2af0d-44ce-4cb4-9d68-a1688828bd2b', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'compliance', 'StG_Certificate_32-34 Connaught Square W2 2HL.pdf', 'compliance/StG_Certificate_32-34 Connaught Square W2 2HL.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('e4ed8e5d-2cf0-4cec-b628-6c3bbfbd7153', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'compliance', 'StG_Insurer pack_32-34 Connaught Square Freehold Limited.pdf', 'compliance/StG_Insurer pack_32-34 Connaught Square Freehold Limited.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('fb78332f-97bc-4a63-b343-5e6a7577719c', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'compliance', 'StG_Statement of Fact_32-34 Connaught Square W2 2HL.pdf', 'compliance/StG_Statement of Fact_32-34 Connaught Square W2 2HL.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('52ca4b1f-4803-4ff6-9c10-2ae465be7e64', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'finance', 'StG_Invoice_32-34 Connaught Square Freehold Limited.pdf', 'finance/StG_Invoice_32-34 Connaught Square Freehold Limited.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('3dcadd48-36dd-4304-bb23-773978091c09', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'compliance', '32-34 Connaught Square Freehold Limited - Arch D&O Schedule.pdf', 'compliance/32-34 Connaught Square Freehold Limited - Arch D&O Schedule.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('d6ca2c9f-0f53-4b5d-92f1-4bc940c55218', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'compliance', 'StG_Certificate_32-34 Connaught Square Freehold Limited.pdf', 'compliance/StG_Certificate_32-34 Connaught Square Freehold Limited.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('050ac727-7ed0-4d5d-b0b5-041801961db8', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'compliance', 'StG_Policy Wording_32-34 Connaught Square Freehold Limited.pdf', 'compliance/StG_Policy Wording_32-34 Connaught Square Freehold Limited.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('bd8f9cab-eb87-4cef-9c65-3b0a71b66c71', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'compliance', 'StG_D&O Endorsements_32-34 Connaught Square Freehold Limited.pdf', 'compliance/StG_D&O Endorsements_32-34 Connaught Square Freehold Limited.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('1230b90a-d38f-4e63-be6d-82c50721c7d0', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'finance', 'StG_Demands & Needs_32-34 Connaught Square Freehold Limited.pdf', 'finance/StG_Demands & Needs_32-34 Connaught Square Freehold Limited.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('dc8b1a70-3149-4572-9ec6-1f35aabb2d1c', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'contracts', 'StG_Quote_32-34 Connaught Square Freehold Limited.pdf', 'contracts/StG_Quote_32-34 Connaught Square Freehold Limited.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('22efeeb9-6723-4d31-bcec-37fc189d922d', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'compliance', 'StG_Insurance Report_32-34 Connaught Square W2 2HL.pdf', 'compliance/StG_Insurance Report_32-34 Connaught Square W2 2HL.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('f386dbb8-c615-40ef-821e-837f320614cc', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'compliance', 'FBR113382303-20230405-B.pdf', 'compliance/FBR113382303-20230405-B.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('cee5783e-502a-4035-a3f1-d73a9a96f440', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'compliance', 'Real Estate Insurance NTP (01.23).pdf', 'compliance/Real Estate Insurance NTP (01.23).pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('2f53e417-365e-46c4-a0ae-083f51697a19', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'compliance', 'Real Estate Policy (01.23).pdf', 'compliance/Real Estate Policy (01.23).pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('2a1d5962-94aa-48df-a61e-7f885df884a3', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'compliance', 'Summary of Cover (01.23).pdf', 'compliance/Summary of Cover (01.23).pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('5d67d17d-3a94-4061-96ac-5231e53fbbef', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'compliance', '32-34 Connaught Sq Buildings Insurance 2023-2024.pdf', 'compliance/32-34 Connaught Sq Buildings Insurance 2023-2024.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('73c94f4b-1b6b-455c-a09d-c76456251674', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'compliance', 'Policy Limits Document.pdf', 'compliance/Policy Limits Document.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('c35632bc-14c9-4433-b2b0-8d45f50ca2fc', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'compliance', 'Zurich Real Estate Policy Summary.pdf', 'compliance/Zurich Real Estate Policy Summary.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('44730fbd-dee0-47c7-bde3-7ac33f51d9e9', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'compliance', 'Zurich Real Estate Policy Wording.pdf', 'compliance/Zurich Real Estate Policy Wording.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('9766aa6e-3afc-4826-bf87-944644694f71', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'compliance', 'Zurich Real Estate Insurance NTP (01.23) ZCYP895.02.pdf', 'compliance/Zurich Real Estate Insurance NTP (01.23) ZCYP895.02.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('7fa9ed0c-1cd7-4273-a89e-5ce4f1c4610e', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'finance', 'StG_Invoice_32-34 Connaught Square W2 2HL.pdf', 'finance/StG_Invoice_32-34 Connaught Square W2 2HL.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('c706c559-8d4f-4121-a775-c35d659ff28b', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'compliance', 'StG_Certificate_32-34 Connaught Square W2 2HL.pdf', 'compliance/StG_Certificate_32-34 Connaught Square W2 2HL.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('8907d555-4647-4165-951a-88c0f14e76cc', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'compliance', 'StG_Supporting Docs_32-34 Connaught Square W2 2HL.pdf', 'compliance/StG_Supporting Docs_32-34 Connaught Square W2 2HL.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('a03961ca-a781-4dc4-8142-1088c8eb4879', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'finance', 'StG_Invoice_32-34 Connaught Square W2 2HL.pdf', 'finance/StG_Invoice_32-34 Connaught Square W2 2HL.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('1de16f23-3f16-4673-818a-71c745ce84dc', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'compliance', 'StG_Certificate_32-34 Connaught Square W2 2HL.pdf', 'compliance/StG_Certificate_32-34 Connaught Square W2 2HL.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('7545252c-8322-470a-8034-11b9db12761d', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'compliance', 'StG_Statement of Fact_32-34 Connaught Square W2 2HL.pdf', 'compliance/StG_Statement of Fact_32-34 Connaught Square W2 2HL.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('3e310fca-130f-401d-a608-33b1fab7fe68', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'finance', 'StG_Invoice_32-34 Connaught Square W2 2HL.pdf', 'finance/StG_Invoice_32-34 Connaught Square W2 2HL.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('befb70f2-23db-49de-945d-18999893afb3', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'compliance', 'StG_Statement of Fact_32-34 Connaught Square W2 2HL.pdf', 'compliance/StG_Statement of Fact_32-34 Connaught Square W2 2HL.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('4a28ac2d-ebb8-4d13-a6ed-8c0ac80446ac', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'uncategorised', 'Connaught Square New property information.xlsx', 'uncategorised/Connaught Square New property information.xlsx');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('afc8e8ae-17da-4a99-a79b-cf248627a1d4', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'uncategorised', 'Connaught Square Meeting Minutes 2.docx', 'uncategorised/Connaught Square Meeting Minutes 2.docx');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('3bccf424-db05-4adf-8075-4a6d9936da0e', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'uncategorised', 'connaught.xlsx', 'uncategorised/connaught.xlsx');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('2df578e9-9b5a-45c4-9703-33fd77eb14d0', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'uncategorised', 'matrix - pp.xlsx', 'uncategorised/matrix - pp.xlsx');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('fb972fa5-e936-4f4a-b536-b8d3e8b85d54', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'uncategorised', '12. Change of Tenancy - EDF supporting document.docx', 'uncategorised/12. Change of Tenancy - EDF supporting document.docx');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('6b0d2014-df7f-44f2-a815-1e09e9ff9456', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'correspondence', 'Correspondence letter.pdf', 'correspondence/Correspondence letter.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('3d0ec0b5-bb1b-485f-90f9-254c86ab3646', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'uncategorised', 'tenant list - pp.xlsx', 'uncategorised/tenant list - pp.xlsx');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('24afbdd2-edab-48de-8afc-cf96b9938bd9', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'uncategorised', 'Report - 32-34 Connaught Square BCH 78350.pdf', 'uncategorised/Report - 32-34 Connaught Square BCH 78350.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('8eee3ee8-7d04-4e4d-8f99-239942d9c900', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'uncategorised', 'Connaught Square Meeting Minutes 2.docx', 'uncategorised/Connaught Square Meeting Minutes 2.docx');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('c6b057b1-0cb2-4ff0-89fd-40588df4d7d6', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'uncategorised', 'Connaught Square Meeting Minutes 20241120.docx', 'uncategorised/Connaught Square Meeting Minutes 20241120.docx');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('55ca553a-05d7-4c0f-9e37-ea4dbc619c83', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'uncategorised', 'Connaught Square Meeting Minutes.docx', 'uncategorised/Connaught Square Meeting Minutes.docx');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('c159b0aa-df23-4adc-9b76-6abbe9780645', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'uncategorised', 'Connaught Square Admin Duties of Co Sec.docx', 'uncategorised/Connaught Square Admin Duties of Co Sec.docx');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('7742ebd9-038a-4870-81b9-afb676350131', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'uncategorised', 'Signed Connaught Square Admin Duties of Co Sec.pdf', 'uncategorised/Signed Connaught Square Admin Duties of Co Sec.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('0b1d8f18-1693-43f9-9467-6a16bdec8cc8', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'uncategorised', '32_34 CONNAUGHT SQUARE FREEHOLD LIMITED - Statutory Registers on 22.03.2024.pdf', 'uncategorised/32_34 CONNAUGHT SQUARE FREEHOLD LIMITED - Statutory Registers on 22.03.2024.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('7daa59f2-1d5d-45ff-ad39-3f96c795d07e', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'correspondence', 'Memorandum of Association.pdf', 'correspondence/Memorandum of Association.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('463951f1-971f-4681-88c6-7e8641cf394a', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'uncategorised', 'Incorporation documents.pdf', 'uncategorised/Incorporation documents.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('6bf99828-bc8b-4470-85b4-ae9cd151b0bf', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'uncategorised', 'B25676 RS 21.05.24 RM CM.pdf', 'uncategorised/B25676 RS 21.05.24 RM CM.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('e2b8791d-face-4c86-844b-ba9b0cc52632', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'uncategorised', 'Report-20.08.2024.pdf', 'uncategorised/Report-20.08.2024.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('b7ad9464-e335-4948-b6e5-642cb6e4c995', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'correspondence', 'PN0119V1.7 Privacy Notice (Website).pdf', 'correspondence/PN0119V1.7 Privacy Notice (Website).pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('1d6fb5c9-a2fd-40fa-8425-ed2f4c25c35d', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'correspondence', 'PN0119V1.8 Privacy Notice (Website).pdf', 'correspondence/PN0119V1.8 Privacy Notice (Website).pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('d7aefb16-0bff-4f68-aac1-ab8cd6d4d858', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'uncategorised', 'REPORT 31-07-25.pdf', 'uncategorised/REPORT 31-07-25.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('08c57d46-a573-412e-b3ba-55e3aea075e7', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'uncategorised', '32-34 Connought Square Condtion Assessments.pdf', 'uncategorised/32-34 Connought Square Condtion Assessments.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('a79fb87b-d70a-4a8f-8ec5-9e9491f62dfd', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'uncategorised', 'Signed Conract.pdf', 'uncategorised/Signed Conract.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('159cafc1-192f-4221-b0cb-80b66f65b489', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'uncategorised', 'BLENHEIMS, CONNAUGHT, W2 2HL PHOTO - 22.01.24.pdf', 'uncategorised/BLENHEIMS, CONNAUGHT, W2 2HL PHOTO - 22.01.24.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('759ba962-3bf6-4d49-9bc1-62d1658b6724', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'uncategorised', 'BLENHEIMS, CONNAUGHT, W2 2HL PHOTO - 22.03.24.pdf', 'uncategorised/BLENHEIMS, CONNAUGHT, W2 2HL PHOTO - 22.03.24.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('81151c9b-86b4-4163-b647-4e4bbeebb9a6', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'uncategorised', 'Latest Report.pdf', 'uncategorised/Latest Report.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('53e29f3b-7d31-4a4c-8b5f-b5b9dbd43855', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'uncategorised', 'Latest Report 24.04.2024.pdf', 'uncategorised/Latest Report 24.04.2024.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('5e7cc38b-1a5a-43f3-a799-b119870c5896', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'uncategorised', 'Latest Report 19.09.2024.pdf', 'uncategorised/Latest Report 19.09.2024.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('6baa6b8c-4dc9-4e9c-8a0a-67b9ee4b97f8', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'uncategorised', 'BLENHEIMS, 32-34 CONNAUGHT, W2 2HL - 25.09.23.pdf', 'uncategorised/BLENHEIMS, 32-34 CONNAUGHT, W2 2HL - 25.09.23.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('d6bf76b0-be87-49a7-9e09-7f48a8524a6c', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'uncategorised', 'BLENHEIMS, 32-34 CONNAUGHT, W2 2HL PHOTO - 29.11.23.pdf', 'uncategorised/BLENHEIMS, 32-34 CONNAUGHT, W2 2HL PHOTO - 29.11.23.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('31a83e79-d1e5-40ed-b5db-7a1bcba9d354', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'uncategorised', 'BLENHEIMS, 32-34 CONNAUGHT, W2 2HL PHOTO - 18.12.23.pdf', 'uncategorised/BLENHEIMS, 32-34 CONNAUGHT, W2 2HL PHOTO - 18.12.23.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('56a1d30a-3d0e-4a3d-af76-ac391852b70f', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'uncategorised', 'BLENHEIMS, CONNAUGHT, W2 2HL PHOTO - 23.02.24.pdf', 'uncategorised/BLENHEIMS, CONNAUGHT, W2 2HL PHOTO - 23.02.24.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('08457d7f-7a92-4b17-bf18-99a9f1c24877', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'uncategorised', '10.02.25-Pest Control.pdf', 'uncategorised/10.02.25-Pest Control.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('a3ab9aa0-23cc-4c0b-84f9-0ba9cee8f606', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'uncategorised', 'Latest Report.pdf', 'uncategorised/Latest Report.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('0e98faa4-ce1a-4f8e-a02f-9b5446b82821', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'uncategorised', '17.01.2025-Pest Control.pdf', 'uncategorised/17.01.2025-Pest Control.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('e7d4db0e-747e-4266-b048-c59068d9976b', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'uncategorised', 'J18503 - MIH, CONNAUGHT SQR, W2 - 04.04.25.pdf', 'uncategorised/J18503 - MIH, CONNAUGHT SQR, W2 - 04.04.25.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('0e5e4cde-1e33-4d65-a2aa-06ccd725d063', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'uncategorised', 'J18502 - MIH, CONNAUGHT SQR, W2 - 04.04.25.pdf', 'uncategorised/J18502 - MIH, CONNAUGHT SQR, W2 - 04.04.25.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('d42a6d4a-6e43-4041-afaa-11026e7d1998', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'uncategorised', 'BLENHEIMS, CONNAUGHT, W2 2HL PHOTO - 22.01.24.pdf', 'uncategorised/BLENHEIMS, CONNAUGHT, W2 2HL PHOTO - 22.01.24.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('342ea87d-da19-4e79-8ac8-58fd06271c69', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'uncategorised', 'BLENHEIMS, CONNAUGHT, W2 2HL PHOTO - 22.03.24.pdf', 'uncategorised/BLENHEIMS, CONNAUGHT, W2 2HL PHOTO - 22.03.24.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('f94c3144-b5da-47bd-ab32-318dbd40923f', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'uncategorised', 'BLENHEIMS, 32-34 CONNAUGHT, W2 2HL - 25.09.23.pdf', 'uncategorised/BLENHEIMS, 32-34 CONNAUGHT, W2 2HL - 25.09.23.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('c25ab3a3-f471-4bf0-8941-35edd9b4a68b', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'uncategorised', 'BLENHEIMS, 32-34 CONNAUGHT, W2 2HL PHOTO - 29.11.23.pdf', 'uncategorised/BLENHEIMS, 32-34 CONNAUGHT, W2 2HL PHOTO - 29.11.23.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('49461d64-5d51-4ac9-9ba5-c847279d36f9', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'uncategorised', 'BLENHEIMS, 32-34 CONNAUGHT, W2 2HL PHOTO - 18.12.23.pdf', 'uncategorised/BLENHEIMS, 32-34 CONNAUGHT, W2 2HL PHOTO - 18.12.23.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('da4147d0-45a6-4f55-bc38-62e02922bf60', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'uncategorised', 'BLENHEIMS, CONNAUGHT, W2 2HL PHOTO - 23.02.24.pdf', 'uncategorised/BLENHEIMS, CONNAUGHT, W2 2HL PHOTO - 23.02.24.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('1d9769db-b3e7-4ae1-961a-46c843b3cf51', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'uncategorised', 'INV 11546 Mr Martin Samworth.xlsx', 'uncategorised/INV 11546 Mr Martin Samworth.xlsx');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('242f28bf-aa94-4776-bb21-d5507d89257f', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'uncategorised', 'QB4126 Mr Martin Samworth.docx', 'uncategorised/QB4126 Mr Martin Samworth.docx');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('aa9393cf-bbae-4ee6-be2a-f70d63b0e83e', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'uncategorised', 'CQ2879 Mr Martin Samworth   (IP) CCTV.docx', 'uncategorised/CQ2879 Mr Martin Samworth   (IP) CCTV.docx');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('ae1c1453-1b9e-414b-8364-569e18b98d20', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'uncategorised', 'Asset_Record_For_Job_No_32810_17-03-2025_1311.pdf', 'uncategorised/Asset_Record_For_Job_No_32810_17-03-2025_1311.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('6a0c44b4-a1a9-4e9b-b085-677bce964942', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'uncategorised', 'Asset_Record_For_Job_No_32344_12-03-2025_1426.pdf', 'uncategorised/Asset_Record_For_Job_No_32344_12-03-2025_1426.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('dedbf625-0b21-4a8a-947d-b4e0ba696822', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'uncategorised', 'Asset_Record_For_Job_No_37675_25-07-2025_1549.pdf', 'uncategorised/Asset_Record_For_Job_No_37675_25-07-2025_1549.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('eebe57b4-78f4-42f6-a0e8-b3e619468a25', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'uncategorised', 'Asset_Record_For_Job_No_34012_01-05-2025_1616.pdf', 'uncategorised/Asset_Record_For_Job_No_34012_01-05-2025_1616.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('720e56cd-b0a3-498e-ab64-4c5e3a994793', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'uncategorised', 'Asset_Record_For_Job_No_32759_17-03-2025_1147.pdf', 'uncategorised/Asset_Record_For_Job_No_32759_17-03-2025_1147.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('df9dffea-b92e-41c3-99d2-be22a47359d5', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'uncategorised', 'Jobcard_For_Job_No_32344_12-03-2025_1426.pdf', 'uncategorised/Jobcard_For_Job_No_32344_12-03-2025_1426.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('3b082e25-5c3d-4551-9ded-fc89ecaead80', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'uncategorised', 'Asset_Record_For_Job_No_33844_07-04-2025_1143.pdf', 'uncategorised/Asset_Record_For_Job_No_33844_07-04-2025_1143.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('98a8a12a-55ab-44ac-a9ce-a9f729aa1eaa', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'uncategorised', 'Asset_Record_For_Job_No_25732_03-10-2024_1337.pdf', 'uncategorised/Asset_Record_For_Job_No_25732_03-10-2024_1337.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('b09f0b66-5c75-45e6-8a84-bd3b64e36f8a', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'uncategorised', 'Asset_Record_For_Job_No_22634_03-07-2024_1650.pdf', 'uncategorised/Asset_Record_For_Job_No_22634_03-07-2024_1650.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('4b2a9e3a-9731-4fdf-b8f0-341e8e8bc7e0', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'uncategorised', 'Asset_Record_For_Job_No_27067_07-10-2024_1147.pdf', 'uncategorised/Asset_Record_For_Job_No_27067_07-10-2024_1147.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('fec20efa-0863-4f84-96cb-74aa436791b5', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'uncategorised', 'Asset_Record_For_Job_No_19665_05-04-2024_1048.pdf', 'uncategorised/Asset_Record_For_Job_No_19665_05-04-2024_1048.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('1d6a95bf-5b19-4cf3-9b9a-662a0f6e1a30', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'contracts', 'Connaught Square-Lift Quotes.xlsx', 'contracts/Connaught Square-Lift Quotes.xlsx');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('0bd54350-baef-4190-8b6e-471e69f2b23d', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'uncategorised', 'LXBI3559280XB2-NEW STEP-Business-Certificate of el insurance.pdf', 'uncategorised/LXBI3559280XB2-NEW STEP-Business-Certificate of el insurance.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('1026567e-d0c0-40f4-804e-5e1919c2a53e', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'uncategorised', 'New Step - Cleaning of Com Part- Jan- 2023.pdf', 'uncategorised/New Step - Cleaning of Com Part- Jan- 2023.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('901d75e3-09ee-483d-89fe-8c51904f9775', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'uncategorised', 'Aged debtors by property.pdf', 'uncategorised/Aged debtors by property.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('06251e18-287d-4458-a9c8-22ef5edc5766', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'uncategorised', 'Connaught Square, 32-34 Approved xlsx.xlsx', 'uncategorised/Connaught Square, 32-34 Approved xlsx.xlsx');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('8e2ad1d1-e64d-45a0-a23a-247cf3d83954', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'uncategorised', 'BvA 24 Jan 25.xlsx', 'uncategorised/BvA 24 Jan 25.xlsx');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('5ed63939-2bd0-4460-988b-9a862478bb5c', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'uncategorised', 'pdf.pdf', 'uncategorised/pdf.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('fb92fe76-e604-4134-8c39-364a9be782e9', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'uncategorised', 'Connaught Square-Agenda 20.11.24.docx', 'uncategorised/Connaught Square-Agenda 20.11.24.docx');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('02cd89ff-47fc-48fe-8de9-643c5d3d7b82', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'uncategorised', 'Connaught Square-Agenda 26.04.2024.docx', 'uncategorised/Connaught Square-Agenda 26.04.2024.docx');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('ec17e3ed-e54d-4322-aa4a-80e0914928cd', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'uncategorised', 'Connaught Square 26.04.24.docx', 'uncategorised/Connaught Square 26.04.24.docx');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('c695e51f-a399-4f83-97d9-c666bbc04456', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'contracts', 'StG_Quote_32-34 Connaught Square W2 2HL.pdf', 'contracts/StG_Quote_32-34 Connaught Square W2 2HL.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('38c67102-9d25-48e2-a6d8-f1f8efaa7ad9', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'uncategorised', 'StG_Policy Wording_32-34 Connaught Square W2 2HL.pdf', 'uncategorised/StG_Policy Wording_32-34 Connaught Square W2 2HL.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('0e05d8ce-edda-4534-887d-73347ce5dfdd', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'contracts', 'StG_Quote_32-34 Connaught Square W2 2HL.pdf', 'contracts/StG_Quote_32-34 Connaught Square W2 2HL.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('a6824afd-72c0-4d54-b329-c7363e85e354', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'uncategorised', 'StG_Policy Wording_32-34 Connaught Square W2 2HL.pdf', 'uncategorised/StG_Policy Wording_32-34 Connaught Square W2 2HL.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('730d1239-2d4c-4c2b-ae1d-ac40befcbc15', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'uncategorised', 'Report - 32-34 Connaught Square BCH 78350.pdf', 'uncategorised/Report - 32-34 Connaught Square BCH 78350.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('7b04c4f0-e015-4fb0-92c5-b556330b103e', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'uncategorised', 'Asset_Record_For_Job_No_16617_27-11-2023_1522.pdf', 'uncategorised/Asset_Record_For_Job_No_16617_27-11-2023_1522.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('1e7eeb0c-2ba4-4a83-8fc4-27a0fdb71d2b', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'uncategorised', 'Asset_Record_For_Job_No_16808_28-11-2023_1340.pdf', 'uncategorised/Asset_Record_For_Job_No_16808_28-11-2023_1340.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('ad45ff9f-fdea-4727-a7db-5b56ad2fc3cc', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'uncategorised', 'EX-NC (CONNAUGHT SQUARE) EXTRA 01102024.pdf', 'uncategorised/EX-NC (CONNAUGHT SQUARE) EXTRA 01102024.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('d3d8509b-1211-4bf6-aa6f-9dfbf0429393', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'uncategorised', 'H&S recomendations - Spreadsheet with comments.xlsx', 'uncategorised/H&S recomendations - Spreadsheet with comments.xlsx');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('803866ba-6f59-4601-8fd2-f57cdeff15e0', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'uncategorised', 'CM434 RS 32-34 Connaught Square - VISIT 1 OF 2 - 30-04-25.pdf', 'uncategorised/CM434 RS 32-34 Connaught Square - VISIT 1 OF 2 - 30-04-25.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('35c8edfc-b2cf-4d69-9913-da2ed5d95e00', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'uncategorised', 'Q49511 - 32-34 Connaught Square.pdf', 'uncategorised/Q49511 - 32-34 Connaught Square.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('505e6045-29b9-4525-b447-4a3955b81d15', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'uncategorised', 'FA7817 CALL OUT 26032025.pdf', 'uncategorised/FA7817 CALL OUT 26032025.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('fcfd0d6d-9677-42c5-a536-3ba0cc4dc218', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'uncategorised', '32 Connaught Sq - PAT .pdf', 'uncategorised/32 Connaught Sq - PAT .pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('21bd7c03-3ba4-494a-a264-ea59dcc5dfd3', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'uncategorised', 'Asset_Record_For_Job_No_35146_03-06-2025_0906.pdf', 'uncategorised/Asset_Record_For_Job_No_35146_03-06-2025_0906.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('846f5e67-b3f6-443d-bc16-45f2fa58b91e', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'uncategorised', 'Asset_Record_For_Job_No_31162_30-01-2025_1603.pdf', 'uncategorised/Asset_Record_For_Job_No_31162_30-01-2025_1603.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('3ed251c2-b788-4744-8882-b52b7deefd45', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'uncategorised', 'Asset_Record_For_Job_No_37675_25-07-2025_1549.pdf', 'uncategorised/Asset_Record_For_Job_No_37675_25-07-2025_1549.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('238778b8-7ef3-4a99-afc8-6e4dfd263930', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'uncategorised', 'Asset_Record_For_Job_No_28737_25-11-2024_0907.pdf', 'uncategorised/Asset_Record_For_Job_No_28737_25-11-2024_0907.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('48e27619-d49e-42c3-acd7-600f2e103ddf', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'uncategorised', 'Asset_Record_For_Job_No_35402_03-06-2025_0916.pdf', 'uncategorised/Asset_Record_For_Job_No_35402_03-06-2025_0916.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('0e10b5b2-cea9-47ec-bee2-9cf01feb1fbc', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'uncategorised', 'Asset_Record_For_Job_No_22171_14-05-2024_1202.pdf', 'uncategorised/Asset_Record_For_Job_No_22171_14-05-2024_1202.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('413f9b4b-f4b0-453f-88cb-191eaf01a457', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'uncategorised', 'Asset_Record_For_Job_No_35654_03-06-2025_0912.pdf', 'uncategorised/Asset_Record_For_Job_No_35654_03-06-2025_0912.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('bfc182dc-08ed-42a1-92ea-586bd137e2d2', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'uncategorised', 'Asset_Record_For_Job_No_38609_26-08-2025_0740.pdf', 'uncategorised/Asset_Record_For_Job_No_38609_26-08-2025_0740.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('3aba1c6f-8f80-4a4a-9def-217cfb685729', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'uncategorised', 'Asset_Record_For_Job_No_36465_20-06-2025_1038.pdf', 'uncategorised/Asset_Record_For_Job_No_36465_20-06-2025_1038.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('ba7deac7-23c3-4c85-b1e4-f2d727678b23', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'uncategorised', '26368 Report.pdf', 'uncategorised/26368 Report.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('02675f53-81e2-44a7-a4ba-701ce2f8c784', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'uncategorised', '26474 Report.pdf', 'uncategorised/26474 Report.pdf');

-- Insert 26 apportionments
INSERT INTO apportionments (id, building_id, percentage) VALUES ('2a8011b7-d8d1-447c-921a-7959765a3338', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 32.0);
INSERT INTO apportionments (id, building_id, percentage) VALUES ('eb78060b-54cf-4ec4-a19a-4d0c262739c9', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 10.0);
INSERT INTO apportionments (id, building_id, percentage) VALUES ('c11e222a-d68e-4abc-b7aa-5699529d0d04', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 32.0);
INSERT INTO apportionments (id, building_id, percentage) VALUES ('58005b13-29c8-4d89-873b-ff0f28cffa31', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 19.0);
INSERT INTO apportionments (id, building_id, percentage) VALUES ('abe98337-0eb6-4b75-98b4-8fe203d0da94', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 2.0);
INSERT INTO apportionments (id, building_id, percentage) VALUES ('3c6ee0f1-e985-462d-8865-047fc88338da', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 2.0);
INSERT INTO apportionments (id, building_id, percentage) VALUES ('c4a437f1-2fd6-4e49-a141-2ec7a813cb22', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 2.0);
INSERT INTO apportionments (id, building_id, percentage) VALUES ('5cf3e1c7-457e-4786-8700-141831121ca4', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 2.0);
INSERT INTO apportionments (id, building_id, percentage) VALUES ('21c29a33-647e-4460-9b86-6aa72130dcde', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 2.0);
INSERT INTO apportionments (id, building_id, percentage) VALUES ('3bbe42e6-7eba-4211-be0d-7aa3c04f8178', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 8.0);
INSERT INTO apportionments (id, building_id, percentage) VALUES ('8c785f0e-35ba-4321-a939-1ecf4eff0c1c', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 3.0);
INSERT INTO apportionments (id, building_id, percentage) VALUES ('9c372b4d-3b51-48a2-a972-e3519673e8eb', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 3.0);
INSERT INTO apportionments (id, building_id, percentage) VALUES ('40e94e95-3007-4584-8992-dc8a96fbad77', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 3.0);
INSERT INTO apportionments (id, building_id, percentage) VALUES ('f0be2add-4a23-4c7e-b6c7-4ece9a4992fd', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 3.0);
INSERT INTO apportionments (id, building_id, percentage) VALUES ('0d0c452e-89a4-4c62-9222-78986b4baa2c', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 3.0);
INSERT INTO apportionments (id, building_id, percentage) VALUES ('02115cbd-fc71-4c51-a11c-2f4dbab842d7', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 3.0);
INSERT INTO apportionments (id, building_id, percentage) VALUES ('36a041d9-403a-4738-ba21-b0afbf4b6496', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 3.0);
INSERT INTO apportionments (id, building_id, percentage) VALUES ('dda148e7-898c-4ce4-a19a-93aca200335e', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 3.0);
INSERT INTO apportionments (id, building_id, percentage) VALUES ('5a96ea66-552f-4392-bd91-f2f9b568affb', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 8.0);
INSERT INTO apportionments (id, building_id, percentage) VALUES ('882f7c87-2c13-49b2-8c82-07d3b23fdbf6', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 3.0);
INSERT INTO apportionments (id, building_id, percentage) VALUES ('f9760716-4355-4b8b-b2c9-2262f9fac9bb', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 8.0);
INSERT INTO apportionments (id, building_id, percentage) VALUES ('94e260ff-e256-419f-a0a9-622c395be7de', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 8.0);
INSERT INTO apportionments (id, building_id, percentage) VALUES ('0d18e547-37cf-4de7-bea9-28ded00ad412', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 8.0);
INSERT INTO apportionments (id, building_id, percentage) VALUES ('19103473-dc2e-4bdb-9425-2fa498d91542', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 8.0);
INSERT INTO apportionments (id, building_id, percentage) VALUES ('78bf3524-3a66-4a6a-9fdd-4822730ebfdd', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 8.0);
INSERT INTO apportionments (id, building_id, percentage) VALUES ('19176154-66b5-4711-818d-7627b712c55b', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 8.0);

-- Insert 131 insurance records
INSERT INTO building_insurance (id, building_id, policy_number, insurance_type) VALUES ('6ec0d69b-8ea6-44bb-bddd-4af0946675af', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'CGBI3964546XB', 'general');
INSERT INTO building_insurance (id, building_id, policy_number, insurance_type) VALUES ('09630a16-7e59-4c2a-99d9-bac79400f472', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'CGBI3964546XB', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('44c890a4-4723-497e-849d-7b0472d6006a', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('01e4123e-de22-4209-8b86-adfb79edda7a', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('47ecd684-70a3-4baf-b4bf-19862cba9dca', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'general');
INSERT INTO building_insurance (id, building_id, policy_number, insurance_type) VALUES ('cbbbfa2f-068b-412c-9abf-cf9afc080d20', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'and', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('95ad030b-b96c-47ce-8e10-22b678d52b99', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('c55c7568-a19a-4fdf-89b0-7c4e93f61c3e', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('5ab14461-9630-4238-a3be-91828c6e5d38', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'general');
INSERT INTO building_insurance (id, building_id, policy_number, insurance_type) VALUES ('58f6bca4-2f29-4319-8e2d-31bcee3cf75f', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'NZ23346712', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('29d37010-c9c2-46b0-9c6c-3417924bb731', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('2c8d52d3-6bab-4eb7-969a-12a92b74ae74', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('52dc5b96-7fa1-4530-b3e5-3cacab2f2ad2', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('fbf5e738-12d6-4dc1-a504-ccbffe79ec1c', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('9b4b1a6e-4301-47af-9303-65de721db7bf', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'general');
INSERT INTO building_insurance (id, building_id, policy_number, insurance_type) VALUES ('efb107a4-9a65-4b72-9172-9e2667df0f00', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'ARCH', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('5eea7713-1566-4d44-9f1e-7e7cc7459ed5', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('4abf33a6-0564-40a7-915d-e252ad3694db', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('bdbe0b0e-0265-48c3-bad1-7d397cb641d0', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('398c3702-80eb-46ef-b6ba-faec964430fd', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'general');
INSERT INTO building_insurance (id, building_id, policy_number, insurance_type) VALUES ('3fec9374-1fff-4928-96eb-893ab4aab0b6', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'FU117816', 'general');
INSERT INTO building_insurance (id, building_id, policy_number, insurance_type) VALUES ('04679e4a-fd02-45a6-ae48-a743e3375edc', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'FU117816', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('ae57bfb6-0f42-4e4e-b16f-e80a73b80682', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('7aae8b7b-b7a7-471e-af65-de9ffd65c5a4', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('76c76239-73a6-416b-a959-9303e48e3542', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('e11d2608-3377-4c5f-a7be-de3fe9b9355c', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('5d97cdda-5bf2-4b3a-becd-822787f3f800', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('f7258cf8-6935-4907-a5a6-fc32710f29a3', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('df113eb6-33ba-4444-96ef-97b052e3b829', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('153c92af-014c-48af-958d-efd464daebf1', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('75d2ce74-1541-4fa6-8d32-9838ec297756', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('d992d171-02b4-4cd0-bb46-975aaa0884a4', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('de302bd9-dade-467a-aa07-2964908a600b', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('0d64f810-d213-4052-9947-2c37c3aadcb6', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('52d26c37-6243-434c-aa29-43d6e7a8c155', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('d79c76cb-b789-4f52-be48-c278f8220b1e', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('693ec196-b0fe-4d72-a9a1-cdea43584aa3', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('7b28e12a-979a-4256-ab48-eee1cc3c1eee', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('1bd630e1-58b5-4eff-a2a6-cf0763514a0a', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('b6ceff43-6f21-4c60-8ca9-8b68336ff1de', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('03704243-9b6f-427b-9045-bb39af87b25a', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('f15d9010-da1c-4a91-a56b-b8272627eb5b', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('e1beb352-4945-4b37-b6cf-c144f188e03a', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('954eeadc-656b-4935-84f9-f06793588518', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('e9a9c262-6de0-4770-b6b7-f0bc8e383bdb', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('de9e50d5-5539-4b77-ad66-4da274b40b7c', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('171bfb36-8f5b-454c-8ae9-bd5703d34501', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('fe4c8be1-6991-4aaf-8b9a-8c56d0dce0be', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('c9438970-0b3b-4e3e-9446-5e4e408c7beb', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('f538a6f5-8edb-497d-af43-5726ef83e0e1', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('87c9186b-2ab5-4a66-af6e-418d5a7e60fc', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('b8ba6945-5ec1-4d67-b7e6-a891fdb7924a', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('23adc9a6-1b21-4ef7-a639-959ccea28226', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('125ceb2b-942d-43b4-affc-bd432ba4aa4c', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('fa0e9c32-4983-47d4-8ba9-272466d0691e', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'general');
INSERT INTO building_insurance (id, building_id, policy_number, insurance_type) VALUES ('3cf6d809-1e3d-43c7-9bc8-112f2419ccd3', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'LXBI3559280XB', 'general');
INSERT INTO building_insurance (id, building_id, policy_number, insurance_type) VALUES ('0cadb521-16de-4835-b92f-e267bf6b6f27', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'LXBI3559280XB', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('eec5a844-1b8c-4e19-8aa3-5c054ad6f98c', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('029de5f7-d129-4c4a-a701-f7e844e43af9', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('b43348e9-a064-4b55-8b6e-b5f2ff0641f8', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('211e9a1e-9570-482b-a14e-5801c28d5af5', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('09b2d4b3-29d4-4a1b-a477-41c1741375a4', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('7f0f4fe1-9443-4c11-8a89-c0e56953ca3e', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('efc8edd5-ebe9-442b-b54b-1fb892d34340', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('a95afe2f-62ff-4e94-96cb-067f4430d24b', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('421561cc-dd7e-482d-aa08-11ceb9a6bfae', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('fdc411bf-0d7d-4ad2-bfc0-8f5d3531b8c6', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'general');
INSERT INTO building_insurance (id, building_id, policy_number, insurance_type) VALUES ('f22f4037-009e-4f3e-b411-8528caa21b88', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'NZ23346712', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('b9ab1a69-7b5d-4313-98cc-f1ac300d9ff3', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'general');
INSERT INTO building_insurance (id, building_id, policy_number, insurance_type) VALUES ('d1e38690-4778-4fb6-9aee-05662deb5bb6', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'and', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('37b662bd-f4e9-4b11-b4c0-9e72a6f875e4', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('93f7b13e-e18b-4ff7-ba57-997968f978eb', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('b129bcd3-91aa-4c03-ab29-2fd83335687d', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('791be514-b11d-4a0f-9126-cbd81b1d0866', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'general');
INSERT INTO building_insurance (id, building_id, policy_number, insurance_type) VALUES ('f8b295c8-1cb5-46aa-bece-8fcafbb270eb', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'STGLON', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('7e2cee29-bf01-4a3b-ae75-68d76bcf6506', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('bcb5c468-d338-4a9b-baad-f755c24f1948', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'general');
INSERT INTO building_insurance (id, building_id, policy_number, insurance_type) VALUES ('3562afff-d56a-4544-a7a0-11259aa33d74', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'STGLON', 'general');
INSERT INTO building_insurance (id, building_id, policy_number, insurance_type) VALUES ('717d97ee-893a-46d4-99ca-8001e5bacbcd', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'STGLON', 'general');
INSERT INTO building_insurance (id, building_id, policy_number, insurance_type) VALUES ('3b2bb908-bc0c-4821-87dc-fda985f1697d', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'BERTSTGLON', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('a894e04b-7390-4032-91ba-664bfe77cc0a', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('036f6fce-1f9e-4664-a911-bacfef68951e', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'general');
INSERT INTO building_insurance (id, building_id, policy_number, insurance_type) VALUES ('121240a3-a99b-4165-b7fc-d032d7e1f535', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'LP', 'general');
INSERT INTO building_insurance (id, building_id, policy_number, insurance_type) VALUES ('0a3dc97b-4f47-4ddc-8bd3-045d7b9d9cd8', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'HL', 'general');
INSERT INTO building_insurance (id, building_id, policy_number, insurance_type) VALUES ('93145ed3-d8f0-4a85-b869-45c5c33f6a31', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'ARCH', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('4268b7b6-d7aa-4554-bc87-cb2f3a5facda', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'general');
INSERT INTO building_insurance (id, building_id, policy_number, insurance_type) VALUES ('146650a6-9052-4667-a485-a384397eb4ec', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'and', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('7b42cc19-f95e-49d1-bf48-e0f6e5592581', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('c7b02af4-06de-4c45-9c47-97222f10cf46', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('337f20b4-a70f-4dea-be7e-160616bf7f9e', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('76d45af6-cc39-4521-94ae-637c7b45a25b', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('49d9ab25-2c5d-4c40-8756-badc794ce489', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('b922f056-4fd1-4462-83d0-66dd7cfe3feb', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'general');
INSERT INTO building_insurance (id, building_id, policy_number, insurance_type) VALUES ('c54a6a7e-9a43-4ec0-8d53-329b31498fc4', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'and', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('4e311dd2-d21d-44d9-8aed-7cb092a72954', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('516e153a-5ffa-4ecb-b188-96573e8c5dd1', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('966989ce-234a-4add-8fa0-0118542a2416', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('15c0e258-d9f7-4393-8077-a8e49a975759', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('6b8bf213-1497-4384-b3d6-3a9e6079f45c', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('c4197ead-6abc-44ae-8153-ded366c420b8', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'general');
INSERT INTO building_insurance (id, building_id, policy_number, insurance_type) VALUES ('c894d319-6da9-4d09-8008-de9da1e538d5', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'and', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('801574d6-c9bf-4875-a0d5-a2c706d96ddc', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'general');
INSERT INTO building_insurance (id, building_id, policy_number, insurance_type) VALUES ('bd7cc07e-4d91-46df-8957-bf9b5a5451a7', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'BP13228-2501', 'general');
INSERT INTO building_insurance (id, building_id, policy_number, insurance_type) VALUES ('ec144ad1-590f-44ca-bb3f-49cde9065fcf', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'BP13228-2501', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('88cea33a-8c19-4bf1-8914-c5f30da53bee', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('d2f04779-5a29-45b7-ac80-8f762fc6fc77', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'general');
INSERT INTO building_insurance (id, building_id, policy_number, insurance_type) VALUES ('62c5a7c3-e16e-4b2c-a6f0-d26b5ced69ef', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'TA0604600', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('d3703022-309f-448b-9a02-6831c2ba5add', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('44efb336-8325-48ac-86e3-cab2d6147df4', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'general');
INSERT INTO building_insurance (id, building_id, policy_number, insurance_type) VALUES ('3a270992-4200-475e-89c6-6c94b1fd2934', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'HL', 'general');
INSERT INTO building_insurance (id, building_id, policy_number, insurance_type) VALUES ('f6792ef1-0a5b-4a09-bbfd-8ce1ca13e330', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'Camberford', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('4e82d566-07e1-4867-b508-a1dafa5d1ede', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('d655b26d-491d-4aa2-be32-b288131597c1', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('25350873-9008-41a6-8824-6b2bc8f44fef', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('02138ae7-48fd-4f1a-a584-74122087eefb', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('7e6848ee-0b66-4bd8-9c06-4bf86dad1033', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('a0436299-8e4c-481f-b5b3-086c7e287e0e', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('ef379e9b-fa8e-40ac-bf61-059f3d0f87bc', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('d772ef32-bd87-4cd5-9152-c06723c0bfdf', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('c1920c0d-69c7-47ea-8234-0b40e1d51845', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('ce041061-e189-4ef7-af9f-1225144ec37c', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('82c32277-860b-4a41-a8d5-dfd3d6fe5cf5', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('89f3bf2a-be98-43ad-919d-e1de0ee8702c', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('4af6e38c-1cdc-4a8e-9f75-b190c63a2cb4', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('41e55c79-650c-460b-afda-05e4f78289c4', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('314466f2-0ae5-427c-aaa8-f26c9adeebf1', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('a85d85ca-ccde-4a00-ada0-67e75dd4f344', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('95cefffe-f3fa-4621-81a0-23e5f2ef265b', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('823cc599-b755-431e-a0a6-527cb5728233', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('d11acea8-7ac3-4d19-9fc0-46cc7d5c9171', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('85c47b10-9067-40fd-b94f-7cd44cf3feaf', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'general');

-- ===========================
-- CONTRACTORS
-- ===========================

INSERT INTO contractors (id, name, phone, address) VALUES
('c36c3c43-d9ef-45dc-ac97-f59c6617a83b', 'ISS', '083603538855', 'London, We''re available on Live Chat here., W1S 1RS')
ON CONFLICT (id) DO NOTHING;

INSERT INTO contractors (id, name, email, phone, address) VALUES
('411ad136-cc7f-468c-8d8d-7ca6931229bf', 'Quotehedge', 'info@quotehedge-heating.co.uk', '07801 799118', '182 Revelstoke Road, Wandsworth, London, SW18 5NW')
ON CONFLICT (id) DO NOTHING;

INSERT INTO contractors (id, name, email, address) VALUES
('a17e2c04-5277-441e-9e68-4e9060a2f4e3', 'WHM', 'enquiries@whmltd.org', 'WATER HYGIENE MANAGEMENT L TD, 2 Churchill Court, Hortons Way,, Westerham, Kent, TN16 1BT')
ON CONFLICT (id) DO NOTHING;

INSERT INTO contractors (id, name, email, address) VALUES
('df4afcc6-2718-41b1-bdd1-d5fff4519b7a', 'Capita', 'DPO@archinsurance.co.uk', 'f Arch Insurance (UK) Limited, Arch Insurance (UK) Limited, 5th Floor, 60 Great Tower Street, London EC3R 5AZ')
ON CONFLICT (id) DO NOTHING;


-- ===========================
-- BUILDING_CONTRACTORS
-- ===========================

INSERT INTO building_contractors (id, building_id, contractor_type)
VALUES ('4a4fb756-0f47-4f7e-b4eb-01c76dba229f', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'service_provider')
ON CONFLICT (id) DO NOTHING;

INSERT INTO building_contractors (id, building_id, contractor_type)
VALUES ('3051288e-a587-4b53-98da-01eee7f0983b', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'service_provider')
ON CONFLICT (id) DO NOTHING;

INSERT INTO building_contractors (id, building_id, contractor_type)
VALUES ('016d6d91-00be-49c3-81e0-0a0b8d59694a', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'service_provider')
ON CONFLICT (id) DO NOTHING;

INSERT INTO building_contractors (id, building_id, contractor_type)
VALUES ('ef9654c8-2276-48f4-9efb-479ca4abe81e', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'service_provider')
ON CONFLICT (id) DO NOTHING;

INSERT INTO building_contractors (id, building_id, contractor_type)
VALUES ('3037dfcc-1557-4028-9bb8-ff415dab715a', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'service_provider')
ON CONFLICT (id) DO NOTHING;

INSERT INTO building_contractors (id, building_id, contractor_type)
VALUES ('1f714b3a-4f3e-4c39-b25a-c787fdb7b5d4', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'service_provider')
ON CONFLICT (id) DO NOTHING;

INSERT INTO building_contractors (id, building_id, contractor_type)
VALUES ('d421f282-ed8f-4208-a30d-8bb856fd1566', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'service_provider')
ON CONFLICT (id) DO NOTHING;

INSERT INTO building_contractors (id, building_id, contractor_type)
VALUES ('11333ef2-efeb-4c74-84cc-1a923bc329c2', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'service_provider')
ON CONFLICT (id) DO NOTHING;

INSERT INTO building_contractors (id, building_id, contractor_type)
VALUES ('9d0df1f2-c0de-4085-9682-3955c4fe9c75', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'service_provider')
ON CONFLICT (id) DO NOTHING;

INSERT INTO building_contractors (id, building_id, contractor_type)
VALUES ('3bc6f2d7-a02f-4a70-87b1-6abfbe2e4bde', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'service_provider')
ON CONFLICT (id) DO NOTHING;

INSERT INTO building_contractors (id, building_id, contractor_type)
VALUES ('eaf37f62-c358-4d5e-9e2a-0e53352348b1', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'service_provider')
ON CONFLICT (id) DO NOTHING;

INSERT INTO building_contractors (id, building_id, contractor_type)
VALUES ('fb3f4282-6cde-4645-8914-bc280160cfd6', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'service_provider')
ON CONFLICT (id) DO NOTHING;

INSERT INTO building_contractors (id, building_id, contractor_type)
VALUES ('15b1a93a-a7f6-442f-81f2-7ba06cb89b3b', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'service_provider')
ON CONFLICT (id) DO NOTHING;

INSERT INTO building_contractors (id, building_id, contractor_type)
VALUES ('6022d90a-b73b-4775-bcf6-61bcf4570f2c', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'service_provider')
ON CONFLICT (id) DO NOTHING;

INSERT INTO building_contractors (id, building_id, contractor_type)
VALUES ('a82d85b3-21a7-42b3-9842-f1d1714c2824', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'service_provider')
ON CONFLICT (id) DO NOTHING;

INSERT INTO building_contractors (id, building_id, contractor_type)
VALUES ('aff585e6-b35a-479b-9988-0f3ed0063856', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'service_provider')
ON CONFLICT (id) DO NOTHING;

INSERT INTO building_contractors (id, building_id, contractor_type)
VALUES ('23dcadb6-0906-480c-ae15-9774a6c8de34', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'service_provider')
ON CONFLICT (id) DO NOTHING;

INSERT INTO building_contractors (id, building_id, contractor_type)
VALUES ('40bd1442-f054-44c3-87e1-24ca85a8a5a8', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'service_provider')
ON CONFLICT (id) DO NOTHING;

INSERT INTO building_contractors (id, building_id, contractor_type)
VALUES ('78d21af7-2f55-4175-aa8f-197dd26f30bb', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'service_provider')
ON CONFLICT (id) DO NOTHING;

INSERT INTO building_contractors (id, building_id, contractor_type)
VALUES ('8ab33402-49a4-471b-a4d4-5726eb1bf7ce', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'service_provider')
ON CONFLICT (id) DO NOTHING;

INSERT INTO building_contractors (id, building_id, contractor_type)
VALUES ('f7ffaf9d-9932-4990-b077-84016be6863f', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'service_provider')
ON CONFLICT (id) DO NOTHING;


-- Insert 214 assets
INSERT INTO assets (id, building_id, asset_type, asset_name, location_description, compliance_category, linked_documents) VALUES ('956a8cf2-8ce1-41b4-bf74-aa1d5802b46a', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'fire_alarm', 'Fire Alarm Works', 'Works-Following from latest leak', 'fire_safety', ARRAY['2024 Directors Meeting-Notes.docx']);
INSERT INTO assets (id, building_id, asset_type, asset_name, location_description, compliance_category, linked_documents) VALUES ('c62e888d-1164-47c6-a47c-285579080ddb', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'lift', 'Lift Works', 'Works-Following from latest leak', 'lifts_safety', ARRAY['2024 Directors Meeting-Notes.docx']);
INSERT INTO assets (id, building_id, asset_type, asset_name, location_description, model_number, compliance_category, linked_documents) VALUES ('5e5d167a-b998-4d64-b8c1-9a3852268b92', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'boiler', 'Boiler Room', 'Basement', 'Fire', 'gas_safety', ARRAY['Fire Door (Communal) Inspection (11m +) (7).pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('24cf0d03-abf4-4ab1-ab3e-7b90b8fc3e42', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'fire_alarm', 'Fire Alarm A', 'fire_safety', ARRAY['EICR Cuanku 32-34 conaught square.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, location_description, compliance_category, linked_documents) VALUES ('2d806378-f4c3-4e35-9ae4-4f48672910d9', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'lift', 'LIFT SHAFT', 'CONTROL CIRCUITS', 'lifts_safety', ARRAY['EICR Cuanku 32-34 conaught square.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, model_number, compliance_category, linked_documents) VALUES ('562be845-99a0-4462-a52d-1530db3ae3e4', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'lightning_protection', 'To lightning protection', 'B', 'electrical_safety', ARRAY['EICR Cuanku 32-34 conaught square.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('bad86716-619f-4c73-9ff5-7d7238e240bd', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'generator', 'generators', 'electrical_safety', ARRAY['EICR Cuanku 32-34 conaught square.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, location_description, compliance_category, linked_documents) VALUES ('e475fda5-d3da-42e7-a92d-e4388be0e015', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'boiler', 'Boiler room', 'terrace - lift', 'gas_safety', ARRAY['221037_Fra1-L-394697-071223 32-34 Connaught Square_2024-01-02_163759 (1).pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, location_description, condition_rating, compliance_category, linked_documents) VALUES ('c1233b71-c016-4a06-b3ae-46a7bdc91043', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'fire_alarm', 'Fire Alarm', 'in appropriate X Breaches to compartmentation observed', 'good', 'fire_safety', ARRAY['221037_Fra1-L-394697-071223 32-34 Connaught Square_2024-01-02_163759 (1).pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, location_description, compliance_category, linked_documents) VALUES ('c656a533-a7ab-4e3a-b6ed-3e259e9f8d54', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'lift', 'lift
motor', 'terrace - lift', 'lifts_safety', ARRAY['221037_Fra1-L-394697-071223 32-34 Connaught Square_2024-01-02_163759 (1).pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, location_description, model_number, compliance_category, linked_documents) VALUES ('9f509052-01cc-4bc3-872b-7d72690e9191', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'door_entry', 'Intercom door entry', 'to 3rd floor', '1', 'security', ARRAY['221037_Fra1-L-394697-071223 32-34 Connaught Square_2024-01-02_163759 (1).pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('b9521775-685f-4ba7-ac73-057647111903', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'emergency_lighting', 'emergency lighting present', 'fire_safety', ARRAY['221037_Fra1-L-394697-071223 32-34 Connaught Square_2024-01-02_163759 (1).pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('658aeb5c-4523-4572-bd08-dea0214e70ca', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'fire_extinguisher', 'fire extinguishers', 'fire_safety', ARRAY['221037_Fra1-L-394697-071223 32-34 Connaught Square_2024-01-02_163759 (1).pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, condition_rating, compliance_category, linked_documents) VALUES ('db775c4a-cacd-4e9e-bbd3-2c9d51054712', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'lightning_protection', 'Lightning protection available', 'good', 'electrical_safety', ARRAY['221037_Fra1-L-394697-071223 32-34 Connaught Square_2024-01-02_163759 (1).pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, location_description, model_number, condition_rating, compliance_category, linked_documents) VALUES ('484c380b-35cd-4cef-9797-4524d50ce465', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'boiler', 'Boiler Hanworthy', 'Condensing Boiler Hanworthy Purewell variheat m k2 110 21 Mbar 110 0', 'pressure', 'fair', 'gas_safety', ARRAY['001132-3234-Connaught-Square-London.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, location_description, compliance_category, linked_documents) VALUES ('34ac2738-890f-4fe2-a1d0-567e5bec2eb8', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'boiler', 'Boiler room', 'terrace - lift', 'gas_safety', ARRAY['221038_Hsra1-L-394697-071223 32-34 Connaught Square_2024-01-02_163759 (1).pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('46b2b93a-8361-4896-99df-f3581a0e932e', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'lift', 'LIFTS', 'lifts_safety', ARRAY['221038_Hsra1-L-394697-071223 32-34 Connaught Square_2024-01-02_163759 (1).pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('023acadc-f7a6-4f8f-a8ed-e89f46b4b469', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'cctv', 'CCTV equipment', 'security', ARRAY['221038_Hsra1-L-394697-071223 32-34 Connaught Square_2024-01-02_163759 (1).pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, location_description, compliance_category, linked_documents) VALUES ('60c441e4-0ec3-423d-893e-a2e7b8ca5e3f', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'door_entry', 'Intercom door entry', 'to 3rd floor', 'security', ARRAY['221038_Hsra1-L-394697-071223 32-34 Connaught Square_2024-01-02_163759 (1).pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('bc2c1e56-d8b5-4e03-92c2-69ee576cfd4b', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'emergency_lighting', 'Emergency lighting provided', 'fire_safety', ARRAY['221038_Hsra1-L-394697-071223 32-34 Connaught Square_2024-01-02_163759 (1).pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('a422cfcd-3785-4835-9f40-9cab1b45ec7a', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'water_tank', 'water storage tank', 'water_safety', ARRAY['221038_Hsra1-L-394697-071223 32-34 Connaught Square_2024-01-02_163759 (1).pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, location_description, compliance_category, linked_documents) VALUES ('04b9fa63-0998-4ace-973c-aebaf14c2089', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'boiler', 'Boiler Room', 'exits', 'gas_safety', ARRAY['TETRA - Asbestos Re-Inspection Survey 14.06.22.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, location_description, compliance_category, linked_documents) VALUES ('6ebcaf6a-c2bd-4b27-ae9c-76edf924fdba', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'lift', 'Lift Motor', 'Description Assessment', 'lifts_safety', ARRAY['TETRA - Asbestos Re-Inspection Survey 14.06.22.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, location_description, compliance_category, linked_documents) VALUES ('91e2a836-7eb3-4e31-86c9-cb9c5d464004', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'pump', 'pumps', 'exits', 'water_safety', ARRAY['TETRA - Asbestos Re-Inspection Survey 14.06.22.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, model_number, compliance_category, linked_documents) VALUES ('994b18fb-07ba-48d9-bfa8-c78ba7cea5bf', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'boiler', 'Boilers', 'Total', 'gas_safety', ARRAY['WHM Legionella Risk Assessment 07.06.22.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('ad77fc0a-bc5d-4744-920e-5186f3ef98dc', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'sprinkler', 'Sprinklers', 'fire_safety', ARRAY['WHM Legionella Risk Assessment 07.06.22.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('2c58307e-e3f3-49f6-939e-a1c4ad87bb9d', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'pump', 'pump is', 'water_safety', ARRAY['WHM Legionella Risk Assessment 07.06.22.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, service_frequency, compliance_category, linked_documents) VALUES ('34f41aba-8049-4732-b14b-1ca3d9c34850', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'water_tank', 'water tanks', 'annually', 'water_safety', ARRAY['WHM Legionella Risk Assessment 07.06.22.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('128cae4f-065b-4b25-9d1b-4569830c33a9', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'fire_alarm', 'Fire Alarm A', 'fire_safety', ARRAY['EICR Report Cunaku SATISFACTORY 2023 .pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, location_description, compliance_category, linked_documents) VALUES ('b0a9899d-2bfb-4378-840f-111d35519cc6', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'lift', 'LIFT SHAFT', 'CONTROL CIRCUITS', 'lifts_safety', ARRAY['EICR Report Cunaku SATISFACTORY 2023 .pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, model_number, compliance_category, linked_documents) VALUES ('811e2e15-e73d-4100-b564-47bb3e7c7509', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'lightning_protection', 'To lightning protection', 'B', 'electrical_safety', ARRAY['EICR Report Cunaku SATISFACTORY 2023 .pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('d447eb75-94ec-430d-a47c-727c49646f6b', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'generator', 'generators', 'electrical_safety', ARRAY['EICR Report Cunaku SATISFACTORY 2023 .pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, location_description, compliance_category, linked_documents) VALUES ('07a1000b-c618-4297-b63b-46318e7c7f52', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'fire_alarm', 'Fire Alarm Works', 'Works-Following from latest leak', 'fire_safety', ARRAY['2024 Directors Meeting-Notes.docx']);
INSERT INTO assets (id, building_id, asset_type, asset_name, location_description, compliance_category, linked_documents) VALUES ('b9744576-ecce-4d23-822a-e0ba1598bd81', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'lift', 'Lift Works', 'Works-Following from latest leak', 'lifts_safety', ARRAY['2024 Directors Meeting-Notes.docx']);
INSERT INTO assets (id, building_id, asset_type, asset_name, location_description, model_number, condition_rating, compliance_category, linked_documents) VALUES ('6ad9faae-dfaa-451c-ab1f-62dac953ee54', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'boiler', 'Boiler Hanworthy', 'Condensing Boiler Hanworthy Wessex modumaxO mFk2 110c 20 Mbar 1', 'pressure', 'fair', 'gas_safety', ARRAY['001457-3234-Connaught-Square-London Certificate.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, location_description, manufacturer, compliance_category, linked_documents) VALUES ('661b263e-bb81-4b6c-a58c-6f6e413072d0', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'lift', 'lift to', 'of Commission is', 'Crown to the Customer', 'lifts_safety', ARRAY['TC0001V31 General Terms and Conditions.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, model_number, compliance_category, linked_documents) VALUES ('900f4c25-84aa-4903-9194-b97b41f13df9', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'boiler', 'Boilers', 'Total', 'gas_safety', ARRAY['Connaught Square (32-34) - 09.12.24 LRA.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('b2da8f44-e6be-4a69-927b-91691c60b91a', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'sprinkler', 'Sprinklers', 'fire_safety', ARRAY['Connaught Square (32-34) - 09.12.24 LRA.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('62be3ddc-07d6-4876-9508-ecf149ef1579', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'pump', 'pump is', 'water_safety', ARRAY['Connaught Square (32-34) - 09.12.24 LRA.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, service_frequency, compliance_category, linked_documents) VALUES ('976ac278-d3a6-4acc-a4d3-7ff14c400891', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'water_tank', 'water tanks', 'annually', 'water_safety', ARRAY['Connaught Square (32-34) - 09.12.24 LRA.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, location_description, model_number, compliance_category, linked_documents) VALUES ('bdd7b372-7682-470f-8e9a-347574617d6e', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'boiler', 'Boiler Room', 'Basement', 'Fire', 'gas_safety', ARRAY['Fire Door (Communal) Inspection (11m +) (7).pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, location_description, compliance_category, linked_documents) VALUES ('51c058b7-1d24-4ba4-a3d4-34f5e5b7ec3f', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'boiler', 'Boiler room', 'terrace - lift', 'gas_safety', ARRAY['221037_Fra1-L-394697-071223 32-34 Connaught Square_2024-01-02_163759.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, location_description, condition_rating, compliance_category, linked_documents) VALUES ('20584a69-084b-40fd-b930-04e799433395', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'fire_alarm', 'Fire Alarm', 'in appropriate X Breaches to compartmentation observed', 'good', 'fire_safety', ARRAY['221037_Fra1-L-394697-071223 32-34 Connaught Square_2024-01-02_163759.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, location_description, compliance_category, linked_documents) VALUES ('74ff31fa-350d-4e94-bdb9-05598e577936', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'lift', 'lift
motor', 'terrace - lift', 'lifts_safety', ARRAY['221037_Fra1-L-394697-071223 32-34 Connaught Square_2024-01-02_163759.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, location_description, model_number, compliance_category, linked_documents) VALUES ('63b7948d-c517-48cd-bb7e-365dff926596', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'door_entry', 'Intercom door entry', 'to 3rd floor', '1', 'security', ARRAY['221037_Fra1-L-394697-071223 32-34 Connaught Square_2024-01-02_163759.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('33f43e71-f878-4fd9-9ad3-22e852f1f76b', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'emergency_lighting', 'emergency lighting present', 'fire_safety', ARRAY['221037_Fra1-L-394697-071223 32-34 Connaught Square_2024-01-02_163759.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('538f5c6f-330d-4802-b353-d93a1c8dfc8e', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'fire_extinguisher', 'fire extinguishers', 'fire_safety', ARRAY['221037_Fra1-L-394697-071223 32-34 Connaught Square_2024-01-02_163759.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, condition_rating, compliance_category, linked_documents) VALUES ('b21914e5-9979-4563-a13a-75b54bfa13da', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'lightning_protection', 'Lightning protection available', 'good', 'electrical_safety', ARRAY['221037_Fra1-L-394697-071223 32-34 Connaught Square_2024-01-02_163759.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, location_description, model_number, compliance_category, linked_documents) VALUES ('c3c66e1b-dc74-4b86-81e4-8d40c3f63461', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'boiler', 'Boiler Room', 'Basement', 'Fire', 'gas_safety', ARRAY['Fire Door (Communal) Inspection (11m +) - 2024-01-24T120743.986.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, location_description, compliance_category, linked_documents) VALUES ('a6d0ac31-f7f1-4763-b9c9-341908839460', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'boiler', 'Boiler room', 'terrace - lift', 'gas_safety', ARRAY['221038_Hsra1-L-394697-071223 32-34 Connaught Square_2024-01-02_163759.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('f91db328-3f59-4cd2-abe5-39fbf993a028', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'lift', 'LIFTS', 'lifts_safety', ARRAY['221038_Hsra1-L-394697-071223 32-34 Connaught Square_2024-01-02_163759.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('a465d9a6-18d9-43ff-a540-3d2e3a473256', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'cctv', 'CCTV equipment', 'security', ARRAY['221038_Hsra1-L-394697-071223 32-34 Connaught Square_2024-01-02_163759.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, location_description, compliance_category, linked_documents) VALUES ('1ae0f1e7-fd41-4b0b-a18d-cedc662e808c', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'door_entry', 'Intercom door entry', 'to 3rd floor', 'security', ARRAY['221038_Hsra1-L-394697-071223 32-34 Connaught Square_2024-01-02_163759.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('3dcabd9e-5805-4ddd-a15f-59a19a3ac899', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'emergency_lighting', 'Emergency lighting provided', 'fire_safety', ARRAY['221038_Hsra1-L-394697-071223 32-34 Connaught Square_2024-01-02_163759.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('6634b3ac-4801-4929-96a1-9db51b3bcbe5', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'water_tank', 'water storage tank', 'water_safety', ARRAY['221038_Hsra1-L-394697-071223 32-34 Connaught Square_2024-01-02_163759.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, location_description, compliance_category, linked_documents) VALUES ('90006cc2-0d7d-4e44-bdb9-0b495649c6e0', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'boiler', 'Boiler room', 'terrace - lift', 'gas_safety', ARRAY['Hsfra1-L-422971-210225 32-34 Connaught Square.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, location_description, condition_rating, compliance_category, linked_documents) VALUES ('fae02857-1f7c-4b9b-b91d-adae0955485f', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'fire_alarm', 'Fire Alarm', 'in appropriate X Breaches to compartmentation observed', 'good', 'fire_safety', ARRAY['Hsfra1-L-422971-210225 32-34 Connaught Square.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('e5edc4ba-def1-4b00-8753-3c7ba8b90401', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'lift', 'LIFTS', 'lifts_safety', ARRAY['Hsfra1-L-422971-210225 32-34 Connaught Square.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('b25ef500-d09b-47c3-8fa2-e0c1f6170700', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'cctv', 'CCTV equipment', 'security', ARRAY['Hsfra1-L-422971-210225 32-34 Connaught Square.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, location_description, compliance_category, linked_documents) VALUES ('e6499720-4d40-4c7b-ae9b-18380052e79a', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'door_entry', 'Intercom door entry', 'to 3rd floor', 'security', ARRAY['Hsfra1-L-422971-210225 32-34 Connaught Square.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('b0e1c1c2-5352-4841-b789-4148d15086a3', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'emergency_lighting', 'Emergency lighting provided', 'fire_safety', ARRAY['Hsfra1-L-422971-210225 32-34 Connaught Square.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('ec5cde80-592c-4904-aa65-7048b2dcd2a1', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'fire_extinguisher', 'fire extinguishers', 'fire_safety', ARRAY['Hsfra1-L-422971-210225 32-34 Connaught Square.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, condition_rating, compliance_category, linked_documents) VALUES ('8c093ca5-e1e8-4e27-be64-a4c63677e974', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'lightning_protection', 'Lightning protection available', 'good', 'electrical_safety', ARRAY['Hsfra1-L-422971-210225 32-34 Connaught Square.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('300c6a0b-7251-4384-9b29-05f4f28240c1', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'water_tank', 'water storage tank', 'water_safety', ARRAY['Hsfra1-L-422971-210225 32-34 Connaught Square.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('a66be15e-6d6e-4ac0-b839-5f4100d38e38', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'fire_alarm', 'ESCAPE

FIRE DETECTION', 'fire_safety', ARRAY['Hsfra1-L-422971-210225 32-34 Connaught Square.docx']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('05b9ec60-f5fb-4091-9e55-58c59cd9407c', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'lift', 'LIFTS', 'lifts_safety', ARRAY['Hsfra1-L-422971-210225 32-34 Connaught Square.docx']);
INSERT INTO assets (id, building_id, asset_type, asset_name, location_description, compliance_category, linked_documents) VALUES ('81b4cbed-4644-449b-a067-05fa38b5dc80', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'boiler', 'Boiler room', 'terrace - lift', 'gas_safety', ARRAY['221037_Fra1-L-394697-071223 32-34 Connaught Square_2024-01-02_163759 (1).pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, location_description, condition_rating, compliance_category, linked_documents) VALUES ('45b584ab-0ed7-4a3a-ab09-646a585a02b4', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'fire_alarm', 'Fire Alarm', 'in appropriate X Breaches to compartmentation observed', 'good', 'fire_safety', ARRAY['221037_Fra1-L-394697-071223 32-34 Connaught Square_2024-01-02_163759 (1).pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, location_description, compliance_category, linked_documents) VALUES ('784924b1-b83c-496a-895c-dc2a27b7e5ed', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'lift', 'lift
motor', 'terrace - lift', 'lifts_safety', ARRAY['221037_Fra1-L-394697-071223 32-34 Connaught Square_2024-01-02_163759 (1).pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, location_description, model_number, compliance_category, linked_documents) VALUES ('f2777c12-601c-44b5-96ac-76921dbe263a', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'door_entry', 'Intercom door entry', 'to 3rd floor', '1', 'security', ARRAY['221037_Fra1-L-394697-071223 32-34 Connaught Square_2024-01-02_163759 (1).pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('24ca1898-ba5a-4bf9-b395-68ce0a46fb9a', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'emergency_lighting', 'emergency lighting present', 'fire_safety', ARRAY['221037_Fra1-L-394697-071223 32-34 Connaught Square_2024-01-02_163759 (1).pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('c9ce4a26-1f58-47ee-a49b-2a09b82b6689', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'fire_extinguisher', 'fire extinguishers', 'fire_safety', ARRAY['221037_Fra1-L-394697-071223 32-34 Connaught Square_2024-01-02_163759 (1).pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, condition_rating, compliance_category, linked_documents) VALUES ('d0a12192-51e0-463a-aa5b-0597b39794f4', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'lightning_protection', 'Lightning protection available', 'good', 'electrical_safety', ARRAY['221037_Fra1-L-394697-071223 32-34 Connaught Square_2024-01-02_163759 (1).pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, location_description, compliance_category, linked_documents) VALUES ('1f914dcb-3b3b-40d7-b43a-fb7d4655aa40', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'boiler', 'Boiler room', 'terrace - lift', 'gas_safety', ARRAY['221038_Hsra1-L-394697-071223 32-34 Connaught Square_2024-01-02_163759 (1).pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('d0969edb-a3ac-4d04-8c23-ff48c7729913', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'lift', 'LIFTS', 'lifts_safety', ARRAY['221038_Hsra1-L-394697-071223 32-34 Connaught Square_2024-01-02_163759 (1).pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('bc77cf68-e9c4-4261-ba94-d2e2ff5aec84', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'cctv', 'CCTV equipment', 'security', ARRAY['221038_Hsra1-L-394697-071223 32-34 Connaught Square_2024-01-02_163759 (1).pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, location_description, compliance_category, linked_documents) VALUES ('5335c3e0-ca45-467a-87d0-b66ccfd19abf', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'door_entry', 'Intercom door entry', 'to 3rd floor', 'security', ARRAY['221038_Hsra1-L-394697-071223 32-34 Connaught Square_2024-01-02_163759 (1).pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('f5a229c7-25d8-47f6-b176-e68d41f5dad0', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'emergency_lighting', 'Emergency lighting provided', 'fire_safety', ARRAY['221038_Hsra1-L-394697-071223 32-34 Connaught Square_2024-01-02_163759 (1).pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('64863be9-94f5-499a-b32d-bd17490dcb2e', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'water_tank', 'water storage tank', 'water_safety', ARRAY['221038_Hsra1-L-394697-071223 32-34 Connaught Square_2024-01-02_163759 (1).pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, location_description, model_number, condition_rating, compliance_category, linked_documents) VALUES ('eb5e6e52-3247-4787-80b6-d8cb7402d2e4', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'boiler', 'Boiler Hamworthy', 'Plant Room Condensing', 'pressure', 'fair', 'gas_safety', ARRAY['001534-3234-Connaught-Square-London.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, location_description, compliance_category, linked_documents) VALUES ('ca24a958-24c4-4aba-baa0-0e931069262f', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'boiler', 'boiler number', 'new gas valve', 'gas_safety', ARRAY['C1047 - Job card.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, model_number, compliance_category, linked_documents) VALUES ('bb4c4c13-2dd8-46dd-85b5-c71c55e9f228', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'boiler', 'Boilers', 'Total', 'gas_safety', ARRAY['WHM Legionella Risk Assessment 09.12.25.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('5a28f607-8126-49ed-bd82-39dfe1673afb', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'sprinkler', 'Sprinklers', 'fire_safety', ARRAY['WHM Legionella Risk Assessment 09.12.25.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('8d75775a-28de-4718-8046-3f3e2c25d675', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'pump', 'pump is', 'water_safety', ARRAY['WHM Legionella Risk Assessment 09.12.25.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, service_frequency, compliance_category, linked_documents) VALUES ('fc1c7d4d-b620-4b7d-9115-5e857374a4dd', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'water_tank', 'water tanks', 'annually', 'water_safety', ARRAY['WHM Legionella Risk Assessment 09.12.25.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, model_number, compliance_category, linked_documents) VALUES ('41299a2d-3c87-4e00-95bc-97a3e999906c', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'boiler', 'Boilers', 'Total', 'gas_safety', ARRAY['WHM Legionella Risk Assessment 07.06.22.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('433f3aff-addf-4678-a286-df4e4a676b91', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'sprinkler', 'Sprinklers', 'fire_safety', ARRAY['WHM Legionella Risk Assessment 07.06.22.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('2ab14e0f-a046-4c0d-b8ea-12f6a653a05c', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'pump', 'pump is', 'water_safety', ARRAY['WHM Legionella Risk Assessment 07.06.22.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, service_frequency, compliance_category, linked_documents) VALUES ('1da7f327-be4f-46a3-8fd3-d492631e1909', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'water_tank', 'water tanks', 'annually', 'water_safety', ARRAY['WHM Legionella Risk Assessment 07.06.22.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('61eb4111-3b34-4bc9-83e7-968ab4bfc3d3', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'fire_alarm', 'Fire Alarm A', 'fire_safety', ARRAY['EICR Cuanku 32-34 conaught square.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, location_description, compliance_category, linked_documents) VALUES ('d63df8b3-b1c7-4d31-9cfe-f5aeb116b127', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'lift', 'LIFT SHAFT', 'CONTROL CIRCUITS', 'lifts_safety', ARRAY['EICR Cuanku 32-34 conaught square.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, model_number, compliance_category, linked_documents) VALUES ('74424021-9c11-427e-b87d-2de556c9d456', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'lightning_protection', 'To lightning protection', 'B', 'electrical_safety', ARRAY['EICR Cuanku 32-34 conaught square.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('9fcf3ce3-081f-4f89-9011-7ebdd819f42a', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'generator', 'generators', 'electrical_safety', ARRAY['EICR Cuanku 32-34 conaught square.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('8b171909-8df9-47b0-970b-626fdd0d382b', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'fire_alarm', 'Fire Alarm A', 'fire_safety', ARRAY['EICR Report Cunaku SATISFACTORY 2023 .pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, location_description, compliance_category, linked_documents) VALUES ('33b26c3b-2a4f-4437-a583-f60e3ce0a947', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'lift', 'LIFT SHAFT', 'CONTROL CIRCUITS', 'lifts_safety', ARRAY['EICR Report Cunaku SATISFACTORY 2023 .pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, model_number, compliance_category, linked_documents) VALUES ('8ff748af-edeb-43bc-94f3-000ef5622441', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'lightning_protection', 'To lightning protection', 'B', 'electrical_safety', ARRAY['EICR Report Cunaku SATISFACTORY 2023 .pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('cde78eb2-af7c-43c6-ba85-162c3ace3733', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'generator', 'generators', 'electrical_safety', ARRAY['EICR Report Cunaku SATISFACTORY 2023 .pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, location_description, model_number, condition_rating, compliance_category, linked_documents) VALUES ('1d468220-621a-4752-af84-6728fc329fae', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'boiler', 'Boiler Hanworthy', 'Condensing Boiler Hanworthy Purewell variheat m k2 110 21 Mbar 110 0', 'pressure', 'fair', 'gas_safety', ARRAY['001132-3234-Connaught-Square-London.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, location_description, model_number, condition_rating, compliance_category, linked_documents) VALUES ('7a715f78-851c-4dc6-9882-23922aa25c04', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'boiler', 'Boiler Hamworthy', 'Plant Room Condensing', 'pressure', 'fair', 'gas_safety', ARRAY['001534-3234-Connaught-Square-London.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, location_description, compliance_category, linked_documents) VALUES ('fdea5875-c0b2-45da-995d-cdec7ca55d39', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'boiler', 'Boiler Room', 'pipework', 'gas_safety', ARRAY['FINAL L-432900 32-34 Connaught Square Management Survey Report Issue 1.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, location_description, compliance_category, linked_documents) VALUES ('8b1efe34-bc98-43dc-adf2-2ac338926fe2', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'lift', 'Lift Motor', 'Room brake shoe to lift motor', 'lifts_safety', ARRAY['FINAL L-432900 32-34 Connaught Square Management Survey Report Issue 1.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, location_description, compliance_category, linked_documents) VALUES ('22992041-28f5-485c-ac05-4332a3be2fab', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'boiler', 'Boiler Room', 'exits', 'gas_safety', ARRAY['TETRA - Asbestos Re-Inspection Survey 14.06.22.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, location_description, compliance_category, linked_documents) VALUES ('df239e4d-dcd9-4c0a-9896-2f712e43ec57', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'lift', 'Lift Motor', 'Description Assessment', 'lifts_safety', ARRAY['TETRA - Asbestos Re-Inspection Survey 14.06.22.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, location_description, compliance_category, linked_documents) VALUES ('2a13259b-414e-4bf4-837b-3f203953247f', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'pump', 'pumps', 'exits', 'water_safety', ARRAY['TETRA - Asbestos Re-Inspection Survey 14.06.22.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, service_frequency, compliance_category, linked_documents) VALUES ('ecc237cb-e238-46fb-a2b9-024ba632639b', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'lift', 'lifts', 'monthly', 'lifts_safety', ARRAY['Signed 2025 Connaught Square Management Agreement.docx.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, service_frequency, compliance_category, linked_documents) VALUES ('3406128c-7b2c-4eb3-abc5-8a818caf5884', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'lift', 'lifts', 'monthly', 'lifts_safety', ARRAY['Signed Connaught Square Management Agreement.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, model_number, compliance_category, linked_documents) VALUES ('17377da4-2d64-4c6a-b70c-e6635ef4639e', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'boiler', 'BOILER SERVICE', 'OF', 'gas_safety', ARRAY['CM434.PRO 2024-2025.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, model_number, compliance_category, linked_documents) VALUES ('f338e755-c6b8-429f-aff5-c3d7fbbf5212', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'boiler', 'BOILER SERVICE', 'OF', 'gas_safety', ARRAY['CM434.PRO.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('a03b9dcb-1c03-43b7-869d-321c86700336', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'lift', 'lift in', 'lifts_safety', ARRAY['Gas Contract 24-5.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('d82ed478-af2b-42f6-a821-e6e72cc416ea', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'lift', 'LIFT INCORPORATED', 'lifts_safety', ARRAY['Contract_10-03-2025.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('e09a3339-5518-48c2-a60d-21e13f10ac19', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'lift', 'LIFT INCORPORATED', 'lifts_safety', ARRAY['Gas Contract 25-26.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('acf852e2-455b-4ff6-850b-d4a5b4a56d3a', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'lift', 'lift to', 'lifts_safety', ARRAY['Welcome Letter - CG1885574.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, location_description, service_frequency, compliance_category, linked_documents) VALUES ('ea11579f-e809-4e68-b12b-d40ab005a089', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'lift', 'lift accessible', 'To clean out silt from the outlet and bagged it up', 'monthly', 'lifts_safety', ARRAY['Job 67141.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, model_number, compliance_category, linked_documents) VALUES ('607f05f8-3f2a-4ed7-8f1c-05a7ea098880', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'lift', 'Lift Ref', 'BRONZE', 'lifts_safety', ARRAY['JLGCalloutVisit-5455045-12-07-2024.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, model_number, compliance_category, linked_documents) VALUES ('0d03e9a1-ca00-408d-9ede-a5d2e7b476a2', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'lift', 'Lift Ref', 'BRONZE', 'lifts_safety', ARRAY['JLGCalloutVisit-5483206-26-10-2024.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, model_number, compliance_category, linked_documents) VALUES ('5d17876a-b7bf-420f-9425-1ad5c8abab7c', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'lift', 'Lift Ref', 'BRONZE', 'lifts_safety', ARRAY['JLGCalloutVisit-5498439-16-12-2024.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, location_description, compliance_category, linked_documents) VALUES ('fa40278e-13c0-438c-8d73-8618021e2555', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'emergency_lighting', 'emergency lighting
The', 'The fault status has been classified as Faulty', 'fire_safety', ARRAY['JLGCalloutVisit-5498439-16-12-2024.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, model_number, compliance_category, linked_documents) VALUES ('ac967403-9814-4076-b0b5-985eb8d9aa6c', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'lift', 'Lift Ref', 'BRONZE', 'lifts_safety', ARRAY['JLGCalloutVisit-5455462-16-07-2024.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, model_number, compliance_category, linked_documents) VALUES ('f1cc6274-28a3-49cd-9959-c732405ff01f', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'lift', 'Lift Ref', 'BRONZE', 'lifts_safety', ARRAY['JLGCalloutVisit-5497480-13-12-2024.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, model_number, compliance_category, linked_documents) VALUES ('e679db74-4ac3-486d-83f0-f92c02e18cd5', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'fire_alarm', 'Fire Alarm', 'SMALL', 'fire_safety', ARRAY['Engineering Report - 32-34 CONNAUGHT SQUARE.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, model_number, compliance_category, linked_documents) VALUES ('5d564fd9-59c8-4050-93eb-18478716aaef', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'emergency_lighting', 'Emergency Lights - FA7817', 'SMALL', 'fire_safety', ARRAY['Engineering Report - 32-34 CONNAUGHT SQUARE.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, location_description, compliance_category, linked_documents) VALUES ('58d9099a-f63e-419b-9d97-42b7fa65f56b', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'boiler', 'a boiler', 'but this sha', 'gas_safety', ARRAY['StG_Policy Wording_32-34 Connaught Square W2 2HL.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('91df83a9-b5d3-43b2-bf09-92d6ef3d6385', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'fire_alarm', 'fire alarm
The', 'fire_safety', ARRAY['StG_Policy Wording_32-34 Connaught Square W2 2HL.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('1e9bfac4-5f4d-4482-aa1b-e90e2da21618', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'sprinkler', 'sprinkler leakage', 'fire_safety', ARRAY['StG_Policy Wording_32-34 Connaught Square W2 2HL.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('c255f6ec-df87-4d95-860b-c02560adaf38', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'lift', 'lift in', 'lifts_safety', ARRAY['StG_Policy Wording_32-34 Connaught Square W2 2HL.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('1346a24a-c088-4c32-a7e5-27645c6a0a58', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'pump', 'pumping', 'water_safety', ARRAY['StG_Policy Wording_32-34 Connaught Square W2 2HL.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, location_description, compliance_category, linked_documents) VALUES ('06b965f5-91a7-42d2-b807-10d80e2069b7', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'cctv', 'cameras', 'on or', 'security', ARRAY['StG_Policy Wording_32-34 Connaught Square W2 2HL.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('2308feab-c59a-40cc-93f0-afd052097215', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'water_tank', 'water tanks', 'water_safety', ARRAY['StG_Policy Wording_32-34 Connaught Square W2 2HL.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('e53cfa83-44ca-4a51-a613-d1ad35b0884d', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'fire_extinguisher', 'fire extinguishers', 'fire_safety', ARRAY['Q51691 - 32-34 Connaught Square Contract.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, model_number, compliance_category, linked_documents) VALUES ('8904aff9-82fa-4692-b089-7c9c9c186dd2', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'fire_alarm', 'Fire Alarm', 'SMALL', 'fire_safety', ARRAY['Engineering Report - 32-34 CONNAUGHT SQUARE.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, model_number, compliance_category, linked_documents) VALUES ('3adf3f8d-c4a6-4628-9f1c-8d07e72afa9d', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'emergency_lighting', 'Emergency Lights - FA7817', 'SMALL', 'fire_safety', ARRAY['Engineering Report - 32-34 CONNAUGHT SQUARE.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, location_description, model_number, compliance_category, linked_documents) VALUES ('bf701b47-0d9c-43ab-a225-7de10fbecdcb', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'fire_alarm', 'uk
FIRE ALARM', 'LONDON', 'LIGHTS', 'fire_safety', ARRAY['Fire Alarm+Emergency Lighting Contract Connaught Square.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, service_frequency, compliance_category, linked_documents) VALUES ('3a87c2c9-7e52-45cf-b77b-635e1cc8481b', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'emergency_lighting', 'EMERGENCY LIGHTS
MT8825', 'monthly', 'fire_safety', ARRAY['Fire Alarm+Emergency Lighting Contract Connaught Square.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, service_frequency, compliance_category, linked_documents) VALUES ('03436c9d-b60e-48c3-b653-bd870ef9cfd7', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'fire_alarm', 'FIRE ALARM BELL', 'monthly', 'fire_safety', ARRAY['BT3205 03072025.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, model_number, service_frequency, compliance_category, linked_documents) VALUES ('82fb62ae-66b0-4962-a2f8-7adfc1973301', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'fire_alarm', 'fire alarm service', 'MAINTENANCE', 'monthly', 'fire_safety', ARRAY['FA7817 SERVICE 08042025.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, model_number, service_frequency, compliance_category, linked_documents) VALUES ('b7e92f80-2a39-422f-a12f-6607caa61d67', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'emergency_lighting', 'Emergency Lights - FA7817', 'MAINTENANCE', 'monthly', 'fire_safety', ARRAY['FA7817 SERVICE 08042025.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, model_number, compliance_category, linked_documents) VALUES ('965bccf9-373d-4377-9812-1aaf4a4a9b60', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'fire_alarm', 'Fire Alarm', 'SMALL', 'fire_safety', ARRAY['Engineer Report - 32-34 Connaught Square Flat 5.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, model_number, compliance_category, linked_documents) VALUES ('add20600-15cb-4f41-94fb-a20d2a04efd5', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'emergency_lighting', 'Emergency Lights - FA7817', 'SMALL', 'fire_safety', ARRAY['Engineer Report - 32-34 Connaught Square Flat 5.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, model_number, compliance_category, linked_documents) VALUES ('c7950e31-e74e-43b7-b037-657d53999f4e', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'fire_alarm', 'Fire Alarm', 'SMALL', 'fire_safety', ARRAY['Engineering Report - 32-34 CONNAUGHT SQUARE.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, model_number, compliance_category, linked_documents) VALUES ('140c6732-28d5-420d-bb5c-7cd65dcffef4', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'emergency_lighting', 'Emergency Lights - FA7817', 'SMALL', 'fire_safety', ARRAY['Engineering Report - 32-34 CONNAUGHT SQUARE.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, model_number, service_frequency, compliance_category, linked_documents) VALUES ('192399d5-f131-470e-ba6c-794bea8201e2', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'emergency_lighting', 'Emergency Lights Testing', 'MONTHLY', 'monthly', 'fire_safety', ARRAY['MT8825 03072025.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, model_number, service_frequency, compliance_category, linked_documents) VALUES ('667c8c5d-3801-44d4-98bd-7365a037c4c4', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'emergency_lighting', 'Emergency Lights Testing', 'MONTHLY', 'monthly', 'fire_safety', ARRAY['January Monthly Test For EL-Connaught Square.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, model_number, service_frequency, compliance_category, linked_documents) VALUES ('cbe97ba6-9a4d-4330-8bd6-236e6493aac3', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'emergency_lighting', 'Emergency Lights Testing', 'MONTHLY', 'monthly', 'fire_safety', ARRAY['February Monthly Test For EL-Connaught Square.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('3e6ed5b2-db32-47bb-a8b1-e379f775ad42', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'boiler', 'boilers', 'gas_safety', ARRAY['Real Estate Policy (01.23).pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('ff8d3d42-3ce3-4794-95d8-f47c70aef926', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'sprinkler', 'sprinkler leakage', 'fire_safety', ARRAY['Real Estate Policy (01.23).pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('59db1903-d1d7-4e0f-af0a-6a1df6a2cee1', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'pump', 'pumping', 'water_safety', ARRAY['Real Estate Policy (01.23).pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('f12516a2-d72d-4fd3-9ac2-0f7497c6c2c9', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'cctv', 'cameras', 'security', ARRAY['Real Estate Policy (01.23).pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('0e0e4d31-d6ed-4ea1-99e6-0780f5be246e', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'fire_extinguisher', 'fire extinguishers', 'fire_safety', ARRAY['Real Estate Policy (01.23).pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('1f8e4832-fea4-4906-b7de-ea5cc5e5ff2d', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'communal_aerial', 'satellite dishes', 'other', ARRAY['Real Estate Policy (01.23).pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('ea27e9ad-96e1-4f4e-b9ea-ffaefdeaf15f', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'water_tank', 'water tanks', 'water_safety', ARRAY['Real Estate Policy (01.23).pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('f50d8562-4b7a-4d80-8099-1d5182e21839', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'sprinkler', 'sprinkler installation', 'fire_safety', ARRAY['Summary of Cover (01.23).pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('af71e438-020a-41db-84d2-cf6d6f975d05', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'lift', 'lift in', 'lifts_safety', ARRAY['Summary of Cover (01.23).pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('07372f27-5cef-4e96-b85e-2c30f4d48e3c', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'boiler', 'Boilers', 'gas_safety', ARRAY['2023 Allianz VOC - 32-34 Connuaght Square (Freehold) Limited.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('3a81a221-91c0-4590-9354-44f2100be798', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'lift', 'Lift - Powered', 'lifts_safety', ARRAY['2023 Allianz VOC - 32-34 Connuaght Square (Freehold) Limited.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('0d46f64c-e343-4f02-a1ab-42a504d5ff0b', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'pump', 'Pumps', 'water_safety', ARRAY['2023 Allianz VOC - 32-34 Connuaght Square (Freehold) Limited.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('f220b2fd-ea9b-41b8-bd16-fe3207616128', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'boiler', 'Boilers', 'gas_safety', ARRAY['2023 Engineering Renewal Notice - 32 34 Connuaght Square (Freehold) Limited.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('3b2a23d7-600c-4b16-ba6a-8e9361114239', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'lift', 'Lift -
Powered', 'lifts_safety', ARRAY['2023 Engineering Renewal Notice - 32 34 Connuaght Square (Freehold) Limited.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('359af4fd-56f7-4090-8f21-80d255329138', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'pump', 'Pumps', 'water_safety', ARRAY['2023 Engineering Renewal Notice - 32 34 Connuaght Square (Freehold) Limited.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('3a0c1568-1cd2-41d0-af33-de462120e2fe', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'lift', 'Lift', 'lifts_safety', ARRAY['32-34 Connaught Sq Buildings Insurance 2023-2024.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('f7c2863d-e134-4996-8753-31245301f635', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'lift', 'Lift Report', 'lifts_safety', ARRAY['Allianz - Lift Report 14.03.23.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('b72c081d-d1dc-4981-91bd-17c30b6c3227', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'lift', 'Lift Report', 'lifts_safety', ARRAY['Allianz-Lift Report 18.03.2024.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('99e767e2-c4ab-432e-800a-afe4c4add28a', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'lift', 'Lift Report', 'lifts_safety', ARRAY['Allianz - Lift Report - 15.09.21.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('6c14c281-1662-444f-9242-c5ed43f5f6d8', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'lift', 'Lift Report', 'lifts_safety', ARRAY['Allianz - Lift Report 10.03.22.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('488fb2ce-90c4-4c76-b008-522928bd01cf', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'boiler', 'Boilers', 'gas_safety', ARRAY['2023 Allianz VOC - 32-34 Connuaght Square (Freehold) Limited.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('e758ab44-c342-43b4-afee-dc239f5d9d08', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'lift', 'Lift - Powered', 'lifts_safety', ARRAY['2023 Allianz VOC - 32-34 Connuaght Square (Freehold) Limited.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('b250cbf1-39db-4cd0-835b-1c45ff4b5864', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'pump', 'Pumps', 'water_safety', ARRAY['2023 Allianz VOC - 32-34 Connuaght Square (Freehold) Limited.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('e715b9e9-c5c9-4051-9d6d-487f5a93c1ee', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'boiler', 'Boilers', 'gas_safety', ARRAY['2023 Engineering Renewal Notice - 32 34 Connuaght Square (Freehold) Limited.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('4b0e9602-94e6-4b74-b844-8ccee3532e17', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'lift', 'Lift -
Powered', 'lifts_safety', ARRAY['2023 Engineering Renewal Notice - 32 34 Connuaght Square (Freehold) Limited.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('b2f63c22-2f66-4164-8af2-d7bed08f013b', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'pump', 'Pumps', 'water_safety', ARRAY['2023 Engineering Renewal Notice - 32 34 Connuaght Square (Freehold) Limited.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, location_description, compliance_category, linked_documents) VALUES ('a2d120bd-91dd-4439-93b4-b027e9744dac', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'boiler', 'Boiler and', 'owned by or leased', 'gas_safety', ARRAY['MO - Policy Wording - NZ0411.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('1b1c116c-b290-4acd-9f0a-10aaca3f5473', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'lift', 'Lift and', 'lifts_safety', ARRAY['MO - Policy Wording - NZ0411.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('3f43cc64-3d07-42fc-ba97-d1b3375629ef', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'pump', 'pumps', 'water_safety', ARRAY['MO - Policy Wording - NZ0411.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('d6a5c8dd-34d1-4b11-8236-bcb80fde51dc', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'water_tank', 'Storage Tanks', 'water_safety', ARRAY['MO - Policy Wording - NZ0411.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('d95c51c0-235f-4eb9-9b86-3a71978233d5', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'generator', 'generator sets', 'electrical_safety', ARRAY['MO - Policy Wording - NZ0411.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('c2242277-8a5c-404c-a0e5-5f02817bcf99', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'lift', 'Lift and', 'lifts_safety', ARRAY['Feature and Benefits of Allianz Engineering Inspection Service.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('3fead831-1ecc-436a-a269-c08ff89ca578', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'boiler', 'Boilers', 'gas_safety', ARRAY['StG_Statement of Facts_32-34 Connaught Square W2 2HL.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('ec90631a-db2c-4bc2-95da-3711a1d14484', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'lift', 'Lifts', 'lifts_safety', ARRAY['StG_Statement of Facts_32-34 Connaught Square W2 2HL.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('7d2ed7f2-9ac9-43c4-bb3b-914c9e5a58a8', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'pump', 'Centrifugal pump', 'water_safety', ARRAY['StG_Statement of Facts_32-34 Connaught Square W2 2HL.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('120283ef-116d-408f-8d1f-9da196255d1c', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'boiler', 'Boilers', 'gas_safety', ARRAY['StG_Insurance Report_32-34 Connaught Square W2 2HL.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('febae372-fa14-42de-acc3-507f2039c2a7', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'lift', 'Lifts', 'lifts_safety', ARRAY['StG_Insurance Report_32-34 Connaught Square W2 2HL.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('ee653781-c4a0-48ad-ab0f-034ef164970b', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'pump', 'Centrifugal pump', 'water_safety', ARRAY['StG_Insurance Report_32-34 Connaught Square W2 2HL.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('fffa8b3c-97ad-46b3-bba8-6ef962c0e1f4', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'boiler', 'Boilers', 'gas_safety', ARRAY['StG_Statement of Facts_32-34 Connaught Square W2 2HL.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('7df018f7-15c0-4f50-9dea-d64c7a65f23c', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'lift', 'Lifts', 'lifts_safety', ARRAY['StG_Statement of Facts_32-34 Connaught Square W2 2HL.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('ef5f0f00-b0b3-4bb1-aaf3-9cc576f165cc', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'pump', 'Centrifugal pump', 'water_safety', ARRAY['StG_Statement of Facts_32-34 Connaught Square W2 2HL.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('d9813302-2897-42ba-a9fc-4071e5b8aaa5', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'boiler', 'Boilers', 'gas_safety', ARRAY['StG_Insurance Report_32-34 Connaught Square W2 2HL.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('fddea638-1a7c-413b-85bf-0fef0e5ae49e', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'lift', 'Lifts', 'lifts_safety', ARRAY['StG_Insurance Report_32-34 Connaught Square W2 2HL.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('e1a3b348-f8ee-4bca-9bc1-4eec3254a970', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'pump', 'Centrifugal pump', 'water_safety', ARRAY['StG_Insurance Report_32-34 Connaught Square W2 2HL.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('499dbdfd-3d5c-4a8f-a282-459b76d04a3d', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'boiler', 'water boiler', 'gas_safety', ARRAY['StG_Certificate_32-34 Connaught Square W2 2HL.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('f34ddf6b-94cb-44b0-a05a-0f2005b4df4e', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'lift', 'Passenger Lift', 'lifts_safety', ARRAY['StG_Certificate_32-34 Connaught Square W2 2HL.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('c2408dbe-ffc4-4bac-9291-d4f226eb9fdb', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'pump', 'Centrifugal pump', 'water_safety', ARRAY['StG_Certificate_32-34 Connaught Square W2 2HL.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('d639dad8-28f4-4d9d-bd5e-5d5dccdc8eec', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'boiler', 'Boilers', 'gas_safety', ARRAY['StG_Statement of Fact_32-34 Connaught Square W2 2HL.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('ea2a44eb-5dc6-4558-b079-7222ca393d32', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'lift', 'Lifts', 'lifts_safety', ARRAY['StG_Statement of Fact_32-34 Connaught Square W2 2HL.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('f1323e22-9577-4c70-941c-2545386e6b82', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'pump', '1x Pump', 'water_safety', ARRAY['StG_Statement of Fact_32-34 Connaught Square W2 2HL.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('78e70da9-19a4-4d16-89ba-209c39457a56', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'lift', 'Lift', 'lifts_safety', ARRAY['FBR113382303-20230405-B.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('ac2a467b-d632-46d0-aad1-25c575c1a4e7', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'boiler', 'boilers', 'gas_safety', ARRAY['Real Estate Policy (01.23).pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('40ecd0cb-6307-4b00-9394-a00f91a6242b', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'sprinkler', 'sprinkler leakage', 'fire_safety', ARRAY['Real Estate Policy (01.23).pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('09573b58-79e2-4a2f-97f1-d019292f87ea', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'pump', 'pumping', 'water_safety', ARRAY['Real Estate Policy (01.23).pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('26acbe68-8a81-4d74-b959-ffbad729ef9b', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'cctv', 'cameras', 'security', ARRAY['Real Estate Policy (01.23).pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('cc7d36b5-992b-4439-af3a-84ce72e49497', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'fire_extinguisher', 'fire extinguishers', 'fire_safety', ARRAY['Real Estate Policy (01.23).pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('535b46c3-ace6-4f63-86e2-889477077fff', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'communal_aerial', 'satellite dishes', 'other', ARRAY['Real Estate Policy (01.23).pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('5a888dbc-4b99-40ab-9c83-11291575c77c', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'water_tank', 'water tanks', 'water_safety', ARRAY['Real Estate Policy (01.23).pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('65e966d8-804a-4da5-a816-6256e8c4557e', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'sprinkler', 'sprinkler installation', 'fire_safety', ARRAY['Summary of Cover (01.23).pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('24037056-06ea-4a5a-9410-d92f2fed85fd', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'lift', 'lift in', 'lifts_safety', ARRAY['Summary of Cover (01.23).pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('a0d417b7-df8b-488a-a898-ffb7521a06a0', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'lift', 'Lift', 'lifts_safety', ARRAY['32-34 Connaught Sq Buildings Insurance 2023-2024.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('3e39bdaf-736d-4cab-b3ed-e160e4f77649', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'sprinkler', 'sprinkler installation', 'fire_safety', ARRAY['Zurich Real Estate Policy Summary.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('205c996f-8955-4475-ab85-3164f21c92fe', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'lift', 'lift in', 'lifts_safety', ARRAY['Zurich Real Estate Policy Summary.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('371da8d0-f5f1-4e0f-9da0-f76325558b51', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'boiler', 'boilers', 'gas_safety', ARRAY['Zurich Real Estate Policy Wording.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('8052a3fb-07f2-437f-a5ce-206534fe5cde', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'sprinkler', 'sprinkler leakage', 'fire_safety', ARRAY['Zurich Real Estate Policy Wording.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('af04e011-81a8-4ad5-9309-a9b0de1848a5', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'pump', 'pumping', 'water_safety', ARRAY['Zurich Real Estate Policy Wording.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('590f8e8c-296c-46a7-9777-c3c0568319d2', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'cctv', 'cameras', 'security', ARRAY['Zurich Real Estate Policy Wording.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('40cda36b-14a2-48f0-8118-06a0b41a848b', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'fire_extinguisher', 'fire extinguishers', 'fire_safety', ARRAY['Zurich Real Estate Policy Wording.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('7126fce0-3985-40a9-9551-144c93053112', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'communal_aerial', 'satellite dishes', 'other', ARRAY['Zurich Real Estate Policy Wording.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('c9cc9a73-7e6e-4eaa-bc30-b5da43640750', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'water_tank', 'water tanks', 'water_safety', ARRAY['Zurich Real Estate Policy Wording.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('6b3552a0-252a-4507-b8a5-40261f34eb20', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'lift', 'Lift', 'lifts_safety', ARRAY['StG_Certificate_32-34 Connaught Square W2 2HL.pdf']);

-- Insert 22 maintenance schedules
INSERT INTO maintenance_schedules (id, building_id, contract_id, service_type, description, frequency, frequency_interval, next_due_date, estimated_duration, priority, status) VALUES ('eda88ffd-9a78-4b18-b17b-bf43fc08f62a', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'c38d5f2c-ee41-459d-a6b2-46ebb7a52e91', 'lifts', 'lifts - ISS', 'monthly', '1 month', '2025-11-09', '4 hours', 'high', 'scheduled');
INSERT INTO maintenance_schedules (id, building_id, contract_id, service_type, description, frequency, frequency_interval, next_due_date, estimated_duration, priority, status) VALUES ('e6f89d03-ab4c-4a36-8347-dbc5c3db403a', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', '05f3e48b-ee61-4bbf-9504-c1f89d17c7ce', 'security', 'security - ISS', 'quarterly', '3 months', '2026-01-09', '8 hours', 'medium', 'scheduled');
INSERT INTO maintenance_schedules (id, building_id, contract_id, service_type, description, frequency, frequency_interval, next_due_date, estimated_duration, priority, status) VALUES ('52af8c6e-684b-49b9-baf4-4190ac6f12ae', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', '5dd9d1f2-c297-43b0-9e49-2850aab2e029', 'security', 'security - ISS', 'quarterly', '3 months', '2026-01-09', '8 hours', 'medium', 'scheduled');
INSERT INTO maintenance_schedules (id, building_id, contract_id, service_type, description, frequency, frequency_interval, next_due_date, estimated_duration, priority, status) VALUES ('bee04501-accb-4824-8959-f3aba65e96c1', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'd2f5450d-207b-4c1f-89ee-443efabbce2b', 'lifts', 'lifts - ISS', 'monthly', '1 month', '2025-11-09', '4 hours', 'high', 'scheduled');
INSERT INTO maintenance_schedules (id, building_id, contract_id, service_type, description, frequency, frequency_interval, next_due_date, estimated_duration, priority, status) VALUES ('0b898c9a-0686-47fa-b9ac-5481a43f3f8e', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'c10a4976-5b19-4b52-962e-92e72ce6e885', 'lifts', 'lifts - ISS', 'monthly', '1 month', '2025-11-09', '4 hours', 'high', 'scheduled');
INSERT INTO maintenance_schedules (id, building_id, contract_id, service_type, description, frequency, frequency_interval, next_due_date, estimated_duration, priority, status) VALUES ('ccbdd00a-48b6-41f9-93fb-ca4604c4b43c', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'e29e7aea-dd5a-4c5b-964c-4ffda15750bd', 'lifts', 'lifts - ISS', 'monthly', '1 month', '2025-11-09', '4 hours', 'high', 'scheduled');
INSERT INTO maintenance_schedules (id, building_id, contract_id, service_type, description, frequency, frequency_interval, next_due_date, estimated_duration, priority, status) VALUES ('21aadf6b-f699-49f6-8061-f774baa3143e', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'c5a40f1c-16ea-4beb-a4e8-299489f08cc4', 'lifts', 'lifts - ISS', 'monthly', '1 month', '2025-11-09', '4 hours', 'high', 'scheduled');
INSERT INTO maintenance_schedules (id, building_id, contract_id, service_type, description, frequency, frequency_interval, next_due_date, estimated_duration, priority, status) VALUES ('fcd4f822-36b2-4daa-a1f5-26f9e0e3701b', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', '5a446bf4-689e-46a1-a122-f2236df80e08', 'lifts', 'lifts - ISS', 'annual', '12 months', '2026-03-14', '4 hours', 'high', 'scheduled');
INSERT INTO maintenance_schedules (id, building_id, contract_id, service_type, description, frequency, frequency_interval, next_due_date, estimated_duration, priority, status) VALUES ('65056a45-5814-4750-94dd-90e04a5b283c', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'c9b71949-f6c8-4810-8b3a-dd61585f4c3c', 'lifts', 'lifts - None', 'monthly', '1 month', '2025-02-13', '4 hours', 'high', 'scheduled');
INSERT INTO maintenance_schedules (id, building_id, contract_id, description, frequency, frequency_interval, next_due_date, priority, status) VALUES ('8f21023c-b1d4-49e4-a6e6-65739e53e8a8', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', '85ac3f20-bef0-4452-81eb-ceeef2016991', 'None - WHM', 'monthly', '1 month', '2025-11-09', 'medium', 'scheduled');
INSERT INTO maintenance_schedules (id, building_id, contract_id, description, frequency, frequency_interval, next_due_date, priority, status) VALUES ('d45e246f-b41e-40bd-b5d8-1a6eec482c0f', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', '6deb1132-6545-451a-bd1c-021ed39623b6', 'None - WHM', 'monthly', '1 month', '2025-11-09', 'medium', 'scheduled');
INSERT INTO maintenance_schedules (id, building_id, contract_id, description, frequency, frequency_interval, next_due_date, priority, status) VALUES ('30b6ecf2-0f51-4523-87a2-cdce830f96a6', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', '4a8e3900-7101-4151-890e-73818bf2f585', 'None - WHM', 'monthly', '1 month', '2025-11-09', 'medium', 'scheduled');
INSERT INTO maintenance_schedules (id, building_id, contract_id, description, frequency, frequency_interval, next_due_date, priority, status) VALUES ('7e7c0a79-4b3f-43cc-b176-fc3eaf301f61', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'a9d328f4-eefc-43d4-8626-163d27d34406', 'None - WHM', 'monthly', '1 month', '2025-11-09', 'medium', 'scheduled');
INSERT INTO maintenance_schedules (id, building_id, contract_id, service_type, description, frequency, frequency_interval, next_due_date, estimated_duration, priority, status) VALUES ('7d7e001a-e688-4859-9a2b-9d9136f6b6de', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', '4efef4c7-a090-43d2-8f95-bd0a9978d3f5', 'security', 'security - Capita', 'monthly', '1 month', '2025-11-09', '8 hours', 'medium', 'scheduled');
INSERT INTO maintenance_schedules (id, building_id, contract_id, service_type, description, frequency, frequency_interval, next_due_date, estimated_duration, priority, status) VALUES ('74ccf1af-ac84-41c2-a412-fc5124a9d537', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', '66a5628c-784d-4ce7-a513-bab9f3c27a62', 'fire_alarm', 'fire_alarm - Capita', 'monthly', '1 month', '2025-11-09', '2 hours', 'high', 'scheduled');
INSERT INTO maintenance_schedules (id, building_id, contract_id, service_type, description, frequency, frequency_interval, next_due_date, estimated_duration, priority, status) VALUES ('fcd4a777-64e4-4395-bfef-653c33866679', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', '7c1762e6-4ea8-45a6-8403-5f8f586eadf2', 'fire_alarm', 'fire_alarm - None', 'monthly', '1 month', '2025-11-09', '2 hours', 'high', 'scheduled');
INSERT INTO maintenance_schedules (id, building_id, contract_id, service_type, description, frequency, frequency_interval, next_due_date, estimated_duration, priority, status) VALUES ('1800459d-c4bd-48f8-be21-23f7f3198d47', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', '7ced52c1-0bd7-4e0a-b660-4b5a0f673c18', 'fire_alarm', 'fire_alarm - None', 'monthly', '1 month', '2025-11-09', '2 hours', 'high', 'scheduled');
INSERT INTO maintenance_schedules (id, building_id, contract_id, service_type, description, frequency, frequency_interval, next_due_date, estimated_duration, priority, status) VALUES ('d981678c-7404-4d46-a441-4ee639be7f3f', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'acddcdc1-11ad-4b9b-b3cc-8e39c44d5601', 'fire_alarm', 'fire_alarm - None', 'monthly', '1 month', '2025-11-09', '2 hours', 'high', 'scheduled');
INSERT INTO maintenance_schedules (id, building_id, contract_id, description, frequency, frequency_interval, next_due_date, priority, status) VALUES ('fe35f237-9ee2-44a7-8331-56d0dd421057', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', '77bd54bb-4ef0-47e6-9682-08e1ba4f8b59', 'None - WHM', 'monthly', '1 month', '2025-11-09', 'medium', 'scheduled');
INSERT INTO maintenance_schedules (id, building_id, contract_id, description, frequency, frequency_interval, next_due_date, priority, status) VALUES ('e6325741-e474-4aa0-9eb6-5bc6e4c3f5bf', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', '8ec5b141-5974-4e64-bad5-af6758c6d2ba', 'None - None', 'monthly', '1 month', '2025-11-09', 'medium', 'scheduled');
INSERT INTO maintenance_schedules (id, building_id, contract_id, description, frequency, frequency_interval, next_due_date, priority, status) VALUES ('73296b6f-ed99-48da-93af-c400cc782c61', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', '8b5e5009-47f0-4db3-857c-f712c99b09d9', 'None - None', 'monthly', '1 month', '2025-11-09', 'medium', 'scheduled');
INSERT INTO maintenance_schedules (id, building_id, contract_id, description, frequency, frequency_interval, next_due_date, priority, status) VALUES ('39aa2966-053a-4320-ba68-437a9c28e15e', 'ee49577b-36b0-4594-8406-65f3fc6c4eef', 'c0ccd0c4-7423-45d3-8b99-604a3b710524', 'None - None', 'monthly', '1 month', '2025-11-09', 'medium', 'scheduled');

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
    '04f2e2de-105c-48be-b2da-a75fcebb5f15',
    'ee49577b-36b0-4594-8406-65f3fc6c4eef',
    'ab9e548c-2513-41b0-b7a5-df79c2a81f82',
    'Unknown',
    'service_charge',
    NULL  -- Requires manual entry
)
ON CONFLICT (id) DO NOTHING;

-- Fallback budget for unstructured PDF
INSERT INTO budgets (id, building_id, document_id, period, budget_type, total_amount)
VALUES (
    'ae28f941-5d98-407f-8bd0-75c727eb5416',
    'ee49577b-36b0-4594-8406-65f3fc6c4eef',
    '6ad02838-a8a6-4fbc-ae4e-550762b00b9b',
    'Unknown',
    'service_charge',
    NULL  -- Requires manual entry
)
ON CONFLICT (id) DO NOTHING;

-- Fallback budget for unstructured PDF
INSERT INTO budgets (id, building_id, document_id, period, budget_type, total_amount)
VALUES (
    '27f271c9-3fe2-40dd-94ba-1a89027d8ac9',
    'ee49577b-36b0-4594-8406-65f3fc6c4eef',
    '53912b96-ccce-4dc4-ac4e-997962ba95b7',
    'Unknown',
    'service_charge',
    NULL  -- Requires manual entry
)
ON CONFLICT (id) DO NOTHING;

-- Fallback budget for unstructured PDF
INSERT INTO budgets (id, building_id, document_id, period, budget_type, total_amount)
VALUES (
    'a6383ff6-b06a-4fb0-901f-f9ca89c7c2c4',
    'ee49577b-36b0-4594-8406-65f3fc6c4eef',
    '486f923f-6293-47c0-9d9f-6ca1ed058976',
    'Unknown',
    'service_charge',
    NULL  -- Requires manual entry
)
ON CONFLICT (id) DO NOTHING;

-- Fallback budget for unstructured PDF
INSERT INTO budgets (id, building_id, document_id, period, budget_type, total_amount)
VALUES (
    '3a6e06c6-32d5-4d25-9808-5a562c0cca74',
    'ee49577b-36b0-4594-8406-65f3fc6c4eef',
    'e46a99c2-48ea-42bf-815e-18a8d0222fe2',
    '2025',
    'service_charge',
    NULL  -- Requires manual entry
)
ON CONFLICT (id) DO NOTHING;

-- Fallback budget for unstructured PDF
INSERT INTO budgets (id, building_id, document_id, period, budget_type, total_amount)
VALUES (
    '3ec3dfa2-4f0a-4e57-86d0-ece5f876ead7',
    'ee49577b-36b0-4594-8406-65f3fc6c4eef',
    '765596f6-65a9-4fc2-a116-d5b4acc1c856',
    '2025',
    'service_charge',
    NULL  -- Requires manual entry
)
ON CONFLICT (id) DO NOTHING;

-- Fallback budget for unstructured PDF
INSERT INTO budgets (id, building_id, document_id, period, budget_type, total_amount)
VALUES (
    '57a25eae-639b-49e0-8de5-0cea1488845e',
    'ee49577b-36b0-4594-8406-65f3fc6c4eef',
    '125b87b0-1a64-4b04-9ac8-10327a3c0227',
    '2025',
    'service_charge',
    NULL  -- Requires manual entry
)
ON CONFLICT (id) DO NOTHING;

-- Fallback budget for unstructured PDF
INSERT INTO budgets (id, building_id, document_id, period, budget_type, total_amount)
VALUES (
    '28453440-8af8-4a17-b10b-6f7fe6b20fcd',
    'ee49577b-36b0-4594-8406-65f3fc6c4eef',
    'f42a4b14-0273-4642-bb9e-1ceb87e143b5',
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
    'ca616d6a-e4b0-4037-a565-3df1da4ad5fa',
    'ee49577b-36b0-4594-8406-65f3fc6c4eef',
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
    '6162367f-f33b-4c62-83dc-9c95dbf171a0',
    'ee49577b-36b0-4594-8406-65f3fc6c4eef',
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
    '0b90a0c7-c4d3-41d3-8c36-5004c70349a3',
    'ee49577b-36b0-4594-8406-65f3fc6c4eef',
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
    'e082a091-4888-494e-a712-31edadc60737',
    'ee49577b-36b0-4594-8406-65f3fc6c4eef',
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
    'f32b26c8-f872-41cc-87c8-05ad3facca47',
    'ee49577b-36b0-4594-8406-65f3fc6c4eef',
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
    '481d1664-405a-48e6-8c7b-41e4187b0293',
    'ee49577b-36b0-4594-8406-65f3fc6c4eef',
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
    'b164c7ce-2441-4106-9add-c29795e4f3d8',
    'ee49577b-36b0-4594-8406-65f3fc6c4eef',
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
    '3393f3b0-734b-496d-b25d-cc239ea5f6cd',
    'ee49577b-36b0-4594-8406-65f3fc6c4eef',
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
    '956e5dd7-712b-4cb0-b77d-440a95ea4f15',
    'ee49577b-36b0-4594-8406-65f3fc6c4eef',
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
    '0d1ad2c7-617c-498b-bd95-e78f2cba2cdc',
    'ee49577b-36b0-4594-8406-65f3fc6c4eef',
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
    '53f2436b-b8e5-402e-a014-62245e209a13',
    'ee49577b-36b0-4594-8406-65f3fc6c4eef',
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
    '3fe7668d-3382-413d-a738-eeeb01922308',
    'ee49577b-36b0-4594-8406-65f3fc6c4eef',
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
    '17f83ac9-513b-4d84-b63f-e58f4ac1055f',
    'ee49577b-36b0-4594-8406-65f3fc6c4eef',
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
    '3543fa5d-0b94-41ba-9931-e32a3ad8c3e2',
    'ee49577b-36b0-4594-8406-65f3fc6c4eef',
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
    'faf58fe6-07d8-49d8-9704-ebc70186fa94',
    'ee49577b-36b0-4594-8406-65f3fc6c4eef',
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
    'b43aa7fa-91fe-45f0-85aa-006704983de2',
    'ee49577b-36b0-4594-8406-65f3fc6c4eef',
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
    '2b9169cb-9399-4edd-88d5-26bb9241eb49',
    'ee49577b-36b0-4594-8406-65f3fc6c4eef',
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
    '7dad4475-bd76-4a1f-9ee2-f3069f0f6497',
    'ee49577b-36b0-4594-8406-65f3fc6c4eef',
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
    '4356fd9e-a07e-4849-b557-78db76dc5516',
    'ee49577b-36b0-4594-8406-65f3fc6c4eef',
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
    'f854d6c2-1429-46be-a6fe-18928caed36e',
    'ee49577b-36b0-4594-8406-65f3fc6c4eef',
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
    '8f83a2b0-3b77-400f-ae17-1b73571fa300',
    'ee49577b-36b0-4594-8406-65f3fc6c4eef',
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
    '87507931-2727-4722-becf-15dc2cd64e5e',
    'ee49577b-36b0-4594-8406-65f3fc6c4eef',
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
    '56e6972e-66c8-4f87-89e0-b4ac19b46fe9',
    'ee49577b-36b0-4594-8406-65f3fc6c4eef',
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
    'fbb189da-1089-47fd-8528-56941d23a481',
    'ee49577b-36b0-4594-8406-65f3fc6c4eef',
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
    '94efcbf1-a3dd-4724-8c31-165463fdd4a6',
    'ee49577b-36b0-4594-8406-65f3fc6c4eef',
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
    '60d45aed-b57f-4b12-b152-274d13fe80fb',
    'ee49577b-36b0-4594-8406-65f3fc6c4eef',
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
    'e6ea1036-7a2f-4259-a403-44d39cd691b3',
    'ee49577b-36b0-4594-8406-65f3fc6c4eef',
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
    '077db534-eccd-4fb1-9101-9dc043aa5c21',
    'ee49577b-36b0-4594-8406-65f3fc6c4eef',
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
    '5b3d8554-68c3-4621-a647-72118d2a660e',
    'ee49577b-36b0-4594-8406-65f3fc6c4eef',
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
    'bd101827-5d59-4ddd-8a6f-65ece3585e58',
    'ee49577b-36b0-4594-8406-65f3fc6c4eef',
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
    '6192bb5b-cc44-4b5f-8637-ca3c0be857b4',
    'ee49577b-36b0-4594-8406-65f3fc6c4eef',
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
    'af6af2ab-8a37-4ecd-a5bb-8bb08fc20f22',
    'ee49577b-36b0-4594-8406-65f3fc6c4eef',
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
    '77ec3d73-5e31-483a-bc69-0b74447bd0cb',
    'ee49577b-36b0-4594-8406-65f3fc6c4eef',
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
    '26d27481-aeab-49d1-96ee-4dce18f0703f',
    'ee49577b-36b0-4594-8406-65f3fc6c4eef',
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
    'b786e754-02c2-4d08-96dc-c30156683389',
    'ee49577b-36b0-4594-8406-65f3fc6c4eef',
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
    '3a5c2a03-8080-427b-b2b9-7861ae609b14',
    'ee49577b-36b0-4594-8406-65f3fc6c4eef',
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
    '4ea650fa-7388-42bd-b43f-263bf0b5a731',
    'ee49577b-36b0-4594-8406-65f3fc6c4eef',
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
    '42e8c6af-d457-4b32-86f4-7a2e8c503cb9',
    'ee49577b-36b0-4594-8406-65f3fc6c4eef',
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
    'aead61a5-5749-49b6-995f-d083c0d38296',
    'ee49577b-36b0-4594-8406-65f3fc6c4eef',
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
    'eee4f7da-d4bc-4c32-a072-41840aa40399',
    'ee49577b-36b0-4594-8406-65f3fc6c4eef',
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
    '04fb0e48-6960-43eb-93a0-8776d2971c2a',
    'ee49577b-36b0-4594-8406-65f3fc6c4eef',
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
    'bbe607c8-b144-4bbe-a020-c16cd63f37d3',
    'ee49577b-36b0-4594-8406-65f3fc6c4eef',
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
    '2a6828a2-5930-4138-91bc-8424a2293a3a',
    'ee49577b-36b0-4594-8406-65f3fc6c4eef',
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
    '9bbc9107-b577-4213-8078-64ff492eb813',
    'ee49577b-36b0-4594-8406-65f3fc6c4eef',
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
    '38979687-15e0-4fd0-a0ef-7cf6dfdbb312',
    'ee49577b-36b0-4594-8406-65f3fc6c4eef',
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
    '480d3e0d-9489-412e-80ef-4cc0028d6516',
    'ee49577b-36b0-4594-8406-65f3fc6c4eef',
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
    '8889be83-72ef-46f8-afbf-0ad221e1c68c',
    'ee49577b-36b0-4594-8406-65f3fc6c4eef',
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
    '1d2cdd4e-d22c-4558-b17b-31188782200b',
    'ee49577b-36b0-4594-8406-65f3fc6c4eef',
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
    '23206f13-6e13-452f-99cb-bf10ddfb790f',
    'ee49577b-36b0-4594-8406-65f3fc6c4eef',
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
    '04e2cf93-cc40-475f-a662-14906da06d24',
    'ee49577b-36b0-4594-8406-65f3fc6c4eef',
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
    '9c473d83-2dcc-40cd-b0b7-0ac61cef9442',
    'ee49577b-36b0-4594-8406-65f3fc6c4eef',
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
    '3e8656e3-8a49-4651-8946-784a1f9a4dd2',
    'ee49577b-36b0-4594-8406-65f3fc6c4eef',
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
    'b092a6f5-4b94-4bb2-b0a1-194c3a7063af',
    'ee49577b-36b0-4594-8406-65f3fc6c4eef',
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
    'cbf404dc-0f6d-4421-b95f-f58ae75ad7bf',
    'ee49577b-36b0-4594-8406-65f3fc6c4eef',
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
    '627762a6-7576-4dd7-b8e6-e9799c363811',
    'ee49577b-36b0-4594-8406-65f3fc6c4eef',
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
    '3cf4d373-ef67-4168-b0e9-01cda35cfa4a',
    'ee49577b-36b0-4594-8406-65f3fc6c4eef',
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
    'ed3f9692-6535-4d98-a73e-81336bc84109',
    'ee49577b-36b0-4594-8406-65f3fc6c4eef',
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
    '80fc5668-1756-45cd-8384-414df74cc464',
    'ee49577b-36b0-4594-8406-65f3fc6c4eef',
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
    'e0e2befb-38df-4b97-93e6-565193d5e32e',
    'ee49577b-36b0-4594-8406-65f3fc6c4eef',
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
    'bb7db710-e08b-450b-be8b-27842d2d6b17',
    'ee49577b-36b0-4594-8406-65f3fc6c4eef',
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
    '3c2552fe-8497-4941-ab45-4d625718be85',
    'ee49577b-36b0-4594-8406-65f3fc6c4eef',
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
    '1860a75c-f4fe-467c-9e0e-3eeff8e0599b',
    'ee49577b-36b0-4594-8406-65f3fc6c4eef',
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
    '61330bf4-0d00-4cb9-bd17-b2290c737eb5',
    'ee49577b-36b0-4594-8406-65f3fc6c4eef',
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
    '34cb4d12-c798-4119-894c-2db8242eaa12',
    'ee49577b-36b0-4594-8406-65f3fc6c4eef',
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
    'a88ead34-10df-4586-9b5e-abfb01eb6be8',
    'ee49577b-36b0-4594-8406-65f3fc6c4eef',
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
    'b7a1ae13-ecfd-4299-b4b0-e246b18fc9f4',
    'ee49577b-36b0-4594-8406-65f3fc6c4eef',
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
    '3fc1ff33-c24f-413e-be49-b0e7db1b000c',
    'ee49577b-36b0-4594-8406-65f3fc6c4eef',
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
    '14c12716-01d4-4872-ac9a-f6ae1618ff85',
    'ee49577b-36b0-4594-8406-65f3fc6c4eef',
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
    '35b13798-7b1c-4cda-b0ad-7a557e554978',
    'ee49577b-36b0-4594-8406-65f3fc6c4eef',
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
    '2eb2d278-c55b-4a18-93de-27a0cdc56e21',
    'ee49577b-36b0-4594-8406-65f3fc6c4eef',
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
    'ed752960-b2d9-4fad-8d1d-b444b8c7a625',
    'ee49577b-36b0-4594-8406-65f3fc6c4eef',
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
    '124bce98-39b8-4445-826e-13cc2569c52c',
    'ee49577b-36b0-4594-8406-65f3fc6c4eef',
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
    '26fef933-134d-4369-9a41-19eceadd5610',
    'ee49577b-36b0-4594-8406-65f3fc6c4eef',
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
    'c33f4b81-cf58-4d55-91f0-e30ddae4c98c',
    'ee49577b-36b0-4594-8406-65f3fc6c4eef',
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
    'b08df52d-c19e-4887-b48c-f7fee1938d33',
    'ee49577b-36b0-4594-8406-65f3fc6c4eef',
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
    '9c6f4f57-ab25-4166-84a9-5541dca5b1c3',
    'ee49577b-36b0-4594-8406-65f3fc6c4eef',
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
    'd3d3cf02-99a0-441c-99e0-da82e1dc0765',
    'ee49577b-36b0-4594-8406-65f3fc6c4eef',
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
    '814ac651-21c4-46a5-a3bc-41c0b614a7fa',
    'ee49577b-36b0-4594-8406-65f3fc6c4eef',
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
    '66b2c4d6-6c3a-4483-894e-56447d953fa0',
    'ee49577b-36b0-4594-8406-65f3fc6c4eef',
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
    'ef5622a6-e085-44af-9751-f513b21fbfb3',
    'ee49577b-36b0-4594-8406-65f3fc6c4eef',
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
    'ff9ce983-2907-4235-ba3f-f6366529b46a',
    'ee49577b-36b0-4594-8406-65f3fc6c4eef',
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
    'c12f7b86-2856-4869-ae31-a5b7a5ad2772',
    'ee49577b-36b0-4594-8406-65f3fc6c4eef',
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
    'a4cbdfca-f637-4aca-a030-6669394bdfe8',
    'ee49577b-36b0-4594-8406-65f3fc6c4eef',
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
    'cf059833-7598-4355-bf24-a543253c5cf6',
    'ee49577b-36b0-4594-8406-65f3fc6c4eef',
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
    '9419abe7-6de4-40f9-8a87-f0ea51847f8b',
    'ee49577b-36b0-4594-8406-65f3fc6c4eef',
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
    'e39f3e4a-dade-41dd-8f5e-86abc7588940',
    'ee49577b-36b0-4594-8406-65f3fc6c4eef',
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
    'ba87b031-978f-4a98-a495-ffefb5005891',
    'ee49577b-36b0-4594-8406-65f3fc6c4eef',
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
    'c072b487-7242-4f81-96ae-b8a076dcae88',
    'ee49577b-36b0-4594-8406-65f3fc6c4eef',
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
    'f5e0b3c0-8261-49b2-9154-ca59c181a57c',
    'ee49577b-36b0-4594-8406-65f3fc6c4eef',
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
    'bdf3ab51-fe4d-4217-80f7-4798bec1ace6',
    'ee49577b-36b0-4594-8406-65f3fc6c4eef',
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
    '41390d52-7249-4734-819b-d159a210bf63',
    'ee49577b-36b0-4594-8406-65f3fc6c4eef',
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
    'e9c1152a-144e-4d80-9974-c0ac0bfb0217',
    'ee49577b-36b0-4594-8406-65f3fc6c4eef',
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
    '3f0f3bc3-7530-4e66-b174-375e31111aa3',
    'ee49577b-36b0-4594-8406-65f3fc6c4eef',
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
    '718e572c-dfb8-43e1-941f-1008a5b96dbd',
    'ee49577b-36b0-4594-8406-65f3fc6c4eef',
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
    'f7b740a0-c284-4d69-850f-0b32f0179a7f',
    'ee49577b-36b0-4594-8406-65f3fc6c4eef',
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
    'cdb0ed20-9967-44a4-b62f-b2577e9b8f1d',
    'ee49577b-36b0-4594-8406-65f3fc6c4eef',
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
    '0266f938-1f37-4718-8501-08366332481d',
    'ee49577b-36b0-4594-8406-65f3fc6c4eef',
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
    'bf3c264a-0581-4d45-89a7-7ecb5a76e74a',
    'ee49577b-36b0-4594-8406-65f3fc6c4eef',
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
    '9fb1ab55-dea1-4030-abdd-a4b42e8bb6f0',
    'ee49577b-36b0-4594-8406-65f3fc6c4eef',
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
    'aab5d68b-618e-45a1-8671-84d3f0293f57',
    'ee49577b-36b0-4594-8406-65f3fc6c4eef',
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
    'bae05f14-9e4a-4635-80f0-7976269ad1d6',
    'ee49577b-36b0-4594-8406-65f3fc6c4eef',
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
    '815892fa-87d0-4e51-97a8-fe6fef362236',
    'ee49577b-36b0-4594-8406-65f3fc6c4eef',
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
    '0f9bc731-050a-4a36-9195-b84c29b510f6',
    'ee49577b-36b0-4594-8406-65f3fc6c4eef',
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
    'baaf74e9-b97e-49f6-a546-d19012da4b45',
    'ee49577b-36b0-4594-8406-65f3fc6c4eef',
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
    'd4f03703-7728-4025-8354-fdbc47db6941',
    'ee49577b-36b0-4594-8406-65f3fc6c4eef',
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
    '4f2bd8ad-4d78-43c1-a896-8210f039be4e',
    'ee49577b-36b0-4594-8406-65f3fc6c4eef',
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
    'eb656e18-1937-4b3e-a61b-a4080392c344',
    'ee49577b-36b0-4594-8406-65f3fc6c4eef',
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
    '22d2f8ec-ad7d-479a-bbcf-811e1f0c9a31',
    'ee49577b-36b0-4594-8406-65f3fc6c4eef',
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
    'dd1d7134-1265-4487-9897-a2535913ae5c',
    'ee49577b-36b0-4594-8406-65f3fc6c4eef',
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
    'c575e672-1b48-471e-af16-a98877f6c338',
    'ee49577b-36b0-4594-8406-65f3fc6c4eef',
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
    'a0308cec-f739-404a-8fe3-a7e76afef0e4',
    'ee49577b-36b0-4594-8406-65f3fc6c4eef',
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
    'b3fa97d7-7119-4c63-8f66-14448d76160f',
    'ee49577b-36b0-4594-8406-65f3fc6c4eef',
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
    '1da73be1-a764-44ec-a2b2-17656dd23e99',
    'ee49577b-36b0-4594-8406-65f3fc6c4eef',
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
    'd46275ed-5003-41e7-9ff4-51ed4c659c55',
    'ee49577b-36b0-4594-8406-65f3fc6c4eef',
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
    'b3aa1b26-d626-4ea4-bf07-bbe5eb3be56e',
    'ee49577b-36b0-4594-8406-65f3fc6c4eef',
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
    'b80572f9-966d-43a6-a16c-b75bdd380bd8',
    'ee49577b-36b0-4594-8406-65f3fc6c4eef',
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
    '52069698-c910-47fe-bf07-eb994069f13b',
    'ee49577b-36b0-4594-8406-65f3fc6c4eef',
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
    '9083fd55-b973-4e5e-ab27-cd72f49b0832',
    'ee49577b-36b0-4594-8406-65f3fc6c4eef',
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
    'b5faca60-94c3-46f5-ab92-5641d0a5996a',
    'ee49577b-36b0-4594-8406-65f3fc6c4eef',
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
    'bc8c2c9d-8485-4f01-867c-3605887cab07',
    'ee49577b-36b0-4594-8406-65f3fc6c4eef',
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
    'f4f90039-8b79-49f6-9b36-300beac342bf',
    'ee49577b-36b0-4594-8406-65f3fc6c4eef',
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
    '601b8406-646a-4b33-9c45-9796fa8a6698',
    'ee49577b-36b0-4594-8406-65f3fc6c4eef',
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
    'f29041a3-d569-4614-8fca-9ca4f8a8cd4f',
    'ee49577b-36b0-4594-8406-65f3fc6c4eef',
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
    'e924131a-dce0-41d8-97d2-152b6f6581ae',
    'ee49577b-36b0-4594-8406-65f3fc6c4eef',
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
    '469ed9b4-e626-4cea-a621-f92c949c532c',
    'ee49577b-36b0-4594-8406-65f3fc6c4eef',
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
    '498b9838-db37-4493-9ff4-d218cc701e1e',
    'ee49577b-36b0-4594-8406-65f3fc6c4eef',
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
    'cb95858f-9dda-43fd-870b-8473835b1cab',
    'ee49577b-36b0-4594-8406-65f3fc6c4eef',
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
    '2c60830c-703d-4fbb-b08e-d35b057a1894',
    'ee49577b-36b0-4594-8406-65f3fc6c4eef',
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
    '723ac43a-b8b9-42b8-ae79-5ad4b6a83275',
    'ee49577b-36b0-4594-8406-65f3fc6c4eef',
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
    '62bc6b0d-a89a-4e46-b651-55a8e7d08c62',
    'ee49577b-36b0-4594-8406-65f3fc6c4eef',
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
    'b283ae07-9185-49dd-b2c9-1e230cb8e170',
    'ee49577b-36b0-4594-8406-65f3fc6c4eef',
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
    '96eece90-43e3-4086-b6dd-322ae2542658',
    'ee49577b-36b0-4594-8406-65f3fc6c4eef',
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
    '467ae11c-578b-4bef-8021-36337ca8450a',
    'ee49577b-36b0-4594-8406-65f3fc6c4eef',
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
    '089495fc-6a72-4094-913e-a1dd9a282ffc',
    'ee49577b-36b0-4594-8406-65f3fc6c4eef',
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
    '697ec149-6d66-4145-816d-3325fe4a53f5',
    'ee49577b-36b0-4594-8406-65f3fc6c4eef',
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
    '6b0de2a8-a16c-4e1e-8b24-8305f52fe24d',
    'ee49577b-36b0-4594-8406-65f3fc6c4eef',
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
    '9fa3f38f-6f01-4bcc-94f3-4ae935380a43',
    'ee49577b-36b0-4594-8406-65f3fc6c4eef',
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
    '2fa9b443-9b42-44df-8a2b-510e24748360',
    'ee49577b-36b0-4594-8406-65f3fc6c4eef',
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
    'fd8545ea-a038-4149-8ef7-d786c7888d7c',
    'ee49577b-36b0-4594-8406-65f3fc6c4eef',
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
    '9c5529dd-beef-41f7-9ed1-a1e1f1d877de',
    'ee49577b-36b0-4594-8406-65f3fc6c4eef',
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
    'b69e17d5-d131-4d86-a7c4-95e1c3a60800',
    'ee49577b-36b0-4594-8406-65f3fc6c4eef',
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
    '65c968a3-a870-4bb7-86db-d61fabe76774',
    'ee49577b-36b0-4594-8406-65f3fc6c4eef',
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
    '69a7b79a-af93-4eb1-ad98-76b6e5cd8e16',
    'ee49577b-36b0-4594-8406-65f3fc6c4eef',
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
    '9a972b1a-4c7d-43f5-8b48-2b533087a8e3',
    'ee49577b-36b0-4594-8406-65f3fc6c4eef',
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
    'e0840f53-a110-4d41-885e-62ee8b8a0c8d',
    'ee49577b-36b0-4594-8406-65f3fc6c4eef',
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
    '20dfec85-8ece-4d09-a0b8-291b9bd1993f',
    'ee49577b-36b0-4594-8406-65f3fc6c4eef',
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
    '2dffaae6-b043-4caf-a717-351f0dd0855f',
    'ee49577b-36b0-4594-8406-65f3fc6c4eef',
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
    '4539edaa-af77-4626-a9a5-67666991d30b',
    'ee49577b-36b0-4594-8406-65f3fc6c4eef',
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
    '02daee44-7478-49fb-a62c-97cfdb44b783',
    'ee49577b-36b0-4594-8406-65f3fc6c4eef',
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
    'd203aeb2-4571-4c47-85be-d9d6701efc18',
    'ee49577b-36b0-4594-8406-65f3fc6c4eef',
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
    '25ecddf9-7061-4782-bc53-98449200e709',
    'ee49577b-36b0-4594-8406-65f3fc6c4eef',
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
    'c478308a-beec-4666-8dca-7da384dfc706',
    'ee49577b-36b0-4594-8406-65f3fc6c4eef',
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
    '776a1052-a8c6-4a41-a25c-e33d3b0d9826',
    'ee49577b-36b0-4594-8406-65f3fc6c4eef',
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
    '63305f6a-4f47-4304-9412-3196f62499a8',
    'ee49577b-36b0-4594-8406-65f3fc6c4eef',
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
    '9fe7025a-0224-4c50-878e-dcfc997d0f4b',
    'ee49577b-36b0-4594-8406-65f3fc6c4eef',
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
    'dd208db6-5809-4bec-95fa-71208a1326df',
    'ee49577b-36b0-4594-8406-65f3fc6c4eef',
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
    'b468ddca-55e3-4919-8c06-16ce80022a95',
    'ee49577b-36b0-4594-8406-65f3fc6c4eef',
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
    'de52e299-3fc1-4f55-9674-caa3c56a164c',
    'ee49577b-36b0-4594-8406-65f3fc6c4eef',
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
    '14d5fa29-d4ff-4a6b-aab7-5e8f12d5c443',
    'ee49577b-36b0-4594-8406-65f3fc6c4eef',
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
    '63f2fc3e-c5cb-489c-bc98-48e0f564da60',
    'ee49577b-36b0-4594-8406-65f3fc6c4eef',
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
    '03279624-a9a9-444e-bd2a-2246dcf578fe',
    'ee49577b-36b0-4594-8406-65f3fc6c4eef',
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
    'fb73efec-fbaf-418f-a596-01ceca8111eb',
    'ee49577b-36b0-4594-8406-65f3fc6c4eef',
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
    'c3dfb294-3aa0-4c5b-85e4-61500b72a07f',
    'ee49577b-36b0-4594-8406-65f3fc6c4eef',
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
    '127e379a-1aa1-4263-ae23-4cfce1d5b52a',
    'ee49577b-36b0-4594-8406-65f3fc6c4eef',
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
    '2a5d9749-a43b-4f2b-88db-67487b416e36',
    'ee49577b-36b0-4594-8406-65f3fc6c4eef',
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
    '584d3f07-174f-46da-9b89-6ed2c3f9f3af',
    'ee49577b-36b0-4594-8406-65f3fc6c4eef',
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
    'a88e4313-d6ba-4b79-90f1-f1704b610e8e',
    'ee49577b-36b0-4594-8406-65f3fc6c4eef',
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
    'dba26833-1c03-4967-81da-87d6b58ab565',
    'ee49577b-36b0-4594-8406-65f3fc6c4eef',
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
    '4a4919c5-ce7c-4fd6-a0d4-cf596ffe4fa6',
    'ee49577b-36b0-4594-8406-65f3fc6c4eef',
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
    '81998a64-f8d8-4e7e-8a6a-f464a619dab6',
    'ee49577b-36b0-4594-8406-65f3fc6c4eef',
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
    '44d0e0f8-db3f-4749-acf0-80b07687eed3',
    'ee49577b-36b0-4594-8406-65f3fc6c4eef',
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
    'bfca5807-8fcc-4353-a042-97188c7c2521',
    'ee49577b-36b0-4594-8406-65f3fc6c4eef',
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
    '733f34c0-f8de-4f0e-b6a0-8ea02d87e7f6',
    'ee49577b-36b0-4594-8406-65f3fc6c4eef',
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
    'e9bd8996-1b68-44f8-99ab-5cbe19c1c1ab',
    'ee49577b-36b0-4594-8406-65f3fc6c4eef',
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
    'bca7b172-5c73-400c-89fc-fe07d235c940',
    'ee49577b-36b0-4594-8406-65f3fc6c4eef',
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
    'eaecf7fa-dd64-4fee-a667-48c72a0ec38b',
    'ee49577b-36b0-4594-8406-65f3fc6c4eef',
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
    '28275a55-64a2-43b3-bf7d-d3d3ab2e796d',
    'ee49577b-36b0-4594-8406-65f3fc6c4eef',
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
    '16b13246-cf32-4993-be03-c4abdcde873c',
    'ee49577b-36b0-4594-8406-65f3fc6c4eef',
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
    '08cf8516-cea2-4ef0-8927-d2f0f78c16de',
    'ee49577b-36b0-4594-8406-65f3fc6c4eef',
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
    'd16980cd-7f4c-4da8-833d-e7c6fdd65a95',
    'ee49577b-36b0-4594-8406-65f3fc6c4eef',
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
    '64ec6d39-8bbe-4329-9cf3-5e5710b34941',
    'ee49577b-36b0-4594-8406-65f3fc6c4eef',
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
    '99d1e4fa-c6c5-4680-be36-078f1d33b660',
    'ee49577b-36b0-4594-8406-65f3fc6c4eef',
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
    'bc629e79-31c8-40cb-a3b6-3b2d72d50fd2',
    'ee49577b-36b0-4594-8406-65f3fc6c4eef',
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
    'acbd24bb-3cb8-4114-9a81-91e6346dbb54',
    'ee49577b-36b0-4594-8406-65f3fc6c4eef',
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
    'bbde0e8d-c3e3-45e7-96a9-405cdd1a9550',
    'ee49577b-36b0-4594-8406-65f3fc6c4eef',
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
    '9d6b94b5-5aa4-4d9f-82b0-75da4391915d',
    'ee49577b-36b0-4594-8406-65f3fc6c4eef',
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
    '02da397d-7370-4c3e-924e-fba3494589f1',
    'ee49577b-36b0-4594-8406-65f3fc6c4eef',
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
    '90d6a2ce-22b9-4d1e-bc16-01206f9132a4',
    'ee49577b-36b0-4594-8406-65f3fc6c4eef',
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
    'd96410f6-461b-4388-8a87-6d717f0efe42',
    'ee49577b-36b0-4594-8406-65f3fc6c4eef',
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
    '3ed23bc4-b2ef-4e2c-b9ce-6a269ccfd9d2',
    'ee49577b-36b0-4594-8406-65f3fc6c4eef',
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
    '8864803b-b037-4400-8c4e-2d4b01d9862a',
    'ee49577b-36b0-4594-8406-65f3fc6c4eef',
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
    '280240e8-b3de-4eeb-a13f-cf1b45edd534',
    'ee49577b-36b0-4594-8406-65f3fc6c4eef',
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
    '97c39838-9c13-4f4b-a00c-fac640fe7575',
    'ee49577b-36b0-4594-8406-65f3fc6c4eef',
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
    '8913a6db-e328-4856-b000-8911d49425e8',
    'ee49577b-36b0-4594-8406-65f3fc6c4eef',
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
    'f53749ce-416f-49ec-af02-5c7d3f110250',
    'ee49577b-36b0-4594-8406-65f3fc6c4eef',
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
    '7e6fffe7-a502-4c8d-8cb5-7f8d370c6fd0',
    'ee49577b-36b0-4594-8406-65f3fc6c4eef',
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
    'e1774fa9-cdf1-4a26-8a5f-d0ec2ad72ece',
    'ee49577b-36b0-4594-8406-65f3fc6c4eef',
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
    '6b84d8ab-8d17-4695-b76c-ee485c2ff9fb',
    'ee49577b-36b0-4594-8406-65f3fc6c4eef',
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
    '47caf689-9195-470a-b647-64337da8f6b0',
    'ee49577b-36b0-4594-8406-65f3fc6c4eef',
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
    '9ada0b2a-edca-4cb5-8b7f-970ff6ed1bc3',
    'ee49577b-36b0-4594-8406-65f3fc6c4eef',
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
    '8001ecfd-b5c3-4d15-bc10-fbc7c3d23204',
    'ee49577b-36b0-4594-8406-65f3fc6c4eef',
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
    '9dd82c18-71d1-4ca9-b64f-226e7fdd3911',
    'ee49577b-36b0-4594-8406-65f3fc6c4eef',
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
    '1c4ba770-7d74-45d7-8f22-ea4691d7ab61',
    'ee49577b-36b0-4594-8406-65f3fc6c4eef',
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
    '5129c238-a77d-4a40-865e-fd0c031908f5',
    'ee49577b-36b0-4594-8406-65f3fc6c4eef',
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
    '364d5137-bb7b-4fa8-8286-e231a34ba1e0',
    'ee49577b-36b0-4594-8406-65f3fc6c4eef',
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
    '219ab85a-a897-41bd-8454-2ab839f876ac',
    'ee49577b-36b0-4594-8406-65f3fc6c4eef',
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
    'a0f46421-bf87-42f1-80a7-29dc6417ae42',
    'ee49577b-36b0-4594-8406-65f3fc6c4eef',
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
    '33db862f-73a9-4020-918c-e1c30f6930dd',
    'ee49577b-36b0-4594-8406-65f3fc6c4eef',
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
    'fbe6025e-405f-496e-9771-9966221862c0',
    'ee49577b-36b0-4594-8406-65f3fc6c4eef',
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
    '5829511f-2ef6-464b-a868-36cb1bdd1e15',
    'ee49577b-36b0-4594-8406-65f3fc6c4eef',
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
    '23ab9468-b326-4551-b9af-7e5507c32e46',
    'ee49577b-36b0-4594-8406-65f3fc6c4eef',
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
    '9e60ab43-cd2f-4e6d-815e-baf0cea9e992',
    'ee49577b-36b0-4594-8406-65f3fc6c4eef',
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
    'ea207f6d-fc17-4b98-a9e2-fb25bc44b219',
    'ee49577b-36b0-4594-8406-65f3fc6c4eef',
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
    'e5f11031-149e-4767-9c78-cbd11a4062df',
    'ee49577b-36b0-4594-8406-65f3fc6c4eef',
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
    'ad74b3b2-efb9-40e1-b45b-bd417df7b7f0',
    'ee49577b-36b0-4594-8406-65f3fc6c4eef',
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
    '35cdeebb-8d1e-4ced-850b-ae7511ebdb72',
    'ee49577b-36b0-4594-8406-65f3fc6c4eef',
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
    '371070f4-3479-4589-826e-e058c887e46d',
    'ee49577b-36b0-4594-8406-65f3fc6c4eef',
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
    '104da7b6-6277-43d4-95f5-d83edf7fa16f',
    'ee49577b-36b0-4594-8406-65f3fc6c4eef',
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
    '613ed345-39f4-4a3d-9b1e-39a4704baae7',
    'ee49577b-36b0-4594-8406-65f3fc6c4eef',
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
    'a86178d4-73ac-41d8-a5a3-efb43676ec72',
    'ee49577b-36b0-4594-8406-65f3fc6c4eef',
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
    '48c656be-d72b-4221-96de-78fcaf937630',
    'ee49577b-36b0-4594-8406-65f3fc6c4eef',
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
    '24f8f72a-cc73-40e9-aa0e-28f2f3900f95',
    'ee49577b-36b0-4594-8406-65f3fc6c4eef',
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
    '90ce794a-09e6-46e2-a270-8977055e7957',
    'ee49577b-36b0-4594-8406-65f3fc6c4eef',
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
    '219743fc-fd1f-4e94-a456-58da0556b7d7',
    'ee49577b-36b0-4594-8406-65f3fc6c4eef',
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
    '81f34cb5-f679-4b0c-988d-b508d56cfddc',
    'ee49577b-36b0-4594-8406-65f3fc6c4eef',
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
    'a29ac1d7-c0bd-475d-8233-a775ef296648',
    'ee49577b-36b0-4594-8406-65f3fc6c4eef',
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
    '5e6eacc2-b5f2-48fc-9315-9e5cf10022ab',
    'ee49577b-36b0-4594-8406-65f3fc6c4eef',
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
    'cc9ad70c-ff0e-42c7-abf7-50a75e3dbeaa',
    'ee49577b-36b0-4594-8406-65f3fc6c4eef',
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
    '72f41427-dc7d-4efc-8909-780a81881c47',
    'ee49577b-36b0-4594-8406-65f3fc6c4eef',
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
    '54fd889a-c3b5-4602-9f7e-e5475a543d7f',
    'ee49577b-36b0-4594-8406-65f3fc6c4eef',
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
    'd1a015b9-4d0b-41c8-844d-fb019848fe56',
    'ee49577b-36b0-4594-8406-65f3fc6c4eef',
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
    'cce93dbe-4216-4b90-acdb-a9b37867c1e9',
    'ee49577b-36b0-4594-8406-65f3fc6c4eef',
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
    'f75be478-03f4-4ebf-8a18-bcf03e5de890',
    'ee49577b-36b0-4594-8406-65f3fc6c4eef',
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
    'fa11ba9b-9163-4e49-8065-9a68873be0d2',
    'ee49577b-36b0-4594-8406-65f3fc6c4eef',
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
    'b0e49b5c-6449-4ef3-9366-720cc39d4ef6',
    'ee49577b-36b0-4594-8406-65f3fc6c4eef',
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
    'd2246ca1-583d-4415-a01e-1564b40fdb1d',
    'ee49577b-36b0-4594-8406-65f3fc6c4eef',
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
    '469d1d2d-c00e-4e16-a75c-870e0cd5ba46',
    'ee49577b-36b0-4594-8406-65f3fc6c4eef',
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
    '822a4b1d-7cf4-4e1f-9658-8c616f669fc2',
    'ee49577b-36b0-4594-8406-65f3fc6c4eef',
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
    '9d924d17-b507-42fb-b274-aed6896ec316',
    'ee49577b-36b0-4594-8406-65f3fc6c4eef',
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
    '9ceaf5ab-af22-4bbd-b161-f916f7c2a6bc',
    'ee49577b-36b0-4594-8406-65f3fc6c4eef',
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
    '29489be0-c8f4-4f35-927c-9850ce5e43a8',
    'ee49577b-36b0-4594-8406-65f3fc6c4eef',
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
    'e2f2ab8a-21d9-472b-8b62-4e4819ec9954',
    'ee49577b-36b0-4594-8406-65f3fc6c4eef',
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
    'ebf02b02-211f-4fa5-9535-713022ed2bae',
    'ee49577b-36b0-4594-8406-65f3fc6c4eef',
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
    '36232ed8-d451-460e-a271-3256f15e6f5e',
    'ee49577b-36b0-4594-8406-65f3fc6c4eef',
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
    'f0ec2d8c-e53f-4fdf-afff-aa54498800e8',
    'ee49577b-36b0-4594-8406-65f3fc6c4eef',
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
    '4a08b238-c8eb-4274-a90a-2cabf33af35d',
    'ee49577b-36b0-4594-8406-65f3fc6c4eef',
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
    '50638e32-0978-432a-a77d-d73f793541b0',
    'ee49577b-36b0-4594-8406-65f3fc6c4eef',
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
    'fa15533e-33ce-4c3d-970b-8a70a00ddd93',
    'ee49577b-36b0-4594-8406-65f3fc6c4eef',
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
    '4b1bebc9-0474-49e1-9a32-5b1a8079072f',
    'ee49577b-36b0-4594-8406-65f3fc6c4eef',
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
    'b2b51ec7-41b5-4b87-8e31-e8f2f9dced83',
    'ee49577b-36b0-4594-8406-65f3fc6c4eef',
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
    'aeb9f183-3d9f-4e40-9ce3-5ba2ddd265c4',
    'ee49577b-36b0-4594-8406-65f3fc6c4eef',
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
    '4df5d82c-161a-4170-8703-c743853ba70c',
    'ee49577b-36b0-4594-8406-65f3fc6c4eef',
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
    '1f157de4-5fc7-4f01-a12a-49c735106db7',
    'ee49577b-36b0-4594-8406-65f3fc6c4eef',
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
    '415d9b9d-41de-41e6-8f79-66c986dd2268',
    'ee49577b-36b0-4594-8406-65f3fc6c4eef',
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
    'a9121976-7155-4404-a436-c4ecb05df95d',
    'ee49577b-36b0-4594-8406-65f3fc6c4eef',
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
    '7957fbb7-f3ae-4993-98b6-f08e1d6b5366',
    'ee49577b-36b0-4594-8406-65f3fc6c4eef',
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
    'b28328e9-9dd2-4479-9847-b473d30f38c9',
    'ee49577b-36b0-4594-8406-65f3fc6c4eef',
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
    '03e1d862-7aa1-4939-86cd-8efecef3fd7d',
    'ee49577b-36b0-4594-8406-65f3fc6c4eef',
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
    '460cbf70-5c36-4e99-ad73-a6686dd8f86c',
    'ee49577b-36b0-4594-8406-65f3fc6c4eef',
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
    '6fe5a0a2-f49d-461e-ab4d-675766743358',
    'ee49577b-36b0-4594-8406-65f3fc6c4eef',
    'boiler_location',
    'utilities',
    'Boiler',
    NULL,
    'Gaskets Very Very',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;
