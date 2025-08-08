with avg_intelligence as (
select avg(cast(intelligence as int)) as avg_intel
from ant_icube_dev.di_ben10_alien_universe_realistic_battle_dataset_aliens
),
multi_battle_days as (
select
alien_name,
battle_date,
count(battle_id) as battle_count
from ant_icube_dev.di_ben10_alien_universe_realistic_battle_dataset_battles
group by alien_name, battle_date
having count(battle_id) > 1
)
select distinct
a.alien_name as `alien_name`
from multi_battle_days m
join ant_icube_dev.di_ben10_alien_universe_realistic_battle_dataset_aliens a
on m.alien_name = a.alien_name
where cast(a.intelligence as int) > (select avg_intel from avg_intelligence);