with filtered_payments as (
    select 
        order_id 
    from 
        ant_icube_dev.ecommerce_order_payments 
    where 
        cast(trim(payment_installments) as int) >= 2
    group by 
        order_id
),
filtered_orders as (
    select 
        o.order_id,
        c.customer_city
    from 
        ant_icube_dev.ecommerce_order_orders o 
    join 
        ant_icube_dev.ecommerce_order_customers c 
        on o.customer_id = c.customer_id
    join 
        filtered_payments fp 
        on o.order_id = fp.order_id
),
order_volumes as (
    select 
        i.order_id,
        sum(
            (cast(trim(p.product_length_cm) as double) 
            * cast(trim(p.product_width_cm) as double) 
            * cast(trim(p.product_height_cm) as double)) 
            / 6000
        ) as total_volume_weight
    from 
        ant_icube_dev.ecommerce_order_order_items i 
    join 
        ant_icube_dev.ecommerce_order_products p 
        on i.product_id = p.product_id
    join 
        filtered_orders fo 
        on i.order_id = fo.order_id
    group by 
        i.order_id
)
select 
    fo.customer_city as `customer_city`,
    avg(ov.total_volume_weight) as `avg_volume_weight`
from 
    filtered_orders fo 
join 
    order_volumes ov 
    on fo.order_id = ov.order_id
group by 
    fo.customer_city;