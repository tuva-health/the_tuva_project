{{ config(
     enabled = var('claims_enabled',var('clinical_enabled',var('tuva_marts_enabled',False))) | as_bool
   )
}}

select * from {{ref('core__int_condition_normalized')}}