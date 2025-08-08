with category_avg_price as (
    -- 计算每个产品类别的平均价格
    select
        p.categoryid,
        avg(cast(p.price as double)) as avg_price
    from
        ant_icube_dev.grocery_sales_products p
    group by
        p.categoryid
),
high_price_products as (
    -- 获取产品信息并与类别信息关联，同时比较价格是否高出均价40%
    select
        p.productid,
        p.productname,
        cast(p.price as double) as price,
        p.isallergic,
        c.categoryid,
        c.categoryname,
        cap.avg_price
    from
        ant_icube_dev.grocery_sales_products p
    inner join
        ant_icube_dev.grocery_sales_categories c
    on
        p.categoryid = c.categoryid
    inner join
        category_avg_price cap
    on
        p.categoryid = cap.categoryid
    where
        cast(p.price as double) > cap.avg_price * 1.4
)
-- 最终结果：产品类别、产品名称、产品价格及过敏属性
select
    categoryname as `产品类别名称`,
    productname as `产品名称`,
    price as `产品价格`,
    isallergic as `过敏属性`
from
    high_price_products;