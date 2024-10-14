{{ config(
     enabled = var('claims_enabled',var('clinical_enabled',var('tuva_marts_enabled',False)))
 | as_bool
   )
}}

with cte as (
    select distinct
        patient_id
    from {{ ref('chronic_conditions__tuva_chronic_conditions_long')}}
)

, patientxwalk as (
    select distinct
        patient_id
      , data_source
    from {{ ref('core__patient')}}
)

, result as (
    select
        l.patient_id
      , p.data_source
      , l.condition
    from {{ ref('chronic_conditions__tuva_chronic_conditions_long')}} as l
    inner join patientxwalk as p
      on l.patient_id = p.patient_id

    union all

    select
        p.patient_id
      , p.data_source
      , 'No Chronic Conditions' as condition
    from {{ ref('core__patient')}} as p
    left join cte
      on p.patient_id = cte.patient_id
    where cte.patient_id is null
)

select *
   , {{ dbt.concat([
        'patient_id',
        "'|'",
        'data_source']) }} as patient_source_key
    , '{{ var('tuva_last_run')}}' as tuva_last_run
from result
