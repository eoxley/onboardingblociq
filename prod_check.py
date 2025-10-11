#!/usr/bin/env python3
"""
BlocIQ Production Readiness Check
Drop-in script that executes the full validation pipeline and generates a report.
"""
import os, sys, subprocess, datetime, json

# --------- CONFIG ---------
ENV_REQUIRED = ["DATABASE_URL", "SUPABASE_URL", "SUPABASE_SERVICE_KEY", "BUILDING_ID"]
PYTHON_STEPS = [
    ("Schema export", ["python3", "scripts/schema/export_schema.py"]),
    ("Schema validate", ["python3", "scripts/schema/validate_against_supabase.py"]),
    ("Compat migration", ["psql", os.environ.get("DATABASE_URL", ""), "-f", "scripts/schema/compatibility_migration.sql"]),
    ("Unit: Lease extractor", ["python3", "-m", "unittest", "tests/unit/test_lease_extractor.py"]),
    ("Unit: Insurance extractor", ["python3", "-m", "unittest", "tests/unit/test_insurance_extractor.py"]),
    ("Unit: Compliance extractor", ["python3", "-m", "unittest", "tests/unit/test_compliance_extractor.py"]),
    ("Smoke: inputs", ["python3", "scripts/smoke/health_inputs.py", os.environ.get("BUILDING_ID", "")]),
    ("Smoke: PDF", ["python3", "scripts/smoke/regenerate_pdf.py", os.environ.get("BUILDING_ID", "")]),
]
REPORT_PATH = "docs/PROD_READINESS_CHECKLIST.md"
SCHEMA_SNAPSHOT = "schema_snapshot.json"
OUT_DIR = "output"
# --------------------------

def run(cmd, env=None):
    """Run command and capture output"""
    # Filter out empty strings from cmd
    cmd = [c for c in cmd if c]
    if not cmd:
        return 1, "Empty command"

    try:
        p = subprocess.Popen(cmd, stdout=subprocess.PIPE, stderr=subprocess.STDOUT, env=env or os.environ)
        out, _ = p.communicate(timeout=300)
        text = out.decode(errors="replace")
        return p.returncode, text
    except subprocess.TimeoutExpired:
        p.kill()
        return 1, "TIMEOUT: Command took longer than 300 seconds"
    except Exception as e:
        return 1, f"ERROR: {str(e)}"

def banner(msg):
    return f"\n{'='*60}\n{msg}\n{'='*60}\n"

def check_env():
    """Check required environment variables"""
    missing = [k for k in ENV_REQUIRED if not os.environ.get(k)]
    return missing

def short_out(text, n=2000):
    """Truncate output to n characters"""
    return text if len(text) <= n else text[:n] + "\n...[truncated]...\n"

