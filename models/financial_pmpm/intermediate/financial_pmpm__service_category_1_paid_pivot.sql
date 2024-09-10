{{ config(
     enabled = var('financial_pmpm_enabled',var('claims_enabled',var('tuva_marts_enabled',False))) | as_bool
   )
}}

with service_cat_1 as (
  select
    patient_id
  , year_month
  , payer
  , plan
  , service_category_1
  , data_source
  , sum(total_paid) as total_paid
  from {{ ref('financial_pmpm__patient_spend_with_service_categories') }}
  group by
    patient_id
  , year_month
  , payer
  , plan
  , service_category_1
  , data_source
)

select
  patient_id
, year_month
, payer
, plan
, data_source
, {{ dbt_utils.pivot(
      column='service_category_1'
    , values=('inpatient','outpatient','Office Visit','ancillary','Other','pharmacy')
    , agg='sum'
    , then_value='total_paid'
    , else_value= 0
    , quote_identifiers = False
    , suffix='_paid'
  ) }}
, '{{ var('tuva_last_run')}}' as tuva_last_run
from service_cat_1
group by
  patient_id
, year_month
, payer
, plan
, data_source