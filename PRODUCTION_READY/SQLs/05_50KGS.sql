-- BlocIQ V2 Complete Building Migration
-- Generated: 2025-10-17T14:14:49.346536
-- Building: 50KGS

-- Building
INSERT INTO buildings (
    id, building_name, building_address, postcode,
    num_units, num_floors,
    building_height_meters,
    bsa_registration_required, bsa_status,
    construction_type, construction_era
) VALUES (
    '89eb5987-2e92-4fba-ac69-a7c8f257c570',
    '50KGS',
    NULL,
    NULL,
    112,
    6,
    NULL,
    FALSE,
    'Not HRB',
    ', or currently',
    'Modern'
) ON CONFLICT (id) DO NOTHING;

-- Units (112)
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    '40008c68-3255-45e8-8175-c7d55cc02366',
    '89eb5987-2e92-4fba-ac69-a7c8f257c570',
    '189-01-001',
    18,
    1.08,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    '16a621ee-26e8-47c3-ad1e-135f1b9c07a2',
    '89eb5987-2e92-4fba-ac69-a7c8f257c570',
    '189-01-002',
    18,
    1.08,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    'aebb719f-9963-45f3-bb13-46285d6e11f9',
    '89eb5987-2e92-4fba-ac69-a7c8f257c570',
    '189-01-003',
    18,
    0.43,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    '9b14c276-4166-4e7d-b5a5-f951d94265c6',
    '89eb5987-2e92-4fba-ac69-a7c8f257c570',
    '189-01-004',
    18,
    0.52,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    'a88a6efd-b812-42bd-912e-c405b2c69dea',
    '89eb5987-2e92-4fba-ac69-a7c8f257c570',
    '189-01-005',
    18,
    1.08,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    '59c7c509-0dc7-453b-8daf-fb1f25b3a1fd',
    '89eb5987-2e92-4fba-ac69-a7c8f257c570',
    '189-01-006',
    18,
    0.94,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    '1f5f3ce8-3923-4914-81a2-097814fde105',
    '89eb5987-2e92-4fba-ac69-a7c8f257c570',
    '189-01-007',
    18,
    0.73,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    'e6b04360-11a8-439b-a9b8-4ce99e4ed814',
    '89eb5987-2e92-4fba-ac69-a7c8f257c570',
    '189-01-008',
    18,
    0.81,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    '1692076b-948f-4fb0-ace2-26ccfa1eab03',
    '89eb5987-2e92-4fba-ac69-a7c8f257c570',
    '189-01-009',
    18,
    1.19,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    '4c7c08c4-2d2c-40f5-baab-6f952bd982e4',
    '89eb5987-2e92-4fba-ac69-a7c8f257c570',
    '189-01-010',
    18,
    1.08,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    '3c95d86a-d0a4-416c-a4e5-7a203f7c1527',
    '89eb5987-2e92-4fba-ac69-a7c8f257c570',
    '189-01-011',
    18,
    0.94,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    '926410f3-eda1-4471-bd94-e6dcd81c31ff',
    '89eb5987-2e92-4fba-ac69-a7c8f257c570',
    '189-01-012',
    18,
    0.73,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    '91bcd26a-1431-4e1b-b98f-68cd8b0b5d12',
    '89eb5987-2e92-4fba-ac69-a7c8f257c570',
    '189-01-013',
    18,
    0.81,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    '76bb061f-5b82-47b5-8742-d49b1663a10f',
    '89eb5987-2e92-4fba-ac69-a7c8f257c570',
    '189-01-014',
    18,
    1.19,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    '72dfaab1-e63c-4f1e-b922-097ead7b9d6b',
    '89eb5987-2e92-4fba-ac69-a7c8f257c570',
    '189-01-015',
    18,
    1.08,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    'dd014531-a748-4cd2-8c02-4c570b54c06e',
    '89eb5987-2e92-4fba-ac69-a7c8f257c570',
    '189-01-016',
    18,
    0.94,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    '327630c1-823e-419e-ba5a-234207984799',
    '89eb5987-2e92-4fba-ac69-a7c8f257c570',
    '189-01-017',
    18,
    0.73,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    '8a093654-7d1c-4839-af61-646ee1b3da62',
    '89eb5987-2e92-4fba-ac69-a7c8f257c570',
    '189-01-018',
    18,
    0.81,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    '811c426a-d366-465a-91c8-64bb1bc5ab6d',
    '89eb5987-2e92-4fba-ac69-a7c8f257c570',
    '189-01-019',
    18,
    1.19,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    '3b85707a-f635-465f-afa2-2fa35a4ce26a',
    '89eb5987-2e92-4fba-ac69-a7c8f257c570',
    '189-01-020',
    18,
    1.08,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    'ebf0cdb0-cfd5-47fc-a745-7aac95999e89',
    '89eb5987-2e92-4fba-ac69-a7c8f257c570',
    '189-01-021',
    18,
    0.94,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    '6bc9e398-a186-4953-b431-8569d20f5cdb',
    '89eb5987-2e92-4fba-ac69-a7c8f257c570',
    '189-01-022',
    18,
    0.73,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    'f7ea6eae-f967-479e-b92e-daa645aae939',
    '89eb5987-2e92-4fba-ac69-a7c8f257c570',
    '189-01-023',
    18,
    0.81,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    '61796a71-5bac-4328-93fb-de4cf655c58d',
    '89eb5987-2e92-4fba-ac69-a7c8f257c570',
    '189-01-024',
    18,
    1.19,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    'dce05c13-6003-40ed-a9ac-06eec6927e1c',
    '89eb5987-2e92-4fba-ac69-a7c8f257c570',
    '189-01-025',
    18,
    1.94,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    '216f8185-3d2e-4d2a-866e-18fce3f4d453',
    '89eb5987-2e92-4fba-ac69-a7c8f257c570',
    '189-01-026',
    18,
    0.81,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    '23cc1b18-53c3-40f5-8d99-72512975b258',
    '89eb5987-2e92-4fba-ac69-a7c8f257c570',
    '189-01-027',
    18,
    0.73,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    '76ffe498-a187-4f23-8f48-77ebb783af62',
    '89eb5987-2e92-4fba-ac69-a7c8f257c570',
    '189-01-028',
    18,
    1.69,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    '6bfd4fe9-9711-40d3-a434-54491ba32267',
    '89eb5987-2e92-4fba-ac69-a7c8f257c570',
    '189-01-029',
    18,
    0.68,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    '51044772-43f5-43ff-9b05-1c130460bca7',
    '89eb5987-2e92-4fba-ac69-a7c8f257c570',
    '189-01-030',
    18,
    0.86,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    '6ff4ef00-3b80-4e77-9383-9ca254c909b8',
    '89eb5987-2e92-4fba-ac69-a7c8f257c570',
    '189-01-031',
    18,
    0.72,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    'c4a5eaf2-d915-464f-b8cf-af13ed530e23',
    '89eb5987-2e92-4fba-ac69-a7c8f257c570',
    '189-01-032',
    18,
    0.97,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    '3f90660d-d6f4-41fc-953c-225c5c6ced24',
    '89eb5987-2e92-4fba-ac69-a7c8f257c570',
    '189-01-033',
    18,
    0.72,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    '277ff2bd-ff51-4d31-beff-3174a25e42cf',
    '89eb5987-2e92-4fba-ac69-a7c8f257c570',
    '189-01-034',
    18,
    0.97,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    'ddb1b2b8-aeb9-4cab-ab63-8c69abbefa25',
    '89eb5987-2e92-4fba-ac69-a7c8f257c570',
    '189-01-035',
    18,
    0.72,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    'd391f464-56cf-4e57-9c90-0a2754dff98a',
    '89eb5987-2e92-4fba-ac69-a7c8f257c570',
    '189-01-036',
    18,
    0.97,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    '9694b9cb-6159-4a1e-8931-c64d73911b50',
    '89eb5987-2e92-4fba-ac69-a7c8f257c570',
    '189-01-037',
    18,
    0.72,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    'e1e20fd8-295e-4680-a978-d5ac2308f409',
    '89eb5987-2e92-4fba-ac69-a7c8f257c570',
    '189-01-038',
    18,
    0.97,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    'b9b9a7f9-256a-427f-b62d-314e7f7e3599',
    '89eb5987-2e92-4fba-ac69-a7c8f257c570',
    '189-01-039',
    18,
    0.68,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    '6ae585bd-f111-428c-8b8f-d32b3c7b553f',
    '89eb5987-2e92-4fba-ac69-a7c8f257c570',
    '189-01-040',
    18,
    0.91,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    '00c0b850-65df-4f28-8703-fce04e7adea3',
    '89eb5987-2e92-4fba-ac69-a7c8f257c570',
    '189-01-041',
    18,
    0.67,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    '43fa9673-1555-4fda-800b-c668dd054d72',
    '89eb5987-2e92-4fba-ac69-a7c8f257c570',
    '189-01-042',
    18,
    0.7,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    '20f0a87b-8b35-4076-b784-8df8f6f98d1f',
    '89eb5987-2e92-4fba-ac69-a7c8f257c570',
    '189-01-043',
    18,
    0.78,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    'fe7ab54a-d389-4982-9f87-aa646b12f610',
    '89eb5987-2e92-4fba-ac69-a7c8f257c570',
    '189-01-044',
    18,
    0.75,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    'd145ab5d-5f5c-44f2-979f-076146379ea3',
    '89eb5987-2e92-4fba-ac69-a7c8f257c570',
    '189-01-045',
    18,
    0.82,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    'e1701921-759a-4702-9e5a-3de60eb8a516',
    '89eb5987-2e92-4fba-ac69-a7c8f257c570',
    '189-01-046',
    18,
    0.79,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    'd056e9f6-43b8-48fc-8be6-f9134e03e934',
    '89eb5987-2e92-4fba-ac69-a7c8f257c570',
    '189-01-047',
    18,
    0.99,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    '27fa0efa-a284-488e-a26d-94cd696e5cce',
    '89eb5987-2e92-4fba-ac69-a7c8f257c570',
    '189-01-048',
    18,
    1.06,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    '000f2dd1-34db-4254-86ce-d01852dcad9b',
    '89eb5987-2e92-4fba-ac69-a7c8f257c570',
    '189-01-049',
    18,
    0.55,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    'dc5efb75-4901-47af-9851-d7b9de143922',
    '89eb5987-2e92-4fba-ac69-a7c8f257c570',
    '189-01-050',
    18,
    0.63,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    '73f2a1db-7cc0-4f1e-9bb5-f5cdbae796a7',
    '89eb5987-2e92-4fba-ac69-a7c8f257c570',
    '189-01-051',
    18,
    0.54,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    '1abeb69b-1161-4fba-99f2-dcb58925694a',
    '89eb5987-2e92-4fba-ac69-a7c8f257c570',
    '189-01-052',
    18,
    1.0,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    'bcdf6f66-207c-45cf-bac9-9cc4c41090af',
    '89eb5987-2e92-4fba-ac69-a7c8f257c570',
    '189-01-053',
    18,
    0.77,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    'e41c676d-78f3-4604-9353-c02b0efa0e09',
    '89eb5987-2e92-4fba-ac69-a7c8f257c570',
    '189-01-054',
    18,
    0.7,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    '88cd7973-94d3-4f2a-a762-498b2e78b2af',
    '89eb5987-2e92-4fba-ac69-a7c8f257c570',
    '189-01-055',
    18,
    0.78,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    'd942addd-8556-4f24-a321-cf8bd5178d50',
    '89eb5987-2e92-4fba-ac69-a7c8f257c570',
    '189-01-056',
    18,
    0.75,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    '9bbb9cdb-94c4-4a6f-935f-f507adbcb2e0',
    '89eb5987-2e92-4fba-ac69-a7c8f257c570',
    '189-01-057',
    18,
    0.82,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    '5c09fc38-0b7a-4883-88b0-b112bf91e3eb',
    '89eb5987-2e92-4fba-ac69-a7c8f257c570',
    '189-01-058',
    18,
    0.79,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    '2003edca-61d6-4c04-b4e7-8f57aed28aa2',
    '89eb5987-2e92-4fba-ac69-a7c8f257c570',
    '189-01-059',
    18,
    0.99,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    '7d86382b-25ed-4fd9-99b8-267cbc739d6b',
    '89eb5987-2e92-4fba-ac69-a7c8f257c570',
    '189-01-060',
    18,
    1.06,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    'eea688fd-e97c-425c-8bd3-df0b1e87c453',
    '89eb5987-2e92-4fba-ac69-a7c8f257c570',
    '189-01-061',
    18,
    0.55,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    '4c1f371d-cee7-45bd-bad5-babcdb415078',
    '89eb5987-2e92-4fba-ac69-a7c8f257c570',
    '189-01-062',
    18,
    0.63,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    '1eb47d17-d2e8-4f31-8a63-e874df8b4200',
    '89eb5987-2e92-4fba-ac69-a7c8f257c570',
    '189-01-063',
    18,
    0.54,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    '76fc51aa-46c6-448a-9299-dc20c5f7ad67',
    '89eb5987-2e92-4fba-ac69-a7c8f257c570',
    '189-01-064',
    18,
    1.0,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    'd5ed970f-0ed0-426d-852a-5add9e277cfc',
    '89eb5987-2e92-4fba-ac69-a7c8f257c570',
    '189-01-065',
    18,
    1.2,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    '0a95c1c2-94f8-4ec2-b7d1-0aafcdbad3d9',
    '89eb5987-2e92-4fba-ac69-a7c8f257c570',
    '189-01-066',
    18,
    1.26,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    '2888c5af-f95d-4189-bcc9-edb584b5746b',
    '89eb5987-2e92-4fba-ac69-a7c8f257c570',
    '189-01-067',
    18,
    1.26,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    '936cea1a-3403-4359-8417-7624a8e7b31a',
    '89eb5987-2e92-4fba-ac69-a7c8f257c570',
    '189-01-068',
    18,
    1.43,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    'a888a47f-6855-4aa0-aede-a4115fb9882a',
    '89eb5987-2e92-4fba-ac69-a7c8f257c570',
    '189-01-069',
    18,
    1.42,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    '7a301ad2-78c1-4494-b8f9-822f87e0c763',
    '89eb5987-2e92-4fba-ac69-a7c8f257c570',
    '189-01-070',
    18,
    1.42,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    'd6b6dd8b-d857-4c54-bdf9-2d340c36dc35',
    '89eb5987-2e92-4fba-ac69-a7c8f257c570',
    '189-01-071',
    18,
    1.42,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    '34a91f3c-ca98-42e2-a598-761c5888a3d7',
    '89eb5987-2e92-4fba-ac69-a7c8f257c570',
    '189-01-072',
    18,
    1.8,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    '3ade011d-6ec9-458a-93d1-cad8eb414dc3',
    '89eb5987-2e92-4fba-ac69-a7c8f257c570',
    '189-01-073',
    18,
    1.86,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    '3cb5e162-11b5-4918-806e-c9da47ba8296',
    '89eb5987-2e92-4fba-ac69-a7c8f257c570',
    '189-01-074',
    18,
    1.57,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    'c7ca8ae9-834b-40d9-9656-65578a2b2912',
    '89eb5987-2e92-4fba-ac69-a7c8f257c570',
    '189-01-075',
    18,
    1.58,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    'b1ad0e32-b5b2-4f29-866e-d2ec1fdc36fb',
    '89eb5987-2e92-4fba-ac69-a7c8f257c570',
    '189-01-076',
    18,
    1.38,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    '4bf31280-8440-4482-b81a-190dfd7ffca1',
    '89eb5987-2e92-4fba-ac69-a7c8f257c570',
    '189-01-077',
    18,
    0.55,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    '066fe447-4bcb-45d1-9208-aed6275f36c5',
    '89eb5987-2e92-4fba-ac69-a7c8f257c570',
    '189-01-078',
    18,
    0.99,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    '4f6a1310-0f2d-47b1-854d-c607d4c45b93',
    '89eb5987-2e92-4fba-ac69-a7c8f257c570',
    '189-01-079',
    18,
    0.82,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    'c7ab0cfb-0653-496c-b64c-f9412d61a529',
    '89eb5987-2e92-4fba-ac69-a7c8f257c570',
    '189-01-080',
    18,
    0.78,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    '1db3fcd4-732e-49f3-bdac-67d52002e157',
    '89eb5987-2e92-4fba-ac69-a7c8f257c570',
    '189-01-081',
    18,
    0.77,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    '9c165985-76da-46a4-a27c-b12a9dd3764b',
    '89eb5987-2e92-4fba-ac69-a7c8f257c570',
    '189-01-082',
    18,
    1.0,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    '38703010-7480-460e-a46b-7a3a8fb0e12f',
    '89eb5987-2e92-4fba-ac69-a7c8f257c570',
    '189-01-083',
    18,
    1.0,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    '98207454-9e99-439d-a950-70af3a3ba947',
    '89eb5987-2e92-4fba-ac69-a7c8f257c570',
    '189-01-084',
    18,
    1.0,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    '75c6aa94-809c-46d9-a306-bc7e61cc6b5d',
    '89eb5987-2e92-4fba-ac69-a7c8f257c570',
    '189-01-085',
    18,
    1.0,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    'bf22f8f9-ff08-435f-81c0-666bf5d498c6',
    '89eb5987-2e92-4fba-ac69-a7c8f257c570',
    '189-01-086',
    18,
    0.95,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    '1e7e86d1-fc35-46fe-8fd2-48943642e6cf',
    '89eb5987-2e92-4fba-ac69-a7c8f257c570',
    '189-01-087',
    18,
    0.95,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    'ca5d62e4-b9c0-4713-89dc-182378abdff9',
    '89eb5987-2e92-4fba-ac69-a7c8f257c570',
    '189-01-088',
    18,
    0.93,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    '44975277-38fb-415a-8a4a-f79839a271d3',
    '89eb5987-2e92-4fba-ac69-a7c8f257c570',
    '189-01-089',
    18,
    1.0,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    '9bdd1b01-0e8b-4ba7-8a45-2952e6f9918e',
    '89eb5987-2e92-4fba-ac69-a7c8f257c570',
    '189-01-090',
    18,
    1.22,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    '28ae58a1-a33b-4446-abbc-a73312390fbb',
    '89eb5987-2e92-4fba-ac69-a7c8f257c570',
    '189-01-091',
    18,
    1.67,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    '9ff89e0d-f946-49a9-ab07-a5490f4d0642',
    '89eb5987-2e92-4fba-ac69-a7c8f257c570',
    '189-01-092',
    18,
    1.35,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    'ab026929-afb4-404a-99a5-31ed74020654',
    '89eb5987-2e92-4fba-ac69-a7c8f257c570',
    '189-01-093',
    18,
    1.0,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    '521fd727-66d7-443c-8d4d-42916e419907',
    '89eb5987-2e92-4fba-ac69-a7c8f257c570',
    '189-01-094',
    18,
    1.0,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    '7f30b08f-8383-40f9-8409-926e26229d09',
    '89eb5987-2e92-4fba-ac69-a7c8f257c570',
    '189-01-095',
    18,
    1.0,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    '6271aa27-e524-4bdb-834e-6e564db0d64a',
    '89eb5987-2e92-4fba-ac69-a7c8f257c570',
    '189-01-096',
    18,
    1.07,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    '3694dd8c-7c25-41f2-8f25-79c72b744b76',
    '89eb5987-2e92-4fba-ac69-a7c8f257c570',
    '189-01-097',
    18,
    1.07,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    'fe768918-0fd7-4d15-b0d6-c8fad602a4f4',
    '89eb5987-2e92-4fba-ac69-a7c8f257c570',
    '189-01-098',
    18,
    1.09,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    '708e1c96-e646-425c-8177-ef293687cdcf',
    '89eb5987-2e92-4fba-ac69-a7c8f257c570',
    '189-01-099',
    18,
    1.09,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    '86536eeb-8f3a-4a3a-bd4c-17e11adfdcbd',
    '89eb5987-2e92-4fba-ac69-a7c8f257c570',
    '189-01-100',
    18,
    1.09,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    '5d09620a-a426-41d2-a716-c8cdefbb6f44',
    '89eb5987-2e92-4fba-ac69-a7c8f257c570',
    '189-01-101',
    18,
    1.09,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    '18555de3-ce47-4a2f-97d0-901558db6760',
    '89eb5987-2e92-4fba-ac69-a7c8f257c570',
    '189-01-102',
    18,
    1.09,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    'e79ba49e-575c-4d0f-83fd-7c9cad61c0eb',
    '89eb5987-2e92-4fba-ac69-a7c8f257c570',
    '189-01-103',
    18,
    NULL,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    '398b155b-bcdc-4ee4-9ca4-33bccf2c6be8',
    '89eb5987-2e92-4fba-ac69-a7c8f257c570',
    '189-01-104',
    18,
    NULL,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    'cb71b880-d058-47f4-8342-b6bcbcf2304e',
    '89eb5987-2e92-4fba-ac69-a7c8f257c570',
    '189-01-105',
    18,
    NULL,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    '680c169d-7616-4628-b505-09fc73e6d6f2',
    '89eb5987-2e92-4fba-ac69-a7c8f257c570',
    '189-01-106',
    18,
    NULL,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    '242e9e98-b859-4388-802a-e99c5ee733e9',
    '89eb5987-2e92-4fba-ac69-a7c8f257c570',
    '189-01-107',
    18,
    NULL,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    '3b0008cc-ffa0-4d3a-ab0d-ef4b2710304f',
    '89eb5987-2e92-4fba-ac69-a7c8f257c570',
    '189-01-108',
    18,
    NULL,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    '4d9aea7b-b303-4145-81fb-7440c4f82c0c',
    '89eb5987-2e92-4fba-ac69-a7c8f257c570',
    '189-01-109',
    18,
    NULL,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    '56c43e71-39a4-4d23-971d-2941c99e82e2',
    '89eb5987-2e92-4fba-ac69-a7c8f257c570',
    '189-01-110',
    18,
    NULL,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    '514e8a42-00ae-4a12-b4bd-b93e2464ef27',
    '89eb5987-2e92-4fba-ac69-a7c8f257c570',
    '189-01-111',
    18,
    NULL,
    'Flat'
) ON CONFLICT DO NOTHING;
INSERT INTO units (
    id, building_id, unit_number, floor_number,
    apportionment_percentage, unit_type
) VALUES (
    '0eff26de-bb0f-4409-bbae-b1a819fd1871',
    '89eb5987-2e92-4fba-ac69-a7c8f257c570',
    '189-01-112',
    18,
    NULL,
    'Flat'
) ON CONFLICT DO NOTHING;

