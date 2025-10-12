#!/usr/bin/env python3
"""Find the unbalanced quote in SQL file"""

import re

sql_path = '/Users/ellie/Desktop/BlocIQ_Output/migration.sql'

with open(sql_path, 'r') as f:
    lines = f.readlines()

print("Searching for unbalanced quotes...")
print()

# Track quote state
in_quote = False
quote_line_start = 0

for i, line in enumerate(lines, 1):
    # Count quotes in line
    for j, char in enumerate(line):
        if char == "'" and (j == 0 or line[j-1] != '\\'):
            # Check if it's an escaped quote (double '')
            if j + 1 < len(line) and line[j+1] == "'":
                continue  # Skip escaped quote

            in_quote = not in_quote
            if in_quote:
                quote_line_start = i

# Check if we ended in a quote
if in_quote:
    print(f"❌ Unclosed quote started on line {quote_line_start}")
    print(f"\nShowing lines {quote_line_start-2} to {quote_line_start+10}:")
    print()
    for i in range(max(0, quote_line_start-3), min(len(lines), quote_line_start+10)):
        marker = " >>> " if i == quote_line_start - 1 else "     "
        print(f"{marker}{i+1:5d} | {lines[i]}", end='')
else:
    print("✅ All quotes are balanced")

# Also find lines with odd number of quotes
print("\n\nLines with odd number of quotes (potential issues):")
print()

for i, line in enumerate(lines, 1):
    # Don't count escaped quotes
    cleaned = line.replace("''", "")

    quote_count = cleaned.count("'")
    if quote_count % 2 != 0:
        print(f"Line {i} ({quote_count} quotes): {line[:80]}")
        if len(line) > 80:
            print(" " * 10 + "...")
