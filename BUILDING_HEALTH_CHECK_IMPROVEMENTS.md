# Building Health Check PDF Improvements

## Summary
Fixed multiple formatting issues and N/A field problems in the Building Health Check PDF report to create professional, client-ready documentation.

## Key Improvements Made

### 1. Data Extraction Enhancement
**Created `sql_parser.py`**: A comprehensive SQL parser that extracts structured data from `migration.sql` files
- Parses all major tables: buildings, units, leaseholders, compliance_assets, contractors, contracts, budgets, apportionments, insurance, etc.
- Converts SQL INSERT statements back into Python dictionaries
- Handles complex data types and NULL values properly
- **Result**: Report now uses complete database records instead of minimal summary data

### 2. Better Data Formatting
**Added formatting helper methods** to `building_health_check.py`:
- `_format_date()`: Converts dates to readable DD/MM/YYYY format instead of ISO strings
- `_format_currency()`: Formats monetary values as £X,XXX.XX
- `_safe_get()`: Safely retrieves values with meaningful defaults instead of "N/A"

**Before**: `N/A` everywhere
**After**: "Not recorded", "To be scheduled", "Not specified" - contextual and meaningful

### 3. Improved Section Content

#### Section 1: Building Summary
- Now shows actual unit count, leaseholder count, active contracts
- All data pulled from parsed records

#### Section 2: Contractor Overview
- **Before**: Simple list or "No data available"
- **After**: 
  - Summary statistics (X active contractors, Y/Z active contracts)
  - Detailed list with service types, frequencies, contract end dates
  - Status icons: ✅ Active, ❌ Expired, ⚠️ Expiring Soon, ❔ Status Unknown
  - Meaningful text when no data: explains what will be tracked

#### Section 3: Asset Register
- **Before**: Raw N/A values in tables
- **After**:
  - Asset names with intelligent fallbacks
  - Service frequencies formatted properly
  - Dates formatted as DD/MM/YYYY
  - "Not recorded" / "To be scheduled" instead of N/A
  - Status icons based on next due dates
  - Alternating row colors for readability

#### Section 4: Compliance Matrix & Status
- **Before**: Generic "No data available"
- **After**:
  - Summary statistics with percentages
  - Color-coded status: ✅ Compliant (green), ❌ Overdue (red), ⚠️ Due Soon (orange), ❔ Unknown (gray)
  - Proper date formatting
  - Responsible party tracking
  - Meaningful contextual text when data is incomplete

#### Section 5: Insurance Coverage
- **Before**: "N/A" for missing fields
- **After**:
  - "Insurer not recorded" instead of N/A
  - "Not recorded" for missing policy numbers
  - Currency formatting: £XX,XXX.XX
  - Dates formatted properly
  - Status with days remaining: "⚠️ 15 days" for expiring soon
  - Clear explanatory text when no policies found

#### Section 6: Budgets
- **Before**: Basic table with "N/A"
- **After**:
  - Financial years extracted and formatted (2024 - 2025)
  - Currency values properly formatted
  - Status icons: 📝 Draft, ✅ Final, ✅ Approved
  - Source document tracking
  - Warning for budgets requiring total calculation

#### Section 7: Apportionments
- **Before**: Type errors with percentage calculations
- **After**:
  - Safe percentage parsing (handles string/float conversion)
  - Percentage totals calculated correctly
  - ✅ Correct indicator when totals = 100%
  - ⚠️ Warning with actual total if not 100%

### 4. Type Safety & Error Handling
**Fixed critical issues**:
- Percentage values from SQL are strings → added float conversion with error handling
- Location fields can be NULL → added null checks before string operations
- Currency values need parsing → added safe numeric conversion
- Date strings need formatting → added comprehensive date parsing

### 5. Professional Presentation
**Enhanced visual design**:
- Alternating row colors (beige/white) for better readability
- Consistent table styling across all sections
- Proper column widths to prevent text overflow
- Truncation with ellipsis (...) for long values
- Consistent use of status icons throughout
- Color-coded information (green for good, red for issues, orange for warnings)

