{{ config(
     enabled = var('claims_enabled',var('tuva_marts_enabled',False))
 | as_bool
   )
}}


WITH dedup_prac AS (
    SELECT DISTINCT practitioner_id,
                    provider_first_name,
                    provider_last_name,
                    specialty
    FROM {{ ref('core__practitioner')}}
),
dedup_loc AS (
    SELECT DISTINCT location_id,
                    npi,
                    name
    FROM {{ ref('core__location')}}
)

SELECT
    p.claim_id,
    p.claim_line_number,
    p.patient_id,
    p.data_source,
    {{ dbt.concat([
        'p.patient_id',
        "' | '",
        'p.data_source'
    ]) }} as patient_source_key,
    p.ndc_code,
    COALESCE(n.fda_description, n.rxnorm_description) AS ndc_description,
    p.paid_amount,
    p.allowed_amount,
    p.prescribing_provider_id,
    p.prescribing_provider_name,
    prac.specialty AS prescribing_specialty,
    p.dispensing_provider_id,
    p.dispensing_provider_name,
    p.paid_date,
    p.dispensing_date,
    p.days_supply,
    p.paid_amount / p.days_supply as cost_per_day,
    (p.paid_amount / p.days_supply) * 30 as thirty_day_equivalent_cost,
    case when ((p.paid_amount / p.days_supply) * 30) >= 950 then 1 else 0 end as specialty_tier, --$950 is threshold set by CMS for CY 2024
    n.rxcui,
    n.rxnorm_description,
    r.brand_name,
    r.brand_vs_generic,
    r.ingredient_name,
    a.atc_1_name,
    a.atc_2_name,
    a.atc_3_name,
    a.atc_4_name,
    pe.GENERIC_AVAILABLE_TOTAL_OPPORTUNITY,
    pe.generic_average_cost_per_unit * p.quantity as generic_cost_at_units,
    pe.brand_cost_per_unit * p.quantity as brand_paid_amount,
    pe.generic_available,
    pe.generic_available_sk
    , '{{ var('tuva_last_run')}}' as tuva_last_run
FROM {{ ref('core__pharmacy_claim')}} p
LEFT JOIN {{ ref('terminology__ndc')}} n ON p.ndc_code = n.ndc
LEFT JOIN {{ ref('terminology__rxnorm_brand_generic') }} r ON n.rxcui = r.product_rxcui
LEFT JOIN {{ ref('terminology__rxnorm_to_atc') }} a ON n.rxcui = a.rxcui
LEFT JOIN dedup_prac prac ON p.prescribing_provider_id = prac.practitioner_id
LEFT JOIN dedup_loc l ON p.dispensing_provider_id = l.location_id
LEFT JOIN {{ ref('pharmacy__pharmacy_claim_expanded')}} pe on p.data_source = pe.data_source
    and p.claim_id = pe.claim_id
    and p.claim_line_number = pe.claim_line_number