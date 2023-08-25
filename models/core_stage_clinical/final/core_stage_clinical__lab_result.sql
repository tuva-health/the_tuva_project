select
    lab_result_id
    , patient_id
    , encounter_id
    , accession_number
    , source_code_type
    , source_code
    , source_description
    , source_component
    , normalized_code_type
    , normalized_code
    , normalized_description
    , normalized_component
    , status
    , result
    , result_date
    , collection_date
    , source_units
    , normalized_units
    , source_reference_range_low
    , source_reference_range_high
    , normalized_reference_range_low
    , normalized_reference_range_high
    , source_abnormal_flag
    , normalized_abnormal_flag
    , specimen
    , ordering_practitioner_id
    , data_source
    , tuva_last_run
from {{ ref('core_stage_clinical__lab_result') }}