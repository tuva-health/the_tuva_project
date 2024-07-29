{{ config(
     enabled = var('claims_preprocessing_enabled',var('claims_enabled',var('tuva_marts_enabled',False))) | as_bool
   )
}}

select distinct
    claim_id
    , claim_line_number
    , claim_line_id
, 'Hospice' as service_category_2
, 'Hospice' as service_category_3
,'{{ this.name }}' as source_model_name
, '{{ var('tuva_last_run')}}' as tuva_last_run
from {{ ref('service_category__stg_professional') }} med
and place_of_service_code in ('34')
  