"""
Unit tests for lease extractor.
Tests parsing of lease documents with peppercorn rent, term years, etc.
"""
import unittest
from datetime import date
from pathlib import Path
import sys

# Add parent directories to path
sys.path.insert(0, str(Path(__file__).parent.parent.parent))

from deep_parser.extractors.lease_extractor import extract_lease_data


class TestLeaseExtractor(unittest.TestCase):
    """Test lease extraction logic"""

    def setUp(self):
        """Load fixture"""
        fixture_path = Path(__file__).parent.parent / 'fixtures' / 'lease_peppercorn.txt'
        with open(fixture_path, 'r') as f:
            self.lease_text = f.read()

    def test_unit_ref_extraction(self):
        """Should extract unit reference (Flat 259)"""
        result = extract_lease_data(self.lease_text, filename="Flat_259_Lease.pdf")

        self.assertIn('unit_ref', result)
        # Should match "259" or "Flat 259"
        self.assertIn('259', result['unit_ref'])

    def test_lessee_names_extraction(self):
        """Should extract both lessee names"""
        result = extract_lease_data(self.lease_text, filename="Flat_259_Lease.pdf")

        self.assertIn('lessee_names', result)
        lessees = result['lessee_names']

        # Should contain both parties
        self.assertGreaterEqual(len(lessees), 2, "Should extract multiple lessees")
        names_str = ' '.join(lessees).upper()
        self.assertIn('JOHN SMITH', names_str)
        self.assertIn('MARY SMITH', names_str)

    def test_term_years_extraction(self):
        """Should extract 125 year term"""
        result = extract_lease_data(self.lease_text, filename="Flat_259_Lease.pdf")

        self.assertIn('term_years', result)
        self.assertEqual(result['term_years'], 125)

    def test_start_date_extraction(self):
        """Should extract start date"""
        result = extract_lease_data(self.lease_text, filename="Flat_259_Lease.pdf")

        self.assertIn('start_date', result)
        # Should be 1st January 1999
        if isinstance(result['start_date'], date):
            self.assertEqual(result['start_date'].year, 1999)
            self.assertEqual(result['start_date'].month, 1)
        else:
            self.assertIn('1999', str(result['start_date']))

    def test_end_date_computation(self):
        """Should compute end date from start + term"""
        result = extract_lease_data(self.lease_text, filename="Flat_259_Lease.pdf")

        if 'end_date' in result and result['end_date']:
            # Should be 125 years after start (2124)
            if isinstance(result['end_date'], date):
                self.assertEqual(result['end_date'].year, 2124)

    def test_peppercorn_rent(self):
        """Should extract ground rent as 'peppercorn'"""
        result = extract_lease_data(self.lease_text, filename="Flat_259_Lease.pdf")

        self.assertIn('ground_rent_text', result)
        rent_text = result['ground_rent_text'].lower()
        self.assertIn('peppercorn', rent_text)

    def test_confidence_score(self):
        """Should return confidence score"""
        result = extract_lease_data(self.lease_text, filename="Flat_259_Lease.pdf")

        # Most extractors return confidence
        if 'confidence' in result:
            self.assertGreaterEqual(result['confidence'], 0.0)
            self.assertLessEqual(result['confidence'], 1.0)


if __name__ == '__main__':
    unittest.main()
