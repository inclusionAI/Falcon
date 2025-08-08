with country_data as (

select

country

from

ant_icube_dev.ufc_country_data

where

unemployment_rate_2023 != 'NA'

and cast(unemployment_rate_2023 as double) < 10.0

),

fighter_arm_reach as (

select

country,

avg(cast(arm_reach_inch as double)) as avg_reach

from

ant_icube_dev.ufc_fighters_stats

where

arm_reach_inch != 'NA'

group by

country

having

avg(cast(arm_reach_inch as double)) > 70

)

select

c.country as `country`

from

country_data c

join fighter_arm_reach f on c.country = f.country;