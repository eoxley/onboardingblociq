-- ============================================================================
-- BlocIQ Property Data Import - Supabase
-- ============================================================================
-- Building: Pimlico Place
-- Extraction Date: 2025-10-16 11:15:44
-- Extraction Version: 6.0
-- Source Folder: N/A
-- Building ID: cd83b608-ee5a-4bcc-b02d-0bc65a477829
-- ============================================================================
--
-- INSTRUCTIONS:
-- 1. Run this SQL script in Supabase SQL Editor
-- 2. Manually upload building documents to Supabase Storage bucket: building-documents
-- 3. Documents should be uploaded to: building-documents/{building_id}/...
-- 4. The documents table entries below reference where files SHOULD be uploaded
--
-- ============================================================================

BEGIN;


-- ============================================================================
-- Building Insert
-- ============================================================================
INSERT INTO buildings (
    id, building_name, city, country, num_units, num_blocks, has_lifts, has_communal_heating, has_hot_water, has_hvac, has_plant_room, has_mechanical_ventilation, has_water_pumps, has_gas, has_sprinklers, has_lightning_conductor, has_gym, has_pool, has_sauna, has_squash_court, has_communal_showers, has_ev_charging, has_balconies, has_cladding, bsa_registration_required, data_quality, confidence_score, extraction_version
)
VALUES (
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829', 'Pimlico Place', 'London', 'United Kingdom', 79, 1, TRUE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, 'production', 0.99, '6.0'
);


-- ============================================================================
-- Units
-- ============================================================================

INSERT INTO units (
    id, building_id, unit_number, unit_reference, unit_type,
    apportionment_percentage, apportionment_method,
    source_document, data_quality
)
VALUES (
    'e3167080-6815-4f8e-a614-c673089a9b9a',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'A1',
    '',
    'Flat',
    0,
    '',
    '',
    'high'
);

INSERT INTO units (
    id, building_id, unit_number, unit_reference, unit_type,
    apportionment_percentage, apportionment_method,
    source_document, data_quality
)
VALUES (
    '76b4c287-0f09-4326-b18f-b3811bbada8b',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'A2',
    '',
    'Flat',
    0,
    '',
    '',
    'high'
);

INSERT INTO units (
    id, building_id, unit_number, unit_reference, unit_type,
    apportionment_percentage, apportionment_method,
    source_document, data_quality
)
VALUES (
    '23f36cc2-610b-4373-8fe3-73208a39cd2d',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'A3',
    '',
    'Flat',
    0,
    '',
    '',
    'high'
);

INSERT INTO units (
    id, building_id, unit_number, unit_reference, unit_type,
    apportionment_percentage, apportionment_method,
    source_document, data_quality
)
VALUES (
    '8bbb09c5-3147-4845-82bd-b8897caa164c',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'A4',
    '',
    'Flat',
    0,
    '',
    '',
    'high'
);

INSERT INTO units (
    id, building_id, unit_number, unit_reference, unit_type,
    apportionment_percentage, apportionment_method,
    source_document, data_quality
)
VALUES (
    'ed201bd9-9697-4d0d-81a0-4b77db2bca75',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'A5',
    '',
    'Flat',
    0,
    '',
    '',
    'high'
);

INSERT INTO units (
    id, building_id, unit_number, unit_reference, unit_type,
    apportionment_percentage, apportionment_method,
    source_document, data_quality
)
VALUES (
    '87586370-78f5-4f34-bb36-ef099281b1e0',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'A6',
    '',
    'Flat',
    0,
    '',
    '',
    'high'
);

INSERT INTO units (
    id, building_id, unit_number, unit_reference, unit_type,
    apportionment_percentage, apportionment_method,
    source_document, data_quality
)
VALUES (
    'b6cefb81-6bd6-4f21-b0e9-71c2e7a27e9a',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'A7',
    '',
    'Flat',
    0,
    '',
    '',
    'high'
);

INSERT INTO units (
    id, building_id, unit_number, unit_reference, unit_type,
    apportionment_percentage, apportionment_method,
    source_document, data_quality
)
VALUES (
    '24226521-bc21-44e7-9f57-097a9c5e4b7c',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'A8',
    '',
    'Flat',
    0,
    '',
    '',
    'high'
);

INSERT INTO units (
    id, building_id, unit_number, unit_reference, unit_type,
    apportionment_percentage, apportionment_method,
    source_document, data_quality
)
VALUES (
    '7dc6af1d-8e09-4569-a4fd-1faad0586c1a',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'A9',
    '',
    'Flat',
    0,
    '',
    '',
    'high'
);

INSERT INTO units (
    id, building_id, unit_number, unit_reference, unit_type,
    apportionment_percentage, apportionment_method,
    source_document, data_quality
)
VALUES (
    '984bd1c7-d0de-402a-83a2-4dc65c39034a',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'A10',
    '',
    'Flat',
    0,
    '',
    '',
    'high'
);

INSERT INTO units (
    id, building_id, unit_number, unit_reference, unit_type,
    apportionment_percentage, apportionment_method,
    source_document, data_quality
)
VALUES (
    'd11cbb34-21c7-4104-9cf1-917b87a87325',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'A11',
    '',
    'Flat',
    0,
    '',
    '',
    'high'
);

INSERT INTO units (
    id, building_id, unit_number, unit_reference, unit_type,
    apportionment_percentage, apportionment_method,
    source_document, data_quality
)
VALUES (
    'c5bc1277-8b43-4288-8b34-5b37d947d2d0',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'A12',
    '',
    'Flat',
    0,
    '',
    '',
    'high'
);

INSERT INTO units (
    id, building_id, unit_number, unit_reference, unit_type,
    apportionment_percentage, apportionment_method,
    source_document, data_quality
)
VALUES (
    'acc7f0e5-4207-46f8-bdc8-943ac64f5813',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'A13',
    '',
    'Flat',
    0,
    '',
    '',
    'high'
);

INSERT INTO units (
    id, building_id, unit_number, unit_reference, unit_type,
    apportionment_percentage, apportionment_method,
    source_document, data_quality
)
VALUES (
    '20e55ca7-304e-4168-b0a9-0a931096c3ce',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'A14',
    '',
    'Flat',
    0,
    '',
    '',
    'high'
);

INSERT INTO units (
    id, building_id, unit_number, unit_reference, unit_type,
    apportionment_percentage, apportionment_method,
    source_document, data_quality
)
VALUES (
    '037a9d7b-1648-4b4b-b2a6-9f864286e22e',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'A15',
    '',
    'Flat',
    0,
    '',
    '',
    'high'
);

INSERT INTO units (
    id, building_id, unit_number, unit_reference, unit_type,
    apportionment_percentage, apportionment_method,
    source_document, data_quality
)
VALUES (
    '25e74db5-07cf-4c9a-a278-49d132b2b7ff',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'A16',
    '',
    'Flat',
    0,
    '',
    '',
    'high'
);

INSERT INTO units (
    id, building_id, unit_number, unit_reference, unit_type,
    apportionment_percentage, apportionment_method,
    source_document, data_quality
)
VALUES (
    'bf78e777-4f8c-4062-96de-afa599c43a67',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'A17',
    '',
    'Flat',
    0,
    '',
    '',
    'high'
);

INSERT INTO units (
    id, building_id, unit_number, unit_reference, unit_type,
    apportionment_percentage, apportionment_method,
    source_document, data_quality
)
VALUES (
    '77e194d2-2b80-4004-9c8c-b6d6dc66a010',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'A18',
    '',
    'Flat',
    0,
    '',
    '',
    'high'
);

INSERT INTO units (
    id, building_id, unit_number, unit_reference, unit_type,
    apportionment_percentage, apportionment_method,
    source_document, data_quality
)
VALUES (
    '95ea3e1f-3a3a-4228-90b9-ae2b617217c8',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'A19',
    '',
    'Flat',
    0,
    '',
    '',
    'high'
);

INSERT INTO units (
    id, building_id, unit_number, unit_reference, unit_type,
    apportionment_percentage, apportionment_method,
    source_document, data_quality
)
VALUES (
    '36a1528d-3911-4329-add8-cf1a22c44b3b',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'A20',
    '',
    'Flat',
    0,
    '',
    '',
    'high'
);

INSERT INTO units (
    id, building_id, unit_number, unit_reference, unit_type,
    apportionment_percentage, apportionment_method,
    source_document, data_quality
)
VALUES (
    '8244757e-165b-4506-8f92-b680ae0bb50c',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'A21',
    '',
    'Flat',
    0,
    '',
    '',
    'high'
);

INSERT INTO units (
    id, building_id, unit_number, unit_reference, unit_type,
    apportionment_percentage, apportionment_method,
    source_document, data_quality
)
VALUES (
    'b1040ac1-2881-42db-8bc2-b0d4b2b865b8',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'B1',
    '',
    'Flat',
    0,
    '',
    '',
    'high'
);

INSERT INTO units (
    id, building_id, unit_number, unit_reference, unit_type,
    apportionment_percentage, apportionment_method,
    source_document, data_quality
)
VALUES (
    '464e11aa-6efb-498e-b73e-a0c3a235caf8',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'B2',
    '',
    'Flat',
    0,
    '',
    '',
    'high'
);

INSERT INTO units (
    id, building_id, unit_number, unit_reference, unit_type,
    apportionment_percentage, apportionment_method,
    source_document, data_quality
)
VALUES (
    '435ae0d1-79b5-40ee-8a0a-b7749bae5b8b',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'B3',
    '',
    'Flat',
    0,
    '',
    '',
    'high'
);

INSERT INTO units (
    id, building_id, unit_number, unit_reference, unit_type,
    apportionment_percentage, apportionment_method,
    source_document, data_quality
)
VALUES (
    '020991bc-e241-4bae-a75a-aa10b363f07d',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'B4',
    '',
    'Flat',
    0,
    '',
    '',
    'high'
);

INSERT INTO units (
    id, building_id, unit_number, unit_reference, unit_type,
    apportionment_percentage, apportionment_method,
    source_document, data_quality
)
VALUES (
    '1d0c4941-3164-4aad-88e4-e21bbc37270d',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'B5',
    '',
    'Flat',
    0,
    '',
    '',
    'high'
);

INSERT INTO units (
    id, building_id, unit_number, unit_reference, unit_type,
    apportionment_percentage, apportionment_method,
    source_document, data_quality
)
VALUES (
    '0c6c1527-07ca-4ff7-8676-7275ea889e70',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'B6',
    '',
    'Flat',
    0,
    '',
    '',
    'high'
);

INSERT INTO units (
    id, building_id, unit_number, unit_reference, unit_type,
    apportionment_percentage, apportionment_method,
    source_document, data_quality
)
VALUES (
    'd324c402-6090-4e9e-9589-e7017aad0675',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'B7',
    '',
    'Flat',
    0,
    '',
    '',
    'high'
);

INSERT INTO units (
    id, building_id, unit_number, unit_reference, unit_type,
    apportionment_percentage, apportionment_method,
    source_document, data_quality
)
VALUES (
    'df55d38d-a1ea-41c7-a565-1244989e7db2',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'B8',
    '',
    'Flat',
    0,
    '',
    '',
    'high'
);

INSERT INTO units (
    id, building_id, unit_number, unit_reference, unit_type,
    apportionment_percentage, apportionment_method,
    source_document, data_quality
)
VALUES (
    'cd04624e-5879-4027-b82e-e66ee8d02c35',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'B9',
    '',
    'Flat',
    0,
    '',
    '',
    'high'
);

INSERT INTO units (
    id, building_id, unit_number, unit_reference, unit_type,
    apportionment_percentage, apportionment_method,
    source_document, data_quality
)
VALUES (
    '09be113d-ecba-4371-8e5f-e2d735bfd0af',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'C1',
    '',
    'Flat',
    0,
    '',
    '',
    'high'
);

INSERT INTO units (
    id, building_id, unit_number, unit_reference, unit_type,
    apportionment_percentage, apportionment_method,
    source_document, data_quality
)
VALUES (
    '7891d839-4ef4-40c7-b589-1790d667388e',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'C2',
    '',
    'Flat',
    0,
    '',
    '',
    'high'
);

INSERT INTO units (
    id, building_id, unit_number, unit_reference, unit_type,
    apportionment_percentage, apportionment_method,
    source_document, data_quality
)
VALUES (
    '6a0839d7-373b-4e08-891b-e2edb09e43b5',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'D1',
    '',
    'Flat',
    0,
    '',
    '',
    'high'
);

INSERT INTO units (
    id, building_id, unit_number, unit_reference, unit_type,
    apportionment_percentage, apportionment_method,
    source_document, data_quality
)
VALUES (
    '1de6ab49-cc8c-41aa-92b9-23660051d424',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'D2',
    '',
    'Flat',
    0,
    '',
    '',
    'high'
);

INSERT INTO units (
    id, building_id, unit_number, unit_reference, unit_type,
    apportionment_percentage, apportionment_method,
    source_document, data_quality
)
VALUES (
    '2ba97200-cb90-426d-af79-8115efe40938',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'D3',
    '',
    'Flat',
    0,
    '',
    '',
    'high'
);

INSERT INTO units (
    id, building_id, unit_number, unit_reference, unit_type,
    apportionment_percentage, apportionment_method,
    source_document, data_quality
)
VALUES (
    '5674b30e-2404-4c78-b104-8fbdc7279d1d',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'D4',
    '',
    'Flat',
    0,
    '',
    '',
    'high'
);

INSERT INTO units (
    id, building_id, unit_number, unit_reference, unit_type,
    apportionment_percentage, apportionment_method,
    source_document, data_quality
)
VALUES (
    '724f5ad6-630e-4787-8d5e-007cfb8deaba',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'D5',
    '',
    'Flat',
    0,
    '',
    '',
    'high'
);

INSERT INTO units (
    id, building_id, unit_number, unit_reference, unit_type,
    apportionment_percentage, apportionment_method,
    source_document, data_quality
)
VALUES (
    '6170e23f-ccec-43ae-b389-278fd21b3cc2',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'D6',
    '',
    'Flat',
    0,
    '',
    '',
    'high'
);

INSERT INTO units (
    id, building_id, unit_number, unit_reference, unit_type,
    apportionment_percentage, apportionment_method,
    source_document, data_quality
)
VALUES (
    '36803186-f60a-4ddb-9b3f-4cd96bafea19',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'D7',
    '',
    'Flat',
    0,
    '',
    '',
    'high'
);

INSERT INTO units (
    id, building_id, unit_number, unit_reference, unit_type,
    apportionment_percentage, apportionment_method,
    source_document, data_quality
)
VALUES (
    'a149e6dd-14b2-450b-be1e-d0b8a43a036d',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'D8',
    '',
    'Flat',
    0,
    '',
    '',
    'high'
);

INSERT INTO units (
    id, building_id, unit_number, unit_reference, unit_type,
    apportionment_percentage, apportionment_method,
    source_document, data_quality
)
VALUES (
    '6b33e094-420d-40e9-b61c-41c853375e20',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'D9',
    '',
    'Flat',
    0,
    '',
    '',
    'high'
);

INSERT INTO units (
    id, building_id, unit_number, unit_reference, unit_type,
    apportionment_percentage, apportionment_method,
    source_document, data_quality
)
VALUES (
    'aeb9abe8-19f4-4475-a5f2-799d2017867f',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'D10',
    '',
    'Flat',
    0,
    '',
    '',
    'high'
);

INSERT INTO units (
    id, building_id, unit_number, unit_reference, unit_type,
    apportionment_percentage, apportionment_method,
    source_document, data_quality
)
VALUES (
    '73a3a1d0-c770-4c16-a5cc-b99dfc9bdf6f',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'D11',
    '',
    'Flat',
    0,
    '',
    '',
    'high'
);

INSERT INTO units (
    id, building_id, unit_number, unit_reference, unit_type,
    apportionment_percentage, apportionment_method,
    source_document, data_quality
)
VALUES (
    'cf62404f-c86a-44e4-bc58-5d9b8cda8581',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'E1',
    '',
    'Flat',
    0,
    '',
    '',
    'high'
);

INSERT INTO units (
    id, building_id, unit_number, unit_reference, unit_type,
    apportionment_percentage, apportionment_method,
    source_document, data_quality
)
VALUES (
    '3ae918fc-a692-42a9-a0b5-0104c9668f0e',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'E2',
    '',
    'Flat',
    0,
    '',
    '',
    'high'
);

INSERT INTO units (
    id, building_id, unit_number, unit_reference, unit_type,
    apportionment_percentage, apportionment_method,
    source_document, data_quality
)
VALUES (
    'aed9d5f6-46cb-49d6-8b55-ae00d5938e26',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'E3',
    '',
    'Flat',
    0,
    '',
    '',
    'high'
);

INSERT INTO units (
    id, building_id, unit_number, unit_reference, unit_type,
    apportionment_percentage, apportionment_method,
    source_document, data_quality
)
VALUES (
    'b4cc697d-5975-4f01-b534-eef154920fee',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'E4',
    '',
    'Flat',
    0,
    '',
    '',
    'high'
);

INSERT INTO units (
    id, building_id, unit_number, unit_reference, unit_type,
    apportionment_percentage, apportionment_method,
    source_document, data_quality
)
VALUES (
    '9eb25b13-db78-45ea-bcb3-3e6f2dff522e',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'E5',
    '',
    'Flat',
    0,
    '',
    '',
    'high'
);

INSERT INTO units (
    id, building_id, unit_number, unit_reference, unit_type,
    apportionment_percentage, apportionment_method,
    source_document, data_quality
)
VALUES (
    'd41d1092-5247-4d0b-ae4c-35ef0577d2e0',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'E6',
    '',
    'Flat',
    0,
    '',
    '',
    'high'
);

INSERT INTO units (
    id, building_id, unit_number, unit_reference, unit_type,
    apportionment_percentage, apportionment_method,
    source_document, data_quality
)
VALUES (
    '77579ed3-c19c-49b9-ad96-78a3a1e5e40e',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'E7',
    '',
    'Flat',
    0,
    '',
    '',
    'high'
);

INSERT INTO units (
    id, building_id, unit_number, unit_reference, unit_type,
    apportionment_percentage, apportionment_method,
    source_document, data_quality
)
VALUES (
    '7b5e7d76-0b37-47df-971e-bdcacd90b0a5',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'E8',
    '',
    'Flat',
    0,
    '',
    '',
    'high'
);

INSERT INTO units (
    id, building_id, unit_number, unit_reference, unit_type,
    apportionment_percentage, apportionment_method,
    source_document, data_quality
)
VALUES (
    '203dbf1d-094e-405b-b91d-e6bec44ad544',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'E9',
    '',
    'Flat',
    0,
    '',
    '',
    'high'
);

INSERT INTO units (
    id, building_id, unit_number, unit_reference, unit_type,
    apportionment_percentage, apportionment_method,
    source_document, data_quality
)
VALUES (
    '04c1c60f-bf31-44d6-b330-cd31feff190b',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'E10',
    '',
    'Flat',
    0,
    '',
    '',
    'high'
);

INSERT INTO units (
    id, building_id, unit_number, unit_reference, unit_type,
    apportionment_percentage, apportionment_method,
    source_document, data_quality
)
VALUES (
    '2ebf73d7-8f79-4a4a-afbb-1fdb8dce7cf0',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'E11',
    '',
    'Flat',
    0,
    '',
    '',
    'high'
);

INSERT INTO units (
    id, building_id, unit_number, unit_reference, unit_type,
    apportionment_percentage, apportionment_method,
    source_document, data_quality
)
VALUES (
    '6c395f63-14a9-435f-91f2-c131479ce73c',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'E12',
    '',
    'Flat',
    0,
    '',
    '',
    'high'
);

INSERT INTO units (
    id, building_id, unit_number, unit_reference, unit_type,
    apportionment_percentage, apportionment_method,
    source_document, data_quality
)
VALUES (
    '1c692288-98aa-4f72-9706-bd82e42a8c4e',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'E13',
    '',
    'Flat',
    0,
    '',
    '',
    'high'
);

INSERT INTO units (
    id, building_id, unit_number, unit_reference, unit_type,
    apportionment_percentage, apportionment_method,
    source_document, data_quality
)
VALUES (
    '71a81cc0-32fa-4ec8-a1dd-a11a071c1f5e',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'E14',
    '',
    'Flat',
    0,
    '',
    '',
    'high'
);

INSERT INTO units (
    id, building_id, unit_number, unit_reference, unit_type,
    apportionment_percentage, apportionment_method,
    source_document, data_quality
)
VALUES (
    '9bb1cd80-65c5-4bb8-ab20-18d7715deb9d',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'E15',
    '',
    'Flat',
    0,
    '',
    '',
    'high'
);

INSERT INTO units (
    id, building_id, unit_number, unit_reference, unit_type,
    apportionment_percentage, apportionment_method,
    source_document, data_quality
)
VALUES (
    'fa6d2488-90f7-457a-92bb-6350d98bebe6',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'E16',
    '',
    'Flat',
    0,
    '',
    '',
    'high'
);

INSERT INTO units (
    id, building_id, unit_number, unit_reference, unit_type,
    apportionment_percentage, apportionment_method,
    source_document, data_quality
)
VALUES (
    '430ecfe1-34f5-4e56-a51c-633635e9f1c5',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'E17',
    '',
    'Flat',
    0,
    '',
    '',
    'high'
);

INSERT INTO units (
    id, building_id, unit_number, unit_reference, unit_type,
    apportionment_percentage, apportionment_method,
    source_document, data_quality
)
VALUES (
    '25f52957-47f5-48f0-85d3-06792c8bbd06',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'E18',
    '',
    'Flat',
    0,
    '',
    '',
    'high'
);

INSERT INTO units (
    id, building_id, unit_number, unit_reference, unit_type,
    apportionment_percentage, apportionment_method,
    source_document, data_quality
)
VALUES (
    'fa18e7f9-36a3-45df-8d25-4bf1499b5121',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'E19',
    '',
    'Flat',
    0,
    '',
    '',
    'high'
);

INSERT INTO units (
    id, building_id, unit_number, unit_reference, unit_type,
    apportionment_percentage, apportionment_method,
    source_document, data_quality
)
VALUES (
    '2ae61d32-14aa-48eb-9161-3f3aacdf3b82',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'E20',
    '',
    'Flat',
    0,
    '',
    '',
    'high'
);

INSERT INTO units (
    id, building_id, unit_number, unit_reference, unit_type,
    apportionment_percentage, apportionment_method,
    source_document, data_quality
)
VALUES (
    'ecaf4d4e-16c4-471c-8b24-35b667388ec1',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'E21',
    '',
    'Flat',
    0,
    '',
    '',
    'high'
);

INSERT INTO units (
    id, building_id, unit_number, unit_reference, unit_type,
    apportionment_percentage, apportionment_method,
    source_document, data_quality
)
VALUES (
    '3c388829-6777-49d2-8f86-14125333c423',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'E22',
    '',
    'Flat',
    0,
    '',
    '',
    'high'
);

INSERT INTO units (
    id, building_id, unit_number, unit_reference, unit_type,
    apportionment_percentage, apportionment_method,
    source_document, data_quality
)
VALUES (
    'd4b5c90f-28f3-4dd8-bc40-5027cf8e19ef',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'E23',
    '',
    'Flat',
    0,
    '',
    '',
    'high'
);

INSERT INTO units (
    id, building_id, unit_number, unit_reference, unit_type,
    apportionment_percentage, apportionment_method,
    source_document, data_quality
)
VALUES (
    'd9864768-6ed7-436b-a343-fb9c3b65f244',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'E24',
    '',
    'Flat',
    0,
    '',
    '',
    'high'
);

INSERT INTO units (
    id, building_id, unit_number, unit_reference, unit_type,
    apportionment_percentage, apportionment_method,
    source_document, data_quality
)
VALUES (
    'e271c6e5-8c15-4209-93d2-261962f21c90',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'E25',
    '',
    'Flat',
    0,
    '',
    '',
    'high'
);

INSERT INTO units (
    id, building_id, unit_number, unit_reference, unit_type,
    apportionment_percentage, apportionment_method,
    source_document, data_quality
)
VALUES (
    '0d682779-baa7-4708-bad8-af46cd8da91e',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'E26',
    '',
    'Flat',
    0,
    '',
    '',
    'high'
);

INSERT INTO units (
    id, building_id, unit_number, unit_reference, unit_type,
    apportionment_percentage, apportionment_method,
    source_document, data_quality
)
VALUES (
    '4dbfa0f5-9c82-4061-92a8-94b8053875fc',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'E27',
    '',
    'Flat',
    0,
    '',
    '',
    'high'
);

INSERT INTO units (
    id, building_id, unit_number, unit_reference, unit_type,
    apportionment_percentage, apportionment_method,
    source_document, data_quality
)
VALUES (
    'c536c21a-6b7d-4c5d-9690-f5cf7bc5bf1d',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'E28',
    '',
    'Flat',
    0,
    '',
    '',
    'high'
);

INSERT INTO units (
    id, building_id, unit_number, unit_reference, unit_type,
    apportionment_percentage, apportionment_method,
    source_document, data_quality
)
VALUES (
    'eedd7355-9d2a-46b5-a4e4-add4f2db21c1',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'E29',
    '',
    'Flat',
    0,
    '',
    '',
    'high'
);

INSERT INTO units (
    id, building_id, unit_number, unit_reference, unit_type,
    apportionment_percentage, apportionment_method,
    source_document, data_quality
)
VALUES (
    'a9a623ac-cfb7-4476-97e2-db6df0c4990d',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'E30',
    '',
    'Flat',
    0,
    '',
    '',
    'high'
);

INSERT INTO units (
    id, building_id, unit_number, unit_reference, unit_type,
    apportionment_percentage, apportionment_method,
    source_document, data_quality
)
VALUES (
    'b220781e-9503-420c-85a0-6a24f7b970f5',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'E31',
    '',
    'Flat',
    0,
    '',
    '',
    'high'
);

INSERT INTO units (
    id, building_id, unit_number, unit_reference, unit_type,
    apportionment_percentage, apportionment_method,
    source_document, data_quality
)
VALUES (
    '891eba80-7a8c-4d3e-ad1c-237dcaa83746',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'F1',
    '',
    'Flat',
    0,
    '',
    '',
    'high'
);

INSERT INTO units (
    id, building_id, unit_number, unit_reference, unit_type,
    apportionment_percentage, apportionment_method,
    source_document, data_quality
)
VALUES (
    'f0d7291e-8215-4b3f-8d79-01b22be09ac2',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'F2',
    '',
    'Flat',
    0,
    '',
    '',
    'high'
);

INSERT INTO units (
    id, building_id, unit_number, unit_reference, unit_type,
    apportionment_percentage, apportionment_method,
    source_document, data_quality
)
VALUES (
    '238c328c-25f2-46b8-a5d2-8515ed39a67f',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'F3',
    '',
    'Flat',
    0,
    '',
    '',
    'high'
);

INSERT INTO units (
    id, building_id, unit_number, unit_reference, unit_type,
    apportionment_percentage, apportionment_method,
    source_document, data_quality
)
VALUES (
    '21ba9480-b850-40f8-be3d-f7686c3b04df',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'F4',
    '',
    'Flat',
    0,
    '',
    '',
    'high'
);

INSERT INTO units (
    id, building_id, unit_number, unit_reference, unit_type,
    apportionment_percentage, apportionment_method,
    source_document, data_quality
)
VALUES (
    'ca41a5f5-b865-4223-afcd-300fb91d9929',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'F5',
    '',
    'Flat',
    0,
    '',
    '',
    'high'
);

