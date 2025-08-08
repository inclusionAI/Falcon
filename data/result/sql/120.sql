WITH      joined_data AS (
          SELECT    d.date,
                    d.index,
                    CAST(d.volume AS BIGINT) AS volume,
                    CAST(d.close AS DOUBLE) AS close,
                    i.region
          FROM      ant_icube_dev.stock_exchange_index_data d
          JOIN      ant_icube_dev.stock_exchange_index_info i ON d.index = i.index
          ),
          avg_volume AS (
          SELECT    INDEX,
                    AVG(CAST(volume AS BIGINT)) AS avg_volume
          FROM      ant_icube_dev.stock_exchange_index_data
          GROUP BY  INDEX
          ),
          region_max_close AS (
          SELECT    region,
                    MAX(CAST(close AS DOUBLE)) AS max_region_close
          FROM      joined_data
          GROUP BY  region
          ),
          recent_data AS (
          SELECT    jd.date,
                    jd.index,
                    jd.volume,
                    jd.close,
                    jd.region
          FROM      joined_data jd
          JOIN      avg_volume av ON jd.index = av.index
          JOIN      region_max_close rmc ON jd.region = rmc.region
          WHERE  jd.volume > av.avg_volume
          AND       jd.close = rmc.max_region_close
          )
SELECT    DATE AS `date`,
          INDEX AS `index`,
          volume AS `volume`,
          close AS `close`,
          region AS `region`
FROM      recent_data;