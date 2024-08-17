{{ config(
    enabled = var('clinical_enabled', False)
) }}


SELECT
      m.data_source
    , coalesce({{ dbt.current_timestamp() }},cast('1900-01-01' as date)) as source_date
    , 'PRACTITIONER' AS table_name
    , 'Practitioner ID' as drill_down_key
    , coalesce(practitioner_id, 'NULL') AS drill_down_value
    , 'SPECIALTY' as field_name
    , case when m.specialty is not null then 'valid' else 'null' end as bucket_name
    , cast(null as {{ dbt.type_string() }}) as invalid_reason
    , cast(specialty as {{ dbt.type_string() }}) as field_value
    , '{{ var('tuva_last_run')}}' as tuva_last_run
from {{ ref('practitioner')}} m
