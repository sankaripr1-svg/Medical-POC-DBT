{{ config(materialized='view') }}
-- Preserve raw payload and ingestion metadata; deduplicate by business identifier.
select raw_id, source_system, batch_id, diagnosis_id, raw_payload, ingested_at, record_hash
from {{ source('bronze','raw_diagnosis') }}
qualify row_number() over (partition by diagnosis_id order by ingested_at desc, raw_id desc) = 1
