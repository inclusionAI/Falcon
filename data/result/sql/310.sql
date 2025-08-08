WITH city_avg_distances AS (

SELECT

d.city,

AVG(CAST(r.distance_km AS DOUBLE)) AS total_avg,

AVG(CASE WHEN CAST(d.experience_years AS INT) >= 20 THEN CAST(r.distance_km AS DOUBLE) END) AS experienced_avg

FROM

ant_icube_dev.city_ride_data_drivers d

JOIN

ant_icube_dev.city_ride_data_rides r ON d.driver_id = r.driver_id

GROUP BY

d.city

)



SELECT

city AS `city`

FROM

city_avg_distances

WHERE

experienced_avg > total_avg;