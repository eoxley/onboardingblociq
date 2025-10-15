BEGIN;


-- Contractor 1: 1050 Architects Limited
-- ============================================================================
-- Supplier Onboarding: 1050 Architects Limited
-- ============================================================================
-- Generated: 2025-10-15 12:25:02
-- Supplier ID: 0eada0a0-0682-4b6e-8a1d-7a2ef199bb35
-- Storage: supplier_documents/0eada0a0-0682-4b6e-8a1d-7a2ef199bb35/
-- ============================================================================




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
    '0eada0a0-0682-4b6e-8a1d-7a2ef199bb35',
    '1050 Architects Limited',
    'Second Home Spitalfields, Studio 319, 68/80 Hanbury Street, London, E1 5JL',
    'E1 5JL',
    'Claire.dupont@1050architects.com',
    '07976 951077',
    NULL,
    '60618912',
    '231185',
    NULL,
    FALSE,
    FALSE,
    NULL,
    'excel_batch',
    0.8,
    'pending',
    0,
    'supplier_documents/0eada0a0-0682-4b6e-8a1d-7a2ef199bb35/'
);




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
WHERE id = '0eada0a0-0682-4b6e-8a1d-7a2ef199bb35';

-- Next Steps:
-- 1. Upload documents to Supabase Storage: supplier_documents/0eada0a0-0682-4b6e-8a1d-7a2ef199bb35/
-- 2. Update document paths in supplier_documents table
-- 3. Review and approve supplier

-- Contractor 2: 1st Choice Cleaning Ltd
-- ============================================================================
-- Supplier Onboarding: 1st Choice Cleaning Ltd
-- ============================================================================
-- Generated: 2025-10-15 12:25:02
-- Supplier ID: a7f138cf-35eb-42d8-96c3-9f70aa8a4bbc
-- Storage: supplier_documents/a7f138cf-35eb-42d8-96c3-9f70aa8a4bbc/
-- ============================================================================




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
    'a7f138cf-35eb-42d8-96c3-9f70aa8a4bbc',
    '1st Choice Cleaning Ltd',
    'Suite G009, Lombard Business Park, 8 Lombard Road, London, SW19 3TZ',
    'SW19 3TZ',
    'info1st@hotmail.com',
    NULL,
    NULL,
    '90585394',
    '209689',
    NULL,
    FALSE,
    FALSE,
    NULL,
    'excel_batch',
    0.8,
    'pending',
    0,
    'supplier_documents/a7f138cf-35eb-42d8-96c3-9f70aa8a4bbc/'
);




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
WHERE id = 'a7f138cf-35eb-42d8-96c3-9f70aa8a4bbc';

-- Next Steps:
-- 1. Upload documents to Supabase Storage: supplier_documents/a7f138cf-35eb-42d8-96c3-9f70aa8a4bbc/
-- 2. Update document paths in supplier_documents table
-- 3. Review and approve supplier

-- Contractor 3: 1st Metropolitan Locksmiths Ltd
-- ============================================================================
-- Supplier Onboarding: 1st Metropolitan Locksmiths Ltd
-- ============================================================================
-- Generated: 2025-10-15 12:25:02
-- Supplier ID: 85dc49e0-0803-4aa8-beb7-4ca71798abd5
-- Storage: supplier_documents/85dc49e0-0803-4aa8-beb7-4ca71798abd5/
-- ============================================================================




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
    '85dc49e0-0803-4aa8-beb7-4ca71798abd5',
    '1st Metropolitan Locksmiths Ltd',
    'Unit 7, 2 Somerset Road, London, N17 9EJ',
    'N17 9EJ',
    'help@metrolocks.co.uk',
    NULL,
    NULL,
    '60593222',
    '209448',
    NULL,
    FALSE,
    FALSE,
    NULL,
    'excel_batch',
    0.8,
    'pending',
    0,
    'supplier_documents/85dc49e0-0803-4aa8-beb7-4ca71798abd5/'
);




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
WHERE id = '85dc49e0-0803-4aa8-beb7-4ca71798abd5';

-- Next Steps:
-- 1. Upload documents to Supabase Storage: supplier_documents/85dc49e0-0803-4aa8-beb7-4ca71798abd5/
-- 2. Update document paths in supplier_documents table
-- 3. Review and approve supplier

-- Contractor 4: 3Sixty Measurement Limited
-- ============================================================================
-- Supplier Onboarding: 3Sixty Measurement Limited
-- ============================================================================
-- Generated: 2025-10-15 12:25:02
-- Supplier ID: d5513a77-e05c-4528-b800-5b018f68a10b
-- Storage: supplier_documents/d5513a77-e05c-4528-b800-5b018f68a10b/
-- ============================================================================




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
    'd5513a77-e05c-4528-b800-5b018f68a10b',
    '3Sixty Measurement Limited',
    'China Works, Black Prince Road, London, SE1 7SJ',
    'SE1 7SJ',
    'info@3sixtymeasurement.co.uk',
    NULL,
    NULL,
    '63583392',
    '209689',
    NULL,
    FALSE,
    FALSE,
    NULL,
    'excel_batch',
    0.8,
    'pending',
    0,
    'supplier_documents/d5513a77-e05c-4528-b800-5b018f68a10b/'
);




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
WHERE id = 'd5513a77-e05c-4528-b800-5b018f68a10b';

-- Next Steps:
-- 1. Upload documents to Supabase Storage: supplier_documents/d5513a77-e05c-4528-b800-5b018f68a10b/
-- 2. Update document paths in supplier_documents table
-- 3. Review and approve supplier

-- Contractor 5: 4site Consulting Limited
-- ============================================================================
-- Supplier Onboarding: 4site Consulting Limited
-- ============================================================================
-- Generated: 2025-10-15 12:25:02
-- Supplier ID: f8a79365-9942-47fc-84b5-4c7daeae3c43
-- Storage: supplier_documents/f8a79365-9942-47fc-84b5-4c7daeae3c43/
-- ============================================================================




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
    'f8a79365-9942-47fc-84b5-4c7daeae3c43',
    '4site Consulting Limited',
    'Unit 4, Exchange Court, London Road, Feering, Essex, CO5 9FB',
    'CO5 9FB',
    'office@4siteconsulting.co.uk',
    NULL,
    NULL,
    '88545660',
    '602417',
    NULL,
    FALSE,
    FALSE,
    NULL,
    'excel_batch',
    0.8,
    'pending',
    0,
    'supplier_documents/f8a79365-9942-47fc-84b5-4c7daeae3c43/'
);




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
WHERE id = 'f8a79365-9942-47fc-84b5-4c7daeae3c43';

-- Next Steps:
-- 1. Upload documents to Supabase Storage: supplier_documents/f8a79365-9942-47fc-84b5-4c7daeae3c43/
-- 2. Update document paths in supplier_documents table
-- 3. Review and approve supplier

-- Contractor 6: 4Tradesmen Ltd
-- ============================================================================
-- Supplier Onboarding: 4Tradesmen Ltd
-- ============================================================================
-- Generated: 2025-10-15 12:25:02
-- Supplier ID: 8f707dbd-c7bf-4dbf-9e09-c0b4768fcce5
-- Storage: supplier_documents/8f707dbd-c7bf-4dbf-9e09-c0b4768fcce5/
-- ============================================================================




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
    '8f707dbd-c7bf-4dbf-9e09-c0b4768fcce5',
    '4Tradesmen Ltd',
    'Black Barn,, Dawn Farm, Fawkham, DA3 8LY',
    'DA3 8LY',
    'Info@4Tradesmenltd.co.uk',
    NULL,
    NULL,
    '78803403',
    '517014',
    NULL,
    FALSE,
    FALSE,
    NULL,
    'excel_batch',
    0.8,
    'pending',
    0,
    'supplier_documents/8f707dbd-c7bf-4dbf-9e09-c0b4768fcce5/'
);




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
WHERE id = '8f707dbd-c7bf-4dbf-9e09-c0b4768fcce5';

-- Next Steps:
-- 1. Upload documents to Supabase Storage: supplier_documents/8f707dbd-c7bf-4dbf-9e09-c0b4768fcce5/
-- 2. Update document paths in supplier_documents table
-- 3. Review and approve supplier

-- Contractor 7: 5RB
-- ============================================================================
-- Supplier Onboarding: 5RB
-- ============================================================================
-- Generated: 2025-10-15 12:25:02
-- Supplier ID: 5bdab9e2-8d0a-4a35-99b6-d42b4f05c6f9
-- Storage: supplier_documents/5bdab9e2-8d0a-4a35-99b6-d42b4f05c6f9/
-- ============================================================================




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
    '5bdab9e2-8d0a-4a35-99b6-d42b4f05c6f9',
    '5RB',
    '5 Gray''s Inn Square, London, WC1R 5AH',
    'WC1R 5AH',
    'clerks@5RB.com',
    NULL,
    NULL,
    '23876530',
    '600423',
    NULL,
    FALSE,
    FALSE,
    NULL,
    'excel_batch',
    0.8,
    'pending',
    0,
    'supplier_documents/5bdab9e2-8d0a-4a35-99b6-d42b4f05c6f9/'
);




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
WHERE id = '5bdab9e2-8d0a-4a35-99b6-d42b4f05c6f9';

-- Next Steps:
-- 1. Upload documents to Supabase Storage: supplier_documents/5bdab9e2-8d0a-4a35-99b6-d42b4f05c6f9/
-- 2. Update document paths in supplier_documents table
-- 3. Review and approve supplier

-- Contractor 8: X - Miscellaneous Creditors
-- ============================================================================
-- Supplier Onboarding: X - Miscellaneous Creditors
-- ============================================================================
-- Generated: 2025-10-15 12:25:02
-- Supplier ID: 7d355895-ce1d-4c1a-933b-31eb2d95f53e
-- Storage: supplier_documents/7d355895-ce1d-4c1a-933b-31eb2d95f53e/
-- ============================================================================




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
    '7d355895-ce1d-4c1a-933b-31eb2d95f53e',
    'X - Miscellaneous Creditors',
    NULL,
    NULL,
    NULL,
    NULL,
    NULL,
    NULL,
    NULL,
    NULL,
    FALSE,
    FALSE,
    NULL,
    'excel_batch',
    0.8,
    'pending',
    0,
    'supplier_documents/7d355895-ce1d-4c1a-933b-31eb2d95f53e/'
);




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
WHERE id = '7d355895-ce1d-4c1a-933b-31eb2d95f53e';

-- Next Steps:
-- 1. Upload documents to Supabase Storage: supplier_documents/7d355895-ce1d-4c1a-933b-31eb2d95f53e/
-- 2. Update document paths in supplier_documents table
-- 3. Review and approve supplier

-- Contractor 9: 9 GROUP
-- ============================================================================
-- Supplier Onboarding: 9 GROUP
-- ============================================================================
-- Generated: 2025-10-15 12:25:02
-- Supplier ID: c1763e65-eeb5-4038-a281-35f6e4403f83
-- Storage: supplier_documents/c1763e65-eeb5-4038-a281-35f6e4403f83/
-- ============================================================================




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
    'c1763e65-eeb5-4038-a281-35f6e4403f83',
    '9 GROUP',
    'Victoria House, Chobham Street, Luton, Bedfordshire, LU1 3BS',
    'LU1 3BS',
    'salesledger@9group.co.uk',
    NULL,
    NULL,
    '72364386',
    '600846',
    NULL,
    FALSE,
    FALSE,
    NULL,
    'excel_batch',
    0.8,
    'pending',
    0,
    'supplier_documents/c1763e65-eeb5-4038-a281-35f6e4403f83/'
);




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
WHERE id = 'c1763e65-eeb5-4038-a281-35f6e4403f83';

-- Next Steps:
-- 1. Upload documents to Supabase Storage: supplier_documents/c1763e65-eeb5-4038-a281-35f6e4403f83/
-- 2. Update document paths in supplier_documents table
-- 3. Review and approve supplier

-- Contractor 10: A2B London Locksmiths
-- ============================================================================
-- Supplier Onboarding: A2B London Locksmiths
-- ============================================================================
-- Generated: 2025-10-15 12:25:02
-- Supplier ID: 92cf3177-f350-4336-bebc-ce8bf743c020
-- Storage: supplier_documents/92cf3177-f350-4336-bebc-ce8bf743c020/
-- ============================================================================




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
    '92cf3177-f350-4336-bebc-ce8bf743c020',
    'A2B London Locksmiths',
    '56 ArchWay, Westbridge Road,  London, SW11',
    'SW11',
    'a2blondonlocksmiths@gmail.com',
    NULL,
    NULL,
    '82092315',
    '608371',
    NULL,
    FALSE,
    FALSE,
    NULL,
    'excel_batch',
    0.8,
    'pending',
    0,
    'supplier_documents/92cf3177-f350-4336-bebc-ce8bf743c020/'
);




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
WHERE id = '92cf3177-f350-4336-bebc-ce8bf743c020';

-- Next Steps:
-- 1. Upload documents to Supabase Storage: supplier_documents/92cf3177-f350-4336-bebc-ce8bf743c020/
-- 2. Update document paths in supplier_documents table
-- 3. Review and approve supplier

-- Contractor 11: A&A Enterprises
-- ============================================================================
-- Supplier Onboarding: A&A Enterprises
-- ============================================================================
-- Generated: 2025-10-15 12:25:02
-- Supplier ID: c730017f-695b-4338-afc6-d2f12b0177b1
-- Storage: supplier_documents/c730017f-695b-4338-afc6-d2f12b0177b1/
-- ============================================================================




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
    'c730017f-695b-4338-afc6-d2f12b0177b1',
    'A&A Enterprises',
    '161 Cotton Avenue, Westcott Park, Acton, London, W3 6YG',
    'W3 6YG',
    'aocbrothers@gmail.com',
    NULL,
    NULL,
    '42946559',
    '230580',
    NULL,
    FALSE,
    FALSE,
    NULL,
    'excel_batch',
    0.8,
    'pending',
    0,
    'supplier_documents/c730017f-695b-4338-afc6-d2f12b0177b1/'
);




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
WHERE id = 'c730017f-695b-4338-afc6-d2f12b0177b1';

-- Next Steps:
-- 1. Upload documents to Supabase Storage: supplier_documents/c730017f-695b-4338-afc6-d2f12b0177b1/
-- 2. Update document paths in supplier_documents table
-- 3. Review and approve supplier

-- Contractor 12: Ahmed Albayati
-- ============================================================================
-- Supplier Onboarding: Ahmed Albayati
-- ============================================================================
-- Generated: 2025-10-15 12:25:02
-- Supplier ID: 4af1533b-880f-48ed-8528-154c45025754
-- Storage: supplier_documents/4af1533b-880f-48ed-8528-154c45025754/
-- ============================================================================




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
    '4af1533b-880f-48ed-8528-154c45025754',
    'Ahmed Albayati',
    NULL,
    NULL,
    'pimlicoplace@yahoo.co.uk',
    NULL,
    NULL,
    '26265260',
    '308445',
    NULL,
    FALSE,
    FALSE,
    NULL,
    'excel_batch',
    0.8,
    'pending',
    0,
    'supplier_documents/4af1533b-880f-48ed-8528-154c45025754/'
);




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
WHERE id = '4af1533b-880f-48ed-8528-154c45025754';

-- Next Steps:
-- 1. Upload documents to Supabase Storage: supplier_documents/4af1533b-880f-48ed-8528-154c45025754/
-- 2. Update document paths in supplier_documents table
-- 3. Review and approve supplier

-- Contractor 13: AAO Fire & Electrical Engineers
-- ============================================================================
-- Supplier Onboarding: AAO Fire & Electrical Engineers
-- ============================================================================
-- Generated: 2025-10-15 12:25:02
-- Supplier ID: 5022087c-fdb6-4dce-aff0-1f0d4b752cf3
-- Storage: supplier_documents/5022087c-fdb6-4dce-aff0-1f0d4b752cf3/
-- ============================================================================




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
    '5022087c-fdb6-4dce-aff0-1f0d4b752cf3',
    'AAO Fire & Electrical Engineers',
    NULL,
    NULL,
    'a.a.o@btinternet.com',
    NULL,
    NULL,
    '90839604',
    '204422',
    NULL,
    FALSE,
    FALSE,
    NULL,
    'excel_batch',
    0.8,
    'pending',
    0,
    'supplier_documents/5022087c-fdb6-4dce-aff0-1f0d4b752cf3/'
);




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
WHERE id = '5022087c-fdb6-4dce-aff0-1f0d4b752cf3';

