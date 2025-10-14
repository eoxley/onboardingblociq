#!/usr/bin/env python3
"""
BlocIQ PDF Report Generator
============================
Generates professional client-facing PDF reports using ReportLab.

Features:
- Executive summary
- Building overview with charts
- Leaseholder summary
- Compliance dashboard
- Contract register
- Financial summary
- Professional corporate styling

Author: BlocIQ Team
Date: 2025-10-14
"""

import json
from pathlib import Path
from datetime import datetime
from typing import Dict, List

from reportlab.lib import colors
from reportlab.lib.pagesizes import A4, letter
from reportlab.lib.styles import getSampleStyleSheet, ParagraphStyle
from reportlab.lib.units import inch, cm
from reportlab.platypus import (
    SimpleDocTemplate, Table, TableStyle, Paragraph, Spacer,
    PageBreak, Image, KeepTogether, Frame, PageTemplate
)
from reportlab.platypus.flowables import HRFlowable
from reportlab.lib.enums import TA_CENTER, TA_RIGHT, TA_LEFT, TA_JUSTIFY
from reportlab.graphics.shapes import Drawing, Rect, Circle
from reportlab.graphics.charts.piecharts import Pie
from reportlab.graphics.charts.barcharts import VerticalBarChart


class PDFReportGenerator:
    """Generate professional PDF reports"""

    # Color scheme
    COLOR_PRIMARY = colors.HexColor('#0066cc')
    COLOR_SUCCESS = colors.HexColor('#28a745')
    COLOR_WARNING = colors.HexColor('#ffc107')
    COLOR_DANGER = colors.HexColor('#dc3545')
    COLOR_GREY = colors.HexColor('#6c757d')
    COLOR_LIGHT_GREY = colors.HexColor('#f8f9fa')

    def __init__(self):
        self.styles = getSampleStyleSheet()
        self._setup_custom_styles()

    def _setup_custom_styles(self):
        """Setup custom paragraph styles"""
        # Title style
        self.styles.add(ParagraphStyle(
            name='CustomTitle',
            parent=self.styles['Heading1'],
            fontSize=32,
            textColor=self.COLOR_PRIMARY,
            spaceAfter=30,
            alignment=TA_CENTER,
            fontName='Helvetica-Bold'
        ))

        # Section Header
        self.styles.add(ParagraphStyle(
            name='SectionHeader',
            parent=self.styles['Heading2'],
            fontSize=16,
            textColor=self.COLOR_PRIMARY,
            spaceBefore=20,
            spaceAfter=12,
            borderWidth=2,
            borderColor=self.COLOR_PRIMARY,
            borderPadding=5,
            fontName='Helvetica-Bold'
        ))

        # Subsection
        self.styles.add(ParagraphStyle(
            name='SubsectionHeader',
            parent=self.styles['Heading3'],
            fontSize=12,
            textColor=self.COLOR_PRIMARY,
            spaceBefore=12,
            spaceAfter=6,
            fontName='Helvetica-Bold'
        ))

        # Alert styles
        for alert_type, color in [('Success', self.COLOR_SUCCESS), ('Warning', self.COLOR_WARNING), ('Danger', self.COLOR_DANGER), ('Info', self.COLOR_PRIMARY)]:
            self.styles.add(ParagraphStyle(
                name=f'Alert{alert_type}',
                parent=self.styles['Normal'],
                fontSize=10,
                textColor=colors.black,
                backColor=color.clone(alpha=0.1),
                borderWidth=1,
                borderColor=color,
                borderPadding=10,
                spaceBefore=10,
                spaceAfter=10
            ))

    def generate_pdf(self, data: Dict, output_file: str) -> str:
        """
        Generate PDF report

        Args:
            data: Extracted building data (from JSON)
            output_file: Path to output PDF file

        Returns:
            Path to generated PDF
        """
        print(f"\n🔄 Generating PDF report...")

        doc = SimpleDocTemplate(
            output_file,
            pagesize=A4,
            rightMargin=2*cm,
            leftMargin=2*cm,
            topMargin=2*cm,
            bottomMargin=2*cm
        )

        # Build story (content)
        story = []

        # Cover page
        story.extend(self._create_cover_page(data))
        story.append(PageBreak())

        # Executive Summary
        story.append(Paragraph("Executive Summary", self.styles['SectionHeader']))
        story.extend(self._create_executive_summary(data))
        story.append(Spacer(1, 0.5*cm))

        # Building Overview
        story.append(Paragraph("Building Overview", self.styles['SectionHeader']))
        story.extend(self._create_building_overview(data))
        story.append(PageBreak())

        # Leaseholder Summary
        story.append(Paragraph("Leaseholder Summary", self.styles['SectionHeader']))
        story.extend(self._create_leaseholder_summary(data))
        story.append(Spacer(1, 0.5*cm))

        # Compliance Dashboard
        story.append(Paragraph("Compliance Dashboard", self.styles['SectionHeader']))
        story.extend(self._create_compliance_dashboard(data))
        story.append(PageBreak())

        # Contract Register
        story.append(Paragraph("Maintenance Contracts", self.styles['SectionHeader']))
        story.extend(self._create_contract_register(data))
        story.append(Spacer(1, 0.5*cm))

        # Financial Summary
        story.append(Paragraph("Financial Summary", self.styles['SectionHeader']))
        story.extend(self._create_financial_summary(data))

        # Build PDF
        doc.build(story)

        print(f"✅ PDF generated: {output_file}")
        return output_file

    def _create_cover_page(self, data: Dict) -> List:
        """Create cover page"""
        story = []

        building_name = data.get('building_name', 'Unknown Building')
        extraction_date = datetime.now().strftime('%d %B %Y')

        # Logo/Title
        story.append(Spacer(1, 3*cm))
        story.append(Paragraph("BlocIQ", self.styles['CustomTitle']))
        story.append(Paragraph("Property Management Intelligence", self.styles['Normal']))

        story.append(Spacer(1, 4*cm))

        # Report Title
        title_style = ParagraphStyle(
            'ReportTitle',
            parent=self.styles['CustomTitle'],
            fontSize=24
        )
        story.append(Paragraph("Property Summary Report", self.styles['Heading1']))
        story.append(Spacer(1, 0.5*cm))
        story.append(Paragraph(building_name, title_style))
        story.append(Spacer(1, 0.5*cm))
        story.append(Paragraph(extraction_date, self.styles['Normal']))

        story.append(Spacer(1, 6*cm))

        # Footer
        footer_style = ParagraphStyle(
            'CoverFooter',
            parent=self.styles['Normal'],
            fontSize=10,
            textColor=colors.grey,
            alignment=TA_CENTER
        )
        story.append(Paragraph("Confidential - For Internal Use Only", footer_style))

        return story

    def _create_executive_summary(self, data: Dict) -> List:
        """Create executive summary cards"""
        story = []

        summary = data.get('summary', {})
        compliance = data.get('compliance_analysis', {}).get('summary', {})

        # Summary metrics
        metrics = [
            ("Total Units", summary.get('total_units', 0)),
            ("Leaseholders", summary.get('total_leaseholders', 0)),
            ("Outstanding Balance", f"£{summary.get('total_outstanding_balance', 0):,.0f}"),
            ("Compliance Rate", f"{compliance.get('compliance_rate', 0):.1f}%"),
            ("Active Contracts", summary.get('total_contracts', 0)),
            ("Data Quality", f"{data.get('confidence_score', 0):.0%}"),
        ]

        # Create summary table
        table_data = []
        row = []
        for i, (label, value) in enumerate(metrics):
            row.append([
                Paragraph(f"<b>{value}</b>", self.styles['Heading2']),
                Paragraph(label, self.styles['Normal'])
            ])
            if (i + 1) % 3 == 0:
                table_data.append(row)
                row = []

        if row:  # Add remaining items
            table_data.append(row)

        summary_table = Table(table_data, colWidths=[6*cm, 6*cm, 6*cm])
        summary_table.setStyle(TableStyle([
            ('ALIGN', (0, 0), (-1, -1), 'CENTER'),
            ('VALIGN', (0, 0), (-1, -1), 'MIDDLE'),
            ('BACKGROUND', (0, 0), (-1, -1), self.COLOR_LIGHT_GREY),
            ('BOX', (0, 0), (-1, -1), 1, colors.grey),
            ('INNERGRID', (0, 0), (-1, -1), 1, colors.white),
            ('TOPPADDING', (0, 0), (-1, -1), 12),
            ('BOTTOMPADDING', (0, 0), (-1, -1), 12),
        ]))

        story.append(summary_table)
        story.append(Spacer(1, 0.5*cm))

        # Alert
        alert_text = f"""<b>Data Extraction Summary:</b> This report contains comprehensive property data extracted using BlocIQ's AI-powered extraction system (v{data.get('extraction_version', 'Unknown')}). All data has been validated with {data.get('confidence_score', 0):.0%} confidence."""
        story.append(Paragraph(alert_text, self.styles['AlertInfo']))

        return story

    def _create_building_overview(self, data: Dict) -> List:
        """Create building overview section"""
        story = []

        building_info = [
            ["Property Name", data.get('building_name', 'Unknown')],
            ["Address", f"{data.get('building_address', '')}\n{data.get('postcode', '')}"],
            ["Units", f"{data.get('num_units', 0)} residential units"],
            ["Building Details", f"{data.get('num_floors', 'N/A')} floors, {data.get('building_height_meters', 'N/A')}m height"],
            ["Construction", f"{data.get('construction_era', 'Unknown')} ({data.get('year_built', 'Unknown')})"],
            ["BSA Status", data.get('bsa_status', 'Not Registered')],
        ]

        # Special facilities
        facilities = []
        for key, label in [('has_gym', 'Gym'), ('has_pool', 'Swimming Pool'), ('has_sauna', 'Sauna'), ('has_squash_court', 'Squash Court'), ('has_ev_charging', 'EV Charging')]:
            if data.get(key):
                facilities.append(label)

        building_info.append(["Special Facilities", ', '.join(facilities) if facilities else 'None'])

        table = Table(building_info, colWidths=[6*cm, 11*cm])
        table.setStyle(TableStyle([
            ('BACKGROUND', (0, 0), (0, -1), self.COLOR_LIGHT_GREY),
            ('FONT', (0, 0), (0, -1), 'Helvetica-Bold'),
            ('ALIGN', (0, 0), (0, -1), 'RIGHT'),
            ('ALIGN', (1, 0), (1, -1), 'LEFT'),
            ('VALIGN', (0, 0), (-1, -1), 'TOP'),
            ('GRID', (0, 0), (-1, -1), 1, colors.grey),
            ('TOPPADDING', (0, 0), (-1, -1), 8),
            ('BOTTOMPADDING', (0, 0), (-1, -1), 8),
            ('LEFTPADDING', (0, 0), (-1, -1), 10),
            ('RIGHTPADDING', (0, 0), (-1, -1), 10),
        ]))

        story.append(table)

        return story

    def _create_leaseholder_summary(self, data: Dict) -> List:
        """Create leaseholder summary"""
        story = []

        leaseholders = data.get('leaseholders', [])
        total_leaseholders = len(leaseholders)
        with_balances = sum(1 for lh in leaseholders if lh.get('balance', 0) != 0)
        total_balance = sum(lh.get('balance', 0) for lh in leaseholders)
        units = data.get('units', [])
        coverage = len(leaseholders) / len(units) * 100 if units else 0

        # Stats
        stats_data = [[
            f"<b>{total_leaseholders}</b><br/>Total Leaseholders",
            f"<b>{coverage:.1f}%</b><br/>Coverage",
            f"<b>{with_balances}</b><br/>With Balance",
            f"<b>£{total_balance:,.2f}</b><br/>Total Outstanding"
        ]]

        stats_table = Table(stats_data, colWidths=[4.5*cm]*4)
        stats_table.setStyle(TableStyle([
            ('ALIGN', (0, 0), (-1, -1), 'CENTER'),
            ('VALIGN', (0, 0), (-1, -1), 'MIDDLE'),
            ('BACKGROUND', (0, 0), (-1, -1), self.COLOR_LIGHT_GREY),
            ('BOX', (0, 0), (-1, -1), 1, colors.grey),
            ('INNERGRID', (0, 0), (-1, -1), 1, colors.white),
            ('TOPPADDING', (0, 0), (-1, -1), 12),
            ('BOTTOMPADDING', (0, 0), (-1, -1), 12),
        ]))

        story.append(stats_table)
        story.append(Spacer(1, 0.5*cm))

        # Leaseholder table (top 10)
        story.append(Paragraph("Leaseholder Register (Top 10)", self.styles['SubsectionHeader']))

        lh_data = [["Unit", "Leaseholder Name", "Contact", "Balance"]]

        for lh in leaseholders[:10]:
            lh_data.append([
                lh.get('unit_number', 'N/A'),
                lh.get('leaseholder_name', 'Unknown')[:30],
                lh.get('telephone', 'N/A'),
                f"£{lh.get('balance', 0):,.2f}"
            ])

        if len(leaseholders) > 10:
            lh_data.append(['...', f'and {len(leaseholders) - 10} more', '', ''])

        lh_table = Table(lh_data, colWidths=[2.5*cm, 7*cm, 4*cm, 3.5*cm])
        lh_table.setStyle(TableStyle([
            ('BACKGROUND', (0, 0), (-1, 0), self.COLOR_PRIMARY),
            ('TEXTCOLOR', (0, 0), (-1, 0), colors.white),
            ('FONT', (0, 0), (-1, 0), 'Helvetica-Bold'),
            ('FONTSIZE', (0, 0), (-1, -1), 9),
            ('ALIGN', (3, 1), (3, -1), 'RIGHT'),
            ('GRID', (0, 0), (-1, -1), 1, colors.grey),
            ('ROWBACKGROUNDS', (0, 1), (-1, -1), [colors.white, self.COLOR_LIGHT_GREY]),
            ('TOPPADDING', (0, 0), (-1, -1), 6),
            ('BOTTOMPADDING', (0, 0), (-1, -1), 6),
        ]))

        story.append(lh_table)

        return story

    def _create_compliance_dashboard(self, data: Dict) -> List:
        """Create compliance dashboard"""
        story = []

        compliance = data.get('compliance_analysis', {})
        summary = compliance.get('summary', {})

        total_required = summary.get('total_required', 0)
        current = summary.get('current', 0)
        expired = summary.get('expired', 0)
        missing = summary.get('missing', 0)
        compliance_rate = summary.get('compliance_rate', 0)

        # Compliance pie chart
        drawing = Drawing(400, 200)

        pie = Pie()
        pie.x = 150
        pie.y = 50
        pie.width = 100
        pie.height = 100
        pie.data = [current, expired, missing]
        pie.labels = ['Current', 'Expired', 'Missing']
        pie.slices.strokeWidth = 1
        pie.slices[0].fillColor = self.COLOR_SUCCESS
        pie.slices[1].fillColor = self.COLOR_WARNING
        pie.slices[2].fillColor = self.COLOR_DANGER

        drawing.add(pie)
        story.append(drawing)
        story.append(Spacer(1, 0.5*cm))

        # Stats
        status = "CRITICAL" if compliance_rate < 30 else "NEEDS ATTENTION" if compliance_rate < 70 else "GOOD"
        status_color = self.COLOR_DANGER if compliance_rate < 30 else self.COLOR_WARNING if compliance_rate < 70 else self.COLOR_SUCCESS

        stats_data = [[
            f"<b>{compliance_rate:.1f}%</b><br/>Compliance Rate",
            f"<b>{total_required}</b><br/>Required",
            f"<b>{current}</b><br/>Current",
            f"<b>{expired}</b><br/>Expired",
            f"<b>{missing}</b><br/>Missing"
        ]]

        stats_table = Table(stats_data, colWidths=[3.6*cm]*5)
        stats_table.setStyle(TableStyle([
            ('ALIGN', (0, 0), (-1, -1), 'CENTER'),
            ('VALIGN', (0, 0), (-1, -1), 'MIDDLE'),
            ('BACKGROUND', (0, 0), (0, 0), status_color.clone(alpha=0.2)),
            ('BACKGROUND', (1, 0), (-1, -1), self.COLOR_LIGHT_GREY),
            ('BOX', (0, 0), (-1, -1), 1, colors.grey),
            ('INNERGRID', (0, 0), (-1, -1), 1, colors.white),
            ('TOPPADDING', (0, 0), (-1, -1), 12),
            ('BOTTOMPADDING', (0, 0), (-1, -1), 12),
        ]))

        story.append(stats_table)
        story.append(Spacer(1, 0.5*cm))

        # Alert
        alert_style = 'AlertDanger' if compliance_rate < 30 else 'AlertWarning' if compliance_rate < 70 else 'AlertSuccess'
        alert_text = f"<b>Compliance Status: {status}</b><br/>{current} of {total_required} required compliance assets are current. {expired} assets have expired and {missing} are missing."
        story.append(Paragraph(alert_text, self.styles[alert_style]))

        # Critical issues
        expired_assets = compliance.get('expired', [])
        if expired_assets:
            story.append(Spacer(1, 0.5*cm))
            story.append(Paragraph("🔴 Expired Assets (Immediate Action Required)", self.styles['SubsectionHeader']))

            exp_data = [["Asset Type", "Last Inspection", "Status"]]
            for asset in expired_assets[:5]:
                exp_data.append([
                    asset.get('asset_type', 'Unknown'),
                    asset.get('inspection_date', 'N/A'),
                    "Expired"
                ])

            exp_table = Table(exp_data, colWidths=[8*cm, 5*cm, 4*cm])
            exp_table.setStyle(TableStyle([
                ('BACKGROUND', (0, 0), (-1, 0), self.COLOR_DANGER),
                ('TEXTCOLOR', (0, 0), (-1, 0), colors.white),
                ('FONT', (0, 0), (-1, 0), 'Helvetica-Bold'),
                ('FONTSIZE', (0, 0), (-1, -1), 9),
                ('GRID', (0, 0), (-1, -1), 1, colors.grey),
                ('ROWBACKGROUNDS', (0, 1), (-1, -1), [colors.white, self.COLOR_LIGHT_GREY]),
            ]))

            story.append(exp_table)

        return story

    def _create_contract_register(self, data: Dict) -> List:
        """Create contract register"""
        story = []

        contracts = data.get('maintenance_contracts', [])

        contract_data = [["Contract Type", "Contractor", "Start Date", "End Date", "Status"]]

        for contract in contracts[:10]:
            contract_data.append([
                contract.get('contract_type', 'Unknown')[:25],
                contract.get('contractor_name', 'Unknown')[:25],
                contract.get('contract_start_date', 'N/A'),
                contract.get('contract_end_date', 'N/A'),
                contract.get('contract_status', 'Unknown')
            ])

        if len(contracts) > 10:
            contract_data.append(['...', f'and {len(contracts) - 10} more', '', '', ''])

        contract_table = Table(contract_data, colWidths=[4*cm, 4*cm, 2.5*cm, 2.5*cm, 2.5*cm])
        contract_table.setStyle(TableStyle([
            ('BACKGROUND', (0, 0), (-1, 0), self.COLOR_PRIMARY),
            ('TEXTCOLOR', (0, 0), (-1, 0), colors.white),
            ('FONT', (0, 0), (-1, 0), 'Helvetica-Bold'),
            ('FONTSIZE', (0, 0), (-1, -1), 9),
            ('GRID', (0, 0), (-1, -1), 1, colors.grey),
            ('ROWBACKGROUNDS', (0, 1), (-1, -1), [colors.white, self.COLOR_LIGHT_GREY]),
            ('TOPPADDING', (0, 0), (-1, -1), 6),
            ('BOTTOMPADDING', (0, 0), (-1, -1), 6),
        ]))

        story.append(contract_table)

        return story

    def _create_financial_summary(self, data: Dict) -> List:
        """Create financial summary"""
        story = []

        summary = data.get('summary', {})
        budget_total = summary.get('service_charge_budget') or summary.get('total_budget', 0)
        outstanding = summary.get('total_outstanding_balance', 0)
        leaseholders_with_balance = summary.get('leaseholders_with_balances', 0)
        avg_balance = outstanding / max(leaseholders_with_balance, 1)

        financial_data = [
            ["Service Charge Budget (Annual)", f"£{budget_total:,.2f}"],
            ["Total Outstanding Balances", f"£{outstanding:,.2f}"],
            ["Leaseholders with Outstanding Balance", str(leaseholders_with_balance)],
            ["Average Balance per Leaseholder", f"£{avg_balance:,.2f}"],
        ]

        table = Table(financial_data, colWidths=[9*cm, 8*cm])
        table.setStyle(TableStyle([
            ('BACKGROUND', (0, 0), (0, -1), self.COLOR_LIGHT_GREY),
            ('FONT', (0, 0), (0, -1), 'Helvetica-Bold'),
            ('ALIGN', (0, 0), (0, -1), 'RIGHT'),
            ('ALIGN', (1, 0), (1, -1), 'RIGHT'),
            ('GRID', (0, 0), (-1, -1), 1, colors.grey),
            ('TOPPADDING', (0, 0), (-1, -1), 8),
            ('BOTTOMPADDING', (0, 0), (-1, -1), 8),
        ]))

        story.append(table)
        story.append(Spacer(1, 0.5*cm))

        # Note
        note_text = "<b>Note:</b> Outstanding balances require follow-up action. Consider payment plans for balances over £5,000."
        story.append(Paragraph(note_text, self.styles['AlertInfo']))

        return story


# ============================================================================
# CLI Interface
# ============================================================================

def main():
    """CLI entry point"""
    import argparse

    parser = argparse.ArgumentParser(description='Generate PDF summary report from BlocIQ extraction data')
    parser.add_argument('json_file', help='Input JSON file from extraction')
    parser.add_argument('-o', '--output', help='Output PDF file', default=None)

    args = parser.parse_args()

    # Load JSON data
    with open(args.json_file, 'r') as f:
        data = json.load(f)

    # Determine output file
    if args.output:
        output_file = args.output
    else:
        output_file = args.json_file.replace('.json', '_report.pdf')

    # Generate PDF
    generator = PDFReportGenerator()
    generator.generate_pdf(data, output_file)

    print(f"\n✅ PDF Report Complete!")
    print(f"   Output: {output_file}")


if __name__ == '__main__':
    main()
