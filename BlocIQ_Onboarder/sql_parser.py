#!/usr/bin/env python3
"""
SQL Parser - Extract structured data from migration.sql files
Converts INSERT statements back into Python dict structures for report generation
"""

import re
from typing import Dict, List, Any, Optional
from datetime import datetime


class SQLDataExtractor:
    """Extract structured data from SQL migration files"""
    
    def __init__(self, sql_file_path: str):
        """Initialize with path to migration.sql"""
        self.sql_file_path = sql_file_path
        self.data = {
            'building': None,
            'units': [],
            'leaseholders': [],
            'compliance_assets': [],
            'building_contractors': [],
            'budgets': [],
            'apportionments': [],
            'building_insurance': [],
            'fire_door_inspections': [],
            'building_staff': [],
            'leases': [],
            'building_intelligence': [],
            'contracts': [],
            'insurance_policies': [],
            'assets': [],
            'contractors': []
        }
        
    def parse(self) -> Dict[str, Any]:
        """Parse the SQL file and extract all data"""
        print(f"📖 Parsing SQL file: {self.sql_file_path}")
        
        with open(self.sql_file_path, 'r', encoding='utf-8') as f:
            sql_content = f.read()
        
        # Extract data from each table
        self._extract_building(sql_content)
        self._extract_units(sql_content)
        self._extract_leaseholders(sql_content)
        self._extract_compliance_assets(sql_content)
        self._extract_contractors(sql_content)
        self._extract_contracts(sql_content)  # Extract actual contracts table
        self._extract_budgets(sql_content)
        self._extract_apportionments(sql_content)
        self._extract_insurance(sql_content)
        self._extract_fire_doors(sql_content)
        self._extract_staff(sql_content)
        self._extract_leases(sql_content)
        self._extract_building_intelligence(sql_content)
        
        return self.data
    
    def _extract_building(self, sql: str):
        """Extract building information"""
        # Pattern: INSERT INTO buildings (id, name, address, portfolio_id) VALUES (...)
        pattern = r"INSERT INTO buildings \([^)]+\) VALUES \(([^;]+)\);"
        matches = re.finditer(pattern, sql, re.IGNORECASE)
        
        for match in matches:
            values = self._parse_values(match.group(1))
            if values:
                self.data['building'] = {
                    'id': self._clean_value(values[0]),
                    'name': self._clean_value(values[1]),
                    'address': self._clean_value(values[2]),
                    'portfolio_id': self._clean_value(values[3]) if len(values) > 3 else None
                }
                print(f"   ✅ Building: {self.data['building']['name']}")
                break
    
    def _extract_units(self, sql: str):
        """Extract units"""
        pattern = r"INSERT INTO units \([^)]+\) VALUES \(([^;]+)\);"
        matches = re.finditer(pattern, sql, re.IGNORECASE)
        
        for match in matches:
            values = self._parse_values(match.group(1))
            if values:
                unit = {
                    'id': self._clean_value(values[0]),
                    'building_id': self._clean_value(values[1]),
                    'unit_number': self._clean_value(values[2])
                }
                self.data['units'].append(unit)
        
        print(f"   ✅ Units: {len(self.data['units'])}")
    
    def _extract_leaseholders(self, sql: str):
        """Extract leaseholders"""
        pattern = r"INSERT INTO leaseholders \(([^)]+)\) VALUES \(([^;]+)\);"
        matches = re.finditer(pattern, sql, re.IGNORECASE)
        
        for match in matches:
            columns = [c.strip() for c in match.group(1).split(',')]
            values = self._parse_values(match.group(2))
            
            if values and len(columns) == len(values):
                leaseholder = {}
                for col, val in zip(columns, values):
                    leaseholder[col] = self._clean_value(val)
                self.data['leaseholders'].append(leaseholder)
        
        print(f"   ✅ Leaseholders: {len(self.data['leaseholders'])}")
    
    def _extract_compliance_assets(self, sql: str):
        """Extract compliance assets"""
        pattern = r"INSERT INTO compliance_assets \(([^)]+)\) VALUES \(([^;]+)\);"
        matches = re.finditer(pattern, sql, re.IGNORECASE)
        
        for match in matches:
            columns = [c.strip() for c in match.group(1).split(',')]
            values = self._parse_values(match.group(2))
            
            if values and len(columns) == len(values):
                asset = {}
                for col, val in zip(columns, values):
                    asset[col] = self._clean_value(val)
                    
                # Standardize key names for report generator
                if 'asset_name' not in asset and 'name' in asset:
                    asset['asset_name'] = asset['name']
                    
                self.data['compliance_assets'].append(asset)
        
        print(f"   ✅ Compliance Assets: {len(self.data['compliance_assets'])}")
    
    def _extract_contractors(self, sql: str):
        """Extract contractors from contractors table"""
        pattern = r"INSERT INTO contractors \(([^)]+)\) VALUES \(([^;]+)\);"
        matches = re.finditer(pattern, sql, re.IGNORECASE)
        
        for match in matches:
            columns = [c.strip() for c in match.group(1).split(',')]
            values = self._parse_values(match.group(2))
            
            if values and len(columns) == len(values):
                contractor = {}
                for col, val in zip(columns, values):
                    contractor[col] = self._clean_value(val)
                    
                self.data['contractors'].append(contractor)
        
        # Also extract building_contractors junction table
        pattern = r"INSERT INTO building_contractors \(([^)]+)\) VALUES \(([^;]+)\);"
        matches = re.finditer(pattern, sql, re.IGNORECASE)
        
        for match in matches:
            columns = [c.strip() for c in match.group(1).split(',')]
            values = self._parse_values(match.group(2))
            
            if values and len(columns) == len(values):
                junction = {}
                for col, val in zip(columns, values):
                    junction[col] = self._clean_value(val)
                    
                self.data['building_contractors'].append(junction)
        
        print(f"   ✅ Contractors: {len(self.data['contractors'])}")
    
    def _extract_contracts(self, sql: str):
        """Extract contracts from contracts table"""
        pattern = r"INSERT INTO contracts \(([^)]+)\) VALUES \(([^;]+)\);"
        matches = re.finditer(pattern, sql, re.IGNORECASE)
        
        for match in matches:
            columns = [c.strip() for c in match.group(1).split(',')]
            values = self._parse_values(match.group(2))
            
            if values and len(columns) == len(values):
                contract = {}
                for col, val in zip(columns, values):
                    contract[col] = self._clean_value(val)
                    
                self.data['contracts'].append(contract)
        
        print(f"   ✅ Contracts: {len(self.data['contracts'])}")
    
    def _extract_budgets(self, sql: str):
        """Extract budgets"""
        pattern = r"INSERT INTO budgets \(([^)]+)\) VALUES \(([^;]+)\);"
        matches = re.finditer(pattern, sql, re.IGNORECASE)
        
        for match in matches:
            columns = [c.strip() for c in match.group(1).split(',')]
            values = self._parse_values(match.group(2))
            
            if values and len(columns) == len(values):
                budget = {}
                for col, val in zip(columns, values):
                    budget[col] = self._clean_value(val)
                self.data['budgets'].append(budget)
        
        print(f"   ✅ Budgets: {len(self.data['budgets'])}")
    
    def _extract_apportionments(self, sql: str):
        """Extract apportionments"""
        pattern = r"INSERT INTO apportionments \(([^)]+)\) VALUES \(([^;]+)\);"
        matches = re.finditer(pattern, sql, re.IGNORECASE)
        
        for match in matches:
            columns = [c.strip() for c in match.group(1).split(',')]
            values = self._parse_values(match.group(2))
            
            if values and len(columns) == len(values):
                app = {}
                for col, val in zip(columns, values):
                    app[col] = self._clean_value(val)
                self.data['apportionments'].append(app)
        
        print(f"   ✅ Apportionments: {len(self.data['apportionments'])}")
    
    def _extract_insurance(self, sql: str):
        """Extract insurance policies"""
        pattern = r"INSERT INTO building_insurance \(([^)]+)\) VALUES \(([^;]+)\);"
        matches = re.finditer(pattern, sql, re.IGNORECASE)
        
        for match in matches:
            columns = [c.strip() for c in match.group(1).split(',')]
            values = self._parse_values(match.group(2))
            
            if values and len(columns) == len(values):
                policy = {}
                for col, val in zip(columns, values):
                    policy[col] = self._clean_value(val)
                    
                # Standardize for insurance_policies list
                insurance_policy = {
                    'id': policy.get('id'),
                    'insurer': policy.get('provider'),
                    'policy_number': policy.get('policy_number'),
                    'cover_type': 'Buildings',
                    'sum_insured': self._parse_numeric(policy.get('premium_amount')),
                    'end_date': policy.get('expiry_date'),
                    'building_id': policy.get('building_id')
                }
                
                self.data['building_insurance'].append(policy)
                self.data['insurance_policies'].append(insurance_policy)
        
        print(f"   ✅ Insurance Policies: {len(self.data['building_insurance'])}")
    
    def _extract_fire_doors(self, sql: str):
        """Extract fire door inspections"""
        pattern = r"INSERT INTO fire_door_inspections \(([^)]+)\) VALUES \(([^;]+)\);"
        matches = re.finditer(pattern, sql, re.IGNORECASE)
        
        for match in matches:
            columns = [c.strip() for c in match.group(1).split(',')]
            values = self._parse_values(match.group(2))
            
            if values and len(columns) == len(values):
                inspection = {}
                for col, val in zip(columns, values):
                    inspection[col] = self._clean_value(val)
                self.data['fire_door_inspections'].append(inspection)
        
        print(f"   ✅ Fire Door Inspections: {len(self.data['fire_door_inspections'])}")
    
    def _extract_staff(self, sql: str):
        """Extract building staff"""
        pattern = r"INSERT INTO building_staff \(([^)]+)\) VALUES \(([^;]+)\);"
        matches = re.finditer(pattern, sql, re.IGNORECASE)
        
        for match in matches:
            columns = [c.strip() for c in match.group(1).split(',')]
            values = self._parse_values(match.group(2))
            
            if values and len(columns) == len(values):
                staff = {}
                for col, val in zip(columns, values):
                    staff[col] = self._clean_value(val)
                self.data['building_staff'].append(staff)
        
        print(f"   ✅ Building Staff: {len(self.data['building_staff'])}")
    
    def _extract_leases(self, sql: str):
        """Extract leases"""
        pattern = r"INSERT INTO leases \(([^)]+)\) VALUES \(([^;]+)\);"
        matches = re.finditer(pattern, sql, re.IGNORECASE)
        
        for match in matches:
            columns = [c.strip() for c in match.group(1).split(',')]
            values = self._parse_values(match.group(2))
            
            if values and len(columns) == len(values):
                lease = {}
                for col, val in zip(columns, values):
                    lease[col] = self._clean_value(val)
                self.data['leases'].append(lease)
        
        print(f"   ✅ Leases: {len(self.data['leases'])}")
    
    def _extract_building_intelligence(self, sql: str):
        """Extract building intelligence entries"""
        pattern = r"INSERT INTO building_intelligence \(([^)]+)\) VALUES \(([^;]+)\);"
        matches = re.finditer(pattern, sql, re.IGNORECASE)
        
        for match in matches:
            columns = [c.strip() for c in match.group(1).split(',')]
            values = self._parse_values(match.group(2))
            
            if values and len(columns) == len(values):
                entry = {}
                for col, val in zip(columns, values):
                    entry[col] = self._clean_value(val)
                self.data['building_intelligence'].append(entry)
        
        print(f"   ✅ Building Intelligence: {len(self.data['building_intelligence'])}")
    
    def _parse_values(self, values_str: str) -> List[str]:
        """Parse SQL VALUES clause into list of values"""
        # Handle complex nested values
        values = []
        current_value = []
        in_quotes = False
        quote_char = None
        paren_depth = 0
        
        for char in values_str:
            if char in ("'", '"') and not in_quotes:
                in_quotes = True
                quote_char = char
                current_value.append(char)
            elif char == quote_char and in_quotes:
                in_quotes = False
                quote_char = None
                current_value.append(char)
            elif char == '(' and not in_quotes:
                paren_depth += 1
                current_value.append(char)
            elif char == ')' and not in_quotes:
                paren_depth -= 1
                if paren_depth < 0:
                    break
                current_value.append(char)
            elif char == ',' and not in_quotes and paren_depth == 0:
                values.append(''.join(current_value).strip())
                current_value = []
            else:
                current_value.append(char)
        
        # Add last value
        if current_value:
            values.append(''.join(current_value).strip())
        
        return values
    
    def _clean_value(self, value: str) -> Any:
        """Clean and convert SQL value to Python type"""
        if not value:
            return None
            
        value = value.strip()
        
        # NULL
        if value.upper() == 'NULL':
            return None
        
        # Remove quotes
        if (value.startswith("'") and value.endswith("'")) or \
           (value.startswith('"') and value.endswith('"')):
            value = value[1:-1]
        
        # Unescape single quotes
        value = value.replace("''", "'")
        
        # Empty string
        if value == '':
            return None
        
        return value
    
    def _parse_numeric(self, value: Any) -> Optional[float]:
        """Parse numeric value"""
        if value is None:
            return None
        try:
            return float(value)
        except:
            return None


def load_data_from_migration_sql(sql_file_path: str) -> Dict[str, Any]:
    """
    Load structured data from migration.sql file
    
    Args:
        sql_file_path: Path to migration.sql
        
    Returns:
        Structured data dict for report generation
    """
    extractor = SQLDataExtractor(sql_file_path)
    data = extractor.parse()
    
    # Post-process: map assets from compliance_assets
    data['assets'] = []
    for comp_asset in data.get('compliance_assets', []):
        asset = {
            'id': comp_asset.get('id'),
            'asset_name': comp_asset.get('asset_name') or comp_asset.get('name'),
            'asset_type': comp_asset.get('asset_type', 'general'),
            'compliance_asset_id': comp_asset.get('id'),
            'contractor_id': None,  # Would need to be looked up
            'service_frequency': comp_asset.get('service_frequency'),
            'last_service_date': comp_asset.get('last_inspection_date'),
            'next_due_date': comp_asset.get('next_due_date'),
            'compliance_category': comp_asset.get('asset_type'),
            'compliance_status': comp_asset.get('compliance_status', 'unknown'),
            'location_description': comp_asset.get('location'),
            'condition_rating': None
        }
        data['assets'].append(asset)
    
    return data
