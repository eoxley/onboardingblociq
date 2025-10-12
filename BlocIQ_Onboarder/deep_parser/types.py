"""
Deep Parser Type Definitions
Universal parse contract for building handover data
"""

from typing import List, Dict, Optional, Any, Literal
from dataclasses import dataclass, field
from datetime import date


@dataclass
class BuildingMetadata:
    """Building metadata"""
    name: Optional[str] = None
    address_line1: Optional[str] = None
    address_line2: Optional[str] = None
    city: Optional[str] = None
    postcode: Optional[str] = None
    full_address: Optional[str] = None


@dataclass
class UnitData:
    """Unit data"""
    unit_ref: str
    level: Optional[str] = None
    source_file: str = ""
    confidence: float = 0.0


@dataclass
class LeaseData:
    """Lease data with full extraction"""
    unit_ref: str
    lessee_names: List[str]
    term_years: Optional[int] = None
    start_date: Optional[str] = None  # ISO date
    end_date: Optional[str] = None    # ISO date
    ground_rent_text: Optional[str] = None
    apportionment_pct: Optional[float] = None
    source_file: str = ""
    confidence: float = 0.0

    # Additional fields
    lease_type: Optional[str] = None
    service_charge_apportionment: Optional[str] = None

    # Lease clauses (for traceability)
    clauses: List[Dict[str, Any]] = field(default_factory=list)  # List of extracted lease clauses

    # Missing fields for health check
    lessor_name: Optional[str] = None
    rent_review_period: Optional[int] = None  # Years between rent reviews


@dataclass
class InsurancePolicyData:
    """Insurance policy data"""
    provider: Optional[str] = None
    policy_number: Optional[str] = None
    policy_type: Optional[str] = None  # buildings, terrorism, engineering breakdown
    period_start: Optional[str] = None  # ISO
    period_end: Optional[str] = None    # ISO
    sum_insured: Optional[float] = None
    premium: Optional[float] = None
    source_file: str = ""
    confidence: float = 0.0
    status: Optional[Literal["Active", "Expired", "Unknown"]] = None


@dataclass
class ComplianceAssetData:
    """Compliance asset data"""
    category: Optional[str] = None  # Fire Safety / Electrical / Water / General
    name: str = ""
    last_inspection: Optional[str] = None  # ISO
    next_due: Optional[str] = None         # ISO
    status: Optional[Literal["OK", "Overdue", "Unknown"]] = "Unknown"
    source_file: str = ""
    confidence: float = 0.0

    # Additional fields
    location: Optional[str] = None
    responsible_party: Optional[str] = None
    inspection_frequency: Optional[str] = None


@dataclass
class BudgetItemData:
    """Budget item data"""
    service_charge_year: str  # "2025/26" or "2025"
    heading: str              # cost heading
    schedule: Optional[str] = None  # "Sch1"..."Sch8"
    amount: Optional[float] = None  # decimal, None if not found
    currency: str = "GBP"
    source_file: str = ""
    confidence: float = 0.0


@dataclass
class ContractorData:
    """Contractor data"""
    name: str
    service_type: Optional[str] = None
    start_date: Optional[str] = None
    end_date: Optional[str] = None
    status: Optional[Literal["Active", "Expired", "Planned"]] = None
    source_file: str = ""
    confidence: float = 0.0

    # Additional fields
    contact_person: Optional[str] = None
    phone: Optional[str] = None
    email: Optional[str] = None


@dataclass
class ParsedBundle:
    """Complete parsed building data bundle"""
    building: BuildingMetadata = field(default_factory=BuildingMetadata)
    units: List[UnitData] = field(default_factory=list)
    leases: List[LeaseData] = field(default_factory=list)
    insurance_policies: List[InsurancePolicyData] = field(default_factory=list)
    compliance_assets: List[ComplianceAssetData] = field(default_factory=list)
    budgets: List[BudgetItemData] = field(default_factory=list)
    contractors: List[ContractorData] = field(default_factory=list)
    logs: List[str] = field(default_factory=list)

    def add_log(self, message: str):
        """Add log message"""
        self.logs.append(message)


@dataclass
class UpsertSummary:
    """Summary of database upsert operations"""
    building_id: Optional[str] = None
    units_inserted: int = 0
    units_updated: int = 0
    leases_inserted: int = 0
    leases_updated: int = 0
    insurance_inserted: int = 0
    insurance_updated: int = 0
    compliance_inserted: int = 0
    compliance_updated: int = 0
    budgets_inserted: int = 0
    budgets_updated: int = 0
    contractors_inserted: int = 0
    contractors_updated: int = 0
    errors: List[str] = field(default_factory=list)
    warnings: List[str] = field(default_factory=list)

    def total_inserted(self) -> int:
        return (self.units_inserted + self.leases_inserted +
                self.insurance_inserted + self.compliance_inserted +
                self.budgets_inserted + self.contractors_inserted)

    def total_updated(self) -> int:
        return (self.units_updated + self.leases_updated +
                self.insurance_updated + self.compliance_updated +
                self.budgets_updated + self.contractors_updated)
