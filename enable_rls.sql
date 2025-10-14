-- ============================================================================
-- Enable Row Level Security (RLS) and Create Policies
-- ============================================================================
-- This allows both public access (for now) and service_role access
-- You can customize these policies later for multi-tenant access
-- ============================================================================

-- Enable RLS on all tables
ALTER TABLE buildings ENABLE ROW LEVEL SECURITY;
ALTER TABLE building_blocks ENABLE ROW LEVEL SECURITY;
ALTER TABLE units ENABLE ROW LEVEL SECURITY;
ALTER TABLE leaseholders ENABLE ROW LEVEL SECURITY;
ALTER TABLE compliance_asset_types ENABLE ROW LEVEL SECURITY;
ALTER TABLE compliance_assets ENABLE ROW LEVEL SECURITY;
ALTER TABLE contract_types ENABLE ROW LEVEL SECURITY;
ALTER TABLE maintenance_contracts ENABLE ROW LEVEL SECURITY;
ALTER TABLE budgets ENABLE ROW LEVEL SECURITY;
ALTER TABLE budget_line_items ENABLE ROW LEVEL SECURITY;
ALTER TABLE leaseholder_accounts ENABLE ROW LEVEL SECURITY;
ALTER TABLE insurance_policies ENABLE ROW LEVEL SECURITY;
ALTER TABLE documents ENABLE ROW LEVEL SECURITY;
ALTER TABLE extraction_runs ENABLE ROW LEVEL SECURITY;
ALTER TABLE audit_log ENABLE ROW LEVEL SECURITY;

-- ============================================================================
-- Create permissive policies (allow all operations for now)
-- Later you can restrict these based on user authentication
-- ============================================================================

-- Buildings
CREATE POLICY "Enable read access for all users" ON buildings FOR SELECT USING (true);
CREATE POLICY "Enable insert access for all users" ON buildings FOR INSERT WITH CHECK (true);
CREATE POLICY "Enable update access for all users" ON buildings FOR UPDATE USING (true);
CREATE POLICY "Enable delete access for all users" ON buildings FOR DELETE USING (true);

-- Building Blocks
CREATE POLICY "Enable read access for all users" ON building_blocks FOR SELECT USING (true);
CREATE POLICY "Enable insert access for all users" ON building_blocks FOR INSERT WITH CHECK (true);
CREATE POLICY "Enable update access for all users" ON building_blocks FOR UPDATE USING (true);
CREATE POLICY "Enable delete access for all users" ON building_blocks FOR DELETE USING (true);

-- Units
CREATE POLICY "Enable read access for all users" ON units FOR SELECT USING (true);
CREATE POLICY "Enable insert access for all users" ON units FOR INSERT WITH CHECK (true);
CREATE POLICY "Enable update access for all users" ON units FOR UPDATE USING (true);
CREATE POLICY "Enable delete access for all users" ON units FOR DELETE USING (true);

-- Leaseholders
CREATE POLICY "Enable read access for all users" ON leaseholders FOR SELECT USING (true);
CREATE POLICY "Enable insert access for all users" ON leaseholders FOR INSERT WITH CHECK (true);
CREATE POLICY "Enable update access for all users" ON leaseholders FOR UPDATE USING (true);
CREATE POLICY "Enable delete access for all users" ON leaseholders FOR DELETE USING (true);

-- Compliance Asset Types (Reference table - read-only for most users)
CREATE POLICY "Enable read access for all users" ON compliance_asset_types FOR SELECT USING (true);
CREATE POLICY "Enable insert access for all users" ON compliance_asset_types FOR INSERT WITH CHECK (true);
CREATE POLICY "Enable update access for all users" ON compliance_asset_types FOR UPDATE USING (true);
CREATE POLICY "Enable delete access for all users" ON compliance_asset_types FOR DELETE USING (true);

-- Compliance Assets
CREATE POLICY "Enable read access for all users" ON compliance_assets FOR SELECT USING (true);
CREATE POLICY "Enable insert access for all users" ON compliance_assets FOR INSERT WITH CHECK (true);
CREATE POLICY "Enable update access for all users" ON compliance_assets FOR UPDATE USING (true);
CREATE POLICY "Enable delete access for all users" ON compliance_assets FOR DELETE USING (true);

