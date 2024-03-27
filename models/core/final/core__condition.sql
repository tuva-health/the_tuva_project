{{ config(
     enabled = var('claims_enabled',var('clinical_enabled',var('tuva_marts_enabled',False)))
 | as_bool
   )
}}


with all_conditions as (
   {% if var('clinical_enabled'
   , var('tuva_marts_enabled'
   , False)) == true and var('claims_enabled'
   , var('tuva_marts_enabled'
   , False)) == true -%}

select *
from {{ ref('core__stg_claims_condition') }}
union all
select *
from {{ ref('core__stg_clinical_condition') }}

{% elif var('clinical_enabled', var('tuva_marts_enabled',False)) == true -%}

select *
from {{ ref('core__stg_clinical_condition') }}

{% elif var('claims_enabled', var('tuva_marts_enabled',False)) == true -%}

select *
from {{ ref('core__stg_claims_condition') }}

{%- endif %}
)



{% if var('enable_normalize_engine',false) != true %}
select
    all_conditions.CONDITION_ID
  , all_conditions.PATIENT_ID
  , all_conditions.ENCOUNTER_ID
  , all_conditions.CLAIM_ID
  , all_conditions.RECORDED_DATE
  , all_conditions.ONSET_DATE
  , all_conditions.RESOLVED_DATE
  , all_conditions.STATUS
  , all_conditions.CONDITION_TYPE
  , all_conditions.SOURCE_CODE_TYPE
  , all_conditions.SOURCE_CODE
  , all_conditions.SOURCE_DESCRIPTION
  , case
        when all_conditions.NORMALIZED_CODE_TYPE is not null then all_conditions.NORMALIZED_CODE_TYPE
        when icd10.icd_10_cm is not null then 'icd-10-cm'
        when icd9.icd_9_cm is not null then 'icd-9-cm'
        else null end as NORMALIZED_CODE_TYPE
  , coalesce(
        all_conditions.NORMALIZED_CODE
      , icd10.icd_10_cm
      , icd9.icd_9_cm ) as NORMALIZED_CODE
  , coalesce(
        all_conditions.NORMALIZED_DESCRIPTION
      , icd10.description
      , icd9.long_description) as NORMALIZED_DESCRIPTION
  , case when coalesce(all_conditions.NORMALIZED_CODE, all_conditions.NORMALIZED_DESCRIPTION) is not null then 'manual'
         when coalesce(icd10.icd_10_cm,icd10.description,icd9.icd_9_cm,icd9.long_description) is not null then 'automatic'
         end as mapping_method
  , all_conditions.CONDITION_RANK
  , all_conditions.PRESENT_ON_ADMIT_CODE
  , all_conditions.PRESENT_ON_ADMIT_DESCRIPTION
  , all_conditions.DATA_SOURCE
  , all_conditions.TUVA_LAST_RUN
from
all_conditions
left join {{ ref('terminology__icd_10_cm') }} icd10
    on all_conditions.source_code_type = 'icd-10-cm'
        and all_conditions.source_code = icd10.icd_10_cm
left join {{ ref('terminology__icd_9_cm') }} icd9
    on all_conditions.source_code_type = 'icd-9-cm'
        and all_conditions.source_code = icd9.icd_9_cm

{% else %}
select
    all_conditions.CONDITION_ID
  , all_conditions.PATIENT_ID
  , all_conditions.ENCOUNTER_ID
  , all_conditions.CLAIM_ID
  , all_conditions.RECORDED_DATE
  , all_conditions.ONSET_DATE
  , all_conditions.RESOLVED_DATE
  , all_conditions.STATUS
  , all_conditions.CONDITION_TYPE
  , all_conditions.SOURCE_CODE_TYPE
  , all_conditions.SOURCE_CODE
  , all_conditions.SOURCE_DESCRIPTION
  , case
        when all_conditions.NORMALIZED_CODE_TYPE is not null then all_conditions.NORMALIZED_CODE_TYPE
        when icd10.icd_10_cm is not null then 'icd-10-cm'
        when icd9.icd_9_cm is not null then 'icd-9-cm'
        else custom_mapped.normalized_code_type end as NORMALIZED_CODE_TYPE
  , coalesce(
        all_conditions.NORMALIZED_CODE
      , custom_mapped.normalized_code
      , icd10.icd_10_cm
      , icd9.icd_9_cm) as NORMALIZED_CODE
  , coalesce(
        all_conditions.NORMALIZED_DESCRIPTION
      , custom_mapped.normalized_description
      , icd10.description
      , icd9.long_description) as NORMALIZED_DESCRIPTION
  , case when coalesce(all_conditions.NORMALIZED_CODE, all_conditions.NORMALIZED_DESCRIPTION) is not null then 'manual'
         when coalesce(custom_mapped.normalized_code,custom_mapped.normalized_description) is not null and custom_mapped.not_mapped is null then 'custom'
         when custom_mapped.not_mapped is not null then custom_mapped.not_mapped
         when coalesce(icd10.icd_10_cm,icd10.description,icd9.icd_9_cm,icd9.long_description) is not null then 'automatic'
         end as mapping_method
  , all_conditions.CONDITION_RANK
  , all_conditions.PRESENT_ON_ADMIT_CODE
  , all_conditions.PRESENT_ON_ADMIT_DESCRIPTION
  , all_conditions.DATA_SOURCE
  , all_conditions.TUVA_LAST_RUN
from
all_conditions
left join {{ ref('terminology__icd_10_cm') }} icd10
    on all_conditions.source_code_type = 'icd-10-cm'
        and all_conditions.source_code = icd10.icd_10_cm
left join {{ ref('terminology__icd_9_cm') }} icd9
    on all_conditions.source_code_type = 'icd-9-cm'
        and all_conditions.source_code = icd9.icd_9_cm
left join {{ source('normalize_engine','custom_mapped') }} custom_mapped
    on custom_mapped.domain = 'condition'
        and ( lower(all_conditions.source_code_type) = lower(custom_mapped.source_code_type)
            or ( all_conditions.source_code_type is null and custom_mapped.source_code_type is null)
            )
        and (all_conditions.source_code = custom_mapped.source_code
            or ( all_conditions.source_code is null and custom_mapped.source_code is null)
            )
        and (all_conditions.source_description = custom_mapped.source_description
            or ( all_conditions.source_description is null and custom_mapped.source_description is null)
            )
        and not (all_conditions.source_code is null and all_conditions.source_description is null)
{% endif %}