with filtered_orders as (
    select
        order_date,
        amount
    from
        ant_icube_dev.di_sales_dataset
    where
        state = 'California'
        and category = 'Furniture'
        ),
monthly_sales as (
    select
        substr(order_date, 1, 7) as month_str,
        sum(cast(amount as double)) as total_sales
    from
        filtered_orders
    group by
        substr(order_date, 1, 7)
        )
select
    month_str as `月份`,
    sum(total_sales) over (
        order by month_str
        rows between unbounded preceding and current row
    ) as `累计销售额`
    from
    monthly_sales
order by
    month_str;