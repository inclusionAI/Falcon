WITH
-- 筛选周末的销售记录
weekend_sales AS (
    SELECT
        product_name,
        CAST(amount AS BIGINT) AS amount_num
    FROM
        ant_icube_dev.bakery_sales_sale
    WHERE
        day_of_week IN ('Sat', 'Sun')
),
-- 计算产品总销量
product_summary AS (
    SELECT
        product_name,
        SUM(amount_num) AS total_quantity
    FROM
        weekend_sales
    GROUP BY
        product_name
)
-- 筛选销量超过1000的产品
SELECT
    product_name AS `product_name`
FROM
    product_summary
WHERE
    total_quantity > 1000;