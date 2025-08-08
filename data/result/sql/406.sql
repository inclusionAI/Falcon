WITH ranked_aliens AS (
  SELECT
    alien_name,
    (CAST(intelligence AS INT) + 
     CAST(speed_level AS INT) + 
     CAST(strength_level AS INT)) AS intelligence_num,
    RANK() OVER (ORDER BY 
      (CAST(intelligence AS INT) + 
       CAST(speed_level AS INT) + 
       CAST(strength_level AS INT)) DESC) AS rnk
  FROM
    ant_icube_dev.di_ben10_alien_universe_realistic_battle_dataset_aliens
),

top_aliens AS (
  SELECT
    alien_name
  FROM
    ranked_aliens
  WHERE
    rnk <= 3
),

latest_battles AS (
  SELECT
    b.alien_name,
    b.enemy_name,
    TO_DATE(b.battle_date, 'dd-MM-yyyy') AS battle_date,
    ROW_NUMBER() OVER (
      PARTITION BY b.alien_name 
      ORDER BY TO_DATE(b.battle_date, 'dd-MM-yyyy') DESC
    ) AS battle_rn
  FROM
    ant_icube_dev.di_ben10_alien_universe_realistic_battle_dataset_battles b
  INNER JOIN
    top_aliens ta ON b.alien_name = ta.alien_name
)

SELECT
  lb.alien_name AS `智力前三外星人`,
  lb.enemy_name AS `对手名称`,
  ea.home_planet AS `对手所在星球`  -- 新增对手星球信息
FROM
  latest_battles lb
-- 通过enemy_name关联获取对手的星球信息
JOIN
  ant_icube_dev.di_ben10_alien_universe_realistic_battle_dataset_aliens ea 
  ON lb.enemy_name = ea.alien_name
WHERE
  lb.battle_rn = 1;