
select SOURCE_CODE_TYPE, SOURCE_CODE, SOURCE_DESCRIPTION,
       count(*) as item_count,
       listagg(distinct DATA_SOURCE, ', ') within group ( order by DATA_SOURCE ) as data_sources
from {{ref('core__procedure')}}
where NORMALIZED_CODE is null and NORMALIZED_DESCRIPTION is null
    and not ( SOURCE_CODE is null and SOURCE_DESCRIPTION is null)
group by SOURCE_CODE_TYPE, SOURCE_CODE, SOURCE_DESCRIPTION