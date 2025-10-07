# Enhanced Building Health Check Report - Documentation

## Overview

The **Building Health Check Report** is a comprehensive, branded PDF report that provides complete intelligence on building management, contractor relationships, asset inventory, compliance status, and actionable recommendations.

---

## New Features (Version 3.0)

### 🎨 Company Branding

- **Logo Integration**: Company logo displayed in header
- **Customizable Colors**: Brand colors configurable via JSON
- **Custom Fonts**: Typography settings per brand guidelines
- **Status Icons**: Consistent visual indicators (✅ ⚠️ ❌ ❓)

### 📊 Enhanced Report Structure

**6 Core Sections:**

1. **Building Summary** - Overview with key metrics
2. **Contractor Overview** - All contractors and active contracts
3. **Asset Register** - Complete asset inventory with status
4. **Compliance Matrix** - Compliance by category
5. **Recommendations** - Auto-generated action items
6. **Health Score** - Overall building health rating

---

## Configuration

### Branding Setup

**File:** `BlocIQ_Onboarder/config/branding.json`

```json
{
  "company_name": "BlocIQ",
  "report_title": "BlocIQ Building Health Check",
  "logo_path": "assets/logo-header.png",
  "brand_colors": {
    "primary": "#1e40af",
    "secondary": "#3b82f6",
    "success": "#10b981",
    "warning": "#f59e0b",
    "danger": "#ef4444"
  },
  "fonts": {
    "title": "Helvetica-Bold",
    "heading": "Helvetica-Bold",
    "body": "Helvetica",
    "size_title": 24,
    "size_heading": 16,
    "size_body": 10
  },
  "status_icons": {
    "compliant": "✅",
    "due_soon": "⚠️",
    "overdue": "❌",
    "missing": "❓",
    "unknown": "❔"
  }
}
```

### Logo Setup

1. Place logo file at: `BlocIQ_Onboarder/assets/logo-header.png`
2. Recommended size: 400x160px (2:1 ratio)
3. Format: PNG with transparency

---

## Report Sections

### Section 1: Building Summary

**Displays:**
- Building Name
- Total Units
- Total Leaseholders
- Active Contracts
- Known Assets
- Compliance Assets

**Example:**
```
Building Name: Connaught Square
Total Units: 8
Total Leaseholders: 8
Active Contracts: 48
Known Assets: 56
Compliance Assets: 56
```

---

### Section 2: Contractor Overview

**Format:**
```
✅ ABC Lifts Ltd – Lift Maintenance – Quarterly – Next Due: 12/10/2025
✅ SecureDoors Ltd – Roller Shutters – 6-Monthly – Next Due: 15/12/2025
⚠️ XYZ Heating – Boiler Service – Annual – Next Due: 15/01/2026
```

**Status Icons:**
- ✅ Active and current
- ⚠️ Due soon (within 30 days)
- ❌ Overdue
- ❓ Unknown/missing

---

### Section 3: Asset Register

**Table Columns:**
1. Asset - Name/Type
2. Contractor - Responsible party
3. Frequency - Service interval
4. Last Service - Date of last maintenance
5. Next Due - Date of next service
6. Compliance - Linked compliance category
7. Status - Visual indicator

**Example:**
```
┌──────────────┬───────────────┬───────────┬──────────────┬───────────┬─────────────┬────────┐
│ Asset        │ Contractor    │ Frequency │ Last Service │ Next Due  │ Compliance  │ Status │
├──────────────┼───────────────┼───────────┼──────────────┼───────────┼─────────────┼────────┤
│ AOV (Core A) │ ABC Lifts Ltd │ Quarterly │ 01/07/2025   │ 01/10/2025│ Fire Safety │ ✅     │
│ Boiler       │ XYZ Heating   │ Annual    │ 15/03/2025   │ 15/03/2026│ Gas Safe    │ ⚠️     │
│ Lift Pass. 1 │ ABC Lifts Ltd │ Quarterly │ 20/02/2025   │ 20/05/2025│ Lifts       │ ✅     │
└──────────────┴───────────────┴───────────┴──────────────┴───────────┴─────────────┴────────┘
```

**Status Determination:**
- ✅ **Compliant**: Next due >30 days away
- ⚠️ **Due Soon**: Next due within 30 days
- ❌ **Overdue**: Next due date passed
- ❓ **Unknown**: No service date available

---

### Section 4: Compliance Matrix

