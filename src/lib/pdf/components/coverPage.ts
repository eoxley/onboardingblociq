/**
 * Cover Page Component
 * BlocIQ Building Health Check Report Cover
 */

import PDFDocument from 'pdfkit';
import { BlocIQBrand } from '../brand';
import * as dayjs from 'dayjs';

export function renderCoverPage(doc: PDFDocument, data: any): void {
  const { building } = data;
  const pageWidth = doc.page.width;
  const pageHeight = doc.page.height;
  const centerX = pageWidth / 2;

  // Background color
  doc.rect(0, 0, pageWidth, pageHeight)
     .fill(BlocIQBrand.colours.background);

  // Logo (if exists)
  // Placeholder for logo - add actual logo rendering here
  doc.fontSize(BlocIQBrand.fontSize.title)
     .fillColor(BlocIQBrand.colours.primary)
     .font('Helvetica-Bold')
     .text('BlocIQ', centerX - 50, 150, { align: 'center', width: 100 });

  // Building Name
  doc.fontSize(BlocIQBrand.fontSize.title + 4)
     .fillColor(BlocIQBrand.colours.text)
     .font('Helvetica-Bold')
     .text(building.name || 'Building Name', 50, 250, {
       align: 'center',
       width: pageWidth - 100
     });

  // Building Address
  doc.fontSize(BlocIQBrand.fontSize.heading2)
     .fillColor(BlocIQBrand.colours.text)
     .font('Helvetica')
     .text(building.address || '', 50, 290, {
       align: 'center',
       width: pageWidth - 100
     });

  // Report Title
  doc.fontSize(BlocIQBrand.fontSize.heading1)
     .fillColor(BlocIQBrand.colours.secondary)
     .font('Helvetica-Bold')
     .text('Building Health Check Report', 50, 360, {
       align: 'center',
       width: pageWidth - 100
     });

  // Date Generated
  const dateGenerated = dayjs().format('DD MMMM YYYY');
  doc.fontSize(BlocIQBrand.fontSize.body)
     .fillColor(BlocIQBrand.colours.text)
     .font('Helvetica')
     .text(`Generated: ${dateGenerated}`, 50, 400, {
       align: 'center',
       width: pageWidth - 100
     });

  // Summary Box
  const healthScore = calculateHealthScore(data);
  const boxY = 460;
  const boxHeight = 80;

  doc.roundedRect(100, boxY, pageWidth - 200, boxHeight, 10)
     .fillAndStroke(BlocIQBrand.colours.white, BlocIQBrand.colours.secondary);

  doc.fontSize(BlocIQBrand.fontSize.heading3)
     .fillColor(BlocIQBrand.colours.text)
     .font('Helvetica-Bold')
     .text(`Building Health Score: ${healthScore}%`, 120, boxY + 20, {
       width: pageWidth - 240
     });

  const status = healthScore >= 80 ? 'Excellent' : healthScore >= 60 ? 'Satisfactory' : 'Requires Attention';
  const statusColor = healthScore >= 80 ? BlocIQBrand.colours.success :
                     healthScore >= 60 ? BlocIQBrand.colours.warning :
                     BlocIQBrand.colours.danger;

  doc.fontSize(BlocIQBrand.fontSize.body)
     .fillColor(statusColor)
     .font('Helvetica')
     .text(`Status: ${status}`, 120, boxY + 45, {
       width: pageWidth - 240
     });

  // Footer Disclaimer
  const disclaimerY = pageHeight - 150;
  doc.fontSize(BlocIQBrand.fontSize.small)
     .fillColor(BlocIQBrand.colours.text)
     .font('Helvetica')
     .text(
       'This Building Health Check has been prepared by BlocIQ Property Intelligence.\n' +
       'It is automatically generated from data, documents, and certificates uploaded to the BlocIQ platform.\n' +
       'While every effort is made to ensure accuracy, the report is provided for information only and should not be relied upon as legal, financial, or technical advice.\n' +
       'The content reflects information available as of the generation date.',
       50,
       disclaimerY,
       {
         align: 'center',
         width: pageWidth - 100,
         lineGap: 3
       }
     );

  doc.addPage();
}

function calculateHealthScore(data: any): number {
  const compliance = data.compliance || [];
  const insurance = data.insurance || [];
  const budgets = data.budgets || [];
  const leases = data.leases || [];

  const complianceScore = compliance.length > 0 ?
    (compliance.filter((c: any) => c.status === 'compliant').length / compliance.length) * 100 : 0;

  const insuranceScore = insurance.length > 0 ? 100 : 0;
  const budgetScore = budgets.length > 0 ? 100 : 0;
  const leaseScore = leases.length > 0 ? 100 : 0;

  const score = (complianceScore * 0.4) +
                (insuranceScore * 0.2) +
                (budgetScore * 0.2) +
                (leaseScore * 0.2);

  return Math.round(score);
}
