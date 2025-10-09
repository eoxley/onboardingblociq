/**
 * BlocIQ Building Health Check V2 Generator
 * Professional, brand-aligned PDF report generator
 *
 * @version 2.0.0
 * @author BlocIQ Property Intelligence
 */

import PDFDocument from 'pdfkit';
import * as fs from 'fs';
import * as path from 'path';
import * as dayjs from 'dayjs';
import { BlocIQBrand, StatusColors, StatusIcons } from './brand';

// Type Definitions
interface BuildingData {
  building: {
    id: string;
    name: string;
    address: string;
    year_built?: number;
    units_count: number;
    portfolio?: string;
    last_updated: string;
  };
  leases?: any[];
  insurance?: any[];
  budgets?: any[];
  compliance?: any[];
  contractors?: any[];
  majorWorks?: any[];
  documents?: any[];
}

export class BuildingHealthCheckV2 {
  private doc: PDFDocument;
  private data: BuildingData;
  private outputPath: string;
  private y: number = 50; // Current Y position

  constructor(data: BuildingData, outputPath: string) {
    this.data = data;
    this.outputPath = outputPath;
    this.doc = new PDFDocument({
      size: 'A4',
      margins: {
        top: BlocIQBrand.spacing.pageMargin,
        bottom: BlocIQBrand.spacing.pageMargin,
        left: BlocIQBrand.spacing.pageMargin,
        right: BlocIQBrand.spacing.pageMargin
      },
      info: {
        Title: 'BlocIQ Building Health Check',
        Author: 'BlocIQ Property Intelligence',
        Subject: `Health Check Report for ${data.building.name}`,
        Keywords: 'property management, building health, compliance, BlocIQ',
        CreationDate: new Date()
      }
    });
  }

  /**
   * Generate the complete PDF report
   */
  public async generate(): Promise<void> {
    try {
      // Create output stream
      const stream = fs.createWriteStream(this.outputPath);
      this.doc.pipe(stream);

      // Render all sections
      this.renderCoverPage();
      this.renderExecutiveSummary();
      this.renderBuildingOverview();

      if (this.data.leases && this.data.leases.length > 0) {
        this.renderLeaseSummary();
      }

      if (this.data.insurance && this.data.insurance.length > 0) {
        this.renderInsuranceSummary();
      }

      if (this.data.budgets && this.data.budgets.length > 0) {
        this.renderBudgetSummary();
      }

      if (this.data.compliance && this.data.compliance.length > 0) {
        this.renderComplianceOverview();
      }

      if (this.data.contractors && this.data.contractors.length > 0) {
        this.renderContractors();
      }

      if (this.data.majorWorks && this.data.majorWorks.length > 0) {
        this.renderMajorWorks();
      }

      if (this.data.documents && this.data.documents.length > 0) {
        this.renderDocumentIndex();
      }

      // Finalize PDF
      this.doc.end();

      return new Promise((resolve, reject) => {
        stream.on('finish', () => {
          console.log(`✅ BlocIQ Health Check generated for ${this.data.building.name}`);
          console.log(`Output: ${this.outputPath}`);
          resolve();
        });
        stream.on('error', reject);
      });
    } catch (error) {
      console.error('❌ Error generating Health Check:', error);
      throw error;
    }
  }

