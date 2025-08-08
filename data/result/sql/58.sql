WITH      filtered_data AS (
          SELECT    industry,
                    valuation
          FROM      ant_icube_dev.di_unicorn_startups
          WHERE     country = 'United States'
          ),
          converted_valuations AS (
          SELECT    industry,
                    CAST(
                    REPLACE   (valuation, '$', '') AS DOUBLE
                    ) AS valuation_num
          FROM      filtered_data
          )
SELECT    industry AS `industry`,
          AVG(valuation_num) AS `average_valuation`
FROM      converted_valuations
GROUP BY  industry
HAVING    AVG(valuation_num) > 5
ORDER BY  industry;