with order_total_shipping as (
    select
        order_id,
        sum(cast(price as double)) as total_price
    from
        ant_icube_dev.ecommerce_order_order_items
    group by
        order_id
),
item_shipping_ratio as (
    select
        oi.order_id,
        oi.product_id,
        (cast(oi.shipping_charges as double) / ots.total_price) as shipping_ratio
    from
        ant_icube_dev.ecommerce_order_order_items oi
        inner join order_total_shipping ots 
            on oi.order_id = ots.order_id
    where
        ots.total_price > 0
)
select
    sr.order_id as `order_id`,
    sr.product_id as `product_id`,
    p.product_category_name as `product_category_name`
from
    item_shipping_ratio sr
    inner join ant_icube_dev.ecommerce_order_products p
        on sr.product_id = p.product_id
where
    sr.shipping_ratio > 0.15;