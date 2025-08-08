WITH store_sales AS (
    SELECT 
        store, 
        SUM(CAST(weekly_sales AS DOUBLE)) AS total_sales
    FROM ant_icube_dev.walmart_sales
    GROUP BY store
),
store_info AS (
    SELECT 
        store, 
        type
    FROM ant_icube_dev.walmart_stores
)
SELECT 
    s.store AS `store`,
    s.total_sales AS `总销售额`,
    i.type AS `类型`
FROM store_sales s
JOIN store_info i ON s.store = i.store;