with filtered_orders as (

select

o.order_id,

cast(o.order_total as double) as order_total,

c.customer_segment

from

ant_icube_dev.blinkit_orders o

inner join

ant_icube_dev.blinkit_customers c

on o.customer_id = c.customer_id

where

to_date(substr(o.order_date, 1, 10)) between '2024-01-01' and '2024-06-30'

)

select

customer_segment as `客户群体`,

sum(order_total) / count(order_id) as `客单价`

from

filtered_orders

group by

customer_segment

order by

`客单价` desc

limit 3;