-- Leaseholders (111)
INSERT INTO leaseholders (
    id, unit_id, full_name,
    correspondence_address, email, phone
) VALUES (
    'bc158f64-33bb-42df-8108-1b72457a8123',
    '40008c68-3255-45e8-8175-c7d55cc02366',
    'Mr & Mrs R Dunn',
    '16 Temple Fortue Lane, London, NW11 7UD',
    NULL,
    '0773 996 1484 Natasha'
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, full_name,
    correspondence_address, email, phone
) VALUES (
    'c171c011-48d4-4687-86ec-526ddb0cdf38',
    '16a621ee-26e8-47c3-ad1e-135f1b9c07a2',
    'Mr Chee Teng Wah & Anthony Chee King Hock',
    '116 Jalan Tun Tan Cheng Lock, 75200 Melaka, Malaysia',
    NULL,
    'AgencyPM@eu.jll.com'
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, full_name,
    correspondence_address, email, phone
) VALUES (
    '135e12a9-b725-4d2d-b094-2bf416990467',
    'aebb719f-9963-45f3-bb13-46285d6e11f9',
    'Bradshaw International Corp',
    'FAO Adrien Ng, Flat 3, 50 Kensington Garden Square, London, W2 4BA',
    NULL,
    '00852 281 26682'
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, full_name,
    correspondence_address, email, phone
) VALUES (
    '3fea585d-1a53-4e4d-a415-1654e432b255',
    '9b14c276-4166-4e7d-b5a5-f951d94265c6',
    'Mr Wee Tong Yeow',
    '41 Hume Avenue, Apartment 02-08, Symphony Heights, Singapore, 598738',
    NULL,
    NULL
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, full_name,
    correspondence_address, email, phone
) VALUES (
    'df7d7c19-247f-43c8-848d-158ae7473d4c',
    'a88a6efd-b812-42bd-912e-c405b2c69dea',
    'Bradshaw International Corp',
    'FAO Simon Kwok Wing Ng, Flat 5, 50 Kensington Garden Sq,, London, W2 4BA',
    NULL,
    '07412 871 701 HK+7'
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, full_name,
    correspondence_address, email, phone
) VALUES (
    'cd26a110-a763-4299-b44d-dd8e28b81750',
    '59c7c509-0dc7-453b-8daf-fb1f25b3a1fd',
    'Java Bridge Ltd',
    'c/o Excel Property Services Ltd, 146 Finchley Rd, London, NW3 5HS',
    NULL,
    '020 7691 9000'
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, full_name,
    correspondence_address, email, phone
) VALUES (
    'ef396ef1-86b0-4c6a-bfe8-6b730cf4344a',
    '1f5f3ce8-3923-4914-81a2-097814fde105',
    'Miss V Chan',
    'c/c Karrylee Kelly, Marsh & Parsons, 80 Hammersmith Road, London, W14 8UD',
    NULL,
    NULL
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, full_name,
    correspondence_address, email, phone
) VALUES (
    '7d2fba51-94d1-4fcb-bd1d-708114930f6b',
    'e6b04360-11a8-439b-a9b8-4ce99e4ed814',
    'Java Bridge Ltd',
    'Flat 8, 50 Kensington Garden Square, London, W2 4BA',
    NULL,
    '07925 356932'
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, full_name,
    correspondence_address, email, phone
) VALUES (
    '801a1754-342e-4589-8fa5-7463e1b5c7ae',
    '1692076b-948f-4fb0-ace2-26ccfa1eab03',
    'Fiona Jane Many Paulus',
    'Upper Maisonette,, 155 Gloucester avenue, London, NW1 8LA',
    NULL,
    '07802 830012 - PM'
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, full_name,
    correspondence_address, email, phone
) VALUES (
    '788b36c7-8e47-4ae7-962c-067ecee62584',
    '4c7c08c4-2d2c-40f5-baab-6f952bd982e4',
    'Mr C Tailor',
    'Flat 10, 50 Kensington Garden Square, London, W2 4BA',
    NULL,
    '0207 221 4357'
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, full_name,
    correspondence_address, email, phone
) VALUES (
    'e3b1c81f-e31c-408f-9398-bb6a9a868a71',
    '3c95d86a-d0a4-416c-a4e5-7a203f7c1527',
    'Mr & Mrs Leong',
    '27 Cashew Crescent, Singapore, 679772',
    NULL,
    '0065 6468 1851'
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, full_name,
    correspondence_address, email, phone
) VALUES (
    '225b74ab-ad0c-43ff-bbca-85ee98c06b1c',
    '926410f3-eda1-4471-bd94-e6dcd81c31ff',
    'Donatella Cuocci',
    '5 Rue Cambon, Paris, France, 75001',
    NULL,
    '+337771788352'
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, full_name,
    correspondence_address, email, phone
) VALUES (
    '198c6a16-c731-4ff7-ad55-4e62dc041138',
    '91bcd26a-1431-4e1b-b98f-68cd8b0b5d12',
    'Mr N B Haftel',
    '213 Kensington Church Street, London, W8 7LX',
    NULL,
    NULL
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, full_name,
    correspondence_address, email, phone
) VALUES (
    '5dd21ada-bb15-4b90-a2b8-f981235264e5',
    '76bb061f-5b82-47b5-8742-d49b1663a10f',
    'Mrs A Zheng & Mr F Li',
    '91 Belgrave Road, London, SW1V 2BQ',
    NULL,
    '07880 982 920'
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, full_name,
    correspondence_address, email, phone
) VALUES (
    '15528220-5437-4cb3-81f0-b17d6becd31b',
    '72dfaab1-e63c-4f1e-b922-097ead7b9d6b',
    'Kensington Garden Properties Limited',
    'Flat 16, 50 Kensington Garden Sq, London, W2, London, W2 4BA',
    NULL,
    NULL
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, full_name,
    correspondence_address, email, phone
) VALUES (
    '09e4f3d9-d41c-4f6c-92c1-02451276e7fe',
    'dd014531-a748-4cd2-8c02-4c570b54c06e',
    'Kensington Gardens Properties Limited',
    'Flat 17, 50 Kensington Garden Sq, London, W2, London, W2 4BA',
    NULL,
    NULL
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, full_name,
    correspondence_address, email, phone
) VALUES (
    '2fa99379-f780-4341-a484-7313c0007da1',
    '327630c1-823e-419e-ba5a-234207984799',
    'Ms S E Wong',
    'C/O Aisha Ahmed, 56 Sloane Square, London, SW1W 8AX',
    NULL,
    '+6012-3058840'
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, full_name,
    correspondence_address, email, phone
) VALUES (
    'a6fd451e-53a5-43a6-a901-c5eabaa349c9',
    '8a093654-7d1c-4839-af61-646ee1b3da62',
    'Charalampos Tymvios',
    'Flat 19, 50 Kensington Garden Square, London, W2 4BA',
    NULL,
    NULL
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, full_name,
    correspondence_address, email, phone
) VALUES (
    'f678b33e-d969-405f-a83b-c8a7fb370b67',
    '811c426a-d366-465a-91c8-64bb1bc5ab6d',
    'Ms S C Tan & Mr L C Chen',
    '12 Lorong Cinta Alam B, Country Heights, 43000 Kajang, Selangor, Malaysia',
    NULL,
    NULL
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, full_name,
    correspondence_address, email, phone
) VALUES (
    'fb6b0ea1-a4a4-4f38-9bbf-0985a24fd3d6',
    '3b85707a-f635-465f-afa2-2fa35a4ce26a',
    'Kensington Gardens Properties Limited',
    'Flat 21, 50 Kensington Garden Sq, London, W2, London, W2 4BA',
    NULL,
    NULL
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, full_name,
    correspondence_address, email, phone
) VALUES (
    'fdbcbce7-fe27-4de2-be9b-30c2d6de9f24',
    'ebf0cdb0-cfd5-47fc-a745-7aac95999e89',
    'Kensington Gardens Properties Limited',
    'Flat 22, 50 Kensington Garden Sq, London, W2, London, W2 4BA',
    NULL,
    NULL
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, full_name,
    correspondence_address, email, phone
) VALUES (
    '5e50072a-1bc8-485d-8367-09c466c7dc11',
    '6bc9e398-a186-4953-b431-8569d20f5cdb',
    'Bradshaw International Corp',
    'Simon Kwok Wing Ng, Flat 23, 50 Kensington Garden Sq, London, W2 4BA',
    NULL,
    NULL
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, full_name,
    correspondence_address, email, phone
) VALUES (
    '3875b46c-31bc-4305-8210-7b8ed34f8792',
    'f7ea6eae-f967-479e-b92e-daa645aae939',
    'Kensington Gardens Properties Limited',
    'Flat 24, 50 Kensington Garden Sq, London, W2, London, W2 4BA',
    NULL,
    NULL
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, full_name,
    correspondence_address, email, phone
) VALUES (
    '804bc9ad-c88e-41b1-ba2f-98c4558b3819',
    '61796a71-5bac-4328-93fb-de4cf655c58d',
    'Evangelia Ovale',
    '302 Blazer Court, St John’s Wood Road, London, NW8 7JY',
    NULL,
    NULL
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, full_name,
    correspondence_address, email, phone
) VALUES (
    'c89929f3-5638-441c-b06a-4ff05f541324',
    'dce05c13-6003-40ed-a9ac-06eec6927e1c',
    'Federal Government of United Arab Emirates',
    'Military Attaches Office, 6 Queens Gate Terrace, London, SW7 5PF',
    NULL,
    '020 7590 2379'
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, full_name,
    correspondence_address, email, phone
) VALUES (
    '6c8893cc-e30c-47df-982c-8f44dd50c62c',
    '216f8185-3d2e-4d2a-866e-18fce3f4d453',
    'Ms M Kokkinou',
    'Flat 27, 50 Kensington Garden Square, London, W2 4BA',
    NULL,
    NULL
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, full_name,
    correspondence_address, email, phone
) VALUES (
    'bba780bb-b810-4490-8383-940a6da10a09',
    '23cc1b18-53c3-40f5-8d99-72512975b258',
    'Lochan Investments Limited',
    'C/o Atlas Property Letting & Services Ltd, 51 The Grove, Ealing, London, W5 5DX',
    NULL,
    '020 7124 4046'
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, full_name,
    correspondence_address, email, phone
) VALUES (
    '68c831f9-062c-4818-b7bc-85c6c64e9d55',
    '76ffe498-a187-4f23-8f48-77ebb783af62',
    'Ace Alliance Associates Inc',
    '1 Raffles Place, 39-01 One Raffles Place, Singapore, 048616',
    NULL,
    NULL
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, full_name,
    correspondence_address, email, phone
) VALUES (
    '0809886a-1cae-4546-8ea9-1bd3dd5057c2',
    '6bfd4fe9-9711-40d3-a434-54491ba32267',
    'Mrs O Gonzalez',
    'Flat 30, 50 Kensington Garden Sq, London, W2 4BA',
    NULL,
    '+1 305 873 4483'
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, full_name,
    correspondence_address, email, phone
) VALUES (
    '25aed9f3-f3e3-4fbf-be0a-8ff7b947b86b',
    '51044772-43f5-43ff-9b05-1c130460bca7',
    'Abimbola Omotanwa Ayinde',
    'Flat 31, 50 Kensington Garden Sq, London, W2 4BA',
    NULL,
    NULL
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, full_name,
    correspondence_address, email, phone
) VALUES (
    'f863fbf1-d930-41db-87d6-8332db307cc2',
    '6ff4ef00-3b80-4e77-9383-9ca254c909b8',
    'Miss L McBride',
    '4 Bridstow Place, London, W2 5AE',
    NULL,
    NULL
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, full_name,
    correspondence_address, email, phone
) VALUES (
    '60710d73-7c32-4f20-a0fc-03f714ce0b53',
    'c4a5eaf2-d915-464f-b8cf-af13ed530e23',
    'Achille Del Pizzo & Elena Sophie Fabritius',
    'Flat 33, 50 Kensington Garden Sq, London, W2 4BA',
    NULL,
    NULL
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, full_name,
    correspondence_address, email, phone
) VALUES (
    'd11834d4-9fd1-4157-8cd8-2b910d82f26d',
    '3f90660d-d6f4-41fc-953c-225c5c6ced24',
    'The Executors of the Late Mr Leandro Delgado',
    'Maria Helena Vidal Delgado, C/O Vanessa Delgado, 2 Goshawk Rise, Hengoed, CF82 6BG',
    NULL,
    '0035 1213 872419'
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, full_name,
    correspondence_address, email, phone
) VALUES (
    '1f2e0367-d1ec-45a5-a98c-24c132e4d45c',
    '277ff2bd-ff51-4d31-beff-3174a25e42cf',
    'See Yoon Chin & Moi Eng Chea',
    '276 Lorong Maarof, Bukit Bandaraya, 59100 Kuala Lumpur, Malaysia',
    NULL,
    '+6012 - 287 3638'
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, full_name,
    correspondence_address, email, phone
) VALUES (
    'fa8a1404-0815-4985-b3df-9bd32d1ebf06',
    'ddb1b2b8-aeb9-4cab-ab63-8c69abbefa25',
    'Mr M Grigolin',
    'Flat 36, 50 Kensington Gardens Square, London, W2 4BA',
    NULL,
    '+39 335 6399125'
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, full_name,
    correspondence_address, email, phone
) VALUES (
    'bfaeb2d9-a82e-4bcb-8f29-4b1c9c94d867',
    'd391f464-56cf-4e57-9c90-0a2754dff98a',
    'Mr A Zverev',
    'Flat 37, 50 Kensington Garden Square, London, W2 4BA',
    NULL,
    '07802 510 662'
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, full_name,
    correspondence_address, email, phone
) VALUES (
    'c64b120a-178e-41ae-9afb-61a2d0aa4f45',
    '9694b9cb-6159-4a1e-8931-c64d73911b50',
    'Mr R Morley',
    'Flat 38, 50 Kensington Garden Square, London, W2 4BA',
    NULL,
    NULL
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, full_name,
    correspondence_address, email, phone
) VALUES (
    '28487dfa-b9a6-4c61-93eb-91b631406d9c',
    'e1e20fd8-295e-4680-a978-d5ac2308f409',
    'Mr DC Tsui',
    'Flat 39, 50 Kensington Garden Sq, London, W2 4BA',
    NULL,
    '852 2711 5500'
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, full_name,
    correspondence_address, email, phone
) VALUES (
    '42dcdec2-1c28-43bf-910d-4f72e97deb10',
    'b9b9a7f9-256a-427f-b62d-314e7f7e3599',
    'Mr Y Sovgyra',
    'Flat 40, 50 Kensington Garden Square, London, W2 4BA',
    NULL,
    '07983 014966'
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, full_name,
    correspondence_address, email, phone
) VALUES (
    '63590add-f622-4246-860a-03fa9f095e18',
    '6ae585bd-f111-428c-8b8f-d32b3c7b553f',
    'Jayson Wang & Siew Teng Ng',
    '5 Tenniel Close, London, W2 3LE',
    NULL,
    '020 7221 3215'
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, full_name,
    correspondence_address, email, phone
) VALUES (
    '3acb2687-9035-4bff-99a4-5afa439d6084',
    '00c0b850-65df-4f28-8703-fce04e7adea3',
    'Deepside Ltd',
    '8 St Georges Street, Douglas, Isle of Man, IM1 1AH',
    NULL,
    '01624 665 100'
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, full_name,
    correspondence_address, email, phone
) VALUES (
    'e0c778a2-36b8-4df1-aa2b-9ed7a3df1f1d',
    '43fa9673-1555-4fda-800b-c668dd054d72',
    'Bharat Bhundia',
    'Flat 43, 50 Kensington Garden Square, London, W2 4BA',
    NULL,
    '07768 906812'
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, full_name,
    correspondence_address, email, phone
) VALUES (
    '197a07b4-20f5-4195-8057-c856a448b029',
    '20f0a87b-8b35-4076-b784-8df8f6f98d1f',
    'Mr Faraz Alnur Ramji',
    'Flat 5, 22 St Pancras Chambers, Euston Road, London, Nw1 2AR',
    NULL,
    NULL
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, full_name,
    correspondence_address, email, phone
) VALUES (
    'e9eaa44a-58f2-4844-8fe9-5033028b1bef',
    'fe7ab54a-d389-4982-9f87-aa646b12f610',
    'Mrs V B Parker',
    '21 The Tramshed, Beehive Yard, Bath, BA1 5BB',
    NULL,
    '01225 462290'
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, full_name,
    correspondence_address, email, phone
) VALUES (
    '841c6eee-d002-4616-baa4-c8d332de820b',
    'd145ab5d-5f5c-44f2-979f-076146379ea3',
    'Mr I McDonough',
    '3 Foster Road, London, W4 4NY',
    NULL,
    '07920 703 055 Ian'
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, full_name,
    correspondence_address, email, phone
) VALUES (
    '7a1c830e-b2d7-48dd-9679-67b398232a82',
    'e1701921-759a-4702-9e5a-3de60eb8a516',
    'Petros Alexandros Koumpas',
    'Flat 47, 50 Kensington Garden Sq, London, W2 4BA',
    NULL,
    NULL
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, full_name,
    correspondence_address, email, phone
) VALUES (
    '2df5e387-c86e-47ab-af75-07db31f9cc79',
    'd056e9f6-43b8-48fc-8be6-f9134e03e934',
    'Ms M Asaria',
    'Elysee, 25-26 Craven Terrace,, London, W2 3EL',
    NULL,
    '07740 107 005'
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, full_name,
    correspondence_address, email, phone
) VALUES (
    'f2ea6d3b-e413-45fc-aaf2-1ed9a301d0e5',
    '27fa0efa-a284-488e-a26d-94cd696e5cce',
    'Tan Siew Chin & Chen Lee Chew',
    '12 Lorong Cinta Alam B,, Country Heights, 43000 Kajang, Selangor, Malaysia',
    NULL,
    NULL
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, full_name,
    correspondence_address, email, phone
) VALUES (
    'f66e6534-9282-4777-a269-db33dee971dd',
    '000f2dd1-34db-4254-86ce-d01852dcad9b',
    'Ms M Asaria',
    'Elysee, 25-26 Craven Terrace, London, W2 3EL',
    NULL,
    '07740 107 005'
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, full_name,
    correspondence_address, email, phone
) VALUES (
    'a699ef13-b504-41cd-8174-8cb59da01f84',
    'dc5efb75-4901-47af-9851-d7b9de143922',
    'Mr & Mrs L de Freitas',
    '11 Ickenham Road, Ruislip, Middlesex, HA4 7BT',
    NULL,
    '01895 638 689'
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, full_name,
    correspondence_address, email, phone
) VALUES (
    '7f35bcb3-708a-4b2d-9a7c-bb35bfbb1263',
    '73f2a1db-7cc0-4f1e-9bb5-f5cdbae796a7',
    'MedMon Limited',
    'Flat 6, Cranleigh Court, 4-5 Leinster Gardens, London, W2 6DP',
    NULL,
    NULL
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, full_name,
    correspondence_address, email, phone
) VALUES (
    'a02733cc-37d3-40cc-9868-4408b7d6b0d0',
    '1abeb69b-1161-4fba-99f2-dcb58925694a',
    'Tan Chee Yi lilian & Lee Wai Ching',
    '21 Brookfield Avenue, London, W5 1LA',
    NULL,
    NULL
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, full_name,
    correspondence_address, email, phone
) VALUES (
    'fd9f492b-1086-4896-a28e-232f1354074f',
    'bcdf6f66-207c-45cf-bac9-9cc4c41090af',
    'Mr P M Weil, Mr F A Lehmann & Ms L J Lehmann',
    'Flat 40, West Heath Place, 1B Hodford Road, London, NW11 8NL',
    NULL,
    '07774 868 626 Freddy'
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, full_name,
    correspondence_address, email, phone
) VALUES (
    '91baac42-c54e-411d-ac6d-c3a474519545',
    'e41c676d-78f3-4604-9353-c02b0efa0e09',
    'Mr Peter Weil & Mr Freddy Lehmann',
    'Flat 40, West Heath Place, 1B Hodford Road, London, NW11 8NL',
    NULL,
    '07774 868 626'
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, full_name,
    correspondence_address, email, phone
) VALUES (
    '7425610c-3613-49fe-970f-b21b3d4cefa6',
    '88cd7973-94d3-4f2a-a762-498b2e78b2af',
    'Mr EJ Reed',
    'Flat 56, 50 Kensington Garden Square, London, W2 4BA',
    NULL,
    NULL
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, full_name,
    correspondence_address, email, phone
) VALUES (
    '73e0a978-965f-4f62-bdb1-db9fd789a135',
    'd942addd-8556-4f24-a321-cf8bd5178d50',
    'Karim Vellani',
    'Flat 57, 50 Kensington Garden Sq, London, W2, London, W2 4BA',
    NULL,
    NULL
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, full_name,
    correspondence_address, email, phone
) VALUES (
    '7ba62820-a443-4578-ba94-73a2b8c4ca69',
    '9bbb9cdb-94c4-4a6f-935f-f507adbcb2e0',
    'Kensington Gardens Properties Limited',
    'Flat 58, 50 Kensington Garden Sq, London, W2, London, W2 4BA',
    NULL,
    NULL
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, full_name,
    correspondence_address, email, phone
) VALUES (
    '7c15d2fb-df9f-4734-8c0a-431d7e1a18d8',
    '5c09fc38-0b7a-4883-88b0-b112bf91e3eb',
    'Ms I P Spyrou',
    'PO Box 25520, 1310, Nicosia, Cyprus',
    NULL,
    '+357 99352444'
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, full_name,
    correspondence_address, email, phone
) VALUES (
    'bfa14517-1242-4da6-b00c-97d1054f5af2',
    '2003edca-61d6-4c04-b4e7-8f57aed28aa2',
    'Gwee K Gwee & Goei KG',
    'C/O Wisteria, The Grange Barn, Pikes End, Pinner, Middlesex, HA5 2EX',
    NULL,
    '+44 20 7861 5528 Agt'
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, full_name,
    correspondence_address, email, phone
) VALUES (
    'e79e922c-cd77-43d8-a4a7-53bb22d580a1',
    '7d86382b-25ed-4fd9-99b8-267cbc739d6b',
    'Ms E Green',
    'Flat 61, 50 Kensington Garden Square, London, W2 4BA',
    NULL,
    NULL
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, full_name,
    correspondence_address, email, phone
) VALUES (
    'ce881f58-3948-4697-8f38-0054bf74ce3b',
    'eea688fd-e97c-425c-8bd3-df0b1e87c453',
    'Ms Moussavou',
    '48 Chiltern Court, Baker Street, London, NW1 5SP',
    NULL,
    '+352 621 458 236'
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, full_name,
    correspondence_address, email, phone
) VALUES (
    'd054ed8c-26d3-4ffd-9676-e68fcb4aa52a',
    '4c1f371d-cee7-45bd-bad5-babcdb415078',
    'Mr & Mrs A Sahu',
    '10 Stoke Hill, Stoke Bishop, Bristol, BS9 1JH',
    NULL,
    '0117 968 5105'
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, full_name,
    correspondence_address, email, phone
) VALUES (
    '98dff307-70bc-4f0f-911e-1fb46a289dda',
    '1eb47d17-d2e8-4f31-8a63-e874df8b4200',
    'Madam Tan Y H & Mr Wong Chig Meng',
    'C/O Knight Frank, 55 Baker Street, London, W1U 8AN',
    NULL,
    '+44 7814 215 190'
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, full_name,
    correspondence_address, email, phone
) VALUES (
    '2cc7e054-f396-4081-975e-506bfb17fb9a',
    '76fc51aa-46c6-448a-9299-dc20c5f7ad67',
    'Mrs L Lehmann, Mr F Lehmann & Mr P Weil',
    'Flat 40, West Heath Place, 1B Hodford Road, London, NW11 8NL',
    NULL,
    '07774 868 626 Freddy'
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, full_name,
    correspondence_address, email, phone
) VALUES (
    '8320896f-c7b5-499f-b795-db305f6cda41',
    'd5ed970f-0ed0-426d-852a-5add9e277cfc',
    'Mark Valenzia & Elias Lambrianios-Sabeh',
    'Flat 66, 50 Kensington Garden Sq, London, W2 4BA',
    NULL,
    NULL
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, full_name,
    correspondence_address, email, phone
) VALUES (
    '2d3d0321-7f3b-439b-ae49-dbe7d42c0f71',
    '0a95c1c2-94f8-4ec2-b7d1-0aafcdbad3d9',
    'Ms Joanne Hole',
    '5908 141 Street NW, Edmonton, Alberta, Canada, T6H 4A5',
    NULL,
    NULL
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, full_name,
    correspondence_address, email, phone
) VALUES (
    '38653afe-1479-42b4-b2e1-3ec95a6d3a96',
    '2888c5af-f95d-4189-bcc9-edb584b5746b',
    'Mr P Weil',
    'Flat 68, 50 Kensington Garden Sq, London, W2 4BA',
    NULL,
    NULL
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, full_name,
    correspondence_address, email, phone
) VALUES (
    '45a7a5e5-5c2a-48e7-9e62-28f58761b69a',
    '936cea1a-3403-4359-8417-7624a8e7b31a',
    'Mr S Abletshauser',
    'Flat 69, 50 Kensington Garden Square, London, W2 4BA',
    NULL,
    NULL
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, full_name,
    correspondence_address, email, phone
) VALUES (
    'fcdf01d7-9aac-4bce-a965-207c0c904a6c',
    'a888a47f-6855-4aa0-aede-a4115fb9882a',
    'Ms Paola De Leo',
    'Flat 70, 50 Kensington Garden Square, London, W2 4BA',
    NULL,
    NULL
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, full_name,
    correspondence_address, email, phone
) VALUES (
    '27aedd41-bdbf-4e27-8046-8faf96a5dd04',
    '7a301ad2-78c1-4494-b8f9-822f87e0c763',
    'Dr J Perez',
    'Flat 71, 50 Kensington Garden Square, London, W2 4BA',
    NULL,
    NULL
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, full_name,
    correspondence_address, email, phone
) VALUES (
    '26281e77-41d2-4d2f-8dd4-8ab84d19ecb9',
    'd6b6dd8b-d857-4c54-bdf9-2d340c36dc35',
    'Dario Dias Cavalheiro & Anika Arya Cavalherio',
    'Flat 72, 50 Kensington Garden Sq, London, W2 4BA',
    NULL,
    '07379133760'
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, full_name,
    correspondence_address, email, phone
) VALUES (
    '7fab8b65-0286-4111-b26a-993fbc2a2719',
    '34a91f3c-ca98-42e2-a598-761c5888a3d7',
    'Walter Cegarra & Nathalie Taube',
    'Flat 73, 50 Kensington garden Square, London, W2 4UA',
    NULL,
    '0207 985 0620'
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, full_name,
    correspondence_address, email, phone
) VALUES (
    '7551fd41-e6b0-44f6-937f-250595c48b9a',
    '3ade011d-6ec9-458a-93d1-cad8eb414dc3',
    'Mr E Barnes',
    'Flat 74, 50 Kensington Gardens Square, London, W2 4BA',
    NULL,
    '01608 677768'
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, full_name,
    correspondence_address, email, phone
) VALUES (
    'aaf48214-d2cb-4713-917a-a9f551e7d8b4',
    '3cb5e162-11b5-4918-806e-c9da47ba8296',
    'Mr & Mrs C Simon',
    'Flat 75, 50 Kensington Garden Square, London, W2 4BA',
    NULL,
    '020 7221 4745'
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, full_name,
    correspondence_address, email, phone
) VALUES (
    '9b95a848-d659-430f-bf00-64d039e85ef5',
    'c7ca8ae9-834b-40d9-9656-65578a2b2912',
    'Mr Vinay Jayaram',
    'Flat 76, 50 Kensington Garden Square, London, W2 4BA',
    NULL,
    NULL
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, full_name,
    correspondence_address, email, phone
) VALUES (
    '9e39af48-4820-4dce-b75f-c6dc94a5182c',
    'b1ad0e32-b5b2-4f29-866e-d2ec1fdc36fb',
    'Ms P Maleh',
    'Flat 77, 50 Kensington Gardens Square, London, W2 4BA',
    NULL,
    NULL
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, full_name,
    correspondence_address, email, phone
) VALUES (
    'e871d781-abee-473f-99f1-e774daaab518',
    '4bf31280-8440-4482-b81a-190dfd7ffca1',
    'Nuver Estates Ltd',
    'Rodion Panayi (Nuver Estates Ltd), P.Box 56965, 3311 Limassol, Cyprus',
    NULL,
    'none'
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, full_name,
    correspondence_address, email, phone
) VALUES (
    '2ea172a7-5c74-47b1-a0ca-45be643b95e2',
    '066fe447-4bcb-45d1-9208-aed6275f36c5',
    'Natasha Chrishausen Inc',
    'C/O Fraser & Co, Unit 12, West End Quay, 1 South Wharf Road, Paddington, London, W2 1JB',
    NULL,
    NULL
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, full_name,
    correspondence_address, email, phone
) VALUES (
    'accb8767-db33-40e3-b48e-b82ee7788b4f',
    '4f6a1310-0f2d-47b1-854d-c607d4c45b93',
    'SNR Property Limited',
    'Kubie Gold Associates Ltd, 36 Ivor Place, Regents Park, London, NW1 6EA',
    NULL,
    NULL
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, full_name,
    correspondence_address, email, phone
) VALUES (
    'b4968f00-0386-4060-8fca-66293bf521b5',
    'c7ab0cfb-0653-496c-b64c-f9412d61a529',
    'SNR Property Limited',
    'Kubie Gold Associates Ltd, 36 Ivor Place, Regents Park, London, NW1 6EA',
    NULL,
    '07774 860 755 (mark)'
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, full_name,
    correspondence_address, email, phone
) VALUES (
    '0cf792f7-1a8f-49f3-b518-66a08ab8f781',
    '1db3fcd4-732e-49f3-bdac-67d52002e157',
    'Mr P M Weil & Mr F A & Ms L J Lehmann',
    'Flat 40, West Heath Place, 1B Hodford Road, London, NW11 8NL',
    NULL,
    '07774 868 626 Freddy'
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, full_name,
    correspondence_address, email, phone
) VALUES (
    '338c4b96-ac8d-4d5b-90c5-f676bbd75832',
    '9c165985-76da-46a4-a27c-b12a9dd3764b',
    'Mr A I Boyne & Ms M A Boyne',
    'Apt 1.3 Compass House, 50 Kensington Gardens Square, Bayswater, London, W2 4AZ',
    NULL,
    NULL
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, full_name,
    correspondence_address, email, phone
) VALUES (
    'd2236070-a269-4652-ad6b-61a7a4aa46a0',
    '38703010-7480-460e-a46b-7a3a8fb0e12f',
    'Octavia Lucy Fleur Wyatt',
    'Mews Hse 84, 50 Kensington Gdn Sq, London, W2 4BA',
    NULL,
    '07768171545 (Lorren D'
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, full_name,
    correspondence_address, email, phone
) VALUES (
    '3495cd96-b6ba-47e6-8a63-e7e00a5f6c91',
    '98207454-9e99-439d-a950-70af3a3ba947',
    'Khadijeh Rafi Haeri',
    'Flat 17, Saxon Hall, 16 Palace Court, London, W2 4JA',
    NULL,
    '020 7229 6335'
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, full_name,
    correspondence_address, email, phone
) VALUES (
    '93be611d-c1fa-41fe-ae06-9f5e8c90d89b',
    '75c6aa94-809c-46d9-a306-bc7e61cc6b5d',
    'Meredith Estates Ltd',
    'c/o Regent Cofid Limited, 37 - 38 Long Acre, London, WC2E 9JT',
    NULL,
    '0203 2140442'
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, full_name,
    correspondence_address, email, phone
) VALUES (
    '4d079d26-4ab1-4ab3-b172-a6f98f4396e1',
    'bf22f8f9-ff08-435f-81c0-666bf5d498c6',
    'Kathryn Estelle Williams',
    'Mews Hse 87, 50 Kensington Gdn Sq, London, W2 4BA',
    NULL,
    NULL
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, full_name,
    correspondence_address, email, phone
) VALUES (
    '7ccfcfac-c226-40ab-8083-b3c368b27473',
    '1e7e86d1-fc35-46fe-8fd2-48943642e6cf',
    'Chi Yan Kwan & Joseph Kwan',
    '88 Mews House, 50 Kensington Garden Square, London, W2 4BA',
    NULL,
    '07375313676'
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, full_name,
    correspondence_address, email, phone
) VALUES (
    '43b7318f-bdb2-4029-9d6b-fbd7d1ddbf35',
    'ca5d62e4-b9c0-4713-89dc-182378abdff9',
    'Mrs Dipti Singh',
    'Dipti Singh, C/O Minnie Frangiamore, 107 Victor Road, Kensal Green, London, NW10 5XB',
    NULL,
    NULL
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, full_name,
    correspondence_address, email, phone
) VALUES (
    'd7d5d74f-88d2-46f3-834b-29aedd9c0878',
    '44975277-38fb-415a-8a4a-f79839a271d3',
    'Tan Puay Chuan Annie',
    'Bismac Consultants Pte Ltd, 24 Fernhill Crescent, Singapore, 259178',
    NULL,
    '+65 97866923'
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, full_name,
    correspondence_address, email, phone
) VALUES (
    '98db72e5-8d5e-47eb-ad3f-c598f0f562f6',
    '9bdd1b01-0e8b-4ba7-8a45-2952e6f9918e',
    'Ms C A O''Driscoll',
    'Mews House No 91, 50 Kensington Garden Square, London, W2 4BA',
    NULL,
    '020 7727 7059'
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, full_name,
    correspondence_address, email, phone
) VALUES (
    'e854c624-9710-4142-8605-d1d9c1a2f07a',
    '28ae58a1-a33b-4446-abbc-a73312390fbb',
    'Fausto Limited',
    'c/o Eduardo Bertao, 1 Thomas Place, London, W8 5UG',
    NULL,
    NULL
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, full_name,
    correspondence_address, email, phone
) VALUES (
    '07747f55-fd3b-424e-89f4-cb427d73bc8f',
    '9ff89e0d-f946-49a9-ab07-a5490f4d0642',
    'Mr F O R Nashashibi & Mrs M Nashashibi',
    'Mews Hse 93, 50 kensington Garden Square, London, W2 4BA',
    NULL,
    '07877 44 12 31 Reza'
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, full_name,
    correspondence_address, email, phone
) VALUES (
    '8ecb7568-0b78-461b-aa13-e251048def35',
    'ab026929-afb4-404a-99a5-31ed74020654',
    'Ms I Cosar',
    'Mews House No 94, 50 Kensington Garden Square, London, W2 4BA',
    NULL,
    '020 7727 4179'
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, full_name,
    correspondence_address, email, phone
) VALUES (
    '48d8e5df-3dcb-4a18-bdca-0da786d0b053',
    '521fd727-66d7-443c-8d4d-42916e419907',
    'Fergus Alexander Dixon & Georgia Karargyri',
    'Mews House 95, 50 Kensington Garden Square, London, W2 4BA',
    NULL,
    '07960 169252'
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, full_name,
    correspondence_address, email, phone
) VALUES (
    '841a8775-d953-4be4-ac6d-8980f30e25fd',
    '7f30b08f-8383-40f9-8409-926e26229d09',
    'Mr & Mrs K Teasdale',
    'Mews House No 96, 50 Kensington Garden Square, London, W2 4BA',
    NULL,
    '01235 528 299'
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, full_name,
    correspondence_address, email, phone
) VALUES (
    '75e707a6-290d-4439-8034-90d9a81bbd59',
    '6271aa27-e524-4bdb-834e-6e564db0d64a',
    'Mr C L H Clark',
    'Mews House 97, 50 Kensington Garden Square, London, W2 4BA',
    NULL,
    NULL
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, full_name,
    correspondence_address, email, phone
) VALUES (
    'f2bae7da-05c4-4d30-afdc-7677f63efaa5',
    '3694dd8c-7c25-41f2-8f25-79c72b744b76',
    'Aditi Ravi Kumar',
    '6 Hill Road, London, NW8 9QS',
    NULL,
    NULL
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, full_name,
    correspondence_address, email, phone
) VALUES (
    'ebb0ed1d-ef3a-42e7-a1a2-8ae9a641c9b6',
    'fe768918-0fd7-4d15-b0d6-c8fad602a4f4',
    'Mr R Jong',
    '3 Langside Avenue, London, SW15 5QT',
    NULL,
    '07788 416 195'
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, full_name,
    correspondence_address, email, phone
) VALUES (
    '043d5d0d-b2b1-4f17-8fc3-1b492a4d0eaa',
    '708e1c96-e646-425c-8177-ef293687cdcf',
    'Mr & Mrs K Wildie',
    'Flat 100, 50 Kensington Gardens Square, London, W24BA',
    NULL,
    '020 7243 3377'
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, full_name,
    correspondence_address, email, phone
) VALUES (
    '2d3b94b6-6e6c-4a14-b6a7-3c1a63c02476',
    '86536eeb-8f3a-4a3a-bd4c-17e11adfdcbd',
    'Raptakos, Brett U.K Limited',
    'Third Floor, 126-134 Baker Street, London, W1U 6UE',
    NULL,
    NULL
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, full_name,
    correspondence_address, email, phone
) VALUES (
    'c0e5dfd0-e2ce-420a-ad93-51806020c338',
    '5d09620a-a426-41d2-a716-c8cdefbb6f44',
    'Raptakos, Brett U.K. Limited',
    'c/o Butler & Co LLP, Third Floor, 126-164 Baker Street, London, W1U 6UE',
    NULL,
    '020 7243 5260'
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, full_name,
    correspondence_address, email, phone
) VALUES (
    'b08771a1-f0f6-4c82-9a85-c66f45a98959',
    '18555de3-ce47-4a2f-97d0-901558db6760',
    'Raptakos, Brett U.K. Limited',
    'c/o Butler & Co LLP, Third Floor, 126-164 Baker Street, London, W1U 6UE',
    NULL,
    '020 3195 1632'
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, full_name,
    correspondence_address, email, phone
) VALUES (
    '43f7d8ff-1b17-4d94-82b4-2696bfb89e17',
    'e79ba49e-575c-4d0f-83fd-7c9cad61c0eb',
    'UK Insurance Limited',
    'c/o CBRE Limited, Pacific House (Accounts Payable), 70 Wellington Street, Glasgow, G2 6UA',
    NULL,
    NULL
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, full_name,
    correspondence_address, email, phone
) VALUES (
    '96b3f8de-8ff4-4a82-895f-54638f0c2012',
    '398b155b-bcdc-4ee4-9ca4-33bccf2c6be8',
    'UK Insurance Limited',
    'c/o CBRE Limited, Pacific House (Accounts Payable), 70 Wellington Street, Glasgow, G2 6UA',
    NULL,
    NULL
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, full_name,
    correspondence_address, email, phone
) VALUES (
    '2da7bd87-9b76-4e82-b695-9a21e656a10c',
    'cb71b880-d058-47f4-8342-b6bcbcf2304e',
    'UK Insurance Limited',
    'c/o CBRE Limited, Pacific House (Accounts Payable), 70 Wellington Street, Glasgow, G2 6UA',
    NULL,
    NULL
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, full_name,
    correspondence_address, email, phone
) VALUES (
    '8e9f1559-bc11-4d9f-bda1-3ae35fcf9373',
    '680c169d-7616-4628-b505-09fc73e6d6f2',
    'UK Insurance Limited',
    'c/o CBRE Limited, Pacific House (Accounts Payable), 70 Wellington Street, Glasgow, G2 6UA',
    NULL,
    NULL
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, full_name,
    correspondence_address, email, phone
) VALUES (
    'fd19d042-23e1-4803-83cd-a3f8369ff4bb',
    '242e9e98-b859-4388-802a-e99c5ee733e9',
    'UK Insurance Limited',
    'c/o CBRE Limited, Pacific House (Accounts Payable), 70 Wellington Street, Glasgow, G2 6UA',
    NULL,
    NULL
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, full_name,
    correspondence_address, email, phone
) VALUES (
    '3cb12039-649f-4d13-86b6-5e66d96340ab',
    '3b0008cc-ffa0-4d3a-ab0d-ef4b2710304f',
    'UK Insurance Limited',
    'c/o CBRE Limited, Pacific House (Accounts Payable), 70 Wellington Street, Glasgow, G2 6UA',
    NULL,
    NULL
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, full_name,
    correspondence_address, email, phone
) VALUES (
    'de76ad35-9770-44b5-bb4c-928e88c3ace8',
    '4d9aea7b-b303-4145-81fb-7440c4f82c0c',
    'Redan Place Management Company Ltd',
    '50 Kensington Gardens Square, London, W2 4AZ',
    NULL,
    NULL
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, full_name,
    correspondence_address, email, phone
) VALUES (
    '7409d285-145d-4528-bbc3-443606a633e0',
    '56c43e71-39a4-4d23-971d-2941c99e82e2',
    'Redan Place',
    'Mr S Dear, Hillside House, Petworth Road, Haslemere, Surrey, GU27 2HZ',
    NULL,
    '01428 645721'
) ON CONFLICT DO NOTHING;
INSERT INTO leaseholders (
    id, unit_id, full_name,
    correspondence_address, email, phone
) VALUES (
    'fedb4d3f-262c-4faa-b1d6-6389221a550a',
    '514e8a42-00ae-4a12-b4bd-b93e2464ef27',
    'UK Insurance Limited',
    'c/o CBRE Limited, Pacific House (Accounts Payable), 70 Wellington Street, Glasgow, G2 6UA',
    NULL,
    NULL
) ON CONFLICT DO NOTHING;

