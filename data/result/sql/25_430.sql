with return_summary as (
    select 
        productkey, 
        sum(cast(trim(returnquantity) as int)) as total_return 
    from 
        ant_icube_dev.tech_sales_product_returns 
    group by 
        productkey
),
max_return as (
    select 
        max(total_return) as max_total 
    from 
        return_summary
)
select 
    p.modelname as `modelname`
from 
    return_summary rs
join 
    ant_icube_dev.tech_sales_product_lookup p 
on 
    rs.productkey = p.productkey
join 
    max_return mr 
on 
    rs.total_return = mr.max_total;