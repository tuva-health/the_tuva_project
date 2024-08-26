{{ config(
     enabled = var('claims_preprocessing_enabled',var('claims_enabled',var('tuva_marts_enabled',False))) | as_bool
   )
}}

select distinct 
    med.claim_id
    , med.claim_line_number
    , med.claim_line_id
    , 'Office-Based Radiology' as service_category_2
    , case when med.modality = 'Nuclear medicine' then 'PET'
           when med.modality = 'Magnetic resonance' then 'MRI'
           when med.modality = 'Computerized tomography' then 'CT'
           when med.modality in ('Invasive', 'Ultrasound', 'Computer-aided detection', 'Three-dimensional reconstruction', 'Radiography') then 'General'
           else 'General' 
           end as service_category_3
    ,'{{ this.name }}' as source_model_name
    , '{{ var('tuva_last_run') }}' as tuva_last_run
from {{ ref('service_category__stg_medical_claim') }} med
inner join {{ ref('service_category__stg_office_based') }} o on med.claim_id = o.claim_id
and
med.claim_line_number = o.claim_line_number
where 
med.modality is not null
and
med.place_of_service_code = '11'




