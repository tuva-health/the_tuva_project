{{ config(
     enabled = var('quality_measures_enabled',var('claims_enabled',var('clinical_enabled',var('tuva_marts_enabled',False)))) | as_bool
   )
}}

/*
    Each measure is pivoted into a boolean column by evaluating the
    denominator, numerator, and exclusion flags.
*/
with measures_long as (

        select
          patient_id
        , denominator_flag
        , numerator_flag
        , exclusion_flag
        , performance_flag
        , measure_id
    from {{ ref('quality_measures__summary_long') }}

)

, cqm_438 as (

    select
          patient_id
        , performance_flag
    from measures_long
    where measure_id = 'CQM438'

)

, cqm_130 as (

    select
          patient_id
        , performance_flag
    from measures_long
    where measure_id = 'CQM130'

)

, nqf_0420 as (

    select
          patient_id
        , performance_flag
    from measures_long
    where measure_id = 'NQF0420'

)

, adh_diabetes as (

    select
          patient_id
        , performance_flag
    from measures_long
    where measure_id = 'ADH-Diabetes'

)

, adh_ras as (

    select
          patient_id
        , performance_flag
    from measures_long
    where measure_id = 'ADH-RAS'
    
)

, supd as (

    select
          patient_id
        , performance_flag
    from measures_long
    where measure_id = 'SUPD'

)

, adh_statins as (

    select
          patient_id
        , performance_flag
    from measures_long
    where measure_id = 'ADH-Statins'

)

, joined as (

    select
          measures_long.patient_id
        , max(cqm_438.performance_flag) as cqm_438
        , max(cqm_130.performance_flag) as cqm_130
        , max(nqf_0420.performance_flag) as nqf_0420
        , max(adh_diabetes.performance_flag) as adh_diabetes
        , max(adh_ras.performance_flag) as adh_ras
        , max(supd.performance_flag) as supd
        , max(adh_statins.performance_flag) as adh_statins
    from measures_long
        left join cqm_438
            on measures_long.patient_id = cqm_438.patient_id
        left join cqm_130
            on measures_long.patient_id = cqm_130.patient_id
        left join nqf_0420
            on measures_long.patient_id = nqf_0420.patient_id
        left join adh_diabetes
            on measures_long.patient_id = adh_diabetes.patient_id
        left join adh_ras
            on measures_long.patient_id = adh_ras.patient_id
        left join supd
            on measures_long.patient_id = supd.patient_id
        left join adh_statins
            on measures_long.patient_id = adh_statins.patient_id
    group by measures_long.patient_id

)

, add_data_types as (

    select
          cast(patient_id as {{ dbt.type_string() }}) as patient_id
        , cast(cqm_438 as integer) as cqm_438
        , cast(cqm_130 as integer) as cqm_130
        , cast(nqf_0420 as integer) as nqf_0420
        , cast(adh_diabetes as integer) as adh_diabetes
        , cast(adh_ras as integer) as adh_ras
        , cast(supd as integer) as supd
        , cast(adh_statins as integer) as adh_statins
    from joined

)

select
      patient_id
    , adh_diabetes
    , adh_ras
    , adh_statins
    , cqm_130
    , cqm_438
    , nqf_0420
    , supd
    , '{{ var('tuva_last_run')}}' as tuva_last_run
from add_data_types