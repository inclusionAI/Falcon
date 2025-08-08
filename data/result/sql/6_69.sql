with filtered_orders as (
    select
        state,
        cast(profit as double) as profit
    from
        ant_icube_dev.di_sales_dataset
    where
        paymentmode = 'Credit Card'
        )
select
    state as `state`,
    avg(profit) as `平均利润`
    from
    filtered_orders
    group by
    state
    having
    sum(profit) > 5000;