WITH sales_with_price AS (
    SELECT 
        CAST(s.amount AS BIGINT) AS amount,
        CAST(p.price AS BIGINT) AS price,
CONCAT(
        -- 年（保持不变）
        regexp_extract(s.datetime, '^(\\d{4})/', 1), '/',
        -- 月（补零至2位）
        lpad(regexp_extract(s.datetime, '^\\d{4}/(\\d{1,2})/', 1), 2, '0'), '/',
        -- 日（补零至2位）
        lpad(regexp_extract(s.datetime, '^\\d{4}/\\d{1,2}/(\\d{1,2})', 1), 2, '0'),
        -- 时间部分（直接保留原样）
        regexp_extract(s.datetime, '( \\d{1,2}:\\d{2})$', 1)) as datetime
    FROM 
        ant_icube_dev.bakery_sales_sale s
    JOIN 
        ant_icube_dev.bakery_sales_price p
    ON 
        s.product_name = p.name
),
monthly_sales AS (
    SELECT 
        SUBSTR(datetime, 1, 7) AS month,
        SUM(amount * price) AS monthly_sales
    FROM 
        sales_with_price
    WHERE 
        SUBSTR(datetime, 1, 4) = '2019'
    GROUP BY 
        SUBSTR(datetime, 1, 7)
),
growth AS (
    SELECT 
        month,
        monthly_sales,
        LAG(monthly_sales, 1) OVER (ORDER BY month) AS prev_month_sales
    FROM 
        monthly_sales
)
SELECT 
    month AS `月份`,
    (monthly_sales - prev_month_sales) / prev_month_sales * 100 AS `环比增长`
FROM 
    growth
WHERE 
    prev_month_sales IS NOT NULL
ORDER BY 
    month;