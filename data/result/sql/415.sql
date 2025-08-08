with latest_orders as (
select
customer_id,
order_id,
order_date,
row_number() over (partition by customer_id order by order_date desc) as rn
from
ant_icube_dev.blinkit_orders
)
select
blinkit_customers.customer_id as `客户id`,
blinkit_delivery_performance.delivery_status as `交付状态`,
blinkit_products.product_name as `商品名称`
from
ant_icube_dev.blinkit_customers
join
latest_orders
on
blinkit_customers.customer_id = latest_orders.customer_id
and latest_orders.rn = 1
join
ant_icube_dev.blinkit_delivery_performance
on
latest_orders.order_id = blinkit_delivery_performance.order_id
join
ant_icube_dev.blinkit_order_items
on
latest_orders.order_id = blinkit_order_items.order_id
join
ant_icube_dev.blinkit_products
on
blinkit_order_items.product_id = blinkit_products.product_id;