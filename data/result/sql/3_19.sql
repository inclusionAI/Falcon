WITH filtered_data AS (
    SELECT 
       SUBSTR(date,1,10) as temp_day,
        volume,
        high,
        low
    FROM ant_icube_dev.di_massive_yahoo_finance_dataset
    WHERE company = 'AAPL'
),
daily_calculation AS (
    SELECT 
        temp_day,
        (CAST(high AS DOUBLE) + CAST(low AS DOUBLE)) / 2 AS mid_price,
        CAST(volume AS BIGINT) AS volume
    FROM filtered_data
    WHERE high IS NOT NULL AND low IS NOT NULL AND volume IS NOT NULL
),
aggregated_data AS (
    SELECT 
        temp_day,
        mid_price,
        AVG(volume) AS avg_volume
    FROM daily_calculation
    GROUP BY temp_day,mid_price
)
SELECT 
    temp_day
FROM aggregated_data
WHERE avg_volume > 100000
ORDER BY temp_day;