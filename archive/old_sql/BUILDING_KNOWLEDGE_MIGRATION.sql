-- ============================================================
-- Building Knowledge Enhancement Migration
-- ============================================================
-- Purpose: Enhance existing building_keys_access table to support
--          broader building information (not just access codes)
-- Usage: Stores practical info accessible via ContextRibbon UI
--        and Ask BlocIQ chat
-- ============================================================

-- Step 1: Extend building_keys_access with new columns
-- ============================================================
-- Note: This table already exists with:
--   - access_type, description, code, location, notes
-- We're adding: category, label, visibility for better organization

ALTER TABLE building_keys_access
  ADD COLUMN IF NOT EXISTS category text,
  ADD COLUMN IF NOT EXISTS label text,
  ADD COLUMN IF NOT EXISTS visibility text DEFAULT 'team';

-- Step 2: Create indexes for performance
-- ============================================================

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

-- Step 3: Migrate existing data to new structure
-- ============================================================
-- Map access_type to category and create labels

UPDATE building_keys_access
SET
  category = CASE
    WHEN access_type IN ('labelled_keys', 'gate_codes', 'entrance_codes') THEN 'access'
    WHEN access_type IN ('bin_store', 'bike_store') THEN 'general'
    ELSE 'access'
  END,
  label = CASE
    WHEN access_type = 'labelled_keys' THEN 'Keys'
    WHEN access_type = 'gate_codes' THEN 'Gate Codes'
    WHEN access_type = 'entrance_codes' THEN 'Entrance Codes'
    WHEN access_type = 'bin_store' THEN 'Bin Store Access'
    WHEN access_type = 'bike_store' THEN 'Bike Store Access'
    ELSE initcap(replace(access_type, '_', ' '))
  END,
  visibility = 'team'
WHERE category IS NULL;

-- Step 4: Add constraints and comments
-- ============================================================

COMMENT ON COLUMN building_keys_access.category IS
  'Logical grouping: access, utilities, safety, general';

COMMENT ON COLUMN building_keys_access.label IS
  'Human-readable label for UI display';

COMMENT ON COLUMN building_keys_access.visibility IS
  'Who can view this: team, directors, contractors';

COMMENT ON COLUMN building_keys_access.access_type IS
  'Legacy type field - use category instead for new records';

COMMENT ON COLUMN building_keys_access.code IS
  'Access codes, gate codes, etc. (should be encrypted in production)';

COMMENT ON COLUMN building_keys_access.location IS
  'Physical location: e.g., "Boiler room cupboard to the left"';

COMMENT ON COLUMN building_keys_access.description IS
  'Additional descriptive text';

COMMENT ON TABLE building_keys_access IS
  'Building knowledge: access codes, utility locations, safety equipment, general info';

-- Step 5: Seed data examples (optional)
-- ============================================================

-- Example entries for demonstration
-- Uncomment and modify with actual building IDs

/*
INSERT INTO building_keys_access (building_id, category, access_type, label, code, location, description, visibility)
VALUES
  -- Access information
  (
    '00000000-0000-0000-0000-000000000000', -- Replace with actual building_id
    'access',
    'gate_codes',
    'Front Gate Code',
    '4829#',
    NULL,
    'Main entrance gate code',
    'contractors'
  ),
  (
    '00000000-0000-0000-0000-000000000000',
    'access',
    'gate_codes',
    'Rear Gate Code',
    '1234*',
    NULL,
    'Rear service entrance',
    'contractors'
  ),

  -- Utilities information
  (
    '00000000-0000-0000-0000-000000000000',
    'utilities',
    'stopcock',
    'Stopcock',
    NULL,
    'Boiler room cupboard to the left',
    'Main water shutoff valve',
    'team'
  ),
  (
    '00000000-0000-0000-0000-000000000000',
    'utilities',
    'meter',
    'Gas Meter',
    NULL,
    'External wall, rear of building',
    NULL,
    'team'
  ),
  (
    '00000000-0000-0000-0000-000000000000',
    'utilities',
    'meter',
    'Electric Meter',
    NULL,
    'Ground floor utility cupboard',
    NULL,
    'team'
  ),

  -- Safety information
  (
    '00000000-0000-0000-0000-000000000000',
    'safety',
    'alarm',
    'Alarm Panel',
    NULL,
    'Main entrance hallway, left side',
    NULL,
    'team'
  ),
  (
    '00000000-0000-0000-0000-000000000000',
    'safety',
    'assembly_point',
    'Fire Assembly Point',
    NULL,
    'Front courtyard near main gate',
    NULL,
    'team'
  ),

  -- General information
  (
    '00000000-0000-0000-0000-000000000000',
    'general',
    'general',
    'Bin Collection Day',
    NULL,
    NULL,
    'Thursday mornings (before 7am)',
    'team'
  ),
  (
    '00000000-0000-0000-0000-000000000000',
    'general',
    'wifi',
    'WiFi Network',
    NULL,
    NULL,
    'Building_Common_5G (password in secure vault)',
    'team'
  )
ON CONFLICT (id) DO NOTHING;
*/

-- ============================================================
-- Migration Complete
-- ============================================================
-- Next Steps:
-- 1. Run this migration in your Supabase SQL editor
-- 2. Integrate with BlocIQ Onboarder Python generator
-- 3. Update property form extraction to populate this table
-- 4. Implement frontend ContextRibbon UI integration
-- 5. Add to Ask BlocIQ chat context
-- ============================================================
