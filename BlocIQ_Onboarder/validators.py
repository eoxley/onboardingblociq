"""
BlocIQ Onboarder - Validation Rules
UK block management sanity checks and compliance validators
"""

import re
from typing import Dict, List, Optional, Tuple
from datetime import datetime, timedelta
from dataclasses import dataclass
import yaml
from pathlib import Path


@dataclass
class ValidationResult:
    """Result of a validation check"""
    valid: bool
    message: str
    severity: str  # 'error', 'warning', 'info'
    field: Optional[str] = None
    actual_value: Optional[any] = None
    expected_value: Optional[any] = None


class BlockValidator:
    """Validates UK block management data against business rules"""

    def __init__(self, taxonomy_path: str = None):
        if taxonomy_path is None:
            taxonomy_path = Path(__file__).parent / "config" / "block_taxonomy.yml"

        with open(taxonomy_path, 'r') as f:
            self.taxonomy = yaml.safe_load(f)

        self.validation_rules = self.taxonomy.get('validation_rules', {})
        self.renewal_rules = self.taxonomy.get('renewal_rules', {})

    def validate_apportionments(self, apportionments: List[float]) -> List[ValidationResult]:
        """
        Validate that apportionments sum to 100% (within tolerance)

        Args:
            apportionments: List of apportionment percentages

        Returns:
            List of validation results
        """
        results = []

        if not apportionments:
            results.append(ValidationResult(
                valid=False,
                message="No apportionments found",
                severity='error',
                field='apportionments'
            ))
            return results

        total = sum(apportionments)
        rules = self.validation_rules.get('apportionment', {})
        min_sum = rules.get('min_sum', 99.9)
        max_sum = rules.get('max_sum', 100.1)

        if min_sum <= total <= max_sum:
            results.append(ValidationResult(
                valid=True,
                message=f"Apportionments sum to {total:.2f}% (within tolerance)",
                severity='info',
                field='apportionments',
                actual_value=total
            ))
        else:
            results.append(ValidationResult(
                valid=False,
                message=f"Apportionments sum to {total:.2f}% (expected {min_sum}-{max_sum}%)",
                severity='error',
                field='apportionments',
                actual_value=total,
                expected_value=f"{min_sum}-{max_sum}%"
            ))

        return results

    def validate_budget_period(self, year_start: str, year_end: str) -> List[ValidationResult]:
        """
        Validate budget period is approximately 1 year

        Args:
            year_start: Start date (ISO format)
            year_end: End date (ISO format)

        Returns:
            List of validation results
        """
        results = []

        if not year_start or not year_end:
            results.append(ValidationResult(
                valid=False,
                message="Missing budget period dates",
                severity='warning',
                field='budget_period'
            ))
            return results

        try:
            start = datetime.fromisoformat(year_start).date()
            end = datetime.fromisoformat(year_end).date()

            duration_days = (end - start).days
            duration_months = duration_days / 30.44  # Average month length

            rules = self.validation_rules.get('budget_period', {})
            min_months = rules.get('min_duration_months', 11)
            max_months = rules.get('max_duration_months', 13)

            if min_months <= duration_months <= max_months:
                results.append(ValidationResult(
                    valid=True,
                    message=f"Budget period is {duration_months:.1f} months",
                    severity='info',
                    field='budget_period',
                    actual_value=f"{duration_months:.1f} months"
                ))
            else:
                results.append(ValidationResult(
                    valid=False,
                    message=f"Budget period is {duration_months:.1f} months (expected {min_months}-{max_months})",
                    severity='warning',
                    field='budget_period',
                    actual_value=f"{duration_months:.1f} months",
                    expected_value=f"{min_months}-{max_months} months"
                ))

        except (ValueError, AttributeError) as e:
            results.append(ValidationResult(
                valid=False,
                message=f"Invalid date format: {e}",
                severity='error',
                field='budget_period'
            ))

        return results

    def validate_section20_timeline(self, noi_date: str, soe_date: str) -> List[ValidationResult]:
        """
        Validate Section 20 consultation timeline

        Args:
            noi_date: Notice of Intention date (ISO format)
            soe_date: Statement of Estimates date (ISO format)

        Returns:
            List of validation results
        """
        results = []

        if not noi_date or not soe_date:
            return results  # Optional check

        try:
            noi = datetime.fromisoformat(noi_date).date()
            soe = datetime.fromisoformat(soe_date).date()

            gap_days = (soe - noi).days

            rules = self.validation_rules.get('section20', {})
            min_days = rules.get('noi_to_soe_min_days', 30)
            max_days = rules.get('noi_to_soe_max_days', 365)

            if gap_days < 0:
                results.append(ValidationResult(
                    valid=False,
                    message=f"SOE date ({soe_date}) is before NOI date ({noi_date})",
                    severity='error',
                    field='section20_timeline'
                ))
            elif gap_days < min_days:
                results.append(ValidationResult(
                    valid=False,
                    message=f"Section 20 consultation period too short: {gap_days} days (minimum {min_days})",
                    severity='error',
                    field='section20_timeline',
                    actual_value=f"{gap_days} days",
                    expected_value=f"≥{min_days} days"
                ))
            elif gap_days > max_days:
                results.append(ValidationResult(
                    valid=False,
                    message=f"Section 20 consultation period unusually long: {gap_days} days",
                    severity='warning',
                    field='section20_timeline',
                    actual_value=f"{gap_days} days"
                ))
            else:
                results.append(ValidationResult(
                    valid=True,
                    message=f"Section 20 timeline valid: {gap_days} days between NOI and SOE",
                    severity='info',
                    field='section20_timeline',
                    actual_value=f"{gap_days} days"
                ))

        except (ValueError, AttributeError) as e:
            results.append(ValidationResult(
                valid=False,
                message=f"Invalid date format: {e}",
                severity='error',
                field='section20_timeline'
            ))

        return results

    def validate_compliance_due_date(self,
                                      compliance_type: str,
                                      last_inspection_date: str,
                                      next_due_date: str = None) -> List[ValidationResult]:
        """
        Validate compliance inspection due dates based on UK regulations

        Args:
            compliance_type: Type of compliance (e.g., 'compliance_fra', 'compliance_eicr')
            last_inspection_date: Date of last inspection (ISO format)
            next_due_date: Calculated next due date (ISO format, optional)

        Returns:
            List of validation results
        """
        results = []

        if not last_inspection_date:
            return results

        renewal_rule = self.renewal_rules.get(compliance_type)
        if not renewal_rule:
            return results  # No rule defined for this type

        try:
            last_date = datetime.fromisoformat(last_inspection_date).date()

            # Calculate expected next due date
            if 'years' in renewal_rule:
                expected_next = last_date.replace(year=last_date.year + renewal_rule['years'])
            elif 'months' in renewal_rule:
                months = renewal_rule['months']
                expected_next = last_date + timedelta(days=months * 30.44)
            else:
                return results

            # Check if overdue
            today = datetime.now().date()
            days_until_due = (expected_next - today).days

            if next_due_date:
                # Validate provided due date
                provided_next = datetime.fromisoformat(next_due_date).date()
                if abs((provided_next - expected_next).days) > 30:
                    results.append(ValidationResult(
                        valid=False,
                        message=f"Next due date ({next_due_date}) doesn't match renewal rules (expected ~{expected_next})",
                        severity='warning',
                        field='next_due_date',
                        actual_value=next_due_date,
                        expected_value=str(expected_next)
                    ))

            # Check compliance status
            rules = self.validation_rules.get('compliance', {})
            max_overdue_months = rules.get('max_overdue_months', 3)

            if days_until_due < 0:
                months_overdue = abs(days_until_due) / 30.44
                if months_overdue > max_overdue_months:
                    results.append(ValidationResult(
                        valid=False,
                        message=f"{compliance_type} is {months_overdue:.1f} months overdue (last: {last_inspection_date})",
                        severity='error',
                        field='compliance_status',
                        actual_value=f"{months_overdue:.1f} months overdue"
                    ))
                else:
                    results.append(ValidationResult(
                        valid=False,
                        message=f"{compliance_type} is {months_overdue:.1f} months overdue",
                        severity='warning',
                        field='compliance_status'
                    ))
            elif days_until_due < 60:
                results.append(ValidationResult(
                    valid=True,
                    message=f"{compliance_type} due in {days_until_due} days - book soon",
                    severity='warning',
                    field='compliance_status'
                ))
            else:
                results.append(ValidationResult(
                    valid=True,
                    message=f"{compliance_type} compliant (due {expected_next})",
                    severity='info',
                    field='compliance_status'
                ))

        except (ValueError, AttributeError) as e:
            results.append(ValidationResult(
                valid=False,
                message=f"Invalid date format: {e}",
                severity='error',
                field='compliance_dates'
            ))

        return results

    def validate_complete_dataset(self, mapped_data: Dict) -> Dict:
        """
        Run all validation checks on complete mapped dataset

        Returns:
            Dictionary with validation results by category
        """
        validation_report = {
            'valid': True,
            'errors': [],
            'warnings': [],
            'info': [],
            'by_field': {}
        }

        # Validate apportionments
        units = mapped_data.get('units', [])
        if units:
            apportionments = [u.get('apportionment_percent') for u in units if u.get('apportionment_percent')]
            if apportionments:
                results = self.validate_apportionments(apportionments)
                for result in results:
                    self._add_result_to_report(validation_report, result)

        # Validate budgets
        budgets = mapped_data.get('budgets', [])
        for budget in budgets:
            results = self.validate_budget_period(
                budget.get('start_date'),
                budget.get('end_date')
            )
            for result in results:
                self._add_result_to_report(validation_report, result)

        # Validate compliance assets
        compliance_assets = mapped_data.get('compliance_assets', [])
        for asset in compliance_assets:
            results = self.validate_compliance_due_date(
                asset.get('asset_type', ''),
                asset.get('last_inspection_date'),
                asset.get('next_due_date')
            )
            for result in results:
                self._add_result_to_report(validation_report, result)

        # Validate major works
        major_works = mapped_data.get('major_works_projects', [])
        for project in major_works:
            results = self.validate_section20_timeline(
                project.get('notice_of_intention_date'),
                project.get('statement_of_estimates_date')
            )
            for result in results:
                self._add_result_to_report(validation_report, result)

        # Set overall valid flag
        validation_report['valid'] = len(validation_report['errors']) == 0

        return validation_report

    def _add_result_to_report(self, report: Dict, result: ValidationResult):
        """Add validation result to report"""
        result_dict = {
            'message': result.message,
            'field': result.field,
            'actual': result.actual_value,
            'expected': result.expected_value
        }

        if result.severity == 'error':
            report['errors'].append(result_dict)
        elif result.severity == 'warning':
            report['warnings'].append(result_dict)
        else:
            report['info'].append(result_dict)

        if result.field:
            if result.field not in report['by_field']:
                report['by_field'][result.field] = []
            report['by_field'][result.field].append(result_dict)
