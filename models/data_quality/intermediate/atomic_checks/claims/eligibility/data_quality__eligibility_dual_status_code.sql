{{ config(
    enabled = var('claims_enabled', False)
) }}

SELECT DISTINCT 
    M.Data_SOURCE
    ,coalesce(cast(M.ENROLLMENT_START_DATE as {{ dbt.type_string() }}),cast('1900-01-01' as {{ dbt.type_string() }})) AS SOURCE_DATE
    ,'ELIGIBILITY' AS TABLE_NAME
    ,'Member ID | Enrollment Start Date' AS DRILL_DOWN_KEY
        ,coalesce(M.Member_ID, 'NULL') as DRILL_DOWN_VALUE
    ,'ELIGIBILITY' AS CLAIM_TYPE
    ,'DUAL_STATUS_CODE' AS FIELD_NAME
    ,case when M.DUAL_STATUS_CODE is null then 'null' 
          when TERM.DUAL_STATUS_CODE is null then 'invalid'
                             else 'valid' end as BUCKET_NAME
    ,case
        when M.DUAL_STATUS_CODE is not null and TERM.DUAL_STATUS_CODE is null then 'Dual Status Code does not join to Terminology Medicare Dual Eligibility table'
        else null
    end as INVALID_REASON
    ,CAST(M.DUAL_STATUS_CODE || '|' || COALESCE(TERM.DUAL_STATUS_DESCRIPTION, '') as {{ dbt.type_string() }}) AS FIELD_VALUE
    , '{{ var('tuva_last_run')}}' as tuva_last_run
FROM {{ ref('eligibility')}} M
LEFT JOIN {{ ref('terminology__medicare_dual_eligibility')}} TERM ON M.DUAL_STATUS_CODE = TERM.DUAL_STATUS_CODE