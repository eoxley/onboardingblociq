#!/usr/bin/env python3
"""
CLI wrapper to run onboarder and see console output
"""
from onboarder import BlocIQOnboarder
import sys

folder = '/Users/ellie/Downloads/219.01 CONNAUGHT SQUARE'
print(f"Starting onboarding for: {folder}")
print("="*80)

try:
    onboarder = BlocIQOnboarder(folder)
    onboarder.run()
    print("\n" + "="*80)
    print("COMPLETED")
    print("="*80)
except Exception as e:
    print(f"\n ERROR: {e}")
    import traceback
    traceback.print_exc()
