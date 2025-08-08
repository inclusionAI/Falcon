WITH tierra_nova_aliens AS (
SELECT
strength_level
FROM
ant_icube_dev.di_ben10_alien_universe_realistic_battle_dataset_aliens
WHERE
home_planet = 'Tierra Nova'
)
SELECT
AVG(CAST(strength_level AS DOUBLE)) AS `平均战斗力量值`
FROM
tierra_nova_aliens;