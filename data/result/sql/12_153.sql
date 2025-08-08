with event_data as (
    -- 步骤1: 筛选出所有类型为add_to_cart的事件，并提取月份
    select
        substr(date, 1, 7) as month,
        item_id
    from
        ant_icube_dev.google_merchandise_events
    where
        type = 'add_to_cart'
),
item_relation as (
    -- 步骤2: 关联商品表获取商品类别
    select
        e.month,
        i.category
    from
        event_data e
    join
        ant_icube_dev.google_merchandise_items i
    on
        e.item_id = i.id
),
monthly_count as (
    -- 步骤3: 按月份和商品类别分组统计次数
    select
        month,
        category,
        count(*) as cnt
    from
        item_relation
    group by
        month,
        category
)
-- 步骤4: 计算每个商品类别的月平均次数
select
    category as `商品类别`,
    avg(cnt) as `平均新增次数`
from
    monthly_count
group by
    `商品类别`;