#!/bin/bash
#
# Test SQL migration against local PostgreSQL to find exact errors
# This will show the same errors Supabase would show
#

set -e

SQL_FILE="/Users/ellie/Desktop/BlocIQ_Output/migration.sql"
DB_NAME="blociq_test"
PSQL_CMD="/opt/homebrew/Cellar/postgresql@15/15.14/bin/psql"

echo "============================================================"
echo "PostgreSQL SQL Validation Test"
echo "============================================================"
echo

# Create test database (drop if exists)
echo "1. Creating test database..."
$PSQL_CMD -U postgres -c "DROP DATABASE IF EXISTS $DB_NAME;" 2>/dev/null || true
$PSQL_CMD -U postgres -c "CREATE DATABASE $DB_NAME;"
echo "   ✓ Test database created"
echo

# Run SQL and capture errors
echo "2. Executing migration SQL..."
echo "   (Errors will be shown below)"
echo
echo "-----------------------------------------------------------"

if $PSQL_CMD -U postgres -d $DB_NAME -f "$SQL_FILE" 2>&1 | tee /tmp/psql_output.log; then
    echo "-----------------------------------------------------------"
    echo
    echo "✅ SQL executed successfully!"
    exit 0
else
    ERROR_CODE=$?
    echo "-----------------------------------------------------------"
    echo
    echo "❌ SQL execution failed with error code $ERROR_CODE"
    echo
    echo "First error found:"
    grep -i "error\|failed\|syntax" /tmp/psql_output.log | head -5
    exit 1
fi
