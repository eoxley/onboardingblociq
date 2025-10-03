#!/usr/bin/env python3
"""
CLI test of onboarder with console output
"""
import sys
from onboarder import BlocIQOnboarder

folder_path = "/Users/ellie/Downloads/219.01 CONNAUGHT SQUARE"
output_dir = "/Users/ellie/Desktop/BlocIQ_Output"

print(f"\n🚀 Starting onboarding process...")
print(f"   Client folder: {folder_path}")
print(f"   Output dir: {output_dir}\n")

onboarder = BlocIQOnboarder(folder_path, output_dir)
onboarder.run()

print("\n✅ Process complete! Check output files.")
