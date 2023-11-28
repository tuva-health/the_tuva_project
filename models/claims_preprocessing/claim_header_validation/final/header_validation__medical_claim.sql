select
	med.claim_id
	, med.claim_line_number
	, med.claim_type
	, med.patient_id
	, med.member_id
	, med.payer
	, med.plan 
	, med.claim_start_date
	, med.claim_end_date
	, med.claim_line_start_date
	, med.claim_line_end_date
	, med.admission_date
	, med.discharge_date
	, ad_source.normalized_code as admit_source_code
	, ad_type.normalized_code as admit_type_code
	, disch_disp.normalized_code as discharge_disposition_code
	, place_of_service_code
	, bill.normalized_code as bill_type_code
	, ms.normalized_code as ms_drg_code
	, apr.normalized_code as apr_drg_code
	, med.revenue_center_code
	, med.service_unit_quantity
	, med.hcpcs_code
	, med.hcpcs_modifier_1
	, med.hcpcs_modifier_2
	, med.hcpcs_modifier_3
	, med.hcpcs_modifier_4
	, med.hcpcs_modifier_5
	, med.rendering_npi
	, med.billing_npi
	, med.facility_npi
	, med.paid_date
	, med.paid_amount
	, med.allowed_amount
	, med.charge_amount
	, med.coinsurance_amount
	, med.copayment_amount
	, med.deductible_amount
	, med.total_cost_amount
	, med.diagnosis_code_type
	, dx_code.diagnosis_code_1
	, dx_code.diagnosis_code_2
	, dx_code.diagnosis_code_3
	, dx_code.diagnosis_code_4
	, dx_code.diagnosis_code_5
	, dx_code.diagnosis_code_6
	, dx_code.diagnosis_code_7
	, dx_code.diagnosis_code_8
	, dx_code.diagnosis_code_9
	, dx_code.diagnosis_code_10
	, dx_code.diagnosis_code_11
	, dx_code.diagnosis_code_12
	, dx_code.diagnosis_code_13
	, dx_code.diagnosis_code_14
	, dx_code.diagnosis_code_15
	, dx_code.diagnosis_code_16
	, dx_code.diagnosis_code_17
	, dx_code.diagnosis_code_18
	, dx_code.diagnosis_code_19
	, dx_code.diagnosis_code_20
	, dx_code.diagnosis_code_21
	, dx_code.diagnosis_code_22
	, dx_code.diagnosis_code_23
	, dx_code.diagnosis_code_24
	, dx_code.diagnosis_code_25
	, poa.diagnosis_poa_1
	, poa.diagnosis_poa_2
	, poa.diagnosis_poa_3
	, poa.diagnosis_poa_4
	, poa.diagnosis_poa_5
	, poa.diagnosis_poa_6
	, poa.diagnosis_poa_7
	, poa.diagnosis_poa_8
	, poa.diagnosis_poa_9
	, poa.diagnosis_poa_10
	, poa.diagnosis_poa_11
	, poa.diagnosis_poa_12
	, poa.diagnosis_poa_13
	, poa.diagnosis_poa_14
	, poa.diagnosis_poa_15
	, poa.diagnosis_poa_16
	, poa.diagnosis_poa_17
	, poa.diagnosis_poa_18
	, poa.diagnosis_poa_19
	, poa.diagnosis_poa_20
	, poa.diagnosis_poa_21
	, poa.diagnosis_poa_22
	, poa.diagnosis_poa_23
	, poa.diagnosis_poa_24
	, poa.diagnosis_poa_25
	, med.procedure_code_type
	, px_code.procedure_code_1
	, px_code.procedure_code_2
	, px_code.procedure_code_3
	, px_code.procedure_code_4
	, px_code.procedure_code_5
	, px_code.procedure_code_6
	, px_code.procedure_code_7
	, px_code.procedure_code_8
	, px_code.procedure_code_9
	, px_code.procedure_code_10
	, px_code.procedure_code_11
	, px_code.procedure_code_12
	, px_code.procedure_code_13
	, px_code.procedure_code_14
	, px_code.procedure_code_15
	, px_code.procedure_code_16
	, px_code.procedure_code_17
	, px_code.procedure_code_18
	, px_code.procedure_code_19
	, px_code.procedure_code_20
	, px_code.procedure_code_21
	, px_code.procedure_code_22
	, px_code.procedure_code_23
	, px_code.procedure_code_24
	, px_code.procedure_code_25
	, px_date.procedure_date_1
	, px_date.procedure_date_2
	, px_date.procedure_date_3
	, px_date.procedure_date_4
	, px_date.procedure_date_5
	, px_date.procedure_date_6
	, px_date.procedure_date_7
	, px_date.procedure_date_8
	, px_date.procedure_date_9
	, px_date.procedure_date_10
	, px_date.procedure_date_11
	, px_date.procedure_date_12
	, px_date.procedure_date_13
	, px_date.procedure_date_14
	, px_date.procedure_date_15
	, px_date.procedure_date_16
	, px_date.procedure_date_17
	, px_date.procedure_date_18
	, px_date.procedure_date_19
	, px_date.procedure_date_20
	, px_date.procedure_date_21
	, px_date.procedure_date_22
	, px_date.procedure_date_23
	, px_date.procedure_date_24
	, px_date.procedure_date_25
	, med.data_source
from {{ ref('medical_claim') }} med
left join {{ref('header_validation__int_admit_source_final') }} ad_source
    on med.claim_id = ad_source.claim_id
    and med.data_source = ad_source.data_source
left join {{ref('header_validation__int_admit_type_final') }} ad_type
    on med.claim_id = ad_type.claim_id
    and med.data_source = ad_type.data_source
left join {{ref('header_validation__int_apr_drg_final') }} apr
    on med.claim_id = apr.claim_id
    and med.data_source = apr.data_source
left join {{ref('header_validation__int_bill_type_final') }} bill
    on med.claim_id = bill.claim_id
    and med.data_source = bill.data_source
left join {{ref('header_validation__int_discharge_disposition_final') }} disch_disp
    on med.claim_id = disch_disp.claim_id
    and med.data_source = disch_disp.data_source
left join {{ref('header_validation__int_ms_drg_final') }} ms
    on med.claim_id = ms.claim_id
    and med.data_source = ms.data_source
left join {{ref('header_validation__int_diagnosis_code_final') }} dx_code
    on med.claim_id = dx_code.claim_id
    and med.data_source = dx_code.data_source
left join {{ref('header_validation__int_present_on_admit_final') }} poa
    on med.claim_id = poa.claim_id
    and med.data_source = poa.data_source
left join {{ref('header_validation__int_procedure_code_final') }} px_code
    on med.claim_id = px_code.claim_id
    and med.data_source = px_code.data_source
left join {{ref('header_validation__int_procedure_date_final') }} px_date
    on med.claim_id = px_date.claim_id
    and med.data_source = px_date.data_source

