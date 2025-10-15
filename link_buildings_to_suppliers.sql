-- ============================================================================
-- Link Buildings and Contracts to Suppliers
-- ============================================================================
-- Better approach: Link the actual contractor names (not folder names)
-- 
-- Link these to suppliers:
-- 1. buildings.cleaning_contractor → suppliers
-- 2. buildings.lift_contractor → suppliers
-- 3. buildings.heating_contractor → suppliers
-- 4. maintenance_contracts.contractor_name → suppliers
-- ============================================================================

BEGIN;

-- ============================================================================
-- STEP 1: Add supplier_id to buildings table (for key contractors)
-- ============================================================================

ALTER TABLE buildings 
ADD COLUMN IF NOT EXISTS cleaning_supplier_id UUID REFERENCES suppliers(id),
ADD COLUMN IF NOT EXISTS lift_supplier_id UUID REFERENCES suppliers(id),
ADD COLUMN IF NOT EXISTS heating_supplier_id UUID REFERENCES suppliers(id),
ADD COLUMN IF NOT EXISTS property_manager_supplier_id UUID REFERENCES suppliers(id);

CREATE INDEX IF NOT EXISTS idx_buildings_cleaning_supplier ON buildings(cleaning_supplier_id);
CREATE INDEX IF NOT EXISTS idx_buildings_lift_supplier ON buildings(lift_supplier_id);
CREATE INDEX IF NOT EXISTS idx_buildings_heating_supplier ON buildings(heating_supplier_id);

COMMENT ON COLUMN buildings.cleaning_supplier_id IS 'Link to suppliers table for full cleaning contractor details';
COMMENT ON COLUMN buildings.lift_supplier_id IS 'Link to suppliers table for full lift contractor details';
COMMENT ON COLUMN buildings.heating_supplier_id IS 'Link to suppliers table for full heating contractor details';

-- ============================================================================
-- STEP 2: Add supplier_id to maintenance_contracts table
-- ============================================================================

ALTER TABLE maintenance_contracts 
ADD COLUMN IF NOT EXISTS supplier_id UUID REFERENCES suppliers(id);

CREATE INDEX IF NOT EXISTS idx_maintenance_contracts_supplier ON maintenance_contracts(supplier_id);

COMMENT ON COLUMN maintenance_contracts.supplier_id IS 'Link to suppliers table for contractor details (bank, insurance, etc)';

-- ============================================================================
-- STEP 3: Link existing building contractors by name matching
-- ============================================================================

-- Link cleaning contractors
UPDATE buildings b
SET cleaning_supplier_id = s.id
FROM suppliers s
WHERE b.cleaning_supplier_id IS NULL
  AND b.cleaning_contractor IS NOT NULL
  AND (
      LOWER(s.contractor_name) LIKE '%' || LOWER(b.cleaning_contractor) || '%'
      OR LOWER(b.cleaning_contractor) LIKE '%' || LOWER(s.contractor_name) || '%'
  );

-- Link lift contractors
UPDATE buildings b
SET lift_supplier_id = s.id
FROM suppliers s
WHERE b.lift_supplier_id IS NULL
  AND b.lift_contractor IS NOT NULL
  AND (
      LOWER(s.contractor_name) LIKE '%' || LOWER(b.lift_contractor) || '%'
      OR LOWER(b.lift_contractor) LIKE '%' || LOWER(s.contractor_name) || '%'
  );

-- Link heating contractors (e.g. Quotehedge)
UPDATE buildings b
SET heating_supplier_id = s.id
FROM suppliers s
WHERE b.heating_supplier_id IS NULL
  AND b.heating_contractor IS NOT NULL
  AND (
      LOWER(s.contractor_name) LIKE '%' || LOWER(b.heating_contractor) || '%'
      OR LOWER(b.heating_contractor) LIKE '%' || LOWER(s.contractor_name) || '%'
  );

-- ============================================================================
-- STEP 4: Link maintenance contracts
-- ============================================================================

UPDATE maintenance_contracts mc
SET supplier_id = s.id
FROM suppliers s
WHERE mc.supplier_id IS NULL
  AND mc.contractor_name IS NOT NULL
  AND (
      LOWER(s.contractor_name) LIKE '%' || LOWER(mc.contractor_name) || '%'
      OR LOWER(mc.contractor_name) LIKE '%' || LOWER(s.contractor_name) || '%'
  );

-- ============================================================================
-- STEP 5: Create comprehensive view
-- ============================================================================

CREATE OR REPLACE VIEW vw_building_contractors_full AS
SELECT 
    b.id as building_id,
    b.building_name,
    
    -- Cleaning
    b.cleaning_contractor as cleaning_name,
    cs.contractor_name as cleaning_supplier_full_name,
    cs.email as cleaning_email,
    cs.telephone as cleaning_phone,
    cs.pli_expiry_date as cleaning_pli_expiry,
    
    -- Lift
    b.lift_contractor as lift_name,
    ls.contractor_name as lift_supplier_full_name,
    ls.email as lift_email,
    ls.telephone as lift_phone,
    ls.pli_expiry_date as lift_pli_expiry,
    
    -- Heating
    b.heating_contractor as heating_name,
    hs.contractor_name as heating_supplier_full_name,
    hs.email as heating_email,
    hs.telephone as heating_phone,
    hs.pli_expiry_date as heating_pli_expiry
    
FROM buildings b
LEFT JOIN suppliers cs ON b.cleaning_supplier_id = cs.id
LEFT JOIN suppliers ls ON b.lift_supplier_id = ls.id
LEFT JOIN suppliers hs ON b.heating_supplier_id = hs.id
WHERE b.deleted_at IS NULL;

COMMENT ON VIEW vw_building_contractors_full IS 'Shows all buildings with full supplier details for key contractors (cleaning, lift, heating)';

-- ============================================================================
-- VERIFICATION
-- ============================================================================

-- Show building contractors with supplier links
SELECT 
    building_name,
    cleaning_contractor,
    cleaning_supplier_id IS NOT NULL as cleaning_linked,
    lift_contractor,
    lift_supplier_id IS NOT NULL as lift_linked,
    heating_contractor,
    heating_supplier_id IS NOT NULL as heating_linked
FROM buildings
WHERE building_name LIKE '%Connaught%';

-- Show maintenance contracts with supplier links
SELECT 
    'Maintenance contracts linked' as status,
    COUNT(*) as total,
    COUNT(supplier_id) as linked
FROM maintenance_contracts;

COMMIT;

