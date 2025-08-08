with product_sales as (
    select
        s.productkey,
        sum(
            cast(trim(s.orderquantity) as double) * cast(trim(p.productprice) as double)
        ) as total_sales
    from
        ant_icube_dev.tech_sales_sales_data s
        join ant_icube_dev.tech_sales_product_lookup p on s.productkey = p.productkey
    group by
        s.productkey
),
product_subcategory as (
    select
        p.productkey,
        ps.productsubcategorykey,
        p.productname
    from
        ant_icube_dev.tech_sales_product_lookup p
        join ant_icube_dev.tech_sales_product_subcategories ps on p.productsubcategorykey = ps.productsubcategorykey
),
subcategory_avg as (
    select
        ps.productsubcategorykey,
        avg(psales.total_sales) as avg_sales
    from
        product_subcategory ps
        join product_sales psales on ps.productkey = psales.productkey
    group by
        ps.productsubcategorykey
)
select
    ps.productkey
from
    product_subcategory ps
    join product_sales psales on ps.productkey = psales.productkey
    join subcategory_avg sa on ps.productsubcategorykey = sa.productsubcategorykey
where
    psales.total_sales > sa.avg_sales;