with filtered_aliens as (
select
alien_name,
cast(strength_level as int) as strength
from
ant_icube_dev.di_ben10_alien_universe_realistic_battle_dataset_aliens
where
home_planet = 'Ego the Living Planet'
),
max_strength as (
select
max(strength) as max_str
from
filtered_aliens
)
select
alien_name as `alien_name`
from
filtered_aliens
where
strength = (select max_str from max_strength);