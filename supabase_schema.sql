-- ============================================================================
-- BlocIQ Property Management - Comprehensive Supabase Schema
-- ============================================================================
-- Version: 1.0
-- Date: 2025-10-14
-- Purpose: Flexible schema for all building types, compliance, contracts, and financials
-- Database: PostgreSQL (Supabase)
-- ============================================================================

-- Enable UUID extension
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- ============================================================================
-- CORE ENTITIES
-- ============================================================================

-- ----------------------------------------------------------------------------
-- Buildings (Parent entity for all data)
-- ----------------------------------------------------------------------------
CREATE TABLE buildings (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),

    -- Basic Information
    building_name VARCHAR(255) NOT NULL,
    building_address TEXT,
    postcode VARCHAR(10),
    city VARCHAR(100),
    country VARCHAR(50) DEFAULT 'United Kingdom',

    -- Physical Characteristics
    num_units INTEGER,
    num_residential_units INTEGER,
    num_commercial_units INTEGER,
    num_floors INTEGER,
    num_blocks INTEGER,
    building_height_meters NUMERIC(10,2),

    -- Construction
    construction_era VARCHAR(50),
    year_built INTEGER,

    -- Services & Systems
    has_lifts BOOLEAN DEFAULT false,
    num_lifts INTEGER,
    has_communal_heating BOOLEAN DEFAULT false,
    heating_type VARCHAR(100),
    has_hot_water BOOLEAN DEFAULT false,
    has_hvac BOOLEAN DEFAULT false,
    has_plant_room BOOLEAN DEFAULT false,
    has_mechanical_ventilation BOOLEAN DEFAULT false,
    has_water_pumps BOOLEAN DEFAULT false,
    has_water_tanks BOOLEAN DEFAULT false,
    has_booster_set BOOLEAN DEFAULT false,
    has_gas BOOLEAN DEFAULT false,
    has_sprinklers BOOLEAN DEFAULT false,
    has_smoke_shaft BOOLEAN DEFAULT false,
    has_lightning_conductor BOOLEAN DEFAULT false,
    has_generator BOOLEAN DEFAULT false,
    has_emergency_power BOOLEAN DEFAULT false,
    has_pressure_systems BOOLEAN DEFAULT false,
    has_air_conditioning BOOLEAN DEFAULT false,

    -- Special Facilities
    has_gym BOOLEAN DEFAULT false,
    has_pool BOOLEAN DEFAULT false,
    has_sauna BOOLEAN DEFAULT false,
    has_spa BOOLEAN DEFAULT false,
    has_squash_court BOOLEAN DEFAULT false,
    has_tennis_court BOOLEAN DEFAULT false,
    has_communal_showers BOOLEAN DEFAULT false,
    has_communal_areas BOOLEAN DEFAULT false,
    has_communal_areas_with_appliances BOOLEAN DEFAULT false,
    has_grounds BOOLEAN DEFAULT false,
    has_gardens BOOLEAN DEFAULT false,
    has_balconies BOOLEAN DEFAULT false,
    has_ev_charging BOOLEAN DEFAULT false,
    has_car_park BOOLEAN DEFAULT false,

    -- External & Structure
    has_cladding BOOLEAN DEFAULT false,
    has_combustible_cladding BOOLEAN DEFAULT false,
    cladding_type VARCHAR(100),

    -- Regulatory
    bsa_registration_required BOOLEAN DEFAULT false,
    bsa_registration_number VARCHAR(50),
    bsa_status VARCHAR(50),

    -- Management
    management_company VARCHAR(255),
    is_rmc BOOLEAN DEFAULT false,
    is_rtm BOOLEAN DEFAULT false,
    managing_agent VARCHAR(255),

    -- Metadata
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW(),
    data_quality VARCHAR(50),
    confidence_score NUMERIC(3,2),
    source_folder VARCHAR(500),
    extraction_version VARCHAR(50),

    -- Soft Delete
    deleted_at TIMESTAMPTZ
);

-- Indexes for buildings
CREATE INDEX idx_buildings_postcode ON buildings(postcode);
CREATE INDEX idx_buildings_bsa_required ON buildings(bsa_registration_required);
CREATE INDEX idx_buildings_name ON buildings(building_name);
CREATE INDEX idx_buildings_deleted ON buildings(deleted_at) WHERE deleted_at IS NULL;

