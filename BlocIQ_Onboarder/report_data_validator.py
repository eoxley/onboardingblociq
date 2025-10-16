"""
BlocIQ Report Data Integrity Validator
=======================================
Ensures PDF reports contain ONLY the building's SQL data with zero contamination

CRITICAL: This validator BLOCKS report generation if any data mismatch is detected
"""

from typing import Dict, List, Any, Optional
from datetime import datetime
import json


class ReportDataIntegrityError(Exception):
    """Raised when report data doesn't match SQL snapshot"""
    pass


class ReportDataValidator:
    """Validates that PDF report data exactly matches SQL data for a specific building"""
    
    def __init__(self, building_id: str, sql_data: Dict[str, Any]):
        """
        Initialize validator with SQL snapshot
        
        Args:
            building_id: UUID of the building
            sql_data: Complete mapped_data.json or SQL snapshot for THIS building only
        """
        self.building_id = building_id
        self.sql_data = sql_data
        self.validation_errors = []
        self.validation_warnings = []
        
    def validate_building_isolation(self) -> bool:
        """
        CRITICAL: Ensure no data from other buildings leaked into this report
        
        Returns:
            True if data is isolated, raises ReportDataIntegrityError otherwise
        """
        building = self.sql_data.get('building', {})
        
        # Check building ID matches
        if building.get('id') != self.building_id:
            raise ReportDataIntegrityError(
                f"CRITICAL: Building ID mismatch! "
                f"Expected {self.building_id}, got {building.get('id')}"
            )
        
        # Check all linked records reference THIS building_id only
        for entity_type in ['units', 'leaseholders', 'budgets', 'compliance_assets', 
                           'insurance_policies', 'maintenance_contracts', 'leases']:
            records = self.sql_data.get(entity_type, [])
            for idx, record in enumerate(records):
                record_building_id = record.get('building_id')
                if record_building_id and record_building_id != self.building_id:
                    raise ReportDataIntegrityError(
                        f"CONTAMINATION DETECTED: {entity_type}[{idx}] has "
                        f"building_id={record_building_id}, expected {self.building_id}. "
                        f"Data from another building has leaked into this report!"
                    )
        
        return True
    
    def validate_report_data(self, report_data: Dict[str, Any]) -> bool:
        """
        Validate that report data matches SQL data exactly
        
        Args:
            report_data: Data prepared for PDF rendering
            
        Returns:
            True if valid, raises ReportDataIntegrityError if mismatched
        """
        self.validation_errors = []
        self.validation_warnings = []
        
        # 1. Validate building isolation FIRST
        self.validate_building_isolation()
        
        # 2. Validate building summary
        self._validate_building_summary(report_data)
        
        # 3. Validate counts
        self._validate_entity_counts(report_data)
        
        # 4. Validate financial totals
        self._validate_financial_totals(report_data)
        
        # 5. Validate specific entities
        self._validate_leaseholders(report_data)
        self._validate_compliance(report_data)
        self._validate_insurance(report_data)
        
        # Raise errors if found
        if self.validation_errors:
            error_msg = "\n".join([
                "REPORT DATA INTEGRITY FAILED:",
                "=" * 70,
                *self.validation_errors,
                "=" * 70,
                "PDF generation BLOCKED to prevent inaccurate client deliverables."
            ])
            raise ReportDataIntegrityError(error_msg)
        
        # Log warnings but don't block
        if self.validation_warnings:
            print("\n⚠️  VALIDATION WARNINGS:")
            for warning in self.validation_warnings:
                print(f"   {warning}")
        
        return True
    
    def _validate_building_summary(self, report_data: Dict):
        """Validate building core fields match SQL"""
        sql_building = self.sql_data.get('building', {})
        report_building = report_data.get('building', {})
        
        critical_fields = ['id', 'name', 'building_name']
        for field in critical_fields:
            sql_val = sql_building.get(field)
            report_val = report_building.get(field)
            
            if sql_val and sql_val != report_val:
                self.validation_errors.append(
                    f"Building.{field}: SQL='{sql_val}' ≠ Report='{report_val}'"
                )
        
        # Check numeric fields
        numeric_fields = ['number_of_units', 'num_units', 'num_blocks']
        for field in numeric_fields:
            sql_val = sql_building.get(field)
            report_val = report_building.get(field)
            
            if sql_val is not None and sql_val != report_val:
                self.validation_warnings.append(
                    f"Building.{field}: SQL={sql_val} ≠ Report={report_val}"
                )
    
    def _validate_entity_counts(self, report_data: Dict):
        """Validate entity counts match between SQL and report"""
        entities = [
            ('units', 'Units'),
            ('leaseholders', 'Leaseholders'),
            ('budgets', 'Budgets'),
            ('compliance_assets', 'Compliance Assets'),
            ('insurance_policies', 'Insurance Policies'),
            ('leases', 'Leases'),
            ('maintenance_contracts', 'Contracts'),
        ]
        
        for entity_key, entity_name in entities:
            sql_count = len(self.sql_data.get(entity_key, []))
            report_count = len(report_data.get(entity_key, []))
            
            if sql_count != report_count:
                self.validation_errors.append(
                    f"{entity_name} count mismatch: SQL={sql_count}, Report={report_count}"
                )
    
    def _validate_financial_totals(self, report_data: Dict):
        """Validate financial totals match"""
        sql_budgets = self.sql_data.get('budgets', [])
        report_budgets = report_data.get('budgets', [])
        
        # Calculate SQL total
        sql_total = sum(
            float(b.get('total_amount') or 0) 
            for b in sql_budgets
        )
        
        # Calculate report total
        report_total = sum(
            float(b.get('total_amount') or 0) 
            for b in report_budgets
        )
        
        # Check total amount match (count is already checked in _validate_entity_counts)
        if abs(sql_total - report_total) > 0.01:  # Allow 1p rounding difference
            self.validation_errors.append(
                f"Budget total mismatch: SQL=£{sql_total:,.2f}, Report=£{report_total:,.2f}"
            )
    
    def _validate_leaseholders(self, report_data: Dict):
        """Validate leaseholder data"""
        sql_leaseholders = {lh.get('id'): lh for lh in self.sql_data.get('leaseholders', [])}
        report_leaseholders = {lh.get('id'): lh for lh in report_data.get('leaseholders', [])}
        
        # Check IDs match
        sql_ids = set(sql_leaseholders.keys())
        report_ids = set(report_leaseholders.keys())
        
        missing_in_report = sql_ids - report_ids
        extra_in_report = report_ids - sql_ids
        
        if missing_in_report:
            self.validation_errors.append(
                f"Leaseholders missing in report: {len(missing_in_report)} IDs"
            )
        
        if extra_in_report:
            self.validation_errors.append(
                f"Extra leaseholders in report (contamination?): {len(extra_in_report)} IDs"
            )
    
    def _validate_compliance(self, report_data: Dict):
        """Validate compliance asset data"""
        sql_assets = self.sql_data.get('compliance_assets', [])
        report_assets = report_data.get('compliance_assets', [])
        
        # Count by status
        sql_statuses = {}
        report_statuses = {}
        
        for asset in sql_assets:
            status = asset.get('compliance_status', 'unknown')
            sql_statuses[status] = sql_statuses.get(status, 0) + 1
        
        for asset in report_assets:
            status = asset.get('compliance_status', 'unknown')
            report_statuses[status] = report_statuses.get(status, 0) + 1
        
        # Compare
        all_statuses = set(sql_statuses.keys()) | set(report_statuses.keys())
        for status in all_statuses:
            sql_count = sql_statuses.get(status, 0)
            report_count = report_statuses.get(status, 0)
            
            if sql_count != report_count:
                self.validation_warnings.append(
                    f"Compliance status '{status}': SQL={sql_count}, Report={report_count}"
                )
    
    def _validate_insurance(self, report_data: Dict):
        """Validate insurance data"""
        sql_policies = self.sql_data.get('insurance_policies', [])
        report_policies = report_data.get('insurance_policies', [])
        
        # Validate total premium if available
        sql_total = sum(
            float(p.get('annual_premium') or p.get('premium') or 0) 
            for p in sql_policies
        )
        report_total = sum(
            float(p.get('annual_premium') or p.get('premium') or 0) 
            for p in report_policies
        )
        
        if abs(sql_total - report_total) > 0.01:
            self.validation_warnings.append(
                f"Insurance premium total: SQL=£{sql_total:,.2f}, Report=£{report_total:,.2f}"
            )
    
    def generate_validation_report(self) -> Dict:
        """Generate validation report for logging"""
        return {
            'timestamp': datetime.now().isoformat(),
            'building_id': self.building_id,
            'validation_passed': len(self.validation_errors) == 0,
            'errors': self.validation_errors,
            'warnings': self.validation_warnings,
            'entities_validated': {
                'units': len(self.sql_data.get('units', [])),
                'leaseholders': len(self.sql_data.get('leaseholders', [])),
                'budgets': len(self.sql_data.get('budgets', [])),
                'compliance_assets': len(self.sql_data.get('compliance_assets', [])),
                'insurance_policies': len(self.sql_data.get('insurance_policies', [])),
            }
        }


def validate_before_pdf_generation(
    building_id: str, 
    sql_data_file: str, 
    report_data: Dict
) -> bool:
    """
    Main validation entry point - call this BEFORE generating PDF
    
    Args:
        building_id: Building UUID
        sql_data_file: Path to mapped_data.json or SQL snapshot
        report_data: Data prepared for PDF rendering
        
    Returns:
        True if valid
        
    Raises:
        ReportDataIntegrityError if validation fails
    """
    # Load SQL data
    with open(sql_data_file, 'r') as f:
        sql_data = json.load(f)
    
    # Validate
    validator = ReportDataValidator(building_id, sql_data)
    validator.validate_report_data(report_data)
    
    # Log validation report
    report = validator.generate_validation_report()
    print(f"\n✅ Data integrity validation PASSED for building {building_id}")
    print(f"   Entities validated: {report['entities_validated']}")
    
    return True

