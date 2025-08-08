WITH filtered_data AS (
    SELECT 
        date,
        SUBSTR(date, 1, 7) AS `month`,
        CAST(high AS DOUBLE) AS high,
        CAST(low AS DOUBLE) AS low
    FROM ant_icube_dev.di_massive_yahoo_finance_dataset
    WHERE company = 'MSFT'
      AND SUBSTR(date, 1, 4) = '2018'
),
monthly_high_low AS (
    SELECT 
        `month`,
        MAX(high) AS max_high,
        MIN(low) AS min_low
    FROM filtered_data
    GROUP BY `month`
)
SELECT 
    `month`
FROM monthly_high_low
WHERE (max_high - min_low) > 10;