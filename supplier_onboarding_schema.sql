-- ============================================================================
-- Supplier Onboarding System - Supabase Schema
-- ============================================================================
-- Purpose: Onboard suppliers/contractors with financial and compliance documentation
-- Storage: supplier_documents bucket in Supabase Storage
-- Note: Uses "suppliers" to avoid conflict with existing "contractors" table
-- ============================================================================

BEGIN;

-- ============================================================================
-- SUPPLIERS ONBOARDING TABLE (Main supplier data)
-- ============================================================================

CREATE TABLE IF NOT EXISTS suppliers (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    
    -- ========================================================================
    -- CONTRACTOR DETAILS
    -- ========================================================================
    
    -- Basic Information
    contractor_name VARCHAR(255) NOT NULL,
    trading_name VARCHAR(255),
    company_number VARCHAR(50), -- Companies House number
    
    -- Contact Details
    address TEXT,
    address_line_1 VARCHAR(255),
    address_line_2 VARCHAR(255),
    city VARCHAR(100),
    postcode VARCHAR(20),
    country VARCHAR(100) DEFAULT 'United Kingdom',
    
    email VARCHAR(255),
    telephone VARCHAR(50),
    mobile VARCHAR(50),
    website VARCHAR(255),
    
    -- Contact Person
    contact_person_name VARCHAR(255),
    contact_person_role VARCHAR(100),
    contact_person_email VARCHAR(255),
    contact_person_phone VARCHAR(50),
    
    -- ========================================================================
    -- SERVICES PROVIDED
    -- ========================================================================
    
    services_provided TEXT[], -- Array: ['Cleaning', 'Lift Maintenance', 'Electrical']
    service_categories TEXT[], -- Array: ['Building Services', 'Fire Safety', 'Facilities']
    specializations TEXT,
    years_in_business INTEGER,
    
    -- ========================================================================
    -- BANKING DETAILS
    -- ========================================================================
    
    bank_account_name VARCHAR(255),
    bank_name VARCHAR(255),
    bank_sort_code VARCHAR(20), -- Format: XX-XX-XX
    bank_account_number VARCHAR(20), -- Encrypted or last 4 digits only
    bank_iban VARCHAR(50),
    
    -- ========================================================================
    -- COMPLIANCE & INSURANCE
    -- ========================================================================
    
    -- Public Liability Insurance
    pli_insurer VARCHAR(255),
    pli_policy_number VARCHAR(100),
    pli_coverage_amount NUMERIC(15,2), -- e.g. £5,000,000
    pli_expiry_date DATE,
    pli_status VARCHAR(50), -- 'current', 'expired', 'pending'
    days_until_pli_expiry INTEGER,
    
    -- Employers Liability Insurance (if applicable)
    eli_insurer VARCHAR(255),
    eli_policy_number VARCHAR(100),
    eli_coverage_amount NUMERIC(15,2),
    eli_expiry_date DATE,
    
    -- Professional Indemnity (if applicable)
    pi_insurer VARCHAR(255),
    pi_coverage_amount NUMERIC(15,2),
    pi_expiry_date DATE,
    
    -- ========================================================================
    -- DOCUMENTATION STATUS
    -- ========================================================================
    
    has_audited_accounts BOOLEAN DEFAULT false,
    audited_accounts_year INTEGER, -- e.g. 2024
    audited_accounts_date DATE,
    
    has_certificate_of_incorporation BOOLEAN DEFAULT false,
    certificate_date DATE,
    
    has_vat_certificate BOOLEAN DEFAULT false,
    vat_number VARCHAR(50),
    
    has_health_safety_policy BOOLEAN DEFAULT false,
    has_environmental_policy BOOLEAN DEFAULT false,
    has_quality_assurance_cert BOOLEAN DEFAULT false, -- ISO 9001, etc.
    
    -- ========================================================================
    -- CERTIFICATIONS & ACCREDITATIONS
    -- ========================================================================
    
    certifications TEXT[], -- ['Gas Safe', 'NICEIC', 'CHAS', 'Safe Contractor']
    accreditations TEXT[], -- ['ISO 9001', 'ISO 14001', 'ISO 45001']
    trade_associations TEXT[], -- ['FMB', 'CIBSE', 'BESA']
    
    -- ========================================================================
    -- ONBOARDING STATUS
    -- ========================================================================
    
    onboarding_status VARCHAR(50) DEFAULT 'pending', -- 'pending', 'in_progress', 'approved', 'rejected', 'incomplete'
    onboarding_stage VARCHAR(100), -- 'documents_received', 'under_review', 'compliance_check', 'approved'
    approved_by VARCHAR(255),
    approved_date DATE,
    rejection_reason TEXT,
    
    -- ========================================================================
    -- DOCUMENT REFERENCES (Supabase Storage)
    -- ========================================================================
    
    -- Storage bucket: contractor_documents
    pli_certificate_path TEXT,
    audited_accounts_path TEXT,
    certificate_of_incorporation_path TEXT,
    vat_certificate_path TEXT,
    bank_details_path TEXT,
    health_safety_policy_path TEXT,
    additional_documents_paths TEXT[], -- Array of paths
    
    -- Document metadata
    total_documents_uploaded INTEGER DEFAULT 0,
    documents_storage_folder TEXT, -- e.g. contractor_documents/<contractor_id>/
    
    -- ========================================================================
    -- RATINGS & PERFORMANCE
    -- ========================================================================
    
    rating NUMERIC(2,1), -- 1.0 to 5.0
    num_reviews INTEGER DEFAULT 0,
    is_preferred_contractor BOOLEAN DEFAULT false,
    is_approved_contractor BOOLEAN DEFAULT false,
    
    -- Performance tracking
    contracts_completed INTEGER DEFAULT 0,
    average_response_time_hours INTEGER,
    on_time_completion_rate NUMERIC(5,2), -- Percentage
    
    -- ========================================================================
    -- FINANCIAL TERMS
    -- ========================================================================
    
    payment_terms VARCHAR(50), -- '30 days', 'Net 30', '7 days', etc.
    currency VARCHAR(3) DEFAULT 'GBP',
    vat_registered BOOLEAN DEFAULT false,
    vat_rate NUMERIC(5,2) DEFAULT 20.00,
    
    -- ========================================================================
    -- NOTES & METADATA
    -- ========================================================================
    
    notes TEXT,
    internal_notes TEXT, -- Private notes for staff only
    
    source_document VARCHAR(500), -- Original Excel/PDF/Word file
    extraction_method VARCHAR(50), -- 'excel', 'pdf_ocr', 'word', 'manual'
    extraction_confidence NUMERIC(3,2),
    
    -- ========================================================================
    -- AUDIT TRAIL
    -- ========================================================================
    
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW(),
    created_by UUID, -- User who created this record
    last_reviewed_date DATE,
    next_review_date DATE,
    
    deleted_at TIMESTAMPTZ
);

