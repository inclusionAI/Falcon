WITH dairy_products AS (

SELECT product_id

FROM ant_icube_dev.blinkit_products

WHERE category = 'Dairy & Breakfast'

),

order_products AS (

SELECT

oi.product_id,

oi.order_id

FROM ant_icube_dev.blinkit_order_items oi

JOIN dairy_products dp ON oi.product_id = dp.product_id

),

delivery_status_data AS (

SELECT

op.product_id,

CASE WHEN dp.delivery_status = 'On Time' THEN 1 ELSE 0 END AS is_ontime

FROM order_products op

JOIN ant_icube_dev.blinkit_orders o ON op.order_id = o.order_id  -- 确保 op.order_id 正确引用

JOIN ant_icube_dev.blinkit_delivery_performance dp ON op.order_id = dp.order_id

),

delivery_stats AS (

SELECT

product_id,

SUM(is_ontime) * 1.0 / COUNT(*) AS ontime_rate

FROM delivery_status_data

GROUP BY product_id

)

SELECT product_id

FROM delivery_stats

WHERE ontime_rate < 0.9;