WITH country_data_filter AS (

SELECT

country,

country_code,

CAST(population_growth_2023 AS DOUBLE) AS population_growth_2023,

CAST(percent_of_internet_users AS DOUBLE) AS internet_2023,

CAST(percent_of_internet_users_2022 AS DOUBLE) AS internet_2022

FROM

ant_icube_dev.ufc_country_data

WHERE

CAST(population_growth_2023 AS DOUBLE) < 0

),

internet_growth_calculation AS (

SELECT

country,

country_code,

(internet_2023 - internet_2022) AS internet_growth

FROM

country_data_filter

),

ranked_countries AS (

SELECT

country_code AS `country_code`,

country AS `country`,

internet_growth AS `internet_user_growth`,

RANK() OVER (ORDER BY internet_growth DESC) AS growth_rank

FROM

internet_growth_calculation

)

SELECT

`country`

FROM

ranked_countries

WHERE

growth_rank = 1;