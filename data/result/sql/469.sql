with 
-- 关联客户表和销售表，获取客户的购买数量及所在城市ID
customer_sales as (
    select
        c.cityid as customer_cityid,
        s.quantity
    from
        ant_icube_dev.grocery_sales_customers c
    inner join
        ant_icube_dev.grocery_sales_sales s
    on
        c.customerid = s.customerid
),
-- 关联城市表获取城市名称
city_data as (
    select
        ci.cityid,
        ci.cityname
    from
        ant_icube_dev.grocery_sales_cities ci
)
-- 计算各城市平均购买量并排名
select
    cityname as `城市名称`,
    avg(cast(quantity as double)) as `平均购买数量`
from
    customer_sales
inner join
    city_data
on
    customer_sales.customer_cityid = city_data.cityid
group by
    cityname;