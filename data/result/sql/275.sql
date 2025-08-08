with verbose_filtered as (
select
regiondisplay,
countrydisplay,
cast(displayvalue as double) as life_value
from
ant_icube_dev.alcohol_and_life_expectancy_verbose
where
yeardisplay = '1990'
and ghodisplay = 'Life expectancy at birth (years)'
),

region_avg as (
select
regiondisplay,
avg(life_value) as avg_life
from
verbose_filtered
group by
regiondisplay
having
avg_life > 65
),

eligible_countries as (
select
vf.countrydisplay,
ra.regiondisplay
from
verbose_filtered vf
inner join
region_avg ra
on vf.regiondisplay = ra.regiondisplay
),

joined_data as (
select
ec.regiondisplay,
d.beer_servings,
d.spirit_servings,
d.wine_servings,
d.total_litres_of_pure_alcohol
from
eligible_countries ec
inner join
ant_icube_dev.alcohol_and_life_expectancy_drinks d
on ec.countrydisplay = d.country
)

select
regiondisplay as `地区`,
avg(cast(beer_servings as double)) as `平均啤酒消费量`,
avg(cast(spirit_servings as double)) as `平均烈酒消费量`,
avg(cast(wine_servings as double)) as `平均葡萄酒消费量`,
avg(cast(total_litres_of_pure_alcohol as double)) as `平均纯酒精消费量`
from
joined_data
group by
regiondisplay;