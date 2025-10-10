# BlocIQ Onboarding Report Generator

Professional branded reports for BlocIQ onboarding with HTML and PDF export.

## 🎯 Overview

Generate beautiful, client-ready onboarding reports with:
- ✨ **Branded Design** - BlocIQ gradient header with logo
- 📊 **Data Summary** - Units, leaseholders, documents, compliance assets
- 🤖 **AI Confidence Metrics** (optional) - OCR quality and data coverage
- 📄 **Multiple Formats** - JSON (internal), HTML, PDF (client-ready)

## 📦 Features

### Standard Report (`generateReports.ts`)
- Clean professional layout
- Building overview and statistics
- Document count summary
- Status badges for data quality
- Next steps guidance

### AI Confidence Report (`generateReportsWithConfidence.ts`)
- All standard features
- **OCR confidence scoring**
- **Data quality metrics**
- **AI tagging insights**
- **Compliance coverage analysis**

## 🚀 Quick Start

### Installation

```bash
# Install dependencies
npm install

# Install TypeScript dev dependencies
npm install --save-dev @types/node ts-node typescript

# Install PDF converter (choose one)
# macOS:
brew install wkhtmltopdf

# Ubuntu/Debian:
sudo apt-get install wkhtmltopdf

# Or use pypandoc:
pip install pypandoc

# Or use weasyprint:
pip install weasyprint
```

### Setup Environment

Create `.env` file:
```bash
SUPABASE_URL=https://your-project.supabase.co
SUPABASE_SERVICE_ROLE_KEY=your-service-role-key
NODE_ENV=production
```

### Generate Reports

```bash
# Standard report
ts-node generateReports.ts <building_id>

# AI confidence report
ts-node generateReportsWithConfidence.ts <building_id>

# Using npm scripts
npm run report <building_id>
npm run report:confidence <building_id>
```

## 📁 Output Structure

```
diagnostics/reports/<building_name>/
├── user_summary.json       # Internal use (metrics, counts)
├── agency_summary.html     # Client-ready branded report
└── agency_summary.pdf      # Print-ready PDF (if converter installed)
```

## 📊 Report Contents

### 1. **Building Overview**
- Building name and address
- Report generation timestamp
- Data quality score

### 2. **Onboarding Summary Table**
- Units: Count + Status
- Leaseholders: Count + Status
- Compliance Assets: Count + Coverage %
- Major Works Projects: Count + Status
- Budgets: Count + Status
- Documents: Count + Status

### 3. **AI Confidence Metrics** (Confidence version only)
- OCR Confidence: Average recognition quality
- Compliance Coverage: % of assets with dates
- Data Quality Score: Overall grade (A+, B, C)
- Linked Units: Cross-referenced documents

### 4. **Next Steps**
- Automated dashboard updates
- Finance data availability
- Document search capabilities
- Compliance reminders

## 🎨 Branding

### Logo
```html
<div class="logo">Bloc<span class="logo-iq">IQ</span></div>
```

### Color Scheme
- Primary Gradient: `#667eea → #5e48e8`
- Background: `#f8f9fa`
- Text: `#1a1a1a`
- Borders: `#e9ecef`

### Typography
- Font: Inter, -apple-system, BlinkMacSystemFont, Segoe UI
- Headings: 700 weight, -0.02em letter spacing
- Body: 400 weight, 1.6 line height

## 📄 PDF Generation

The script tries multiple PDF converters in order:

1. **wkhtmltopdf** (recommended - best quality)
   ```bash
   brew install wkhtmltopdf  # macOS
   apt-get install wkhtmltopdf  # Ubuntu
   ```

2. **pypandoc** (good quality)
   ```bash
   pip install pypandoc
   ```

3. **weasyprint** (good quality)
   ```bash
   pip install weasyprint
   ```

If no converter is installed, HTML report is still generated.

## 🔍 Example Output

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

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

## 🔧 Customization

### Modify Header
Edit the `<header>` section in the HTML template:
```typescript
const html = `
  <header>
    <div class="logo">Bloc<span class="logo-iq">IQ</span></div>
    <p>Your Custom Tagline</p>
  </header>
