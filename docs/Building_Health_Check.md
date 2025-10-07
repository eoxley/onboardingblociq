# Building Health Check Report - Documentation

## Overview

The **Building Health Check** is an AI-driven PDF report that provides comprehensive analytics, risk assessment, and actionable recommendations based on all extracted handover data. It's automatically generated after each ingestion run to give directors, clients, and property managers an instant overview of building health.

## Report Structure

### 1. Executive Summary 📊

**Contents:**
- Building name and address
- Report generation date
- Key metrics overview:
  - Number of units
  - Compliance assets count
  - Insurance policies count
  - Active contracts count
  - Utility accounts count

**Purpose:** Instant snapshot of building portfolio size and data coverage.

---

### 2. Overall Building Health Score 🩺

**Scoring Algorithm:**

| Component | Weight | Calculation Method |
|-----------|--------|-------------------|
| **Compliance** | 30% | (% compliant assets) × 0.30 <br/> Penalty: -30% per overdue, -10% per due soon |
| **Insurance** | 25% | Base 100% <br/> Penalty: -15% if underinsured, -30% if expired, -10% if expiring <30 days |
| **Contracts** | 15% | (% active contracts / total) × 0.15 |
| **Finance** | 15% | (1 - arrears_ratio) × 0.15 <br/> where arrears_ratio = arrears / balance |
| **Utilities** | 10% | (% active utilities / total) × 0.10 |
| **Meetings** | 5% | 100% if meeting <90 days, 70% if <180 days, 40% otherwise |

**Total Score:** 0-100 (weighted sum)

**Rating Bands:**
- **90-100:** ✅ Excellent (Green)
- **70-89:** 🟢 Good (Light Green)
- **50-69:** 🟠 Attention Required (Amber)
- **<50:** 🔴 Critical (Red)

**Visual:** Gauge chart with color-coded needle showing current score.

---

### 3. Compliance Status 🔥

**Data Sources:**
- `compliance_assets` table
- Fields: `asset_name`, `inspection_date`, `reinspection_date`, `inspection_contractor`, `compliance_status`

**Metrics Displayed:**
- Total compliance assets
- Number compliant (green)
- Number overdue (red)
- Number due soon (amber)
- % compliant

**Table Columns:**
1. Asset Name (e.g., "Fire Risk Assessment")
2. Last Inspection Date
3. Next Due Date
4. Contractor
5. Status (color-coded: compliant/overdue/due_soon)

**Risk Indicators:**
- 🔴 Any overdue assets trigger urgent recommendations
- 🟠 Assets due within 30 days flagged
- ⚠️ Missing inspection dates shown as "unknown" status

---

### 4. Insurance Coverage 🛡️

**Data Sources:**
- `insurance_policies` table
- Fields: `insurer`, `policy_number`, `cover_type`, `sum_insured`, `reinstatement_value`, `start_date`, `end_date`

**Metrics Displayed:**
- Policy count
- Total sum insured
- Underinsured properties (where sum_insured < reinstatement_value × 0.9)
- Policies expiring <30 days

**Table Columns:**
1. Insurer
2. Policy Number
3. Cover Type (buildings/terrorism/EL/PL/etc.)
4. Sum Insured (£)
5. Expiry Date
6. Status (✅ Active / 🟠 Expiring / 🔴 Expired)

**Warnings Generated:**
- **Underinsured:** If gap > 10% between sum insured and reinstatement value
- **Expiring Soon:** <30 days to expiry
- **Expired:** Past expiry date
- **Old RCA:** Reinstatement cost assessment >3 years old

---

### 5. Contracts Overview 🧾

**Data Sources:**
- `contracts` table
- Fields: `contractor_name`, `service_type`, `start_date`, `end_date`, `renewal_date`, `contract_status`

**Metrics Displayed:**
- Total contracts
- Number active
- Number expired
- Number expiring soon (<30 days)

**Table Columns:**
1. Contractor Name
2. Service Type (fire_alarm/lifts/cleaning/etc.)
3. End Date
4. Status (✅ Active / 🟠 Expiring / 🔴 Expired)

**Service Coverage Check:**
Essential services flagged if missing:
- Fire alarm servicing
- Lift maintenance
- Emergency lighting testing

---

### 6. Utilities ⚡

**Data Sources:**
- `utilities` table
- Fields: `supplier`, `utility_type`, `account_number`, `tariff`, `contract_status`

**Table Columns:**
1. Supplier
2. Type (electricity/gas/water/waste/telecommunications)
3. Account Number
4. Status

