SELECT 
    et.country AS `country`
FROM 
    ant_icube_dev.world_economic_tourism et
JOIN 
    ant_icube_dev.world_economic_tourism t 
ON 
    et.country = t.country
JOIN 
    ant_icube_dev.world_economic_unemployment u 
ON 
    et.country = u.country
WHERE 
    CAST(t.percentage_of_gdp AS DOUBLE) > (
        SELECT AVG(CAST(percentage_of_gdp AS DOUBLE)) 
        FROM ant_icube_dev.world_economic_tourism
    )
    AND CAST(u.unemployment_rate AS DOUBLE) < 5;