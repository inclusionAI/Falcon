with global_avg as (
select
avg(cast(beer_servings as double)) as avg_beer
from
ant_icube_dev.alcohol_and_life_expectancy_drinks
)
select
country as `国家`,
avg(cast(total_litres_of_pure_alcohol as double)) as `平均纯酒精总消费量`
from
ant_icube_dev.alcohol_and_life_expectancy_drinks
where
cast(beer_servings as double) > (select avg_beer from global_avg)
group by
country;