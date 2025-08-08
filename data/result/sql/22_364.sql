WITH russian_fighters AS (

SELECT

age,

CAST(win_percent AS DOUBLE) AS win_percent

FROM

ant_icube_dev.ufc_fighters_stats

WHERE

country = 'Russia'

AND win_percent != 'NA'

)



SELECT

age AS `年龄分组`,

AVG(win_percent) AS `平均胜率`

FROM

russian_fighters

GROUP BY

age

ORDER BY

age;