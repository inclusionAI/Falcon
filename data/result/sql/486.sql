WITH electronic_products AS (
    SELECT product_id
    FROM ant_icube_dev.online_shop_products
    WHERE product_name = 'Gaming Keyboard'
),
filtered_order_items AS (
    SELECT 
        oi.order_id,
        oi.price_at_purchase,
        oi.quantity
    FROM ant_icube_dev.online_shop_order_items oi
    INNER JOIN electronic_products ep ON oi.product_id = ep.product_id
),
orders_with_customer AS (
    SELECT 
        o.customer_id,
        oi.price_at_purchase,
        oi.quantity
    FROM filtered_order_items oi
    INNER JOIN ant_icube_dev.online_shop_orders o ON oi.order_id = o.order_id
),
customer_spending AS (
    SELECT 
        customer_id,
        SUM(CAST(TRIM(price_at_purchase) AS DOUBLE) * CAST(TRIM(quantity) AS DOUBLE)) AS total_spent
    FROM orders_with_customer
    GROUP BY customer_id
),
total_spent_all AS (
    SELECT SUM(total_spent) AS grand_total
    FROM customer_spending
)
SELECT 
    cs.customer_id AS `customer_id`,
    cs.total_spent AS `total_spent`,
    (cs.total_spent / (SELECT SUM(total_spent) FROM customer_spending)) * 100 AS `percentage`
FROM customer_spending cs