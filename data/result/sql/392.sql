WITH filtered_aliens AS (
SELECT
species,
speed_level
FROM
ant_icube_dev.di_ben10_alien_universe_realistic_battle_dataset_aliens
WHERE
CAST(intelligence AS INT) > 7
)
SELECT
species AS `物种`,
AVG(CAST(speed_level AS INT)) AS `平均战斗速度等级`
FROM
filtered_aliens
GROUP BY
species;