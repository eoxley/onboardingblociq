-- Migration: Update compliance_assets table to BlocIQ V2 minimal schema
-- WARNING: This will drop old columns and data. Backup first!

-- Drop old columns that are no longer in V2 schema
ALTER TABLE compliance_assets
    DROP COLUMN IF EXISTS user_id,
    DROP COLUMN IF EXISTS category,
    DROP COLUMN IF EXISTS is_required,
    DROP COLUMN IF EXISTS is_active,
    DROP COLUMN IF EXISTS status,
    DROP COLUMN IF EXISTS last_inspection_date,
    DROP COLUMN IF EXISTS next_due_date,
    DROP COLUMN IF EXISTS certificate_expiry,
    DROP COLUMN IF EXISTS inspector_name,
    DROP COLUMN IF EXISTS inspector_company,
    DROP COLUMN IF EXISTS inspector_contact,
    DROP COLUMN IF EXISTS certificate_url,
    DROP COLUMN IF EXISTS notes,
    DROP COLUMN IF EXISTS compliance_reference,
    DROP COLUMN IF EXISTS custom_asset,
    DROP COLUMN IF EXISTS frequency_months,
    DROP COLUMN IF EXISTS created_at,
    DROP COLUMN IF EXISTS updated_at;

-- Ensure V2 columns exist with correct types
-- Add building_id if it doesn't exist (with NOT NULL constraint)
DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns
                   WHERE table_name = 'compliance_assets' AND column_name = 'building_id') THEN
        ALTER TABLE compliance_assets
            ADD COLUMN building_id UUID NOT NULL REFERENCES buildings(id) ON DELETE CASCADE;
    ELSE
        -- Make building_id NOT NULL if it exists but is nullable
        ALTER TABLE compliance_assets
            ALTER COLUMN building_id SET NOT NULL;
    END IF;
END $$;

-- Add asset_name if it doesn't exist
DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns
                   WHERE table_name = 'compliance_assets' AND column_name = 'asset_name') THEN
        ALTER TABLE compliance_assets
            ADD COLUMN asset_name TEXT NOT NULL;
    END IF;
END $$;

-- Add asset_type if it doesn't exist
DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns
                   WHERE table_name = 'compliance_assets' AND column_name = 'asset_type') THEN
        ALTER TABLE compliance_assets
            ADD COLUMN asset_type TEXT NOT NULL;
    END IF;
END $$;

-- Change inspection_frequency from VARCHAR to INTERVAL
DO $$
BEGIN
    -- Drop and recreate with INTERVAL type
    IF EXISTS (SELECT 1 FROM information_schema.columns
               WHERE table_name = 'compliance_assets' AND column_name = 'inspection_frequency') THEN
        ALTER TABLE compliance_assets
            DROP COLUMN inspection_frequency;
    END IF;

    ALTER TABLE compliance_assets
        ADD COLUMN inspection_frequency INTERVAL;
END $$;

-- Add description if it doesn't exist
DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns
                   WHERE table_name = 'compliance_assets' AND column_name = 'description') THEN
        ALTER TABLE compliance_assets
            ADD COLUMN description TEXT;
    END IF;
END $$;

-- Create indexes for performance
CREATE INDEX IF NOT EXISTS idx_compliance_assets_building_id ON compliance_assets(building_id);
CREATE INDEX IF NOT EXISTS idx_compliance_assets_type ON compliance_assets(asset_type);

-- Verify final schema
SELECT column_name, data_type, is_nullable
FROM information_schema.columns
WHERE table_name = 'compliance_assets'
ORDER BY ordinal_position;
