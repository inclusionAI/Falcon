WITH large_products AS (
    SELECT 
        product_id 
    FROM 
        ant_icube_dev.ecommerce_order_products 
    WHERE 
        CAST(product_height_cm AS DECIMAL) * CAST(product_length_cm AS DECIMAL) * CAST(product_width_cm AS DECIMAL) > 10000
),
relevant_order_items AS (
    SELECT 
        order_id 
    FROM 
        ant_icube_dev.ecommerce_order_order_items 
    WHERE 
        product_id IN (SELECT product_id FROM large_products)
)
SELECT 
    p.order_id AS `order_id`,
    p.payment_type AS `payment_type`
FROM 
    ant_icube_dev.ecommerce_order_payments p
INNER JOIN 
    relevant_order_items r 
ON 
    p.order_id = r.order_id;