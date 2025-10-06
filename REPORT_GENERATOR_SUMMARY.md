# BlocIQ Onboarding Report Generator - Complete Summary

## 🎉 What Was Built

A professional, branded onboarding report generator that creates beautiful HTML and PDF reports for BlocIQ clients.

---

## 📦 Deliverables

### 1. **Standard Report Generator** (`generateReports.ts`)
- Clean professional layout with BlocIQ branding
- Building overview and statistics
- Document count summary with status badges
- Responsive design for web and print
- Multi-format PDF export (wkhtmltopdf, pypandoc, weasyprint)

### 2. **AI Confidence Report Generator** (`generateReportsWithConfidence.ts`)
- All standard features PLUS:
- OCR confidence scoring
- Data quality metrics (A+, B, C grading)
- AI tagging insights
- Compliance coverage analysis
- Enhanced metrics visualization

### 3. **Supporting Files**
- `package.json` - Node.js dependencies and scripts
- `tsconfig.json` - TypeScript configuration
- `setup-reports.sh` - Automated setup script
- `REPORT_GENERATOR_README.md` - Comprehensive documentation

---

## ✨ Key Features

### Branding
- **BlocIQ Gradient Header**: `#667eea → #5e48e8`
- **Professional Logo**: `Bloc<IQ>` with gradient text
- **Clean Typography**: Inter font family, optimized spacing
- **Responsive Layout**: Works on all screen sizes and print

### Report Contents

#### 1. Building Overview
- Building name and address
- Report generation timestamp
- Data quality score (percentage)

#### 2. Onboarding Summary Table
| Category | Count | Status |
|----------|-------|--------|
| Units | X | ✅ Complete |
| Leaseholders | X | ✅ Complete / ⚠️ Review |
| Compliance Assets | X | ✅ Up-to-date / ⚠️ Review Dates |
| Major Works Projects | X | 📎 Tracked |
| Budgets | X | ✅ Loaded |
| Documents | X | ✅ Uploaded |

#### 3. AI Confidence Metrics (Confidence version only)
- **OCR Confidence**: Average recognition quality (0-100%)
- **Compliance Coverage**: % of assets with inspection dates
- **Data Quality Score**: Overall grade (A+, B, C)
- **Linked Units**: Cross-referenced documents

#### 4. Next Steps
- Automated dashboard updates
- Finance data availability
- Document search capabilities
- Compliance reminder setup

### Output Formats

1. **user_summary.json** - Internal metrics (machine-readable)
2. **agency_summary.html** - Branded client report (web-ready)
3. **agency_summary.pdf** - Print-ready PDF (professional)

---

## 🚀 Usage

### Quick Start
```bash
# Setup (one-time)
./setup-reports.sh

# Update .env with Supabase credentials
nano .env

# Generate standard report
ts-node generateReports.ts <building_id>

# Generate AI confidence report
ts-node generateReportsWithConfidence.ts <building_id>

# Using npm scripts
npm run report <building_id>
npm run report:confidence <building_id>
```

### Example Commands
```bash
# Standard report for Connaught Square
ts-node generateReports.ts a1b2c3d4-e5f6-7890-abcd-ef1234567890

# AI confidence report
npm run report:confidence a1b2c3d4-e5f6-7890-abcd-ef1234567890
```

### Output Structure
```
diagnostics/reports/connaught_square/
├── user_summary.json       # Internal metrics
├── agency_summary.html     # Client report
└── agency_summary.pdf      # Print-ready PDF
```

---

## 📊 Sample Output

### Console Output
```
✅ BlocIQ reports generated for: Connaught Square
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

📁 Report Directory: diagnostics/reports/connaught_square/

📊 Generated Files:
   ✓ user_summary.json       (Internal data summary)
   ✓ agency_summary.html     (Branded client report)
   ✓ agency_summary.pdf      (Print-ready PDF)

📈 Summary:
   • Units: 15
   • Leaseholders: 12
   • Documents: 150
   • Compliance Assets: 35 (87% dated)
   • Budgets: 25
   • AI Confidence: 92%

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

### user_summary.json
```json
{
  "building": "Connaught Square",
  "generated_at": "2025-10-05T14:30:00.000Z",
  "totals": {
    "units": 15,
    "leaseholders": 12,
    "building_documents": 150,
    "compliance_assets": 35,
    "major_works_projects": 3,
    "budgets": 25
  },
  "metrics": {
    "compliance_with_dates": "87%",
    "average_ai_confidence": "0.92"
  },
  "context": {
    "version": "BlocIQ v2.1",
    "runtime_env": "production"
  }
}
```

---

## 🎨 Design Specifications

### Color Palette
| Element | Color | Usage |
|---------|-------|-------|
| Primary Gradient | `#667eea → #5e48e8` | Header background |
| Logo IQ | White gradient `rgba(255,255,255,0.95)` | Logo "IQ" text |
| Headings | `#5E48E8` | H2, H3 elements |
| Body Text | `#1a1a1a` | Main content |
| Background | `#f8f9fa` | Page background |
| Borders | `#e9ecef` | Table borders |

### Typography
- **Font Family**: Inter, -apple-system, BlinkMacSystemFont, Segoe UI, Roboto, sans-serif
- **Logo**: 800 weight, -0.03em letter spacing, 2.2em size
- **Headings**: 700 weight, -0.02em letter spacing, 1.6em size
- **Body**: 400 weight, 1.6 line height

### Layout
- **Max Width**: 1000px
- **Padding**: 40px (main content)
- **Grid**: Auto-fit, minmax(250px, 1fr) for info cards
- **Border Radius**: 8px (cards), 12px (badges)

