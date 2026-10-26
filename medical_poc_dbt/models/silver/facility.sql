{{ config(materialized='table') }}
-- Converted from SILVER.SP_LOAD_FACILITY.
with parsed as (
SELECT FACILITY_ID,
        INITCAP(RAW_PAYLOAD:name::VARCHAR) FACILITY_NAME,
        UPPER(RAW_PAYLOAD:type::VARCHAR) FACILITY_TYPE,
        INITCAP(RAW_PAYLOAD:city::VARCHAR) CITY,
        UPPER(RAW_PAYLOAD:state::VARCHAR) STATE,
        UPPER(RAW_PAYLOAD:country::VARCHAR) COUNTRY,
        TRY_TO_NUMBER(RAW_PAYLOAD:bed_capacity::VARCHAR) BED_CAPACITY,
        COALESCE(RAW_PAYLOAD:active::BOOLEAN,TRUE) ACTIVE_FLAG
 FROM {{ ref('stg_facility') }}

)
select parsed.*, current_timestamp()::timestamp_ntz as updated_at from parsed
