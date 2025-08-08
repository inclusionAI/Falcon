with sales_with_price as (
    select
        s.datetime,
        s.day_of_week,
        cast(s.amount as bigint) as amount,
        cast(p.price as bigint) as price,
        (cast(s.amount as bigint) * cast(p.price as bigint)) as sales_amount,
        to_date(
        CONCAT(
        -- 年（保持不变）
        regexp_extract(s.datetime, '^(\\d{4})/', 1), '/',
        -- 月（补零至2位）
        lpad(regexp_extract(s.datetime, '^\\d{4}/(\\d{1,2})/', 1), 2, '0'), '/',
        -- 日（补零至2位）
        lpad(regexp_extract(s.datetime, '^\\d{4}/\\d{1,2}/(\\d{1,2})', 1), 2, '0'),
        -- 时间部分（直接保留原样）
        regexp_extract(s.datetime, '( \\d{1,2}:\\d{2})$', 1)), 'yyyy/MM/dd hh:mm') as sale_date
    from
        ant_icube_dev.bakery_sales_sale s
    join
        ant_icube_dev.bakery_sales_price p
    on
        s.product_name = p.name
    where
        s.product_name = 'tiramisu croissant'
),
weekly_avg as (
    select
        year(sale_date) as year,
        weekofyear(sale_date) as week,
        avg(sales_amount) as avg_weekly_sales
    from
        sales_with_price
    group by
        year(sale_date),
        weekofyear(sale_date)
),
sunday_sales as (
    select
        swp.*,
        wa.avg_weekly_sales
    from
        sales_with_price swp
    join
        weekly_avg wa
    on
        year(swp.sale_date) = wa.year
        and weekofyear(swp.sale_date) = wa.week
    where
        swp.day_of_week = 'Sun'
)
select
    datetime as `datetime`,
    day_of_week as `day_of_week`,
    sales_amount as `sales_amount`,
    avg_weekly_sales as `avg_weekly_sales`
from
    sunday_sales
where
    sales_amount > 1.5 * avg_weekly_sales;