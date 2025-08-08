with price_diff as (
    select
        data.date,
        data.index,
        data.high,
        data.low,
        info.exchange,
        (cast(data.high as double) - cast(data.low as double)) as price_diff
    from
        ant_icube_dev.stock_exchange_index_data data
    join
        ant_icube_dev.stock_exchange_index_info info
    on
        data.index = info.index
),
ranked_data as (
    select
        *,
        row_number() over (partition by exchange order by price_diff desc) as rn
    from
        price_diff
)
select
    date as `date`,
    index as `index`,
    high as `high`,
    low as `low`,
    exchange as `exchange`,
    price_diff as `price_diff`
from
    ranked_data
where
    rn = 1