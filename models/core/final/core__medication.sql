{{ config(
     enabled = var('clinical_enabled',var('tuva_marts_enabled',False))
 | as_bool
   )
}}


 select
    meds.MEDICATION_ID,
    meds.PATIENT_ID,
    meds.ENCOUNTER_ID,
    meds.DISPENSING_DATE,
    meds.PRESCRIBING_DATE,
    meds.SOURCE_CODE_TYPE,
    meds.SOURCE_CODE,
    meds.SOURCE_DESCRIPTION,
    meds.NDC_CODE,
    meds.NDC_DESCRIPTION,
    meds.RXNORM_CODE,
    meds.RXNORM_DESCRIPTION,
    meds.ATC_CODE,
    meds.ATC_DESCRIPTION,
    meds.ROUTE,
    meds.STRENGTH,
    meds.QUANTITY,
    meds.QUANTITY_UNIT,
    meds.DAYS_SUPPLY,
    meds.PRACTITIONER_ID,
    meds.DATA_SOURCE,
    meds.TUVA_LAST_RUN
from {{ ref('core__stg_clinical_medication')}} meds