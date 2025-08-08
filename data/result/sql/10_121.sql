WITH      region_filter AS (
          SELECT    INDEX
          FROM      ant_icube_dev.stock_exchange_index_info
          WHERE     region = 'China'
          ),
          daily_data AS (
          SELECT    d.date,
                    d.index,
                    CAST(d.close AS DOUBLE) AS close
          FROM      ant_icube_dev.stock_exchange_index_data d
          INNER     JOIN region_filter r ON d.index = r.index
          WHERE     YEAR(TO_DATE (d.date)) = 1998
          ),
          avg_close AS (
          SELECT    INDEX,
                    AVG(close) AS avg_close
          FROM      daily_data
          GROUP BY  INDEX
          )
SELECT    d.date AS `date`,
          d.index AS `index`
FROM      daily_data d
INNER     JOIN avg_close a ON d.index = a.index
WHERE     d.close > a.avg_close
ORDER BY  d.date ASC;