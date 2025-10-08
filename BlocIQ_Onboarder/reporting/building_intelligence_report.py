"""
BlocIQ Building Intelligence Report Generator V2
Professional, client-ready building health check with visual analytics and actionable insights
"""

import os
import io
from datetime import datetime, timedelta
from pathlib import Path
from typing import Dict, List, Optional, Tuple
from collections import defaultdict

# ReportLab imports
from reportlab.lib import colors
from reportlab.lib.pagesizes import A4
from reportlab.lib.styles import getSampleStyleSheet, ParagraphStyle
from reportlab.lib.units import inch, cm, mm
from reportlab.lib.enums import TA_CENTER, TA_LEFT, TA_RIGHT, TA_JUSTIFY
from reportlab.platypus import (
    SimpleDocTemplate, Paragraph, Spacer, Table, TableStyle,
    PageBreak, Image, KeepTogether, Frame, PageTemplate
)
from reportlab.pdfgen import canvas

# Matplotlib for charts
import matplotlib
matplotlib.use('Agg')
import matplotlib.pyplot as plt
import matplotlib.patches as mpatches
from matplotlib.patches import Rectangle
import numpy as np


class BlocIQBrandColors:
    """BlocIQ Brand Color Palette"""
    PURPLE = '#5E48E8'
    PURPLE_LIGHT = '#8B7AEF'
    PURPLE_DARK = '#4A38C7'
    
    GREY_LIGHT = '#F8F9FA'
    GREY = '#E9ECEF'
    GREY_DARK = '#6C757D'
    
    RED_CRITICAL = '#D9534F'
    ORANGE_WARNING = '#F59E0B'
    GREEN_SUCCESS = '#28A745'
    GREEN_LIGHT = '#5CB85C'
    
    BLUE_INFO = '#17A2B8'
    
    WHITE = '#FFFFFF'
    BLACK = '#212529'


