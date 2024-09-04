{{ config(
     enabled = var('hcc_suspecting_enabled',var('claims_enabled',var('clinical_enabled',var('tuva_marts_enabled',False)))) | as_bool
   )
}}

with conditions as (

    select
          patient_id
        , recorded_date
        , condition_type
        , code_type
        , code
        , data_source
    from {{ ref('hcc_suspecting__int_prep_conditions') }}

)

, observations as (

    select
          patient_id
        , observation_date
        , result
        , code_type
        , code
        , data_source
    from {{ ref('hcc_suspecting__stg_core__observation') }}

)

, numeric_observations as (

    select
          patient_id
        , observation_date
        {% if target.type == 'fabric' %}
         , TRY_CAST(result AS {{ dbt.type_numeric() }}) AS result
        {% else %}
        , CAST(result AS {{ dbt.type_numeric() }}) AS result
        {% endif %}
        , code_type
        , code
        , data_source
    from observations
   {% if target.type == 'fabric' %}
        WHERE result LIKE '%.%' OR result LIKE '%[0-9]%'
        AND result NOT LIKE '%[^0-9.]%'
    {% else %}
        where {{ apply_regex('result', '^[+-]?([0-9]*[.])?[0-9]+$') }}
    {% endif %}

)

, seed_clinical_concepts as (

    select
          concept_name
        , code
        , code_system
    from {{ ref('hcc_suspecting__clinical_concepts') }}

)

, seed_hcc_descriptions as (

    select distinct
          hcc_code
        , hcc_description
    from {{ ref('hcc_suspecting__hcc_descriptions') }}

)

, billed_hccs as (

    select distinct
          patient_id
        , data_source
        , hcc_code
        , current_year_billed
    from {{ ref('hcc_suspecting__int_patient_hcc_history') }}

)

, depression_assessment as (

    select
          numeric_observations.patient_id
        , numeric_observations.observation_date
        , numeric_observations.result
        , numeric_observations.code_type
        , numeric_observations.code
        , numeric_observations.data_source
        , seed_clinical_concepts.concept_name
    from numeric_observations
        inner join seed_clinical_concepts
            on numeric_observations.code_type = seed_clinical_concepts.code_system
            and numeric_observations.code = seed_clinical_concepts.code
    where lower(seed_clinical_concepts.concept_name) = 'depression assessment (phq-9)'

)

, diabetes as (

     select
          conditions.patient_id
        , conditions.recorded_date
        , conditions.condition_type
        , conditions.code_type
        , conditions.code
        , conditions.data_source
        , seed_clinical_concepts.concept_name
    from conditions
        inner join seed_clinical_concepts
            on conditions.code_type = seed_clinical_concepts.code_system
            and conditions.code = seed_clinical_concepts.code
    where lower(seed_clinical_concepts.concept_name) = 'diabetes'

)

, hypertension as (

     select
          conditions.patient_id
        , conditions.recorded_date
        , conditions.condition_type
        , conditions.code_type
        , conditions.code
        , conditions.data_source
        , seed_clinical_concepts.concept_name
    from conditions
        inner join seed_clinical_concepts
            on conditions.code_type = seed_clinical_concepts.code_system
            and conditions.code = seed_clinical_concepts.code
    where lower(seed_clinical_concepts.concept_name) = 'essential hypertension'

)

, obstructive_sleep_apnea as (

     select
          conditions.patient_id
        , conditions.recorded_date
        , conditions.condition_type
        , conditions.code_type
        , conditions.code
        , conditions.data_source
        , seed_clinical_concepts.concept_name
    from conditions
        inner join seed_clinical_concepts
            on conditions.code_type = seed_clinical_concepts.code_system
            and conditions.code = seed_clinical_concepts.code
    where lower(seed_clinical_concepts.concept_name) = 'obstructive sleep apnea'

)

/* BEGIN HCC 48 logic (Morbid Obesity) */
, bmi_over_30_with_osa as (

    select
          numeric_observations.patient_id
        , numeric_observations.data_source
        , numeric_observations.observation_date
        , numeric_observations.result as observation_result
        , obstructive_sleep_apnea.code as condition_code
        , obstructive_sleep_apnea.recorded_date as condition_date
        , obstructive_sleep_apnea.concept_name as condition_concept_name
        , seed_hcc_descriptions.hcc_code
        , seed_hcc_descriptions.hcc_description
    from numeric_observations
        inner join seed_clinical_concepts
            on numeric_observations.code_type = seed_clinical_concepts.code_system
            and numeric_observations.code = seed_clinical_concepts.code
        inner join obstructive_sleep_apnea
            on numeric_observations.patient_id = obstructive_sleep_apnea.patient_id
            /* ensure bmi and condition overlaps in the same year */
            and {{ date_part('year', 'numeric_observations.observation_date') }} = {{ date_part('year', 'obstructive_sleep_apnea.recorded_date') }}
        inner join seed_hcc_descriptions
            on hcc_code = '48'
    where lower(seed_clinical_concepts.concept_name) = 'bmi'
    and result >= 30

)

