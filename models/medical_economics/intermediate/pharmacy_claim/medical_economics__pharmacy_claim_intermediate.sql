select 
      aa.*
from {{ ref('medical_economics__stg_core_pharmacy_claim') }} aa 
inner join {{ ref('medical_economics__patient_random_group') }} bb 
    on aa.person_id = bb.person_id