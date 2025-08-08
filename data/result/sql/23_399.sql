with battle_stats as (
select
a.alien_name,
a.species,
sum(case when b.winner = a.alien_name then 1.0 else 0.0 end) / count(*) as win_rate
from
ant_icube_dev.di_ben10_alien_universe_realistic_battle_dataset_battles b
join ant_icube_dev.di_ben10_alien_universe_realistic_battle_dataset_aliens a
on b.alien_name = a.alien_name
group by
a.alien_name,
a.species
),
speed_ranking as (
select
alien_name,
species,
row_number() over (partition by species order by cast(speed_level as int) desc) as speed_rank
from
ant_icube_dev.di_ben10_alien_universe_realistic_battle_dataset_aliens
),
win_rate_ranking as (
select
alien_name,
species,
row_number() over (partition by species order by win_rate desc) as win_rate_rank
from
battle_stats
),
qualified_aliens as (
select
s.alien_name,
s.species
from
speed_ranking s
join win_rate_ranking w
on s.alien_name = w.alien_name
and s.species = w.species
where
s.speed_rank <= 3
and w.win_rate_rank <= 3
)
select
species as `物种`,
alien_name as `外星人`
from
qualified_aliens;