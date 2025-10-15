-- ============================================================================
-- Link Contractors to Suppliers
-- ============================================================================
-- Purpose: Connect building-specific contractors to the master suppliers table
-- 
-- contractors table: Created during building onboarding (e.g. "New Step" for Connaught)
-- suppliers table: Master supplier directory with bank details, PLI, etc.
--
-- This allows getting full supplier details (email, bank, insurance) for 
-- contractors working at a building
-- ============================================================================

BEGIN;

-- ============================================================================
-- STEP 1: Add supplier_id to contractors table
-- ============================================================================

ALTER TABLE contractors 
ADD COLUMN IF NOT EXISTS supplier_id UUID REFERENCES suppliers(id);

-- Add index for performance
CREATE INDEX IF NOT EXISTS idx_contractors_supplier ON contractors(supplier_id);

COMMENT ON COLUMN contractors.supplier_id IS 'Link to master suppliers table for full supplier details (bank, insurance, etc)';

-- ============================================================================
-- STEP 2: Create matching function
-- ============================================================================

CREATE OR REPLACE FUNCTION match_contractor_to_supplier(contractor_name_input TEXT)
RETURNS UUID AS $$
DECLARE
    supplier_uuid UUID;
    clean_name TEXT;
BEGIN
    -- Clean the input name
    clean_name := LOWER(TRIM(contractor_name_input));
    
    -- Try exact match first
    SELECT id INTO supplier_uuid
    FROM suppliers
    WHERE LOWER(TRIM(contractor_name)) = clean_name
    LIMIT 1;
    
    IF supplier_uuid IS NOT NULL THEN
        RETURN supplier_uuid;
    END IF;
    
    -- Try partial match (supplier name contains contractor name or vice versa)
    SELECT id INTO supplier_uuid
    FROM suppliers
    WHERE LOWER(contractor_name) LIKE '%' || clean_name || '%'
       OR clean_name LIKE '%' || LOWER(contractor_name) || '%'
    ORDER BY LENGTH(contractor_name)  -- Prefer shorter (more specific) matches
    LIMIT 1;
    
    RETURN supplier_uuid;
END;
$$ LANGUAGE plpgsql;

-- ============================================================================
-- STEP 3: Auto-link existing contractors
-- ============================================================================

-- Link contractors by matching names
UPDATE contractors c
SET supplier_id = match_contractor_to_supplier(c.company_name)
WHERE c.supplier_id IS NULL
  AND c.company_name IS NOT NULL;

-- ============================================================================
-- STEP 4: Create view for contractors with supplier details
-- ============================================================================

CREATE OR REPLACE VIEW vw_contractors_with_suppliers AS
SELECT 
    c.id as contractor_id,
    c.company_name as contractor_company_name,
    c.services_offered as contractor_services,
    c.is_active as contractor_is_active,
    
    -- Supplier details
    s.id as supplier_id,
    s.contractor_name as supplier_full_name,
    s.email as supplier_email,
    s.telephone as supplier_phone,
    s.mobile as supplier_mobile,
    s.address as supplier_address,
    s.postcode as supplier_postcode,
    s.bank_account_name,
    s.bank_sort_code,
    s.pli_expiry_date,
    s.pli_status,
    s.days_until_pli_expiry,
    s.has_audited_accounts,
    s.has_certificate_of_incorporation,
    s.onboarding_status,
    s.is_approved_contractor as supplier_is_approved
    
FROM contractors c
LEFT JOIN suppliers s ON c.supplier_id = s.id;

COMMENT ON VIEW vw_contractors_with_suppliers IS 'Combines building-specific contractors with master supplier details for full information';

-- ============================================================================
-- STEP 5: Verification
-- ============================================================================

-- Show contractors that were linked
SELECT 
    'Linked contractors' as status,
    COUNT(*) as total_contractors,
    COUNT(supplier_id) as linked_to_suppliers,
    COUNT(*) - COUNT(supplier_id) as unlinked
FROM contractors;

-- Show sample matches
SELECT 
    c.company_name as contractor_name,
    s.contractor_name as matched_supplier_name,
    s.email,
    s.postcode
FROM contractors c
LEFT JOIN suppliers s ON c.supplier_id = s.id
LIMIT 10;

COMMIT;

-- ============================================================================
-- USAGE EXAMPLES
-- ============================================================================

-- Get full supplier details for a building's contractors:
-- SELECT * FROM vw_contractors_with_suppliers;

-- Get all contractors with their PLI status:
-- SELECT contractor_company_name, pli_expiry_date, pli_status, supplier_email
-- FROM vw_contractors_with_suppliers
-- WHERE pli_expiry_date IS NOT NULL;

-- Find contractors with expiring PLI:
-- SELECT contractor_company_name, pli_expiry_date, days_until_pli_expiry, supplier_email
-- FROM vw_contractors_with_suppliers
-- WHERE days_until_pli_expiry < 60;

