-- Make uploaded_by nullable so document vault can upload without user ID
ALTER TABLE documents ALTER COLUMN uploaded_by DROP NOT NULL;

-- Set a default value for future uploads
ALTER TABLE documents ALTER COLUMN uploaded_by SET DEFAULT 'system';

SELECT '✅ uploaded_by column is now nullable with default "system"' as result;
