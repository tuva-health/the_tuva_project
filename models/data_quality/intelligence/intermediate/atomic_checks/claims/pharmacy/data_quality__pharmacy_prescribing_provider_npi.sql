{{ config(
    enabled = var('claims_enabled', False)
) }}

SELECT DISTINCT -- to bring to claim_ID grain 
    M.Data_SOURCE
    ,coalesce(M.PAID_DATE,'1900-01-01') AS SOURCE_DATE
    ,'PHARMACY_CLAIM' AS TABLE_NAME
    ,'Claim ID | Claim Line Number' AS DRILL_DOWN_KEY
    ,IFNULL(M.CLAIM_ID, 'NULL') || '|' || IFNULL(TO_VARCHAR(M.CLAIM_LINE_NUMBER), 'NULL') AS DRILL_DOWN_VALUE
    ,'PHARMACY' AS CLAIM_TYPE
    ,'PRESCRIBING_PROVIDER_NPI' AS FIELD_NAME
    ,case when TERM.NPI is not null          then        'valid'
          when M.PRESCRIBING_PROVIDER_NPI is not null    then 'invalid'      
                                             else 'null' end as BUCKET_NAME
    ,case
        when M.PRESCRIBING_PROVIDER_NPI is not null
            and TERM.NPI is null
            then 'Prescribing Provider NPI does not join to Terminology Provider table'
        else null
    end as INVALID_REASON                                             
    ,CAST(M.PRESCRIBING_PROVIDER_NPI AS VARCHAR(255)) AS FIELD_VALUE
FROM {{ source('tuva_claim_input','pharmacy_claim') }} M
LEFT JOIN {{ source('tuva_terminology','provider') }} AS TERM ON M.PRESCRIBING_PROVIDER_NPI = TERM.NPI