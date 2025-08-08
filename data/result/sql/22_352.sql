with fightercountries as (

select

country,

count(*) as fighter_count

from

ant_icube_dev.ufc_fighters_stats

group by

country

),

rankedcountries as (

select

country,

rank() over (order by fighter_count desc) as country_rank

from

fightercountries

)

select

ufc_country_data.working_age_pop_percent as `劳动年龄人口比例`

from

ant_icube_dev.ufc_country_data

inner join

rankedcountries on ant_icube_dev.ufc_country_data.country = rankedcountries.country

where

rankedcountries.country_rank <= 2;