-- Compliance Assets (6)
INSERT INTO compliance_assets (
    id, building_id, asset_name, asset_type,
    last_inspection_date, next_due_date,
    compliance_status, assessor_company
) VALUES (
    '128b9f29-c373-4c7e-ae5d-97094f702f58',
    '89eb5987-2e92-4fba-ac69-a7c8f257c570',
    'Lift LOLER Inspection',
    'lift_loler',
    '2023-11-21',
    '2024-05-21',
    'Pass',
    NULL
);
INSERT INTO compliance_assets (
    id, building_id, asset_name, asset_type,
    last_inspection_date, next_due_date,
    compliance_status, assessor_company
) VALUES (
    '16a39d93-a307-4ba3-976a-eb472eff26ae',
    '89eb5987-2e92-4fba-ac69-a7c8f257c570',
    'Fire Risk Assessment',
    'fire_risk_assessment',
    '2025-03-18',
    '2026-03-18',
    'Pass',
    NULL
);
INSERT INTO compliance_assets (
    id, building_id, asset_name, asset_type,
    last_inspection_date, next_due_date,
    compliance_status, assessor_company
) VALUES (
    '701ca213-1152-4e19-b4a6-ff53b346a12e',
    '89eb5987-2e92-4fba-ac69-a7c8f257c570',
    'Legionella Risk Assessment',
    'legionella',
    '2025-09-22',
    '2027-09-22',
    'Unknown',
    NULL
);
INSERT INTO compliance_assets (
    id, building_id, asset_name, asset_type,
    last_inspection_date, next_due_date,
    compliance_status, assessor_company
) VALUES (
    '8b8e887d-19fe-4b0e-aa43-d06202757faa',
    '89eb5987-2e92-4fba-ac69-a7c8f257c570',
    'Fire Door Inspection',
    'fire_door_inspection',
    NULL,
    '2026-09-02',
    'Pass',
    NULL
);
INSERT INTO compliance_assets (
    id, building_id, asset_name, asset_type,
    last_inspection_date, next_due_date,
    compliance_status, assessor_company
) VALUES (
    '78939e0a-82f5-44a6-a341-52769de5af97',
    '89eb5987-2e92-4fba-ac69-a7c8f257c570',
    'EICR',
    'eicr',
    '2021-11-05',
    '2026-11-05',
    'Pass',
    NULL
);
INSERT INTO compliance_assets (
    id, building_id, asset_name, asset_type,
    last_inspection_date, next_due_date,
    compliance_status, assessor_company
) VALUES (
    'aa05d347-62c2-418b-ac64-f9af4e17527f',
    '89eb5987-2e92-4fba-ac69-a7c8f257c570',
    'Emergency Lighting Test',
    'emergency_lighting',
    NULL,
    NULL,
    'Pass',
    NULL
);

