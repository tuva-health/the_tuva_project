{{ config(
     enabled = var('claims_preprocessing_enabled',var('claims_enabled',var('tuva_marts_enabled',False))) | as_bool
   )
}}

select distinct 
  claim_id
, claim_line_number
, 'Outpatient Psychiatric' as service_category_2
, 'Outpatient Psychiatric' as service_category_3
, '{{ var('tuva_last_run')}}' as tuva_last_run
from {{ ref('service_category__stg_medical_claim') }}
where claim_type = 'professional'
  and place_of_service_code in ('52','53','57','58')
  