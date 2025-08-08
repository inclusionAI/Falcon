with payment_orders as (
    select
        p.order_id,
        p.payment_method,
        cast(p.amount as double) as amount,
        o.order_date
    from
        ant_icube_dev.online_shop_payment p
    join
        ant_icube_dev.online_shop_orders o
    on
        p.order_id = o.order_id
),
payment_aggregation as (
    select
        order_id,
        payment_method,
        sum(amount) as total_amount,
        max(order_date) as order_date
    from
        payment_orders
    group by
        order_id, payment_method
)
select
    order_id as `order_id`,
    payment_method as `payment_method`,
    total_amount as `amount`,
    order_date as `order_date`,
    row_number() over (
        partition by order_id
        order by total_amount desc
    ) as `payment_rank`
from
    payment_aggregation;