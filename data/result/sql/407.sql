with battles_data as (

select

alien_name,

battle_date,

battle_id,

enemy_name,

winner

from

ant_icube_dev.di_ben10_alien_universe_realistic_battle_dataset_battles

where

alien_name = 'Big Chill'



)

select * from battles_data;