#!/usr/bin/env python3
"""
BlocIQ Comprehensive Building Report Generator
===============================================
Generates professional, client-ready PDF reports with ALL data from Supabase import

Includes:
- Building overview
- Units & leaseholders
- Financial summary (budget with 52 line items)
- Insurance policies
- Lease summaries
- Compliance assets
- Maintenance contracts & schedules
- Contractors
- Major works

Author: BlocIQ Team
Date: 2025-10-14
"""

import json
import sys
from datetime import datetime
from pathlib import Path
from reportlab.lib import colors
from reportlab.lib.pagesizes import A4, letter
from reportlab.lib.styles import getSampleStyleSheet, ParagraphStyle
from reportlab.lib.units import inch
from reportlab.platypus import (
    SimpleDocTemplate, Table, TableStyle, Paragraph, Spacer,
    PageBreak, Image, KeepTogether
)
from reportlab.lib.enums import TA_LEFT, TA_CENTER, TA_RIGHT


class ComprehensiveBuildingReport:
    """Generate comprehensive building report PDF"""
    
    def __init__(self, data: dict, output_file: str):
        self.data = data
        self.output_file = output_file
        self.doc = SimpleDocTemplate(
            output_file,
            pagesize=letter,
            rightMargin=0.75*inch,
            leftMargin=0.75*inch,
            topMargin=1*inch,
            bottomMargin=0.75*inch,
        )
        self.styles = getSampleStyleSheet()
        self.story = []
        
        # Custom styles
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
            fontSize=16,
            textColor=colors.HexColor('#2c5aa0'),
            spaceAfter=12,
            spaceBefore=20,
        )
        
        self.subheading_style = ParagraphStyle(
            'CustomSubHeading',
            parent=self.styles['Heading3'],
            fontSize=12,
            textColor=colors.HexColor('#4a4a4a'),
            spaceAfter=8,
        )
    
    def generate(self):
        """Generate the complete report"""
        print(f"\n📄 Generating Comprehensive Building Report...")
        
        # Cover page
        self._add_cover_page()
        self.story.append(PageBreak())
        
        # Table of contents
        self._add_table_of_contents()
        self.story.append(PageBreak())
        
        # 1. Executive Summary
        self._add_executive_summary()
        self.story.append(PageBreak())
        
        # 2. Building Profile
        self._add_building_profile()
        self.story.append(PageBreak())
        
        # 3. Units & Leaseholders
        self._add_units_and_leaseholders()
        self.story.append(PageBreak())
        
        # 4. Financial Summary (Budgets)
        self._add_financial_summary()
        self.story.append(PageBreak())
        
        # 5. Insurance Policies
        self._add_insurance_policies()
        self.story.append(PageBreak())
        
        # 6. Lease Summaries
        self._add_lease_summaries()
        self.story.append(PageBreak())
        
        # 7. Compliance Assets
        self._add_compliance_assets()
        self.story.append(PageBreak())
        
        # 8. Maintenance Contracts & Schedules
        self._add_maintenance_section()
        self.story.append(PageBreak())
        
        # 9. Contractors Directory
        self._add_contractors_directory()
        self.story.append(PageBreak())
        
        # 10. Major Works
        self._add_major_works()
        
        # Build PDF
        self.doc.build(self.story)
        print(f"✅ Report generated: {self.output_file}")
        
        return self.output_file
    
    def _add_cover_page(self):
        """Generate cover page"""
        building_name = self.data.get('building_name', 'Unknown Building')
        address = self.data.get('building_address', '')
        postcode = self.data.get('postcode', '')
        
        self.story.append(Spacer(1, 2*inch))
        
        # Title
        title = Paragraph(f"<b>PROPERTY DATA REPORT</b>", self.title_style)
        self.story.append(title)
        self.story.append(Spacer(1, 0.3*inch))
        
        # Building name
        building_para = Paragraph(
            f"<b>{building_name}</b>",
            ParagraphStyle('BuildingName', parent=self.styles['Heading2'], 
                         fontSize=18, alignment=TA_CENTER)
        )
        self.story.append(building_para)
        self.story.append(Spacer(1, 0.1*inch))
        
        # Address
        addr_para = Paragraph(
            f"{address}<br/>{postcode}",
            ParagraphStyle('Address', parent=self.styles['Normal'], 
                         alignment=TA_CENTER, fontSize=12)
        )
        self.story.append(addr_para)
        self.story.append(Spacer(1, 1*inch))
        
        # Report date
        date_str = datetime.now().strftime('%B %d, %Y')
        date_para = Paragraph(
            f"Report Generated: {date_str}",
            ParagraphStyle('Date', parent=self.styles['Normal'], 
                         alignment=TA_CENTER, fontSize=10, textColor=colors.grey)
        )
        self.story.append(date_para)
        
        # Version
        version_para = Paragraph(
            f"BlocIQ Extraction Version: {self.data.get('extraction_version', '6.0')}",
            ParagraphStyle('Version', parent=self.styles['Normal'], 
                         alignment=TA_CENTER, fontSize=9, textColor=colors.grey)
        )
        self.story.append(version_para)
    
    def _add_table_of_contents(self):
        """Generate table of contents"""
        self.story.append(Paragraph("<b>TABLE OF CONTENTS</b>", self.heading_style))
        self.story.append(Spacer(1, 0.2*inch))
        
        toc_items = [
            "1. Executive Summary",
            "2. Building Profile",
            "3. Units & Leaseholders",
            "4. Financial Summary & Budget Breakdown",
            "5. Insurance Policies",
            "6. Lease Summaries",
            "7. Compliance Assets",
            "8. Maintenance Contracts & Schedules",
            "9. Contractors Directory",
            "10. Major Works Projects"
        ]
        
        for item in toc_items:
            p = Paragraph(item, self.styles['Normal'])
            self.story.append(p)
            self.story.append(Spacer(1, 8))
    
    def _add_executive_summary(self):
        """Generate executive summary"""
        self.story.append(Paragraph("<b>1. EXECUTIVE SUMMARY</b>", self.heading_style))
        
        summary = self.data.get('summary', {})
        
        data = [
            ['<b>Metric</b>', '<b>Value</b>'],
            ['Total Units', str(summary.get('total_units', 0))],
            ['Total Leaseholders', str(summary.get('total_leaseholders', 0))],
            ['Outstanding Balance', f"£{summary.get('total_outstanding_balance', 0):,.2f}"],
            ['Annual Service Charge', f"£{self.data.get('annual_service_charge_budget', 0):,.0f}"],
            ['Compliance Rate', f"{summary.get('compliance_rate', 0):.1f}%"],
            ['Total Contracts', str(summary.get('total_contracts', 0))],
            ['Insurance Policies', str(summary.get('total_insurance_policies', 0))],
            ['Lease Documents', str(summary.get('total_leases', 0))],
        ]
        
        table = Table(data, colWidths=[3*inch, 2*inch])
        table.setStyle(TableStyle([
            ('BACKGROUND', (0, 0), (-1, 0), colors.HexColor('#2c5aa0')),
            ('TEXTCOLOR', (0, 0), (-1, 0), colors.whitesmoke),
            ('ALIGN', (0, 0), (-1, -1), 'LEFT'),
            ('ALIGN', (1, 0), (1, -1), 'RIGHT'),
            ('FONTNAME', (0, 0), (-1, 0), 'Helvetica-Bold'),
            ('FONTSIZE', (0, 0), (-1, 0), 11),
            ('BOTTOMPADDING', (0, 0), (-1, 0), 12),
            ('BACKGROUND', (0, 1), (-1, -1), colors.beige),
            ('GRID', (0, 0), (-1, -1), 1, colors.grey),
            ('FONTNAME', (0, 1), (0, -1), 'Helvetica-Bold'),
        ]))
        
        self.story.append(table)
    
    def _add_building_profile(self):
        """Building characteristics"""
        self.story.append(Paragraph("<b>2. BUILDING PROFILE</b>", self.heading_style))
        
        data = [
            ['<b>Characteristic</b>', '<b>Value</b>'],
            ['Building Name', self.data.get('building_name', '')],
            ['Address', self.data.get('building_address', '')],
            ['Postcode', self.data.get('postcode', '')],
            ['Construction Type', self.data.get('construction_type', 'N/A')],
            ['Construction Era', self.data.get('construction_era', '')],
            ['Number of Units', str(self.data.get('num_units', 0))],
            ['Number of Floors', str(self.data.get('num_floors', 0))],
            ['Building Height', f"{self.data.get('building_height_meters', 0)}m"],
            ['Has Lifts', 'Yes' if self.data.get('has_lifts') else 'No'],
            ['Number of Lifts', str(self.data.get('num_lifts', 0))],
            ['BSA Status', self.data.get('bsa_status', 'N/A')],
        ]
        
        table = Table(data, colWidths=[3*inch, 3*inch])
        table.setStyle(TableStyle([
            ('BACKGROUND', (0, 0), (-1, 0), colors.HexColor('#2c5aa0')),
            ('TEXTCOLOR', (0, 0), (-1, 0), colors.whitesmoke),
            ('ALIGN', (0, 0), (-1, -1), 'LEFT'),
            ('FONTNAME', (0, 0), (-1, 0), 'Helvetica-Bold'),
            ('GRID', (0, 0), (-1, -1), 1, colors.grey),
            ('BACKGROUND', (0, 1), (-1, -1), colors.beige),
        ]))
        
        self.story.append(table)
    
    def _add_units_and_leaseholders(self):
        """Units and leaseholders"""
        self.story.append(Paragraph("<b>3. UNITS & LEASEHOLDERS</b>", self.heading_style))
        
        units = self.data.get('units', [])
        leaseholders = self.data.get('leaseholders', [])
        
        # Create lookup for leaseholders by unit
        lh_by_unit = {lh.get('unit_number'): lh for lh in leaseholders}
        
        data = [['<b>Unit</b>', '<b>Leaseholder</b>', '<b>Apport %</b>', '<b>Balance</b>']]
        
        for unit in units:
            unit_num = unit.get('unit_number', '')
            lh = lh_by_unit.get(unit_num, {})
            lh_name = lh.get('leaseholder_name', 'Vacant')
            apport = unit.get('apportionment_percentage', 0)
            balance = lh.get('balance', 0)
            
            data.append([
                unit_num,
                lh_name[:30] + '...' if len(lh_name) > 30 else lh_name,
                f"{apport:.2f}%",
                f"£{balance:,.2f}" if balance else "£0.00"
            ])
        
        # Add totals
        total_balance = sum(lh.get('balance', 0) for lh in leaseholders)
        data.append([
            '<b>TOTAL</b>',
            f'<b>{len(leaseholders)} leaseholders</b>',
            '<b>100%</b>',
            f'<b>£{total_balance:,.2f}</b>'
        ])
        
        table = Table(data, colWidths=[1*inch, 3*inch, 1*inch, 1.2*inch])
        table.setStyle(TableStyle([
            ('BACKGROUND', (0, 0), (-1, 0), colors.HexColor('#2c5aa0')),
            ('TEXTCOLOR', (0, 0), (-1, 0), colors.whitesmoke),
            ('ALIGN', (0, 0), (-1, -1), 'LEFT'),
            ('ALIGN', (2, 0), (2, -1), 'CENTER'),
            ('ALIGN', (3, 0), (3, -1), 'RIGHT'),
            ('FONTNAME', (0, 0), (-1, 0), 'Helvetica-Bold'),
            ('GRID', (0, 0), (-1, -1), 1, colors.grey),
            ('BACKGROUND', (0, 1), (-1, -2), colors.beige),
            ('BACKGROUND', (0, -1), (-1, -1), colors.HexColor('#e8f0f8')),
            ('FONTNAME', (0, -1), (-1, -1), 'Helvetica-Bold'),
        ]))
        
        self.story.append(table)
    
    def _add_financial_summary(self):
        """Budget with detailed line items"""
        self.story.append(Paragraph("<b>4. FINANCIAL SUMMARY</b>", self.heading_style))
        
        budgets = self.data.get('budgets', [])
        if not budgets:
            self.story.append(Paragraph("No budget data available", self.styles['Normal']))
            return
        
        budget = budgets[0]
        
        # Budget header
        self.story.append(Paragraph(
            f"<b>Financial Year:</b> {budget.get('financial_year', 'N/A')}<br/>"
            f"<b>Status:</b> {budget.get('status', 'Draft').title()}<br/>"
            f"<b>Source:</b> {budget.get('source_document', 'N/A')}",
            self.styles['Normal']
        ))
        self.story.append(Spacer(1, 0.2*inch))
        
        # Line items by section
        line_items = budget.get('line_items', [])
        
        if not line_items:
            self.story.append(Paragraph("No detailed line items available", self.styles['Normal']))
            return
        
        # Group by section
        sections = {}
        for item in line_items:
            if item.get('category') == 'Total':
                continue
            section = item.get('section', 'OTHER')
            if section not in sections:
                sections[section] = []
            sections[section].append(item)
        
        # Generate tables per section
        for section_name, items in sorted(sections.items()):
            self.story.append(Paragraph(f"<b>{section_name}</b>", self.subheading_style))
            
            data = [['<b>Category</b>', '<b>Budget 25/26</b>', '<b>Actual 24/25</b>', '<b>Variance</b>']]
            
            section_total_budget = 0
            section_total_actual = 0
            
            for item in items:
                budget_amt = item.get('budget_2025_26', 0)
                actual_amt = item.get('actual_2024_25', 0)
                variance = item.get('variance_from_actual', 0)
                
                section_total_budget += budget_amt
                section_total_actual += actual_amt
                
                data.append([
                    item.get('category', 'Unknown')[:35],
                    f"£{budget_amt:,.0f}",
                    f"£{actual_amt:,.0f}",
                    f"£{variance:,.0f}" if variance >= 0 else f"(£{abs(variance):,.0f})"
                ])
            
            # Section total
            data.append([
                f'<b>{section_name} TOTAL</b>',
                f'<b>£{section_total_budget:,.0f}</b>',
                f'<b>£{section_total_actual:,.0f}</b>',
                f'<b>£{section_total_budget - section_total_actual:,.0f}</b>'
            ])
            
            table = Table(data, colWidths=[2.8*inch, 1.2*inch, 1.2*inch, 1.2*inch])
            table.setStyle(TableStyle([
                ('BACKGROUND', (0, 0), (-1, 0), colors.HexColor('#4a4a4a')),
                ('TEXTCOLOR', (0, 0), (-1, 0), colors.whitesmoke),
                ('ALIGN', (1, 0), (-1, -1), 'RIGHT'),
                ('FONTNAME', (0, 0), (-1, 0), 'Helvetica-Bold'),
                ('FONTSIZE', (0, 0), (-1, -1), 9),
                ('GRID', (0, 0), (-1, -1), 0.5, colors.grey),
                ('BACKGROUND', (0, 1), (-1, -2), colors.beige),
                ('BACKGROUND', (0, -1), (-1, -1), colors.HexColor('#d3d3d3')),
                ('FONTNAME', (0, -1), (-1, -1), 'Helvetica-Bold'),
            ]))
            
            self.story.append(table)
            self.story.append(Spacer(1, 0.15*inch))
        
        # Grand total
        total_budget = sum(item.get('budget_2025_26', 0) for item in line_items if item.get('category') != 'Total')
        
        self.story.append(Spacer(1, 0.2*inch))
        total_para = Paragraph(
            f"<b>TOTAL ANNUAL SERVICE CHARGE: £{total_budget:,.0f}</b>",
            ParagraphStyle('Total', parent=self.styles['Heading3'], 
                         textColor=colors.HexColor('#2c5aa0'), alignment=TA_CENTER)
        )
        self.story.append(total_para)
    
    def _add_insurance_policies(self):
        """Insurance policies details"""
        self.story.append(Paragraph("<b>5. INSURANCE POLICIES</b>", self.heading_style))
        
        policies = self.data.get('insurance_policies', [])
        
        if not policies:
            self.story.append(Paragraph("No insurance policies on file", self.styles['Normal']))
            return
        
        data = [['<b>Policy Type</b>', '<b>Insurer</b>', '<b>Renewal Date</b>', '<b>Premium</b>']]
        
        total_premium = 0
        for policy in policies:
            premium = policy.get('estimated_premium', 0) or policy.get('annual_premium', 0)
            total_premium += premium
            
            data.append([
                policy.get('policy_type', 'Unknown'),
                policy.get('insurer', 'N/A'),
                policy.get('renewal_date', 'N/A'),
                f"£{premium:,.0f}" if premium else 'N/A'
            ])
        
        # Total
        data.append([
            '<b>TOTAL ANNUAL PREMIUMS</b>',
            '',
            '',
            f'<b>£{total_premium:,.0f}</b>'
        ])
        
        table = Table(data, colWidths=[2*inch, 2*inch, 1.5*inch, 1.2*inch])
        table.setStyle(TableStyle([
            ('BACKGROUND', (0, 0), (-1, 0), colors.HexColor('#2c5aa0')),
            ('TEXTCOLOR', (0, 0), (-1, 0), colors.whitesmoke),
            ('ALIGN', (2, 0), (2, -1), 'CENTER'),
            ('ALIGN', (3, 0), (3, -1), 'RIGHT'),
            ('FONTNAME', (0, 0), (-1, 0), 'Helvetica-Bold'),
            ('GRID', (0, 0), (-1, -1), 1, colors.grey),
            ('BACKGROUND', (0, 1), (-1, -2), colors.beige),
            ('BACKGROUND', (0, -1), (-1, -1), colors.HexColor('#e8f0f8')),
            ('FONTNAME', (0, -1), (-1, -1), 'Helvetica-Bold'),
        ]))
        
        self.story.append(table)
        
        # Insurance notes
        self.story.append(Spacer(1, 0.2*inch))
        for policy in policies:
            note = f"<b>{policy.get('policy_type')}:</b> Renews {policy.get('renewal_date', 'N/A')}, "
            note += f"Source: {policy.get('source', 'Budget estimate')}"
            self.story.append(Paragraph(note, ParagraphStyle('Small', parent=self.styles['Normal'], fontSize=9)))
    
    def _add_lease_summaries(self):
        """Lease documents summary"""
        self.story.append(Paragraph("<b>6. LEASE SUMMARIES</b>", self.heading_style))
        
        leases = self.data.get('leases', [])
        
        if not leases:
            self.story.append(Paragraph("No lease documents extracted", self.styles['Normal']))
            return
        
        self.story.append(Paragraph(
            f"<b>{len(leases)} lease documents identified and processed</b>",
            self.styles['Normal']
        ))
        self.story.append(Spacer(1, 0.15*inch))
        
        # Detailed lease table
        data = [['<b>Document</b>', '<b>Title Number</b>', '<b>Pages</b>', '<b>Size</b>', '<b>Status</b>']]
        
        total_pages = 0
        total_size = 0
        
        for lease in leases:
            pages = lease.get('page_count', 0)
            size_mb = lease.get('file_size_mb', 0)
            total_pages += pages
            total_size += size_mb
            
            status = '✓ Extracted' if lease.get('extracted_successfully') else '⚠ Pending'
            
            data.append([
                lease.get('source_document', 'Unknown')[:30],
                lease.get('title_number', 'N/A'),
                str(pages),
                f"{size_mb:.2f} MB",
                status
            ])
        
        # Total
        data.append([
            f'<b>TOTAL ({len(leases)} documents)</b>',
            '',
            f'<b>{total_pages} pages</b>',
            f'<b>{total_size:.2f} MB</b>',
            ''
        ])
        
        table = Table(data, colWidths=[2.2*inch, 1.3*inch, 0.8*inch, 1*inch, 1.2*inch])
        table.setStyle(TableStyle([
            ('BACKGROUND', (0, 0), (-1, 0), colors.HexColor('#2c5aa0')),
            ('TEXTCOLOR', (0, 0), (-1, 0), colors.whitesmoke),
            ('ALIGN', (2, 0), (3, -1), 'CENTER'),
            ('FONTNAME', (0, 0), (-1, 0), 'Helvetica-Bold'),
            ('FONTSIZE', (0, 0), (-1, -1), 9),
            ('GRID', (0, 0), (-1, -1), 1, colors.grey),
            ('BACKGROUND', (0, 1), (-1, -2), colors.beige),
            ('BACKGROUND', (0, -1), (-1, -1), colors.HexColor('#e8f0f8')),
            ('FONTNAME', (0, -1), (-1, -1), 'Helvetica-Bold'),
        ]))
        
        self.story.append(table)
        
        # Lease details
        self.story.append(Spacer(1, 0.2*inch))
        self.story.append(Paragraph("<b>Lease Document Locations:</b>", self.subheading_style))
        for i, lease in enumerate(leases, 1):
            location = lease.get('document_location', 'N/A')
            self.story.append(Paragraph(
                f"{i}. {location}",
                ParagraphStyle('Small', parent=self.styles['Normal'], fontSize=8)
            ))
    
    def _add_compliance_assets(self):
        """Compliance status"""
        self.story.append(Paragraph("<b>7. COMPLIANCE ASSETS</b>", self.heading_style))
        
        assets = self.data.get('compliance_assets_all', [])
        analysis = self.data.get('compliance_analysis', {})
        
        # Summary
        comp_summary = analysis.get('summary', {})
        self.story.append(Paragraph(
            f"<b>Compliance Rate:</b> {comp_summary.get('compliance_rate', 0):.1f}%<br/>"
            f"<b>Total Required:</b> {comp_summary.get('total_required', 0)} assets<br/>"
            f"<b>Current:</b> {comp_summary.get('current', 0)} | "
            f"<b>Expired:</b> {comp_summary.get('expired', 0)} | "
            f"<b>Missing:</b> {comp_summary.get('missing', 0)}",
            self.styles['Normal']
        ))
        self.story.append(Spacer(1, 0.2*inch))
        
        # Assets table
        data = [['<b>Asset Type</b>', '<b>Status</b>', '<b>Last Inspection</b>', '<b>Next Due</b>']]
        
        # Sort by status: current, expired, missing
        status_order = {'current': 1, 'expired': 2, 'missing': 3}
        sorted_assets = sorted(assets, key=lambda x: status_order.get(x.get('status', 'missing'), 4))
        
        for asset in sorted_assets[:20]:  # First 20 assets
            status = asset.get('status', 'unknown')
            status_icon = '✓' if status == 'current' else '⚠' if status == 'expired' else '✗'
            
            data.append([
                asset.get('asset_type', 'Unknown'),
                f"{status_icon} {status.title()}",
                asset.get('inspection_date', 'N/A'),
                asset.get('next_due_date', 'N/A')
            ])
        
        if len(assets) > 20:
            data.append([f'... and {len(assets) - 20} more assets', '', '', ''])
        
        table = Table(data, colWidths=[2*inch, 1.5*inch, 1.5*inch, 1.5*inch])
        table.setStyle(TableStyle([
            ('BACKGROUND', (0, 0), (-1, 0), colors.HexColor('#2c5aa0')),
            ('TEXTCOLOR', (0, 0), (-1, 0), colors.whitesmoke),
            ('ALIGN', (1, 0), (-1, -1), 'CENTER'),
            ('FONTNAME', (0, 0), (-1, 0), 'Helvetica-Bold'),
            ('FONTSIZE', (0, 0), (-1, -1), 9),
            ('GRID', (0, 0), (-1, -1), 1, colors.grey),
            ('BACKGROUND', (0, 1), (-1, -1), colors.beige),
        ]))
        
        self.story.append(table)
    
    def _add_maintenance_section(self):
        """Maintenance contracts and schedules"""
        self.story.append(Paragraph("<b>8. MAINTENANCE CONTRACTS & SCHEDULES</b>", self.heading_style))
        
        contracts = self.data.get('maintenance_contracts', [])
        
        if not contracts:
            self.story.append(Paragraph("No maintenance contracts on file", self.styles['Normal']))
            return
        
        # Contracts table
        self.story.append(Paragraph("<b>Active Contracts:</b>", self.subheading_style))
        
        data = [['<b>Service Type</b>', '<b>Contractor</b>', '<b>Frequency</b>', '<b>Status</b>']]
        
        # Map frequencies
        FREQ_MAP = {
            'Lift Maintenance': 'Annual',
            'Cleaning': 'Weekly',
            'CCTV': 'Annual',
            'Water Hygiene': 'Quarterly',
            'Pest Control': 'Quarterly'
        }
        
        for contract in contracts:
            contract_type = contract.get('contract_type', 'Unknown')
            frequency = FREQ_MAP.get(contract_type, 'Annual')
            status = contract.get('contract_status', 'Unknown').title()
            
            data.append([
                contract_type,
                contract.get('contractor_name', 'Unknown')[:25],
                frequency,
                status
            ])
        
        table = Table(data, colWidths=[2*inch, 2*inch, 1.5*inch, 1*inch])
        table.setStyle(TableStyle([
            ('BACKGROUND', (0, 0), (-1, 0), colors.HexColor('#2c5aa0')),
            ('TEXTCOLOR', (0, 0), (-1, 0), colors.whitesmoke),
            ('ALIGN', (2, 0), (3, -1), 'CENTER'),
            ('FONTNAME', (0, 0), (-1, 0), 'Helvetica-Bold'),
            ('FONTSIZE', (0, 0), (-1, -1), 9),
            ('GRID', (0, 0), (-1, -1), 1, colors.grey),
            ('BACKGROUND', (0, 1), (-1, -1), colors.beige),
        ]))
        
        self.story.append(table)
        
        # Maintenance schedules
        self.story.append(Spacer(1, 0.3*inch))
        self.story.append(Paragraph("<b>Service Schedule Summary:</b>", self.subheading_style))
        
        schedule_summary = [
            ('Weekly Services', 'Cleaning'),
            ('Quarterly Services', 'Water Hygiene, Pest Control'),
            ('Annual Services', 'Lift LOLER, CCTV, Fire Alarm'),
        ]
        
        for frequency, services in schedule_summary:
            self.story.append(Paragraph(
                f"<b>{frequency}:</b> {services}",
                ParagraphStyle('Schedule', parent=self.styles['Normal'], fontSize=10)
            ))
    
    def _add_contractors_directory(self):
        """Contractors list"""
        self.story.append(Paragraph("<b>9. CONTRACTORS DIRECTORY</b>", self.heading_style))
        
        contractors = self.data.get('contractors', [])
        
        if not contractors:
            self.story.append(Paragraph("No contractors on file", self.styles['Normal']))
            return
        
        self.story.append(Paragraph(
            f"<b>{len(contractors)} service providers identified</b>",
            self.styles['Normal']
        ))
        self.story.append(Spacer(1, 0.15*inch))
        
        data = [['<b>Contractor</b>', '<b>Service Type</b>', '<b>Documents</b>']]
        
        for contractor in contractors:
            data.append([
                contractor.get('contractor_name', 'Unknown')[:30],
                contractor.get('service_type', 'General')[:25],
                str(contractor.get('contract_documents_count', 0))
            ])
        
        table = Table(data, colWidths=[3*inch, 2.5*inch, 1*inch])
        table.setStyle(TableStyle([
            ('BACKGROUND', (0, 0), (-1, 0), colors.HexColor('#2c5aa0')),
            ('TEXTCOLOR', (0, 0), (-1, 0), colors.whitesmoke),
            ('ALIGN', (2, 0), (2, -1), 'CENTER'),
            ('FONTNAME', (0, 0), (-1, 0), 'Helvetica-Bold'),
            ('FONTSIZE', (0, 0), (-1, -1), 9),
            ('GRID', (0, 0), (-1, -1), 1, colors.grey),
            ('BACKGROUND', (0, 1), (-1, -1), colors.beige),
        ]))
        
        self.story.append(table)
    
    def _add_major_works(self):
        """Major works projects"""
        self.story.append(Paragraph("<b>10. MAJOR WORKS PROJECTS</b>", self.heading_style))
        
        major_works = self.data.get('major_works', [])
        
        if not major_works or not major_works[0].get('major_works_detected'):
            self.story.append(Paragraph("No major works projects currently planned or underway", self.styles['Normal']))
            return
        
        project = major_works[0]
        
        self.story.append(Paragraph(
            f"<b>Major Works Detected:</b> Yes<br/>"
            f"<b>Total Documents:</b> {project.get('total_documents', 0)}<br/>"
            f"<b>Section 20 Consultation Documents:</b> {project.get('s20_consultation_documents', 0)}<br/>"
            f"<b>Folder Location:</b> {project.get('folder_path', 'N/A')}",
            self.styles['Normal']
        ))
        
        self.story.append(Spacer(1, 0.2*inch))
        self.story.append(Paragraph(
            "<i>Note: Major works require Section 20 consultation with leaseholders. "
            "Review documents in the Major Works folder for full details.</i>",
            ParagraphStyle('Italic', parent=self.styles['Normal'], fontSize=9, textColor=colors.grey)
        ))


