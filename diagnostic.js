#!/usr/bin/env node
/**
 * BlocIQ Migration Diagnostic Script
 *
 * Purpose: Scan generated SQL migration files and flag common onboarding/data integrity issues
 * Checks: missing dates, duplicate inserts, empty strings, missing ON CONFLICT protection, etc.
 *
 * Usage: node diagnostic.js [path/to/migration.sql]
 */

const fs = require('fs');
const path = require('path');

class BlocIQDiagnostic {
    constructor(sqlFilePath) {
        this.sqlFilePath = sqlFilePath;
        this.sqlContent = '';
        this.sqlLines = [];
        this.issues = {
            critical: [],
            warnings: [],
            info: [],
            suggestions: []
        };
        this.stats = {
            buildings: 0,
            complianceAssets: 0,
            budgets: 0,
            documents: 0,
            units: 0,
            leaseholders: 0
        };
    }

    async run() {
        console.log('\n' + '='.repeat(60));
        console.log('BlocIQ Migration Diagnostic');
        console.log('='.repeat(60));
        console.log(`File: ${this.sqlFilePath}\n`);

        // Read SQL file
        try {
            this.sqlContent = fs.readFileSync(this.sqlFilePath, 'utf-8');
            this.sqlLines = this.sqlContent.split('\n');
        } catch (err) {
            console.error(`❌ Error reading file: ${err.message}`);
            process.exit(1);
        }

        // Run all checks
        this.checkMissingDates();
        this.checkDuplicateInserts();
        this.checkEmptyStrings();
        this.checkOnConflictProtection();
        this.checkComplianceFrequencies();
        this.checkBudgetMetadata();
        this.checkUUIDs();
        this.checkForeignKeys();
        this.extractDatePatterns();
        this.countRecords();

        // Print results
        this.printResults();
    }

    checkMissingDates() {
        const complianceInserts = this.sqlLines.filter(line =>
            line.includes('INSERT INTO compliance_assets')
        );

        let missingInspectionDate = 0;
        let missingExpiryDate = 0;

        for (const line of complianceInserts) {
            if (!line.includes('last_inspection_date') && !line.includes('inspection_date')) {
                missingInspectionDate++;
            }
            if (!line.includes('next_due_date') && !line.includes('expiry_date')) {
                missingExpiryDate++;
            }
        }

        if (missingInspectionDate > 0) {
            this.issues.warnings.push(
                `${missingInspectionDate} compliance_assets missing inspection_date/last_inspection_date`
            );
        }

        if (missingExpiryDate > 0) {
            this.issues.warnings.push(
                `${missingExpiryDate} compliance_assets missing next_due_date/expiry_date`
            );
        }

        // Check for missing created_at timestamps
        const allInserts = this.sqlLines.filter(line => line.trim().startsWith('INSERT INTO'));
        let missingCreatedAt = 0;

        for (const line of allInserts) {
            if (!line.includes('created_at')) {
                missingCreatedAt++;
            }
        }

        if (missingCreatedAt > 10) {
            this.issues.info.push(
                `${missingCreatedAt} INSERT statements missing created_at (using DB default)`
            );
        }
    }

    checkDuplicateInserts() {
        const insertsByTable = {};
        const insertPattern = /INSERT INTO (\w+)/;

        for (const line of this.sqlLines) {
            const match = line.match(insertPattern);
            if (match) {
                const tableName = match[1];
                if (!insertsByTable[tableName]) {
                    insertsByTable[tableName] = [];
                }
                insertsByTable[tableName].push(line);
            }
        }

        // Check for duplicate values
        for (const [table, inserts] of Object.entries(insertsByTable)) {
            const seen = new Set();
            const duplicates = [];

            for (const insert of inserts) {
                // Extract VALUES clause
                const valuesMatch = insert.match(/VALUES\s*\((.*)\)/);
                if (valuesMatch) {
                    const values = valuesMatch[1];
                    if (seen.has(values)) {
                        duplicates.push(values);
                    }
                    seen.add(values);
                }
            }

            if (duplicates.length > 0) {
                this.issues.warnings.push(
                    `${duplicates.length} possible duplicate INSERT(s) in ${table}`
                );

                // Show first duplicate as example
                if (duplicates.length > 0) {
                    const example = duplicates[0].substring(0, 80);
                    this.issues.info.push(`  Example: ${example}...`);
                }
            }
        }
    }

    checkEmptyStrings() {
        const emptyStringPattern = /''\s*,/g;
        let emptyAddresses = 0;
        let emptyNotes = 0;

        for (const line of this.sqlLines) {
            if (line.includes('INSERT INTO buildings') && line.match(/'',\s*$/)) {
                emptyAddresses++;
            }
            if (line.includes("''") && (line.includes('notes') || line.includes('address'))) {
                emptyNotes++;
            }
        }

        if (emptyAddresses > 0) {
            this.issues.warnings.push(
                `${emptyAddresses} building record(s) with empty address value`
            );
        }

        if (emptyNotes > 3) {
            this.issues.info.push(
                `${emptyNotes} record(s) with empty notes/address fields`
            );
        }
    }