, bmi_over_35_with_diabetes as (

    select
          numeric_observations.patient_id
        , numeric_observations.data_source
        , numeric_observations.observation_date
        , numeric_observations.result as observation_result
        , diabetes.code as condition_code
        , diabetes.recorded_date as condition_date
        , diabetes.concept_name as condition_concept_name
        , seed_hcc_descriptions.hcc_code
        , seed_hcc_descriptions.hcc_description
    from numeric_observations
        inner join seed_clinical_concepts
            on numeric_observations.code_type = seed_clinical_concepts.code_system
            and numeric_observations.code = seed_clinical_concepts.code
        inner join diabetes
            on numeric_observations.patient_id = diabetes.patient_id
            /* ensure bmi and condition overlaps in the same year */
            and {{ date_part('year', 'numeric_observations.observation_date') }} = {{ date_part('year', 'diabetes.recorded_date') }}
        inner join seed_hcc_descriptions
            on hcc_code = '48'
    where lower(seed_clinical_concepts.concept_name) = 'bmi'
    and result >= 35

)

, bmi_over_35_with_hypertension as (

    select
          numeric_observations.patient_id
        , numeric_observations.data_source
        , numeric_observations.observation_date
        , numeric_observations.result as observation_result
        , hypertension.code as condition_code
        , hypertension.recorded_date as condition_date
        , hypertension.concept_name as condition_concept_name
        , seed_hcc_descriptions.hcc_code
        , seed_hcc_descriptions.hcc_description
    from numeric_observations
        inner join seed_clinical_concepts
            on numeric_observations.code_type = seed_clinical_concepts.code_system
            and numeric_observations.code = seed_clinical_concepts.code
        inner join hypertension
            on numeric_observations.patient_id = hypertension.patient_id
            /* ensure bmi and condition overlaps in the same year */
            and {{ date_part('year', 'numeric_observations.observation_date') }} = {{ date_part('year', 'hypertension.recorded_date') }}
        inner join seed_hcc_descriptions
            on hcc_code = '48'
    where lower(seed_clinical_concepts.concept_name) = 'bmi'
    and result >= 35

)

, bmi_over_40 as (

    select
          numeric_observations.patient_id
        , numeric_observations.data_source
        , numeric_observations.observation_date
        , numeric_observations.result as observation_result
        , cast(null as {{ dbt.type_string() }}) as condition_code
        , cast(null as date) as condition_date
        , cast(null as {{ dbt.type_string() }}) as condition_concept_name
        , seed_hcc_descriptions.hcc_code
        , seed_hcc_descriptions.hcc_description
    from numeric_observations
        inner join seed_clinical_concepts
            on numeric_observations.code_type = seed_clinical_concepts.code_system
            and numeric_observations.code = seed_clinical_concepts.code
        inner join seed_hcc_descriptions
            on hcc_code = '48'
    where lower(seed_clinical_concepts.concept_name) = 'bmi'
    and result >= 40

)

, hcc_48_unioned as (

    select * from bmi_over_30_with_osa
    union all
    select * from bmi_over_35_with_diabetes
    union all
    select * from bmi_over_35_with_hypertension
    union all
    select * from bmi_over_40

)

, hcc_48_suspect as (

    select
          patient_id
        , data_source
        , observation_date
        , observation_result
        , condition_code
        , condition_date
        , condition_concept_name
        , hcc_code
        , hcc_description
        , {{ dbt.concat([
            "'BMI result '",
            "observation_result",
            "case"
            " when condition_code is null then '' "
            " else " ~
            dbt.concat(["' with '",
                        "condition_concept_name",
                        "'('",
                        "condition_code",
                        "' on '",
                        "condition_date",
                        "')'"]) ~
            " end"
        ]) }} as contributing_factor
    from hcc_48_unioned

)
/* END HCC 48 logic */

