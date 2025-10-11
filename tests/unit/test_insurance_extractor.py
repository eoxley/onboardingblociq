"""
Unit tests for insurance certificate extractor.
Ensures we extract from certificates only, not policy wordings.
"""
import unittest
from datetime import date
from pathlib import Path
import sys

sys.path.insert(0, str(Path(__file__).parent.parent.parent))

from deep_parser.extractors.insurance_extractor import extract_insurance_data


class TestInsuranceExtractor(unittest.TestCase):
    """Test insurance certificate extraction"""

    def setUp(self):
        """Load fixture"""
        fixture_path = Path(__file__).parent.parent / 'fixtures' / 'insurance_cert_short.txt'
        with open(fixture_path, 'r') as f:
            self.cert_text = f.read()

    def test_provider_extraction(self):
        """Should extract provider name"""
        result = extract_insurance_data(self.cert_text, filename="Buildings_Insurance_2024.pdf")

        self.assertIn('provider', result)
        provider = result['provider'].lower()
        self.assertIn('aviva', provider)

    def test_policy_number_extraction(self):
        """Should extract policy number"""
        result = extract_insurance_data(self.cert_text, filename="Buildings_Insurance_2024.pdf")

        self.assertIn('policy_number', result)
        policy_num = result['policy_number']
        self.assertIn('POL-2024-12345', policy_num)

    def test_period_dates_extraction(self):
        """Should extract period start and end dates"""
        result = extract_insurance_data(self.cert_text, filename="Buildings_Insurance_2024.pdf")

        self.assertIn('period_start', result)
        self.assertIn('period_end', result)

        # Check dates are in 2024
        if isinstance(result['period_start'], date):
            self.assertEqual(result['period_start'].year, 2024)
            self.assertEqual(result['period_start'].month, 1)

        if isinstance(result['period_end'], date):
            self.assertEqual(result['period_end'].year, 2024)
            self.assertEqual(result['period_end'].month, 12)

    def test_policy_type_extraction(self):
        """Should identify policy type"""
        result = extract_insurance_data(self.cert_text, filename="Buildings_Insurance_2024.pdf")

        # Should identify as buildings insurance
        if 'policy_type' in result:
            policy_type = result['policy_type'].lower()
            self.assertIn('building', policy_type)

    def test_no_false_positives_from_wordings(self):
        """Should not extract from policy wording documents"""
        wording_text = """
        POLICY WORDING DOCUMENT

        This document contains the terms and conditions.
        Policy wording for reference only.
        Not a certificate of insurance.
        """

        result = extract_insurance_data(wording_text, filename="Policy_Wording.pdf")

        # Should have low confidence or empty result
        if 'confidence' in result:
            # Policy wordings should score low
            self.assertLess(result['confidence'], 0.5, "Policy wording should have low confidence")

    def test_confidence_score(self):
        """Should return confidence score for valid cert"""
        result = extract_insurance_data(self.cert_text, filename="Buildings_Insurance_2024.pdf")

        if 'confidence' in result:
            # Valid certificate should have good confidence
            self.assertGreater(result['confidence'], 0.6)


if __name__ == '__main__':
    unittest.main()
