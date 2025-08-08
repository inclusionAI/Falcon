WITH product_volume AS (
    SELECT 
        product_id,
        product_category_name,
        CAST(product_length_cm AS DOUBLE) * CAST(product_width_cm AS DOUBLE) * CAST(product_height_cm AS DOUBLE) AS volume
    FROM 
        ant_icube_dev.ecommerce_order_products
),
ranked_products AS (
    SELECT 
        product_id,
        product_category_name,
        ROW_NUMBER() OVER (PARTITION BY product_category_name ORDER BY volume DESC) AS rn
    FROM 
        product_volume
),
top_products AS (
    SELECT 
        product_id,
        product_category_name
    FROM 
        ranked_products
    WHERE 
        rn <= 3
)
SELECT 
    tp.product_category_name AS `product_category_name`,
    AVG(CAST(oi.shipping_charges AS DOUBLE)) AS `avg_shipping_charges`
FROM 
    top_products tp
JOIN 
    ant_icube_dev.ecommerce_order_order_items oi 
    ON tp.product_id = oi.product_id
GROUP BY 
    tp.product_category_name;