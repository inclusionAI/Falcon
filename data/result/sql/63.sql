WITH      fintech_companies AS (
          SELECT    country,
                    valuation,
                    company
          FROM      ant_icube_dev.di_unicorn_startups
          WHERE     industry = 'Fintech'
          )
SELECT    country AS `国家`,
          COUNT(company) AS `企业数量`,
          REGEXP_REPLACE(MAX(valuation), '[^0-9.]', '') AS `最高估值`
FROM      fintech_companies
GROUP BY  country
ORDER BY  CAST(REGEXP_REPLACE(MAX(valuation), '[^0-9.]', '') AS DECIMAL) DESC;