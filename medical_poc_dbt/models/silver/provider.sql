{{ config(materialized='table') }}
-- Converted from SILVER.SP_LOAD_PROVIDER.
with parsed as (
SELECT PROVIDER_ID,
        INITCAP(RAW_PAYLOAD:name::VARCHAR) PROVIDER_NAME,
        INITCAP(RAW_PAYLOAD:speciality::VARCHAR) SPECIALITY,
        RAW_PAYLOAD:license_number::VARCHAR LICENSE_NUMBER,
        RAW_PAYLOAD:phone::VARCHAR PHONE,
        LOWER(RAW_PAYLOAD:email::VARCHAR) EMAIL,
        RAW_PAYLOAD:facility_id::VARCHAR FACILITY_ID,
        COALESCE(RAW_PAYLOAD:active::BOOLEAN,TRUE) ACTIVE_FLAG
 FROM {{ ref('stg_provider') }}

)
select parsed.*, current_timestamp()::timestamp_ntz as updated_at from parsed