-- Next Steps:
-- 1. Upload documents to Supabase Storage: supplier_documents/5022087c-fdb6-4dce-aff0-1f0d4b752cf3/
-- 2. Update document paths in supplier_documents table
-- 3. Review and approve supplier

-- Contractor 14: Aaron Property Services
-- ============================================================================
-- Supplier Onboarding: Aaron Property Services
-- ============================================================================
-- Generated: 2025-10-15 12:25:02
-- Supplier ID: ae64abcb-033c-411a-9e4e-c1757d92ad18
-- Storage: supplier_documents/ae64abcb-033c-411a-9e4e-c1757d92ad18/
-- ============================================================================




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
    'ae64abcb-033c-411a-9e4e-c1757d92ad18',
    'Aaron Property Services',
    '30 Pyrland Road, Richmond, Surrey, TW10 6JA',
    'TW10 6JA',
    'kenataaron@outlook.com',
    NULL,
    NULL,
    '23292290',
    '204276',
    NULL,
    FALSE,
    FALSE,
    NULL,
    'excel_batch',
    0.8,
    'pending',
    0,
    'supplier_documents/ae64abcb-033c-411a-9e4e-c1757d92ad18/'
);




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
WHERE id = 'ae64abcb-033c-411a-9e4e-c1757d92ad18';

-- Next Steps:
-- 1. Upload documents to Supabase Storage: supplier_documents/ae64abcb-033c-411a-9e4e-c1757d92ad18/
-- 2. Update document paths in supplier_documents table
-- 3. Review and approve supplier

-- Contractor 15: Aaron Services
-- ============================================================================
-- Supplier Onboarding: Aaron Services
-- ============================================================================
-- Generated: 2025-10-15 12:25:02
-- Supplier ID: 295856ca-0f88-4bcd-b321-62e859c02142
-- Storage: supplier_documents/295856ca-0f88-4bcd-b321-62e859c02142/
-- ============================================================================




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
    '295856ca-0f88-4bcd-b321-62e859c02142',
    'Aaron Services',
    '58 St Clair Drive, KT4 8UQ',
    'KT4 8UQ',
    'gingerataaron@aol.com',
    '7956602753',
    NULL,
    '100269',
    '203590',
    NULL,
    FALSE,
    FALSE,
    NULL,
    'excel_batch',
    0.8,
    'pending',
    0,
    'supplier_documents/295856ca-0f88-4bcd-b321-62e859c02142/'
);




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
WHERE id = '295856ca-0f88-4bcd-b321-62e859c02142';

-- Next Steps:
-- 1. Upload documents to Supabase Storage: supplier_documents/295856ca-0f88-4bcd-b321-62e859c02142/
-- 2. Update document paths in supplier_documents table
-- 3. Review and approve supplier

-- Contractor 16: A.A.S Electrics Ltd
-- ============================================================================
-- Supplier Onboarding: A.A.S Electrics Ltd
-- ============================================================================
-- Generated: 2025-10-15 12:25:02
-- Supplier ID: 3954ac18-5d98-4ca0-b554-2afb3d5b93b9
-- Storage: supplier_documents/3954ac18-5d98-4ca0-b554-2afb3d5b93b9/
-- ============================================================================




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
    '3954ac18-5d98-4ca0-b554-2afb3d5b93b9',
    'A.A.S Electrics Ltd',
    '44 Cedar Lawn Avenue, Barnet, EN5 2LN',
    'EN5 2LN',
    'albi@altrics.co.uk',
    '7876654538',
    NULL,
    '92463363',
    '608371',
    NULL,
    FALSE,
    FALSE,
    NULL,
    'excel_batch',
    0.8,
    'pending',
    0,
    'supplier_documents/3954ac18-5d98-4ca0-b554-2afb3d5b93b9/'
);




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
WHERE id = '3954ac18-5d98-4ca0-b554-2afb3d5b93b9';

-- Next Steps:
-- 1. Upload documents to Supabase Storage: supplier_documents/3954ac18-5d98-4ca0-b554-2afb3d5b93b9/
-- 2. Update document paths in supplier_documents table
-- 3. Review and approve supplier

-- Contractor 17: Abacus Carpet Company Ltd
-- ============================================================================
-- Supplier Onboarding: Abacus Carpet Company Ltd
-- ============================================================================
-- Generated: 2025-10-15 12:25:02
-- Supplier ID: 1454b8d5-656d-4490-abde-c0e518cd9ff8
-- Storage: supplier_documents/1454b8d5-656d-4490-abde-c0e518cd9ff8/
-- ============================================================================




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
    '1454b8d5-656d-4490-abde-c0e518cd9ff8',
    'Abacus Carpet Company Ltd',
    '229-231 Sandycombe Road, Kew, Richmond, Surrey, TW9 2EW',
    'TW9 2EW',
    'sales@abacuscarpets.co.uk',
    NULL,
    NULL,
    '53954165',
    '601542',
    NULL,
    FALSE,
    FALSE,
    NULL,
    'excel_batch',
    0.8,
    'pending',
    0,
    'supplier_documents/1454b8d5-656d-4490-abde-c0e518cd9ff8/'
);




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
WHERE id = '1454b8d5-656d-4490-abde-c0e518cd9ff8';

-- Next Steps:
-- 1. Upload documents to Supabase Storage: supplier_documents/1454b8d5-656d-4490-abde-c0e518cd9ff8/
-- 2. Update document paths in supplier_documents table
-- 3. Review and approve supplier

-- Contractor 18: Aball Construction Ltd
-- ============================================================================
-- Supplier Onboarding: Aball Construction Ltd
-- ============================================================================
-- Generated: 2025-10-15 12:25:02
-- Supplier ID: a37593e7-8ed7-4556-beda-5b9a4d9c2666
-- Storage: supplier_documents/a37593e7-8ed7-4556-beda-5b9a4d9c2666/
-- ============================================================================




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
    'a37593e7-8ed7-4556-beda-5b9a4d9c2666',
    'Aball Construction Ltd',
    'Glenmore, Five Oaks Road, Horsham, West Sussex, RH13 0RQ',
    'RH13 0RQ',
    'aballcon@googlemail.com',
    NULL,
    NULL,
    '16507660',
    '309044',
    NULL,
    FALSE,
    FALSE,
    NULL,
    'excel_batch',
    0.8,
    'pending',
    0,
    'supplier_documents/a37593e7-8ed7-4556-beda-5b9a4d9c2666/'
);




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
WHERE id = 'a37593e7-8ed7-4556-beda-5b9a4d9c2666';

-- Next Steps:
-- 1. Upload documents to Supabase Storage: supplier_documents/a37593e7-8ed7-4556-beda-5b9a4d9c2666/
-- 2. Update document paths in supplier_documents table
-- 3. Review and approve supplier

-- Contractor 19: Abbatt Property Services
-- ============================================================================
-- Supplier Onboarding: Abbatt Property Services
-- ============================================================================
-- Generated: 2025-10-15 12:25:02
-- Supplier ID: 357b5d93-6778-49f0-b299-c8d65b6e44f3
-- Storage: supplier_documents/357b5d93-6778-49f0-b299-c8d65b6e44f3/
-- ============================================================================




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
    '357b5d93-6778-49f0-b299-c8d65b6e44f3',
    'Abbatt Property Services',
    '2nd Floor, Swan House, 37-39 High Holborn, London, WC1V 6AA',
    'WC1V 6AA',
    'accounts@abbatt.co.uk',
    NULL,
    NULL,
    '90202134',
    '204141',
    NULL,
    FALSE,
    FALSE,
    NULL,
    'excel_batch',
    0.8,
    'pending',
    0,
    'supplier_documents/357b5d93-6778-49f0-b299-c8d65b6e44f3/'
);




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
WHERE id = '357b5d93-6778-49f0-b299-c8d65b6e44f3';

-- Next Steps:
-- 1. Upload documents to Supabase Storage: supplier_documents/357b5d93-6778-49f0-b299-c8d65b6e44f3/
-- 2. Update document paths in supplier_documents table
-- 3. Review and approve supplier

-- Contractor 20: Abbatt Dual Management Ltd
-- ============================================================================
-- Supplier Onboarding: Abbatt Dual Management Ltd
-- ============================================================================
-- Generated: 2025-10-15 12:25:02
-- Supplier ID: f55f4b41-e895-43ec-a589-8a59021507bf
-- Storage: supplier_documents/f55f4b41-e895-43ec-a589-8a59021507bf/
-- ============================================================================




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
    'f55f4b41-e895-43ec-a589-8a59021507bf',
    'Abbatt Dual Management Ltd',
    'Swan House, 2nd Floor, 37-39 High Holborn, London, WC1V 6AA',
    'WC1V 6AA',
    'accounts@abbatt.co.uk',
    NULL,
    NULL,
    '10048666',
    '204141',
    NULL,
    FALSE,
    FALSE,
    NULL,
    'excel_batch',
    0.8,
    'pending',
    0,
    'supplier_documents/f55f4b41-e895-43ec-a589-8a59021507bf/'
);




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
WHERE id = 'f55f4b41-e895-43ec-a589-8a59021507bf';

-- Next Steps:
-- 1. Upload documents to Supabase Storage: supplier_documents/f55f4b41-e895-43ec-a589-8a59021507bf/
-- 2. Update document paths in supplier_documents table
-- 3. Review and approve supplier

-- Contractor 21: Abbott Management Ltd
-- ============================================================================
-- Supplier Onboarding: Abbott Management Ltd
-- ============================================================================
-- Generated: 2025-10-15 12:25:02
-- Supplier ID: fb979d38-e946-476d-b1a8-0e9ee325f340
-- Storage: supplier_documents/fb979d38-e946-476d-b1a8-0e9ee325f340/
-- ============================================================================




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
    'fb979d38-e946-476d-b1a8-0e9ee325f340',
    'Abbott Management Ltd',
    '17 The Stables, Sansaw Business Park, Hadnall, Shrewsbury, Shropshire, SY4 4AS',
    'SY4 4AS',
    'maintenance@abbottmanagement.co.uk',
    NULL,
    NULL,
    '530550',
    '309154',
    NULL,
    FALSE,
    FALSE,
    NULL,
    'excel_batch',
    0.8,
    'pending',
    0,
    'supplier_documents/fb979d38-e946-476d-b1a8-0e9ee325f340/'
);




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
WHERE id = 'fb979d38-e946-476d-b1a8-0e9ee325f340';

-- Next Steps:
-- 1. Upload documents to Supabase Storage: supplier_documents/fb979d38-e946-476d-b1a8-0e9ee325f340/
-- 2. Update document paths in supplier_documents table
-- 3. Review and approve supplier

-- Contractor 22: AB Contractors & Son Ltd
-- ============================================================================
-- Supplier Onboarding: AB Contractors & Son Ltd
-- ============================================================================
-- Generated: 2025-10-15 12:25:02
-- Supplier ID: 4b294b6c-fc8a-4de9-95b1-e64446749d86
-- Storage: supplier_documents/4b294b6c-fc8a-4de9-95b1-e64446749d86/
-- ============================================================================




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
    '4b294b6c-fc8a-4de9-95b1-e64446749d86',
    'AB Contractors & Son Ltd',
    'AB Contractors & Son Ltd, Tree Birches Greenlane, Surrey, London, KT9 2DS',
    'KT9 2DS',
    'abcontractorsandsonsltd@hotmail.com',
    NULL,
    NULL,
    '33389952',
    '204673',
    NULL,
    FALSE,
    FALSE,
    NULL,
    'excel_batch',
    0.8,
    'pending',
    0,
    'supplier_documents/4b294b6c-fc8a-4de9-95b1-e64446749d86/'
);




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
WHERE id = '4b294b6c-fc8a-4de9-95b1-e64446749d86';

-- Next Steps:
-- 1. Upload documents to Supabase Storage: supplier_documents/4b294b6c-fc8a-4de9-95b1-e64446749d86/
-- 2. Update document paths in supplier_documents table
-- 3. Review and approve supplier

-- Contractor 23: Abitativa Ltd
-- ============================================================================
-- Supplier Onboarding: Abitativa Ltd
-- ============================================================================
-- Generated: 2025-10-15 12:25:02
-- Supplier ID: e9ddfb2d-0f72-44bb-9527-ae40326b097c
-- Storage: supplier_documents/e9ddfb2d-0f72-44bb-9527-ae40326b097c/
-- ============================================================================




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
    'e9ddfb2d-0f72-44bb-9527-ae40326b097c',
    'Abitativa Ltd',
    'Unit 1 Endeavour House, 2 Cambridge Road, Kingston Upon Thames, KT1 3JU',
    'KT1 3JU',
    'info@abitativa.com',
    NULL,
    NULL,
    '47475079',
    '608371',
    NULL,
    FALSE,
    FALSE,
    NULL,
    'excel_batch',
    0.8,
    'pending',
    0,
    'supplier_documents/e9ddfb2d-0f72-44bb-9527-ae40326b097c/'
);




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
WHERE id = 'e9ddfb2d-0f72-44bb-9527-ae40326b097c';

-- Next Steps:
-- 1. Upload documents to Supabase Storage: supplier_documents/e9ddfb2d-0f72-44bb-9527-ae40326b097c/
-- 2. Update document paths in supplier_documents table
-- 3. Review and approve supplier

-- Contractor 24: AB Key LLP
-- ============================================================================
-- Supplier Onboarding: AB Key LLP
-- ============================================================================
-- Generated: 2025-10-15 12:25:02
-- Supplier ID: 50578f93-dc54-4e91-8208-a6e08cd86bc4
-- Storage: supplier_documents/50578f93-dc54-4e91-8208-a6e08cd86bc4/
-- ============================================================================




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
    '50578f93-dc54-4e91-8208-a6e08cd86bc4',
    'AB Key LLP',
    'Unit 23 Mulberry Court, Bourne Industrial Park, Crayford, Dartford, Kent, DA1 4BF',
    'DA1 4BF',
    'Accounts@abkey.co.uk',
    NULL,
    NULL,
    '3158489',
    '202963',
    NULL,
    FALSE,
    FALSE,
    NULL,
    'excel_batch',
    0.8,
    'pending',
    0,
    'supplier_documents/50578f93-dc54-4e91-8208-a6e08cd86bc4/'
);




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
WHERE id = '50578f93-dc54-4e91-8208-a6e08cd86bc4';

-- Next Steps:
-- 1. Upload documents to Supabase Storage: supplier_documents/50578f93-dc54-4e91-8208-a6e08cd86bc4/
-- 2. Update document paths in supplier_documents table
-- 3. Review and approve supplier

-- Contractor 25: Viabl Ltd T/A Able Group
-- ============================================================================
-- Supplier Onboarding: Viabl Ltd T/A Able Group
-- ============================================================================
-- Generated: 2025-10-15 12:25:02
-- Supplier ID: 6b681980-cb5a-4a9b-9d6e-9bf7e6697e04
-- Storage: supplier_documents/6b681980-cb5a-4a9b-9d6e-9bf7e6697e04/
-- ============================================================================




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
    '6b681980-cb5a-4a9b-9d6e-9bf7e6697e04',
    'Viabl Ltd T/A Able Group',
    'Able House, 39 Progress Road, Leigh on Sea, Essex, SS9 5PR',
    'SS9 5PR',
    'sales@able-group.co.uk',
    NULL,
    NULL,
    '48113352',
    '606004',
    NULL,
    FALSE,
    FALSE,
    NULL,
    'excel_batch',
    0.8,
    'pending',
    0,
    'supplier_documents/6b681980-cb5a-4a9b-9d6e-9bf7e6697e04/'
);




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
WHERE id = '6b681980-cb5a-4a9b-9d6e-9bf7e6697e04';