**Flags:**
- Missing electricity or gas supplier
- Expired tariffs

---

### 7. Financial Position 💰

**Data Sources:**
- `client_money_snapshots` table (latest snapshot)
- Fields: `balance`, `uncommitted_funds`, `arrears_total`, `snapshot_date`

**Metrics Displayed:**
- Total client account balance (£)
- Uncommitted funds (£)
- Total arrears (£) - highlighted in red
- Snapshot date

**Health Indicator:**
- Arrears ratio: `arrears / balance`
- High arrears (>10%) trigger recommendations

---

### 8. Recent Meetings 🗂️

**Data Sources:**
- `meetings` table (last 3)
- Fields: `meeting_type`, `meeting_date`, `attendees`, `key_decisions`

**Display:**
- Meeting type (AGM/EGM/Board/Handover)
- Date
- Key decisions summary (first 200 chars)

**Governance Check:**
- Green if last meeting <90 days
- Amber if 90-180 days
- Red if >180 days

---

### 9. Recommendations & Action Items 💡

**Auto-Generated Based On:**

#### Compliance Issues
- **Overdue:** "🔴 URGENT: Renew {asset_name} (overdue)"
- **Due Soon:** "🟠 ATTENTION: {asset_name} due on {date}"

#### Insurance Issues
- **Underinsured:** "💰 Review Policy {policy_no}: Underinsured by £{gap}"
- **Expiring:** "📅 Policy {policy_no} expires in {days} days"
- **Expired:** "🔴 URGENT: Policy {policy_no} has expired"

#### Contract Issues
- **Expired:** "📝 Reinstate {service_type} contract with {contractor}"
- **Missing Essential:** "⚠️ No active {service} contract found"

#### Financial Issues
- **High Arrears:** "💰 Address arrears balance of £{amount} ({%})"

**Limit:** Top 10 recommendations displayed, prioritized by urgency.

---

## Technical Implementation

### Report Generation Flow

```
1. Data Gathering
   ├─ Query buildings table
   ├─ Query compliance_assets
   ├─ Query insurance_policies
   ├─ Query contracts
   ├─ Query utilities
   ├─ Query meetings
   └─ Query client_money_snapshots

2. Health Score Calculation
   ├─ Calculate compliance score (30%)
   ├─ Calculate insurance score (25%)
   ├─ Calculate contracts score (15%)
   ├─ Calculate finance score (15%)
   ├─ Calculate utilities score (10%)
   ├─ Calculate meetings score (5%)
   └─ Weighted total → Overall score

3. Recommendations Generation
   ├─ Scan for overdue compliance
   ├─ Check insurance gaps/expiry
   ├─ Check expired contracts
   └─ Prioritize by urgency

4. PDF Generation (ReportLab)
   ├─ Header with building info
   ├─ Executive summary table
   ├─ Health score gauge chart (matplotlib)
   ├─ Compliance table (color-coded)
   ├─ Insurance table
   ├─ Contracts table
   ├─ Utilities table
   ├─ Financial snapshot
   ├─ Recent meetings
   └─ Recommendations list

5. Output
   └─ {building_id}_Building_Health_Check.pdf
```

### Styling Specifications

**Colors:**
- **Primary (Header):** `#1e40af` (Blue)
- **Excellent:** `#10b981` (Green)
- **Good:** `#22c55e` (Light Green)
- **Attention:** `#f59e0b` (Amber)
- **Critical:** `#ef4444` (Red)

**Fonts:**
- **Titles:** Helvetica-Bold, 24pt
- **Section Headers:** Helvetica-Bold, 16pt
- **Body Text:** Helvetica, 10pt
- **Tables:** Helvetica, 8-9pt

**Layout:**
- **Page Size:** A4
- **Margins:** 1.5cm left/right, 2cm top/bottom
- **Spacing:** 0.2-0.5 inch between sections

---

## CLI Usage

### Generate Report During Onboarding

```bash
python run_onboarder.py \
  --folder "/path/to/handover" \
  --building-id "abc-123" \
  --generate-report
```

### Generate Report Standalone

```bash
# After data is already in Supabase
python -c "
from BlocIQ_Onboarder.reporting import BuildingHealthCheckGenerator
from supabase import create_client
import os

supabase = create_client(os.getenv('SUPABASE_URL'), os.getenv('SUPABASE_SERVICE_ROLE_KEY'))
gen = BuildingHealthCheckGenerator(supabase)
gen.generate_report('building-uuid-here', output_dir='reports')
"
```

