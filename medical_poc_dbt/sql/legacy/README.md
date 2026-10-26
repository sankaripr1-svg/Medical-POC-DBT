# Legacy Snowflake SQL (reference only)
The original SQL is included without modifications as `original_medical_poc.sql`.
The nine `SP_API_LOAD_*` procedures remain a separate upstream ingestion concern and are **not dbt models**.
Do not run the full original SQL against an existing environment: it contains CREATE OR REPLACE DATABASE/TABLE statements and destructive DML.
Bronze dedup/retention, audit control procedures, streams, and other operational logic require separate orchestration and migration decisions.
