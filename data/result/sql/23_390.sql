WITH battles_vs_ultimate_bc AS (
SELECT
winner
FROM
ant_icube_dev.di_ben10_alien_universe_realistic_battle_dataset_battles
WHERE
enemy_name = 'Ultimate Big Chill'
)
SELECT DISTINCT
a.alien_name as `alien_name`
FROM
battles_vs_ultimate_bc b
JOIN
ant_icube_dev.di_ben10_alien_universe_realistic_battle_dataset_aliens a
ON
b.winner = a.alien_name
WHERE
CAST(a.intelligence AS INT) > 5;