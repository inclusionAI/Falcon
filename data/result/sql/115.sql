with joined_data as (
    select
        data.date as date,
        data.high as high,
        data.low as low,
        info.region as region
    from
        ant_icube_dev.stock_exchange_index_data data
    join
        ant_icube_dev.stock_exchange_index_info info
    on
        data.index = info.index
),
daily_diff as (
    select
        region,
        date,
        (cast(high as double) - cast(low as double)) as diff
    from
        joined_data
),
max_diff as (
    select
        region,
        max(diff) as max_diff
    from
        daily_diff
    group by
        region
)
select
    m.region as `地区`,
    m.max_diff as `最大差值`,
    d.date as `交易日`
from
    max_diff m
join
    daily_diff d
on
    m.region = d.region
    and m.max_diff = d.diff;