-- ============================================================
-- PATCHED: BlocIQ Onboarder - Auto-generated Migration (Schema-Corrected)
-- Generated at: 2025-10-09T21:55:33.074618
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
INSERT INTO buildings (id, name, address) VALUES ('6f70b361-8781-47bc-934b-06892458b603', 'Connaught Square', 'CONNAUGHT SQUARE');

-- Insert 1 schedule(s)
INSERT INTO schedules (id, building_id, name, description) VALUES ('c9ffa88e-6f51-4b83-ab64-3dcc1d03bde4', '6f70b361-8781-47bc-934b-06892458b603', 'Main Schedule', 'Auto-detected schedule from onboarding');
-- Created schedules: Main Schedule

-- Insert 8 units
INSERT INTO units (id, building_id, unit_number) VALUES
('c0c997ba-06a1-422b-834b-11e7a98a2dad', '6f70b361-8781-47bc-934b-06892458b603', 'Flat 1'),
('4975937d-ac01-4190-8afc-acbe137b8e66', '6f70b361-8781-47bc-934b-06892458b603', 'Flat 2'),
('e6e6b660-a933-4fdd-b576-9e6695e354d0', '6f70b361-8781-47bc-934b-06892458b603', 'Flat 3'),
('d93a2de7-055a-44fa-a810-15ba15a1cd34', '6f70b361-8781-47bc-934b-06892458b603', 'Flat 4'),
('f3877866-d3ec-40f2-86f3-32c9046c01f1', '6f70b361-8781-47bc-934b-06892458b603', 'Flat 5'),
('da454b7f-860b-439b-8651-88a13a231556', '6f70b361-8781-47bc-934b-06892458b603', 'Flat 6'),
('d4706576-f9f5-4787-8fbc-0681af5d0190', '6f70b361-8781-47bc-934b-06892458b603', 'Flat 7'),
('4230a0dd-5b3e-4dac-ba71-ecb1e9f4909f', '6f70b361-8781-47bc-934b-06892458b603', 'Flat 8')
ON CONFLICT (id) DO NOTHING;

-- Insert 8 leaseholders (schema has building_id and unit_number)
INSERT INTO leaseholders (id, building_id, unit_id, unit_number, name) VALUES
('2685bcf7-22bb-4004-adb7-bfa1f68d0cbd', '6f70b361-8781-47bc-934b-06892458b603', 'c0c997ba-06a1-422b-834b-11e7a98a2dad', 'Flat 1', 'Marmotte Holdings Limited'),
('e6f69d37-6b9c-47df-b128-b76a9c48671f', '6f70b361-8781-47bc-934b-06892458b603', '4975937d-ac01-4190-8afc-acbe137b8e66', 'Flat 2', 'Ms V Rebulla'),
('bf1ea282-3ab4-4561-bbeb-9dd8ede3b90a', '6f70b361-8781-47bc-934b-06892458b603', 'e6e6b660-a933-4fdd-b576-9e6695e354d0', 'Flat 3', 'Ms V Rebulla'),
('96dc1773-eb71-453d-96c9-519f5a910079', '6f70b361-8781-47bc-934b-06892458b603', 'd93a2de7-055a-44fa-a810-15ba15a1cd34', 'Flat 4', 'Mr P J J Reynish & Ms C A O''Loughlin'),
('24274d90-07db-4e71-a914-1510492ba39b', '6f70b361-8781-47bc-934b-06892458b603', 'f3877866-d3ec-40f2-86f3-32c9046c01f1', 'Flat 5', 'Mr & Mrs M D Samworth'),
('bfa7aec3-f73e-4756-8634-610637bdbfc9', '6f70b361-8781-47bc-934b-06892458b603', 'da454b7f-860b-439b-8651-88a13a231556', 'Flat 6', 'Mr M D & Mrs C P Samworth'),
('2cfbe61e-5339-4cf4-9fe4-d0783db2ce94', '6f70b361-8781-47bc-934b-06892458b603', 'd4706576-f9f5-4787-8fbc-0681af5d0190', 'Flat 7', 'Ms J Gomm'),
('95618864-b31b-4f9e-b43e-97d01652dd32', '6f70b361-8781-47bc-934b-06892458b603', '4230a0dd-5b3e-4dac-ba71-ecb1e9f4909f', 'Flat 8', 'Miss T V Samwoth & Miss G E Samworth')
ON CONFLICT (id) DO NOTHING;

-- Insert 56 compliance assets
INSERT INTO compliance_assets (id, building_id, description, asset_name, asset_type, inspection_frequency, last_inspection_date, next_due_date, compliance_status, is_active) VALUES ('6ba37729-0a9c-4aea-b3d2-7731e42d6b95', '6f70b361-8781-47bc-934b-06892458b603', 'Extracted from 2024 Directors Meeting-Notes.docx', 'Compliance Asset', 'general', '12 months', '2024-01-01', '2025-01-01', 'overdue', TRUE);
INSERT INTO compliance_assets (id, building_id, description, asset_name, asset_type, inspection_frequency, compliance_status, location, is_active) VALUES ('39c6bf0b-adbd-4167-be26-c15a8a629860', '6f70b361-8781-47bc-934b-06892458b603', 'Extracted from Fire Door (Communal) Inspection (11m +) (7).pdf', 'Fire Door Inspection', 'fire_safety', '12 months', 'unknown', 'Communal', TRUE);
INSERT INTO compliance_assets (id, building_id, description, asset_name, asset_type, inspection_frequency, compliance_status, is_active) VALUES ('24d180b9-724c-4e09-bf30-116a3efdcefa', '6f70b361-8781-47bc-934b-06892458b603', 'Extracted from Fire Door (Flats) Inspection (11m +) (13).pdf', 'Fire Door Inspection', 'fire_safety', '12 months', 'unknown', TRUE);
INSERT INTO compliance_assets (id, building_id, description, asset_name, asset_type, inspection_frequency, compliance_status, is_active) VALUES ('1133a3d5-00c6-48de-9a8a-722e66359f88', '6f70b361-8781-47bc-934b-06892458b603', 'Extracted from Fire Door (Flats) Inspection (11m +) (18).pdf', 'Fire Door Inspection', 'fire_safety', '12 months', 'unknown', TRUE);
INSERT INTO compliance_assets (id, building_id, description, asset_name, asset_type, inspection_frequency, compliance_status, is_active) VALUES ('b8888d11-b64b-48cc-8556-3957824ee8e9', '6f70b361-8781-47bc-934b-06892458b603', 'Extracted from Fire Door (Flats) Inspection (11m +) (14).pdf', 'Fire Door Inspection', 'fire_safety', '12 months', 'unknown', TRUE);
INSERT INTO compliance_assets (id, building_id, description, asset_name, asset_type, inspection_frequency, compliance_status, is_active) VALUES ('0b51b66a-2b72-4786-b04f-674d61829a10', '6f70b361-8781-47bc-934b-06892458b603', 'Extracted from EICR Cuanku 32-34 conaught square.pdf', 'Electrical Installation Condition Report (EICR)', 'electrical', '60 months', 'unknown', TRUE);
INSERT INTO compliance_assets (id, building_id, description, asset_name, asset_type, inspection_frequency, compliance_status, is_active) VALUES ('a8c73556-9460-4a95-9905-344c7beaafc8', '6f70b361-8781-47bc-934b-06892458b603', 'Extracted from Fire Door (Flats) Inspection (11m +) (15).pdf', 'Fire Door Inspection', 'fire_safety', '12 months', 'unknown', TRUE);
INSERT INTO compliance_assets (id, building_id, description, asset_name, asset_type, inspection_frequency, last_inspection_date, next_due_date, compliance_status, is_active) VALUES ('6464c35d-36b5-40e0-a735-f495773d93ae', '6f70b361-8781-47bc-934b-06892458b603', 'Extracted from 221037_Fra1-L-394697-071223 32-34 Connaught Square_2024-01-02_163759 (1).pdf', 'Fire Risk Assessment (FRA)', 'fire_safety', '12 months', '2024-01-02', '2025-01-02', 'overdue', TRUE);
INSERT INTO compliance_assets (id, building_id, description, asset_name, asset_type, inspection_frequency, compliance_status, is_active) VALUES ('6cb4761c-3ab4-4214-87a3-5e2a15eb782a', '6f70b361-8781-47bc-934b-06892458b603', 'Extracted from Fire Door (Flats) Inspection (11m +) (19).pdf', 'Fire Door Inspection', 'fire_safety', '12 months', 'unknown', TRUE);
INSERT INTO compliance_assets (id, building_id, description, asset_name, asset_type, inspection_frequency, compliance_status, is_active) VALUES ('f09a9492-f5c7-47e8-a656-ddf79e3f5c85', '6f70b361-8781-47bc-934b-06892458b603', 'Extracted from 001132-3234-Connaught-Square-London.pdf', 'Compliance Asset', 'general', '12 months', 'unknown', TRUE);
INSERT INTO compliance_assets (id, building_id, description, asset_name, asset_type, inspection_frequency, last_inspection_date, next_due_date, compliance_status, is_active) VALUES ('8256829b-30a1-4aa6-b6c5-7a5c7c74404f', '6f70b361-8781-47bc-934b-06892458b603', 'Extracted from 221038_Hsra1-L-394697-071223 32-34 Connaught Square_2024-01-02_163759 (1).pdf', 'Compliance Asset', 'general', '12 months', '2024-01-02', '2025-01-02', 'overdue', TRUE);
INSERT INTO compliance_assets (id, building_id, description, asset_name, asset_type, inspection_frequency, compliance_status, is_active) VALUES ('f2a76ec9-53de-4cae-9635-1d1a3aff5f7b', '6f70b361-8781-47bc-934b-06892458b603', 'Extracted from TETRA - Asbestos Re-Inspection Survey 14.06.22.pdf', 'Compliance Asset', 'general', '12 months', 'unknown', TRUE);
INSERT INTO compliance_assets (id, building_id, description, asset_name, asset_type, inspection_frequency, compliance_status, is_active) VALUES ('9fc9e3cf-ad74-4a54-93db-2cf65bb27592', '6f70b361-8781-47bc-934b-06892458b603', 'Extracted from Fire Door (Flats) Inspection (11m +) (16).pdf', 'Fire Door Inspection', 'fire_safety', '12 months', 'unknown', TRUE);
INSERT INTO compliance_assets (id, building_id, description, asset_name, asset_type, inspection_frequency, compliance_status, is_active) VALUES ('0bc763e2-7d0a-42a2-bac1-6fed2c404a63', '6f70b361-8781-47bc-934b-06892458b603', 'Extracted from Fire Door (Flats) Inspection (11m +) (17).pdf', 'Fire Door Inspection', 'fire_safety', '12 months', 'unknown', TRUE);
INSERT INTO compliance_assets (id, building_id, description, asset_name, asset_type, inspection_frequency, compliance_status, is_active) VALUES ('c176f5b6-c03d-4749-97e7-a3710ae471d0', '6f70b361-8781-47bc-934b-06892458b603', 'Extracted from WHM Legionella Risk Assessment 07.06.22.pdf', 'Legionella Risk Assessment', 'water_safety', '24 months', 'unknown', TRUE);
INSERT INTO compliance_assets (id, building_id, description, asset_name, asset_type, inspection_frequency, last_inspection_date, next_due_date, compliance_status, is_active) VALUES ('69cf0ed6-0cac-468f-ae02-2ddaffb50302', '6f70b361-8781-47bc-934b-06892458b603', 'Extracted from EICR Report Cunaku SATISFACTORY 2023 .pdf', 'Electrical Installation Condition Report (EICR)', 'electrical', '60 months', '2023-01-01', '2028-01-01', 'compliant', TRUE);
INSERT INTO compliance_assets (id, building_id, description, asset_name, asset_type, inspection_frequency, last_inspection_date, next_due_date, compliance_status, is_active) VALUES ('98282f3f-a984-49af-a9a7-8cc2e4d7c65a', '6f70b361-8781-47bc-934b-06892458b603', 'Extracted from 2024 Directors Meeting-Notes.docx', 'Compliance Asset', 'general', '12 months', '2024-01-01', '2025-01-01', 'overdue', TRUE);
INSERT INTO compliance_assets (id, building_id, description, asset_name, asset_type, inspection_frequency, compliance_status, is_active) VALUES ('7626d7a1-46da-46ab-af4e-471fd6a66d94', '6f70b361-8781-47bc-934b-06892458b603', 'Extracted from 001457-3234-Connaught-Square-London Certificate.pdf', 'Compliance Asset', 'general', '12 months', 'unknown', TRUE);
INSERT INTO compliance_assets (id, building_id, description, asset_name, asset_type, inspection_frequency, compliance_status, is_active) VALUES ('69fb1816-cc91-4b55-b07d-4e93ef60a416', '6f70b361-8781-47bc-934b-06892458b603', 'Extracted from TC0001V31 General Terms and Conditions.pdf', 'Compliance Asset', 'general', '12 months', 'unknown', TRUE);
INSERT INTO compliance_assets (id, building_id, description, asset_name, asset_type, inspection_frequency, last_inspection_date, next_due_date, compliance_status, is_active) VALUES ('9491a244-519c-4dfe-b434-0ab0aa1036ba', '6f70b361-8781-47bc-934b-06892458b603', 'Extracted from Jobcard_For_Job_No_28992_24-01-2025_1545.pdf', 'Compliance Asset', 'general', '12 months', '2025-01-24', '2026-01-24', 'compliant', TRUE);
INSERT INTO compliance_assets (id, building_id, description, asset_name, asset_type, inspection_frequency, compliance_status, is_active) VALUES ('88b228b8-e260-4956-8da4-f631904cb5e8', '6f70b361-8781-47bc-934b-06892458b603', 'Extracted from Connaught Square (32-34) - 09.12.24 LRA.pdf', 'Compliance Asset', 'general', '12 months', 'unknown', TRUE);
INSERT INTO compliance_assets (id, building_id, description, asset_name, asset_type, inspection_frequency, compliance_status, is_active) VALUES ('c7875497-768b-4b44-a83b-a2f501adfb23', '6f70b361-8781-47bc-934b-06892458b603', 'Extracted from SC Certificate - 10072023.pdf', 'Compliance Asset', 'general', '12 months', 'unknown', TRUE);
INSERT INTO compliance_assets (id, building_id, description, asset_name, asset_type, inspection_frequency, compliance_status, location, is_active) VALUES ('2f43531f-db4e-49b8-99fa-6b54d87543c3', '6f70b361-8781-47bc-934b-06892458b603', 'Extracted from Fire Door (Communal) Inspection (11m +) (7).pdf', 'Fire Door Inspection', 'fire_safety', '12 months', 'unknown', 'Communal', TRUE);
INSERT INTO compliance_assets (id, building_id, description, asset_name, asset_type, inspection_frequency, compliance_status, is_active) VALUES ('bd34519c-c53f-4876-aab6-7fd20e4774f9', '6f70b361-8781-47bc-934b-06892458b603', 'Extracted from Fire Door (Flats) Inspection (11m +) (13).pdf', 'Fire Door Inspection', 'fire_safety', '12 months', 'unknown', TRUE);
INSERT INTO compliance_assets (id, building_id, description, asset_name, asset_type, inspection_frequency, compliance_status, is_active) VALUES ('7431579b-2354-495b-ba6f-5e51cad105fd', '6f70b361-8781-47bc-934b-06892458b603', 'Extracted from Fire Door (Flats) Inspection (11m +) (18).pdf', 'Fire Door Inspection', 'fire_safety', '12 months', 'unknown', TRUE);
INSERT INTO compliance_assets (id, building_id, description, asset_name, asset_type, inspection_frequency, compliance_status, is_active) VALUES ('f119d76e-5274-4c2f-826d-47bca834b6dc', '6f70b361-8781-47bc-934b-06892458b603', 'Extracted from Fire Door (Flats) Inspection (11m +) (14).pdf', 'Fire Door Inspection', 'fire_safety', '12 months', 'unknown', TRUE);
INSERT INTO compliance_assets (id, building_id, description, asset_name, asset_type, inspection_frequency, compliance_status, is_active) VALUES ('c5ef7c53-2f97-4699-8043-ca87e5b560f0', '6f70b361-8781-47bc-934b-06892458b603', 'Extracted from Fire Door (Flats) Inspection (11m +) (15).pdf', 'Fire Door Inspection', 'fire_safety', '12 months', 'unknown', TRUE);
INSERT INTO compliance_assets (id, building_id, description, asset_name, asset_type, inspection_frequency, compliance_status, is_active) VALUES ('ae8b88cd-e701-49c7-a3cb-194eb4e56448', '6f70b361-8781-47bc-934b-06892458b603', 'Extracted from Fire Door (Flats) Inspection (11m +) (19).pdf', 'Fire Door Inspection', 'fire_safety', '12 months', 'unknown', TRUE);
INSERT INTO compliance_assets (id, building_id, description, asset_name, asset_type, inspection_frequency, compliance_status, is_active) VALUES ('1d66c2da-9cf4-454f-8efc-5e3606134542', '6f70b361-8781-47bc-934b-06892458b603', 'Extracted from Fire Door (Flats) Inspection (11m +) (16).pdf', 'Fire Door Inspection', 'fire_safety', '12 months', 'unknown', TRUE);
INSERT INTO compliance_assets (id, building_id, description, asset_name, asset_type, inspection_frequency, compliance_status, is_active) VALUES ('b08a0fc5-0831-4568-b4de-c28f774a8199', '6f70b361-8781-47bc-934b-06892458b603', 'Extracted from Fire Door (Flats) Inspection (11m +) (17).pdf', 'Fire Door Inspection', 'fire_safety', '12 months', 'unknown', TRUE);
INSERT INTO compliance_assets (id, building_id, description, asset_name, asset_type, inspection_frequency, last_inspection_date, next_due_date, compliance_status, is_active) VALUES ('d76c4b30-2531-4f16-9b59-1813cd9963fe', '6f70b361-8781-47bc-934b-06892458b603', 'Extracted from 221037_Fra1-L-394697-071223 32-34 Connaught Square_2024-01-02_163759.pdf', 'Fire Risk Assessment (FRA)', 'fire_safety', '12 months', '2024-01-02', '2025-01-02', 'overdue', TRUE);
INSERT INTO compliance_assets (id, building_id, description, asset_name, asset_type, inspection_frequency, last_inspection_date, next_due_date, compliance_status, is_active) VALUES ('458f3988-dc15-4555-a4df-10a9f015bb22', '6f70b361-8781-47bc-934b-06892458b603', 'Extracted from Fire Door (Flats) Inspection (11m +) - 2024-01-24T120747.552.pdf', 'Fire Door Inspection', 'fire_safety', '12 months', '2024-01-24', '2025-01-24', 'overdue', TRUE);
INSERT INTO compliance_assets (id, building_id, description, asset_name, asset_type, inspection_frequency, compliance_status, is_active) VALUES ('dba358a6-ba1a-443e-a97d-fbac79a03484', '6f70b361-8781-47bc-934b-06892458b603', 'Extracted from Connaught Square (32-34) - 15.11.23 (886) wa.pdf', 'Compliance Asset', 'general', '12 months', 'unknown', TRUE);
INSERT INTO compliance_assets (id, building_id, description, asset_name, asset_type, inspection_frequency, last_inspection_date, next_due_date, compliance_status, is_active) VALUES ('fbb63362-39fb-4ac3-96b4-97991ee8d7ad', '6f70b361-8781-47bc-934b-06892458b603', 'Extracted from Fire Door (Flats) Inspection (11m +) - 2024-01-24T120745.875.pdf', 'Fire Door Inspection', 'fire_safety', '12 months', '2024-01-24', '2025-01-24', 'overdue', TRUE);
INSERT INTO compliance_assets (id, building_id, description, asset_name, asset_type, inspection_frequency, last_inspection_date, next_due_date, compliance_status, is_active) VALUES ('54c0079c-1dc7-4361-b8a8-26e01d576879', '6f70b361-8781-47bc-934b-06892458b603', 'Extracted from Fire Door (Flats) Inspection (11m +) - 2024-01-24T120746.424.pdf', 'Fire Door Inspection', 'fire_safety', '12 months', '2024-01-24', '2025-01-24', 'overdue', TRUE);
INSERT INTO compliance_assets (id, building_id, description, asset_name, asset_type, inspection_frequency, last_inspection_date, next_due_date, compliance_status, location, is_active) VALUES ('e18840c1-52d2-4f57-9caf-4e3504f5c2bd', '6f70b361-8781-47bc-934b-06892458b603', 'Extracted from Fire Door (Communal) Inspection (11m +) - 2024-01-24T120743.986.pdf', 'Fire Door Inspection', 'fire_safety', '12 months', '2024-01-24', '2025-01-24', 'overdue', 'Communal', TRUE);
INSERT INTO compliance_assets (id, building_id, description, asset_name, asset_type, inspection_frequency, last_inspection_date, next_due_date, compliance_status, is_active) VALUES ('5b8ef94a-f2ae-4886-8ef6-43c5399cfe50', '6f70b361-8781-47bc-934b-06892458b603', 'Extracted from Fire Door (Flats) Inspection (11m +) - 2024-01-24T120744.738.pdf', 'Fire Door Inspection', 'fire_safety', '12 months', '2024-01-24', '2025-01-24', 'overdue', TRUE);
INSERT INTO compliance_assets (id, building_id, description, asset_name, asset_type, inspection_frequency, last_inspection_date, next_due_date, compliance_status, is_active) VALUES ('07534db7-37b1-470b-9201-b99979153488', '6f70b361-8781-47bc-934b-06892458b603', 'Extracted from Fire Door (Flats) Inspection (11m +) - 2024-01-24T120747.015.pdf', 'Fire Door Inspection', 'fire_safety', '12 months', '2024-01-24', '2025-01-24', 'overdue', TRUE);
INSERT INTO compliance_assets (id, building_id, description, asset_name, asset_type, inspection_frequency, last_inspection_date, next_due_date, compliance_status, is_active) VALUES ('6cbd48d8-37bd-49df-832a-5982589f9dec', '6f70b361-8781-47bc-934b-06892458b603', 'Extracted from 221038_Hsra1-L-394697-071223 32-34 Connaught Square_2024-01-02_163759.pdf', 'Compliance Asset', 'general', '12 months', '2024-01-02', '2025-01-02', 'overdue', TRUE);
INSERT INTO compliance_assets (id, building_id, description, asset_name, asset_type, inspection_frequency, last_inspection_date, next_due_date, compliance_status, is_active) VALUES ('9b7c949d-42c2-49f2-8bd8-5e82c2d3be81', '6f70b361-8781-47bc-934b-06892458b603', 'Extracted from Fire Door (Flats) Inspection (11m +) - 2024-01-24T120745.174.pdf', 'Fire Door Inspection', 'fire_safety', '12 months', '2024-01-24', '2025-01-24', 'overdue', TRUE);
INSERT INTO compliance_assets (id, building_id, description, asset_name, asset_type, inspection_frequency, compliance_status, is_active) VALUES ('55b1be1d-9a1d-4d1e-bbbb-f3a516c08c77', '6f70b361-8781-47bc-934b-06892458b603', 'Extracted from Hsfra1-L-422971-210225 32-34 Connaught Square.pdf', 'Fire Risk Assessment (FRA)', 'fire_safety', '12 months', 'unknown', TRUE);
INSERT INTO compliance_assets (id, building_id, description, asset_name, asset_type, inspection_frequency, compliance_status, is_active) VALUES ('7e78545d-9b5a-4426-addf-9a258f5dc2a5', '6f70b361-8781-47bc-934b-06892458b603', 'Extracted from Hsfra1-L-422971-210225 32-34 Connaught Square.docx', 'Fire Risk Assessment (FRA)', 'fire_safety', '12 months', 'unknown', TRUE);
INSERT INTO compliance_assets (id, building_id, description, asset_name, asset_type, inspection_frequency, last_inspection_date, next_due_date, compliance_status, is_active) VALUES ('4cb7e56d-c9f7-4895-9129-032c4dd468d0', '6f70b361-8781-47bc-934b-06892458b603', 'Extracted from 221037_Fra1-L-394697-071223 32-34 Connaught Square_2024-01-02_163759 (1).pdf', 'Fire Risk Assessment (FRA)', 'fire_safety', '12 months', '2024-01-02', '2025-01-02', 'overdue', TRUE);
INSERT INTO compliance_assets (id, building_id, description, asset_name, asset_type, inspection_frequency, last_inspection_date, next_due_date, compliance_status, is_active) VALUES ('be580fbb-6e89-44a8-ac0c-a687e46c7f2e', '6f70b361-8781-47bc-934b-06892458b603', 'Extracted from 221038_Hsra1-L-394697-071223 32-34 Connaught Square_2024-01-02_163759 (1).pdf', 'Compliance Asset', 'general', '12 months', '2024-01-02', '2025-01-02', 'overdue', TRUE);
INSERT INTO compliance_assets (id, building_id, description, asset_name, asset_type, inspection_frequency, compliance_status, is_active) VALUES ('795a9163-8ce9-4c61-9c6a-e8e7d25a8e89', '6f70b361-8781-47bc-934b-06892458b603', 'Extracted from FRA-Connaught Square Reccommendations.xlsx', 'Fire Risk Assessment (FRA)', 'fire_safety', '12 months', 'unknown', TRUE);
INSERT INTO compliance_assets (id, building_id, description, asset_name, asset_type, inspection_frequency, compliance_status, is_active) VALUES ('c90c965a-ba41-4cc3-9f06-2b4e40bdea9b', '6f70b361-8781-47bc-934b-06892458b603', 'Extracted from 001534-3234-Connaught-Square-London.pdf', 'Compliance Asset', 'general', '12 months', 'unknown', TRUE);
INSERT INTO compliance_assets (id, building_id, description, asset_name, asset_type, inspection_frequency, compliance_status, is_active) VALUES ('5ea0c38d-177b-48c0-a4e3-67afdec7e141', '6f70b361-8781-47bc-934b-06892458b603', 'Extracted from C1047 - Job card.pdf', 'Compliance Asset', 'general', '12 months', 'unknown', TRUE);
INSERT INTO compliance_assets (id, building_id, description, asset_name, asset_type, inspection_frequency, compliance_status, is_active) VALUES ('2e2e2b09-841b-441b-a070-3ef2a7a8255a', '6f70b361-8781-47bc-934b-06892458b603', 'Extracted from WHM Legionella Risk Assessment 09.12.25.pdf', 'Legionella Risk Assessment', 'water_safety', '24 months', 'unknown', TRUE);
INSERT INTO compliance_assets (id, building_id, description, asset_name, asset_type, inspection_frequency, compliance_status, is_active) VALUES ('96af3f04-54db-436a-ae82-c5756aa90832', '6f70b361-8781-47bc-934b-06892458b603', 'Extracted from WHM Legionella Risk Assessment 07.06.22.pdf', 'Legionella Risk Assessment', 'water_safety', '24 months', 'unknown', TRUE);
INSERT INTO compliance_assets (id, building_id, description, asset_name, asset_type, inspection_frequency, compliance_status, is_active) VALUES ('2715d6c5-d847-4edf-aade-cdec7dc9aeb0', '6f70b361-8781-47bc-934b-06892458b603', 'Extracted from Connaught Square (32-34) - 29.05.25 (201) wa.pdf', 'Compliance Asset', 'general', '12 months', 'unknown', TRUE);
INSERT INTO compliance_assets (id, building_id, description, asset_name, asset_type, inspection_frequency, compliance_status, is_active) VALUES ('793cd5e4-c3cd-4a9f-9910-8ee9a8c3c9a1', '6f70b361-8781-47bc-934b-06892458b603', 'Extracted from EICR Cuanku 32-34 conaught square.pdf', 'Electrical Installation Condition Report (EICR)', 'electrical', '60 months', 'unknown', TRUE);
INSERT INTO compliance_assets (id, building_id, description, asset_name, asset_type, inspection_frequency, last_inspection_date, next_due_date, compliance_status, is_active) VALUES ('1187c0f7-a6e7-440d-80f9-ebcc0f426da2', '6f70b361-8781-47bc-934b-06892458b603', 'Extracted from EICR Report Cunaku SATISFACTORY 2023 .pdf', 'Electrical Installation Condition Report (EICR)', 'electrical', '60 months', '2023-01-01', '2028-01-01', 'compliant', TRUE);
INSERT INTO compliance_assets (id, building_id, description, asset_name, asset_type, inspection_frequency, compliance_status, is_active) VALUES ('20cd4503-28cc-4f64-bf02-278da46cc49e', '6f70b361-8781-47bc-934b-06892458b603', 'Extracted from 001132-3234-Connaught-Square-London.pdf', 'Compliance Asset', 'general', '12 months', 'unknown', TRUE);
INSERT INTO compliance_assets (id, building_id, description, asset_name, asset_type, inspection_frequency, compliance_status, is_active) VALUES ('adea3db5-9a0f-418a-95c1-361633c7a1e0', '6f70b361-8781-47bc-934b-06892458b603', 'Extracted from 001534-3234-Connaught-Square-London.pdf', 'Compliance Asset', 'general', '12 months', 'unknown', TRUE);
INSERT INTO compliance_assets (id, building_id, description, asset_name, asset_type, inspection_frequency, compliance_status, is_active) VALUES ('a8d42757-078f-48fc-ad3a-6782805926b7', '6f70b361-8781-47bc-934b-06892458b603', 'Extracted from FINAL L-432900 32-34 Connaught Square Management Survey Report Issue 1.pdf', 'Compliance Asset', 'general', '12 months', 'unknown', TRUE);
INSERT INTO compliance_assets (id, building_id, description, asset_name, asset_type, inspection_frequency, compliance_status, is_active) VALUES ('350eaf45-67ba-40fe-a08f-9966e1465236', '6f70b361-8781-47bc-934b-06892458b603', 'Extracted from TETRA - Asbestos Re-Inspection Survey 14.06.22.pdf', 'Compliance Asset', 'general', '12 months', 'unknown', TRUE);

-- Insert 4 major works projects
INSERT INTO major_works_projects (id, building_id, name, status, start_date) VALUES ('5f228144-0e18-4633-a42d-dd1f3d300b17', '6f70b361-8781-47bc-934b-06892458b603', 'External Decoration - 2025', 'planning', '2025-01-01');
INSERT INTO major_works_projects (id, building_id, name, status, start_date) VALUES ('6d65114c-78db-4df0-a300-3ca30f7979fa', '6f70b361-8781-47bc-934b-06892458b603', 'Section 20 Consultation (SOE) - 2025', 'planning', '2025-01-01');
INSERT INTO major_works_projects (id, building_id, name, status, start_date) VALUES ('689f8bda-5fd5-4c31-92c0-61a13439a4df', '6f70b361-8781-47bc-934b-06892458b603', 'Lift - Section 20 (NOI) - 2025', 'planning', '2025-01-01');
INSERT INTO major_works_projects (id, building_id, name, status, start_date) VALUES ('18b66388-6560-4049-bef3-470f92c58c7d', '6f70b361-8781-47bc-934b-06892458b603', 'Major Works Project - 2025', 'planning', '2025-01-01');