INSERT INTO units (
    id, building_id, unit_number, unit_reference, unit_type,
    apportionment_percentage, apportionment_method,
    source_document, data_quality
)
VALUES (
    '5117002c-faa0-46ef-886e-412a3c3a49c5',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'Flat 80',
    '',
    'Flat',
    0,
    '',
    '',
    'high'
);

INSERT INTO units (
    id, building_id, unit_number, unit_reference, unit_type,
    apportionment_percentage, apportionment_method,
    source_document, data_quality
)
VALUES (
    '3da9ce10-361a-4ef8-bf58-b2be8887b311',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'Flat 81',
    '',
    'Flat',
    0,
    '',
    '',
    'high'
);

INSERT INTO units (
    id, building_id, unit_number, unit_reference, unit_type,
    apportionment_percentage, apportionment_method,
    source_document, data_quality
)
VALUES (
    '15133ce6-b3a1-499f-9dd0-4d6cacc00902',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'Flat 82',
    '',
    'Flat',
    0,
    '',
    '',
    'high'
);

INSERT INTO units (
    id, building_id, unit_number, unit_reference, unit_type,
    apportionment_percentage, apportionment_method,
    source_document, data_quality
)
VALUES (
    '7bf6edd6-d80d-4ee0-b7e8-5194dd833817',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'Flat 5',
    '',
    'Flat',
    0,
    '',
    '',
    'high'
);


-- ============================================================================
-- Leaseholders
-- ============================================================================

INSERT INTO leaseholders (
    id, unit_id, leaseholder_name, correspondence_address,
    telephone, email, status, current_balance,
    data_source, data_quality
)
VALUES (
    '9e61509c-60d8-433b-ae99-c2c4ba350e05',
    'e3167080-6815-4f8e-a614-c673089a9b9a',
    'Unknown',
    'Ethlope Property Ltd Acting by his, LPA Fixed Charge Receivers, C/O MDT Property Consultants, 5 Coppice Drive, Putney, London, SW15 5BW',
    '',
    '',
    'Current',
    0,
    '',
    'high'
);

INSERT INTO leaseholders (
    id, unit_id, leaseholder_name, correspondence_address,
    telephone, email, status, current_balance,
    data_source, data_quality
)
VALUES (
    'e4f64e95-b2a6-4f17-a999-9c3ebeddbfd2',
    '76b4c287-0f09-4326-b18f-b3811bbada8b',
    'Unknown',
    'Pimlico Place - Flat A2, 28 Guildhouse Street, Pimlico, London, SW1V 1JJ',
    '',
    '',
    'Current',
    0,
    '',
    'high'
);

INSERT INTO leaseholders (
    id, unit_id, leaseholder_name, correspondence_address,
    telephone, email, status, current_balance,
    data_source, data_quality
)
VALUES (
    '7e4bf93f-ad71-43dd-9056-6198bf7125a0',
    '23f36cc2-610b-4373-8fe3-73208a39cd2d',
    'Unknown',
    'C/O Hoffen West Ltd, 16 Lower Belgrave Street, London, SW1W 0LN',
    '',
    '',
    'Current',
    0,
    '',
    'high'
);

INSERT INTO leaseholders (
    id, unit_id, leaseholder_name, correspondence_address,
    telephone, email, status, current_balance,
    data_source, data_quality
)
VALUES (
    '1ba89a7d-5ed8-45c9-990d-77ee4920a181',
    '8bbb09c5-3147-4845-82bd-b8897caa164c',
    'Unknown',
    'Pimlico Place - Flat A4, 28 Guildhouse Street, London, SW1V 1JJ',
    '',
    '',
    'Current',
    0,
    '',
    'high'
);

INSERT INTO leaseholders (
    id, unit_id, leaseholder_name, correspondence_address,
    telephone, email, status, current_balance,
    data_source, data_quality
)
VALUES (
    '48393eab-054b-43d5-9836-2bd30cdd1d2e',
    'ed201bd9-9697-4d0d-81a0-4b77db2bca75',
    'Unknown',
    'Finance Office, 46 Francis Street, London, SW1P 1QN',
    '',
    '',
    'Current',
    0,
    '',
    'high'
);

INSERT INTO leaseholders (
    id, unit_id, leaseholder_name, correspondence_address,
    telephone, email, status, current_balance,
    data_source, data_quality
)
VALUES (
    '36f6825d-49ea-4808-8a97-1ba82241b826',
    '87586370-78f5-4f34-bb36-ef099281b1e0',
    'Unknown',
    '46 E Peninsula Centre, DR APT 259, Rllng Hls Est, California 90274, USA',
    '',
    '',
    'Current',
    0,
    '',
    'high'
);

INSERT INTO leaseholders (
    id, unit_id, leaseholder_name, correspondence_address,
    telephone, email, status, current_balance,
    data_source, data_quality
)
VALUES (
    '9f76231a-f5a2-4d89-b22f-3f593dad62ce',
    'b6cefb81-6bd6-4f21-b0e9-71c2e7a27e9a',
    'Unknown',
    'Crossbow House, Hillhouse Lane, Rudgwick, West Sussex, RH12 3BD',
    '',
    '',
    'Current',
    0,
    '',
    'high'
);

INSERT INTO leaseholders (
    id, unit_id, leaseholder_name, correspondence_address,
    telephone, email, status, current_balance,
    data_source, data_quality
)
VALUES (
    'd7d440fe-eaa5-492d-bcda-e41de1545373',
    '24226521-bc21-44e7-9f57-097a9c5e4b7c',
    'Unknown',
    'Pimlico Place - Flat A8, 28 Guildhouse Street, Pimlico, London, SW1V 1JJ',
    '',
    '',
    'Current',
    0,
    '',
    'high'
);

INSERT INTO leaseholders (
    id, unit_id, leaseholder_name, correspondence_address,
    telephone, email, status, current_balance,
    data_source, data_quality
)
VALUES (
    '7d87c30d-215e-41c5-9e1a-beb4c3126485',
    '7dc6af1d-8e09-4569-a4fd-1faad0586c1a',
    'Unknown',
    'Pimlico Place - Flat A9, 28 Guildhouse Street, Pimlico, London, SW1V 1JJ',
    '',
    '',
    'Current',
    0,
    '',
    'high'
);

INSERT INTO leaseholders (
    id, unit_id, leaseholder_name, correspondence_address,
    telephone, email, status, current_balance,
    data_source, data_quality
)
VALUES (
    '6766771e-89db-4f91-95e8-4259447bb46a',
    '984bd1c7-d0de-402a-83a2-4dc65c39034a',
    'Unknown',
    'Pimlico Place - Flat A10, 28 Guildhouse Street, Pimlico, London, SW1V 1JJ',
    '',
    '',
    'Current',
    0,
    '',
    'high'
);

INSERT INTO leaseholders (
    id, unit_id, leaseholder_name, correspondence_address,
    telephone, email, status, current_balance,
    data_source, data_quality
)
VALUES (
    '810606ce-eb37-4c3f-a066-001fa8ad03b3',
    'd11cbb34-21c7-4104-9cf1-917b87a87325',
    'Unknown',
    '2 Rathfarnham Wood, Dublin 14, EIRE',
    '',
    '',
    'Current',
    0,
    '',
    'high'
);

INSERT INTO leaseholders (
    id, unit_id, leaseholder_name, correspondence_address,
    telephone, email, status, current_balance,
    data_source, data_quality
)
VALUES (
    '10466b64-2fd1-4a6e-8a83-480dc49d2452',
    'c5bc1277-8b43-4288-8b34-5b37d947d2d0',
    'Unknown',
    'Pimlico Place - Flat A12, 28 Guildhouse Street, Pimlico, London, SW1V 1JJ',
    '',
    '',
    'Current',
    0,
    '',
    'high'
);

INSERT INTO leaseholders (
    id, unit_id, leaseholder_name, correspondence_address,
    telephone, email, status, current_balance,
    data_source, data_quality
)
VALUES (
    '5e74406f-7adf-4815-aa44-61cc1b6477af',
    'acc7f0e5-4207-46f8-bdc8-943ac64f5813',
    'Unknown',
    'Pimlico Place - Flat A13, 28 Guildhouse Street, Pimlico, London, SW1V 1JJ',
    '',
    '',
    'Current',
    0,
    '',
    'high'
);

INSERT INTO leaseholders (
    id, unit_id, leaseholder_name, correspondence_address,
    telephone, email, status, current_balance,
    data_source, data_quality
)
VALUES (
    'dd88234c-158e-4a05-944a-68fdfd8afb0e',
    '20e55ca7-304e-4168-b0a9-0a931096c3ce',
    'Unknown',
    '5 Popes Wood, Thurnham, Kent, ME14 3PW',
    '',
    '',
    'Current',
    0,
    '',
    'high'
);

INSERT INTO leaseholders (
    id, unit_id, leaseholder_name, correspondence_address,
    telephone, email, status, current_balance,
    data_source, data_quality
)
VALUES (
    'e0102f67-0c2c-4ef3-bfbc-6da498b40a62',
    '037a9d7b-1648-4b4b-b2a6-9f864286e22e',
    'Unknown',
    '19 Cumberland Street, London, SW1V 4LS',
    '',
    '',
    'Current',
    0,
    '',
    'high'
);

INSERT INTO leaseholders (
    id, unit_id, leaseholder_name, correspondence_address,
    telephone, email, status, current_balance,
    data_source, data_quality
)
VALUES (
    '735bdc4d-0d74-4627-a9d6-41a0d98b7a99',
    '25e74db5-07cf-4c9a-a278-49d132b2b7ff',
    'Unknown',
    'Pimlico Place - Flat A16, 28 Guildhouse Street, Pimlico, London, SW1V 1JJ',
    '',
    '',
    'Current',
    0,
    '',
    'high'
);

INSERT INTO leaseholders (
    id, unit_id, leaseholder_name, correspondence_address,
    telephone, email, status, current_balance,
    data_source, data_quality
)
VALUES (
    '4a4a2919-aa46-48a6-b039-44b6111ceb3a',
    'bf78e777-4f8c-4062-96de-afa599c43a67',
    'Unknown',
    'Pimlico Place - Flat A17, 28 Guildhouse Street, Pimlico, London, SW1V 1JJ',
    '',
    '',
    'Current',
    0,
    '',
    'high'
);

INSERT INTO leaseholders (
    id, unit_id, leaseholder_name, correspondence_address,
    telephone, email, status, current_balance,
    data_source, data_quality
)
VALUES (
    '678a2645-8002-4682-8fc7-6a7a07617556',
    '77e194d2-2b80-4004-9c8c-b6d6dc66a010',
    'Unknown',
    'Pimlico Place - Flat A18, 28 Guildhouse Street, Pimlico, London, SW1V 1JJ',
    '',
    '',
    'Current',
    0,
    '',
    'high'
);

INSERT INTO leaseholders (
    id, unit_id, leaseholder_name, correspondence_address,
    telephone, email, status, current_balance,
    data_source, data_quality
)
VALUES (
    '80fcd76b-7a8f-4e88-ad3d-d3a46a06120b',
    '95ea3e1f-3a3a-4228-90b9-ae2b617217c8',
    'Unknown',
    'c/o S Oliver Gmbh & Co KG, Ostring, 97228 Rottendorf, GERMANY',
    '',
    '',
    'Current',
    0,
    '',
    'high'
);

INSERT INTO leaseholders (
    id, unit_id, leaseholder_name, correspondence_address,
    telephone, email, status, current_balance,
    data_source, data_quality
)
VALUES (
    'd3cf8d15-edd6-482d-9836-b65c58900635',
    '36a1528d-3911-4329-add8-cf1a22c44b3b',
    'Unknown',
    'Pimlico Place - Flat A20, 28 Guildhouse Street, Pimlico, London, SW1V 1JJ',
    '',
    '',
    'Current',
    0,
    '',
    'high'
);

INSERT INTO leaseholders (
    id, unit_id, leaseholder_name, correspondence_address,
    telephone, email, status, current_balance,
    data_source, data_quality
)
VALUES (
    'b9965b3b-5ec1-4809-b382-c849cf5d5419',
    '8244757e-165b-4506-8f92-b680ae0bb50c',
    'Unknown',
    'Pimlico Place - Flat A21, 28 Guildhouse Street, Pimlico, London, SW1V 1JJ',
    '',
    '',
    'Current',
    0,
    '',
    'high'
);

INSERT INTO leaseholders (
    id, unit_id, leaseholder_name, correspondence_address,
    telephone, email, status, current_balance,
    data_source, data_quality
)
VALUES (
    '9cbd2bbd-2fb1-401f-b780-4dff9b278eaf',
    'b1040ac1-2881-42db-8bc2-b0d4b2b865b8',
    'Unknown',
    'Prestwood, 8 Rowley Green Road, Barnet, EN5 3HJ',
    '',
    '',
    'Current',
    0,
    '',
    'high'
);

INSERT INTO leaseholders (
    id, unit_id, leaseholder_name, correspondence_address,
    telephone, email, status, current_balance,
    data_source, data_quality
)
VALUES (
    'ac0cbe8d-6f66-4c61-96f8-6ff5f885b47d',
    '464e11aa-6efb-498e-b73e-a0c3a235caf8',
    'Unknown',
    'c/o Phillips & Southern, Onslow Hall 2nd Floor, Little Green, Richmond upon Thames, TW9 1QS',
    '',
    '',
    'Current',
    0,
    '',
    'high'
);

INSERT INTO leaseholders (
    id, unit_id, leaseholder_name, correspondence_address,
    telephone, email, status, current_balance,
    data_source, data_quality
)
VALUES (
    'e7f369ed-1508-4187-9f45-6b0d88e23952',
    '435ae0d1-79b5-40ee-8a0a-b7749bae5b8b',
    'Unknown',
    '66 Ashley Gardens, Ambrosden Avenue, London, SW1P 1QG',
    '',
    '',
    'Current',
    0,
    '',
    'high'
);

INSERT INTO leaseholders (
    id, unit_id, leaseholder_name, correspondence_address,
    telephone, email, status, current_balance,
    data_source, data_quality
)
VALUES (
    '9d45386c-2756-4c43-aca2-aeada6e02a84',
    '020991bc-e241-4bae-a75a-aa10b363f07d',
    'Unknown',
    'C/O Kerensa Cooper, Foot Anstey, Senate Court, Southernhay Gardens, Exeter, EX1 1NT',
    '',
    '',
    'Current',
    0,
    '',
    'high'
);

INSERT INTO leaseholders (
    id, unit_id, leaseholder_name, correspondence_address,
    telephone, email, status, current_balance,
    data_source, data_quality
)
VALUES (
    '4c52c73a-1430-43a9-99e2-06417995a0ec',
    '1d0c4941-3164-4aad-88e4-e21bbc37270d',
    'Unknown',
    '49 Wood Vale, Dulwich, London, SE23 3DT',
    '',
    '',
    'Current',
    0,
    '',
    'high'
);

INSERT INTO leaseholders (
    id, unit_id, leaseholder_name, correspondence_address,
    telephone, email, status, current_balance,
    data_source, data_quality
)
VALUES (
    'd012e4c1-5442-4161-9796-f38f657bd9b2',
    '0c6c1527-07ca-4ff7-8676-7275ea889e70',
    'Unknown',
    '23 Stoke Park Road, Stoke Bishop, Bristol, BS9 1JF',
    '',
    '',
    'Current',
    0,
    '',
    'high'
);

INSERT INTO leaseholders (
    id, unit_id, leaseholder_name, correspondence_address,
    telephone, email, status, current_balance,
    data_source, data_quality
)
VALUES (
    '86d43617-8071-447e-b3ec-e6cc378b6960',
    'd324c402-6090-4e9e-9589-e7017aad0675',
    'Unknown',
    'c/o Phillips & Southern, Onslow Hall 2nd Floor, Little Green, Richmond upon Thames, TW9 1QS',
    '',
    '',
    'Current',
    0,
    '',
    'high'
);

INSERT INTO leaseholders (
    id, unit_id, leaseholder_name, correspondence_address,
    telephone, email, status, current_balance,
    data_source, data_quality
)
VALUES (
    'd5c0f32a-f05e-43ea-b8b8-9f82ab3256a1',
    'df55d38d-a1ea-41c7-a565-1244989e7db2',
    'Unknown',
    'c/o Tate Residential, 16 Battersea Park Road, London, SW8 4LS',
    '',
    '',
    'Current',
    0,
    '',
    'high'
);

INSERT INTO leaseholders (
    id, unit_id, leaseholder_name, correspondence_address,
    telephone, email, status, current_balance,
    data_source, data_quality
)
VALUES (
    '8a4846bf-a553-4d83-a354-06a1984dfe37',
    'cd04624e-5879-4027-b82e-e66ee8d02c35',
    'Unknown',
    'c/o Tate Residential, 16 Battersea Park Road, London, SW8 4LS',
    '',
    '',
    'Current',
    0,
    '',
    'high'
);

INSERT INTO leaseholders (
    id, unit_id, leaseholder_name, correspondence_address,
    telephone, email, status, current_balance,
    data_source, data_quality
)
VALUES (
    'be7a2d90-b203-4235-95da-45a18852c2b2',
    '09be113d-ecba-4371-8e5f-e2d735bfd0af',
    'Unknown',
    'c/o Phillips & Southern, Onslow Hall 2nd Floor, Little Green, Richmond upon Thames, TW9 1QS',
    '',
    '',
    'Current',
    0,
    '',
    'high'
);

INSERT INTO leaseholders (
    id, unit_id, leaseholder_name, correspondence_address,
    telephone, email, status, current_balance,
    data_source, data_quality
)
VALUES (
    '25142c35-b643-45c8-b422-e1dfa88ef977',
    '7891d839-4ef4-40c7-b589-1790d667388e',
    'Unknown',
    '32 Totteridge Common, London, N20 8NE',
    '',
    '',
    'Current',
    0,
    '',
    'high'
);

INSERT INTO leaseholders (
    id, unit_id, leaseholder_name, correspondence_address,
    telephone, email, status, current_balance,
    data_source, data_quality
)
VALUES (
    '13d6d91e-46f1-4eb7-a22e-5c1d0fed3441',
    '6a0839d7-373b-4e08-891b-e2edb09e43b5',
    'Unknown',
    'Pimlico Place - Flat D1, 28 Guildhouse Street, Pimlico, London, SW1V 1JJ',
    '',
    '',
    'Current',
    0,
    '',
    'high'
);

INSERT INTO leaseholders (
    id, unit_id, leaseholder_name, correspondence_address,
    telephone, email, status, current_balance,
    data_source, data_quality
)
VALUES (
    '8a1f6ae5-68d7-45d7-978d-e16cfd6fdbec',
    '1de6ab49-cc8c-41aa-92b9-23660051d424',
    'Unknown',
    'Pimlico Place - Flat D2, 28 Guildhouse Street, Pimlico, London, SW1V 1JJ',
    '',
    '',
    'Current',
    0,
    '',
    'high'
);

INSERT INTO leaseholders (
    id, unit_id, leaseholder_name, correspondence_address,
    telephone, email, status, current_balance,
    data_source, data_quality
)
VALUES (
    '45168b0b-5627-4e36-a2ee-c281a133d193',
    '2ba97200-cb90-426d-af79-8115efe40938',
    'Unknown',
    'Pimlico Place - Flat D3, 28 Guildhouse Street, Pimlico, London, SW1V 1JJ',
    '',
    '',
    'Current',
    0,
    '',
    'high'
);

INSERT INTO leaseholders (
    id, unit_id, leaseholder_name, correspondence_address,
    telephone, email, status, current_balance,
    data_source, data_quality
)
VALUES (
    '55c3d585-a5c0-4550-acda-a9fa0739f796',
    '5674b30e-2404-4c78-b104-8fbdc7279d1d',
    'Unknown',
    '33 Radnor Mews, London, W2 2SA',
    '',
    '',
    'Current',
    0,
    '',
    'high'
);

INSERT INTO leaseholders (
    id, unit_id, leaseholder_name, correspondence_address,
    telephone, email, status, current_balance,
    data_source, data_quality
)
VALUES (
    '79e547f3-4738-4a24-9d52-782794729189',
    '724f5ad6-630e-4787-8d5e-007cfb8deaba',
    'Unknown',
    'c/o Vuna Capital Trustees (Mauritius), Level 10, NeXTeracom, Tower 1, Cybercity, Ebene, MAURITIUS, 72201',
    '',
    '',
    'Current',
    0,
    '',
    'high'
);

INSERT INTO leaseholders (
    id, unit_id, leaseholder_name, correspondence_address,
    telephone, email, status, current_balance,
    data_source, data_quality
)
VALUES (
    'fd8c0b38-b3e4-490e-a371-5a7a24c89b4f',
    '6170e23f-ccec-43ae-b389-278fd21b3cc2',
    'Unknown',
    'c/o Phillips & Southern, Onslow Hall 2nd Floor, Little Green, Richmond upon Thames, TW9 1QS',
    '',
    '',
    'Current',
    0,
    '',
    'high'
);

INSERT INTO leaseholders (
    id, unit_id, leaseholder_name, correspondence_address,
    telephone, email, status, current_balance,
    data_source, data_quality
)
VALUES (
    'e0b553d1-7376-4601-beb5-df847c5cd5e2',
    '36803186-f60a-4ddb-9b3f-4cd96bafea19',
    'Unknown',
    'NO CORRESPONDECE TO BE SENT VIA POST, D3, La Clare Mansion, 92, Pokfulam Road, Hong Kong',
    '',
    '',
    'Current',
    0,
    '',
    'high'
);

INSERT INTO leaseholders (
    id, unit_id, leaseholder_name, correspondence_address,
    telephone, email, status, current_balance,
    data_source, data_quality
)
VALUES (
    'df56b993-2a4f-4931-b7c3-7cd9e94084bd',
    'a149e6dd-14b2-450b-be1e-d0b8a43a036d',
    'Unknown',
    'Pimlico Place - Flat D8, 28 Guildhouse Street, Pimlico, London, SW1V 1JJ',
    '',
    '',
    'Current',
    0,
    '',
    'high'
);

INSERT INTO leaseholders (
    id, unit_id, leaseholder_name, correspondence_address,
    telephone, email, status, current_balance,
    data_source, data_quality
)
VALUES (
    'ea1c2ab3-e7e8-4316-b5cd-3cc6335ce129',
    '6b33e094-420d-40e9-b61c-41c853375e20',
    'Unknown',
    'c/o Phillips & Southern, Onslow Hall 2nd Floor, Little Green, Richmond upon Thames, TW9 1QS',
    '',
    '',
    'Current',
    0,
    '',
    'high'
);

INSERT INTO leaseholders (
    id, unit_id, leaseholder_name, correspondence_address,
    telephone, email, status, current_balance,
    data_source, data_quality
)
VALUES (
    '523e5041-4232-4314-a8fe-83312d20d375',
    'aeb9abe8-19f4-4475-a5f2-799d2017867f',
    'Unknown',
    'Pimlico Place - Flat D10, 28 Guildhouse Street, Pimlico, London, SW1V 1JJ',
    '',
    '',
    'Current',
    0,
    '',
    'high'
);

INSERT INTO leaseholders (
    id, unit_id, leaseholder_name, correspondence_address,
    telephone, email, status, current_balance,
    data_source, data_quality
)
VALUES (
    '55c6f3c7-e721-4ba0-a3b8-6055856edb65',
    '73a3a1d0-c770-4c16-a5cc-b99dfc9bdf6f',
    'Unknown',
    'Pimlico Place - Flat D11, 28 Guildhouse Street, Pimlico, London, SW1V 1JJ',
    '',
    '',
    'Current',
    0,
    '',
    'high'
);

INSERT INTO leaseholders (
    id, unit_id, leaseholder_name, correspondence_address,
    telephone, email, status, current_balance,
    data_source, data_quality
)
VALUES (
    'b85f8edf-9047-4442-88d4-48ac64229bd4',
    'cf62404f-c86a-44e4-bc58-5d9b8cda8581',
    'Unknown',
    'Pimlico Place - Flat E1, 28 Guildhouse Street, Pimlico, London, SW1V 1JJ',
    '',
    '',
    'Current',
    0,
    '',
    'high'
);

INSERT INTO leaseholders (
    id, unit_id, leaseholder_name, correspondence_address,
    telephone, email, status, current_balance,
    data_source, data_quality
)
VALUES (
    '83b199fd-7648-401b-b15f-04256782c34b',
    '3ae918fc-a692-42a9-a0b5-0104c9668f0e',
    'Unknown',
    'Pimlico Place - Flat E2, 28 Guildhouse Street, Pimlico, London, SW1V 1JJ',
    '',
    '',
    'Current',
    0,
    '',
    'high'
);

INSERT INTO leaseholders (
    id, unit_id, leaseholder_name, correspondence_address,
    telephone, email, status, current_balance,
    data_source, data_quality
)
VALUES (
    '2b621dc8-e212-43ca-bfdb-68989775bf1f',
    'aed9d5f6-46cb-49d6-8b55-ae00d5938e26',
    'Unknown',
    'Dencombe House, High Beeches Lane, Handcross, West Sussex, RH17 6HQ',
    '',
    '',
    'Current',
    0,
    '',
    'high'
);

INSERT INTO leaseholders (
    id, unit_id, leaseholder_name, correspondence_address,
    telephone, email, status, current_balance,
    data_source, data_quality
)
VALUES (
    '50e24bc9-a00b-4c8e-b043-aaa26c36d48b',
    'b4cc697d-5975-4f01-b534-eef154920fee',
    'Unknown',
    'Dencombe House, High Beeches Lane, Handcross, West Sussex, RH17 6HQ',
    '',
    '',
    'Current',
    0,
    '',
    'high'
);

INSERT INTO leaseholders (
    id, unit_id, leaseholder_name, correspondence_address,
    telephone, email, status, current_balance,
    data_source, data_quality
)
VALUES (
    '25e37866-87bb-41a5-b5c0-1fb190ae7364',
    '9eb25b13-db78-45ea-bcb3-3e6f2dff522e',
    'Unknown',
    'c/o Ms Asami Miyoshi, c/o London Tokyo Property Services, Central London Office, 115 Baker Street, London, W1U 6RT',
    '',
    '',
    'Current',
    0,
    '',
    'high'
);

INSERT INTO leaseholders (
    id, unit_id, leaseholder_name, correspondence_address,
    telephone, email, status, current_balance,
    data_source, data_quality
)
VALUES (
    '34d1d622-731a-4354-926d-b93b05950e22',
    'd41d1092-5247-4d0b-ae4c-35ef0577d2e0',
    'Unknown',
    'Pimlico Place - Flat E6, 28 Guildhouse Street, Pimlico, London, SW1V 1JJ',
    '',
    '',
    'Current',
    0,
    '',
    'high'
);

INSERT INTO leaseholders (
    id, unit_id, leaseholder_name, correspondence_address,
    telephone, email, status, current_balance,
    data_source, data_quality
)
VALUES (
    '3ee2522d-d012-413b-afe5-582a253126dc',
    '77579ed3-c19c-49b9-ad96-78a3a1e5e40e',
    'Unknown',
    'Pimlico Place - Flat E7, 28 Guildhouse Street, Pimlico, London, SW1V 1JJ',
    '',
    '',
    'Current',
    0,
    '',
    'high'
);

INSERT INTO leaseholders (
    id, unit_id, leaseholder_name, correspondence_address,
    telephone, email, status, current_balance,
    data_source, data_quality
)
VALUES (
    'e181d45f-ca89-4a97-8751-b7a004240823',
    '7b5e7d76-0b37-47df-971e-bdcacd90b0a5',
    'Unknown',
    'c/o Phillips & Southern, Onslow Hall 2nd Floor, Little Green, Richmond upon Thames, TW9 1QS',
    '',
    '',
    'Current',
    0,
    '',
    'high'
);

