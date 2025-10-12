#!/usr/bin/env python3
"""Find unbalanced parentheses in SQL"""

sql_path = '/Users/ellie/Desktop/BlocIQ_Output/migration.sql'

with open(sql_path, 'r') as f:
    lines = f.readlines()

print("Scanning for unbalanced parentheses...")
print()

# Track parenthesis balance line by line
balance = 0
max_depth = 0
problematic_lines = []

for i, line in enumerate(lines, 1):
    line_open = line.count('(')
    line_close = line.count(')')

    balance += line_open - line_close

    if balance > max_depth:
        max_depth = balance

    # Flag lines with negative balance (more closes than opens)
    if balance < 0:
        problematic_lines.append((i, balance, line.strip()))

    # Flag lines with very high balance (likely unclosed)
    if balance > 20:
        problematic_lines.append((i, balance, line.strip()))

print(f"Max depth reached: {max_depth}")
print(f"Final balance: {balance} (should be 0)")
print()

if balance != 0:
    print(f"❌ Unbalanced by {abs(balance)} parentheses")
    print()

    if problematic_lines:
        print("Problematic lines (first 20):")
        for line_no, bal, content in problematic_lines[:20]:
            print(f"  Line {line_no} (balance={bal:+d}): {content[:70]}")
    print()

    # Find the last line where balance was 0
    balance_check = 0
    last_zero_line = 0
    for i, line in enumerate(lines, 1):
        balance_check += line.count('(') - line.count(')')
        if balance_check == 0:
            last_zero_line = i

    print(f"Last line with zero balance: {last_zero_line}")
    print(f"Problem likely after line {last_zero_line}")

    # Show lines around the problem
    if last_zero_line < len(lines):
        print(f"\nContext around line {last_zero_line}:")
        start = max(0, last_zero_line - 3)
        end = min(len(lines), last_zero_line + 10)
        for i in range(start, end):
            marker = " >>> " if i == last_zero_line - 1 else "     "
            print(f"{marker}{i+1:5d} | {lines[i]}", end='')

else:
    print("✅ Parentheses are balanced")
