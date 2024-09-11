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
  , sum(total_allowed) as total_allowed
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
  , values=('acute inpatient',
            'ambulance',
            'Ambulatory Surgery',
            'dialysis',
            'durable medical equipment',
            'emergency department',
            'home health',
            'Hospice',
            'inpatient psychiatric',
            'inpatient rehabilitation',
            'lab',
            'Office Visit',
            'outpatient hospital or clinic',
            'outpatient psychiatric',
            'outpatient rehabilitation',
            'skilled nursing',
            'urgent care'                                                 
            )
  , agg='sum'
  , then_value='total_allowed'
  , else_value= 0
  , quote_identifiers = False
  , suffix='_allowed'
) }}
, '{{ var('tuva_last_run')}}' as tuva_last_run
from service_cat_2
group by
  patient_id
, year_month
, payer
, {{ quote_column('plan') }}
, data_source
