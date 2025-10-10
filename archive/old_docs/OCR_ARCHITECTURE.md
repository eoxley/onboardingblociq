# OCR Architecture Analysis - BlocIQ Onboarder

## Executive Summary

**Current State:** BlocIQ Onboarder does **NOT** use any OCR service (Google Vision API, internal microservice, or otherwise). All text extraction is performed using **local Python libraries** for native text extraction from structured documents.

**No External OCR Dependencies:**
- ❌ No Google Vision API integration
- ❌ No Document AI integration
- ❌ No internal OCR microservice
- ❌ No hosted OCR endpoints (Render, FastAPI, etc.)
- ✅ Uses native Python PDF/Excel/Word parsers only

---

## 1. Text Extraction Methods

### Current Implementation: Native Library Parsing

The onboarder uses **local parsing libraries** to extract text directly from document structures:

| File Type | Library | Method | Location |
|-----------|---------|--------|----------|
| **PDF** | `pdfplumber` (primary)<br>`PyPDF2` (fallback) | Native text layer extraction | `parsers.py:143-208` |
| **Excel** | `openpyxl`<br>`pandas` | Read cell values directly | `parsers.py:37-141` |
| **Word** | `python-docx` | Extract paragraph/table text | `parsers.py:211-247` |
| **CSV** | `pandas` | Direct text reading | `parsers.py:249-271` |

### Key Functions

#### 1. `parse_file()` - Main Entry Point
**Location:** `parsers.py:273-309`

```python
def parse_file(file_path: str) -> Dict[str, Any]:
    """Dispatch to appropriate parser based on file extension"""
    ext = os.path.splitext(file_path)[1].lower()

    parsers = {
        '.xlsx': ExcelParser,
        '.xls': ExcelParser,
        '.pdf': PDFParser,
        '.docx': WordParser,
        '.csv': CSVParser
    }

    parser = parsers.get(ext)
    return parser(file_path).parse()
```

#### 2. PDF Text Extraction
**Location:** `parsers.py:155-186`

```python
def _parse_with_pdfplumber(self) -> Dict[str, Any]:
    """Extract text from PDF using pdfplumber"""
    text_content = []

    with pdfplumber.open(self.file_path) as pdf:
        for page_num, page in enumerate(pdf.pages, 1):
            text = page.extract_text()  # Native text extraction
            if text:
                text_content.append({
                    'page': page_num,
                    'text': text
                })

    return {
        'pages': len(text_content),
        'text_content': text_content,
        'full_text': '\n\n'.join([p['text'] for p in text_content])
    }
```

**Note:** This extracts the embedded text layer from PDFs. It does **NOT** perform OCR on scanned images.

#### 3. Excel Data Extraction
**Location:** `parsers.py:84-106`

```python
df = pd.read_excel(self.file_path, sheet_name=None, engine='openpyxl')

for sheet_name, sheet_df in df.items():
    result['data'][sheet_name] = {
        'rows': len(sheet_df),
        'columns': list(sheet_df.columns),
        'raw_data': sheet_df.to_dict('records')
    }
```

---

## 2. Data Flow Through Pipeline

### Overall Architecture

