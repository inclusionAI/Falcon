WITH overall_avg AS (

SELECT

AVG(CAST(total_litres_of_pure_alcohol AS DOUBLE)) AS avg_alcohol

FROM

ant_icube_dev.alcohol_and_life_expectancy_drinks

),



-- 计算欧洲高收入国家平均纯酒精消耗量

europe_high_income AS (

SELECT

v.countrydisplay,

AVG(CAST(d.total_litres_of_pure_alcohol AS DOUBLE)) AS country_avg

FROM

ant_icube_dev.alcohol_and_life_expectancy_verbose v

JOIN

ant_icube_dev.alcohol_and_life_expectancy_drinks d

ON

v.countrydisplay = d.country

WHERE

v.regiondisplay = 'Europe'

AND v.worldbankincomegroupdisplay = 'High_income'

GROUP BY

v.countrydisplay

)



-- 筛选出超过总平均值的国家

SELECT

countrydisplay AS `国家`

FROM

europe_high_income

WHERE

country_avg > (SELECT avg_alcohol FROM overall_avg);