def main():
    """CLI entry point"""
    import argparse
    
    parser = argparse.ArgumentParser(description='Generate comprehensive building report PDF')
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
        output_file = args.json_file.replace('.json', '_comprehensive_report.pdf')
    
    # Generate report
    generator = ComprehensiveBuildingReport(data, output_file)
    generator.generate()
    
    print(f"\n✅ Complete!")
    print(f"   Report: {output_file}")
    print(f"\n📊 Report includes:")
    print(f"   • Building profile & characteristics")
    print(f"   • Units & leaseholders (£{data.get('summary', {}).get('total_outstanding_balance', 0):,.2f} outstanding)")
    print(f"   • Budget breakdown ({len(data.get('budgets', [{}])[0].get('line_items', []))} line items)")
    print(f"   • Insurance policies ({len(data.get('insurance_policies', []))} policies)")
    print(f"   • Lease summaries ({len(data.get('leases', []))} documents)")
    print(f"   • Compliance assets ({len(data.get('compliance_assets_all', []))} assets)")
    print(f"   • Maintenance contracts ({len(data.get('maintenance_contracts', []))} contracts)")
    print(f"   • Contractors directory ({len(data.get('contractors', []))} providers)")
    print(f"   • Major works projects")
    
    # Open PDF
    import subprocess
    subprocess.run(['open', output_file])


if __name__ == '__main__':
    main()

