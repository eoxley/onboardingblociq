-- ============================================================================
-- BlocIQ Supabase Schema
-- ============================================================================
-- Hybrid schema design:
-- - Core relational tables for stable data
-- - JSONB snapshots for dynamic AI-extracted data
-- - Per-agency isolation (no RLS needed)
-- - Idempotent UPSERT support via unique constraints
--
-- Author: BlocIQ Team
-- Date: 2025-10-14
-- ============================================================================

-- Enable UUID extension
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- ============================================================================
-- CORE TABLES
-- ============================================================================

-- Buildings (Core entity)
CREATE TABLE buildings (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    name text NOT NULL,
    address text NOT NULL,
    postcode text,
    year_built int,
    num_floors int,
    num_units int,
    construction_type text,
    has_lifts boolean DEFAULT false,
    num_lifts int,
    fire_strategy text,
    bsa_status text,
    bsa_registration_number text,
    metadata jsonb,
    current_data_id uuid,  -- References latest snapshot
    storage_path text,  -- Supabase storage bucket path
    created_at timestamptz DEFAULT now(),
    updated_at timestamptz DEFAULT now(),

    -- Unique constraint for UPSERT
    CONSTRAINT buildings_name_address_key UNIQUE (name, address)
);

-- Create index on commonly queried fields
CREATE INDEX idx_buildings_postcode ON buildings(postcode);
CREATE INDEX idx_buildings_bsa_number ON buildings(bsa_registration_number);

-- ============================================================================
-- BUILDING DATA SNAPSHOTS (Dynamic AI-extracted data)
-- ============================================================================

CREATE TABLE building_data_snapshots (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    building_id uuid REFERENCES buildings(id) ON DELETE CASCADE,
    extracted_at timestamptz DEFAULT now(),
    source_folder text,
    raw_sql_json jsonb,  -- Unmapped fields from extraction
    summary jsonb,  -- Summary of extraction (confidence, fields found, etc.)
    storage_ref text,  -- Reference to source files in storage
    created_at timestamptz DEFAULT now()
);

CREATE INDEX idx_snapshots_building_id ON building_data_snapshots(building_id);
CREATE INDEX idx_snapshots_extracted_at ON building_data_snapshots(extracted_at DESC);

-- ============================================================================
-- UNITS
-- ============================================================================

CREATE TABLE units (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    building_id uuid REFERENCES buildings(id) ON DELETE CASCADE,
    unit_number text NOT NULL,
    floor_number int,
    bedrooms int,
    tenure_type text,
    leaseholder_name text,
    correspondence_address text,
    is_resident_owner boolean,
    apportionment_percentage numeric(5,2),
    metadata jsonb,
    created_at timestamptz DEFAULT now(),
    updated_at timestamptz DEFAULT now(),

    -- Unique constraint for UPSERT
    CONSTRAINT units_building_unit_key UNIQUE (building_id, unit_number)
);

CREATE INDEX idx_units_building_id ON units(building_id);
CREATE INDEX idx_units_leaseholder ON units(leaseholder_name);

-- ============================================================================
-- LEASES
-- ============================================================================

CREATE TABLE leases (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    unit_id uuid REFERENCES units(id) ON DELETE CASCADE,
    lease_date date,
    term_years int,
    start_date date NOT NULL,
    end_date date,
    ground_rent_amount numeric(10,2),
    ground_rent_review_basis text,
    service_charge_basis text,
    title_number text,
    landlord_name text,
    metadata jsonb,
    created_at timestamptz DEFAULT now(),
    updated_at timestamptz DEFAULT now(),

    -- Unique constraint for UPSERT
    CONSTRAINT leases_unit_start_key UNIQUE (unit_id, start_date)
);

CREATE INDEX idx_leases_unit_id ON leases(unit_id);
CREATE INDEX idx_leases_end_date ON leases(end_date);

-- ============================================================================
-- COMPLIANCE ASSETS
-- ============================================================================

CREATE TABLE compliance_assets (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    building_id uuid REFERENCES buildings(id) ON DELETE CASCADE,
    asset_type text NOT NULL,  -- FRA, EICR, Asbestos, Legionella, etc.
    inspection_date date,
    next_due_date date,
    status text,  -- current, due_soon, expired, missing
    risk_rating text,
    assessor text,
    certificate_reference text,
    metadata jsonb,
    created_at timestamptz DEFAULT now(),
    updated_at timestamptz DEFAULT now(),

    -- Unique constraint for UPSERT
    CONSTRAINT compliance_building_type_date_key UNIQUE (building_id, asset_type, inspection_date)
);

