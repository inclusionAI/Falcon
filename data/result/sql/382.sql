WITH win_counts AS (
SELECT
alien_name,
COUNT(*) AS total_wins
FROM
ant_icube_dev.di_ben10_alien_universe_realistic_battle_dataset_battles
WHERE
winner = alien_name
GROUP BY
alien_name
)
SELECT
a.alien_name AS `alien_name`,
a.home_planet AS `home_planet`,
COALESCE(wc.total_wins, 0) AS `total_wins`
FROM
ant_icube_dev.di_ben10_alien_universe_realistic_battle_dataset_aliens a
LEFT JOIN
win_counts wc
ON
a.alien_name = wc.alien_name;