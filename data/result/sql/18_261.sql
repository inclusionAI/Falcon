with 
-- 筛选生活成本指数高于30的国家
cost_of_living_filtered as (
    select 
        country,
        cost_index
    from 
        ant_icube_dev.world_economic_cost_of_living
    where 
        cast(cost_index as double) > 100
),

-- 筛选旅游业GDP占比超过1%的国家
tourism_filtered as (
    select 
        country,
        percentage_of_gdp
    from 
        ant_icube_dev.world_economic_tourism
    where 
        cast(percentage_of_gdp as double) > 1.0
)

-- 关联两个筛选结果集
select distinct
    cof.country as `国家`
from 
    cost_of_living_filtered cof
join 
    tourism_filtered tf 
on 
    cof.country = tf.country
where 
    -- 确保两个条件同时满足
    cast(cof.cost_index as double) > 100
    and cast(tf.percentage_of_gdp as double) > 1.0;