-- Next Steps:
-- 1. Upload documents to Supabase Storage: supplier_documents/6b681980-cb5a-4a9b-9d6e-9bf7e6697e04/
-- 2. Update document paths in supplier_documents table
-- 3. Review and approve supplier

-- Contractor 26: Abridge Cleaning Services Ltd
-- ============================================================================
-- Supplier Onboarding: Abridge Cleaning Services Ltd
-- ============================================================================
-- Generated: 2025-10-15 12:25:02
-- Supplier ID: 563158d2-5daf-4352-9090-6aaa5ded1786
-- Storage: supplier_documents/563158d2-5daf-4352-9090-6aaa5ded1786/
-- ============================================================================




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
    '563158d2-5daf-4352-9090-6aaa5ded1786',
    'Abridge Cleaning Services Ltd',
    'R734 Kings park, Canvey Island, SS8 8QS¶',
    'SS8 8QS¶',
    'accounts@abridgecleaning.co.uk',
    NULL,
    NULL,
    '67110363',
    '600718',
    NULL,
    FALSE,
    FALSE,
    NULL,
    'excel_batch',
    0.8,
    'pending',
    0,
    'supplier_documents/563158d2-5daf-4352-9090-6aaa5ded1786/'
);




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
WHERE id = '563158d2-5daf-4352-9090-6aaa5ded1786';

-- Next Steps:
-- 1. Upload documents to Supabase Storage: supplier_documents/563158d2-5daf-4352-9090-6aaa5ded1786/
-- 2. Update document paths in supplier_documents table
-- 3. Review and approve supplier

-- Contractor 27: Alfred Bagnall & Sons Restoration Ltd
-- ============================================================================
-- Supplier Onboarding: Alfred Bagnall & Sons Restoration Ltd
-- ============================================================================
-- Generated: 2025-10-15 12:25:02
-- Supplier ID: b39d65fc-dde3-4b15-b034-2810c7528cb8
-- Storage: supplier_documents/b39d65fc-dde3-4b15-b034-2810c7528cb8/
-- ============================================================================




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
    'b39d65fc-dde3-4b15-b034-2810c7528cb8',
    'Alfred Bagnall & Sons Restoration Ltd',
    'Penkridge,, Dyehouse Drive, West 26 Industrial Estate, Cleckheaton, BD19 4TY',
    'BD19 4TY',
    'remittances@bagnalls.co.uk',
    NULL,
    NULL,
    '20930652',
    '201199',
    NULL,
    FALSE,
    FALSE,
    NULL,
    'excel_batch',
    0.8,
    'pending',
    0,
    'supplier_documents/b39d65fc-dde3-4b15-b034-2810c7528cb8/'
);




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
WHERE id = 'b39d65fc-dde3-4b15-b034-2810c7528cb8';

-- Next Steps:
-- 1. Upload documents to Supabase Storage: supplier_documents/b39d65fc-dde3-4b15-b034-2810c7528cb8/
-- 2. Update document paths in supplier_documents table
-- 3. Review and approve supplier

-- Contractor 28: Academy Associates
-- ============================================================================
-- Supplier Onboarding: Academy Associates
-- ============================================================================
-- Generated: 2025-10-15 12:25:02
-- Supplier ID: a6215dca-7647-42b9-a496-ec48f11016bf
-- Storage: supplier_documents/a6215dca-7647-42b9-a496-ec48f11016bf/
-- ============================================================================




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
    'a6215dca-7647-42b9-a496-ec48f11016bf',
    'Academy Associates',
    '123A Park Road, New Barnet, Herts, EN4 9QN',
    'EN4 9QN',
    'leo@academyassociates.com',
    NULL,
    NULL,
    '80101370',
    '203688',
    NULL,
    FALSE,
    FALSE,
    NULL,
    'excel_batch',
    0.8,
    'pending',
    0,
    'supplier_documents/a6215dca-7647-42b9-a496-ec48f11016bf/'
);




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
WHERE id = 'a6215dca-7647-42b9-a496-ec48f11016bf';

-- Next Steps:
-- 1. Upload documents to Supabase Storage: supplier_documents/a6215dca-7647-42b9-a496-ec48f11016bf/
-- 2. Update document paths in supplier_documents table
-- 3. Review and approve supplier

-- Contractor 29: Access4Lofts
-- ============================================================================
-- Supplier Onboarding: Access4Lofts
-- ============================================================================
-- Generated: 2025-10-15 12:25:02
-- Supplier ID: 9189375c-e77d-4101-a024-208bda2f3fc3
-- Storage: supplier_documents/9189375c-e77d-4101-a024-208bda2f3fc3/
-- ============================================================================




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
    '9189375c-e77d-4101-a024-208bda2f3fc3',
    'Access4Lofts',
    'Jubilee House, East Beach, Lytham, FY8 5FT',
    'FY8 5FT',
    'wimbledon@access4lofts.co.uk',
    NULL,
    NULL,
    '96988244',
    '608371',
    NULL,
    FALSE,
    FALSE,
    NULL,
    'excel_batch',
    0.8,
    'pending',
    0,
    'supplier_documents/9189375c-e77d-4101-a024-208bda2f3fc3/'
);




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
WHERE id = '9189375c-e77d-4101-a024-208bda2f3fc3';

-- Next Steps:
-- 1. Upload documents to Supabase Storage: supplier_documents/9189375c-e77d-4101-a024-208bda2f3fc3/
-- 2. Update document paths in supplier_documents table
-- 3. Review and approve supplier

-- Contractor 30: Acclimatise Airconditioning Ltd
-- ============================================================================
-- Supplier Onboarding: Acclimatise Airconditioning Ltd
-- ============================================================================
-- Generated: 2025-10-15 12:25:02
-- Supplier ID: 12d26357-56f6-4b44-9091-8347a56554e1
-- Storage: supplier_documents/12d26357-56f6-4b44-9091-8347a56554e1/
-- ============================================================================




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
    '12d26357-56f6-4b44-9091-8347a56554e1',
    'Acclimatise Airconditioning Ltd',
    '16 Enterprise Estate, Station Road West, Ash Vale, Surrey, GU12 5QJ',
    'GU12 5QJ',
    'accounts@acclimatise.biz',
    NULL,
    NULL,
    '1575256',
    '309980',
    NULL,
    FALSE,
    FALSE,
    NULL,
    'excel_batch',
    0.8,
    'pending',
    0,
    'supplier_documents/12d26357-56f6-4b44-9091-8347a56554e1/'
);




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
WHERE id = '12d26357-56f6-4b44-9091-8347a56554e1';

-- Next Steps:
-- 1. Upload documents to Supabase Storage: supplier_documents/12d26357-56f6-4b44-9091-8347a56554e1/
-- 2. Update document paths in supplier_documents table
-- 3. Review and approve supplier

-- Contractor 31: Ace Appliance Centre Ltd
-- ============================================================================
-- Supplier Onboarding: Ace Appliance Centre Ltd
-- ============================================================================
-- Generated: 2025-10-15 12:25:02
-- Supplier ID: cfa3d3d8-d7f0-4998-a9c7-0fa15a2d8716
-- Storage: supplier_documents/cfa3d3d8-d7f0-4998-a9c7-0fa15a2d8716/
-- ============================================================================




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
    'cfa3d3d8-d7f0-4998-a9c7-0fa15a2d8716',
    'Ace Appliance Centre Ltd',
    '1 Willow Grove, Ruislip, Middlesex, HA4 6DG',
    'HA4 6DG',
    'admin@aceappliancecentre.co.uk',
    NULL,
    NULL,
    '80182508',
    '207353',
    NULL,
    FALSE,
    FALSE,
    NULL,
    'excel_batch',
    0.8,
    'pending',
    0,
    'supplier_documents/cfa3d3d8-d7f0-4998-a9c7-0fa15a2d8716/'
);




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
WHERE id = 'cfa3d3d8-d7f0-4998-a9c7-0fa15a2d8716';

-- Next Steps:
-- 1. Upload documents to Supabase Storage: supplier_documents/cfa3d3d8-d7f0-4998-a9c7-0fa15a2d8716/
-- 2. Update document paths in supplier_documents table
-- 3. Review and approve supplier

-- Contractor 32: Ace Cleaning & Support services Ltd
-- ============================================================================
-- Supplier Onboarding: Ace Cleaning & Support services Ltd
-- ============================================================================
-- Generated: 2025-10-15 12:25:02
-- Supplier ID: a3e66637-5cc5-4333-8d05-f14bc60b2376
-- Storage: supplier_documents/a3e66637-5cc5-4333-8d05-f14bc60b2376/
-- ============================================================================




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
    'a3e66637-5cc5-4333-8d05-f14bc60b2376',
    'Ace Cleaning & Support services Ltd',
    'The Cabin, 37 Ardleigh Green Road, Hornchurch, Essex, RM11 2JZ',
    'RM11 2JZ',
    'office@acesupportservices.co.uk',
    NULL,
    NULL,
    '33701042',
    '202519',
    NULL,
    FALSE,
    FALSE,
    NULL,
    'excel_batch',
    0.8,
    'pending',
    0,
    'supplier_documents/a3e66637-5cc5-4333-8d05-f14bc60b2376/'
);




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
WHERE id = 'a3e66637-5cc5-4333-8d05-f14bc60b2376';

-- Next Steps:
-- 1. Upload documents to Supabase Storage: supplier_documents/a3e66637-5cc5-4333-8d05-f14bc60b2376/
-- 2. Update document paths in supplier_documents table
-- 3. Review and approve supplier

-- Contractor 33: Acer Landscapes Ltd
-- ============================================================================
-- Supplier Onboarding: Acer Landscapes Ltd
-- ============================================================================
-- Generated: 2025-10-15 12:25:02
-- Supplier ID: a9de5323-233b-4fd2-85f5-4689d6d67c2a
-- Storage: supplier_documents/a9de5323-233b-4fd2-85f5-4689d6d67c2a/
-- ============================================================================




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
    'a9de5323-233b-4fd2-85f5-4689d6d67c2a',
    'Acer Landscapes Ltd',
    'Five Tree Works, Bakers Lane, Galleywood, Chelmsford, Essex, CM2 8LD',
    'CM2 8LD',
    'ben.chapman@acerlandscapes.co.uk',
    '07825 536 535',
    NULL,
    '61083406',
    '402620',
    NULL,
    FALSE,
    FALSE,
    NULL,
    'excel_batch',
    0.8,
    'pending',
    0,
    'supplier_documents/a9de5323-233b-4fd2-85f5-4689d6d67c2a/'
);




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
WHERE id = 'a9de5323-233b-4fd2-85f5-4689d6d67c2a';

-- Next Steps:
-- 1. Upload documents to Supabase Storage: supplier_documents/a9de5323-233b-4fd2-85f5-4689d6d67c2a/
-- 2. Update document paths in supplier_documents table
-- 3. Review and approve supplier

-- Contractor 34: Acescott Specialist Services Ltd
-- ============================================================================
-- Supplier Onboarding: Acescott Specialist Services Ltd
-- ============================================================================
-- Generated: 2025-10-15 12:25:02
-- Supplier ID: 1cdc9758-04b3-488b-b92f-81e7ea295d68
-- Storage: supplier_documents/1cdc9758-04b3-488b-b92f-81e7ea295d68/
-- ============================================================================




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
    '1cdc9758-04b3-488b-b92f-81e7ea295d68',
    'Acescott Specialist Services Ltd',
    'Acescott Specialist Services Ltd c/o, PTSG, 13-14 Flemming Court, Castleford, West Yorkshire, WF10 5HW',
    'WF10 5HW',
    'luisa@acescott.com',
    NULL,
    NULL,
    '24819772',
    '401118',
    NULL,
    FALSE,
    FALSE,
    NULL,
    'excel_batch',
    0.8,
    'pending',
    0,
    'supplier_documents/1cdc9758-04b3-488b-b92f-81e7ea295d68/'
);




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
WHERE id = '1cdc9758-04b3-488b-b92f-81e7ea295d68';

-- Next Steps:
-- 1. Upload documents to Supabase Storage: supplier_documents/1cdc9758-04b3-488b-b92f-81e7ea295d68/
-- 2. Update document paths in supplier_documents table
-- 3. Review and approve supplier

-- Contractor 35: Acomtec Ltd
-- ============================================================================
-- Supplier Onboarding: Acomtec Ltd
-- ============================================================================
-- Generated: 2025-10-15 12:25:02
-- Supplier ID: bbcf8132-af4d-4217-849a-5a5d9973adbe
-- Storage: supplier_documents/bbcf8132-af4d-4217-849a-5a5d9973adbe/
-- ============================================================================




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
    'bbcf8132-af4d-4217-849a-5a5d9973adbe',
    'Acomtec Ltd',
    '10 Fowey Close, Wellingborough, Northamptonshire, NN8 5WW',
    'NN8 5WW',
    'david.levy@optionsfm.co.uk',
    NULL,
    NULL,
    '73176290',
    '204577',
    NULL,
    FALSE,
    FALSE,
    NULL,
    'excel_batch',
    0.8,
    'pending',
    0,
    'supplier_documents/bbcf8132-af4d-4217-849a-5a5d9973adbe/'
);




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
WHERE id = 'bbcf8132-af4d-4217-849a-5a5d9973adbe';

-- Next Steps:
-- 1. Upload documents to Supabase Storage: supplier_documents/bbcf8132-af4d-4217-849a-5a5d9973adbe/
-- 2. Update document paths in supplier_documents table
-- 3. Review and approve supplier

-- Contractor 36: Mr Abbas Contractor
-- ============================================================================
-- Supplier Onboarding: Mr Abbas Contractor
-- ============================================================================
-- Generated: 2025-10-15 12:25:02
-- Supplier ID: 5b7d5e46-47d6-483a-bdbb-9a9f01062ce1
-- Storage: supplier_documents/5b7d5e46-47d6-483a-bdbb-9a9f01062ce1/
-- ============================================================================




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
    '5b7d5e46-47d6-483a-bdbb-9a9f01062ce1',
    'Mr Abbas Contractor',
    '6 Dollis Park, London, N3 1HG',
    'N3 1HG',
    'abbasc@aol.com',
    NULL,
    NULL,
    '61137638',
    '400701',
    NULL,
    FALSE,
    FALSE,
    NULL,
    'excel_batch',
    0.8,
    'pending',
    0,
    'supplier_documents/5b7d5e46-47d6-483a-bdbb-9a9f01062ce1/'
);




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
WHERE id = '5b7d5e46-47d6-483a-bdbb-9a9f01062ce1';

-- Next Steps:
-- 1. Upload documents to Supabase Storage: supplier_documents/5b7d5e46-47d6-483a-bdbb-9a9f01062ce1/
-- 2. Update document paths in supplier_documents table
-- 3. Review and approve supplier

-- Contractor 37: Acopia Group
-- ============================================================================
-- Supplier Onboarding: Acopia Group
-- ============================================================================
-- Generated: 2025-10-15 12:25:02
-- Supplier ID: 3af68cae-a126-4311-8455-dbf55a30940f
-- Storage: supplier_documents/3af68cae-a126-4311-8455-dbf55a30940f/
-- ============================================================================




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
    '3af68cae-a126-4311-8455-dbf55a30940f',
    'Acopia Group',
    'Global Point, Steyning Way, Bognor Regis, West Sussex, PO22 9SB',
    'PO22 9SB',
    'accounts@acopia.co.uk',
    NULL,
    NULL,
    '89622502',
    '601727',
    NULL,
    FALSE,
    FALSE,
    NULL,
    'excel_batch',
    0.8,
    'pending',
    0,
    'supplier_documents/3af68cae-a126-4311-8455-dbf55a30940f/'
);




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
WHERE id = '3af68cae-a126-4311-8455-dbf55a30940f';

