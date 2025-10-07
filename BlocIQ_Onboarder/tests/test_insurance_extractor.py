"""
Unit tests for Insurance Extractor
"""

import sys
from pathlib import Path
sys.path.insert(0, str(Path(__file__).parent.parent))

from extractors.insurance_extractor import InsuranceExtractor


def test_extract_insurer():
    """Test insurer extraction"""
    extractor = InsuranceExtractor()

    # Test with Zurich
    text = "Policy issued by Zurich Insurance Company"
    insurer = extractor._extract_insurer(text, "")
    assert insurer == "Zurich"

    # Test with Aviva
    text = "Underwriter: Aviva plc"
    insurer = extractor._extract_insurer(text, "")
    assert insurer == "Aviva"


def test_extract_policy_number():
    """Test policy number extraction"""
    extractor = InsuranceExtractor()

    # Test standard format
    text = "Policy Number: POL123456789"
    policy_no = extractor._extract_policy_number(text)
    assert policy_no == "POL123456789"

    # Test with ref
    text = "Ref: XYZ987654"
    policy_no = extractor._extract_policy_number(text)
    assert policy_no == "XYZ987654"


def test_extract_sum_insured():
    """Test sum insured extraction"""
    extractor = InsuranceExtractor()

    # Test with currency
    text = "Sum Insured: £5,000,000.00"
    sum_insured = extractor._extract_sum_insured(text)
    assert sum_insured == 5000000.00

    # Test without decimals
    text = "Total Sum Insured: £12,500,000"
    sum_insured = extractor._extract_sum_insured(text)
    assert sum_insured == 12500000.0


def test_extract_dates():
    """Test date extraction"""
    extractor = InsuranceExtractor()

    # Test start date
    text = "Period of Insurance: from 01/04/2024"
    start_date = extractor._extract_start_date(text)
    assert start_date == "2024-04-01"

    # Test end date
    text = "Expires: 31/03/2025"
    end_date = extractor._extract_end_date(text)
    assert end_date == "2025-03-31"


def test_detect_cover_type():
    """Test cover type detection"""
    extractor = InsuranceExtractor()

    # Test buildings
    text = "Buildings Insurance Schedule"
    cover_type = extractor._detect_cover_type(text, "")
    assert cover_type == "buildings"

    # Test terrorism
    text = "Terrorism cover provided by Pool Re"
    cover_type = extractor._detect_cover_type(text, "")
    assert cover_type == "terrorism"


def test_extract_full_policy():
    """Test full policy extraction"""
    extractor = InsuranceExtractor()

    # Sample policy document
    file_data = {
        'file_name': 'Insurance Policy Schedule 2024.pdf',
        'full_text': """
        INSURANCE POLICY SCHEDULE

        Policy Number: POL987654321
        Insurer: Zurich Insurance plc
        Broker: Marsh Commercial

        Period of Insurance: from 01/04/2024 to 31/03/2025

        Buildings Insurance
        Sum Insured: £8,500,000.00
        Reinstatement Value: £9,000,000.00

        Excess: £1,000 per claim
        Escape of Water Excess: £2,500
        Subsidence Excess: £5,000

        Endorsements: Extended cover for flood damage
        """
    }

    result = extractor.extract(file_data, 'building-123')

    assert result is not None
    policy = result['policy']

    assert policy['policy_number'] == 'POL987654321'
    assert policy['insurer'] == 'Zurich'
    assert policy['broker'] == 'Marsh Commercial'
    assert policy['cover_type'] == 'buildings'
    assert policy['sum_insured'] == 8500000.0
    assert policy['reinstatement_value'] == 9000000.0
    assert policy['start_date'] == '2024-04-01'
    assert policy['end_date'] == '2025-03-31'
    assert policy['policy_status'] == 'active'
    assert policy['excess_json'] is not None


def test_policy_status_determination():
    """Test policy status logic"""
    extractor = InsuranceExtractor()

    # Test active (future expiry)
    status = extractor._determine_status('2026-12-31')
    assert status == 'active'

    # Test expired (past expiry)
    status = extractor._determine_status('2023-01-01')
    assert status == 'expired'


if __name__ == '__main__':
    print("Running Insurance Extractor Tests...")

    test_extract_insurer()
    print("✓ test_extract_insurer")

    test_extract_policy_number()
    print("✓ test_extract_policy_number")

    test_extract_sum_insured()
    print("✓ test_extract_sum_insured")

    test_extract_dates()
    print("✓ test_extract_dates")

    test_detect_cover_type()
    print("✓ test_detect_cover_type")

    test_extract_full_policy()
    print("✓ test_extract_full_policy")

    test_policy_status_determination()
    print("✓ test_policy_status_determination")

    print("\n✅ All tests passed!")
