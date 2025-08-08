with cte as (

select

a.country as `country`,

a.beer_servings as `beer_servings`,

a.spirit_servings as `spirit_servings`,

a.wine_servings as `wine_servings`,

b.regiondisplay as `regiondisplay`

from

ant_icube_dev.alcohol_and_life_expectancy_drinks a

join

ant_icube_dev.alcohol_and_life_expectancy_verbose b

on

a.country = b.countrydisplay

)

select distinct

`country`,

`beer_servings`,

`spirit_servings`,

`wine_servings`,

`regiondisplay`

from

cte;