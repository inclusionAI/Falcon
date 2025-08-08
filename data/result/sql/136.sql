WITH sale_data AS (
    SELECT 
        product_name,
        CAST(amount AS BIGINT) AS amount
    FROM 
        ant_icube_dev.bakery_sales_sale
),
price_data AS (
    SELECT 
        name,
        CAST(price AS BIGINT) AS price
    FROM 
        ant_icube_dev.bakery_sales_price
),
product_sales AS (
    SELECT 
        s.product_name,
        s.amount * p.price AS sales_amount
    FROM 
        sale_data s
    JOIN 
        price_data p 
    ON 
        s.product_name = p.name
),
total_sales AS (
    SELECT 
        product_name,
        SUM(sales_amount) AS total_sales
    FROM 
        product_sales
    GROUP BY 
        product_name
)
SELECT 
    product_name AS `商品名称`,
    total_sales AS `销售额`
FROM 
    total_sales
ORDER BY 
    total_sales DESC
LIMIT 3;