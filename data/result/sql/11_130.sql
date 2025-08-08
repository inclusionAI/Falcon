with product_sales as (
    select 
        s.product_name,
        cast(s.amount as bigint) * cast(p.price as bigint) as sales
    from 
        ant_icube_dev.bakery_sales_sale s
    join 
        ant_icube_dev.bakery_sales_price p
    on 
        s.product_name = p.name
)

select 
    product_name as `product_name`,
    sum(sales) as `total_sales`
from 
    product_sales 
group by 
    product_name
having 
    sum(sales) > 1000000;