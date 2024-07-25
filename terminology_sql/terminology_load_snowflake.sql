CREATE SCHEMA IF NOT EXISTS terminology;
CREATE OR REPLACE TABLE terminology.ADMIT_SOURCE (
	ADMIT_SOURCE_CODE varchar,
	ADMIT_SOURCE_DESCRIPTION varchar,
	NEWBORN_DESCRIPTION varchar
);
COPY INTO terminology.ADMIT_SOURCE
FROM 's3://tuva-public-resources/versioned_terminology/0.10.1/admit_source.csv'
FILE_FORMAT = (TYPE = CSV, COMPRESSION = 'GZIP', NULL_IF = ('\\N'), FIELD_OPTIONALLY_ENCLOSED_BY = '"');



CREATE SCHEMA IF NOT EXISTS terminology;
CREATE OR REPLACE TABLE terminology.ADMIT_TYPE (
	ADMIT_TYPE_CODE varchar,
	ADMIT_TYPE_DESCRIPTION varchar
);
COPY INTO terminology.ADMIT_TYPE
FROM 's3://tuva-public-resources/versioned_terminology/0.10.1/admit_type.csv'
FILE_FORMAT = (TYPE = CSV, COMPRESSION = 'GZIP', NULL_IF = ('\\N'), FIELD_OPTIONALLY_ENCLOSED_BY = '"');



CREATE SCHEMA IF NOT EXISTS terminology;
CREATE OR REPLACE TABLE terminology.APR_DRG (
	APR_DRG_CODE varchar,
	MEDICAL_SURGICAL varchar,
	MDC_CODE varchar,
	APR_DRG_DESCRIPTION varchar
);
COPY INTO terminology.APR_DRG
FROM 's3://tuva-public-resources/versioned_terminology/0.10.1/apr_drg.csv'
FILE_FORMAT = (TYPE = CSV, COMPRESSION = 'GZIP', NULL_IF = ('\\N'), FIELD_OPTIONALLY_ENCLOSED_BY = '"');



CREATE SCHEMA IF NOT EXISTS terminology;
CREATE OR REPLACE TABLE terminology.BILL_TYPE (
	BILL_TYPE_CODE varchar,
	BILL_TYPE_DESCRIPTION varchar,
	DEPRECATED integer,
	DEPRECATED_DATE date
);
COPY INTO terminology.BILL_TYPE
FROM 's3://tuva-public-resources/versioned_terminology/0.10.1/bill_type.csv'
FILE_FORMAT = (TYPE = CSV, COMPRESSION = 'GZIP', NULL_IF = ('\\N'), FIELD_OPTIONALLY_ENCLOSED_BY = '"');



CREATE SCHEMA IF NOT EXISTS terminology;
CREATE OR REPLACE TABLE terminology.CLAIM_TYPE (
	CLAIM_TYPE varchar
);
COPY INTO terminology.CLAIM_TYPE
FROM 's3://tuva-public-resources/versioned_terminology/0.10.1/claim_type.csv'
FILE_FORMAT = (TYPE = CSV, COMPRESSION = 'GZIP', NULL_IF = ('\\N'), FIELD_OPTIONALLY_ENCLOSED_BY = '"');



CREATE SCHEMA IF NOT EXISTS terminology;
CREATE OR REPLACE TABLE terminology.DISCHARGE_DISPOSITION (
	DISCHARGE_DISPOSITION_CODE varchar,
	DISCHARGE_DISPOSITION_DESCRIPTION varchar
);
COPY INTO terminology.DISCHARGE_DISPOSITION
FROM 's3://tuva-public-resources/versioned_terminology/0.10.1/discharge_disposition.csv'
FILE_FORMAT = (TYPE = CSV, COMPRESSION = 'GZIP', NULL_IF = ('\\N'), FIELD_OPTIONALLY_ENCLOSED_BY = '"');



CREATE SCHEMA IF NOT EXISTS terminology;
CREATE OR REPLACE TABLE terminology.ENCOUNTER_TYPE (
	ENCOUNTER_TYPE varchar
);
COPY INTO terminology.ENCOUNTER_TYPE
FROM 's3://tuva-public-resources/versioned_terminology/0.10.1/encounter_type.csv'
FILE_FORMAT = (TYPE = CSV, COMPRESSION = 'GZIP', NULL_IF = ('\\N'), FIELD_OPTIONALLY_ENCLOSED_BY = '"');



CREATE SCHEMA IF NOT EXISTS terminology;
CREATE OR REPLACE TABLE terminology.ETHNICITY (
	CODE varchar,
	DESCRIPTION varchar
);
COPY INTO terminology.ETHNICITY
FROM 's3://tuva-public-resources/versioned_terminology/0.10.1/ethnicity.csv'
FILE_FORMAT = (TYPE = CSV, COMPRESSION = 'GZIP', NULL_IF = ('\\N'), FIELD_OPTIONALLY_ENCLOSED_BY = '"');



CREATE SCHEMA IF NOT EXISTS terminology;
CREATE OR REPLACE TABLE terminology.GENDER (
	GENDER varchar
);
COPY INTO terminology.GENDER
FROM 's3://tuva-public-resources/versioned_terminology/0.10.1/gender.csv'
FILE_FORMAT = (TYPE = CSV, COMPRESSION = 'GZIP', NULL_IF = ('\\N'), FIELD_OPTIONALLY_ENCLOSED_BY = '"');



CREATE SCHEMA IF NOT EXISTS terminology;
CREATE OR REPLACE TABLE terminology.HCPCS_LEVEL_2 (
	HCPCS varchar,
	SEQNUM varchar,
	RECID varchar,
	LONG_DESCRIPTION varchar(2000),
	SHORT_DESCRIPTION varchar
);
COPY INTO terminology.HCPCS_LEVEL_2
FROM 's3://tuva-public-resources/versioned_terminology/0.10.1/hcpcs_level_2.csv'
FILE_FORMAT = (TYPE = CSV, COMPRESSION = 'GZIP', NULL_IF = ('\\N'), FIELD_OPTIONALLY_ENCLOSED_BY = '"');



CREATE SCHEMA IF NOT EXISTS terminology;
CREATE OR REPLACE TABLE terminology.ICD_9_CM (
	ICD_9_CM varchar,
	LONG_DESCRIPTION varchar,
	SHORT_DESCRIPTION varchar
);
COPY INTO terminology.ICD_9_CM
FROM 's3://tuva-public-resources/versioned_terminology/0.10.1/icd_9_cm.csv'
FILE_FORMAT = (TYPE = CSV, COMPRESSION = 'GZIP', NULL_IF = ('\\N'), FIELD_OPTIONALLY_ENCLOSED_BY = '"');



CREATE SCHEMA IF NOT EXISTS terminology;
CREATE OR REPLACE TABLE terminology.ICD_9_PCS (
	ICD_9_PCS varchar,
	LONG_DESCRIPTION varchar,
	SHORT_DESCRIPTION varchar
);
COPY INTO terminology.ICD_9_PCS
FROM 's3://tuva-public-resources/versioned_terminology/0.10.1/icd_9_pcs.csv'
FILE_FORMAT = (TYPE = CSV, COMPRESSION = 'GZIP', NULL_IF = ('\\N'), FIELD_OPTIONALLY_ENCLOSED_BY = '"');



CREATE SCHEMA IF NOT EXISTS terminology;
CREATE OR REPLACE TABLE terminology.ICD_10_CM (
	ICD_10_CM varchar,
	HEADER_FLAG varchar,
	SHORT_DESCRIPTION varchar,
	LONG_DESCRIPTION varchar
);
COPY INTO terminology.ICD_10_CM
FROM 's3://tuva-public-resources/versioned_terminology/0.10.1/icd_10_cm.csv'
FILE_FORMAT = (TYPE = CSV, COMPRESSION = 'GZIP', NULL_IF = ('\\N'), FIELD_OPTIONALLY_ENCLOSED_BY = '"');



