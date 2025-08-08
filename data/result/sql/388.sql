WITH vega_aliens AS (

SELECT 

alien_name

FROM 

ant_icube_dev.di_ben10_alien_universe_realistic_battle_dataset_aliens

WHERE 

home_planet = 'Vega'

),



alien_victories AS (

SELECT 

a.alien_name,

b.winner

FROM 

vega_aliens a

INNER JOIN 

ant_icube_dev.di_ben10_alien_universe_realistic_battle_dataset_battles b ON a.alien_name = b.alien_name

WHERE 

b.winner = a.alien_name

)



SELECT 

alien_name AS `alien_name`

FROM 

alien_victories

GROUP BY 

alien_name

HAVING 

COUNT(*) > 3;