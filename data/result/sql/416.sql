WITH inventory_summary AS (
    SELECT 
        product_id,
        SUM(CAST(damaged_stock AS DOUBLE)) AS total_damaged,
        SUM(CAST(stock_received AS DOUBLE)) AS total_received
    FROM ant_icube_dev.blinkit_inventory
    GROUP BY product_id
),
product_damage_ratio AS (
    SELECT 
        p.product_id,
        p.category,
        (CAST(i.total_damaged AS DOUBLE) / NULLIF(i.total_received, 0)) AS `damage_ratio`
    FROM inventory_summary i
    JOIN ant_icube_dev.blinkit_products p
        ON i.product_id = p.product_id
),
category_avg_ratio AS (
    SELECT 
        category,
        AVG(`damage_ratio`) AS `avg_damage_ratio`
    FROM product_damage_ratio
    GROUP BY category
)
SELECT 
    pdr.product_id
FROM product_damage_ratio pdr
JOIN category_avg_ratio car
    ON pdr.category = car.category
WHERE pdr.`damage_ratio` > car.`avg_damage_ratio`