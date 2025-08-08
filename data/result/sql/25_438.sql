with product_returns as (
    select 
        productkey,
        sum(cast(trim(returnquantity) as int)) as total_return
    from 
        ant_icube_dev.tech_sales_product_returns
    group by productkey
    having 
        total_return > 1
),
router_products as (
    select 
        productkey,
        productname
    from 
        ant_icube_dev.tech_sales_product_lookup
    where 
        lower(productname) like '%wifi%range%extender%'
)
select 
    rp.productkey as `productkey`
from 
    router_products rp
inner join 
    product_returns pr 
on 
    rp.productkey = pr.productkey;