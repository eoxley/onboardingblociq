-- ============================================================
-- CREATE lease_clauses TABLE
-- Purpose: Store individual lease clauses for traceability
-- ============================================================

CREATE TABLE IF NOT EXISTS lease_clauses (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    lease_id uuid NOT NULL REFERENCES leases(id) ON DELETE CASCADE,
    building_id uuid NOT NULL REFERENCES buildings(id) ON DELETE CASCADE,
    clause_number text,  -- e.g., "1.1", "2.3.4"
    clause_category text,  -- rent, repair, insurance, service_charge, use, alterations, assignment, forfeiture, covenant, other
    clause_text text,  -- Full clause text (up to 1000 chars)
    clause_summary text,  -- Short summary (up to 100 chars)
    created_at timestamptz DEFAULT now(),
    updated_at timestamptz DEFAULT now()
);

-- Create indexes for performance
CREATE INDEX IF NOT EXISTS idx_lease_clauses_lease ON lease_clauses(lease_id);
CREATE INDEX IF NOT EXISTS idx_lease_clauses_building ON lease_clauses(building_id);
CREATE INDEX IF NOT EXISTS idx_lease_clauses_category ON lease_clauses(clause_category);

-- Add comments
COMMENT ON TABLE lease_clauses IS 'Individual lease clauses extracted from lease documents for traceability and analysis';
COMMENT ON COLUMN lease_clauses.clause_number IS 'Clause reference number from lease document (e.g., 1.1, 2.3)';
COMMENT ON COLUMN lease_clauses.clause_category IS 'Category: rent, repair, insurance, service_charge, use, alterations, assignment, forfeiture, covenant, other';
COMMENT ON COLUMN lease_clauses.clause_text IS 'Full text of the clause (up to 1000 characters)';
COMMENT ON COLUMN lease_clauses.clause_summary IS 'Brief summary of clause (up to 100 characters)';
