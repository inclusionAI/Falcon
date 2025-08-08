with corruption_data as (
    select 
        country,
        corruption_index
    from 
        ant_icube_dev.world_economic_corruption
    where 
        cast(corruption_index as decimal) < 50
),
unemployment_data as (
    select 
        country,
        unemployment_rate
    from 
        ant_icube_dev.world_economic_unemployment
    where 
        cast(unemployment_rate as decimal) > 8
)
select
    c.country as `country`
from
    corruption_data c
join
    unemployment_data u
on
    c.country = u.country;