-- ----------------------------------------------------------------------------
-- Building Blocks (for multi-block developments)
-- ----------------------------------------------------------------------------
CREATE TABLE building_blocks (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    building_id UUID REFERENCES buildings(id) ON DELETE CASCADE,

    block_identifier VARCHAR(10) NOT NULL, -- 'A', 'B', 'C', etc.
    block_name VARCHAR(100),
    num_units INTEGER,
    num_floors INTEGER,

    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW(),

    UNIQUE(building_id, block_identifier)
);

CREATE INDEX idx_blocks_building ON building_blocks(building_id);

-- ----------------------------------------------------------------------------
-- Units
-- ----------------------------------------------------------------------------
CREATE TABLE units (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    building_id UUID REFERENCES buildings(id) ON DELETE CASCADE,
    block_id UUID REFERENCES building_blocks(id) ON DELETE SET NULL,

    -- Identification
    unit_number VARCHAR(50) NOT NULL,
    unit_reference VARCHAR(100),
    unit_type VARCHAR(50), -- 'Flat', 'Apartment', 'Commercial', 'Parking'

    -- Details
    bedrooms INTEGER,
    bathrooms INTEGER,
    floor_number INTEGER,
    square_footage NUMERIC(10,2),

    -- Apportionment
    apportionment_percentage NUMERIC(10,6),
    apportionment_method VARCHAR(50),

    -- Status
    tenure VARCHAR(50), -- 'Leasehold', 'Freehold', 'Share of Freehold'
    is_occupied BOOLEAN,
    occupancy_type VARCHAR(50), -- 'Owner-occupied', 'Rented', 'Vacant'

    -- Metadata
    source_document VARCHAR(255),
    data_quality VARCHAR(50),
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW(),
    deleted_at TIMESTAMPTZ,

    UNIQUE(building_id, unit_number)
);

CREATE INDEX idx_units_building ON units(building_id);
CREATE INDEX idx_units_block ON units(block_id);
CREATE INDEX idx_units_number ON units(unit_number);
CREATE INDEX idx_units_type ON units(unit_type);

-- ----------------------------------------------------------------------------
-- Leaseholders
-- ----------------------------------------------------------------------------
CREATE TABLE leaseholders (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    unit_id UUID REFERENCES units(id) ON DELETE CASCADE,

    -- Personal Information
    leaseholder_name VARCHAR(255) NOT NULL,
    title VARCHAR(20),
    first_name VARCHAR(100),
    last_name VARCHAR(100),

    -- Contact Details
    correspondence_address TEXT,
    email VARCHAR(255),
    telephone VARCHAR(50),
    mobile VARCHAR(50),

    -- Leaseholder Details
    leaseholder_type VARCHAR(50), -- 'Individual', 'Company', 'Trust'
    company_number VARCHAR(50),

    -- Status
    status VARCHAR(50), -- 'Current', 'Former', 'Deceased'
    move_in_date DATE,
    move_out_date DATE,

    -- Financial
    current_balance NUMERIC(12,2) DEFAULT 0,

    -- Metadata
    data_source VARCHAR(255),
    data_quality VARCHAR(50),
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW(),
    deleted_at TIMESTAMPTZ
);

CREATE INDEX idx_leaseholders_unit ON leaseholders(unit_id);
CREATE INDEX idx_leaseholders_name ON leaseholders(leaseholder_name);
CREATE INDEX idx_leaseholders_balance ON leaseholders(current_balance) WHERE current_balance != 0;

-- ============================================================================
-- COMPLIANCE & SAFETY
-- ============================================================================

-- ----------------------------------------------------------------------------
-- Compliance Asset Types (Reference table)
-- ----------------------------------------------------------------------------
CREATE TABLE compliance_asset_types (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),

    -- Basic Info
    asset_type_code VARCHAR(50) UNIQUE NOT NULL, -- 'FRA', 'EICR', 'LOLER', etc.
    full_name VARCHAR(255) NOT NULL,
    category VARCHAR(100), -- 'Fire Safety', 'Electrical', 'Water Hygiene', etc.

    -- Requirements
    frequency_months INTEGER,
    regulatory_basis TEXT,
    priority VARCHAR(20), -- 'critical', 'high', 'medium', 'low'

    -- Metadata
    description TEXT,
    keywords TEXT[], -- Array of detection keywords

    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Pre-populate with 50+ known asset types