INSERT INTO leaseholders (
    id, unit_id, leaseholder_name, correspondence_address,
    telephone, email, status, current_balance,
    data_source, data_quality
)
VALUES (
    'cb2b1fd4-74e3-43cb-bc8e-b968759001e5',
    '203dbf1d-094e-405b-b91d-e6bec44ad544',
    'Unknown',
    'Pimlico Place - Flat E9, 28 Guildhouse Street, Pimlico, London, SW1V 1JJ',
    '',
    '',
    'Current',
    0,
    '',
    'high'
);

INSERT INTO leaseholders (
    id, unit_id, leaseholder_name, correspondence_address,
    telephone, email, status, current_balance,
    data_source, data_quality
)
VALUES (
    '308680f3-6acd-42f8-8259-86edbcebbdd5',
    '04c1c60f-bf31-44d6-b330-cd31feff190b',
    'Unknown',
    'c/o Phillips & Southern, Onslow Hall 2nd Floor, Little Green, Richmond upon Thames, TW9 1QS',
    '',
    '',
    'Current',
    0,
    '',
    'high'
);

INSERT INTO leaseholders (
    id, unit_id, leaseholder_name, correspondence_address,
    telephone, email, status, current_balance,
    data_source, data_quality
)
VALUES (
    '0452635e-de97-4571-aae6-6608c08e9e34',
    '2ebf73d7-8f79-4a4a-afbb-1fdb8dce7cf0',
    'Unknown',
    'c/o Phillips & Southern, Onslow Hall 2nd Floor, Little Green, Richmond upon Thames, TW9 1QS',
    '',
    '',
    'Current',
    0,
    '',
    'high'
);

INSERT INTO leaseholders (
    id, unit_id, leaseholder_name, correspondence_address,
    telephone, email, status, current_balance,
    data_source, data_quality
)
VALUES (
    '7c497947-9c45-407a-b2dd-79a2553acb74',
    '6c395f63-14a9-435f-91f2-c131479ce73c',
    'Unknown',
    'Pimlico Place - Flat E12, 28 Guildhouse Street, Pimlico, London, SW1V 1JJ',
    '',
    '',
    'Current',
    0,
    '',
    'high'
);

INSERT INTO leaseholders (
    id, unit_id, leaseholder_name, correspondence_address,
    telephone, email, status, current_balance,
    data_source, data_quality
)
VALUES (
    '69d695ec-759f-40a7-8d93-b70529828146',
    '1c692288-98aa-4f72-9706-bd82e42a8c4e',
    'Unknown',
    'C/O JLL, Unit C1, 4 Riverlight Quay, London, SW11 8DG',
    '',
    '',
    'Current',
    0,
    '',
    'high'
);

INSERT INTO leaseholders (
    id, unit_id, leaseholder_name, correspondence_address,
    telephone, email, status, current_balance,
    data_source, data_quality
)
VALUES (
    'dfadf092-1bfc-4668-93a7-1e8366bf3411',
    '71a81cc0-32fa-4ec8-a1dd-a11a071c1f5e',
    'Unknown',
    'c/o Phillips & Southern, Onslow Hall 2nd Floor, Little Green, Richmond upon Thames, TW9 1QS',
    '',
    '',
    'Current',
    0,
    '',
    'high'
);

INSERT INTO leaseholders (
    id, unit_id, leaseholder_name, correspondence_address,
    telephone, email, status, current_balance,
    data_source, data_quality
)
VALUES (
    'f5ceeea5-b7b0-4562-b6b4-9c4d1c9eab9c',
    '9bb1cd80-65c5-4bb8-ab20-18d7715deb9d',
    'Unknown',
    'c/o Phillips & Southern, Onslow Hall 2nd Floor, Little Green, Richmond upon Thames, TW9 1QS',
    '',
    '',
    'Current',
    0,
    '',
    'high'
);

INSERT INTO leaseholders (
    id, unit_id, leaseholder_name, correspondence_address,
    telephone, email, status, current_balance,
    data_source, data_quality
)
VALUES (
    '57bd40dd-5d2a-4982-9a56-ceed68c46962',
    'fa6d2488-90f7-457a-92bb-6350d98bebe6',
    'Unknown',
    'Pimlico Place - Flat E16, 28 Guildhouse Street, Pimlico, London, SW1V 1JJ',
    '',
    '',
    'Current',
    0,
    '',
    'high'
);

INSERT INTO leaseholders (
    id, unit_id, leaseholder_name, correspondence_address,
    telephone, email, status, current_balance,
    data_source, data_quality
)
VALUES (
    '9d8e3705-68c6-4fb9-9bd3-cbd9959ea016',
    '430ecfe1-34f5-4e56-a51c-633635e9f1c5',
    'Unknown',
    'c/o Phillips & Southern, Onslow Hall 2nd Floor, Little Green, Richmond upon Thames, TW9 1QS',
    '',
    '',
    'Current',
    0,
    '',
    'high'
);

INSERT INTO leaseholders (
    id, unit_id, leaseholder_name, correspondence_address,
    telephone, email, status, current_balance,
    data_source, data_quality
)
VALUES (
    'b73c3e6d-d415-48a1-8226-8ee04a77e276',
    '25f52957-47f5-48f0-85d3-06792c8bbd06',
    'Unknown',
    'The Old Rectory, Stoke Lyne, Oxfordshire, OX27 8RU',
    '',
    '',
    'Current',
    0,
    '',
    'high'
);

INSERT INTO leaseholders (
    id, unit_id, leaseholder_name, correspondence_address,
    telephone, email, status, current_balance,
    data_source, data_quality
)
VALUES (
    '7289face-00cc-4e9e-a106-32f64dc11aee',
    'fa18e7f9-36a3-45df-8d25-4bf1499b5121',
    'Unknown',
    'Pimlico Place - Flat E19, 28 Guildhouse Street, Pimlico, London, SW1V 1JJ',
    '',
    '',
    'Current',
    0,
    '',
    'high'
);

INSERT INTO leaseholders (
    id, unit_id, leaseholder_name, correspondence_address,
    telephone, email, status, current_balance,
    data_source, data_quality
)
VALUES (
    '14101449-e365-4dee-915c-e3d053b5320b',
    '2ae61d32-14aa-48eb-9161-3f3aacdf3b82',
    'Unknown',
    'c/o Phillips & Southern, Onslow Hall 2nd Floor, Little Green, Richmond upon Thames, TW9 1QS',
    '',
    '',
    'Current',
    0,
    '',
    'high'
);

INSERT INTO leaseholders (
    id, unit_id, leaseholder_name, correspondence_address,
    telephone, email, status, current_balance,
    data_source, data_quality
)
VALUES (
    '4407e3f1-cfbb-4f17-8fd8-6ace697b3cbb',
    'ecaf4d4e-16c4-471c-8b24-35b667388ec1',
    'Unknown',
    'c/o Phillips & Southern, Onslow Hall 2nd Floor, Little Green, Richmond upon Thames, TW9 1QS',
    '',
    '',
    'Current',
    0,
    '',
    'high'
);

INSERT INTO leaseholders (
    id, unit_id, leaseholder_name, correspondence_address,
    telephone, email, status, current_balance,
    data_source, data_quality
)
VALUES (
    'bb178652-ca80-49a3-89ef-486869a3521e',
    '3c388829-6777-49d2-8f86-14125333c423',
    'Unknown',
    'c/o Phillips & Southern, Onslow Hall 2nd Floor, Little Green, Richmond upon Thames, TW9 1QS',
    '',
    '',
    'Current',
    0,
    '',
    'high'
);

INSERT INTO leaseholders (
    id, unit_id, leaseholder_name, correspondence_address,
    telephone, email, status, current_balance,
    data_source, data_quality
)
VALUES (
    'e70f5fc4-dbeb-4ece-a051-124439bf7eef',
    'd4b5c90f-28f3-4dd8-bc40-5027cf8e19ef',
    'Unknown',
    'Pimlico Place - Flat E23, 28 Guildhouse Street, Pimlico, London, SW1V 1JJ',
    '',
    '',
    'Current',
    0,
    '',
    'high'
);

INSERT INTO leaseholders (
    id, unit_id, leaseholder_name, correspondence_address,
    telephone, email, status, current_balance,
    data_source, data_quality
)
VALUES (
    '2a8eb0a4-7d3d-43d2-85b3-1061006da230',
    'd9864768-6ed7-436b-a343-fb9c3b65f244',
    'Unknown',
    'c/o Chestertons, 26 Clifton Road, London, W9 1SX',
    '',
    '',
    'Current',
    0,
    '',
    'high'
);

INSERT INTO leaseholders (
    id, unit_id, leaseholder_name, correspondence_address,
    telephone, email, status, current_balance,
    data_source, data_quality
)
VALUES (
    '34cc29ae-cea5-4c2a-9f3d-71246643bc5f',
    'e271c6e5-8c15-4209-93d2-261962f21c90',
    'Unknown',
    'Pimlico Place - Flat E25, 28 Guildhouse Street, Pimlico, London, SW1V 1JJ',
    '',
    '',
    'Current',
    0,
    '',
    'high'
);

INSERT INTO leaseholders (
    id, unit_id, leaseholder_name, correspondence_address,
    telephone, email, status, current_balance,
    data_source, data_quality
)
VALUES (
    '59408158-b56f-4702-b4df-e398e51aacb2',
    '0d682779-baa7-4708-bad8-af46cd8da91e',
    'Unknown',
    'c/o Andrew Reeves, 81 Rochester Row, London, SW1P 1LJ',
    '',
    '',
    'Current',
    0,
    '',
    'high'
);

INSERT INTO leaseholders (
    id, unit_id, leaseholder_name, correspondence_address,
    telephone, email, status, current_balance,
    data_source, data_quality
)
VALUES (
    'd2981148-7647-46e5-9e35-edaa00a2ba0f',
    '4dbfa0f5-9c82-4061-92a8-94b8053875fc',
    'Unknown',
    'Pimlico Place - Flat E27, 28 Guildhouse Street, Pimlico, London, SW1V 1JJ',
    '',
    '',
    'Current',
    0,
    '',
    'high'
);

INSERT INTO leaseholders (
    id, unit_id, leaseholder_name, correspondence_address,
    telephone, email, status, current_balance,
    data_source, data_quality
)
VALUES (
    '6ca3e527-fd81-4d58-8472-307ee5dc89ca',
    'c536c21a-6b7d-4c5d-9690-f5cf7bc5bf1d',
    'Unknown',
    'Pimlico Place - Flat E28, 28 Guildhouse Street, Pimlico, London, SW1V 1JJ',
    '',
    '',
    'Current',
    0,
    '',
    'high'
);

INSERT INTO leaseholders (
    id, unit_id, leaseholder_name, correspondence_address,
    telephone, email, status, current_balance,
    data_source, data_quality
)
VALUES (
    '9146fe7c-949d-411d-b466-924ae191802e',
    'eedd7355-9d2a-46b5-a4e4-add4f2db21c1',
    'Unknown',
    'c/o Phillips & Southern, Onslow Hall 2nd Floor, Little Green, Richmond upon Thames, TW9 1QS',
    '',
    '',
    'Current',
    0,
    '',
    'high'
);

INSERT INTO leaseholders (
    id, unit_id, leaseholder_name, correspondence_address,
    telephone, email, status, current_balance,
    data_source, data_quality
)
VALUES (
    '2bfcd550-d24e-42f4-b885-fb4e9418dfd7',
    'a9a623ac-cfb7-4476-97e2-db6df0c4990d',
    'Unknown',
    'c/o Phillips & Southern, Onslow Hall 2nd Floor, Little Green, Richmond upon Thames, TW9 1QS',
    '',
    '',
    'Current',
    0,
    '',
    'high'
);

INSERT INTO leaseholders (
    id, unit_id, leaseholder_name, correspondence_address,
    telephone, email, status, current_balance,
    data_source, data_quality
)
VALUES (
    '77e29fcc-2534-43a6-b730-c527837c5aa1',
    'b220781e-9503-420c-85a0-6a24f7b970f5',
    'Unknown',
    'The Manor House, Adwincle, Nr Oundle, Northamptonshire, NN14 3EA',
    '',
    '',
    'Current',
    0,
    '',
    'high'
);

INSERT INTO leaseholders (
    id, unit_id, leaseholder_name, correspondence_address,
    telephone, email, status, current_balance,
    data_source, data_quality
)
VALUES (
    'e8c0a655-6492-4e88-a4a2-0631df047ac0',
    '891eba80-7a8c-4d3e-ad1c-237dcaa83746',
    'Unknown',
    'Lowick, Lincombe Lane, Oxford, OX1 5DZ',
    '',
    '',
    'Current',
    0,
    '',
    'high'
);

INSERT INTO leaseholders (
    id, unit_id, leaseholder_name, correspondence_address,
    telephone, email, status, current_balance,
    data_source, data_quality
)
VALUES (
    '4eacdf23-c646-4e23-8422-b08797a473a7',
    'f0d7291e-8215-4b3f-8d79-01b22be09ac2',
    'Unknown',
    'c/o Phillips & Southern, Onslow Hall 2nd Floor, Little Green, Richmond upon Thames, TW9 1QS',
    '',
    '',
    'Current',
    0,
    '',
    'high'
);

INSERT INTO leaseholders (
    id, unit_id, leaseholder_name, correspondence_address,
    telephone, email, status, current_balance,
    data_source, data_quality
)
VALUES (
    'df8fa9f2-ccc5-48d8-8ef2-db5de69e8475',
    '238c328c-25f2-46b8-a5d2-8515ed39a67f',
    'Unknown',
    'c/o Phillips & Southern, Onslow Hall 2nd Floor, Little Green, Richmond upon Thames, TW9 1QS',
    '',
    '',
    'Current',
    0,
    '',
    'high'
);

INSERT INTO leaseholders (
    id, unit_id, leaseholder_name, correspondence_address,
    telephone, email, status, current_balance,
    data_source, data_quality
)
VALUES (
    '4c136e64-fd07-47a3-9215-18650413aec4',
    '21ba9480-b850-40f8-be3d-f7686c3b04df',
    'Unknown',
    'c/o JMW Property Management, 71-75 Shelton Street, London, WC2H 9JQ',
    '',
    '',
    'Current',
    0,
    '',
    'high'
);

INSERT INTO leaseholders (
    id, unit_id, leaseholder_name, correspondence_address,
    telephone, email, status, current_balance,
    data_source, data_quality
)
VALUES (
    '873b0849-695f-432e-be3a-af22d80a3846',
    'ca41a5f5-b865-4223-afcd-300fb91d9929',
    'Unknown',
    'Flat F5, Pimlico Place, 28 Guildhouse Street, Pimlico, London, SW1V 1JJ',
    '',
    '',
    'Current',
    0,
    '',
    'high'
);

INSERT INTO leaseholders (
    id, unit_id, leaseholder_name, correspondence_address,
    telephone, email, status, current_balance,
    data_source, data_quality
)
VALUES (
    'cccd5117-3acc-4dd4-be59-b209eceb3f41',
    '5117002c-faa0-46ef-886e-412a3c3a49c5',
    'Unknown',
    'Apartment 70, Consort Rise House, 203 Buckingham Palace Road, London, SW1W 9TB',
    '',
    '',
    'Current',
    0,
    '',
    'high'
);

INSERT INTO leaseholders (
    id, unit_id, leaseholder_name, correspondence_address,
    telephone, email, status, current_balance,
    data_source, data_quality
)
VALUES (
    '429365b2-0129-4bca-b5f9-dac1ea6c7061',
    '3da9ce10-361a-4ef8-bf58-b2be8887b311',
    'Unknown',
    '49 Wood Vale, Dulwich, London, SE23 3DT',
    '',
    '',
    'Current',
    0,
    '',
    'high'
);

INSERT INTO leaseholders (
    id, unit_id, leaseholder_name, correspondence_address,
    telephone, email, status, current_balance,
    data_source, data_quality
)
VALUES (
    '2219b389-5928-4326-a09e-fbcf7751fc04',
    '15133ce6-b3a1-499f-9dd0-4d6cacc00902',
    'Unknown',
    'Pimlico Place - Hindon Court Shared Costs, Olympic Office Centre, 8 Fulton Road, Wembley, HA9 0NU',
    '',
    '',
    'Current',
    0,
    '',
    'high'
);


-- ============================================================================
-- Compliance Assets
-- ============================================================================
-- Note: asset_type_id references compliance_asset_types table
-- Map asset_type to correct UUID from compliance_asset_types table


-- fire_safety
INSERT INTO compliance_assets (
    id, building_id,
    asset_type_id, -- TODO: Replace with actual UUID from compliance_asset_types WHERE asset_type_code = 'UNKNOWN'
    inspection_date, expiry_date, next_due_date,
    status, days_overdue,
    is_inferred, inference_reason, last_known_inspection, evidence_found,
    source_document, data_quality
)
VALUES (
    '0ed1d976-98d7-4829-9e2a-130a8795caa5',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    (SELECT id FROM compliance_asset_types WHERE asset_type_code = 'UNKNOWN' LIMIT 1),
    NULL,
    NULL,
    NULL,
    'unknown',
    NULL,
    FALSE,
    '',
    NULL,
    FALSE,
    '',
    'medium'
);

-- general
INSERT INTO compliance_assets (
    id, building_id,
    asset_type_id, -- TODO: Replace with actual UUID from compliance_asset_types WHERE asset_type_code = 'UNKNOWN'
    inspection_date, expiry_date, next_due_date,
    status, days_overdue,
    is_inferred, inference_reason, last_known_inspection, evidence_found,
    source_document, data_quality
)
VALUES (
    '9d2884a1-6a95-4f77-a826-123da01b0f97',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    (SELECT id FROM compliance_asset_types WHERE asset_type_code = 'UNKNOWN' LIMIT 1),
    NULL,
    NULL,
    NULL,
    'unknown',
    NULL,
    FALSE,
    '',
    NULL,
    FALSE,
    '',
    'medium'
);

-- fire_safety
INSERT INTO compliance_assets (
    id, building_id,
    asset_type_id, -- TODO: Replace with actual UUID from compliance_asset_types WHERE asset_type_code = 'UNKNOWN'
    inspection_date, expiry_date, next_due_date,
    status, days_overdue,
    is_inferred, inference_reason, last_known_inspection, evidence_found,
    source_document, data_quality
)
VALUES (
    'ba0599ca-a785-4e19-8c48-066803f37f8a',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    (SELECT id FROM compliance_asset_types WHERE asset_type_code = 'UNKNOWN' LIMIT 1),
    NULL,
    NULL,
    '2024-01-01',
    'unknown',
    NULL,
    FALSE,
    '',
    NULL,
    FALSE,
    '',
    'medium'
);

-- general
INSERT INTO compliance_assets (
    id, building_id,
    asset_type_id, -- TODO: Replace with actual UUID from compliance_asset_types WHERE asset_type_code = 'UNKNOWN'
    inspection_date, expiry_date, next_due_date,
    status, days_overdue,
    is_inferred, inference_reason, last_known_inspection, evidence_found,
    source_document, data_quality
)
VALUES (
    '1b04ef11-9331-4345-a451-ab0fc8c15ad2',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    (SELECT id FROM compliance_asset_types WHERE asset_type_code = 'UNKNOWN' LIMIT 1),
    NULL,
    NULL,
    NULL,
    'unknown',
    NULL,
    FALSE,
    '',
    NULL,
    FALSE,
    '',
    'medium'
);

-- general
INSERT INTO compliance_assets (
    id, building_id,
    asset_type_id, -- TODO: Replace with actual UUID from compliance_asset_types WHERE asset_type_code = 'UNKNOWN'
    inspection_date, expiry_date, next_due_date,
    status, days_overdue,
    is_inferred, inference_reason, last_known_inspection, evidence_found,
    source_document, data_quality
)
VALUES (
    'c8613c05-73e6-49b0-adae-45a569a7cb76',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    (SELECT id FROM compliance_asset_types WHERE asset_type_code = 'UNKNOWN' LIMIT 1),
    NULL,
    NULL,
    NULL,
    'unknown',
    NULL,
    FALSE,
    '',
    NULL,
    FALSE,
    '',
    'medium'
);

-- general
INSERT INTO compliance_assets (
    id, building_id,
    asset_type_id, -- TODO: Replace with actual UUID from compliance_asset_types WHERE asset_type_code = 'UNKNOWN'
    inspection_date, expiry_date, next_due_date,
    status, days_overdue,
    is_inferred, inference_reason, last_known_inspection, evidence_found,
    source_document, data_quality
)
VALUES (
    '7b845e68-fd52-4fb3-9fb3-54fee6db86af',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    (SELECT id FROM compliance_asset_types WHERE asset_type_code = 'UNKNOWN' LIMIT 1),
    NULL,
    NULL,
    NULL,
    'unknown',
    NULL,
    FALSE,
    '',
    NULL,
    FALSE,
    '',
    'medium'
);

-- general
INSERT INTO compliance_assets (
    id, building_id,
    asset_type_id, -- TODO: Replace with actual UUID from compliance_asset_types WHERE asset_type_code = 'UNKNOWN'
    inspection_date, expiry_date, next_due_date,
    status, days_overdue,
    is_inferred, inference_reason, last_known_inspection, evidence_found,
    source_document, data_quality
)
VALUES (
    '3a030155-7451-4aca-81cc-8616de2c912e',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    (SELECT id FROM compliance_asset_types WHERE asset_type_code = 'UNKNOWN' LIMIT 1),
    NULL,
    NULL,
    NULL,
    'unknown',
    NULL,
    FALSE,
    '',
    NULL,
    FALSE,
    '',
    'medium'
);

-- general
INSERT INTO compliance_assets (
    id, building_id,
    asset_type_id, -- TODO: Replace with actual UUID from compliance_asset_types WHERE asset_type_code = 'UNKNOWN'
    inspection_date, expiry_date, next_due_date,
    status, days_overdue,
    is_inferred, inference_reason, last_known_inspection, evidence_found,
    source_document, data_quality
)
VALUES (
    '04d03a20-7df6-4d0b-a395-625918220429',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    (SELECT id FROM compliance_asset_types WHERE asset_type_code = 'UNKNOWN' LIMIT 1),
    NULL,
    NULL,
    NULL,
    'unknown',
    NULL,
    FALSE,
    '',
    NULL,
    FALSE,
    '',
    'medium'
);

-- general
INSERT INTO compliance_assets (
    id, building_id,
    asset_type_id, -- TODO: Replace with actual UUID from compliance_asset_types WHERE asset_type_code = 'UNKNOWN'
    inspection_date, expiry_date, next_due_date,
    status, days_overdue,
    is_inferred, inference_reason, last_known_inspection, evidence_found,
    source_document, data_quality
)
VALUES (
    'ce275769-fdc1-40f1-ba05-a5725b75a3aa',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    (SELECT id FROM compliance_asset_types WHERE asset_type_code = 'UNKNOWN' LIMIT 1),
    NULL,
    NULL,
    NULL,
    'unknown',
    NULL,
    FALSE,
    '',
    NULL,
    FALSE,
    '',
    'medium'
);

-- general
INSERT INTO compliance_assets (
    id, building_id,
    asset_type_id, -- TODO: Replace with actual UUID from compliance_asset_types WHERE asset_type_code = 'UNKNOWN'
    inspection_date, expiry_date, next_due_date,
    status, days_overdue,
    is_inferred, inference_reason, last_known_inspection, evidence_found,
    source_document, data_quality
)
VALUES (
    'f4c52858-b446-4d4f-8f15-38584bc98165',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    (SELECT id FROM compliance_asset_types WHERE asset_type_code = 'UNKNOWN' LIMIT 1),
    NULL,
    NULL,
    NULL,
    'unknown',
    NULL,
    FALSE,
    '',
    NULL,
    FALSE,
    '',
    'medium'
);

-- general
INSERT INTO compliance_assets (
    id, building_id,
    asset_type_id, -- TODO: Replace with actual UUID from compliance_asset_types WHERE asset_type_code = 'UNKNOWN'
    inspection_date, expiry_date, next_due_date,
    status, days_overdue,
    is_inferred, inference_reason, last_known_inspection, evidence_found,
    source_document, data_quality
)
VALUES (
    '983921c9-fdcb-4397-893e-35ff29657a1a',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    (SELECT id FROM compliance_asset_types WHERE asset_type_code = 'UNKNOWN' LIMIT 1),
    NULL,
    NULL,
    NULL,
    'unknown',
    NULL,
    FALSE,
    '',
    NULL,
    FALSE,
    '',
    'medium'
);

-- general
INSERT INTO compliance_assets (
    id, building_id,
    asset_type_id, -- TODO: Replace with actual UUID from compliance_asset_types WHERE asset_type_code = 'UNKNOWN'
    inspection_date, expiry_date, next_due_date,
    status, days_overdue,
    is_inferred, inference_reason, last_known_inspection, evidence_found,
    source_document, data_quality
)
VALUES (
    '127c611f-f4fc-4830-9c54-57fdcc48f69c',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    (SELECT id FROM compliance_asset_types WHERE asset_type_code = 'UNKNOWN' LIMIT 1),
    NULL,
    NULL,
    NULL,
    'unknown',
    NULL,
    FALSE,
    '',
    NULL,
    FALSE,
    '',
    'medium'
);

-- general
INSERT INTO compliance_assets (
    id, building_id,
    asset_type_id, -- TODO: Replace with actual UUID from compliance_asset_types WHERE asset_type_code = 'UNKNOWN'
    inspection_date, expiry_date, next_due_date,
    status, days_overdue,
    is_inferred, inference_reason, last_known_inspection, evidence_found,
    source_document, data_quality
)
VALUES (
    '42fec104-b17f-4bd0-bcc6-3eb498d9ebfd',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    (SELECT id FROM compliance_asset_types WHERE asset_type_code = 'UNKNOWN' LIMIT 1),
    NULL,
    NULL,
    NULL,
    'unknown',
    NULL,
    FALSE,
    '',
    NULL,
    FALSE,
    '',
    'medium'
);

-- general
INSERT INTO compliance_assets (
    id, building_id,
    asset_type_id, -- TODO: Replace with actual UUID from compliance_asset_types WHERE asset_type_code = 'UNKNOWN'
    inspection_date, expiry_date, next_due_date,
    status, days_overdue,
    is_inferred, inference_reason, last_known_inspection, evidence_found,
    source_document, data_quality
)
VALUES (
    '16d577f6-1b18-42f1-842b-c9d30c363fab',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    (SELECT id FROM compliance_asset_types WHERE asset_type_code = 'UNKNOWN' LIMIT 1),
    NULL,
    NULL,
    NULL,
    'unknown',
    NULL,
    FALSE,
    '',
    NULL,
    FALSE,
    '',
    'medium'
);

-- general
INSERT INTO compliance_assets (
    id, building_id,
    asset_type_id, -- TODO: Replace with actual UUID from compliance_asset_types WHERE asset_type_code = 'UNKNOWN'
    inspection_date, expiry_date, next_due_date,
    status, days_overdue,
    is_inferred, inference_reason, last_known_inspection, evidence_found,
    source_document, data_quality
)
VALUES (
    '087f3cea-8a4a-4585-9f31-21808e41eeb6',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    (SELECT id FROM compliance_asset_types WHERE asset_type_code = 'UNKNOWN' LIMIT 1),
    NULL,
    NULL,
    NULL,
    'unknown',
    NULL,
    FALSE,
    '',
    NULL,
    FALSE,
    '',
    'medium'
);

