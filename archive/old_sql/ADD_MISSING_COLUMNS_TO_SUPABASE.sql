-- =====================================
-- BlocIQ V2 Schema Enhancement
-- Add missing columns for Onboarder compatibility
-- =====================================
-- Run this in Supabase SQL Editor BEFORE running migration.sql
-- This ensures the generated migration.sql will succeed
-- =====================================

-- 1. UNITS TABLE - Add property details
ALTER TABLE units
  ADD COLUMN IF NOT EXISTS floor_number integer,
  ADD COLUMN IF NOT EXISTS unit_type text,
  ADD COLUMN IF NOT EXISTS bedrooms integer,
  ADD COLUMN IF NOT EXISTS square_footage numeric;

COMMENT ON COLUMN units.floor_number IS 'Floor level of the unit';
COMMENT ON COLUMN units.unit_type IS 'Type: Flat, Apartment, Commercial, etc.';
COMMENT ON COLUMN units.bedrooms IS 'Number of bedrooms';
COMMENT ON COLUMN units.square_footage IS 'Total floor area in square feet';

-- 2. LEASEHOLDERS TABLE - Add personal details
ALTER TABLE leaseholders
  ADD COLUMN IF NOT EXISTS first_name text,
  ADD COLUMN IF NOT EXISTS last_name text,
  ADD COLUMN IF NOT EXISTS email text,
  ADD COLUMN IF NOT EXISTS phone text,
  ADD COLUMN IF NOT EXISTS move_in_date date;

COMMENT ON COLUMN leaseholders.first_name IS 'Leaseholder first name';
COMMENT ON COLUMN leaseholders.last_name IS 'Leaseholder last name or company name';
COMMENT ON COLUMN leaseholders.email IS 'Contact email';
COMMENT ON COLUMN leaseholders.phone IS 'Contact phone number';
COMMENT ON COLUMN leaseholders.move_in_date IS 'Date leaseholder moved in';

-- 3. BUILDING_DOCUMENTS TABLE - Add file tracking
ALTER TABLE building_documents
  ADD COLUMN IF NOT EXISTS file_path text,
  ADD COLUMN IF NOT EXISTS file_type text;

COMMENT ON COLUMN building_documents.file_path IS 'Local file path (legacy - use storage_path for new docs)';
COMMENT ON COLUMN building_documents.file_type IS 'File extension: pdf, docx, xlsx, etc.';

-- 4. COMPLIANCE_ASSETS TABLE - Add tracking fields
ALTER TABLE compliance_assets
  ADD COLUMN IF NOT EXISTS category text,
  ADD COLUMN IF NOT EXISTS asset_name text,
  ADD COLUMN IF NOT EXISTS asset_type text,
  ADD COLUMN IF NOT EXISTS inspection_frequency interval,
  ADD COLUMN IF NOT EXISTS description text,
  ADD COLUMN IF NOT EXISTS location text,
  ADD COLUMN IF NOT EXISTS responsible_party text,
  ADD COLUMN IF NOT EXISTS notes text;

COMMENT ON COLUMN compliance_assets.category IS 'Category: compliance, safety, maintenance, etc.';
COMMENT ON COLUMN compliance_assets.asset_name IS 'Name of the compliance asset';
COMMENT ON COLUMN compliance_assets.asset_type IS 'Type: fire_safety, electrical, water_safety, general, etc.';
COMMENT ON COLUMN compliance_assets.inspection_frequency IS 'How often inspection is required (e.g., 12 months)';
COMMENT ON COLUMN compliance_assets.description IS 'Description of the asset';
COMMENT ON COLUMN compliance_assets.location IS 'Physical location within building';
COMMENT ON COLUMN compliance_assets.responsible_party IS 'Who is responsible for this asset';

-- 5. BUILDINGS TABLE - Add portfolio link if missing
ALTER TABLE buildings
  ADD COLUMN IF NOT EXISTS postcode text,
  ADD COLUMN IF NOT EXISTS building_type text,
  ADD COLUMN IF NOT EXISTS year_built integer,
  ADD COLUMN IF NOT EXISTS total_floor_area numeric;

