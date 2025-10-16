-- BlocIQ SQL Generator Output
-- Generated: 2025-10-14T11:54:20.780305
-- Source: /Users/ellie/Downloads/219.01 CONNAUGHT SQUARE
-- Tables affected: buildings, building_data_snapshots

BEGIN;

INSERT INTO buildings (name, address, postcode, construction_type, has_lifts, num_units)
VALUES ('219 Connaught Square', '219 Connaught Square, London', 'W2 1HH', 'Period conversion', FALSE, 6)
ON CONFLICT (name, address) DO UPDATE SET
  postcode = EXCLUDED.postcode,
  construction_type = EXCLUDED.construction_type,
  has_lifts = EXCLUDED.has_lifts,
  num_units = EXCLUDED.num_units;

INSERT INTO building_data_snapshots (id, building_id, extracted_at, source_folder, raw_sql_json)
VALUES (
  'ebcbccff-3e16-4228-a1a2-611ca18430ae',
  '7ab522fd-c3a5-4e4f-abf0-24288e0f22d1',
  '2025-10-14T11:54:20.780226',
  '/Users/ellie/Downloads/219.01 CONNAUGHT SQUARE',
  '{"apportionment_detected": true, "apportionment_source": "connaught apportionment.xlsx", "has_fire_door_inspection": true, "fire_door_inspection_source": "4. HEALTH & SAFETY/FIRE DOORS", "insurance_folder_detected": true, "insurance_folder_path": "5. INSURANCE", "contracts_folder_detected": true, "contracts_count": "multiple", "major_works_folder_detected": true, "major_works_folder_path": "6. MAJOR WORKS", "finance_folder_detected": true, "finance_folder_path": "2. FINANCE", "client_info_folder_detected": true, "client_info_folder_path": "1. CLIENT INFORMATION", "correspondence_folder_detected": true, "drawings_folder_detected": true, "drawings_folder_path": "9.BUILDING DRAWINGS & PLANS", "directors_meeting_notes": "2024 Directors Meeting-Notes.docx", "meeting_minutes": "Connaught Square Meeting Minutes 2.docx", "property_information": "Connaught Square New property information.xlsx", "extraction_timestamp": "2025-10-14T11:54:20.779634", "extraction_method": "Full folder scan", "source_folder": "/Users/ellie/Downloads/219.01 CONNAUGHT SQUARE", "folders_scanned": ["1. CLIENT INFORMATION", "2. FINANCE", "3. GENERAL CORRESPONDENCE", "4. HEALTH & SAFETY", "5. INSURANCE", "6. MAJOR WORKS", "7. CONTRACTS", "8. FLAT CORRESPONDENCE", "9.BUILDING DRAWINGS & PLANS", "11. HANDOVER"], "total_folders": 10}'::jsonb
);

COMMIT;
