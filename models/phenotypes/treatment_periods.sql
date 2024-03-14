


select
  patient_id,
  therapy,
  treatment_period_id,
  min(start_date) as treatment_start,
  max(end_date) as treatment_end
  
from {{ ref('patient_treatments_with_treatment_ids') }}
group by patient_id, therapy, treatment_period_id
