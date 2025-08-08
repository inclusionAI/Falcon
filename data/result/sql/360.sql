with filtered_countries as (
select
country
from
ant_icube_dev.ufc_country_data
where
cast(working_age_pop_percent as double) > 65.0
and (
(cast(percent_of_internet_users as double) - cast(percent_of_internet_users_2022 as double))
/ cast(percent_of_internet_users_2022 as double) * 100
) > 3
)
select
e.country as `country`,
avg(cast(e.attendance as bigint)) as `avg_attendance`
from
filtered_countries fc
join
ant_icube_dev.ufc_events_stats e
on
fc.country = e.country
group by
e.country;