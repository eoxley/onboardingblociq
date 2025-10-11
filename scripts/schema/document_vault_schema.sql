-- Document Vault Schema Extension
-- Adds columns and structure to support organized document storage in Supabase

-- ========================================================================
-- 1. EXTEND DOCUMENTS TABLE FOR VAULT SUPPORT
-- ========================================================================

-- Add vault-specific columns to documents table
ALTER TABLE IF EXISTS documents ADD COLUMN IF NOT EXISTS storage_url TEXT;
ALTER TABLE IF EXISTS documents ADD COLUMN IF NOT EXISTS file_size BIGINT;
ALTER TABLE IF EXISTS documents ADD COLUMN IF NOT EXISTS mime_type TEXT;
ALTER TABLE IF EXISTS documents ADD COLUMN IF NOT EXISTS uploaded_at TIMESTAMPTZ DEFAULT NOW();
ALTER TABLE IF EXISTS documents ADD COLUMN IF NOT EXISTS vault_category TEXT;
ALTER TABLE IF EXISTS documents ADD COLUMN IF NOT EXISTS vault_subfolder TEXT;
ALTER TABLE IF EXISTS documents ADD COLUMN IF NOT EXISTS metadata JSONB;

-- Add index for vault queries
CREATE INDEX IF NOT EXISTS idx_documents_vault_category
    ON documents(building_id, vault_category);

CREATE INDEX IF NOT EXISTS idx_documents_storage_url
    ON documents(storage_url) WHERE storage_url IS NOT NULL;

-- ========================================================================
-- 2. CREATE DOCUMENT CATEGORIES VIEW
-- ========================================================================

CREATE OR REPLACE VIEW v_document_categories AS
SELECT
    building_id,
    vault_category,
    vault_subfolder,
    COUNT(*) as document_count,
    SUM(file_size) as total_size_bytes,
    ROUND(SUM(file_size)::NUMERIC / 1024 / 1024, 2) as total_size_mb,
    MAX(uploaded_at) as last_uploaded
FROM documents
WHERE status = 'active'
  AND storage_url IS NOT NULL
GROUP BY building_id, vault_category, vault_subfolder
ORDER BY building_id, vault_category, vault_subfolder;

-- ========================================================================
-- 3. CREATE BUILDING DOCUMENT SUMMARY VIEW
-- ========================================================================

CREATE OR REPLACE VIEW v_building_document_summary AS
SELECT
    building_id,
    COUNT(*) as total_documents,
    COUNT(DISTINCT vault_category) as category_count,
    SUM(file_size) as total_size_bytes,
    ROUND(SUM(file_size)::NUMERIC / 1024 / 1024, 2) as total_size_mb,
    MIN(uploaded_at) as first_upload,
    MAX(uploaded_at) as last_upload
FROM documents
WHERE status = 'active'
  AND storage_url IS NOT NULL
GROUP BY building_id;

-- ========================================================================
-- 4. CREATE DOCUMENT ACCESS LOG TABLE (OPTIONAL)
-- ========================================================================

CREATE TABLE IF NOT EXISTS document_access_log (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    document_id UUID REFERENCES documents(id) ON DELETE CASCADE,
    building_id UUID REFERENCES buildings(id) ON DELETE CASCADE,
    accessed_by TEXT,
    accessed_at TIMESTAMPTZ DEFAULT NOW(),
    access_type TEXT, -- 'view', 'download', 'share'
    ip_address TEXT,
    user_agent TEXT
);

CREATE INDEX IF NOT EXISTS idx_doc_access_log_document
    ON document_access_log(document_id, accessed_at DESC);

CREATE INDEX IF NOT EXISTS idx_doc_access_log_building
    ON document_access_log(building_id, accessed_at DESC);

-- ========================================================================
-- 5. UPDATE EXISTING DOCUMENTS WITH VAULT INFO
-- ========================================================================

-- Set vault_category based on existing category field
UPDATE documents SET vault_category =
    CASE
        -- Insurance
        WHEN category ILIKE '%insurance%' THEN 'Insurance'
        WHEN category ILIKE '%policy%' THEN 'Insurance'

        -- Health & Safety / Compliance
        WHEN category ILIKE '%fire%risk%' OR category = 'FRA' THEN 'Health and Safety'
        WHEN category ILIKE '%emergency%light%' OR category = 'EL' THEN 'Health and Safety'
        WHEN category = 'EICR' OR category ILIKE '%electrical%' THEN 'Health and Safety'
        WHEN category ILIKE '%fire%door%' THEN 'Health and Safety'
        WHEN category = 'LOLER' THEN 'Health and Safety'
        WHEN category ILIKE '%legionella%' THEN 'Health and Safety'
        WHEN category ILIKE '%gas%' THEN 'Health and Safety'
        WHEN category ILIKE '%lightning%' OR category = 'LPS' THEN 'Health and Safety'
        WHEN category ILIKE '%asbestos%' THEN 'Health and Safety'
        WHEN category ILIKE '%compliance%' THEN 'Health and Safety'

        -- Leases
        WHEN category ILIKE '%lease%' THEN 'Leases'

        -- Finance
        WHEN category ILIKE '%budget%' THEN 'Finance'
        WHEN category ILIKE '%account%' THEN 'Finance'
        WHEN category ILIKE '%invoice%' THEN 'Finance'
        WHEN category ILIKE '%audit%' THEN 'Finance'

        -- Major Works
        WHEN category ILIKE '%section%20%' OR category ILIKE '%s20%' THEN 'Major Works'
        WHEN category ILIKE '%major%work%' THEN 'Major Works'

        -- Contracts
        WHEN category ILIKE '%contract%' THEN 'Contracts'

        -- Correspondence
        WHEN category ILIKE '%correspondence%' THEN 'General Correspondence'
        WHEN category ILIKE '%email%' THEN 'General Correspondence'
        WHEN category ILIKE '%letter%' THEN 'General Correspondence'

        -- Leaseholder
        WHEN category ILIKE '%leaseholder%' THEN 'Leaseholder Correspondence'

        -- Plans
        WHEN category ILIKE '%drawing%' OR category ILIKE '%plan%' THEN 'Building Drawings and Plans'

        -- Default
        ELSE 'General Correspondence'
    END
