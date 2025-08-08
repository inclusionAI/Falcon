WITH corruption_filtered AS (
    SELECT country
    FROM ant_icube_dev.world_economic_corruption
    WHERE cast(corruption_index AS DOUBLE) > 50
),
unemployment_joined AS (
    SELECT u.country
    FROM ant_icube_dev.world_economic_unemployment u
    INNER JOIN corruption_filtered cf ON u.country = cf.country
),
richest_filtered AS (
    SELECT r.country, r.gdp_per_capita
    FROM ant_icube_dev.world_economic_richest_countries r
    INNER JOIN unemployment_joined uj ON r.country = uj.country
)
SELECT 
    country as `country`,
    cast(gdp_per_capita AS DOUBLE) as `gdp_per_capita`
FROM richest_filtered
ORDER BY cast(gdp_per_capita AS DOUBLE) DESC 
LIMIT 3;