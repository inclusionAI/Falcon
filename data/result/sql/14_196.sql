with 
-- 连接销售表、店铺表、产品表并计算销售额
joined_data as (
    select 
        p.product_category as `product_category`,
        s.store_city as `store_city`,
        cast(regexp_replace(p.product_price, '[^0-9.]', '') as decimal) * cast(sa.units as int) as `sales_amount`
    from 
        ant_icube_dev.mexico_toy_sales sa
        join ant_icube_dev.mexico_toy_stores s on sa.store_id = s.store_id
        join ant_icube_dev.mexico_toy_products p on sa.product_id = p.product_id
),

-- 计算各品类各城市总销售额
category_city_sales as (
    select 
        `product_category`,
        `store_city`,
        sum(`sales_amount`) as `total_sales`
    from 
        joined_data
    group by 
        `product_category`, `store_city`
),

-- 计算各品类平均销售额
category_avg_sales as (
    select 
        `product_category`,
        avg(`total_sales`) as `avg_category_sales`
    from 
        category_city_sales
    group by 
        `product_category`
)

-- 筛选超过品类平均值的城市
select 
    ccs.`product_category` as `产品类别`,
    ccs.`store_city` as `城市`,
    ccs.`total_sales` as `历史总销售额`
from 
    category_city_sales ccs
    join category_avg_sales cas 
        on ccs.`product_category` = cas.`product_category`
where 
    ccs.`total_sales` > cas.`avg_category_sales`;