with country_gdp as (
select
country,
sum(cast(gdp_2023_billion_usd as double)) as gdp_sum
from
ant_icube_dev.ufc_country_data
where
gdp_2023_billion_usd is not null
and gdp_2023_billion_usd != 'NA'
group by
country
),
country_attendance as (
select
country,
avg(cast(attendance as bigint)) as avg_attendance
from
ant_icube_dev.ufc_events_stats
where
attendance is not null
and attendance != 'NA'
group by
country
)
select
cg.country as `country`,
cg.gdp_sum as `gdp_2023_billion_usd`,
ca.avg_attendance as `attendance`
from
country_gdp cg
inner join
country_attendance ca
on
cg.country = ca.country;