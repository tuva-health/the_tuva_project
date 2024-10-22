{{ config(
    enabled = var('clinical_enabled', False)
) }}

SELECT
      m.data_source
    , coalesce(m.encounter_start_date,cast('1900-01-01' as date)) as source_date
    , 'ENCOUNTER' AS table_name
    , 'Encounter ID' as drill_down_key
    , coalesce(encounter_id, 'NULL') AS drill_down_value
    , 'MS_DRG_CODE' AS field_name
    , case when term.ms_drg_code is not null then 'valid'
          when m.ms_drg_code is not null then 'invalid'
          else 'null'
    end as bucket_name
    , case when m.ms_drg_code is not null and term.ms_drg_code is null
          then 'MS DRG Code does not join to Terminology ms_drg table'
          else null end as invalid_reason
    , cast(m.ms_drg_code as {{ dbt.type_string() }}) as field_value
    , '{{ var('tuva_last_run')}}' as tuva_last_run
from {{ ref('encounter')}} m
left join {{ ref('terminology__ms_drg')}} term on m.ms_drg_code = term.ms_drg_code
