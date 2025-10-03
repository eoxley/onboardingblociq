# BlocIQ Onboarding Guidance

## How to Delete a Building and All Related Data

If you need to remove a building due to a corrupt SQL run or incorrect data import, use this script to cleanly delete the building and all its related records.

### Delete Building Script

```sql
DO $$
DECLARE
    v_building_id uuid := 'YOUR-BUILDING-ID-HERE'; -- CHANGE THIS to your building ID
BEGIN
    -- Delete in order of dependencies (children first, then parents)

    -- 1. Delete compliance inspections (references compliance_assets)
    DELETE FROM compliance_inspections WHERE building_id = v_building_id;
    RAISE NOTICE 'Deleted compliance_inspections';

    -- 2. Delete compliance assets (references building)
    DELETE FROM compliance_assets WHERE building_id = v_building_id;
    RAISE NOTICE 'Deleted compliance_assets';

    -- 3. Delete major works projects (references building)
    DELETE FROM major_works_projects WHERE building_id = v_building_id;
    RAISE NOTICE 'Deleted major_works_projects';

    -- 4. Delete leaseholders (references units)
    DELETE FROM leaseholders WHERE unit_id IN (
        SELECT id FROM units WHERE building_id = v_building_id
    );
    RAISE NOTICE 'Deleted leaseholders';

    -- 5. Delete units (references building)
    DELETE FROM units WHERE building_id = v_building_id;
    RAISE NOTICE 'Deleted units';

    -- 6. Delete building documents (references building)
    DELETE FROM building_documents WHERE building_id = v_building_id;
    RAISE NOTICE 'Deleted building_documents';

    -- 7. Finally delete the building
    DELETE FROM buildings WHERE id = v_building_id;
    RAISE NOTICE 'Deleted building';

    RAISE NOTICE 'All data for building % deleted successfully', v_building_id;
END $$;
```

### How to Use

1. Find your building ID from the Supabase `buildings` table
2. Replace `'YOUR-BUILDING-ID-HERE'` with your actual building UUID
3. Run the script in Supabase SQL Editor
4. Check the notifications to confirm all deletions

### Example

```sql
DO $$
DECLARE
    v_building_id uuid := '93c82651-4c34-4461-976f-660c20b52bc8';
BEGIN
    -- ... rest of script
END $$;
```

### Preview Before Deleting

If you want to see what will be deleted first without actually deleting:

```sql
DO $$
DECLARE
    v_building_id uuid := 'YOUR-BUILDING-ID-HERE'; -- CHANGE THIS
    v_count integer;
BEGIN
    SELECT COUNT(*) INTO v_count FROM compliance_inspections WHERE building_id = v_building_id;
    RAISE NOTICE 'compliance_inspections: % records', v_count;

    SELECT COUNT(*) INTO v_count FROM compliance_assets WHERE building_id = v_building_id;
    RAISE NOTICE 'compliance_assets: % records', v_count;

    SELECT COUNT(*) INTO v_count FROM major_works_projects WHERE building_id = v_building_id;
    RAISE NOTICE 'major_works_projects: % records', v_count;

    SELECT COUNT(*) INTO v_count FROM leaseholders WHERE unit_id IN (SELECT id FROM units WHERE building_id = v_building_id);
    RAISE NOTICE 'leaseholders: % records', v_count;

    SELECT COUNT(*) INTO v_count FROM units WHERE building_id = v_building_id;
    RAISE NOTICE 'units: % records', v_count;

    SELECT COUNT(*) INTO v_count FROM building_documents WHERE building_id = v_building_id;
    RAISE NOTICE 'building_documents: % records', v_count;

    RAISE NOTICE 'Total records that would be deleted (excluding building itself)';
END $$;
```

## Common Issues and Solutions

### Issue: Foreign Key Constraint Error

**Error Message:**
```
Unable to delete row as it is currently referenced by a foreign key constraint from the table compliance_assets
```

**Solution:** Use the deletion script above. It deletes all dependent records in the correct order before deleting the building.

### Issue: Building Name Extracted Incorrectly

**Problem:** Building imported with name "Important" instead of actual building name.

**Solution:**
1. Delete the corrupt building using the script above
2. Re-run the onboarding with explicit building name:
   ```bash
   python3 onboarder.py "/path/to/folder" --building-name "Actual Building Name"
   ```
3. Or use the desktop app and fill in the building name field

The latest version of the onboarder now automatically extracts building names from folder names (e.g., "219.01 CONNAUGHT SQUARE" → "Connaught Square").

## Best Practices

1. **Always preview before deleting** - Run the preview script to see what will be affected
2. **Verify building ID** - Double-check you have the correct building UUID before running deletion
3. **Keep backups** - The onboarder automatically creates backups in `output/client-backup/`
4. **Test migrations** - Review `output/migration.sql` before executing in Supabase
5. **Use explicit building names** - When in doubt, provide `--building-name` to avoid extraction errors
