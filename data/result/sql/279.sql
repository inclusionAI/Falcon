with verbose_filtered as (

select

countrydisplay,

regiondisplay

from

ant_icube_dev.alcohol_and_life_expectancy_verbose

where

worldbankincomegroupdisplay = 'High_income'

and yearcode = '1990'

),

region_avg as (

select

v.regiondisplay,

avg(cast(d.beer_servings as double)) as avg_beer

from

verbose_filtered v

inner join

ant_icube_dev.alcohol_and_life_expectancy_drinks d

on

v.countrydisplay = d.country

group by

v.regiondisplay

)

select

distinct v.countrydisplay as `国家`

from

verbose_filtered v

inner join

ant_icube_dev.alcohol_and_life_expectancy_drinks d

on

v.countrydisplay = d.country

inner join

region_avg r

on

v.regiondisplay = r.regiondisplay

where

cast(d.beer_servings as double) > r.avg_beer;