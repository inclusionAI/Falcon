with fighters_filtered as (
select
city,
last_name,
cast(win_percent as double) as win_percent
from
ant_icube_dev.ufc_fighters_stats
where
country = 'Brazil'
and cast(arm_reach_inch as double) > 80
),
events_filtered as (
select
distinct trim(fighter_1) as fighter_1_trimmed
from (
select
fighter_1,
case
when substr(date, 1, 3) = 'Jan' then '01'
when substr(date, 1, 3) = 'Feb' then '02'
when substr(date, 1, 3) = 'Mar' then '03'
when substr(date, 1, 3) = 'Apr' then '04'
when substr(date, 1, 3) = 'May' then '05'
when substr(date, 1, 3) = 'Jun' then '06'
when substr(date, 1, 3) = 'Jul' then '07'
when substr(date, 1, 3) = 'Aug' then '08'
when substr(date, 1, 3) = 'Sep' then '09'
when substr(date, 1, 3) = 'Oct' then '10'
when substr(date, 1, 3) = 'Nov' then '11'
when substr(date, 1, 3) = 'Dec' then '12'
end as month_num,
regexp_substr(date, '[0-9]+(?=,)') as day_str,
regexp_substr(date, '[0-9]{4}$') as year_str
from
ant_icube_dev.ufc_events_stats
) t
where
concat(year_str, '-', month_num, '-', lpad(day_str, 2, '0')) >= '2019-01-01'
),
joined_data as (
select
f.city,
f.last_name,
f.win_percent
from
fighters_filtered f
inner join
events_filtered e
on f.last_name = e.fighter_1_trimmed
),
ranked_data as (
select
city,
last_name,
win_percent,
row_number() over (partition by city order by win_percent desc) as rn
from
joined_data
)
select
city as `城市`,
last_name as `选手编号`,
win_percent as `胜率`
from
ranked_data
where
rn = 1;