INSERT INTO compliance_asset_types (asset_type_code, full_name, category, frequency_months, regulatory_basis, priority) VALUES
-- Fire Safety
('FRA', 'Fire Risk Assessment', 'Fire Safety', 12, 'Regulatory Reform (Fire Safety) Order 2005', 'critical'),
('FIRE_ALARM', 'Fire Alarm Test & Maintenance', 'Fire Safety', 6, 'BS 5839-1', 'critical'),
('EMERGENCY_LIGHTING', 'Emergency Lighting Test', 'Fire Safety', 12, 'BS 5266-1', 'high'),
('FIRE_DOOR', 'Fire Doors Inspection', 'Fire Safety', 12, 'Building Safety Act 2022', 'critical'),
('AOV', 'AOV / Smoke Vent', 'Fire Safety', 6, 'BS 9991 / BS 9999', 'high'),
('SPRINKLER', 'Sprinkler System', 'Fire Safety', 6, 'BS 9251 / BS EN 12845', 'critical'),
('FIRE_EXTINGUISHERS', 'Fire Extinguishers', 'Fire Safety', 12, 'BS 5306-3', 'medium'),
('FIRE_STOPPING', 'Fire Stopping / Compartmentation', 'Fire Safety', 36, 'Building Regulations Part B', 'high'),
('DRY_RISER', 'Fire Hydrants / Dry Risers', 'Fire Safety', 12, 'BS 9990', 'critical'),
('SMOKE_DETECTORS', 'Smoke Detectors / CO Alarms', 'Fire Safety', 12, 'Smoke and Carbon Monoxide Alarm Regulations 2015', 'high'),
-- Electrical
('EICR', 'EICR (Fixed Wiring)', 'Electrical Safety', 60, 'BS 7671:2018', 'critical'),
('PAT', 'PAT Testing', 'Electrical Safety', 12, 'Electricity at Work Regulations 1989', 'medium'),
('LIGHTNING', 'Lightning Protection Test', 'Electrical Safety', 12, 'BS EN 62305', 'medium'),
('GENERATOR', 'Emergency Power / Backup Generator', 'Electrical Safety', 3, 'BS 7671', 'high'),
('DISTRIBUTION_BOARD', 'Communal Meter / Distribution Board', 'Electrical Safety', 12, 'BS 7671', 'medium'),
-- Water Hygiene
('LEGIONELLA', 'Legionella Risk Assessment', 'Water Hygiene', 24, 'L8 ACOP', 'high'),
('WATER_TANK', 'Cold Water Tank Clean & Chlorination', 'Water Hygiene', 12, 'Water Supply Regulations 1999', 'high'),
('TEMPERATURE_MONITORING', 'Temperature Monitoring', 'Water Hygiene', 1, 'L8 ACOP', 'medium'),
('TMV', 'TMV Servicing', 'Water Hygiene', 12, 'NHS D08', 'medium'),
('SHOWER_DESCALING', 'Shower Head Descaling', 'Water Hygiene', 3, 'L8 ACOP', 'low'),
-- Structural & Fabric
('ASBESTOS', 'Asbestos Survey / Reinspection', 'Structural & Fabric', 36, 'Control of Asbestos Regulations 2012', 'high'),
('ROOF', 'Roof / Gutter Inspection', 'Structural & Fabric', 12, 'RICS Building Surveying', 'medium'),
('BALCONY', 'Balcony / Façade Inspection', 'Structural & Fabric', 60, 'Building Safety Act 2022', 'high'),
('CLADDING', 'Cladding Remediation / FRAEW', 'Structural & Fabric', 0, 'Building Safety Act 2022', 'critical'),
('SAFETY_CASE', 'Safety Case Report', 'Structural & Fabric', 12, 'Building Safety Act 2022', 'critical'),
('RESIDENT_ENGAGEMENT', 'Resident Engagement Strategy', 'Structural & Fabric', 12, 'Building Safety Act 2022', 'medium'),
('COMPARTMENTATION', 'Compartmentation Survey', 'Structural & Fabric', 36, 'Building Regulations Part B', 'high'),
-- Mechanical & HVAC
('LIFT_LOLER', 'Lift LOLER Inspection', 'Mechanical & HVAC', 6, 'LOLER 1998', 'critical'),
('LIFT_MAINTENANCE', 'Lift Maintenance', 'Mechanical & HVAC', 1, 'BS EN 81-80', 'critical'),
('PRESSURE_SYSTEMS', 'Pressure Systems (PSSR)', 'Mechanical & HVAC', 12, 'PSSR 2000', 'high'),
('GAS_SAFETY', 'Gas Safety Certificate (CP12)', 'Mechanical & HVAC', 12, 'Gas Safety Regulations 1998', 'critical'),
('VENTILATION', 'Ventilation Cleaning / Duct Hygiene', 'Mechanical & HVAC', 12, 'HVCA TR19', 'medium'),
('HVAC', 'HVAC Servicing', 'Mechanical & HVAC', 12, 'F-Gas Regulations 2014', 'medium'),
('WATER_PUMP', 'Water Pump / Booster Set Maintenance', 'Mechanical & HVAC', 3, 'Water Supply Regulations 1999', 'high');

