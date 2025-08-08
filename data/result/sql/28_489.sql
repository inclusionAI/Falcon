with wireless_mouse_id AS (
    select product_id
    from ant_icube_dev.online_shop_products
    where product_name = 'Wireless Mouse'
)
select
    oi.order_id,
    cast(oi.price_at_purchase as double) as price,
    p.supplier_id,
    row_number() over (order by price desc) as price_rank
from
    ant_icube_dev.online_shop_order_items oi
    join ant_icube_dev.online_shop_products p 
    on oi.product_id = p.product_id
where 
    oi.product_id in (select product_id from wireless_mouse_id)