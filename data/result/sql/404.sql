with
-- 计算每个外星人作为胜利者的战斗次数
alien_win_counts as (
select
a.alien_name,
a.species,
a.strength_level,
count(*) as cnt
from
ant_icube_dev.di_ben10_alien_universe_realistic_battle_dataset_battles b
join ant_icube_dev.di_ben10_alien_universe_realistic_battle_dataset_aliens a
on b.winner = a.alien_name
group by
a.alien_name, a.species, a.strength_level
),
-- 计算每个敌人对应的外星人作为胜利者的战斗次数
enemy_win_counts as (
select
a.alien_name,
a.species,
a.strength_level,
count(*) as cnt
from
ant_icube_dev.di_ben10_alien_universe_realistic_battle_dataset_battles b
join ant_icube_dev.di_ben10_alien_universe_realistic_battle_dataset_enemies e
on b.winner = e.enemy_name
join ant_icube_dev.di_ben10_alien_universe_realistic_battle_dataset_aliens a
on e.alien_name = a.alien_name
group by
a.alien_name, a.species, a.strength_level
),
-- 合并两种来源的胜利数据
combined_win_counts as (
select * from alien_win_counts
union all
select * from enemy_win_counts
),
-- 计算物种内胜利次数排名
species_rank as (
select
species,
alien_name,
strength_level,
sum(cnt) as total_wins,
row_number() over(partition by species order by sum(cnt) desc) as rn
from
combined_win_counts
group by
species, alien_name, strength_level
)
-- 筛选每个物种中胜利次数最多的个体
select
species as `物种`,
alien_name as `外星人名称`,
strength_level as `力量等级`
from
species_rank
where
rn = 1;