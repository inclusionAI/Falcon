with enemy_avg_speed as (
select
avg(cast(a.speed_level as double)) as global_avg_speed
from
ant_icube_dev.di_ben10_alien_universe_realistic_battle_dataset_enemies e
join
ant_icube_dev.di_ben10_alien_universe_realistic_battle_dataset_aliens a
on
e.enemy_name = a.alien_name
),
home_planet_strength as (
select
home_planet,
avg(cast(strength_level as double)) as avg_strength
from
ant_icube_dev.di_ben10_alien_universe_realistic_battle_dataset_aliens
group by
home_planet
)
select
home_planet as `家乡星球`
from
home_planet_strength
where
avg_strength > (select global_avg_speed from enemy_avg_speed);