    checkOnConflictProtection() {
        const hasOnConflict = this.sqlContent.includes('ON CONFLICT');
        const hasDoNothing = this.sqlContent.includes('DO NOTHING');
        const hasDoUpdate = this.sqlContent.includes('DO UPDATE');

        if (hasOnConflict && (hasDoNothing || hasDoUpdate)) {
            this.issues.info.push('✅ ON CONFLICT protection found');
        } else {
            this.issues.warnings.push(
                '⚠️ No ON CONFLICT protection - inserts may fail on re-run'
            );
            this.issues.suggestions.push(
                'Add ON CONFLICT (id) DO NOTHING to all INSERT statements'
            );
        }
    }

    checkComplianceFrequencies() {
        const frequencyPattern = /inspection_frequency['"]\s*[:,]\s*['"](.*?)['"]/gi;
        const frequencies = {};
        let match;

        while ((match = frequencyPattern.exec(this.sqlContent)) !== null) {
            const freq = match[1];
            frequencies[freq] = (frequencies[freq] || 0) + 1;
        }

        const totalFrequencies = Object.values(frequencies).reduce((a, b) => a + b, 0);

        if (frequencies['12 months'] && frequencies['12 months'] === totalFrequencies) {
            this.issues.warnings.push(
                `All ${totalFrequencies} compliance_assets have default frequency "12 months"`
            );
            this.issues.suggestions.push(
                'Extract specific frequencies: EICR (60 months), LOLER (6 months), FRA (12 months)'
            );
        } else if (Object.keys(frequencies).length > 0) {
            this.issues.info.push(
                `Compliance frequencies detected: ${Object.keys(frequencies).join(', ')}`
            );
        }
    }

    checkBudgetMetadata() {
        const budgetInserts = this.sqlLines.filter(line =>
            line.includes('INSERT INTO budgets') || line.includes('INSERT INTO building_documents')
        );

        let missingPeriod = 0;
        let missingYear = 0;
        let hasFinancialYear = false;
        let hasPeriodLabel = false;

        for (const line of budgetInserts) {
            if (line.includes('INSERT INTO budgets')) {
                if (!line.includes('period') && !line.includes('financial_year')) {
                    missingPeriod++;
                }
                if (!line.match(/20\d{2}/)) {
                    missingYear++;
                }
            }

            if (line.includes('financial_year')) hasFinancialYear = true;
            if (line.includes('period_label')) hasPeriodLabel = true;
        }

        if (missingPeriod > 0) {
            this.issues.warnings.push(
                `${missingPeriod} budget record(s) missing period/year metadata`
            );
        }

        if (hasFinancialYear || hasPeriodLabel) {
            this.issues.info.push(
                '✅ Budget documents include financial_year and period_label metadata'
            );
        } else {
            this.issues.suggestions.push(
                'Extract financial_year (e.g., "2025") and period_label (e.g., "Q1") from filenames'
            );
        }
    }

    checkUUIDs() {
        const uuidPattern = /[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}/gi;
        const uuids = this.sqlContent.match(uuidPattern) || [];

        if (uuids.length === 0) {
            this.issues.critical.push('❌ No valid UUIDs found in migration');
        } else {
            this.issues.info.push(`✅ ${uuids.length} UUIDs detected`);
        }

        // Check for malformed UUIDs (missing dashes, wrong length)
        const malformedPattern = /[0-9a-f]{32}/gi;
        const malformed = this.sqlContent.match(malformedPattern) || [];

        if (malformed.length > 0) {
            this.issues.warnings.push(
                `${malformed.length} potentially malformed UUID(s) (missing dashes)`
            );
        }
    }

    checkForeignKeys() {
        const hasBuildingId = this.sqlContent.includes('building_id');
        const hasUnitId = this.sqlContent.includes('unit_id');
        const hasFkConstraints = this.sqlContent.includes('FOREIGN KEY') ||
                                 this.sqlContent.includes('REFERENCES');

        if (hasBuildingId && hasUnitId) {
            this.issues.info.push('✅ Foreign key columns present (building_id, unit_id)');
        }

        if (hasFkConstraints) {
            this.issues.info.push('✅ Foreign key constraints defined');
        }
    }

