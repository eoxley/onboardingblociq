-- ============================================================================
-- Add Contractor Fields to Buildings Table
-- ============================================================================
-- These fields store the names of key service providers for the building
-- Extracted from contracts/budget documents and used in PDF reports
-- ============================================================================

BEGIN;

-- Add contractor name fields to buildings table
ALTER TABLE buildings 
ADD COLUMN IF NOT EXISTS cleaning_contractor VARCHAR(255),
ADD COLUMN IF NOT EXISTS lift_contractor VARCHAR(255),
ADD COLUMN IF NOT EXISTS property_manager VARCHAR(255),
ADD COLUMN IF NOT EXISTS heating_contractor VARCHAR(255),
ADD COLUMN IF NOT EXISTS gardening_contractor VARCHAR(255);

-- Add comments
COMMENT ON COLUMN buildings.cleaning_contractor IS 'Name of cleaning contractor (e.g. New Step)';
COMMENT ON COLUMN buildings.lift_contractor IS 'Name of lift maintenance contractor (e.g. Jacksons Lift)';
COMMENT ON COLUMN buildings.property_manager IS 'Name of property manager/managing agent';
COMMENT ON COLUMN buildings.heating_contractor IS 'Name of heating/boiler contractor (e.g. Quotehedge)';
COMMENT ON COLUMN buildings.gardening_contractor IS 'Name of gardening/grounds maintenance contractor';

COMMIT;

-- ============================================================================
-- Verification
-- ============================================================================
SELECT 
    column_name,
    data_type,
    is_nullable
FROM information_schema.columns 
WHERE table_name = 'buildings'
AND column_name IN ('cleaning_contractor', 'lift_contractor', 'property_manager', 'heating_contractor', 'gardening_contractor')
ORDER BY ordinal_position;

