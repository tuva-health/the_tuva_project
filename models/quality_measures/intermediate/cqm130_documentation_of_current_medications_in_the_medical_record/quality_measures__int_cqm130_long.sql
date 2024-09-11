{{ config(
     enabled = var('quality_measures_enabled',var('claims_enabled',var('clinical_enabled',var('tuva_marts_enabled',False)))) | as_bool
   )
}}

with denominator as (

    select
          patient_id
        , performance_period_begin
        , performance_period_end
        , measure_id
        , measure_name
        , measure_version
        , denominator_flag
    from {{ ref('quality_measures__int_cqm130_denominator') }}

)

, numerator as (

    select
          patient_id
        , evidence_date
        , evidence_value
    from {{ ref('quality_measures__int_cqm130_numerator') }}

)

, exclusions as (

    select
          patient_id
        , exclusion_date
        , exclusion_reason
    from {{ ref('quality_measures__int_cqm130_exclusions') }}

)

, measure_flags as (

    select
          denominator.patient_id
        , case
            when denominator.patient_id is not null
            then 1
            else null
          end as denominator_flag
        , case
            when numerator.patient_id is not null and denominator.patient_id is not null
            then 1
            when denominator.patient_id is not null
            then 0
            else null
          end as numerator_flag
        , case
            when exclusions.patient_id is not null and denominator.patient_id is not null
            then 1
            when denominator.patient_id is not null
            then 0
            else null
          end as exclusion_flag
        , numerator.evidence_date
        , numerator.evidence_value
        , exclusions.exclusion_date
        , exclusions.exclusion_reason
        , denominator.performance_period_begin
        , denominator.performance_period_end
        , denominator.measure_id
        , denominator.measure_name
        , denominator.measure_version
        , (row_number() over(
            partition by
                  denominator.patient_id
                , denominator.performance_period_begin
                , denominator.performance_period_end
                , denominator.measure_id
                , denominator.measure_name
              order by
                  case when numerator.evidence_date is null then 1 else 0 end,
                  numerator.evidence_date desc
                , case when exclusions.exclusion_date is null then 1 else 0 end,
                  exclusions.exclusion_date desc
          )) as rn
    from denominator
        left join numerator
            on denominator.patient_id = numerator.patient_id
        left join exclusions
            on denominator.patient_id = exclusions.patient_id

)

/*
    Deduplicate measure rows by latest evidence date or exclusion date
*/
, deduped as (

    select
          patient_id
        , denominator_flag
        , numerator_flag
        , exclusion_flag
        , evidence_date
        , evidence_value
        , exclusion_date
        , exclusion_reason
        , performance_period_begin
        , performance_period_end
        , measure_id
        , measure_name
        , measure_version
    from measure_flags
    where rn = 1

)

, add_data_types as (

    select
          cast(patient_id as {{ dbt.type_string() }}) as patient_id
        , cast(denominator_flag as integer) as denominator_flag
        , cast(numerator_flag as integer) as numerator_flag
        , cast(exclusion_flag as integer) as exclusion_flag
        , cast(evidence_date as date) as evidence_date
        , cast(evidence_value as {{ dbt.type_string() }}) as evidence_value
        , cast(exclusion_date as date) as exclusion_date
        , cast(exclusion_reason as {{ dbt.type_string() }}) as exclusion_reason
        , cast(performance_period_begin as date) as performance_period_begin
        , cast(performance_period_end as date) as performance_period_end
        , cast(measure_id as {{ dbt.type_string() }}) as measure_id
        , cast(measure_name as {{ dbt.type_string() }}) as measure_name
        , cast(measure_version as {{ dbt.type_string() }}) as measure_version
    from deduped

)

select
      patient_id
    , denominator_flag
    , numerator_flag
    , exclusion_flag
    , evidence_date
    , evidence_value
    , exclusion_date
    , exclusion_reason
    , performance_period_begin
    , performance_period_end
    , measure_id
    , measure_name
    , measure_version
    , '{{ var('tuva_last_run')}}' as tuva_last_run
from add_data_types
