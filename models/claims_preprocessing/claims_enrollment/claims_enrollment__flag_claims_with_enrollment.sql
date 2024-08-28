{{ config(
     enabled = var('claims_preprocessing_enabled',var('claims_enabled',var('tuva_marts_enabled',False)))
 | as_bool
   )
}}


with claim_dates as(
    select
        claim_id
        , claim_line_number
        , patient_id
        , payer
        , plan
        , coalesce(claim_line_start_date, claim_start_date, admission_date) as inferred_claim_start_date
        , coalesce(claim_line_end_date, claim_end_date, discharge_date) as inferred_claim_end_date
        , case
            when claim_line_start_date is not null then 'claim_line_start_date'
            when claim_line_start_date is null and claim_start_date is not null then 'claim_start_date'
            when claim_line_start_date is null and claim_start_date is null and admission_date is not null then 'admission_date'
        end as inferred_claim_start_column_used
        , case
            when claim_line_end_date is not null then 'claim_line_end_date'
            when claim_line_end_date is null and claim_end_date is not null then 'claim_end_date'
            when claim_line_end_date is null and claim_end_date is null and discharge_date is not null then 'discharge_date'
        end as inferred_claim_end_column_used
    from {{ ref('normalized_input__medical_claim')}}
)

, claim_year_month as(
    select
          claim_id
        , claim_line_number
        , patient_id
        , payer
        , plan
        , inferred_claim_start_date
        , inferred_claim_end_date
        , inferred_claim_start_column_used
        , inferred_claim_end_column_used
        , cast({{ date_part("year", "inferred_claim_start_date")}} as {{ dbt.type_string() }} ) || lpad(cast({{ date_part("month", "inferred_claim_start_date")}} as {{ dbt.type_string() }} ),2,'0') AS inferred_claim_start_year_month
        , cast({{ date_part("year", "inferred_claim_end_date")}} as {{ dbt.type_string() }} ) || lpad(cast({{ date_part("month", "inferred_claim_end_date")}} as {{ dbt.type_string() }} ),2,'0') AS inferred_claim_end_year_month
    from claim_dates

)

select distinct
     claim.claim_id
    , claim.claim_line_number
    , claim.patient_id
    , claim.payer
    , claim.plan
    , claim.inferred_claim_start_year_month
    , claim.inferred_claim_end_year_month
    , claim.inferred_claim_start_column_used
    , claim.inferred_claim_end_column_used
    , cast('{{ var('tuva_last_run')}}' as {{ dbt.type_timestamp() }} ) as tuva_last_run
from {{ ref('core__member_months')}} mm
inner join claim_year_month claim
    on mm.patient_id = claim.patient_id
    and mm.payer = claim.payer
    and mm.plan = claim.plan
    and mm.year_month >= claim.inferred_claim_start_year_month
    and mm.year_month <= claim.inferred_claim_end_year_month


