

select
  aa.patient_id,
  bb.therapy,
  aa.code_type,
  aa.code,
  aa.start_date,
  aa.end_date
  
from {{ ref('all_medications') }} aa
inner join {{ ref('condition_therapies') }} bb
on aa.code_type = bb.code_type and
aa.code = bb.code
