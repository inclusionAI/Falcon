with
-- 转换烈酒消费量为数值类型，并关联两张表
combined_data as (
select
av.regiondisplay,
ad.country,
cast(ad.spirit_servings as bigint) as spirit_servings
from
ant_icube_dev.alcohol_and_life_expectancy_drinks ad
inner join
ant_icube_dev.alcohol_and_life_expectancy_verbose av
on
ad.country = av.countrydisplay
),
-- 对各区域国家按消费量进行排名
ranked_data as (
select
regiondisplay,
country,
spirit_servings,
row_number() over (partition by regiondisplay order by spirit_servings desc) as rk
from
combined_data
)
-- 取各区域消费量前3国家
select
regiondisplay as `区域`,
country as `国家`,
spirit_servings as `烈酒消费量`
from
ranked_data
where
rk <= 3
order by
`区域`,
`烈酒消费量` desc;