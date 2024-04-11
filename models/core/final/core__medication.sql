{{ config(
     enabled = var('clinical_enabled',var('tuva_marts_enabled',False))
 | as_bool
   )
}}


with source_mapping as (
{% if var('enable_normalize_engine',false) != true %}
    select
     meds.MEDICATION_ID
   , meds.PATIENT_ID
   , meds.ENCOUNTER_ID
   , meds.DISPENSING_DATE
   , meds.PRESCRIBING_DATE
   , meds.SOURCE_CODE_TYPE
   , meds.SOURCE_CODE
   , meds.SOURCE_DESCRIPTION
   , case
        when meds.ndc_code is not null then meds.ndc_code
        when ndc.ndc is not null then ndc.ndc
        else null end as NDC_CODE
   ,  case
        when meds.ndc_description is not null then meds.ndc_description
        when ndc.ndc is not null then coalesce(ndc.fda_description, ndc.rxnorm_description)
        else null end as NDC_DESCRIPTION
   , case
        when meds.ndc_code is not null then 'manual'
        when ndc.ndc is not null then 'automatic'
        else null end as ndc_mapping_method
   , case
        when meds.rxnorm_code is not null then meds.RXNORM_CODE
        when rxatc.rxcui is not null then  rxatc.rxcui
        else null end as RXNORM_CODE
   , case
        when meds.rxnorm_code is not null then meds.RXNORM_CODE
        when rxatc.rxcui is not null then  rxatc.rxnorm_description
        else null end as RXNORM_DESCRIPTION
   , case
        when meds.rxnorm_code is not null then 'manual'
        when rxatc.rxcui is not null then 'automatic'
        else null end as rxnorm_mapping_method
   , case
        when meds.atc_code is not null then meds.atc_code
        when rxatc.rxcui is not null then null -- need to add codes to terminology
        else null end as ATC_CODE
   , case
        when meds.atc_description is not null then meds.atc_description
        when rxatc.rxcui is not null then rxatc.atc_4_name
        else null end as ATC_DESCRIPTION
   , case
        when meds.atc_code is not null then 'manual'
        when rxatc.atc_4_name is not null then 'automatic'
        else null end as atc_mapping_method
   , meds.ROUTE
   , meds.STRENGTH
   , meds.QUANTITY
   , meds.QUANTITY_UNIT
   , meds.DAYS_SUPPLY
   , meds.PRACTITIONER_ID
   , meds.DATA_SOURCE
   , meds.TUVA_LAST_RUN
from {{ ref('core__stg_clinical_medication')}} meds
    left join {{ref('terminology__ndc')}} ndc
        on meds.source_code_type = 'ndc'
        and meds.source_code = ndc.ndc
    left join {{ref('terminology__rxnorm_to_atc')}} rxatc
        on meds.source_code_type = 'rxnorm'
        and meds.source_code = rxatc.rxcui


{% else %}

 select
     meds.MEDICATION_ID
   , meds.PATIENT_ID
   , meds.ENCOUNTER_ID
   , meds.DISPENSING_DATE
   , meds.PRESCRIBING_DATE
   , meds.SOURCE_CODE_TYPE
   , meds.SOURCE_CODE
   , meds.SOURCE_DESCRIPTION
   , case
        when meds.ndc_code is not null then meds.ndc_code
        when ndc.ndc is not null then ndc.ndc
        when custom_mapped_ndc.normalized_code is not null then custom_mapped_ndc.normalized_code
        else null end as NDC_CODE
   ,  case
        when meds.ndc_description is not null then meds.ndc_description
        when ndc.ndc is not null then coalesce(ndc.fda_description, ndc.rxnorm_description)
        when custom_mapped_ndc.normalized_description is not null then custom_mapped_ndc.normalized_description
       else null end as NDC_DESCRIPTION
   , case
        when meds.ndc_code is not null then 'manual'
        when ndc.ndc is not null then 'automatic'
        else null end as ndc_mapping_method
   , case
        when meds.rxnorm_code is not null then meds.RXNORM_CODE
        when rxatc.rxcui is not null then  rxatc.rxcui
        when custom_mapped_rxnorm.normalized_code is not null then custom_mapped_rxnorm.normalized_code
        else null end as RXNORM_CODE
   , case
        when meds.rxnorm_code is not null then meds.RXNORM_CODE
        when rxatc.rxcui is not null then  rxatc.rxnorm_description
        when custom_mapped_rxnorm.normalized_description is not null then custom_mapped_rxnorm.normalized_description
        else null end as RXNORM_DESCRIPTION
   , case
        when meds.rxnorm_code is not null then 'manual'
        when rxatc.rxcui is not null then 'automatic'
        else null end as rxnorm_mapping_method
   , case
        when meds.atc_code is not null then meds.atc_code
        when rxatc.rxcui is not null then null -- need to add codes to terminology
        when custom_mapped_atc.normalized_code is not null then custom_mapped_atc.normalized_code
        else null end as ATC_CODE
   , case
        when meds.atc_description is not null then meds.atc_description
        when rxatc.rxcui is not null then rxatc.atc_4_name
        when custom_mapped_atc.normalized_description is not null then custom_mapped_atc.normalized_description
        else null end as ATC_DESCRIPTION
   , case
        when meds.atc_code is not null then 'manual'
        when rxatc.atc_4_name is not null then 'automatic'
        else null end as atc_mapping_method
   , meds.ROUTE
   , meds.STRENGTH
   , meds.QUANTITY
   , meds.QUANTITY_UNIT
   , meds.DAYS_SUPPLY
   , meds.PRACTITIONER_ID
   , meds.DATA_SOURCE
   , meds.TUVA_LAST_RUN
from {{ ref('core__stg_clinical_medication')}} meds
    left join {{ref('terminology__ndc')}} ndc
        on meds.source_code_type = 'ndc'
        and meds.source_code = ndc.ndc
    left join {{ref('terminology__rxnorm_to_atc')}} rxatc
        on meds.source_code_type = 'rxnorm'
        and meds.source_code = rxatc.rxcui
    left join {{ ref('custom_mapped') }} custom_mapped_ndc
        on custom_mapped.domain = 'medication'
        and custom_mapped.normalized_code_type = 'ndc'
        and ( lower(meds.source_code_type) = lower(custom_mapped.source_code_type)
            or ( meds.source_code_type is null and custom_mapped.source_code_type is null)
            )
        and (meds.source_code = custom_mapped.source_code
            or ( meds.source_code is null and custom_mapped.source_code is null)
            )
        and (meds.source_description = custom_mapped.source_description
            or ( meds.source_description is null and custom_mapped.source_description is null)
            )
        and not (meds.source_code is null and meds.source_description is null)
    left join {{ ref('custom_mapped') }} custom_mapped_ndc
        on custom_mapped.domain = 'medication'
        and custom_mapped.normalized_code_type = 'rxnorm'
        and ( lower(meds.source_code_type) = lower(custom_mapped.source_code_type)
            or ( meds.source_code_type is null and custom_mapped.source_code_type is null)
            )
        and (meds.source_code = custom_mapped.source_code
            or ( meds.source_code is null and custom_mapped.source_code is null)
            )
        and (meds.source_description = custom_mapped.source_description
            or ( meds.source_description is null and custom_mapped.source_description is null)
            )
        and not (meds.source_code is null and meds.source_description is null)
    left join {{ ref('custom_mapped') }} custom_mapped_ndc
        on custom_mapped.domain = 'medication'
        and custom_mapped.normalized_code_type = 'atc'
        and ( lower(meds.source_code_type) = lower(custom_mapped.source_code_type)
            or ( meds.source_code_type is null and custom_mapped.source_code_type is null)
            )
        and (meds.source_code = custom_mapped.source_code
            or ( meds.source_code is null and custom_mapped.source_code is null)
            )
        and (meds.source_description = custom_mapped.source_description
            or ( meds.source_description is null and custom_mapped.source_description is null)
            )
        and not (meds.source_code is null and meds.source_description is null)
{% endif %}
   )


