{{ config(
     enabled = var('claims_preprocessing_enabled',var('claims_enabled',var('tuva_marts_enabled',False))) | as_bool
   )
}}

select distinct 
  claim_id
, 'Home Health' as service_category_2
, 'Home Health' as service_category_3
, '{{ var('tuva_last_run')}}' as tuva_last_run
from {{ ref('service_category__stg_medical_claim') }}
where claim_type = 'institutional'
  and substring(bill_type_code, 1, 2) in ('31','32','33')
  