**Summary by Category:**

| Category          | Compliant | Overdue | Unknown |
|-------------------|-----------|---------|---------|
| Fire Safety       | ✅ 12     | 0       | 0       |
| Electrical Safety | ✅ 8      | ❌ 2    | 0       |
| Gas Safety        | ✅ 4      | 0       | ❔ 1    |
| Water Safety      | ✅ 6      | ❌ 1    | 0       |
| Lifts Safety      | ✅ 4      | 0       | 0       |

**Highlights:**
- Missing certificates flagged
- Expired certificates highlighted
- Unknown status tracked

---

### Section 5: Recommendations

**Auto-Generated Action Items:**

Examples:
1. 🔴 **URGENT:** Lift maintenance due in next 30 days
2. ❌ **CRITICAL:** No linked contractor found for CCTV system
3. ⚠️ **ATTENTION:** FRA overdue since Jan 2025
4. 💰 **REVIEW:** Policy ABC123 underinsured by £500,000
5. 📝 **ACTION:** Reinstate door entry contract
6. 📅 **SCHEDULE:** Gas safety certificate expires 20/12/2025

**Generation Logic:**
- Compliance assets overdue or due soon
- Insurance gaps or expiring policies
- Expired contracts
- Missing contractor links
- High arrears balance
- Old reinstatement cost assessments

---

## Usage

### CLI Generation

```bash
python run_onboarder.py \
  --folder "/path/to/handover" \
  --building-id "abc-123" \
  --generate-report
```

### Programmatic Generation

```python
from BlocIQ_Onboarder.reporting import BuildingHealthCheckGenerator
from supabase import create_client
import os

# Initialize with branding
generator = BuildingHealthCheckGenerator(
    supabase_client=create_client(
        os.getenv('SUPABASE_URL'),
        os.getenv('SUPABASE_SERVICE_ROLE_KEY')
    ),
    branding_config_path='config/branding.json'
)

# Generate report
report_path = generator.generate_report(
    building_id='abc-123',
    output_dir='reports'
)

print(f"Report: {report_path}")
```

---

## Output

### File Naming

**Default:** `{building_id}_Building_Health_Check.pdf`

**Example:** `abc-123_Building_Health_Check.pdf`

### Storage Location

**Default:** `reports/` directory

**Custom:** Specify via `output_dir` parameter

---

## Branding Customization

### Change Company Logo

1. Replace: `BlocIQ_Onboarder/assets/logo-header.png`
2. Logo will auto-scale to 2" width × 0.8" height

### Change Brand Colors

Edit `config/branding.json`:

```json
{
  "brand_colors": {
    "primary": "#YOUR_PRIMARY_COLOR",
    "success": "#YOUR_SUCCESS_COLOR",
    "warning": "#YOUR_WARNING_COLOR",
    "danger": "#YOUR_DANGER_COLOR"
  }
}
```

### Change Report Title

```json
{
  "report_title": "Your Company Building Health Check",
  "company_name": "Your Company Name"
}
```

### Change Status Icons

```json
{
  "status_icons": {
    "compliant": "✓",
    "due_soon": "!",
    "overdue": "✗",
    "missing": "?"
  }
}
```

---

## Data Requirements

### Minimum Required Data

**Essential:**
- Building record (id, name, address)
- At least 1 compliance asset OR 1 contract

**Recommended:**
- Contractors with contact details
- Contracts with service schedules
- Assets with service history
- Compliance records with status
- Insurance policies
- Financial snapshots

### Optional Data

- Leaseholder records
- Meeting minutes
- Utility accounts
- Document attachments

---

## Advanced Features

### Contractor–Asset Linking

**Automatic Cross-Referencing:**
- Assets linked to contractors via `contractor_id`
- Contractors linked to buildings via `building_contractors`
- Maintenance schedules generated from contract frequency

**Example Flow:**
```
Contract (Fire Alarm Service)
  ├─ Contractor: ABC Fire Ltd
  ├─ Frequency: Quarterly
  └─ Generates maintenance_schedule records
      └─ Links to asset: Fire Alarm System
          └─ Links to compliance: Fire Risk Assessment
```

### Compliance Cross-Linking

**Assets automatically linked to compliance records:**

