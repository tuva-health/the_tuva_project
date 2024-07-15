{{ config(
    enabled = var('clinical_enabled', False)
) }}


SELECT
    M.Data_SOURCE
    ,coalesce(current_date,cast('1900-01-01' as date)) AS SOURCE_DATE
    ,'PATIENT' AS TABLE_NAME
    ,'Patient ID' as DRILL_DOWN_KEY
    , coalesce(patient_id, 'NULL') AS DRILL_DOWN_VALUE
    -- ,M.CLAIM_TYPE AS CLAIM_TYPE
    ,'BIRTH_DATE' AS FIELD_NAME
    ,CASE 
        WHEN M.BIRTH_DATE > cast(substring('{{ var('tuva_last_run') }}',1,10) as date) THEN 'invalid'
        WHEN M.BIRTH_DATE <= cast('1901-01-01' as date) THEN 'invalid'
        WHEN M.BIRTH_DATE > M.DEATH_DATE THEN 'invalid'
        WHEN M.BIRTH_DATE IS NULL THEN 'null'
        ELSE 'valid' 
    END AS BUCKET_NAME
    ,CASE 
        WHEN M.BIRTH_DATE > cast(substring('{{ var('tuva_last_run') }}',1,10) as date) THEN 'future'
        WHEN M.BIRTH_DATE <= cast('1901-01-01' as date) THEN 'too old'
        WHEN M.BIRTH_DATE > M.DEATH_DATE THEN 'Birth date after death date'
        else null
    END AS INVALID_REASON
    ,CAST(BIRTH_DATE as {{ dbt.type_string() }}) AS FIELD_VALUE
    , '{{ var('tuva_last_run')}}' as tuva_last_run
FROM {{ ref('patient')}} M