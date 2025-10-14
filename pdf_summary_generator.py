#!/usr/bin/env python3
"""
BlocIQ PDF Summary Generator
=============================
Generates professional client-facing PDF reports from extraction data.

Features:
- Executive summary
- Building overview
- Leaseholder summary
- Compliance dashboard
- Contract register
- Financial summary
- Professional styling with charts

Author: BlocIQ Team
Date: 2025-10-14
"""

import json
from pathlib import Path
from datetime import datetime
from typing import Dict, List
from weasyprint import HTML, CSS
from weasyprint.text.fonts import FontConfiguration


class PDFSummaryGenerator:
    """Generate professional PDF summaries"""

    def __init__(self):
        self.font_config = FontConfiguration()

    def generate_pdf(self, data: Dict, output_file: str) -> str:
        """
        Generate PDF summary report

        Args:
            data: Extracted building data (from JSON)
            output_file: Path to output PDF file

        Returns:
            Path to generated PDF
        """
        print(f"\n🔄 Generating PDF summary report...")

        # Generate HTML content
        html_content = self._generate_html(data)

        # Convert to PDF
        HTML(string=html_content).write_pdf(
            output_file,
            stylesheets=[CSS(string=self._get_css())],
            font_config=self.font_config
        )

        print(f"✅ PDF generated: {output_file}")
        return output_file

    def _generate_html(self, data: Dict) -> str:
        """Generate HTML content for PDF"""

        building_name = data.get('building_name', 'Unknown Building')
        extraction_date = datetime.now().strftime('%d %B %Y')

        html = f"""
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Property Summary Report - {building_name}</title>
</head>
<body>

    <!-- Cover Page -->
    <div class="cover-page">
        <div class="logo">
            <h1>BlocIQ</h1>
            <p class="tagline">Property Management Intelligence</p>
        </div>
        <div class="cover-title">
            <h2>Property Summary Report</h2>
            <h1>{building_name}</h1>
            <p class="date">{extraction_date}</p>
        </div>
        <div class="cover-footer">
            <p>Confidential - For Internal Use Only</p>
        </div>
    </div>

    <!-- Page Break -->
    <div class="page-break"></div>

    <!-- Executive Summary -->
    <div class="section">
        <h2 class="section-title">Executive Summary</h2>
        {self._generate_executive_summary(data)}
    </div>

    <!-- Building Overview -->
    <div class="section">
        <h2 class="section-title">Building Overview</h2>
        {self._generate_building_overview(data)}
    </div>

    <!-- Page Break -->
    <div class="page-break"></div>

    <!-- Leaseholder Summary -->
    <div class="section">
        <h2 class="section-title">Leaseholder Summary</h2>
        {self._generate_leaseholder_summary(data)}
    </div>

    <!-- Compliance Dashboard -->
    <div class="section">
        <h2 class="section-title">Compliance Dashboard</h2>
        {self._generate_compliance_dashboard(data)}
    </div>

    <!-- Page Break -->
    <div class="page-break"></div>

    <!-- Contract Register -->
    <div class="section">
        <h2 class="section-title">Maintenance Contracts</h2>
        {self._generate_contract_register(data)}
    </div>

    <!-- Financial Summary -->
    <div class="section">
        <h2 class="section-title">Financial Summary</h2>
        {self._generate_financial_summary(data)}
    </div>

    <!-- Data Quality & Metadata -->
    <div class="section">
        <h2 class="section-title">Data Quality & Extraction Metadata</h2>
        {self._generate_metadata(data)}
    </div>

</body>
</html>
"""
        return html

    def _generate_executive_summary(self, data: Dict) -> str:
        """Generate executive summary section"""
        summary = data.get('summary', {})
        compliance = data.get('compliance_analysis', {}).get('summary', {})

        total_units = summary.get('total_units', 0)
        total_leaseholders = summary.get('total_leaseholders', 0)
        outstanding_balance = summary.get('total_outstanding_balance', 0)
        compliance_rate = compliance.get('compliance_rate', 0)
        total_contracts = summary.get('total_contracts', 0)

        # Status indicators
        compliance_status = "critical" if compliance_rate < 30 else "warning" if compliance_rate < 70 else "good"
        balance_status = "critical" if outstanding_balance > 100000 else "warning" if outstanding_balance > 50000 else "good"

        html = f"""
        <div class="summary-grid">
            <div class="summary-card">
                <div class="card-icon">🏢</div>
                <div class="card-value">{total_units}</div>
                <div class="card-label">Total Units</div>
            </div>
            <div class="summary-card">
                <div class="card-icon">👥</div>
                <div class="card-value">{total_leaseholders}</div>
                <div class="card-label">Leaseholders</div>
            </div>
            <div class="summary-card status-{balance_status}">
                <div class="card-icon">💰</div>
                <div class="card-value">£{outstanding_balance:,.0f}</div>
                <div class="card-label">Outstanding Balance</div>
            </div>
        </div>

        <div class="summary-grid">
            <div class="summary-card status-{compliance_status}">
                <div class="card-icon">🛡️</div>
                <div class="card-value">{compliance_rate:.1f}%</div>
                <div class="card-label">Compliance Rate</div>
            </div>
            <div class="summary-card">
                <div class="card-icon">🔧</div>
                <div class="card-value">{total_contracts}</div>
                <div class="card-label">Active Contracts</div>
            </div>
            <div class="summary-card">
                <div class="card-icon">📊</div>
                <div class="card-value">{data.get('confidence_score', 0):.0%}</div>
                <div class="card-label">Data Quality</div>
            </div>
        </div>

        <div class="alert alert-info">
            <strong>Data Extraction Summary:</strong> This report contains comprehensive property data extracted using BlocIQ's AI-powered extraction system (v{data.get('extraction_version', 'Unknown')}). All data has been validated with {data.get('confidence_score', 0):.0%} confidence.
        </div>
        """

        return html

    def _generate_building_overview(self, data: Dict) -> str:
        """Generate building overview section"""
        building_name = data.get('building_name', 'Unknown')
        address = data.get('building_address', '')
        postcode = data.get('postcode', '')
        num_units = data.get('num_units', 0)
        num_floors = data.get('num_floors', 'N/A')
        height = data.get('building_height_meters', 'N/A')
        construction_era = data.get('construction_era', 'Unknown')
        year_built = data.get('year_built', 'Unknown')
        bsa_status = data.get('bsa_status', 'Not Registered')

        # Special facilities
        facilities = []
        if data.get('has_gym'): facilities.append('Gym')
        if data.get('has_pool'): facilities.append('Swimming Pool')
        if data.get('has_sauna'): facilities.append('Sauna')
        if data.get('has_squash_court'): facilities.append('Squash Court')
        if data.get('has_ev_charging'): facilities.append('EV Charging')

        facilities_str = ', '.join(facilities) if facilities else 'None'

        html = f"""
        <table class="info-table">
            <tr>
                <th>Property Name</th>
                <td>{building_name}</td>
            </tr>
            <tr>
                <th>Address</th>
                <td>{address}<br>{postcode}</td>
            </tr>
            <tr>
                <th>Units</th>
                <td>{num_units} residential units</td>
            </tr>
            <tr>
                <th>Building Details</th>
                <td>{num_floors} floors, {height}m height</td>
            </tr>
            <tr>
                <th>Construction</th>
                <td>{construction_era} ({year_built})</td>
            </tr>
            <tr>
                <th>BSA Status</th>
                <td><span class="badge">{bsa_status}</span></td>
            </tr>
            <tr>
                <th>Special Facilities</th>
                <td>{facilities_str}</td>
            </tr>
        </table>
        """

        return html

    def _generate_leaseholder_summary(self, data: Dict) -> str:
        """Generate leaseholder summary section"""
        leaseholders = data.get('leaseholders', [])
        total_leaseholders = len(leaseholders)
        with_balances = sum(1 for lh in leaseholders if lh.get('balance', 0) != 0)
        total_balance = sum(lh.get('balance', 0) for lh in leaseholders)

        # Coverage
        units = data.get('units', [])
        coverage = len(leaseholders) / len(units) * 100 if units else 0

        html = f"""
        <div class="stats-row">
            <div class="stat-box">
                <div class="stat-value">{total_leaseholders}</div>
                <div class="stat-label">Total Leaseholders</div>
            </div>
            <div class="stat-box">
                <div class="stat-value">{coverage:.1f}%</div>
                <div class="stat-label">Coverage</div>
            </div>
            <div class="stat-box">
                <div class="stat-value">{with_balances}</div>
                <div class="stat-label">With Outstanding Balance</div>
            </div>
            <div class="stat-box">
                <div class="stat-value">£{total_balance:,.2f}</div>
                <div class="stat-label">Total Outstanding</div>
            </div>
        </div>

        <h3>Leaseholder Register</h3>
        <table class="data-table">
            <thead>
                <tr>
                    <th>Unit</th>
                    <th>Leaseholder Name</th>
                    <th>Contact</th>
                    <th class="text-right">Balance</th>
                </tr>
            </thead>
            <tbody>
        """

        # Show top 10 leaseholders
        for lh in leaseholders[:10]:
            unit = lh.get('unit_number', 'N/A')
            name = lh.get('leaseholder_name', 'Unknown')
            phone = lh.get('telephone', 'N/A')
            balance = lh.get('balance', 0)

            balance_class = 'text-danger' if balance > 5000 else 'text-warning' if balance > 0 else ''

            html += f"""
                <tr>
                    <td>{unit}</td>
                    <td>{name}</td>
                    <td>{phone}</td>
                    <td class="text-right {balance_class}">£{balance:,.2f}</td>
                </tr>
            """

        if len(leaseholders) > 10:
            html += f"""
                <tr>
                    <td colspan="4" class="text-center" style="font-style: italic;">
                        ... and {len(leaseholders) - 10} more
                    </td>
                </tr>
            """

        html += """
            </tbody>
        </table>
        """

        return html

    def _generate_compliance_dashboard(self, data: Dict) -> str:
        """Generate compliance dashboard section"""
        compliance = data.get('compliance_analysis', {})
        summary = compliance.get('summary', {})

        total_required = summary.get('total_required', 0)
        current = summary.get('current', 0)
        expired = summary.get('expired', 0)
        missing = summary.get('missing', 0)
        compliance_rate = summary.get('compliance_rate', 0)

        # Status
        status = "CRITICAL" if compliance_rate < 30 else "NEEDS ATTENTION" if compliance_rate < 70 else "GOOD"
        status_class = "danger" if compliance_rate < 30 else "warning" if compliance_rate < 70 else "success"

        html = f"""
        <div class="compliance-header">
            <div class="compliance-rate">
                <div class="rate-circle status-{status_class}">
                    <div class="rate-value">{compliance_rate:.1f}%</div>
                </div>
                <div class="rate-label">Overall Compliance</div>
            </div>
            <div class="compliance-stats">
                <div class="stat-item">
                    <span class="stat-number">{total_required}</span>
                    <span class="stat-text">Required</span>
                </div>
                <div class="stat-item status-success">
                    <span class="stat-number">{current}</span>
                    <span class="stat-text">Current</span>
                </div>
                <div class="stat-item status-warning">
                    <span class="stat-number">{expired}</span>
                    <span class="stat-text">Expired</span>
                </div>
                <div class="stat-item status-danger">
                    <span class="stat-number">{missing}</span>
                    <span class="stat-text">Missing</span>
                </div>
            </div>
        </div>

        <div class="alert alert-{status_class}">
            <strong>Compliance Status: {status}</strong><br>
            {current} of {total_required} required compliance assets are current.
            {expired} assets have expired and {missing} are missing.
        </div>

        <h3>Critical Issues Requiring Attention</h3>
        """

        # Expired assets
        expired_assets = compliance.get('expired', [])
        if expired_assets:
            html += """
            <h4 class="text-danger">🔴 Expired Assets (Immediate Action Required)</h4>
            <table class="data-table">
                <thead>
                    <tr>
                        <th>Asset Type</th>
                        <th>Last Inspection</th>
                        <th>Status</th>
                    </tr>
                </thead>
                <tbody>
            """
            for asset in expired_assets[:5]:
                html += f"""
                    <tr>
                        <td>{asset.get('asset_type', 'Unknown')}</td>
                        <td>{asset.get('inspection_date', 'N/A')}</td>
                        <td><span class="badge badge-danger">Expired</span></td>
                    </tr>
                """
            html += """
                </tbody>
            </table>
            """

        # Missing assets
        missing_assets = compliance.get('regulatory_missing', [])
        if missing_assets:
            html += """
            <h4 class="text-warning">⚠️ Missing Assets (Investigation Required)</h4>
            <table class="data-table">
                <thead>
                    <tr>
                        <th>Asset Type</th>
                        <th>Priority</th>
                        <th>Regulatory Basis</th>
                    </tr>
                </thead>
                <tbody>
            """
            for asset in missing_assets[:5]:
                priority = asset.get('priority', 'medium')
                html += f"""
                    <tr>
                        <td>{asset.get('asset_type', 'Unknown')}</td>
                        <td><span class="badge badge-{priority}">{priority.upper()}</span></td>
                        <td>{asset.get('regulatory_basis', 'N/A')}</td>
                    </tr>
                """
            html += """
                </tbody>
            </table>
            """

        return html

    def _generate_contract_register(self, data: Dict) -> str:
        """Generate contract register section"""
        contracts = data.get('maintenance_contracts', [])
        total_contracts = len(contracts)

        html = f"""
        <p><strong>Total Contracts:</strong> {total_contracts}</p>

        <table class="data-table">
            <thead>
                <tr>
                    <th>Contract Type</th>
                    <th>Contractor</th>
                    <th>Start Date</th>
                    <th>End Date</th>
                    <th>Status</th>
                </tr>
            </thead>
            <tbody>
        """

        for contract in contracts[:10]:
            contract_type = contract.get('contract_type', 'Unknown')
            contractor = contract.get('contractor_name', 'Unknown')
            start_date = contract.get('contract_start_date', 'N/A')
            end_date = contract.get('contract_end_date', 'N/A')
            status = contract.get('contract_status', 'Unknown')

            status_class = 'success' if status == 'Active' else 'danger' if status == 'Expired' else 'warning'

            html += f"""
                <tr>
                    <td>{contract_type}</td>
                    <td>{contractor}</td>
                    <td>{start_date}</td>
                    <td>{end_date}</td>
                    <td><span class="badge badge-{status_class}">{status}</span></td>
                </tr>
            """

        if len(contracts) > 10:
            html += f"""
                <tr>
                    <td colspan="5" class="text-center" style="font-style: italic;">
                        ... and {len(contracts) - 10} more
                    </td>
                </tr>
            """

        html += """
            </tbody>
        </table>
        """

        return html

    def _generate_financial_summary(self, data: Dict) -> str:
        """Generate financial summary section"""
        summary = data.get('summary', {})
        budget_total = summary.get('service_charge_budget') or summary.get('total_budget', 0)
        outstanding = summary.get('total_outstanding_balance', 0)
        leaseholders_with_balance = summary.get('leaseholders_with_balances', 0)

        html = f"""
        <table class="info-table">
            <tr>
                <th>Service Charge Budget (Annual)</th>
                <td>£{budget_total:,.2f}</td>
            </tr>
            <tr>
                <th>Total Outstanding Balances</th>
                <td class="text-danger"><strong>£{outstanding:,.2f}</strong></td>
            </tr>
            <tr>
                <th>Leaseholders with Outstanding Balance</th>
                <td>{leaseholders_with_balance}</td>
            </tr>
            <tr>
                <th>Average Balance per Leaseholder</th>
                <td>£{outstanding / max(leaseholders_with_balance, 1):,.2f}</td>
            </tr>
        </table>

        <div class="alert alert-info">
            <strong>Note:</strong> Outstanding balances require follow-up action. Consider payment plans for balances over £5,000.
        </div>
        """

        return html

    def _generate_metadata(self, data: Dict) -> str:
        """Generate metadata section"""
        extraction_date = data.get('extraction_timestamp', datetime.now().isoformat())
        extraction_version = data.get('extraction_version', 'Unknown')
        confidence = data.get('confidence_score', 0)
        data_quality = data.get('data_quality', 'Unknown')

        # Adaptive detection results
        new_types = data.get('summary', {}).get('new_contract_types_discovered', 0)

        html = f"""
        <table class="info-table">
            <tr>
                <th>Extraction Date</th>
                <td>{extraction_date}</td>
            </tr>
            <tr>
                <th>System Version</th>
                <td>{extraction_version}</td>
            </tr>
            <tr>
                <th>Data Quality</th>
                <td><span class="badge badge-success">{data_quality.upper()}</span></td>
            </tr>
            <tr>
                <th>Confidence Score</th>
                <td>{confidence:.0%}</td>
            </tr>
            <tr>
                <th>New Contract Types Discovered</th>
                <td>{new_types}</td>
            </tr>
        </table>

        <div class="alert alert-info">
            <strong>About BlocIQ:</strong> This report was generated using BlocIQ's comprehensive property data extraction system, which uses AI-powered analysis combined with regulatory intelligence to provide accurate, structured property data. The system automatically discovers and tracks 50+ compliance asset types and maintenance contracts.
        </div>
        """

        return html

    def _get_css(self) -> str:
        """Get CSS styling for PDF"""
        return """
        @page {
            size: A4;
            margin: 2cm;
        }

        body {
            font-family: 'Helvetica', 'Arial', sans-serif;
            font-size: 10pt;
            color: #333;
            line-height: 1.6;
        }

        /* Cover Page */
        .cover-page {
            height: 100vh;
            display: flex;
            flex-direction: column;
            justify-content: space-between;
            text-align: center;
            page-break-after: always;
        }

        .logo h1 {
            font-size: 48pt;
            color: #0066cc;
            margin: 0;
            padding-top: 100px;
        }

        .logo .tagline {
            font-size: 14pt;
            color: #666;
            margin-top: 10px;
        }

        .cover-title {
            margin-top: 100px;
        }

        .cover-title h2 {
            font-size: 18pt;
            color: #666;
            font-weight: normal;
            margin: 0;
        }

        .cover-title h1 {
            font-size: 32pt;
            color: #0066cc;
            margin: 20px 0;
        }

        .cover-title .date {
            font-size: 14pt;
            color: #666;
        }

        .cover-footer {
            font-size: 10pt;
            color: #999;
            padding-bottom: 50px;
        }

        /* Page Break */
        .page-break {
            page-break-after: always;
        }

        /* Sections */
        .section {
            margin-bottom: 30px;
        }

        .section-title {
            color: #0066cc;
            border-bottom: 2px solid #0066cc;
            padding-bottom: 5px;
            margin-top: 30px;
            font-size: 16pt;
        }

        /* Summary Grid */
        .summary-grid {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 15px;
            margin: 20px 0;
        }

        .summary-card {
            background: #f8f9fa;
            padding: 20px;
            border-radius: 8px;
            text-align: center;
            border: 1px solid #ddd;
        }

        .summary-card.status-good {
            background: #d4edda;
            border-color: #28a745;
        }

        .summary-card.status-warning {
            background: #fff3cd;
            border-color: #ffc107;
        }

        .summary-card.status-critical {
            background: #f8d7da;
            border-color: #dc3545;
        }

        .card-icon {
            font-size: 32pt;
            margin-bottom: 10px;
        }

        .card-value {
            font-size: 24pt;
            font-weight: bold;
            color: #333;
        }

        .card-label {
            font-size: 10pt;
            color: #666;
            margin-top: 5px;
        }

        /* Tables */
        .info-table {
            width: 100%;
            border-collapse: collapse;
            margin: 20px 0;
        }

        .info-table th {
            text-align: left;
            padding: 10px;
            background: #f8f9fa;
            border: 1px solid #ddd;
            width: 40%;
            font-weight: bold;
        }

        .info-table td {
            padding: 10px;
            border: 1px solid #ddd;
        }

        .data-table {
            width: 100%;
            border-collapse: collapse;
            margin: 20px 0;
            font-size: 9pt;
        }

        .data-table thead {
            background: #0066cc;
            color: white;
        }

        .data-table th {
            padding: 10px;
            text-align: left;
            font-weight: bold;
        }

        .data-table td {
            padding: 8px;
            border-bottom: 1px solid #ddd;
        }

        .data-table tbody tr:hover {
            background: #f8f9fa;
        }

        /* Stats */
        .stats-row {
            display: grid;
            grid-template-columns: repeat(4, 1fr);
            gap: 15px;
            margin: 20px 0;
        }

        .stat-box {
            text-align: center;
            padding: 15px;
            background: #f8f9fa;
            border-radius: 8px;
            border: 1px solid #ddd;
        }

        .stat-value {
            font-size: 24pt;
            font-weight: bold;
            color: #0066cc;
        }

        .stat-label {
            font-size: 9pt;
            color: #666;
            margin-top: 5px;
        }

        /* Compliance */
        .compliance-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin: 20px 0;
        }

        .compliance-rate {
            text-align: center;
        }

        .rate-circle {
            width: 120px;
            height: 120px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto;
            border: 8px solid #ddd;
        }

        .rate-circle.status-success {
            border-color: #28a745;
        }

        .rate-circle.status-warning {
            border-color: #ffc107;
        }

        .rate-circle.status-danger {
            border-color: #dc3545;
        }

        .rate-value {
            font-size: 28pt;
            font-weight: bold;
        }

        .rate-label {
            font-size: 10pt;
            color: #666;
            margin-top: 10px;
        }

        .compliance-stats {
            display: grid;
            grid-template-columns: repeat(4, 1fr);
            gap: 15px;
        }

        .stat-item {
            text-align: center;
            padding: 15px;
            background: #f8f9fa;
            border-radius: 8px;
        }

        .stat-item.status-success {
            background: #d4edda;
        }

        .stat-item.status-warning {
            background: #fff3cd;
        }

        .stat-item.status-danger {
            background: #f8d7da;
        }

        .stat-number {
            display: block;
            font-size: 24pt;
            font-weight: bold;
        }

        .stat-text {
            display: block;
            font-size: 9pt;
            color: #666;
        }

        /* Alerts */
        .alert {
            padding: 15px;
            border-radius: 8px;
            margin: 20px 0;
            border: 1px solid;
        }

        .alert-info {
            background: #d1ecf1;
            border-color: #bee5eb;
            color: #0c5460;
        }

        .alert-success {
            background: #d4edda;
            border-color: #c3e6cb;
            color: #155724;
        }

        .alert-warning {
            background: #fff3cd;
            border-color: #ffeeba;
            color: #856404;
        }

        .alert-danger {
            background: #f8d7da;
            border-color: #f5c6cb;
            color: #721c24;
        }

        /* Badges */
        .badge {
            display: inline-block;
            padding: 4px 12px;
            border-radius: 4px;
            font-size: 9pt;
            font-weight: bold;
            background: #6c757d;
            color: white;
        }

        .badge-success {
            background: #28a745;
        }

        .badge-warning {
            background: #ffc107;
            color: #333;
        }

        .badge-danger {
            background: #dc3545;
        }

        .badge-critical {
            background: #dc3545;
        }

        .badge-high {
            background: #fd7e14;
        }

        .badge-medium {
            background: #ffc107;
            color: #333;
        }

        .badge-low {
            background: #6c757d;
        }

        /* Text Utilities */
        .text-right {
            text-align: right;
        }

        .text-center {
            text-align: center;
        }

        .text-danger {
            color: #dc3545;
        }

        .text-warning {
            color: #ffc107;
        }

        .text-success {
            color: #28a745;
        }

        /* Headings */
        h3 {
            color: #0066cc;
            font-size: 12pt;
            margin-top: 20px;
            margin-bottom: 10px;
        }

        h4 {
            font-size: 11pt;
            margin-top: 15px;
            margin-bottom: 10px;
        }

        /* Print */
        @media print {
            .page-break {
                page-break-after: always;
            }
        }
        """


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
        output_file = args.json_file.replace('.json', '_summary.pdf')

    # Generate PDF
    generator = PDFSummaryGenerator()
    generator.generate_pdf(data, output_file)

    print(f"\n✅ PDF Summary Report Complete!")
    print(f"   Output: {output_file}")


if __name__ == '__main__':
    main()
