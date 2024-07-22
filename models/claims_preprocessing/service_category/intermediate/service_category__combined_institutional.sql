{{ config(
     enabled = var('claims_preprocessing_enabled',var('claims_enabled',var('tuva_marts_enabled',False))) | as_bool
   )
}}

with combine as (
select *
from {{ ref('service_category__acute_inpatient_institutional') }}

union all

select *
from {{ ref('service_category__dialysis_institutional') }}

union all

select *
from {{ ref('service_category__emergency_department_institutional') }}

union all

select *
from {{ ref('service_category__home_health_institutional') }}

union all

select *
from {{ ref('service_category__hospice_institutional') }}

union all

select *
from {{ ref('service_category__lab_institutional') }}

union all

select *
from {{ ref('service_category__outpatient_hospital_or_clinic_institutional') }}

union all

select *
from {{ ref('service_category__outpatient_psychiatric_institutional') }}

union all

select *
from {{ ref('service_category__skilled_nursing_institutional') }}

union all

select *
from {{ ref('service_category__urgent_care_institutional') }}
)



select
  a.claim_id
, a.service_category_2
, a.service_category_3
from combine a
