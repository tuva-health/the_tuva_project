{{ config(
     enabled = var('clinical_enabled',var('tuva_marts_enabled',False))
 | as_bool
   )
}}

{% if var('enable_normalize_engine',false) != true %}


select
      labs.LAB_RESULT_ID
    , labs.PATIENT_ID
    , labs.ENCOUNTER_ID
    , labs.ACCESSION_NUMBER
    , labs.SOURCE_CODE_TYPE
    , labs.SOURCE_CODE
    , labs.SOURCE_DESCRIPTION
    , labs.SOURCE_COMPONENT
    , case
        when labs.NORMALIZED_CODE_TYPE is not null then labs.NORMALIZED_CODE_TYPE
        when loinc.loinc is not null then 'loinc'
        when snomed.conceptid is not null then 'snomed-ct'
        else null end as NORMALIZED_CODE_TYPE
    , case
        when labs.NORMALIZED_CODE is not null then labs.NORMALIZED_CODE
        when loinc.loinc is not null then loinc.loinc
        when snomed.conceptid is not null then snomed.conceptid
        else null end as NORMALIZED_CODE
    , case
        when labs.NORMALIZED_DESCRIPTION is not null then labs.NORMALIZED_DESCRIPTION
        when loinc.long_common_name is not null then loinc.long_common_name
        when snomed.term is not null then snomed.term
        else null end as NORMALIZED_CODE
    , case when coalesce(labs.NORMALIZED_CODE, labs.NORMALIZED_DESCRIPTION) is not null then 'manual'
         when coalesce(LOINC.loinc,loinc.long_common_name,snomed.conceptid,snomed.term) is not null then 'automatic'
         end as mapping_method
    , labs.NORMALIZED_COMPONENT
    , labs.STATUS
    , labs.RESULT
    , labs.RESULT_DATE
    , labs.COLLECTION_DATE
    , labs.SOURCE_UNITS
    , labs.NORMALIZED_UNITS
    , labs.SOURCE_REFERENCE_RANGE_LOW
    , labs.SOURCE_REFERENCE_RANGE_HIGH
    , labs.NORMALIZED_REFERENCE_RANGE_LOW
    , labs.NORMALIZED_REFERENCE_RANGE_HIGH
    , labs.SOURCE_ABNORMAL_FLAG
    , labs.NORMALIZED_ABNORMAL_FLAG
    , labs.SPECIMEN
    , labs.ORDERING_PRACTITIONER_ID
    , labs.DATA_SOURCE
    , labs.TUVA_LAST_RUN
From {{ ref('core__stg_clinical_lab_result')}} as labs
left join {{ ref('terminology__loinc') }} loinc
    on labs.source_code_type = 'loinc'
        and all_procedures.source_code = loinc.loinc
left join health_gorilla.terminology.snomed snomed
    on labs.source_code_type = 'snomed-ct'
        and labs.source_code = snomed.conceptid

 {% else %}

select
      labs.LAB_RESULT_ID
    , labs.PATIENT_ID
    , labs.ENCOUNTER_ID
    , labs.ACCESSION_NUMBER
    , labs.SOURCE_CODE_TYPE
    , labs.SOURCE_CODE
    , labs.SOURCE_DESCRIPTION
    , labs.SOURCE_COMPONENT
    , case
        when labs.NORMALIZED_CODE_TYPE is not null then labs.NORMALIZED_CODE_TYPE
        when loinc.loinc is not null then 'loinc'
        when snomed.conceptid is not null then 'snomed-ct'
        else null end as NORMALIZED_CODE_TYPE
    , case
        when labs.NORMALIZED_CODE is not null then labs.NORMALIZED_CODE
        when loinc.loinc is not null then loinc.loinc
        when snomed.conceptid is not null then snomed.conceptid
        else null end as NORMALIZED_CODE
    , case
        when labs.NORMALIZED_DESCRIPTION is not null then labs.NORMALIZED_DESCRIPTION
        when loinc.long_common_name is not null then loinc.long_common_name
        when snomed.term is not null then snomed.term
        else null end as NORMALIZED_CODE
  , case case when coalesce(labs.NORMALIZED_CODE, labs.NORMALIZED_DESCRIPTION) is not null then 'manual'
        when coalesce(custom_mapped.normalized_code,custom_mapped.normalized_description) is not null and custom_mapped.not_mapped is null then 'custom'
        when custom_mapped.not_mapped is not null then custom_mapped.not_mapped
        when coalesce(LOINC.loinc,loinc.long_common_name,snomed.conceptid,snomed.term) is not null then 'automatic'
        end as mapping_method
    , labs.NORMALIZED_COMPONENT
    , labs.STATUS
    , labs.RESULT
    , labs.RESULT_DATE
    , labs.COLLECTION_DATE
    , labs.SOURCE_UNITS
    , labs.NORMALIZED_UNITS
    , labs.SOURCE_REFERENCE_RANGE_LOW
    , labs.SOURCE_REFERENCE_RANGE_HIGH
    , labs.NORMALIZED_REFERENCE_RANGE_LOW
    , labs.NORMALIZED_REFERENCE_RANGE_HIGH
    , labs.SOURCE_ABNORMAL_FLAG
    , labs.NORMALIZED_ABNORMAL_FLAG
    , labs.SPECIMEN
    , labs.ORDERING_PRACTITIONER_ID
    , labs.DATA_SOURCE
    , labs.TUVA_LAST_RUN
From  {{ ref('core__stg_clinical_lab_result')}} as labs
left join {{ ref('terminology__loinc') }} loinc
    on labs.source_code_type = 'loinc'
        and all_procedures.source_code = loinc.loinc
left join health_gorilla.terminology.snomed snomed
    on labs.source_code_type = 'snomed-ct'
        and labs.source_code = snomed.conceptid
left join {{ source('normalize_engine','custom_mapped') }} custom_mapped
    on custom_mapped.domain = 'lab_result'
        and ( lower(labs.source_code_type) = lower(custom_mapped.source_code_type)
            or ( labs.source_code_type is null and custom_mapped.source_code_type is null)
            )
        and (labs.source_code = custom_mapped.source_code
            or ( labs.source_code is null and custom_mapped.source_code is null)
            )
        and (labs.source_description = custom_mapped.source_description
            or ( labs.source_description is null and custom_mapped.source_description is null)
            )
        and not (labs.source_code is null and labs.source_description is null)
{% endif %}