CREATE INDEX idx_compliance_building_id ON compliance_assets(building_id);
CREATE INDEX idx_compliance_next_due ON compliance_assets(next_due_date);
CREATE INDEX idx_compliance_status ON compliance_assets(status);

-- ============================================================================
-- BUDGETS
-- ============================================================================

CREATE TABLE budgets (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    building_id uuid REFERENCES buildings(id) ON DELETE CASCADE,
    financial_year text NOT NULL,  -- e.g., "2024/2025"
    budget_total numeric(12,2),
    reserve_fund numeric(12,2),
    schedule_letter text,  -- A, B, C, etc.
    version int DEFAULT 1,
    metadata jsonb,
    created_at timestamptz DEFAULT now(),
    updated_at timestamptz DEFAULT now(),

    -- Unique constraint for UPSERT
    CONSTRAINT budgets_building_year_key UNIQUE (building_id, financial_year)
);

CREATE INDEX idx_budgets_building_id ON budgets(building_id);
CREATE INDEX idx_budgets_financial_year ON budgets(financial_year);

-- ============================================================================
-- REPAIR OBLIGATIONS (from leases)
-- ============================================================================

CREATE TABLE repair_obligations (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    lease_id uuid REFERENCES leases(id) ON DELETE CASCADE,
    responsible_party text,  -- Tenant, Landlord
    component text NOT NULL,  -- Structure, Internal, Decorations, etc.
    obligation text,
    frequency_years int,
    created_at timestamptz DEFAULT now(),

    -- Unique constraint for UPSERT
    CONSTRAINT repair_lease_component_key UNIQUE (lease_id, component)
);

CREATE INDEX idx_repair_lease_id ON repair_obligations(lease_id);

-- ============================================================================
-- RESTRICTIONS (from leases)
-- ============================================================================

CREATE TABLE restrictions (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    lease_id uuid REFERENCES leases(id) ON DELETE CASCADE,
    restriction_type text NOT NULL,  -- Pets, Flooring, Subletting, etc.
    clause_text text,
    allows_with_consent boolean DEFAULT false,
    absolute_prohibition boolean DEFAULT true,
    created_at timestamptz DEFAULT now(),

    -- Unique constraint for UPSERT
    CONSTRAINT restrictions_lease_type_key UNIQUE (lease_id, restriction_type)
);

CREATE INDEX idx_restrictions_lease_id ON restrictions(lease_id);
CREATE INDEX idx_restrictions_type ON restrictions(restriction_type);

-- ============================================================================
-- RIGHTS AND EASEMENTS (from leases)
-- ============================================================================

CREATE TABLE rights_and_easements (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    lease_id uuid REFERENCES leases(id) ON DELETE CASCADE,
    right_type text NOT NULL,  -- Access, Support, Use of Facility, etc.
    description text,
    granted_to text,  -- Tenant, Landlord
    created_at timestamptz DEFAULT now(),

    -- Unique constraint for UPSERT
    CONSTRAINT rights_lease_type_key UNIQUE (lease_id, right_type)
);

CREATE INDEX idx_rights_lease_id ON rights_and_easements(lease_id);

-- ============================================================================
-- DEVELOPMENTS (for multi-building estates)
-- ============================================================================

CREATE TABLE developments (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    development_name text NOT NULL UNIQUE,
    client_name text,
    management_agent text,
    tenure_type text,
    num_buildings int,
    has_master_apportionment boolean DEFAULT false,
    has_estate_service_charge boolean DEFAULT false,
    insurance_policy_ref text,
    bsa_registration_number text,
    metadata jsonb,
    created_at timestamptz DEFAULT now(),
    updated_at timestamptz DEFAULT now()
);

-- Link buildings to developments
ALTER TABLE buildings ADD COLUMN development_id uuid REFERENCES developments(id);
CREATE INDEX idx_buildings_development_id ON buildings(development_id);

-- ============================================================================
-- ESTATE ASSETS (shared across development)
-- ============================================================================

CREATE TABLE estate_assets (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    development_id uuid REFERENCES developments(id) ON DELETE CASCADE,
    asset_type text NOT NULL,  -- Gardens, Parking, Bin Store, etc.
    description text,
    shared_by_all_buildings boolean DEFAULT true,
    maintenance_provider text,
    created_at timestamptz DEFAULT now(),

    -- Unique constraint for UPSERT
    CONSTRAINT estate_assets_dev_type_key UNIQUE (development_id, asset_type)
);