CREATE INDEX idx_asset_types_code ON compliance_asset_types(asset_type_code);
CREATE INDEX idx_asset_types_category ON compliance_asset_types(category);
CREATE INDEX idx_asset_types_priority ON compliance_asset_types(priority);

-- ----------------------------------------------------------------------------
-- Compliance Assets (Actual inspections/certificates)
-- ----------------------------------------------------------------------------
CREATE TABLE compliance_assets (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    building_id UUID REFERENCES buildings(id) ON DELETE CASCADE,
    asset_type_id UUID REFERENCES compliance_asset_types(id),

    -- Inspection Details
    inspection_date DATE,
    expiry_date DATE,
    next_due_date DATE,

    -- Status
    status VARCHAR(50), -- 'current', 'expired', 'missing', 'inferred'
    days_overdue INTEGER,

    -- Inspector/Company
    inspector_name VARCHAR(255),
    inspection_company VARCHAR(255),
    certificate_number VARCHAR(100),

    -- Documents
    document_name VARCHAR(500),
    document_path TEXT,
    document_url TEXT,
    vault_file_id UUID, -- Link to file storage

    -- Inference (for missing assets)
    is_inferred BOOLEAN DEFAULT false,
    inference_reason TEXT,
    last_known_inspection DATE,
    evidence_found BOOLEAN,

    -- Metadata
    source_document VARCHAR(500),
    data_quality VARCHAR(50),
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW(),
    deleted_at TIMESTAMPTZ
);

CREATE INDEX idx_compliance_building ON compliance_assets(building_id);
CREATE INDEX idx_compliance_type ON compliance_assets(asset_type_id);
CREATE INDEX idx_compliance_status ON compliance_assets(status);
CREATE INDEX idx_compliance_expiry ON compliance_assets(expiry_date);
CREATE INDEX idx_compliance_next_due ON compliance_assets(next_due_date);

-- ============================================================================
-- MAINTENANCE CONTRACTS
-- ============================================================================

-- ----------------------------------------------------------------------------
-- Contract Types (Reference table)
-- ----------------------------------------------------------------------------
CREATE TABLE contract_types (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),

    contract_type_code VARCHAR(50) UNIQUE NOT NULL,
    contract_type_name VARCHAR(255) NOT NULL,
    category VARCHAR(100),

    -- Links to compliance
    compliance_asset_type_id UUID REFERENCES compliance_asset_types(id),

    keywords TEXT[],

    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Pre-populate known contract types
INSERT INTO contract_types (contract_type_code, contract_type_name, category) VALUES
('LIFT_MAINTENANCE', 'Lift Maintenance', 'Building Services'),
('FIRE_ALARM', 'Fire Alarm Maintenance', 'Fire Safety'),
('CLEANING', 'Cleaning Contract', 'Facilities'),
('GARDENING', 'Gardening / Grounds Maintenance', 'Facilities'),
('PEST_CONTROL', 'Pest Control', 'Facilities'),
('WATER_HYGIENE', 'Water Hygiene / Legionella', 'Water Hygiene'),
('CCTV', 'CCTV Maintenance', 'Security'),
('DOOR_ENTRY', 'Door Entry System', 'Building Services'),
('POOL', 'Swimming Pool Maintenance', 'Facilities'),
('GYM', 'Gym Equipment Maintenance', 'Facilities'),
('EV_CHARGING', 'EV Charging Maintenance', 'Building Services');

