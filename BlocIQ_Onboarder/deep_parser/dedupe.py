"""
Dedupe & Cross-Check Engine
Normalizes unit refs, merges duplicates, validates data quality
"""

import re
import hashlib
from datetime import datetime, timedelta
from typing import List, Dict, Set
from collections import defaultdict

from .types import ParsedBundle, LeaseData, UnitData


class DedupeEngine:
    """Deduplication and cross-checking logic"""

    def normalize_unit_ref(self, unit: str) -> str:
        """
        Normalize unit references
        'Flat 1', '1', '001', 'Unit 1' => '1'
        'Flat 2A', '2A', '002A' => '2A'
        """
        # Remove common prefixes
        unit = re.sub(r'(?:Flat|Apartment|Unit)\s*', '', unit, flags=re.IGNORECASE)

        # Remove leading zeros (but keep if followed by letter)
        unit = re.sub(r'^0+(\d)', r'\1', unit)

        # Uppercase letters
        unit = unit.strip().upper()

        return unit

    def dedupe_units(self, units: List[UnitData]) -> List[UnitData]:
        """Deduplicate units by normalized ref"""
        seen = {}

        for unit in units:
            norm_ref = self.normalize_unit_ref(unit.unit_ref)

            if norm_ref not in seen:
                # Keep first occurrence with normalized ref
                unit.unit_ref = norm_ref
                seen[norm_ref] = unit
            else:
                # Merge - keep higher confidence
                if unit.confidence > seen[norm_ref].confidence:
                    unit.unit_ref = norm_ref
                    seen[norm_ref] = unit

        return list(seen.values())

    def dedupe_leases(self, leases: List[LeaseData]) -> List[LeaseData]:
        """
        Merge leases with same (unit_ref, start_date ±7 days, lessee hash)
        """
        unique = {}

        for lease in leases:
            # Normalize unit
            norm_unit = self.normalize_unit_ref(lease.unit_ref)
            lease.unit_ref = norm_unit  # Update in place

            # Create lessee hash
            lessee_hash = self._hash_lessees(lease.lessee_names)

            # Parse start date
            start = None
            if lease.start_date:
                try:
                    start = datetime.fromisoformat(lease.start_date).date()
                except:
                    pass

            # Check for similar existing lease
            key = f"{norm_unit}_{lessee_hash}"
            merged = False

            for existing_key, existing in list(unique.items()):
                if not existing_key.startswith(f"{norm_unit}_"):
                    continue

                # Check if dates are within 7 days
                existing_start = None
                if existing.start_date:
                    try:
                        existing_start = datetime.fromisoformat(existing.start_date).date()
                    except:
                        pass

                if existing_start and start:
                    days_diff = abs((existing_start - start).days)
                    if days_diff <= 7:
                        # Merge - keep higher confidence
                        if lease.confidence > existing.confidence:
                            unique[existing_key] = lease
                        merged = True
                        break

            if not merged:
                # Add as new with unique key
                unique[f"{key}_{len(unique)}"] = lease

        return list(unique.values())

    def _hash_lessees(self, lessees: List[str]) -> str:
        """Create hash of lessee names"""
        if not lessees:
            return "no_lessee"

        # Sort and join
        lessee_str = '|'.join(sorted(lessees))

        # Create hash
        return hashlib.md5(lessee_str.encode()).hexdigest()[:8]

    def cross_check_counts(self, bundle: ParsedBundle) -> List[str]:
        """Generate warnings for data quality issues"""
        warnings = []

        # Units vs leases coverage
        if bundle.units:
            unique_lease_units = set(l.unit_ref for l in bundle.leases)
            unit_refs = set(u.unit_ref for u in bundle.units)

            coverage = len(unique_lease_units) / len(unit_refs) * 100 if unit_refs else 0

            warnings.append(f"📊 Lease coverage: {len(unique_lease_units)}/{len(unit_refs)} units ({coverage:.0f}%)")

            if coverage < 100:
                missing = len(unit_refs) - len(unique_lease_units)
                missing_units = unit_refs - unique_lease_units
                warnings.append(f"⚠️  {missing} units missing lease records: {', '.join(sorted(missing_units))}")

        # Compliance status breakdown
        compliant = sum(1 for c in bundle.compliance_assets if c.status == "OK")
        overdue = sum(1 for c in bundle.compliance_assets if c.status == "Overdue")
        unknown = sum(1 for c in bundle.compliance_assets if c.status == "Unknown")

        if bundle.compliance_assets:
            warnings.append(
                f"📊 Compliance: {compliant} OK, {overdue} Overdue, {unknown} Unknown "
                f"(Total: {len(bundle.compliance_assets)})"
            )

            if overdue > 0:
                warnings.append(f"❌ {overdue} compliance assets are OVERDUE")

            # Never auto-mark Unknown as Overdue
            if unknown > (len(bundle.compliance_assets) * 0.5):
                warnings.append(
                    f"ℹ️  {unknown} assets have Unknown status (missing inspection dates) - "
                    f"NOT marked as Overdue"
                )

        # Insurance status breakdown
        if bundle.insurance_policies:
            active = sum(1 for i in bundle.insurance_policies if i.status == "Active")
            expired = sum(1 for i in bundle.insurance_policies if i.status == "Expired")
            unknown_ins = sum(1 for i in bundle.insurance_policies if i.status == "Unknown")

            warnings.append(
                f"📊 Insurance: {active} Active, {expired} Expired, {unknown_ins} Unknown "
                f"(Total: {len(bundle.insurance_policies)})"
            )

            if unknown_ins > (len(bundle.insurance_policies) * 0.5):
                warnings.append(
                    f"⚠️  {unknown_ins} policies missing period dates (cannot determine Active/Expired)"
                )

        # Budget completeness
        if bundle.budgets:
            with_amounts = sum(1 for b in bundle.budgets if b.amount is not None)
            without_amounts = len(bundle.budgets) - with_amounts

            warnings.append(
                f"📊 Budgets: {len(bundle.budgets)} items, "
                f"{with_amounts} with amounts, {without_amounts} without"
            )

            if without_amounts > 0:
                warnings.append(f"⚠️  {without_amounts} budget items missing amounts")

        # Contractor status
        if bundle.contractors:
            active_contractors = sum(1 for c in bundle.contractors if c.status == "Active")
            warnings.append(f"📊 Contractors: {len(bundle.contractors)} total, {active_contractors} active")

        return warnings

    def validate_data_integrity(self, bundle: ParsedBundle) -> List[str]:
        """Validate data integrity and return errors"""
        errors = []

        # Check for orphaned leases (unit_ref doesn't match any unit)
        if bundle.units and bundle.leases:
            unit_refs = set(u.unit_ref for u in bundle.units)
            for lease in bundle.leases:
                if lease.unit_ref not in unit_refs:
                    errors.append(
                        f"Orphaned lease: unit '{lease.unit_ref}' not found in units list"
                    )

        # Check for leases with no lessees
        for lease in bundle.leases:
            if not lease.lessee_names:
                errors.append(f"Lease for unit '{lease.unit_ref}' has no lessee names")

        # Check for compliance assets with conflicting dates
        for asset in bundle.compliance_assets:
            if asset.last_inspection and asset.next_due:
                try:
                    last = datetime.fromisoformat(asset.last_inspection).date()
                    next_due = datetime.fromisoformat(asset.next_due).date()

                    if next_due < last:
                        errors.append(
                            f"Compliance '{asset.name}': next_due ({asset.next_due}) "
                            f"is before last_inspection ({asset.last_inspection})"
                        )
                except:
                    pass

        # Check for insurance with conflicting dates
        for policy in bundle.insurance_policies:
            if policy.period_start and policy.period_end:
                try:
                    start = datetime.fromisoformat(policy.period_start).date()
                    end = datetime.fromisoformat(policy.period_end).date()

                    if end < start:
                        errors.append(
                            f"Insurance policy: period_end ({policy.period_end}) "
                            f"is before period_start ({policy.period_start})"
                        )
                except:
                    pass

        return errors
