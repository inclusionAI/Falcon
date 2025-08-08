with global_averages as (

select

avg(cast(total_population as double)) as global_avg_pop,

avg(cast(gdp_2023_billion_usd as double)) as global_avg_gdp

from

ant_icube_dev.ufc_country_data

)



select

country as `国家`

from

ant_icube_dev.ufc_country_data

where

cast(total_population as double) > (select global_avg_pop from global_averages)

and cast(gdp_2023_billion_usd as double) > (select global_avg_gdp from global_averages);