CREATE SCHEMA IF NOT EXISTS terminology;
CREATE OR REPLACE TABLE terminology.ICD_10_PCS (
	ICD_10_PCS varchar,
	DESCRIPTION varchar
);
COPY INTO terminology.ICD_10_PCS
FROM 's3://tuva-public-resources/versioned_terminology/0.10.1/icd_10_pcs.csv'
FILE_FORMAT = (TYPE = CSV, COMPRESSION = 'GZIP', NULL_IF = ('\\N'), FIELD_OPTIONALLY_ENCLOSED_BY = '"');



CREATE SCHEMA IF NOT EXISTS terminology;
CREATE OR REPLACE TABLE terminology.LOINC (
	LOINC varchar,
	SHORT_NAME varchar,
	LONG_COMMON_NAME varchar,
	COMPONENT varchar,
	PROPERTY varchar,
	TIME_ASPECT varchar,
	SYSTEM varchar,
	SCALE_TYPE varchar,
	METHOD_TYPE varchar,
	CLASS_CODE varchar,
	CLASS_DESCRIPTION varchar,
	CLASS_TYPE_CODE varchar,
	CLASS_TYPE_DESCRIPTION varchar,
	EXTERNAL_COPYRIGHT_NOTICE varchar(3000),
	STATUS varchar,
	VERSION_FIRST_RELEASED varchar,
	VERSION_LAST_CHANGED varchar
);
COPY INTO terminology.LOINC
FROM 's3://tuva-public-resources/versioned_terminology/0.10.1/loinc.csv'
FILE_FORMAT = (TYPE = CSV, COMPRESSION = 'GZIP', NULL_IF = ('\\N'), FIELD_OPTIONALLY_ENCLOSED_BY = '"');



CREATE SCHEMA IF NOT EXISTS terminology;
CREATE OR REPLACE TABLE terminology.LOINC_DEPRECATED_MAPPING (
	LOINC varchar,
	MAP_TO varchar,
	COMMENT varchar,
	FINAL_MAP_TO varchar,
	ALL_COMMENTS varchar,
	DEPTH varchar
);
COPY INTO terminology.LOINC_DEPRECATED_MAPPING
FROM 's3://tuva-public-resources/versioned_terminology/0.10.1/loinc_deprecated_mapping.csv'
FILE_FORMAT = (TYPE = CSV, COMPRESSION = 'GZIP', NULL_IF = ('\\N'), FIELD_OPTIONALLY_ENCLOSED_BY = '"');



CREATE SCHEMA IF NOT EXISTS terminology;
CREATE OR REPLACE TABLE terminology.MDC (
	MDC_CODE varchar,
	MDC_DESCRIPTION varchar
);
COPY INTO terminology.MDC
FROM 's3://tuva-public-resources/versioned_terminology/0.10.1/mdc.csv'
FILE_FORMAT = (TYPE = CSV, COMPRESSION = 'GZIP', NULL_IF = ('\\N'), FIELD_OPTIONALLY_ENCLOSED_BY = '"');



CREATE SCHEMA IF NOT EXISTS terminology;
CREATE OR REPLACE TABLE terminology.MEDICARE_DUAL_ELIGIBILITY (
	DUAL_STATUS_CODE varchar,
	DUAL_STATUS_DESCRIPTION varchar
);
COPY INTO terminology.MEDICARE_DUAL_ELIGIBILITY
FROM 's3://tuva-public-resources/versioned_terminology/0.10.1/medicare_dual_eligibility.csv'
FILE_FORMAT = (TYPE = CSV, COMPRESSION = 'GZIP', NULL_IF = ('\\N'), FIELD_OPTIONALLY_ENCLOSED_BY = '"');



CREATE SCHEMA IF NOT EXISTS terminology;
CREATE OR REPLACE TABLE terminology.MEDICARE_OREC (
	ORIGINAL_REASON_ENTITLEMENT_CODE varchar,
	ORIGINAL_REASON_ENTITLEMENT_DESCRIPTION varchar
);
COPY INTO terminology.MEDICARE_OREC
FROM 's3://tuva-public-resources/versioned_terminology/0.10.1/medicare_orec.csv'
FILE_FORMAT = (TYPE = CSV, COMPRESSION = 'GZIP', NULL_IF = ('\\N'), FIELD_OPTIONALLY_ENCLOSED_BY = '"');



CREATE SCHEMA IF NOT EXISTS terminology;
CREATE OR REPLACE TABLE terminology.MEDICARE_STATUS (
	MEDICARE_STATUS_CODE varchar,
	MEDICARE_STATUS_DESCRIPTION varchar
);
COPY INTO terminology.MEDICARE_STATUS
FROM 's3://tuva-public-resources/versioned_terminology/0.10.1/medicare_status.csv'
FILE_FORMAT = (TYPE = CSV, COMPRESSION = 'GZIP', NULL_IF = ('\\N'), FIELD_OPTIONALLY_ENCLOSED_BY = '"');



CREATE SCHEMA IF NOT EXISTS terminology;
CREATE OR REPLACE TABLE terminology.MS_DRG (
	MS_DRG_CODE varchar,
	MDC_CODE varchar,
	MEDICAL_SURGICAL varchar,
	MS_DRG_DESCRIPTION varchar,
	DEPRECATED integer,
	DEPRECATED_DATE date
);
COPY INTO terminology.MS_DRG
FROM 's3://tuva-public-resources/versioned_terminology/0.10.1/ms_drg.csv'
FILE_FORMAT = (TYPE = CSV, COMPRESSION = 'GZIP', NULL_IF = ('\\N'), FIELD_OPTIONALLY_ENCLOSED_BY = '"');



CREATE SCHEMA IF NOT EXISTS terminology;
CREATE OR REPLACE TABLE terminology.NDC (
	NDC varchar,
	RXCUI varchar,
	RXNORM_DESCRIPTION varchar(3000),
	FDA_DESCRIPTION varchar(3000)
);
COPY INTO terminology.NDC
FROM 's3://tuva-public-resources/versioned_terminology/0.10.1/ndc.csv'
FILE_FORMAT = (TYPE = CSV, COMPRESSION = 'GZIP', NULL_IF = ('\\N'), FIELD_OPTIONALLY_ENCLOSED_BY = '"');



CREATE SCHEMA IF NOT EXISTS terminology;
CREATE OR REPLACE TABLE terminology.OTHER_PROVIDER_TAXONOMY (
	NPI varchar(35),
	TAXONOMY_CODE varchar(35),
	MEDICARE_SPECIALTY_CODE varchar(173),
	DESCRIPTION varchar(101),
	PRIMARY_FLAG integer
);
COPY INTO terminology.OTHER_PROVIDER_TAXONOMY
FROM 's3://tuva-public-resources/versioned_provider_data/0.10.1/other_provider_taxonomy.csv'
FILE_FORMAT = (TYPE = CSV, COMPRESSION = 'GZIP', NULL_IF = ('\\N'), FIELD_OPTIONALLY_ENCLOSED_BY = '"');



CREATE SCHEMA IF NOT EXISTS terminology;
CREATE OR REPLACE TABLE terminology.PAYER_TYPE (
	PAYER_TYPE varchar
);
COPY INTO terminology.PAYER_TYPE
FROM 's3://tuva-public-resources/versioned_terminology/0.10.1/payer_type.csv'
FILE_FORMAT = (TYPE = CSV, COMPRESSION = 'GZIP', NULL_IF = ('\\N'), FIELD_OPTIONALLY_ENCLOSED_BY = '"');



CREATE SCHEMA IF NOT EXISTS terminology;
CREATE OR REPLACE TABLE terminology.PLACE_OF_SERVICE (
	PLACE_OF_SERVICE_CODE varchar,
	PLACE_OF_SERVICE_DESCRIPTION varchar
);
COPY INTO terminology.PLACE_OF_SERVICE
FROM 's3://tuva-public-resources/versioned_terminology/0.10.1/place_of_service.csv'
FILE_FORMAT = (TYPE = CSV, COMPRESSION = 'GZIP', NULL_IF = ('\\N'), FIELD_OPTIONALLY_ENCLOSED_BY = '"');



