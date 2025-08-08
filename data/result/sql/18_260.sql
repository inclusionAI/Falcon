WITH unemployment_filter AS (
    SELECT country
    FROM ant_icube_dev.world_economic_unemployment
    WHERE CAST(unemployment_rate AS DOUBLE) < 6.0
),
corruption_filter AS (
    SELECT 
        CAST(c.annual_income AS DOUBLE) AS annual_income
    FROM ant_icube_dev.world_economic_corruption c
    INNER JOIN unemployment_filter u
    ON c.country = u.country
    WHERE CAST(c.corruption_index AS DOUBLE) > 50
)
SELECT
    AVG(annual_income) AS `年度人均收入平均值`
FROM corruption_filter;