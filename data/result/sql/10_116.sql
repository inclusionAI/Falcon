with data_prepared as (
    select
        index,
        substr(date, 1, 7) as year_month,
        cast(volume as bigint) as volume
    from ant_icube_dev.stock_exchange_index_data
)
select
    year_month,
    data_prepared.index as `index`,
    sum(volume) as `total_volume`
from data_prepared
join ant_icube_dev.stock_exchange_index_info 
    on data_prepared.index = ant_icube_dev.stock_exchange_index_info.index
group by
    year_month,
    data_prepared.index;