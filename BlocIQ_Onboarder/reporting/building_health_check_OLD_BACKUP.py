"""
BlocIQ Onboarder - Building Health Check Report Generator
AI-driven PDF report with analytics, risk assessment, and recommendations
"""

import os
import json
from datetime import datetime, timedelta
from pathlib import Path
from typing import Dict, List, Optional, Tuple
import io

# ReportLab imports
from reportlab.lib import colors
from reportlab.lib.pagesizes import A4, letter
from reportlab.lib.styles import getSampleStyleSheet, ParagraphStyle
from reportlab.lib.units import inch, cm
from reportlab.lib.enums import TA_CENTER, TA_LEFT, TA_RIGHT, TA_JUSTIFY
from reportlab.platypus import (
    SimpleDocTemplate, Paragraph, Spacer, Table, TableStyle,
    PageBreak, Image, KeepTogether
)
from reportlab.pdfgen import canvas
from PyPDF2 import PdfReader, PdfWriter

# Matplotlib for charts
import matplotlib
matplotlib.use('Agg')  # Non-interactive backend
import matplotlib.pyplot as plt
from matplotlib.patches import Wedge
import numpy as np


class BuildingHealthCheckGenerator:
    """Generates comprehensive Building Health Check PDF reports with company branding"""

    def __init__(self, supabase_client=None, branding_config_path=None):
        """
        Initialize report generator

        Args:
            supabase_client: Supabase client instance (optional)
            branding_config_path: Path to branding.json (optional)
        """
        self.supabase = supabase_client
        self.building_data = {}
        self.health_score = 0
        self.recommendations = []

        # Load branding configuration
        self.branding = self._load_branding_config(branding_config_path)

        # Colors from branding config (must be set before styles)
        brand_colors = self.branding.get('brand_colors', {})
        self.COLOR_EXCELLENT = colors.HexColor(brand_colors.get('success', '#10b981'))
        self.COLOR_GOOD = colors.HexColor('#22c55e')
        self.COLOR_ATTENTION = colors.HexColor(brand_colors.get('warning', '#f59e0b'))
        self.COLOR_CRITICAL = colors.HexColor(brand_colors.get('danger', '#ef4444'))
        self.COLOR_HEADER = colors.HexColor(brand_colors.get('primary', '#1e40af'))

        # Status icons
        self.STATUS_ICONS = self.branding.get('status_icons', {
            'compliant': '✅',
            'due_soon': '⚠️',
            'overdue': '❌',
            'missing': '❓',
            'unknown': '❔'
        })

        # Report styling (after colors are set)
        self.styles = getSampleStyleSheet()
        self._setup_custom_styles()

    def _load_branding_config(self, config_path=None):
        """Load branding configuration from JSON file"""
        if config_path is None:
            # Default path
            config_path = Path(__file__).parent.parent / 'config' / 'branding.json'

        try:
            with open(config_path, 'r') as f:
                return json.load(f)
        except FileNotFoundError:
            print(f"   ⚠️  Branding config not found at {config_path}, using defaults")
            return self._get_default_branding()
        except json.JSONDecodeError as e:
            print(f"   ⚠️  Error parsing branding config: {e}, using defaults")
            return self._get_default_branding()

    def _get_default_branding(self):
        """Get default branding configuration"""
        return {
            "company_name": "BlocIQ",
            "report_title": "BlocIQ Building Health Check",
            "logo_path": None,
            "brand_colors": {
                "primary": "#1e40af",
                "success": "#10b981",
                "warning": "#f59e0b",
                "danger": "#ef4444"
            },
            "status_icons": {
                "compliant": "✅",
                "due_soon": "⚠️",
                "overdue": "❌",
                "missing": "❓"
            }
        }
    
    def _format_date(self, date_value: any, default: str = "Not recorded") -> str:
        """Format date value for display"""
        if not date_value or date_value == 'N/A':
            return default
        
        # If already a string in readable format
        if isinstance(date_value, str):
            try:
                # Try to parse and reformat
                dt = datetime.fromisoformat(date_value.replace('Z', '+00:00'))
                return dt.strftime('%d/%m/%Y')
            except:
                return date_value
        
        # If datetime object
        try:
            return date_value.strftime('%d/%m/%Y')
        except:
            return str(date_value)
    
    def _format_currency(self, amount: any, default: str = "Not specified") -> str:
        """Format currency value for display"""
        if amount is None or amount == '' or amount == 'N/A':
            return default
        
        try:
            value = float(amount)
            return f"£{value:,.2f}"
        except:
            return default
    
    def _safe_get(self, data: dict, key: str, default: str = "Not recorded") -> str:
        """Safely get value from dict with meaningful default"""
        value = data.get(key)
        if value is None or value == '' or value == 'N/A':
            return default
        return str(value)

    def _setup_custom_styles(self):
        """Setup custom paragraph styles"""
        fonts = self.branding.get('fonts', {})

        # Title style
        self.styles.add(ParagraphStyle(
            name='CustomTitle',
            parent=self.styles['Heading1'],
            fontSize=fonts.get('size_title', 24),
            fontName=fonts.get('title', 'Helvetica-Bold'),
            textColor=self.COLOR_HEADER,
            spaceAfter=20,
            alignment=TA_CENTER
        ))

        # Section header style
        self.styles.add(ParagraphStyle(
            name='SectionHeader',
            parent=self.styles['Heading2'],
            fontSize=16,
            textColor=self.COLOR_HEADER,
            spaceAfter=12,
            spaceBefore=20,
            borderWidth=0,
            borderPadding=0,
            borderColor=self.COLOR_HEADER,
            borderRadius=None
        ))

        # Warning text (BodyText already exists in stylesheet)
        self.styles.add(ParagraphStyle(
            name='Warning',
            parent=self.styles['BodyText'],
            fontSize=10,
            textColor=self.COLOR_CRITICAL,
            leftIndent=20
        ))

    def generate_report(self, building_id: str, output_dir: str = 'reports', local_data: Dict = None) -> str:
        """
        Generate Building Health Check PDF report

        Args:
            building_id: UUID of building
            output_dir: Output directory for PDF
            local_data: Optional local mapped_data dict (for offline generation)

        Returns:
            Path to generated PDF
        """
        print(f"\n📊 Generating Building Health Check Report...")
        print(f"   Building ID: {building_id}")

        # Ensure building-specific directory exists: /reports/[building_id]/
        output_path = Path(output_dir) / building_id
        output_path.mkdir(exist_ok=True, parents=True)

        # Gather all data (from Supabase or local data)
        if local_data:
            print("   ℹ️  Using local extracted data")
            self.building_data = self._prepare_local_data(building_id, local_data)
        else:
            print("   ℹ️  Querying Supabase for data")
            self.building_data = self._gather_building_data(building_id)

        if not self.building_data.get('building'):
            print("   ⚠️  No building data found")
            return None

        # Calculate health score (updated weights)
        self.health_score = self._calculate_health_score()

        # Generate recommendations
        self.recommendations = self._generate_recommendations()

        # Create PDF with new filename: building_health_check.pdf
        pdf_filename = "building_health_check.pdf"
        pdf_path = output_path / pdf_filename

        doc = SimpleDocTemplate(
            str(pdf_path),
            pagesize=A4,
            rightMargin=1.5*cm,
            leftMargin=1.5*cm,
            topMargin=2*cm,
            bottomMargin=2*cm
        )

        # Build document
        story = []
        story.extend(self._build_header())
        story.extend(self._build_overview())
        story.extend(self._build_contractor_overview())
        story.extend(self._build_health_score_section())
        story.append(PageBreak())
        story.extend(self._build_asset_register_section())
        story.extend(self._build_compliance_section())
        story.append(PageBreak())
        story.extend(self._build_compliance_matrix())
        story.extend(self._build_insurance_section())
        story.append(PageBreak())
        story.extend(self._build_contracts_section())
        story.extend(self._build_utilities_section())
        story.extend(self._build_financial_section())
        story.extend(self._build_budgets_section())
        story.extend(self._build_apportionments_section())
        story.append(PageBreak())
        story.extend(self._build_fire_door_inspections_section())
        story.extend(self._build_staffing_section())
        story.append(PageBreak())
        story.extend(self._build_lease_summary_section())
        story.extend(self._build_assets_section())
        story.extend(self._build_meetings_section())
        story.extend(self._build_recommendations_section())

        # Build PDF
        doc.build(story)

        # Apply letterhead template as background
        final_pdf_path = self._apply_letterhead_background(pdf_path)

        print(f"   ✅ Report generated: {final_pdf_path}")
        return str(final_pdf_path)

    def _apply_letterhead_background(self, pdf_path: Path) -> Path:
        """
        Apply letterhead template as background to all pages

        Args:
            pdf_path: Path to generated PDF

        Returns:
            Path to final PDF with letterhead background
        """
        letterhead_template = self.branding.get('letterhead_template')

        # If no letterhead template, return original
        if not letterhead_template:
            return pdf_path

        # Resolve letterhead path
        if not os.path.isabs(letterhead_template):
            letterhead_path = Path(__file__).parent.parent / letterhead_template
        else:
            letterhead_path = Path(letterhead_template)

        # Check if letterhead exists
        if not letterhead_path.exists():
            print(f"   ⚠️  Letterhead template not found: {letterhead_path}")
            return pdf_path

        try:
            print(f"   📄 Applying letterhead background...")

            # Read letterhead template
            letterhead_reader = PdfReader(str(letterhead_path))
            letterhead_page = letterhead_reader.pages[0]

            # Read generated content
            content_reader = PdfReader(str(pdf_path))
            writer = PdfWriter()

            # Merge each page: letterhead as background, content on top
            for page_num, content_page in enumerate(content_reader.pages):
                # Create new page with letterhead as background
                letterhead_page_copy = letterhead_reader.pages[0]  # Always use first page of letterhead

                # Merge content on top of letterhead
                letterhead_page_copy.merge_page(content_page)

                # Add merged page to writer
                writer.add_page(letterhead_page_copy)

            # Write final PDF with letterhead background
            final_path = pdf_path.parent / f"{pdf_path.stem}_letterhead{pdf_path.suffix}"
            with open(final_path, 'wb') as output_file:
                writer.write(output_file)

            # Replace original with letterhead version
            os.remove(pdf_path)
            os.rename(final_path, pdf_path)

            print(f"   ✅ Letterhead applied to all pages")
            return pdf_path

        except Exception as e:
            print(f"   ⚠️  Error applying letterhead: {e}")
            print(f"   📄 Using report without letterhead background")
            return pdf_path

    def _prepare_local_data(self, building_id: str, mapped_data: Dict) -> Dict:
        """Prepare local mapped_data for report generation"""
        # Ensure building has all required fields
        building = mapped_data.get('building', {})
        if not building:
            building = {}
        
        building.setdefault('id', building_id)
        building.setdefault('name', 'Property Name Not Specified')
        building.setdefault('address', 'Address Not Available')
        
        data = {
            'building': building,
            'compliance_assets': mapped_data.get('compliance_assets', []),
            'insurance_policies': mapped_data.get('insurance_policies', []) or mapped_data.get('building_insurance', []),
            'contracts': mapped_data.get('contracts', []) or mapped_data.get('building_contractors', []),
            'utilities': mapped_data.get('utilities', []),
            'meetings': mapped_data.get('meetings', []),
            'client_money': mapped_data.get('client_money', []),
            'units_count': len(mapped_data.get('units', [])),
            'assets': mapped_data.get('assets', []) or mapped_data.get('compliance_assets', []),
            'contractors': mapped_data.get('contractors', []) or mapped_data.get('building_contractors', []),
            'maintenance_schedules': mapped_data.get('maintenance_schedules', []),
            'apportionments': mapped_data.get('apportionments', []),
            'budgets': mapped_data.get('budgets', []),
            'building_insurance': mapped_data.get('building_insurance', []),
            'fire_door_inspections': mapped_data.get('fire_door_inspections', []),
            'leaseholders': mapped_data.get('leaseholders', []),
            'building_staff': mapped_data.get('building_staff', []),
            'leases': mapped_data.get('leases', [])
        }
        return data

    def _gather_building_data(self, building_id: str) -> Dict:
        """Gather all building data from various sources"""
        data = {
            'building': self._query_building(building_id),
            'compliance_assets': self._query_compliance(building_id),
            'insurance_policies': self._query_insurance(building_id),
            'contracts': self._query_contracts(building_id),
            'utilities': self._query_utilities(building_id),
            'meetings': self._query_meetings(building_id),
            'client_money': self._query_client_money(building_id),
            'units_count': self._query_units_count(building_id),
            'assets': self._query_assets(building_id),
            'contractors': self._query_contractors(building_id),
            'maintenance_schedules': self._query_maintenance_schedules(building_id),
            'apportionments': self._query_apportionments(building_id),
            'budgets': self._query_budgets(building_id),
            'building_insurance': self._query_building_insurance(building_id),
            'fire_door_inspections': self._query_fire_door_inspections(building_id),
            'leaseholders': self._query_leaseholders(building_id),
            'building_staff': self._query_building_staff(building_id),
            'leases': self._query_leases(building_id)
        }
        return data

    def _query_building(self, building_id: str) -> Optional[Dict]:
        """Query building basic info"""
        if not self.supabase:
            return {'id': building_id, 'name': 'Test Building', 'address': 'Test Address'}

        try:
            result = self.supabase.table('buildings').select('*').eq('id', building_id).execute()
            return result.data[0] if result.data else None
        except:
            return None

    def _query_compliance(self, building_id: str) -> List[Dict]:
        """Query compliance assets"""
        if not self.supabase:
            return []

        try:
            result = self.supabase.table('compliance_assets').select('*').eq('building_id', building_id).execute()
            return result.data or []
        except:
            return []

    def _query_insurance(self, building_id: str) -> List[Dict]:
        """Query insurance policies"""
        if not self.supabase:
            return []

        try:
            result = self.supabase.table('insurance_policies').select('*').eq('building_id', building_id).execute()
            return result.data or []
        except:
            return []

    def _query_contracts(self, building_id: str) -> List[Dict]:
        """Query contracts"""
        if not self.supabase:
            return []

        try:
            result = self.supabase.table('contracts').select('*').eq('building_id', building_id).execute()
            return result.data or []
        except:
            return []

    def _query_utilities(self, building_id: str) -> List[Dict]:
        """Query utilities"""
        if not self.supabase:
            return []

        try:
            result = self.supabase.table('utilities').select('*').eq('building_id', building_id).execute()
            return result.data or []
        except:
            return []

    def _query_meetings(self, building_id: str) -> List[Dict]:
        """Query meetings"""
        if not self.supabase:
            return []

        try:
            result = self.supabase.table('meetings').select('*').eq('building_id', building_id).order('meeting_date', desc=True).limit(3).execute()
            return result.data or []
        except:
            return []

    def _query_client_money(self, building_id: str) -> List[Dict]:
        """Query client money snapshots"""
        if not self.supabase:
            return []

        try:
            result = self.supabase.table('client_money_snapshots').select('*').eq('building_id', building_id).order('snapshot_date', desc=True).limit(1).execute()
            return result.data or []
        except:
            return []

    def _query_units_count(self, building_id: str) -> int:
        """Query number of units"""
        if not self.supabase:
            return 0

        try:
            result = self.supabase.table('units').select('id', count='exact').eq('building_id', building_id).execute()
            return result.count or 0
        except:
            return 0

    def _query_assets(self, building_id: str) -> List[Dict]:
        """Query building assets"""
        if not self.supabase:
            return []

        try:
            result = self.supabase.table('assets').select('*').eq('building_id', building_id).execute()
            return result.data or []
        except:
            return []

    def _query_contractors(self, building_id: str) -> List[Dict]:
        """Query contractors linked to building"""
        if not self.supabase:
            return []

        try:
            # Query through building_contractors junction table
            result = self.supabase.table('building_contractors')\
                .select('contractors(*)')\
                .eq('building_id', building_id)\
                .execute()
            return result.data or []
        except:
            return []

    def _query_maintenance_schedules(self, building_id: str) -> List[Dict]:
        """Query maintenance schedules"""
        if not self.supabase:
            return []

        try:
            result = self.supabase.table('maintenance_schedules').select('*').eq('building_id', building_id).execute()
            return result.data or []
        except:
            return []

    def _query_apportionments(self, building_id: str) -> List[Dict]:
        """Query apportionments"""
        if not self.supabase:
            return []

        try:
            result = self.supabase.table('apportionments').select('*').eq('building_id', building_id).execute()
            return result.data or []
        except:
            return []

    def _query_budgets(self, building_id: str) -> List[Dict]:
        """Query budgets"""
        if not self.supabase:
            return []

        try:
            result = self.supabase.table('budgets').select('*').eq('building_id', building_id).execute()
            return result.data or []
        except:
            return []

    def _query_building_insurance(self, building_id: str) -> List[Dict]:
        """Query building insurance"""
        if not self.supabase:
            return []

        try:
            result = self.supabase.table('building_insurance').select('*').eq('building_id', building_id).execute()
            return result.data or []
        except:
            return []

    def _query_fire_door_inspections(self, building_id: str) -> List[Dict]:
        """Query fire door inspections"""
        if not self.supabase:
            return []

        try:
            result = self.supabase.table('fire_door_inspections').select('*').eq('building_id', building_id).execute()
            return result.data or []
        except:
            return []

    def _query_leaseholders(self, building_id: str) -> List[Dict]:
        """Query leaseholders"""
        if not self.supabase:
            return []

        try:
            result = self.supabase.table('leaseholders').select('*').eq('building_id', building_id).execute()
            return result.data or []
        except:
            return []

    def _query_building_staff(self, building_id: str) -> List[Dict]:
        """Query building staff"""
        if not self.supabase:
            return []

        try:
            result = self.supabase.table('building_staff').select('*').eq('building_id', building_id).execute()
            return result.data or []
        except:
            return []

    def _query_leases(self, building_id: str) -> List[Dict]:
        """Query leases"""
        if not self.supabase:
            return []

        try:
            result = self.supabase.table('leases').select('*').eq('building_id', building_id).execute()
            return result.data or []
        except:
            return []

    def _calculate_health_score(self) -> float:
        """
        Calculate overall building health score (0-100)

        Component weights (as per specification):
        - Compliance Coverage: 40%
        - Maintenance & Contractor Readiness: 25%
        - Financial Completeness: 25%
        - Insurance Validity: 10%
        """
        scores = {}

        # Compliance Coverage (40%)
        scores['compliance'] = self._score_compliance() * 0.40

        # Maintenance & Contractor Readiness (25%)
        scores['maintenance'] = self._score_maintenance() * 0.25

        # Financial Completeness (25%)
        scores['finance'] = self._score_finance() * 0.25

        # Insurance Validity (10%)
        scores['insurance'] = self._score_insurance() * 0.10

        total_score = sum(scores.values())
        return round(total_score, 1)

    def _score_compliance(self) -> float:
        """Score compliance health (0-100)"""
        assets = self.building_data.get('compliance_assets', [])
        if not assets:
            return 50.0  # Neutral score if no data

        compliant = 0
        overdue = 0
        due_soon = 0

        today = datetime.now().date()

        for asset in assets:
            status = asset.get('compliance_status', 'unknown')
            if status == 'compliant':
                compliant += 1
            elif status == 'overdue':
                overdue += 1
            elif status == 'due_soon':
                due_soon += 1

        total = len(assets)
        if total == 0:
            return 50.0

        # Calculate score
        score = (compliant / total) * 100
        score -= (overdue / total) * 30  # Penalty for overdue
        score -= (due_soon / total) * 10  # Minor penalty for due soon

        return max(0, min(100, score))

    def _score_insurance(self) -> float:
        """Score insurance health (0-100)"""
        policies = self.building_data.get('insurance_policies', [])
        if not policies:
            return 30.0  # Low score if no insurance

        score = 100.0
        today = datetime.now().date()

        for policy in policies:
            # Check underinsured
            sum_insured = policy.get('sum_insured', 0) or 0
            reinstatement = policy.get('reinstatement_value', 0) or 0

            if reinstatement > 0 and sum_insured < reinstatement * 0.9:
                score -= 15  # Underinsured penalty

            # Check expiry
            end_date_str = policy.get('end_date')
            if end_date_str:
                try:
                    end_date = datetime.fromisoformat(end_date_str).date() if isinstance(end_date_str, str) else end_date_str
                    days_until_expiry = (end_date - today).days

                    if days_until_expiry < 0:
                        score -= 30  # Expired
                    elif days_until_expiry < 30:
                        score -= 10  # Expiring soon

                except:
                    pass

        return max(0, min(100, score))

    def _score_maintenance(self) -> float:
        """Score maintenance & contractor readiness (0-100)"""
        # Check contracts, contractors, maintenance schedules, and assets
        contracts = self.building_data.get('contracts', [])
        contractors = self.building_data.get('contractors', [])
        schedules = self.building_data.get('maintenance_schedules', [])
        assets = self.building_data.get('assets', [])

        score = 0
        weights = []

        # Contracts score (40% of maintenance score)
        if contracts:
            active = sum(1 for c in contracts if c.get('contract_status') == 'active')
            contracts_score = (active / len(contracts)) * 100 if contracts else 60
            score += contracts_score * 0.4
            weights.append(0.4)

        # Contractors score (30% of maintenance score)
        if contractors:
            contractors_score = min(100, (len(contractors) / 5) * 100)  # 5+ contractors = 100%
            score += contractors_score * 0.3
            weights.append(0.3)

        # Maintenance schedules score (30% of maintenance score)
        if schedules:
            # Check how many are up to date
            today = datetime.now().date()
            up_to_date = sum(1 for s in schedules if s.get('next_due') and
                           datetime.strptime(str(s['next_due']), '%Y-%m-%d').date() > today)
            schedules_score = (up_to_date / len(schedules)) * 100 if schedules else 60
            score += schedules_score * 0.3
            weights.append(0.3)

        # If no data, return moderate score
        if not weights:
            return 60.0

        # Normalize by actual weights used
        return min(100, score / sum(weights))

    def _score_contracts(self) -> float:
        """Score contracts health (0-100) - LEGACY"""
        contracts = self.building_data.get('contracts', [])
        if not contracts:
            return 60.0

        active = sum(1 for c in contracts if c.get('contract_status') == 'active')
        total = len(contracts)

        if total == 0:
            return 60.0

        return (active / total) * 100

    def _score_finance(self) -> float:
        """Score financial completeness (0-100)"""
        score = 0
        weights = []

        # Budget score (40% of finance score)
        budgets = self.building_data.get('budgets', [])
        if budgets:
            # Check if current year budget exists
            current_year = datetime.now().year
            has_current = any(str(current_year) in str(b.get('year_start', '')) or
                            str(current_year - 1) in str(b.get('year_start', ''))
                            for b in budgets)
            budget_score = 100 if has_current else 50
            score += budget_score * 0.4
            weights.append(0.4)
        else:
            score += 50 * 0.4  # Missing budget = 50%
            weights.append(0.4)

        # Apportionment score (30% of finance score)
        apportionments = self.building_data.get('apportionments', [])
        if apportionments:
            # Check if totals equal 100%
            total_pct = 0
            for a in apportionments:
                pct = a.get('percentage', 0)
                try:
                    total_pct += float(pct) if pct else 0
                except (ValueError, TypeError):
                    pass
            apport_score = 100 if abs(total_pct - 100) < 0.1 else 70
            score += apport_score * 0.3
            weights.append(0.3)
        else:
            score += 60 * 0.3  # Missing apportionments = 60%
            weights.append(0.3)

        # Client money / arrears score (30% of finance score)
        snapshots = self.building_data.get('client_money', [])
        if snapshots:
            snapshot = snapshots[0]
            balance = snapshot.get('balance', 0) or 0
            arrears = snapshot.get('arrears_total', 0) or 0

            if balance == 0:
                arrears_score = 50
            else:
                arrears_ratio = arrears / balance if balance > 0 else 0
                arrears_score = 100 - (arrears_ratio * 100)
                arrears_score = max(0, min(100, arrears_score))

            score += arrears_score * 0.3
            weights.append(0.3)
        else:
            score += 70 * 0.3  # No data = 70%
            weights.append(0.3)

        # Normalize by actual weights used
        return min(100, score / sum(weights)) if weights else 70.0

    def _score_utilities(self) -> float:
        """Score utilities health (0-100)"""
        utilities = self.building_data.get('utilities', [])
        if not utilities:
            return 70.0  # Moderate if no data

        active = sum(1 for u in utilities if u.get('contract_status') == 'active')
        total = len(utilities)

        if total == 0:
            return 70.0

        return (active / total) * 100

    def _score_meetings(self) -> float:
        """Score meetings health (0-100)"""
        meetings = self.building_data.get('meetings', [])

        if not meetings:
            return 50.0

        # Check if last meeting was within 3 months
        last_meeting = meetings[0]
        meeting_date_str = last_meeting.get('meeting_date')

        if meeting_date_str:
            try:
                meeting_date = datetime.fromisoformat(meeting_date_str).date() if isinstance(meeting_date_str, str) else meeting_date_str
                days_since = (datetime.now().date() - meeting_date).days

                if days_since < 90:
                    return 100.0
                elif days_since < 180:
                    return 70.0
                else:
                    return 40.0
            except:
                pass

        return 50.0

    def _generate_recommendations(self) -> List[str]:
        """Generate actionable recommendations"""
        recommendations = []

        # Compliance recommendations
        assets = self.building_data.get('compliance_assets', [])
        today = datetime.now().date()

        for asset in assets:
            status = asset.get('compliance_status')
            asset_name = asset.get('asset_name', 'Unknown')
            reinspection_date = asset.get('reinspection_date')

            if status == 'overdue':
                recommendations.append(f"🔴 URGENT: Renew {asset_name} (overdue)")
            elif status == 'due_soon' and reinspection_date:
                try:
                    due_date = datetime.fromisoformat(reinspection_date).date() if isinstance(reinspection_date, str) else reinspection_date
                    recommendations.append(f"🟠 ATTENTION: {asset_name} due on {due_date.strftime('%d/%m/%Y')}")
                except:
                    pass

        # Insurance recommendations
        policies = self.building_data.get('insurance_policies', [])
        for policy in policies:
            sum_insured = policy.get('sum_insured', 0) or 0
            reinstatement = policy.get('reinstatement_value', 0) or 0
            policy_number = policy.get('policy_number', 'N/A')

            if reinstatement > 0 and sum_insured < reinstatement * 0.9:
                gap = reinstatement - sum_insured
                recommendations.append(f"💰 Review Policy {policy_number}: Underinsured by £{gap:,.0f}")

            # Check expiry
            end_date_str = policy.get('end_date')
            if end_date_str:
                try:
                    end_date = datetime.fromisoformat(end_date_str).date() if isinstance(end_date_str, str) else end_date_str
                    days_until = (end_date - today).days

                    if 0 < days_until < 30:
                        recommendations.append(f"📅 Policy {policy_number} expires in {days_until} days")
                    elif days_until < 0:
                        recommendations.append(f"🔴 URGENT: Policy {policy_number} has expired")
                except:
                    pass

        # Contract recommendations
        contracts = self.building_data.get('contracts', [])
        for contract in contracts:
            if contract.get('contract_status') == 'expired':
                contractor = contract.get('contractor_name', 'Unknown')
                service = contract.get('service_type', 'service')
                recommendations.append(f"📝 Reinstate {service} contract with {contractor}")

        return recommendations[:10]  # Top 10 recommendations

    def _build_header(self) -> List:
        """Build report header with company logo"""
        elements = []

        building = self.building_data.get('building', {})
        building_name = building.get('name', 'Unknown Building')

        # Check if using letterhead template
        uses_letterhead = bool(self.branding.get('letterhead_template'))

        # Add company logo if available (only if not using letterhead template)
        logo_path = self.branding.get('logo_path')
        if logo_path and not uses_letterhead:
            # Resolve logo path relative to module
            if not os.path.isabs(logo_path):
                logo_path = Path(__file__).parent.parent / logo_path

            if os.path.exists(logo_path):
                try:
                    # Add logo at top
                    logo = Image(str(logo_path), width=2*inch, height=0.8*inch)
                    elements.append(logo)
                    elements.append(Spacer(1, 0.2*inch))
                except Exception as e:
                    print(f"   ⚠️  Could not load logo: {e}")

        # Add top spacing if using letterhead to avoid overlap with letterhead header
        if uses_letterhead:
            elements.append(Spacer(1, 1.5*inch))

        # Title
        report_title = self.branding.get('report_title', 'Building Health Check Report')
        title = Paragraph(report_title, self.styles['CustomTitle'])
        elements.append(title)

        # Subtitle
        subtitle = f"Building Intelligence Report – {building_name}"
        elements.append(Paragraph(f"<i>{subtitle}</i>", self.styles['BodyText']))
        elements.append(Spacer(1, 0.3*inch))

        # Building info
        building_info = f"""
        <b>Building:</b> {building_name}<br/>
        <b>Address:</b> {building.get('address', 'N/A')}<br/>
        <b>Report Date:</b> {datetime.now().strftime('%d %B %Y')}<br/>
        <b>Prepared by:</b> {self.branding.get('company_name', 'BlocIQ')} Onboarder (Automated)
        """
        elements.append(Paragraph(building_info, self.styles['BodyText']))
        elements.append(Spacer(1, 0.5*inch))

        return elements

    def _build_overview(self) -> List:
        """Build overview section - Building Summary"""
        elements = []

        elements.append(Paragraph("Section 1: Building Summary", self.styles['SectionHeader']))

        # Building summary table matching required format
        building = self.building_data.get('building', {})
        building_name = building.get('name', 'Unknown Building')

        # Count leaseholders
        leaseholders_count = len(self.building_data.get('leaseholders', []))

        # Count assets
        assets_count = len(self.building_data.get('assets', []))

        # Count active contracts
        contracts = self.building_data.get('contracts', [])
        active_contracts = len([c for c in contracts if c.get('contract_status') == 'active'])

        stats_data = [
            ['Field', 'Value'],
            ['Building Name', building_name],
            ['Total Units', str(self.building_data.get('units_count', 0))],
            ['Total Leaseholders', str(leaseholders_count)],
            ['Active Contracts', str(active_contracts)],
            ['Known Assets', str(assets_count)],
            ['Compliance Assets', str(len(self.building_data.get('compliance_assets', [])))]
        ]

        stats_table = Table(stats_data, colWidths=[3*inch, 3*inch])
        stats_table.setStyle(TableStyle([
            ('BACKGROUND', (0, 0), (-1, 0), self.COLOR_HEADER),
            ('TEXTCOLOR', (0, 0), (-1, 0), colors.whitesmoke),
            ('ALIGN', (0, 0), (-1, -1), 'LEFT'),
            ('FONTNAME', (0, 0), (-1, 0), 'Helvetica-Bold'),
            ('FONTSIZE', (0, 0), (-1, 0), 12),
            ('BOTTOMPADDING', (0, 0), (-1, 0), 12),
            ('BACKGROUND', (0, 1), (-1, -1), colors.beige),
            ('GRID', (0, 0), (-1, -1), 1, colors.black)
        ]))

        elements.append(stats_table)
        elements.append(Spacer(1, 0.3*inch))

        return elements

    def _build_contractor_overview(self) -> List:
        """Build Section 2: Contractor Overview"""
        elements = []

        elements.append(Paragraph("Section 2: Contractor Overview", self.styles['SectionHeader']))

        contractors = self.building_data.get('contractors', [])
        contracts = self.building_data.get('contracts', [])

        if not contractors and not contracts:
            elements.append(Paragraph(
                "No contractor information has been identified during onboarding. "
                "This section will be populated when contractor agreements and service contracts are provided.",
                self.styles['BodyText']
            ))
            elements.append(Spacer(1, 0.3*inch))
            return elements

        # Summary stats
        active_contracts = len([c for c in contracts if c.get('contract_status') == 'active'])
        total_contractors = len(set(c.get('contractor_name') or c.get('company_name') for c in contracts if c.get('contractor_name') or c.get('company_name')))
        
        summary_text = f"<b>Active Contractors:</b> {total_contractors} | <b>Active Contracts:</b> {active_contracts}/{len(contracts)}"
        elements.append(Paragraph(summary_text, self.styles['BodyText']))
        elements.append(Spacer(1, 0.2*inch))

        # List contractors and their contracts
        for contract in contracts[:15]:  # Limit to 15 for readability
            contractor_name = self._safe_get(contract, 'contractor_name', 'Contractor name not recorded')
            if contractor_name == 'Contractor name not recorded':
                contractor_name = self._safe_get(contract, 'company_name', 'Unknown Contractor')
            
            service_type = contract.get('service_type', 'general_services')
            service_type = service_type.replace('_', ' ').title() if service_type else 'General Services'
            
            frequency = contract.get('frequency') or contract.get('service_frequency', '')
            frequency_display = frequency.replace('_', ' ').title() if frequency else 'As required'
            
            end_date = self._format_date(contract.get('end_date') or contract.get('contract_end'), 'Date not specified')
            status = contract.get('contract_status', 'unknown')

            # Status icon
            if status == 'active':
                status_icon = '✅'
                status_text = 'Active'
            elif status == 'expired':
                status_icon = '❌'
                status_text = 'Expired'
            elif status == 'expiring_soon':
                status_icon = '⚠️'
                status_text = 'Expiring Soon'
            else:
                status_icon = '❔'
                status_text = 'Status Unknown'

            contractor_line = f"{status_icon} <b>{contractor_name}</b> – {service_type} – {frequency_display} – Contract End: {end_date}"
            elements.append(Paragraph(contractor_line, self.styles['BodyText']))
            elements.append(Spacer(1, 0.1*inch))

        if len(contracts) > 15:
            elements.append(Paragraph(f"<i>... and {len(contracts) - 15} more contractors</i>", self.styles['BodyText']))

        elements.append(Spacer(1, 0.2*inch))
        return elements

    def _build_asset_register_section(self) -> List:
        """Build Section 3: Asset Register"""
        elements = []

        elements.append(Paragraph("Section 3: Asset Register", self.styles['SectionHeader']))

        assets = self.building_data.get('assets', [])
        contractors = {c.get('id'): c.get('company_name') for c in self.building_data.get('contractors', [])}
        compliance_assets = {c.get('id'): c.get('compliance_status', 'unknown') for c in self.building_data.get('compliance_assets', [])}

        if not assets:
            elements.append(Paragraph(
                "Asset register is being compiled. This section tracks all building equipment, "
                "systems and components requiring maintenance or compliance monitoring.",
                self.styles['BodyText']
            ))
            elements.append(Spacer(1, 0.3*inch))
            return elements

        # Summary
        summary_text = f"Total Assets Identified: <b>{len(assets)}</b>"
        elements.append(Paragraph(summary_text, self.styles['BodyText']))
        elements.append(Spacer(1, 0.2*inch))

        # Asset table
        table_data = [['Asset Name', 'Type', 'Service Frequency', 'Last Serviced', 'Next Due', 'Status']]

        for asset in assets[:15]:  # First 15 assets
            asset_name = asset.get('asset_name')
            if not asset_name or asset_name == 'N/A':
                asset_type = asset.get('asset_type', 'asset').replace('_', ' ').title()
                asset_name = f"{asset_type} (ID on file)"
            
            # Truncate long names
            if len(asset_name) > 35:
                asset_name = asset_name[:32] + '...'
            
            asset_type = asset.get('asset_type', 'general').replace('_', ' ').title()
            
            frequency = asset.get('service_frequency') or asset.get('frequency', '')
            frequency_display = frequency.replace('_', ' ').title() if frequency else 'As required'
            
            last_service = self._format_date(
                asset.get('last_service_date') or asset.get('last_inspection_date'),
                'Not recorded'
            )
            next_due = self._format_date(
                asset.get('next_due_date') or asset.get('next_inspection_date'),
                'To be scheduled'
            )

            # Determine status icon
            status_icon = '❔'
            next_due_raw = asset.get('next_due_date') or asset.get('next_inspection_date')
            if next_due_raw and next_due_raw != 'N/A':
                try:
                    next_date = datetime.fromisoformat(str(next_due_raw)).date()
                    today = datetime.now().date()
                    days_until = (next_date - today).days

                    if days_until < 0:
                        status_icon = '❌'
                    elif days_until < 30:
                        status_icon = '⚠️'
                    else:
                        status_icon = '✅'
                except:
                    pass

            table_data.append([
                asset_name,
                asset_type,
                frequency_display,
                last_service,
                next_due,
                status_icon
            ])

        asset_table = Table(table_data, colWidths=[2.0*inch, 1.3*inch, 1.2*inch, 1.0*inch, 1.0*inch, 0.6*inch])
        asset_table.setStyle(TableStyle([
            ('BACKGROUND', (0, 0), (-1, 0), self.COLOR_HEADER),
            ('TEXTCOLOR', (0, 0), (-1, 0), colors.whitesmoke),
            ('ALIGN', (0, 0), (-1, -1), 'LEFT'),
            ('VALIGN', (0, 0), (-1, -1), 'TOP'),
            ('FONTNAME', (0, 0), (-1, 0), 'Helvetica-Bold'),
            ('FONTSIZE', (0, 0), (-1, 0), 8),
            ('FONTSIZE', (0, 1), (-1, -1), 7),
            ('BOTTOMPADDING', (0, 0), (-1, 0), 12),
            ('BACKGROUND', (0, 1), (-1, -1), colors.beige),
            ('GRID', (0, 0), (-1, -1), 0.5, colors.grey),
            ('ROWBACKGROUNDS', (0, 1), (-1, -1), [colors.beige, colors.white])
        ]))

        elements.append(asset_table)

        if len(assets) > 15:
            elements.append(Spacer(1, 0.1*inch))
            elements.append(Paragraph(f"<i>... and {len(assets) - 15} additional assets on record</i>", self.styles['BodyText']))

        elements.append(Spacer(1, 0.3*inch))
        return elements

    def _build_compliance_matrix(self) -> List:
        """Build Section 4: Compliance Matrix"""
        elements = []

        elements.append(Paragraph("Section 4: Compliance Matrix", self.styles['SectionHeader']))

        compliance_assets = self.building_data.get('compliance_assets', [])

        if not compliance_assets:
            elements.append(Paragraph("No compliance data available.", self.styles['BodyText']))
            elements.append(Spacer(1, 0.3*inch))
            return elements

        # Group by compliance category
        categories = {}
        for asset in compliance_assets:
            category = asset.get('asset_type', 'Other').replace('_', ' ').title()
            status = asset.get('compliance_status', 'unknown')

            if category not in categories:
                categories[category] = {'compliant': 0, 'overdue': 0, 'unknown': 0}

            if status in ['compliant', 'current']:
                categories[category]['compliant'] += 1
            elif status in ['overdue', 'expired']:
                categories[category]['overdue'] += 1
            else:
                categories[category]['unknown'] += 1

        # Build matrix table
        matrix_data = [['Category', 'Compliant', 'Overdue', 'Unknown']]
        for category, counts in sorted(categories.items()):
            matrix_data.append([
                category,
                f"{self.STATUS_ICONS['compliant']} {counts['compliant']}",
                f"{self.STATUS_ICONS['overdue']} {counts['overdue']}" if counts['overdue'] > 0 else '0',
                f"{self.STATUS_ICONS['unknown']} {counts['unknown']}" if counts['unknown'] > 0 else '0'
            ])

        matrix_table = Table(matrix_data, colWidths=[2.5*inch, 1.5*inch, 1.5*inch, 1.5*inch])
        matrix_table.setStyle(TableStyle([
            ('BACKGROUND', (0, 0), (-1, 0), self.COLOR_HEADER),
            ('TEXTCOLOR', (0, 0), (-1, 0), colors.whitesmoke),
            ('ALIGN', (0, 0), (-1, -1), 'LEFT'),
            ('FONTNAME', (0, 0), (-1, 0), 'Helvetica-Bold'),
            ('FONTSIZE', (0, 0), (-1, 0), 10),
            ('BOTTOMPADDING', (0, 0), (-1, 0), 12),
            ('BACKGROUND', (0, 1), (-1, -1), colors.beige),
            ('GRID', (0, 0), (-1, -1), 1, colors.black)
        ]))

        elements.append(matrix_table)
        elements.append(Spacer(1, 0.3*inch))

        return elements

    def _build_health_score_section(self) -> List:
        """Build health score section with gauge"""
        elements = []

        elements.append(Paragraph("Overall Building Health Score", self.styles['SectionHeader']))

        # Generate gauge chart
        gauge_path = self._create_gauge_chart(self.health_score)
        if gauge_path and os.path.exists(gauge_path):
            gauge_img = Image(gauge_path, width=4*inch, height=3*inch)
            elements.append(gauge_img)

        # Score interpretation
        rating = self._get_health_rating(self.health_score)
        rating_color = self._get_rating_color(self.health_score)

        score_text = f"""
        <b><font color="{rating_color}" size="14">Score: {self.health_score}/100 - {rating}</font></b>
        """
        elements.append(Paragraph(score_text, self.styles['BodyText']))
        elements.append(Spacer(1, 0.2*inch))

        return elements

    def _build_compliance_section(self) -> List:
        """Build compliance section"""
        elements = []

        elements.append(Paragraph("🔥 Compliance Status", self.styles['SectionHeader']))

        assets = self.building_data.get('compliance_assets', [])

        if not assets:
            elements.append(Paragraph(
                "Compliance tracking is being established. This section monitors statutory inspections, "
                "certifications and regulatory requirements for the building.",
                self.styles['BodyText']
            ))
            return elements

        # Summary stats
        compliant = sum(1 for a in assets if a.get('compliance_status') == 'compliant')
        overdue = sum(1 for a in assets if a.get('compliance_status') == 'overdue')
        due_soon = sum(1 for a in assets if a.get('compliance_status') == 'due_soon')
        unknown = len(assets) - compliant - overdue - due_soon

        summary = f"""
        <b>Total Compliance Items:</b> {len(assets)}<br/>
        <b><font color="green">✅ Compliant:</font></b> {compliant} ({compliant/len(assets)*100:.0f}%)<br/>
        <b><font color="red">❌ Overdue:</font></b> {overdue} ({overdue/len(assets)*100:.0f}%)<br/>
        <b><font color="orange">⚠️ Due Soon:</font></b> {due_soon}<br/>
        <b><font color="gray">❔ Status Unknown:</font></b> {unknown}
        """
        elements.append(Paragraph(summary, self.styles['BodyText']))
        elements.append(Spacer(1, 0.2*inch))

        # Table of assets
        table_data = [['Asset/Certificate', 'Last Inspection', 'Next Due', 'Responsible Party', 'Status']]

        for asset in assets[:10]:  # First 10
            asset_name = asset.get('asset_name') or asset.get('name', 'Compliance Item')
            if len(asset_name) > 30:
                asset_name = asset_name[:27] + '...'
            
            last_inspection = self._format_date(
                asset.get('inspection_date') or asset.get('last_inspection_date'),
                'Not recorded'
            )
            next_due = self._format_date(
                asset.get('reinspection_date') or asset.get('next_due_date'),
                'To be scheduled'
            )
            
            responsible = asset.get('inspection_contractor') or asset.get('responsible_party', '')
            if responsible and len(responsible) > 20:
                responsible = responsible[:17] + '...'
            elif not responsible:
                responsible = 'Not assigned'
            
            status = asset.get('compliance_status', 'unknown')
            status_color = {
                'compliant': 'green',
                'due_soon': 'orange',
                'overdue': 'red',
                'unknown': 'gray'
            }.get(status, 'black')
            
            status_display = status.replace('_', ' ').title()

            table_data.append([
                asset_name,
                last_inspection,
                next_due,
                responsible,
                f'<font color="{status_color}"><b>{status_display}</b></font>'
            ])

        compliance_table = Table(table_data, colWidths=[2.0*inch, 1.2*inch, 1.2*inch, 1.5*inch, 1.0*inch])
        compliance_table.setStyle(TableStyle([
            ('BACKGROUND', (0, 0), (-1, 0), self.COLOR_HEADER),
            ('TEXTCOLOR', (0, 0), (-1, 0), colors.whitesmoke),
            ('ALIGN', (0, 0), (-1, -1), 'LEFT'),
            ('VALIGN', (0, 0), (-1, -1), 'TOP'),
            ('FONTNAME', (0, 0), (-1, 0), 'Helvetica-Bold'),
            ('FONTSIZE', (0, 0), (-1, -1), 8),
            ('BOTTOMPADDING', (0, 0), (-1, 0), 12),
            ('GRID', (0, 0), (-1, -1), 0.5, colors.grey),
            ('ROWBACKGROUNDS', (0, 1), (-1, -1), [colors.beige, colors.white])
        ]))

        elements.append(compliance_table)
        
        if len(assets) > 10:
            elements.append(Spacer(1, 0.1*inch))
            elements.append(Paragraph(f"<i>... and {len(assets) - 10} additional compliance items</i>", self.styles['BodyText']))
        
        elements.append(Spacer(1, 0.3*inch))

        return elements

    def _build_insurance_section(self) -> List:
        """Build insurance section"""
        elements = []

        elements.append(Paragraph("🛡️ Insurance Coverage", self.styles['SectionHeader']))

        policies = self.building_data.get('insurance_policies', [])

        if not policies:
            elements.append(Paragraph(
                "Insurance policy information is being compiled. This section will track building insurance, "
                "liability cover, and other relevant policies including renewal dates and coverage levels.",
                self.styles['BodyText']
            ))
            return elements

        # Summary
        elements.append(Paragraph(f"<b>Policies on Record:</b> {len(policies)}", self.styles['BodyText']))
        elements.append(Spacer(1, 0.2*inch))

        # Policy table
        table_data = [['Insurer', 'Policy Number', 'Cover Type', 'Sum Insured', 'Renewal Date', 'Status']]

        today = datetime.now().date()

        for policy in policies:
            insurer = self._safe_get(policy, 'insurer', 'Insurer not recorded')
            if len(insurer) > 20:
                insurer = insurer[:17] + '...'
            
            policy_number = self._safe_get(policy, 'policy_number', 'Not recorded')
            if len(policy_number) > 15:
                policy_number = policy_number[:12] + '...'
            
            cover_type = self._safe_get(policy, 'cover_type', 'Buildings')
            if len(cover_type) > 15:
                cover_type = cover_type[:12] + '...'
            
            sum_insured = policy.get('sum_insured', 0) or policy.get('premium_amount', 0) or 0
            sum_insured_display = self._format_currency(sum_insured, 'Not specified')
            
            end_date_str = policy.get('end_date') or policy.get('expiry_date')
            expiry_date = self._format_date(end_date_str, 'Not recorded')

            status = '✅ Active'
            status_color = 'green'

            if end_date_str:
                try:
                    end_date = datetime.fromisoformat(str(end_date_str)).date() if isinstance(end_date_str, str) else end_date_str
                    days_until = (end_date - today).days

                    if days_until < 0:
                        status = '❌ Expired'
                        status_color = 'red'
                    elif days_until < 30:
                        status = f'⚠️ {days_until} days'
                        status_color = 'orange'
                    else:
                        status = '✅ Current'
                except:
                    status = '❔ Unknown'
                    status_color = 'gray'

            table_data.append([
                insurer,
                policy_number,
                cover_type,
                sum_insured_display,
                expiry_date,
                f'<font color="{status_color}"><b>{status}</b></font>'
            ])

        insurance_table = Table(table_data, colWidths=[1.5*inch, 1.3*inch, 1.0*inch, 1.2*inch, 1.1*inch, 1.0*inch])
        insurance_table.setStyle(TableStyle([
            ('BACKGROUND', (0, 0), (-1, 0), self.COLOR_HEADER),
            ('TEXTCOLOR', (0, 0), (-1, 0), colors.whitesmoke),
            ('ALIGN', (0, 0), (-1, -1), 'LEFT'),
            ('VALIGN', (0, 0), (-1, -1), 'TOP'),
            ('FONTNAME', (0, 0), (-1, 0), 'Helvetica-Bold'),
            ('FONTSIZE', (0, 0), (-1, -1), 8),
            ('BOTTOMPADDING', (0, 0), (-1, 0), 12),
            ('GRID', (0, 0), (-1, -1), 0.5, colors.grey),
            ('ROWBACKGROUNDS', (0, 1), (-1, -1), [colors.beige, colors.white])
        ]))

        elements.append(insurance_table)
        elements.append(Spacer(1, 0.3*inch))

        return elements

    def _build_contracts_section(self) -> List:
        """Build contracts section"""
        elements = []

        elements.append(Paragraph("🧾 Active Contracts", self.styles['SectionHeader']))

        contracts = self.building_data.get('contracts', [])

        if not contracts:
            elements.append(Paragraph("No contract data available.", self.styles['BodyText']))
            return elements

        # Contract table
        table_data = [['Contractor', 'Service', 'End Date', 'Status']]

        for contract in contracts[:10]:
            status = contract.get('contract_status', 'unknown')
            status_display = {
                'active': '✅ Active',
                'expired': '🔴 Expired',
                'expiring_soon': '🟠 Expiring'
            }.get(status, status)

            table_data.append([
                contract.get('contractor_name', 'N/A')[:30],
                contract.get('service_type', 'N/A'),
                contract.get('end_date', 'N/A'),
                status_display
            ])

        contracts_table = Table(table_data, colWidths=[2.5*inch, 1.5*inch, 1.5*inch, 1.5*inch])
        contracts_table.setStyle(TableStyle([
            ('BACKGROUND', (0, 0), (-1, 0), self.COLOR_HEADER),
            ('TEXTCOLOR', (0, 0), (-1, 0), colors.whitesmoke),
            ('ALIGN', (0, 0), (-1, -1), 'LEFT'),
            ('FONTNAME', (0, 0), (-1, 0), 'Helvetica-Bold'),
            ('FONTSIZE', (0, 0), (-1, -1), 9),
            ('BOTTOMPADDING', (0, 0), (-1, 0), 12),
            ('GRID', (0, 0), (-1, -1), 1, colors.black)
        ]))

        elements.append(contracts_table)
        elements.append(Spacer(1, 0.3*inch))

        return elements

    def _build_utilities_section(self) -> List:
        """Build utilities section"""
        elements = []

        elements.append(Paragraph("⚡ Utilities", self.styles['SectionHeader']))

        utilities = self.building_data.get('utilities', [])

        if not utilities:
            elements.append(Paragraph("No utility data available.", self.styles['BodyText']))
            return elements

        # Utilities table
        table_data = [['Supplier', 'Type', 'Account No.', 'Status']]

        for utility in utilities:
            table_data.append([
                utility.get('supplier', 'N/A')[:25],
                utility.get('utility_type', 'N/A'),
                utility.get('account_number', 'N/A')[:20],
                utility.get('contract_status', 'N/A')
            ])

        utilities_table = Table(table_data, colWidths=[2*inch, 1.5*inch, 2*inch, 1.5*inch])
        utilities_table.setStyle(TableStyle([
            ('BACKGROUND', (0, 0), (-1, 0), self.COLOR_HEADER),
            ('TEXTCOLOR', (0, 0), (-1, 0), colors.whitesmoke),
            ('ALIGN', (0, 0), (-1, -1), 'LEFT'),
            ('FONTNAME', (0, 0), (-1, 0), 'Helvetica-Bold'),
            ('FONTSIZE', (0, 0), (-1, -1), 9),
            ('BOTTOMPADDING', (0, 0), (-1, 0), 12),
            ('GRID', (0, 0), (-1, -1), 1, colors.black)
        ]))

        elements.append(utilities_table)
        elements.append(Spacer(1, 0.3*inch))

        return elements

    def _build_financial_section(self) -> List:
        """Build financial section"""
        elements = []

        elements.append(Paragraph("💰 Financial Position", self.styles['SectionHeader']))

        snapshots = self.building_data.get('client_money', [])

        if not snapshots:
            elements.append(Paragraph("No financial data available.", self.styles['BodyText']))
            return elements

        snapshot = snapshots[0]
        balance = snapshot.get('balance', 0) or 0
        uncommitted = snapshot.get('uncommitted_funds', 0) or 0
        arrears = snapshot.get('arrears_total', 0) or 0

        financial_text = f"""
        <b>Client Account Balance:</b> £{balance:,.2f}<br/>
        <b>Uncommitted Funds:</b> £{uncommitted:,.2f}<br/>
        <b>Total Arrears:</b> <font color="red">£{arrears:,.2f}</font><br/>
        <b>Snapshot Date:</b> {snapshot.get('snapshot_date', 'N/A')}
        """
        elements.append(Paragraph(financial_text, self.styles['BodyText']))
        elements.append(Spacer(1, 0.3*inch))

        return elements

    def _build_assets_section(self) -> List:
        """Build assets register section"""
        elements = []

        elements.append(Paragraph("🏗️ Asset Register", self.styles['SectionHeader']))

        assets = self.building_data.get('assets', [])

        if not assets:
            elements.append(Paragraph("No asset data available.", self.styles['BodyText']))
            elements.append(Spacer(1, 0.3*inch))
            return elements

        # Group assets by type
        assets_by_type = {}
        for asset in assets:
            asset_type = asset.get('asset_type', 'other')
            if asset_type not in assets_by_type:
                assets_by_type[asset_type] = []
            assets_by_type[asset_type].append(asset)

        # Summary text
        summary_text = f"Total Assets: <b>{len(assets)}</b> | Types: <b>{len(assets_by_type)}</b>"
        elements.append(Paragraph(summary_text, self.styles['BodyText']))
        elements.append(Spacer(1, 0.2*inch))

        # Build assets table (show first 20 assets)
        table_data = [['Asset Type', 'Name', 'Location', 'Condition', 'Last Service', 'Next Due']]

        for asset in assets[:20]:  # Limit to 20 assets
            asset_type = asset.get('asset_type', 'general').replace('_', ' ').title()
            asset_name = asset.get('asset_name', 'Asset')
            location = asset.get('location_description') or asset.get('location', 'Not specified')
            if location and len(str(location)) > 30:
                location = str(location)[:27] + '...'
            elif not location:
                location = 'Not specified'
            condition = asset.get('condition_rating', 'Unknown')
            last_service = self._format_date(asset.get('last_service_date') or asset.get('last_inspection_date'), 'Not recorded')
            next_due = self._format_date(asset.get('next_due_date') or asset.get('next_inspection_date'), 'To be scheduled')

            # Color code by condition
            if condition and condition.lower() == 'poor':
                condition_cell = Paragraph(f'<font color="red">{condition}</font>', self.styles['BodyText'])
            elif condition and condition.lower() == 'excellent':
                condition_cell = Paragraph(f'<font color="green">{condition}</font>', self.styles['BodyText'])
            else:
                condition_cell = condition

            table_data.append([
                asset_type,
                asset_name,
                location,
                condition_cell,
                last_service,
                next_due
            ])

        assets_table = Table(table_data, colWidths=[1.2*inch, 1.5*inch, 1.5*inch, 0.9*inch, 1.0*inch, 1.0*inch])
        assets_table.setStyle(TableStyle([
            ('BACKGROUND', (0, 0), (-1, 0), self.COLOR_HEADER),
            ('TEXTCOLOR', (0, 0), (-1, 0), colors.whitesmoke),
            ('ALIGN', (0, 0), (-1, -1), 'LEFT'),
            ('FONTNAME', (0, 0), (-1, 0), 'Helvetica-Bold'),
            ('FONTSIZE', (0, 0), (-1, 0), 9),
            ('FONTSIZE', (0, 1), (-1, -1), 8),
            ('BOTTOMPADDING', (0, 0), (-1, 0), 12),
            ('BACKGROUND', (0, 1), (-1, -1), colors.beige),
            ('GRID', (0, 0), (-1, -1), 0.5, colors.grey)
        ]))

        elements.append(assets_table)

        if len(assets) > 20:
            elements.append(Spacer(1, 0.1*inch))
            elements.append(Paragraph(f"<i>... and {len(assets) - 20} more assets</i>", self.styles['BodyText']))

        elements.append(Spacer(1, 0.3*inch))

        return elements

    def _build_meetings_section(self) -> List:
        """Build meetings section"""
        elements = []

        elements.append(Paragraph("🗂️ Recent Meetings", self.styles['SectionHeader']))

        meetings = self.building_data.get('meetings', [])

        if not meetings:
            elements.append(Paragraph("No meeting records available.", self.styles['BodyText']))
            return elements

        for meeting in meetings[:3]:
            meeting_text = f"""
            <b>{meeting.get('meeting_type', 'Meeting')}</b> - {meeting.get('meeting_date', 'N/A')}<br/>
            <i>Key Decisions:</i> {meeting.get('key_decisions', 'N/A')[:200]}...
            """
            elements.append(Paragraph(meeting_text, self.styles['BodyText']))
            elements.append(Spacer(1, 0.2*inch))

        return elements

    def _build_recommendations_section(self) -> List:
        """Build Section 5: Recommendations"""
        elements = []

        elements.append(Paragraph("Section 5: Recommendations", self.styles['SectionHeader']))

        if not self.recommendations:
            # Generate recommendations if not already done
            self.recommendations = self._generate_recommendations()

        if not self.recommendations:
            elements.append(Paragraph("No specific recommendations at this time. All systems appear to be operating normally.", self.styles['BodyText']))
            return elements

        elements.append(Paragraph("<b>Auto-generated action items based on data analysis:</b>", self.styles['BodyText']))
        elements.append(Spacer(1, 0.1*inch))

        for i, rec in enumerate(self.recommendations, 1):
            elements.append(Paragraph(f"{i}. {rec}", self.styles['BodyText']))
            elements.append(Spacer(1, 0.1*inch))

        return elements

    def _create_gauge_chart(self, score: float) -> Optional[str]:
        """Create gauge chart for health score"""
        try:
            fig, ax = plt.subplots(figsize=(6, 4), subplot_kw={'projection': 'polar'})

            # Gauge parameters
            theta = np.linspace(0, np.pi, 100)

            # Background arc
            ax.plot(theta, [1]*100, linewidth=20, color='lightgray', alpha=0.3)

            # Score arc
            score_theta = np.linspace(0, np.pi * (score/100), 100)
            color = self._get_rating_color_rgb(score)
            ax.plot(score_theta, [1]*100, linewidth=20, color=color)

            # Needle
            needle_theta = np.pi * (score/100)
            ax.plot([needle_theta, needle_theta], [0, 1], linewidth=3, color='black')

            # Score text
            ax.text(np.pi/2, 0.5, f"{score:.1f}", ha='center', va='center', fontsize=32, fontweight='bold')

            ax.set_ylim(0, 1.2)
            ax.set_yticks([])
            ax.set_xticks([])
            ax.spines['polar'].set_visible(False)
            ax.grid(False)

            # Save
            gauge_path = '/tmp/health_gauge.png'
            plt.savefig(gauge_path, bbox_inches='tight', dpi=150, transparent=True)
            plt.close()

            return gauge_path
        except Exception as e:
            print(f"   ⚠️  Error creating gauge chart: {e}")
            return None

    def _get_health_rating(self, score: float) -> str:
        """Get health rating label"""
        if score >= 90:
            return '✅ Excellent'
        elif score >= 70:
            return '🟢 Good'
        elif score >= 50:
            return '🟠 Attention Required'
        else:
            return '🔴 Critical'

    def _get_rating_color(self, score: float) -> str:
        """Get color for rating (hex)"""
        if score >= 90:
            return '#10b981'
        elif score >= 70:
            return '#22c55e'
        elif score >= 50:
            return '#f59e0b'
        else:
            return '#ef4444'

    def _get_rating_color_rgb(self, score: float) -> str:
        """Get color for rating (matplotlib)"""
        if score >= 90:
            return '#10b981'
        elif score >= 70:
            return '#22c55e'
        elif score >= 50:
            return '#f59e0b'
        else:
            return '#ef4444'

    def _build_budgets_section(self) -> List:
        """Build budgets summary section"""
        elements = []

        budgets = self.building_data.get('budgets', [])
        if not budgets:
            return elements

        elements.append(Paragraph("💰 Budgets", self.styles['SectionHeader']))

        # Detection status summary
        budgets_with_totals = len([b for b in budgets if b.get('total_amount') or b.get('total')])
        
        status_text = f"<b>Budget Documents Identified:</b> {len(budgets)}"
        if budgets_with_totals < len(budgets):
            status_text += f" | ⚠️ {len(budgets) - budgets_with_totals} require total calculation"

        elements.append(Paragraph(status_text, self.styles['BodyText']))
        elements.append(Spacer(1, 0.2*cm))

        # Build table
        table_data = [['Financial Year', 'Total Budget', 'Status', 'Notes']]

        for budget in budgets[:10]:  # Limit to 10
            year_start = budget.get('year_start', '')
            year_end = budget.get('year_end', '')

            if year_start and year_end:
                # Format dates if they're date objects
                try:
                    if isinstance(year_start, str) and '-' in year_start:
                        year_start = datetime.fromisoformat(year_start).strftime('%Y')
                    if isinstance(year_end, str) and '-' in year_end:
                        year_end = datetime.fromisoformat(year_end).strftime('%Y')
                except:
                    pass
                year_display = f"{year_start} - {year_end}"
            else:
                year_display = 'Year not specified'

            total = budget.get('total_amount') or budget.get('total', 0)
            total_display = self._format_currency(total, 'To be calculated')

            status = budget.get('status', 'draft')
            status_display = {
                'draft': '📝 Draft',
                'final': '✅ Final',
                'approved': '✅ Approved'
            }.get(status, status.title())

            notes = budget.get('notes', budget.get('source_document', ''))
            if notes and len(notes) > 50:
                notes = notes[:47] + '...'
            elif not notes:
                notes = '-'

            table_data.append([year_display, total_display, status_display, notes])

        table = Table(table_data, colWidths=[3*cm, 2.5*cm, 2.5*cm, 6*cm])
        table.setStyle(TableStyle([
            ('BACKGROUND', (0, 0), (-1, 0), self.COLOR_HEADER),
            ('TEXTCOLOR', (0, 0), (-1, 0), colors.whitesmoke),
            ('ALIGN', (0, 0), (-1, -1), 'LEFT'),
            ('VALIGN', (0, 0), (-1, -1), 'TOP'),
            ('FONTNAME', (0, 0), (-1, 0), 'Helvetica-Bold'),
            ('FONTSIZE', (0, 0), (-1, 0), 10),
            ('BOTTOMPADDING', (0, 0), (-1, 0), 10),
            ('GRID', (0, 0), (-1, -1), 0.5, colors.grey),
            ('FONTSIZE', (0, 1), (-1, -1), 8),
            ('ROWBACKGROUNDS', (0, 1), (-1, -1), [colors.beige, colors.white])
        ]))

        elements.append(table)
        elements.append(Spacer(1, 0.3*cm))

        return elements

    def _build_apportionments_section(self) -> List:
        """Build apportionments summary section"""
        elements = []

        apportionments = self.building_data.get('apportionments', [])
        if not apportionments:
            return elements

        elements.append(Paragraph("🧮 Apportionments", self.styles['SectionHeader']))

        # Detection status summary
        units_mapped = len([a for a in apportionments if a.get('unit_id')])
        status_text = f"✅ Apportionments mapped: {units_mapped}/{len(apportionments)} units"

        elements.append(Paragraph(status_text, self.styles['BodyText']))
        elements.append(Spacer(1, 0.2*cm))

        # Build table
        table_data = [['Unit', 'Percentage', 'Schedule']]

        # Calculate total
        total_percentage = 0

        for app in apportionments[:20]:  # Limit to 20
            unit_id = app.get('unit_id')
            # TODO: Look up unit name from unit_id
            unit_display = unit_id[:8] if unit_id else 'Unknown'

            percentage = app.get('percentage', 0)
            try:
                pct_value = float(percentage) if percentage else 0
                total_percentage += pct_value
                pct_display = f"{pct_value:.3f}%"
            except (ValueError, TypeError):
                pct_display = str(percentage) if percentage else "0.000%"

            schedule = app.get('schedule_name', 'N/A')

            table_data.append([unit_display, pct_display, schedule])

        # Add total row
        total_status = "✅ Correct" if abs(total_percentage - 100.0) < 0.1 else f"⚠️ {total_percentage:.3f}%"
        table_data.append(['TOTAL', f"{total_percentage:.3f}%", total_status])

        table = Table(table_data, colWidths=[4*cm, 3*cm, 7*cm])
        table.setStyle(TableStyle([
            ('BACKGROUND', (0, 0), (-1, 0), self.COLOR_HEADER),
            ('TEXTCOLOR', (0, 0), (-1, 0), colors.whitesmoke),
            ('ALIGN', (0, 0), (-1, -1), 'LEFT'),
            ('FONTNAME', (0, 0), (-1, 0), 'Helvetica-Bold'),
            ('FONTSIZE', (0, 0), (-1, 0), 10),
            ('BOTTOMPADDING', (0, 0), (-1, 0), 10),
            ('BACKGROUND', (0, 1), (-1, -2), colors.beige),
            ('BACKGROUND', (0, -1), (-1, -1), colors.lightgrey),
            ('FONTNAME', (0, -1), (-1, -1), 'Helvetica-Bold'),
            ('GRID', (0, 0), (-1, -1), 0.5, colors.grey),
            ('FONTSIZE', (0, 1), (-1, -1), 8)
        ]))

        elements.append(table)
        elements.append(Spacer(1, 0.3*cm))

        return elements

    def _build_fire_door_inspections_section(self) -> List:
        """Build fire door inspections section"""
        elements = []

        inspections = self.building_data.get('fire_door_inspections', [])
        if not inspections:
            return elements

        elements.append(Paragraph("🚪 Fire Door Inspections", self.styles['SectionHeader']))

        # Build table
        table_data = [['Location', 'Date', 'Status']]

        for inspection in inspections[:20]:  # Limit to 20
            location = inspection.get('location', 'Unknown')
            inspection_date = inspection.get('inspection_date', 'N/A')
            status = inspection.get('status', 'unknown')

            # Status icon
            status_icon = self.STATUS_ICONS.get(status, self.STATUS_ICONS['unknown'])
            status_display = f"{status_icon} {status.title()}"

            table_data.append([location, inspection_date, status_display])

        table = Table(table_data, colWidths=[6*cm, 3*cm, 5*cm])
        table.setStyle(TableStyle([
            ('BACKGROUND', (0, 0), (-1, 0), self.COLOR_HEADER),
            ('TEXTCOLOR', (0, 0), (-1, 0), colors.whitesmoke),
            ('ALIGN', (0, 0), (-1, -1), 'LEFT'),
            ('FONTNAME', (0, 0), (-1, 0), 'Helvetica-Bold'),
            ('FONTSIZE', (0, 0), (-1, 0), 10),
            ('BOTTOMPADDING', (0, 0), (-1, 0), 10),
            ('BACKGROUND', (0, 1), (-1, -1), colors.beige),
            ('GRID', (0, 0), (-1, -1), 0.5, colors.grey),
            ('FONTSIZE', (0, 1), (-1, -1), 8)
        ]))

        elements.append(table)
        elements.append(Spacer(1, 0.3*cm))

        # Summary stats
        compliant = len([i for i in inspections if i.get('status') == 'compliant'])
        non_compliant = len([i for i in inspections if i.get('status') == 'non-compliant'])

        summary_text = f"Total: {len(inspections)} | Compliant: {compliant} | Non-Compliant: {non_compliant}"
        elements.append(Paragraph(summary_text, self.styles['BodyText']))
        elements.append(Spacer(1, 0.5*cm))

        return elements

    def _build_staffing_section(self) -> List:
        """Build staffing overview section"""
        elements = []

        staff_members = self.building_data.get('building_staff', [])
        if not staff_members:
            return elements

        elements.append(Paragraph("👤 Building Staff", self.styles['SectionHeader']))

        # Build table
        table_data = [['Name', 'Role', 'Hours', 'Contact', 'Company']]

        for staff in staff_members[:20]:  # Limit to 20
            name = staff.get('name', 'Unknown')
            role = staff.get('role', 'staff').title()
            hours = staff.get('hours', 'N/A')
            contact = staff.get('contact_info', 'N/A')
            company = staff.get('company_name', 'N/A')

            # Truncate long fields
            if hours and len(hours) > 30:
                hours = hours[:27] + '...'
            if contact and len(contact) > 25:
                contact = contact[:22] + '...'

            table_data.append([name, role, hours, contact, company])

        table = Table(table_data, colWidths=[3*cm, 2.5*cm, 3*cm, 3*cm, 2.5*cm])
        table.setStyle(TableStyle([
            ('BACKGROUND', (0, 0), (-1, 0), self.COLOR_HEADER),
            ('TEXTCOLOR', (0, 0), (-1, 0), colors.whitesmoke),
            ('ALIGN', (0, 0), (-1, -1), 'LEFT'),
            ('FONTNAME', (0, 0), (-1, 0), 'Helvetica-Bold'),
            ('FONTSIZE', (0, 0), (-1, 0), 10),
            ('BOTTOMPADDING', (0, 0), (-1, 0), 10),
            ('BACKGROUND', (0, 1), (-1, -1), colors.beige),
            ('GRID', (0, 0), (-1, -1), 0.5, colors.grey),
            ('FONTSIZE', (0, 1), (-1, -1), 8)
        ]))

        elements.append(table)
        elements.append(Spacer(1, 0.5*cm))

        return elements

    def _build_lease_summary_section(self) -> List:
        """Build comprehensive lease summary section"""
        elements = []

        leases = self.building_data.get('leases', [])
        if not leases:
            return elements

        elements.append(Paragraph("📜 Lease Summary Report", self.styles['SectionHeader']))
        elements.append(Spacer(1, 0.3*cm))

        # Add generation info
        today = datetime.now().strftime('%d/%m/%Y')
        info_text = f"<b>Generated:</b> {today} | <b>Total Leases:</b> {len(leases)}"
        elements.append(Paragraph(info_text, self.styles['BodyText']))
        elements.append(Spacer(1, 0.4*cm))

        # Process each lease
        for idx, lease in enumerate(leases[:10], 1):  # Limit to 10 leases
            # Extract lease data
            leaseholder = lease.get('leaseholder_name', 'Not identified')
            lessor = lease.get('lessor_name', 'Not identified')
            term_years = lease.get('term_years')
            term_start = lease.get('term_start', 'TBD')
            expiry_date = lease.get('expiry_date', 'Not calculated')
            ground_rent = lease.get('ground_rent')
            rent_review = lease.get('rent_review_period')
            source_doc = lease.get('source_document', 'Unknown')

            # === Executive Summary ===
            elements.append(Paragraph(f"<b>Lease #{idx}: {source_doc}</b>", self.styles['Heading2']))
            elements.append(Spacer(1, 0.2*cm))

            summary_parts = []
            summary_parts.append(f"This lease is between <b>{lessor}</b> (Lessor) and <b>{leaseholder}</b> (Lessee). ")

            if term_years:
                summary_parts.append(f"The lease term is <b>{term_years} years</b> ")
            else:
                summary_parts.append("Lease term not clearly specified ")

            if term_start and term_start != 'TBD':
                summary_parts.append(f"starting from <b>{term_start}</b>. ")
            else:
                summary_parts.append("with start date TBD. ")

            if ground_rent:
                summary_parts.append(f"Ground rent: <b>£{ground_rent:.2f} per annum</b>. ")
            else:
                summary_parts.append("Ground rent terms not clearly stated. ")

            elements.append(Paragraph(''.join(summary_parts), self.styles['BodyText']))
            elements.append(Spacer(1, 0.3*cm))

            # === Basic Property Details Table ===
            elements.append(Paragraph("<b>Basic Property Details</b>", self.styles['Heading3']))
            elements.append(Spacer(1, 0.1*cm))

            details_data = [
                ['Field', 'Value'],
                ['Lessor', lessor],
                ['Lessee', leaseholder],
                ['Lease Term', f"{term_years} years" if term_years else "Not specified"],
                ['Term Start', term_start if term_start != 'TBD' else "Not specified"],
                ['Term End', expiry_date if expiry_date != 'Not calculated' else "Not calculated"],
                ['Ground Rent', f"£{ground_rent:.2f} p.a." if ground_rent else "Not specified"],
                ['Rent Review Period', f"{rent_review} years" if rent_review else "Not specified"]
            ]

            details_table = Table(details_data, colWidths=[5*cm, 9*cm])
            details_table.setStyle(TableStyle([
                ('BACKGROUND', (0, 0), (-1, 0), self.COLOR_HEADER),
                ('TEXTCOLOR', (0, 0), (-1, 0), colors.whitesmoke),
                ('ALIGN', (0, 0), (-1, -1), 'LEFT'),
                ('FONTNAME', (0, 0), (-1, 0), 'Helvetica-Bold'),
                ('FONTSIZE', (0, 0), (-1, 0), 10),
                ('BOTTOMPADDING', (0, 0), (-1, 0), 10),
                ('BACKGROUND', (0, 1), (-1, -1), colors.beige),
                ('GRID', (0, 0), (-1, -1), 0.5, colors.grey),
                ('FONTSIZE', (0, 1), (-1, -1), 8),
                ('VALIGN', (0, 0), (-1, -1), 'TOP')
            ]))

            elements.append(details_table)
            elements.append(Spacer(1, 0.4*cm))

            # === Key Lease Terms ===
            elements.append(Paragraph("<b>Key Lease Terms & Obligations</b>", self.styles['Heading3']))
            elements.append(Spacer(1, 0.1*cm))

            # Standard lease clauses based on frontend lease report structure
            clauses = [
                {
                    'title': 'Repair & Maintenance',
                    'content': 'Tenant responsible for internal repairs and decorations. Landlord responsible for structural repairs and common parts.'
                },
                {
                    'title': 'Service Charge',
                    'content': 'Tenant to pay fair and reasonable proportion of building service costs including insurance, management, repairs, and reserve fund contributions.'
                },
                {
                    'title': 'Alterations & Improvements',
                    'content': 'No structural alterations without Landlord consent. Internal non-structural works may require notification.'
                },
                {
                    'title': 'Subletting & Assignment',
                    'content': 'Assignment permitted with Landlord consent (not to be unreasonably withheld). Subletting typically requires specific consent.'
                },
                {
                    'title': 'Use Restrictions',
                    'content': 'Property to be used as a private residence only. No business use, nuisance, or pets without consent (where applicable).'
                },
                {
                    'title': 'Insurance',
                    'content': 'Landlord insures building. Tenant to reimburse insurance premium as part of service charge. Tenant responsible for contents insurance.'
                }
            ]

            for clause in clauses:
                clause_text = f"<b>{clause['title']}:</b> {clause['content']}"
                elements.append(Paragraph(clause_text, self.styles['BodyText']))
                elements.append(Spacer(1, 0.15*cm))

            elements.append(Spacer(1, 0.3*cm))

            # === Important Notes ===
            notes = lease.get('notes')
            if notes:
                elements.append(Paragraph("<b>Notes:</b>", self.styles['Heading3']))
                elements.append(Paragraph(notes, self.styles['BodyText']))
                elements.append(Spacer(1, 0.3*cm))

            # Separator between leases
            if idx < min(len(leases), 10):
                elements.append(Spacer(1, 0.2*cm))
                # Add a subtle divider line
                line_data = [['', '']]
                line_table = Table(line_data, colWidths=[14*cm])
                line_table.setStyle(TableStyle([
                    ('LINEABOVE', (0, 0), (-1, 0), 1, colors.grey)
                ]))
                elements.append(line_table)
                elements.append(Spacer(1, 0.4*cm))

        # === Disclaimer ===
        elements.append(Spacer(1, 0.5*cm))
        elements.append(Paragraph("<b>Disclaimer</b>", self.styles['Heading2']))
        elements.append(Spacer(1, 0.2*cm))

        disclaimer_text = (
            "This is an AI-assisted lease summary based on automated document analysis. "
            "It is not legal advice and should not be relied upon for legal decisions. "
            "Please consult with a qualified legal professional for definitive interpretation. "
            "Accuracy depends on document quality, legibility, and OCR extraction. "
            "Clauses marked as 'Not explicitly stated' use standard lease covenant assumptions."
        )

        disclaimer_style = ParagraphStyle(
            'Disclaimer',
            parent=self.styles['BodyText'],
            textColor=colors.HexColor('#666666'),
            fontSize=8,
            leading=10
        )

        elements.append(Paragraph(disclaimer_text, disclaimer_style))
        elements.append(Spacer(1, 0.5*cm))

        return elements
