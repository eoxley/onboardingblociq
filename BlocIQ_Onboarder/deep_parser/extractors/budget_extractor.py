"""
Budget Extractor - Deep parsing of service charge budgets
Extracts: year, heading, schedule, amount
"""

import re
from typing import List, Optional, Dict, Any
import openpyxl
from pathlib import Path

from ..types import BudgetItemData


class BudgetExtractor:
    """Extract budget items from Excel/CSV files"""

    def __init__(self):
        self.year_patterns = [
            r'20(\d{2})[-/](\d{2})',  # 2025-26 or 2025/26
            r'20(\d{2})',              # 2025
        ]

        self.schedule_patterns = [
            r'(?:Sch|Schedule)\s*(\d+)',
            r'Schedule\s+([A-Z])',
        ]

    def extract_from_excel(self, file_path: str) -> List[BudgetItemData]:
        """Extract budget items from Excel file"""
        budgets = []

        try:
            wb = openpyxl.load_workbook(file_path, data_only=True)
            ws = wb.active

            # Convert to list of dicts
            rows = []
            headers = None

            for i, row in enumerate(ws.iter_rows(values_only=True)):
                if i == 0 or not headers:
                    # Try to detect headers
                    if any(cell and isinstance(cell, str) and any(h in cell.lower() for h in ['heading', 'description', 'cost', 'budget', 'amount']) for cell in row):
                        headers = [str(cell).strip() if cell else f'col_{j}' for j, cell in enumerate(row)]
                        continue

                if headers and row:
                    row_dict = dict(zip(headers, row))
                    rows.append(row_dict)

            # Extract from rows
            budgets = self.extract(rows, Path(file_path).name)

        except Exception as e:
            print(f"Error reading Excel: {e}")

        return budgets

    def extract(self, rows: List[Dict], filename: str) -> List[BudgetItemData]:
        """
        Extract budget items from parsed rows
        ONLY include rows tied to a service charge YEAR
        """
        budgets = []

        # Detect service charge year
        year = self._detect_year(filename, rows)

        if not year:
            return budgets  # Skip if no year found

        for row in rows:
            # Try various column names for heading
            heading = (
                row.get('Heading') or
                row.get('Cost Heading') or
                row.get('Description') or
                row.get('Item') or
                row.get('Cost Description') or
                row.get('Budget Heading')
            )

            # Try various column names for amount
            amount = (
                row.get('Amount') or
                row.get('Budget') or
                row.get('Total') or
                row.get('Budget Amount') or
                row.get('Annual Budget') or
                row.get('Value')
            )

            # Try various column names for schedule
            schedule = (
                row.get('Schedule') or
                row.get('Sch') or
                row.get('Apportionment')
            )

            if not heading:
                continue

            # Skip if heading looks like a header or total row
            heading_str = str(heading).strip()
            if not heading_str or heading_str.lower() in ['total', 'sub-total', 'heading', 'description']:
                continue

            # Parse amount
            amount_val = self._parse_amount(amount)

            # Parse schedule
            schedule_str = self._parse_schedule(schedule)

            # Calculate confidence
            confidence = self._calculate_confidence(heading_str, amount_val, schedule_str)

            budgets.append(BudgetItemData(
                service_charge_year=year,
                heading=heading_str,
                schedule=schedule_str,
                amount=amount_val,
                currency='GBP',
                source_file=filename,
                confidence=confidence
            ))

        return budgets

    def _detect_year(self, filename: str, rows: List[Dict]) -> Optional[str]:
        """Detect service charge year from filename or content"""

        # From filename: "Budget 2025-26.xlsx" -> "2025/26"
        for pattern in self.year_patterns:
            match = re.search(pattern, filename)
            if match:
                year1 = f"20{match.group(1)}"
                if len(match.groups()) > 1 and match.group(2):
                    return f"{year1}/{match.group(2)}"
                return year1

        # From header rows (first 5 rows)
        for row in rows[:5]:
            for key, val in row.items():
                if val:
                    val_str = str(val)
                    for pattern in self.year_patterns:
                        match = re.search(pattern, val_str)
                        if match:
                            year1 = f"20{match.group(1)}"
                            if len(match.groups()) > 1 and match.group(2):
                                return f"{year1}/{match.group(2)}"
                            return year1

        return None

    def _parse_amount(self, amount: Any) -> Optional[float]:
        """
        Parse amount from various formats
        Default: null if not found
        NEVER return 0 unless explicitly "0" or "0.00"
        """
        if amount is None or amount == '':
            return None

        # Handle numeric types
        if isinstance(amount, (int, float)):
            return float(amount)

        # Handle string
        amount_str = str(amount).strip()

        # Check for explicit zero
        if amount_str in ['0', '0.00', '0.0']:
            return 0.0

        # Check for empty/placeholder values
        if amount_str in ['-', '—', 'N/A', 'TBC', '']:
            return None

        # Remove currency symbols and commas
        amount_str = re.sub(r'[£$€,\s]', '', amount_str)

        # Remove parentheses (negative)
        is_negative = False
        if amount_str.startswith('(') and amount_str.endswith(')'):
            is_negative = True
            amount_str = amount_str[1:-1]

        # Try to parse
        try:
            value = float(amount_str)
            return -value if is_negative else value
        except:
            return None

    def _parse_schedule(self, schedule: Any) -> Optional[str]:
        """Parse schedule reference"""
        if not schedule:
            return None

        schedule_str = str(schedule).strip()

        # Look for schedule pattern
        for pattern in self.schedule_patterns:
            match = re.search(pattern, schedule_str, re.IGNORECASE)
            if match:
                return f"Sch{match.group(1)}"

        # If it's just a number, assume it's a schedule
        if schedule_str.isdigit():
            return f"Sch{schedule_str}"

        return schedule_str if schedule_str else None

    def _calculate_confidence(
        self,
        heading: str,
        amount: Optional[float],
        schedule: Optional[str]
    ) -> float:
        """Calculate confidence score 0-1"""
        score = 0.0

        if heading and len(heading) > 3:
            score += 0.4
        if amount is not None:
            score += 0.4
        if schedule:
            score += 0.2

        return min(1.0, score)
