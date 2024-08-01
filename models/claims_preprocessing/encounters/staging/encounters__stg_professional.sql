{{ config(
     enabled = var('claims_preprocessing_enabled',var('claims_enabled',var('tuva_marts_enabled',False))) | as_bool
   )
}}

select distinct 
    a.claim_id
  , a.claim_line_number
  , a.claim_id || '|' || cast(a.claim_line_number as {{dbt.type_string() }} ) as claim_line_id
, 'Professional' as service_type
, '{{ var('tuva_last_run')}}' as tuva_last_run
from {{ ref('encounters__stg_medical_claim') }} a
where a.claim_type = 'professional'

