with laptop_subcategory as (
    select 
        productsubcategorykey 
    from 
        ant_icube_dev.tech_sales_product_subcategories 
    where 
        subcategoryname = 'Laptops'
),
laptop_products as (
    select 
        p.productkey,
        p.modelname,
        cast(p.productprice as double) as productprice,
        cast(p.productcost as double) as productcost
    from 
        ant_icube_dev.tech_sales_product_lookup p
    join 
        laptop_subcategory ls 
    on 
        p.productsubcategorykey = ls.productsubcategorykey
),
december_sales as (
    select 
        productkey
    from 
        ant_icube_dev.tech_sales_sales_data
    where 
        TO_CHAR(to_date(orderdate, 'MM/dd/yyyy'), 'yyyy-MM-dd') between '2022-12-01' and '2022-12-31'
),
sales_profit as (
    select 
        lp.modelname,
        ((lp.productprice - lp.productcost) / lp.productcost) as profit_ratio
    from 
        december_sales ds
    join 
        laptop_products lp 
    on 
        ds.productkey = lp.productkey
),
avg_profit as (
    select 
        modelname,
        avg(profit_ratio) as avg_profit_margin
    from 
        sales_profit
    group by 
        modelname
)
select 
    modelname as `modelname`,
    avg_profit_margin as `平均利润率`
from 
    avg_profit;