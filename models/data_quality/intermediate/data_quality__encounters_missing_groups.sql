{{ config(
    enabled = var('claims_enabled', var('tuva_marts_enabled', false)) | as_bool
) }}

with expected_groups as (
    select 'inpatient' as encounter_group
    union all
    select 'outpatient'
    union all
    select 'office based'
    union all
    select 'other'
)

, actual_groups as (
    select distinct
        encounter_group
    from {{ ref('core__encounter') }}
)

select
    e.encounter_group as missing_encounter_group
from expected_groups e
    left join actual_groups a
        on e.encounter_group = a.encounter_group
where a.encounter_group is null