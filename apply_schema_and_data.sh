#!/bin/bash
# ============================================================================
# Apply Complete Schema and Connaught Data to Supabase
# ============================================================================

echo ""
echo "================================================================================"
echo "🚀 BlocIQ - Apply Complete Schema & Data to Supabase"
echo "================================================================================"
echo ""

# Check if pbcopy is available
if ! command -v pbcopy &> /dev/null; then
    echo "❌ pbcopy not found (required for clipboard copy)"
    echo "   This script works on macOS. On Linux, use xclip instead."
    exit 1
fi

# File paths
SCHEMA_FILE="/Users/ellie/onboardingblociq/supabase_schema.sql"
DATA_FILE="/Users/ellie/onboardingblociq/output/connaught_COMPLETE.sql"
SUPABASE_URL="https://supabase.com/dashboard/project/xqxaatvykmaaynqeoemy/sql/new"

echo "📋 Files to apply:"
echo "   1. Schema: supabase_schema.sql (1,153 lines, 21 tables)"
echo "   2. Data: connaught_COMPLETE.sql (2,175 lines, 108 INSERTs)"
echo ""

# Step 1: Schema
echo "================================================================================"
echo "📄 STEP 1: Apply Schema (Creates 21 tables)"
echo "================================================================================"
echo ""
echo "Copying schema to clipboard..."
cat "$SCHEMA_FILE" | pbcopy
echo "✅ Schema copied to clipboard!"
echo ""
echo "📋 Next:"
echo "   1. Opening Supabase SQL Editor in browser..."
sleep 2
open "$SUPABASE_URL"
echo "   2. PASTE (Cmd+V) the schema SQL"
echo "   3. Click 'Run' button (bottom right)"
echo "   4. Wait for 'Success. No rows returned'"
echo ""
read -p "Press ENTER when schema is applied and you're ready for Step 2..."
echo ""

# Step 2: Data
echo "================================================================================"
echo "📄 STEP 2: Load Connaught Square Data (108 INSERTs)"
echo "================================================================================"
echo ""
echo "Copying Connaught data to clipboard..."
cat "$DATA_FILE" | pbcopy
echo "✅ Connaught data copied to clipboard!"
echo ""
echo "📋 Next:"
echo "   1. In the SAME Supabase SQL Editor tab"
echo "   2. CLEAR the previous query"
echo "   3. PASTE (Cmd+V) the Connaught data SQL"
echo "   4. Click 'Run' button (bottom right)"
echo "   5. Wait for 'Success. No rows returned'"
echo ""
read -p "Press ENTER when data is loaded..."
echo ""

# Verification
echo "================================================================================"
echo "✅ VERIFICATION"
echo "================================================================================"
echo ""
echo "Run this query in Supabase SQL Editor to verify:"
echo ""
cat << 'EOF'
SELECT 
    (SELECT COUNT(*) FROM buildings) as buildings,
    (SELECT COUNT(*) FROM units) as units,
    (SELECT COUNT(*) FROM budget_line_items) as budget_items,
    (SELECT COUNT(*) FROM insurance_policies) as insurance,
    (SELECT COUNT(*) FROM leases) as leases,
    (SELECT COUNT(*) FROM contractors) as contractors,
    (SELECT COUNT(*) FROM maintenance_schedules) as schedules;
EOF
echo ""
echo "Expected results:"
echo "   buildings: 1"
echo "   units: 8"
echo "   budget_items: 26"
echo "   insurance: 3"
echo "   leases: 4"
echo "   contractors: 10"
echo "   schedules: 6"
echo ""
echo "Copying verification query to clipboard..."
cat << 'EOF' | pbcopy
SELECT 
    (SELECT COUNT(*) FROM buildings) as buildings,
    (SELECT COUNT(*) FROM units) as units,
    (SELECT COUNT(*) FROM budget_line_items) as budget_items,
    (SELECT COUNT(*) FROM insurance_policies) as insurance,
    (SELECT COUNT(*) FROM leases) as leases,
    (SELECT COUNT(*) FROM contractors) as contractors,
    (SELECT COUNT(*) FROM maintenance_schedules) as schedules;
EOF
echo "✅ Verification query copied to clipboard - paste and run!"
echo ""
echo "================================================================================"
echo "🎉 COMPLETE! Connaught Square data is now in Supabase"
echo "================================================================================"
echo ""
echo "🔗 View your data:"
echo "   https://supabase.com/dashboard/project/xqxaatvykmaaynqeoemy/editor"
echo ""