WHERE vault_category IS NULL;

-- Set vault_subfolder based on category
UPDATE documents SET vault_subfolder =
    CASE
        -- Insurance subfolders
        WHEN vault_category = 'Insurance' AND category ILIKE '%certificate%' THEN 'Certificates'
        WHEN vault_category = 'Insurance' AND category ILIKE '%wording%' THEN 'Policy Wordings'
        WHEN vault_category = 'Insurance' AND category ILIKE '%claim%' THEN 'Claims'
        WHEN vault_category = 'Insurance' THEN 'Current Policies'

        -- Health & Safety subfolders
        WHEN vault_category = 'Health and Safety' AND (category ILIKE '%fire%risk%' OR category = 'FRA') THEN 'Fire Risk Assessments'
        WHEN vault_category = 'Health and Safety' AND (category ILIKE '%emergency%light%' OR category = 'EL') THEN 'Emergency Lighting'
        WHEN vault_category = 'Health and Safety' AND category = 'EICR' THEN 'EICR'
        WHEN vault_category = 'Health and Safety' AND category ILIKE '%fire%door%' THEN 'Fire Door Inspections'
        WHEN vault_category = 'Health and Safety' AND category = 'LOLER' THEN 'LOLER'
        WHEN vault_category = 'Health and Safety' AND category ILIKE '%legionella%' THEN 'Legionella'
        WHEN vault_category = 'Health and Safety' AND category ILIKE '%gas%' THEN 'Gas Safety'
        WHEN vault_category = 'Health and Safety' AND (category ILIKE '%lightning%' OR category = 'LPS') THEN 'Lightning Protection'
        WHEN vault_category = 'Health and Safety' AND category ILIKE '%asbestos%' THEN 'Asbestos Surveys'
        WHEN vault_category = 'Health and Safety' THEN 'Other Compliance'

        -- Leases subfolders
        WHEN vault_category = 'Leases' AND category ILIKE '%extension%' THEN 'Lease Extensions'
        WHEN vault_category = 'Leases' AND category ILIKE '%variation%' THEN 'Variations'
        WHEN vault_category = 'Leases' THEN 'Original Leases'

        -- Finance subfolders
        WHEN vault_category = 'Finance' AND category ILIKE '%budget%' THEN 'Budgets'
        WHEN vault_category = 'Finance' AND category ILIKE '%year%end%' THEN 'Year End Accounts'
        WHEN vault_category = 'Finance' AND category ILIKE '%account%' THEN 'Service Charge Accounts'
        WHEN vault_category = 'Finance' AND category ILIKE '%invoice%' THEN 'Invoices'
        WHEN vault_category = 'Finance' AND category ILIKE '%audit%' THEN 'Audit Reports'
        WHEN vault_category = 'Finance' THEN 'General Admin'

        -- Default subfolders for other categories
        WHEN vault_category = 'Major Works' THEN 'Section 20 Notices'
        WHEN vault_category = 'Contracts' THEN 'Other Contracts'
        WHEN vault_category = 'General Correspondence' THEN 'Letters'
        WHEN vault_category = 'Leaseholder Correspondence' THEN 'General Enquiries'
        WHEN vault_category = 'Building Drawings and Plans' THEN 'Architectural'

        ELSE 'General Admin'
    END
WHERE vault_subfolder IS NULL;

-- ========================================================================
-- COMMENTS
-- ========================================================================

COMMENT ON COLUMN documents.storage_url IS 'URL to document in Supabase Storage';
COMMENT ON COLUMN documents.vault_category IS 'Main vault category (e.g., Insurance, Health and Safety)';
COMMENT ON COLUMN documents.vault_subfolder IS 'Subfolder within category (e.g., Certificates, Fire Risk Assessments)';
COMMENT ON COLUMN documents.file_size IS 'File size in bytes';
COMMENT ON COLUMN documents.mime_type IS 'MIME type (e.g., application/pdf, image/jpeg)';
COMMENT ON COLUMN documents.metadata IS 'Additional JSON metadata';

COMMENT ON VIEW v_document_categories IS 'Document counts and sizes by category for each building';
COMMENT ON VIEW v_building_document_summary IS 'Overall document statistics per building';
COMMENT ON TABLE document_access_log IS 'Tracks document access for audit purposes';

-- ========================================================================
-- DONE
-- ========================================================================

\echo '✅ Document Vault schema extension completed'
\echo '   - Extended documents table with vault columns'
\echo '   - Created document category views'
\echo '   - Created access logging table'
\echo '   - Migrated existing documents to vault structure'
