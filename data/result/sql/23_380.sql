with vega_aliens as (
select
alien_name
from
ant_icube_dev.di_ben10_alien_universe_realistic_battle_dataset_aliens
where
home_planet = 'Vega'
),

battle_stats as (
select
b.alien_name,
count(1) as total_battles,
sum(case when b.winner = b.alien_name then 1 else 0 end) as win_count
from
ant_icube_dev.di_ben10_alien_universe_realistic_battle_dataset_battles b
inner join
vega_aliens v
on
b.alien_name = v.alien_name
group by
b.alien_name
),

filtered_aliens as (
select
alien_name,
win_count * 1.0 / total_battles as win_rate,
(win_count * 1.0 / total_battles) * total_battles as battle_efficiency
from
battle_stats
where
(win_count * 1.0 / total_battles) > 0.5
)

select
alien_name as `alien_name`,
battle_efficiency as `战斗效率`
from
filtered_aliens;