  /**
   * COVER PAGE
   */
  private renderCoverPage(): void {
    const { building } = this.data;
    const pageWidth = this.doc.page.width;
    const pageHeight = this.doc.page.height;

    // Background
    this.doc.rect(0, 0, pageWidth, pageHeight).fill(BlocIQBrand.colours.background);

    // BlocIQ Logo/Title
    this.doc
      .fontSize(32)
      .fillColor(BlocIQBrand.colours.primary)
      .font('Helvetica-Bold')
      .text('BlocIQ', 0, 120, { align: 'center' });

    // Building Name
    this.doc
      .fontSize(BlocIQBrand.fontSize.title)
      .fillColor(BlocIQBrand.colours.text)
      .font('Helvetica-Bold')
      .text(building.name, 50, 200, { align: 'center', width: pageWidth - 100 });

    // Building Address
    this.doc
      .fontSize(BlocIQBrand.fontSize.heading2)
      .fillColor(BlocIQBrand.colours.text)
      .font('Helvetica')
      .text(building.address, 50, 240, { align: 'center', width: pageWidth - 100 });

    // Report Title
    this.doc
      .fontSize(BlocIQBrand.fontSize.heading1)
      .fillColor(BlocIQBrand.colours.secondary)
      .font('Helvetica-Bold')
      .text('Building Health Check Report', 50, 320, { align: 'center', width: pageWidth - 100 });

    // Date
    this.doc
      .fontSize(BlocIQBrand.fontSize.body)
      .fillColor(BlocIQBrand.colours.text)
      .font('Helvetica')
      .text(`Generated: ${dayjs().format('DD MMMM YYYY')}`, 50, 360, { align: 'center', width: pageWidth - 100 });

    // Health Score Box
    const healthScore = this.calculateHealthScore();
    const status = this.getHealthStatus(healthScore);
    const statusColor = this.getStatusColor(healthScore);

    this.doc
      .roundedRect(100, 420, pageWidth - 200, 80, 10)
      .fillAndStroke(BlocIQBrand.colours.white, BlocIQBrand.colours.secondary);

    this.doc
      .fontSize(BlocIQBrand.fontSize.heading3)
      .fillColor(BlocIQBrand.colours.text)
      .font('Helvetica-Bold')
      .text(`Building Health Score: ${healthScore}%`, 0, 440, { align: 'center' });

    this.doc
      .fontSize(BlocIQBrand.fontSize.body)
      .fillColor(statusColor)
      .text(`Status: ${status}`, 0, 465, { align: 'center' });

    // Disclaimer
    this.doc
      .fontSize(BlocIQBrand.fontSize.small)
      .fillColor(BlocIQBrand.colours.text)
      .font('Helvetica')
      .text(
        'This Building Health Check has been prepared by BlocIQ Property Intelligence.\n' +
        'It is automatically generated from data, documents, and certificates uploaded to the BlocIQ platform.\n' +
        'While every effort is made to ensure accuracy, the report is provided for information only and should not be relied upon as legal, financial, or technical advice.\n' +
        'The content reflects information available as of the generation date.',
        50,
        pageHeight - 130,
        { align: 'center', width: pageWidth - 100, lineGap: 2 }
      );

    this.doc.addPage();
    this.y = 50;
  }

  /**
   * EXECUTIVE SUMMARY
   */
  private renderExecutiveSummary(): void {
    this.addSectionHeader('Executive Summary');

    const { building, compliance = [], insurance = [], budgets = [], leases = [] } = this.data;

    // Key Metrics Table
    const metrics = [
      ['Metric', 'Value'],
      ['Units', building.units_count.toString()],
      ['Leaseholders', leases.length.toString()],
      ['Compliance Assets', compliance.length.toString()],
      ['  Compliant', compliance.filter(c => c.status === 'compliant').length.toString()],
      ['  Overdue', compliance.filter(c => c.status === 'overdue').length.toString()],
      ['  Unknown', compliance.filter(c => c.status === 'unknown').length.toString()],
      ['Insurance Policies', insurance.length.toString()],
      ['Budgets Captured', budgets.length > 0 ? '100%' : '0%'],
      ['Lease Coverage', leases.length > 0 ? '100%' : '0%'],
      ['Overall Health Score', `${this.calculateHealthScore()}%`]
    ];

    this.renderTable(metrics, [250, 250]);

    this.y += 30;

    // Health Score Bars
    this.addText('Health Component Breakdown', BlocIQBrand.fontSize.heading3, true);
    this.y += 10;

    const components = [
      { label: 'Compliance', score: this.getComplianceScore() },
      { label: 'Insurance', score: this.getInsuranceScore() },
      { label: 'Budgets', score: this.getBudgetScore() },
      { label: 'Lease Data', score: this.getLeaseScore() }
    ];

    components.forEach(comp => {
      this.renderProgressBar(comp.label, comp.score);
      this.y += 5;
    });

    this.doc.addPage();
    this.y = 50;
  }

