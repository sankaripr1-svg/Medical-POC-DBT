{{ config(materialized='table') }}
-- Converted from SILVER.SP_LOAD_PATIENT.
with parsed as (
SELECT
   PATIENT_ID,
   RAW_PAYLOAD:mrn::VARCHAR MRN,
   INITCAP(TRIM(RAW_PAYLOAD:first_name::VARCHAR)) FIRST_NAME,
   INITCAP(TRIM(RAW_PAYLOAD:last_name::VARCHAR)) LAST_NAME,
   TRY_TO_DATE(RAW_PAYLOAD:date_of_birth::VARCHAR) DATE_OF_BIRTH,
   UPPER(TRIM(RAW_PAYLOAD:gender::VARCHAR)) GENDER,
   UPPER(TRIM(RAW_PAYLOAD:blood_group::VARCHAR)) BLOOD_GROUP,
   RAW_PAYLOAD:phone::VARCHAR PHONE,
   LOWER(TRIM(RAW_PAYLOAD:email::VARCHAR)) EMAIL,
   RAW_PAYLOAD:address:line1::VARCHAR ADDRESS_LINE1,
   INITCAP(RAW_PAYLOAD:address:city::VARCHAR) CITY,
   UPPER(RAW_PAYLOAD:address:state::VARCHAR) STATE,
   RAW_PAYLOAD:address:postal_code::VARCHAR POSTAL_CODE,
   UPPER(RAW_PAYLOAD:address:country::VARCHAR) COUNTRY,
   COALESCE(RAW_PAYLOAD:active::BOOLEAN,TRUE) ACTIVE_FLAG,
   SOURCE_SYSTEM,
   RECORD_HASH
 FROM {{ ref('stg_patient') }}

)
select parsed.*, current_timestamp()::timestamp_ntz as created_at,
current_timestamp()::timestamp_ntz as updated_at from parsed
