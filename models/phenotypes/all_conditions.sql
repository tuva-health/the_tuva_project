



select
  patient_id as patient_id,
  source_code_type as code_type,
  normalized_code as code,
  recorded_date as condition_date
  
from {{ ref('core__condition') }}