class BuildingIntelligenceEngine:
    """Core intelligence engine for building analysis"""
    
    def __init__(self, building_data: Dict):
        self.data = building_data
        self.building = building_data.get('building', {})
        self.compliance_assets = building_data.get('compliance_assets', [])
        self.contracts = building_data.get('contracts', [])
        self.insurance = building_data.get('insurance_policies', [])
        self.budgets = building_data.get('budgets', [])
        self.major_works = building_data.get('major_works_projects', [])
        
        # Computed metrics
        self.overall_score = 0
        self.category_scores = {}
        self.risk_items = []
        self.recommendations = []
        
    def analyze(self):
        """Run full building intelligence analysis"""
        print("🧠 Running building intelligence analysis...")
        
        # Deduplicate and aggregate compliance data
        self._deduplicate_compliance_assets()
        
        # Calculate category scores
        self._calculate_category_scores()
        
        # Calculate overall score
        self._calculate_overall_score()
        
        # Identify risk items
        self._identify_risks()
        
        # Generate recommendations
        self._generate_recommendations()
        
        print(f"   Overall Score: {self.overall_score:.1f}/100")
        print(f"   Categories: {len(self.category_scores)}")
        print(f"   Risks Identified: {len(self.risk_items)}")
        print(f"   Recommendations: {len(self.recommendations)}")
        
    def _deduplicate_compliance_assets(self):
        """Deduplicate compliance assets by type and location, keep most recent"""
        if not self.compliance_assets:
            return
        
        # Group by asset_type + location
        grouped = defaultdict(list)
        for asset in self.compliance_assets:
            asset_type = asset.get('asset_type', 'general')
            location = asset.get('location', 'building')
            key = f"{asset_type}_{location}"
            grouped[key].append(asset)
        
        # Keep most recent for each group
        deduplicated = []
        for key, assets in grouped.items():
            # Sort by last_inspection_date, most recent first
            sorted_assets = sorted(
                assets,
                key=lambda x: x.get('last_inspection_date') or '1900-01-01',
                reverse=True
            )
            # Keep the most recent one
            deduplicated.append(sorted_assets[0])
        
        original_count = len(self.compliance_assets)
        self.compliance_assets = deduplicated
        
        if original_count > len(deduplicated):
            print(f"   ✅ Deduplicated: {original_count} → {len(deduplicated)} assets")
    
    def _calculate_category_scores(self):
        """Calculate weighted scores per compliance category"""
        categories = defaultdict(lambda: {'compliant': 0, 'due_soon': 0, 'overdue': 0, 'unknown': 0, 'total': 0})
        
        today = datetime.now().date()
        
        for asset in self.compliance_assets:
            asset_type = asset.get('asset_type', 'general')
            status = asset.get('compliance_status', 'unknown')
            
            # Determine actual status based on next_due_date if available
            next_due = asset.get('next_due_date')
            if next_due and status == 'unknown':
                try:
                    next_date = datetime.fromisoformat(str(next_due)).date()
                    days_until = (next_date - today).days
                    
                    if days_until < 0:
                        status = 'overdue'
                    elif days_until < 30:
                        status = 'due_soon'
                    else:
                        status = 'compliant'
                except:
                    pass
            
            categories[asset_type][status] += 1
            categories[asset_type]['total'] += 1
        
        # Calculate weighted score for each category
        # Formula: (compliant * 1.0 + due_soon * 0.7 + unknown * 0.4 + overdue * 0.0) / total * 100
        for category, counts in categories.items():
            total = counts['total']
            if total > 0:
                score = (
                    counts['compliant'] * 1.0 +
                    counts['due_soon'] * 0.7 +
                    counts['unknown'] * 0.4 +
                    counts['overdue'] * 0.0
                ) / total * 100
                
                self.category_scores[category] = {
                    'score': round(score, 1),
                    'counts': counts
                }
    
    def _calculate_overall_score(self):
        """Calculate weighted overall building score"""
        if not self.category_scores:
            self.overall_score = 0
            return
        
        # Weight categories by asset count
        total_weighted = 0
        total_assets = 0
        
        for category, data in self.category_scores.items():
            score = data['score']
            asset_count = data['counts']['total']
            
            total_weighted += score * asset_count
            total_assets += asset_count
        
        if total_assets > 0:
            self.overall_score = round(total_weighted / total_assets, 1)
        else:
            self.overall_score = 0
    
    def _identify_risks(self):
        """Identify top risk items from overdue and due soon assets"""
        today = datetime.now().date()
        
        risks = []
        
        for asset in self.compliance_assets:
            status = asset.get('compliance_status', 'unknown')
            asset_name = asset.get('asset_name') or asset.get('asset_type', 'Asset')
            next_due = asset.get('next_due_date')
            last_inspection = asset.get('last_inspection_date')
            
            # Check if overdue
            if status == 'overdue' or (next_due and isinstance(next_due, str)):
                try:
                    next_date = datetime.fromisoformat(str(next_due)).date()
                    days_overdue = (today - next_date).days
                    
                    if days_overdue > 0:
                        risks.append({
                            'asset': asset_name,
                            'severity': 'critical',
                            'days_overdue': days_overdue,
                            'message': f"{asset_name} overdue by {days_overdue} days",
                            'priority': days_overdue  # Higher = more urgent
                        })
                except:
                    if status == 'overdue':
                        risks.append({
                            'asset': asset_name,
                            'severity': 'critical',
                            'days_overdue': 999,
                            'message': f"{asset_name} status: overdue",
                            'priority': 999
                        })
            
            # Check if due soon
            elif next_due:
                try:
                    next_date = datetime.fromisoformat(str(next_due)).date()
                    days_until = (next_date - today).days
                    
                    if 0 < days_until <= 30:
                        risks.append({
                            'asset': asset_name,
                            'severity': 'warning',
                            'days_until': days_until,
                            'message': f"{asset_name} due in {days_until} days",
                            'priority': 30 - days_until  # Sooner = higher priority
                        })
                except:
                    pass
        
        # Sort by priority (highest first) and take top 10
        self.risk_items = sorted(risks, key=lambda x: x['priority'], reverse=True)[:10]
    
    def _generate_recommendations(self):
        """Generate actionable recommendations based on data analysis"""
        recommendations = []
        
        # Compliance recommendations
        overdue_count = sum(1 for a in self.compliance_assets if a.get('compliance_status') == 'overdue')
        unknown_count = sum(1 for a in self.compliance_assets if a.get('compliance_status') == 'unknown')
        
        if overdue_count > 0:
            recommendations.append({
                'priority': 'critical',
                'icon': '🔴',
                'title': 'Urgent Compliance Action Required',
                'message': f"{overdue_count} compliance items are overdue. Schedule inspections immediately to maintain regulatory compliance."
            })
        
        if unknown_count > 3:
            recommendations.append({
                'priority': 'warning',
                'icon': '⚠️',
                'title': 'Document Missing Certificates',
                'message': f"{unknown_count} assets have unknown compliance status. Request certificates from contractors and update records."
            })
        
        # Insurance recommendations
        today = datetime.now().date()
        for policy in self.insurance[:5]:  # Check first 5 policies
            end_date_str = policy.get('end_date') or policy.get('expiry_date')
            if end_date_str:
                try:
                    end_date = datetime.fromisoformat(str(end_date_str)).date()
                    days_until = (end_date - today).days
                    
                    if days_until < 0:
                        recommendations.append({
                            'priority': 'critical',
                            'icon': '🔴',
                            'title': 'Insurance Policy Expired',
                            'message': f"Policy {policy.get('policy_number', 'Unknown')} has expired. Renew immediately to maintain coverage."
                        })
                    elif days_until < 30:
                        recommendations.append({
                            'priority': 'warning',
                            'icon': '⚠️',
                            'title': 'Insurance Renewal Due',
                            'message': f"Policy {policy.get('policy_number', 'Unknown')} expires in {days_until} days. Begin renewal process."
                        })
                except:
                    pass
        
        # Contract recommendations
        for contract in self.contracts[:10]:
            end_date_str = contract.get('end_date') or contract.get('contract_end')
            if end_date_str:
                try:
                    end_date = datetime.fromisoformat(str(end_date_str)).date()
                    days_until = (end_date - today).days
                    
                    if 0 < days_until < 90:
                        contractor = contract.get('contractor_name', 'Contractor')
                        service = contract.get('service_type', 'service')
                        recommendations.append({
                            'priority': 'info',
                            'icon': '📋',
                            'title': 'Contract Retender Planning',
                            'message': f"{contractor} {service} contract expires in {days_until} days. Begin retender process if renewal not planned."
                        })
                except:
                    pass
        
        # Budget recommendations
        current_year = datetime.now().year
        has_current_budget = any(
            str(current_year) in str(b.get('year_start', ''))
            for b in self.budgets
        )
        
        if not has_current_budget and self.budgets:
            recommendations.append({
                'priority': 'warning',
                'icon': '💰',
                'title': 'Current Year Budget Missing',
                'message': f"No budget found for {current_year}. Prepare and approve budget to ensure proper financial planning."
            })
        
        # Limit to top 8 recommendations
        self.recommendations = recommendations[:8]
    
    def get_rating(self) -> Tuple[str, str]:
        """Get overall rating label and color"""
        score = self.overall_score
        
        if score >= 80:
            return ('Excellent', BlocIQBrandColors.GREEN_SUCCESS)
        elif score >= 60:
            return ('Good', BlocIQBrandColors.GREEN_LIGHT)
        elif score >= 40:
            return ('Monitor', BlocIQBrandColors.ORANGE_WARNING)
        else:
            return ('Critical', BlocIQBrandColors.RED_CRITICAL)


