WITH filtered_battles AS (

SELECT

alien_name,

battle_date,

enemy_name

FROM

ant_icube_dev.di_ben10_alien_universe_realistic_battle_dataset_battles

WHERE

alien_name = 'Terraspin'

AND enemy_name = 'Ultimate Big Chill'

)

SELECT distinct

a.species AS `species`,

CAST(a.speed_level AS BIGINT) AS `speed_level`,

CAST(a.strength_level AS BIGINT) AS `strength_level`

FROM

filtered_battles b

JOIN

ant_icube_dev.di_ben10_alien_universe_realistic_battle_dataset_aliens a

ON b.alien_name = a.alien_name

WHERE

a.alien_name = 'Terraspin';