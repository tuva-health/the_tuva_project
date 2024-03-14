



select
  patient_id as patient_id,

  case
    when ndc_code is not null then 'ndc'
    when rxnorm_code is not null then 'rxnorm'
  end as code_type,
  
  case
    when ndc_code is not null then ndc_code
    when rxnorm_code is not null then rxnorm_code
  end as code,

  dispensing_date as start_date,
  dispensing_date + days_supply as end_date
  
from {{ ref('core__medication') }}
where ndc_code is not null or rxnorm_code is not null
