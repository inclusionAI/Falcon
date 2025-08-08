WITH max_sale_date AS (
    SELECT MAX(TO_DATE(date, 'yyyy-mm-dd')) AS max_date
    FROM ant_icube_dev.mexico_toy_sales
),
valid_stores AS (
    SELECT store_id
    FROM ant_icube_dev.mexico_toy_stores
    WHERE store_city = 'Mexicali'
    AND DATEDIFF((SELECT max_date FROM max_sale_date), TO_DATE(store_open_date, 'yyyy-mm-dd')) >= 3650
),
sales_detail AS (
    SELECT 
        s.product_id,
        CAST(REGEXP_REPLACE(p.product_price, '[^0-9.]', '') AS DOUBLE) * CAST(s.units AS INT) AS sale_amount
    FROM ant_icube_dev.mexico_toy_sales s
    JOIN valid_stores v ON s.store_id = v.store_id
    JOIN ant_icube_dev.mexico_toy_products p ON s.product_id = p.product_id
),
product_ranking AS (
    SELECT 
        product_id,
        SUM(sale_amount) AS total_sales,
        ROW_NUMBER() OVER (ORDER BY SUM(sale_amount) DESC) AS rank
    FROM sales_detail
    GROUP BY product_id
)
SELECT 
    p.product_name AS `product_name`
FROM product_ranking r
JOIN ant_icube_dev.mexico_toy_products p ON r.product_id = p.product_id
WHERE r.rank = 1;