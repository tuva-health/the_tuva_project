{{ config(
    enabled = var('claims_enabled', False)
) }}

SELECT  
      m.data_source
    , coalesce(cast(m.claim_start_date as {{ dbt.type_string() }}),cast('1900-01-01' as {{ dbt.type_string() }})) as source_date
    , 'MEDICAL_CLAIM' AS table_name
    , 'Claim ID | Claim Line Number' AS drill_down_key
    . {{ dbt.concat(["coalesce(m.claim_id, 'null')", "'|'", "coalesce(m.claim_line_number, 'NULL')"]) }} as drill_down_value
    , m.claim_type as claim_type
    , 'COPAYMENT_AMOUNT' AS field_name
    , case when m.copayment_amount is null then 'null'
                                    else 'valid' end as bucket_name
    , cast(null as {{ dbt.type_string() }}) as invalid_reason
    , cast(copayment_amount as {{ dbt.type_string() }}) as field_value
    , '{{ var('tuva_last_run')}}' as tuva_last_run
from {{ ref('medical_claim')}} m