/* BEGIN HCC 155 logic (Major Depression, Moderate or Severe, without Psychosis)

   to determine a positive PHQ-9 assessment, we look at the past 3 screenings
   for a patient and take the highest result
*/
, eligible_depression_assessments as (

    select
          depression_assessment.patient_id
        , depression_assessment.observation_date
        , depression_assessment.result
        , depression_assessment.code_type
        , depression_assessment.code
        , depression_assessment.data_source
        , depression_assessment.concept_name
        , row_number() over (
            partition by
                  depression_assessment.patient_id
                , depression_assessment.data_source
            order by
                case when depression_assessment.observation_date is null then 1 else 0 end,
                depression_assessment.observation_date desc
        ) assessment_order
    from depression_assessment

)

, depression_assessments_ordered as (

    select
          patient_id
        , observation_date
        , code_type
        , code
        , data_source
        , concept_name
        , result
        , row_number() over (
            partition by
                  patient_id
                , data_source
            --order by result desc nulls last
            order by
                case when result is null then 1 else 0 end,
                result desc
        ) as result_order --order the last three assessments by result value
    from eligible_depression_assessments
    where assessment_order <= 3

)

, hcc_155_suspect as (

    select
          depression_assessments_ordered.patient_id
        , depression_assessments_ordered.data_source
        , depression_assessments_ordered.observation_date
        , depression_assessments_ordered.result as observation_result
        , cast(null as {{ dbt.type_string() }}) as condition_code
        , cast(null as date) as condition_date
        , depression_assessments_ordered.concept_name as condition_concept_name
        , seed_hcc_descriptions.hcc_code
        , seed_hcc_descriptions.hcc_description
        , {{ dbt.concat([
            "'PHQ-9 result '",
            "depression_assessments_ordered.result",
            "' on '",
            "depression_assessments_ordered.observation_date"]) }} as contributing_factor
    from depression_assessments_ordered
        inner join seed_hcc_descriptions
            on hcc_code = '155'
    where result_order = 1
    and result >= 15

)

/* END HCC 155 logic */

, unioned as (

    select * from hcc_48_suspect
    union all
    select * from hcc_155_suspect

)

, add_billed_flag as (

    select
          unioned.patient_id
        , unioned.data_source
        , unioned.observation_date
        , unioned.observation_result
        , unioned.condition_code
        , unioned.condition_date
        , unioned.condition_concept_name
        , unioned.hcc_code
        , unioned.hcc_description
        , unioned.contributing_factor
        , billed_hccs.current_year_billed
    from unioned
        left join billed_hccs
            on unioned.patient_id = billed_hccs.patient_id
            and unioned.data_source = billed_hccs.data_source
            and unioned.hcc_code = billed_hccs.hcc_code

)

, add_standard_fields as (

    select
          patient_id
        , data_source
        , observation_date
        , observation_result
        , condition_code
        , condition_date
        , condition_concept_name
        , hcc_code
        , hcc_description
        , contributing_factor
        , current_year_billed
        , cast('Observation suspect' as {{ dbt.type_string() }}) as reason
        , observation_date as suspect_date
    from add_billed_flag

)

, add_data_types as (

    select
          cast(patient_id as {{ dbt.type_string() }}) as patient_id
        , cast(data_source as {{ dbt.type_string() }}) as data_source
        , cast(observation_date as date) as observation_date
        , cast(observation_result as {{ dbt.type_string() }}) as observation_result
        , cast(condition_code as {{ dbt.type_string() }}) as condition_code
        , cast(condition_date as date) as condition_date
        , cast(condition_concept_name as {{ dbt.type_string() }}) as condition_concept_name
        , cast(hcc_code as {{ dbt.type_string() }}) as hcc_code
        , cast(hcc_description as {{ dbt.type_string() }}) as hcc_description
        {% if target.type == 'fabric' %}
            , cast(current_year_billed as bit) as current_year_billed
        {% else %}
            , cast(current_year_billed as boolean) as current_year_billed
        {% endif %}
        , cast(reason as {{ dbt.type_string() }}) as reason
        , cast(contributing_factor as {{ dbt.type_string() }}) as contributing_factor
        , cast(suspect_date as date) as suspect_date
    from add_standard_fields

)

select
      patient_id
    , data_source
    , observation_date
    , observation_result
    , condition_code
    , condition_date
    , condition_concept_name
    , hcc_code
    , hcc_description
    , current_year_billed
    , reason
    , contributing_factor
    , suspect_date
    , '{{ var('tuva_last_run')}}' as tuva_last_run
from add_data_types