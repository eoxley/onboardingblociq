-- BlocIQ Onboarder - Auto-generated Migration
-- Generated at: 2025-10-08T09:28:01.647002
-- Review this script before executing!

-- =====================================
-- REQUIRED: Replace AGENCY_ID_PLACEHOLDER with your agency UUID
-- =====================================

-- =====================================
-- SCHEMA MIGRATIONS: Add missing columns if they don't exist
-- =====================================

-- Add building_id to leaseholders (if not exists)
ALTER TABLE leaseholders ADD COLUMN IF NOT EXISTS building_id uuid;

-- Add unit_number to leaseholders (if not exists)
ALTER TABLE leaseholders ADD COLUMN IF NOT EXISTS unit_number VARCHAR(50);

-- Add year_start and year_end to budgets (if not exists)
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

-- Budgets
CREATE TABLE IF NOT EXISTS budgets (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  building_id uuid REFERENCES buildings(id),
  year_start date,
  year_end date,
  total_amount numeric(15,2),
  status text CHECK (status IN ('draft','final','approved')),
  source_document text,
  notes text,
  created_at timestamptz DEFAULT now()
);

CREATE INDEX IF NOT EXISTS idx_budgets_building ON budgets(building_id);
CREATE INDEX IF NOT EXISTS idx_budgets_year ON budgets(year_start);

-- Building Insurance
CREATE TABLE IF NOT EXISTS building_insurance (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  building_id uuid REFERENCES buildings(id),
  provider text,
  policy_number text,
  expiry_date date,
  premium_amount numeric(15,2),
  source_document text,
  notes text,
  created_at timestamptz DEFAULT now()
);

CREATE INDEX IF NOT EXISTS idx_building_insurance_building ON building_insurance(building_id);
CREATE INDEX IF NOT EXISTS idx_building_insurance_expiry ON building_insurance(expiry_date);

-- Building Staff
CREATE TABLE IF NOT EXISTS building_staff (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  building_id uuid REFERENCES buildings(id),
  name text NOT NULL,
  role text,
  contact_info text,
  hours text,
  company_name text,
  contractor_id uuid REFERENCES building_contractors(id),
  source_document text,
  notes text,
  created_at timestamptz DEFAULT now()
);

CREATE INDEX IF NOT EXISTS idx_building_staff_building ON building_staff(building_id);
CREATE INDEX IF NOT EXISTS idx_building_staff_role ON building_staff(role);

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
-- DATA MIGRATION: Insert building data
-- =====================================

-- Example: INSERT INTO agencies (id, name) VALUES ('AGENCY_ID_PLACEHOLDER', 'My Agency')
-- ON CONFLICT (id) DO NOTHING;

INSERT INTO portfolios (id, agency_id, name)
VALUES ('b29b1193-cd46-49cd-ba4f-154426f3a2d6', 'AGENCY_ID_PLACEHOLDER', 'Default Portfolio')
ON CONFLICT (id) DO NOTHING;

BEGIN;

