WITH high_elevation_countries AS (

SELECT country

FROM ant_icube_dev.ufc_country_data

WHERE CAST(avg_elevation_meters AS DOUBLE) > 500

),

valid_events AS (

SELECT

e.country,

e.fighter_1

FROM ant_icube_dev.ufc_events_stats e

INNER JOIN high_elevation_countries h

ON e.country = h.country

),

event_fighters AS (

SELECT

v.country,

CAST(f.age AS DOUBLE) AS age

FROM valid_events v

INNER JOIN ant_icube_dev.ufc_fighters_stats f

ON TRIM(BOTH ' ' FROM v.fighter_1) = f.last_name  -- 关键修改：去除前后空格

WHERE

f.age IS NOT NULL

AND f.age != 'NA'

),

country_avg_age AS (

SELECT

country,

AVG(age) AS avg_age

FROM event_fighters

GROUP BY country

HAVING AVG(age) < 40

)

SELECT country

FROM country_avg_age;