-- Next Steps:
-- 1. Upload documents to Supabase Storage: supplier_documents/3af68cae-a126-4311-8455-dbf55a30940f/
-- 2. Update document paths in supplier_documents table
-- 3. Review and approve supplier

-- Contractor 38: Acorn Mobility Services Ltd
-- ============================================================================
-- Supplier Onboarding: Acorn Mobility Services Ltd
-- ============================================================================
-- Generated: 2025-10-15 12:25:02
-- Supplier ID: b6edc364-44b6-44fd-a112-9a1f3f966948
-- Storage: supplier_documents/b6edc364-44b6-44fd-a112-9a1f3f966948/
-- ============================================================================




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
    'b6edc364-44b6-44fd-a112-9a1f3f966948',
    'Acorn Mobility Services Ltd',
    'Telecom House, Millennium Business Park, Steeton, West Yorkshire, BD20 6RB',
    'BD20 6RB',
    'info@acornstairlifts.com',
    NULL,
    NULL,
    '640817',
    '309112',
    NULL,
    FALSE,
    FALSE,
    NULL,
    'excel_batch',
    0.8,
    'pending',
    0,
    'supplier_documents/b6edc364-44b6-44fd-a112-9a1f3f966948/'
);




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
WHERE id = 'b6edc364-44b6-44fd-a112-9a1f3f966948';

-- Next Steps:
-- 1. Upload documents to Supabase Storage: supplier_documents/b6edc364-44b6-44fd-a112-9a1f3f966948/
-- 2. Update document paths in supplier_documents table
-- 3. Review and approve supplier

-- Contractor 39: ACS Trees Consulting
-- ============================================================================
-- Supplier Onboarding: ACS Trees Consulting
-- ============================================================================
-- Generated: 2025-10-15 12:25:02
-- Supplier ID: 7988ffbf-5b6e-4fed-be20-550b35b1ec63
-- Storage: supplier_documents/7988ffbf-5b6e-4fed-be20-550b35b1ec63/
-- ============================================================================




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
    '7988ffbf-5b6e-4fed-be20-550b35b1ec63',
    'ACS Trees Consulting',
    'Tree Tops, 2 Redwood Mount, Reigate, Surrey, RH2 9NB',
    'RH2 9NB',
    'info@acstrees.co.uk',
    NULL,
    NULL,
    '50588958',
    '601727',
    NULL,
    FALSE,
    FALSE,
    NULL,
    'excel_batch',
    0.8,
    'pending',
    0,
    'supplier_documents/7988ffbf-5b6e-4fed-be20-550b35b1ec63/'
);




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
WHERE id = '7988ffbf-5b6e-4fed-be20-550b35b1ec63';

-- Next Steps:
-- 1. Upload documents to Supabase Storage: supplier_documents/7988ffbf-5b6e-4fed-be20-550b35b1ec63/
-- 2. Update document paths in supplier_documents table
-- 3. Review and approve supplier

-- Contractor 40: Associated Cooling Services Ltd
-- ============================================================================
-- Supplier Onboarding: Associated Cooling Services Ltd
-- ============================================================================
-- Generated: 2025-10-15 12:25:02
-- Supplier ID: 3473a826-69dc-4e6b-8116-f2e9a7feac2f
-- Storage: supplier_documents/3473a826-69dc-4e6b-8116-f2e9a7feac2f/
-- ============================================================================




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
    '3473a826-69dc-4e6b-8116-f2e9a7feac2f',
    'Associated Cooling Services Ltd',
    '20 Metro Centre, Kangley Bridge Road, London, SE26 5BW',
    'SE26 5BW',
    'accounts@acsuk.org',
    NULL,
    NULL,
    '53660730',
    '600212',
    NULL,
    FALSE,
    FALSE,
    NULL,
    'excel_batch',
    0.8,
    'pending',
    0,
    'supplier_documents/3473a826-69dc-4e6b-8116-f2e9a7feac2f/'
);




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
WHERE id = '3473a826-69dc-4e6b-8116-f2e9a7feac2f';

-- Next Steps:
-- 1. Upload documents to Supabase Storage: supplier_documents/3473a826-69dc-4e6b-8116-f2e9a7feac2f/
-- 2. Update document paths in supplier_documents table
-- 3. Review and approve supplier

-- Contractor 41: ADCO Design Ltd
-- ============================================================================
-- Supplier Onboarding: ADCO Design Ltd
-- ============================================================================
-- Generated: 2025-10-15 12:25:02
-- Supplier ID: 905918dd-cb50-43e3-8342-20884a45dd8e
-- Storage: supplier_documents/905918dd-cb50-43e3-8342-20884a45dd8e/
-- ============================================================================




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
    '905918dd-cb50-43e3-8342-20884a45dd8e',
    'ADCO Design Ltd',
    '189 Baker Street, London, NW1 6UY',
    'NW1 6UY',
    'adco@aol.com',
    NULL,
    NULL,
    '44763262',
    '309897',
    NULL,
    FALSE,
    FALSE,
    NULL,
    'excel_batch',
    0.8,
    'pending',
    0,
    'supplier_documents/905918dd-cb50-43e3-8342-20884a45dd8e/'
);




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
WHERE id = '905918dd-cb50-43e3-8342-20884a45dd8e';

-- Next Steps:
-- 1. Upload documents to Supabase Storage: supplier_documents/905918dd-cb50-43e3-8342-20884a45dd8e/
-- 2. Update document paths in supplier_documents table
-- 3. Review and approve supplier

-- Contractor 42: A & D Heating Solutions Ltd
-- ============================================================================
-- Supplier Onboarding: A & D Heating Solutions Ltd
-- ============================================================================
-- Generated: 2025-10-15 12:25:02
-- Supplier ID: cabe26fa-f0b3-4069-8e79-e500ac86f072
-- Storage: supplier_documents/cabe26fa-f0b3-4069-8e79-e500ac86f072/
-- ============================================================================




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
    'cabe26fa-f0b3-4069-8e79-e500ac86f072',
    'A & D Heating Solutions Ltd',
    '746 Chigwell Road, Woodford Green, Essex, IG8 8AL',
    'IG8 8AL',
    'Jake@adhs.ltd',
    NULL,
    NULL,
    '298433',
    '208956',
    NULL,
    FALSE,
    FALSE,
    NULL,
    'excel_batch',
    0.8,
    'pending',
    0,
    'supplier_documents/cabe26fa-f0b3-4069-8e79-e500ac86f072/'
);




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
WHERE id = 'cabe26fa-f0b3-4069-8e79-e500ac86f072';

-- Next Steps:
-- 1. Upload documents to Supabase Storage: supplier_documents/cabe26fa-f0b3-4069-8e79-e500ac86f072/
-- 2. Update document paths in supplier_documents table
-- 3. Review and approve supplier

-- Contractor 43: Adkins Consultants Ltd
-- ============================================================================
-- Supplier Onboarding: Adkins Consultants Ltd
-- ============================================================================
-- Generated: 2025-10-15 12:25:02
-- Supplier ID: bb634e2e-dae5-4f4a-8355-5607a213e287
-- Storage: supplier_documents/bb634e2e-dae5-4f4a-8355-5607a213e287/
-- ============================================================================




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
    'bb634e2e-dae5-4f4a-8355-5607a213e287',
    'Adkins Consultants Ltd',
    '130A ASHFORD ROAD, Bearsted, Maidstone, ME14 4AF',
    'ME14 4AF',
    's.jenkins@adkinsconsultants.com',
    NULL,
    NULL,
    '37300502',
    '90129',
    NULL,
    FALSE,
    FALSE,
    NULL,
    'excel_batch',
    0.8,
    'pending',
    0,
    'supplier_documents/bb634e2e-dae5-4f4a-8355-5607a213e287/'
);




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
WHERE id = 'bb634e2e-dae5-4f4a-8355-5607a213e287';

-- Next Steps:
-- 1. Upload documents to Supabase Storage: supplier_documents/bb634e2e-dae5-4f4a-8355-5607a213e287/
-- 2. Update document paths in supplier_documents table
-- 3. Review and approve supplier

-- Contractor 44: Mr A Doyle
-- ============================================================================
-- Supplier Onboarding: Mr A Doyle
-- ============================================================================
-- Generated: 2025-10-15 12:25:02
-- Supplier ID: d0d664d8-e5d3-4e68-9c3c-0982e31e3f25
-- Storage: supplier_documents/d0d664d8-e5d3-4e68-9c3c-0982e31e3f25/
-- ============================================================================




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
    'd0d664d8-e5d3-4e68-9c3c-0982e31e3f25',
    'Mr A Doyle',
    'c/o Warwick Drive',
    NULL,
    NULL,
    NULL,
    NULL,
    '60436852',
    '202749',
    NULL,
    FALSE,
    FALSE,
    NULL,
    'excel_batch',
    0.8,
    'pending',
    0,
    'supplier_documents/d0d664d8-e5d3-4e68-9c3c-0982e31e3f25/'
);




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
WHERE id = 'd0d664d8-e5d3-4e68-9c3c-0982e31e3f25';

-- Next Steps:
-- 1. Upload documents to Supabase Storage: supplier_documents/d0d664d8-e5d3-4e68-9c3c-0982e31e3f25/
-- 2. Update document paths in supplier_documents table
-- 3. Review and approve supplier

-- Contractor 45: X - Adrian Bold
-- ============================================================================
-- Supplier Onboarding: X - Adrian Bold
-- ============================================================================
-- Generated: 2025-10-15 12:25:02
-- Supplier ID: bfc8694b-9223-4182-941d-91e0f997f45f
-- Storage: supplier_documents/bfc8694b-9223-4182-941d-91e0f997f45f/
-- ============================================================================




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
    'bfc8694b-9223-4182-941d-91e0f997f45f',
    'X - Adrian Bold',
    '6 Downs Cote Drive, Westbury on Trym, Bristol, BS9 3TP',
    'BS9 3TP',
    'figuresbold@aol.com',
    NULL,
    NULL,
    '3243628',
    '309938',
    NULL,
    FALSE,
    FALSE,
    NULL,
    'excel_batch',
    0.8,
    'pending',
    0,
    'supplier_documents/bfc8694b-9223-4182-941d-91e0f997f45f/'
);




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
WHERE id = 'bfc8694b-9223-4182-941d-91e0f997f45f';

-- Next Steps:
-- 1. Upload documents to Supabase Storage: supplier_documents/bfc8694b-9223-4182-941d-91e0f997f45f/
-- 2. Update document paths in supplier_documents table
-- 3. Review and approve supplier

-- Contractor 46: ADS Smart Home Ltd
-- ============================================================================
-- Supplier Onboarding: ADS Smart Home Ltd
-- ============================================================================
-- Generated: 2025-10-15 12:25:02
-- Supplier ID: 6dcdb393-5cef-4204-aae2-941fec675585
-- Storage: supplier_documents/6dcdb393-5cef-4204-aae2-941fec675585/
-- ============================================================================




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
    '6dcdb393-5cef-4204-aae2-941fec675585',
    'ADS Smart Home Ltd',
    '22 Holywell Hill, St Albans, AL1 1BZ',
    'AL1 1BZ',
    'info@adsukltd.com',
    NULL,
    NULL,
    '46554297',
    '600731',
    NULL,
    FALSE,
    FALSE,
    NULL,
    'excel_batch',
    0.8,
    'pending',
    0,
    'supplier_documents/6dcdb393-5cef-4204-aae2-941fec675585/'
);




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
WHERE id = '6dcdb393-5cef-4204-aae2-941fec675585';

-- Next Steps:
-- 1. Upload documents to Supabase Storage: supplier_documents/6dcdb393-5cef-4204-aae2-941fec675585/
-- 2. Update document paths in supplier_documents table
-- 3. Review and approve supplier

-- Contractor 47: Advance Facilities Solutions
-- ============================================================================
-- Supplier Onboarding: Advance Facilities Solutions
-- ============================================================================
-- Generated: 2025-10-15 12:25:02
-- Supplier ID: cc4adb9d-371f-4465-9b30-e405b654e4d1
-- Storage: supplier_documents/cc4adb9d-371f-4465-9b30-e405b654e4d1/
-- ============================================================================




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
    'cc4adb9d-371f-4465-9b30-e405b654e4d1',
    'Advance Facilities Solutions',
    'St Laurence Avenue, 20/20 Industrial Estate, Maidstone, Kent, ME16 0LL',
    'ME16 0LL',
    'ar@advance.fm',
    NULL,
    NULL,
    '47723272',
    '230580',
    NULL,
    FALSE,
    FALSE,
    NULL,
    'excel_batch',
    0.8,
    'pending',
    0,
    'supplier_documents/cc4adb9d-371f-4465-9b30-e405b654e4d1/'
);




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
WHERE id = 'cc4adb9d-371f-4465-9b30-e405b654e4d1';

-- Next Steps:
-- 1. Upload documents to Supabase Storage: supplier_documents/cc4adb9d-371f-4465-9b30-e405b654e4d1/
-- 2. Update document paths in supplier_documents table
-- 3. Review and approve supplier

-- Contractor 48: Advanced Property Maintenance Limited
-- ============================================================================
-- Supplier Onboarding: Advanced Property Maintenance Limited
-- ============================================================================
-- Generated: 2025-10-15 12:25:02
-- Supplier ID: d801a863-f64a-4ef4-98d6-a7835fcb7c67
-- Storage: supplier_documents/d801a863-f64a-4ef4-98d6-a7835fcb7c67/
-- ============================================================================




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
    'd801a863-f64a-4ef4-98d6-a7835fcb7c67',
    'Advanced Property Maintenance Limited',
    '16 Chigwell Rise, Chigwell, Essex, IG7 6AB',
    'IG7 6AB',
    'Email: apmlimited@live.com',
    NULL,
    NULL,
    '38454823',
    '605009',
    NULL,
    FALSE,
    FALSE,
    NULL,
    'excel_batch',
    0.8,
    'pending',
    0,
    'supplier_documents/d801a863-f64a-4ef4-98d6-a7835fcb7c67/'
);




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
WHERE id = 'd801a863-f64a-4ef4-98d6-a7835fcb7c67';

-- Next Steps:
-- 1. Upload documents to Supabase Storage: supplier_documents/d801a863-f64a-4ef4-98d6-a7835fcb7c67/
-- 2. Update document paths in supplier_documents table
-- 3. Review and approve supplier

-- Contractor 49: Advance FM Ltd
-- ============================================================================
-- Supplier Onboarding: Advance FM Ltd
-- ============================================================================
-- Generated: 2025-10-15 12:25:02
-- Supplier ID: b9bf1966-1f0e-49b1-99a1-f4177a0e929c
-- Storage: supplier_documents/b9bf1966-1f0e-49b1-99a1-f4177a0e929c/
-- ============================================================================




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
    'b9bf1966-1f0e-49b1-99a1-f4177a0e929c',
    'Advance FM Ltd',
    'Unit 10, St Laurence Avenue, 20/20 Industrial Estate, Maidstone, Kent, ME16 0LL',
    'ME16 0LL',
    'jemma@advance.fm',
    NULL,
    NULL,
    '47723272',
    '230580',
    NULL,
    FALSE,
    FALSE,
    NULL,
    'excel_batch',
    0.8,
    'pending',
    0,
    'supplier_documents/b9bf1966-1f0e-49b1-99a1-f4177a0e929c/'
);




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
WHERE id = 'b9bf1966-1f0e-49b1-99a1-f4177a0e929c';

-- Next Steps:
-- 1. Upload documents to Supabase Storage: supplier_documents/b9bf1966-1f0e-49b1-99a1-f4177a0e929c/
-- 2. Update document paths in supplier_documents table
-- 3. Review and approve supplier

