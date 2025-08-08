WITH a_stores AS (
    SELECT store
    FROM ant_icube_dev.walmart_stores
    WHERE type = 'A'
),
high_temp_data AS (
    SELECT 
        store,
        date,
        fuel_price
    FROM ant_icube_dev.walmart_features
    WHERE CAST(temperature AS DOUBLE) > 75
),
combined_sales AS (
    SELECT 
        s.date,
        s.store,
        CAST(s.weekly_sales AS DOUBLE) AS weekly_sales,
        CAST(h.fuel_price AS DOUBLE) AS fuel_price
    FROM ant_icube_dev.walmart_sales s
    LEFT JOIN a_stores a
        ON s.store = a.store
    LEFT JOIN high_temp_data h
        ON s.store = h.store AND s.date = h.date
)
SELECT 
    date AS `date`,
    store AS `store`,
    weekly_sales AS `weekly_sales`,
    fuel_price AS `fuel_price`,
    RANK() OVER (PARTITION BY date ORDER BY weekly_sales / fuel_price DESC) AS `sales_efficiency_rank`
FROM combined_sales
ORDER BY date, store;