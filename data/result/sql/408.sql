with battle_filter as (

select

winner

from

ant_icube_dev.di_ben10_alien_universe_realistic_battle_dataset_battles

where

(

(alien_name = 'Rath' and enemy_name = 'Eatle')

or

(alien_name = 'Eatle' and enemy_name = 'Rath')

)

)

select

count(winner) as `胜利次数`

from

battle_filter

where

winner = 'Rath';