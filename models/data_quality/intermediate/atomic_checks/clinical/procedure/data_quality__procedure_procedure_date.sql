{{ config(
    enabled = var('clinical_enabled', False)
) }}


SELECT
    M.Data_SOURCE
    ,coalesce(M.PROCEDURE_DATE,cast('1900-01-01' as date)) AS SOURCE_DATE
    ,'PROCEDURE' AS TABLE_NAME
    ,'Procedure ID' as DRILL_DOWN_KEY
    , coalesce(procedure_id, 'NULL') AS DRILL_DOWN_VALUE
    -- ,M.CLAIM_TYPE AS CLAIM_TYPE
    ,'PROCEDURE_DATE' AS FIELD_NAME
    ,CASE 
        WHEN M.PROCEDURE_DATE > cast(substring('{{ var('tuva_last_run') }}',1,10) as date) THEN 'invalid'
        WHEN M.PROCEDURE_DATE <= cast('1901-01-01' as date) THEN 'invalid'
        WHEN M.PROCEDURE_DATE IS NULL THEN 'null'
        ELSE 'valid' 
    END AS BUCKET_NAME
    ,CASE 
        WHEN M.PROCEDURE_DATE > cast(substring('{{ var('tuva_last_run') }}',1,10) as date) THEN 'future'
        WHEN M.PROCEDURE_DATE <= cast('1901-01-01' as date) THEN 'too old'
        else null
    END AS INVALID_REASON
    ,CAST(PROCEDURE_DATE as {{ dbt.type_string() }}) AS FIELD_VALUE
    , '{{ var('tuva_last_run')}}' as tuva_last_run
FROM {{ ref('procedure')}} M