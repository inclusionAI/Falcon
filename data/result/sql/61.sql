WITH      cte_valuation AS (
          SELECT    country,
                    company,
                    CAST(
                    REPLACE   (valuation, '$', '') AS DOUBLE
                    ) AS valuation_num
          FROM      ant_icube_dev.di_unicorn_startups
          ),
          cte_rank AS (
          SELECT    country,
                    company,
                    valuation_num,
                    ROW_NUMBER() OVER (
                    PARTITION BY country
                    ORDER BY  valuation_num DESC
                    ) AS RANK
          FROM      cte_valuation
          )
SELECT    country AS `country`,
          company AS `company`
FROM      cte_rank
WHERE     RANK <= 3;