
select distinct m.patient_data_source_id
 , m.start_date
 , m.claim_id
 , m.claim_line_number
 , m.hcpcs_code
 , u.old_encounter_id
from {{ ref('encounters__stg_medical_claim') }} m
inner join {{ ref('outpatient_radiology__generate_encounter_id') }} u on m.patient_data_source_id = u.patient_data_source_id
and
m.start_date = u.start_date
and
m.hcpcs_code = u.hcpcs_code