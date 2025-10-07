"""
BlocIQ Onboarder - Database Insert Helpers
Safe insert functions with column validation
"""

import json
from typing import Dict, List, Optional
from datetime import datetime


class SafeInserter:
    """Safe database insert with column validation"""

    def __init__(self, supabase_client=None):
        self.supabase = supabase_client
        self.insert_log = []

    def insert_insurance_policies(self, policies: List[Dict]) -> List[Dict]:
        """Insert insurance policies with validation"""
        results = []
        for policy in policies:
            try:
                # Filter to known columns
                safe_policy = self._filter_columns(policy, [
                    'id', 'building_id', 'insurer', 'broker', 'policy_number',
                    'cover_type', 'sum_insured', 'reinstatement_value', 'valuation_date',
                    'start_date', 'end_date', 'excess_json', 'endorsements',
                    'conditions', 'claims_json', 'evidence_url', 'policy_status'
                ])

                if self.supabase:
                    result = self.supabase.table('insurance_policies').insert(safe_policy).execute()
                    results.append({'success': True, 'id': safe_policy['id']})
                else:
                    results.append({'success': True, 'id': safe_policy['id'], 'sql_only': True})

                self.insert_log.append({
                    'table': 'insurance_policies',
                    'id': safe_policy['id'],
                    'timestamp': datetime.now().isoformat()
                })

            except KeyError as e:
                results.append({'success': False, 'error': f'Missing column: {e}'})
            except Exception as e:
                results.append({'success': False, 'error': str(e)})

        return results

    def insert_contracts(self, contracts: List[Dict]) -> List[Dict]:
        """Insert service contracts with validation"""
        results = []
        for contract in contracts:
            try:
                safe_contract = self._filter_columns(contract, [
                    'id', 'building_id', 'contractor_name', 'service_type',
                    'start_date', 'end_date', 'renewal_date', 'frequency',
                    'value', 'contract_status'
                ])

                if self.supabase:
                    result = self.supabase.table('contracts').insert(safe_contract).execute()
                    results.append({'success': True, 'id': safe_contract['id']})
                else:
                    results.append({'success': True, 'id': safe_contract['id'], 'sql_only': True})

                self.insert_log.append({
                    'table': 'contracts',
                    'id': safe_contract['id'],
                    'timestamp': datetime.now().isoformat()
                })

            except KeyError as e:
                results.append({'success': False, 'error': f'Missing column: {e}'})
            except Exception as e:
                results.append({'success': False, 'error': str(e)})

        return results

    def insert_utilities(self, utilities: List[Dict]) -> List[Dict]:
        """Insert utility accounts with validation"""
        results = []
        for utility in utilities:
            try:
                safe_utility = self._filter_columns(utility, [
                    'id', 'building_id', 'supplier', 'utility_type',
                    'account_number', 'start_date', 'end_date', 'tariff',
                    'contract_status'
                ])

                if self.supabase:
                    result = self.supabase.table('utilities').insert(safe_utility).execute()
                    results.append({'success': True, 'id': safe_utility['id']})
                else:
                    results.append({'success': True, 'id': safe_utility['id'], 'sql_only': True})

                self.insert_log.append({
                    'table': 'utilities',
                    'id': safe_utility['id'],
                    'timestamp': datetime.now().isoformat()
                })

            except KeyError as e:
                results.append({'success': False, 'error': f'Missing column: {e}'})
            except Exception as e:
                results.append({'success': False, 'error': str(e)})

        return results

    def insert_meetings(self, meetings: List[Dict]) -> List[Dict]:
        """Insert meeting records with validation"""
        results = []
        for meeting in meetings:
            try:
                safe_meeting = self._filter_columns(meeting, [
                    'id', 'building_id', 'meeting_type', 'meeting_date',
                    'attendees', 'key_decisions', 'minutes_url'
                ])

                if self.supabase:
                    result = self.supabase.table('meetings').insert(safe_meeting).execute()
                    results.append({'success': True, 'id': safe_meeting['id']})
                else:
                    results.append({'success': True, 'id': safe_meeting['id'], 'sql_only': True})

                self.insert_log.append({
                    'table': 'meetings',
                    'id': safe_meeting['id'],
                    'timestamp': datetime.now().isoformat()
                })

            except KeyError as e:
                results.append({'success': False, 'error': f'Missing column: {e}'})
            except Exception as e:
                results.append({'success': False, 'error': str(e)})

        return results

    def insert_client_money_snapshots(self, snapshots: List[Dict]) -> List[Dict]:
        """Insert client money snapshots with validation"""
        results = []
        for snapshot in snapshots:
            try:
                safe_snapshot = self._filter_columns(snapshot, [
                    'id', 'building_id', 'snapshot_date', 'bank_name',
                    'account_identifier', 'balance', 'uncommitted_funds',
                    'arrears_total', 'notes'
                ])

                if self.supabase:
                    result = self.supabase.table('client_money_snapshots').insert(safe_snapshot).execute()
                    results.append({'success': True, 'id': safe_snapshot['id']})
                else:
                    results.append({'success': True, 'id': safe_snapshot['id'], 'sql_only': True})

                self.insert_log.append({
                    'table': 'client_money_snapshots',
                    'id': safe_snapshot['id'],
                    'timestamp': datetime.now().isoformat()
                })

            except KeyError as e:
                results.append({'success': False, 'error': f'Missing column: {e}'})
            except Exception as e:
                results.append({'success': False, 'error': str(e)})

        return results

    def _filter_columns(self, record: Dict, allowed_columns: List[str]) -> Dict:
        """Filter record to only include allowed columns"""
        filtered = {}
        for col in allowed_columns:
            if col in record:
                value = record[col]
                # Convert JSONB fields to JSON strings if needed
                if col.endswith('_json') and isinstance(value, (dict, list)):
                    filtered[col] = json.dumps(value)
                else:
                    filtered[col] = value
            # Don't include None values for optional fields
        return {k: v for k, v in filtered.items() if v is not None}

    def get_insert_summary(self) -> Dict:
        """Get summary of all inserts"""
        summary = {}
        for log_entry in self.insert_log:
            table = log_entry['table']
            summary[table] = summary.get(table, 0) + 1

        return {
            'total_inserts': len(self.insert_log),
            'by_table': summary,
            'log': self.insert_log
        }


def generate_insert_sql(table_name: str, records: List[Dict]) -> str:
    """
    Generate SQL INSERT statements for records

    Args:
        table_name: Name of the table
        records: List of record dictionaries

    Returns:
        SQL INSERT statement
    """
    if not records:
        return ''

    sql_lines = [f"-- Insert {len(records)} records into {table_name}"]

    for record in records:
        # Get column names and values
        columns = list(record.keys())
        values = []

        for col in columns:
            val = record[col]
            if val is None:
                values.append('NULL')
            elif isinstance(val, (int, float)):
                values.append(str(val))
            elif isinstance(val, (dict, list)):
                # JSONB type
                values.append(f"'{json.dumps(val)}'::jsonb")
            else:
                # String/text type - escape single quotes
                escaped = str(val).replace("'", "''")
                values.append(f"'{escaped}'")

        col_list = ', '.join(columns)
        val_list = ', '.join(values)

        sql_lines.append(f"INSERT INTO {table_name} ({col_list}) VALUES ({val_list});")

    return '\n'.join(sql_lines)
