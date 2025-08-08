WITH middle_east_events AS (
SELECT
e.attendance,
e.city,
e.country,
e.date,
e.event_category,
e.fighter_1,
e.fighter_2,
e.state_province,
e.venue,
c.avg_temperature_celsius
FROM
ant_icube_dev.ufc_events_stats e
JOIN ant_icube_dev.ufc_country_data c ON TRIM(e.country) = TRIM(c.country)
WHERE
c.country IN ('United Arab Emirates', 'Saudi Arabia', 'Qatar', 'Iran', 'Iraq', 'Turkey', 'Israel', 'Egypt', 'Jordan', 'Kuwait', 'Bahrain', 'Oman', 'Yemen', 'Lebanon', 'Syria')
),
qualified_fighters AS (
SELECT
last_name
FROM
ant_icube_dev.ufc_fighters_stats
WHERE
CAST(age AS DOUBLE) < 30
AND CAST(win_percent AS DOUBLE) > 80
AND REGEXP_REPLACE(win_percent, '[^0-9.]', '') <> ''
),
joined_data AS (
SELECT
me.city,
me.avg_temperature_celsius
FROM
middle_east_events me
JOIN qualified_fighters qf ON REGEXP_REPLACE(TRIM(me.fighter_1), '[^A-Za-z]', '') = REGEXP_REPLACE(TRIM(qf.last_name), '[^A-Za-z]', '')
)

SELECT
city AS `城市`,
AVG(CAST(avg_temperature_celsius AS DOUBLE)) AS `温度分布`
FROM
joined_data
GROUP BY
city;