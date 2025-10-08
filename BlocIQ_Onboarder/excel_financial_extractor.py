"""
BlocIQ Onboarder - Excel Financial Data Extractor
Extracts budgets, apportionments, and insurance metadata from Excel files without OCR
"""

import re
import pandas as pd
from pathlib import Path
from datetime import datetime
from typing import Dict, List, Optional, Tuple
import uuid


class ExcelFinancialExtractor:
    """Extract financial data directly from Excel files"""

    def __init__(self, parsed_files: List[Dict], mapped_data: Dict):
        """
        Initialize Excel financial extractor

        Args:
            parsed_files: List of parsed file dictionaries
            mapped_data: Mapped data with building and unit info
        """
        self.parsed_files = parsed_files
        self.mapped_data = mapped_data
        self.building_id = mapped_data.get('building', {}).get('id')

        # Results
        self.budgets = []
        self.apportionments = []
        self.insurance_records = []
        self.errors = []

    def extract_all(self) -> Dict:
        """
        Extract all financial data from Excel files

        Returns:
            Dictionary with extracted financial data and errors
        """
        print("  💰 Extracting financial data from Excel files...")

        for parsed_file in self.parsed_files:
            file_path = parsed_file.get('file_path', '')
            file_name = parsed_file.get('file_name', '')
            category = parsed_file.get('category', '')

            # Check if this is a financial file
            if not self._is_financial_file(file_name, category):
                continue

            file_ext = Path(file_path).suffix.lower()

            # Process Excel files directly
            if file_ext in ['.xlsx', '.xls']:
                self._process_excel_file(file_path, file_name)

            # Process PDFs (metadata only)
            elif file_ext == '.pdf':
                self._process_pdf_metadata(file_path, file_name)

        print(f"     ✅ Budgets extracted: {len(self.budgets)}")
        print(f"     ✅ Apportionments extracted: {len(self.apportionments)}")
        print(f"     ✅ Insurance records: {len(self.insurance_records)}")
        if self.errors:
            print(f"     ⚠️  Errors: {len(self.errors)}")

        return {
            'budgets': self.budgets,
            'apportionments': self.apportionments,
            'building_insurance': self.insurance_records,
            'errors': self.errors
        }

    def _is_financial_file(self, file_name: str, category: str) -> bool:
        """Check if file is likely to contain financial data"""
        file_name_lower = file_name.lower()

        # Check category
        if category == 'finance':
            return True

        # Check filename keywords
        financial_keywords = [
            'budget', 'accounts', 'service charge', 'apportionment',
            'insurance', 'policy', 'summary of cover', 'certificate',
            'financial', 'expenditure', 'income'
        ]

        return any(keyword in file_name_lower for keyword in financial_keywords)

    def _process_excel_file(self, file_path: str, file_name: str):
        """Process Excel file for financial data"""
        try:
            # Read all sheets
            excel_file = pd.ExcelFile(file_path)

            for sheet_name in excel_file.sheet_names:
                df = pd.read_excel(file_path, sheet_name=sheet_name)

                # Try budget extraction
                self._extract_budget_from_sheet(df, sheet_name, file_name)

                # Try apportionment extraction
                self._extract_apportionments_from_sheet(df, file_name)

                # Try insurance extraction
                self._extract_insurance_from_sheet(df, file_name)

        except Exception as e:
            error_msg = f"Error processing Excel file {file_name}: {str(e)}"
            self.errors.append({
                'file': file_name,
                'error': str(e),
                'type': 'excel_processing'
            })
            print(f"     ⚠️  {error_msg}")

    def _extract_budget_from_sheet(self, df: pd.DataFrame, sheet_name: str, file_name: str):
        """Extract budget data from Excel sheet"""
        # Check if this looks like a budget sheet
        budget_keywords = ['budget', 'account', 'total', 'actual', 'description']

        # Get all column names (case-insensitive)
        columns_lower = [str(col).lower() for col in df.columns]

        # Check if any budget keywords are in columns
        has_budget_columns = any(
            any(keyword in col for keyword in budget_keywords)
            for col in columns_lower
        )

        if not has_budget_columns:
            return

        # Extract year from filename or sheet name
        year_start, year_end = self._extract_years(file_name, sheet_name)

        # Extract total amount
        total_amount = self._extract_total_from_dataframe(df)

        # Determine status
        status = 'draft' if 'draft' in file_name.lower() else 'final'

        # Generate period label from years or filename
        period = self._generate_period_label(year_start, year_end, file_name)

        # Create budget record
        budget = {
            'id': str(uuid.uuid4()),
            'building_id': self.building_id,
            'period': period,
            'year_start': year_start,
            'year_end': year_end,
            'total_amount': total_amount,
            'status': status,
            'source_document': file_name
        }

        # Only add if we have at least a year or total
        if year_start or total_amount:
            self.budgets.append(budget)

            # Log warning if total is missing
            if not total_amount:
                self.errors.append({
                    'file': file_name,
                    'error': 'Missing total in budget',
                    'type': 'budget_missing_total'
                })

    def _extract_apportionments_from_sheet(self, df: pd.DataFrame, file_name: str):
        """Extract apportionment data from Excel sheet"""
        # Look for columns indicating apportionments
        columns_lower = {str(col).lower(): col for col in df.columns}

        # Find unit/flat column
        unit_col = None
        for keyword in ['flat', 'unit', 'apartment', 'property']:
            matching_cols = [col for col_lower, col in columns_lower.items() if keyword in col_lower]
            if matching_cols:
                unit_col = matching_cols[0]
                break

        # Find percentage column
        percentage_col = None
        for keyword in ['apportionment', '%', 'percent', 'share']:
            matching_cols = [col for col_lower, col in columns_lower.items() if keyword in col_lower]
            if matching_cols:
                percentage_col = matching_cols[0]
                break

        # If we have both columns, extract data
        if unit_col and percentage_col:
            units = self.mapped_data.get('units', [])

            for _, row in df.iterrows():
                try:
                    unit_name = str(row[unit_col]).strip()
                    percentage_value = row[percentage_col]

                    # Clean percentage value
                    if pd.isna(percentage_value):
                        continue

                    # Convert to float
                    if isinstance(percentage_value, str):
                        percentage_value = percentage_value.replace('%', '').strip()

                    percentage = float(percentage_value)

                    # Find matching unit
                    unit_id = self._find_unit_id(unit_name, units)

                    apportionment = {
                        'id': str(uuid.uuid4()),
                        'building_id': self.building_id,
                        'unit_id': unit_id,
                        'percentage': percentage,
                        'source_document': file_name
                    }

                    self.apportionments.append(apportionment)

                except (ValueError, TypeError, KeyError):
                    continue

    def _extract_insurance_from_sheet(self, df: pd.DataFrame, file_name: str):
        """Extract insurance data from Excel sheet"""
        # Check if this looks like an insurance document
        if not any(keyword in file_name.lower() for keyword in ['insurance', 'policy', 'cover']):
            return

        columns_lower = {str(col).lower(): col for col in df.columns}

        # Try to find insurance-related data
        provider = None
        policy_number = None
        expiry_date = None

        # Look for provider
        for keyword in ['provider', 'insurer', 'company']:
            matching_cols = [col for col_lower, col in columns_lower.items() if keyword in col_lower]
            if matching_cols and not df[matching_cols[0]].empty:
                provider = str(df[matching_cols[0]].iloc[0])
                break

        # Look for policy number
        for keyword in ['policy', 'number', 'reference']:
            matching_cols = [col for col_lower, col in columns_lower.items() if keyword in col_lower]
            if matching_cols and not df[matching_cols[0]].empty:
                policy_number = str(df[matching_cols[0]].iloc[0])
                break

        # Look for expiry date
        for keyword in ['expiry', 'renewal', 'end date']:
            matching_cols = [col for col_lower, col in columns_lower.items() if keyword in col_lower]
            if matching_cols and not df[matching_cols[0]].empty:
                expiry_value = df[matching_cols[0]].iloc[0]
                if pd.notna(expiry_value):
                    expiry_date = self._parse_date(expiry_value)
                break

        # Create insurance record if we have any data
        if provider or policy_number or expiry_date:
            insurance = {
                'id': str(uuid.uuid4()),
                'building_id': self.building_id,
                'insurance_type': 'general',  # Required NOT NULL column
                'provider': provider,
                'policy_number': policy_number,
                'expiry_date': expiry_date,
                'source_document': file_name
            }

            self.insurance_records.append(insurance)

    def _process_pdf_metadata(self, file_path: str, file_name: str):
        """Process PDF metadata only (no OCR)"""
        # Check if this is an insurance document
        if not any(keyword in file_name.lower() for keyword in ['insurance', 'policy', 'certificate', 'cover']):
            return

        # Extract year from filename if possible
        year_match = re.search(r'20(\d{2})', file_name)
        inferred_year = f"20{year_match.group(1)}" if year_match else None

        # Create insurance record with metadata only
        insurance = {
            'id': str(uuid.uuid4()),
            'building_id': self.building_id,
            'insurance_type': 'general',  # Required NOT NULL column
            'provider': None,
            'policy_number': None,
            'expiry_date': None,
            'source_document': file_name,
            'notes': f"PDF metadata only. Inferred year: {inferred_year}" if inferred_year else "PDF metadata only"
        }

        self.insurance_records.append(insurance)

    def _generate_period_label(self, year_start: Optional[str], year_end: Optional[str], file_name: str) -> str:
        """Generate period label for budgets table (NOT NULL column)"""
        # Try to generate from year_start and year_end
        if year_start and year_end:
            try:
                # Extract years from dates
                start_year = year_start[:4] if year_start else ''
                end_year = year_end[:4] if year_end else ''
                return f"{start_year}-{end_year}"
            except:
                pass
        
        # Try to extract from filename
        # Pattern: "2025-26" or "2025-2026" or "YE25" or "Budget 2025"
        year_patterns = [
            r'(\d{4})[_\-](\d{2,4})',  # 2025-26 or 2025-2026
            r'YE\s*(\d{2,4})',          # YE25
            r'20(\d{2})',                # 2025
        ]
        
        for pattern in year_patterns:
            match = re.search(pattern, file_name, re.IGNORECASE)
            if match:
                if len(match.groups()) == 2:
                    return f"{match.group(1)}-{match.group(2)}"
                else:
                    year = match.group(1)
                    if len(year) == 2:
                        year = f"20{year}"
                    return f"YE{year}"
        
        # Fallback: use filename without extension
        base_name = file_name.rsplit('.', 1)[0]
        if len(base_name) > 50:
            base_name = base_name[:50]
        return base_name if base_name else 'Budget'

    def _extract_years(self, file_name: str, sheet_name: str) -> Tuple[Optional[str], Optional[str]]:
        """Extract year_start and year_end from filename or sheet name"""
        text = f"{file_name} {sheet_name}"

        # Pattern 1: "2025-26" or "2025-6"
        pattern1 = r'(\d{4})[_\-\s](\d{1,4})'
        match1 = re.search(pattern1, text)

        if match1:
            year1 = int(match1.group(1))
            year2_str = match1.group(2)

            # Handle short form (e.g., "25-6" means 2025-2026)
            if len(year2_str) <= 2:
                year2 = int(f"{year1 // 100}{year2_str:0>2}")
            else:
                year2 = int(year2_str)

            # Create fiscal year dates (April to March)
            year_start = f"{year1}-04-01"
            year_end = f"{year2}-03-31"

            return year_start, year_end

        # Pattern 2: Single year "2025" or "Budget 2025"
        pattern2 = r'(?:budget|accounts?|financial)?\s*(\d{4})'
        match2 = re.search(pattern2, text, re.IGNORECASE)

        if match2:
            year = int(match2.group(1))
            year_start = f"{year}-04-01"
            year_end = f"{year + 1}-03-31"

            return year_start, year_end

        return None, None

    def _extract_total_from_dataframe(self, df: pd.DataFrame) -> Optional[float]:
        """Extract total amount from dataframe"""
        # Look for columns with "total" in the name
        total_cols = [col for col in df.columns if 'total' in str(col).lower()]

        for col in total_cols:
            try:
                # Try to find the largest numeric value in the column
                numeric_values = pd.to_numeric(df[col], errors='coerce').dropna()

                if not numeric_values.empty:
                    # Return the maximum value (likely the total)
                    return float(numeric_values.max())
            except:
                continue

        # If no "total" column, try summing all numeric columns
        try:
            numeric_cols = df.select_dtypes(include=['number']).columns
            if len(numeric_cols) > 0:
                # Sum the first numeric column that looks like amounts
                for col in numeric_cols:
                    values = df[col].dropna()
                    if len(values) > 0 and values.max() > 100:  # Likely currency values
                        return float(values.sum())
        except:
            pass

        return None

    def _find_unit_id(self, unit_name: str, units: List[Dict]) -> Optional[str]:
        """Find unit ID by matching unit name"""
        if not unit_name or pd.isna(unit_name):
            return None

        unit_name_clean = str(unit_name).strip().lower()

        # Try exact match first
        for unit in units:
            if unit.get('name', '').lower() == unit_name_clean:
                return unit.get('id')

        # Try partial match (e.g., "Flat 1" matches "1")
        for unit in units:
            unit_name_db = unit.get('name', '').lower()
            if unit_name_clean in unit_name_db or unit_name_db in unit_name_clean:
                return unit.get('id')

        # Extract number and try matching
        number_match = re.search(r'\d+', unit_name_clean)
        if number_match:
            unit_number = number_match.group()
            for unit in units:
                if unit_number in unit.get('name', '').lower():
                    return unit.get('id')

        return None

    def _parse_date(self, date_value) -> Optional[str]:
        """Parse date value to ISO format string"""
        try:
            if isinstance(date_value, str):
                # Try common date formats
                for fmt in ['%Y-%m-%d', '%d/%m/%Y', '%m/%d/%Y', '%d-%m-%Y', '%Y/%m/%d']:
                    try:
                        dt = datetime.strptime(date_value, fmt)
                        return dt.strftime('%Y-%m-%d')
                    except ValueError:
                        continue

            elif isinstance(date_value, datetime):
                return date_value.strftime('%Y-%m-%d')

            elif pd.notna(date_value):
                # Try pandas datetime conversion
                dt = pd.to_datetime(date_value)
                return dt.strftime('%Y-%m-%d')

        except:
            pass

        return None