-- Maintenance Contracts (27)
INSERT INTO maintenance_contracts (
    id, building_id, contractor_name, service_type,
    start_date, end_date, annual_cost
) VALUES (
    '77ff4400-56e6-4aa8-8cdf-e24d12f8c126',
    '89eb5987-2e92-4fba-ac69-a7c8f257c570',
    'has given notice that the rate of VAT chargeable on the
supply of goods and services',
    'gardening',
    NULL,
    NULL,
    NULL
);
INSERT INTO maintenance_contracts (
    id, building_id, contractor_name, service_type,
    start_date, end_date, annual_cost
) VALUES (
    '2a48f547-e3f9-4d25-915f-13b7a5ccbd94',
    '89eb5987-2e92-4fba-ac69-a7c8f257c570',
    'has given notice that the rate of VAT chargeable on the
supply of goods and services',
    'gardening',
    NULL,
    NULL,
    NULL
);
INSERT INTO maintenance_contracts (
    id, building_id, contractor_name, service_type,
    start_date, end_date, annual_cost
) VALUES (
    '5561c358-6096-4e84-80f1-e34b2bb5c734',
    '89eb5987-2e92-4fba-ac69-a7c8f257c570',
    'has given notice that the rate of VAT chargeable on the
supply of goods and services',
    'gardening',
    NULL,
    NULL,
    NULL
);
INSERT INTO maintenance_contracts (
    id, building_id, contractor_name, service_type,
    start_date, end_date, annual_cost
) VALUES (
    '27c79ac3-0b0f-4fbc-94a0-e42414b63911',
    '89eb5987-2e92-4fba-ac69-a7c8f257c570',
    'has given notice that the rate of VAT chargeable on the
supply of goods and services',
    'gardening',
    NULL,
    NULL,
    NULL
);
INSERT INTO maintenance_contracts (
    id, building_id, contractor_name, service_type,
    start_date, end_date, annual_cost
) VALUES (
    '6c0cd93b-f76c-41b0-b5a3-50776e6ea3aa',
    '89eb5987-2e92-4fba-ac69-a7c8f257c570',
    'has given notice that the rate of VAT chargeable on the
supply of goods and services',
    'gardening',
    NULL,
    NULL,
    NULL
);
INSERT INTO maintenance_contracts (
    id, building_id, contractor_name, service_type,
    start_date, end_date, annual_cost
) VALUES (
    '715c0e58-42ab-4c93-9891-35da15359a71',
    '89eb5987-2e92-4fba-ac69-a7c8f257c570',
    'has given notice that the rate of VAT chargeable on the
supply of goods and services',
    'gardening',
    NULL,
    NULL,
    NULL
);
INSERT INTO maintenance_contracts (
    id, building_id, contractor_name, service_type,
    start_date, end_date, annual_cost
) VALUES (
    '113a3af0-2f65-4e4a-b067-320b3b922880',
    '89eb5987-2e92-4fba-ac69-a7c8f257c570',
    'MIH Property Management Ltd',
    'gardening',
    NULL,
    NULL,
    NULL
);
INSERT INTO maintenance_contracts (
    id, building_id, contractor_name, service_type,
    start_date, end_date, annual_cost
) VALUES (
    'f6a2291f-3e71-4e49-b88a-d5dc93021ac4',
    '89eb5987-2e92-4fba-ac69-a7c8f257c570',
    's and each contractor engaged to provide services',
    'gardening',
    NULL,
    NULL,
    NULL
);
INSERT INTO maintenance_contracts (
    id, building_id, contractor_name, service_type,
    start_date, end_date, annual_cost
) VALUES (
    '62680d42-9ded-4498-9eb9-eb610f173673',
    '89eb5987-2e92-4fba-ac69-a7c8f257c570',
    's and each contractor engaged to provide services',
    'gardening',
    NULL,
    NULL,
    NULL
);
INSERT INTO maintenance_contracts (
    id, building_id, contractor_name, service_type,
    start_date, end_date, annual_cost
) VALUES (
    '05db677e-ecf1-41c1-8f35-c999dbf8a0c3',
    '89eb5987-2e92-4fba-ac69-a7c8f257c570',
    's and each contractor engaged to provide services',
    'gardening',
    NULL,
    NULL,
    NULL
);
INSERT INTO maintenance_contracts (
    id, building_id, contractor_name, service_type,
    start_date, end_date, annual_cost
) VALUES (
    '30a7416a-b5c4-430d-ac50-1db7eab8e196',
    '89eb5987-2e92-4fba-ac69-a7c8f257c570',
    's and each 
contractor engaged to provide services',
    'cleaning',
    NULL,
    NULL,
    NULL
);
INSERT INTO maintenance_contracts (
    id, building_id, contractor_name, service_type,
    start_date, end_date, annual_cost
) VALUES (
    'c35631f5-1f15-4f94-8db0-6cb3addc15c3',
    '89eb5987-2e92-4fba-ac69-a7c8f257c570',
    's and each contractor engaged to provide services',
    'gardening',
    NULL,
    NULL,
    NULL
);
INSERT INTO maintenance_contracts (
    id, building_id, contractor_name, service_type,
    start_date, end_date, annual_cost
) VALUES (
    'b40bf519-eb32-4b61-945a-0f0bb4382b05',
    '89eb5987-2e92-4fba-ac69-a7c8f257c570',
    'Number is
The Company is limited',
    'gardening',
    NULL,
    NULL,
    NULL
);
INSERT INTO maintenance_contracts (
    id, building_id, contractor_name, service_type,
    start_date, end_date, annual_cost
) VALUES (
    '015d61b9-cabf-4e68-aa8c-09f694611ecd',
    '89eb5987-2e92-4fba-ac69-a7c8f257c570',
    'is limited',
    'gardening',
    NULL,
    NULL,
    NULL
);
INSERT INTO maintenance_contracts (
    id, building_id, contractor_name, service_type,
    start_date, end_date, annual_cost
) VALUES (
    '2587b378-9e4e-4079-9cdf-af6e56866a12',
    '89eb5987-2e92-4fba-ac69-a7c8f257c570',
    'will provide to the Customer payroll services',
    'gardening',
    NULL,
    NULL,
    NULL
);
INSERT INTO maintenance_contracts (
    id, building_id, contractor_name, service_type,
    start_date, end_date, annual_cost
) VALUES (
    '3de847e9-6959-4b6e-a537-e3c9949677a6',
    '89eb5987-2e92-4fba-ac69-a7c8f257c570',
    'cannot be delegated and Zurich Insurance Group Ltd',
    'gardening',
    NULL,
    NULL,
    NULL
);
INSERT INTO maintenance_contracts (
    id, building_id, contractor_name, service_type,
    start_date, end_date, annual_cost
) VALUES (
    'df099fe2-0930-4b44-978e-567cbf1e7ab8',
    '89eb5987-2e92-4fba-ac69-a7c8f257c570',
    'cannot be delegated and Zurich Insurance Group Ltd',
    'gardening',
    NULL,
    NULL,
    NULL
);
INSERT INTO maintenance_contracts (
    id, building_id, contractor_name, service_type,
    start_date, end_date, annual_cost
) VALUES (
    '29e55eca-3cc6-43f8-8d83-35a3bc9e4496',
    '89eb5987-2e92-4fba-ac69-a7c8f257c570',
    'w ill provide the services',
    'gardening',
    NULL,
    NULL,
    NULL
);
INSERT INTO maintenance_contracts (
    id, building_id, contractor_name, service_type,
    start_date, end_date, annual_cost
) VALUES (
    '8833031c-4c95-4edd-90e1-926e7d700e12',
    '89eb5987-2e92-4fba-ac69-a7c8f257c570',
    'to prevent rodent 

Discreet Pest Control Limited',
    'gardening',
    NULL,
    NULL,
    NULL
);
INSERT INTO maintenance_contracts (
    id, building_id, contractor_name, service_type,
    start_date, end_date, annual_cost
) VALUES (
    '1713a02a-8147-4e5a-9a1f-a0e809e1af89',
    '89eb5987-2e92-4fba-ac69-a7c8f257c570',
    'PTSG Electrical Services Ltd',
    'gardening',
    NULL,
    NULL,
    NULL
);
INSERT INTO maintenance_contracts (
    id, building_id, contractor_name, service_type,
    start_date, end_date, annual_cost
) VALUES (
    '75bf0e80-3d37-46f5-8524-cad16054fe2e',
    '89eb5987-2e92-4fba-ac69-a7c8f257c570',
    's must NOT be used without the prior consent of MIH Property Management  Ltd',
    'gardening',
    NULL,
    NULL,
    NULL
);
INSERT INTO maintenance_contracts (
    id, building_id, contractor_name, service_type,
    start_date, end_date, annual_cost
) VALUES (
    'd057698a-f586-42b2-8b51-a69196a6cf94',
    '89eb5987-2e92-4fba-ac69-a7c8f257c570',
    's must NOT be used without the prior consent of MIH Property Management  Ltd',
    'gardening',
    NULL,
    NULL,
    NULL
);
INSERT INTO maintenance_contracts (
    id, building_id, contractor_name, service_type,
    start_date, end_date, annual_cost
) VALUES (
    '0a436751-9beb-40b8-85ce-2f999353a8d5',
    '89eb5987-2e92-4fba-ac69-a7c8f257c570',
    's must NOT be used without the prior consent of MIH Property Management  Ltd',
    'gardening',
    NULL,
    NULL,
    NULL
);
INSERT INTO maintenance_contracts (
    id, building_id, contractor_name, service_type,
    start_date, end_date, annual_cost
) VALUES (
    '8a172754-f6b5-407f-9c2f-2700a36ba7bc',
    '89eb5987-2e92-4fba-ac69-a7c8f257c570',
    'has given notice that the rate of VAT chargeable on the
supply of goods and services',
    'gardening',
    NULL,
    NULL,
    NULL
);
INSERT INTO maintenance_contracts (
    id, building_id, contractor_name, service_type,
    start_date, end_date, annual_cost
) VALUES (
    'c5019331-209d-4c23-9aa9-cdc71cd55d55',
    '89eb5987-2e92-4fba-ac69-a7c8f257c570',
    'has given notice that the rate of VAT chargeable on the
supply of goods and services',
    'gardening',
    NULL,
    NULL,
    NULL
);
INSERT INTO maintenance_contracts (
    id, building_id, contractor_name, service_type,
    start_date, end_date, annual_cost
) VALUES (
    '446180e0-4ce9-4e72-bd23-edaead4b90e5',
    '89eb5987-2e92-4fba-ac69-a7c8f257c570',
    'has given notice that the rate of VAT chargeable on the
supply of goods and services',
    'gardening',
    NULL,
    NULL,
    NULL
);
INSERT INTO maintenance_contracts (
    id, building_id, contractor_name, service_type,
    start_date, end_date, annual_cost
) VALUES (
    '6a7d828a-0c99-431f-886d-34409a965510',
    '89eb5987-2e92-4fba-ac69-a7c8f257c570',
    'has given notice that the rate of VAT chargeable on the
supply of goods and services',
    'gardening',
    NULL,
    NULL,
    NULL
);

