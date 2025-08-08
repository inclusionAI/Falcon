with filtered_battles as (
select
alien_name,
battle_date,
enemy_name,
winner
from
ant_icube_dev.di_ben10_alien_universe_realistic_battle_dataset_battles
where
enemy_name = 'Snare-oh'
and substr(battle_date,7,4) = '2024'
and winner = alien_name
)
select distinct
a.alien_name as `alien_name`
from
filtered_battles fb
join
ant_icube_dev.di_ben10_alien_universe_realistic_battle_dataset_aliens a
on fb.alien_name = a.alien_name;