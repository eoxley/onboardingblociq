# 🧠 Building Knowledge System

## Overview

The Building Knowledge system enhances the existing `building_keys_access` table to store practical building information beyond just access codes:

- 🔑 **Access**: Gate codes, entrance codes, key locations
- ⚡ **Utilities**: Stopcock location, meter locations
- 🚨 **Safety**: Alarm panels, fire assembly points (future)
- 🧾 **General**: Bin store, bike store, general notes

## Database Schema Enhancement

### What Changed

Added 3 new columns to `building_keys_access` table:
- `category` - Logical grouping: `access`, `utilities`, `safety`, `general`
- `label` - Human-readable UI label (e.g., "Front Gate Code", "Stopcock")
- `visibility` - Who can view: `team`, `directors`, `contractors`

### Existing Columns (unchanged)
- `access_type` - Legacy type field (now mapped to category)
- `code` - Access codes (e.g., "4829#")
- `location` - Physical locations (e.g., "Boiler room cupboard to the left")
- `description` - Additional descriptive text
- `notes` - General notes

## Installation

### Step 1: Run SQL Migration

```bash
psql -d your_supabase_db < BUILDING_KNOWLEDGE_MIGRATION.sql
```

Or copy/paste the contents into Supabase SQL Editor.

### Step 2: Verify Migration

```sql
SELECT * FROM building_keys_access LIMIT 5;

-- Should show new columns: category, label, visibility
```

## Usage in Onboarding Generator

The Python onboarder (`schema_mapper.py`) automatically extracts building knowledge from property forms:

### Extracted Fields

From property information forms, the onboarder now extracts:

| Field Name | Category | Label | Stored As |
|------------|----------|-------|-----------|
| Gate Codes | `access` | "Gate Codes" | `code` |
| Entrance Codes | `access` | "Entrance Codes" | `code` |
| Stopcock Location | `utilities` | "Stopcock" | `location` |
| Gas Meter Location | `utilities` | "Gas Meter" | `location` |
| Electric Meter | `utilities` | "Electric Meter" | `location` |
| Bin Store | `general` | "Bin Store Access" | `description` |
| Bike Store | `general` | "Bike Store Access" | `description` |

### Example Property Form Input

```
Property Information Form:
- Gate Codes: 4829#
- Location of Stopcock: Boiler room cupboard to the left
- Electric Meter Location: Ground floor utility cupboard
```

### Generated SQL Output

```sql
INSERT INTO building_keys_access (
    id, building_id, access_type, category, label, code, location, visibility
) VALUES
    (
        '...',
        'building-uuid-here',
        'gate_codes',
        'access',
        'Gate Codes',
        '4829#',
        NULL,
        'contractors'
    ),
    (
        '...',
        'building-uuid-here',
        'stopcock',
        'utilities',
        'Stopcock',
        NULL,
        'Boiler room cupboard to the left',
        'team'
    ),
    (
        '...',
        'building-uuid-here',
        'electric_meter',
        'utilities',
        'Electric Meter',
        NULL,
        'Ground floor utility cupboard',
        'team'
    );
```

## Example Queries

### Get all knowledge for a building

```sql
SELECT category, label, code, location, description
FROM building_keys_access
WHERE building_id = 'your-building-uuid'
ORDER BY category, label;
```

### Get only access codes (for contractors)

```sql
SELECT label, code
FROM building_keys_access
WHERE building_id = 'your-building-uuid'
  AND category = 'access'
  AND visibility IN ('contractors', 'team');
```

### Get utility locations

```sql
SELECT label, location
FROM building_keys_access
WHERE building_id = 'your-building-uuid'
  AND category = 'utilities';
```

### Search across all knowledge

```sql
SELECT category, label, code, location, description
FROM building_keys_access
WHERE building_id = 'your-building-uuid'
  AND (
    label ILIKE '%stopcock%'
    OR location ILIKE '%stopcock%'
    OR description ILIKE '%stopcock%'
  );
```

## Adding New Knowledge Types

### In Schema Mapper

Edit `BlocIQ_Onboarder/schema_mapper.py` line ~1729:

