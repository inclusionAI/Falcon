WITH battles_vs_snareoh AS (

SELECT

b.battle_id,

b.alien_name,

b.winner

FROM

ant_icube_dev.di_ben10_alien_universe_realistic_battle_dataset_battles b

INNER JOIN

ant_icube_dev.di_ben10_alien_universe_realistic_battle_dataset_aliens a ON b.alien_name = a.alien_name

WHERE

b.enemy_name = 'Snare-oh'

),

alien_win_stats AS (

SELECT

alien_name,

SUM(CASE WHEN winner = alien_name THEN 1 ELSE 0 END) AS win_count,

COUNT(DISTINCT battle_id) AS total_battles

FROM

battles_vs_snareoh

GROUP BY

alien_name

)

SELECT

alien_name AS `alien_name`

FROM

alien_win_stats

WHERE

total_battles > 0 AND  -- 确保总战斗次数大于 0

(win_count / total_battles) > 0.50;  -- 判断是否胜率 > 50%