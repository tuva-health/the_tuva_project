



select
  aa.patient_id,
  aa.therapy,
  aa.start_date,
  aa.end_date,
  aa.row_num,
  aa.unique_id,
  bb.treatment_period_id
from {{ ref('raw_patient_treatment_periods') }} aa
left join {{ ref('treatment_period_id') }} bb
on aa.unique_id = bb.unique_id
