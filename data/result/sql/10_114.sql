with daily_volume as (
    select 
        index,
        avg(cast(volume as double)) as avg_volume
    from 
        ant_icube_dev.stock_exchange_index_data
    group by 
        index
)
select
    dv.index as `index`,
    dv.avg_volume as `日均交易量`,
    info.currency as `货币`
from 
    daily_volume dv
join 
    ant_icube_dev.stock_exchange_index_info info
on 
    dv.index = info.index;