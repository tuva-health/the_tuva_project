{{ config(
     enabled = var('quality_measures_reporting_enabled',var('tuva_marts_enabled',True))
   )
}}

/*
    Patients greater than or equal to 66 with at least one claim/encounter for frailty
    during the measurement period AND a dispensed medication for dementia during the measurement period
    or year prior to measurement period
*/

with denominator as (

    select
          patient_id
        , age
        , performance_period_begin
        , performance_period_end
    from {{ ref('quality_measures_reporting__int_nqf2372_denominator') }}

)

, exclusion_codes as (

    select
          code
        , code_system
        , concept_name
    from {{ ref('quality_measures_reporting__value_sets') }}
    where concept_name in (
          'Frailty Device'
        , 'Frailty Diagnosis'
        , 'Frailty Encounter'
        , 'Frailty Symptom'
        , 'Dementia Medications'
    )

)

, conditions as (

    select
          patient_id
        , condition_date
        , code_type
        , code
    from {{ ref('quality_measures_reporting__stg_core__condition') }}

)

, medical_claim as (

    select
          patient_id
        , claim_start_date
        , claim_end_date
        , hcpcs_code
        , place_of_service_code
    from {{ ref('quality_measures_reporting__stg_medical_claim') }}

)

, pharmacy_claim as (

    select
          patient_id
        , dispensing_date
        , ndc_code
        , paid_date
    from {{ ref('quality_measures_reporting__stg_pharmacy_claim') }}

)

, procedures as (

    select
          patient_id
        , procedure_date
        , code_type
        , code
    from {{ ref('quality_measures_reporting__stg_core__procedure') }}

)

, med_claim_exclusions as (

    select
          medical_claim.patient_id
        , medical_claim.claim_start_date
        , medical_claim.claim_end_date
        , medical_claim.hcpcs_code
        , exclusion_codes.concept_name
    from medical_claim
         inner join exclusion_codes
         on medical_claim.hcpcs_code = exclusion_codes.code
    where exclusion_codes.code_system = 'hcpcs'

)

, pharmacy_claim_exclusions as (

    select
          pharmacy_claim.patient_id
        , pharmacy_claim.dispensing_date
        , pharmacy_claim.ndc_code
        , pharmacy_claim.paid_date
        , exclusion_codes.concept_name
    from pharmacy_claim
         inner join exclusion_codes
         on pharmacy_claim.ndc_code = exclusion_codes.code
    where exclusion_codes.code_system = 'ndc'

)

, condition_exclusions as (

    select
          conditions.patient_id
        , conditions.condition_date
        , conditions.code_type
        , conditions.code
        , exclusion_codes.concept_name
    from conditions
         inner join exclusion_codes
         on conditions.code = exclusion_codes.code
         and conditions.code_type = exclusion_codes.code_system

)

, procedure_exclusions as (

    select
          procedures.patient_id
        , procedures.procedure_date
        , procedures.code_type
        , procedures.code
        , exclusion_codes.concept_name
    from procedures
         inner join exclusion_codes
         on procedures.code = exclusion_codes.code
         and procedures.code_type = exclusion_codes.code_system

)

, patients_with_frailty as (

    select
          denominator.patient_id
        , denominator.performance_period_begin
        , denominator.performance_period_end
        , coalesce(
              med_claim_exclusions.claim_start_date
            , med_claim_exclusions.claim_end_date
          ) as exclusion_date
        , med_claim_exclusions.concept_name
    from denominator
         inner join med_claim_exclusions
         on denominator.patient_id = med_claim_exclusions.patient_id
    where denominator.age >= 66
    and med_claim_exclusions.concept_name in (
          'Frailty Device'
        , 'Frailty Diagnosis'
        , 'Frailty Encounter'
        , 'Frailty Symptom'
    )
    and (
        med_claim_exclusions.claim_start_date
            between denominator.performance_period_begin
            and denominator.performance_period_end
        or med_claim_exclusions.claim_end_date
            between denominator.performance_period_begin
            and denominator.performance_period_end
    )

    union all

    select
          denominator.patient_id
        , denominator.performance_period_begin
        , denominator.performance_period_end
        , condition_exclusions.condition_date as exclusion_date
        , condition_exclusions.concept_name
    from denominator
         inner join condition_exclusions
         on denominator.patient_id = condition_exclusions.patient_id
    where denominator.age >= 66
    and condition_exclusions.concept_name in (
          'Frailty Device'
        , 'Frailty Diagnosis'
        , 'Frailty Encounter'
        , 'Frailty Symptom'
    )
    and condition_exclusions.condition_date
        between denominator.performance_period_begin
        and denominator.performance_period_end

    union all

    select
          denominator.patient_id
        , denominator.performance_period_begin
        , denominator.performance_period_end
        , procedure_exclusions.procedure_date as exclusion_date
        , procedure_exclusions.concept_name
    from denominator
         inner join procedure_exclusions
         on denominator.patient_id = procedure_exclusions.patient_id
    where denominator.age >= 66
    and procedure_exclusions.concept_name in (
          'Frailty Device'
        , 'Frailty Diagnosis'
        , 'Frailty Encounter'
        , 'Frailty Symptom'
    )
    and procedure_exclusions.procedure_date
        between denominator.performance_period_begin
        and denominator.performance_period_end

)

, frailty_with_dementia as (

    select
          patients_with_frailty.patient_id
        , patients_with_frailty.exclusion_date
        , concat (
              patients_with_frailty.concept_name
            , ' with '
            , pharmacy_claim_exclusions.concept_name
          ) as exclusion_reason
    from patients_with_frailty
         inner join pharmacy_claim_exclusions
         on patients_with_frailty.patient_id = pharmacy_claim_exclusions.patient_id
    where (
        pharmacy_claim_exclusions.dispensing_date
            between patients_with_frailty.performance_period_begin
            and patients_with_frailty.performance_period_end
        or pharmacy_claim_exclusions.paid_date
            between patients_with_frailty.performance_period_begin
            and patients_with_frailty.performance_period_end
    )

)

select distinct
      patient_id
    , exclusion_date
    , exclusion_reason
from frailty_with_dementia