CREATE SCHEMA IF NOT EXISTS terminology;
CREATE OR REPLACE TABLE terminology.PRESENT_ON_ADMISSION (
	PRESENT_ON_ADMIT_CODE varchar,
	PRESENT_ON_ADMIT_DESCRIPTION varchar
);
COPY INTO terminology.PRESENT_ON_ADMISSION
FROM 's3://tuva-public-resources/versioned_terminology/0.10.1/present_on_admission.csv'
FILE_FORMAT = (TYPE = CSV, COMPRESSION = 'GZIP', NULL_IF = ('\\N'), FIELD_OPTIONALLY_ENCLOSED_BY = '"');



CREATE SCHEMA IF NOT EXISTS terminology;
CREATE OR REPLACE TABLE terminology.PROVIDER (
	NPI varchar(35),
	ENTITY_TYPE_CODE varchar(26),
	ENTITY_TYPE_DESCRIPTION varchar(37),
	PRIMARY_TAXONOMY_CODE varchar(35),
	PRIMARY_SPECIALTY_DESCRIPTION varchar(173),
	PROVIDER_FIRST_NAME varchar(95),
	PROVIDER_LAST_NAME varchar(95),
	PROVIDER_ORGANIZATION_NAME varchar(95),
	PARENT_ORGANIZATION_NAME varchar(95),
	PRACTICE_ADDRESS_LINE_1 varchar(80),
	PRACTICE_ADDRESS_LINE_2 varchar(80),
	PRACTICE_CITY varchar(65),
	PRACTICE_STATE varchar(65),
	PRACTICE_ZIP_CODE varchar(42),
	LAST_UPDATED date,
	DEACTIVATION_DATE date,
	DEACTIVATION_FLAG varchar(80)
);
COPY INTO terminology.PROVIDER
FROM 's3://tuva-public-resources/versioned_provider_data/0.10.1/provider.csv'
FILE_FORMAT = (TYPE = CSV, COMPRESSION = 'GZIP', NULL_IF = ('\\N'), FIELD_OPTIONALLY_ENCLOSED_BY = '"');



CREATE SCHEMA IF NOT EXISTS terminology;
CREATE OR REPLACE TABLE terminology.RACE (
	CODE varchar,
	DESCRIPTION varchar
);
COPY INTO terminology.RACE
FROM 's3://tuva-public-resources/versioned_terminology/0.10.1/race.csv'
FILE_FORMAT = (TYPE = CSV, COMPRESSION = 'GZIP', NULL_IF = ('\\N'), FIELD_OPTIONALLY_ENCLOSED_BY = '"');



CREATE SCHEMA IF NOT EXISTS terminology;
CREATE OR REPLACE TABLE terminology.REVENUE_CENTER (
	REVENUE_CENTER_CODE varchar,
	REVENUE_CENTER_DESCRIPTION varchar
);
COPY INTO terminology.REVENUE_CENTER
FROM 's3://tuva-public-resources/versioned_terminology/0.10.1/revenue_center.csv'
FILE_FORMAT = (TYPE = CSV, COMPRESSION = 'GZIP', NULL_IF = ('\\N'), FIELD_OPTIONALLY_ENCLOSED_BY = '"');



CREATE SCHEMA IF NOT EXISTS terminology;
CREATE OR REPLACE TABLE terminology.RXNORM_TO_ATC (
	RXCUI varchar,
	RXNORM_DESCRIPTION varchar(3000),
	ATC_1_CODE varchar,
	ATC_1_NAME varchar,
	ATC_2_CODE varchar,
	ATC_2_NAME varchar,
	ATC_3_CODE varchar,
	ATC_3_NAME varchar,
	ATC_4_CODE varchar,
	ATC_4_NAME varchar
);
COPY INTO terminology.RXNORM_TO_ATC
FROM 's3://tuva-public-resources/versioned_terminology/0.10.1/rxnorm_to_atc.csv'
FILE_FORMAT = (TYPE = CSV, COMPRESSION = 'GZIP', NULL_IF = ('\\N'), FIELD_OPTIONALLY_ENCLOSED_BY = '"');



CREATE SCHEMA IF NOT EXISTS terminology;
CREATE OR REPLACE TABLE terminology.SNOMED_ICD_10_MAP (
	ID varchar,
	EFFECTIVE_TIME varchar,
	ACTIVE varchar,
	MODULE_ID varchar,
	REF_SET_ID varchar,
	REFERENCED_COMPONENT_ID varchar,
	REFERENCED_COMPONENT_NAME varchar,
	MAP_GROUP varchar,
	MAP_PRIORITY varchar,
	MAP_RULE varchar(500),
	MAP_ADVICE varchar(500),
	MAP_TARGET varchar,
	MAP_TARGET_NAME varchar,
	CORRELATION_ID varchar,
	MAP_CATEGORY_ID varchar,
	MAP_CATEGORY_NAME varchar
);
COPY INTO terminology.SNOMED_ICD_10_MAP
FROM 's3://tuva-public-resources/versioned_terminology/0.10.1/snomed_icd_10_map.csv'
FILE_FORMAT = (TYPE = CSV, COMPRESSION = 'GZIP', NULL_IF = ('\\N'), FIELD_OPTIONALLY_ENCLOSED_BY = '"');



CREATE SCHEMA IF NOT EXISTS terminology;
CREATE OR REPLACE TABLE terminology.SNOMED_CT (
	SNOMED_CT varchar,
	DESCRIPTION varchar,
	IS_ACTIVE varchar,
	CREATED date,
	LAST_UPDATED date
);
COPY INTO terminology.SNOMED_CT
FROM 's3://tuva-public-resources/versioned_terminology/0.10.1/snomed_ct.csv'
FILE_FORMAT = (TYPE = CSV, COMPRESSION = 'GZIP', NULL_IF = ('\\N'), FIELD_OPTIONALLY_ENCLOSED_BY = '"');



CREATE SCHEMA IF NOT EXISTS terminology;
CREATE OR REPLACE TABLE terminology.SNOMED_CT_TRANSITIVE_CLOSURES (
	PARENT_SNOMED_CODE varchar,
	PARENT_DESCRIPTION varchar,
	CHILD_SNOMED_CODE varchar,
	CHILD_DESCRIPTION varchar
);
COPY INTO terminology.SNOMED_CT_TRANSITIVE_CLOSURES
FROM 's3://tuva-public-resources/versioned_terminology/0.10.1/snomed_ct_transitive_closures.csv'
FILE_FORMAT = (TYPE = CSV, COMPRESSION = 'GZIP', NULL_IF = ('\\N'), FIELD_OPTIONALLY_ENCLOSED_BY = '"');



CREATE SCHEMA IF NOT EXISTS terminology;
CREATE OR REPLACE TABLE terminology.RXNORM_BRAND_GENERIC (
	PRODUCT_RXCUI varchar,
	PRODUCT_NAME varchar(3000),
	PRODUCT_TTY varchar,
	BRAND_VS_GENERIC varchar,
	BRAND_NAME varchar(1000),
	CLINICAL_PRODUCT_RXCUI varchar,
	CLINICAL_PRODUCT_NAME varchar(3000),
	CLINICAL_PRODUCT_TTY varchar,
	INGREDIENT_NAME varchar(3000),
	DOSE_FORM_NAME varchar
);
COPY INTO terminology.RXNORM_BRAND_GENERIC
FROM 's3://tuva-public-resources/versioned_terminology/0.10.1/rxnorm_brand_generic.csv'
FILE_FORMAT = (TYPE = CSV, COMPRESSION = 'GZIP', NULL_IF = ('\\N'), FIELD_OPTIONALLY_ENCLOSED_BY = '"');



CREATE SCHEMA IF NOT EXISTS clinical_concept_library;
CREATE OR REPLACE TABLE clinical_concept_library.CLINICAL_CONCEPTS (
	CONCEPT_ID varchar,
	CONCEPT_NAME varchar,
	STATUS varchar,
	CONCEPT_OID varchar,
	LAST_UPDATE_DATE date,
	LAST_UPDATE_NOTE varchar,
	CONCEPT_TYPE varchar,
	CONTENT_SOURCE varchar(3000),
	EXTERNAL_SOURCE_DETAIL varchar(3000),
	CONCEPT_SCOPE varchar(3000),
	VALUE_SET_SEARCH_NOTES varchar(3000),
	CODE varchar,
	CODE_DESCRIPTION varchar,
	CODING_SYSTEM_ID varchar,
	CODING_SYSTEM_VERSION varchar
);
COPY INTO clinical_concept_library.CLINICAL_CONCEPTS
FROM 's3://tuva-public-resources/versioned_value_sets/0.10.1/tuva_clinical_concepts.csv'
FILE_FORMAT = (TYPE = CSV, COMPRESSION = 'GZIP', NULL_IF = ('\\N'), FIELD_OPTIONALLY_ENCLOSED_BY = '"');



