

select
  aa.patient_id,
  bb.condition,
  bb.code_type,
  bb.code,
  aa.condition_date
  
from {{ ref('all_conditions') }} aa
inner join {{ ref('condition_diagnoses') }} bb
on aa.code = bb.code
and aa.code_type = bb.code_type
