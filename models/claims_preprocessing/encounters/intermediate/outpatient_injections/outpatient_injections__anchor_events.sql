{{ config(
     enabled = var('claims_preprocessing_enabled',var('claims_enabled',var('tuva_marts_enabled',False))) | as_bool
   )
}}

with multiple_sources as 
(
select distinct
    med.claim_id
from {{ ref('service_category__stg_medical_claim') }} med
inner join {{ ref('service_category__stg_outpatient_institutional') }} outpatient
    on med.claim_id = outpatient.claim_id
where substring(med.hcpcs_code,1,1) = 'J'
)


select distinct 
claim_id
, '{{ var('tuva_last_run')}}' as tuva_last_run
from multiple_sources