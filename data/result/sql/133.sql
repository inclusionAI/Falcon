WITH sales_data AS 
(
    SELECT  s.product_name
            ,s.day_of_week
            ,CAST(s.amount AS BIGINT) AS amount
    FROM    ant_icube_dev.bakery_sales_sale s
) -- 按产品分组统计周末和工作日销量差异
SELECT  product_name AS `产品名称`
        ,SUM(CASE    WHEN day_of_week IN ('Sat','Sun') THEN amount ELSE 0 END) AS `周末销售数量`
        ,SUM(CASE    WHEN day_of_week NOT IN ('Sat','Sun') THEN amount ELSE 0 END) AS `工作日销售数量`
        ,(SUM(CASE    WHEN day_of_week IN ('Sat','Sun') THEN amount ELSE 0 END) - SUM(CASE    WHEN day_of_week NOT IN ('Sat','Sun') THEN amount ELSE 0 END)) AS `销售数量差异`
FROM    ant_icube_dev.bakery_sales_sale
GROUP BY product_name
;