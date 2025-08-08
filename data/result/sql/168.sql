WITH sales_detail AS (
    SELECT
        p.product_category,
        CAST(TRIM(s.units) AS INT) * CAST(REPLACE(TRIM(p.product_price), '$', '') AS DECIMAL) AS sale_amount
    FROM
        ant_icube_dev.mexico_toy_sales s
    INNER JOIN
        ant_icube_dev.mexico_toy_products p
    ON
        s.product_id = p.product_id
),
category_sales AS (
    SELECT
        product_category,
        SUM(sale_amount) AS category_total
    FROM
        sales_detail
    GROUP BY
        product_category
),
total_sales AS (
    SELECT
        SUM(category_total) AS grand_total
    FROM
        category_sales
)
SELECT
    cs.product_category AS `product_category`,
    (cs.category_total * 100.0 / (SELECT grand_total FROM total_sales)) AS `sales_percentage`
FROM
    category_sales cs
WHERE
    cs.category_total > 50;  -- 将阈值从20000降低到50