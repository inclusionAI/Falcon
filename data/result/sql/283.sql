with verbose_europe_male_life as (

select

countrydisplay,

displayvalue

from

ant_icube_dev.alcohol_and_life_expectancy_verbose

where

regiondisplay = 'Europe'

and sexdisplay = 'Male'

and ghodisplay = 'Life expectancy at birth (years)'

and cast(displayvalue as double) > 75

)



-- 步骤2：关联饮酒数据表获取消费量指标

select distinct

v.countrydisplay as `countrydisplay`,

d.beer_servings as `beer_servings`,

d.spirit_servings as `spirit_servings`,

d.wine_servings as `wine_servings`

from

verbose_europe_male_life v

inner join

ant_icube_dev.alcohol_and_life_expectancy_drinks d

on

v.countrydisplay = d.country;