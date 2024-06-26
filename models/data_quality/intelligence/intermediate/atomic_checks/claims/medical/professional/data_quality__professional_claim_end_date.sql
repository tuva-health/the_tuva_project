{{ config(
    enabled = var('claims_enabled', False)
) }}

WITH BASE as (
    SELECT * 
    FROM {{ source('tuva_claim_input','medical_claim') }}
    WHERE CLAIM_TYPE = 'institutional'
),
UNIQUE_FIELD as (
    SELECT DISTINCT CLAIM_ID
        ,CLAIM_END_DATE as Field
        ,DATA_SOURCE
    FROM BASE
),
CLAIM_GRAIN as (
    SELECT CLAIM_ID
        ,DATA_SOURCE
        ,count(*) as FREQUENCY
    from UNIQUE_FIELD 
    GROUP BY CLAIM_ID
        ,DATA_SOURCE
),
CLAIM_AGG as (
    SELECT
        CLAIM_ID,
        DATA_SOURCE,
        LISTAGG(IFF(Field IS NULL, 'null', TO_VARCHAR(Field)), ', ') WITHIN GROUP (ORDER BY Field DESC) AS FIELD_AGGREGATED
    FROM
        UNIQUE_FIELD
    GROUP BY
        CLAIM_ID,
        DATA_SOURCE
)
SELECT
    M.Data_SOURCE
    ,coalesce(M.CLAIM_START_DATE,'1900-01-01') AS SOURCE_DATE
    ,'MEDICAL_CLAIM' AS TABLE_NAME
    ,'Claim ID' AS DRILL_DOWN_KEY
    ,IFNULL(M.CLAIM_ID, 'NULL') AS DRILL_DOWN_VALUE
    ,'professional' AS CLAIM_TYPE
    ,'CLAIM_END_DATE' AS FIELD_NAME
    ,CASE 
        WHEN CG.FREQUENCY > 1 THEN 'multiple'      
        WHEN M.CLAIM_END_DATE > CURRENT_DATE() THEN 'invalid'
        WHEN M.CLAIM_END_DATE < DATEADD(year, -10, CURRENT_DATE()) THEN 'invalid'
        WHEN M.CLAIM_END_DATE < M.CLAIM_START_DATE THEN 'invalid'
        WHEN M.CLAIM_END_DATE IS NULL THEN 'null'
        ELSE 'valid' 
    END AS BUCKET_NAME
    ,CASE 
        WHEN CG.FREQUENCY > 1 THEN 'multiple'      
        WHEN M.CLAIM_END_DATE > CURRENT_DATE() THEN 'future'
        WHEN M.CLAIM_END_DATE < DATEADD(year, -10, CURRENT_DATE()) THEN 'too old'
        WHEN M.CLAIM_END_DATE < M.CLAIM_START_DATE THEN 'claim end date before start date'
        WHEN M.CLAIM_END_DATE IS NULL THEN null
        ELSE 'valid' 
    END AS INVALID_REASON
    ,CAST(LEFT(AGG.FIELD_AGGREGATED,255) AS VARCHAR(255)) AS FIELD_VALUE
FROM BASE M
LEFT JOIN CLAIM_GRAIN CG ON M.CLAIM_ID = CG.CLAIM_ID AND M.Data_Source = CG.Data_Source
LEFT JOIN CLAIM_AGG AGG ON M.CLAIM_ID = AGG.CLAIM_ID AND M.Data_Source = AGG.Data_Source