"""
BlocIQ Building Health Check - Simple & Readable Version
Clean, text-based PDF with all essential information clearly visible
"""

import os
from datetime import datetime
from pathlib import Path
from typing import Dict, List
from collections import defaultdict

from reportlab.lib import colors
from reportlab.lib.pagesizes import A4, letter
from reportlab.lib.styles import getSampleStyleSheet, ParagraphStyle
from reportlab.lib.units import inch
from reportlab.lib.enums import TA_CENTER, TA_LEFT, TA_RIGHT
from reportlab.platypus import (
    SimpleDocTemplate, Paragraph, Spacer, Table, TableStyle,
    PageBreak
)
from reportlab.pdfgen import canvas


class SimpleBuildingHealthCheck:
    """Simplified, highly readable PDF generator"""
    
    def __init__(self):
        self.styles = getSampleStyleSheet()
        self._setup_custom_styles()
    
    def _setup_custom_styles(self):
        """Create simple, readable text styles"""
        # Title
        self.styles.add(ParagraphStyle(
            name='Title',
            parent=self.styles['Heading1'],
            fontSize=24,
            textColor=colors.HexColor('#5E48E8'),
            spaceAfter=12,
            alignment=TA_CENTER,
            fontName='Helvetica-Bold'
        ))
        
        # Section
        self.styles.add(ParagraphStyle(
            name='Section',
            parent=self.styles['Heading2'],
            fontSize=16,
            textColor=colors.HexColor('#2C3E50'),
            spaceAfter=10,
            spaceBefore=20,
            fontName='Helvetica-Bold'
        ))
        
        # Normal text
        self.styles.add(ParagraphStyle(
            name='Normal',
            parent=self.styles['BodyText'],
            fontSize=11,
            leading=14,
            textColor=colors.black
        ))
    
    def generate(self, building_data: Dict, output_path: str) -> str:
        """Generate simple, readable PDF"""
        print("📊 Generating Simple Building Health Check PDF...")
        
        # Create PDF
        doc = SimpleDocTemplate(
            output_path,
            pagesize=letter,
            rightMargin=0.75*inch,
            leftMargin=0.75*inch,
            topMargin=0.75*inch,
            bottomMargin=0.75*inch
        )
        
        elements = []
        
        # Build sections
        elements.extend(self._build_title(building_data))
        elements.extend(self._build_summary(building_data))
        elements.append(PageBreak())
        elements.extend(self._build_compliance(building_data))
        elements.append(PageBreak())
        elements.extend(self._build_financial(building_data))
        elements.append(PageBreak())
        elements.extend(self._build_contractors(building_data))
        
        # Generate PDF
        doc.build(elements)
        print(f"   ✅ PDF generated: {output_path}")
        
        return output_path
    
    def _build_title(self, data: Dict) -> List:
        """Build title page"""
        elements = []
        
        building = data.get('building', {})
        building_name = building.get('name', 'Unknown Building')
        address = building.get('address', '')
        
        elements.append(Spacer(1, 1*inch))
        elements.append(Paragraph("BlocIQ Building Health Check", self.styles['Title']))
        elements.append(Spacer(1, 0.3*inch))
        elements.append(Paragraph(
            f"<b>{building_name}</b>",
            ParagraphStyle('BuildingName', parent=self.styles['Normal'], fontSize=18, alignment=TA_CENTER)
        ))
        if address:
            elements.append(Paragraph(
                address,
                ParagraphStyle('Address', parent=self.styles['Normal'], alignment=TA_CENTER, textColor=colors.grey)
            ))
        elements.append(Spacer(1, 0.5*inch))
        elements.append(Paragraph(
            f"Generated: {datetime.now().strftime('%d %B %Y at %H:%M')}",
            ParagraphStyle('Date', parent=self.styles['Normal'], fontSize=10, alignment=TA_CENTER, textColor=colors.grey)
        ))
        
        return elements
    
    def _build_summary(self, data: Dict) -> List:
        """Build executive summary"""
        elements = []
        
        elements.append(Paragraph("EXECUTIVE SUMMARY", self.styles['Section']))
        elements.append(Spacer(1, 0.2*inch))
        
        # Count key metrics
        units = data.get('units', [])
        compliance_assets = data.get('compliance_assets', [])
        contracts = data.get('contracts', [])
        budgets = data.get('budgets', [])
        
        # Compliance status
        compliant = sum(1 for a in compliance_assets if a.get('compliance_status') == 'compliant')
        overdue = sum(1 for a in compliance_assets if a.get('compliance_status') == 'overdue')
        unknown = sum(1 for a in compliance_assets if a.get('compliance_status') == 'unknown')
        total_assets = len(compliance_assets)
        
        # Create summary table
        summary_data = [
            ['METRIC', 'VALUE'],
            ['Total Units', str(len(units))],
            ['Compliance Assets', str(total_assets)],
            ['  - Compliant', f"{compliant} ({(compliant/total_assets*100):.0f}%)" if total_assets > 0 else "0"],
            ['  - Overdue/At Risk', f"{overdue} ({(overdue/total_assets*100):.0f}%)" if total_assets > 0 else "0"],
            ['  - Unknown Status', f"{unknown} ({(unknown/total_assets*100):.0f}%)" if total_assets > 0 else "0"],
            ['Active Contracts', str(len(contracts))],
            ['Budgets', str(len(budgets))],
        ]
        
        table = Table(summary_data, colWidths=[3*inch, 2*inch])
        table.setStyle(TableStyle([
            ('BACKGROUND', (0, 0), (-1, 0), colors.HexColor('#5E48E8')),
            ('TEXTCOLOR', (0, 0), (-1, 0), colors.white),
            ('ALIGN', (0, 0), (-1, -1), 'LEFT'),
            ('FONTNAME', (0, 0), (-1, 0), 'Helvetica-Bold'),
            ('FONTSIZE', (0, 0), (-1, -1), 10),
            ('BOTTOMPADDING', (0, 0), (-1, -1), 8),
            ('TOPPADDING', (0, 0), (-1, -1), 8),
            ('GRID', (0, 0), (-1, -1), 0.5, colors.grey),
            ('ROWBACKGROUNDS', (0, 1), (-1, -1), [colors.white, colors.HexColor('#F8F9FA')])
        ]))
        
        elements.append(table)
        
        # Status indicator
        if total_assets > 0:
            compliance_rate = (compliant / total_assets * 100)
            elements.append(Spacer(1, 0.3*inch))
            
            if compliance_rate >= 80:
                status = "✅ GOOD - Most assets are compliant"
                status_color = colors.green
            elif compliance_rate >= 60:
                status = "⚠️  FAIR - Some assets need attention"
                status_color = colors.orange
            else:
                status = "❌ ATTENTION NEEDED - Many assets overdue"
                status_color = colors.red
            
            elements.append(Paragraph(
                f'<font color="{status_color}"><b>{status}</b></font>',
                self.styles['Normal']
            ))
        
        return elements
    
    def _build_compliance(self, data: Dict) -> List:
        """Build compliance assets section"""
        elements = []
        
        elements.append(Paragraph("COMPLIANCE ASSETS", self.styles['Section']))
        elements.append(Spacer(1, 0.2*inch))
        
        compliance_assets = data.get('compliance_assets', [])
        
        if not compliance_assets:
            elements.append(Paragraph("No compliance assets recorded.", self.styles['Normal']))
            return elements
        
        # Group by category
        by_category = defaultdict(list)
        for asset in compliance_assets:
            category = asset.get('compliance_category', 'other')
            by_category[category].append(asset)
        
        # Show each category
        for category, assets in sorted(by_category.items()):
            category_title = category.replace('_', ' ').title()
            elements.append(Paragraph(
                f"<b>{category_title}</b> ({len(assets)} assets)",
                ParagraphStyle('CategoryTitle', parent=self.styles['Normal'], fontSize=12, textColor=colors.HexColor('#5E48E8'))
            ))
            elements.append(Spacer(1, 0.1*inch))
            
            # Create table for this category
            table_data = [['Asset Name', 'Status', 'Next Due']]
            
            for asset in assets[:10]:  # Limit to 10 per category for readability
                name = asset.get('asset_name', 'Unknown')[:40]
                status = asset.get('compliance_status', 'unknown')
                next_due = asset.get('next_due_date', 'Not set')
                
                # Format status with color
                if status == 'compliant':
                    status_text = '✅ Compliant'
                elif status == 'overdue':
                    status_text = '❌ Overdue'
                elif status == 'due_soon':
                    status_text = '⚠️  Due Soon'
                else:
                    status_text = '❔ Unknown'
                
                if isinstance(next_due, str) and next_due != 'Not set':
                    try:
                        next_due = datetime.fromisoformat(next_due).strftime('%d %b %Y')
                    except:
                        pass
                
                table_data.append([name, status_text, str(next_due)])
            
            if len(assets) > 10:
                table_data.append([f"... and {len(assets) - 10} more", '', ''])
            
            table = Table(table_data, colWidths=[3*inch, 1.5*inch, 1.5*inch])
            table.setStyle(TableStyle([
                ('BACKGROUND', (0, 0), (-1, 0), colors.HexColor('#E9ECEF')),
                ('TEXTCOLOR', (0, 0), (-1, 0), colors.black),
                ('ALIGN', (0, 0), (-1, -1), 'LEFT'),
                ('FONTNAME', (0, 0), (-1, 0), 'Helvetica-Bold'),
                ('FONTSIZE', (0, 0), (-1, -1), 9),
                ('BOTTOMPADDING', (0, 0), (-1, -1), 6),
                ('TOPPADDING', (0, 0), (-1, -1), 6),
                ('GRID', (0, 0), (-1, -1), 0.5, colors.lightgrey),
            ]))
            
            elements.append(table)
            elements.append(Spacer(1, 0.3*inch))
        
        return elements
    
    def _build_financial(self, data: Dict) -> List:
        """Build financial section"""
        elements = []
        
        elements.append(Paragraph("FINANCIAL OVERVIEW", self.styles['Section']))
        elements.append(Spacer(1, 0.2*inch))
        
        budgets = data.get('budgets', [])
        insurance = data.get('insurance_policies', [])
        
        # Budgets
        if budgets:
            elements.append(Paragraph("<b>Budgets</b>", self.styles['Normal']))
            elements.append(Spacer(1, 0.1*inch))
            
            budget_data = [['Period', 'Total Amount', 'Status']]
            for budget in budgets[:5]:
                period = budget.get('period', 'Unknown')
                amount = budget.get('total_amount', 0)
                status = budget.get('status', 'draft')
                
                amount_str = f"£{amount:,.2f}" if amount else "Not set"
                budget_data.append([period, amount_str, status.title()])
            
            table = Table(budget_data, colWidths=[2*inch, 2*inch, 1.5*inch])
            table.setStyle(TableStyle([
                ('BACKGROUND', (0, 0), (-1, 0), colors.HexColor('#E9ECEF')),
                ('FONTNAME', (0, 0), (-1, 0), 'Helvetica-Bold'),
                ('FONTSIZE', (0, 0), (-1, -1), 9),
                ('BOTTOMPADDING', (0, 0), (-1, -1), 6),
                ('TOPPADDING', (0, 0), (-1, -1), 6),
                ('GRID', (0, 0), (-1, -1), 0.5, colors.lightgrey),
            ]))
            elements.append(table)
            elements.append(Spacer(1, 0.3*inch))
        
        # Insurance
        if insurance:
            elements.append(Paragraph("<b>Insurance Policies</b>", self.styles['Normal']))
            elements.append(Spacer(1, 0.1*inch))
            
            for policy in insurance[:3]:
                provider = policy.get('provider', 'Unknown')
                policy_no = policy.get('policy_number', 'Not recorded')
                expiry = policy.get('expiry_date', 'Not set')
                
                if isinstance(expiry, str) and expiry != 'Not set':
                    try:
                        expiry = datetime.fromisoformat(expiry).strftime('%d %b %Y')
                    except:
                        pass
                
                elements.append(Paragraph(
                    f"• <b>{provider}</b> - Policy: {policy_no} - Expires: {expiry}",
                    self.styles['Normal']
                ))
        
        if not budgets and not insurance:
            elements.append(Paragraph("No financial data recorded.", self.styles['Normal']))
        
        return elements
    
    def _build_contractors(self, data: Dict) -> List:
        """Build contractors section"""
        elements = []
        
        elements.append(Paragraph("CONTRACTORS & CONTRACTS", self.styles['Section']))
        elements.append(Spacer(1, 0.2*inch))
        
        contracts = data.get('contracts', [])
        
        if not contracts:
            elements.append(Paragraph("No contracts recorded.", self.styles['Normal']))
            return elements
        
        contract_data = [['Contractor', 'Service Type', 'Status', 'End Date']]
        
        for contract in contracts[:15]:
            contractor = contract.get('contractor_name', 'Unknown')[:30]
            service = contract.get('service_type', 'General')
            status = contract.get('contract_status', 'unknown')
            end_date = contract.get('end_date', 'Not set')
            
            if isinstance(end_date, str) and end_date != 'Not set':
                try:
                    end_date = datetime.fromisoformat(end_date).strftime('%d %b %Y')
                except:
                    pass
            
            contract_data.append([contractor, service, status.title(), str(end_date)])
        
        table = Table(contract_data, colWidths=[2*inch, 1.8*inch, 1*inch, 1.2*inch])
        table.setStyle(TableStyle([
            ('BACKGROUND', (0, 0), (-1, 0), colors.HexColor('#E9ECEF')),
            ('FONTNAME', (0, 0), (-1, 0), 'Helvetica-Bold'),
            ('FONTSIZE', (0, 0), (-1, -1), 9),
            ('BOTTOMPADDING', (0, 0), (-1, -1), 6),
            ('TOPPADDING', (0, 0), (-1, -1), 6),
            ('GRID', (0, 0), (-1, -1), 0.5, colors.lightgrey),
        ]))
        
        elements.append(table)
        
        return elements


def generate_simple_health_check(building_data: Dict, output_path: str) -> str:
    """
    Generate a simple, readable building health check PDF
    
    Args:
        building_data: Dictionary with building information
        output_path: Path where PDF should be saved
        
    Returns:
        Path to generated PDF
    """
    generator = SimpleBuildingHealthCheck()
    return generator.generate(building_data, output_path)