```
┌─────────────────┐
│  Client Files   │
│  (PDF/Excel/    │
│   Word/CSV)     │
└────────┬────────┘
         │
         ▼
┌─────────────────────────────────────────────────────────────┐
│ 1. FILE PARSING (parsers.py)                                │
│    • PDFParser.parse() → extract text from PDF layers       │
│    • ExcelParser.parse() → read Excel cell values           │
│    • WordParser.parse() → extract Word paragraphs           │
│    • CSVParser.parse() → read CSV rows                      │
│                                                              │
│    Output: {                                                 │
│      'file_name': str,                                       │
│      'file_path': str,                                       │
│      'full_text': str,        ← All text content            │
│      'text_content': List[Dict],  ← Page-by-page            │
│      'data': Dict,            ← Structured data (Excel)      │
│      'tables': List           ← Extracted tables             │
│    }                                                         │
└────────┬────────────────────────────────────────────────────┘
         │
         ▼
┌─────────────────────────────────────────────────────────────┐
│ 2. DOCUMENT CLASSIFICATION (classifier.py)                  │
│    • DocumentClassifier.classify(parsed_data)               │
│    • Reads: parsed_data['full_text']                        │
│    • Uses: keyword matching, filename patterns, regex       │
│                                                              │
│    Output: (category, confidence_score)                     │
│    Categories: 'compliance', 'budgets', 'major_works',      │
│               'units_leaseholders', 'apportionments', etc.  │
└────────┬────────────────────────────────────────────────────┘
         │
         ▼
┌─────────────────────────────────────────────────────────────┐
│ 3. SPECIALIZED EXTRACTION (extractors)                      │
│    • ComplianceAssetExtractor._extract_text_content()       │
│    • FinancialExtractor._extract_text_content()             │
│    • MajorWorksExtractor._extract_text_content()            │
│                                                              │
│    Reads from parsed file_data:                             │
│    • file_data['data'] (Excel sheets)                       │
│    • file_data['full_text'] (PDFs/Word)                     │
│    • file_data['text_content'] (page content)               │
└────────┬────────────────────────────────────────────────────┘
         │
         ▼
┌─────────────────────────────────────────────────────────────┐
│ 4. SCHEMA MAPPING (mapper.py, schema_mapper.py)            │
│    • Extract structured data from text content              │
│    • Map to Supabase schema fields                          │
│    • Generate SQL inserts                                   │
└────────┬────────────────────────────────────────────────────┘
         │
         ▼
┌─────────────────────────────────────────────────────────────┐
│ 5. STORAGE (storage_uploader.py)                            │
│    • Upload original files to Supabase Storage              │
│    • Store in: building-{id}/{category}/{filename}          │
│    • Does NOT store OCR text (no OCR performed)             │
└─────────────────────────────────────────────────────────────┘
         │
         ▼
┌─────────────────────────────────────────────────────────────┐
│ 6. DATABASE (Supabase)                                      │
│    • building_documents table has 'ocr_text' column         │
│    • Currently UNUSED (always NULL)                         │
│    • Reserved for future OCR integration                    │
└─────────────────────────────────────────────────────────────┘
```

---

## 3. Detailed Data Flow

### Step 1: Parsing (onboarder.py:151-162)

```python
def _parse_all_files(self):
    for file_path in self.client_folder.rglob('*'):
        if file_path.is_file():
            parsed = parse_file(str(file_path))  # parsers.py:273
            self.parsed_files.append(parsed)
```

### Step 2: Classification (onboarder.py:164-181)

```python
def _classify_files(self):
    for parsed in self.parsed_files:
        category, confidence = self.classifier.classify(parsed)

        # Classifier reads from parsed['full_text']
        # (classifier.py:301-318)
```

### Step 3: Text Content Extraction (compliance_extractor.py:292-309)

```python
def _extract_text_content(self, file_data: Dict) -> str:
    """Used by all extractors to get text for processing"""
    content_parts = []

    if 'data' in file_data:
        data = file_data['data']

        # Excel files: iterate through sheets
        if isinstance(data, dict):
            for sheet_name, sheet_data in data.items():
                if 'raw_data' in sheet_data:
                    for row in sheet_data['raw_data']:
                        content_parts.append(str(row))

        # PDF/Word files: use full_text
        elif isinstance(data, str):
            content_parts.append(data)

    return ' '.join(content_parts)
```

### Step 4: Storage Metadata (schema_mapper.py:74)

```python
'building_documents': {
    'id': 'uuid',
    'building_id': 'uuid',
    'file_name': 'text',
    'storage_path': 'text',
    'category': 'text',
    'ocr_text': 'text',  # ← RESERVED, currently unused
    'processing_status': 'text',
    'confidence_level': 'text',
    'metadata': 'jsonb',
    'created_at': 'timestamp'
}
```

**Note:** The `ocr_text` column exists in the schema but is **never populated** by the current implementation.

---

## 4. OCR Response Shape (If It Existed)

### Current Parsed Data Structure

The onboarder currently produces this structure from `parse_file()`:

```typescript
{
  // File metadata
  file_name: string,
  file_path: string,
  file_type: string,        // e.g., '.pdf', '.xlsx'
  file_size: number,        // bytes
  parsed_at: string,        // ISO timestamp

  // Text content (from native extraction, NOT OCR)
  full_text?: string,       // Complete extracted text
  text_content?: Array<{    // Page-by-page breakdown
    page: number,
    text: string
  }>,

  // Structured data (Excel only)
  data?: {
    [sheetName: string]: {
      rows: number,
      columns: string[],
      raw_data: Array<Record<string, any>>
    }
  },

  // Tables (PDF only)
  tables?: Array<{
    page: number,
    table: number,
    data: any[][]
  }>,

  // Word documents
  paragraphs?: string[],

  // Parse status
  parsed: boolean,
  error?: string
}
```

### Hypothetical OCR Response (Google Vision API)

If OCR were integrated, the response would likely look like:

```typescript
{
  // File identification
  file_name: string,
  file_url: string,

  // OCR results
  text: string,              // Complete OCR text
  confidence: number,        // 0.0 - 1.0

  // Page-level results
  pages: Array<{
    page_number: number,
    text: string,
    confidence: number,
    blocks?: Array<{        // Text block detection
      text: string,
      confidence: number,
      bounding_box: {
        x: number,
        y: number,
        width: number,
        height: number
      }
    }>
  }>,

  // Metadata
  language: string,
  processing_time_ms: number,
  api_version: string
}
```

---

## 5. Comparison: Current vs. Potential OCR Integration

### Current Native Text Extraction

**Advantages:**
- ✅ No API costs
- ✅ No network latency
- ✅ Works offline
- ✅ No API rate limits
- ✅ Immediate processing
- ✅ No credentials management

**Limitations:**
- ❌ Cannot process scanned PDFs (images)
- ❌ Cannot read handwritten text
- ❌ Cannot extract text from images/screenshots
- ❌ Fails on PDFs without text layer
- ❌ No OCR confidence scoring

### Potential OCR Integration (Google Vision API)

**Advantages:**
- ✅ Can process scanned documents
- ✅ Handles image-based PDFs
- ✅ Reads handwritten text
- ✅ Language detection
- ✅ Confidence scoring per word/block
- ✅ Advanced layout analysis

**Challenges:**
- ❌ API costs per document
- ❌ Requires network connectivity
- ❌ Rate limiting (quotas)
- ❌ Credential management complexity
- ❌ Processing latency (upload + OCR time)
- ❌ Privacy concerns (data sent to Google)

---

## 6. Integration Points (If OCR Were Added)

### Where OCR Would Fit

```python
# parsers.py - Enhanced PDF parser
class PDFParser(FileParser):
    def parse(self) -> Dict[str, Any]:
        # Try native text extraction first
        result = self._parse_with_pdfplumber()

        # NEW: If no text found, use OCR
        if not result['full_text'].strip():
            ocr_result = self._ocr_with_google_vision()
            result['full_text'] = ocr_result['text']
            result['ocr_confidence'] = ocr_result['confidence']
            result['ocr_used'] = True

        return result

    def _ocr_with_google_vision(self) -> Dict:
        """NEW: Google Vision API integration"""
        from google.cloud import vision

        client = vision.ImageAnnotatorClient()

        with open(self.file_path, 'rb') as f:
            content = f.read()

        image = vision.Image(content=content)
        response = client.document_text_detection(image=image)

        return {
            'text': response.full_text_annotation.text,
            'confidence': response.full_text_annotation.pages[0].confidence,
            'pages': [...]
        }
```

### Required Changes

1. **Add dependencies to `requirements.txt`:**
   ```
   google-cloud-vision>=3.4.0
   ```

2. **Environment variables (`.env.local`):**
   ```bash
   GOOGLE_APPLICATION_CREDENTIALS=/path/to/service-account-key.json
   GOOGLE_VISION_API_KEY=...
   ```

3. **Update schema mapper to store OCR text:**
   ```python
   # schema_mapper.py - map_building_documents()
   doc_record = {
       # ... existing fields ...
       'ocr_text': parsed_data.get('full_text') if parsed_data.get('ocr_used') else None,
       'processing_status': 'ocr_completed' if parsed_data.get('ocr_used') else 'native_parse',
       'confidence_level': str(parsed_data.get('ocr_confidence')) if parsed_data.get('ocr_used') else None
   }
   ```