-- Insert 22 budgets
INSERT INTO budgets (id, building_id, year_start, year_end, period) VALUES ('b2789ad4-b2a3-49fa-98b0-f09ed7cbccb8', '6f70b361-8781-47bc-934b-06892458b603', '2025-04-01', '2026-03-31', '2025');
INSERT INTO budgets (id, building_id, year_start, year_end, period) VALUES ('219b8401-38a3-4ef3-ab01-789ab3bf3fb9', '6f70b361-8781-47bc-934b-06892458b603', '2025-04-01', '2026-03-31', '2025');
INSERT INTO budgets (id, building_id, year_start, year_end, period) VALUES ('02ba024d-02cf-4164-a63b-520dd74461a2', '6f70b361-8781-47bc-934b-06892458b603', '2025-04-01', '2026-03-31', '2025');
INSERT INTO budgets (id, building_id, year_start, year_end, period) VALUES ('8f1689ef-c908-4c91-b19b-840d93a43ce4', '6f70b361-8781-47bc-934b-06892458b603', '2025-04-01', '2026-03-31', '2025');
INSERT INTO budgets (id, building_id, year_start, year_end, period) VALUES ('2f1e0edf-b467-40db-af5b-fa0b7c383ec5', '6f70b361-8781-47bc-934b-06892458b603', '2025-04-01', '2026-03-31', '2025');
INSERT INTO budgets (id, building_id, year_start, year_end, period) VALUES ('15d4ab4a-7c5a-458f-ae4f-2e8b0169acd4', '6f70b361-8781-47bc-934b-06892458b603', '2025-04-01', '2026-03-31', '2025');
INSERT INTO budgets (id, building_id, year_start, year_end, period) VALUES ('4341d8a5-d704-4cd2-9fea-a2172e0cc7c9', '6f70b361-8781-47bc-934b-06892458b603', '2025-04-01', '2026-03-31', '2025');
INSERT INTO budgets (id, building_id, year_start, year_end, period) VALUES ('795194fd-2b95-42b8-955a-3e1d9a26314d', '6f70b361-8781-47bc-934b-06892458b603', '2025-04-01', '2026-03-31', '2025');
INSERT INTO budgets (id, building_id, year_start, year_end, period) VALUES ('aa59e939-106e-47f8-bdd7-2a32b27527a2', '6f70b361-8781-47bc-934b-06892458b603', '2025-04-01', '2026-03-31', '2025');
INSERT INTO budgets (id, building_id, year_start, year_end, period) VALUES ('75bbc1a7-f82b-4442-aa4c-f453d5856c9e', '6f70b361-8781-47bc-934b-06892458b603', '2025-04-01', '2026-03-31', '2025');
INSERT INTO budgets (id, building_id, year_start, year_end, period) VALUES ('0894a7c5-60a4-4ba5-9a8e-b725aed47f84', '6f70b361-8781-47bc-934b-06892458b603', '2025-04-01', '2026-03-31', '2025');
INSERT INTO budgets (id, building_id, year_start, year_end, period) VALUES ('232df20c-69d3-48a3-bff1-47acadd6bf67', '6f70b361-8781-47bc-934b-06892458b603', '2025-04-01', '2026-03-31', '2025');
INSERT INTO budgets (id, building_id, year_start, year_end, period) VALUES ('b0934226-c2d5-4160-97a9-eb78d886a4fb', '6f70b361-8781-47bc-934b-06892458b603', '2025-04-01', '2026-03-31', '2025');
INSERT INTO budgets (id, building_id, year_start, year_end, period) VALUES ('4e6e93fc-6eb6-411d-aa7c-b74760cf6422', '6f70b361-8781-47bc-934b-06892458b603', '2025-04-01', '2026-03-31', '2025');
INSERT INTO budgets (id, building_id, year_start, year_end, period) VALUES ('a713e5b6-a633-4649-8306-4bf3b92e5f51', '6f70b361-8781-47bc-934b-06892458b603', '2025-04-01', '2026-03-31', '2025');
INSERT INTO budgets (id, building_id, year_start, year_end, period) VALUES ('db6f188a-f2b6-4747-bd72-fb8f563d78bb', '6f70b361-8781-47bc-934b-06892458b603', '2025-04-01', '2026-03-31', '2025');
INSERT INTO budgets (id, building_id, year_start, year_end, period) VALUES ('6e18f401-96c5-46df-b2f7-e81ceb8b2a1e', '6f70b361-8781-47bc-934b-06892458b603', '2025-04-01', '2026-03-31', '2025');
INSERT INTO budgets (id, building_id, year_start, year_end, period) VALUES ('d6825a99-02e7-484e-b33b-35027c549a26', '6f70b361-8781-47bc-934b-06892458b603', '2025-04-01', '2026-03-31', '2025');
INSERT INTO budgets (id, building_id, year_start, year_end, period) VALUES ('31ef9cc6-30f6-4937-af27-817aebaa6711', '6f70b361-8781-47bc-934b-06892458b603', '2025-04-01', '2026-03-31', '2025');
INSERT INTO budgets (id, building_id, year_start, year_end, period) VALUES ('339c64bc-e121-4895-8c40-39dcbccbf23a', '6f70b361-8781-47bc-934b-06892458b603', '2025-04-01', '2026-03-31', '2025');
INSERT INTO budgets (id, building_id, year_start, year_end, period) VALUES ('aaa26c76-fe86-4592-aee8-44ca8cf8c578', '6f70b361-8781-47bc-934b-06892458b603', '2025-04-01', '2026-03-31', '2025');
INSERT INTO budgets (id, building_id, year_start, year_end, period) VALUES ('1faff437-cd38-439c-8816-bca455b9461b', '6f70b361-8781-47bc-934b-06892458b603', '2025-04-01', '2026-03-31', '2025');

