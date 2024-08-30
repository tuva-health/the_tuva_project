{{ config(
     enabled = var('claims_preprocessing_enabled',var('claims_enabled',var('tuva_marts_enabled',False))) | as_bool
   )
}}

with multiple_sources as (
select distinct 
    med.claim_id
    , 'Emergency Department' as service_category_2
    , 'Emergency Department' as service_category_3
    , '{{ var('tuva_last_run')}}' as tuva_last_run
    , '{{ this.name }}' as source_model_name
from {{ ref('service_category__stg_medical_claim') }} med
inner join {{ ref('service_category__stg_outpatient_institutional') }} outpatient
    on med.claim_id = outpatient.claim_id
where revenue_center_code in ('0450','0451','0452','0459','0981')
OR
hcpcs_code in ('99281','99282','99283','99284','99285','G0380','G0381','G0382','G0383','G0384')
  
UNION 


--Adding in inpatient claims for flagging encounters with ED 
select distinct 
    med.claim_id
    , 'Emergency Department' as service_category_2
    , 'Emergency Department' as service_category_3
    , '{{ var('tuva_last_run')}}' as tuva_last_run
    , '{{ this.name }}' as source_model_name
from {{ ref('service_category__stg_medical_claim') }} med
inner join {{ ref('service_category__stg_inpatient_institutional') }} inp
    on med.claim_id = inp.claim_id
where revenue_center_code in ('0450','0451','0452','0459','0981')

)

select claim_id
, 'Outpatient' as service_category_1
,service_category_2
,service_category_3
,tuva_last_run
,source_model_name
from multiple_sources