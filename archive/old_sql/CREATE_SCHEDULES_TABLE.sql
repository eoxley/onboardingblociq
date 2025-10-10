-- =====================================
-- BlocIQ V2 Service Charge Schedules
-- Add schedules table for building schedule management
-- =====================================
-- Run this in Supabase SQL Editor before onboarding buildings with schedules
-- =====================================

-- Create schedules table
CREATE TABLE IF NOT EXISTS schedules (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  building_id uuid NOT NULL REFERENCES buildings(id) ON DELETE CASCADE,
  name text NOT NULL,
  service_charge_code text,
  notes text,
  meta jsonb DEFAULT '{}'::jsonb,
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now(),
  UNIQUE(building_id, name)
);

-- Add indexes for performance
CREATE INDEX IF NOT EXISTS idx_schedules_building_id ON schedules(building_id);
CREATE INDEX IF NOT EXISTS idx_schedules_code ON schedules(service_charge_code);

-- Add schedule_id to budgets table if not exists
ALTER TABLE budgets
  ADD COLUMN IF NOT EXISTS schedule_id uuid REFERENCES schedules(id) ON DELETE SET NULL;

CREATE INDEX IF NOT EXISTS idx_budgets_schedule_id ON budgets(schedule_id);

-- Add schedule_id to units table if not exists (for per-unit schedule allocation)
ALTER TABLE units
  ADD COLUMN IF NOT EXISTS schedule_id uuid REFERENCES schedules(id) ON DELETE SET NULL;

CREATE INDEX IF NOT EXISTS idx_units_schedule_id ON units(schedule_id);

-- Add schedule_id to compliance_assets if needed (for schedule-specific compliance)
ALTER TABLE compliance_assets
  ADD COLUMN IF NOT EXISTS schedule_id uuid REFERENCES schedules(id) ON DELETE SET NULL;

CREATE INDEX IF NOT EXISTS idx_compliance_assets_schedule_id ON compliance_assets(schedule_id);

-- Enable RLS
ALTER TABLE schedules ENABLE ROW LEVEL SECURITY;

-- Drop existing policies if they exist
DROP POLICY IF EXISTS "Users can view schedules for their buildings" ON schedules;
DROP POLICY IF EXISTS "Users can insert schedules for their buildings" ON schedules;
DROP POLICY IF EXISTS "Users can update schedules for their buildings" ON schedules;

-- Create RLS policies (adjust based on your auth setup)
-- Example: Allow authenticated users to see schedules for buildings they have access to
CREATE POLICY "Users can view schedules for their buildings"
  ON schedules FOR SELECT
  USING (
    building_id IN (
      SELECT building_id FROM building_access WHERE user_id = auth.uid()
    )
  );

CREATE POLICY "Users can insert schedules for their buildings"
  ON schedules FOR INSERT
  WITH CHECK (
    building_id IN (
      SELECT building_id FROM building_access WHERE user_id = auth.uid()
    )
  );

CREATE POLICY "Users can update schedules for their buildings"
  ON schedules FOR UPDATE
  USING (
    building_id IN (
      SELECT building_id FROM building_access WHERE user_id = auth.uid()
    )
  );

-- Verification
SELECT
  column_name,
  data_type,
  is_nullable,
  column_default
FROM information_schema.columns
WHERE table_name = 'schedules'
ORDER BY ordinal_position;

-- Show sample query
-- SELECT
--   s.id,
--   s.name,
--   s.service_charge_code,
--   b.name AS building_name,
--   COUNT(DISTINCT u.id) AS units_count,
--   COUNT(DISTINCT bg.id) AS budgets_count
-- FROM schedules s
-- JOIN buildings b ON s.building_id = b.id
-- LEFT JOIN units u ON u.schedule_id = s.id
-- LEFT JOIN budgets bg ON bg.schedule_id = s.id
-- GROUP BY s.id, s.name, s.service_charge_code, b.name;

-- =====================================
-- SUCCESS!
-- =====================================
-- After running this:
-- 1. Schedules table is ready
-- 2. Budgets, units, and compliance_assets can link to schedules
-- 3. RLS policies protect schedule data
-- 4. Ready for onboarder to auto-create schedules
-- =====================================
