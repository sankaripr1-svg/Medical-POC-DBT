{{ config(materialized='table') }}
-- Converted from SILVER.SP_LOAD_MEDICAL_PROCEDURE.
with parsed as (
SELECT PROCEDURE_ID,
        RAW_PAYLOAD:encounter_id::VARCHAR ENCOUNTER_ID,
        RAW_PAYLOAD:patient_id::VARCHAR PATIENT_ID,
        RAW_PAYLOAD:provider_id::VARCHAR PROVIDER_ID,
        UPPER(RAW_PAYLOAD:cpt_code::VARCHAR) CPT_CODE,
        INITCAP(RAW_PAYLOAD:procedure_name::VARCHAR) PROCEDURE_NAME,
        TRY_TO_DATE(RAW_PAYLOAD:procedure_date::VARCHAR) PROCEDURE_DATE,
        UPPER(RAW_PAYLOAD:status::VARCHAR) PROCEDURE_STATUS,
        TRY_TO_DECIMAL(RAW_PAYLOAD:cost::VARCHAR,18,2) PROCEDURE_COST
 FROM {{ ref('stg_medical_procedure') }}

)
select parsed.*, current_timestamp()::timestamp_ntz as updated_at from parsed