CREATE SCHEMA IF NOT EXISTS clinical_concept_library;
CREATE OR REPLACE TABLE clinical_concept_library.VALUE_SET_MEMBERS (
	VALUE_SET_MEMBER_ID varchar,
	CONCEPT_ID varchar,
	STATUS varchar,
	LAST_UPDATE_DATE date,
	LAST_UPDATE_NOTE varchar,
	CODE varchar,
	CODE_DESCRIPTION varchar(2000),
	CODING_SYSTEM_ID varchar,
	CODING_SYSTEM_VERSION varchar,
	INCLUDE_DESCENDANTS varchar,
	COMMENT varchar(2000)
);
COPY INTO clinical_concept_library.VALUE_SET_MEMBERS
FROM 's3://tuva-public-resources/versioned_value_sets/0.10.1/tuva_value_set_members.csv'
FILE_FORMAT = (TYPE = CSV, COMPRESSION = 'GZIP', NULL_IF = ('\\N'), FIELD_OPTIONALLY_ENCLOSED_BY = '"');



CREATE SCHEMA IF NOT EXISTS clinical_concept_library;
CREATE OR REPLACE TABLE clinical_concept_library.CODING_SYSTEMS (
	CODING_SYSTEM_ID varchar,
	CODING_SYSTEM_NAME varchar,
	CODING_SYSTEM_URI varchar,
	CODING_SYSTEM_OID varchar
);
COPY INTO clinical_concept_library.CODING_SYSTEMS
FROM 's3://tuva-public-resources/versioned_value_sets/0.10.1/tuva_coding_systems.csv'
FILE_FORMAT = (TYPE = CSV, COMPRESSION = 'GZIP', NULL_IF = ('\\N'), FIELD_OPTIONALLY_ENCLOSED_BY = '"');



CREATE SCHEMA IF NOT EXISTS pharmacy;
CREATE OR REPLACE TABLE pharmacy.RXNORM_GENERIC_AVAILABLE (
	PRODUCT_TTY varchar,
	PRODUCT_RXCUI varchar,
	PRODUCT_NAME varchar(3000),
	NDC_PRODUCT_TTY varchar,
	NDC_PRODUCT_RXCUI varchar,
	NDC_PRODUCT_NAME varchar(3000),
	NDC varchar,
	PRODUCT_STARTMARKETINGDATE date,
	PACKAGE_STARTMARKETINGDATE date
);
COPY INTO pharmacy.RXNORM_GENERIC_AVAILABLE
FROM 's3://tuva-public-resources/versioned_value_sets/0.10.1/rxnorm_generic_available.csv'
FILE_FORMAT = (TYPE = CSV, COMPRESSION = 'GZIP', NULL_IF = ('\\N'), FIELD_OPTIONALLY_ENCLOSED_BY = '"');



CREATE SCHEMA IF NOT EXISTS data_quality;
CREATE OR REPLACE TABLE data_quality._VALUE_SET_CROSSWALK_FIELD_INFO (
	INPUT_LAYER_TABLE_NAME varchar,
	CLAIM_TYPE varchar,
	FIELD_NAME varchar,
	RED integer,
	GREEN integer,
	UNIQUE_VALUES_EXPECTED_FLAG integer
);
COPY INTO data_quality._VALUE_SET_CROSSWALK_FIELD_INFO
FROM 's3://tuva-public-resources/versioned_value_sets/0.10.1/data_quality_crosswalk_field_info.csv'
FILE_FORMAT = (TYPE = CSV, COMPRESSION = 'GZIP', NULL_IF = ('\\N'), FIELD_OPTIONALLY_ENCLOSED_BY = '"');



CREATE SCHEMA IF NOT EXISTS data_quality;
CREATE OR REPLACE TABLE data_quality._VALUE_SET_CROSSWALK_FIELD_TO_MART (
	INPUT_LAYER_TABLE_NAME varchar,
	CLAIM_TYPE varchar,
	FIELD_NAME varchar,
	MART_NAME varchar
);
COPY INTO data_quality._VALUE_SET_CROSSWALK_FIELD_TO_MART
FROM 's3://tuva-public-resources/versioned_value_sets/0.10.1/data_quality_crosswalk_field_to_mart.csv'
FILE_FORMAT = (TYPE = CSV, COMPRESSION = 'GZIP', NULL_IF = ('\\N'), FIELD_OPTIONALLY_ENCLOSED_BY = '"');



CREATE SCHEMA IF NOT EXISTS data_quality;
CREATE OR REPLACE TABLE data_quality._VALUE_SET_CROSSWALK_MART_TO_OUTCOME_MEASURE (
	MART_NAME varchar,
	MEASURE_NAME varchar
);
COPY INTO data_quality._VALUE_SET_CROSSWALK_MART_TO_OUTCOME_MEASURE
FROM 's3://tuva-public-resources/versioned_value_sets/0.10.1/data_quality_crosswalk_mart_to_outcome_measure.csv'
FILE_FORMAT = (TYPE = CSV, COMPRESSION = 'GZIP', NULL_IF = ('\\N'), FIELD_OPTIONALLY_ENCLOSED_BY = '"');



CREATE SCHEMA IF NOT EXISTS data_quality;
CREATE OR REPLACE TABLE data_quality._VALUE_SET_CROSSWALK_MEASURE_REASONABLE_RANGES (
	MEASURE_NAME varchar,
	PAYER_TYPE varchar,
	LOWER_BOUND float,
	UPPER_BOUND float
);
COPY INTO data_quality._VALUE_SET_CROSSWALK_MEASURE_REASONABLE_RANGES
FROM 's3://tuva-public-resources/versioned_value_sets/0.10.1/data_quality_crosswalk_measure_reasonable_ranges.csv'
FILE_FORMAT = (TYPE = CSV, COMPRESSION = 'GZIP', NULL_IF = ('\\N'), FIELD_OPTIONALLY_ENCLOSED_BY = '"');



CREATE SCHEMA IF NOT EXISTS claims_preprocessing;
CREATE OR REPLACE TABLE claims_preprocessing._VALUE_SET_SERVICE_CATEGORIES (
	SERVICE_CATEGORY_1 varchar,
	SERVICE_CATEGORY_2 varchar
);
COPY INTO claims_preprocessing._VALUE_SET_SERVICE_CATEGORIES
FROM 's3://tuva-public-resources/versioned_value_sets/0.10.1/service_category_service_categories.csv'
FILE_FORMAT = (TYPE = CSV, COMPRESSION = 'GZIP', NULL_IF = ('\\N'), FIELD_OPTIONALLY_ENCLOSED_BY = '"');



CREATE SCHEMA IF NOT EXISTS ed_classification;
CREATE OR REPLACE TABLE ed_classification._VALUE_SET_CATEGORIES (
	CLASSIFICATION varchar,
	CLASSIFICATION_NAME varchar,
	CLASSIFICATION_ORDER varchar,
	CLASSIFICATION_COLUMN varchar
);
COPY INTO ed_classification._VALUE_SET_CATEGORIES
FROM 's3://tuva-public-resources/versioned_value_sets/0.10.1/ed_classification_categories.csv'
FILE_FORMAT = (TYPE = CSV, COMPRESSION = 'GZIP', NULL_IF = ('\\N'), FIELD_OPTIONALLY_ENCLOSED_BY = '"');



