WITH recent_events AS (

SELECT DISTINCT TRIM(fighter_1) AS fighter_1_trimmed

FROM ant_icube_dev.ufc_events_stats

WHERE CAST(SUBSTR(date, -4) AS INT) >= YEAR(NOW()) - 3

),

us_lightweight_fighters AS (

SELECT

last_name,

arm_reach_inch,

city,

weight_lbs

FROM ant_icube_dev.ufc_fighters_stats

WHERE country = 'United States'

AND weight_division = 'Lightweight Division'

AND CAST(win_percent AS DOUBLE) > 70

),

qualified_fighters AS (

SELECT

uf.last_name,

uf.arm_reach_inch,

uf.city,

uf.weight_lbs

FROM us_lightweight_fighters uf

INNER JOIN recent_events re ON re.fighter_1_trimmed = uf.last_name

),

arm_reach_ranking AS (

SELECT

last_name,

arm_reach_inch,

city,

weight_lbs,

RANK() OVER (

ORDER BY CAST(arm_reach_inch AS DOUBLE) DESC

) AS reach_rank  -- 改为RANK()

FROM qualified_fighters

),

city_avg_weight AS (

SELECT

city,

AVG(CAST(weight_lbs AS DOUBLE)) AS avg_weight

FROM qualified_fighters

GROUP BY city

)

SELECT

arr.last_name AS `选手姓氏`,

arr.arm_reach_inch AS `臂展英寸`,

arr.reach_rank AS `臂展排名`,

arr.city AS `城市`,

caw.avg_weight AS `城市平均体重`

FROM arm_reach_ranking arr

INNER JOIN city_avg_weight caw ON arr.city = caw.city

ORDER BY arr.reach_rank;  -- 按排名排序