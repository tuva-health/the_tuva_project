{{ config(
     enabled = var('pqi_enabled',var('claims_enabled',var('tuva_marts_enabled',False))) | as_bool
   )
}}

with kidney as (
    select distinct
        encounter_id
      , data_source
      , 'kidney' as exclusion_reason
    from {{ ref('core__condition') }} as c
    inner join {{ ref('pqi__value_sets') }} as pqi 
      on c.normalized_code = pqi.code
      and c.normalized_code_type = 'icd-10-cm'
      and pqi.value_set_name = 'kidney_or_urinary_tract_disorder_diagnosis_codes'
      and pqi.pqi_number = '12'
    where c.encounter_id is not null
),

immune_dx as (
    select distinct
        encounter_id
      , data_source
      , 'immunocompromised diagnosis' as exclusion_reason
    from {{ ref('core__condition') }} as c
    inner join {{ ref('pqi__value_sets') }} as pqi 
      on c.normalized_code = pqi.code
      and c.normalized_code_type = 'icd-10-cm'
      and pqi.value_set_name = 'immunocompromised_state_diagnosis_codes'
      and pqi.pqi_number = 'appendix_c'
    where c.encounter_id is not null
),

immune_px as (
    select distinct
        encounter_id
      , data_source
      , 'immunocompromised procedure' as exclusion_reason
    from {{ ref('core__procedure') }} as c
    inner join {{ ref('pqi__value_sets') }} as pqi 
      on c.normalized_code = pqi.code
      and c.normalized_code_type = 'icd-10-pcs'
      and pqi.value_set_name = 'immunocompromised_state_procedure_codes'
      and pqi.pqi_number = 'appendix_c'
    where c.encounter_id is not null
),

union_cte as (
    select
        encounter_id
      , data_source
      , exclusion_reason
    from {{ ref('ahrq_measures__int_pqi_shared_exclusion_union') }}

    union

    select
        encounter_id
      , data_source
      , exclusion_reason
    from kidney

    union

    select
        encounter_id
      , data_source
      , exclusion_reason
    from immune_dx

    union

    select
        encounter_id
      , data_source
      , exclusion_reason
    from immune_px
)

select
    encounter_id
  , data_source
  , exclusion_reason
  , row_number() over (
      partition by encounter_id, data_source 
      order by exclusion_reason
    ) as exclusion_number
  , '{{ var('tuva_last_run')}}' as tuva_last_run
from union_cte
