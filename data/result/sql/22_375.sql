with filtered_fighters as (

select

f.weight_lbs,

c.unemployment_rate_2023

from

ant_icube_dev.ufc_fighters_stats f

join ant_icube_dev.ufc_country_data c on f.country = c.country

where

f.country = 'Brazil'

and f.debut >= '2020-01-01'

and f.weight_division = 'Featherweight Division'

)

select

avg(cast(weight_lbs as double)) as `平均体重`,

avg(cast(unemployment_rate_2023 as double)) as `所在城市失业率`

from

filtered_fighters;