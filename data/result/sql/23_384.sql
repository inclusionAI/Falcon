WITH alien_strength AS (
SELECT
alien_name,
CAST(intelligence AS INT) + CAST(strength_level AS INT) AS total_strength
FROM
ant_icube_dev.di_ben10_alien_universe_realistic_battle_dataset_aliens
),
max_strength AS (
SELECT
MAX(total_strength) AS max_total
FROM
alien_strength
),
top_aliens AS (
SELECT
alien_name
FROM
alien_strength
WHERE
total_strength = (SELECT max_total FROM max_strength)
),
battle_enemies AS (
SELECT
ta.alien_name,
COUNT(DISTINCT CASE WHEN b.winner = b.alien_name THEN b.enemy_name END) AS cnt
FROM
top_aliens ta
LEFT JOIN
ant_icube_dev.di_ben10_alien_universe_realistic_battle_dataset_battles b
ON ta.alien_name = b.alien_name
GROUP BY
ta.alien_name
)
SELECT
AVG(CAST(cnt AS DOUBLE)) AS `平均击败敌人数量`
FROM
battle_enemies;