-- ----------------------------------------------------------------------------
-- Maintenance Contracts
-- ----------------------------------------------------------------------------
CREATE TABLE maintenance_contracts (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    building_id UUID REFERENCES buildings(id) ON DELETE CASCADE,
    contract_type_id UUID REFERENCES contract_types(id),

    -- Contractor
    contractor_name VARCHAR(255) NOT NULL,
    contractor_company VARCHAR(255),
    contractor_email VARCHAR(255),
    contractor_phone VARCHAR(50),
    contractor_address TEXT,

    -- Contract Details
    contract_reference VARCHAR(100),
    contract_start_date DATE,
    contract_end_date DATE,
    contract_auto_renew BOOLEAN DEFAULT false,
    renewal_notice_days INTEGER,

    -- Financial
    contract_value_annual NUMERIC(12,2),
    contract_value_total NUMERIC(12,2),
    payment_frequency VARCHAR(50), -- 'Monthly', 'Quarterly', 'Annual'
    currency VARCHAR(3) DEFAULT 'GBP',

    -- Service Details
    maintenance_frequency VARCHAR(100), -- 'Weekly', 'Monthly', 'Quarterly', etc.
    service_level_agreement TEXT,

    -- Status
    contract_status VARCHAR(50), -- 'Active', 'Expired', 'Pending', 'Cancelled'

    -- Documents
    contract_document_path TEXT,
    contract_document_url TEXT,
    vault_file_id UUID,

    -- Detection Metadata (from adaptive system)
    detection_confidence NUMERIC(3,2),
    is_new_type BOOLEAN DEFAULT false,
    requires_review BOOLEAN DEFAULT false,

    -- Metadata
    source_folder VARCHAR(500),
    data_quality VARCHAR(50),
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW(),
    deleted_at TIMESTAMPTZ
);

CREATE INDEX idx_contracts_building ON maintenance_contracts(building_id);
CREATE INDEX idx_contracts_type ON maintenance_contracts(contract_type_id);
CREATE INDEX idx_contracts_contractor ON maintenance_contracts(contractor_name);
CREATE INDEX idx_contracts_status ON maintenance_contracts(contract_status);
CREATE INDEX idx_contracts_end_date ON maintenance_contracts(contract_end_date);

-- ============================================================================
-- FINANCIAL DATA
-- ============================================================================

-- ----------------------------------------------------------------------------
-- Service Charge Budgets
-- ----------------------------------------------------------------------------
CREATE TABLE budgets (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    building_id UUID REFERENCES buildings(id) ON DELETE CASCADE,

    -- Budget Period
    budget_year INTEGER NOT NULL,
    budget_period_start DATE,
    budget_period_end DATE,

    -- Totals
    total_budget NUMERIC(12,2),
    total_actual NUMERIC(12,2),
    variance NUMERIC(12,2),

    -- Status
    status VARCHAR(50), -- 'Draft', 'Approved', 'Final'
    approved_date DATE,
    approved_by VARCHAR(255),

    -- Metadata
    source_document VARCHAR(500),
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW(),

    UNIQUE(building_id, budget_year)
);

CREATE INDEX idx_budgets_building ON budgets(building_id);
CREATE INDEX idx_budgets_year ON budgets(budget_year);