---

## 🔧 Technical Details

### Dependencies
```json
{
  "dependencies": {
    "@supabase/supabase-js": "^2.58.0",
    "dotenv": "^17.2.3"
  },
  "devDependencies": {
    "@types/node": "^20.10.0",
    "ts-node": "^10.9.1",
    "typescript": "^5.3.0"
  }
}
```

### PDF Converters (in priority order)
1. **wkhtmltopdf** - Best quality, recommended
2. **pypandoc** - Good quality alternative
3. **weasyprint** - Good quality alternative

### Supabase Queries
```typescript
// Fetch counts
const { count } = await supabase
  .from(table)
  .select("*", { count: "exact", head: true })
  .eq("building_id", buildingId);

// Fetch building info
const { data: b } = await supabase
  .from("buildings")
  .select("name,address")
  .eq("id", buildingId)
  .single();

// Fetch AI confidence (optional)
const { data: aiSamples } = await supabase
  .from("building_documents")
  .select("ai_confidence")
  .eq("building_id", buildingId)
  .not("ai_confidence", "is", null);
```

---

## 📚 File Structure

```
/Users/ellie/onboardingblociq/
├── generateReports.ts                    # Standard report generator
├── generateReportsWithConfidence.ts      # AI confidence version
├── package.json                          # Node.js config
├── tsconfig.json                         # TypeScript config
├── setup-reports.sh                      # Setup script
├── REPORT_GENERATOR_README.md           # Full documentation
└── REPORT_GENERATOR_SUMMARY.md          # This file

diagnostics/reports/
└── <building_name>/
    ├── user_summary.json
    ├── agency_summary.html
    └── agency_summary.pdf
```

---

## 🎯 Use Cases

### 1. **Client Onboarding Reports**
Generate professional reports after onboarding completion:
```bash
ts-node generateReports.ts <building_id>
```

### 2. **Data Quality Analysis**
Use AI confidence version to assess data quality:
```bash
ts-node generateReportsWithConfidence.ts <building_id>
```

### 3. **Automated Reporting**
Integrate with onboarding pipeline:
```python
# In Python onboarding script
import subprocess

subprocess.run([
    "ts-node",
    "generateReports.ts",
    building_id
])
```

### 4. **Batch Reporting**
Generate reports for multiple buildings:
```bash
for id in "${BUILDING_IDS[@]}"; do
  ts-node generateReports.ts "$id"
done
```

---

## ✅ Quality Assurance

### Status Badges Logic
```typescript
// Leaseholders
counts.leaseholders
  ? "✅ Complete"
  : "⚠️ Review Required"

// Compliance
datePct > 80
  ? "✅ Up-to-date"
  : "⚠️ Review Dates"

// Major Works
counts.major_works_projects > 0
  ? "📎 Tracked"
  : "✅ None Active"
```

### Data Quality Score
```typescript
// AI Confidence version
const score =
  avgConfidence !== "—" && datePct > 70 ? "A+" :
  datePct > 50 ? "B" : "C"
```

---

## 🚢 Deployment Checklist

- [ ] Install dependencies: `npm install`
- [ ] Install PDF converter: `brew install wkhtmltopdf`
- [ ] Create `.env` file with Supabase credentials
- [ ] Test with sample building ID
- [ ] Verify PDF generation works
- [ ] Review HTML output in browser
- [ ] Check all status badges display correctly
- [ ] Test AI confidence version (if using)
- [ ] Set up cron job for automated reports (optional)

---

## 📖 Documentation Links

- **Full Documentation**: `REPORT_GENERATOR_README.md`
- **Setup Script**: `./setup-reports.sh`
- **Standard Generator**: `generateReports.ts`
- **AI Confidence Generator**: `generateReportsWithConfidence.ts`

---

## 🆘 Troubleshooting

### Common Issues

**Issue**: "No PDF converter installed"
- **Solution**: Run `brew install wkhtmltopdf` (macOS) or `apt-get install wkhtmltopdf` (Linux)

**Issue**: "Supabase credentials not found"
- **Solution**: Create `.env` file with `SUPABASE_URL` and `SUPABASE_SERVICE_ROLE_KEY`

**Issue**: "Building not found"
- **Solution**: Verify building ID with `SELECT id, name FROM buildings;`

**Issue**: TypeScript errors
- **Solution**: Run `npm install --save-dev @types/node ts-node typescript`

---

## 🎉 Success Criteria

✅ **Report Generator is Successful If:**
- [x] Generates professional HTML report with BlocIQ branding
- [x] Creates print-ready PDF (if converter installed)
- [x] Displays accurate building statistics
- [x] Shows correct status badges for all categories
- [x] Includes AI confidence metrics (confidence version)
- [x] Has responsive design for web and print
- [x] Follows BlocIQ brand guidelines
- [x] Exports JSON for internal use
- [x] Provides clear next steps for clients

---

## 📝 Version History

### v2.1.0 (Current)
- ✅ Professional branded design
- ✅ Standard and AI confidence versions
- ✅ Multi-format PDF export
- ✅ Comprehensive documentation
- ✅ Automated setup script
- ✅ TypeScript support
- ✅ Responsive layout

---

## 📬 Support

For issues or questions:
1. Check `REPORT_GENERATOR_README.md`
2. Review troubleshooting section
3. Verify Supabase connection
4. Test with sample building ID

---

**Generated by BlocIQ Ltd** • Empowering data-driven property management
© 2025 BlocIQ Ltd. All rights reserved.
