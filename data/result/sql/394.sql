with high_speed_aliens as (
select alien_name
from ant_icube_dev.di_ben10_alien_universe_realistic_battle_dataset_aliens
where cast(speed_level as int) > 8
),
qualified_battles as (
select
battles.enemy_name
from
ant_icube_dev.di_ben10_alien_universe_realistic_battle_dataset_battles as battles
inner join high_speed_aliens on battles.alien_name = high_speed_aliens.alien_name
where
battles.winner = high_speed_aliens.alien_name
)
select
enemy_name as `敌方名称`,
count(*) as `出现频率`
from
qualified_battles
group by
enemy_name;