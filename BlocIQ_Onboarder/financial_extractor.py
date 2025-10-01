"""
BlocIQ Onboarder - Financial Data Extractor
Intelligently detects and extracts budgets, service charges, and financial accounts
"""

import re
from typing import Dict, List, Optional, Tuple
from datetime import datetime
import uuid


class FinancialExtractor:
    """Extracts financial data (budgets, service charges, accounts) from parsed documents"""

    def __init__(self):
        # Define financial document patterns
        self.financial_patterns = {
            'service_charge_budget': {
                'patterns': [
                    r'service\s*charge\s*budget',
                    r'budget\s*\d{4}[/-]\d{2,4}',
                    r'annual\s*budget',
                    r'estimated\s*expenditure'
                ],
                'doc_type': 'budget'
            },
            'service_charge_accounts': {
                'patterns': [
                    r'service\s*charge\s*accounts?',
                    r'actual\s*expenditure',
                    r'certified\s*accounts?',
                    r'final\s*accounts?',
                    r'year\s*end\s*accounts?'
                ],
                'doc_type': 'accounts'
            },
            'arrears_schedule': {
                'patterns': [
                    r'arrears',
                    r'outstanding\s*charges',
                    r'debt\s*schedule'
                ],
                'doc_type': 'arrears'
            },
            'demand_notice': {
                'patterns': [
                    r'demand',
                    r'invoice',
                    r'service\s*charge\s*demand'
                ],
                'doc_type': 'demand'
            }
        }

    def extract_financial_data(self, parsed_files: List[Dict], building_id: str, building_name: str = None) -> Dict:
        """
        Extract comprehensive financial data from all parsed files

        Args:
            parsed_files: List of parsed file dictionaries
            building_id: UUID of the building
            building_name: Name of the building

        Returns:
            Dictionary with budgets, service_charge_years, and financial metadata
        """
        financial_data = {
            'budgets': [],
            'service_charge_years': [],
            'financial_summary': {}
        }

        for file_data in parsed_files:
            # Detect financial document type
            doc_type, year = self._detect_financial_document(file_data)

            if doc_type == 'budget':
                budget = self._extract_budget_data(file_data, building_id, building_name, year)
                if budget:
                    financial_data['budgets'].append(budget)

            elif doc_type == 'accounts':
                accounts = self._extract_accounts_data(file_data, building_id, building_name, year)
                if accounts:
                    financial_data['service_charge_years'].append(accounts)

        # Generate summary
        financial_data['financial_summary'] = self._generate_summary(financial_data)

        return financial_data

    def _detect_financial_document(self, file_data: Dict) -> Tuple[Optional[str], Optional[str]]:
        """Detect if file is a financial document and extract year"""

        file_name = file_data.get('file_name', '').lower()
        file_content = self._extract_text_content(file_data)

        # Extract year from filename first
        year = self._extract_year(file_name, file_content)

        # Try to match against known financial document types
        for fin_key, fin_config in self.financial_patterns.items():
            if self._matches_patterns(file_name, file_content, fin_config['patterns']):
                return fin_config['doc_type'], year

        return None, None

    def _extract_budget_data(self, file_data: Dict, building_id: str, building_name: str, year: str) -> Optional[Dict]:
        """Extract service charge budget data from Excel/CSV file"""

        file_content = self._extract_text_content(file_data)
        raw_data = self._extract_raw_data(file_data)

        if not raw_data:
            return None

        # Extract budget line items
        budget_items = self._parse_budget_line_items(raw_data)

        if not budget_items:
            return None

        # Calculate totals
        total_budget = sum(item.get('amount', 0) for item in budget_items)

        # Extract budget period
        start_date, end_date = self._extract_budget_period(file_content, file_data.get('file_name', ''), year)

        budget = {
            'id': str(uuid.uuid4()),
            'building_id': building_id,
            'building_name': building_name,
            'year': year or datetime.now().year,
            'budget_type': 'service_charge',
            'start_date': start_date,
            'end_date': end_date,
            'total_budget': total_budget,
            'status': 'approved',
            'line_items': budget_items,
            'notes': f'Imported from: {file_data.get("file_name", "")}',
            'created_at': datetime.now().isoformat(),
            'updated_at': datetime.now().isoformat()
        }

        return budget

    def _extract_accounts_data(self, file_data: Dict, building_id: str, building_name: str, year: str) -> Optional[Dict]:
        """Extract actual service charge accounts/expenditure data"""

        file_content = self._extract_text_content(file_data)
        raw_data = self._extract_raw_data(file_data)

        if not raw_data:
            return None

        # Extract actual expenditure line items
        actual_items = self._parse_expenditure_line_items(raw_data)

        if not actual_items:
            return None

        # Calculate totals
        total_actual = sum(item.get('amount', 0) for item in actual_items)

        # Extract corresponding budget amounts if present
        budget_items = self._parse_budget_line_items(raw_data)
        total_budget = sum(item.get('amount', 0) for item in budget_items) if budget_items else None

        # Calculate variance
        variance = total_actual - total_budget if total_budget else None

        # Extract period
        start_date, end_date = self._extract_budget_period(file_content, file_data.get('file_name', ''), year)

        accounts = {
            'id': str(uuid.uuid4()),
            'building_id': building_id,
            'building_name': building_name,
            'year': year or datetime.now().year,
            'period_start': start_date,
            'period_end': end_date,
            'total_budget': total_budget,
            'total_actual': total_actual,
            'total_variance': variance,
            'is_certified': self._is_certified(file_content),
            'certification_date': self._extract_certification_date(file_content),
            'line_items': actual_items,
            'status': 'final' if self._is_certified(file_content) else 'draft',
            'notes': f'Imported from: {file_data.get("file_name", "")}',
            'created_at': datetime.now().isoformat(),
            'updated_at': datetime.now().isoformat()
        }

        return accounts

    def _parse_budget_line_items(self, raw_data: List) -> List[Dict]:
        """Parse budget line items from Excel/CSV data"""

        line_items = []

        # Common budget categories to look for
        budget_categories = [
            'insurance', 'management', 'repairs', 'maintenance', 'cleaning',
            'gardening', 'lighting', 'heating', 'water', 'lift', 'security',
            'professional fees', 'accountancy', 'legal', 'reserve', 'sinking fund',
            'electricity', 'gas', 'communal', 'decoration', 'grounds'
        ]

        for row in raw_data:
            if isinstance(row, dict):
                # Try to find category and amount columns
                category = self._extract_category_from_row(row, budget_categories)
                amount = self._extract_amount_from_row(row)

                if category and amount:
                    line_items.append({
                        'category': category,
                        'amount': amount,
                        'type': 'budget'
                    })

            elif isinstance(row, list) and len(row) >= 2:
                # First column = category, find amount in subsequent columns
                category_text = str(row[0]).lower().strip()

                for cat in budget_categories:
                    if cat in category_text and len(category_text) < 100:  # Reasonable length
                        # Look for amount in row
                        for cell in row[1:]:
                            amount = self._parse_amount(cell)
                            if amount:
                                line_items.append({
                                    'category': category_text.title(),
                                    'amount': amount,
                                    'type': 'budget'
                                })
                                break
                        break

        return line_items

    def _parse_expenditure_line_items(self, raw_data: List) -> List[Dict]:
        """Parse actual expenditure line items (similar logic to budget, but looks for 'actual' columns)"""

        line_items = []

        budget_categories = [
            'insurance', 'management', 'repairs', 'maintenance', 'cleaning',
            'gardening', 'lighting', 'heating', 'water', 'lift', 'security',
            'professional fees', 'accountancy', 'legal', 'reserve', 'sinking fund',
            'electricity', 'gas', 'communal', 'decoration', 'grounds'
        ]

        for row in raw_data:
            if isinstance(row, dict):
                category = self._extract_category_from_row(row, budget_categories)
                # Look for actual amount (not budget)
                amount = self._extract_actual_amount_from_row(row)

                if category and amount:
                    line_items.append({
                        'category': category,
                        'amount': amount,
                        'type': 'actual'
                    })

            elif isinstance(row, list) and len(row) >= 2:
                category_text = str(row[0]).lower().strip()

                for cat in budget_categories:
                    if cat in category_text and len(category_text) < 100:
                        # Look for amount in row (prefer 'actual' column if exists)
                        for cell in row[1:]:
                            amount = self._parse_amount(cell)
                            if amount:
                                line_items.append({
                                    'category': category_text.title(),
                                    'amount': amount,
                                    'type': 'actual'
                                })
                                break
                        break

        return line_items

    def _extract_category_from_row(self, row: Dict, categories: List[str]) -> Optional[str]:
        """Extract budget category from row"""

        for key, value in row.items():
            if isinstance(value, str):
                value_lower = value.lower()
                for cat in categories:
                    if cat in value_lower and len(value) < 100:
                        return value.strip().title()

        return None

    def _extract_amount_from_row(self, row: Dict) -> Optional[float]:
        """Extract amount from row (looks for any numeric value)"""

        # Look for keys that might contain amounts
        amount_keys = ['amount', 'budget', 'estimated', 'total', 'cost', 'price', 'value']

        for key in amount_keys:
            for row_key, value in row.items():
                if key in str(row_key).lower():
                    amount = self._parse_amount(value)
                    if amount:
                        return amount

        # Fallback: look for any numeric value
        for value in row.values():
            amount = self._parse_amount(value)
            if amount and amount > 0:
                return amount

        return None

    def _extract_actual_amount_from_row(self, row: Dict) -> Optional[float]:
        """Extract actual amount from row (prefers 'actual' columns)"""

        # Prefer actual amounts
        actual_keys = ['actual', 'expenditure', 'spent', 'incurred']

        for key in actual_keys:
            for row_key, value in row.items():
                if key in str(row_key).lower():
                    amount = self._parse_amount(value)
                    if amount:
                        return amount

        # Fallback to any amount
        return self._extract_amount_from_row(row)

    def _parse_amount(self, value) -> Optional[float]:
        """Parse monetary amount from various formats"""

        if value is None:
            return None

        # If already a number
        if isinstance(value, (int, float)):
            return float(value) if value > 0 else None

        # Parse from string
        if isinstance(value, str):
            # Remove currency symbols and commas
            cleaned = re.sub(r'[£$€,\s]', '', value)

            # Remove brackets (negative numbers)
            cleaned = cleaned.replace('(', '-').replace(')', '')

            # Extract numeric value
            match = re.search(r'-?[\d.]+', cleaned)
            if match:
                try:
                    amount = float(match.group())
                    # Reasonable range check (£1 to £10M)
                    if 1 <= abs(amount) <= 10000000:
                        return amount
                except ValueError:
                    pass

        return None

    def _extract_year(self, filename: str, content: str) -> Optional[str]:
        """Extract financial year from filename or content"""

        # Try filename first
        year_match = re.search(r'20\d{2}', filename)
        if year_match:
            return year_match.group()

        # Try content - look for "Year ending YYYY" or "FY YYYY"
        year_patterns = [
            r'year\s*ending[:\s]*(\d{4})',
            r'financial\s*year[:\s]*(\d{4})',
            r'fy[:\s]*(\d{4})',
            r'period[:\s]*\d{1,2}/\d{1,2}/(\d{4})'
        ]

        for pattern in year_patterns:
            match = re.search(pattern, content, re.IGNORECASE)
            if match:
                return match.group(1)

        return None

    def _extract_budget_period(self, content: str, filename: str, year: str) -> Tuple[Optional[str], Optional[str]]:
        """Extract budget period start and end dates"""

        # Try to find explicit dates
        period_patterns = [
            r'period[:\s]*(\d{1,2}[/-]\d{1,2}[/-]\d{2,4})\s*to\s*(\d{1,2}[/-]\d{1,2}[/-]\d{2,4})',
            r'from[:\s]*(\d{1,2}[/-]\d{1,2}[/-]\d{2,4})\s*to\s*(\d{1,2}[/-]\d{1,2}[/-]\d{2,4})'
        ]

        for pattern in period_patterns:
            match = re.search(pattern, content, re.IGNORECASE)
            if match:
                start = self._normalize_date(match.group(1))
                end = self._normalize_date(match.group(2))
                if start and end:
                    return start, end

        # Fallback: use year to create standard financial year
        if year:
            return f"{year}-04-01", f"{int(year)+1}-03-31"

        return None, None

    def _is_certified(self, content: str) -> bool:
        """Check if accounts are certified"""
        return bool(re.search(r'certified|audited|approved', content, re.IGNORECASE))

    def _extract_certification_date(self, content: str) -> Optional[str]:
        """Extract certification/approval date"""

        patterns = [
            r'certified\s*(?:on|date)[:\s]*(\d{1,2}[/-]\d{1,2}[/-]\d{2,4})',
            r'approved[:\s]*(\d{1,2}[/-]\d{1,2}[/-]\d{2,4})'
        ]

        for pattern in patterns:
            match = re.search(pattern, content, re.IGNORECASE)
            if match:
                return self._normalize_date(match.group(1))

        return None

    def _extract_text_content(self, file_data: Dict) -> str:
        """Extract all text content from parsed file data"""
        content_parts = []

        if 'data' in file_data:
            data = file_data['data']

            if isinstance(data, dict):
                for sheet_name, sheet_data in data.items():
                    if isinstance(sheet_data, dict) and 'raw_data' in sheet_data:
                        for row in sheet_data['raw_data']:
                            content_parts.append(str(row))

            elif isinstance(data, str):
                content_parts.append(data)

        return ' '.join(content_parts)[:10000]

    def _extract_raw_data(self, file_data: Dict) -> List:
        """Extract raw tabular data from Excel/CSV files"""

        if 'data' not in file_data:
            return []

        data = file_data['data']

        if isinstance(data, dict):
            # Excel file - get first sheet's data
            for sheet_name, sheet_data in data.items():
                if isinstance(sheet_data, dict) and 'raw_data' in sheet_data:
                    return sheet_data['raw_data']

        return []

    def _matches_patterns(self, file_name: str, content: str, patterns: List[str]) -> bool:
        """Check if filename or content matches any of the patterns"""
        search_text = f"{file_name} {content}".lower()

        for pattern in patterns:
            if re.search(pattern, search_text, re.IGNORECASE):
                return True

        return False

    def _normalize_date(self, date_string: str) -> Optional[str]:
        """Normalize date string to ISO format YYYY-MM-DD"""

        for separator in ['/', '-']:
            pattern = f'(\\d{{1,2}}){separator}(\\d{{1,2}}){separator}(\\d{{2,4}})'
            match = re.match(pattern, date_string)
            if match:
                day, month, year = match.groups()

                if len(year) == 2:
                    year = f"20{year}"

                try:
                    date_obj = datetime(int(year), int(month), int(day))
                    return date_obj.date().isoformat()
                except ValueError:
                    continue

        return None

    def _generate_summary(self, financial_data: Dict) -> Dict:
        """Generate financial summary statistics"""

        summary = {
            'total_budgets': len(financial_data['budgets']),
            'total_years': len(financial_data['service_charge_years']),
            'years_covered': []
        }

        # Get unique years
        years = set()
        for budget in financial_data['budgets']:
            if budget.get('year'):
                years.add(str(budget['year']))
        for accounts in financial_data['service_charge_years']:
            if accounts.get('year'):
                years.add(str(accounts['year']))

        summary['years_covered'] = sorted(list(years))

        return summary
