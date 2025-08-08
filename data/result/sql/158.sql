with sales_data as (
    select
        store,
        isholiday,
        cast(weekly_sales as double) as weekly_sales
    from
        ant_icube_dev.walmart_sales
)

select
    store as `store`,
    isholiday as `isholiday`,
    sum(weekly_sales) as `周销售额总和`
from
    sales_data
group by
    store, isholiday;