def main():
    started = datetime.datetime.utcnow()
    os.makedirs("docs", exist_ok=True)
    os.makedirs(OUT_DIR, exist_ok=True)

    print(banner("🚀 BlocIQ Production Readiness Check"))

    # 1) Env check
    print("\n📋 Checking environment variables...")
    env_missing = check_env()
    results = []

    if env_missing:
        results.append(("Environment variables", False, f"Missing: {', '.join(env_missing)}"))
        print(f"❌ Missing environment variables: {', '.join(env_missing)}")
    else:
        results.append(("Environment variables", True, "All required env vars present."))
        print("✅ All required environment variables present")

    # 2) Run steps
    all_ok = not env_missing
    logs = {}

    for name, cmd in PYTHON_STEPS:
        # Skip steps requiring BUILDING_ID if not set
        if not os.environ.get("BUILDING_ID") and "Smoke" in name:
            results.append((name, None, "Skipped (BUILDING_ID not set)"))
            print(f"⏭️  {name}: Skipped (BUILDING_ID not set)")
            continue

        # Skip if critical early failures (but try schema steps to potentially fix)
        if not all_ok and not any(x in name for x in ["Schema", "Compat"]):
            results.append((name, None, "Skipped due to earlier failure"))
            print(f"⏭️  {name}: Skipped due to earlier failure")
            continue

        print(f"\n🔄 Running: {name}...")
        print(f"   Command: {' '.join(cmd)}")

        rc, out = run(cmd)
        logs[name] = out
        ok = (rc == 0)

        if not ok and any(x in name for x in ["Schema export", "Schema validate", "Compat migration"]):
            # Critical schema steps
            all_ok = False

        results.append((name, ok, "OK" if ok else "FAILED"))

        if ok:
            print(f"✅ {name}: PASSED")
        else:
            print(f"❌ {name}: FAILED")
            # Show first few lines of error
            error_lines = out.split('\n')[:5]
            for line in error_lines:
                if line.strip():
                    print(f"   {line}")

    # 3) Inspect schema snapshot (optional sanity)
    print("\n🔍 Checking schema snapshot...")
    schema_ok = True
    schema_note = "Not found"

    if os.path.exists(SCHEMA_SNAPSHOT):
        try:
            snap = json.load(open(SCHEMA_SNAPSHOT))
            if not isinstance(snap.get("columns", []), list):
                schema_ok = False
                schema_note = "schema_snapshot.json lacks 'columns' array"
            else:
                col_count = len(snap['columns'])
                const_count = len(snap.get('constraints', []))
                idx_count = len(snap.get('indexes', []))
                view_count = len(snap.get('views', []))
                schema_note = f"columns: {col_count}, constraints: {const_count}, indexes: {idx_count}, views: {view_count}"
                print(f"✅ Schema snapshot: {schema_note}")
        except Exception as e:
            schema_ok = False
            schema_note = f"Error reading schema snapshot: {e}"
            print(f"❌ Schema snapshot: {schema_note}")
    else:
        print(f"⚠️  Schema snapshot not found")

    results.append(("Schema snapshot sanity", schema_ok, schema_note))

    # 4) Check PDF artifact existence
    print("\n📄 Checking for PDF artifacts...")
    pdf_ok = False
    pdf_note = "None"

    if os.path.exists(OUT_DIR):
        pdfs = [f for f in os.listdir(OUT_DIR) if f.lower().endswith(".pdf")]
        pdf_ok = len(pdfs) > 0
        pdf_note = pdfs[0] if pdfs else "No PDF files found"

        if pdf_ok:
            print(f"✅ PDF artifact found: {pdf_note}")
        else:
            print(f"⚠️  No PDF artifacts found in {OUT_DIR}/")
    else:
        pdf_note = f"{OUT_DIR}/ directory not found"
        print(f"⚠️  {pdf_note}")

    results.append(("PDF artifact", pdf_ok, pdf_note))

    # 5) Calculate overall status
    critical_checks = [r for r in results if r[0] in [
        "Environment variables",
        "Schema export",
        "Schema validate",
        "Compat migration"
    ]]
    critical_ok = all(r[1] for r in critical_checks if r[1] is not None)

    # Count passes and fails
    passed = sum(1 for r in results if r[1] is True)
    failed = sum(1 for r in results if r[1] is False)
    skipped = sum(1 for r in results if r[1] is None)

    all_ok = critical_ok and failed == 0

    # 6) Compose report
    grade = "✅ Production-ready" if all_ok else ("⚠️ Issues detected" if critical_ok else "❌ Critical failures")
    ts = started.strftime("%Y-%m-%d %H:%M UTC")

    md = []
    md.append(f"# BlocIQ Production Readiness Report\n")
    md.append(f"**Generated:** {ts}\n")
    md.append(f"\n## Summary\n")
    md.append(f"- **Status:** {grade}")
    md.append(f"- **Passed:** {passed} ✅")
    md.append(f"- **Failed:** {failed} ❌")
    md.append(f"- **Skipped:** {skipped} ⏭️")
    md.append(f"\n## Gates\n")

    for name, ok, note in results:
        if ok is True:
            status = "✅ PASS"
        elif ok is False:
            status = "❌ FAIL"
        else:
            status = "⏭️ SKIP"
        md.append(f"- {status} — **{name}** — {note}")

    md.append(f"\n## Key Logs (last ~2000 chars each)\n")

    for name, out in logs.items():
        md.append(f"\n### {name}\n\n```\n{short_out(out)}\n```\n")

    # Schema details
    if os.path.exists(SCHEMA_SNAPSHOT):
        try:
            snap = json.load(open(SCHEMA_SNAPSHOT))
            md.append(f"\n## Schema Details\n")

            # Tables
            tables = list(set(c['table_name'] for c in snap.get('columns', [])))
            md.append(f"\n### Tables ({len(tables)})\n")
            for table in sorted(tables)[:20]:  # Show first 20
                cols = [c for c in snap.get('columns', []) if c['table_name'] == table]
                md.append(f"- `{table}` ({len(cols)} columns)")

            # Views
            views = snap.get('views', [])
            md.append(f"\n### Views ({len(views)})\n")
            for view in views[:10]:  # Show first 10
                md.append(f"- `{view.get('view_name', 'unknown')}`")
        except:
            pass

    md.append(f"\n---\n\n**Checks executed:**\n")
    md.append(f"1. Schema export & validate\n")
    md.append(f"2. Compatibility migration\n")
    md.append(f"3. Unit tests (extractors)\n")
    md.append(f"4. Smoke: data inputs\n")
    md.append(f"5. Smoke: PDF render\n")

    # Write report
    with open(REPORT_PATH, "w") as f:
        f.write("\n".join(md))

    # Print summary
    print(banner("📊 RESULT"))
    print(f"Status: {grade}")
    print(f"\nPassed:  {passed} ✅")
    print(f"Failed:  {failed} ❌")
    print(f"Skipped: {skipped} ⏭️")
    print(f"\nReport → {REPORT_PATH}")

    if pdf_ok:
        print(f"PDF    → {os.path.join(OUT_DIR, pdf_note)}")

    print(banner("✨ DONE"))

    sys.exit(0 if all_ok else 1)

if __name__ == "__main__":
    main()
