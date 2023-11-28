with pivot_procedure as(
    {{ dbt_utils.unpivot(
        relation=ref('medical_claim'),
        cast_to='string',
        exclude=['claim_id','data_source','procedure_code_type'],
        remove=[
            'claim_line_number'
            , 'claim_type'
            , 'patient_id'
            , 'member_id'
            , 'payer'
            , 'plan '
            , 'claim_start_date'
            , 'claim_end_date'
            , 'claim_line_start_date'
            , 'claim_line_end_date'
            , 'admission_date'
            , 'discharge_date'
            , 'admit_source_code'
            , 'admit_type_code'
            , 'discharge_disposition_code'
            , 'place_of_service_code'
            , 'bill_type_code'
            , 'ms_drg_code'
            , 'apr_drg_code'
            , 'revenue_center_code'
            , 'service_unit_quantity'
            , 'hcpcs_code'
            , 'hcpcs_modifier_1'
            , 'hcpcs_modifier_2'
            , 'hcpcs_modifier_3'
            , 'hcpcs_modifier_4'
            , 'hcpcs_modifier_5'
            , 'rendering_npi'
            , 'billing_npi'
            , 'facility_npi'
            , 'paid_date'
            , 'paid_amount'
            , 'allowed_amount'
            , 'charge_amount'
            , 'coinsurance_amount'
            , 'copayment_amount'
            , 'deductible_amount'
            , 'total_cost_amount'
            , 'diagnosis_code_type'
            , 'diagnosis_code_1'
            , 'diagnosis_code_2'
            , 'diagnosis_code_3'
            , 'diagnosis_code_4'
            , 'diagnosis_code_5'
            , 'diagnosis_code_6'
            , 'diagnosis_code_7'
            , 'diagnosis_code_8'
            , 'diagnosis_code_9'
            , 'diagnosis_code_10'
            , 'diagnosis_code_11'
            , 'diagnosis_code_12'
            , 'diagnosis_code_13'
            , 'diagnosis_code_14'
            , 'diagnosis_code_15'
            , 'diagnosis_code_16'
            , 'diagnosis_code_17'
            , 'diagnosis_code_18'
            , 'diagnosis_code_19'
            , 'diagnosis_code_20'
            , 'diagnosis_code_21'
            , 'diagnosis_code_22'
            , 'diagnosis_code_23'
            , 'diagnosis_code_24'
            , 'diagnosis_code_25'
            , 'diagnosis_poa_1'
            , 'diagnosis_poa_2'
            , 'diagnosis_poa_3'
            , 'diagnosis_poa_4'
            , 'diagnosis_poa_5'
            , 'diagnosis_poa_6'
            , 'diagnosis_poa_7'
            , 'diagnosis_poa_8'
            , 'diagnosis_poa_9'
            , 'diagnosis_poa_10'
            , 'diagnosis_poa_11'
            , 'diagnosis_poa_12'
            , 'diagnosis_poa_13'
            , 'diagnosis_poa_14'
            , 'diagnosis_poa_15'
            , 'diagnosis_poa_16'
            , 'diagnosis_poa_17'
            , 'diagnosis_poa_18'
            , 'diagnosis_poa_19'
            , 'diagnosis_poa_20'
            , 'diagnosis_poa_21'
            , 'diagnosis_poa_22'
            , 'diagnosis_poa_23'
            , 'diagnosis_poa_24'
            , 'diagnosis_poa_25'
            , 'procedure_date_1'
            , 'procedure_date_2'
            , 'procedure_date_3'
            , 'procedure_date_4'
            , 'procedure_date_5'
            , 'procedure_date_6'
            , 'procedure_date_7'
            , 'procedure_date_8'
            , 'procedure_date_9'
            , 'procedure_date_10'
            , 'procedure_date_11'
            , 'procedure_date_12'
            , 'procedure_date_13'
            , 'procedure_date_14'
            , 'procedure_date_15'
            , 'procedure_date_16'
            , 'procedure_date_17'
            , 'procedure_date_18'
            , 'procedure_date_19'
            , 'procedure_date_20'
            , 'procedure_date_21'
            , 'procedure_date_22'
            , 'procedure_date_23'
            , 'procedure_date_24'
            , 'procedure_date_25'
            ],
    field_name='procedure_column',
    value_name='procedure_code'

) }}
)

select
    claim_id
    , data_source
    , procedure_code_type
    , procedure_column
    , coalesce(icd_9.icd_9_pcs,icd_10.icd_10_pcs) as normalized_procedure_code
    , count(*) as procedure_code_occurrence_count
from pivot_procedure piv
left join {{ ref('terminology__icd_10_pcs') }} icd_10
    on replace(piv.procedure_code,'.','') = icd_10.icd_10_pcs
    and piv.procedure_code_type = 'icd-10-pcs'
left join {{ ref('terminology__icd_9_pcs') }} icd_9
    on replace(piv.procedure_code,'.','') = icd_9.icd_9_pcs
    and piv.procedure_code_type = 'icd-9-pcs'
group by 
    claim_id
    , data_source
    , procedure_code_type
    , procedure_column
    , coalesce(icd_9.icd_9_pcs,icd_10.icd_10_pcs)