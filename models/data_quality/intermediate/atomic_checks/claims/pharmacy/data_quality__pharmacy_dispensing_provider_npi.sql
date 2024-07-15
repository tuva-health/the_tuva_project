{{ config(
    enabled = var('claims_enabled', False)
) }}

SELECT DISTINCT -- to bring to claim_ID grain 
    M.Data_SOURCE
    ,coalesce(cast(M.PAID_DATE as {{ dbt.type_string() }}),cast('1900-01-01' as {{ dbt.type_string() }})) AS SOURCE_DATE
    ,'PHARMACY_CLAIM' AS TABLE_NAME
    ,'Claim ID | Claim Line Number' AS DRILL_DOWN_KEY
    ,COALESCE(CAST(M.CLAIM_ID as {{ dbt.type_string() }}), 'NULL') || '|' || COALESCE(CAST(M.CLAIM_LINE_NUMBER as {{ dbt.type_string() }}), 'NULL') AS DRILL_DOWN_VALUE
    ,'PHARMACY' AS CLAIM_TYPE
    ,'DISPENSING_PROVIDER_NPI' AS FIELD_NAME
    ,case when TERM.NPI is not null                     then        'valid'
          when M.DISPENSING_PROVIDER_NPI is not null    then 'invalid'      
                                                        else 'null' 
                                                        end as BUCKET_NAME
    ,case
        when M.DISPENSING_PROVIDER_NPI is not null
            and TERM.NPI is null
            then 'Dispensing Provider NPI does not join to Terminology Provider Table'
        else null
    end as INVALID_REASON                                                        
    ,CAST(M.DISPENSING_PROVIDER_NPI as {{ dbt.type_string() }}) AS FIELD_VALUE
    , '{{ var('tuva_last_run')}}' as tuva_last_run
FROM {{ ref('pharmacy_claim')}} M
LEFT JOIN {{ ref('terminology__provider')}} AS TERM ON M.DISPENSING_PROVIDER_NPI = TERM.NPI