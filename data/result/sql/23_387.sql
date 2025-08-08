WITH speed_aliens AS (

SELECT 

alien_name

FROM 

ant_icube_dev.di_ben10_alien_universe_realistic_battle_dataset_aliens

WHERE 

CAST(speed_level AS INT) > 5

),

winner_counts AS (

SELECT

b.winner,

COUNT(*) AS cnt

FROM

ant_icube_dev.di_ben10_alien_universe_realistic_battle_dataset_battles b

INNER JOIN 

speed_aliens a ON b.winner = a.alien_name

GROUP BY

b.winner

),

ranked_winners AS (

SELECT

winner AS `alien_name`,

cnt,

RANK() OVER (ORDER BY cnt DESC) AS win_rank

FROM

winner_counts

)

SELECT 

`alien_name`

FROM 

ranked_winners

WHERE 

win_rank = 1;