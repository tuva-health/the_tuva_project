{{ config(
     enabled = var('financial_pmpm_enabled',var('claims_enabled',var('tuva_marts_enabled',False))) | as_bool
   )
}}

with service_cat_2 as (
  select
    patient_id
  , year_month
  , payer
  , {{ quote_column('plan') }}
  , service_category_2
  , data_source
  , sum(total_paid) as total_paid
  from {{ ref('financial_pmpm__patient_spend_with_service_categories') }}
  group by
    patient_id
  , year_month
  , payer
  , {{ quote_column('plan') }}
  , service_category_2
  , data_source
)

select
  patient_id
, year_month
, payer
, {{ quote_column('plan') }}
, data_source
, {{ dbt_utils.pivot(
      column='service_category_2'
    , values=('Acute Inpatient',
              'Ambulance',
              'Ambulatory Surgery',
              'Dialysis',
              'Durable Medical Equipment',
              'Emergency Department',
              'Home Health',
              'Hospice',
              'Inpatient Psychiatric',
              'Inpatient Rehabilitation',
              'Lab',
              'Office Visit',
              'Outpatient Hospital or Clinic',
              'Outpatient Psychiatric',
              'Outpatient Rehabilitation',
              'Skilled Nursing',
              'Urgent Care'
              )
    , agg='sum'
    , then_value='total_paid'
    , else_value= 0
    , quote_identifiers = False
    , suffix='_paid'
  ) }}
, '{{ var('tuva_last_run')}}' as tuva_last_run
from service_cat_2
group by
  patient_id
, year_month
, payer
, {{ quote_column('plan') }}
, data_source
