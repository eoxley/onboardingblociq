#!/usr/bin/env python3
"""
BlocIQ Building Health Check Report Generator
Generates a branded PDF report with compliance scores, risks, and recommendations
"""

import os
from datetime import datetime, timedelta
from pathlib import Path
from typing import Dict, List, Tuple
from reportlab.lib import colors
from reportlab.lib.pagesizes import A4
from reportlab.lib.styles import getSampleStyleSheet, ParagraphStyle
from reportlab.lib.units import inch
from reportlab.platypus import (
    SimpleDocTemplate, Paragraph, Spacer, Table, TableStyle,
    PageBreak, Image, KeepTogether
)
from reportlab.pdfgen import canvas
from reportlab.lib.enums import TA_CENTER, TA_LEFT, TA_RIGHT


# BlocIQ Brand Colors
BLOCIQ_PURPLE = colors.HexColor('#6B46C1')
BLOCIQ_LIGHT_PURPLE = colors.HexColor('#9F7AEA')
BLOCIQ_DARK_PURPLE = colors.HexColor('#553C9A')
COLOR_GREEN = colors.HexColor('#48BB78')
COLOR_AMBER = colors.HexColor('#ECC94B')
COLOR_RED = colors.HexColor('#F56565')
COLOR_GREY = colors.HexColor('#A0AEC0')


