with eligible_aliens as (
select
alien_name,
cast(strength_level as int) as strength,
cast(speed_level as int) as speed
from
ant_icube_dev.di_ben10_alien_universe_realistic_battle_dataset_aliens
where
home_planet = 'Ego the Living Planet'
),
score_ranking as (
select
alien_name,
(strength + speed) as combined_value,
row_number() over (order by (strength + speed) desc) as rn
from
eligible_aliens
)
select
alien_name as `alien_name`
from
score_ranking
where
rn = 1;