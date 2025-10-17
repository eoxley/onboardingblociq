"""
Data Quality Validator
======================
Validates extracted data for completeness and accuracy
Reports issues and warnings before SQL generation
"""

from typing import Dict, List, Tuple


class DataQualityValidator:
    """
    Validate data quality and report issues
    
    Checks:
    - Apportionment totals (should be ~100%)
    - Budget completeness
    - Compliance coverage
    - Missing critical data
    - Data consistency
    """
    
    def __init__(self):
        self.issues = []
        self.warnings = []
        self.stats = {}
    
    def validate(self, extracted_data: Dict) -> Tuple[List[str], List[str]]:
        """
        Validate all extracted data
        
        Returns:
            (issues, warnings)
            issues = critical problems
            warnings = non-critical but noteworthy
        """
        self.issues = []
        self.warnings = []
        
        self._validate_building(extracted_data.get('building', {}))
        self._validate_units(extracted_data.get('units', []))
        self._validate_budget(extracted_data.get('budgets', []))
        self._validate_compliance(extracted_data.get('compliance_assets', []))
        self._validate_contractors(extracted_data.get('contractors', []))
        
        return self.issues, self.warnings
    
    def _validate_building(self, building: Dict):
        """Validate building data"""
        if not building.get('name'):
            self.issues.append("Building name missing")
        
        if not building.get('number_of_floors'):
            self.warnings.append("Number of floors not extracted")
        
        if not building.get('sc_year_start') or not building.get('sc_year_end'):
            self.warnings.append("Service charge year not extracted")
    
    def _validate_units(self, units: List[Dict]):
        """Validate units and apportionments"""
        if not units:
            self.warnings.append("No units extracted")
            return
        
        # Check apportionment total
        apport_values = [u.get('apportionment') for u in units if u.get('apportionment') is not None]
        
        if apport_values:
            total = sum(apport_values)
            
            # Should be close to 100% (allow 98-102% for rounding)
            if total < 98 or total > 102:
                self.warnings.append(f"Apportionment total = {total:.2f}% (should be ~100%)")
        
        # Check leaseholder coverage
        with_names = len([u for u in units if u.get('leaseholder_name')])
        coverage = (with_names / len(units)) * 100 if units else 0
        
        if coverage < 50:
            self.warnings.append(f"Only {with_names}/{len(units)} units have leaseholder names ({coverage:.0f}%)")
        elif coverage < 90:
            self.warnings.append(f"Leaseholder coverage: {with_names}/{len(units)} ({coverage:.0f}%)")
    
    def _validate_budget(self, budgets: List[Dict]):
        """Validate budget data"""
        if not budgets:
            self.warnings.append("No budget extracted")
            return
        
        budget = budgets[0]
        
        if not budget.get('budget_year'):
            self.warnings.append("Budget year not determined")
        
        if not budget.get('line_items'):
            self.warnings.append("No budget line items extracted")
        
        if budget.get('total_budget', 0) == 0:
            self.warnings.append("Budget total is £0")
    
    def _validate_compliance(self, compliance: List[Dict]):
        """Validate compliance assets"""
        if not compliance:
            self.warnings.append("No compliance assets extracted")
            return
        
        # Check date extraction rate
        with_dates = len([c for c in compliance if c.get('assessment_date')])
        date_rate = (with_dates / len(compliance)) * 100 if compliance else 0
        
        if date_rate < 50:
            self.warnings.append(f"Only {with_dates}/{len(compliance)} compliance assets have dates ({date_rate:.0f}%)")
        
        # Check for expired compliance
        expired = [c for c in compliance if not c.get('is_current')]
        if expired:
            for asset in expired:
                self.warnings.append(f"EXPIRED: {asset['asset_type']} (needs renewal)")
    
    def _validate_contractors(self, contractors: List[Dict]):
        """Validate contractor data"""
        if not contractors:
            self.warnings.append("No contractors extracted")
            return
        
        # Check for contractors with no annual value
        no_value = len([c for c in contractors if not c.get('annual_value') or c['annual_value'] == 0])
        
        if no_value > len(contractors) / 2:
            self.warnings.append(f"{no_value}/{len(contractors)} contractors have no annual value")
    
    def print_report(self):
        """Print validation report"""
        print("\n" + "="*70)
        print("📋 DATA QUALITY VALIDATION REPORT")
        print("="*70)
        
        if not self.issues and not self.warnings:
            print("✅ No issues or warnings - data quality excellent!")
            return
        
        if self.issues:
            print(f"\n🔴 CRITICAL ISSUES ({len(self.issues)}):")
            for issue in self.issues:
                print(f"   • {issue}")
        
        if self.warnings:
            print(f"\n⚠️  WARNINGS ({len(self.warnings)}):")
            for warning in self.warnings:
                print(f"   • {warning}")
        
        print("="*70)

