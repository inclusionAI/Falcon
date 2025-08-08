with 
-- 获取谷物类产品的销售记录
grain_sales as (
    select 
        s.salespersonid,
        cast(s.quantity as double) as quantity
    from 
        ant_icube_dev.grocery_sales_sales s
        join ant_icube_dev.grocery_sales_products p on s.productid = p.productid
        join ant_icube_dev.grocery_sales_categories c on p.categoryid = c.categoryid
    where 
        c.categoryname = 'Grain'
),
-- 计算销售人员平均销量
sales_avg as (
    select 
        salespersonid,
        avg(quantity) as avg_quantity
    from 
        grain_sales
    group by 
        salespersonid
)
-- 筛选超过平均销量50%的记录并汇总
select
    g.salespersonid as `销售人员ID`,
    sum(g.quantity) as `总销量`
from
    grain_sales g
    join sales_avg a on g.salespersonid = a.salespersonid
where
    g.quantity > a.avg_quantity * 0.5
group by
    g.salespersonid;