-- Contractor 50: Advantis Credit Ltd
-- ============================================================================
-- Supplier Onboarding: Advantis Credit Ltd
-- ============================================================================
-- Generated: 2025-10-15 12:25:02
-- Supplier ID: 68b13145-98fd-4b97-a655-551b3c831527
-- Storage: supplier_documents/68b13145-98fd-4b97-a655-551b3c831527/
-- ============================================================================




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
    '68b13145-98fd-4b97-a655-551b3c831527',
    'Advantis Credit Ltd',
    'Minton Hollins Building, Shelton Old Road, Stoke on Trent, ST4 7RY',
    'ST4 7RY',
    'admin@advantiscredit.co.uk',
    NULL,
    NULL,
    '10530398',
    '541017',
    NULL,
    FALSE,
    FALSE,
    NULL,
    'excel_batch',
    0.8,
    'pending',
    0,
    'supplier_documents/68b13145-98fd-4b97-a655-551b3c831527/'
);




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
WHERE id = '68b13145-98fd-4b97-a655-551b3c831527';

-- Next Steps:
-- 1. Upload documents to Supabase Storage: supplier_documents/68b13145-98fd-4b97-a655-551b3c831527/
-- 2. Update document paths in supplier_documents table
-- 3. Review and approve supplier

-- Contractor 51: Aerial Services Ltd
-- ============================================================================
-- Supplier Onboarding: Aerial Services Ltd
-- ============================================================================
-- Generated: 2025-10-15 12:25:02
-- Supplier ID: e3ef9b7e-7f5f-48cb-904a-b590bc0ee191
-- Storage: supplier_documents/e3ef9b7e-7f5f-48cb-904a-b590bc0ee191/
-- ============================================================================




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
    'e3ef9b7e-7f5f-48cb-904a-b590bc0ee191',
    'Aerial Services Ltd',
    '11-21 Old Paradise Street, London, SE11 6BB',
    'SE11 6BB',
    'info@aerialservices.co.uk',
    NULL,
    NULL,
    '64052991',
    '90129',
    NULL,
    FALSE,
    FALSE,
    NULL,
    'excel_batch',
    0.8,
    'pending',
    0,
    'supplier_documents/e3ef9b7e-7f5f-48cb-904a-b590bc0ee191/'
);




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
WHERE id = 'e3ef9b7e-7f5f-48cb-904a-b590bc0ee191';

-- Next Steps:
-- 1. Upload documents to Supabase Storage: supplier_documents/e3ef9b7e-7f5f-48cb-904a-b590bc0ee191/
-- 2. Update document paths in supplier_documents table
-- 3. Review and approve supplier

-- Contractor 52: All Emergency Services Limited
-- ============================================================================
-- Supplier Onboarding: All Emergency Services Limited
-- ============================================================================
-- Generated: 2025-10-15 12:25:02
-- Supplier ID: eeda28ac-17fc-4a4e-8307-288e56b3b12a
-- Storage: supplier_documents/eeda28ac-17fc-4a4e-8307-288e56b3b12a/
-- ============================================================================




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
    'eeda28ac-17fc-4a4e-8307-288e56b3b12a',
    'All Emergency Services Limited',
    'Unit 1, Tramsheds Industrial Estate, Coomber Way, Croydon, Surrey, CR0 4TQ',
    'CR0 4TQ',
    'accounts@allemergencyservices.com',
    NULL,
    NULL,
    '30482615',
    '601516',
    NULL,
    FALSE,
    FALSE,
    NULL,
    'excel_batch',
    0.8,
    'pending',
    0,
    'supplier_documents/eeda28ac-17fc-4a4e-8307-288e56b3b12a/'
);




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
WHERE id = 'eeda28ac-17fc-4a4e-8307-288e56b3b12a';

-- Next Steps:
-- 1. Upload documents to Supabase Storage: supplier_documents/eeda28ac-17fc-4a4e-8307-288e56b3b12a/
-- 2. Update document paths in supplier_documents table
-- 3. Review and approve supplier

-- Contractor 53: AESG Limited
-- ============================================================================
-- Supplier Onboarding: AESG Limited
-- ============================================================================
-- Generated: 2025-10-15 12:25:02
-- Supplier ID: e70eba44-dc78-42a4-a8a1-f0ddae2f6be0
-- Storage: supplier_documents/e70eba44-dc78-42a4-a8a1-f0ddae2f6be0/
-- ============================================================================




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
    'e70eba44-dc78-42a4-a8a1-f0ddae2f6be0',
    'AESG Limited',
    '306A Mermaid House, 2 Puddle Dock, London, EC4V 3DS',
    'EC4V 3DS',
    NULL,
    NULL,
    NULL,
    '3833348',
    '209074',
    NULL,
    FALSE,
    FALSE,
    NULL,
    'excel_batch',
    0.8,
    'pending',
    0,
    'supplier_documents/e70eba44-dc78-42a4-a8a1-f0ddae2f6be0/'
);




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
WHERE id = 'e70eba44-dc78-42a4-a8a1-f0ddae2f6be0';

-- Next Steps:
-- 1. Upload documents to Supabase Storage: supplier_documents/e70eba44-dc78-42a4-a8a1-f0ddae2f6be0/
-- 2. Update document paths in supplier_documents table
-- 3. Review and approve supplier

-- Contractor 54: AES Rewinds Limited
-- ============================================================================
-- Supplier Onboarding: AES Rewinds Limited
-- ============================================================================
-- Generated: 2025-10-15 12:25:02
-- Supplier ID: 7ab46456-f561-4488-b6d0-fc7098c9bf00
-- Storage: supplier_documents/7ab46456-f561-4488-b6d0-fc7098c9bf00/
-- ============================================================================




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
    '7ab46456-f561-4488-b6d0-fc7098c9bf00',
    'AES Rewinds Limited',
    'Unit 3 LDL Business Centre, Station Road West, GU12 5 RT',
    'GU12 5 RT',
    'Accounts@AESRewinds.com',
    NULL,
    NULL,
    '81118307',
    '403545',
    NULL,
    FALSE,
    FALSE,
    NULL,
    'excel_batch',
    0.8,
    'pending',
    0,
    'supplier_documents/7ab46456-f561-4488-b6d0-fc7098c9bf00/'
);




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
WHERE id = '7ab46456-f561-4488-b6d0-fc7098c9bf00';

-- Next Steps:
-- 1. Upload documents to Supabase Storage: supplier_documents/7ab46456-f561-4488-b6d0-fc7098c9bf00/
-- 2. Update document paths in supplier_documents table
-- 3. Review and approve supplier

-- Contractor 55: Affiliated Utilities Ltd
-- ============================================================================
-- Supplier Onboarding: Affiliated Utilities Ltd
-- ============================================================================
-- Generated: 2025-10-15 12:25:02
-- Supplier ID: 8deee21f-8f97-4cb5-be1e-d540b4c3cbb7
-- Storage: supplier_documents/8deee21f-8f97-4cb5-be1e-d540b4c3cbb7/
-- ============================================================================




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
    '8deee21f-8f97-4cb5-be1e-d540b4c3cbb7',
    'Affiliated Utilities Ltd',
    'Cussons House, 2nd Floor, 102 Great Clowes Street, Salford, M7 1RN',
    'M7 1RN',
    'info@au-ltd.co.uk',
    NULL,
    NULL,
    '37921777',
    '230580',
    NULL,
    FALSE,
    FALSE,
    NULL,
    'excel_batch',
    0.8,
    'pending',
    0,
    'supplier_documents/8deee21f-8f97-4cb5-be1e-d540b4c3cbb7/'
);




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
WHERE id = '8deee21f-8f97-4cb5-be1e-d540b4c3cbb7';

-- Next Steps:
-- 1. Upload documents to Supabase Storage: supplier_documents/8deee21f-8f97-4cb5-be1e-d540b4c3cbb7/
-- 2. Update document paths in supplier_documents table
-- 3. Review and approve supplier

-- Contractor 56: Affinia
-- ============================================================================
-- Supplier Onboarding: Affinia
-- ============================================================================
-- Generated: 2025-10-15 12:25:02
-- Supplier ID: f3d36919-6e42-4868-a388-4106779959a7
-- Storage: supplier_documents/f3d36919-6e42-4868-a388-4106779959a7/
-- ============================================================================




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
    'f3d36919-6e42-4868-a388-4106779959a7',
    'Affinia',
    '19th Floor, 1 Westfield Avenue, Stratford, London, E20 1HZ',
    'E20 1HZ',
    'creditcontrol@affinia.co.uk',
    NULL,
    NULL,
    '80177883',
    '600606',
    NULL,
    FALSE,
    FALSE,
    NULL,
    'excel_batch',
    0.8,
    'pending',
    0,
    'supplier_documents/f3d36919-6e42-4868-a388-4106779959a7/'
);




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
WHERE id = 'f3d36919-6e42-4868-a388-4106779959a7';

-- Next Steps:
-- 1. Upload documents to Supabase Storage: supplier_documents/f3d36919-6e42-4868-a388-4106779959a7/
-- 2. Update document paths in supplier_documents table
-- 3. Review and approve supplier

-- Contractor 57: Affinity Water
-- ============================================================================
-- Supplier Onboarding: Affinity Water
-- ============================================================================
-- Generated: 2025-10-15 12:25:02
-- Supplier ID: 7b45baa1-2d54-4daf-8b27-b7a6fd7dd0f3
-- Storage: supplier_documents/7b45baa1-2d54-4daf-8b27-b7a6fd7dd0f3/
-- ============================================================================




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
    '7b45baa1-2d54-4daf-8b27-b7a6fd7dd0f3',
    'Affinity Water',
    'Tamblin Way, Hatfield, Hertfordshire, AL10 9EZ',
    'AL10 9EZ',
    NULL,
    NULL,
    NULL,
    '80542903',
    '200503',
    NULL,
    FALSE,
    FALSE,
    NULL,
    'excel_batch',
    0.8,
    'pending',
    0,
    'supplier_documents/7b45baa1-2d54-4daf-8b27-b7a6fd7dd0f3/'
);




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
WHERE id = '7b45baa1-2d54-4daf-8b27-b7a6fd7dd0f3';

-- Next Steps:
-- 1. Upload documents to Supabase Storage: supplier_documents/7b45baa1-2d54-4daf-8b27-b7a6fd7dd0f3/
-- 2. Update document paths in supplier_documents table
-- 3. Review and approve supplier

-- Contractor 58: Alon Friedlander
-- ============================================================================
-- Supplier Onboarding: Alon Friedlander
-- ============================================================================
-- Generated: 2025-10-15 12:25:02
-- Supplier ID: bdcad65e-65fe-44ee-86d1-eb04399cbe10
-- Storage: supplier_documents/bdcad65e-65fe-44ee-86d1-eb04399cbe10/
-- ============================================================================




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
    'bdcad65e-65fe-44ee-86d1-eb04399cbe10',
    'Alon Friedlander',
    'Basement, 14-15 Ennismore Gdns',
    NULL,
    'alon_friedlander@yahoo.com',
    NULL,
    NULL,
    '1684760',
    '40075',
    NULL,
    FALSE,
    FALSE,
    NULL,
    'excel_batch',
    0.8,
    'pending',
    0,
    'supplier_documents/bdcad65e-65fe-44ee-86d1-eb04399cbe10/'
);




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
WHERE id = 'bdcad65e-65fe-44ee-86d1-eb04399cbe10';

-- Next Steps:
-- 1. Upload documents to Supabase Storage: supplier_documents/bdcad65e-65fe-44ee-86d1-eb04399cbe10/
-- 2. Update document paths in supplier_documents table
-- 3. Review and approve supplier

-- Contractor 59: Active Fire Systems Ltd
-- ============================================================================
-- Supplier Onboarding: Active Fire Systems Ltd
-- ============================================================================
-- Generated: 2025-10-15 12:25:02
-- Supplier ID: 49f0993b-8f7a-4acf-bf7e-2f4cb7db0f1f
-- Storage: supplier_documents/49f0993b-8f7a-4acf-bf7e-2f4cb7db0f1f/
-- ============================================================================




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
    '49f0993b-8f7a-4acf-bf7e-2f4cb7db0f1f',
    'Active Fire Systems Ltd',
    'Unit 1 D Garden Road, Bromley, Kent, BR1 3LU',
    'BR1 3LU',
    'admin@activefiresystems.com',
    NULL,
    NULL,
    '46468668',
    '309245',
    NULL,
    FALSE,
    FALSE,
    NULL,
    'excel_batch',
    0.8,
    'pending',
    0,
    'supplier_documents/49f0993b-8f7a-4acf-bf7e-2f4cb7db0f1f/'
);




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
WHERE id = '49f0993b-8f7a-4acf-bf7e-2f4cb7db0f1f';

-- Next Steps:
-- 1. Upload documents to Supabase Storage: supplier_documents/49f0993b-8f7a-4acf-bf7e-2f4cb7db0f1f/
-- 2. Update document paths in supplier_documents table
-- 3. Review and approve supplier

-- Contractor 60: Agent's Army
-- ============================================================================
-- Supplier Onboarding: Agent's Army
-- ============================================================================
-- Generated: 2025-10-15 12:25:02
-- Supplier ID: 1b7eb7c2-26b4-463e-9671-95b4d87cb571
-- Storage: supplier_documents/1b7eb7c2-26b4-463e-9671-95b4d87cb571/
-- ============================================================================




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
    '1b7eb7c2-26b4-463e-9671-95b4d87cb571',
    'Agent''s Army',
    'C/O TMRW @ Davis House, 2 Robert Street, CR0 1QQ',
    'CR0 1QQ',
    'bookings@sgentsarmy.co.uk',
    NULL,
    NULL,
    '1623486',
    '400615',
    NULL,
    FALSE,
    FALSE,
    NULL,
    'excel_batch',
    0.8,
    'pending',
    0,
    'supplier_documents/1b7eb7c2-26b4-463e-9671-95b4d87cb571/'
);




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
WHERE id = '1b7eb7c2-26b4-463e-9671-95b4d87cb571';

-- Next Steps:
-- 1. Upload documents to Supabase Storage: supplier_documents/1b7eb7c2-26b4-463e-9671-95b4d87cb571/
-- 2. Update document paths in supplier_documents table
-- 3. Review and approve supplier

-- Contractor 61: Aquatronic Group Management PLC
-- ============================================================================
-- Supplier Onboarding: Aquatronic Group Management PLC
-- ============================================================================
-- Generated: 2025-10-15 12:25:02
-- Supplier ID: cf705ea9-c09c-4988-a980-9801ef3c4282
-- Storage: supplier_documents/cf705ea9-c09c-4988-a980-9801ef3c4282/
-- ============================================================================




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
    'cf705ea9-c09c-4988-a980-9801ef3c4282',
    'Aquatronic Group Management PLC',
    'AGM House, London Road, Copford, Colchester, CO6 1GT',
    'CO6 1GT',
    'info@agm-plc.co.uk',
    NULL,
    NULL,
    '48193437',
    '600606',
    NULL,
    FALSE,
    FALSE,
    NULL,
    'excel_batch',
    0.8,
    'pending',
    0,
    'supplier_documents/cf705ea9-c09c-4988-a980-9801ef3c4282/'
);




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
WHERE id = 'cf705ea9-c09c-4988-a980-9801ef3c4282';

-- Next Steps:
-- 1. Upload documents to Supabase Storage: supplier_documents/cf705ea9-c09c-4988-a980-9801ef3c4282/
-- 2. Update document paths in supplier_documents table
-- 3. Review and approve supplier

-- Contractor 62: Andrew Grier
-- ============================================================================
-- Supplier Onboarding: Andrew Grier
-- ============================================================================
-- Generated: 2025-10-15 12:25:02
-- Supplier ID: f338e97d-d1cb-4630-b119-29900faea1a8
-- Storage: supplier_documents/f338e97d-d1cb-4630-b119-29900faea1a8/
-- ============================================================================




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
    'f338e97d-d1cb-4630-b119-29900faea1a8',
    'Andrew Grier',
    'c/o Bethwin',
    NULL,
    NULL,
    NULL,
    NULL,
    '673813',
    '835000',
    NULL,
    FALSE,
    FALSE,
    NULL,
    'excel_batch',
    0.8,
    'pending',
    0,
    'supplier_documents/f338e97d-d1cb-4630-b119-29900faea1a8/'
);




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
WHERE id = 'f338e97d-d1cb-4630-b119-29900faea1a8';