```python
# Asset detection
asset = {
    'asset_type': 'fire_alarm',
    'asset_name': 'Fire Alarm System',
    ...
}

# Auto-link to compliance
compliance = {
    'asset_type': 'fire_alarm',
    'compliance_status': 'compliant',
    ...
}

# Link created
asset['compliance_asset_id'] = compliance['id']
```

---

## Troubleshooting

### Logo Not Appearing

**Check:**
1. Logo file exists at `assets/logo-header.png`
2. File path in `branding.json` is correct
3. Image format is PNG or JPEG
4. File permissions allow reading

**Solution:**
```bash
# Verify logo exists
ls -la BlocIQ_Onboarder/assets/logo-header.png

# Check branding config
cat BlocIQ_Onboarder/config/branding.json
```

### Colors Not Applied

**Check:**
1. Hex colors in branding.json are valid (e.g., "#1e40af")
2. JSON syntax is valid (no trailing commas)
3. Branding config loads without errors

**Solution:**
```bash
# Validate JSON
python3 -c "import json; print(json.load(open('BlocIQ_Onboarder/config/branding.json')))"
```

### Missing Sections

**Cause:** Insufficient data in database

**Solution:**
- Ensure tables exist: `contractors`, `contracts`, `assets`, `compliance_assets`
- Run schema introspection: `python run_onboarder.py --schema-only`
- Verify building_id exists in database

---

## Performance

**Generation Time:**
- Small building (<50 assets): 3-5 seconds
- Medium building (50-200 assets): 5-8 seconds
- Large building (>200 assets): 8-12 seconds

**File Size:**
- Typical report: 200-500 KB
- With logo: +50-100 KB
- With gauge chart: +20-30 KB

---

## Migration from Previous Version

### Changes from v2.0 to v3.0

**New:**
- Logo in header
- Branding configuration system
- Section numbering (1-5)
- Contractor overview section
- Compliance matrix section
- Enhanced asset register with status icons

**Renamed:**
- `Building Health Check Report` → Configurable title
- Section headers now numbered
- Status display uses icons

**Backward Compatible:**
- All v2.0 data structures supported
- Graceful degradation if branding.json missing
- Default branding used if logo unavailable

---

## API Reference

### BuildingHealthCheckGenerator

```python
class BuildingHealthCheckGenerator:
    def __init__(
        self,
        supabase_client=None,
        branding_config_path=None
    ):
        """
        Initialize report generator

        Args:
            supabase_client: Supabase client instance
            branding_config_path: Path to branding.json
        """

    def generate_report(
        self,
        building_id: str,
        output_dir: str = 'reports'
    ) -> str:
        """
        Generate Building Health Check PDF

        Args:
            building_id: Building UUID
            output_dir: Output directory path

        Returns:
            Path to generated PDF
        """
```

### Branding Configuration

```python
# Load custom branding
generator = BuildingHealthCheckGenerator(
    supabase_client=supabase,
    branding_config_path='/path/to/custom_branding.json'
)

# Use default branding
generator = BuildingHealthCheckGenerator(supabase_client=supabase)
```

---

## Examples

### Example 1: Full Report with Logo

```bash
# 1. Add logo
cp your-logo.png BlocIQ_Onboarder/assets/logo-header.png

# 2. Generate report
python run_onboarder.py \
  --folder "/path/to/handover" \
  --building-id "abc-123" \
  --generate-report

# Output: reports/abc-123_Building_Health_Check.pdf
```

### Example 2: Custom Branding

```python
# custom_branding.json
{
  "company_name": "Property Management Ltd",
  "report_title": "Property Management Building Health Check",
  "logo_path": "assets/pm-logo.png",
  "brand_colors": {
    "primary": "#0066cc",
    "success": "#00cc66",
    "warning": "#ff9900",
    "danger": "#cc0000"
  }
}

# Generate with custom branding
from BlocIQ_Onboarder.reporting import BuildingHealthCheckGenerator

generator = BuildingHealthCheckGenerator(
    branding_config_path='custom_branding.json'
)
generator.generate_report('building-123')
```

---

## Future Enhancements

**Planned Features:**
- [ ] Multi-building portfolio reports
- [ ] Historical trend tracking
- [ ] Interactive HTML version
- [ ] Email delivery integration
- [ ] Custom section ordering
- [ ] Multi-language support
- [ ] Watermark support
- [ ] Digital signatures

---

**Version:** 3.0
**Date:** 2025-10-07
**Status:** Production Ready ✅

**Fully integrated with contractor–asset intelligence system.**
