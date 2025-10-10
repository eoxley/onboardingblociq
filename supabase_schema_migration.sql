-- ============================================================
-- BlocIQ Onboarder - Supabase Schema Migration
-- Purpose: Add missing columns to support full data extraction
-- Date: October 10, 2025
-- Impact: Zero data loss, preserves all 36 at-risk records
-- ============================================================

-- This migration adds columns needed by the onboarder to capture
-- maintenance scheduling and asset service frequency data.
-- All additions are backward-compatible (no data loss on existing records).

BEGIN;

-- ============================================================
-- 1. ADD service_frequency TO assets TABLE
-- ============================================================
-- Purpose: Track how often assets need servicing (annual, monthly, etc.)
-- Impact: Preserves data for 14 assets

DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM information_schema.columns
        WHERE table_name = 'assets' AND column_name = 'service_frequency'
    ) THEN
        ALTER TABLE assets ADD COLUMN service_frequency TEXT;
        COMMENT ON COLUMN assets.service_frequency IS 'Service interval: annual, quarterly, monthly, etc.';
    END IF;
END $$;

-- ============================================================
-- 2. ENHANCE schedules TABLE FOR MAINTENANCE TRACKING
-- ============================================================
-- Purpose: Transform basic schedules table into full maintenance scheduling
-- Impact: Preserves data for 22 maintenance schedule records

-- Add contract linkage
DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM information_schema.columns
        WHERE table_name = 'schedules' AND column_name = 'contract_id'
    ) THEN
        ALTER TABLE schedules ADD COLUMN contract_id UUID;
        COMMENT ON COLUMN schedules.contract_id IS 'Links to contractor_contracts table';
    END IF;
END $$;

-- Add service type categorization
DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM information_schema.columns
        WHERE table_name = 'schedules' AND column_name = 'service_type'
    ) THEN
        ALTER TABLE schedules ADD COLUMN service_type TEXT;
        COMMENT ON COLUMN schedules.service_type IS 'Type of service: Fire Alarm, Lift Maintenance, etc.';
    END IF;
END $$;

-- Add frequency tracking
DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM information_schema.columns
        WHERE table_name = 'schedules' AND column_name = 'frequency'
    ) THEN
        ALTER TABLE schedules ADD COLUMN frequency TEXT;
        COMMENT ON COLUMN schedules.frequency IS 'Service frequency: annual, quarterly, monthly, weekly';
    END IF;
END $$;

-- Add frequency interval (numeric)
DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM information_schema.columns
        WHERE table_name = 'schedules' AND column_name = 'frequency_interval'
    ) THEN
        ALTER TABLE schedules ADD COLUMN frequency_interval INTEGER;
        COMMENT ON COLUMN schedules.frequency_interval IS 'Number of months between services (1, 3, 6, 12, etc.)';
    END IF;
END $$;

-- Add next due date
DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM information_schema.columns
        WHERE table_name = 'schedules' AND column_name = 'next_due_date'
    ) THEN
        ALTER TABLE schedules ADD COLUMN next_due_date DATE;
        COMMENT ON COLUMN schedules.next_due_date IS 'When this service is next due';
    END IF;
END $$;

-- Add priority
DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM information_schema.columns
        WHERE table_name = 'schedules' AND column_name = 'priority'
    ) THEN
        ALTER TABLE schedules ADD COLUMN priority TEXT DEFAULT 'medium';
        COMMENT ON COLUMN schedules.priority IS 'Priority level: high, medium, low';
    END IF;
END $$;

-- Add status tracking
DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM information_schema.columns
        WHERE table_name = 'schedules' AND column_name = 'status'
    ) THEN
        ALTER TABLE schedules ADD COLUMN status TEXT DEFAULT 'active';
        COMMENT ON COLUMN schedules.status IS 'Status: active, overdue, upcoming, completed, cancelled';
    END IF;
END $$;

