with latest_orders as (
    select 
        customerkey,
        productkey,
        row_number() over (partition by customerkey order by to_date(orderdate, 'dd/MM/yyyy') desc) as rn
    from 
        ant_icube_dev.tech_sales_sales_data
),
filtered_products as (
    select 
        lo.customerkey,
        pl.productname,
        pl.productsubcategorykey
    from 
        latest_orders lo
    join 
        ant_icube_dev.tech_sales_product_lookup pl 
    on 
        lo.productkey = pl.productkey
    where 
        lo.rn = 1 
        and cast(pl.productprice as double) > 400
),
category_mapping as (
    select 
        fp.customerkey,
        fp.productname,
        pc.categoryname
    from 
        filtered_products fp
    join 
        ant_icube_dev.tech_sales_product_subcategories ps 
    on 
        fp.productsubcategorykey = ps.productsubcategorykey
    join 
        ant_icube_dev.tech_sales_product_categories pc 
    on 
        ps.productcategorykey = pc.productcategorykey
)
select 
    cl.name as `客户名称`,
    cm.productname as `商品名称`,
    cm.categoryname as `商品类别`
from 
    category_mapping cm
join 
    ant_icube_dev.tech_sales_customer_lookup cl 
on 
    cm.customerkey = cl.customer_id;