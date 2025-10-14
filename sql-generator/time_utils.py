"""
SQL Generator - Time Utilities
Handle renewal cycles, date calculations, and status determination
"""

import json
from datetime import datetime, timedelta
from dateutil.relativedelta import relativedelta
from pathlib import Path
from typing import Dict, Optional, List


class RenewalCalculator:
    """Calculate renewal dates and determine document status"""

    def __init__(self, config_path: str = None):
        """
        Initialize with renewal rules

        Args:
            config_path: Path to renewal_rules.json
        """
        if config_path is None:
            config_path = Path(__file__).parent / 'config' / 'renewal_rules.json'

        # Load renewal rules
        with open(config_path, 'r') as f:
            self.renewal_rules = json.load(f)

    def calculate_next_due(self, inspection_date: str, document_type: str) -> Optional[str]:
        """
        Calculate next due date based on inspection date and document type

        Args:
            inspection_date: ISO format date string (YYYY-MM-DD)
            document_type: Type of document (e.g., 'FRA', 'EICR')

        Returns:
            Next due date in ISO format, or None if cannot calculate
        """
        if not inspection_date:
            return None

        try:
            # Parse inspection date
            dt = datetime.strptime(inspection_date, '%Y-%m-%d')

            # Get renewal period in months (default to 12)
            months = self.renewal_rules.get(document_type, 12)

            # Calculate next due date
            next_due = dt + relativedelta(months=months)

            return next_due.strftime('%Y-%m-%d')

        except Exception as e:
            return None

    def calculate_days_until_due(self, due_date: str) -> Optional[int]:
        """
        Calculate days until due date

        Args:
            due_date: ISO format date string

        Returns:
            Number of days (negative if overdue)
        """
        if not due_date:
            return None

        try:
            dt = datetime.strptime(due_date, '%Y-%m-%d')
            today = datetime.now()
            delta = dt - today
            return delta.days
        except:
            return None

    def determine_status(self, next_due_date: str, grace_period_days: int = 0) -> str:
        """
        Determine document status based on due date

        Args:
            next_due_date: ISO format date string
            grace_period_days: Grace period after expiry

        Returns:
            Status: 'current', 'due_soon', 'expired', or 'unknown'
        """
        if not next_due_date:
            return 'unknown'

        days_until = self.calculate_days_until_due(next_due_date)

        if days_until is None:
            return 'unknown'

        # Expired (beyond grace period)
        if days_until < -grace_period_days:
            return 'expired'

        # Due soon (within 30 days)
        elif days_until <= 30:
            return 'due_soon'

        # Current
        else:
            return 'current'

    def calculate_urgency_score(self, next_due_date: str) -> int:
        """
        Calculate urgency score (0-100) based on how soon document is due

        Args:
            next_due_date: ISO format date string

        Returns:
            Urgency score (100 = critical/overdue, 0 = far in future)
        """
        days_until = self.calculate_days_until_due(next_due_date)

        if days_until is None:
            return 0

        # Overdue - critical
        if days_until < 0:
            return 100

        # Due within 7 days - very urgent
        elif days_until <= 7:
            return 90

        # Due within 30 days - urgent
        elif days_until <= 30:
            return 75

        # Due within 60 days - moderate
        elif days_until <= 60:
            return 50

        # Due within 90 days - low
        elif days_until <= 90:
            return 25

        # More than 90 days - very low
        else:
            return 10


class DocumentStatusManager:
    """Manage document status and determine most recent documents"""

    def __init__(self, renewal_calculator: RenewalCalculator):
        self.renewal_calc = renewal_calculator

    def process_documents(self, documents: List[Dict]) -> List[Dict]:
        """
        Process documents to determine status and mark most recent

        Args:
            documents: List of document dictionaries with metadata

        Returns:
            Processed documents with status and is_current flags
        """
        # Group by document type
        by_type = {}
        for doc in documents:
            doc_type = doc.get('document_type')
            if doc_type not in by_type:
                by_type[doc_type] = []
            by_type[doc_type].append(doc)

        # Process each group
        processed = []
        for doc_type, docs in by_type.items():
            # Sort by inspection date (most recent first)
            docs_sorted = sorted(
                docs,
                key=lambda d: d.get('inspection_date') or '1900-01-01',
                reverse=True
            )

            # Mark most recent as current
            for i, doc in enumerate(docs_sorted):
                # Calculate next due if not present
                if not doc.get('next_due_date') and doc.get('inspection_date'):
                    doc['next_due_date'] = self.renewal_calc.calculate_next_due(
                        doc['inspection_date'],
                        doc_type
                    )

                # Determine status
                if doc.get('next_due_date'):
                    doc['status'] = self.renewal_calc.determine_status(doc['next_due_date'])
                    doc['days_until_due'] = self.renewal_calc.calculate_days_until_due(
                        doc['next_due_date']
                    )
                    doc['urgency_score'] = self.renewal_calc.calculate_urgency_score(
                        doc['next_due_date']
                    )
                else:
                    doc['status'] = 'unknown'

                # Mark most recent as current
                doc['is_current'] = (i == 0)

                processed.append(doc)

        return processed

    def identify_missing_documents(
        self,
        documents: List[Dict],
        expected_docs: List[str]
    ) -> List[Dict]:
        """
        Identify missing required documents

        Args:
            documents: List of processed documents
            expected_docs: List of expected document types

        Returns:
            List of missing document records
        """
        # Get document types present
        present_types = set(doc.get('document_type') for doc in documents)

        # Find missing types
        missing = []
        for doc_type in expected_docs:
            if doc_type not in present_types:
                missing.append({
                    'document_type': doc_type,
                    'status': 'missing',
                    'is_current': False,
                    'file_name': None,
                    'file_path': None
                })

        return missing


def load_expected_documents(config_path: str = None, building_config: Dict = None) -> List[str]:
    """
    Load expected documents based on building configuration

    Args:
        config_path: Path to expected_docs.json
        building_config: Building configuration (e.g., has_lifts, over_11m)

    Returns:
        List of expected document types
    """
    if config_path is None:
        config_path = Path(__file__).parent / 'config' / 'expected_docs.json'

    with open(config_path, 'r') as f:
        rules = json.load(f)

    # Start with default documents
    expected = list(rules['default'])

    if building_config is None:
        building_config = {}

    # Add conditional documents
    if building_config.get('has_lifts'):
        expected.extend(rules.get('has_lifts', []))

    if building_config.get('over_11m'):
        expected.extend(rules.get('over_11m', []))

    if building_config.get('has_gas'):
        expected.extend(rules.get('has_gas', []))

    if building_config.get('has_communal_electrics'):
        expected.extend(rules.get('has_communal_electrics', []))

    # Check other conditional documents
    for condition, doc_types in rules.get('conditional', {}).items():
        if building_config.get(condition):
            expected.extend(doc_types)

    return list(set(expected))  # Remove duplicates


# Test function
if __name__ == '__main__':
    calculator = RenewalCalculator()

    # Test calculations
    print("Testing renewal calculations:")

    # FRA - 12 months
    next_due = calculator.calculate_next_due('2025-03-04', 'FRA')
    print(f"FRA next due: {next_due}")

    # EICR - 60 months
    next_due = calculator.calculate_next_due('2022-01-15', 'EICR')
    print(f"EICR next due: {next_due}")

    # Status determination
    status = calculator.determine_status('2025-12-01')
    print(f"Status for 2025-12-01: {status}")

    status = calculator.determine_status('2025-10-20')
    print(f"Status for 2025-10-20: {status}")

    status = calculator.determine_status('2024-01-01')
    print(f"Status for 2024-01-01: {status}")
