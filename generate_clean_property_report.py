#!/usr/bin/env python3
"""
BlocIQ Clean Property Report Generator
========================================
Generates professional, client-ready property reports with clean formatting
"""

import json
import sys
from datetime import datetime
from reportlab.lib import colors
from reportlab.lib.pagesizes import letter, A4
from reportlab.lib.styles import getSampleStyleSheet, ParagraphStyle
from reportlab.lib.units import inch
from reportlab.platypus import (
    SimpleDocTemplate, Table, TableStyle, Paragraph, Spacer,
    PageBreak, KeepTogether
)
from reportlab.lib.enums import TA_LEFT, TA_CENTER, TA_RIGHT


class CleanPropertyReport:
    """Generate clean, professional property report"""
    
    def __init__(self, data: dict, output_file: str):
        self.data = data
        self.building = data.get('building', {})
        self.output_file = output_file
        self.doc = SimpleDocTemplate(
            output_file,
            pagesize=letter,
            rightMargin=0.75*inch,
            leftMargin=0.75*inch,
            topMargin=0.75*inch,
            bottomMargin=0.75*inch,
        )
        self.styles = getSampleStyleSheet()
        self.story = []
        
        # Colors
        self.primary = colors.HexColor('#1a365d')
        self.secondary = colors.HexColor('#2c5282')
        self.light_bg = colors.HexColor('#edf2f7')
        
        self.setup_styles()
    
    def setup_styles(self):
        """Setup custom styles"""
        self.title_style = ParagraphStyle(
            'CustomTitle',
            parent=self.styles['Heading1'],
            fontSize=24,
            textColor=self.primary,
            alignment=TA_CENTER,
            fontName='Helvetica-Bold',
            spaceAfter=10
        )
        
        self.section_header = ParagraphStyle(
            'SectionHeader',
            parent=self.styles['Heading2'],
            fontSize=14,
            textColor=colors.white,
            alignment=TA_LEFT,
            fontName='Helvetica-Bold',
            leftIndent=10,
            spaceBefore=15,
            spaceAfter=10,
            backColor=self.primary,
            borderPadding=8
        )
        
        self.subsection_header = ParagraphStyle(
            'SubsectionHeader',
            parent=self.styles['Heading3'],
            fontSize=12,
            textColor=self.secondary,
            fontName='Helvetica-Bold',
            spaceBefore=10,
            spaceAfter=6
        )
    
    def generate(self):
        """Generate the complete report"""
        # Page 1: Cover
        self._add_cover_page()
        self.story.append(PageBreak())
        
        # Page 2: Building Profile
        self._add_building_profile()
        self.story.append(PageBreak())
        
        # Units & Leaseholders
        self._add_units_leaseholders()
        
        # Insurance
        if self.data.get('insurance_policies'):
            self.story.append(PageBreak())
            self._add_insurance()
        
        # Lease Documents
        if self.data.get('leases'):
            self.story.append(PageBreak())
            self._add_lease_documents()
        
        # Lease Clauses
        if self.data.get('lease_clauses'):
            self.story.append(PageBreak())
            self._add_lease_clauses()
        
        # Contractors
        if self.data.get('contractors'):
            self.story.append(PageBreak())
            self._add_contractors()
        
        # Compliance
        if self.data.get('compliance_assets'):
            self.story.append(PageBreak())
            self._add_compliance()
        
        # Build PDF
        self.doc.build(self.story)
        return self.output_file
    
    def _add_cover_page(self):
        """Front page with key stats"""
        # Title
        self.story.append(Spacer(1, 1.5*inch))
        self.story.append(Paragraph("<b>COMPLETE PROPERTY DATA REPORT</b>", self.title_style))
        self.story.append(Spacer(1, 0.2*inch))
        
        # Subtitle
        subtitle_style = ParagraphStyle(
            'Subtitle', parent=self.styles['Normal'],
            fontSize=14, alignment=TA_CENTER, textColor=self.secondary
        )
        self.story.append(Paragraph("<b>Comprehensive Extraction & Analysis</b>", subtitle_style))
        self.story.append(Spacer(1, 0.8*inch))
        
        # Building Name (large)
        building_name = self.building.get('building_name') or self.building.get('name', 'Unknown Building')
        name_style = ParagraphStyle(
            'BuildingName', parent=self.styles['Heading1'],
            fontSize=22, alignment=TA_CENTER, fontName='Helvetica-Bold'
        )
        self.story.append(Paragraph(f"<b>{building_name}</b>", name_style))
        self.story.append(Spacer(1, 0.15*inch))
        
        # Address
        address = self.building.get('address', '')
        if address:
            addr_style = ParagraphStyle('Addr', parent=self.styles['Normal'], alignment=TA_CENTER, fontSize=12)
            self.story.append(Paragraph(address, addr_style))
            self.story.append(Spacer(1, 0.1*inch))
        
        # Postcode
        postcode = self.building.get('postcode', '')
        if postcode:
            self.story.append(Paragraph(postcode, addr_style))
        
        self.story.append(Spacer(1, 0.8*inch))
        
        # Key Stats Box
        units_count = len(self.data.get('units', []))
        leaseholders_count = len(self.data.get('leaseholders', []))
        lease_docs_count = len(self.data.get('leases', []))
        
        # Format year end date
        year_end = self.building.get('year_end_date', '')
        if year_end:
            annual_budget_ye = f"YE {year_end}"
        else:
            annual_budget_ye = "Not specified"
        
        # Create stats with Paragraph objects for proper rendering
        bold_style = ParagraphStyle('Bold', parent=self.styles['Normal'], fontName='Helvetica-Bold')
        normal_style = self.styles['Normal']
        
        stats_data = [
            [Paragraph('Units', bold_style), str(units_count)],
            [Paragraph('Leaseholders', bold_style), str(leaseholders_count)],
            [Paragraph('Annual Budget YE', bold_style), annual_budget_ye],
            [Paragraph('Lease Documents', bold_style), str(lease_docs_count)],
        ]
        
        stats_table = Table(stats_data, colWidths=[2.5*inch, 2*inch])
        stats_table.setStyle(TableStyle([
            ('ALIGN', (0, 0), (0, -1), 'RIGHT'),
            ('ALIGN', (1, 0), (1, -1), 'LEFT'),
            ('FONTNAME', (0, 0), (-1, -1), 'Helvetica'),
            ('FONTSIZE', (0, 0), (-1, -1), 11),
            ('TEXTCOLOR', (0, 0), (0, -1), self.secondary),
            ('LEFTPADDING', (0, 0), (-1, -1), 12),
            ('RIGHTPADDING', (0, 0), (-1, -1), 12),
            ('TOPPADDING', (0, 0), (-1, -1), 8),
            ('BOTTOMPADDING', (0, 0), (-1, -1), 8),
        ]))
        
        self.story.append(stats_table)
        
        # Generated date
        self.story.append(Spacer(1, 1*inch))
        date_style = ParagraphStyle('Date', parent=self.styles['Normal'], 
                                    alignment=TA_CENTER, fontSize=10, textColor=colors.grey)
        self.story.append(Paragraph(f"Generated: {datetime.now().strftime('%B %d, %Y')}", date_style))
    
    def _add_building_profile(self):
        """Building Profile & Characteristics"""
        self.story.append(Paragraph("■ BUILDING PROFILE & CHARACTERISTICS", self.section_header))
        self.story.append(Spacer(1, 0.2*inch))
        
        # Basic Information
        self.story.append(Paragraph("<b>Basic Information</b>", self.subsection_header))
        
        basic_data = [
            ['Building Name', self.building.get('building_name') or self.building.get('name', '—')],
            ['Full Address', self.building.get('address', '—')],
            ['Postcode', self.building.get('postcode', '—')],
            ['City', self.building.get('city', 'London')],
        ]
        
        basic_table = Table(basic_data, colWidths=[2*inch, 4.5*inch])
        basic_table.setStyle(self._get_info_table_style())
        self.story.append(basic_table)
        self.story.append(Spacer(1, 0.2*inch))
        
        # Physical Characteristics
        self.story.append(Paragraph("<b>Physical Characteristics</b>", self.subsection_header))
        
        physical_data = [
            ['Construction Era', self.building.get('construction_era', '—')],
            ['Number of Units', str(self.building.get('number_of_units') or self.building.get('num_units', '—'))],
            ['Number of Floors', str(self.building.get('num_floors', '—'))],
            ['Building Height', f"{self.building.get('building_height_meters', '—')}m" if self.building.get('building_height_meters') else '—'],
            ['Number of Blocks', str(self.building.get('num_blocks', '—'))],
        ]
        
        physical_table = Table(physical_data, colWidths=[2*inch, 4.5*inch])
        physical_table.setStyle(self._get_info_table_style())
        self.story.append(physical_table)
        self.story.append(Spacer(1, 0.2*inch))
        
        # Services & Systems
        self.story.append(Paragraph("<b>Services & Systems</b>", self.subsection_header))
        
        num_lifts = self.building.get('num_lifts') or (1 if self.building.get('has_lifts') else 0)
        lifts_text = f"Yes ({num_lifts} lifts)" if num_lifts else "No"
        
        heating_text = "Yes" if self.building.get('has_communal_heating') else "No"
        gas_text = "Yes" if self.building.get('has_gas') else "No"
        
        services_data = [
            ['Lifts', lifts_text],
            ['Communal Heating', heating_text],
            ['Gas Supply', gas_text],
        ]
        
        services_table = Table(services_data, colWidths=[2*inch, 4.5*inch])
        services_table.setStyle(self._get_info_table_style())
        self.story.append(services_table)
        self.story.append(Spacer(1, 0.2*inch))
        
        # Regulatory
        self.story.append(Paragraph("<b>Regulatory</b>", self.subsection_header))
        
        # BSA status based on height
        height = self.building.get('building_height_meters', 0)
        bsa_status = "BSA Registered" if height and height >= 18 else "Not BSA"
        bsa_required = "Yes" if height and height >= 18 else "No"
        
        regulatory_data = [
            ['BSA Status', bsa_status],
            ['BSA Registration Required', bsa_required],
        ]
        
        regulatory_table = Table(regulatory_data, colWidths=[2*inch, 4.5*inch])
        regulatory_table.setStyle(self._get_info_table_style())
        self.story.append(regulatory_table)
    
    def _add_units_leaseholders(self):
        """Units & Leaseholders - Single comprehensive table"""
        self.story.append(Paragraph("■ UNITS & LEASEHOLDERS - DETAILED BREAKDOWN", self.section_header))
        self.story.append(Spacer(1, 0.15*inch))
        
        # Combine units and leaseholders data
        units = self.data.get('units', [])
        leaseholders = self.data.get('leaseholders', [])
        
        # Create leaseholder lookup by unit_id
        lh_by_unit = {}
        for lh in leaseholders:
            unit_id = lh.get('unit_id')
            if unit_id:
                lh_by_unit[unit_id] = lh
        
        # Build combined table
        table_data = [
            [
                Paragraph('<b>Unit</b>', self.styles['Normal']),
                Paragraph('<b>Leaseholder</b>', self.styles['Normal']),
                Paragraph('<b>Contact</b>', self.styles['Normal']),
                Paragraph('<b>Apport %</b>', self.styles['Normal'])
            ]
        ]
        
        # SHOW ALL UNITS (no limit)
        for unit in units:
            unit_num = unit.get('unit_number') or '—'
            
            # Get apportionment - try multiple field names
            apport = (
                unit.get('apportionment_percentage') or 
                unit.get('apportionment') or 
                unit.get('percentage') or 
                0
            )
            apport_str = f"{float(apport):.2f}%" if apport and float(apport) > 0 else "—"
            
            # Get leaseholder for this unit
            lh = lh_by_unit.get(unit.get('id'), {})
            lh_name = (
                lh.get('leaseholder_name') or 
                lh.get('name') or 
                lh.get('full_name') or 
                '—'
            )
            
            lh_address = lh.get('correspondence_address') or ''
            lh_email = lh.get('email') or ''
            lh_tel = lh.get('telephone') or lh.get('phone') or ''
            
            # Combine contact info
            contact_parts = []
            if lh_address and lh_address != '—':
                contact_parts.append(str(lh_address)[:100])
            if lh_email and lh_email != '—':
                contact_parts.append(str(lh_email))
            if lh_tel and lh_tel != '—':
                contact_parts.append(str(lh_tel))
            
            contact = ', '.join(contact_parts) if contact_parts else '—'
            
            # Handle leaseholder name - if it's "Unknown", show as vacant
            if lh_name == 'Unknown' or lh_name == '—':
                lh_name = 'Vacant' if not contact or contact == '—' else lh_name
            
            table_data.append([
                str(unit_num),
                Paragraph(str(lh_name)[:60], self.styles['Normal']),
                Paragraph(contact[:180], self.styles['Normal']),
                apport_str
            ])
        
        units_table = Table(table_data, colWidths=[0.8*inch, 1.8*inch, 2.8*inch, 0.9*inch])
        units_table.setStyle(TableStyle([
            ('BACKGROUND', (0, 0), (-1, 0), self.light_bg),
            ('TEXTCOLOR', (0, 0), (-1, 0), self.primary),
            ('FONTNAME', (0, 0), (-1, 0), 'Helvetica-Bold'),
            ('FONTSIZE', (0, 0), (-1, -1), 9),
            ('ALIGN', (0, 0), (-1, 0), 'CENTER'),
            ('ALIGN', (3, 0), (3, -1), 'RIGHT'),
            ('GRID', (0, 0), (-1, -1), 0.5, colors.grey),
            ('VALIGN', (0, 0), (-1, -1), 'TOP'),
            ('LEFTPADDING', (0, 0), (-1, -1), 6),
            ('RIGHTPADDING', (0, 0), (-1, -1), 6),
            ('TOPPADDING', (0, 0), (-1, -1), 4),
            ('BOTTOMPADDING', (0, 0), (-1, -1), 4),
        ]))
        
        self.story.append(units_table)
    
    def _add_insurance(self):
        """Insurance Policies"""
        self.story.append(Paragraph("■ INSURANCE POLICIES - COMPLETE COVERAGE", self.section_header))
        self.story.append(Spacer(1, 0.15*inch))
        
        policies = self.data.get('insurance_policies', [])
        
        table_data = [
            [
                Paragraph('<b>Type</b>', self.styles['Normal']),
                Paragraph('<b>Insurer</b>', self.styles['Normal']),
                Paragraph('<b>Premium</b>', self.styles['Normal']),
                Paragraph('<b>Expiry</b>', self.styles['Normal'])
            ]
        ]
        
        for policy in policies[:30]:
            policy_type = policy.get('policy_type') or '—'
            insurer = policy.get('insurer') or '—'
            premium = policy.get('annual_premium') or policy.get('premium') or 0
            premium_str = f"£{premium:,.0f}" if premium else "—"
            expiry = policy.get('expiry_date') or '—'
            
            table_data.append([
                Paragraph(str(policy_type)[:30], self.styles['Normal']),
                Paragraph(str(insurer)[:40], self.styles['Normal']),
                premium_str,
                str(expiry)[:15] if expiry != '—' else '—'
            ])
        
        if len(policies) > 30:
            table_data.append([f'+ {len(policies) - 30} more policies', '', '', ''])
        
        insurance_table = Table(table_data, colWidths=[1.5*inch, 2*inch, 1.2*inch, 1.6*inch])
        insurance_table.setStyle(self._get_standard_table_style())
        self.story.append(insurance_table)
    
    def _add_lease_documents(self):
        """Lease Documents - All together"""
        self.story.append(Paragraph("■ LEASE DOCUMENTS - COMPREHENSIVE SUMMARY", self.section_header))
        self.story.append(Spacer(1, 0.15*inch))
        
        leases = self.data.get('leases', [])
        
        table_data = [
            [
                Paragraph('<b>Title No.</b>', self.styles['Normal']),
                Paragraph('<b>Type</b>', self.styles['Normal']),
                Paragraph('<b>Document</b>', self.styles['Normal']),
                Paragraph('<b>Pages</b>', self.styles['Normal'])
            ]
        ]
        
        for lease in leases[:50]:
            title_num = lease.get('title_number') or '—'
            lease_type = lease.get('lease_type') or lease.get('document_type') or '—'
            doc_name = lease.get('source_document') or '—'
            pages = lease.get('page_count') or '—'
            
            table_data.append([
                str(title_num)[:20],
                Paragraph(str(lease_type)[:25], self.styles['Normal']),
                Paragraph(str(doc_name)[:60], self.styles['Normal']),
                str(pages)
            ])
        
        if len(leases) > 50:
            table_data.append([f'+ {len(leases) - 50} more leases', '', '', ''])
        
        lease_table = Table(table_data, colWidths=[1.2*inch, 1.5*inch, 3.2*inch, 0.6*inch])
        lease_table.setStyle(self._get_standard_table_style())
        self.story.append(lease_table)
    
    def _add_lease_clauses(self):
        """Lease Clause Analysis"""
        self.story.append(Paragraph("■ LEASE CLAUSE ANALYSIS", self.section_header))
        self.story.append(Spacer(1, 0.15*inch))
        
        clauses = self.data.get('lease_clauses', [])
        
        # Group by category
        by_category = {}
        for clause in clauses:
            category = clause.get('clause_category', 'other')
            if category not in by_category:
                by_category[category] = []
            by_category[category].append(clause)
        
        # Show summary by category
        summary_data = [
            [Paragraph('<b>Category</b>', self.styles['Normal']), 
             Paragraph('<b>Count</b>', self.styles['Normal'])]
        ]
        
        for category, cat_clauses in sorted(by_category.items(), key=lambda x: -len(x[1])):
            summary_data.append([
                category.replace('_', ' ').title(),
                str(len(cat_clauses))
            ])
        
        summary_table = Table(summary_data, colWidths=[3*inch, 1.5*inch])
        summary_table.setStyle(self._get_standard_table_style())
        self.story.append(summary_table)
        
        self.story.append(Spacer(1, 0.15*inch))
        total_style = ParagraphStyle('Total', parent=self.styles['Normal'], fontSize=10)
        self.story.append(Paragraph(f"<b>Total Lease Clauses Extracted:</b> {len(clauses)}", total_style))
    
    def _add_contractors(self):
        """Contractors & Service Providers"""
        self.story.append(Paragraph("■ CONTRACTORS & SERVICE PROVIDERS", self.section_header))
        self.story.append(Spacer(1, 0.15*inch))
        
        contractors = self.data.get('contractors', [])
        
        table_data = [
            [
                Paragraph('<b>Service</b>', self.styles['Normal']),
                Paragraph('<b>Company</b>', self.styles['Normal']),
                Paragraph('<b>Notes</b>', self.styles['Normal'])
            ]
        ]
        
        for contractor in contractors:
            service = contractor.get('service', '—')
            company = contractor.get('company_name', '—')
            last_date = contractor.get('last_date', '')
            notes = f"Last: {last_date}" if last_date else "—"
            
            table_data.append([
                service.title(),
                Paragraph(company[:40], self.styles['Normal']),
                notes
            ])
        
        contractor_table = Table(table_data, colWidths=[1.5*inch, 2.5*inch, 2.5*inch])
        contractor_table.setStyle(self._get_standard_table_style())
        self.story.append(contractor_table)
    
    def _add_compliance(self):
        """Compliance Assets"""
        self.story.append(Paragraph("■ COMPLIANCE ASSETS & REPORTS", self.section_header))
        self.story.append(Spacer(1, 0.15*inch))
        
        assets = self.data.get('compliance_assets', [])
        
        table_data = [
            [
                Paragraph('<b>Asset Type</b>', self.styles['Normal']),
                Paragraph('<b>Status</b>', self.styles['Normal']),
                Paragraph('<b>Last Inspection</b>', self.styles['Normal']),
                Paragraph('<b>Next Due</b>', self.styles['Normal'])
            ]
        ]
        
        for asset in assets[:40]:
            asset_type = asset.get('asset_type', '—')
            status = asset.get('compliance_status', '—')
            last_inspection = asset.get('last_inspection_date', '—')
            next_due = asset.get('next_due_date', '—')
            
            table_data.append([
                Paragraph(asset_type[:40], self.styles['Normal']),
                status[:15],
                str(last_inspection)[:15] if last_inspection != '—' else '—',
                str(next_due)[:15] if next_due != '—' else '—'
            ])
        
        if len(assets) > 40:
            table_data.append([f'+ {len(assets) - 40} more assets', '', '', ''])
        
        compliance_table = Table(table_data, colWidths=[2.2*inch, 1.2*inch, 1.3*inch, 1.3*inch])
        compliance_table.setStyle(self._get_standard_table_style())
        self.story.append(compliance_table)
    
    def _get_info_table_style(self):
        """Style for information tables"""
        return TableStyle([
            ('FONTNAME', (0, 0), (0, -1), 'Helvetica-Bold'),
            ('FONTNAME', (1, 0), (1, -1), 'Helvetica'),
            ('FONTSIZE', (0, 0), (-1, -1), 10),
            ('LEFTPADDING', (0, 0), (-1, -1), 8),
            ('RIGHTPADDING', (0, 0), (-1, -1), 8),
            ('TOPPADDING', (0, 0), (-1, -1), 6),
            ('BOTTOMPADDING', (0, 0), (-1, -1), 6),
            ('ROWBACKGROUNDS', (0, 0), (-1, -1), [colors.white, self.light_bg]),
        ])
    
    def _get_standard_table_style(self):
        """Style for data tables"""
        return TableStyle([
            ('BACKGROUND', (0, 0), (-1, 0), self.primary),
            ('TEXTCOLOR', (0, 0), (-1, 0), colors.white),
            ('FONTNAME', (0, 0), (-1, 0), 'Helvetica-Bold'),
            ('FONTSIZE', (0, 0), (-1, 0), 9),
            ('FONTSIZE', (0, 1), (-1, -1), 8),
            ('ALIGN', (0, 0), (-1, 0), 'CENTER'),
            ('GRID', (0, 0), (-1, -1), 0.5, colors.grey),
            ('VALIGN', (0, 0), (-1, -1), 'TOP'),
            ('LEFTPADDING', (0, 0), (-1, -1), 6),
            ('RIGHTPADDING', (0, 0), (-1, -1), 6),
            ('TOPPADDING', (0, 0), (-1, -1), 4),
            ('BOTTOMPADDING', (0, 0), (-1, -1), 4),
            ('ROWBACKGROUNDS', (0, 1), (-1, -1), [colors.white, self.light_bg]),
        ])


