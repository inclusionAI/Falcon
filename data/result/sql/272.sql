with filtered_countries as (
    select
        t.country,
        t.receipts_per_tourist
    from
        ant_icube_dev.world_economic_tourism t
    where
        cast(t.receipts_in_billions as double) > 1.0
)
select
    country as `国家`,
    receipts_per_tourist as `游客人均消费`
from
    filtered_countries
order by
    cast(receipts_per_tourist as double) desc
limit 5;