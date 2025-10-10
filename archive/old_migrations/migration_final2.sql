-- ============================================================
-- PATCHED: BlocIQ Onboarder - Auto-generated Migration (Schema-Corrected)
-- Generated at: 2025-10-09T20:59:16.562821
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
INSERT INTO buildings (id, name, address) VALUES ('731b3369-8d8a-4506-9946-ff45c139e31c', 'Connaught Square', 'CONNAUGHT SQUARE');

-- Insert 1 schedule(s)
INSERT INTO schedules (id, building_id, name, description) VALUES ('843f8f9d-b71b-494b-bb3b-d306cf9e575c', '731b3369-8d8a-4506-9946-ff45c139e31c', 'Main Schedule', 'Auto-detected schedule from onboarding');
-- Created schedules: Main Schedule

-- Insert 8 units
INSERT INTO units (id, building_id, unit_number) VALUES
('9f344bb3-7d0e-40b6-a7f9-eb0f9971a1cf', '731b3369-8d8a-4506-9946-ff45c139e31c', 'Flat 1'),
('2682a39f-f2d8-4926-860c-1619aeb7c4b2', '731b3369-8d8a-4506-9946-ff45c139e31c', 'Flat 2'),
('681287e4-5549-4a5d-bca5-536dae758c86', '731b3369-8d8a-4506-9946-ff45c139e31c', 'Flat 3'),
('eaead1fe-7566-4af0-87cd-029fa7c3264a', '731b3369-8d8a-4506-9946-ff45c139e31c', 'Flat 4'),
('c5587678-da5e-484e-8e19-52a95286ad59', '731b3369-8d8a-4506-9946-ff45c139e31c', 'Flat 5'),
('61a018bb-61a4-46c6-8464-1ba0e811993c', '731b3369-8d8a-4506-9946-ff45c139e31c', 'Flat 6'),
('7f4d1d14-5583-4918-b519-1d27ac2c9a7d', '731b3369-8d8a-4506-9946-ff45c139e31c', 'Flat 7'),
('90b92d06-d6cb-44f5-a02d-6b76446c78e1', '731b3369-8d8a-4506-9946-ff45c139e31c', 'Flat 8')
ON CONFLICT (id) DO NOTHING;

-- Insert 8 leaseholders (schema has building_id and unit_number)
INSERT INTO leaseholders (id, building_id, unit_id, unit_number, name) VALUES
('cf7ece26-af96-4243-9069-09ba2ed26e8a', '731b3369-8d8a-4506-9946-ff45c139e31c', '9f344bb3-7d0e-40b6-a7f9-eb0f9971a1cf', 'Flat 1', 'Marmotte Holdings Limited'),
('e2938192-71ba-4f83-a46a-cd71ca11737b', '731b3369-8d8a-4506-9946-ff45c139e31c', '2682a39f-f2d8-4926-860c-1619aeb7c4b2', 'Flat 2', 'Ms V Rebulla'),
('fef74a4a-aed7-46e8-a683-52c49d4eaa40', '731b3369-8d8a-4506-9946-ff45c139e31c', '681287e4-5549-4a5d-bca5-536dae758c86', 'Flat 3', 'Ms V Rebulla'),
('7cc9afdc-f2c5-4583-a2f8-7709432b8be8', '731b3369-8d8a-4506-9946-ff45c139e31c', 'eaead1fe-7566-4af0-87cd-029fa7c3264a', 'Flat 4', 'Mr P J J Reynish & Ms C A O''Loughlin'),
('07c55e27-41f1-4ddc-882b-cc628f97de2d', '731b3369-8d8a-4506-9946-ff45c139e31c', 'c5587678-da5e-484e-8e19-52a95286ad59', 'Flat 5', 'Mr & Mrs M D Samworth'),
('9ad64b6a-c671-4759-83e7-cc945ee27af9', '731b3369-8d8a-4506-9946-ff45c139e31c', '61a018bb-61a4-46c6-8464-1ba0e811993c', 'Flat 6', 'Mr M D & Mrs C P Samworth'),
('2b5625c1-328d-4ffc-b394-bda6a84fa7dc', '731b3369-8d8a-4506-9946-ff45c139e31c', '7f4d1d14-5583-4918-b519-1d27ac2c9a7d', 'Flat 7', 'Ms J Gomm'),
('f1260d22-c385-4658-8d3a-980317ffdf28', '731b3369-8d8a-4506-9946-ff45c139e31c', '90b92d06-d6cb-44f5-a02d-6b76446c78e1', 'Flat 8', 'Miss T V Samwoth & Miss G E Samworth')
ON CONFLICT (id) DO NOTHING;

-- Insert 56 compliance assets
INSERT INTO compliance_assets (id, building_id, description, asset_name, asset_type, inspection_frequency, last_inspection_date, next_due_date, compliance_status, is_active) VALUES ('8a289f99-566d-4637-a10f-a0f00e363a89', '731b3369-8d8a-4506-9946-ff45c139e31c', 'Extracted from 2024 Directors Meeting-Notes.docx', 'Compliance Asset', 'general', '12 months', '2024-01-01', '2025-01-01', 'overdue', TRUE);
INSERT INTO compliance_assets (id, building_id, description, asset_name, asset_type, inspection_frequency, compliance_status, location, is_active) VALUES ('46f2ba59-b17e-4098-96c6-79b0c6e64de0', '731b3369-8d8a-4506-9946-ff45c139e31c', 'Extracted from Fire Door (Communal) Inspection (11m +) (7).pdf', 'Fire Door Inspection', 'fire_safety', '12 months', 'unknown', 'Communal', TRUE);
INSERT INTO compliance_assets (id, building_id, description, asset_name, asset_type, inspection_frequency, compliance_status, is_active) VALUES ('f3a8b800-b322-409b-b067-a2d79e55c236', '731b3369-8d8a-4506-9946-ff45c139e31c', 'Extracted from Fire Door (Flats) Inspection (11m +) (13).pdf', 'Fire Door Inspection', 'fire_safety', '12 months', 'unknown', TRUE);
INSERT INTO compliance_assets (id, building_id, description, asset_name, asset_type, inspection_frequency, compliance_status, is_active) VALUES ('3d317b7e-634a-417e-ad1b-2a84d9497640', '731b3369-8d8a-4506-9946-ff45c139e31c', 'Extracted from Fire Door (Flats) Inspection (11m +) (18).pdf', 'Fire Door Inspection', 'fire_safety', '12 months', 'unknown', TRUE);
INSERT INTO compliance_assets (id, building_id, description, asset_name, asset_type, inspection_frequency, compliance_status, is_active) VALUES ('94539130-d4f4-40b2-abd3-9ee32996c2d7', '731b3369-8d8a-4506-9946-ff45c139e31c', 'Extracted from Fire Door (Flats) Inspection (11m +) (14).pdf', 'Fire Door Inspection', 'fire_safety', '12 months', 'unknown', TRUE);
INSERT INTO compliance_assets (id, building_id, description, asset_name, asset_type, inspection_frequency, compliance_status, is_active) VALUES ('fe87ca4a-23c5-4089-9fda-e750bca2b76c', '731b3369-8d8a-4506-9946-ff45c139e31c', 'Extracted from EICR Cuanku 32-34 conaught square.pdf', 'Electrical Installation Condition Report (EICR)', 'electrical', '60 months', 'unknown', TRUE);
INSERT INTO compliance_assets (id, building_id, description, asset_name, asset_type, inspection_frequency, compliance_status, is_active) VALUES ('3b01172b-359a-40a1-9cc9-a5e696a30194', '731b3369-8d8a-4506-9946-ff45c139e31c', 'Extracted from Fire Door (Flats) Inspection (11m +) (15).pdf', 'Fire Door Inspection', 'fire_safety', '12 months', 'unknown', TRUE);
INSERT INTO compliance_assets (id, building_id, description, asset_name, asset_type, inspection_frequency, last_inspection_date, next_due_date, compliance_status, is_active) VALUES ('6d77bccf-409b-4402-8bce-1c23ba0c5e5b', '731b3369-8d8a-4506-9946-ff45c139e31c', 'Extracted from 221037_Fra1-L-394697-071223 32-34 Connaught Square_2024-01-02_163759 (1).pdf', 'Fire Risk Assessment (FRA)', 'fire_safety', '12 months', '2024-01-02', '2025-01-02', 'overdue', TRUE);
INSERT INTO compliance_assets (id, building_id, description, asset_name, asset_type, inspection_frequency, compliance_status, is_active) VALUES ('2c28adb2-ab9b-413f-8693-99ebaaaf6a11', '731b3369-8d8a-4506-9946-ff45c139e31c', 'Extracted from Fire Door (Flats) Inspection (11m +) (19).pdf', 'Fire Door Inspection', 'fire_safety', '12 months', 'unknown', TRUE);
INSERT INTO compliance_assets (id, building_id, description, asset_name, asset_type, inspection_frequency, compliance_status, is_active) VALUES ('f7eaa015-e4be-488a-8fdd-1bfb75e2c23d', '731b3369-8d8a-4506-9946-ff45c139e31c', 'Extracted from 001132-3234-Connaught-Square-London.pdf', 'Compliance Asset', 'general', '12 months', 'unknown', TRUE);
INSERT INTO compliance_assets (id, building_id, description, asset_name, asset_type, inspection_frequency, last_inspection_date, next_due_date, compliance_status, is_active) VALUES ('13d8222d-f3ce-4a8f-adad-afd76aba37eb', '731b3369-8d8a-4506-9946-ff45c139e31c', 'Extracted from 221038_Hsra1-L-394697-071223 32-34 Connaught Square_2024-01-02_163759 (1).pdf', 'Compliance Asset', 'general', '12 months', '2024-01-02', '2025-01-02', 'overdue', TRUE);
INSERT INTO compliance_assets (id, building_id, description, asset_name, asset_type, inspection_frequency, compliance_status, is_active) VALUES ('5c9fd31b-a32b-4be3-865f-ebf43d83ad20', '731b3369-8d8a-4506-9946-ff45c139e31c', 'Extracted from TETRA - Asbestos Re-Inspection Survey 14.06.22.pdf', 'Compliance Asset', 'general', '12 months', 'unknown', TRUE);
INSERT INTO compliance_assets (id, building_id, description, asset_name, asset_type, inspection_frequency, compliance_status, is_active) VALUES ('3b260d59-2095-47f1-9254-3e654b30877a', '731b3369-8d8a-4506-9946-ff45c139e31c', 'Extracted from Fire Door (Flats) Inspection (11m +) (16).pdf', 'Fire Door Inspection', 'fire_safety', '12 months', 'unknown', TRUE);
INSERT INTO compliance_assets (id, building_id, description, asset_name, asset_type, inspection_frequency, compliance_status, is_active) VALUES ('e23018c1-7c63-4ca5-9dbd-65c4d5b97698', '731b3369-8d8a-4506-9946-ff45c139e31c', 'Extracted from Fire Door (Flats) Inspection (11m +) (17).pdf', 'Fire Door Inspection', 'fire_safety', '12 months', 'unknown', TRUE);
INSERT INTO compliance_assets (id, building_id, description, asset_name, asset_type, inspection_frequency, compliance_status, is_active) VALUES ('29fc7cdf-3f94-4dd5-a7da-6fee69023e2a', '731b3369-8d8a-4506-9946-ff45c139e31c', 'Extracted from WHM Legionella Risk Assessment 07.06.22.pdf', 'Legionella Risk Assessment', 'water_safety', '24 months', 'unknown', TRUE);
INSERT INTO compliance_assets (id, building_id, description, asset_name, asset_type, inspection_frequency, last_inspection_date, next_due_date, compliance_status, is_active) VALUES ('65bb0e12-0931-4c18-bba7-97071fd83ed9', '731b3369-8d8a-4506-9946-ff45c139e31c', 'Extracted from EICR Report Cunaku SATISFACTORY 2023 .pdf', 'Electrical Installation Condition Report (EICR)', 'electrical', '60 months', '2023-01-01', '2028-01-01', 'compliant', TRUE);
INSERT INTO compliance_assets (id, building_id, description, asset_name, asset_type, inspection_frequency, last_inspection_date, next_due_date, compliance_status, is_active) VALUES ('34be755e-00f2-4273-a4d6-9ec74f7ca1ac', '731b3369-8d8a-4506-9946-ff45c139e31c', 'Extracted from 2024 Directors Meeting-Notes.docx', 'Compliance Asset', 'general', '12 months', '2024-01-01', '2025-01-01', 'overdue', TRUE);
INSERT INTO compliance_assets (id, building_id, description, asset_name, asset_type, inspection_frequency, compliance_status, is_active) VALUES ('6cc75012-8680-4b50-a57c-7db393efb7a4', '731b3369-8d8a-4506-9946-ff45c139e31c', 'Extracted from 001457-3234-Connaught-Square-London Certificate.pdf', 'Compliance Asset', 'general', '12 months', 'unknown', TRUE);
INSERT INTO compliance_assets (id, building_id, description, asset_name, asset_type, inspection_frequency, compliance_status, is_active) VALUES ('d08ee821-4f9f-463d-8b09-2454aa33485f', '731b3369-8d8a-4506-9946-ff45c139e31c', 'Extracted from TC0001V31 General Terms and Conditions.pdf', 'Compliance Asset', 'general', '12 months', 'unknown', TRUE);
INSERT INTO compliance_assets (id, building_id, description, asset_name, asset_type, inspection_frequency, last_inspection_date, next_due_date, compliance_status, is_active) VALUES ('d2df565d-0a1a-4492-8213-492ac417864a', '731b3369-8d8a-4506-9946-ff45c139e31c', 'Extracted from Jobcard_For_Job_No_28992_24-01-2025_1545.pdf', 'Compliance Asset', 'general', '12 months', '2025-01-24', '2026-01-24', 'compliant', TRUE);
INSERT INTO compliance_assets (id, building_id, description, asset_name, asset_type, inspection_frequency, compliance_status, is_active) VALUES ('311e341a-904d-41b4-b1e9-afbf2adebe0f', '731b3369-8d8a-4506-9946-ff45c139e31c', 'Extracted from Connaught Square (32-34) - 09.12.24 LRA.pdf', 'Compliance Asset', 'general', '12 months', 'unknown', TRUE);
INSERT INTO compliance_assets (id, building_id, description, asset_name, asset_type, inspection_frequency, compliance_status, is_active) VALUES ('10913139-2300-429e-8f41-86df1ab5b434', '731b3369-8d8a-4506-9946-ff45c139e31c', 'Extracted from SC Certificate - 10072023.pdf', 'Compliance Asset', 'general', '12 months', 'unknown', TRUE);
INSERT INTO compliance_assets (id, building_id, description, asset_name, asset_type, inspection_frequency, compliance_status, location, is_active) VALUES ('7f8223d0-a4bd-4f79-a474-2090b1241d1b', '731b3369-8d8a-4506-9946-ff45c139e31c', 'Extracted from Fire Door (Communal) Inspection (11m +) (7).pdf', 'Fire Door Inspection', 'fire_safety', '12 months', 'unknown', 'Communal', TRUE);
INSERT INTO compliance_assets (id, building_id, description, asset_name, asset_type, inspection_frequency, compliance_status, is_active) VALUES ('94833c40-0158-4416-bd70-21c61e28f5a7', '731b3369-8d8a-4506-9946-ff45c139e31c', 'Extracted from Fire Door (Flats) Inspection (11m +) (13).pdf', 'Fire Door Inspection', 'fire_safety', '12 months', 'unknown', TRUE);
INSERT INTO compliance_assets (id, building_id, description, asset_name, asset_type, inspection_frequency, compliance_status, is_active) VALUES ('91031d82-380d-4e19-8361-aee5bc289b7b', '731b3369-8d8a-4506-9946-ff45c139e31c', 'Extracted from Fire Door (Flats) Inspection (11m +) (18).pdf', 'Fire Door Inspection', 'fire_safety', '12 months', 'unknown', TRUE);
INSERT INTO compliance_assets (id, building_id, description, asset_name, asset_type, inspection_frequency, compliance_status, is_active) VALUES ('8d61cf5d-905f-4a3c-9c82-da375a71287f', '731b3369-8d8a-4506-9946-ff45c139e31c', 'Extracted from Fire Door (Flats) Inspection (11m +) (14).pdf', 'Fire Door Inspection', 'fire_safety', '12 months', 'unknown', TRUE);
INSERT INTO compliance_assets (id, building_id, description, asset_name, asset_type, inspection_frequency, compliance_status, is_active) VALUES ('c6b3da70-f22b-4697-8b9d-1e6ff7723059', '731b3369-8d8a-4506-9946-ff45c139e31c', 'Extracted from Fire Door (Flats) Inspection (11m +) (15).pdf', 'Fire Door Inspection', 'fire_safety', '12 months', 'unknown', TRUE);
INSERT INTO compliance_assets (id, building_id, description, asset_name, asset_type, inspection_frequency, compliance_status, is_active) VALUES ('6137322d-7f0d-4f57-9e16-99f405904c03', '731b3369-8d8a-4506-9946-ff45c139e31c', 'Extracted from Fire Door (Flats) Inspection (11m +) (19).pdf', 'Fire Door Inspection', 'fire_safety', '12 months', 'unknown', TRUE);
INSERT INTO compliance_assets (id, building_id, description, asset_name, asset_type, inspection_frequency, compliance_status, is_active) VALUES ('317426ed-3452-4222-9a1b-5b0558f5e098', '731b3369-8d8a-4506-9946-ff45c139e31c', 'Extracted from Fire Door (Flats) Inspection (11m +) (16).pdf', 'Fire Door Inspection', 'fire_safety', '12 months', 'unknown', TRUE);
INSERT INTO compliance_assets (id, building_id, description, asset_name, asset_type, inspection_frequency, compliance_status, is_active) VALUES ('24e5971d-db46-44dc-b58c-3949ef967862', '731b3369-8d8a-4506-9946-ff45c139e31c', 'Extracted from Fire Door (Flats) Inspection (11m +) (17).pdf', 'Fire Door Inspection', 'fire_safety', '12 months', 'unknown', TRUE);
INSERT INTO compliance_assets (id, building_id, description, asset_name, asset_type, inspection_frequency, last_inspection_date, next_due_date, compliance_status, is_active) VALUES ('b28fa0a4-c3ec-4d41-bdb3-8fadbef18228', '731b3369-8d8a-4506-9946-ff45c139e31c', 'Extracted from 221037_Fra1-L-394697-071223 32-34 Connaught Square_2024-01-02_163759.pdf', 'Fire Risk Assessment (FRA)', 'fire_safety', '12 months', '2024-01-02', '2025-01-02', 'overdue', TRUE);
INSERT INTO compliance_assets (id, building_id, description, asset_name, asset_type, inspection_frequency, last_inspection_date, next_due_date, compliance_status, is_active) VALUES ('3ac48ec2-6b8d-4f92-b23e-8f77fcd65c07', '731b3369-8d8a-4506-9946-ff45c139e31c', 'Extracted from Fire Door (Flats) Inspection (11m +) - 2024-01-24T120747.552.pdf', 'Fire Door Inspection', 'fire_safety', '12 months', '2024-01-24', '2025-01-24', 'overdue', TRUE);
INSERT INTO compliance_assets (id, building_id, description, asset_name, asset_type, inspection_frequency, compliance_status, is_active) VALUES ('954340b8-3f02-41ce-aa0a-9929700a201f', '731b3369-8d8a-4506-9946-ff45c139e31c', 'Extracted from Connaught Square (32-34) - 15.11.23 (886) wa.pdf', 'Compliance Asset', 'general', '12 months', 'unknown', TRUE);
INSERT INTO compliance_assets (id, building_id, description, asset_name, asset_type, inspection_frequency, last_inspection_date, next_due_date, compliance_status, is_active) VALUES ('de954b38-539b-4917-8751-ea0385d65b1a', '731b3369-8d8a-4506-9946-ff45c139e31c', 'Extracted from Fire Door (Flats) Inspection (11m +) - 2024-01-24T120745.875.pdf', 'Fire Door Inspection', 'fire_safety', '12 months', '2024-01-24', '2025-01-24', 'overdue', TRUE);
INSERT INTO compliance_assets (id, building_id, description, asset_name, asset_type, inspection_frequency, last_inspection_date, next_due_date, compliance_status, is_active) VALUES ('2db09201-f626-4233-8596-4f63eda82151', '731b3369-8d8a-4506-9946-ff45c139e31c', 'Extracted from Fire Door (Flats) Inspection (11m +) - 2024-01-24T120746.424.pdf', 'Fire Door Inspection', 'fire_safety', '12 months', '2024-01-24', '2025-01-24', 'overdue', TRUE);
INSERT INTO compliance_assets (id, building_id, description, asset_name, asset_type, inspection_frequency, last_inspection_date, next_due_date, compliance_status, location, is_active) VALUES ('d016f5ec-03e7-4b56-bee6-cea282758455', '731b3369-8d8a-4506-9946-ff45c139e31c', 'Extracted from Fire Door (Communal) Inspection (11m +) - 2024-01-24T120743.986.pdf', 'Fire Door Inspection', 'fire_safety', '12 months', '2024-01-24', '2025-01-24', 'overdue', 'Communal', TRUE);
INSERT INTO compliance_assets (id, building_id, description, asset_name, asset_type, inspection_frequency, last_inspection_date, next_due_date, compliance_status, is_active) VALUES ('63a31ce8-dd87-4275-8206-14135951782f', '731b3369-8d8a-4506-9946-ff45c139e31c', 'Extracted from Fire Door (Flats) Inspection (11m +) - 2024-01-24T120744.738.pdf', 'Fire Door Inspection', 'fire_safety', '12 months', '2024-01-24', '2025-01-24', 'overdue', TRUE);
INSERT INTO compliance_assets (id, building_id, description, asset_name, asset_type, inspection_frequency, last_inspection_date, next_due_date, compliance_status, is_active) VALUES ('71123f5a-318a-4cf1-9bb5-7edf2aa3d3bf', '731b3369-8d8a-4506-9946-ff45c139e31c', 'Extracted from Fire Door (Flats) Inspection (11m +) - 2024-01-24T120747.015.pdf', 'Fire Door Inspection', 'fire_safety', '12 months', '2024-01-24', '2025-01-24', 'overdue', TRUE);
INSERT INTO compliance_assets (id, building_id, description, asset_name, asset_type, inspection_frequency, last_inspection_date, next_due_date, compliance_status, is_active) VALUES ('5525eb6a-a2e1-4d63-8c4a-6f2072684380', '731b3369-8d8a-4506-9946-ff45c139e31c', 'Extracted from 221038_Hsra1-L-394697-071223 32-34 Connaught Square_2024-01-02_163759.pdf', 'Compliance Asset', 'general', '12 months', '2024-01-02', '2025-01-02', 'overdue', TRUE);
INSERT INTO compliance_assets (id, building_id, description, asset_name, asset_type, inspection_frequency, last_inspection_date, next_due_date, compliance_status, is_active) VALUES ('db68580d-61de-4c4d-aabb-60966771a44e', '731b3369-8d8a-4506-9946-ff45c139e31c', 'Extracted from Fire Door (Flats) Inspection (11m +) - 2024-01-24T120745.174.pdf', 'Fire Door Inspection', 'fire_safety', '12 months', '2024-01-24', '2025-01-24', 'overdue', TRUE);
INSERT INTO compliance_assets (id, building_id, description, asset_name, asset_type, inspection_frequency, compliance_status, is_active) VALUES ('24247741-b915-492b-85c5-a2caf3212cf5', '731b3369-8d8a-4506-9946-ff45c139e31c', 'Extracted from Hsfra1-L-422971-210225 32-34 Connaught Square.pdf', 'Fire Risk Assessment (FRA)', 'fire_safety', '12 months', 'unknown', TRUE);
INSERT INTO compliance_assets (id, building_id, description, asset_name, asset_type, inspection_frequency, compliance_status, is_active) VALUES ('fcefe9ca-b29f-4d3f-b7b5-9b3ac027b686', '731b3369-8d8a-4506-9946-ff45c139e31c', 'Extracted from Hsfra1-L-422971-210225 32-34 Connaught Square.docx', 'Fire Risk Assessment (FRA)', 'fire_safety', '12 months', 'unknown', TRUE);
INSERT INTO compliance_assets (id, building_id, description, asset_name, asset_type, inspection_frequency, last_inspection_date, next_due_date, compliance_status, is_active) VALUES ('0734986a-0a04-45d2-9082-01e7ccaebba1', '731b3369-8d8a-4506-9946-ff45c139e31c', 'Extracted from 221037_Fra1-L-394697-071223 32-34 Connaught Square_2024-01-02_163759 (1).pdf', 'Fire Risk Assessment (FRA)', 'fire_safety', '12 months', '2024-01-02', '2025-01-02', 'overdue', TRUE);
INSERT INTO compliance_assets (id, building_id, description, asset_name, asset_type, inspection_frequency, last_inspection_date, next_due_date, compliance_status, is_active) VALUES ('4c0a28af-4a76-4374-bb3c-47dc1c2f93af', '731b3369-8d8a-4506-9946-ff45c139e31c', 'Extracted from 221038_Hsra1-L-394697-071223 32-34 Connaught Square_2024-01-02_163759 (1).pdf', 'Compliance Asset', 'general', '12 months', '2024-01-02', '2025-01-02', 'overdue', TRUE);
INSERT INTO compliance_assets (id, building_id, description, asset_name, asset_type, inspection_frequency, compliance_status, is_active) VALUES ('90622934-3503-4a30-a799-3b4b75ba1d90', '731b3369-8d8a-4506-9946-ff45c139e31c', 'Extracted from FRA-Connaught Square Reccommendations.xlsx', 'Fire Risk Assessment (FRA)', 'fire_safety', '12 months', 'unknown', TRUE);
INSERT INTO compliance_assets (id, building_id, description, asset_name, asset_type, inspection_frequency, compliance_status, is_active) VALUES ('6c3eb7ca-4994-4329-bc60-a86312ad4ce4', '731b3369-8d8a-4506-9946-ff45c139e31c', 'Extracted from 001534-3234-Connaught-Square-London.pdf', 'Compliance Asset', 'general', '12 months', 'unknown', TRUE);
INSERT INTO compliance_assets (id, building_id, description, asset_name, asset_type, inspection_frequency, compliance_status, is_active) VALUES ('495e796e-af99-4375-b2c6-0d4edffdcb85', '731b3369-8d8a-4506-9946-ff45c139e31c', 'Extracted from C1047 - Job card.pdf', 'Compliance Asset', 'general', '12 months', 'unknown', TRUE);
INSERT INTO compliance_assets (id, building_id, description, asset_name, asset_type, inspection_frequency, compliance_status, is_active) VALUES ('1eca6d34-6cea-4a01-ac8b-5c7a5db96880', '731b3369-8d8a-4506-9946-ff45c139e31c', 'Extracted from WHM Legionella Risk Assessment 09.12.25.pdf', 'Legionella Risk Assessment', 'water_safety', '24 months', 'unknown', TRUE);
INSERT INTO compliance_assets (id, building_id, description, asset_name, asset_type, inspection_frequency, compliance_status, is_active) VALUES ('bbad4fa4-c0cc-4333-b6eb-0f250e64fd18', '731b3369-8d8a-4506-9946-ff45c139e31c', 'Extracted from WHM Legionella Risk Assessment 07.06.22.pdf', 'Legionella Risk Assessment', 'water_safety', '24 months', 'unknown', TRUE);
INSERT INTO compliance_assets (id, building_id, description, asset_name, asset_type, inspection_frequency, compliance_status, is_active) VALUES ('daa08812-5823-44f8-9aa4-56aa3a3abd10', '731b3369-8d8a-4506-9946-ff45c139e31c', 'Extracted from Connaught Square (32-34) - 29.05.25 (201) wa.pdf', 'Compliance Asset', 'general', '12 months', 'unknown', TRUE);
INSERT INTO compliance_assets (id, building_id, description, asset_name, asset_type, inspection_frequency, compliance_status, is_active) VALUES ('01b25a24-c31f-41f6-8d29-8b67033a702b', '731b3369-8d8a-4506-9946-ff45c139e31c', 'Extracted from EICR Cuanku 32-34 conaught square.pdf', 'Electrical Installation Condition Report (EICR)', 'electrical', '60 months', 'unknown', TRUE);
INSERT INTO compliance_assets (id, building_id, description, asset_name, asset_type, inspection_frequency, last_inspection_date, next_due_date, compliance_status, is_active) VALUES ('3e4c8e52-d50e-46ca-925e-c409b95ba550', '731b3369-8d8a-4506-9946-ff45c139e31c', 'Extracted from EICR Report Cunaku SATISFACTORY 2023 .pdf', 'Electrical Installation Condition Report (EICR)', 'electrical', '60 months', '2023-01-01', '2028-01-01', 'compliant', TRUE);
INSERT INTO compliance_assets (id, building_id, description, asset_name, asset_type, inspection_frequency, compliance_status, is_active) VALUES ('c6df2991-9947-4a07-8c43-01b883b228e8', '731b3369-8d8a-4506-9946-ff45c139e31c', 'Extracted from 001132-3234-Connaught-Square-London.pdf', 'Compliance Asset', 'general', '12 months', 'unknown', TRUE);
INSERT INTO compliance_assets (id, building_id, description, asset_name, asset_type, inspection_frequency, compliance_status, is_active) VALUES ('e3194502-7d4b-435e-9e23-7a2a61830550', '731b3369-8d8a-4506-9946-ff45c139e31c', 'Extracted from 001534-3234-Connaught-Square-London.pdf', 'Compliance Asset', 'general', '12 months', 'unknown', TRUE);
INSERT INTO compliance_assets (id, building_id, description, asset_name, asset_type, inspection_frequency, compliance_status, is_active) VALUES ('981a215d-9371-4ab9-a565-41940552055b', '731b3369-8d8a-4506-9946-ff45c139e31c', 'Extracted from FINAL L-432900 32-34 Connaught Square Management Survey Report Issue 1.pdf', 'Compliance Asset', 'general', '12 months', 'unknown', TRUE);
INSERT INTO compliance_assets (id, building_id, description, asset_name, asset_type, inspection_frequency, compliance_status, is_active) VALUES ('a6ad3af5-acc5-40bd-883b-54a026e52061', '731b3369-8d8a-4506-9946-ff45c139e31c', 'Extracted from TETRA - Asbestos Re-Inspection Survey 14.06.22.pdf', 'Compliance Asset', 'general', '12 months', 'unknown', TRUE);

-- Insert 4 major works projects
INSERT INTO major_works_projects (id, building_id, name, status, start_date) VALUES ('79844a2a-f245-4b5a-921b-2bc0c234b2dc', '731b3369-8d8a-4506-9946-ff45c139e31c', 'External Decoration - 2025', 'planning', '2025-01-01');
INSERT INTO major_works_projects (id, building_id, name, status, start_date) VALUES ('c7cb646e-72dd-4b8c-a92d-ad045fff0461', '731b3369-8d8a-4506-9946-ff45c139e31c', 'Section 20 Consultation (SOE) - 2025', 'planning', '2025-01-01');
INSERT INTO major_works_projects (id, building_id, name, status, start_date) VALUES ('485843a3-050e-4a75-a927-4a962d62d84b', '731b3369-8d8a-4506-9946-ff45c139e31c', 'Lift - Section 20 (NOI) - 2025', 'planning', '2025-01-01');
INSERT INTO major_works_projects (id, building_id, name, status, start_date) VALUES ('b20cd007-369e-4420-938d-373b9fbf22f8', '731b3369-8d8a-4506-9946-ff45c139e31c', 'Major Works Project - 2025', 'planning', '2025-01-01');

-- Insert 22 budgets
INSERT INTO budgets (id, building_id, year_start, year_end, period) VALUES ('591961ad-6743-4626-9241-66fe5f37e93e', '731b3369-8d8a-4506-9946-ff45c139e31c', '2025-04-01', '2026-03-31', '2025');
INSERT INTO budgets (id, building_id, year_start, year_end, period) VALUES ('99679ac5-09ff-42e3-87fa-b880faf33baa', '731b3369-8d8a-4506-9946-ff45c139e31c', '2025-04-01', '2026-03-31', '2025');
INSERT INTO budgets (id, building_id, year_start, year_end, period) VALUES ('78cddc95-6211-4b13-bb17-1ef99a824a89', '731b3369-8d8a-4506-9946-ff45c139e31c', '2025-04-01', '2026-03-31', '2025');
INSERT INTO budgets (id, building_id, year_start, year_end, period) VALUES ('6c7796c2-0737-4d09-a182-e10bf11acb09', '731b3369-8d8a-4506-9946-ff45c139e31c', '2025-04-01', '2026-03-31', '2025');
INSERT INTO budgets (id, building_id, year_start, year_end, period) VALUES ('fa1ffde3-1c0d-49e0-9720-785fc32d5bc4', '731b3369-8d8a-4506-9946-ff45c139e31c', '2025-04-01', '2026-03-31', '2025');
INSERT INTO budgets (id, building_id, year_start, year_end, period) VALUES ('207a46fc-4ab1-49cc-bd1d-7443c6f81795', '731b3369-8d8a-4506-9946-ff45c139e31c', '2025-04-01', '2026-03-31', '2025');
INSERT INTO budgets (id, building_id, year_start, year_end, period) VALUES ('594eaf39-fd3e-4ed0-9275-79b33e29b2e8', '731b3369-8d8a-4506-9946-ff45c139e31c', '2025-04-01', '2026-03-31', '2025');
INSERT INTO budgets (id, building_id, year_start, year_end, period) VALUES ('56fe78be-d47a-4c85-9153-964fbdd1a2e0', '731b3369-8d8a-4506-9946-ff45c139e31c', '2025-04-01', '2026-03-31', '2025');
INSERT INTO budgets (id, building_id, year_start, year_end, period) VALUES ('1865322d-3576-48df-a368-26a987a935d5', '731b3369-8d8a-4506-9946-ff45c139e31c', '2025-04-01', '2026-03-31', '2025');
INSERT INTO budgets (id, building_id, year_start, year_end, period) VALUES ('ceac3b57-0ee7-41bf-b2e6-4cfae216431a', '731b3369-8d8a-4506-9946-ff45c139e31c', '2025-04-01', '2026-03-31', '2025');
INSERT INTO budgets (id, building_id, year_start, year_end, period) VALUES ('1f61582b-be25-46ed-9059-4f304481c39f', '731b3369-8d8a-4506-9946-ff45c139e31c', '2025-04-01', '2026-03-31', '2025');
INSERT INTO budgets (id, building_id, year_start, year_end, period) VALUES ('254d42fb-f9b8-4686-aa84-d834505c5949', '731b3369-8d8a-4506-9946-ff45c139e31c', '2025-04-01', '2026-03-31', '2025');
INSERT INTO budgets (id, building_id, year_start, year_end, period) VALUES ('7f17e3d1-d4f8-46c5-bd2a-26dff9f8f549', '731b3369-8d8a-4506-9946-ff45c139e31c', '2025-04-01', '2026-03-31', '2025');
INSERT INTO budgets (id, building_id, year_start, year_end, period) VALUES ('de431530-c8ae-44d5-8fe2-b2dfd0545dfd', '731b3369-8d8a-4506-9946-ff45c139e31c', '2025-04-01', '2026-03-31', '2025');
INSERT INTO budgets (id, building_id, year_start, year_end, period) VALUES ('f1645cc4-7ae7-488a-be28-053a0992fe1d', '731b3369-8d8a-4506-9946-ff45c139e31c', '2025-04-01', '2026-03-31', '2025');
INSERT INTO budgets (id, building_id, year_start, year_end, period) VALUES ('f63c9e66-fc3e-46bc-9db4-0a053b5d8baf', '731b3369-8d8a-4506-9946-ff45c139e31c', '2025-04-01', '2026-03-31', '2025');
INSERT INTO budgets (id, building_id, year_start, year_end, period) VALUES ('8224527e-c827-4a12-8357-5254e57e473a', '731b3369-8d8a-4506-9946-ff45c139e31c', '2025-04-01', '2026-03-31', '2025');
INSERT INTO budgets (id, building_id, year_start, year_end, period) VALUES ('817611d8-c19f-45a9-b7e9-c110127518f3', '731b3369-8d8a-4506-9946-ff45c139e31c', '2025-04-01', '2026-03-31', '2025');
INSERT INTO budgets (id, building_id, year_start, year_end, period) VALUES ('98c940fc-f2ea-46eb-8789-a69f721c328b', '731b3369-8d8a-4506-9946-ff45c139e31c', '2025-04-01', '2026-03-31', '2025');
INSERT INTO budgets (id, building_id, year_start, year_end, period) VALUES ('a6dd849b-acb9-4068-a2e6-9b76ada7774a', '731b3369-8d8a-4506-9946-ff45c139e31c', '2025-04-01', '2026-03-31', '2025');
INSERT INTO budgets (id, building_id, year_start, year_end, period) VALUES ('2ca18d5b-605c-4fd1-b28b-118e5698694d', '731b3369-8d8a-4506-9946-ff45c139e31c', '2025-04-01', '2026-03-31', '2025');
INSERT INTO budgets (id, building_id, year_start, year_end, period) VALUES ('b5de7a39-5b60-498e-9869-8ee5d76e15b5', '731b3369-8d8a-4506-9946-ff45c139e31c', '2025-04-01', '2026-03-31', '2025');

