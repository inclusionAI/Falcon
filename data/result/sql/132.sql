WITH joined_data AS 
(
    SELECT  s.product_name
            ,CAST(s.amount AS BIGINT) AS amount
            ,CAST(s.total AS BIGINT) AS total
            ,CAST(p.price AS BIGINT) AS price
    FROM    ant_icube_dev.bakery_sales_sale s
    INNER JOIN ant_icube_dev.bakery_sales_price p
    ON      s.product_name = p.name
) -- 计算各产品的总销售额和总成本
,sales_summary AS 
(
    SELECT  product_name
            ,SUM(total) AS total_sales
            ,SUM(amount * price * 0.5) AS total_cost -- 成本按单价50%计算
    FROM    joined_data
    GROUP BY product_name
) -- 筛选百万级销售额商品并计算利润率
SELECT  product_name AS `产品名称`
        ,total_sales AS `总销售额`
        ,(total_sales - total_cost) / total_sales AS `利润率`
FROM    sales_summary
WHERE   total_sales > 1000000
;