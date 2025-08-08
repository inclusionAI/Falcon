WITH high_gdp_countries AS (
    SELECT 
        country,
        gdp_per_capita
    FROM 
        ant_icube_dev.world_economic_richest_countries
),
unemployment_filter AS (
    SELECT 
        country,
        CAST(unemployment_rate AS DOUBLE) AS unemployment_rate
    FROM 
        ant_icube_dev.world_economic_unemployment
    WHERE 
        CAST(unemployment_rate AS DOUBLE) < 5
)
SELECT 
    h.country AS `country`,
    u.unemployment_rate AS `unemployment_rate`
FROM 
    high_gdp_countries h
INNER JOIN 
    unemployment_filter u 
ON 
    h.country = u.country;