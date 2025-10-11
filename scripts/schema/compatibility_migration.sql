-- Compatibility Migration: Safe schema additions and view creation
-- Run this to ensure schema matches generator expectations
-- All operations are idempotent (IF NOT EXISTS)

-- ========================================================================
-- 1. ADD MISSING COLUMNS (IF NOT EXISTS)
-- ========================================================================

-- Buildings
ALTER TABLE IF EXISTS buildings ADD COLUMN IF NOT EXISTS full_address TEXT;
ALTER TABLE IF EXISTS buildings ADD COLUMN IF NOT EXISTS address_line1 TEXT;
ALTER TABLE IF EXISTS buildings ADD COLUMN IF NOT EXISTS address_line2 TEXT;
ALTER TABLE IF EXISTS buildings ADD COLUMN IF NOT EXISTS city TEXT;
ALTER TABLE IF EXISTS buildings ADD COLUMN IF NOT EXISTS region TEXT;
ALTER TABLE IF EXISTS buildings ADD COLUMN IF NOT EXISTS total_units INT;
ALTER TABLE IF EXISTS buildings ADD COLUMN IF NOT EXISTS year_built INT;
ALTER TABLE IF EXISTS buildings ADD COLUMN IF NOT EXISTS managing_agent TEXT;
ALTER TABLE IF EXISTS buildings ADD COLUMN IF NOT EXISTS portfolio TEXT;

-- Units
ALTER TABLE IF EXISTS units ADD COLUMN IF NOT EXISTS level TEXT;

-- Leaseholders
ALTER TABLE IF EXISTS leaseholders ADD COLUMN IF NOT EXISTS email TEXT;
ALTER TABLE IF EXISTS leaseholders ADD COLUMN IF NOT EXISTS phone TEXT;

-- Leases
ALTER TABLE IF EXISTS leases ADD COLUMN IF NOT EXISTS term_years INT;
ALTER TABLE IF EXISTS leases ADD COLUMN IF NOT EXISTS ground_rent_text TEXT;
ALTER TABLE IF EXISTS leases ADD COLUMN IF NOT EXISTS source_file TEXT;

-- Insurance Policies
ALTER TABLE IF EXISTS insurance_policies ADD COLUMN IF NOT EXISTS policy_type TEXT;
ALTER TABLE IF EXISTS insurance_policies ADD COLUMN IF NOT EXISTS source_file TEXT;

-- Compliance Assets
ALTER TABLE IF EXISTS compliance_assets ADD COLUMN IF NOT EXISTS confidence NUMERIC(3,2);
ALTER TABLE IF EXISTS compliance_assets ADD COLUMN IF NOT EXISTS provenance TEXT;
ALTER TABLE IF EXISTS compliance_assets ADD COLUMN IF NOT EXISTS has_evidence BOOLEAN DEFAULT FALSE;
ALTER TABLE IF EXISTS compliance_assets ADD COLUMN IF NOT EXISTS dates_missing BOOLEAN DEFAULT FALSE;
ALTER TABLE IF EXISTS compliance_assets ADD COLUMN IF NOT EXISTS source_file TEXT;

-- Documents (for archiving)
ALTER TABLE IF EXISTS documents ADD COLUMN IF NOT EXISTS status TEXT NOT NULL DEFAULT 'active';
ALTER TABLE IF EXISTS documents ADD COLUMN IF NOT EXISTS archive_reason TEXT;
ALTER TABLE IF EXISTS documents ADD COLUMN IF NOT EXISTS archived_at TIMESTAMPTZ;

-- Budget Items
ALTER TABLE IF EXISTS budget_items ADD COLUMN IF NOT EXISTS service_charge_year TEXT;
ALTER TABLE IF EXISTS budget_items ADD COLUMN IF NOT EXISTS heading TEXT;
ALTER TABLE IF EXISTS budget_items ADD COLUMN IF NOT EXISTS schedule TEXT;

-- Contractors
ALTER TABLE IF EXISTS contractors ADD COLUMN IF NOT EXISTS service_type TEXT;

-- Contracts
ALTER TABLE IF EXISTS contracts ADD COLUMN IF NOT EXISTS status TEXT;

-- ========================================================================
-- 2. CREATE COMPLIANCE REQUIREMENTS STATUS TABLE (IF NOT EXISTS)
-- ========================================================================

CREATE TABLE IF NOT EXISTS compliance_requirements_status (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    building_id UUID NOT NULL REFERENCES buildings(id) ON DELETE CASCADE,
    requirement_key TEXT NOT NULL,
    evidence_date DATE,
    expiry_date DATE,
    points NUMERIC(2,1) NOT NULL DEFAULT 0.0,
    source_doc_id UUID,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW(),
    UNIQUE(building_id, requirement_key)
);

CREATE INDEX IF NOT EXISTS idx_compliance_req_building
    ON compliance_requirements_status(building_id);

-- ========================================================================
-- 3. CREATE UNIQUE INDEXES FOR UPSERT KEYS (IDEMPOTENT)
-- ========================================================================

