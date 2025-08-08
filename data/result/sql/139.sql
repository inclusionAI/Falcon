with 
weekend_sales as (
    select
        s.product_name,
        cast(s.amount as bigint) as amount
    from
        ant_icube_dev.bakery_sales_sale s
    inner join
        ant_icube_dev.bakery_sales_price p
    on
        s.product_name = p.name
    where
        s.day_of_week in ('Sat','Sun')
),
product_avg as (
    select
        product_name,
        avg(amount) as avg_amount
    from
        weekend_sales
    group by
        product_name
)
select
    product_name as `product_name`,
    avg_amount as `average_sales`
from
    product_avg
order by
    avg_amount desc
limit 5;