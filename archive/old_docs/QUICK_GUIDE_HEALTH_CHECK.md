# Quick Guide: Building Health Check PDF Generation

## Problem Solved ✅
The Building Health Check PDF had multiple formatting issues:
- ❌ Many fields showing "N/A" 
- ❌ Dates in ISO format (2025-01-15) instead of DD/MM/YYYY
- ❌ No currency formatting
- ❌ Generic "No data available" messages
- ❌ Missing contract and contractor information
- ❌ Type errors when calculating percentages
- ❌ Not client-ready

## Solution ✅
Created a comprehensive system that:
- ✅ Parses migration.sql to extract all available data
- ✅ Formats dates as DD/MM/YYYY
- ✅ Formats currency as £X,XXX.XX
- ✅ Uses meaningful defaults ("Not recorded", "To be scheduled") instead of "N/A"
- ✅ Extracts contractors and contracts properly
- ✅ Handles type conversions safely
- ✅ Produces professional, client-ready reports

## How to Use

### Generate Health Check from Output Folder
```bash
cd /Users/ellie/onboardingblociq
python3 generate_health_check_from_output.py
```

This will:
1. Look for `output/migration.sql`
2. Parse all building data (units, contractors, compliance, insurance, budgets, etc.)
3. Generate a professional PDF report
4. Save to `output/[building-id]/building_health_check.pdf`

### Generate from Supabase (when data is uploaded)
```bash
cd /Users/ellie/onboardingblociq/BlocIQ_Onboarder
python3 generate_pdf.py YOUR_BUILDING_ID
```

## What's Included in the Report

### Section 1: Building Summary
- Building name and address
- Total units and leaseholders
- Active contracts count
- Known assets count
- Compliance assets count

### Section 2: Contractor Overview
- Active contractor count
- Contract status (✅ Active, ❌ Expired, ⚠️ Expiring Soon)
- Service types (Lifts, Security, Cleaning, etc.)
- Service frequencies (Monthly, Quarterly, Annual)
- Contract end dates

### Section 3: Asset Register
- All building assets (Fire doors, Lifts, Boilers, etc.)
- Asset types and names
- Service frequencies
- Last service dates (formatted)
- Next due dates (formatted)
- Status icons (✅ ⚠️ ❌ ❔)

### Section 4: Compliance Matrix & Status
- Total compliance items
- Compliant percentage
- Overdue items
- Due soon warnings
- Status for each certificate/inspection
- Last inspection and next due dates
- Responsible parties

### Section 5: Insurance Coverage
- All insurance policies
- Insurer names
- Policy numbers
- Coverage types
- Sum insured (formatted as currency)
- Renewal dates
- Status (✅ Current, ⚠️ Expiring, ❌ Expired)

### Section 6: Budgets
- Budget documents by financial year
- Total budget amounts (formatted)
- Status (📝 Draft, ✅ Final, ✅ Approved)
- Source document tracking

### Section 7: Apportionments
- Service charge apportionments by unit
- Percentages (with 3 decimal places)
- Schedule names
- Total percentage validation (✅ if = 100%)

### Section 8: Building Health Score
- Overall score out of 100
- Gauge visualization
- Rating (✅ Excellent, 🟢 Good, 🟠 Attention Required, 🔴 Critical)
- Component breakdowns

### Section 9: Recommendations
- Auto-generated action items
- Priority indicators (🔴 Urgent, 🟠 Attention)
- Based on compliance status, insurance gaps, contract expirations

## Example Output

### Before Improvements
```
Contractor: N/A
Service Type: N/A  
Frequency: N/A
End Date: N/A
Status: N/A
```

### After Improvements
```
✅ ISS – Lifts – Monthly – Contract End: 13/03/2026
✅ Quotehedge – Heating – As required – Contract End: Not specified  
⚠️ WHM – Water Hygiene – Quarterly – Contract End: 15/11/2025 (Expiring in 37 days)
```

## Sample Data Extracted

From Connaught Square sample:
- **Building**: Connaught Square, CONNAUGHT SQUARE
- **Units**: 8 (Flat 1, Flat 2, Flat 3, etc.)
- **Leaseholders**: 8
- **Compliance Assets**: 56 items
  - Fire Door Inspections: 29
  - Electrical Testing: 4
  - Water Safety: 3
  - General Compliance: 20
- **Contractors**: 4 companies (ISS, Quotehedge, WHM, Capita)
- **Contracts**: 43 active service contracts
- **Insurance Policies**: 152 policies on record
- **Budgets**: 22 budget documents
- **Apportionments**: 26 unit allocations

## Key Features

### Professional Formatting
- ✅ Dates: DD/MM/YYYY (e.g., 15/11/2025)
- ✅ Currency: £X,XXX.XX (e.g., £125,000.00)
- ✅ Percentages: X.XXX% (e.g., 12.500%)
- ✅ Status Icons: ✅ ⚠️ ❌ ❔ 📝
- ✅ Color Coding: Green (good), Orange (warning), Red (critical), Gray (unknown)

### Intelligent Defaults
Instead of "N/A", the report now shows:
- **"Not recorded"** - for dates/values that weren't captured
- **"Not specified"** - for optional information not provided
- **"To be scheduled"** - for future dates not yet set
- **"Not assigned"** - for responsible parties not designated
- **"As required"** - for non-regular service frequencies

### Error Handling
- Safely handles NULL values from database
- Converts string percentages to floats
- Parses various date formats
- Handles missing data gracefully
- Falls back to summary.json if SQL parsing fails

## Files Created/Modified

### New Files
1. **`BlocIQ_Onboarder/sql_parser.py`** - SQL parser for data extraction
2. **`BUILDING_HEALTH_CHECK_IMPROVEMENTS.md`** - Detailed technical documentation
3. **`QUICK_GUIDE_HEALTH_CHECK.md`** - This quick reference

### Modified Files
1. **`BlocIQ_Onboarder/reporting/building_health_check.py`** - Enhanced report generator
2. **`generate_health_check_from_output.py`** - Updated to use SQL parser

## Troubleshooting

### Report shows minimal data
- Check that `output/migration.sql` exists
- Verify the SQL file has INSERT statements for your building
- Check console output for parsing errors

### Type errors
- Fixed! All type conversions now handle strings/floats safely
- Percentages converted properly
- Currency values parsed correctly

### Formatting issues
- All dates now formatted as DD/MM/YYYY
- All currency now formatted as £X,XXX.XX  
- All tables use consistent styling

## Next Steps

The report is now client-ready! Optional enhancements:
1. Add unit name lookups (instead of showing UUIDs)
2. Include contractor contact details in overview
3. Add charts/graphs for visual representation
4. Create executive summary page
5. Add building intelligence insights when available

## Support

For questions or issues, refer to:
- **`BUILDING_HEALTH_CHECK_IMPROVEMENTS.md`** - Detailed technical documentation
- **`BlocIQ_Onboarder/reporting/building_health_check.py`** - Source code
- **`BlocIQ_Onboarder/sql_parser.py`** - Data extraction logic
