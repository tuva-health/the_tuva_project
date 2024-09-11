{{ config(
    enabled = var('clinical_enabled', False)
) }}

SELECT
      m.data_source
    , coalesce(m.encounter_start_date,cast('1900-01-01' as date)) as source_date
    , 'ENCOUNTER' AS table_name
    , 'Encounter ID' as drill_down_key
    , coalesce(encounter_id, 'NULL') AS drill_down_value
    , 'ADMIT_TYPE_CODE' AS field_name
    , case when term.admit_type_code is not null then 'valid'
          when m.admit_type_code is not null then 'invalid'
          else 'null'
    end as bucket_name
    , case when m.admit_type_code is not null and term.admit_type_code is null
          then 'Admit Type Code does not join to Terminology admit_type table'
          else null end as invalid_reason
    , cast(m.admit_type_code as {{ dbt.type_string() }}) as field_value
    , '{{ var('tuva_last_run')}}' as tuva_last_run
from {{ ref('encounter')}} m
left join {{ ref('terminology__admit_type')}} term on m.admit_type_code = term.admit_type_code
