with filtered_events as (
    select 
        e.user_id,
        e.date,
        cast(i.price_in_usd as double) as price
    from 
        ant_icube_dev.google_merchandise_events e
        join ant_icube_dev.google_merchandise_items i on e.item_id = i.id
    where 
        e.country = 'SE'
        and e.type = 'purchase'
),

-- 步骤2: 计算用户购买总次数和平均金额
user_stats as (
    select 
        user_id,
        count(*) as total_purchases,
        avg(price) as avg_price
    from 
        filtered_events
    group by 
        user_id
    having 
        count(*) > 1
),

-- 步骤3: 获取每个用户的最近一次购买记录
latest_purchases as (
    select 
        user_id,
        price,
        row_number() over (partition by user_id order by date desc) as rn
    from 
        filtered_events
)

-- 步骤4: 组合结果集，筛选最近购买超过均值的用户
select 
    u.user_id as `id`,
    u.total_purchases as `购买次数`,
    l.price as `最近一次购买金额`,
    u.avg_price as `历史平均金额`
from 
    user_stats u
    join latest_purchases l 
    on u.user_id = l.user_id
    and l.rn = 1
where 
    l.price > u.avg_price;