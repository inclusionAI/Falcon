WITH battle_counts AS (
SELECT
alien_name,
COUNT(DISTINCT battle_id) AS total_battles
FROM
ant_icube_dev.di_ben10_alien_universe_realistic_battle_dataset_battles
GROUP BY
alien_name
HAVING
COUNT(DISTINCT battle_id) > 3
),
qualified_aliens AS (
SELECT
a.alien_name,
a.speed_level,
a.strength_level
FROM
ant_icube_dev.di_ben10_alien_universe_realistic_battle_dataset_aliens a
INNER JOIN
battle_counts bc
ON
a.alien_name = bc.alien_name
WHERE
CAST(a.intelligence AS INT) > 8
)
SELECT
alien_name AS `alien_name`,
speed_level AS `speed_level`,
strength_level AS `strength_level`
FROM
qualified_aliens;