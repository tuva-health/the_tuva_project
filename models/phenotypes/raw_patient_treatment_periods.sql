



with add_row_num as (
select
  patient_id,
  therapy,
  start_date,
  end_date,
  row_number() over (
    partition by patient_id, therapy
    order by start_date, end_date
  ) as row_num
from {{ ref('drug_exposures') }}
),


add_unique_id as (
select
  patient_id,
  therapy,
  start_date,
  end_date,
  row_num,
  patient_id || '-' || therapy || '-' || row_num as unique_id
from add_row_num
)


select *
from add_unique_id


