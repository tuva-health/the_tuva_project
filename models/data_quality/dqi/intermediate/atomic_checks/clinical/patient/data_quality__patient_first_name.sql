{{ config(
    enabled = var('clinical_enabled', False)
) }}


SELECT
      m.data_source
    {% if target.type == 'bigquery' %}
        , cast(coalesce({{ dbt.current_timestamp() }}, cast('1900-01-01' as timestamp)) as date) as source_date
    {% else %}
        , cast(coalesce({{ dbt.current_timestamp() }}, cast('1900-01-01' as date)) as date) as source_date
    {% endif %}
    , 'PATIENT' AS table_name
    , 'Person ID' as drill_down_key
    , coalesce(person_id, 'NULL') AS drill_down_value
    , 'FIRST_NAME' as field_name
    , case when m.first_name is not null then 'valid' else 'null' end as bucket_name
    , cast(null as {{ dbt.type_string() }}) as invalid_reason
    , cast(first_name as {{ dbt.type_string() }}) as field_value
    , '{{ var('tuva_last_run')}}' as tuva_last_run
from {{ ref('patient')}} m
