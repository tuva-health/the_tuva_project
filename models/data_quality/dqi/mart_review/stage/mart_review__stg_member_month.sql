{{ config(
     enabled = var('claims_enabled',var('tuva_marts_enabled',False))
 | as_bool
   )
}}

with cte as
(
select distinct year_month_int
,full_date
from {{ ref('reference_data__calendar') }} c
where day = 1

)

select  mm.*
,c.year_month_int
,c.full_date as year_month_date
FROM {{ ref('core__member_months')}} mm
left join cte c on cast(mm.year_month as int) = c.year_month_int