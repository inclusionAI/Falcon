WITH filtered_battles AS (

SELECT

battle_id,

alien_name

FROM

ant_icube_dev.di_ben10_alien_universe_realistic_battle_dataset_battles

WHERE

alien_name = 'Big Chill'

AND battle_date > '01-01-2024'

),

alien_attributes AS (

SELECT

alien_name,

CAST(strength_level AS INT) AS strength,

CAST(speed_level AS INT) AS speed,

CAST(intelligence AS INT) AS intelligence

FROM

ant_icube_dev.di_ben10_alien_universe_realistic_battle_dataset_aliens

)

SELECT

fb.battle_id,

aa.strength,

aa.speed 

FROM

filtered_battles fb

JOIN

alien_attributes aa ON fb.alien_name = aa.alien_name