WITH      daily_data AS (
          SELECT    data.index,
                    CASE
                              WHEN CAST(data.close AS DOUBLE) > CAST(data.open AS DOUBLE) THEN 1
                              ELSE 0
                    END AS is_rising
          FROM      ant_icube_dev.stock_exchange_index_data data
          WHERE     YEAR(to_date (data.date)) = 1988
          ),
          index_stats AS (
          SELECT    INDEX,
                    COUNT(*) AS total_days,
                    SUM(is_rising) AS rising_days
          FROM      daily_data
          GROUP BY  INDEX
          )
SELECT    INDEX AS `index`
FROM      index_stats
WHERE     rising_days > total_days / 2;