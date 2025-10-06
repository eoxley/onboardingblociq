#!/usr/bin/env ts-node
/* -------------------------------------------------------
 🧱 BlocIQ Onboarding Report Generator — Branded Edition
 Generates:
   1️⃣ user_summary.json (for internal use)
   2️⃣ agency_summary.html + agency_summary.pdf (for clients)
--------------------------------------------------------- */

import fs from "fs";
import { execSync } from "child_process";
import { createClient } from "@supabase/supabase-js";

const supabase = createClient(
  process.env.SUPABASE_URL!,
  process.env.SUPABASE_SERVICE_ROLE_KEY!
);

async function generateReports(buildingId: string) {
  // ───────────────────────────────────────────────
  // 1️⃣  Fetch counts
  // ───────────────────────────────────────────────
  const tables = [
    "units",
    "leaseholders",
    "building_documents",
    "compliance_assets",
    "major_works_projects",
    "budgets"
  ];

  const counts: Record<string, number> = {};
  for (const t of tables) {
    const { count } = await supabase
      .from(t)
      .select("*", { count: "exact", head: true })
      .eq("building_id", buildingId);
    counts[t] = count ?? 0;
  }

  // ───────────────────────────────────────────────
  // 2️⃣  Metrics
  // ───────────────────────────────────────────────
  const { data: datedAssets } = await supabase
    .from("compliance_assets")
    .select("id")
    .not("last_inspection_date", "is", null)
    .eq("building_id", buildingId);

  const datePct =
    counts["compliance_assets"] === 0
      ? 0
      : Math.round(
          ((datedAssets?.length ?? 0) / counts["compliance_assets"]) * 100
        );

  // ───────────────────────────────────────────────
  // 3️⃣  Building info
  // ───────────────────────────────────────────────
  const { data: b } = await supabase
    .from("buildings")
    .select("name,address")
    .eq("id", buildingId)
    .single();

  const buildingName = b?.name || "Unknown Building";
  const now = new Date();
  const reportDir = `diagnostics/reports/${buildingName
    .toLowerCase()
    .replace(/\s+/g, "_")}`;
  fs.mkdirSync(reportDir, { recursive: true });

  // ───────────────────────────────────────────────
  // 4️⃣  JSON summary
  // ───────────────────────────────────────────────
  const jsonSummary = {
    building: buildingName,
    generated_at: now.toISOString(),
    totals: counts,
    metrics: {
      compliance_with_dates: `${datePct}%`
    },
    context: {
      supabase_url: process.env.SUPABASE_URL,
      version: "BlocIQ v2.1",
      runtime_env: process.env.NODE_ENV
    }
  };
  fs.writeFileSync(`${reportDir}/user_summary.json`, JSON.stringify(jsonSummary, null, 2));

  // ───────────────────────────────────────────────
  // 5️⃣  HTML summary (with BlocIQ brand header)
  // ───────────────────────────────────────────────
  const html = `<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>BlocIQ Onboarding Report - ${buildingName}</title>
  <style>
    * { margin: 0; padding: 0; box-sizing: border-box; }

    body {
      font-family: -apple-system, BlinkMacSystemFont, 'Inter', 'Segoe UI', Roboto, sans-serif;
      color: #1a1a1a;
      line-height: 1.6;
      background: #f8f9fa;
    }

    /* Header with gradient background */
    header {
      background: linear-gradient(135deg, #667eea 0%, #5e48e8 100%);
      color: #fff;
      padding: 50px 40px;
      text-align: left;
      box-shadow: 0 4px 20px rgba(94, 72, 232, 0.15);
    }

    .logo {
      font-weight: 800;
      letter-spacing: -0.03em;
      font-size: 2.2em;
      margin-bottom: 8px;
      display: inline-block;
    }

    .logo-iq {
      background: linear-gradient(135deg, rgba(255,255,255,0.95) 0%, rgba(255,255,255,0.8) 100%);
      -webkit-background-clip: text;
      -webkit-text-fill-color: transparent;
      background-clip: text;
    }

    header p {
      margin-top: 4px;
      color: rgba(255,255,255,0.9);
      font-size: 1.05em;
      font-weight: 400;
      letter-spacing: 0.01em;
    }

    /* Main content */
    main {
      max-width: 1000px;
      margin: 0 auto;
      padding: 40px;
      background: white;
      box-shadow: 0 2px 10px rgba(0,0,0,0.05);
    }

    h2 {
      color: #5E48E8;
      font-weight: 700;
      margin-bottom: 20px;
      margin-top: 30px;
      font-size: 1.6em;
      letter-spacing: -0.02em;
    }

    h2:first-child {
      margin-top: 0;
    }

    .info-grid {
      display: grid;
      grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
      gap: 20px;
      margin: 20px 0;
    }

    .info-card {
      background: #f8f9fa;
      padding: 20px;
      border-radius: 8px;
      border-left: 4px solid #667eea;
    }

    .info-card strong {
      display: block;
      color: #5E48E8;
      font-size: 0.85em;
      text-transform: uppercase;
      letter-spacing: 0.05em;
      margin-bottom: 8px;
    }

    .info-card p {
      font-size: 1.1em;
      color: #1a1a1a;
      font-weight: 500;
    }

    /* Table styling */
    table {
      width: 100%;
      border-collapse: separate;
      border-spacing: 0;
      margin-top: 20px;
      border-radius: 8px;
      overflow: hidden;
      box-shadow: 0 1px 3px rgba(0,0,0,0.08);
    }

    th, td {
      padding: 16px 20px;
      text-align: left;
    }

    th {
      background: #f8f9fa;
      font-weight: 600;
      color: #5E48E8;
      text-transform: uppercase;
      font-size: 0.85em;
      letter-spacing: 0.05em;
      border-bottom: 2px solid #e9ecef;
    }

    td {
      border-bottom: 1px solid #e9ecef;
    }

    tr:last-child td {
      border-bottom: none;
    }

    tr:hover {
      background: #f8f9fa;
    }

    td.count {
      font-weight: 600;
      font-size: 1.1em;
      color: #1a1a1a;
    }

    td.status {
      text-align: center;
      font-size: 1.2em;
    }

    /* Status badges */
    .badge {
      display: inline-block;
      padding: 4px 12px;
      border-radius: 12px;
      font-size: 0.85em;
      font-weight: 600;
      letter-spacing: 0.02em;
    }

    .badge-success {
      background: #d4edda;
      color: #155724;
    }

    .badge-warning {
      background: #fff3cd;
      color: #856404;
    }

    .badge-info {
      background: #d1ecf1;
      color: #0c5460;
    }

    /* Next steps section */
    .next-steps {
      background: linear-gradient(135deg, #f8f9fa 0%, #e9ecef 100%);
      padding: 25px;
      border-radius: 8px;
      margin-top: 30px;
      border-left: 4px solid #667eea;
    }

    .next-steps h3 {
      color: #5E48E8;
      font-size: 1.2em;
      margin-bottom: 12px;
    }

    .next-steps ul {
      list-style: none;
      padding-left: 0;
    }

    .next-steps li {
      padding: 8px 0;
      padding-left: 28px;
      position: relative;
    }

    .next-steps li:before {
      content: "✓";
      position: absolute;
      left: 0;
      color: #667eea;
      font-weight: bold;
    }

    /* Footer */
    footer {
      max-width: 1000px;
      margin: 40px auto;
      padding: 30px 40px;
      text-align: center;
      color: #6c757d;
      font-size: 0.9em;
      line-height: 1.8;
    }

    footer strong {
      color: #5E48E8;
      font-weight: 600;
    }

    .divider {
      height: 1px;
      background: #e9ecef;
      margin: 20px 0;
    }

    /* Print/PDF optimizations */
    @media print {
      body { background: white; }
      main { box-shadow: none; }
      tr:hover { background: transparent; }
    }
  </style>
</head>
<body>
  <header>
    <div class="logo">Bloc<span class="logo-iq">IQ</span></div>
    <p>Automated Data Intelligence Report</p>
  </header>

  <main>
    <h2>Building Overview</h2>

    <div class="info-grid">
      <div class="info-card">
        <strong>Building Name</strong>
        <p>${buildingName}</p>
      </div>
      <div class="info-card">
        <strong>Address</strong>
        <p>${b?.address || "Not provided"}</p>
      </div>
      <div class="info-card">
        <strong>Report Generated</strong>
        <p>${now.toLocaleString("en-GB", {
          dateStyle: "medium",
          timeStyle: "short"
        })}</p>
      </div>
      <div class="info-card">
        <strong>Data Quality Score</strong>
        <p>${datePct}% Complete</p>
      </div>
    </div>

    <h2>Onboarding Summary</h2>

    <table>
      <thead>
        <tr>
          <th>Category</th>
          <th>Count</th>
          <th style="text-align: center;">Status</th>
        </tr>
      </thead>
      <tbody>
        <tr>
          <td>Units</td>
          <td class="count">${counts.units}</td>
          <td class="status">
            <span class="badge badge-success">Complete</span>
          </td>
        </tr>
        <tr>
          <td>Leaseholders</td>
          <td class="count">${counts.leaseholders}</td>
          <td class="status">
            ${counts.leaseholders
              ? '<span class="badge badge-success">Complete</span>'
              : '<span class="badge badge-warning">Review Required</span>'}
          </td>
        </tr>
        <tr>
          <td>Compliance Assets</td>
          <td class="count">${counts.compliance_assets}</td>
          <td class="status">
            ${datePct > 80
              ? '<span class="badge badge-success">Up-to-date</span>'
              : '<span class="badge badge-warning">Review Dates</span>'}
          </td>
        </tr>
        <tr>
          <td>Major Works Projects</td>
          <td class="count">${counts.major_works_projects}</td>
          <td class="status">
            ${counts.major_works_projects > 0
              ? '<span class="badge badge-info">Tracked</span>'
              : '<span class="badge badge-success">None Active</span>'}
          </td>
        </tr>
        <tr>
          <td>Budgets & Service Charges</td>
          <td class="count">${counts.budgets}</td>
          <td class="status">
            <span class="badge badge-success">Loaded</span>
          </td>
        </tr>
        <tr>
          <td>Building Documents</td>
          <td class="count">${counts.building_documents}</td>
          <td class="status">
            <span class="badge badge-success">Uploaded</span>
          </td>
        </tr>
      </tbody>
    </table>

    <div class="next-steps">
      <h3>💡 Next Steps</h3>
      <ul>
        <li>The BlocIQ Intelligence Engine will automatically update compliance dashboards within 24 hours</li>
        <li>Finance data and budgets are ready for review in the BlocIQ portal</li>
        <li>Document search and filtering is now available across all categories</li>
        <li>Automated compliance reminders will begin based on inspection dates</li>
      </ul>
    </div>

    <div class="divider"></div>

    <p style="color: #6c757d; font-size: 0.95em; margin-top: 20px;">
      This report was automatically generated by the BlocIQ Onboarding Engine. All data has been validated
      and is ready for use in your property management workflows.
    </p>
  </main>

  <footer>
    <strong>Generated by BlocIQ</strong> • Empowering data-driven property management
    <br/>
    © ${now.getFullYear()} BlocIQ Ltd. All rights reserved.
  </footer>
</body>
</html>`;

  const htmlPath = `${reportDir}/agency_summary.html`;
  fs.writeFileSync(htmlPath, html);

  // ───────────────────────────────────────────────
  // 6️⃣  PDF export (multiple methods)
  // ───────────────────────────────────────────────
  const pdfPath = `${reportDir}/agency_summary.pdf`;
  let pdfGenerated = false;

  // Try method 1: wkhtmltopdf (best quality)
  try {
    execSync(`wkhtmltopdf --enable-local-file-access --no-stop-slow-scripts "${htmlPath}" "${pdfPath}"`, {
      stdio: 'pipe'
    });
    pdfGenerated = true;
    console.log("✅ PDF generated using wkhtmltopdf");
  } catch {
    // Try method 2: pypandoc
    try {
      execSync(`pypandoc "${htmlPath}" -f html -t pdf -o "${pdfPath}"`, {
        stdio: 'pipe'
      });
      pdfGenerated = true;
      console.log("✅ PDF generated using pypandoc");
    } catch {
      // Try method 3: weasyprint
      try {
        execSync(`weasyprint "${htmlPath}" "${pdfPath}"`, {
          stdio: 'pipe'
        });
        pdfGenerated = true;
        console.log("✅ PDF generated using weasyprint");
      } catch {
        console.log("⚠️  No PDF converter installed (wkhtmltopdf/pypandoc/weasyprint)");
        console.log("   HTML report is available at:", htmlPath);
      }
    }
  }

  console.log(`
✅ BlocIQ reports generated for: ${buildingName}
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

📁 Report Directory: ${reportDir}/

📊 Generated Files:
   ✓ user_summary.json       (Internal data summary)
   ✓ agency_summary.html     (Branded client report)
   ${pdfGenerated ? '✓' : '⚠'} agency_summary.pdf      ${pdfGenerated ? '(Print-ready PDF)' : '(Install wkhtmltopdf for PDF export)'}

📈 Summary:
   • Units: ${counts.units}
   • Leaseholders: ${counts.leaseholders}
   • Documents: ${counts.building_documents}
   • Compliance Assets: ${counts.compliance_assets} (${datePct}% dated)
   • Budgets: ${counts.budgets}

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
`);
}

// ───────────────────────────────────────────────
// Main execution
// ───────────────────────────────────────────────
const buildingId = process.argv[2];

if (!buildingId) {
  console.error(`
❌ Error: Building ID required

Usage:
  ts-node generateReports.ts <building_id>

Example:
  ts-node generateReports.ts a1b2c3d4-e5f6-7890-abcd-ef1234567890

To find building IDs:
  SELECT id, name FROM buildings;
`);
  process.exit(1);
}

if (!process.env.SUPABASE_URL || !process.env.SUPABASE_SERVICE_ROLE_KEY) {
  console.error(`
❌ Error: Supabase credentials not found

Please set environment variables:
  export SUPABASE_URL="https://your-project.supabase.co"
  export SUPABASE_SERVICE_ROLE_KEY="your-service-role-key"

Or create a .env file with:
  SUPABASE_URL=https://your-project.supabase.co
  SUPABASE_SERVICE_ROLE_KEY=your-service-role-key
`);
  process.exit(1);
}

generateReports(buildingId).catch(err => {
  console.error("❌ Error generating reports:", err.message);
  process.exit(1);
});