-- Next Steps:
-- 1. Upload documents to Supabase Storage: supplier_documents/f338e97d-d1cb-4630-b119-29900faea1a8/
-- 2. Update document paths in supplier_documents table
-- 3. Review and approve supplier

-- Contractor 63: A.H Gardens Ltd
-- ============================================================================
-- Supplier Onboarding: A.H Gardens Ltd
-- ============================================================================
-- Generated: 2025-10-15 12:25:02
-- Supplier ID: ec411d40-6ec5-4a2f-83c0-8b22beec8b92
-- Storage: supplier_documents/ec411d40-6ec5-4a2f-83c0-8b22beec8b92/
-- ============================================================================




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
    'ec411d40-6ec5-4a2f-83c0-8b22beec8b92',
    'A.H Gardens Ltd',
    'Suite 106, 394 Muswell Hill Broadway, London, N10 1DJ',
    'N10 1DJ',
    'aidan@ahgardenservices.co.uk',
    NULL,
    NULL,
    '59806381',
    '608371',
    NULL,
    FALSE,
    FALSE,
    NULL,
    'excel_batch',
    0.8,
    'pending',
    0,
    'supplier_documents/ec411d40-6ec5-4a2f-83c0-8b22beec8b92/'
);




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
WHERE id = 'ec411d40-6ec5-4a2f-83c0-8b22beec8b92';

-- Next Steps:
-- 1. Upload documents to Supabase Storage: supplier_documents/ec411d40-6ec5-4a2f-83c0-8b22beec8b92/
-- 2. Update document paths in supplier_documents table
-- 3. Review and approve supplier

-- Contractor 64: Airborne Environmental Consultants Ltd
-- ============================================================================
-- Supplier Onboarding: Airborne Environmental Consultants Ltd
-- ============================================================================
-- Generated: 2025-10-15 12:25:02
-- Supplier ID: 45e4fcdd-cbf6-4510-8cb2-b81099225356
-- Storage: supplier_documents/45e4fcdd-cbf6-4510-8cb2-b81099225356/
-- ============================================================================




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
    '45e4fcdd-cbf6-4510-8cb2-b81099225356',
    'Airborne Environmental Consultants Ltd',
    '23 Wheel Forge Way, Ashburton Point, Trafford Park, Manchester, M17 1EH',
    'M17 1EH',
    'Nina.Williamson@aec.uk',
    NULL,
    NULL,
    '10729308',
    '90222',
    NULL,
    FALSE,
    FALSE,
    NULL,
    'excel_batch',
    0.8,
    'pending',
    0,
    'supplier_documents/45e4fcdd-cbf6-4510-8cb2-b81099225356/'
);




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
WHERE id = '45e4fcdd-cbf6-4510-8cb2-b81099225356';

-- Next Steps:
-- 1. Upload documents to Supabase Storage: supplier_documents/45e4fcdd-cbf6-4510-8cb2-b81099225356/
-- 2. Update document paths in supplier_documents table
-- 3. Review and approve supplier

-- Contractor 65: Air Cool Engineering
-- ============================================================================
-- Supplier Onboarding: Air Cool Engineering
-- ============================================================================
-- Generated: 2025-10-15 12:25:02
-- Supplier ID: 3627875e-a00c-4eab-8c3c-375113df0bf6
-- Storage: supplier_documents/3627875e-a00c-4eab-8c3c-375113df0bf6/
-- ============================================================================




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
    '3627875e-a00c-4eab-8c3c-375113df0bf6',
    'Air Cool Engineering',
    'Aneurin House, Astonbury Farm,, Aston, Herts, SG2 7EG',
    'SG2 7EG',
    'service@servmain.aircool.co.uk.',
    NULL,
    NULL,
    '39056988',
    '602026',
    NULL,
    FALSE,
    FALSE,
    NULL,
    'excel_batch',
    0.8,
    'pending',
    0,
    'supplier_documents/3627875e-a00c-4eab-8c3c-375113df0bf6/'
);




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
WHERE id = '3627875e-a00c-4eab-8c3c-375113df0bf6';

-- Next Steps:
-- 1. Upload documents to Supabase Storage: supplier_documents/3627875e-a00c-4eab-8c3c-375113df0bf6/
-- 2. Update document paths in supplier_documents table
-- 3. Review and approve supplier

-- Contractor 66: Air Surveys Limited
-- ============================================================================
-- Supplier Onboarding: Air Surveys Limited
-- ============================================================================
-- Generated: 2025-10-15 12:25:02
-- Supplier ID: ca79f186-fbd7-4638-89e5-9f6ff0519d43
-- Storage: supplier_documents/ca79f186-fbd7-4638-89e5-9f6ff0519d43/
-- ============================================================================




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
    'ca79f186-fbd7-4638-89e5-9f6ff0519d43',
    'Air Surveys Limited',
    '2 College Mews, St Ann''s Hill, Wandsworth, London, SW18 2SJ',
    'SW18 2SJ',
    'airsurveysltd@aol.com',
    NULL,
    NULL,
    '37322860',
    '308468',
    NULL,
    FALSE,
    FALSE,
    NULL,
    'excel_batch',
    0.8,
    'pending',
    0,
    'supplier_documents/ca79f186-fbd7-4638-89e5-9f6ff0519d43/'
);




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
WHERE id = 'ca79f186-fbd7-4638-89e5-9f6ff0519d43';

-- Next Steps:
-- 1. Upload documents to Supabase Storage: supplier_documents/ca79f186-fbd7-4638-89e5-9f6ff0519d43/
-- 2. Update document paths in supplier_documents table
-- 3. Review and approve supplier

-- Contractor 67: AJH Cleaning Services
-- ============================================================================
-- Supplier Onboarding: AJH Cleaning Services
-- ============================================================================
-- Generated: 2025-10-15 12:25:02
-- Supplier ID: 218d52d2-6683-43af-a836-7f6be0d029d9
-- Storage: supplier_documents/218d52d2-6683-43af-a836-7f6be0d029d9/
-- ============================================================================




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
    '218d52d2-6683-43af-a836-7f6be0d029d9',
    'AJH Cleaning Services',
    '132 Firtree Road, Banstead, Surrey, SM7 1NH',
    'SM7 1NH',
    'danny.hosier@sky.com',
    NULL,
    NULL,
    '55574270',
    '600801',
    NULL,
    FALSE,
    FALSE,
    NULL,
    'excel_batch',
    0.8,
    'pending',
    0,
    'supplier_documents/218d52d2-6683-43af-a836-7f6be0d029d9/'
);




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
WHERE id = '218d52d2-6683-43af-a836-7f6be0d029d9';

-- Next Steps:
-- 1. Upload documents to Supabase Storage: supplier_documents/218d52d2-6683-43af-a836-7f6be0d029d9/
-- 2. Update document paths in supplier_documents table
-- 3. Review and approve supplier

-- Contractor 68: AJT Plumbing and Heating
-- ============================================================================
-- Supplier Onboarding: AJT Plumbing and Heating
-- ============================================================================
-- Generated: 2025-10-15 12:25:02
-- Supplier ID: f270e85f-51a4-4c2d-bb1c-9f1436650535
-- Storage: supplier_documents/f270e85f-51a4-4c2d-bb1c-9f1436650535/
-- ============================================================================




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
    'f270e85f-51a4-4c2d-bb1c-9f1436650535',
    'AJT Plumbing and Heating',
    '68 Thamesbank Place, Thamesmead, London, SE28 8PS',
    'SE28 8PS',
    'ajtplumbingandheating@hotmail.com',
    NULL,
    NULL,
    '846680',
    '309089',
    NULL,
    FALSE,
    FALSE,
    NULL,
    'excel_batch',
    0.8,
    'pending',
    0,
    'supplier_documents/f270e85f-51a4-4c2d-bb1c-9f1436650535/'
);




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
WHERE id = 'f270e85f-51a4-4c2d-bb1c-9f1436650535';

-- Next Steps:
-- 1. Upload documents to Supabase Storage: supplier_documents/f270e85f-51a4-4c2d-bb1c-9f1436650535/
-- 2. Update document paths in supplier_documents table
-- 3. Review and approve supplier

-- Contractor 69: A.Kapllaj Ltd
-- ============================================================================
-- Supplier Onboarding: A.Kapllaj Ltd
-- ============================================================================
-- Generated: 2025-10-15 12:25:02
-- Supplier ID: ccdb92a7-892d-463c-8f50-90a3e10fd99c
-- Storage: supplier_documents/ccdb92a7-892d-463c-8f50-90a3e10fd99c/
-- ============================================================================




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
    'ccdb92a7-892d-463c-8f50-90a3e10fd99c',
    'A.Kapllaj Ltd',
    '52 Mark Road, London, N22 6PX',
    'N22 6PX',
    'akapllaj123@gmail.com',
    NULL,
    NULL,
    '23613828',
    '206915',
    NULL,
    FALSE,
    FALSE,
    NULL,
    'excel_batch',
    0.8,
    'pending',
    0,
    'supplier_documents/ccdb92a7-892d-463c-8f50-90a3e10fd99c/'
);




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
WHERE id = 'ccdb92a7-892d-463c-8f50-90a3e10fd99c';

-- Next Steps:
-- 1. Upload documents to Supabase Storage: supplier_documents/ccdb92a7-892d-463c-8f50-90a3e10fd99c/
-- 2. Update document paths in supplier_documents table
-- 3. Review and approve supplier

-- Contractor 70: AKA Sparks Electrical Contractors Ltd
-- ============================================================================
-- Supplier Onboarding: AKA Sparks Electrical Contractors Ltd
-- ============================================================================
-- Generated: 2025-10-15 12:25:02
-- Supplier ID: 4935f205-2d99-4d52-81b9-596e7e4197dd
-- Storage: supplier_documents/4935f205-2d99-4d52-81b9-596e7e4197dd/
-- ============================================================================




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
    '4935f205-2d99-4d52-81b9-596e7e4197dd',
    'AKA Sparks Electrical Contractors Ltd',
    '20 Stephenson Road, London, E17 7LE',
    'E17 7LE',
    'info@akasparkselectrical.co.uk',
    NULL,
    NULL,
    '19057187',
    '90129',
    NULL,
    FALSE,
    FALSE,
    NULL,
    'excel_batch',
    0.8,
    'pending',
    0,
    'supplier_documents/4935f205-2d99-4d52-81b9-596e7e4197dd/'
);




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
WHERE id = '4935f205-2d99-4d52-81b9-596e7e4197dd';

-- Next Steps:
-- 1. Upload documents to Supabase Storage: supplier_documents/4935f205-2d99-4d52-81b9-596e7e4197dd/
-- 2. Update document paths in supplier_documents table
-- 3. Review and approve supplier

-- Contractor 71: AKB CONTRACTORS LTD
-- ============================================================================
-- Supplier Onboarding: AKB CONTRACTORS LTD
-- ============================================================================
-- Generated: 2025-10-15 12:25:02
-- Supplier ID: 61290d7b-e0f8-45f1-98ea-4d4000e267db
-- Storage: supplier_documents/61290d7b-e0f8-45f1-98ea-4d4000e267db/
-- ============================================================================




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
    '61290d7b-e0f8-45f1-98ea-4d4000e267db',
    'AKB CONTRACTORS LTD',
    'Ferneberga House, Alexandra Road, Farnborough, Hampshire, GU14 6DQ',
    'GU14 6DQ',
    'akbcontractors@btconnect.com',
    NULL,
    NULL,
    '11395564',
    '402734',
    NULL,
    FALSE,
    FALSE,
    NULL,
    'excel_batch',
    0.8,
    'pending',
    0,
    'supplier_documents/61290d7b-e0f8-45f1-98ea-4d4000e267db/'
);




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
WHERE id = '61290d7b-e0f8-45f1-98ea-4d4000e267db';

-- Next Steps:
-- 1. Upload documents to Supabase Storage: supplier_documents/61290d7b-e0f8-45f1-98ea-4d4000e267db/
-- 2. Update document paths in supplier_documents table
-- 3. Review and approve supplier

-- Contractor 72: AK Fire Ltd
-- ============================================================================
-- Supplier Onboarding: AK Fire Ltd
-- ============================================================================
-- Generated: 2025-10-15 12:25:02
-- Supplier ID: db6df24e-296c-4150-969f-aaa28e6157c9
-- Storage: supplier_documents/db6df24e-296c-4150-969f-aaa28e6157c9/
-- ============================================================================




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
    'db6df24e-296c-4150-969f-aaa28e6157c9',
    'AK Fire Ltd',
    '28 Woodford Road, Watford, WD17 1PA',
    'WD17 1PA',
    'jacob@akfire.co.uk',
    NULL,
    NULL,
    '41114736',
    '602034',
    NULL,
    FALSE,
    FALSE,
    NULL,
    'excel_batch',
    0.8,
    'pending',
    0,
    'supplier_documents/db6df24e-296c-4150-969f-aaa28e6157c9/'
);




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
WHERE id = 'db6df24e-296c-4150-969f-aaa28e6157c9';

-- Next Steps:
-- 1. Upload documents to Supabase Storage: supplier_documents/db6df24e-296c-4150-969f-aaa28e6157c9/
-- 2. Update document paths in supplier_documents table
-- 3. Review and approve supplier

-- Contractor 73: A-KHANDEHROY
-- ============================================================================
-- Supplier Onboarding: A-KHANDEHROY
-- ============================================================================
-- Generated: 2025-10-15 12:25:02
-- Supplier ID: e08e4372-1eef-45ab-85bf-2f87a1393cb5
-- Storage: supplier_documents/e08e4372-1eef-45ab-85bf-2f87a1393cb5/
-- ============================================================================




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
    'e08e4372-1eef-45ab-85bf-2f87a1393cb5',
    'A-KHANDEHROY',
    '3 Moat Farm Road, Northolt, UB5 5DR',
    'UB5 5DR',
    'Aanda4@hotmail.co.uk',
    NULL,
    NULL,
    '10498866',
    '110422',
    NULL,
    FALSE,
    FALSE,
    NULL,
    'excel_batch',
    0.8,
    'pending',
    0,
    'supplier_documents/e08e4372-1eef-45ab-85bf-2f87a1393cb5/'
);




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
WHERE id = 'e08e4372-1eef-45ab-85bf-2f87a1393cb5';

-- Next Steps:
-- 1. Upload documents to Supabase Storage: supplier_documents/e08e4372-1eef-45ab-85bf-2f87a1393cb5/
-- 2. Update document paths in supplier_documents table
-- 3. Review and approve supplier

-- Contractor 74: A.K LOCKSMITHS LTD
-- ============================================================================
-- Supplier Onboarding: A.K LOCKSMITHS LTD
-- ============================================================================
-- Generated: 2025-10-15 12:25:02
-- Supplier ID: 330ad310-ccd4-441d-a01a-e2ac22d196f1
-- Storage: supplier_documents/330ad310-ccd4-441d-a01a-e2ac22d196f1/
-- ============================================================================




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
    '330ad310-ccd4-441d-a01a-e2ac22d196f1',
    'A.K LOCKSMITHS LTD',
    '56 MILL LANE, WEST HAMPSTEAD, LONDON, NW6 1NJ',
    'NW6 1NJ',
    NULL,
    NULL,
    NULL,
    '50106534',
    '207463',
    NULL,
    FALSE,
    FALSE,
    NULL,
    'excel_batch',
    0.8,
    'pending',
    0,
    'supplier_documents/330ad310-ccd4-441d-a01a-e2ac22d196f1/'
);




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
WHERE id = '330ad310-ccd4-441d-a01a-e2ac22d196f1';

-- Next Steps:
-- 1. Upload documents to Supabase Storage: supplier_documents/330ad310-ccd4-441d-a01a-e2ac22d196f1/
-- 2. Update document paths in supplier_documents table
-- 3. Review and approve supplier

