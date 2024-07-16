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

, nqf_2372 as (

    select
          patient_id
        , performance_flag
    from measures_long
    where measure_id = 'NQF2372'

)
, nqf_0034 as (

    select
          patient_id
        , performance_flag
    from measures_long
    where measure_id = 'NQF0034'

)

, nqf_0059 as (

    select
          patient_id
        , performance_flag
    from measures_long
    where measure_id = 'NQF0059'

)

, cqm_236 as (

    select
          patient_id
        , performance_flag
    from measures_long
    where measure_id = 'CQM236'

)

, nqf_0053 as (

    select
          patient_id
        , performance_flag
    from measures_long
    where measure_id = 'NQF0053'

)

, cbe_0055 as (

    select
          patient_id
        , performance_flag
    from measures_long
    where measure_id = 'CBE0055'

)

, nqf_0097 as (

    select
          patient_id
        , performance_flag
    from measures_long
    where measure_id = 'NQF0097'

)

, cqm_438 as (

    select
          patient_id
        , performance_flag
    from measures_long
    where measure_id = 'CQM438'

)

, nqf_0041 as (

    select
          patient_id
        , performance_flag
    from measures_long
    where measure_id = 'NQF0041'

)

, cbe_0101 as (

    select
          patient_id
        , performance_flag
    from measures_long
    where measure_id = 'CBE0101'

)

, joined as (

    select
          measures_long.patient_id
        , max(nqf_2372.performance_flag) as nqf_2372
        , max(nqf_0034.performance_flag) as nqf_0034
        , max(nqf_0059.performance_flag) as nqf_0059
        , max(cqm_236.performance_flag) as cqm_236
        , max(nqf_0053.performance_flag) as nqf_0053
        , max(cbe_0055.performance_flag) as cbe_0055
        , max(nqf_0097.performance_flag) as nqf_0097
        , max(cqm_438.performance_flag) as cqm_438
        , max(nqf_0041.performance_flag) as nqf_0041
        , max(cbe_0101.performance_flag) as cbe_0101
    from measures_long
        left join nqf_2372
            on measures_long.patient_id = nqf_2372.patient_id
        left join nqf_0034
            on measures_long.patient_id = nqf_0034.patient_id
        left join nqf_0059
            on measures_long.patient_id = nqf_0059.patient_id
        left join cqm_236
            on measures_long.patient_id = cqm_236.patient_id
        left join nqf_0053
            on measures_long.patient_id = nqf_0053.patient_id
        left join cbe_0055
            on measures_long.patient_id = cbe_0055.patient_id
        left join nqf_0097
            on measures_long.patient_id = nqf_0097.patient_id
        left join cqm_438
            on measures_long.patient_id = cqm_438.patient_id
        left join nqf_0041
            on measures_long.patient_id = nqf_0041.patient_id
        left join cbe_0101
            on measures_long.patient_id = cbe_0101.patient_id
    group by measures_long.patient_id

)

, add_data_types as (

    select
          cast(patient_id as {{ dbt.type_string() }}) as patient_id
        , cast(nqf_2372 as integer) as nqf_2372
        , cast(nqf_0034 as integer) as nqf_0034
        , cast(nqf_0059 as integer) as nqf_0059
        , cast(cqm_236 as integer) as cqm_236
        , cast(nqf_0053 as integer) as nqf_0053
        , cast(cbe_0055 as integer) as cbe_0055
        , cast(nqf_0097 as integer) as nqf_0097
        , cast(cqm_438 as integer) as cqm_438 
        , cast(nqf_0041 as integer) as nqf_0041
        , cast(cbe_0101 as integer) as cbe_0101
    from joined

)

select
      patient_id
    , nqf_2372
    , nqf_0034
    , nqf_0059
    , cqm_236
    , nqf_0053
    , cbe_0055
    , nqf_0097
    , cqm_438
    , nqf_0041
    , cbe_0101
    , '{{ var('tuva_last_run')}}' as tuva_last_run
from add_data_types
