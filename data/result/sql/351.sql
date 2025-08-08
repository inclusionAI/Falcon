WITH country_filter AS (

SELECT country

FROM ant_icube_dev.ufc_country_data

WHERE unemployment_rate_2023 != 'NA'

AND CAST(unemployment_rate_2023 AS DOUBLE) > 5.0

),

event_dates AS (

SELECT

date formatted_date

FROM ant_icube_dev.ufc_events_stats

INNER JOIN country_filter

ON ant_icube_dev.ufc_events_stats.country = country_filter.country

)

SELECT MIN(formatted_date) AS `earliest_date`

FROM event_dates;