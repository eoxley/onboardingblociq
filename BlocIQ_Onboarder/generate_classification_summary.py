#!/usr/bin/env python3
"""
BlocIQ Document Classification Summary Generator
Generates a beautiful branded PDF summary of document classification results
"""

import json
import os
import subprocess
from datetime import datetime
from pathlib import Path
from collections import defaultdict
from typing import Dict, List

def generate_classification_summary(categorized_files: Dict, output_dir: str = "output"):
    """Generate branded PDF summary of classification results"""

    # Create output directory
    Path(output_dir).mkdir(exist_ok=True)

    # Calculate totals per category
    category_counts = defaultdict(int)
    category_examples = defaultdict(list)

    for category, files in categorized_files.items():
        category_counts[category] = len(files)
        # Store up to 3 example files per category
        category_examples[category] = [f['file_name'] for f in files[:3]]

    # Sort categories by count (descending)
    sorted_categories = sorted(category_counts.items(), key=lambda x: x[1], reverse=True)

    # Total files
    total_files = sum(category_counts.values())

    # Generate HTML with BlocIQ branding
    html = f"""<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>BlocIQ Document Classification Summary</title>
    <style>
        * {{ margin: 0; padding: 0; box-sizing: border-box; }}

        body {{
            font-family: -apple-system, BlinkMacSystemFont, 'Inter', 'Segoe UI', Roboto, sans-serif;
            color: #1a1a1a;
            line-height: 1.6;
            background: #f8f9fa;
            padding: 40px;
        }}

        .container {{
            max-width: 1000px;
            margin: 0 auto;
            background: white;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            border-radius: 12px;
            overflow: hidden;
        }}

        /* Header with gradient */
        header {{
            background: linear-gradient(135deg, #667eea 0%, #5e48e8 100%);
            color: #fff;
            padding: 50px 40px;
            text-align: left;
        }}

        .logo {{
            font-weight: 800;
            letter-spacing: -0.03em;
            font-size: 2.2em;
            margin-bottom: 8px;
        }}

        .logo-iq {{
            background: linear-gradient(135deg, rgba(255,255,255,0.95) 0%, rgba(255,255,255,0.8) 100%);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
        }}

        header p {{
            color: rgba(255,255,255,0.9);
            font-size: 1.05em;
            margin-top: 4px;
        }}

        /* Main content */
        main {{
            padding: 40px;
        }}

        h2 {{
            color: #5E48E8;
            font-weight: 700;
            margin-bottom: 20px;
            margin-top: 30px;
            font-size: 1.6em;
            letter-spacing: -0.02em;
        }}

        h2:first-child {{
            margin-top: 0;
        }}

        .summary-stats {{
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 20px;
            margin: 20px 0;
        }}

        .stat-card {{
            background: #f8f9fa;
            padding: 20px;
            border-radius: 8px;
            border-left: 4px solid #667eea;
        }}

        .stat-card strong {{
            display: block;
            color: #5E48E8;
            font-size: 0.85em;
            text-transform: uppercase;
            letter-spacing: 0.05em;
            margin-bottom: 8px;
        }}

        .stat-card p {{
            font-size: 2em;
            font-weight: 700;
            color: #1a1a1a;
        }}

        /* Table styling */
        table {{
            width: 100%;
            border-collapse: separate;
            border-spacing: 0;
            margin-top: 20px;
            border-radius: 8px;
            overflow: hidden;
            box-shadow: 0 1px 3px rgba(0,0,0,0.08);
        }}

        th, td {{
            padding: 16px 20px;
            text-align: left;
        }}

        th {{
            background: #f8f9fa;
            font-weight: 600;
            color: #5E48E8;
            text-transform: uppercase;
            font-size: 0.85em;
            letter-spacing: 0.05em;
            border-bottom: 2px solid #e9ecef;
        }}

        td {{
            border-bottom: 1px solid #e9ecef;
        }}

        tr:last-child td {{
            border-bottom: none;
        }}

        tr:hover {{
            background: #f8f9fa;
        }}

        .count {{
            font-weight: 600;
            font-size: 1.2em;
            color: #667eea;
        }}

        .examples {{
            font-size: 0.9em;
            color: #6c757d;
            font-style: italic;
        }}

        .examples-list {{
            margin: 0;
            padding-left: 20px;
        }}

        .examples-list li {{
            margin: 4px 0;
        }}

        /* Category badges */
        .category {{
            display: inline-block;
            padding: 4px 12px;
            border-radius: 12px;
            font-size: 0.85em;
            font-weight: 600;
            text-transform: capitalize;
        }}

        .category-insurance {{ background: #d1ecf1; color: #0c5460; }}
        .category-compliance {{ background: #d4edda; color: #155724; }}
        .category-budgets {{ background: #fff3cd; color: #856404; }}
        .category-contracts {{ background: #f8d7da; color: #721c24; }}
        .category-major_works {{ background: #e2e3e5; color: #383d41; }}
        .category-default {{ background: #e9ecef; color: #495057; }}

        /* Footer */
        footer {{
            padding: 30px 40px;
            text-align: center;
            color: #6c757d;
            font-size: 0.9em;
            border-top: 1px solid #e9ecef;
        }}

        footer strong {{
            color: #5E48E8;
        }}

        /* Print optimizations */
        @media print {{
            body {{ background: white; padding: 0; }}
            .container {{ box-shadow: none; }}
            tr:hover {{ background: transparent; }}
        }}
    </style>
</head>
<body>
    <div class="container">
        <header>
            <div class="logo">Bloc<span class="logo-iq">IQ</span></div>
            <p>Document Classification Summary</p>
        </header>

        <main>
            <h2>Classification Overview</h2>

            <div class="summary-stats">
                <div class="stat-card">
                    <strong>Total Documents</strong>
                    <p>{total_files}</p>
                </div>
                <div class="stat-card">
                    <strong>Categories</strong>
                    <p>{len(category_counts)}</p>
                </div>
                <div class="stat-card">
                    <strong>Generated</strong>
                    <p style="font-size: 1.2em; font-weight: 500;">{datetime.now().strftime("%d %b %Y")}</p>
                </div>
            </div>

            <h2>Documents by Category</h2>

            <table>
                <thead>
                    <tr>
                        <th>Category</th>
                        <th style="text-align: center;">Count</th>
                        <th>Example Files</th>
                    </tr>
                </thead>
                <tbody>
"""

    # Add table rows
    for category, count in sorted_categories:
        # Get category badge class
        badge_class = f"category-{category.replace('_', '-')}" if category in ['insurance', 'compliance', 'budgets', 'contracts', 'major_works'] else "category-default"

        # Get examples
        examples = category_examples[category]
        examples_html = "<br>".join([f"• {ex}" for ex in examples[:3]])

        html += f"""                    <tr>
                        <td>
                            <span class="category {badge_class}">{category.replace('_', ' ')}</span>
                        </td>
                        <td class="count" style="text-align: center;">{count}</td>
                        <td class="examples">{examples_html}</td>
                    </tr>
"""

    html += f"""                </tbody>
            </table>

            <h2 style="margin-top: 40px;">Classification Details</h2>

            <table>
                <thead>
                    <tr>
                        <th>Category</th>
                        <th>Example Files (Full List)</th>
                    </tr>
                </thead>
                <tbody>
"""

    # Add detailed examples
    for category, count in sorted_categories:
        badge_class = f"category-{category.replace('_', '-')}" if category in ['insurance', 'compliance', 'budgets', 'contracts', 'major_works'] else "category-default"
        examples = category_examples[category]

        examples_list = "".join([f"<li>{ex}</li>" for ex in examples])

        html += f"""                    <tr>
                        <td style="vertical-align: top;">
                            <span class="category {badge_class}">{category.replace('_', ' ')}</span>
                        </td>
                        <td>
                            <ul class="examples-list">
                                {examples_list}
                                {f'<li><em>... and {count - len(examples)} more</em></li>' if count > len(examples) else ''}
                            </ul>
                        </td>
                    </tr>
"""

    html += f"""                </tbody>
            </table>
        </main>

        <footer>
            <strong>Generated by BlocIQ Intelligence Engine</strong><br>
            {datetime.now().strftime("%A, %d %B %Y at %H:%M")}<br>
            © {datetime.now().year} BlocIQ Ltd. All rights reserved.
        </footer>
    </div>
</body>
</html>"""

    # Write HTML
    html_path = os.path.join(output_dir, "document_summary.html")
    with open(html_path, 'w', encoding='utf-8') as f:
        f.write(html)

    print(f"✅ HTML summary saved to {html_path}")

    # Generate PDF using wkhtmltopdf or pypandoc
    pdf_path = os.path.join(output_dir, "document_summary.pdf")
    pdf_generated = False

    try:
        # Try wkhtmltopdf first (best quality)
        subprocess.run([
            "wkhtmltopdf",
            "--enable-local-file-access",
            "--no-stop-slow-scripts",
            html_path,
            pdf_path
        ], check=True, capture_output=True)
        pdf_generated = True
        print(f"✅ PDF summary saved to {pdf_path} (wkhtmltopdf)")
    except (subprocess.CalledProcessError, FileNotFoundError):
        try:
            # Try pypandoc
            subprocess.run([
                "pypandoc",
                html_path,
                "-f", "html",
                "-t", "pdf",
                "-o", pdf_path
            ], check=True, capture_output=True)
            pdf_generated = True
            print(f"✅ PDF summary saved to {pdf_path} (pypandoc)")
        except (subprocess.CalledProcessError, FileNotFoundError):
            try:
                # Try weasyprint
                subprocess.run([
                    "weasyprint",
                    html_path,
                    pdf_path
                ], check=True, capture_output=True)
                pdf_generated = True
                print(f"✅ PDF summary saved to {pdf_path} (weasyprint)")
            except (subprocess.CalledProcessError, FileNotFoundError):
                print("⚠️  No PDF converter installed (wkhtmltopdf/pypandoc/weasyprint)")
                print(f"   HTML summary available at: {html_path}")

    # Save categorized files debug JSON
    debug_results = []
    for category, files in categorized_files.items():
        for file_data in files:
            debug_results.append({
                'file': file_data.get('file_name', 'unknown'),
                'category': category,
                'confidence': file_data.get('confidence', 0.0)
            })

    debug_path = os.path.join(output_dir, "categorized_files_debug.json")
    with open(debug_path, 'w', encoding='utf-8') as f:
        json.dump(debug_results, f, indent=2)

    print(f"✅ Debug JSON saved to {debug_path}")

    # Print summary
    print(f"\n{'='*60}")
    print("📊 BlocIQ Classification Summary")
    print(f"{'='*60}")
    print(f"\nTotal Documents: {total_files}")
    print(f"Total Categories: {len(category_counts)}\n")

    print("Category Breakdown:")
    for category, count in sorted_categories:
        print(f"  • {category.replace('_', ' ').title()}: {count}")

    print(f"\n{'='*60}\n")

    return {
        'html_path': html_path,
        'pdf_path': pdf_path if pdf_generated else None,
        'debug_path': debug_path,
        'total_files': total_files,
        'categories': len(category_counts)
    }

if __name__ == "__main__":
    # Example usage - load from categorized_files_debug.json if available
    import sys

    if len(sys.argv) > 1:
        input_file = sys.argv[1]
    else:
        input_file = "output/categorized_files_debug.json"

    if not os.path.exists(input_file):
        print(f"❌ Error: {input_file} not found")
        print("\nUsage: python generate_classification_summary.py [path/to/categorized_files_debug.json]")
        sys.exit(1)

    with open(input_file, 'r') as f:
        debug_data = json.load(f)

    # Group by category
    categorized = defaultdict(list)
    for item in debug_data:
        category = item.get('category', 'uncategorized')
        categorized[category].append({
            'file_name': item.get('file', 'unknown'),
            'confidence': item.get('confidence', 0.0)
        })

    generate_classification_summary(dict(categorized))
