# Medical POC — dbt Core / Snowflake project

Converted from the attached MEDICAL_POC_DB Snowflake SQL.

## What is implemented
- **9 staging views** over the existing `MEDICAL_POC_DB.BRONZE.RAW_*` tables; latest record chosen by ID.
- **9 Silver models** translating original `SILVER.SP_LOAD_*` transformations.
- **9 Gold models** translating original `GOLD.SP_BUILD_*` reporting queries, including the daily summary.
- **Custom dbt data tests** for patient dates/gender, encounter date order, claim amounts, and lab ranges.
- **Original SQL preserved** in `sql/legacy/`; API loaders separated for operational deployment.

## Snowflake trial connection (updated 26 October 2026)
Values read from the user's Snowsight screenshot:

| Key | Value |
| --- | --- |
| Organization | `HCPETXC` |
| Account locator | `IX05925` |
| Username | `muthuselvimsc04` |
| Role currently active | `ACCOUNTADMIN` |
| Database | `MEDICAL_POC_DB` |
| Warehouse | `MEDICAL_POC_WH` |
| Source schema | `BRONZE` |
| dbt target schema | `DBT_DEV` (proposed, not confirmed to exist) |

**The `HCPETXC-IX05925` value in the template is provisional, not verified as a working Snowflake account identifier.** To obtain the correct value run `sql/check_snowflake_account.sql` in Snowsight and replace `account:` in `%USERPROFILE%\.dbt\profiles.yml` with `DBT_ACCOUNT_IDENTIFIER`. The Snowflake screenshot does not show `CURRENT_ACCOUNT_NAME()`.

### Open in VS Code (PowerShell)
```powershell
cd 'C:\Users\sankara.shenbagaraj\Downloads\Medical_POC_DBT_Project\medical_poc_dbt' # adjust to extracted folder
.\setup_windows_vscode.ps1 # if execution blocked: use commands below instead
# Inspect and update the copied connection profile at $HOME\.dbt\profiles.yml
.\.venv\Scripts\Activate.ps1
# From the dbt project root:
dbt debug
dbt parse
dbt run --select staging
dbt run --select silver
dbt run --select gold
dbt test
```
If PowerShell script execution is blocked, run `python -m venv .venv`, `python -m pip install -r requirements.txt` using the venv Python, and copy the profile manually instead of changing machine policy. `dbt build` modifies Snowflake development relations; confirm privileges and source data first.

**Do not run the original `sql/legacy/original_medical_poc.sql` as a setup script without review**: it contains destructive `CREATE OR REPLACE` statements.

## Prerequisites
1. Create/populate original Bronze tables and grant read privileges. Inspect original SQL before using it; it includes destructive `CREATE OR REPLACE` statements.
2. Python and `dbt-snowflake` installed in a virtual environment.
3. Snowflake access to `MEDICAL_POC_DB` and `MEDICAL_POC_WH`, plus create privilege for your **development** schemas.
4. Copy `profiles.yml.example` to `%USERPROFILE%\.dbt\profiles.yml` and set environment variables, or configure an approved authentication strategy. The `profile:` name must remain `medical_poc_dbt`.

## VS Code PowerShell quick start
```powershell
cd path\to\medical_poc_dbt  # folder containing dbt_project.yml
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
