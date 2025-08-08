WITH global_avg AS (

SELECT

AVG(CAST(unemployment_rate_2023 AS DOUBLE)) AS avg_unemployment

FROM

ant_icube_dev.ufc_country_data

WHERE

unemployment_rate_2023 != 'NA'

),

ranked_countries AS (

SELECT

country AS `country`,

CAST(working_age_pop_percent AS DOUBLE) AS `working_age_pop_percent`,

RANK() OVER (ORDER BY CAST(working_age_pop_percent AS DOUBLE) DESC) AS country_rank

FROM

ant_icube_dev.ufc_country_data

WHERE

unemployment_rate_2023 != 'NA'

AND CAST(unemployment_rate_2023 AS DOUBLE) > (SELECT avg_unemployment FROM global_avg)

)

SELECT

`country`

FROM

ranked_countries

WHERE

country_rank = 1;