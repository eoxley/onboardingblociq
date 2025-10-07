#!/usr/bin/env python3
"""
BlocIQ Onboarder - Enhanced CLI
Comprehensive handover folder processing with full intelligence extraction

Usage:
    python run_onboarder.py --folder <path> --building-id <uuid>
    python run_onboarder.py --folder "/path/to/handover" --building-id "123e4567-e89b-12d3-a456-426614174000"
"""

import argparse
import sys
import os
from pathlib import Path

# Add BlocIQ_Onboarder to path
sys.path.insert(0, str(Path(__file__).parent / 'BlocIQ_Onboarder'))

from BlocIQ_Onboarder.onboarder import BlocIQOnboarder
from BlocIQ_Onboarder.db.introspect import introspect_and_generate


def main():
    parser = argparse.ArgumentParser(
        description='BlocIQ Onboarder - Comprehensive handover processing',
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog="""
Examples:
  # Process a handover folder
  python run_onboarder.py --folder "/Users/ellie/Desktop/BlocIQ Buildings/Building1" --building-id "abc-123"

  # Generate schema suggestions only
  python run_onboarder.py --schema-only

  # Process with custom output directory
  python run_onboarder.py --folder "./handover" --building-id "abc-123" --output ./results
        """
    )

    parser.add_argument(
        '--folder',
        help='Path to handover folder containing documents'
    )

    parser.add_argument(
        '--building-id',
        help='Building UUID (will be generated if not provided)'
    )

    parser.add_argument(
        '--building-name',
        help='Override building name'
    )

    parser.add_argument(
        '--output',
        help='Output directory for results (default: ./out)'
    )

    parser.add_argument(
        '--schema-only',
        action='store_true',
        help='Only generate schema suggestions without processing files'
    )

    parser.add_argument(
        '--no-schema-check',
        action='store_true',
        help='Skip schema introspection and suggestion generation'
    )

    args = parser.parse_args()

    print("=" * 70)
    print(" BlocIQ Onboarder - Enhanced Handover Processing")
    print("=" * 70)
    print()

    # Handle schema-only mode
    if args.schema_only:
        print("🔍 Running schema introspection only...\n")

        try:
            from dotenv import load_dotenv
            from supabase import create_client

            # Load environment
            env_path = Path(__file__).parent / 'BlocIQ_Onboarder' / '.env.local'
            if env_path.exists():
                load_dotenv(env_path)

                supabase_url = os.getenv('SUPABASE_URL')
                supabase_key = os.getenv('SUPABASE_SERVICE_ROLE_KEY')

                if supabase_url and supabase_key:
                    supabase = create_client(supabase_url, supabase_key)
                    introspect_and_generate(supabase, output_file='out/schema_suggestions.sql')
                else:
                    print("⚠️  No Supabase credentials - generating full schema")
                    introspect_and_generate(output_file='out/schema_suggestions.sql')
            else:
                print("⚠️  No .env.local file found - generating full schema")
                introspect_and_generate(output_file='out/schema_suggestions.sql')

        except Exception as e:
            print(f"❌ Error during schema introspection: {e}")
            return 1

        print("\n✅ Schema introspection complete!")
        print("📄 Review: out/schema_suggestions.sql")
        return 0

    # Validate folder argument
    if not args.folder:
        parser.print_help()
        print("\n❌ Error: --folder is required")
        return 1

    folder_path = Path(args.folder)
    if not folder_path.exists():
        print(f"❌ Error: Folder does not exist: {folder_path}")
        return 1

    if not folder_path.is_dir():
        print(f"❌ Error: Path is not a directory: {folder_path}")
        return 1

    # Generate or use provided building ID
    building_id = args.building_id
    if not building_id:
        import uuid
        building_id = str(uuid.uuid4())
        print(f"ℹ️  Generated building ID: {building_id}\n")

    # Determine output directory
    output_dir = args.output if args.output else 'out'

    print(f"📁 Handover Folder: {folder_path}")
    print(f"🆔 Building ID: {building_id}")
    print(f"📂 Output Directory: {output_dir}")
    print()

    # Run schema introspection first (unless disabled)
    if not args.no_schema_check:
        print("🔍 Step 1: Database schema introspection...\n")

        try:
            from dotenv import load_dotenv
            from supabase import create_client

            env_path = Path(__file__).parent / 'BlocIQ_Onboarder' / '.env.local'
            if env_path.exists():
                load_dotenv(env_path)

                supabase_url = os.getenv('SUPABASE_URL')
                supabase_key = os.getenv('SUPABASE_SERVICE_ROLE_KEY')

                if supabase_url and supabase_key:
                    supabase = create_client(supabase_url, supabase_key)
                    introspect_and_generate(supabase, output_file=f'{output_dir}/schema_suggestions.sql')
                else:
                    introspect_and_generate(output_file=f'{output_dir}/schema_suggestions.sql')
            else:
                introspect_and_generate(output_file=f'{output_dir}/schema_suggestions.sql')

        except Exception as e:
            print(f"⚠️  Schema introspection failed: {e}")
            print("ℹ️  Continuing with file processing...\n")

    # Run main onboarding process
    print("🚀 Step 2: Processing handover files...\n")

    try:
        onboarder = BlocIQOnboarder(
            client_folder=str(folder_path),
            building_name=args.building_name,
            output_dir=output_dir
        )

        onboarder.run()

        print("\n" + "=" * 70)
        print("✅ ONBOARDING COMPLETE")
        print("=" * 70)
        print()
        print("📦 Deliverables:")
        print(f"   • {output_dir}/migration.sql - Database migration script")
        print(f"   • {output_dir}/schema_suggestions.sql - Schema enhancement suggestions")
        print(f"   • {output_dir}/ingestion_audit.csv - Detailed ingestion log")
        print(f"   • {output_dir}/confidence_report.csv - Data confidence scores")
        print(f"   • {output_dir}/validation_report.json - Data validation results")
        print()
        print("⚠️  IMPORTANT: Review schema_suggestions.sql before applying!")
        print("ℹ️  Apply SQL manually: Do NOT execute automatically")
        print()

        return 0

    except KeyboardInterrupt:
        print("\n\n⚠️  Process interrupted by user")
        return 130

    except Exception as e:
        print(f"\n\n❌ Error during processing: {e}")
        import traceback
        traceback.print_exc()
        return 1


if __name__ == '__main__':
    sys.exit(main())
