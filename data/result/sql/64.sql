WITH      company_valuation AS (
          SELECT    country,
                    company,
                    CAST(
                    REPLACE   (valuation, '$', '') AS DECIMAL
                    ) AS valuation_num
          FROM      ant_icube_dev.di_unicorn_startups
          ),
          country_total AS (
          SELECT    country,
                    SUM(valuation_num) AS total_valuation
          FROM      company_valuation
          GROUP BY  country
          )
SELECT    company AS `company`
FROM      company_valuation cv
JOIN      country_total ct ON cv.country = ct.country
WHERE     (valuation_num / total_valuation * 100) > 10;