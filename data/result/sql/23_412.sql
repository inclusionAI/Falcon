with combat_scores as (

select

alien_id,

alien_name,

species,

cast(strength_level as int) + cast(speed_level as int) + cast(intelligence as int) as total_power

from

ant_icube_dev.di_ben10_alien_universe_realistic_battle_dataset_aliens

),

ranked_data as (

select

species,

alien_name,

total_power,

rank() over (partition by species order by total_power desc) as rank_num

from

combat_scores

)

select

species as `物种`,

alien_name as `外星人名称`

from

ranked_data

where

rank_num <= 1;