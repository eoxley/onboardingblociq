"""
BlocIQ Building Health Check V3 - Complete Rebuild
Professional, data-driven PDF report generator with real validation
NO placeholders unless data truly doesn't exist
"""

import os
from datetime import datetime, date
from pathlib import Path
from typing import Dict, List, Optional, Tuple
from collections import defaultdict

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


# BlocIQ Brand Colors
class BlocIQBrand:
    PRIMARY = colors.HexColor('#5E48E8')      # Purple
    PRIMARY_LIGHT = colors.HexColor('#8B7AEF')
    PRIMARY_DARK = colors.HexColor('#4A38C7')

    GREY = colors.HexColor('#6C757D')
    GREY_LIGHT = colors.HexColor('#F8F9FA')
    GREY_MEDIUM = colors.HexColor('#E9ECEF')

    SUCCESS = colors.HexColor('#28A745')
    WARNING = colors.HexColor('#F59E0B')
    DANGER = colors.HexColor('#D9534F')
    INFO = colors.HexColor('#17A2B8')

    WHITE = colors.white
    BLACK = colors.HexColor('#212529')


class BuildingHealthScorerV3:
    """
    Comprehensive health scoring algorithm
    Compliance: 40% | Insurance: 20% | Budget: 15% | Lease: 15% | Contractor: 10%
    """

    def __init__(self, data: Dict):
        self.data = data
        self.scores = {}
        self.overall_score = 0.0
        self.details = {}

    def calculate(self) -> Dict:
        """Calculate all scores with detailed breakdown"""

        # PRIORITY 1: Use view-based health_metrics if available
        if 'health_metrics' in self.data and self.data['health_metrics']:
            metrics = self.data['health_metrics']
            self.overall_score = metrics.get('health_score', 0.0)

            self.scores = {
                'overall': self.overall_score,
                'compliance': metrics.get('compliance_score', 0.0),
                'insurance': metrics.get('insurance_score', 0.0),
                'budget': metrics.get('budget_score', 0.0),
                'lease': metrics.get('lease_score', 0.0),
                'contractor': metrics.get('contractor_score', 0.0)
            }

            # Still calculate details for breakdown display
            _, compliance_details = self._score_compliance()
            _, insurance_details = self._score_insurance()
            _, budget_details = self._score_budgets()
            _, lease_details = self._score_leases()
            _, contractor_details = self._score_contractors()

            self.details = {
                'compliance': compliance_details,
                'insurance': insurance_details,
                'budget': budget_details,
                'lease': lease_details,
                'contractor': contractor_details
            }

            return self.scores

        # FALLBACK: Calculate manually if views not available
        # Compliance coverage (40%)
        compliance_score, compliance_details = self._score_compliance()

        # Insurance validity (20%)
        insurance_score, insurance_details = self._score_insurance()

        # Budget completeness (15%)
        budget_score, budget_details = self._score_budgets()

        # Lease data completeness (15%)
        lease_score, lease_details = self._score_leases()

        # Contractor coverage (10%)
        contractor_score, contractor_details = self._score_contractors()

        # Weighted total
        self.overall_score = (
            compliance_score * 0.40 +
            insurance_score * 0.20 +
            budget_score * 0.15 +
            lease_score * 0.15 +
            contractor_score * 0.10
        )

        self.scores = {
            'overall': self.overall_score,
            'compliance': compliance_score,
            'insurance': insurance_score,
            'budget': budget_score,
            'lease': lease_score,
            'contractor': contractor_score
        }

        self.details = {
            'compliance': compliance_details,
            'insurance': insurance_details,
            'budget': budget_details,
            'lease': lease_details,
            'contractor': contractor_details
        }

        return self.scores

    def _score_compliance(self) -> Tuple[float, Dict]:
        """Score compliance assets (% compliant)"""
        compliance = self.data.get('compliance_assets', [])
        if not compliance:
            return 0.0, {'count': 0, 'compliant': 0, 'overdue': 0, 'due_soon': 0, 'unknown': 0}

        compliant = sum(1 for c in compliance if c.get('compliance_status') == 'compliant')
        overdue = sum(1 for c in compliance if c.get('compliance_status') == 'overdue')
        due_soon = sum(1 for c in compliance if c.get('compliance_status') == 'due_soon')
        unknown = sum(1 for c in compliance if c.get('compliance_status') in ['unknown', None])

        score = (compliant / len(compliance)) * 100 if compliance else 0.0

        details = {
            'count': len(compliance),
            'compliant': compliant,
            'overdue': overdue,
            'due_soon': due_soon,
            'unknown': unknown,
            'percentage': score
        }

        return score, details

    def _score_insurance(self) -> Tuple[float, Dict]:
        """Score insurance (% active policies)"""
        insurance = self.data.get('insurance_policies', [])
        if not insurance:
            return 0.0, {'count': 0, 'active': 0, 'expired': 0}

        today = date.today()
        active = 0
        expired = 0

        for policy in insurance:
            expiry = policy.get('expiry_date')
            if expiry:
                try:
                    if isinstance(expiry, str):
                        expiry_date = datetime.fromisoformat(expiry).date()
                    else:
                        expiry_date = expiry

                    if expiry_date >= today:
                        active += 1
                    else:
                        expired += 1
                except:
                    pass

        score = (active / len(insurance)) * 100 if insurance else 0.0

        details = {
            'count': len(insurance),
            'active': active,
            'expired': expired,
            'percentage': score
        }

        return score, details

    def _score_budgets(self) -> Tuple[float, Dict]:
        """Score budgets (completeness)"""
        budgets = self.data.get('budgets', [])
        if not budgets:
            return 0.0, {'count': 0, 'total_value': 0.0}

        total_value = sum(float(b.get('total_amount', 0) or 0) for b in budgets)

        # Score based on presence and variety
        periods = set(b.get('period') for b in budgets if b.get('period'))
        score = min(100.0, (len(budgets) / 10) * 100)  # Full score at 10+ budget items

        details = {
            'count': len(budgets),
            'periods': len(periods),
            'total_value': total_value,
            'percentage': score
        }

        return score, details

    def _score_leases(self) -> Tuple[float, Dict]:
        """Score lease completeness"""
        leases = self.data.get('leases', [])
        units = self.data.get('units', [])

        if not units:
            return 0.0, {'count': 0, 'units': 0, 'coverage': 0.0}

        # Score based on lease coverage and completeness
        coverage = (len(leases) / len(units)) * 100 if units else 0

        # Bonus points for complete lease data
        complete_leases = sum(
            1 for l in leases
            if l.get('term_start') and l.get('term_end') and l.get('leaseholder_name')
        )

        completeness = (complete_leases / len(leases)) * 100 if leases else 0

        # Combined score
        score = (coverage * 0.7 + completeness * 0.3)
        score = min(score, 100.0)

        details = {
            'count': len(leases),
            'units': len(units),
            'coverage': coverage,
            'complete': complete_leases,
            'completeness': completeness,
            'percentage': score
        }

        return score, details

    def _score_contractors(self) -> Tuple[float, Dict]:
        """Score contractor coverage"""
        contractors = self.data.get('building_contractors', []) or self.data.get('contracts', [])
        if not contractors:
            return 0.0, {'count': 0, 'active': 0, 'expired': 0}

        today = date.today()
        active = 0
        expired = 0

        for contractor in contractors:
            end_date = contractor.get('contract_end') or contractor.get('end_date')
            if end_date:
                try:
                    if isinstance(end_date, str):
                        end = datetime.fromisoformat(end_date).date()
                    else:
                        end = end_date

                    if end >= today:
                        active += 1
                    else:
                        expired += 1
                except:
                    active += 1  # Assume active if date parsing fails
            else:
                active += 1  # Assume active if no end date

        # Score based on having multiple active contractors
        score = min(100.0, (active / 5) * 100)  # Full score at 5+ active contractors

        details = {
            'count': len(contractors),
            'active': active,
            'expired': expired,
            'percentage': score
        }

        return score, details

    def get_rating(self) -> Tuple[str, str, colors.Color]:
        """Get text rating, emoji, and color"""
        score = self.overall_score

        if score >= 85:
            return "EXCELLENT", "✅", BlocIQBrand.SUCCESS
        elif score >= 65:
            return "GOOD", "🟢", BlocIQBrand.INFO
        elif score >= 45:
            return "MODERATE", "🟠", BlocIQBrand.WARNING
        elif score >= 25:
            return "REQUIRES ATTENTION", "🔴", BlocIQBrand.DANGER
        else:
            return "CRITICAL", "⚫", BlocIQBrand.BLACK


