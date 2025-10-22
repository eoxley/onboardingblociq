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
        self.sql_statements.append("    construction_type, construction_era,")
        self.sql_statements.append("    service_charge_year_end")
        self.sql_statements.append(") VALUES (")
        # Get address - try multiple field names
        address = (building.get('building_address') or
                  building.get('address') or
                  building.get('full_address'))

        # Get postcode
        postcode = building.get('postcode')

        # Get SC year end as recurring date (always use year 2000)
        sc_year_end_date = self._get_recurring_date(
            building.get('sc_year_end') or
            (self.data.get('budgets', [{}])[0].get('sc_year_end') if self.data.get('budgets') else None)
        )

        self.sql_statements.append(f"    '{self.building_id}',")
        self.sql_statements.append(f"    {self._quote(building.get('name', 'Unknown'))},")
        self.sql_statements.append(f"    {self._quote(address)},")
        self.sql_statements.append(f"    {self._quote(postcode)},")
        self.sql_statements.append(f"    {len(self.data.get('units', []))},")
        self.sql_statements.append(f"    {building.get('number_of_floors') or building.get('num_floors') or 'NULL'},")
        self.sql_statements.append(f"    {building.get('building_height_meters') or 'NULL'},")
        self.sql_statements.append(f"    {self._bool(building.get('is_hrb', False))},")
        self.sql_statements.append(f"    {self._quote(building.get('bsa_status', 'Not HRB'))},")
        self.sql_statements.append(f"    {self._quote(building.get('construction_type'))},")
        self.sql_statements.append(f"    {self._quote(building.get('construction_era'))},")
        self.sql_statements.append(f"    {self._quote_date(sc_year_end_date)}")
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

        # Now generate leaseholders from separate leaseholders array
        self._generate_leaseholders()
    
    def _generate_leaseholders(self):
        """Generate leaseholders from separate leaseholders array OR embedded in units"""
        leaseholders = self.data.get('leaseholders', [])

        # If no separate leaseholders array, check if embedded in units
        if not leaseholders:
            units = self.data.get('units', [])
            leaseholders_from_units = []
            for unit in units:
                if unit.get('leaseholder_name'):
                    # Create leaseholder dict from unit data
                    leaseholders_from_units.append({
                        'unit_number': unit.get('unit_number'),
                        'name': unit.get('leaseholder_name'),
                        'correspondence_address': unit.get('correspondence_address'),
                        'email': unit.get('email'),
                        'phone': unit.get('phone'),
                        'telephone': unit.get('telephone'),
                    })
            leaseholders = leaseholders_from_units

        if not leaseholders:
            return

        self.sql_statements.append(f"-- Leaseholders ({len(leaseholders)})")

        for leaseholder in leaseholders:
            leaseholder_id = str(uuid.uuid4())

            # Get unit_id from unit_number mapping
            unit_number = leaseholder.get('unit_number')
            unit_id = self.unit_id_map.get(unit_number) if unit_number else None

            # If no unit_number, try using unit_id from leaseholder data
            if not unit_id and leaseholder.get('unit_id'):
                # Check if this unit_id exists in our generated units
                for un, uid in self.unit_id_map.items():
                    if uid == leaseholder.get('unit_id'):
                        unit_id = uid
                        break

            if not unit_id:
                # Skip leaseholders without valid unit link
                continue

            self.sql_statements.append("INSERT INTO leaseholders (")
            self.sql_statements.append("    id, unit_id, leaseholder_name,")
            self.sql_statements.append("    correspondence_address, email, telephone")
            self.sql_statements.append(") VALUES (")
            self.sql_statements.append(f"    '{leaseholder_id}',")
            self.sql_statements.append(f"    '{unit_id}',")
            self.sql_statements.append(f"    {self._quote(leaseholder.get('name') or leaseholder.get('leaseholder_name'))},")
            self.sql_statements.append(f"    {self._quote(leaseholder.get('correspondence_address'))},")
            self.sql_statements.append(f"    {self._quote(leaseholder.get('email'))},")
            self.sql_statements.append(f"    {self._quote(leaseholder.get('phone') or leaseholder.get('telephone'))}")
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
            
            # Budget year is required - infer from dates if missing
            budget_year = budget.get('budget_year')
            if not budget_year:
                # Try to extract year from date fields
                period_end = budget.get('sc_year_end') or budget.get('budget_period_end')
                if period_end and isinstance(period_end, str):
                    try:
                        import re
                        year_match = re.search(r'20\d{2}', period_end)
                        if year_match:
                            budget_year = int(year_match.group())
                    except:
                        pass

                # Default to current year if still missing
                if not budget_year:
                    budget_year = datetime.now().year

            self.sql_statements.append("INSERT INTO budgets (")
            self.sql_statements.append("    id, building_id, budget_year, total_budget,")
            self.sql_statements.append("    budget_period_start, budget_period_end, status")
            self.sql_statements.append(") VALUES (")
            self.sql_statements.append(f"    '{budget_id}',")
            self.sql_statements.append(f"    '{self.building_id}',")
            self.sql_statements.append(f"    {budget_year},")
            self.sql_statements.append(f"    {budget.get('total_budget') or 0},")
            self.sql_statements.append(f"    {self._quote_date(budget.get('sc_year_start') or budget.get('budget_period_start'))},")
            self.sql_statements.append(f"    {self._quote_date(budget.get('sc_year_end') or budget.get('budget_period_end'))},")
            self.sql_statements.append(f"    {self._quote(budget.get('status', 'draft'))}")
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
        """Generate compliance assets - SCHEMA ALIGNED with asset_type_id lookup"""
        assets = self.data.get('compliance_assets', [])

        if not assets:
            return

        # Asset type mapping to asset_type_code
        asset_type_map = {
            'legionella': 'LEGIONELLA',
            'legionella risk assessment': 'LEGIONELLA',
            'eicr': 'EICR',
            'electrical installation condition report': 'EICR',
            'fire_risk_assessment': 'FRA',
            'fire risk assessment': 'FRA',
            'fire_door_inspection': 'FIRE_DOOR',
            'fire door inspection': 'FIRE_DOOR',
            'gas_safety': 'GAS_SAFETY',
            'gas safety': 'GAS_SAFETY',
            'gas safety certificate': 'GAS_SAFETY',
            'asbestos': 'ASBESTOS',
            'asbestos survey': 'ASBESTOS',
            'emergency_lighting': 'EMERGENCY_LIGHTING',
            'emergency lighting': 'EMERGENCY_LIGHTING',
            'emergency lighting test': 'EMERGENCY_LIGHTING',
            'fire_alarm': 'FIRE_ALARM',
            'lift': 'LIFT_MAINTENANCE',
            'pat': 'PAT',
        }

        self.sql_statements.append(f"-- Compliance Assets ({len(assets)})")

        for asset in assets:
            asset_id = str(uuid.uuid4())

            # Map asset_type to asset_type_code for lookup
            asset_type = (asset.get('asset_type') or '').lower().strip()
            asset_type_code = asset_type_map.get(asset_type, 'FRA')  # Default to FRA if unknown

            self.sql_statements.append("INSERT INTO compliance_assets (")
            self.sql_statements.append("    id, building_id, asset_type_id,")
            self.sql_statements.append("    inspection_date, next_due_date,")
            self.sql_statements.append("    status, inspection_company")
            self.sql_statements.append(") ")
            self.sql_statements.append("SELECT")
            self.sql_statements.append(f"    '{asset_id}',")
            self.sql_statements.append(f"    '{self.building_id}',")
            self.sql_statements.append(f"    id,")
            self.sql_statements.append(f"    {self._quote_date(asset.get('assessment_date') or asset.get('last_inspection_date'))},")
            self.sql_statements.append(f"    {self._quote_date(asset.get('next_due_date'))},")
            self.sql_statements.append(f"    {self._quote(asset.get('status', 'Unknown'))},")
            self.sql_statements.append(f"    {self._quote(asset.get('assessor_company') or asset.get('inspector_company'))}")
            self.sql_statements.append(f"FROM compliance_asset_types WHERE asset_type_code = '{asset_type_code}';")

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
            self.sql_statements.append("    id, building_id, policy_type, insurer,")
            self.sql_statements.append("    annual_premium, renewal_date, policy_number")
            self.sql_statements.append(") VALUES (")
            self.sql_statements.append(f"    '{policy_id}',")
            self.sql_statements.append(f"    '{self.building_id}',")
            self.sql_statements.append(f"    {self._quote(policy.get('policy_type', 'Buildings'))},")
            self.sql_statements.append(f"    {self._quote(policy.get('insurer_name') or policy.get('insurer'))},")
            self.sql_statements.append(f"    {policy.get('premium_amount') or policy.get('premium') or policy.get('annual_premium') or 'NULL'},")
            self.sql_statements.append(f"    {self._quote_date(policy.get('renewal_date'))},")
            self.sql_statements.append(f"    {self._quote(policy.get('policy_number'))}")
            self.sql_statements.append(") ON CONFLICT DO NOTHING;")
        
        self.sql_statements.append("")
    
    def _generate_contracts(self):
        """Generate maintenance contracts - SCHEMA ALIGNED with contract_type_id lookup"""
        contracts = self.data.get('contracts', [])

        if not contracts:
            return

        # Service type mapping to contract_type_code
        service_type_map = {
            'cleaning': 'CLEANING',
            'security': 'CCTV',
            'gardening': 'GARDENING',
            'lift': 'LIFT_MAINTENANCE',
            'lifts': 'LIFT_MAINTENANCE',
            'pest_control': 'PEST_CONTROL',
            'fire_alarm': 'FIRE_ALARM',
            'door_entry': 'DOOR_ENTRY',
            'water_hygiene': 'WATER_HYGIENE',
        }

        self.sql_statements.append(f"-- Maintenance Contracts ({len(contracts)})")

        for contract in contracts:
            contract_id = str(uuid.uuid4())

            # Map service_type to contract_type_code
            service_type = (contract.get('service_type') or '').lower().replace(' ', '_')
            contract_type_code = service_type_map.get(service_type, 'CLEANING')  # Default to CLEANING if unknown

            self.sql_statements.append("INSERT INTO maintenance_contracts (")
            self.sql_statements.append("    id, building_id, contract_type_id, contractor_name,")
            self.sql_statements.append("    contract_start_date, contract_end_date, contract_value_annual")
            self.sql_statements.append(") ")
            self.sql_statements.append("SELECT")
            self.sql_statements.append(f"    '{contract_id}',")
            self.sql_statements.append(f"    '{self.building_id}',")
            self.sql_statements.append(f"    id,")
            self.sql_statements.append(f"    {self._quote(contract.get('contractor_name', 'Unknown'))},")
            self.sql_statements.append(f"    {self._quote_date(contract.get('start_date'))},")
            self.sql_statements.append(f"    {self._quote_date(contract.get('end_date'))},")
            self.sql_statements.append(f"    {contract.get('contract_value') or contract.get('annual_cost') or 'NULL'}")
            self.sql_statements.append(f"FROM contract_types WHERE contract_type_code = '{contract_type_code}';")

        self.sql_statements.append("")
    
    def _generate_accounts(self):
        """Generate service charge accounts - DISABLED (table doesn't exist in schema)"""
        # Table service_charge_accounts does not exist in Supabase schema
        # Service charge data is tracked via budgets table instead
        return
    
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
        """Generate contractors (consolidated) - SCHEMA ALIGNED (no building_id)"""
        contractors = self.data.get('contractors', [])

        if not contractors:
            return

        self.sql_statements.append(f"-- Contractors ({len(contractors)})")

        for contractor in contractors:
            contractor_id = str(uuid.uuid4())

            # Convert services to PostgreSQL array format: ARRAY['value1', 'value2']
            services = contractor.get('services_provided', [])
            if isinstance(services, str):
                services = [services]

            if services:
                # Escape single quotes in service names
                escaped_services = [s.replace("'", "''") for s in services]
                services_array = "ARRAY[" + ','.join([f"'{s}'" for s in escaped_services]) + "]"
            else:
                services_array = 'NULL'

            self.sql_statements.append("INSERT INTO contractors (")
            self.sql_statements.append("    id, company_name, services_offered,")
            self.sql_statements.append("    is_active")
            self.sql_statements.append(") VALUES (")
            self.sql_statements.append(f"    '{contractor_id}',")
            self.sql_statements.append(f"    {self._quote(contractor.get('contractor_name') or contractor.get('company_name'))},")
            self.sql_statements.append(f"    {services_array},")
            self.sql_statements.append(f"    {self._bool(contractor.get('is_active', True))}")
            self.sql_statements.append(") ON CONFLICT DO NOTHING;")

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

    def _get_recurring_date(self, date_value) -> str:
        """
        Convert date to recurring date format (year 2000 convention)

        Examples:
            "2025-03-31" -> "2000-03-31" (31st March, annual)
            "2024-12-25" -> "2000-12-25" (25th December, annual)

        This allows the database to store annual recurring dates (like SC year end)
        without being tied to a specific year.
        """
        if not date_value:
            return None

        if isinstance(date_value, str):
            # Extract month and day, replace year with 2000
            try:
                # Handle YYYY-MM-DD format
                parts = date_value.split('T')[0].split(' ')[0].split('-')
                if len(parts) == 3:
                    year, month, day = parts
                    return f"2000-{month}-{day}"
            except:
                pass

        return None
        
        return 'NULL'

