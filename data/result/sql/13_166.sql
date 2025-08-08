WITH qualified_stores AS (
    SELECT DISTINCT store
    FROM ant_icube_dev.walmart_features
    WHERE date >= '2013-04-01' AND date <= '2013-06-30'
      AND CAST(cpi AS DOUBLE) > 200
      AND CAST(fuel_price AS DOUBLE) < 3.5
),
joined_sales AS (
    SELECT s.store, s.weekly_sales
    FROM ant_icube_dev.walmart_sales s
    LEFT JOIN qualified_stores q
    ON s.store = q.store
),
joined_stores AS (
    SELECT j.store, j.weekly_sales, st.type
    FROM joined_sales j
    LEFT JOIN ant_icube_dev.walmart_stores st
    ON j.store = st.store
),
avg_sales_ranked AS (
    SELECT 
        type,
        AVG(CAST(weekly_sales AS DOUBLE)) AS avg_weekly_sales,
        RANK() OVER (ORDER BY AVG(CAST(weekly_sales AS DOUBLE)) DESC) AS sales_rank
    FROM joined_stores
    GROUP BY type
)
SELECT 
    `type` AS `店铺类型`,
    avg_weekly_sales AS `平均周销售额`,
    sales_rank AS `排名`
FROM avg_sales_ranked;