-- ----------------------------------------------------------------------------
-- Budget Line Items
-- ----------------------------------------------------------------------------
CREATE TABLE budget_line_items (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    budget_id UUID REFERENCES budgets(id) ON DELETE CASCADE,

    -- Line Item Details
    category VARCHAR(255),
    subcategory VARCHAR(255),
    description TEXT,

    -- Amounts
    budgeted_amount NUMERIC(12,2),
    actual_amount NUMERIC(12,2),
    variance NUMERIC(12,2),
    variance_percentage NUMERIC(5,2),

    -- Links
    contract_id UUID REFERENCES maintenance_contracts(id),

    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX idx_budget_lines_budget ON budget_line_items(budget_id);
CREATE INDEX idx_budget_lines_category ON budget_line_items(category);

-- ----------------------------------------------------------------------------
-- Maintenance Schedules (for tracking service due dates)
-- ----------------------------------------------------------------------------
CREATE TABLE maintenance_schedules (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    building_id UUID REFERENCES buildings(id) ON DELETE CASCADE,
    contract_id UUID REFERENCES maintenance_contracts(id) ON DELETE CASCADE,
    
    -- Schedule Details
    service_type VARCHAR(255), -- "Lift LOLER", "Fire Alarm Service", etc.
    frequency VARCHAR(50), -- "annual", "quarterly", "monthly", "biannual"
    frequency_months INTEGER, -- 12, 6, 3, 1
    
    -- Due Dates
    last_service_date DATE,
    next_due_date DATE,
    
    -- Status
    status VARCHAR(50), -- 'active', 'overdue', 'upcoming', 'cancelled'
    priority VARCHAR(20), -- 'critical', 'high', 'medium', 'low'
    
    -- Details
    description TEXT,
    estimated_duration VARCHAR(100),
    responsible_contractor VARCHAR(255),
    
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX idx_maintenance_schedules_building ON maintenance_schedules(building_id);
CREATE INDEX idx_maintenance_schedules_contract ON maintenance_schedules(contract_id);
CREATE INDEX idx_maintenance_schedules_next_due ON maintenance_schedules(next_due_date);
CREATE INDEX idx_maintenance_schedules_status ON maintenance_schedules(status);

-- ----------------------------------------------------------------------------
-- Leaseholder Accounts
-- ----------------------------------------------------------------------------
CREATE TABLE leaseholder_accounts (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    leaseholder_id UUID REFERENCES leaseholders(id) ON DELETE CASCADE,

    -- Account Details
    account_number VARCHAR(50),
    account_type VARCHAR(50), -- 'Service Charge', 'Major Works', 'Ground Rent'

    -- Balances
    opening_balance NUMERIC(12,2),
    current_balance NUMERIC(12,2),

    -- Status
    account_status VARCHAR(50), -- 'Active', 'In Arrears', 'Closed'
    is_in_arrears BOOLEAN DEFAULT false,

    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX idx_accounts_leaseholder ON leaseholder_accounts(leaseholder_id);
CREATE INDEX idx_accounts_arrears ON leaseholder_accounts(is_in_arrears) WHERE is_in_arrears = true;

-- ----------------------------------------------------------------------------
-- Insurance Policies
-- ----------------------------------------------------------------------------
CREATE TABLE insurance_policies (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    building_id UUID REFERENCES buildings(id) ON DELETE CASCADE,

    -- Policy Details
    policy_type VARCHAR(100), -- 'Buildings', 'Public Liability', 'Employers Liability'
    policy_number VARCHAR(100),
    insurer VARCHAR(255),
    broker VARCHAR(255),

    -- Coverage
    coverage_amount NUMERIC(15,2),
    excess NUMERIC(12,2),

    -- Dates
    policy_start_date DATE,
    policy_end_date DATE,
    renewal_date DATE,

    -- Premium
    annual_premium NUMERIC(12,2),

    -- Status
    policy_status VARCHAR(50), -- 'Active', 'Expired', 'Cancelled'

    -- Documents
    policy_document_path TEXT,
    vault_file_id UUID,

    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX idx_insurance_building ON insurance_policies(building_id);
CREATE INDEX idx_insurance_end_date ON insurance_policies(policy_end_date);

-- ============================================================================
-- DOCUMENTS & FILES
-- ============================================================================

-- ----------------------------------------------------------------------------
-- Document Registry
-- ----------------------------------------------------------------------------
CREATE TABLE documents (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    building_id UUID REFERENCES buildings(id) ON DELETE CASCADE,

    -- Document Details
    document_name VARCHAR(500) NOT NULL,
    document_type VARCHAR(100), -- 'Lease', 'Certificate', 'Contract', 'Report', etc.
    document_category VARCHAR(100),

    -- File Details
    file_path TEXT,
    file_size_bytes BIGINT,
    file_extension VARCHAR(10),
    mime_type VARCHAR(100),

    -- Storage
    vault_file_id UUID, -- Link to Supabase Storage
    storage_bucket VARCHAR(100),
    storage_path TEXT,

    -- Metadata
    upload_date TIMESTAMPTZ,
    document_date DATE,

    -- Links
    unit_id UUID REFERENCES units(id),
    leaseholder_id UUID REFERENCES leaseholders(id),
    compliance_asset_id UUID REFERENCES compliance_assets(id),
    contract_id UUID REFERENCES maintenance_contracts(id),

    -- Search
    full_text_content TEXT,
    keywords TEXT[],

    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW(),
    deleted_at TIMESTAMPTZ
);

CREATE INDEX idx_documents_building ON documents(building_id);
CREATE INDEX idx_documents_type ON documents(document_type);
CREATE INDEX idx_documents_unit ON documents(unit_id);
CREATE INDEX idx_documents_leaseholder ON documents(leaseholder_id);
CREATE INDEX idx_documents_compliance ON documents(compliance_asset_id);
CREATE INDEX idx_documents_contract ON documents(contract_id);

-- Full-text search index
CREATE INDEX idx_documents_fulltext ON documents USING gin(to_tsvector('english', full_text_content));

-- ============================================================================
-- EXTRACTION METADATA & AUDIT
-- ============================================================================

-- ----------------------------------------------------------------------------
-- Extraction Runs (Track each extraction)
-- ----------------------------------------------------------------------------
CREATE TABLE extraction_runs (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    building_id UUID REFERENCES buildings(id) ON DELETE CASCADE,

    -- Run Details
    extraction_date TIMESTAMPTZ NOT NULL,
    extraction_version VARCHAR(50),

    -- Results
    units_extracted INTEGER,
    leaseholders_extracted INTEGER,
    compliance_assets_extracted INTEGER,
    contracts_extracted INTEGER,
    documents_extracted INTEGER,

    -- Quality
    data_quality VARCHAR(50),
    confidence_score NUMERIC(3,2),

    -- Adaptive Detection Results
    new_types_discovered INTEGER,
    low_confidence_detections INTEGER,

    -- Source
    source_folder VARCHAR(500),

    -- Status
    extraction_status VARCHAR(50), -- 'Success', 'Failed', 'Partial'
    error_message TEXT,

    created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX idx_extraction_building ON extraction_runs(building_id);
CREATE INDEX idx_extraction_date ON extraction_runs(extraction_date);

-- ----------------------------------------------------------------------------
-- Audit Log
-- ----------------------------------------------------------------------------
CREATE TABLE audit_log (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),

    -- Action Details
    table_name VARCHAR(100) NOT NULL,
    record_id UUID NOT NULL,
    action VARCHAR(20) NOT NULL, -- 'INSERT', 'UPDATE', 'DELETE'

    -- Changes
    old_values JSONB,
    new_values JSONB,

    -- User (for UI application)
    user_id UUID,
    user_email VARCHAR(255),

    -- Metadata
    ip_address INET,
    user_agent TEXT,

    created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX idx_audit_table ON audit_log(table_name);
CREATE INDEX idx_audit_record ON audit_log(record_id);
CREATE INDEX idx_audit_date ON audit_log(created_at);
CREATE INDEX idx_audit_user ON audit_log(user_id);

-- ============================================================================
-- VIEWS FOR COMMON QUERIES
-- ============================================================================

-- ----------------------------------------------------------------------------
-- Building Summary View
-- ----------------------------------------------------------------------------
CREATE OR REPLACE VIEW vw_building_summary AS
SELECT
    b.id,
    b.building_name,
    b.postcode,
    b.num_units,

    -- Leaseholder Stats
    COUNT(DISTINCT l.id) as total_leaseholders,
    COUNT(DISTINCT CASE WHEN l.current_balance != 0 THEN l.id END) as leaseholders_with_balance,
    SUM(l.current_balance) as total_outstanding_balance,

    -- Compliance Stats
    COUNT(DISTINCT ca.id) FILTER (WHERE ca.status = 'current') as current_compliance_assets,
    COUNT(DISTINCT ca.id) FILTER (WHERE ca.status = 'expired') as expired_compliance_assets,
    COUNT(DISTINCT ca.id) FILTER (WHERE ca.status = 'missing') as missing_compliance_assets,

    -- Contract Stats
    COUNT(DISTINCT mc.id) as total_contracts,
    COUNT(DISTINCT mc.id) FILTER (WHERE mc.contract_status = 'Active') as active_contracts,

    b.created_at,
    b.updated_at
FROM buildings b
LEFT JOIN units u ON b.id = u.building_id AND u.deleted_at IS NULL
LEFT JOIN leaseholders l ON u.id = l.unit_id AND l.deleted_at IS NULL
LEFT JOIN compliance_assets ca ON b.id = ca.building_id AND ca.deleted_at IS NULL
LEFT JOIN maintenance_contracts mc ON b.id = mc.building_id AND mc.deleted_at IS NULL
WHERE b.deleted_at IS NULL
GROUP BY b.id;

-- ----------------------------------------------------------------------------
-- Compliance Dashboard View
-- ----------------------------------------------------------------------------
CREATE OR REPLACE VIEW vw_compliance_dashboard AS
SELECT
    b.id as building_id,
    b.building_name,
    cat.category,
    cat.priority,

    COUNT(DISTINCT ca.id) as total_assets,
    COUNT(DISTINCT ca.id) FILTER (WHERE ca.status = 'current') as current_assets,
    COUNT(DISTINCT ca.id) FILTER (WHERE ca.status = 'expired') as expired_assets,
    COUNT(DISTINCT ca.id) FILTER (WHERE ca.status = 'missing') as missing_assets,

    MIN(ca.next_due_date) as next_due_date,
    MAX(ca.days_overdue) as max_days_overdue

FROM buildings b
LEFT JOIN compliance_assets ca ON b.id = ca.building_id AND ca.deleted_at IS NULL
LEFT JOIN compliance_asset_types cat ON ca.asset_type_id = cat.id
WHERE b.deleted_at IS NULL
GROUP BY b.id, b.building_name, cat.category, cat.priority;

-- ----------------------------------------------------------------------------
-- Contract Expiry View
-- ----------------------------------------------------------------------------
CREATE OR REPLACE VIEW vw_contracts_expiring_soon AS
SELECT
    mc.id,
    b.building_name,
    ct.contract_type_name,
    mc.contractor_name,
    mc.contract_end_date,
    mc.contract_auto_renew,
    (mc.contract_end_date - CURRENT_DATE) as days_until_expiry
FROM maintenance_contracts mc
JOIN buildings b ON mc.building_id = b.id
JOIN contract_types ct ON mc.contract_type_id = ct.id
WHERE mc.contract_status = 'Active'
    AND mc.contract_end_date <= CURRENT_DATE + INTERVAL '90 days'
    AND mc.deleted_at IS NULL
    AND b.deleted_at IS NULL
ORDER BY mc.contract_end_date;

-- ============================================================================
-- FUNCTIONS & TRIGGERS
-- ============================================================================

-- ----------------------------------------------------------------------------
-- Update timestamp trigger function
-- ----------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Apply to all tables with updated_at column
CREATE TRIGGER update_buildings_updated_at BEFORE UPDATE ON buildings
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_units_updated_at BEFORE UPDATE ON units
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_leaseholders_updated_at BEFORE UPDATE ON leaseholders
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_compliance_updated_at BEFORE UPDATE ON compliance_assets
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_contracts_updated_at BEFORE UPDATE ON maintenance_contracts
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- ----------------------------------------------------------------------------
-- Calculate compliance rate function
-- ----------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION calculate_compliance_rate(p_building_id UUID)
RETURNS NUMERIC AS $$
DECLARE
    v_current_count INTEGER;
    v_total_required INTEGER;
BEGIN
    SELECT
        COUNT(*) FILTER (WHERE status = 'current'),
        COUNT(*)
    INTO v_current_count, v_total_required
    FROM compliance_assets
    WHERE building_id = p_building_id
        AND deleted_at IS NULL;

    IF v_total_required = 0 THEN
        RETURN 0;
    END IF;

    RETURN ROUND((v_current_count::NUMERIC / v_total_required::NUMERIC) * 100, 1);
END;
$$ LANGUAGE plpgsql;

-- ============================================================================
-- ROW LEVEL SECURITY (RLS) - Optional, for multi-tenancy
-- ============================================================================

-- Enable RLS on key tables (uncomment when ready)
-- ALTER TABLE buildings ENABLE ROW LEVEL SECURITY;
-- ALTER TABLE units ENABLE ROW LEVEL SECURITY;
-- ALTER TABLE leaseholders ENABLE ROW LEVEL SECURITY;
-- ALTER TABLE compliance_assets ENABLE ROW LEVEL SECURITY;
-- ALTER TABLE maintenance_contracts ENABLE ROW LEVEL SECURITY;

-- Example policy (adjust based on your auth setup)
-- CREATE POLICY "Users can view their own buildings" ON buildings
--     FOR SELECT USING (auth.uid() = user_id);

-- ============================================================================
-- COMMENTS FOR DOCUMENTATION
-- ============================================================================

COMMENT ON TABLE buildings IS 'Core building/property entity. Parent for all other data.';
COMMENT ON TABLE units IS 'Individual units within buildings (flats, apartments, commercial units).';
COMMENT ON TABLE leaseholders IS 'Leaseholder/tenant information linked to units.';
COMMENT ON TABLE compliance_assets IS 'Compliance inspections, certificates, and regulatory requirements.';
COMMENT ON TABLE compliance_asset_types IS 'Reference table of 50+ UK compliance asset types.';
COMMENT ON TABLE maintenance_contracts IS 'Maintenance contracts with contractors.';
COMMENT ON TABLE contract_types IS 'Reference table of maintenance contract types.';
COMMENT ON TABLE budgets IS 'Annual service charge budgets.';
COMMENT ON TABLE budget_line_items IS 'Individual line items within budgets.';
COMMENT ON TABLE documents IS 'Document registry linking files to buildings, units, etc.';
COMMENT ON TABLE extraction_runs IS 'Metadata about each extraction run for audit purposes.';

-- ============================================================================
-- END OF SCHEMA
-- ============================================================================
