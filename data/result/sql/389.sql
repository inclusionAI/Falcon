with battle_counts as (
select
alien_name,
count(distinct battle_id) as `战斗次数`
from
ant_icube_dev.di_ben10_alien_universe_realistic_battle_dataset_battles
group by
alien_name
having
`战斗次数` >= 5
)
select distinct
a.alien_name as `alien_name`
from
ant_icube_dev.di_ben10_alien_universe_realistic_battle_dataset_aliens a
inner join
battle_counts bc
on
a.alien_name = bc.alien_name
where
cast(a.strength_level as int) > 8;