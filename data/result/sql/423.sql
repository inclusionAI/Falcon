with product_sales as (
    select 
        oi.product_id,
        sum(cast(oi.quantity as bigint)) as total_quantity
    from 
        ant_icube_dev.blinkit_order_items oi
    group by 
        oi.product_id
),
category_avg as (
    select 
        p.category,
        avg(ps.total_quantity) as avg_quantity
    from 
        product_sales ps
    join 
        ant_icube_dev.blinkit_products p 
    on 
        ps.product_id = p.product_id
    group by 
        p.category
)
select 
    ps.product_id
from 
    product_sales ps
join 
    ant_icube_dev.blinkit_products p 
on 
    ps.product_id = p.product_id
join 
    category_avg ca 
on 
    p.category = ca.category
where 
    ps.total_quantity > ca.avg_quantity;