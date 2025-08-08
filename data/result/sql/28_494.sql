with filtered_orders as (

select

o.customer_id,

cast(o.total_price as double) as total_price

from

ant_icube_dev.online_shop_orders o

inner join ant_icube_dev.online_shop_payment p

on o.order_id = p.order_id

where

o.order_date between '2024-03-01' and '2024-03-31'

and p.transaction_status = 'Completed'

)

select

customer_id as `customer_id`,

avg(total_price) / sum(total_price) as `avg_total_ratio`

from

filtered_orders

group by

customer_id;