class BuildingIntelligenceReport:
    """Professional Building Intelligence PDF Report Generator"""
    
    def __init__(self, supabase_client=None):
        self.supabase = supabase_client
        self.engine = None
        self.building_data = {}
        
        # Report styling
        self.styles = getSampleStyleSheet()
        self._setup_styles()
        
    def _setup_styles(self):
        """Setup custom styles with BlocIQ branding"""
        # Title style
        self.styles.add(ParagraphStyle(
            name='BlocIQTitle',
            parent=self.styles['Heading1'],
            fontSize=32,
            fontName='Helvetica-Bold',
            textColor=colors.HexColor(BlocIQBrandColors.PURPLE),
            spaceAfter=20,
            alignment=TA_CENTER
        ))
        
        # Section header
        self.styles.add(ParagraphStyle(
            name='SectionHeader',
            parent=self.styles['Heading2'],
            fontSize=18,
            fontName='Helvetica-Bold',
            textColor=colors.HexColor(BlocIQBrandColors.PURPLE),
            spaceAfter=12,
            spaceBefore=20
        ))
        
        # Subsection header
        self.styles.add(ParagraphStyle(
            name='SubSection',
            parent=self.styles['Heading3'],
            fontSize=14,
            fontName='Helvetica-Bold',
            textColor=colors.HexColor(BlocIQBrandColors.PURPLE_DARK),
            spaceAfter=8,
            spaceBefore=12
        ))
        
        # Score display
        self.styles.add(ParagraphStyle(
            name='ScoreDisplay',
            parent=self.styles['BodyText'],
            fontSize=48,
            fontName='Helvetica-Bold',
            alignment=TA_CENTER,
            spaceAfter=10
        ))
        
        # Recommendation item
        self.styles.add(ParagraphStyle(
            name='RecommendationItem',
            parent=self.styles['BodyText'],
            fontSize=10,
            leftIndent=20,
            spaceAfter=8
        ))
    
    def generate_report(self, building_id: str, output_dir: str = 'reports', local_data: Dict = None) -> str:
        """
        Generate Building Intelligence Report PDF
        
        Args:
            building_id: UUID of building
            output_dir: Output directory for PDF
            local_data: Optional local data dict
            
        Returns:
            Path to generated PDF
        """
        print(f"\n🎨 Generating Building Intelligence Report...")
        print(f"   Building ID: {building_id}")
        
        # Prepare output directory
        output_path = Path(output_dir) / building_id
        output_path.mkdir(exist_ok=True, parents=True)
        
        # Load data
        if local_data:
            print("   📊 Using local data")
            self.building_data = local_data
        else:
            print("   📊 Querying database")
            self.building_data = self._query_building_data(building_id)
        
        # Run intelligence analysis
        self.engine = BuildingIntelligenceEngine(self.building_data)
        self.engine.analyze()
        
        # Generate PDF
        pdf_filename = "building_intelligence_report.pdf"
        pdf_path = output_path / pdf_filename
        
        doc = SimpleDocTemplate(
            str(pdf_path),
            pagesize=A4,
            rightMargin=2*cm,
            leftMargin=2*cm,
            topMargin=2*cm,
            bottomMargin=2*cm
        )
        
        # Build document story
        story = []
        story.extend(self._build_cover_page())
        story.append(PageBreak())
        story.extend(self._build_executive_summary())
        story.append(PageBreak())
        story.extend(self._build_category_breakdown())
        story.extend(self._build_compliance_table())
        story.append(PageBreak())
        story.extend(self._build_insurance_contractors())
        story.extend(self._build_major_works_budget())
        story.append(PageBreak())
        story.extend(self._build_recommendations())
        story.extend(self._build_appendix())
        
        # Build PDF
        doc.build(story)
        
        print(f"   ✅ Report generated: {pdf_path}")
        return str(pdf_path)
    
    def _query_building_data(self, building_id: str) -> Dict:
        """Query building data from database"""
        # TODO: Implement database queries
        return {}
    
    def _build_cover_page(self) -> List:
        """Build professional cover page"""
        elements = []
        
        building = self.building_data.get('building', {})
        building_name = building.get('name', 'Unknown Building')
        building_address = building.get('address', '')
        
        # Spacer for top
        elements.append(Spacer(1, 1.5*inch))
        
        # Title
        elements.append(Paragraph("Building Intelligence Report", self.styles['BlocIQTitle']))
        elements.append(Spacer(1, 0.3*inch))
        
        # Building name
        building_name_p = Paragraph(
            f'<para alignment="center" fontSize="20" fontName="Helvetica-Bold">{building_name}</para>',
            self.styles['BodyText']
        )
        elements.append(building_name_p)
        elements.append(Spacer(1, 0.1*inch))
        
        # Building address and date
        building_info_p = Paragraph(
            f'<para alignment="center" fontSize="12" textColor="#6C757D">{building_address}<br/>Report Date: {datetime.now().strftime("%d %B %Y")}</para>',
            self.styles['BodyText']
        )
        elements.append(building_info_p)
        elements.append(Spacer(1, 0.8*inch))
        
        # Overall score with color bar
        rating, color = self.engine.get_rating()
        score_display_p = Paragraph(
            f'<para alignment="center"><font size="48" color="{color}"><b>{self.engine.overall_score:.1f}</b></font><font size="24">/100</font><br/><font size="18" color="{color}"><b>{rating}</b></font></para>',
            self.styles['BodyText']
        )
        elements.append(score_display_p)
        
        # Score bar visualization
        score_bar_path = self._create_score_bar(self.engine.overall_score)
        if score_bar_path:
            elements.append(Spacer(1, 0.3*inch))
            score_img = Image(score_bar_path, width=4*inch, height=0.5*inch)
            elements.append(score_img)
        
        elements.append(Spacer(1, 1*inch))
        
        # Prepared by
        footer_p = Paragraph(
            '<para alignment="center" fontSize="10" textColor="#6C757D"><i>Prepared by BlocIQ Onboarder AI</i><br/>Intelligent Building Management Platform</para>',
            self.styles['BodyText']
        )
        elements.append(footer_p)
        
        return elements
    
    def _create_score_bar(self, score: float) -> Optional[str]:
        """Create horizontal score bar with gradient"""
        try:
            fig, ax = plt.subplots(figsize=(8, 1))
            
            # Draw gradient bar
            gradient = np.linspace(0, 100, 256).reshape(1, -1)
            ax.imshow(gradient, aspect='auto', cmap='RdYlGn', extent=[0, 100, 0, 1])
            
            # Draw score marker
            ax.axvline(x=score, color='black', linewidth=3, linestyle='-')
            ax.text(score, 0.5, f' {score:.1f}', va='center', fontsize=14, fontweight='bold')
            
            # Styling
            ax.set_xlim(0, 100)
            ax.set_ylim(0, 1)
            ax.set_xticks([0, 25, 50, 75, 100])
            ax.set_yticks([])
            ax.spines['top'].set_visible(False)
            ax.spines['right'].set_visible(False)
            ax.spines['left'].set_visible(False)
            
            # Save
            score_bar_path = '/tmp/score_bar.png'
            plt.savefig(score_bar_path, bbox_inches='tight', dpi=150, transparent=True)
            plt.close()
            
            return score_bar_path
        except Exception as e:
            print(f"   ⚠️  Error creating score bar: {e}")
            return None
    
    def _build_executive_summary(self) -> List:
        """Build executive summary page"""
        elements = []
        
        elements.append(Paragraph("Executive Summary", self.styles['SectionHeader']))
        elements.append(Spacer(1, 0.2*inch))
        
        # Overall assessment
        rating, color = self.engine.get_rating()
        assessment_p = Paragraph(
            f'<b>Overall Assessment:</b> <font color="{color}"><b>{rating}</b></font> ({self.engine.overall_score:.1f}/100)',
            self.styles['BodyText']
        )
        elements.append(assessment_p)
        elements.append(Spacer(1, 0.2*inch))
        
        # Key metrics
        total_assets = len(self.engine.compliance_assets)
        compliant = sum(1 for a in self.engine.compliance_assets if a.get('compliance_status') == 'compliant')
        overdue = sum(1 for a in self.engine.compliance_assets if a.get('compliance_status') == 'overdue')
        unknown = sum(1 for a in self.engine.compliance_assets if a.get('compliance_status') == 'unknown')
        
        metrics_data = [
            ['Metric', 'Value'],
            ['Total Compliance Assets', str(total_assets)],
            [' ✅ Compliant', f"{compliant} ({compliant/total_assets*100:.0f}%)" if total_assets > 0 else "0"],
            [' ❌ Overdue', f"{overdue} ({overdue/total_assets*100:.0f}%)" if total_assets > 0 else "0"],
            [' ❔ Unknown Status', f"{unknown} ({unknown/total_assets*100:.0f}%)" if total_assets > 0 else "0"],
        ]
        
        metrics_table = Table(metrics_data, colWidths=[3*inch, 2*inch])
        metrics_table.setStyle(TableStyle([
            ('BACKGROUND', (0, 0), (-1, 0), colors.HexColor(BlocIQBrandColors.PURPLE)),
            ('TEXTCOLOR', (0, 0), (-1, 0), colors.whitesmoke),
            ('ALIGN', (0, 0), (-1, -1), 'LEFT'),
            ('FONTNAME', (0, 0), (-1, 0), 'Helvetica-Bold'),
            ('FONTSIZE', (0, 0), (-1, 0), 11),
            ('BOTTOMPADDING', (0, 0), (-1, 0), 12),
            ('BACKGROUND', (0, 1), (-1, -1), colors.HexColor(BlocIQBrandColors.GREY_LIGHT)),
            ('GRID', (0, 0), (-1, -1), 0.5, colors.grey),
            ('ROWBACKGROUNDS', (0, 1), (-1, -1), [colors.white, colors.HexColor(BlocIQBrandColors.GREY_LIGHT)])
        ]))
        
        elements.append(metrics_table)
        elements.append(Spacer(1, 0.3*inch))
        
        # Category breakdown
        if self.engine.category_scores:
            elements.append(Paragraph("Category Performance", self.styles['SubSection']))
            
            category_data = [['Category', 'Score', 'Assets', 'Status']]
            for category, data in sorted(self.engine.category_scores.items(), key=lambda x: x[1]['score'], reverse=True):
                score = data['score']
                asset_count = data['counts']['total']
                
                # Status icon based on score
                if score >= 80:
                    status = '✅ Excellent'
                elif score >= 60:
                    status = '🟢 Good'
                elif score >= 40:
                    status = '⚠️ Monitor'
                else:
                    status = '🔴 Critical'
                
                category_name = category.replace('_', ' ').title()
                category_data.append([category_name, f"{score:.1f}/100", str(asset_count), status])
            
            category_table = Table(category_data, colWidths=[2*inch, 1.2*inch, 1*inch, 1.3*inch])
            category_table.setStyle(TableStyle([
                ('BACKGROUND', (0, 0), (-1, 0), colors.HexColor(BlocIQBrandColors.PURPLE)),
                ('TEXTCOLOR', (0, 0), (-1, 0), colors.whitesmoke),
                ('ALIGN', (0, 0), (-1, -1), 'LEFT'),
                ('FONTNAME', (0, 0), (-1, 0), 'Helvetica-Bold'),
                ('FONTSIZE', (0, 0), (-1, -1), 9),
                ('BOTTOMPADDING', (0, 0), (-1, 0), 12),
                ('GRID', (0, 0), (-1, -1), 0.5, colors.grey),
                ('ROWBACKGROUNDS', (0, 1), (-1, -1), [colors.white, colors.HexColor(BlocIQBrandColors.GREY_LIGHT)])
            ]))
            
            elements.append(category_table)
            elements.append(Spacer(1, 0.3*inch))
        
        # Top 3 urgent risks
        if self.engine.risk_items:
            elements.append(Paragraph("⚠️  Top Urgent Risks", self.styles['SubSection']))
            
            for risk in self.engine.risk_items[:3]:
                icon = '🔴' if risk['severity'] == 'critical' else '⚠️'
                risk_text = f"{icon} <b>{risk['message']}</b>"
                elements.append(Paragraph(risk_text, self.styles['BodyText']))
                elements.append(Spacer(1, 0.1*inch))
        
        return elements
    
    def _build_category_breakdown(self) -> List:
        """Build visual category breakdown with charts"""
        elements = []
        
        elements.append(Paragraph("Category Breakdown", self.styles['SectionHeader']))
        elements.append(Spacer(1, 0.2*inch))
        
        # Create pie chart
        chart_path = self._create_compliance_pie_chart()
        if chart_path:
            chart_img = Image(chart_path, width=5*inch, height=3.5*inch)
            elements.append(chart_img)
            elements.append(Spacer(1, 0.3*inch))
        
        # Create category score bar chart
        category_chart_path = self._create_category_bar_chart()
        if category_chart_path:
            category_img = Image(category_chart_path, width=6*inch, height=3.5*inch)
            elements.append(category_img)
            elements.append(Spacer(1, 0.3*inch))
        
        return elements
    
    def _create_compliance_pie_chart(self) -> Optional[str]:
        """Create pie chart of compliance status distribution"""
        try:
            compliant = sum(1 for a in self.engine.compliance_assets if a.get('compliance_status') == 'compliant')
            due_soon = sum(1 for a in self.engine.compliance_assets if a.get('compliance_status') == 'due_soon')
            overdue = sum(1 for a in self.engine.compliance_assets if a.get('compliance_status') == 'overdue')
            unknown = sum(1 for a in self.engine.compliance_assets if a.get('compliance_status') == 'unknown')
            
            sizes = [compliant, due_soon, overdue, unknown]
            labels = ['Compliant', 'Due Soon', 'Overdue', 'Unknown']
            colors_list = [
                BlocIQBrandColors.GREEN_SUCCESS,
                BlocIQBrandColors.ORANGE_WARNING,
                BlocIQBrandColors.RED_CRITICAL,
                BlocIQBrandColors.GREY
            ]
            
            # Filter out zero values
            data = [(s, l, c) for s, l, c in zip(sizes, labels, colors_list) if s > 0]
            if not data:
                return None
            
            sizes, labels, colors_list = zip(*data)
            
            fig, ax = plt.subplots(figsize=(8, 6))
            ax.pie(sizes, labels=labels, colors=colors_list, autopct='%1.1f%%',
                   startangle=90, textprops={'fontsize': 11, 'weight': 'bold'})
            ax.axis('equal')
            plt.title('Compliance Status Distribution', fontsize=14, weight='bold', pad=20)
            
            chart_path = '/tmp/compliance_pie.png'
            plt.savefig(chart_path, bbox_inches='tight', dpi=150, facecolor='white')
            plt.close()
            
            return chart_path
        except Exception as e:
            print(f"   ⚠️  Error creating pie chart: {e}")
            return None
    
    def _create_category_bar_chart(self) -> Optional[str]:
        """Create bar chart of category scores"""
        try:
            if not self.engine.category_scores:
                return None
            
            categories = []
            scores = []
            colors_list = []
            
            for category, data in sorted(self.engine.category_scores.items(), key=lambda x: x[1]['score'], reverse=True):
                categories.append(category.replace('_', ' ').title())
                score = data['score']
                scores.append(score)
                
                # Color based on score
                if score >= 80:
                    colors_list.append(BlocIQBrandColors.GREEN_SUCCESS)
                elif score >= 60:
                    colors_list.append(BlocIQBrandColors.GREEN_LIGHT)
                elif score >= 40:
                    colors_list.append(BlocIQBrandColors.ORANGE_WARNING)
                else:
                    colors_list.append(BlocIQBrandColors.RED_CRITICAL)
            
            fig, ax = plt.subplots(figsize=(10, 6))
            bars = ax.barh(categories, scores, color=colors_list)
            
            # Add score labels
            for i, (bar, score) in enumerate(zip(bars, scores)):
                ax.text(score + 2, i, f'{score:.1f}', va='center', fontsize=10, weight='bold')
            
            ax.set_xlabel('Score', fontsize=12, weight='bold')
            ax.set_title('Category Performance Scores', fontsize=14, weight='bold', pad=20)
            ax.set_xlim(0, 110)
            ax.grid(axis='x', alpha=0.3)
            
            chart_path = '/tmp/category_bars.png'
            plt.savefig(chart_path, bbox_inches='tight', dpi=150, facecolor='white')
            plt.close()
            
            return chart_path
        except Exception as e:
            print(f"   ⚠️  Error creating bar chart: {e}")
            return None
    
    def _build_compliance_table(self) -> List:
        """Build condensed compliance table"""
        elements = []
        
        elements.append(Paragraph("Detailed Compliance Overview", self.styles['SectionHeader']))
        elements.append(Spacer(1, 0.2*inch))
        
        if not self.engine.compliance_assets:
            elements.append(Paragraph("No compliance data available.", self.styles['BodyText']))
            return elements
        
        # Build table with top 25 assets
        table_data = [['Category', 'Asset', 'Last Inspection', 'Next Due', 'Status']]
        
        for asset in self.engine.compliance_assets[:25]:
            category = asset.get('asset_type', 'general').replace('_', ' ').title()
            asset_name = asset.get('asset_name', 'Asset')
            if len(asset_name) > 30:
                asset_name = asset_name[:27] + '...'
            
            last_inspection = asset.get('last_inspection_date', 'Not recorded')
            if last_inspection and last_inspection != 'Not recorded':
                try:
                    dt = datetime.fromisoformat(str(last_inspection))
                    last_inspection = dt.strftime('%d/%m/%Y')
                except:
                    pass
            
            next_due = asset.get('next_due_date', 'Not scheduled')
            if next_due and next_due != 'Not scheduled':
                try:
                    dt = datetime.fromisoformat(str(next_due))
                    next_due = dt.strftime('%d/%m/%Y')
                except:
                    pass
            
            status = asset.get('compliance_status', 'unknown')
            status_display = {
                'compliant': '✅ Compliant',
                'due_soon': '⚠️ Due Soon',
                'overdue': '🔴 Overdue',
                'unknown': '❔ Unknown'
            }.get(status, status.title())
            
            table_data.append([category, asset_name, last_inspection, next_due, status_display])
        
        compliance_table = Table(table_data, colWidths=[1.8*cm, 4.5*cm, 3*cm, 3*cm, 2.7*cm])
        compliance_table.setStyle(TableStyle([
            ('BACKGROUND', (0, 0), (-1, 0), colors.HexColor(BlocIQBrandColors.PURPLE)),
            ('TEXTCOLOR', (0, 0), (-1, 0), colors.whitesmoke),
            ('ALIGN', (0, 0), (-1, -1), 'LEFT'),
            ('FONTNAME', (0, 0), (-1, 0), 'Helvetica-Bold'),
            ('FONTSIZE', (0, 0), (-1, 0), 8),
            ('FONTSIZE', (0, 1), (-1, -1), 7),
            ('BOTTOMPADDING', (0, 0), (-1, 0), 8),
            ('GRID', (0, 0), (-1, -1), 0.5, colors.grey),
            ('ROWBACKGROUNDS', (0, 1), (-1, -1), [colors.white, colors.HexColor(BlocIQBrandColors.GREY_LIGHT)]),
            ('VALIGN', (0, 0), (-1, -1), 'TOP')
        ]))
        
        elements.append(compliance_table)
        
        if len(self.engine.compliance_assets) > 25:
            elements.append(Spacer(1, 0.1*inch))
            remaining = len(self.engine.compliance_assets) - 25
            elements.append(Paragraph(f"<i>... and {remaining} additional compliance items</i>", self.styles['BodyText']))
        
        elements.append(Spacer(1, 0.3*inch))
        
        return elements
    
    def _build_insurance_contractors(self) -> List:
        """Build insurance and contractors overview"""
        elements = []
        
        elements.append(Paragraph("Insurance & Service Providers", self.styles['SectionHeader']))
        elements.append(Spacer(1, 0.2*inch))
        
        # Insurance summary
        if self.engine.insurance:
            elements.append(Paragraph("Current Insurance Coverage", self.styles['SubSection']))
            
            ins_data = [['Provider', 'Policy No.', 'Expiry', 'Status']]
            
            today = datetime.now().date()
            for policy in self.engine.insurance[:5]:
                provider = policy.get('insurer') or 'Unknown'
                if provider and len(provider) > 20:
                    provider = provider[:17] + '...'
                
                policy_no = policy.get('policy_number') or 'N/A'
                if policy_no and len(policy_no) > 15:
                    policy_no = policy_no[:12] + '...'
                
                expiry = policy.get('end_date') or policy.get('expiry_date', 'Not specified')
                if expiry and expiry != 'Not specified':
                    try:
                        dt = datetime.fromisoformat(str(expiry))
                        expiry = dt.strftime('%d/%m/%Y')
                    except:
                        pass
                
                status = '✅ Active'
                
                ins_data.append([provider, policy_no, expiry, status])
            
            ins_table = Table(ins_data, colWidths=[3.5*cm, 3*cm, 3*cm, 2.5*cm])
            ins_table.setStyle(TableStyle([
                ('BACKGROUND', (0, 0), (-1, 0), colors.HexColor(BlocIQBrandColors.PURPLE)),
                ('TEXTCOLOR', (0, 0), (-1, 0), colors.whitesmoke),
                ('ALIGN', (0, 0), (-1, -1), 'LEFT'),
                ('FONTNAME', (0, 0), (-1, 0), 'Helvetica-Bold'),
                ('FONTSIZE', (0, 0), (-1, -1), 9),
                ('BOTTOMPADDING', (0, 0), (-1, 0), 8),
                ('GRID', (0, 0), (-1, -1), 0.5, colors.grey),
                ('ROWBACKGROUNDS', (0, 1), (-1, -1), [colors.white, colors.HexColor(BlocIQBrandColors.GREY_LIGHT)])
            ]))
            
            elements.append(ins_table)
            elements.append(Spacer(1, 0.3*inch))
        
        # Contractors summary
        if self.engine.contracts:
            elements.append(Paragraph("Key Service Providers", self.styles['SubSection']))
            
            contract_data = [['Provider', 'Service', 'Status']]
            
            for contract in self.engine.contracts[:10]:
                contractor = contract.get('contractor_name') or 'Unknown'
                if contractor and len(contractor) > 25:
                    contractor = contractor[:22] + '...'
                
                service = (contract.get('service_type') or 'service').replace('_', ' ').title()
                status_val = contract.get('contract_status', 'active')
                
                status = {
                    'active': '✅ Active',
                    'expired': '❌ Expired',
                    'expiring_soon': '⚠️ Expiring'
                }.get(status_val, status_val.title())
                
                contract_data.append([contractor, service, status])
            
            contract_table = Table(contract_data, colWidths=[5*cm, 4*cm, 3*cm])
            contract_table.setStyle(TableStyle([
                ('BACKGROUND', (0, 0), (-1, 0), colors.HexColor(BlocIQBrandColors.PURPLE)),
                ('TEXTCOLOR', (0, 0), (-1, 0), colors.whitesmoke),
                ('ALIGN', (0, 0), (-1, -1), 'LEFT'),
                ('FONTNAME', (0, 0), (-1, 0), 'Helvetica-Bold'),
                ('FONTSIZE', (0, 0), (-1, -1), 9),
                ('BOTTOMPADDING', (0, 0), (-1, 0), 8),
                ('GRID', (0, 0), (-1, -1), 0.5, colors.grey),
                ('ROWBACKGROUNDS', (0, 1), (-1, -1), [colors.white, colors.HexColor(BlocIQBrandColors.GREY_LIGHT)])
            ]))
            
            elements.append(contract_table)
            elements.append(Spacer(1, 0.3*inch))
        
        return elements
    
    def _build_major_works_budget(self) -> List:
        """Build major works and budget summary"""
        elements = []
        
        # Major works
        if self.engine.major_works:
            elements.append(Paragraph("Major Works Projects", self.styles['SubSection']))
            
            for project in self.engine.major_works[:5]:
                project_name = project.get('project_name', 'Project')
                status = project.get('status', 'planned').title()
                
                project_text = f"<b>{project_name}</b> - Status: {status}"
                elements.append(Paragraph(project_text, self.styles['BodyText']))
                elements.append(Spacer(1, 0.1*inch))
            
            elements.append(Spacer(1, 0.2*inch))
        
        # Budget summary
        if self.engine.budgets:
            elements.append(Paragraph("Budget Summary", self.styles['SubSection']))
            
            budget_text = f"Budget documents on record: {len(self.engine.budgets)}"
            elements.append(Paragraph(budget_text, self.styles['BodyText']))
            elements.append(Spacer(1, 0.3*inch))
        
        return elements
    
    def _build_recommendations(self) -> List:
        """Build action recommendations section"""
        elements = []
        
        elements.append(Paragraph("Recommended Actions", self.styles['SectionHeader']))
        elements.append(Spacer(1, 0.2*inch))
        
        if not self.engine.recommendations:
            elements.append(Paragraph("No urgent actions required at this time.", self.styles['BodyText']))
            return elements
        
        for rec in self.engine.recommendations:
            icon = rec['icon']
            title = rec['title']
            message = rec['message']
            
            rec_text = f"{icon} <b>{title}</b><br/>{message}"
            elements.append(Paragraph(rec_text, self.styles['RecommendationItem']))
            elements.append(Spacer(1, 0.15*inch))
        
        return elements
    
    def _build_appendix(self) -> List:
        """Build technical appendix"""
        elements = []
        
        elements.append(Paragraph("Technical Appendix", self.styles['SectionHeader']))
        elements.append(Spacer(1, 0.2*inch))
        
        # Document statistics
        stats_text = (
            f"<b>Report Metadata</b><br/>"
            f"Generated: {datetime.now().strftime('%d %B %Y %H:%M')}<br/>"
            f"Total Compliance Assets: {len(self.engine.compliance_assets)}<br/>"
            f"Total Contracts: {len(self.engine.contracts)}<br/>"
            f"Total Insurance Policies: {len(self.engine.insurance)}<br/>"
            f"Analysis Engine: BlocIQ Intelligence v2.0<br/>"
            f"<br/>"
            f"<i>This report was generated automatically by BlocIQ's AI-powered building intelligence platform.</i>"
        )
        elements.append(Paragraph(stats_text, self.styles['BodyText']))
        
        return elements


# Convenience function for external use
def generate_building_intelligence_report(building_id: str, output_dir: str, local_data: Dict = None) -> str:
    """
    Generate Building Intelligence Report
    
    Args:
        building_id: Building UUID
        output_dir: Output directory
        local_data: Optional local data dict
        
    Returns:
        Path to generated PDF
    """
    generator = BuildingIntelligenceReport()
    return generator.generate_report(building_id, output_dir, local_data)