4. **Add OCR fallback logic in `onboarder.py`:**
   ```python
   def _parse_all_files(self):
       for file_path in self.client_folder.rglob('*'):
           parsed = parse_file(str(file_path))

           # Check if OCR is needed
           if not parsed.get('full_text') and file_path.suffix == '.pdf':
               print(f"  ⚠️  No text found in {file_path.name}, triggering OCR...")
               parsed = self._ocr_pdf(file_path)

           self.parsed_files.append(parsed)
   ```

---

## 7. Current File Structure

### Key Files

| File | Purpose | OCR Related? |
|------|---------|--------------|
| `parsers.py` | Native text extraction from PDFs/Excel/Word | No OCR used |
| `classifier.py` | Document categorization using extracted text | Reads `full_text` |
| `compliance_extractor.py` | Extract compliance data from text | Uses `_extract_text_content()` |
| `financial_extractor.py` | Extract financial data | Uses `_extract_text_content()` |
| `major_works_extractor.py` | Extract major works data | Uses `_extract_text_content()` |
| `schema_mapper.py` | Map to Supabase schema | Has `ocr_text` column (unused) |
| `storage_uploader.py` | Upload files to Supabase Storage | No OCR integration |
| `requirements.txt` | Python dependencies | No Google Vision or OCR libs |

---

## 8. Recommendations

### Current State is Sufficient For:
- ✅ Modern digital PDFs with embedded text
- ✅ Excel spreadsheets
- ✅ Word documents
- ✅ CSV files
- ✅ Documents created by software (not scanned)

### OCR Integration Would Be Needed For:
- 📄 Scanned paper documents
- 📄 Image-based PDFs (photos of documents)
- 📄 Handwritten forms
- 📄 Legacy documents without text layers
- 📄 Screenshots of documents

### Suggested Approach:
1. **Monitor parsing failures** - Track how many PDFs return empty `full_text`
2. **Implement hybrid approach** - Try native extraction first, fallback to OCR only when needed
3. **Add OCR as optional feature** - Use environment variable flag to enable/disable
4. **Cost optimization** - Only OCR documents that fail native extraction

---

## 9. Historical Context

Based on the codebase search:
- **No evidence of previous OCR microservice** in current codebase
- **No Render/FastAPI OCR endpoints** found
- **No Google Vision imports** in any files
- **No OCR configuration files** or service account keys
- **`ocr_text` column exists** in schema but is always NULL

**Conclusion:** Either:
1. OCR was planned but never implemented
2. OCR existed in a previous version (now removed)
3. OCR is handled by a separate service/repo not present here

---

## 10. Summary Table

| Aspect | Current Implementation | OCR Integration (If Added) |
|--------|----------------------|---------------------------|
| **PDF Text Extraction** | `pdfplumber` (native layers only) | Google Vision API (image OCR) |
| **Excel Parsing** | `openpyxl`/`pandas` (cell values) | N/A (Excel not image-based) |
| **Word Parsing** | `python-docx` (paragraph text) | N/A (Word not image-based) |
| **API Calls** | None | Google Vision REST/gRPC |
| **Credentials** | None required | Service account JSON key |
| **Cost** | $0 | ~$1.50 per 1000 pages |
| **Latency** | <100ms per file | 2-5s per page |
| **Works Offline** | Yes | No |
| **Scanned PDFs** | ❌ Fails | ✅ Works |
| **Dependencies** | 6 Python libs | +2 (google-cloud-vision, google-auth) |
| **Database Storage** | `ocr_text` = NULL | `ocr_text` = extracted text |

---

## Conclusion

**The BlocIQ Onboarder does not currently use OCR.** All text extraction is performed using native Python libraries that read the embedded text from digital documents. While the database schema includes an `ocr_text` column, it is never populated by the current implementation.

For the vast majority of property management documents (Excel budgets, digital PDFs, Word documents), the current approach is sufficient and cost-effective. OCR integration would only be beneficial if clients frequently provide scanned paper documents or image-based PDFs.
