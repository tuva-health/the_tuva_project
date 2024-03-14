


select
  patient_id,
  condition,
  current_date() - max(condition_date) as days_since_last_diagnosis
from {{ ref('patient_condition_diagnoses') }}
group by patient_id, condition
