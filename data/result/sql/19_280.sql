with americas_spirit as (

select

a.countrydisplay as `国家`,

cast(b.spirit_servings as double) as spirit_val

from

ant_icube_dev.alcohol_and_life_expectancy_verbose a

join

ant_icube_dev.alcohol_and_life_expectancy_drinks b

on

a.countrydisplay = b.country

where

a.regiondisplay = 'Americas'

),

country_avg as (

select

`国家`,

avg(spirit_val) as avg_spirit_val

from

americas_spirit

group by

`国家`

),

region_avg as (

select

avg(avg_spirit_val) as avg_val

from

country_avg

)

select distinct

c.`国家`

from

country_avg c

where

c.avg_spirit_val > (select avg_val from region_avg);