CREATE SCHEMA IF NOT EXISTS ed_classification;
CREATE OR REPLACE TABLE ed_classification._VALUE_SET_ICD_10_CM_TO_CCS (
	ICD_10_CM varchar,
	DESCRIPTION varchar,
	CCS_DIAGNOSIS_CATEGORY varchar,
	CCS_DESCRIPTION varchar
);
COPY INTO ed_classification._VALUE_SET_ICD_10_CM_TO_CCS
FROM 's3://tuva-public-resources/versioned_value_sets/0.10.1/icd_10_cm_to_ccs.csv'
FILE_FORMAT = (TYPE = CSV, COMPRESSION = 'GZIP', NULL_IF = ('\\N'), FIELD_OPTIONALLY_ENCLOSED_BY = '"');



CREATE SCHEMA IF NOT EXISTS ed_classification;
CREATE OR REPLACE TABLE ed_classification._VALUE_SET_JOHNSTON_ICD9 (
	ICD9 varchar,
	EDCNNPA varchar,
	EDCNPA varchar,
	EPCT varchar,
	NONER varchar,
	INJURY varchar,
	PSYCH varchar,
	ALCOHOL varchar,
	DRUG varchar
);
COPY INTO ed_classification._VALUE_SET_JOHNSTON_ICD9
FROM 's3://tuva-public-resources/versioned_value_sets/0.10.1/johnston_icd9.csv'
FILE_FORMAT = (TYPE = CSV, COMPRESSION = 'GZIP', NULL_IF = ('\\N'), FIELD_OPTIONALLY_ENCLOSED_BY = '"');



CREATE SCHEMA IF NOT EXISTS ed_classification;
CREATE OR REPLACE TABLE ed_classification._VALUE_SET_JOHNSTON_ICD10 (
	ICD10 varchar,
	EDCNNPA varchar,
	EDCNPA varchar,
	NONER varchar,
	EPCT varchar,
	INJURY varchar,
	PSYCH varchar,
	ALCOHOL varchar,
	DRUG varchar
);
COPY INTO ed_classification._VALUE_SET_JOHNSTON_ICD10
FROM 's3://tuva-public-resources/versioned_value_sets/0.10.1/johnston_icd10.csv'
FILE_FORMAT = (TYPE = CSV, COMPRESSION = 'GZIP', NULL_IF = ('\\N'), FIELD_OPTIONALLY_ENCLOSED_BY = '"');



CREATE SCHEMA IF NOT EXISTS readmissions;
CREATE OR REPLACE TABLE readmissions._VALUE_SET_ACUTE_DIAGNOSIS_CCS (
	CCS_DIAGNOSIS_CATEGORY varchar,
	DESCRIPTION varchar
);
COPY INTO readmissions._VALUE_SET_ACUTE_DIAGNOSIS_CCS
FROM 's3://tuva-public-resources/versioned_value_sets/0.10.1/acute_diagnosis_ccs.csv'
FILE_FORMAT = (TYPE = CSV, COMPRESSION = 'GZIP', NULL_IF = ('\\N'), FIELD_OPTIONALLY_ENCLOSED_BY = '"');



CREATE SCHEMA IF NOT EXISTS readmissions;
CREATE OR REPLACE TABLE readmissions._VALUE_SET_ACUTE_DIAGNOSIS_ICD_10_CM (
	ICD_10_CM varchar,
	DESCRIPTION varchar
);
COPY INTO readmissions._VALUE_SET_ACUTE_DIAGNOSIS_ICD_10_CM
FROM 's3://tuva-public-resources/versioned_value_sets/0.10.1/acute_diagnosis_icd_10_cm.csv'
FILE_FORMAT = (TYPE = CSV, COMPRESSION = 'GZIP', NULL_IF = ('\\N'), FIELD_OPTIONALLY_ENCLOSED_BY = '"');



CREATE SCHEMA IF NOT EXISTS readmissions;
CREATE OR REPLACE TABLE readmissions._VALUE_SET_ALWAYS_PLANNED_CCS_DIAGNOSIS_CATEGORY (
	CCS_DIAGNOSIS_CATEGORY varchar,
	DESCRIPTION varchar
);
COPY INTO readmissions._VALUE_SET_ALWAYS_PLANNED_CCS_DIAGNOSIS_CATEGORY
FROM 's3://tuva-public-resources/versioned_value_sets/0.10.1/always_planned_ccs_diagnosis_category.csv'
FILE_FORMAT = (TYPE = CSV, COMPRESSION = 'GZIP', NULL_IF = ('\\N'), FIELD_OPTIONALLY_ENCLOSED_BY = '"');



CREATE SCHEMA IF NOT EXISTS readmissions;
CREATE OR REPLACE TABLE readmissions._VALUE_SET_ALWAYS_PLANNED_CCS_PROCEDURE_CATEGORY (
	CCS_PROCEDURE_CATEGORY varchar,
	DESCRIPTION varchar
);
COPY INTO readmissions._VALUE_SET_ALWAYS_PLANNED_CCS_PROCEDURE_CATEGORY
FROM 's3://tuva-public-resources/versioned_value_sets/0.10.1/always_planned_ccs_procedure_category.csv'
FILE_FORMAT = (TYPE = CSV, COMPRESSION = 'GZIP', NULL_IF = ('\\N'), FIELD_OPTIONALLY_ENCLOSED_BY = '"');



CREATE SCHEMA IF NOT EXISTS readmissions;
CREATE OR REPLACE TABLE readmissions._VALUE_SET_EXCLUSION_CCS_DIAGNOSIS_CATEGORY (
	CCS_DIAGNOSIS_CATEGORY varchar,
	DESCRIPTION varchar,
	EXCLUSION_CATEGORY varchar
);
COPY INTO readmissions._VALUE_SET_EXCLUSION_CCS_DIAGNOSIS_CATEGORY
FROM 's3://tuva-public-resources/versioned_value_sets/0.10.1/exclusion_ccs_diagnosis_category.csv'
FILE_FORMAT = (TYPE = CSV, COMPRESSION = 'GZIP', NULL_IF = ('\\N'), FIELD_OPTIONALLY_ENCLOSED_BY = '"');



CREATE SCHEMA IF NOT EXISTS readmissions;
CREATE OR REPLACE TABLE readmissions._VALUE_SET_ICD_10_CM_TO_CCS (
	ICD_10_CM varchar,
	DESCRIPTION varchar,
	CCS_DIAGNOSIS_CATEGORY varchar,
	CCS_DESCRIPTION varchar
);
COPY INTO readmissions._VALUE_SET_ICD_10_CM_TO_CCS
FROM 's3://tuva-public-resources/versioned_value_sets/0.10.1/icd_10_cm_to_ccs.csv'
FILE_FORMAT = (TYPE = CSV, COMPRESSION = 'GZIP', NULL_IF = ('\\N'), FIELD_OPTIONALLY_ENCLOSED_BY = '"');



CREATE SCHEMA IF NOT EXISTS readmissions;
CREATE OR REPLACE TABLE readmissions._VALUE_SET_ICD_10_PCS_TO_CCS (
	ICD_10_PCS varchar,
	DESCRIPTION varchar,
	CCS_PROCEDURE_CATEGORY varchar,
	CCS_DESCRIPTION varchar
);
COPY INTO readmissions._VALUE_SET_ICD_10_PCS_TO_CCS
FROM 's3://tuva-public-resources/versioned_value_sets/0.10.1/icd_10_pcs_to_ccs.csv'
FILE_FORMAT = (TYPE = CSV, COMPRESSION = 'GZIP', NULL_IF = ('\\N'), FIELD_OPTIONALLY_ENCLOSED_BY = '"');



CREATE SCHEMA IF NOT EXISTS readmissions;
CREATE OR REPLACE TABLE readmissions._VALUE_SET_POTENTIALLY_PLANNED_CCS_PROCEDURE_CATEGORY (
	CCS_PROCEDURE_CATEGORY varchar,
	DESCRIPTION varchar
);
COPY INTO readmissions._VALUE_SET_POTENTIALLY_PLANNED_CCS_PROCEDURE_CATEGORY
FROM 's3://tuva-public-resources/versioned_value_sets/0.10.1/potentially_planned_ccs_procedure_category.csv'
FILE_FORMAT = (TYPE = CSV, COMPRESSION = 'GZIP', NULL_IF = ('\\N'), FIELD_OPTIONALLY_ENCLOSED_BY = '"');



