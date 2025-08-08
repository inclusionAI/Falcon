WITH avg_composite_score AS (

SELECT

AVG(CAST(speed_level AS INT) + CAST(intelligence AS INT)) AS avg_score

FROM

ant_icube_dev.di_ben10_alien_universe_realistic_battle_dataset_aliens

),

vega_aliens AS (

SELECT

alien_name,

CAST(speed_level AS INT) + CAST(intelligence AS INT) AS composite_score

FROM

ant_icube_dev.di_ben10_alien_universe_realistic_battle_dataset_aliens

WHERE

home_planet = 'Vega'

),

qualified_aliens AS (

SELECT

a.alien_name,

a.composite_score

FROM

vega_aliens a

WHERE

a.composite_score > (SELECT avg_score FROM avg_composite_score)

),

latest_battles AS (

SELECT

alien_name,

MAX(TO_DATE(battle_date, 'dd-MM-yyyy')) AS latest_date

FROM

ant_icube_dev.di_ben10_alien_universe_realistic_battle_dataset_battles

GROUP BY

alien_name

)

SELECT

q.alien_name AS `alien_name`,

q.composite_score AS `综合评分`,

TO_CHAR(l.latest_date, 'dd-MM-yyyy') AS `最新战斗日期`

FROM

qualified_aliens q

LEFT JOIN

latest_battles l ON q.alien_name = l.alien_name;