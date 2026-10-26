# Run in PowerShell from the directory containing dbt_project.yml.
# Requires installed Python. Does not execute Snowflake DDL or dbt build.
$ErrorActionPreference = 'Stop'
python -m venv .venv
& .\.venv\Scripts\python.exe -m pip install --upgrade pip
& .\.venv\Scripts\python.exe -m pip install -r requirements.txt
New-Item -ItemType Directory -Force "$HOME\.dbt" | Out-Null
$profilePath = Join-Path $HOME '.dbt\profiles.yml'
if (-not (Test-Path $profilePath)) {
  Copy-Item 'profiles.yml.example' $profilePath
  Write-Host "Created $profilePath. IMPORTANT: Verify and edit 'account' before running dbt debug."
} else {
  Write-Host "Existing $profilePath was NOT overwritten."
}
& .\.venv\Scripts\python.exe -m dbt --version
