{{ config(materialized='table') }}
-- Converted from SILVER.SP_LOAD_LAB_RESULT.
with parsed as (
SELECT LAB_RESULT_ID,
        RAW_PAYLOAD:patient_id::VARCHAR PATIENT_ID,
        RAW_PAYLOAD:encounter_id::VARCHAR ENCOUNTER_ID,
        UPPER(RAW_PAYLOAD:test_code::VARCHAR) TEST_CODE,
        RAW_PAYLOAD:test_name::VARCHAR TEST_NAME,
        RAW_PAYLOAD:result_value::VARCHAR RESULT_VALUE,
        TRY_TO_DECIMAL(RAW_PAYLOAD:result_value::VARCHAR,18,4) NUMERIC_VALUE,
        RAW_PAYLOAD:unit::VARCHAR UNIT,
        TRY_TO_DECIMAL(RAW_PAYLOAD:reference_low::VARCHAR,18,4) REFERENCE_LOW,
        TRY_TO_DECIMAL(RAW_PAYLOAD:reference_high::VARCHAR,18,4) REFERENCE_HIGH,
        TRY_TO_TIMESTAMP_NTZ(RAW_PAYLOAD:collected_at::VARCHAR) COLLECTED_AT,
        TRY_TO_TIMESTAMP_NTZ(RAW_PAYLOAD:resulted_at::VARCHAR) RESULTED_AT
 FROM {{ ref('stg_lab_result') }}

)
select parsed.*, case
    when numeric_value is null then 'UNKNOWN'
    when reference_low is not null and numeric_value < reference_low then 'LOW'
    when reference_high is not null and numeric_value > reference_high then 'HIGH'
    else 'NORMAL' end as abnormal_flag
from parsed
