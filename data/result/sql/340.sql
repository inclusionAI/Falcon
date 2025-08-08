WITH customer_counts AS (
    SELECT
        city,
        COUNT(DISTINCT customerid) AS customer_cnt
    FROM ant_icube_dev.di_data_cleaning_for_customer_database_e_customers
    GROUP BY city
),
valid_orders_2020 AS (
    SELECT
        o.customerid,
        c.city
    FROM ant_icube_dev.di_data_cleaning_for_customer_database_e_orders o
    JOIN ant_icube_dev.di_data_cleaning_for_customer_database_e_customers c
        ON o.customerid = c.customerid
    WHERE 
        YEAR(TO_DATE(o.orderdate)) = 2020  
),
order_counts_2020 AS (
    SELECT
        city,
        COUNT(*) AS order_cnt
    FROM valid_orders_2020
    GROUP BY city
)
SELECT
    a.city AS `城市`,
    a.customer_cnt AS `客户数量`,
    COALESCE(b.order_cnt, 0) AS `2018年订单数量`,
    CASE
        WHEN COALESCE(b.order_cnt, 0) = 0 THEN NULL
        ELSE ROUND(CAST(a.customer_cnt AS DOUBLE) / b.order_cnt, 2)
    END AS `客户订单比例`
FROM customer_counts a
LEFT JOIN order_counts_2020 b 
    ON a.city = b.city
ORDER BY `客户订单比例` DESC NULLS LAST;  -- 按比例降序排列