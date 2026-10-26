# Medical POC — dbt Core / Snowflake project

Converted from the attached MEDICAL_POC_DB Snowflake SQL.

## What is implemented
- **9 staging views** over the existing `MEDICAL_POC_DB.BRONZE.RAW_*` tables; latest record chosen by ID.
- **9 Silver models** translating original `SILVER.SP_LOAD_*` transformations.
- **9 Gold models** translating original `GOLD.SP_BUILD_*` reporting queries, including the daily summary.
- **Custom dbt data tests** for patient dates/gender, encounter date order, claim amounts, and lab ranges.
- **Original SQL preserved** in `sql/legacy/`; API loaders separated for operational deployment.

## Prerequisites
1. Create/populate original Bronze tables and grant read privileges. Inspect original SQL before using it; it includes destructive `CREATE OR REPLACE` statements.
2. Python and `dbt-snowflake` installed in a virtual environment.
3. Snowflake access to `MEDICAL_POC_DB` and `MEDICAL_POC_WH`, plus create privilege for your **development** schemas.
4. Copy `profiles.yml.example` to `%USERPROFILE%\.dbt\profiles.yml` and set environment variables, or configure an approved authentication strategy. The `profile:` name must remain `medical_poc_dbt`.

## VS Code PowerShell quick start
```powershell
cd C:\Projects\Start-DBT  # if adding this project to your fork, copy this folder within your repo first
python -m venv .venv
.\.venv\Scripts\Activate.ps1
python -m pip install -r requirements.txt
# configure your Snowflake profile outside the repo

dbt debug
dbt parse
dbt build
```
Run the `dbt` commands **from this directory**, where `dbt_project.yml` is located.

## Schema behavior and deployment
The default dbt `generate_schema_name` produces schemas such as `DBT_DEV_STAGING`, `DBT_DEV_SILVER`, and `DBT_DEV_GOLD`. This is intentional to avoid overwriting existing legacy SILVER/GOLD tables. The database is determined by your profile (`MEDICAL_POC_DB`). Source Bronze tables remain in `MEDICAL_POC_DB.BRONZE`.

## Migration notes / known gaps
- Model logic is converted from the supplied SQL, but **not executed against your Snowflake account**. Validate outputs against legacy results before promotion.
- Legacy Silver surrogate-key columns (`*_KEY NUMBER AUTOINCREMENT`) are not reproduced; dbt tables use natural IDs. Downstream models rely on natural IDs.
- Silver materializations use full-table rebuilds for parity and simplicity, **not** production incremental merges. Adopt incremental models after measuring volume and choosing change-detection and late-arrival semantics.
- `CREATED_AT` and `UPDATED_AT` generated during dbt builds are not stable historical audit timestamps. Rework for production if required.
- DQ tests fail builds instead of inserting to `CONTROL.DATA_QUALITY_ERROR`; configure centralized test result persistence if needed.
- Existing API ingestion, Bronze retention, streams, audit logging, and operational procedure execution are **not** migrated to dbt model SQL.
- Some legacy Gold metric definitions (e.g. readmission windows, rounded year age, claim approval rate) are preserved and should be reviewed with domain owners.
- Do not mix this project's `dbt_project.yml` into an existing dbt project root; place this directory inside your repository and execute from here.
