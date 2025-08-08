WITH cost_filtered AS (
    SELECT 
        country,
        CAST(cost_index AS DOUBLE) AS cost_index,
        CAST(monthly_income AS DOUBLE) AS monthly_income,
        CAST(purchasing_power_index AS DOUBLE) AS purchasing_power_index
    FROM 
        ant_icube_dev.world_economic_cost_of_living
    WHERE 
        CAST(cost_index AS DOUBLE) > 30
),
tourism_filtered AS (
    SELECT 
        country,
        CAST(percentage_of_gdp AS DOUBLE) AS percentage_of_gdp
    FROM 
        ant_icube_dev.world_economic_tourism
    WHERE 
        CAST(percentage_of_gdp AS DOUBLE) > 1
),
combined_countries AS (
    SELECT 
        c.country,
        c.monthly_income,
        c.purchasing_power_index
    FROM 
        cost_filtered c
    JOIN 
        tourism_filtered t 
    ON 
        c.country = t.country
),
ranked_data AS (
    SELECT 
        country,
        monthly_income,
        purchasing_power_index,
        ROW_NUMBER() OVER (ORDER BY monthly_income DESC) AS `月收入排名`,
        ROW_NUMBER() OVER (ORDER BY purchasing_power_index DESC) AS `购买力指数排名`
    FROM 
        combined_countries
)
SELECT 
    country AS `country`,
    monthly_income AS `monthly_income`,
    purchasing_power_index AS `purchasing_power_index`,
    `月收入排名`,
    `购买力指数排名`
FROM 
    ranked_data;