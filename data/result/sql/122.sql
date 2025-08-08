with usd_indexes as (
    select index
    from ant_icube_dev.stock_exchange_index_info
    where currency = 'USD'
),
qualified_days as (
    select
        data.date
    from
        ant_icube_dev.stock_exchange_index_data data
    inner join
        usd_indexes info
    on
        data.index = info.index
    where
        to_date(data.date, 'yyyy-MM-dd') between to_date('2020-01-01', 'yyyy-MM-dd') and to_date('2020-03-31', 'yyyy-MM-dd')
        and cast(data.close as double) > cast(data.adj_close as double)
)
select
    count(date) as `天数`
from
    qualified_days;