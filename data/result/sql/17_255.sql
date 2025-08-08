with order_payment_totals as (
    select 
        order_id,
        sum(cast(payment_value as double)) as total_payment
    from 
        ant_icube_dev.ecommerce_order_payments
    group by 
        order_id
),
customer_orders as (
    select 
        o.order_id,
        o.customer_id,
        c.customer_city
    from 
        ant_icube_dev.ecommerce_order_orders o
    inner join 
        ant_icube_dev.ecommerce_order_customers c
    on 
        o.customer_id = c.customer_id
),
customer_order_payments as (
    select 
        co.customer_id,
        co.customer_city,
        opt.total_payment
    from 
        customer_orders co
    inner join 
        order_payment_totals opt
    on 
        co.order_id = opt.order_id
),
city_avg_payment as (
    select 
        customer_city,
        avg(total_payment) as avg_city_payment
    from 
        customer_order_payments
    group by 
        customer_city
),
customer_total_stats as (
    select 
        cop.customer_id,
        cop.customer_city,
        sum(cop.total_payment) as total_payment,
        count(distinct co.order_id) as order_count,
        cap.avg_city_payment
    from 
        customer_order_payments cop
    inner join 
        city_avg_payment cap
    on 
        cop.customer_city = cap.customer_city
    inner join 
        ant_icube_dev.ecommerce_order_orders co
    on 
        cop.customer_id = co.customer_id
    group by 
        cop.customer_id,
        cop.customer_city,
        cap.avg_city_payment
)
select 
    customer_id as `customer_id`,
    customer_city as `customer_city`,
    order_count as `order_count`
from 
    customer_total_stats
where 
    total_payment > avg_city_payment;