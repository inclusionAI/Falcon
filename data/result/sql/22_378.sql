WITH country_avg AS (
SELECT
country,
AVG(CAST(win_percent AS DOUBLE)) AS avg_win_percent
FROM
ant_icube_dev.ufc_fighters_stats
GROUP BY
country
),

-- 关联选手数据和国家平均胜率
fighter_analysis AS (
SELECT
fs.weight_division,
fs.country,
CAST(fs.win_percent AS DOUBLE) AS individual_win,
ca.avg_win_percent AS country_avg
FROM
ant_icube_dev.ufc_fighters_stats fs
LEFT JOIN
country_avg ca
ON
fs.country = ca.country
)

-- 按体重级别分组统计比较结果
SELECT
weight_division AS `weight_division`,
CASE
WHEN individual_win > country_avg THEN '是'
ELSE '否'
END AS `是否高于平均胜率`,
COUNT(*) AS `运动员数量`
FROM
fighter_analysis
GROUP BY
weight_division,
`是否高于平均胜率`
ORDER BY
weight_division;