-- Contract Types (Reference table)
CREATE POLICY "Enable read access for all users" ON contract_types FOR SELECT USING (true);
CREATE POLICY "Enable insert access for all users" ON contract_types FOR INSERT WITH CHECK (true);
CREATE POLICY "Enable update access for all users" ON contract_types FOR UPDATE USING (true);
CREATE POLICY "Enable delete access for all users" ON contract_types FOR DELETE USING (true);

-- Maintenance Contracts
CREATE POLICY "Enable read access for all users" ON maintenance_contracts FOR SELECT USING (true);
CREATE POLICY "Enable insert access for all users" ON maintenance_contracts FOR INSERT WITH CHECK (true);
CREATE POLICY "Enable update access for all users" ON maintenance_contracts FOR UPDATE USING (true);
CREATE POLICY "Enable delete access for all users" ON maintenance_contracts FOR DELETE USING (true);

-- Budgets
CREATE POLICY "Enable read access for all users" ON budgets FOR SELECT USING (true);
CREATE POLICY "Enable insert access for all users" ON budgets FOR INSERT WITH CHECK (true);
CREATE POLICY "Enable update access for all users" ON budgets FOR UPDATE USING (true);
CREATE POLICY "Enable delete access for all users" ON budgets FOR DELETE USING (true);

-- Budget Line Items
CREATE POLICY "Enable read access for all users" ON budget_line_items FOR SELECT USING (true);
CREATE POLICY "Enable insert access for all users" ON budget_line_items FOR INSERT WITH CHECK (true);
CREATE POLICY "Enable update access for all users" ON budget_line_items FOR UPDATE USING (true);
CREATE POLICY "Enable delete access for all users" ON budget_line_items FOR DELETE USING (true);

-- Leaseholder Accounts
CREATE POLICY "Enable read access for all users" ON leaseholder_accounts FOR SELECT USING (true);
CREATE POLICY "Enable insert access for all users" ON leaseholder_accounts FOR INSERT WITH CHECK (true);
CREATE POLICY "Enable update access for all users" ON leaseholder_accounts FOR UPDATE USING (true);
CREATE POLICY "Enable delete access for all users" ON leaseholder_accounts FOR DELETE USING (true);

-- Insurance Policies
CREATE POLICY "Enable read access for all users" ON insurance_policies FOR SELECT USING (true);
CREATE POLICY "Enable insert access for all users" ON insurance_policies FOR INSERT WITH CHECK (true);
CREATE POLICY "Enable update access for all users" ON insurance_policies FOR UPDATE USING (true);
CREATE POLICY "Enable delete access for all users" ON insurance_policies FOR DELETE USING (true);

-- Documents
CREATE POLICY "Enable read access for all users" ON documents FOR SELECT USING (true);
CREATE POLICY "Enable insert access for all users" ON documents FOR INSERT WITH CHECK (true);
CREATE POLICY "Enable update access for all users" ON documents FOR UPDATE USING (true);
CREATE POLICY "Enable delete access for all users" ON documents FOR DELETE USING (true);

-- Extraction Runs
CREATE POLICY "Enable read access for all users" ON extraction_runs FOR SELECT USING (true);
CREATE POLICY "Enable insert access for all users" ON extraction_runs FOR INSERT WITH CHECK (true);
CREATE POLICY "Enable update access for all users" ON extraction_runs FOR UPDATE USING (true);
CREATE POLICY "Enable delete access for all users" ON extraction_runs FOR DELETE USING (true);

-- Audit Log
CREATE POLICY "Enable read access for all users" ON audit_log FOR SELECT USING (true);
CREATE POLICY "Enable insert access for all users" ON audit_log FOR INSERT WITH CHECK (true);
CREATE POLICY "Enable update access for all users" ON audit_log FOR UPDATE USING (true);
CREATE POLICY "Enable delete access for all users" ON audit_log FOR DELETE USING (true);

-- ============================================================================
-- COMPLETE
-- ============================================================================
-- RLS is now enabled with permissive policies
-- All authenticated and anonymous users can read/write all data
-- You can customize these policies later for multi-tenant access
-- ============================================================================
