with customer_orders as (
select
customer_id,
sum(cast(order_total as double)) as total_order_amount
from
ant_icube_dev.blinkit_orders
group by
customer_id
),
segment_avg as (
select
c.customer_segment,
avg(co.total_order_amount) as avg_order_amount
from
ant_icube_dev.blinkit_customers c
inner join
customer_orders co
on c.customer_id = co.customer_id
group by
c.customer_segment
)
select
c.customer_id as `客户id`
from
ant_icube_dev.blinkit_customers c
inner join
customer_orders co
on c.customer_id = co.customer_id
inner join
segment_avg sa
on c.customer_segment = sa.customer_segment
where
co.total_order_amount > sa.avg_order_amount;