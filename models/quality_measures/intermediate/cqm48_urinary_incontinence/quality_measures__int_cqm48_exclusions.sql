{{ config(
     enabled = var('quality_measures_enabled',var('claims_enabled',var('clinical_enabled',var('tuva_marts_enabled',False)))) | as_bool
   )
}}

{%- set performance_period_begin -%}
(
  select 
    performance_period_begin
  from {{ ref('quality_measures__int_cqm48__performance_period') }}
)
{%- endset -%}

{%- set performance_period_end -%}
(
  select 
    performance_period_end
  from {{ ref('quality_measures__int_cqm48__performance_period') }}
)
{%- endset -%}

with valid_hospice_exclusions as (

  select
      patient_id
    , exclusion_date
    , exclusion_reason
  from {{ ref('quality_measures__int_shared_exclusions_hospice_palliative') }}
  where exclusion_date between {{ performance_period_begin }} and {{ performance_period_end }}
    and lower(exclusion_reason) in (
            'hospice encounter'
    )

)

, combined_exclusions as (

  select
      valid_hospice_exclusions.patient_id
    , valid_hospice_exclusions.exclusion_date
    , valid_hospice_exclusions.exclusion_reason
  from valid_hospice_exclusions
  inner join {{ ref('quality_measures__int_cqm48_denominator') }} as denominator
      on valid_hospice_exclusions.patient_id = denominator.patient_id

)

, add_data_types as (

    select
        distinct
          cast(patient_id as {{ dbt.type_string() }}) as patient_id
        , cast(exclusion_date as date) as exclusion_date
        , cast(exclusion_reason as {{ dbt.type_string() }}) as exclusion_reason
        , cast(1 as integer) as exclusion_flag
    from combined_exclusions

)

select
      patient_id
    , exclusion_date
    , exclusion_reason
    , exclusion_flag
    , '{{ var('tuva_last_run')}}' as tuva_last_run
from add_data_types
