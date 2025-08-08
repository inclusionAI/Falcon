WITH country_population AS (
SELECT
country,
CAST(total_population AS DOUBLE) AS total_population
FROM
ant_icube_dev.ufc_country_data
WHERE
CAST(total_population AS DOUBLE) > 5000000
),
country_events AS (
SELECT
country,
COUNT(*) AS event_cnt
FROM
ant_icube_dev.ufc_events_stats
GROUP BY
country
HAVING
COUNT(*) > 2
)
SELECT
cp.country
FROM
country_population cp
JOIN
country_events ce
ON
cp.country = ce.country;