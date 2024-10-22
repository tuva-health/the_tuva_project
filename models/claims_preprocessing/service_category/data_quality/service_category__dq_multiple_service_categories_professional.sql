{{ config(
     enabled = var('claims_preprocessing_enabled',var('claims_enabled',var('tuva_marts_enabled',False))) | as_bool
   )
}}

select
  claim_id
, claim_line_number
, count(distinct service_category_2) as distinct_service_category_count
, '{{ var('tuva_last_run')}}' as tuva_last_run
from {{ ref('service_category__combined_professional') }}
group by claim_id, claim_line_number
having count(distinct service_category_2) > 1