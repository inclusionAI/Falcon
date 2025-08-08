WITH avg_pop_growth AS (

SELECT AVG(CAST(population_growth_2023 AS DOUBLE)) AS avg_growth

FROM ant_icube_dev.ufc_country_data

),

high_growth_countries AS (

SELECT

country,

CAST(total_population AS BIGINT) AS total_pop

FROM ant_icube_dev.ufc_country_data

WHERE CAST(population_growth_2023 AS DOUBLE) > (SELECT avg_growth FROM avg_pop_growth)

)

SELECT

h.country AS `country`,  -- 明确指定 country 来源

e.city AS `city`,

e.date AS `date`,

e.event_category AS `event_category`

FROM ant_icube_dev.ufc_events_stats e

INNER JOIN high_growth_countries h ON e.country = h.country

WHERE CAST(e.attendance AS BIGINT) > h.total_pop * 0.001;  -- 明确指定 total_pop 来源