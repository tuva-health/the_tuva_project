{{ config(
    enabled = var('claims_enabled', False)
) }}

WITH BASE as (
    SELECT * 
    FROM {{ ref('medical_claim')}}
    WHERE CLAIM_TYPE = 'professional'
)

SELECT
    M.Data_SOURCE
    ,coalesce(cast(M.CLAIM_START_DATE as {{ dbt.type_string() }}),cast('1900-01-01' as {{ dbt.type_string() }})) AS SOURCE_DATE
    ,'MEDICAL_CLAIM' AS TABLE_NAME
    ,'Claim ID | Claim Line Number' AS DRILL_DOWN_KEY
    ,COALESCE(CAST(M.CLAIM_ID as {{ dbt.type_string() }}), 'NULL') || '|' || COALESCE(CAST(M.CLAIM_LINE_NUMBER as {{ dbt.type_string() }}), 'NULL') AS DRILL_DOWN_VALUE
    ,'professional' AS CLAIM_TYPE
    ,'PLACE_OF_SERVICE_CODE' AS FIELD_NAME
    ,case when TERM.PLACE_OF_SERVICE_CODE is not null then 'valid'
          when M.PLACE_OF_SERVICE_CODE is not null    then 'invalid'      
                                               else 'null' end as BUCKET_NAME
    ,case
        when M.PLACE_OF_SERVICE_CODE is not null
            and TERM.PLACE_OF_SERVICE_CODE is null
            then 'Place of Service Code does not join to Terminology Place of Service table'
        else null
    end as INVALID_REASON
    ,CAST(M.PLACE_OF_SERVICE_CODE || '|' || COALESCE(TERM.PLACE_OF_SERVICE_DESCRIPTION, '') as {{ dbt.type_string() }}) AS FIELD_VALUE
    , '{{ var('tuva_last_run')}}' as tuva_last_run
FROM base M
LEFT JOIN {{ ref('terminology__place_of_service')}} AS TERM ON M.PLACE_OF_SERVICE_CODE = TERM.PLACE_OF_SERVICE_CODE