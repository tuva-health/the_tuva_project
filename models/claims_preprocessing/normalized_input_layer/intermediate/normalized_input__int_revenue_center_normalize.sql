select
    claim_id
    , claim_line_number
    , data_source
    , rev.revenue_center_code as normalized_code
from {{ ref('medical_claim') }} med
left join {{ ref('terminology__revenue_center') }} rev
    on lpad(med.revenue_center_code, 4, '0') = rev.revenue_center_code
where claim_type = 'institutional'