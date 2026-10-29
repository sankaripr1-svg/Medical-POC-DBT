{{ config(materialized='table') }}

SELECT
    c.claim_id,
    c.claim_status,
    c.claim_amount,
    c.approved_amount,
    c.patient_pay_amount,
    m.status_category,
    m.is_final
FROM {{ ref('claim') }} c
LEFT JOIN {{ ref('claim_status_mapping') }} m
    ON UPPER(TRIM(c.claim_status)) = m.claim_status