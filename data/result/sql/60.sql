WITH      valuation_conversion AS (
          SELECT    country,
                    company,
                    city,
                    CAST(SUBSTR(valuation, 2) AS DOUBLE) AS valuation_num
          FROM      ant_icube_dev.di_unicorn_startups
          ),
          country_ranking AS (
          SELECT    country,
                    company,
                    city,
                    valuation_num,
                    ROW_NUMBER() OVER (
                    PARTITION BY country
                    ORDER BY  valuation_num DESC
                    ) AS RANK
          FROM      valuation_conversion
          )
SELECT    country AS `国家`,
          company AS `公司`,
          city AS `城市`,
          CONCAT('$', CAST(valuation_num AS string)) AS `估值`
FROM      country_ranking
WHERE     RANK = 1;