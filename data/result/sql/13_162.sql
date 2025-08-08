with 
-- 筛选节假日销售数据并按门店汇总
holiday_sales as (
    select 
        store, 
        sum(cast(weekly_sales as double)) as store_total
    from 
        ant_icube_dev.walmart_sales 
    where 
        isholiday = 'True'
    group by 
        store
),

-- 关联门店基础信息获取类型
store_sales_with_type as (
    select 
        hs.store,
        cast(hs.store_total as double) as `store_total`,
        ws.type
    from 
        holiday_sales hs
    inner join 
        ant_icube_dev.walmart_stores ws
    on 
        hs.store = ws.store
),

-- 计算各类型总销售额
type_total_sales as (
    select 
        type,
        sum(store_total) as type_total
    from 
        store_sales_with_type
    group by 
        type
),

-- 计算排名和占比
final_result as (
    select 
        s.type,
        s.store,
        s.store_total,
        (s.store_total / t.type_total) as ratio,
        row_number() over (
            partition by s.type 
            order by s.store_total desc
        ) as rank
    from 
        store_sales_with_type s
    inner join 
        type_total_sales t
    on 
        s.type = t.type
)

select 
    type as `商店类型`,
    store as `门店`,
    store_total as `节假日销售总额`,
    ratio as `销售占比`,
    rank as `销售排名`
from 
    final_result
order by 
    `商店类型`, 
    `销售排名`;