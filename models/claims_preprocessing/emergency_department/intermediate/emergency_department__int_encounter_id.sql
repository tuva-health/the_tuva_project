{{ config(
     enabled = var('claims_preprocessing_enabled',var('claims_enabled',var('tuva_marts_enabled',False)))
   )
}}

-- *************************************************
-- This dbt model assigns an encounter_id to each
-- institutional or professional acute inpatient claim
-- that is eligible to be part of an encounter.
-- Professional acute inpatient claims that are
-- orphan claims (don't overlap with an institutional
-- acute inpatient claim) or that have
-- encounter_count > 1 (overlap with more than one different
-- acute inpatient encounter) are not included here.
-- It returns a table with these 3 columns:
--      patient_id
--      claim_id
--      encounter_id
-- *************************************************




select
  patient_id,
  claim_id,
  encounter_id,
  '{{ var('tuva_last_run')}}' as tuva_last_run
from {{ ref('emergency_department__int_institutional_encounter_id') }}

union distinct

select
  patient_id,
  claim_id,
  encounter_id,
  '{{ var('tuva_last_run')}}' as tuva_last_run
from {{ ref('emergency_department__int_professional_encounter_id') }}
where (orphan_claim_flag = 0) and (encounter_count = 1)
