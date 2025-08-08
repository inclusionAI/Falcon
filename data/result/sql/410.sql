with alien_wins as (

select

a.alien_name,

count(*) as win_count

from

ant_icube_dev.di_ben10_alien_universe_realistic_battle_dataset_aliens a

join

ant_icube_dev.di_ben10_alien_universe_realistic_battle_dataset_battles b

on

b.winner = a.alien_name

group by

a.alien_name

),

enemy_wins as (

select

e.enemy_name,

count(*) as win_count

from

ant_icube_dev.di_ben10_alien_universe_realistic_battle_dataset_enemies e

join

ant_icube_dev.di_ben10_alien_universe_realistic_battle_dataset_battles b

on

b.winner = e.enemy_name

group by

e.enemy_name

),

average_enemy_win as (

select

avg(win_count) as avg_win

from

enemy_wins

)

select

alien_name as `alien_name`

from

alien_wins

where

win_count >= 0.5  * (select avg_win from average_enemy_win);