  /**
   * BUILDING OVERVIEW
   */
  private renderBuildingOverview(): void {
    this.addSectionHeader('Building Overview');

    const { building } = this.data;

    const overview = [
      ['Field', 'Data'],
      ['Building Name', building.name],
      ['Address', building.address],
      ['Year Built', building.year_built?.toString() || 'N/A'],
      ['Managed Through', 'BlocIQ'],
      ['Units', building.units_count.toString()],
      ['Current Health Rating', `${this.calculateHealthScore()}% (${this.getHealthStatus(this.calculateHealthScore())})`]
    ];

    this.renderTable(overview, [200, 300]);

    this.doc.addPage();
    this.y = 50;
  }

  /**
   * LEASE SUMMARY
   */
  private renderLeaseSummary(): void {
    this.addSectionHeader('Lease Summary');

    const leases = this.data.leases || [];

    if (leases.length === 0) {
      this.addText('No lease data available', BlocIQBrand.fontSize.body);
      return;
    }

    const headers = ['Unit', 'Term Start', 'Term (yrs)', 'Expiry', 'Ground Rent', 'SC Year'];
    const rows = [headers];

    leases.slice(0, 10).forEach(lease => {
      rows.push([
        lease.unit || 'N/A',
        lease.term_start ? dayjs(lease.term_start).format('DD/MM/YYYY') : 'N/A',
        lease.term_years?.toString() || 'N/A',
        lease.expiry ? dayjs(lease.expiry).format('DD/MM/YYYY') : 'N/A',
        lease.ground_rent ? `£${lease.ground_rent}` : 'N/A',
        lease.sc_year || 'N/A'
      ]);
    });

    this.renderTable(rows, [80, 80, 60, 80, 80, 80]);

    if (leases.length > 10) {
      this.y += 10;
      this.addText(`... and ${leases.length - 10} more leases`, BlocIQBrand.fontSize.small);
    }

    this.doc.addPage();
    this.y = 50;
  }

  /**
   * INSURANCE SUMMARY
   */
  private renderInsuranceSummary(): void {
    this.addSectionHeader('Insurance Summary');

    const insurance = this.data.insurance || [];

    const headers = ['Provider', 'Policy No.', 'Period', 'Sum Insured', 'Premium', 'Status'];
    const rows = [headers];

    insurance.forEach(policy => {
      rows.push([
        policy.provider || 'N/A',
        policy.policy_number || 'N/A',
        policy.period || 'N/A',
        policy.sum_insured ? `£${policy.sum_insured.toLocaleString()}` : 'N/A',
        policy.premium ? `£${policy.premium.toLocaleString()}` : 'N/A',
        policy.status === 'active' ? '✓ Active' : policy.status
      ]);
    });

    this.renderTable(rows, [100, 80, 100, 90, 70, 60]);

    this.doc.addPage();
    this.y = 50;
  }

  /**
   * BUDGET SUMMARY
   */
  private renderBudgetSummary(): void {
    this.addSectionHeader('Budget Summary');

    const budgets = this.data.budgets || [];

    const headers = ['Cost Heading', 'Budget 25/26', 'Actual 24/25', 'Variance', 'Comment'];
    const rows = [headers];

    budgets.forEach(budget => {
      const variance = budget.budget && budget.actual ?
        ((budget.actual - budget.budget) / budget.budget * 100).toFixed(1) + '%' : 'N/A';

      rows.push([
        budget.heading || 'N/A',
        budget.budget ? `£${budget.budget.toLocaleString()}` : 'N/A',
        budget.actual ? `£${budget.actual.toLocaleString()}` : 'N/A',
        variance,
        budget.comment || ''
      ]);
    });

    this.renderTable(rows, [150, 80, 80, 70, 120]);

    this.doc.addPage();
    this.y = 50;
  }

