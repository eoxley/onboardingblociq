-- ============================================================================
-- Add Comprehensive Lease Extraction Tables (28-Point Analysis)
-- ============================================================================
-- Safe to run: Uses IF NOT EXISTS
-- Purpose: Add lease clause analysis capabilities
-- ============================================================================

-- ----------------------------------------------------------------------------
-- Lease Clauses (Comprehensive Extraction)
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS lease_clauses (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    lease_id UUID NOT NULL REFERENCES leases(id) ON DELETE CASCADE,
    building_id UUID NOT NULL REFERENCES buildings(id) ON DELETE CASCADE,
    
    -- Clause Identification
    clause_number VARCHAR(20), -- e.g., "1.1", "2.3.4", "Schedule A"
    clause_category VARCHAR(50), -- 'rent', 'repair', 'insurance', 'service_charge', 'use', 'alterations', 'assignment', 'forfeiture', 'covenant', 'other'
    clause_subcategory VARCHAR(100),
    
    -- Clause Content
    clause_text TEXT, -- Full clause text
    clause_summary TEXT, -- Brief summary
    
    -- Clause Analysis
    key_terms TEXT[], -- Array of key legal terms
    obligations TEXT[], -- Who must do what
    restrictions TEXT[], -- What is not allowed
    rights TEXT[], -- What is permitted
    
    -- Financial Impact
    has_financial_impact BOOLEAN DEFAULT false,
    estimated_annual_cost NUMERIC(10,2),
    payment_frequency VARCHAR(50),
    
    -- Importance
    importance_level VARCHAR(20), -- 'critical', 'high', 'medium', 'low'
    affects_compliance BOOLEAN DEFAULT false,
    compliance_category VARCHAR(100),
    
    -- Metadata
    extraction_confidence NUMERIC(3,2), -- 0.00 to 1.00
    requires_legal_review BOOLEAN DEFAULT false,
    notes TEXT,
    
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_lease_clauses_lease ON lease_clauses(lease_id);
CREATE INDEX IF NOT EXISTS idx_lease_clauses_building ON lease_clauses(building_id);
CREATE INDEX IF NOT EXISTS idx_lease_clauses_category ON lease_clauses(clause_category);
CREATE INDEX IF NOT EXISTS idx_lease_clauses_importance ON lease_clauses(importance_level);

-- ----------------------------------------------------------------------------
-- Lease Parties (Lessor, Lessee, Guarantors)
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS lease_parties (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    lease_id UUID NOT NULL REFERENCES leases(id) ON DELETE CASCADE,
    
    -- Lessor (Landlord) - Index Point 3
    lessor_name VARCHAR(255),
    lessor_type VARCHAR(50), -- 'individual', 'company', 'trust'
    lessor_address TEXT,
    
    -- Lessee (Tenant) - Index Point 4
    lessee_name VARCHAR(255),
    lessee_type VARCHAR(50),
    lessee_address TEXT,
    
    -- Additional Parties - Index Points 26-27
    guarantor_name VARCHAR(255),
    management_company VARCHAR(255),
    
    created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_lease_parties_lease ON lease_parties(lease_id);

-- ----------------------------------------------------------------------------
-- Lease Financial Terms (Ground Rent, Service Charge, etc.)
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS lease_financial_terms (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    lease_id UUID NOT NULL REFERENCES leases(id) ON DELETE CASCADE,
    
    -- Ground Rent (IP 12)
    ground_rent_initial NUMERIC(10,2),
    ground_rent_current NUMERIC(10,2),
    ground_rent_review_period INTEGER, -- Years
    ground_rent_review_method VARCHAR(100),
    ground_rent_next_review_date DATE,
    
    -- Service Charge (IP 13)
    service_charge_method VARCHAR(100), -- 'fixed', 'percentage', 'on_account'
    service_charge_percentage NUMERIC(5,2),
    service_charge_cap NUMERIC(10,2),
    advance_service_charge BOOLEAN DEFAULT false,
    
    -- Insurance (IP 14)
    insurance_method VARCHAR(100), -- 'paid_by_landlord', 'on_demand', 'percentage'
    insurance_percentage NUMERIC(5,2),
    
    -- Reserve Fund (IP 21)
    reserve_fund_contribution NUMERIC(10,2),
    reserve_fund_percentage NUMERIC(5,2),
    
    -- Apportionment (IP 22-23)
    apportionment_method VARCHAR(100), -- 'floor_area', 'fixed_percentage', 'rateable_value'
    apportionment_percentage NUMERIC(5,2),
    
    created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_lease_financial_lease ON lease_financial_terms(lease_id);

-- ============================================================================
-- Verification Query
-- ============================================================================
SELECT 'Lease extraction tables added successfully!' as message;

SELECT table_name, 
       (SELECT COUNT(*) FROM information_schema.columns WHERE table_name = t.table_name) as column_count
FROM information_schema.tables t
WHERE table_schema = 'public' 
AND table_name IN ('lease_clauses', 'lease_parties', 'lease_financial_terms')
ORDER BY table_name;

-- Expected: 3 tables with columns
-- lease_clauses: 20+ columns
-- lease_parties: 9 columns  
-- lease_financial_terms: 14 columns