`;
```

### Add Custom Metrics
Add to metrics calculation:
```typescript
const { data: customData } = await supabase
  .from("your_table")
  .select("field")
  .eq("building_id", buildingId);

const customMetric = customData?.length || 0;
```

### Change Color Scheme
Update CSS variables:
```css
header {
  background: linear-gradient(135deg, #YOUR_COLOR_1, #YOUR_COLOR_2);
}

h2 {
  color: #YOUR_PRIMARY_COLOR;
}
```

## 🐛 Troubleshooting

### Issue: "No PDF converter installed"
**Solution:** Install wkhtmltopdf:
```bash
# macOS
brew install wkhtmltopdf

# Ubuntu
sudo apt-get install wkhtmltopdf

# Or use alternative
pip install weasyprint
```

### Issue: "Supabase credentials not found"
**Solution:** Create `.env` file with:
```
SUPABASE_URL=https://your-project.supabase.co
SUPABASE_SERVICE_ROLE_KEY=your-key
```

### Issue: "Building not found"
**Solution:** Verify building ID:
```sql
SELECT id, name FROM buildings;
```

### Issue: "TypeScript errors"
**Solution:** Install dev dependencies:
```bash
npm install --save-dev @types/node ts-node typescript
```

## 📚 API Reference

### generateReports(buildingId: string)

Generates standard onboarding report.

**Parameters:**
- `buildingId` (string): UUID of the building

**Returns:**
- Creates report files in `diagnostics/reports/<building_name>/`

**Throws:**
- Error if building not found
- Error if Supabase credentials missing

### generateReportsWithConfidence(buildingId: string)

Generates report with AI confidence metrics.

**Additional Features:**
- OCR confidence scoring (from `building_documents.ai_confidence`)
- Data quality grading
- Enhanced metrics table

## 🚢 Deployment

### 1. Production Environment

```bash
# Set production credentials
export SUPABASE_URL="https://your-project.supabase.co"
export SUPABASE_SERVICE_ROLE_KEY="your-key"
export NODE_ENV="production"

# Generate report
ts-node generateReports.ts <building_id>
```

### 2. Automated Reports

Create cron job:
```bash
# Run daily at 2 AM
0 2 * * * cd /path/to/project && ts-node generateReports.ts <building_id>
```

### 3. Integration with Onboarding Pipeline

```python
# In Python onboarding script
import subprocess

building_id = "..."
subprocess.run([
    "ts-node",
    "generateReports.ts",
    building_id
])
```

## 📖 Examples

### Basic Usage
```bash
ts-node generateReports.ts a1b2c3d4-e5f6-7890-abcd-ef1234567890
```

### With AI Confidence
```bash
ts-node generateReportsWithConfidence.ts a1b2c3d4-e5f6-7890-abcd-ef1234567890
```

### Batch Generation
```bash
#!/bin/bash
BUILDINGS=(
  "a1b2c3d4-e5f6-7890-abcd-ef1234567890"
  "b2c3d4e5-f6a7-8901-bcde-f12345678901"
  "c3d4e5f6-a7b8-9012-cdef-123456789012"
)

for id in "${BUILDINGS[@]}"; do
  ts-node generateReports.ts "$id"
done
```

## 🎯 Best Practices

1. **Always verify building ID before generation**
   ```sql
   SELECT id, name FROM buildings WHERE id = 'your-id';
   ```

2. **Use environment variables for credentials**
   - Never hardcode Supabase keys
   - Use `.env` file locally
   - Use environment variables in production

3. **Check PDF generation**
   - Verify wkhtmltopdf is installed
   - Test PDF output before sending to clients

4. **Review reports before sharing**
   - Check data accuracy
   - Verify all counts are correct
   - Review status badges

## 📝 License

MIT License - BlocIQ Ltd © 2025

## 🆘 Support

For issues or questions:
- Check troubleshooting section above
- Review example output
- Verify Supabase connection
- Test with sample building ID
