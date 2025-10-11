-- Add vault columns to documents table
ALTER TABLE documents
    ADD COLUMN IF NOT EXISTS storage_url TEXT,
    ADD COLUMN IF NOT EXISTS vault_category TEXT,
    ADD COLUMN IF NOT EXISTS vault_subfolder TEXT,
    ADD COLUMN IF NOT EXISTS mime_type TEXT,
    ADD COLUMN IF NOT EXISTS category TEXT,
    ADD COLUMN IF NOT EXISTS status TEXT DEFAULT 'active',
    ADD COLUMN IF NOT EXISTS uploaded_at TIMESTAMPTZ DEFAULT NOW(),
    ADD COLUMN IF NOT EXISTS path TEXT;

-- Make uploaded_by nullable
ALTER TABLE documents ALTER COLUMN uploaded_by DROP NOT NULL;

-- Create indexes for better query performance
CREATE INDEX IF NOT EXISTS idx_documents_vault_category
    ON documents(building_id, vault_category);

CREATE INDEX IF NOT EXISTS idx_documents_status
    ON documents(status) WHERE status = 'active';

-- Create a minimal building record for testing
INSERT INTO buildings (id, name, address)
VALUES (
    'ceec21e6-b91e-4c40-9a57-51994caf3ab7',
    'Connaught Square',
    '219.01 Connaught Square'
)
ON CONFLICT (id) DO NOTHING;

SELECT '✅ Vault schema applied successfully!' as result;
