with anchor as 
(
select distinct m.patient_data_source_id
 , m.start_date
 , m.claim_id
from {{ ref('encounters__stg_medical_claim') }} m
inner join {{ ref('outpatient_substance_use__anchor_events') }} u on m.claim_id = u.claim_id
)

select patient_data_source_id
,start_date
,claim_id
,dense_rank() over (order by patient_data_source_id, start_date) as old_encounter_id
from anchor