class BuildingHealthCheckReport:
    """Generate Building Health Check PDF Report"""

    def __init__(self, output_path: str, building_data: Dict):
        self.output_path = output_path
        self.building_data = building_data
        self.width, self.height = A4
        self.styles = getSampleStyleSheet()
        self._setup_custom_styles()

    def _setup_custom_styles(self):
        """Setup custom paragraph styles"""
        # Title style
        self.styles.add(ParagraphStyle(
            name='CustomTitle',
            parent=self.styles['Heading1'],
            fontSize=28,
            textColor=colors.white,
            alignment=TA_CENTER,
            spaceAfter=12
        ))

        # Subtitle style
        self.styles.add(ParagraphStyle(
            name='CustomSubtitle',
            parent=self.styles['Normal'],
            fontSize=14,
            textColor=colors.white,
            alignment=TA_CENTER,
            spaceAfter=6
        ))

        # Heading style
        self.styles.add(ParagraphStyle(
            name='SectionHeading',
            parent=self.styles['Heading2'],
            fontSize=18,
            textColor=BLOCIQ_PURPLE,
            spaceAfter=12,
            spaceBefore=12
        ))

        # Small text style
        self.styles.add(ParagraphStyle(
            name='SmallText',
            parent=self.styles['Normal'],
            fontSize=9,
            textColor=COLOR_GREY
        ))

    def _calculate_scores(self) -> Dict:
        """Calculate compliance scores and risk levels"""
        compliance_assets = self.building_data.get('compliance_assets', [])

        # Initialize counters
        total_assets = len(compliance_assets)
        compliant = 0
        overdue = 0
        due_soon = 0
        unknown = 0

        # Category counters
        categories = {
            'fire_safety': {'total': 0, 'compliant': 0, 'overdue': 0, 'unknown': 0},
            'electrical': {'total': 0, 'compliant': 0, 'overdue': 0, 'unknown': 0},
            'water_safety': {'total': 0, 'compliant': 0, 'overdue': 0, 'unknown': 0},
            'general': {'total': 0, 'compliant': 0, 'overdue': 0, 'unknown': 0}
        }

        today = datetime.now().date()

        for asset in compliance_assets:
            due_date = asset.get('due_date')
            category_name = asset.get('category', 'general').lower().replace(' ', '_')

            # Map to standard categories
            if 'fire' in category_name:
                cat = 'fire_safety'
            elif 'electric' in category_name or 'eicr' in category_name:
                cat = 'electrical'
            elif 'water' in category_name or 'legionella' in category_name:
                cat = 'water_safety'
            else:
                cat = 'general'

            categories[cat]['total'] += 1

            if due_date:
                try:
                    if isinstance(due_date, str):
                        due_date = datetime.fromisoformat(due_date.replace('Z', '+00:00')).date()

                    if due_date >= today:
                        compliant += 1
                        categories[cat]['compliant'] += 1
                        if (due_date - today).days <= 30:
                            due_soon += 1
                    else:
                        overdue += 1
                        categories[cat]['overdue'] += 1
                except:
                    unknown += 1
                    categories[cat]['unknown'] += 1
            else:
                unknown += 1
                categories[cat]['unknown'] += 1

        # Calculate weighted scores
        def calc_category_score(cat_data):
            total = cat_data['total']
            if total == 0:
                return 0
            comp = cat_data['compliant']
            over = cat_data['overdue']
            unk = cat_data['unknown']
            return round((comp * 1.0 + unk * 0.4) / total * 100, 1)

        category_scores = {
            cat: calc_category_score(data)
            for cat, data in categories.items()
        }

        # Overall score
        if total_assets > 0:
            overall_score = round(
                (compliant * 1.0 + due_soon * 0.7 + unknown * 0.4) / total_assets * 100,
                1
            )
        else:
            overall_score = 0

        # Risk level
        if overall_score >= 70:
            risk_level = "Healthy"
            risk_color = COLOR_GREEN
        elif overall_score >= 40:
            risk_level = "Monitor"
            risk_color = COLOR_AMBER
        else:
            risk_level = "Critical"
            risk_color = COLOR_RED

        # BlocIQ Confidence Index (data completeness)
        total_fields = total_assets * 5  # Assuming 5 key fields per asset
        filled_fields = sum(1 for asset in compliance_assets for field in ['category', 'description', 'due_date', 'responsible_party', 'document_ref'] if asset.get(field))
        confidence = round((filled_fields / total_fields * 100) if total_fields > 0 else 0, 1)

        return {
            'overall_score': overall_score,
            'risk_level': risk_level,
            'risk_color': risk_color,
            'total_assets': total_assets,
            'compliant': compliant,
            'overdue': overdue,
            'due_soon': due_soon,
            'unknown': unknown,
            'categories': categories,
            'category_scores': category_scores,
            'confidence': confidence
        }

    def _draw_cover_page(self, story: List):
        """Page 1: Cover page with branding"""
        # Purple gradient background (simulated with colored box)
        title = Paragraph(
            f"<b>{self.building_data.get('building_name', 'Building')}</b>",
            self.styles['CustomTitle']
        )

        address = Paragraph(
            self.building_data.get('address', 'Address not provided'),
            self.styles['CustomSubtitle']
        )

        date_str = datetime.now().strftime("%B %d, %Y")
        report_title = Paragraph(
            f"Building Health Check – {date_str}",
            self.styles['CustomSubtitle']
        )

        scores = self._calculate_scores()
        score = scores['overall_score']
        risk_level = scores['risk_level']

        # Build cover page
        story.append(Spacer(1, 2*inch))
        story.append(title)
        story.append(address)
        story.append(Spacer(1, 0.3*inch))
        story.append(report_title)
        story.append(Spacer(1, 0.5*inch))

        # Overall score display
        score_text = Paragraph(
            f"<b>Overall Health Score: {score}</b>",
            ParagraphStyle(
                'ScoreText',
                parent=self.styles['Normal'],
                fontSize=20,
                alignment=TA_CENTER,
                textColor=scores['risk_color']
            )
        )
        story.append(score_text)

        risk_text = Paragraph(
            f"Status: <b>{risk_level}</b>",
            ParagraphStyle(
                'RiskText',
                parent=self.styles['Normal'],
                fontSize=16,
                alignment=TA_CENTER,
                textColor=scores['risk_color']
            )
        )
        story.append(risk_text)

        story.append(Spacer(1, 1*inch))

        footer = Paragraph(
            "Prepared by: <b>BlocIQ Onboarder AI</b>",
            ParagraphStyle(
                'Footer',
                parent=self.styles['Normal'],
                fontSize=12,
                alignment=TA_CENTER,
                textColor=COLOR_GREY
            )
        )
        story.append(footer)
        story.append(PageBreak())

    def _draw_executive_summary(self, story: List):
        """Page 2: Executive Summary"""
        story.append(Paragraph("Executive Summary", self.styles['SectionHeading']))
        story.append(Spacer(1, 0.2*inch))

        scores = self._calculate_scores()

        # Key metrics table
        metrics_data = [
            ['Metric', 'Value', 'Status'],
            ['Overall Score', f"{scores['overall_score']}", scores['risk_level']],
            ['Total Assets', f"{scores['total_assets']}", ''],
            ['Compliant', f"{scores['compliant']}", ''],
            ['Overdue', f"{scores['overdue']}", ''],
            ['Unknown Status', f"{scores['unknown']}", ''],
            ['Fire Safety Score', f"{scores['category_scores']['fire_safety']}%", ''],
            ['Electrical Score', f"{scores['category_scores']['electrical']}%", ''],
            ['Water Safety Score', f"{scores['category_scores']['water_safety']}%", ''],
            ['Data Confidence', f"{scores['confidence']}%", ''],
        ]

        metrics_table = Table(metrics_data, colWidths=[2.5*inch, 1.5*inch, 1.5*inch])
        metrics_table.setStyle(TableStyle([
            ('BACKGROUND', (0, 0), (-1, 0), BLOCIQ_PURPLE),
            ('TEXTCOLOR', (0, 0), (-1, 0), colors.white),
            ('ALIGN', (0, 0), (-1, -1), 'LEFT'),
            ('FONTNAME', (0, 0), (-1, 0), 'Helvetica-Bold'),
            ('FONTSIZE', (0, 0), (-1, 0), 12),
            ('BOTTOMPADDING', (0, 0), (-1, 0), 12),
            ('BACKGROUND', (0, 1), (-1, -1), colors.white),
            ('GRID', (0, 0), (-1, -1), 1, COLOR_GREY),
            ('ROWBACKGROUNDS', (0, 1), (-1, -1), [colors.white, colors.lightgrey]),
        ]))

        story.append(metrics_table)
        story.append(Spacer(1, 0.3*inch))

        # Top Risks
        story.append(Paragraph("<b>Top 3 Risks</b>", self.styles['Heading3']))
        story.append(Spacer(1, 0.1*inch))

        risks = self._identify_top_risks(scores)
        for i, risk in enumerate(risks[:3], 1):
            risk_para = Paragraph(
                f"<b>{i}.</b> {risk}",
                self.styles['Normal']
            )
            story.append(risk_para)
            story.append(Spacer(1, 0.1*inch))

        story.append(Spacer(1, 0.2*inch))

        # Upcoming inspections
        upcoming = self._get_upcoming_inspections()
        if upcoming:
            story.append(Paragraph("<b>Upcoming Inspections (Next 30 Days)</b>", self.styles['Heading3']))
            story.append(Spacer(1, 0.1*inch))

            for item in upcoming[:5]:
                story.append(Paragraph(f"• {item}", self.styles['Normal']))
                story.append(Spacer(1, 0.05*inch))

        story.append(PageBreak())

    def _draw_compliance_summary(self, story: List):
        """Page 3: Compliance Summary"""
        story.append(Paragraph("Compliance Summary", self.styles['SectionHeading']))
        story.append(Spacer(1, 0.2*inch))

        scores = self._calculate_scores()
        categories = scores['categories']
        category_scores = scores['category_scores']

        # Compliance table
        compliance_data = [
            ['Category', 'Total', 'Compliant', 'Overdue', 'Unknown', 'Score']
        ]

        category_labels = {
            'fire_safety': '🔥 Fire Safety',
            'electrical': '⚡ Electrical',
            'water_safety': '💧 Water Safety',
            'general': '📋 General'
        }

        for cat_key, cat_data in categories.items():
            if cat_data['total'] > 0:
                compliance_data.append([
                    category_labels.get(cat_key, cat_key.title()),
                    str(cat_data['total']),
                    str(cat_data['compliant']),
                    str(cat_data['overdue']),
                    str(cat_data['unknown']),
                    f"{category_scores[cat_key]}%"
                ])

        compliance_table = Table(compliance_data, colWidths=[1.8*inch, 0.8*inch, 1*inch, 0.9*inch, 0.9*inch, 0.9*inch])
        compliance_table.setStyle(TableStyle([
            ('BACKGROUND', (0, 0), (-1, 0), BLOCIQ_PURPLE),
            ('TEXTCOLOR', (0, 0), (-1, 0), colors.white),
            ('ALIGN', (0, 0), (-1, -1), 'CENTER'),
            ('ALIGN', (0, 1), (0, -1), 'LEFT'),
            ('FONTNAME', (0, 0), (-1, 0), 'Helvetica-Bold'),
            ('FONTSIZE', (0, 0), (-1, 0), 11),
            ('BOTTOMPADDING', (0, 0), (-1, 0), 12),
            ('BACKGROUND', (0, 1), (-1, -1), colors.white),
            ('GRID', (0, 0), (-1, -1), 1, COLOR_GREY),
            ('ROWBACKGROUNDS', (0, 1), (-1, -1), [colors.white, colors.lightgrey]),
        ]))

        story.append(compliance_table)
        story.append(PageBreak())

    def _draw_insurance_contractors(self, story: List):
        """Page 4: Insurance & Contractors"""
        story.append(Paragraph("Insurance & Contractors", self.styles['SectionHeading']))
        story.append(Spacer(1, 0.2*inch))

        # Insurance policies
        insurance = self.building_data.get('insurance_policies', [])
        if insurance:
            story.append(Paragraph("<b>Active Insurance Policies</b>", self.styles['Heading3']))
            story.append(Spacer(1, 0.1*inch))

            insurance_data = [['Policy Type', 'Insurer', 'Expiry Date', 'Premium']]
            for policy in insurance[:5]:
                insurance_data.append([
                    policy.get('insurance_type', 'N/A'),
                    policy.get('insurer', 'N/A'),
                    policy.get('expiry_date', 'N/A'),
                    f"£{policy.get('premium_amount', 0):,.2f}" if policy.get('premium_amount') else 'N/A'
                ])

            ins_table = Table(insurance_data, colWidths=[1.5*inch, 1.5*inch, 1.3*inch, 1.2*inch])
            ins_table.setStyle(TableStyle([
                ('BACKGROUND', (0, 0), (-1, 0), BLOCIQ_LIGHT_PURPLE),
                ('TEXTCOLOR', (0, 0), (-1, 0), colors.white),
                ('ALIGN', (0, 0), (-1, -1), 'LEFT'),
                ('FONTNAME', (0, 0), (-1, 0), 'Helvetica-Bold'),
                ('FONTSIZE', (0, 0), (-1, 0), 10),
                ('GRID', (0, 0), (-1, -1), 1, COLOR_GREY),
                ('ROWBACKGROUNDS', (0, 1), (-1, -1), [colors.white, colors.lightgrey]),
            ]))

            story.append(ins_table)
            story.append(Spacer(1, 0.3*inch))

        # Contracts
        contracts = self.building_data.get('contracts', [])
        if contracts:
            story.append(Paragraph("<b>Active Contracts</b>", self.styles['Heading3']))
            story.append(Spacer(1, 0.1*inch))

            contract_data = [['Service', 'Contractor', 'Renewal Date', 'Status']]
            today = datetime.now().date()

            for contract in contracts[:8]:
                renewal_date = contract.get('end_date', '')
                status = 'Active'

                if renewal_date:
                    try:
                        if isinstance(renewal_date, str):
                            renewal_dt = datetime.fromisoformat(renewal_date.replace('Z', '+00:00')).date()
                        else:
                            renewal_dt = renewal_date

                        days_until = (renewal_dt - today).days
                        if days_until <= 90:
                            status = f'⚠️ Expiring in {days_until}d'
                    except:
                        pass

                contract_data.append([
                    contract.get('service_type', 'N/A'),
                    contract.get('contractor_name', 'N/A'),
                    renewal_date if isinstance(renewal_date, str) else str(renewal_date),
                    status
                ])

            contract_table = Table(contract_data, colWidths=[1.5*inch, 1.5*inch, 1.3*inch, 1.2*inch])
            contract_table.setStyle(TableStyle([
                ('BACKGROUND', (0, 0), (-1, 0), BLOCIQ_LIGHT_PURPLE),
                ('TEXTCOLOR', (0, 0), (-1, 0), colors.white),
                ('ALIGN', (0, 0), (-1, -1), 'LEFT'),
                ('FONTNAME', (0, 0), (-1, 0), 'Helvetica-Bold'),
                ('FONTSIZE', (0, 0), (-1, 0), 10),
                ('GRID', (0, 0), (-1, -1), 1, COLOR_GREY),
                ('ROWBACKGROUNDS', (0, 1), (-1, -1), [colors.white, colors.lightgrey]),
            ]))

            story.append(contract_table)

        story.append(PageBreak())

    def _draw_major_works_budget(self, story: List):
        """Page 5: Major Works & Budget"""
        story.append(Paragraph("Major Works & Budget", self.styles['SectionHeading']))
        story.append(Spacer(1, 0.2*inch))

        major_works = self.building_data.get('major_works', [])
        if major_works:
            story.append(Paragraph("<b>Active Projects</b>", self.styles['Heading3']))
            story.append(Spacer(1, 0.1*inch))

            works_data = [['Project', 'Status', 'Start Date', 'Budget']]
            total_budget = 0

            for work in major_works[:8]:
                budget = work.get('total_cost', 0) or 0
                total_budget += budget

                works_data.append([
                    work.get('project_name', 'N/A'),
                    work.get('status', 'N/A'),
                    work.get('start_date', 'N/A'),
                    f"£{budget:,.2f}"
                ])

            works_data.append(['', '', 'Total:', f"£{total_budget:,.2f}"])

            works_table = Table(works_data, colWidths=[2*inch, 1.2*inch, 1.3*inch, 1*inch])
            works_table.setStyle(TableStyle([
                ('BACKGROUND', (0, 0), (-1, 0), BLOCIQ_LIGHT_PURPLE),
                ('TEXTCOLOR', (0, 0), (-1, 0), colors.white),
                ('ALIGN', (0, 0), (-1, -1), 'LEFT'),
                ('ALIGN', (3, 1), (3, -1), 'RIGHT'),
                ('FONTNAME', (0, 0), (-1, 0), 'Helvetica-Bold'),
                ('FONTSIZE', (0, 0), (-1, 0), 10),
                ('GRID', (0, 0), (-1, -2), 1, COLOR_GREY),
                ('LINEABOVE', (2, -1), (-1, -1), 2, BLOCIQ_PURPLE),
                ('FONTNAME', (2, -1), (-1, -1), 'Helvetica-Bold'),
                ('ROWBACKGROUNDS', (0, 1), (-1, -2), [colors.white, colors.lightgrey]),
            ]))

            story.append(works_table)
            story.append(Spacer(1, 0.2*inch))

        # Budget summary
        budgets = self.building_data.get('budgets', [])
        if budgets:
            story.append(Paragraph("<b>Budget Summary</b>", self.styles['Heading3']))
            story.append(Spacer(1, 0.1*inch))

            for budget in budgets[:3]:
                budget_text = f"<b>{budget.get('category', 'General')}:</b> £{budget.get('allocated_amount', 0):,.2f} allocated"
                story.append(Paragraph(budget_text, self.styles['Normal']))
                story.append(Spacer(1, 0.05*inch))

        story.append(PageBreak())

    def _draw_actions_recommendations(self, story: List):
        """Page 6: Actions & Recommendations"""
        story.append(Paragraph("Actions & Recommendations", self.styles['SectionHeading']))
        story.append(Spacer(1, 0.2*inch))

        scores = self._calculate_scores()
        recommendations = self._generate_recommendations(scores)

        story.append(Paragraph(
            "The BlocIQ Onboarder AI has identified the following priority actions:",
            self.styles['Normal']
        ))
        story.append(Spacer(1, 0.2*inch))

        for rec in recommendations:
            icon = rec.get('icon', '•')
            priority = rec.get('priority', '')
            text = rec.get('text', '')

            rec_para = Paragraph(
                f"{icon} <b>[{priority}]</b> {text}",
                self.styles['Normal']
            )
            story.append(rec_para)
            story.append(Spacer(1, 0.15*inch))

        story.append(Spacer(1, 0.4*inch))

        # Footer
        footer_text = f"<i>Generated automatically by BlocIQ Onboarder AI on {datetime.now().strftime('%B %d, %Y at %H:%M')}</i>"
        story.append(Paragraph(footer_text, self.styles['SmallText']))

    def _identify_top_risks(self, scores: Dict) -> List[str]:
        """Identify top 3 risks based on scores"""
        risks = []

        if scores['overdue'] > 0:
            risks.append(f"{scores['overdue']} compliance asset(s) overdue - immediate action required")

        if scores['category_scores']['fire_safety'] < 50:
            risks.append(f"Fire Safety score critically low ({scores['category_scores']['fire_safety']}%) - urgent review needed")

        if scores['category_scores']['water_safety'] < 50:
            risks.append(f"Water Safety score below acceptable level ({scores['category_scores']['water_safety']}%) - legionella risk")

        if scores['unknown'] > scores['total_assets'] * 0.5:
            risks.append(f"Over 50% of assets have unknown status - data quality issue")

        if scores['confidence'] < 60:
            risks.append(f"Data confidence low ({scores['confidence']}%) - incomplete building records")

        # Check contracts
        contracts = self.building_data.get('contracts', [])
        expiring_soon = 0
        today = datetime.now().date()

        for contract in contracts:
            end_date = contract.get('end_date')
            if end_date:
                try:
                    if isinstance(end_date, str):
                        end_dt = datetime.fromisoformat(end_date.replace('Z', '+00:00')).date()
                    else:
                        end_dt = end_date

                    if 0 <= (end_dt - today).days <= 90:
                        expiring_soon += 1
                except:
                    pass

        if expiring_soon > 0:
            risks.append(f"{expiring_soon} contract(s) expiring within 90 days - renewal action required")

        return risks

    def _get_upcoming_inspections(self) -> List[str]:
        """Get inspections due in next 30 days"""
        upcoming = []
        compliance_assets = self.building_data.get('compliance_assets', [])
        today = datetime.now().date()
        future_30 = today + timedelta(days=30)

        for asset in compliance_assets:
            due_date = asset.get('due_date')
            if due_date:
                try:
                    if isinstance(due_date, str):
                        due_dt = datetime.fromisoformat(due_date.replace('Z', '+00:00')).date()
                    else:
                        due_dt = due_date

                    if today <= due_dt <= future_30:
                        days_until = (due_dt - today).days
                        upcoming.append(
                            f"{asset.get('category', 'Inspection')} - {asset.get('description', 'N/A')} "
                            f"(due in {days_until} days)"
                        )
                except:
                    pass

        return sorted(upcoming)

    def _generate_recommendations(self, scores: Dict) -> List[Dict]:
        """Generate AI recommendations based on analysis"""
        recommendations = []

        # Critical overdue items
        if scores['overdue'] > 0:
            recommendations.append({
                'icon': '🔴',
                'priority': 'CRITICAL',
                'text': f"{scores['overdue']} compliance asset(s) overdue - Schedule inspections immediately"
            })

        # Fire safety specific
        if scores['category_scores']['fire_safety'] < 50:
            recommendations.append({
                'icon': '🔥',
                'priority': 'URGENT',
                'text': 'Fire Risk Assessment overdue or incomplete - Retender FRA immediately'
            })

        # Water safety specific
        if scores['category_scores']['water_safety'] < 60:
            recommendations.append({
                'icon': '💧',
                'priority': 'HIGH',
                'text': 'Legionella Risk Assessment status unclear - Request current report from contractor'
            })

        # Unknown status items
        if scores['unknown'] > 5:
            recommendations.append({
                'icon': '⚠️',
                'priority': 'MEDIUM',
                'text': f"{scores['unknown']} asset(s) have unknown status - Update compliance tracker with current dates"
            })

        # Electrical
        if scores['categories']['electrical']['total'] > 0 and scores['category_scores']['electrical'] < 80:
            recommendations.append({
                'icon': '⚡',
                'priority': 'MEDIUM',
                'text': 'EICR or electrical testing may require attention - Verify inspection dates'
            })

        # Contracts expiring
        contracts = self.building_data.get('contracts', [])
        today = datetime.now().date()
        expiring = []

        for contract in contracts:
            end_date = contract.get('end_date')
            if end_date:
                try:
                    if isinstance(end_date, str):
                        end_dt = datetime.fromisoformat(end_date.replace('Z', '+00:00')).date()
                    else:
                        end_dt = end_date

                    if 0 <= (end_dt - today).days <= 90:
                        expiring.append(contract.get('service_type', 'Contract'))
                except:
                    pass

        if expiring:
            recommendations.append({
                'icon': '📋',
                'priority': 'MEDIUM',
                'text': f"Contract(s) expiring soon: {', '.join(expiring[:3])} - Schedule renewal discussions"
            })

        # Data quality
        if scores['confidence'] < 70:
            recommendations.append({
                'icon': '📊',
                'priority': 'LOW',
                'text': f'Data completeness at {scores["confidence"]}% - Review and update building records for better tracking'
            })

        # General maintenance
        if scores['overall_score'] < 50:
            recommendations.append({
                'icon': '🔧',
                'priority': 'HIGH',
                'text': 'Overall building health critical - Consider comprehensive compliance audit'
            })

        return recommendations

    def generate(self):
        """Generate the complete PDF report"""
        # Create PDF document
        doc = SimpleDocTemplate(
            self.output_path,
            pagesize=A4,
            rightMargin=0.75*inch,
            leftMargin=0.75*inch,
            topMargin=0.75*inch,
            bottomMargin=0.75*inch
        )

        # Build story
        story = []

        # Add all pages
        self._draw_cover_page(story)
        self._draw_executive_summary(story)
        self._draw_compliance_summary(story)
        self._draw_insurance_contractors(story)
        self._draw_major_works_budget(story)
        self._draw_actions_recommendations(story)

        # Build PDF
        doc.build(story)

        return self.output_path


def generate_health_check_report(building_data: Dict, output_path: str = None) -> str:
    """
    Main entry point for generating Building Health Check report

    Args:
        building_data: Dictionary containing all building data
        output_path: Optional custom output path

    Returns:
        Path to generated PDF
    """
    if output_path is None:
        output_dir = Path.home() / "Desktop" / "BlocIQ_Output"
        output_dir.mkdir(parents=True, exist_ok=True)

        building_id = building_data.get('building_id', 'unknown')
        output_path = output_dir / building_id / "building_health_check.pdf"
        output_path.parent.mkdir(parents=True, exist_ok=True)

    report = BuildingHealthCheckReport(str(output_path), building_data)
    return report.generate()
