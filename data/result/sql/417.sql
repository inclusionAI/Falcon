WITH delivery_performance AS (
    SELECT 
        order_id,
        CAST(delivery_time_minutes AS DOUBLE) AS delivery_time_minutes
    FROM 
        ant_icube_dev.blinkit_delivery_performance
),
max_early_value AS (
    SELECT 
        MIN(delivery_time_minutes) AS min_delivery_time
    FROM 
        delivery_performance
),
target_orders AS (
    SELECT 
        dp.order_id
    FROM 
        delivery_performance dp
        JOIN max_early_value mev ON dp.delivery_time_minutes = mev.min_delivery_time
),
order_products AS (
    SELECT 
        oi.order_id,
        oi.product_id
    FROM 
        ant_icube_dev.blinkit_order_items oi
        JOIN target_orders to1 ON oi.order_id = to1.order_id
),
product_info AS (
    SELECT 
        op.order_id,
        p.category
    FROM 
        order_products op
        JOIN ant_icube_dev.blinkit_products p ON op.product_id = p.product_id
)
SELECT DISTINCT 
    order_id AS `order_id`,
    category AS `商品品类`
FROM 
    product_info;