-- Insert building
INSERT INTO buildings (id, name, address, portfolio_id) VALUES ('40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'Connaught Square', 'CONNAUGHT SQUARE', 'b29b1193-cd46-49cd-ba4f-154426f3a2d6');

-- Insert 1 schedule(s)
INSERT INTO schedules (id, building_id, name, description) VALUES ('3eb1227e-ae2e-40bc-a370-f340160710e7', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'Main Schedule', 'Auto-detected schedule from onboarding');
-- Created schedules: Main Schedule

-- Insert 8 units
INSERT INTO units (id, building_id, unit_number) VALUES ('13e33089-159c-461e-8762-2b92f28ce547', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'Flat 1');
INSERT INTO units (id, building_id, unit_number) VALUES ('feaca086-682c-49af-ac7b-3069e34c7e24', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'Flat 2');
INSERT INTO units (id, building_id, unit_number) VALUES ('588e2e89-7aad-433c-8171-c3205294f0de', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'Flat 3');
INSERT INTO units (id, building_id, unit_number) VALUES ('be9d2886-65f6-4487-97eb-36944aae2876', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'Flat 4');
INSERT INTO units (id, building_id, unit_number) VALUES ('b868cbb5-dad2-48ad-88c7-599293313bcb', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'Flat 5');
INSERT INTO units (id, building_id, unit_number) VALUES ('b3c8d092-0d38-4675-824c-ac9d1ecfeca6', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'Flat 6');
INSERT INTO units (id, building_id, unit_number) VALUES ('0e7a4791-11c1-4271-b488-40aa037ad885', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'Flat 7');
INSERT INTO units (id, building_id, unit_number) VALUES ('87aecef5-ce1d-4667-abb2-02a54c0ab467', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'Flat 8');

-- Insert 8 leaseholders
INSERT INTO leaseholders (id, building_id, unit_id, name) VALUES ('d10a70f2-f4e8-4363-abc9-8dc9cf68281e', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', '13e33089-159c-461e-8762-2b92f28ce547', 'Marmotte Holdings Limited');
INSERT INTO leaseholders (id, building_id, unit_id, name) VALUES ('63494781-324a-4bdd-83c1-542ec3740cab', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'feaca086-682c-49af-ac7b-3069e34c7e24', 'Ms V Rebulla');
INSERT INTO leaseholders (id, building_id, unit_id, name) VALUES ('1f8fe882-9231-44f9-848b-d22dcc54b292', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', '588e2e89-7aad-433c-8171-c3205294f0de', 'Ms V Rebulla');
INSERT INTO leaseholders (id, building_id, unit_id, name) VALUES ('a0c0a3c2-c45b-4f51-8af3-3bb8e8c2b85d', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'be9d2886-65f6-4487-97eb-36944aae2876', 'Mr P J J Reynish & Ms C A O''Loughlin');
INSERT INTO leaseholders (id, building_id, unit_id, name) VALUES ('b340bd6d-6324-4c74-b629-c1a4e2f9910d', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'b868cbb5-dad2-48ad-88c7-599293313bcb', 'Mr & Mrs M D Samworth');
INSERT INTO leaseholders (id, building_id, unit_id, name) VALUES ('1eba360d-1349-4cd1-ac21-ebf98a5b4bd3', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'b3c8d092-0d38-4675-824c-ac9d1ecfeca6', 'Mr M D & Mrs C P Samworth');
INSERT INTO leaseholders (id, building_id, unit_id, name) VALUES ('a1064b59-e678-4097-b334-0039b2c45288', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', '0e7a4791-11c1-4271-b488-40aa037ad885', 'Ms J Gomm');
INSERT INTO leaseholders (id, building_id, unit_id, name) VALUES ('d414b493-e572-4fde-840e-ee8298e8fa69', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', '87aecef5-ce1d-4667-abb2-02a54c0ab467', 'Miss T V Samwoth & Miss G E Samworth');

-- Insert 56 compliance assets
INSERT INTO compliance_assets (id, building_id, description, asset_name, asset_type, inspection_frequency, last_inspection_date, next_due_date, compliance_status, is_active) VALUES ('b2c12569-9c86-485e-a01e-15a51d18d3aa', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'Extracted from 2024 Directors Meeting-Notes.docx', 'Compliance Asset', 'general', '12 months', '2024-01-01', '2025-01-01', 'overdue', TRUE);
INSERT INTO compliance_assets (id, building_id, description, asset_name, asset_type, inspection_frequency, compliance_status, location, is_active) VALUES ('ca76d921-926d-400c-9495-43149ceb0edd', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'Extracted from Fire Door (Communal) Inspection (11m +) (7).pdf', 'Fire Door Inspection', 'fire_safety', '12 months', 'unknown', 'Communal', TRUE);
INSERT INTO compliance_assets (id, building_id, description, asset_name, asset_type, inspection_frequency, compliance_status, is_active) VALUES ('11773620-8c18-4091-9285-fd87d58608a6', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'Extracted from Fire Door (Flats) Inspection (11m +) (13).pdf', 'Fire Door Inspection', 'fire_safety', '12 months', 'unknown', TRUE);
INSERT INTO compliance_assets (id, building_id, description, asset_name, asset_type, inspection_frequency, compliance_status, is_active) VALUES ('404df702-1212-403e-8ee0-e598c4cbaced', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'Extracted from Fire Door (Flats) Inspection (11m +) (18).pdf', 'Fire Door Inspection', 'fire_safety', '12 months', 'unknown', TRUE);
INSERT INTO compliance_assets (id, building_id, description, asset_name, asset_type, inspection_frequency, compliance_status, is_active) VALUES ('b0a20d2f-9490-49c3-8dd1-df3f168ad65f', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'Extracted from Fire Door (Flats) Inspection (11m +) (14).pdf', 'Fire Door Inspection', 'fire_safety', '12 months', 'unknown', TRUE);
INSERT INTO compliance_assets (id, building_id, description, asset_name, asset_type, inspection_frequency, compliance_status, is_active) VALUES ('c009aef8-e891-4eea-9c1d-4d9fc79ec6a1', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'Extracted from EICR Cuanku 32-34 conaught square.pdf', 'Electrical Installation Condition Report (EICR)', 'electrical', '60 months', 'unknown', TRUE);
INSERT INTO compliance_assets (id, building_id, description, asset_name, asset_type, inspection_frequency, compliance_status, is_active) VALUES ('53652672-8b71-45f1-a98d-7d881cc2e011', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'Extracted from Fire Door (Flats) Inspection (11m +) (15).pdf', 'Fire Door Inspection', 'fire_safety', '12 months', 'unknown', TRUE);
INSERT INTO compliance_assets (id, building_id, description, asset_name, asset_type, inspection_frequency, last_inspection_date, next_due_date, compliance_status, is_active) VALUES ('eb0a8d07-4418-4891-86b2-280bdbe629c7', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'Extracted from 221037_Fra1-L-394697-071223 32-34 Connaught Square_2024-01-02_163759 (1).pdf', 'Fire Risk Assessment (FRA)', 'fire_safety', '12 months', '2024-01-02', '2025-01-02', 'overdue', TRUE);
INSERT INTO compliance_assets (id, building_id, description, asset_name, asset_type, inspection_frequency, compliance_status, is_active) VALUES ('027edbc2-b264-4c1b-9d1b-c9b9ed5b72b6', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'Extracted from Fire Door (Flats) Inspection (11m +) (19).pdf', 'Fire Door Inspection', 'fire_safety', '12 months', 'unknown', TRUE);
INSERT INTO compliance_assets (id, building_id, description, asset_name, asset_type, inspection_frequency, compliance_status, is_active) VALUES ('c41de099-f132-43d9-835e-2a20ed128c86', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'Extracted from 001132-3234-Connaught-Square-London.pdf', 'Compliance Asset', 'general', '12 months', 'unknown', TRUE);
INSERT INTO compliance_assets (id, building_id, description, asset_name, asset_type, inspection_frequency, last_inspection_date, next_due_date, compliance_status, is_active) VALUES ('5c5578b1-3beb-46c4-a428-f3c13d626758', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'Extracted from 221038_Hsra1-L-394697-071223 32-34 Connaught Square_2024-01-02_163759 (1).pdf', 'Compliance Asset', 'general', '12 months', '2024-01-02', '2025-01-02', 'overdue', TRUE);
INSERT INTO compliance_assets (id, building_id, description, asset_name, asset_type, inspection_frequency, compliance_status, is_active) VALUES ('a38f107e-e979-478b-9433-8143ac1772d9', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'Extracted from TETRA - Asbestos Re-Inspection Survey 14.06.22.pdf', 'Compliance Asset', 'general', '12 months', 'unknown', TRUE);
INSERT INTO compliance_assets (id, building_id, description, asset_name, asset_type, inspection_frequency, compliance_status, is_active) VALUES ('3830ad0a-01d3-4467-9ca5-b65c7825a2dc', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'Extracted from Fire Door (Flats) Inspection (11m +) (16).pdf', 'Fire Door Inspection', 'fire_safety', '12 months', 'unknown', TRUE);
INSERT INTO compliance_assets (id, building_id, description, asset_name, asset_type, inspection_frequency, compliance_status, is_active) VALUES ('caf06cb3-d8e8-4bd9-8598-6ae8b14ea27f', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'Extracted from Fire Door (Flats) Inspection (11m +) (17).pdf', 'Fire Door Inspection', 'fire_safety', '12 months', 'unknown', TRUE);
INSERT INTO compliance_assets (id, building_id, description, asset_name, asset_type, inspection_frequency, compliance_status, is_active) VALUES ('245d1df3-018c-4b5a-90f7-ef70d1937812', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'Extracted from WHM Legionella Risk Assessment 07.06.22.pdf', 'Legionella Risk Assessment', 'water_safety', '24 months', 'unknown', TRUE);
INSERT INTO compliance_assets (id, building_id, description, asset_name, asset_type, inspection_frequency, last_inspection_date, next_due_date, compliance_status, is_active) VALUES ('a9250478-5aa8-4fbc-8619-3391267216f0', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'Extracted from EICR Report Cunaku SATISFACTORY 2023 .pdf', 'Electrical Installation Condition Report (EICR)', 'electrical', '60 months', '2023-01-01', '2028-01-01', 'compliant', TRUE);
INSERT INTO compliance_assets (id, building_id, description, asset_name, asset_type, inspection_frequency, last_inspection_date, next_due_date, compliance_status, is_active) VALUES ('a29db49e-34da-4483-b56f-e7a0c4148f4e', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'Extracted from 2024 Directors Meeting-Notes.docx', 'Compliance Asset', 'general', '12 months', '2024-01-01', '2025-01-01', 'overdue', TRUE);
INSERT INTO compliance_assets (id, building_id, description, asset_name, asset_type, inspection_frequency, compliance_status, is_active) VALUES ('31b7ecfb-a22b-4b70-8667-79fc4857d92b', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'Extracted from 001457-3234-Connaught-Square-London Certificate.pdf', 'Compliance Asset', 'general', '12 months', 'unknown', TRUE);
INSERT INTO compliance_assets (id, building_id, description, asset_name, asset_type, inspection_frequency, compliance_status, is_active) VALUES ('504ff3ac-20e9-4301-b332-bc01a03a94ff', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'Extracted from TC0001V31 General Terms and Conditions.pdf', 'Compliance Asset', 'general', '12 months', 'unknown', TRUE);
INSERT INTO compliance_assets (id, building_id, description, asset_name, asset_type, inspection_frequency, last_inspection_date, next_due_date, compliance_status, is_active) VALUES ('4d8cf27e-a941-4ca4-8693-b3d131b8a11a', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'Extracted from Jobcard_For_Job_No_28992_24-01-2025_1545.pdf', 'Compliance Asset', 'general', '12 months', '2025-01-24', '2026-01-24', 'compliant', TRUE);
INSERT INTO compliance_assets (id, building_id, description, asset_name, asset_type, inspection_frequency, compliance_status, is_active) VALUES ('db5703da-c264-43ae-a74c-108747317b78', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'Extracted from Connaught Square (32-34) - 09.12.24 LRA.pdf', 'Compliance Asset', 'general', '12 months', 'unknown', TRUE);
INSERT INTO compliance_assets (id, building_id, description, asset_name, asset_type, inspection_frequency, compliance_status, is_active) VALUES ('dc4b2a83-8aad-47d0-9aaa-16e8e36553c7', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'Extracted from SC Certificate - 10072023.pdf', 'Compliance Asset', 'general', '12 months', 'unknown', TRUE);
INSERT INTO compliance_assets (id, building_id, description, asset_name, asset_type, inspection_frequency, compliance_status, location, is_active) VALUES ('93936f73-e8fb-4bd5-bce6-cf5d89c729a6', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'Extracted from Fire Door (Communal) Inspection (11m +) (7).pdf', 'Fire Door Inspection', 'fire_safety', '12 months', 'unknown', 'Communal', TRUE);
INSERT INTO compliance_assets (id, building_id, description, asset_name, asset_type, inspection_frequency, compliance_status, is_active) VALUES ('6b5c3d29-4281-4628-ac6b-ad17b58f7af0', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'Extracted from Fire Door (Flats) Inspection (11m +) (13).pdf', 'Fire Door Inspection', 'fire_safety', '12 months', 'unknown', TRUE);
INSERT INTO compliance_assets (id, building_id, description, asset_name, asset_type, inspection_frequency, compliance_status, is_active) VALUES ('c246ff91-cab1-4d6c-9cb6-32a755d08b2d', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'Extracted from Fire Door (Flats) Inspection (11m +) (18).pdf', 'Fire Door Inspection', 'fire_safety', '12 months', 'unknown', TRUE);
INSERT INTO compliance_assets (id, building_id, description, asset_name, asset_type, inspection_frequency, compliance_status, is_active) VALUES ('0240ef66-8246-42ad-9dd9-a66cf6445093', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'Extracted from Fire Door (Flats) Inspection (11m +) (14).pdf', 'Fire Door Inspection', 'fire_safety', '12 months', 'unknown', TRUE);
INSERT INTO compliance_assets (id, building_id, description, asset_name, asset_type, inspection_frequency, compliance_status, is_active) VALUES ('570a3518-0e71-46ce-8be4-e390aaf92ab5', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'Extracted from Fire Door (Flats) Inspection (11m +) (15).pdf', 'Fire Door Inspection', 'fire_safety', '12 months', 'unknown', TRUE);
INSERT INTO compliance_assets (id, building_id, description, asset_name, asset_type, inspection_frequency, compliance_status, is_active) VALUES ('bcca537d-981a-4621-8e9f-7e52c2203eb8', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'Extracted from Fire Door (Flats) Inspection (11m +) (19).pdf', 'Fire Door Inspection', 'fire_safety', '12 months', 'unknown', TRUE);
INSERT INTO compliance_assets (id, building_id, description, asset_name, asset_type, inspection_frequency, compliance_status, is_active) VALUES ('0ffc32f9-cb7b-44f7-a98b-43f3cb0956ef', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'Extracted from Fire Door (Flats) Inspection (11m +) (16).pdf', 'Fire Door Inspection', 'fire_safety', '12 months', 'unknown', TRUE);
INSERT INTO compliance_assets (id, building_id, description, asset_name, asset_type, inspection_frequency, compliance_status, is_active) VALUES ('bdc46c82-d0eb-4e0d-9f00-1b30abb56bed', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'Extracted from Fire Door (Flats) Inspection (11m +) (17).pdf', 'Fire Door Inspection', 'fire_safety', '12 months', 'unknown', TRUE);
INSERT INTO compliance_assets (id, building_id, description, asset_name, asset_type, inspection_frequency, last_inspection_date, next_due_date, compliance_status, is_active) VALUES ('ef8938b8-ec16-4f32-b2a3-8bdec73a6e7d', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'Extracted from 221037_Fra1-L-394697-071223 32-34 Connaught Square_2024-01-02_163759.pdf', 'Fire Risk Assessment (FRA)', 'fire_safety', '12 months', '2024-01-02', '2025-01-02', 'overdue', TRUE);
INSERT INTO compliance_assets (id, building_id, description, asset_name, asset_type, inspection_frequency, last_inspection_date, next_due_date, compliance_status, is_active) VALUES ('3a533d1d-c6e0-41de-93e0-521a8d52b89e', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'Extracted from Fire Door (Flats) Inspection (11m +) - 2024-01-24T120747.552.pdf', 'Fire Door Inspection', 'fire_safety', '12 months', '2024-01-24', '2025-01-24', 'overdue', TRUE);
INSERT INTO compliance_assets (id, building_id, description, asset_name, asset_type, inspection_frequency, compliance_status, is_active) VALUES ('7547664b-6404-4ec7-b2dc-90b6de0ec0fd', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'Extracted from Connaught Square (32-34) - 15.11.23 (886) wa.pdf', 'Compliance Asset', 'general', '12 months', 'unknown', TRUE);
INSERT INTO compliance_assets (id, building_id, description, asset_name, asset_type, inspection_frequency, last_inspection_date, next_due_date, compliance_status, is_active) VALUES ('5ac99679-153e-42cd-b976-aebe5b6e9c1d', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'Extracted from Fire Door (Flats) Inspection (11m +) - 2024-01-24T120745.875.pdf', 'Fire Door Inspection', 'fire_safety', '12 months', '2024-01-24', '2025-01-24', 'overdue', TRUE);
INSERT INTO compliance_assets (id, building_id, description, asset_name, asset_type, inspection_frequency, last_inspection_date, next_due_date, compliance_status, is_active) VALUES ('095e68aa-233b-42c4-9b92-4dabc99cb0aa', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'Extracted from Fire Door (Flats) Inspection (11m +) - 2024-01-24T120746.424.pdf', 'Fire Door Inspection', 'fire_safety', '12 months', '2024-01-24', '2025-01-24', 'overdue', TRUE);
INSERT INTO compliance_assets (id, building_id, description, asset_name, asset_type, inspection_frequency, last_inspection_date, next_due_date, compliance_status, location, is_active) VALUES ('fe868683-772e-4bbb-9713-c3e69bd0d52a', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'Extracted from Fire Door (Communal) Inspection (11m +) - 2024-01-24T120743.986.pdf', 'Fire Door Inspection', 'fire_safety', '12 months', '2024-01-24', '2025-01-24', 'overdue', 'Communal', TRUE);
INSERT INTO compliance_assets (id, building_id, description, asset_name, asset_type, inspection_frequency, last_inspection_date, next_due_date, compliance_status, is_active) VALUES ('6c6bbad3-b8c4-4490-983f-1b3d23b7bc44', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'Extracted from Fire Door (Flats) Inspection (11m +) - 2024-01-24T120744.738.pdf', 'Fire Door Inspection', 'fire_safety', '12 months', '2024-01-24', '2025-01-24', 'overdue', TRUE);
INSERT INTO compliance_assets (id, building_id, description, asset_name, asset_type, inspection_frequency, last_inspection_date, next_due_date, compliance_status, is_active) VALUES ('7bc27476-9cdb-4f5a-9aba-973bed6ad0dd', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'Extracted from Fire Door (Flats) Inspection (11m +) - 2024-01-24T120747.015.pdf', 'Fire Door Inspection', 'fire_safety', '12 months', '2024-01-24', '2025-01-24', 'overdue', TRUE);
INSERT INTO compliance_assets (id, building_id, description, asset_name, asset_type, inspection_frequency, last_inspection_date, next_due_date, compliance_status, is_active) VALUES ('5194adc0-dee1-40f6-85a1-ba262b5ecb3c', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'Extracted from 221038_Hsra1-L-394697-071223 32-34 Connaught Square_2024-01-02_163759.pdf', 'Compliance Asset', 'general', '12 months', '2024-01-02', '2025-01-02', 'overdue', TRUE);
INSERT INTO compliance_assets (id, building_id, description, asset_name, asset_type, inspection_frequency, last_inspection_date, next_due_date, compliance_status, is_active) VALUES ('3481bfbb-b905-4b1f-b562-4a2c0dac417f', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'Extracted from Fire Door (Flats) Inspection (11m +) - 2024-01-24T120745.174.pdf', 'Fire Door Inspection', 'fire_safety', '12 months', '2024-01-24', '2025-01-24', 'overdue', TRUE);
INSERT INTO compliance_assets (id, building_id, description, asset_name, asset_type, inspection_frequency, compliance_status, is_active) VALUES ('21881f27-f48d-4811-9812-7653c50861ba', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'Extracted from Hsfra1-L-422971-210225 32-34 Connaught Square.pdf', 'Fire Risk Assessment (FRA)', 'fire_safety', '12 months', 'unknown', TRUE);
INSERT INTO compliance_assets (id, building_id, description, asset_name, asset_type, inspection_frequency, compliance_status, is_active) VALUES ('70846469-7734-4beb-8ab0-81295b6ffc4b', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'Extracted from Hsfra1-L-422971-210225 32-34 Connaught Square.docx', 'Fire Risk Assessment (FRA)', 'fire_safety', '12 months', 'unknown', TRUE);
INSERT INTO compliance_assets (id, building_id, description, asset_name, asset_type, inspection_frequency, last_inspection_date, next_due_date, compliance_status, is_active) VALUES ('f526cbdf-f288-4bf5-89dd-e8ce1fb2c943', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'Extracted from 221037_Fra1-L-394697-071223 32-34 Connaught Square_2024-01-02_163759 (1).pdf', 'Fire Risk Assessment (FRA)', 'fire_safety', '12 months', '2024-01-02', '2025-01-02', 'overdue', TRUE);
INSERT INTO compliance_assets (id, building_id, description, asset_name, asset_type, inspection_frequency, last_inspection_date, next_due_date, compliance_status, is_active) VALUES ('5c276c33-c477-4191-9b31-990ae8f018b6', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'Extracted from 221038_Hsra1-L-394697-071223 32-34 Connaught Square_2024-01-02_163759 (1).pdf', 'Compliance Asset', 'general', '12 months', '2024-01-02', '2025-01-02', 'overdue', TRUE);
INSERT INTO compliance_assets (id, building_id, description, asset_name, asset_type, inspection_frequency, compliance_status, is_active) VALUES ('57c590dd-27dc-4f5d-bd80-f1658448fee0', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'Extracted from FRA-Connaught Square Reccommendations.xlsx', 'Fire Risk Assessment (FRA)', 'fire_safety', '12 months', 'unknown', TRUE);
INSERT INTO compliance_assets (id, building_id, description, asset_name, asset_type, inspection_frequency, compliance_status, is_active) VALUES ('b8d8529a-d4c2-4536-b6ba-1ddc40a6acbd', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'Extracted from 001534-3234-Connaught-Square-London.pdf', 'Compliance Asset', 'general', '12 months', 'unknown', TRUE);
INSERT INTO compliance_assets (id, building_id, description, asset_name, asset_type, inspection_frequency, compliance_status, is_active) VALUES ('e2f68b0e-a402-4ab1-b155-93f9b49c9da9', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'Extracted from C1047 - Job card.pdf', 'Compliance Asset', 'general', '12 months', 'unknown', TRUE);
INSERT INTO compliance_assets (id, building_id, description, asset_name, asset_type, inspection_frequency, compliance_status, is_active) VALUES ('623696ff-b2d1-4a40-bfe7-c0ccc483b13a', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'Extracted from WHM Legionella Risk Assessment 09.12.25.pdf', 'Legionella Risk Assessment', 'water_safety', '24 months', 'unknown', TRUE);
INSERT INTO compliance_assets (id, building_id, description, asset_name, asset_type, inspection_frequency, compliance_status, is_active) VALUES ('595185b0-6f62-4da6-948d-d0ec19abf826', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'Extracted from WHM Legionella Risk Assessment 07.06.22.pdf', 'Legionella Risk Assessment', 'water_safety', '24 months', 'unknown', TRUE);
INSERT INTO compliance_assets (id, building_id, description, asset_name, asset_type, inspection_frequency, compliance_status, is_active) VALUES ('eed515a2-4a99-479a-b196-7b47a92b0840', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'Extracted from Connaught Square (32-34) - 29.05.25 (201) wa.pdf', 'Compliance Asset', 'general', '12 months', 'unknown', TRUE);
INSERT INTO compliance_assets (id, building_id, description, asset_name, asset_type, inspection_frequency, compliance_status, is_active) VALUES ('db0b8070-37ae-4f1f-9064-344f2ee43493', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'Extracted from EICR Cuanku 32-34 conaught square.pdf', 'Electrical Installation Condition Report (EICR)', 'electrical', '60 months', 'unknown', TRUE);
INSERT INTO compliance_assets (id, building_id, description, asset_name, asset_type, inspection_frequency, last_inspection_date, next_due_date, compliance_status, is_active) VALUES ('95b895fc-07ea-48cf-a9cd-612c60c71f98', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'Extracted from EICR Report Cunaku SATISFACTORY 2023 .pdf', 'Electrical Installation Condition Report (EICR)', 'electrical', '60 months', '2023-01-01', '2028-01-01', 'compliant', TRUE);
INSERT INTO compliance_assets (id, building_id, description, asset_name, asset_type, inspection_frequency, compliance_status, is_active) VALUES ('69087942-465f-4a60-92b5-a012b8411a4d', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'Extracted from 001132-3234-Connaught-Square-London.pdf', 'Compliance Asset', 'general', '12 months', 'unknown', TRUE);
INSERT INTO compliance_assets (id, building_id, description, asset_name, asset_type, inspection_frequency, compliance_status, is_active) VALUES ('f22a6ccf-cc02-492c-abd5-a87375cbfe87', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'Extracted from 001534-3234-Connaught-Square-London.pdf', 'Compliance Asset', 'general', '12 months', 'unknown', TRUE);
INSERT INTO compliance_assets (id, building_id, description, asset_name, asset_type, inspection_frequency, compliance_status, is_active) VALUES ('ac223efa-1c76-47f0-83e3-a855bd56b991', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'Extracted from FINAL L-432900 32-34 Connaught Square Management Survey Report Issue 1.pdf', 'Compliance Asset', 'general', '12 months', 'unknown', TRUE);
INSERT INTO compliance_assets (id, building_id, description, asset_name, asset_type, inspection_frequency, compliance_status, is_active) VALUES ('b467c371-8e1c-4bb9-a771-13ad269fb466', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'Extracted from TETRA - Asbestos Re-Inspection Survey 14.06.22.pdf', 'Compliance Asset', 'general', '12 months', 'unknown', TRUE);

-- Insert 4 major works projects
INSERT INTO major_works_projects (id, building_id, project_name, status, start_date) VALUES ('3af3687e-5aca-435e-860b-8f92694276c6', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'External Decoration - 2025', 'planned', '2025-01-01');
INSERT INTO major_works_projects (id, building_id, project_name, status, start_date) VALUES ('6419f392-3050-453d-8c13-b9d457337002', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'Section 20 Consultation (SOE) - 2025', 'planned', '2025-01-01');
INSERT INTO major_works_projects (id, building_id, project_name, status, start_date) VALUES ('1d62f9bd-c7b0-4e6d-bdcd-edf5127235c7', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'Lift - Section 20 (NOI) - 2025', 'planned', '2025-01-01');
INSERT INTO major_works_projects (id, building_id, project_name, status, start_date) VALUES ('b1381e8f-88bc-47f4-b40b-ab04353308d5', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'Major Works Project - 2025', 'planned', '2025-01-01');

-- Insert 22 budgets
INSERT INTO budgets (id, building_id) VALUES ('94f32da6-d963-4298-9582-ea8325453ece', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8');
INSERT INTO budgets (id, building_id) VALUES ('2f22dcf3-d44e-4aee-b906-a7b3863fc263', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8');
INSERT INTO budgets (id, building_id) VALUES ('94c3a8de-193b-464e-84a7-5c25894e98ec', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8');
INSERT INTO budgets (id, building_id) VALUES ('2d2adfea-5911-43eb-b18b-65f69037bb75', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8');
INSERT INTO budgets (id, building_id) VALUES ('be424008-ac3c-4571-af12-1ebcbf5d40e3', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8');
INSERT INTO budgets (id, building_id) VALUES ('f4ca6385-0799-46d3-8af7-6af323e5fb06', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8');
INSERT INTO budgets (id, building_id) VALUES ('c9a75b5d-a2bf-456e-b74b-b2403e54ddb9', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8');
INSERT INTO budgets (id, building_id) VALUES ('59068ce6-ac68-4312-9d1a-96ae22212c87', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8');
INSERT INTO budgets (id, building_id) VALUES ('be4e269a-d818-4663-874b-7fe67ed49674', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8');
INSERT INTO budgets (id, building_id) VALUES ('d2e8c5c1-c2f3-4488-aabf-eaba0dfcfea0', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8');
INSERT INTO budgets (id, building_id) VALUES ('6513a93d-07f2-4ec8-ac2b-342ead68f387', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8');
INSERT INTO budgets (id, building_id) VALUES ('5dd25a62-4118-4052-b8ca-5300f6cfea6f', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8');
INSERT INTO budgets (id, building_id) VALUES ('f3fe2442-1865-4510-9cde-52f6173578c1', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8');
INSERT INTO budgets (id, building_id) VALUES ('bf0967c1-d5a0-4961-b222-c970d45df3d1', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8');
INSERT INTO budgets (id, building_id) VALUES ('1158255f-3b27-4f85-b2bd-b7993d01e545', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8');
INSERT INTO budgets (id, building_id) VALUES ('67c861d5-3d8b-4808-a5c3-c4a7c02fc5e6', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8');
INSERT INTO budgets (id, building_id) VALUES ('ee9075af-c889-4dc2-a26d-3afa96802463', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8');
INSERT INTO budgets (id, building_id) VALUES ('71523fe8-5c3c-427b-8f05-f31f12427e86', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8');
INSERT INTO budgets (id, building_id) VALUES ('1f037a24-93d4-4172-9b1c-2837f9d32d22', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8');
INSERT INTO budgets (id, building_id) VALUES ('b6ef849b-26ea-4145-8352-e32739556f7b', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8');
INSERT INTO budgets (id, building_id) VALUES ('519d46bb-27c1-4ec3-bb03-f0e59360b32c', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8');
INSERT INTO budgets (id, building_id) VALUES ('9f032c93-5320-41ca-b60d-cede7cb11826', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8');

-- Insert 316 document records
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('53a49509-fd17-4660-a3bc-c2341d041d90', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'lease', 'Important Information .pdf', 'lease/Important Information .pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('be550639-fbba-4f6f-8ea9-3aed75f6485e', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'finance', 'ACCOUNTS - YE 31.03.21 - Service Charge Accounts (1).pdf', 'finance/ACCOUNTS - YE 31.03.21 - Service Charge Accounts (1).pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('c76dd562-7d24-4496-9440-bab082526a66', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'lease', 'Official Copy (Lease) 04.08.2022 - NGL809841 (1).pdf', 'lease/Official Copy (Lease) 04.08.2022 - NGL809841 (1).pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('4051075f-497d-49dc-b44d-1bb8e079353f', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'lease', 'Official Copy (Lease) 04.08.2022 - NGL809841 (2).pdf', 'lease/Official Copy (Lease) 04.08.2022 - NGL809841 (2).pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('44ae79e0-e3f8-47b6-9f76-3f9061b7e88b', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'lease', 'Official Copy (Lease) 13.06.2003 - NGL827422.pdf', 'lease/Official Copy (Lease) 13.06.2003 - NGL827422.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('1d62c03a-7fc6-49ee-9cff-658d1d88b3fd', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'lease', 'Official Copy (Lease) 04.08.2022 - NGL809841.pdf', 'lease/Official Copy (Lease) 04.08.2022 - NGL809841.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('f2444344-01aa-41e9-bc1f-1cc4f99f191a', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'lease', 'Signed April 2025 Arrears Collection Procedure.pdf', 'lease/Signed April 2025 Arrears Collection Procedure.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('257dd282-8a80-4279-829c-d48195076d22', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'lease', 'WP0005V17 Welcome Pack.pdf', 'lease/WP0005V17 Welcome Pack.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('92dc292e-97b8-4657-aa6a-30ec3a2ffd9b', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'lease', 'Jobcard_For_Job_No_33844_07-04-2025_1143.pdf', 'lease/Jobcard_For_Job_No_33844_07-04-2025_1143.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('3b859327-a2fe-4c81-a8d0-bb42812d3db6', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'lease', 'Jobcard_For_Job_No_37675_25-07-2025_1549.pdf', 'lease/Jobcard_For_Job_No_37675_25-07-2025_1549.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('3d636fb1-3598-4a7d-a8f3-125aac450c30', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'lease', 'Jobcard_For_Job_No_34012_01-05-2025_1616.pdf', 'lease/Jobcard_For_Job_No_34012_01-05-2025_1616.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('53d10871-c3e2-429f-a144-aed893bb5db4', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'lease', 'Jobcard_For_Job_No_32759_17-03-2025_1145.pdf', 'lease/Jobcard_For_Job_No_32759_17-03-2025_1145.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('effb487d-7d25-49cf-a611-4f92c00fdd33', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'lease', 'Jobcard_For_Job_No_32810_17-03-2025_1311.pdf', 'lease/Jobcard_For_Job_No_32810_17-03-2025_1311.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('f5d44f4e-7a4c-4701-b732-589c1f41f795', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'contracts', 'Quote_No_23550 - Connaught Square (32-34) 2023-2024.pdf', 'contracts/Quote_No_23550 - Connaught Square (32-34) 2023-2024.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('5b15186b-de32-46cf-99b5-1a9f2102b669', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'lease', 'Licence_Document_352024.pdf', 'lease/Licence_Document_352024.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('7fb1d716-67cb-463d-a741-138925f515b3', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'lease', 'JLGServiceVisit-M00813-12-09-2024.pdf', 'lease/JLGServiceVisit-M00813-12-09-2024.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('2328feeb-a24f-4886-bf6e-fe5e58ab6e5a', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'lease', 'JLGServiceVisit-M00813-13-11-2024.pdf', 'lease/JLGServiceVisit-M00813-13-11-2024.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('097e6139-8bd1-4776-9f7a-5d3ad548c5b2', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'lease', 'JLGServiceVisit-M00813-02-12-2024.pdf', 'lease/JLGServiceVisit-M00813-02-12-2024.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('56db6fa9-e36d-464a-b92f-14bea8c44f4a', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'lease', 'JLGServiceVisit-M00813-08-07-2024.pdf', 'lease/JLGServiceVisit-M00813-08-07-2024.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('88c0033f-7555-4803-bd2b-09d182581d5b', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'lease', 'JLGServiceVisit-M00813-08-10-2024.pdf', 'lease/JLGServiceVisit-M00813-08-10-2024.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('135afdd5-a64d-4f77-92da-346361f0c707', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'lease', 'JLGServiceVisit-M00813-12-02-2025.pdf', 'lease/JLGServiceVisit-M00813-12-02-2025.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('1d5c71ae-eae2-40d2-b6bc-df2f5e9c7983', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'lease', 'JLGServiceVisit-M00813-17-03-2025.pdf', 'lease/JLGServiceVisit-M00813-17-03-2025.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('ab0044cb-f9e2-40c3-96e6-d24bdd230685', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'lease', 'JLGServiceVisit-M00813-14-04-2025.pdf', 'lease/JLGServiceVisit-M00813-14-04-2025.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('d7bd5891-f7fc-4d1d-9abc-f64948d4fffc', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'lease', 'REP-40343473-L1.pdf', 'lease/REP-40343473-L1.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('06234b26-f533-436b-818f-2f3589dc86ff', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'lease', 'JLGServiceVisit-M00813-13-05-2025.pdf', 'lease/JLGServiceVisit-M00813-13-05-2025.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('c7c7e919-ad86-4d8f-a48b-dacc5d92ff78', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'lease', 'Communal Cleaning-First Port.pdf', 'lease/Communal Cleaning-First Port.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('de2cdb13-e411-46d3-9e69-8db80c541015', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'lease', 'SC Health and Safety Product - Accredited 10072023.pdf', 'lease/SC Health and Safety Product - Accredited 10072023.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('320df57b-051e-4858-9d2c-1d63a933b60e', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'lease', 'Tenancy Schedule by Property.pdf', 'lease/Tenancy Schedule by Property.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('aa7c8ecf-30ca-42ae-ad27-115e64bbb3d9', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'finance', 'Accounts YE 31.03.2022 32-34 Connaught Square MJP.pdf', 'finance/Accounts YE 31.03.2022 32-34 Connaught Square MJP.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('04035f63-6747-45ad-a688-c8927adb093a', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'finance', '197-YE 31.03.22 SC Accs FINAL MAY 2023.pdf', 'finance/197-YE 31.03.22 SC Accs FINAL MAY 2023.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('2d564b06-7769-4d92-a11f-5853376a1fbb', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'finance', 'ACCOUNTS - YE 31.03.21 - Service Charge Accounts (1).pdf', 'finance/ACCOUNTS - YE 31.03.21 - Service Charge Accounts (1).pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('8509660d-f375-48c8-a3b8-ba25435afb20', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'finance', '27039 Accounts Pack - YE 2023.pdf', 'finance/27039 Accounts Pack - YE 2023.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('94af0675-e001-4050-b437-b2b239a2add1', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'finance', 'Connaught Sq SC YE 23.pdf', 'finance/Connaught Sq SC YE 23.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('ab8fb58e-3553-4d41-a4df-c188f6c2e290', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'lease', 'Connaught Square-House Rules.docx', 'lease/Connaught Square-House Rules.docx');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('80f750a6-3ddb-4c91-b96b-b573a0a1068f', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'correspondence', 'Garden Notice-Connaught Square.docx', 'correspondence/Garden Notice-Connaught Square.docx');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('10959d27-c287-45bb-aa58-029bdcac3481', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'correspondence', 'Connaught Square-Key Cut Authorisation Letter.docx', 'correspondence/Connaught Square-Key Cut Authorisation Letter.docx');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('01afb3dd-c757-49a1-baa4-6bca2c86fb4b', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'lease', 'House Rules-Connaught Square.pdf', 'lease/House Rules-Connaught Square.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('7524be36-efca-4639-859d-25de4f864a6f', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'lease', 'REP-39659654.pdf', 'lease/REP-39659654.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('c464ec9b-31b2-468b-95f8-7a480038e27d', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'lease', 'Important Information .pdf', 'lease/Important Information .pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('0b8be2eb-e677-4727-933a-83f52dd96c0d', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'lease', 'StG_Certificate_32-34 Connaught Square W2 2HL.pdf', 'lease/StG_Certificate_32-34 Connaught Square W2 2HL.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('ee8cb2ab-af24-4152-a02b-ee3df49eba59', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'contracts', 'CM434.AnnualServiceAgreement2025-2026.pdf', 'contracts/CM434.AnnualServiceAgreement2025-2026.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('297782a8-ab7c-4647-8f72-f23d1111dcda', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'contracts', 'CM434.AnnualServiceAgreement2024-2025.pdf', 'contracts/CM434.AnnualServiceAgreement2024-2025.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('15840937-2521-47da-b451-2d931ed6b48b', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'lease', 'REP-40324834-E3.pdf', 'lease/REP-40324834-E3.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('dffab708-0a01-4342-a3e5-c1e37ebf63a8', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'lease', 'Ellie@mihproperty.co.uk - BES Group - E-Report.pdf', 'lease/Ellie@mihproperty.co.uk - BES Group - E-Report.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('176a8f04-7d84-4353-9475-e340f572355f', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'lease', 'Jobcard_For_Job_No_38609_26-08-2025_0741.pdf', 'lease/Jobcard_For_Job_No_38609_26-08-2025_0741.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('cd2555e2-c549-45ac-bf10-c746a27b85c6', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'lease', 'Jobcard_For_Job_No_28737_25-11-2024_0907.pdf', 'lease/Jobcard_For_Job_No_28737_25-11-2024_0907.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('63c12922-86d8-492f-b80b-1efbfafc9cd6', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'lease', 'Jobcard_For_Job_No_35402_03-06-2025_0916.pdf', 'lease/Jobcard_For_Job_No_35402_03-06-2025_0916.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('7da116cc-2ccd-4d54-bc58-167558c5bc5d', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'lease', 'Jobcard_For_Job_No_35654_03-06-2025_0911.pdf', 'lease/Jobcard_For_Job_No_35654_03-06-2025_0911.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('4f5a5a80-b5ca-4917-8bd5-2eec911b6850', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'lease', 'Jobcard_For_Job_No_37675_25-07-2025_1549.pdf', 'lease/Jobcard_For_Job_No_37675_25-07-2025_1549.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('e692d815-d1a0-4b46-b6fa-7511984658ea', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'lease', 'Jobcard_For_Job_No_35146_03-06-2025_0906.pdf', 'lease/Jobcard_For_Job_No_35146_03-06-2025_0906.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('5b3a71dc-cad0-4294-9a2c-8be953c43759', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'lease', 'Jobcard_For_Job_No_31162_30-01-2025_1602.pdf', 'lease/Jobcard_For_Job_No_31162_30-01-2025_1602.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('bc29592e-0d3d-475f-8e0e-a1a10baf0d2e', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'lease', 'Jobcard_For_Job_No_36465_20-06-2025_1037.pdf', 'lease/Jobcard_For_Job_No_36465_20-06-2025_1037.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path, entity_type, linked_entity_id) VALUES ('21ee75ba-0c42-4381-9771-5651527b87b4', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'finance', 'ACCOUNTS - YE 31.03.21 - Service Charge Accounts.pdf', 'finance/ACCOUNTS - YE 31.03.21 - Service Charge Accounts.pdf', 'budget', '6c32cff3-541a-48b4-ad84-5fad072f6363');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path, entity_type, linked_entity_id) VALUES ('bcd92669-c176-4ac7-9581-cae6dc4e5a19', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'finance', 'Connaught Square Budget 2025-6 Draft.xlsx', 'finance/Connaught Square Budget 2025-6 Draft.xlsx', 'budget', 'dd09f23b-b113-483d-889a-75935e5af65e');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path, entity_type, linked_entity_id) VALUES ('55ef6361-4816-4cba-9838-dfe7a911347e', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'finance', 'Connaught Square Budget 2025-Final.pdf', 'finance/Connaught Square Budget 2025-Final.pdf', 'budget', '17906837-f0d1-41b1-a08e-216cea71d392');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path, entity_type, linked_entity_id) VALUES ('007904c0-eef2-455d-9fae-a944159d02f0', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'finance', 'Connaught Square Budget 2025-Final.xlsx', 'finance/Connaught Square Budget 2025-Final.xlsx', 'budget', 'f02110a1-789a-482a-a886-e8e54365e4a3');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path, entity_type, linked_entity_id) VALUES ('8b774a1b-564f-4de5-91fc-17f98b031596', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'finance', 'ACCOUNTS - YE 31.03.21 - Service Charge Accounts.pdf', 'finance/ACCOUNTS - YE 31.03.21 - Service Charge Accounts.pdf', 'budget', '2b5b6436-214c-48e9-bf47-27c3560d89e9');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path, entity_type, linked_entity_id) VALUES ('1bb61018-2c6d-4dd8-8f99-81193d7d33a2', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'finance', 'Connaught Square YE 24 Accounts.pdf', 'finance/Connaught Square YE 24 Accounts.pdf', 'budget', 'ce495b09-6dfe-469f-97d4-b332ad37e29a');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path, entity_type, linked_entity_id) VALUES ('94a7d07c-c01f-45c7-8e0e-022dbfd6da56', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'compliance', '2024 Directors Meeting-Notes.docx', 'compliance/2024 Directors Meeting-Notes.docx', 'compliance_asset', 'b2c12569-9c86-485e-a01e-15a51d18d3aa');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path, entity_type, linked_entity_id) VALUES ('66cbbe65-8e86-481d-8eb9-75153afe969c', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'compliance', 'Fire Door (Communal) Inspection (11m +) (7).pdf', 'compliance/Fire Door (Communal) Inspection (11m +) (7).pdf', 'compliance_asset', 'ca76d921-926d-400c-9495-43149ceb0edd');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path, entity_type, linked_entity_id) VALUES ('8205ac8c-03ff-4a9f-b380-cdbcb5b9d5d9', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'compliance', 'Fire Door (Flats) Inspection (11m +) (13).pdf', 'compliance/Fire Door (Flats) Inspection (11m +) (13).pdf', 'compliance_asset', '11773620-8c18-4091-9285-fd87d58608a6');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path, entity_type, linked_entity_id) VALUES ('ab9c6ace-10fb-4d26-a6ac-b66961dc4d15', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'compliance', 'Fire Door (Flats) Inspection (11m +) (18).pdf', 'compliance/Fire Door (Flats) Inspection (11m +) (18).pdf', 'compliance_asset', '404df702-1212-403e-8ee0-e598c4cbaced');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path, entity_type, linked_entity_id) VALUES ('ba7cea99-9809-4285-8806-6406969bd9c0', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'compliance', 'Fire Door (Flats) Inspection (11m +) (14).pdf', 'compliance/Fire Door (Flats) Inspection (11m +) (14).pdf', 'compliance_asset', 'b0a20d2f-9490-49c3-8dd1-df3f168ad65f');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path, entity_type, linked_entity_id) VALUES ('20ebf0f8-6cbf-477a-b92d-6ed8fcdedad0', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'compliance', 'EICR Cuanku 32-34 conaught square.pdf', 'compliance/EICR Cuanku 32-34 conaught square.pdf', 'compliance_asset', 'c009aef8-e891-4eea-9c1d-4d9fc79ec6a1');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path, entity_type, linked_entity_id) VALUES ('d3c37a4e-a46a-4865-9dee-fd7ab42fa603', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'compliance', 'Fire Door (Flats) Inspection (11m +) (15).pdf', 'compliance/Fire Door (Flats) Inspection (11m +) (15).pdf', 'compliance_asset', '53652672-8b71-45f1-a98d-7d881cc2e011');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path, entity_type, linked_entity_id) VALUES ('30fe709b-9081-490a-ba74-cc744f2994ed', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'compliance', '221037_Fra1-L-394697-071223 32-34 Connaught Square_2024-01-02_163759 (1).pdf', 'compliance/221037_Fra1-L-394697-071223 32-34 Connaught Square_2024-01-02_163759 (1).pdf', 'compliance_asset', 'eb0a8d07-4418-4891-86b2-280bdbe629c7');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path, entity_type, linked_entity_id) VALUES ('3b15dcff-722e-459d-8186-c1d142a6cac3', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'compliance', 'Fire Door (Flats) Inspection (11m +) (19).pdf', 'compliance/Fire Door (Flats) Inspection (11m +) (19).pdf', 'compliance_asset', '027edbc2-b264-4c1b-9d1b-c9b9ed5b72b6');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path, entity_type, linked_entity_id) VALUES ('79b93cc2-43f5-4a6a-bdc5-b07e38514ebb', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'compliance', '001132-3234-Connaught-Square-London.pdf', 'compliance/001132-3234-Connaught-Square-London.pdf', 'compliance_asset', 'c41de099-f132-43d9-835e-2a20ed128c86');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path, entity_type, linked_entity_id) VALUES ('1e22ca40-985b-4dde-ab9d-a2fbe61a7c5a', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'compliance', '221038_Hsra1-L-394697-071223 32-34 Connaught Square_2024-01-02_163759 (1).pdf', 'compliance/221038_Hsra1-L-394697-071223 32-34 Connaught Square_2024-01-02_163759 (1).pdf', 'compliance_asset', '5c5578b1-3beb-46c4-a428-f3c13d626758');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path, entity_type, linked_entity_id) VALUES ('0af0e42f-2046-4c9e-bfe5-95efd869b0dc', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'compliance', 'TETRA - Asbestos Re-Inspection Survey 14.06.22.pdf', 'compliance/TETRA - Asbestos Re-Inspection Survey 14.06.22.pdf', 'compliance_asset', 'a38f107e-e979-478b-9433-8143ac1772d9');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path, entity_type, linked_entity_id) VALUES ('67b67e2e-3c6f-42d2-9c11-424ebe496ef2', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'compliance', 'Fire Door (Flats) Inspection (11m +) (16).pdf', 'compliance/Fire Door (Flats) Inspection (11m +) (16).pdf', 'compliance_asset', '3830ad0a-01d3-4467-9ca5-b65c7825a2dc');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path, entity_type, linked_entity_id) VALUES ('1601ef81-4932-40c5-bf51-f5f0d75f6bea', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'compliance', 'Fire Door (Flats) Inspection (11m +) (17).pdf', 'compliance/Fire Door (Flats) Inspection (11m +) (17).pdf', 'compliance_asset', 'caf06cb3-d8e8-4bd9-8598-6ae8b14ea27f');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path, entity_type, linked_entity_id) VALUES ('194f8e59-cc7c-4c7f-b2a7-8dbd6d4f7343', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'compliance', 'WHM Legionella Risk Assessment 07.06.22.pdf', 'compliance/WHM Legionella Risk Assessment 07.06.22.pdf', 'compliance_asset', '245d1df3-018c-4b5a-90f7-ef70d1937812');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path, entity_type, linked_entity_id) VALUES ('de72cb87-097f-4f0f-b2b3-dca5bbdff447', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'compliance', 'EICR Report Cunaku SATISFACTORY 2023 .pdf', 'compliance/EICR Report Cunaku SATISFACTORY 2023 .pdf', 'compliance_asset', 'a9250478-5aa8-4fbc-8619-3391267216f0');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path, entity_type, linked_entity_id) VALUES ('b69141c5-135c-43cf-8bdd-fb6d38cc458a', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'compliance', '2024 Directors Meeting-Notes.docx', 'compliance/2024 Directors Meeting-Notes.docx', 'compliance_asset', 'a29db49e-34da-4483-b56f-e7a0c4148f4e');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path, entity_type, linked_entity_id) VALUES ('9ac55562-155b-4d68-b575-96f8ab10ffa1', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'compliance', '001457-3234-Connaught-Square-London Certificate.pdf', 'compliance/001457-3234-Connaught-Square-London Certificate.pdf', 'compliance_asset', '31b7ecfb-a22b-4b70-8667-79fc4857d92b');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path, entity_type, linked_entity_id) VALUES ('ab9c042e-267e-4add-a06a-ed0beb5fe2c7', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'compliance', 'TC0001V31 General Terms and Conditions.pdf', 'compliance/TC0001V31 General Terms and Conditions.pdf', 'compliance_asset', '504ff3ac-20e9-4301-b332-bc01a03a94ff');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path, entity_type, linked_entity_id) VALUES ('c635a9ec-3656-40f7-ad36-6cc132f675da', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'compliance', 'Jobcard_For_Job_No_28992_24-01-2025_1545.pdf', 'compliance/Jobcard_For_Job_No_28992_24-01-2025_1545.pdf', 'compliance_asset', '4d8cf27e-a941-4ca4-8693-b3d131b8a11a');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path, entity_type, linked_entity_id) VALUES ('4ef972dc-4571-4a30-9b88-eadf395ef104', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'compliance', 'Connaught Square (32-34) - 09.12.24 LRA.pdf', 'compliance/Connaught Square (32-34) - 09.12.24 LRA.pdf', 'compliance_asset', 'db5703da-c264-43ae-a74c-108747317b78');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path, entity_type, linked_entity_id) VALUES ('78f10169-e569-4ff8-927d-fd605f338503', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'compliance', 'SC Certificate - 10072023.pdf', 'compliance/SC Certificate - 10072023.pdf', 'compliance_asset', 'dc4b2a83-8aad-47d0-9aaa-16e8e36553c7');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path, entity_type, linked_entity_id) VALUES ('020bb227-1369-453d-b75e-898c657311b3', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'compliance', 'Fire Door (Communal) Inspection (11m +) (7).pdf', 'compliance/Fire Door (Communal) Inspection (11m +) (7).pdf', 'compliance_asset', '93936f73-e8fb-4bd5-bce6-cf5d89c729a6');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path, entity_type, linked_entity_id) VALUES ('30d60f06-80bc-4a41-ad6f-da6cdff29b5d', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'compliance', 'Fire Door (Flats) Inspection (11m +) (13).pdf', 'compliance/Fire Door (Flats) Inspection (11m +) (13).pdf', 'compliance_asset', '6b5c3d29-4281-4628-ac6b-ad17b58f7af0');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path, entity_type, linked_entity_id) VALUES ('b68e4eee-7e33-4a0c-8449-db16652b9662', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'compliance', 'Fire Door (Flats) Inspection (11m +) (18).pdf', 'compliance/Fire Door (Flats) Inspection (11m +) (18).pdf', 'compliance_asset', 'c246ff91-cab1-4d6c-9cb6-32a755d08b2d');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path, entity_type, linked_entity_id) VALUES ('05283633-c658-4d27-b5b9-8642d60c0bcc', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'compliance', 'Fire Door (Flats) Inspection (11m +) (14).pdf', 'compliance/Fire Door (Flats) Inspection (11m +) (14).pdf', 'compliance_asset', '0240ef66-8246-42ad-9dd9-a66cf6445093');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path, entity_type, linked_entity_id) VALUES ('a30cbd89-02b6-407d-a38d-2d544086ae81', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'compliance', 'Fire Door (Flats) Inspection (11m +) (15).pdf', 'compliance/Fire Door (Flats) Inspection (11m +) (15).pdf', 'compliance_asset', '570a3518-0e71-46ce-8be4-e390aaf92ab5');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path, entity_type, linked_entity_id) VALUES ('c4297b92-1e70-4583-9cf1-bdf18ca47a97', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'compliance', 'Fire Door (Flats) Inspection (11m +) (19).pdf', 'compliance/Fire Door (Flats) Inspection (11m +) (19).pdf', 'compliance_asset', 'bcca537d-981a-4621-8e9f-7e52c2203eb8');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path, entity_type, linked_entity_id) VALUES ('49cbf860-3bce-4611-85ee-dfb69aa580bc', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'compliance', 'Fire Door (Flats) Inspection (11m +) (16).pdf', 'compliance/Fire Door (Flats) Inspection (11m +) (16).pdf', 'compliance_asset', '0ffc32f9-cb7b-44f7-a98b-43f3cb0956ef');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path, entity_type, linked_entity_id) VALUES ('510a631e-a2c0-43d3-a2a3-e787469538f8', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'compliance', 'Fire Door (Flats) Inspection (11m +) (17).pdf', 'compliance/Fire Door (Flats) Inspection (11m +) (17).pdf', 'compliance_asset', 'bdc46c82-d0eb-4e0d-9f00-1b30abb56bed');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path, entity_type, linked_entity_id) VALUES ('df7fbe38-13ea-4704-a8d0-fce4c7348d10', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'compliance', '221037_Fra1-L-394697-071223 32-34 Connaught Square_2024-01-02_163759.pdf', 'compliance/221037_Fra1-L-394697-071223 32-34 Connaught Square_2024-01-02_163759.pdf', 'compliance_asset', 'ef8938b8-ec16-4f32-b2a3-8bdec73a6e7d');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path, entity_type, linked_entity_id) VALUES ('cf244733-98cd-4e11-a9e0-e1b02078230a', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'compliance', 'Fire Door (Flats) Inspection (11m +) - 2024-01-24T120747.552.pdf', 'compliance/Fire Door (Flats) Inspection (11m +) - 2024-01-24T120747.552.pdf', 'compliance_asset', '3a533d1d-c6e0-41de-93e0-521a8d52b89e');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path, entity_type, linked_entity_id) VALUES ('77460ff4-a7e9-452a-89c9-ab3576c8bd97', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'compliance', 'Connaught Square (32-34) - 15.11.23 (886) wa.pdf', 'compliance/Connaught Square (32-34) - 15.11.23 (886) wa.pdf', 'compliance_asset', '7547664b-6404-4ec7-b2dc-90b6de0ec0fd');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path, entity_type, linked_entity_id) VALUES ('37a5c758-76ff-4205-be70-e81e49b480ee', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'compliance', 'Fire Door (Flats) Inspection (11m +) - 2024-01-24T120745.875.pdf', 'compliance/Fire Door (Flats) Inspection (11m +) - 2024-01-24T120745.875.pdf', 'compliance_asset', '5ac99679-153e-42cd-b976-aebe5b6e9c1d');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path, entity_type, linked_entity_id) VALUES ('38d79666-c040-4e79-a438-568ae425c753', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'compliance', 'Fire Door (Flats) Inspection (11m +) - 2024-01-24T120746.424.pdf', 'compliance/Fire Door (Flats) Inspection (11m +) - 2024-01-24T120746.424.pdf', 'compliance_asset', '095e68aa-233b-42c4-9b92-4dabc99cb0aa');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path, entity_type, linked_entity_id) VALUES ('cd3e89f0-6339-4c79-a062-c776fab3d830', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'compliance', 'Fire Door (Communal) Inspection (11m +) - 2024-01-24T120743.986.pdf', 'compliance/Fire Door (Communal) Inspection (11m +) - 2024-01-24T120743.986.pdf', 'compliance_asset', 'fe868683-772e-4bbb-9713-c3e69bd0d52a');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path, entity_type, linked_entity_id) VALUES ('2a6b1613-5fe4-463e-ad18-13bc1237e9b8', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'compliance', 'Fire Door (Flats) Inspection (11m +) - 2024-01-24T120744.738.pdf', 'compliance/Fire Door (Flats) Inspection (11m +) - 2024-01-24T120744.738.pdf', 'compliance_asset', '6c6bbad3-b8c4-4490-983f-1b3d23b7bc44');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path, entity_type, linked_entity_id) VALUES ('16a956a1-68c0-4d76-a24f-b72fe257bc5a', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'compliance', 'Fire Door (Flats) Inspection (11m +) - 2024-01-24T120747.015.pdf', 'compliance/Fire Door (Flats) Inspection (11m +) - 2024-01-24T120747.015.pdf', 'compliance_asset', '7bc27476-9cdb-4f5a-9aba-973bed6ad0dd');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path, entity_type, linked_entity_id) VALUES ('528e7d88-8e34-467c-b1c6-507e4ddb3290', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'compliance', '221038_Hsra1-L-394697-071223 32-34 Connaught Square_2024-01-02_163759.pdf', 'compliance/221038_Hsra1-L-394697-071223 32-34 Connaught Square_2024-01-02_163759.pdf', 'compliance_asset', '5194adc0-dee1-40f6-85a1-ba262b5ecb3c');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path, entity_type, linked_entity_id) VALUES ('c8244f22-364a-4a81-8a78-b54911b8aa91', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'compliance', 'Fire Door (Flats) Inspection (11m +) - 2024-01-24T120745.174.pdf', 'compliance/Fire Door (Flats) Inspection (11m +) - 2024-01-24T120745.174.pdf', 'compliance_asset', '3481bfbb-b905-4b1f-b562-4a2c0dac417f');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path, entity_type, linked_entity_id) VALUES ('9e8bb64a-7412-4d47-b663-367781821420', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'compliance', 'Hsfra1-L-422971-210225 32-34 Connaught Square.pdf', 'compliance/Hsfra1-L-422971-210225 32-34 Connaught Square.pdf', 'compliance_asset', '21881f27-f48d-4811-9812-7653c50861ba');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path, entity_type, linked_entity_id) VALUES ('978cb8d1-9c8a-4856-892c-69923e713037', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'compliance', 'Hsfra1-L-422971-210225 32-34 Connaught Square.docx', 'compliance/Hsfra1-L-422971-210225 32-34 Connaught Square.docx', 'compliance_asset', '70846469-7734-4beb-8ab0-81295b6ffc4b');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path, entity_type, linked_entity_id) VALUES ('55426371-bd66-4b69-853b-297cd14fd357', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'compliance', '221037_Fra1-L-394697-071223 32-34 Connaught Square_2024-01-02_163759 (1).pdf', 'compliance/221037_Fra1-L-394697-071223 32-34 Connaught Square_2024-01-02_163759 (1).pdf', 'compliance_asset', 'f526cbdf-f288-4bf5-89dd-e8ce1fb2c943');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path, entity_type, linked_entity_id) VALUES ('a4271427-c397-4745-8202-cbbd6997236d', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'compliance', '221038_Hsra1-L-394697-071223 32-34 Connaught Square_2024-01-02_163759 (1).pdf', 'compliance/221038_Hsra1-L-394697-071223 32-34 Connaught Square_2024-01-02_163759 (1).pdf', 'compliance_asset', '5c276c33-c477-4191-9b31-990ae8f018b6');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path, entity_type, linked_entity_id) VALUES ('f44daa77-c693-48b6-b77a-4893924af03d', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'compliance', 'FRA-Connaught Square Reccommendations.xlsx', 'compliance/FRA-Connaught Square Reccommendations.xlsx', 'compliance_asset', '57c590dd-27dc-4f5d-bd80-f1658448fee0');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path, entity_type, linked_entity_id) VALUES ('8fd8e388-afaa-43fb-8211-0afdff822cdb', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'compliance', '001534-3234-Connaught-Square-London.pdf', 'compliance/001534-3234-Connaught-Square-London.pdf', 'compliance_asset', 'b8d8529a-d4c2-4536-b6ba-1ddc40a6acbd');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path, entity_type, linked_entity_id) VALUES ('24ea22d2-5505-45c6-8179-1a2e867d0a7d', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'compliance', 'C1047 - Job card.pdf', 'compliance/C1047 - Job card.pdf', 'compliance_asset', 'e2f68b0e-a402-4ab1-b155-93f9b49c9da9');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path, entity_type, linked_entity_id) VALUES ('14410c38-240b-4be6-aac8-c836cc64614d', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'compliance', 'WHM Legionella Risk Assessment 09.12.25.pdf', 'compliance/WHM Legionella Risk Assessment 09.12.25.pdf', 'compliance_asset', '623696ff-b2d1-4a40-bfe7-c0ccc483b13a');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path, entity_type, linked_entity_id) VALUES ('24a8b117-723c-46fa-bfc7-479059fca124', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'compliance', 'WHM Legionella Risk Assessment 07.06.22.pdf', 'compliance/WHM Legionella Risk Assessment 07.06.22.pdf', 'compliance_asset', '595185b0-6f62-4da6-948d-d0ec19abf826');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path, entity_type, linked_entity_id) VALUES ('15d0606d-87cb-4965-a45f-aea4844433a7', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'compliance', 'Connaught Square (32-34) - 29.05.25 (201) wa.pdf', 'compliance/Connaught Square (32-34) - 29.05.25 (201) wa.pdf', 'compliance_asset', 'eed515a2-4a99-479a-b196-7b47a92b0840');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path, entity_type, linked_entity_id) VALUES ('c2a75f7d-c0c8-411d-9e6e-91e3d4bef206', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'compliance', 'EICR Cuanku 32-34 conaught square.pdf', 'compliance/EICR Cuanku 32-34 conaught square.pdf', 'compliance_asset', 'db0b8070-37ae-4f1f-9064-344f2ee43493');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path, entity_type, linked_entity_id) VALUES ('76b1d3e2-cc40-4071-af6f-6bafb2ec6164', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'compliance', 'EICR Report Cunaku SATISFACTORY 2023 .pdf', 'compliance/EICR Report Cunaku SATISFACTORY 2023 .pdf', 'compliance_asset', '95b895fc-07ea-48cf-a9cd-612c60c71f98');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path, entity_type, linked_entity_id) VALUES ('21847d7f-60d9-4e3d-badc-8cb9745e78e2', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'compliance', '001132-3234-Connaught-Square-London.pdf', 'compliance/001132-3234-Connaught-Square-London.pdf', 'compliance_asset', '69087942-465f-4a60-92b5-a012b8411a4d');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path, entity_type, linked_entity_id) VALUES ('13a48046-59d0-4429-879d-8689653cc6a4', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'compliance', '001534-3234-Connaught-Square-London.pdf', 'compliance/001534-3234-Connaught-Square-London.pdf', 'compliance_asset', 'f22a6ccf-cc02-492c-abd5-a87375cbfe87');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path, entity_type, linked_entity_id) VALUES ('59d3cb67-dad8-4efd-b6c2-1ce0e35f1393', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'compliance', 'FINAL L-432900 32-34 Connaught Square Management Survey Report Issue 1.pdf', 'compliance/FINAL L-432900 32-34 Connaught Square Management Survey Report Issue 1.pdf', 'compliance_asset', 'ac223efa-1c76-47f0-83e3-a855bd56b991');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path, entity_type, linked_entity_id) VALUES ('fb893c46-0100-4a24-8e27-d37255dcada7', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'compliance', 'TETRA - Asbestos Re-Inspection Survey 14.06.22.pdf', 'compliance/TETRA - Asbestos Re-Inspection Survey 14.06.22.pdf', 'compliance_asset', 'b467c371-8e1c-4bb9-a771-13ad269fb466');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('67bb04d1-12be-4c93-80d7-f286ac83a78e', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'finance', 'British Gas Invoice-862451083.pdf', 'finance/British Gas Invoice-862451083.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('4dd49329-69d1-4291-8b7b-f91ae551febe', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'contracts', 'Signed 2025 Connaught Square Management Agreement.docx.pdf', 'contracts/Signed 2025 Connaught Square Management Agreement.docx.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('46f2001a-780e-49cb-803f-e930ab74bc7b', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'contracts', 'Connaught Square Management Agreement.docx', 'contracts/Connaught Square Management Agreement.docx');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('22a6d09a-c4cd-4a24-b1a0-861b3817f4df', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'contracts', '2025 Connaught Square Management Agreement.docx', 'contracts/2025 Connaught Square Management Agreement.docx');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('ce2dd259-faee-4041-9424-d35f00c8cbc1', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'contracts', 'Signed Connaught Square Management Agreement.pdf', 'contracts/Signed Connaught Square Management Agreement.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('1f72602a-454f-417c-974f-63f53c4ce245', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'contracts', 'Contractors list.xlsx', 'contracts/Contractors list.xlsx');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('b0eeed06-1a8c-4b89-b8d3-d1a2874f4f0c', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'contracts', 'Contractors list.xlsx', 'contracts/Contractors list.xlsx');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('a80988a1-75c7-4c0d-acf3-36d711cca3e4', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'contracts', 'EMERGENCY CALL OUT DETAILS 2024.pdf', 'contracts/EMERGENCY CALL OUT DETAILS 2024.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('d9ff1642-8d9d-4e11-9e77-f251305c1218', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'contracts', 'CM434.PRO 2024-2025.pdf', 'contracts/CM434.PRO 2024-2025.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('0363796f-3b4f-433f-9d76-959c96097d65', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'contracts', 'CM434.PRO.pdf', 'contracts/CM434.PRO.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('b8a01578-a22f-4dba-9186-0d7e990f4de2', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'contracts', 'Gas Contract 24-5.pdf', 'contracts/Gas Contract 24-5.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('2d3b9c15-a1b4-405f-b09a-c8a282fb77a7', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'contracts', 'Contract_10-03-2025.pdf', 'contracts/Contract_10-03-2025.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('ffe37d3e-9946-46dd-bd64-5335290c9c74', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'contracts', 'Gas Contract 25-26.pdf', 'contracts/Gas Contract 25-26.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('e79e942c-6ac1-44ea-8459-094c0cb72e0e', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'correspondence', 'Welcome Letter - CG1885574.pdf', 'correspondence/Welcome Letter - CG1885574.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('45c38e12-e344-4f28-a7f3-426a3b51c6ea', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'contracts', 'Job 67141.pdf', 'contracts/Job 67141.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('2598c32e-8f61-4617-aad5-b69eca330184', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'contracts', 'BLENHEIMS, 32-34 CONNAUGHT, W2 2HL - 19.05.23.pdf', 'contracts/BLENHEIMS, 32-34 CONNAUGHT, W2 2HL - 19.05.23.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('577b0b03-b7fc-45a1-b57e-67ab50af0786', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'contracts', 'BLENHEIMS, 32-34 CONNAUGHT, W2 2HL - 22.03.23.pdf', 'contracts/BLENHEIMS, 32-34 CONNAUGHT, W2 2HL - 22.03.23.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('20501656-aa08-49e6-8a16-4ef231881c05', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'contracts', 'BLENHEIMS, 32-34 CONNAUGHT, W2 2HL - 26.06.23.pdf', 'contracts/BLENHEIMS, 32-34 CONNAUGHT, W2 2HL - 26.06.23.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('41094fee-d2a0-41b1-ab67-2c95c9e51d14', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'contracts', 'BLENHEIMS, 32-34 CONNAUGHT, W2 2HL - 19.05.23.pdf', 'contracts/BLENHEIMS, 32-34 CONNAUGHT, W2 2HL - 19.05.23.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('21849c83-9fb1-4795-8039-0c3d839970c1', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'contracts', 'BLENHEIMS, 32-34 CONNAUGHT, W2 2HL - 22.03.23.pdf', 'contracts/BLENHEIMS, 32-34 CONNAUGHT, W2 2HL - 22.03.23.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('5212d0c8-4aa0-4f4f-a5c2-050153768621', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'contracts', 'BLENHEIMS, 32-34 CONNAUGHT, W2 2HL - 26.06.23.pdf', 'contracts/BLENHEIMS, 32-34 CONNAUGHT, W2 2HL - 26.06.23.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('a62a339f-9877-49b8-b628-935394043c77', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'contracts', 'Jobcard_For_Job_No_27067_07-10-2024_1147.pdf', 'contracts/Jobcard_For_Job_No_27067_07-10-2024_1147.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('1b910324-41aa-4e53-8ad2-0611550725c1', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'contracts', 'Jobcard_For_Job_No_19665_28-03-2024_0936.pdf', 'contracts/Jobcard_For_Job_No_19665_28-03-2024_0936.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('1408853f-1675-417f-859d-8dc0fa87da76', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'contracts', 'Jobcard_For_Job_No_22634_03-07-2024_1649.pdf', 'contracts/Jobcard_For_Job_No_22634_03-07-2024_1649.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('0f2a7bad-ba1b-4995-93ce-c2ce213363be', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'contracts', 'Jobcard_For_Job_No_25732_03-10-2024_1337.pdf', 'contracts/Jobcard_For_Job_No_25732_03-10-2024_1337.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('8576de2b-b198-43a5-b351-bfb8236fada3', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'contracts', 'Lift Contract-Jacksons lift.pdf', 'contracts/Lift Contract-Jacksons lift.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('99d4ff8b-8bb8-4d67-ba02-73ceb7388f9e', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'contracts', 'JLGCalloutVisit-5455045-12-07-2024.pdf', 'contracts/JLGCalloutVisit-5455045-12-07-2024.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('74fbb54f-0d28-42cc-8324-a65e8a66dd07', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'contracts', 'JLGCalloutVisit-5483206-26-10-2024.pdf', 'contracts/JLGCalloutVisit-5483206-26-10-2024.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('60b50561-3d28-4810-b8c5-fa1cdb9bfdd7', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'contracts', 'JLGCalloutVisit-5498439-16-12-2024.pdf', 'contracts/JLGCalloutVisit-5498439-16-12-2024.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('f1188a4f-d878-4579-8153-bd639b0fbb99', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'contracts', 'JLGCalloutVisit-5455462-16-07-2024.pdf', 'contracts/JLGCalloutVisit-5455462-16-07-2024.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('632db395-2b0f-4688-8962-a7719f2f2632', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'contracts', 'JLGCalloutVisit-5497480-13-12-2024.pdf', 'contracts/JLGCalloutVisit-5497480-13-12-2024.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('dac21b68-c191-42b2-a10a-0178de25aea3', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'contracts', 'Engineering Report - 32-34 CONNAUGHT SQUARE.pdf', 'contracts/Engineering Report - 32-34 CONNAUGHT SQUARE.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('8624c5a7-765c-42ac-be24-194b81ec7a5f', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'contracts', 'Arch Directors and Officers Liability Insurance for Residents Associations (12.22).pdf', 'contracts/Arch Directors and Officers Liability Insurance for Residents Associations (12.22).pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('e52bd7dd-15e9-4025-9025-fc35ec5db36d', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'contracts', 'StG_Policy Wording_32-34 Connaught Square W2 2HL.pdf', 'contracts/StG_Policy Wording_32-34 Connaught Square W2 2HL.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('8ce710ef-4034-4eb7-b0cb-f3eb7c3e50cb', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'compliance', 'Fire Extinguisher Signed Contract- Connaught Square.pdf', 'compliance/Fire Extinguisher Signed Contract- Connaught Square.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('589a9821-e131-4695-8ab4-890cb76d4f35', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'contracts', 'Q51691 - 32-34 Connaught Square Contract.pdf', 'contracts/Q51691 - 32-34 Connaught Square Contract.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('37dab825-8ec6-4b68-a0b1-bd43625af884', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'contracts', 'Engineering Report - 32-34 CONNAUGHT SQUARE.pdf', 'contracts/Engineering Report - 32-34 CONNAUGHT SQUARE.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('6d5d4e19-e53c-46d3-86ee-97f2da7dc03a', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'compliance', 'Fire Alarm+Emergency Lighting Signed Contract-3234 Connaught Square.pdf', 'compliance/Fire Alarm+Emergency Lighting Signed Contract-3234 Connaught Square.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('2f46ee7b-6dd6-4612-abbf-0b64e015ce87', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'compliance', 'Fire Alarm+Emergency Lighting Contract Connaught Square.pdf', 'compliance/Fire Alarm+Emergency Lighting Contract Connaught Square.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('701b35a8-03b3-4a5b-a519-a355eb0b2ea6', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'contracts', 'BT3205 03072025.pdf', 'contracts/BT3205 03072025.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('ba09ec9a-090e-41bd-9743-e76c553eb0d3', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'contracts', 'FA7817 SERVICE 08042025.pdf', 'contracts/FA7817 SERVICE 08042025.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('14178bed-b20a-48af-becd-1819ae2b16dd', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'contracts', 'Engineer Report - 32-34 Connaught Square Flat 5.pdf', 'contracts/Engineer Report - 32-34 Connaught Square Flat 5.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('3e73142f-0b0a-4cb6-8b16-a725dfb6a250', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'contracts', 'Engineering Report - 32-34 CONNAUGHT SQUARE.pdf', 'contracts/Engineering Report - 32-34 CONNAUGHT SQUARE.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('256a5d32-56fc-463e-8024-ebddda2ec5ce', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'contracts', 'Jobcard_For_Job_No_22171_14-05-2024_1202.pdf', 'contracts/Jobcard_For_Job_No_22171_14-05-2024_1202.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('d9b86c5a-0b3e-4c89-91bf-41bcba6ec11e', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'finance', 'British Gas Invoice-862451083.pdf', 'finance/British Gas Invoice-862451083.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('5d4ec261-24dd-4fbd-a407-b81c145c19a8', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'contracts', 'MT8825 03072025.pdf', 'contracts/MT8825 03072025.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('8464146e-e059-4abb-88e6-3a5d595d1b06', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'contracts', 'January Monthly Test For EL-Connaught Square.pdf', 'contracts/January Monthly Test For EL-Connaught Square.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('3df85b4f-f303-45a5-897c-c6c6a34a4f43', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'contracts', 'February Monthly Test For EL-Connaught Square.pdf', 'contracts/February Monthly Test For EL-Connaught Square.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path, entity_type, linked_entity_id) VALUES ('597a60ab-e3b0-4b1e-bfce-2f971b43806d', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'major_works', 'External Decorations SOI - 28042025.docx', 'major_works/External Decorations SOI - 28042025.docx', 'major_works_project', '3af3687e-5aca-435e-860b-8f92694276c6');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path, entity_type, linked_entity_id) VALUES ('b6b457c8-d385-4b3c-9558-040d40962aac', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'major_works', 'External Dec SOE 03072025.docx', 'major_works/External Dec SOE 03072025.docx', 'major_works_project', '6419f392-3050-453d-8c13-b9d457337002');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path, entity_type, linked_entity_id) VALUES ('e90ff582-8f48-4b00-9b78-526e42000699', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'major_works', 'Notice of intention for lift.docx', 'major_works/Notice of intention for lift.docx', 'major_works_project', '1d62f9bd-c7b0-4e6d-bdcd-edf5127235c7');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path, entity_type, linked_entity_id) VALUES ('ed67863d-f918-4511-a3e9-7c5d46eebcd3', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'major_works', 'Connaught Square (32-34) - 09.12.24 Schematic.pdf', 'major_works/Connaught Square (32-34) - 09.12.24 Schematic.pdf', 'major_works_project', 'b1381e8f-88bc-47f4-b40b-ab04353308d5');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('0bb48b73-251e-4bc4-b549-c63b2ca391e4', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'compliance', 'CGBI3964546XB6-Cunaku Construction Ltd-Business-Certificate of insurance.pdf', 'compliance/CGBI3964546XB6-Cunaku Construction Ltd-Business-Certificate of insurance.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('58afa937-9a13-4fe1-b9d5-7136cf0d26c7', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'compliance', 'CGBI3964546XB7-Cunaku Construction Ltd-Business-Certificate of insurance.pdf', 'compliance/CGBI3964546XB7-Cunaku Construction Ltd-Business-Certificate of insurance.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('54c7619d-ba00-4c9f-bae3-4cb37b9e5548', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'compliance', 'Real Estate Insurance NTP (01.23).pdf', 'compliance/Real Estate Insurance NTP (01.23).pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('feb5de2f-8fd6-4b6d-b24b-8626dc12b770', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'compliance', 'Real Estate Policy (01.23).pdf', 'compliance/Real Estate Policy (01.23).pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('daa2783c-2848-4117-943e-5ce45b7def49', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'compliance', 'Summary of Cover (01.23).pdf', 'compliance/Summary of Cover (01.23).pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('55351106-07ae-49b6-ac91-fafe69677f24', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'compliance', '2023 Allianz VOC - 32-34 Connuaght Square (Freehold) Limited.pdf', 'compliance/2023 Allianz VOC - 32-34 Connuaght Square (Freehold) Limited.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('43e4e3bb-d7cf-42fb-88f7-03c1102af504', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'correspondence', '2023 Engineering Renewal Notice - 32 34 Connuaght Square (Freehold) Limited.pdf', 'correspondence/2023 Engineering Renewal Notice - 32 34 Connuaght Square (Freehold) Limited.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('f25ce57d-4a72-4e2c-95f1-e3a18dfbef8c', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'compliance', '32-34 Connaught Square Freehold Limited - Arch D&O Schedule.pdf', 'compliance/32-34 Connaught Square Freehold Limited - Arch D&O Schedule.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('722edbde-75a3-4362-9129-3ca38a43f83e', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'compliance', '32-34 Connaught Sq Buildings Insurance 2023-2024.pdf', 'compliance/32-34 Connaught Sq Buildings Insurance 2023-2024.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('26657c45-f044-4ed6-a924-3e97cea012e1', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'compliance', 'Policy Limits Document.pdf', 'compliance/Policy Limits Document.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('6ae61183-f2ee-46f0-a2af-9a1235bb9855', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'lease', 'Official Copy (Lease) 13.06.2003 - NGL823646-Flat 4.pdf', 'lease/Official Copy (Lease) 13.06.2003 - NGL823646-Flat 4.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('e49721d8-acf7-48f3-9c10-e8092a67dfb4', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'correspondence', 'Letter of Authority - Connaught Square.doc.pdf', 'correspondence/Letter of Authority - Connaught Square.doc.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('a5879d9d-7afc-44a8-a32b-b45160b74f7b', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'correspondence', 'Letter to report - Connaught Square.doc.pdf', 'correspondence/Letter to report - Connaught Square.doc.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('aca86b06-7c81-4734-997f-ad4f17d92d78', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'contracts', 'Pricing Quote - 32_34 Connaught Square Freehold Ltd - 109 - Gas - 10.03.2025.pdf', 'contracts/Pricing Quote - 32_34 Connaught Square Freehold Ltd - 109 - Gas - 10.03.2025.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('cb36d573-46e0-499a-babb-f0a15588b49a', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'compliance', 'Allianz - Lift Report 14.03.23.pdf', 'compliance/Allianz - Lift Report 14.03.23.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('c45dc011-9861-4254-b877-4005b30311db', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'compliance', 'Allianz-Lift Report 18.03.2024.pdf', 'compliance/Allianz-Lift Report 18.03.2024.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('f432602f-6daa-443f-8e7f-48e4716949c0', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'compliance', 'Allianz - Lift Report - 15.09.21.pdf', 'compliance/Allianz - Lift Report - 15.09.21.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('b0a9836e-9c65-494b-baee-1cfbbede76f0', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'compliance', 'Allianz - Lift Report 27.09.23.pdf', 'compliance/Allianz - Lift Report 27.09.23.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('7b97f894-92ca-40f3-9cdf-e13b5329cf10', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'compliance', 'Allianz - Lift Report 10.03.22.pdf', 'compliance/Allianz - Lift Report 10.03.22.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('affe8d38-e6fb-4769-bccd-3c12480957aa', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'compliance', 'Allianz - Lift Report 09.09.22.pdf', 'compliance/Allianz - Lift Report 09.09.22.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('a0e1359b-dfcc-4ae6-8f12-0444e6920dc4', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'compliance', 'LXBI3559280XB2-NEW STEP-Business-Certificate of insurance.pdf', 'compliance/LXBI3559280XB2-NEW STEP-Business-Certificate of insurance.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('8e2611e0-7732-41ba-af87-7dc1611397bf', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'compliance', '2023 Allianz VOC - 32-34 Connuaght Square (Freehold) Limited.pdf', 'compliance/2023 Allianz VOC - 32-34 Connuaght Square (Freehold) Limited.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('a53f432b-9283-4f56-81b7-e9b857d06a33', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'correspondence', '2023 Engineering Renewal Notice - 32 34 Connuaght Square (Freehold) Limited.pdf', 'correspondence/2023 Engineering Renewal Notice - 32 34 Connuaght Square (Freehold) Limited.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('98149b48-c526-4bad-9117-8c8675914413', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'compliance', 'MO - Policy Wording - NZ0411.pdf', 'compliance/MO - Policy Wording - NZ0411.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('76690806-58ca-4ad3-a785-2d4b5939797d', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'compliance', 'Feature and Benefits of Allianz Engineering Inspection Service.pdf', 'compliance/Feature and Benefits of Allianz Engineering Inspection Service.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('66121ea9-3744-4df3-bc33-b2c087d3ff0b', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'compliance', 'StG_Insurer pack_32-34 Connaught Square Freehold Limited.pdf', 'compliance/StG_Insurer pack_32-34 Connaught Square Freehold Limited.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('44146a2c-62b1-449c-bd82-08816c51a6a9', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'compliance', 'StG_Statement of Facts_32-34 Connaught Square W2 2HL.pdf', 'compliance/StG_Statement of Facts_32-34 Connaught Square W2 2HL.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('e6ea1dcd-7e3a-406f-9b9f-ef53505b47c2', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'compliance', 'StG_Insurance Report_32-34 Connaught Square W2 2HL.pdf', 'compliance/StG_Insurance Report_32-34 Connaught Square W2 2HL.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('07c0dbf2-76d0-4a9c-82a4-5d3a3103d089', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'compliance', 'StG_Insurer pack_32-34 Connaught Square Freehold Limited.pdf', 'compliance/StG_Insurer pack_32-34 Connaught Square Freehold Limited.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('e10369d0-b2cf-497d-8bf2-22d13e8bac8c', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'compliance', 'StG_Statement of Facts_32-34 Connaught Square W2 2HL.pdf', 'compliance/StG_Statement of Facts_32-34 Connaught Square W2 2HL.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('206dfe01-b455-4c83-a425-d61bf7e24c9d', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'compliance', 'StG_Insurance Report_32-34 Connaught Square W2 2HL.pdf', 'compliance/StG_Insurance Report_32-34 Connaught Square W2 2HL.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('85f54869-0788-4926-bf19-8cf5c0369afd', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'finance', 'StG_Invoice_32-34 Connaught Square W2 2HL.pdf', 'finance/StG_Invoice_32-34 Connaught Square W2 2HL.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('de6dd98a-b433-47c8-81b0-d46515364b55', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'compliance', 'StG_Certificate_32-34 Connaught Square W2 2HL.pdf', 'compliance/StG_Certificate_32-34 Connaught Square W2 2HL.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('b3c72ace-b7c8-4c62-ba5f-4ba17b8d9695', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'compliance', 'StG_Insurer pack_32-34 Connaught Square Freehold Limited.pdf', 'compliance/StG_Insurer pack_32-34 Connaught Square Freehold Limited.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('7e375cdb-7147-4443-8bd3-9c7b6fd1d390', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'compliance', 'StG_Statement of Fact_32-34 Connaught Square W2 2HL.pdf', 'compliance/StG_Statement of Fact_32-34 Connaught Square W2 2HL.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('3f90afc8-decd-4bb8-9241-4ecc94983452', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'finance', 'StG_Invoice_32-34 Connaught Square Freehold Limited.pdf', 'finance/StG_Invoice_32-34 Connaught Square Freehold Limited.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('05c25ba7-54e3-4125-bee4-24b03996b40b', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'compliance', '32-34 Connaught Square Freehold Limited - Arch D&O Schedule.pdf', 'compliance/32-34 Connaught Square Freehold Limited - Arch D&O Schedule.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('ba78b57e-6c25-4cbb-b525-9852f021c1c5', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'compliance', 'StG_Certificate_32-34 Connaught Square Freehold Limited.pdf', 'compliance/StG_Certificate_32-34 Connaught Square Freehold Limited.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('d24fb435-ebb5-4043-ad20-2f5ee6f1982e', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'compliance', 'StG_Policy Wording_32-34 Connaught Square Freehold Limited.pdf', 'compliance/StG_Policy Wording_32-34 Connaught Square Freehold Limited.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('8727dfa5-5e8f-4d59-9e34-26809b6fcd95', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'compliance', 'StG_D&O Endorsements_32-34 Connaught Square Freehold Limited.pdf', 'compliance/StG_D&O Endorsements_32-34 Connaught Square Freehold Limited.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('d1dba8b0-7719-4e76-bc95-a8da4ab7eab2', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'finance', 'StG_Demands & Needs_32-34 Connaught Square Freehold Limited.pdf', 'finance/StG_Demands & Needs_32-34 Connaught Square Freehold Limited.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('ae0f7511-4bd0-4c20-a870-c5889ba1b0a1', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'contracts', 'StG_Quote_32-34 Connaught Square Freehold Limited.pdf', 'contracts/StG_Quote_32-34 Connaught Square Freehold Limited.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('d5f7699f-e809-4279-976e-b6bdf2fb1916', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'compliance', 'StG_Insurance Report_32-34 Connaught Square W2 2HL.pdf', 'compliance/StG_Insurance Report_32-34 Connaught Square W2 2HL.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('fb56ec1f-69da-47e0-93d3-c83881724350', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'compliance', 'FBR113382303-20230405-B.pdf', 'compliance/FBR113382303-20230405-B.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('0d24d2b1-7615-4748-9179-6df3da9e9f7f', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'compliance', 'Real Estate Insurance NTP (01.23).pdf', 'compliance/Real Estate Insurance NTP (01.23).pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('4367b2a4-1d28-45e0-882a-bad2cbca6c56', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'compliance', 'Real Estate Policy (01.23).pdf', 'compliance/Real Estate Policy (01.23).pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('88854cba-2b59-4342-94d1-004ab5ac826f', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'compliance', 'Summary of Cover (01.23).pdf', 'compliance/Summary of Cover (01.23).pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('58dc01e9-1e47-4bb5-8bd9-efd0d4f85a5f', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'compliance', '32-34 Connaught Sq Buildings Insurance 2023-2024.pdf', 'compliance/32-34 Connaught Sq Buildings Insurance 2023-2024.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('60dc5d27-da87-4707-b3a5-6f9182574746', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'compliance', 'Policy Limits Document.pdf', 'compliance/Policy Limits Document.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('73d7105c-647a-4cae-8f51-44a314494273', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'compliance', 'Zurich Real Estate Policy Summary.pdf', 'compliance/Zurich Real Estate Policy Summary.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('a1e84f9d-711b-4e8a-b30a-71218dd91879', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'compliance', 'Zurich Real Estate Policy Wording.pdf', 'compliance/Zurich Real Estate Policy Wording.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('d6744db0-53ae-46f3-97b7-e6c5f95b7b51', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'compliance', 'Zurich Real Estate Insurance NTP (01.23) ZCYP895.02.pdf', 'compliance/Zurich Real Estate Insurance NTP (01.23) ZCYP895.02.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('a9ad9dbe-31eb-48f5-b99e-77e83d4764f8', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'finance', 'StG_Invoice_32-34 Connaught Square W2 2HL.pdf', 'finance/StG_Invoice_32-34 Connaught Square W2 2HL.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('dbe4cc98-2ea0-4cf8-b246-7ee705081250', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'compliance', 'StG_Certificate_32-34 Connaught Square W2 2HL.pdf', 'compliance/StG_Certificate_32-34 Connaught Square W2 2HL.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('41b6aef8-ca03-4b84-ae13-9fa736bfa867', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'compliance', 'StG_Supporting Docs_32-34 Connaught Square W2 2HL.pdf', 'compliance/StG_Supporting Docs_32-34 Connaught Square W2 2HL.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('a0d68e96-c811-4a27-89e1-ad59befbc416', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'finance', 'StG_Invoice_32-34 Connaught Square W2 2HL.pdf', 'finance/StG_Invoice_32-34 Connaught Square W2 2HL.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('656db523-332b-4b89-a653-31227ce6c0a1', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'compliance', 'StG_Certificate_32-34 Connaught Square W2 2HL.pdf', 'compliance/StG_Certificate_32-34 Connaught Square W2 2HL.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('12dfa8ed-7a0d-42f8-ac53-c55823a3a577', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'compliance', 'StG_Statement of Fact_32-34 Connaught Square W2 2HL.pdf', 'compliance/StG_Statement of Fact_32-34 Connaught Square W2 2HL.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('b696fa6b-d6b8-4ac6-ad66-8db00425dc39', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'finance', 'StG_Invoice_32-34 Connaught Square W2 2HL.pdf', 'finance/StG_Invoice_32-34 Connaught Square W2 2HL.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('402a768e-6723-4428-944e-a6ef36018277', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'compliance', 'StG_Statement of Fact_32-34 Connaught Square W2 2HL.pdf', 'compliance/StG_Statement of Fact_32-34 Connaught Square W2 2HL.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('284061bf-68de-4ca9-a592-4957ff0ca8e9', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'uncategorised', 'Connaught Square New property information.xlsx', 'uncategorised/Connaught Square New property information.xlsx');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('886d6f56-b74f-44c5-af49-82a2f51f29a8', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'uncategorised', 'Connaught Square Meeting Minutes 2.docx', 'uncategorised/Connaught Square Meeting Minutes 2.docx');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('de31905b-e6b1-4b84-94fc-e43007231aaa', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'uncategorised', 'matrix - pp.xlsx', 'uncategorised/matrix - pp.xlsx');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('a759a058-3088-4478-94b6-d67b948b4403', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'uncategorised', '12. Change of Tenancy - EDF supporting document.docx', 'uncategorised/12. Change of Tenancy - EDF supporting document.docx');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('15907c26-03a0-49c8-94c8-c3dbb011cd14', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'correspondence', 'Correspondence letter.pdf', 'correspondence/Correspondence letter.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('82651d85-ca15-4888-bb23-1edd64b7d4e3', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'uncategorised', 'tenant list - pp.xlsx', 'uncategorised/tenant list - pp.xlsx');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('52a1c346-a59b-467e-88e6-cf1f6ddc2a8f', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'uncategorised', 'Report - 32-34 Connaught Square BCH 78350.pdf', 'uncategorised/Report - 32-34 Connaught Square BCH 78350.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('ea0fdc57-5d42-4dcb-a5d0-10710cb1302a', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'uncategorised', 'Connaught Square Meeting Minutes 2.docx', 'uncategorised/Connaught Square Meeting Minutes 2.docx');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('a364c2e8-b65f-4f01-8c88-58d2b0bb7884', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'uncategorised', 'Connaught Square Meeting Minutes 20241120.docx', 'uncategorised/Connaught Square Meeting Minutes 20241120.docx');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('3db60420-eb1a-471d-b0f3-22c16aefa7a2', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'uncategorised', 'Connaught Square Meeting Minutes.docx', 'uncategorised/Connaught Square Meeting Minutes.docx');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('26985461-0981-43d5-906a-532a3ba4e598', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'uncategorised', 'Connaught Square Admin Duties of Co Sec.docx', 'uncategorised/Connaught Square Admin Duties of Co Sec.docx');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('cd12ef5c-da8b-4aa3-9a01-6fd601f7a318', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'uncategorised', 'Signed Connaught Square Admin Duties of Co Sec.pdf', 'uncategorised/Signed Connaught Square Admin Duties of Co Sec.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('c797f478-e679-4f1b-9fb7-030c9be3ac94', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'uncategorised', '32_34 CONNAUGHT SQUARE FREEHOLD LIMITED - Statutory Registers on 22.03.2024.pdf', 'uncategorised/32_34 CONNAUGHT SQUARE FREEHOLD LIMITED - Statutory Registers on 22.03.2024.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('807f0aca-90e8-42c1-bc8e-60b0796aa11c', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'correspondence', 'Memorandum of Association.pdf', 'correspondence/Memorandum of Association.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('bd42fe43-6c1a-4e5d-a482-23b06389308a', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'uncategorised', 'Incorporation documents.pdf', 'uncategorised/Incorporation documents.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('346ea81c-f068-4912-abc5-7abed8138516', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'uncategorised', 'B25676 RS 21.05.24 RM CM.pdf', 'uncategorised/B25676 RS 21.05.24 RM CM.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('dd78e3ae-ce99-41b4-952c-a49a1dfecd3c', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'uncategorised', 'Report-20.08.2024.pdf', 'uncategorised/Report-20.08.2024.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('bf2780b5-a03b-4a86-a9a6-b9f378f6261f', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'correspondence', 'PN0119V1.7 Privacy Notice (Website).pdf', 'correspondence/PN0119V1.7 Privacy Notice (Website).pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('307e2ebb-81f5-4e3d-9805-d31f75476566', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'correspondence', 'PN0119V1.8 Privacy Notice (Website).pdf', 'correspondence/PN0119V1.8 Privacy Notice (Website).pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('b2603f02-1bb2-4e3d-861c-748c407abe6d', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'uncategorised', 'REPORT 31-07-25.pdf', 'uncategorised/REPORT 31-07-25.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('837df40f-b1b2-4003-8eb6-42b9c74d1d51', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'uncategorised', '32-34 Connought Square Condtion Assessments.pdf', 'uncategorised/32-34 Connought Square Condtion Assessments.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('519cbc68-eef6-42cc-a956-cf16ec548a7a', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'uncategorised', 'Signed Conract.pdf', 'uncategorised/Signed Conract.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('c9eabc14-d7a9-46a4-b322-959b4ebc8034', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'uncategorised', 'BLENHEIMS, CONNAUGHT, W2 2HL PHOTO - 22.01.24.pdf', 'uncategorised/BLENHEIMS, CONNAUGHT, W2 2HL PHOTO - 22.01.24.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('bc9213f8-ddb2-415f-a9e9-d9558dd2b69e', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'uncategorised', 'BLENHEIMS, CONNAUGHT, W2 2HL PHOTO - 22.03.24.pdf', 'uncategorised/BLENHEIMS, CONNAUGHT, W2 2HL PHOTO - 22.03.24.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('87fddbc0-b32b-4ebf-9cfe-a5b056ab0955', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'uncategorised', 'Latest Report.pdf', 'uncategorised/Latest Report.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('8fce0152-ccb7-4a6c-be0f-74e8dd2cf231', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'uncategorised', 'Latest Report 24.04.2024.pdf', 'uncategorised/Latest Report 24.04.2024.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('6a0ffc8d-acd1-40fe-9bd5-ef7895c7e5c5', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'uncategorised', 'Latest Report 19.09.2024.pdf', 'uncategorised/Latest Report 19.09.2024.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('51a6509c-bd61-43c1-8fa3-d96a77619864', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'uncategorised', 'BLENHEIMS, 32-34 CONNAUGHT, W2 2HL - 25.09.23.pdf', 'uncategorised/BLENHEIMS, 32-34 CONNAUGHT, W2 2HL - 25.09.23.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('cca1e3ec-b5d8-42f6-8c3f-f701d5d8d97e', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'uncategorised', 'BLENHEIMS, 32-34 CONNAUGHT, W2 2HL PHOTO - 29.11.23.pdf', 'uncategorised/BLENHEIMS, 32-34 CONNAUGHT, W2 2HL PHOTO - 29.11.23.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('6f7c5fd3-9215-4a8b-89df-15aecd365acf', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'uncategorised', 'BLENHEIMS, 32-34 CONNAUGHT, W2 2HL PHOTO - 18.12.23.pdf', 'uncategorised/BLENHEIMS, 32-34 CONNAUGHT, W2 2HL PHOTO - 18.12.23.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('5f66ab50-9eba-4e7c-9c65-83352654942b', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'uncategorised', 'BLENHEIMS, CONNAUGHT, W2 2HL PHOTO - 23.02.24.pdf', 'uncategorised/BLENHEIMS, CONNAUGHT, W2 2HL PHOTO - 23.02.24.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('e0aa049c-8b31-4277-ae76-3eea537db644', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'uncategorised', '10.02.25-Pest Control.pdf', 'uncategorised/10.02.25-Pest Control.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('12a5c9ca-f9c7-4776-847d-cbacd158dbbd', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'uncategorised', 'Latest Report.pdf', 'uncategorised/Latest Report.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('1cc64a37-48af-4e29-a6f4-0defbef4ceb7', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'uncategorised', '17.01.2025-Pest Control.pdf', 'uncategorised/17.01.2025-Pest Control.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('aec0f240-7ede-4af7-91da-a8fcba5c6e19', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'uncategorised', 'J18503 - MIH, CONNAUGHT SQR, W2 - 04.04.25.pdf', 'uncategorised/J18503 - MIH, CONNAUGHT SQR, W2 - 04.04.25.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('8c48c209-a6ac-45fa-b706-5d68b1db1fee', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'uncategorised', 'J18502 - MIH, CONNAUGHT SQR, W2 - 04.04.25.pdf', 'uncategorised/J18502 - MIH, CONNAUGHT SQR, W2 - 04.04.25.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('6b91af52-be91-4de5-989d-08135b078969', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'uncategorised', 'BLENHEIMS, CONNAUGHT, W2 2HL PHOTO - 22.01.24.pdf', 'uncategorised/BLENHEIMS, CONNAUGHT, W2 2HL PHOTO - 22.01.24.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('987f1a70-0ed4-416c-b338-8de686767597', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'uncategorised', 'BLENHEIMS, CONNAUGHT, W2 2HL PHOTO - 22.03.24.pdf', 'uncategorised/BLENHEIMS, CONNAUGHT, W2 2HL PHOTO - 22.03.24.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('ad1fce4a-2878-494b-8d91-339e56a00d29', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'uncategorised', 'BLENHEIMS, 32-34 CONNAUGHT, W2 2HL - 25.09.23.pdf', 'uncategorised/BLENHEIMS, 32-34 CONNAUGHT, W2 2HL - 25.09.23.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('521b337b-9d72-4ce4-9c6d-09ac24f6253b', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'uncategorised', 'BLENHEIMS, 32-34 CONNAUGHT, W2 2HL PHOTO - 29.11.23.pdf', 'uncategorised/BLENHEIMS, 32-34 CONNAUGHT, W2 2HL PHOTO - 29.11.23.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('05a73090-39ee-4b8a-9544-002d491a7a9d', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'uncategorised', 'BLENHEIMS, 32-34 CONNAUGHT, W2 2HL PHOTO - 18.12.23.pdf', 'uncategorised/BLENHEIMS, 32-34 CONNAUGHT, W2 2HL PHOTO - 18.12.23.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('317d6fb4-a43f-4c54-b054-28df444e7739', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'uncategorised', 'BLENHEIMS, CONNAUGHT, W2 2HL PHOTO - 23.02.24.pdf', 'uncategorised/BLENHEIMS, CONNAUGHT, W2 2HL PHOTO - 23.02.24.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('ca37571a-551f-4266-8701-4a8e663cce25', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'uncategorised', 'INV 11546 Mr Martin Samworth.xlsx', 'uncategorised/INV 11546 Mr Martin Samworth.xlsx');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('eb3b71ad-423b-4c43-80e0-b39f62512212', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'uncategorised', 'QB4126 Mr Martin Samworth.docx', 'uncategorised/QB4126 Mr Martin Samworth.docx');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('d1487c18-7902-447e-b428-e08984b72c0d', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'uncategorised', 'CQ2879 Mr Martin Samworth   (IP) CCTV.docx', 'uncategorised/CQ2879 Mr Martin Samworth   (IP) CCTV.docx');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('4e7136c8-f65e-498e-977e-88626ee97ccd', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'uncategorised', 'Asset_Record_For_Job_No_32810_17-03-2025_1311.pdf', 'uncategorised/Asset_Record_For_Job_No_32810_17-03-2025_1311.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('644b03ff-248a-4638-a58a-ac8951f179c1', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'uncategorised', 'Asset_Record_For_Job_No_32344_12-03-2025_1426.pdf', 'uncategorised/Asset_Record_For_Job_No_32344_12-03-2025_1426.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('00a2f2c5-72b2-474b-b2d1-3801141fa5ea', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'uncategorised', 'Asset_Record_For_Job_No_37675_25-07-2025_1549.pdf', 'uncategorised/Asset_Record_For_Job_No_37675_25-07-2025_1549.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('e7a7e742-c3ca-4788-91c2-87845697f3df', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'uncategorised', 'Asset_Record_For_Job_No_34012_01-05-2025_1616.pdf', 'uncategorised/Asset_Record_For_Job_No_34012_01-05-2025_1616.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('d3f3606e-fa73-40b0-abfe-699b63e4bf5d', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'uncategorised', 'Asset_Record_For_Job_No_32759_17-03-2025_1147.pdf', 'uncategorised/Asset_Record_For_Job_No_32759_17-03-2025_1147.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('ae73db73-d6a6-443b-acac-acce0e525b56', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'uncategorised', 'Jobcard_For_Job_No_32344_12-03-2025_1426.pdf', 'uncategorised/Jobcard_For_Job_No_32344_12-03-2025_1426.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('0759a77a-463c-4d68-acde-a3d768f6c567', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'uncategorised', 'Asset_Record_For_Job_No_33844_07-04-2025_1143.pdf', 'uncategorised/Asset_Record_For_Job_No_33844_07-04-2025_1143.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('5eab9675-44c9-4532-bf6d-e2468eefe453', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'uncategorised', 'Asset_Record_For_Job_No_25732_03-10-2024_1337.pdf', 'uncategorised/Asset_Record_For_Job_No_25732_03-10-2024_1337.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('f3ffebc4-cf15-4237-9e69-0bf141a554ff', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'uncategorised', 'Asset_Record_For_Job_No_22634_03-07-2024_1650.pdf', 'uncategorised/Asset_Record_For_Job_No_22634_03-07-2024_1650.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('e8b17f47-98f4-4b77-8903-e0766d34613b', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'uncategorised', 'Asset_Record_For_Job_No_27067_07-10-2024_1147.pdf', 'uncategorised/Asset_Record_For_Job_No_27067_07-10-2024_1147.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('f943aeaa-bb6a-4d06-9273-7d355636aa63', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'uncategorised', 'Asset_Record_For_Job_No_19665_05-04-2024_1048.pdf', 'uncategorised/Asset_Record_For_Job_No_19665_05-04-2024_1048.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('9d037c1d-7282-4503-bb6e-4a71843f0c0a', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'contracts', 'Connaught Square-Lift Quotes.xlsx', 'contracts/Connaught Square-Lift Quotes.xlsx');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('4cd6204b-ee9c-4360-9b43-0ac7dd3b2e4f', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'uncategorised', 'LXBI3559280XB2-NEW STEP-Business-Certificate of el insurance.pdf', 'uncategorised/LXBI3559280XB2-NEW STEP-Business-Certificate of el insurance.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('1f956371-39bb-4d8d-b6d6-bfc355696832', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'uncategorised', 'New Step - Cleaning of Com Part- Jan- 2023.pdf', 'uncategorised/New Step - Cleaning of Com Part- Jan- 2023.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('a965eec6-99c1-4912-97ff-8d980d55ea5d', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'uncategorised', 'Aged debtors by property.pdf', 'uncategorised/Aged debtors by property.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('dc9434a9-c082-4dca-ac13-06b2e776f9ab', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'uncategorised', 'Connaught Square, 32-34 Approved xlsx.xlsx', 'uncategorised/Connaught Square, 32-34 Approved xlsx.xlsx');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('8a66773b-d451-4d87-bba0-f2af72d5c332', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'uncategorised', 'BvA 24 Jan 25.xlsx', 'uncategorised/BvA 24 Jan 25.xlsx');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('34899e76-4555-41ce-b0cd-06de1ebf92ca', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'uncategorised', 'pdf.pdf', 'uncategorised/pdf.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('f12ca869-ca41-411a-ad22-c441d4002515', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'uncategorised', 'Connaught Square-Agenda 20.11.24.docx', 'uncategorised/Connaught Square-Agenda 20.11.24.docx');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('5ddbf703-05af-4c76-b4f8-e10a10b92d3b', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'uncategorised', 'Connaught Square-Agenda 26.04.2024.docx', 'uncategorised/Connaught Square-Agenda 26.04.2024.docx');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('f966b3f5-ac9a-422a-8c2e-69c86c7b5c63', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'uncategorised', 'Connaught Square 26.04.24.docx', 'uncategorised/Connaught Square 26.04.24.docx');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('ebe54c4f-d6c3-4266-a1ef-2395733c10af', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'contracts', 'StG_Quote_32-34 Connaught Square W2 2HL.pdf', 'contracts/StG_Quote_32-34 Connaught Square W2 2HL.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('2ce583fb-d0b6-4362-9c4a-b6b7c25959eb', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'uncategorised', 'StG_Policy Wording_32-34 Connaught Square W2 2HL.pdf', 'uncategorised/StG_Policy Wording_32-34 Connaught Square W2 2HL.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('d92ae46d-135e-4d8d-9b20-fdda39e1f970', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'contracts', 'StG_Quote_32-34 Connaught Square W2 2HL.pdf', 'contracts/StG_Quote_32-34 Connaught Square W2 2HL.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('2d49dda4-b619-4c7b-b039-41b52279c370', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'uncategorised', 'StG_Policy Wording_32-34 Connaught Square W2 2HL.pdf', 'uncategorised/StG_Policy Wording_32-34 Connaught Square W2 2HL.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('8b01374e-3a48-4250-88dd-b1ae8873e0e1', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'uncategorised', 'Report - 32-34 Connaught Square BCH 78350.pdf', 'uncategorised/Report - 32-34 Connaught Square BCH 78350.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('a0b499da-2e9f-4714-914f-00bf83f1d0e2', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'uncategorised', 'Asset_Record_For_Job_No_16617_27-11-2023_1522.pdf', 'uncategorised/Asset_Record_For_Job_No_16617_27-11-2023_1522.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('4593f0df-d8c2-4e50-82a6-2c963d4020a8', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'uncategorised', 'Asset_Record_For_Job_No_16808_28-11-2023_1340.pdf', 'uncategorised/Asset_Record_For_Job_No_16808_28-11-2023_1340.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('39f553d1-e6ca-42d3-b661-cefa73a07185', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'uncategorised', 'EX-NC (CONNAUGHT SQUARE) EXTRA 01102024.pdf', 'uncategorised/EX-NC (CONNAUGHT SQUARE) EXTRA 01102024.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('74a0b01f-96e5-49c2-b2c7-62fc9584bb0d', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'uncategorised', 'H&S recomendations - Spreadsheet with comments.xlsx', 'uncategorised/H&S recomendations - Spreadsheet with comments.xlsx');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('8f011602-2358-426c-8943-91e127f1c907', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'uncategorised', 'CM434 RS 32-34 Connaught Square - VISIT 1 OF 2 - 30-04-25.pdf', 'uncategorised/CM434 RS 32-34 Connaught Square - VISIT 1 OF 2 - 30-04-25.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('2dbf489a-fce0-4d22-bc1a-becabb27856f', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'uncategorised', 'Q49511 - 32-34 Connaught Square.pdf', 'uncategorised/Q49511 - 32-34 Connaught Square.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('791b5431-642f-4d9b-9c62-af0458661f7c', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'uncategorised', 'FA7817 CALL OUT 26032025.pdf', 'uncategorised/FA7817 CALL OUT 26032025.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('5d1e66ce-8737-464e-8774-059f06bb2517', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'uncategorised', '32 Connaught Sq - PAT .pdf', 'uncategorised/32 Connaught Sq - PAT .pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('44740649-3518-4b82-b7e0-81c40e5f98d6', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'uncategorised', 'Asset_Record_For_Job_No_35146_03-06-2025_0906.pdf', 'uncategorised/Asset_Record_For_Job_No_35146_03-06-2025_0906.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('c2008d33-4aec-48f8-963d-72690bc9fcb6', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'uncategorised', 'Asset_Record_For_Job_No_31162_30-01-2025_1603.pdf', 'uncategorised/Asset_Record_For_Job_No_31162_30-01-2025_1603.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('7b4ec3f2-7538-4122-9c0b-6e1380761bf8', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'uncategorised', 'Asset_Record_For_Job_No_37675_25-07-2025_1549.pdf', 'uncategorised/Asset_Record_For_Job_No_37675_25-07-2025_1549.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('d6e5db9e-67cc-4942-8f3e-e896e2a1183f', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'uncategorised', 'Asset_Record_For_Job_No_28737_25-11-2024_0907.pdf', 'uncategorised/Asset_Record_For_Job_No_28737_25-11-2024_0907.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('99b88566-ac6c-488f-ae4e-9f98d989d08c', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'uncategorised', 'Asset_Record_For_Job_No_35402_03-06-2025_0916.pdf', 'uncategorised/Asset_Record_For_Job_No_35402_03-06-2025_0916.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('393aaf99-43bc-490a-8a7f-32c3a60a4b08', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'uncategorised', 'Asset_Record_For_Job_No_22171_14-05-2024_1202.pdf', 'uncategorised/Asset_Record_For_Job_No_22171_14-05-2024_1202.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('ad752fac-757c-4d5e-ae19-4449722b8ca8', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'uncategorised', 'Asset_Record_For_Job_No_35654_03-06-2025_0912.pdf', 'uncategorised/Asset_Record_For_Job_No_35654_03-06-2025_0912.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('0b995674-98d2-4afc-b817-eb0a90d32f06', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'uncategorised', 'Asset_Record_For_Job_No_38609_26-08-2025_0740.pdf', 'uncategorised/Asset_Record_For_Job_No_38609_26-08-2025_0740.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('e2ab3f28-43e7-4b64-8df3-7d6f76b37467', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'uncategorised', 'Asset_Record_For_Job_No_36465_20-06-2025_1038.pdf', 'uncategorised/Asset_Record_For_Job_No_36465_20-06-2025_1038.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('2e5171a9-73be-4fe5-b807-e78ade8f01d9', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'uncategorised', '26368 Report.pdf', 'uncategorised/26368 Report.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('43c15f19-5080-495b-9f81-b67c623dade4', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'uncategorised', '26474 Report.pdf', 'uncategorised/26474 Report.pdf');

-- Insert 26 apportionments
INSERT INTO apportionments (id, building_id, percentage) VALUES ('c074dcd8-c497-4af9-841d-7ff6ea5c348a', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 32.0);
INSERT INTO apportionments (id, building_id, percentage) VALUES ('f83d71ab-3fec-4f39-b1dc-32da054ffa1e', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 10.0);
INSERT INTO apportionments (id, building_id, percentage) VALUES ('e8050bf0-9d85-4fff-846b-4df400ad5e99', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 32.0);
INSERT INTO apportionments (id, building_id, percentage) VALUES ('380bc57b-759a-4876-8864-ec68df907bd4', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 19.0);
INSERT INTO apportionments (id, building_id, percentage) VALUES ('4b2326a9-9f97-4ea5-8e74-5e75e5f7e9c3', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 2.0);
INSERT INTO apportionments (id, building_id, percentage) VALUES ('38d93661-4bd9-4365-afa2-d26a3da504d9', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 2.0);
INSERT INTO apportionments (id, building_id, percentage) VALUES ('2543b225-3ee8-4b4c-9bed-e6a82eeda123', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 2.0);
INSERT INTO apportionments (id, building_id, percentage) VALUES ('7b5fe36d-d60e-4d70-83e6-56ce03d825e2', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 2.0);
INSERT INTO apportionments (id, building_id, percentage) VALUES ('540b4a42-d72e-4676-8bd3-93a0c8449203', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 2.0);
INSERT INTO apportionments (id, building_id, percentage) VALUES ('a0592705-43e0-4e8b-8de1-0ee32213f836', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 8.0);
INSERT INTO apportionments (id, building_id, percentage) VALUES ('a41c25a9-5ab9-4cc3-88a4-0a3ab863b2fc', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 3.0);
INSERT INTO apportionments (id, building_id, percentage) VALUES ('94eb2450-d24b-40c9-ba11-1ac8ed935b4e', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 3.0);
INSERT INTO apportionments (id, building_id, percentage) VALUES ('74a719cc-227f-4933-a498-1a35539a4bc1', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 3.0);
INSERT INTO apportionments (id, building_id, percentage) VALUES ('ea202c6e-dddb-4bef-99fb-dc76f0f59bf2', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 3.0);
INSERT INTO apportionments (id, building_id, percentage) VALUES ('3dca3c7f-88fe-41a4-82a9-bed149623904', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 3.0);
INSERT INTO apportionments (id, building_id, percentage) VALUES ('cb9fab7a-2f20-479c-b996-9567075443dc', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 3.0);
INSERT INTO apportionments (id, building_id, percentage) VALUES ('e5d2f7f5-1b0a-4cba-b3b9-c8e961d9d543', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 3.0);
INSERT INTO apportionments (id, building_id, percentage) VALUES ('3bf50cf8-d6a6-4767-a498-03607340cc3b', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 3.0);
INSERT INTO apportionments (id, building_id, percentage) VALUES ('1cc0b7b1-59d9-45d4-8da5-f848346cd3af', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 8.0);
INSERT INTO apportionments (id, building_id, percentage) VALUES ('3f6a1c06-a0a9-4420-9714-c65433705963', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 3.0);
INSERT INTO apportionments (id, building_id, percentage) VALUES ('322da307-6447-4064-a95e-5ada8eeea716', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 8.0);
INSERT INTO apportionments (id, building_id, percentage) VALUES ('91d625f7-666a-44b6-9226-10450d9808dc', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 8.0);
INSERT INTO apportionments (id, building_id, percentage) VALUES ('ee8f290b-53a8-41b7-bfb9-7df528d58dda', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 8.0);
INSERT INTO apportionments (id, building_id, percentage) VALUES ('1d46e446-c72f-4922-ae67-b7b6da51a3c1', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 8.0);
INSERT INTO apportionments (id, building_id, percentage) VALUES ('4243a62d-2a47-4e2f-ab92-c4d2a54ed918', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 8.0);
INSERT INTO apportionments (id, building_id, percentage) VALUES ('c03c2abd-1930-40c8-90da-a007eb34c25f', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 8.0);

-- Insert 152 insurance records
INSERT INTO building_insurance (id, building_id, policy_number) VALUES ('368a23f2-dfb1-4f7e-ad8a-0282d6fe887e', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'CGBI3964546XB');
INSERT INTO building_insurance (id, building_id, policy_number) VALUES ('93ef4d39-7ff5-4fc3-a9f0-311979dbe805', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'CGBI3964546XB');
INSERT INTO building_insurance (id, building_id) VALUES ('f4301dd5-13a3-4026-b708-34a46760d0ba', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8');
INSERT INTO building_insurance (id, building_id) VALUES ('4b21316a-9ee8-4f43-a36e-a21aa37f8254', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8');
INSERT INTO building_insurance (id, building_id) VALUES ('fcae3503-b7bc-4b44-8b3f-8d2dd2bbcb8a', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8');
INSERT INTO building_insurance (id, building_id, policy_number) VALUES ('c8c91ed9-957b-418f-b1c8-31e64bea639a', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'and');
INSERT INTO building_insurance (id, building_id) VALUES ('02601dcd-67e7-435b-9ba5-56dc424720a8', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8');
INSERT INTO building_insurance (id, building_id) VALUES ('39ae976b-98b1-4a61-8726-2523b39c0186', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8');
INSERT INTO building_insurance (id, building_id) VALUES ('0092b1d2-cc5e-4fc2-9552-c15ed7628f47', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8');
INSERT INTO building_insurance (id, building_id, policy_number) VALUES ('f9e25cb6-8222-44ff-9099-9fa364d5fefc', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'NZ23346712');
INSERT INTO building_insurance (id, building_id) VALUES ('f495908f-ee1a-44f1-bc53-b3f8e3d32cdb', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8');
INSERT INTO building_insurance (id, building_id) VALUES ('1b2e498d-803e-4e63-8e7f-75dfa45e7a24', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8');
INSERT INTO building_insurance (id, building_id) VALUES ('1522b72c-d80b-4c20-beb3-78e8b9c427d1', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8');
INSERT INTO building_insurance (id, building_id) VALUES ('aec968a0-d825-4f5d-8287-8f0bb683d34d', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8');
INSERT INTO building_insurance (id, building_id) VALUES ('9a6e17a5-f571-463d-983b-8cc3bbbad24d', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8');
INSERT INTO building_insurance (id, building_id, policy_number) VALUES ('6e60f803-c2ea-4af2-8650-d03015d8ff5c', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'ARCH');
INSERT INTO building_insurance (id, building_id) VALUES ('f61e126c-188c-4e35-b599-4742c1267378', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8');
INSERT INTO building_insurance (id, building_id) VALUES ('76914784-6736-4d7d-ad66-7fba2ac7562f', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8');
INSERT INTO building_insurance (id, building_id) VALUES ('b8b2694d-6c46-4e68-aa9a-2ce2a6eb69e2', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8');
INSERT INTO building_insurance (id, building_id) VALUES ('6a74bbc5-4a19-445c-851e-63b418fc9df0', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8');
INSERT INTO building_insurance (id, building_id, policy_number) VALUES ('be6ebda7-c088-4f39-8f64-116a25e7a5db', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'FU117816');
INSERT INTO building_insurance (id, building_id, policy_number) VALUES ('ce77ade6-e31d-4813-943a-b8bdd9681e5f', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'FU117816');
INSERT INTO building_insurance (id, building_id) VALUES ('0309b34a-b888-4373-8390-f19072077609', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8');
INSERT INTO building_insurance (id, building_id) VALUES ('eb4f37f8-e63c-48dd-813c-ccf2b409d63b', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8');
INSERT INTO building_insurance (id, building_id) VALUES ('bf119dbf-204c-4a79-b62f-e36ad6600907', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8');
INSERT INTO building_insurance (id, building_id) VALUES ('9dff770f-111e-4295-a839-c52fa9268d11', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8');
INSERT INTO building_insurance (id, building_id) VALUES ('3be810bb-9676-4f67-8628-204627f4c073', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8');
INSERT INTO building_insurance (id, building_id) VALUES ('655ab39d-72b0-4828-b4ef-6a078cb33551', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8');
INSERT INTO building_insurance (id, building_id) VALUES ('41f2572e-5d95-4443-a167-0d961384e66d', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8');
INSERT INTO building_insurance (id, building_id) VALUES ('e3c5691c-c767-48a8-a72a-3a81825cfc91', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8');
INSERT INTO building_insurance (id, building_id) VALUES ('a73a07bb-df24-4d09-9933-12361fd78ac4', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8');
INSERT INTO building_insurance (id, building_id) VALUES ('33d4d5ce-a316-4bab-ae28-13310a6498bd', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8');
INSERT INTO building_insurance (id, building_id) VALUES ('e3548302-8047-443d-b002-0c316d7d7f1e', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8');
INSERT INTO building_insurance (id, building_id) VALUES ('1fe055ee-8755-486e-ab83-2d343d339010', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8');
INSERT INTO building_insurance (id, building_id) VALUES ('56e91e1b-b995-46d8-abc1-2eef8395b0a0', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8');
INSERT INTO building_insurance (id, building_id) VALUES ('28aba32c-d4eb-49f8-b795-73d99d93b5a8', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8');
INSERT INTO building_insurance (id, building_id) VALUES ('0e91406b-754e-4ec3-b8a0-25589c93a477', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8');
INSERT INTO building_insurance (id, building_id) VALUES ('f8828f69-34a5-4520-b510-f39717774e6f', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8');
INSERT INTO building_insurance (id, building_id) VALUES ('a2d0cecf-f42c-4d0b-a36a-e5e0a7ec06bd', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8');
INSERT INTO building_insurance (id, building_id) VALUES ('b639c05d-189c-4586-8b12-56f274c1bb96', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8');
INSERT INTO building_insurance (id, building_id) VALUES ('e1561162-b2cb-463f-82ae-6f766bb99b6f', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8');
INSERT INTO building_insurance (id, building_id) VALUES ('19d203ea-77e0-440b-a91e-3189430b3f72', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8');
INSERT INTO building_insurance (id, building_id) VALUES ('52d9a2b6-a397-4423-b723-343c84c3fbc8', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8');
INSERT INTO building_insurance (id, building_id) VALUES ('96168aaf-9da6-4c2b-90a2-857deeb640aa', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8');
INSERT INTO building_insurance (id, building_id) VALUES ('8b7aa866-3de7-4d0b-839d-2b078e2a7483', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8');
INSERT INTO building_insurance (id, building_id) VALUES ('fb94fa83-57c8-45bf-b385-3fff717264fd', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8');
INSERT INTO building_insurance (id, building_id) VALUES ('a07495de-ec95-4221-9d8e-064de074ce42', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8');
INSERT INTO building_insurance (id, building_id) VALUES ('d5a24939-eda0-41aa-a101-8ba76a1d76a9', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8');
INSERT INTO building_insurance (id, building_id) VALUES ('4d365270-d3e5-421b-85c7-2a0a2d4dff31', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8');
INSERT INTO building_insurance (id, building_id) VALUES ('16fc429f-621d-44a3-8c77-f1a263c56248', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8');
INSERT INTO building_insurance (id, building_id) VALUES ('70361aa4-bbfe-48f5-8a61-17e9492912a7', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8');
INSERT INTO building_insurance (id, building_id) VALUES ('949c535b-df35-4647-bb78-74dc3eca3e3e', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8');
INSERT INTO building_insurance (id, building_id) VALUES ('af3e8467-d074-4381-83b1-fe8fe7369178', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8');
INSERT INTO building_insurance (id, building_id) VALUES ('22d5c2d3-ee43-4b82-ba41-d7306b80526e', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8');
INSERT INTO building_insurance (id, building_id) VALUES ('02ee299d-f68b-4841-bff2-cdfd3032b271', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8');
INSERT INTO building_insurance (id, building_id, policy_number) VALUES ('5779c8ae-bcd3-4e6b-84c3-4cf6bd81bda1', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'LXBI3559280XB');
INSERT INTO building_insurance (id, building_id, policy_number) VALUES ('6d326acd-a636-45b5-9f99-dd5ad6ee0d67', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'LXBI3559280XB');
INSERT INTO building_insurance (id, building_id) VALUES ('ca4c734e-a994-42fa-9e15-35aa74e965f0', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8');
INSERT INTO building_insurance (id, building_id) VALUES ('af124d23-7d41-4a27-9cc0-fe2831973745', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8');
INSERT INTO building_insurance (id, building_id) VALUES ('d5e95e80-d260-4d48-ae1e-eb487e229026', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8');
INSERT INTO building_insurance (id, building_id) VALUES ('d15a933d-6d78-401a-991a-7bff94d59843', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8');
INSERT INTO building_insurance (id, building_id) VALUES ('87d35f9d-6857-44c7-91cd-7ee8cf328321', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8');
INSERT INTO building_insurance (id, building_id) VALUES ('35555c31-a0a1-4005-a737-8c71c8edd60b', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8');
INSERT INTO building_insurance (id, building_id) VALUES ('e62fa362-1a01-4241-9848-4bf389d94d1c', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8');
INSERT INTO building_insurance (id, building_id) VALUES ('b1a144c7-2277-41e0-9937-18de7247919a', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8');
INSERT INTO building_insurance (id, building_id) VALUES ('9aece419-bfc5-47ef-befd-1439b653ed97', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8');
INSERT INTO building_insurance (id, building_id) VALUES ('1d21e1cf-3728-4a61-8149-99cc24d97194', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8');
INSERT INTO building_insurance (id, building_id, policy_number) VALUES ('c52fc241-3b2c-44f0-ae16-12c552bb0678', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'NZ23346712');
INSERT INTO building_insurance (id, building_id) VALUES ('3a3a6754-52e6-49a7-9e02-616020213088', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8');
INSERT INTO building_insurance (id, building_id, policy_number) VALUES ('a6afc3b1-ab05-49e6-b4e1-f0ecc04caf2b', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'and');
INSERT INTO building_insurance (id, building_id) VALUES ('b2946630-32fd-49bd-bca6-dea41500988c', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8');
INSERT INTO building_insurance (id, building_id) VALUES ('6365e07f-2bf5-4053-85d1-38f507355293', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8');
INSERT INTO building_insurance (id, building_id) VALUES ('8efd0a5f-573d-4551-b81e-9d286f08d84f', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8');
INSERT INTO building_insurance (id, building_id) VALUES ('c909d376-d9f2-46ce-988e-b3cd6f66a67e', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8');
INSERT INTO building_insurance (id, building_id, policy_number) VALUES ('6126897c-d1d0-41d4-a232-e6fc9fe35921', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'STGLON');
INSERT INTO building_insurance (id, building_id) VALUES ('c2d1e72a-7cb0-460f-bcf3-988279087d66', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8');
INSERT INTO building_insurance (id, building_id) VALUES ('5be6f0de-2b7d-4508-9133-32e8ea090af2', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8');
INSERT INTO building_insurance (id, building_id, policy_number) VALUES ('6c316cb8-a19e-4ad5-9f15-283919450e0e', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'STGLON');
INSERT INTO building_insurance (id, building_id, policy_number) VALUES ('fd973906-4733-476d-abbd-f884cdd8a7ac', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'STGLON');
INSERT INTO building_insurance (id, building_id, policy_number) VALUES ('dd2a40bf-af08-4e7b-aec1-eedafcc2a083', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'BERTSTGLON');
INSERT INTO building_insurance (id, building_id) VALUES ('1d19fc77-1384-4c1b-9b8f-bf27422c7754', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8');
INSERT INTO building_insurance (id, building_id) VALUES ('66a196fe-b8df-45e9-afb6-e2a4f97bd8e3', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8');
INSERT INTO building_insurance (id, building_id, policy_number) VALUES ('2b96daca-107d-484c-a1a2-1354c2f28d0e', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'LP');
INSERT INTO building_insurance (id, building_id, policy_number) VALUES ('b54a93ec-6781-415e-b755-e080239c1df9', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'HL');
INSERT INTO building_insurance (id, building_id, policy_number) VALUES ('608659c5-7fa7-4f6a-abb4-77e7432319e4', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'ARCH');
INSERT INTO building_insurance (id, building_id) VALUES ('3db7d7e0-e0fe-47fa-8455-f11b7067b02b', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8');
INSERT INTO building_insurance (id, building_id, policy_number) VALUES ('abf7e39b-b51e-48ee-b880-69def42e0fc0', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'and');
INSERT INTO building_insurance (id, building_id) VALUES ('278e2dac-1e8b-4e44-bec5-0b6d5f8e5b97', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8');
INSERT INTO building_insurance (id, building_id) VALUES ('191e27a9-7fcf-444b-8acf-02f0eecd755c', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8');
INSERT INTO building_insurance (id, building_id) VALUES ('bd63d3d4-1e0c-44f1-8a05-b681595642b7', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8');
INSERT INTO building_insurance (id, building_id) VALUES ('b129773f-c7ff-4712-bcd8-da1db9363eec', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8');
INSERT INTO building_insurance (id, building_id) VALUES ('0434355e-cf34-4581-9d48-2ed11b78388b', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8');
INSERT INTO building_insurance (id, building_id) VALUES ('86fdb8f3-4231-4eb6-a67d-16f2d15c3ea9', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8');
INSERT INTO building_insurance (id, building_id, policy_number) VALUES ('6460c5f6-f3d4-491d-bdec-f4e8847566cf', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'and');
INSERT INTO building_insurance (id, building_id) VALUES ('c4e2b916-d635-46ff-b9fc-c3a8a21321dc', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8');
INSERT INTO building_insurance (id, building_id) VALUES ('65960f5b-4b15-406f-8d68-c4690a3561ce', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8');
INSERT INTO building_insurance (id, building_id) VALUES ('609af7cd-a2c0-4ef6-8323-99ccc2b83566', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8');
INSERT INTO building_insurance (id, building_id) VALUES ('b1813d7a-0e9b-45bc-b8e4-7793b87d015e', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8');
INSERT INTO building_insurance (id, building_id) VALUES ('7a264372-4ed6-4ca8-bc69-c561ae750d45', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8');
INSERT INTO building_insurance (id, building_id) VALUES ('413ae558-e26b-4175-9522-09a25980bc33', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8');
INSERT INTO building_insurance (id, building_id, policy_number) VALUES ('4099c9ee-c9e3-47c3-ad29-a7ed08917d92', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'and');
INSERT INTO building_insurance (id, building_id) VALUES ('d0965c37-a4fe-44a9-906c-8fae5758ebf9', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8');
INSERT INTO building_insurance (id, building_id, policy_number) VALUES ('72d4041a-7172-4f31-944b-d077ad9fbccb', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'BP13228-2501');
INSERT INTO building_insurance (id, building_id, policy_number) VALUES ('e1e8f980-798c-4de8-bc02-d131185c7c2a', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'BP13228-2501');
INSERT INTO building_insurance (id, building_id) VALUES ('de8f1ca0-99d4-4ea6-ae7a-a9663a684043', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8');
INSERT INTO building_insurance (id, building_id) VALUES ('dffad681-1348-4b77-93b7-1f45fec30093', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8');
INSERT INTO building_insurance (id, building_id, policy_number) VALUES ('74b94230-c660-4d59-bf39-8e92714423c0', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'TA0604600');
INSERT INTO building_insurance (id, building_id) VALUES ('d5f3c421-e223-4afe-bc99-ba1913282203', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8');
INSERT INTO building_insurance (id, building_id) VALUES ('6111302f-9de7-428d-897a-b8c2e571a7d9', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8');
INSERT INTO building_insurance (id, building_id, policy_number) VALUES ('ca37e179-4c94-49bd-a30a-fc3174fc310b', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'HL');
INSERT INTO building_insurance (id, building_id, policy_number) VALUES ('4cc60153-9426-446b-a1d6-180b32b9a572', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'Camberford');
INSERT INTO building_insurance (id, building_id) VALUES ('e612a4a2-d399-4193-8318-1d4d79299a66', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8');
INSERT INTO building_insurance (id, building_id) VALUES ('0e0b4db0-5a1b-44d3-bc42-3df735b4f4fd', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8');
INSERT INTO building_insurance (id, building_id) VALUES ('eb312524-3761-4b57-93fa-2d808a47506e', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8');
INSERT INTO building_insurance (id, building_id) VALUES ('cf582725-e52c-49ad-960a-8dd565d548ca', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8');
INSERT INTO building_insurance (id, building_id) VALUES ('6a8fd040-5199-4529-9899-a5c29466a64a', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8');
INSERT INTO building_insurance (id, building_id) VALUES ('d09908a6-6339-4235-a987-a4b3dd8a5380', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8');
INSERT INTO building_insurance (id, building_id) VALUES ('8a243f99-c553-442c-b56e-e6a87cf03157', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8');
INSERT INTO building_insurance (id, building_id) VALUES ('15132301-38e6-404a-8e62-898377c0290e', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8');
INSERT INTO building_insurance (id, building_id) VALUES ('ac647b7b-63f2-445d-ac42-7ad229405992', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8');
INSERT INTO building_insurance (id, building_id) VALUES ('7ba31814-2d14-4767-8e43-7fa9ac32a496', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8');
INSERT INTO building_insurance (id, building_id) VALUES ('dc7cd024-3a5c-4f5a-b27a-350c68c34537', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8');
INSERT INTO building_insurance (id, building_id) VALUES ('cf532974-5084-4961-b617-0c809103c3ef', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8');
INSERT INTO building_insurance (id, building_id) VALUES ('07e5adba-1dbd-4ede-a050-5b27d19139f6', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8');
INSERT INTO building_insurance (id, building_id) VALUES ('54af230f-4eda-4402-9dc9-e2efb11f8bd1', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8');
INSERT INTO building_insurance (id, building_id) VALUES ('6f23b914-bdc5-4415-91fe-133d3267af38', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8');
INSERT INTO building_insurance (id, building_id) VALUES ('8e883b03-9c50-49c7-acd3-8bfa3f75f037', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8');
INSERT INTO building_insurance (id, building_id) VALUES ('194b8783-b70c-4fdf-82ad-520fe03b2223', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8');
INSERT INTO building_insurance (id, building_id) VALUES ('d181af0f-7f1e-482d-be7f-1317803e069a', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8');
INSERT INTO building_insurance (id, building_id) VALUES ('0a3feb71-c940-4e8e-91a9-50f7f278a78e', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8');
INSERT INTO building_insurance (id, building_id) VALUES ('cfa2cd47-37c2-4d09-8d03-af5e68fbbe1e', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8');
INSERT INTO building_insurance (id, building_id, notes) VALUES ('a352a7e7-9f6a-4ab0-a2c9-4ffd404cf4b3', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'PDF metadata only');
INSERT INTO building_insurance (id, building_id, notes) VALUES ('57876f42-4fc4-48a5-b288-81dede00a58c', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'PDF metadata only');
INSERT INTO building_insurance (id, building_id, notes) VALUES ('73f712fd-a2ed-4f12-8c02-41f30b24bc8a', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'PDF metadata only');
INSERT INTO building_insurance (id, building_id, notes) VALUES ('a3d50c2e-27ef-4130-baf9-11b53a503005', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'PDF metadata only');
INSERT INTO building_insurance (id, building_id, notes) VALUES ('f9a07963-2c02-434a-8245-d42ccef60a59', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'PDF metadata only');
INSERT INTO building_insurance (id, building_id, notes) VALUES ('5f086e78-49b4-48df-a325-0488283f15c2', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'PDF metadata only. Inferred year: 2023');
INSERT INTO building_insurance (id, building_id, notes) VALUES ('3ccb07a8-2709-4511-9bbd-90e5b3cfa91c', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'PDF metadata only');
INSERT INTO building_insurance (id, building_id, notes) VALUES ('9a7b6c31-e7dc-4d35-a819-d49fa99c1715', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'PDF metadata only');
INSERT INTO building_insurance (id, building_id, notes) VALUES ('f273032e-d24d-4f4d-b68e-9c8f4403fb05', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'PDF metadata only');
INSERT INTO building_insurance (id, building_id, notes) VALUES ('08c99b57-7203-4400-aad7-2268e620db05', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'PDF metadata only');
INSERT INTO building_insurance (id, building_id, notes) VALUES ('07d38572-0212-49d5-8be1-b49ca620badd', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'PDF metadata only. Inferred year: 2023');
INSERT INTO building_insurance (id, building_id, notes) VALUES ('b0095398-d788-45f2-b38d-d3369cbd5d19', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'PDF metadata only');
INSERT INTO building_insurance (id, building_id, notes) VALUES ('35741d31-f398-4351-bdd6-0bc2f426c6f6', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'PDF metadata only');
INSERT INTO building_insurance (id, building_id, notes) VALUES ('26480eaa-6a52-4053-a296-957a4ccd54f8', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'PDF metadata only');
INSERT INTO building_insurance (id, building_id, notes) VALUES ('33ac2bb9-4d2c-4e61-bad4-590cf63d08ad', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'PDF metadata only');
INSERT INTO building_insurance (id, building_id, notes) VALUES ('d557269c-a740-4283-9b8b-3986580c66b6', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'PDF metadata only');
INSERT INTO building_insurance (id, building_id, notes) VALUES ('74400f9e-6a74-4248-8918-73be2c2ded99', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'PDF metadata only');
INSERT INTO building_insurance (id, building_id, notes) VALUES ('fd93da2f-e26f-4cb3-b471-dc55c6fa1391', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'PDF metadata only');
INSERT INTO building_insurance (id, building_id, notes) VALUES ('b713d618-0f1c-48e6-9701-71f9a9e7744e', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'PDF metadata only');
INSERT INTO building_insurance (id, building_id, notes) VALUES ('68c00aed-f5d3-4f2f-b57e-a2f264be1f93', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'PDF metadata only');
INSERT INTO building_insurance (id, building_id, notes) VALUES ('2d6db22f-bb32-4e3e-ba61-12b213fa9365', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'PDF metadata only');

-- Insert 4 contractors
INSERT INTO contractors (id, company_name, contact_person, phone, address, accreditations) VALUES ('0c4790db-1717-42eb-8314-ac16c3471be9', 'ISS', 'UK POWER', '083603538855', 'London, We''re available on Live Chat here., W1S 1RS', ARRAY[]);
INSERT INTO contractors (id, company_name, email, phone, address, accreditations) VALUES ('cb587ba1-999c-4099-a49b-783f930b45d6', 'Quotehedge', 'info@quotehedge-heating.co.uk', '07801 799118', '182 Revelstoke Road, Wandsworth, London, SW18 5NW', ARRAY[]);
INSERT INTO contractors (id, company_name, contact_person, email, address, accreditations) VALUES ('a3a1ed20-ae28-4357-8d79-b080784bc4a2', 'WHM', 'Candice Fisher', 'enquiries@whmltd.org', 'WATER HYGIENE MANAGEMENT L TD, 2 Churchill Court, Hortons Way,, Westerham, Kent, TN16 1BT', ARRAY[]);
INSERT INTO contractors (id, company_name, contact_person, email, address, specialization, accreditations) VALUES ('95b246ae-e6cd-4610-819b-ad344594c5f2', 'Capita', 'your insurance', 'DPO@archinsurance.co.uk', 'f Arch Insurance (UK) Limited, Arch Insurance (UK) Limited, 5th Floor, 60 Great Tower Street, London EC3R 5AZ', 'security', ARRAY['chas']);

-- Insert 43 contracts
INSERT INTO contracts (id, building_id, contractor_name, contract_status) VALUES ('4b6b5af3-f498-4b3d-963e-e2d9481e620c', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'ISS', 'active');
INSERT INTO contracts (id, building_id, contractor_name, service_type, frequency, contract_status) VALUES ('6d00ab6b-af55-4b87-ae4e-c5b9d64462cf', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'ISS', 'lifts', 'monthly', 'active');
INSERT INTO contracts (id, building_id, contractor_name, service_type, frequency, contract_status) VALUES ('ad4d8d1d-42dc-4f47-bd46-266634b41e7f', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'ISS', 'security', 'quarterly', 'active');
INSERT INTO contracts (id, building_id, contractor_name, service_type, frequency, contract_status) VALUES ('d06ca3dd-6799-4727-8a25-eb76af98ebeb', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'ISS', 'security', 'quarterly', 'active');
INSERT INTO contracts (id, building_id, contractor_name, service_type, frequency, contract_status) VALUES ('5fd758f3-7b00-454d-a08e-b27b7d49a850', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'ISS', 'lifts', 'monthly', 'active');
INSERT INTO contracts (id, building_id, contractor_name, contract_status) VALUES ('d8cfa13a-8147-4d20-b759-6143a400d2ad', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'Quotehedge', 'active');
INSERT INTO contracts (id, building_id, contractor_name, contract_status) VALUES ('84289254-a92a-4d03-927f-cc358c44ad97', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'Quotehedge', 'active');
INSERT INTO contracts (id, building_id, contractor_name, contract_status) VALUES ('85f3d7d2-d256-4b89-993b-7e27a62c1bf0', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'Quotehedge', 'active');
INSERT INTO contracts (id, building_id, contractor_name, service_type, frequency, contract_status) VALUES ('86c5c539-ef54-4922-8bf7-fde162285bf2', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'ISS', 'lifts', 'monthly', 'active');
INSERT INTO contracts (id, building_id, contractor_name, service_type, frequency, contract_status) VALUES ('473a9969-2eec-4058-aa28-223868dfe6ff', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'ISS', 'lifts', 'monthly', 'active');
INSERT INTO contracts (id, building_id, contractor_name, service_type, frequency, contract_status) VALUES ('f0e8e3b9-ffdb-4cf4-96cc-f34a2a409d52', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'ISS', 'lifts', 'monthly', 'active');
INSERT INTO contracts (id, building_id, contractor_name, service_type, start_date, end_date, frequency, contract_status) VALUES ('67c8b5fa-914e-454f-b346-445fbe5e95b7', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'ISS', 'lifts', '2025-03-14', '2026-03-13', 'annual', 'active');
INSERT INTO contracts (id, building_id, service_type, start_date, end_date, frequency, contract_status) VALUES ('f7f916ac-e991-47b7-91c0-425718a65e39', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'lifts', '2025-01-13', '2025-01-13', 'monthly', 'expired');
INSERT INTO contracts (id, building_id, service_type, contract_status) VALUES ('f0750432-e831-4570-a306-5108ac315f9e', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'pest_control', 'active');
INSERT INTO contracts (id, building_id, service_type, contract_status) VALUES ('7e961b86-d653-4b3a-8153-f9b2cbab77c3', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'pest_control', 'active');
INSERT INTO contracts (id, building_id, service_type, contract_status) VALUES ('d5b5acd5-b87c-4227-aa1b-b9b8d4f32dba', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'pest_control', 'active');
INSERT INTO contracts (id, building_id, service_type, contract_status) VALUES ('9db5871e-95dd-40a5-910e-54ef918f5fd9', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'pest_control', 'active');
INSERT INTO contracts (id, building_id, service_type, contract_status) VALUES ('4a821a11-614c-447e-a95c-e58b9e5b9d8c', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'pest_control', 'active');
INSERT INTO contracts (id, building_id, service_type, contract_status) VALUES ('06d6027d-91ac-4544-8244-fac2aca39652', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'pest_control', 'active');
INSERT INTO contracts (id, building_id, contractor_name, frequency, contract_status) VALUES ('2804c0a5-34c0-4a26-9509-09ed3ce8391e', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'WHM', 'monthly', 'active');
INSERT INTO contracts (id, building_id, contractor_name, frequency, contract_status) VALUES ('fd8fbadd-567d-4df7-b0a2-88a181abc3d3', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'WHM', 'monthly', 'active');
INSERT INTO contracts (id, building_id, contractor_name, frequency, contract_status) VALUES ('ff854cbf-8595-42d5-a2ed-7e452320803d', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'WHM', 'monthly', 'active');
INSERT INTO contracts (id, building_id, contractor_name, frequency, contract_status) VALUES ('716aa335-a0bd-4405-bf4c-8f393747b464', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'WHM', 'monthly', 'active');
INSERT INTO contracts (id, building_id, service_type, contract_status) VALUES ('c7b28510-b035-4c74-bb49-29733c5482d8', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'lifts', 'active');
INSERT INTO contracts (id, building_id, service_type, contract_status) VALUES ('77841e75-eab8-4f2b-ae30-f2dd53d71061', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'lifts', 'active');
INSERT INTO contracts (id, building_id, service_type, contract_status) VALUES ('1a0975e2-53be-4b1f-984b-bc93c6dfbb67', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'lifts', 'active');
INSERT INTO contracts (id, building_id, service_type, contract_status) VALUES ('e0a094f9-c2e0-4f15-bf4f-1b3e011dc28c', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'lifts', 'active');
INSERT INTO contracts (id, building_id, contractor_name, service_type, contract_status) VALUES ('85601b54-964c-4876-8730-61443dd8bd80', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'ISS', 'lifts', 'active');
INSERT INTO contracts (id, building_id, service_type, contract_status) VALUES ('e6fa00b6-6a09-4548-bf74-da49fe1153cd', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'fire_alarm', 'active');
INSERT INTO contracts (id, building_id, contractor_name, service_type, frequency, contract_status) VALUES ('fe94889a-cc21-48f2-860b-7ab756668cf0', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'Capita', 'security', 'monthly', 'active');
INSERT INTO contracts (id, building_id, contractor_name, service_type, frequency, contract_status) VALUES ('b142c988-dbcf-4716-9af3-e2d303390f8d', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'Capita', 'fire_alarm', 'monthly', 'active');
INSERT INTO contracts (id, building_id, contract_status) VALUES ('ec8510b1-2c69-4b37-8d61-3b3ef5bcc536', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'active');
INSERT INTO contracts (id, building_id, service_type, contract_status) VALUES ('b36728b4-dda6-4cf3-bdce-1de0a64cbadf', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'fire_alarm', 'active');
INSERT INTO contracts (id, building_id, service_type, frequency, contract_status) VALUES ('d6a22a5c-0174-4ae8-8042-6c191581b0a5', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'fire_alarm', 'monthly', 'active');
INSERT INTO contracts (id, building_id, service_type, frequency, contract_status) VALUES ('a4208235-d2e1-4a9f-878c-09d995e368ff', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'fire_alarm', 'monthly', 'active');
INSERT INTO contracts (id, building_id, service_type, frequency, contract_status) VALUES ('1af34acf-42c5-450a-a028-c7986c875256', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'fire_alarm', 'monthly', 'active');
INSERT INTO contracts (id, building_id, service_type, contract_status) VALUES ('10560e11-9ecf-4c69-8ff4-4859c8b2116f', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'fire_alarm', 'active');
INSERT INTO contracts (id, building_id, service_type, contract_status) VALUES ('95b2fd2b-5440-4642-b263-3aab395e20b4', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'fire_alarm', 'active');
INSERT INTO contracts (id, building_id, contractor_name, frequency, contract_status) VALUES ('55d4e868-bb31-4e7d-a376-a6f6818dab2b', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'WHM', 'monthly', 'active');
INSERT INTO contracts (id, building_id, contractor_name, contract_status) VALUES ('ae0e4cde-cc72-4f11-b212-02ac3232fc60', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'ISS', 'active');
INSERT INTO contracts (id, building_id, frequency, contract_status) VALUES ('3d9336cc-16a9-4410-8b27-535083fd31b6', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'monthly', 'active');
INSERT INTO contracts (id, building_id, frequency, contract_status) VALUES ('d2783b7d-ae37-4c95-a9de-66721378d8f5', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'monthly', 'active');
INSERT INTO contracts (id, building_id, frequency, contract_status) VALUES ('e9e5ecbd-d39c-4532-a579-0aa029ee4bf0', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'monthly', 'active');

-- Insert 21 building-contractor links
INSERT INTO building_contractors (id, building_id, contractor_id, relationship_type, is_preferred) VALUES ('fd7088bd-b139-45e0-aad3-ac4f1ff3de31', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', '0c4790db-1717-42eb-8314-ac16c3471be9', 'service_provider', FALSE);
INSERT INTO building_contractors (id, building_id, contractor_id, relationship_type, is_preferred) VALUES ('0bbc0780-24ea-4f85-a8dc-4fc84557edf1', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'b31ab448-a0ce-4f8a-b4d7-0ab089d06a0b', 'service_provider', FALSE);
INSERT INTO building_contractors (id, building_id, contractor_id, relationship_type, is_preferred) VALUES ('59d2e884-1ced-4eea-b93e-19dcc6515d39', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', '208c8157-b344-4791-996e-6916c595dbc2', 'service_provider', FALSE);
INSERT INTO building_contractors (id, building_id, contractor_id, relationship_type, is_preferred) VALUES ('f2b9ca19-980a-476c-90e4-4bfba07c61bc', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', '706aeca7-361c-4ea7-b93d-f3cc1ad305af', 'service_provider', FALSE);
INSERT INTO building_contractors (id, building_id, contractor_id, relationship_type, is_preferred) VALUES ('5cc53cc4-bde3-4621-805e-3e7e08e9685b', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'da3e5c35-357c-4628-a2a7-12db3de94949', 'service_provider', FALSE);
INSERT INTO building_contractors (id, building_id, contractor_id, relationship_type, is_preferred) VALUES ('8764ffc8-71c7-4f0a-bd00-113f635954be', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'cb587ba1-999c-4099-a49b-783f930b45d6', 'service_provider', FALSE);
INSERT INTO building_contractors (id, building_id, contractor_id, relationship_type, is_preferred) VALUES ('fc093d92-f238-4de0-b236-5158a5226902', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', '51493d82-3646-4f78-b7c1-f7b96ee15e91', 'service_provider', FALSE);
INSERT INTO building_contractors (id, building_id, contractor_id, relationship_type, is_preferred) VALUES ('3de1367b-6987-4565-b9e8-9d66b2ce26ac', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', '7d4bce10-cabc-42b4-93aa-7909e76af9ab', 'service_provider', FALSE);
INSERT INTO building_contractors (id, building_id, contractor_id, relationship_type, is_preferred) VALUES ('a31965ff-2363-4e31-a7cc-b57fde06b3a1', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'b79a994c-05c5-4ed5-8f41-15cce75bfa1c', 'service_provider', FALSE);
INSERT INTO building_contractors (id, building_id, contractor_id, relationship_type, is_preferred) VALUES ('748a1032-1d4b-4ecb-b96d-eafcf6c631b7', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', '024dcabe-bd0b-4e69-8061-09c6d4f33d89', 'service_provider', FALSE);
INSERT INTO building_contractors (id, building_id, contractor_id, relationship_type, is_preferred) VALUES ('23a829a2-091a-4015-bedc-f6fbc24b6bd4', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'fcdfd10f-7884-418e-bc98-6a25fdd7b02e', 'service_provider', FALSE);
INSERT INTO building_contractors (id, building_id, contractor_id, relationship_type, is_preferred) VALUES ('3c3438ae-9b8d-4d16-b4f6-9fa2b1c28c9c', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', '2070a905-13ee-4900-8f72-eca3f2ed9214', 'service_provider', FALSE);
INSERT INTO building_contractors (id, building_id, contractor_id, relationship_type, is_preferred) VALUES ('66809cf5-f2e6-4b89-8b57-4f09bb24c518', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'a3a1ed20-ae28-4357-8d79-b080784bc4a2', 'service_provider', FALSE);
INSERT INTO building_contractors (id, building_id, contractor_id, relationship_type, is_preferred) VALUES ('4f7437f3-5512-4423-899b-3058fc989ebd', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', '0681cefd-ebc4-4070-849f-41a66cba32d8', 'service_provider', FALSE);
INSERT INTO building_contractors (id, building_id, contractor_id, relationship_type, is_preferred) VALUES ('7c5fad17-cfeb-411f-9a31-b50b2d51f436', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', '32d9a4b1-8426-4899-b590-6a6a75dfaf10', 'service_provider', FALSE);
INSERT INTO building_contractors (id, building_id, contractor_id, relationship_type, is_preferred) VALUES ('0de8f3ac-65d7-4f50-91eb-9aac602b7737', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', '52a76804-568c-4a5c-86c1-9314a4a720bd', 'service_provider', FALSE);
INSERT INTO building_contractors (id, building_id, contractor_id, relationship_type, is_preferred) VALUES ('20451b76-9835-4c6c-8949-ab45715150ca', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'e7b7a787-89df-4878-87cd-a1ecb3f55c21', 'service_provider', FALSE);
INSERT INTO building_contractors (id, building_id, contractor_id, relationship_type, is_preferred) VALUES ('487b65c5-39fc-4584-9ee4-2426e134bc16', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', '95b246ae-e6cd-4610-819b-ad344594c5f2', 'service_provider', FALSE);
INSERT INTO building_contractors (id, building_id, contractor_id, relationship_type, is_preferred) VALUES ('d0f70326-9f31-4a60-a610-e568f884a2a6', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'ace39e4a-7270-449e-86f5-240ea6332881', 'service_provider', FALSE);
INSERT INTO building_contractors (id, building_id, contractor_id, relationship_type, is_preferred) VALUES ('24078034-a924-4bfa-9e3a-850a48f62d42', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'c1fecc38-634f-41ce-8176-85e52486eb88', 'service_provider', FALSE);
INSERT INTO building_contractors (id, building_id, contractor_id, relationship_type, is_preferred) VALUES ('2859b5dc-f7d7-4a12-a19c-e5d3bc93a267', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', '376f4480-29a9-4948-8110-b9692110b4a3', 'service_provider', FALSE);

-- Insert 214 assets
INSERT INTO assets (id, building_id, asset_type, asset_name, location_description, compliance_category, linked_documents) VALUES ('458a8291-a47a-445c-8766-39fb521e6c31', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'fire_alarm', 'Fire Alarm Works', 'Works-Following from latest leak', 'fire_safety', ARRAY['2024 Directors Meeting-Notes.docx']);
INSERT INTO assets (id, building_id, asset_type, asset_name, location_description, compliance_category, linked_documents) VALUES ('391051c6-5ff7-4209-90e0-491a0c495d4e', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'lift', 'Lift Works', 'Works-Following from latest leak', 'lifts_safety', ARRAY['2024 Directors Meeting-Notes.docx']);
INSERT INTO assets (id, building_id, asset_type, asset_name, location_description, model_number, compliance_category, linked_documents) VALUES ('36736e6f-5963-4e20-b08f-57b436088d83', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'boiler', 'Boiler Room', 'Basement', 'Fire', 'gas_safety', ARRAY['Fire Door (Communal) Inspection (11m +) (7).pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('e8873c3e-3314-475d-aa65-10bdf4c699c9', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'fire_alarm', 'Fire Alarm A', 'fire_safety', ARRAY['EICR Cuanku 32-34 conaught square.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, location_description, compliance_category, linked_documents) VALUES ('72a43229-5e2b-4e82-b91f-5f5c678c9eaf', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'lift', 'LIFT SHAFT', 'CONTROL CIRCUITS', 'lifts_safety', ARRAY['EICR Cuanku 32-34 conaught square.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, model_number, compliance_category, linked_documents) VALUES ('79529742-4599-4470-ac3b-5ab644fc85a8', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'lightning_protection', 'To lightning protection', 'B', 'electrical_safety', ARRAY['EICR Cuanku 32-34 conaught square.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('57019d69-976a-4f42-be0d-5283a565ce62', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'generator', 'generators', 'electrical_safety', ARRAY['EICR Cuanku 32-34 conaught square.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, location_description, compliance_category, linked_documents) VALUES ('a1ea4b4b-df9d-4036-884b-232ab7e40e75', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'boiler', 'Boiler room', 'terrace - lift', 'gas_safety', ARRAY['221037_Fra1-L-394697-071223 32-34 Connaught Square_2024-01-02_163759 (1).pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, location_description, condition_rating, compliance_category, linked_documents) VALUES ('4f2636f4-e5e1-4f1a-bffe-9aa074fc41b2', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'fire_alarm', 'Fire Alarm', 'in appropriate X Breaches to compartmentation observed', 'good', 'fire_safety', ARRAY['221037_Fra1-L-394697-071223 32-34 Connaught Square_2024-01-02_163759 (1).pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, location_description, compliance_category, linked_documents) VALUES ('3cfe83bd-8f64-4551-8f1a-167947f6d10d', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'lift', 'lift
motor', 'terrace - lift', 'lifts_safety', ARRAY['221037_Fra1-L-394697-071223 32-34 Connaught Square_2024-01-02_163759 (1).pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, location_description, model_number, compliance_category, linked_documents) VALUES ('aa1adb28-c653-4efe-8996-e8b755c1bc4c', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'door_entry', 'Intercom door entry', 'to 3rd floor', '1', 'security', ARRAY['221037_Fra1-L-394697-071223 32-34 Connaught Square_2024-01-02_163759 (1).pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('bf310a58-bd31-473b-8050-1156c104dda8', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'emergency_lighting', 'emergency lighting present', 'fire_safety', ARRAY['221037_Fra1-L-394697-071223 32-34 Connaught Square_2024-01-02_163759 (1).pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('3afc7699-e404-422e-afa8-d244135ae821', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'fire_extinguisher', 'fire extinguishers', 'fire_safety', ARRAY['221037_Fra1-L-394697-071223 32-34 Connaught Square_2024-01-02_163759 (1).pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, condition_rating, compliance_category, linked_documents) VALUES ('36ae4212-88f9-4f9f-bf1c-9033d14d8179', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'lightning_protection', 'Lightning protection available', 'good', 'electrical_safety', ARRAY['221037_Fra1-L-394697-071223 32-34 Connaught Square_2024-01-02_163759 (1).pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, location_description, model_number, condition_rating, compliance_category, linked_documents) VALUES ('ce293373-853e-472d-a3c4-820dac174b20', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'boiler', 'Boiler Hanworthy', 'Condensing Boiler Hanworthy Purewell variheat m k2 110 21 Mbar 110 0', 'pressure', 'fair', 'gas_safety', ARRAY['001132-3234-Connaught-Square-London.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, location_description, compliance_category, linked_documents) VALUES ('7befcdc5-141d-4008-9f1c-4cda47d51caa', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'boiler', 'Boiler room', 'terrace - lift', 'gas_safety', ARRAY['221038_Hsra1-L-394697-071223 32-34 Connaught Square_2024-01-02_163759 (1).pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('0400f71f-735f-4d64-9041-7a5d6ede44a6', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'lift', 'LIFTS', 'lifts_safety', ARRAY['221038_Hsra1-L-394697-071223 32-34 Connaught Square_2024-01-02_163759 (1).pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('73c8a73d-f188-4185-b2e6-6e0383cbd7f2', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'cctv', 'CCTV equipment', 'security', ARRAY['221038_Hsra1-L-394697-071223 32-34 Connaught Square_2024-01-02_163759 (1).pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, location_description, compliance_category, linked_documents) VALUES ('871d5217-1e51-494c-9cfe-bc6a67aec4ee', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'door_entry', 'Intercom door entry', 'to 3rd floor', 'security', ARRAY['221038_Hsra1-L-394697-071223 32-34 Connaught Square_2024-01-02_163759 (1).pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('478e7398-c99f-4e0e-9f1f-6904a6b88bc5', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'emergency_lighting', 'Emergency lighting provided', 'fire_safety', ARRAY['221038_Hsra1-L-394697-071223 32-34 Connaught Square_2024-01-02_163759 (1).pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('a75dfb3d-cdd5-41d8-92ad-3e5fd952dd82', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'water_tank', 'water storage tank', 'water_safety', ARRAY['221038_Hsra1-L-394697-071223 32-34 Connaught Square_2024-01-02_163759 (1).pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, location_description, compliance_category, linked_documents) VALUES ('b6d35818-7717-4282-8c90-e28cbea9c506', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'boiler', 'Boiler Room', 'exits', 'gas_safety', ARRAY['TETRA - Asbestos Re-Inspection Survey 14.06.22.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, location_description, compliance_category, linked_documents) VALUES ('61acd4cd-65b5-472b-a9ca-337c6e5e54aa', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'lift', 'Lift Motor', 'Description Assessment', 'lifts_safety', ARRAY['TETRA - Asbestos Re-Inspection Survey 14.06.22.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, location_description, compliance_category, linked_documents) VALUES ('f9e4a7d7-b446-4937-8594-44735b4330fb', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'pump', 'pumps', 'exits', 'water_safety', ARRAY['TETRA - Asbestos Re-Inspection Survey 14.06.22.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, model_number, compliance_category, linked_documents) VALUES ('a6053ea7-3b2b-46c7-8d18-cd6266984065', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'boiler', 'Boilers', 'Total', 'gas_safety', ARRAY['WHM Legionella Risk Assessment 07.06.22.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('fd99291e-d186-47e2-8bda-ab8ae77af845', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'sprinkler', 'Sprinklers', 'fire_safety', ARRAY['WHM Legionella Risk Assessment 07.06.22.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('38147e88-239a-4e63-91a5-f586e7dd6574', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'pump', 'pump is', 'water_safety', ARRAY['WHM Legionella Risk Assessment 07.06.22.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, service_frequency, compliance_category, linked_documents) VALUES ('9efcf527-3318-4c5e-ac16-ff445f52051e', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'water_tank', 'water tanks', 'annually', 'water_safety', ARRAY['WHM Legionella Risk Assessment 07.06.22.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('e08ec62b-1063-4560-aa20-0061b467e8fb', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'fire_alarm', 'Fire Alarm A', 'fire_safety', ARRAY['EICR Report Cunaku SATISFACTORY 2023 .pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, location_description, compliance_category, linked_documents) VALUES ('6d60b94d-3ed8-4a41-b982-a4dc37930c08', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'lift', 'LIFT SHAFT', 'CONTROL CIRCUITS', 'lifts_safety', ARRAY['EICR Report Cunaku SATISFACTORY 2023 .pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, model_number, compliance_category, linked_documents) VALUES ('a992f564-6d05-4bf4-a24b-134d561c05e5', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'lightning_protection', 'To lightning protection', 'B', 'electrical_safety', ARRAY['EICR Report Cunaku SATISFACTORY 2023 .pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('788a3ea9-4bb6-472b-80fa-fca3c233afd0', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'generator', 'generators', 'electrical_safety', ARRAY['EICR Report Cunaku SATISFACTORY 2023 .pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, location_description, compliance_category, linked_documents) VALUES ('afcef1cc-eb14-4860-ac5a-3e8e1f9cb8e7', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'fire_alarm', 'Fire Alarm Works', 'Works-Following from latest leak', 'fire_safety', ARRAY['2024 Directors Meeting-Notes.docx']);
INSERT INTO assets (id, building_id, asset_type, asset_name, location_description, compliance_category, linked_documents) VALUES ('cc87e3f6-6e8a-48d6-b2e1-2c7a935e8cde', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'lift', 'Lift Works', 'Works-Following from latest leak', 'lifts_safety', ARRAY['2024 Directors Meeting-Notes.docx']);
INSERT INTO assets (id, building_id, asset_type, asset_name, location_description, model_number, condition_rating, compliance_category, linked_documents) VALUES ('f4902847-a370-4928-8431-d8e9749f6dbf', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'boiler', 'Boiler Hanworthy', 'Condensing Boiler Hanworthy Wessex modumaxO mFk2 110c 20 Mbar 1', 'pressure', 'fair', 'gas_safety', ARRAY['001457-3234-Connaught-Square-London Certificate.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, location_description, manufacturer, compliance_category, linked_documents) VALUES ('595459dc-45b4-4594-94aa-8a9c9022eda6', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'lift', 'lift to', 'of Commission is', 'Crown to the Customer', 'lifts_safety', ARRAY['TC0001V31 General Terms and Conditions.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, model_number, compliance_category, linked_documents) VALUES ('e15d8645-2603-47b3-bab5-e5e1432bad37', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'boiler', 'Boilers', 'Total', 'gas_safety', ARRAY['Connaught Square (32-34) - 09.12.24 LRA.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('15b861d9-5a16-48a7-b1e0-bb4d332c37d0', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'sprinkler', 'Sprinklers', 'fire_safety', ARRAY['Connaught Square (32-34) - 09.12.24 LRA.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('12876770-56ff-45e0-9fe0-10355a4f20b1', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'pump', 'pump is', 'water_safety', ARRAY['Connaught Square (32-34) - 09.12.24 LRA.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, service_frequency, compliance_category, linked_documents) VALUES ('5f95c319-f80d-48cc-9276-a9fb026e3dd5', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'water_tank', 'water tanks', 'annually', 'water_safety', ARRAY['Connaught Square (32-34) - 09.12.24 LRA.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, location_description, model_number, compliance_category, linked_documents) VALUES ('afeec942-d17c-437b-8d4b-a13a8247595b', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'boiler', 'Boiler Room', 'Basement', 'Fire', 'gas_safety', ARRAY['Fire Door (Communal) Inspection (11m +) (7).pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, location_description, compliance_category, linked_documents) VALUES ('80472ee1-4281-4773-99d3-db1ddaef7503', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'boiler', 'Boiler room', 'terrace - lift', 'gas_safety', ARRAY['221037_Fra1-L-394697-071223 32-34 Connaught Square_2024-01-02_163759.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, location_description, condition_rating, compliance_category, linked_documents) VALUES ('ad6a1b4d-e451-4b1b-8fff-5ea9978cdafa', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'fire_alarm', 'Fire Alarm', 'in appropriate X Breaches to compartmentation observed', 'good', 'fire_safety', ARRAY['221037_Fra1-L-394697-071223 32-34 Connaught Square_2024-01-02_163759.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, location_description, compliance_category, linked_documents) VALUES ('e5377b1c-4e30-4c32-a78c-ff4d7cef3073', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'lift', 'lift
motor', 'terrace - lift', 'lifts_safety', ARRAY['221037_Fra1-L-394697-071223 32-34 Connaught Square_2024-01-02_163759.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, location_description, model_number, compliance_category, linked_documents) VALUES ('5082176b-4a01-4cdf-8b5d-5a817f47fcf9', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'door_entry', 'Intercom door entry', 'to 3rd floor', '1', 'security', ARRAY['221037_Fra1-L-394697-071223 32-34 Connaught Square_2024-01-02_163759.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('53abcffc-ed8a-43b3-b2a2-a9507308295b', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'emergency_lighting', 'emergency lighting present', 'fire_safety', ARRAY['221037_Fra1-L-394697-071223 32-34 Connaught Square_2024-01-02_163759.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('fb48e599-298a-4458-9ccb-9060a5b53937', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'fire_extinguisher', 'fire extinguishers', 'fire_safety', ARRAY['221037_Fra1-L-394697-071223 32-34 Connaught Square_2024-01-02_163759.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, condition_rating, compliance_category, linked_documents) VALUES ('4f8b6452-496b-48fc-a79b-ef1bbc960cc0', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'lightning_protection', 'Lightning protection available', 'good', 'electrical_safety', ARRAY['221037_Fra1-L-394697-071223 32-34 Connaught Square_2024-01-02_163759.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, location_description, model_number, compliance_category, linked_documents) VALUES ('0272fc23-195a-4ad1-b3de-395e55edf4dd', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'boiler', 'Boiler Room', 'Basement', 'Fire', 'gas_safety', ARRAY['Fire Door (Communal) Inspection (11m +) - 2024-01-24T120743.986.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, location_description, compliance_category, linked_documents) VALUES ('6a86b359-2a98-484c-9b6f-4f4a720d1b59', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'boiler', 'Boiler room', 'terrace - lift', 'gas_safety', ARRAY['221038_Hsra1-L-394697-071223 32-34 Connaught Square_2024-01-02_163759.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('eb5574fb-95df-406d-bf26-a4849a96bb67', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'lift', 'LIFTS', 'lifts_safety', ARRAY['221038_Hsra1-L-394697-071223 32-34 Connaught Square_2024-01-02_163759.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('5b48f6f1-65ed-4b8c-ae0b-0dd33c11e16d', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'cctv', 'CCTV equipment', 'security', ARRAY['221038_Hsra1-L-394697-071223 32-34 Connaught Square_2024-01-02_163759.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, location_description, compliance_category, linked_documents) VALUES ('bf248815-eb1a-4409-9fe2-5dea67080b06', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'door_entry', 'Intercom door entry', 'to 3rd floor', 'security', ARRAY['221038_Hsra1-L-394697-071223 32-34 Connaught Square_2024-01-02_163759.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('884bae2b-c3b9-4405-92be-2f47f4ddde07', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'emergency_lighting', 'Emergency lighting provided', 'fire_safety', ARRAY['221038_Hsra1-L-394697-071223 32-34 Connaught Square_2024-01-02_163759.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('1c3465bd-f2e6-4e12-a3d7-42fda9992849', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'water_tank', 'water storage tank', 'water_safety', ARRAY['221038_Hsra1-L-394697-071223 32-34 Connaught Square_2024-01-02_163759.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, location_description, compliance_category, linked_documents) VALUES ('851e0c3f-c2cc-4ddd-9e7a-b2b7abb20ab5', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'boiler', 'Boiler room', 'terrace - lift', 'gas_safety', ARRAY['Hsfra1-L-422971-210225 32-34 Connaught Square.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, location_description, condition_rating, compliance_category, linked_documents) VALUES ('4dd78965-e97c-4625-9338-c6317ed899b3', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'fire_alarm', 'Fire Alarm', 'in appropriate X Breaches to compartmentation observed', 'good', 'fire_safety', ARRAY['Hsfra1-L-422971-210225 32-34 Connaught Square.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('85e44843-1ae3-4273-8357-d3cb372a0cf9', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'lift', 'LIFTS', 'lifts_safety', ARRAY['Hsfra1-L-422971-210225 32-34 Connaught Square.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('0f958056-bd3e-49af-89b8-31ce03aeb415', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'cctv', 'CCTV equipment', 'security', ARRAY['Hsfra1-L-422971-210225 32-34 Connaught Square.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, location_description, compliance_category, linked_documents) VALUES ('73852eb5-2e01-4201-84a7-68a21573e8db', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'door_entry', 'Intercom door entry', 'to 3rd floor', 'security', ARRAY['Hsfra1-L-422971-210225 32-34 Connaught Square.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('ff463b0d-ec4c-4a3d-8796-39f67b347b61', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'emergency_lighting', 'Emergency lighting provided', 'fire_safety', ARRAY['Hsfra1-L-422971-210225 32-34 Connaught Square.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('de8f5d2b-d808-470c-8c35-01d8465da0eb', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'fire_extinguisher', 'fire extinguishers', 'fire_safety', ARRAY['Hsfra1-L-422971-210225 32-34 Connaught Square.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, condition_rating, compliance_category, linked_documents) VALUES ('bcfd2af1-cb29-4ab5-941f-01cbef2b0804', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'lightning_protection', 'Lightning protection available', 'good', 'electrical_safety', ARRAY['Hsfra1-L-422971-210225 32-34 Connaught Square.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('c3b39a5b-007e-4201-9f9b-5d024694c28b', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'water_tank', 'water storage tank', 'water_safety', ARRAY['Hsfra1-L-422971-210225 32-34 Connaught Square.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('2d237b8b-9ea7-4938-b5f6-7a01ef5718a8', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'fire_alarm', 'ESCAPE

FIRE DETECTION', 'fire_safety', ARRAY['Hsfra1-L-422971-210225 32-34 Connaught Square.docx']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('7310c1cd-f501-4a67-b9ed-9245dd707d0c', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'lift', 'LIFTS', 'lifts_safety', ARRAY['Hsfra1-L-422971-210225 32-34 Connaught Square.docx']);
INSERT INTO assets (id, building_id, asset_type, asset_name, location_description, compliance_category, linked_documents) VALUES ('7f6ff3d1-911e-47e9-bb63-e8372a984572', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'boiler', 'Boiler room', 'terrace - lift', 'gas_safety', ARRAY['221037_Fra1-L-394697-071223 32-34 Connaught Square_2024-01-02_163759 (1).pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, location_description, condition_rating, compliance_category, linked_documents) VALUES ('2ff88578-28ab-4e3f-90ec-28527c83e244', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'fire_alarm', 'Fire Alarm', 'in appropriate X Breaches to compartmentation observed', 'good', 'fire_safety', ARRAY['221037_Fra1-L-394697-071223 32-34 Connaught Square_2024-01-02_163759 (1).pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, location_description, compliance_category, linked_documents) VALUES ('708ad1a7-c252-410e-aa1a-7b8bc07375c4', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'lift', 'lift
motor', 'terrace - lift', 'lifts_safety', ARRAY['221037_Fra1-L-394697-071223 32-34 Connaught Square_2024-01-02_163759 (1).pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, location_description, model_number, compliance_category, linked_documents) VALUES ('3b04776a-87b9-4f87-bf77-e845220b1032', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'door_entry', 'Intercom door entry', 'to 3rd floor', '1', 'security', ARRAY['221037_Fra1-L-394697-071223 32-34 Connaught Square_2024-01-02_163759 (1).pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('43153369-6396-40e5-8726-5baa06c15842', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'emergency_lighting', 'emergency lighting present', 'fire_safety', ARRAY['221037_Fra1-L-394697-071223 32-34 Connaught Square_2024-01-02_163759 (1).pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('37b8694b-2713-4989-b7ad-042ee30d4559', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'fire_extinguisher', 'fire extinguishers', 'fire_safety', ARRAY['221037_Fra1-L-394697-071223 32-34 Connaught Square_2024-01-02_163759 (1).pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, condition_rating, compliance_category, linked_documents) VALUES ('5c4cc603-c5b9-47fb-91db-90de56ebedbf', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'lightning_protection', 'Lightning protection available', 'good', 'electrical_safety', ARRAY['221037_Fra1-L-394697-071223 32-34 Connaught Square_2024-01-02_163759 (1).pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, location_description, compliance_category, linked_documents) VALUES ('c6a5a21c-9f36-409e-8a48-a04929232c99', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'boiler', 'Boiler room', 'terrace - lift', 'gas_safety', ARRAY['221038_Hsra1-L-394697-071223 32-34 Connaught Square_2024-01-02_163759 (1).pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('332c975a-9d80-42e5-88a0-0e64aa4e105f', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'lift', 'LIFTS', 'lifts_safety', ARRAY['221038_Hsra1-L-394697-071223 32-34 Connaught Square_2024-01-02_163759 (1).pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('9d023feb-8e3b-4473-8f5e-225006145156', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'cctv', 'CCTV equipment', 'security', ARRAY['221038_Hsra1-L-394697-071223 32-34 Connaught Square_2024-01-02_163759 (1).pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, location_description, compliance_category, linked_documents) VALUES ('65b71d92-9e8e-40ed-9172-4d119ec12855', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'door_entry', 'Intercom door entry', 'to 3rd floor', 'security', ARRAY['221038_Hsra1-L-394697-071223 32-34 Connaught Square_2024-01-02_163759 (1).pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('f0040cc2-9a66-4c99-b138-383ef464e268', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'emergency_lighting', 'Emergency lighting provided', 'fire_safety', ARRAY['221038_Hsra1-L-394697-071223 32-34 Connaught Square_2024-01-02_163759 (1).pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('5b6d6988-31b7-4604-9bf4-76c6453ed292', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'water_tank', 'water storage tank', 'water_safety', ARRAY['221038_Hsra1-L-394697-071223 32-34 Connaught Square_2024-01-02_163759 (1).pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, location_description, model_number, condition_rating, compliance_category, linked_documents) VALUES ('564a9ac7-e717-4e91-8ce1-d00ce6a0fbff', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'boiler', 'Boiler Hamworthy', 'Plant Room Condensing', 'pressure', 'fair', 'gas_safety', ARRAY['001534-3234-Connaught-Square-London.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, location_description, compliance_category, linked_documents) VALUES ('1ac2113a-f313-4d2c-ad55-294174de86cd', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'boiler', 'boiler number', 'new gas valve', 'gas_safety', ARRAY['C1047 - Job card.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, model_number, compliance_category, linked_documents) VALUES ('e3f42ad2-a6da-4a5d-a68d-5cbed07ef025', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'boiler', 'Boilers', 'Total', 'gas_safety', ARRAY['WHM Legionella Risk Assessment 09.12.25.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('dd960635-b4a5-47b0-b3ed-9a51880b9eec', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'sprinkler', 'Sprinklers', 'fire_safety', ARRAY['WHM Legionella Risk Assessment 09.12.25.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('321805a3-c7f3-4886-927d-4441dc8fa937', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'pump', 'pump is', 'water_safety', ARRAY['WHM Legionella Risk Assessment 09.12.25.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, service_frequency, compliance_category, linked_documents) VALUES ('0a772651-9b06-4936-b305-5e8ff9f8e02d', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'water_tank', 'water tanks', 'annually', 'water_safety', ARRAY['WHM Legionella Risk Assessment 09.12.25.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, model_number, compliance_category, linked_documents) VALUES ('82bc8d47-f9f7-4f2a-aece-9931ba9f2d04', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'boiler', 'Boilers', 'Total', 'gas_safety', ARRAY['WHM Legionella Risk Assessment 07.06.22.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('93f8e186-f96e-48e6-a276-92568cf6d154', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'sprinkler', 'Sprinklers', 'fire_safety', ARRAY['WHM Legionella Risk Assessment 07.06.22.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('567c9f23-2b93-4dba-8cbe-08d0d5903ae4', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'pump', 'pump is', 'water_safety', ARRAY['WHM Legionella Risk Assessment 07.06.22.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, service_frequency, compliance_category, linked_documents) VALUES ('2e65d91a-ccaf-42b0-8784-64c31e5e6447', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'water_tank', 'water tanks', 'annually', 'water_safety', ARRAY['WHM Legionella Risk Assessment 07.06.22.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('744883b7-e55f-43da-8d12-18da5681516a', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'fire_alarm', 'Fire Alarm A', 'fire_safety', ARRAY['EICR Cuanku 32-34 conaught square.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, location_description, compliance_category, linked_documents) VALUES ('eefd5022-8e72-4726-9e1e-519d0c63d987', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'lift', 'LIFT SHAFT', 'CONTROL CIRCUITS', 'lifts_safety', ARRAY['EICR Cuanku 32-34 conaught square.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, model_number, compliance_category, linked_documents) VALUES ('2384f295-0d31-4ace-8772-298dd49595f2', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'lightning_protection', 'To lightning protection', 'B', 'electrical_safety', ARRAY['EICR Cuanku 32-34 conaught square.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('1445f317-6736-473c-8bae-7479e76b57f7', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'generator', 'generators', 'electrical_safety', ARRAY['EICR Cuanku 32-34 conaught square.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('e541abf9-7cfc-4e10-a538-c38d499217a4', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'fire_alarm', 'Fire Alarm A', 'fire_safety', ARRAY['EICR Report Cunaku SATISFACTORY 2023 .pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, location_description, compliance_category, linked_documents) VALUES ('b451d231-196b-4f1d-baf0-2a79e1d093cc', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'lift', 'LIFT SHAFT', 'CONTROL CIRCUITS', 'lifts_safety', ARRAY['EICR Report Cunaku SATISFACTORY 2023 .pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, model_number, compliance_category, linked_documents) VALUES ('e51614ca-740c-41a1-8ff0-154c0cc9597e', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'lightning_protection', 'To lightning protection', 'B', 'electrical_safety', ARRAY['EICR Report Cunaku SATISFACTORY 2023 .pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('3e80134d-c04d-4567-bce5-4b7c782f2b71', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'generator', 'generators', 'electrical_safety', ARRAY['EICR Report Cunaku SATISFACTORY 2023 .pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, location_description, model_number, condition_rating, compliance_category, linked_documents) VALUES ('25119e65-4d10-4af0-9dfd-ddedb774e8bb', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'boiler', 'Boiler Hanworthy', 'Condensing Boiler Hanworthy Purewell variheat m k2 110 21 Mbar 110 0', 'pressure', 'fair', 'gas_safety', ARRAY['001132-3234-Connaught-Square-London.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, location_description, model_number, condition_rating, compliance_category, linked_documents) VALUES ('620c33b6-90d0-4ae9-80ff-e36fb6bfbdff', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'boiler', 'Boiler Hamworthy', 'Plant Room Condensing', 'pressure', 'fair', 'gas_safety', ARRAY['001534-3234-Connaught-Square-London.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, location_description, compliance_category, linked_documents) VALUES ('15006cb1-987e-4735-82bc-76db956abbf0', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'boiler', 'Boiler Room', 'pipework', 'gas_safety', ARRAY['FINAL L-432900 32-34 Connaught Square Management Survey Report Issue 1.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, location_description, compliance_category, linked_documents) VALUES ('d304d1ea-7ff1-45e1-890d-e63cd3248570', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'lift', 'Lift Motor', 'Room brake shoe to lift motor', 'lifts_safety', ARRAY['FINAL L-432900 32-34 Connaught Square Management Survey Report Issue 1.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, location_description, compliance_category, linked_documents) VALUES ('47787bd9-6797-4ea6-8bc2-fbcacd497a60', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'boiler', 'Boiler Room', 'exits', 'gas_safety', ARRAY['TETRA - Asbestos Re-Inspection Survey 14.06.22.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, location_description, compliance_category, linked_documents) VALUES ('00030007-cb9f-4e6a-9e60-53dd0ff85de3', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'lift', 'Lift Motor', 'Description Assessment', 'lifts_safety', ARRAY['TETRA - Asbestos Re-Inspection Survey 14.06.22.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, location_description, compliance_category, linked_documents) VALUES ('166d8571-8ca5-4d43-9f18-c3783b9d15a6', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'pump', 'pumps', 'exits', 'water_safety', ARRAY['TETRA - Asbestos Re-Inspection Survey 14.06.22.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, service_frequency, compliance_category, linked_documents) VALUES ('5644cb99-7f0e-45d7-887c-e55fa9ad2809', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'lift', 'lifts', 'monthly', 'lifts_safety', ARRAY['Signed 2025 Connaught Square Management Agreement.docx.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, service_frequency, compliance_category, linked_documents) VALUES ('f587d66a-5711-4f7d-a61e-8fc3c00a1311', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'lift', 'lifts', 'monthly', 'lifts_safety', ARRAY['Signed Connaught Square Management Agreement.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, model_number, compliance_category, linked_documents) VALUES ('52cfcc28-e050-41be-9771-74062a2a2404', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'boiler', 'BOILER SERVICE', 'OF', 'gas_safety', ARRAY['CM434.PRO 2024-2025.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, model_number, compliance_category, linked_documents) VALUES ('d852eac9-a204-4697-960f-8dfcc1f36a92', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'boiler', 'BOILER SERVICE', 'OF', 'gas_safety', ARRAY['CM434.PRO.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('abbf830b-5623-4bd5-b49e-216129c9c723', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'lift', 'lift in', 'lifts_safety', ARRAY['Gas Contract 24-5.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('64ac092f-3fc4-4035-ac8f-5a3b996db8f7', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'lift', 'LIFT INCORPORATED', 'lifts_safety', ARRAY['Contract_10-03-2025.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('17812356-2424-4cbe-8d20-246f05ebaa15', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'lift', 'LIFT INCORPORATED', 'lifts_safety', ARRAY['Gas Contract 25-26.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('166d06e8-bbf9-4f7d-a876-ecfa8ca8865b', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'lift', 'lift to', 'lifts_safety', ARRAY['Welcome Letter - CG1885574.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, location_description, service_frequency, compliance_category, linked_documents) VALUES ('87071808-b495-4194-be19-aeee2360bf62', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'lift', 'lift accessible', 'To clean out silt from the outlet and bagged it up', 'monthly', 'lifts_safety', ARRAY['Job 67141.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, model_number, compliance_category, linked_documents) VALUES ('14e09cbb-1e7e-4493-84d7-013dec5556cf', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'lift', 'Lift Ref', 'BRONZE', 'lifts_safety', ARRAY['JLGCalloutVisit-5455045-12-07-2024.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, model_number, compliance_category, linked_documents) VALUES ('014814aa-2c91-49b4-8162-b1477c07d3c3', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'lift', 'Lift Ref', 'BRONZE', 'lifts_safety', ARRAY['JLGCalloutVisit-5483206-26-10-2024.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, model_number, compliance_category, linked_documents) VALUES ('2ea74f06-167d-4f41-9c5e-29f8b7032351', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'lift', 'Lift Ref', 'BRONZE', 'lifts_safety', ARRAY['JLGCalloutVisit-5498439-16-12-2024.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, location_description, compliance_category, linked_documents) VALUES ('d223695d-c7bb-4af3-b35c-1d6bd3b8534a', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'emergency_lighting', 'emergency lighting
The', 'The fault status has been classified as Faulty', 'fire_safety', ARRAY['JLGCalloutVisit-5498439-16-12-2024.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, model_number, compliance_category, linked_documents) VALUES ('66a5be76-ac9d-44ba-b9bc-aba6ef8cb282', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'lift', 'Lift Ref', 'BRONZE', 'lifts_safety', ARRAY['JLGCalloutVisit-5455462-16-07-2024.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, model_number, compliance_category, linked_documents) VALUES ('fa0f7b76-9ea6-4888-8a6c-d3dfddb254d9', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'lift', 'Lift Ref', 'BRONZE', 'lifts_safety', ARRAY['JLGCalloutVisit-5497480-13-12-2024.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, model_number, compliance_category, linked_documents) VALUES ('76104d0e-3047-4e20-b3b6-a0e85429ca61', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'fire_alarm', 'Fire Alarm', 'SMALL', 'fire_safety', ARRAY['Engineering Report - 32-34 CONNAUGHT SQUARE.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, model_number, compliance_category, linked_documents) VALUES ('a36e2680-d8dc-4c37-b1b3-13d71d010fa4', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'emergency_lighting', 'Emergency Lights - FA7817', 'SMALL', 'fire_safety', ARRAY['Engineering Report - 32-34 CONNAUGHT SQUARE.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, location_description, compliance_category, linked_documents) VALUES ('b3de67d5-6b5f-4c21-b39d-a3eeec1ad693', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'boiler', 'a boiler', 'but this sha', 'gas_safety', ARRAY['StG_Policy Wording_32-34 Connaught Square W2 2HL.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('c8473da7-6b65-4e64-b673-0340f3a7d2cd', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'fire_alarm', 'fire alarm
The', 'fire_safety', ARRAY['StG_Policy Wording_32-34 Connaught Square W2 2HL.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('c8bb13b4-5a4f-4d61-8544-4ec4675ae964', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'sprinkler', 'sprinkler leakage', 'fire_safety', ARRAY['StG_Policy Wording_32-34 Connaught Square W2 2HL.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('8593a400-0dce-439b-9641-a8e974e3acb7', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'lift', 'lift in', 'lifts_safety', ARRAY['StG_Policy Wording_32-34 Connaught Square W2 2HL.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('b06dc744-bc28-4f30-abc4-f50e024f0ec1', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'pump', 'pumping', 'water_safety', ARRAY['StG_Policy Wording_32-34 Connaught Square W2 2HL.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, location_description, compliance_category, linked_documents) VALUES ('c26abe92-e0a8-4e90-9fdd-fbd9432cb70e', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'cctv', 'cameras', 'on or', 'security', ARRAY['StG_Policy Wording_32-34 Connaught Square W2 2HL.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('6ce86b68-5860-4ec6-a446-4c1edbdfca6f', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'water_tank', 'water tanks', 'water_safety', ARRAY['StG_Policy Wording_32-34 Connaught Square W2 2HL.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('3b94958c-1c13-4426-8d53-692b840f6169', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'fire_extinguisher', 'fire extinguishers', 'fire_safety', ARRAY['Q51691 - 32-34 Connaught Square Contract.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, model_number, compliance_category, linked_documents) VALUES ('a224095c-d7fb-4ef8-9837-426dfc063c26', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'fire_alarm', 'Fire Alarm', 'SMALL', 'fire_safety', ARRAY['Engineering Report - 32-34 CONNAUGHT SQUARE.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, model_number, compliance_category, linked_documents) VALUES ('d58b9bd0-f139-4da5-a825-04df7467aa6e', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'emergency_lighting', 'Emergency Lights - FA7817', 'SMALL', 'fire_safety', ARRAY['Engineering Report - 32-34 CONNAUGHT SQUARE.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, location_description, model_number, compliance_category, linked_documents) VALUES ('d8eb597b-d110-4fba-bf6f-27c5b9c818c9', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'fire_alarm', 'uk
FIRE ALARM', 'LONDON', 'LIGHTS', 'fire_safety', ARRAY['Fire Alarm+Emergency Lighting Contract Connaught Square.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, service_frequency, compliance_category, linked_documents) VALUES ('02770c69-0207-42fe-8b0e-b4e8a31a735d', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'emergency_lighting', 'EMERGENCY LIGHTS
MT8825', 'monthly', 'fire_safety', ARRAY['Fire Alarm+Emergency Lighting Contract Connaught Square.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, service_frequency, compliance_category, linked_documents) VALUES ('873f002a-6373-4f97-8853-e963167031ff', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'fire_alarm', 'FIRE ALARM BELL', 'monthly', 'fire_safety', ARRAY['BT3205 03072025.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, model_number, service_frequency, compliance_category, linked_documents) VALUES ('b0d10858-45ef-4ddf-95a2-bd7f94e6983d', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'fire_alarm', 'fire alarm service', 'MAINTENANCE', 'monthly', 'fire_safety', ARRAY['FA7817 SERVICE 08042025.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, model_number, service_frequency, compliance_category, linked_documents) VALUES ('df448222-9635-4aa3-a17b-8bf0061d01d6', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'emergency_lighting', 'Emergency Lights - FA7817', 'MAINTENANCE', 'monthly', 'fire_safety', ARRAY['FA7817 SERVICE 08042025.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, model_number, compliance_category, linked_documents) VALUES ('598dc441-7845-4463-86b3-e661e5446d6b', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'fire_alarm', 'Fire Alarm', 'SMALL', 'fire_safety', ARRAY['Engineer Report - 32-34 Connaught Square Flat 5.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, model_number, compliance_category, linked_documents) VALUES ('90a54263-0d2b-4649-bd26-5944441d8d3a', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'emergency_lighting', 'Emergency Lights - FA7817', 'SMALL', 'fire_safety', ARRAY['Engineer Report - 32-34 Connaught Square Flat 5.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, model_number, compliance_category, linked_documents) VALUES ('6109d364-0561-49ca-aa81-94109dbb126d', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'fire_alarm', 'Fire Alarm', 'SMALL', 'fire_safety', ARRAY['Engineering Report - 32-34 CONNAUGHT SQUARE.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, model_number, compliance_category, linked_documents) VALUES ('5a63d035-40b2-4bb8-a4e6-688087f5f42c', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'emergency_lighting', 'Emergency Lights - FA7817', 'SMALL', 'fire_safety', ARRAY['Engineering Report - 32-34 CONNAUGHT SQUARE.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, model_number, service_frequency, compliance_category, linked_documents) VALUES ('b905e975-5141-492a-ba3e-6e5fecbe1283', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'emergency_lighting', 'Emergency Lights Testing', 'MONTHLY', 'monthly', 'fire_safety', ARRAY['MT8825 03072025.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, model_number, service_frequency, compliance_category, linked_documents) VALUES ('59f2fe2f-0f35-49ce-a66e-a848e3bf7f85', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'emergency_lighting', 'Emergency Lights Testing', 'MONTHLY', 'monthly', 'fire_safety', ARRAY['January Monthly Test For EL-Connaught Square.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, model_number, service_frequency, compliance_category, linked_documents) VALUES ('4a225202-ab97-4406-aac8-462c2e7d4ff8', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'emergency_lighting', 'Emergency Lights Testing', 'MONTHLY', 'monthly', 'fire_safety', ARRAY['February Monthly Test For EL-Connaught Square.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('fe32b07a-45bb-4dcb-a254-869bfc6a5cd4', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'boiler', 'boilers', 'gas_safety', ARRAY['Real Estate Policy (01.23).pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('6d94ff1f-40fa-4361-bcc5-2820fdf66eb9', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'sprinkler', 'sprinkler leakage', 'fire_safety', ARRAY['Real Estate Policy (01.23).pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('16a2d135-a566-472e-a5f7-b32bb1b8da4d', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'pump', 'pumping', 'water_safety', ARRAY['Real Estate Policy (01.23).pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('be07ca31-92ee-4b5c-980f-cbb56dee5e75', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'cctv', 'cameras', 'security', ARRAY['Real Estate Policy (01.23).pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('89d6c6dc-4670-42d7-b291-4a1f6d73dead', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'fire_extinguisher', 'fire extinguishers', 'fire_safety', ARRAY['Real Estate Policy (01.23).pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('c72d5159-7584-4ccd-89af-935ca8172b7d', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'communal_aerial', 'satellite dishes', 'other', ARRAY['Real Estate Policy (01.23).pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('d3f621e5-9046-448e-a20e-d7359bce2356', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'water_tank', 'water tanks', 'water_safety', ARRAY['Real Estate Policy (01.23).pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('9e1333bd-7a72-4ad8-a974-a85437aa2a28', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'sprinkler', 'sprinkler installation', 'fire_safety', ARRAY['Summary of Cover (01.23).pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('c2d17bee-752d-4157-a447-58cdf6627776', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'lift', 'lift in', 'lifts_safety', ARRAY['Summary of Cover (01.23).pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('8e715cc7-b81d-4c3a-9f55-8f83701a5d61', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'boiler', 'Boilers', 'gas_safety', ARRAY['2023 Allianz VOC - 32-34 Connuaght Square (Freehold) Limited.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('20bbecc7-ac62-4d50-a574-c812a58117c8', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'lift', 'Lift - Powered', 'lifts_safety', ARRAY['2023 Allianz VOC - 32-34 Connuaght Square (Freehold) Limited.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('0180547a-faca-4276-ad6d-b390a79e53f5', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'pump', 'Pumps', 'water_safety', ARRAY['2023 Allianz VOC - 32-34 Connuaght Square (Freehold) Limited.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('b1fc9862-7ba0-44fa-a939-29651ea1c3f9', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'boiler', 'Boilers', 'gas_safety', ARRAY['2023 Engineering Renewal Notice - 32 34 Connuaght Square (Freehold) Limited.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('b0d5db66-0daf-4e1c-a2fe-916b6fe1c770', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'lift', 'Lift -
Powered', 'lifts_safety', ARRAY['2023 Engineering Renewal Notice - 32 34 Connuaght Square (Freehold) Limited.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('f7100c62-712c-4515-9ec4-d6d222f46d7e', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'pump', 'Pumps', 'water_safety', ARRAY['2023 Engineering Renewal Notice - 32 34 Connuaght Square (Freehold) Limited.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('b3d70acf-d242-433b-ab12-7ad6fb09830f', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'lift', 'Lift', 'lifts_safety', ARRAY['32-34 Connaught Sq Buildings Insurance 2023-2024.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('b0ec69d9-ed83-4418-a14b-82ed2ead945d', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'lift', 'Lift Report', 'lifts_safety', ARRAY['Allianz - Lift Report 14.03.23.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('7bf259d5-518c-4bdc-b537-0150b291a201', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'lift', 'Lift Report', 'lifts_safety', ARRAY['Allianz-Lift Report 18.03.2024.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('17bba60a-56bd-4db3-8ce1-e18c96ec8c69', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'lift', 'Lift Report', 'lifts_safety', ARRAY['Allianz - Lift Report - 15.09.21.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('12a3006f-bd6d-4e54-a20c-1d86ad1dcb11', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'lift', 'Lift Report', 'lifts_safety', ARRAY['Allianz - Lift Report 10.03.22.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('9a78ee7b-46a8-48e0-a44e-64687b61a4b2', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'boiler', 'Boilers', 'gas_safety', ARRAY['2023 Allianz VOC - 32-34 Connuaght Square (Freehold) Limited.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('ec1dcbc5-788b-43e1-8b67-65887f948f33', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'lift', 'Lift - Powered', 'lifts_safety', ARRAY['2023 Allianz VOC - 32-34 Connuaght Square (Freehold) Limited.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('20d54bd5-1cd9-4105-b502-9335cd43a373', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'pump', 'Pumps', 'water_safety', ARRAY['2023 Allianz VOC - 32-34 Connuaght Square (Freehold) Limited.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('54133ea0-926a-4c12-a61c-ee945706ba81', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'boiler', 'Boilers', 'gas_safety', ARRAY['2023 Engineering Renewal Notice - 32 34 Connuaght Square (Freehold) Limited.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('cd7202eb-eff2-4d73-9e01-f8ef2f43e5e3', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'lift', 'Lift -
Powered', 'lifts_safety', ARRAY['2023 Engineering Renewal Notice - 32 34 Connuaght Square (Freehold) Limited.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('c69cfb62-d098-4467-8e72-00e0c9dd7801', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'pump', 'Pumps', 'water_safety', ARRAY['2023 Engineering Renewal Notice - 32 34 Connuaght Square (Freehold) Limited.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, location_description, compliance_category, linked_documents) VALUES ('2bd4487c-f85e-4492-854d-b3e2082e84d9', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'boiler', 'Boiler and', 'owned by or leased', 'gas_safety', ARRAY['MO - Policy Wording - NZ0411.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('eeac3691-a043-4220-ac14-a40dd0a4d160', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'lift', 'Lift and', 'lifts_safety', ARRAY['MO - Policy Wording - NZ0411.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('f392aca1-d5e3-4e42-810b-28a98818a38c', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'pump', 'pumps', 'water_safety', ARRAY['MO - Policy Wording - NZ0411.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('b079a504-45d6-4b7a-ac5d-2f6e92475fc3', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'water_tank', 'Storage Tanks', 'water_safety', ARRAY['MO - Policy Wording - NZ0411.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('4f3abd0e-c5cd-4cb5-b213-d5396b4921f0', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'generator', 'generator sets', 'electrical_safety', ARRAY['MO - Policy Wording - NZ0411.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('c1cb0125-77fa-453e-8e17-9a2ed108848a', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'lift', 'Lift and', 'lifts_safety', ARRAY['Feature and Benefits of Allianz Engineering Inspection Service.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('4d7bdc7c-fd1e-4151-8b90-004414ba0cee', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'boiler', 'Boilers', 'gas_safety', ARRAY['StG_Statement of Facts_32-34 Connaught Square W2 2HL.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('265e04c4-1f9a-4512-8e2b-ba43a34bce17', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'lift', 'Lifts', 'lifts_safety', ARRAY['StG_Statement of Facts_32-34 Connaught Square W2 2HL.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('b59ab58f-ff6f-47ae-99ca-0b6144f97188', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'pump', 'Centrifugal pump', 'water_safety', ARRAY['StG_Statement of Facts_32-34 Connaught Square W2 2HL.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('df90c460-a416-4eb9-97c2-2bc895d6243c', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'boiler', 'Boilers', 'gas_safety', ARRAY['StG_Insurance Report_32-34 Connaught Square W2 2HL.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('e659cfed-4177-4f61-a7c9-27037f8210f2', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'lift', 'Lifts', 'lifts_safety', ARRAY['StG_Insurance Report_32-34 Connaught Square W2 2HL.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('c2a6dadd-e756-408c-8d78-0b6a223e3957', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'pump', 'Centrifugal pump', 'water_safety', ARRAY['StG_Insurance Report_32-34 Connaught Square W2 2HL.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('b0676620-b187-4b4e-a328-32d3f2ecb1f4', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'boiler', 'Boilers', 'gas_safety', ARRAY['StG_Statement of Facts_32-34 Connaught Square W2 2HL.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('70ee7cc6-f926-4584-bd28-19d9453657b5', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'lift', 'Lifts', 'lifts_safety', ARRAY['StG_Statement of Facts_32-34 Connaught Square W2 2HL.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('d1343aff-c9df-4bb1-8a79-9e3ab17e57c9', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'pump', 'Centrifugal pump', 'water_safety', ARRAY['StG_Statement of Facts_32-34 Connaught Square W2 2HL.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('de5f612e-61a9-4b97-ab36-253ab90482b7', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'boiler', 'Boilers', 'gas_safety', ARRAY['StG_Insurance Report_32-34 Connaught Square W2 2HL.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('371de321-c6c8-4856-b77f-33fba3d53db9', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'lift', 'Lifts', 'lifts_safety', ARRAY['StG_Insurance Report_32-34 Connaught Square W2 2HL.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('85b8a61e-3fa9-495b-8860-6be6d8a5d64c', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'pump', 'Centrifugal pump', 'water_safety', ARRAY['StG_Insurance Report_32-34 Connaught Square W2 2HL.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('d782eda7-c677-4735-98d2-3a4f2d701eec', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'boiler', 'water boiler', 'gas_safety', ARRAY['StG_Certificate_32-34 Connaught Square W2 2HL.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('27cd5076-5de3-40cd-95b1-6d99293e82b4', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'lift', 'Passenger Lift', 'lifts_safety', ARRAY['StG_Certificate_32-34 Connaught Square W2 2HL.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('659dea88-88a1-44ee-956b-4b0196d78251', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'pump', 'Centrifugal pump', 'water_safety', ARRAY['StG_Certificate_32-34 Connaught Square W2 2HL.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('081ab4f6-8675-44ff-a418-3108643bf7c8', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'boiler', 'Boilers', 'gas_safety', ARRAY['StG_Statement of Fact_32-34 Connaught Square W2 2HL.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('c210805e-acdf-451f-891c-dd4d72fa1f62', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'lift', 'Lifts', 'lifts_safety', ARRAY['StG_Statement of Fact_32-34 Connaught Square W2 2HL.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('e5732f76-cefd-446d-aa0e-d4f9e4aa2c93', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'pump', '1x Pump', 'water_safety', ARRAY['StG_Statement of Fact_32-34 Connaught Square W2 2HL.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('3c17fa22-ba37-4807-b1e0-b9f8eadb9c1d', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'lift', 'Lift', 'lifts_safety', ARRAY['FBR113382303-20230405-B.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('5f57b9a2-85b2-49e1-8205-6a065383c8df', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'boiler', 'boilers', 'gas_safety', ARRAY['Real Estate Policy (01.23).pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('ac91e292-998e-4c07-b637-c077bce6ea1c', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'sprinkler', 'sprinkler leakage', 'fire_safety', ARRAY['Real Estate Policy (01.23).pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('3f0f20b8-24db-4df0-b116-d2d2fafefeba', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'pump', 'pumping', 'water_safety', ARRAY['Real Estate Policy (01.23).pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('ed2424f5-8f51-4e23-bfbd-a5e6be9b3f01', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'cctv', 'cameras', 'security', ARRAY['Real Estate Policy (01.23).pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('334d70cd-d493-4bc5-a468-b8d29735b8ea', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'fire_extinguisher', 'fire extinguishers', 'fire_safety', ARRAY['Real Estate Policy (01.23).pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('b256d771-64db-4335-af5b-49819712d4ed', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'communal_aerial', 'satellite dishes', 'other', ARRAY['Real Estate Policy (01.23).pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('9718af92-ff1f-4db4-a24d-908683c593a6', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'water_tank', 'water tanks', 'water_safety', ARRAY['Real Estate Policy (01.23).pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('3e7c8d3a-6b96-48d1-b86f-034c915a67da', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'sprinkler', 'sprinkler installation', 'fire_safety', ARRAY['Summary of Cover (01.23).pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('bb5f5ea4-6286-47ad-a60f-f5401940f2fb', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'lift', 'lift in', 'lifts_safety', ARRAY['Summary of Cover (01.23).pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('db8686d1-1654-4425-94e7-38494d11bf83', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'lift', 'Lift', 'lifts_safety', ARRAY['32-34 Connaught Sq Buildings Insurance 2023-2024.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('4e8ea569-09da-4f72-be99-3067f1e90a55', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'sprinkler', 'sprinkler installation', 'fire_safety', ARRAY['Zurich Real Estate Policy Summary.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('5dc5a347-7946-4427-a58e-dee7e371267e', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'lift', 'lift in', 'lifts_safety', ARRAY['Zurich Real Estate Policy Summary.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('30cb25ef-e862-413b-a6da-fc63c9cfdbcc', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'boiler', 'boilers', 'gas_safety', ARRAY['Zurich Real Estate Policy Wording.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('c21826d2-a1c7-4842-b0ee-fe216d6faaa3', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'sprinkler', 'sprinkler leakage', 'fire_safety', ARRAY['Zurich Real Estate Policy Wording.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('bb3d39e6-20ab-4cc5-bcbf-1657fa2d7439', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'pump', 'pumping', 'water_safety', ARRAY['Zurich Real Estate Policy Wording.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('65f28190-b8c8-4de4-8834-d3574220df31', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'cctv', 'cameras', 'security', ARRAY['Zurich Real Estate Policy Wording.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('c4a2434f-ecf6-4c0d-8bd6-22ae35bb5b68', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'fire_extinguisher', 'fire extinguishers', 'fire_safety', ARRAY['Zurich Real Estate Policy Wording.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('27600074-89b0-4de0-b95c-d72824c3a1e2', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'communal_aerial', 'satellite dishes', 'other', ARRAY['Zurich Real Estate Policy Wording.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('4ae6f289-f067-4944-97f2-50089cdf5611', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'water_tank', 'water tanks', 'water_safety', ARRAY['Zurich Real Estate Policy Wording.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('21e4f866-664a-4e54-b0a1-4ac4dfc95635', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'lift', 'Lift', 'lifts_safety', ARRAY['StG_Certificate_32-34 Connaught Square W2 2HL.pdf']);

-- Insert 22 maintenance schedules
INSERT INTO maintenance_schedules (id, building_id, contract_id, service_type, description, frequency, frequency_interval, next_due_date, estimated_duration, priority, status) VALUES ('b7a49e7e-c622-466a-854a-f89c7414e426', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', '6d00ab6b-af55-4b87-ae4e-c5b9d64462cf', 'lifts', 'lifts - ISS', 'monthly', '1 month', '2025-11-08', '4 hours', 'high', 'scheduled');
INSERT INTO maintenance_schedules (id, building_id, contract_id, service_type, description, frequency, frequency_interval, next_due_date, estimated_duration, priority, status) VALUES ('3e0fd486-140c-4e0c-a29a-5a8016e33505', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'ad4d8d1d-42dc-4f47-bd46-266634b41e7f', 'security', 'security - ISS', 'quarterly', '3 months', '2026-01-08', '8 hours', 'medium', 'scheduled');
INSERT INTO maintenance_schedules (id, building_id, contract_id, service_type, description, frequency, frequency_interval, next_due_date, estimated_duration, priority, status) VALUES ('5b5ade94-fabf-4aa0-b02f-5e0596cbf0f8', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'd06ca3dd-6799-4727-8a25-eb76af98ebeb', 'security', 'security - ISS', 'quarterly', '3 months', '2026-01-08', '8 hours', 'medium', 'scheduled');
INSERT INTO maintenance_schedules (id, building_id, contract_id, service_type, description, frequency, frequency_interval, next_due_date, estimated_duration, priority, status) VALUES ('1bc80530-b97f-4a49-8c49-6242d8c05486', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', '5fd758f3-7b00-454d-a08e-b27b7d49a850', 'lifts', 'lifts - ISS', 'monthly', '1 month', '2025-11-08', '4 hours', 'high', 'scheduled');
INSERT INTO maintenance_schedules (id, building_id, contract_id, service_type, description, frequency, frequency_interval, next_due_date, estimated_duration, priority, status) VALUES ('ab535a04-10de-48b0-8c7b-5dd7cd967ed9', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', '86c5c539-ef54-4922-8bf7-fde162285bf2', 'lifts', 'lifts - ISS', 'monthly', '1 month', '2025-11-08', '4 hours', 'high', 'scheduled');
INSERT INTO maintenance_schedules (id, building_id, contract_id, service_type, description, frequency, frequency_interval, next_due_date, estimated_duration, priority, status) VALUES ('3a84a63e-b27b-44c8-be50-962d754c2658', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', '473a9969-2eec-4058-aa28-223868dfe6ff', 'lifts', 'lifts - ISS', 'monthly', '1 month', '2025-11-08', '4 hours', 'high', 'scheduled');
INSERT INTO maintenance_schedules (id, building_id, contract_id, service_type, description, frequency, frequency_interval, next_due_date, estimated_duration, priority, status) VALUES ('5f68ce22-e735-4dee-a5c6-6cee3eafeda3', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'f0e8e3b9-ffdb-4cf4-96cc-f34a2a409d52', 'lifts', 'lifts - ISS', 'monthly', '1 month', '2025-11-08', '4 hours', 'high', 'scheduled');
INSERT INTO maintenance_schedules (id, building_id, contract_id, service_type, description, frequency, frequency_interval, next_due_date, estimated_duration, priority, status) VALUES ('410c8f31-815b-4cfe-a1bc-aca75a3d7375', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', '67c8b5fa-914e-454f-b346-445fbe5e95b7', 'lifts', 'lifts - ISS', 'annual', '12 months', '2026-03-14', '4 hours', 'high', 'scheduled');
INSERT INTO maintenance_schedules (id, building_id, contract_id, service_type, description, frequency, frequency_interval, next_due_date, estimated_duration, priority, status) VALUES ('b93c9c45-3929-4552-b919-17118a99ec15', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'f7f916ac-e991-47b7-91c0-425718a65e39', 'lifts', 'lifts - None', 'monthly', '1 month', '2025-02-13', '4 hours', 'high', 'scheduled');
INSERT INTO maintenance_schedules (id, building_id, contract_id, description, frequency, frequency_interval, next_due_date, priority, status) VALUES ('b915630f-f199-422f-bc17-5d932ab753db', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', '2804c0a5-34c0-4a26-9509-09ed3ce8391e', 'None - WHM', 'monthly', '1 month', '2025-11-08', 'medium', 'scheduled');
INSERT INTO maintenance_schedules (id, building_id, contract_id, description, frequency, frequency_interval, next_due_date, priority, status) VALUES ('87d4b2eb-6df4-47be-8e7a-c2fdacd5fe24', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'fd8fbadd-567d-4df7-b0a2-88a181abc3d3', 'None - WHM', 'monthly', '1 month', '2025-11-08', 'medium', 'scheduled');
INSERT INTO maintenance_schedules (id, building_id, contract_id, description, frequency, frequency_interval, next_due_date, priority, status) VALUES ('10753259-a562-4626-8598-53ba6f698529', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'ff854cbf-8595-42d5-a2ed-7e452320803d', 'None - WHM', 'monthly', '1 month', '2025-11-08', 'medium', 'scheduled');
INSERT INTO maintenance_schedules (id, building_id, contract_id, description, frequency, frequency_interval, next_due_date, priority, status) VALUES ('abc081f9-999d-4c24-a017-0cd6c8b3d4dc', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', '716aa335-a0bd-4405-bf4c-8f393747b464', 'None - WHM', 'monthly', '1 month', '2025-11-08', 'medium', 'scheduled');
INSERT INTO maintenance_schedules (id, building_id, contract_id, service_type, description, frequency, frequency_interval, next_due_date, estimated_duration, priority, status) VALUES ('acd836f5-2ea9-4388-8f5d-c0a56542d66f', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'fe94889a-cc21-48f2-860b-7ab756668cf0', 'security', 'security - Capita', 'monthly', '1 month', '2025-11-08', '8 hours', 'medium', 'scheduled');
INSERT INTO maintenance_schedules (id, building_id, contract_id, service_type, description, frequency, frequency_interval, next_due_date, estimated_duration, priority, status) VALUES ('eba131cb-6068-4f78-b15c-53ad3e6c0ead', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'b142c988-dbcf-4716-9af3-e2d303390f8d', 'fire_alarm', 'fire_alarm - Capita', 'monthly', '1 month', '2025-11-08', '2 hours', 'high', 'scheduled');
INSERT INTO maintenance_schedules (id, building_id, contract_id, service_type, description, frequency, frequency_interval, next_due_date, estimated_duration, priority, status) VALUES ('07e19729-b102-4beb-b205-aecf6ec1bb71', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'd6a22a5c-0174-4ae8-8042-6c191581b0a5', 'fire_alarm', 'fire_alarm - None', 'monthly', '1 month', '2025-11-08', '2 hours', 'high', 'scheduled');
INSERT INTO maintenance_schedules (id, building_id, contract_id, service_type, description, frequency, frequency_interval, next_due_date, estimated_duration, priority, status) VALUES ('0574041c-fa35-4382-9430-0425eae156b8', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'a4208235-d2e1-4a9f-878c-09d995e368ff', 'fire_alarm', 'fire_alarm - None', 'monthly', '1 month', '2025-11-08', '2 hours', 'high', 'scheduled');
INSERT INTO maintenance_schedules (id, building_id, contract_id, service_type, description, frequency, frequency_interval, next_due_date, estimated_duration, priority, status) VALUES ('d7d06bd0-b850-42e9-9aba-5315fa60db04', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', '1af34acf-42c5-450a-a028-c7986c875256', 'fire_alarm', 'fire_alarm - None', 'monthly', '1 month', '2025-11-08', '2 hours', 'high', 'scheduled');
INSERT INTO maintenance_schedules (id, building_id, contract_id, description, frequency, frequency_interval, next_due_date, priority, status) VALUES ('9c68e4d5-7beb-4b3a-9af0-53a078626c1a', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', '55d4e868-bb31-4e7d-a376-a6f6818dab2b', 'None - WHM', 'monthly', '1 month', '2025-11-08', 'medium', 'scheduled');
INSERT INTO maintenance_schedules (id, building_id, contract_id, description, frequency, frequency_interval, next_due_date, priority, status) VALUES ('459a6a2b-7c1e-44ed-aef7-c2180724b8ed', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', '3d9336cc-16a9-4410-8b27-535083fd31b6', 'None - None', 'monthly', '1 month', '2025-11-08', 'medium', 'scheduled');
INSERT INTO maintenance_schedules (id, building_id, contract_id, description, frequency, frequency_interval, next_due_date, priority, status) VALUES ('3617aa1c-b58d-45f8-9874-2e3d244a9d63', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'd2783b7d-ae37-4c95-a9de-66721378d8f5', 'None - None', 'monthly', '1 month', '2025-11-08', 'medium', 'scheduled');
INSERT INTO maintenance_schedules (id, building_id, contract_id, description, frequency, frequency_interval, next_due_date, priority, status) VALUES ('d335ab97-0591-4743-907d-1c40ddffa9a8', '40ac4afd-5ddd-4654-9eb7-3984aa510dd8', 'e9e5ecbd-d39c-4532-a579-0aa029ee4bf0', 'None - None', 'monthly', '1 month', '2025-11-08', 'medium', 'scheduled');

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
    '11cbb2a3-8f5a-41fc-b4af-7bac59275280',
    '40ac4afd-5ddd-4654-9eb7-3984aa510dd8',
    'be550639-fbba-4f6f-8ea9-3aed75f6485e',
    'Unknown',
    'service_charge',
    NULL  -- Requires manual entry
)
ON CONFLICT (id) DO NOTHING;

-- Fallback budget for unstructured PDF
INSERT INTO budgets (id, building_id, document_id, period, budget_type, total_amount)
VALUES (
    '00a4e40f-a6f8-4e4b-aaac-f1fdda8bc44f',
    '40ac4afd-5ddd-4654-9eb7-3984aa510dd8',
    '2d564b06-7769-4d92-a11f-5853376a1fbb',
    'Unknown',
    'service_charge',
    NULL  -- Requires manual entry
)
ON CONFLICT (id) DO NOTHING;

-- Fallback budget for unstructured PDF
INSERT INTO budgets (id, building_id, document_id, period, budget_type, total_amount)
VALUES (
    '3ab328f9-aa7e-40b5-8134-610632758af0',
    '40ac4afd-5ddd-4654-9eb7-3984aa510dd8',
    '21ee75ba-0c42-4381-9771-5651527b87b4',
    'Unknown',
    'service_charge',
    NULL  -- Requires manual entry
)
ON CONFLICT (id) DO NOTHING;

-- Fallback budget for unstructured PDF
INSERT INTO budgets (id, building_id, document_id, period, budget_type, total_amount)
VALUES (
    '2b4e8319-54ce-4343-ae78-474fb93fbdf6',
    '40ac4afd-5ddd-4654-9eb7-3984aa510dd8',
    'bcd92669-c176-4ac7-9581-cae6dc4e5a19',
    '2025',
    'service_charge',
    NULL  -- Requires manual entry
)
ON CONFLICT (id) DO NOTHING;

-- Fallback budget for unstructured PDF
INSERT INTO budgets (id, building_id, document_id, period, budget_type, total_amount)
VALUES (
    '44ed619a-1b96-4f6b-aa35-46ecb122f984',
    '40ac4afd-5ddd-4654-9eb7-3984aa510dd8',
    '55ef6361-4816-4cba-9838-dfe7a911347e',
    '2025',
    'service_charge',
    NULL  -- Requires manual entry
)
ON CONFLICT (id) DO NOTHING;

-- Fallback budget for unstructured PDF
INSERT INTO budgets (id, building_id, document_id, period, budget_type, total_amount)
VALUES (
    'e2ecaeb3-e4a6-4ddf-a791-5f796bb737c0',
    '40ac4afd-5ddd-4654-9eb7-3984aa510dd8',
    '007904c0-eef2-455d-9fae-a944159d02f0',
    '2025',
    'service_charge',
    NULL  -- Requires manual entry
)
ON CONFLICT (id) DO NOTHING;

-- Fallback budget for unstructured PDF
INSERT INTO budgets (id, building_id, document_id, period, budget_type, total_amount)
VALUES (
    '2149d50e-4af3-406c-93ba-a5ed4c7b83d1',
    '40ac4afd-5ddd-4654-9eb7-3984aa510dd8',
    '8b774a1b-564f-4de5-91fc-17f98b031596',
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
    'cef6a946-969b-4983-b8c1-2950e438bc7d',
    '40ac4afd-5ddd-4654-9eb7-3984aa510dd8',
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
    '696668e0-8e64-426e-aef3-7bca9ce59022',
    '40ac4afd-5ddd-4654-9eb7-3984aa510dd8',
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
    'be4f666e-d9d1-4bf9-aed8-e13c146013b5',
    '40ac4afd-5ddd-4654-9eb7-3984aa510dd8',
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
    '41453116-3583-4cc5-a37f-133415b23b76',
    '40ac4afd-5ddd-4654-9eb7-3984aa510dd8',
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
    '9e5ed022-1e90-47b1-8053-2107d8a6eacb',
    '40ac4afd-5ddd-4654-9eb7-3984aa510dd8',
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
    '2708cab3-0c79-42ec-96f9-772957abc19e',
    '40ac4afd-5ddd-4654-9eb7-3984aa510dd8',
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
    '5f3a2b35-a3f8-4317-8f78-cb86b4975035',
    '40ac4afd-5ddd-4654-9eb7-3984aa510dd8',
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
    '857a2b1a-d1d8-4e33-8f2f-d0c49992e4de',
    '40ac4afd-5ddd-4654-9eb7-3984aa510dd8',
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
    '4d30315e-cc3a-497d-8ec8-8696dbb229fc',
    '40ac4afd-5ddd-4654-9eb7-3984aa510dd8',
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
    '87e76cca-bb01-450e-8487-98d29437b321',
    '40ac4afd-5ddd-4654-9eb7-3984aa510dd8',
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
    '24c54588-81ca-4602-95b7-c2bb62c3e8d4',
    '40ac4afd-5ddd-4654-9eb7-3984aa510dd8',
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
    '8a2683ca-2783-4b9e-ae24-5983b9ad4635',
    '40ac4afd-5ddd-4654-9eb7-3984aa510dd8',
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
    '1906d696-2185-4f9e-b5e8-97084542377e',
    '40ac4afd-5ddd-4654-9eb7-3984aa510dd8',
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
    '44ef6d7c-d774-4b22-b300-f26f59ab5837',
    '40ac4afd-5ddd-4654-9eb7-3984aa510dd8',
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
    'ba1f9b7c-d69d-4d18-bb00-bad6dfbef9d7',
    '40ac4afd-5ddd-4654-9eb7-3984aa510dd8',
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
    'fbd545f0-9a9e-4e4b-b6fb-1426b11e4a91',
    '40ac4afd-5ddd-4654-9eb7-3984aa510dd8',
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
    '225fa381-a9a2-48d8-8a7e-691f350d40ea',
    '40ac4afd-5ddd-4654-9eb7-3984aa510dd8',
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
    '951f6738-948b-4341-92f5-2f0245182f54',
    '40ac4afd-5ddd-4654-9eb7-3984aa510dd8',
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
    'f766869b-56d8-49ef-aa1f-7da8c022b206',
    '40ac4afd-5ddd-4654-9eb7-3984aa510dd8',
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
    '7420cacb-1d92-4b56-bd46-bcfaaf394d53',
    '40ac4afd-5ddd-4654-9eb7-3984aa510dd8',
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
    '645a878a-3ea2-49df-899d-12315c6f7f53',
    '40ac4afd-5ddd-4654-9eb7-3984aa510dd8',
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
    '9c478184-93ad-4bf0-ab1e-721c532bd44f',
    '40ac4afd-5ddd-4654-9eb7-3984aa510dd8',
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
    '40e35981-3d2e-4407-953a-85a821343ed4',
    '40ac4afd-5ddd-4654-9eb7-3984aa510dd8',
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
    '7bcef447-ce7b-4501-a755-bf228882263b',
    '40ac4afd-5ddd-4654-9eb7-3984aa510dd8',
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
    'f202d058-db32-423f-8f97-033be5369016',
    '40ac4afd-5ddd-4654-9eb7-3984aa510dd8',
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
    '648e5ddf-230f-4f83-b13e-fefea861d091',
    '40ac4afd-5ddd-4654-9eb7-3984aa510dd8',
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
    'f27e5443-b676-41cb-b481-a61fbfaed96c',
    '40ac4afd-5ddd-4654-9eb7-3984aa510dd8',
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
    '52e2709d-b210-464d-bea9-87812e69f372',
    '40ac4afd-5ddd-4654-9eb7-3984aa510dd8',
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
    '5d73da2e-e73a-41ff-9d67-4c55e77a515f',
    '40ac4afd-5ddd-4654-9eb7-3984aa510dd8',
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
    'f01729d7-04f1-4150-b776-8a4f48e13c5b',
    '40ac4afd-5ddd-4654-9eb7-3984aa510dd8',
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
    'ff2382e3-0a0b-4b89-8dc3-8644e0919ba1',
    '40ac4afd-5ddd-4654-9eb7-3984aa510dd8',
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
    '04bf8237-eaa1-4e9b-950a-67602cb54689',
    '40ac4afd-5ddd-4654-9eb7-3984aa510dd8',
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
    '29f9c5e0-c03d-44a4-8129-1e46c63db076',
    '40ac4afd-5ddd-4654-9eb7-3984aa510dd8',
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
    '191cec47-9792-4621-8d69-10c6afca370c',
    '40ac4afd-5ddd-4654-9eb7-3984aa510dd8',
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
    'fe5f9348-8e27-4198-853c-8d6960c26dee',
    '40ac4afd-5ddd-4654-9eb7-3984aa510dd8',
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
    'd7e08f93-5bb8-406e-94a8-82e4f9b031cc',
    '40ac4afd-5ddd-4654-9eb7-3984aa510dd8',
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
    '024839ad-9eca-49a6-9340-d9104b76daa5',
    '40ac4afd-5ddd-4654-9eb7-3984aa510dd8',
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
    '03f68f87-de2c-456b-a5a1-c47c96161852',
    '40ac4afd-5ddd-4654-9eb7-3984aa510dd8',
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
    '591de2ed-201a-49e5-aca5-9ce0b22b6a36',
    '40ac4afd-5ddd-4654-9eb7-3984aa510dd8',
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
    '861b9354-7a5c-4d5c-877b-c6826b3b8ba3',
    '40ac4afd-5ddd-4654-9eb7-3984aa510dd8',
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
    '7801b486-996f-4ed1-bb47-05e6ee5bdb03',
    '40ac4afd-5ddd-4654-9eb7-3984aa510dd8',
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
    'e7959143-551c-47e1-8845-70d307942851',
    '40ac4afd-5ddd-4654-9eb7-3984aa510dd8',
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
    'b57eb6d1-35e7-4730-9ecb-409e786408e9',
    '40ac4afd-5ddd-4654-9eb7-3984aa510dd8',
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
    '9daf59de-1dca-466b-8a74-3874fcc42b6f',
    '40ac4afd-5ddd-4654-9eb7-3984aa510dd8',
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
    'c425317b-90a8-4925-bb9b-3866788dcd9a',
    '40ac4afd-5ddd-4654-9eb7-3984aa510dd8',
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
    'dccb9628-8e7b-47ba-b997-08f5e40e194b',
    '40ac4afd-5ddd-4654-9eb7-3984aa510dd8',
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
    'a2668d1e-755e-4350-8817-0027a23e2710',
    '40ac4afd-5ddd-4654-9eb7-3984aa510dd8',
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
    'ec6fc695-7f5b-4329-bf2c-250da679aa23',
    '40ac4afd-5ddd-4654-9eb7-3984aa510dd8',
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
    '6f5f2b49-71e4-4737-8de7-90371020f7ac',
    '40ac4afd-5ddd-4654-9eb7-3984aa510dd8',
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
    '19b077da-b688-44a9-85ee-5c700aa249ac',
    '40ac4afd-5ddd-4654-9eb7-3984aa510dd8',
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
    '04b38520-2175-477c-ad41-4f03627dc56f',
    '40ac4afd-5ddd-4654-9eb7-3984aa510dd8',
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
    'b4223a1f-4596-46e8-8b7e-84fa3ded4a69',
    '40ac4afd-5ddd-4654-9eb7-3984aa510dd8',
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
    '34c69a7e-c10f-4244-b4c5-5b2072dbdf9a',
    '40ac4afd-5ddd-4654-9eb7-3984aa510dd8',
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
    '6e05ec24-e3df-49e6-b186-d1ffb91e849a',
    '40ac4afd-5ddd-4654-9eb7-3984aa510dd8',
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
    'ee263b5e-f6be-4257-9ffa-11253383ae82',
    '40ac4afd-5ddd-4654-9eb7-3984aa510dd8',
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
    '6c874a85-9a13-4e01-a48c-143da6563d71',
    '40ac4afd-5ddd-4654-9eb7-3984aa510dd8',
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
    '64377d55-8c82-4f54-b650-75fa154c2e51',
    '40ac4afd-5ddd-4654-9eb7-3984aa510dd8',
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
    'b0e4eab7-ad54-4fd3-9fa9-a957c3db5124',
    '40ac4afd-5ddd-4654-9eb7-3984aa510dd8',
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
    '7abb60df-00d2-491a-9d38-2fd7f32b656b',
    '40ac4afd-5ddd-4654-9eb7-3984aa510dd8',
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
    '2b0e8796-6951-48c6-b1b6-c4063fdd6765',
    '40ac4afd-5ddd-4654-9eb7-3984aa510dd8',
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
    'ac40809a-db7b-47fe-abee-f248528ee6d0',
    '40ac4afd-5ddd-4654-9eb7-3984aa510dd8',
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
    '634c913d-0dc3-45a2-a1a3-ebaeac696a51',
    '40ac4afd-5ddd-4654-9eb7-3984aa510dd8',
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
    '46d90221-ec0a-46b4-85e6-31c5ac8db48a',
    '40ac4afd-5ddd-4654-9eb7-3984aa510dd8',
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
    '0aa3466c-591e-41b9-ad69-e520934cff18',
    '40ac4afd-5ddd-4654-9eb7-3984aa510dd8',
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
    '12c9ea67-c0fa-4e32-b47b-215583b1896c',
    '40ac4afd-5ddd-4654-9eb7-3984aa510dd8',
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
    '848f11a0-7560-4f05-b83b-bf648fa15378',
    '40ac4afd-5ddd-4654-9eb7-3984aa510dd8',
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
    '35d9df17-4c83-4383-9fef-663b3274bd8e',
    '40ac4afd-5ddd-4654-9eb7-3984aa510dd8',
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
    'bd77d60a-5ec7-4e09-baa9-4dc2056afc3e',
    '40ac4afd-5ddd-4654-9eb7-3984aa510dd8',
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
    '32365cbd-5551-46a2-a90a-6beb7d01c271',
    '40ac4afd-5ddd-4654-9eb7-3984aa510dd8',
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
    'adbca543-bdfa-4f96-9dfc-494f325db232',
    '40ac4afd-5ddd-4654-9eb7-3984aa510dd8',
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
    '679f4e4b-8546-4ace-9cb7-b530dc32a365',
    '40ac4afd-5ddd-4654-9eb7-3984aa510dd8',
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
    '7db1a2d1-e04e-492f-81d0-9439abeac6fd',
    '40ac4afd-5ddd-4654-9eb7-3984aa510dd8',
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
    '1bbcd89e-5471-49d8-a4d4-d9b5db4c67f3',
    '40ac4afd-5ddd-4654-9eb7-3984aa510dd8',
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
    '8243171b-f37b-454b-947a-65ab60e89f4f',
    '40ac4afd-5ddd-4654-9eb7-3984aa510dd8',
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
    'ba8a72de-6893-4da6-b1e7-94d9c9964c23',
    '40ac4afd-5ddd-4654-9eb7-3984aa510dd8',
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
    'c31625e6-3364-426d-bd9f-2ff1120bec6c',
    '40ac4afd-5ddd-4654-9eb7-3984aa510dd8',
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
    'c959828a-1e5b-443c-9730-70d8fac5f815',
    '40ac4afd-5ddd-4654-9eb7-3984aa510dd8',
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
    'c1bcf865-068f-4b91-b0da-634e40c4af6e',
    '40ac4afd-5ddd-4654-9eb7-3984aa510dd8',
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
    '3f2a809d-ccbd-43ae-8ef8-83f8d8117553',
    '40ac4afd-5ddd-4654-9eb7-3984aa510dd8',
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
    '786f97a6-c0fb-49d4-befa-104f3c191bbc',
    '40ac4afd-5ddd-4654-9eb7-3984aa510dd8',
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
    'e79a0915-13c5-4a02-aefb-110e869d04d5',
    '40ac4afd-5ddd-4654-9eb7-3984aa510dd8',
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
    '76fa8ed5-221e-46fd-a91a-8ed9860dac08',
    '40ac4afd-5ddd-4654-9eb7-3984aa510dd8',
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
    '7e2b0135-8fb5-46ab-be99-59e6c6fcfaa9',
    '40ac4afd-5ddd-4654-9eb7-3984aa510dd8',
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
    '2a22cd72-3e1b-4837-97f4-7b7b9cf9c0e3',
    '40ac4afd-5ddd-4654-9eb7-3984aa510dd8',
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
    'f41f8439-4e88-45e9-8416-56ac05e4229b',
    '40ac4afd-5ddd-4654-9eb7-3984aa510dd8',
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
    'd49b71f8-6282-4cea-981e-8fc175bda521',
    '40ac4afd-5ddd-4654-9eb7-3984aa510dd8',
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
    'cfef9883-cfa5-423e-aaa9-2c1f8c63bb10',
    '40ac4afd-5ddd-4654-9eb7-3984aa510dd8',
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
    '82e58b2d-bed6-46ec-b598-7cf19ae9e1d5',
    '40ac4afd-5ddd-4654-9eb7-3984aa510dd8',
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
    'ce3137dd-d1c7-4f67-a65c-46c0e84fe5c2',
    '40ac4afd-5ddd-4654-9eb7-3984aa510dd8',
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
    '69962f8f-aa0c-466d-b808-19d7304c4d07',
    '40ac4afd-5ddd-4654-9eb7-3984aa510dd8',
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
    '3eab9692-1565-46d7-bbee-2c0aa522ec93',
    '40ac4afd-5ddd-4654-9eb7-3984aa510dd8',
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
    'ccc60df8-294e-47d7-b8f2-a096ab6579aa',
    '40ac4afd-5ddd-4654-9eb7-3984aa510dd8',
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
    '39ca0a21-4cbd-413d-874c-d988b703a732',
    '40ac4afd-5ddd-4654-9eb7-3984aa510dd8',
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
    '55977d7c-4c4f-4a0a-b732-885818d2ee16',
    '40ac4afd-5ddd-4654-9eb7-3984aa510dd8',
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
    '196a86e9-e33b-424f-b35f-ec25f979015f',
    '40ac4afd-5ddd-4654-9eb7-3984aa510dd8',
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
    '0a059aea-120a-4288-bc3e-6ef133671153',
    '40ac4afd-5ddd-4654-9eb7-3984aa510dd8',
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
    'bf354da3-3497-4605-8b69-92020330ba22',
    '40ac4afd-5ddd-4654-9eb7-3984aa510dd8',
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
    '3ce0b434-859b-4cc3-b4c2-18ba02ea1e88',
    '40ac4afd-5ddd-4654-9eb7-3984aa510dd8',
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
    'b9eff80d-aa50-477f-8b51-79c27f6492c9',
    '40ac4afd-5ddd-4654-9eb7-3984aa510dd8',
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
    'e282287b-f165-4954-a8de-aac635b797bb',
    '40ac4afd-5ddd-4654-9eb7-3984aa510dd8',
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
    '8e8a61b8-9e5e-4ce4-9f43-c350b14aa561',
    '40ac4afd-5ddd-4654-9eb7-3984aa510dd8',
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
    '59cc9bad-5ce0-4e05-8267-0ac32cd82c7c',
    '40ac4afd-5ddd-4654-9eb7-3984aa510dd8',
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
    'd0822cfc-f429-45a1-a5e8-d245c38e769f',
    '40ac4afd-5ddd-4654-9eb7-3984aa510dd8',
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
    'd4ca0bc7-3f01-4972-b5d2-21d510e9b88e',
    '40ac4afd-5ddd-4654-9eb7-3984aa510dd8',
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
    '55b05beb-f214-4fab-81c5-702275e1a881',
    '40ac4afd-5ddd-4654-9eb7-3984aa510dd8',
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
    'b11509d9-f0fa-490d-a1db-c0437d9be52f',
    '40ac4afd-5ddd-4654-9eb7-3984aa510dd8',
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
    'fd948833-09a5-42a8-a69a-7c938d2fbc86',
    '40ac4afd-5ddd-4654-9eb7-3984aa510dd8',
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
    'b01effe1-670e-4e0e-993f-2b4e3124ecc4',
    '40ac4afd-5ddd-4654-9eb7-3984aa510dd8',
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
    'e7b40c84-e6b8-40ac-9bb0-473c226e424b',
    '40ac4afd-5ddd-4654-9eb7-3984aa510dd8',
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
    '40a696b6-df48-4635-9416-ebd30a577162',
    '40ac4afd-5ddd-4654-9eb7-3984aa510dd8',
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
    '0bb34c27-2d74-4289-867f-b17e3186b766',
    '40ac4afd-5ddd-4654-9eb7-3984aa510dd8',
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
    '6401a656-be99-4f62-a08b-572659aa3b05',
    '40ac4afd-5ddd-4654-9eb7-3984aa510dd8',
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
    '17028357-627b-4d94-a397-03c9bd2d173a',
    '40ac4afd-5ddd-4654-9eb7-3984aa510dd8',
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
    '4fc8f02d-79fa-455f-9141-18157e55e1bd',
    '40ac4afd-5ddd-4654-9eb7-3984aa510dd8',
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
    'a367f23a-f89a-4f5c-8320-d286402d52a7',
    '40ac4afd-5ddd-4654-9eb7-3984aa510dd8',
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
    'c7848f33-2fec-4cb4-a26d-0e45a080d971',
    '40ac4afd-5ddd-4654-9eb7-3984aa510dd8',
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
    'ea66c177-7be7-4aee-b6ea-87d168c452d6',
    '40ac4afd-5ddd-4654-9eb7-3984aa510dd8',
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
    'e7dcdb51-b9f9-4326-ac08-39f19f55a838',
    '40ac4afd-5ddd-4654-9eb7-3984aa510dd8',
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
    'e40b985f-cff3-4e8f-bc9f-2114a0f7bae7',
    '40ac4afd-5ddd-4654-9eb7-3984aa510dd8',
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
    '842c666a-bf48-427a-a231-0ade1ea49631',
    '40ac4afd-5ddd-4654-9eb7-3984aa510dd8',
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
    'd4623be2-8fdb-4240-851e-db43c5d2bd12',
    '40ac4afd-5ddd-4654-9eb7-3984aa510dd8',
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
    '703c749c-850a-4fed-9c8b-18c1f85352f6',
    '40ac4afd-5ddd-4654-9eb7-3984aa510dd8',
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
    'c683ebba-3ce0-4c44-a7bb-a4bfcd8cb5e7',
    '40ac4afd-5ddd-4654-9eb7-3984aa510dd8',
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
    '86ff5850-29b2-4f14-8fbf-59ccbd868482',
    '40ac4afd-5ddd-4654-9eb7-3984aa510dd8',
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
    'ae20cda9-b500-432a-84bc-ad7cbfeda461',
    '40ac4afd-5ddd-4654-9eb7-3984aa510dd8',
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
    'd3708952-ed80-4f4c-afb5-39773d6c005a',
    '40ac4afd-5ddd-4654-9eb7-3984aa510dd8',
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
    '43d6c967-aff8-4d6e-b568-1c81ca69e391',
    '40ac4afd-5ddd-4654-9eb7-3984aa510dd8',
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
    '214ad60f-0e22-4d2a-b58c-f75c686591a2',
    '40ac4afd-5ddd-4654-9eb7-3984aa510dd8',
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
    '949ef939-322d-4950-a2ec-f72aa547c345',
    '40ac4afd-5ddd-4654-9eb7-3984aa510dd8',
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
    '20b200a2-f18b-43d6-bba7-2983b6e32194',
    '40ac4afd-5ddd-4654-9eb7-3984aa510dd8',
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
    'bc5878d9-6421-45f2-8fe5-3402de18376d',
    '40ac4afd-5ddd-4654-9eb7-3984aa510dd8',
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
    '7714bd67-5d1c-41bd-8c91-0fb2fdc3c94d',
    '40ac4afd-5ddd-4654-9eb7-3984aa510dd8',
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
    'a9864353-3e46-428a-9c40-d8d70e5972e9',
    '40ac4afd-5ddd-4654-9eb7-3984aa510dd8',
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
    'cdd32432-6444-46a2-9172-115be39c86fb',
    '40ac4afd-5ddd-4654-9eb7-3984aa510dd8',
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
    '781ecfb8-d452-42e6-b70d-2da668e1b764',
    '40ac4afd-5ddd-4654-9eb7-3984aa510dd8',
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
    '8d91fff6-a47c-432e-96cc-47ab59225b25',
    '40ac4afd-5ddd-4654-9eb7-3984aa510dd8',
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
    'c37caf48-537b-4c2b-b61a-65712e6309e8',
    '40ac4afd-5ddd-4654-9eb7-3984aa510dd8',
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
    '3167c2d7-0f7d-41b6-8288-3e56c1474caf',
    '40ac4afd-5ddd-4654-9eb7-3984aa510dd8',
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
    'b0c6c127-3714-4f4c-966b-a0c738381694',
    '40ac4afd-5ddd-4654-9eb7-3984aa510dd8',
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
    'aa8af1de-dc67-455f-8e48-147893b4c908',
    '40ac4afd-5ddd-4654-9eb7-3984aa510dd8',
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
    'e416190f-bd6d-4c44-9032-f78ed4303266',
    '40ac4afd-5ddd-4654-9eb7-3984aa510dd8',
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
    '218a43fe-b351-4e76-9bb7-1531e3b2e51d',
    '40ac4afd-5ddd-4654-9eb7-3984aa510dd8',
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
    '531c4226-8b6d-4b67-806e-fdbb4af39614',
    '40ac4afd-5ddd-4654-9eb7-3984aa510dd8',
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
    '2274f772-01f2-4b4e-859e-996e35544643',
    '40ac4afd-5ddd-4654-9eb7-3984aa510dd8',
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
    'fba8b78f-a8fc-4687-826c-1d793b298240',
    '40ac4afd-5ddd-4654-9eb7-3984aa510dd8',
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
    '04f3c262-a5bd-40ae-b150-0c8d551eca52',
    '40ac4afd-5ddd-4654-9eb7-3984aa510dd8',
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
    'c57601c9-2253-4312-9054-85d5f89c921e',
    '40ac4afd-5ddd-4654-9eb7-3984aa510dd8',
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
    '34e61f3d-08fb-48cb-893f-e2eb26d1f4eb',
    '40ac4afd-5ddd-4654-9eb7-3984aa510dd8',
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
    'bc5e6724-5caa-4524-8acc-cc22c3014bf5',
    '40ac4afd-5ddd-4654-9eb7-3984aa510dd8',
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
    '0d9146b3-ef2b-4a10-a739-f27c7a4e9ab9',
    '40ac4afd-5ddd-4654-9eb7-3984aa510dd8',
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
    '4218030f-9e19-43d2-a257-1d1e234f1813',
    '40ac4afd-5ddd-4654-9eb7-3984aa510dd8',
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
    'c26e9440-22ce-4edf-bf7e-cf87e7640037',
    '40ac4afd-5ddd-4654-9eb7-3984aa510dd8',
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
    'faa6f45d-d625-4705-a55f-08ae098f2bc2',
    '40ac4afd-5ddd-4654-9eb7-3984aa510dd8',
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
    '78a1be1e-32e4-4de2-8dc2-61c0baf8c84e',
    '40ac4afd-5ddd-4654-9eb7-3984aa510dd8',
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
    '946d096d-ec1e-4c0e-a902-c837bf2ba048',
    '40ac4afd-5ddd-4654-9eb7-3984aa510dd8',
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
    '6db2d61a-29ff-4877-a149-b289b881019a',
    '40ac4afd-5ddd-4654-9eb7-3984aa510dd8',
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
    '37036b9e-7320-48e2-b5a5-f30121b81622',
    '40ac4afd-5ddd-4654-9eb7-3984aa510dd8',
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
    '73b5ec14-8e99-427b-a11d-04f600b1e5d8',
    '40ac4afd-5ddd-4654-9eb7-3984aa510dd8',
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
    '8e6a7bc2-1862-440c-8887-b155a546e3c2',
    '40ac4afd-5ddd-4654-9eb7-3984aa510dd8',
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
    '8048d6ce-8b2c-4d76-9072-faee25e7c68d',
    '40ac4afd-5ddd-4654-9eb7-3984aa510dd8',
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
    'df3bd2ec-99a8-4f46-9d08-292b0015de7c',
    '40ac4afd-5ddd-4654-9eb7-3984aa510dd8',
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
    '8302bb55-4fa8-46b4-9686-b55a2d0ce580',
    '40ac4afd-5ddd-4654-9eb7-3984aa510dd8',
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
    'fbc0a3dd-c6e0-4849-a493-de9361c348fa',
    '40ac4afd-5ddd-4654-9eb7-3984aa510dd8',
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
    'cbdccd43-446d-43a3-9696-bbd67be2d751',
    '40ac4afd-5ddd-4654-9eb7-3984aa510dd8',
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
    '5203f5cf-b2f1-4ee4-9796-0536767ef4d3',
    '40ac4afd-5ddd-4654-9eb7-3984aa510dd8',
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
    'da16790b-0561-4677-a47c-f7b126f50cd0',
    '40ac4afd-5ddd-4654-9eb7-3984aa510dd8',
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
    '4fbd09a7-1436-4f3c-9774-25889fc12819',
    '40ac4afd-5ddd-4654-9eb7-3984aa510dd8',
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
    '84b0e439-351c-4996-9fae-27a94e82733e',
    '40ac4afd-5ddd-4654-9eb7-3984aa510dd8',
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
    '40c4e54c-116a-482c-84cc-89919392f33d',
    '40ac4afd-5ddd-4654-9eb7-3984aa510dd8',
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
    '446d94ba-66d1-41ce-ae6e-8739a13b2efc',
    '40ac4afd-5ddd-4654-9eb7-3984aa510dd8',
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
    '14190d19-bc3f-49fb-958a-68650df198fe',
    '40ac4afd-5ddd-4654-9eb7-3984aa510dd8',
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
    '0e92c92b-45b9-43c3-b935-6dec28ee13d3',
    '40ac4afd-5ddd-4654-9eb7-3984aa510dd8',
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
    '79f69a01-0442-4952-9add-cd2e8329e2cf',
    '40ac4afd-5ddd-4654-9eb7-3984aa510dd8',
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
    '7e12bf0e-120c-4758-b7ae-40f3e1a2a22c',
    '40ac4afd-5ddd-4654-9eb7-3984aa510dd8',
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
    '37d2e3d6-318a-404a-bd40-b056ca2cbbab',
    '40ac4afd-5ddd-4654-9eb7-3984aa510dd8',
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
    '4a26ffd1-a385-4b90-b3ea-5a5057886182',
    '40ac4afd-5ddd-4654-9eb7-3984aa510dd8',
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
    '712018e9-0ebf-4663-9206-e85c4d80d182',
    '40ac4afd-5ddd-4654-9eb7-3984aa510dd8',
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
    '9b561c2f-6a40-47d7-b773-82cf7f30247e',
    '40ac4afd-5ddd-4654-9eb7-3984aa510dd8',
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
    '1551fbd2-d97f-4d03-aa35-fd1b6e5f58c7',
    '40ac4afd-5ddd-4654-9eb7-3984aa510dd8',
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
    '40704023-affe-491c-ae6e-12652376d99a',
    '40ac4afd-5ddd-4654-9eb7-3984aa510dd8',
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
    'b2c17f40-9ee6-4612-981a-46465edefaed',
    '40ac4afd-5ddd-4654-9eb7-3984aa510dd8',
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
    'cb76f1a5-8d35-48f9-9090-8d3f137ce795',
    '40ac4afd-5ddd-4654-9eb7-3984aa510dd8',
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
    'e36f5da2-9c95-4190-a517-75245c38c364',
    '40ac4afd-5ddd-4654-9eb7-3984aa510dd8',
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
    '115413e1-e89b-407d-b76d-32581e856e58',
    '40ac4afd-5ddd-4654-9eb7-3984aa510dd8',
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
    '13daab61-a4c0-4cbe-b967-04676bd9f3d6',
    '40ac4afd-5ddd-4654-9eb7-3984aa510dd8',
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
    '07137b2a-9ac7-49fa-b504-8a391da40d38',
    '40ac4afd-5ddd-4654-9eb7-3984aa510dd8',
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
    'd653d6a9-d23f-42af-ae1c-6d74850cd9c3',
    '40ac4afd-5ddd-4654-9eb7-3984aa510dd8',
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
    '03adcb40-8c45-4a43-b1c8-330d5e24815f',
    '40ac4afd-5ddd-4654-9eb7-3984aa510dd8',
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
    '87d195d7-2d6b-4bab-9ced-a955b0ded5b3',
    '40ac4afd-5ddd-4654-9eb7-3984aa510dd8',
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
    '89bc105d-8689-4263-aac9-e95878da0658',
    '40ac4afd-5ddd-4654-9eb7-3984aa510dd8',
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
    'a6815523-f8b2-4df4-adf0-3ca2cf039717',
    '40ac4afd-5ddd-4654-9eb7-3984aa510dd8',
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
    '11b0d8c9-d8cb-4c10-9654-9723989ad0f1',
    '40ac4afd-5ddd-4654-9eb7-3984aa510dd8',
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
    'f831b08d-b44a-4927-8727-7e9c03046cfc',
    '40ac4afd-5ddd-4654-9eb7-3984aa510dd8',
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
    '82b948e1-bf20-421f-ab70-e10eb41ed4cc',
    '40ac4afd-5ddd-4654-9eb7-3984aa510dd8',
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
    'aae11bfe-b215-4eac-ac31-df0074e91d34',
    '40ac4afd-5ddd-4654-9eb7-3984aa510dd8',
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
    '7f6916e9-b8d5-495d-83ec-e2ecc58ddeaf',
    '40ac4afd-5ddd-4654-9eb7-3984aa510dd8',
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
    '2e44c820-5a00-44a6-9d18-5eba99de944f',
    '40ac4afd-5ddd-4654-9eb7-3984aa510dd8',
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
    '71f311ca-7df2-46e1-9bc8-d4ceeb82e02d',
    '40ac4afd-5ddd-4654-9eb7-3984aa510dd8',
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
    '97981c4c-d705-4cfc-b387-afcdd2cb2d76',
    '40ac4afd-5ddd-4654-9eb7-3984aa510dd8',
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
    '039989ce-e35e-4737-bff0-030a65ebdddf',
    '40ac4afd-5ddd-4654-9eb7-3984aa510dd8',
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
    '474d5a35-a85c-4df2-be50-81839c09f384',
    '40ac4afd-5ddd-4654-9eb7-3984aa510dd8',
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
    '326f41fc-97dd-4ebd-9ab8-83cb29ad945a',
    '40ac4afd-5ddd-4654-9eb7-3984aa510dd8',
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
    'c3a5d103-b76d-420c-9056-39f420163a5a',
    '40ac4afd-5ddd-4654-9eb7-3984aa510dd8',
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
    '5b5c6187-763a-4e1d-ae7a-2ab4c1e51b58',
    '40ac4afd-5ddd-4654-9eb7-3984aa510dd8',
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
    '669a8537-7d78-43ed-99b2-4a83f2deafcd',
    '40ac4afd-5ddd-4654-9eb7-3984aa510dd8',
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
    'de0eb18e-1148-47cd-a924-95b41f02dbbc',
    '40ac4afd-5ddd-4654-9eb7-3984aa510dd8',
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
    'a1686746-1f7b-4b11-8de3-961bc03d3da2',
    '40ac4afd-5ddd-4654-9eb7-3984aa510dd8',
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
    '8966c26b-bcb7-4754-a72c-d9b40708b4ce',
    '40ac4afd-5ddd-4654-9eb7-3984aa510dd8',
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
    '741eb7d5-420b-4266-b2e6-9eae718f2c61',
    '40ac4afd-5ddd-4654-9eb7-3984aa510dd8',
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
    '82ef5d34-2f68-4fbe-91cd-9f1b9e208a5e',
    '40ac4afd-5ddd-4654-9eb7-3984aa510dd8',
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
    '220102a4-88a9-4a13-acde-b07461bac3f1',
    '40ac4afd-5ddd-4654-9eb7-3984aa510dd8',
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
    'c0913b1f-7d2c-4dc2-b91d-41d7229260a5',
    '40ac4afd-5ddd-4654-9eb7-3984aa510dd8',
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
    '0c2b5d8f-d2ed-4bdd-9747-ca82ce332988',
    '40ac4afd-5ddd-4654-9eb7-3984aa510dd8',
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
    '999ae501-acb6-4952-812e-9109acb81dd7',
    '40ac4afd-5ddd-4654-9eb7-3984aa510dd8',
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
    '5aaa767a-2669-47eb-95fb-5671a54e32f6',
    '40ac4afd-5ddd-4654-9eb7-3984aa510dd8',
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
    '4b312848-22c9-4f13-b4fe-d243c4b88e0a',
    '40ac4afd-5ddd-4654-9eb7-3984aa510dd8',
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
    '552a3a4d-ab4b-4f1d-a0d8-088ae913b84d',
    '40ac4afd-5ddd-4654-9eb7-3984aa510dd8',
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
    'f920231f-2194-43ca-8ddf-3b5d92c9eeed',
    '40ac4afd-5ddd-4654-9eb7-3984aa510dd8',
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
    'ef5e9dba-0986-4786-9fd4-4da50fa74067',
    '40ac4afd-5ddd-4654-9eb7-3984aa510dd8',
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
    '80bd7d84-2bbc-420c-904d-9316fdc08aac',
    '40ac4afd-5ddd-4654-9eb7-3984aa510dd8',
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
    'cf3d0c84-0141-48d3-ae48-352c773d605f',
    '40ac4afd-5ddd-4654-9eb7-3984aa510dd8',
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
    '285f1a0b-d5c7-40d2-ab4d-db8ee38d347c',
    '40ac4afd-5ddd-4654-9eb7-3984aa510dd8',
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
    '99bf39ca-0f54-4119-b72a-637d25f46cf9',
    '40ac4afd-5ddd-4654-9eb7-3984aa510dd8',
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
    '56e5d041-be66-4e28-827e-3011d21d7ef4',
    '40ac4afd-5ddd-4654-9eb7-3984aa510dd8',
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
    '2d8202a1-fa5f-4d07-a538-b236e35722c1',
    '40ac4afd-5ddd-4654-9eb7-3984aa510dd8',
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
    'f1894de5-9706-4bfb-ad1d-a80dc96f2f37',
    '40ac4afd-5ddd-4654-9eb7-3984aa510dd8',
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
    '1dfe4284-21f5-491d-9ee8-07ebe378d5c2',
    '40ac4afd-5ddd-4654-9eb7-3984aa510dd8',
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
    '5443e78a-8b49-40d6-a741-27ab268b15ee',
    '40ac4afd-5ddd-4654-9eb7-3984aa510dd8',
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
    'd1ea6509-8467-402e-a525-424684c69215',
    '40ac4afd-5ddd-4654-9eb7-3984aa510dd8',
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
    '9ee0559b-cc8f-497b-a370-ab0c16e6b2ab',
    '40ac4afd-5ddd-4654-9eb7-3984aa510dd8',
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
    '7db35403-a927-4a03-ad31-f601a8812467',
    '40ac4afd-5ddd-4654-9eb7-3984aa510dd8',
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
    '1f668813-033f-4447-9e0e-7c05daa06a68',
    '40ac4afd-5ddd-4654-9eb7-3984aa510dd8',
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
    '7bcc29c4-6d81-4dc2-8c5d-b6e000348303',
    '40ac4afd-5ddd-4654-9eb7-3984aa510dd8',
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
    '34d9fa6f-e923-4d61-ad28-7c166afe1851',
    '40ac4afd-5ddd-4654-9eb7-3984aa510dd8',
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
    'fad579c3-adbd-4f38-8acf-61938da48897',
    '40ac4afd-5ddd-4654-9eb7-3984aa510dd8',
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
    'a696002e-0322-455f-a767-7c8a27f21349',
    '40ac4afd-5ddd-4654-9eb7-3984aa510dd8',
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
    '9d96c302-8c65-4443-91a8-fa750bd608cd',
    '40ac4afd-5ddd-4654-9eb7-3984aa510dd8',
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
    'e134a9a4-7c4a-402d-99df-e7cf75f3b787',
    '40ac4afd-5ddd-4654-9eb7-3984aa510dd8',
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
    'e229f67d-c38c-4f1d-9653-59d43973f0ce',
    '40ac4afd-5ddd-4654-9eb7-3984aa510dd8',
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
    '25ea9859-182c-45a3-a0b6-263c539855a2',
    '40ac4afd-5ddd-4654-9eb7-3984aa510dd8',
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
    '55aa4f13-672b-421f-928c-7434795faf7a',
    '40ac4afd-5ddd-4654-9eb7-3984aa510dd8',
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
    '45aa5348-6050-48a1-b7f7-5533e15484e7',
    '40ac4afd-5ddd-4654-9eb7-3984aa510dd8',
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
    '0ab0e6a5-e0d5-4a94-a477-6de0ef67a4f3',
    '40ac4afd-5ddd-4654-9eb7-3984aa510dd8',
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
    '52de5306-6641-4d34-95ee-43c79f03534e',
    '40ac4afd-5ddd-4654-9eb7-3984aa510dd8',
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
    '4a7e1797-437b-403e-8e79-eb37390a6fb7',
    '40ac4afd-5ddd-4654-9eb7-3984aa510dd8',
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
    '38ceb97b-c8c2-41c5-a518-15a07cd59654',
    '40ac4afd-5ddd-4654-9eb7-3984aa510dd8',
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
    '764b5ac5-2c5a-4405-bd61-1e1513c58f44',
    '40ac4afd-5ddd-4654-9eb7-3984aa510dd8',
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
    'b66168de-f9c2-433d-b787-86496602ec72',
    '40ac4afd-5ddd-4654-9eb7-3984aa510dd8',
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
    '19514c95-776a-4846-b755-7e74568d7633',
    '40ac4afd-5ddd-4654-9eb7-3984aa510dd8',
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
    'ee98fa32-5c74-405b-9ae9-1506da2e83ad',
    '40ac4afd-5ddd-4654-9eb7-3984aa510dd8',
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
    'efe3f76d-7424-4cf9-ae1f-ddd79cf0cdb4',
    '40ac4afd-5ddd-4654-9eb7-3984aa510dd8',
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
    '7d3bb6e7-319e-42b8-a6ca-f31e7f9589c1',
    '40ac4afd-5ddd-4654-9eb7-3984aa510dd8',
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
    '09f47883-d5b7-43ee-8e8c-53c00f625fbf',
    '40ac4afd-5ddd-4654-9eb7-3984aa510dd8',
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
    '74a1b972-904f-411e-a084-3521054ab05b',
    '40ac4afd-5ddd-4654-9eb7-3984aa510dd8',
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
    '2d20b87e-acd0-42c8-90dd-de20677fbedb',
    '40ac4afd-5ddd-4654-9eb7-3984aa510dd8',
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
    '3df28034-f586-400b-a0e3-3f361fa74aeb',
    '40ac4afd-5ddd-4654-9eb7-3984aa510dd8',
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
    'be69bc15-5865-4382-882c-16e6cdcc40e3',
    '40ac4afd-5ddd-4654-9eb7-3984aa510dd8',
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
    'e58930ed-5adb-4239-8bc9-b132ff1e23c5',
    '40ac4afd-5ddd-4654-9eb7-3984aa510dd8',
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
    '243d7514-98e6-474c-a03e-be20963e8e17',
    '40ac4afd-5ddd-4654-9eb7-3984aa510dd8',
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
    '9be30925-f1df-4dee-b09f-b9f736cc3098',
    '40ac4afd-5ddd-4654-9eb7-3984aa510dd8',
    'boiler_location',
    'utilities',
    'Boiler',
    NULL,
    'Gaskets Very Very',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;
