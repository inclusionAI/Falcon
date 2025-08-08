WITH filtered_battles AS (

SELECT

winner

FROM

ant_icube_dev.di_ben10_alien_universe_realistic_battle_dataset_battles

WHERE

enemy_name = 'Ultimate Big Chill'

AND winner != 'Ultimate Big Chill'

),

win_counts AS (

SELECT

winner,

COUNT(*) AS win_count

FROM

filtered_battles

GROUP BY

winner

),

unique_aliens AS (

SELECT

alien_name,

strength_level,

speed_level

FROM (

SELECT

alien_name,

strength_level,

speed_level,

ROW_NUMBER() OVER (PARTITION BY alien_name ORDER BY alien_id DESC) AS rn

FROM

ant_icube_dev.di_ben10_alien_universe_realistic_battle_dataset_aliens

) t

WHERE

rn = 1

),

joined_data AS (

SELECT

wc.winner,

wc.win_count,

CAST(ua.strength_level AS INT) * CAST(ua.speed_level AS INT) AS battle_power

FROM

win_counts wc

JOIN unique_aliens ua ON wc.winner = ua.alien_name

),

ranked_aliens AS (

SELECT

winner AS `外星人名称`,

win_count AS `胜场数`,

battle_power AS `战斗强度`,

RANK() OVER (

ORDER BY 

win_count DESC, 

battle_power DESC

) AS final_rank

FROM

joined_data

)

SELECT

`外星人名称`,

`战斗强度`

FROM

ranked_aliens

WHERE

final_rank <= 3;  -- 获取前三名（包括并列情况）