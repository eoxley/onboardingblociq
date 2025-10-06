-- BlocIQ Test Migration (demonstrates diagnostic features)

-- Building with missing address
INSERT INTO buildings (id, portfolio_id, name, address)
VALUES ('a1b2c3d4-e5f6-7890-abcd-ef1234567890', 'b2c3d4e5-f6a7-8901-bcde-f12345678901', 'Test Building', '');

-- Units
INSERT INTO units (id, building_id, unit_number)
VALUES ('c3d4e5f6-a7b8-9012-cdef-123456789012', 'a1b2c3d4-e5f6-7890-abcd-ef1234567890', 'Flat 1');

-- Compliance assets with default frequency
INSERT INTO compliance_assets (id, building_id, asset_name, asset_type, inspection_frequency)
VALUES ('d4e5f6a7-b8c9-0123-def1-234567890123', 'a1b2c3d4-e5f6-7890-abcd-ef1234567890', 'Fire Risk Assessment', 'fire_safety', '12 months');

INSERT INTO compliance_assets (id, building_id, asset_name, asset_type, inspection_frequency)
VALUES ('e5f6a7b8-c9d0-1234-ef12-345678901234', 'a1b2c3d4-e5f6-7890-abcd-ef1234567890', 'EICR Report', 'electrical', '12 months');

-- Duplicate compliance asset (same values)
INSERT INTO compliance_assets (id, building_id, asset_name, asset_type, inspection_frequency)
VALUES ('f6a7b8c9-d0e1-2345-f123-456789012345', 'a1b2c3d4-e5f6-7890-abcd-ef1234567890', 'Fire Risk Assessment', 'fire_safety', '12 months');

-- Building documents with filenames containing dates
INSERT INTO building_documents (id, building_id, category, file_name, storage_path)
VALUES ('a7b8c9d0-e1f2-3456-1234-567890123456', 'a1b2c3d4-e5f6-7890-abcd-ef1234567890', 'compliance', 'FRA 160124.pdf', 'compliance/FRA 160124.pdf');

INSERT INTO building_documents (id, building_id, category, file_name, storage_path)
VALUES ('b8c9d0e1-f2a3-4567-2345-678901234567', 'a1b2c3d4-e5f6-7890-abcd-ef1234567890', 'compliance', 'EICR 2023-11-15.pdf', 'compliance/EICR 2023-11-15.pdf');

-- Budget without year/period metadata
INSERT INTO budgets (id, building_id, period)
VALUES ('c9d0e1f2-a3b4-5678-3456-789012345678', 'a1b2c3d4-e5f6-7890-abcd-ef1234567890', 'Unknown');

-- Building document with financial metadata (good example)
INSERT INTO building_documents (id, building_id, category, file_name, storage_path, entity_type, financial_year, period_label)
VALUES ('d0e1f2a3-b4c5-6789-4567-890123456789', 'a1b2c3d4-e5f6-7890-abcd-ef1234567890', 'finance', 'Budget YE25 Q1.xlsx', 'finance/Budget YE25 Q1.xlsx', 'budget', '2025', 'Q1');

-- Malformed UUID (missing dashes)
-- INSERT INTO units (id, building_id, unit_number)
-- VALUES ('e1f2a3b4c5d6789045678901234567890', 'a1b2c3d4-e5f6-7890-abcd-ef1234567890', 'Flat 2');

-- Missing ON CONFLICT protection on some inserts (intentionally missing)
INSERT INTO leaseholders (id, building_id, unit_id, name)
VALUES ('f2a3b4c5-d6e7-8901-5678-901234567890', 'a1b2c3d4-e5f6-7890-abcd-ef1234567890', 'c3d4e5f6-a7b8-9012-cdef-123456789012', 'John Doe');

-- Good example with ON CONFLICT
INSERT INTO units (id, building_id, unit_number)
VALUES ('a3b4c5d6-e7f8-9012-6789-012345678901', 'a1b2c3d4-e5f6-7890-abcd-ef1234567890', 'Flat 3')
ON CONFLICT (id) DO NOTHING;

-- Foreign key references
ALTER TABLE units ADD CONSTRAINT fk_units_building FOREIGN KEY (building_id) REFERENCES buildings(id);
