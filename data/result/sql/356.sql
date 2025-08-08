WITH cte_country AS (
SELECT
country_code,
country,
percent_of_internet_users
FROM
ant_icube_dev.ufc_country_data
WHERE
CAST(percent_of_internet_users AS DOUBLE) > 90.0
),
cte_events AS (
SELECT
e.city,
e.attendance
FROM
ant_icube_dev.ufc_events_stats e
INNER JOIN
cte_country c ON e.country = c.country
WHERE
CAST(e.attendance AS INT) > 15000
)
SELECT
DISTINCT city
FROM
cte_events;