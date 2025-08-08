WITH win_counts AS (
SELECT
alien_name,
COUNT(*) AS win_count
FROM
ant_icube_dev.di_ben10_alien_universe_realistic_battle_dataset_battles
WHERE
winner = alien_name
GROUP BY
alien_name
HAVING
COUNT(*) > 3
),
enemy_counts AS (
SELECT
alien_name,
COUNT(DISTINCT enemy_name) AS enemy_count
FROM
ant_icube_dev.di_ben10_alien_universe_realistic_battle_dataset_battles
GROUP BY
alien_name
HAVING
COUNT(DISTINCT enemy_name) > 2
)
SELECT
w.alien_name AS `alien_name`
FROM
win_counts w
JOIN
enemy_counts e
ON
w.alien_name = e.alien_name;