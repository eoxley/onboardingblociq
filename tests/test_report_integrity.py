"""
Test Report Data Integrity Validation
======================================
Ensures PDF reports contain only per-building data with zero contamination
"""

import unittest
import json
import sys
import os

# Add parent directory to path
sys.path.insert(0, os.path.join(os.path.dirname(__file__), '..', 'BlocIQ_Onboarder'))

from report_data_validator import ReportDataValidator, ReportDataIntegrityError


class TestReportDataIntegrity(unittest.TestCase):
    """Test report data integrity validation"""
    
    def setUp(self):
        """Setup test data"""
        self.building_id = 'test-building-123'
        self.sql_data = {
            'building': {
                'id': 'test-building-123',
                'name': 'Test Building',
                'building_name': 'Test Building',
                'number_of_units': 10,
            },
            'units': [
                {'id': f'unit-{i}', 'building_id': 'test-building-123', 'unit_number': f'A{i}'}
                for i in range(1, 11)
            ],
            'leaseholders': [
                {'id': f'lh-{i}', 'building_id': 'test-building-123', 'name': f'Leaseholder {i}'}
                for i in range(1, 11)
            ],
            'budgets': [
                {'id': 'budget-1', 'building_id': 'test-building-123', 'total_amount': 10000}
            ],
            'compliance_assets': [
                {'id': f'asset-{i}', 'building_id': 'test-building-123', 'compliance_status': 'current'}
                for i in range(1, 6)
            ],
            'insurance_policies': [
                {'id': 'ins-1', 'building_id': 'test-building-123', 'annual_premium': 5000}
            ]
        }
    
    def test_valid_data_passes(self):
        """Test that matching data passes validation"""
        validator = ReportDataValidator(self.building_id, self.sql_data)
        report_data = self.sql_data.copy()
        
        # Should not raise
        result = validator.validate_report_data(report_data)
        self.assertTrue(result)
        self.assertEqual(len(validator.validation_errors), 0)
    
    def test_wrong_building_id_fails(self):
        """Test that wrong building ID is detected"""
        wrong_data = self.sql_data.copy()
        wrong_data['building']['id'] = 'different-building-456'
        
        validator = ReportDataValidator(self.building_id, wrong_data)
        
        with self.assertRaises(ReportDataIntegrityError) as ctx:
            validator.validate_report_data(wrong_data)
        
        self.assertIn('Building ID mismatch', str(ctx.exception))
    
    def test_cross_building_contamination_detected(self):
        """CRITICAL: Test that data from another building is detected"""
        contaminated_data = self.sql_data.copy()
        
        # Add a unit from a different building (data leak!)
        contaminated_data['units'].append({
            'id': 'leaked-unit',
            'building_id': 'other-building-789',  # WRONG!
            'unit_number': 'B1'
        })
        
        validator = ReportDataValidator(self.building_id, contaminated_data)
        
        with self.assertRaises(ReportDataIntegrityError) as ctx:
            validator.validate_report_data(contaminated_data)
        
        error_msg = str(ctx.exception)
        self.assertIn('CONTAMINATION DETECTED', error_msg)
        self.assertIn('other-building-789', error_msg)
    
    def test_count_mismatch_fails(self):
        """Test that entity count mismatches are detected"""
        validator = ReportDataValidator(self.building_id, self.sql_data)
        
        report_data = self.sql_data.copy()
        # Remove one unit from report
        report_data['units'] = report_data['units'][:-1]
        
        with self.assertRaises(ReportDataIntegrityError) as ctx:
            validator.validate_report_data(report_data)
        
        self.assertIn('Units count mismatch', str(ctx.exception))
    
    def test_financial_total_mismatch_fails(self):
        """Test that financial total mismatches are detected"""
        validator = ReportDataValidator(self.building_id, self.sql_data)
        
        import copy
        report_data = copy.deepcopy(self.sql_data)
        # Change budget amount
        report_data['budgets'][0]['total_amount'] = 20000  # Was 10000
        
        with self.assertRaises(ReportDataIntegrityError) as ctx:
            validator.validate_report_data(report_data)
        
        self.assertIn('Budget total mismatch', str(ctx.exception))
    
    def test_validation_report_generated(self):
        """Test that validation report is generated"""
        validator = ReportDataValidator(self.building_id, self.sql_data)
        validator.validate_report_data(self.sql_data)
        
        report = validator.generate_validation_report()
        
        self.assertIn('building_id', report)
        self.assertIn('validation_passed', report)
        self.assertTrue(report['validation_passed'])
        self.assertIn('entities_validated', report)
        self.assertEqual(report['entities_validated']['units'], 10)
        self.assertEqual(report['entities_validated']['leaseholders'], 10)


class TestPimlicoPlaceIntegrity(unittest.TestCase):
    """Real-world test: Pimlico Place PDF should match its SQL"""
    
    def test_pimlico_mapped_data_exists(self):
        """Test that Pimlico mapped_data.json exists"""
        pimlico_data_path = os.path.join(
            os.path.dirname(__file__), 
            '..', 
            'BlocIQ_Onboarder', 
            'output', 
            'mapped_data.json'
        )
        
        if os.path.exists(pimlico_data_path):
            with open(pimlico_data_path, 'r') as f:
                data = json.load(f)
            
            building = data.get('building', {})
            building_id = building.get('id')
            building_name = building.get('name') or building.get('building_name')
            
            print(f"\n📊 Testing real data: {building_name} ({building_id})")
            print(f"   Units: {len(data.get('units', []))}")
            print(f"   Leaseholders: {len(data.get('leaseholders', []))}")
            print(f"   Budgets: {len(data.get('budgets', []))}")
            
            # Validate building isolation
            validator = ReportDataValidator(building_id, data)
            
            try:
                validator.validate_building_isolation()
                print(f"   ✅ No cross-building contamination detected")
            except ReportDataIntegrityError as e:
                self.fail(f"Building isolation failed: {e}")
        else:
            self.skipTest("Pimlico mapped_data.json not found")


if __name__ == '__main__':
    unittest.main()

