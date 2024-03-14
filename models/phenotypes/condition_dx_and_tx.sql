


select
  coalesce(aa.patient_id,bb.patient_id) as patient_id,
  coalesce(aa.condition,bb.condition) as condition,
  aa.days_since_last_diagnosis as days_since_last_diagnosis,
  bb.days_since_last_treatment as days_since_last_treatment,
  case
    when aa.days_since_last_diagnosis is not null then 1
    else 0
  end as has_condition,
  case
    when bb.days_since_last_treatment is not null then 1
    else 0
  end as might_have_condition
  
from {{ ref('condition_last_dx_date') }} aa
full outer join {{ ref('condition_last_tx_date') }} bb
on aa.patient_id = bb.patient_id
and aa.condition = bb.condition
