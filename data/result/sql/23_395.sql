WITH ranked_battles AS (
SELECT
alien_name,
enemy_name,
battle_date,
ROW_NUMBER() OVER (
PARTITION BY alien_name
ORDER BY TO_DATE(battle_date, 'dd-MM-yyyy') DESC
) AS rn
FROM
ant_icube_dev.di_ben10_alien_universe_realistic_battle_dataset_battles
)
SELECT
alien_name AS `alien_name`,
enemy_name AS `enemy_name`,
battle_date AS `battle_date`
FROM
ranked_battles
WHERE
rn <= 3
ORDER BY
TO_DATE(battle_date, 'dd-MM-yyyy') DESC;