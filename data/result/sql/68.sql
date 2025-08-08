with monthly_sales as (
    select
        city,
        substr(order_date, 1, 7) as `year_month`,
        sum(cast(amount as bigint)) as `total_sales`
    from
        ant_icube_dev.di_sales_dataset
    group by
        city, substr(order_date, 1, 7)
        ),
ranked_sales as (
    select
        city,
        `year_month`,
        `total_sales`,
        row_number() over (partition by city order by `total_sales` desc) as `rank`
    from
        monthly_sales
        )
select
    city as `city`,
    `year_month` as `year_month`,
    `total_sales` as `total_sales`
    from
    ranked_sales
    where
    `rank` <= 3;