CREATE SCHEMA IF NOT EXISTS readmissions;
CREATE OR REPLACE TABLE readmissions._VALUE_SET_POTENTIALLY_PLANNED_ICD_10_PCS (
	ICD_10_PCS varchar,
	DESCRIPTION varchar
);
COPY INTO readmissions._VALUE_SET_POTENTIALLY_PLANNED_ICD_10_PCS
FROM 's3://tuva-public-resources/versioned_value_sets/0.10.1/potentially_planned_icd_10_pcs.csv'
FILE_FORMAT = (TYPE = CSV, COMPRESSION = 'GZIP', NULL_IF = ('\\N'), FIELD_OPTIONALLY_ENCLOSED_BY = '"');



CREATE SCHEMA IF NOT EXISTS readmissions;
CREATE OR REPLACE TABLE readmissions._VALUE_SET_SPECIALTY_COHORT (
	CCS varchar,
	DESCRIPTION varchar,
	SPECIALTY_COHORT varchar,
	PROCEDURE_OR_DIAGNOSIS varchar
);
COPY INTO readmissions._VALUE_SET_SPECIALTY_COHORT
FROM 's3://tuva-public-resources/versioned_value_sets/0.10.1/specialty_cohort.csv'
FILE_FORMAT = (TYPE = CSV, COMPRESSION = 'GZIP', NULL_IF = ('\\N'), FIELD_OPTIONALLY_ENCLOSED_BY = '"');



CREATE SCHEMA IF NOT EXISTS readmissions;
CREATE OR REPLACE TABLE readmissions._VALUE_SET_SURGERY_GYNECOLOGY_COHORT (
	ICD_10_PCS varchar,
	DESCRIPTION varchar,
	CCS_CODE_AND_DESCRIPTION varchar,
	SPECIALTY_COHORT varchar
);
COPY INTO readmissions._VALUE_SET_SURGERY_GYNECOLOGY_COHORT
FROM 's3://tuva-public-resources/versioned_value_sets/0.10.1/surgery_gynecology_cohort.csv'
FILE_FORMAT = (TYPE = CSV, COMPRESSION = 'GZIP', NULL_IF = ('\\N'), FIELD_OPTIONALLY_ENCLOSED_BY = '"');



CREATE SCHEMA IF NOT EXISTS cms_hcc;
CREATE OR REPLACE TABLE cms_hcc._VALUE_SET_ADJUSTMENT_RATES (
	MODEL_VERSION varchar,
	PAYMENT_YEAR integer,
	NORMALIZATION_FACTOR float,
	MA_CODING_PATTERN_ADJUSTMENT float
);
COPY INTO cms_hcc._VALUE_SET_ADJUSTMENT_RATES
FROM 's3://tuva-public-resources/versioned_value_sets/0.10.1/cms_hcc_adjustment_rates.csv'
FILE_FORMAT = (TYPE = CSV, COMPRESSION = 'GZIP', NULL_IF = ('\\N'), FIELD_OPTIONALLY_ENCLOSED_BY = '"');



CREATE SCHEMA IF NOT EXISTS cms_hcc;
CREATE OR REPLACE TABLE cms_hcc._VALUE_SET_CPT_HCPCS (
	PAYMENT_YEAR integer,
	HCPCS_CPT_CODE varchar,
	INCLUDED_FLAG varchar
);
COPY INTO cms_hcc._VALUE_SET_CPT_HCPCS
FROM 's3://tuva-public-resources/versioned_value_sets/0.10.1/cms_hcc_cpt_hcpcs.csv'
FILE_FORMAT = (TYPE = CSV, COMPRESSION = 'GZIP', NULL_IF = ('\\N'), FIELD_OPTIONALLY_ENCLOSED_BY = '"');



CREATE SCHEMA IF NOT EXISTS cms_hcc;
CREATE OR REPLACE TABLE cms_hcc._VALUE_SET_DEMOGRAPHIC_FACTORS (
	MODEL_VERSION varchar,
	FACTOR_TYPE varchar,
	ENROLLMENT_STATUS varchar,
	PLAN_SEGMENT varchar,
	GENDER varchar,
	AGE_GROUP varchar,
	MEDICAID_STATUS varchar,
	DUAL_STATUS varchar,
	OREC varchar,
	INSTITUTIONAL_STATUS varchar,
	COEFFICIENT float
);
COPY INTO cms_hcc._VALUE_SET_DEMOGRAPHIC_FACTORS
FROM 's3://tuva-public-resources/versioned_value_sets/0.10.1/cms_hcc_demographic_factors.csv'
FILE_FORMAT = (TYPE = CSV, COMPRESSION = 'GZIP', NULL_IF = ('\\N'), FIELD_OPTIONALLY_ENCLOSED_BY = '"');



CREATE SCHEMA IF NOT EXISTS cms_hcc;
CREATE OR REPLACE TABLE cms_hcc._VALUE_SET_DISABLED_INTERACTION_FACTORS (
	MODEL_VERSION varchar,
	FACTOR_TYPE varchar,
	ENROLLMENT_STATUS varchar,
	INSTITUTIONAL_STATUS varchar,
	SHORT_NAME varchar,
	DESCRIPTION varchar,
	HCC_CODE varchar,
	COEFFICIENT float
);
COPY INTO cms_hcc._VALUE_SET_DISABLED_INTERACTION_FACTORS
FROM 's3://tuva-public-resources/versioned_value_sets/0.10.1/cms_hcc_disabled_interaction_factors.csv'
FILE_FORMAT = (TYPE = CSV, COMPRESSION = 'GZIP', NULL_IF = ('\\N'), FIELD_OPTIONALLY_ENCLOSED_BY = '"');



CREATE SCHEMA IF NOT EXISTS cms_hcc;
CREATE OR REPLACE TABLE cms_hcc._VALUE_SET_DISEASE_FACTORS (
	MODEL_VERSION varchar,
	FACTOR_TYPE varchar,
	ENROLLMENT_STATUS varchar,
	MEDICAID_STATUS varchar,
	DUAL_STATUS varchar,
	OREC varchar,
	INSTITUTIONAL_STATUS varchar,
	HCC_CODE varchar,
	DESCRIPTION varchar,
	COEFFICIENT float
);
COPY INTO cms_hcc._VALUE_SET_DISEASE_FACTORS
FROM 's3://tuva-public-resources/versioned_value_sets/0.10.1/cms_hcc_disease_factors.csv'
FILE_FORMAT = (TYPE = CSV, COMPRESSION = 'GZIP', NULL_IF = ('\\N'), FIELD_OPTIONALLY_ENCLOSED_BY = '"');



CREATE SCHEMA IF NOT EXISTS cms_hcc;
CREATE OR REPLACE TABLE cms_hcc._VALUE_SET_DISEASE_HIERARCHY (
	MODEL_VERSION varchar,
	HCC_CODE varchar,
	DESCRIPTION varchar,
	HCCS_TO_EXCLUDE varchar
);
COPY INTO cms_hcc._VALUE_SET_DISEASE_HIERARCHY
FROM 's3://tuva-public-resources/versioned_value_sets/0.10.1/cms_hcc_disease_hierarchy.csv'
FILE_FORMAT = (TYPE = CSV, COMPRESSION = 'GZIP', NULL_IF = ('\\N'), FIELD_OPTIONALLY_ENCLOSED_BY = '"');



CREATE SCHEMA IF NOT EXISTS cms_hcc;
CREATE OR REPLACE TABLE cms_hcc._VALUE_SET_DISEASE_INTERACTION_FACTORS (
	MODEL_VERSION varchar,
	FACTOR_TYPE varchar,
	ENROLLMENT_STATUS varchar,
	MEDICAID_STATUS varchar,
	DUAL_STATUS varchar,
	OREC varchar,
	INSTITUTIONAL_STATUS varchar,
	SHORT_NAME varchar,
	DESCRIPTION varchar,
	HCC_CODE_1 varchar,
	HCC_CODE_2 varchar,
	COEFFICIENT float
);
COPY INTO cms_hcc._VALUE_SET_DISEASE_INTERACTION_FACTORS
FROM 's3://tuva-public-resources/versioned_value_sets/0.10.1/cms_hcc_disease_interaction_factors.csv'
FILE_FORMAT = (TYPE = CSV, COMPRESSION = 'GZIP', NULL_IF = ('\\N'), FIELD_OPTIONALLY_ENCLOSED_BY = '"');



