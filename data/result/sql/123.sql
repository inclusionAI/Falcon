WITH      filtered_data AS (
          SELECT    d.date,
                    CAST(d.close AS DOUBLE) AS close
          FROM      ant_icube_dev.stock_exchange_index_data d
          INNER     JOIN ant_icube_dev.stock_exchange_index_info i ON d.index = i.index
          WHERE     i.index = 'HSI'
          AND       to_date (d.date) >= '1998-01-01'
          GROUP BY  d.date,
                    d.close
          ),
          daily_changes AS (
          SELECT    to_date (DATE) AS trade_date,
                    close,
                    LAG(close, 1) OVER (
                    ORDER BY  to_date (DATE)
                    ) AS prev_close
          FROM      filtered_data
          ),
          changes_marked AS (
          SELECT    trade_date,
                    CASE
                              WHEN close > prev_close THEN 1
                              ELSE 0
                    END AS increased
          FROM      daily_changes
          WHERE     prev_close IS NOT NULL
          ),
          GROUPS AS (
          SELECT    trade_date,increased,
                    SUM(
                    CASE
                              WHEN increased = 0 THEN 1
                              ELSE 0
                    END
                    ) OVER (
                    ORDER BY  trade_date
                    ) AS group_id
          FROM      changes_marked
          ),
          consecutive_days AS (
          SELECT    group_id,
                    COUNT(*) AS days
          FROM      GROUPS
          WHERE     increased = 1
          GROUP BY  group_id
          )
SELECT    MAX(days) AS `最大连续上涨天数`
FROM      consecutive_days;