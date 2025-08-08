WITH paid_apps AS (
    SELECT 
        category,
        app,
        CAST(REGEXP_REPLACE(price, '[^0-9.]', '') AS DECIMAL(10,2)) AS price_value
    FROM 
        ant_icube_dev.di_google_play_store_apps
    WHERE 
        type = 'Paid' 
        AND price IS NOT NULL
        AND price != ''
        AND REGEXP_LIKE(price, '^\\$?[0-9]+(\\.[0-9]{1,2})?$')
),
ranked_apps AS (
    SELECT 
        category,
        app,
        price_value,
        DENSE_RANK() OVER (
            PARTITION BY category 
            ORDER BY price_value DESC
        ) AS price_rank
    FROM 
        paid_apps
)
SELECT 
    category AS `类别`,
    app AS `应用名称`,
    CONCAT('$', price_value) AS `价格`
FROM 
    ranked_apps
WHERE 
    price_rank = 1
ORDER BY 
    app ASC;