with state_avg_payment as (
    select
        c.customer_state,
        avg(cast(p.payment_value as double)) as avg_value
    from
        ant_icube_dev.ecommerce_order_payments p
        join ant_icube_dev.ecommerce_order_orders o on p.order_id = o.order_id
        join ant_icube_dev.ecommerce_order_customers c on o.customer_id = c.customer_id
    where
        p.payment_type = 'credit_card'
    group by
        c.customer_state
)
select
    o.order_id as `order_id`,
    o.order_purchase_timestamp as `order_purchase_timestamp`,
    c.customer_state as `customer_state`,
    p.payment_value as `payment_value`,
    p.payment_type as `payment_type`,
    c.customer_city as `customer_city`,
    c.customer_zip_code_prefix as `customer_zip_code_prefix`
from
    ant_icube_dev.ecommerce_order_payments p
    join ant_icube_dev.ecommerce_order_orders o on p.order_id = o.order_id
    join ant_icube_dev.ecommerce_order_customers c on o.customer_id = c.customer_id
    join state_avg_payment s on c.customer_state = s.customer_state
where
    p.payment_type = 'credit_card'
    and cast(p.payment_value as double) > s.avg_value;