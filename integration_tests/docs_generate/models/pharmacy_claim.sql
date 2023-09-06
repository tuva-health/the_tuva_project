select claim_id,
       claim_line_number,
       patient_id,
       member_id,
       prescribing_provider_npi,
       dispensing_provider_npi,
       dispensing_date,
       ndc_code,
       quantity,
       days_supply,
       refills,
       paid_date,
       paid_amount,
       allowed_amount,
       data_source
from tuva.tuva_synthetic.pharmacy_claim_seed