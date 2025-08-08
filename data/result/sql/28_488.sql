with latest_orders as (
select
customer_id,
order_id,
order_date,
row_number() over (partition by customer_id order by order_date desc) as rn
from
ant_icube_dev.online_shop_orders
)
select
concat(c.first_name, ' ', c.last_name) as `客户全名`,
p.transaction_status as `交易状态`
from
latest_orders lo
join
ant_icube_dev.online_shop_customers c
on lo.customer_id = c.customer_id
join
ant_icube_dev.online_shop_payment p
on lo.order_id = p.order_id
where
lo.rn = 1;