CREATE SCHEMA IF NOT EXISTS cms_hcc;
CREATE OR REPLACE TABLE cms_hcc._VALUE_SET_ENROLLMENT_INTERACTION_FACTORS (
	MODEL_VERSION varchar,
	FACTOR_TYPE varchar,
	GENDER varchar,
	ENROLLMENT_STATUS varchar,
	MEDICAID_STATUS varchar,
	DUAL_STATUS varchar,
	INSTITUTIONAL_STATUS varchar,
	DESCRIPTION varchar,
	COEFFICIENT float
);
COPY INTO cms_hcc._VALUE_SET_ENROLLMENT_INTERACTION_FACTORS
FROM 's3://tuva-public-resources/versioned_value_sets/0.10.1/cms_hcc_enrollment_interaction_factors.csv'
FILE_FORMAT = (TYPE = CSV, COMPRESSION = 'GZIP', NULL_IF = ('\\N'), FIELD_OPTIONALLY_ENCLOSED_BY = '"');



CREATE SCHEMA IF NOT EXISTS cms_hcc;
CREATE OR REPLACE TABLE cms_hcc._VALUE_SET_ICD_10_CM_MAPPINGS (
	PAYMENT_YEAR integer,
	DIAGNOSIS_CODE varchar,
	CMS_HCC_V24 varchar,
	CMS_HCC_V24_FLAG varchar,
	CMS_HCC_V28 varchar,
	CMS_HCC_V28_FLAG varchar
);
COPY INTO cms_hcc._VALUE_SET_ICD_10_CM_MAPPINGS
FROM 's3://tuva-public-resources/versioned_value_sets/0.10.1/cms_hcc_icd_10_cm_mappings.csv'
FILE_FORMAT = (TYPE = CSV, COMPRESSION = 'GZIP', NULL_IF = ('\\N'), FIELD_OPTIONALLY_ENCLOSED_BY = '"');



CREATE SCHEMA IF NOT EXISTS cms_hcc;
CREATE OR REPLACE TABLE cms_hcc._VALUE_SET_PAYMENT_HCC_COUNT_FACTORS (
	MODEL_VERSION varchar,
	FACTOR_TYPE varchar,
	ENROLLMENT_STATUS varchar,
	MEDICAID_STATUS varchar,
	DUAL_STATUS varchar,
	OREC varchar,
	INSTITUTIONAL_STATUS varchar,
	PAYMENT_HCC_COUNT varchar,
	DESCRIPTION varchar,
	COEFFICIENT float
);
COPY INTO cms_hcc._VALUE_SET_PAYMENT_HCC_COUNT_FACTORS
FROM 's3://tuva-public-resources/versioned_value_sets/0.10.1/cms_hcc_payment_hcc_count_factors.csv'
FILE_FORMAT = (TYPE = CSV, COMPRESSION = 'GZIP', NULL_IF = ('\\N'), FIELD_OPTIONALLY_ENCLOSED_BY = '"');



CREATE SCHEMA IF NOT EXISTS quality_measures;
CREATE OR REPLACE TABLE quality_measures._VALUE_SET_CONCEPTS (
	CONCEPT_NAME varchar,
	CONCEPT_OID varchar,
	MEASURE_ID varchar,
	MEASURE_NAME varchar
);
COPY INTO quality_measures._VALUE_SET_CONCEPTS
FROM 's3://tuva-public-resources/versioned_value_sets/0.10.1/quality_measures_concepts.csv'
FILE_FORMAT = (TYPE = CSV, COMPRESSION = 'GZIP', NULL_IF = ('\\N'), FIELD_OPTIONALLY_ENCLOSED_BY = '"');



CREATE SCHEMA IF NOT EXISTS quality_measures;
CREATE OR REPLACE TABLE quality_measures._VALUE_SET_MEASURES (
	ID varchar,
	NAME varchar,
	DESCRIPTION varchar(3000),
	VERSION varchar,
	STEWARD varchar
);
COPY INTO quality_measures._VALUE_SET_MEASURES
FROM 's3://tuva-public-resources/versioned_value_sets/0.10.1/quality_measures_measures.csv'
FILE_FORMAT = (TYPE = CSV, COMPRESSION = 'GZIP', NULL_IF = ('\\N'), FIELD_OPTIONALLY_ENCLOSED_BY = '"');



CREATE SCHEMA IF NOT EXISTS quality_measures;
CREATE OR REPLACE TABLE quality_measures._VALUE_SET_CODES (
	CONCEPT_NAME varchar,
	CONCEPT_OID varchar,
	CODE varchar,
	CODE_SYSTEM varchar
);
COPY INTO quality_measures._VALUE_SET_CODES
FROM 's3://tuva-public-resources/versioned_value_sets/0.10.1/quality_measures_value_set_codes.csv'
FILE_FORMAT = (TYPE = CSV, COMPRESSION = 'GZIP', NULL_IF = ('\\N'), FIELD_OPTIONALLY_ENCLOSED_BY = '"');



CREATE SCHEMA IF NOT EXISTS ccsr;
CREATE OR REPLACE TABLE ccsr._VALUE_SET_DXCCSR_V2023_1_BODY_SYSTEMS (
	BODY_SYSTEM varchar,
	CCSR_PARENT_CATEGORY varchar,
	PARENT_CATEGORY_DESCRIPTION varchar(3000)
);
COPY INTO ccsr._VALUE_SET_DXCCSR_V2023_1_BODY_SYSTEMS
FROM 's3://tuva-public-resources/versioned_value_sets/0.10.1/dxccsr_v2023_1_body_systems.csv'
FILE_FORMAT = (TYPE = CSV, COMPRESSION = 'GZIP', NULL_IF = ('\\N'), FIELD_OPTIONALLY_ENCLOSED_BY = '"');



CREATE SCHEMA IF NOT EXISTS ccsr;
CREATE OR REPLACE TABLE ccsr._VALUE_SET_DXCCSR_V2023_1_CLEANED_MAP (
	ICD_10_CM_CODE varchar,
	ICD_10_CM_CODE_DESCRIPTION varchar,
	DEFAULT_CCSR_CATEGORY_IP varchar,
	DEFAULT_CCSR_CATEGORY_DESCRIPTION_IP varchar,
	DEFAULT_CCSR_CATEGORY_OP varchar,
	DEFAULT_CCSR_CATEGORY_DESCRIPTION_OP varchar,
	CCSR_CATEGORY_1 varchar,
	CCSR_CATEGORY_1_DESCRIPTION varchar,
	CCSR_CATEGORY_2 varchar,
	CCSR_CATEGORY_2_DESCRIPTION varchar,
	CCSR_CATEGORY_3 varchar,
	CCSR_CATEGORY_3_DESCRIPTION varchar,
	CCSR_CATEGORY_4 varchar,
	CCSR_CATEGORY_4_DESCRIPTION varchar,
	CCSR_CATEGORY_5 varchar,
	CCSR_CATEGORY_5_DESCRIPTION varchar,
	CCSR_CATEGORY_6 varchar,
	CCSR_CATEGORY_6_DESCRIPTION varchar
);
COPY INTO ccsr._VALUE_SET_DXCCSR_V2023_1_CLEANED_MAP
FROM 's3://tuva-public-resources/versioned_value_sets/0.10.1/dxccsr_v2023_1_cleaned_map.csv'
FILE_FORMAT = (TYPE = CSV, COMPRESSION = 'GZIP', NULL_IF = ('\\N'), FIELD_OPTIONALLY_ENCLOSED_BY = '"');



CREATE SCHEMA IF NOT EXISTS ccsr;
CREATE OR REPLACE TABLE ccsr._VALUE_SET_PRCCSR_V2023_1_CLEANED_MAP (
	ICD_10_PCS varchar,
	ICD_10_PCS_DESCRIPTION varchar,
	PRCCSR varchar,
	PRCCSR_DESCRIPTION varchar,
	CLINICAL_DOMAIN varchar
);
COPY INTO ccsr._VALUE_SET_PRCCSR_V2023_1_CLEANED_MAP
FROM 's3://tuva-public-resources/versioned_value_sets/0.10.1/prccsr_v2023_1_cleaned_map.csv'
FILE_FORMAT = (TYPE = CSV, COMPRESSION = 'GZIP', NULL_IF = ('\\N'), FIELD_OPTIONALLY_ENCLOSED_BY = '"');



