


select
  aa.patient_id,
  bb.condition,
  aa.therapy,
  aa.treatment_start,
  aa.treatment_end
  
from {{ ref('treatment_periods') }} aa
left join {{ ref('condition_therapies') }} bb
on aa.therapy = bb.therapy


