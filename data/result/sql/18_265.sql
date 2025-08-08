WITH filtered_tourism AS (
    SELECT country
    FROM ant_icube_dev.world_economic_tourism
    WHERE CAST(percentage_of_gdp AS DOUBLE) > 3.0
),
joined_gdp AS (
    SELECT 
        r.country,
        CAST(r.gdp_per_capita AS DOUBLE) AS `gdp_per_capita`
    FROM filtered_tourism t
    INNER JOIN ant_icube_dev.world_economic_richest_countries r
    ON t.country = r.country
)
SELECT 
    country AS `country`
FROM (
    SELECT 
        country,
        ROW_NUMBER() OVER (ORDER BY `gdp_per_capita` DESC) AS rank
    FROM joined_gdp
) ranked_data
WHERE rank = 1;