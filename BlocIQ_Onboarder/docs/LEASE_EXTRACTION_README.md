# Lease Document Extraction with OCR

## Overview
Automatically detects and extracts lease information from onboarding documents using OCR integration with the Render.com microservice (from BlocIQ frontend).

## OCR Integration

### External OCR Service (Render.com)
**URL**: `https://ocr-server-2-ykmk.onrender.com/upload`
**Token**: `blociq-dev-token-2024`
**Technology**: Python/FastAPI with Tesseract OCR and Google Vision API

### Configuration
```bash
# Environment variables
RENDER_OCR_URL=https://ocr-server-2-ykmk.onrender.com/upload
RENDER_OCR_TOKEN=blociq-dev-token-2024
```

### OCR Request
```python
POST https://ocr-server-2-ykmk.onrender.com/upload
Authorization: Bearer blociq-dev-token-2024
Content-Type: multipart/form-data

FormData:
  - file: <binary>
  - use_google_vision: "false"  # true for Google Vision, false for Tesseract
```

### OCR Response
```json
{
  "text": "Extracted text content from lease document...",
  "source": "tesseract",
  "text_length": 3500
}
```

## Detection Rules

### Lease Document Identification
Files are identified as leases if they contain:

**Filename keywords:**
- lease
- leasehold
- tenancy
- official copy
- transfer
- assignment

**Text markers:**
- THIS LEASE
- LEASE AGREEMENT
- DEMISE
- LESSOR and LESSEE
- OFFICIAL COPY
- LAND REGISTRY
- TITLE NUMBER

## Extraction Logic

### Fields Extracted

#### 1. **term_start** (date)
Patterns:
- "commencing on 1st January 2003"
- "from the 1st January 2003"
- "dated the 1/1/2003"
- ISO formats: YYYY-MM-DD, DD/MM/YYYY

#### 2. **term_years** (integer)
Patterns:
- "for a term of 125 years"
- "for 99 years"
- "125-year lease"

Sanity check: 1-9999 years

#### 3. **ground_rent** (numeric)
Patterns:
- "ground rent of £250 per annum"
- "£50 ground rent"
- "rent: £250 per annum"

Sanity check: £0-£100,000

#### 4. **rent_review_period** (integer)
Patterns:
- "reviewed every 25 years"
- "review period of 33 years"
- "rent review: 25 years"

Sanity check: 1-999 years

#### 5. **leaseholder_name** (text)
Patterns:
- "and [NAME] (hereinafter called the Lessee)"
- "Lessee: [NAME]"
- "granted to [NAME]"

Filters out: "The Landlord", "The Tenant", "The Lessee"

#### 6. **lessor_name** (text)
Patterns:
- "[NAME] Ltd (hereinafter called the Landlord)"
- "Lessor: [NAME]"
- "between [NAME] and"

#### 7. **unit_reference** (text)
Patterns from filename:
- "Flat 3.pdf" → "3"
- "Flat3.pdf" → "3"
- "Unit_5A.pdf" → "5A"
- "Apartment 12.pdf" → "12"

Patterns from text:
- "Flat No. 3"
- "Unit: 5A"
- "property known as 12"

#### 8. **unit_id** (uuid)
- Matches unit_reference against units table
- Tries exact match, then partial match, then numeric match

#### 9. **expiry_date** (computed)
```python
expiry_date = term_start + (term_years × 365.25 days)
```

Example: 2003-01-01 + 125 years = 2128-01-01

## Database Schema

```sql
CREATE TABLE leases (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  building_id uuid REFERENCES buildings(id),
  unit_id uuid REFERENCES units(id),
  term_start date,
  term_years integer,
  expiry_date date,
  ground_rent numeric(10,2),
  rent_review_period integer,
  leaseholder_name text,
  lessor_name text,
  source_document text,
  notes text,
  created_at timestamptz DEFAULT now()
);

CREATE INDEX idx_leases_building ON leases(building_id);
CREATE INDEX idx_leases_unit ON leases(unit_id);
CREATE INDEX idx_leases_expiry ON leases(expiry_date);
```

