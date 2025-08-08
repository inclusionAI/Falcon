with
-- 从饮品表中获取啤酒消费数据
drinks as (
select
beer_servings
from
ant_icube_dev.alcohol_and_life_expectancy_drinks
)
-- 计算全局平均值
select
avg(cast(beer_servings as double)) as `全球平均啤酒消费量`
from
drinks;