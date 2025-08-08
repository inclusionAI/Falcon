WITH      annual_avg_diff AS (
          SELECT    INDEX,
                    SUBSTR(DATE, 1, 4) AS YEAR,
                    AVG(CAST(high AS DOUBLE)) - AVG(CAST(low AS DOUBLE)) AS avg_diff
          FROM      ant_icube_dev.stock_exchange_index_data
          GROUP BY  INDEX,
                    SUBSTR(DATE, 1, 4)
          ),
          exchange_avg AS (
          SELECT    info.exchange,
                    AVG(annual.avg_diff) AS overall_avg_diff
          FROM      annual_avg_diff annual
          JOIN      ant_icube_dev.stock_exchange_index_info info ON annual.index = info.index
          GROUP BY  info.exchange
          )
SELECT    exchange AS `exchange`
FROM      exchange_avg
WHERE     overall_avg_diff > 700;