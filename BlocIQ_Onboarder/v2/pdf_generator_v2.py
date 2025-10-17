"""
PDF Report Generator V2
=======================
Generates client-ready PDF report from extracted_data
Professional formatting, all sections included
"""

from reportlab.lib.pagesizes import letter, A4
from reportlab.lib.styles import getSampleStyleSheet, ParagraphStyle
from reportlab.lib.units import inch
from reportlab.lib import colors
from reportlab.platypus import SimpleDocTemplate, Table, TableStyle, Paragraph, Spacer, PageBreak
from reportlab.lib.enums import TA_CENTER, TA_LEFT, TA_RIGHT
from datetime import datetime
from typing import Dict, List


class PDFGeneratorV2:
    """
    Generate comprehensive PDF report from extracted data
    Mirrors SQL data exactly (no residual/placeholder data)
    """
    
    def __init__(self, extracted_data: Dict, output_filename: str):
        self.data = extracted_data
        self.filename = output_filename
        self.doc = SimpleDocTemplate(output_filename, pagesize=A4)
        self.styles = getSampleStyleSheet()
        self.story = []
        
        # Custom styles
        self._setup_styles()
    
    def _setup_styles(self):
        """Setup custom paragraph styles"""
        self.title_style = ParagraphStyle(
            'CustomTitle',
            parent=self.styles['Heading1'],
            fontSize=24,
            textColor=colors.HexColor('#1a1a1a'),
            spaceAfter=30,
            alignment=TA_CENTER
        )
        
        self.heading_style = ParagraphStyle(
            'CustomHeading',
            parent=self.styles['Heading2'],
            fontSize=14,
            textColor=colors.HexColor('#2c3e50'),
            spaceAfter=12,
            spaceBefore=20
        )
        
        self.subheading_style = ParagraphStyle(
            'CustomSubHeading',
            parent=self.styles['Heading3'],
            fontSize=11,
            textColor=colors.HexColor('#34495e'),
            spaceAfter=8
        )
    
    def generate(self):
        """Generate complete PDF report"""
        # Cover page
        self._add_cover_page()
        self.story.append(PageBreak())
        
        # Sections
        self._add_building_profile()
        self._add_units_leaseholders()
        self._add_budgets()
        self._add_compliance_assets()
        self._add_contractors()
        self._add_contracts()
        self._add_accounts()
        self._add_ai_lease_analysis()  # AI-powered lease analysis (Option 2: AI-Only)
        self._add_asset_register()
        
        # Build PDF
        self.doc.build(self.story)
        print(f"      PDF generated: {self.filename}")
    
    def _add_cover_page(self):
        """Generate cover page"""
        building = self.data['building']
        
        # Title
        self.story.append(Spacer(1, 2*inch))
        title = Paragraph("COMPLETE PROPERTY DATA REPORT", self.title_style)
        self.story.append(title)
        
        subtitle = Paragraph("Comprehensive Extraction & Analysis", self.styles['Heading3'])
        self.story.append(subtitle)
        self.story.append(Spacer(1, 0.5*inch))
        
        # Building name
        building_name = Paragraph(
            f"<b>{building.get('name', 'Unknown Building')}</b>",
            self.styles['Heading2']
        )
        self.story.append(building_name)
        
        # Stats table
        self.story.append(Spacer(1, 0.5*inch))
        
        stats_data = [
            ['Units', str(len(self.data.get('units', [])))],
            ['Leaseholders', str(len([u for u in self.data.get('units', []) if u.get('leaseholder_name')]))],
            ['Annual Budget', f"£{sum(b.get('total_budget', 0) for b in self.data.get('budgets', [])):,.0f}" if self.data.get('budgets') else '—'],
            ['Compliance Assets', str(len(self.data.get('compliance_assets', [])))],
            ['Contractors', str(len(self.data.get('contractors', [])))],
        ]
        
        stats_table = Table(stats_data, colWidths=[2.5*inch, 2.5*inch])
        stats_table.setStyle(TableStyle([
            ('ALIGN', (0, 0), (-1, -1), 'LEFT'),
            ('FONTNAME', (0, 0), (0, -1), 'Helvetica-Bold'),
            ('FONTSIZE', (0, 0), (-1, -1), 12),
            ('BOTTOMPADDING', (0, 0), (-1, -1), 12),
        ]))
        self.story.append(stats_table)
        
        # Footer
        self.story.append(Spacer(1, 1*inch))
        footer = Paragraph(
            f"Generated: {datetime.now().strftime('%d %B %Y')}",
            self.styles['Normal']
        )
        self.story.append(footer)
    
    def _add_building_profile(self):
        """Building profile section"""
        building = self.data['building']
        
        self.story.append(Paragraph("BUILDING PROFILE & CHARACTERISTICS", self.heading_style))
        
        # Basic info
        data = [
            ['Building Name', building.get('name', '—')],
            ['Address', building.get('address', '—')],
            ['Postcode', building.get('postcode', '—')],
            ['Number of Units', str(len(self.data.get('units', [])))],
            ['Number of Floors', str(building.get('number_of_floors', '—'))],
            ['Height', f"{building.get('building_height_meters', '—')}m" if building.get('building_height_meters') else '—'],
            ['Has Basement', 'Yes' if building.get('has_basement') else 'No'],
            ['BSA Status', building.get('bsa_status', 'Not HRB')],
            ['Is HRB', 'Yes' if building.get('is_hrb') else 'No'],
            ['Construction Type', building.get('construction_type', '—')],
        ]
        
        table = Table(data, colWidths=[2*inch, 4*inch])
        table.setStyle(TableStyle([
            ('BACKGROUND', (0, 0), (0, -1), colors.HexColor('#f5f5f5')),
            ('ALIGN', (0, 0), (-1, -1), 'LEFT'),
            ('FONTNAME', (0, 0), (0, -1), 'Helvetica-Bold'),
            ('FONTSIZE', (0, 0), (-1, -1), 9),
            ('GRID', (0, 0), (-1, -1), 0.5, colors.grey),
            ('PADDING', (0, 0), (-1, -1), 6),
        ]))
        self.story.append(table)
        self.story.append(Spacer(1, 0.3*inch))
    
    def _add_units_leaseholders(self):
        """Units and leaseholders table"""
        units = self.data.get('units', [])
        
        if not units:
            return
        
        self.story.append(Paragraph("UNITS & LEASEHOLDERS", self.heading_style))
        
        # Header
        data = [['Unit', 'Leaseholder', 'Floor', 'Apportionment %']]
        
        # Rows
        for unit in units:
            data.append([
                unit.get('unit_number', '—'),
                unit.get('leaseholder_name', '—'),
                str(unit.get('floor', '—')),
                f"{unit.get('apportionment', 0):.2f}%" if unit.get('apportionment') else '—'
            ])
        
        table = Table(data, colWidths=[1.2*inch, 2.5*inch, 1*inch, 1.3*inch])
        table.setStyle(TableStyle([
            ('BACKGROUND', (0, 0), (-1, 0), colors.HexColor('#2c3e50')),
            ('TEXTCOLOR', (0, 0), (-1, 0), colors.whitesmoke),
            ('ALIGN', (0, 0), (-1, -1), 'LEFT'),
            ('FONTNAME', (0, 0), (-1, 0), 'Helvetica-Bold'),
            ('FONTSIZE', (0, 0), (-1, -1), 8),
            ('GRID', (0, 0), (-1, -1), 0.5, colors.grey),
            ('PADDING', (0, 0), (-1, -1), 4),
        ]))
        self.story.append(table)
        self.story.append(Spacer(1, 0.3*inch))
    
    def _add_budgets(self):
        """Budget summary"""
        budgets = self.data.get('budgets', [])
        
        if not budgets:
            return
        
        self.story.append(Paragraph("BUDGETS", self.heading_style))
        
        for budget in budgets:
            self.story.append(Paragraph(
                f"Budget Year: {budget.get('budget_year', '—')} | Total: £{budget.get('total_budget', 0):,.0f}",
                self.subheading_style
            ))
            
            # Show top 10 line items
            line_items = budget.get('line_items', [])[:10]
            if line_items:
                data = [['Category', 'Description', 'Amount']]
                for item in line_items:
                    data.append([
                        item.get('category', '—'),
                        item.get('description', '—')[:50],
                        f"£{item.get('annual_amount', 0):,.0f}"
                    ])
                
                table = Table(data, colWidths=[1.2*inch, 3*inch, 1.8*inch])
                table.setStyle(TableStyle([
                    ('BACKGROUND', (0, 0), (-1, 0), colors.HexColor('#f5f5f5')),
                    ('ALIGN', (2, 0), (2, -1), 'RIGHT'),
                    ('FONTNAME', (0, 0), (-1, 0), 'Helvetica-Bold'),
                    ('FONTSIZE', (0, 0), (-1, -1), 8),
                    ('GRID', (0, 0), (-1, -1), 0.5, colors.grey),
                    ('PADDING', (0, 0), (-1, -1), 4),
                ]))
                self.story.append(table)
        
        self.story.append(Spacer(1, 0.3*inch))
    
    def _add_compliance_assets(self):
        """Compliance assets table"""
        assets = self.data.get('compliance_assets', [])
        
        if not assets:
            return
        
        self.story.append(Paragraph("COMPLIANCE ASSETS", self.heading_style))
        
        # Filter to current/recent assets only (remove duplicates)
        unique_assets = {}
        for asset in assets:
            asset_type = asset.get('asset_type', 'Unknown')
            if asset_type not in unique_assets or asset.get('is_current'):
                unique_assets[asset_type] = asset
        
        # Table
        data = [['Asset Type', 'Last Inspection', 'Next Due', 'Status']]
        
        for asset in list(unique_assets.values())[:20]:  # Limit to 20
            data.append([
                asset.get('asset_type', '—'),
                asset.get('assessment_date', '—')[:10] if asset.get('assessment_date') else '—',
                asset.get('next_due_date', '—')[:10] if asset.get('next_due_date') else '—',
                asset.get('status', '—')
            ])
        
        table = Table(data, colWidths=[2*inch, 1.5*inch, 1.5*inch, 1*inch])
        table.setStyle(TableStyle([
            ('BACKGROUND', (0, 0), (-1, 0), colors.HexColor('#2c3e50')),
            ('TEXTCOLOR', (0, 0), (-1, 0), colors.whitesmoke),
            ('ALIGN', (0, 0), (-1, -1), 'LEFT'),
            ('FONTNAME', (0, 0), (-1, 0), 'Helvetica-Bold'),
            ('FONTSIZE', (0, 0), (-1, -1), 8),
            ('GRID', (0, 0), (-1, -1), 0.5, colors.grey),
            ('PADDING', (0, 0), (-1, -1), 4),
        ]))
        self.story.append(table)
        self.story.append(Spacer(1, 0.3*inch))
    
    def _add_contractors(self):
        """Contractors summary"""
        contractors = self.data.get('contractors', [])
        
        if not contractors:
            return
        
        self.story.append(Paragraph("CONTRACTORS & SERVICE PROVIDERS", self.heading_style))
        
        data = [['Contractor', 'Services', 'Annual Value']]
        
        for contractor in contractors:
            services = ', '.join(contractor.get('services_provided', []))[:60]
            data.append([
                contractor.get('contractor_name', '—'),
                services,
                f"£{contractor.get('annual_value', 0):,.0f}" if contractor.get('annual_value') else '—'
            ])
        
        table = Table(data, colWidths=[2*inch, 3*inch, 1*inch])
        table.setStyle(TableStyle([
            ('BACKGROUND', (0, 0), (-1, 0), colors.HexColor('#f5f5f5')),
            ('ALIGN', (2, 0), (2, -1), 'RIGHT'),
            ('FONTNAME', (0, 0), (-1, 0), 'Helvetica-Bold'),
            ('FONTSIZE', (0, 0), (-1, -1), 8),
            ('GRID', (0, 0), (-1, -1), 0.5, colors.grey),
            ('PADDING', (0, 0), (-1, -1), 4),
        ]))
        self.story.append(table)
        self.story.append(Spacer(1, 0.3*inch))
    
    def _add_contracts(self):
        """Maintenance contracts"""
        contracts = self.data.get('contracts', [])
        
        if not contracts:
            return
        
        self.story.append(Paragraph("MAINTENANCE CONTRACTS", self.heading_style))
        
        data = [['Contractor', 'Service', 'End Date', 'Status']]
        
        for contract in contracts:
            data.append([
                contract.get('contractor_name', '—'),
                contract.get('service_type', '—'),
                contract.get('end_date', '—')[:10] if contract.get('end_date') else '—',
                'Current' if contract.get('is_current') else 'Expired'
            ])
        
        table = Table(data, colWidths=[2*inch, 2*inch, 1.2*inch, 0.8*inch])
        table.setStyle(TableStyle([
            ('BACKGROUND', (0, 0), (-1, 0), colors.HexColor('#f5f5f5')),
            ('FONTNAME', (0, 0), (-1, 0), 'Helvetica-Bold'),
            ('FONTSIZE', (0, 0), (-1, -1), 8),
            ('GRID', (0, 0), (-1, -1), 0.5, colors.grey),
            ('PADDING', (0, 0), (-1, -1), 4),
        ]))
        self.story.append(table)
        self.story.append(Spacer(1, 0.3*inch))
    
    def _add_accounts(self):
        """Service charge accounts"""
        accounts = self.data.get('accounts', [])
        
        if not accounts:
            return
        
        self.story.append(Paragraph("SERVICE CHARGE ACCOUNTS", self.heading_style))
        
        data = [['Financial Year', 'Status', 'Total Expenditure']]
        
        for account in accounts:
            status = 'Approved' if account.get('is_approved') else 'Draft'
            data.append([
                account.get('financial_year', '—'),
                status,
                f"£{account.get('total_expenditure', 0):,.0f}" if account.get('total_expenditure') else '—'
            ])
        
        table = Table(data, colWidths=[2*inch, 2*inch, 2*inch])
        table.setStyle(TableStyle([
            ('BACKGROUND', (0, 0), (-1, 0), colors.HexColor('#f5f5f5')),
            ('ALIGN', (2, 0), (2, -1), 'RIGHT'),
            ('FONTNAME', (0, 0), (-1, 0), 'Helvetica-Bold'),
            ('FONTSIZE', (0, 0), (-1, -1), 8),
            ('GRID', (0, 0), (-1, -1), 0.5, colors.grey),
            ('PADDING', (0, 0), (-1, -1), 4),
        ]))
        self.story.append(table)
        self.story.append(Spacer(1, 0.3*inch))
    
    def _add_ai_lease_analysis(self):
        """
        AI-Powered Lease Analysis (LeaseClear Quality)
        Comprehensive section with clause references
        """
        ai_analyses = self.data.get('lease_ai_analyses', [])
        
        if not ai_analyses:
            return
        
        # Add page break before lease section
        self.story.append(PageBreak())
        
        # Main heading
        self.story.append(Paragraph("LEASE ANALYSIS - COMPREHENSIVE SUMMARY", self.heading_style))
        self.story.append(Spacer(1, 0.2*inch))
        
        # Analyze each lease
        for i, lease_data in enumerate(ai_analyses, 1):
            ai_result = lease_data.get('ai_analysis', {})
            filename = lease_data.get('filename', f'Lease {i}')
            
            # Lease header
            self.story.append(Paragraph(
                f"LEASE {i}: {filename}", 
                ParagraphStyle(
                    'LeaseHeader',
                    parent=self.heading_style,
                    fontSize=12,
                    textColor=colors.HexColor('#2c5282'),
                    spaceAfter=10
                )
            ))
            
            # Executive Summary
            exec_summary = ai_result.get('executive_summary', 'Analysis unavailable')
            self.story.append(Paragraph(
                f"<b>Executive Summary</b>",
                ParagraphStyle('ExecLabel', fontSize=10, fontName='Helvetica-Bold', spaceAfter=6)
            ))
            self.story.append(Paragraph(
                exec_summary,
                ParagraphStyle('ExecText', fontSize=9, fontName='Helvetica', spaceAfter=12, leading=12)
            ))
            
            # Basic Property Details
            basic = ai_result.get('basic_property_details', {})
            if basic:
                self.story.append(Paragraph(
                    f"<b>Basic Property Details</b>",
                    ParagraphStyle('BasicLabel', fontSize=10, fontName='Helvetica-Bold', spaceAfter=6)
                ))
                
                details_text = f"""<b>Property:</b> {basic.get('property_description', 'N/A')}<br/>
<b>Lease Term:</b> {basic.get('lease_term', 'N/A')}<br/>
<b>Title Number:</b> {basic.get('title_number', 'N/A')}<br/>
<b>Parties:</b><br/>"""
                
                for party in basic.get('parties', []):
                    details_text += f"  • {party}<br/>"
                
                if basic.get('referenced_clauses'):
                    details_text += f"<br/><i>References: {', '.join(basic['referenced_clauses'])}</i>"
                
                self.story.append(Paragraph(
                    details_text,
                    ParagraphStyle('BasicText', fontSize=8, fontName='Helvetica', spaceAfter=12, leading=11)
                ))
            
            # Detailed Sections (Ground Rent, Pets, Repairs, etc.)
            detailed_sections = ai_result.get('detailed_sections', [])
            if detailed_sections:
                self.story.append(Paragraph(
                    f"<b>Detailed Provisions</b>",
                    ParagraphStyle('DetailLabel', fontSize=10, fontName='Helvetica-Bold', spaceAfter=8)
                ))
                
                for section in detailed_sections:
                    # Section title
                    section_title = section.get('section_title', 'Provision')
                    self.story.append(Paragraph(
                        f"<b>{section_title}</b>",
                        ParagraphStyle('SectionTitle', fontSize=9, fontName='Helvetica-Bold', 
                                      textColor=colors.HexColor('#4a5568'), spaceAfter=4)
                    ))
                    
                    # Content
                    for content_item in section.get('content', []):
                        self.story.append(Paragraph(
                            f"• {content_item}",
                            ParagraphStyle('ContentItem', fontSize=8, fontName='Helvetica',
                                          leftIndent=10, spaceAfter=3, leading=10)
                        ))
                    
                    # Clause references
                    if section.get('referenced_clauses'):
                        refs = ', '.join(section['referenced_clauses'])
                        self.story.append(Paragraph(
                            f"<i>References: {refs}</i>",
                            ParagraphStyle('Refs', fontSize=7, fontName='Helvetica-Oblique',
                                          leftIndent=10, spaceAfter=10, textColor=colors.grey)
                        ))
                    
                    self.story.append(Spacer(1, 0.1*inch))
            
            # Other Provisions
            other = ai_result.get('other_provisions', [])
            if other:
                self.story.append(Paragraph(
                    f"<b>Other Provisions</b>",
                    ParagraphStyle('OtherLabel', fontSize=10, fontName='Helvetica-Bold', spaceAfter=6)
                ))
                
                for provision in other:
                    prov_text = f"<b>{provision['title']}:</b> {provision['description']}"
                    if provision.get('referenced_clauses'):
                        refs = ', '.join(provision['referenced_clauses'])
                        prov_text += f"<br/><i>References: {refs}</i>"
                    
                    self.story.append(Paragraph(
                        prov_text,
                        ParagraphStyle('ProvText', fontSize=8, fontName='Helvetica', spaceAfter=8, leading=10)
                    ))
            
            # Disclaimer
            disclaimer = ai_result.get('disclaimer', 'This analysis is for informational purposes only and should not be relied upon as legal advice.')
            self.story.append(Spacer(1, 0.2*inch))
            self.story.append(Paragraph(
                f"<i>{disclaimer}</i>",
                ParagraphStyle('Disclaimer', fontSize=7, fontName='Helvetica-Oblique',
                              textColor=colors.grey, alignment=1, spaceAfter=15)
            ))
            
            # Separator between leases
            if i < len(ai_analyses):
                self.story.append(Spacer(1, 0.3*inch))
                self.story.append(Paragraph("─" * 80, ParagraphStyle('Sep', fontSize=8, textColor=colors.grey)))
                self.story.append(Spacer(1, 0.3*inch))
    
    def _add_asset_register(self):
        """Asset register from H&S reports"""
        assets = self.data.get('asset_register', [])
        
        if not assets:
            return
        
        self.story.append(Paragraph("ASSET REGISTER", self.heading_style))
        
        # Group by asset type
        by_type = {}
        for asset in assets:
            asset_type = asset.get('asset_type', 'general')
            if asset_type not in by_type:
                by_type[asset_type] = []
            by_type[asset_type].append(asset)
        
        # Display by type
        for asset_type, asset_list in list(by_type.items())[:10]:  # Limit types
            self.story.append(Paragraph(f"<b>{asset_type.title()}</b>", self.subheading_style))
            
            asset_names = [f"• {a.get('asset_name', '?')} ({a.get('quantity', 1)}x)" 
                          for a in asset_list[:10]]
            text = '<br/>'.join(asset_names)
            self.story.append(Paragraph(text, self.styles['Normal']))
            self.story.append(Spacer(1, 0.1*inch))

