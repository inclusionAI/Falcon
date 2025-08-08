WITH filtered_sales AS 
(
    SELECT  product_name
            ,amount
            ,day_of_week
    FROM    ant_icube_dev.bakery_sales_sale
    WHERE   day_of_week IN ('Sat','Sun')
)
,joined_data AS 
(
    SELECT  s.product_name
            ,s.amount
            ,p.price
    FROM    filtered_sales s
    JOIN    ant_icube_dev.bakery_sales_price p
    ON      s.product_name = p.name
)
,sales_calculation AS 
(
    SELECT  product_name
            ,CAST(amount AS DOUBLE) AS amount_num
            ,CAST(price AS DOUBLE) AS price_num
    FROM    joined_data
)
,total_sales AS 
(
    SELECT  product_name
            ,amount_num * price_num AS sale_total
    FROM    sales_calculation
)
,avg_sales AS 
(
    SELECT  product_name
            ,AVG(sale_total) AS avg_sale
    FROM    total_sales
    GROUP BY product_name
)
SELECT  product_name
        ,avg_sale
FROM    avg_sales
ORDER BY avg_sale DESC
LIMIT   1
;