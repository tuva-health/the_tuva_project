{{ config(
     enabled = var('clinical_enabled',False)
   )
}}

WITH valid_conditions AS (
    SELECT 
        *
    FROM 
        {{ ref('data_quality__location_location_id') }}
    WHERE 
        BUCKET_NAME = 'valid'
)
, uniqueness_check as (
        SELECT
                FIELD_VALUE,
                COUNT(*) AS duplicate_count
        FROM 
                valid_conditions
        GROUP BY 
                FIELD_VALUE
        HAVING 
                COUNT(*) > 1
)

, random_sample AS (
    SELECT 
        Data_SOURCE,
        SOURCE_DATE,
        TABLE_NAME,
        DRILL_DOWN_KEY,
        DRILL_DOWN_VALUE,
        FIELD_NAME,
        FIELD_VALUE,
        BUCKET_NAME,
        ROW_NUMBER() OVER (ORDER BY DRILL_DOWN_KEY) as row_number_value
    FROM 
        {{ ref('data_quality__location_location_id') }}
    WHERE 
        BUCKET_NAME = 'valid'

)

, duplicates_summary AS (
    SELECT 
        a.Data_SOURCE,
        a.SOURCE_DATE,
        a.TABLE_NAME,
        a.DRILL_DOWN_KEY,
        a.DRILL_DOWN_VALUE,
        a.FIELD_NAME,
        a.FIELD_VALUE,
        a.BUCKET_NAME,
        b.duplicate_count,
        ROW_NUMBER() OVER (ORDER BY DRILL_DOWN_KEY) as row_number_value
    FROM 
        {{ ref('data_quality__location_location_id') }} a
    JOIN 
        uniqueness_check b ON a.FIELD_VALUE = b.FIELD_VALUE
) 

SELECT 
    *
    , '{{ var('tuva_last_run')}}' as tuva_last_run
FROM 
    duplicates_summary
where row_number_value <= 5

union all

SELECT 
    *,
    0 as duplicate_count
    , '{{ var('tuva_last_run')}}' as tuva_last_run
FROM 
    random_sample
WHERE
    row_number_value <= 5
    and NOT EXISTS (SELECT 1 FROM duplicates_summary)