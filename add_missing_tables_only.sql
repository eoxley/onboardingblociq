-- ============================================================================
-- BlocIQ - Incremental Schema Migration (Add Missing Tables/Columns Only)
-- ============================================================================
-- Date: 2025-10-14
-- Purpose: Add new tables without affecting existing ones
-- Safe to run: Uses IF NOT EXISTS checks
-- ============================================================================

-- Enable UUID extension (safe if already exists)
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE EXTENSION IF NOT EXISTS "pgcrypto";

-- ============================================================================
-- ADD NEW TABLES (Only if they don't exist)
-- ============================================================================

-- ----------------------------------------------------------------------------
-- Agencies (Multi-Tenancy)
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS agencies (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name VARCHAR(255) NOT NULL,
    email VARCHAR(255),
    phone VARCHAR(50),
    address TEXT,
    website VARCHAR(255),
    logo_url TEXT,
    is_active BOOLEAN DEFAULT true,
    subscription_tier VARCHAR(50),
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_agencies_active ON agencies(is_active);

-- ----------------------------------------------------------------------------
-- Users (Staff)
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS users (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    agency_id UUID REFERENCES agencies(id) ON DELETE CASCADE,
    email VARCHAR(255) NOT NULL UNIQUE,
    full_name VARCHAR(255),
    role VARCHAR(50),
    auth_user_id UUID,
    is_active BOOLEAN DEFAULT true,
    last_login TIMESTAMPTZ,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_users_agency ON users(agency_id);
CREATE INDEX IF NOT EXISTS idx_users_email ON users(email);

-- ----------------------------------------------------------------------------
-- User Buildings
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS user_buildings (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID REFERENCES users(id) ON DELETE CASCADE,
    building_id UUID REFERENCES buildings(id) ON DELETE CASCADE,
    assigned_date DATE DEFAULT CURRENT_DATE,
    role VARCHAR(50),
    created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_user_buildings_user ON user_buildings(user_id);
CREATE INDEX IF NOT EXISTS idx_user_buildings_building ON user_buildings(building_id);

-- ----------------------------------------------------------------------------
-- Budget Line Items
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS budget_line_items (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    budget_id UUID REFERENCES budgets(id) ON DELETE CASCADE,
    category VARCHAR(255),
    subcategory VARCHAR(255),
    description TEXT,
    budgeted_amount NUMERIC(12,2),
    actual_amount NUMERIC(12,2),
    variance NUMERIC(12,2),
    variance_percentage NUMERIC(5,2),
    contract_id UUID REFERENCES maintenance_contracts(id),
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_budget_lines_budget ON budget_line_items(budget_id);
CREATE INDEX IF NOT EXISTS idx_budget_lines_category ON budget_line_items(category);

-- ----------------------------------------------------------------------------
-- Maintenance Schedules
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS maintenance_schedules (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    building_id UUID REFERENCES buildings(id) ON DELETE CASCADE,
    contract_id UUID REFERENCES maintenance_contracts(id) ON DELETE CASCADE,
    service_type VARCHAR(255),
    frequency VARCHAR(50),
    frequency_months INTEGER,
    last_service_date DATE,
    next_due_date DATE,
    status VARCHAR(50),
    priority VARCHAR(20),
    description TEXT,
    estimated_duration VARCHAR(100),
    responsible_contractor VARCHAR(255),
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_maintenance_schedules_building ON maintenance_schedules(building_id);
CREATE INDEX IF NOT EXISTS idx_maintenance_schedules_contract ON maintenance_schedules(contract_id);
CREATE INDEX IF NOT EXISTS idx_maintenance_schedules_next_due ON maintenance_schedules(next_due_date);
CREATE INDEX IF NOT EXISTS idx_maintenance_schedules_status ON maintenance_schedules(status);

-- ----------------------------------------------------------------------------
-- Contractors
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS contractors (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    company_name VARCHAR(255) NOT NULL,
    contact_person VARCHAR(255),
    email VARCHAR(255),
    phone VARCHAR(50),
    address TEXT,
    website VARCHAR(255),
    services_offered TEXT[],
    certifications TEXT[],
    is_active BOOLEAN DEFAULT true,
    rating NUMERIC(2,1),
    notes TEXT,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_contractors_active ON contractors(is_active);
CREATE INDEX IF NOT EXISTS idx_contractors_name ON contractors(company_name);

-- ----------------------------------------------------------------------------
-- Leases
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS leases (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    building_id UUID REFERENCES buildings(id) ON DELETE CASCADE,
    unit_id UUID REFERENCES units(id) ON DELETE CASCADE,
    leaseholder_id UUID REFERENCES leaseholders(id) ON DELETE SET NULL,
    title_number VARCHAR(50),
    lease_type VARCHAR(50),
    lease_start_date DATE,
    lease_end_date DATE,
    lease_term_years INTEGER,
    document_id UUID REFERENCES documents(id),
    source_document VARCHAR(500),
    document_location TEXT,
    page_count INTEGER,
    file_size_mb NUMERIC(10,2),
    extraction_timestamp TIMESTAMPTZ,
    extracted_successfully BOOLEAN DEFAULT false,
    ground_rent_annual NUMERIC(10,2),
    ground_rent_review_period INTEGER,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_leases_building ON leases(building_id);
CREATE INDEX IF NOT EXISTS idx_leases_unit ON leases(unit_id);
CREATE INDEX IF NOT EXISTS idx_leases_title ON leases(title_number);

-- ----------------------------------------------------------------------------
-- Major Works Projects
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS major_works_projects (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    building_id UUID REFERENCES buildings(id) ON DELETE CASCADE,
    project_name VARCHAR(255) NOT NULL,
    description TEXT,
    project_type VARCHAR(100),
    start_date DATE,
    completion_date DATE,
    planned_start DATE,
    planned_completion DATE,
    estimated_cost NUMERIC(15,2),
    actual_cost NUMERIC(15,2),
    s20_consultation_required BOOLEAN DEFAULT false,
    s20_consultation_completed BOOLEAN DEFAULT false,
    s20_documents_count INTEGER DEFAULT 0,
    status VARCHAR(50),
    priority VARCHAR(20),
    folder_path TEXT,
    total_documents INTEGER DEFAULT 0,
    contractor_id UUID REFERENCES contractors(id),
    contractor_name VARCHAR(255),
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_major_works_building ON major_works_projects(building_id);
CREATE INDEX IF NOT EXISTS idx_major_works_status ON major_works_projects(status);

-- ============================================================================
-- ADD MISSING COLUMNS TO EXISTING TABLES
-- ============================================================================

-- Add agency_id to buildings if it doesn't exist
DO $$ 
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM information_schema.columns 
        WHERE table_name='buildings' AND column_name='agency_id'
    ) THEN
        ALTER TABLE buildings ADD COLUMN agency_id UUID REFERENCES agencies(id) ON DELETE SET NULL;
    END IF;
END $$;

-- Add construction_type to buildings if it doesn't exist
DO $$ 
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM information_schema.columns 
        WHERE table_name='buildings' AND column_name='construction_type'
    ) THEN
        ALTER TABLE buildings ADD COLUMN construction_type VARCHAR(100);
    END IF;
END $$;

-- ============================================================================
-- SUCCESS!
-- ============================================================================

SELECT 'Schema migration complete! New tables added:' as message;
SELECT table_name FROM information_schema.tables 
WHERE table_schema = 'public' 
AND table_name IN ('agencies', 'users', 'user_buildings', 'budget_line_items', 
                   'maintenance_schedules', 'contractors', 'leases', 'major_works_projects')
ORDER BY table_name;