-- Contractor 75: A K Locksmiths
-- ============================================================================
-- Supplier Onboarding: A K Locksmiths
-- ============================================================================
-- Generated: 2025-10-15 12:25:02
-- Supplier ID: c30f3d8d-b4a4-4a9a-bd22-fd8f789d823b
-- Storage: supplier_documents/c30f3d8d-b4a4-4a9a-bd22-fd8f789d823b/
-- ============================================================================




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
    'c30f3d8d-b4a4-4a9a-bd22-fd8f789d823b',
    'A K Locksmiths',
    'Flat 8 Hadleyvale Court, 114-116 Hadley Road, Barnet, Hertfordshire, EN5 5QY',
    'EN5 5QY',
    'aklocksmiths@gmail.com',
    '07944 168937',
    NULL,
    '3369910',
    '90128',
    NULL,
    FALSE,
    FALSE,
    NULL,
    'excel_batch',
    0.8,
    'pending',
    0,
    'supplier_documents/c30f3d8d-b4a4-4a9a-bd22-fd8f789d823b/'
);




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
WHERE id = 'c30f3d8d-b4a4-4a9a-bd22-fd8f789d823b';

-- Next Steps:
-- 1. Upload documents to Supabase Storage: supplier_documents/c30f3d8d-b4a4-4a9a-bd22-fd8f789d823b/
-- 2. Update document paths in supplier_documents table
-- 3. Review and approve supplier

-- Contractor 76: Alan Boswell Insurance Brokers Limited
-- ============================================================================
-- Supplier Onboarding: Alan Boswell Insurance Brokers Limited
-- ============================================================================
-- Generated: 2025-10-15 12:25:02
-- Supplier ID: 907a5356-99f3-4bda-8f68-c8a9ea84df4f
-- Storage: supplier_documents/907a5356-99f3-4bda-8f68-c8a9ea84df4f/
-- ============================================================================




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
    '907a5356-99f3-4bda-8f68-c8a9ea84df4f',
    'Alan Boswell Insurance Brokers Limited',
    'Suites 5/6 East Barton Barns,, Great Barton, Bury St Edmunds, IP31 2QY',
    'IP31 2QY',
    'bury@alanboswell.com',
    NULL,
    NULL,
    '60151971',
    '206261',
    NULL,
    FALSE,
    FALSE,
    NULL,
    'excel_batch',
    0.8,
    'pending',
    0,
    'supplier_documents/907a5356-99f3-4bda-8f68-c8a9ea84df4f/'
);




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
WHERE id = '907a5356-99f3-4bda-8f68-c8a9ea84df4f';

-- Next Steps:
-- 1. Upload documents to Supabase Storage: supplier_documents/907a5356-99f3-4bda-8f68-c8a9ea84df4f/
-- 2. Update document paths in supplier_documents table
-- 3. Review and approve supplier

-- Contractor 77: Alban Fire Protection Limited
-- ============================================================================
-- Supplier Onboarding: Alban Fire Protection Limited
-- ============================================================================
-- Generated: 2025-10-15 12:25:02
-- Supplier ID: 276f1709-4c33-4c03-8f31-2947945c53cc
-- Storage: supplier_documents/276f1709-4c33-4c03-8f31-2947945c53cc/
-- ============================================================================




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
    '276f1709-4c33-4c03-8f31-2947945c53cc',
    'Alban Fire Protection Limited',
    '8 Harefield Place, St. Albans, AL4 9JQ',
    'AL4 9JQ',
    'albanfire@virginmedia.com',
    NULL,
    NULL,
    '82987957',
    '90128',
    NULL,
    FALSE,
    FALSE,
    NULL,
    'excel_batch',
    0.8,
    'pending',
    0,
    'supplier_documents/276f1709-4c33-4c03-8f31-2947945c53cc/'
);




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
WHERE id = '276f1709-4c33-4c03-8f31-2947945c53cc';

-- Next Steps:
-- 1. Upload documents to Supabase Storage: supplier_documents/276f1709-4c33-4c03-8f31-2947945c53cc/
-- 2. Update document paths in supplier_documents table
-- 3. Review and approve supplier

-- Contractor 78: Albany Pest Control
-- ============================================================================
-- Supplier Onboarding: Albany Pest Control
-- ============================================================================
-- Generated: 2025-10-15 12:25:02
-- Supplier ID: 74bd0080-2995-4e47-ad6d-3089703d03b8
-- Storage: supplier_documents/74bd0080-2995-4e47-ad6d-3089703d03b8/
-- ============================================================================




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
    '74bd0080-2995-4e47-ad6d-3089703d03b8',
    'Albany Pest Control',
    '22 Bloomsbury Square, London, WC1A 2NS',
    'WC1A 2NS',
    'creditcontroller@albanypestcontrol.co.uk',
    NULL,
    NULL,
    '593696',
    '301330',
    NULL,
    FALSE,
    FALSE,
    NULL,
    'excel_batch',
    0.8,
    'pending',
    0,
    'supplier_documents/74bd0080-2995-4e47-ad6d-3089703d03b8/'
);




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
WHERE id = '74bd0080-2995-4e47-ad6d-3089703d03b8';

-- Next Steps:
-- 1. Upload documents to Supabase Storage: supplier_documents/74bd0080-2995-4e47-ad6d-3089703d03b8/
-- 2. Update document paths in supplier_documents table
-- 3. Review and approve supplier

-- Contractor 79: Albany Environmental Services Limited
-- ============================================================================
-- Supplier Onboarding: Albany Environmental Services Limited
-- ============================================================================
-- Generated: 2025-10-15 12:25:02
-- Supplier ID: 06f204f2-90cf-4097-b28b-e6748a16b159
-- Storage: supplier_documents/06f204f2-90cf-4097-b28b-e6748a16b159/
-- ============================================================================




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
    '06f204f2-90cf-4097-b28b-e6748a16b159',
    'Albany Environmental Services Limited',
    '2nd Floor, 87-91 Springfield Road, Chelmsford, Essex, CM2 6JL',
    'CM2 6JL',
    'info@albanypestcontrol.co.uk',
    NULL,
    NULL,
    '593696',
    '301330',
    NULL,
    FALSE,
    FALSE,
    NULL,
    'excel_batch',
    0.8,
    'pending',
    0,
    'supplier_documents/06f204f2-90cf-4097-b28b-e6748a16b159/'
);




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
WHERE id = '06f204f2-90cf-4097-b28b-e6748a16b159';

-- Next Steps:
-- 1. Upload documents to Supabase Storage: supplier_documents/06f204f2-90cf-4097-b28b-e6748a16b159/
-- 2. Update document paths in supplier_documents table
-- 3. Review and approve supplier

-- Contractor 80: Alexander & Co (Accountancy) Limited
-- ============================================================================
-- Supplier Onboarding: Alexander & Co (Accountancy) Limited
-- ============================================================================
-- Generated: 2025-10-15 12:25:02
-- Supplier ID: 193d62b3-d3db-46ca-a2bc-261b2ad5fc1e
-- Storage: supplier_documents/193d62b3-d3db-46ca-a2bc-261b2ad5fc1e/
-- ============================================================================




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
    '193d62b3-d3db-46ca-a2bc-261b2ad5fc1e',
    'Alexander & Co (Accountancy) Limited',
    '7 Murray Crescent, Pinner, Middlesex, HA5 3QF',
    'HA5 3QF',
    'alexanderaccounts@live.co.uk',
    NULL,
    NULL,
    '41444119',
    '90666',
    NULL,
    FALSE,
    FALSE,
    NULL,
    'excel_batch',
    0.8,
    'pending',
    0,
    'supplier_documents/193d62b3-d3db-46ca-a2bc-261b2ad5fc1e/'
);




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
WHERE id = '193d62b3-d3db-46ca-a2bc-261b2ad5fc1e';

-- Next Steps:
-- 1. Upload documents to Supabase Storage: supplier_documents/193d62b3-d3db-46ca-a2bc-261b2ad5fc1e/
-- 2. Update document paths in supplier_documents table
-- 3. Review and approve supplier

-- Contractor 81: Alexander Miller Ltd
-- ============================================================================
-- Supplier Onboarding: Alexander Miller Ltd
-- ============================================================================
-- Generated: 2025-10-15 12:25:02
-- Supplier ID: 384ad6a1-416f-4f17-9a3c-48abb8a0f09c
-- Storage: supplier_documents/384ad6a1-416f-4f17-9a3c-48abb8a0f09c/
-- ============================================================================




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
    '384ad6a1-416f-4f17-9a3c-48abb8a0f09c',
    'Alexander Miller Ltd',
    'Ground Floor, 6 Square Rigger Row, Plantation Wharf, London, SW11 3TZ',
    'SW11 3TZ',
    NULL,
    NULL,
    NULL,
    '32056192',
    '604005',
    NULL,
    FALSE,
    FALSE,
    NULL,
    'excel_batch',
    0.8,
    'pending',
    0,
    'supplier_documents/384ad6a1-416f-4f17-9a3c-48abb8a0f09c/'
);




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
WHERE id = '384ad6a1-416f-4f17-9a3c-48abb8a0f09c';

-- Next Steps:
-- 1. Upload documents to Supabase Storage: supplier_documents/384ad6a1-416f-4f17-9a3c-48abb8a0f09c/
-- 2. Update document paths in supplier_documents table
-- 3. Review and approve supplier

-- Contractor 82: AD Smith
-- ============================================================================
-- Supplier Onboarding: AD Smith
-- ============================================================================
-- Generated: 2025-10-15 12:25:02
-- Supplier ID: b03c7b87-4a7e-4d59-b875-6eee4f2f7eea
-- Storage: supplier_documents/b03c7b87-4a7e-4d59-b875-6eee4f2f7eea/
-- ============================================================================




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
    'b03c7b87-4a7e-4d59-b875-6eee4f2f7eea',
    'AD Smith',
    'Underhill House, Racecourse Road, Shropshire, SY10 7PN',
    'SY10 7PN',
    'alex@underhillhouse.net',
    NULL,
    NULL,
    '22217353',
    '90126',
    NULL,
    FALSE,
    FALSE,
    NULL,
    'excel_batch',
    0.8,
    'pending',
    0,
    'supplier_documents/b03c7b87-4a7e-4d59-b875-6eee4f2f7eea/'
);




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
WHERE id = 'b03c7b87-4a7e-4d59-b875-6eee4f2f7eea';

-- Next Steps:
-- 1. Upload documents to Supabase Storage: supplier_documents/b03c7b87-4a7e-4d59-b875-6eee4f2f7eea/
-- 2. Update document paths in supplier_documents table
-- 3. Review and approve supplier

-- Contractor 83: All About Gates & Automation Ltd
-- ============================================================================
-- Supplier Onboarding: All About Gates & Automation Ltd
-- ============================================================================
-- Generated: 2025-10-15 12:25:02
-- Supplier ID: 6021221d-a491-4820-b518-9afa20076c07
-- Storage: supplier_documents/6021221d-a491-4820-b518-9afa20076c07/
-- ============================================================================




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
    '6021221d-a491-4820-b518-9afa20076c07',
    'All About Gates & Automation Ltd',
    'Unit 5 Brownings Farm, Gravel Lane, Chigwell, Essex, IG7 6DQ',
    'IG7 6DQ',
    'Allaboutgates@outlook.com',
    NULL,
    NULL,
    '82210160',
    '309713',
    NULL,
    FALSE,
    FALSE,
    NULL,
    'excel_batch',
    0.8,
    'pending',
    0,
    'supplier_documents/6021221d-a491-4820-b518-9afa20076c07/'
);




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
WHERE id = '6021221d-a491-4820-b518-9afa20076c07';

-- Next Steps:
-- 1. Upload documents to Supabase Storage: supplier_documents/6021221d-a491-4820-b518-9afa20076c07/
-- 2. Update document paths in supplier_documents table
-- 3. Review and approve supplier

-- Contractor 84: Allan Watson Electrical Ltd
-- ============================================================================
-- Supplier Onboarding: Allan Watson Electrical Ltd
-- ============================================================================
-- Generated: 2025-10-15 12:25:02
-- Supplier ID: 5e961619-c77f-412a-93d8-3bb49840cd57
-- Storage: supplier_documents/5e961619-c77f-412a-93d8-3bb49840cd57/
-- ============================================================================




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
    '5e961619-c77f-412a-93d8-3bb49840cd57',
    'Allan Watson Electrical Ltd',
    '39 GROSVENOR GARDENS, Oakwood, London, NI4 4TU',
    'NI4 4TU',
    'awelectrical@aol.com',
    NULL,
    NULL,
    '90265985',
    '202977',
    NULL,
    FALSE,
    FALSE,
    NULL,
    'excel_batch',
    0.8,
    'pending',
    0,
    'supplier_documents/5e961619-c77f-412a-93d8-3bb49840cd57/'
);




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
WHERE id = '5e961619-c77f-412a-93d8-3bb49840cd57';

-- Next Steps:
-- 1. Upload documents to Supabase Storage: supplier_documents/5e961619-c77f-412a-93d8-3bb49840cd57/
-- 2. Update document paths in supplier_documents table
-- 3. Review and approve supplier

-- Contractor 85: All Aspects Home Maintenance
-- ============================================================================
-- Supplier Onboarding: All Aspects Home Maintenance
-- ============================================================================
-- Generated: 2025-10-15 12:25:02
-- Supplier ID: 4900bbeb-6ddc-4361-ad50-afa988012d2f
-- Storage: supplier_documents/4900bbeb-6ddc-4361-ad50-afa988012d2f/
-- ============================================================================




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
    '4900bbeb-6ddc-4361-ad50-afa988012d2f',
    'All Aspects Home Maintenance',
    '24 Ridgsway East, Sidcup, Kent, DA15 8RZ',
    'DA15 8RZ',
    'Tony.p@hotmail.com',
    NULL,
    NULL,
    '72976768',
    '779144',
    NULL,
    FALSE,
    FALSE,
    NULL,
    'excel_batch',
    0.8,
    'pending',
    0,
    'supplier_documents/4900bbeb-6ddc-4361-ad50-afa988012d2f/'
);




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
WHERE id = '4900bbeb-6ddc-4361-ad50-afa988012d2f';

-- Next Steps:
-- 1. Upload documents to Supabase Storage: supplier_documents/4900bbeb-6ddc-4361-ad50-afa988012d2f/
-- 2. Update document paths in supplier_documents table
-- 3. Review and approve supplier

-- Contractor 86: Allen and Brown Ltd
-- ============================================================================
-- Supplier Onboarding: Allen and Brown Ltd
-- ============================================================================
-- Generated: 2025-10-15 12:25:02
-- Supplier ID: 98fa6607-d325-4d5d-b76a-d0f32dba23b9
-- Storage: supplier_documents/98fa6607-d325-4d5d-b76a-d0f32dba23b9/
-- ============================================================================




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
    '98fa6607-d325-4d5d-b76a-d0f32dba23b9',
    'Allen and Brown Ltd',
    'Office 1 Choles Yard, 284 High Road, North Weald, Essex, CM166EG¶',
    'CM166EG¶',
    'info@allenandbrown.com',
    NULL,
    NULL,
    '13435946',
    '202986',
    NULL,
    FALSE,
    FALSE,
    NULL,
    'excel_batch',
    0.8,
    'pending',
    0,
    'supplier_documents/98fa6607-d325-4d5d-b76a-d0f32dba23b9/'
);




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
WHERE id = '98fa6607-d325-4d5d-b76a-d0f32dba23b9';

-- Next Steps:
-- 1. Upload documents to Supabase Storage: supplier_documents/98fa6607-d325-4d5d-b76a-d0f32dba23b9/
-- 2. Update document paths in supplier_documents table
-- 3. Review and approve supplier

