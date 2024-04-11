{{ config(
     enabled = (var('enable_normalize_engine', False) == True) and (
                 var('claims_enabled', var('clinical_enabled', var('tuva_marts_enabled', False)))
               ) | as_bool
   )
}}
select i.SOURCE_CODE_TYPE, i.SOURCE_CODE, i.SOURCE_DESCRIPTION,
       count(*) as item_count,
       listagg(distinct i.DATA_SOURCE, ', ') within group ( order by i.DATA_SOURCE ) as data_sources
from {{ref('core__medication')}} i
left join {{ ref('custom_mapped') }} custom_mapped
    on custom_mapped.domain = 'medication'
        and ( lower(i.source_code_type) = lower(custom_mapped.source_code_type)
            or ( i.source_code_type is null and custom_mapped.source_code_type is null)
            )
        and (i.source_code = custom_mapped.source_code
            or ( i.source_code is null and custom_mapped.source_code is null)
            )
        and (i.source_description = custom_mapped.source_description
            or ( i.source_description is null and custom_mapped.source_description is null)
            )
where i.NORMALIZED_CODE is null and i.NORMALIZED_DESCRIPTION is null
    and not ( i.SOURCE_CODE is null and i.SOURCE_DESCRIPTION is null)
    and custom_mapped.not_mapped is not null
group by i.SOURCE_CODE_TYPE, i.SOURCE_CODE, i.SOURCE_DESCRIPTION