## SQL Output Example

```sql
-- Insert 2 lease records
INSERT INTO leases (
  id, building_id, unit_id, term_start, term_years, expiry_date, ground_rent,
  rent_review_period, leaseholder_name, lessor_name, source_document
)
VALUES (
  'a3c1e0c9-42d2-4e0b-b317-92bfad9a42fa',
  '63567c65-7815-461a-ac88-80cf5c1f0113',
  'f03c88c0-fe4d-49c4-a0ab-5b7cb203e122',
  '2003-01-01',
  125,
  '2128-01-01',
  250.00,
  25,
  'Ms J Gomm',
  'Connaught Square Freehold Ltd',
  'Flat 3 Lease.pdf'
);

INSERT INTO leases (
  id, building_id, unit_id, term_start, term_years, ground_rent,
  leaseholder_name, lessor_name, source_document, notes
)
VALUES (
  'b4d2f1d8-53e3-5f1c-c428-a3bfce8b53gb',
  '63567c65-7815-461a-ac88-80cf5c1f0113',
  NULL,
  NULL,
  99,
  NULL,
  NULL,
  'Freehold Company Ltd',
  'Flat 5 Lease.pdf',
  'Partial record created from filename only - OCR not available'
);
```

## Error Handling

### Partial Records
If OCR fails or fields cannot be extracted:
- Create record with available data
- Set missing fields to NULL
- Add note explaining limitation

### OCR Timeout
- Timeout: 60 seconds per document
- Fallback: Create partial record from filename
- Error logged to timeline_events

### OCR Service Unavailable
```
⚠️  OCR service not configured, skipping Flat3_Lease.pdf
```
Creates partial record from filename only.

### Timeline Events
Errors are logged for manual review:
```sql
INSERT INTO timeline_events (
  building_id, event_type, description, metadata, severity
) VALUES (
  '{{building_id}}',
  'import_error',
  'Lease extraction error: Could not parse term start date',
  '{"file": "Flat3_Lease.pdf", "error_type": "lease_extraction"}',
  'warning'
);
```

## Processing Flow

```
┌─────────────────────────────────────┐
│  Onboarder scans parsed_files       │
└──────────────┬──────────────────────┘
               │
               ▼
┌─────────────────────────────────────┐
│  Lease detection (filename + text)  │
│  - Keywords: lease, official copy   │
│  - Markers: THIS LEASE, DEMISE      │
└──────────────┬──────────────────────┘
               │
               ▼
┌─────────────────────────────────────┐
│  Text content available?            │
│  YES → Extract fields               │
│  NO  → Call Render OCR service      │
└──────────────┬──────────────────────┘
               │
               ▼
┌─────────────────────────────────────┐
│  OCR Processing (if needed)         │
│  POST to Render.com                 │
│  - Tesseract (default)              │
│  - Google Vision (optional)         │
│  Timeout: 60 seconds                │
└──────────────┬──────────────────────┘
               │
               ▼
┌─────────────────────────────────────┐
│  Field Extraction (regex patterns)  │
│  - term_start, term_years           │
│  - ground_rent, rent_review_period  │
│  - leaseholder_name, lessor_name    │
│  - unit_reference                   │
└──────────────┬──────────────────────┘
               │
               ▼
┌─────────────────────────────────────┐
│  Unit Matching                      │
│  Match unit_reference to units      │
│  - Exact match                      │
│  - Partial match                    │
│  - Numeric match                    │
└──────────────┬──────────────────────┘
               │
               ▼
┌─────────────────────────────────────┐
│  Compute Expiry Date                │
│  expiry = start + (years × 365.25)  │
└──────────────┬──────────────────────┘
               │
               ▼
┌─────────────────────────────────────┐
│  Generate INSERT INTO leases        │
│  ON CONFLICT DO NOTHING             │
└──────────────┬──────────────────────┘
               │
               ▼
┌─────────────────────────────────────┐
│  Log to timeline_events (errors)    │
│  Add to audit_log (statistics)      │
└─────────────────────────────────────┘
```

## Performance Considerations

