#!/usr/bin/env python3
"""
Format Building Summary Report to match exact template structure
Takes the auto-generated report and reformats it to match the provided template
"""

import re
from pathlib import Path


def update_css_to_template_style(html_content: str) -> str:
    """Replace CSS with template-matching styles"""

    template_css = """
    <style>
        @page {
            size: A4;
            margin: 2cm;
        }

        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            line-height: 1.6;
            color: #333;
            max-width: 210mm;
            margin: 0 auto;
            background: white;
            padding: 20px;
        }

        .header {
            border-bottom: 4px solid #2c3e50;
            padding-bottom: 20px;
            margin-bottom: 30px;
        }

        .header h1 {
            color: #2c3e50;
            margin: 0 0 10px 0;
            font-size: 28px;
        }

        .header .subtitle {
            color: #7f8c8d;
            font-size: 14px;
            margin: 5px 0;
        }

        .section {
            margin-bottom: 30px;
            page-break-inside: avoid;
        }

        .section-title {
            background: #2c3e50;
            color: white;
            padding: 10px 15px;
            margin: 20px 0 15px 0;
            font-size: 18px;
            font-weight: bold;
        }

        .info-grid {
            display: grid;
            grid-template-columns: repeat(2, 1fr);
            gap: 15px;
            margin-bottom: 20px;
        }

        .info-box {
            background: #f8f9fa;
            padding: 15px;
            border-left: 4px solid #3498db;
        }

        .info-box .label {
            font-weight: bold;
            color: #2c3e50;
            font-size: 12px;
            text-transform: uppercase;
            margin-bottom: 5px;
        }

        .info-box .value {
            font-size: 16px;
            color: #34495e;
        }

        .stats-container {
            display: grid;
            grid-template-columns: repeat(4, 1fr);
            gap: 15px;
            margin: 20px 0;
        }

        .stat-card {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 20px;
            border-radius: 8px;
            text-align: center;
        }

        .stat-card.green {
            background: linear-gradient(135deg, #11998e 0%, #38ef7d 100%);
        }

        .stat-card.orange {
            background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%);
        }

        .stat-card.blue {
            background: linear-gradient(135deg, #4facfe 0%, #00f2fe 100%);
        }

        .stat-card .number {
            font-size: 36px;
            font-weight: bold;
            margin-bottom: 5px;
        }

        .stat-card .label {
            font-size: 12px;
            opacity: 0.9;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            margin: 15px 0;
            background: white;
        }

        thead {
            background: #34495e;
            color: white;
        }

        th, td {
            padding: 12px;
            text-align: left;
            border-bottom: 1px solid #ddd;
        }

        tbody tr:hover {
            background: #f8f9fa;
        }

        .alert {
            padding: 15px;
            margin: 10px 0;
            border-radius: 5px;
            border-left: 4px solid;
        }

        .alert.warning {
            background: #fff3cd;
            border-color: #ffc107;
            color: #856404;
        }

        .alert.info {
            background: #d1ecf1;
            border-color: #17a2b8;
            color: #0c5460;
        }

        .alert.success {
            background: #d4edda;
            border-color: #28a745;
            color: #155724;
        }

        .footer {
            margin-top: 40px;
            padding-top: 20px;
            border-top: 2px solid #e9ecef;
            font-size: 11px;
            color: #7f8c8d;
            text-align: center;
        }

        @media print {
            body {
                margin: 0;
                padding: 15mm;
            }

            .section {
                page-break-inside: avoid;
            }

            .no-print {
                display: none;
            }
        }
    </style>
    """

    # Replace the existing style section
    pattern = r'<style>.*?</style>'
    html_content = re.sub(pattern, template_css, html_content, flags=re.DOTALL)

    return html_content


def update_class_names(html_content: str) -> str:
    """Update class names to match template"""

    # Replace class names
    replacements = {
        'section-header': 'section-title',
        'stat-grid': 'stats-container',
        'stat-card purple': 'stat-card',
    }

    for old, new in replacements.items():
        html_content = html_content.replace(old, new)

    return html_content


def wrap_sections_in_div(html_content: str) -> str:
    """Wrap sections in <div class="section">"""

    # Find all section-title divs and wrap their following content
    pattern = r'(<div class="section-title">.*?</div>)'
    sections = re.findall(pattern, html_content, re.DOTALL)

    # This is complex - easier to just add the class manually
    # For now, just ensure sections have the right structure

    return html_content


def format_report(input_file: str, output_file: str = None):
    """Format an existing report to match template"""

    if output_file is None:
        output_file = input_file.replace('.html', '_formatted.html')

    # Read input
    with open(input_file, 'r', encoding='utf-8') as f:
        html_content = f.read()

    print(f"📄 Reading: {input_file}")

    # Apply transformations
    print("🔧 Updating CSS to template style...")
    html_content = update_css_to_template_style(html_content)

    print("🔧 Updating class names...")
    html_content = update_class_names(html_content)

    # Write output
    with open(output_file, 'w', encoding='utf-8') as f:
        f.write(html_content)

    print(f"✅ Formatted report saved to: {output_file}")

    return output_file


if __name__ == '__main__':
    import sys

    if len(sys.argv) < 2:
        print("Usage: python format_to_template.py <input_html> [output_html]")
        sys.exit(1)

    input_file = sys.argv[1]
    output_file = sys.argv[2] if len(sys.argv) > 2 else None

    format_report(input_file, output_file)
