select
      patient_id
    , member_id
    , subscriber_id
    , gender
    , race
    , birth_date
    , death_date
    , death_flag
    , enrollment_start_date
    , enrollment_end_date
    , payer
    , payer_type
    , plan
    , original_reason_entitlement_code
    , dual_status_code
    , medicare_status_code
    , first_name
    , last_name
    , social_security_number
    , subscriber_relation
    , address
    , city
    , state
    , zip_code
    , phone
    , data_source
    , file_name
    , ingest_datetime
from {{ ref('eligibility_seed') }}