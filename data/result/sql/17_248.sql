with filtered_payments as (
    select
        order_id,
        sum(cast(trim(payment_value) as double)) as total_payment
    from
        ant_icube_dev.ecommerce_order_payments
    where
        payment_type = 'credit_card'
        and cast(trim(payment_installments) as int) > 2
    group by
        order_id
)
select
    c.customer_state as `customer_state`,
    avg(fp.total_payment) as `average_payment`
from
    filtered_payments fp
join
    ant_icube_dev.ecommerce_order_orders o
on
    fp.order_id = o.order_id
join
    ant_icube_dev.ecommerce_order_customers c
on
    o.customer_id = c.customer_id
group by
    c.customer_state;