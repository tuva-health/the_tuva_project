{{ config(
     enabled = var('claims_preprocessing_enabled',var('claims_enabled',var('tuva_marts_enabled',False))) | as_bool
   )
}}

select distinct 
  claim_id
, 'Inpatient Hospice' as service_category_2
, 'Inpatient Hospice' as service_category_3
,'{{ this.name }}' as source_model_name
, '{{ var('tuva_last_run')}}' as tuva_last_run
from {{ ref('service_category__stg_inpatient_institutional') }}
  and substring(bill_type_code, 1, 2) in ('82')
  