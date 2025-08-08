with cost_filter as (
    select
        country
    from
        ant_icube_dev.world_economic_cost_of_living
    where
        cast(purchasing_power_index as double) > 65
),
tourism_filter as (
    select
        country
    from
        ant_icube_dev.world_economic_tourism
    where
        cast(tourists_in_millions as double) > 5
)
select
    cost_filter.country as `country`
from
    cost_filter
join
    tourism_filter
on
    cost_filter.country = tourism_filter.country;