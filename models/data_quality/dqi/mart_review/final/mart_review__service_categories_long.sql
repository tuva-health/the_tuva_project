{{ config(
    enabled = var('claims_enabled', var('tuva_marts_enabled', False)) | as_bool
) }}

with encounters as (
    select
        cast(c.year_month_int as {{ dbt.type_string() }}) as year_month
      , mc.patient_id
      , service_category_1
      , service_category_2
      , count(distinct mc.encounter_id) as visits
    from {{ ref('mart_review__stg_medical_claim')}} as mc
    left join {{ ref('reference_data__calendar')}} c on mc.claim_start_date = c.full_date
    inner join {{ref ('core__encounter')}} as e
      on mc.encounter_id = e.encounter_id
    group by
        cast(c.year_month_int as {{ dbt.type_string() }})
      , mc.patient_id
      , service_category_1
      , service_category_2
)


    select     
        pmpm.year_month
      , pmpm.data_source
      , pmpm.service_category_1
      , pmpm.service_category_2
      , sum(total_paid) as paid_amt
      , sum(visits) as visits
    from {{ref('financial_pmpm__patient_spend_with_service_categories')}} as pmpm
    left join encounters
      on pmpm.year_month = encounters.year_month
      and pmpm.patient_id = encounters.patient_id
      and pmpm.service_category_1 = encounters.service_category_1
      and pmpm.service_category_2 = encounters.service_category_2
    group by
        pmpm.year_month
      , pmpm.data_source
      , pmpm.service_category_1
      , pmpm.service_category_2


