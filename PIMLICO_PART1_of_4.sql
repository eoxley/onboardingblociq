BEGIN;
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
COMMIT;