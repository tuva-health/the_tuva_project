{{ config(
     enabled = var('claims_enabled',var('tuva_marts_enabled',False))
 | as_bool
   )
}}

WITH RankedMonths AS (
    SELECT
        person_id,
        year_month,
        data_source,
        {{ quote_column('plan') }},
        lag(year_month_date, 1) over (partition by person_id, data_source, {{ quote_column('plan') }} order by year_month_date) as prev_year_month,
        lead(year_month_date, 1) over (partition by person_id, data_source, {{ quote_column('plan') }} order by year_month_date) as next_year_month,
        year_month_date
    FROM {{ ref('mart_review__stg_member_month') }}
),
Changes AS (
 SELECT
    person_id,
    data_source,
    {{ quote_column('plan') }},
    year_month_date as change_month,
    case
        when prev_year_month is null
            or {{ dateadd('month', -1, 'year_month_date') }} != prev_year_month
        then 'added'
    end as change_type
FROM RankedMonths
union all
SELECT
    person_id,
    data_source,
    {{ quote_column('plan') }},
    {{ dateadd('month', 1, 'year_month_date') }} as change_month,
    case
        when next_year_month is null
            or {{ dateadd('month', 1, 'year_month_date') }} != next_year_month
        then 'removed'
    end as change_type
FROM RankedMonths

),
Final AS (
    SELECT
       {{ dbt.concat(["person_id", "'|'", "change_month"]) }} as membermonthkey,
        data_source,
        person_id,
        {{ quote_column('plan') }},
        change_month,
        change_type
    FROM Changes
    WHERE change_type IS NOT NULL
),
Result AS (
    SELECT
        data_source,
        change_month,
        change_type,
        {{ quote_column('plan') }},
        count(*) as member_count
    FROM Final
    GROUP BY data_source
    , change_month
    , change_type
    , {{ quote_column('plan') }}
)


SELECT * , '{{ var('tuva_last_run')}}' as tuva_last_run
FROM Result