{{ config(
    enabled = var('clinical_enabled', False)
) }}

SELECT
    M.Data_SOURCE
    ,coalesce(M.ENCOUNTER_START_DATE,'1900-01-01') AS SOURCE_DATE
    ,'ENCOUNTER' AS TABLE_NAME
    ,'Encounter ID' as DRILL_DOWN_KEY
    ,IFNULL(ENCOUNTER_ID, 'NULL') AS DRILL_DOWN_VALUE
    -- ,M.CLAIM_TYPE AS CLAIM_TYPE
    ,'PRIMARY_DIAGNOSIS_CODE_TYPE' AS FIELD_NAME
    ,case when M.PRIMARY_DIAGNOSIS_CODE_TYPE is not null then 'valid' else 'null' end as BUCKET_NAME
    ,null as INVALID_REASON
    ,CAST(PRIMARY_DIAGNOSIS_CODE_TYPE AS VARCHAR(255)) AS FIELD_VALUE
FROM {{ source('tuva_clinical_input','encounter') }} M