{{ config(
    enabled = var('clinical_enabled', False)
) }}


            SELECT
                M.Data_SOURCE
                ,coalesce(M.OBSERVATION_DATE,cast('1900-01-01' as date)) AS SOURCE_DATE
                ,'OBSERVATION' AS TABLE_NAME
                ,'Observation ID' as DRILL_DOWN_KEY
                , coalesce(observation_id, 'NULL') AS DRILL_DOWN_VALUE
                -- ,M.CLAIM_TYPE AS CLAIM_TYPE
                ,'RESULT' AS FIELD_NAME
                ,case when M.RESULT is not null then 'valid' else 'null' end as BUCKET_NAME
                ,cast(null as {{ dbt.type_string() }}) as INVALID_REASON
                ,CAST(SUBSTRING(RESULT, 1, 255) AS {{ dbt.type_string() }}) AS FIELD_VALUE
                , '{{ var('tuva_last_run')}}' as tuva_last_run
            FROM {{ ref('observation')}} M