-- ============================================================================
-- INDEXES
-- ============================================================================

CREATE INDEX idx_suppliers_name ON suppliers(contractor_name);
CREATE INDEX idx_suppliers_postcode ON suppliers(postcode);
CREATE INDEX idx_suppliers_status ON suppliers(onboarding_status);
CREATE INDEX idx_suppliers_pli_expiry ON suppliers(pli_expiry_date);
CREATE INDEX idx_suppliers_approved ON suppliers(is_approved_contractor) WHERE is_approved_contractor = true;
CREATE INDEX idx_suppliers_services ON suppliers USING gin(services_provided);
CREATE INDEX idx_suppliers_deleted ON suppliers(deleted_at) WHERE deleted_at IS NULL;

-- ============================================================================
-- SUPPLIER DOCUMENTS (Detailed document tracking)
-- ============================================================================

CREATE TABLE IF NOT EXISTS supplier_documents (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    supplier_id UUID REFERENCES suppliers(id) ON DELETE CASCADE,
    
    -- Document Details
    document_type VARCHAR(100), -- 'PLI Certificate', 'Audited Accounts', 'Certificate of Incorporation', 'Bank Details', 'Other'
    document_name VARCHAR(500),
    document_description TEXT,
    
    -- File Details
    file_name VARCHAR(500),
    file_size_bytes BIGINT,
    file_extension VARCHAR(10),
    mime_type VARCHAR(100),
    
    -- Supabase Storage
    storage_bucket VARCHAR(100) DEFAULT 'supplier_documents',
    storage_path TEXT, -- e.g. supplier_documents/<supplier_id>/pli_certificate.pdf
    storage_url TEXT, -- Signed URL from Supabase Storage
    
    -- Dates
    document_date DATE,
    expiry_date DATE, -- For certificates/insurance
    upload_date TIMESTAMPTZ DEFAULT NOW(),
    
    -- Status
    document_status VARCHAR(50), -- 'pending_review', 'approved', 'rejected', 'expired'
    is_verified BOOLEAN DEFAULT false,
    verified_by VARCHAR(255),
    verified_date TIMESTAMPTZ,
    
    -- Extraction
    extracted_data JSONB, -- Store any extracted fields for reference
    extraction_confidence NUMERIC(3,2),
    
    -- Metadata
    notes TEXT,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX idx_supplier_docs_supplier ON supplier_documents(supplier_id);
CREATE INDEX idx_supplier_docs_type ON supplier_documents(document_type);
CREATE INDEX idx_supplier_docs_expiry ON supplier_documents(expiry_date);
CREATE INDEX idx_supplier_docs_status ON supplier_documents(document_status);

-- ============================================================================
-- TRIGGERS
-- ============================================================================

-- Auto-update updated_at timestamp
CREATE TRIGGER update_suppliers_updated_at 
    BEFORE UPDATE ON suppliers
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_supplier_docs_updated_at 
    BEFORE UPDATE ON supplier_documents
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- Auto-calculate days until PLI expiry
CREATE OR REPLACE FUNCTION calculate_pli_days_until_expiry()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.pli_expiry_date IS NOT NULL THEN
        NEW.days_until_pli_expiry := NEW.pli_expiry_date - CURRENT_DATE;
        
        -- Update status based on expiry
        IF NEW.pli_expiry_date < CURRENT_DATE THEN
            NEW.pli_status := 'expired';
        ELSIF NEW.pli_expiry_date <= CURRENT_DATE + INTERVAL '30 days' THEN
            NEW.pli_status := 'expiring_soon';
        ELSE
            NEW.pli_status := 'current';
        END IF;
    END IF;
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_calculate_pli_expiry 
    BEFORE INSERT OR UPDATE OF pli_expiry_date ON suppliers
    FOR EACH ROW EXECUTE FUNCTION calculate_pli_days_until_expiry();

-- ============================================================================
-- VIEWS
-- ============================================================================

-- View: Suppliers needing document renewals
CREATE OR REPLACE VIEW vw_suppliers_documents_expiring AS
SELECT 
    s.id,
    s.contractor_name,
    s.email,
    s.telephone,
    s.pli_expiry_date,
    s.days_until_pli_expiry,
    s.pli_status,
    s.onboarding_status,
    s.is_approved_contractor,
    s.services_provided
FROM suppliers s
WHERE s.deleted_at IS NULL
    AND (
        s.pli_expiry_date <= CURRENT_DATE + INTERVAL '60 days'
        OR s.onboarding_status = 'incomplete'
    )
ORDER BY s.pli_expiry_date ASC;

-- View: Approved suppliers directory
CREATE OR REPLACE VIEW vw_approved_suppliers AS
SELECT 
    s.id,
    s.contractor_name,
    s.services_provided,
    s.email,
    s.telephone,
    s.postcode,
    s.rating,
    s.pli_expiry_date,
    s.is_preferred_contractor,
    s.contracts_completed,
    s.on_time_completion_rate
FROM suppliers s
WHERE s.is_approved_contractor = true
    AND s.deleted_at IS NULL
    AND s.pli_status IN ('current', 'expiring_soon')
ORDER BY s.rating DESC NULLS LAST, s.contractor_name;

-- ============================================================================
-- ROW LEVEL SECURITY
-- ============================================================================

ALTER TABLE suppliers ENABLE ROW LEVEL SECURITY;
ALTER TABLE supplier_documents ENABLE ROW LEVEL SECURITY;

-- Policy: Authenticated users can view all suppliers
CREATE POLICY "Authenticated users can view suppliers" ON suppliers
    FOR SELECT USING (auth.role() = 'authenticated');

-- Policy: Only admins can insert/update suppliers
CREATE POLICY "Admins can manage suppliers" ON suppliers
    FOR ALL USING (
        EXISTS (
            SELECT 1 FROM users 
            WHERE auth_user_id = auth.uid() 
            AND role IN ('admin', 'manager')
        )
    );

-- ============================================================================
-- COMMENTS
-- ============================================================================

COMMENT ON TABLE suppliers IS 'Supplier/contractor onboarding with financial and compliance documentation tracking. Separate from contractors table used in building onboarding.';
COMMENT ON TABLE supplier_documents IS 'Document registry for supplier onboarding (linked to supplier_documents storage bucket)';

COMMENT ON COLUMN suppliers.services_provided IS 'Array of services offered by supplier';
COMMENT ON COLUMN suppliers.pli_expiry_date IS 'Public Liability Insurance expiry date - critical for compliance';
COMMENT ON COLUMN suppliers.has_audited_accounts IS 'Whether supplier has provided audited accounts';
COMMENT ON COLUMN suppliers.has_certificate_of_incorporation IS 'Whether supplier has provided certificate of incorporation';
COMMENT ON COLUMN suppliers.onboarding_status IS 'Current stage in onboarding process';

COMMIT;

-- ============================================================================
-- VERIFICATION
-- ============================================================================

SELECT 'Supplier onboarding schema created successfully!' as status;

SELECT table_name, column_name, data_type
FROM information_schema.columns 
WHERE table_name IN ('suppliers', 'supplier_documents')
ORDER BY table_name, ordinal_position;