CREATE INDEX idx_estate_assets_dev_id ON estate_assets(development_id);

-- ============================================================================
-- HELPER FUNCTIONS
-- ============================================================================

-- Function to update updated_at timestamp
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = now();
    RETURN NEW;
END;
$$ language 'plpgsql';

-- Apply updated_at trigger to all tables
CREATE TRIGGER update_buildings_updated_at BEFORE UPDATE ON buildings
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_units_updated_at BEFORE UPDATE ON units
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_leases_updated_at BEFORE UPDATE ON leases
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_compliance_updated_at BEFORE UPDATE ON compliance_assets
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_budgets_updated_at BEFORE UPDATE ON budgets
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_developments_updated_at BEFORE UPDATE ON developments
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- ============================================================================
-- VIEWS (for common queries)
-- ============================================================================

-- Buildings with latest snapshot
CREATE OR REPLACE VIEW buildings_with_latest_snapshot AS
SELECT
    b.*,
    s.extracted_at as latest_extraction_date,
    s.raw_sql_json as latest_unmapped_data,
    s.summary as latest_extraction_summary
FROM buildings b
LEFT JOIN LATERAL (
    SELECT * FROM building_data_snapshots
    WHERE building_id = b.id
    ORDER BY extracted_at DESC
    LIMIT 1
) s ON true;

-- Compliance status summary by building
CREATE OR REPLACE VIEW compliance_status_summary AS
SELECT
    building_id,
    COUNT(*) as total_assets,
    COUNT(*) FILTER (WHERE status = 'current') as current_count,
    COUNT(*) FILTER (WHERE status = 'due_soon') as due_soon_count,
    COUNT(*) FILTER (WHERE status = 'expired') as expired_count,
    COUNT(*) FILTER (WHERE status = 'missing') as missing_count
FROM compliance_assets
GROUP BY building_id;

-- Units with lease information
CREATE OR REPLACE VIEW units_with_lease_info AS
SELECT
    u.*,
    l.lease_date,
    l.term_years,
    l.start_date as lease_start,
    l.end_date as lease_end,
    l.ground_rent_amount,
    l.service_charge_basis
FROM units u
LEFT JOIN leases l ON u.id = l.unit_id;

-- ============================================================================
-- COMMENTS (documentation)
-- ============================================================================

COMMENT ON TABLE buildings IS 'Core building entities with stable attributes';
COMMENT ON TABLE building_data_snapshots IS 'Dynamic AI-extracted data that doesn''t fit stable schema';
COMMENT ON TABLE units IS 'Individual units/flats within buildings';
COMMENT ON TABLE leases IS 'Lease agreements linked to units';
COMMENT ON TABLE compliance_assets IS 'Compliance certificates and inspections (FRA, EICR, etc.)';
COMMENT ON TABLE budgets IS 'Annual service charge budgets';
COMMENT ON TABLE developments IS 'Multi-building estates or developments';
COMMENT ON TABLE estate_assets IS 'Shared assets across a development (gardens, parking, etc.)';

COMMENT ON COLUMN buildings.current_data_id IS 'References the latest snapshot for quick access';
COMMENT ON COLUMN buildings.storage_path IS 'Path to source documents in Supabase storage bucket';
COMMENT ON COLUMN building_data_snapshots.raw_sql_json IS 'Unmapped fields from AI extraction preserved as JSONB';
COMMENT ON COLUMN units.apportionment_percentage IS 'Service charge contribution percentage';
COMMENT ON COLUMN leases.ground_rent_review_basis IS 'Doubles/RPI/CPI/Fixed';

-- ============================================================================
-- SAMPLE QUERIES
-- ============================================================================

-- Sample 1: Get all buildings with their compliance status
-- SELECT b.name, b.address, c.current_count, c.expired_count
-- FROM buildings b
-- LEFT JOIN compliance_status_summary c ON b.id = c.building_id;

-- Sample 2: Find leases expiring in next 5 years
-- SELECT u.unit_number, b.name, l.end_date
-- FROM leases l
-- JOIN units u ON l.unit_id = u.id
-- JOIN buildings b ON u.building_id = b.id
-- WHERE l.end_date BETWEEN now() AND now() + interval '5 years';

-- Sample 3: Get unmapped data for a building
-- SELECT b.name, s.raw_sql_json
-- FROM buildings b
-- JOIN building_data_snapshots s ON b.current_data_id = s.id;