-- Insert 318 document records
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('b1b74dae-62c7-4ba0-b98a-0c41cc6c5bc7', '731b3369-8d8a-4506-9946-ff45c139e31c', 'leases', 'Important Information .pdf', 'lease/Important Information .pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('14494f91-4728-44a9-9876-9f93a6122aba', '731b3369-8d8a-4506-9946-ff45c139e31c', 'other', 'ACCOUNTS - YE 31.03.21 - Service Charge Accounts (1).pdf', 'finance/ACCOUNTS - YE 31.03.21 - Service Charge Accounts (1).pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('58325903-2c36-4a3f-a923-611e2e6ffc07', '731b3369-8d8a-4506-9946-ff45c139e31c', 'leases', 'Official Copy (Lease) 04.08.2022 - NGL809841 (1).pdf', 'lease/Official Copy (Lease) 04.08.2022 - NGL809841 (1).pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('b57398b2-3477-48e0-9f94-d1156aceac8f', '731b3369-8d8a-4506-9946-ff45c139e31c', 'leases', 'Official Copy (Lease) 04.08.2022 - NGL809841 (2).pdf', 'lease/Official Copy (Lease) 04.08.2022 - NGL809841 (2).pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('07572465-376b-4329-84b7-1d2265943390', '731b3369-8d8a-4506-9946-ff45c139e31c', 'leases', 'Official Copy (Lease) 13.06.2003 - NGL827422.pdf', 'lease/Official Copy (Lease) 13.06.2003 - NGL827422.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('1c2f3cb3-7388-4a2c-9cfc-bec9fee4dc84', '731b3369-8d8a-4506-9946-ff45c139e31c', 'leases', 'Official Copy (Lease) 04.08.2022 - NGL809841.pdf', 'lease/Official Copy (Lease) 04.08.2022 - NGL809841.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('de223320-f3d0-468d-9167-088694cd263f', '731b3369-8d8a-4506-9946-ff45c139e31c', 'leases', 'Signed April 2025 Arrears Collection Procedure.pdf', 'lease/Signed April 2025 Arrears Collection Procedure.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('f735355a-4537-4a45-bf7d-180e3177ecea', '731b3369-8d8a-4506-9946-ff45c139e31c', 'leases', 'WP0005V17 Welcome Pack.pdf', 'lease/WP0005V17 Welcome Pack.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('ce6e0bff-b344-4a48-9a0a-835c82a10faf', '731b3369-8d8a-4506-9946-ff45c139e31c', 'leases', 'Jobcard_For_Job_No_33844_07-04-2025_1143.pdf', 'lease/Jobcard_For_Job_No_33844_07-04-2025_1143.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('ab9b8fa0-353e-48b6-bf8b-3ab2806000c1', '731b3369-8d8a-4506-9946-ff45c139e31c', 'leases', 'Jobcard_For_Job_No_37675_25-07-2025_1549.pdf', 'lease/Jobcard_For_Job_No_37675_25-07-2025_1549.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('696a34f1-eadc-41ab-a753-6b8bb6d0f600', '731b3369-8d8a-4506-9946-ff45c139e31c', 'leases', 'Jobcard_For_Job_No_34012_01-05-2025_1616.pdf', 'lease/Jobcard_For_Job_No_34012_01-05-2025_1616.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('d5febc6f-ad53-4f3d-859c-8db892d03d29', '731b3369-8d8a-4506-9946-ff45c139e31c', 'leases', 'Jobcard_For_Job_No_32759_17-03-2025_1145.pdf', 'lease/Jobcard_For_Job_No_32759_17-03-2025_1145.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('4aa648db-a2a0-4bc9-9e1a-660430006457', '731b3369-8d8a-4506-9946-ff45c139e31c', 'leases', 'Jobcard_For_Job_No_32810_17-03-2025_1311.pdf', 'lease/Jobcard_For_Job_No_32810_17-03-2025_1311.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('04afd5a8-125e-4714-845a-78302ea4ba73', '731b3369-8d8a-4506-9946-ff45c139e31c', 'other', 'Quote_No_23550 - Connaught Square (32-34) 2023-2024.pdf', 'contracts/Quote_No_23550 - Connaught Square (32-34) 2023-2024.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('db8e4417-92ea-4c4e-84e2-443530ae7434', '731b3369-8d8a-4506-9946-ff45c139e31c', 'leases', 'Licence_Document_352024.pdf', 'lease/Licence_Document_352024.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('330bccfa-5e3f-4956-8391-0d738a2bb11d', '731b3369-8d8a-4506-9946-ff45c139e31c', 'leases', 'JLGServiceVisit-M00813-12-09-2024.pdf', 'lease/JLGServiceVisit-M00813-12-09-2024.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('325615d3-286a-4f4f-a8e2-e4942d3394a4', '731b3369-8d8a-4506-9946-ff45c139e31c', 'leases', 'JLGServiceVisit-M00813-13-11-2024.pdf', 'lease/JLGServiceVisit-M00813-13-11-2024.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('abb56e5d-593c-4828-8b59-ac5355328591', '731b3369-8d8a-4506-9946-ff45c139e31c', 'leases', 'JLGServiceVisit-M00813-02-12-2024.pdf', 'lease/JLGServiceVisit-M00813-02-12-2024.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('8f7b074d-51f1-4425-be60-f72ed3f8f850', '731b3369-8d8a-4506-9946-ff45c139e31c', 'leases', 'JLGServiceVisit-M00813-08-07-2024.pdf', 'lease/JLGServiceVisit-M00813-08-07-2024.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('4d1e5237-6d15-4868-9178-887b3a7eff8f', '731b3369-8d8a-4506-9946-ff45c139e31c', 'leases', 'JLGServiceVisit-M00813-08-10-2024.pdf', 'lease/JLGServiceVisit-M00813-08-10-2024.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('8c51ad3a-01e6-4625-afb5-d4bc2d52821f', '731b3369-8d8a-4506-9946-ff45c139e31c', 'leases', 'JLGServiceVisit-M00813-12-02-2025.pdf', 'lease/JLGServiceVisit-M00813-12-02-2025.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('ba35e5b6-6ef9-4d0c-af28-088d4e4411a7', '731b3369-8d8a-4506-9946-ff45c139e31c', 'leases', 'JLGServiceVisit-M00813-17-03-2025.pdf', 'lease/JLGServiceVisit-M00813-17-03-2025.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('6f488515-1487-4487-aa38-5dbce77fe83b', '731b3369-8d8a-4506-9946-ff45c139e31c', 'leases', 'JLGServiceVisit-M00813-14-04-2025.pdf', 'lease/JLGServiceVisit-M00813-14-04-2025.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('dc11cee3-3ec5-425b-a976-efa4ed50538f', '731b3369-8d8a-4506-9946-ff45c139e31c', 'leases', 'REP-40343473-L1.pdf', 'lease/REP-40343473-L1.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('c91b2b7e-bba8-456b-b3c6-716787a4e1cd', '731b3369-8d8a-4506-9946-ff45c139e31c', 'leases', 'JLGServiceVisit-M00813-13-05-2025.pdf', 'lease/JLGServiceVisit-M00813-13-05-2025.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('a55c27f3-b858-45ba-97c8-d2d29f1e186c', '731b3369-8d8a-4506-9946-ff45c139e31c', 'leases', 'Communal Cleaning-First Port.pdf', 'lease/Communal Cleaning-First Port.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('12641f0d-0998-45b2-9865-6c3aef39d8bd', '731b3369-8d8a-4506-9946-ff45c139e31c', 'leases', 'SC Health and Safety Product - Accredited 10072023.pdf', 'lease/SC Health and Safety Product - Accredited 10072023.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('562b78f5-5194-4632-9237-9ec892f062f7', '731b3369-8d8a-4506-9946-ff45c139e31c', 'leases', 'Tenancy Schedule by Property.pdf', 'lease/Tenancy Schedule by Property.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('6ce9baaa-c1d3-417b-ba61-807873fd71c4', '731b3369-8d8a-4506-9946-ff45c139e31c', 'other', 'Accounts YE 31.03.2022 32-34 Connaught Square MJP.pdf', 'finance/Accounts YE 31.03.2022 32-34 Connaught Square MJP.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('800bb21e-e6b3-4643-b397-0e304cb0158e', '731b3369-8d8a-4506-9946-ff45c139e31c', 'other', '197-YE 31.03.22 SC Accs FINAL MAY 2023.pdf', 'finance/197-YE 31.03.22 SC Accs FINAL MAY 2023.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('10c32555-2e41-4d25-a8b4-8e22fc4e4948', '731b3369-8d8a-4506-9946-ff45c139e31c', 'other', 'ACCOUNTS - YE 31.03.21 - Service Charge Accounts (1).pdf', 'finance/ACCOUNTS - YE 31.03.21 - Service Charge Accounts (1).pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('a2d89a76-15d4-47d6-b312-001899a2c5f5', '731b3369-8d8a-4506-9946-ff45c139e31c', 'other', '27039 Accounts Pack - YE 2023.pdf', 'finance/27039 Accounts Pack - YE 2023.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('b35ec467-954e-4d91-a15a-ed15398733ef', '731b3369-8d8a-4506-9946-ff45c139e31c', 'other', 'Connaught Sq SC YE 23.pdf', 'finance/Connaught Sq SC YE 23.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('71e780be-3cfd-4da3-8d7b-cb7b96a4b8e4', '731b3369-8d8a-4506-9946-ff45c139e31c', 'leases', 'Connaught Square-House Rules.docx', 'lease/Connaught Square-House Rules.docx');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('9a0be423-ad4c-4b23-aa34-2d40115a8ce0', '731b3369-8d8a-4506-9946-ff45c139e31c', 'correspondence', 'Garden Notice-Connaught Square.docx', 'correspondence/Garden Notice-Connaught Square.docx');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('07332ddc-c0e3-4f25-a9b4-70cab1e2ae95', '731b3369-8d8a-4506-9946-ff45c139e31c', 'correspondence', 'Connaught Square-Key Cut Authorisation Letter.docx', 'correspondence/Connaught Square-Key Cut Authorisation Letter.docx');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('b4f28b9a-f145-4646-a15b-0e68b4eaffbb', '731b3369-8d8a-4506-9946-ff45c139e31c', 'leases', 'House Rules-Connaught Square.pdf', 'lease/House Rules-Connaught Square.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('7bdecf8e-0c92-419d-81cd-ed81679f6836', '731b3369-8d8a-4506-9946-ff45c139e31c', 'leases', 'REP-39659654.pdf', 'lease/REP-39659654.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('c11fa94c-6b66-4d63-8827-329d52b42109', '731b3369-8d8a-4506-9946-ff45c139e31c', 'leases', 'Important Information .pdf', 'lease/Important Information .pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('ffb8ac7b-11f9-4a4a-b393-77d0a6ecfc6f', '731b3369-8d8a-4506-9946-ff45c139e31c', 'leases', 'StG_Certificate_32-34 Connaught Square W2 2HL.pdf', 'lease/StG_Certificate_32-34 Connaught Square W2 2HL.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('c882df90-4e70-4ffb-9be8-ade8427f31a2', '731b3369-8d8a-4506-9946-ff45c139e31c', 'other', 'CM434.AnnualServiceAgreement2025-2026.pdf', 'contracts/CM434.AnnualServiceAgreement2025-2026.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('5b24deeb-56c2-4399-bbfe-e3dd2bd16327', '731b3369-8d8a-4506-9946-ff45c139e31c', 'other', 'CM434.AnnualServiceAgreement2024-2025.pdf', 'contracts/CM434.AnnualServiceAgreement2024-2025.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('24ee2edc-6929-4d1f-80b8-f22d2d5717af', '731b3369-8d8a-4506-9946-ff45c139e31c', 'leases', 'REP-40324834-E3.pdf', 'lease/REP-40324834-E3.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('d69f8ca7-26e1-4825-9582-29693f997e22', '731b3369-8d8a-4506-9946-ff45c139e31c', 'leases', 'Ellie@mihproperty.co.uk - BES Group - E-Report.pdf', 'lease/Ellie@mihproperty.co.uk - BES Group - E-Report.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('534cff96-a445-4b2f-a587-3ab0f7decfb2', '731b3369-8d8a-4506-9946-ff45c139e31c', 'leases', 'Jobcard_For_Job_No_38609_26-08-2025_0741.pdf', 'lease/Jobcard_For_Job_No_38609_26-08-2025_0741.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('84871aed-fc79-4473-a797-b635bda71c2b', '731b3369-8d8a-4506-9946-ff45c139e31c', 'leases', 'Jobcard_For_Job_No_28737_25-11-2024_0907.pdf', 'lease/Jobcard_For_Job_No_28737_25-11-2024_0907.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('1c68a02a-012e-4a98-bf0a-703fd5fd3b9e', '731b3369-8d8a-4506-9946-ff45c139e31c', 'leases', 'Jobcard_For_Job_No_35402_03-06-2025_0916.pdf', 'lease/Jobcard_For_Job_No_35402_03-06-2025_0916.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('46c9de05-9fe9-4759-a94d-9468223eb144', '731b3369-8d8a-4506-9946-ff45c139e31c', 'leases', 'Jobcard_For_Job_No_35654_03-06-2025_0911.pdf', 'lease/Jobcard_For_Job_No_35654_03-06-2025_0911.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('75f41f0f-6a03-4b77-9d9a-124b6c183acc', '731b3369-8d8a-4506-9946-ff45c139e31c', 'leases', 'Jobcard_For_Job_No_37675_25-07-2025_1549.pdf', 'lease/Jobcard_For_Job_No_37675_25-07-2025_1549.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('6f27da62-a708-4982-8d8c-d0f2c2fc563a', '731b3369-8d8a-4506-9946-ff45c139e31c', 'leases', 'Jobcard_For_Job_No_35146_03-06-2025_0906.pdf', 'lease/Jobcard_For_Job_No_35146_03-06-2025_0906.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('b5ee937d-653c-41d1-87d8-02f5a2a59658', '731b3369-8d8a-4506-9946-ff45c139e31c', 'leases', 'Jobcard_For_Job_No_31162_30-01-2025_1602.pdf', 'lease/Jobcard_For_Job_No_31162_30-01-2025_1602.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('d9250e82-b2b2-44e4-9dfd-3b16e5a145d7', '731b3369-8d8a-4506-9946-ff45c139e31c', 'leases', 'Jobcard_For_Job_No_36465_20-06-2025_1037.pdf', 'lease/Jobcard_For_Job_No_36465_20-06-2025_1037.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('37750813-5e99-4df5-ac8a-d72fd8acf841', '731b3369-8d8a-4506-9946-ff45c139e31c', 'other', 'connaught apportionment.xlsx', 'finance/connaught apportionment.xlsx');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('a3d111c8-b426-435e-a5bb-412b47812dd6', '731b3369-8d8a-4506-9946-ff45c139e31c', 'other', 'ACCOUNTS - YE 31.03.21 - Service Charge Accounts.pdf', 'finance/ACCOUNTS - YE 31.03.21 - Service Charge Accounts.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('42280bdf-752d-4303-ab9e-746c4aed76dc', '731b3369-8d8a-4506-9946-ff45c139e31c', 'other', 'Connaught Square Budget 2025-6 Draft.xlsx', 'finance/Connaught Square Budget 2025-6 Draft.xlsx');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('34c84285-08fe-4997-84bc-883d7adf2206', '731b3369-8d8a-4506-9946-ff45c139e31c', 'other', 'Connaught Square Budget 2025-Final.pdf', 'finance/Connaught Square Budget 2025-Final.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('40a7c356-57b7-43e0-9a13-3cdf8768e15c', '731b3369-8d8a-4506-9946-ff45c139e31c', 'other', 'Connaught Square Budget 2025-Final.xlsx', 'finance/Connaught Square Budget 2025-Final.xlsx');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('c53de3ed-8261-45c7-a5b5-c61d5c99b424', '731b3369-8d8a-4506-9946-ff45c139e31c', 'other', 'ACCOUNTS - YE 31.03.21 - Service Charge Accounts.pdf', 'finance/ACCOUNTS - YE 31.03.21 - Service Charge Accounts.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('3caf6d0d-96d0-445a-b00a-ba6f29a81548', '731b3369-8d8a-4506-9946-ff45c139e31c', 'other', 'Connaught Square YE 24 Accounts.pdf', 'finance/Connaught Square YE 24 Accounts.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('d8504ab4-c379-4e0f-9001-9dd52686a551', '731b3369-8d8a-4506-9946-ff45c139e31c', 'compliance', '2024 Directors Meeting-Notes.docx', 'compliance/2024 Directors Meeting-Notes.docx');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('a74a2cf6-e0d1-4c8b-bb08-ecf8782307f2', '731b3369-8d8a-4506-9946-ff45c139e31c', 'compliance', 'Fire Door (Communal) Inspection (11m +) (7).pdf', 'compliance/Fire Door (Communal) Inspection (11m +) (7).pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('c7b7f13f-c647-43ef-bfb3-c9bffe49ce6d', '731b3369-8d8a-4506-9946-ff45c139e31c', 'compliance', 'Fire Door (Flats) Inspection (11m +) (13).pdf', 'compliance/Fire Door (Flats) Inspection (11m +) (13).pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('f68a17a1-d984-43d0-bc74-e1cabf75714c', '731b3369-8d8a-4506-9946-ff45c139e31c', 'compliance', 'Fire Door (Flats) Inspection (11m +) (18).pdf', 'compliance/Fire Door (Flats) Inspection (11m +) (18).pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('864640fa-bcf8-4761-a60f-14402858bcad', '731b3369-8d8a-4506-9946-ff45c139e31c', 'compliance', 'Fire Door (Flats) Inspection (11m +) (14).pdf', 'compliance/Fire Door (Flats) Inspection (11m +) (14).pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('e7445605-9c50-4ce6-96ad-0b6bd4fbefaa', '731b3369-8d8a-4506-9946-ff45c139e31c', 'compliance', 'EICR Cuanku 32-34 conaught square.pdf', 'compliance/EICR Cuanku 32-34 conaught square.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('16fd10cd-ae3e-4444-90b8-89a0cab46db4', '731b3369-8d8a-4506-9946-ff45c139e31c', 'compliance', 'Fire Door (Flats) Inspection (11m +) (15).pdf', 'compliance/Fire Door (Flats) Inspection (11m +) (15).pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('dcb7d134-ec9a-4a77-b110-028ce82833c3', '731b3369-8d8a-4506-9946-ff45c139e31c', 'compliance', '221037_Fra1-L-394697-071223 32-34 Connaught Square_2024-01-02_163759 (1).pdf', 'compliance/221037_Fra1-L-394697-071223 32-34 Connaught Square_2024-01-02_163759 (1).pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('dbedf368-6834-4555-a465-705448560a29', '731b3369-8d8a-4506-9946-ff45c139e31c', 'compliance', 'Fire Door (Flats) Inspection (11m +) (19).pdf', 'compliance/Fire Door (Flats) Inspection (11m +) (19).pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('78243e96-a5bf-4106-b211-3f08f4967525', '731b3369-8d8a-4506-9946-ff45c139e31c', 'compliance', '001132-3234-Connaught-Square-London.pdf', 'compliance/001132-3234-Connaught-Square-London.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('751c5238-9ca6-4fa9-8e33-9c647aa6b0eb', '731b3369-8d8a-4506-9946-ff45c139e31c', 'compliance', '221038_Hsra1-L-394697-071223 32-34 Connaught Square_2024-01-02_163759 (1).pdf', 'compliance/221038_Hsra1-L-394697-071223 32-34 Connaught Square_2024-01-02_163759 (1).pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('b9386408-bbf6-4fab-a0af-04a3c9cea68d', '731b3369-8d8a-4506-9946-ff45c139e31c', 'compliance', 'TETRA - Asbestos Re-Inspection Survey 14.06.22.pdf', 'compliance/TETRA - Asbestos Re-Inspection Survey 14.06.22.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('cfe59ee0-9896-4f6c-9271-91c0c1986c6a', '731b3369-8d8a-4506-9946-ff45c139e31c', 'compliance', 'Fire Door (Flats) Inspection (11m +) (16).pdf', 'compliance/Fire Door (Flats) Inspection (11m +) (16).pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('eddcd2e4-55fa-46ba-a8e5-53fa3447afab', '731b3369-8d8a-4506-9946-ff45c139e31c', 'compliance', 'Fire Door (Flats) Inspection (11m +) (17).pdf', 'compliance/Fire Door (Flats) Inspection (11m +) (17).pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('f9b9d394-9e07-4750-b5af-4726055cc14a', '731b3369-8d8a-4506-9946-ff45c139e31c', 'compliance', 'WHM Legionella Risk Assessment 07.06.22.pdf', 'compliance/WHM Legionella Risk Assessment 07.06.22.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('433c8b80-f7f8-4fbb-add3-b634739157ba', '731b3369-8d8a-4506-9946-ff45c139e31c', 'compliance', 'EICR Report Cunaku SATISFACTORY 2023 .pdf', 'compliance/EICR Report Cunaku SATISFACTORY 2023 .pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('1b0ed84b-a81f-4939-9e7a-9dedc0ad2828', '731b3369-8d8a-4506-9946-ff45c139e31c', 'compliance', '2024 Directors Meeting-Notes.docx', 'compliance/2024 Directors Meeting-Notes.docx');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('3b070670-8b56-48b5-b8e4-91fdf90cea9b', '731b3369-8d8a-4506-9946-ff45c139e31c', 'compliance', '001457-3234-Connaught-Square-London Certificate.pdf', 'compliance/001457-3234-Connaught-Square-London Certificate.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('a336e345-c2ad-492d-a878-6c7c3a304477', '731b3369-8d8a-4506-9946-ff45c139e31c', 'compliance', 'TC0001V31 General Terms and Conditions.pdf', 'compliance/TC0001V31 General Terms and Conditions.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('df02e174-8217-4f57-b955-abf3718c6508', '731b3369-8d8a-4506-9946-ff45c139e31c', 'compliance', 'Jobcard_For_Job_No_28992_24-01-2025_1545.pdf', 'compliance/Jobcard_For_Job_No_28992_24-01-2025_1545.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('d19e92ea-20db-44b0-a9d8-288e9076adff', '731b3369-8d8a-4506-9946-ff45c139e31c', 'compliance', 'Connaught Square (32-34) - 09.12.24 LRA.pdf', 'compliance/Connaught Square (32-34) - 09.12.24 LRA.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('0567d0a8-5741-440e-b796-046d642b1c4b', '731b3369-8d8a-4506-9946-ff45c139e31c', 'compliance', 'SC Certificate - 10072023.pdf', 'compliance/SC Certificate - 10072023.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('bc05da32-29ab-4735-b99f-d7c1f91d298d', '731b3369-8d8a-4506-9946-ff45c139e31c', 'compliance', 'Fire Door (Communal) Inspection (11m +) (7).pdf', 'compliance/Fire Door (Communal) Inspection (11m +) (7).pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('d3e981b2-48ed-4440-952d-113fea2b321b', '731b3369-8d8a-4506-9946-ff45c139e31c', 'compliance', 'Fire Door (Flats) Inspection (11m +) (13).pdf', 'compliance/Fire Door (Flats) Inspection (11m +) (13).pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('bae258c1-ed0c-4626-80ae-58d70f5222f2', '731b3369-8d8a-4506-9946-ff45c139e31c', 'compliance', 'Fire Door (Flats) Inspection (11m +) (18).pdf', 'compliance/Fire Door (Flats) Inspection (11m +) (18).pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('08c1f0e5-5095-47e5-9130-044368a6e8b0', '731b3369-8d8a-4506-9946-ff45c139e31c', 'compliance', 'Fire Door (Flats) Inspection (11m +) (14).pdf', 'compliance/Fire Door (Flats) Inspection (11m +) (14).pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('a63d8ec3-3b55-45c6-b198-56308982a97f', '731b3369-8d8a-4506-9946-ff45c139e31c', 'compliance', 'Fire Door (Flats) Inspection (11m +) (15).pdf', 'compliance/Fire Door (Flats) Inspection (11m +) (15).pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('20130c84-3bee-4543-949b-7381b0bfa2d2', '731b3369-8d8a-4506-9946-ff45c139e31c', 'compliance', 'Fire Door (Flats) Inspection (11m +) (19).pdf', 'compliance/Fire Door (Flats) Inspection (11m +) (19).pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('d4b1be4b-8a93-4e08-9ae7-749ae5f26edd', '731b3369-8d8a-4506-9946-ff45c139e31c', 'compliance', 'Fire Door (Flats) Inspection (11m +) (16).pdf', 'compliance/Fire Door (Flats) Inspection (11m +) (16).pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('c8a4e29f-fa65-45cb-aa88-61d1edee7f2c', '731b3369-8d8a-4506-9946-ff45c139e31c', 'compliance', 'Fire Door (Flats) Inspection (11m +) (17).pdf', 'compliance/Fire Door (Flats) Inspection (11m +) (17).pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('fe77346a-fd2d-43af-8f74-fb46c09dcf94', '731b3369-8d8a-4506-9946-ff45c139e31c', 'compliance', '221037_Fra1-L-394697-071223 32-34 Connaught Square_2024-01-02_163759.pdf', 'compliance/221037_Fra1-L-394697-071223 32-34 Connaught Square_2024-01-02_163759.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('f25027a7-8d2a-41da-a42e-32d178a03c12', '731b3369-8d8a-4506-9946-ff45c139e31c', 'compliance', 'Fire Door (Flats) Inspection (11m +) - 2024-01-24T120747.552.pdf', 'compliance/Fire Door (Flats) Inspection (11m +) - 2024-01-24T120747.552.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('be2e5e09-47d5-4489-888d-1936e4d4132d', '731b3369-8d8a-4506-9946-ff45c139e31c', 'compliance', 'Connaught Square (32-34) - 15.11.23 (886) wa.pdf', 'compliance/Connaught Square (32-34) - 15.11.23 (886) wa.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('f0c8dccc-7513-44f3-89a0-e8dace28a546', '731b3369-8d8a-4506-9946-ff45c139e31c', 'compliance', 'Fire Door (Flats) Inspection (11m +) - 2024-01-24T120745.875.pdf', 'compliance/Fire Door (Flats) Inspection (11m +) - 2024-01-24T120745.875.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('963f2e1f-dd45-4e22-a2bd-13e5fc6a15e8', '731b3369-8d8a-4506-9946-ff45c139e31c', 'compliance', 'Fire Door (Flats) Inspection (11m +) - 2024-01-24T120746.424.pdf', 'compliance/Fire Door (Flats) Inspection (11m +) - 2024-01-24T120746.424.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('037aaffa-ed30-4d5d-aec7-6ece4d509f96', '731b3369-8d8a-4506-9946-ff45c139e31c', 'compliance', 'Fire Door (Communal) Inspection (11m +) - 2024-01-24T120743.986.pdf', 'compliance/Fire Door (Communal) Inspection (11m +) - 2024-01-24T120743.986.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('fd8acc9f-a12a-458a-bad7-32a5cf8d485e', '731b3369-8d8a-4506-9946-ff45c139e31c', 'compliance', 'Fire Door (Flats) Inspection (11m +) - 2024-01-24T120744.738.pdf', 'compliance/Fire Door (Flats) Inspection (11m +) - 2024-01-24T120744.738.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('d604c89d-2f3d-46b6-a730-d272b939d2d6', '731b3369-8d8a-4506-9946-ff45c139e31c', 'compliance', 'Fire Door (Flats) Inspection (11m +) - 2024-01-24T120747.015.pdf', 'compliance/Fire Door (Flats) Inspection (11m +) - 2024-01-24T120747.015.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('282147c9-8bc4-4ee5-8c69-70008c5c4c3f', '731b3369-8d8a-4506-9946-ff45c139e31c', 'compliance', '221038_Hsra1-L-394697-071223 32-34 Connaught Square_2024-01-02_163759.pdf', 'compliance/221038_Hsra1-L-394697-071223 32-34 Connaught Square_2024-01-02_163759.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('80161327-82aa-493e-bf0e-6551da025aa1', '731b3369-8d8a-4506-9946-ff45c139e31c', 'compliance', 'Fire Door (Flats) Inspection (11m +) - 2024-01-24T120745.174.pdf', 'compliance/Fire Door (Flats) Inspection (11m +) - 2024-01-24T120745.174.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('147a78f0-7e36-4cac-851b-330d9ff5fdd6', '731b3369-8d8a-4506-9946-ff45c139e31c', 'compliance', 'Hsfra1-L-422971-210225 32-34 Connaught Square.pdf', 'compliance/Hsfra1-L-422971-210225 32-34 Connaught Square.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('18767fd5-9cf4-4362-a6fb-72ed42614c51', '731b3369-8d8a-4506-9946-ff45c139e31c', 'compliance', 'Hsfra1-L-422971-210225 32-34 Connaught Square.docx', 'compliance/Hsfra1-L-422971-210225 32-34 Connaught Square.docx');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('c3ea041e-2ea3-4a56-b8cb-138e78c740a2', '731b3369-8d8a-4506-9946-ff45c139e31c', 'compliance', '221037_Fra1-L-394697-071223 32-34 Connaught Square_2024-01-02_163759 (1).pdf', 'compliance/221037_Fra1-L-394697-071223 32-34 Connaught Square_2024-01-02_163759 (1).pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('ae83e041-73ab-4659-8dfe-51648b90fcb6', '731b3369-8d8a-4506-9946-ff45c139e31c', 'compliance', '221038_Hsra1-L-394697-071223 32-34 Connaught Square_2024-01-02_163759 (1).pdf', 'compliance/221038_Hsra1-L-394697-071223 32-34 Connaught Square_2024-01-02_163759 (1).pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('39bc0bf7-b822-4528-b630-b7bed8abad1c', '731b3369-8d8a-4506-9946-ff45c139e31c', 'compliance', 'FRA-Connaught Square Reccommendations.xlsx', 'compliance/FRA-Connaught Square Reccommendations.xlsx');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('8fc29f12-11e9-4b42-acbf-215f4f00830a', '731b3369-8d8a-4506-9946-ff45c139e31c', 'compliance', '001534-3234-Connaught-Square-London.pdf', 'compliance/001534-3234-Connaught-Square-London.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('ce584dc3-9926-4529-90f1-0e25ecead555', '731b3369-8d8a-4506-9946-ff45c139e31c', 'compliance', 'C1047 - Job card.pdf', 'compliance/C1047 - Job card.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('48a9ca62-3ab1-482f-88eb-e541a820f25b', '731b3369-8d8a-4506-9946-ff45c139e31c', 'compliance', 'WHM Legionella Risk Assessment 09.12.25.pdf', 'compliance/WHM Legionella Risk Assessment 09.12.25.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('54eb8e7e-a5ab-4bd4-946d-62195358c108', '731b3369-8d8a-4506-9946-ff45c139e31c', 'compliance', 'WHM Legionella Risk Assessment 07.06.22.pdf', 'compliance/WHM Legionella Risk Assessment 07.06.22.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('1608c9bf-d18a-462b-8c57-757ea7f9d18b', '731b3369-8d8a-4506-9946-ff45c139e31c', 'compliance', 'Connaught Square (32-34) - 29.05.25 (201) wa.pdf', 'compliance/Connaught Square (32-34) - 29.05.25 (201) wa.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('98ba8b82-9102-4bef-ad9e-3b0b521b27b5', '731b3369-8d8a-4506-9946-ff45c139e31c', 'compliance', 'EICR Cuanku 32-34 conaught square.pdf', 'compliance/EICR Cuanku 32-34 conaught square.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('93106582-01c9-4fca-9afe-0e121ec375e9', '731b3369-8d8a-4506-9946-ff45c139e31c', 'compliance', 'EICR Report Cunaku SATISFACTORY 2023 .pdf', 'compliance/EICR Report Cunaku SATISFACTORY 2023 .pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('a278820c-e603-496a-87b1-e43056e994dd', '731b3369-8d8a-4506-9946-ff45c139e31c', 'compliance', '001132-3234-Connaught-Square-London.pdf', 'compliance/001132-3234-Connaught-Square-London.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('fb35b401-48b7-47d0-9205-45f3a53cc5a6', '731b3369-8d8a-4506-9946-ff45c139e31c', 'compliance', '001534-3234-Connaught-Square-London.pdf', 'compliance/001534-3234-Connaught-Square-London.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('73170f30-4dc9-4aa0-9c01-ad2fd47d6f45', '731b3369-8d8a-4506-9946-ff45c139e31c', 'compliance', 'FINAL L-432900 32-34 Connaught Square Management Survey Report Issue 1.pdf', 'compliance/FINAL L-432900 32-34 Connaught Square Management Survey Report Issue 1.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('24d1de5e-dbc7-4ab9-93b5-846f8f04a3bc', '731b3369-8d8a-4506-9946-ff45c139e31c', 'compliance', 'TETRA - Asbestos Re-Inspection Survey 14.06.22.pdf', 'compliance/TETRA - Asbestos Re-Inspection Survey 14.06.22.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('6c034638-f0fe-4256-83bc-6c83ee5abbb7', '731b3369-8d8a-4506-9946-ff45c139e31c', 'other', 'British Gas Invoice-862451083.pdf', 'finance/British Gas Invoice-862451083.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('3fd5b533-2040-4a16-aded-679b14506c45', '731b3369-8d8a-4506-9946-ff45c139e31c', 'other', 'Signed 2025 Connaught Square Management Agreement.docx.pdf', 'contracts/Signed 2025 Connaught Square Management Agreement.docx.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('f6751529-3158-4a77-b41f-1080d0aafd01', '731b3369-8d8a-4506-9946-ff45c139e31c', 'other', 'Connaught Square Management Agreement.docx', 'contracts/Connaught Square Management Agreement.docx');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('4ab8d9fe-b6f2-4b35-87aa-2cb62632522a', '731b3369-8d8a-4506-9946-ff45c139e31c', 'other', '2025 Connaught Square Management Agreement.docx', 'contracts/2025 Connaught Square Management Agreement.docx');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('0da4a9de-6552-4bfb-946f-38f37a8a8fbe', '731b3369-8d8a-4506-9946-ff45c139e31c', 'other', 'Signed Connaught Square Management Agreement.pdf', 'contracts/Signed Connaught Square Management Agreement.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('b6ec67a9-4e68-4f66-9012-3bf459529e57', '731b3369-8d8a-4506-9946-ff45c139e31c', 'other', 'Contractors list.xlsx', 'contracts/Contractors list.xlsx');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('d1f47aec-8e70-4dd8-8621-d54520fcc0b1', '731b3369-8d8a-4506-9946-ff45c139e31c', 'other', 'Contractors list.xlsx', 'contracts/Contractors list.xlsx');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('7553739e-596b-4f44-952d-ce05c2715ed7', '731b3369-8d8a-4506-9946-ff45c139e31c', 'other', 'EMERGENCY CALL OUT DETAILS 2024.pdf', 'contracts/EMERGENCY CALL OUT DETAILS 2024.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('b70c496a-5026-434e-bda2-b75396f0845a', '731b3369-8d8a-4506-9946-ff45c139e31c', 'other', 'CM434.PRO 2024-2025.pdf', 'contracts/CM434.PRO 2024-2025.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('a8e50dbb-35e0-4941-a0ee-0b7e5d301de6', '731b3369-8d8a-4506-9946-ff45c139e31c', 'other', 'CM434.PRO.pdf', 'contracts/CM434.PRO.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('04a03a42-718a-4ac3-b80c-fdf379ef3f68', '731b3369-8d8a-4506-9946-ff45c139e31c', 'other', 'Gas Contract 24-5.pdf', 'contracts/Gas Contract 24-5.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('764d3f6d-8b43-4bb7-8b06-b9e8ce917adb', '731b3369-8d8a-4506-9946-ff45c139e31c', 'other', 'Contract_10-03-2025.pdf', 'contracts/Contract_10-03-2025.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('c3a9129e-daa5-4cc5-8944-57422ed74f4e', '731b3369-8d8a-4506-9946-ff45c139e31c', 'other', 'Gas Contract 25-26.pdf', 'contracts/Gas Contract 25-26.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('c0b27c93-ff05-4653-bd8f-c049712611ab', '731b3369-8d8a-4506-9946-ff45c139e31c', 'correspondence', 'Welcome Letter - CG1885574.pdf', 'correspondence/Welcome Letter - CG1885574.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('4495c7bb-bb44-4d0e-aa20-b1afa5ea3ff1', '731b3369-8d8a-4506-9946-ff45c139e31c', 'other', 'Job 67141.pdf', 'contracts/Job 67141.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('a0912def-e27e-4709-b7ea-53c6292ac8ae', '731b3369-8d8a-4506-9946-ff45c139e31c', 'other', 'BLENHEIMS, 32-34 CONNAUGHT, W2 2HL - 19.05.23.pdf', 'contracts/BLENHEIMS, 32-34 CONNAUGHT, W2 2HL - 19.05.23.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('5f913e1c-3002-49d9-8497-cd88d0ca8c48', '731b3369-8d8a-4506-9946-ff45c139e31c', 'other', 'BLENHEIMS, 32-34 CONNAUGHT, W2 2HL - 22.03.23.pdf', 'contracts/BLENHEIMS, 32-34 CONNAUGHT, W2 2HL - 22.03.23.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('195e0a55-e214-4199-a2f3-264000e2d622', '731b3369-8d8a-4506-9946-ff45c139e31c', 'other', 'BLENHEIMS, 32-34 CONNAUGHT, W2 2HL - 26.06.23.pdf', 'contracts/BLENHEIMS, 32-34 CONNAUGHT, W2 2HL - 26.06.23.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('cdb548f1-3798-4ddc-9c0b-8691b5a5e979', '731b3369-8d8a-4506-9946-ff45c139e31c', 'other', 'BLENHEIMS, 32-34 CONNAUGHT, W2 2HL - 19.05.23.pdf', 'contracts/BLENHEIMS, 32-34 CONNAUGHT, W2 2HL - 19.05.23.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('efa526fa-3d0e-4557-89ef-83b0b1f38625', '731b3369-8d8a-4506-9946-ff45c139e31c', 'other', 'BLENHEIMS, 32-34 CONNAUGHT, W2 2HL - 22.03.23.pdf', 'contracts/BLENHEIMS, 32-34 CONNAUGHT, W2 2HL - 22.03.23.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('b2b1276b-0186-4714-a1f5-e50d0e15e3ae', '731b3369-8d8a-4506-9946-ff45c139e31c', 'other', 'BLENHEIMS, 32-34 CONNAUGHT, W2 2HL - 26.06.23.pdf', 'contracts/BLENHEIMS, 32-34 CONNAUGHT, W2 2HL - 26.06.23.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('de9366a3-b121-4be1-ba7a-e067571df708', '731b3369-8d8a-4506-9946-ff45c139e31c', 'other', 'Jobcard_For_Job_No_27067_07-10-2024_1147.pdf', 'contracts/Jobcard_For_Job_No_27067_07-10-2024_1147.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('0a09c7d8-2240-4ded-b7b1-c1918bc136db', '731b3369-8d8a-4506-9946-ff45c139e31c', 'other', 'Jobcard_For_Job_No_19665_28-03-2024_0936.pdf', 'contracts/Jobcard_For_Job_No_19665_28-03-2024_0936.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('93900821-67f2-4733-8965-2980444b0b93', '731b3369-8d8a-4506-9946-ff45c139e31c', 'other', 'Jobcard_For_Job_No_22634_03-07-2024_1649.pdf', 'contracts/Jobcard_For_Job_No_22634_03-07-2024_1649.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('1a5909e8-c897-4ce5-8d1f-c505bf99db43', '731b3369-8d8a-4506-9946-ff45c139e31c', 'other', 'Jobcard_For_Job_No_25732_03-10-2024_1337.pdf', 'contracts/Jobcard_For_Job_No_25732_03-10-2024_1337.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('98b1e9e9-8284-4fc4-ac46-2a4ede595cf2', '731b3369-8d8a-4506-9946-ff45c139e31c', 'other', 'Lift Contract-Jacksons lift.pdf', 'contracts/Lift Contract-Jacksons lift.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('503f1328-6025-4753-b882-2ba6509feed7', '731b3369-8d8a-4506-9946-ff45c139e31c', 'other', 'JLGCalloutVisit-5455045-12-07-2024.pdf', 'contracts/JLGCalloutVisit-5455045-12-07-2024.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('e9163974-f538-478c-a002-3f6e3e48640a', '731b3369-8d8a-4506-9946-ff45c139e31c', 'other', 'JLGCalloutVisit-5483206-26-10-2024.pdf', 'contracts/JLGCalloutVisit-5483206-26-10-2024.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('f6fdaee9-9192-4a83-9bbb-7111a8527af8', '731b3369-8d8a-4506-9946-ff45c139e31c', 'other', 'JLGCalloutVisit-5498439-16-12-2024.pdf', 'contracts/JLGCalloutVisit-5498439-16-12-2024.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('c0b37cb2-4130-4a17-9c10-9cbbf10bdfdb', '731b3369-8d8a-4506-9946-ff45c139e31c', 'other', 'JLGCalloutVisit-5455462-16-07-2024.pdf', 'contracts/JLGCalloutVisit-5455462-16-07-2024.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('2021736e-a4b6-4eb3-8f2b-820bcaae3e1b', '731b3369-8d8a-4506-9946-ff45c139e31c', 'other', 'JLGCalloutVisit-5497480-13-12-2024.pdf', 'contracts/JLGCalloutVisit-5497480-13-12-2024.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('86d5b169-0664-43f8-b482-a6303828d5fb', '731b3369-8d8a-4506-9946-ff45c139e31c', 'other', 'Engineering Report - 32-34 CONNAUGHT SQUARE.pdf', 'contracts/Engineering Report - 32-34 CONNAUGHT SQUARE.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('9587e148-9921-4fe9-83cb-784801ef9c1f', '731b3369-8d8a-4506-9946-ff45c139e31c', 'other', 'Arch Directors and Officers Liability Insurance for Residents Associations (12.22).pdf', 'contracts/Arch Directors and Officers Liability Insurance for Residents Associations (12.22).pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('3ad09c17-4dda-4000-a73e-bf4db7fa7657', '731b3369-8d8a-4506-9946-ff45c139e31c', 'other', 'StG_Policy Wording_32-34 Connaught Square W2 2HL.pdf', 'contracts/StG_Policy Wording_32-34 Connaught Square W2 2HL.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('c0e0495b-4b65-4f11-b1ff-39c300b0306f', '731b3369-8d8a-4506-9946-ff45c139e31c', 'compliance', 'Fire Extinguisher Signed Contract- Connaught Square.pdf', 'compliance/Fire Extinguisher Signed Contract- Connaught Square.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('9c4f58f5-65af-47fd-82bd-4ddaf2a824b7', '731b3369-8d8a-4506-9946-ff45c139e31c', 'other', 'Q51691 - 32-34 Connaught Square Contract.pdf', 'contracts/Q51691 - 32-34 Connaught Square Contract.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('64db4506-b5ae-4c71-8031-27b9d3bae9e9', '731b3369-8d8a-4506-9946-ff45c139e31c', 'other', 'Engineering Report - 32-34 CONNAUGHT SQUARE.pdf', 'contracts/Engineering Report - 32-34 CONNAUGHT SQUARE.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('1854433f-54e7-4bb8-9076-bffdb6f9bc8b', '731b3369-8d8a-4506-9946-ff45c139e31c', 'compliance', 'Fire Alarm+Emergency Lighting Signed Contract-3234 Connaught Square.pdf', 'compliance/Fire Alarm+Emergency Lighting Signed Contract-3234 Connaught Square.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('9e36eeed-482d-47c1-8743-d811b00676c0', '731b3369-8d8a-4506-9946-ff45c139e31c', 'compliance', 'Fire Alarm+Emergency Lighting Contract Connaught Square.pdf', 'compliance/Fire Alarm+Emergency Lighting Contract Connaught Square.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('3bd48190-b330-47de-828a-830420d41722', '731b3369-8d8a-4506-9946-ff45c139e31c', 'other', 'BT3205 03072025.pdf', 'contracts/BT3205 03072025.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('d9dca639-6556-4ae3-93b0-3c36a0933743', '731b3369-8d8a-4506-9946-ff45c139e31c', 'other', 'FA7817 SERVICE 08042025.pdf', 'contracts/FA7817 SERVICE 08042025.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('7d6ac38e-409c-4e2a-887b-70a0602ef4c6', '731b3369-8d8a-4506-9946-ff45c139e31c', 'other', 'Engineer Report - 32-34 Connaught Square Flat 5.pdf', 'contracts/Engineer Report - 32-34 Connaught Square Flat 5.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('c2094879-2907-4b9b-80c0-2a2d3d04d078', '731b3369-8d8a-4506-9946-ff45c139e31c', 'other', 'Engineering Report - 32-34 CONNAUGHT SQUARE.pdf', 'contracts/Engineering Report - 32-34 CONNAUGHT SQUARE.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('24124242-e577-4a10-af6a-39eac72f9f52', '731b3369-8d8a-4506-9946-ff45c139e31c', 'other', 'Jobcard_For_Job_No_22171_14-05-2024_1202.pdf', 'contracts/Jobcard_For_Job_No_22171_14-05-2024_1202.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('3054684b-29af-49fc-9b6e-470874949c56', '731b3369-8d8a-4506-9946-ff45c139e31c', 'other', 'British Gas Invoice-862451083.pdf', 'finance/British Gas Invoice-862451083.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('c5ad6012-ef6e-4d87-8108-1acb830f08a5', '731b3369-8d8a-4506-9946-ff45c139e31c', 'other', 'MT8825 03072025.pdf', 'contracts/MT8825 03072025.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('2e730a2c-9e4b-4caf-8a63-a745b26cf360', '731b3369-8d8a-4506-9946-ff45c139e31c', 'other', 'January Monthly Test For EL-Connaught Square.pdf', 'contracts/January Monthly Test For EL-Connaught Square.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('da7d6284-4695-48e0-b66d-1ecafe973ac6', '731b3369-8d8a-4506-9946-ff45c139e31c', 'other', 'February Monthly Test For EL-Connaught Square.pdf', 'contracts/February Monthly Test For EL-Connaught Square.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('eea7711f-7a70-4842-afb9-37f4a38ab5cf', '731b3369-8d8a-4506-9946-ff45c139e31c', 'major_works', 'External Decorations SOI - 28042025.docx', 'major_works/External Decorations SOI - 28042025.docx');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('eb1d3485-674e-4d79-9ecd-046d1af88577', '731b3369-8d8a-4506-9946-ff45c139e31c', 'major_works', 'External Dec SOE 03072025.docx', 'major_works/External Dec SOE 03072025.docx');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('b5ba2614-770b-4e51-aaf5-18cdb4134331', '731b3369-8d8a-4506-9946-ff45c139e31c', 'major_works', 'Notice of intention for lift.docx', 'major_works/Notice of intention for lift.docx');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('aa47f2cc-5acd-4e82-885a-ee84835b7c3e', '731b3369-8d8a-4506-9946-ff45c139e31c', 'major_works', 'Connaught Square (32-34) - 09.12.24 Schematic.pdf', 'major_works/Connaught Square (32-34) - 09.12.24 Schematic.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('f6655ad7-8df2-4765-b57f-fd26ce00e7f6', '731b3369-8d8a-4506-9946-ff45c139e31c', 'compliance', 'CGBI3964546XB6-Cunaku Construction Ltd-Business-Certificate of insurance.pdf', 'compliance/CGBI3964546XB6-Cunaku Construction Ltd-Business-Certificate of insurance.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('f13e4e41-c032-4248-b47a-ee2ddbbe9a70', '731b3369-8d8a-4506-9946-ff45c139e31c', 'compliance', 'CGBI3964546XB7-Cunaku Construction Ltd-Business-Certificate of insurance.pdf', 'compliance/CGBI3964546XB7-Cunaku Construction Ltd-Business-Certificate of insurance.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('98fa1c45-f403-40f9-bfca-e9b72be1a3cf', '731b3369-8d8a-4506-9946-ff45c139e31c', 'compliance', 'Real Estate Insurance NTP (01.23).pdf', 'compliance/Real Estate Insurance NTP (01.23).pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('6df4d985-10e3-49a6-bca6-75ba376d2eaf', '731b3369-8d8a-4506-9946-ff45c139e31c', 'compliance', 'Real Estate Policy (01.23).pdf', 'compliance/Real Estate Policy (01.23).pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('5f548ede-85bf-4ba5-8fe1-2833f5dfe0e4', '731b3369-8d8a-4506-9946-ff45c139e31c', 'compliance', 'Summary of Cover (01.23).pdf', 'compliance/Summary of Cover (01.23).pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('829ebf00-d736-4903-9021-73ef2007d3c8', '731b3369-8d8a-4506-9946-ff45c139e31c', 'compliance', '2023 Allianz VOC - 32-34 Connuaght Square (Freehold) Limited.pdf', 'compliance/2023 Allianz VOC - 32-34 Connuaght Square (Freehold) Limited.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('cc0c6f0d-51a4-4bc9-887d-d808701fbd05', '731b3369-8d8a-4506-9946-ff45c139e31c', 'correspondence', '2023 Engineering Renewal Notice - 32 34 Connuaght Square (Freehold) Limited.pdf', 'correspondence/2023 Engineering Renewal Notice - 32 34 Connuaght Square (Freehold) Limited.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('1c99e9d8-7100-40e5-897c-fed7699d91b8', '731b3369-8d8a-4506-9946-ff45c139e31c', 'compliance', '32-34 Connaught Square Freehold Limited - Arch D&O Schedule.pdf', 'compliance/32-34 Connaught Square Freehold Limited - Arch D&O Schedule.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('48c63a88-8e00-4459-a990-d10888054f88', '731b3369-8d8a-4506-9946-ff45c139e31c', 'compliance', '32-34 Connaught Sq Buildings Insurance 2023-2024.pdf', 'compliance/32-34 Connaught Sq Buildings Insurance 2023-2024.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('64c574e7-a8f4-43fb-9b47-16726a55b57e', '731b3369-8d8a-4506-9946-ff45c139e31c', 'compliance', 'Policy Limits Document.pdf', 'compliance/Policy Limits Document.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('811a27f5-e739-4a02-b55c-c8e46f3dd735', '731b3369-8d8a-4506-9946-ff45c139e31c', 'leases', 'Official Copy (Lease) 13.06.2003 - NGL823646-Flat 4.pdf', 'lease/Official Copy (Lease) 13.06.2003 - NGL823646-Flat 4.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('83c714ff-310a-4851-be17-2e4e9369e33a', '731b3369-8d8a-4506-9946-ff45c139e31c', 'correspondence', 'Letter of Authority - Connaught Square.doc.pdf', 'correspondence/Letter of Authority - Connaught Square.doc.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('698c475c-276d-4f39-9f04-c88fe6a359d4', '731b3369-8d8a-4506-9946-ff45c139e31c', 'correspondence', 'Letter to report - Connaught Square.doc.pdf', 'correspondence/Letter to report - Connaught Square.doc.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('f3251178-eb28-42b4-bb0a-308ea184d5b7', '731b3369-8d8a-4506-9946-ff45c139e31c', 'other', 'Pricing Quote - 32_34 Connaught Square Freehold Ltd - 109 - Gas - 10.03.2025.pdf', 'contracts/Pricing Quote - 32_34 Connaught Square Freehold Ltd - 109 - Gas - 10.03.2025.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('507f4477-3652-4f14-8240-a1090aacf59a', '731b3369-8d8a-4506-9946-ff45c139e31c', 'compliance', 'Allianz - Lift Report 14.03.23.pdf', 'compliance/Allianz - Lift Report 14.03.23.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('f5d36407-d40c-4212-9b06-8b42c8d63501', '731b3369-8d8a-4506-9946-ff45c139e31c', 'compliance', 'Allianz-Lift Report 18.03.2024.pdf', 'compliance/Allianz-Lift Report 18.03.2024.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('588f9c06-5eb3-4f42-81aa-ce16a824be02', '731b3369-8d8a-4506-9946-ff45c139e31c', 'compliance', 'Allianz - Lift Report - 15.09.21.pdf', 'compliance/Allianz - Lift Report - 15.09.21.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('59f1a19a-9cc4-4915-83a1-2749ae5c2be7', '731b3369-8d8a-4506-9946-ff45c139e31c', 'compliance', 'Allianz - Lift Report 27.09.23.pdf', 'compliance/Allianz - Lift Report 27.09.23.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('4e6dddd7-1eca-4364-a7a3-040aae3a4a5b', '731b3369-8d8a-4506-9946-ff45c139e31c', 'compliance', 'Allianz - Lift Report 10.03.22.pdf', 'compliance/Allianz - Lift Report 10.03.22.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('fea1647c-acb6-4f11-b340-52e243c8c98d', '731b3369-8d8a-4506-9946-ff45c139e31c', 'compliance', 'Allianz - Lift Report 09.09.22.pdf', 'compliance/Allianz - Lift Report 09.09.22.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('5a6338ea-a524-4914-85d3-e2551f17cd8a', '731b3369-8d8a-4506-9946-ff45c139e31c', 'compliance', 'LXBI3559280XB2-NEW STEP-Business-Certificate of insurance.pdf', 'compliance/LXBI3559280XB2-NEW STEP-Business-Certificate of insurance.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('bd3110b8-4d86-409b-b022-bedaf8fccbf8', '731b3369-8d8a-4506-9946-ff45c139e31c', 'compliance', '2023 Allianz VOC - 32-34 Connuaght Square (Freehold) Limited.pdf', 'compliance/2023 Allianz VOC - 32-34 Connuaght Square (Freehold) Limited.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('4de6783d-c0de-4a71-a7e2-99d49970bbd6', '731b3369-8d8a-4506-9946-ff45c139e31c', 'correspondence', '2023 Engineering Renewal Notice - 32 34 Connuaght Square (Freehold) Limited.pdf', 'correspondence/2023 Engineering Renewal Notice - 32 34 Connuaght Square (Freehold) Limited.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('92bb98b0-49cd-4a17-ad08-d98aad8bd717', '731b3369-8d8a-4506-9946-ff45c139e31c', 'compliance', 'MO - Policy Wording - NZ0411.pdf', 'compliance/MO - Policy Wording - NZ0411.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('73b7cd6f-56e0-4276-b12e-d434f4088118', '731b3369-8d8a-4506-9946-ff45c139e31c', 'compliance', 'Feature and Benefits of Allianz Engineering Inspection Service.pdf', 'compliance/Feature and Benefits of Allianz Engineering Inspection Service.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('8f710bea-2674-4038-8370-01e62b7bd238', '731b3369-8d8a-4506-9946-ff45c139e31c', 'compliance', 'StG_Insurer pack_32-34 Connaught Square Freehold Limited.pdf', 'compliance/StG_Insurer pack_32-34 Connaught Square Freehold Limited.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('68b4c671-9e07-4d91-92b2-98b6410fa105', '731b3369-8d8a-4506-9946-ff45c139e31c', 'compliance', 'StG_Statement of Facts_32-34 Connaught Square W2 2HL.pdf', 'compliance/StG_Statement of Facts_32-34 Connaught Square W2 2HL.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('c9254c95-bbf4-4e86-b29a-2ab85a05c013', '731b3369-8d8a-4506-9946-ff45c139e31c', 'compliance', 'StG_Insurance Report_32-34 Connaught Square W2 2HL.pdf', 'compliance/StG_Insurance Report_32-34 Connaught Square W2 2HL.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('ba548e39-b365-4090-ba5c-22ea4f6396ce', '731b3369-8d8a-4506-9946-ff45c139e31c', 'compliance', 'StG_Insurer pack_32-34 Connaught Square Freehold Limited.pdf', 'compliance/StG_Insurer pack_32-34 Connaught Square Freehold Limited.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('ec96bc2e-8d57-4381-a08f-a68c7300c245', '731b3369-8d8a-4506-9946-ff45c139e31c', 'compliance', 'StG_Statement of Facts_32-34 Connaught Square W2 2HL.pdf', 'compliance/StG_Statement of Facts_32-34 Connaught Square W2 2HL.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('876fe009-979a-4fde-a06f-802ef78db816', '731b3369-8d8a-4506-9946-ff45c139e31c', 'compliance', 'StG_Insurance Report_32-34 Connaught Square W2 2HL.pdf', 'compliance/StG_Insurance Report_32-34 Connaught Square W2 2HL.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('37c726eb-d624-4a10-bc63-03a059196e9a', '731b3369-8d8a-4506-9946-ff45c139e31c', 'other', 'StG_Invoice_32-34 Connaught Square W2 2HL.pdf', 'finance/StG_Invoice_32-34 Connaught Square W2 2HL.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('1163ae3c-5651-4463-be52-19e91cb9be65', '731b3369-8d8a-4506-9946-ff45c139e31c', 'compliance', 'StG_Certificate_32-34 Connaught Square W2 2HL.pdf', 'compliance/StG_Certificate_32-34 Connaught Square W2 2HL.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('6ae2079c-7cd2-4aea-a542-dfbaddc90408', '731b3369-8d8a-4506-9946-ff45c139e31c', 'compliance', 'StG_Insurer pack_32-34 Connaught Square Freehold Limited.pdf', 'compliance/StG_Insurer pack_32-34 Connaught Square Freehold Limited.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('967503f0-fe54-46fa-9bd7-7d70ba977609', '731b3369-8d8a-4506-9946-ff45c139e31c', 'compliance', 'StG_Statement of Fact_32-34 Connaught Square W2 2HL.pdf', 'compliance/StG_Statement of Fact_32-34 Connaught Square W2 2HL.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('f1b0160c-201c-4de5-bbef-b880fa7c3793', '731b3369-8d8a-4506-9946-ff45c139e31c', 'other', 'StG_Invoice_32-34 Connaught Square Freehold Limited.pdf', 'finance/StG_Invoice_32-34 Connaught Square Freehold Limited.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('e1d9ad14-e385-4dd9-a313-6da898d08dd2', '731b3369-8d8a-4506-9946-ff45c139e31c', 'compliance', '32-34 Connaught Square Freehold Limited - Arch D&O Schedule.pdf', 'compliance/32-34 Connaught Square Freehold Limited - Arch D&O Schedule.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('1cd63b50-8e80-4a0e-83a2-a9ffb9c1a98b', '731b3369-8d8a-4506-9946-ff45c139e31c', 'compliance', 'StG_Certificate_32-34 Connaught Square Freehold Limited.pdf', 'compliance/StG_Certificate_32-34 Connaught Square Freehold Limited.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('ddf1bf0f-5d97-4ee3-ad7a-e31d89359057', '731b3369-8d8a-4506-9946-ff45c139e31c', 'compliance', 'StG_Policy Wording_32-34 Connaught Square Freehold Limited.pdf', 'compliance/StG_Policy Wording_32-34 Connaught Square Freehold Limited.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('3c762283-ffcf-47f9-a59d-b56e48ea50b2', '731b3369-8d8a-4506-9946-ff45c139e31c', 'compliance', 'StG_D&O Endorsements_32-34 Connaught Square Freehold Limited.pdf', 'compliance/StG_D&O Endorsements_32-34 Connaught Square Freehold Limited.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('a12062a8-1809-467c-b1c4-fba616dac867', '731b3369-8d8a-4506-9946-ff45c139e31c', 'other', 'StG_Demands & Needs_32-34 Connaught Square Freehold Limited.pdf', 'finance/StG_Demands & Needs_32-34 Connaught Square Freehold Limited.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('74ee3b98-1326-4de1-8895-8b67f25f7737', '731b3369-8d8a-4506-9946-ff45c139e31c', 'other', 'StG_Quote_32-34 Connaught Square Freehold Limited.pdf', 'contracts/StG_Quote_32-34 Connaught Square Freehold Limited.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('cc7ceb62-6778-4996-9ee6-bd4f691af427', '731b3369-8d8a-4506-9946-ff45c139e31c', 'compliance', 'StG_Insurance Report_32-34 Connaught Square W2 2HL.pdf', 'compliance/StG_Insurance Report_32-34 Connaught Square W2 2HL.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('6a032e61-92c5-4b48-b15b-490a1f975a5b', '731b3369-8d8a-4506-9946-ff45c139e31c', 'compliance', 'FBR113382303-20230405-B.pdf', 'compliance/FBR113382303-20230405-B.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('379ddc50-aa42-4f40-bdb8-c133cbd3c404', '731b3369-8d8a-4506-9946-ff45c139e31c', 'compliance', 'Real Estate Insurance NTP (01.23).pdf', 'compliance/Real Estate Insurance NTP (01.23).pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('5d7f6864-494f-4934-9979-e24907ceff53', '731b3369-8d8a-4506-9946-ff45c139e31c', 'compliance', 'Real Estate Policy (01.23).pdf', 'compliance/Real Estate Policy (01.23).pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('9637a193-b1b6-428b-abca-b70a74f1394a', '731b3369-8d8a-4506-9946-ff45c139e31c', 'compliance', 'Summary of Cover (01.23).pdf', 'compliance/Summary of Cover (01.23).pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('0e1c16fc-74c4-4d8d-bedc-3f6ff38d9385', '731b3369-8d8a-4506-9946-ff45c139e31c', 'compliance', '32-34 Connaught Sq Buildings Insurance 2023-2024.pdf', 'compliance/32-34 Connaught Sq Buildings Insurance 2023-2024.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('04ba0961-65f6-40bb-b1a3-d6b9ccbad38a', '731b3369-8d8a-4506-9946-ff45c139e31c', 'compliance', 'Policy Limits Document.pdf', 'compliance/Policy Limits Document.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('c8adf046-55d1-4440-97be-95f4ed24302f', '731b3369-8d8a-4506-9946-ff45c139e31c', 'compliance', 'Zurich Real Estate Policy Summary.pdf', 'compliance/Zurich Real Estate Policy Summary.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('1f0f1ee4-730b-4caf-8122-7ff7410c30b6', '731b3369-8d8a-4506-9946-ff45c139e31c', 'compliance', 'Zurich Real Estate Policy Wording.pdf', 'compliance/Zurich Real Estate Policy Wording.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('25f51d8a-ad29-41ad-8fa5-c7a98f47caf1', '731b3369-8d8a-4506-9946-ff45c139e31c', 'compliance', 'Zurich Real Estate Insurance NTP (01.23) ZCYP895.02.pdf', 'compliance/Zurich Real Estate Insurance NTP (01.23) ZCYP895.02.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('a67ea0e0-220d-49cc-83f5-8aec2126125d', '731b3369-8d8a-4506-9946-ff45c139e31c', 'other', 'StG_Invoice_32-34 Connaught Square W2 2HL.pdf', 'finance/StG_Invoice_32-34 Connaught Square W2 2HL.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('8f390f13-9d82-4d80-aa7c-f0bd8119e38e', '731b3369-8d8a-4506-9946-ff45c139e31c', 'compliance', 'StG_Certificate_32-34 Connaught Square W2 2HL.pdf', 'compliance/StG_Certificate_32-34 Connaught Square W2 2HL.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('08aa09d0-ff59-4f40-b7e4-4dc472ec58e4', '731b3369-8d8a-4506-9946-ff45c139e31c', 'compliance', 'StG_Supporting Docs_32-34 Connaught Square W2 2HL.pdf', 'compliance/StG_Supporting Docs_32-34 Connaught Square W2 2HL.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('8f475e99-1993-48b9-935b-fc79c9fa6fa0', '731b3369-8d8a-4506-9946-ff45c139e31c', 'other', 'StG_Invoice_32-34 Connaught Square W2 2HL.pdf', 'finance/StG_Invoice_32-34 Connaught Square W2 2HL.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('6fbfb48c-ceb9-4a93-8592-1aec7edb8578', '731b3369-8d8a-4506-9946-ff45c139e31c', 'compliance', 'StG_Certificate_32-34 Connaught Square W2 2HL.pdf', 'compliance/StG_Certificate_32-34 Connaught Square W2 2HL.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('58e38ca2-6e9b-4ffd-88c3-39196279140b', '731b3369-8d8a-4506-9946-ff45c139e31c', 'compliance', 'StG_Statement of Fact_32-34 Connaught Square W2 2HL.pdf', 'compliance/StG_Statement of Fact_32-34 Connaught Square W2 2HL.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('85bae882-3ef4-4a21-aafa-74a42e9ca0ab', '731b3369-8d8a-4506-9946-ff45c139e31c', 'other', 'StG_Invoice_32-34 Connaught Square W2 2HL.pdf', 'finance/StG_Invoice_32-34 Connaught Square W2 2HL.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('e5f6b2a9-776e-4e3e-8d84-c9ba344b6e52', '731b3369-8d8a-4506-9946-ff45c139e31c', 'compliance', 'StG_Statement of Fact_32-34 Connaught Square W2 2HL.pdf', 'compliance/StG_Statement of Fact_32-34 Connaught Square W2 2HL.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('ebe52117-98d7-4805-bcc8-b4cb26326bed', '731b3369-8d8a-4506-9946-ff45c139e31c', 'uncategorised', 'Connaught Square New property information.xlsx', 'uncategorised/Connaught Square New property information.xlsx');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('2337bdef-7886-4d66-854a-c493530fd376', '731b3369-8d8a-4506-9946-ff45c139e31c', 'uncategorised', 'Connaught Square Meeting Minutes 2.docx', 'uncategorised/Connaught Square Meeting Minutes 2.docx');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('6920e077-3b77-475e-a88f-8c6c40e46141', '731b3369-8d8a-4506-9946-ff45c139e31c', 'uncategorised', 'connaught.xlsx', 'uncategorised/connaught.xlsx');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('e198535e-ae71-4726-ab8a-fca6bd82aa5d', '731b3369-8d8a-4506-9946-ff45c139e31c', 'uncategorised', 'matrix - pp.xlsx', 'uncategorised/matrix - pp.xlsx');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('a13a5069-83d0-4bd6-b52d-c4f20a962ca1', '731b3369-8d8a-4506-9946-ff45c139e31c', 'uncategorised', '12. Change of Tenancy - EDF supporting document.docx', 'uncategorised/12. Change of Tenancy - EDF supporting document.docx');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('cfc63134-1a16-4a8e-b660-2d650d78e933', '731b3369-8d8a-4506-9946-ff45c139e31c', 'correspondence', 'Correspondence letter.pdf', 'correspondence/Correspondence letter.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('663ea0c6-5fb7-4ec8-b200-da3e717d4efa', '731b3369-8d8a-4506-9946-ff45c139e31c', 'uncategorised', 'tenant list - pp.xlsx', 'uncategorised/tenant list - pp.xlsx');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('65376e3a-6731-49cd-8d75-cb23f8bc8208', '731b3369-8d8a-4506-9946-ff45c139e31c', 'uncategorised', 'Report - 32-34 Connaught Square BCH 78350.pdf', 'uncategorised/Report - 32-34 Connaught Square BCH 78350.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('bfbed4a3-f6f5-428c-a24c-d00ef710ee19', '731b3369-8d8a-4506-9946-ff45c139e31c', 'uncategorised', 'Connaught Square Meeting Minutes 2.docx', 'uncategorised/Connaught Square Meeting Minutes 2.docx');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('4e1b7c2a-c4df-4868-8583-ac1156861ef0', '731b3369-8d8a-4506-9946-ff45c139e31c', 'uncategorised', 'Connaught Square Meeting Minutes 20241120.docx', 'uncategorised/Connaught Square Meeting Minutes 20241120.docx');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('f52c0332-b3db-4b9a-b179-ae5f0a0a8849', '731b3369-8d8a-4506-9946-ff45c139e31c', 'uncategorised', 'Connaught Square Meeting Minutes.docx', 'uncategorised/Connaught Square Meeting Minutes.docx');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('6472478d-a209-44d3-bcf7-3d54d25f5687', '731b3369-8d8a-4506-9946-ff45c139e31c', 'uncategorised', 'Connaught Square Admin Duties of Co Sec.docx', 'uncategorised/Connaught Square Admin Duties of Co Sec.docx');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('b1e4dcf6-1034-45b2-b825-66d4dfdb4891', '731b3369-8d8a-4506-9946-ff45c139e31c', 'uncategorised', 'Signed Connaught Square Admin Duties of Co Sec.pdf', 'uncategorised/Signed Connaught Square Admin Duties of Co Sec.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('d967349e-04f5-4168-84ce-c40581336a99', '731b3369-8d8a-4506-9946-ff45c139e31c', 'uncategorised', '32_34 CONNAUGHT SQUARE FREEHOLD LIMITED - Statutory Registers on 22.03.2024.pdf', 'uncategorised/32_34 CONNAUGHT SQUARE FREEHOLD LIMITED - Statutory Registers on 22.03.2024.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('04cf9ec2-f14c-4532-af03-5a997efa6d08', '731b3369-8d8a-4506-9946-ff45c139e31c', 'correspondence', 'Memorandum of Association.pdf', 'correspondence/Memorandum of Association.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('535cabf9-44fd-427e-98b0-e22a54450fff', '731b3369-8d8a-4506-9946-ff45c139e31c', 'uncategorised', 'Incorporation documents.pdf', 'uncategorised/Incorporation documents.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('4c80a627-9656-4f69-9b05-f182d2e52b34', '731b3369-8d8a-4506-9946-ff45c139e31c', 'uncategorised', 'B25676 RS 21.05.24 RM CM.pdf', 'uncategorised/B25676 RS 21.05.24 RM CM.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('d94d898e-df85-4466-81d2-258c3f615e93', '731b3369-8d8a-4506-9946-ff45c139e31c', 'uncategorised', 'Report-20.08.2024.pdf', 'uncategorised/Report-20.08.2024.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('67f6fe80-0287-4e6e-bc14-b246a21f0cd8', '731b3369-8d8a-4506-9946-ff45c139e31c', 'correspondence', 'PN0119V1.7 Privacy Notice (Website).pdf', 'correspondence/PN0119V1.7 Privacy Notice (Website).pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('70d5b2fb-2a86-44ec-8aa2-2da9e798574b', '731b3369-8d8a-4506-9946-ff45c139e31c', 'correspondence', 'PN0119V1.8 Privacy Notice (Website).pdf', 'correspondence/PN0119V1.8 Privacy Notice (Website).pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('3f85135e-c245-4620-b322-1c0f4d302823', '731b3369-8d8a-4506-9946-ff45c139e31c', 'uncategorised', 'REPORT 31-07-25.pdf', 'uncategorised/REPORT 31-07-25.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('c5156582-badb-41e8-b5e7-d54d307adbf3', '731b3369-8d8a-4506-9946-ff45c139e31c', 'uncategorised', '32-34 Connought Square Condtion Assessments.pdf', 'uncategorised/32-34 Connought Square Condtion Assessments.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('eec56ddc-884d-4243-9745-11dcaf61d33a', '731b3369-8d8a-4506-9946-ff45c139e31c', 'uncategorised', 'Signed Conract.pdf', 'uncategorised/Signed Conract.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('3edecb75-0523-4a0b-bf0e-806f7bbf61c4', '731b3369-8d8a-4506-9946-ff45c139e31c', 'uncategorised', 'BLENHEIMS, CONNAUGHT, W2 2HL PHOTO - 22.01.24.pdf', 'uncategorised/BLENHEIMS, CONNAUGHT, W2 2HL PHOTO - 22.01.24.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('c8fcb293-ac7b-4530-a25e-18b375bb0dbc', '731b3369-8d8a-4506-9946-ff45c139e31c', 'uncategorised', 'BLENHEIMS, CONNAUGHT, W2 2HL PHOTO - 22.03.24.pdf', 'uncategorised/BLENHEIMS, CONNAUGHT, W2 2HL PHOTO - 22.03.24.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('7696d729-4bbc-4cc7-a75d-5ee7a91a3a3e', '731b3369-8d8a-4506-9946-ff45c139e31c', 'uncategorised', 'Latest Report.pdf', 'uncategorised/Latest Report.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('ea4ae403-fd7d-4127-9e1f-2991caf91430', '731b3369-8d8a-4506-9946-ff45c139e31c', 'uncategorised', 'Latest Report 24.04.2024.pdf', 'uncategorised/Latest Report 24.04.2024.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('5edd861b-4d3f-4f67-b5fa-06bd2d6f0eae', '731b3369-8d8a-4506-9946-ff45c139e31c', 'uncategorised', 'Latest Report 19.09.2024.pdf', 'uncategorised/Latest Report 19.09.2024.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('85595e14-df31-4204-974e-b5747b74a7ad', '731b3369-8d8a-4506-9946-ff45c139e31c', 'uncategorised', 'BLENHEIMS, 32-34 CONNAUGHT, W2 2HL - 25.09.23.pdf', 'uncategorised/BLENHEIMS, 32-34 CONNAUGHT, W2 2HL - 25.09.23.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('d840b004-9b95-4335-990d-e6a967afb942', '731b3369-8d8a-4506-9946-ff45c139e31c', 'uncategorised', 'BLENHEIMS, 32-34 CONNAUGHT, W2 2HL PHOTO - 29.11.23.pdf', 'uncategorised/BLENHEIMS, 32-34 CONNAUGHT, W2 2HL PHOTO - 29.11.23.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('117be224-5419-44b2-bbdc-9da412c8a3e6', '731b3369-8d8a-4506-9946-ff45c139e31c', 'uncategorised', 'BLENHEIMS, 32-34 CONNAUGHT, W2 2HL PHOTO - 18.12.23.pdf', 'uncategorised/BLENHEIMS, 32-34 CONNAUGHT, W2 2HL PHOTO - 18.12.23.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('cff7da65-f2cf-4b9f-bc46-721385e7191a', '731b3369-8d8a-4506-9946-ff45c139e31c', 'uncategorised', 'BLENHEIMS, CONNAUGHT, W2 2HL PHOTO - 23.02.24.pdf', 'uncategorised/BLENHEIMS, CONNAUGHT, W2 2HL PHOTO - 23.02.24.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('1ff3215e-e8a0-4d9d-ae6f-49a799db2211', '731b3369-8d8a-4506-9946-ff45c139e31c', 'uncategorised', '10.02.25-Pest Control.pdf', 'uncategorised/10.02.25-Pest Control.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('57233fd3-ba90-43a1-a79a-7288c6f9a26b', '731b3369-8d8a-4506-9946-ff45c139e31c', 'uncategorised', 'Latest Report.pdf', 'uncategorised/Latest Report.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('6e1ed864-d057-4c19-822a-c5cb983327bb', '731b3369-8d8a-4506-9946-ff45c139e31c', 'uncategorised', '17.01.2025-Pest Control.pdf', 'uncategorised/17.01.2025-Pest Control.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('9a4d0dc6-8a1d-424a-9ac5-c652bf0cafd6', '731b3369-8d8a-4506-9946-ff45c139e31c', 'uncategorised', 'J18503 - MIH, CONNAUGHT SQR, W2 - 04.04.25.pdf', 'uncategorised/J18503 - MIH, CONNAUGHT SQR, W2 - 04.04.25.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('bbf0de17-32fa-495e-9834-4b28ed796051', '731b3369-8d8a-4506-9946-ff45c139e31c', 'uncategorised', 'J18502 - MIH, CONNAUGHT SQR, W2 - 04.04.25.pdf', 'uncategorised/J18502 - MIH, CONNAUGHT SQR, W2 - 04.04.25.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('663f3ccd-71d2-436a-a75a-d603a654de02', '731b3369-8d8a-4506-9946-ff45c139e31c', 'uncategorised', 'BLENHEIMS, CONNAUGHT, W2 2HL PHOTO - 22.01.24.pdf', 'uncategorised/BLENHEIMS, CONNAUGHT, W2 2HL PHOTO - 22.01.24.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('7fff55b8-3258-4d60-99bb-16eae1ae9d89', '731b3369-8d8a-4506-9946-ff45c139e31c', 'uncategorised', 'BLENHEIMS, CONNAUGHT, W2 2HL PHOTO - 22.03.24.pdf', 'uncategorised/BLENHEIMS, CONNAUGHT, W2 2HL PHOTO - 22.03.24.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('ef4337c5-4828-4d80-b349-cc8f7fe2170b', '731b3369-8d8a-4506-9946-ff45c139e31c', 'uncategorised', 'BLENHEIMS, 32-34 CONNAUGHT, W2 2HL - 25.09.23.pdf', 'uncategorised/BLENHEIMS, 32-34 CONNAUGHT, W2 2HL - 25.09.23.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('2241c0ab-528e-481f-9038-d917210e62b6', '731b3369-8d8a-4506-9946-ff45c139e31c', 'uncategorised', 'BLENHEIMS, 32-34 CONNAUGHT, W2 2HL PHOTO - 29.11.23.pdf', 'uncategorised/BLENHEIMS, 32-34 CONNAUGHT, W2 2HL PHOTO - 29.11.23.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('a20186c7-bf3a-4dd2-a38f-15694b9a22f7', '731b3369-8d8a-4506-9946-ff45c139e31c', 'uncategorised', 'BLENHEIMS, 32-34 CONNAUGHT, W2 2HL PHOTO - 18.12.23.pdf', 'uncategorised/BLENHEIMS, 32-34 CONNAUGHT, W2 2HL PHOTO - 18.12.23.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('82ac4490-00b8-4da1-90fb-0e509140db86', '731b3369-8d8a-4506-9946-ff45c139e31c', 'uncategorised', 'BLENHEIMS, CONNAUGHT, W2 2HL PHOTO - 23.02.24.pdf', 'uncategorised/BLENHEIMS, CONNAUGHT, W2 2HL PHOTO - 23.02.24.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('00d0a34c-07be-459e-a55c-dcedc8a95d77', '731b3369-8d8a-4506-9946-ff45c139e31c', 'uncategorised', 'INV 11546 Mr Martin Samworth.xlsx', 'uncategorised/INV 11546 Mr Martin Samworth.xlsx');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('6576daad-eb13-4962-b2f7-f69d74ba9239', '731b3369-8d8a-4506-9946-ff45c139e31c', 'uncategorised', 'QB4126 Mr Martin Samworth.docx', 'uncategorised/QB4126 Mr Martin Samworth.docx');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('7c42f749-e8cd-45d7-a377-edf86c695f56', '731b3369-8d8a-4506-9946-ff45c139e31c', 'uncategorised', 'CQ2879 Mr Martin Samworth   (IP) CCTV.docx', 'uncategorised/CQ2879 Mr Martin Samworth   (IP) CCTV.docx');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('159c412b-bd57-4114-aee9-08c2c3e8b423', '731b3369-8d8a-4506-9946-ff45c139e31c', 'uncategorised', 'Asset_Record_For_Job_No_32810_17-03-2025_1311.pdf', 'uncategorised/Asset_Record_For_Job_No_32810_17-03-2025_1311.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('a48131bd-f74f-454e-9c00-86ba16bbbc4e', '731b3369-8d8a-4506-9946-ff45c139e31c', 'uncategorised', 'Asset_Record_For_Job_No_32344_12-03-2025_1426.pdf', 'uncategorised/Asset_Record_For_Job_No_32344_12-03-2025_1426.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('0351ff15-c249-4445-bf3e-686171ad8356', '731b3369-8d8a-4506-9946-ff45c139e31c', 'uncategorised', 'Asset_Record_For_Job_No_37675_25-07-2025_1549.pdf', 'uncategorised/Asset_Record_For_Job_No_37675_25-07-2025_1549.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('3cea64b8-bd71-48b5-9083-a92a91228004', '731b3369-8d8a-4506-9946-ff45c139e31c', 'uncategorised', 'Asset_Record_For_Job_No_34012_01-05-2025_1616.pdf', 'uncategorised/Asset_Record_For_Job_No_34012_01-05-2025_1616.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('887e1114-add2-40d4-8c6b-50de7f6f3bfe', '731b3369-8d8a-4506-9946-ff45c139e31c', 'uncategorised', 'Asset_Record_For_Job_No_32759_17-03-2025_1147.pdf', 'uncategorised/Asset_Record_For_Job_No_32759_17-03-2025_1147.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('cfac1d87-8386-4403-97f6-c6c6dd075bc1', '731b3369-8d8a-4506-9946-ff45c139e31c', 'uncategorised', 'Jobcard_For_Job_No_32344_12-03-2025_1426.pdf', 'uncategorised/Jobcard_For_Job_No_32344_12-03-2025_1426.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('8130d59a-75ae-465b-9919-ece9ce1e0b4e', '731b3369-8d8a-4506-9946-ff45c139e31c', 'uncategorised', 'Asset_Record_For_Job_No_33844_07-04-2025_1143.pdf', 'uncategorised/Asset_Record_For_Job_No_33844_07-04-2025_1143.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('c286fa11-0389-497a-8931-c9052fd79ea4', '731b3369-8d8a-4506-9946-ff45c139e31c', 'uncategorised', 'Asset_Record_For_Job_No_25732_03-10-2024_1337.pdf', 'uncategorised/Asset_Record_For_Job_No_25732_03-10-2024_1337.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('ea6b8ee9-baf2-458c-b6c1-c4900cb62557', '731b3369-8d8a-4506-9946-ff45c139e31c', 'uncategorised', 'Asset_Record_For_Job_No_22634_03-07-2024_1650.pdf', 'uncategorised/Asset_Record_For_Job_No_22634_03-07-2024_1650.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('155e6b1d-49fc-4bfc-b2d0-11a9687e99e1', '731b3369-8d8a-4506-9946-ff45c139e31c', 'uncategorised', 'Asset_Record_For_Job_No_27067_07-10-2024_1147.pdf', 'uncategorised/Asset_Record_For_Job_No_27067_07-10-2024_1147.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('98a15df3-6c8f-4429-8505-a28a496a2d49', '731b3369-8d8a-4506-9946-ff45c139e31c', 'uncategorised', 'Asset_Record_For_Job_No_19665_05-04-2024_1048.pdf', 'uncategorised/Asset_Record_For_Job_No_19665_05-04-2024_1048.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('4b141e99-811e-4b1b-afd7-c75fcc626aab', '731b3369-8d8a-4506-9946-ff45c139e31c', 'other', 'Connaught Square-Lift Quotes.xlsx', 'contracts/Connaught Square-Lift Quotes.xlsx');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('55628b3b-8d7f-4ec2-825f-8a3974bbef7d', '731b3369-8d8a-4506-9946-ff45c139e31c', 'uncategorised', 'LXBI3559280XB2-NEW STEP-Business-Certificate of el insurance.pdf', 'uncategorised/LXBI3559280XB2-NEW STEP-Business-Certificate of el insurance.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('e5356dc4-e689-46dd-876f-5e7f41301ca3', '731b3369-8d8a-4506-9946-ff45c139e31c', 'uncategorised', 'New Step - Cleaning of Com Part- Jan- 2023.pdf', 'uncategorised/New Step - Cleaning of Com Part- Jan- 2023.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('14a94c3e-0e25-47b7-b80f-2d497c9f9459', '731b3369-8d8a-4506-9946-ff45c139e31c', 'uncategorised', 'Aged debtors by property.pdf', 'uncategorised/Aged debtors by property.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('65af0be3-e316-4ad9-9ac5-c284e86e5160', '731b3369-8d8a-4506-9946-ff45c139e31c', 'uncategorised', 'Connaught Square, 32-34 Approved xlsx.xlsx', 'uncategorised/Connaught Square, 32-34 Approved xlsx.xlsx');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('e6104429-e2fe-488e-a400-056c41ac5249', '731b3369-8d8a-4506-9946-ff45c139e31c', 'uncategorised', 'BvA 24 Jan 25.xlsx', 'uncategorised/BvA 24 Jan 25.xlsx');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('9877c583-731c-4907-82f5-3e9fb3d1cc72', '731b3369-8d8a-4506-9946-ff45c139e31c', 'uncategorised', 'pdf.pdf', 'uncategorised/pdf.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('1617ea56-a4a6-4fd8-bb69-67675d698a0c', '731b3369-8d8a-4506-9946-ff45c139e31c', 'uncategorised', 'Connaught Square-Agenda 20.11.24.docx', 'uncategorised/Connaught Square-Agenda 20.11.24.docx');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('77a4f66a-ae44-48ee-a5e2-fa748826a10f', '731b3369-8d8a-4506-9946-ff45c139e31c', 'uncategorised', 'Connaught Square-Agenda 26.04.2024.docx', 'uncategorised/Connaught Square-Agenda 26.04.2024.docx');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('b6293772-b182-4af0-a9a1-0a54bc013877', '731b3369-8d8a-4506-9946-ff45c139e31c', 'uncategorised', 'Connaught Square 26.04.24.docx', 'uncategorised/Connaught Square 26.04.24.docx');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('13f40281-3d10-48e5-b2fa-ff15b1cdd83a', '731b3369-8d8a-4506-9946-ff45c139e31c', 'other', 'StG_Quote_32-34 Connaught Square W2 2HL.pdf', 'contracts/StG_Quote_32-34 Connaught Square W2 2HL.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('c338a4e5-dade-4008-a507-b7181ff150c0', '731b3369-8d8a-4506-9946-ff45c139e31c', 'uncategorised', 'StG_Policy Wording_32-34 Connaught Square W2 2HL.pdf', 'uncategorised/StG_Policy Wording_32-34 Connaught Square W2 2HL.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('6dd2b4ec-af90-414b-886d-355d45a1480d', '731b3369-8d8a-4506-9946-ff45c139e31c', 'other', 'StG_Quote_32-34 Connaught Square W2 2HL.pdf', 'contracts/StG_Quote_32-34 Connaught Square W2 2HL.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('c6f1ac2a-b4e0-460e-8d63-cd735ce1814c', '731b3369-8d8a-4506-9946-ff45c139e31c', 'uncategorised', 'StG_Policy Wording_32-34 Connaught Square W2 2HL.pdf', 'uncategorised/StG_Policy Wording_32-34 Connaught Square W2 2HL.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('d9133ede-7c5d-43b6-b95e-1c50ef0584e6', '731b3369-8d8a-4506-9946-ff45c139e31c', 'uncategorised', 'Report - 32-34 Connaught Square BCH 78350.pdf', 'uncategorised/Report - 32-34 Connaught Square BCH 78350.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('8e37b6c5-c28a-4f1b-8e7a-9159a667c740', '731b3369-8d8a-4506-9946-ff45c139e31c', 'uncategorised', 'Asset_Record_For_Job_No_16617_27-11-2023_1522.pdf', 'uncategorised/Asset_Record_For_Job_No_16617_27-11-2023_1522.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('75f17026-dd25-4a71-96a4-4c3444b799f8', '731b3369-8d8a-4506-9946-ff45c139e31c', 'uncategorised', 'Asset_Record_For_Job_No_16808_28-11-2023_1340.pdf', 'uncategorised/Asset_Record_For_Job_No_16808_28-11-2023_1340.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('0dd1beb3-1086-47cb-b527-1c388c7e6980', '731b3369-8d8a-4506-9946-ff45c139e31c', 'uncategorised', 'EX-NC (CONNAUGHT SQUARE) EXTRA 01102024.pdf', 'uncategorised/EX-NC (CONNAUGHT SQUARE) EXTRA 01102024.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('a9ea4989-bc45-4008-8f47-5fb28cd50053', '731b3369-8d8a-4506-9946-ff45c139e31c', 'uncategorised', 'H&S recomendations - Spreadsheet with comments.xlsx', 'uncategorised/H&S recomendations - Spreadsheet with comments.xlsx');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('99be30d4-cb54-46ad-b03b-3ff66ad54371', '731b3369-8d8a-4506-9946-ff45c139e31c', 'uncategorised', 'CM434 RS 32-34 Connaught Square - VISIT 1 OF 2 - 30-04-25.pdf', 'uncategorised/CM434 RS 32-34 Connaught Square - VISIT 1 OF 2 - 30-04-25.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('dfaf5446-8065-4bdf-a54d-78eff305e4d6', '731b3369-8d8a-4506-9946-ff45c139e31c', 'uncategorised', 'Q49511 - 32-34 Connaught Square.pdf', 'uncategorised/Q49511 - 32-34 Connaught Square.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('889d1c5c-1afe-45d4-9d43-6dff16b7695b', '731b3369-8d8a-4506-9946-ff45c139e31c', 'uncategorised', 'FA7817 CALL OUT 26032025.pdf', 'uncategorised/FA7817 CALL OUT 26032025.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('229b1fc5-bafd-4511-9524-9cb8c56190ab', '731b3369-8d8a-4506-9946-ff45c139e31c', 'uncategorised', '32 Connaught Sq - PAT .pdf', 'uncategorised/32 Connaught Sq - PAT .pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('28522e57-f8ea-433c-8020-ebf6b936d789', '731b3369-8d8a-4506-9946-ff45c139e31c', 'uncategorised', 'Asset_Record_For_Job_No_35146_03-06-2025_0906.pdf', 'uncategorised/Asset_Record_For_Job_No_35146_03-06-2025_0906.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('85d4f7ba-76b4-45ca-84e0-900ca8eeb1b0', '731b3369-8d8a-4506-9946-ff45c139e31c', 'uncategorised', 'Asset_Record_For_Job_No_31162_30-01-2025_1603.pdf', 'uncategorised/Asset_Record_For_Job_No_31162_30-01-2025_1603.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('a2335887-1ab1-4fb0-8368-334826726ac4', '731b3369-8d8a-4506-9946-ff45c139e31c', 'uncategorised', 'Asset_Record_For_Job_No_37675_25-07-2025_1549.pdf', 'uncategorised/Asset_Record_For_Job_No_37675_25-07-2025_1549.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('b51b5b8c-3122-4599-9381-36ba8afe8d42', '731b3369-8d8a-4506-9946-ff45c139e31c', 'uncategorised', 'Asset_Record_For_Job_No_28737_25-11-2024_0907.pdf', 'uncategorised/Asset_Record_For_Job_No_28737_25-11-2024_0907.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('641662a8-bf96-4a83-aae7-a71d838b0327', '731b3369-8d8a-4506-9946-ff45c139e31c', 'uncategorised', 'Asset_Record_For_Job_No_35402_03-06-2025_0916.pdf', 'uncategorised/Asset_Record_For_Job_No_35402_03-06-2025_0916.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('43679da1-3d81-45ff-9907-04c76e383072', '731b3369-8d8a-4506-9946-ff45c139e31c', 'uncategorised', 'Asset_Record_For_Job_No_22171_14-05-2024_1202.pdf', 'uncategorised/Asset_Record_For_Job_No_22171_14-05-2024_1202.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('39c40915-212d-418c-84f0-45b400466b1b', '731b3369-8d8a-4506-9946-ff45c139e31c', 'uncategorised', 'Asset_Record_For_Job_No_35654_03-06-2025_0912.pdf', 'uncategorised/Asset_Record_For_Job_No_35654_03-06-2025_0912.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('4a0ce6e7-75fd-4d6d-8f51-3ef5bc00765d', '731b3369-8d8a-4506-9946-ff45c139e31c', 'uncategorised', 'Asset_Record_For_Job_No_38609_26-08-2025_0740.pdf', 'uncategorised/Asset_Record_For_Job_No_38609_26-08-2025_0740.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('293aab17-b6a9-41ec-b566-a56999685061', '731b3369-8d8a-4506-9946-ff45c139e31c', 'uncategorised', 'Asset_Record_For_Job_No_36465_20-06-2025_1038.pdf', 'uncategorised/Asset_Record_For_Job_No_36465_20-06-2025_1038.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('89da0b9f-f979-4dfc-8e5c-12684704a5a8', '731b3369-8d8a-4506-9946-ff45c139e31c', 'uncategorised', '26368 Report.pdf', 'uncategorised/26368 Report.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, file_path) VALUES ('380dc1a1-db5c-42ef-8a25-3b75a0d80817', '731b3369-8d8a-4506-9946-ff45c139e31c', 'uncategorised', '26474 Report.pdf', 'uncategorised/26474 Report.pdf');

-- Insert 26 apportionments
INSERT INTO apportionments (id, building_id, percentage) VALUES ('352d8d08-f924-45eb-85d3-e7c60da67761', '731b3369-8d8a-4506-9946-ff45c139e31c', 32.0);
INSERT INTO apportionments (id, building_id, percentage) VALUES ('68a50ada-eea0-4712-a50d-2c0c8ebb0e78', '731b3369-8d8a-4506-9946-ff45c139e31c', 10.0);
INSERT INTO apportionments (id, building_id, percentage) VALUES ('c981dc0b-ee25-4f20-900c-13ac9e7ff539', '731b3369-8d8a-4506-9946-ff45c139e31c', 32.0);
INSERT INTO apportionments (id, building_id, percentage) VALUES ('0e49ce8d-2c1f-43e9-9d93-e7105f9f8db3', '731b3369-8d8a-4506-9946-ff45c139e31c', 19.0);
INSERT INTO apportionments (id, building_id, percentage) VALUES ('9938ba9e-1e8d-4712-bf09-ac231c421f4f', '731b3369-8d8a-4506-9946-ff45c139e31c', 2.0);
INSERT INTO apportionments (id, building_id, percentage) VALUES ('786efe29-4610-46c8-a105-6f3a52956023', '731b3369-8d8a-4506-9946-ff45c139e31c', 2.0);
INSERT INTO apportionments (id, building_id, percentage) VALUES ('688ba6d7-a880-4f1c-bf9f-06b29c2a7a84', '731b3369-8d8a-4506-9946-ff45c139e31c', 2.0);
INSERT INTO apportionments (id, building_id, percentage) VALUES ('e9fbe4fc-1991-4d9a-838a-57afa637b0f9', '731b3369-8d8a-4506-9946-ff45c139e31c', 2.0);
INSERT INTO apportionments (id, building_id, percentage) VALUES ('d41c84d6-d856-4459-bf97-5aba989d2454', '731b3369-8d8a-4506-9946-ff45c139e31c', 2.0);
INSERT INTO apportionments (id, building_id, percentage) VALUES ('372cbdf9-a052-4e63-9b01-a7de181d8133', '731b3369-8d8a-4506-9946-ff45c139e31c', 8.0);
INSERT INTO apportionments (id, building_id, percentage) VALUES ('d6c868d6-2fcc-4a87-834d-86a3d75e56be', '731b3369-8d8a-4506-9946-ff45c139e31c', 3.0);
INSERT INTO apportionments (id, building_id, percentage) VALUES ('d7320891-16f6-4911-962a-9a69e06c0b71', '731b3369-8d8a-4506-9946-ff45c139e31c', 3.0);
INSERT INTO apportionments (id, building_id, percentage) VALUES ('86652670-f0bf-4b62-9c08-83f65c849818', '731b3369-8d8a-4506-9946-ff45c139e31c', 3.0);
INSERT INTO apportionments (id, building_id, percentage) VALUES ('22cf1056-4757-4df1-93cc-b197b7d829fa', '731b3369-8d8a-4506-9946-ff45c139e31c', 3.0);
INSERT INTO apportionments (id, building_id, percentage) VALUES ('2215ba90-b826-4e26-81e5-22ae7e145f62', '731b3369-8d8a-4506-9946-ff45c139e31c', 3.0);
INSERT INTO apportionments (id, building_id, percentage) VALUES ('10154531-8957-4882-8b0b-baccd1f69229', '731b3369-8d8a-4506-9946-ff45c139e31c', 3.0);
INSERT INTO apportionments (id, building_id, percentage) VALUES ('16227929-1e3c-4e71-81b3-58ea0a737cdd', '731b3369-8d8a-4506-9946-ff45c139e31c', 3.0);
INSERT INTO apportionments (id, building_id, percentage) VALUES ('f92447f3-d75c-4029-999a-7d6639bdeb2c', '731b3369-8d8a-4506-9946-ff45c139e31c', 3.0);
INSERT INTO apportionments (id, building_id, percentage) VALUES ('7b7bec03-48af-4ba4-8061-77b16b069241', '731b3369-8d8a-4506-9946-ff45c139e31c', 8.0);
INSERT INTO apportionments (id, building_id, percentage) VALUES ('374309c7-7c5c-47b4-9624-7ce8807a163f', '731b3369-8d8a-4506-9946-ff45c139e31c', 3.0);
INSERT INTO apportionments (id, building_id, percentage) VALUES ('d4c815cf-1ad7-4532-a53c-3dae933d744c', '731b3369-8d8a-4506-9946-ff45c139e31c', 8.0);
INSERT INTO apportionments (id, building_id, percentage) VALUES ('2189ef4f-a44f-42bc-9cc0-d3da36d77f76', '731b3369-8d8a-4506-9946-ff45c139e31c', 8.0);
INSERT INTO apportionments (id, building_id, percentage) VALUES ('85f0d435-ed81-4c37-8647-9a572de463e7', '731b3369-8d8a-4506-9946-ff45c139e31c', 8.0);
INSERT INTO apportionments (id, building_id, percentage) VALUES ('86900d34-741e-4385-8287-371a4405262d', '731b3369-8d8a-4506-9946-ff45c139e31c', 8.0);
INSERT INTO apportionments (id, building_id, percentage) VALUES ('8c15c39b-ce90-4184-9e98-0208ace5e8fa', '731b3369-8d8a-4506-9946-ff45c139e31c', 8.0);
INSERT INTO apportionments (id, building_id, percentage) VALUES ('607ed74f-80df-4e22-86c9-7d9eb0e62aa7', '731b3369-8d8a-4506-9946-ff45c139e31c', 8.0);

-- Insert 131 insurance records
INSERT INTO building_insurance (id, building_id, policy_number, insurance_type) VALUES ('79414e16-cc4f-4d01-93e0-c1373253b558', '731b3369-8d8a-4506-9946-ff45c139e31c', 'CGBI3964546XB', 'general');
INSERT INTO building_insurance (id, building_id, policy_number, insurance_type) VALUES ('5829c144-7473-4767-b1c0-cfd57dbc2ca4', '731b3369-8d8a-4506-9946-ff45c139e31c', 'CGBI3964546XB', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('39bfcdef-97bb-4b6d-8ec2-b007625cbdb6', '731b3369-8d8a-4506-9946-ff45c139e31c', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('d44c3a9c-0ab3-473b-b0b5-e574204fbe65', '731b3369-8d8a-4506-9946-ff45c139e31c', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('74d1ab5a-7059-4d70-9fdb-7e4c58cfbd1f', '731b3369-8d8a-4506-9946-ff45c139e31c', 'general');
INSERT INTO building_insurance (id, building_id, policy_number, insurance_type) VALUES ('619369da-79da-43e6-b7dd-1766a2a57794', '731b3369-8d8a-4506-9946-ff45c139e31c', 'and', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('fec978c5-41b4-44c1-a63b-c0cf1ae75b1f', '731b3369-8d8a-4506-9946-ff45c139e31c', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('0c0527ac-7faa-4713-8be5-ab0a5f66686f', '731b3369-8d8a-4506-9946-ff45c139e31c', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('841041ea-6d24-4fd5-93dc-830095114d48', '731b3369-8d8a-4506-9946-ff45c139e31c', 'general');
INSERT INTO building_insurance (id, building_id, policy_number, insurance_type) VALUES ('b883d60f-71f3-48b9-b3ef-503294379153', '731b3369-8d8a-4506-9946-ff45c139e31c', 'NZ23346712', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('43605605-7a9b-4295-84dd-9c48b593372b', '731b3369-8d8a-4506-9946-ff45c139e31c', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('c09f58c6-7118-4e94-9b8f-c1efbfe8b65e', '731b3369-8d8a-4506-9946-ff45c139e31c', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('d79a2575-4418-4705-ba94-fa0867f6d809', '731b3369-8d8a-4506-9946-ff45c139e31c', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('aa494d7f-81a7-4964-bbb3-b86ad27ae928', '731b3369-8d8a-4506-9946-ff45c139e31c', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('fd5ea46e-e609-4459-b24f-5964f1ad26e5', '731b3369-8d8a-4506-9946-ff45c139e31c', 'general');
INSERT INTO building_insurance (id, building_id, policy_number, insurance_type) VALUES ('704567a2-a4bb-49c4-bda8-2105be62728b', '731b3369-8d8a-4506-9946-ff45c139e31c', 'ARCH', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('641fb631-ca59-485e-a005-e9a7deafb56a', '731b3369-8d8a-4506-9946-ff45c139e31c', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('53b06814-79ea-4ded-b00c-46cf07af5704', '731b3369-8d8a-4506-9946-ff45c139e31c', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('17c3b2bf-a28e-4749-b947-6ee95c98166c', '731b3369-8d8a-4506-9946-ff45c139e31c', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('efaaf38b-d53b-488b-865e-b99058ee0318', '731b3369-8d8a-4506-9946-ff45c139e31c', 'general');
INSERT INTO building_insurance (id, building_id, policy_number, insurance_type) VALUES ('289ba7eb-ae8e-4ce6-8549-a825501ed3f6', '731b3369-8d8a-4506-9946-ff45c139e31c', 'FU117816', 'general');
INSERT INTO building_insurance (id, building_id, policy_number, insurance_type) VALUES ('0f8570cb-330e-4dc9-85e6-d92942754332', '731b3369-8d8a-4506-9946-ff45c139e31c', 'FU117816', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('ed9817ab-9088-494c-b7e7-dcacb28b634c', '731b3369-8d8a-4506-9946-ff45c139e31c', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('ff2b852a-ddbe-4249-8855-824beba10634', '731b3369-8d8a-4506-9946-ff45c139e31c', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('e4fee229-de77-4d5f-936c-bea018f6dc9b', '731b3369-8d8a-4506-9946-ff45c139e31c', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('dd880eda-d7f4-4446-8cca-90947fa9f26b', '731b3369-8d8a-4506-9946-ff45c139e31c', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('07c405f7-241f-4cce-a535-e283764068ab', '731b3369-8d8a-4506-9946-ff45c139e31c', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('c22b75d6-7178-4b5e-b2f8-e50d04eb382b', '731b3369-8d8a-4506-9946-ff45c139e31c', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('e90ca587-4093-4759-b3fa-60e622416af1', '731b3369-8d8a-4506-9946-ff45c139e31c', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('0bf5f19d-c3b7-44ec-a219-a099970db60c', '731b3369-8d8a-4506-9946-ff45c139e31c', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('f4d4c3e9-0780-4a36-b23e-5c023f5fcbe0', '731b3369-8d8a-4506-9946-ff45c139e31c', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('441f6b22-9499-4157-82b7-c9b93243d7d8', '731b3369-8d8a-4506-9946-ff45c139e31c', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('f0929aa4-aced-4946-b07a-03c93de23737', '731b3369-8d8a-4506-9946-ff45c139e31c', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('a157c51c-002a-4750-8447-bf81654a7844', '731b3369-8d8a-4506-9946-ff45c139e31c', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('0d765dbd-53a7-4228-bcb2-045c48de0eef', '731b3369-8d8a-4506-9946-ff45c139e31c', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('fbb255f6-069e-4a6d-ace4-c08e5c39cc6d', '731b3369-8d8a-4506-9946-ff45c139e31c', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('9a3a69d3-ae23-41d4-ba38-76813a3240cd', '731b3369-8d8a-4506-9946-ff45c139e31c', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('b7b6def0-dfd6-4a65-87d7-a86be87fb4d0', '731b3369-8d8a-4506-9946-ff45c139e31c', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('09a2dfed-865c-4613-9e1a-377d97554b85', '731b3369-8d8a-4506-9946-ff45c139e31c', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('501ab32e-f4e8-4335-909e-cb1787d3140c', '731b3369-8d8a-4506-9946-ff45c139e31c', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('6fe02906-a234-4168-bca7-c267a6b7c1b2', '731b3369-8d8a-4506-9946-ff45c139e31c', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('d3f7b187-7e45-4b15-b5df-d88637cc4aef', '731b3369-8d8a-4506-9946-ff45c139e31c', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('049218e7-0325-4b1e-aafe-06e4dec756d3', '731b3369-8d8a-4506-9946-ff45c139e31c', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('844e6195-e0ed-4df9-b72a-38354f97fcb7', '731b3369-8d8a-4506-9946-ff45c139e31c', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('2a35f563-10a1-427a-bb37-9eeb25aa2b28', '731b3369-8d8a-4506-9946-ff45c139e31c', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('4dcb9c27-d039-49d7-b7cf-5599ece28b55', '731b3369-8d8a-4506-9946-ff45c139e31c', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('342820d4-2de2-40e9-b9df-a8ecca84acd0', '731b3369-8d8a-4506-9946-ff45c139e31c', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('7eda722a-786d-4230-941b-ef0440c0667a', '731b3369-8d8a-4506-9946-ff45c139e31c', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('77006dbe-7602-4920-92f2-a485833931d1', '731b3369-8d8a-4506-9946-ff45c139e31c', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('6c66a7f8-d896-4228-a3b2-33d430dfbf2a', '731b3369-8d8a-4506-9946-ff45c139e31c', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('5e58eeb2-b6ac-4620-895a-f6fc51190efc', '731b3369-8d8a-4506-9946-ff45c139e31c', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('3977ebd8-6b1f-4286-a7eb-4ed815218812', '731b3369-8d8a-4506-9946-ff45c139e31c', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('53348291-eb95-4c38-b2ee-b30cd3f70a5f', '731b3369-8d8a-4506-9946-ff45c139e31c', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('516d0905-48b2-49d9-bbb0-c39d5f6221b0', '731b3369-8d8a-4506-9946-ff45c139e31c', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('956b3a72-0030-49ec-84f0-f4769a3babf4', '731b3369-8d8a-4506-9946-ff45c139e31c', 'general');
INSERT INTO building_insurance (id, building_id, policy_number, insurance_type) VALUES ('0df0e131-83e2-4d0a-b93c-4aa8c9bd9e77', '731b3369-8d8a-4506-9946-ff45c139e31c', 'LXBI3559280XB', 'general');
INSERT INTO building_insurance (id, building_id, policy_number, insurance_type) VALUES ('a45d8ba7-55b6-46a2-8137-3036a2721a39', '731b3369-8d8a-4506-9946-ff45c139e31c', 'LXBI3559280XB', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('56090f5a-1379-4375-9f4b-30d34df84b2c', '731b3369-8d8a-4506-9946-ff45c139e31c', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('5d7fa134-03aa-4139-a170-23dc792b0085', '731b3369-8d8a-4506-9946-ff45c139e31c', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('c3eb6b54-6b0c-4261-a61b-e48a9d6f1de2', '731b3369-8d8a-4506-9946-ff45c139e31c', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('49f157da-b071-4149-9033-e6e50c30a55c', '731b3369-8d8a-4506-9946-ff45c139e31c', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('75c2d438-5e01-4d11-8927-512354969b93', '731b3369-8d8a-4506-9946-ff45c139e31c', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('031409fa-b004-4256-8d6a-ef13e931190a', '731b3369-8d8a-4506-9946-ff45c139e31c', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('ec294735-6aff-4b30-a69c-689c03dabff2', '731b3369-8d8a-4506-9946-ff45c139e31c', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('bfc0e8c9-7259-4628-93d4-5737ae60f0da', '731b3369-8d8a-4506-9946-ff45c139e31c', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('168dd98e-7953-411a-9aa0-880d9665e234', '731b3369-8d8a-4506-9946-ff45c139e31c', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('b3dc96ce-53de-41d6-b1ad-bf70cbb457b1', '731b3369-8d8a-4506-9946-ff45c139e31c', 'general');
INSERT INTO building_insurance (id, building_id, policy_number, insurance_type) VALUES ('cff39557-78e0-4aec-b826-cc41e9417eae', '731b3369-8d8a-4506-9946-ff45c139e31c', 'NZ23346712', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('39060038-eceb-4929-8a01-51e1237cf362', '731b3369-8d8a-4506-9946-ff45c139e31c', 'general');
INSERT INTO building_insurance (id, building_id, policy_number, insurance_type) VALUES ('6fe8d034-9c54-437e-b32a-3d035124c483', '731b3369-8d8a-4506-9946-ff45c139e31c', 'and', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('7fb9d896-2446-4719-80a0-d0e7a38d915b', '731b3369-8d8a-4506-9946-ff45c139e31c', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('d933a7d2-51d6-4995-83ae-26aa684b8056', '731b3369-8d8a-4506-9946-ff45c139e31c', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('f71cb2af-c632-4dce-a95f-8091ac308a2c', '731b3369-8d8a-4506-9946-ff45c139e31c', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('ee93bc0e-4868-42d0-9d8d-fffef4778a27', '731b3369-8d8a-4506-9946-ff45c139e31c', 'general');
INSERT INTO building_insurance (id, building_id, policy_number, insurance_type) VALUES ('7f44e635-3d5b-428d-9192-7ec83c457198', '731b3369-8d8a-4506-9946-ff45c139e31c', 'STGLON', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('b49898b6-a788-4349-87ca-49fa7e4a3e98', '731b3369-8d8a-4506-9946-ff45c139e31c', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('faa558b3-b65b-4488-b127-36cbb70c5e11', '731b3369-8d8a-4506-9946-ff45c139e31c', 'general');
INSERT INTO building_insurance (id, building_id, policy_number, insurance_type) VALUES ('c633bd19-597a-44aa-be51-34309ddb0e40', '731b3369-8d8a-4506-9946-ff45c139e31c', 'STGLON', 'general');
INSERT INTO building_insurance (id, building_id, policy_number, insurance_type) VALUES ('fba6247b-5c99-46ea-907a-35ae132c0a3b', '731b3369-8d8a-4506-9946-ff45c139e31c', 'STGLON', 'general');
INSERT INTO building_insurance (id, building_id, policy_number, insurance_type) VALUES ('6c49ca69-2896-4a92-893d-1ca8427c9617', '731b3369-8d8a-4506-9946-ff45c139e31c', 'BERTSTGLON', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('e5171d13-c3f8-4d01-bfcb-8c503321b7ff', '731b3369-8d8a-4506-9946-ff45c139e31c', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('f1fda3bb-6dc3-4711-808f-901a7ad262dd', '731b3369-8d8a-4506-9946-ff45c139e31c', 'general');
INSERT INTO building_insurance (id, building_id, policy_number, insurance_type) VALUES ('d7f134ef-cc3c-44ee-9344-918e4838b01c', '731b3369-8d8a-4506-9946-ff45c139e31c', 'LP', 'general');
INSERT INTO building_insurance (id, building_id, policy_number, insurance_type) VALUES ('34d15eef-229f-4d14-b9ac-e15ca00dcf4e', '731b3369-8d8a-4506-9946-ff45c139e31c', 'HL', 'general');
INSERT INTO building_insurance (id, building_id, policy_number, insurance_type) VALUES ('f59b303c-3665-44aa-ab83-07b61d107443', '731b3369-8d8a-4506-9946-ff45c139e31c', 'ARCH', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('1c6e3b96-724d-42ef-9816-49c80925c889', '731b3369-8d8a-4506-9946-ff45c139e31c', 'general');
INSERT INTO building_insurance (id, building_id, policy_number, insurance_type) VALUES ('5503205a-2784-4b97-99c4-3503cccdcc7f', '731b3369-8d8a-4506-9946-ff45c139e31c', 'and', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('50ed8e45-1a5a-427f-9fca-8181f1a978e9', '731b3369-8d8a-4506-9946-ff45c139e31c', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('2eb88de9-1b00-4b36-a7a0-7d2bb3a62d11', '731b3369-8d8a-4506-9946-ff45c139e31c', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('18c73504-0a3e-421b-9a4d-81dbcbec7a59', '731b3369-8d8a-4506-9946-ff45c139e31c', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('145c218b-0776-4f86-b6de-66030b5da629', '731b3369-8d8a-4506-9946-ff45c139e31c', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('54713e14-7a7f-4a3b-b5bf-e11717b84b0f', '731b3369-8d8a-4506-9946-ff45c139e31c', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('9726278e-1469-47cd-8e81-5617ff674368', '731b3369-8d8a-4506-9946-ff45c139e31c', 'general');
INSERT INTO building_insurance (id, building_id, policy_number, insurance_type) VALUES ('360e54e3-5d85-41cc-bffc-871dea3538d0', '731b3369-8d8a-4506-9946-ff45c139e31c', 'and', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('de086d50-c07d-4312-a1be-7abfd4f0c822', '731b3369-8d8a-4506-9946-ff45c139e31c', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('8035e467-2ccb-4d42-8e23-0e1f5d2755fa', '731b3369-8d8a-4506-9946-ff45c139e31c', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('cb73b7ee-69ff-44c3-9a8b-e8ae019fe632', '731b3369-8d8a-4506-9946-ff45c139e31c', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('3bf1e557-a052-477f-b2ea-067d98ed5ee5', '731b3369-8d8a-4506-9946-ff45c139e31c', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('28442eec-7389-43c0-9bbc-52edd7eff76d', '731b3369-8d8a-4506-9946-ff45c139e31c', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('281b5a0f-f60b-40c3-95cc-7207619a23f5', '731b3369-8d8a-4506-9946-ff45c139e31c', 'general');
INSERT INTO building_insurance (id, building_id, policy_number, insurance_type) VALUES ('1b48c69f-05f7-4ded-92bc-fd6bb099d99f', '731b3369-8d8a-4506-9946-ff45c139e31c', 'and', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('9ed58cbd-1366-4844-a9ef-d1adb2883894', '731b3369-8d8a-4506-9946-ff45c139e31c', 'general');
INSERT INTO building_insurance (id, building_id, policy_number, insurance_type) VALUES ('cb7f2927-3882-4bb4-a165-538bbdde436a', '731b3369-8d8a-4506-9946-ff45c139e31c', 'BP13228-2501', 'general');
INSERT INTO building_insurance (id, building_id, policy_number, insurance_type) VALUES ('b7a1053b-6b21-40c1-b1fb-10e8515feadf', '731b3369-8d8a-4506-9946-ff45c139e31c', 'BP13228-2501', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('c5cf5584-063d-46a7-8847-4c4dc5128344', '731b3369-8d8a-4506-9946-ff45c139e31c', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('ea1b590f-4f3c-4a38-9bc2-7d5c98e7fc06', '731b3369-8d8a-4506-9946-ff45c139e31c', 'general');
INSERT INTO building_insurance (id, building_id, policy_number, insurance_type) VALUES ('6bf87245-2634-4b84-af79-61dafe5abd25', '731b3369-8d8a-4506-9946-ff45c139e31c', 'TA0604600', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('0369b64d-9c93-4b9c-b815-d6a3056d1d85', '731b3369-8d8a-4506-9946-ff45c139e31c', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('2c028cd8-b0af-4819-90b4-28b238cd96b0', '731b3369-8d8a-4506-9946-ff45c139e31c', 'general');
INSERT INTO building_insurance (id, building_id, policy_number, insurance_type) VALUES ('833d2133-472d-41cd-a61c-3203f67b995e', '731b3369-8d8a-4506-9946-ff45c139e31c', 'HL', 'general');
INSERT INTO building_insurance (id, building_id, policy_number, insurance_type) VALUES ('2ff597bf-39a0-4bb3-9cef-99ec83a237b1', '731b3369-8d8a-4506-9946-ff45c139e31c', 'Camberford', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('71d9b2ab-b117-4256-a410-816b3a1cb81e', '731b3369-8d8a-4506-9946-ff45c139e31c', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('b2f3a2ed-0a0e-406c-bc4b-9e3901a137f9', '731b3369-8d8a-4506-9946-ff45c139e31c', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('4fb448ba-4670-42dd-ad48-436dd29ab349', '731b3369-8d8a-4506-9946-ff45c139e31c', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('c5fcd730-0971-40e9-bb33-47ec4de39e29', '731b3369-8d8a-4506-9946-ff45c139e31c', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('7fdaed12-483d-492c-82c2-7e61b83d86fa', '731b3369-8d8a-4506-9946-ff45c139e31c', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('e3b09bcb-bc3a-4014-81dc-d129468ba161', '731b3369-8d8a-4506-9946-ff45c139e31c', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('44d96a3e-c049-413f-8a47-753bde1bb6a3', '731b3369-8d8a-4506-9946-ff45c139e31c', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('231a208b-fe26-484d-9dac-4e8323efc2f7', '731b3369-8d8a-4506-9946-ff45c139e31c', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('2fa6999a-64bc-44fa-ace2-8b709c62eaf2', '731b3369-8d8a-4506-9946-ff45c139e31c', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('6b723bc4-d6d7-4b72-ae01-ce28f240e2dc', '731b3369-8d8a-4506-9946-ff45c139e31c', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('f74bf0bd-dd52-4c66-9420-0356064e54c5', '731b3369-8d8a-4506-9946-ff45c139e31c', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('24cbb59f-7dde-498c-8e43-81339f04cdf8', '731b3369-8d8a-4506-9946-ff45c139e31c', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('ad973007-16bc-49ea-aefb-85ac6c5a3e40', '731b3369-8d8a-4506-9946-ff45c139e31c', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('492b09ac-f741-4947-9de0-d3aa7a9af4b0', '731b3369-8d8a-4506-9946-ff45c139e31c', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('1fb968ff-9406-48cb-baef-28ed10a4bd99', '731b3369-8d8a-4506-9946-ff45c139e31c', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('2303076d-33e7-4563-b764-6dbf8df7dbe2', '731b3369-8d8a-4506-9946-ff45c139e31c', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('6110b540-2d13-4c24-b088-571143652389', '731b3369-8d8a-4506-9946-ff45c139e31c', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('62c63265-df87-479f-9492-1dbdf23c69d9', '731b3369-8d8a-4506-9946-ff45c139e31c', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('930918d8-232b-4a4f-b5c4-62342e471643', '731b3369-8d8a-4506-9946-ff45c139e31c', 'general');
INSERT INTO building_insurance (id, building_id, insurance_type) VALUES ('7a442f12-fb50-4c8c-b3be-05bdee0c171c', '731b3369-8d8a-4506-9946-ff45c139e31c', 'general');

-- ===========================
-- CONTRACTORS
-- ===========================

INSERT INTO contractors (id, name, phone, address) VALUES
('5206328e-d675-4c49-9339-ca833ade7be2', 'ISS', '083603538855', 'London, We''re available on Live Chat here., W1S 1RS')
ON CONFLICT (id) DO NOTHING;

INSERT INTO contractors (id, name, email, phone, address) VALUES
('2d698f60-c3a9-4d5d-805f-92890b40da1b', 'Quotehedge', 'info@quotehedge-heating.co.uk', '07801 799118', '182 Revelstoke Road, Wandsworth, London, SW18 5NW')
ON CONFLICT (id) DO NOTHING;

INSERT INTO contractors (id, name, email, address) VALUES
('c10dbdd7-b41a-4002-9945-30199a500452', 'WHM', 'enquiries@whmltd.org', 'WATER HYGIENE MANAGEMENT L TD, 2 Churchill Court, Hortons Way,, Westerham, Kent, TN16 1BT')
ON CONFLICT (id) DO NOTHING;

INSERT INTO contractors (id, name, email, address) VALUES
('85d8d115-4e82-4ac7-b925-978b0da236ad', 'Capita', 'DPO@archinsurance.co.uk', 'f Arch Insurance (UK) Limited, Arch Insurance (UK) Limited, 5th Floor, 60 Great Tower Street, London EC3R 5AZ')
ON CONFLICT (id) DO NOTHING;


-- ===========================
-- BUILDING_CONTRACTORS
-- ===========================

INSERT INTO building_contractors (id, building_id, contractor_type)
VALUES ('147b79ff-7891-484f-978b-d7302815af44', '731b3369-8d8a-4506-9946-ff45c139e31c', 'service_provider')
ON CONFLICT (id) DO NOTHING;

INSERT INTO building_contractors (id, building_id, contractor_type)
VALUES ('92d56afe-6cef-4254-ab5d-729c2f45f6a8', '731b3369-8d8a-4506-9946-ff45c139e31c', 'service_provider')
ON CONFLICT (id) DO NOTHING;

INSERT INTO building_contractors (id, building_id, contractor_type)
VALUES ('89097807-f287-46a7-a966-08450b085224', '731b3369-8d8a-4506-9946-ff45c139e31c', 'service_provider')
ON CONFLICT (id) DO NOTHING;

INSERT INTO building_contractors (id, building_id, contractor_type)
VALUES ('6a8c8ca5-1157-4d80-b382-a7bb3dddc8aa', '731b3369-8d8a-4506-9946-ff45c139e31c', 'service_provider')
ON CONFLICT (id) DO NOTHING;

INSERT INTO building_contractors (id, building_id, contractor_type)
VALUES ('62b0e239-5923-4a28-a78b-15069fd0c438', '731b3369-8d8a-4506-9946-ff45c139e31c', 'service_provider')
ON CONFLICT (id) DO NOTHING;

INSERT INTO building_contractors (id, building_id, contractor_type)
VALUES ('802fe335-d4e8-480a-9454-8d287205b12d', '731b3369-8d8a-4506-9946-ff45c139e31c', 'service_provider')
ON CONFLICT (id) DO NOTHING;

INSERT INTO building_contractors (id, building_id, contractor_type)
VALUES ('c13423ad-dc13-4c8e-a8dd-41ebf1eb67d3', '731b3369-8d8a-4506-9946-ff45c139e31c', 'service_provider')
ON CONFLICT (id) DO NOTHING;

INSERT INTO building_contractors (id, building_id, contractor_type)
VALUES ('df769be8-1361-46a3-9230-908e75096db1', '731b3369-8d8a-4506-9946-ff45c139e31c', 'service_provider')
ON CONFLICT (id) DO NOTHING;

INSERT INTO building_contractors (id, building_id, contractor_type)
VALUES ('04dcaebc-cdc3-4f09-8371-bdfd31c2c18a', '731b3369-8d8a-4506-9946-ff45c139e31c', 'service_provider')
ON CONFLICT (id) DO NOTHING;

INSERT INTO building_contractors (id, building_id, contractor_type)
VALUES ('fead7e84-2fa1-45b8-a483-595c09bc6a74', '731b3369-8d8a-4506-9946-ff45c139e31c', 'service_provider')
ON CONFLICT (id) DO NOTHING;

INSERT INTO building_contractors (id, building_id, contractor_type)
VALUES ('1417b25f-66bb-4892-8d9f-db58d6fe4b3b', '731b3369-8d8a-4506-9946-ff45c139e31c', 'service_provider')
ON CONFLICT (id) DO NOTHING;

INSERT INTO building_contractors (id, building_id, contractor_type)
VALUES ('3cb33733-5edc-4778-b71d-4563cbbce2fc', '731b3369-8d8a-4506-9946-ff45c139e31c', 'service_provider')
ON CONFLICT (id) DO NOTHING;

INSERT INTO building_contractors (id, building_id, contractor_type)
VALUES ('b93a0dec-592e-4bdc-a468-9d84031d61a1', '731b3369-8d8a-4506-9946-ff45c139e31c', 'service_provider')
ON CONFLICT (id) DO NOTHING;

INSERT INTO building_contractors (id, building_id, contractor_type)
VALUES ('409bc1a7-6f0f-428e-b8ff-5bcc378ea7ac', '731b3369-8d8a-4506-9946-ff45c139e31c', 'service_provider')
ON CONFLICT (id) DO NOTHING;

INSERT INTO building_contractors (id, building_id, contractor_type)
VALUES ('12f263d6-873d-473a-a244-191575df9444', '731b3369-8d8a-4506-9946-ff45c139e31c', 'service_provider')
ON CONFLICT (id) DO NOTHING;

INSERT INTO building_contractors (id, building_id, contractor_type)
VALUES ('1793cc52-4841-462a-8242-13a82d00d317', '731b3369-8d8a-4506-9946-ff45c139e31c', 'service_provider')
ON CONFLICT (id) DO NOTHING;

INSERT INTO building_contractors (id, building_id, contractor_type)
VALUES ('45df7b19-d4bc-45d5-99b1-86a8a268cf35', '731b3369-8d8a-4506-9946-ff45c139e31c', 'service_provider')
ON CONFLICT (id) DO NOTHING;

INSERT INTO building_contractors (id, building_id, contractor_type)
VALUES ('b8c3c210-01b0-4145-a5ea-b78a5acabcb3', '731b3369-8d8a-4506-9946-ff45c139e31c', 'service_provider')
ON CONFLICT (id) DO NOTHING;

INSERT INTO building_contractors (id, building_id, contractor_type)
VALUES ('509caaf2-7c74-426c-bc2f-6ba595fdb6f5', '731b3369-8d8a-4506-9946-ff45c139e31c', 'service_provider')
ON CONFLICT (id) DO NOTHING;

INSERT INTO building_contractors (id, building_id, contractor_type)
VALUES ('b8561e76-7894-4e0d-82d6-74797152eee8', '731b3369-8d8a-4506-9946-ff45c139e31c', 'service_provider')
ON CONFLICT (id) DO NOTHING;

INSERT INTO building_contractors (id, building_id, contractor_type)
VALUES ('9e58e9ed-6c0a-409f-9553-b9631bc14503', '731b3369-8d8a-4506-9946-ff45c139e31c', 'service_provider')
ON CONFLICT (id) DO NOTHING;


-- Insert 214 assets
INSERT INTO assets (id, building_id, asset_type, asset_name, location_description, compliance_category, linked_documents) VALUES ('011c29f8-09ad-42de-afef-8b93e09b54cb', '731b3369-8d8a-4506-9946-ff45c139e31c', 'fire_alarm', 'Fire Alarm Works', 'Works-Following from latest leak', 'fire_safety', ARRAY['2024 Directors Meeting-Notes.docx']);
INSERT INTO assets (id, building_id, asset_type, asset_name, location_description, compliance_category, linked_documents) VALUES ('c975f489-18a7-4a0e-9ec7-993b6c7e0df3', '731b3369-8d8a-4506-9946-ff45c139e31c', 'lift', 'Lift Works', 'Works-Following from latest leak', 'lifts_safety', ARRAY['2024 Directors Meeting-Notes.docx']);
INSERT INTO assets (id, building_id, asset_type, asset_name, location_description, model_number, compliance_category, linked_documents) VALUES ('98856bdf-7445-4691-967f-cec2411b139e', '731b3369-8d8a-4506-9946-ff45c139e31c', 'boiler', 'Boiler Room', 'Basement', 'Fire', 'gas_safety', ARRAY['Fire Door (Communal) Inspection (11m +) (7).pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('fd2ad03c-fee5-4888-9d34-5f72b3d8e481', '731b3369-8d8a-4506-9946-ff45c139e31c', 'fire_alarm', 'Fire Alarm A', 'fire_safety', ARRAY['EICR Cuanku 32-34 conaught square.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, location_description, compliance_category, linked_documents) VALUES ('8dc1c862-6913-403e-9def-ad56318f9398', '731b3369-8d8a-4506-9946-ff45c139e31c', 'lift', 'LIFT SHAFT', 'CONTROL CIRCUITS', 'lifts_safety', ARRAY['EICR Cuanku 32-34 conaught square.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, model_number, compliance_category, linked_documents) VALUES ('80d06ae1-8908-4da6-815e-8e1176f9269e', '731b3369-8d8a-4506-9946-ff45c139e31c', 'lightning_protection', 'To lightning protection', 'B', 'electrical_safety', ARRAY['EICR Cuanku 32-34 conaught square.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('b9545985-45e9-4dec-ab55-a2f5c2ec6088', '731b3369-8d8a-4506-9946-ff45c139e31c', 'generator', 'generators', 'electrical_safety', ARRAY['EICR Cuanku 32-34 conaught square.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, location_description, compliance_category, linked_documents) VALUES ('5a59a950-a1b0-49e9-ac95-369f63047ea0', '731b3369-8d8a-4506-9946-ff45c139e31c', 'boiler', 'Boiler room', 'terrace - lift', 'gas_safety', ARRAY['221037_Fra1-L-394697-071223 32-34 Connaught Square_2024-01-02_163759 (1).pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, location_description, condition_rating, compliance_category, linked_documents) VALUES ('9857b4de-e0b5-4e6d-8891-02b139dc1f9b', '731b3369-8d8a-4506-9946-ff45c139e31c', 'fire_alarm', 'Fire Alarm', 'in appropriate X Breaches to compartmentation observed', 'good', 'fire_safety', ARRAY['221037_Fra1-L-394697-071223 32-34 Connaught Square_2024-01-02_163759 (1).pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, location_description, compliance_category, linked_documents) VALUES ('895b5dcf-4a72-4bb8-ba6d-5fab3b0a1433', '731b3369-8d8a-4506-9946-ff45c139e31c', 'lift', 'lift
motor', 'terrace - lift', 'lifts_safety', ARRAY['221037_Fra1-L-394697-071223 32-34 Connaught Square_2024-01-02_163759 (1).pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, location_description, model_number, compliance_category, linked_documents) VALUES ('bbcc21fe-6fab-487c-b3ac-edd290b9cf0f', '731b3369-8d8a-4506-9946-ff45c139e31c', 'door_entry', 'Intercom door entry', 'to 3rd floor', '1', 'security', ARRAY['221037_Fra1-L-394697-071223 32-34 Connaught Square_2024-01-02_163759 (1).pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('9276ed4b-7bb9-4784-a1f9-03272a6584ac', '731b3369-8d8a-4506-9946-ff45c139e31c', 'emergency_lighting', 'emergency lighting present', 'fire_safety', ARRAY['221037_Fra1-L-394697-071223 32-34 Connaught Square_2024-01-02_163759 (1).pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('49777fa8-8abb-4abc-9622-cf8c86a42da4', '731b3369-8d8a-4506-9946-ff45c139e31c', 'fire_extinguisher', 'fire extinguishers', 'fire_safety', ARRAY['221037_Fra1-L-394697-071223 32-34 Connaught Square_2024-01-02_163759 (1).pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, condition_rating, compliance_category, linked_documents) VALUES ('33c6736d-0990-4d82-972f-51a4578cc7d7', '731b3369-8d8a-4506-9946-ff45c139e31c', 'lightning_protection', 'Lightning protection available', 'good', 'electrical_safety', ARRAY['221037_Fra1-L-394697-071223 32-34 Connaught Square_2024-01-02_163759 (1).pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, location_description, model_number, condition_rating, compliance_category, linked_documents) VALUES ('eb56f368-aaca-470d-8a40-66c3dc5354e9', '731b3369-8d8a-4506-9946-ff45c139e31c', 'boiler', 'Boiler Hanworthy', 'Condensing Boiler Hanworthy Purewell variheat m k2 110 21 Mbar 110 0', 'pressure', 'fair', 'gas_safety', ARRAY['001132-3234-Connaught-Square-London.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, location_description, compliance_category, linked_documents) VALUES ('581a91d6-e8e1-410c-9ec5-90490f586bbb', '731b3369-8d8a-4506-9946-ff45c139e31c', 'boiler', 'Boiler room', 'terrace - lift', 'gas_safety', ARRAY['221038_Hsra1-L-394697-071223 32-34 Connaught Square_2024-01-02_163759 (1).pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('e85e9d53-bed2-43ed-b0dd-c8d21d63794b', '731b3369-8d8a-4506-9946-ff45c139e31c', 'lift', 'LIFTS', 'lifts_safety', ARRAY['221038_Hsra1-L-394697-071223 32-34 Connaught Square_2024-01-02_163759 (1).pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('4d977f68-1e71-4fb2-a6a4-40e26459140a', '731b3369-8d8a-4506-9946-ff45c139e31c', 'cctv', 'CCTV equipment', 'security', ARRAY['221038_Hsra1-L-394697-071223 32-34 Connaught Square_2024-01-02_163759 (1).pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, location_description, compliance_category, linked_documents) VALUES ('9b8653ed-a3a7-4e88-acfd-ee9d1cc8936d', '731b3369-8d8a-4506-9946-ff45c139e31c', 'door_entry', 'Intercom door entry', 'to 3rd floor', 'security', ARRAY['221038_Hsra1-L-394697-071223 32-34 Connaught Square_2024-01-02_163759 (1).pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('36cba05c-cbd5-4112-861b-443792cfbab6', '731b3369-8d8a-4506-9946-ff45c139e31c', 'emergency_lighting', 'Emergency lighting provided', 'fire_safety', ARRAY['221038_Hsra1-L-394697-071223 32-34 Connaught Square_2024-01-02_163759 (1).pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('55a0d176-ab80-49ab-8745-60dee5b4facf', '731b3369-8d8a-4506-9946-ff45c139e31c', 'water_tank', 'water storage tank', 'water_safety', ARRAY['221038_Hsra1-L-394697-071223 32-34 Connaught Square_2024-01-02_163759 (1).pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, location_description, compliance_category, linked_documents) VALUES ('6720e405-c2a1-4f01-9395-fe212ef41526', '731b3369-8d8a-4506-9946-ff45c139e31c', 'boiler', 'Boiler Room', 'exits', 'gas_safety', ARRAY['TETRA - Asbestos Re-Inspection Survey 14.06.22.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, location_description, compliance_category, linked_documents) VALUES ('e33e756b-6f28-4a44-850f-9145b58e2399', '731b3369-8d8a-4506-9946-ff45c139e31c', 'lift', 'Lift Motor', 'Description Assessment', 'lifts_safety', ARRAY['TETRA - Asbestos Re-Inspection Survey 14.06.22.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, location_description, compliance_category, linked_documents) VALUES ('dbdb47c3-0cfc-4680-a1f4-7269e1458f7e', '731b3369-8d8a-4506-9946-ff45c139e31c', 'pump', 'pumps', 'exits', 'water_safety', ARRAY['TETRA - Asbestos Re-Inspection Survey 14.06.22.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, model_number, compliance_category, linked_documents) VALUES ('d65df6d3-24c9-4552-8309-0cd8f13e6279', '731b3369-8d8a-4506-9946-ff45c139e31c', 'boiler', 'Boilers', 'Total', 'gas_safety', ARRAY['WHM Legionella Risk Assessment 07.06.22.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('99116fe3-cfdb-44aa-adfd-a7d25b9f09aa', '731b3369-8d8a-4506-9946-ff45c139e31c', 'sprinkler', 'Sprinklers', 'fire_safety', ARRAY['WHM Legionella Risk Assessment 07.06.22.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('a1cbcf1d-cd0d-4faa-9e84-85b86d48b484', '731b3369-8d8a-4506-9946-ff45c139e31c', 'pump', 'pump is', 'water_safety', ARRAY['WHM Legionella Risk Assessment 07.06.22.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, service_frequency, compliance_category, linked_documents) VALUES ('d55c182e-1165-458b-beef-ba7e7fa32fc1', '731b3369-8d8a-4506-9946-ff45c139e31c', 'water_tank', 'water tanks', 'annually', 'water_safety', ARRAY['WHM Legionella Risk Assessment 07.06.22.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('364cf547-d0d5-468d-8a3d-ce43c959dc14', '731b3369-8d8a-4506-9946-ff45c139e31c', 'fire_alarm', 'Fire Alarm A', 'fire_safety', ARRAY['EICR Report Cunaku SATISFACTORY 2023 .pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, location_description, compliance_category, linked_documents) VALUES ('538e90cb-e556-4fb5-afd1-4dc808e41f70', '731b3369-8d8a-4506-9946-ff45c139e31c', 'lift', 'LIFT SHAFT', 'CONTROL CIRCUITS', 'lifts_safety', ARRAY['EICR Report Cunaku SATISFACTORY 2023 .pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, model_number, compliance_category, linked_documents) VALUES ('f9658f10-870e-4529-a408-918ffa933890', '731b3369-8d8a-4506-9946-ff45c139e31c', 'lightning_protection', 'To lightning protection', 'B', 'electrical_safety', ARRAY['EICR Report Cunaku SATISFACTORY 2023 .pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('3afe22d4-c216-41e8-9b9f-f3a276ae736d', '731b3369-8d8a-4506-9946-ff45c139e31c', 'generator', 'generators', 'electrical_safety', ARRAY['EICR Report Cunaku SATISFACTORY 2023 .pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, location_description, compliance_category, linked_documents) VALUES ('6dca9cc9-2aa5-47f8-909d-096ffd392eaa', '731b3369-8d8a-4506-9946-ff45c139e31c', 'fire_alarm', 'Fire Alarm Works', 'Works-Following from latest leak', 'fire_safety', ARRAY['2024 Directors Meeting-Notes.docx']);
INSERT INTO assets (id, building_id, asset_type, asset_name, location_description, compliance_category, linked_documents) VALUES ('df5e7514-da87-4780-af73-71b6766dffe4', '731b3369-8d8a-4506-9946-ff45c139e31c', 'lift', 'Lift Works', 'Works-Following from latest leak', 'lifts_safety', ARRAY['2024 Directors Meeting-Notes.docx']);
INSERT INTO assets (id, building_id, asset_type, asset_name, location_description, model_number, condition_rating, compliance_category, linked_documents) VALUES ('3ffac1af-9bb9-4345-99bd-b13f39d56d34', '731b3369-8d8a-4506-9946-ff45c139e31c', 'boiler', 'Boiler Hanworthy', 'Condensing Boiler Hanworthy Wessex modumaxO mFk2 110c 20 Mbar 1', 'pressure', 'fair', 'gas_safety', ARRAY['001457-3234-Connaught-Square-London Certificate.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, location_description, manufacturer, compliance_category, linked_documents) VALUES ('bfb6f2c5-a5ba-448a-9c58-e60af8d8b720', '731b3369-8d8a-4506-9946-ff45c139e31c', 'lift', 'lift to', 'of Commission is', 'Crown to the Customer', 'lifts_safety', ARRAY['TC0001V31 General Terms and Conditions.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, model_number, compliance_category, linked_documents) VALUES ('35f55207-64a4-4b84-a74f-8d4e97e935ac', '731b3369-8d8a-4506-9946-ff45c139e31c', 'boiler', 'Boilers', 'Total', 'gas_safety', ARRAY['Connaught Square (32-34) - 09.12.24 LRA.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('c6b443a6-375f-4881-977c-71195f260867', '731b3369-8d8a-4506-9946-ff45c139e31c', 'sprinkler', 'Sprinklers', 'fire_safety', ARRAY['Connaught Square (32-34) - 09.12.24 LRA.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('8eb34d5a-5b35-4e1a-aa9c-70c682e16760', '731b3369-8d8a-4506-9946-ff45c139e31c', 'pump', 'pump is', 'water_safety', ARRAY['Connaught Square (32-34) - 09.12.24 LRA.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, service_frequency, compliance_category, linked_documents) VALUES ('7a3d7dcb-2d8e-409a-921d-491684195029', '731b3369-8d8a-4506-9946-ff45c139e31c', 'water_tank', 'water tanks', 'annually', 'water_safety', ARRAY['Connaught Square (32-34) - 09.12.24 LRA.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, location_description, model_number, compliance_category, linked_documents) VALUES ('5765065a-094e-4857-8f5d-59216445c705', '731b3369-8d8a-4506-9946-ff45c139e31c', 'boiler', 'Boiler Room', 'Basement', 'Fire', 'gas_safety', ARRAY['Fire Door (Communal) Inspection (11m +) (7).pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, location_description, compliance_category, linked_documents) VALUES ('2873d7f0-d201-4c04-a577-0d5ce7b4525a', '731b3369-8d8a-4506-9946-ff45c139e31c', 'boiler', 'Boiler room', 'terrace - lift', 'gas_safety', ARRAY['221037_Fra1-L-394697-071223 32-34 Connaught Square_2024-01-02_163759.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, location_description, condition_rating, compliance_category, linked_documents) VALUES ('b36d4e0c-712e-4d21-9ece-3dd164f50a28', '731b3369-8d8a-4506-9946-ff45c139e31c', 'fire_alarm', 'Fire Alarm', 'in appropriate X Breaches to compartmentation observed', 'good', 'fire_safety', ARRAY['221037_Fra1-L-394697-071223 32-34 Connaught Square_2024-01-02_163759.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, location_description, compliance_category, linked_documents) VALUES ('9ab555fb-c6c5-45c5-ba3e-00a54a7df026', '731b3369-8d8a-4506-9946-ff45c139e31c', 'lift', 'lift
motor', 'terrace - lift', 'lifts_safety', ARRAY['221037_Fra1-L-394697-071223 32-34 Connaught Square_2024-01-02_163759.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, location_description, model_number, compliance_category, linked_documents) VALUES ('40c18e2c-d8ad-4269-925b-9f99b0190d3e', '731b3369-8d8a-4506-9946-ff45c139e31c', 'door_entry', 'Intercom door entry', 'to 3rd floor', '1', 'security', ARRAY['221037_Fra1-L-394697-071223 32-34 Connaught Square_2024-01-02_163759.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('35a3fbfd-e322-4316-a73f-e3362d72bf48', '731b3369-8d8a-4506-9946-ff45c139e31c', 'emergency_lighting', 'emergency lighting present', 'fire_safety', ARRAY['221037_Fra1-L-394697-071223 32-34 Connaught Square_2024-01-02_163759.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('88ade6ef-4b66-499f-a609-ea6c57768ab7', '731b3369-8d8a-4506-9946-ff45c139e31c', 'fire_extinguisher', 'fire extinguishers', 'fire_safety', ARRAY['221037_Fra1-L-394697-071223 32-34 Connaught Square_2024-01-02_163759.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, condition_rating, compliance_category, linked_documents) VALUES ('e62d0eee-8769-4d54-b609-6c2e174c7b20', '731b3369-8d8a-4506-9946-ff45c139e31c', 'lightning_protection', 'Lightning protection available', 'good', 'electrical_safety', ARRAY['221037_Fra1-L-394697-071223 32-34 Connaught Square_2024-01-02_163759.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, location_description, model_number, compliance_category, linked_documents) VALUES ('0466e03e-2858-4098-8078-c6ec90816885', '731b3369-8d8a-4506-9946-ff45c139e31c', 'boiler', 'Boiler Room', 'Basement', 'Fire', 'gas_safety', ARRAY['Fire Door (Communal) Inspection (11m +) - 2024-01-24T120743.986.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, location_description, compliance_category, linked_documents) VALUES ('21650572-4ea0-4ea2-aa3b-10cb374f6dbe', '731b3369-8d8a-4506-9946-ff45c139e31c', 'boiler', 'Boiler room', 'terrace - lift', 'gas_safety', ARRAY['221038_Hsra1-L-394697-071223 32-34 Connaught Square_2024-01-02_163759.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('84ea104d-5e43-4fb7-8dde-f3b53253ae79', '731b3369-8d8a-4506-9946-ff45c139e31c', 'lift', 'LIFTS', 'lifts_safety', ARRAY['221038_Hsra1-L-394697-071223 32-34 Connaught Square_2024-01-02_163759.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('d9bb90ef-fd8d-4f5a-93e5-38b30831b995', '731b3369-8d8a-4506-9946-ff45c139e31c', 'cctv', 'CCTV equipment', 'security', ARRAY['221038_Hsra1-L-394697-071223 32-34 Connaught Square_2024-01-02_163759.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, location_description, compliance_category, linked_documents) VALUES ('7fe0d24a-746d-405d-891d-14a23cd604de', '731b3369-8d8a-4506-9946-ff45c139e31c', 'door_entry', 'Intercom door entry', 'to 3rd floor', 'security', ARRAY['221038_Hsra1-L-394697-071223 32-34 Connaught Square_2024-01-02_163759.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('eac206f1-6bc9-4e8b-9881-d280611be2e2', '731b3369-8d8a-4506-9946-ff45c139e31c', 'emergency_lighting', 'Emergency lighting provided', 'fire_safety', ARRAY['221038_Hsra1-L-394697-071223 32-34 Connaught Square_2024-01-02_163759.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('1ab78738-b7e6-4f8d-83fc-1949aee03bc1', '731b3369-8d8a-4506-9946-ff45c139e31c', 'water_tank', 'water storage tank', 'water_safety', ARRAY['221038_Hsra1-L-394697-071223 32-34 Connaught Square_2024-01-02_163759.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, location_description, compliance_category, linked_documents) VALUES ('890b728f-64dc-46fa-b2da-32de2969afea', '731b3369-8d8a-4506-9946-ff45c139e31c', 'boiler', 'Boiler room', 'terrace - lift', 'gas_safety', ARRAY['Hsfra1-L-422971-210225 32-34 Connaught Square.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, location_description, condition_rating, compliance_category, linked_documents) VALUES ('b41236b8-49db-459a-9285-d57590e13eae', '731b3369-8d8a-4506-9946-ff45c139e31c', 'fire_alarm', 'Fire Alarm', 'in appropriate X Breaches to compartmentation observed', 'good', 'fire_safety', ARRAY['Hsfra1-L-422971-210225 32-34 Connaught Square.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('320b9993-cd9c-4c7a-8498-dabcda006a6e', '731b3369-8d8a-4506-9946-ff45c139e31c', 'lift', 'LIFTS', 'lifts_safety', ARRAY['Hsfra1-L-422971-210225 32-34 Connaught Square.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('a62510aa-ccd1-4a13-9e04-6e92362435d4', '731b3369-8d8a-4506-9946-ff45c139e31c', 'cctv', 'CCTV equipment', 'security', ARRAY['Hsfra1-L-422971-210225 32-34 Connaught Square.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, location_description, compliance_category, linked_documents) VALUES ('139506e3-9080-4a2f-b9f9-6dc03029caad', '731b3369-8d8a-4506-9946-ff45c139e31c', 'door_entry', 'Intercom door entry', 'to 3rd floor', 'security', ARRAY['Hsfra1-L-422971-210225 32-34 Connaught Square.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('2274d68f-6bd3-4488-965d-ecc6965db2c1', '731b3369-8d8a-4506-9946-ff45c139e31c', 'emergency_lighting', 'Emergency lighting provided', 'fire_safety', ARRAY['Hsfra1-L-422971-210225 32-34 Connaught Square.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('99e43db7-2dc2-4f3c-ba50-abd52e5eea42', '731b3369-8d8a-4506-9946-ff45c139e31c', 'fire_extinguisher', 'fire extinguishers', 'fire_safety', ARRAY['Hsfra1-L-422971-210225 32-34 Connaught Square.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, condition_rating, compliance_category, linked_documents) VALUES ('b212b425-b9f0-40cb-bc71-fa02f36b1bce', '731b3369-8d8a-4506-9946-ff45c139e31c', 'lightning_protection', 'Lightning protection available', 'good', 'electrical_safety', ARRAY['Hsfra1-L-422971-210225 32-34 Connaught Square.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('9b072e39-4170-4041-bf51-7f1df060d989', '731b3369-8d8a-4506-9946-ff45c139e31c', 'water_tank', 'water storage tank', 'water_safety', ARRAY['Hsfra1-L-422971-210225 32-34 Connaught Square.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('3df49745-ab25-4bda-9a37-08c5d3d2197b', '731b3369-8d8a-4506-9946-ff45c139e31c', 'fire_alarm', 'ESCAPE

FIRE DETECTION', 'fire_safety', ARRAY['Hsfra1-L-422971-210225 32-34 Connaught Square.docx']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('11d6b9fb-cd88-4210-9ac6-721049a53687', '731b3369-8d8a-4506-9946-ff45c139e31c', 'lift', 'LIFTS', 'lifts_safety', ARRAY['Hsfra1-L-422971-210225 32-34 Connaught Square.docx']);
INSERT INTO assets (id, building_id, asset_type, asset_name, location_description, compliance_category, linked_documents) VALUES ('000d1892-1346-40f9-b8f1-99e9d2716d1e', '731b3369-8d8a-4506-9946-ff45c139e31c', 'boiler', 'Boiler room', 'terrace - lift', 'gas_safety', ARRAY['221037_Fra1-L-394697-071223 32-34 Connaught Square_2024-01-02_163759 (1).pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, location_description, condition_rating, compliance_category, linked_documents) VALUES ('527dd8d8-1e20-4fef-a439-23ca02a665ea', '731b3369-8d8a-4506-9946-ff45c139e31c', 'fire_alarm', 'Fire Alarm', 'in appropriate X Breaches to compartmentation observed', 'good', 'fire_safety', ARRAY['221037_Fra1-L-394697-071223 32-34 Connaught Square_2024-01-02_163759 (1).pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, location_description, compliance_category, linked_documents) VALUES ('f9ef5539-2964-4538-b61f-3c27491c4b26', '731b3369-8d8a-4506-9946-ff45c139e31c', 'lift', 'lift
motor', 'terrace - lift', 'lifts_safety', ARRAY['221037_Fra1-L-394697-071223 32-34 Connaught Square_2024-01-02_163759 (1).pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, location_description, model_number, compliance_category, linked_documents) VALUES ('3be348d4-4d30-4091-bd43-cdba9e0cef1b', '731b3369-8d8a-4506-9946-ff45c139e31c', 'door_entry', 'Intercom door entry', 'to 3rd floor', '1', 'security', ARRAY['221037_Fra1-L-394697-071223 32-34 Connaught Square_2024-01-02_163759 (1).pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('33da03b8-b32d-4990-9931-8f7e38b7209f', '731b3369-8d8a-4506-9946-ff45c139e31c', 'emergency_lighting', 'emergency lighting present', 'fire_safety', ARRAY['221037_Fra1-L-394697-071223 32-34 Connaught Square_2024-01-02_163759 (1).pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('1d08b853-4ca5-4eba-94e5-ee26ecdf2795', '731b3369-8d8a-4506-9946-ff45c139e31c', 'fire_extinguisher', 'fire extinguishers', 'fire_safety', ARRAY['221037_Fra1-L-394697-071223 32-34 Connaught Square_2024-01-02_163759 (1).pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, condition_rating, compliance_category, linked_documents) VALUES ('40342a32-d7ed-408d-90d2-007a8963064b', '731b3369-8d8a-4506-9946-ff45c139e31c', 'lightning_protection', 'Lightning protection available', 'good', 'electrical_safety', ARRAY['221037_Fra1-L-394697-071223 32-34 Connaught Square_2024-01-02_163759 (1).pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, location_description, compliance_category, linked_documents) VALUES ('2a098caf-d5e6-49e6-b551-a45697fb49bc', '731b3369-8d8a-4506-9946-ff45c139e31c', 'boiler', 'Boiler room', 'terrace - lift', 'gas_safety', ARRAY['221038_Hsra1-L-394697-071223 32-34 Connaught Square_2024-01-02_163759 (1).pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('1cae76b2-b785-413a-bea5-9c841477b696', '731b3369-8d8a-4506-9946-ff45c139e31c', 'lift', 'LIFTS', 'lifts_safety', ARRAY['221038_Hsra1-L-394697-071223 32-34 Connaught Square_2024-01-02_163759 (1).pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('7a3a60bd-594e-494b-b669-497c600ad35f', '731b3369-8d8a-4506-9946-ff45c139e31c', 'cctv', 'CCTV equipment', 'security', ARRAY['221038_Hsra1-L-394697-071223 32-34 Connaught Square_2024-01-02_163759 (1).pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, location_description, compliance_category, linked_documents) VALUES ('10a92a00-2f75-48a1-b54a-313d653931b4', '731b3369-8d8a-4506-9946-ff45c139e31c', 'door_entry', 'Intercom door entry', 'to 3rd floor', 'security', ARRAY['221038_Hsra1-L-394697-071223 32-34 Connaught Square_2024-01-02_163759 (1).pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('c663437e-84c5-4553-800f-21eaa1982420', '731b3369-8d8a-4506-9946-ff45c139e31c', 'emergency_lighting', 'Emergency lighting provided', 'fire_safety', ARRAY['221038_Hsra1-L-394697-071223 32-34 Connaught Square_2024-01-02_163759 (1).pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('61b6a259-35a8-459f-8571-d0d5de755d23', '731b3369-8d8a-4506-9946-ff45c139e31c', 'water_tank', 'water storage tank', 'water_safety', ARRAY['221038_Hsra1-L-394697-071223 32-34 Connaught Square_2024-01-02_163759 (1).pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, location_description, model_number, condition_rating, compliance_category, linked_documents) VALUES ('bf1917f2-988e-4340-94b6-bc02937614db', '731b3369-8d8a-4506-9946-ff45c139e31c', 'boiler', 'Boiler Hamworthy', 'Plant Room Condensing', 'pressure', 'fair', 'gas_safety', ARRAY['001534-3234-Connaught-Square-London.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, location_description, compliance_category, linked_documents) VALUES ('ed2c164a-23f7-4e36-86e5-412f0ae9cca7', '731b3369-8d8a-4506-9946-ff45c139e31c', 'boiler', 'boiler number', 'new gas valve', 'gas_safety', ARRAY['C1047 - Job card.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, model_number, compliance_category, linked_documents) VALUES ('85d302c8-507d-4942-a9e0-bdfef9480f96', '731b3369-8d8a-4506-9946-ff45c139e31c', 'boiler', 'Boilers', 'Total', 'gas_safety', ARRAY['WHM Legionella Risk Assessment 09.12.25.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('933e012d-6093-4527-80f4-8199a3e38740', '731b3369-8d8a-4506-9946-ff45c139e31c', 'sprinkler', 'Sprinklers', 'fire_safety', ARRAY['WHM Legionella Risk Assessment 09.12.25.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('aa768d4b-7ac5-483f-a226-3b47036faebf', '731b3369-8d8a-4506-9946-ff45c139e31c', 'pump', 'pump is', 'water_safety', ARRAY['WHM Legionella Risk Assessment 09.12.25.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, service_frequency, compliance_category, linked_documents) VALUES ('76dc7096-139b-4f68-ba0f-3867191f8994', '731b3369-8d8a-4506-9946-ff45c139e31c', 'water_tank', 'water tanks', 'annually', 'water_safety', ARRAY['WHM Legionella Risk Assessment 09.12.25.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, model_number, compliance_category, linked_documents) VALUES ('8875b24d-3927-43a1-86fc-284f27e36222', '731b3369-8d8a-4506-9946-ff45c139e31c', 'boiler', 'Boilers', 'Total', 'gas_safety', ARRAY['WHM Legionella Risk Assessment 07.06.22.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('bb8ebad1-c886-4bda-8544-b0795031a2d5', '731b3369-8d8a-4506-9946-ff45c139e31c', 'sprinkler', 'Sprinklers', 'fire_safety', ARRAY['WHM Legionella Risk Assessment 07.06.22.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('553c6552-208b-4ad5-9984-a3968c277344', '731b3369-8d8a-4506-9946-ff45c139e31c', 'pump', 'pump is', 'water_safety', ARRAY['WHM Legionella Risk Assessment 07.06.22.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, service_frequency, compliance_category, linked_documents) VALUES ('44441371-8e85-4649-8e09-301b40ac4d6e', '731b3369-8d8a-4506-9946-ff45c139e31c', 'water_tank', 'water tanks', 'annually', 'water_safety', ARRAY['WHM Legionella Risk Assessment 07.06.22.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('866c1dce-9174-4bb3-900a-e5076251d477', '731b3369-8d8a-4506-9946-ff45c139e31c', 'fire_alarm', 'Fire Alarm A', 'fire_safety', ARRAY['EICR Cuanku 32-34 conaught square.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, location_description, compliance_category, linked_documents) VALUES ('594966b2-9280-4983-ba5e-d731aec7d2ff', '731b3369-8d8a-4506-9946-ff45c139e31c', 'lift', 'LIFT SHAFT', 'CONTROL CIRCUITS', 'lifts_safety', ARRAY['EICR Cuanku 32-34 conaught square.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, model_number, compliance_category, linked_documents) VALUES ('74d5102d-a3c6-49a2-9974-2a0c562dd9ba', '731b3369-8d8a-4506-9946-ff45c139e31c', 'lightning_protection', 'To lightning protection', 'B', 'electrical_safety', ARRAY['EICR Cuanku 32-34 conaught square.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('1705a0fa-cb16-4a9a-967d-cecfd399c9f2', '731b3369-8d8a-4506-9946-ff45c139e31c', 'generator', 'generators', 'electrical_safety', ARRAY['EICR Cuanku 32-34 conaught square.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('0c89e3c4-1302-4419-bb1e-cb6992a18d8a', '731b3369-8d8a-4506-9946-ff45c139e31c', 'fire_alarm', 'Fire Alarm A', 'fire_safety', ARRAY['EICR Report Cunaku SATISFACTORY 2023 .pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, location_description, compliance_category, linked_documents) VALUES ('2f164605-3f45-4d6c-9b7a-d7cfd8f2bfc8', '731b3369-8d8a-4506-9946-ff45c139e31c', 'lift', 'LIFT SHAFT', 'CONTROL CIRCUITS', 'lifts_safety', ARRAY['EICR Report Cunaku SATISFACTORY 2023 .pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, model_number, compliance_category, linked_documents) VALUES ('15c5fd49-1d52-4474-8c3e-6b1b58bd5838', '731b3369-8d8a-4506-9946-ff45c139e31c', 'lightning_protection', 'To lightning protection', 'B', 'electrical_safety', ARRAY['EICR Report Cunaku SATISFACTORY 2023 .pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('bd901eea-deef-4b6e-b72d-a784df1a7133', '731b3369-8d8a-4506-9946-ff45c139e31c', 'generator', 'generators', 'electrical_safety', ARRAY['EICR Report Cunaku SATISFACTORY 2023 .pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, location_description, model_number, condition_rating, compliance_category, linked_documents) VALUES ('9c79ad8a-8859-4e41-9588-0bad273b4869', '731b3369-8d8a-4506-9946-ff45c139e31c', 'boiler', 'Boiler Hanworthy', 'Condensing Boiler Hanworthy Purewell variheat m k2 110 21 Mbar 110 0', 'pressure', 'fair', 'gas_safety', ARRAY['001132-3234-Connaught-Square-London.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, location_description, model_number, condition_rating, compliance_category, linked_documents) VALUES ('fb39c075-53d8-472c-8751-e243fd982532', '731b3369-8d8a-4506-9946-ff45c139e31c', 'boiler', 'Boiler Hamworthy', 'Plant Room Condensing', 'pressure', 'fair', 'gas_safety', ARRAY['001534-3234-Connaught-Square-London.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, location_description, compliance_category, linked_documents) VALUES ('7c884909-8584-4f9e-9004-f606701a1699', '731b3369-8d8a-4506-9946-ff45c139e31c', 'boiler', 'Boiler Room', 'pipework', 'gas_safety', ARRAY['FINAL L-432900 32-34 Connaught Square Management Survey Report Issue 1.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, location_description, compliance_category, linked_documents) VALUES ('868657e0-5ad7-4fb3-8205-655c9dac4101', '731b3369-8d8a-4506-9946-ff45c139e31c', 'lift', 'Lift Motor', 'Room brake shoe to lift motor', 'lifts_safety', ARRAY['FINAL L-432900 32-34 Connaught Square Management Survey Report Issue 1.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, location_description, compliance_category, linked_documents) VALUES ('96f6e6a8-5322-441e-81b3-a93640de05c0', '731b3369-8d8a-4506-9946-ff45c139e31c', 'boiler', 'Boiler Room', 'exits', 'gas_safety', ARRAY['TETRA - Asbestos Re-Inspection Survey 14.06.22.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, location_description, compliance_category, linked_documents) VALUES ('3bd9699e-0ba8-4afd-8c07-62d4b87b5612', '731b3369-8d8a-4506-9946-ff45c139e31c', 'lift', 'Lift Motor', 'Description Assessment', 'lifts_safety', ARRAY['TETRA - Asbestos Re-Inspection Survey 14.06.22.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, location_description, compliance_category, linked_documents) VALUES ('93aadd30-e11e-4fd6-a126-49132871dbd3', '731b3369-8d8a-4506-9946-ff45c139e31c', 'pump', 'pumps', 'exits', 'water_safety', ARRAY['TETRA - Asbestos Re-Inspection Survey 14.06.22.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, service_frequency, compliance_category, linked_documents) VALUES ('be7cfab7-b002-4e93-851f-17b19aed53f0', '731b3369-8d8a-4506-9946-ff45c139e31c', 'lift', 'lifts', 'monthly', 'lifts_safety', ARRAY['Signed 2025 Connaught Square Management Agreement.docx.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, service_frequency, compliance_category, linked_documents) VALUES ('98437700-8f1d-4f8f-a8c5-86b16b1afadf', '731b3369-8d8a-4506-9946-ff45c139e31c', 'lift', 'lifts', 'monthly', 'lifts_safety', ARRAY['Signed Connaught Square Management Agreement.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, model_number, compliance_category, linked_documents) VALUES ('a1fd7456-0d01-4788-b4c3-65ff340e1d95', '731b3369-8d8a-4506-9946-ff45c139e31c', 'boiler', 'BOILER SERVICE', 'OF', 'gas_safety', ARRAY['CM434.PRO 2024-2025.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, model_number, compliance_category, linked_documents) VALUES ('21a9f74c-338a-4599-bef7-b2eaf329d902', '731b3369-8d8a-4506-9946-ff45c139e31c', 'boiler', 'BOILER SERVICE', 'OF', 'gas_safety', ARRAY['CM434.PRO.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('63e98ea1-9b70-402f-b63a-4f34e355f632', '731b3369-8d8a-4506-9946-ff45c139e31c', 'lift', 'lift in', 'lifts_safety', ARRAY['Gas Contract 24-5.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('31d90cdc-578b-44f9-8ca3-9cd498e07c71', '731b3369-8d8a-4506-9946-ff45c139e31c', 'lift', 'LIFT INCORPORATED', 'lifts_safety', ARRAY['Contract_10-03-2025.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('e18409b2-6692-4eef-9c9b-01d1343c132d', '731b3369-8d8a-4506-9946-ff45c139e31c', 'lift', 'LIFT INCORPORATED', 'lifts_safety', ARRAY['Gas Contract 25-26.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('348f9057-dd52-4cef-b1c2-1ab5102d6c02', '731b3369-8d8a-4506-9946-ff45c139e31c', 'lift', 'lift to', 'lifts_safety', ARRAY['Welcome Letter - CG1885574.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, location_description, service_frequency, compliance_category, linked_documents) VALUES ('e17ccbd6-ef4e-4b48-800d-6d1910f5858a', '731b3369-8d8a-4506-9946-ff45c139e31c', 'lift', 'lift accessible', 'To clean out silt from the outlet and bagged it up', 'monthly', 'lifts_safety', ARRAY['Job 67141.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, model_number, compliance_category, linked_documents) VALUES ('a4905977-6da8-45ab-9d9a-d262b8f8d5d9', '731b3369-8d8a-4506-9946-ff45c139e31c', 'lift', 'Lift Ref', 'BRONZE', 'lifts_safety', ARRAY['JLGCalloutVisit-5455045-12-07-2024.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, model_number, compliance_category, linked_documents) VALUES ('4794238b-91b1-4a97-b60c-6875b521ff17', '731b3369-8d8a-4506-9946-ff45c139e31c', 'lift', 'Lift Ref', 'BRONZE', 'lifts_safety', ARRAY['JLGCalloutVisit-5483206-26-10-2024.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, model_number, compliance_category, linked_documents) VALUES ('f7db3110-8b5d-400d-ad62-2ff2a8834db3', '731b3369-8d8a-4506-9946-ff45c139e31c', 'lift', 'Lift Ref', 'BRONZE', 'lifts_safety', ARRAY['JLGCalloutVisit-5498439-16-12-2024.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, location_description, compliance_category, linked_documents) VALUES ('92e6b49a-8cdf-4e3c-a4e1-4f92454da259', '731b3369-8d8a-4506-9946-ff45c139e31c', 'emergency_lighting', 'emergency lighting
The', 'The fault status has been classified as Faulty', 'fire_safety', ARRAY['JLGCalloutVisit-5498439-16-12-2024.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, model_number, compliance_category, linked_documents) VALUES ('60362df5-9b11-470e-8f46-19729e03d480', '731b3369-8d8a-4506-9946-ff45c139e31c', 'lift', 'Lift Ref', 'BRONZE', 'lifts_safety', ARRAY['JLGCalloutVisit-5455462-16-07-2024.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, model_number, compliance_category, linked_documents) VALUES ('e0c9334f-be5e-40b4-ab67-2590de5cf129', '731b3369-8d8a-4506-9946-ff45c139e31c', 'lift', 'Lift Ref', 'BRONZE', 'lifts_safety', ARRAY['JLGCalloutVisit-5497480-13-12-2024.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, model_number, compliance_category, linked_documents) VALUES ('986f8b1a-2673-46bd-8f29-8030cb954cb8', '731b3369-8d8a-4506-9946-ff45c139e31c', 'fire_alarm', 'Fire Alarm', 'SMALL', 'fire_safety', ARRAY['Engineering Report - 32-34 CONNAUGHT SQUARE.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, model_number, compliance_category, linked_documents) VALUES ('8cb5e9df-8597-457c-9e1c-82ec34e9025d', '731b3369-8d8a-4506-9946-ff45c139e31c', 'emergency_lighting', 'Emergency Lights - FA7817', 'SMALL', 'fire_safety', ARRAY['Engineering Report - 32-34 CONNAUGHT SQUARE.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, location_description, compliance_category, linked_documents) VALUES ('6223070e-7fa7-4839-8147-44173a1023f1', '731b3369-8d8a-4506-9946-ff45c139e31c', 'boiler', 'a boiler', 'but this sha', 'gas_safety', ARRAY['StG_Policy Wording_32-34 Connaught Square W2 2HL.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('5a52f295-d2a0-48db-92c4-f821f780441e', '731b3369-8d8a-4506-9946-ff45c139e31c', 'fire_alarm', 'fire alarm
The', 'fire_safety', ARRAY['StG_Policy Wording_32-34 Connaught Square W2 2HL.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('f61df154-9b03-4b82-9e3a-8b0f04922d5b', '731b3369-8d8a-4506-9946-ff45c139e31c', 'sprinkler', 'sprinkler leakage', 'fire_safety', ARRAY['StG_Policy Wording_32-34 Connaught Square W2 2HL.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('c259ee74-26e9-47a5-b8d8-81fc41c89934', '731b3369-8d8a-4506-9946-ff45c139e31c', 'lift', 'lift in', 'lifts_safety', ARRAY['StG_Policy Wording_32-34 Connaught Square W2 2HL.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('8d6598a1-e940-424e-a330-feab15309ce2', '731b3369-8d8a-4506-9946-ff45c139e31c', 'pump', 'pumping', 'water_safety', ARRAY['StG_Policy Wording_32-34 Connaught Square W2 2HL.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, location_description, compliance_category, linked_documents) VALUES ('fbfc36de-52f0-4b3c-a261-c7aa7a40e2a1', '731b3369-8d8a-4506-9946-ff45c139e31c', 'cctv', 'cameras', 'on or', 'security', ARRAY['StG_Policy Wording_32-34 Connaught Square W2 2HL.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('a689a31b-ab0f-4128-8dca-f67b598ad51d', '731b3369-8d8a-4506-9946-ff45c139e31c', 'water_tank', 'water tanks', 'water_safety', ARRAY['StG_Policy Wording_32-34 Connaught Square W2 2HL.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('c0325998-7e52-452e-806c-c446016e529b', '731b3369-8d8a-4506-9946-ff45c139e31c', 'fire_extinguisher', 'fire extinguishers', 'fire_safety', ARRAY['Q51691 - 32-34 Connaught Square Contract.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, model_number, compliance_category, linked_documents) VALUES ('d21ac10b-512d-46df-a3f6-3d6d99a34a50', '731b3369-8d8a-4506-9946-ff45c139e31c', 'fire_alarm', 'Fire Alarm', 'SMALL', 'fire_safety', ARRAY['Engineering Report - 32-34 CONNAUGHT SQUARE.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, model_number, compliance_category, linked_documents) VALUES ('9513a3f2-e4e5-4c62-90e5-be87ec98e558', '731b3369-8d8a-4506-9946-ff45c139e31c', 'emergency_lighting', 'Emergency Lights - FA7817', 'SMALL', 'fire_safety', ARRAY['Engineering Report - 32-34 CONNAUGHT SQUARE.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, location_description, model_number, compliance_category, linked_documents) VALUES ('4e854710-bcb9-4365-9bd5-277ab730b746', '731b3369-8d8a-4506-9946-ff45c139e31c', 'fire_alarm', 'uk
FIRE ALARM', 'LONDON', 'LIGHTS', 'fire_safety', ARRAY['Fire Alarm+Emergency Lighting Contract Connaught Square.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, service_frequency, compliance_category, linked_documents) VALUES ('83086c6e-3477-4c34-a1b3-97951ad3cf85', '731b3369-8d8a-4506-9946-ff45c139e31c', 'emergency_lighting', 'EMERGENCY LIGHTS
MT8825', 'monthly', 'fire_safety', ARRAY['Fire Alarm+Emergency Lighting Contract Connaught Square.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, service_frequency, compliance_category, linked_documents) VALUES ('1f6b733a-dc86-4f29-bde7-02a023a32c2e', '731b3369-8d8a-4506-9946-ff45c139e31c', 'fire_alarm', 'FIRE ALARM BELL', 'monthly', 'fire_safety', ARRAY['BT3205 03072025.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, model_number, service_frequency, compliance_category, linked_documents) VALUES ('fb5f33ad-3672-4911-8854-67c2addb987b', '731b3369-8d8a-4506-9946-ff45c139e31c', 'fire_alarm', 'fire alarm service', 'MAINTENANCE', 'monthly', 'fire_safety', ARRAY['FA7817 SERVICE 08042025.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, model_number, service_frequency, compliance_category, linked_documents) VALUES ('ad6456dd-3f1d-4955-a739-4cf471b1fb7e', '731b3369-8d8a-4506-9946-ff45c139e31c', 'emergency_lighting', 'Emergency Lights - FA7817', 'MAINTENANCE', 'monthly', 'fire_safety', ARRAY['FA7817 SERVICE 08042025.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, model_number, compliance_category, linked_documents) VALUES ('42951f38-3797-454c-ba9d-a7a0a787c719', '731b3369-8d8a-4506-9946-ff45c139e31c', 'fire_alarm', 'Fire Alarm', 'SMALL', 'fire_safety', ARRAY['Engineer Report - 32-34 Connaught Square Flat 5.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, model_number, compliance_category, linked_documents) VALUES ('e518595d-025e-4c64-ab05-9d2c8be07232', '731b3369-8d8a-4506-9946-ff45c139e31c', 'emergency_lighting', 'Emergency Lights - FA7817', 'SMALL', 'fire_safety', ARRAY['Engineer Report - 32-34 Connaught Square Flat 5.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, model_number, compliance_category, linked_documents) VALUES ('2fb45351-134d-4b81-86d3-62596c98fb40', '731b3369-8d8a-4506-9946-ff45c139e31c', 'fire_alarm', 'Fire Alarm', 'SMALL', 'fire_safety', ARRAY['Engineering Report - 32-34 CONNAUGHT SQUARE.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, model_number, compliance_category, linked_documents) VALUES ('2804417e-2c2c-4d5f-90be-d6dab5bea263', '731b3369-8d8a-4506-9946-ff45c139e31c', 'emergency_lighting', 'Emergency Lights - FA7817', 'SMALL', 'fire_safety', ARRAY['Engineering Report - 32-34 CONNAUGHT SQUARE.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, model_number, service_frequency, compliance_category, linked_documents) VALUES ('d5496b55-64b1-4664-91f6-30c6a05cb2a8', '731b3369-8d8a-4506-9946-ff45c139e31c', 'emergency_lighting', 'Emergency Lights Testing', 'MONTHLY', 'monthly', 'fire_safety', ARRAY['MT8825 03072025.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, model_number, service_frequency, compliance_category, linked_documents) VALUES ('c6310157-13f6-44bf-95a8-93a29ac2cb04', '731b3369-8d8a-4506-9946-ff45c139e31c', 'emergency_lighting', 'Emergency Lights Testing', 'MONTHLY', 'monthly', 'fire_safety', ARRAY['January Monthly Test For EL-Connaught Square.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, model_number, service_frequency, compliance_category, linked_documents) VALUES ('507c167e-2473-4a1b-8a05-609a891b405b', '731b3369-8d8a-4506-9946-ff45c139e31c', 'emergency_lighting', 'Emergency Lights Testing', 'MONTHLY', 'monthly', 'fire_safety', ARRAY['February Monthly Test For EL-Connaught Square.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('c20a5772-00ed-4173-81dc-928fab589800', '731b3369-8d8a-4506-9946-ff45c139e31c', 'boiler', 'boilers', 'gas_safety', ARRAY['Real Estate Policy (01.23).pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('9249c4f6-cda4-4a3e-80bb-bef49a3292a7', '731b3369-8d8a-4506-9946-ff45c139e31c', 'sprinkler', 'sprinkler leakage', 'fire_safety', ARRAY['Real Estate Policy (01.23).pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('f9c40ff8-2bfc-4b20-8dfa-f01dfb3b4d16', '731b3369-8d8a-4506-9946-ff45c139e31c', 'pump', 'pumping', 'water_safety', ARRAY['Real Estate Policy (01.23).pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('e9c1bf96-a215-4113-903b-a897dea3c33f', '731b3369-8d8a-4506-9946-ff45c139e31c', 'cctv', 'cameras', 'security', ARRAY['Real Estate Policy (01.23).pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('33fb29b1-3b0d-4d87-8a24-58a1d768372b', '731b3369-8d8a-4506-9946-ff45c139e31c', 'fire_extinguisher', 'fire extinguishers', 'fire_safety', ARRAY['Real Estate Policy (01.23).pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('244816af-6af9-4efc-9288-0c95ea0b2b2d', '731b3369-8d8a-4506-9946-ff45c139e31c', 'communal_aerial', 'satellite dishes', 'other', ARRAY['Real Estate Policy (01.23).pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('21adbfb0-c333-49ea-a909-206261a2dc1a', '731b3369-8d8a-4506-9946-ff45c139e31c', 'water_tank', 'water tanks', 'water_safety', ARRAY['Real Estate Policy (01.23).pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('9d02e67c-6723-429e-a484-4ac79a6da569', '731b3369-8d8a-4506-9946-ff45c139e31c', 'sprinkler', 'sprinkler installation', 'fire_safety', ARRAY['Summary of Cover (01.23).pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('4de6f928-cc9b-42ce-88ee-9f4081c191c6', '731b3369-8d8a-4506-9946-ff45c139e31c', 'lift', 'lift in', 'lifts_safety', ARRAY['Summary of Cover (01.23).pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('0ccf588d-ba06-497d-a732-59ab01182b61', '731b3369-8d8a-4506-9946-ff45c139e31c', 'boiler', 'Boilers', 'gas_safety', ARRAY['2023 Allianz VOC - 32-34 Connuaght Square (Freehold) Limited.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('d3a9d31f-6840-462f-af9a-dd1748239528', '731b3369-8d8a-4506-9946-ff45c139e31c', 'lift', 'Lift - Powered', 'lifts_safety', ARRAY['2023 Allianz VOC - 32-34 Connuaght Square (Freehold) Limited.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('7f94bc0c-c25a-434a-a4a9-1b59247a0695', '731b3369-8d8a-4506-9946-ff45c139e31c', 'pump', 'Pumps', 'water_safety', ARRAY['2023 Allianz VOC - 32-34 Connuaght Square (Freehold) Limited.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('51a0964d-6b2a-4fce-9f0d-9ee55af4bc23', '731b3369-8d8a-4506-9946-ff45c139e31c', 'boiler', 'Boilers', 'gas_safety', ARRAY['2023 Engineering Renewal Notice - 32 34 Connuaght Square (Freehold) Limited.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('4acbb1e0-1565-42b1-8188-c19db12dd887', '731b3369-8d8a-4506-9946-ff45c139e31c', 'lift', 'Lift -
Powered', 'lifts_safety', ARRAY['2023 Engineering Renewal Notice - 32 34 Connuaght Square (Freehold) Limited.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('8b526c04-17a7-4a21-af83-6b941c244048', '731b3369-8d8a-4506-9946-ff45c139e31c', 'pump', 'Pumps', 'water_safety', ARRAY['2023 Engineering Renewal Notice - 32 34 Connuaght Square (Freehold) Limited.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('ef3f5d0a-5abd-4834-81b5-dbf71c17eb85', '731b3369-8d8a-4506-9946-ff45c139e31c', 'lift', 'Lift', 'lifts_safety', ARRAY['32-34 Connaught Sq Buildings Insurance 2023-2024.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('653183c6-f698-44d7-a69d-d59bfaadf97c', '731b3369-8d8a-4506-9946-ff45c139e31c', 'lift', 'Lift Report', 'lifts_safety', ARRAY['Allianz - Lift Report 14.03.23.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('74c14d38-e159-4950-bf9d-7d9417ba69f6', '731b3369-8d8a-4506-9946-ff45c139e31c', 'lift', 'Lift Report', 'lifts_safety', ARRAY['Allianz-Lift Report 18.03.2024.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('72ce39bf-e4eb-4980-8223-0f5af9bf3e1c', '731b3369-8d8a-4506-9946-ff45c139e31c', 'lift', 'Lift Report', 'lifts_safety', ARRAY['Allianz - Lift Report - 15.09.21.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('cd5bc233-bc3b-4191-9506-e9e321dd8d8d', '731b3369-8d8a-4506-9946-ff45c139e31c', 'lift', 'Lift Report', 'lifts_safety', ARRAY['Allianz - Lift Report 10.03.22.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('0b35405b-efa0-49f6-8e9e-cfcc0c476327', '731b3369-8d8a-4506-9946-ff45c139e31c', 'boiler', 'Boilers', 'gas_safety', ARRAY['2023 Allianz VOC - 32-34 Connuaght Square (Freehold) Limited.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('63dca444-cc14-4d27-ade2-c3e777cb36dc', '731b3369-8d8a-4506-9946-ff45c139e31c', 'lift', 'Lift - Powered', 'lifts_safety', ARRAY['2023 Allianz VOC - 32-34 Connuaght Square (Freehold) Limited.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('59967fcb-5b66-4e27-b5d2-72b8b968a109', '731b3369-8d8a-4506-9946-ff45c139e31c', 'pump', 'Pumps', 'water_safety', ARRAY['2023 Allianz VOC - 32-34 Connuaght Square (Freehold) Limited.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('19ccdaf7-7140-4340-894f-d95098c976e0', '731b3369-8d8a-4506-9946-ff45c139e31c', 'boiler', 'Boilers', 'gas_safety', ARRAY['2023 Engineering Renewal Notice - 32 34 Connuaght Square (Freehold) Limited.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('30ae1cb0-c7c7-4f5d-82c7-cacffe1371c7', '731b3369-8d8a-4506-9946-ff45c139e31c', 'lift', 'Lift -
Powered', 'lifts_safety', ARRAY['2023 Engineering Renewal Notice - 32 34 Connuaght Square (Freehold) Limited.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('62421eb4-0b36-46d3-b9a1-ba52c305c981', '731b3369-8d8a-4506-9946-ff45c139e31c', 'pump', 'Pumps', 'water_safety', ARRAY['2023 Engineering Renewal Notice - 32 34 Connuaght Square (Freehold) Limited.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, location_description, compliance_category, linked_documents) VALUES ('3be9d358-46fb-4918-b816-ff684331d777', '731b3369-8d8a-4506-9946-ff45c139e31c', 'boiler', 'Boiler and', 'owned by or leased', 'gas_safety', ARRAY['MO - Policy Wording - NZ0411.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('81635bf5-4479-49e5-84a5-dd402ddafb76', '731b3369-8d8a-4506-9946-ff45c139e31c', 'lift', 'Lift and', 'lifts_safety', ARRAY['MO - Policy Wording - NZ0411.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('a60aceee-4c04-436f-a54a-8646f225d6eb', '731b3369-8d8a-4506-9946-ff45c139e31c', 'pump', 'pumps', 'water_safety', ARRAY['MO - Policy Wording - NZ0411.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('f51f4c97-e057-4cd7-8927-6577b55a771d', '731b3369-8d8a-4506-9946-ff45c139e31c', 'water_tank', 'Storage Tanks', 'water_safety', ARRAY['MO - Policy Wording - NZ0411.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('f57d9bb7-6e36-4493-894b-f2fda7f06498', '731b3369-8d8a-4506-9946-ff45c139e31c', 'generator', 'generator sets', 'electrical_safety', ARRAY['MO - Policy Wording - NZ0411.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('54249310-fae2-4ec1-aaad-3b2b3387246b', '731b3369-8d8a-4506-9946-ff45c139e31c', 'lift', 'Lift and', 'lifts_safety', ARRAY['Feature and Benefits of Allianz Engineering Inspection Service.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('b63ab398-11d8-4ae0-8c03-911a201076f7', '731b3369-8d8a-4506-9946-ff45c139e31c', 'boiler', 'Boilers', 'gas_safety', ARRAY['StG_Statement of Facts_32-34 Connaught Square W2 2HL.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('5cf6817d-f466-487e-a69d-3a36ba976252', '731b3369-8d8a-4506-9946-ff45c139e31c', 'lift', 'Lifts', 'lifts_safety', ARRAY['StG_Statement of Facts_32-34 Connaught Square W2 2HL.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('771d0eb4-004d-4ec4-a83d-5a1f503a916e', '731b3369-8d8a-4506-9946-ff45c139e31c', 'pump', 'Centrifugal pump', 'water_safety', ARRAY['StG_Statement of Facts_32-34 Connaught Square W2 2HL.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('b54c09cb-5752-473c-aa2e-0dcc87a97a87', '731b3369-8d8a-4506-9946-ff45c139e31c', 'boiler', 'Boilers', 'gas_safety', ARRAY['StG_Insurance Report_32-34 Connaught Square W2 2HL.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('fc147258-d61d-4e54-a8ed-731b842fd150', '731b3369-8d8a-4506-9946-ff45c139e31c', 'lift', 'Lifts', 'lifts_safety', ARRAY['StG_Insurance Report_32-34 Connaught Square W2 2HL.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('8b019437-c4f7-4794-a37b-df428297fcc0', '731b3369-8d8a-4506-9946-ff45c139e31c', 'pump', 'Centrifugal pump', 'water_safety', ARRAY['StG_Insurance Report_32-34 Connaught Square W2 2HL.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('6eefaca6-1479-48be-ba6b-f09e2c26a210', '731b3369-8d8a-4506-9946-ff45c139e31c', 'boiler', 'Boilers', 'gas_safety', ARRAY['StG_Statement of Facts_32-34 Connaught Square W2 2HL.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('f7a346de-f4f0-4aa3-b002-7e5b92862e8c', '731b3369-8d8a-4506-9946-ff45c139e31c', 'lift', 'Lifts', 'lifts_safety', ARRAY['StG_Statement of Facts_32-34 Connaught Square W2 2HL.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('cd0cfe05-ab9d-4438-8624-2b01466d5e59', '731b3369-8d8a-4506-9946-ff45c139e31c', 'pump', 'Centrifugal pump', 'water_safety', ARRAY['StG_Statement of Facts_32-34 Connaught Square W2 2HL.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('08757662-4902-40b3-9671-39f736f2e2fd', '731b3369-8d8a-4506-9946-ff45c139e31c', 'boiler', 'Boilers', 'gas_safety', ARRAY['StG_Insurance Report_32-34 Connaught Square W2 2HL.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('a17bbed6-f806-4417-a3e9-dcad4242602a', '731b3369-8d8a-4506-9946-ff45c139e31c', 'lift', 'Lifts', 'lifts_safety', ARRAY['StG_Insurance Report_32-34 Connaught Square W2 2HL.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('722503b3-e5a4-4d17-8678-e59159da0586', '731b3369-8d8a-4506-9946-ff45c139e31c', 'pump', 'Centrifugal pump', 'water_safety', ARRAY['StG_Insurance Report_32-34 Connaught Square W2 2HL.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('336fe28c-e56e-457e-bff7-93305e22f261', '731b3369-8d8a-4506-9946-ff45c139e31c', 'boiler', 'water boiler', 'gas_safety', ARRAY['StG_Certificate_32-34 Connaught Square W2 2HL.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('d4e8fd28-5c3f-444a-a5d2-210fbc195a56', '731b3369-8d8a-4506-9946-ff45c139e31c', 'lift', 'Passenger Lift', 'lifts_safety', ARRAY['StG_Certificate_32-34 Connaught Square W2 2HL.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('678025b6-cdb7-4582-bf79-39ce6d5677b6', '731b3369-8d8a-4506-9946-ff45c139e31c', 'pump', 'Centrifugal pump', 'water_safety', ARRAY['StG_Certificate_32-34 Connaught Square W2 2HL.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('68254f5f-8ed1-4b75-81be-c602f776d285', '731b3369-8d8a-4506-9946-ff45c139e31c', 'boiler', 'Boilers', 'gas_safety', ARRAY['StG_Statement of Fact_32-34 Connaught Square W2 2HL.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('c182e358-a87e-4cb9-80e3-ff7631a3c2fb', '731b3369-8d8a-4506-9946-ff45c139e31c', 'lift', 'Lifts', 'lifts_safety', ARRAY['StG_Statement of Fact_32-34 Connaught Square W2 2HL.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('c83fafc5-195d-4fbd-9ee0-cd2dfebce177', '731b3369-8d8a-4506-9946-ff45c139e31c', 'pump', '1x Pump', 'water_safety', ARRAY['StG_Statement of Fact_32-34 Connaught Square W2 2HL.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('729e9f5f-cbd1-4021-8b34-025db652ea78', '731b3369-8d8a-4506-9946-ff45c139e31c', 'lift', 'Lift', 'lifts_safety', ARRAY['FBR113382303-20230405-B.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('ebd841c6-ca02-4988-b2cd-046f36dc492b', '731b3369-8d8a-4506-9946-ff45c139e31c', 'boiler', 'boilers', 'gas_safety', ARRAY['Real Estate Policy (01.23).pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('7732d2b3-1a61-4a41-95c8-66760f5a13d3', '731b3369-8d8a-4506-9946-ff45c139e31c', 'sprinkler', 'sprinkler leakage', 'fire_safety', ARRAY['Real Estate Policy (01.23).pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('f4781d33-8978-4b2e-a64b-bbf4285433a4', '731b3369-8d8a-4506-9946-ff45c139e31c', 'pump', 'pumping', 'water_safety', ARRAY['Real Estate Policy (01.23).pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('8f9e7f5e-7498-4305-b2a9-1589e604b172', '731b3369-8d8a-4506-9946-ff45c139e31c', 'cctv', 'cameras', 'security', ARRAY['Real Estate Policy (01.23).pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('ac7a11a7-93f2-43dd-912c-f6f54acd566b', '731b3369-8d8a-4506-9946-ff45c139e31c', 'fire_extinguisher', 'fire extinguishers', 'fire_safety', ARRAY['Real Estate Policy (01.23).pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('fc0c837d-1c01-4bdf-b094-a21847241388', '731b3369-8d8a-4506-9946-ff45c139e31c', 'communal_aerial', 'satellite dishes', 'other', ARRAY['Real Estate Policy (01.23).pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('d853fbea-66e0-4b03-96ae-2b3d029c1d0f', '731b3369-8d8a-4506-9946-ff45c139e31c', 'water_tank', 'water tanks', 'water_safety', ARRAY['Real Estate Policy (01.23).pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('ba1f670c-2a0a-4e2b-8aae-f162c9f0874e', '731b3369-8d8a-4506-9946-ff45c139e31c', 'sprinkler', 'sprinkler installation', 'fire_safety', ARRAY['Summary of Cover (01.23).pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('782fb61f-730c-465d-ba80-4b0e459b1194', '731b3369-8d8a-4506-9946-ff45c139e31c', 'lift', 'lift in', 'lifts_safety', ARRAY['Summary of Cover (01.23).pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('071bf6ae-5ae8-4a9c-8214-5501e1c5d25f', '731b3369-8d8a-4506-9946-ff45c139e31c', 'lift', 'Lift', 'lifts_safety', ARRAY['32-34 Connaught Sq Buildings Insurance 2023-2024.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('57092a0e-ca2b-49b4-bb65-9da22e4b5282', '731b3369-8d8a-4506-9946-ff45c139e31c', 'sprinkler', 'sprinkler installation', 'fire_safety', ARRAY['Zurich Real Estate Policy Summary.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('05629077-69c3-40d9-9b34-d449943f9f29', '731b3369-8d8a-4506-9946-ff45c139e31c', 'lift', 'lift in', 'lifts_safety', ARRAY['Zurich Real Estate Policy Summary.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('b4a6e1f1-73fe-4534-bceb-73a79a7fd9ae', '731b3369-8d8a-4506-9946-ff45c139e31c', 'boiler', 'boilers', 'gas_safety', ARRAY['Zurich Real Estate Policy Wording.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('5fa0100b-f03d-4323-b798-f325bd48a00d', '731b3369-8d8a-4506-9946-ff45c139e31c', 'sprinkler', 'sprinkler leakage', 'fire_safety', ARRAY['Zurich Real Estate Policy Wording.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('6d669ca5-a4fa-48eb-8686-3324021784e5', '731b3369-8d8a-4506-9946-ff45c139e31c', 'pump', 'pumping', 'water_safety', ARRAY['Zurich Real Estate Policy Wording.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('bc110403-d65f-4125-9198-39447df14aed', '731b3369-8d8a-4506-9946-ff45c139e31c', 'cctv', 'cameras', 'security', ARRAY['Zurich Real Estate Policy Wording.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('fe67272e-4ff0-4f0d-8e9b-a25fc8901b56', '731b3369-8d8a-4506-9946-ff45c139e31c', 'fire_extinguisher', 'fire extinguishers', 'fire_safety', ARRAY['Zurich Real Estate Policy Wording.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('b2af1da5-7713-43e0-88f3-77de451d7096', '731b3369-8d8a-4506-9946-ff45c139e31c', 'communal_aerial', 'satellite dishes', 'other', ARRAY['Zurich Real Estate Policy Wording.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('3dd700f2-77f5-40be-b7aa-7fbe54338049', '731b3369-8d8a-4506-9946-ff45c139e31c', 'water_tank', 'water tanks', 'water_safety', ARRAY['Zurich Real Estate Policy Wording.pdf']);
INSERT INTO assets (id, building_id, asset_type, asset_name, compliance_category, linked_documents) VALUES ('393257d8-1739-479e-a23e-34820c5b66b6', '731b3369-8d8a-4506-9946-ff45c139e31c', 'lift', 'Lift', 'lifts_safety', ARRAY['StG_Certificate_32-34 Connaught Square W2 2HL.pdf']);

-- Insert 22 maintenance schedules
INSERT INTO maintenance_schedules (id, building_id, contract_id, service_type, description, frequency, frequency_interval, next_due_date, estimated_duration, priority, status) VALUES ('07c10407-dec1-48b0-9205-2b746cb88c11', '731b3369-8d8a-4506-9946-ff45c139e31c', '905ba26f-4015-4806-9e3d-13c1e9a79a19', 'lifts', 'lifts - ISS', 'monthly', '1 month', '2025-11-09', '4 hours', 'high', 'scheduled');
INSERT INTO maintenance_schedules (id, building_id, contract_id, service_type, description, frequency, frequency_interval, next_due_date, estimated_duration, priority, status) VALUES ('97b6932c-e8bf-404f-b11f-ac52d89b2a96', '731b3369-8d8a-4506-9946-ff45c139e31c', '0346a08a-28f6-4c2a-9097-20a8bb23933c', 'security', 'security - ISS', 'quarterly', '3 months', '2026-01-09', '8 hours', 'medium', 'scheduled');
INSERT INTO maintenance_schedules (id, building_id, contract_id, service_type, description, frequency, frequency_interval, next_due_date, estimated_duration, priority, status) VALUES ('ea0f3bb9-275f-4f00-9701-57aa90fc54bb', '731b3369-8d8a-4506-9946-ff45c139e31c', 'da2d79ce-457d-4c25-a6b2-d508223cee80', 'security', 'security - ISS', 'quarterly', '3 months', '2026-01-09', '8 hours', 'medium', 'scheduled');
INSERT INTO maintenance_schedules (id, building_id, contract_id, service_type, description, frequency, frequency_interval, next_due_date, estimated_duration, priority, status) VALUES ('d493167e-0335-4dd3-851c-563f3ad07bde', '731b3369-8d8a-4506-9946-ff45c139e31c', 'e338a4fb-0736-4635-87be-0eddd8ce0db4', 'lifts', 'lifts - ISS', 'monthly', '1 month', '2025-11-09', '4 hours', 'high', 'scheduled');
INSERT INTO maintenance_schedules (id, building_id, contract_id, service_type, description, frequency, frequency_interval, next_due_date, estimated_duration, priority, status) VALUES ('94af5697-32ba-4abd-8a06-9ae3c8febc3f', '731b3369-8d8a-4506-9946-ff45c139e31c', '4a269d58-4c83-4522-94b3-80ccc1e3e4ec', 'lifts', 'lifts - ISS', 'monthly', '1 month', '2025-11-09', '4 hours', 'high', 'scheduled');
INSERT INTO maintenance_schedules (id, building_id, contract_id, service_type, description, frequency, frequency_interval, next_due_date, estimated_duration, priority, status) VALUES ('d9ebedfc-cb6b-4067-a717-1710f6fd7725', '731b3369-8d8a-4506-9946-ff45c139e31c', 'd2c3e657-a62d-48ea-be97-42e09f2aa694', 'lifts', 'lifts - ISS', 'monthly', '1 month', '2025-11-09', '4 hours', 'high', 'scheduled');
INSERT INTO maintenance_schedules (id, building_id, contract_id, service_type, description, frequency, frequency_interval, next_due_date, estimated_duration, priority, status) VALUES ('5239b298-bbcb-409b-821a-9b4295982605', '731b3369-8d8a-4506-9946-ff45c139e31c', '8a8a1b2f-fbef-433b-b3ba-d478f3af253e', 'lifts', 'lifts - ISS', 'monthly', '1 month', '2025-11-09', '4 hours', 'high', 'scheduled');
INSERT INTO maintenance_schedules (id, building_id, contract_id, service_type, description, frequency, frequency_interval, next_due_date, estimated_duration, priority, status) VALUES ('da1f835c-2eac-491a-9f11-d54e845abf0c', '731b3369-8d8a-4506-9946-ff45c139e31c', '8f874d3c-e3ed-43f3-9adb-71c216f65eb8', 'lifts', 'lifts - ISS', 'annual', '12 months', '2026-03-14', '4 hours', 'high', 'scheduled');
INSERT INTO maintenance_schedules (id, building_id, contract_id, service_type, description, frequency, frequency_interval, next_due_date, estimated_duration, priority, status) VALUES ('7647d712-aea1-4abf-b5df-5f39dcfc52c4', '731b3369-8d8a-4506-9946-ff45c139e31c', '9aab9f6e-3587-478c-a0ee-3693de6f2dd8', 'lifts', 'lifts - None', 'monthly', '1 month', '2025-02-13', '4 hours', 'high', 'scheduled');
INSERT INTO maintenance_schedules (id, building_id, contract_id, description, frequency, frequency_interval, next_due_date, priority, status) VALUES ('281846b9-c8d0-4635-b4ef-2e2d2f4a07ca', '731b3369-8d8a-4506-9946-ff45c139e31c', 'e57b4889-7aee-460b-bbd2-528587797613', 'None - WHM', 'monthly', '1 month', '2025-11-09', 'medium', 'scheduled');
INSERT INTO maintenance_schedules (id, building_id, contract_id, description, frequency, frequency_interval, next_due_date, priority, status) VALUES ('d9a67881-dd68-46b3-91c9-ef50b11fcc67', '731b3369-8d8a-4506-9946-ff45c139e31c', 'a3ef7a87-7090-4123-a8b5-ae0bbbe7f00e', 'None - WHM', 'monthly', '1 month', '2025-11-09', 'medium', 'scheduled');
INSERT INTO maintenance_schedules (id, building_id, contract_id, description, frequency, frequency_interval, next_due_date, priority, status) VALUES ('e9df9771-053c-4a8c-bb43-2bfb327c7bc2', '731b3369-8d8a-4506-9946-ff45c139e31c', '6996418c-3b8b-4954-89ba-e96e7f67920a', 'None - WHM', 'monthly', '1 month', '2025-11-09', 'medium', 'scheduled');
INSERT INTO maintenance_schedules (id, building_id, contract_id, description, frequency, frequency_interval, next_due_date, priority, status) VALUES ('64e67ad7-d995-4d4e-8555-4168189934dd', '731b3369-8d8a-4506-9946-ff45c139e31c', '9c63fe87-ac3d-450f-87d2-9bd2d6a0d484', 'None - WHM', 'monthly', '1 month', '2025-11-09', 'medium', 'scheduled');
INSERT INTO maintenance_schedules (id, building_id, contract_id, service_type, description, frequency, frequency_interval, next_due_date, estimated_duration, priority, status) VALUES ('45393d17-1359-4d1d-9e58-485fdc38a504', '731b3369-8d8a-4506-9946-ff45c139e31c', '01f8e452-e3d5-4cc8-976e-dbe4888415e0', 'security', 'security - Capita', 'monthly', '1 month', '2025-11-09', '8 hours', 'medium', 'scheduled');
INSERT INTO maintenance_schedules (id, building_id, contract_id, service_type, description, frequency, frequency_interval, next_due_date, estimated_duration, priority, status) VALUES ('824c2d65-a5ee-4d3e-8b72-31d5754f6b76', '731b3369-8d8a-4506-9946-ff45c139e31c', 'e81e17e9-8cbf-45a2-93d3-90530d0b1629', 'fire_alarm', 'fire_alarm - Capita', 'monthly', '1 month', '2025-11-09', '2 hours', 'high', 'scheduled');
INSERT INTO maintenance_schedules (id, building_id, contract_id, service_type, description, frequency, frequency_interval, next_due_date, estimated_duration, priority, status) VALUES ('6dfe4b3b-afaf-4c30-9aa1-6762289dccff', '731b3369-8d8a-4506-9946-ff45c139e31c', '1ac47677-6154-4bfe-aead-e8f135b92e52', 'fire_alarm', 'fire_alarm - None', 'monthly', '1 month', '2025-11-09', '2 hours', 'high', 'scheduled');
INSERT INTO maintenance_schedules (id, building_id, contract_id, service_type, description, frequency, frequency_interval, next_due_date, estimated_duration, priority, status) VALUES ('3757bca3-b631-4d57-87e8-bf1a1b18e5cd', '731b3369-8d8a-4506-9946-ff45c139e31c', 'ecf0dd2b-b171-477b-9f40-9ef61a06f016', 'fire_alarm', 'fire_alarm - None', 'monthly', '1 month', '2025-11-09', '2 hours', 'high', 'scheduled');
INSERT INTO maintenance_schedules (id, building_id, contract_id, service_type, description, frequency, frequency_interval, next_due_date, estimated_duration, priority, status) VALUES ('ad930a7a-2b10-49b8-875b-90d38711763a', '731b3369-8d8a-4506-9946-ff45c139e31c', '30456263-4a94-404b-86f1-abb1a27112f7', 'fire_alarm', 'fire_alarm - None', 'monthly', '1 month', '2025-11-09', '2 hours', 'high', 'scheduled');
INSERT INTO maintenance_schedules (id, building_id, contract_id, description, frequency, frequency_interval, next_due_date, priority, status) VALUES ('9cbfd194-3922-4cbf-a60c-694d5deaee2f', '731b3369-8d8a-4506-9946-ff45c139e31c', 'bd3403f5-4f49-4b9f-b899-e3dd17e7b4f3', 'None - WHM', 'monthly', '1 month', '2025-11-09', 'medium', 'scheduled');
INSERT INTO maintenance_schedules (id, building_id, contract_id, description, frequency, frequency_interval, next_due_date, priority, status) VALUES ('fbb66faf-0316-4cb4-b375-394ca4e95d96', '731b3369-8d8a-4506-9946-ff45c139e31c', '3f40b8e4-1cba-4a30-baf6-f36c39b3f179', 'None - None', 'monthly', '1 month', '2025-11-09', 'medium', 'scheduled');
INSERT INTO maintenance_schedules (id, building_id, contract_id, description, frequency, frequency_interval, next_due_date, priority, status) VALUES ('33c6bb22-ec08-4ccd-89c8-c7894ce539da', '731b3369-8d8a-4506-9946-ff45c139e31c', '94dd5f18-9e8d-4488-a8d9-ac8aac968190', 'None - None', 'monthly', '1 month', '2025-11-09', 'medium', 'scheduled');
INSERT INTO maintenance_schedules (id, building_id, contract_id, description, frequency, frequency_interval, next_due_date, priority, status) VALUES ('949d1e5b-4809-4bb7-b9d0-eee3465a4b28', '731b3369-8d8a-4506-9946-ff45c139e31c', 'eee770e0-fa1a-4188-b235-21edfaaaff7b', 'None - None', 'monthly', '1 month', '2025-11-09', 'medium', 'scheduled');

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


-- Fallback budget for unstructured PDF
INSERT INTO budgets (id, building_id, document_id, period, budget_type, total_amount)
VALUES (
    '8f133e97-a982-40a6-88cb-e84c194df075',
    '731b3369-8d8a-4506-9946-ff45c139e31c',
    '14494f91-4728-44a9-9876-9f93a6122aba',
    'Unknown',
    'service_charge',
    NULL  -- Requires manual entry
)
ON CONFLICT (id) DO NOTHING;

-- Fallback budget for unstructured PDF
INSERT INTO budgets (id, building_id, document_id, period, budget_type, total_amount)
VALUES (
    '046a19e5-9f1e-478a-a525-9ee9e4227e71',
    '731b3369-8d8a-4506-9946-ff45c139e31c',
    '10c32555-2e41-4d25-a8b4-8e22fc4e4948',
    'Unknown',
    'service_charge',
    NULL  -- Requires manual entry
)
ON CONFLICT (id) DO NOTHING;

-- Fallback budget for unstructured PDF
INSERT INTO budgets (id, building_id, document_id, period, budget_type, total_amount)
VALUES (
    'bdfdd8a9-fa54-442b-9b85-baa405907e72',
    '731b3369-8d8a-4506-9946-ff45c139e31c',
    '37750813-5e99-4df5-ac8a-d72fd8acf841',
    'Unknown',
    'service_charge',
    NULL  -- Requires manual entry
)
ON CONFLICT (id) DO NOTHING;

-- Fallback budget for unstructured PDF
INSERT INTO budgets (id, building_id, document_id, period, budget_type, total_amount)
VALUES (
    'f9fe791c-12ac-4df7-be3a-19053a53b2d2',
    '731b3369-8d8a-4506-9946-ff45c139e31c',
    'a3d111c8-b426-435e-a5bb-412b47812dd6',
    'Unknown',
    'service_charge',
    NULL  -- Requires manual entry
)
ON CONFLICT (id) DO NOTHING;

-- Fallback budget for unstructured PDF
INSERT INTO budgets (id, building_id, document_id, period, budget_type, total_amount)
VALUES (
    '70ea3fc4-00fa-47af-9402-ff4bb7baf471',
    '731b3369-8d8a-4506-9946-ff45c139e31c',
    '42280bdf-752d-4303-ab9e-746c4aed76dc',
    '2025',
    'service_charge',
    NULL  -- Requires manual entry
)
ON CONFLICT (id) DO NOTHING;

-- Fallback budget for unstructured PDF
INSERT INTO budgets (id, building_id, document_id, period, budget_type, total_amount)
VALUES (
    '67970937-03f3-4b38-b806-85fd89f50291',
    '731b3369-8d8a-4506-9946-ff45c139e31c',
    '34c84285-08fe-4997-84bc-883d7adf2206',
    '2025',
    'service_charge',
    NULL  -- Requires manual entry
)
ON CONFLICT (id) DO NOTHING;

-- Fallback budget for unstructured PDF
INSERT INTO budgets (id, building_id, document_id, period, budget_type, total_amount)
VALUES (
    'b88cef90-82c9-4042-8d45-b7ef3a9db25d',
    '731b3369-8d8a-4506-9946-ff45c139e31c',
    '40a7c356-57b7-43e0-9a13-3cdf8768e15c',
    '2025',
    'service_charge',
    NULL  -- Requires manual entry
)
ON CONFLICT (id) DO NOTHING;

-- Fallback budget for unstructured PDF
INSERT INTO budgets (id, building_id, document_id, period, budget_type, total_amount)
VALUES (
    '8a8c981a-72b8-432a-9dc9-bdfbbe27e65d',
    '731b3369-8d8a-4506-9946-ff45c139e31c',
    'c53de3ed-8261-45c7-a5b5-c61d5c99b424',
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
    '04578d1d-f03f-43d9-a7ad-2abe96b7b5e4',
    '731b3369-8d8a-4506-9946-ff45c139e31c',
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
    'da9000c4-573c-43b5-80e5-7d52f611cdfe',
    '731b3369-8d8a-4506-9946-ff45c139e31c',
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
    '7e0814f0-403a-4f4b-abec-8008c348f703',
    '731b3369-8d8a-4506-9946-ff45c139e31c',
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
    '3f64415c-1187-4aef-8183-5d3e59c52e6b',
    '731b3369-8d8a-4506-9946-ff45c139e31c',
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
    '031e9685-1fe1-4477-8fed-5e496aca4c64',
    '731b3369-8d8a-4506-9946-ff45c139e31c',
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
    'fb0a891c-7c06-440a-a12f-252eb6b4444d',
    '731b3369-8d8a-4506-9946-ff45c139e31c',
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
    '389c8282-11b1-4551-a7fd-8d71043fa005',
    '731b3369-8d8a-4506-9946-ff45c139e31c',
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
    '248e6785-116a-48c6-abc3-77f4ab0b11c7',
    '731b3369-8d8a-4506-9946-ff45c139e31c',
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
    '01b1c007-e642-41a5-a631-e1f5fe08f4f3',
    '731b3369-8d8a-4506-9946-ff45c139e31c',
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
    '7ed7b1b6-3e76-4cf4-a571-9a1af0dc0657',
    '731b3369-8d8a-4506-9946-ff45c139e31c',
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
    '569bdc71-5978-4308-b772-731c1e14376b',
    '731b3369-8d8a-4506-9946-ff45c139e31c',
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
    '2c6b0596-14dc-4bad-b3b0-6f365e88cc53',
    '731b3369-8d8a-4506-9946-ff45c139e31c',
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
    '814872de-1f51-47d2-9bb0-40ef70b114d0',
    '731b3369-8d8a-4506-9946-ff45c139e31c',
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
    '0e27aa75-0144-44ec-ae0b-e2e95f495682',
    '731b3369-8d8a-4506-9946-ff45c139e31c',
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
    '0ae36012-b7c8-42f9-b056-0c6ff7c38846',
    '731b3369-8d8a-4506-9946-ff45c139e31c',
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
    '457605b1-8a1e-4315-bc54-334a3a6fb075',
    '731b3369-8d8a-4506-9946-ff45c139e31c',
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
    'e08f4bf9-d13d-4fd5-975b-1274e726b3ca',
    '731b3369-8d8a-4506-9946-ff45c139e31c',
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
    '4c8ca707-107a-4f48-bc63-0e606fd15ec6',
    '731b3369-8d8a-4506-9946-ff45c139e31c',
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
    '61e97614-7ce3-4771-ab53-2914ab48b390',
    '731b3369-8d8a-4506-9946-ff45c139e31c',
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
    'b0c0d053-6895-4a2f-9793-70979cc516e2',
    '731b3369-8d8a-4506-9946-ff45c139e31c',
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
    '7ca112ae-f3dd-4928-a4fe-6568154720e4',
    '731b3369-8d8a-4506-9946-ff45c139e31c',
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
    'd193448d-9860-4110-9ff5-76a2090f1444',
    '731b3369-8d8a-4506-9946-ff45c139e31c',
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
    '9d5947c0-d6bb-431a-aee3-b3f25cc76132',
    '731b3369-8d8a-4506-9946-ff45c139e31c',
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
    '1fbae64b-3262-47a8-975a-eb00be0eb7b2',
    '731b3369-8d8a-4506-9946-ff45c139e31c',
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
    '579c1fab-c967-44d6-ab49-d61a00f5c5bf',
    '731b3369-8d8a-4506-9946-ff45c139e31c',
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
    'f583c7fa-1d5a-4ca4-afa1-90f143a3dbe8',
    '731b3369-8d8a-4506-9946-ff45c139e31c',
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
    '45078a6e-1a15-45d4-8ffc-1abee5bb9012',
    '731b3369-8d8a-4506-9946-ff45c139e31c',
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
    '5a7c4e4f-1f74-4151-a345-dd7f21e87caa',
    '731b3369-8d8a-4506-9946-ff45c139e31c',
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
    '22d2e8aa-3e6e-439b-bca4-15eef4e61fdf',
    '731b3369-8d8a-4506-9946-ff45c139e31c',
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
    'd5ef5255-16ad-4beb-8e62-7767e5dd4c1a',
    '731b3369-8d8a-4506-9946-ff45c139e31c',
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
    '5f0d3643-e36e-498f-a922-3be85875a712',
    '731b3369-8d8a-4506-9946-ff45c139e31c',
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
    'e266415e-14d3-4841-b888-e3f1f6e304a4',
    '731b3369-8d8a-4506-9946-ff45c139e31c',
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
    '12fd5044-631b-405b-81f9-8ac255e83106',
    '731b3369-8d8a-4506-9946-ff45c139e31c',
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
    '795d6e60-f715-440a-86c0-2facd61f7b74',
    '731b3369-8d8a-4506-9946-ff45c139e31c',
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
    '05f56d4e-de40-4ff3-acb8-4c7af82df32a',
    '731b3369-8d8a-4506-9946-ff45c139e31c',
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
    'cb91ec68-7910-4d5b-96b9-f4a90f7e1733',
    '731b3369-8d8a-4506-9946-ff45c139e31c',
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
    '3e54e1e6-bcf9-4f73-99a4-01bf05a813db',
    '731b3369-8d8a-4506-9946-ff45c139e31c',
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
    '95242f9b-ca78-496d-877d-376f9058861b',
    '731b3369-8d8a-4506-9946-ff45c139e31c',
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
    'c6f8ccc1-c7ad-45f9-9843-5a4cec508794',
    '731b3369-8d8a-4506-9946-ff45c139e31c',
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
    '7e232c4d-58af-48d7-9f99-af13a025ca3d',
    '731b3369-8d8a-4506-9946-ff45c139e31c',
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
    '54e4d785-2ca4-425f-a023-6eb902347cef',
    '731b3369-8d8a-4506-9946-ff45c139e31c',
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
    '1cf16f57-66ac-403f-bed5-aaf6dbddc97f',
    '731b3369-8d8a-4506-9946-ff45c139e31c',
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
    '699fc26a-20a0-4416-bb29-28997b2c89ff',
    '731b3369-8d8a-4506-9946-ff45c139e31c',
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
    '4340a3cb-f691-4374-ad8d-c7e8e413d20b',
    '731b3369-8d8a-4506-9946-ff45c139e31c',
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
    'b4fc4ec5-603c-45ae-a887-1877076befc7',
    '731b3369-8d8a-4506-9946-ff45c139e31c',
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
    '51d1e6b7-cef2-4a26-89de-9b6108f6d581',
    '731b3369-8d8a-4506-9946-ff45c139e31c',
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
    '176e22b1-0c50-4248-86fb-3d5c5e2b52ab',
    '731b3369-8d8a-4506-9946-ff45c139e31c',
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
    '3b6fdf4d-1a75-4890-8ab9-8b69d56ba0b4',
    '731b3369-8d8a-4506-9946-ff45c139e31c',
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
    'ac7d7538-b3d3-4f6e-9ac0-c4def6057a7f',
    '731b3369-8d8a-4506-9946-ff45c139e31c',
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
    'f48fcd5d-785d-4031-807f-2784dac8703a',
    '731b3369-8d8a-4506-9946-ff45c139e31c',
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
    '4f660cc9-36ba-44a6-8b23-20cab20639d9',
    '731b3369-8d8a-4506-9946-ff45c139e31c',
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
    'b13f18ba-ca85-4b27-afca-dbf609fbad87',
    '731b3369-8d8a-4506-9946-ff45c139e31c',
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
    'f1c206d8-c6bc-424f-87c5-436f0d583a63',
    '731b3369-8d8a-4506-9946-ff45c139e31c',
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
    '1d99f64c-f18c-4407-aa88-ac26a9401a05',
    '731b3369-8d8a-4506-9946-ff45c139e31c',
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
    '5339889c-5609-4d73-b0af-4ac3be3e75b7',
    '731b3369-8d8a-4506-9946-ff45c139e31c',
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
    '4dd22e51-078b-4f29-80af-0327431d2f00',
    '731b3369-8d8a-4506-9946-ff45c139e31c',
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
    '3a619ce7-cebe-42ae-a609-d7c7dac89c7a',
    '731b3369-8d8a-4506-9946-ff45c139e31c',
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
    '52565a9a-a226-4335-a643-e033b9fb109f',
    '731b3369-8d8a-4506-9946-ff45c139e31c',
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
    '0d002e6b-0958-4ce2-825a-9d8e3e160803',
    '731b3369-8d8a-4506-9946-ff45c139e31c',
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
    'a8aa5370-7bac-4d22-9b91-df3746a4f389',
    '731b3369-8d8a-4506-9946-ff45c139e31c',
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
    '6b435f7a-a21a-4da5-9697-02d29d11a496',
    '731b3369-8d8a-4506-9946-ff45c139e31c',
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
    'ac706184-786f-4d70-9d80-00e704deb08e',
    '731b3369-8d8a-4506-9946-ff45c139e31c',
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
    'af5c5e0b-3f7b-4c68-af5c-ee97f084cc7a',
    '731b3369-8d8a-4506-9946-ff45c139e31c',
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
    '8dbe0392-5f1b-44fa-a6f0-ef074bf8766d',
    '731b3369-8d8a-4506-9946-ff45c139e31c',
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
    '9d65e748-69b7-4cbd-b9b7-c123172eefe2',
    '731b3369-8d8a-4506-9946-ff45c139e31c',
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
    '93c471fa-8353-4a0c-9c1a-270a51a27bed',
    '731b3369-8d8a-4506-9946-ff45c139e31c',
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
    '004036ba-d2bf-43c9-9176-61e1c2e6a3d8',
    '731b3369-8d8a-4506-9946-ff45c139e31c',
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
    '554cbfc9-e78e-45e9-832a-2f7fd6452ef1',
    '731b3369-8d8a-4506-9946-ff45c139e31c',
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
    '218190dd-d755-4844-af7b-381b607d1a4f',
    '731b3369-8d8a-4506-9946-ff45c139e31c',
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
    'f3036029-22d5-4765-823c-c4b5e1a2dfdb',
    '731b3369-8d8a-4506-9946-ff45c139e31c',
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
    'a4fbf2cf-8eb8-45da-be56-40b874959fe0',
    '731b3369-8d8a-4506-9946-ff45c139e31c',
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
    '4e320585-619b-427e-b8cf-0b672f381d22',
    '731b3369-8d8a-4506-9946-ff45c139e31c',
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
    '6be62b92-74de-457e-a9ae-79facc61ce0a',
    '731b3369-8d8a-4506-9946-ff45c139e31c',
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
    '36e91ff6-f889-4d52-936f-39417a5b01bd',
    '731b3369-8d8a-4506-9946-ff45c139e31c',
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
    '6cd51685-3261-46d5-9fcb-16359a6e434f',
    '731b3369-8d8a-4506-9946-ff45c139e31c',
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
    '38cd52bb-73cf-41ea-a90e-558d119c143b',
    '731b3369-8d8a-4506-9946-ff45c139e31c',
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
    'c806b2fc-fd77-44d0-afc0-6ddf03821d8e',
    '731b3369-8d8a-4506-9946-ff45c139e31c',
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
    '912ad455-ec5e-42dd-8fac-2fe13bdf0727',
    '731b3369-8d8a-4506-9946-ff45c139e31c',
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
    '634df28e-1814-4e00-84ea-e3a124734694',
    '731b3369-8d8a-4506-9946-ff45c139e31c',
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
    '967790bd-0a6d-4e30-b345-7519e38d4f25',
    '731b3369-8d8a-4506-9946-ff45c139e31c',
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
    '92e1c3f8-1443-4608-a5b6-163f9dd65823',
    '731b3369-8d8a-4506-9946-ff45c139e31c',
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
    '0fb712f3-d517-49d8-850d-80e2ae4c492c',
    '731b3369-8d8a-4506-9946-ff45c139e31c',
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
    '64c95aa2-00d4-4257-8608-94a78e453dce',
    '731b3369-8d8a-4506-9946-ff45c139e31c',
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
    'cf555815-5ae6-43d1-8de2-2852ff044dfc',
    '731b3369-8d8a-4506-9946-ff45c139e31c',
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
    'fdf899e3-38ab-48e3-b631-484cb407aa6f',
    '731b3369-8d8a-4506-9946-ff45c139e31c',
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
    'f3cb80bb-057b-49a8-a666-515fe68351e4',
    '731b3369-8d8a-4506-9946-ff45c139e31c',
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
    '1bb39c5d-0821-4392-b8d5-6aae8dd91b87',
    '731b3369-8d8a-4506-9946-ff45c139e31c',
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
    'c76ba085-2471-4f11-9448-b7ba68667181',
    '731b3369-8d8a-4506-9946-ff45c139e31c',
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
    'b7c2d1e3-59bd-4924-af96-42fc81f9e494',
    '731b3369-8d8a-4506-9946-ff45c139e31c',
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
    '2367f829-00f0-4181-aa34-744e5413cbc8',
    '731b3369-8d8a-4506-9946-ff45c139e31c',
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
    'ccc7a73b-98f3-4e87-a46d-c8ca3f02931c',
    '731b3369-8d8a-4506-9946-ff45c139e31c',
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
    '60c327c2-0e98-4464-a341-b820b69a828e',
    '731b3369-8d8a-4506-9946-ff45c139e31c',
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
    '9ad11327-0001-4615-93a8-2e93abc93502',
    '731b3369-8d8a-4506-9946-ff45c139e31c',
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
    '3e40797b-3a96-4b95-a5c3-d31a97e70090',
    '731b3369-8d8a-4506-9946-ff45c139e31c',
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
    'c7a1a3b9-3e77-4af5-a7e7-4f8d8a05b1e5',
    '731b3369-8d8a-4506-9946-ff45c139e31c',
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
    '4399f424-58d6-42a3-bb52-56cc5f7d1a9e',
    '731b3369-8d8a-4506-9946-ff45c139e31c',
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
    'f4fce722-5444-4348-9097-6399af73961b',
    '731b3369-8d8a-4506-9946-ff45c139e31c',
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
    'd8b6d955-60d3-4536-b04e-03f0d862928f',
    '731b3369-8d8a-4506-9946-ff45c139e31c',
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
    '27bdd0e9-d425-4e2c-8488-5794cb04d400',
    '731b3369-8d8a-4506-9946-ff45c139e31c',
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
    '6c6c7718-7669-4666-8d9b-cbad86927b6e',
    '731b3369-8d8a-4506-9946-ff45c139e31c',
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
    '2da122ee-94e9-4afe-b8f6-a5e4926482e3',
    '731b3369-8d8a-4506-9946-ff45c139e31c',
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
    'bbd73c89-8bb9-4b7a-a498-3cbb1af050cf',
    '731b3369-8d8a-4506-9946-ff45c139e31c',
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
    'abe3e0b3-a44c-422a-bd1c-a398b4493a33',
    '731b3369-8d8a-4506-9946-ff45c139e31c',
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
    'ac554837-afea-4a94-b0ed-65922e405aaf',
    '731b3369-8d8a-4506-9946-ff45c139e31c',
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
    '009249c8-c9a0-4eba-b4c0-2bb6af3ee887',
    '731b3369-8d8a-4506-9946-ff45c139e31c',
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
    '5371765f-1250-4e33-a18c-3b3406722fbf',
    '731b3369-8d8a-4506-9946-ff45c139e31c',
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
    '87ad0fb1-d39e-40b3-b787-602ece7aaffb',
    '731b3369-8d8a-4506-9946-ff45c139e31c',
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
    '455816a0-4d7d-47c5-8d98-51c92765612d',
    '731b3369-8d8a-4506-9946-ff45c139e31c',
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
    '17f09dda-a02b-4813-a127-0a2f2515c17d',
    '731b3369-8d8a-4506-9946-ff45c139e31c',
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
    '157a3fab-8bcd-4093-99ce-7400ba07280a',
    '731b3369-8d8a-4506-9946-ff45c139e31c',
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
    'e03bb009-6a6c-4f2b-b810-46d0b4a206be',
    '731b3369-8d8a-4506-9946-ff45c139e31c',
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
    '21442abc-7ce9-4b16-9c4f-b82fd4934a35',
    '731b3369-8d8a-4506-9946-ff45c139e31c',
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
    '6e6c9427-9478-4486-bfd0-3d654fe88f47',
    '731b3369-8d8a-4506-9946-ff45c139e31c',
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
    'fb56a65a-f98d-4200-9a8b-486b485ff5ee',
    '731b3369-8d8a-4506-9946-ff45c139e31c',
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
    '5f72fcb1-7da1-4227-b777-5361ac0c9614',
    '731b3369-8d8a-4506-9946-ff45c139e31c',
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
    'f140a5a9-b39b-45c6-9e45-5b2be4979a5f',
    '731b3369-8d8a-4506-9946-ff45c139e31c',
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
    '96bf7ebf-a64b-4c75-b0e3-32d0cdd27e07',
    '731b3369-8d8a-4506-9946-ff45c139e31c',
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
    '0023f2b3-260c-4646-bf4f-128600bcfe94',
    '731b3369-8d8a-4506-9946-ff45c139e31c',
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
    'dc0adbde-8566-43ca-be80-b6ce29498171',
    '731b3369-8d8a-4506-9946-ff45c139e31c',
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
    '9079a511-c4f1-45f4-ac37-46530a1ad66d',
    '731b3369-8d8a-4506-9946-ff45c139e31c',
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
    'c7c15d5f-fc0b-4f5e-b4ac-c1b5f19e5c01',
    '731b3369-8d8a-4506-9946-ff45c139e31c',
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
    '22b7f118-0030-4872-88ea-b6fcf5c6a7ee',
    '731b3369-8d8a-4506-9946-ff45c139e31c',
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
    '13ab1a54-93da-47cd-9687-e18915c6ae26',
    '731b3369-8d8a-4506-9946-ff45c139e31c',
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
    '8064f383-7394-4fcb-ad0b-04504e584c15',
    '731b3369-8d8a-4506-9946-ff45c139e31c',
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
    '937db193-be2d-41d9-a32d-d5c9c06eecb2',
    '731b3369-8d8a-4506-9946-ff45c139e31c',
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
    'a13e91d5-b6e0-49f6-8f63-ea1c7cb06360',
    '731b3369-8d8a-4506-9946-ff45c139e31c',
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
    '64aecf8d-9969-4edd-a5d8-7bc570bc8e87',
    '731b3369-8d8a-4506-9946-ff45c139e31c',
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
    'b8bcc713-bb74-4b59-bd22-0c46e7bee755',
    '731b3369-8d8a-4506-9946-ff45c139e31c',
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
    'a7d0b3d6-6433-4fc2-9509-5ff24477c01a',
    '731b3369-8d8a-4506-9946-ff45c139e31c',
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
    'efa8c032-1d6c-4c6c-b06d-7a6832f2671d',
    '731b3369-8d8a-4506-9946-ff45c139e31c',
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
    '7210b79a-9fba-463e-a761-0ce8b07f8c57',
    '731b3369-8d8a-4506-9946-ff45c139e31c',
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
    '0961bf1e-85f0-4742-9efb-6fb969009442',
    '731b3369-8d8a-4506-9946-ff45c139e31c',
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
    '893501d8-0fe4-43db-9903-b6853ebf4467',
    '731b3369-8d8a-4506-9946-ff45c139e31c',
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
    '4b21c1b2-0e76-4534-afb1-affc42d2537f',
    '731b3369-8d8a-4506-9946-ff45c139e31c',
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
    '71a3023c-50d1-43b1-8688-cb588bd3b761',
    '731b3369-8d8a-4506-9946-ff45c139e31c',
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
    '23c8b50d-1e3b-45ac-b6be-9dc89f0cd5dd',
    '731b3369-8d8a-4506-9946-ff45c139e31c',
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
    '11a60928-2b38-44ce-8b8a-7a76c518969a',
    '731b3369-8d8a-4506-9946-ff45c139e31c',
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
    'f85ef34f-e2d2-433f-8f5c-e2073246f818',
    '731b3369-8d8a-4506-9946-ff45c139e31c',
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
    'd0f78722-1730-470f-b9de-88b07b410482',
    '731b3369-8d8a-4506-9946-ff45c139e31c',
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
    '09b64ff7-3aeb-47af-b425-cc918cdb0d31',
    '731b3369-8d8a-4506-9946-ff45c139e31c',
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
    'e2011f3d-4e81-4d15-9cf1-cf701e36786c',
    '731b3369-8d8a-4506-9946-ff45c139e31c',
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
    '9bb70545-1ea4-45c3-9056-95bbf6588954',
    '731b3369-8d8a-4506-9946-ff45c139e31c',
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
    'fd4fefda-e1de-4bfa-ad1c-465edce365d2',
    '731b3369-8d8a-4506-9946-ff45c139e31c',
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
    '9d6a4bb6-a16f-4235-8f14-cf450436c2cd',
    '731b3369-8d8a-4506-9946-ff45c139e31c',
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
    '8fd2f50f-d9bf-4535-ac71-b568c4b1b67e',
    '731b3369-8d8a-4506-9946-ff45c139e31c',
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
    'cd6eec83-4e3b-438b-bc92-b73ae58b4577',
    '731b3369-8d8a-4506-9946-ff45c139e31c',
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
    '4d32a46a-9167-4296-b59b-aa057bda8da3',
    '731b3369-8d8a-4506-9946-ff45c139e31c',
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
    'e676e10f-f1a1-43a5-8010-e6d586778b6d',
    '731b3369-8d8a-4506-9946-ff45c139e31c',
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
    'e0d08338-ad1c-4e2b-b445-c74783f883f5',
    '731b3369-8d8a-4506-9946-ff45c139e31c',
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
    'c315b387-2a87-43f8-81be-7e499952a6ff',
    '731b3369-8d8a-4506-9946-ff45c139e31c',
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
    'e418dcb7-14ab-44e0-a703-ca2758b3aced',
    '731b3369-8d8a-4506-9946-ff45c139e31c',
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
    '9275bac6-25bb-489e-9209-6f774a022332',
    '731b3369-8d8a-4506-9946-ff45c139e31c',
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
    '881c5a4a-9286-4093-b9b4-f283c3757eea',
    '731b3369-8d8a-4506-9946-ff45c139e31c',
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
    '021df4f8-e4f3-4a31-b46f-9c278fde9b96',
    '731b3369-8d8a-4506-9946-ff45c139e31c',
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
    '70a08750-7a56-4f98-b49e-22ce49edd45b',
    '731b3369-8d8a-4506-9946-ff45c139e31c',
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
    '16f5f1ed-804e-41a3-9d36-b52b73c535c4',
    '731b3369-8d8a-4506-9946-ff45c139e31c',
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
    'c49724e1-fa19-439c-8598-d460f636a762',
    '731b3369-8d8a-4506-9946-ff45c139e31c',
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
    '58ef787a-f4e0-409f-8bac-8428148e1e05',
    '731b3369-8d8a-4506-9946-ff45c139e31c',
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
    'eadf3f85-9046-4af2-aa8a-13033489ec39',
    '731b3369-8d8a-4506-9946-ff45c139e31c',
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
    '2b676725-64d4-4cfc-b64a-9219f7c1c667',
    '731b3369-8d8a-4506-9946-ff45c139e31c',
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
    '2d268dde-7de5-4d11-95ba-6d2bbb154eb1',
    '731b3369-8d8a-4506-9946-ff45c139e31c',
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
    '48b160de-d77f-4719-b659-9c131617b568',
    '731b3369-8d8a-4506-9946-ff45c139e31c',
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
    '895d0b22-13c4-4652-abcd-6ae452bcb45e',
    '731b3369-8d8a-4506-9946-ff45c139e31c',
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
    '866eb3d0-06ca-41e3-a606-be2bac8ced8a',
    '731b3369-8d8a-4506-9946-ff45c139e31c',
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
    'f533bb0d-aeca-4617-98dd-5f0311a95289',
    '731b3369-8d8a-4506-9946-ff45c139e31c',
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
    '685a0ec3-81ea-4afa-9bfa-af7f8d36122f',
    '731b3369-8d8a-4506-9946-ff45c139e31c',
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
    '7587e61c-099f-41a7-a807-d145733f39c3',
    '731b3369-8d8a-4506-9946-ff45c139e31c',
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
    'a43c3e6a-c282-4d09-bcb1-8011d38b6a3c',
    '731b3369-8d8a-4506-9946-ff45c139e31c',
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
    '12af78ca-f4d2-4ed8-8c68-c120b0177614',
    '731b3369-8d8a-4506-9946-ff45c139e31c',
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
    '936f2800-72eb-47b6-aa87-b85db3b60ebb',
    '731b3369-8d8a-4506-9946-ff45c139e31c',
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
    'a899b032-23f0-4e67-859f-a1eefaa4a074',
    '731b3369-8d8a-4506-9946-ff45c139e31c',
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
    'c45c407b-9327-484a-a273-adb5c00bad42',
    '731b3369-8d8a-4506-9946-ff45c139e31c',
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
    '661f2492-ae6e-4d41-bb34-24aa1b15b879',
    '731b3369-8d8a-4506-9946-ff45c139e31c',
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
    'b143a2c0-4c97-442f-8551-ecd16c32a095',
    '731b3369-8d8a-4506-9946-ff45c139e31c',
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
    'c6d8d371-911d-44b3-bd92-9123cea74e28',
    '731b3369-8d8a-4506-9946-ff45c139e31c',
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
    '253db6b3-5332-484f-bb8a-0b2f3dd35992',
    '731b3369-8d8a-4506-9946-ff45c139e31c',
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
    '926aa912-5a67-479f-a787-90dc9ccc26cb',
    '731b3369-8d8a-4506-9946-ff45c139e31c',
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
    '9030265b-49de-4308-884b-d30ba46d08cf',
    '731b3369-8d8a-4506-9946-ff45c139e31c',
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
    '587c00ef-9f18-4f40-9a66-d2a896221fe2',
    '731b3369-8d8a-4506-9946-ff45c139e31c',
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
    'c924741d-0136-412f-b87b-c67bf341199e',
    '731b3369-8d8a-4506-9946-ff45c139e31c',
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
    'ec4d06b9-5f35-4f96-8d79-54e79a22ca5c',
    '731b3369-8d8a-4506-9946-ff45c139e31c',
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
    'c9190c29-3906-406f-99cd-c015296b7238',
    '731b3369-8d8a-4506-9946-ff45c139e31c',
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
    '5a32fc18-2702-4a56-959a-6b20721db430',
    '731b3369-8d8a-4506-9946-ff45c139e31c',
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
    '2931efc2-8107-4c9c-9d5d-0c3e98b22edb',
    '731b3369-8d8a-4506-9946-ff45c139e31c',
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
    '508fdfb6-b6e3-4c2a-973e-aaec78de4c5d',
    '731b3369-8d8a-4506-9946-ff45c139e31c',
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
    '26719107-86d6-43a3-a6fa-6bedaff46c8a',
    '731b3369-8d8a-4506-9946-ff45c139e31c',
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
    '402e27b7-9e3d-4e70-b1e7-22ae881b6523',
    '731b3369-8d8a-4506-9946-ff45c139e31c',
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
    'fef6a262-c8e4-492e-a16d-75e8cf84de46',
    '731b3369-8d8a-4506-9946-ff45c139e31c',
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
    '080e41e1-2752-4fb0-b2b7-1549b95c1f31',
    '731b3369-8d8a-4506-9946-ff45c139e31c',
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
    '7e558c64-ef23-4d9c-a51c-aa48d490a720',
    '731b3369-8d8a-4506-9946-ff45c139e31c',
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
    '745c5b9c-3ec9-41d1-93ee-c7469e6f6543',
    '731b3369-8d8a-4506-9946-ff45c139e31c',
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
    '1db75c16-e849-4c4c-931a-262d70d12e65',
    '731b3369-8d8a-4506-9946-ff45c139e31c',
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
    'b4c62c92-ce7b-4a4e-89d0-387117348efa',
    '731b3369-8d8a-4506-9946-ff45c139e31c',
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
    '1eba7159-df95-4b5d-b6dd-ca5475bd290a',
    '731b3369-8d8a-4506-9946-ff45c139e31c',
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
    'b49e2a06-92a7-4743-b334-8af87ff5faa7',
    '731b3369-8d8a-4506-9946-ff45c139e31c',
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
    '46bcbe72-c57d-485f-9377-576d4eb66c34',
    '731b3369-8d8a-4506-9946-ff45c139e31c',
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
    '845aaf2b-2f1f-428a-bdb8-f1d6fbebe49f',
    '731b3369-8d8a-4506-9946-ff45c139e31c',
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
    '69bdc78b-fe9e-4405-9f85-ecb023015c28',
    '731b3369-8d8a-4506-9946-ff45c139e31c',
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
    'ba777c7a-6e2f-4fc3-b2e4-f57f2e1f1890',
    '731b3369-8d8a-4506-9946-ff45c139e31c',
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
    'b6d7c8ba-5048-4183-b8e1-8865ce720dff',
    '731b3369-8d8a-4506-9946-ff45c139e31c',
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
    'e1a1a41b-0757-4ed0-916f-7b75597271bc',
    '731b3369-8d8a-4506-9946-ff45c139e31c',
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
    '7139b046-8b5f-409f-97b5-ec272a26578c',
    '731b3369-8d8a-4506-9946-ff45c139e31c',
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
    '6d9c19ec-acc9-4c43-9771-e79a2c6b5f71',
    '731b3369-8d8a-4506-9946-ff45c139e31c',
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
    'dbb031c6-0343-4b76-9fca-6e2e0e07cb23',
    '731b3369-8d8a-4506-9946-ff45c139e31c',
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
    '1ae61857-9408-4d4a-821c-406fd09ef34c',
    '731b3369-8d8a-4506-9946-ff45c139e31c',
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
    'ea15628b-d859-4926-9c86-e73ac4d20e50',
    '731b3369-8d8a-4506-9946-ff45c139e31c',
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
    '4585b40d-eed9-4da3-a2ff-b7ef2e7589c5',
    '731b3369-8d8a-4506-9946-ff45c139e31c',
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
    'e957df24-3df5-443b-b7f2-208acf8a412b',
    '731b3369-8d8a-4506-9946-ff45c139e31c',
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
    '7e8126a4-2276-46eb-b65e-c347687e4677',
    '731b3369-8d8a-4506-9946-ff45c139e31c',
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
    'a63555ca-c3b3-48f4-90f2-33691cdc968c',
    '731b3369-8d8a-4506-9946-ff45c139e31c',
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
    '0f4c1559-1ca8-4f20-a204-7c04c8ce870d',
    '731b3369-8d8a-4506-9946-ff45c139e31c',
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
    'fb7c03d9-5b09-4caf-9483-389f91f8c0bc',
    '731b3369-8d8a-4506-9946-ff45c139e31c',
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
    '5773502f-cbc6-42ff-b570-45e5171c9154',
    '731b3369-8d8a-4506-9946-ff45c139e31c',
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
    'cf4c10f0-9c16-4751-a704-7128c11b5196',
    '731b3369-8d8a-4506-9946-ff45c139e31c',
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
    '76c0cbd9-06e2-4e16-aa58-4b521f67747a',
    '731b3369-8d8a-4506-9946-ff45c139e31c',
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
    '64d79ae4-1ce4-47f2-a068-e29ad5660cf7',
    '731b3369-8d8a-4506-9946-ff45c139e31c',
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
    'a5802a4f-efdc-49b1-8da7-8a48b4470512',
    '731b3369-8d8a-4506-9946-ff45c139e31c',
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
    '19907092-d5e5-431b-8bf9-87228412bac8',
    '731b3369-8d8a-4506-9946-ff45c139e31c',
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
    '940b6043-39cf-489d-82c1-999269f9fcf9',
    '731b3369-8d8a-4506-9946-ff45c139e31c',
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
    '9fc2d657-914d-4cc9-82da-1a6da18b5b83',
    '731b3369-8d8a-4506-9946-ff45c139e31c',
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
    'e50a51c8-d549-46d8-92f7-c4950d961698',
    '731b3369-8d8a-4506-9946-ff45c139e31c',
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
    '733ca1a7-873b-4d6e-a8fb-af1b7347926d',
    '731b3369-8d8a-4506-9946-ff45c139e31c',
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
    '8790a1ca-66b6-4904-b31c-15a240206201',
    '731b3369-8d8a-4506-9946-ff45c139e31c',
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
    '755984ff-f659-430f-bc05-f52aa111de43',
    '731b3369-8d8a-4506-9946-ff45c139e31c',
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
    '9948394c-23d3-4884-aa95-9bce7bb51397',
    '731b3369-8d8a-4506-9946-ff45c139e31c',
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
    'db980b20-5e08-4b16-a02c-9ec9dd6afc29',
    '731b3369-8d8a-4506-9946-ff45c139e31c',
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
    '7ba234cf-1571-4a70-8060-5cde9fe31b9b',
    '731b3369-8d8a-4506-9946-ff45c139e31c',
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
    '265fa8dc-b74a-4fe4-b728-fe21c3a3a91c',
    '731b3369-8d8a-4506-9946-ff45c139e31c',
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
    'f8f80c3b-1565-4444-b9d9-8a8d63300fe4',
    '731b3369-8d8a-4506-9946-ff45c139e31c',
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
    'ce36107d-db95-40c0-a49e-7e9f18c76ac0',
    '731b3369-8d8a-4506-9946-ff45c139e31c',
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
    'b4b95484-e95f-4f6f-a923-0fc583952681',
    '731b3369-8d8a-4506-9946-ff45c139e31c',
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
    'c9afa106-bc87-4410-bc46-6179a31f16bc',
    '731b3369-8d8a-4506-9946-ff45c139e31c',
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
    '8a40b57e-d28f-4dc3-b4be-8a864602c6ef',
    '731b3369-8d8a-4506-9946-ff45c139e31c',
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
    'b6a1a132-724b-4cad-8730-b719a3a90edf',
    '731b3369-8d8a-4506-9946-ff45c139e31c',
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
    '80877590-e87a-4559-ad73-fe97ccd1076c',
    '731b3369-8d8a-4506-9946-ff45c139e31c',
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
    'dd2e72c2-5781-4d40-8e9e-54b069b92d79',
    '731b3369-8d8a-4506-9946-ff45c139e31c',
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
    'baa6058d-fddc-47c8-9ae4-586ce6d9cb05',
    '731b3369-8d8a-4506-9946-ff45c139e31c',
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
    '491429ac-84d1-4b68-8e44-2157a434b912',
    '731b3369-8d8a-4506-9946-ff45c139e31c',
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
    'ff362ded-2041-40de-88fa-dc52260a6d4c',
    '731b3369-8d8a-4506-9946-ff45c139e31c',
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
    'b4deb5b3-de87-42c5-8b66-1e1dff3459e2',
    '731b3369-8d8a-4506-9946-ff45c139e31c',
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
    '8a45b58c-7aac-4f1a-be62-41c4bc4ceb6b',
    '731b3369-8d8a-4506-9946-ff45c139e31c',
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
    'ac2387f2-7a89-4fb5-b495-1f08e5d15461',
    '731b3369-8d8a-4506-9946-ff45c139e31c',
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
    '62125f88-4422-4045-a05f-094de415b56f',
    '731b3369-8d8a-4506-9946-ff45c139e31c',
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
    'b3824b40-2630-4c76-b5d3-b9e1addbd373',
    '731b3369-8d8a-4506-9946-ff45c139e31c',
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
    '4653a899-6309-4486-a0c0-89be42415c57',
    '731b3369-8d8a-4506-9946-ff45c139e31c',
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
    '91103842-fe1a-48f4-b15c-4eaabe4d6337',
    '731b3369-8d8a-4506-9946-ff45c139e31c',
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
    '55366436-6ee2-4709-a385-ab27c524f39e',
    '731b3369-8d8a-4506-9946-ff45c139e31c',
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
    '0e668a7e-ec60-4ede-b448-041a3fc5b51d',
    '731b3369-8d8a-4506-9946-ff45c139e31c',
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
    '9ffca6e3-6a2a-4923-a674-5d7f3008ef4b',
    '731b3369-8d8a-4506-9946-ff45c139e31c',
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
    '99189815-77f0-4afc-b36f-75a280fbb05c',
    '731b3369-8d8a-4506-9946-ff45c139e31c',
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
    '39492341-f6c2-402e-abbe-619c55367017',
    '731b3369-8d8a-4506-9946-ff45c139e31c',
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
    '917c5434-5b13-4c90-a9a7-ca07a3eeeb3a',
    '731b3369-8d8a-4506-9946-ff45c139e31c',
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
    '498d0358-c9dc-4ae1-89d2-be3e105ceae0',
    '731b3369-8d8a-4506-9946-ff45c139e31c',
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
    '57ea77e4-2706-4045-9fc6-e8fa33dac85b',
    '731b3369-8d8a-4506-9946-ff45c139e31c',
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
    '2aa944c4-3f71-43c7-8a22-65ab10d2fe77',
    '731b3369-8d8a-4506-9946-ff45c139e31c',
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
    'f47f939c-2175-42c7-a5f6-32aea7838fd3',
    '731b3369-8d8a-4506-9946-ff45c139e31c',
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
    'dd7867af-753a-4ce9-9ee6-93a810585984',
    '731b3369-8d8a-4506-9946-ff45c139e31c',
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
    'af760749-0dd2-4184-b749-25c010d69345',
    '731b3369-8d8a-4506-9946-ff45c139e31c',
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
    'c820d41c-6efa-4fe2-ae40-a6f79350dee8',
    '731b3369-8d8a-4506-9946-ff45c139e31c',
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
    '819645e1-c5f1-47f1-b5b2-f39b0e02e0b3',
    '731b3369-8d8a-4506-9946-ff45c139e31c',
    'boiler_location',
    'utilities',
    'Boiler',
    NULL,
    'Gaskets Very Very',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;
