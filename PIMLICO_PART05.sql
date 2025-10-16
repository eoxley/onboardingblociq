BEGIN;

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
    'and residential accommodation;

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

INSERT INTO budgets (id, building_id, budget_year, total_budget, status) 
VALUES ('48644340-b3c0-428a-9ed2-0cfc30cbaee4', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', 2024, 0, 'draft') ON CONFLICT (id) DO NOTHING;

INSERT INTO budgets (id, building_id, budget_year, total_budget, status) 
VALUES ('328531b8-0223-4c37-8859-235ffd2a3e91', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', 2024, 0, 'draft') ON CONFLICT (id) DO NOTHING;

INSERT INTO budgets (id, building_id, budget_year, total_budget, status) 
VALUES ('ab381e84-c7b1-45cc-8d92-3e8069933db1', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', 2024, 0, 'draft') ON CONFLICT (id) DO NOTHING;

INSERT INTO budgets (id, building_id, budget_year, total_budget, status) 
VALUES ('4eba2c36-6583-44fc-bacb-da106032f943', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', 2024, 0, 'draft') ON CONFLICT (id) DO NOTHING;

INSERT INTO budgets (id, building_id, budget_year, total_budget, status) 
VALUES ('d64292fa-3218-4ebd-ba90-55d4cd9119d1', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', 2024, 0, 'draft') ON CONFLICT (id) DO NOTHING;

INSERT INTO budgets (id, building_id, budget_year, total_budget, status) 
VALUES ('2bb1b832-0c70-4e31-8153-b252110babec', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', 2024, 0, 'draft') ON CONFLICT (id) DO NOTHING;

INSERT INTO budgets (id, building_id, budget_year, total_budget, status) 
VALUES ('14a0bd59-d564-4648-abea-13c95158cf7e', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', 2024, 0, 'draft') ON CONFLICT (id) DO NOTHING;

INSERT INTO budgets (id, building_id, budget_year, total_budget, status) 
VALUES ('f54c33d4-24c1-46db-a51a-d25607553f33', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', 2024, 0, 'draft') ON CONFLICT (id) DO NOTHING;

INSERT INTO budgets (id, building_id, budget_year, total_budget, status) 
VALUES ('bfe50d14-9637-4cb7-bb3d-fd9e114a4eed', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', 2024, 0, 'draft') ON CONFLICT (id) DO NOTHING;

INSERT INTO budgets (id, building_id, budget_year, total_budget, status) 
VALUES ('7ebcab2c-b703-4c86-9570-dab0f03b09ed', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', 2024, 0, 'draft') ON CONFLICT (id) DO NOTHING;

INSERT INTO budgets (id, building_id, budget_year, total_budget, status) 
VALUES ('f19af977-4f6b-4d57-81fd-4c60a0c99a07', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', 2024, 0, 'draft') ON CONFLICT (id) DO NOTHING;

INSERT INTO budgets (id, building_id, budget_year, total_budget, status) 
VALUES ('76ac2d00-7295-4df0-9c9f-b80a8d334d29', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', 2024, 0, 'draft') ON CONFLICT (id) DO NOTHING;

INSERT INTO budgets (id, building_id, budget_year, total_budget, status) 
VALUES ('936a81fe-c67c-408b-b4c4-afe9fd1dabb9', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', 2024, 0, 'draft') ON CONFLICT (id) DO NOTHING;

INSERT INTO budgets (id, building_id, budget_year, total_budget, status) 
VALUES ('a9cef3b7-bca4-4775-baec-fe4ba7220589', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', 2024, 0, 'draft') ON CONFLICT (id) DO NOTHING;

INSERT INTO budgets (id, building_id, budget_year, total_budget, status) 
VALUES ('477df829-5564-42fb-830f-335f29400aa9', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', 2024, 0, 'draft') ON CONFLICT (id) DO NOTHING;

INSERT INTO budgets (id, building_id, budget_year, total_budget, status) 
VALUES ('218f45e0-df5f-44f5-ad52-b03fd35ea4ec', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', 2024, 0, 'draft') ON CONFLICT (id) DO NOTHING;

INSERT INTO budgets (id, building_id, budget_year, total_budget, status) 
VALUES ('267ffb7b-ee58-4524-90d3-82e3dba218a5', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', 2024, 0, 'draft') ON CONFLICT (id) DO NOTHING;

INSERT INTO budgets (id, building_id, budget_year, total_budget, status) 
VALUES ('149acd60-1321-4707-82bb-7694006ca024', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', 2024, 0, 'draft') ON CONFLICT (id) DO NOTHING;

INSERT INTO budgets (id, building_id, budget_year, total_budget, status) 
VALUES ('24a2a4c7-4f9b-46eb-bebe-409b003ae7b9', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', 2024, 0, 'draft') ON CONFLICT (id) DO NOTHING;

INSERT INTO budgets (id, building_id, budget_year, total_budget, status) 
VALUES ('f88d90da-9a98-4162-86c4-eaa79d3689fb', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', 2024, 0, 'draft') ON CONFLICT (id) DO NOTHING;

INSERT INTO budgets (id, building_id, budget_year, total_budget, status) 
VALUES ('c6750e2b-5e33-45b3-8174-13758464a3db', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', 2024, 0, 'draft') ON CONFLICT (id) DO NOTHING;

INSERT INTO budgets (id, building_id, budget_year, total_budget, status) 
VALUES ('4b776c5c-df58-4efd-9fda-07a689c606f5', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', 2024, 0, 'draft') ON CONFLICT (id) DO NOTHING;

INSERT INTO budgets (id, building_id, budget_year, total_budget, status) 
VALUES ('b326324e-31c1-4ea7-a208-806c96ad61fa', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', 2024, 0, 'draft') ON CONFLICT (id) DO NOTHING;

INSERT INTO budgets (id, building_id, budget_year, total_budget, status) 
VALUES ('bded0ba7-50a3-4a81-b3cd-2737039dadd9', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', 2024, 0, 'draft') ON CONFLICT (id) DO NOTHING;

INSERT INTO budgets (id, building_id, budget_year, total_budget, status) 
VALUES ('96184bc1-f874-4523-9d87-d25aa22dac4e', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', 2024, 0, 'draft') ON CONFLICT (id) DO NOTHING;

INSERT INTO budgets (id, building_id, budget_year, total_budget, status) 
VALUES ('94e59820-80d1-4d03-a358-56e3e692d9bf', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', 2024, 0, 'draft') ON CONFLICT (id) DO NOTHING;

INSERT INTO budgets (id, building_id, budget_year, total_budget, status) 
VALUES ('6b6cb19a-4e91-4d71-897a-08e15d72ac14', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', 2024, 0, 'draft') ON CONFLICT (id) DO NOTHING;

INSERT INTO budgets (id, building_id, budget_year, total_budget, status) 
VALUES ('9b6ad12c-de77-4632-8257-631a96d3bbef', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', 2024, 0, 'draft') ON CONFLICT (id) DO NOTHING;

INSERT INTO budgets (id, building_id, budget_year, total_budget, status) 
VALUES ('a559091f-9a29-4838-b490-7dffd3e7c5c6', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', 2024, 0, 'draft') ON CONFLICT (id) DO NOTHING;

INSERT INTO budgets (id, building_id, budget_year, total_budget, status) 
VALUES ('380fbf85-142d-4e8b-886b-c3808751666b', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', 2024, 0, 'draft') ON CONFLICT (id) DO NOTHING;

INSERT INTO budgets (id, building_id, budget_year, total_budget, status) 
VALUES ('3e5850d3-2722-465d-a977-9541c26da6e0', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', 2024, 0, 'draft') ON CONFLICT (id) DO NOTHING;

INSERT INTO budgets (id, building_id, budget_year, total_budget, status) 
VALUES ('802c90c1-4093-4c1d-8fa3-080d021e89ef', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', 2024, 0, 'draft') ON CONFLICT (id) DO NOTHING;

INSERT INTO budgets (id, building_id, budget_year, total_budget, status) 
VALUES ('07220bee-b769-4689-afc1-b65d778684b6', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', 2024, 0, 'draft') ON CONFLICT (id) DO NOTHING;

INSERT INTO budgets (id, building_id, budget_year, total_budget, status) 
VALUES ('9617b587-d16c-47ac-81d8-150f09ad0dc2', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', 2024, 0, 'draft') ON CONFLICT (id) DO NOTHING;

INSERT INTO budgets (id, building_id, budget_year, total_budget, status) 
VALUES ('8ea1e38e-59ea-426d-94c2-f6c5f9c0c8db', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', 2024, 0, 'draft') ON CONFLICT (id) DO NOTHING;

INSERT INTO budgets (id, building_id, budget_year, total_budget, status) 
VALUES ('80500bb6-aea9-4d75-8b75-7160c6ed16c7', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', 2024, 0, 'draft') ON CONFLICT (id) DO NOTHING;

INSERT INTO budgets (id, building_id, budget_year, total_budget, status) 
VALUES ('91f326bd-1a67-4cc8-be67-4861ceede972', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', 2024, 0, 'draft') ON CONFLICT (id) DO NOTHING;

INSERT INTO budgets (id, building_id, budget_year, total_budget, status) 
VALUES ('417477a0-8e9a-4b0c-9d6d-b0664c4ed313', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', 2024, 0, 'draft') ON CONFLICT (id) DO NOTHING;

INSERT INTO budgets (id, building_id, budget_year, total_budget, status) 
VALUES ('642701e0-650c-40da-b6bc-475c185312a3', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', 2024, 0, 'draft') ON CONFLICT (id) DO NOTHING;

INSERT INTO budgets (id, building_id, budget_year, total_budget, status) 
VALUES ('864fd0d9-893e-49e4-8483-253638ef003f', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', 2024, 0, 'draft') ON CONFLICT (id) DO NOTHING;

INSERT INTO budgets (id, building_id, budget_year, total_budget, status) 
VALUES ('15a1f751-a146-428c-a276-3b3b3a99beef', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', 2024, 0, 'draft') ON CONFLICT (id) DO NOTHING;

INSERT INTO budgets (id, building_id, budget_year, total_budget, status) 
VALUES ('126edfdc-5f05-43c5-a99d-7e936d5973c7', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', 2024, 0, 'draft') ON CONFLICT (id) DO NOTHING;

INSERT INTO budgets (id, building_id, budget_year, total_budget, status) 
VALUES ('0e7f187c-7661-481b-bd3e-55e303750cb8', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', 2024, 0, 'draft') ON CONFLICT (id) DO NOTHING;

INSERT INTO budgets (id, building_id, budget_year, total_budget, status) 
VALUES ('391b6462-512c-4915-b37a-7c51463decde', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', 2024, 0, 'draft') ON CONFLICT (id) DO NOTHING;

INSERT INTO budgets (id, building_id, budget_year, total_budget, status) 
VALUES ('8915356e-ba42-4e90-8812-7848cf28e669', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', 2024, 0, 'draft') ON CONFLICT (id) DO NOTHING;

INSERT INTO budgets (id, building_id, budget_year, total_budget, status) 
VALUES ('31954276-bb81-4dc3-9255-564ca2d93735', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', 2024, 0, 'draft') ON CONFLICT (id) DO NOTHING;

INSERT INTO budgets (id, building_id, budget_year, total_budget, status) 
VALUES ('3bd9d799-0d96-4a7d-9e22-54b54d36aabc', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', 2024, 0, 'draft') ON CONFLICT (id) DO NOTHING;

INSERT INTO budgets (id, building_id, budget_year, total_budget, status) 
VALUES ('a0664c14-ca29-47a3-b120-85dca2c55cd5', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', 2024, 0, 'draft') ON CONFLICT (id) DO NOTHING;

INSERT INTO budgets (id, building_id, budget_year, total_budget, status) 
VALUES ('5835f74f-3ac3-4f41-9d3b-e23b68835c7e', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', 2024, 0, 'draft') ON CONFLICT (id) DO NOTHING;

INSERT INTO budgets (id, building_id, budget_year, total_budget, status) 
VALUES ('5e280c86-0349-4482-9b83-f8adb7cfdb3f', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', 2024, 0, 'draft') ON CONFLICT (id) DO NOTHING;

INSERT INTO budgets (id, building_id, budget_year, total_budget, status) 
VALUES ('d3efd4b2-2375-4e79-94b8-6dbddfb6881e', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', 2024, 0, 'draft') ON CONFLICT (id) DO NOTHING;

INSERT INTO budgets (id, building_id, budget_year, total_budget, status) 
VALUES ('93f30d9f-b304-4d06-a8ca-1097f9a91a3f', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', 2024, 0, 'draft') ON CONFLICT (id) DO NOTHING;

INSERT INTO budgets (id, building_id, budget_year, total_budget, status) 
VALUES ('82df1f2c-ac6a-47c2-b971-466bfb4663f2', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', 2024, 0, 'draft') ON CONFLICT (id) DO NOTHING;

INSERT INTO budgets (id, building_id, budget_year, total_budget, status) 
VALUES ('dee56b2b-fae6-4ed1-b917-dbf130870f6c', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', 2024, 0, 'draft') ON CONFLICT (id) DO NOTHING;

INSERT INTO budgets (id, building_id, budget_year, total_budget, status) 
VALUES ('5a224399-4bec-420f-aef5-8978e65f25ea', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', 2024, 0, 'draft') ON CONFLICT (id) DO NOTHING;

INSERT INTO budgets (id, building_id, budget_year, total_budget, status) 
VALUES ('eb39d946-ee39-4a7d-9ffd-e892ea50cce3', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', 2024, 0, 'draft') ON CONFLICT (id) DO NOTHING;

INSERT INTO budgets (id, building_id, budget_year, total_budget, status) 
VALUES ('48e8e323-cba0-40b4-aa2e-d3604d46a7be', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', 2024, 0, 'draft') ON CONFLICT (id) DO NOTHING;

INSERT INTO budgets (id, building_id, budget_year, total_budget, status) 
VALUES ('e8f874df-4321-44dd-b3aa-466d9b410352', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', 2024, 0, 'draft') ON CONFLICT (id) DO NOTHING;

INSERT INTO budgets (id, building_id, budget_year, total_budget, status) 
VALUES ('972a268b-b7a0-4d79-abed-b43daff74626', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', 2024, 0, 'draft') ON CONFLICT (id) DO NOTHING;

INSERT INTO budgets (id, building_id, budget_year, total_budget, status) 
VALUES ('6deefb90-58c2-4b1c-b3ef-159338ab9c74', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', 2024, 0, 'draft') ON CONFLICT (id) DO NOTHING;

INSERT INTO budgets (id, building_id, budget_year, total_budget, status) 
VALUES ('03b2e203-3b25-4b47-a8d8-28e7dc807e22', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', 2024, 0, 'draft') ON CONFLICT (id) DO NOTHING;

INSERT INTO budgets (id, building_id, budget_year, total_budget, status) 
VALUES ('f7ee2140-e23e-4ac0-b559-9f30e52fed6a', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', 2024, 0, 'draft') ON CONFLICT (id) DO NOTHING;

INSERT INTO budgets (id, building_id, budget_year, total_budget, status) 
VALUES ('d2ca62ae-0853-443f-ae80-69b9e868eb04', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', 2024, 0, 'draft') ON CONFLICT (id) DO NOTHING;

INSERT INTO budgets (id, building_id, budget_year, total_budget, status) 
VALUES ('fbc88af4-94d4-48bd-b590-1d45b22b5872', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', 2024, 0, 'draft') ON CONFLICT (id) DO NOTHING;

INSERT INTO budgets (id, building_id, budget_year, total_budget, status) 
VALUES ('931fb9f0-4cff-4f61-a337-0aeb56d578ff', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', 2024, 0, 'draft') ON CONFLICT (id) DO NOTHING;

INSERT INTO budgets (id, building_id, budget_year, total_budget, status) 
VALUES ('d7f7fc5f-da85-4784-af36-301090ec28cf', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', 2024, 0, 'draft') ON CONFLICT (id) DO NOTHING;

INSERT INTO budgets (id, building_id, budget_year, total_budget, status) 
VALUES ('5df96b24-b896-4afd-8e14-62fccfc4e0b8', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', 2024, 0, 'draft') ON CONFLICT (id) DO NOTHING;

INSERT INTO budgets (id, building_id, budget_year, total_budget, status) 
VALUES ('6a853233-5cad-4722-a95d-be52fc48818c', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', 2024, 0, 'draft') ON CONFLICT (id) DO NOTHING;

INSERT INTO budgets (id, building_id, budget_year, total_budget, status) 
VALUES ('322aef5e-0199-4d7e-8460-f97bd9e2006c', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', 2024, 0, 'draft') ON CONFLICT (id) DO NOTHING;

INSERT INTO budgets (id, building_id, budget_year, total_budget, status) 
VALUES ('49060206-a75d-4599-9f06-8ed6a9a3772d', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', 2024, 0, 'draft') ON CONFLICT (id) DO NOTHING;

INSERT INTO budgets (id, building_id, budget_year, total_budget, status) 
VALUES ('42f2ea96-bbba-450d-bc5e-3a1850b24150', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', 2024, 0, 'draft') ON CONFLICT (id) DO NOTHING;

INSERT INTO budgets (id, building_id, budget_year, total_budget, status) 
VALUES ('6cf43546-d6e7-4a89-a8f1-28ef4e6e777f', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', 2024, 0, 'draft') ON CONFLICT (id) DO NOTHING;

INSERT INTO budgets (id, building_id, budget_year, total_budget, status) 
VALUES ('4873bd82-1309-47c2-bea6-c35da2f6a847', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', 2024, 0, 'draft') ON CONFLICT (id) DO NOTHING;

INSERT INTO budgets (id, building_id, budget_year, total_budget, status) 
VALUES ('8e085c88-cdcc-4bc2-a934-09992dcfbc9d', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', 2024, 0, 'draft') ON CONFLICT (id) DO NOTHING;

INSERT INTO budgets (id, building_id, budget_year, total_budget, status) 
VALUES ('1edba608-cc25-4313-8d44-501f815c925a', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', 2024, 0, 'draft') ON CONFLICT (id) DO NOTHING;

INSERT INTO budgets (id, building_id, budget_year, total_budget, status) 
VALUES ('0b1978e0-772f-4288-a0b9-875b3b81c81a', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', 2024, 0, 'draft') ON CONFLICT (id) DO NOTHING;

INSERT INTO budgets (id, building_id, budget_year, total_budget, status) 
VALUES ('f800e17a-1442-43e5-9527-fabc0b1ed5a3', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', 2024, 0, 'draft') ON CONFLICT (id) DO NOTHING;

INSERT INTO budgets (id, building_id, budget_year, total_budget, status) 
VALUES ('68e5dd2b-38af-49c1-a5a4-783212881dd6', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', 2024, 0, 'draft') ON CONFLICT (id) DO NOTHING;

INSERT INTO budgets (id, building_id, budget_year, total_budget, status) 
VALUES ('2a49cb4f-6121-40a0-ada3-56aee5ddbd08', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', 2024, 0, 'draft') ON CONFLICT (id) DO NOTHING;

INSERT INTO budgets (id, building_id, budget_year, total_budget, status) 
VALUES ('0fd5be90-abd8-4156-97dd-0cd92156f497', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', 2024, 0, 'draft') ON CONFLICT (id) DO NOTHING;

INSERT INTO budgets (id, building_id, budget_year, total_budget, status) 
VALUES ('cff55c80-7e80-4373-be96-44654de68453', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', 2024, 0, 'draft') ON CONFLICT (id) DO NOTHING;

INSERT INTO budgets (id, building_id, budget_year, total_budget, status) 
VALUES ('8d13a380-c64b-434d-8314-7d7c6219de7d', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', 2024, 0, 'draft') ON CONFLICT (id) DO NOTHING;

INSERT INTO budgets (id, building_id, budget_year, total_budget, status) 
VALUES ('bc1fbede-1da7-42a8-9a5b-c112bad0f363', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', 2024, 0, 'draft') ON CONFLICT (id) DO NOTHING;

INSERT INTO budgets (id, building_id, budget_year, total_budget, status) 
VALUES ('3c4859e4-068e-4cf2-86cf-3b3e2cc21b3f', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', 2024, 0, 'draft') ON CONFLICT (id) DO NOTHING;

INSERT INTO budgets (id, building_id, budget_year, total_budget, status) 
VALUES ('af73ecc0-b17a-477b-8156-111155fd4c45', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', 2024, 0, 'draft') ON CONFLICT (id) DO NOTHING;

INSERT INTO budgets (id, building_id, budget_year, total_budget, status) 
VALUES ('7d9106b8-09d6-4de4-9431-e175dad1b18b', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', 2024, 0, 'draft') ON CONFLICT (id) DO NOTHING;

INSERT INTO budgets (id, building_id, budget_year, total_budget, status) 
VALUES ('5214ab5c-8fec-428e-84b8-8af9b8a76900', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', 2024, 0, 'draft') ON CONFLICT (id) DO NOTHING;

INSERT INTO budgets (id, building_id, budget_year, total_budget, status) 
VALUES ('c9660629-69c3-42bc-8ac1-c00b8f11a505', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', 2024, 0, 'draft') ON CONFLICT (id) DO NOTHING;

INSERT INTO budgets (id, building_id, budget_year, total_budget, status) 
VALUES ('5ca9fff7-1303-4729-a1e7-5e14131e7b31', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', 2024, 0, 'draft') ON CONFLICT (id) DO NOTHING;

INSERT INTO budgets (id, building_id, budget_year, total_budget, status) 
VALUES ('6d5e0515-536d-46f9-a5be-e019ec10f853', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', 2024, 0, 'draft') ON CONFLICT (id) DO NOTHING;

INSERT INTO budgets (id, building_id, budget_year, total_budget, status) 
VALUES ('c867c165-dd1a-4c36-9197-8209be1289f0', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', 2024, 0, 'draft') ON CONFLICT (id) DO NOTHING;

INSERT INTO budgets (id, building_id, budget_year, total_budget, status) 
VALUES ('0bbccc1f-d732-4967-bac5-5af74cf1c66c', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', 2024, 0, 'draft') ON CONFLICT (id) DO NOTHING;

INSERT INTO budgets (id, building_id, budget_year, total_budget, status) 
VALUES ('aa44dbc1-7e2a-4e42-bacf-f6df9117dd02', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', 2024, 0, 'draft') ON CONFLICT (id) DO NOTHING;

INSERT INTO budgets (id, building_id, budget_year, total_budget, status) 
VALUES ('f9761877-c8e0-4a99-9afb-7f66a542b45a', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', 2024, 0, 'draft') ON CONFLICT (id) DO NOTHING;

INSERT INTO budgets (id, building_id, budget_year, total_budget, status) 
VALUES ('c84cb734-ae25-496f-a1e7-1d41528caa91', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', 2024, 0, 'draft') ON CONFLICT (id) DO NOTHING;

INSERT INTO budgets (id, building_id, budget_year, total_budget, status) 
VALUES ('0981ee27-b553-46c5-8b98-aeebf9521a64', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', 2024, 0, 'draft') ON CONFLICT (id) DO NOTHING;

INSERT INTO budgets (id, building_id, budget_year, total_budget, status) 
VALUES ('31d76958-e82d-4340-aad0-c2009754affe', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', 2024, 0, 'draft') ON CONFLICT (id) DO NOTHING;

INSERT INTO budgets (id, building_id, budget_year, total_budget, status) 
VALUES ('89c41ddf-0a53-4bda-b599-9f0ba74b20bb', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', 2024, 0, 'draft') ON CONFLICT (id) DO NOTHING;

INSERT INTO budgets (id, building_id, budget_year, total_budget, status) 
VALUES ('72b135d8-6cb4-4983-bd7c-fc87d01b6b29', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', 2024, 0, 'draft') ON CONFLICT (id) DO NOTHING;

INSERT INTO budgets (id, building_id, budget_year, total_budget, status) 
VALUES ('a7346067-dd51-49a1-bc64-f6c1a0c272c2', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', 2024, 0, 'draft') ON CONFLICT (id) DO NOTHING;

INSERT INTO budgets (id, building_id, budget_year, total_budget, status) 
VALUES ('e51f7753-dfa7-4b3b-9d8c-9589b0c0d4bb', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', 2024, 0, 'draft') ON CONFLICT (id) DO NOTHING;

INSERT INTO budgets (id, building_id, budget_year, total_budget, status) 
VALUES ('b52cc7f1-481a-4630-923a-20cebb3e7b97', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', 2024, 0, 'draft') ON CONFLICT (id) DO NOTHING;

INSERT INTO budgets (id, building_id, budget_year, total_budget, status) 
VALUES ('7b8a3ff4-7231-4b60-bc61-108c011d1583', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', 2024, 0, 'draft') ON CONFLICT (id) DO NOTHING;

INSERT INTO budgets (id, building_id, budget_year, total_budget, status) 
VALUES ('168c9331-d4cb-4fb8-b928-023f141b507c', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', 2024, 0, 'draft') ON CONFLICT (id) DO NOTHING;

INSERT INTO budgets (id, building_id, budget_year, total_budget, status) 
VALUES ('a14bdc07-e5c5-4c61-9a67-17d9361cb378', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', 2024, 0, 'draft') ON CONFLICT (id) DO NOTHING;

INSERT INTO budgets (id, building_id, budget_year, total_budget, status) 
VALUES ('c47a4457-13bf-4a96-9e3f-b8dd3aed6981', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', 2024, 0, 'draft') ON CONFLICT (id) DO NOTHING;

INSERT INTO budgets (id, building_id, budget_year, total_budget, status) 
VALUES ('adf5bfbb-dc45-43a6-a776-31e168c72d0b', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', 2024, 0, 'draft') ON CONFLICT (id) DO NOTHING;

INSERT INTO budgets (id, building_id, budget_year, total_budget, status) 
VALUES ('e89339b2-1a20-4027-b3b9-5bea274b92c0', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', 2024, 0, 'draft') ON CONFLICT (id) DO NOTHING;

INSERT INTO budgets (id, building_id, budget_year, total_budget, status) 
VALUES ('b1e856c0-1345-4b26-97de-f9190995aa6a', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', 2024, 0, 'draft') ON CONFLICT (id) DO NOTHING;

INSERT INTO budgets (id, building_id, budget_year, total_budget, status) 
VALUES ('360a0811-d873-4dc8-b506-4d1e8f7719b2', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', 2024, 0, 'draft') ON CONFLICT (id) DO NOTHING;

INSERT INTO budgets (id, building_id, budget_year, total_budget, status) 
VALUES ('fef81748-209f-4be7-88fb-58eff18542eb', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', 2024, 0, 'draft') ON CONFLICT (id) DO NOTHING;

INSERT INTO budgets (id, building_id, budget_year, total_budget, status) 
VALUES ('bc9a2001-7684-4957-bf19-d0b85ad6b166', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', 2024, 0, 'draft') ON CONFLICT (id) DO NOTHING;

INSERT INTO budgets (id, building_id, budget_year, total_budget, status) 
VALUES ('70e1e417-09fb-4b91-b05a-ece5e3b996e1', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', 2024, 0, 'draft') ON CONFLICT (id) DO NOTHING;

INSERT INTO budgets (id, building_id, budget_year, total_budget, status) 
VALUES ('9cf3c018-f94a-419f-abae-ee2628a258a3', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', 2024, 0, 'draft') ON CONFLICT (id) DO NOTHING;

INSERT INTO budgets (id, building_id, budget_year, total_budget, status) 
VALUES ('68941882-66e4-4c74-bb94-3a176a3eea42', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', 2024, 0, 'draft') ON CONFLICT (id) DO NOTHING;

INSERT INTO budgets (id, building_id, budget_year, total_budget, status) 
VALUES ('dac1b0a3-73a2-474a-a371-522db1399cd4', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', 2024, 0, 'draft') ON CONFLICT (id) DO NOTHING;

INSERT INTO budgets (id, building_id, budget_year, total_budget, status) 
VALUES ('072cb06d-86fe-45ef-979b-413d7fa73504', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', 2024, 0, 'draft') ON CONFLICT (id) DO NOTHING;

INSERT INTO budgets (id, building_id, budget_year, total_budget, status) 
VALUES ('214fc950-5495-4b21-8cd4-59f2b9e208d0', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', 2024, 0, 'draft') ON CONFLICT (id) DO NOTHING;

INSERT INTO budgets (id, building_id, budget_year, total_budget, status) 
VALUES ('1892d3c8-14fc-4daf-bc31-967d41959feb', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', 2024, 0, 'draft') ON CONFLICT (id) DO NOTHING;

INSERT INTO budgets (id, building_id, budget_year, total_budget, status) 
VALUES ('0bb1179a-63ac-43e0-8788-02cb2cd7a5b9', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', 2024, 0, 'draft') ON CONFLICT (id) DO NOTHING;

INSERT INTO budgets (id, building_id, budget_year, total_budget, status) 
VALUES ('8b93f9e4-3735-4760-9c2a-bf464049b711', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', 2024, 0, 'draft') ON CONFLICT (id) DO NOTHING;

INSERT INTO budgets (id, building_id, budget_year, total_budget, status) 
VALUES ('4581834e-0e64-4510-a9d3-5960c42a4fe6', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', 2024, 0, 'draft') ON CONFLICT (id) DO NOTHING;

INSERT INTO budgets (id, building_id, budget_year, total_budget, status) 
VALUES ('c4ee8a4e-2ecb-437f-8121-f14d01a295e4', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', 2024, 0, 'draft') ON CONFLICT (id) DO NOTHING;

INSERT INTO budgets (id, building_id, budget_year, total_budget, status) 
VALUES ('d5bdb848-2877-4343-8d74-a869f34c88a5', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', 2024, 0, 'draft') ON CONFLICT (id) DO NOTHING;

INSERT INTO budgets (id, building_id, budget_year, total_budget, status) 
VALUES ('61f045b3-f30a-4e9a-a4cd-579d679ae2de', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', 2024, 0, 'draft') ON CONFLICT (id) DO NOTHING;

INSERT INTO budgets (id, building_id, budget_year, total_budget, status) 
VALUES ('b56c9ea9-936b-4ed9-be5b-a2f562c2f89c', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', 2024, 0, 'draft') ON CONFLICT (id) DO NOTHING;

INSERT INTO budgets (id, building_id, budget_year, total_budget, status) 
VALUES ('ef3eb4ef-260b-4eea-8e61-93c35534ca00', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', 2024, 0, 'draft') ON CONFLICT (id) DO NOTHING;

INSERT INTO budgets (id, building_id, budget_year, total_budget, status) 
VALUES ('723129e3-08fe-406d-9241-98019746c287', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', 2024, 0, 'draft') ON CONFLICT (id) DO NOTHING;

INSERT INTO budgets (id, building_id, budget_year, total_budget, status) 
VALUES ('15ddd29d-99cb-4bc1-b294-8a84af795625', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', 2024, 0, 'draft') ON CONFLICT (id) DO NOTHING;

INSERT INTO budgets (id, building_id, budget_year, total_budget, status) 
VALUES ('9f82590b-872f-4633-b111-d36fa7b3bf94', 'cd83b608-ee5a-4bcc-b02d-0bc65a477829', 2024, 0, 'draft') ON CONFLICT (id) DO NOTHING;

COMMIT;