{{ config(
    enabled = var('claims_enabled', False)
) }}

SELECT DISTINCT -- to bring to claim_ID grain 
    m.data_source
    ,coalesce(cast(m.enrollment_start_date as {{ dbt.type_string() }}),cast('1900-01-01' as {{ dbt.type_string() }})) as source_date
    ,'ELIGIBILITY' AS table_name
    ,'Member ID | Enrollment Start Date' AS drill_down_key
    ,coalesce(m.member_id, 'NULL') as drill_down_value
    ,'ELIGIBILITY' AS claim_type
    ,'RACE' AS field_name
    ,case when m.race is  null then 'null'
          when r.description is  null then 'invalid'
                             else 'valid' end as bucket_name
    ,case
        when m.race is not null and r.description is null then 'Race does not join to terminology race table'
        else null
    end as invalid_reason
    ,cast(race as {{ dbt.type_string() }}) as field_value
, '{{ var('tuva_last_run')}}' as tuva_last_run
from {{ ref('eligibility')}} m
left join {{ ref('terminology__race')}} r on m.race=r.description