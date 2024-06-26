{{ config(
    enabled = var('claims_enabled', False)
) }}

SELECT DISTINCT
    M.Data_SOURCE
    ,coalesce(M.ENROLLMENT_START_DATE,'1900-01-01') AS SOURCE_DATE
    ,'ELIGIBILITY' AS TABLE_NAME
    ,'Member ID | Enrollment Start Date' AS DRILL_DOWN_KEY
    ,IFNULL(M.MEMBER_ID,'NULL') || '|' || IFNULL(TO_VARCHAR(M.ENROLLMENT_START_DATE), 'NULL') AS DRILL_DOWN_VALUE
    ,'ELIGIBILITY' AS CLAIM_TYPE
    ,'PAYER' AS FIELD_NAME
    ,case when M.PAYER is not null then 'valid' else 'null' end as BUCKET_NAME
    ,null as INVALID_REASON
    ,CAST(PAYER AS VARCHAR(255)) AS FIELD_VALUE
FROM {{ source('tuva_claim_input','eligibility') }} M