{{ config(materialized='table') }}
-- Converted from SILVER.SP_LOAD_MEDICATION.
SELECT MEDICATION_ID,
        RAW_PAYLOAD:patient_id::VARCHAR PATIENT_ID,
        RAW_PAYLOAD:encounter_id::VARCHAR ENCOUNTER_ID,
        RAW_PAYLOAD:drug_code::VARCHAR DRUG_CODE,
        INITCAP(RAW_PAYLOAD:drug_name::VARCHAR) DRUG_NAME,
        RAW_PAYLOAD:dosage::VARCHAR DOSAGE,
        RAW_PAYLOAD:frequency::VARCHAR FREQUENCY,
        UPPER(RAW_PAYLOAD:route::VARCHAR) ROUTE,
        TRY_TO_DATE(RAW_PAYLOAD:start_date::VARCHAR) START_DATE,
        TRY_TO_DATE(RAW_PAYLOAD:end_date::VARCHAR) END_DATE,
        UPPER(RAW_PAYLOAD:status::VARCHAR) MEDICATION_STATUS
 FROM {{ ref('stg_medication') }}
