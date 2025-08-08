with country_gdp as (
select country
from ant_icube_dev.ufc_country_data
where cast(gdp_2023_billion_usd as double) > 2000
),

valid_events as (
select
trim(e.country) as country,
trim(e.fighter_1) as fighter_1
from ant_icube_dev.ufc_events_stats e
inner join country_gdp c on e.country = c.country
where e.fighter_1 != 'NA'
),

fighter_percent as (
select
last_name,
cast(win_percent as double) as win_pct
from ant_icube_dev.ufc_fighters_stats
),

joined_data as (
select
v.country,
f.win_pct
from valid_events v
inner join fighter_percent f on v.fighter_1 = f.last_name
),

unique_win_percent as (
select distinct country, win_pct
from joined_data
),

final_result as (
select
country,
avg(win_pct) as avg_win_rate
from unique_win_percent
group by country
having avg(win_pct) > 60
)

select country
from final_result;