-- Insert 318 document records
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('977b8053-b55a-4c81-9a85-04a0eea83996', '6f70b361-8781-47bc-934b-06892458b603', 'leases', 'Important Information .pdf', 'leases/Important Information .pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('3da25336-f812-47c1-886c-6b6b2caf9ece', '6f70b361-8781-47bc-934b-06892458b603', 'other', 'ACCOUNTS - YE 31.03.21 - Service Charge Accounts (1).pdf', 'other/ACCOUNTS - YE 31.03.21 - Service Charge Accounts (1).pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('33ef6b83-66cf-4c7e-a677-d67d964e66f9', '6f70b361-8781-47bc-934b-06892458b603', 'leases', 'Official Copy (Lease) 04.08.2022 - NGL809841 (1).pdf', 'leases/Official Copy (Lease) 04.08.2022 - NGL809841 (1).pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('470c3fe5-5323-4ee2-951e-6fa39659ca7f', '6f70b361-8781-47bc-934b-06892458b603', 'leases', 'Official Copy (Lease) 04.08.2022 - NGL809841 (2).pdf', 'leases/Official Copy (Lease) 04.08.2022 - NGL809841 (2).pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('a25703e0-7871-4700-b947-e55267a5d103', '6f70b361-8781-47bc-934b-06892458b603', 'leases', 'Official Copy (Lease) 13.06.2003 - NGL827422.pdf', 'leases/Official Copy (Lease) 13.06.2003 - NGL827422.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('cbedb3d1-e0ca-47cf-9d3f-19e30bd0dcf3', '6f70b361-8781-47bc-934b-06892458b603', 'leases', 'Official Copy (Lease) 04.08.2022 - NGL809841.pdf', 'leases/Official Copy (Lease) 04.08.2022 - NGL809841.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('5beb4419-4ee6-44fe-bd18-9a8f05b14719', '6f70b361-8781-47bc-934b-06892458b603', 'leases', 'Signed April 2025 Arrears Collection Procedure.pdf', 'leases/Signed April 2025 Arrears Collection Procedure.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('7daf496b-b7da-4de9-8a8e-90837485fb36', '6f70b361-8781-47bc-934b-06892458b603', 'leases', 'WP0005V17 Welcome Pack.pdf', 'leases/WP0005V17 Welcome Pack.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('5ad860e6-91cb-4f52-95ac-e8024de4f971', '6f70b361-8781-47bc-934b-06892458b603', 'leases', 'Jobcard_For_Job_No_33844_07-04-2025_1143.pdf', 'leases/Jobcard_For_Job_No_33844_07-04-2025_1143.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('9eb64679-ee46-4a03-afa4-96c9b8dfa64e', '6f70b361-8781-47bc-934b-06892458b603', 'leases', 'Jobcard_For_Job_No_37675_25-07-2025_1549.pdf', 'leases/Jobcard_For_Job_No_37675_25-07-2025_1549.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('bcf00034-302c-4156-96fd-cd24e5853cd2', '6f70b361-8781-47bc-934b-06892458b603', 'leases', 'Jobcard_For_Job_No_34012_01-05-2025_1616.pdf', 'leases/Jobcard_For_Job_No_34012_01-05-2025_1616.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('f52fee35-6909-4a37-91a9-32dbb0964f0b', '6f70b361-8781-47bc-934b-06892458b603', 'leases', 'Jobcard_For_Job_No_32759_17-03-2025_1145.pdf', 'leases/Jobcard_For_Job_No_32759_17-03-2025_1145.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('5487ea5d-01f0-4d68-b8c9-2bbd3827327f', '6f70b361-8781-47bc-934b-06892458b603', 'leases', 'Jobcard_For_Job_No_32810_17-03-2025_1311.pdf', 'leases/Jobcard_For_Job_No_32810_17-03-2025_1311.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('85fad14b-e0f6-4e0b-ab85-0eef3281dc63', '6f70b361-8781-47bc-934b-06892458b603', 'other', 'Quote_No_23550 - Connaught Square (32-34) 2023-2024.pdf', 'other/Quote_No_23550 - Connaught Square (32-34) 2023-2024.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('1892c932-7abc-4496-92fe-d01e597862a2', '6f70b361-8781-47bc-934b-06892458b603', 'leases', 'Licence_Document_352024.pdf', 'leases/Licence_Document_352024.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('c9d055f0-29ef-4d5f-8121-0dc76826e4b5', '6f70b361-8781-47bc-934b-06892458b603', 'leases', 'JLGServiceVisit-M00813-12-09-2024.pdf', 'leases/JLGServiceVisit-M00813-12-09-2024.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('b73ab750-6287-4686-b0cc-5c61b5c235aa', '6f70b361-8781-47bc-934b-06892458b603', 'leases', 'JLGServiceVisit-M00813-13-11-2024.pdf', 'leases/JLGServiceVisit-M00813-13-11-2024.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('5344a113-c5af-48b5-b257-6de913040554', '6f70b361-8781-47bc-934b-06892458b603', 'leases', 'JLGServiceVisit-M00813-02-12-2024.pdf', 'leases/JLGServiceVisit-M00813-02-12-2024.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('497fc06c-70ba-42ab-a346-00accae4b5ea', '6f70b361-8781-47bc-934b-06892458b603', 'leases', 'JLGServiceVisit-M00813-08-07-2024.pdf', 'leases/JLGServiceVisit-M00813-08-07-2024.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('2a966d16-5ed8-4d7d-96c0-65b9dd5a809d', '6f70b361-8781-47bc-934b-06892458b603', 'leases', 'JLGServiceVisit-M00813-08-10-2024.pdf', 'leases/JLGServiceVisit-M00813-08-10-2024.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('a40e216b-001a-4ca8-ac0f-aa66626a00de', '6f70b361-8781-47bc-934b-06892458b603', 'leases', 'JLGServiceVisit-M00813-12-02-2025.pdf', 'leases/JLGServiceVisit-M00813-12-02-2025.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('7954bb43-49f8-4630-b71c-755d45a809ae', '6f70b361-8781-47bc-934b-06892458b603', 'leases', 'JLGServiceVisit-M00813-17-03-2025.pdf', 'leases/JLGServiceVisit-M00813-17-03-2025.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('c4045e53-aa12-4ac0-96c0-352c0111417f', '6f70b361-8781-47bc-934b-06892458b603', 'leases', 'JLGServiceVisit-M00813-14-04-2025.pdf', 'leases/JLGServiceVisit-M00813-14-04-2025.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('2461233c-f3a5-4491-a630-bcf1d992d0be', '6f70b361-8781-47bc-934b-06892458b603', 'leases', 'REP-40343473-L1.pdf', 'leases/REP-40343473-L1.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('b598fcc5-89f5-4113-8016-873217975e39', '6f70b361-8781-47bc-934b-06892458b603', 'leases', 'JLGServiceVisit-M00813-13-05-2025.pdf', 'leases/JLGServiceVisit-M00813-13-05-2025.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('e55fc687-afc4-47bc-b35c-2afab80697a0', '6f70b361-8781-47bc-934b-06892458b603', 'leases', 'Communal Cleaning-First Port.pdf', 'leases/Communal Cleaning-First Port.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('5b962bf9-71c7-4de7-a8e3-712ad2472a38', '6f70b361-8781-47bc-934b-06892458b603', 'leases', 'SC Health and Safety Product - Accredited 10072023.pdf', 'leases/SC Health and Safety Product - Accredited 10072023.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('a468dbc1-37ac-421d-97d7-a94645f81651', '6f70b361-8781-47bc-934b-06892458b603', 'leases', 'Tenancy Schedule by Property.pdf', 'leases/Tenancy Schedule by Property.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('34dcca06-6652-43e4-aed0-62cd191490d8', '6f70b361-8781-47bc-934b-06892458b603', 'other', 'Accounts YE 31.03.2022 32-34 Connaught Square MJP.pdf', 'other/Accounts YE 31.03.2022 32-34 Connaught Square MJP.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('42195991-225b-4218-aed0-594e5f4c40c1', '6f70b361-8781-47bc-934b-06892458b603', 'other', '197-YE 31.03.22 SC Accs FINAL MAY 2023.pdf', 'other/197-YE 31.03.22 SC Accs FINAL MAY 2023.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('19cfc09b-dc3f-4cdb-be66-2d5ee00ddc70', '6f70b361-8781-47bc-934b-06892458b603', 'other', 'ACCOUNTS - YE 31.03.21 - Service Charge Accounts (1).pdf', 'other/ACCOUNTS - YE 31.03.21 - Service Charge Accounts (1).pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('746b372a-b4f8-4289-9ad1-e2caab5e28c3', '6f70b361-8781-47bc-934b-06892458b603', 'other', '27039 Accounts Pack - YE 2023.pdf', 'other/27039 Accounts Pack - YE 2023.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('f5222ade-a74c-4b3c-ac67-17adf074a8a1', '6f70b361-8781-47bc-934b-06892458b603', 'other', 'Connaught Sq SC YE 23.pdf', 'other/Connaught Sq SC YE 23.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('dbab027d-9394-4367-8530-0acf3481dbd4', '6f70b361-8781-47bc-934b-06892458b603', 'leases', 'Connaught Square-House Rules.docx', 'leases/Connaught Square-House Rules.docx');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('3df3f103-33f5-47fc-a613-71eb6752ad18', '6f70b361-8781-47bc-934b-06892458b603', 'other', 'Garden Notice-Connaught Square.docx', 'other/Garden Notice-Connaught Square.docx');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('ca3bcff2-2426-4961-bee2-c091174ea93d', '6f70b361-8781-47bc-934b-06892458b603', 'other', 'Connaught Square-Key Cut Authorisation Letter.docx', 'other/Connaught Square-Key Cut Authorisation Letter.docx');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('cbd1159b-1a07-43f1-a539-ed6ec85bfccc', '6f70b361-8781-47bc-934b-06892458b603', 'leases', 'House Rules-Connaught Square.pdf', 'leases/House Rules-Connaught Square.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('cf55f0fe-6667-4e2d-af1f-cb2e06342ed6', '6f70b361-8781-47bc-934b-06892458b603', 'leases', 'REP-39659654.pdf', 'leases/REP-39659654.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('624a6134-2e0b-4eee-99aa-d64a50c5654e', '6f70b361-8781-47bc-934b-06892458b603', 'leases', 'Important Information .pdf', 'leases/Important Information .pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('1b679484-3a81-4e28-8546-e6549a72df95', '6f70b361-8781-47bc-934b-06892458b603', 'leases', 'StG_Certificate_32-34 Connaught Square W2 2HL.pdf', 'leases/StG_Certificate_32-34 Connaught Square W2 2HL.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('22ecd67b-da5a-4f7e-8903-13e5cf848250', '6f70b361-8781-47bc-934b-06892458b603', 'other', 'CM434.AnnualServiceAgreement2025-2026.pdf', 'other/CM434.AnnualServiceAgreement2025-2026.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('cdbd8452-8494-41dc-8016-94b66ac35dc1', '6f70b361-8781-47bc-934b-06892458b603', 'other', 'CM434.AnnualServiceAgreement2024-2025.pdf', 'other/CM434.AnnualServiceAgreement2024-2025.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('dfda7cbf-0196-47db-adfe-6d712af23403', '6f70b361-8781-47bc-934b-06892458b603', 'leases', 'REP-40324834-E3.pdf', 'leases/REP-40324834-E3.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('99229271-55dc-4ecc-a8b3-56eab8a9b829', '6f70b361-8781-47bc-934b-06892458b603', 'leases', 'Ellie@mihproperty.co.uk - BES Group - E-Report.pdf', 'leases/Ellie@mihproperty.co.uk - BES Group - E-Report.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('1ff8b642-90f1-42aa-a6b5-5be7b3e63ead', '6f70b361-8781-47bc-934b-06892458b603', 'leases', 'Jobcard_For_Job_No_38609_26-08-2025_0741.pdf', 'leases/Jobcard_For_Job_No_38609_26-08-2025_0741.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('5593257c-ca58-49ed-950f-2fc175a2ddc2', '6f70b361-8781-47bc-934b-06892458b603', 'leases', 'Jobcard_For_Job_No_28737_25-11-2024_0907.pdf', 'leases/Jobcard_For_Job_No_28737_25-11-2024_0907.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('91981f8b-f56b-4e91-8b96-de2061aaa244', '6f70b361-8781-47bc-934b-06892458b603', 'leases', 'Jobcard_For_Job_No_35402_03-06-2025_0916.pdf', 'leases/Jobcard_For_Job_No_35402_03-06-2025_0916.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('505b1477-3420-40d6-96c7-3d97926a01a3', '6f70b361-8781-47bc-934b-06892458b603', 'leases', 'Jobcard_For_Job_No_35654_03-06-2025_0911.pdf', 'leases/Jobcard_For_Job_No_35654_03-06-2025_0911.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('08cb7d9b-89a4-4e44-9a9e-64877e011b1a', '6f70b361-8781-47bc-934b-06892458b603', 'leases', 'Jobcard_For_Job_No_37675_25-07-2025_1549.pdf', 'leases/Jobcard_For_Job_No_37675_25-07-2025_1549.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('687a7b10-a727-40e0-b2ee-331ddb9f8ddb', '6f70b361-8781-47bc-934b-06892458b603', 'leases', 'Jobcard_For_Job_No_35146_03-06-2025_0906.pdf', 'leases/Jobcard_For_Job_No_35146_03-06-2025_0906.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('d3bbd089-bfe5-4ff1-8864-f3ecb9b6cabc', '6f70b361-8781-47bc-934b-06892458b603', 'leases', 'Jobcard_For_Job_No_31162_30-01-2025_1602.pdf', 'leases/Jobcard_For_Job_No_31162_30-01-2025_1602.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('00269820-7e80-4503-a655-c896c8f55643', '6f70b361-8781-47bc-934b-06892458b603', 'leases', 'Jobcard_For_Job_No_36465_20-06-2025_1037.pdf', 'leases/Jobcard_For_Job_No_36465_20-06-2025_1037.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('6a469b8d-aa42-4514-8b2b-1f0a3d88029f', '6f70b361-8781-47bc-934b-06892458b603', 'other', 'connaught apportionment.xlsx', 'other/connaught apportionment.xlsx');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('71ec5062-82dd-4111-b5b6-d231400afcf6', '6f70b361-8781-47bc-934b-06892458b603', 'other', 'ACCOUNTS - YE 31.03.21 - Service Charge Accounts.pdf', 'other/ACCOUNTS - YE 31.03.21 - Service Charge Accounts.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('01d32e37-2811-4245-ac1a-be6e192923d1', '6f70b361-8781-47bc-934b-06892458b603', 'other', 'Connaught Square Budget 2025-6 Draft.xlsx', 'other/Connaught Square Budget 2025-6 Draft.xlsx');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('8776c543-9ad7-4e03-9c0f-442b893ebf05', '6f70b361-8781-47bc-934b-06892458b603', 'other', 'Connaught Square Budget 2025-Final.pdf', 'other/Connaught Square Budget 2025-Final.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('2a9b717f-8210-4f52-84f9-bf008686eec6', '6f70b361-8781-47bc-934b-06892458b603', 'other', 'Connaught Square Budget 2025-Final.xlsx', 'other/Connaught Square Budget 2025-Final.xlsx');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('adc0fae1-db34-43ba-b0d8-7a9923780f54', '6f70b361-8781-47bc-934b-06892458b603', 'other', 'ACCOUNTS - YE 31.03.21 - Service Charge Accounts.pdf', 'other/ACCOUNTS - YE 31.03.21 - Service Charge Accounts.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('f0ff9f2a-4a13-494d-b18f-3640ee4b86e6', '6f70b361-8781-47bc-934b-06892458b603', 'other', 'Connaught Square YE 24 Accounts.pdf', 'other/Connaught Square YE 24 Accounts.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('dc26d598-6c16-4412-a41d-91124d23214b', '6f70b361-8781-47bc-934b-06892458b603', 'compliance', '2024 Directors Meeting-Notes.docx', 'compliance/2024 Directors Meeting-Notes.docx');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('55aba615-6553-4b44-8a2e-e92295ee8c52', '6f70b361-8781-47bc-934b-06892458b603', 'compliance', 'Fire Door (Communal) Inspection (11m +) (7).pdf', 'compliance/Fire Door (Communal) Inspection (11m +) (7).pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('34011032-9307-4830-bda8-3c02839bcac3', '6f70b361-8781-47bc-934b-06892458b603', 'compliance', 'Fire Door (Flats) Inspection (11m +) (13).pdf', 'compliance/Fire Door (Flats) Inspection (11m +) (13).pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('5ebed618-0654-4ef1-95a6-5875ad3db999', '6f70b361-8781-47bc-934b-06892458b603', 'compliance', 'Fire Door (Flats) Inspection (11m +) (18).pdf', 'compliance/Fire Door (Flats) Inspection (11m +) (18).pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('22f9aea0-885c-4396-ae98-d19fc56c64ef', '6f70b361-8781-47bc-934b-06892458b603', 'compliance', 'Fire Door (Flats) Inspection (11m +) (14).pdf', 'compliance/Fire Door (Flats) Inspection (11m +) (14).pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('e157f9f3-3182-48eb-9990-447457211295', '6f70b361-8781-47bc-934b-06892458b603', 'compliance', 'EICR Cuanku 32-34 conaught square.pdf', 'compliance/EICR Cuanku 32-34 conaught square.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('3246eba7-8557-4fd7-88c7-9e6fbb985f95', '6f70b361-8781-47bc-934b-06892458b603', 'compliance', 'Fire Door (Flats) Inspection (11m +) (15).pdf', 'compliance/Fire Door (Flats) Inspection (11m +) (15).pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('7078f487-6bf8-40a1-998e-537ca92f8b9a', '6f70b361-8781-47bc-934b-06892458b603', 'compliance', '221037_Fra1-L-394697-071223 32-34 Connaught Square_2024-01-02_163759 (1).pdf', 'compliance/221037_Fra1-L-394697-071223 32-34 Connaught Square_2024-01-02_163759 (1).pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('560e6b7f-2963-49a2-ab5e-20e4f5063285', '6f70b361-8781-47bc-934b-06892458b603', 'compliance', 'Fire Door (Flats) Inspection (11m +) (19).pdf', 'compliance/Fire Door (Flats) Inspection (11m +) (19).pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('821ad79a-7540-4ced-80a8-5a2e536a4580', '6f70b361-8781-47bc-934b-06892458b603', 'compliance', '001132-3234-Connaught-Square-London.pdf', 'compliance/001132-3234-Connaught-Square-London.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('82d040cd-ef4d-4336-a81e-69f751070cbb', '6f70b361-8781-47bc-934b-06892458b603', 'compliance', '221038_Hsra1-L-394697-071223 32-34 Connaught Square_2024-01-02_163759 (1).pdf', 'compliance/221038_Hsra1-L-394697-071223 32-34 Connaught Square_2024-01-02_163759 (1).pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('47e2f2f8-13bc-44b7-a6ee-088a9fb528f7', '6f70b361-8781-47bc-934b-06892458b603', 'compliance', 'TETRA - Asbestos Re-Inspection Survey 14.06.22.pdf', 'compliance/TETRA - Asbestos Re-Inspection Survey 14.06.22.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('b6ec3db3-762b-4e1c-8bd1-bc7f04567728', '6f70b361-8781-47bc-934b-06892458b603', 'compliance', 'Fire Door (Flats) Inspection (11m +) (16).pdf', 'compliance/Fire Door (Flats) Inspection (11m +) (16).pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('19870103-81a6-4658-a0cf-cb6962305565', '6f70b361-8781-47bc-934b-06892458b603', 'compliance', 'Fire Door (Flats) Inspection (11m +) (17).pdf', 'compliance/Fire Door (Flats) Inspection (11m +) (17).pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('9a93cc39-b2fa-4798-b145-3408cffcf1a3', '6f70b361-8781-47bc-934b-06892458b603', 'compliance', 'WHM Legionella Risk Assessment 07.06.22.pdf', 'compliance/WHM Legionella Risk Assessment 07.06.22.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('cec3fa10-465d-4918-aef7-3e00df9d09c7', '6f70b361-8781-47bc-934b-06892458b603', 'compliance', 'EICR Report Cunaku SATISFACTORY 2023 .pdf', 'compliance/EICR Report Cunaku SATISFACTORY 2023 .pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('afbeae8d-fde3-4072-a90b-d12c9ca8cb07', '6f70b361-8781-47bc-934b-06892458b603', 'compliance', '2024 Directors Meeting-Notes.docx', 'compliance/2024 Directors Meeting-Notes.docx');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('2406126d-b4f0-4e9c-8f87-b9b5d868f14d', '6f70b361-8781-47bc-934b-06892458b603', 'compliance', '001457-3234-Connaught-Square-London Certificate.pdf', 'compliance/001457-3234-Connaught-Square-London Certificate.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('8ffa49eb-070b-4c66-8fd9-3118e0d084a2', '6f70b361-8781-47bc-934b-06892458b603', 'compliance', 'TC0001V31 General Terms and Conditions.pdf', 'compliance/TC0001V31 General Terms and Conditions.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('d11599cb-25b7-4309-98f1-11bc9bcf8d83', '6f70b361-8781-47bc-934b-06892458b603', 'compliance', 'Jobcard_For_Job_No_28992_24-01-2025_1545.pdf', 'compliance/Jobcard_For_Job_No_28992_24-01-2025_1545.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('91d507f0-5b92-41c5-9996-e7b4f3b11d53', '6f70b361-8781-47bc-934b-06892458b603', 'compliance', 'Connaught Square (32-34) - 09.12.24 LRA.pdf', 'compliance/Connaught Square (32-34) - 09.12.24 LRA.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('9e018056-5f21-4ab6-ac57-2c23c076419e', '6f70b361-8781-47bc-934b-06892458b603', 'compliance', 'SC Certificate - 10072023.pdf', 'compliance/SC Certificate - 10072023.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('06622d6a-d54d-4ee0-a15b-41825cda0424', '6f70b361-8781-47bc-934b-06892458b603', 'compliance', 'Fire Door (Communal) Inspection (11m +) (7).pdf', 'compliance/Fire Door (Communal) Inspection (11m +) (7).pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('8da4d15d-ed37-4afb-8f6b-9dfa2c648c90', '6f70b361-8781-47bc-934b-06892458b603', 'compliance', 'Fire Door (Flats) Inspection (11m +) (13).pdf', 'compliance/Fire Door (Flats) Inspection (11m +) (13).pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('98090f25-1b9c-446c-a188-2df2bcc109a7', '6f70b361-8781-47bc-934b-06892458b603', 'compliance', 'Fire Door (Flats) Inspection (11m +) (18).pdf', 'compliance/Fire Door (Flats) Inspection (11m +) (18).pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('9f25363b-5dc7-474d-8c57-110ac62c171b', '6f70b361-8781-47bc-934b-06892458b603', 'compliance', 'Fire Door (Flats) Inspection (11m +) (14).pdf', 'compliance/Fire Door (Flats) Inspection (11m +) (14).pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('95397b58-13de-4853-9a19-1919f200efc8', '6f70b361-8781-47bc-934b-06892458b603', 'compliance', 'Fire Door (Flats) Inspection (11m +) (15).pdf', 'compliance/Fire Door (Flats) Inspection (11m +) (15).pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('44ccc87b-eb62-4753-a5a6-2babea8bd3a8', '6f70b361-8781-47bc-934b-06892458b603', 'compliance', 'Fire Door (Flats) Inspection (11m +) (19).pdf', 'compliance/Fire Door (Flats) Inspection (11m +) (19).pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('ed791d8b-4f06-4aa3-a92c-adfc72355448', '6f70b361-8781-47bc-934b-06892458b603', 'compliance', 'Fire Door (Flats) Inspection (11m +) (16).pdf', 'compliance/Fire Door (Flats) Inspection (11m +) (16).pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('a3ad002b-ef8a-4a07-902b-d94129a3ae67', '6f70b361-8781-47bc-934b-06892458b603', 'compliance', 'Fire Door (Flats) Inspection (11m +) (17).pdf', 'compliance/Fire Door (Flats) Inspection (11m +) (17).pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('56d51318-7334-43cd-8f4f-ce6307550218', '6f70b361-8781-47bc-934b-06892458b603', 'compliance', '221037_Fra1-L-394697-071223 32-34 Connaught Square_2024-01-02_163759.pdf', 'compliance/221037_Fra1-L-394697-071223 32-34 Connaught Square_2024-01-02_163759.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('44896907-1c5a-432d-8abf-f91d8c672ce1', '6f70b361-8781-47bc-934b-06892458b603', 'compliance', 'Fire Door (Flats) Inspection (11m +) - 2024-01-24T120747.552.pdf', 'compliance/Fire Door (Flats) Inspection (11m +) - 2024-01-24T120747.552.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('17305411-a057-4315-9d43-cf3e0d688efb', '6f70b361-8781-47bc-934b-06892458b603', 'compliance', 'Connaught Square (32-34) - 15.11.23 (886) wa.pdf', 'compliance/Connaught Square (32-34) - 15.11.23 (886) wa.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('b7521e15-1fec-4277-a9cf-093299dc2b3b', '6f70b361-8781-47bc-934b-06892458b603', 'compliance', 'Fire Door (Flats) Inspection (11m +) - 2024-01-24T120745.875.pdf', 'compliance/Fire Door (Flats) Inspection (11m +) - 2024-01-24T120745.875.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('d324a856-9e19-4b22-98b6-7638dd6598d4', '6f70b361-8781-47bc-934b-06892458b603', 'compliance', 'Fire Door (Flats) Inspection (11m +) - 2024-01-24T120746.424.pdf', 'compliance/Fire Door (Flats) Inspection (11m +) - 2024-01-24T120746.424.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('d3d7cc98-29b6-4476-b4cd-aba49ea4cf51', '6f70b361-8781-47bc-934b-06892458b603', 'compliance', 'Fire Door (Communal) Inspection (11m +) - 2024-01-24T120743.986.pdf', 'compliance/Fire Door (Communal) Inspection (11m +) - 2024-01-24T120743.986.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('8dc95d9e-22e4-4c58-b3e5-102869eb51db', '6f70b361-8781-47bc-934b-06892458b603', 'compliance', 'Fire Door (Flats) Inspection (11m +) - 2024-01-24T120744.738.pdf', 'compliance/Fire Door (Flats) Inspection (11m +) - 2024-01-24T120744.738.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('b06ad4e3-d52a-457e-a668-256b6512de69', '6f70b361-8781-47bc-934b-06892458b603', 'compliance', 'Fire Door (Flats) Inspection (11m +) - 2024-01-24T120747.015.pdf', 'compliance/Fire Door (Flats) Inspection (11m +) - 2024-01-24T120747.015.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('2d419c79-b79f-4dc9-bb44-92d65855d0a5', '6f70b361-8781-47bc-934b-06892458b603', 'compliance', '221038_Hsra1-L-394697-071223 32-34 Connaught Square_2024-01-02_163759.pdf', 'compliance/221038_Hsra1-L-394697-071223 32-34 Connaught Square_2024-01-02_163759.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('5dadae1a-e930-41b5-8d59-7a1f211d063e', '6f70b361-8781-47bc-934b-06892458b603', 'compliance', 'Fire Door (Flats) Inspection (11m +) - 2024-01-24T120745.174.pdf', 'compliance/Fire Door (Flats) Inspection (11m +) - 2024-01-24T120745.174.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('7337ec24-0e95-46f3-ad07-424b9910fdc9', '6f70b361-8781-47bc-934b-06892458b603', 'compliance', 'Hsfra1-L-422971-210225 32-34 Connaught Square.pdf', 'compliance/Hsfra1-L-422971-210225 32-34 Connaught Square.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('3e1836c2-f367-44e6-be08-43f3865da865', '6f70b361-8781-47bc-934b-06892458b603', 'compliance', 'Hsfra1-L-422971-210225 32-34 Connaught Square.docx', 'compliance/Hsfra1-L-422971-210225 32-34 Connaught Square.docx');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('22816af0-9690-4c49-b8d5-4ce7454254e4', '6f70b361-8781-47bc-934b-06892458b603', 'compliance', '221037_Fra1-L-394697-071223 32-34 Connaught Square_2024-01-02_163759 (1).pdf', 'compliance/221037_Fra1-L-394697-071223 32-34 Connaught Square_2024-01-02_163759 (1).pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('d08fc6e5-18b7-40e3-8298-458f5f0dc32a', '6f70b361-8781-47bc-934b-06892458b603', 'compliance', '221038_Hsra1-L-394697-071223 32-34 Connaught Square_2024-01-02_163759 (1).pdf', 'compliance/221038_Hsra1-L-394697-071223 32-34 Connaught Square_2024-01-02_163759 (1).pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('a21937d2-7d3d-411d-8230-2fc01d39bd57', '6f70b361-8781-47bc-934b-06892458b603', 'compliance', 'FRA-Connaught Square Reccommendations.xlsx', 'compliance/FRA-Connaught Square Reccommendations.xlsx');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('66a7ef29-9cbc-4dfa-9a8c-11abafaaf143', '6f70b361-8781-47bc-934b-06892458b603', 'compliance', '001534-3234-Connaught-Square-London.pdf', 'compliance/001534-3234-Connaught-Square-London.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('0e04d74c-8124-4db7-ad71-f87a9edf8f23', '6f70b361-8781-47bc-934b-06892458b603', 'compliance', 'C1047 - Job card.pdf', 'compliance/C1047 - Job card.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('98127825-97a1-47c5-ab18-7e8c61b3d220', '6f70b361-8781-47bc-934b-06892458b603', 'compliance', 'WHM Legionella Risk Assessment 09.12.25.pdf', 'compliance/WHM Legionella Risk Assessment 09.12.25.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('88030ceb-f6f7-437f-aa59-4ccc1f609f54', '6f70b361-8781-47bc-934b-06892458b603', 'compliance', 'WHM Legionella Risk Assessment 07.06.22.pdf', 'compliance/WHM Legionella Risk Assessment 07.06.22.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('8878a603-90c8-4f39-9f75-494e5ef8ccaa', '6f70b361-8781-47bc-934b-06892458b603', 'compliance', 'Connaught Square (32-34) - 29.05.25 (201) wa.pdf', 'compliance/Connaught Square (32-34) - 29.05.25 (201) wa.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('a716e187-01d5-43d2-b3bf-a453a22c4c7d', '6f70b361-8781-47bc-934b-06892458b603', 'compliance', 'EICR Cuanku 32-34 conaught square.pdf', 'compliance/EICR Cuanku 32-34 conaught square.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('99bdda92-7771-45be-928d-56d15a8c8312', '6f70b361-8781-47bc-934b-06892458b603', 'compliance', 'EICR Report Cunaku SATISFACTORY 2023 .pdf', 'compliance/EICR Report Cunaku SATISFACTORY 2023 .pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('42927e3d-aa3b-44aa-aeb1-3001780bac73', '6f70b361-8781-47bc-934b-06892458b603', 'compliance', '001132-3234-Connaught-Square-London.pdf', 'compliance/001132-3234-Connaught-Square-London.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('20801e8b-e2d1-4211-9288-8a707898d082', '6f70b361-8781-47bc-934b-06892458b603', 'compliance', '001534-3234-Connaught-Square-London.pdf', 'compliance/001534-3234-Connaught-Square-London.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('f0b20702-f5f4-42ca-8b2f-bbbfbfa058f9', '6f70b361-8781-47bc-934b-06892458b603', 'compliance', 'FINAL L-432900 32-34 Connaught Square Management Survey Report Issue 1.pdf', 'compliance/FINAL L-432900 32-34 Connaught Square Management Survey Report Issue 1.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('ae3309cb-83da-4396-b72e-518e87b9cfc4', '6f70b361-8781-47bc-934b-06892458b603', 'compliance', 'TETRA - Asbestos Re-Inspection Survey 14.06.22.pdf', 'compliance/TETRA - Asbestos Re-Inspection Survey 14.06.22.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('5409e3bb-41bf-42ca-b130-b8497d8c38a3', '6f70b361-8781-47bc-934b-06892458b603', 'other', 'British Gas Invoice-862451083.pdf', 'other/British Gas Invoice-862451083.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('8e45c504-0af4-4509-ab9e-a48154985acf', '6f70b361-8781-47bc-934b-06892458b603', 'other', 'Signed 2025 Connaught Square Management Agreement.docx.pdf', 'other/Signed 2025 Connaught Square Management Agreement.docx.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('f57eff76-3b74-4f59-b068-792405ba3d08', '6f70b361-8781-47bc-934b-06892458b603', 'other', 'Connaught Square Management Agreement.docx', 'other/Connaught Square Management Agreement.docx');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('64611c85-8807-49eb-a3b5-5118ce366b8e', '6f70b361-8781-47bc-934b-06892458b603', 'other', '2025 Connaught Square Management Agreement.docx', 'other/2025 Connaught Square Management Agreement.docx');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('10aa5d8c-f50f-4d06-88a2-3381acd9ee94', '6f70b361-8781-47bc-934b-06892458b603', 'other', 'Signed Connaught Square Management Agreement.pdf', 'other/Signed Connaught Square Management Agreement.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('e180541c-8bb6-481f-9d14-90f7acebd2d3', '6f70b361-8781-47bc-934b-06892458b603', 'other', 'Contractors list.xlsx', 'other/Contractors list.xlsx');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('6985b597-cad0-495f-8763-45dd5eea39b3', '6f70b361-8781-47bc-934b-06892458b603', 'other', 'Contractors list.xlsx', 'other/Contractors list.xlsx');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('2c77f609-2110-4d0f-b1a9-1b9afe79c36c', '6f70b361-8781-47bc-934b-06892458b603', 'other', 'EMERGENCY CALL OUT DETAILS 2024.pdf', 'other/EMERGENCY CALL OUT DETAILS 2024.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('78dbfb41-d87a-4cb0-9fba-f94c69425908', '6f70b361-8781-47bc-934b-06892458b603', 'other', 'CM434.PRO 2024-2025.pdf', 'other/CM434.PRO 2024-2025.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('c8c5c967-3448-477a-bb15-3ce9fcb339ea', '6f70b361-8781-47bc-934b-06892458b603', 'other', 'CM434.PRO.pdf', 'other/CM434.PRO.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('42e0c82e-c5f4-403a-9f7c-82cd035e80d6', '6f70b361-8781-47bc-934b-06892458b603', 'other', 'Gas Contract 24-5.pdf', 'other/Gas Contract 24-5.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('20139028-b3f4-4c29-8af0-166aaaf9c98c', '6f70b361-8781-47bc-934b-06892458b603', 'other', 'Contract_10-03-2025.pdf', 'other/Contract_10-03-2025.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('2d72619c-e5b5-4c0c-88d8-5b2efd963a9d', '6f70b361-8781-47bc-934b-06892458b603', 'other', 'Gas Contract 25-26.pdf', 'other/Gas Contract 25-26.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('dbbde16d-f923-466f-86a3-79c4e1578e0c', '6f70b361-8781-47bc-934b-06892458b603', 'other', 'Welcome Letter - CG1885574.pdf', 'other/Welcome Letter - CG1885574.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('b822bd77-846d-4598-85b1-e2f1d3408412', '6f70b361-8781-47bc-934b-06892458b603', 'other', 'Job 67141.pdf', 'other/Job 67141.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('6d5994f3-7950-41d3-b75c-7a221a3b5afe', '6f70b361-8781-47bc-934b-06892458b603', 'other', 'BLENHEIMS, 32-34 CONNAUGHT, W2 2HL - 19.05.23.pdf', 'other/BLENHEIMS, 32-34 CONNAUGHT, W2 2HL - 19.05.23.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('7a744d0b-be4c-4666-bf98-f7870b443d99', '6f70b361-8781-47bc-934b-06892458b603', 'other', 'BLENHEIMS, 32-34 CONNAUGHT, W2 2HL - 22.03.23.pdf', 'other/BLENHEIMS, 32-34 CONNAUGHT, W2 2HL - 22.03.23.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('95596924-3cbc-4d61-8138-8b7a63fbcff6', '6f70b361-8781-47bc-934b-06892458b603', 'other', 'BLENHEIMS, 32-34 CONNAUGHT, W2 2HL - 26.06.23.pdf', 'other/BLENHEIMS, 32-34 CONNAUGHT, W2 2HL - 26.06.23.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('a150130c-4e4c-4305-992f-72e919eb159e', '6f70b361-8781-47bc-934b-06892458b603', 'other', 'BLENHEIMS, 32-34 CONNAUGHT, W2 2HL - 19.05.23.pdf', 'other/BLENHEIMS, 32-34 CONNAUGHT, W2 2HL - 19.05.23.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('46d4dbcc-0b6c-4041-94f9-2ee802ab24ba', '6f70b361-8781-47bc-934b-06892458b603', 'other', 'BLENHEIMS, 32-34 CONNAUGHT, W2 2HL - 22.03.23.pdf', 'other/BLENHEIMS, 32-34 CONNAUGHT, W2 2HL - 22.03.23.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('d11a6ff2-e946-4268-ab1c-a44bd3ce5c55', '6f70b361-8781-47bc-934b-06892458b603', 'other', 'BLENHEIMS, 32-34 CONNAUGHT, W2 2HL - 26.06.23.pdf', 'other/BLENHEIMS, 32-34 CONNAUGHT, W2 2HL - 26.06.23.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('3cca7bf2-0a89-4b96-aec8-875831cc85b1', '6f70b361-8781-47bc-934b-06892458b603', 'other', 'Jobcard_For_Job_No_27067_07-10-2024_1147.pdf', 'other/Jobcard_For_Job_No_27067_07-10-2024_1147.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('9ae8ae3a-949c-48e2-89eb-b8f0b99648f2', '6f70b361-8781-47bc-934b-06892458b603', 'other', 'Jobcard_For_Job_No_19665_28-03-2024_0936.pdf', 'other/Jobcard_For_Job_No_19665_28-03-2024_0936.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('7ad5ddf0-b49e-4d45-9520-1d6674ff836c', '6f70b361-8781-47bc-934b-06892458b603', 'other', 'Jobcard_For_Job_No_22634_03-07-2024_1649.pdf', 'other/Jobcard_For_Job_No_22634_03-07-2024_1649.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('51fdb55e-a72d-426b-81b6-e4de99a6cac9', '6f70b361-8781-47bc-934b-06892458b603', 'other', 'Jobcard_For_Job_No_25732_03-10-2024_1337.pdf', 'other/Jobcard_For_Job_No_25732_03-10-2024_1337.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('e4774cc1-ac75-44b8-a8f3-280de43c68cb', '6f70b361-8781-47bc-934b-06892458b603', 'other', 'Lift Contract-Jacksons lift.pdf', 'other/Lift Contract-Jacksons lift.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('ecb9242d-7377-48e8-947d-0e3857de1b5d', '6f70b361-8781-47bc-934b-06892458b603', 'other', 'JLGCalloutVisit-5455045-12-07-2024.pdf', 'other/JLGCalloutVisit-5455045-12-07-2024.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('d922c1a9-a205-4170-b1e7-32bbe0635b3c', '6f70b361-8781-47bc-934b-06892458b603', 'other', 'JLGCalloutVisit-5483206-26-10-2024.pdf', 'other/JLGCalloutVisit-5483206-26-10-2024.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('393df930-1000-48c1-a861-b693e2c1ddc2', '6f70b361-8781-47bc-934b-06892458b603', 'other', 'JLGCalloutVisit-5498439-16-12-2024.pdf', 'other/JLGCalloutVisit-5498439-16-12-2024.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('28c51218-85b8-4267-b281-219d32137a2b', '6f70b361-8781-47bc-934b-06892458b603', 'other', 'JLGCalloutVisit-5455462-16-07-2024.pdf', 'other/JLGCalloutVisit-5455462-16-07-2024.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('943702ab-10a4-40e1-9c1b-04a379260cdc', '6f70b361-8781-47bc-934b-06892458b603', 'other', 'JLGCalloutVisit-5497480-13-12-2024.pdf', 'other/JLGCalloutVisit-5497480-13-12-2024.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('e2869090-40d5-44ff-9cff-329a54e16834', '6f70b361-8781-47bc-934b-06892458b603', 'other', 'Engineering Report - 32-34 CONNAUGHT SQUARE.pdf', 'other/Engineering Report - 32-34 CONNAUGHT SQUARE.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('cf51c663-fc6d-44ca-ac96-6d3cc5e532da', '6f70b361-8781-47bc-934b-06892458b603', 'other', 'Arch Directors and Officers Liability Insurance for Residents Associations (12.22).pdf', 'other/Arch Directors and Officers Liability Insurance for Residents Associations (12.22).pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('0b76da15-0eef-4b43-b859-e79d57ed4022', '6f70b361-8781-47bc-934b-06892458b603', 'other', 'StG_Policy Wording_32-34 Connaught Square W2 2HL.pdf', 'other/StG_Policy Wording_32-34 Connaught Square W2 2HL.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('f99a12ab-7df0-4061-9e59-a395cfbd3a7d', '6f70b361-8781-47bc-934b-06892458b603', 'compliance', 'Fire Extinguisher Signed Contract- Connaught Square.pdf', 'compliance/Fire Extinguisher Signed Contract- Connaught Square.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('c3c91b8f-9250-489e-bacc-44525e6df92a', '6f70b361-8781-47bc-934b-06892458b603', 'other', 'Q51691 - 32-34 Connaught Square Contract.pdf', 'other/Q51691 - 32-34 Connaught Square Contract.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('cbfc1401-7ea0-46c0-b0dd-b6ad8ad7f6d0', '6f70b361-8781-47bc-934b-06892458b603', 'other', 'Engineering Report - 32-34 CONNAUGHT SQUARE.pdf', 'other/Engineering Report - 32-34 CONNAUGHT SQUARE.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('034ef701-5214-4899-98ce-3d6da9152c4e', '6f70b361-8781-47bc-934b-06892458b603', 'compliance', 'Fire Alarm+Emergency Lighting Signed Contract-3234 Connaught Square.pdf', 'compliance/Fire Alarm+Emergency Lighting Signed Contract-3234 Connaught Square.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('a97f4c9f-6807-455b-aada-70debab712b7', '6f70b361-8781-47bc-934b-06892458b603', 'compliance', 'Fire Alarm+Emergency Lighting Contract Connaught Square.pdf', 'compliance/Fire Alarm+Emergency Lighting Contract Connaught Square.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('640529fb-0735-4e1c-9e6c-53d4fb70e3ca', '6f70b361-8781-47bc-934b-06892458b603', 'other', 'BT3205 03072025.pdf', 'other/BT3205 03072025.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('2b16648d-c51f-455e-9786-2c31be9eded0', '6f70b361-8781-47bc-934b-06892458b603', 'other', 'FA7817 SERVICE 08042025.pdf', 'other/FA7817 SERVICE 08042025.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('7d2ae8b4-548b-48c8-a8d9-9ffe2265fee8', '6f70b361-8781-47bc-934b-06892458b603', 'other', 'Engineer Report - 32-34 Connaught Square Flat 5.pdf', 'other/Engineer Report - 32-34 Connaught Square Flat 5.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('079d95bb-7516-413a-afef-00dc4c68f030', '6f70b361-8781-47bc-934b-06892458b603', 'other', 'Engineering Report - 32-34 CONNAUGHT SQUARE.pdf', 'other/Engineering Report - 32-34 CONNAUGHT SQUARE.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('7f5b7f28-6912-4d19-9c39-7f28e96c4564', '6f70b361-8781-47bc-934b-06892458b603', 'other', 'Jobcard_For_Job_No_22171_14-05-2024_1202.pdf', 'other/Jobcard_For_Job_No_22171_14-05-2024_1202.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('8b156912-92c9-4663-8e40-7b24f4478767', '6f70b361-8781-47bc-934b-06892458b603', 'other', 'British Gas Invoice-862451083.pdf', 'other/British Gas Invoice-862451083.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('a12114b1-19a9-4f8c-8cf9-498ae228f45b', '6f70b361-8781-47bc-934b-06892458b603', 'other', 'MT8825 03072025.pdf', 'other/MT8825 03072025.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('692451ff-9ad7-4a51-b0d1-79d244b4be0a', '6f70b361-8781-47bc-934b-06892458b603', 'other', 'January Monthly Test For EL-Connaught Square.pdf', 'other/January Monthly Test For EL-Connaught Square.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('33f85010-5949-46ee-a10f-fa9c41207423', '6f70b361-8781-47bc-934b-06892458b603', 'other', 'February Monthly Test For EL-Connaught Square.pdf', 'other/February Monthly Test For EL-Connaught Square.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('810a725a-46b1-4483-87c8-3c5f831a3de5', '6f70b361-8781-47bc-934b-06892458b603', 'major_works', 'External Decorations SOI - 28042025.docx', 'major_works/External Decorations SOI - 28042025.docx');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('ace1f4c7-0cc1-4e46-b064-bb7cbeea61d9', '6f70b361-8781-47bc-934b-06892458b603', 'major_works', 'External Dec SOE 03072025.docx', 'major_works/External Dec SOE 03072025.docx');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('a689edd3-a42b-4fa8-8261-6c496c3eeccc', '6f70b361-8781-47bc-934b-06892458b603', 'major_works', 'Notice of intention for lift.docx', 'major_works/Notice of intention for lift.docx');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('9266ee17-4447-434a-8d4a-4e55a6b50b25', '6f70b361-8781-47bc-934b-06892458b603', 'major_works', 'Connaught Square (32-34) - 09.12.24 Schematic.pdf', 'major_works/Connaught Square (32-34) - 09.12.24 Schematic.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('00a904f9-6aae-48be-a0bd-d07ad06001cb', '6f70b361-8781-47bc-934b-06892458b603', 'insurance', 'CGBI3964546XB6-Cunaku Construction Ltd-Business-Certificate of insurance.pdf', 'insurance/CGBI3964546XB6-Cunaku Construction Ltd-Business-Certificate of insurance.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('1da0dd34-1c4b-4475-b9f7-a3f4ccb02a90', '6f70b361-8781-47bc-934b-06892458b603', 'insurance', 'CGBI3964546XB7-Cunaku Construction Ltd-Business-Certificate of insurance.pdf', 'insurance/CGBI3964546XB7-Cunaku Construction Ltd-Business-Certificate of insurance.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('7ac03b09-c2e7-42b7-ab75-c26a3d46e784', '6f70b361-8781-47bc-934b-06892458b603', 'insurance', 'Real Estate Insurance NTP (01.23).pdf', 'insurance/Real Estate Insurance NTP (01.23).pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('e0534b16-7f82-4742-8736-94dda9d1dd1b', '6f70b361-8781-47bc-934b-06892458b603', 'insurance', 'Real Estate Policy (01.23).pdf', 'insurance/Real Estate Policy (01.23).pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('33e3456b-bbbb-40a4-a884-20e5e234c133', '6f70b361-8781-47bc-934b-06892458b603', 'insurance', 'Summary of Cover (01.23).pdf', 'insurance/Summary of Cover (01.23).pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('86241db5-4b23-4514-9fe1-46dc5b5cf657', '6f70b361-8781-47bc-934b-06892458b603', 'insurance', '2023 Allianz VOC - 32-34 Connuaght Square (Freehold) Limited.pdf', 'insurance/2023 Allianz VOC - 32-34 Connuaght Square (Freehold) Limited.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('b10c8753-e286-4d58-853e-bbf3c0e8502a', '6f70b361-8781-47bc-934b-06892458b603', 'other', '2023 Engineering Renewal Notice - 32 34 Connuaght Square (Freehold) Limited.pdf', 'other/2023 Engineering Renewal Notice - 32 34 Connuaght Square (Freehold) Limited.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('95f4bb69-4c05-45b4-9ee2-272d8c7d6e83', '6f70b361-8781-47bc-934b-06892458b603', 'insurance', '32-34 Connaught Square Freehold Limited - Arch D&O Schedule.pdf', 'insurance/32-34 Connaught Square Freehold Limited - Arch D&O Schedule.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('de0fe750-1862-4331-a2bb-33d95575f683', '6f70b361-8781-47bc-934b-06892458b603', 'insurance', '32-34 Connaught Sq Buildings Insurance 2023-2024.pdf', 'insurance/32-34 Connaught Sq Buildings Insurance 2023-2024.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('83d29edd-aaee-4c85-8f60-43de783db206', '6f70b361-8781-47bc-934b-06892458b603', 'insurance', 'Policy Limits Document.pdf', 'insurance/Policy Limits Document.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('51a7470e-28c6-400a-9d3f-0f25df03930d', '6f70b361-8781-47bc-934b-06892458b603', 'leases', 'Official Copy (Lease) 13.06.2003 - NGL823646-Flat 4.pdf', 'leases/Official Copy (Lease) 13.06.2003 - NGL823646-Flat 4.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('99cf36f1-09db-4e0f-b0b2-c2ad592d49b0', '6f70b361-8781-47bc-934b-06892458b603', 'other', 'Letter of Authority - Connaught Square.doc.pdf', 'other/Letter of Authority - Connaught Square.doc.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('574eaab1-477a-454b-9e50-fb0cdc1936ad', '6f70b361-8781-47bc-934b-06892458b603', 'other', 'Letter to report - Connaught Square.doc.pdf', 'other/Letter to report - Connaught Square.doc.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('6a65dce9-0d28-42fa-b42e-66025f3e26d9', '6f70b361-8781-47bc-934b-06892458b603', 'other', 'Pricing Quote - 32_34 Connaught Square Freehold Ltd - 109 - Gas - 10.03.2025.pdf', 'other/Pricing Quote - 32_34 Connaught Square Freehold Ltd - 109 - Gas - 10.03.2025.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('2b658a3a-e35e-4a15-96d8-a6ae091fe24a', '6f70b361-8781-47bc-934b-06892458b603', 'insurance', 'Allianz - Lift Report 14.03.23.pdf', 'insurance/Allianz - Lift Report 14.03.23.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('ec3461e5-5db4-4cc4-9afb-c0e13e57dd8c', '6f70b361-8781-47bc-934b-06892458b603', 'insurance', 'Allianz-Lift Report 18.03.2024.pdf', 'insurance/Allianz-Lift Report 18.03.2024.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('4f2d8bf7-2eb9-418c-b255-8749726a6257', '6f70b361-8781-47bc-934b-06892458b603', 'insurance', 'Allianz - Lift Report - 15.09.21.pdf', 'insurance/Allianz - Lift Report - 15.09.21.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('50122653-54b6-4482-9e8a-7520ffa776d8', '6f70b361-8781-47bc-934b-06892458b603', 'insurance', 'Allianz - Lift Report 27.09.23.pdf', 'insurance/Allianz - Lift Report 27.09.23.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('7ef556aa-fc6f-4d26-a2df-a1f6838bd66a', '6f70b361-8781-47bc-934b-06892458b603', 'insurance', 'Allianz - Lift Report 10.03.22.pdf', 'insurance/Allianz - Lift Report 10.03.22.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('17253ce4-6655-4359-b152-2a6b20737449', '6f70b361-8781-47bc-934b-06892458b603', 'insurance', 'Allianz - Lift Report 09.09.22.pdf', 'insurance/Allianz - Lift Report 09.09.22.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('b5eb2e5d-36db-4c61-9536-7946195667b8', '6f70b361-8781-47bc-934b-06892458b603', 'insurance', 'LXBI3559280XB2-NEW STEP-Business-Certificate of insurance.pdf', 'insurance/LXBI3559280XB2-NEW STEP-Business-Certificate of insurance.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('692e436b-58ff-4446-9a4d-790d0e1ccfd5', '6f70b361-8781-47bc-934b-06892458b603', 'insurance', '2023 Allianz VOC - 32-34 Connuaght Square (Freehold) Limited.pdf', 'insurance/2023 Allianz VOC - 32-34 Connuaght Square (Freehold) Limited.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('7e11fff7-925b-4fc0-be8c-39c5232363ef', '6f70b361-8781-47bc-934b-06892458b603', 'other', '2023 Engineering Renewal Notice - 32 34 Connuaght Square (Freehold) Limited.pdf', 'other/2023 Engineering Renewal Notice - 32 34 Connuaght Square (Freehold) Limited.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('8b0f8ad9-6ecd-46a5-8096-1d085de4e0c6', '6f70b361-8781-47bc-934b-06892458b603', 'insurance', 'MO - Policy Wording - NZ0411.pdf', 'insurance/MO - Policy Wording - NZ0411.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('69815f11-7e3a-429d-9c4f-12ca108f23a8', '6f70b361-8781-47bc-934b-06892458b603', 'insurance', 'Feature and Benefits of Allianz Engineering Inspection Service.pdf', 'insurance/Feature and Benefits of Allianz Engineering Inspection Service.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('50daed87-62c5-4b73-9786-cc170d925ea4', '6f70b361-8781-47bc-934b-06892458b603', 'insurance', 'StG_Insurer pack_32-34 Connaught Square Freehold Limited.pdf', 'insurance/StG_Insurer pack_32-34 Connaught Square Freehold Limited.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('0c81e007-2483-465b-87ff-27fe7b33c856', '6f70b361-8781-47bc-934b-06892458b603', 'insurance', 'StG_Statement of Facts_32-34 Connaught Square W2 2HL.pdf', 'insurance/StG_Statement of Facts_32-34 Connaught Square W2 2HL.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('de67a076-d528-4f01-970c-40905b6b096b', '6f70b361-8781-47bc-934b-06892458b603', 'insurance', 'StG_Insurance Report_32-34 Connaught Square W2 2HL.pdf', 'insurance/StG_Insurance Report_32-34 Connaught Square W2 2HL.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('067c682f-dc1d-4047-894e-d6eaaaf8d891', '6f70b361-8781-47bc-934b-06892458b603', 'insurance', 'StG_Insurer pack_32-34 Connaught Square Freehold Limited.pdf', 'insurance/StG_Insurer pack_32-34 Connaught Square Freehold Limited.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('8504a19f-e50e-41a6-9ed6-300138727117', '6f70b361-8781-47bc-934b-06892458b603', 'insurance', 'StG_Statement of Facts_32-34 Connaught Square W2 2HL.pdf', 'insurance/StG_Statement of Facts_32-34 Connaught Square W2 2HL.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('84c367a4-1abc-4464-9a77-99679e58de95', '6f70b361-8781-47bc-934b-06892458b603', 'insurance', 'StG_Insurance Report_32-34 Connaught Square W2 2HL.pdf', 'insurance/StG_Insurance Report_32-34 Connaught Square W2 2HL.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('4a5100de-a647-42e8-8de9-709202621a0d', '6f70b361-8781-47bc-934b-06892458b603', 'other', 'StG_Invoice_32-34 Connaught Square W2 2HL.pdf', 'other/StG_Invoice_32-34 Connaught Square W2 2HL.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('af074d5b-20c6-4869-b742-82a8a2cd6f1f', '6f70b361-8781-47bc-934b-06892458b603', 'insurance', 'StG_Certificate_32-34 Connaught Square W2 2HL.pdf', 'insurance/StG_Certificate_32-34 Connaught Square W2 2HL.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('b2aacfdf-5ba8-4e14-a993-56ffb0649a92', '6f70b361-8781-47bc-934b-06892458b603', 'insurance', 'StG_Insurer pack_32-34 Connaught Square Freehold Limited.pdf', 'insurance/StG_Insurer pack_32-34 Connaught Square Freehold Limited.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('bf75a411-4b57-4a45-bf0f-ac24cd104b20', '6f70b361-8781-47bc-934b-06892458b603', 'insurance', 'StG_Statement of Fact_32-34 Connaught Square W2 2HL.pdf', 'insurance/StG_Statement of Fact_32-34 Connaught Square W2 2HL.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('6df41fb6-d907-401a-901a-4030ddacfcdd', '6f70b361-8781-47bc-934b-06892458b603', 'other', 'StG_Invoice_32-34 Connaught Square Freehold Limited.pdf', 'other/StG_Invoice_32-34 Connaught Square Freehold Limited.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('7f173047-cebf-4a4a-88f7-fe1f1e277557', '6f70b361-8781-47bc-934b-06892458b603', 'insurance', '32-34 Connaught Square Freehold Limited - Arch D&O Schedule.pdf', 'insurance/32-34 Connaught Square Freehold Limited - Arch D&O Schedule.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('616324c0-ddeb-482b-9bec-b78f3e18bd17', '6f70b361-8781-47bc-934b-06892458b603', 'insurance', 'StG_Certificate_32-34 Connaught Square Freehold Limited.pdf', 'insurance/StG_Certificate_32-34 Connaught Square Freehold Limited.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('7872d0c0-6673-4198-aaf1-1ae3a5946539', '6f70b361-8781-47bc-934b-06892458b603', 'insurance', 'StG_Policy Wording_32-34 Connaught Square Freehold Limited.pdf', 'insurance/StG_Policy Wording_32-34 Connaught Square Freehold Limited.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('185eb12e-4509-475c-a79c-47ba9e862856', '6f70b361-8781-47bc-934b-06892458b603', 'insurance', 'StG_D&O Endorsements_32-34 Connaught Square Freehold Limited.pdf', 'insurance/StG_D&O Endorsements_32-34 Connaught Square Freehold Limited.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('d52fca2b-cf42-4101-9b45-c26e46229348', '6f70b361-8781-47bc-934b-06892458b603', 'other', 'StG_Demands & Needs_32-34 Connaught Square Freehold Limited.pdf', 'other/StG_Demands & Needs_32-34 Connaught Square Freehold Limited.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('ec824892-bfe9-47cf-95e1-e594ea47c302', '6f70b361-8781-47bc-934b-06892458b603', 'other', 'StG_Quote_32-34 Connaught Square Freehold Limited.pdf', 'other/StG_Quote_32-34 Connaught Square Freehold Limited.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('8502798b-c5aa-48a7-8cc5-eb4a51359c51', '6f70b361-8781-47bc-934b-06892458b603', 'insurance', 'StG_Insurance Report_32-34 Connaught Square W2 2HL.pdf', 'insurance/StG_Insurance Report_32-34 Connaught Square W2 2HL.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('e05bb194-7a1f-4627-85c9-21741f963759', '6f70b361-8781-47bc-934b-06892458b603', 'insurance', 'FBR113382303-20230405-B.pdf', 'insurance/FBR113382303-20230405-B.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('694c09da-faab-47f2-8681-c09e749a8041', '6f70b361-8781-47bc-934b-06892458b603', 'insurance', 'Real Estate Insurance NTP (01.23).pdf', 'insurance/Real Estate Insurance NTP (01.23).pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('81d4cfd0-a7b2-4e78-8187-950ee3f0ce3d', '6f70b361-8781-47bc-934b-06892458b603', 'insurance', 'Real Estate Policy (01.23).pdf', 'insurance/Real Estate Policy (01.23).pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('a94f872c-b9b9-4092-a53d-be2005620705', '6f70b361-8781-47bc-934b-06892458b603', 'insurance', 'Summary of Cover (01.23).pdf', 'insurance/Summary of Cover (01.23).pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('707802bf-01a1-48e3-8e58-c5a910da6662', '6f70b361-8781-47bc-934b-06892458b603', 'insurance', '32-34 Connaught Sq Buildings Insurance 2023-2024.pdf', 'insurance/32-34 Connaught Sq Buildings Insurance 2023-2024.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('2e7ac094-0975-4f8c-a798-16452d80c635', '6f70b361-8781-47bc-934b-06892458b603', 'insurance', 'Policy Limits Document.pdf', 'insurance/Policy Limits Document.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('6e066094-35d5-42ae-ba38-5ac3d26ae638', '6f70b361-8781-47bc-934b-06892458b603', 'insurance', 'Zurich Real Estate Policy Summary.pdf', 'insurance/Zurich Real Estate Policy Summary.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('e518a9c0-7584-4676-8825-cf9390342018', '6f70b361-8781-47bc-934b-06892458b603', 'insurance', 'Zurich Real Estate Policy Wording.pdf', 'insurance/Zurich Real Estate Policy Wording.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('b73f929e-922a-4c10-a218-725601558271', '6f70b361-8781-47bc-934b-06892458b603', 'insurance', 'Zurich Real Estate Insurance NTP (01.23) ZCYP895.02.pdf', 'insurance/Zurich Real Estate Insurance NTP (01.23) ZCYP895.02.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('6ca87288-878d-455a-af50-0fb0fbe0d2ae', '6f70b361-8781-47bc-934b-06892458b603', 'other', 'StG_Invoice_32-34 Connaught Square W2 2HL.pdf', 'other/StG_Invoice_32-34 Connaught Square W2 2HL.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('d7b0a7db-61ee-45f0-91a8-c4ed5e54279c', '6f70b361-8781-47bc-934b-06892458b603', 'insurance', 'StG_Certificate_32-34 Connaught Square W2 2HL.pdf', 'insurance/StG_Certificate_32-34 Connaught Square W2 2HL.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('c3f4df63-e358-4032-ab3f-0b7308ec4652', '6f70b361-8781-47bc-934b-06892458b603', 'insurance', 'StG_Supporting Docs_32-34 Connaught Square W2 2HL.pdf', 'insurance/StG_Supporting Docs_32-34 Connaught Square W2 2HL.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('2f59a71b-6e61-4944-8a39-a375dfc86b64', '6f70b361-8781-47bc-934b-06892458b603', 'other', 'StG_Invoice_32-34 Connaught Square W2 2HL.pdf', 'other/StG_Invoice_32-34 Connaught Square W2 2HL.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('0e8412a3-939d-43bf-85ec-048567a5e29a', '6f70b361-8781-47bc-934b-06892458b603', 'insurance', 'StG_Certificate_32-34 Connaught Square W2 2HL.pdf', 'insurance/StG_Certificate_32-34 Connaught Square W2 2HL.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('14f433de-f27a-4b8d-ace4-dc9794bb589e', '6f70b361-8781-47bc-934b-06892458b603', 'insurance', 'StG_Statement of Fact_32-34 Connaught Square W2 2HL.pdf', 'insurance/StG_Statement of Fact_32-34 Connaught Square W2 2HL.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('52597da8-cff0-49f8-9d0f-c0ae70a5951e', '6f70b361-8781-47bc-934b-06892458b603', 'other', 'StG_Invoice_32-34 Connaught Square W2 2HL.pdf', 'other/StG_Invoice_32-34 Connaught Square W2 2HL.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('1b7fa3a2-5c80-4bb2-925a-6d990250b4d5', '6f70b361-8781-47bc-934b-06892458b603', 'insurance', 'StG_Statement of Fact_32-34 Connaught Square W2 2HL.pdf', 'insurance/StG_Statement of Fact_32-34 Connaught Square W2 2HL.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('de384004-3f91-4720-806a-0d2d613507ca', '6f70b361-8781-47bc-934b-06892458b603', 'other', 'Connaught Square New property information.xlsx', 'other/Connaught Square New property information.xlsx');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('dbe73a52-e668-4bb1-b6fd-ef8db3e9721a', '6f70b361-8781-47bc-934b-06892458b603', 'other', 'Connaught Square Meeting Minutes 2.docx', 'other/Connaught Square Meeting Minutes 2.docx');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('447f14e2-81da-4946-91cd-457195388c6f', '6f70b361-8781-47bc-934b-06892458b603', 'other', 'connaught.xlsx', 'other/connaught.xlsx');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('8dc72d0b-e2c9-4152-b934-c1e191ab3f5e', '6f70b361-8781-47bc-934b-06892458b603', 'other', 'matrix - pp.xlsx', 'other/matrix - pp.xlsx');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('5aa77a1b-25f0-4481-9088-ef87c3f42635', '6f70b361-8781-47bc-934b-06892458b603', 'other', '12. Change of Tenancy - EDF supporting document.docx', 'other/12. Change of Tenancy - EDF supporting document.docx');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('838ccb1e-2292-46b8-bd2a-b140923af7aa', '6f70b361-8781-47bc-934b-06892458b603', 'other', 'Correspondence letter.pdf', 'other/Correspondence letter.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('5eab88bc-fc2f-438c-aa0e-05d8efe16445', '6f70b361-8781-47bc-934b-06892458b603', 'other', 'tenant list - pp.xlsx', 'other/tenant list - pp.xlsx');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('d5ea5129-e19f-429b-8f40-8dd80a07cb4a', '6f70b361-8781-47bc-934b-06892458b603', 'other', 'Report - 32-34 Connaught Square BCH 78350.pdf', 'other/Report - 32-34 Connaught Square BCH 78350.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('aea3a643-cb36-4853-b2a5-2b78732654da', '6f70b361-8781-47bc-934b-06892458b603', 'other', 'Connaught Square Meeting Minutes 2.docx', 'other/Connaught Square Meeting Minutes 2.docx');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('1d0941f0-126f-4361-bca8-6d5b65232d9d', '6f70b361-8781-47bc-934b-06892458b603', 'other', 'Connaught Square Meeting Minutes 20241120.docx', 'other/Connaught Square Meeting Minutes 20241120.docx');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('0d4bdb5c-1088-4733-843e-a1d7f068bd63', '6f70b361-8781-47bc-934b-06892458b603', 'other', 'Connaught Square Meeting Minutes.docx', 'other/Connaught Square Meeting Minutes.docx');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('a7281ded-0b2b-42c1-affa-2724cb8be118', '6f70b361-8781-47bc-934b-06892458b603', 'other', 'Connaught Square Admin Duties of Co Sec.docx', 'other/Connaught Square Admin Duties of Co Sec.docx');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('6fe202d8-4f58-4da2-9b45-c99461f95dda', '6f70b361-8781-47bc-934b-06892458b603', 'other', 'Signed Connaught Square Admin Duties of Co Sec.pdf', 'other/Signed Connaught Square Admin Duties of Co Sec.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('04983ffe-eccf-4df1-80c6-9ef813e244e7', '6f70b361-8781-47bc-934b-06892458b603', 'other', '32_34 CONNAUGHT SQUARE FREEHOLD LIMITED - Statutory Registers on 22.03.2024.pdf', 'other/32_34 CONNAUGHT SQUARE FREEHOLD LIMITED - Statutory Registers on 22.03.2024.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('2b7d3da5-446d-4a51-bb4c-ff1e7d7a1648', '6f70b361-8781-47bc-934b-06892458b603', 'other', 'Memorandum of Association.pdf', 'other/Memorandum of Association.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('96e9225c-f75d-4ef5-aac5-d855b21b8fcd', '6f70b361-8781-47bc-934b-06892458b603', 'other', 'Incorporation documents.pdf', 'other/Incorporation documents.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('cda26126-3469-49de-a0f3-464089ec8f87', '6f70b361-8781-47bc-934b-06892458b603', 'other', 'B25676 RS 21.05.24 RM CM.pdf', 'other/B25676 RS 21.05.24 RM CM.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('6fe92e49-ccfd-479f-a225-044c164f130b', '6f70b361-8781-47bc-934b-06892458b603', 'other', 'Report-20.08.2024.pdf', 'other/Report-20.08.2024.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('2dcef474-51e7-4917-9a1b-74cfe1dc35c4', '6f70b361-8781-47bc-934b-06892458b603', 'other', 'PN0119V1.7 Privacy Notice (Website).pdf', 'other/PN0119V1.7 Privacy Notice (Website).pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('e8e2ecff-b2d7-4b0e-af61-7dfd24d13ece', '6f70b361-8781-47bc-934b-06892458b603', 'other', 'PN0119V1.8 Privacy Notice (Website).pdf', 'other/PN0119V1.8 Privacy Notice (Website).pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('d0ab4609-a9d1-40ca-a390-4fa943c5bb22', '6f70b361-8781-47bc-934b-06892458b603', 'other', 'REPORT 31-07-25.pdf', 'other/REPORT 31-07-25.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('05f5bae3-1148-440c-a64a-3e6833b47e71', '6f70b361-8781-47bc-934b-06892458b603', 'other', '32-34 Connought Square Condtion Assessments.pdf', 'other/32-34 Connought Square Condtion Assessments.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('8b3a8d8d-c562-40ed-80f6-6e66ae7307bc', '6f70b361-8781-47bc-934b-06892458b603', 'other', 'Signed Conract.pdf', 'other/Signed Conract.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('a1194e53-59c3-4c46-a065-00331b5e76cf', '6f70b361-8781-47bc-934b-06892458b603', 'other', 'BLENHEIMS, CONNAUGHT, W2 2HL PHOTO - 22.01.24.pdf', 'other/BLENHEIMS, CONNAUGHT, W2 2HL PHOTO - 22.01.24.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('7a3a35ea-065e-4203-bde5-61529f05df99', '6f70b361-8781-47bc-934b-06892458b603', 'other', 'BLENHEIMS, CONNAUGHT, W2 2HL PHOTO - 22.03.24.pdf', 'other/BLENHEIMS, CONNAUGHT, W2 2HL PHOTO - 22.03.24.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('a4db0c95-1f56-4939-a255-b6cc2c8c68ac', '6f70b361-8781-47bc-934b-06892458b603', 'other', 'Latest Report.pdf', 'other/Latest Report.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('11b2374e-691e-47ce-ba9d-db9e60273f86', '6f70b361-8781-47bc-934b-06892458b603', 'other', 'Latest Report 24.04.2024.pdf', 'other/Latest Report 24.04.2024.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('1a562576-3b0b-49de-bffd-5185781d5d06', '6f70b361-8781-47bc-934b-06892458b603', 'other', 'Latest Report 19.09.2024.pdf', 'other/Latest Report 19.09.2024.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('aa10a24b-bec3-467d-8c7d-052a9d31843c', '6f70b361-8781-47bc-934b-06892458b603', 'other', 'BLENHEIMS, 32-34 CONNAUGHT, W2 2HL - 25.09.23.pdf', 'other/BLENHEIMS, 32-34 CONNAUGHT, W2 2HL - 25.09.23.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('7b8ba6ef-5af4-43f4-94a5-2e6f279ade91', '6f70b361-8781-47bc-934b-06892458b603', 'other', 'BLENHEIMS, 32-34 CONNAUGHT, W2 2HL PHOTO - 29.11.23.pdf', 'other/BLENHEIMS, 32-34 CONNAUGHT, W2 2HL PHOTO - 29.11.23.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('1fff2a4d-8603-4c23-9fb9-035f1f4954a4', '6f70b361-8781-47bc-934b-06892458b603', 'other', 'BLENHEIMS, 32-34 CONNAUGHT, W2 2HL PHOTO - 18.12.23.pdf', 'other/BLENHEIMS, 32-34 CONNAUGHT, W2 2HL PHOTO - 18.12.23.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('4c8cb0fc-f360-44f2-ac99-de4644d6bd22', '6f70b361-8781-47bc-934b-06892458b603', 'other', 'BLENHEIMS, CONNAUGHT, W2 2HL PHOTO - 23.02.24.pdf', 'other/BLENHEIMS, CONNAUGHT, W2 2HL PHOTO - 23.02.24.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('e76cae19-a94a-482e-b8a1-e9bc45fa9e54', '6f70b361-8781-47bc-934b-06892458b603', 'other', '10.02.25-Pest Control.pdf', 'other/10.02.25-Pest Control.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('273db947-a838-4b13-84f6-97eb3c685df7', '6f70b361-8781-47bc-934b-06892458b603', 'other', 'Latest Report.pdf', 'other/Latest Report.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('d3e60344-d410-43df-bb23-e555aa6b7a43', '6f70b361-8781-47bc-934b-06892458b603', 'other', '17.01.2025-Pest Control.pdf', 'other/17.01.2025-Pest Control.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('ba69d8cb-6cef-4045-88ef-c96b96dffc7e', '6f70b361-8781-47bc-934b-06892458b603', 'other', 'J18503 - MIH, CONNAUGHT SQR, W2 - 04.04.25.pdf', 'other/J18503 - MIH, CONNAUGHT SQR, W2 - 04.04.25.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('bea20ec0-a3bb-4e1c-acfc-75467de314d8', '6f70b361-8781-47bc-934b-06892458b603', 'other', 'J18502 - MIH, CONNAUGHT SQR, W2 - 04.04.25.pdf', 'other/J18502 - MIH, CONNAUGHT SQR, W2 - 04.04.25.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('d03633ed-70f2-4fa2-a889-00f62484aef5', '6f70b361-8781-47bc-934b-06892458b603', 'other', 'BLENHEIMS, CONNAUGHT, W2 2HL PHOTO - 22.01.24.pdf', 'other/BLENHEIMS, CONNAUGHT, W2 2HL PHOTO - 22.01.24.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('2f7a2fce-9f45-4323-aa4c-c5732b0345b0', '6f70b361-8781-47bc-934b-06892458b603', 'other', 'BLENHEIMS, CONNAUGHT, W2 2HL PHOTO - 22.03.24.pdf', 'other/BLENHEIMS, CONNAUGHT, W2 2HL PHOTO - 22.03.24.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('d9463197-a04f-4d2d-b2a2-36ff809ce880', '6f70b361-8781-47bc-934b-06892458b603', 'other', 'BLENHEIMS, 32-34 CONNAUGHT, W2 2HL - 25.09.23.pdf', 'other/BLENHEIMS, 32-34 CONNAUGHT, W2 2HL - 25.09.23.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('e715a22b-1de1-4b5f-b1c6-04ae2865bdc9', '6f70b361-8781-47bc-934b-06892458b603', 'other', 'BLENHEIMS, 32-34 CONNAUGHT, W2 2HL PHOTO - 29.11.23.pdf', 'other/BLENHEIMS, 32-34 CONNAUGHT, W2 2HL PHOTO - 29.11.23.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('4e89bdea-7fc3-402b-980d-895c25d63501', '6f70b361-8781-47bc-934b-06892458b603', 'other', 'BLENHEIMS, 32-34 CONNAUGHT, W2 2HL PHOTO - 18.12.23.pdf', 'other/BLENHEIMS, 32-34 CONNAUGHT, W2 2HL PHOTO - 18.12.23.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('c1257457-d2af-47c8-a2ec-8ec731e5049f', '6f70b361-8781-47bc-934b-06892458b603', 'other', 'BLENHEIMS, CONNAUGHT, W2 2HL PHOTO - 23.02.24.pdf', 'other/BLENHEIMS, CONNAUGHT, W2 2HL PHOTO - 23.02.24.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('3230759d-71e5-44da-b7cf-3775d8843b06', '6f70b361-8781-47bc-934b-06892458b603', 'other', 'INV 11546 Mr Martin Samworth.xlsx', 'other/INV 11546 Mr Martin Samworth.xlsx');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('bcf2fd4a-7791-4a32-9fff-5e3036d4ca3b', '6f70b361-8781-47bc-934b-06892458b603', 'other', 'QB4126 Mr Martin Samworth.docx', 'other/QB4126 Mr Martin Samworth.docx');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('607f0016-b2c5-431f-8901-f1167c6ddb2c', '6f70b361-8781-47bc-934b-06892458b603', 'other', 'CQ2879 Mr Martin Samworth   (IP) CCTV.docx', 'other/CQ2879 Mr Martin Samworth   (IP) CCTV.docx');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('396fe8f6-da71-4aeb-838d-f93f020b870e', '6f70b361-8781-47bc-934b-06892458b603', 'other', 'Asset_Record_For_Job_No_32810_17-03-2025_1311.pdf', 'other/Asset_Record_For_Job_No_32810_17-03-2025_1311.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('8439992f-70c5-4ac6-b3cb-0ae2fc306c98', '6f70b361-8781-47bc-934b-06892458b603', 'other', 'Asset_Record_For_Job_No_32344_12-03-2025_1426.pdf', 'other/Asset_Record_For_Job_No_32344_12-03-2025_1426.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('3026308d-726b-421d-9e6b-0989e3cd8471', '6f70b361-8781-47bc-934b-06892458b603', 'other', 'Asset_Record_For_Job_No_37675_25-07-2025_1549.pdf', 'other/Asset_Record_For_Job_No_37675_25-07-2025_1549.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('7eb88488-94c3-40b2-8ced-71b0167fc413', '6f70b361-8781-47bc-934b-06892458b603', 'other', 'Asset_Record_For_Job_No_34012_01-05-2025_1616.pdf', 'other/Asset_Record_For_Job_No_34012_01-05-2025_1616.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('afbf52d0-8f36-444a-ba2b-39200b2c62e9', '6f70b361-8781-47bc-934b-06892458b603', 'other', 'Asset_Record_For_Job_No_32759_17-03-2025_1147.pdf', 'other/Asset_Record_For_Job_No_32759_17-03-2025_1147.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('1bf62ad2-3992-4717-9448-1e02a95728fa', '6f70b361-8781-47bc-934b-06892458b603', 'other', 'Jobcard_For_Job_No_32344_12-03-2025_1426.pdf', 'other/Jobcard_For_Job_No_32344_12-03-2025_1426.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('80b4daed-280d-48fe-b8c8-5cca5b3a3506', '6f70b361-8781-47bc-934b-06892458b603', 'other', 'Asset_Record_For_Job_No_33844_07-04-2025_1143.pdf', 'other/Asset_Record_For_Job_No_33844_07-04-2025_1143.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('7f98690a-3ef4-4e9c-9f51-06014f8cfd24', '6f70b361-8781-47bc-934b-06892458b603', 'other', 'Asset_Record_For_Job_No_25732_03-10-2024_1337.pdf', 'other/Asset_Record_For_Job_No_25732_03-10-2024_1337.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('7c5b6c7c-dfee-4f2c-8788-22a7186c5796', '6f70b361-8781-47bc-934b-06892458b603', 'other', 'Asset_Record_For_Job_No_22634_03-07-2024_1650.pdf', 'other/Asset_Record_For_Job_No_22634_03-07-2024_1650.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('777cbb79-3ee7-401b-a8a2-021d95024a29', '6f70b361-8781-47bc-934b-06892458b603', 'other', 'Asset_Record_For_Job_No_27067_07-10-2024_1147.pdf', 'other/Asset_Record_For_Job_No_27067_07-10-2024_1147.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('7437f17f-4eb4-421f-b866-a5b393392a63', '6f70b361-8781-47bc-934b-06892458b603', 'other', 'Asset_Record_For_Job_No_19665_05-04-2024_1048.pdf', 'other/Asset_Record_For_Job_No_19665_05-04-2024_1048.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('3aa238f4-79f6-44eb-bb1f-53178e7bbbcb', '6f70b361-8781-47bc-934b-06892458b603', 'other', 'Connaught Square-Lift Quotes.xlsx', 'other/Connaught Square-Lift Quotes.xlsx');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('c84fd603-6c71-405a-a09f-d0ef4010e537', '6f70b361-8781-47bc-934b-06892458b603', 'other', 'LXBI3559280XB2-NEW STEP-Business-Certificate of el insurance.pdf', 'other/LXBI3559280XB2-NEW STEP-Business-Certificate of el insurance.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('356b59e2-7a84-4562-8ce2-e9bc468c7c07', '6f70b361-8781-47bc-934b-06892458b603', 'other', 'New Step - Cleaning of Com Part- Jan- 2023.pdf', 'other/New Step - Cleaning of Com Part- Jan- 2023.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('91f69cc8-77c6-4b19-910b-5b3f8ebfc318', '6f70b361-8781-47bc-934b-06892458b603', 'other', 'Aged debtors by property.pdf', 'other/Aged debtors by property.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('52052214-0162-43f2-a461-0884068058e6', '6f70b361-8781-47bc-934b-06892458b603', 'other', 'Connaught Square, 32-34 Approved xlsx.xlsx', 'other/Connaught Square, 32-34 Approved xlsx.xlsx');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('20611c1a-9586-44f3-ad6d-f3a6ed97f7c9', '6f70b361-8781-47bc-934b-06892458b603', 'other', 'BvA 24 Jan 25.xlsx', 'other/BvA 24 Jan 25.xlsx');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('9d93583c-cbb7-46eb-bc25-081b335d5e8a', '6f70b361-8781-47bc-934b-06892458b603', 'other', 'pdf.pdf', 'other/pdf.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('aaffe015-45ae-4bf5-8c51-0984960bad56', '6f70b361-8781-47bc-934b-06892458b603', 'other', 'Connaught Square-Agenda 20.11.24.docx', 'other/Connaught Square-Agenda 20.11.24.docx');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('d8fa296c-31aa-476d-8f34-4a35ddfa5fdf', '6f70b361-8781-47bc-934b-06892458b603', 'other', 'Connaught Square-Agenda 26.04.2024.docx', 'other/Connaught Square-Agenda 26.04.2024.docx');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('8ac9ccdc-360e-4a1c-8da5-2a30b83c5881', '6f70b361-8781-47bc-934b-06892458b603', 'other', 'Connaught Square 26.04.24.docx', 'other/Connaught Square 26.04.24.docx');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('bb201b57-20ff-49ca-84ce-858d9b1e5752', '6f70b361-8781-47bc-934b-06892458b603', 'other', 'StG_Quote_32-34 Connaught Square W2 2HL.pdf', 'other/StG_Quote_32-34 Connaught Square W2 2HL.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('c9555645-3776-4ef3-9b00-1cf67c9cb714', '6f70b361-8781-47bc-934b-06892458b603', 'other', 'StG_Policy Wording_32-34 Connaught Square W2 2HL.pdf', 'other/StG_Policy Wording_32-34 Connaught Square W2 2HL.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('17b0c142-012b-4de1-9258-761aabf0eedb', '6f70b361-8781-47bc-934b-06892458b603', 'other', 'StG_Quote_32-34 Connaught Square W2 2HL.pdf', 'other/StG_Quote_32-34 Connaught Square W2 2HL.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('09e17081-bcd9-4bef-8330-746a50a6a287', '6f70b361-8781-47bc-934b-06892458b603', 'other', 'StG_Policy Wording_32-34 Connaught Square W2 2HL.pdf', 'other/StG_Policy Wording_32-34 Connaught Square W2 2HL.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('a9e713eb-5deb-41d0-a1b6-233dfc6e0531', '6f70b361-8781-47bc-934b-06892458b603', 'other', 'Report - 32-34 Connaught Square BCH 78350.pdf', 'other/Report - 32-34 Connaught Square BCH 78350.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('345643b2-8e0a-4f88-900e-e7ade227e83f', '6f70b361-8781-47bc-934b-06892458b603', 'other', 'Asset_Record_For_Job_No_16617_27-11-2023_1522.pdf', 'other/Asset_Record_For_Job_No_16617_27-11-2023_1522.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('c297cc24-8eb0-4360-aaa3-cb8ce959949e', '6f70b361-8781-47bc-934b-06892458b603', 'other', 'Asset_Record_For_Job_No_16808_28-11-2023_1340.pdf', 'other/Asset_Record_For_Job_No_16808_28-11-2023_1340.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('e936a273-7fb4-4020-9a21-55bdbbf84b81', '6f70b361-8781-47bc-934b-06892458b603', 'other', 'EX-NC (CONNAUGHT SQUARE) EXTRA 01102024.pdf', 'other/EX-NC (CONNAUGHT SQUARE) EXTRA 01102024.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('735c6c1f-fd3a-4507-8a3c-7c3630b6d951', '6f70b361-8781-47bc-934b-06892458b603', 'other', 'H&S recomendations - Spreadsheet with comments.xlsx', 'other/H&S recomendations - Spreadsheet with comments.xlsx');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('b8370e68-03ea-4b3c-8b86-b3b95b01434f', '6f70b361-8781-47bc-934b-06892458b603', 'other', 'CM434 RS 32-34 Connaught Square - VISIT 1 OF 2 - 30-04-25.pdf', 'other/CM434 RS 32-34 Connaught Square - VISIT 1 OF 2 - 30-04-25.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('a4ec15db-a723-45c7-ae83-4861954692e2', '6f70b361-8781-47bc-934b-06892458b603', 'other', 'Q49511 - 32-34 Connaught Square.pdf', 'other/Q49511 - 32-34 Connaught Square.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('4ed62de8-0ac9-4321-b56d-7bce918e2a1a', '6f70b361-8781-47bc-934b-06892458b603', 'other', 'FA7817 CALL OUT 26032025.pdf', 'other/FA7817 CALL OUT 26032025.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('a675a78f-64a0-41a5-b4cb-895dd5a2b8de', '6f70b361-8781-47bc-934b-06892458b603', 'other', '32 Connaught Sq - PAT .pdf', 'other/32 Connaught Sq - PAT .pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('3383a69a-856b-40a0-b8cb-34f3244a0ac8', '6f70b361-8781-47bc-934b-06892458b603', 'other', 'Asset_Record_For_Job_No_35146_03-06-2025_0906.pdf', 'other/Asset_Record_For_Job_No_35146_03-06-2025_0906.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('4d2a8a88-d5f0-457d-b1c0-c5e52464e8f6', '6f70b361-8781-47bc-934b-06892458b603', 'other', 'Asset_Record_For_Job_No_31162_30-01-2025_1603.pdf', 'other/Asset_Record_For_Job_No_31162_30-01-2025_1603.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('5c2b432f-5545-4b86-ad26-a21072f229b7', '6f70b361-8781-47bc-934b-06892458b603', 'other', 'Asset_Record_For_Job_No_37675_25-07-2025_1549.pdf', 'other/Asset_Record_For_Job_No_37675_25-07-2025_1549.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('98ab207f-69be-4da6-b34a-bf8335bdd012', '6f70b361-8781-47bc-934b-06892458b603', 'other', 'Asset_Record_For_Job_No_28737_25-11-2024_0907.pdf', 'other/Asset_Record_For_Job_No_28737_25-11-2024_0907.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('0387d076-4408-4032-9118-b1ad27621954', '6f70b361-8781-47bc-934b-06892458b603', 'other', 'Asset_Record_For_Job_No_35402_03-06-2025_0916.pdf', 'other/Asset_Record_For_Job_No_35402_03-06-2025_0916.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('7f57ece8-7bae-4102-b934-95e16810e7e0', '6f70b361-8781-47bc-934b-06892458b603', 'other', 'Asset_Record_For_Job_No_22171_14-05-2024_1202.pdf', 'other/Asset_Record_For_Job_No_22171_14-05-2024_1202.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('56512739-499d-4830-b246-1346bbe073fb', '6f70b361-8781-47bc-934b-06892458b603', 'other', 'Asset_Record_For_Job_No_35654_03-06-2025_0912.pdf', 'other/Asset_Record_For_Job_No_35654_03-06-2025_0912.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('fc32a70a-64c5-40fa-aa07-4bddcb7a23ae', '6f70b361-8781-47bc-934b-06892458b603', 'other', 'Asset_Record_For_Job_No_38609_26-08-2025_0740.pdf', 'other/Asset_Record_For_Job_No_38609_26-08-2025_0740.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('c5573f01-13b5-4ea0-8d46-0ee8d2bea32b', '6f70b361-8781-47bc-934b-06892458b603', 'other', 'Asset_Record_For_Job_No_36465_20-06-2025_1038.pdf', 'other/Asset_Record_For_Job_No_36465_20-06-2025_1038.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('01210cd2-1b68-4146-a094-cded77187222', '6f70b361-8781-47bc-934b-06892458b603', 'other', '26368 Report.pdf', 'other/26368 Report.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('10bc1aac-90c7-40da-9ad5-8603217cbf56', '6f70b361-8781-47bc-934b-06892458b603', 'other', '26474 Report.pdf', 'other/26474 Report.pdf');

-- Insert 26 apportionments
INSERT INTO apportionments (id, building_id, percentage) VALUES ('cd7e6e3e-f05f-4494-b468-08949339c3a9', '6f70b361-8781-47bc-934b-06892458b603', 32.0);
INSERT INTO apportionments (id, building_id, percentage) VALUES ('f42e17a7-f4a6-42f3-a4d0-7a52c8a860f7', '6f70b361-8781-47bc-934b-06892458b603', 10.0);
INSERT INTO apportionments (id, building_id, percentage) VALUES ('46268db1-9954-445f-b70b-3f598bdd67cf', '6f70b361-8781-47bc-934b-06892458b603', 32.0);
INSERT INTO apportionments (id, building_id, percentage) VALUES ('b78bec2e-af05-4773-a497-5ad5b328571a', '6f70b361-8781-47bc-934b-06892458b603', 19.0);
INSERT INTO apportionments (id, building_id, percentage) VALUES ('2a66a54d-5769-4951-8e3e-d000e304307b', '6f70b361-8781-47bc-934b-06892458b603', 2.0);
INSERT INTO apportionments (id, building_id, percentage) VALUES ('37096de0-a9ec-4025-9017-5b5b5293de05', '6f70b361-8781-47bc-934b-06892458b603', 2.0);
INSERT INTO apportionments (id, building_id, percentage) VALUES ('a65088b5-2f0e-43c5-bc97-e66c789c188c', '6f70b361-8781-47bc-934b-06892458b603', 2.0);
INSERT INTO apportionments (id, building_id, percentage) VALUES ('9ef9b1d3-0d19-42d8-a656-4ac13a165880', '6f70b361-8781-47bc-934b-06892458b603', 2.0);
INSERT INTO apportionments (id, building_id, percentage) VALUES ('23de871b-d544-45d5-aab0-55678f8eb802', '6f70b361-8781-47bc-934b-06892458b603', 2.0);
INSERT INTO apportionments (id, building_id, percentage) VALUES ('54f18315-d39b-42c6-882c-b0aacde04f25', '6f70b361-8781-47bc-934b-06892458b603', 8.0);
INSERT INTO apportionments (id, building_id, percentage) VALUES ('d00b12e4-2890-4170-b192-6c30a756abd0', '6f70b361-8781-47bc-934b-06892458b603', 3.0);
INSERT INTO apportionments (id, building_id, percentage) VALUES ('f2b391a7-94a3-4999-a083-352dcc734e91', '6f70b361-8781-47bc-934b-06892458b603', 3.0);
INSERT INTO apportionments (id, building_id, percentage) VALUES ('e77e90a7-2a9a-44a3-a6dc-40581c1a2e97', '6f70b361-8781-47bc-934b-06892458b603', 3.0);
INSERT INTO apportionments (id, building_id, percentage) VALUES ('6676844e-de40-47e4-bdfd-d0293a1fce3b', '6f70b361-8781-47bc-934b-06892458b603', 3.0);
INSERT INTO apportionments (id, building_id, percentage) VALUES ('e2c1ab26-38c6-4453-a6b7-46e25f9833bd', '6f70b361-8781-47bc-934b-06892458b603', 3.0);
INSERT INTO apportionments (id, building_id, percentage) VALUES ('3e408310-b6ad-438e-a85d-0904ff4f3441', '6f70b361-8781-47bc-934b-06892458b603', 3.0);
INSERT INTO apportionments (id, building_id, percentage) VALUES ('fecf88ac-444b-4fdf-a38f-acbd2c5cead8', '6f70b361-8781-47bc-934b-06892458b603', 3.0);
INSERT INTO apportionments (id, building_id, percentage) VALUES ('ba6a8c5c-5811-4e18-a8f0-e848b9c6ac41', '6f70b361-8781-47bc-934b-06892458b603', 3.0);
INSERT INTO apportionments (id, building_id, percentage) VALUES ('7bd10ae0-e248-4d66-b706-3f3b0c298946', '6f70b361-8781-47bc-934b-06892458b603', 8.0);
INSERT INTO apportionments (id, building_id, percentage) VALUES ('c141829f-f4c9-452f-aa66-907ec3a44ec4', '6f70b361-8781-47bc-934b-06892458b603', 3.0);
INSERT INTO apportionments (id, building_id, percentage) VALUES ('b6e868d8-f94f-47a3-9dbc-f251ad4004f4', '6f70b361-8781-47bc-934b-06892458b603', 8.0);
INSERT INTO apportionments (id, building_id, percentage) VALUES ('922f5096-917f-4055-a8ef-c6ab9dc4da71', '6f70b361-8781-47bc-934b-06892458b603', 8.0);
INSERT INTO apportionments (id, building_id, percentage) VALUES ('0933b1ef-a38e-44d7-a08f-0c65a8a96c44', '6f70b361-8781-47bc-934b-06892458b603', 8.0);
INSERT INTO apportionments (id, building_id, percentage) VALUES ('e30fcd42-7808-41be-a98d-e6c6cbd903f8', '6f70b361-8781-47bc-934b-06892458b603', 8.0);
INSERT INTO apportionments (id, building_id, percentage) VALUES ('9dccea42-9a41-463a-bf68-4fada54eca67', '6f70b361-8781-47bc-934b-06892458b603', 8.0);
INSERT INTO apportionments (id, building_id, percentage) VALUES ('e3e560d1-8187-411f-a5a6-1a6e38b63f41', '6f70b361-8781-47bc-934b-06892458b603', 8.0);

-- Insert 131 insurance records
INSERT INTO building_insurance (id, building_id, policy_number, insurance_type) VALUES ('aaed0645-8058-4db2-98e5-e74d55efa523', '6f70b361-8781-47bc-934b-06892458b603', 'CGBI3964546XB', 'general');
INSERT INTO building_insurance (id, building_id, policy_number, insurance_type) VALUES ('2526e3a0-d94a-4012-9aa4-9eab188c5b0b', '6f70b361-8781-47bc-934b-06892458b603', 'CGBI3964546XB', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('ab5a98cd-32e4-49fc-8f89-b97baa88cf34', '6f70b361-8781-47bc-934b-06892458b603', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('95d1773f-0b50-431a-a2f7-f8c21174bf12', '6f70b361-8781-47bc-934b-06892458b603', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('70f5e3a1-cd46-4094-812c-1e9237b71c61', '6f70b361-8781-47bc-934b-06892458b603', 'general');
INSERT INTO building_insurance (id, building_id, policy_number, insurance_type) VALUES ('735ef49b-43ea-4ec1-9cc5-6594492b2788', '6f70b361-8781-47bc-934b-06892458b603', 'and', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('926ec773-d9e0-4cca-842a-8fa6d46c5747', '6f70b361-8781-47bc-934b-06892458b603', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('4a36c638-01e0-4038-9839-1f79d1d17149', '6f70b361-8781-47bc-934b-06892458b603', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('73db0765-3fc0-4711-a68b-7fcc99641eec', '6f70b361-8781-47bc-934b-06892458b603', 'general');
INSERT INTO building_insurance (id, building_id, policy_number, insurance_type) VALUES ('31a37a6d-43c0-4eaa-bac0-2fc92f7387de', '6f70b361-8781-47bc-934b-06892458b603', 'NZ23346712', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('f2509b68-740d-44e9-b999-e6646046d056', '6f70b361-8781-47bc-934b-06892458b603', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('ce5a24d7-aca5-439c-8c92-f1e796ede811', '6f70b361-8781-47bc-934b-06892458b603', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('f7f98acf-dab0-4397-895c-0baab011c52f', '6f70b361-8781-47bc-934b-06892458b603', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('e415a4f3-449d-43f3-b9c3-a0f2b11a24b2', '6f70b361-8781-47bc-934b-06892458b603', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('64f3185b-4ac1-4a2a-866e-b9c552a702a5', '6f70b361-8781-47bc-934b-06892458b603', 'general');
INSERT INTO building_insurance (id, building_id, policy_number, insurance_type) VALUES ('958a18f0-dec9-4c51-be6d-dad3c752e02a', '6f70b361-8781-47bc-934b-06892458b603', 'ARCH', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('38c8eab9-2968-46d1-8344-c558a72eee40', '6f70b361-8781-47bc-934b-06892458b603', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('833b642e-a9a6-46f4-a811-918d4ef4dddf', '6f70b361-8781-47bc-934b-06892458b603', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('398e02a6-9813-4a7e-b04b-63e663ce7218', '6f70b361-8781-47bc-934b-06892458b603', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('0ef6810a-64e8-47d7-8825-34b5c120f495', '6f70b361-8781-47bc-934b-06892458b603', 'general');
INSERT INTO building_insurance (id, building_id, policy_number, insurance_type) VALUES ('0d06f167-3b60-49cf-922f-d963fb1be624', '6f70b361-8781-47bc-934b-06892458b603', 'FU117816', 'general');
INSERT INTO building_insurance (id, building_id, policy_number, insurance_type) VALUES ('37cec1e9-0a80-4a68-8c73-47ac2c44874d', '6f70b361-8781-47bc-934b-06892458b603', 'FU117816', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('0f0d96c6-232f-45a9-a078-4750c0191054', '6f70b361-8781-47bc-934b-06892458b603', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('3149a183-d474-47b9-b20d-d6c79a80126e', '6f70b361-8781-47bc-934b-06892458b603', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('153d7ed7-f56d-4b16-ad59-5ed508f9e2b4', '6f70b361-8781-47bc-934b-06892458b603', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('010fc9a6-785e-4720-8a49-9f54e6e7710e', '6f70b361-8781-47bc-934b-06892458b603', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('f3328397-8eba-4c33-928f-ada50f682441', '6f70b361-8781-47bc-934b-06892458b603', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('8da2c2a4-3351-4045-aef0-ea9c4b204497', '6f70b361-8781-47bc-934b-06892458b603', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('ce88b21d-506c-494b-bb1e-d8ee02aa9515', '6f70b361-8781-47bc-934b-06892458b603', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('09cf6a25-58e7-4c13-b221-1eab76ef6f64', '6f70b361-8781-47bc-934b-06892458b603', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('d58c10bc-d598-4cc4-a164-8d58530596a8', '6f70b361-8781-47bc-934b-06892458b603', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('81d7b9c3-f01b-4618-9048-e66424ccbe71', '6f70b361-8781-47bc-934b-06892458b603', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('2e490f7e-adc6-4324-8c85-434ba66ea5d7', '6f70b361-8781-47bc-934b-06892458b603', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('e1ee13ce-29ee-4037-9f94-ac5ab6c1468f', '6f70b361-8781-47bc-934b-06892458b603', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('57ed6a13-3ef3-4b70-951b-97e30e46cd1a', '6f70b361-8781-47bc-934b-06892458b603', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('678c9e84-bc40-451d-adc7-8b584d72ff61', '6f70b361-8781-47bc-934b-06892458b603', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('fd9a4bbe-7722-41c1-8985-babaf97a2a0b', '6f70b361-8781-47bc-934b-06892458b603', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('699d5f9d-1af8-466e-8553-681a77ec0a26', '6f70b361-8781-47bc-934b-06892458b603', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('57c69100-528d-46df-a1c1-e96f92b01810', '6f70b361-8781-47bc-934b-06892458b603', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('90e718ea-9d3d-4a3b-8219-109eca222edb', '6f70b361-8781-47bc-934b-06892458b603', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('45e7c075-f939-4476-bb0a-1c61841f0d0a', '6f70b361-8781-47bc-934b-06892458b603', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('a5deceb8-ea08-412f-8d34-b71031017025', '6f70b361-8781-47bc-934b-06892458b603', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('e3fde0b4-0795-42df-96bf-33e80b8adf25', '6f70b361-8781-47bc-934b-06892458b603', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('a0a878a5-38ef-45ef-9649-d367f8f7dc81', '6f70b361-8781-47bc-934b-06892458b603', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('f6ad40cd-7ef0-4d79-82c7-6f74bb8185cf', '6f70b361-8781-47bc-934b-06892458b603', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('78f47c4c-0770-4e00-b2a8-85a398022caf', '6f70b361-8781-47bc-934b-06892458b603', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('c460d551-5da0-4ec9-bb60-491fe16acafb', '6f70b361-8781-47bc-934b-06892458b603', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('e18f251b-7870-4f6b-b7d0-ed057dad0b34', '6f70b361-8781-47bc-934b-06892458b603', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('afaf7257-448a-4133-8b35-ff536330a3b8', '6f70b361-8781-47bc-934b-06892458b603', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('ff9e5708-ce3b-4e2a-8622-14d66bfd6a32', '6f70b361-8781-47bc-934b-06892458b603', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('07a76c9e-7484-48b3-aae6-adbc783082d5', '6f70b361-8781-47bc-934b-06892458b603', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('93942d24-4c46-47b0-85a7-52bca6ebe5fb', '6f70b361-8781-47bc-934b-06892458b603', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('b20c5f87-a7a4-4d11-b699-854bb45b350b', '6f70b361-8781-47bc-934b-06892458b603', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('5d91b44e-9df3-415a-99ed-31a9aa8062ad', '6f70b361-8781-47bc-934b-06892458b603', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('5dc836dc-73bc-495f-9b16-c763cb778789', '6f70b361-8781-47bc-934b-06892458b603', 'general');
INSERT INTO building_insurance (id, building_id, policy_number, insurance_type) VALUES ('700948d6-18c5-4515-9040-2a6aa7871551', '6f70b361-8781-47bc-934b-06892458b603', 'LXBI3559280XB', 'general');
INSERT INTO building_insurance (id, building_id, policy_number, insurance_type) VALUES ('47fae066-142c-48de-9762-39542341fab4', '6f70b361-8781-47bc-934b-06892458b603', 'LXBI3559280XB', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('f4b72525-a7e0-46d3-b1bd-c7a0daf5893c', '6f70b361-8781-47bc-934b-06892458b603', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('5b22f41d-b96d-4341-bb69-a2582579cdb1', '6f70b361-8781-47bc-934b-06892458b603', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('946fff93-8ca7-4bca-9f7e-c9edc685e33e', '6f70b361-8781-47bc-934b-06892458b603', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('643a6010-c844-4e4b-a0ec-f4b5583941be', '6f70b361-8781-47bc-934b-06892458b603', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('9a4217ef-828d-4b1e-9645-9bba7a060d45', '6f70b361-8781-47bc-934b-06892458b603', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('d239ffda-f716-4747-b12a-6d589574b574', '6f70b361-8781-47bc-934b-06892458b603', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('a49d1833-ed62-41bd-861a-69e40bec0b01', '6f70b361-8781-47bc-934b-06892458b603', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('ad67ebb4-99e5-4eec-a443-27c5f6af7afa', '6f70b361-8781-47bc-934b-06892458b603', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('df67a3d5-a7d1-4515-b622-0b8dce024aef', '6f70b361-8781-47bc-934b-06892458b603', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('017debf8-6930-48e1-b0d0-5a868e28deea', '6f70b361-8781-47bc-934b-06892458b603', 'general');
INSERT INTO building_insurance (id, building_id, policy_number, insurance_type) VALUES ('902030ac-ca5e-48b9-bed8-b05d0885a8f7', '6f70b361-8781-47bc-934b-06892458b603', 'NZ23346712', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('e211193f-26a9-45d1-b6a6-ab5f6ae602b7', '6f70b361-8781-47bc-934b-06892458b603', 'general');
INSERT INTO building_insurance (id, building_id, policy_number, insurance_type) VALUES ('db2c46e1-469c-42b1-ad89-34e41ccbd91b', '6f70b361-8781-47bc-934b-06892458b603', 'and', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('34b58fc6-ae14-46d5-bacb-5b758d5993f5', '6f70b361-8781-47bc-934b-06892458b603', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('a7b861cb-26de-4f92-b91e-841fd566f133', '6f70b361-8781-47bc-934b-06892458b603', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('b4eea6e4-a38f-47c2-aca8-ee9b44cda8f7', '6f70b361-8781-47bc-934b-06892458b603', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('671a940a-a346-4ab7-889e-73e79be5be48', '6f70b361-8781-47bc-934b-06892458b603', 'general');
INSERT INTO building_insurance (id, building_id, policy_number, insurance_type) VALUES ('fdff97fc-8802-4d6e-952e-fa10416b2294', '6f70b361-8781-47bc-934b-06892458b603', 'STGLON', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('d5959a0c-ff2b-4ee6-92c0-fbabba8eed6c', '6f70b361-8781-47bc-934b-06892458b603', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('41a3bfe8-0d6f-4989-bb7f-da15f8662082', '6f70b361-8781-47bc-934b-06892458b603', 'general');
INSERT INTO building_insurance (id, building_id, policy_number, insurance_type) VALUES ('ed52002d-d287-431d-8865-c6a18c33b06a', '6f70b361-8781-47bc-934b-06892458b603', 'STGLON', 'general');
INSERT INTO building_insurance (id, building_id, policy_number, insurance_type) VALUES ('6cfea9bf-02d2-46e8-bb96-398828bfb071', '6f70b361-8781-47bc-934b-06892458b603', 'STGLON', 'general');
INSERT INTO building_insurance (id, building_id, policy_number, insurance_type) VALUES ('01846021-de49-4554-ab55-5de845ffb625', '6f70b361-8781-47bc-934b-06892458b603', 'BERTSTGLON', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('138d80de-6be7-4d25-b29e-556d7c67f329', '6f70b361-8781-47bc-934b-06892458b603', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('5947e90e-a3e4-4d47-a7a6-343730e806e0', '6f70b361-8781-47bc-934b-06892458b603', 'general');
INSERT INTO building_insurance (id, building_id, policy_number, insurance_type) VALUES ('9498109e-e1ae-4841-8356-23191165da7f', '6f70b361-8781-47bc-934b-06892458b603', 'LP', 'general');
INSERT INTO building_insurance (id, building_id, policy_number, insurance_type) VALUES ('8dab34ef-14f2-4bd7-914b-193b5ab698b2', '6f70b361-8781-47bc-934b-06892458b603', 'HL', 'general');
INSERT INTO building_insurance (id, building_id, policy_number, insurance_type) VALUES ('2fd1bbe1-2947-49d0-b0eb-93e9bab00519', '6f70b361-8781-47bc-934b-06892458b603', 'ARCH', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('0ee75bf4-ceb5-43b3-af2c-0d22e32ae4c8', '6f70b361-8781-47bc-934b-06892458b603', 'general');
INSERT INTO building_insurance (id, building_id, policy_number, insurance_type) VALUES ('e1f74566-bdf2-46d5-bc26-2b5f67e7662d', '6f70b361-8781-47bc-934b-06892458b603', 'and', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('76d5a206-e6c9-4461-8a75-9fb87545ee40', '6f70b361-8781-47bc-934b-06892458b603', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('823cfe4f-929e-497e-a938-d9f8f40155e7', '6f70b361-8781-47bc-934b-06892458b603', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('3f57b3e5-6964-45e9-b89c-f387f27b15b5', '6f70b361-8781-47bc-934b-06892458b603', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('f710b8e3-c6fe-403f-99c9-3629a1e3ed40', '6f70b361-8781-47bc-934b-06892458b603', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('0a5ae7b7-a220-4d50-8b42-81b58af6da0c', '6f70b361-8781-47bc-934b-06892458b603', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('28c368c3-60b0-42ef-8287-0255788f3e74', '6f70b361-8781-47bc-934b-06892458b603', 'general');
INSERT INTO building_insurance (id, building_id, policy_number, insurance_type) VALUES ('615e8d1f-8cda-41cc-a095-c8dcac1c3c09', '6f70b361-8781-47bc-934b-06892458b603', 'and', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('ab7aca46-d7f2-4d4e-b080-920c1a01d845', '6f70b361-8781-47bc-934b-06892458b603', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('40b5b04e-0787-4f96-b95a-fcc9fee8930f', '6f70b361-8781-47bc-934b-06892458b603', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('c28bbdd5-67f7-4882-8b8e-35b5ab34001b', '6f70b361-8781-47bc-934b-06892458b603', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('22e8229c-f798-4489-bdb2-5e3a23af7d46', '6f70b361-8781-47bc-934b-06892458b603', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('ca824fe9-7ba4-4dae-bfbd-0fa289caba0e', '6f70b361-8781-47bc-934b-06892458b603', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('a11aa638-bc42-43e1-9fca-5d9200a4f53e', '6f70b361-8781-47bc-934b-06892458b603', 'general');
INSERT INTO building_insurance (id, building_id, policy_number, insurance_type) VALUES ('2751269b-53d8-4184-bcdd-1f3d34778c82', '6f70b361-8781-47bc-934b-06892458b603', 'and', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('17b66f32-1570-4425-a438-089b135d67bc', '6f70b361-8781-47bc-934b-06892458b603', 'general');
INSERT INTO building_insurance (id, building_id, policy_number, insurance_type) VALUES ('68b88aa7-1db4-4406-a025-5c445bbe028e', '6f70b361-8781-47bc-934b-06892458b603', 'BP13228-2501', 'general');
INSERT INTO building_insurance (id, building_id, policy_number, insurance_type) VALUES ('fd2c35ee-c3df-4d93-93cc-59d11a3b0761', '6f70b361-8781-47bc-934b-06892458b603', 'BP13228-2501', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('d2b77392-93ab-4112-9426-84fdbef2aa90', '6f70b361-8781-47bc-934b-06892458b603', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('ed730a72-d0e8-45a9-adf3-4abd3932ac43', '6f70b361-8781-47bc-934b-06892458b603', 'general');
INSERT INTO building_insurance (id, building_id, policy_number, insurance_type) VALUES ('09c907b3-b213-421f-ab58-b36666b82763', '6f70b361-8781-47bc-934b-06892458b603', 'TA0604600', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('28abcc3b-efa0-405a-b376-9757962175b4', '6f70b361-8781-47bc-934b-06892458b603', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('d0b5db8d-3c9b-48e2-a001-ab48021ea713', '6f70b361-8781-47bc-934b-06892458b603', 'general');
INSERT INTO building_insurance (id, building_id, policy_number, insurance_type) VALUES ('7d68cc19-00a0-4e84-8698-ed0e9bf6579e', '6f70b361-8781-47bc-934b-06892458b603', 'HL', 'general');
INSERT INTO building_insurance (id, building_id, policy_number, insurance_type) VALUES ('e9cfa654-bebc-4499-8182-ed1fd4c6845c', '6f70b361-8781-47bc-934b-06892458b603', 'Camberford', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('a6087ae3-20b8-4d0e-9805-a39f2b9cf8e5', '6f70b361-8781-47bc-934b-06892458b603', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('ff86c765-3325-4918-84f2-a012d6b20da0', '6f70b361-8781-47bc-934b-06892458b603', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('87363646-e83f-4ec9-a3ff-b6ef42aebd82', '6f70b361-8781-47bc-934b-06892458b603', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('28f640b0-a8f1-4d0d-aaa1-c0106df053f5', '6f70b361-8781-47bc-934b-06892458b603', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('8682f1ea-b553-4da5-9e22-1b5d24f3c228', '6f70b361-8781-47bc-934b-06892458b603', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('5fdce9b5-e708-4c85-ad9e-30030af974ce', '6f70b361-8781-47bc-934b-06892458b603', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('12ad867f-b05e-43b7-8945-d1de88d4f204', '6f70b361-8781-47bc-934b-06892458b603', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('3551ac32-38aa-4059-8eb3-e16709b2c59c', '6f70b361-8781-47bc-934b-06892458b603', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('faf002de-90d4-427e-b54c-a7cf1022af2e', '6f70b361-8781-47bc-934b-06892458b603', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('ac73dd24-22c0-44af-b55a-e1a8e63856fb', '6f70b361-8781-47bc-934b-06892458b603', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('35ed8226-6725-402f-9fe3-b082ab4a2d4f', '6f70b361-8781-47bc-934b-06892458b603', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('dc8fc42b-2e32-4626-8343-5c2e6b50fae5', '6f70b361-8781-47bc-934b-06892458b603', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('078f40fe-a3b5-4a5f-af3d-68d9edc73840', '6f70b361-8781-47bc-934b-06892458b603', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('8c598a29-d5a6-4e2f-bedd-aa76647a2b2c', '6f70b361-8781-47bc-934b-06892458b603', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('6315dad2-6264-488e-83e2-5951614c51ba', '6f70b361-8781-47bc-934b-06892458b603', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('4cc3a1e5-757f-4243-ac62-921196664358', '6f70b361-8781-47bc-934b-06892458b603', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('9fc89280-3911-4a0b-89b4-5241e623d003', '6f70b361-8781-47bc-934b-06892458b603', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('6f515f20-d620-41b5-affb-9966d0f3e706', '6f70b361-8781-47bc-934b-06892458b603', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('c518c8dd-f2af-4054-a12d-b2f4d5fd625a', '6f70b361-8781-47bc-934b-06892458b603', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('d941d2ec-a5b2-4648-9762-70dce2bac28c', '6f70b361-8781-47bc-934b-06892458b603', 'general');

-- ===========================
-- CONTRACTORS
-- ===========================

INSERT INTO contractors (id, name, phone, address) VALUES
('bceec86b-2945-4c39-8fd7-dee8e3586cd3', 'ISS', '083603538855', 'London, We''re available on Live Chat here., W1S 1RS')
ON CONFLICT (id) DO NOTHING;

INSERT INTO contractors (id, name, email, phone, address) VALUES
('095ec856-5cbb-403a-a8c0-81c7ba1ca034', 'Quotehedge', 'info@quotehedge-heating.co.uk', '07801 799118', '182 Revelstoke Road, Wandsworth, London, SW18 5NW')
ON CONFLICT (id) DO NOTHING;

INSERT INTO contractors (id, name, email, address) VALUES
('a21f70f0-e6ae-48e0-b99e-a7c3becbe2b1', 'WHM', 'enquiries@whmltd.org', 'WATER HYGIENE MANAGEMENT L TD, 2 Churchill Court, Hortons Way,, Westerham, Kent, TN16 1BT')
ON CONFLICT (id) DO NOTHING;

INSERT INTO contractors (id, name, email, address) VALUES
('9ffdf1a8-80b2-4375-a4ce-3719171484c5', 'Capita', 'DPO@archinsurance.co.uk', 'f Arch Insurance (UK) Limited, Arch Insurance (UK) Limited, 5th Floor, 60 Great Tower Street, London EC3R 5AZ')
ON CONFLICT (id) DO NOTHING;


-- ===========================
-- BUILDING_CONTRACTORS
-- ===========================

INSERT INTO building_contractors (id, building_id, contractor_type)
VALUES ('adc2f40f-3675-4052-bf3b-04723828a62a', '6f70b361-8781-47bc-934b-06892458b603', 'service_provider')
ON CONFLICT (id) DO NOTHING;

INSERT INTO building_contractors (id, building_id, contractor_type)
VALUES ('cbdf9a9a-5bf9-4f7d-9096-6f11463d79fe', '6f70b361-8781-47bc-934b-06892458b603', 'service_provider')
ON CONFLICT (id) DO NOTHING;

INSERT INTO building_contractors (id, building_id, contractor_type)
VALUES ('25fab1f5-447d-4b05-a73e-a5119aef81fa', '6f70b361-8781-47bc-934b-06892458b603', 'service_provider')
ON CONFLICT (id) DO NOTHING;

INSERT INTO building_contractors (id, building_id, contractor_type)
VALUES ('fa6041ca-b292-4a76-b87c-3c9f6ed7b672', '6f70b361-8781-47bc-934b-06892458b603', 'service_provider')
ON CONFLICT (id) DO NOTHING;

INSERT INTO building_contractors (id, building_id, contractor_type)
VALUES ('eceae6df-74f4-482b-a8e5-80b796b40a7c', '6f70b361-8781-47bc-934b-06892458b603', 'service_provider')
ON CONFLICT (id) DO NOTHING;

INSERT INTO building_contractors (id, building_id, contractor_type)
VALUES ('3e15e601-1878-4d89-9313-c597069cf06b', '6f70b361-8781-47bc-934b-06892458b603', 'service_provider')
ON CONFLICT (id) DO NOTHING;

INSERT INTO building_contractors (id, building_id, contractor_type)
VALUES ('7c6371fa-3a39-406d-b050-840e30f7f920', '6f70b361-8781-47bc-934b-06892458b603', 'service_provider')
ON CONFLICT (id) DO NOTHING;

INSERT INTO building_contractors (id, building_id, contractor_type)
VALUES ('99209ee2-68c3-4770-b8d7-a76fe0edd1c0', '6f70b361-8781-47bc-934b-06892458b603', 'service_provider')
ON CONFLICT (id) DO NOTHING;

INSERT INTO building_contractors (id, building_id, contractor_type)
VALUES ('8a930e62-b5b8-4cf9-9c07-c05a2ec96bbe', '6f70b361-8781-47bc-934b-06892458b603', 'service_provider')
ON CONFLICT (id) DO NOTHING;

INSERT INTO building_contractors (id, building_id, contractor_type)
VALUES ('0c3c09fa-8b7f-4acd-806f-80375cab7ef1', '6f70b361-8781-47bc-934b-06892458b603', 'service_provider')
ON CONFLICT (id) DO NOTHING;

INSERT INTO building_contractors (id, building_id, contractor_type)
VALUES ('570d0177-9019-4876-9081-cfc4ebfeea46', '6f70b361-8781-47bc-934b-06892458b603', 'service_provider')
ON CONFLICT (id) DO NOTHING;

INSERT INTO building_contractors (id, building_id, contractor_type)
VALUES ('ab6de596-efd1-4bfd-86ea-043bb5afeaab', '6f70b361-8781-47bc-934b-06892458b603', 'service_provider')
ON CONFLICT (id) DO NOTHING;

INSERT INTO building_contractors (id, building_id, contractor_type)
VALUES ('92c943fb-b610-42b8-bf92-5574c5e0f07b', '6f70b361-8781-47bc-934b-06892458b603', 'service_provider')
ON CONFLICT (id) DO NOTHING;

INSERT INTO building_contractors (id, building_id, contractor_type)
VALUES ('09c9de95-391a-4d6b-9d05-2b0fe1948a5c', '6f70b361-8781-47bc-934b-06892458b603', 'service_provider')
ON CONFLICT (id) DO NOTHING;

INSERT INTO building_contractors (id, building_id, contractor_type)
VALUES ('fc856b49-ee24-4f71-aa59-d15dde70f55f', '6f70b361-8781-47bc-934b-06892458b603', 'service_provider')
ON CONFLICT (id) DO NOTHING;

INSERT INTO building_contractors (id, building_id, contractor_type)
VALUES ('d4203de9-aeb9-4d71-af15-1c5a122f06c6', '6f70b361-8781-47bc-934b-06892458b603', 'service_provider')
ON CONFLICT (id) DO NOTHING;

INSERT INTO building_contractors (id, building_id, contractor_type)
VALUES ('8a872ee7-49f4-4973-a577-fd00e7363924', '6f70b361-8781-47bc-934b-06892458b603', 'service_provider')
ON CONFLICT (id) DO NOTHING;

INSERT INTO building_contractors (id, building_id, contractor_type)
VALUES ('e7c7c10b-0a8f-4338-888d-839179c1ccb1', '6f70b361-8781-47bc-934b-06892458b603', 'service_provider')
ON CONFLICT (id) DO NOTHING;

INSERT INTO building_contractors (id, building_id, contractor_type)
VALUES ('394eabf3-9723-4b3b-b366-8fdd3b175c82', '6f70b361-8781-47bc-934b-06892458b603', 'service_provider')
ON CONFLICT (id) DO NOTHING;

INSERT INTO building_contractors (id, building_id, contractor_type)
VALUES ('037d49fa-5bb4-465f-8576-b42a23bf32eb', '6f70b361-8781-47bc-934b-06892458b603', 'service_provider')
ON CONFLICT (id) DO NOTHING;

INSERT INTO building_contractors (id, building_id, contractor_type)
VALUES ('0cc95f50-699e-4a68-83c1-68131b0ead74', '6f70b361-8781-47bc-934b-06892458b603', 'service_provider')
ON CONFLICT (id) DO NOTHING;


-- Insert 214 assets
INSERT INTO assets (id, building_id, asset_type, asset_name, location_description, compliance_category, linked_documents) VALUES ('916cbd12-b679-4ae6-aa97-08778f0eb990', '6f70b361-8781-47bc-934b-06892458b603', 'fire_alarm', 'Fire Alarm Works', 'Works-Following from latest leak', 'fire_safety', ARRAY['2024 Directors Meeting-Notes.docx']);
INSERT INTO assets (id, building_id, asset_type, asset_name, location_description, compliance_category, linked_documents) VALUES ('151af9b6-2be1-4131-a732-cf147d52a305', '6f70b361-8781-47bc-934b-06892458b603', 'lift', 'Lift Works', 'Works-Following from latest leak', 'lifts_safety', ARRAY['2024 Directors Meeting-Notes.docx']);
INSERT INTO assets (id, building_id, asset_type, asset_name, location_description, model_number, compliance_category, linked_documents) VALUES ('79f48ee4-22da-4a14-942c-16f2905672d0', '6f70b361-8781-47bc-934b-06892458b603', 'boiler', 'Boiler Room', 'Basement', 'Fire', 'gas_safety', ARRAY['Fire Door (Communal) Inspection (11m +) (7).pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('9a91c71b-c41d-435d-8741-1637c15ccca1', '6f70b361-8781-47bc-934b-06892458b603', 'fire_alarm', 'Fire Alarm A', 'fire_safety', ARRAY['EICR Cuanku 32-34 conaught square.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, location_description, compliance_category, linked_documents) VALUES ('fa908de3-7fd3-4594-a7f4-8889eacb4480', '6f70b361-8781-47bc-934b-06892458b603', 'lift', 'LIFT SHAFT', 'CONTROL CIRCUITS', 'lifts_safety', ARRAY['EICR Cuanku 32-34 conaught square.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, model_number, compliance_category, linked_documents) VALUES ('857e39a9-66fe-4e18-88d9-d8ab2743e3c9', '6f70b361-8781-47bc-934b-06892458b603', 'lightning_protection', 'To lightning protection', 'B', 'electrical_safety', ARRAY['EICR Cuanku 32-34 conaught square.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('a9ffd8c6-3a05-4b00-94e1-09c1b7d161d3', '6f70b361-8781-47bc-934b-06892458b603', 'generator', 'generators', 'electrical_safety', ARRAY['EICR Cuanku 32-34 conaught square.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, location_description, compliance_category, linked_documents) VALUES ('7187c731-40c0-4fb6-8089-c5cc8b5c4402', '6f70b361-8781-47bc-934b-06892458b603', 'boiler', 'Boiler room', 'terrace - lift', 'gas_safety', ARRAY['221037_Fra1-L-394697-071223 32-34 Connaught Square_2024-01-02_163759 (1).pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, location_description, condition_rating, compliance_category, linked_documents) VALUES ('f2e69c7c-b806-4a88-8dab-8de9fad06870', '6f70b361-8781-47bc-934b-06892458b603', 'fire_alarm', 'Fire Alarm', 'in appropriate X Breaches to compartmentation observed', 'good', 'fire_safety', ARRAY['221037_Fra1-L-394697-071223 32-34 Connaught Square_2024-01-02_163759 (1).pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, location_description, compliance_category, linked_documents) VALUES ('13894f7f-b2d8-474f-af0d-da08aba7cd67', '6f70b361-8781-47bc-934b-06892458b603', 'lift', 'lift
motor', 'terrace - lift', 'lifts_safety', ARRAY['221037_Fra1-L-394697-071223 32-34 Connaught Square_2024-01-02_163759 (1).pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, location_description, model_number, compliance_category, linked_documents) VALUES ('aa0f1720-6091-464c-b373-a1392abc2b27', '6f70b361-8781-47bc-934b-06892458b603', 'door_entry', 'Intercom door entry', 'to 3rd floor', '1', 'security', ARRAY['221037_Fra1-L-394697-071223 32-34 Connaught Square_2024-01-02_163759 (1).pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('9b75753e-fed6-4d3a-8220-f41f38318aa0', '6f70b361-8781-47bc-934b-06892458b603', 'emergency_lighting', 'emergency lighting present', 'fire_safety', ARRAY['221037_Fra1-L-394697-071223 32-34 Connaught Square_2024-01-02_163759 (1).pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('8215d8e5-51b7-4eaa-be25-603c8c23aa76', '6f70b361-8781-47bc-934b-06892458b603', 'fire_extinguisher', 'fire extinguishers', 'fire_safety', ARRAY['221037_Fra1-L-394697-071223 32-34 Connaught Square_2024-01-02_163759 (1).pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, condition_rating, compliance_category, linked_documents) VALUES ('409e391a-ea53-4142-87ed-4f894e441c42', '6f70b361-8781-47bc-934b-06892458b603', 'lightning_protection', 'Lightning protection available', 'good', 'electrical_safety', ARRAY['221037_Fra1-L-394697-071223 32-34 Connaught Square_2024-01-02_163759 (1).pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, location_description, model_number, condition_rating, compliance_category, linked_documents) VALUES ('1c1b27ea-951f-4a08-bcd7-76b4d9cd8b72', '6f70b361-8781-47bc-934b-06892458b603', 'boiler', 'Boiler Hanworthy', 'Condensing Boiler Hanworthy Purewell variheat m k2 110 21 Mbar 110 0', 'pressure', 'fair', 'gas_safety', ARRAY['001132-3234-Connaught-Square-London.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, location_description, compliance_category, linked_documents) VALUES ('9adba6d9-88d9-491a-94c2-4a1e3d2ebfae', '6f70b361-8781-47bc-934b-06892458b603', 'boiler', 'Boiler room', 'terrace - lift', 'gas_safety', ARRAY['221038_Hsra1-L-394697-071223 32-34 Connaught Square_2024-01-02_163759 (1).pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('35b82512-bfc6-4bc3-8f38-312dcfd6bf1e', '6f70b361-8781-47bc-934b-06892458b603', 'lift', 'LIFTS', 'lifts_safety', ARRAY['221038_Hsra1-L-394697-071223 32-34 Connaught Square_2024-01-02_163759 (1).pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('fd9ef867-7106-4cf5-912f-784bd7e89089', '6f70b361-8781-47bc-934b-06892458b603', 'cctv', 'CCTV equipment', 'security', ARRAY['221038_Hsra1-L-394697-071223 32-34 Connaught Square_2024-01-02_163759 (1).pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, location_description, compliance_category, linked_documents) VALUES ('41738587-d4b4-47b7-a6dd-626fe333e270', '6f70b361-8781-47bc-934b-06892458b603', 'door_entry', 'Intercom door entry', 'to 3rd floor', 'security', ARRAY['221038_Hsra1-L-394697-071223 32-34 Connaught Square_2024-01-02_163759 (1).pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('d160ca7d-293b-4c8a-bfdb-44ecc0652f94', '6f70b361-8781-47bc-934b-06892458b603', 'emergency_lighting', 'Emergency lighting provided', 'fire_safety', ARRAY['221038_Hsra1-L-394697-071223 32-34 Connaught Square_2024-01-02_163759 (1).pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('37c8693f-06f3-462c-b81b-82e23e990e4d', '6f70b361-8781-47bc-934b-06892458b603', 'water_tank', 'water storage tank', 'water_safety', ARRAY['221038_Hsra1-L-394697-071223 32-34 Connaught Square_2024-01-02_163759 (1).pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, location_description, compliance_category, linked_documents) VALUES ('561e3ee3-094f-4a75-80f5-5569badee294', '6f70b361-8781-47bc-934b-06892458b603', 'boiler', 'Boiler Room', 'exits', 'gas_safety', ARRAY['TETRA - Asbestos Re-Inspection Survey 14.06.22.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, location_description, compliance_category, linked_documents) VALUES ('c8818d03-b9f7-42d6-9378-6506b4efb1a4', '6f70b361-8781-47bc-934b-06892458b603', 'lift', 'Lift Motor', 'Description Assessment', 'lifts_safety', ARRAY['TETRA - Asbestos Re-Inspection Survey 14.06.22.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, location_description, compliance_category, linked_documents) VALUES ('52ef69bb-9184-4198-b041-169a1ac66446', '6f70b361-8781-47bc-934b-06892458b603', 'pump', 'pumps', 'exits', 'water_safety', ARRAY['TETRA - Asbestos Re-Inspection Survey 14.06.22.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, model_number, compliance_category, linked_documents) VALUES ('914c5e90-5e07-485b-a4a2-09d7c1720ffd', '6f70b361-8781-47bc-934b-06892458b603', 'boiler', 'Boilers', 'Total', 'gas_safety', ARRAY['WHM Legionella Risk Assessment 07.06.22.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('4a214a53-d3f0-49ff-8cfb-d48dc38ba055', '6f70b361-8781-47bc-934b-06892458b603', 'sprinkler', 'Sprinklers', 'fire_safety', ARRAY['WHM Legionella Risk Assessment 07.06.22.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('405e6c38-5267-40a6-b66d-c98315135eee', '6f70b361-8781-47bc-934b-06892458b603', 'pump', 'pump is', 'water_safety', ARRAY['WHM Legionella Risk Assessment 07.06.22.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, service_frequency, compliance_category, linked_documents) VALUES ('2dec7968-1834-4164-aa88-42a32fdd6716', '6f70b361-8781-47bc-934b-06892458b603', 'water_tank', 'water tanks', 'annually', 'water_safety', ARRAY['WHM Legionella Risk Assessment 07.06.22.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('9b43951b-21be-44f1-90c4-fb4b03d4f422', '6f70b361-8781-47bc-934b-06892458b603', 'fire_alarm', 'Fire Alarm A', 'fire_safety', ARRAY['EICR Report Cunaku SATISFACTORY 2023 .pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, location_description, compliance_category, linked_documents) VALUES ('805eabae-b617-4b0c-9779-704ad50127c6', '6f70b361-8781-47bc-934b-06892458b603', 'lift', 'LIFT SHAFT', 'CONTROL CIRCUITS', 'lifts_safety', ARRAY['EICR Report Cunaku SATISFACTORY 2023 .pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, model_number, compliance_category, linked_documents) VALUES ('bab8a047-1cde-47cf-b564-4c647df1046a', '6f70b361-8781-47bc-934b-06892458b603', 'lightning_protection', 'To lightning protection', 'B', 'electrical_safety', ARRAY['EICR Report Cunaku SATISFACTORY 2023 .pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('4bfbbb80-2a34-4d40-9cdf-c642cecf2c1f', '6f70b361-8781-47bc-934b-06892458b603', 'generator', 'generators', 'electrical_safety', ARRAY['EICR Report Cunaku SATISFACTORY 2023 .pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, location_description, compliance_category, linked_documents) VALUES ('55e6083d-e818-4ff1-be12-42d040d4c196', '6f70b361-8781-47bc-934b-06892458b603', 'fire_alarm', 'Fire Alarm Works', 'Works-Following from latest leak', 'fire_safety', ARRAY['2024 Directors Meeting-Notes.docx']);
INSERT INTO assets (id, building_id, asset_type, asset_name, location_description, compliance_category, linked_documents) VALUES ('2847bbe5-b018-4ca1-814e-dc30a6aa5ef5', '6f70b361-8781-47bc-934b-06892458b603', 'lift', 'Lift Works', 'Works-Following from latest leak', 'lifts_safety', ARRAY['2024 Directors Meeting-Notes.docx']);
INSERT INTO assets (id, building_id, asset_type, asset_name, location_description, model_number, condition_rating, compliance_category, linked_documents) VALUES ('1e001da6-540d-44ad-9628-c9f866852279', '6f70b361-8781-47bc-934b-06892458b603', 'boiler', 'Boiler Hanworthy', 'Condensing Boiler Hanworthy Wessex modumaxO mFk2 110c 20 Mbar 1', 'pressure', 'fair', 'gas_safety', ARRAY['001457-3234-Connaught-Square-London Certificate.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, location_description, manufacturer, compliance_category, linked_documents) VALUES ('690aa00f-765a-4723-af45-2d2e2e758c1e', '6f70b361-8781-47bc-934b-06892458b603', 'lift', 'lift to', 'of Commission is', 'Crown to the Customer', 'lifts_safety', ARRAY['TC0001V31 General Terms and Conditions.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, model_number, compliance_category, linked_documents) VALUES ('7d14bcb4-a199-4e61-8e3b-e333805162e4', '6f70b361-8781-47bc-934b-06892458b603', 'boiler', 'Boilers', 'Total', 'gas_safety', ARRAY['Connaught Square (32-34) - 09.12.24 LRA.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('d0b9f753-8f9c-4c07-8d7f-21ab18ad75f0', '6f70b361-8781-47bc-934b-06892458b603', 'sprinkler', 'Sprinklers', 'fire_safety', ARRAY['Connaught Square (32-34) - 09.12.24 LRA.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('4cad6bc7-2d35-498a-8f1e-a91332b8b51c', '6f70b361-8781-47bc-934b-06892458b603', 'pump', 'pump is', 'water_safety', ARRAY['Connaught Square (32-34) - 09.12.24 LRA.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, service_frequency, compliance_category, linked_documents) VALUES ('38a5457d-0e30-40ec-99be-f395fd19f5d1', '6f70b361-8781-47bc-934b-06892458b603', 'water_tank', 'water tanks', 'annually', 'water_safety', ARRAY['Connaught Square (32-34) - 09.12.24 LRA.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, location_description, model_number, compliance_category, linked_documents) VALUES ('0d91a6c0-58ed-417d-b08a-3acc4482345b', '6f70b361-8781-47bc-934b-06892458b603', 'boiler', 'Boiler Room', 'Basement', 'Fire', 'gas_safety', ARRAY['Fire Door (Communal) Inspection (11m +) (7).pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, location_description, compliance_category, linked_documents) VALUES ('fe21402d-482a-4f76-955e-0f0147eac170', '6f70b361-8781-47bc-934b-06892458b603', 'boiler', 'Boiler room', 'terrace - lift', 'gas_safety', ARRAY['221037_Fra1-L-394697-071223 32-34 Connaught Square_2024-01-02_163759.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, location_description, condition_rating, compliance_category, linked_documents) VALUES ('81437383-3cbd-4a73-9fc9-2b5c93468e2f', '6f70b361-8781-47bc-934b-06892458b603', 'fire_alarm', 'Fire Alarm', 'in appropriate X Breaches to compartmentation observed', 'good', 'fire_safety', ARRAY['221037_Fra1-L-394697-071223 32-34 Connaught Square_2024-01-02_163759.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, location_description, compliance_category, linked_documents) VALUES ('fca698a7-6f80-47a4-9cad-087b0ca7ce7c', '6f70b361-8781-47bc-934b-06892458b603', 'lift', 'lift
motor', 'terrace - lift', 'lifts_safety', ARRAY['221037_Fra1-L-394697-071223 32-34 Connaught Square_2024-01-02_163759.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, location_description, model_number, compliance_category, linked_documents) VALUES ('7248bb7a-7d16-460b-8260-092407d63568', '6f70b361-8781-47bc-934b-06892458b603', 'door_entry', 'Intercom door entry', 'to 3rd floor', '1', 'security', ARRAY['221037_Fra1-L-394697-071223 32-34 Connaught Square_2024-01-02_163759.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('4bea2f19-3eea-4cef-80a0-c832a8bfba97', '6f70b361-8781-47bc-934b-06892458b603', 'emergency_lighting', 'emergency lighting present', 'fire_safety', ARRAY['221037_Fra1-L-394697-071223 32-34 Connaught Square_2024-01-02_163759.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('48ac8b5d-9fb9-43a6-bca8-9f0c5519f0b0', '6f70b361-8781-47bc-934b-06892458b603', 'fire_extinguisher', 'fire extinguishers', 'fire_safety', ARRAY['221037_Fra1-L-394697-071223 32-34 Connaught Square_2024-01-02_163759.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, condition_rating, compliance_category, linked_documents) VALUES ('17ff80a3-4d6f-4883-ad89-c4c7ab080f4c', '6f70b361-8781-47bc-934b-06892458b603', 'lightning_protection', 'Lightning protection available', 'good', 'electrical_safety', ARRAY['221037_Fra1-L-394697-071223 32-34 Connaught Square_2024-01-02_163759.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, location_description, model_number, compliance_category, linked_documents) VALUES ('aa91add5-06bc-49b0-bb4f-22325fb2953d', '6f70b361-8781-47bc-934b-06892458b603', 'boiler', 'Boiler Room', 'Basement', 'Fire', 'gas_safety', ARRAY['Fire Door (Communal) Inspection (11m +) - 2024-01-24T120743.986.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, location_description, compliance_category, linked_documents) VALUES ('cf0d2e8d-e9d3-4630-b860-2e2434429f16', '6f70b361-8781-47bc-934b-06892458b603', 'boiler', 'Boiler room', 'terrace - lift', 'gas_safety', ARRAY['221038_Hsra1-L-394697-071223 32-34 Connaught Square_2024-01-02_163759.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('5fe17dc1-8e10-4ce0-910c-7e00f3d74c65', '6f70b361-8781-47bc-934b-06892458b603', 'lift', 'LIFTS', 'lifts_safety', ARRAY['221038_Hsra1-L-394697-071223 32-34 Connaught Square_2024-01-02_163759.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('1e691c5b-9ad4-4a3d-80d5-8b523a3e150d', '6f70b361-8781-47bc-934b-06892458b603', 'cctv', 'CCTV equipment', 'security', ARRAY['221038_Hsra1-L-394697-071223 32-34 Connaught Square_2024-01-02_163759.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, location_description, compliance_category, linked_documents) VALUES ('d6ca5f37-b85e-4687-b1a1-4a37c9046644', '6f70b361-8781-47bc-934b-06892458b603', 'door_entry', 'Intercom door entry', 'to 3rd floor', 'security', ARRAY['221038_Hsra1-L-394697-071223 32-34 Connaught Square_2024-01-02_163759.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('b13966dc-cbdb-4e95-8bfb-9816ce490567', '6f70b361-8781-47bc-934b-06892458b603', 'emergency_lighting', 'Emergency lighting provided', 'fire_safety', ARRAY['221038_Hsra1-L-394697-071223 32-34 Connaught Square_2024-01-02_163759.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('21d175b2-bdd8-40c1-b260-46a2d37574e4', '6f70b361-8781-47bc-934b-06892458b603', 'water_tank', 'water storage tank', 'water_safety', ARRAY['221038_Hsra1-L-394697-071223 32-34 Connaught Square_2024-01-02_163759.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, location_description, compliance_category, linked_documents) VALUES ('33183550-1ca9-4c1b-ad1d-a612f8e62995', '6f70b361-8781-47bc-934b-06892458b603', 'boiler', 'Boiler room', 'terrace - lift', 'gas_safety', ARRAY['Hsfra1-L-422971-210225 32-34 Connaught Square.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, location_description, condition_rating, compliance_category, linked_documents) VALUES ('61880378-323e-41c0-9a31-ac8eccfa89bd', '6f70b361-8781-47bc-934b-06892458b603', 'fire_alarm', 'Fire Alarm', 'in appropriate X Breaches to compartmentation observed', 'good', 'fire_safety', ARRAY['Hsfra1-L-422971-210225 32-34 Connaught Square.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('341c78cd-8dfa-494b-be49-11872ccc201c', '6f70b361-8781-47bc-934b-06892458b603', 'lift', 'LIFTS', 'lifts_safety', ARRAY['Hsfra1-L-422971-210225 32-34 Connaught Square.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('fdda802e-7304-4b2e-baaa-e8dd59eea4df', '6f70b361-8781-47bc-934b-06892458b603', 'cctv', 'CCTV equipment', 'security', ARRAY['Hsfra1-L-422971-210225 32-34 Connaught Square.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, location_description, compliance_category, linked_documents) VALUES ('cc65ead7-c1ae-44de-8ffa-74f76070fff2', '6f70b361-8781-47bc-934b-06892458b603', 'door_entry', 'Intercom door entry', 'to 3rd floor', 'security', ARRAY['Hsfra1-L-422971-210225 32-34 Connaught Square.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('67e38ad5-8b64-4c25-aaec-5079657134c8', '6f70b361-8781-47bc-934b-06892458b603', 'emergency_lighting', 'Emergency lighting provided', 'fire_safety', ARRAY['Hsfra1-L-422971-210225 32-34 Connaught Square.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('e039d146-7286-469f-98b5-ad187a883178', '6f70b361-8781-47bc-934b-06892458b603', 'fire_extinguisher', 'fire extinguishers', 'fire_safety', ARRAY['Hsfra1-L-422971-210225 32-34 Connaught Square.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, condition_rating, compliance_category, linked_documents) VALUES ('ac119de1-b7ef-48d8-b56a-23964718f2e7', '6f70b361-8781-47bc-934b-06892458b603', 'lightning_protection', 'Lightning protection available', 'good', 'electrical_safety', ARRAY['Hsfra1-L-422971-210225 32-34 Connaught Square.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('f8b6960a-4746-4fb6-a531-45d810038651', '6f70b361-8781-47bc-934b-06892458b603', 'water_tank', 'water storage tank', 'water_safety', ARRAY['Hsfra1-L-422971-210225 32-34 Connaught Square.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('78fd61c9-706c-4e60-9103-349a8e153cdd', '6f70b361-8781-47bc-934b-06892458b603', 'fire_alarm', 'ESCAPE

FIRE DETECTION', 'fire_safety', ARRAY['Hsfra1-L-422971-210225 32-34 Connaught Square.docx']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('b20405a0-dde7-4cd1-bad9-9fc510feda80', '6f70b361-8781-47bc-934b-06892458b603', 'lift', 'LIFTS', 'lifts_safety', ARRAY['Hsfra1-L-422971-210225 32-34 Connaught Square.docx']);
INSERT INTO assets (id, building_id, asset_type, asset_name, location_description, compliance_category, linked_documents) VALUES ('8828d46d-cc00-4396-8bc3-2a8478fc8677', '6f70b361-8781-47bc-934b-06892458b603', 'boiler', 'Boiler room', 'terrace - lift', 'gas_safety', ARRAY['221037_Fra1-L-394697-071223 32-34 Connaught Square_2024-01-02_163759 (1).pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, location_description, condition_rating, compliance_category, linked_documents) VALUES ('45b0aa28-00a0-4d40-86c2-50a81e18c654', '6f70b361-8781-47bc-934b-06892458b603', 'fire_alarm', 'Fire Alarm', 'in appropriate X Breaches to compartmentation observed', 'good', 'fire_safety', ARRAY['221037_Fra1-L-394697-071223 32-34 Connaught Square_2024-01-02_163759 (1).pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, location_description, compliance_category, linked_documents) VALUES ('6422808a-0015-4f08-928e-760cb48d9ff3', '6f70b361-8781-47bc-934b-06892458b603', 'lift', 'lift
motor', 'terrace - lift', 'lifts_safety', ARRAY['221037_Fra1-L-394697-071223 32-34 Connaught Square_2024-01-02_163759 (1).pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, location_description, model_number, compliance_category, linked_documents) VALUES ('4dd837df-532f-4a39-818b-7d1d99da0445', '6f70b361-8781-47bc-934b-06892458b603', 'door_entry', 'Intercom door entry', 'to 3rd floor', '1', 'security', ARRAY['221037_Fra1-L-394697-071223 32-34 Connaught Square_2024-01-02_163759 (1).pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('6650d3a8-0be7-4d34-a558-a2f52838459f', '6f70b361-8781-47bc-934b-06892458b603', 'emergency_lighting', 'emergency lighting present', 'fire_safety', ARRAY['221037_Fra1-L-394697-071223 32-34 Connaught Square_2024-01-02_163759 (1).pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('fed4c7b6-d842-492d-be8e-8101a1593647', '6f70b361-8781-47bc-934b-06892458b603', 'fire_extinguisher', 'fire extinguishers', 'fire_safety', ARRAY['221037_Fra1-L-394697-071223 32-34 Connaught Square_2024-01-02_163759 (1).pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, condition_rating, compliance_category, linked_documents) VALUES ('f15e4666-ae60-4e21-ab37-e05dbf3c0760', '6f70b361-8781-47bc-934b-06892458b603', 'lightning_protection', 'Lightning protection available', 'good', 'electrical_safety', ARRAY['221037_Fra1-L-394697-071223 32-34 Connaught Square_2024-01-02_163759 (1).pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, location_description, compliance_category, linked_documents) VALUES ('132b589a-accf-4c8e-9d4e-0dd201244733', '6f70b361-8781-47bc-934b-06892458b603', 'boiler', 'Boiler room', 'terrace - lift', 'gas_safety', ARRAY['221038_Hsra1-L-394697-071223 32-34 Connaught Square_2024-01-02_163759 (1).pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('0bc626b0-a66e-434f-b82c-2bb6dde7100f', '6f70b361-8781-47bc-934b-06892458b603', 'lift', 'LIFTS', 'lifts_safety', ARRAY['221038_Hsra1-L-394697-071223 32-34 Connaught Square_2024-01-02_163759 (1).pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('7a1f8460-6635-4732-9a9f-2fd5d95fe31e', '6f70b361-8781-47bc-934b-06892458b603', 'cctv', 'CCTV equipment', 'security', ARRAY['221038_Hsra1-L-394697-071223 32-34 Connaught Square_2024-01-02_163759 (1).pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, location_description, compliance_category, linked_documents) VALUES ('b1a29707-f74d-41f2-a167-7c99b1806ff8', '6f70b361-8781-47bc-934b-06892458b603', 'door_entry', 'Intercom door entry', 'to 3rd floor', 'security', ARRAY['221038_Hsra1-L-394697-071223 32-34 Connaught Square_2024-01-02_163759 (1).pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('f31b4642-6d46-4efb-ab15-0b29c67230f0', '6f70b361-8781-47bc-934b-06892458b603', 'emergency_lighting', 'Emergency lighting provided', 'fire_safety', ARRAY['221038_Hsra1-L-394697-071223 32-34 Connaught Square_2024-01-02_163759 (1).pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('1bd1d949-e332-4aaa-852b-32a3ad5953bc', '6f70b361-8781-47bc-934b-06892458b603', 'water_tank', 'water storage tank', 'water_safety', ARRAY['221038_Hsra1-L-394697-071223 32-34 Connaught Square_2024-01-02_163759 (1).pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, location_description, model_number, condition_rating, compliance_category, linked_documents) VALUES ('9bc81492-d2ed-42ad-b519-d55b09874974', '6f70b361-8781-47bc-934b-06892458b603', 'boiler', 'Boiler Hamworthy', 'Plant Room Condensing', 'pressure', 'fair', 'gas_safety', ARRAY['001534-3234-Connaught-Square-London.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, location_description, compliance_category, linked_documents) VALUES ('44086c76-cfab-48ab-9fd3-4279243bc93e', '6f70b361-8781-47bc-934b-06892458b603', 'boiler', 'boiler number', 'new gas valve', 'gas_safety', ARRAY['C1047 - Job card.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, model_number, compliance_category, linked_documents) VALUES ('ac3a094b-0840-4676-b864-5037349e7f1b', '6f70b361-8781-47bc-934b-06892458b603', 'boiler', 'Boilers', 'Total', 'gas_safety', ARRAY['WHM Legionella Risk Assessment 09.12.25.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('62885753-1f00-4d73-ad9a-27cd529ee38b', '6f70b361-8781-47bc-934b-06892458b603', 'sprinkler', 'Sprinklers', 'fire_safety', ARRAY['WHM Legionella Risk Assessment 09.12.25.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('cecfdaeb-d7bb-412b-a5e5-c665707e3f5c', '6f70b361-8781-47bc-934b-06892458b603', 'pump', 'pump is', 'water_safety', ARRAY['WHM Legionella Risk Assessment 09.12.25.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, service_frequency, compliance_category, linked_documents) VALUES ('732a2321-6a20-48c3-b8f2-b46ceea8cdd5', '6f70b361-8781-47bc-934b-06892458b603', 'water_tank', 'water tanks', 'annually', 'water_safety', ARRAY['WHM Legionella Risk Assessment 09.12.25.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, model_number, compliance_category, linked_documents) VALUES ('96cbb229-b8f0-4c8b-8605-56b3b96b6875', '6f70b361-8781-47bc-934b-06892458b603', 'boiler', 'Boilers', 'Total', 'gas_safety', ARRAY['WHM Legionella Risk Assessment 07.06.22.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('7ef4785f-7e74-40cb-bcde-ca35e5687c3d', '6f70b361-8781-47bc-934b-06892458b603', 'sprinkler', 'Sprinklers', 'fire_safety', ARRAY['WHM Legionella Risk Assessment 07.06.22.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('215ae067-da22-4894-a46d-1fa031a7760d', '6f70b361-8781-47bc-934b-06892458b603', 'pump', 'pump is', 'water_safety', ARRAY['WHM Legionella Risk Assessment 07.06.22.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, service_frequency, compliance_category, linked_documents) VALUES ('a38edbe7-1822-433b-897b-c08846e7569d', '6f70b361-8781-47bc-934b-06892458b603', 'water_tank', 'water tanks', 'annually', 'water_safety', ARRAY['WHM Legionella Risk Assessment 07.06.22.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('68d4cafa-0f39-43b6-a9b8-fe5e6efd0465', '6f70b361-8781-47bc-934b-06892458b603', 'fire_alarm', 'Fire Alarm A', 'fire_safety', ARRAY['EICR Cuanku 32-34 conaught square.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, location_description, compliance_category, linked_documents) VALUES ('24449994-ea6b-4327-8fcd-b826e9126e02', '6f70b361-8781-47bc-934b-06892458b603', 'lift', 'LIFT SHAFT', 'CONTROL CIRCUITS', 'lifts_safety', ARRAY['EICR Cuanku 32-34 conaught square.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, model_number, compliance_category, linked_documents) VALUES ('57f48ee6-0dfd-4d9d-ac7d-fe3bb69747ba', '6f70b361-8781-47bc-934b-06892458b603', 'lightning_protection', 'To lightning protection', 'B', 'electrical_safety', ARRAY['EICR Cuanku 32-34 conaught square.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('d5c68c44-b4f3-40fd-acd4-4062617bd27a', '6f70b361-8781-47bc-934b-06892458b603', 'generator', 'generators', 'electrical_safety', ARRAY['EICR Cuanku 32-34 conaught square.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('02a8f066-bd68-4cd1-9786-d99ee76c7870', '6f70b361-8781-47bc-934b-06892458b603', 'fire_alarm', 'Fire Alarm A', 'fire_safety', ARRAY['EICR Report Cunaku SATISFACTORY 2023 .pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, location_description, compliance_category, linked_documents) VALUES ('7e8c4c4d-be34-4c86-84fc-4f77f23f3242', '6f70b361-8781-47bc-934b-06892458b603', 'lift', 'LIFT SHAFT', 'CONTROL CIRCUITS', 'lifts_safety', ARRAY['EICR Report Cunaku SATISFACTORY 2023 .pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, model_number, compliance_category, linked_documents) VALUES ('10038842-1354-40d6-a999-a1e48d476fa4', '6f70b361-8781-47bc-934b-06892458b603', 'lightning_protection', 'To lightning protection', 'B', 'electrical_safety', ARRAY['EICR Report Cunaku SATISFACTORY 2023 .pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('acd4f80b-0298-4a8b-9cb2-19b9e9d856e6', '6f70b361-8781-47bc-934b-06892458b603', 'generator', 'generators', 'electrical_safety', ARRAY['EICR Report Cunaku SATISFACTORY 2023 .pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, location_description, model_number, condition_rating, compliance_category, linked_documents) VALUES ('e81c97c6-afce-428c-bffa-9fbc8b7f8fa8', '6f70b361-8781-47bc-934b-06892458b603', 'boiler', 'Boiler Hanworthy', 'Condensing Boiler Hanworthy Purewell variheat m k2 110 21 Mbar 110 0', 'pressure', 'fair', 'gas_safety', ARRAY['001132-3234-Connaught-Square-London.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, location_description, model_number, condition_rating, compliance_category, linked_documents) VALUES ('3507e08b-6489-4f6e-afa7-3975fa3e2f17', '6f70b361-8781-47bc-934b-06892458b603', 'boiler', 'Boiler Hamworthy', 'Plant Room Condensing', 'pressure', 'fair', 'gas_safety', ARRAY['001534-3234-Connaught-Square-London.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, location_description, compliance_category, linked_documents) VALUES ('5898522a-594a-459f-8a27-7f3ebf4d9c95', '6f70b361-8781-47bc-934b-06892458b603', 'boiler', 'Boiler Room', 'pipework', 'gas_safety', ARRAY['FINAL L-432900 32-34 Connaught Square Management Survey Report Issue 1.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, location_description, compliance_category, linked_documents) VALUES ('ac545c92-7d3d-468a-8a52-ac80c23acb6e', '6f70b361-8781-47bc-934b-06892458b603', 'lift', 'Lift Motor', 'Room brake shoe to lift motor', 'lifts_safety', ARRAY['FINAL L-432900 32-34 Connaught Square Management Survey Report Issue 1.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, location_description, compliance_category, linked_documents) VALUES ('61f29dab-db81-4b66-bd77-b62510da4cf2', '6f70b361-8781-47bc-934b-06892458b603', 'boiler', 'Boiler Room', 'exits', 'gas_safety', ARRAY['TETRA - Asbestos Re-Inspection Survey 14.06.22.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, location_description, compliance_category, linked_documents) VALUES ('40ebeab3-1dba-40b1-8574-59c2923a0485', '6f70b361-8781-47bc-934b-06892458b603', 'lift', 'Lift Motor', 'Description Assessment', 'lifts_safety', ARRAY['TETRA - Asbestos Re-Inspection Survey 14.06.22.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, location_description, compliance_category, linked_documents) VALUES ('99ba2b02-5f65-4e30-adc5-99592ab7bde6', '6f70b361-8781-47bc-934b-06892458b603', 'pump', 'pumps', 'exits', 'water_safety', ARRAY['TETRA - Asbestos Re-Inspection Survey 14.06.22.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, service_frequency, compliance_category, linked_documents) VALUES ('346bd5da-ac86-428a-99a5-8ace4e13a8f3', '6f70b361-8781-47bc-934b-06892458b603', 'lift', 'lifts', 'monthly', 'lifts_safety', ARRAY['Signed 2025 Connaught Square Management Agreement.docx.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, service_frequency, compliance_category, linked_documents) VALUES ('20b59604-772d-4c3b-86a4-581300a0e1fe', '6f70b361-8781-47bc-934b-06892458b603', 'lift', 'lifts', 'monthly', 'lifts_safety', ARRAY['Signed Connaught Square Management Agreement.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, model_number, compliance_category, linked_documents) VALUES ('28fd89fd-e9d2-41cf-b4c8-4bcd2bd53ba6', '6f70b361-8781-47bc-934b-06892458b603', 'boiler', 'BOILER SERVICE', 'OF', 'gas_safety', ARRAY['CM434.PRO 2024-2025.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, model_number, compliance_category, linked_documents) VALUES ('234f64f5-9cce-4f1f-8b95-969267571a26', '6f70b361-8781-47bc-934b-06892458b603', 'boiler', 'BOILER SERVICE', 'OF', 'gas_safety', ARRAY['CM434.PRO.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('1e53b50f-6d1b-4590-ba69-df18b904e469', '6f70b361-8781-47bc-934b-06892458b603', 'lift', 'lift in', 'lifts_safety', ARRAY['Gas Contract 24-5.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('45d9607f-3ea7-4337-a75c-17074479a6a2', '6f70b361-8781-47bc-934b-06892458b603', 'lift', 'LIFT INCORPORATED', 'lifts_safety', ARRAY['Contract_10-03-2025.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('991d8288-568a-44f2-b139-43ed440141ce', '6f70b361-8781-47bc-934b-06892458b603', 'lift', 'LIFT INCORPORATED', 'lifts_safety', ARRAY['Gas Contract 25-26.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('472e7d14-db5a-41d8-919c-86f699e3c69a', '6f70b361-8781-47bc-934b-06892458b603', 'lift', 'lift to', 'lifts_safety', ARRAY['Welcome Letter - CG1885574.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, location_description, service_frequency, compliance_category, linked_documents) VALUES ('019f8b1f-c3c6-4cd3-98da-affb37b4e555', '6f70b361-8781-47bc-934b-06892458b603', 'lift', 'lift accessible', 'To clean out silt from the outlet and bagged it up', 'monthly', 'lifts_safety', ARRAY['Job 67141.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, model_number, compliance_category, linked_documents) VALUES ('5197555a-67de-45cf-b1dc-7f3ec198a838', '6f70b361-8781-47bc-934b-06892458b603', 'lift', 'Lift Ref', 'BRONZE', 'lifts_safety', ARRAY['JLGCalloutVisit-5455045-12-07-2024.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, model_number, compliance_category, linked_documents) VALUES ('37f5cb13-e69f-4175-b1ff-0d1564d1dadf', '6f70b361-8781-47bc-934b-06892458b603', 'lift', 'Lift Ref', 'BRONZE', 'lifts_safety', ARRAY['JLGCalloutVisit-5483206-26-10-2024.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, model_number, compliance_category, linked_documents) VALUES ('4e06a220-6e0b-4074-9798-0e1e0667c891', '6f70b361-8781-47bc-934b-06892458b603', 'lift', 'Lift Ref', 'BRONZE', 'lifts_safety', ARRAY['JLGCalloutVisit-5498439-16-12-2024.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, location_description, compliance_category, linked_documents) VALUES ('9d8e6de8-f7a2-4521-9cb2-96883d6f5497', '6f70b361-8781-47bc-934b-06892458b603', 'emergency_lighting', 'emergency lighting
The', 'The fault status has been classified as Faulty', 'fire_safety', ARRAY['JLGCalloutVisit-5498439-16-12-2024.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, model_number, compliance_category, linked_documents) VALUES ('9c15d5ab-970d-47fe-af91-77d8b3c4ba3f', '6f70b361-8781-47bc-934b-06892458b603', 'lift', 'Lift Ref', 'BRONZE', 'lifts_safety', ARRAY['JLGCalloutVisit-5455462-16-07-2024.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, model_number, compliance_category, linked_documents) VALUES ('7d543de9-0a66-4725-b61c-2c865ac50ac0', '6f70b361-8781-47bc-934b-06892458b603', 'lift', 'Lift Ref', 'BRONZE', 'lifts_safety', ARRAY['JLGCalloutVisit-5497480-13-12-2024.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, model_number, compliance_category, linked_documents) VALUES ('af95f6f7-27d5-4295-b285-7736f29660c6', '6f70b361-8781-47bc-934b-06892458b603', 'fire_alarm', 'Fire Alarm', 'SMALL', 'fire_safety', ARRAY['Engineering Report - 32-34 CONNAUGHT SQUARE.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, model_number, compliance_category, linked_documents) VALUES ('532f2219-9699-4478-b693-e34aca800bba', '6f70b361-8781-47bc-934b-06892458b603', 'emergency_lighting', 'Emergency Lights - FA7817', 'SMALL', 'fire_safety', ARRAY['Engineering Report - 32-34 CONNAUGHT SQUARE.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, location_description, compliance_category, linked_documents) VALUES ('6e875bc6-1f3f-4727-9e9c-586f34fcc597', '6f70b361-8781-47bc-934b-06892458b603', 'boiler', 'a boiler', 'but this sha', 'gas_safety', ARRAY['StG_Policy Wording_32-34 Connaught Square W2 2HL.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('f931dd8c-1a5c-4196-845c-7507ab8bebfc', '6f70b361-8781-47bc-934b-06892458b603', 'fire_alarm', 'fire alarm
The', 'fire_safety', ARRAY['StG_Policy Wording_32-34 Connaught Square W2 2HL.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('c44f26f4-3c6b-4f52-ae46-c06b61749465', '6f70b361-8781-47bc-934b-06892458b603', 'sprinkler', 'sprinkler leakage', 'fire_safety', ARRAY['StG_Policy Wording_32-34 Connaught Square W2 2HL.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('8a4fa92a-037d-47c3-a838-d428462e6e14', '6f70b361-8781-47bc-934b-06892458b603', 'lift', 'lift in', 'lifts_safety', ARRAY['StG_Policy Wording_32-34 Connaught Square W2 2HL.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('92d2adba-1406-4de9-8ffe-334a9539ef41', '6f70b361-8781-47bc-934b-06892458b603', 'pump', 'pumping', 'water_safety', ARRAY['StG_Policy Wording_32-34 Connaught Square W2 2HL.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, location_description, compliance_category, linked_documents) VALUES ('ab60bad1-04fa-4bf3-b207-51e089102c86', '6f70b361-8781-47bc-934b-06892458b603', 'cctv', 'cameras', 'on or', 'security', ARRAY['StG_Policy Wording_32-34 Connaught Square W2 2HL.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('85a1ad0b-8466-4311-813a-107e0bbd0745', '6f70b361-8781-47bc-934b-06892458b603', 'water_tank', 'water tanks', 'water_safety', ARRAY['StG_Policy Wording_32-34 Connaught Square W2 2HL.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('3c4eb81b-ed9a-49a5-9009-f73f2f739954', '6f70b361-8781-47bc-934b-06892458b603', 'fire_extinguisher', 'fire extinguishers', 'fire_safety', ARRAY['Q51691 - 32-34 Connaught Square Contract.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, model_number, compliance_category, linked_documents) VALUES ('c25bd103-c837-4f7d-a39c-d05f6e792d24', '6f70b361-8781-47bc-934b-06892458b603', 'fire_alarm', 'Fire Alarm', 'SMALL', 'fire_safety', ARRAY['Engineering Report - 32-34 CONNAUGHT SQUARE.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, model_number, compliance_category, linked_documents) VALUES ('7307850e-d7a2-4b1e-8266-9f4cfe23b57d', '6f70b361-8781-47bc-934b-06892458b603', 'emergency_lighting', 'Emergency Lights - FA7817', 'SMALL', 'fire_safety', ARRAY['Engineering Report - 32-34 CONNAUGHT SQUARE.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, location_description, model_number, compliance_category, linked_documents) VALUES ('99fbcce9-a862-46d5-86b8-32e0069c2718', '6f70b361-8781-47bc-934b-06892458b603', 'fire_alarm', 'uk
FIRE ALARM', 'LONDON', 'LIGHTS', 'fire_safety', ARRAY['Fire Alarm+Emergency Lighting Contract Connaught Square.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, service_frequency, compliance_category, linked_documents) VALUES ('d74d1088-b375-4e30-b929-9f8497340ee4', '6f70b361-8781-47bc-934b-06892458b603', 'emergency_lighting', 'EMERGENCY LIGHTS
MT8825', 'monthly', 'fire_safety', ARRAY['Fire Alarm+Emergency Lighting Contract Connaught Square.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, service_frequency, compliance_category, linked_documents) VALUES ('d32212f4-d570-4562-b846-e6d2ceb12ba3', '6f70b361-8781-47bc-934b-06892458b603', 'fire_alarm', 'FIRE ALARM BELL', 'monthly', 'fire_safety', ARRAY['BT3205 03072025.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, model_number, service_frequency, compliance_category, linked_documents) VALUES ('11c17dde-af78-4fe8-9a01-55b568c70ae1', '6f70b361-8781-47bc-934b-06892458b603', 'fire_alarm', 'fire alarm service', 'MAINTENANCE', 'monthly', 'fire_safety', ARRAY['FA7817 SERVICE 08042025.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, model_number, service_frequency, compliance_category, linked_documents) VALUES ('e0130193-2cd3-4aee-b847-732e5c90cd6d', '6f70b361-8781-47bc-934b-06892458b603', 'emergency_lighting', 'Emergency Lights - FA7817', 'MAINTENANCE', 'monthly', 'fire_safety', ARRAY['FA7817 SERVICE 08042025.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, model_number, compliance_category, linked_documents) VALUES ('059fe374-eacd-4f3a-acd8-83140bea1888', '6f70b361-8781-47bc-934b-06892458b603', 'fire_alarm', 'Fire Alarm', 'SMALL', 'fire_safety', ARRAY['Engineer Report - 32-34 Connaught Square Flat 5.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, model_number, compliance_category, linked_documents) VALUES ('055a68d5-ebcd-4898-92b6-448e10171e1c', '6f70b361-8781-47bc-934b-06892458b603', 'emergency_lighting', 'Emergency Lights - FA7817', 'SMALL', 'fire_safety', ARRAY['Engineer Report - 32-34 Connaught Square Flat 5.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, model_number, compliance_category, linked_documents) VALUES ('a7086b09-3779-42c5-b7d8-2de58af77e78', '6f70b361-8781-47bc-934b-06892458b603', 'fire_alarm', 'Fire Alarm', 'SMALL', 'fire_safety', ARRAY['Engineering Report - 32-34 CONNAUGHT SQUARE.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, model_number, compliance_category, linked_documents) VALUES ('97b68174-8754-49c8-adbf-5af18ce89d71', '6f70b361-8781-47bc-934b-06892458b603', 'emergency_lighting', 'Emergency Lights - FA7817', 'SMALL', 'fire_safety', ARRAY['Engineering Report - 32-34 CONNAUGHT SQUARE.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, model_number, service_frequency, compliance_category, linked_documents) VALUES ('1bd7ca68-deab-419e-973f-62ab154a264e', '6f70b361-8781-47bc-934b-06892458b603', 'emergency_lighting', 'Emergency Lights Testing', 'MONTHLY', 'monthly', 'fire_safety', ARRAY['MT8825 03072025.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, model_number, service_frequency, compliance_category, linked_documents) VALUES ('3149e34f-d1f2-4d93-b8fe-1e770b1330e2', '6f70b361-8781-47bc-934b-06892458b603', 'emergency_lighting', 'Emergency Lights Testing', 'MONTHLY', 'monthly', 'fire_safety', ARRAY['January Monthly Test For EL-Connaught Square.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, model_number, service_frequency, compliance_category, linked_documents) VALUES ('22c107cd-8209-4b0d-aa8c-4d172582db21', '6f70b361-8781-47bc-934b-06892458b603', 'emergency_lighting', 'Emergency Lights Testing', 'MONTHLY', 'monthly', 'fire_safety', ARRAY['February Monthly Test For EL-Connaught Square.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('52e0ef0f-bde5-4f9e-ae41-86f73c4e2cd4', '6f70b361-8781-47bc-934b-06892458b603', 'boiler', 'boilers', 'gas_safety', ARRAY['Real Estate Policy (01.23).pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('2528f648-89c5-4163-9947-f4cdb25f2410', '6f70b361-8781-47bc-934b-06892458b603', 'sprinkler', 'sprinkler leakage', 'fire_safety', ARRAY['Real Estate Policy (01.23).pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('9eccfc6d-ce5c-4166-805c-a6779344e225', '6f70b361-8781-47bc-934b-06892458b603', 'pump', 'pumping', 'water_safety', ARRAY['Real Estate Policy (01.23).pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('2c421023-6568-4d71-bb5d-de1067c3da3c', '6f70b361-8781-47bc-934b-06892458b603', 'cctv', 'cameras', 'security', ARRAY['Real Estate Policy (01.23).pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('70480f21-6d21-4718-ac41-8b060bf63482', '6f70b361-8781-47bc-934b-06892458b603', 'fire_extinguisher', 'fire extinguishers', 'fire_safety', ARRAY['Real Estate Policy (01.23).pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('2361cedd-b22c-4015-86d6-dda18d59cb5b', '6f70b361-8781-47bc-934b-06892458b603', 'communal_aerial', 'satellite dishes', 'other', ARRAY['Real Estate Policy (01.23).pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('d77c5582-c128-4a5e-a0ec-ff85ea51c66b', '6f70b361-8781-47bc-934b-06892458b603', 'water_tank', 'water tanks', 'water_safety', ARRAY['Real Estate Policy (01.23).pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('bfe31439-829b-4bee-ac7c-303324c56c00', '6f70b361-8781-47bc-934b-06892458b603', 'sprinkler', 'sprinkler installation', 'fire_safety', ARRAY['Summary of Cover (01.23).pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('f63069ed-41e8-4dda-a61e-02c6f8b1d68c', '6f70b361-8781-47bc-934b-06892458b603', 'lift', 'lift in', 'lifts_safety', ARRAY['Summary of Cover (01.23).pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('6f0f7e43-d7ef-4daa-b74c-8505821fb0ad', '6f70b361-8781-47bc-934b-06892458b603', 'boiler', 'Boilers', 'gas_safety', ARRAY['2023 Allianz VOC - 32-34 Connuaght Square (Freehold) Limited.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('674f2d0c-e714-46e9-a484-80696b67aa93', '6f70b361-8781-47bc-934b-06892458b603', 'lift', 'Lift - Powered', 'lifts_safety', ARRAY['2023 Allianz VOC - 32-34 Connuaght Square (Freehold) Limited.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('d65e25da-dc68-4751-8f10-eec45f29b3fe', '6f70b361-8781-47bc-934b-06892458b603', 'pump', 'Pumps', 'water_safety', ARRAY['2023 Allianz VOC - 32-34 Connuaght Square (Freehold) Limited.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('778a04ca-0e61-4537-a735-2c87d3926034', '6f70b361-8781-47bc-934b-06892458b603', 'boiler', 'Boilers', 'gas_safety', ARRAY['2023 Engineering Renewal Notice - 32 34 Connuaght Square (Freehold) Limited.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('df30d6c5-0926-4b57-b2ab-dff2cc3fdb99', '6f70b361-8781-47bc-934b-06892458b603', 'lift', 'Lift -
Powered', 'lifts_safety', ARRAY['2023 Engineering Renewal Notice - 32 34 Connuaght Square (Freehold) Limited.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('7e0ba139-e80d-4492-96e9-d74f5fa5a816', '6f70b361-8781-47bc-934b-06892458b603', 'pump', 'Pumps', 'water_safety', ARRAY['2023 Engineering Renewal Notice - 32 34 Connuaght Square (Freehold) Limited.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('a6934021-de32-4af6-8d64-cd85182271e2', '6f70b361-8781-47bc-934b-06892458b603', 'lift', 'Lift', 'lifts_safety', ARRAY['32-34 Connaught Sq Buildings Insurance 2023-2024.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('8ed2b93f-34cd-486f-9b82-357e202aaeb1', '6f70b361-8781-47bc-934b-06892458b603', 'lift', 'Lift Report', 'lifts_safety', ARRAY['Allianz - Lift Report 14.03.23.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('14e3424c-3a6c-441f-8fc4-372f78e964ca', '6f70b361-8781-47bc-934b-06892458b603', 'lift', 'Lift Report', 'lifts_safety', ARRAY['Allianz-Lift Report 18.03.2024.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('8e35c84d-cf9c-4119-baf1-aa32ac9d229c', '6f70b361-8781-47bc-934b-06892458b603', 'lift', 'Lift Report', 'lifts_safety', ARRAY['Allianz - Lift Report - 15.09.21.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('6c8fb7b0-35b4-42d5-80e0-6f519ec3c1ec', '6f70b361-8781-47bc-934b-06892458b603', 'lift', 'Lift Report', 'lifts_safety', ARRAY['Allianz - Lift Report 10.03.22.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('30a31b90-0354-4e12-958f-3df7af71691c', '6f70b361-8781-47bc-934b-06892458b603', 'boiler', 'Boilers', 'gas_safety', ARRAY['2023 Allianz VOC - 32-34 Connuaght Square (Freehold) Limited.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('dd55faaa-eea1-4ed9-b6d5-4c95c1b0f35b', '6f70b361-8781-47bc-934b-06892458b603', 'lift', 'Lift - Powered', 'lifts_safety', ARRAY['2023 Allianz VOC - 32-34 Connuaght Square (Freehold) Limited.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('cb8f2a84-644e-4655-b78c-3703a5449e81', '6f70b361-8781-47bc-934b-06892458b603', 'pump', 'Pumps', 'water_safety', ARRAY['2023 Allianz VOC - 32-34 Connuaght Square (Freehold) Limited.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('7cd3bf26-fa8f-43ac-82e1-37bee6fa9513', '6f70b361-8781-47bc-934b-06892458b603', 'boiler', 'Boilers', 'gas_safety', ARRAY['2023 Engineering Renewal Notice - 32 34 Connuaght Square (Freehold) Limited.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('6533459d-4ac1-422a-9db2-fd145ff46d2d', '6f70b361-8781-47bc-934b-06892458b603', 'lift', 'Lift -
Powered', 'lifts_safety', ARRAY['2023 Engineering Renewal Notice - 32 34 Connuaght Square (Freehold) Limited.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('0ccc8ff6-11da-4728-a3db-133209742197', '6f70b361-8781-47bc-934b-06892458b603', 'pump', 'Pumps', 'water_safety', ARRAY['2023 Engineering Renewal Notice - 32 34 Connuaght Square (Freehold) Limited.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, location_description, compliance_category, linked_documents) VALUES ('a44445bd-3d50-4b80-9303-1fe06b576a8d', '6f70b361-8781-47bc-934b-06892458b603', 'boiler', 'Boiler and', 'owned by or leased', 'gas_safety', ARRAY['MO - Policy Wording - NZ0411.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('777115d3-cdf6-4a8c-ba2f-2ce3fa8ec027', '6f70b361-8781-47bc-934b-06892458b603', 'lift', 'Lift and', 'lifts_safety', ARRAY['MO - Policy Wording - NZ0411.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('a9c3a013-2ec4-4937-89bc-0a248a43b575', '6f70b361-8781-47bc-934b-06892458b603', 'pump', 'pumps', 'water_safety', ARRAY['MO - Policy Wording - NZ0411.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('1b36b5ac-6c36-47e5-a022-873f51fef8be', '6f70b361-8781-47bc-934b-06892458b603', 'water_tank', 'Storage Tanks', 'water_safety', ARRAY['MO - Policy Wording - NZ0411.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('f676fb9a-5c27-4709-a70e-794a66f82a51', '6f70b361-8781-47bc-934b-06892458b603', 'generator', 'generator sets', 'electrical_safety', ARRAY['MO - Policy Wording - NZ0411.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('77549344-7215-4d60-993c-a2b30cd69683', '6f70b361-8781-47bc-934b-06892458b603', 'lift', 'Lift and', 'lifts_safety', ARRAY['Feature and Benefits of Allianz Engineering Inspection Service.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('44388602-a14f-4a9e-b254-507c394320de', '6f70b361-8781-47bc-934b-06892458b603', 'boiler', 'Boilers', 'gas_safety', ARRAY['StG_Statement of Facts_32-34 Connaught Square W2 2HL.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('f5bf3d7f-44f5-43d4-95a0-790ab567e63b', '6f70b361-8781-47bc-934b-06892458b603', 'lift', 'Lifts', 'lifts_safety', ARRAY['StG_Statement of Facts_32-34 Connaught Square W2 2HL.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('80546bfa-ae8e-4547-b648-84e7ef5a63e9', '6f70b361-8781-47bc-934b-06892458b603', 'pump', 'Centrifugal pump', 'water_safety', ARRAY['StG_Statement of Facts_32-34 Connaught Square W2 2HL.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('d838feb9-7988-4863-8385-3dcc0d7c51e0', '6f70b361-8781-47bc-934b-06892458b603', 'boiler', 'Boilers', 'gas_safety', ARRAY['StG_Insurance Report_32-34 Connaught Square W2 2HL.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('6f221fe3-9b50-414f-98a4-676ef31f17fc', '6f70b361-8781-47bc-934b-06892458b603', 'lift', 'Lifts', 'lifts_safety', ARRAY['StG_Insurance Report_32-34 Connaught Square W2 2HL.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('85510a2a-ee69-404e-a6bd-e1d7efe8ee9b', '6f70b361-8781-47bc-934b-06892458b603', 'pump', 'Centrifugal pump', 'water_safety', ARRAY['StG_Insurance Report_32-34 Connaught Square W2 2HL.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('0b13f9ee-05ca-475a-a63b-8c33352c8de3', '6f70b361-8781-47bc-934b-06892458b603', 'boiler', 'Boilers', 'gas_safety', ARRAY['StG_Statement of Facts_32-34 Connaught Square W2 2HL.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('ba4e4903-edd1-4736-8c9e-d2499dcbb3cd', '6f70b361-8781-47bc-934b-06892458b603', 'lift', 'Lifts', 'lifts_safety', ARRAY['StG_Statement of Facts_32-34 Connaught Square W2 2HL.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('ed788d96-0b4c-4768-a50c-463ad0fac8c5', '6f70b361-8781-47bc-934b-06892458b603', 'pump', 'Centrifugal pump', 'water_safety', ARRAY['StG_Statement of Facts_32-34 Connaught Square W2 2HL.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('55bd5e21-eff4-414b-a858-27ad682eabfc', '6f70b361-8781-47bc-934b-06892458b603', 'boiler', 'Boilers', 'gas_safety', ARRAY['StG_Insurance Report_32-34 Connaught Square W2 2HL.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('7fcb3bd5-8394-4acf-a302-a0836d330452', '6f70b361-8781-47bc-934b-06892458b603', 'lift', 'Lifts', 'lifts_safety', ARRAY['StG_Insurance Report_32-34 Connaught Square W2 2HL.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('c19c4296-9989-4fa1-8200-743baa75f30f', '6f70b361-8781-47bc-934b-06892458b603', 'pump', 'Centrifugal pump', 'water_safety', ARRAY['StG_Insurance Report_32-34 Connaught Square W2 2HL.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('baa16fbb-6bdc-4d23-abde-652b5c9e4a49', '6f70b361-8781-47bc-934b-06892458b603', 'boiler', 'water boiler', 'gas_safety', ARRAY['StG_Certificate_32-34 Connaught Square W2 2HL.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('34b2b25e-5d1e-45ac-9338-e9313137f18e', '6f70b361-8781-47bc-934b-06892458b603', 'lift', 'Passenger Lift', 'lifts_safety', ARRAY['StG_Certificate_32-34 Connaught Square W2 2HL.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('24a0bfb3-063a-4b04-8591-1347b4efa3ff', '6f70b361-8781-47bc-934b-06892458b603', 'pump', 'Centrifugal pump', 'water_safety', ARRAY['StG_Certificate_32-34 Connaught Square W2 2HL.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('097c70a6-c263-43a9-b73b-863007751a2c', '6f70b361-8781-47bc-934b-06892458b603', 'boiler', 'Boilers', 'gas_safety', ARRAY['StG_Statement of Fact_32-34 Connaught Square W2 2HL.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('454ee402-3e7d-4975-bd3a-71e566e8b7bf', '6f70b361-8781-47bc-934b-06892458b603', 'lift', 'Lifts', 'lifts_safety', ARRAY['StG_Statement of Fact_32-34 Connaught Square W2 2HL.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('248fd4d2-9a22-4b18-b483-49728214e02d', '6f70b361-8781-47bc-934b-06892458b603', 'pump', '1x Pump', 'water_safety', ARRAY['StG_Statement of Fact_32-34 Connaught Square W2 2HL.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('d6c7e7f0-503f-49d8-be4a-8a7f46745692', '6f70b361-8781-47bc-934b-06892458b603', 'lift', 'Lift', 'lifts_safety', ARRAY['FBR113382303-20230405-B.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('ce03da6b-70eb-41e1-b6bb-117a3e58ae6c', '6f70b361-8781-47bc-934b-06892458b603', 'boiler', 'boilers', 'gas_safety', ARRAY['Real Estate Policy (01.23).pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('2182f632-4d56-46f9-9b43-08a41255a45c', '6f70b361-8781-47bc-934b-06892458b603', 'sprinkler', 'sprinkler leakage', 'fire_safety', ARRAY['Real Estate Policy (01.23).pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('0ff28eed-0cc2-4c2d-a434-52e43ce05a7a', '6f70b361-8781-47bc-934b-06892458b603', 'pump', 'pumping', 'water_safety', ARRAY['Real Estate Policy (01.23).pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('a4fc1c76-e026-4c33-9f5b-3d10b9c9ea5f', '6f70b361-8781-47bc-934b-06892458b603', 'cctv', 'cameras', 'security', ARRAY['Real Estate Policy (01.23).pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('51fb3a83-e68a-4e80-b23e-01bbc32f3ab0', '6f70b361-8781-47bc-934b-06892458b603', 'fire_extinguisher', 'fire extinguishers', 'fire_safety', ARRAY['Real Estate Policy (01.23).pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('8db71902-8871-4018-89e0-1289277962e6', '6f70b361-8781-47bc-934b-06892458b603', 'communal_aerial', 'satellite dishes', 'other', ARRAY['Real Estate Policy (01.23).pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('bd24ea10-f900-4390-855b-83de8bbc2cac', '6f70b361-8781-47bc-934b-06892458b603', 'water_tank', 'water tanks', 'water_safety', ARRAY['Real Estate Policy (01.23).pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('2031658c-3c66-479e-9a2b-b9f7f1c02757', '6f70b361-8781-47bc-934b-06892458b603', 'sprinkler', 'sprinkler installation', 'fire_safety', ARRAY['Summary of Cover (01.23).pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('f4d25725-7f74-47e7-96d5-1db8ef482efe', '6f70b361-8781-47bc-934b-06892458b603', 'lift', 'lift in', 'lifts_safety', ARRAY['Summary of Cover (01.23).pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('65feabdf-f349-46ce-adaa-0427a497adaa', '6f70b361-8781-47bc-934b-06892458b603', 'lift', 'Lift', 'lifts_safety', ARRAY['32-34 Connaught Sq Buildings Insurance 2023-2024.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('9a7b027b-658a-4ced-bdbb-8c4af2320c3b', '6f70b361-8781-47bc-934b-06892458b603', 'sprinkler', 'sprinkler installation', 'fire_safety', ARRAY['Zurich Real Estate Policy Summary.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('f8161410-1ba1-42fc-a405-de86c540277f', '6f70b361-8781-47bc-934b-06892458b603', 'lift', 'lift in', 'lifts_safety', ARRAY['Zurich Real Estate Policy Summary.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('da2ad929-c2ba-44f9-b7e2-e85de40f4552', '6f70b361-8781-47bc-934b-06892458b603', 'boiler', 'boilers', 'gas_safety', ARRAY['Zurich Real Estate Policy Wording.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('73a4b51f-6578-4c5e-a861-fa4df3667c9f', '6f70b361-8781-47bc-934b-06892458b603', 'sprinkler', 'sprinkler leakage', 'fire_safety', ARRAY['Zurich Real Estate Policy Wording.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('f2e3be4a-59c4-45a1-be35-c2449ec20d4b', '6f70b361-8781-47bc-934b-06892458b603', 'pump', 'pumping', 'water_safety', ARRAY['Zurich Real Estate Policy Wording.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('621c0aa8-4581-4997-883a-0504affe29fc', '6f70b361-8781-47bc-934b-06892458b603', 'cctv', 'cameras', 'security', ARRAY['Zurich Real Estate Policy Wording.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('a1015326-9412-486d-ac38-68b68288f8e2', '6f70b361-8781-47bc-934b-06892458b603', 'fire_extinguisher', 'fire extinguishers', 'fire_safety', ARRAY['Zurich Real Estate Policy Wording.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('7a0795e5-2197-423d-87ba-32e5904d3687', '6f70b361-8781-47bc-934b-06892458b603', 'communal_aerial', 'satellite dishes', 'other', ARRAY['Zurich Real Estate Policy Wording.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('c9556b12-859e-48e2-acf5-e6a971da6dbc', '6f70b361-8781-47bc-934b-06892458b603', 'water_tank', 'water tanks', 'water_safety', ARRAY['Zurich Real Estate Policy Wording.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('9fca7cb9-7194-4946-8794-835a9d797484', '6f70b361-8781-47bc-934b-06892458b603', 'lift', 'Lift', 'lifts_safety', ARRAY['StG_Certificate_32-34 Connaught Square W2 2HL.pdf']);

-- Insert 22 maintenance schedules
INSERT INTO maintenance_schedules (id, building_id, contract_id, service_type, description, frequency, frequency_interval, next_due_date, estimated_duration, priority, status) VALUES ('111212c9-4a54-447d-9556-ad97112698de', '6f70b361-8781-47bc-934b-06892458b603', '1de5a0c7-e234-4132-b2a9-b4dfaa62a767', 'lifts', 'lifts - ISS', 'monthly', '1 month', '2025-11-09', '4 hours', 'high', 'scheduled');
INSERT INTO maintenance_schedules (id, building_id, contract_id, service_type, description, frequency, frequency_interval, next_due_date, estimated_duration, priority, status) VALUES ('08f0ae96-616b-4b1a-9d96-cfae5921bcbc', '6f70b361-8781-47bc-934b-06892458b603', '7bc9f5c4-5692-4dfc-9d4d-d79c4c2791ce', 'security', 'security - ISS', 'quarterly', '3 months', '2026-01-09', '8 hours', 'medium', 'scheduled');
INSERT INTO maintenance_schedules (id, building_id, contract_id, service_type, description, frequency, frequency_interval, next_due_date, estimated_duration, priority, status) VALUES ('a61aca68-feba-467e-93c5-1722a5c33d72', '6f70b361-8781-47bc-934b-06892458b603', 'f75ba208-f64d-403d-9c67-0e7944c08eab', 'security', 'security - ISS', 'quarterly', '3 months', '2026-01-09', '8 hours', 'medium', 'scheduled');
INSERT INTO maintenance_schedules (id, building_id, contract_id, service_type, description, frequency, frequency_interval, next_due_date, estimated_duration, priority, status) VALUES ('37badc05-022a-47ca-ba4d-4196c1001342', '6f70b361-8781-47bc-934b-06892458b603', 'fbd28033-2e55-43dd-862f-191006670fcc', 'lifts', 'lifts - ISS', 'monthly', '1 month', '2025-11-09', '4 hours', 'high', 'scheduled');
INSERT INTO maintenance_schedules (id, building_id, contract_id, service_type, description, frequency, frequency_interval, next_due_date, estimated_duration, priority, status) VALUES ('17884aee-2c0f-47e6-91a6-29f19967303f', '6f70b361-8781-47bc-934b-06892458b603', '91adf47e-d4bf-4477-9ea4-7fb51d75d13d', 'lifts', 'lifts - ISS', 'monthly', '1 month', '2025-11-09', '4 hours', 'high', 'scheduled');
INSERT INTO maintenance_schedules (id, building_id, contract_id, service_type, description, frequency, frequency_interval, next_due_date, estimated_duration, priority, status) VALUES ('28a3c761-c999-4082-9424-94295eef5209', '6f70b361-8781-47bc-934b-06892458b603', 'b9e7058e-e6ea-4c1b-8839-652844103d09', 'lifts', 'lifts - ISS', 'monthly', '1 month', '2025-11-09', '4 hours', 'high', 'scheduled');
INSERT INTO maintenance_schedules (id, building_id, contract_id, service_type, description, frequency, frequency_interval, next_due_date, estimated_duration, priority, status) VALUES ('d4ac8542-00de-4d75-ad09-5aeedbd0f600', '6f70b361-8781-47bc-934b-06892458b603', '30763126-c454-4a2f-a20a-c4c934cbfbf8', 'lifts', 'lifts - ISS', 'monthly', '1 month', '2025-11-09', '4 hours', 'high', 'scheduled');
INSERT INTO maintenance_schedules (id, building_id, contract_id, service_type, description, frequency, frequency_interval, next_due_date, estimated_duration, priority, status) VALUES ('2f8669f1-9c6b-4f8a-80a0-05391e943a40', '6f70b361-8781-47bc-934b-06892458b603', '90c0bd39-3d8b-428e-815b-ffd61d045cdc', 'lifts', 'lifts - ISS', 'annual', '12 months', '2026-03-14', '4 hours', 'high', 'scheduled');
INSERT INTO maintenance_schedules (id, building_id, contract_id, service_type, description, frequency, frequency_interval, next_due_date, estimated_duration, priority, status) VALUES ('01f555bb-f3b4-4db7-93f6-1c516fb7bea0', '6f70b361-8781-47bc-934b-06892458b603', 'f0893dec-c28b-435f-808c-214bfcdf9502', 'lifts', 'lifts - None', 'monthly', '1 month', '2025-02-13', '4 hours', 'high', 'scheduled');
INSERT INTO maintenance_schedules (id, building_id, contract_id, description, frequency, frequency_interval, next_due_date, priority, status) VALUES ('306a497a-acf0-4d28-92d7-644adfaa5265', '6f70b361-8781-47bc-934b-06892458b603', '0fbef632-bbfc-448e-81f2-d108af50b669', 'None - WHM', 'monthly', '1 month', '2025-11-09', 'medium', 'scheduled');
INSERT INTO maintenance_schedules (id, building_id, contract_id, description, frequency, frequency_interval, next_due_date, priority, status) VALUES ('57801522-39dd-49d8-9e0d-cefcf34e71ae', '6f70b361-8781-47bc-934b-06892458b603', 'f525c95f-1e04-49b7-9e5b-48d976d5fff5', 'None - WHM', 'monthly', '1 month', '2025-11-09', 'medium', 'scheduled');
INSERT INTO maintenance_schedules (id, building_id, contract_id, description, frequency, frequency_interval, next_due_date, priority, status) VALUES ('a2418a7c-082b-4204-a42b-e9a37d1e8f3e', '6f70b361-8781-47bc-934b-06892458b603', 'd69824da-3f93-405f-b397-9efe439b3502', 'None - WHM', 'monthly', '1 month', '2025-11-09', 'medium', 'scheduled');
INSERT INTO maintenance_schedules (id, building_id, contract_id, description, frequency, frequency_interval, next_due_date, priority, status) VALUES ('4c17c877-0d3b-4c51-af80-3b267bbbcf1f', '6f70b361-8781-47bc-934b-06892458b603', '35c2e100-06a8-4d0c-a53f-31ae16f171d7', 'None - WHM', 'monthly', '1 month', '2025-11-09', 'medium', 'scheduled');
INSERT INTO maintenance_schedules (id, building_id, contract_id, service_type, description, frequency, frequency_interval, next_due_date, estimated_duration, priority, status) VALUES ('e03eb814-dd9a-4e2a-afe6-dc0912b09bea', '6f70b361-8781-47bc-934b-06892458b603', '5dd280b5-f7b8-481a-ace8-9ba752ed849f', 'security', 'security - Capita', 'monthly', '1 month', '2025-11-09', '8 hours', 'medium', 'scheduled');
INSERT INTO maintenance_schedules (id, building_id, contract_id, service_type, description, frequency, frequency_interval, next_due_date, estimated_duration, priority, status) VALUES ('7c5f059f-5913-47bf-aeae-a845fe8266a6', '6f70b361-8781-47bc-934b-06892458b603', '2ef0a124-07c5-43e0-8c01-7009e0955164', 'fire_alarm', 'fire_alarm - Capita', 'monthly', '1 month', '2025-11-09', '2 hours', 'high', 'scheduled');
INSERT INTO maintenance_schedules (id, building_id, contract_id, service_type, description, frequency, frequency_interval, next_due_date, estimated_duration, priority, status) VALUES ('dc0d0e8e-dbac-4c82-bacc-b8e44347e748', '6f70b361-8781-47bc-934b-06892458b603', 'ae474eb6-031f-4e5a-9298-a934bda0a22d', 'fire_alarm', 'fire_alarm - None', 'monthly', '1 month', '2025-11-09', '2 hours', 'high', 'scheduled');
INSERT INTO maintenance_schedules (id, building_id, contract_id, service_type, description, frequency, frequency_interval, next_due_date, estimated_duration, priority, status) VALUES ('0eb1562d-6e30-4f2b-abcb-b030e952784c', '6f70b361-8781-47bc-934b-06892458b603', 'e2db6e94-37f1-4764-b8a1-4c45641328e9', 'fire_alarm', 'fire_alarm - None', 'monthly', '1 month', '2025-11-09', '2 hours', 'high', 'scheduled');
INSERT INTO maintenance_schedules (id, building_id, contract_id, service_type, description, frequency, frequency_interval, next_due_date, estimated_duration, priority, status) VALUES ('8eb6f28e-8ed1-4e45-8c8c-9e9dd6eadd14', '6f70b361-8781-47bc-934b-06892458b603', 'dce763a2-701b-4230-ab2d-bf5e67eaa691', 'fire_alarm', 'fire_alarm - None', 'monthly', '1 month', '2025-11-09', '2 hours', 'high', 'scheduled');
INSERT INTO maintenance_schedules (id, building_id, contract_id, description, frequency, frequency_interval, next_due_date, priority, status) VALUES ('e7a9e48b-6de2-41bb-b3fe-282e3d283014', '6f70b361-8781-47bc-934b-06892458b603', 'dee16389-d46a-4d0a-84b0-0e889f813205', 'None - WHM', 'monthly', '1 month', '2025-11-09', 'medium', 'scheduled');
INSERT INTO maintenance_schedules (id, building_id, contract_id, description, frequency, frequency_interval, next_due_date, priority, status) VALUES ('2f14ecce-b5fb-4e60-9f3c-5f92e8e5f953', '6f70b361-8781-47bc-934b-06892458b603', '258707e2-bdcb-49a0-9a5d-66e4fb80ba26', 'None - None', 'monthly', '1 month', '2025-11-09', 'medium', 'scheduled');
INSERT INTO maintenance_schedules (id, building_id, contract_id, description, frequency, frequency_interval, next_due_date, priority, status) VALUES ('7502ef31-5d10-457a-a935-58999091a89d', '6f70b361-8781-47bc-934b-06892458b603', '8dca5c95-729d-423b-8522-d492cb70066d', 'None - None', 'monthly', '1 month', '2025-11-09', 'medium', 'scheduled');
INSERT INTO maintenance_schedules (id, building_id, contract_id, description, frequency, frequency_interval, next_due_date, priority, status) VALUES ('4fea0167-493d-418a-9861-076e87f07b09', '6f70b361-8781-47bc-934b-06892458b603', 'aa120dfb-89c1-4ed2-93a3-9c042a41b7e9', 'None - None', 'monthly', '1 month', '2025-11-09', 'medium', 'scheduled');

-- Insert 28 lease records
INSERT INTO leases (unit_number, leaseholder_name, ground_rent, file_path) VALUES ('Unknown', 'Unknown', '0', 'unknown');
INSERT INTO leases (unit_number, leaseholder_name, ground_rent, file_path) VALUES ('Unknown', 'Unknown', '0', 'unknown');
INSERT INTO leases (unit_number, leaseholder_name, ground_rent, file_path) VALUES ('Unknown', 'Unknown', '0', 'unknown');
INSERT INTO leases (unit_number, leaseholder_name, ground_rent, file_path) VALUES ('Unknown', 'Unknown', '0', 'unknown');
INSERT INTO leases (unit_number, leaseholder_name, ground_rent, file_path) VALUES ('Unknown', 'Unknown', '0', 'unknown');
INSERT INTO leases (unit_number, leaseholder_name, ground_rent, file_path) VALUES ('Unknown', 'Unknown', '0', 'unknown');
INSERT INTO leases (unit_number, leaseholder_name, ground_rent, file_path) VALUES ('Unknown', 'Unknown', '0', 'unknown');
INSERT INTO leases (unit_number, leaseholder_name, ground_rent, file_path) VALUES ('Unknown', 'Unknown', '0', 'unknown');
INSERT INTO leases (unit_number, leaseholder_name, ground_rent, file_path) VALUES ('Unknown', 'Unknown', '0', 'unknown');
INSERT INTO leases (unit_number, leaseholder_name, ground_rent, file_path) VALUES ('Unknown', 'Unknown', '0', 'unknown');
INSERT INTO leases (unit_number, leaseholder_name, ground_rent, file_path) VALUES ('Unknown', 'Unknown', '0', 'unknown');
INSERT INTO leases (unit_number, leaseholder_name, ground_rent, file_path) VALUES ('Unknown', 'Unknown', '0', 'unknown');
INSERT INTO leases (unit_number, leaseholder_name, ground_rent, file_path) VALUES ('Unknown', 'Unknown', '0', 'unknown');
INSERT INTO leases (unit_number, leaseholder_name, ground_rent, file_path) VALUES ('Unknown', 'Unknown', '0', 'unknown');
INSERT INTO leases (unit_number, leaseholder_name, ground_rent, file_path) VALUES ('Unknown', 'Unknown', '0', 'unknown');
INSERT INTO leases (unit_number, leaseholder_name, ground_rent, file_path) VALUES ('Unknown', 'Unknown', '0', 'unknown');
INSERT INTO leases (unit_number, leaseholder_name, ground_rent, file_path) VALUES ('Unknown', 'Unknown', '0', 'unknown');
INSERT INTO leases (unit_number, leaseholder_name, ground_rent, file_path) VALUES ('Unknown', 'Unknown', '0', 'unknown');
INSERT INTO leases (unit_number, leaseholder_name, ground_rent, file_path) VALUES ('Unknown', 'Unknown', '0', 'unknown');
INSERT INTO leases (unit_number, leaseholder_name, ground_rent, file_path) VALUES ('Unknown', 'Unknown', '0', 'unknown');
INSERT INTO leases (unit_number, leaseholder_name, ground_rent, file_path) VALUES ('Unknown', 'Unknown', '0', 'unknown');
INSERT INTO leases (unit_number, leaseholder_name, ground_rent, file_path) VALUES ('Unknown', 'Unknown', '0', 'unknown');
INSERT INTO leases (unit_number, leaseholder_name, ground_rent, file_path) VALUES ('Unknown', 'Unknown', '0', 'unknown');
INSERT INTO leases (unit_number, leaseholder_name, ground_rent, file_path) VALUES ('Unknown', 'Unknown', '0', 'unknown');
INSERT INTO leases (unit_number, leaseholder_name, ground_rent, file_path) VALUES ('Unknown', 'Unknown', '0', 'unknown');
INSERT INTO leases (unit_number, leaseholder_name, ground_rent, file_path) VALUES ('Unknown', 'Unknown', '0', 'unknown');
INSERT INTO leases (unit_number, leaseholder_name, ground_rent, file_path) VALUES ('Unknown', 'Unknown', '0', 'unknown');
INSERT INTO leases (unit_number, leaseholder_name, ground_rent, file_path) VALUES ('Unknown', 'Unknown', '0', 'unknown');


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


-- Building knowledge: Caretaker
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '6628e410-cbff-4314-9924-13d4e8497978',
    '6f70b361-8781-47bc-934b-06892458b603',
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
    '8907d7e6-80a0-4395-8b29-e5e22b721ac9',
    '6f70b361-8781-47bc-934b-06892458b603',
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
    '587c7a4f-1aae-4a6c-89b0-c7612dc7ead8',
    '6f70b361-8781-47bc-934b-06892458b603',
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
    'a59b3def-2b25-4ecb-af54-3180eaa25abf',
    '6f70b361-8781-47bc-934b-06892458b603',
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
    '8b8517ab-10a4-424c-a6e8-c1918e8d8f7f',
    '6f70b361-8781-47bc-934b-06892458b603',
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
    'c0dfa820-2e34-4a60-a08a-314458e3695e',
    '6f70b361-8781-47bc-934b-06892458b603',
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
    '5e98e4b7-2009-4741-b87a-69cab009e26a',
    '6f70b361-8781-47bc-934b-06892458b603',
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
    '82d36b2f-1ead-42ef-b0ea-a1d2b52a32c0',
    '6f70b361-8781-47bc-934b-06892458b603',
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
    '4d438546-4d76-4a15-91af-5f2797f20cf6',
    '6f70b361-8781-47bc-934b-06892458b603',
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
    'c6cad100-2465-4a6c-96ee-314a2f08ffcc',
    '6f70b361-8781-47bc-934b-06892458b603',
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
    '5e084e67-ba30-4617-ade1-90b60479e5ce',
    '6f70b361-8781-47bc-934b-06892458b603',
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
    'be69d1ce-4636-4835-a242-0b4552ee0022',
    '6f70b361-8781-47bc-934b-06892458b603',
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
    'a8404f76-756e-4188-b724-26bd6c07caa2',
    '6f70b361-8781-47bc-934b-06892458b603',
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
    'da2c2bd1-d3f0-4b78-938f-257fc52cc947',
    '6f70b361-8781-47bc-934b-06892458b603',
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
    'ccee7517-50ed-4a1e-92e4-575c0f4bdb39',
    '6f70b361-8781-47bc-934b-06892458b603',
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
    '0115d55b-e47f-4e39-a1e9-61860b5c1f04',
    '6f70b361-8781-47bc-934b-06892458b603',
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
    '0b21d182-6ee2-4303-99e0-a5c68054cf14',
    '6f70b361-8781-47bc-934b-06892458b603',
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
    'fa9cb9aa-5435-4129-8351-a5dde6957005',
    '6f70b361-8781-47bc-934b-06892458b603',
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
    '38a1230e-4d9a-45fa-bf1b-073ab76a7219',
    '6f70b361-8781-47bc-934b-06892458b603',
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
    'd6bedd6b-fede-40e8-9c38-02f2104f1eb4',
    '6f70b361-8781-47bc-934b-06892458b603',
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
    '1b95bd3e-8855-4aa4-910d-6ddbd7424fdb',
    '6f70b361-8781-47bc-934b-06892458b603',
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
    'd6b51c14-c2c9-4e72-a5bf-f9a8e300306e',
    '6f70b361-8781-47bc-934b-06892458b603',
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
    'fcfccb80-2fe3-4575-a506-a229c8c505e1',
    '6f70b361-8781-47bc-934b-06892458b603',
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
    '4f02d19a-317d-4303-a0db-d45f024a5ff3',
    '6f70b361-8781-47bc-934b-06892458b603',
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
    '2eaad515-7b16-434c-af5a-cd6fd8add716',
    '6f70b361-8781-47bc-934b-06892458b603',
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
    'f4866f46-4bcb-418e-833d-1eb827ef3823',
    '6f70b361-8781-47bc-934b-06892458b603',
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
    '08368833-de7b-498a-850c-3da73cb946c3',
    '6f70b361-8781-47bc-934b-06892458b603',
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
    'a2a68129-e878-477f-a343-cd69d63d7d96',
    '6f70b361-8781-47bc-934b-06892458b603',
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
    '9c6255f7-797b-449c-bdc8-337a82df3b03',
    '6f70b361-8781-47bc-934b-06892458b603',
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
    'ac6f476f-577e-4409-8c2a-9ef7188248d8',
    '6f70b361-8781-47bc-934b-06892458b603',
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
    'a41a538a-60db-444b-964f-2510936b3b38',
    '6f70b361-8781-47bc-934b-06892458b603',
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
    'd92cd279-4f82-4a30-8b25-52772267d41f',
    '6f70b361-8781-47bc-934b-06892458b603',
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
    '0e42ebef-50a1-4ee8-b124-45fb1325f511',
    '6f70b361-8781-47bc-934b-06892458b603',
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
    'b6078ec4-f8e4-4842-9f2c-b0af9c6c8a89',
    '6f70b361-8781-47bc-934b-06892458b603',
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
    'de3f26ae-11f7-4c70-b98e-372af2e37272',
    '6f70b361-8781-47bc-934b-06892458b603',
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
    'ff26dfaa-4ce8-4f8a-820a-8cb73bfbcdc2',
    '6f70b361-8781-47bc-934b-06892458b603',
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
    'b4f21c50-419f-4519-9d12-0bcb9e0735b5',
    '6f70b361-8781-47bc-934b-06892458b603',
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
    '84ab4c73-76b4-4259-9dbd-6f54cfa12fa1',
    '6f70b361-8781-47bc-934b-06892458b603',
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
    'b92dca3d-22e0-4558-aef5-c19ea551e734',
    '6f70b361-8781-47bc-934b-06892458b603',
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
    '0091e1c1-41d7-4be7-aa5c-4cc9aea5e64a',
    '6f70b361-8781-47bc-934b-06892458b603',
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
    '832b18e0-c163-4f50-8228-438b97d2d90f',
    '6f70b361-8781-47bc-934b-06892458b603',
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
    'f4e37635-8b52-4c6c-b3ed-93767268e9d5',
    '6f70b361-8781-47bc-934b-06892458b603',
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
    'dd97d9bd-b53c-491f-b312-1b269827857b',
    '6f70b361-8781-47bc-934b-06892458b603',
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
    'c3efa2e8-95e4-4fd8-bd36-62276d2b2c57',
    '6f70b361-8781-47bc-934b-06892458b603',
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
    'dc860cec-b9be-4b87-a6bc-2395faf7e361',
    '6f70b361-8781-47bc-934b-06892458b603',
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
    'e8b27011-c226-4e26-acd1-6e58a8fc786c',
    '6f70b361-8781-47bc-934b-06892458b603',
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
    'e2de6c21-c625-4545-8a45-11f1a2dbe86c',
    '6f70b361-8781-47bc-934b-06892458b603',
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
    'cee4dca0-f467-40e9-adad-f8ace0c89c0c',
    '6f70b361-8781-47bc-934b-06892458b603',
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
    '6490b656-4ca5-4ddc-8783-c23f0070a3db',
    '6f70b361-8781-47bc-934b-06892458b603',
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
    '251e34fc-d84d-4592-9a56-52736539028c',
    '6f70b361-8781-47bc-934b-06892458b603',
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
    '6d2a33ba-2d1b-4705-9188-4eda9b1f166d',
    '6f70b361-8781-47bc-934b-06892458b603',
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
    '1c4300de-c973-4d26-a3a0-2538dc0d6785',
    '6f70b361-8781-47bc-934b-06892458b603',
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
    'ded45e1b-69e2-4f1b-a3d2-5646f2c06c80',
    '6f70b361-8781-47bc-934b-06892458b603',
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
    '6a7ce57e-0025-4089-ae94-7dc0bcdab55e',
    '6f70b361-8781-47bc-934b-06892458b603',
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
    'dfc83aab-8523-4fe3-bc87-cad36064eb60',
    '6f70b361-8781-47bc-934b-06892458b603',
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
    '7dbf92ec-6d82-49fa-a78b-a230939f85eb',
    '6f70b361-8781-47bc-934b-06892458b603',
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
    '6ceb9337-da5e-47a3-9305-8ff0397c5ef6',
    '6f70b361-8781-47bc-934b-06892458b603',
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
    'ac0581b2-3b8f-4b1a-97b3-2c2dfe74d5e4',
    '6f70b361-8781-47bc-934b-06892458b603',
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
    'dfbcd4a8-a5d0-4596-8b29-c593708ff263',
    '6f70b361-8781-47bc-934b-06892458b603',
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
    'aa671b0c-cb35-48f1-a51a-d1e703be1b5b',
    '6f70b361-8781-47bc-934b-06892458b603',
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
    'c5183d37-b121-4928-9528-6aaf6e7f9d8c',
    '6f70b361-8781-47bc-934b-06892458b603',
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
    '953c2418-d813-4558-93f9-427277d98d86',
    '6f70b361-8781-47bc-934b-06892458b603',
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
    'eccbf12b-13d8-46b9-8b59-9fbae4086281',
    '6f70b361-8781-47bc-934b-06892458b603',
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
    '478a580e-d8c1-44ca-b1d2-04ceba43f612',
    '6f70b361-8781-47bc-934b-06892458b603',
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
    '787e4326-37b3-4c3e-a95d-5577c34277e1',
    '6f70b361-8781-47bc-934b-06892458b603',
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
    '958fe8a2-4eab-4032-9771-f13465edad2c',
    '6f70b361-8781-47bc-934b-06892458b603',
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
    'd671ab37-79d7-4465-94cf-0d16b84727fd',
    '6f70b361-8781-47bc-934b-06892458b603',
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
    '7d6b140c-00c9-4206-80f0-1842ed92079b',
    '6f70b361-8781-47bc-934b-06892458b603',
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
    '212d69f0-01ab-4dcf-8e51-2231ec9649c5',
    '6f70b361-8781-47bc-934b-06892458b603',
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
    'a4fb4637-cc64-4488-b8ab-bd12b3845554',
    '6f70b361-8781-47bc-934b-06892458b603',
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
    '2673ad29-edc6-44c7-ac93-5f0ad99a79c4',
    '6f70b361-8781-47bc-934b-06892458b603',
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
    '8ef71376-141c-4af1-9dcf-2f81d0a35834',
    '6f70b361-8781-47bc-934b-06892458b603',
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
    'e8535c18-47f6-4f3c-9098-51f4eac2de31',
    '6f70b361-8781-47bc-934b-06892458b603',
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
    '75fb8864-72eb-42d6-ac89-c9a6fdb5022b',
    '6f70b361-8781-47bc-934b-06892458b603',
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
    '1902db25-5f61-4947-b62a-c61526fa04ed',
    '6f70b361-8781-47bc-934b-06892458b603',
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
    '4f706152-203a-4d92-a841-ce7b0693eb39',
    '6f70b361-8781-47bc-934b-06892458b603',
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
    'e44dc75f-c85b-4b94-9eb4-5b5b46022db0',
    '6f70b361-8781-47bc-934b-06892458b603',
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
    '21e2193f-ce65-4172-8693-b250a875dec6',
    '6f70b361-8781-47bc-934b-06892458b603',
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
    '100122b1-5678-49ee-a22b-8a3b811567df',
    '6f70b361-8781-47bc-934b-06892458b603',
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
    'e6cdc736-b403-48c7-9153-8ec15628c4d9',
    '6f70b361-8781-47bc-934b-06892458b603',
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
    '9ce05936-4ce3-42a3-b426-b4a3fe781e5f',
    '6f70b361-8781-47bc-934b-06892458b603',
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
    '3075dd8b-e040-4e62-9b0c-2373f4482dd8',
    '6f70b361-8781-47bc-934b-06892458b603',
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
    'cac035b1-4bf0-41b4-9b62-f6ab9a4a4d0d',
    '6f70b361-8781-47bc-934b-06892458b603',
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
    'cf358b13-0855-4c95-b4d0-0c93d2729b53',
    '6f70b361-8781-47bc-934b-06892458b603',
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
    '06990be4-a5b8-495c-9b9b-342efb5c2628',
    '6f70b361-8781-47bc-934b-06892458b603',
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
    'e44a92d4-dc29-406e-bf71-985aa965630a',
    '6f70b361-8781-47bc-934b-06892458b603',
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
    '91c2492e-8352-4a8c-85b2-5095eed97f96',
    '6f70b361-8781-47bc-934b-06892458b603',
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
    'f9c67fa9-e811-474d-ae8e-8aada23ec5f7',
    '6f70b361-8781-47bc-934b-06892458b603',
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
    '808579c3-42ba-49a5-b952-2ced34b449fc',
    '6f70b361-8781-47bc-934b-06892458b603',
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
    '979094ca-f67f-411a-87c6-36298ed2a03b',
    '6f70b361-8781-47bc-934b-06892458b603',
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
    'ec1ec580-0ca8-41b8-b8d8-e03f8f82cfff',
    '6f70b361-8781-47bc-934b-06892458b603',
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
    'abe37700-d4c8-41cb-841b-7129e42a95bf',
    '6f70b361-8781-47bc-934b-06892458b603',
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
    '569184cb-c453-45c3-8baf-06eb5e8ae37f',
    '6f70b361-8781-47bc-934b-06892458b603',
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
    '22e18074-173e-4538-8fca-c493a8f99c78',
    '6f70b361-8781-47bc-934b-06892458b603',
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
    '88e5f8b5-4ee6-4164-9d6a-b8faa783caae',
    '6f70b361-8781-47bc-934b-06892458b603',
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
    'b9081373-d314-4af3-bf22-04ed738287a1',
    '6f70b361-8781-47bc-934b-06892458b603',
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
    'a579d3e4-c161-4db6-b6f3-b201cd42830e',
    '6f70b361-8781-47bc-934b-06892458b603',
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
    'a2debee6-34dc-4f29-b755-42fcf08c0dc2',
    '6f70b361-8781-47bc-934b-06892458b603',
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
    '0cba2e3b-4c88-4783-ab1b-ffdc72adf33f',
    '6f70b361-8781-47bc-934b-06892458b603',
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
    '09ea1a0f-24e2-4755-997f-151a630975bb',
    '6f70b361-8781-47bc-934b-06892458b603',
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
    '1c6ba3b1-d907-4b8d-8f9a-c07da0db1ded',
    '6f70b361-8781-47bc-934b-06892458b603',
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
    '436404c5-e4fa-4995-ae03-0f3f7dd6fc7e',
    '6f70b361-8781-47bc-934b-06892458b603',
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
    'b76003a2-d0df-42b6-b5db-bc7501951df9',
    '6f70b361-8781-47bc-934b-06892458b603',
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
    'dfe51039-62de-49c2-b535-e95135368eca',
    '6f70b361-8781-47bc-934b-06892458b603',
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
    'c1ccdff1-da54-45b4-818d-c43c760972e4',
    '6f70b361-8781-47bc-934b-06892458b603',
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
    '762bf7b2-49e2-4089-9cc0-9fc0d7a6a24a',
    '6f70b361-8781-47bc-934b-06892458b603',
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
    '79a75f35-dd29-46d6-9982-d73ce3558dc5',
    '6f70b361-8781-47bc-934b-06892458b603',
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
    '4b546cef-09bc-4f6a-a468-f3c3aab9d731',
    '6f70b361-8781-47bc-934b-06892458b603',
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
    '7d1d548d-a270-4736-af57-44ab02131f34',
    '6f70b361-8781-47bc-934b-06892458b603',
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
    '3a3a82d5-e5bc-42d1-b960-7ec2d791b5ee',
    '6f70b361-8781-47bc-934b-06892458b603',
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
    'e5af2410-eed1-486e-bdda-3f05f88339a7',
    '6f70b361-8781-47bc-934b-06892458b603',
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
    '1f2ac966-72b2-4cb1-82de-976be6b36990',
    '6f70b361-8781-47bc-934b-06892458b603',
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
    'b055c472-f482-4068-9346-7335459f1156',
    '6f70b361-8781-47bc-934b-06892458b603',
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
    '09d5f28b-b759-4305-a767-09590a39126a',
    '6f70b361-8781-47bc-934b-06892458b603',
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
    'dc8bb94d-2615-4d76-830c-9a3a95e2faa8',
    '6f70b361-8781-47bc-934b-06892458b603',
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
    '53e5e120-5396-4de6-aa7c-3b61f9a756b0',
    '6f70b361-8781-47bc-934b-06892458b603',
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
    'fd582909-365e-47f3-a2f6-5753ef101bf0',
    '6f70b361-8781-47bc-934b-06892458b603',
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
    'c0fa01b5-2e8a-41cf-89af-c48d3bf98c07',
    '6f70b361-8781-47bc-934b-06892458b603',
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
    '27e58824-51dc-420e-97e4-59caff918b02',
    '6f70b361-8781-47bc-934b-06892458b603',
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
    'a1aba5e2-3f35-440b-8aa0-600833a11136',
    '6f70b361-8781-47bc-934b-06892458b603',
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
    'ef89e861-a32b-4a0f-bf28-083636a5db06',
    '6f70b361-8781-47bc-934b-06892458b603',
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
    '38cef0c1-fec2-4077-bf5c-39a48114ce6e',
    '6f70b361-8781-47bc-934b-06892458b603',
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
    '266e3fa3-5c44-4942-a762-ce69f4fbffdd',
    '6f70b361-8781-47bc-934b-06892458b603',
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
    '007dc246-fa3f-443a-968f-d7d33014b209',
    '6f70b361-8781-47bc-934b-06892458b603',
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
    'fe5ef77d-629a-4712-b616-8547859bd307',
    '6f70b361-8781-47bc-934b-06892458b603',
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
    '545742c0-6c6e-48cf-be42-84c8a6785874',
    '6f70b361-8781-47bc-934b-06892458b603',
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
    '986d860d-da8a-4827-9664-e6abb92e792f',
    '6f70b361-8781-47bc-934b-06892458b603',
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
    '1c1ddc37-ddcf-4c04-b8d1-0e2616c2a324',
    '6f70b361-8781-47bc-934b-06892458b603',
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
    'ad22ae56-1b1f-4703-82b3-e2b1fa31cc42',
    '6f70b361-8781-47bc-934b-06892458b603',
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
    'd8451d16-8784-4e22-b94f-d2e73033c4c1',
    '6f70b361-8781-47bc-934b-06892458b603',
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
    'a202cfd3-ab51-4704-9f8e-f74fa1f5f1f1',
    '6f70b361-8781-47bc-934b-06892458b603',
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
    '7103e49c-bd99-4d5e-a281-784a23b01e10',
    '6f70b361-8781-47bc-934b-06892458b603',
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
    '6393614f-8d21-4a88-bab0-af4be1bd5fca',
    '6f70b361-8781-47bc-934b-06892458b603',
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
    '59439bf5-734f-4c37-82d3-9a93a1189229',
    '6f70b361-8781-47bc-934b-06892458b603',
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
    'e622c675-a58b-4079-8e04-bd7f43e66e08',
    '6f70b361-8781-47bc-934b-06892458b603',
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
    'e6956992-0b39-4df6-8e05-495e2c59ac67',
    '6f70b361-8781-47bc-934b-06892458b603',
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
    '1d09fedd-2b82-4408-a2ef-1eba2c412d2e',
    '6f70b361-8781-47bc-934b-06892458b603',
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
    '3263830d-bd65-4082-8500-19db12d8bb8c',
    '6f70b361-8781-47bc-934b-06892458b603',
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
    '9fa90b10-12f6-49f0-9660-55413dce6afa',
    '6f70b361-8781-47bc-934b-06892458b603',
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
    '8829669c-4ed2-484f-94e1-edc29a88c85c',
    '6f70b361-8781-47bc-934b-06892458b603',
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
    '7ca2c608-2250-4d92-b49b-b270c24d8b5b',
    '6f70b361-8781-47bc-934b-06892458b603',
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
    'ab0d7ad7-6cd7-4067-92ce-6fe06966e092',
    '6f70b361-8781-47bc-934b-06892458b603',
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
    'e021f8c7-2eb7-4dc6-9759-e7bad5fb3e6b',
    '6f70b361-8781-47bc-934b-06892458b603',
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
    'e1284834-3dde-4249-aec4-7b8c06a16b7e',
    '6f70b361-8781-47bc-934b-06892458b603',
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
    '63dc675a-e9db-4eca-95e1-cff5b86642ee',
    '6f70b361-8781-47bc-934b-06892458b603',
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
    '72f40b8b-3fe9-441e-9138-1d6e55c4d249',
    '6f70b361-8781-47bc-934b-06892458b603',
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
    'c378494f-c191-4238-86d1-0e8ddc44f5f1',
    '6f70b361-8781-47bc-934b-06892458b603',
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
    '46d5b4e1-b693-4a25-9be8-7b779206d254',
    '6f70b361-8781-47bc-934b-06892458b603',
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
    '8875210a-ff02-41b3-847c-82c3b4f7245e',
    '6f70b361-8781-47bc-934b-06892458b603',
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
    'e1b0608c-fef1-4445-b359-749f42b2f0f9',
    '6f70b361-8781-47bc-934b-06892458b603',
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
    '10ff384c-a761-457f-9eef-69be642ea5ab',
    '6f70b361-8781-47bc-934b-06892458b603',
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
    '4425fe9d-14a8-4e9c-a79d-5ddd1b4afe18',
    '6f70b361-8781-47bc-934b-06892458b603',
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
    '2e75848d-3877-4bd5-9f7f-6b0f52afe998',
    '6f70b361-8781-47bc-934b-06892458b603',
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
    '269be3d5-e7ec-4496-934c-18bebed9052f',
    '6f70b361-8781-47bc-934b-06892458b603',
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
    'a512bbaa-3491-4f18-8845-6fdfa965e2ba',
    '6f70b361-8781-47bc-934b-06892458b603',
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
    '31bb9025-d60c-4c1c-813b-bfa87674c6ef',
    '6f70b361-8781-47bc-934b-06892458b603',
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
    '3817a48b-3419-4cb1-ab94-0eb7d3d4e903',
    '6f70b361-8781-47bc-934b-06892458b603',
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
    'bfe645c0-57e9-495e-af96-d1fdffdb0315',
    '6f70b361-8781-47bc-934b-06892458b603',
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
    '0bb899d1-c216-4330-ab02-f1a81c487410',
    '6f70b361-8781-47bc-934b-06892458b603',
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
    'b841cb1f-ff06-4f7c-a39d-f29dca41bd83',
    '6f70b361-8781-47bc-934b-06892458b603',
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
    'c0720cc2-67c7-4e59-b71f-5d7199ddb5a0',
    '6f70b361-8781-47bc-934b-06892458b603',
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
    '65f873f4-0c45-462e-b765-580778dcaa70',
    '6f70b361-8781-47bc-934b-06892458b603',
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
    'f43fc2d0-6b76-4e33-b642-32aeca97600b',
    '6f70b361-8781-47bc-934b-06892458b603',
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
    '445ec96f-6559-4e69-8b47-947a8458a07c',
    '6f70b361-8781-47bc-934b-06892458b603',
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
    'b167319e-6f19-4857-84a3-932adc5b7e31',
    '6f70b361-8781-47bc-934b-06892458b603',
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
    'db2f862d-8cc3-46b2-9a2e-aec2ad092607',
    '6f70b361-8781-47bc-934b-06892458b603',
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
    '61e7c501-084e-41e9-b43a-9ddebf193ce4',
    '6f70b361-8781-47bc-934b-06892458b603',
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
    '2b77d981-aae7-4d16-8467-af77d13af211',
    '6f70b361-8781-47bc-934b-06892458b603',
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
    'dad9bf0f-80f4-467a-9b8e-8b0c27496ca7',
    '6f70b361-8781-47bc-934b-06892458b603',
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
    '3c6220a4-ee75-446b-a2a1-2cc195d02af0',
    '6f70b361-8781-47bc-934b-06892458b603',
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
    '91f7a729-ba7e-478f-b991-1d941fb29699',
    '6f70b361-8781-47bc-934b-06892458b603',
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
    '907cf1f5-63db-4e90-b88d-383a745a96d2',
    '6f70b361-8781-47bc-934b-06892458b603',
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
    'b8187a15-ea83-48b3-b963-6d00c846ae40',
    '6f70b361-8781-47bc-934b-06892458b603',
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
    '832cf721-114d-4ec0-bd97-62c36c6c1a2c',
    '6f70b361-8781-47bc-934b-06892458b603',
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
    'b312f6b7-827a-424a-bf2d-93884685d115',
    '6f70b361-8781-47bc-934b-06892458b603',
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
    '5b818494-e333-4fa2-8eea-aea55d2dbde4',
    '6f70b361-8781-47bc-934b-06892458b603',
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
    '6a80ff4e-6720-461c-8ed3-63820f2c17c6',
    '6f70b361-8781-47bc-934b-06892458b603',
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
    '447de76c-a87e-4a7c-8dfd-08c1dfcd236f',
    '6f70b361-8781-47bc-934b-06892458b603',
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
    '83f5a9f7-28fc-4963-8a39-f6af1c2afacf',
    '6f70b361-8781-47bc-934b-06892458b603',
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
    'd722128a-9cdb-4361-a3f5-1a620238d320',
    '6f70b361-8781-47bc-934b-06892458b603',
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
    '0d083a14-e301-4c40-b55b-d619075b1ffd',
    '6f70b361-8781-47bc-934b-06892458b603',
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
    'a601c69e-f025-4385-a071-42b4f360d20b',
    '6f70b361-8781-47bc-934b-06892458b603',
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
    '01fbd2ff-7d03-40fa-a20c-a19c7b1f6f03',
    '6f70b361-8781-47bc-934b-06892458b603',
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
    'd14acc46-a58f-4b2a-bd27-65fa89dbaa59',
    '6f70b361-8781-47bc-934b-06892458b603',
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
    '87b56851-48a9-475b-9b2b-5aacfeea2109',
    '6f70b361-8781-47bc-934b-06892458b603',
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
    '751c038c-9d29-4914-86cd-9789ba5a7272',
    '6f70b361-8781-47bc-934b-06892458b603',
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
    'f0101729-653e-4733-9a79-41849266af45',
    '6f70b361-8781-47bc-934b-06892458b603',
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
    '31092b2f-a809-40a8-bf0e-7a658198ded9',
    '6f70b361-8781-47bc-934b-06892458b603',
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
    '02aa6626-63d7-443f-af18-fd44425e5586',
    '6f70b361-8781-47bc-934b-06892458b603',
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
    '7001c0e2-c0bb-4d60-90af-716f803790cf',
    '6f70b361-8781-47bc-934b-06892458b603',
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
    '5b4588a3-ad89-40e6-9b35-f59493ba6d41',
    '6f70b361-8781-47bc-934b-06892458b603',
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
    'f15068f4-761d-4f75-92da-efdf523866a0',
    '6f70b361-8781-47bc-934b-06892458b603',
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
    '5934ba84-17de-4677-8956-aa539ad08e0f',
    '6f70b361-8781-47bc-934b-06892458b603',
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
    '2a74ba86-6b0d-4315-9449-5a2c52182a7b',
    '6f70b361-8781-47bc-934b-06892458b603',
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
    '0142d6ba-ffcd-4c1d-b4a2-1eb82c4ea08c',
    '6f70b361-8781-47bc-934b-06892458b603',
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
    '8d15829e-1249-41df-a232-907f14abcc94',
    '6f70b361-8781-47bc-934b-06892458b603',
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
    'e068bf71-24d8-40e5-8c7d-c5c5043743ca',
    '6f70b361-8781-47bc-934b-06892458b603',
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
    '5199f289-4080-4ee5-963a-3bdb51db9c5b',
    '6f70b361-8781-47bc-934b-06892458b603',
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
    'b28d3f89-f3cd-46d7-ad3f-dc0486254fa3',
    '6f70b361-8781-47bc-934b-06892458b603',
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
    '02f0c4a8-3319-4d05-8f93-a06284a26da6',
    '6f70b361-8781-47bc-934b-06892458b603',
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
    'e9f18721-0d46-49b0-aa10-4679291a4174',
    '6f70b361-8781-47bc-934b-06892458b603',
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
    '6569329b-bf22-4a33-860c-b1f20f8c1d73',
    '6f70b361-8781-47bc-934b-06892458b603',
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
    'fc9004cb-03ef-4d50-bc9e-d536d184a1a3',
    '6f70b361-8781-47bc-934b-06892458b603',
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
    '5df5a555-5bbe-492a-8b7e-f774442d3196',
    '6f70b361-8781-47bc-934b-06892458b603',
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
    '38d28253-b4f0-4bfc-8fd0-ef3ffc2b98bb',
    '6f70b361-8781-47bc-934b-06892458b603',
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
    '911cf39a-3d1a-4f77-9e30-f62bc8751ad6',
    '6f70b361-8781-47bc-934b-06892458b603',
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
    '04a95441-049e-4d69-a88f-bcc095102441',
    '6f70b361-8781-47bc-934b-06892458b603',
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
    '1386df37-f050-4cc6-aa88-2a740a206eb9',
    '6f70b361-8781-47bc-934b-06892458b603',
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
    'e5edf1e4-a3ce-4238-8c3a-faaabcc9ea2b',
    '6f70b361-8781-47bc-934b-06892458b603',
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
    'f79cd2e3-470a-434d-b8e9-5071f37174e7',
    '6f70b361-8781-47bc-934b-06892458b603',
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
    'decedf81-9b6d-4dc0-b0c6-edf152a9f026',
    '6f70b361-8781-47bc-934b-06892458b603',
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
    '2e09596b-0c2b-4475-ad97-33517d644877',
    '6f70b361-8781-47bc-934b-06892458b603',
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
    'a16745f3-80ba-4df0-83cc-fcb534270dba',
    '6f70b361-8781-47bc-934b-06892458b603',
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
    '208714cc-51ff-4abc-a788-e087da9a9318',
    '6f70b361-8781-47bc-934b-06892458b603',
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
    '856f2db8-3907-45c2-bae7-d6b21eca3107',
    '6f70b361-8781-47bc-934b-06892458b603',
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
    '11f075ac-ac95-4607-8da9-b2b7125de5e7',
    '6f70b361-8781-47bc-934b-06892458b603',
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
    '4baa3ab1-fbc3-4332-a174-446a50af3aaa',
    '6f70b361-8781-47bc-934b-06892458b603',
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
    '44fb610c-b74d-4a42-a7b8-affc2bfbfebd',
    '6f70b361-8781-47bc-934b-06892458b603',
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
    '2593d57f-240a-44c9-bef0-d145b34e00f7',
    '6f70b361-8781-47bc-934b-06892458b603',
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
    'dab3bc3a-ecec-48b7-9f4f-f22e9f511ef0',
    '6f70b361-8781-47bc-934b-06892458b603',
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
    '8678d0e3-62cb-4628-b2c0-338b2af444e9',
    '6f70b361-8781-47bc-934b-06892458b603',
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
    '740c86d9-fdd7-4331-b04c-78cc98347551',
    '6f70b361-8781-47bc-934b-06892458b603',
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
    '0f55598e-4702-4417-9aea-54a4439b5d8b',
    '6f70b361-8781-47bc-934b-06892458b603',
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
    '2200a8e5-0525-4309-ab75-28e65fc04df6',
    '6f70b361-8781-47bc-934b-06892458b603',
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
    'bf5152a8-54bd-4cd0-bc41-35b0a4a2eac9',
    '6f70b361-8781-47bc-934b-06892458b603',
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
    '17ad2c86-8fa6-4826-8e95-97344d90ecd4',
    '6f70b361-8781-47bc-934b-06892458b603',
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
    'a958c5e7-7ae4-4946-ab5f-b17e19757cb8',
    '6f70b361-8781-47bc-934b-06892458b603',
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
    'ec4ae827-9817-425f-ad75-b63aff38e792',
    '6f70b361-8781-47bc-934b-06892458b603',
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
    'c0dd9fad-cf24-4367-b1c4-0f04140d60dd',
    '6f70b361-8781-47bc-934b-06892458b603',
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
    'f504e14b-b2ce-4c04-a3f0-52814cd58d93',
    '6f70b361-8781-47bc-934b-06892458b603',
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
    '84894e56-7424-497f-a25d-79e5be5afbed',
    '6f70b361-8781-47bc-934b-06892458b603',
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
    'caaf46e3-c387-4684-abb2-6b766e400950',
    '6f70b361-8781-47bc-934b-06892458b603',
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
    'f442ffdc-aabb-46fe-81f0-ff64327a1cc1',
    '6f70b361-8781-47bc-934b-06892458b603',
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
    '68ade1b6-a960-4c48-8e84-3bca5f6e1847',
    '6f70b361-8781-47bc-934b-06892458b603',
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
    '37633fbe-191f-4817-882b-80f02d11f22d',
    '6f70b361-8781-47bc-934b-06892458b603',
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
    '4448e710-b996-4257-9e1d-6d4c4726138c',
    '6f70b361-8781-47bc-934b-06892458b603',
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
    'fa125892-e391-4fc6-acd9-fa35cc20981f',
    '6f70b361-8781-47bc-934b-06892458b603',
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
    '64f502be-9d5e-409c-a73e-a73cd09e0e55',
    '6f70b361-8781-47bc-934b-06892458b603',
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
    'b3d6853d-4645-4396-9814-beb9a6b7cd4b',
    '6f70b361-8781-47bc-934b-06892458b603',
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
    'fc5d0693-11cf-4370-99f7-fcf5522a5935',
    '6f70b361-8781-47bc-934b-06892458b603',
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
    '761991a1-7657-4866-94d9-af216f12e8f6',
    '6f70b361-8781-47bc-934b-06892458b603',
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
    '516f5eae-1894-4660-9477-cc4e4c24df3e',
    '6f70b361-8781-47bc-934b-06892458b603',
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
    '5f689511-3a68-475d-83cb-ebe4e9840b04',
    '6f70b361-8781-47bc-934b-06892458b603',
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
    '71c1e257-73af-48d4-9d8b-dbe60e25da8f',
    '6f70b361-8781-47bc-934b-06892458b603',
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
    '7d1a09f3-db05-4679-8e47-fe8fc4add508',
    '6f70b361-8781-47bc-934b-06892458b603',
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
    '5687e6b1-92dd-4d5a-835e-c2c63e0638c9',
    '6f70b361-8781-47bc-934b-06892458b603',
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
    '010e89e0-9055-41fc-8188-87c9db786f47',
    '6f70b361-8781-47bc-934b-06892458b603',
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
    '02a9f323-3436-445a-88d4-a8cd749f76fc',
    '6f70b361-8781-47bc-934b-06892458b603',
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
    'f3e63d3c-4ccc-40c6-9dc5-e841cb96dd58',
    '6f70b361-8781-47bc-934b-06892458b603',
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
    '3a6094c5-c1c7-4b13-9b84-c2ce53b19ea3',
    '6f70b361-8781-47bc-934b-06892458b603',
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
    '7ddb660d-d3d4-4b47-8fe4-8cd1339a2784',
    '6f70b361-8781-47bc-934b-06892458b603',
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
    '5185b24c-8aea-423b-96aa-91247b958f37',
    '6f70b361-8781-47bc-934b-06892458b603',
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
    'bf282421-e501-4ea3-b95f-95327d33a03d',
    '6f70b361-8781-47bc-934b-06892458b603',
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
    '9d1cdc03-5c11-4c7e-9e9c-bfeb1f0dbc85',
    '6f70b361-8781-47bc-934b-06892458b603',
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
    '139f391f-4da3-4117-a984-8ee2df420d2f',
    '6f70b361-8781-47bc-934b-06892458b603',
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
    'f5167264-1add-4814-b74b-7b8cd425fc67',
    '6f70b361-8781-47bc-934b-06892458b603',
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
    '3844d32b-e709-4eb0-a4d9-92cc836aced9',
    '6f70b361-8781-47bc-934b-06892458b603',
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
    '86e2fe05-b732-4467-9b69-40b9ef30868b',
    '6f70b361-8781-47bc-934b-06892458b603',
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
    '8e1f33fd-e742-41c0-80dd-ee9670f52de9',
    '6f70b361-8781-47bc-934b-06892458b603',
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
    '8aef0d8f-6f91-406e-873e-3b5cf3c8f640',
    '6f70b361-8781-47bc-934b-06892458b603',
    'boiler_location',
    'utilities',
    'Boiler',
    NULL,
    'Gaskets Very Very',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;
