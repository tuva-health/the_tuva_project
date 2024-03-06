{{ config(
     enabled = var('claims_enabled',var('clinical_enabled',var('tuva_marts_enabled',False)))
   )
}}


with all_procedures as (
{% if var('clinical_enabled', var('tuva_marts_enabled',False)) == true and var('claims_enabled', var('tuva_marts_enabled',False)) == true -%}

select * from {{ ref('core__stg_claims_procedure') }}
union all
select * from {{ ref('core__stg_clinical_procedure') }}

{% elif var('clinical_enabled', var('tuva_marts_enabled',False)) == true -%}

select * from {{ ref('core__stg_clinical_procedure') }}

{% elif var('claims_enabled', var('tuva_marts_enabled',False)) == true -%}

select * from {{ ref('core__stg_claims_procedure') }}

{%- endif %}
)

{% if var('enable_normalize_engine',false) != true %}
select
    all_procedures.PROCEDURE_ID
  , all_procedures.PATIENT_ID
  , all_procedures.ENCOUNTER_ID
  , all_procedures.CLAIM_ID
  , all_procedures.PROCEDURE_DATE
  , all_procedures.SOURCE_CODE_TYPE
  , all_procedures.SOURCE_CODE
  , all_procedures.SOURCE_DESCRIPTION
  , case when all_procedures.NORMALIZED_CODE_TYPE is not null then  all_procedures.NORMALIZED_CODE_TYPE
      when icd10.icd_10_pcs is not null then 'icd-10-pcs'
      when icd9.icd_9_pcs is not null then 'icd-9-pcs'
      when hcpcs.hcpcs is not null then 'hcpcs'
      when snomed.conceptid is not null then 'snomed-ct'
      else null end NORMALIZED_CODE_TYPE
  , coalesce(all_procedures.NORMALIZED_CODE
      , icd10.icd_10_pcs
      , icd9.icd_9_pcs
      , hcpcs.hcpcs
      ,snomed.CONCEPTID) as NORMALIZED_CODE

  ,  coalesce(all_procedures.NORMALIZED_DESCRIPTION
      , icd10.desciption
      , icd9.description
      , hcpcs.long_description
      , snomed.term) NORMALIZED_DESCRIPTION
  , all_procedures.MODIFIER_1
  , all_procedures.MODIFIER_2
  , all_procedures.MODIFIER_3
  , all_procedures.MODIFIER_4
  , all_procedures.MODIFIER_5
  , all_procedures.PRACTITIONER_ID
  , all_procedures.DATA_SOURCE
  , all_procedures.TUVA_LAST_RUN
from all_procedures
left join {{ ref('terminology__icd_10_cm') }} icd10
    on all_conditions.source_code_type = 'icd-10-pcs'
        and all_conditions.source_code = icd10.icd_10_pcs
left join {{ ref('terminology__icd_9_cm') }} icd9
    on all_conditions.source_code_type = 'icd-9-pcs'
        and all_conditions.source_code = icd9.icd_9_pcs
left join {{ ref('terminology__hcpcs_level_2') }} hcpcs
    on all_conditions.source_code_type = 'hcpcs'
        and all_conditions.source_code = hcpcs.hcpcs
left join health_gorilla.terminology.snomed snomed
    on all_conditions.source_code_type = 'snomed-ct'
        and all_conditions.source_code = snomed.conceptid
{% else %}

select
    all_procedures.PROCEDURE_ID
  , all_procedures.PATIENT_ID
  , all_procedures.ENCOUNTER_ID
  , all_procedures.CLAIM_ID
  , all_procedures.PROCEDURE_DATE
  , all_procedures.SOURCE_CODE_TYPE
  , all_procedures.SOURCE_CODE
  , all_procedures.SOURCE_DESCRIPTION
  , case when all_procedures.NORMALIZED_CODE_TYPE is not null then  all_procedures.NORMALIZED_CODE_TYPE
      when icd10.icd_10_pcs is not null then 'icd-10-pcs'
      when icd9.icd_9_pcs is not null then 'icd-9-pcs'
      when hcpcs.hcpcs is not null then 'hcpcs'
      when snomed.conceptid is not null then 'snomed-ct'
      else null end as NORMALIZED_CODE_TYPE
  , coalesce(all_procedures.NORMALIZED_CODE
      , icd10.icd_10_pcs
      , icd9.icd_9_pcs
      , hcpcs.hcpcs
      ,snomed.CONCEPTID
      ,custom_mapped.normalized_description  ) as NORMALIZED_CODE
  ,  coalesce(all_procedures.NORMALIZED_DESCRIPTION
      , icd10.desciption
      , icd9.description
      , hcpcs.long_description
      , snomed.term)
  , all_procedures.MODIFIER_1
  , all_procedures.MODIFIER_2
  , all_procedures.MODIFIER_3
  , all_procedures.MODIFIER_4
  , all_procedures.MODIFIER_5
  , all_procedures.PRACTITIONER_ID
  , all_procedures.DATA_SOURCE
  , all_procedures.TUVA_LAST_RUN
from all_procedures
left join {{ ref('terminology__icd_10_cm') }} icd10
    on all_conditions.source_code_type = 'icd-10-pcs'
        and all_conditions.source_code = icd10.icd_10_pcs
left join {{ ref('terminology__icd_9_cm') }} icd9
    on all_conditions.source_code_type = 'icd-9-pcs'
        and all_conditions.source_code = icd9.icd_9_pcs
left join {{ ref('terminology__hcpcs_level_2') }} hcpcs
    on all_conditions.source_code_type = 'hcpcs'
        and all_conditions.source_code = hcpcs.hcpcs
left join health_gorilla.terminology.snomed snomed
    on all_conditions.source_code_type = 'snomed-ct'
        and all_conditions.source_code = snomed.conceptid
left join {{ source('normalize_engine','custom_mapped') }} custom_mapped
    on custom_mapped.table = 'procedure'
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