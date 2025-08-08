WITH      filtered_data AS (
          SELECT    INDEX,
                    to_date (DATE) AS trade_date,
                    CAST(close AS DOUBLE) AS close_price
          FROM      ant_icube_dev.stock_exchange_index_data
          WHERE     to_date (DATE) BETWEEN '1998-01-21' AND '1998-01-27'
          ),
          windowed_data AS (
          SELECT    INDEX,
                    trade_date,
                    close_price,
                    LEAD(trade_date, 1) OVER (
                    PARTITION BY INDEX
                    ORDER BY  trade_date
                    ) AS next_date,
                    LEAD(close_price, 1) OVER (
                    PARTITION BY INDEX
                    ORDER BY  trade_date
                    ) AS next_close,
                    LEAD(trade_date, 2) OVER (
                    PARTITION BY INDEX
                    ORDER BY  trade_date
                    ) AS next_next_date,
                    LEAD(close_price, 2) OVER (
                    PARTITION BY INDEX
                    ORDER BY  trade_date
                    ) AS next_next_close
          FROM      filtered_data
          )
SELECT    DISTINCT w.index AS `index`,
          i.exchange AS `exchange`
FROM      windowed_data w
JOIN      ant_icube_dev.stock_exchange_index_info i ON w.index = i.index
WHERE     DATEDIFF(next_date, trade_date) = 1
AND       DATEDIFF(next_next_date, next_date) = 1
AND       close_price < next_close
AND       next_close < next_next_close;