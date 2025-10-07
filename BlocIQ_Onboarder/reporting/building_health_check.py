"""
BlocIQ Onboarder - Building Health Check Report Generator
AI-driven PDF report with analytics, risk assessment, and recommendations
"""

import os
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

# Matplotlib for charts
import matplotlib
matplotlib.use('Agg')  # Non-interactive backend
import matplotlib.pyplot as plt
from matplotlib.patches import Wedge
import numpy as np


class BuildingHealthCheckGenerator:
    """Generates comprehensive Building Health Check PDF reports"""

    def __init__(self, supabase_client=None):
        """
        Initialize report generator

        Args:
            supabase_client: Supabase client instance (optional)
        """
        self.supabase = supabase_client
        self.building_data = {}
        self.health_score = 0
        self.recommendations = []

        # Report styling
        self.styles = getSampleStyleSheet()
        self._setup_custom_styles()

        # Colors
        self.COLOR_EXCELLENT = colors.HexColor('#10b981')  # Green
        self.COLOR_GOOD = colors.HexColor('#22c55e')
        self.COLOR_ATTENTION = colors.HexColor('#f59e0b')  # Amber
        self.COLOR_CRITICAL = colors.HexColor('#ef4444')  # Red
        self.COLOR_HEADER = colors.HexColor('#1e40af')  # Blue

    def _setup_custom_styles(self):
        """Setup custom paragraph styles"""
        # Title style
        self.styles.add(ParagraphStyle(
            name='CustomTitle',
            parent=self.styles['Heading1'],
            fontSize=24,
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

        # Body text
        self.styles.add(ParagraphStyle(
            name='BodyText',
            parent=self.styles['BodyText'],
            fontSize=10,
            leading=14,
            alignment=TA_JUSTIFY
        ))

        # Warning text
        self.styles.add(ParagraphStyle(
            name='Warning',
            parent=self.styles['BodyText'],
            fontSize=10,
            textColor=self.COLOR_CRITICAL,
            leftIndent=20
        ))

    def generate_report(self, building_id: str, output_dir: str = 'reports') -> str:
        """
        Generate Building Health Check PDF report

        Args:
            building_id: UUID of building
            output_dir: Output directory for PDF

        Returns:
            Path to generated PDF
        """
        print(f"\n📊 Generating Building Health Check Report...")
        print(f"   Building ID: {building_id}")

        # Ensure output directory exists
        output_path = Path(output_dir)
        output_path.mkdir(exist_ok=True, parents=True)

        # Gather all data
        self.building_data = self._gather_building_data(building_id)

        if not self.building_data.get('building'):
            print("   ⚠️  No building data found")
            return None

        # Calculate health score
        self.health_score = self._calculate_health_score()

        # Generate recommendations
        self.recommendations = self._generate_recommendations()

        # Create PDF
        pdf_filename = f"{building_id}_Building_Health_Check.pdf"
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
        story.extend(self._build_health_score_section())
        story.append(PageBreak())
        story.extend(self._build_compliance_section())
        story.extend(self._build_insurance_section())
        story.append(PageBreak())
        story.extend(self._build_contracts_section())
        story.extend(self._build_utilities_section())
        story.extend(self._build_financial_section())
        story.append(PageBreak())
        story.extend(self._build_meetings_section())
        story.extend(self._build_recommendations_section())

        # Build PDF
        doc.build(story)

        print(f"   ✅ Report generated: {pdf_path}")
        return str(pdf_path)

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
            'units_count': self._query_units_count(building_id)
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

    def _calculate_health_score(self) -> float:
        """
        Calculate overall building health score (0-100)

        Component weights:
        - Compliance: 30%
        - Insurance: 25%
        - Contracts: 15%
        - Finance: 15%
        - Utilities: 10%
        - Meetings: 5%
        """
        scores = {}

        # Compliance score (30%)
        scores['compliance'] = self._score_compliance() * 0.30

        # Insurance score (25%)
        scores['insurance'] = self._score_insurance() * 0.25

        # Contracts score (15%)
        scores['contracts'] = self._score_contracts() * 0.15

        # Finance score (15%)
        scores['finance'] = self._score_finance() * 0.15

        # Utilities score (10%)
        scores['utilities'] = self._score_utilities() * 0.10

        # Meetings score (5%)
        scores['meetings'] = self._score_meetings() * 0.05

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

    def _score_contracts(self) -> float:
        """Score contracts health (0-100)"""
        contracts = self.building_data.get('contracts', [])
        if not contracts:
            return 60.0  # Moderate score if no contracts data

        active = sum(1 for c in contracts if c.get('contract_status') == 'active')
        total = len(contracts)

        if total == 0:
            return 60.0

        return (active / total) * 100

    def _score_finance(self) -> float:
        """Score financial health (0-100)"""
        snapshots = self.building_data.get('client_money', [])
        if not snapshots:
            return 70.0  # Moderate score if no data

        snapshot = snapshots[0]
        balance = snapshot.get('balance', 0) or 0
        arrears = snapshot.get('arrears_total', 0) or 0

        if balance == 0:
            return 50.0

        # Score based on arrears ratio
        arrears_ratio = arrears / balance if balance > 0 else 0
        score = 100 - (arrears_ratio * 100)

        return max(0, min(100, score))

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
        """Build report header"""
        elements = []

        building = self.building_data.get('building', {})
        building_name = building.get('name', 'Unknown Building')

        # Title
        title = Paragraph("Building Health Check Report", self.styles['CustomTitle'])
        elements.append(title)
        elements.append(Spacer(1, 0.3*inch))

        # Building info
        building_info = f"""
        <b>Building:</b> {building_name}<br/>
        <b>Address:</b> {building.get('address', 'N/A')}<br/>
        <b>Report Date:</b> {datetime.now().strftime('%d %B %Y')}<br/>
        <b>Prepared by:</b> BlocIQ Onboarder (Automated)
        """
        elements.append(Paragraph(building_info, self.styles['BodyText']))
        elements.append(Spacer(1, 0.5*inch))

        return elements

    def _build_overview(self) -> List:
        """Build overview section"""
        elements = []

        elements.append(Paragraph("Executive Summary", self.styles['SectionHeader']))

        # Stats table
        building = self.building_data.get('building', {})
        stats_data = [
            ['Metric', 'Count'],
            ['Units', str(self.building_data.get('units_count', 0))],
            ['Compliance Assets', str(len(self.building_data.get('compliance_assets', [])))],
            ['Insurance Policies', str(len(self.building_data.get('insurance_policies', [])))],
            ['Active Contracts', str(len([c for c in self.building_data.get('contracts', []) if c.get('contract_status') == 'active']))],
            ['Utility Accounts', str(len(self.building_data.get('utilities', [])))]
        ]

        stats_table = Table(stats_data, colWidths=[3*inch, 2*inch])
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
            elements.append(Paragraph("No compliance data available.", self.styles['BodyText']))
            return elements

        # Summary stats
        compliant = sum(1 for a in assets if a.get('compliance_status') == 'compliant')
        overdue = sum(1 for a in assets if a.get('compliance_status') == 'overdue')
        due_soon = sum(1 for a in assets if a.get('compliance_status') == 'due_soon')

        summary = f"""
        <b>Total Assets:</b> {len(assets)}<br/>
        <b><font color="green">Compliant:</font></b> {compliant} ({compliant/len(assets)*100:.0f}%)<br/>
        <b><font color="red">Overdue:</font></b> {overdue}<br/>
        <b><font color="orange">Due Soon:</font></b> {due_soon}
        """
        elements.append(Paragraph(summary, self.styles['BodyText']))
        elements.append(Spacer(1, 0.2*inch))

        # Table of assets
        table_data = [['Asset', 'Last Inspection', 'Next Due', 'Contractor', 'Status']]

        for asset in assets[:10]:  # First 10
            status = asset.get('compliance_status', 'unknown')
            status_color = {
                'compliant': 'green',
                'due_soon': 'orange',
                'overdue': 'red',
                'unknown': 'gray'
            }.get(status, 'black')

            table_data.append([
                asset.get('asset_name', 'N/A')[:30],
                asset.get('inspection_date', 'N/A'),
                asset.get('reinspection_date', 'N/A'),
                asset.get('inspection_contractor', 'N/A')[:20],
                f'<font color="{status_color}">{status.upper()}</font>'
            ])

        compliance_table = Table(table_data, colWidths=[2*inch, 1*inch, 1*inch, 1.5*inch, 1*inch])
        compliance_table.setStyle(TableStyle([
            ('BACKGROUND', (0, 0), (-1, 0), self.COLOR_HEADER),
            ('TEXTCOLOR', (0, 0), (-1, 0), colors.whitesmoke),
            ('ALIGN', (0, 0), (-1, -1), 'LEFT'),
            ('FONTNAME', (0, 0), (-1, 0), 'Helvetica-Bold'),
            ('FONTSIZE', (0, 0), (-1, -1), 8),
            ('BOTTOMPADDING', (0, 0), (-1, 0), 12),
            ('GRID', (0, 0), (-1, -1), 1, colors.black)
        ]))

        elements.append(compliance_table)
        elements.append(Spacer(1, 0.3*inch))

        return elements

    def _build_insurance_section(self) -> List:
        """Build insurance section"""
        elements = []

        elements.append(Paragraph("🛡️ Insurance Coverage", self.styles['SectionHeader']))

        policies = self.building_data.get('insurance_policies', [])

        if not policies:
            elements.append(Paragraph("No insurance data available.", self.styles['BodyText']))
            return elements

        # Policy table
        table_data = [['Insurer', 'Policy No.', 'Cover Type', 'Sum Insured', 'Expires', 'Status']]

        today = datetime.now().date()

        for policy in policies:
            sum_insured = policy.get('sum_insured', 0) or 0
            end_date_str = policy.get('end_date')

            status = '✅ Active'
            status_color = 'green'

            if end_date_str:
                try:
                    end_date = datetime.fromisoformat(end_date_str).date() if isinstance(end_date_str, str) else end_date_str
                    days_until = (end_date - today).days

                    if days_until < 0:
                        status = '🔴 Expired'
                        status_color = 'red'
                    elif days_until < 30:
                        status = f'🟠 {days_until}d'
                        status_color = 'orange'
                except:
                    pass

            table_data.append([
                policy.get('insurer', 'N/A')[:20],
                policy.get('policy_number', 'N/A')[:15],
                policy.get('cover_type', 'N/A')[:15],
                f"£{sum_insured:,.0f}" if sum_insured else 'N/A',
                end_date_str or 'N/A',
                f'<font color="{status_color}">{status}</font>'
            ])

        insurance_table = Table(table_data, colWidths=[1.5*inch, 1.2*inch, 1*inch, 1*inch, 1*inch, 1*inch])
        insurance_table.setStyle(TableStyle([
            ('BACKGROUND', (0, 0), (-1, 0), self.COLOR_HEADER),
            ('TEXTCOLOR', (0, 0), (-1, 0), colors.whitesmoke),
            ('ALIGN', (0, 0), (-1, -1), 'LEFT'),
            ('FONTNAME', (0, 0), (-1, 0), 'Helvetica-Bold'),
            ('FONTSIZE', (0, 0), (-1, -1), 8),
            ('BOTTOMPADDING', (0, 0), (-1, 0), 12),
            ('GRID', (0, 0), (-1, -1), 1, colors.black)
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
        """Build recommendations section"""
        elements = []

        elements.append(Paragraph("💡 Recommendations & Action Items", self.styles['SectionHeader']))

        if not self.recommendations:
            elements.append(Paragraph("No specific recommendations at this time.", self.styles['BodyText']))
            return elements

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
