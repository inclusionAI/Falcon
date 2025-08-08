with ranked_aliens as (
select
home_planet,
species,
alien_name,
speed_level,
row_number() over (partition by home_planet, species order by cast(strength_level as int) desc) as rank
from
ant_icube_dev.di_ben10_alien_universe_realistic_battle_dataset_aliens
)
select
home_planet as `星球`,
species as `物种`,
alien_name as `外星人`,
speed_level as `速度等级`
from
ranked_aliens
where
rank <= 5;