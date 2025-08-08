with filtered_country as (
select
avg_elevation_meters,
total_population,
percent_of_internet_users
from
ant_icube_dev.ufc_country_data
where
country = 'Austria'
)
select
avg_elevation_meters as `avg_elevation_meters`,
total_population as `total_population`,
percent_of_internet_users as `percent_of_internet_users`
from
filtered_country;