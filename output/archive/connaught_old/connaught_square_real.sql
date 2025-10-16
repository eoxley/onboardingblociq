-- BlocIQ SQL Generator Output
-- Generated: 2025-10-14T12:04:20.537040
-- Source: /Users/ellie/Downloads/219.01 CONNAUGHT SQUARE
-- Tables affected: buildings, building_data_snapshots

BEGIN;

INSERT INTO buildings (name, address, postcode, construction_type, has_lifts, num_lifts, num_units, num_floors, bsa_status)
VALUES ('32-34 Connaught Square', '32-34 Connaught Square, London', 'W2 2HL', 'Period conversion', TRUE, 1, 8, 4, 'Registered')
ON CONFLICT (name, address) DO UPDATE SET
  postcode = EXCLUDED.postcode,
  construction_type = EXCLUDED.construction_type,
  has_lifts = EXCLUDED.has_lifts,
  num_lifts = EXCLUDED.num_lifts,
  num_units = EXCLUDED.num_units,
  num_floors = EXCLUDED.num_floors,
  bsa_status = EXCLUDED.bsa_status;

INSERT INTO building_data_snapshots (id, building_id, extracted_at, source_folder, raw_sql_json)
VALUES (
  '50897a8b-502e-4a1b-8509-58e28faea626',
  'e60709d0-e6df-4215-9ff1-9d479e222e29',
  '2025-10-14T12:04:20.536960',
  '/Users/ellie/Downloads/219.01 CONNAUGHT SQUARE',
  '{"units": [{"unit_number": "Flat 1", "unit_reference": "219-01-001", "apportionment_percentage": 13.97, "apportionment_method": "Last In"}, {"unit_number": "Flat 2", "unit_reference": "219-01-002", "apportionment_percentage": 11.51, "apportionment_method": "Last In"}, {"unit_number": "Flat 3", "unit_reference": "219-01-003", "apportionment_percentage": 12.18, "apportionment_method": "Last In"}, {"unit_number": "Flat 4", "unit_reference": "219-01-004", "apportionment_percentage": 11.21, "apportionment_method": "Last In"}, {"unit_number": "Flat 5", "unit_reference": "219-01-005", "apportionment_percentage": 11.75, "apportionment_method": "Last In"}, {"unit_number": "Flat 6", "unit_reference": "219-01-006", "apportionment_percentage": 24.13, "apportionment_method": "Last In"}, {"unit_number": "Flat 7", "unit_reference": "219-01-007", "apportionment_percentage": 9.25, "apportionment_method": "Last In"}, {"unit_number": "Flat 8", "unit_reference": "219-01-008", "apportionment_percentage": 6.0, "apportionment_method": "Last In"}], "compliance_assets": [{"asset_type": "FRA", "inspection_date": "2023-12-07", "next_due_date": "2024-12-31", "status": "current", "risk_rating": "Medium", "assessor": "Tetra Consulting Ltd", "certificate_reference": "Fra1-L-394697-071223", "source_document": "221037_Fra1-L-394697-071223 32-34 Connaught Square_2024-01-02_163759.pdf"}, {"asset_type": "EICR", "inspection_date": "2023-01-01", "status": "current", "assessor": "Cunaku", "certificate_reference": "SATISFACTORY", "source_document": "EICR Report Cunaku SATISFACTORY 2023 .pdf"}, {"asset_type": "Legionella", "inspection_date": "2022-06-07", "status": "expired", "assessor": "WHM", "source_document": "WHM Legionella Risk Assessment 07.06.22.pdf"}, {"asset_type": "Asbestos", "inspection_date": "2022-06-14", "status": "current", "assessor": "TETRA", "source_document": "TETRA - Asbestos Re-Inspection Survey 14.06.22.pdf"}, {"asset_type": "Fire Door", "inspection_date": "2024-01-24", "status": "current", "source_document": "Fire Door (Communal) Inspection (11m +) - 2024-01-24T120743.986.pdf"}], "budgets": [{"financial_year": "2025/2026", "budget_total": null, "source_document": "Connaught Square Budget 2025-6 Draft.xlsx", "status": "draft"}], "extraction_timestamp": "2025-10-14T12:04:20.536104", "extraction_method": "Real document parsing", "source_folder": "/Users/ellie/Downloads/219.01 CONNAUGHT SQUARE", "data_quality": "high", "corrections_applied": ["Address corrected from '219 Connaught Square' to '32-34 Connaught Square'", "Unit count corrected from 6 to 8", "Has_lifts corrected from False to True", "Compliance asset dates extracted from actual documents", "Apportionment percentages extracted from spreadsheet"]}'::jsonb
);

COMMIT;
