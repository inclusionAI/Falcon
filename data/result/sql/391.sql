WITH qualified_aliens AS (

SELECT alien_name

FROM ant_icube_dev.di_ben10_alien_universe_realistic_battle_dataset_aliens

WHERE CAST(intelligence AS INT) + CAST(speed_level AS INT) + CAST(strength_level AS INT) > 13

)



SELECT DISTINCT

enemy_name as `敌人名称`

FROM

ant_icube_dev.di_ben10_alien_universe_realistic_battle_dataset_battles battles

INNER JOIN

qualified_aliens

ON

battles.alien_name = qualified_aliens.alien_name

WHERE

SUBSTR(battles.battle_date, 7, 4) >= '2024';