"""
SQL Generator - Output Reporter
Generate JSON metadata and SQL outputs
"""

import json
from datetime import datetime
from pathlib import Path
from typing import List, Dict, Optional


class ReportGenerator:
    """Generate structured JSON and SQL outputs"""

    def generate_json_report(
        self,
        building_name: str,
        documents: List[Dict],
        output_path: str,
        building_profile: Dict = None
    ) -> str:
        """
        Generate JSON metadata report

        Args:
            building_name: Name of the building
            documents: List of processed documents with metadata
            output_path: Path to save JSON file
            building_profile: Building description profile (optional)

        Returns:
            Path to generated JSON file
        """
        report = {
            'building': building_name,
            'generated_at': datetime.now().isoformat(),
            'total_documents': len(documents),
            'building_profile': building_profile or {},
            'documents': documents,
            'summary': self._generate_summary(documents)
        }

        # Ensure output directory exists
        Path(output_path).parent.mkdir(parents=True, exist_ok=True)

        # Write JSON
        with open(output_path, 'w', encoding='utf-8') as f:
            json.dump(report, f, indent=2, ensure_ascii=False)

        return output_path

    def _generate_summary(self, documents: List[Dict]) -> Dict:
        """Generate summary statistics"""
        summary = {
            'total': len(documents),
            'current': 0,
            'due_soon': 0,
            'expired': 0,
            'missing': 0,
            'unknown': 0,
            'by_type': {}
        }

        for doc in documents:
            status = doc.get('status', 'unknown')

            # Count by status
            if status == 'current':
                summary['current'] += 1
            elif status == 'due_soon':
                summary['due_soon'] += 1
            elif status == 'expired':
                summary['expired'] += 1
            elif status == 'missing':
                summary['missing'] += 1
            else:
                summary['unknown'] += 1

            # Count by type
            doc_type = doc.get('document_type', 'Unknown')
            if doc_type not in summary['by_type']:
                summary['by_type'][doc_type] = {
                    'total': 0,
                    'current': 0,
                    'expired': 0,
                    'missing': 0
                }

            summary['by_type'][doc_type]['total'] += 1

            if status == 'current':
                summary['by_type'][doc_type]['current'] += 1
            elif status == 'expired':
                summary['by_type'][doc_type]['expired'] += 1
            elif status == 'missing':
                summary['by_type'][doc_type]['missing'] += 1

        return summary

    def generate_sql_file(
        self,
        building_name: str,
        documents: List[Dict],
        output_path: str,
        table_name: str = 'building_documents'
    ) -> str:
        """
        Generate SQL INSERT statements

        Args:
            building_name: Name of the building
            documents: List of processed documents
            output_path: Path to save SQL file
            table_name: Name of the table to insert into

        Returns:
            Path to generated SQL file
        """
        # Ensure output directory exists
        Path(output_path).parent.mkdir(parents=True, exist_ok=True)

        with open(output_path, 'w', encoding='utf-8') as f:
            # Write header
            f.write(f"-- Building Documents SQL\n")
            f.write(f"-- Generated: {datetime.now().isoformat()}\n")
            f.write(f"-- Building: {building_name}\n")
            f.write(f"-- Total Documents: {len(documents)}\n\n")

            # Write INSERT statements
            for doc in documents:
                # Skip missing documents
                if doc.get('status') == 'missing':
                    f.write(f"-- MISSING: {doc.get('document_type')}\n")
                    continue

                # Generate INSERT
                sql = self._generate_insert_statement(building_name, doc, table_name)
                f.write(sql + '\n')

        return output_path

    def _generate_insert_statement(
        self,
        building_name: str,
        doc: Dict,
        table_name: str
    ) -> str:
        """Generate INSERT statement for a single document"""

        # Extract fields
        file_name = self._escape_sql(doc.get('file_name', ''))
        doc_type = doc.get('document_type', '')
        inspection_date = doc.get('inspection_date') or 'NULL'
        next_due_date = doc.get('next_due_date') or 'NULL'
        status = doc.get('status', 'unknown')
        contractor = self._escape_sql(doc.get('contractor', ''))
        reference = self._escape_sql(doc.get('reference_number', ''))
        risk_rating = doc.get('risk_rating', '')
        is_current = 'TRUE' if doc.get('is_current') else 'FALSE'

        # Format dates
        if inspection_date != 'NULL':
            inspection_date = f"'{inspection_date}'"
        if next_due_date != 'NULL':
            next_due_date = f"'{next_due_date}'"

        # Build INSERT
        sql = f"""INSERT INTO {table_name} (
    building_name,
    file_name,
    document_type,
    inspection_date,
    next_due_date,
    status,
    contractor,
    reference_number,
    risk_rating,
    is_current
) VALUES (
    '{self._escape_sql(building_name)}',
    '{file_name}',
    '{doc_type}',
    {inspection_date},
    {next_due_date},
    '{status}',
    '{contractor}',
    '{reference}',
    '{risk_rating}',
    {is_current}
);"""

        return sql

    def _escape_sql(self, value: str) -> str:
        """Escape single quotes for SQL"""
        if value is None:
            return ''
        return str(value).replace("'", "''")

    def generate_summary_csv(
        self,
        documents: List[Dict],
        output_path: str
    ) -> str:
        """
        Generate CSV summary of documents

        Args:
            documents: List of processed documents
            output_path: Path to save CSV file

        Returns:
            Path to generated CSV file
        """
        import csv

        # Ensure output directory exists
        Path(output_path).parent.mkdir(parents=True, exist_ok=True)

        with open(output_path, 'w', newline='', encoding='utf-8') as f:
            writer = csv.writer(f)

            # Write header
            writer.writerow([
                'Document Type',
                'File Name',
                'Inspection Date',
                'Next Due Date',
                'Days Until Due',
                'Status',
                'Contractor',
                'Reference',
                'Risk Rating',
                'Is Current'
            ])

            # Write rows
            for doc in documents:
                writer.writerow([
                    doc.get('document_type', ''),
                    doc.get('file_name', ''),
                    doc.get('inspection_date', ''),
                    doc.get('next_due_date', ''),
                    doc.get('days_until_due', ''),
                    doc.get('status', ''),
                    doc.get('contractor', ''),
                    doc.get('reference_number', ''),
                    doc.get('risk_rating', ''),
                    'Yes' if doc.get('is_current') else 'No'
                ])

        return output_path

    def generate_html_report(
        self,
        building_name: str,
        documents: List[Dict],
        output_path: str
    ) -> str:
        """
        Generate HTML summary report

        Args:
            building_name: Name of the building
            documents: List of processed documents
            output_path: Path to save HTML file

        Returns:
            Path to generated HTML file
        """
        summary = self._generate_summary(documents)

        html = f"""<!DOCTYPE html>
<html>
<head>
    <title>Document Report - {building_name}</title>
    <style>
        body {{ font-family: Arial, sans-serif; margin: 20px; }}
        h1 {{ color: #333; }}
        .summary {{ background: #f5f5f5; padding: 15px; margin: 20px 0; border-radius: 5px; }}
        .summary-item {{ display: inline-block; margin: 10px 20px 10px 0; }}
        table {{ border-collapse: collapse; width: 100%; margin-top: 20px; }}
        th, td {{ border: 1px solid #ddd; padding: 12px; text-align: left; }}
        th {{ background-color: #4CAF50; color: white; }}
        tr:nth-child(even) {{ background-color: #f2f2f2; }}
        .status-current {{ color: green; font-weight: bold; }}
        .status-expired {{ color: red; font-weight: bold; }}
        .status-due_soon {{ color: orange; font-weight: bold; }}
        .status-missing {{ color: red; font-style: italic; }}
    </style>
</head>
<body>
    <h1>Building Document Report: {building_name}</h1>
    <p>Generated: {datetime.now().strftime('%d %B %Y at %H:%M')}</p>

    <div class="summary">
        <h2>Summary</h2>
        <div class="summary-item"><strong>Total Documents:</strong> {summary['total']}</div>
        <div class="summary-item"><strong>Current:</strong> {summary['current']}</div>
        <div class="summary-item"><strong>Due Soon:</strong> {summary['due_soon']}</div>
        <div class="summary-item"><strong>Expired:</strong> {summary['expired']}</div>
        <div class="summary-item"><strong>Missing:</strong> {summary['missing']}</div>
    </div>

    <h2>Document Details</h2>
    <table>
        <thead>
            <tr>
                <th>Document Type</th>
                <th>File Name</th>
                <th>Inspection Date</th>
                <th>Next Due</th>
                <th>Status</th>
                <th>Contractor</th>
            </tr>
        </thead>
        <tbody>
"""

        # Sort documents: current first, then by urgency
        sorted_docs = sorted(
            documents,
            key=lambda d: (
                0 if d.get('is_current') else 1,
                -(d.get('urgency_score', 0))
            )
        )

        for doc in sorted_docs:
            status = doc.get('status', 'unknown')
            status_class = f"status-{status}"

            html += f"""
            <tr>
                <td>{doc.get('document_type', '')}</td>
                <td>{doc.get('file_name', 'N/A')}</td>
                <td>{doc.get('inspection_date', 'N/A')}</td>
                <td>{doc.get('next_due_date', 'N/A')}</td>
                <td class="{status_class}">{status.replace('_', ' ').title()}</td>
                <td>{doc.get('contractor', 'N/A')}</td>
            </tr>
"""

        html += """
        </tbody>
    </table>
</body>
</html>
"""

        # Ensure output directory exists
        Path(output_path).parent.mkdir(parents=True, exist_ok=True)

        with open(output_path, 'w', encoding='utf-8') as f:
            f.write(html)

        return output_path


# Test function
if __name__ == '__main__':
    # Test data
    test_documents = [
        {
            'document_type': 'FRA',
            'file_name': 'FRA_2025.pdf',
            'inspection_date': '2025-03-04',
            'next_due_date': '2026-03-04',
            'status': 'current',
            'is_current': True,
            'contractor': 'TriFire Safety Ltd',
            'reference_number': 'FRA-2025-001',
            'risk_rating': 'Low'
        },
        {
            'document_type': 'EICR',
            'file_name': 'EICR_2022.pdf',
            'inspection_date': '2022-01-15',
            'next_due_date': '2027-01-15',
            'status': 'current',
            'is_current': True,
            'contractor': 'ABC Electrical Ltd'
        },
        {
            'document_type': 'Legionella',
            'status': 'missing'
        }
    ]

    generator = ReportGenerator()

    # Generate JSON
    json_path = generator.generate_json_report(
        'Test Building',
        test_documents,
        '/tmp/test_metadata.json'
    )
    print(f"Generated JSON: {json_path}")

    # Generate SQL
    sql_path = generator.generate_sql_file(
        'Test Building',
        test_documents,
        '/tmp/test_generated.sql'
    )
    print(f"Generated SQL: {sql_path}")
