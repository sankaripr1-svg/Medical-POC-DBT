{{ config(materialized='table') }}
-- Converted from SILVER.SP_LOAD_DIAGNOSIS.
with parsed as (
SELECT DIAGNOSIS_ID,
        RAW_PAYLOAD:encounter_id::VARCHAR ENCOUNTER_ID,
        RAW_PAYLOAD:patient_id::VARCHAR PATIENT_ID,
        UPPER(TRIM(RAW_PAYLOAD:icd10_code::VARCHAR)) ICD10_CODE,
        INITCAP(RAW_PAYLOAD:diagnosis_name::VARCHAR) DIAGNOSIS_NAME,
        UPPER(RAW_PAYLOAD:diagnosis_type::VARCHAR) DIAGNOSIS_TYPE,
        TRY_TO_DATE(RAW_PAYLOAD:diagnosis_date::VARCHAR) DIAGNOSIS_DATE,
        COALESCE(RAW_PAYLOAD:present_on_admission::BOOLEAN,FALSE) PRESENT_ON_ADMISSION
 FROM {{ ref('stg_diagnosis') }}

)
select parsed.*, current_timestamp()::timestamp_ntz as updated_at from parsed