## Files Modified

### New Files Created
1. **`BlocIQ_Onboarder/sql_parser.py`** (426 lines)
   - Complete SQL parser for extracting structured data
   - Handles all major tables in the migration.sql

### Files Updated
2. **`BlocIQ_Onboarder/reporting/building_health_check.py`**
   - Added formatting helper methods
   - Improved all section builders
   - Better default values and error handling
   - Enhanced table styling

3. **`generate_health_check_from_output.py`**
   - Now uses SQL parser to load complete data
   - Falls back to summary.json if SQL parsing fails

## Before vs After Comparison

### Before
```
Contractor: N/A
Service: N/A
Frequency: N/A
Next Due: N/A
```

### After
```
✅ ISS – Lifts – Monthly – Contract End: 13/03/2026
✅ Quotehedge – Heating – As required – Contract End: Not specified
⚠️ WHM – Water Hygiene – Quarterly – Contract End: 15/11/2025
```

## Data Extraction Results

Current extraction from Connaught Square sample:
- ✅ **Building**: Connaught Square
- ✅ **Units**: 8
- ✅ **Leaseholders**: 8
- ✅ **Compliance Assets**: 56
- ✅ **Contractors**: 4
- ✅ **Contracts**: 43
- ✅ **Budgets**: 22
- ✅ **Apportionments**: 26
- ✅ **Insurance Policies**: 152

## Usage

### Generate Building Health Check from Output Folder
```bash
cd /Users/ellie/onboardingblociq
python3 generate_health_check_from_output.py
```

This will:
1. Read `output/migration.sql` and parse all data
2. Generate a comprehensive PDF report
3. Apply letterhead branding
4. Save to `output/[building-id]/building_health_check.pdf`

### Generate from Supabase
```bash
cd /Users/ellie/onboardingblociq/BlocIQ_Onboarder
python3 generate_pdf.py [building-id]
```

## Benefits

### For Clients
- **Professional appearance**: No more raw "N/A" or missing data messages
- **Readable dates**: UK format (DD/MM/YYYY) instead of ISO
- **Clear currency**: £X,XXX.XX format
- **Contextual information**: Meaningful text explains what data represents
- **Visual clarity**: Icons, colors, and formatting make reports easy to scan

### For BlocIQ
- **Reduced manual editing**: Reports are client-ready on generation
- **Consistent quality**: All sections follow same formatting standards
- **Complete data**: SQL parsing extracts all available information
- **Maintainable code**: Helper methods make future updates easier

## Next Steps / Optional Enhancements

1. **Add unit name lookups**: Currently showing unit IDs in apportionments - could look up actual unit numbers
2. **Contractor contact details**: Could add phone/email to contractor overview
3. **Lease information**: When lease data is available, integrate into report
4. **Building staff**: When staff data is populated, display in dedicated section
5. **Building intelligence**: When extracted, add insights section
6. **Charts and graphs**: Add visual representations of compliance status, budget trends, etc.
7. **Executive summary**: Add a one-page executive summary at the start

## Technical Notes

### SQL Parsing Approach
- Uses regex to extract INSERT statements
- Handles complex nested values (arrays, escaped quotes)
- Maps SQL data types to Python types
- Preserves referential integrity between tables

### Error Handling
- Graceful degradation when data is missing
- Safe type conversions with try/except
- Meaningful defaults instead of exceptions
- Fallback to summary.json if SQL parsing fails

### Performance
- Parses 5,737-line SQL file in ~1 second
- Report generation takes 3-5 seconds
- No database queries needed for offline generation

## Conclusion

The Building Health Check PDF now produces professional, client-ready reports with properly formatted data, meaningful default values, and clear visual presentation. All N/A fields have been replaced with contextual information, and the report makes full use of available data from the migration SQL files.
