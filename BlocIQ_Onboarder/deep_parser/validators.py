"""
Validators - Validate extracted data and calculate trust scores
"""

from typing import List, Any
from datetime import datetime

from .types import (
    LeaseData, InsurancePolicyData, ComplianceAssetData,
    BudgetItemData, ContractorData
)


class Validator:
    """Validate extracted entities"""

    def validate_lease(self, lease: LeaseData) -> List[str]:
        """Validate lease data, return warnings"""
        warnings = []

        # Required fields
        if not lease.unit_ref:
            warnings.append("❌ Missing unit_ref")
        if not lease.lessee_names:
            warnings.append("❌ Missing lessee names")

        # Recommended fields
        if not lease.term_years:
            warnings.append("⚠️  Missing term_years")
        if not lease.start_date:
            warnings.append("⚠️  Missing start_date")
        if not lease.ground_rent_text:
            warnings.append("ℹ️  Missing ground_rent")

        # Sanity checks
        if lease.term_years:
            if lease.term_years > 999:
                warnings.append(f"⚠️  Unusual term: {lease.term_years} years (999 year lease?)")
            elif lease.term_years < 10:
                warnings.append(f"⚠️  Short term: {lease.term_years} years")

        # Date validation
        if lease.start_date and lease.end_date:
            try:
                start = datetime.fromisoformat(lease.start_date).date()
                end = datetime.fromisoformat(lease.end_date).date()

                if end < start:
                    warnings.append(f"❌ end_date ({lease.end_date}) before start_date ({lease.start_date})")

                # Check if term_years matches date range
                if lease.term_years:
                    years_diff = (end - start).days / 365.25
                    if abs(years_diff - lease.term_years) > 1:
                        warnings.append(
                            f"⚠️  term_years ({lease.term_years}) doesn't match "
                            f"date range ({years_diff:.0f} years)"
                        )
            except:
                warnings.append("❌ Invalid date format")

        return warnings

    def validate_insurance(self, policy: InsurancePolicyData) -> List[str]:
        """Validate insurance policy data"""
        warnings = []

        # Required fields
        if not policy.policy_number and not policy.period_start:
            warnings.append("❌ Missing both policy_number and period dates")

        # Recommended fields
        if not policy.provider:
            warnings.append("⚠️  Missing provider")
        if not policy.period_start or not policy.period_end:
            warnings.append("⚠️  Missing policy period dates")
        if not policy.sum_insured:
            warnings.append("ℹ️  Missing sum_insured")

        # Date validation
        if policy.period_start and policy.period_end:
            try:
                start = datetime.fromisoformat(policy.period_start).date()
                end = datetime.fromisoformat(policy.period_end).date()

                if end < start:
                    warnings.append(f"❌ period_end before period_start")

                # Check if period is typical (usually 1 year)
                days = (end - start).days
                if days < 300 or days > 400:
                    warnings.append(f"ℹ️  Unusual period length: {days} days")
            except:
                warnings.append("❌ Invalid date format")

        # Amount validation
        if policy.sum_insured and policy.sum_insured < 10000:
            warnings.append(f"⚠️  Low sum_insured: £{policy.sum_insured:,.0f}")

        return warnings

    def validate_compliance(self, asset: ComplianceAssetData) -> List[str]:
        """Validate compliance asset data"""
        warnings = []

        # Required fields
        if not asset.name:
            warnings.append("❌ Missing asset name")

        # Recommended fields
        if not asset.category:
            warnings.append("⚠️  Missing category")
        if not asset.last_inspection and not asset.next_due:
            warnings.append("⚠️  Missing both last_inspection and next_due dates")

        # Status validation
        if asset.status == "OK" and (not asset.last_inspection or not asset.next_due):
            warnings.append("❌ Status is OK but missing dates")
        elif asset.status == "Overdue" and not asset.next_due:
            warnings.append("❌ Status is Overdue but missing next_due date")

        # Date validation
        if asset.last_inspection and asset.next_due:
            try:
                last = datetime.fromisoformat(asset.last_inspection).date()
                next_due = datetime.fromisoformat(asset.next_due).date()

                if next_due < last:
                    warnings.append(f"❌ next_due before last_inspection")
            except:
                warnings.append("❌ Invalid date format")

        return warnings

    def validate_budget(self, budget: BudgetItemData) -> List[str]:
        """Validate budget item data"""
        warnings = []

        # Required fields
        if not budget.service_charge_year:
            warnings.append("❌ Missing service_charge_year")
        if not budget.heading:
            warnings.append("❌ Missing heading")

        # Recommended fields
        if budget.amount is None:
            warnings.append("⚠️  Missing amount")

        # Sanity checks
        if budget.amount is not None:
            if budget.amount < 0:
                warnings.append(f"ℹ️  Negative amount: £{budget.amount:,.2f} (rebate/refund?)")
            elif budget.amount == 0:
                warnings.append(f"ℹ️  Zero amount")
            elif budget.amount > 1000000:
                warnings.append(f"⚠️  Large amount: £{budget.amount:,.2f}")

        return warnings

    def validate_contractor(self, contractor: ContractorData) -> List[str]:
        """Validate contractor data"""
        warnings = []

        # Required fields
        if not contractor.name:
            warnings.append("❌ Missing contractor name")

        # Recommended fields
        if not contractor.service_type:
            warnings.append("⚠️  Missing service_type")

        # Date validation
        if contractor.start_date and contractor.end_date:
            try:
                start = datetime.fromisoformat(contractor.start_date).date()
                end = datetime.fromisoformat(contractor.end_date).date()

                if end < start:
                    warnings.append(f"❌ end_date before start_date")
            except:
                warnings.append("❌ Invalid date format")

        return warnings

    def calculate_trust_score(self, entity: Any) -> float:
        """
        Calculate trust score 0-1 based on field completeness
        If entity has .confidence, use that; otherwise calculate generic score
        """
        if hasattr(entity, 'confidence') and entity.confidence is not None:
            return entity.confidence

        # Generic scoring based on field population
        total_fields = 0
        populated_fields = 0

        for key, value in entity.__dict__.items():
            if key.startswith('_') or key in ['source_file', 'confidence']:
                continue

            total_fields += 1

            if value not in [None, '', [], 0.0]:
                populated_fields += 1

        return populated_fields / total_fields if total_fields > 0 else 0.0

    def calculate_bundle_trust_score(self, bundle: Any) -> Dict[str, float]:
        """Calculate average trust scores for each entity type in bundle"""
        scores = {}

        if hasattr(bundle, 'leases') and bundle.leases:
            scores['leases'] = sum(l.confidence for l in bundle.leases) / len(bundle.leases)

        if hasattr(bundle, 'insurance_policies') and bundle.insurance_policies:
            scores['insurance'] = sum(i.confidence for i in bundle.insurance_policies) / len(bundle.insurance_policies)

        if hasattr(bundle, 'compliance_assets') and bundle.compliance_assets:
            scores['compliance'] = sum(c.confidence for c in bundle.compliance_assets) / len(bundle.compliance_assets)

        if hasattr(bundle, 'budgets') and bundle.budgets:
            scores['budgets'] = sum(b.confidence for b in bundle.budgets) / len(bundle.budgets)

        if hasattr(bundle, 'contractors') and bundle.contractors:
            scores['contractors'] = sum(c.confidence for c in bundle.contractors) / len(bundle.contractors)

        # Overall average
        if scores:
            scores['overall'] = sum(scores.values()) / len(scores)
        else:
            scores['overall'] = 0.0

        return scores
