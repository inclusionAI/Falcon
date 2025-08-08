with credit_payments as (
    select 
        order_id,
        payment_value
    from 
        ant_icube_dev.ecommerce_order_payments
    where 
        payment_type = 'credit_card'
),

order_customer_city as (
    select 
        o.order_id,
        c.customer_city
    from 
        ant_icube_dev.ecommerce_order_orders o
    inner join 
        ant_icube_dev.ecommerce_order_customers c
    on 
        o.customer_id = c.customer_id
),

payment_city_agg as (
    select 
        occ.customer_city,
        sum(cast(cp.payment_value as double)) as total_payment
    from 
        credit_payments cp
    inner join 
        order_customer_city occ
    on 
        cp.order_id = occ.order_id
    group by 
        occ.customer_city
)

select 
    customer_city as `customer_city`,
    total_payment
from 
    payment_city_agg
order by 
    total_payment desc
limit 3;