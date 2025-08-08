with russian_fighters as (
select last_name
from ant_icube_dev.ufc_fighters_stats
where country = 'Russia'
),
russian_events as (
select
e.event_category,
e.attendance,
e.country
from
ant_icube_dev.ufc_events_stats e
inner join
russian_fighters rf
on
trim(e.fighter_1) = rf.last_name
),
event_avg_attendance as (
select
event_category,
country,
avg(cast(attendance as bigint)) as avg_attendance
from
russian_events
group by
event_category,
country
having
avg(cast(attendance as bigint)) > 10000
)
select
event_category as `赛事类型`,
gdp_2023_billion_usd as `举办国家的GDP`
from
event_avg_attendance e
inner join
ant_icube_dev.ufc_country_data c
on
e.country = c.country;