DO $$
BEGIN
    -- Buildings: name + postcode
    IF NOT EXISTS (
        SELECT 1 FROM pg_indexes
        WHERE schemaname='public' AND indexname='uniq_buildings_name_postcode'
    ) THEN
        CREATE UNIQUE INDEX uniq_buildings_name_postcode
            ON buildings (name, postcode);
    END IF;

    -- Units: building_id + unit_ref
    IF NOT EXISTS (
        SELECT 1 FROM pg_indexes
        WHERE schemaname='public' AND indexname='uniq_units_building_unitref'
    ) THEN
        CREATE UNIQUE INDEX uniq_units_building_unitref
            ON units (building_id, unit_ref);
    END IF;

    -- Leases: unit_id + start_date + source_file
    IF NOT EXISTS (
        SELECT 1 FROM pg_indexes
        WHERE schemaname='public' AND indexname='uniq_leases_unit_start_source'
    ) THEN
        CREATE UNIQUE INDEX uniq_leases_unit_start_source
            ON leases (unit_id, start_date, COALESCE(source_file, ''));
    END IF;

    -- Insurance: building_id + policy_number + period_start
    IF NOT EXISTS (
        SELECT 1 FROM pg_indexes
        WHERE schemaname='public' AND indexname='uniq_insurance_building_policy_start'
    ) THEN
        CREATE UNIQUE INDEX uniq_insurance_building_policy_start
            ON insurance_policies (building_id, policy_number, period_start);
    END IF;

    -- Documents: building_id + filename
    IF NOT EXISTS (
        SELECT 1 FROM pg_indexes
        WHERE schemaname='public' AND indexname='uniq_docs_building_filename'
    ) THEN
        CREATE UNIQUE INDEX uniq_docs_building_filename
            ON documents (building_id, filename);
    END IF;

    -- Compliance Assets: building_id + name + COALESCE(next_due)
    IF NOT EXISTS (
        SELECT 1 FROM pg_indexes
        WHERE schemaname='public' AND indexname='uniq_compliance_building_name_due'
    ) THEN
        CREATE UNIQUE INDEX uniq_compliance_building_name_due
            ON compliance_assets (building_id, name, COALESCE(next_due, '1900-01-01'::DATE));
    END IF;
END $$;

-- ========================================================================
-- 4. CREATE/REPLACE REPORTING VIEWS
-- ========================================================================

-- Insurance Certificates (certificates only, no policy wordings)
CREATE OR REPLACE VIEW v_insurance_certificates AS
SELECT p.*
FROM insurance_policies p
JOIN documents d
  ON d.building_id = p.building_id
 AND d.category = 'insurance_certificate'
 AND d.status = 'active'
 AND (p.source_file = d.filename OR p.source_file IS NULL);

-- Compliance Rollup (OK/Overdue/Unknown counts)
CREATE OR REPLACE VIEW v_compliance_rollup AS
SELECT
    building_id,
    COUNT(*) as total_assets,
    COUNT(*) FILTER (WHERE status = 'OK') as ok_count,
    COUNT(*) FILTER (WHERE status = 'Overdue') as overdue_count,
    COUNT(*) FILTER (WHERE status = 'Unknown' OR status IS NULL) as unknown_count,
    ROUND(100.0 * COUNT(*) FILTER (WHERE status = 'OK') / NULLIF(COUNT(*), 0), 1) as ok_pct
FROM compliance_assets
GROUP BY building_id;

-- Lease Coverage (distinct units with leases / total units)
CREATE OR REPLACE VIEW v_lease_coverage AS
WITH leased_units AS (
    SELECT DISTINCT u.building_id, u.id as unit_id
    FROM units u
    JOIN leases l ON l.unit_id = u.id
)
SELECT
    b.id as building_id,
    (SELECT COUNT(*) FROM units u WHERE u.building_id = b.id) as total_units,
    (SELECT COUNT(*) FROM leased_units lu WHERE lu.building_id = b.id) as leased_units,
    ROUND(
        100.0 * (SELECT COUNT(*) FROM leased_units lu WHERE lu.building_id = b.id)
        / NULLIF((SELECT COUNT(*) FROM units u WHERE u.building_id = b.id), 0),
        1
    ) as lease_pct
FROM buildings b;

-- Budget Years (distinct years with totals)
CREATE OR REPLACE VIEW v_budget_years AS
SELECT
    building_id,
    service_charge_year,
    COUNT(*) as line_count,
    COALESCE(SUM(amount), 0)::NUMERIC(14,2) as total_amount
FROM budget_items
WHERE service_charge_year IS NOT NULL
GROUP BY building_id, service_charge_year
ORDER BY
    CASE
        WHEN service_charge_year ~ '^\d{4}'
        THEN SUBSTRING(service_charge_year FROM '^\d{4}')::INT
        ELSE 0
    END DESC NULLS LAST;

-- Required Compliance Score (required items only, 0-100 scale)
CREATE OR REPLACE VIEW v_required_compliance_score AS
SELECT
    building_id,
    COUNT(*) as required_items,
    ROUND(100.0 * SUM(points) / NULLIF(COUNT(*), 0), 1) as req_score
FROM compliance_requirements_status
GROUP BY building_id;

-- Building Health Score (composite)
CREATE OR REPLACE VIEW v_building_health_score AS
SELECT
    b.id as building_id,
    b.name,
    COALESCE(cr.req_score, 0) as compliance_score,
    COALESCE(lc.lease_pct, 0) as lease_coverage_pct,
    COALESCE(cr.required_items, 0) as compliance_items,
    COALESCE(lc.leased_units, 0) as leased_units,
    -- Simple weighted health score: 70% compliance + 30% leases
    ROUND(
        (COALESCE(cr.req_score, 0) * 0.7 + COALESCE(lc.lease_pct, 0) * 0.3),
        1
    ) as health_score
FROM buildings b
LEFT JOIN v_required_compliance_score cr ON cr.building_id = b.id
LEFT JOIN v_lease_coverage lc ON lc.building_id = b.id;

-- ========================================================================
-- DONE
-- ========================================================================

\echo '✅ Compatibility migration completed'
\echo '   - Added missing columns (IF NOT EXISTS)'
\echo '   - Created unique indexes for UPSERT keys'
\echo '   - Created/replaced reporting views'
