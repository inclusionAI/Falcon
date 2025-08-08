WITH country_ranks AS (

SELECT 

country,

RANK() OVER (

ORDER BY CAST(percent_of_internet_users_2022 AS DOUBLE) DESC

) AS country_rank

FROM ant_icube_dev.ufc_country_data

),

top_countries AS (

SELECT country

FROM country_ranks

WHERE country_rank <= 10

),

valid_events AS (

SELECT TRIM(fighter_1) AS fighter_trim

FROM ant_icube_dev.ufc_events_stats

INNER JOIN top_countries

ON ant_icube_dev.ufc_events_stats.country = top_countries.country

WHERE 

TRIM(fighter_1) NOT IN ('NA', '') 

AND fighter_1 IS NOT NULL

),

fighter_stats AS (

SELECT CAST(win_percent AS DOUBLE) AS win_percent

FROM ant_icube_dev.ufc_fighters_stats

INNER JOIN valid_events

ON ant_icube_dev.ufc_fighters_stats.last_name = valid_events.fighter_trim

)

SELECT AVG(win_percent) AS `平均胜率`

FROM fighter_stats;