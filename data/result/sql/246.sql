with 
order_customer as (
    select 
        o.order_id,
        c.customer_state
    from 
        ant_icube_dev.ecommerce_order_orders o
        join ant_icube_dev.ecommerce_order_customers c 
        on o.customer_id = c.customer_id
),
order_payment as (
    select 
        order_id,
        payment_value
    from 
        ant_icube_dev.ecommerce_order_payments
)
select 
    oc.customer_state as `customer_state`,
    sum(cast(op.payment_value as double)) as `total_payment`
from 
    order_customer oc
    join order_payment op 
    on oc.order_id = op.order_id
group by 
    oc.customer_state
order by 
    total_payment desc
limit 3;