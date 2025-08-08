with 
stores_residential as (
    select store_id
    from ant_icube_dev.mexico_toy_stores
    where store_location = 'Downtown'
),
sales_joined as (
    select 
        s.product_id,
        cast(s.units as bigint) as units
    from ant_icube_dev.mexico_toy_sales s
    join stores_residential sr
    on s.store_id = sr.store_id
),
product_sales as (
    select 
        product_id,
        sum(units) as total_units
    from sales_joined
    group by product_id
    having sum(units) < 3
),
sales_ranked as (
    select 
        product_id,
        total_units,
        row_number() over (order by total_units desc) as rn
    from product_sales
)
select 
    p.product_name as `产品名称`,
    sr.total_units as `总销量`
from sales_ranked sr
join ant_icube_dev.mexico_toy_products p
on sr.product_id = p.product_id
where rn <= 2;