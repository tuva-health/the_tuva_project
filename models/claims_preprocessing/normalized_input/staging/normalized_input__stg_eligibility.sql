{{ config(
     enabled = var('claims_preprocessing_enabled',var('claims_enabled',var('tuva_marts_enabled',False)))
 | as_bool
   )
}}


select
      patient_id
    , {{ dbt.concat([
        "patient_id",
        "coalesce(data_source,'')",
        "coalesce(payer,'')",
        "coalesce(" ~ quote_column('plan') ~ ",'')",
        "coalesce(cast(enrollment_start_date as " ~ dbt.type_string() ~ "),'')",
        "coalesce(cast(enrollment_end_date as " ~ dbt.type_string() ~ "),'')"
    ]) }} as patient_id_key
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
    , {{ quote_column('plan') }}
    , subscriber_relation
    , original_reason_entitlement_code
    , dual_status_code
    , medicare_status_code
    , first_name
    , last_name
    , social_security_number
    , address
    , city
    , state
    , zip_code
    , phone
    , data_source
    , file_name
    , ingest_datetime
from {{ ref('eligibility') }}
