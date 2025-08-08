with tourism_top10 as (
    select
        country,
        receipts_in_billions,
        receipts_per_tourist
    from
        ant_icube_dev.world_economic_tourism
    order by
        cast(receipts_in_billions as double) desc
    limit 10
),
filtered_countries as (
    select
        t.country
    from
        tourism_top10 t
    join
        ant_icube_dev.world_economic_cost_of_living c
    on
        t.country = c.country
    where
        cast(c.purchasing_power_index as double) > 50
        and cast(t.receipts_per_tourist as double) > 1000
)

select
    count(*) as `国家数量`
from
    filtered_countries;