-- general
INSERT INTO compliance_assets (
    id, building_id,
    asset_type_id, -- TODO: Replace with actual UUID from compliance_asset_types WHERE asset_type_code = 'UNKNOWN'
    inspection_date, expiry_date, next_due_date,
    status, days_overdue,
    is_inferred, inference_reason, last_known_inspection, evidence_found,
    source_document, data_quality
)
VALUES (
    '6bac01c1-8530-4e2c-9901-37c73a3c1d2e',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    (SELECT id FROM compliance_asset_types WHERE asset_type_code = 'UNKNOWN' LIMIT 1),
    NULL,
    NULL,
    NULL,
    'unknown',
    NULL,
    FALSE,
    '',
    NULL,
    FALSE,
    '',
    'medium'
);

-- general
INSERT INTO compliance_assets (
    id, building_id,
    asset_type_id, -- TODO: Replace with actual UUID from compliance_asset_types WHERE asset_type_code = 'UNKNOWN'
    inspection_date, expiry_date, next_due_date,
    status, days_overdue,
    is_inferred, inference_reason, last_known_inspection, evidence_found,
    source_document, data_quality
)
VALUES (
    'f5d77e9b-0c9a-4fb0-aba1-1504982beb71',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    (SELECT id FROM compliance_asset_types WHERE asset_type_code = 'UNKNOWN' LIMIT 1),
    NULL,
    NULL,
    NULL,
    'unknown',
    NULL,
    FALSE,
    '',
    NULL,
    FALSE,
    '',
    'medium'
);

-- general
INSERT INTO compliance_assets (
    id, building_id,
    asset_type_id, -- TODO: Replace with actual UUID from compliance_asset_types WHERE asset_type_code = 'UNKNOWN'
    inspection_date, expiry_date, next_due_date,
    status, days_overdue,
    is_inferred, inference_reason, last_known_inspection, evidence_found,
    source_document, data_quality
)
VALUES (
    '2b12be73-9502-4683-b1f3-e653b48246fe',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    (SELECT id FROM compliance_asset_types WHERE asset_type_code = 'UNKNOWN' LIMIT 1),
    NULL,
    NULL,
    NULL,
    'unknown',
    NULL,
    FALSE,
    '',
    NULL,
    FALSE,
    '',
    'medium'
);

-- general
INSERT INTO compliance_assets (
    id, building_id,
    asset_type_id, -- TODO: Replace with actual UUID from compliance_asset_types WHERE asset_type_code = 'UNKNOWN'
    inspection_date, expiry_date, next_due_date,
    status, days_overdue,
    is_inferred, inference_reason, last_known_inspection, evidence_found,
    source_document, data_quality
)
VALUES (
    '04118965-10a9-45d1-a43c-83feea466991',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    (SELECT id FROM compliance_asset_types WHERE asset_type_code = 'UNKNOWN' LIMIT 1),
    NULL,
    NULL,
    NULL,
    'unknown',
    NULL,
    FALSE,
    '',
    NULL,
    FALSE,
    '',
    'medium'
);

-- general
INSERT INTO compliance_assets (
    id, building_id,
    asset_type_id, -- TODO: Replace with actual UUID from compliance_asset_types WHERE asset_type_code = 'UNKNOWN'
    inspection_date, expiry_date, next_due_date,
    status, days_overdue,
    is_inferred, inference_reason, last_known_inspection, evidence_found,
    source_document, data_quality
)
VALUES (
    '1287380b-dad5-451c-bac9-8c003dbc5792',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    (SELECT id FROM compliance_asset_types WHERE asset_type_code = 'UNKNOWN' LIMIT 1),
    NULL,
    NULL,
    NULL,
    'unknown',
    NULL,
    FALSE,
    '',
    NULL,
    FALSE,
    '',
    'medium'
);

-- fire_safety
INSERT INTO compliance_assets (
    id, building_id,
    asset_type_id, -- TODO: Replace with actual UUID from compliance_asset_types WHERE asset_type_code = 'UNKNOWN'
    inspection_date, expiry_date, next_due_date,
    status, days_overdue,
    is_inferred, inference_reason, last_known_inspection, evidence_found,
    source_document, data_quality
)
VALUES (
    '626a4345-e12c-496f-8cef-8630e6d968c0',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    (SELECT id FROM compliance_asset_types WHERE asset_type_code = 'UNKNOWN' LIMIT 1),
    NULL,
    NULL,
    NULL,
    'unknown',
    NULL,
    FALSE,
    '',
    NULL,
    FALSE,
    '',
    'medium'
);

-- fire_safety
INSERT INTO compliance_assets (
    id, building_id,
    asset_type_id, -- TODO: Replace with actual UUID from compliance_asset_types WHERE asset_type_code = 'UNKNOWN'
    inspection_date, expiry_date, next_due_date,
    status, days_overdue,
    is_inferred, inference_reason, last_known_inspection, evidence_found,
    source_document, data_quality
)
VALUES (
    'c1a226b4-f48d-4056-8390-c23cffff4229',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    (SELECT id FROM compliance_asset_types WHERE asset_type_code = 'UNKNOWN' LIMIT 1),
    NULL,
    NULL,
    NULL,
    'unknown',
    NULL,
    FALSE,
    '',
    NULL,
    FALSE,
    '',
    'medium'
);

-- fire_safety
INSERT INTO compliance_assets (
    id, building_id,
    asset_type_id, -- TODO: Replace with actual UUID from compliance_asset_types WHERE asset_type_code = 'UNKNOWN'
    inspection_date, expiry_date, next_due_date,
    status, days_overdue,
    is_inferred, inference_reason, last_known_inspection, evidence_found,
    source_document, data_quality
)
VALUES (
    '82eb5c4d-9b40-4295-843a-2b7ddf29d287',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    (SELECT id FROM compliance_asset_types WHERE asset_type_code = 'UNKNOWN' LIMIT 1),
    NULL,
    NULL,
    '2024-01-01',
    'unknown',
    NULL,
    FALSE,
    '',
    NULL,
    FALSE,
    '',
    'medium'
);

-- fire_safety
INSERT INTO compliance_assets (
    id, building_id,
    asset_type_id, -- TODO: Replace with actual UUID from compliance_asset_types WHERE asset_type_code = 'UNKNOWN'
    inspection_date, expiry_date, next_due_date,
    status, days_overdue,
    is_inferred, inference_reason, last_known_inspection, evidence_found,
    source_document, data_quality
)
VALUES (
    'a958d251-578b-462c-9238-5cf942615da3',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    (SELECT id FROM compliance_asset_types WHERE asset_type_code = 'UNKNOWN' LIMIT 1),
    NULL,
    NULL,
    '2024-01-01',
    'unknown',
    NULL,
    FALSE,
    '',
    NULL,
    FALSE,
    '',
    'medium'
);

-- fire_safety
INSERT INTO compliance_assets (
    id, building_id,
    asset_type_id, -- TODO: Replace with actual UUID from compliance_asset_types WHERE asset_type_code = 'UNKNOWN'
    inspection_date, expiry_date, next_due_date,
    status, days_overdue,
    is_inferred, inference_reason, last_known_inspection, evidence_found,
    source_document, data_quality
)
VALUES (
    '81f528a6-0e68-4384-8226-ab5d23be44f8',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    (SELECT id FROM compliance_asset_types WHERE asset_type_code = 'UNKNOWN' LIMIT 1),
    NULL,
    NULL,
    '2024-01-01',
    'unknown',
    NULL,
    FALSE,
    '',
    NULL,
    FALSE,
    '',
    'medium'
);

-- fire_safety
INSERT INTO compliance_assets (
    id, building_id,
    asset_type_id, -- TODO: Replace with actual UUID from compliance_asset_types WHERE asset_type_code = 'UNKNOWN'
    inspection_date, expiry_date, next_due_date,
    status, days_overdue,
    is_inferred, inference_reason, last_known_inspection, evidence_found,
    source_document, data_quality
)
VALUES (
    'c936b101-f15a-410c-9bf4-5f377ffa0066',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    (SELECT id FROM compliance_asset_types WHERE asset_type_code = 'UNKNOWN' LIMIT 1),
    NULL,
    NULL,
    NULL,
    'unknown',
    NULL,
    FALSE,
    '',
    NULL,
    FALSE,
    '',
    'medium'
);

-- general
INSERT INTO compliance_assets (
    id, building_id,
    asset_type_id, -- TODO: Replace with actual UUID from compliance_asset_types WHERE asset_type_code = 'UNKNOWN'
    inspection_date, expiry_date, next_due_date,
    status, days_overdue,
    is_inferred, inference_reason, last_known_inspection, evidence_found,
    source_document, data_quality
)
VALUES (
    '43754124-4374-441f-8b50-63e8db4c017d',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    (SELECT id FROM compliance_asset_types WHERE asset_type_code = 'UNKNOWN' LIMIT 1),
    NULL,
    NULL,
    NULL,
    'unknown',
    NULL,
    FALSE,
    '',
    NULL,
    FALSE,
    '',
    'medium'
);

-- electrical
INSERT INTO compliance_assets (
    id, building_id,
    asset_type_id, -- TODO: Replace with actual UUID from compliance_asset_types WHERE asset_type_code = 'UNKNOWN'
    inspection_date, expiry_date, next_due_date,
    status, days_overdue,
    is_inferred, inference_reason, last_known_inspection, evidence_found,
    source_document, data_quality
)
VALUES (
    '8362323b-65eb-42b5-b2fa-db0b0a5264c8',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    (SELECT id FROM compliance_asset_types WHERE asset_type_code = 'UNKNOWN' LIMIT 1),
    NULL,
    NULL,
    NULL,
    'unknown',
    NULL,
    FALSE,
    '',
    NULL,
    FALSE,
    '',
    'medium'
);

-- electrical
INSERT INTO compliance_assets (
    id, building_id,
    asset_type_id, -- TODO: Replace with actual UUID from compliance_asset_types WHERE asset_type_code = 'UNKNOWN'
    inspection_date, expiry_date, next_due_date,
    status, days_overdue,
    is_inferred, inference_reason, last_known_inspection, evidence_found,
    source_document, data_quality
)
VALUES (
    'a3dfed82-5d30-4f78-add7-05c24fe35795',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    (SELECT id FROM compliance_asset_types WHERE asset_type_code = 'UNKNOWN' LIMIT 1),
    NULL,
    NULL,
    NULL,
    'unknown',
    NULL,
    FALSE,
    '',
    NULL,
    FALSE,
    '',
    'medium'
);

-- electrical
INSERT INTO compliance_assets (
    id, building_id,
    asset_type_id, -- TODO: Replace with actual UUID from compliance_asset_types WHERE asset_type_code = 'UNKNOWN'
    inspection_date, expiry_date, next_due_date,
    status, days_overdue,
    is_inferred, inference_reason, last_known_inspection, evidence_found,
    source_document, data_quality
)
VALUES (
    '21d73dfc-3054-4f2d-97e4-fe10efa2a683',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    (SELECT id FROM compliance_asset_types WHERE asset_type_code = 'UNKNOWN' LIMIT 1),
    NULL,
    NULL,
    NULL,
    'unknown',
    NULL,
    FALSE,
    '',
    NULL,
    FALSE,
    '',
    'medium'
);

-- electrical
INSERT INTO compliance_assets (
    id, building_id,
    asset_type_id, -- TODO: Replace with actual UUID from compliance_asset_types WHERE asset_type_code = 'UNKNOWN'
    inspection_date, expiry_date, next_due_date,
    status, days_overdue,
    is_inferred, inference_reason, last_known_inspection, evidence_found,
    source_document, data_quality
)
VALUES (
    'e5bb86ff-15da-4d3f-9201-2ff0ea33eaa9',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    (SELECT id FROM compliance_asset_types WHERE asset_type_code = 'UNKNOWN' LIMIT 1),
    NULL,
    NULL,
    NULL,
    'unknown',
    NULL,
    FALSE,
    '',
    NULL,
    FALSE,
    '',
    'medium'
);

-- electrical
INSERT INTO compliance_assets (
    id, building_id,
    asset_type_id, -- TODO: Replace with actual UUID from compliance_asset_types WHERE asset_type_code = 'UNKNOWN'
    inspection_date, expiry_date, next_due_date,
    status, days_overdue,
    is_inferred, inference_reason, last_known_inspection, evidence_found,
    source_document, data_quality
)
VALUES (
    '739fe120-9cc4-4281-9d73-3cd0ff1c037b',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    (SELECT id FROM compliance_asset_types WHERE asset_type_code = 'UNKNOWN' LIMIT 1),
    NULL,
    NULL,
    NULL,
    'unknown',
    NULL,
    FALSE,
    '',
    NULL,
    FALSE,
    '',
    'medium'
);

-- general
INSERT INTO compliance_assets (
    id, building_id,
    asset_type_id, -- TODO: Replace with actual UUID from compliance_asset_types WHERE asset_type_code = 'UNKNOWN'
    inspection_date, expiry_date, next_due_date,
    status, days_overdue,
    is_inferred, inference_reason, last_known_inspection, evidence_found,
    source_document, data_quality
)
VALUES (
    '423df053-7bc1-43c5-a47c-99baa998d851',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    (SELECT id FROM compliance_asset_types WHERE asset_type_code = 'UNKNOWN' LIMIT 1),
    NULL,
    NULL,
    NULL,
    'unknown',
    NULL,
    FALSE,
    '',
    NULL,
    FALSE,
    '',
    'medium'
);

-- general
INSERT INTO compliance_assets (
    id, building_id,
    asset_type_id, -- TODO: Replace with actual UUID from compliance_asset_types WHERE asset_type_code = 'UNKNOWN'
    inspection_date, expiry_date, next_due_date,
    status, days_overdue,
    is_inferred, inference_reason, last_known_inspection, evidence_found,
    source_document, data_quality
)
VALUES (
    'e70648e9-4906-492a-8ae0-5130f100c6e9',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    (SELECT id FROM compliance_asset_types WHERE asset_type_code = 'UNKNOWN' LIMIT 1),
    NULL,
    NULL,
    NULL,
    'unknown',
    NULL,
    FALSE,
    '',
    NULL,
    FALSE,
    '',
    'medium'
);

-- general
INSERT INTO compliance_assets (
    id, building_id,
    asset_type_id, -- TODO: Replace with actual UUID from compliance_asset_types WHERE asset_type_code = 'UNKNOWN'
    inspection_date, expiry_date, next_due_date,
    status, days_overdue,
    is_inferred, inference_reason, last_known_inspection, evidence_found,
    source_document, data_quality
)
VALUES (
    '97ddb8bd-84ed-44ef-8312-620bff0429f1',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    (SELECT id FROM compliance_asset_types WHERE asset_type_code = 'UNKNOWN' LIMIT 1),
    NULL,
    NULL,
    NULL,
    'unknown',
    NULL,
    FALSE,
    '',
    NULL,
    FALSE,
    '',
    'medium'
);

-- general
INSERT INTO compliance_assets (
    id, building_id,
    asset_type_id, -- TODO: Replace with actual UUID from compliance_asset_types WHERE asset_type_code = 'UNKNOWN'
    inspection_date, expiry_date, next_due_date,
    status, days_overdue,
    is_inferred, inference_reason, last_known_inspection, evidence_found,
    source_document, data_quality
)
VALUES (
    '4bf0a859-98d6-4ad8-a02e-0a5d52712d25',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    (SELECT id FROM compliance_asset_types WHERE asset_type_code = 'UNKNOWN' LIMIT 1),
    NULL,
    NULL,
    NULL,
    'unknown',
    NULL,
    FALSE,
    '',
    NULL,
    FALSE,
    '',
    'medium'
);

-- general
INSERT INTO compliance_assets (
    id, building_id,
    asset_type_id, -- TODO: Replace with actual UUID from compliance_asset_types WHERE asset_type_code = 'UNKNOWN'
    inspection_date, expiry_date, next_due_date,
    status, days_overdue,
    is_inferred, inference_reason, last_known_inspection, evidence_found,
    source_document, data_quality
)
VALUES (
    '37a32495-03a1-44c0-ab08-46eb4a8994f9',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    (SELECT id FROM compliance_asset_types WHERE asset_type_code = 'UNKNOWN' LIMIT 1),
    NULL,
    NULL,
    '2023-01-01',
    'unknown',
    NULL,
    FALSE,
    '',
    NULL,
    FALSE,
    '',
    'medium'
);

-- general
INSERT INTO compliance_assets (
    id, building_id,
    asset_type_id, -- TODO: Replace with actual UUID from compliance_asset_types WHERE asset_type_code = 'UNKNOWN'
    inspection_date, expiry_date, next_due_date,
    status, days_overdue,
    is_inferred, inference_reason, last_known_inspection, evidence_found,
    source_document, data_quality
)
VALUES (
    'ca2fd693-b474-4772-9911-33d72d245e52',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    (SELECT id FROM compliance_asset_types WHERE asset_type_code = 'UNKNOWN' LIMIT 1),
    NULL,
    NULL,
    '2023-01-01',
    'unknown',
    NULL,
    FALSE,
    '',
    NULL,
    FALSE,
    '',
    'medium'
);

-- general
INSERT INTO compliance_assets (
    id, building_id,
    asset_type_id, -- TODO: Replace with actual UUID from compliance_asset_types WHERE asset_type_code = 'UNKNOWN'
    inspection_date, expiry_date, next_due_date,
    status, days_overdue,
    is_inferred, inference_reason, last_known_inspection, evidence_found,
    source_document, data_quality
)
VALUES (
    'dd099e09-6c27-4d65-bcb9-cd63f87f06c6',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    (SELECT id FROM compliance_asset_types WHERE asset_type_code = 'UNKNOWN' LIMIT 1),
    NULL,
    NULL,
    '2023-01-01',
    'unknown',
    NULL,
    FALSE,
    '',
    NULL,
    FALSE,
    '',
    'medium'
);

-- general
INSERT INTO compliance_assets (
    id, building_id,
    asset_type_id, -- TODO: Replace with actual UUID from compliance_asset_types WHERE asset_type_code = 'UNKNOWN'
    inspection_date, expiry_date, next_due_date,
    status, days_overdue,
    is_inferred, inference_reason, last_known_inspection, evidence_found,
    source_document, data_quality
)
VALUES (
    'c8cca9a7-22eb-4610-9ddd-36d53009b72f',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    (SELECT id FROM compliance_asset_types WHERE asset_type_code = 'UNKNOWN' LIMIT 1),
    NULL,
    NULL,
    '2021-01-01',
    'unknown',
    NULL,
    FALSE,
    '',
    NULL,
    FALSE,
    '',
    'medium'
);

-- general
INSERT INTO compliance_assets (
    id, building_id,
    asset_type_id, -- TODO: Replace with actual UUID from compliance_asset_types WHERE asset_type_code = 'UNKNOWN'
    inspection_date, expiry_date, next_due_date,
    status, days_overdue,
    is_inferred, inference_reason, last_known_inspection, evidence_found,
    source_document, data_quality
)
VALUES (
    'c3159de0-c54d-4b35-8835-40468780bfc3',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    (SELECT id FROM compliance_asset_types WHERE asset_type_code = 'UNKNOWN' LIMIT 1),
    NULL,
    NULL,
    NULL,
    'unknown',
    NULL,
    FALSE,
    '',
    NULL,
    FALSE,
    '',
    'medium'
);

-- general
INSERT INTO compliance_assets (
    id, building_id,
    asset_type_id, -- TODO: Replace with actual UUID from compliance_asset_types WHERE asset_type_code = 'UNKNOWN'
    inspection_date, expiry_date, next_due_date,
    status, days_overdue,
    is_inferred, inference_reason, last_known_inspection, evidence_found,
    source_document, data_quality
)
VALUES (
    '6ac678ef-baff-42cd-9ba0-03d4d4b4f2d7',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    (SELECT id FROM compliance_asset_types WHERE asset_type_code = 'UNKNOWN' LIMIT 1),
    NULL,
    NULL,
    NULL,
    'unknown',
    NULL,
    FALSE,
    '',
    NULL,
    FALSE,
    '',
    'medium'
);

-- general
INSERT INTO compliance_assets (
    id, building_id,
    asset_type_id, -- TODO: Replace with actual UUID from compliance_asset_types WHERE asset_type_code = 'UNKNOWN'
    inspection_date, expiry_date, next_due_date,
    status, days_overdue,
    is_inferred, inference_reason, last_known_inspection, evidence_found,
    source_document, data_quality
)
VALUES (
    '3458af14-52c9-457e-b51d-c1968e976cd3',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    (SELECT id FROM compliance_asset_types WHERE asset_type_code = 'UNKNOWN' LIMIT 1),
    NULL,
    NULL,
    NULL,
    'unknown',
    NULL,
    FALSE,
    '',
    NULL,
    FALSE,
    '',
    'medium'
);

-- general
INSERT INTO compliance_assets (
    id, building_id,
    asset_type_id, -- TODO: Replace with actual UUID from compliance_asset_types WHERE asset_type_code = 'UNKNOWN'
    inspection_date, expiry_date, next_due_date,
    status, days_overdue,
    is_inferred, inference_reason, last_known_inspection, evidence_found,
    source_document, data_quality
)
VALUES (
    'a71a2b62-79ec-4a2a-a1ec-7c6871d6da1d',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    (SELECT id FROM compliance_asset_types WHERE asset_type_code = 'UNKNOWN' LIMIT 1),
    NULL,
    NULL,
    '2023-08-12',
    'unknown',
    NULL,
    FALSE,
    '',
    NULL,
    FALSE,
    '',
    'medium'
);

-- general
INSERT INTO compliance_assets (
    id, building_id,
    asset_type_id, -- TODO: Replace with actual UUID from compliance_asset_types WHERE asset_type_code = 'UNKNOWN'
    inspection_date, expiry_date, next_due_date,
    status, days_overdue,
    is_inferred, inference_reason, last_known_inspection, evidence_found,
    source_document, data_quality
)
VALUES (
    '3abad4e6-09ee-4f7e-8345-30d8c4279f58',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    (SELECT id FROM compliance_asset_types WHERE asset_type_code = 'UNKNOWN' LIMIT 1),
    NULL,
    NULL,
    '2023-08-12',
    'unknown',
    NULL,
    FALSE,
    '',
    NULL,
    FALSE,
    '',
    'medium'
);

-- general
INSERT INTO compliance_assets (
    id, building_id,
    asset_type_id, -- TODO: Replace with actual UUID from compliance_asset_types WHERE asset_type_code = 'UNKNOWN'
    inspection_date, expiry_date, next_due_date,
    status, days_overdue,
    is_inferred, inference_reason, last_known_inspection, evidence_found,
    source_document, data_quality
)
VALUES (
    'b0639fcf-489b-4316-bca5-96b7c5c6fd19',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    (SELECT id FROM compliance_asset_types WHERE asset_type_code = 'UNKNOWN' LIMIT 1),
    NULL,
    NULL,
    NULL,
    'unknown',
    NULL,
    FALSE,
    '',
    NULL,
    FALSE,
    '',
    'medium'
);

-- general
INSERT INTO compliance_assets (
    id, building_id,
    asset_type_id, -- TODO: Replace with actual UUID from compliance_asset_types WHERE asset_type_code = 'UNKNOWN'
    inspection_date, expiry_date, next_due_date,
    status, days_overdue,
    is_inferred, inference_reason, last_known_inspection, evidence_found,
    source_document, data_quality
)
VALUES (
    '1dd303b1-2707-4acd-b7a9-20fb2efa4be5',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    (SELECT id FROM compliance_asset_types WHERE asset_type_code = 'UNKNOWN' LIMIT 1),
    NULL,
    NULL,
    '2026-08-13',
    'unknown',
    NULL,
    FALSE,
    '',
    NULL,
    FALSE,
    '',
    'medium'
);

-- general
INSERT INTO compliance_assets (
    id, building_id,
    asset_type_id, -- TODO: Replace with actual UUID from compliance_asset_types WHERE asset_type_code = 'UNKNOWN'
    inspection_date, expiry_date, next_due_date,
    status, days_overdue,
    is_inferred, inference_reason, last_known_inspection, evidence_found,
    source_document, data_quality
)
VALUES (
    'b6b6b60a-69a9-4c41-b987-0b9130a6eac6',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    (SELECT id FROM compliance_asset_types WHERE asset_type_code = 'UNKNOWN' LIMIT 1),
    NULL,
    NULL,
    NULL,
    'unknown',
    NULL,
    FALSE,
    '',
    NULL,
    FALSE,
    '',
    'medium'
);

-- general
INSERT INTO compliance_assets (
    id, building_id,
    asset_type_id, -- TODO: Replace with actual UUID from compliance_asset_types WHERE asset_type_code = 'UNKNOWN'
    inspection_date, expiry_date, next_due_date,
    status, days_overdue,
    is_inferred, inference_reason, last_known_inspection, evidence_found,
    source_document, data_quality
)
VALUES (
    'cf9c062f-a594-4648-9476-545fbb388828',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    (SELECT id FROM compliance_asset_types WHERE asset_type_code = 'UNKNOWN' LIMIT 1),
    NULL,
    NULL,
    '2026-08-13',
    'unknown',
    NULL,
    FALSE,
    '',
    NULL,
    FALSE,
    '',
    'medium'
);

-- general
INSERT INTO compliance_assets (
    id, building_id,
    asset_type_id, -- TODO: Replace with actual UUID from compliance_asset_types WHERE asset_type_code = 'UNKNOWN'
    inspection_date, expiry_date, next_due_date,
    status, days_overdue,
    is_inferred, inference_reason, last_known_inspection, evidence_found,
    source_document, data_quality
)
VALUES (
    '92d3290f-52f3-4bde-a0a4-26536a5052eb',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    (SELECT id FROM compliance_asset_types WHERE asset_type_code = 'UNKNOWN' LIMIT 1),
    NULL,
    NULL,
    NULL,
    'unknown',
    NULL,
    FALSE,
    '',
    NULL,
    FALSE,
    '',
    'medium'
);

-- general
INSERT INTO compliance_assets (
    id, building_id,
    asset_type_id, -- TODO: Replace with actual UUID from compliance_asset_types WHERE asset_type_code = 'UNKNOWN'
    inspection_date, expiry_date, next_due_date,
    status, days_overdue,
    is_inferred, inference_reason, last_known_inspection, evidence_found,
    source_document, data_quality
)
VALUES (
    'd2c9065c-9666-444b-8a91-1349450cf4dd',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    (SELECT id FROM compliance_asset_types WHERE asset_type_code = 'UNKNOWN' LIMIT 1),
    NULL,
    NULL,
    '2026-04-30',
    'unknown',
    NULL,
    FALSE,
    '',
    NULL,
    FALSE,
    '',
    'medium'
);

-- general
INSERT INTO compliance_assets (
    id, building_id,
    asset_type_id, -- TODO: Replace with actual UUID from compliance_asset_types WHERE asset_type_code = 'UNKNOWN'
    inspection_date, expiry_date, next_due_date,
    status, days_overdue,
    is_inferred, inference_reason, last_known_inspection, evidence_found,
    source_document, data_quality
)
VALUES (
    '4f81f405-6930-4ac5-9ccc-cff9d65d796e',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    (SELECT id FROM compliance_asset_types WHERE asset_type_code = 'UNKNOWN' LIMIT 1),
    NULL,
    NULL,
    '2023-05-24',
    'unknown',
    NULL,
    FALSE,
    '',
    NULL,
    FALSE,
    '',
    'medium'
);

