#!/bin/bash

echo "🚀 Running ALL Pimlico SQL parts to Supabase..."
echo ""
echo "This will run 19 SQL files in sequence"
echo ""

# Step 1: Delete
echo "🗑️  STEP 1/19: Deleting old Pimlico..."
python3 apply_with_new_credentials.py DELETE_pimlico_65e81534.sql
echo ""
sleep 1

# Steps 2-19: Insert parts
for i in {01..18}; do
    echo "📊 STEP $((10#$i + 1))/19: Running PIMLICO_PART${i}.sql..."
    python3 apply_with_new_credentials.py PIMLICO_PART${i}.sql
    
    if [ $? -eq 0 ]; then
        echo "   ✅ Part ${i} complete"
    else
        echo "   ⚠️  Part ${i} had issues (check output above)"
    fi
    echo ""
    sleep 0.5
done

echo ""
echo "✅ ALL 19 FILES PROCESSED!"
echo ""
echo "🔍 Verify with this query in Supabase:"
echo "SELECT building_name, num_units FROM buildings WHERE building_name = 'Pimlico Place';"

