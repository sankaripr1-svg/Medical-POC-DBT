{{ config(materialized='table') }}
-- Converted from SILVER.SP_LOAD_ENCOUNTER.
with parsed as (
SELECT ENCOUNTER_ID,
        RAW_PAYLOAD:patient_id::VARCHAR PATIENT_ID,
        RAW_PAYLOAD:provider_id::VARCHAR PROVIDER_ID,
        RAW_PAYLOAD:facility_id::VARCHAR FACILITY_ID,
        UPPER(RAW_PAYLOAD:encounter_type::VARCHAR) ENCOUNTER_TYPE,
        TRY_TO_TIMESTAMP_NTZ(RAW_PAYLOAD:admission_time::VARCHAR) ADMISSION_TIME,
        TRY_TO_TIMESTAMP_NTZ(RAW_PAYLOAD:discharge_time::VARCHAR) DISCHARGE_TIME,
        UPPER(RAW_PAYLOAD:status::VARCHAR) ENCOUNTER_STATUS,
        RAW_PAYLOAD:reason::VARCHAR PRIMARY_REASON
 FROM {{ ref('stg_encounter') }}

)
select parsed.*, iff(discharge_time is null, null, datediff('DAY', admission_time, discharge_time)) as length_of_stay,
current_timestamp()::timestamp_ntz as updated_at from parsed
