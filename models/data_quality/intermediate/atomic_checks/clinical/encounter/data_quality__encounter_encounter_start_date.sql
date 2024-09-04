{{ config(
    enabled = var('clinical_enabled', False)
) }}

SELECT
      m.data_source
    , coalesce(m.encounter_start_date,cast('1900-01-01' as date)) as source_date
    , 'ENCOUNTER' AS table_name
    , 'Encounter ID' as drill_down_key
    , coalesce(encounter_id, 'NULL') AS drill_down_value
    , 'ENCOUNTER_START_DATE' AS field_name
    , case
        when m.encounter_start_date > cast(substring('{{ var('tuva_last_run') }}',1,10) as date) then 'invalid'
        when m.encounter_start_date <= cast('1901-01-01' as date) then 'invalid'
        when m.encounter_start_date > m.encounter_end_date then 'invalid'
        when m.encounter_start_date is null then 'null'
        else 'valid'
    end as bucket_name
    , case
        when m.encounter_start_date > cast(substring('{{ var('tuva_last_run') }}',1,10) as date) then 'future'
        when m.encounter_start_date <= cast('1901-01-01' as date) then 'too old'
        when m.encounter_start_date > m.encounter_end_date then 'Encounter start date after encounter end date'
        else null
    end as invalid_reason
    , cast(encounter_start_date as {{ dbt.type_string() }}) as field_value
    , '{{ var('tuva_last_run')}}' as tuva_last_run
from {{ ref('encounter')}} m
