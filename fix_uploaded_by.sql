-- Make uploaded_by column nullable in documents table
ALTER TABLE documents ALTER COLUMN uploaded_by DROP NOT NULL;

SELECT '✅ uploaded_by is now nullable' as result;
