{{ config(materialized='table') }}
-- Converted from SILVER.SP_LOAD_CLAIM.
with parsed as (
SELECT CLAIM_ID,
        RAW_PAYLOAD:patient_id::VARCHAR PATIENT_ID,
        RAW_PAYLOAD:encounter_id::VARCHAR ENCOUNTER_ID,
        INITCAP(RAW_PAYLOAD:payer_name::VARCHAR) PAYER_NAME,
        TRY_TO_DATE(RAW_PAYLOAD:claim_date::VARCHAR) CLAIM_DATE,
        TRY_TO_DECIMAL(RAW_PAYLOAD:claim_amount::VARCHAR,18,2) CLAIM_AMOUNT,
        TRY_TO_DECIMAL(RAW_PAYLOAD:approved_amount::VARCHAR,18,2) APPROVED_AMOUNT,
        TRY_TO_DECIMAL(RAW_PAYLOAD:patient_pay_amount::VARCHAR,18,2) PATIENT_PAY_AMOUNT,
        UPPER(RAW_PAYLOAD:status::VARCHAR) CLAIM_STATUS
 FROM {{ ref('stg_claim') }}

)
select parsed.*, current_timestamp()::timestamp_ntz as updated_at from parsed
