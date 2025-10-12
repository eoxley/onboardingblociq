#!/usr/bin/env python3
"""
Find and fix the 2 extra closing parentheses in migration.sql
"""

import re

sql_path = '/Users/ellie/Desktop/BlocIQ_Output/migration.sql'

with open(sql_path, 'r') as f:
    lines = f.readlines()

print("Scanning for problem parentheses...")

# Track balance and find where it goes negative
balance = 0
first_negative = None
second_negative = None

for i, line in enumerate(lines, 1):
    old_balance = balance
    balance += line.count('(') - line.count(')')

    # Find first time balance goes negative
    if old_balance >= 0 and balance < 0 and first_negative is None:
        first_negative = (i, line)
        print(f"\nFirst negative balance at line {i}:")
        print(f"  Balance: {balance}")
        print(f"  Line: {line[:100]}")

    # Find second time (if balance recovers and goes negative again)
    if first_negative and old_balance >= 0 and balance < 0 and second_negative is None and i != first_negative[0]:
        second_negative = (i, line)
        print(f"\nSecond negative balance at line {i}:")
        print(f"  Balance: {balance}")
        print(f"  Line: {line[:100]}")

# Show context around first problem
if first_negative:
    i = first_negative[0]
    print(f"\n\nContext around line {i}:")
    for j in range(max(0, i-5), min(len(lines), i+5)):
        marker = " >>> " if j == i-1 else "     "
        open_c = lines[j].count('(')
        close_c = lines[j].count(')')
        print(f"{marker}{j+1:5d} ({open_c:2d}|{close_c:2d}) | {lines[j]}", end='')

# Check if it's a duplicate closing paren on a line by itself
print(f"\n\nLooking for standalone closing parens...")
standalone_closes = []
for i, line in enumerate(lines, 1):
    stripped = line.strip()
    if stripped == ')':
        # Check if previous line also ends with )
        if i > 1:
            prev_line = lines[i-2].strip()
            if prev_line.endswith(')') or prev_line.endswith(');'):
                standalone_closes.append((i, line, lines[i-2]))

if standalone_closes:
    print(f"Found {len(standalone_closes)} potential duplicate closing parens:")
    for i, line, prev_line in standalone_closes[:5]:
        print(f"  Line {i}: prev line was '{prev_line[:60]}'")
