WITH      filtered_data AS (
          SELECT    country,
                    date_joined
          FROM      ant_icube_dev.di_unicorn_startups
          WHERE     SUBSTR(date_joined, -4) = '2020'
          )
SELECT    country AS `国家`,
          COUNT(*) AS `数量`
FROM      filtered_data
GROUP BY  country
HAVING    COUNT(*) > 3
ORDER BY  `国家`;