-- general
INSERT INTO compliance_assets (
    id, building_id,
    asset_type_id, -- TODO: Replace with actual UUID from compliance_asset_types WHERE asset_type_code = 'UNKNOWN'
    inspection_date, expiry_date, next_due_date,
    status, days_overdue,
    is_inferred, inference_reason, last_known_inspection, evidence_found,
    source_document, data_quality
)
VALUES (
    '401655af-59f3-45c7-aaa3-4cfa300abb1f',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    (SELECT id FROM compliance_asset_types WHERE asset_type_code = 'UNKNOWN' LIMIT 1),
    NULL,
    NULL,
    NULL,
    'unknown',
    NULL,
    FALSE,
    '',
    NULL,
    FALSE,
    '',
    'medium'
);

-- general
INSERT INTO compliance_assets (
    id, building_id,
    asset_type_id, -- TODO: Replace with actual UUID from compliance_asset_types WHERE asset_type_code = 'UNKNOWN'
    inspection_date, expiry_date, next_due_date,
    status, days_overdue,
    is_inferred, inference_reason, last_known_inspection, evidence_found,
    source_document, data_quality
)
VALUES (
    '6ff95e93-624e-435f-af5c-4fe43213c082',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    (SELECT id FROM compliance_asset_types WHERE asset_type_code = 'UNKNOWN' LIMIT 1),
    NULL,
    NULL,
    NULL,
    'unknown',
    NULL,
    FALSE,
    '',
    NULL,
    FALSE,
    '',
    'medium'
);

-- general
INSERT INTO compliance_assets (
    id, building_id,
    asset_type_id, -- TODO: Replace with actual UUID from compliance_asset_types WHERE asset_type_code = 'UNKNOWN'
    inspection_date, expiry_date, next_due_date,
    status, days_overdue,
    is_inferred, inference_reason, last_known_inspection, evidence_found,
    source_document, data_quality
)
VALUES (
    '2756027a-21d9-4184-95b3-f022b006b53a',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    (SELECT id FROM compliance_asset_types WHERE asset_type_code = 'UNKNOWN' LIMIT 1),
    NULL,
    NULL,
    '2026-01-01',
    'unknown',
    NULL,
    FALSE,
    '',
    NULL,
    FALSE,
    '',
    'medium'
);

-- general
INSERT INTO compliance_assets (
    id, building_id,
    asset_type_id, -- TODO: Replace with actual UUID from compliance_asset_types WHERE asset_type_code = 'UNKNOWN'
    inspection_date, expiry_date, next_due_date,
    status, days_overdue,
    is_inferred, inference_reason, last_known_inspection, evidence_found,
    source_document, data_quality
)
VALUES (
    '7a8a3499-64ee-4251-9a18-b28a21991e64',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    (SELECT id FROM compliance_asset_types WHERE asset_type_code = 'UNKNOWN' LIMIT 1),
    NULL,
    NULL,
    NULL,
    'unknown',
    NULL,
    FALSE,
    '',
    NULL,
    FALSE,
    '',
    'medium'
);

-- general
INSERT INTO compliance_assets (
    id, building_id,
    asset_type_id, -- TODO: Replace with actual UUID from compliance_asset_types WHERE asset_type_code = 'UNKNOWN'
    inspection_date, expiry_date, next_due_date,
    status, days_overdue,
    is_inferred, inference_reason, last_known_inspection, evidence_found,
    source_document, data_quality
)
VALUES (
    '27d6c18e-908b-4dfd-b5ae-e67b531269b5',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    (SELECT id FROM compliance_asset_types WHERE asset_type_code = 'UNKNOWN' LIMIT 1),
    NULL,
    NULL,
    NULL,
    'unknown',
    NULL,
    FALSE,
    '',
    NULL,
    FALSE,
    '',
    'medium'
);

-- lift_safety
INSERT INTO compliance_assets (
    id, building_id,
    asset_type_id, -- TODO: Replace with actual UUID from compliance_asset_types WHERE asset_type_code = 'UNKNOWN'
    inspection_date, expiry_date, next_due_date,
    status, days_overdue,
    is_inferred, inference_reason, last_known_inspection, evidence_found,
    source_document, data_quality
)
VALUES (
    'e6c35495-2f57-414d-b1df-67e1369b8cc5',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    (SELECT id FROM compliance_asset_types WHERE asset_type_code = 'UNKNOWN' LIMIT 1),
    NULL,
    NULL,
    NULL,
    'unknown',
    NULL,
    FALSE,
    '',
    NULL,
    FALSE,
    '',
    'medium'
);

-- lift_safety
INSERT INTO compliance_assets (
    id, building_id,
    asset_type_id, -- TODO: Replace with actual UUID from compliance_asset_types WHERE asset_type_code = 'UNKNOWN'
    inspection_date, expiry_date, next_due_date,
    status, days_overdue,
    is_inferred, inference_reason, last_known_inspection, evidence_found,
    source_document, data_quality
)
VALUES (
    '2d4f25e0-d441-4b3c-b4da-bb594e5dade4',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    (SELECT id FROM compliance_asset_types WHERE asset_type_code = 'UNKNOWN' LIMIT 1),
    NULL,
    NULL,
    NULL,
    'unknown',
    NULL,
    FALSE,
    '',
    NULL,
    FALSE,
    '',
    'medium'
);

-- lift_safety
INSERT INTO compliance_assets (
    id, building_id,
    asset_type_id, -- TODO: Replace with actual UUID from compliance_asset_types WHERE asset_type_code = 'UNKNOWN'
    inspection_date, expiry_date, next_due_date,
    status, days_overdue,
    is_inferred, inference_reason, last_known_inspection, evidence_found,
    source_document, data_quality
)
VALUES (
    '2aa28388-e9be-4fd2-aea0-6ae3f934d34e',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    (SELECT id FROM compliance_asset_types WHERE asset_type_code = 'UNKNOWN' LIMIT 1),
    NULL,
    NULL,
    NULL,
    'unknown',
    NULL,
    FALSE,
    '',
    NULL,
    FALSE,
    '',
    'medium'
);

-- lift_safety
INSERT INTO compliance_assets (
    id, building_id,
    asset_type_id, -- TODO: Replace with actual UUID from compliance_asset_types WHERE asset_type_code = 'UNKNOWN'
    inspection_date, expiry_date, next_due_date,
    status, days_overdue,
    is_inferred, inference_reason, last_known_inspection, evidence_found,
    source_document, data_quality
)
VALUES (
    'd39f0647-4340-4ac5-98df-e714f036f2fd',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    (SELECT id FROM compliance_asset_types WHERE asset_type_code = 'UNKNOWN' LIMIT 1),
    NULL,
    NULL,
    NULL,
    'unknown',
    NULL,
    FALSE,
    '',
    NULL,
    FALSE,
    '',
    'medium'
);

-- lift_safety
INSERT INTO compliance_assets (
    id, building_id,
    asset_type_id, -- TODO: Replace with actual UUID from compliance_asset_types WHERE asset_type_code = 'UNKNOWN'
    inspection_date, expiry_date, next_due_date,
    status, days_overdue,
    is_inferred, inference_reason, last_known_inspection, evidence_found,
    source_document, data_quality
)
VALUES (
    'ebf210ae-6590-4aaa-a005-4a6a94728998',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    (SELECT id FROM compliance_asset_types WHERE asset_type_code = 'UNKNOWN' LIMIT 1),
    NULL,
    NULL,
    NULL,
    'unknown',
    NULL,
    FALSE,
    '',
    NULL,
    FALSE,
    '',
    'medium'
);

-- lift_safety
INSERT INTO compliance_assets (
    id, building_id,
    asset_type_id, -- TODO: Replace with actual UUID from compliance_asset_types WHERE asset_type_code = 'UNKNOWN'
    inspection_date, expiry_date, next_due_date,
    status, days_overdue,
    is_inferred, inference_reason, last_known_inspection, evidence_found,
    source_document, data_quality
)
VALUES (
    '1002c7e5-114a-4a5e-8d08-b36d8561a023',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    (SELECT id FROM compliance_asset_types WHERE asset_type_code = 'UNKNOWN' LIMIT 1),
    NULL,
    NULL,
    NULL,
    'unknown',
    NULL,
    FALSE,
    '',
    NULL,
    FALSE,
    '',
    'medium'
);

-- lift_safety
INSERT INTO compliance_assets (
    id, building_id,
    asset_type_id, -- TODO: Replace with actual UUID from compliance_asset_types WHERE asset_type_code = 'UNKNOWN'
    inspection_date, expiry_date, next_due_date,
    status, days_overdue,
    is_inferred, inference_reason, last_known_inspection, evidence_found,
    source_document, data_quality
)
VALUES (
    '2d799d59-7803-4415-9fc1-a59a87b721ef',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    (SELECT id FROM compliance_asset_types WHERE asset_type_code = 'UNKNOWN' LIMIT 1),
    NULL,
    NULL,
    NULL,
    'unknown',
    NULL,
    FALSE,
    '',
    NULL,
    FALSE,
    '',
    'medium'
);

-- lift_safety
INSERT INTO compliance_assets (
    id, building_id,
    asset_type_id, -- TODO: Replace with actual UUID from compliance_asset_types WHERE asset_type_code = 'UNKNOWN'
    inspection_date, expiry_date, next_due_date,
    status, days_overdue,
    is_inferred, inference_reason, last_known_inspection, evidence_found,
    source_document, data_quality
)
VALUES (
    '3995a288-83f0-4f40-a225-5b15926ad688',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    (SELECT id FROM compliance_asset_types WHERE asset_type_code = 'UNKNOWN' LIMIT 1),
    NULL,
    NULL,
    NULL,
    'unknown',
    NULL,
    FALSE,
    '',
    NULL,
    FALSE,
    '',
    'medium'
);

-- lift_safety
INSERT INTO compliance_assets (
    id, building_id,
    asset_type_id, -- TODO: Replace with actual UUID from compliance_asset_types WHERE asset_type_code = 'UNKNOWN'
    inspection_date, expiry_date, next_due_date,
    status, days_overdue,
    is_inferred, inference_reason, last_known_inspection, evidence_found,
    source_document, data_quality
)
VALUES (
    '418868d6-eb9d-4fbf-aec8-56a7f3114b45',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    (SELECT id FROM compliance_asset_types WHERE asset_type_code = 'UNKNOWN' LIMIT 1),
    NULL,
    NULL,
    NULL,
    'unknown',
    NULL,
    FALSE,
    '',
    NULL,
    FALSE,
    '',
    'medium'
);

-- lift_safety
INSERT INTO compliance_assets (
    id, building_id,
    asset_type_id, -- TODO: Replace with actual UUID from compliance_asset_types WHERE asset_type_code = 'UNKNOWN'
    inspection_date, expiry_date, next_due_date,
    status, days_overdue,
    is_inferred, inference_reason, last_known_inspection, evidence_found,
    source_document, data_quality
)
VALUES (
    '2c3cb9cf-2561-4192-a880-d6b3da6fee1a',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    (SELECT id FROM compliance_asset_types WHERE asset_type_code = 'UNKNOWN' LIMIT 1),
    NULL,
    NULL,
    NULL,
    'unknown',
    NULL,
    FALSE,
    '',
    NULL,
    FALSE,
    '',
    'medium'
);

-- lift_safety
INSERT INTO compliance_assets (
    id, building_id,
    asset_type_id, -- TODO: Replace with actual UUID from compliance_asset_types WHERE asset_type_code = 'UNKNOWN'
    inspection_date, expiry_date, next_due_date,
    status, days_overdue,
    is_inferred, inference_reason, last_known_inspection, evidence_found,
    source_document, data_quality
)
VALUES (
    '9835fbbe-01a8-437d-957b-0e711d7503bf',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    (SELECT id FROM compliance_asset_types WHERE asset_type_code = 'UNKNOWN' LIMIT 1),
    NULL,
    NULL,
    NULL,
    'unknown',
    NULL,
    FALSE,
    '',
    NULL,
    FALSE,
    '',
    'medium'
);

-- fire_safety
INSERT INTO compliance_assets (
    id, building_id,
    asset_type_id, -- TODO: Replace with actual UUID from compliance_asset_types WHERE asset_type_code = 'UNKNOWN'
    inspection_date, expiry_date, next_due_date,
    status, days_overdue,
    is_inferred, inference_reason, last_known_inspection, evidence_found,
    source_document, data_quality
)
VALUES (
    '8dc5ac7d-d075-4925-94c3-536d37d57cfc',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    (SELECT id FROM compliance_asset_types WHERE asset_type_code = 'UNKNOWN' LIMIT 1),
    NULL,
    NULL,
    NULL,
    'unknown',
    NULL,
    FALSE,
    '',
    NULL,
    FALSE,
    '',
    'medium'
);

-- fire_safety
INSERT INTO compliance_assets (
    id, building_id,
    asset_type_id, -- TODO: Replace with actual UUID from compliance_asset_types WHERE asset_type_code = 'UNKNOWN'
    inspection_date, expiry_date, next_due_date,
    status, days_overdue,
    is_inferred, inference_reason, last_known_inspection, evidence_found,
    source_document, data_quality
)
VALUES (
    'b7987fd9-086e-4eb2-8163-e5ad623b8bbf',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    (SELECT id FROM compliance_asset_types WHERE asset_type_code = 'UNKNOWN' LIMIT 1),
    NULL,
    NULL,
    '2024-01-01',
    'unknown',
    NULL,
    FALSE,
    '',
    NULL,
    FALSE,
    '',
    'medium'
);

-- fire_safety
INSERT INTO compliance_assets (
    id, building_id,
    asset_type_id, -- TODO: Replace with actual UUID from compliance_asset_types WHERE asset_type_code = 'UNKNOWN'
    inspection_date, expiry_date, next_due_date,
    status, days_overdue,
    is_inferred, inference_reason, last_known_inspection, evidence_found,
    source_document, data_quality
)
VALUES (
    '938d7df8-379d-496b-baa0-2e214dc773f9',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    (SELECT id FROM compliance_asset_types WHERE asset_type_code = 'UNKNOWN' LIMIT 1),
    NULL,
    NULL,
    NULL,
    'unknown',
    NULL,
    FALSE,
    '',
    NULL,
    FALSE,
    '',
    'medium'
);

-- fire_safety
INSERT INTO compliance_assets (
    id, building_id,
    asset_type_id, -- TODO: Replace with actual UUID from compliance_asset_types WHERE asset_type_code = 'UNKNOWN'
    inspection_date, expiry_date, next_due_date,
    status, days_overdue,
    is_inferred, inference_reason, last_known_inspection, evidence_found,
    source_document, data_quality
)
VALUES (
    '42c77836-353b-49bc-bb1b-25d119f9c1cc',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    (SELECT id FROM compliance_asset_types WHERE asset_type_code = 'UNKNOWN' LIMIT 1),
    NULL,
    NULL,
    NULL,
    'unknown',
    NULL,
    FALSE,
    '',
    NULL,
    FALSE,
    '',
    'medium'
);

-- fire_safety
INSERT INTO compliance_assets (
    id, building_id,
    asset_type_id, -- TODO: Replace with actual UUID from compliance_asset_types WHERE asset_type_code = 'UNKNOWN'
    inspection_date, expiry_date, next_due_date,
    status, days_overdue,
    is_inferred, inference_reason, last_known_inspection, evidence_found,
    source_document, data_quality
)
VALUES (
    '1273445b-7d77-44f3-8b07-9848f3a6858c',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    (SELECT id FROM compliance_asset_types WHERE asset_type_code = 'UNKNOWN' LIMIT 1),
    NULL,
    NULL,
    NULL,
    'unknown',
    NULL,
    FALSE,
    '',
    NULL,
    FALSE,
    '',
    'medium'
);

-- general
INSERT INTO compliance_assets (
    id, building_id,
    asset_type_id, -- TODO: Replace with actual UUID from compliance_asset_types WHERE asset_type_code = 'UNKNOWN'
    inspection_date, expiry_date, next_due_date,
    status, days_overdue,
    is_inferred, inference_reason, last_known_inspection, evidence_found,
    source_document, data_quality
)
VALUES (
    '90cfa3fe-96ba-40c8-96b2-e2602d8e17b4',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    (SELECT id FROM compliance_asset_types WHERE asset_type_code = 'UNKNOWN' LIMIT 1),
    NULL,
    NULL,
    NULL,
    'unknown',
    NULL,
    FALSE,
    '',
    NULL,
    FALSE,
    '',
    'medium'
);

-- general
INSERT INTO compliance_assets (
    id, building_id,
    asset_type_id, -- TODO: Replace with actual UUID from compliance_asset_types WHERE asset_type_code = 'UNKNOWN'
    inspection_date, expiry_date, next_due_date,
    status, days_overdue,
    is_inferred, inference_reason, last_known_inspection, evidence_found,
    source_document, data_quality
)
VALUES (
    '2c973635-3baf-4e7b-a370-5eb652b86d19',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    (SELECT id FROM compliance_asset_types WHERE asset_type_code = 'UNKNOWN' LIMIT 1),
    NULL,
    NULL,
    NULL,
    'unknown',
    NULL,
    FALSE,
    '',
    NULL,
    FALSE,
    '',
    'medium'
);

-- general
INSERT INTO compliance_assets (
    id, building_id,
    asset_type_id, -- TODO: Replace with actual UUID from compliance_asset_types WHERE asset_type_code = 'UNKNOWN'
    inspection_date, expiry_date, next_due_date,
    status, days_overdue,
    is_inferred, inference_reason, last_known_inspection, evidence_found,
    source_document, data_quality
)
VALUES (
    'beef8ad1-6301-42a3-8e2c-71b368c158f7',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    (SELECT id FROM compliance_asset_types WHERE asset_type_code = 'UNKNOWN' LIMIT 1),
    NULL,
    NULL,
    NULL,
    'unknown',
    NULL,
    FALSE,
    '',
    NULL,
    FALSE,
    '',
    'medium'
);

-- general
INSERT INTO compliance_assets (
    id, building_id,
    asset_type_id, -- TODO: Replace with actual UUID from compliance_asset_types WHERE asset_type_code = 'UNKNOWN'
    inspection_date, expiry_date, next_due_date,
    status, days_overdue,
    is_inferred, inference_reason, last_known_inspection, evidence_found,
    source_document, data_quality
)
VALUES (
    '78dc1f70-22d1-499d-a23a-b643f35f7a65',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    (SELECT id FROM compliance_asset_types WHERE asset_type_code = 'UNKNOWN' LIMIT 1),
    NULL,
    NULL,
    NULL,
    'unknown',
    NULL,
    FALSE,
    '',
    NULL,
    FALSE,
    '',
    'medium'
);

-- general
INSERT INTO compliance_assets (
    id, building_id,
    asset_type_id, -- TODO: Replace with actual UUID from compliance_asset_types WHERE asset_type_code = 'UNKNOWN'
    inspection_date, expiry_date, next_due_date,
    status, days_overdue,
    is_inferred, inference_reason, last_known_inspection, evidence_found,
    source_document, data_quality
)
VALUES (
    'b152915e-5168-4122-9634-908d5c6f22a7',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    (SELECT id FROM compliance_asset_types WHERE asset_type_code = 'UNKNOWN' LIMIT 1),
    NULL,
    NULL,
    NULL,
    'unknown',
    NULL,
    FALSE,
    '',
    NULL,
    FALSE,
    '',
    'medium'
);

-- general
INSERT INTO compliance_assets (
    id, building_id,
    asset_type_id, -- TODO: Replace with actual UUID from compliance_asset_types WHERE asset_type_code = 'UNKNOWN'
    inspection_date, expiry_date, next_due_date,
    status, days_overdue,
    is_inferred, inference_reason, last_known_inspection, evidence_found,
    source_document, data_quality
)
VALUES (
    '051fbba9-6617-4bb2-a104-bf5e1cb48fdf',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    (SELECT id FROM compliance_asset_types WHERE asset_type_code = 'UNKNOWN' LIMIT 1),
    NULL,
    NULL,
    NULL,
    'unknown',
    NULL,
    FALSE,
    '',
    NULL,
    FALSE,
    '',
    'medium'
);

-- general
INSERT INTO compliance_assets (
    id, building_id,
    asset_type_id, -- TODO: Replace with actual UUID from compliance_asset_types WHERE asset_type_code = 'UNKNOWN'
    inspection_date, expiry_date, next_due_date,
    status, days_overdue,
    is_inferred, inference_reason, last_known_inspection, evidence_found,
    source_document, data_quality
)
VALUES (
    'fed640c2-d818-454a-aead-7b83c29d1274',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    (SELECT id FROM compliance_asset_types WHERE asset_type_code = 'UNKNOWN' LIMIT 1),
    NULL,
    NULL,
    '2026-08-13',
    'unknown',
    NULL,
    FALSE,
    '',
    NULL,
    FALSE,
    '',
    'medium'
);

-- fire_safety
INSERT INTO compliance_assets (
    id, building_id,
    asset_type_id, -- TODO: Replace with actual UUID from compliance_asset_types WHERE asset_type_code = 'UNKNOWN'
    inspection_date, expiry_date, next_due_date,
    status, days_overdue,
    is_inferred, inference_reason, last_known_inspection, evidence_found,
    source_document, data_quality
)
VALUES (
    'd5c83cf4-39d5-4d14-abed-3ed3266f3f00',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    (SELECT id FROM compliance_asset_types WHERE asset_type_code = 'UNKNOWN' LIMIT 1),
    NULL,
    NULL,
    NULL,
    'unknown',
    NULL,
    FALSE,
    '',
    NULL,
    FALSE,
    '',
    'medium'
);


-- ============================================================================
-- Insurance Policies (Supabase: insurance_policies table)
-- ============================================================================

INSERT INTO insurance_policies (
    id, building_id, policy_type, insurer,
    renewal_date, annual_premium, policy_number
)
VALUES (
    'ff868f39-e166-4a6f-b708-125c4d292069',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'General',
    'Allianz',
    NULL,
    NULL,
    'LX13181358'
);

INSERT INTO insurance_policies (
    id, building_id, policy_type, insurer,
    renewal_date, annual_premium, policy_number
)
VALUES (
    'd764c074-eb43-4722-9c75-5132049e6ea8',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'General',
    'Zurich',
    NULL,
    NULL,
    'Schedule'
);

INSERT INTO insurance_policies (
    id, building_id, policy_type, insurer,
    renewal_date, annual_premium, policy_number
)
VALUES (
    '1a137642-e110-4df8-9d90-b02aafe822a6',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'General',
    '',
    NULL,
    NULL,
    'erence'
);

INSERT INTO insurance_policies (
    id, building_id, policy_type, insurer,
    renewal_date, annual_premium, policy_number
)
VALUES (
    '26fc4c71-76e9-41d9-b776-b9e212815402',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'General',
    '',
    NULL,
    NULL,
    'Fatrafol'
);

INSERT INTO insurance_policies (
    id, building_id, policy_type, insurer,
    renewal_date, annual_premium, policy_number
)
VALUES (
    'bbef8f8b-c846-4c23-abf0-e6be24f675fc',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'General',
    'Zurich',
    NULL,
    NULL,
    'urbishment'
);

INSERT INTO insurance_policies (
    id, building_id, policy_type, insurer,
    renewal_date, annual_premium, policy_number
)
VALUES (
    'ad36218b-8649-4516-81f2-1eee84e10ce5',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'General',
    '',
    NULL,
    NULL,
    ''
);

INSERT INTO insurance_policies (
    id, building_id, policy_type, insurer,
    renewal_date, annual_premium, policy_number
)
VALUES (
    '50a45920-f725-46b1-a555-dc3cce69ea0f',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'General',
    '',
    NULL,
    NULL,
    'Fatrafol'
);

INSERT INTO insurance_policies (
    id, building_id, policy_type, insurer,
    renewal_date, annual_premium, policy_number
)
VALUES (
    '969cce6a-c889-462e-acd7-b3f27757af95',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'General',
    'Zurich',
    NULL,
    NULL,
    'urbishment'
);

INSERT INTO insurance_policies (
    id, building_id, policy_type, insurer,
    renewal_date, annual_premium, policy_number
)
VALUES (
    'db8f5201-e50b-4947-931e-2402b19f1506',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'General',
    '',
    NULL,
    NULL,
    ''
);

INSERT INTO insurance_policies (
    id, building_id, policy_type, insurer,
    renewal_date, annual_premium, policy_number
)
VALUES (
    '8e08c074-24a6-4333-a9f7-e8601db7b6ee',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'General',
    'Zurich',
    NULL,
    NULL,
    'Schedule'
);

INSERT INTO insurance_policies (
    id, building_id, policy_type, insurer,
    renewal_date, annual_premium, policy_number
)
VALUES (
    '398eec2a-e31a-4b2b-b57b-4cf564778724',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'General',
    '',
    NULL,
    NULL,
    ''
);

INSERT INTO insurance_policies (
    id, building_id, policy_type, insurer,
    renewal_date, annual_premium, policy_number
)
VALUES (
    'b902fe61-eb7c-4db4-9152-09c97c6bbcaa',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'General',
    'Zurich',
    NULL,
    NULL,
    'Schedule'
);

INSERT INTO insurance_policies (
    id, building_id, policy_type, insurer,
    renewal_date, annual_premium, policy_number
)
VALUES (
    '9b0dbbab-5f74-490c-84e6-6e8756082714',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'General',
    '',
    NULL,
    NULL,
    ''
);

INSERT INTO insurance_policies (
    id, building_id, policy_type, insurer,
    renewal_date, annual_premium, policy_number
)
VALUES (
    'd55f78dc-61f4-4055-8017-dc87b51a0db8',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'General',
    '',
    NULL,
    NULL,
    ''
);

INSERT INTO insurance_policies (
    id, building_id, policy_type, insurer,
    renewal_date, annual_premium, policy_number
)
VALUES (
    'f1615a32-a71e-4e18-95f9-f7b0cbb0de6a',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'General',
    '',
    NULL,
    NULL,
    ''
);

INSERT INTO insurance_policies (
    id, building_id, policy_type, insurer,
    renewal_date, annual_premium, policy_number
)
VALUES (
    '69b1f088-0699-4910-ade6-a8747b3dbcbb',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'General',
    'Zurich',
    NULL,
    NULL,
    'Schedule'
);

INSERT INTO insurance_policies (
    id, building_id, policy_type, insurer,
    renewal_date, annual_premium, policy_number
)
VALUES (
    'a0748b18-c361-44cc-818c-e9ef7172f584',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'General',
    'Zurich',
    NULL,
    NULL,
    'schedule'
);

INSERT INTO insurance_policies (
    id, building_id, policy_type, insurer,
    renewal_date, annual_premium, policy_number
)
VALUES (
    'ffbc7f6e-242a-4ea2-a863-4844ad3f484a',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'General',
    'Zurich',
    NULL,
    NULL,
    'Schedule'
);

INSERT INTO insurance_policies (
    id, building_id, policy_type, insurer,
    renewal_date, annual_premium, policy_number
)
VALUES (
    '79860f37-7d74-4602-9cd3-a504c5264406',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'General',
    'Zurich',
    NULL,
    NULL,
    'Schedule'
);

INSERT INTO insurance_policies (
    id, building_id, policy_type, insurer,
    renewal_date, annual_premium, policy_number
)
VALUES (
    '024f1aa6-15d0-4c11-8059-35ce815cf29d',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'General',
    '',
    NULL,
    NULL,
    ''
);

INSERT INTO insurance_policies (
    id, building_id, policy_type, insurer,
    renewal_date, annual_premium, policy_number
)
VALUES (
    'f3ee3661-38ab-4b19-851d-82971d4883fd',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'General',
    '',
    NULL,
    NULL,
    ''
);

INSERT INTO insurance_policies (
    id, building_id, policy_type, insurer,
    renewal_date, annual_premium, policy_number
)
VALUES (
    '8d50ca27-e254-4a6f-8a62-30821487cb64',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'General',
    '',
    NULL,
    NULL,
    ''
);

