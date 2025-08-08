WITH recent_battles AS (

SELECT

alien_name,

winner

FROM

ant_icube_dev.di_ben10_alien_universe_realistic_battle_dataset_battles

WHERE

YEAR(TO_DATE(battle_date, 'dd-MM-yyyy')) BETWEEN YEAR(CURRENT_DATE()) - 2 AND YEAR(CURRENT_DATE())

),

alien_victories AS (

SELECT

a.alien_name,

CAST(a.speed_level AS DOUBLE) AS speed_level

FROM

recent_battles b

JOIN ant_icube_dev.di_ben10_alien_universe_realistic_battle_dataset_aliens a 

ON b.alien_name = a.alien_name

WHERE

b.winner = a.alien_name

),

victory_counts AS (

SELECT

alien_name,

COUNT(*) AS victory_num

FROM

alien_victories

GROUP BY

alien_name

),

avg_speed_levels AS (

SELECT

a.alien_name,

AVG(CAST(a.speed_level AS DOUBLE)) AS avg_speed

FROM

ant_icube_dev.di_ben10_alien_universe_realistic_battle_dataset_aliens a

GROUP BY

a.alien_name

),

ranked_aliens AS (

SELECT

v.alien_name,

v.victory_num,

s.avg_speed,

DENSE_RANK() OVER (ORDER BY v.victory_num DESC) AS rank  -- 按胜利次数降序排名

FROM

victory_counts v

JOIN avg_speed_levels s 

ON v.alien_name = s.alien_name

)

SELECT

alien_name AS `alien_name`,

avg_speed AS `平均战斗速度等级`

FROM

ranked_aliens

WHERE

rank <= 3;  -- 仅保留前三名