-- Create documents table with vault support
CREATE TABLE IF NOT EXISTS documents (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    building_id UUID NOT NULL REFERENCES buildings(id) ON DELETE CASCADE,
    filename TEXT NOT NULL,
    file_type TEXT,
    file_size BIGINT,
    mime_type TEXT,
    document_type TEXT,
    category TEXT,

    -- Vault columns
    storage_url TEXT,
    vault_category TEXT,
    vault_subfolder TEXT,
    path TEXT,
    metadata JSONB,

    -- Extraction fields
    uploaded_by TEXT,
    extraction_status TEXT,
    extracted_text TEXT,

    -- Lease extraction
    lease_extraction JSONB,

    -- Status
    status TEXT NOT NULL DEFAULT 'active',
    uploaded_at TIMESTAMPTZ DEFAULT NOW(),
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Create indexes
CREATE INDEX IF NOT EXISTS idx_documents_building_id
    ON documents(building_id);

CREATE INDEX IF NOT EXISTS idx_documents_category
    ON documents(category);

CREATE INDEX IF NOT EXISTS idx_documents_vault_category
    ON documents(building_id, vault_category);

CREATE INDEX IF NOT EXISTS idx_documents_storage_url
    ON documents(storage_url) WHERE storage_url IS NOT NULL;

CREATE INDEX IF NOT EXISTS idx_documents_status
    ON documents(status);

-- Add unique constraint to prevent duplicate uploads
CREATE UNIQUE INDEX IF NOT EXISTS idx_documents_building_filename
    ON documents(building_id, filename) WHERE status = 'active';

-- Add comments
COMMENT ON TABLE documents IS 'All building documents with vault organization';
COMMENT ON COLUMN documents.storage_url IS 'URL to document in Supabase Storage';
COMMENT ON COLUMN documents.vault_category IS 'Main vault category (e.g., Insurance, Health and Safety)';
COMMENT ON COLUMN documents.vault_subfolder IS 'Subfolder within category (e.g., Certificates, Fire Risk Assessments)';
COMMENT ON COLUMN documents.path IS 'Full storage path: building_id/category/subfolder/filename';

-- Create views for document organization
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
WHERE status = 'active' AND storage_url IS NOT NULL
GROUP BY building_id, vault_category, vault_subfolder
ORDER BY building_id, vault_category, vault_subfolder;

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
WHERE status = 'active' AND storage_url IS NOT NULL
GROUP BY building_id;

COMMENT ON VIEW v_document_categories IS 'Document counts and sizes by category for each building';
COMMENT ON VIEW v_building_document_summary IS 'Overall document statistics per building';
