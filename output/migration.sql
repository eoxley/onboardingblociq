-- BlocIQ Onboarder - Auto-generated Migration
-- Generated at: 2025-10-06T07:33:04.553413
-- Review this script before executing!

-- =====================================
-- REQUIRED: Replace AGENCY_ID_PLACEHOLDER with your agency UUID
-- =====================================

-- =====================================
-- SCHEMA MIGRATIONS: Add missing columns if they don't exist
-- =====================================

-- Add building_id to leaseholders (if not exists)
ALTER TABLE leaseholders ADD COLUMN IF NOT EXISTS building_id uuid;

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
-- DATA MIGRATION: Insert building data
-- =====================================

-- Example: INSERT INTO agencies (id, name) VALUES ('AGENCY_ID_PLACEHOLDER', 'My Agency')
-- ON CONFLICT (id) DO NOTHING;

INSERT INTO portfolios (id, agency_id, name)
VALUES ('9d443c5f-f0e0-4308-a5fd-a1a76d0cface', 'AGENCY_ID_PLACEHOLDER', 'Default Portfolio')
ON CONFLICT (id) DO NOTHING;

BEGIN;

-- Insert building
INSERT INTO buildings (id, name, address) VALUES ('c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3', 'Connaught Square', 'CONNAUGHT SQUARE');

-- Insert 8 units
INSERT INTO units (id, building_id, unit_number) VALUES ('f3ab3a59-a10a-44ba-97cb-2d52d2192ba8', 'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3', 'Flat 1');
INSERT INTO units (id, building_id, unit_number) VALUES ('bed209d7-3e5c-4138-b2bb-fbb331c82617', 'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3', 'Flat 2');
INSERT INTO units (id, building_id, unit_number) VALUES ('978db428-de43-4568-a0b2-f0fa739c59f2', 'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3', 'Flat 3');
INSERT INTO units (id, building_id, unit_number) VALUES ('575fe98e-23fb-4799-a521-dfd48c582fc9', 'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3', 'Flat 4');
INSERT INTO units (id, building_id, unit_number) VALUES ('6e2545cc-9cbc-4342-b509-9b6f7ad9de38', 'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3', 'Flat 5');
INSERT INTO units (id, building_id, unit_number) VALUES ('e01e5e65-c930-45bb-8503-2eaedf1c52b0', 'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3', 'Flat 6');
INSERT INTO units (id, building_id, unit_number) VALUES ('1a4d9f82-872f-4962-a158-44d5e8589f2d', 'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3', 'Flat 7');
INSERT INTO units (id, building_id, unit_number) VALUES ('de834633-a9a7-4573-b5a0-2f6599ba7641', 'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3', 'Flat 8');

-- Insert 8 leaseholders
INSERT INTO leaseholders (id, building_id, unit_number, first_name, last_name) VALUES ('ee477c81-6adf-4760-832a-72b54993b021', 'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3', 'Flat 1', 'Marmotte', 'Holdings Limited');
INSERT INTO leaseholders (id, building_id, unit_number, title, first_name, last_name) VALUES ('42ea3172-32c4-4e20-8533-f379ba2e7190', 'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3', 'Flat 2', 'Ms', 'V', 'Rebulla');
INSERT INTO leaseholders (id, building_id, unit_number, title, first_name, last_name) VALUES ('3ab7536f-bbe1-4869-9607-d4a6f8a8764b', 'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3', 'Flat 3', 'Ms', 'V', 'Rebulla');
INSERT INTO leaseholders (id, building_id, unit_number, title, first_name, last_name, notes) VALUES ('2bb98d30-ddc9-4784-8625-8bb7c0e9eac1', 'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3', 'Flat 4', 'Mr', 'P', 'J J Reynish', 'Joint owners: Mr P J J Reynish & Ms C A O''Loughlin');
INSERT INTO leaseholders (id, building_id, unit_number, first_name, last_name, notes) VALUES ('d18cf96c-1c82-4981-883a-4221ca79dedb', 'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3', 'Flat 5', 'Mr', 'Mr', 'Joint owners: Mr & Mrs M D Samworth');
INSERT INTO leaseholders (id, building_id, unit_number, title, first_name, last_name, notes) VALUES ('016fef9a-12b9-437d-9a13-11b6aa20ef10', 'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3', 'Flat 6', 'Mr', 'M', 'D', 'Joint owners: Mr M D & Mrs C P Samworth');
INSERT INTO leaseholders (id, building_id, unit_number, title, first_name, last_name) VALUES ('b8cc7440-f908-4a43-90d9-b731ed4da423', 'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3', 'Flat 7', 'Ms', 'J', 'Gomm');
INSERT INTO leaseholders (id, building_id, unit_number, title, first_name, last_name, notes) VALUES ('b007bb64-432e-4e65-a66f-5dc9291230ff', 'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3', 'Flat 8', 'Miss', 'T', 'V Samwoth', 'Joint owners: Miss T V Samwoth & Miss G E Samworth');

-- Insert 56 compliance assets
INSERT INTO compliance_assets (id, building_id, category, asset_name, asset_type, inspection_frequency, description, last_inspection_date, next_due_date, compliance_status) VALUES ('2498e740-09cf-4b68-ab7a-4d6990432d27', 'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3', 'compliance', 'Compliance Asset', 'general', '12 months', 'Extracted from 2024 Directors Meeting-Notes.docx', '2024-01-01', '2025-01-01', 'overdue');
INSERT INTO compliance_assets (id, building_id, category, asset_name, asset_type, inspection_frequency, description, compliance_status, location) VALUES ('6598ac69-4e35-4341-b6a9-066949fd4799', 'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3', 'compliance', 'Fire Door Inspection', 'fire_safety', '12 months', 'Extracted from Fire Door (Communal) Inspection (11m +) (7).pdf', 'unknown', 'Communal');
INSERT INTO compliance_assets (id, building_id, category, asset_name, asset_type, inspection_frequency, description, compliance_status) VALUES ('8857a218-f157-408e-852e-437d5019e138', 'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3', 'compliance', 'Fire Door Inspection', 'fire_safety', '12 months', 'Extracted from Fire Door (Flats) Inspection (11m +) (13).pdf', 'unknown');
INSERT INTO compliance_assets (id, building_id, category, asset_name, asset_type, inspection_frequency, description, compliance_status) VALUES ('a76e628b-c0d3-4e09-ab1c-a90476d7efaa', 'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3', 'compliance', 'Fire Door Inspection', 'fire_safety', '12 months', 'Extracted from Fire Door (Flats) Inspection (11m +) (18).pdf', 'unknown');
INSERT INTO compliance_assets (id, building_id, category, asset_name, asset_type, inspection_frequency, description, compliance_status) VALUES ('5f0b4e47-bea9-4f62-acd8-066f634a24ea', 'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3', 'compliance', 'Fire Door Inspection', 'fire_safety', '12 months', 'Extracted from Fire Door (Flats) Inspection (11m +) (14).pdf', 'unknown');
INSERT INTO compliance_assets (id, building_id, category, asset_name, asset_type, inspection_frequency, description, compliance_status) VALUES ('e0cc93d0-41f4-451f-a173-2c69f2ca6eba', 'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3', 'compliance', 'Electrical Installation Condition Report (EICR)', 'electrical', '60 months', 'Extracted from EICR Cuanku 32-34 conaught square.pdf', 'unknown');
INSERT INTO compliance_assets (id, building_id, category, asset_name, asset_type, inspection_frequency, description, compliance_status) VALUES ('31c4e4ce-589c-4ec1-bffc-b50d1c879f5b', 'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3', 'compliance', 'Fire Door Inspection', 'fire_safety', '12 months', 'Extracted from Fire Door (Flats) Inspection (11m +) (15).pdf', 'unknown');
INSERT INTO compliance_assets (id, building_id, category, asset_name, asset_type, inspection_frequency, description, last_inspection_date, next_due_date, compliance_status) VALUES ('da3db2be-13b6-41a4-a38b-b636719830c1', 'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3', 'compliance', 'Fire Risk Assessment (FRA)', 'fire_safety', '12 months', 'Extracted from 221037_Fra1-L-394697-071223 32-34 Connaught Square_2024-01-02_163759 (1).pdf', '2024-01-02', '2025-01-02', 'overdue');
INSERT INTO compliance_assets (id, building_id, category, asset_name, asset_type, inspection_frequency, description, compliance_status) VALUES ('0114c39c-3a2f-46ae-bd4c-193161e9f5b3', 'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3', 'compliance', 'Fire Door Inspection', 'fire_safety', '12 months', 'Extracted from Fire Door (Flats) Inspection (11m +) (19).pdf', 'unknown');
INSERT INTO compliance_assets (id, building_id, category, asset_name, asset_type, inspection_frequency, description, compliance_status) VALUES ('8901b5b7-240b-4105-9efc-17f88c93f0c7', 'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3', 'compliance', 'Compliance Asset', 'general', '12 months', 'Extracted from 001132-3234-Connaught-Square-London.pdf', 'unknown');
INSERT INTO compliance_assets (id, building_id, category, asset_name, asset_type, inspection_frequency, description, last_inspection_date, next_due_date, compliance_status) VALUES ('eb39d247-1327-49db-95d5-5d568641752d', 'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3', 'compliance', 'Compliance Asset', 'general', '12 months', 'Extracted from 221038_Hsra1-L-394697-071223 32-34 Connaught Square_2024-01-02_163759 (1).pdf', '2024-01-02', '2025-01-02', 'overdue');
INSERT INTO compliance_assets (id, building_id, category, asset_name, asset_type, inspection_frequency, description, compliance_status) VALUES ('0b284542-c301-446a-8e9b-c3a53d48143a', 'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3', 'compliance', 'Compliance Asset', 'general', '12 months', 'Extracted from TETRA - Asbestos Re-Inspection Survey 14.06.22.pdf', 'unknown');
INSERT INTO compliance_assets (id, building_id, category, asset_name, asset_type, inspection_frequency, description, compliance_status) VALUES ('188fe0ad-280d-42ea-9bfe-7515f24306eb', 'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3', 'compliance', 'Fire Door Inspection', 'fire_safety', '12 months', 'Extracted from Fire Door (Flats) Inspection (11m +) (16).pdf', 'unknown');
INSERT INTO compliance_assets (id, building_id, category, asset_name, asset_type, inspection_frequency, description, compliance_status) VALUES ('0012ca33-2647-40b1-a2e2-e8bab8e5f1c3', 'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3', 'compliance', 'Fire Door Inspection', 'fire_safety', '12 months', 'Extracted from Fire Door (Flats) Inspection (11m +) (17).pdf', 'unknown');
INSERT INTO compliance_assets (id, building_id, category, asset_name, asset_type, inspection_frequency, description, compliance_status) VALUES ('16046826-3b73-4601-a05d-9794eff8ce21', 'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3', 'compliance', 'Legionella Risk Assessment', 'water_safety', '24 months', 'Extracted from WHM Legionella Risk Assessment 07.06.22.pdf', 'unknown');
INSERT INTO compliance_assets (id, building_id, category, asset_name, asset_type, inspection_frequency, description, last_inspection_date, next_due_date, compliance_status) VALUES ('c355b7ba-d41c-4d34-a0e4-5db4ab77f86a', 'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3', 'compliance', 'Electrical Installation Condition Report (EICR)', 'electrical', '60 months', 'Extracted from EICR Report Cunaku SATISFACTORY 2023 .pdf', '2023-01-01', '2028-01-01', 'compliant');
INSERT INTO compliance_assets (id, building_id, category, asset_name, asset_type, inspection_frequency, description, last_inspection_date, next_due_date, compliance_status) VALUES ('14c1f362-3837-43f3-a959-fae0bc95b4ca', 'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3', 'compliance', 'Compliance Asset', 'general', '12 months', 'Extracted from 2024 Directors Meeting-Notes.docx', '2024-01-01', '2025-01-01', 'overdue');
INSERT INTO compliance_assets (id, building_id, category, asset_name, asset_type, inspection_frequency, description, compliance_status) VALUES ('2a7f7bf3-99ee-43b0-aac2-be9a42a4ff4c', 'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3', 'compliance', 'Compliance Asset', 'general', '12 months', 'Extracted from 001457-3234-Connaught-Square-London Certificate.pdf', 'unknown');
INSERT INTO compliance_assets (id, building_id, category, asset_name, asset_type, inspection_frequency, description, compliance_status) VALUES ('32161b77-8065-4dff-a7a0-efc5092dec8d', 'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3', 'compliance', 'Compliance Asset', 'general', '12 months', 'Extracted from TC0001V31 General Terms and Conditions.pdf', 'unknown');
INSERT INTO compliance_assets (id, building_id, category, asset_name, asset_type, inspection_frequency, description, last_inspection_date, next_due_date, compliance_status) VALUES ('f8d84186-e07f-47fd-9aed-2bbc763f9062', 'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3', 'compliance', 'Compliance Asset', 'general', '12 months', 'Extracted from Jobcard_For_Job_No_28992_24-01-2025_1545.pdf', '2025-01-24', '2026-01-24', 'compliant');
INSERT INTO compliance_assets (id, building_id, category, asset_name, asset_type, inspection_frequency, description, compliance_status) VALUES ('2c798967-22de-4e42-805c-461e4b4790b9', 'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3', 'compliance', 'Compliance Asset', 'general', '12 months', 'Extracted from Connaught Square (32-34) - 09.12.24 LRA.pdf', 'unknown');
INSERT INTO compliance_assets (id, building_id, category, asset_name, asset_type, inspection_frequency, description, compliance_status) VALUES ('b3ae4118-1756-4328-908b-60e86c74625d', 'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3', 'compliance', 'Compliance Asset', 'general', '12 months', 'Extracted from SC Certificate - 10072023.pdf', 'unknown');
INSERT INTO compliance_assets (id, building_id, category, asset_name, asset_type, inspection_frequency, description, compliance_status, location) VALUES ('afc68890-13f9-4afb-b644-388ac60192e1', 'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3', 'compliance', 'Fire Door Inspection', 'fire_safety', '12 months', 'Extracted from Fire Door (Communal) Inspection (11m +) (7).pdf', 'unknown', 'Communal');
INSERT INTO compliance_assets (id, building_id, category, asset_name, asset_type, inspection_frequency, description, compliance_status) VALUES ('3a480f75-4060-4ac6-ac9c-6d9299a5cb94', 'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3', 'compliance', 'Fire Door Inspection', 'fire_safety', '12 months', 'Extracted from Fire Door (Flats) Inspection (11m +) (13).pdf', 'unknown');
INSERT INTO compliance_assets (id, building_id, category, asset_name, asset_type, inspection_frequency, description, compliance_status) VALUES ('b2876b37-4b50-4dcd-a584-7768197a33c9', 'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3', 'compliance', 'Fire Door Inspection', 'fire_safety', '12 months', 'Extracted from Fire Door (Flats) Inspection (11m +) (18).pdf', 'unknown');
INSERT INTO compliance_assets (id, building_id, category, asset_name, asset_type, inspection_frequency, description, compliance_status) VALUES ('47b435e7-dad1-4436-a545-c00b5906910c', 'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3', 'compliance', 'Fire Door Inspection', 'fire_safety', '12 months', 'Extracted from Fire Door (Flats) Inspection (11m +) (14).pdf', 'unknown');
INSERT INTO compliance_assets (id, building_id, category, asset_name, asset_type, inspection_frequency, description, compliance_status) VALUES ('f64e79c8-ee25-4f7e-9cf8-af26697c8622', 'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3', 'compliance', 'Fire Door Inspection', 'fire_safety', '12 months', 'Extracted from Fire Door (Flats) Inspection (11m +) (15).pdf', 'unknown');
INSERT INTO compliance_assets (id, building_id, category, asset_name, asset_type, inspection_frequency, description, compliance_status) VALUES ('b6ac9491-b988-4eeb-95ea-3fc343b94687', 'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3', 'compliance', 'Fire Door Inspection', 'fire_safety', '12 months', 'Extracted from Fire Door (Flats) Inspection (11m +) (19).pdf', 'unknown');
INSERT INTO compliance_assets (id, building_id, category, asset_name, asset_type, inspection_frequency, description, compliance_status) VALUES ('28ea54a3-0569-4df4-bedb-db4ce7aac9a8', 'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3', 'compliance', 'Fire Door Inspection', 'fire_safety', '12 months', 'Extracted from Fire Door (Flats) Inspection (11m +) (16).pdf', 'unknown');
INSERT INTO compliance_assets (id, building_id, category, asset_name, asset_type, inspection_frequency, description, compliance_status) VALUES ('27a0e118-1e65-4130-9858-0db775ac374d', 'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3', 'compliance', 'Fire Door Inspection', 'fire_safety', '12 months', 'Extracted from Fire Door (Flats) Inspection (11m +) (17).pdf', 'unknown');
INSERT INTO compliance_assets (id, building_id, category, asset_name, asset_type, inspection_frequency, description, last_inspection_date, next_due_date, compliance_status) VALUES ('bcefbaf0-6e9a-451c-864f-cc5bc5243abe', 'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3', 'compliance', 'Fire Risk Assessment (FRA)', 'fire_safety', '12 months', 'Extracted from 221037_Fra1-L-394697-071223 32-34 Connaught Square_2024-01-02_163759.pdf', '2024-01-02', '2025-01-02', 'overdue');
INSERT INTO compliance_assets (id, building_id, category, asset_name, asset_type, inspection_frequency, description, last_inspection_date, next_due_date, compliance_status) VALUES ('282b88ac-dc29-4b40-a9f7-92653ac8c9fe', 'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3', 'compliance', 'Fire Door Inspection', 'fire_safety', '12 months', 'Extracted from Fire Door (Flats) Inspection (11m +) - 2024-01-24T120747.552.pdf', '2024-01-24', '2025-01-24', 'overdue');
INSERT INTO compliance_assets (id, building_id, category, asset_name, asset_type, inspection_frequency, description, compliance_status) VALUES ('4d6b17e5-f5a6-4e07-9d06-7fbf73c35b57', 'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3', 'compliance', 'Compliance Asset', 'general', '12 months', 'Extracted from Connaught Square (32-34) - 15.11.23 (886) wa.pdf', 'unknown');
INSERT INTO compliance_assets (id, building_id, category, asset_name, asset_type, inspection_frequency, description, last_inspection_date, next_due_date, compliance_status) VALUES ('26e45775-3710-47d7-beaf-1c124713dc38', 'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3', 'compliance', 'Fire Door Inspection', 'fire_safety', '12 months', 'Extracted from Fire Door (Flats) Inspection (11m +) - 2024-01-24T120745.875.pdf', '2024-01-24', '2025-01-24', 'overdue');
INSERT INTO compliance_assets (id, building_id, category, asset_name, asset_type, inspection_frequency, description, last_inspection_date, next_due_date, compliance_status) VALUES ('49fb9c85-cdc5-42d1-910b-3c6b3b110d20', 'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3', 'compliance', 'Fire Door Inspection', 'fire_safety', '12 months', 'Extracted from Fire Door (Flats) Inspection (11m +) - 2024-01-24T120746.424.pdf', '2024-01-24', '2025-01-24', 'overdue');
INSERT INTO compliance_assets (id, building_id, category, asset_name, asset_type, inspection_frequency, description, last_inspection_date, next_due_date, compliance_status, location) VALUES ('791e0cc1-bc95-49f4-976c-7ec521b74eec', 'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3', 'compliance', 'Fire Door Inspection', 'fire_safety', '12 months', 'Extracted from Fire Door (Communal) Inspection (11m +) - 2024-01-24T120743.986.pdf', '2024-01-24', '2025-01-24', 'overdue', 'Communal');
INSERT INTO compliance_assets (id, building_id, category, asset_name, asset_type, inspection_frequency, description, last_inspection_date, next_due_date, compliance_status) VALUES ('28d8bbf2-a762-43a9-a1a2-01d2ee1ff3b6', 'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3', 'compliance', 'Fire Door Inspection', 'fire_safety', '12 months', 'Extracted from Fire Door (Flats) Inspection (11m +) - 2024-01-24T120744.738.pdf', '2024-01-24', '2025-01-24', 'overdue');
INSERT INTO compliance_assets (id, building_id, category, asset_name, asset_type, inspection_frequency, description, last_inspection_date, next_due_date, compliance_status) VALUES ('0db6ed26-fd08-46b1-94a5-8d21fa2e19b5', 'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3', 'compliance', 'Fire Door Inspection', 'fire_safety', '12 months', 'Extracted from Fire Door (Flats) Inspection (11m +) - 2024-01-24T120747.015.pdf', '2024-01-24', '2025-01-24', 'overdue');
INSERT INTO compliance_assets (id, building_id, category, asset_name, asset_type, inspection_frequency, description, last_inspection_date, next_due_date, compliance_status) VALUES ('7ab63e84-9535-4e8b-9b93-2cc71e83700e', 'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3', 'compliance', 'Compliance Asset', 'general', '12 months', 'Extracted from 221038_Hsra1-L-394697-071223 32-34 Connaught Square_2024-01-02_163759.pdf', '2024-01-02', '2025-01-02', 'overdue');
INSERT INTO compliance_assets (id, building_id, category, asset_name, asset_type, inspection_frequency, description, last_inspection_date, next_due_date, compliance_status) VALUES ('6abbc839-9073-40c0-9ec2-af5dc2423a28', 'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3', 'compliance', 'Fire Door Inspection', 'fire_safety', '12 months', 'Extracted from Fire Door (Flats) Inspection (11m +) - 2024-01-24T120745.174.pdf', '2024-01-24', '2025-01-24', 'overdue');
INSERT INTO compliance_assets (id, building_id, category, asset_name, asset_type, inspection_frequency, description, compliance_status) VALUES ('0009a696-bfe4-4043-922d-c2579d261e2f', 'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3', 'compliance', 'Fire Risk Assessment (FRA)', 'fire_safety', '12 months', 'Extracted from Hsfra1-L-422971-210225 32-34 Connaught Square.pdf', 'unknown');
INSERT INTO compliance_assets (id, building_id, category, asset_name, asset_type, inspection_frequency, description, compliance_status) VALUES ('db9cb1ad-e132-4529-a27c-af982d99d177', 'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3', 'compliance', 'Fire Risk Assessment (FRA)', 'fire_safety', '12 months', 'Extracted from Hsfra1-L-422971-210225 32-34 Connaught Square.docx', 'unknown');
INSERT INTO compliance_assets (id, building_id, category, asset_name, asset_type, inspection_frequency, description, last_inspection_date, next_due_date, compliance_status) VALUES ('de2db40c-53ab-40af-83c0-2a6b85b589db', 'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3', 'compliance', 'Fire Risk Assessment (FRA)', 'fire_safety', '12 months', 'Extracted from 221037_Fra1-L-394697-071223 32-34 Connaught Square_2024-01-02_163759 (1).pdf', '2024-01-02', '2025-01-02', 'overdue');
INSERT INTO compliance_assets (id, building_id, category, asset_name, asset_type, inspection_frequency, description, last_inspection_date, next_due_date, compliance_status) VALUES ('94a71750-5b54-48bb-885d-36cb88e9552f', 'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3', 'compliance', 'Compliance Asset', 'general', '12 months', 'Extracted from 221038_Hsra1-L-394697-071223 32-34 Connaught Square_2024-01-02_163759 (1).pdf', '2024-01-02', '2025-01-02', 'overdue');
INSERT INTO compliance_assets (id, building_id, category, asset_name, asset_type, inspection_frequency, description, compliance_status) VALUES ('e4ff4efc-973b-45c5-b7d3-25673c93fb34', 'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3', 'compliance', 'Fire Risk Assessment (FRA)', 'fire_safety', '12 months', 'Extracted from FRA-Connaught Square Reccommendations.xlsx', 'unknown');
INSERT INTO compliance_assets (id, building_id, category, asset_name, asset_type, inspection_frequency, description, compliance_status) VALUES ('21f9dc54-a202-4488-97ab-8f4f21fa653b', 'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3', 'compliance', 'Compliance Asset', 'general', '12 months', 'Extracted from 001534-3234-Connaught-Square-London.pdf', 'unknown');
INSERT INTO compliance_assets (id, building_id, category, asset_name, asset_type, inspection_frequency, description, compliance_status) VALUES ('3188f241-f192-4ceb-9bff-ff16f1a7af02', 'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3', 'compliance', 'Compliance Asset', 'general', '12 months', 'Extracted from C1047 - Job card.pdf', 'unknown');
INSERT INTO compliance_assets (id, building_id, category, asset_name, asset_type, inspection_frequency, description, compliance_status) VALUES ('fb716cbb-ab3b-4659-ab11-65193d99fce4', 'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3', 'compliance', 'Legionella Risk Assessment', 'water_safety', '24 months', 'Extracted from WHM Legionella Risk Assessment 09.12.25.pdf', 'unknown');
INSERT INTO compliance_assets (id, building_id, category, asset_name, asset_type, inspection_frequency, description, compliance_status) VALUES ('a334c32f-37e5-4bce-b31c-613826be6feb', 'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3', 'compliance', 'Legionella Risk Assessment', 'water_safety', '24 months', 'Extracted from WHM Legionella Risk Assessment 07.06.22.pdf', 'unknown');
INSERT INTO compliance_assets (id, building_id, category, asset_name, asset_type, inspection_frequency, description, compliance_status) VALUES ('d8e710a3-8ee6-4cff-8de8-e0242f31f0f0', 'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3', 'compliance', 'Compliance Asset', 'general', '12 months', 'Extracted from Connaught Square (32-34) - 29.05.25 (201) wa.pdf', 'unknown');
INSERT INTO compliance_assets (id, building_id, category, asset_name, asset_type, inspection_frequency, description, compliance_status) VALUES ('8f4a2aa3-7d48-4b2f-9c78-f5bf70a5bafc', 'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3', 'compliance', 'Electrical Installation Condition Report (EICR)', 'electrical', '60 months', 'Extracted from EICR Cuanku 32-34 conaught square.pdf', 'unknown');
INSERT INTO compliance_assets (id, building_id, category, asset_name, asset_type, inspection_frequency, description, last_inspection_date, next_due_date, compliance_status) VALUES ('b098a74f-d09f-4535-9197-c95ccd024ea5', 'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3', 'compliance', 'Electrical Installation Condition Report (EICR)', 'electrical', '60 months', 'Extracted from EICR Report Cunaku SATISFACTORY 2023 .pdf', '2023-01-01', '2028-01-01', 'compliant');
INSERT INTO compliance_assets (id, building_id, category, asset_name, asset_type, inspection_frequency, description, compliance_status) VALUES ('4611843d-58a4-41fe-be5f-f4ed0b428cc7', 'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3', 'compliance', 'Compliance Asset', 'general', '12 months', 'Extracted from 001132-3234-Connaught-Square-London.pdf', 'unknown');
INSERT INTO compliance_assets (id, building_id, category, asset_name, asset_type, inspection_frequency, description, compliance_status) VALUES ('b33dc087-63a0-444b-9f0a-d87bec03ce3b', 'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3', 'compliance', 'Compliance Asset', 'general', '12 months', 'Extracted from 001534-3234-Connaught-Square-London.pdf', 'unknown');
INSERT INTO compliance_assets (id, building_id, category, asset_name, asset_type, inspection_frequency, description, compliance_status) VALUES ('3726f1a0-0eda-4b4f-b684-acfb0e07e087', 'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3', 'compliance', 'Compliance Asset', 'general', '12 months', 'Extracted from FINAL L-432900 32-34 Connaught Square Management Survey Report Issue 1.pdf', 'unknown');
INSERT INTO compliance_assets (id, building_id, category, asset_name, asset_type, inspection_frequency, description, compliance_status) VALUES ('82e007bd-0a84-4877-bb0d-195fe179b2da', 'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3', 'compliance', 'Compliance Asset', 'general', '12 months', 'Extracted from TETRA - Asbestos Re-Inspection Survey 14.06.22.pdf', 'unknown');