class BuildingHealthCheckV3:
    """V3 PDF Generator - Complete rebuild with comprehensive data validation"""

    def __init__(self, data: Dict):
        self.data = data
        self.building = data.get('building', {})
        self.scorer = BuildingHealthScorerV3(data)
        self.styles = getSampleStyleSheet()
        self._setup_styles()

    def _setup_styles(self):
        """Setup custom paragraph styles"""
        # Page Title
        self.styles.add(ParagraphStyle(
            name='PageTitle',
            parent=self.styles['Heading1'],
            fontSize=28,
            textColor=BlocIQBrand.PRIMARY,
            spaceAfter=20,
            alignment=TA_CENTER,
            fontName='Helvetica-Bold'
        ))

        # Section Header
        self.styles.add(ParagraphStyle(
            name='SectionHeader',
            parent=self.styles['Heading2'],
            fontSize=16,
            textColor=BlocIQBrand.PRIMARY_DARK,
            spaceAfter=12,
            spaceBefore=20,
            fontName='Helvetica-Bold',
            borderWidth=1,
            borderColor=BlocIQBrand.PRIMARY_LIGHT,
            borderPadding=8,
            backColor=BlocIQBrand.GREY_LIGHT
        ))

        # Subsection
        self.styles.add(ParagraphStyle(
            name='Subsection',
            parent=self.styles['Heading3'],
            fontSize=13,
            textColor=BlocIQBrand.BLACK,
            spaceAfter=8,
            spaceBefore=12,
            fontName='Helvetica-Bold'
        ))

        # Body
        self.styles.add(ParagraphStyle(
            name='Body',
            parent=self.styles['BodyText'],
            fontSize=10,
            leading=14,
            textColor=BlocIQBrand.BLACK
        ))

        # Warning Box
        self.styles.add(ParagraphStyle(
            name='WarningBox',
            parent=self.styles['Normal'],
            fontSize=10,
            textColor=BlocIQBrand.DANGER,
            backColor=colors.HexColor('#FEE2E2'),
            borderWidth=1,
            borderColor=BlocIQBrand.DANGER,
            borderPadding=10,
            spaceAfter=10
        ))

    def generate(self, output_path: str) -> str:
        """Generate the complete PDF report"""
        print("📊 Generating BlocIQ Building Health Check V3...")

        # Calculate scores first
        self.scorer.calculate()
        print(f"   Health Score: {self.scorer.overall_score:.1f}/100")

        # Create PDF document
        doc = SimpleDocTemplate(
            output_path,
            pagesize=letter,
            rightMargin=0.75*inch,
            leftMargin=0.75*inch,
            topMargin=inch,
            bottomMargin=0.75*inch,
            title=f"BlocIQ Health Check - {self.building.get('name', 'Building')}"
        )

        # Build content
        elements = []

        # Cover Page
        elements.extend(self._build_cover_page())
        elements.append(PageBreak())

        # Executive Summary
        elements.extend(self._build_executive_summary())
        elements.append(PageBreak())

        # Building Overview
        elements.extend(self._build_building_overview())
        elements.append(Spacer(1, 0.3*inch))

        # Lease Summary
        elements.extend(self._build_lease_summary())

        # Insurance Summary
        if self.data.get('insurance_policies'):
            elements.append(PageBreak())
            elements.extend(self._build_insurance_summary())

        # Budget Summary
        if self.data.get('budgets'):
            elements.append(PageBreak())
            elements.extend(self._build_budget_summary())

        # Compliance Overview
        if self.data.get('compliance_assets'):
            elements.append(PageBreak())
            elements.extend(self._build_compliance_overview())

        # Contractors
        if self.data.get('building_contractors') or self.data.get('contracts'):
            elements.append(PageBreak())
            elements.extend(self._build_contractors())

        # Major Works
        if self.data.get('major_works_projects'):
            elements.append(PageBreak())
            elements.extend(self._build_major_works())

        # Utilities
        if self.data.get('utilities') or self.data.get('building_utilities'):
            elements.append(PageBreak())
            elements.extend(self._build_utilities_summary())

        # Data Completeness Checklist
        elements.append(PageBreak())
        elements.extend(self._build_completeness_checklist())

        # AI Validation Notes
        elements.append(PageBreak())
        elements.extend(self._build_validation_notes())

        # Generate PDF
        doc.build(elements, onFirstPage=self._add_header_footer, onLaterPages=self._add_header_footer)

        print(f"   ✅ PDF Generated: {output_path}")
        return output_path

    def _add_header_footer(self, canvas_obj, doc):
        """Add header and footer to each page"""
        canvas_obj.saveState()

        # Header
        canvas_obj.setFont('Helvetica-Bold', 10)
        canvas_obj.setFillColor(BlocIQBrand.PRIMARY)
        canvas_obj.drawString(0.75*inch, letter[1] - 0.5*inch, "BlocIQ")

        canvas_obj.setFont('Helvetica', 9)
        canvas_obj.setFillColor(BlocIQBrand.GREY)
        building_name = self.building.get('name', 'Building Health Check')
        canvas_obj.drawRightString(letter[0] - 0.75*inch, letter[1] - 0.5*inch, building_name)

        # Footer
        canvas_obj.setFont('Helvetica', 8)
        page_num = f"Page {doc.page}"
        canvas_obj.drawCentredString(letter[0]/2, 0.5*inch, page_num)
        canvas_obj.setFillColor(BlocIQBrand.GREY)
        canvas_obj.drawCentredString(letter[0]/2, 0.35*inch, "Generated automatically from validated building data. Please verify before submission.")

        canvas_obj.restoreState()

    def _build_cover_page(self) -> List:
        """Build cover page"""
        elements = []

        building_name = self.building.get('name', '—')
        address = self.building.get('address', '—')

        elements.append(Spacer(1, 1.5*inch))

        # Title
        elements.append(Paragraph(
            "BlocIQ Building Health Check",
            self.styles['PageTitle']
        ))

        elements.append(Spacer(1, 0.3*inch))

        # Building Name
        if building_name and building_name != '—':
            elements.append(Paragraph(
                f"<b>{building_name}</b>",
                ParagraphStyle('BuildingTitle', parent=self.styles['Body'], fontSize=20, alignment=TA_CENTER, textColor=BlocIQBrand.PRIMARY_DARK)
            ))

        if address and address != '—':
            elements.append(Paragraph(
                address,
                ParagraphStyle('Address', parent=self.styles['Body'], fontSize=12, alignment=TA_CENTER, textColor=BlocIQBrand.GREY)
            ))

        elements.append(Spacer(1, 0.5*inch))

        # Health Score Box
        rating_text, emoji, rating_color = self.scorer.get_rating()
        score_box = Paragraph(
            f'<para alignment="center" fontSize="18" textColor="{rating_color}">'
            f'<b>Overall Health Score: {self.scorer.overall_score:.1f}/100</b><br/>'
            f'<font size="16">{emoji} {rating_text}</font>'
            '</para>',
            self.styles['Body']
        )
        elements.append(score_box)

        elements.append(Spacer(1, inch))

        # Generation Date
        gen_date = datetime.now().strftime('%d %B %Y at %H:%M')
        elements.append(Paragraph(
            f"Generated: {gen_date}",
            ParagraphStyle('GenDate', parent=self.styles['Body'], fontSize=10, alignment=TA_CENTER, textColor=BlocIQBrand.GREY)
        ))

        return elements

    def _build_executive_summary(self) -> List:
        """Build executive summary with detailed metrics"""
        elements = []

        elements.append(Paragraph("EXECUTIVE SUMMARY", self.styles['SectionHeader']))
        elements.append(Spacer(1, 0.3*inch))

        # Score breakdown table
        score_data = [
            ['CATEGORY', 'WEIGHT', 'SCORE', 'CONTRIBUTION', 'METRIC'],
            [
                'Compliance Coverage',
                '40%',
                f"{self.scorer.scores.get('compliance', 0):.0f}%",
                f"{self.scorer.scores.get('compliance', 0) * 0.40:.1f}",
                f"{self.scorer.details['compliance']['compliant']}/{self.scorer.details['compliance']['count']} compliant"
            ],
            [
                'Insurance Validity',
                '20%',
                f"{self.scorer.scores.get('insurance', 0):.0f}%",
                f"{self.scorer.scores.get('insurance', 0) * 0.20:.1f}",
                f"{self.scorer.details['insurance']['active']}/{self.scorer.details['insurance']['count']} active"
            ],
            [
                'Budget Completeness',
                '15%',
                f"{self.scorer.scores.get('budget', 0):.0f}%",
                f"{self.scorer.scores.get('budget', 0) * 0.15:.1f}",
                f"{self.scorer.details['budget']['count']} budget items"
            ],
            [
                'Lease Records',
                '15%',
                f"{self.scorer.scores.get('lease', 0):.0f}%",
                f"{self.scorer.scores.get('lease', 0) * 0.15:.1f}",
                f"{self.scorer.details['lease']['count']}/{self.scorer.details['lease']['units']} units"
            ],
            [
                'Contractor Coverage',
                '10%',
                f"{self.scorer.scores.get('contractor', 0):.0f}%",
                f"{self.scorer.scores.get('contractor', 0) * 0.10:.1f}",
                f"{self.scorer.details['contractor']['active']} active contracts"
            ],
            [
                '<b>OVERALL SCORE</b>',
                '<b>100%</b>',
                '',
                f"<b>{self.scorer.overall_score:.1f}</b>",
                ''
            ]
        ]

        score_table = Table(score_data, colWidths=[2*inch, 0.8*inch, 0.8*inch, inch, 1.8*inch])
        score_table.setStyle(TableStyle([
            ('BACKGROUND', (0, 0), (-1, 0), BlocIQBrand.PRIMARY),
            ('TEXTCOLOR', (0, 0), (-1, 0), BlocIQBrand.WHITE),
            ('ALIGN', (1, 0), (-1, -1), 'CENTER'),
            ('ALIGN', (0, 0), (0, -1), 'LEFT'),
            ('FONTNAME', (0, 0), (-1, 0), 'Helvetica-Bold'),
            ('FONTSIZE', (0, 0), (-1, -1), 9),
            ('BOTTOMPADDING', (0, 0), (-1, -1), 10),
            ('TOPPADDING', (0, 0), (-1, -1), 10),
            ('GRID', (0, 0), (-1, -2), 0.5, BlocIQBrand.GREY),
            ('LINEABOVE', (0, -1), (-1, -1), 2, BlocIQBrand.PRIMARY),
            ('ROWBACKGROUNDS', (0, 1), (-1, -2), [BlocIQBrand.WHITE, BlocIQBrand.GREY_LIGHT]),
            ('BACKGROUND', (0, -1), (-1, -1), BlocIQBrand.GREY_MEDIUM)
        ]))

        elements.append(score_table)

        return elements

    def _build_building_overview(self) -> List:
        """Build building overview section"""
        elements = []

        elements.append(Paragraph("BUILDING OVERVIEW", self.styles['SectionHeader']))
        elements.append(Spacer(1, 0.2*inch))

        building = self.building
        units = self.data.get('units', [])

        # Use real data or — for missing
        def safe_val(val, default='—'):
            return val if val else default

        overview_data = [
            ['Property Name', safe_val(building.get('name'))],
            ['Address', safe_val(building.get('address'))],
            ['Total Units', str(len(units))],
            ['Managing Agent', safe_val(building.get('managing_agent'))],
            ['Last Updated', datetime.now().strftime('%d %B %Y')]
        ]

        overview_table = Table(overview_data, colWidths=[2*inch, 4*inch])
        overview_table.setStyle(TableStyle([
            ('FONTNAME', (0, 0), (0, -1), 'Helvetica-Bold'),
            ('FONTSIZE', (0, 0), (-1, -1), 10),
            ('BOTTOMPADDING', (0, 0), (-1, -1), 8),
            ('TOPPADDING', (0, 0), (-1, -1), 8),
            ('GRID', (0, 0), (-1, -1), 0.5, colors.lightgrey),
            ('ROWBACKGROUNDS', (0, 0), (-1, -1), [BlocIQBrand.GREY_LIGHT, BlocIQBrand.WHITE])
        ]))

        elements.append(overview_table)

        return elements

    def _build_lease_summary(self) -> List:
        """Build comprehensive lease summary"""
        elements = []

        elements.append(Paragraph("LEASE SUMMARY", self.styles['SectionHeader']))
        elements.append(Spacer(1, 0.2*inch))

        leases = self.data.get('leases', [])
        units = self.data.get('units', [])

        if not leases:
            elements.append(Paragraph(
                "⚠️ No lease data found in migration SQL.",
                self.styles['WarningBox']
            ))
            return elements

        elements.append(Paragraph(
            f"<b>Lease Records:</b> {len(leases)} / {len(units)} units ({(len(leases)/max(len(units), 1))*100:.0f}%)",
            self.styles['Subsection']
        ))
        elements.append(Spacer(1, 0.1*inch))

        # Build lease table
        lease_data = [['Unit', 'Leaseholder', 'Term (Years)', 'Start', 'Expiry']]

        for lease in leases[:20]:  # First 20
            unit = lease.get('unit_name') or lease.get('unit_number') or '—'
            leaseholder = lease.get('leaseholder_name') or '—'
            term_years = lease.get('term_years') or '—'

            start = lease.get('term_start') or lease.get('start_date')
            expiry = lease.get('expiry_date') or lease.get('end_date')

            # Format dates
            start_str = '—'
            if start:
                try:
                    if isinstance(start, str):
                        start_str = datetime.fromisoformat(start).strftime('%d %b %Y')
                    else:
                        start_str = start.strftime('%d %b %Y')
                except:
                    start_str = str(start)[:10]

            expiry_str = '—'
            if expiry:
                try:
                    if isinstance(expiry, str):
                        expiry_str = datetime.fromisoformat(expiry).strftime('%d %b %Y')
                    else:
                        expiry_str = expiry.strftime('%d %b %Y')
                except:
                    expiry_str = str(expiry)[:10]

            lease_data.append([
                str(unit)[:15],
                str(leaseholder)[:25],
                str(term_years),
                start_str,
                expiry_str
            ])

        if len(leases) > 20:
            lease_data.append([f"... and {len(leases) - 20} more", '', '', '', ''])

        lease_table = Table(lease_data, colWidths=[inch, 1.8*inch, inch, 1.2*inch, 1.2*inch])
        lease_table.setStyle(TableStyle([
            ('BACKGROUND', (0, 0), (-1, 0), BlocIQBrand.PRIMARY),
            ('TEXTCOLOR', (0, 0), (-1, 0), BlocIQBrand.WHITE),
            ('FONTNAME', (0, 0), (-1, 0), 'Helvetica-Bold'),
            ('FONTSIZE', (0, 0), (-1, -1), 9),
            ('ALIGN', (0, 0), (-1, -1), 'LEFT'),
            ('BOTTOMPADDING', (0, 0), (-1, -1), 6),
            ('TOPPADDING', (0, 0), (-1, -1), 6),
            ('GRID', (0, 0), (-1, -1), 0.5, colors.lightgrey),
            ('ROWBACKGROUNDS', (0, 1), (-1, -1), [BlocIQBrand.WHITE, BlocIQBrand.GREY_LIGHT])
        ]))

        elements.append(lease_table)

        return elements

    def _build_insurance_summary(self) -> List:
        """Build insurance summary with active/expired breakdown"""
        elements = []

        elements.append(Paragraph("INSURANCE SUMMARY", self.styles['SectionHeader']))
        elements.append(Spacer(1, 0.2*inch))

        insurance = self.data.get('insurance_policies', [])

        if not insurance:
            elements.append(Paragraph("⚠️ No insurance data available.", self.styles['WarningBox']))
            return elements

        active = self.scorer.details['insurance']['active']
        expired = self.scorer.details['insurance']['expired']

        elements.append(Paragraph(
            f"<b>Total Policies:</b> {len(insurance)} | <b>Active:</b> {active} | <b>Expired:</b> {expired}",
            self.styles['Subsection']
        ))
        elements.append(Spacer(1, 0.1*inch))

        # Build insurance table
        ins_data = [['Provider', 'Policy No.', 'Type', 'Expiry', 'Coverage', 'Status']]

        today = date.today()
        for policy in insurance[:15]:  # First 15
            provider = policy.get('provider') or policy.get('insurer_name') or '—'
            policy_no = policy.get('policy_number') or '—'
            ins_type = policy.get('insurance_type') or '—'
            expiry = policy.get('expiry_date')
            coverage = policy.get('sum_insured') or policy.get('coverage_amount')

            # Format expiry
            expiry_str = '—'
            status = '❔ Unknown'
            if expiry:
                try:
                    if isinstance(expiry, str):
                        exp_date = datetime.fromisoformat(expiry).date()
                    else:
                        exp_date = expiry
                    expiry_str = exp_date.strftime('%d %b %Y')
                    status = '✅ Active' if exp_date >= today else '❌ Expired'
                except:
                    pass

            # Format coverage
            coverage_str = f"£{float(coverage):,.0f}" if coverage else '—'

            ins_data.append([
                str(provider)[:18],
                str(policy_no)[:15],
                str(ins_type)[:12],
                expiry_str,
                coverage_str,
                status
            ])

        if len(insurance) > 15:
            ins_data.append([f"... and {len(insurance) - 15} more", '', '', '', '', ''])

        ins_table = Table(ins_data, colWidths=[1.2*inch, 1.1*inch, 1*inch, 1*inch, 1*inch, 0.9*inch])
        ins_table.setStyle(TableStyle([
            ('BACKGROUND', (0, 0), (-1, 0), BlocIQBrand.PRIMARY),
            ('TEXTCOLOR', (0, 0), (-1, 0), BlocIQBrand.WHITE),
            ('FONTNAME', (0, 0), (-1, 0), 'Helvetica-Bold'),
            ('FONTSIZE', (0, 0), (-1, -1), 8),
            ('ALIGN', (0, 0), (-1, -1), 'LEFT'),
            ('ALIGN', (4, 0), (4, -1), 'RIGHT'),
            ('BOTTOMPADDING', (0, 0), (-1, -1), 6),
            ('TOPPADDING', (0, 0), (-1, -1), 6),
            ('GRID', (0, 0), (-1, -1), 0.5, colors.lightgrey),
            ('ROWBACKGROUNDS', (0, 1), (-1, -1), [BlocIQBrand.WHITE, BlocIQBrand.GREY_LIGHT])
        ]))

        elements.append(ins_table)

        return elements

    def _build_budget_summary(self) -> List:
        """Build budget summary with period breakdown"""
        elements = []

        elements.append(Paragraph("BUDGET SUMMARY", self.styles['SectionHeader']))
        elements.append(Spacer(1, 0.2*inch))

        budgets = self.data.get('budgets', [])

        if not budgets:
            elements.append(Paragraph("⚠️ No budget data available.", self.styles['WarningBox']))
            return elements

        total_value = self.scorer.details['budget']['total_value']

        elements.append(Paragraph(
            f"<b>Total Budget Records:</b> {len(budgets)} | <b>Total Value:</b> £{total_value:,.2f}",
            self.styles['Subsection']
        ))
        elements.append(Spacer(1, 0.1*inch))

        # Group by period
        by_period = defaultdict(list)
        for budget in budgets:
            period = budget.get('period', 'Unknown')
            by_period[period].append(budget)

        # Show first 3 periods
        for period, period_budgets in sorted(by_period.items(), reverse=True)[:3]:
            elements.append(Paragraph(
                f"<b>Period: {period}</b>",
                ParagraphStyle('BudgetPeriod', parent=self.styles['Body'], fontSize=11, textColor=BlocIQBrand.PRIMARY_DARK)
            ))
            elements.append(Spacer(1, 0.05*inch))

            budget_data = [['Cost Heading', 'Amount']]

            period_total = 0.0
            for budget in period_budgets[:10]:  # First 10 items
                heading = budget.get('cost_heading') or budget.get('name') or '—'
                amount = budget.get('total_amount')

                amount_val = float(amount) if amount else 0.0
                period_total += amount_val
                amount_str = f"£{amount_val:,.2f}" if amount else '—'

                budget_data.append([
                    str(heading)[:45],
                    amount_str
                ])

            if len(period_budgets) > 10:
                remaining_total = sum(float(b.get('total_amount', 0) or 0) for b in period_budgets[10:])
                budget_data.append([f"... and {len(period_budgets) - 10} more items", f"£{remaining_total:,.2f}"])

            budget_data.append(['<b>Period Total</b>', f"<b>£{period_total:,.2f}</b>"])

            budget_table = Table(budget_data, colWidths=[4*inch, 1.5*inch])
            budget_table.setStyle(TableStyle([
                ('BACKGROUND', (0, 0), (-1, 0), BlocIQBrand.GREY_MEDIUM),
                ('FONTNAME', (0, 0), (-1, 0), 'Helvetica-Bold'),
                ('FONTSIZE', (0, 0), (-1, -1), 9),
                ('ALIGN', (1, 0), (1, -1), 'RIGHT'),
                ('BOTTOMPADDING', (0, 0), (-1, -1), 6),
                ('TOPPADDING', (0, 0), (-1, -1), 6),
                ('GRID', (0, 0), (-1, -1), 0.5, colors.lightgrey),
                ('LINEABOVE', (0, -1), (-1, -1), 1, BlocIQBrand.PRIMARY),
            ]))

            elements.append(budget_table)
            elements.append(Spacer(1, 0.2*inch))

        return elements

    def _build_compliance_overview(self) -> List:
        """Build compliance overview by category"""
        elements = []

        elements.append(Paragraph("COMPLIANCE OVERVIEW", self.styles['SectionHeader']))
        elements.append(Spacer(1, 0.2*inch))

        compliance = self.data.get('compliance_assets', [])

        if not compliance:
            elements.append(Paragraph("⚠️ No compliance data available.", self.styles['WarningBox']))
            return elements

        compliant = self.scorer.details['compliance']['compliant']
        overdue = self.scorer.details['compliance']['overdue']
        due_soon = self.scorer.details['compliance']['due_soon']
        unknown = self.scorer.details['compliance']['unknown']

        elements.append(Paragraph(
            f"<b>Total Assets:</b> {len(compliance)} | "
            f"✅ Compliant: {compliant} | ❌ Overdue: {overdue} | ⚠️  Due Soon: {due_soon} | ❔ Unknown: {unknown}",
            self.styles['Subsection']
        ))
        elements.append(Spacer(1, 0.1*inch))

        # Group by category
        by_category = defaultdict(list)
        for asset in compliance:
            category = asset.get('compliance_category') or asset.get('asset_type') or 'other'
            by_category[category].append(asset)

        # Show each category
        for category, assets in sorted(by_category.items())[:5]:  # First 5 categories
            cat_title = str(category).replace('_', ' ').title()
            elements.append(Paragraph(
                f"<b>{cat_title}</b> ({len(assets)} assets)",
                ParagraphStyle('ComplianceCat', parent=self.styles['Body'], fontSize=11, textColor=BlocIQBrand.INFO)
            ))
            elements.append(Spacer(1, 0.05*inch))

            comp_data = [['Asset Name', 'Last Inspection', 'Next Due', 'Status']]

            for asset in assets[:8]:  # First 8 per category
                name = asset.get('asset_name') or '—'
                last_insp = asset.get('last_inspection_date')
                next_due = asset.get('next_due_date')
                status = asset.get('compliance_status', 'unknown')

                # Format dates
                last_str = '—'
                if last_insp:
                    try:
                        if isinstance(last_insp, str):
                            last_str = datetime.fromisoformat(last_insp).strftime('%d %b %Y')
                        else:
                            last_str = last_insp.strftime('%d %b %Y')
                    except:
                        pass

                next_str = '—'
                if next_due:
                    try:
                        if isinstance(next_due, str):
                            next_str = datetime.fromisoformat(next_due).strftime('%d %b %Y')
                        else:
                            next_str = next_due.strftime('%d %b %Y')
                    except:
                        pass

                # Status icon
                if status == 'compliant':
                    status_icon = '✅ OK'
                elif status == 'overdue':
                    status_icon = '❌ Overdue'
                elif status == 'due_soon':
                    status_icon = '⚠️  Soon'
                else:
                    status_icon = '❔ Unknown'

                comp_data.append([
                    str(name)[:35],
                    last_str,
                    next_str,
                    status_icon
                ])

            if len(assets) > 8:
                comp_data.append([f"... and {len(assets) - 8} more", '', '', ''])

            comp_table = Table(comp_data, colWidths=[2.2*inch, 1.1*inch, 1.1*inch, 0.9*inch])
            comp_table.setStyle(TableStyle([
                ('BACKGROUND', (0, 0), (-1, 0), BlocIQBrand.GREY_MEDIUM),
                ('FONTNAME', (0, 0), (-1, 0), 'Helvetica-Bold'),
                ('FONTSIZE', (0, 0), (-1, -1), 8),
                ('BOTTOMPADDING', (0, 0), (-1, -1), 6),
                ('TOPPADDING', (0, 0), (-1, -1), 6),
                ('GRID', (0, 0), (-1, -1), 0.5, colors.lightgrey),
            ]))

            elements.append(comp_table)
            elements.append(Spacer(1, 0.15*inch))

        return elements

    def _build_contractors(self) -> List:
        """Build contractors section"""
        elements = []

        elements.append(Paragraph("ACTIVE CONTRACTS / CONTRACTORS", self.styles['SectionHeader']))
        elements.append(Spacer(1, 0.2*inch))

        contractors = self.data.get('building_contractors', []) or self.data.get('contracts', [])

        if not contractors:
            elements.append(Paragraph("⚠️ No contractor data available.", self.styles['WarningBox']))
            return elements

        active = self.scorer.details['contractor']['active']
        expired = self.scorer.details['contractor']['expired']

        elements.append(Paragraph(
            f"<b>Total Contracts:</b> {len(contractors)} | <b>Active:</b> {active} | <b>Expired:</b> {expired}",
            self.styles['Subsection']
        ))
        elements.append(Spacer(1, 0.1*inch))

        # Build contracts table
        contract_data = [['Contractor', 'Service Type', 'Contact', 'End Date']]

        for contract in contractors[:15]:  # First 15
            contractor = contract.get('contractor_name') or contract.get('company_name') or '—'
            service = contract.get('service_type') or contract.get('contractor_type') or '—'
            contact = contract.get('contact_person') or '—'
            end_date = contract.get('contract_end') or contract.get('end_date')

            # Format date
            end_str = '—'
            if end_date:
                try:
                    if isinstance(end_date, str):
                        end_str = datetime.fromisoformat(end_date).strftime('%d %b %Y')
                    else:
                        end_str = end_date.strftime('%d %b %Y')
                except:
                    pass

            contract_data.append([
                str(contractor)[:28],
                str(service)[:20],
                str(contact)[:18],
                end_str
            ])

        if len(contractors) > 15:
            contract_data.append([f"... and {len(contractors) - 15} more", '', '', ''])

        contract_table = Table(contract_data, colWidths=[1.8*inch, 1.5*inch, 1.4*inch, 1.1*inch])
        contract_table.setStyle(TableStyle([
            ('BACKGROUND', (0, 0), (-1, 0), BlocIQBrand.PRIMARY),
            ('TEXTCOLOR', (0, 0), (-1, 0), BlocIQBrand.WHITE),
            ('FONTNAME', (0, 0), (-1, 0), 'Helvetica-Bold'),
            ('FONTSIZE', (0, 0), (-1, -1), 9),
            ('BOTTOMPADDING', (0, 0), (-1, -1), 6),
            ('TOPPADDING', (0, 0), (-1, -1), 6),
            ('GRID', (0, 0), (-1, -1), 0.5, colors.lightgrey),
            ('ROWBACKGROUNDS', (0, 1), (-1, -1), [BlocIQBrand.WHITE, BlocIQBrand.GREY_LIGHT])
        ]))

        elements.append(contract_table)

        return elements

    def _build_major_works(self) -> List:
        """Build major works section"""
        elements = []

        elements.append(Paragraph("MAJOR WORKS & PROJECTS", self.styles['SectionHeader']))
        elements.append(Spacer(1, 0.2*inch))

        projects = self.data.get('major_works_projects', [])

        if not projects:
            elements.append(Paragraph("No major works data available.", self.styles['Body']))
            return elements

        elements.append(Paragraph(
            f"<b>Total Projects:</b> {len(projects)}",
            self.styles['Subsection']
        ))
        elements.append(Spacer(1, 0.1*inch))

        # Show each project
        for project in projects[:10]:  # First 10 projects
            title = project.get('title', 'Unnamed Project')
            status = project.get('status', 'unknown')
            start = project.get('start_date')
            end = project.get('end_date')
            budget = project.get('estimated_cost')

            # Format dates
            start_str = '—'
            if start:
                try:
                    if isinstance(start, str):
                        start_str = datetime.fromisoformat(start).strftime('%d %b %Y')
                    else:
                        start_str = start.strftime('%d %b %Y')
                except:
                    pass

            end_str = '—'
            if end:
                try:
                    if isinstance(end, str):
                        end_str = datetime.fromisoformat(end).strftime('%d %b %Y')
                    else:
                        end_str = end.strftime('%d %b %Y')
                except:
                    pass

            budget_str = f"£{float(budget):,.2f}" if budget else 'Not specified'

            elements.append(Paragraph(
                f"<b>{title}</b> - {status.title()}",
                ParagraphStyle('ProjectTitle', parent=self.styles['Body'], fontSize=11, textColor=BlocIQBrand.PRIMARY_DARK)
            ))
            elements.append(Paragraph(
                f"Period: {start_str} to {end_str} | Budget: {budget_str}",
                ParagraphStyle('ProjectDetails', parent=self.styles['Body'], fontSize=9, textColor=BlocIQBrand.GREY)
            ))
            elements.append(Spacer(1, 0.15*inch))

        return elements

    def _build_utilities_summary(self) -> List:
        """Build utilities summary with providers, accounts, and meter numbers"""
        elements = []

        elements.append(Paragraph("UTILITIES & SERVICES", self.styles['SectionHeader']))
        elements.append(Spacer(1, 0.2*inch))

        # Get utilities from both possible sources
        utilities = self.data.get('utilities', []) or self.data.get('building_utilities', [])

        if not utilities:
            elements.append(Paragraph("⚠️ No utility data available.", self.styles['WarningBox']))
            return elements

        elements.append(Paragraph(
            f"<b>Total Utility Accounts:</b> {len(utilities)}",
            self.styles['Subsection']
        ))
        elements.append(Spacer(1, 0.1*inch))

        # Group by utility type
        by_type = defaultdict(list)
        for utility in utilities:
            util_type = utility.get('utility_type') or 'other'
            by_type[util_type].append(utility)

        # Show each utility type
        for util_type, type_utilities in sorted(by_type.items()):
            type_title = str(util_type).replace('_', ' ').title()
            elements.append(Paragraph(
                f"<b>{type_title}</b> ({len(type_utilities)} account{'' if len(type_utilities) == 1 else 's'})",
                ParagraphStyle('UtilityType', parent=self.styles['Body'], fontSize=11, textColor=BlocIQBrand.INFO)
            ))
            elements.append(Spacer(1, 0.05*inch))

            util_data = [['Provider', 'Account Number', 'Meter/MPAN', 'Contract Status']]

            for utility in type_utilities[:10]:  # First 10 per type
                provider = utility.get('supplier') or utility.get('provider_name') or '—'
                account = utility.get('account_number') or '—'

                # Get meter number or MPAN/MPRN
                meter = utility.get('meter_numbers') or utility.get('mpan') or utility.get('mprn') or '—'

                # Contract status
                status = utility.get('contract_status', 'unknown')
                if status == 'active':
                    status_icon = '✅ Active'
                elif status == 'expired':
                    status_icon = '❌ Expired'
                else:
                    status_icon = '❔ Unknown'

                util_data.append([
                    str(provider)[:25],
                    str(account)[:20],
                    str(meter)[:18],
                    status_icon
                ])

            if len(type_utilities) > 10:
                util_data.append([f"... and {len(type_utilities) - 10} more", '', '', ''])

            util_table = Table(util_data, colWidths=[1.5*inch, 1.5*inch, 1.5*inch, 1*inch])
            util_table.setStyle(TableStyle([
                ('BACKGROUND', (0, 0), (-1, 0), BlocIQBrand.GREY_MEDIUM),
                ('FONTNAME', (0, 0), (-1, 0), 'Helvetica-Bold'),
                ('FONTSIZE', (0, 0), (-1, -1), 8),
                ('BOTTOMPADDING', (0, 0), (-1, -1), 6),
                ('TOPPADDING', (0, 0), (-1, -1), 6),
                ('GRID', (0, 0), (-1, -1), 0.5, colors.lightgrey),
                ('ROWBACKGROUNDS', (0, 1), (-1, -1), [BlocIQBrand.WHITE, BlocIQBrand.GREY_LIGHT])
            ]))

            elements.append(util_table)
            elements.append(Spacer(1, 0.15*inch))

        # Add helpful notes about important utilities
        elements.append(Paragraph(
            "<b>Important Notes:</b>",
            ParagraphStyle('UtilityNotes', parent=self.styles['Body'], fontSize=10, textColor=BlocIQBrand.PRIMARY_DARK)
        ))
        elements.append(Spacer(1, 0.05*inch))

        notes = [
            "• MPAN (Meter Point Administration Number) - 13-digit electricity meter identifier",
            "• MPRN (Meter Point Reference Number) - 6-10 digit gas meter identifier",
            "• Ensure all utility accounts are up to date before property transfer",
            "• Check meter readings are recent and accurate",
            "• Verify lift line phone contracts are active (required for lift alarms)"
        ]

        for note in notes:
            elements.append(Paragraph(
                note,
                ParagraphStyle('UtilityNote', parent=self.styles['Body'], fontSize=8, textColor=BlocIQBrand.GREY)
            ))

        return elements

    def _build_completeness_checklist(self) -> List:
        """Build data completeness checklist showing what's present vs missing"""
        elements = []

        elements.append(Paragraph("DATA COMPLETENESS CHECKLIST", self.styles['SectionHeader']))
        elements.append(Spacer(1, 0.2*inch))

        elements.append(Paragraph(
            "The following checklist shows which data categories were successfully extracted from the provided documents:",
            self.styles['Body']
        ))
        elements.append(Spacer(1, 0.15*inch))

        # Define all categories we check for
        checklist_data = [
            ['Category', 'Status', 'Records', 'Notes'],
        ]

        # Building Information
        building = self.data.get('building', {})
        building_complete = building.get('name') and building.get('address')
        checklist_data.append([
            'Building Details',
            '✓ Present' if building_complete else '— Missing',
            f"{1 if building_complete else 0}/1",
            'Name, address, unit count'
        ])

        # Units & Leaseholders
        units = self.data.get('units', [])
        leaseholders = self.data.get('leaseholders', [])
        checklist_data.append([
            'Units & Leaseholders',
            '✓ Present' if (units and leaseholders) else '⚠ Partial' if (units or leaseholders) else '— Missing',
            f"{len(units)} units, {len(leaseholders)} leaseholders",
            'Contact details, unit assignments'
        ])

        # Leases
        leases = self.data.get('leases', [])
        lease_coverage = (len(leases) / len(units) * 100) if units else 0
        checklist_data.append([
            'Lease Documents',
            '✓ Present' if leases else '— Missing',
            f"{len(leases)} leases ({lease_coverage:.0f}% coverage)",
            'Terms, ground rent, service charges'
        ])

        # Financial - Budgets
        budgets = self.data.get('budgets', [])
        checklist_data.append([
            'Budgets & Service Charges',
            '✓ Present' if budgets else '— Missing',
            f"{len(budgets)} budget periods",
            'Annual budgets, demand dates'
        ])

        # Financial - Accounts
        bank_details = building.get('bank_account') or building.get('sort_code')
        checklist_data.append([
            'Bank Account Details',
            '✓ Present' if bank_details else '— Missing',
            '—',
            'Account numbers, sort codes'
        ])

        # Insurance
        insurance = self.data.get('insurance_policies', [])
        checklist_data.append([
            'Insurance Policies',
            '✓ Present' if insurance else '— Missing',
            f"{len(insurance)} policies",
            'Buildings, terrorism, liability'
        ])

        # Compliance
        compliance = self.data.get('compliance_assets', [])
        compliance_types = len(set(c.get('asset_type') for c in compliance if c.get('asset_type')))
        checklist_data.append([
            'Compliance Certificates',
            '✓ Present' if compliance else '— Missing',
            f"{len(compliance)} assets ({compliance_types} types)",
            'FRA, EICR, gas safety, legionella'
        ])

        # Contractors
        contractors = self.data.get('building_contractors', []) or self.data.get('contracts', [])
        checklist_data.append([
            'Contractors & Contracts',
            '✓ Present' if contractors else '— Missing',
            f"{len(contractors)} contractors",
            'Service contracts, contact details'
        ])

        # Major Works
        major_works = self.data.get('major_works_projects', [])
        checklist_data.append([
            'Major Works & Section 20',
            '✓ Present' if major_works else '— Missing',
            f"{len(major_works)} projects",
            'Ongoing, planned, completed works'
        ])

        # Utilities
        utilities = self.data.get('utilities', [])
        checklist_data.append([
            'Utilities',
            '✓ Present' if utilities else '— Missing',
            f"{len(utilities)} accounts",
            'Providers, meter numbers, MPAN'
        ])

        # Legal
        legal = self.data.get('building_legal', [])
        checklist_data.append([
            'Legal / Disputes',
            '✓ Present' if legal else '— Missing',
            f"{len(legal)} records",
            'Lease disputes, litigation'
        ])

        # Title Deeds
        title_deeds = self.data.get('building_title_deeds', [])
        checklist_data.append([
            'Title Deeds & Plans',
            '✓ Present' if title_deeds else '— Missing',
            f"{len(title_deeds)} documents",
            'Freehold title, building plans'
        ])

        # Company Secretary
        company_sec = self.data.get('company_secretary', [])
        checklist_data.append([
            'Company Secretary',
            '✓ Present' if company_sec else '— Missing',
            f"{len(company_sec)} records",
            'Companies House, memorandum'
        ])

        # Staff
        staff = self.data.get('building_staff', [])
        checklist_data.append([
            'Staff Records',
            '✓ Present' if staff else '— Missing',
            f"{len(staff)} employees",
            'Contracts, PAYE, pensions'
        ])

        # Warranties
        warranties = self.data.get('building_warranties', [])
        checklist_data.append([
            'Warranties & Guarantees',
            '✓ Present' if warranties else '— Missing',
            f"{len(warranties)} warranties",
            'Boilers, pumps, roofing'
        ])

        # Access Codes
        access = self.data.get('building_keys_access', [])
        checklist_data.append([
            'Access Codes & Keys',
            '✓ Present' if access else '— Missing',
            f"{len(access)} items",
            'Gate codes, entrance codes, keys'
        ])

        # Create table
        table = Table(checklist_data, colWidths=[2*inch, 1*inch, 1.2*inch, 2*inch])
        table.setStyle(TableStyle([
            ('BACKGROUND', (0, 0), (-1, 0), BlocIQBrand.PRIMARY),
            ('TEXTCOLOR', (0, 0), (-1, 0), BlocIQBrand.WHITE),
            ('FONTNAME', (0, 0), (-1, 0), 'Helvetica-Bold'),
            ('FONTSIZE', (0, 0), (-1, -1), 8),
            ('ALIGN', (0, 0), (-1, -1), 'LEFT'),
            ('BOTTOMPADDING', (0, 0), (-1, -1), 6),
            ('TOPPADDING', (0, 0), (-1, -1), 6),
            ('GRID', (0, 0), (-1, -1), 0.5, colors.lightgrey),
            ('ROWBACKGROUNDS', (0, 1), (-1, -1), [BlocIQBrand.WHITE, BlocIQBrand.GREY_LIGHT])
        ]))

        elements.append(table)
        elements.append(Spacer(1, 0.2*inch))

        # Summary stats
        total_categories = len(checklist_data) - 1  # Exclude header
        present_categories = sum(1 for row in checklist_data[1:] if row[1].startswith('✓'))
        partial_categories = sum(1 for row in checklist_data[1:] if row[1].startswith('⚠'))
        missing_categories = sum(1 for row in checklist_data[1:] if row[1].startswith('—'))

        completeness_pct = (present_categories / total_categories * 100) if total_categories > 0 else 0

        elements.append(Paragraph(
            f"<b>Completeness Summary:</b> {present_categories} present | "
            f"{partial_categories} partial | {missing_categories} missing | "
            f"<b>Overall: {completeness_pct:.0f}% complete</b>",
            ParagraphStyle('CompletenessSummary', parent=self.styles['Body'], fontSize=10, textColor=BlocIQBrand.PRIMARY_DARK)
        ))

        return elements

    def _build_validation_notes(self) -> List:
        """Build AI validation and data quality notes"""
        elements = []

        elements.append(Paragraph("AI VALIDATION NOTES", self.styles['SectionHeader']))
        elements.append(Spacer(1, 0.2*inch))

        findings = []

        # Check for missing lease data
        leases = self.data.get('leases', [])
        units = self.data.get('units', [])
        if len(units) > 0 and len(leases) == 0:
            findings.append("❌ No lease records found despite units being present")
        elif len(leases) < len(units):
            findings.append(f"⚠️  Only {len(leases)}/{len(units)} units have lease records ({(len(leases)/len(units))*100:.0f}%)")

        # Check for expired insurance
        expired_insurance = self.scorer.details['insurance']['expired']
        if expired_insurance > 0:
            findings.append(f"❌ {expired_insurance} expired insurance policies require renewal")

        # Check for overdue compliance
        overdue_compliance = self.scorer.details['compliance']['overdue']
        if overdue_compliance > 0:
            findings.append(f"❌ {overdue_compliance} compliance assets are overdue for inspection")

        # Check for incomplete lease data
        incomplete_leases = [l for l in leases if not l.get('term_start') or not l.get('leaseholder_name')]
        if incomplete_leases:
            findings.append(f"⚠️  {len(incomplete_leases)} leases missing term start or leaseholder details")

        # Check for missing budget data
        budgets = self.data.get('budgets', [])
        if not budgets:
            findings.append("⚠️  No budget data imported - financial planning information unavailable")

        # Data provenance
        elements.append(Paragraph(
            "<b>Data Provenance:</b> This report was generated automatically from validated building data migration. "
            "All information is extracted from documents uploaded to BlocIQ and processed using AI/ML models.",
            self.styles['Body']
        ))
        elements.append(Spacer(1, 0.2*inch))

        # Findings
        if findings:
            elements.append(Paragraph("<b>Key Findings:</b>", self.styles['Subsection']))
            elements.append(Spacer(1, 0.1*inch))

            for finding in findings:
                elements.append(Paragraph(f"• {finding}", self.styles['Body']))
                elements.append(Spacer(1, 0.05*inch))
        else:
            elements.append(Paragraph(
                "✅ All data appears complete and up to date",
                ParagraphStyle('Success', parent=self.styles['Body'], textColor=BlocIQBrand.SUCCESS)
            ))

        return elements


def generate_health_check_v3(building_data: Dict, output_path: str) -> str:
    """
    Generate Building Health Check V3 PDF

    Args:
        building_data: Structured building data dict
        output_path: Path where PDF should be saved

    Returns:
        Path to generated PDF
    """
    generator = BuildingHealthCheckV3(building_data)
    return generator.generate(output_path)
