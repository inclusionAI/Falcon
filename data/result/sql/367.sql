WITH fighters_ranking AS (

SELECT

country,

first_name,

last_name,

CAST(wins AS INT) AS wins,

RANK() OVER (PARTITION BY country ORDER BY CAST(wins AS INT) DESC) AS ranking  -- 使用 RANK() 处理并列情况

FROM

ant_icube_dev.ufc_fighters_stats

),

country_economics AS (

SELECT

country,

total_population,                       

gdp_2023_billion_usd

FROM

ant_icube_dev.ufc_country_data

)

SELECT DISTINCT

fr.country AS `国家`,

fr.last_name AS `选手姓氏`,

fr.first_name AS `选手名字`, 

fr.ranking AS `排名`,

(CAST(ce.gdp_2023_billion_usd AS DOUBLE) * 1000000000) / CAST(ce.total_population AS DOUBLE) AS `GDP与人口比`

FROM

fighters_ranking fr

JOIN

country_economics ce ON fr.country = ce.country

ORDER BY

fr.country, fr.ranking;  -- 根据国家和排名进行排序