-- Insert 4 major works projects
INSERT INTO major_works_projects (id, building_id, project_name, status, start_date) VALUES ('c238580f-5779-439d-9c48-c22965d52647', 'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3', 'External Decoration - 2025', 'planned', '2025-01-01');
INSERT INTO major_works_projects (id, building_id, project_name, status, start_date) VALUES ('bdc51a2d-b6b8-45df-9db3-f6de631e18f5', 'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3', 'Section 20 Consultation (SOE) - 2025', 'planned', '2025-01-01');
INSERT INTO major_works_projects (id, building_id, project_name, status, start_date) VALUES ('c5bab58f-ea9f-4c71-80f3-931842c2d333', 'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3', 'Lift - Section 20 (NOI) - 2025', 'planned', '2025-01-01');
INSERT INTO major_works_projects (id, building_id, project_name, status, start_date) VALUES ('a57ccd92-cac1-425a-b4ea-e7d03b194b4b', 'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3', 'Major Works Project - 2025', 'planned', '2025-01-01');

-- Insert 318 document records
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('91f5f472-082c-4e4d-a4bb-134bbb252c30', 'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3', 'lease', 'Important Information .pdf', 'lease/Important Information .pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('ac87d90b-b85b-4948-a9b5-0671d228b079', 'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3', 'finance', 'ACCOUNTS - YE 31.03.21 - Service Charge Accounts (1).pdf', 'finance/ACCOUNTS - YE 31.03.21 - Service Charge Accounts (1).pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('de37a6f7-d1fa-4094-873b-29b6a3d4096b', 'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3', 'lease', 'Official Copy (Lease) 04.08.2022 - NGL809841 (1).pdf', 'lease/Official Copy (Lease) 04.08.2022 - NGL809841 (1).pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('a40baf2d-0f0b-40e8-a87f-3d205248afa3', 'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3', 'lease', 'Official Copy (Lease) 04.08.2022 - NGL809841 (2).pdf', 'lease/Official Copy (Lease) 04.08.2022 - NGL809841 (2).pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('5fb2414b-c048-4db9-a431-d5f0bcee351b', 'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3', 'lease', 'Official Copy (Lease) 13.06.2003 - NGL827422.pdf', 'lease/Official Copy (Lease) 13.06.2003 - NGL827422.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('b8c2cfc3-2b1e-4d45-99dd-cb42273817ad', 'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3', 'lease', 'Official Copy (Lease) 04.08.2022 - NGL809841.pdf', 'lease/Official Copy (Lease) 04.08.2022 - NGL809841.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('45026719-9265-4b1b-8d4a-6405c69f0ed0', 'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3', 'lease', 'Signed April 2025 Arrears Collection Procedure.pdf', 'lease/Signed April 2025 Arrears Collection Procedure.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('844f2af5-234a-499c-8515-34f41f30b9d1', 'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3', 'lease', 'WP0005V17 Welcome Pack.pdf', 'lease/WP0005V17 Welcome Pack.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('7c609dd0-cc7e-44d1-9915-6d5b979606b0', 'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3', 'lease', 'Jobcard_For_Job_No_33844_07-04-2025_1143.pdf', 'lease/Jobcard_For_Job_No_33844_07-04-2025_1143.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('4def3584-26e0-4bc1-b60e-aae001f07ba2', 'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3', 'lease', 'Jobcard_For_Job_No_37675_25-07-2025_1549.pdf', 'lease/Jobcard_For_Job_No_37675_25-07-2025_1549.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('4d8bcbf7-08ba-4402-b28f-5b278e4fa7d6', 'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3', 'lease', 'Jobcard_For_Job_No_34012_01-05-2025_1616.pdf', 'lease/Jobcard_For_Job_No_34012_01-05-2025_1616.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('70ad8532-bee9-43ab-9f5f-e4daa5d82c5f', 'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3', 'lease', 'Jobcard_For_Job_No_32759_17-03-2025_1145.pdf', 'lease/Jobcard_For_Job_No_32759_17-03-2025_1145.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('d0abf9fb-b207-47df-9dc2-835a30174af2', 'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3', 'lease', 'Jobcard_For_Job_No_32810_17-03-2025_1311.pdf', 'lease/Jobcard_For_Job_No_32810_17-03-2025_1311.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('938adc77-fbdf-4176-8a26-b5a6a9345998', 'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3', 'contracts', 'Quote_No_23550 - Connaught Square (32-34) 2023-2024.pdf', 'contracts/Quote_No_23550 - Connaught Square (32-34) 2023-2024.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('3a16d6c2-2a12-4abd-b5c8-a52cc52b4078', 'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3', 'lease', 'Licence_Document_352024.pdf', 'lease/Licence_Document_352024.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('06af10c4-1ac1-4a3c-9530-d70c5f382d12', 'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3', 'lease', 'JLGServiceVisit-M00813-12-09-2024.pdf', 'lease/JLGServiceVisit-M00813-12-09-2024.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('26347cf2-652e-437f-9ee1-b68a63a7b1f2', 'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3', 'lease', 'JLGServiceVisit-M00813-13-11-2024.pdf', 'lease/JLGServiceVisit-M00813-13-11-2024.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('0b8a2946-0db3-4b77-8728-c3092cd9bedf', 'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3', 'lease', 'JLGServiceVisit-M00813-02-12-2024.pdf', 'lease/JLGServiceVisit-M00813-02-12-2024.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('5bf29d4b-8bc7-4083-915b-5951b30c8707', 'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3', 'lease', 'JLGServiceVisit-M00813-08-07-2024.pdf', 'lease/JLGServiceVisit-M00813-08-07-2024.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('4ea428f2-3ca3-433c-8b1a-7ad32c61583d', 'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3', 'lease', 'JLGServiceVisit-M00813-08-10-2024.pdf', 'lease/JLGServiceVisit-M00813-08-10-2024.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('32da300c-3db0-40b8-943c-8edafc57750c', 'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3', 'lease', 'JLGServiceVisit-M00813-12-02-2025.pdf', 'lease/JLGServiceVisit-M00813-12-02-2025.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('fff5a08c-5967-4ab8-8c2a-82f8b3edd87d', 'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3', 'lease', 'JLGServiceVisit-M00813-17-03-2025.pdf', 'lease/JLGServiceVisit-M00813-17-03-2025.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('9734a1ef-a265-407c-ba75-4f9b593e43e3', 'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3', 'lease', 'JLGServiceVisit-M00813-14-04-2025.pdf', 'lease/JLGServiceVisit-M00813-14-04-2025.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('36cef7e2-5d88-4901-b52c-d79a8290aaf1', 'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3', 'lease', 'REP-40343473-L1.pdf', 'lease/REP-40343473-L1.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('3b7c6b3f-e4cc-4c4b-8d42-75e0a1bc63db', 'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3', 'lease', 'JLGServiceVisit-M00813-13-05-2025.pdf', 'lease/JLGServiceVisit-M00813-13-05-2025.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('a00428e6-ceba-4233-8da9-24c4153e4c49', 'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3', 'lease', 'Communal Cleaning-First Port.pdf', 'lease/Communal Cleaning-First Port.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('7afc13a2-b8d9-4a3e-8d0a-8fcd1553686d', 'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3', 'lease', 'SC Health and Safety Product - Accredited 10072023.pdf', 'lease/SC Health and Safety Product - Accredited 10072023.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('eb85dd94-ae35-419b-b4d5-29aa37a0ede5', 'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3', 'lease', 'Tenancy Schedule by Property.pdf', 'lease/Tenancy Schedule by Property.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('af8c2513-2278-461d-9ead-baca06919e59', 'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3', 'finance', 'Accounts YE 31.03.2022 32-34 Connaught Square MJP.pdf', 'finance/Accounts YE 31.03.2022 32-34 Connaught Square MJP.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('65143e32-32e4-4da5-84f5-9a30368c1d53', 'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3', 'finance', '197-YE 31.03.22 SC Accs FINAL MAY 2023.pdf', 'finance/197-YE 31.03.22 SC Accs FINAL MAY 2023.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('ccf1fcaa-7189-4e66-a1aa-9a74dd72c7ee', 'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3', 'finance', 'ACCOUNTS - YE 31.03.21 - Service Charge Accounts (1).pdf', 'finance/ACCOUNTS - YE 31.03.21 - Service Charge Accounts (1).pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('db9047e7-19ea-425b-aae7-f1a13a5fbd4c', 'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3', 'finance', '27039 Accounts Pack - YE 2023.pdf', 'finance/27039 Accounts Pack - YE 2023.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('d9ce1db7-2e2a-4e67-8951-bab99e182443', 'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3', 'finance', 'Connaught Sq SC YE 23.pdf', 'finance/Connaught Sq SC YE 23.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('7e8e895f-27ad-417c-9b35-70b6ed247102', 'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3', 'lease', 'Connaught Square-House Rules.docx', 'lease/Connaught Square-House Rules.docx');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('6fbd6e95-2809-4da6-bd9b-0b9a2d3c02ce', 'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3', 'correspondence', 'Garden Notice-Connaught Square.docx', 'correspondence/Garden Notice-Connaught Square.docx');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('3966c9ba-cfe3-43b4-9017-c5525a2b7325', 'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3', 'correspondence', 'Connaught Square-Key Cut Authorisation Letter.docx', 'correspondence/Connaught Square-Key Cut Authorisation Letter.docx');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('e178c476-1544-4ea6-8c6a-2b147e556442', 'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3', 'lease', 'House Rules-Connaught Square.pdf', 'lease/House Rules-Connaught Square.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('47c73f68-be70-4107-ac7b-ee75f2bccbd5', 'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3', 'lease', 'REP-39659654.pdf', 'lease/REP-39659654.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('2e9f4777-30f1-4da3-8536-23db939cdb09', 'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3', 'lease', 'Important Information .pdf', 'lease/Important Information .pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('66cafa0d-148c-427a-9c5a-17fc0985babb', 'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3', 'lease', 'StG_Certificate_32-34 Connaught Square W2 2HL.pdf', 'lease/StG_Certificate_32-34 Connaught Square W2 2HL.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('0a215018-37f3-4d10-9a39-541f65cb437f', 'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3', 'contracts', 'CM434.AnnualServiceAgreement2025-2026.pdf', 'contracts/CM434.AnnualServiceAgreement2025-2026.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('a6ae2603-67f2-47a6-a57c-037543645afc', 'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3', 'contracts', 'CM434.AnnualServiceAgreement2024-2025.pdf', 'contracts/CM434.AnnualServiceAgreement2024-2025.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('abf940f0-2379-4ba4-b3b9-6fa9b6bbf7f9', 'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3', 'lease', 'REP-40324834-E3.pdf', 'lease/REP-40324834-E3.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('0c3ef397-080d-4367-98b9-0729a94819ec', 'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3', 'lease', 'Ellie@mihproperty.co.uk - BES Group - E-Report.pdf', 'lease/Ellie@mihproperty.co.uk - BES Group - E-Report.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('19ccc2e3-ee2f-46c1-b909-4d1b41af9c99', 'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3', 'lease', 'Jobcard_For_Job_No_38609_26-08-2025_0741.pdf', 'lease/Jobcard_For_Job_No_38609_26-08-2025_0741.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('4a4ff52f-e449-4b15-8aa3-41f25b198d1a', 'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3', 'lease', 'Jobcard_For_Job_No_28737_25-11-2024_0907.pdf', 'lease/Jobcard_For_Job_No_28737_25-11-2024_0907.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('953d30c4-eed1-46e7-b55f-9df26b1aafbb', 'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3', 'lease', 'Jobcard_For_Job_No_35402_03-06-2025_0916.pdf', 'lease/Jobcard_For_Job_No_35402_03-06-2025_0916.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('98bba208-3899-4619-b16a-57ec1cf7bba8', 'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3', 'lease', 'Jobcard_For_Job_No_35654_03-06-2025_0911.pdf', 'lease/Jobcard_For_Job_No_35654_03-06-2025_0911.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('d41761f5-160c-41c9-a4a6-f308c6a6254a', 'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3', 'lease', 'Jobcard_For_Job_No_37675_25-07-2025_1549.pdf', 'lease/Jobcard_For_Job_No_37675_25-07-2025_1549.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('079370c4-fcc5-4033-b6df-a51121c02025', 'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3', 'lease', 'Jobcard_For_Job_No_35146_03-06-2025_0906.pdf', 'lease/Jobcard_For_Job_No_35146_03-06-2025_0906.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('ca54c3af-d064-468e-a112-0eef26710015', 'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3', 'lease', 'Jobcard_For_Job_No_31162_30-01-2025_1602.pdf', 'lease/Jobcard_For_Job_No_31162_30-01-2025_1602.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('bc98d3cf-8596-47f2-b13d-997b2f9364bb', 'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3', 'lease', 'Jobcard_For_Job_No_36465_20-06-2025_1037.pdf', 'lease/Jobcard_For_Job_No_36465_20-06-2025_1037.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path, entity_type, linked_entity_id) VALUES ('495b8be0-96e0-42e7-9c0c-fb90e982969b', 'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3', 'finance', 'connaught apportionment.xlsx', 'finance/connaught apportionment.xlsx', 'budget', '9711402f-3c49-460a-90bc-ce07eeedd255');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path, entity_type, linked_entity_id) VALUES ('ceeb398a-4d2a-4d97-9da6-d2d1b7c1b977', 'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3', 'finance', 'ACCOUNTS - YE 31.03.21 - Service Charge Accounts.pdf', 'finance/ACCOUNTS - YE 31.03.21 - Service Charge Accounts.pdf', 'budget', 'b61d3aa4-7e2a-4479-9f98-5fd513799cd9');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path, entity_type, linked_entity_id) VALUES ('e6445226-51b4-42b3-ac0d-ffc135050e23', 'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3', 'finance', 'Connaught Square Budget 2025-6 Draft.xlsx', 'finance/Connaught Square Budget 2025-6 Draft.xlsx', 'budget', 'a0a9a7dd-9f72-4918-ac97-2a2f514694d5');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path, entity_type, linked_entity_id) VALUES ('c72ea651-727f-4991-98cf-d7c624356ff5', 'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3', 'finance', 'Connaught Square Budget 2025-Final.pdf', 'finance/Connaught Square Budget 2025-Final.pdf', 'budget', '51c8991b-ce30-469f-b13e-a29da80b798f');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path, entity_type, linked_entity_id) VALUES ('5bed5b84-f3c5-43d7-a82d-1dd75efc5010', 'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3', 'finance', 'Connaught Square Budget 2025-Final.xlsx', 'finance/Connaught Square Budget 2025-Final.xlsx', 'budget', '2a81e130-64fb-4c8b-a5b7-421c09658c78');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path, entity_type, linked_entity_id) VALUES ('2a50177f-5e87-41c0-90f6-974b054aaf56', 'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3', 'finance', 'ACCOUNTS - YE 31.03.21 - Service Charge Accounts.pdf', 'finance/ACCOUNTS - YE 31.03.21 - Service Charge Accounts.pdf', 'budget', '1709e914-2be5-486d-b867-a4def323bfc5');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path, entity_type, linked_entity_id) VALUES ('612b33f5-2c5c-4b2d-9814-71828ed5561d', 'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3', 'finance', 'Connaught Square YE 24 Accounts.pdf', 'finance/Connaught Square YE 24 Accounts.pdf', 'budget', 'f730ad6b-72c1-49cd-9496-ef6d90fa625f');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path, entity_type, linked_entity_id) VALUES ('389150cf-3ed5-467c-b0ae-96db2a29f7b9', 'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3', 'compliance', '2024 Directors Meeting-Notes.docx', 'compliance/2024 Directors Meeting-Notes.docx', 'compliance_asset', '2498e740-09cf-4b68-ab7a-4d6990432d27');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path, entity_type, linked_entity_id) VALUES ('01770e37-94d6-49ed-8bf2-7ce2577faadb', 'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3', 'compliance', 'Fire Door (Communal) Inspection (11m +) (7).pdf', 'compliance/Fire Door (Communal) Inspection (11m +) (7).pdf', 'compliance_asset', '6598ac69-4e35-4341-b6a9-066949fd4799');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path, entity_type, linked_entity_id) VALUES ('e2c8df8d-961a-455e-b30f-657da7ae2f26', 'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3', 'compliance', 'Fire Door (Flats) Inspection (11m +) (13).pdf', 'compliance/Fire Door (Flats) Inspection (11m +) (13).pdf', 'compliance_asset', '8857a218-f157-408e-852e-437d5019e138');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path, entity_type, linked_entity_id) VALUES ('e0a6defd-381b-4c41-a1df-cf68d9749494', 'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3', 'compliance', 'Fire Door (Flats) Inspection (11m +) (18).pdf', 'compliance/Fire Door (Flats) Inspection (11m +) (18).pdf', 'compliance_asset', 'a76e628b-c0d3-4e09-ab1c-a90476d7efaa');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path, entity_type, linked_entity_id) VALUES ('f49739a4-62b8-43be-9a95-ea21af6272d0', 'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3', 'compliance', 'Fire Door (Flats) Inspection (11m +) (14).pdf', 'compliance/Fire Door (Flats) Inspection (11m +) (14).pdf', 'compliance_asset', '5f0b4e47-bea9-4f62-acd8-066f634a24ea');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path, entity_type, linked_entity_id) VALUES ('722da4dd-5bfe-4184-bc42-aa5c4405fdeb', 'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3', 'compliance', 'EICR Cuanku 32-34 conaught square.pdf', 'compliance/EICR Cuanku 32-34 conaught square.pdf', 'compliance_asset', 'e0cc93d0-41f4-451f-a173-2c69f2ca6eba');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path, entity_type, linked_entity_id) VALUES ('90bd5a12-b7f9-495a-ba17-b74ab4e25194', 'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3', 'compliance', 'Fire Door (Flats) Inspection (11m +) (15).pdf', 'compliance/Fire Door (Flats) Inspection (11m +) (15).pdf', 'compliance_asset', '31c4e4ce-589c-4ec1-bffc-b50d1c879f5b');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path, entity_type, linked_entity_id) VALUES ('b8421177-be59-468f-8d14-57dad273cc92', 'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3', 'compliance', '221037_Fra1-L-394697-071223 32-34 Connaught Square_2024-01-02_163759 (1).pdf', 'compliance/221037_Fra1-L-394697-071223 32-34 Connaught Square_2024-01-02_163759 (1).pdf', 'compliance_asset', 'da3db2be-13b6-41a4-a38b-b636719830c1');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path, entity_type, linked_entity_id) VALUES ('ecb1ba5b-01ba-4a8a-923a-665946e04f7e', 'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3', 'compliance', 'Fire Door (Flats) Inspection (11m +) (19).pdf', 'compliance/Fire Door (Flats) Inspection (11m +) (19).pdf', 'compliance_asset', '0114c39c-3a2f-46ae-bd4c-193161e9f5b3');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path, entity_type, linked_entity_id) VALUES ('e6b9d0e6-c370-453f-901d-762c832f0a49', 'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3', 'compliance', '001132-3234-Connaught-Square-London.pdf', 'compliance/001132-3234-Connaught-Square-London.pdf', 'compliance_asset', '8901b5b7-240b-4105-9efc-17f88c93f0c7');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path, entity_type, linked_entity_id) VALUES ('6e2f85de-a781-47ae-9ee9-5b724597a27d', 'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3', 'compliance', '221038_Hsra1-L-394697-071223 32-34 Connaught Square_2024-01-02_163759 (1).pdf', 'compliance/221038_Hsra1-L-394697-071223 32-34 Connaught Square_2024-01-02_163759 (1).pdf', 'compliance_asset', 'eb39d247-1327-49db-95d5-5d568641752d');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path, entity_type, linked_entity_id) VALUES ('2b1efc2c-ccfe-4ee7-a9ac-4bcc2e2175b4', 'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3', 'compliance', 'TETRA - Asbestos Re-Inspection Survey 14.06.22.pdf', 'compliance/TETRA - Asbestos Re-Inspection Survey 14.06.22.pdf', 'compliance_asset', '0b284542-c301-446a-8e9b-c3a53d48143a');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path, entity_type, linked_entity_id) VALUES ('b6ac70cf-f2f3-4ae1-ab30-f916396d16d2', 'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3', 'compliance', 'Fire Door (Flats) Inspection (11m +) (16).pdf', 'compliance/Fire Door (Flats) Inspection (11m +) (16).pdf', 'compliance_asset', '188fe0ad-280d-42ea-9bfe-7515f24306eb');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path, entity_type, linked_entity_id) VALUES ('f7e585d9-f138-48c7-954e-8a9945f4ef4d', 'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3', 'compliance', 'Fire Door (Flats) Inspection (11m +) (17).pdf', 'compliance/Fire Door (Flats) Inspection (11m +) (17).pdf', 'compliance_asset', '0012ca33-2647-40b1-a2e2-e8bab8e5f1c3');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path, entity_type, linked_entity_id) VALUES ('55638f79-8920-4022-a14d-c244024758dc', 'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3', 'compliance', 'WHM Legionella Risk Assessment 07.06.22.pdf', 'compliance/WHM Legionella Risk Assessment 07.06.22.pdf', 'compliance_asset', '16046826-3b73-4601-a05d-9794eff8ce21');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path, entity_type, linked_entity_id) VALUES ('073bdd02-8834-49fc-ad62-e17f09256565', 'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3', 'compliance', 'EICR Report Cunaku SATISFACTORY 2023 .pdf', 'compliance/EICR Report Cunaku SATISFACTORY 2023 .pdf', 'compliance_asset', 'c355b7ba-d41c-4d34-a0e4-5db4ab77f86a');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path, entity_type, linked_entity_id) VALUES ('4f503746-e5f8-4888-98e1-e356c1a84a49', 'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3', 'compliance', '2024 Directors Meeting-Notes.docx', 'compliance/2024 Directors Meeting-Notes.docx', 'compliance_asset', '14c1f362-3837-43f3-a959-fae0bc95b4ca');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path, entity_type, linked_entity_id) VALUES ('f741bc3f-b981-4060-8dfe-a793e98094c3', 'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3', 'compliance', '001457-3234-Connaught-Square-London Certificate.pdf', 'compliance/001457-3234-Connaught-Square-London Certificate.pdf', 'compliance_asset', '2a7f7bf3-99ee-43b0-aac2-be9a42a4ff4c');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path, entity_type, linked_entity_id) VALUES ('a7e3e6a1-f067-494c-a4f9-0ca54d4550b3', 'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3', 'compliance', 'TC0001V31 General Terms and Conditions.pdf', 'compliance/TC0001V31 General Terms and Conditions.pdf', 'compliance_asset', '32161b77-8065-4dff-a7a0-efc5092dec8d');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path, entity_type, linked_entity_id) VALUES ('309a2d99-fb6b-4b95-b6a1-6d55c1a6b933', 'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3', 'compliance', 'Jobcard_For_Job_No_28992_24-01-2025_1545.pdf', 'compliance/Jobcard_For_Job_No_28992_24-01-2025_1545.pdf', 'compliance_asset', 'f8d84186-e07f-47fd-9aed-2bbc763f9062');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path, entity_type, linked_entity_id) VALUES ('1cda32fa-7122-4403-acae-16ed834f8b0b', 'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3', 'compliance', 'Connaught Square (32-34) - 09.12.24 LRA.pdf', 'compliance/Connaught Square (32-34) - 09.12.24 LRA.pdf', 'compliance_asset', '2c798967-22de-4e42-805c-461e4b4790b9');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path, entity_type, linked_entity_id) VALUES ('657058e1-230f-48cb-8785-e876f42156f1', 'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3', 'compliance', 'SC Certificate - 10072023.pdf', 'compliance/SC Certificate - 10072023.pdf', 'compliance_asset', 'b3ae4118-1756-4328-908b-60e86c74625d');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path, entity_type, linked_entity_id) VALUES ('80237504-7a75-4177-a0da-300aaa7d4981', 'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3', 'compliance', 'Fire Door (Communal) Inspection (11m +) (7).pdf', 'compliance/Fire Door (Communal) Inspection (11m +) (7).pdf', 'compliance_asset', 'afc68890-13f9-4afb-b644-388ac60192e1');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path, entity_type, linked_entity_id) VALUES ('6e1d3028-dc3c-4e0c-b697-a4546c361e1b', 'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3', 'compliance', 'Fire Door (Flats) Inspection (11m +) (13).pdf', 'compliance/Fire Door (Flats) Inspection (11m +) (13).pdf', 'compliance_asset', '3a480f75-4060-4ac6-ac9c-6d9299a5cb94');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path, entity_type, linked_entity_id) VALUES ('15d61b94-a866-483d-8912-a586214512b6', 'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3', 'compliance', 'Fire Door (Flats) Inspection (11m +) (18).pdf', 'compliance/Fire Door (Flats) Inspection (11m +) (18).pdf', 'compliance_asset', 'b2876b37-4b50-4dcd-a584-7768197a33c9');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path, entity_type, linked_entity_id) VALUES ('231b83e9-6b70-433e-b277-8451ff0cbfe9', 'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3', 'compliance', 'Fire Door (Flats) Inspection (11m +) (14).pdf', 'compliance/Fire Door (Flats) Inspection (11m +) (14).pdf', 'compliance_asset', '47b435e7-dad1-4436-a545-c00b5906910c');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path, entity_type, linked_entity_id) VALUES ('d001bd1e-18d3-4c8d-aa4a-29e9b4b5b621', 'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3', 'compliance', 'Fire Door (Flats) Inspection (11m +) (15).pdf', 'compliance/Fire Door (Flats) Inspection (11m +) (15).pdf', 'compliance_asset', 'f64e79c8-ee25-4f7e-9cf8-af26697c8622');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path, entity_type, linked_entity_id) VALUES ('44559656-02cd-4977-b2a6-581493f59cef', 'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3', 'compliance', 'Fire Door (Flats) Inspection (11m +) (19).pdf', 'compliance/Fire Door (Flats) Inspection (11m +) (19).pdf', 'compliance_asset', 'b6ac9491-b988-4eeb-95ea-3fc343b94687');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path, entity_type, linked_entity_id) VALUES ('bc532b9f-3f18-49db-8aa2-cb2f5a1b8bb0', 'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3', 'compliance', 'Fire Door (Flats) Inspection (11m +) (16).pdf', 'compliance/Fire Door (Flats) Inspection (11m +) (16).pdf', 'compliance_asset', '28ea54a3-0569-4df4-bedb-db4ce7aac9a8');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path, entity_type, linked_entity_id) VALUES ('33835cc4-0051-4931-ad0c-2d11cad7034c', 'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3', 'compliance', 'Fire Door (Flats) Inspection (11m +) (17).pdf', 'compliance/Fire Door (Flats) Inspection (11m +) (17).pdf', 'compliance_asset', '27a0e118-1e65-4130-9858-0db775ac374d');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path, entity_type, linked_entity_id) VALUES ('ecee879d-f4eb-4ccc-a977-52fc099f20ee', 'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3', 'compliance', '221037_Fra1-L-394697-071223 32-34 Connaught Square_2024-01-02_163759.pdf', 'compliance/221037_Fra1-L-394697-071223 32-34 Connaught Square_2024-01-02_163759.pdf', 'compliance_asset', 'bcefbaf0-6e9a-451c-864f-cc5bc5243abe');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path, entity_type, linked_entity_id) VALUES ('2b42617f-c131-4ebe-a71c-240265654121', 'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3', 'compliance', 'Fire Door (Flats) Inspection (11m +) - 2024-01-24T120747.552.pdf', 'compliance/Fire Door (Flats) Inspection (11m +) - 2024-01-24T120747.552.pdf', 'compliance_asset', '282b88ac-dc29-4b40-a9f7-92653ac8c9fe');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path, entity_type, linked_entity_id) VALUES ('7c696296-9804-4e5d-b6d9-3f1948180f67', 'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3', 'compliance', 'Connaught Square (32-34) - 15.11.23 (886) wa.pdf', 'compliance/Connaught Square (32-34) - 15.11.23 (886) wa.pdf', 'compliance_asset', '4d6b17e5-f5a6-4e07-9d06-7fbf73c35b57');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path, entity_type, linked_entity_id) VALUES ('b08a7b6f-44ca-4836-b814-51adcbc9a9d5', 'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3', 'compliance', 'Fire Door (Flats) Inspection (11m +) - 2024-01-24T120745.875.pdf', 'compliance/Fire Door (Flats) Inspection (11m +) - 2024-01-24T120745.875.pdf', 'compliance_asset', '26e45775-3710-47d7-beaf-1c124713dc38');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path, entity_type, linked_entity_id) VALUES ('9d990acb-dcce-4707-b018-739e6ba18e2a', 'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3', 'compliance', 'Fire Door (Flats) Inspection (11m +) - 2024-01-24T120746.424.pdf', 'compliance/Fire Door (Flats) Inspection (11m +) - 2024-01-24T120746.424.pdf', 'compliance_asset', '49fb9c85-cdc5-42d1-910b-3c6b3b110d20');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path, entity_type, linked_entity_id) VALUES ('cc6d1827-42fa-4901-ab95-8655bd714209', 'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3', 'compliance', 'Fire Door (Communal) Inspection (11m +) - 2024-01-24T120743.986.pdf', 'compliance/Fire Door (Communal) Inspection (11m +) - 2024-01-24T120743.986.pdf', 'compliance_asset', '791e0cc1-bc95-49f4-976c-7ec521b74eec');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path, entity_type, linked_entity_id) VALUES ('6615096f-3e70-41cf-9146-da5bdf392441', 'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3', 'compliance', 'Fire Door (Flats) Inspection (11m +) - 2024-01-24T120744.738.pdf', 'compliance/Fire Door (Flats) Inspection (11m +) - 2024-01-24T120744.738.pdf', 'compliance_asset', '28d8bbf2-a762-43a9-a1a2-01d2ee1ff3b6');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path, entity_type, linked_entity_id) VALUES ('6d6b05c1-29a3-4252-90c3-d4cb23ca0e33', 'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3', 'compliance', 'Fire Door (Flats) Inspection (11m +) - 2024-01-24T120747.015.pdf', 'compliance/Fire Door (Flats) Inspection (11m +) - 2024-01-24T120747.015.pdf', 'compliance_asset', '0db6ed26-fd08-46b1-94a5-8d21fa2e19b5');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path, entity_type, linked_entity_id) VALUES ('9c58f90c-22d9-4fdc-8c47-caaa5396de7a', 'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3', 'compliance', '221038_Hsra1-L-394697-071223 32-34 Connaught Square_2024-01-02_163759.pdf', 'compliance/221038_Hsra1-L-394697-071223 32-34 Connaught Square_2024-01-02_163759.pdf', 'compliance_asset', '7ab63e84-9535-4e8b-9b93-2cc71e83700e');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path, entity_type, linked_entity_id) VALUES ('0cbd1d10-f347-4f08-823f-f846dacfbdfa', 'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3', 'compliance', 'Fire Door (Flats) Inspection (11m +) - 2024-01-24T120745.174.pdf', 'compliance/Fire Door (Flats) Inspection (11m +) - 2024-01-24T120745.174.pdf', 'compliance_asset', '6abbc839-9073-40c0-9ec2-af5dc2423a28');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path, entity_type, linked_entity_id) VALUES ('b90a8c3e-fadc-450d-8489-286c03a63fa8', 'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3', 'compliance', 'Hsfra1-L-422971-210225 32-34 Connaught Square.pdf', 'compliance/Hsfra1-L-422971-210225 32-34 Connaught Square.pdf', 'compliance_asset', '0009a696-bfe4-4043-922d-c2579d261e2f');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path, entity_type, linked_entity_id) VALUES ('6193c9f4-a6e1-441c-9d3e-94f3beb70a8a', 'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3', 'compliance', 'Hsfra1-L-422971-210225 32-34 Connaught Square.docx', 'compliance/Hsfra1-L-422971-210225 32-34 Connaught Square.docx', 'compliance_asset', 'db9cb1ad-e132-4529-a27c-af982d99d177');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path, entity_type, linked_entity_id) VALUES ('9cec00e3-8941-4f7e-85fc-ae74ffde4bb1', 'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3', 'compliance', '221037_Fra1-L-394697-071223 32-34 Connaught Square_2024-01-02_163759 (1).pdf', 'compliance/221037_Fra1-L-394697-071223 32-34 Connaught Square_2024-01-02_163759 (1).pdf', 'compliance_asset', 'de2db40c-53ab-40af-83c0-2a6b85b589db');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path, entity_type, linked_entity_id) VALUES ('122b5884-8d6d-42d1-b062-66025a67da40', 'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3', 'compliance', '221038_Hsra1-L-394697-071223 32-34 Connaught Square_2024-01-02_163759 (1).pdf', 'compliance/221038_Hsra1-L-394697-071223 32-34 Connaught Square_2024-01-02_163759 (1).pdf', 'compliance_asset', '94a71750-5b54-48bb-885d-36cb88e9552f');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path, entity_type, linked_entity_id) VALUES ('b8a7a3ad-ac82-4156-8829-d8838cc26f2e', 'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3', 'compliance', 'FRA-Connaught Square Reccommendations.xlsx', 'compliance/FRA-Connaught Square Reccommendations.xlsx', 'compliance_asset', 'e4ff4efc-973b-45c5-b7d3-25673c93fb34');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path, entity_type, linked_entity_id) VALUES ('a0f4c184-e180-4eca-b294-0f1a1ad8d74b', 'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3', 'compliance', '001534-3234-Connaught-Square-London.pdf', 'compliance/001534-3234-Connaught-Square-London.pdf', 'compliance_asset', '21f9dc54-a202-4488-97ab-8f4f21fa653b');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path, entity_type, linked_entity_id) VALUES ('c9f1be15-3c31-4814-b64d-cf93190e7f9b', 'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3', 'compliance', 'C1047 - Job card.pdf', 'compliance/C1047 - Job card.pdf', 'compliance_asset', '3188f241-f192-4ceb-9bff-ff16f1a7af02');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path, entity_type, linked_entity_id) VALUES ('0be263c2-fd83-4e1f-85d6-e29031bff19d', 'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3', 'compliance', 'WHM Legionella Risk Assessment 09.12.25.pdf', 'compliance/WHM Legionella Risk Assessment 09.12.25.pdf', 'compliance_asset', 'fb716cbb-ab3b-4659-ab11-65193d99fce4');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path, entity_type, linked_entity_id) VALUES ('13873496-157f-4710-9d67-8d30e8e9fe8c', 'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3', 'compliance', 'WHM Legionella Risk Assessment 07.06.22.pdf', 'compliance/WHM Legionella Risk Assessment 07.06.22.pdf', 'compliance_asset', 'a334c32f-37e5-4bce-b31c-613826be6feb');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path, entity_type, linked_entity_id) VALUES ('0d7c152d-e93e-4bfe-bfbf-f4871b584e3d', 'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3', 'compliance', 'Connaught Square (32-34) - 29.05.25 (201) wa.pdf', 'compliance/Connaught Square (32-34) - 29.05.25 (201) wa.pdf', 'compliance_asset', 'd8e710a3-8ee6-4cff-8de8-e0242f31f0f0');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path, entity_type, linked_entity_id) VALUES ('5a4f30d2-333c-43c4-96ea-3fb98b2084a3', 'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3', 'compliance', 'EICR Cuanku 32-34 conaught square.pdf', 'compliance/EICR Cuanku 32-34 conaught square.pdf', 'compliance_asset', '8f4a2aa3-7d48-4b2f-9c78-f5bf70a5bafc');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path, entity_type, linked_entity_id) VALUES ('f418f4ae-6aae-422a-bbee-f4a0b830afac', 'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3', 'compliance', 'EICR Report Cunaku SATISFACTORY 2023 .pdf', 'compliance/EICR Report Cunaku SATISFACTORY 2023 .pdf', 'compliance_asset', 'b098a74f-d09f-4535-9197-c95ccd024ea5');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path, entity_type, linked_entity_id) VALUES ('6fa07758-abd4-4b5c-9d8f-6950c1971d4c', 'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3', 'compliance', '001132-3234-Connaught-Square-London.pdf', 'compliance/001132-3234-Connaught-Square-London.pdf', 'compliance_asset', '4611843d-58a4-41fe-be5f-f4ed0b428cc7');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path, entity_type, linked_entity_id) VALUES ('654865fe-279a-47ce-912c-48717b10677d', 'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3', 'compliance', '001534-3234-Connaught-Square-London.pdf', 'compliance/001534-3234-Connaught-Square-London.pdf', 'compliance_asset', 'b33dc087-63a0-444b-9f0a-d87bec03ce3b');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path, entity_type, linked_entity_id) VALUES ('fa6cb1cc-17f5-4955-b539-2b9f80a3770c', 'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3', 'compliance', 'FINAL L-432900 32-34 Connaught Square Management Survey Report Issue 1.pdf', 'compliance/FINAL L-432900 32-34 Connaught Square Management Survey Report Issue 1.pdf', 'compliance_asset', '3726f1a0-0eda-4b4f-b684-acfb0e07e087');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path, entity_type, linked_entity_id) VALUES ('9994898d-c0df-479b-a0a5-a079341c845f', 'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3', 'compliance', 'TETRA - Asbestos Re-Inspection Survey 14.06.22.pdf', 'compliance/TETRA - Asbestos Re-Inspection Survey 14.06.22.pdf', 'compliance_asset', '82e007bd-0a84-4877-bb0d-195fe179b2da');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('f6b08c59-24c4-40b3-be65-a392502b7eff', 'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3', 'finance', 'British Gas Invoice-862451083.pdf', 'finance/British Gas Invoice-862451083.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('2484434d-bdb7-4fa7-a617-3e92a55f3f35', 'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3', 'contracts', 'Signed 2025 Connaught Square Management Agreement.docx.pdf', 'contracts/Signed 2025 Connaught Square Management Agreement.docx.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('08800093-b51e-46c5-8612-577867867950', 'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3', 'contracts', 'Connaught Square Management Agreement.docx', 'contracts/Connaught Square Management Agreement.docx');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('0c996317-56d2-4d59-9a8e-3d07fbc3414a', 'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3', 'contracts', '2025 Connaught Square Management Agreement.docx', 'contracts/2025 Connaught Square Management Agreement.docx');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('f9fa2b89-2ba0-4cfa-b5de-52e265219ff5', 'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3', 'contracts', 'Signed Connaught Square Management Agreement.pdf', 'contracts/Signed Connaught Square Management Agreement.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('e735e0a9-baeb-42db-a547-3b7f0324072d', 'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3', 'contracts', 'Contractors list.xlsx', 'contracts/Contractors list.xlsx');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('4ae3a240-cc0a-4b91-a09d-9d99d6035140', 'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3', 'contracts', 'Contractors list.xlsx', 'contracts/Contractors list.xlsx');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('e118cd1f-93fb-47d1-8d4b-0e70ace6dd6a', 'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3', 'contracts', 'EMERGENCY CALL OUT DETAILS 2024.pdf', 'contracts/EMERGENCY CALL OUT DETAILS 2024.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('e8b35b41-f669-4c0b-8c2c-b5a4b9074c5c', 'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3', 'contracts', 'CM434.PRO 2024-2025.pdf', 'contracts/CM434.PRO 2024-2025.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('7669faf9-9ecf-47fb-a49a-45d5bbbbc8ab', 'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3', 'contracts', 'CM434.PRO.pdf', 'contracts/CM434.PRO.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('30e9f13f-db88-4c35-a101-7b3b64dd9bf1', 'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3', 'contracts', 'Gas Contract 24-5.pdf', 'contracts/Gas Contract 24-5.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('81da17b4-1eaf-420a-8814-17f3e06bdbdf', 'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3', 'contracts', 'Contract_10-03-2025.pdf', 'contracts/Contract_10-03-2025.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('c32abb6c-34d2-42a2-8f9d-05a2504b035a', 'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3', 'contracts', 'Gas Contract 25-26.pdf', 'contracts/Gas Contract 25-26.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('4d72c95b-1c23-4ca3-88dc-8261e9135ac1', 'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3', 'correspondence', 'Welcome Letter - CG1885574.pdf', 'correspondence/Welcome Letter - CG1885574.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('663452e1-1789-4499-b0b7-9fd6165845d4', 'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3', 'contracts', 'Job 67141.pdf', 'contracts/Job 67141.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('eee9dc1e-4be2-4aaf-be2c-ad491a4ff7d3', 'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3', 'contracts', 'BLENHEIMS, 32-34 CONNAUGHT, W2 2HL - 19.05.23.pdf', 'contracts/BLENHEIMS, 32-34 CONNAUGHT, W2 2HL - 19.05.23.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('4dd5b0e6-713f-496c-8e38-089044a5239d', 'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3', 'contracts', 'BLENHEIMS, 32-34 CONNAUGHT, W2 2HL - 22.03.23.pdf', 'contracts/BLENHEIMS, 32-34 CONNAUGHT, W2 2HL - 22.03.23.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('3475c393-6913-4ee3-96e4-d254a2e20cd6', 'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3', 'contracts', 'BLENHEIMS, 32-34 CONNAUGHT, W2 2HL - 26.06.23.pdf', 'contracts/BLENHEIMS, 32-34 CONNAUGHT, W2 2HL - 26.06.23.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('b15430c5-5fbe-47a7-84c9-7277e13414fd', 'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3', 'contracts', 'BLENHEIMS, 32-34 CONNAUGHT, W2 2HL - 19.05.23.pdf', 'contracts/BLENHEIMS, 32-34 CONNAUGHT, W2 2HL - 19.05.23.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('58ae3bb0-597c-4007-8d82-7970d29c6c78', 'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3', 'contracts', 'BLENHEIMS, 32-34 CONNAUGHT, W2 2HL - 22.03.23.pdf', 'contracts/BLENHEIMS, 32-34 CONNAUGHT, W2 2HL - 22.03.23.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('5193d0be-2d8c-4d7c-8870-5dcf0957b210', 'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3', 'contracts', 'BLENHEIMS, 32-34 CONNAUGHT, W2 2HL - 26.06.23.pdf', 'contracts/BLENHEIMS, 32-34 CONNAUGHT, W2 2HL - 26.06.23.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('d8fa6c33-5dfb-42ec-8418-b229b5aa0164', 'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3', 'contracts', 'Jobcard_For_Job_No_27067_07-10-2024_1147.pdf', 'contracts/Jobcard_For_Job_No_27067_07-10-2024_1147.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('bd7e2008-1f33-46fb-a095-114484da2bf8', 'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3', 'contracts', 'Jobcard_For_Job_No_19665_28-03-2024_0936.pdf', 'contracts/Jobcard_For_Job_No_19665_28-03-2024_0936.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('888dc0bf-4148-4fb4-8283-6ef10e6ae8ce', 'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3', 'contracts', 'Jobcard_For_Job_No_22634_03-07-2024_1649.pdf', 'contracts/Jobcard_For_Job_No_22634_03-07-2024_1649.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('e66d88cd-4c18-493f-9424-d82431b390e3', 'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3', 'contracts', 'Jobcard_For_Job_No_25732_03-10-2024_1337.pdf', 'contracts/Jobcard_For_Job_No_25732_03-10-2024_1337.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('b4505488-93e4-477d-813b-854ab295d6a5', 'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3', 'contracts', 'Lift Contract-Jacksons lift.pdf', 'contracts/Lift Contract-Jacksons lift.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('610cec64-bc4e-42d0-8bc9-e0a221bfd25e', 'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3', 'contracts', 'JLGCalloutVisit-5455045-12-07-2024.pdf', 'contracts/JLGCalloutVisit-5455045-12-07-2024.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('7ad0d82f-401c-4e02-9641-c98fe5c1c01b', 'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3', 'contracts', 'JLGCalloutVisit-5483206-26-10-2024.pdf', 'contracts/JLGCalloutVisit-5483206-26-10-2024.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('c50823f3-cbe8-40b9-9fcb-ee9dc9f15aaf', 'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3', 'contracts', 'JLGCalloutVisit-5498439-16-12-2024.pdf', 'contracts/JLGCalloutVisit-5498439-16-12-2024.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('1cf81ee1-d00f-46ba-9719-af0bf43b519c', 'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3', 'contracts', 'JLGCalloutVisit-5455462-16-07-2024.pdf', 'contracts/JLGCalloutVisit-5455462-16-07-2024.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('58032a1d-c410-4285-a6df-8e0f0854facf', 'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3', 'contracts', 'JLGCalloutVisit-5497480-13-12-2024.pdf', 'contracts/JLGCalloutVisit-5497480-13-12-2024.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('ef285ea0-26ee-4171-9ce8-7e52a59c7e06', 'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3', 'contracts', 'Engineering Report - 32-34 CONNAUGHT SQUARE.pdf', 'contracts/Engineering Report - 32-34 CONNAUGHT SQUARE.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('27fe1720-4ce9-4f71-a545-24cfad08ae0c', 'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3', 'contracts', 'Arch Directors and Officers Liability Insurance for Residents Associations (12.22).pdf', 'contracts/Arch Directors and Officers Liability Insurance for Residents Associations (12.22).pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('52d27e00-062c-4d2d-b7d1-a0c7e9b598a4', 'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3', 'contracts', 'StG_Policy Wording_32-34 Connaught Square W2 2HL.pdf', 'contracts/StG_Policy Wording_32-34 Connaught Square W2 2HL.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('a384502a-97ae-487a-a7e3-f60f9f434976', 'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3', 'compliance', 'Fire Extinguisher Signed Contract- Connaught Square.pdf', 'compliance/Fire Extinguisher Signed Contract- Connaught Square.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('47da6f12-0c13-4bc2-8a02-75befdc31b04', 'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3', 'contracts', 'Q51691 - 32-34 Connaught Square Contract.pdf', 'contracts/Q51691 - 32-34 Connaught Square Contract.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('f8f9c054-da2d-428b-a37e-60f8d6c73b0b', 'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3', 'contracts', 'Engineering Report - 32-34 CONNAUGHT SQUARE.pdf', 'contracts/Engineering Report - 32-34 CONNAUGHT SQUARE.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('15719532-12a1-401d-9af9-ec8f85faa209', 'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3', 'compliance', 'Fire Alarm+Emergency Lighting Signed Contract-3234 Connaught Square.pdf', 'compliance/Fire Alarm+Emergency Lighting Signed Contract-3234 Connaught Square.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('6ac80097-c8a1-49a4-bd40-c1f6d2927200', 'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3', 'compliance', 'Fire Alarm+Emergency Lighting Contract Connaught Square.pdf', 'compliance/Fire Alarm+Emergency Lighting Contract Connaught Square.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('f574e2ad-0b42-4b79-890b-97aec56209f6', 'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3', 'contracts', 'BT3205 03072025.pdf', 'contracts/BT3205 03072025.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('0f01ab10-5f2c-490b-af4b-6b195b5f4129', 'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3', 'contracts', 'FA7817 SERVICE 08042025.pdf', 'contracts/FA7817 SERVICE 08042025.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('e987648c-0c94-4acd-9204-9af297fcbf79', 'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3', 'contracts', 'Engineer Report - 32-34 Connaught Square Flat 5.pdf', 'contracts/Engineer Report - 32-34 Connaught Square Flat 5.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('cc03063b-1c02-46ad-96fc-8c1f9050f514', 'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3', 'contracts', 'Engineering Report - 32-34 CONNAUGHT SQUARE.pdf', 'contracts/Engineering Report - 32-34 CONNAUGHT SQUARE.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('f662860c-ee19-43c9-9840-7f693d4de899', 'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3', 'contracts', 'Jobcard_For_Job_No_22171_14-05-2024_1202.pdf', 'contracts/Jobcard_For_Job_No_22171_14-05-2024_1202.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('13de9587-78ae-437b-bff7-2d012d4ad9a2', 'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3', 'finance', 'British Gas Invoice-862451083.pdf', 'finance/British Gas Invoice-862451083.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('05078ac9-dbce-440d-aa6f-2b62ff9bfcf5', 'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3', 'contracts', 'MT8825 03072025.pdf', 'contracts/MT8825 03072025.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('abfb8a3c-939b-4beb-ba13-7b55ca6ea3df', 'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3', 'contracts', 'January Monthly Test For EL-Connaught Square.pdf', 'contracts/January Monthly Test For EL-Connaught Square.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('0c94df47-45cb-492e-a0b5-7284878cd499', 'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3', 'contracts', 'February Monthly Test For EL-Connaught Square.pdf', 'contracts/February Monthly Test For EL-Connaught Square.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path, entity_type, linked_entity_id) VALUES ('2074e66f-90ec-4877-93c6-df6d919c383a', 'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3', 'major_works', 'External Decorations SOI - 28042025.docx', 'major_works/External Decorations SOI - 28042025.docx', 'major_works_project', 'c238580f-5779-439d-9c48-c22965d52647');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path, entity_type, linked_entity_id) VALUES ('2582fe39-7ac4-4edd-87c6-dfff2f5e849a', 'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3', 'major_works', 'External Dec SOE 03072025.docx', 'major_works/External Dec SOE 03072025.docx', 'major_works_project', 'bdc51a2d-b6b8-45df-9db3-f6de631e18f5');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path, entity_type, linked_entity_id) VALUES ('cb85bcd0-73f6-4f64-b751-43a84fcbf353', 'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3', 'major_works', 'Notice of intention for lift.docx', 'major_works/Notice of intention for lift.docx', 'major_works_project', 'c5bab58f-ea9f-4c71-80f3-931842c2d333');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path, entity_type, linked_entity_id) VALUES ('476493d1-0a59-447e-82d0-96cba938cf34', 'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3', 'major_works', 'Connaught Square (32-34) - 09.12.24 Schematic.pdf', 'major_works/Connaught Square (32-34) - 09.12.24 Schematic.pdf', 'major_works_project', 'a57ccd92-cac1-425a-b4ea-e7d03b194b4b');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('d25d28c1-6504-468e-b37d-733a4c763ebd', 'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3', 'compliance', 'CGBI3964546XB6-Cunaku Construction Ltd-Business-Certificate of insurance.pdf', 'compliance/CGBI3964546XB6-Cunaku Construction Ltd-Business-Certificate of insurance.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('413a4fe8-3f0c-4dfd-ba71-811713aaa3ac', 'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3', 'compliance', 'CGBI3964546XB7-Cunaku Construction Ltd-Business-Certificate of insurance.pdf', 'compliance/CGBI3964546XB7-Cunaku Construction Ltd-Business-Certificate of insurance.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('869046dd-c2a6-4b03-ac4e-0492194ee587', 'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3', 'compliance', 'Real Estate Insurance NTP (01.23).pdf', 'compliance/Real Estate Insurance NTP (01.23).pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('ff5e012a-8770-4730-9b19-9fc75d09d47f', 'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3', 'compliance', 'Real Estate Policy (01.23).pdf', 'compliance/Real Estate Policy (01.23).pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('da3a3b67-da98-43ca-9d48-60b02f88f37c', 'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3', 'compliance', 'Summary of Cover (01.23).pdf', 'compliance/Summary of Cover (01.23).pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('2677062b-0d77-4da3-8215-b5fde834441e', 'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3', 'compliance', '2023 Allianz VOC - 32-34 Connuaght Square (Freehold) Limited.pdf', 'compliance/2023 Allianz VOC - 32-34 Connuaght Square (Freehold) Limited.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('b054a580-b96f-49ae-87be-1e880a293a6c', 'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3', 'correspondence', '2023 Engineering Renewal Notice - 32 34 Connuaght Square (Freehold) Limited.pdf', 'correspondence/2023 Engineering Renewal Notice - 32 34 Connuaght Square (Freehold) Limited.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('f0e5e231-1422-4c04-a301-c196a2ced41e', 'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3', 'compliance', '32-34 Connaught Square Freehold Limited - Arch D&O Schedule.pdf', 'compliance/32-34 Connaught Square Freehold Limited - Arch D&O Schedule.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('6d048576-f9b8-407a-8320-c29bebc3f412', 'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3', 'compliance', '32-34 Connaught Sq Buildings Insurance 2023-2024.pdf', 'compliance/32-34 Connaught Sq Buildings Insurance 2023-2024.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('bc1edae3-64d3-4b0d-9e9e-c35cd6eee545', 'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3', 'compliance', 'Policy Limits Document.pdf', 'compliance/Policy Limits Document.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('50c7f596-db2a-4b7c-8dbe-136530c838e3', 'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3', 'lease', 'Official Copy (Lease) 13.06.2003 - NGL823646-Flat 4.pdf', 'lease/Official Copy (Lease) 13.06.2003 - NGL823646-Flat 4.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('8421207f-d0a6-48a3-8e0f-ebc05f957d4f', 'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3', 'correspondence', 'Letter of Authority - Connaught Square.doc.pdf', 'correspondence/Letter of Authority - Connaught Square.doc.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('c681578f-267f-4c65-8f68-9535b155585c', 'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3', 'correspondence', 'Letter to report - Connaught Square.doc.pdf', 'correspondence/Letter to report - Connaught Square.doc.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('faa6e100-d7cb-47fa-a786-af5df2415a68', 'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3', 'contracts', 'Pricing Quote - 32_34 Connaught Square Freehold Ltd - 109 - Gas - 10.03.2025.pdf', 'contracts/Pricing Quote - 32_34 Connaught Square Freehold Ltd - 109 - Gas - 10.03.2025.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('a81af41b-30f1-473e-96ee-f6adbb24c0b4', 'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3', 'compliance', 'Allianz - Lift Report 14.03.23.pdf', 'compliance/Allianz - Lift Report 14.03.23.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('22bd9930-585e-4e87-924e-1307c54e3a22', 'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3', 'compliance', 'Allianz-Lift Report 18.03.2024.pdf', 'compliance/Allianz-Lift Report 18.03.2024.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('70ba76ea-b90b-4a96-94b5-19ca7ee0bc92', 'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3', 'compliance', 'Allianz - Lift Report - 15.09.21.pdf', 'compliance/Allianz - Lift Report - 15.09.21.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('b3332739-52cd-4287-99a9-f7ddb2266157', 'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3', 'compliance', 'Allianz - Lift Report 27.09.23.pdf', 'compliance/Allianz - Lift Report 27.09.23.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('26cfc28a-364b-4cd6-94a9-4dfda1cc2582', 'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3', 'compliance', 'Allianz - Lift Report 10.03.22.pdf', 'compliance/Allianz - Lift Report 10.03.22.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('d42d091e-cdc0-46e5-8455-bd45127299dd', 'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3', 'compliance', 'Allianz - Lift Report 09.09.22.pdf', 'compliance/Allianz - Lift Report 09.09.22.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('05303352-a75e-4c88-b833-5f6b8bce677f', 'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3', 'compliance', 'LXBI3559280XB2-NEW STEP-Business-Certificate of insurance.pdf', 'compliance/LXBI3559280XB2-NEW STEP-Business-Certificate of insurance.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('83312781-c837-49e6-abfa-e0f4b1dce30f', 'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3', 'compliance', '2023 Allianz VOC - 32-34 Connuaght Square (Freehold) Limited.pdf', 'compliance/2023 Allianz VOC - 32-34 Connuaght Square (Freehold) Limited.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('6be1c256-f9d7-4b7d-9faa-a6429c018c26', 'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3', 'correspondence', '2023 Engineering Renewal Notice - 32 34 Connuaght Square (Freehold) Limited.pdf', 'correspondence/2023 Engineering Renewal Notice - 32 34 Connuaght Square (Freehold) Limited.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('ecd1b31c-fcb9-4287-b598-a39b8989e220', 'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3', 'compliance', 'MO - Policy Wording - NZ0411.pdf', 'compliance/MO - Policy Wording - NZ0411.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('c239718e-2ab3-44e8-b3ee-dd1f10e010b9', 'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3', 'compliance', 'Feature and Benefits of Allianz Engineering Inspection Service.pdf', 'compliance/Feature and Benefits of Allianz Engineering Inspection Service.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('b3d72d67-31ea-4eb2-99a7-3a4b154483a9', 'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3', 'compliance', 'StG_Insurer pack_32-34 Connaught Square Freehold Limited.pdf', 'compliance/StG_Insurer pack_32-34 Connaught Square Freehold Limited.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('e69a36ea-43dc-4e2a-bdb5-45e601a4313c', 'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3', 'compliance', 'StG_Statement of Facts_32-34 Connaught Square W2 2HL.pdf', 'compliance/StG_Statement of Facts_32-34 Connaught Square W2 2HL.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('3db2ae78-6bd5-4cbd-851b-cdd0c41b9b39', 'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3', 'compliance', 'StG_Insurance Report_32-34 Connaught Square W2 2HL.pdf', 'compliance/StG_Insurance Report_32-34 Connaught Square W2 2HL.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('fbf7e80c-38b6-4717-9ee1-12a371736cde', 'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3', 'compliance', 'StG_Insurer pack_32-34 Connaught Square Freehold Limited.pdf', 'compliance/StG_Insurer pack_32-34 Connaught Square Freehold Limited.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('5bc17438-4fd0-47dc-a5ba-9ab3cd46e75a', 'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3', 'compliance', 'StG_Statement of Facts_32-34 Connaught Square W2 2HL.pdf', 'compliance/StG_Statement of Facts_32-34 Connaught Square W2 2HL.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('85f098e3-aa36-49de-99cc-25b91ff506e9', 'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3', 'compliance', 'StG_Insurance Report_32-34 Connaught Square W2 2HL.pdf', 'compliance/StG_Insurance Report_32-34 Connaught Square W2 2HL.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('a59b3eb5-5a37-4234-805e-b118d13b7acb', 'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3', 'finance', 'StG_Invoice_32-34 Connaught Square W2 2HL.pdf', 'finance/StG_Invoice_32-34 Connaught Square W2 2HL.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('cf8c9f85-aa71-491f-9d10-25655584c350', 'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3', 'compliance', 'StG_Certificate_32-34 Connaught Square W2 2HL.pdf', 'compliance/StG_Certificate_32-34 Connaught Square W2 2HL.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('29bbc15f-eb69-472b-b031-dce656fef792', 'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3', 'compliance', 'StG_Insurer pack_32-34 Connaught Square Freehold Limited.pdf', 'compliance/StG_Insurer pack_32-34 Connaught Square Freehold Limited.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('cb928944-7315-460e-a2b8-6be3229f6046', 'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3', 'compliance', 'StG_Statement of Fact_32-34 Connaught Square W2 2HL.pdf', 'compliance/StG_Statement of Fact_32-34 Connaught Square W2 2HL.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('d2e7b5c6-831d-4f49-b532-4060086448c3', 'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3', 'finance', 'StG_Invoice_32-34 Connaught Square Freehold Limited.pdf', 'finance/StG_Invoice_32-34 Connaught Square Freehold Limited.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('aa2fabe0-2b95-49a8-bcdc-6796c706c5fa', 'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3', 'compliance', '32-34 Connaught Square Freehold Limited - Arch D&O Schedule.pdf', 'compliance/32-34 Connaught Square Freehold Limited - Arch D&O Schedule.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('339f00b3-918a-49ae-8e34-0edfe1ed9936', 'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3', 'compliance', 'StG_Certificate_32-34 Connaught Square Freehold Limited.pdf', 'compliance/StG_Certificate_32-34 Connaught Square Freehold Limited.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('117d7b4d-3212-4813-ac0a-449133b5f918', 'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3', 'compliance', 'StG_Policy Wording_32-34 Connaught Square Freehold Limited.pdf', 'compliance/StG_Policy Wording_32-34 Connaught Square Freehold Limited.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('32ca4ce9-b484-4a00-8c1f-5199cd205391', 'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3', 'compliance', 'StG_D&O Endorsements_32-34 Connaught Square Freehold Limited.pdf', 'compliance/StG_D&O Endorsements_32-34 Connaught Square Freehold Limited.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('ff8ce2ce-a1c5-4dde-bd3b-1f20e17d60ff', 'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3', 'finance', 'StG_Demands & Needs_32-34 Connaught Square Freehold Limited.pdf', 'finance/StG_Demands & Needs_32-34 Connaught Square Freehold Limited.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('c5a319c9-b5a7-423b-ae8e-59691eb9096a', 'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3', 'contracts', 'StG_Quote_32-34 Connaught Square Freehold Limited.pdf', 'contracts/StG_Quote_32-34 Connaught Square Freehold Limited.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('992700fa-2da9-49a5-8fd7-f15eeec37acb', 'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3', 'compliance', 'StG_Insurance Report_32-34 Connaught Square W2 2HL.pdf', 'compliance/StG_Insurance Report_32-34 Connaught Square W2 2HL.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('9439c8e9-54e6-432b-9e8b-d79c3014d45a', 'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3', 'compliance', 'FBR113382303-20230405-B.pdf', 'compliance/FBR113382303-20230405-B.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('ed5891c9-63cc-45a8-8ead-e7763ae4c60f', 'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3', 'compliance', 'Real Estate Insurance NTP (01.23).pdf', 'compliance/Real Estate Insurance NTP (01.23).pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('56b9f583-4ff6-4d3d-af4b-bd4f767958af', 'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3', 'compliance', 'Real Estate Policy (01.23).pdf', 'compliance/Real Estate Policy (01.23).pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('4541bddf-b919-4868-b3b6-2253e3bede07', 'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3', 'compliance', 'Summary of Cover (01.23).pdf', 'compliance/Summary of Cover (01.23).pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('192f172a-a1fe-4d3d-b880-f3eba1a1e43b', 'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3', 'compliance', '32-34 Connaught Sq Buildings Insurance 2023-2024.pdf', 'compliance/32-34 Connaught Sq Buildings Insurance 2023-2024.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('5ba2c484-984d-4ea5-8bc0-7f355b22bc1c', 'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3', 'compliance', 'Policy Limits Document.pdf', 'compliance/Policy Limits Document.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('11c7556a-0a81-40bf-b023-341aeb5dcf6a', 'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3', 'compliance', 'Zurich Real Estate Policy Summary.pdf', 'compliance/Zurich Real Estate Policy Summary.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('d56da9f5-7af1-4aea-8454-1a99d8aae688', 'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3', 'compliance', 'Zurich Real Estate Policy Wording.pdf', 'compliance/Zurich Real Estate Policy Wording.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('686b6e7f-0ef9-452c-99f7-95cd9d675014', 'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3', 'compliance', 'Zurich Real Estate Insurance NTP (01.23) ZCYP895.02.pdf', 'compliance/Zurich Real Estate Insurance NTP (01.23) ZCYP895.02.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('b6e72eb4-66a2-4746-9614-e51fe2b2df8d', 'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3', 'finance', 'StG_Invoice_32-34 Connaught Square W2 2HL.pdf', 'finance/StG_Invoice_32-34 Connaught Square W2 2HL.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('e9a786ea-8dca-43a3-9cfc-f6d3ad978be4', 'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3', 'compliance', 'StG_Certificate_32-34 Connaught Square W2 2HL.pdf', 'compliance/StG_Certificate_32-34 Connaught Square W2 2HL.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('e80ab561-68de-4205-9b2a-b9c84b2a4879', 'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3', 'compliance', 'StG_Supporting Docs_32-34 Connaught Square W2 2HL.pdf', 'compliance/StG_Supporting Docs_32-34 Connaught Square W2 2HL.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('a493223f-d88e-4f79-843e-d2272b2eb602', 'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3', 'finance', 'StG_Invoice_32-34 Connaught Square W2 2HL.pdf', 'finance/StG_Invoice_32-34 Connaught Square W2 2HL.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('3b636082-de0b-4957-b6d9-270f761ecc7d', 'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3', 'compliance', 'StG_Certificate_32-34 Connaught Square W2 2HL.pdf', 'compliance/StG_Certificate_32-34 Connaught Square W2 2HL.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('14ca620c-d0f8-48e5-adf7-575e7912ad85', 'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3', 'compliance', 'StG_Statement of Fact_32-34 Connaught Square W2 2HL.pdf', 'compliance/StG_Statement of Fact_32-34 Connaught Square W2 2HL.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('c3aeb7b7-e1a4-4713-86fd-8b7512d2dda2', 'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3', 'finance', 'StG_Invoice_32-34 Connaught Square W2 2HL.pdf', 'finance/StG_Invoice_32-34 Connaught Square W2 2HL.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('01b3c6c4-8fea-4c74-ab8a-bfd50d3ffc2f', 'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3', 'compliance', 'StG_Statement of Fact_32-34 Connaught Square W2 2HL.pdf', 'compliance/StG_Statement of Fact_32-34 Connaught Square W2 2HL.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('fade00b1-c8e2-4734-9acc-ec9f668ed9d7', 'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3', 'uncategorised', 'Connaught Square New property information.xlsx', 'uncategorised/Connaught Square New property information.xlsx');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('2527a724-d563-4d17-8084-f7324742ce7e', 'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3', 'uncategorised', 'Connaught Square Meeting Minutes 2.docx', 'uncategorised/Connaught Square Meeting Minutes 2.docx');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('c2c64641-0e4f-47a7-aee5-961ef51ed676', 'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3', 'uncategorised', 'connaught.xlsx', 'uncategorised/connaught.xlsx');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('79a5e5a3-53d1-461e-85e4-df84d2a899f0', 'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3', 'uncategorised', 'matrix - pp.xlsx', 'uncategorised/matrix - pp.xlsx');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('24e5633b-b3e9-4470-b7a7-726f2b4e771e', 'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3', 'uncategorised', '12. Change of Tenancy - EDF supporting document.docx', 'uncategorised/12. Change of Tenancy - EDF supporting document.docx');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('054d2ec3-150a-45fd-aa40-239bed64117e', 'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3', 'correspondence', 'Correspondence letter.pdf', 'correspondence/Correspondence letter.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('76bd3705-66e0-45c7-a5e2-92d3d4597789', 'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3', 'uncategorised', 'tenant list - pp.xlsx', 'uncategorised/tenant list - pp.xlsx');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('5b580c79-e55c-4ff0-abe3-51bd87c4cb70', 'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3', 'uncategorised', 'Report - 32-34 Connaught Square BCH 78350.pdf', 'uncategorised/Report - 32-34 Connaught Square BCH 78350.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('f72328fb-bf32-4cd8-9391-767e594c49ff', 'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3', 'uncategorised', 'Connaught Square Meeting Minutes 2.docx', 'uncategorised/Connaught Square Meeting Minutes 2.docx');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('081a3136-69c5-423f-a80f-700049f88569', 'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3', 'uncategorised', 'Connaught Square Meeting Minutes 20241120.docx', 'uncategorised/Connaught Square Meeting Minutes 20241120.docx');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('cba45a49-53f9-4c7d-a375-132853e0ea1a', 'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3', 'uncategorised', 'Connaught Square Meeting Minutes.docx', 'uncategorised/Connaught Square Meeting Minutes.docx');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('1cd378b6-36f9-4e5a-898e-0dab8c4df063', 'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3', 'uncategorised', 'Connaught Square Admin Duties of Co Sec.docx', 'uncategorised/Connaught Square Admin Duties of Co Sec.docx');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('287aac71-d724-4884-83bf-5089f76f655b', 'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3', 'uncategorised', 'Signed Connaught Square Admin Duties of Co Sec.pdf', 'uncategorised/Signed Connaught Square Admin Duties of Co Sec.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('2dd0f3b8-3aac-4c35-a7dd-2f47594f1519', 'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3', 'uncategorised', '32_34 CONNAUGHT SQUARE FREEHOLD LIMITED - Statutory Registers on 22.03.2024.pdf', 'uncategorised/32_34 CONNAUGHT SQUARE FREEHOLD LIMITED - Statutory Registers on 22.03.2024.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('309c2a0f-f798-461d-beb2-dc4649e1da44', 'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3', 'correspondence', 'Memorandum of Association.pdf', 'correspondence/Memorandum of Association.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('2d87f52a-1107-438c-9038-d9b45689f0cf', 'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3', 'uncategorised', 'Incorporation documents.pdf', 'uncategorised/Incorporation documents.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('2399af8d-7e54-453f-8cb5-ba2533f094b8', 'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3', 'uncategorised', 'B25676 RS 21.05.24 RM CM.pdf', 'uncategorised/B25676 RS 21.05.24 RM CM.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('31ad92df-c9b8-41b3-bc6a-175a4aa6e607', 'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3', 'uncategorised', 'Report-20.08.2024.pdf', 'uncategorised/Report-20.08.2024.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('50af96cd-ebf7-49b8-a26d-c2d73e4fbf65', 'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3', 'correspondence', 'PN0119V1.7 Privacy Notice (Website).pdf', 'correspondence/PN0119V1.7 Privacy Notice (Website).pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('5753fe02-2f4b-4308-bf83-4dc4fc359cbe', 'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3', 'correspondence', 'PN0119V1.8 Privacy Notice (Website).pdf', 'correspondence/PN0119V1.8 Privacy Notice (Website).pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('eea70659-71b4-46d4-b6e8-cf2c108c3b27', 'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3', 'uncategorised', 'REPORT 31-07-25.pdf', 'uncategorised/REPORT 31-07-25.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('a04e3ea8-b586-4f87-b2ad-0b5d7e0fe297', 'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3', 'uncategorised', '32-34 Connought Square Condtion Assessments.pdf', 'uncategorised/32-34 Connought Square Condtion Assessments.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('d7c61f6a-c54c-43b9-9e40-599cba085f93', 'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3', 'uncategorised', 'Signed Conract.pdf', 'uncategorised/Signed Conract.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('539bb08b-40e7-41c8-8aff-2d1ae73c2bd6', 'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3', 'uncategorised', 'BLENHEIMS, CONNAUGHT, W2 2HL PHOTO - 22.01.24.pdf', 'uncategorised/BLENHEIMS, CONNAUGHT, W2 2HL PHOTO - 22.01.24.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('58b21bba-5577-4dc1-976a-e8addd3a3dcb', 'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3', 'uncategorised', 'BLENHEIMS, CONNAUGHT, W2 2HL PHOTO - 22.03.24.pdf', 'uncategorised/BLENHEIMS, CONNAUGHT, W2 2HL PHOTO - 22.03.24.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('1226c6cc-b237-4147-b98c-95b3658372c6', 'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3', 'uncategorised', 'Latest Report.pdf', 'uncategorised/Latest Report.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('ad8b50ea-37f9-40e6-8535-fb0501c1690a', 'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3', 'uncategorised', 'Latest Report 24.04.2024.pdf', 'uncategorised/Latest Report 24.04.2024.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('6cc2e03d-f335-4c45-9ba6-dfc33bcc33c1', 'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3', 'uncategorised', 'Latest Report 19.09.2024.pdf', 'uncategorised/Latest Report 19.09.2024.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('bbd161d6-0eb5-4e71-87ae-e6386a44fe54', 'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3', 'uncategorised', 'BLENHEIMS, 32-34 CONNAUGHT, W2 2HL - 25.09.23.pdf', 'uncategorised/BLENHEIMS, 32-34 CONNAUGHT, W2 2HL - 25.09.23.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('a6732707-bd93-47b6-96c3-e2a67bc85283', 'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3', 'uncategorised', 'BLENHEIMS, 32-34 CONNAUGHT, W2 2HL PHOTO - 29.11.23.pdf', 'uncategorised/BLENHEIMS, 32-34 CONNAUGHT, W2 2HL PHOTO - 29.11.23.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('b884dbbd-8b32-40b4-9f1a-eceaec5f8821', 'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3', 'uncategorised', 'BLENHEIMS, 32-34 CONNAUGHT, W2 2HL PHOTO - 18.12.23.pdf', 'uncategorised/BLENHEIMS, 32-34 CONNAUGHT, W2 2HL PHOTO - 18.12.23.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('daab219a-10f1-4679-8492-665756f0ab84', 'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3', 'uncategorised', 'BLENHEIMS, CONNAUGHT, W2 2HL PHOTO - 23.02.24.pdf', 'uncategorised/BLENHEIMS, CONNAUGHT, W2 2HL PHOTO - 23.02.24.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('a3950dbe-6cb5-4416-b15f-f462dd12e327', 'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3', 'uncategorised', '10.02.25-Pest Control.pdf', 'uncategorised/10.02.25-Pest Control.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('31e5ba0e-991a-49c8-a253-36135a2547da', 'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3', 'uncategorised', 'Latest Report.pdf', 'uncategorised/Latest Report.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('a7e4a4f7-e0f5-4650-bd51-67734204f4e7', 'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3', 'uncategorised', '17.01.2025-Pest Control.pdf', 'uncategorised/17.01.2025-Pest Control.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('d1f8bafa-5911-42db-a36a-7cfbe84c481c', 'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3', 'uncategorised', 'J18503 - MIH, CONNAUGHT SQR, W2 - 04.04.25.pdf', 'uncategorised/J18503 - MIH, CONNAUGHT SQR, W2 - 04.04.25.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('6a7c33f2-2bc1-415f-a016-43cc5e4b34fb', 'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3', 'uncategorised', 'J18502 - MIH, CONNAUGHT SQR, W2 - 04.04.25.pdf', 'uncategorised/J18502 - MIH, CONNAUGHT SQR, W2 - 04.04.25.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('8038b70f-af77-45bf-8139-cfd42c621ae6', 'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3', 'uncategorised', 'BLENHEIMS, CONNAUGHT, W2 2HL PHOTO - 22.01.24.pdf', 'uncategorised/BLENHEIMS, CONNAUGHT, W2 2HL PHOTO - 22.01.24.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('ffba6aeb-cce6-4c79-9326-506da29b5806', 'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3', 'uncategorised', 'BLENHEIMS, CONNAUGHT, W2 2HL PHOTO - 22.03.24.pdf', 'uncategorised/BLENHEIMS, CONNAUGHT, W2 2HL PHOTO - 22.03.24.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('0c09a33b-ca90-47a1-a80f-7ef42c7958cf', 'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3', 'uncategorised', 'BLENHEIMS, 32-34 CONNAUGHT, W2 2HL - 25.09.23.pdf', 'uncategorised/BLENHEIMS, 32-34 CONNAUGHT, W2 2HL - 25.09.23.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('d97721e9-2329-4172-b3af-ab9f48ae82c9', 'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3', 'uncategorised', 'BLENHEIMS, 32-34 CONNAUGHT, W2 2HL PHOTO - 29.11.23.pdf', 'uncategorised/BLENHEIMS, 32-34 CONNAUGHT, W2 2HL PHOTO - 29.11.23.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('d81fe31a-990e-4735-ae24-7ffda41747bc', 'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3', 'uncategorised', 'BLENHEIMS, 32-34 CONNAUGHT, W2 2HL PHOTO - 18.12.23.pdf', 'uncategorised/BLENHEIMS, 32-34 CONNAUGHT, W2 2HL PHOTO - 18.12.23.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('3d19302b-5da4-4f3c-9502-76911082a795', 'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3', 'uncategorised', 'BLENHEIMS, CONNAUGHT, W2 2HL PHOTO - 23.02.24.pdf', 'uncategorised/BLENHEIMS, CONNAUGHT, W2 2HL PHOTO - 23.02.24.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('e00d00b3-5bd4-47c8-bac8-179ecea4b705', 'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3', 'uncategorised', 'INV 11546 Mr Martin Samworth.xlsx', 'uncategorised/INV 11546 Mr Martin Samworth.xlsx');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('a0788a16-994a-4f50-9e1f-e0b385a5a203', 'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3', 'uncategorised', 'QB4126 Mr Martin Samworth.docx', 'uncategorised/QB4126 Mr Martin Samworth.docx');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('5ef14547-a05d-4de7-a282-7e9bbce6d2ec', 'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3', 'uncategorised', 'CQ2879 Mr Martin Samworth   (IP) CCTV.docx', 'uncategorised/CQ2879 Mr Martin Samworth   (IP) CCTV.docx');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('4e0b2bd8-125e-4945-b240-21cb9f832c46', 'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3', 'uncategorised', 'Asset_Record_For_Job_No_32810_17-03-2025_1311.pdf', 'uncategorised/Asset_Record_For_Job_No_32810_17-03-2025_1311.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('ee1796b5-b1e0-488a-9d76-20b33935d8d7', 'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3', 'uncategorised', 'Asset_Record_For_Job_No_32344_12-03-2025_1426.pdf', 'uncategorised/Asset_Record_For_Job_No_32344_12-03-2025_1426.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('06dc59c5-7160-4b4f-bffb-3e30cfaa580c', 'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3', 'uncategorised', 'Asset_Record_For_Job_No_37675_25-07-2025_1549.pdf', 'uncategorised/Asset_Record_For_Job_No_37675_25-07-2025_1549.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('088301c3-b8e8-4ce6-8ee0-ce4418667e68', 'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3', 'uncategorised', 'Asset_Record_For_Job_No_34012_01-05-2025_1616.pdf', 'uncategorised/Asset_Record_For_Job_No_34012_01-05-2025_1616.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('6ae78c69-5f2e-46bd-aebd-1ff8b555780a', 'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3', 'uncategorised', 'Asset_Record_For_Job_No_32759_17-03-2025_1147.pdf', 'uncategorised/Asset_Record_For_Job_No_32759_17-03-2025_1147.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('bb9e0d3a-52bd-466f-92d3-94aa229aec5c', 'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3', 'uncategorised', 'Jobcard_For_Job_No_32344_12-03-2025_1426.pdf', 'uncategorised/Jobcard_For_Job_No_32344_12-03-2025_1426.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('4009d2a8-e1ce-484c-9fba-bf7993b67801', 'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3', 'uncategorised', 'Asset_Record_For_Job_No_33844_07-04-2025_1143.pdf', 'uncategorised/Asset_Record_For_Job_No_33844_07-04-2025_1143.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('7936bb51-6294-4fc9-8e11-e4bdc22b3649', 'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3', 'uncategorised', 'Asset_Record_For_Job_No_25732_03-10-2024_1337.pdf', 'uncategorised/Asset_Record_For_Job_No_25732_03-10-2024_1337.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('6a3ddd47-a0e3-4682-b7aa-29858d49448b', 'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3', 'uncategorised', 'Asset_Record_For_Job_No_22634_03-07-2024_1650.pdf', 'uncategorised/Asset_Record_For_Job_No_22634_03-07-2024_1650.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('07b867fe-971e-4958-908a-0060022e0d0a', 'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3', 'uncategorised', 'Asset_Record_For_Job_No_27067_07-10-2024_1147.pdf', 'uncategorised/Asset_Record_For_Job_No_27067_07-10-2024_1147.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('82faf9a3-3a56-44a4-8262-b02f9be0c6eb', 'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3', 'uncategorised', 'Asset_Record_For_Job_No_19665_05-04-2024_1048.pdf', 'uncategorised/Asset_Record_For_Job_No_19665_05-04-2024_1048.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('af9ee50d-a7a4-4036-8c44-7acc921bd753', 'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3', 'contracts', 'Connaught Square-Lift Quotes.xlsx', 'contracts/Connaught Square-Lift Quotes.xlsx');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('09f38b9a-4e61-401d-a248-91ba40ca17fb', 'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3', 'uncategorised', 'LXBI3559280XB2-NEW STEP-Business-Certificate of el insurance.pdf', 'uncategorised/LXBI3559280XB2-NEW STEP-Business-Certificate of el insurance.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('c0ebf1fe-5dfa-4299-aa74-a1f8e4875fe4', 'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3', 'uncategorised', 'New Step - Cleaning of Com Part- Jan- 2023.pdf', 'uncategorised/New Step - Cleaning of Com Part- Jan- 2023.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('a5f89e21-4574-448b-b187-0392e67e9593', 'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3', 'uncategorised', 'Aged debtors by property.pdf', 'uncategorised/Aged debtors by property.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('737aa9c1-835d-4b11-ae49-805f1a355f50', 'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3', 'uncategorised', 'Connaught Square, 32-34 Approved xlsx.xlsx', 'uncategorised/Connaught Square, 32-34 Approved xlsx.xlsx');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('028bc931-8743-48df-9b2a-3a3c2d1288f0', 'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3', 'uncategorised', 'BvA 24 Jan 25.xlsx', 'uncategorised/BvA 24 Jan 25.xlsx');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('7beb9644-6448-4768-b798-778bb383edd6', 'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3', 'uncategorised', 'pdf.pdf', 'uncategorised/pdf.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('e1d82241-7207-4a76-ab04-b54535201761', 'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3', 'uncategorised', 'Connaught Square-Agenda 20.11.24.docx', 'uncategorised/Connaught Square-Agenda 20.11.24.docx');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('7192ba58-e353-416b-9728-9b541d78a1e9', 'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3', 'uncategorised', 'Connaught Square-Agenda 26.04.2024.docx', 'uncategorised/Connaught Square-Agenda 26.04.2024.docx');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('1739d2e4-ea35-4f25-ba8f-24f6932915a3', 'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3', 'uncategorised', 'Connaught Square 26.04.24.docx', 'uncategorised/Connaught Square 26.04.24.docx');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('7744b089-3543-4e2f-91d9-a715156b5276', 'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3', 'contracts', 'StG_Quote_32-34 Connaught Square W2 2HL.pdf', 'contracts/StG_Quote_32-34 Connaught Square W2 2HL.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('cac8cbeb-f739-4cb9-b0e4-145a7dec5d75', 'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3', 'uncategorised', 'StG_Policy Wording_32-34 Connaught Square W2 2HL.pdf', 'uncategorised/StG_Policy Wording_32-34 Connaught Square W2 2HL.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('2f1a8eb9-09fd-4a9f-93cb-c5d9fbe7d145', 'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3', 'contracts', 'StG_Quote_32-34 Connaught Square W2 2HL.pdf', 'contracts/StG_Quote_32-34 Connaught Square W2 2HL.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('2f9bdb74-105b-44e1-8ad9-628c0e40463d', 'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3', 'uncategorised', 'StG_Policy Wording_32-34 Connaught Square W2 2HL.pdf', 'uncategorised/StG_Policy Wording_32-34 Connaught Square W2 2HL.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('3ed15148-2ff9-4e29-9c80-538066ed7ce9', 'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3', 'uncategorised', 'Report - 32-34 Connaught Square BCH 78350.pdf', 'uncategorised/Report - 32-34 Connaught Square BCH 78350.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('6caf8a66-fdc9-4b0c-9641-f20379be0e0c', 'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3', 'uncategorised', 'Asset_Record_For_Job_No_16617_27-11-2023_1522.pdf', 'uncategorised/Asset_Record_For_Job_No_16617_27-11-2023_1522.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('8223ae6a-3da5-488f-865d-41e6cec5c568', 'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3', 'uncategorised', 'Asset_Record_For_Job_No_16808_28-11-2023_1340.pdf', 'uncategorised/Asset_Record_For_Job_No_16808_28-11-2023_1340.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('7723247f-68a5-462c-8484-eba58267e069', 'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3', 'uncategorised', 'EX-NC (CONNAUGHT SQUARE) EXTRA 01102024.pdf', 'uncategorised/EX-NC (CONNAUGHT SQUARE) EXTRA 01102024.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('24fc220b-cc3a-4306-8743-41f69a62e0a8', 'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3', 'uncategorised', 'H&S recomendations - Spreadsheet with comments.xlsx', 'uncategorised/H&S recomendations - Spreadsheet with comments.xlsx');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('0b2f571c-3376-4726-826f-340ca1e718ec', 'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3', 'uncategorised', 'CM434 RS 32-34 Connaught Square - VISIT 1 OF 2 - 30-04-25.pdf', 'uncategorised/CM434 RS 32-34 Connaught Square - VISIT 1 OF 2 - 30-04-25.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('59ff0299-e747-489d-8e3d-15a828b461b8', 'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3', 'uncategorised', 'Q49511 - 32-34 Connaught Square.pdf', 'uncategorised/Q49511 - 32-34 Connaught Square.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('e29b6ed4-3ea2-4477-8395-0201e71615f1', 'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3', 'uncategorised', 'FA7817 CALL OUT 26032025.pdf', 'uncategorised/FA7817 CALL OUT 26032025.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('1f7c2a49-03e0-4bfc-9ef3-93055649762d', 'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3', 'uncategorised', '32 Connaught Sq - PAT .pdf', 'uncategorised/32 Connaught Sq - PAT .pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('35f51224-b886-4f14-bd77-b0dbe05ef8f3', 'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3', 'uncategorised', 'Asset_Record_For_Job_No_35146_03-06-2025_0906.pdf', 'uncategorised/Asset_Record_For_Job_No_35146_03-06-2025_0906.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('47cbb99e-a0bb-4428-bb6e-fcec8019b01d', 'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3', 'uncategorised', 'Asset_Record_For_Job_No_31162_30-01-2025_1603.pdf', 'uncategorised/Asset_Record_For_Job_No_31162_30-01-2025_1603.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('a1a2bd36-4b3c-4a7f-9e47-d4f61e828933', 'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3', 'uncategorised', 'Asset_Record_For_Job_No_37675_25-07-2025_1549.pdf', 'uncategorised/Asset_Record_For_Job_No_37675_25-07-2025_1549.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('5e964229-3277-4c34-82d2-de0c5c68032d', 'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3', 'uncategorised', 'Asset_Record_For_Job_No_28737_25-11-2024_0907.pdf', 'uncategorised/Asset_Record_For_Job_No_28737_25-11-2024_0907.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('c985dcc1-016a-46a8-96de-705c6fb4a145', 'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3', 'uncategorised', 'Asset_Record_For_Job_No_35402_03-06-2025_0916.pdf', 'uncategorised/Asset_Record_For_Job_No_35402_03-06-2025_0916.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('b3e5164a-d8c4-4922-ba2d-b84523d24836', 'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3', 'uncategorised', 'Asset_Record_For_Job_No_22171_14-05-2024_1202.pdf', 'uncategorised/Asset_Record_For_Job_No_22171_14-05-2024_1202.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('f135da7d-89b3-4be6-9c77-29b699ac351b', 'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3', 'uncategorised', 'Asset_Record_For_Job_No_35654_03-06-2025_0912.pdf', 'uncategorised/Asset_Record_For_Job_No_35654_03-06-2025_0912.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('10838086-8f2a-42cd-b75a-25b59fe01ecf', 'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3', 'uncategorised', 'Asset_Record_For_Job_No_38609_26-08-2025_0740.pdf', 'uncategorised/Asset_Record_For_Job_No_38609_26-08-2025_0740.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('2a8effc2-6d4b-461e-b610-90a557298f82', 'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3', 'uncategorised', 'Asset_Record_For_Job_No_36465_20-06-2025_1038.pdf', 'uncategorised/Asset_Record_For_Job_No_36465_20-06-2025_1038.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('8a99d8b9-8009-404b-b1da-fef939233ca8', 'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3', 'uncategorised', '26368 Report.pdf', 'uncategorised/26368 Report.pdf');
INSERT INTO building_documents (id, building_id, category, file_name, storage_path) VALUES ('56b23134-aebd-4a38-b698-39722db404bb', 'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3', 'uncategorised', '26474 Report.pdf', 'uncategorised/26474 Report.pdf');


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
    '15fbd7d8-9fb9-4410-aa10-c46cb6ac4aa9',
    'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3',
    'ac87d90b-b85b-4948-a9b5-0671d228b079',
    'Unknown',
    'service_charge',
    NULL  -- Requires manual entry
)
ON CONFLICT (id) DO NOTHING;

-- Fallback budget for unstructured PDF
INSERT INTO budgets (id, building_id, document_id, period, budget_type, total_amount)
VALUES (
    '10d0a246-bdec-4a3c-b752-fe3f829407ce',
    'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3',
    'ccf1fcaa-7189-4e66-a1aa-9a74dd72c7ee',
    'Unknown',
    'service_charge',
    NULL  -- Requires manual entry
)
ON CONFLICT (id) DO NOTHING;

-- Fallback budget for unstructured PDF
INSERT INTO budgets (id, building_id, document_id, period, budget_type, total_amount)
VALUES (
    'af027122-47e5-4d58-b0cf-0aaec52251f3',
    'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3',
    '495b8be0-96e0-42e7-9c0c-fb90e982969b',
    'Unknown',
    'service_charge',
    NULL  -- Requires manual entry
)
ON CONFLICT (id) DO NOTHING;

-- Fallback budget for unstructured PDF
INSERT INTO budgets (id, building_id, document_id, period, budget_type, total_amount)
VALUES (
    '770a47ad-7f30-49b4-899a-656753d4da4a',
    'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3',
    'ceeb398a-4d2a-4d97-9da6-d2d1b7c1b977',
    'Unknown',
    'service_charge',
    NULL  -- Requires manual entry
)
ON CONFLICT (id) DO NOTHING;

-- Fallback budget for unstructured PDF
INSERT INTO budgets (id, building_id, document_id, period, budget_type, total_amount)
VALUES (
    'fb2144dd-a273-41af-9586-470a6d2c23bd',
    'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3',
    'e6445226-51b4-42b3-ac0d-ffc135050e23',
    '2025',
    'service_charge',
    NULL  -- Requires manual entry
)
ON CONFLICT (id) DO NOTHING;

-- Fallback budget for unstructured PDF
INSERT INTO budgets (id, building_id, document_id, period, budget_type, total_amount)
VALUES (
    '104507d2-856d-486f-876c-7ac8b6eb6a3a',
    'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3',
    'c72ea651-727f-4991-98cf-d7c624356ff5',
    '2025',
    'service_charge',
    NULL  -- Requires manual entry
)
ON CONFLICT (id) DO NOTHING;

-- Fallback budget for unstructured PDF
INSERT INTO budgets (id, building_id, document_id, period, budget_type, total_amount)
VALUES (
    '57102405-46ae-4f70-bb7d-79001e0f4f53',
    'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3',
    '5bed5b84-f3c5-43d7-a82d-1dd75efc5010',
    '2025',
    'service_charge',
    NULL  -- Requires manual entry
)
ON CONFLICT (id) DO NOTHING;

-- Fallback budget for unstructured PDF
INSERT INTO budgets (id, building_id, document_id, period, budget_type, total_amount)
VALUES (
    '5cb1c47c-232e-42a2-bc32-e29e4a30c3b6',
    'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3',
    '2a50177f-5e87-41c0-90f6-974b054aaf56',
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
    '9d406c92-a574-4e88-adf8-f3359736f860',
    'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3',
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
    'e0caa7cc-7015-4969-8885-76794338fa62',
    'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3',
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
    '9d240c29-2c74-4b67-8264-cb3961a53747',
    'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3',
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
    'ad891216-68dc-4454-811d-3cecb364f6a4',
    'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3',
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
    'eb8360c8-88ba-4493-977b-8f2adb1ea122',
    'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3',
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
    '25132360-9bf5-4ee5-85c6-62d5043b5b3a',
    'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3',
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
    '6a9f1c0a-9ba6-44a8-89c2-e6c3d701e9f4',
    'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3',
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
    '0d9de6d9-cf37-4ab6-96fa-b20a29cb6b2e',
    'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3',
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
    '69f3374b-3bc0-4d69-bc3c-e10f98b823fd',
    'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3',
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
    'd3761cfa-1d85-4272-b4ef-8ae114960e48',
    'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3',
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
    '4cba532a-080b-43c1-b048-d4aba1daa29e',
    'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3',
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
    '6ab99f0c-ff30-44a1-8a4b-bf994c5d3e08',
    'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3',
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
    'bacefbc6-60da-4fd2-936c-a273d6abe2b5',
    'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3',
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
    'ae154190-b3b1-46b7-ab0f-e9c0537dc1ee',
    'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3',
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
    'b0e468e6-8ed3-4029-b901-cb6bc9c63fc1',
    'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3',
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
    '72005d9b-0feb-48bd-9fbd-35b4e87b4312',
    'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3',
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
    'b493d464-34b9-4544-b73f-0524462b8fc1',
    'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3',
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
    'ce74daaf-8bb5-40be-9038-2b96b786f37c',
    'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3',
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
    '2731922f-b151-40d3-891b-b4b28c96279f',
    'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3',
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
    '20c9feca-5b58-44d0-a0ab-7f398e5a821b',
    'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3',
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
    '1eceba40-e734-46d9-a64e-a6d2be814091',
    'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3',
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
    '5ab374df-9ff1-4f6b-a46b-2c177f9fe4c2',
    'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3',
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
    '500291c8-cdae-456e-9fb2-237a400838af',
    'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3',
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
    '74757131-03db-460c-8951-0fb58eef4619',
    'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3',
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
    '1ca4bb3a-ed22-430b-a4b5-b3a7e4e20cf1',
    'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3',
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
    'd13c3d76-c12d-4726-9def-70679e1a7e3d',
    'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3',
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
    'cd0c0604-f134-4768-bf20-3b9cd3f14c33',
    'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3',
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
    '4a61ea5d-4823-458f-a7ee-a2e2ec68ddb7',
    'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3',
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
    'a103f882-f322-4e2a-a3c2-9e630da5fa12',
    'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3',
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
    '1c1fad71-55d2-4e44-9790-aa388176e1ce',
    'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3',
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
    'a7890b3f-059a-47a8-bc8e-8284e73bb708',
    'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3',
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
    'ea972031-33a0-4eaa-b34a-1e0f16ef31a1',
    'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3',
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
    '93fe2f4d-815c-4f4d-bf06-b5c1e978f75b',
    'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3',
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
    'ce639fc0-2663-4911-a48c-1c97d6501b9a',
    'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3',
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
    '090640b6-dbfc-4189-8e12-5f5e638a1c64',
    'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3',
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
    '82678cb4-0bca-49ad-bb83-7b61cec97e32',
    'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3',
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
    '43881500-d8a3-442c-a08e-690203ef5f3c',
    'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3',
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
    '09351c20-d580-4bb9-a9f8-6f374c9f6a14',
    'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3',
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
    'd8a0e08a-f87a-4fd7-a7b6-ee36369bc731',
    'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3',
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
    '750ae56f-e269-4f5c-a7e0-ce0c1d99d1ad',
    'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3',
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
    'a0569dc4-2286-4c97-856b-edd416ec8de6',
    'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3',
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
    '87319afd-f202-49f4-ac10-53bc89f5f280',
    'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3',
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
    '9a5c2584-e3d8-45a9-a7be-621002f1c091',
    'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3',
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
    '0388546f-25b4-4259-8999-c9c297cdadfe',
    'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3',
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
    '2af3572b-da59-4886-b330-e1269e54b9fa',
    'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3',
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
    'f71bf695-796d-4454-867d-ee33c4da1a16',
    'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3',
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
    'e670ad0b-707f-41fe-ab91-311d6154b786',
    'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3',
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
    '3ca99b7b-64fc-4e04-b623-2d588ab7e70d',
    'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3',
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
    '2cdcf4c4-eb52-4e03-9a1f-1a087cf385b2',
    'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3',
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
    '09b17846-6d9c-4d5f-9251-021b48b94e53',
    'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3',
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
    '899b8c14-f358-44bc-8c90-2abc7ec8ee29',
    'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3',
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
    '92707757-dffa-40e4-bd5d-6c66807784ae',
    'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3',
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
    '42e3ff3f-7371-4a96-8c05-a3fd815a79d8',
    'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3',
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
    'ef17addf-cc49-4536-b418-8d2622e7c217',
    'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3',
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
    '93a3589d-b30e-4270-b0fc-46a4c56febf3',
    'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3',
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
    'bea2f861-8072-4a14-a7d5-6c2154474c4a',
    'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3',
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
    '3d208fb5-ac2d-4d63-96df-600a934be560',
    'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3',
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
    '9802b655-7653-4c7f-b3c1-eb4f90970d47',
    'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3',
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
    '28ba6783-b9f0-4833-8853-772ac64fa04f',
    'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3',
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
    'ee066f1d-597a-436e-928d-0b3974036a15',
    'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3',
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
    '526ef60a-7870-4fca-bb89-7c0af9dc8759',
    'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3',
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
    '986bc27c-d999-49f7-85ac-44ed3bc8cd96',
    'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3',
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
    '8a3f86f6-5994-4d62-8c1c-c746f76562b9',
    'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3',
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
    '0fd1357c-6d6a-4327-ac33-588a44a5a30c',
    'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3',
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
    'a9e377a8-c480-46aa-a89d-e35ef26f8c87',
    'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3',
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
    '48ec1cc9-938b-45c9-a71d-5a2f2a15f965',
    'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3',
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
    'a0926a66-a812-4492-a593-e42d1b171007',
    'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3',
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
    '42cd5f96-58a3-4d5d-91a6-dab544719040',
    'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3',
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
    '35a42729-9227-40b5-ab85-7767ec4b1ae4',
    'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3',
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
    '667d45d0-726b-4bec-bf9b-ab1cf09d9766',
    'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3',
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
    '2326b335-9f3a-4bb9-b949-809e00f4ab5d',
    'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3',
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
    '73f824f9-79a2-4ba2-a241-80e85d5213ee',
    'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3',
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
    'cd88dd6e-7ba5-4ef2-876e-433234307bad',
    'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3',
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
    'dc24196f-ee4b-4eff-afa7-9a1cc481ca55',
    'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3',
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
    '32b0db72-3e50-4624-ab65-229f08e8a207',
    'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3',
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
    'c2a7900f-4047-44e1-8abd-e22ecebfd0b6',
    'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3',
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
    'e7ee1fd1-3e81-40b4-be05-8bce883e0be4',
    'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3',
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
    '5d99355b-19d5-4441-a2bd-5831a1bbef73',
    'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3',
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
    'bd013af6-8fa7-4001-950a-e1f06578333b',
    'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3',
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
    '2182a8ab-0cfc-4e02-9da1-426bdb4e7e75',
    'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3',
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
    'dba94d2f-cc97-4bce-98e0-8d5771adba7a',
    'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3',
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
    '7a6035b1-9132-4ecc-95b2-ba0a03f07e4d',
    'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3',
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
    'f2b25b5c-4e91-47b1-882d-442de4e12fdf',
    'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3',
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
    'c2746669-1a9b-41e9-9014-fbd96e013d57',
    'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3',
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
    '3590fa1a-c6e0-4eb1-ba62-b253765f810e',
    'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3',
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
    'ef1295fa-e03a-4de5-a73e-00b11c1cb687',
    'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3',
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
    '5f51e111-7595-4430-aa70-08d9033878b7',
    'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3',
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
    '7fbb1640-6613-44e0-be57-b12abab93113',
    'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3',
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
    '5cc98be8-f218-499d-8e02-eef42f7108cb',
    'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3',
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
    '975f8a0e-5a4c-40fb-9fe0-ef91db0a9363',
    'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3',
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
    'ea9c9b22-feea-45c9-b541-42bfc82fbdc1',
    'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3',
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
    'b193fcb2-784a-4e60-89f4-1fe43f78fb55',
    'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3',
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
    'd6396c67-1992-41af-bc6c-2150993d00ce',
    'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3',
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
    '0699d366-5a90-4881-9d84-65bbd587c072',
    'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3',
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
    'bb81e855-cb45-4f63-8813-4c3504569d2f',
    'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3',
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
    '1fb7e520-29df-47c1-a05c-eef83080e631',
    'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3',
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
    '6b18524f-aaf4-4f78-a5e0-7ed30189792f',
    'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3',
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
    '18dc3da4-9d43-414b-b2c8-3cef776bfabe',
    'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3',
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
    '1494973a-c798-4b3a-8739-2721db16f7de',
    'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3',
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
    '994b3d18-b02f-4706-a0ac-edff5cbda8ed',
    'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3',
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
    '1cde5a02-292a-4f95-858a-af85d0602ea3',
    'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3',
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
    '021d4570-d0f5-488a-bb08-c31e18620b1d',
    'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3',
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
    '2ad6b4d2-f395-46f1-8103-0cbd6bcdac15',
    'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3',
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
    '851bdb0d-4955-4925-8057-008b62d7655f',
    'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3',
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
    '8d16f078-f124-4297-a930-e6d65cdc94c5',
    'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3',
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
    '1da8044c-bee5-4021-a53c-213e6787b3b1',
    'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3',
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
    'c6c81475-9422-4c7f-a3f0-ff9d5cda3d61',
    'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3',
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
    'bd41cdce-4439-4790-884f-794905276181',
    'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3',
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
    '624a2fe8-caea-487d-b110-78866e1103d0',
    'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3',
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
    '168ed7c1-433e-4042-976a-7e8a5a146937',
    'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3',
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
    '91cf8b78-b6a2-4720-9b74-bd95bb3e0cb8',
    'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3',
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
    '02dd323b-a533-4529-bcf3-d449d5e775e2',
    'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3',
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
    '801c084d-ba90-4f4f-8a5b-fdd16f116b23',
    'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3',
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
    '263331c1-25a5-400f-8baa-741211784ef1',
    'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3',
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
    '65dcb8e6-5c7b-486d-a26b-cc5d92311fa5',
    'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3',
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
    '2bff78aa-746c-44fb-bd93-a65017f6830f',
    'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3',
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
    '5d6f7958-9367-492f-a830-43d34def9d4b',
    'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3',
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
    '1a29ccfb-bae1-4252-bb5b-ada02ad3bb30',
    'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3',
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
    'b95bb153-b0cd-4dbf-ba58-3bc75cf56c5a',
    'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3',
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
    '74599fe0-15b8-45f4-bbb6-a64ee595a2d1',
    'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3',
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
    '6d780bbd-aa4b-4c2a-8501-0022d39726e5',
    'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3',
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
    'e3f9d8e9-b9e1-4928-b7b8-62a1e564f3b1',
    'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3',
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
    '4aafeba2-47cb-4b7a-b0c4-f7f31f938bd4',
    'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3',
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
    '73c57913-3b10-40d1-bed0-54a08d00089d',
    'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3',
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
    '116b38d2-65ff-4845-8a10-9755ebd6ff6a',
    'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3',
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
    'fd0a61a3-f467-46c4-b37d-675f904ed4eb',
    'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3',
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
    'e2639508-2098-436e-8372-82892dd1b059',
    'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3',
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
    'ee4b6674-6ca3-41a8-8d85-7c404365497d',
    'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3',
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
    '89753f63-d5ae-44d7-917f-1b86056e4d27',
    'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3',
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
    '7dd68447-738c-4f8d-b2a8-f94827fee700',
    'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3',
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
    '40810571-c49e-479b-89a6-8d1cbdae879b',
    'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3',
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
    'df3258ef-6e7e-4f54-9503-9df0e83bf58f',
    'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3',
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
    '985426f9-6d9c-468b-8808-545e3997d1c6',
    'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3',
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
    'ede66c3d-6818-427b-bf27-ca5a1324cf8f',
    'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3',
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
    'c6fe213f-5e69-46bc-9c3e-085f282f9309',
    'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3',
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
    '49b75a0b-6eed-476f-b679-c9937fbb9e0a',
    'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3',
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
    '56996870-0b3e-417a-aa3a-528cb85f13e2',
    'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3',
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
    'c917003d-e102-458d-8cdc-569afea5c4ce',
    'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3',
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
    '0f800e55-b6a7-4b56-9302-c4fc9985034b',
    'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3',
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
    '06309bc6-1cbc-4ac3-962d-34ac03d14019',
    'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3',
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
    'aaf86dfe-6999-4b61-a47f-db6f4c63c0f9',
    'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3',
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
    'ba62bc22-1b8d-4ac1-8529-e18b6ab93f7a',
    'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3',
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
    'e56aecc5-b7de-4bc1-b1c4-eb05732f845e',
    'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3',
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
    'fc03ccfa-32e0-4211-a76d-7ce9ea957b47',
    'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3',
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
    '6f167fa6-e36a-4803-b3e6-1fe550aae37b',
    'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3',
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
    '17e9e3b9-f095-4f4d-ab84-42fa86351c0c',
    'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3',
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
    '3c106e4c-9af8-42b0-8a84-71aedb6b0da9',
    'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3',
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
    '1b7824ef-9089-4a3b-9f80-d99ec5656b37',
    'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3',
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
    '35d0b9be-7eda-47d9-9d0b-0707eb2d4fbb',
    'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3',
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
    '223c4af2-4a03-4652-a243-4f5d725b6b72',
    'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3',
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
    '23ef6bfb-fe3b-49be-8a63-1792e92343f7',
    'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3',
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
    '392658b2-cf45-46f3-ad0c-1f0812fbbf70',
    'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3',
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
    '356c51bc-d8b7-4d05-bb9c-82bc12d645e1',
    'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3',
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
    'f6119197-5c3e-4b0f-9616-523d1e941a96',
    'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3',
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
    'd093d144-985d-4e9a-9765-dd72bc0cc7aa',
    'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3',
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
    '6d574d74-daee-4435-acba-62abc9c56c8b',
    'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3',
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
    '4af16c55-c54b-4a20-8fc8-a5ba1bf92d48',
    'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3',
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
    '1d8ff459-7d11-43e3-8d4e-c71b78a79ad1',
    'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3',
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
    '4c94d93e-786e-4b09-a6b4-5553d6558e6d',
    'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3',
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
    '5801e976-cce9-449e-b899-a066685120bc',
    'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3',
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
    'c3c930c0-7714-4d72-ab44-8f8ffdb19347',
    'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3',
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
    '714c1ecb-b0ad-46c5-8141-7b03d9a8b9aa',
    'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3',
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
    'fda8b857-2d76-4635-af16-c7d08ad057f5',
    'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3',
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
    'dc4cee8a-526a-46cd-a539-7b63ce133185',
    'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3',
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
    '9dfbc922-069e-4dab-86ec-f75256ff6045',
    'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3',
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
    'ac01a3db-88a2-4b70-9761-a2aeb1946ecf',
    'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3',
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
    '85b13e9d-b841-4d4b-8d20-81142f2051b4',
    'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3',
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
    'ddc869f1-a24f-474a-bbcc-00ca08a6e702',
    'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3',
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
    '5f2ddd61-1ef2-483a-90c5-d83bde610e78',
    'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3',
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
    '1e94dcc1-e3f0-45ab-8db0-678e5591a382',
    'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3',
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
    '4cf8d101-be1c-48f5-a474-f4feaed875ee',
    'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3',
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
    '4b04919f-66b4-4e3c-8063-2ef421c97a63',
    'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3',
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
    'da98aa4e-7674-4030-bf6b-0efe95d9eb68',
    'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3',
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
    '14693b3e-a0cd-4c51-befc-b0742ceccf01',
    'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3',
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
    '03bba879-2f62-404f-8e05-8710a3496b66',
    'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3',
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
    'd3b8397d-8841-4e39-a73d-6cc1b11c4621',
    'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3',
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
    '7296d6ef-02c2-41c6-bc32-2d3b3a74b32e',
    'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3',
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
    '1ea0dad3-9a97-4e46-b0f9-e93a34170705',
    'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3',
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
    '2480bb42-fff0-41b7-a8ec-3e3a3280321c',
    'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3',
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
    '0300157f-f13d-462b-867c-3d60f2e0c4e4',
    'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3',
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
    '398b8866-8264-402f-9962-be27bfba9db5',
    'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3',
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
    'cb58a4f9-d93f-4b1e-8e3a-6b773f2ff843',
    'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3',
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
    '273f9260-18a5-4085-bb20-84c86892841a',
    'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3',
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
    '9cefac5f-4f2b-4ddb-8b31-41009ea98c83',
    'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3',
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
    '72ff9555-13ad-480e-9d88-9a9ef75f1afe',
    'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3',
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
    'df8eb8db-9f7b-4e8d-94bc-e2cbec42cba0',
    'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3',
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
    '34421bac-2963-47df-8bae-2e3d5f0b97ce',
    'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3',
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
    '0a020119-bf67-4e22-86e7-7e44f75cdb69',
    'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3',
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
    '9e6505b5-c3ab-446b-9b10-c977d1795789',
    'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3',
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
    'd5fce2f9-7954-4f60-9849-43f72b7721eb',
    'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3',
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
    'afdca921-fb0a-4f43-b5c4-2509664b543f',
    'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3',
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
    '02024adc-ad16-4cf7-b584-6c9c9766c6c3',
    'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3',
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
    '5926340b-64bc-400f-b972-f28d2dd131c3',
    'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3',
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
    '5b7290f5-d127-4727-b244-99737f5cea16',
    'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3',
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
    'b1067e21-bdfb-436e-aff5-b19be12058d0',
    'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3',
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
    '8314d5e9-f915-430c-94b1-382b5e1dc427',
    'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3',
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
    '9262deda-aedd-497d-bd67-f6e6d6d7cbd6',
    'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3',
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
    '5c54feb7-4e31-4177-8184-2062e78e3867',
    'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3',
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
    '9d8b1a26-d364-4305-8712-c729d88c3992',
    'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3',
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
    '6be7b238-9879-443f-801b-f83edf91d095',
    'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3',
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
    '6653a55a-0053-4050-9bc7-db682f3145e1',
    'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3',
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
    '85b07ced-9a9a-4409-946f-0880278a38c4',
    'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3',
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
    '615e1ec4-6ad1-47b7-89a8-d81304b995f4',
    'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3',
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
    'd9db3f0e-5a23-4c0d-83da-3c229d6f0540',
    'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3',
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
    '3a242115-cea8-4d1c-b6fd-d565f2ee75f9',
    'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3',
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
    '35404f62-6794-48d3-9e36-f6d53e4e0316',
    'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3',
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
    '4d0ebf2c-dfa7-4853-9576-1a9b0627e85d',
    'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3',
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
    '9ef4bcfa-25aa-4708-91a6-0a0a49630d3d',
    'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3',
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
    '4a3c16bd-78e8-4483-8922-498fd155e7d7',
    'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3',
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
    '4095e8f9-8a40-4d28-8c53-4e705db329a2',
    'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3',
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
    '1a82b85b-97b8-4166-85aa-bd5177a117f1',
    'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3',
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
    '78a66819-bb8a-47a6-a379-107f08a96d3d',
    'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3',
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
    '7270c971-646c-4d78-82f2-d25335d8c435',
    'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3',
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
    '4f94f220-67bc-464e-8075-9ac0c69963b5',
    'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3',
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
    '9d91661a-8fb0-4ba7-83b8-bf6f8fd7c533',
    'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3',
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
    '3a6a5fe3-a609-4fd3-a33b-2f01724c9a68',
    'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3',
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
    '727ced26-2c0b-453e-b4ef-882e4e9490c1',
    'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3',
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
    '8ff49769-39ee-482f-b931-effdf1ecab5f',
    'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3',
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
    'd70a6045-3012-4fcd-bf4b-dbd7c4aecfc4',
    'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3',
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
    '39336985-93fa-4ace-bc2a-f6f9214236da',
    'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3',
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
    'f4f8f8ed-abf6-43db-98c0-c4dca71d61e4',
    'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3',
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
    '5a94ae4b-237e-401f-9234-ff1669d0d048',
    'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3',
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
    '9df2b999-6fe5-4e45-9ddb-24f7ac02b0fd',
    'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3',
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
    '58f270d5-7e26-47e3-b2af-3186db6dfe03',
    'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3',
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
    '09f781a1-a925-4847-8df0-abe977ee8de7',
    'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3',
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
    '0a8c87f8-699b-49a6-a206-4bb859c87484',
    'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3',
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
    'cb5116e4-b41d-4022-a363-e83b41012e75',
    'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3',
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
    '78c0fe20-7c19-4c0b-8d41-ad5864ee26da',
    'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3',
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
    '152957aa-2401-4cd0-bcd4-e4ff80f0fe64',
    'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3',
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
    '9c0a2a60-deac-4c85-a535-82ea7819e075',
    'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3',
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
    '10d89df5-d137-4705-8a3e-3e3ff8a60864',
    'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3',
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
    'c2b0f31d-bfeb-442a-922c-a902eb7b6d12',
    'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3',
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
    '3aaae649-2809-4111-a55b-29375dc2483e',
    'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3',
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
    'd17a086b-fde9-437c-b17c-488807296e0a',
    'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3',
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
    'b89e7ae4-90a3-46d0-9f92-5d62d468cd95',
    'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3',
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
    '4df5b196-9a01-42e2-944b-5e78fa7c38d5',
    'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3',
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
    'd1f318e0-5ec7-4d2a-86ba-f2b7f8dce2f6',
    'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3',
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
    'ec09b86e-d501-45df-a716-dc03538695e4',
    'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3',
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
    'e73edc38-07a0-417f-9f17-55cf92837158',
    'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3',
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
    'f794bd78-9270-492f-8a64-542f29c088ea',
    'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3',
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
    '2938fd8f-6064-4b39-b077-b8da1526f93b',
    'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3',
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
    '02c75e4e-cff8-4812-8338-90ba075a41f0',
    'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3',
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
    '9fcefcb9-38a5-4890-af9e-8ead0c36753a',
    'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3',
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
    '5baa37c5-f996-4a36-af79-906b465b3c73',
    'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3',
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
    '9c06ea27-abb8-4266-8109-358210a97ba0',
    'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3',
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
    'fd5dc55c-43a4-4248-a6ce-83d88eaf3ead',
    'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3',
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
    '9b186d9e-04c1-482c-a363-5e3ef0a90984',
    'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3',
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
    '0c06b6f6-2bd7-4159-91e5-a656c927e57e',
    'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3',
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
    '7ef0dba1-77a9-450a-9cf7-1cdbae8a3937',
    'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3',
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
    '471dabec-ba71-4c8e-a26e-72d67b3e1bb4',
    'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3',
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
    'ae9aa120-3d7a-455a-bc43-89d8978c5323',
    'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3',
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
    '46d478e0-a207-4b9c-a570-a064f7d9ed80',
    'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3',
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
    '9a37b633-2818-47a4-b34d-b2e25e84b994',
    'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3',
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
    'a130f180-0346-4086-81d4-c86c50f8e2c2',
    'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3',
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
    '7cf30e40-b4a7-4ae9-9a1d-141df59f5887',
    'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3',
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
    'bdebc9f5-619a-4aaf-8621-20b14c306f18',
    'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3',
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
    '4ce1b7fd-e01d-4b51-b99f-8a97846bd3a6',
    'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3',
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
    '097a7814-ffbf-4ba9-a184-77ae587cf7da',
    'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3',
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
    '4bc654b0-668c-46a7-a594-df8000137050',
    'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3',
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
    'b044964e-b193-4466-a9c3-b7873ce47ad3',
    'c30c69ef-5ca3-4e1d-b69b-f3d0750f00b3',
    'boiler_location',
    'utilities',
    'Boiler',
    NULL,
    'Gaskets Very Very',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;
