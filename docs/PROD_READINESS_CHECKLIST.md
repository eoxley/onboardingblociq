# BlocIQ Production Readiness Report

**Generated:** 2025-10-10 16:40 UTC


## Summary

- **Status:** ❌ Critical failures
- **Passed:** 2 ✅
- **Failed:** 4 ❌
- **Skipped:** 5 ⏭️

## Gates

- ❌ FAIL — **Environment variables** — Missing: BUILDING_ID
- ❌ FAIL — **Schema export** — FAILED
- ❌ FAIL — **Schema validate** — FAILED
- ❌ FAIL — **Compat migration** — FAILED
- ⏭️ SKIP — **Unit: Lease extractor** — Skipped due to earlier failure
- ⏭️ SKIP — **Unit: Insurance extractor** — Skipped due to earlier failure
- ⏭️ SKIP — **Unit: Compliance extractor** — Skipped due to earlier failure
- ⏭️ SKIP — **Smoke: inputs** — Skipped (BUILDING_ID not set)
- ⏭️ SKIP — **Smoke: PDF** — Skipped (BUILDING_ID not set)
- ✅ PASS — **Schema snapshot sanity** — Not found
- ✅ PASS — **PDF artifact** — summary_report.pdf

## Key Logs (last ~2000 chars each)


### Schema export

```
Traceback (most recent call last):
  File "/Users/ellie/onboardingblociq/scripts/schema/export_schema.py", line 88, in <module>
    export_schema()
  File "/Users/ellie/onboardingblociq/scripts/schema/export_schema.py", line 17, in export_schema
    conn = psycopg2.connect(database_url)
  File "/Users/ellie/Library/Python/3.9/lib/python/site-packages/psycopg2/__init__.py", line 122, in connect
    conn = _connect(dsn, connection_factory=connection_factory, **kwasync)
psycopg2.OperationalError: connection to server at "aws-0-us-east-1.pooler.supabase.com" (44.216.29.125), port 5432 failed: FATAL:  Tenant or user not found
connection to server at "aws-0-us-east-1.pooler.supabase.com" (44.216.29.125), port 5432 failed: FATAL:  Tenant or user not found


```


### Schema validate

```
❌ schema_snapshot.json not found. Run export_schema.py first.

```


### Compat migration

```
psql: error: connection to server at "aws-0-us-east-1.pooler.supabase.com" (44.208.221.186), port 5432 failed: FATAL:  Tenant or user not found
connection to server at "aws-0-us-east-1.pooler.supabase.com" (44.208.221.186), port 5432 failed: FATAL:  Tenant or user not found

```


---

**Checks executed:**

1. Schema export & validate

2. Compatibility migration

3. Unit tests (extractors)

4. Smoke: data inputs

5. Smoke: PDF render
