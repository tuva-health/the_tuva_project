





with check_for_merges_with_larger_row_num as (
select
  aa.patient_id,
  aa.therapy,
  aa.unique_id as unique_id_a,
  bb.unique_id as unique_id_b,
  aa.row_num as row_num_a,
  bb.row_num as row_num_b,

-- Case statement to create a merge_flag
-- that is 1 when the pair of treatment periods
-- should be merged and 0 when it should not be merged:
  case

-- When the treatment periods overlap they should
-- be merged:
    when
    (
     (aa.start_date between bb.start_date and bb.end_date)
     or
     (aa.end_date between bb.start_date and bb.end_date)
     or
     (bb.start_date between aa.start_date and aa.end_date)
     or
     (bb.end_date between aa.start_date and aa.end_date)
    ) then 1

-- For all other cases, the treatment periods should not be merged:
    else 0
    
  end as merge_flag


from {{ ref('raw_patient_treatment_periods') }} aa
inner join {{ ref('raw_patient_treatment_periods') }} bb
on aa.patient_id = bb.patient_id
and aa.therapy = bb.therapy
and aa.row_num < bb.row_num
),


merges_with_larger_row_num as (
select
  patient_id,
  therapy,
  unique_id_a,
  unique_id_b,
  row_num_a,
  row_num_b,
  merge_flag
from check_for_merges_with_larger_row_num
where merge_flag = 1
),


unique_ids_that_merge_with_larger_row_num as (
select distinct unique_id_a as unique_id
from merges_with_larger_row_num
),


unique_ids_having_a_smaller_row_num_merging_with_a_larger_row_num as (
select distinct aa.unique_id as unique_id
from {{ ref('raw_patient_treatment_periods') }} aa   
     inner join
     merges_with_larger_row_num bb
     on aa.patient_id = bb.patient_id
     and aa.therapy = bb.therapy
     and bb.row_num_a < aa.row_num
     and bb.row_num_b > aa.row_num
),


close_flags as (
select
  aa.patient_id,
  aa.therapy,
  aa.unique_id,
  aa.row_num,
  case when (bb.unique_id is null and cc.unique_id is null) then 1
       else 0
  end as close_flag

from {{ ref('raw_patient_treatment_periods') }} aa

left join unique_ids_that_merge_with_larger_row_num bb
on aa.unique_id = bb.unique_id

left join unique_ids_having_a_smaller_row_num_merging_with_a_larger_row_num cc
on aa.unique_id = cc.unique_id
),


join_every_row_to_later_closes as (
select
  aa.patient_id as patient_id,
  aa.therapy,
  aa.unique_id as unique_id,
  aa.row_num as row_num,
  bb.row_num as row_num_b
from close_flags aa inner join close_flags bb
     on aa.patient_id = bb.patient_id
     and aa.therapy = bb.therapy
     and aa.row_num <= bb.row_num
where bb.close_flag = 1
),


find_min_closing_row_num_for_every_treatment_period as (
select
  patient_id,
  therapy,
  unique_id,
  min(row_num_b) as min_closing_row
from join_every_row_to_later_closes
group by patient_id, therapy, unique_id
),


add_min_closing_row_to_every_treatment_period as (
select
  aa.patient_id as patient_id,
  aa.therapy,
  aa.unique_id as unique_id,
  aa.row_num as row_num,
  aa.close_flag as close_flag,
  bb.min_closing_row as min_closing_row
from close_flags aa
     left join find_min_closing_row_num_for_every_treatment_period bb
     on aa.patient_id = bb.patient_id
     and aa.therapy = bb.therapy
     and aa.unique_id = bb.unique_id
),


add_treatment_period_id as (
select
  aa.patient_id as patient_id,
  aa.therapy,
  aa.unique_id as unique_id,
  aa.row_num as row_num,
  aa.close_flag as close_flag,
  aa.min_closing_row as min_closing_row,
  bb.unique_id as treatment_period_id
from add_min_closing_row_to_every_treatment_period aa
     left join add_min_closing_row_to_every_treatment_period bb
     on aa.patient_id = bb.patient_id
     and aa.therapy = bb.therapy
     and aa.min_closing_row = bb.row_num
)


select
  unique_id,
  treatment_period_id
from add_treatment_period_id