-- Contractor 87: Allium Environmental Ltd
-- ============================================================================
-- Supplier Onboarding: Allium Environmental Ltd
-- ============================================================================
-- Generated: 2025-10-15 12:25:02
-- Supplier ID: 07a5f841-c0a5-4707-81ae-b05f2c4037e9
-- Storage: supplier_documents/07a5f841-c0a5-4707-81ae-b05f2c4037e9/
-- ============================================================================




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
    '07a5f841-c0a5-4707-81ae-b05f2c4037e9',
    'Allium Environmental Ltd',
    'Baldhu House, Wheal Jane Earth Science Park, Baldhu, Truro, Cornwall, TR3 6EH',
    'TR3 6EH',
    'accounts@allium.uk.net',
    NULL,
    NULL,
    '10862607',
    '163320',
    NULL,
    FALSE,
    FALSE,
    NULL,
    'excel_batch',
    0.8,
    'pending',
    0,
    'supplier_documents/07a5f841-c0a5-4707-81ae-b05f2c4037e9/'
);




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
WHERE id = '07a5f841-c0a5-4707-81ae-b05f2c4037e9';

-- Next Steps:
-- 1. Upload documents to Supabase Storage: supplier_documents/07a5f841-c0a5-4707-81ae-b05f2c4037e9/
-- 2. Update document paths in supplier_documents table
-- 3. Review and approve supplier

-- Contractor 88: All services for you
-- ============================================================================
-- Supplier Onboarding: All services for you
-- ============================================================================
-- Generated: 2025-10-15 12:25:02
-- Supplier ID: a1c920d8-d08f-4fc3-8904-bd47e0698b2d
-- Storage: supplier_documents/a1c920d8-d08f-4fc3-8904-bd47e0698b2d/
-- ============================================================================




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
    'a1c920d8-d08f-4fc3-8904-bd47e0698b2d',
    'All services for you',
    '37 Church Hill Road, London, EN 4 8SY',
    'EN 4 8SY',
    'accounts@allservices4u.co.uk',
    NULL,
    NULL,
    '41015346',
    '404725',
    NULL,
    FALSE,
    FALSE,
    NULL,
    'excel_batch',
    0.8,
    'pending',
    0,
    'supplier_documents/a1c920d8-d08f-4fc3-8904-bd47e0698b2d/'
);




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
WHERE id = 'a1c920d8-d08f-4fc3-8904-bd47e0698b2d';

-- Next Steps:
-- 1. Upload documents to Supabase Storage: supplier_documents/a1c920d8-d08f-4fc3-8904-bd47e0698b2d/
-- 2. Update document paths in supplier_documents table
-- 3. Review and approve supplier

-- Contractor 89: Allsop & Francis LTD
-- ============================================================================
-- Supplier Onboarding: Allsop & Francis LTD
-- ============================================================================
-- Generated: 2025-10-15 12:25:02
-- Supplier ID: 07a4ec21-9544-42fb-94d8-000681b14e49
-- Storage: supplier_documents/07a4ec21-9544-42fb-94d8-000681b14e49/
-- ============================================================================




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
    '07a4ec21-9544-42fb-94d8-000681b14e49',
    'Allsop & Francis LTD',
    'Unit 18, Ford Lane Business Park, Ford, Nr. Arundel, West Sussex, BN18 0UZ',
    'BN18 0UZ',
    'accounts@allsopandfrancis.com',
    NULL,
    NULL,
    '20537484',
    '600524',
    NULL,
    FALSE,
    FALSE,
    NULL,
    'excel_batch',
    0.8,
    'pending',
    0,
    'supplier_documents/07a4ec21-9544-42fb-94d8-000681b14e49/'
);




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
WHERE id = '07a4ec21-9544-42fb-94d8-000681b14e49';

-- Next Steps:
-- 1. Upload documents to Supabase Storage: supplier_documents/07a4ec21-9544-42fb-94d8-000681b14e49/
-- 2. Update document paths in supplier_documents table
-- 3. Review and approve supplier

-- Contractor 90: Alltrade Contractors Ltd
-- ============================================================================
-- Supplier Onboarding: Alltrade Contractors Ltd
-- ============================================================================
-- Generated: 2025-10-15 12:25:02
-- Supplier ID: 45494979-7dab-4531-a5d3-f2d7b1070737
-- Storage: supplier_documents/45494979-7dab-4531-a5d3-f2d7b1070737/
-- ============================================================================




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
    '45494979-7dab-4531-a5d3-f2d7b1070737',
    'Alltrade Contractors Ltd',
    'Suite22, 30 Churchill Square, Kings Hill, West Malling, Kent, ME19 4YU',
    'ME19 4YU',
    'info@alltradecontractors.co.uk',
    '07905 458661',
    NULL,
    '73556475',
    '601603',
    NULL,
    FALSE,
    FALSE,
    NULL,
    'excel_batch',
    0.8,
    'pending',
    0,
    'supplier_documents/45494979-7dab-4531-a5d3-f2d7b1070737/'
);




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
WHERE id = '45494979-7dab-4531-a5d3-f2d7b1070737';

-- Next Steps:
-- 1. Upload documents to Supabase Storage: supplier_documents/45494979-7dab-4531-a5d3-f2d7b1070737/
-- 2. Update document paths in supplier_documents table
-- 3. Review and approve supplier

-- Contractor 91: ALL WASTE Rubbish Removal
-- ============================================================================
-- Supplier Onboarding: ALL WASTE Rubbish Removal
-- ============================================================================
-- Generated: 2025-10-15 12:25:02
-- Supplier ID: ce19f58a-de27-42d2-b0b8-27cebed4b172
-- Storage: supplier_documents/ce19f58a-de27-42d2-b0b8-27cebed4b172/
-- ============================================================================




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
    'ce19f58a-de27-42d2-b0b8-27cebed4b172',
    'ALL WASTE Rubbish Removal',
    NULL,
    NULL,
    'drtradersltd@invoicehome.com',
    NULL,
    NULL,
    '23807866',
    '230580',
    NULL,
    FALSE,
    FALSE,
    NULL,
    'excel_batch',
    0.8,
    'pending',
    0,
    'supplier_documents/ce19f58a-de27-42d2-b0b8-27cebed4b172/'
);




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
WHERE id = 'ce19f58a-de27-42d2-b0b8-27cebed4b172';

-- Next Steps:
-- 1. Upload documents to Supabase Storage: supplier_documents/ce19f58a-de27-42d2-b0b8-27cebed4b172/
-- 2. Update document paths in supplier_documents table
-- 3. Review and approve supplier

-- Contractor 92: All Year Gardens Ltd
-- ============================================================================
-- Supplier Onboarding: All Year Gardens Ltd
-- ============================================================================
-- Generated: 2025-10-15 12:25:02
-- Supplier ID: f5f28952-e193-436d-90d0-060d67eb1065
-- Storage: supplier_documents/f5f28952-e193-436d-90d0-060d67eb1065/
-- ============================================================================




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
    'f5f28952-e193-436d-90d0-060d67eb1065',
    'All Year Gardens Ltd',
    'Chilmington Green Road, Ashford, Kent, TN23 3DL',
    'TN23 3DL',
    'info@allyeargardens.co.uk',
    NULL,
    NULL,
    '51503611',
    '600121',
    NULL,
    FALSE,
    FALSE,
    NULL,
    'excel_batch',
    0.8,
    'pending',
    0,
    'supplier_documents/f5f28952-e193-436d-90d0-060d67eb1065/'
);




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
WHERE id = 'f5f28952-e193-436d-90d0-060d67eb1065';

-- Next Steps:
-- 1. Upload documents to Supabase Storage: supplier_documents/f5f28952-e193-436d-90d0-060d67eb1065/
-- 2. Update document paths in supplier_documents table
-- 3. Review and approve supplier

-- Contractor 93: All your junk Ltd
-- ============================================================================
-- Supplier Onboarding: All your junk Ltd
-- ============================================================================
-- Generated: 2025-10-15 12:25:02
-- Supplier ID: 0748032d-98bf-4cb2-91cd-dbe9c59c0fe7
-- Storage: supplier_documents/0748032d-98bf-4cb2-91cd-dbe9c59c0fe7/
-- ============================================================================




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
    '0748032d-98bf-4cb2-91cd-dbe9c59c0fe7',
    'All your junk Ltd',
    '82 Manor Drive, Epsom, KT19 0ET',
    'KT19 0ET',
    'info@allyourjunk.co.uk',
    NULL,
    NULL,
    '11392174',
    '404630',
    NULL,
    FALSE,
    FALSE,
    NULL,
    'excel_batch',
    0.8,
    'pending',
    0,
    'supplier_documents/0748032d-98bf-4cb2-91cd-dbe9c59c0fe7/'
);




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
WHERE id = '0748032d-98bf-4cb2-91cd-dbe9c59c0fe7';

-- Next Steps:
-- 1. Upload documents to Supabase Storage: supplier_documents/0748032d-98bf-4cb2-91cd-dbe9c59c0fe7/
-- 2. Update document paths in supplier_documents table
-- 3. Review and approve supplier

-- Contractor 94: AlphaSure
-- ============================================================================
-- Supplier Onboarding: AlphaSure
-- ============================================================================
-- Generated: 2025-10-15 12:25:02
-- Supplier ID: b18b8da5-0072-4dc4-9422-5c302e699f97
-- Storage: supplier_documents/b18b8da5-0072-4dc4-9422-5c302e699f97/
-- ============================================================================




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
    'b18b8da5-0072-4dc4-9422-5c302e699f97',
    'AlphaSure',
    '41 Walpole Road, London, E18 2LN',
    'E18 2LN',
    'rob@alphasure.co.uk',
    '07961 930393',
    NULL,
    '25794234',
    '404761',
    NULL,
    FALSE,
    FALSE,
    NULL,
    'excel_batch',
    0.8,
    'pending',
    0,
    'supplier_documents/b18b8da5-0072-4dc4-9422-5c302e699f97/'
);




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
WHERE id = 'b18b8da5-0072-4dc4-9422-5c302e699f97';

-- Next Steps:
-- 1. Upload documents to Supabase Storage: supplier_documents/b18b8da5-0072-4dc4-9422-5c302e699f97/
-- 2. Update document paths in supplier_documents table
-- 3. Review and approve supplier

-- Contractor 95: X - Alro Supply Company
-- ============================================================================
-- Supplier Onboarding: X - Alro Supply Company
-- ============================================================================
-- Generated: 2025-10-15 12:25:02
-- Supplier ID: 6295e6f2-91aa-4680-830f-17a262c8d033
-- Storage: supplier_documents/6295e6f2-91aa-4680-830f-17a262c8d033/
-- ============================================================================




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
    '6295e6f2-91aa-4680-830f-17a262c8d033',
    'X - Alro Supply Company',
    '68 Pine Ridge, Carshalton, Surrey, SM5 4QH',
    'SM5 4QH',
    'aandrthomson@btinternet.com',
    NULL,
    NULL,
    '923136',
    '309836',
    NULL,
    FALSE,
    FALSE,
    NULL,
    'excel_batch',
    0.8,
    'pending',
    0,
    'supplier_documents/6295e6f2-91aa-4680-830f-17a262c8d033/'
);




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
WHERE id = '6295e6f2-91aa-4680-830f-17a262c8d033';

-- Next Steps:
-- 1. Upload documents to Supabase Storage: supplier_documents/6295e6f2-91aa-4680-830f-17a262c8d033/
-- 2. Update document paths in supplier_documents table
-- 3. Review and approve supplier

-- Contractor 96: Altus Technical Services Limited
-- ============================================================================
-- Supplier Onboarding: Altus Technical Services Limited
-- ============================================================================
-- Generated: 2025-10-15 12:25:02
-- Supplier ID: 8c8567e5-4e73-4163-b39b-25edca594d2f
-- Storage: supplier_documents/8c8567e5-4e73-4163-b39b-25edca594d2f/
-- ============================================================================




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
    '8c8567e5-4e73-4163-b39b-25edca594d2f',
    'Altus Technical Services Limited',
    'Soane Point, 6-8 Market Place, Reading, RG1 2EG',
    'RG1 2EG',
    'info@altussafety.co.uk',
    '07918 400192',
    NULL,
    '83817652',
    '202950',
    NULL,
    FALSE,
    FALSE,
    NULL,
    'excel_batch',
    0.8,
    'pending',
    0,
    'supplier_documents/8c8567e5-4e73-4163-b39b-25edca594d2f/'
);




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
WHERE id = '8c8567e5-4e73-4163-b39b-25edca594d2f';

-- Next Steps:
-- 1. Upload documents to Supabase Storage: supplier_documents/8c8567e5-4e73-4163-b39b-25edca594d2f/
-- 2. Update document paths in supplier_documents table
-- 3. Review and approve supplier

-- Contractor 97: Andrew Morton Associates Ltd
-- ============================================================================
-- Supplier Onboarding: Andrew Morton Associates Ltd
-- ============================================================================
-- Generated: 2025-10-15 12:25:02
-- Supplier ID: 026e25b6-8836-46a5-bf9f-0d63ce49696e
-- Storage: supplier_documents/026e25b6-8836-46a5-bf9f-0d63ce49696e/
-- ============================================================================




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
    '026e25b6-8836-46a5-bf9f-0d63ce49696e',
    'Andrew Morton Associates Ltd',
    'The Maltings, Malthouse Farm, The Street, Oulton, Norfolk',
    NULL,
    NULL,
    NULL,
    NULL,
    '60978205',
    '200326',
    NULL,
    FALSE,
    FALSE,
    NULL,
    'excel_batch',
    0.8,
    'pending',
    0,
    'supplier_documents/026e25b6-8836-46a5-bf9f-0d63ce49696e/'
);




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
WHERE id = '026e25b6-8836-46a5-bf9f-0d63ce49696e';

-- Next Steps:
-- 1. Upload documents to Supabase Storage: supplier_documents/026e25b6-8836-46a5-bf9f-0d63ce49696e/
-- 2. Update document paths in supplier_documents table
-- 3. Review and approve supplier

-- Contractor 98: Amalgamated Lifts
-- ============================================================================
-- Supplier Onboarding: Amalgamated Lifts
-- ============================================================================
-- Generated: 2025-10-15 12:25:02
-- Supplier ID: 81896251-5999-4a61-9337-8e7401a7796f
-- Storage: supplier_documents/81896251-5999-4a61-9337-8e7401a7796f/
-- ============================================================================




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
    '81896251-5999-4a61-9337-8e7401a7796f',
    'Amalgamated Lifts',
    '4 Mulberry Court, Bourne Road, Crayford, Kent, DA1 4BF',
    'DA1 4BF',
    'info@al-lifts.co.uk',
    NULL,
    NULL,
    '34637958',
    '600633',
    NULL,
    FALSE,
    FALSE,
    NULL,
    'excel_batch',
    0.8,
    'pending',
    0,
    'supplier_documents/81896251-5999-4a61-9337-8e7401a7796f/'
);




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
WHERE id = '81896251-5999-4a61-9337-8e7401a7796f';

-- Next Steps:
-- 1. Upload documents to Supabase Storage: supplier_documents/81896251-5999-4a61-9337-8e7401a7796f/
-- 2. Update document paths in supplier_documents table
-- 3. Review and approve supplier

-- Contractor 99: Andrew Manning-Cox
-- ============================================================================
-- Supplier Onboarding: Andrew Manning-Cox
-- ============================================================================
-- Generated: 2025-10-15 12:25:02
-- Supplier ID: 2f4c86e0-2609-405d-9a27-35e99158a3e4
-- Storage: supplier_documents/2f4c86e0-2609-405d-9a27-35e99158a3e4/
-- ============================================================================




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
    '2f4c86e0-2609-405d-9a27-35e99158a3e4',
    'Andrew Manning-Cox',
    'Flat 12 Gladstone Court',
    NULL,
    NULL,
    NULL,
    NULL,
    '13469268',
    '301674',
    NULL,
    FALSE,
    FALSE,
    NULL,
    'excel_batch',
    0.8,
    'pending',
    0,
    'supplier_documents/2f4c86e0-2609-405d-9a27-35e99158a3e4/'
);




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
WHERE id = '2f4c86e0-2609-405d-9a27-35e99158a3e4';

-- Next Steps:
-- 1. Upload documents to Supabase Storage: supplier_documents/2f4c86e0-2609-405d-9a27-35e99158a3e4/
-- 2. Update document paths in supplier_documents table
-- 3. Review and approve supplier

COMMIT;