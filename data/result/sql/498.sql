with filtered_orders as (
    select 
        customer_id,
        order_date
    from 
        ant_icube_dev.online_shop_orders 
    where 
        substr(order_date, 1, 4) = '2024'
),
date_sequence as (
    select 
        customer_id,
        to_date(order_date) as order_date,
        date_sub(
            to_date(order_date), 
            row_number() over (partition by customer_id order by to_date(order_date))
        ) as date_group
    from 
        filtered_orders
    group by 
        customer_id, order_date
),
consecutive_counts as (
    select 
        customer_id,
        count(*) as consecutive_days
    from 
        date_sequence
    group by 
        customer_id, date_group
    having 
        count(*) >= 2
)
select distinct
    c.address as `address`,
    c.phone_number as `phone_number`,
    c.email as `email`
from 
    ant_icube_dev.online_shop_customers c
join 
    consecutive_counts cc on c.customer_id = cc.customer_id;