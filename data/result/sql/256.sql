WITH 
avg_shipping_charge AS (
    SELECT 
        AVG(CAST(shipping_charges AS DOUBLE)) AS avg_shipping
    FROM 
        ant_icube_dev.ecommerce_order_order_items
),
high_shipping_orders AS (
    SELECT 
        order_items.product_id,
        CAST(order_items.price AS DOUBLE) AS price_val
    FROM 
        ant_icube_dev.ecommerce_order_order_items order_items
    WHERE 
        CAST(order_items.shipping_charges AS DOUBLE) > (SELECT avg_shipping FROM avg_shipping_charge)
),
product_category_data AS (
    SELECT 
        products.product_id,
        products.product_category_name
    FROM 
        ant_icube_dev.ecommerce_order_products products
),
category_sales AS (
    SELECT 
        pcd.product_category_name AS `产品类别`,
        SUM(hso.price_val) AS total_sales,
        COUNT(*) AS sales_count
    FROM 
        high_shipping_orders hso
    INNER JOIN 
        product_category_data pcd 
    ON 
        hso.product_id = pcd.product_id
    GROUP BY 
        pcd.product_category_name
)
SELECT 
    `产品类别`,
    total_sales AS `总销售额`,
    RANK() OVER (ORDER BY total_sales DESC) AS `销售排名`
FROM 
    category_sales
ORDER BY 
    `销售排名` ASC;