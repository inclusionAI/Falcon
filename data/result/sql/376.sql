WITH all_fighters AS (

SELECT 

trim(fighter) AS fighter_name,

'event' AS source_table

FROM (

SELECT fighter_1 AS fighter FROM ant_icube_dev.ufc_events_stats

UNION ALL

SELECT fighter_2 AS fighter FROM ant_icube_dev.ufc_events_stats

) combined

),



fighter_stats AS (

SELECT 

f.last_name,

MAX(f.arm_reach_inch) AS latest_arm_reach,  -- 取最新臂展

MAX(f.leg_reach_inch) AS latest_leg_reach,  -- 取最新腿展

MAX(f.country) AS country  -- 假设国家不变

FROM ant_icube_dev.ufc_fighters_stats f

GROUP BY  f.last_name

),



participation_counts AS (

SELECT 

fs.last_name,

COUNT(*) AS participation_count,

fs.latest_arm_reach,

fs.latest_leg_reach,

fs.country

FROM all_fighters af

JOIN fighter_stats fs 

ON af.fighter_name = fs.last_name  -- 最好用ID匹配

GROUP BY fs.last_name, fs.latest_arm_reach, fs.latest_leg_reach, fs.country

)



SELECT 

pc.last_name AS `拳手`,

pc.participation_count AS `参赛次数`,

COALESCE(cd.percent_of_internet_users, 0) AS `互联网用户比例`,

(COALESCE(CAST(pc.latest_arm_reach AS DOUBLE), 0) + 

COALESCE(CAST(pc.latest_leg_reach AS DOUBLE), 0)) AS `臂展腿展总和`

FROM participation_counts pc

LEFT JOIN ant_icube_dev.ufc_country_data cd  -- 改用左连接

ON pc.country = cd.country

ORDER BY `臂展腿展总和` DESC;