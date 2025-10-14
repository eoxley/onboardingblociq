-- ============================================================================
-- Fix lease_clauses Table - Ensure All Columns Exist
-- ============================================================================

-- Drop and recreate to ensure correct structure
DROP TABLE IF EXISTS lease_clauses CASCADE;
DROP TABLE IF EXISTS lease_parties CASCADE;
DROP TABLE IF EXISTS lease_financial_terms CASCADE;

-- ----------------------------------------------------------------------------
-- Lease Clauses (Complete Structure)
-- ----------------------------------------------------------------------------
CREATE TABLE lease_clauses (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    lease_id UUID NOT NULL REFERENCES leases(id) ON DELETE CASCADE,
    building_id UUID NOT NULL REFERENCES buildings(id) ON DELETE CASCADE,
    
    -- Clause Identification
    clause_number VARCHAR(20),
    clause_category VARCHAR(50),
    clause_subcategory VARCHAR(100),
    
    -- Clause Content
    clause_text TEXT,
    clause_summary TEXT,
    
    -- Clause Analysis
    key_terms TEXT[],
    obligations TEXT[],
    restrictions TEXT[],
    rights TEXT[],
    
    -- Financial Impact
    has_financial_impact BOOLEAN DEFAULT false,
    estimated_annual_cost NUMERIC(10,2),
    payment_frequency VARCHAR(50),
    
    -- Importance
    importance_level VARCHAR(20),
    affects_compliance BOOLEAN DEFAULT false,
    compliance_category VARCHAR(100),
    
    -- Metadata
    extraction_confidence NUMERIC(3,2),
    requires_legal_review BOOLEAN DEFAULT false,
    notes TEXT,
    
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX idx_lease_clauses_lease ON lease_clauses(lease_id);
CREATE INDEX idx_lease_clauses_building ON lease_clauses(building_id);
CREATE INDEX idx_lease_clauses_category ON lease_clauses(clause_category);
CREATE INDEX idx_lease_clauses_importance ON lease_clauses(importance_level);

-- ----------------------------------------------------------------------------
-- Lease Parties
-- ----------------------------------------------------------------------------
CREATE TABLE lease_parties (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    lease_id UUID NOT NULL REFERENCES leases(id) ON DELETE CASCADE,
    
    lessor_name VARCHAR(255),
    lessor_type VARCHAR(50),
    lessor_address TEXT,
    lessee_name VARCHAR(255),
    lessee_type VARCHAR(50),
    lessee_address TEXT,
    guarantor_name VARCHAR(255),
    management_company VARCHAR(255),
    
    created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX idx_lease_parties_lease ON lease_parties(lease_id);

-- ----------------------------------------------------------------------------
-- Lease Financial Terms
-- ----------------------------------------------------------------------------
CREATE TABLE lease_financial_terms (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    lease_id UUID NOT NULL REFERENCES leases(id) ON DELETE CASCADE,
    
    ground_rent_initial NUMERIC(10,2),
    ground_rent_current NUMERIC(10,2),
    ground_rent_review_period INTEGER,
    ground_rent_review_method VARCHAR(100),
    ground_rent_next_review_date DATE,
    service_charge_method VARCHAR(100),
    service_charge_percentage NUMERIC(5,2),
    service_charge_cap NUMERIC(10,2),
    advance_service_charge BOOLEAN DEFAULT false,
    insurance_method VARCHAR(100),
    insurance_percentage NUMERIC(5,2),
    reserve_fund_contribution NUMERIC(10,2),
    reserve_fund_percentage NUMERIC(5,2),
    apportionment_method VARCHAR(100),
    apportionment_percentage NUMERIC(5,2),
    
    created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX idx_lease_financial_lease ON lease_financial_terms(lease_id);

-- Verify
SELECT 'Lease tables recreated successfully!' as status;
SELECT table_name FROM information_schema.tables 
WHERE table_schema = 'public' 
AND table_name IN ('lease_clauses', 'lease_parties', 'lease_financial_terms');

