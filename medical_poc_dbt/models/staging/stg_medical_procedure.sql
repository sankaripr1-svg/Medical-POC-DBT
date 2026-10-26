{{ config(materialized='view') }}
-- Preserve raw payload and ingestion metadata; deduplicate by business identifier.
select raw_id, source_system, batch_id, procedure_id, raw_payload, ingested_at, record_hash
from {{ source('bronze','raw_medical_procedure') }}
qualify row_number() over (partition by procedure_id order by ingested_at desc, raw_id desc) = 1
