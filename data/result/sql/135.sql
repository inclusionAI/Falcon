WITH weekend_sales AS (
    SELECT 
        product_name,
        CAST(amount AS BIGINT) AS amount
    FROM ant_icube_dev.bakery_sales_sale
    WHERE day_of_week IN ('Sun', 'Sat')
)
SELECT 
    product_name AS `product_name`,
    AVG(amount) AS `average_sales`
FROM weekend_sales
GROUP BY product_name
HAVING AVG(amount) > 1;