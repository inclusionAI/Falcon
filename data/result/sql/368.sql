WITH fighter_counts AS (

SELECT

TRIM(fighter_1) AS fighter_name,

COUNT(*) AS total_events

FROM

ant_icube_dev.ufc_events_stats

GROUP BY

TRIM(fighter_1)

HAVING

COUNT(*) > 10

),

fighter_countries AS (

SELECT

DISTINCT country

FROM

ant_icube_dev.ufc_fighters_stats

WHERE

last_name IN (SELECT fighter_name FROM fighter_counts)

)

SELECT

c.avg_temperature_celsius AS `avg_temperature_celsius`,

c.dependency_ratio_2023 AS `dependency_ratio_2023`

FROM

ant_icube_dev.ufc_country_data c

INNER JOIN

fighter_countries fc

ON

c.country = fc.country;