-- add auto rxnorm + atc
select
     sm.MEDICATION_ID
   , sm.PATIENT_ID
   , sm.ENCOUNTER_ID
   , sm.DISPENSING_DATE
   , sm.PRESCRIBING_DATE
   , sm.SOURCE_CODE_TYPE
   , sm.SOURCE_CODE
   , sm.SOURCE_DESCRIPTION
   , sm.NDC_CODE
   , sm.NDC_DESCRIPTION
   , sm.ndc_mapping_method
   , case
        when sm.rxnorm_code is not null then sm.RXNORM_CODE
        when ndc.rxcui is not null then ndc.rxcui
        else null end as RXNORM_CODE
   , case
        when sm.rxnorm_code is not null then sm.RXNORM_description
        when ndc.rxnorm_description is not null then ndc.rxnorm_description
        else null end as RXNORM_DESCRIPTION
   , case
        when sm.rxnorm_mapping_method is not null then sm.rxnorm_mapping_method
        when ndc.rxcui is not null then 'automatic'
        else null end as rxnorm_mapping_method
   , case
        when sm.atc_code is not null then sm.atc_code
        when rxatc.rxcui is not null then null -- need to add codes to terminology
        else null end as ATC_CODE
   , case
        when sm.atc_description is not null then sm.atc_description
        when rxatc.rxcui is not null then rxatc.atc_4_name
        else null end as ATC_DESCRIPTION
   , case
        when sm.atc_code is not null then 'manual'
        when rxatc.atc_4_name is not null then 'automatic'
        else null end as atc_mapping_method
   , sm.ROUTE
   , sm.STRENGTH
   , sm.QUANTITY
   , sm.QUANTITY_UNIT
   , sm.DAYS_SUPPLY
   , sm.PRACTITIONER_ID
   , sm.DATA_SOURCE
   , sm.TUVA_LAST_RUN
from source_mapping sm
    left join {{ref('terminology__ndc')}} ndc
        and sm.ndc_code = ndc.ndc
    left join {{ref('terminology__rxnorm_to_atc')}} rxatc
        on ndc.rxcui = rxatc.rxcui or sm.rxnorm_code = rxatc.rxcui
