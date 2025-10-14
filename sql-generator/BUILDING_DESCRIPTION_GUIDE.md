# Building Description Extraction - Complete Guide

## 🎯 Overview

The Building Description Extractor automatically detects and standardizes descriptive building data from any technical or compliance document to populate comprehensive building profile information.

## 📊 Extracted Fields

### Core Building Information

| Field | Description | Example |
|-------|-------------|---------|
| `building_description` | Narrative text describing age, construction, structure | "Converted Victorian terrace, 4 storeys with basement, traditional masonry walls and timber floors" |
| `building_age_or_type` | Classification (Victorian, Post-war, New build, etc.) | "Victorian Conversion" |
| `num_floors` | Height in floors (including basement/roof) | 8 |
| `num_blocks_or_cores` | Number of blocks or cores referenced | 4 |
| `num_lifts` | Total lift count (if any) | 9 |

### Access & Facilities

| Field | Description | Example |
|-------|-------------|---------|
| `access_details` | Key info on site entry / fire access / gated / concierge | "Main access via coded pedestrian gate on Queensway; vehicular via service road" |
| `parking_arrangements` | Resident / visitor / underground / none | "Undercroft car park with 25 bays" |
| `amenities` | List of shared features | ["Gym", "Concierge", "Bike Store", "Roof Terrace"] |

### Technical Details

| Field | Description | Example |
|-------|-------------|---------|
| `construction_materials` | Keywords from FRA or EWS | ["Brick", "Concrete Frame", "Timber Floors"] |
| `heating_system` | From mechanical sections | "Central boiler with individual HIUs" |
| `cladding_or_ews_status` | From EWS1 / FRAEW | "No combustible cladding present" |
| `fire_strategy` | Fire evacuation strategy | "Stay Put" |

## 📚 Source Documents

The extractor analyzes multiple document types to build a complete picture:

| Document Type | Information Extracted |
|--------------|----------------------|
| **FRA / HSFRA** | Full building narrative, fire strategy, floors, access |
| **EWS1 / FRAEW** | Cladding status, height, cores, external wall system |
| **Asbestos Reports** | Age of building, construction materials |
| **Insurance Valuation** | Year built, construction type, floor area |
| **Budget** | Notes about blocks, lifts, or cores |
| **H&S Audits** | Access, parking, services |
| **Concierge / Welcome Pack** | Amenities, parking, fob systems |

## 🧠 Extraction Logic

### 1. Building Description Text

**Patterns Detected:**
- "Description of Premises"
- "The building comprises"
- "The property consists of"

**Logic:**
- Extracts 1-3 sentence summaries
- Prioritizes FRA documents
- Chooses longest unique description if multiple found

**Example Match:**
```
Description of Premises:
Converted Victorian terrace building comprising 4 storeys with basement.
The building features traditional masonry walls and timber floors throughout.
```

### 2. Building Age / Type

**Regex Patterns:**
```regex
(?i)(victorian|georgian|edwardian|post-war|new build|modern|converted)
```

**Inference Rules:**
- If compliance docs <15 years old → "Modern / New Build"
- If mentions "original timber floors" → "Pre-1970s / Conversion"
- By construction year:
  - <1900 → "Victorian/Georgian"
  - 1900-1945 → "Pre-War"
  - 1945-1970 → "Post-War"
  - 1970-2000 → "Late 20th Century"
  - >2000 → "Modern/New Build"

### 3. Construction Materials

**Keywords Detected:**
- Brick, Masonry, Concrete, Timber, Steel
- Cladding, Render, Insulated Panel
- ACM, HPL, Stone, Glass, Aluminium

**Logic:**
- Scans all documents for material keywords
- Counts occurrences
- Returns deduplicated, sorted list

### 4. Numeric Counts (Floors/Blocks/Cores/Lifts)

**Patterns:**
```regex
(\d+)\s*(storey|floor|floors|levels)
(\d+)\s*(blocks?|cores?)
(\d+)\s*(lift|elevator)s?
```

**Number Word Conversion:**
- "four cores" → 4
- "nine lifts" → 9
- "eight floors" → 8

**Heuristics:**
- If multiple values found, picks maximum
- Handles phrases like "four cores and nine lifts"

### 5. Access Details

**Patterns:**
```regex
access\s*(to|via|from)\s*[A-Z].+
(pedestrian|vehicular|fire access|service road|gated|concierge)
```