```python
knowledge_types = [
    # ... existing entries ...

    # Add new type:
    ('alarm_panel', ['alarm panel location'], 'safety', 'Alarm Panel', 'team', False, True),
    #   ^             ^                         ^         ^              ^       ^      ^
    #   access_type   keywords to search       category  UI label      visibility code? location?
]
```

### Parameters Explained

- `access_type` - Internal identifier (snake_case)
- `keywords` - List of keywords to search in property form
- `category` - Logical grouping (`access`, `utilities`, `safety`, `general`)
- `label` - Human-readable label shown in UI
- `visibility` - Default visibility (`team`, `directors`, `contractors`)
- `is_code` - `True` if value should be stored in `code` column
- `is_location` - `True` if value should be stored in `location` column

## Frontend Integration

### ContextRibbon UI (Future)

The enhanced schema supports building a "🧠 Building Info" panel:

```typescript
// Fetch knowledge grouped by category
const knowledge = await fetch(`/api/building-knowledge?buildingId=${buildingId}`)

// Display by category
{
  "access": [
    { "label": "Gate Codes", "code": "4829#", "visibility": "contractors" }
  ],
  "utilities": [
    { "label": "Stopcock", "location": "Boiler room cupboard to the left" }
  ],
  "general": [
    { "label": "Bin Store Access", "description": "Contact office for key" }
  ]
}
```

### Ask BlocIQ Integration (Future)

Query examples:
- "Where's the stopcock at Connaught Square?" → Returns location from DB
- "What's the gate code?" → Returns code (with visibility check)
- "Update gate code to 1234#" → Updates `code` field

## Testing

### Test with Sample Data

```sql
-- Insert test data
INSERT INTO building_keys_access (building_id, category, access_type, label, code, location, visibility)
VALUES
    (
        (SELECT id FROM buildings LIMIT 1),
        'access',
        'gate_codes',
        'Front Gate Code',
        '4829#',
        NULL,
        'contractors'
    ),
    (
        (SELECT id FROM buildings LIMIT 1),
        'utilities',
        'stopcock',
        'Stopcock',
        NULL,
        'Boiler room cupboard to the left',
        'team'
    );

-- Verify
SELECT * FROM building_keys_access WHERE category IS NOT NULL;
```

### Run Onboarding Test

```bash
# Run onboarding on a test building with property form
python BlocIQ_Onboarder/onboarder.py "/path/to/test/building/"

# Check generated SQL
cat BlocIQ_Onboarder/output/migration.sql | grep "building_keys_access"

# Should see:
# INSERT INTO building_keys_access (... category, label, code, location, visibility ...)
```

## Visibility Levels

| Level | Who Can View | Use Case |
|-------|--------------|----------|
| `team` | Internal BlocIQ staff | Internal building info (stopcock, meters) |
| `directors` | Building directors + BlocIQ | Sensitive info (financials, contracts) |
| `contractors` | External contractors | Access codes they need for work |

## Migration from Legacy Data

Existing `building_keys_access` records are automatically migrated:

```sql
UPDATE building_keys_access
SET
  category = CASE
    WHEN access_type IN ('labelled_keys', 'gate_codes', 'entrance_codes') THEN 'access'
    WHEN access_type IN ('bin_store', 'bike_store') THEN 'general'
    ELSE 'access'
  END,
  label = CASE
    WHEN access_type = 'labelled_keys' THEN 'Keys'
    WHEN access_type = 'gate_codes' THEN 'Gate Codes'
    ...
  END,
  visibility = 'team'
WHERE category IS NULL;
```

## Summary

✅ Enhances existing `building_keys_access` table (no new tables)
✅ Backwards compatible (legacy `access_type` still works)
✅ Auto-populated by onboarding generator from property forms
✅ Ready for ContextRibbon UI and Ask BlocIQ integration
✅ Supports visibility controls for security
✅ Searchable and queryable

---

**Next Steps:**
1. Run `BUILDING_KNOWLEDGE_MIGRATION.sql` in Supabase
2. Re-run onboarding on existing buildings with property forms
3. Verify data in Supabase console
4. Build ContextRibbon UI panel (frontend repo)
5. Integrate with Ask BlocIQ chat (AI context)