INSERT INTO insurance_policies (
    id, building_id, policy_type, insurer,
    renewal_date, annual_premium, policy_number
)
VALUES (
    '3b2f4d05-6dd1-40b2-ba79-803f62e23363',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'General',
    '',
    NULL,
    NULL,
    'relating'
);

INSERT INTO insurance_policies (
    id, building_id, policy_type, insurer,
    renewal_date, annual_premium, policy_number
)
VALUES (
    '4c97b892-a557-49be-9979-bfd145dc712d',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'General',
    '',
    NULL,
    NULL,
    'erence'
);

INSERT INTO insurance_policies (
    id, building_id, policy_type, insurer,
    renewal_date, annual_premium, policy_number
)
VALUES (
    'be17ff62-fa73-4260-9de4-4ef61c68fd61',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'General',
    '',
    NULL,
    NULL,
    'erence'
);

INSERT INTO insurance_policies (
    id, building_id, policy_type, insurer,
    renewal_date, annual_premium, policy_number
)
VALUES (
    '438848e0-7f6d-4eb6-b05c-e5930d48ad67',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'General',
    '',
    NULL,
    NULL,
    'erence'
);

INSERT INTO insurance_policies (
    id, building_id, policy_type, insurer,
    renewal_date, annual_premium, policy_number
)
VALUES (
    '1683fea4-7905-463d-9751-fd6f138641ca',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'General',
    '',
    NULL,
    NULL,
    'erence'
);

INSERT INTO insurance_policies (
    id, building_id, policy_type, insurer,
    renewal_date, annual_premium, policy_number
)
VALUES (
    '02488b1e-c07f-454c-bfe8-de4787465216',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'General',
    '',
    NULL,
    NULL,
    'erence'
);

INSERT INTO insurance_policies (
    id, building_id, policy_type, insurer,
    renewal_date, annual_premium, policy_number
)
VALUES (
    '29e80610-bcd6-4255-9c23-5dc119ece302',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'General',
    '',
    NULL,
    NULL,
    'erence'
);

INSERT INTO insurance_policies (
    id, building_id, policy_type, insurer,
    renewal_date, annual_premium, policy_number
)
VALUES (
    'f1c20bf8-f077-4d56-a4fd-6f0714153017',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'General',
    '',
    NULL,
    NULL,
    'erence'
);

INSERT INTO insurance_policies (
    id, building_id, policy_type, insurer,
    renewal_date, annual_premium, policy_number
)
VALUES (
    '3e4274c4-ed47-41ac-a734-cf80e7836cdd',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'General',
    '',
    NULL,
    NULL,
    'erence'
);

INSERT INTO insurance_policies (
    id, building_id, policy_type, insurer,
    renewal_date, annual_premium, policy_number
)
VALUES (
    'be28ce16-1bb6-4d2c-b369-ca71ad92a085',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'General',
    '',
    NULL,
    NULL,
    'wording'
);

INSERT INTO insurance_policies (
    id, building_id, policy_type, insurer,
    renewal_date, annual_premium, policy_number
)
VALUES (
    '80abdecb-8ade-415b-9431-ec1f6cfda8ca',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'General',
    '',
    NULL,
    NULL,
    ''
);

INSERT INTO insurance_policies (
    id, building_id, policy_type, insurer,
    renewal_date, annual_premium, policy_number
)
VALUES (
    '8b88352b-3c8d-4d9b-a684-841012191955',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'General',
    '',
    NULL,
    NULL,
    ''
);

INSERT INTO insurance_policies (
    id, building_id, policy_type, insurer,
    renewal_date, annual_premium, policy_number
)
VALUES (
    '0364472c-929b-4260-a608-99a3cf4527c3',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'General',
    '',
    NULL,
    NULL,
    ''
);

INSERT INTO insurance_policies (
    id, building_id, policy_type, insurer,
    renewal_date, annual_premium, policy_number
)
VALUES (
    '1c8ccf30-733a-4518-89fd-1cb4525902af',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'General',
    '',
    NULL,
    NULL,
    ''
);

INSERT INTO insurance_policies (
    id, building_id, policy_type, insurer,
    renewal_date, annual_premium, policy_number
)
VALUES (
    '2af364b8-5c7d-4e8e-a133-396704f56333',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'General',
    '',
    NULL,
    NULL,
    ''
);

INSERT INTO insurance_policies (
    id, building_id, policy_type, insurer,
    renewal_date, annual_premium, policy_number
)
VALUES (
    'bf9e1ae7-c4aa-4ac9-b95e-024402e8bbed',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'General',
    'Zurich',
    NULL,
    NULL,
    ''
);

INSERT INTO insurance_policies (
    id, building_id, policy_type, insurer,
    renewal_date, annual_premium, policy_number
)
VALUES (
    '51e1c3ac-e620-40df-8b01-b5c08fe505e8',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'General',
    'AXA',
    NULL,
    NULL,
    'number'
);

INSERT INTO insurance_policies (
    id, building_id, policy_type, insurer,
    renewal_date, annual_premium, policy_number
)
VALUES (
    '8d41c6c3-1310-43c6-a38f-7e6db0ba2bc1',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'General',
    'AXA',
    NULL,
    NULL,
    'wording'
);

INSERT INTO insurance_policies (
    id, building_id, policy_type, insurer,
    renewal_date, annual_premium, policy_number
)
VALUES (
    'd1985a49-e80b-4ced-b7e9-1a37421cfd77',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'General',
    'AXA',
    NULL,
    NULL,
    'schedule'
);

INSERT INTO insurance_policies (
    id, building_id, policy_type, insurer,
    renewal_date, annual_premium, policy_number
)
VALUES (
    '0a829c0d-b33f-4844-b2d4-aae5e4191633',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'General',
    'AXA',
    NULL,
    NULL,
    'number'
);

INSERT INTO insurance_policies (
    id, building_id, policy_type, insurer,
    renewal_date, annual_premium, policy_number
)
VALUES (
    '478f715c-e910-442f-ad48-2309fb064ee2',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'General',
    '',
    NULL,
    NULL,
    ''
);

INSERT INTO insurance_policies (
    id, building_id, policy_type, insurer,
    renewal_date, annual_premium, policy_number
)
VALUES (
    'cb0bdcf7-7ed2-479d-b51a-249427b805be',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'General',
    'AXA',
    NULL,
    NULL,
    'conditions'
);

INSERT INTO insurance_policies (
    id, building_id, policy_type, insurer,
    renewal_date, annual_premium, policy_number
)
VALUES (
    'df4c8854-b1ed-4844-a01f-017b2181c620',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'General',
    'AXA',
    NULL,
    NULL,
    'Invoice'
);

INSERT INTO insurance_policies (
    id, building_id, policy_type, insurer,
    renewal_date, annual_premium, policy_number
)
VALUES (
    '33b2745a-b66f-4f0a-b4a4-2a967dc31ff0',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'General',
    'AXA',
    NULL,
    NULL,
    'conditions'
);

INSERT INTO insurance_policies (
    id, building_id, policy_type, insurer,
    renewal_date, annual_premium, policy_number
)
VALUES (
    '9f5105e4-8f7a-4786-94d2-76c15e6ab674',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'General',
    '',
    NULL,
    NULL,
    ''
);

INSERT INTO insurance_policies (
    id, building_id, policy_type, insurer,
    renewal_date, annual_premium, policy_number
)
VALUES (
    'a532dac1-1ef0-47e8-bba5-affce5fd99dd',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'General',
    'AXA',
    NULL,
    NULL,
    'schedule'
);

INSERT INTO insurance_policies (
    id, building_id, policy_type, insurer,
    renewal_date, annual_premium, policy_number
)
VALUES (
    'c1055676-a741-4499-8fbf-43114e67125f',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'General',
    'AXA',
    NULL,
    NULL,
    'Invoice'
);

INSERT INTO insurance_policies (
    id, building_id, policy_type, insurer,
    renewal_date, annual_premium, policy_number
)
VALUES (
    'c1da39b9-190b-411f-b033-5dbf258afe3b',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'General',
    'AXA',
    NULL,
    NULL,
    'number'
);

INSERT INTO insurance_policies (
    id, building_id, policy_type, insurer,
    renewal_date, annual_premium, policy_number
)
VALUES (
    'c9eb8899-eaf2-4b2a-ab66-145ffb657bb6',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'General',
    'AXA',
    NULL,
    NULL,
    'number'
);

INSERT INTO insurance_policies (
    id, building_id, policy_type, insurer,
    renewal_date, annual_premium, policy_number
)
VALUES (
    'fbf52a4a-a68a-4804-9dc7-ba34a03270c1',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'General',
    'AXA',
    NULL,
    NULL,
    'Number'
);

INSERT INTO insurance_policies (
    id, building_id, policy_type, insurer,
    renewal_date, annual_premium, policy_number
)
VALUES (
    'ffb6200f-544c-455c-8ce7-2bb1fcf3ddad',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'General',
    'AXA',
    NULL,
    NULL,
    'wording'
);

INSERT INTO insurance_policies (
    id, building_id, policy_type, insurer,
    renewal_date, annual_premium, policy_number
)
VALUES (
    'd1453699-4ead-4c0c-adfb-56f522cc0890',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'General',
    'AXA',
    NULL,
    NULL,
    'schedule'
);

INSERT INTO insurance_policies (
    id, building_id, policy_type, insurer,
    renewal_date, annual_premium, policy_number
)
VALUES (
    '9456b6e6-5307-4f93-b2a0-9f5335b9594f',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'General',
    'AXA',
    NULL,
    NULL,
    'number'
);

INSERT INTO insurance_policies (
    id, building_id, policy_type, insurer,
    renewal_date, annual_premium, policy_number
)
VALUES (
    '03c0596f-9c5b-4fa5-8c78-44e0ee37fc8f',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'General',
    '',
    NULL,
    NULL,
    ''
);

INSERT INTO insurance_policies (
    id, building_id, policy_type, insurer,
    renewal_date, annual_premium, policy_number
)
VALUES (
    'af37988d-0d7e-4bb6-90e5-1fdfe7fcebb5',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'General',
    'AXA',
    NULL,
    NULL,
    'conditions'
);

INSERT INTO insurance_policies (
    id, building_id, policy_type, insurer,
    renewal_date, annual_premium, policy_number
)
VALUES (
    '0615cc20-f3bc-4250-91a2-4fa9881e0c4d',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'General',
    'AXA',
    NULL,
    NULL,
    'Invoice'
);

INSERT INTO insurance_policies (
    id, building_id, policy_type, insurer,
    renewal_date, annual_premium, policy_number
)
VALUES (
    'ac0254c0-ac35-44a1-b40a-eeaba020609e',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'General',
    'AXA',
    NULL,
    NULL,
    'number'
);

INSERT INTO insurance_policies (
    id, building_id, policy_type, insurer,
    renewal_date, annual_premium, policy_number
)
VALUES (
    '76581ddb-ca55-4ba0-a855-c2f4ccd7e852',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'General',
    'AXA',
    NULL,
    NULL,
    'number'
);

INSERT INTO insurance_policies (
    id, building_id, policy_type, insurer,
    renewal_date, annual_premium, policy_number
)
VALUES (
    '98d9ef95-cf83-4573-8165-f999432433fa',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'General',
    'Zurich',
    NULL,
    NULL,
    'schedule'
);

INSERT INTO insurance_policies (
    id, building_id, policy_type, insurer,
    renewal_date, annual_premium, policy_number
)
VALUES (
    '196459ee-d0bf-4753-a703-d67e0214f20d',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'General',
    's
We offer products from a limited number of insurers in respect of Engineering Insurance',
    NULL,
    NULL,
    ''
);

INSERT INTO insurance_policies (
    id, building_id, policy_type, insurer,
    renewal_date, annual_premium, policy_number
)
VALUES (
    'd34ad2a4-cf3e-42c9-b5c9-28be8f7204a1',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'General',
    'Zurich',
    NULL,
    NULL,
    'Schedule'
);

INSERT INTO insurance_policies (
    id, building_id, policy_type, insurer,
    renewal_date, annual_premium, policy_number
)
VALUES (
    '31cb4f19-c3cb-4fc1-9785-bfd17f4cd9b0',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'General',
    '',
    NULL,
    NULL,
    'schedule'
);

INSERT INTO insurance_policies (
    id, building_id, policy_type, insurer,
    renewal_date, annual_premium, policy_number
)
VALUES (
    'b1d79931-6921-4c29-a6f5-48a71f0153ed',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'General',
    'Zurich',
    NULL,
    NULL,
    'schedule'
);

INSERT INTO insurance_policies (
    id, building_id, policy_type, insurer,
    renewal_date, annual_premium, policy_number
)
VALUES (
    '8312ee78-a99d-49ab-b279-3032d9002b3a',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'General',
    'providing insurance',
    NULL,
    NULL,
    'WORDING'
);

INSERT INTO insurance_policies (
    id, building_id, policy_type, insurer,
    renewal_date, annual_premium, policy_number
)
VALUES (
    '3de295b8-4a7d-4911-b4f0-039de26a0882',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'General',
    'Zurich',
    NULL,
    NULL,
    'schedule'
);

INSERT INTO insurance_policies (
    id, building_id, policy_type, insurer,
    renewal_date, annual_premium, policy_number
)
VALUES (
    'bdc3d104-c5d7-4907-a084-d8845e2e9702',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'General',
    'Zurich',
    NULL,
    NULL,
    'schedule'
);

INSERT INTO insurance_policies (
    id, building_id, policy_type, insurer,
    renewal_date, annual_premium, policy_number
)
VALUES (
    '2042ea6e-9b7a-481d-b2fa-abe53d44ace8',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'General',
    'Zurich',
    NULL,
    NULL,
    'Number'
);

INSERT INTO insurance_policies (
    id, building_id, policy_type, insurer,
    renewal_date, annual_premium, policy_number
)
VALUES (
    '928893a1-b438-464f-841f-bd4a70cfbe75',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'General',
    'Zurich',
    NULL,
    NULL,
    'Schedule'
);

INSERT INTO insurance_policies (
    id, building_id, policy_type, insurer,
    renewal_date, annual_premium, policy_number
)
VALUES (
    'e6e2df8c-c7f8-4a55-931a-cdb3140f11e1',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'General',
    'Zurich',
    NULL,
    NULL,
    'Schedule'
);


-- ============================================================================
-- Contractors (6 contractors)
-- ============================================================================

INSERT INTO contractors (
    id, company_name, services_offered, is_active, notes
)
VALUES (
    '79014124-5cd0-46bd-85fb-fe4dcc2851e2',
    'Unknown',
    ARRAY['General Maintenance'],
    TRUE,
    'Folder: , Documents: 0'
);

INSERT INTO contractors (
    id, company_name, services_offered, is_active, notes
)
VALUES (
    '227388fe-1679-4513-900f-171071abe415',
    'Unknown',
    ARRAY['General Maintenance'],
    TRUE,
    'Folder: , Documents: 0'
);

INSERT INTO contractors (
    id, company_name, services_offered, is_active, notes
)
VALUES (
    'bc4ff710-5464-43d7-8626-cbcf9d6232d4',
    'Unknown',
    ARRAY['General Maintenance'],
    TRUE,
    'Folder: , Documents: 0'
);

INSERT INTO contractors (
    id, company_name, services_offered, is_active, notes
)
VALUES (
    '00504340-06f9-4829-b507-902eae3d5c5b',
    'Unknown',
    ARRAY['General Maintenance'],
    TRUE,
    'Folder: , Documents: 0'
);

INSERT INTO contractors (
    id, company_name, services_offered, is_active, notes
)
VALUES (
    '5555e8b1-6b24-4ce2-8a3f-071449106109',
    'Unknown',
    ARRAY['General Maintenance'],
    TRUE,
    'Folder: , Documents: 0'
);

INSERT INTO contractors (
    id, company_name, services_offered, is_active, notes
)
VALUES (
    'd058c1f2-0ddd-4c3e-9456-55658f905127',
    'Unknown',
    ARRAY['General Maintenance'],
    TRUE,
    'Folder: , Documents: 0'
);


-- ============================================================================
-- Extraction Run Metadata
-- ============================================================================
INSERT INTO extraction_runs (
    id, building_id, extraction_date, extraction_version,
    units_extracted, leaseholders_extracted,
    compliance_assets_extracted, contracts_extracted,
    data_quality, confidence_score,
    new_types_discovered, low_confidence_detections,
    source_folder, extraction_status
)
VALUES (
    '2069e3b7-ecde-4ae3-9976-65de0d11d3df',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    NOW(),
    '6.0',
    83,
    82,
    81,
    0,
    'production',
    0.99,
    0,
    0,
    '',
    'Success'
);

COMMIT;

-- ============================================================
-- POST-PROCESSING ENRICHMENT
-- Auto-generated corrections and enhancements
-- ============================================================

-- ============================================================
-- Building Knowledge Enhancement
-- ============================================================
-- Note: Uses existing building_keys_access table with enhanced columns
-- This DDL ensures the table has the required columns for building knowledge

-- Add missing columns if they don't exist
DO $$
BEGIN
    -- Add category column if missing
    IF NOT EXISTS (
        SELECT 1 FROM information_schema.columns
        WHERE table_name = 'building_keys_access' AND column_name = 'category'
    ) THEN
        ALTER TABLE building_keys_access ADD COLUMN category text;
    END IF;

    -- Add label column if missing
    IF NOT EXISTS (
        SELECT 1 FROM information_schema.columns
        WHERE table_name = 'building_keys_access' AND column_name = 'label'
    ) THEN
        ALTER TABLE building_keys_access ADD COLUMN label text;
    END IF;

    -- Add visibility column if missing
    IF NOT EXISTS (
        SELECT 1 FROM information_schema.columns
        WHERE table_name = 'building_keys_access' AND column_name = 'visibility'
    ) THEN
        ALTER TABLE building_keys_access ADD COLUMN visibility text DEFAULT 'team';
    END IF;
END $$;

-- Create indexes if missing
CREATE INDEX IF NOT EXISTS idx_building_keys_access_category
    ON building_keys_access(building_id, category);

CREATE INDEX IF NOT EXISTS idx_building_keys_access_search
    ON building_keys_access USING gin(
        to_tsvector('english',
            COALESCE(label, '') || ' ' ||
            COALESCE(description, '') || ' ' ||
            COALESCE(location, '')
        )
    );


-- Update building address
UPDATE buildings
SET address = '01 PIMLICO PLACE'
WHERE id = 'cd83b608-ee5a-4bcc-b02d-0bc65a477829';