**Logic:**
- Extracts paragraph around "access" keyword
- Captures 20-200 characters of context
- Limits to 300 characters total

### 6. Parking Arrangements

**Patterns:**
```regex
(parking|car park)\s*(available|provided|underground|basement|on street|none)
```

**Classification:**
- "Underground" → "Underground parking"
- "Basement" → "Basement parking"
- "On-street" or "none" → "No parking provided"

### 7. Amenities

**Keywords Detected:**
- gym, concierge, garden
- bike store, bicycle storage
- communal terrace, residents lounge
- pool, swimming pool
- lift, elevator
- fob access, CCTV, security
- roof terrace, parking
- storage, post room, meeting room, cinema room

**Logic:**
- Builds set of unique amenities found
- Returns sorted list
- Normalizes naming (title case)

### 8. Heating System

**Patterns:**
```regex
heating\s*(system|is|:)\s*(.+)
(?:central|communal)\s*(?:boiler|heating)
(?:HIU|heat interface unit)s?
```

**Example Matches:**
- "Central boiler with individual HIUs"
- "District heating via HIUs"
- "Gas fired central heating"

### 9. Cladding / EWS Status

**Patterns:**
```regex
(?:no )?combustible cladding
EWS1?\s*(?:form|certificate)
external wall system
cladding
```

**Example Matches:**
- "No combustible cladding present"
- "EWS1 form issued - compliant"
- "External wall system: non-combustible"

### 10. Fire Strategy

**Patterns:**
- "Stay Put" → Stay Put
- "Simultaneous Evacuation" → Simultaneous Evacuation
- "Phased Evacuation" → Phased Evacuation
- "Progressive Horizontal Evacuation" → Progressive Horizontal Evacuation

## 🧮 Confidence Scoring

The extractor calculates a confidence score based on signals:

| Signal | Weight | Description |
|--------|--------|-------------|
| Description paragraph found | +0.4 | High-quality narrative text extracted |
| Numeric counts detected | +0.2 | Floors, lifts, cores, or blocks found |
| Materials found | +0.2 | Construction materials identified |
| Access or parking mentions | +0.2 | Access/parking details extracted |

**Confidence Levels:**
- ≥0.7 → "Reliable Description"
- 0.4-0.6 → "Partial Information"
- <0.4 → "Limited Data"

## 📤 Output Structure

### JSON Format

```json
{
  "building_description": "Converted Victorian terrace, 4 storeys with basement, traditional masonry walls and timber floors.",
  "building_age_or_type": "Victorian Conversion",
  "num_floors": 8,
  "num_blocks_or_cores": 4,
  "num_lifts": 9,
  "access_details": "Main access via coded pedestrian gate on Queensway; vehicular via service road.",
  "parking_arrangements": "Undercroft car park with 25 bays.",
  "amenities": ["Concierge", "Bike Store", "Roof Terrace", "Gym"],
  "construction_materials": ["Brick", "Timber Floors", "Concrete Frame"],
  "heating_system": "Central boiler with individual HIUs",
  "cladding_or_ews_status": "No combustible cladding present",
  "fire_strategy": "Stay Put",
  "confidence": 1.0
}
```

## 🔧 Implementation Details

### Module Architecture

The `BuildingDescriptionExtractor` class:
- Processes **all documents in a folder** (not per-file)
- Aggregates data from multiple sources
- Uses majority voting for conflicts
- Selects best/longest descriptions

### Integration with Main Pipeline

```python
# In main.py
building_extractor = BuildingDescriptionExtractor()

# Prepare documents with text
docs_for_building = [
    {'text': doc_text, 'document_type': doc_type}
    for each document
]

# Extract building profile
building_profile = building_extractor.extract_from_documents(docs_for_building)

# Include in JSON output
report = {
    'building_profile': building_profile,
    'documents': documents,
    ...
}
```

### Key Methods

1. **`extract_from_documents(documents)`**
   - Main entry point
   - Processes all documents
   - Returns complete building profile

2. **`_extract_description(text, doc_type)`**
   - Extracts narrative description
   - Prioritizes FRA documents

3. **`_extract_age_type(text)`**
   - Determines building age/type
   - Infers from construction year if needed

4. **`_extract_materials(text)`**
   - Finds construction materials
   - Returns deduplicated list

