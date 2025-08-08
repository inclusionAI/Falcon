with global_avg_unemployment as (
    select
        avg(cast(unemployment_rate as double)) as global_avg
    from
        ant_icube_dev.world_economic_unemployment
),
global_avg_cost_index as (
    select
        avg(cast(cost_index as double)) as global_avg
    from
        ant_icube_dev.world_economic_cost_of_living
),
joined_countries as (
    select
        u.country,
        cast(u.unemployment_rate as double) as unemployment_rate,
        cast(c.cost_index as double) as cost_index
    from
        ant_icube_dev.world_economic_unemployment u
        join ant_icube_dev.world_economic_richest_countries r on u.country = r.country
        join ant_icube_dev.world_economic_tourism t on r.country = t.country
        join ant_icube_dev.world_economic_cost_of_living c on t.country = c.country
)
select
    j.country as `country`
from
    joined_countries j
where
    j.unemployment_rate > (select global_avg from global_avg_unemployment)
    and j.cost_index > (select global_avg from global_avg_cost_index);