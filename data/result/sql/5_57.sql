WITH      china_data AS (
          SELECT    city,
                    company
          FROM      ant_icube_dev.di_unicorn_startups
          WHERE     country = 'China'
          )
SELECT    city AS `city`,
          COUNT(company) AS `company_count`
FROM      china_data
GROUP BY  city
HAVING    COUNT(company) > 5
ORDER BY  city;