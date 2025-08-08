WITH europe_data AS (

SELECT

verbose.countrydisplay,

drinks.beer_servings,

drinks.spirit_servings,

drinks.wine_servings

FROM

ant_icube_dev.alcohol_and_life_expectancy_verbose verbose

JOIN

ant_icube_dev.alcohol_and_life_expectancy_drinks drinks

ON

verbose.countrydisplay = drinks.country

WHERE

verbose.regiondisplay = 'Europe'

),

converted_values AS (

SELECT

countrydisplay,

CAST(beer_servings AS DOUBLE) AS beer,

CAST(spirit_servings AS DOUBLE) AS spirit,

CAST(wine_servings AS DOUBLE) AS wine

FROM

europe_data

),

country_totals AS (

SELECT

countrydisplay,

beer + spirit AS total_alcohol,

wine

FROM

converted_values

),

-- 找到啤酒和烈酒消费总和最高的国家

max_country AS (

SELECT

countrydisplay,

total_alcohol,

wine,

ROW_NUMBER() OVER (ORDER BY total_alcohol DESC) AS rk

FROM

country_totals

)

SELECT

(wine / total_alcohol) * 100 AS `百分比`

FROM

max_country

WHERE

rk = 1;  -- 只选择消费总和最高的国家