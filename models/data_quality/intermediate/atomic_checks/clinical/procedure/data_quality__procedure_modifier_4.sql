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
    ,'MODIFIER_4' AS FIELD_NAME
    ,case when TERM.HCPCS is not null then 'valid'
          when M.MODIFIER_4 is not null then 'invalid'
          else 'null' 
    end as BUCKET_NAME
    ,case when M.MODIFIER_4 is not null and TERM.HCPCS is null
          then 'Modifier 4 does not join to Terminology hcpcs_level_2 table'
    else null end as INVALID_REASON
    ,CAST(MODIFIER_4 as {{ dbt.type_string() }}) AS FIELD_VALUE
    , '{{ var('tuva_last_run')}}' as tuva_last_run
FROM {{ ref('procedure')}} M
LEFT JOIN {{ ref('terminology__hcpcs_level_2')}} TERM on m.MODIFIER_4 = term.HCPCS