---

## Schema Requirements

### Minimum Required Tables & Columns

#### `buildings`
- `id`, `name`, `address`

#### `compliance_assets`
- `id`, `building_id`, `asset_name`, `asset_type`, `inspection_date`, `reinspection_date`, `inspection_contractor`, `compliance_status`

#### `insurance_policies`
- `id`, `building_id`, `insurer`, `policy_number`, `cover_type`, `sum_insured`, `reinstatement_value`, `start_date`, `end_date`, `policy_status`

#### `contracts`
- `id`, `building_id`, `contractor_name`, `service_type`, `end_date`, `contract_status`

#### `utilities`
- `id`, `building_id`, `supplier`, `utility_type`, `account_number`, `contract_status`

#### `meetings`
- `id`, `building_id`, `meeting_type`, `meeting_date`, `key_decisions`

#### `client_money_snapshots`
- `id`, `building_id`, `balance`, `uncommitted_funds`, `arrears_total`, `snapshot_date`

### Schema Cross-Check

Before report generation, the system can optionally check for missing columns using `db/introspect.py` and append suggestions to `schema_suggestions.sql`.

---

## Sample Report Output

### Example Health Score Breakdown

**Building:** Connaught Square, London W2

**Overall Score:** 78/100 - 🟢 Good

| Component | Score | Weight | Weighted Score |
|-----------|-------|--------|----------------|
| Compliance | 85/100 | 30% | 25.5 |
| Insurance | 70/100 | 25% | 17.5 |
| Contracts | 90/100 | 15% | 13.5 |
| Finance | 75/100 | 15% | 11.25 |
| Utilities | 100/100 | 10% | 10.0 |
| Meetings | 50/100 | 5% | 2.5 |
| **TOTAL** | - | - | **78.0** |

### Example Recommendations

1. 🔴 URGENT: Renew Fire Risk Assessment (overdue)
2. 🟠 ATTENTION: EICR due on 15/11/2025
3. 💰 Review Policy POL123456: Underinsured by £500,000
4. 📅 Policy POL789012 expires in 14 days
5. 📝 Reinstate lift contract with ThyssenKrupp
6. 💰 Address arrears balance of £12,450 (5.2%)

---

## Customization

### Adjusting Score Weights

Edit `_calculate_health_score()` in `building_health_check.py`:

```python
scores['compliance'] = self._score_compliance() * 0.30  # Change weight
scores['insurance'] = self._score_insurance() * 0.25   # Change weight
# ... etc
```

### Adding New Sections

1. Add query method: `_query_your_table(building_id)`
2. Add to `_gather_building_data()`
3. Create build method: `_build_your_section()`
4. Add to report story in `generate_report()`

### Custom Styling

Modify `_setup_custom_styles()` to change fonts, colors, spacing.

---

## Performance

**Typical Generation Time:**
- Small building (<50 units): 2-3 seconds
- Medium building (50-200 units): 3-5 seconds
- Large building (>200 units): 5-8 seconds

**Dependencies:**
- ReportLab for PDF generation
- Matplotlib for gauge chart
- Supabase client for data queries

---

## Troubleshooting

### Issue: Report Generation Fails

**Possible Causes:**
1. Missing Supabase credentials
2. Missing required tables/columns
3. No building data found

**Solutions:**
1. Check `.env.local` has `SUPABASE_URL` and `SUPABASE_SERVICE_ROLE_KEY`
2. Run `python run_onboarder.py --schema-only` to check schema
3. Verify building_id exists in database

### Issue: Gauge Chart Not Appearing

**Cause:** Matplotlib backend issue or `/tmp` not writable

**Solution:**
- Check matplotlib is installed: `pip install matplotlib>=3.5.0`
- Ensure `/tmp` directory is writable
- Check for errors in console output

### Issue: Low Health Score

**Not a bug!** Review recommendations section to understand what needs attention.

---

## Future Enhancements

- [ ] Historical score tracking (trend graphs)
- [ ] Comparative analysis (building vs. portfolio average)
- [ ] Email delivery integration
- [ ] Interactive HTML version
- [ ] Custom branding/logo upload
- [ ] Multi-building portfolio reports
- [ ] Automated scheduling (monthly reports)

---

**Generated by:** BlocIQ Onboarder v2.0
**Last Updated:** 2025-10-07
**Maintainer:** BlocIQ Development Team

For support: See `IMPLEMENTATION_SUMMARY.md` or `README_HANDOVER_FULL_STRIP.md`
