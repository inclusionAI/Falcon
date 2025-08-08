with tourism_filtered as (
    select
        country,
        cast(percentage_of_gdp as double) as percentage_of_gdp,
        cast(receipts_in_billions as double) as receipts_in_billions
    from
        ant_icube_dev.world_economic_tourism
    where
        cast(percentage_of_gdp as double) > 1.0
)

select
    country as `country`
from
    tourism_filtered
order by
    receipts_in_billions desc
limit 1;