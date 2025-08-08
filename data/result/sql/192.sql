with
-- 计算每个城市的平均开业年限
store_opening_years as (
    select
        store_city,
        avg(months_between(current_date(), to_date(store_open_date, 'yyyy-mm-dd')) / 12) as avg_years
    from
        ant_icube_dev.mexico_toy_stores
    group by
        store_city
),
-- 计算区域平均库存
city_avg_inventory as (
    select
        s.store_city,
        avg(cast(i.stock_on_hand as int)) as avg_stock
    from
        ant_icube_dev.mexico_toy_inventory i
    join
        ant_icube_dev.mexico_toy_stores s
    on
        i.store_id = s.store_id
    group by
        s.store_city
),
-- 获取高于区域平均库存的店铺清单
high_inventory_stores as (
    select
        s.store_city,
        s.store_name,
        s.store_location,
        cast(i.stock_on_hand as int) as stock,
        c.avg_stock
    from
        ant_icube_dev.mexico_toy_inventory i
    join
        ant_icube_dev.mexico_toy_stores s
    on
        i.store_id = s.store_id
    join
        city_avg_inventory c
    on
        s.store_city = c.store_city
    where
        cast(i.stock_on_hand as int) > c.avg_stock
)
-- 组合最终结果
select
    soy.store_city as `店铺城市`,
    round(soy.avg_years, 2) as `平均开业年限`,
    his.store_name as `店铺名称`,
    his.store_location as `店铺位置`,
    his.stock as `库存量`,
    his.avg_stock as `区域平均库存`
from
    store_opening_years soy
join
    high_inventory_stores his
on
    soy.store_city = his.store_city
order by
    soy.store_city;