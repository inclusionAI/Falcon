with cost_filter as (
    select 
        country
    from 
        ant_icube_dev.world_economic_cost_of_living 
    where 
        cast(monthly_income as double) > 3000
),
tourism_filter as (
    select 
        country 
    from 
        ant_icube_dev.world_economic_tourism 
    where 
        cast(tourists_in_millions as double) > 10
)
select 
    c.country as `country`
from 
    cost_filter c
inner join 
    tourism_filter t 
on 
    c.country = t.country;