-- Service Charge Accounts (1)
INSERT INTO service_charge_accounts (
    id, building_id, financial_year, year_end_date,
    approval_date, is_approved, total_expenditure
) VALUES (
    '3f7eed3c-3557-4275-a211-6ea71ce71265',
    '89eb5987-2e92-4fba-ac69-a7c8f257c570',
    '2031',
    'YEAR ENDED 31 DECEMBER  2015',
    NULL,
    FALSE,
    NULL
);

-- Leases (1)
INSERT INTO leases (
    id, building_id, title_number, term_years, ground_rent
) VALUES (
    'f2a9745f-ff19-4df8-9e79-dbc1c564e173',
    '89eb5987-2e92-4fba-ac69-a7c8f257c570',
    NULL,
    NULL,
    NULL
);

-- Contractors (3)
INSERT INTO contractors (
    id, building_id, company_name, services_json,
    annual_value, is_active
) VALUES (
    'b10b4a35-3c57-417f-a4c0-3ed2c58d3422',
    '89eb5987-2e92-4fba-ac69-a7c8f257c570',
    'MIH Property Management Ltd',
    '["gardening"]',
    0,
    TRUE
);
INSERT INTO contractors (
    id, building_id, company_name, services_json,
    annual_value, is_active
) VALUES (
    'b8b67af9-e0cc-4b91-bc2d-4a19c9491f3e',
    '89eb5987-2e92-4fba-ac69-a7c8f257c570',
    'Number is
The Company is limited',
    '["gardening"]',
    0,
    TRUE
);
INSERT INTO contractors (
    id, building_id, company_name, services_json,
    annual_value, is_active
) VALUES (
    'f2e244f6-337b-4ee1-8c01-4651f93f6389',
    '89eb5987-2e92-4fba-ac69-a7c8f257c570',
    'PTSG Electrical Services Ltd',
    '["gardening"]',
    0,
    TRUE
);