-- Building knowledge: Parking
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '673dd0ed-614e-4e66-9fae-3795f8287e3c',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'parking',
    'general',
    'Parking',
    NULL,
    NULL,
    'fees and the',
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Parking
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    'd6c7c622-326b-49e9-b1e8-9df2e6d630fa',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'parking',
    'general',
    'Parking',
    NULL,
    NULL,
    'to allow Liftworks Ltd engineers',
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Parking
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '15a8157e-1124-4e0c-bff3-4b377769ae71',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'parking',
    'general',
    'Parking',
    NULL,
    NULL,
    'spaces within Pimlico Place, number 1 (level 1) and',
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Parking
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '1268a498-64e1-437e-9149-9cae398e4871',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'parking',
    'general',
    'Parking',
    NULL,
    NULL,
    'spaces and the circumstances of their grant,',
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Parking
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '1dc7b62b-cf19-4f75-a785-a5b97b929cd2',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'parking',
    'general',
    'Parking',
    NULL,
    NULL,
    'Space 47 (level 1) 22.08.2017 NGL972412',
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Parking
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '665a901f-35b0-439e-992e-cdb8bf77a38e',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'parking',
    'general',
    'Parking',
    NULL,
    NULL,
    'Space 1 (level 1) 22.08.2017 NGL972412',
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Parking
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '82000dad-4983-4acd-81ab-ca47884c68ae',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'parking',
    'general',
    'Parking',
    NULL,
    NULL,
    'Space 47, 29 Gillingham Street, London',
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Parking
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '92acc16a-364b-499e-96f2-eae992bca80d',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'parking',
    'general',
    'Parking',
    NULL,
    NULL,
    'Space 1, 29 Gillingham Street, London',
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Parking
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    'dc0a7187-8128-4444-801a-f265f9acdc7f',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'parking',
    'general',
    'Parking',
    NULL,
    NULL,
    'Space 1 was £1 and the price, other',
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Parking
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '624a4755-714c-4a07-9652-fe03eca58637',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'parking',
    'general',
    'Parking',
    NULL,
    NULL,
    'Space 47 was £1.',
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Parking
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '9729a7ce-3456-49e0-b7cd-aa579fae7fe3',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'parking',
    'general',
    'Parking',
    NULL,
    NULL,
    'to be arranged for Excell vans for the period of works.',
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Parking
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '4a3a4d96-0993-4cb2-bd9c-2f45fea7b866',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'parking',
    'general',
    'Parking',
    NULL,
    NULL,
    'to be provided for the installation team for the period of works',
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Parking
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '6be02665-b793-460a-8d23-fce88bf3d612',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'parking',
    'general',
    'Parking',
    NULL,
    NULL,
    'bay suspensions 1 item. £ 7 ,765.36 1item. £10,511.55',
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Parking
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    'fb12a710-a832-442f-b5ee-03ab8e1447d4',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'parking',
    'general',
    'Parking',
    NULL,
    NULL,
    'bay suspensions 1item. £9,344.00',
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Fire Alarm
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '671b7a1b-743a-4e95-8c38-aed4dadc590e',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'fire_alarm_location',
    'safety',
    'Fire Alarm',
    NULL,
    'system within each flat although the extent of coverage is not specified. There is a communal',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Parking
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '9afc27dc-d9a1-4217-960b-870a1d737f66',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'parking',
    'general',
    'Parking',
    NULL,
    NULL,
    'bays may become apparent during the',
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Parking
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '3d55fa02-7ec4-4da4-ab87-c0596ebe9a55',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'parking',
    'general',
    'Parking',
    NULL,
    NULL,
    'bay(s):',
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Parking
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    'c2741100-00ec-453e-bb3c-4d4a7669c6a1',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'parking',
    'general',
    'Parking',
    NULL,
    NULL,
    'bays:',
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Parking
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    'e6f9a4a4-ed07-48dc-938b-17ce35fb2294',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'parking',
    'general',
    'Parking',
    NULL,
    NULL,
    'bays. Five of these bays',
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Parking
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    'd7a38aed-2a1f-44f1-a41c-bdcb3258cc4a',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'parking',
    'general',
    'Parking',
    NULL,
    NULL,
    '/ basement plant area.',
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Boiler
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '97d4384d-e71c-43aa-86ad-762b81b02f74',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'boiler_location',
    'utilities',
    'Boiler',
    NULL,
    'service £172.80 £0.00 £0.00',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Parking
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '1f4b04b2-de6e-4593-a8d4-6f7f380ab266',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'parking',
    'general',
    'Parking',
    NULL,
    NULL,
    'regulations or restrictions in Yes No',
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: CCTV
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '78890887-a085-4514-9451-f739203d1d96',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'cctv_location',
    'safety',
    'CCTV',
    NULL,
    '8 66 1 ,500 6 29',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: CCTV
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    'f09f3100-2d51-41b9-b59e-b3c0838d09d8',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'cctv_location',
    'safety',
    'CCTV',
    NULL,
    '£ 1,500.00 £ 629.00 £ 1,500.00 No increase from previous year- Provision allows for any repairs',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Alarm Panel
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    'abec8479-ac16-4ac2-8a06-126af3b4ddc1',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'alarm_panel_location',
    'safety',
    'Alarm Panel',
    NULL,
    'in the ground floor main entrance lobby',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Alarm Panel
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '8648c548-d45b-4dd8-a164-9db3e084321e',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'alarm_panel_location',
    'safety',
    'Alarm Panel',
    NULL,
    'for ease of reference.',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Alarm Panel
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    'b2814d2a-17c1-466a-a450-e5299d988d79',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'alarm_panel_location',
    'safety',
    'Alarm Panel',
    NULL,
    'for',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Fire Alarm
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    'f87710ef-98b9-4439-aaaf-55808e5fa30e',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'fire_alarm_location',
    'safety',
    'Fire Alarm',
    NULL,
    'panel; mains powered',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Fire Alarm
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    'cb22cbd2-998e-44eb-ac80-e18fcca9830b',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'fire_alarm_location',
    'safety',
    'Fire Alarm',
    NULL,
    'system within an apartment will raise an alarm within that apartment of fire origin only due to the “protect',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Fire Alarm
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    'f491805e-6439-482d-95e3-b81e2a3d576a',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'fire_alarm_location',
    'safety',
    'Fire Alarm',
    NULL,
    'panel in the ground floor main entrance lobby',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Fire Alarm
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '5baffa3e-f3f3-4ea8-860a-15475f93e28c',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'fire_alarm_location',
    'safety',
    'Fire Alarm',
    NULL,
    'activation X Not checked.',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Fire Alarm
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '20f1c6e6-0ee5-436d-8677-9b306e672fd2',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'fire_alarm_location',
    'safety',
    'Fire Alarm',
    NULL,
    'is audible / visible in all areas  No issues identified.',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Fire Alarm
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    'a7d75186-2fb8-4f0e-929a-d8b591ff039b',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'fire_alarm_location',
    'safety',
    'Fire Alarm',
    NULL,
    'in the commercial / retail units or car park. This also works in the reverse order.',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Fire Alarm
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    'f2c0db29-371d-489e-a69b-992796ac38c2',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'fire_alarm_location',
    'safety',
    'Fire Alarm',
    NULL,
    'frequently has the',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Fire Alarm
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '8cfedeab-481d-4eb8-aaf0-e2aa10aa7bbe',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'fire_alarm_location',
    'safety',
    'Fire Alarm',
    NULL,
    'cables through',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Fire Alarm
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '8af59f5f-f4e6-4085-b55b-b4175d7d14ba',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'fire_alarm_location',
    'safety',
    'Fire Alarm',
    NULL,
    'entrance - Reception. near the fire alarm panel. This system and locate on or adjacent to the fire',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Fire Alarm
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '3f5cbe21-c555-49de-8c60-4960c4fa65b5',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'fire_alarm_location',
    'safety',
    'Fire Alarm',
    NULL,
    'panel for ease of reference.',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Fire Alarm
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '3a54cae4-0f29-4da9-a65c-8159150aaebc',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'fire_alarm_location',
    'safety',
    'Fire Alarm',
    NULL,
    '2 1 L Train and utilise site based staff to carry out',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Fire Alarm
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '1df15dd6-5489-4d78-945c-bf3604f43eab',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'fire_alarm_location',
    'safety',
    'Fire Alarm',
    NULL,
    'bell tests. servicing / maintenance regular bell tests of the fire alarm system,',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Fire Alarm
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    'b3935cc2-5b1f-4845-bbb9-8c409966480f',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'fire_alarm_location',
    'safety',
    'Fire Alarm',
    NULL,
    'system, although these',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Fire Alarm
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    'c7315b32-ced8-490f-8b19-a59765069bf4',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'fire_alarm_location',
    'safety',
    'Fire Alarm',
    NULL,
    'call Smoke vent switches for    Automatic operation also 1 2 L Replace smoke ventilation call points with',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Fire Alarm
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '138e8292-b054-4052-bc76-55718bd9fd74',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'fire_alarm_location',
    'safety',
    'Fire Alarm',
    NULL,
    'call point near Flat 2 ',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Fire Alarm
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '6476bf47-e4bc-47ff-b7c1-58ae7dd736d7',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'fire_alarm_location',
    'safety',
    'Fire Alarm',
    NULL,
    'call point near Flat',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Fire Alarm
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '2dc004a6-3241-40ee-8563-de3efa1589fc',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'fire_alarm_location',
    'safety',
    'Fire Alarm',
    NULL,
    'frequently has the following',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Fire Alarm
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '78114eb1-6a98-4c3d-b6b4-a69854adfaf7',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'fire_alarm_location',
    'safety',
    'Fire Alarm',
    NULL,
    'panel for',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Fire Alarm
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    'e2a80e3b-bda4-400d-b74e-e948c02da41c',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'fire_alarm_location',
    'safety',
    'Fire Alarm',
    NULL,
    'system, ensuring any manual',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Fire Alarm
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '04edd999-878e-4f47-93b6-afb6d3ce5fed',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'fire_alarm_location',
    'safety',
    'Fire Alarm',
    NULL,
    'system, although these can be',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Fire Alarm
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    'fb1fbcf5-2891-4543-a825-8ecb53e3ab47',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'fire_alarm_location',
    'safety',
    'Fire Alarm',
    NULL,
    'call Replace smoke ventilation call points',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: CCTV
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    'a74f4d8b-9bbf-4361-8b68-a82b0e99dba4',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'cctv_location',
    'safety',
    'CCTV',
    NULL,
    'equipment.',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Sprinkler
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '80c75a35-ed6d-4ffa-8d33-39e81a09139b',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'sprinkler_location',
    'safety',
    'Sprinkler',
    NULL,
    'system covers a covered car park and partially escape corridors from the car park. The Estate',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Sprinkler
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '898abe0c-6eee-493e-a3c9-87714d83222c',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'sprinkler_location',
    'safety',
    'Sprinkler',
    NULL,
    'system as they have',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Sprinkler
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    'cc6688e8-8c35-4439-81cd-73f79ee0785e',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'sprinkler_location',
    'safety',
    'Sprinkler',
    NULL,
    'control valves identified and  No issues identified.',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Sprinkler
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '1a5dde4a-ebcc-4318-93ca-24dc2701d25a',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'sprinkler_location',
    'safety',
    'Sprinkler',
    NULL,
    'system appears in good condition?  No issues identified.',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Sprinkler
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    'a0b63472-dc63-46c5-92f9-bd49b8772fee',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'sprinkler_location',
    'safety',
    'Sprinkler',
    NULL,
    'system tested and maintained as N/A Responsibility of others.',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Sprinkler
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '083667d9-8887-48e6-88e8-21ae905d1e3b',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'sprinkler_location',
    'safety',
    'Sprinkler',
    NULL,
    'system relevant British Standard. Maintain up to date',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Sprinkler
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    'ab0ec1bc-9176-466c-9819-11a1c27edddf',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'sprinkler_location',
    'safety',
    'Sprinkler',
    NULL,
    'system',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Fire Assembly Point
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '75c1dfd9-3d2e-4c99-b47e-962be5861824',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'assembly_point',
    'safety',
    'Fire Assembly Point',
    NULL,
    NULL,
    'identified?  Assembly point identified.',
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Bin Store
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    'c72bb53a-42a3-4d14-b744-906cded6c598',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'bin_store',
    'general',
    'Bin Store',
    NULL,
    NULL,
    '- Internal courtyard / communal garden - Roof of Core A - External',
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Bin Store
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    'cf75a98b-9a8a-4025-852e-d689e60767ab',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'bin_store',
    'general',
    'Bin Store',
    NULL,
    NULL,
    'are located on the ground floor.',
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Bin Store
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '2ab3b7bd-07c4-4946-a97a-052212bb1247',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'bin_store',
    'general',
    'Bin Store',
    NULL,
    NULL,
    'are designed to operate the',
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Bin Store
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    'cd550a27-6943-40b6-a789-888d050c6bd3',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'bin_store',
    'general',
    'Bin Store',
    NULL,
    NULL,
    '27 M',
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Bin Store
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '111b3af3-ade1-4312-a3af-f9108ceecd53',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'bin_store',
    'general',
    'Bin Store',
    NULL,
    NULL,
    'Replace plastic cable ties with non-',
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Parking
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    'd8936149-11fb-4551-8f02-2fa64389f702',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'parking',
    'general',
    'Parking',
    NULL,
    NULL,
    'Security measures: 24 hour manned reception. CCTV. Security alarm. Intercom door entry. Fob',
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: CCTV
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '52f6556b-af20-4777-ad0c-5816ec220e59',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'cctv_location',
    'safety',
    'CCTV',
    NULL,
    '2 ,387 1 ,500 8 66',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Parking
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '540e64b6-9394-498b-a694-7548677f5152',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'parking',
    'general',
    'Parking',
    NULL,
    NULL,
    'via Gillingham Street.',
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Parking
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    'f3b46e64-a353-4326-90fd-5c60e2426602',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'parking',
    'general',
    'Parking',
    NULL,
    NULL,
    'bay area up the lift or staircase to the flat.',
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Parking
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    'f5a56898-b3b0-406d-ac87-974f337d1dd0',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'parking',
    'general',
    'Parking',
    NULL,
    NULL,
    'permits will need be applied for by',
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Parking
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    'f4527b5f-7e7b-4b13-aa66-4e2564a87b72',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'parking',
    'general',
    'Parking',
    NULL,
    NULL,
    'space for storage of',
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Parking
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '0564a870-a147-4eec-88dc-5fdaad08acd1',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'parking',
    'general',
    'Parking',
    NULL,
    NULL,
    'bay area and weekly from',
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Parking
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    'd3fece6f-5f65-4d9e-8c5b-a167dca0aa7d',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'parking',
    'general',
    'Parking',
    NULL,
    NULL,
    'bay away.',
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Parking
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '68212fc4-ce7a-4b63-8395-b48c8d8bf4eb',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'parking',
    'general',
    'Parking',
    NULL,
    NULL,
    'bay for vehicle parking of the',
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Gas Meter
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '03a04341-f698-4967-88f4-ca76d10ae0c5',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'gas_meter_location',
    'utilities',
    'Gas Meter',
    NULL,
    'provided to Local Authority & owner on',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Electric Meter
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '8e0bfc2f-59b4-4719-b6d0-92bbf5de7dad',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'electric_meter_location',
    'utilities',
    'Electric Meter',
    NULL,
    'electrician.',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Boiler
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    'db82e50e-22f5-43dd-9beb-e3c483f3b564',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'boiler_location',
    'utilities',
    'Boiler',
    NULL,
    'is existing. § Fuses, RCDs and switches within consumer unit and remote fused switches',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Boiler
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '26746fa6-ba79-4248-8d91-3138f3ecb8c5',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'boiler_location',
    'utilities',
    'Boiler',
    NULL,
    'etc.',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Boiler
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    'fe157f02-b63e-40f5-ab0d-1d82c8e9cb37',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'boiler_location',
    'utilities',
    'Boiler',
    NULL,
    'to be removed',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Boiler
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '14c5fa4d-216c-49bc-9ead-4310c6c47be1',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'boiler_location',
    'utilities',
    'Boiler',
    NULL,
    'flues to be removed',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Boiler
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '5e9240f4-229e-431c-917e-18519dd11f0d',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'boiler_location',
    'utilities',
    'Boiler',
    NULL,
    'Fireplace to',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Boiler
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '87bc03bb-d8ee-48b1-bf40-baea8ab87b84',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'boiler_location',
    'utilities',
    'Boiler',
    NULL,
    'Systems 3mm skim finish',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Boiler
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    'a52157d7-fda5-40bf-8565-040dd8c01134',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'boiler_location',
    'utilities',
    'Boiler',
    NULL,
    '5 5A light switch Light pendant Towel rail / Radiator',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Fire Alarm
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    'b15ba8f0-ab3d-42e9-bfce-23212b88827e',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'fire_alarm_location',
    'safety',
    'Fire Alarm',
    NULL,
    '& Detection Systems: Only applies to new dwellings.',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Parking
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '5dc8c0f6-8945-4dc8-8971-ba10a318881b',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'parking',
    'general',
    'Parking',
    NULL,
    NULL,
    'congestion). The site is',
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Parking
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '6733b21c-7046-425b-bf12-71fb34be4fd4',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'parking',
    'general',
    'Parking',
    NULL,
    NULL,
    'Zone A1, applicable hours, Monday-Friday 8.30am - 6.30 pm.',
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Parking
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    'f75d8958-956e-469d-b225-e758b9523ae0',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'parking',
    'general',
    'Parking',
    NULL,
    NULL,
    'bays with a 4 hour stay limit. See',
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Parking
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '148fb908-7285-4a7a-ad96-fd1e22e5ac04',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'parking',
    'general',
    'Parking',
    NULL,
    NULL,
    'bay within the first floor car park which may be used by',
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Electric Meter
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '4439192d-81a4-4fa2-9995-b2756c1d1ab8',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'electric_meter_location',
    'utilities',
    'Electric Meter',
    NULL,
    'Installers Electrical Installation Certificate to be',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Boiler
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '2eb15e60-1d21-4968-a392-c11be11b7de2',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'boiler_location',
    'utilities',
    'Boiler',
    NULL,
    'is existing. § Permanent labels to be fixed to earth connections & bonds',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Boiler
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '8675f09f-5d55-44d3-9bc0-7673ab45cc76',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'boiler_location',
    'utilities',
    'Boiler',
    NULL,
    'to be remain extractor to be redirected to rear wall',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Boiler
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    'c3b881b0-a765-4a64-9d9d-fa1beb9513b2',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'boiler_location',
    'utilities',
    'Boiler',
    NULL,
    'flue to be re-routed',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Boiler
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    'b53f407e-d68b-43ba-a914-044c162c93bb',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'boiler_location',
    'utilities',
    'Boiler',
    NULL,
    'flue boxed',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Boiler
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '39068892-463d-40f3-b66e-491477e22281',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'boiler_location',
    'utilities',
    'Boiler',
    NULL,
    'condensing',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Boiler
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '8699c78b-fd8d-46ed-9648-e5e71c7af30c',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'boiler_location',
    'utilities',
    'Boiler',
    NULL,
    'flue and kitchen Bellcast bead',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Boiler
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '6a040229-a437-475d-b2f6-0ea4d1106cdb',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'boiler_location',
    'utilities',
    'Boiler',
    NULL,
    'flue box Living room b o a p r e r n ie in rs g s around all 1 G y la p y s e u r m o f a 1 n 2 d .5mm FireLine duplex',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Fire Alarm
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    'bd818129-a05b-462c-9b7a-3f5046bdebd7',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'fire_alarm_location',
    'safety',
    'Fire Alarm',
    NULL,
    '& Detection Systems: § Not applicable to this existing flat § Fuses, RCDs and switches within consumer unit and remote fused switches',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Parking
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    'cd8d91b3-77e1-4b7f-ba72-78db5c52bb31',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'parking',
    'general',
    'Parking',
    NULL,
    NULL,
    'ventilation systems, approved',
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Parking
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    'e9a74631-9b0d-403e-b330-ec6b639a7b06',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'parking',
    'general',
    'Parking',
    NULL,
    NULL,
    'tools. Take action to',
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Parking
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    'c91a50b0-b316-41b0-a70c-6699639b3fbf',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'parking',
    'general',
    'Parking',
    NULL,
    NULL,
    'ventilation systems, approved explosion-proof equipment, and',
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Parking
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '209daa4e-6f33-4166-8b30-315ac5cbf317',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'parking',
    'general',
    'Parking',
    NULL,
    NULL,
    'tools.',
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Boiler
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '93064bb3-6c12-4e8e-99ae-94b723602b07',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'boiler_location',
    'utilities',
    'Boiler',
    NULL,
    'at the above property/address has been carried out by',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Boiler
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '9d340274-8923-412b-bfce-f77d416dc356',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'boiler_location',
    'utilities',
    'Boiler',
    NULL,
    'removed',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Boiler
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    'b1bd8fcd-4dd3-4949-b7c2-a2fe4efe74ae',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'boiler_location',
    'utilities',
    'Boiler',
    NULL,
    'to replace existing gas unit.',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Boiler
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    'd90cff11-5942-4c77-9d77-517cd14f585e',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'boiler_location',
    'utilities',
    'Boiler',
    NULL,
    'or air source heat pump panels. Allow to use 18mm',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Parking
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '68f46a31-5fc3-4918-93cc-627e7c04f709',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'parking',
    'general',
    'Parking',
    NULL,
    NULL,
    'bay within the first floor car park which may be used by the contractor for storage. The site',
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Parking
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    'f08ea377-ab0f-4a1a-b251-a0eeb904e3c0',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'parking',
    'general',
    'Parking',
    NULL,
    NULL,
    'Zone A1, applicable hours,',
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Parking
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    'f883b10f-c0ef-4d5b-bc9e-ae959ad739f7',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'parking',
    'general',
    'Parking',
    NULL,
    NULL,
    'or skips changes',
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Parking
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '41bc64f1-805c-4cd3-96df-61d360102d3e',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'parking',
    'general',
    'Parking',
    NULL,
    NULL,
    'bay within the first floor car park which may be used by the',
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Parking
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    'e5c2d0fa-2f56-464a-9859-e8dbee0cf8c3',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'parking',
    'general',
    'Parking',
    NULL,
    NULL,
    'a car. Note that this car park has limited headroom which will',
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Boiler
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '59fa5f90-9856-41a7-ac45-38bf50527789',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'boiler_location',
    'utilities',
    'Boiler',
    NULL,
    'Systems by British Gypsum with joints sealed as VCL',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Boiler
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '38b779c7-2dca-49bf-b8fa-c4290167dedc',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'boiler_location',
    'utilities',
    'Boiler',
    NULL,
    '& radiaotors',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: CCTV
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '6ca7aac9-84cf-4a83-aabe-2e31842b42bc',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'cctv_location',
    'safety',
    'CCTV',
    NULL,
    '- 1 ,500 2 ,387',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Fire Alarm
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    'c81db21f-7852-4d4a-9df8-3b23f9dedfc2',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'fire_alarm_location',
    'safety',
    'Fire Alarm',
    NULL,
    'is audible / visible in all areas N/A Unable to confirm due to the alarm not',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Fire Alarm
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '1c6a04c9-0408-4676-b03f-7e4c9f996800',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'fire_alarm_location',
    'safety',
    'Fire Alarm',
    NULL,
    'in the',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Fire Alarm
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '69e32bcc-9f03-43d0-94ec-524f4447a4c1',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'fire_alarm_location',
    'safety',
    'Fire Alarm',
    NULL,
    'may not to date records in fire log book.',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Fire Alarm
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '110de3b1-5ac5-44d0-8a19-9455870ddf1b',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'fire_alarm_location',
    'safety',
    'Fire Alarm',
    NULL,
    'systems',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Fire Alarm
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '9df1021a-da4f-4506-b4d9-e66e2853d8cd',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'fire_alarm_location',
    'safety',
    'Fire Alarm',
    NULL,
    'call Smoke vent switches for    Automatic operation also 1 2 L Replace smoke ventilation call points with',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Fire Alarm
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    'eaf29053-facb-4fed-9a22-6c5f88da7cb9',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'fire_alarm_location',
    'safety',
    'Fire Alarm',
    NULL,
    '* frequently has the following',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Fire Alarm
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    'c55f04f3-79f0-4619-aa52-52515b58ef4c',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'fire_alarm_location',
    'safety',
    'Fire Alarm',
    NULL,
    'systems including any',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: CCTV
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '31359b1d-cd6d-4c0d-bbd1-117a312d90de',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'cctv_location',
    'safety',
    'CCTV',
    NULL,
    'equipment;',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Sprinkler
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    'fa691abb-9961-4f73-92c1-60d25c76eb47',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'sprinkler_location',
    'safety',
    'Sprinkler',
    NULL,
    'system covers a covered car park and partially escape corridors from the car park which is',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Sprinkler
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '06f77411-d33c-474a-8925-4e191fc39396',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'sprinkler_location',
    'safety',
    'Sprinkler',
    NULL,
    'control valves identified and N/A Responsibility of others.',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Sprinkler
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '88e4349a-661e-40af-a239-3838986a7fca',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'sprinkler_location',
    'safety',
    'Sprinkler',
    NULL,
    'system appears in good condition? N/A Responsibility of others.',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Sprinkler
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '68f416dd-b578-48e4-99e3-735d3ea9b7cf',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'sprinkler_location',
    'safety',
    'Sprinkler',
    NULL,
    'system *Action outstanding from previous',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Fire Assembly Point
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '717a5f57-07d0-4bcd-8518-e313870039f1',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'assembly_point',
    'safety',
    'Fire Assembly Point',
    NULL,
    NULL,
    'identified? N/A Residential property - assembly point is',
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Bin Store
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '11dfd975-c681-4375-a877-a40042513f2b',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'bin_store',
    'general',
    'Bin Store',
    NULL,
    NULL,
    '- Internal courtyard / communal garden - Roof of Core A - External elevations',
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: CCTV
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '0a3ead25-26cb-4620-98ae-9badd8942635',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'cctv_location',
    'safety',
    'CCTV',
    NULL,
    '1 ,576 1 ,500 -',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Fire Alarm
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    'ea915074-1c95-4bdb-8e20-33852f9f7746',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'fire_alarm_location',
    'safety',
    'Fire Alarm',
    NULL,
    'may not log book.',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Fire Alarm
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    'dc009dc5-7628-4dac-8bb7-00a8d09764ea',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'fire_alarm_location',
    'safety',
    'Fire Alarm',
    NULL,
    'bell tests. regular bell tests of the fire alarm system,',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: CCTV
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    'c30e95c8-125c-42c9-85a8-9f424850a60b',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'cctv_location',
    'safety',
    'CCTV',
    NULL,
    'equipment',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Sprinkler
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '30b57f09-99c0-4d18-aa0c-8961baf851d4',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'sprinkler_location',
    'safety',
    'Sprinkler',
    NULL,
    'system appears in good condition?  No issues identified.',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: CCTV
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '05831ef4-091f-4086-8aab-41a67b6d5fa7',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'cctv_location',
    'safety',
    'CCTV',
    NULL,
    '- SCHEDULE A £1,500.00 £1,500.00Maintained as prev',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Boiler
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '4ee1a310-2c65-4577-a407-e30f12979662',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'boiler_location',
    'utilities',
    'Boiler',
    NULL,
    'within the flat is to be relocated to a position adjacent to the existing',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Sprinkler
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '1ced75d4-bfa2-41b7-b917-dbc613d2cafd',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'sprinkler_location',
    'safety',
    'Sprinkler',
    NULL,
    'systems—minimising consequential water damage, whilst providing the',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Parking
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '306c8b1c-d0b1-42b7-bced-38fc900440df',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'parking',
    'general',
    'Parking',
    NULL,
    NULL,
    'space numbered XX for the parking of a private motor vehicle. The Lessor reserves the right to reallocate spaces from time to time. The occupier of the flat has right of access between his car and his...',
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Parking
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '691d5db7-a0fc-403b-8a7a-c793818e8e0f',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'parking',
    'general',
    'Parking',
    NULL,
    NULL,
    '© 2020 The Association of Residential Managing Agents Ltd',
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Parking
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '6cb508f3-1769-47d4-bc2e-538afd79e22a',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'parking',
    'general',
    'Parking',
    NULL,
    NULL,
    'Signed on behalf of the Client …………………………………………………',
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Parking
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    'a892cf11-cd86-41d3-9931-46715847d318',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'parking',
    'general',
    'Parking',
    NULL,
    NULL,
    'costs and equipment hire costs.',
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Post Room
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '8c2194a5-291d-43f0-8c49-044f40d7617a',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'post_room',
    'general',
    'Post Room',
    NULL,
    NULL,
    'and bin areas.',
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: CCTV
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '2508eb59-dfc6-4dae-8df2-5c361760e187',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'cctv_location',
    'safety',
    'CCTV',
    NULL,
    'monitor 19.99m 0.10ma Pass – visual',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: CCTV
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    'f3878748-1800-45bd-8866-be1aec9faccb',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'cctv_location',
    'safety',
    'CCTV',
    NULL,
    'recorder 19.99m 0.10ma Pass – visual',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: CCTV
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    'be62ed8a-8112-41c0-8807-3736d9901218',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'cctv_location',
    'safety',
    'CCTV',
    NULL,
    'and patrols the building has been kept secure from unauthorised entry',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Fire Alarm
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '8bec17ea-de4d-4485-85c4-2989931ca3e7',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'fire_alarm_location',
    'safety',
    'Fire Alarm',
    NULL,
    'Maintenance in line with BS5839: Pt1. per visit Routine Fire Alarm Service Visit - System Satisfactory',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Fire Alarm
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    'e11f0dfa-43c5-495d-9d37-18f81a2d77af',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'fire_alarm_location',
    'safety',
    'Fire Alarm',
    NULL,
    'Maintenance in line with BS5839: Pt1. per visit per block £40.00 £240.00',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Alarm Panel
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '0fdec51a-b8a8-4e0d-a8d8-1aaa10a1e563',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'alarm_panel_location',
    'safety',
    'Alarm Panel',
    NULL,
    'at the concierge desk.',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Fire Alarm
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '41a91a4c-084c-461e-b792-2a3db7d1685e',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'fire_alarm_location',
    'safety',
    'Fire Alarm',
    NULL,
    'system: Yes',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Fire Alarm
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    'b1fdef4d-4216-49bf-8113-19c6db98aad6',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'fire_alarm_location',
    'safety',
    'Fire Alarm',
    NULL,
    'System, the Customer shall, in the event of the System operating, forthwith notify the Company thereof by telephone: the Company',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Boiler
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '2ed6e491-22c2-4bcc-a37a-c14fb7322b33',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'boiler_location',
    'utilities',
    'Boiler',
    NULL,
    'rooms etc',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Boiler
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '97977211-0a49-4449-b9b7-6e9f642e4805',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'boiler_location',
    'utilities',
    'Boiler',
    NULL,
    'rooms etc. Thereafter for the',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Fire Alarm
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '4927a91e-75b6-492e-b514-5b660bc82c61',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'fire_alarm_location',
    'safety',
    'Fire Alarm',
    NULL,
    'system & Smoke Ventilation Systems',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Fire Alarm
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    'aa73bbce-b459-4659-be59-92586324ba64',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'fire_alarm_location',
    'safety',
    'Fire Alarm',
    NULL,
    'system & Smoke Ventilation systems Equipment Schedule',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Fire Alarm
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    'af8eede1-3766-46c5-b9a0-370b5bae20cd',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'fire_alarm_location',
    'safety',
    'Fire Alarm',
    NULL,
    'Equipment Schedule',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Fire Alarm
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '463e77f0-f7a7-4add-bc47-d51ee4497304',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'fire_alarm_location',
    'safety',
    'Fire Alarm',
    NULL,
    'Panels',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Fire Alarm
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '234f7d97-1d30-4820-b016-5c125c6d144f',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'fire_alarm_location',
    'safety',
    'Fire Alarm',
    NULL,
    'System – 2 visits per year',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Fire Alarm
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    'b9a3f202-6220-42b7-9c54-1e32a4b9efbe',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'fire_alarm_location',
    'safety',
    'Fire Alarm',
    NULL,
    'System £2,135.00',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Fire Alarm
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    'baf78ba7-8b43-4f80-8992-231c1942085f',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'fire_alarm_location',
    'safety',
    'Fire Alarm',
    NULL,
    'system logbook for each system will be completed and any defect logged and',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Fire Alarm
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '1ae491b7-2b78-4d20-aa8a-f8877d473c7a',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'fire_alarm_location',
    'safety',
    'Fire Alarm',
    NULL,
    'Periodic Maintenance',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Fire Alarm
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '31d02fbb-2207-488d-9c88-91a4133bacfd',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'fire_alarm_location',
    'safety',
    'Fire Alarm',
    NULL,
    'systems for buildings —Part 1: Code of practice for system design, installation,',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Fire Alarm
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '0e55ccb1-97a9-4185-99f9-f57b00defeed',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'fire_alarm_location',
    'safety',
    'Fire Alarm',
    NULL,
    'panel. Should these not be available our engineer will',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Fire Alarm
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    'e4793d04-c37d-41e1-a211-38ce7f21492e',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'fire_alarm_location',
    'safety',
    'Fire Alarm',
    NULL,
    'system to the relevant British Standards;',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Fire Alarm
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    'e558a4b1-ce64-4c53-9b3d-b7ade7001e02',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'fire_alarm_location',
    'safety',
    'Fire Alarm',
    NULL,
    'Servicing will be undertaken either quarterly or Bi-annually dependent on the size',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Fire Alarm
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    'b7a734f8-306f-4ab6-be79-2349ace39f8b',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'fire_alarm_location',
    'safety',
    'Fire Alarm',
    NULL,
    'System.',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Fire Alarm
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    'ae8bd47c-0c75-445b-9824-719a8c03f4d0',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'fire_alarm_location',
    'safety',
    'Fire Alarm',
    NULL,
    'and detection system is carried out. All 2-hour response. Our standard response is 4 hour',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Fire Alarm
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    'b01480d3-6a5c-45fc-ba1f-c5ba73415303',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'fire_alarm_location',
    'safety',
    'Fire Alarm',
    NULL,
    'and detection',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Fire Alarm
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    'b610cf25-de08-4abc-abba-812f9b474dff',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'fire_alarm_location',
    'safety',
    'Fire Alarm',
    NULL,
    '• CCTV • Intruder Alarm • Communications • Networked Systems',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: CCTV
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    'e35d6817-96c6-482b-bb5f-ce978574e6e7',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'cctv_location',
    'safety',
    'CCTV',
    NULL,
    '• Intruder Alarm • Communications • Networked Systems',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Parking
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    'bcaa66d2-c13a-4c79-b70b-0b9aa82c1d55',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'parking',
    'general',
    'Parking',
    NULL,
    NULL,
    'or congestion charges',
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Fire Alarm
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '2d7b6a0f-0904-40be-9099-2c953964fc2a',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'fire_alarm_location',
    'safety',
    'Fire Alarm',
    NULL,
    'System',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Parking
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    'accf11b2-e409-4bfe-b47a-1a9294085fcf',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'parking',
    'general',
    'Parking',
    NULL,
    NULL,
    'Congestion Charge',
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Fire Alarm
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '8b533d80-0675-46bd-ad40-ebdeadb86b5d',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'fire_alarm_location',
    'safety',
    'Fire Alarm',
    NULL,
    'Systems of the type(s) we have identified below, certify that the maintenance work identifield below complies',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Sprinkler
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '7f6d4291-127b-4c27-a9e2-4ef177628038',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'sprinkler_location',
    'safety',
    'Sprinkler',
    NULL,
    'Contractor Certificate No. 323',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Fire Alarm
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '3f85ee0e-05c0-4b3f-a22e-7144e6fe3abf',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'fire_alarm_location',
    'safety',
    'Fire Alarm',
    NULL,
    '(L4)',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Fire Alarm
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '35447414-b897-47a5-8cff-fad27cebff84',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'fire_alarm_location',
    'safety',
    'Fire Alarm',
    NULL,
    'systems,',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Fire Alarm
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    'c5f5da29-bd27-49bc-9503-e94ecb1b2052',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'fire_alarm_location',
    'safety',
    'Fire Alarm',
    NULL,
    'System at Pimlico Place, as detailed in 1 2,087.00 2,087.00',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Fire Alarm
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '324b674b-cba6-4af6-8a6f-0c1e028caca7',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'fire_alarm_location',
    'safety',
    'Fire Alarm',
    NULL,
    'systems there.',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Alarm Panel
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    'eaa33763-8bcf-4c9c-b1c4-2767572cd85a',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'alarm_panel_location',
    'safety',
    'Alarm Panel',
    NULL,
    'DateofTest-06/06/2025',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Fire Alarm
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '06696fc3-2e4d-476f-b436-847d870fedfd',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'fire_alarm_location',
    'safety',
    'Fire Alarm',
    NULL,
    'MAINTENANCE REPORT',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Fire Alarm
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    'fe30cd0b-b107-4f21-9be1-6c6a710cea1b',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'fire_alarm_location',
    'safety',
    'Fire Alarm',
    NULL,
    'SERVICE',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Fire Alarm
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    'd5ee8e86-bd01-418b-9560-7d63428cb14b',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'fire_alarm_location',
    'safety',
    'Fire Alarm',
    NULL,
    'Maintenance in line with BS5839: Pt1. per visit - Routine Fire Alarm Service Visit - System Satisfactory',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Fire Alarm
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    'e016f864-830d-4866-85f8-4fc70caa165c',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'fire_alarm_location',
    'safety',
    'Fire Alarm',
    NULL,
    'Maintenance in line with BS5839: Pt1. per visit £240.00 £240.00',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Parking
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    'd616e2f9-9a9c-48cf-a483-94078ce4ce4e',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'parking',
    'general',
    'Parking',
    NULL,
    NULL,
    'procedures to control',
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Fire Alarm
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '44a96a19-d307-44c4-920a-1965049b2aed',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'fire_alarm_location',
    'safety',
    'Fire Alarm',
    NULL,
    'and will need to be closed',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Fire Alarm
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '5fbbac7a-1394-471d-bb3c-e1d9eabb57f0',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'fire_alarm_location',
    'safety',
    'Fire Alarm',
    NULL,
    'reset.',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Fire Alarm
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '3bb5631e-d124-4b6d-9ab4-4470ebf63d91',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'fire_alarm_location',
    'safety',
    'Fire Alarm',
    NULL,
    'and smoke detection with AOVs; gas safety monitoring system; Gym; pond/water feature; communal water system',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Fire Alarm
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    'ac1f30c7-afb4-4752-8325-ffba4a850735',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'fire_alarm_location',
    'safety',
    'Fire Alarm',
    NULL,
    '/ Smoke Detection & AOVs Fidelity 1 Stables Court High Street Orpington BR5 3NL 0844 800 9960 service@fidelityintegrated.com',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: CCTV
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '2c25303c-291c-4df8-b8f7-0e74ac479035',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'cctv_location',
    'safety',
    'CCTV',
    NULL,
    'Seecam 20 Market Hill Southam CV47 0HF 07917 508961 info@seecam.co.uk',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Parking
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    'c8c76db6-626e-4db1-8ffa-773c16aa088f',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'parking',
    'general',
    'Parking',
    NULL,
    NULL,
    'spaces',
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Stopcock
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    'b1bdda66-e457-4c26-94c9-6be217551174',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'stopcock_location',
    'utilities',
    'Stopcock',
    NULL,
    'and is insulated. From',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Sprinkler
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '5d34f2e0-a60e-4f75-85c8-dbbe840565d5',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'sprinkler_location',
    'safety',
    'Sprinkler',
    NULL,
    'and When witnessing tests of sprinkler blow-down and hose reels ensure that there is minimum risk As directed',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Bin Store
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '124e7db3-1699-4922-a1d2-3d09778b927f',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'bin_store',
    'general',
    'Bin Store',
    NULL,
    NULL,
    '1x Bib Tap - Low Use 24.9',
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Parking
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '01e48747-b772-432d-b6b8-bef9dbf21f0f',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'parking',
    'general',
    'Parking',
    NULL,
    NULL,
    'areas for the flats and commercial units.',
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Water Meter
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    'b5a62009-ea69-451d-820e-6e4b2b929b46',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'water_meter_location',
    'utilities',
    'Water Meter',
    NULL,
    'NON-RETURN DOUBLE CHECK VALVE TEMPERATURE PRESSURE GAUGE IWH: INSTANTANEOUS WATER HEATER PRESSURE RELIEF VALVE H PO IU U : W HE H A : T P O IN IN TE T R O F F A U C S E E U W NI A T TER HEATER CWH COM...',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Boiler
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    'efb17eec-f270-47f0-9518-5905393de3ab',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'boiler_location',
    'utilities',
    'Boiler',
    NULL,
    'MIXER TAP EXPANSION VESSEL',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Boiler
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    'db610bff-407b-43b2-895f-89caf0a82a6d',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'boiler_location',
    'utilities',
    'Boiler',
    NULL,
    'WM WASHING MACHINE WATER SOFTENER IM ICE MACHINE',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Stopcock
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '02532c01-e40c-4b57-94c0-7613f3eae243',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'stopcock_location',
    'utilities',
    'Stopcock',
    NULL,
    'and is insulated.',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Bin Store
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '95bf01be-b4e7-4550-bb84-6d3546bb42c5',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'bin_store',
    'general',
    'Bin Store',
    NULL,
    NULL,
    '1 x Bib Tap - Low Use 19.9',
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: CCTV
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '20df1777-e504-45b8-9beb-a3455e818e95',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'cctv_location',
    'safety',
    'CCTV',
    NULL,
    '1,500.00 375.00 144.00 -231.00',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Parking
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    'bfacb5f2-727a-4b77-af1b-cb6e0b96110c',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'parking',
    'general',
    'Parking',
    NULL,
    NULL,
    'Space 1, Pimlico Place Last In None',
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Parking
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '43c16134-7a3c-44cf-a9c6-bad5323f8a59',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'parking',
    'general',
    'Parking',
    NULL,
    NULL,
    'Space 47, Pimlico Place Last In None',
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Boiler
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    'ccd16d6e-15a6-413d-ae61-c2c9e1197ded',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'boiler_location',
    'utilities',
    'Boiler',
    NULL,
    'Service £172.80 £0.00 £0.00',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Boiler
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '0b982912-7d94-4539-b777-f9742ac9d862',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'boiler_location',
    'utilities',
    'Boiler',
    NULL,
    'service £259.20 £0.00 £0.00',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Fire Alarm
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    'c1460a3d-6159-4321-9ce5-be1815fe82b9',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'fire_alarm_location',
    'safety',
    'Fire Alarm',
    NULL,
    'activation by E6£174.00 £0.00 £0.00',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Fire Alarm
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '61b5b42d-d74c-4e23-808c-c9b63c20e924',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'fire_alarm_location',
    'safety',
    'Fire Alarm',
    NULL,
    '/ Health & Safety Service £4,500.00 £0.00 £0.00',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Fire Alarm
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '75525fc6-7ded-484a-8e44-345ccc510a31',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'fire_alarm_location',
    'safety',
    'Fire Alarm',
    NULL,
    '/ Health & Safety Service £6,000.00 £0.00 £0.00',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Fire Alarm
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    'ac2f4361-0a78-4be8-b6db-cee08f2ca21c',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'fire_alarm_location',
    'safety',
    'Fire Alarm',
    NULL,
    '/ Health & Safety Service-£6,000.00 £0.00 £0.00',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Parking
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    'a7b7179e-293a-4bb7-9ec3-ad87b6e09cba',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'parking',
    'general',
    'Parking',
    NULL,
    NULL,
    'Space 1, Pimlico Place',
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Parking
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '5f38f46c-a1c8-4988-bec5-00a7191673cb',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'parking',
    'general',
    'Parking',
    NULL,
    NULL,
    'Space 47, Pimlico Place',
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Boiler
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '1a019376-38aa-42a0-a19a-b64317e96ebe',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'boiler_location',
    'utilities',
    'Boiler',
    NULL,
    '- Gas Safety Service and Maintenance - 4,698.00 4,698.00',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Boiler
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    'd5cdcf2d-e597-4ed9-a2a7-6cee866fc6bb',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'boiler_location',
    'utilities',
    'Boiler',
    NULL,
    '- Gas Safety Service" - -4,698.00 -4,698.00',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Fire Alarm
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '74050cdf-9347-490e-80fd-3062772c5322',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'fire_alarm_location',
    'safety',
    'Fire Alarm',
    NULL,
    'maintenance - Jul 24 - 288.00 288.00',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Fire Alarm
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '66e9f370-0093-49d4-84d6-3bb9bb0eae90',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'fire_alarm_location',
    'safety',
    'Fire Alarm',
    NULL,
    'Maintenance - Apr 25 - 288.00 288.00',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Fire Alarm
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '1ad66404-986a-4aa5-a91d-236565fd9b40',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'fire_alarm_location',
    'safety',
    'Fire Alarm',
    NULL,
    'and smoke vent - 2,796.00 2,796.00',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Bin Store
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '16904be1-49c5-483e-9fd2-20fa46ce6864',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'bin_store',
    'general',
    'Bin Store',
    NULL,
    NULL,
    'light which is - 752.40 752.40',
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Fire Alarm
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    'fc16f55c-ac48-48e1-a40d-2296ad8bb3a2',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'fire_alarm_location',
    'safety',
    'Fire Alarm',
    NULL,
    '/ Extinguishers / Emergency Lights 4,000.00 1,000.00 235.20 -764.80',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: CCTV
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '309a9bad-e622-4da2-b63d-d1f09cbc421e',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'cctv_location',
    'safety',
    'CCTV',
    NULL,
    '1,500.00 375.00 -375.00',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Fire Alarm
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '1284b788-b904-449e-9f7e-c93f2d06556c',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'fire_alarm_location',
    'safety',
    'Fire Alarm',
    NULL,
    '/ Extinguishers / Emergency Lights 4,000.00 2,000.00 3,499.35 1,499.35',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: CCTV
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '4dc48b2c-b778-4a11-8c4b-d12260b2b680',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'cctv_location',
    'safety',
    'CCTV',
    NULL,
    '1,500.00 750.00 -750.00',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Fire Alarm
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '2024c469-80ff-469e-91da-7fc7f1bee341',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'fire_alarm_location',
    'safety',
    'Fire Alarm',
    NULL,
    '/ Extinguishers / Emergency Lights 4,000.00 3,000.00 2,262.60 -737.40',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: CCTV
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '68a1b920-58c8-436a-94ea-329375146eb1',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'cctv_location',
    'safety',
    'CCTV',
    NULL,
    '1,500.00 1,125.00 1,482.24 357.24',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Fire Alarm
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '458e34c3-af9f-48ba-8cb3-fb16b353eef9',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'fire_alarm_location',
    'safety',
    'Fire Alarm',
    NULL,
    '/ Extinguishers / Emergency Lights 4,000.00 3,000.00 6,827.14 3,827.14',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: CCTV
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '4a708475-13e0-477a-b2df-a616f8d3bf5b',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'cctv_location',
    'safety',
    'CCTV',
    NULL,
    '1,500.00 1,125.00 -1,125.00',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Fire Alarm
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '989cc2fc-9ca6-4ba7-be12-10eb04117c31',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'fire_alarm_location',
    'safety',
    'Fire Alarm',
    NULL,
    '/ Extinguishers / Emergency Lights 4,000.00 2,000.00 2,070.60 70.60',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: CCTV
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    'b45f5079-ae4f-44ff-88d1-95d25ced90c0',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'cctv_location',
    'safety',
    'CCTV',
    NULL,
    '1,500.00 750.00 72.00 -678.00',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: CCTV
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '6f19369a-9bb0-413a-be49-0e45efaeafd2',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'cctv_location',
    'safety',
    'CCTV',
    NULL,
    '72.00 72.00',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Fire Alarm
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '4feb1e56-67b2-480b-b5f8-a217f750ebef',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'fire_alarm_location',
    'safety',
    'Fire Alarm',
    NULL,
    '/ Extinguishers / Emergency Lights 4,000.00 1,000.00 1,248.60 248.60',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: CCTV
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    'ec2543d9-e1fb-4607-8499-db9f24c86a85',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'cctv_location',
    'safety',
    'CCTV',
    NULL,
    '1,500.00 375.00 72.00 -303.00',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Boiler
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '45c03281-b662-4e2f-84d5-cbafef0a761e',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'boiler_location',
    'utilities',
    'Boiler',
    NULL,
    '- Gas Safety Service" - 4,698.00 4,698.00',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Fire Alarm
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '19e5a709-51ed-415d-82e5-0ab9cb54e672',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'fire_alarm_location',
    'safety',
    'Fire Alarm',
    NULL,
    'Maintenance - Jan 24 - 288.00 288.00',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: CCTV
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '2eddcff8-dcc6-4c29-8471-101e5e569ef5',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'cctv_location',
    'safety',
    'CCTV',
    NULL,
    '- SCHEDULE A',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: CCTV
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    'b262a5cb-6a45-4432-88ea-b48b5cda6ff8',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'cctv_location',
    'safety',
    'CCTV',
    NULL,
    'battery - 312.00 312.00',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: CCTV
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '3c8b4418-f291-4cf2-9afd-901c5031f580',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'cctv_location',
    'safety',
    'CCTV',
    NULL,
    '- 1,263.60 1,263.60',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Caretaker
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    'e538ce0e-3fb1-453d-a839-dfaacea1a468',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'caretaker',
    'general',
    'Caretaker',
    NULL,
    NULL,
    'Supplies - 92.41 92.41',
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Caretaker
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '69a64964-12fd-488a-8c3b-02c379efafc4',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'caretaker',
    'general',
    'Caretaker',
    NULL,
    NULL,
    'Supplies - 3.85 3.85',
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Parking
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '826918b3-b981-44a3-a250-40de2b9d3d16',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'parking',
    'general',
    'Parking',
    NULL,
    NULL,
    'Space 1 - Current',
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Parking
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    'd5c088b9-1435-44c2-ab4e-bbd0c6856f7c',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'parking',
    'general',
    'Parking',
    NULL,
    NULL,
    'Space 1 551.81 551.81',
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Parking
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '0bd8350e-e564-4954-8756-c64abd722a77',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'parking',
    'general',
    'Parking',
    NULL,
    NULL,
    'Space 47 - Current',
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Parking
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '3a565a8e-715d-46c4-a503-dc31deee3b20',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'parking',
    'general',
    'Parking',
    NULL,
    NULL,
    'Space 47 551.81 551.81',
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Parking
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    'dfd84d97-f2e9-4ead-b2af-149e32f52336',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'parking',
    'general',
    'Parking',
    NULL,
    NULL,
    'Space 1',
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Parking
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    'c65f1a5a-d08e-4bf5-8e0d-205ee53aef24',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'parking',
    'general',
    'Parking',
    NULL,
    NULL,
    'Space 47',
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Parking
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '4626c917-312d-40f0-9716-eb0df23d5153',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'parking',
    'general',
    'Parking',
    NULL,
    NULL,
    'Space 1 239.00 25.00 264.00',
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Parking
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '649daaa6-c3af-41c1-a7fe-a5274b259dcc',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'parking',
    'general',
    'Parking',
    NULL,
    NULL,
    'Space 47 - Previous',
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Parking
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    'bada6c1a-9bd3-48b7-9ce2-72f3c162fa41',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'parking',
    'general',
    'Parking',
    NULL,
    NULL,
    'Space 47 239.00 239.00',
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Parking
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '39250db8-99e7-41b5-bbfd-a712969670c2',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'parking',
    'general',
    'Parking',
    NULL,
    NULL,
    'Space 47 239.00 25.00 264.00',
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Parking
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '9da0ea3e-4100-4dee-b05a-f6545bd6d090',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'parking',
    'general',
    'Parking',
    NULL,
    NULL,
    'Space 1 239.00 239.00',
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Parking
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    'a9e1a09f-5919-432f-8ab1-4f7bd82cf25d',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'parking',
    'general',
    'Parking',
    NULL,
    NULL,
    'Space 1 25.00 25.00',
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Parking
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '4afa0c0f-47c2-4bee-9fa5-10181bf35142',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'parking',
    'general',
    'Parking',
    NULL,
    NULL,
    'Space 47 25.00 25.00',
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: CCTV
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '627f742b-3828-42a9-93e9-c86461c7f609',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'cctv_location',
    'safety',
    'CCTV',
    NULL,
    '1,500.00 1,500.00',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: CCTV
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    'cb0b8790-7c17-40b9-ad0f-a832994780e2',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'cctv_location',
    'safety',
    'CCTV',
    NULL,
    '£ 2,768.00 £ 2,000.00 £ 1,500.00',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Fire Alarm
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '3bcdd00c-ab0c-41f5-ae20-8fd72da50570',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'fire_alarm_location',
    'safety',
    'Fire Alarm',
    NULL,
    'Maintenance - 288.00 288.00',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Caretaker
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '8570a5e4-3e72-40ed-9ac1-9c72a0daa7b9',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'caretaker',
    'general',
    'Caretaker',
    NULL,
    NULL,
    'supplies - 397.07 397.07',
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Caretaker
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '000b5727-6198-4636-8fb1-5279b2a36f70',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'caretaker',
    'general',
    'Caretaker',
    NULL,
    NULL,
    'supplies - 463.61 463.61',
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Caretaker
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '3a1c83a4-78b8-441c-aa27-0be5068dd121',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'caretaker',
    'general',
    'Caretaker',
    NULL,
    NULL,
    'cleaning supplies - 206.76 206.76',
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Caretaker
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    'cc134e3e-4001-45c3-8ee3-a8a7bc0206e1',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'caretaker',
    'general',
    'Caretaker',
    NULL,
    NULL,
    'supplies - 97.26 97.26',
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: CCTV
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '50c3e068-d79c-4496-badf-e72969f72569',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'cctv_location',
    'safety',
    'CCTV',
    NULL,
    'have been evaluated for cost-effectiveness while ensuring statutory compliance.',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: CCTV
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    'e67a5915-c958-4795-ba4f-f2756c8f3e36',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'cctv_location',
    'safety',
    'CCTV',
    NULL,
    '1,500.00 £ 8 33.40 £1,000.00Maintained by Fidelity on ad hoc basis, no formal contract reduced inline with Actual costs',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Fire Alarm
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    'acc0a090-0e27-40e8-9ff7-679239b7e15e',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'fire_alarm_location',
    'safety',
    'Fire Alarm',
    NULL,
    '6 MONTHLY MAINTENANCE',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Fire Alarm
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '17923b56-c69d-44b3-81ae-a4b6a4a5c045',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'fire_alarm_location',
    'safety',
    'Fire Alarm',
    NULL,
    'SERVICE 2.00 £280.00 20% £560.00',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Fire Alarm
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '9a765180-8b04-45a3-8fe3-0620b9492df3',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'fire_alarm_location',
    'safety',
    'Fire Alarm',
    NULL,
    'service £480.00 + VAT per annum',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Fire Alarm
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '9ec4fb43-a1ca-4741-ad7c-791be069725f',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'fire_alarm_location',
    'safety',
    'Fire Alarm',
    NULL,
    '/ Extinguishers / Emergency Lights £4,000.00 £2,930.00 £3,000.00Plus repair cost allowance',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: CCTV
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    'a5aebcb5-80a9-4c32-adcc-084d629b9401',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'cctv_location',
    'safety',
    'CCTV',
    NULL,
    '£1,500.00 £1,575.60 £1,500.00Maintained by Fidelity on ad hoc basis, no formal contract',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: CCTV
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    'b973c99a-50a1-46e0-9330-8d5b61350f4d',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'cctv_location',
    'safety',
    'CCTV',
    NULL,
    '£1,500.00 £1,500.00',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: CCTV
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    'f4b15f41-ff63-4014-ba26-300b062d3a67',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'cctv_location',
    'safety',
    'CCTV',
    NULL,
    'at Pimlico Place - 1,410.24 1,410.24',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Caretaker
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '99186458-2ab3-4791-8b94-b88ad59ba555',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'caretaker',
    'general',
    'Caretaker',
    NULL,
    NULL,
    'supplies - 152.10 152.10',
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Fire Alarm
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '03f4799f-f065-424e-9235-3bc71a60bf3f',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'fire_alarm_location',
    'safety',
    'Fire Alarm',
    NULL,
    '- 435.00 435.00',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Fire Alarm
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '462c62ba-6687-4eef-9bf9-4285736c3cbb',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'fire_alarm_location',
    'safety',
    'Fire Alarm',
    NULL,
    'Maintenance - 444.84 444.84',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Caretaker
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    'b9bead04-84a5-4629-a09d-727824f4be96',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'caretaker',
    'general',
    'Caretaker',
    NULL,
    NULL,
    'supplies - 261.93 261.93',
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Caretaker
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    'bc1c21d9-6ef3-4bf1-aaa3-6268a897063d',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'caretaker',
    'general',
    'Caretaker',
    NULL,
    NULL,
    'on site and - 168.00 168.00',
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Boiler
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    'f19fb25b-43f9-4b0b-afcc-8a96ce7a4d96',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'boiler_location',
    'utilities',
    'Boiler',
    NULL,
    'Present? n/a n/a n/a n/a',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Fire Alarm
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    'a26146c4-211c-479d-9dcd-1de3866f4843',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'fire_alarm_location',
    'safety',
    'Fire Alarm',
    NULL,
    'system with a suitable Smoke detectors have been installed to Residents & visitors.',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Fire Alarm
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    'e63937c2-3664-44d7-ad6c-ac2ae516f9eb',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'fire_alarm_location',
    'safety',
    'Fire Alarm',
    NULL,
    'system identified as being in good Residents & visitors.',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Fire Alarm
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    'bc2c8aad-49fe-4f71-b7b9-0fb9ea6c02a3',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'fire_alarm_location',
    'safety',
    'Fire Alarm',
    NULL,
    'confirmed as being adequately place, and given the presence of Residents & visitors.',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Fire Alarm
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '793ac39f-63ea-41f3-a48a-2b7752b8d563',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'fire_alarm_location',
    'safety',
    'Fire Alarm',
    NULL,
    'system plus AOV Residents & visitors.',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Fire Alarm
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '20c24a45-c943-4107-89e1-f63fd9deff40',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'fire_alarm_location',
    'safety',
    'Fire Alarm',
    NULL,
    'bell tests carried out on a weekly',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Fire Alarm
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    'b544bf82-ec45-4d4a-8651-f02b2303b046',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'fire_alarm_location',
    'safety',
    'Fire Alarm',
    NULL,
    'bell tests (at Residents & visitors.',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Fire Alarm
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '4c450734-2625-4cdb-acb6-5ebb1dea6202',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'fire_alarm_location',
    'safety',
    'Fire Alarm',
    NULL,
    'system, a full evacuation policy',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: CCTV
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '1a088c4a-21d1-49c2-8792-e9a5e1a00cd6',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'cctv_location',
    'safety',
    'CCTV',
    NULL,
    'yes Continue to maintain Attack / theft / fire. low',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Sprinkler
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '1c2dc287-b934-4828-87b1-692687151770',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'sprinkler_location',
    'safety',
    'Sprinkler',
    NULL,
    'in car park, staff kitchen & w.c. in block F ground floor, CCTV.',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Sprinkler
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    'a0ec7422-aa3e-4ba6-993c-38fa86aab969',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'sprinkler_location',
    'safety',
    'Sprinkler',
    NULL,
    'system is annually All persons within premises.',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Sprinkler
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    'a5df7afd-2513-492b-bec8-6717291d1ce3',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'sprinkler_location',
    'safety',
    'Sprinkler',
    NULL,
    'system identified within car park. maintained. Fire spread / smoke inhalation. medium',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Bin Store
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    'edaeb250-c928-4061-ab99-b29b9fdafc4b',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'bin_store',
    'general',
    'Bin Store',
    NULL,
    NULL,
    'to Guildhouse Street (as indicated on Plan of Blocks above). AOV',
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Bin Store
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '8a21e179-7518-4d61-9c43-d64d34f0fefb',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'bin_store',
    'general',
    'Bin Store',
    NULL,
    NULL,
    'on Residents & visitors.',
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Alarm Panel
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    'f9ef3594-7a29-46a4-bbf6-c65d39c0de90',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'alarm_panel_location',
    'safety',
    'Alarm Panel',
    NULL,
    'Zoning. Your fire alarm panel does not Ensure that a floor map is devised highlighting all the zoned Urgent action Ahmed',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Fire Alarm
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    'a854dd04-270c-4682-9f1c-06fd0637b104',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'fire_alarm_location',
    'safety',
    'Fire Alarm',
    NULL,
    'Panel Zoning. Your fire alarm panel does not Ensure that a floor map is devised highlighting all the zoned Urgent action Ahmed',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Fire Alarm
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    'cf7347e7-dc6a-43e6-b004-52caf9fea347',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'fire_alarm_location',
    'safety',
    'Fire Alarm',
    NULL,
    'systems must be tested weekly by a nominated 2-1 Six weeks Ahmed',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Fire Alarm
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '906afb4e-7676-408d-bb11-29133b87f0e2',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'fire_alarm_location',
    'safety',
    'Fire Alarm',
    NULL,
    'company. Keep service records on file.',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Fire Alarm
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    'd2253fd9-c698-464d-b46a-3c6ffee3cd25',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'fire_alarm_location',
    'safety',
    'Fire Alarm',
    NULL,
    'operating points easily accessible? Automatic fire alarm operating points are all easily accessible throughout the building.',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Sprinkler
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '4ac56e8a-dd82-42f5-b0f2-e99a2ef2303e',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'sprinkler_location',
    'safety',
    'Sprinkler',
    NULL,
    'system. The sprinkler Sprinkler systems provided within your premises require 2-1 Six weeks Ahmed',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Parking
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    'b4605e82-a25b-436d-9064-04f7bb2dd50b',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'parking',
    'general',
    'Parking',
    NULL,
    NULL,
    'spaces. The building has a gym with a Japanese court',
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Sprinkler
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '1669b175-1295-4e62-85d8-2011ab03a4db',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'sprinkler_location',
    'safety',
    'Sprinkler',
    NULL,
    'systems',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Parking
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '03575f9a-bdff-4528-8ed7-44c8d87f404d',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'parking',
    'general',
    'Parking',
    NULL,
    NULL,
    'around the',
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Parking
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    'f5065786-9a22-4ede-9c5b-b75de6fde2e5',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'parking',
    'general',
    'Parking',
    NULL,
    NULL,
    'and residential blocks (private and atfordable housing) of varying heights. An existing',
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Parking
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '46b7e3cd-aaa9-4af3-bc02-4f1c109a41ab',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'parking',
    'general',
    'Parking',
    NULL,
    NULL,
    'and residential accommodation;',
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Bin Store
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '146fc88a-09e8-4c13-bf99-1b918ca96886',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'bin_store',
    'general',
    'Bin Store',
    NULL,
    NULL,
    '1x Bib Tap - Low Use - - - -',
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Bin Store
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    'b21aa86d-6dd6-4f32-9e95-4555397e6c25',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'bin_store',
    'general',
    'Bin Store',
    NULL,
    NULL,
    'bib tap',
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Fire Alarm
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    'd83c0624-762a-4293-9f1b-01cdba5d9753',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'fire_alarm_location',
    'safety',
    'Fire Alarm',
    NULL,
    'panel? *',
    NULL,
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Bin Store
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    '65e6fe86-c84b-4bbd-90b8-7abb01f27364',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'bin_store',
    'general',
    'Bin Store',
    NULL,
    NULL,
    'in good, clean condition? *',
    'team'
)
ON CONFLICT (id) DO NOTHING;

-- Building knowledge: Parking
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, description, visibility
)
VALUES (
    'd8a1627a-477b-4c8e-a5cc-2a9e9f24db5c',
    'cd83b608-ee5a-4bcc-b02d-0bc65a477829',
    'parking',
    'general',
    'Parking',
    NULL,
    NULL,
    'issues on site, vehicles obstructing any roads/paths? Any abandoned vehicles? *',
    'team'
)
ON CONFLICT (id) DO NOTHING;
