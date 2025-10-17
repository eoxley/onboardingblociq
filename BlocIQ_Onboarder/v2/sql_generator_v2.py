"""
SQL Generator V2
================
Generates schema-correct SQL from extracted_data
Handles foreign keys, dependencies, proper escaping
"""

import json
import uuid
from typing import Dict, List, Any
from datetime import datetime


class SQLGeneratorV2:
    """
    Generate complete SQL migration from extracted data
    Handles all tables, foreign keys, proper ordering
    """
    
    def __init__(self, extracted_data: Dict):
        self.data = extracted_data
        self.building_id = str(uuid.uuid4())
        self.sql_statements = []
    
    def generate(self) -> str:
        """Generate complete SQL migration"""
        
        # Header
        self.sql_statements.append("-- BlocIQ V2 Complete Building Migration")
        self.sql_statements.append(f"-- Generated: {datetime.now().isoformat()}")
        self.sql_statements.append(f"-- Building: {self.data['building'].get('name', 'Unknown')}")
        self.sql_statements.append("")
        
        # Generate in dependency order (parent → children)
        self._generate_building()
        self._generate_units()  # Creates units + leaseholders
        self._generate_budgets()  # Creates budgets + line items
        self._generate_compliance_assets()
        # self._generate_asset_register()  # DISABLED - Table doesn't exist in Supabase schema
        self._generate_contracts()
        self._generate_insurance_policies()  # ADDED - Critical for insurance data
        self._generate_accounts()
        self._generate_leases()
        self._generate_contractors()
        
        return '\n'.join(self.sql_statements)
    
    def _generate_building(self):
        """Generate building INSERT - SCHEMA ALIGNED"""
        building = self.data['building']
        
        self.sql_statements.append("-- Building")
        self.sql_statements.append("INSERT INTO buildings (")
        self.sql_statements.append("    id, building_name, building_address, postcode,")
        self.sql_statements.append("    num_units, num_floors,")
        self.sql_statements.append("    building_height_meters,")
        self.sql_statements.append("    bsa_registration_required, bsa_status,")
        self.sql_statements.append("    construction_type, construction_era")
        self.sql_statements.append(") VALUES (")
        self.sql_statements.append(f"    '{self.building_id}',")
        self.sql_statements.append(f"    {self._quote(building.get('name', 'Unknown'))},")
        self.sql_statements.append(f"    {self._quote(building.get('address'))},")
        self.sql_statements.append(f"    {self._quote(building.get('postcode'))},")
        self.sql_statements.append(f"    {len(self.data.get('units', []))},")
        self.sql_statements.append(f"    {building.get('number_of_floors') or 'NULL'},")
        self.sql_statements.append(f"    {building.get('building_height_meters') or 'NULL'},")
        self.sql_statements.append(f"    {self._bool(building.get('is_hrb', False))},")
        self.sql_statements.append(f"    {self._quote(building.get('bsa_status', 'Not HRB'))},")
        self.sql_statements.append(f"    {self._quote(building.get('construction_type'))},")
        self.sql_statements.append(f"    {self._quote(building.get('construction_era'))}")
        self.sql_statements.append(") ON CONFLICT (id) DO NOTHING;")
        self.sql_statements.append("")
    
    def _generate_units(self):
        """Generate units INSERTs - SCHEMA ALIGNED"""
        units = self.data.get('units', [])
        
        if not units:
            return
        
        self.sql_statements.append(f"-- Units ({len(units)})")
        
        # Store unit_id mapping for leaseholders
        self.unit_id_map = {}
        
        for unit in units:
            unit_id = str(uuid.uuid4())
            self.unit_id_map[unit['unit_number']] = unit_id
            
            self.sql_statements.append("INSERT INTO units (")
            self.sql_statements.append("    id, building_id, unit_number, floor_number,")
            self.sql_statements.append("    apportionment_percentage, unit_type")
            self.sql_statements.append(") VALUES (")
            self.sql_statements.append(f"    '{unit_id}',")
            self.sql_statements.append(f"    '{self.building_id}',")
            self.sql_statements.append(f"    {self._quote(unit['unit_number'])},")
            self.sql_statements.append(f"    {unit.get('floor') or 'NULL'},")
            self.sql_statements.append(f"    {unit.get('apportionment') or 'NULL'},")
            self.sql_statements.append(f"    {self._quote(unit.get('unit_type', 'Flat'))}")
            self.sql_statements.append(") ON CONFLICT DO NOTHING;")
        
        self.sql_statements.append("")
        
        # Now generate leaseholders (separate table)
        self._generate_leaseholders(units)
    
    def _generate_leaseholders(self, units: List[Dict]):
        """Generate leaseholders - SEPARATE TABLE (not in units!)"""
        leaseholders_to_create = [u for u in units if u.get('leaseholder_name')]
        
        if not leaseholders_to_create:
            return
        
        self.sql_statements.append(f"-- Leaseholders ({len(leaseholders_to_create)})")
        
        for unit in leaseholders_to_create:
            leaseholder_id = str(uuid.uuid4())
            unit_id = self.unit_id_map.get(unit['unit_number'])
            
            if not unit_id:
                continue
            
            self.sql_statements.append("INSERT INTO leaseholders (")
            self.sql_statements.append("    id, unit_id, full_name,")
            self.sql_statements.append("    correspondence_address, email, phone")
            self.sql_statements.append(") VALUES (")
            self.sql_statements.append(f"    '{leaseholder_id}',")
            self.sql_statements.append(f"    '{unit_id}',")
            self.sql_statements.append(f"    {self._quote(unit.get('leaseholder_name'))},")
            self.sql_statements.append(f"    {self._quote(unit.get('correspondence_address'))},")
            self.sql_statements.append(f"    {self._quote(unit.get('email'))},")
            self.sql_statements.append(f"    {self._quote(unit.get('phone'))}")
            self.sql_statements.append(") ON CONFLICT DO NOTHING;")
        
        self.sql_statements.append("")
    
    def _generate_budgets(self):
        """Generate budgets + line items - SCHEMA ALIGNED"""
        budgets = self.data.get('budgets', [])
        
        if not budgets:
            return
        
        self.sql_statements.append(f"-- Budgets ({len(budgets)})")
        
        for budget in budgets:
            budget_id = str(uuid.uuid4())
            
            self.sql_statements.append("INSERT INTO budgets (")
            self.sql_statements.append("    id, building_id, budget_year, total_budget,")
            self.sql_statements.append("    budget_period_start, budget_period_end, status")
            self.sql_statements.append(") VALUES (")
            self.sql_statements.append(f"    '{budget_id}',")
            self.sql_statements.append(f"    '{self.building_id}',")
            self.sql_statements.append(f"    {budget.get('budget_year') or 'NULL'},")
            self.sql_statements.append(f"    {budget.get('total_budget') or 0},")
            self.sql_statements.append(f"    {self._quote_date(budget.get('sc_year_start') or budget.get('budget_period_start'))},")
            self.sql_statements.append(f"    {self._quote_date(budget.get('sc_year_end') or budget.get('budget_period_end'))},")
            self.sql_statements.append(f"    {self._quote(budget.get('status', 'Draft'))}")
            self.sql_statements.append(") ON CONFLICT (building_id, budget_year) DO UPDATE SET total_budget = EXCLUDED.total_budget;")
            
            # Generate line items
            for item in budget.get('line_items', []):
                item_id = str(uuid.uuid4())
                self.sql_statements.append("INSERT INTO budget_line_items (")
                self.sql_statements.append("    id, budget_id, category, description, budgeted_amount")
                self.sql_statements.append(") VALUES (")
                self.sql_statements.append(f"    '{item_id}',")
                self.sql_statements.append(f"    '{budget_id}',")
                self.sql_statements.append(f"    {self._quote(item.get('category', 'Other'))},")
                self.sql_statements.append(f"    {self._quote(item.get('description', ''))},")
                self.sql_statements.append(f"    {item.get('amount') or item.get('annual_amount', 0)}")
                self.sql_statements.append(") ON CONFLICT DO NOTHING;")
        
        self.sql_statements.append("")
    
    def _generate_compliance_assets(self):
        """Generate compliance assets"""
        assets = self.data.get('compliance_assets', [])
        
        if not assets:
            return
        
        self.sql_statements.append(f"-- Compliance Assets ({len(assets)})")
        
        for asset in assets:
            asset_id = str(uuid.uuid4())
            
            self.sql_statements.append("INSERT INTO compliance_assets (")
            self.sql_statements.append("    id, building_id, asset_name, asset_type,")
            self.sql_statements.append("    last_inspection_date, next_due_date,")
            self.sql_statements.append("    compliance_status, assessor_company")
            self.sql_statements.append(") VALUES (")
            self.sql_statements.append(f"    '{asset_id}',")
            self.sql_statements.append(f"    '{self.building_id}',")
            self.sql_statements.append(f"    {self._quote(asset.get('asset_type', 'Unknown'))},")
            self.sql_statements.append(f"    {self._quote(asset.get('asset_key', 'general'))},")
            self.sql_statements.append(f"    {self._quote(asset.get('assessment_date'))},")
            self.sql_statements.append(f"    {self._quote(asset.get('next_due_date'))},")
            self.sql_statements.append(f"    {self._quote(asset.get('status', 'Unknown'))},")
            self.sql_statements.append(f"    {self._quote(asset.get('assessor_company'))}")
            self.sql_statements.append(");")
        
        self.sql_statements.append("")
    
    def _generate_asset_register(self):
        """Generate comprehensive asset register"""
        assets = self.data.get('asset_register', [])
        
        if not assets:
            return
        
        self.sql_statements.append(f"-- Asset Register ({len(assets)} assets)")
        
        for asset in assets:
            asset_id = str(uuid.uuid4())
            
            self.sql_statements.append("INSERT INTO asset_register (")
            self.sql_statements.append("    id, building_id, asset_name, asset_type, category,")
            self.sql_statements.append("    quantity, last_inspection_date, next_inspection_due,")
            self.sql_statements.append("    maintenance_frequency, responsible_contractor,")
            self.sql_statements.append("    compliance_status, annual_maintenance_cost")
            self.sql_statements.append(") VALUES (")
            self.sql_statements.append(f"    '{asset_id}',")
            self.sql_statements.append(f"    '{self.building_id}',")
            self.sql_statements.append(f"    {self._quote(asset.get('asset_name', 'Unknown'))},")
            self.sql_statements.append(f"    {self._quote(asset.get('asset_type', 'general'))},")
            self.sql_statements.append(f"    {self._quote(asset.get('category', 'General'))},")
            self.sql_statements.append(f"    {asset.get('quantity', 1)},")
            self.sql_statements.append(f"    {self._quote(asset.get('last_inspection_date'))},")
            self.sql_statements.append(f"    {self._quote(asset.get('next_inspection_due'))},")
            self.sql_statements.append(f"    {self._quote(asset.get('maintenance_frequency'))},")
            self.sql_statements.append(f"    {self._quote(asset.get('responsible_contractor'))},")
            self.sql_statements.append(f"    {self._quote(asset.get('compliance_status'))},")
            self.sql_statements.append(f"    {asset.get('annual_maintenance_cost') or 'NULL'}")
            self.sql_statements.append(");")
        
        self.sql_statements.append("")
    
    def _generate_insurance_policies(self):
        """Generate insurance policies - SCHEMA ALIGNED"""
        policies = self.data.get('insurance_policies', [])
        
        if not policies:
            return
        
        self.sql_statements.append(f"-- Insurance Policies ({len(policies)})")
        
        for policy in policies:
            policy_id = str(uuid.uuid4())
            
            self.sql_statements.append("INSERT INTO insurance_policies (")
            self.sql_statements.append("    id, building_id, policy_type, insurer_name,")
            self.sql_statements.append("    premium_amount, renewal_date, policy_number")
            self.sql_statements.append(") VALUES (")
            self.sql_statements.append(f"    '{policy_id}',")
            self.sql_statements.append(f"    '{self.building_id}',")
            self.sql_statements.append(f"    {self._quote(policy.get('policy_type', 'Buildings'))},")
            self.sql_statements.append(f"    {self._quote(policy.get('insurer_name') or policy.get('insurer'))},")
            self.sql_statements.append(f"    {policy.get('premium_amount') or policy.get('premium', 0)},")
            self.sql_statements.append(f"    {self._quote_date(policy.get('renewal_date'))},")
            self.sql_statements.append(f"    {self._quote(policy.get('policy_number'))}")
            self.sql_statements.append(") ON CONFLICT DO NOTHING;")
        
        self.sql_statements.append("")
    
    def _generate_contracts(self):
        """Generate maintenance contracts"""
        contracts = self.data.get('contracts', [])
        
        if not contracts:
            return
        
        self.sql_statements.append(f"-- Maintenance Contracts ({len(contracts)})")
        
        for contract in contracts:
            contract_id = str(uuid.uuid4())
            
            self.sql_statements.append("INSERT INTO maintenance_contracts (")
            self.sql_statements.append("    id, building_id, contractor_name, service_type,")
            self.sql_statements.append("    start_date, end_date, annual_cost")
            self.sql_statements.append(") VALUES (")
            self.sql_statements.append(f"    '{contract_id}',")
            self.sql_statements.append(f"    '{self.building_id}',")
            self.sql_statements.append(f"    {self._quote(contract.get('contractor_name', 'Unknown'))},")
            self.sql_statements.append(f"    {self._quote(contract.get('service_type', 'general'))},")
            self.sql_statements.append(f"    {self._quote(contract.get('start_date'))},")
            self.sql_statements.append(f"    {self._quote(contract.get('end_date'))},")
            self.sql_statements.append(f"    {contract.get('contract_value') or 'NULL'}")
            self.sql_statements.append(");")
        
        self.sql_statements.append("")
    
    def _generate_accounts(self):
        """Generate service charge accounts"""
        accounts = self.data.get('accounts', [])
        
        if not accounts:
            return
        
        self.sql_statements.append(f"-- Service Charge Accounts ({len(accounts)})")
        
        for account in accounts:
            account_id = str(uuid.uuid4())
            
            self.sql_statements.append("INSERT INTO service_charge_accounts (")
            self.sql_statements.append("    id, building_id, financial_year, year_end_date,")
            self.sql_statements.append("    approval_date, is_approved, total_expenditure")
            self.sql_statements.append(") VALUES (")
            self.sql_statements.append(f"    '{account_id}',")
            self.sql_statements.append(f"    '{self.building_id}',")
            self.sql_statements.append(f"    {self._quote(account.get('financial_year'))},")
            self.sql_statements.append(f"    {self._quote(account.get('year_end_date'))},")
            self.sql_statements.append(f"    {self._quote(account.get('approval_date'))},")
            self.sql_statements.append(f"    {self._bool(account.get('is_approved', False))},")
            self.sql_statements.append(f"    {account.get('total_expenditure') or 'NULL'}")
            self.sql_statements.append(");")
        
        self.sql_statements.append("")
    
    def _generate_leases(self):
        """Generate leases (if analyzed)"""
        lease_analysis = self.data.get('lease_analysis', {})
        leases = lease_analysis.get('lease_details', [])
        
        if not leases:
            return
        
        self.sql_statements.append(f"-- Leases ({len(leases)})")
        
        for lease in leases:
            lease_id = str(uuid.uuid4())
            
            self.sql_statements.append("INSERT INTO leases (")
            self.sql_statements.append("    id, building_id, title_number, term_years, ground_rent")
            self.sql_statements.append(") VALUES (")
            self.sql_statements.append(f"    '{lease_id}',")
            self.sql_statements.append(f"    '{self.building_id}',")
            self.sql_statements.append(f"    {self._quote(lease.get('title_number'))},")
            self.sql_statements.append(f"    {lease.get('term_years') or 'NULL'},")
            self.sql_statements.append(f"    {lease.get('ground_rent') or 'NULL'}")
            self.sql_statements.append(");")
        
        self.sql_statements.append("")
    
    def _generate_contractors(self):
        """Generate contractors (consolidated)"""
        contractors = self.data.get('contractors', [])
        
        if not contractors:
            return
        
        self.sql_statements.append(f"-- Contractors ({len(contractors)})")
        
        for contractor in contractors:
            contractor_id = str(uuid.uuid4())
            
            services_json = json.dumps(contractor.get('services_provided', []))
            
            self.sql_statements.append("INSERT INTO contractors (")
            self.sql_statements.append("    id, building_id, company_name, services_json,")
            self.sql_statements.append("    annual_value, is_active")
            self.sql_statements.append(") VALUES (")
            self.sql_statements.append(f"    '{contractor_id}',")
            self.sql_statements.append(f"    '{self.building_id}',")
            self.sql_statements.append(f"    {self._quote(contractor.get('contractor_name'))},")
            self.sql_statements.append(f"    {self._quote(services_json)},")
            self.sql_statements.append(f"    {contractor.get('annual_value', 0)},")
            self.sql_statements.append(f"    {self._bool(contractor.get('is_active', True))}")
            self.sql_statements.append(");")
        
        self.sql_statements.append("")
    
    def _quote(self, value) -> str:
        """SQL quote string"""
        if value is None:
            return 'NULL'
        
        # Escape single quotes
        escaped = str(value).replace("'", "''")
        return f"'{escaped}'"
    
    def _bool(self, value: bool) -> str:
        """SQL boolean"""
        return 'TRUE' if value else 'FALSE'
    
    def _quote_date(self, value) -> str:
        """SQL quote date - returns NULL if None"""
        if value is None or value == '':
            return 'NULL'
        
        # If already in YYYY-MM-DD format, quote it
        if isinstance(value, str):
            # Remove any time portion
            date_only = value.split('T')[0].split(' ')[0]
            return f"'{date_only}'"
        
        return 'NULL'