### OCR Processing Time
- **Tesseract**: ~5-15 seconds per page
- **Google Vision**: ~2-5 seconds per page (higher accuracy, costs apply)
- **Cold start**: Render.com free tier may add 10-30 seconds on first request

### Rate Limiting
- Process lease documents sequentially to avoid overwhelming OCR service
- No batch processing (one file at a time)

### Optimization
- Skip OCR if text_content already available (from parser)
- Only process files matching lease detection rules
- Cache OCR results in parsed_files for reuse

## Statistics Tracking

### Audit Log Entry
```json
{
  "timestamp": "2025-10-07T13:30:00",
  "action": "extract_lease_data",
  "leases_extracted": 5,
  "files_processed": 6,
  "files_with_ocr": 3,
  "errors": 1
}
```

### Output Summary
```
📜 Extracting lease information...
  📜 Extracting lease information...
     🔍 Performing OCR on Flat3_Lease.pdf...
        ✅ OCR complete: 3500 characters extracted
     ✅ Lease files found: 6
     ✅ Leases extracted: 5
     ✅ Files processed with OCR: 3
     ⚠️  Errors: 1
```

## Future Enhancements

### Auto-create Leaseholders
If leaseholder_name extracted but not in database:
```sql
INSERT INTO leaseholders (id, building_id, unit_id, name)
VALUES (gen_random_uuid(), '{{building_id}}', '{{unit_id}}', 'Ms J Gomm')
ON CONFLICT DO NOTHING;
```

### Confidence Scoring
```python
confidence = {
  'term_start': 'high' if exact_date else 'low',
  'ground_rent': 'high' if clear_amount else 'medium',
  'parties': 'low' if fuzzy_match else 'high'
}
```

### Ambiguity Detection
Mark fields with multiple conflicting values:
```json
{
  "ground_rent": 250,
  "notes": "Multiple rent amounts found: £250, £300 - using first occurrence"
}
```

### Document Linking
Link to building_documents table:
```sql
ALTER TABLE leases ADD COLUMN document_id uuid REFERENCES building_documents(id);
```

## Testing

### Test Documents
```
/Users/ellie/Downloads/219.01 CONNAUGHT SQUARE/
  Flat 3 Lease.pdf
  Flat 5 Official Copy.pdf
  Unit 7A Leasehold Agreement.pdf
```

### Expected Output
```sql
INSERT INTO leases (id, building_id, unit_id, term_start, term_years, ...) VALUES (...);
INSERT INTO leases (id, building_id, unit_id, term_start, term_years, ...) VALUES (...);
INSERT INTO leases (id, building_id, unit_id, term_start, term_years, ...) VALUES (...);
```

### Validation
```bash
# Check SQL output
grep "INSERT INTO leases" /Users/ellie/Desktop/BlocIQ_Output/migration.sql

# Count leases
grep -c "INSERT INTO leases" /Users/ellie/Desktop/BlocIQ_Output/migration.sql

# Check for errors
grep "lease_extraction" /Users/ellie/Desktop/BlocIQ_Output/audit_log.json
```

## Files Modified

1. **lease_extractor.py** (NEW) - Core lease extraction logic with OCR
2. **sql_writer.py** - Added leases table DDL and insert generator
3. **onboarder.py** - Integrated _extract_lease_data() at Step 4.57
4. **LEASE_EXTRACTION_README.md** (NEW) - This documentation

## Dependencies

### Python Packages
- `requests` - For calling Render OCR service

### External Services
- Render.com OCR microservice (Tesseract + Google Vision)

### Environment Variables
```bash
RENDER_OCR_URL=https://ocr-server-2-ykmk.onrender.com/upload
RENDER_OCR_TOKEN=blociq-dev-token-2024
```

## Notes

- OCR processing adds ~5-15 seconds per lease document
- Google Vision API can be enabled with `use_google_vision=true` (not implemented yet)
- Render.com free tier may have cold starts (10-30 seconds)
- All lease records are created even if partial data is available
- Expiry date is auto-computed from term_start + term_years
- Unit matching uses fuzzy logic for flexible name matching
