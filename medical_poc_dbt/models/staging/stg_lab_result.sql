{{ config(materialized='view') }}
-- Preserve raw payload and ingestion metadata; deduplicate by business identifier.
select raw_id, source_system, batch_id, lab_result_id, raw_payload, ingested_at, record_hash
from {{ source('bronze','raw_lab_result') }}
qualify row_number() over (partition by lab_result_id order by ingested_at desc, raw_id desc) = 1
