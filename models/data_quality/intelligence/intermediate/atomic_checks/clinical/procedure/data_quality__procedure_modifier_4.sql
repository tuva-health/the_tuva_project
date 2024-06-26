{{ config(
    enabled = var('clinical_enabled', False)
) }}


            SELECT
                M.Data_SOURCE
                ,coalesce(M.PROCEDURE_DATE,'1900-01-01') AS SOURCE_DATE
                ,'PROCEDURE' AS TABLE_NAME
                ,'Procedure ID' as DRILL_DOWN_KEY
                ,IFNULL(PROCEDURE_ID, 'NULL') AS DRILL_DOWN_VALUE
                -- ,M.CLAIM_TYPE AS CLAIM_TYPE
                ,'MODIFIER_4' AS FIELD_NAME
                ,case when M.MODIFIER_4 is not null then 'valid' else 'null' end as BUCKET_NAME
                ,null as INVALID_REASON
                ,CAST(MODIFIER_4 AS VARCHAR(255)) AS FIELD_VALUE
            FROM {{source('tuva_clinical_input','procedure')}} M
            