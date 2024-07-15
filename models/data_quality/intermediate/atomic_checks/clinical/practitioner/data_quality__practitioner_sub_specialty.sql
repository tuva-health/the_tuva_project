{{ config(
    enabled = var('clinical_enabled', False)
) }}


            SELECT
                M.Data_SOURCE
                ,coalesce(current_date,cast('1900-01-01' as date)) AS SOURCE_DATE
                ,'PRACTITIONER' AS TABLE_NAME
                ,'Practitioner ID' as DRILL_DOWN_KEY
                , coalesce(practitioner_id, 'NULL') AS DRILL_DOWN_VALUE
                -- ,M.CLAIM_TYPE AS CLAIM_TYPE
                ,'SUB_SPECIALTY' AS FIELD_NAME
                ,case when M.SUB_SPECIALTY is not null then 'valid' else 'null' end as BUCKET_NAME
                ,cast(null as {{ dbt.type_string() }}) as INVALID_REASON
                ,CAST(SUB_SPECIALTY as {{ dbt.type_string() }}) AS FIELD_VALUE
                , '{{ var('tuva_last_run')}}' as tuva_last_run
            FROM {{ ref('practitioner')}} M
            