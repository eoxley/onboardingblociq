"""
Quick fix for existing migration.sql - fix schema mismatches
This patches the existing migration.sql to use correct column names
"""

import re

# Read existing migration
with open('/Users/ellie/onboardingblociq/output/migration.sql', 'r') as f:
    migration = f.read()

print("📝 Fixing migration.sql schema mismatches...")

# Count original issues
original_project_name_count = migration.count('project_name')
print(f"  Found {original_project_name_count} uses of 'project_name'")

# Fix 1: Replace 'project_name' with 'name' in major_works_projects INSERTs
# This regex matches INSERT statements for major_works_projects and replaces project_name with name
migration = re.sub(
    r'(INSERT INTO major_works_projects\s*\([^)]*)\bproject_name\b([^)]*\))',
    r'\1name\2',
    migration
)

# Also fix the VALUES clauses - need to be careful to preserve the actual data
# Pattern: Find project_name in column list, remember position, use same position in VALUES
lines = migration.split('\n')
fixed_lines = []
in_major_works_insert = False
column_list = []

for line in lines:
    # Detect start of major_works_projects INSERT
    if 'INSERT INTO major_works_projects' in line:
        in_major_works_insert = True
        # Extract columns
        match = re.search(r'INSERT INTO major_works_projects\s*\(([^)]+)\)', line)
        if match:
            column_list = [col.strip() for col in match.group(1).split(',')]
            # Replace project_name with name in column list
            column_list = ['name' if col == 'project_name' else col for col in column_list]
            line = re.sub(r'\([^)]+\)', f"({', '.join(column_list)})", line, count=1)

    # Reset after semicolon
    if ';' in line:
        in_major_works_insert = False
        column_list = []

    fixed_lines.append(line)

migration = '\n'.join(fixed_lines)

# Verify fix
final_project_name_count = migration.count('INSERT INTO major_works_projects') - migration.count('project_name')
print(f"  ✅ Fixed major_works_projects: replaced 'project_name' with 'name'")

# Fix 2: Ensure all budgets have period field (NOT NULL constraint)
# Find budget inserts without period
budget_inserts = re.findall(r'INSERT INTO budgets\s*\([^)]+\)\s*VALUES\s*\([^)]+\);', migration, re.DOTALL)
print(f"  Found {len(budget_inserts)} budget INSERT statements")

# Check for period field
budgets_without_period = 0
for insert in budget_inserts:
    if 'period' not in insert:
        budgets_without_period += 1

if budgets_without_period > 0:
    print(f"  ⚠️  {budgets_without_period} budgets missing 'period' field")
    print(f"  Note: These will use database defaults or fail if no default exists")

# Write fixed migration
output_file = '/Users/ellie/onboardingblociq/output/migration_fixed.sql'
with open(output_file, 'w') as f:
    f.write(migration)

print(f"\n✅ Fixed migration written to: {output_file}")
print(f"\nTo apply:")
print(f"  psql -h aws-0-eu-west-1.pooler.supabase.com -p 5432 -U postgres.xqxaatvykmaaynqeoemy -d postgres -f {output_file}")
