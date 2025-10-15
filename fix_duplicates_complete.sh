#!/bin/bash
# ============================================================================
# Complete Fix for Duplicate Buildings
# ============================================================================
# This script will:
# 1. Delete all 3 duplicate buildings
# 2. Generate fresh complete SQL with ALL data + contractor names  
# 3. Apply it to database
# ============================================================================

set -e  # Exit on any error

echo ""
echo "================================================================================"
echo "🧹 FIXING DUPLICATE BUILDINGS - COMPLETE PROCESS"
echo "================================================================================"
echo ""

# Step 1: Cleanup
echo "Step 1: Deleting all 3 duplicate buildings..."
python3 apply_with_new_credentials.py cleanup_duplicates.sql
echo "✅ Cleanup complete!"
echo ""

# Step 2: Generate fresh SQL with ALL data
echo "Step 2: Generating fresh complete SQL with contractor names..."
python3 sql_generator_v2.py output/connaught_square_production_final.json -o output/connaught_FINAL_COMPLETE.sql
echo "✅ SQL generated!"
echo ""

# Step 3: Apply fresh data
echo "Step 3: Loading complete fresh data to database..."
python3 apply_with_new_credentials.py output/connaught_FINAL_COMPLETE.sql
echo "✅ Data loaded!"
echo ""

# Step 4: Verify
echo "Step 4: Verifying the result..."
python3 verify_fresh_load.py
echo ""

echo "================================================================================"
echo "🎉 COMPLETE! You now have ONE building with ALL data + contractor names"
echo "================================================================================"
echo ""

