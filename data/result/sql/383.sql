with battle_alien_info as (
select
battles.alien_name,
aliens.home_planet,
battles.enemy_name
from
ant_icube_dev.di_ben10_alien_universe_realistic_battle_dataset_battles battles
inner join
ant_icube_dev.di_ben10_alien_universe_realistic_battle_dataset_aliens aliens
on
battles.alien_name = aliens.alien_name
),
enemy_alien_info as (
select
enemies.enemy_name,
aliens.home_planet
from
ant_icube_dev.di_ben10_alien_universe_realistic_battle_dataset_enemies enemies
inner join
ant_icube_dev.di_ben10_alien_universe_realistic_battle_dataset_aliens aliens
on
enemies.alien_name = aliens.alien_name
)
select distinct
battle_alien_info.alien_name as `alien_name`
from
battle_alien_info
inner join
enemy_alien_info
on
battle_alien_info.enemy_name = enemy_alien_info.enemy_name
where
battle_alien_info.home_planet = enemy_alien_info.home_planet;