  /**
   * COMPLIANCE OVERVIEW
   */
  private renderComplianceOverview(): void {
    this.addSectionHeader('Compliance Overview');

    const compliance = this.data.compliance || [];

    const headers = ['Type', 'Date', 'Next Due', 'Status', 'Responsible'];
    const rows = [headers];

    compliance.forEach(item => {
      const status = this.getComplianceStatusIcon(item.status);

      rows.push([
        item.type || 'N/A',
        item.date ? dayjs(item.date).format('DD/MM/YYYY') : 'N/A',
        item.next_due ? dayjs(item.next_due).format('DD/MM/YYYY') : 'N/A',
        status,
        item.responsible || 'N/A'
      ]);
    });

    this.renderTable(rows, [100, 80, 80, 80, 160]);

    this.doc.addPage();
    this.y = 50;
  }

  /**
   * CONTRACTORS
   */
  private renderContractors(): void {
    this.addSectionHeader('Contractors & Service Providers');

    const contractors = this.data.contractors || [];

    const headers = ['Service', 'Contractor', 'Contact', 'Renewal', 'Status'];
    const rows = [headers];

    contractors.forEach(contractor => {
      rows.push([
        contractor.service || 'N/A',
        contractor.name || 'N/A',
        contractor.contact || 'N/A',
        contractor.renewal ? dayjs(contractor.renewal).format('DD/MM/YYYY') : 'N/A',
        contractor.status || 'Active'
      ]);
    });

    this.renderTable(rows, [100, 120, 120, 80, 80]);

    this.doc.addPage();
    this.y = 50;
  }

  /**
   * MAJOR WORKS
   */
  private renderMajorWorks(): void {
    this.addSectionHeader('Major Works / Projects');

    const works = this.data.majorWorks || [];

    works.forEach(work => {
      this.addText(work.project || 'Project', BlocIQBrand.fontSize.heading3, true);
      this.addText(`Status: ${work.status || 'N/A'}`, BlocIQBrand.fontSize.body);
      this.addText(`Budget: £${work.budget?.toLocaleString() || 'N/A'}`, BlocIQBrand.fontSize.body);
      this.addText(`Description: ${work.description || 'N/A'}`, BlocIQBrand.fontSize.body);
      this.y += 20;
    });

    this.doc.addPage();
    this.y = 50;
  }

  /**
   * DOCUMENT INDEX
   */
  private renderDocumentIndex(): void {
    this.addSectionHeader('Document Index (Appendix)');

    const documents = this.data.documents || [];

    const headers = ['File', 'Category', 'Uploaded', 'OCR Status'];
    const rows = [headers];

    documents.slice(0, 50).forEach(doc => {
      rows.push([
        this.truncateText(doc.filename || 'N/A', 30),
        doc.category || 'N/A',
        doc.uploaded ? dayjs(doc.uploaded).format('DD/MM/YYYY') : 'N/A',
        doc.ocr_status || 'N/A'
      ]);
    });

    this.renderTable(rows, [180, 80, 80, 80]);

    if (documents.length > 50) {
      this.y += 10;
      this.addText(`... and ${documents.length - 50} more documents`, BlocIQBrand.fontSize.small);
    }
  }

  // ============================================================================
  // HELPER METHODS
  // ============================================================================

  private addSectionHeader(title: string): void {
    this.doc
      .fontSize(BlocIQBrand.fontSize.heading1)
      .fillColor(BlocIQBrand.colours.primary)
      .font('Helvetica-Bold')
      .text(title, 50, this.y);

    this.y += 30;

    // Underline
    this.doc
      .moveTo(50, this.y)
      .lineTo(this.doc.page.width - 50, this.y)
      .strokeColor(BlocIQBrand.colours.secondary)
      .lineWidth(2)
      .stroke();

    this.y += 20;
  }

  private addText(text: string, fontSize: number = BlocIQBrand.fontSize.body, bold: boolean = false): void {
    this.doc
      .fontSize(fontSize)
      .fillColor(BlocIQBrand.colours.text)
      .font(bold ? 'Helvetica-Bold' : 'Helvetica')
      .text(text, 50, this.y, { width: this.doc.page.width - 100 });

    this.y += fontSize + 5;
  }

