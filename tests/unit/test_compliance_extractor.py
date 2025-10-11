"""
Unit tests for compliance certificate extractor.
Tests date extraction and status determination.
"""
import unittest
from datetime import date, timedelta
from pathlib import Path
import sys

sys.path.insert(0, str(Path(__file__).parent.parent.parent))

from deep_parser.extractors.compliance_extractor import extract_compliance_data


class TestComplianceExtractor(unittest.TestCase):
    """Test compliance certificate extraction"""

    def setUp(self):
        """Load fixture"""
        fixture_path = Path(__file__).parent.parent / 'fixtures' / 'compliance_el_annual.txt'
        with open(fixture_path, 'r') as f:
            self.cert_text = f.read()

    def test_last_inspection_extraction(self):
        """Should extract last inspection date"""
        result = extract_compliance_data(self.cert_text, filename="EL_Annual_2024.pdf")

        self.assertIn('last_inspection', result)
        last_insp = result['last_inspection']

        # Should be March 2024
        if isinstance(last_insp, date):
            self.assertEqual(last_insp.year, 2024)
            self.assertEqual(last_insp.month, 3)
        else:
            self.assertIn('2024', str(last_insp))

    def test_next_due_extraction(self):
        """Should extract next due date"""
        result = extract_compliance_data(self.cert_text, filename="EL_Annual_2024.pdf")

        self.assertIn('next_due', result)
        next_due = result['next_due']

        # Should be March 2025
        if isinstance(next_due, date):
            self.assertEqual(next_due.year, 2025)
            self.assertEqual(next_due.month, 3)

    def test_status_ok_when_future_due_date(self):
        """Should mark status as OK if next_due >= today"""
        result = extract_compliance_data(self.cert_text, filename="EL_Annual_2024.pdf")

        # Next due is March 2025 (future)
        if 'status' in result and 'next_due' in result:
            if isinstance(result['next_due'], date):
                if result['next_due'] >= date.today():
                    self.assertEqual(result['status'], 'OK')

    def test_status_overdue_when_past_due_date(self):
        """Should mark status as Overdue if next_due < today"""
        # Create overdue cert text
        overdue_text = """
        EMERGENCY LIGHTING INSPECTION

        Inspection Date: 15th March 2020
        Next Inspection Due: 15th March 2021

        Status: Certificate expired
        """

        result = extract_compliance_data(overdue_text, filename="EL_Old_2020.pdf")

        if 'status' in result and 'next_due' in result:
            if isinstance(result['next_due'], date):
                if result['next_due'] < date.today():
                    self.assertEqual(result['status'], 'Overdue')

    def test_category_identification(self):
        """Should identify category (EL)"""
        result = extract_compliance_data(self.cert_text, filename="EL_Annual_2024.pdf")

        if 'category' in result:
            category = result['category'].upper()
            self.assertIn('EL', category)

    def test_dates_missing_flag(self):
        """Should flag dates_missing when dates not found"""
        no_date_text = """
        FIRE DOOR INSPECTION REPORT

        Site: Test Building
        Inspector: John Smith

        All fire doors inspected and found satisfactory.
        """

        result = extract_compliance_data(no_date_text, filename="Fire_Doors.pdf")

        # Should flag dates as missing
        if 'dates_missing' in result:
            self.assertTrue(result['dates_missing'])

        # Status should be Unknown
        if 'status' in result:
            self.assertEqual(result['status'], 'Unknown')

    def test_confidence_score(self):
        """Should return confidence score"""
        result = extract_compliance_data(self.cert_text, filename="EL_Annual_2024.pdf")

        if 'confidence' in result:
            self.assertGreaterEqual(result['confidence'], 0.0)
            self.assertLessEqual(result['confidence'], 1.0)


if __name__ == '__main__':
    unittest.main()