CREATE SCHEMA IF NOT EXISTS hcc_suspecting;
CREATE OR REPLACE TABLE hcc_suspecting._VALUE_SET_CLINICAL_CONCEPTS (
	CONCEPT_NAME varchar,
	CONCEPT_OID varchar,
	CODE varchar,
	CODE_SYSTEM varchar
);
COPY INTO hcc_suspecting._VALUE_SET_CLINICAL_CONCEPTS
FROM 's3://tuva-public-resources/versioned_value_sets/0.10.1/hcc_suspecting_clinical_concepts.csv'
FILE_FORMAT = (TYPE = CSV, COMPRESSION = 'GZIP', NULL_IF = ('\\N'), FIELD_OPTIONALLY_ENCLOSED_BY = '"');



CREATE SCHEMA IF NOT EXISTS hcc_suspecting;
CREATE OR REPLACE TABLE hcc_suspecting._VALUE_SET_HCC_DESCRIPTIONS (
	HCC_CODE varchar,
	HCC_DESCRIPTION varchar
);
COPY INTO hcc_suspecting._VALUE_SET_HCC_DESCRIPTIONS
FROM 's3://tuva-public-resources/versioned_value_sets/0.10.1/hcc_suspecting_descriptions.csv'
FILE_FORMAT = (TYPE = CSV, COMPRESSION = 'GZIP', NULL_IF = ('\\N'), FIELD_OPTIONALLY_ENCLOSED_BY = '"');



CREATE SCHEMA IF NOT EXISTS hcc_suspecting;
CREATE OR REPLACE TABLE hcc_suspecting._VALUE_SET_ICD_10_CM_MAPPINGS (
	DIAGNOSIS_CODE varchar,
	CMS_HCC_ESRD_V21 varchar,
	CMS_HCC_ESRD_V24 varchar,
	CMS_HCC_V22 varchar,
	CMS_HCC_V24 varchar,
	CMS_HCC_V28 varchar,
	RX_HCC_V05 varchar,
	RX_HCC_V08 varchar
);
COPY INTO hcc_suspecting._VALUE_SET_ICD_10_CM_MAPPINGS
FROM 's3://tuva-public-resources/versioned_value_sets/0.10.1/hcc_suspecting_icd_10_cm_mappings.csv'
FILE_FORMAT = (TYPE = CSV, COMPRESSION = 'GZIP', NULL_IF = ('\\N'), FIELD_OPTIONALLY_ENCLOSED_BY = '"');



CREATE SCHEMA IF NOT EXISTS chronic_conditions;
CREATE OR REPLACE TABLE chronic_conditions._VALUE_SET_TUVA_CHRONIC_CONDITIONS_HIERARCHY (
	CONDITION_FAMILY varchar,
	CONDITION varchar,
	ICD_10_CM_CODE varchar,
	ICD_10_CM_DESCRIPTION varchar,
	CONDITION_COLUMN_NAME varchar
);
COPY INTO chronic_conditions._VALUE_SET_TUVA_CHRONIC_CONDITIONS_HIERARCHY
FROM 's3://tuva-public-resources/versioned_value_sets/0.10.1/tuva_chronic_conditions_hierarchy.csv'
FILE_FORMAT = (TYPE = CSV, COMPRESSION = 'GZIP', NULL_IF = ('\\N'), FIELD_OPTIONALLY_ENCLOSED_BY = '"');



CREATE SCHEMA IF NOT EXISTS chronic_conditions;
CREATE OR REPLACE TABLE chronic_conditions._VALUE_SET_CMS_CHRONIC_CONDITIONS_HIERARCHY (
	CONDITION_ID varchar,
	CONDITION varchar,
	CONDITION_COLUMN_NAME varchar,
	CHRONIC_CONDITION_TYPE varchar,
	CONDITION_CATEGORY varchar,
	ADDITIONAL_LOGIC varchar,
	CLAIMS_QUALIFICATION varchar(1024),
	INCLUSION_TYPE varchar,
	CODE_SYSTEM varchar,
	CODE varchar
);
COPY INTO chronic_conditions._VALUE_SET_CMS_CHRONIC_CONDITIONS_HIERARCHY
FROM 's3://tuva-public-resources/versioned_value_sets/0.10.1/cms_chronic_conditions_hierarchy.csv'
FILE_FORMAT = (TYPE = CSV, COMPRESSION = 'GZIP', NULL_IF = ('\\N'), FIELD_OPTIONALLY_ENCLOSED_BY = '"');



CREATE SCHEMA IF NOT EXISTS reference_data;
CREATE OR REPLACE TABLE reference_data.ANSI_FIPS_STATE (
	ANSI_FIPS_STATE_CODE varchar,
	ANSI_FIPS_STATE_ABBREVIATION varchar,
	ANSI_FIPS_STATE_NAME varchar
);
COPY INTO reference_data.ANSI_FIPS_STATE
FROM 's3://tuva-public-resources/versioned_terminology/0.10.1/ansi_fips_state.csv'
FILE_FORMAT = (TYPE = CSV, COMPRESSION = 'GZIP', NULL_IF = ('\\N'), FIELD_OPTIONALLY_ENCLOSED_BY = '"');



CREATE SCHEMA IF NOT EXISTS reference_data;
CREATE OR REPLACE TABLE reference_data.CALENDAR (
	FULL_DATE date,
	YEAR integer,
	MONTH integer,
	DAY integer,
	MONTH_NAME varchar,
	DAY_OF_WEEK_NUMBER integer,
	DAY_OF_WEEK_NAME varchar,
	WEEK_OF_YEAR integer,
	DAY_OF_YEAR integer,
	YEAR_MONTH varchar,
	FIRST_DAY_OF_MONTH date,
	LAST_DAY_OF_MONTH date,
	YEAR_MONTH_INT integer
);
COPY INTO reference_data.CALENDAR
FROM 's3://tuva-public-resources/versioned_terminology/0.10.1/calendar.csv'
FILE_FORMAT = (TYPE = CSV, COMPRESSION = 'GZIP', NULL_IF = ('\\N'), FIELD_OPTIONALLY_ENCLOSED_BY = '"');



CREATE SCHEMA IF NOT EXISTS reference_data;
CREATE OR REPLACE TABLE reference_data.CODE_TYPE (
	CODE_TYPE varchar
);
COPY INTO reference_data.CODE_TYPE
FROM 's3://tuva-public-resources/versioned_terminology/0.10.1/code_type.csv'
FILE_FORMAT = (TYPE = CSV, COMPRESSION = 'GZIP', NULL_IF = ('\\N'), FIELD_OPTIONALLY_ENCLOSED_BY = '"');



CREATE SCHEMA IF NOT EXISTS reference_data;
CREATE OR REPLACE TABLE reference_data.FIPS_COUNTY (
	FIPS_CODE varchar,
	COUNTY varchar,
	STATE varchar
);
COPY INTO reference_data.FIPS_COUNTY
FROM 's3://tuva-public-resources/versioned_terminology/0.10.1/fips_county.csv'
FILE_FORMAT = (TYPE = CSV, COMPRESSION = 'GZIP', NULL_IF = ('\\N'), FIELD_OPTIONALLY_ENCLOSED_BY = '"');



CREATE SCHEMA IF NOT EXISTS reference_data;
CREATE OR REPLACE TABLE reference_data.SSA_FIPS_STATE (
	SSA_FIPS_STATE_CODE varchar,
	SSA_FIPS_STATE_NAME varchar
);
COPY INTO reference_data.SSA_FIPS_STATE
FROM 's3://tuva-public-resources/versioned_terminology/0.10.1/ssa_fips_state.csv'
FILE_FORMAT = (TYPE = CSV, COMPRESSION = 'GZIP', NULL_IF = ('\\N'), FIELD_OPTIONALLY_ENCLOSED_BY = '"');