COMMENT ON COLUMN buildings.postcode IS 'Building postcode';
COMMENT ON COLUMN buildings.building_type IS 'Type: Residential, Commercial, Mixed Use, etc.';
COMMENT ON COLUMN buildings.year_built IS 'Year of construction';
COMMENT ON COLUMN buildings.total_floor_area IS 'Total building area in square feet';

-- 6. BUILDING_KEYS_ACCESS TABLE - Create if doesn't exist
CREATE TABLE IF NOT EXISTS building_keys_access (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  building_id uuid REFERENCES buildings(id) ON DELETE CASCADE,
  key_type text,
  location text,
  access_details text,
  notes text,
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now()
);

COMMENT ON TABLE building_keys_access IS 'Tracks key and access information for buildings';

-- 7. MAJOR_WORKS_PROJECTS TABLE - Ensure exists
CREATE TABLE IF NOT EXISTS major_works_projects (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  building_id uuid REFERENCES buildings(id) ON DELETE CASCADE,
  project_name text NOT NULL,
  description text,
  start_date date,
  end_date date,
  estimated_cost numeric,
  actual_cost numeric,
  status text DEFAULT 'draft',
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now()
);

COMMENT ON TABLE major_works_projects IS 'Major works and renovation projects';

-- 8. Create indexes for performance
CREATE INDEX IF NOT EXISTS idx_units_building_id ON units(building_id);
CREATE INDEX IF NOT EXISTS idx_units_unit_number ON units(unit_number);
CREATE INDEX IF NOT EXISTS idx_leaseholders_building_id ON leaseholders(building_id);
CREATE INDEX IF NOT EXISTS idx_leaseholders_unit_number ON leaseholders(unit_number);
CREATE INDEX IF NOT EXISTS idx_leaseholders_email ON leaseholders(email);
CREATE INDEX IF NOT EXISTS idx_compliance_assets_building_id ON compliance_assets(building_id);
CREATE INDEX IF NOT EXISTS idx_compliance_assets_type ON compliance_assets(asset_type);
CREATE INDEX IF NOT EXISTS idx_compliance_assets_status ON compliance_assets(compliance_status);
CREATE INDEX IF NOT EXISTS idx_building_documents_building_id ON building_documents(building_id);
CREATE INDEX IF NOT EXISTS idx_building_documents_category ON building_documents(category);

-- 9. Ensure RLS policies allow inserts (adjust agency_id as needed)
-- Note: You may need to customize these based on your RLS setup

-- Enable RLS if not already enabled
ALTER TABLE units ENABLE ROW LEVEL SECURITY;
ALTER TABLE leaseholders ENABLE ROW LEVEL SECURITY;
ALTER TABLE compliance_assets ENABLE ROW LEVEL SECURITY;
ALTER TABLE building_documents ENABLE ROW LEVEL SECURITY;

-- =====================================
-- VERIFICATION QUERIES
-- =====================================

-- Run these after executing the above to verify schema is ready:

-- 1. Check units columns
SELECT column_name, data_type
FROM information_schema.columns
WHERE table_name = 'units'
ORDER BY ordinal_position;

-- 2. Check leaseholders columns
SELECT column_name, data_type
FROM information_schema.columns
WHERE table_name = 'leaseholders'
ORDER BY ordinal_position;

-- 3. Check compliance_assets columns
SELECT column_name, data_type
FROM information_schema.columns
WHERE table_name = 'compliance_assets'
ORDER BY ordinal_position;

-- 4. Check building_documents columns
SELECT column_name, data_type
FROM information_schema.columns
WHERE table_name = 'building_documents'
ORDER BY ordinal_position;

-- =====================================
-- SUCCESS!
-- =====================================
-- After running this, your Supabase schema will be compatible
-- with the migration.sql generated by the BlocIQ Onboarder.
--
-- Next step: Run the generated output/migration.sql
-- =====================================
