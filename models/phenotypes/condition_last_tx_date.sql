


select
  patient_id,
  condition,
  current_date() - max(treatment_end) as days_since_last_treatment
from {{ ref('condition_treatments') }}
group by patient_id, condition