-- Add estimated duration
DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM information_schema.columns
        WHERE table_name = 'schedules' AND column_name = 'estimated_duration'
    ) THEN
        ALTER TABLE schedules ADD COLUMN estimated_duration TEXT;
        COMMENT ON COLUMN schedules.estimated_duration IS 'Expected time to complete service';
    END IF;
END $$;

-- ============================================================
-- 3. ADD PERFORMANCE INDEXES
-- ============================================================
-- These indexes speed up common queries for maintenance tracking

-- Index for finding upcoming/overdue services
DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM pg_indexes
        WHERE indexname = 'idx_schedules_next_due_date'
    ) THEN
        CREATE INDEX idx_schedules_next_due_date ON schedules(next_due_date);
    END IF;
END $$;

-- Index for filtering by status
DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM pg_indexes
        WHERE indexname = 'idx_schedules_status'
    ) THEN
        CREATE INDEX idx_schedules_status ON schedules(status);
    END IF;
END $$;

-- Index for contract lookups
DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM pg_indexes
        WHERE indexname = 'idx_schedules_contract_id'
    ) THEN
        CREATE INDEX idx_schedules_contract_id ON schedules(contract_id);
    END IF;
END $$;

-- ============================================================
-- 4. ADD FOREIGN KEY CONSTRAINT (Optional - Enforces Data Integrity)
-- ============================================================
-- Uncomment if you want to enforce contract_id must exist in contractor_contracts

-- DO $$
-- BEGIN
--     IF NOT EXISTS (
--         SELECT 1 FROM information_schema.table_constraints
--         WHERE constraint_name = 'fk_schedules_contract'
--     ) THEN
--         ALTER TABLE schedules
--         ADD CONSTRAINT fk_schedules_contract
--         FOREIGN KEY (contract_id)
--         REFERENCES contractor_contracts(id)
--         ON DELETE SET NULL;
--     END IF;
-- END $$;

COMMIT;

-- ============================================================
-- VERIFICATION QUERIES
-- ============================================================
-- Run these after migration to verify success:

-- Check assets table has new column:
SELECT column_name, data_type, is_nullable
FROM information_schema.columns
WHERE table_name = 'assets' AND column_name = 'service_frequency';

-- Check schedules table has all new columns:
SELECT column_name, data_type, is_nullable, column_default
FROM information_schema.columns
WHERE table_name = 'schedules'
AND column_name IN (
    'contract_id', 'service_type', 'frequency', 'frequency_interval',
    'next_due_date', 'priority', 'status', 'estimated_duration'
)
ORDER BY column_name;

-- Check indexes were created:
SELECT indexname, indexdef
FROM pg_indexes
WHERE tablename = 'schedules'
AND indexname LIKE 'idx_schedules%';

-- ============================================================
-- ROLLBACK (if needed)
-- ============================================================
-- Uncomment and run this if you need to undo the migration:

-- BEGIN;
-- ALTER TABLE assets DROP COLUMN IF EXISTS service_frequency;
-- ALTER TABLE schedules DROP COLUMN IF EXISTS contract_id;
-- ALTER TABLE schedules DROP COLUMN IF EXISTS service_type;
-- ALTER TABLE schedules DROP COLUMN IF EXISTS frequency;
-- ALTER TABLE schedules DROP COLUMN IF EXISTS frequency_interval;
-- ALTER TABLE schedules DROP COLUMN IF EXISTS next_due_date;
-- ALTER TABLE schedules DROP COLUMN IF EXISTS priority;
-- ALTER TABLE schedules DROP COLUMN IF EXISTS status;
-- ALTER TABLE schedules DROP COLUMN IF EXISTS estimated_duration;
-- DROP INDEX IF EXISTS idx_schedules_next_due_date;
-- DROP INDEX IF EXISTS idx_schedules_status;
-- DROP INDEX IF EXISTS idx_schedules_contract_id;
-- COMMIT;