  private renderTable(rows: string[][], columnWidths: number[]): void {
    const startX = 50;
    const rowHeight = BlocIQBrand.spacing.tableRowHeight;

    rows.forEach((row, rowIndex) => {
      let x = startX;

      // Background color for alternating rows
      if (rowIndex > 0 && rowIndex % 2 === 0) {
        this.doc
          .rect(startX, this.y, columnWidths.reduce((a, b) => a + b, 0), rowHeight)
          .fill(BlocIQBrand.colours.tableAlt);
      }

      row.forEach((cell, colIndex) => {
        const isHeader = rowIndex === 0;

        this.doc
          .fontSize(BlocIQBrand.fontSize.body)
          .fillColor(BlocIQBrand.colours.text)
          .font(isHeader ? 'Helvetica-Bold' : 'Helvetica')
          .text(cell, x + 5, this.y + 5, {
            width: columnWidths[colIndex] - 10,
            height: rowHeight - 10,
            ellipsis: true
          });

        x += columnWidths[colIndex];
      });

      this.y += rowHeight;
    });
  }

  private renderProgressBar(label: string, score: number): void {
    const barWidth = 300;
    const barHeight = 20;
    const x = 50;

    // Label
    this.doc
      .fontSize(BlocIQBrand.fontSize.body)
      .fillColor(BlocIQBrand.colours.text)
      .font('Helvetica')
      .text(label, x, this.y);

    // Background bar
    this.doc
      .rect(x + 150, this.y, barWidth, barHeight)
      .fill(BlocIQBrand.colours.tableAlt);

    // Progress bar
    const fillWidth = (score / 100) * barWidth;
    const color = score >= 80 ? BlocIQBrand.colours.success :
                  score >= 60 ? BlocIQBrand.colours.warning :
                  BlocIQBrand.colours.danger;

    this.doc
      .rect(x + 150, this.y, fillWidth, barHeight)
      .fill(color);

    // Percentage
    this.doc
      .fontSize(BlocIQBrand.fontSize.body)
      .fillColor(BlocIQBrand.colours.text)
      .font('Helvetica-Bold')
      .text(`${score}%`, x + 150 + barWidth + 10, this.y + 5);

    this.y += barHeight + 10;
  }

  private calculateHealthScore(): number {
    const complianceScore = this.getComplianceScore();
    const insuranceScore = this.getInsuranceScore();
    const budgetScore = this.getBudgetScore();
    const leaseScore = this.getLeaseScore();

    const score = (complianceScore * 0.4) +
                  (insuranceScore * 0.2) +
                  (budgetScore * 0.2) +
                  (leaseScore * 0.2);

    return Math.round(score);
  }

  private getComplianceScore(): number {
    const compliance = this.data.compliance || [];
    if (compliance.length === 0) return 0;
    const compliant = compliance.filter(c => c.status === 'compliant').length;
    return Math.round((compliant / compliance.length) * 100);
  }

  private getInsuranceScore(): number {
    return this.data.insurance && this.data.insurance.length > 0 ? 100 : 0;
  }

  private getBudgetScore(): number {
    return this.data.budgets && this.data.budgets.length > 0 ? 100 : 0;
  }

  private getLeaseScore(): number {
    return this.data.leases && this.data.leases.length > 0 ? 100 : 0;
  }

  private getHealthStatus(score: number): string {
    if (score >= 80) return 'Excellent';
    if (score >= 60) return 'Satisfactory';
    return 'Requires Attention';
  }

  private getStatusColor(score: number): string {
    if (score >= 80) return BlocIQBrand.colours.success;
    if (score >= 60) return BlocIQBrand.colours.warning;
    return BlocIQBrand.colours.danger;
  }

  private getComplianceStatusIcon(status: string): string {
    switch (status) {
      case 'compliant': return '✓ Compliant';
      case 'due_soon': return '⚠ Due Soon';
      case 'overdue': return '✗ Overdue';
      default: return '? Unknown';
    }
  }

  private truncateText(text: string, maxLength: number): string {
    return text.length > maxLength ? text.substring(0, maxLength - 3) + '...' : text;
  }
}

// Export generator function
export async function generateBuildingHealthCheck(data: BuildingData, outputPath: string): Promise<void> {
  const generator = new BuildingHealthCheckV2(data, outputPath);
  await generator.generate();
}
