{{ config(
     enabled = var('claims_preprocessing_enabled',var('claims_enabled',var('tuva_marts_enabled',False))) | as_bool
   )
}}

with service_category_1_mapping as(
    select distinct 
        a.claim_id
        , a.claim_line_number
        , a.claim_type
        , case
            when s.service_category_1 is null then 'Value not in seed table'
            else s.service_category_1
          end service_category_1
        , case
            when b.service_category_2 is null then 'Not Mapped'
            when s.service_category_2 is null then 'Value not in seed table'
            else s.service_category_2
          end service_category_2
        , case
            when s.service_category_3 is null then 'Value not in seed table'
            else s.service_category_3
          end service_category_3
        
        ,b.service_category_2 as original_service_cat_2
        ,b.service_category_3 as original_service_cat_3
        , s.priority
        , '{{ var('tuva_last_run')}}' as tuva_last_run
        , b.source_model_name
    from {{ ref('service_category__stg_medical_claim') }} a
    left join {{ ref('service_category__combined_professional') }} b
    on a.claim_id = b.claim_id
    and a.claim_line_number = b.claim_line_number
    left join {{ ref('claims_preprocessing__service_category_seed') }} s on b.service_category_2 = s.service_category_2
    and
    b.service_category_3 = s.service_category_3
    where a.claim_type = 'professional'

    union all

    select distinct 
        a.claim_id
        , a.claim_line_number
        , a.claim_type
        , case
            when s.service_category_1 is null then 'Value not in seed table'
            else s.service_category_1
          end service_category_1
        , case
            when b.service_category_2 is null then 'Not Mapped'
            when s.service_category_2 is null then 'Value not in seed table'
            else s.service_category_2
          end service_category_2
        , case
            when s.service_category_3 is null then 'Value not in seed table'
            else s.service_category_3
          end service_category_3
        ,b.service_category_2 as original_service_cat_2
        ,b.service_category_3 as original_service_cat_3
        , s.priority
        , '{{ var('tuva_last_run')}}' as tuva_last_run
        , b.source_model_name
    from {{ ref('service_category__stg_medical_claim') }} a
    left join {{ ref('service_category__combined_institutional_header_level') }} b
    on a.claim_id = b.claim_id
    left join {{ ref('claims_preprocessing__service_category_seed') }} s on b.service_category_2 = s.service_category_2
    and
    b.service_category_3 = s.service_category_3
    where a.claim_type = 'institutional'

    union all

    select distinct 
        a.claim_id
        , a.claim_line_number
        , a.claim_type
        , case
            when s.service_category_1 is null then 'Value not in seed table'
            else s.service_category_1
          end service_category_1
        , case
            when b.service_category_2 is null then 'Not Mapped'
            when s.service_category_2 is null then 'Value not in seed table'
            else s.service_category_2
          end service_category_2
        , case
            when s.service_category_3 is null then 'Value not in seed table'
            else s.service_category_3
          end service_category_3
        ,b.service_category_2 as original_service_cat_2
        ,b.service_category_3 as original_service_cat_3
        , s.priority
        , '{{ var('tuva_last_run')}}' as tuva_last_run
        , b.source_model_name
    from {{ ref('service_category__stg_medical_claim') }} a
    left join {{ ref('service_category__combined_institutional_line_level') }} b
    on a.claim_id = b.claim_id
    and a.claim_line_number = b.claim_line_number
    left join {{ ref('claims_preprocessing__service_category_seed') }} s on b.service_category_2 = s.service_category_2
    and
    b.service_category_3 = s.service_category_3
    where a.claim_type = 'institutional'
)

, service_category_2_deduplication as(
    select 
        claim_id
        , claim_line_number
        , claim_type
        , service_category_1
        , service_category_2
        , service_category_3
        ,original_service_cat_2
        ,original_service_cat_3
        , source_model_name
        , row_number() over (partition by claim_id, claim_line_number order by priority) as duplicate_row_number
    from service_category_1_mapping
)

select
    d.claim_id
    , d.claim_line_number
    , d.claim_type
    , d.claim_id || '|' || d.claim_line_number as claim_line_id
    , service_category_1
    , service_category_2
    , service_category_3
    , original_service_cat_2
    , original_service_cat_3
    , duplicate_row_number
    , s.ccs_category
    , s.ccs_category_description
    , s.ms_drg_code
    , s.ms_drg_description
    , s.place_of_service_code
    , s.place_of_service_description
    , s.revenue_center_code
    , s.revenue_center_description
    , s.default_ccsr_category_ip
    , s.default_ccsr_category_op
    , s.default_ccsr_category_description_ip
    , s.default_ccsr_category_description_op
    , s.primary_taxonomy_code
    , s.primary_specialty_description
    , s.modality
    , s.bill_type_code
    , s.bill_type_description
    , d.source_model_name
from service_category_2_deduplication d
left join {{ ref('service_category__stg_medical_claim') }} s on d.claim_id = s.claim_id
and
d.claim_line_number = s.claim_line_number
--where duplicate_row_number = 1