5. **`_extract_floors/blocks/cores/lifts(text)`**
   - Extracts numeric counts
   - Converts number words to digits

6. **`_calculate_confidence(signals)`**
   - Computes confidence score
   - Based on data quality signals

## 📋 Usage Examples

### Basic Usage

```python
from extractor_building_description import BuildingDescriptionExtractor

extractor = BuildingDescriptionExtractor()

documents = [
    {'text': fra_text, 'document_type': 'FRA'},
    {'text': ews_text, 'document_type': 'EWS1'},
    {'text': insurance_text, 'document_type': 'Insurance'}
]

building_profile = extractor.extract_from_documents(documents)

print(f"Building: {building_profile['building_age_or_type']}")
print(f"Floors: {building_profile['num_floors']}")
print(f"Amenities: {building_profile['amenities']}")
```

### In SQL Generator Pipeline

The extractor is automatically invoked by `main.py`:

```bash
python main.py /path/to/building/folder --building-name "Connaught Square"
```

Output includes building profile in `{building}_metadata.json`.

## 🎯 Accuracy Tips

### To Improve Extraction Quality

1. **Include FRA Documents**
   - FRAs typically have "Description of Premises" sections
   - Highest priority for building descriptions

2. **Add Multiple Sources**
   - More documents = better data aggregation
   - Cross-validation from multiple sources

3. **Use Structured Documents**
   - Insurance valuations often have year built
   - EWS forms have standardized cladding info

4. **Include Building Handover Packs**
   - Concierge guides list amenities
   - Welcome packs describe facilities

### Common Issues & Solutions

| Issue | Solution |
|-------|----------|
| No description found | Ensure FRA or comprehensive report included |
| Wrong floor count | Check for basement/roof mentions in text |
| Missing amenities | Include resident handbooks or brochures |
| Low confidence | Add more document types to folder |

## 🔄 Aggregation Strategy

When multiple documents provide conflicting data:

1. **Descriptions**: Choose longest from highest-priority document (FRA > EICR > others)
2. **Numeric Counts**: Select maximum value found
3. **Text Fields**: Choose longest unique text
4. **Lists (Amenities/Materials)**: Combine all unique items
5. **Type/Strategy**: Use most common value (majority vote)

## 📊 Example Real-World Extraction

### Input Documents
- FRA: "Victorian conversion, 8 floors including basement"
- EWS1: "No ACM cladding, concrete frame with brick facade"
- Insurance: "Built circa 1890, Victorian terrace"
- Budget: "4 cores, 9 passenger lifts"

### Extracted Profile
```json
{
  "building_description": "Victorian conversion comprising 8 floors including basement",
  "building_age_or_type": "Victorian Conversion",
  "num_floors": 8,
  "num_blocks_or_cores": 4,
  "num_lifts": 9,
  "construction_materials": ["Brick", "Concrete Frame"],
  "cladding_or_ews_status": "No ACM cladding",
  "confidence": 0.8
}
```

## 🚀 Future Enhancements

### Planned Features
1. Gross floor area extraction (GFA)
2. Year built extraction
3. Number of units/flats
4. Site boundaries description
5. Planning restrictions
6. Listed building status
7. Conservation area info

### ML Integration
- Train classifier for building types
- Pattern learning for rare amenities
- Contextual extraction improvements

## 📝 Testing

### Run Module Tests

```bash
python extractor_building_description.py
```

### Test with Sample Data

```python
test_docs = [
    {
        'text': "FRA Report: Victorian building with 4 cores and 9 lifts",
        'document_type': 'FRA'
    }
]

result = extractor.extract_from_documents(test_docs)
print(result)
```

## 📖 Related Documentation

- `README.md` - Main SQL Generator documentation
- `QUICKSTART.md` - Quick start guide
- `IMPLEMENTATION_SUMMARY.md` - Full implementation details

## 🎓 Technical Notes

### Performance
- Processes all documents once
- Efficient regex pattern matching
- Minimal memory overhead

### Extensibility
- Easy to add new patterns
- Configurable keyword lists
- Modular extraction methods

### Reliability
- Handles missing data gracefully
- Aggregates from multiple sources
- Returns confidence scores

---

**Module:** `extractor_building_description.py`
**Integration:** Automatically included in `main.py` pipeline
**Output:** Included in `{building}_metadata.json` under `building_profile`