def main():
    """Main entry point"""
    import argparse
    
    parser = argparse.ArgumentParser(description='Generate clean property report')
    parser.add_argument('json_file', help='Input JSON file (mapped_data.json)')
    parser.add_argument('-o', '--output', help='Output PDF file', default=None)
    
    args = parser.parse_args()
    
    # Load data
    with open(args.json_file, 'r') as f:
        data = json.load(f)
    
    # Validate
    building_id = data.get('building', {}).get('id', 'unknown')
    print(f"\n📄 Generating Clean Property Report...")
    print(f"   Building ID: {building_id}")
    print(f"   Building: {data.get('building', {}).get('name', 'Unknown')}")
    
    # Output file
    if args.output:
        output_file = args.output
    else:
        building_name = data.get('building', {}).get('name', 'Building').replace(' ', '_')
        output_file = f"output/{building_name}_CLEAN_REPORT.pdf"
    
    # Generate
    generator = CleanPropertyReport(data, output_file)
    result = generator.generate()
    
    print(f"\n✅ Clean Report Complete!")
    print(f"   File: {result}")
    print(f"   Size: {len(open(result, 'rb').read()) / 1024:.1f}KB")
    
    # Open
    import subprocess
    subprocess.run(['open', result])


if __name__ == '__main__':
    main()