    extractDatePatterns() {
        // Date patterns: DDMMYY, DDMMYYYY, YYYY-MM-DD, DD-MM-YYYY
        const datePatterns = [
            { regex: /\b(\d{2})(\d{2})(\d{2})\b/g, format: 'DDMMYY' },
            { regex: /\b(\d{2})(\d{2})(\d{4})\b/g, format: 'DDMMYYYY' },
            { regex: /\b(\d{4})-(\d{2})-(\d{2})\b/g, format: 'YYYY-MM-DD' },
            { regex: /\b(\d{2})-(\d{2})-(\d{4})\b/g, format: 'DD-MM-YYYY' }
        ];

        const foundDates = [];

        for (const { regex, format } of datePatterns) {
            let match;
            while ((match = regex.exec(this.sqlContent)) !== null) {
                const dateStr = match[0];
                // Try to parse as date
                const parsed = this.parseDate(dateStr, format);
                if (parsed) {
                    foundDates.push({ original: dateStr, parsed, format });
                }
            }
        }

        if (foundDates.length > 0) {
            this.issues.info.push(
                `📅 ${foundDates.length} potential date(s) found in filenames/data`
            );

            // Show first 3 examples
            const examples = foundDates.slice(0, 3);
            for (const { original, parsed, format } of examples) {
                this.issues.info.push(
                    `  ${original} (${format}) → ${parsed}`
                );
            }
        }
    }

    parseDate(dateStr, format) {
        let day, month, year;

        try {
            switch (format) {
                case 'DDMMYY':
                    day = parseInt(dateStr.substring(0, 2));
                    month = parseInt(dateStr.substring(2, 4));
                    year = 2000 + parseInt(dateStr.substring(4, 6));
                    break;
                case 'DDMMYYYY':
                    day = parseInt(dateStr.substring(0, 2));
                    month = parseInt(dateStr.substring(2, 4));
                    year = parseInt(dateStr.substring(4, 8));
                    break;
                case 'YYYY-MM-DD':
                    const parts1 = dateStr.split('-');
                    year = parseInt(parts1[0]);
                    month = parseInt(parts1[1]);
                    day = parseInt(parts1[2]);
                    break;
                case 'DD-MM-YYYY':
                    const parts2 = dateStr.split('-');
                    day = parseInt(parts2[0]);
                    month = parseInt(parts2[1]);
                    year = parseInt(parts2[2]);
                    break;
            }

            // Validate date
            if (day >= 1 && day <= 31 && month >= 1 && month <= 12 && year >= 2000 && year <= 2030) {
                return `${year}-${String(month).padStart(2, '0')}-${String(day).padStart(2, '0')}`;
            }
        } catch (e) {
            return null;
        }

        return null;
    }

    countRecords() {
        const patterns = {
            buildings: /INSERT INTO buildings/g,
            complianceAssets: /INSERT INTO compliance_assets/g,
            budgets: /INSERT INTO budgets/g,
            documents: /INSERT INTO building_documents/g,
            units: /INSERT INTO units/g,
            leaseholders: /INSERT INTO leaseholders/g
        };

        for (const [key, pattern] of Object.entries(patterns)) {
            const matches = this.sqlContent.match(pattern);
            this.stats[key] = matches ? matches.length : 0;
        }
    }

    printResults() {
        // Print statistics
        console.log('📊 Record Counts:');
        console.log(`  Buildings: ${this.stats.buildings}`);
        console.log(`  Units: ${this.stats.units}`);
        console.log(`  Leaseholders: ${this.stats.leaseholders}`);
        console.log(`  Documents: ${this.stats.documents}`);
        console.log(`  Compliance Assets: ${this.stats.complianceAssets}`);
        console.log(`  Budgets: ${this.stats.budgets}`);
        console.log();

        // Print critical issues
        if (this.issues.critical.length > 0) {
            console.log('🚨 Critical Issues:');
            for (const issue of this.issues.critical) {
                console.log(`  ${issue}`);
            }
            console.log();
        }

        // Print warnings
        if (this.issues.warnings.length > 0) {
            console.log('⚠️  Warnings:');
            for (const issue of this.issues.warnings) {
                console.log(`  ${issue}`);
            }
            console.log();
        }

        // Print info
        if (this.issues.info.length > 0) {
            console.log('ℹ️  Information:');
            for (const issue of this.issues.info) {
                console.log(`  ${issue}`);
            }
            console.log();
        }

        // Print suggestions
        if (this.issues.suggestions.length > 0) {
            console.log('💡 Suggestions:');
            for (const suggestion of this.issues.suggestions) {
                console.log(`  • ${suggestion}`);
            }
            console.log();
        }

        // Summary
        console.log('='.repeat(60));
        const totalIssues = this.issues.critical.length + this.issues.warnings.length;

        if (totalIssues === 0) {
            console.log('✅ Migration looks healthy! No critical issues found.');
        } else {
            console.log(`Found ${totalIssues} issue(s) that may need attention.`);
        }

        console.log('='.repeat(60));
        console.log();
    }
}

// Main execution
const args = process.argv.slice(2);

if (args.length === 0) {
    console.error('Usage: node diagnostic.js [path/to/migration.sql]');
    console.error('Example: node diagnostic.js output/migration.sql');
    process.exit(1);
}

const sqlFilePath = args[0];

if (!fs.existsSync(sqlFilePath)) {
    console.error(`❌ File not found: ${sqlFilePath}`);
    process.exit(1);
}

const diagnostic = new BlocIQDiagnostic(sqlFilePath);
diagnostic.run();
