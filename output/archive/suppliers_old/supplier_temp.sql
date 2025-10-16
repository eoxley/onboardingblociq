-- ============================================================================
-- Supplier Onboarding: Architects Limited
-- ============================================================================
-- Generated: 2025-10-15 12:08:44
-- Supplier ID: 9bd92228-8efd-4baa-bfaa-82eafcd85454
-- Storage: supplier_documents/9bd92228-8efd-4baa-bfaa-82eafcd85454/
-- ============================================================================

BEGIN;


-- ============================================================================
-- Supplier Onboarding Record
-- ============================================================================

INSERT INTO suppliers (
    id,
    contractor_name,
    address,
    postcode,
    email,
    telephone,
    services_provided,
    bank_account_name,
    bank_sort_code,
    pli_expiry_date,
    has_audited_accounts,
    has_certificate_of_incorporation,
    source_document,
    extraction_method,
    extraction_confidence,
    onboarding_status,
    total_documents_uploaded,
    documents_storage_folder
)
VALUES (
    '9bd92228-8efd-4baa-bfaa-82eafcd85454',
    'Architects Limited',
    NULL,
    'E1 5JL',
    'Claire.dupont@1050architects.com',
    '0787 081 0058',
    ARRAY['Cleaning', 'Electrical', 'Plumbing', 'Heating', 'Cctv', 'Security', 'Pest Control', 'Fire Safety', 'Water Hygiene', 'Roofing'],
    NULL,
    '951077',
    NULL,
    FALSE,
    FALSE,
    NULL,
    'excel',
    1.0,
    'pending',
    1,
    'supplier_documents/9bd92228-8efd-4baa-bfaa-82eafcd85454/'
);


-- ============================================================================
-- Supplier Documents
-- ============================================================================

INSERT INTO supplier_documents (
    id,
    supplier_id,
    document_type,
    document_name,
    file_name,
    file_size_bytes,
    storage_bucket,
    storage_path,
    document_status
)
VALUES (
    'ed375420-b2c1-4166-8d8e-520749b77786',
    '9bd92228-8efd-4baa-bfaa-82eafcd85454',
    'Other',
    'Book1.xlsx',
    'Book1.xlsx',
    260279,
    'supplier_documents',
    'supplier_documents/9bd92228-8efd-4baa-bfaa-82eafcd85454/Book1.xlsx',
    'pending_review'
);


COMMIT;

-- ============================================================================
-- Verification Query
-- ============================================================================

SELECT 
    contractor_name,
    email,
    telephone,
    postcode,
    services_provided,
    onboarding_status,
    extraction_confidence,
    total_documents_uploaded
FROM suppliers 
WHERE id = '9bd92228-8efd-4baa-bfaa-82eafcd85454';

-- Next Steps:
-- 1. Upload documents to Supabase Storage: supplier_documents/9bd92228-8efd-4baa-bfaa-82eafcd85454/
-- 2. Update document paths in supplier_documents table
-- 3. Review and approve supplier
