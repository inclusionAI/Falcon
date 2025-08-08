with 
stores as (
    select store_id
    from ant_icube_dev.mexico_toy_stores
    where store_city = 'Mexicali'
),
products as (
    select product_id, product_price
    from ant_icube_dev.mexico_toy_products 
    where product_category = 'Toys'
),
 sales_data as (
    select 
        s.store_id,
        s.units,
        products.product_price
    from ant_icube_dev.mexico_toy_sales s
    join stores 
        on s.store_id = stores.store_id
    join products 
        on s.product_id = products.product_id
    where substr(s.date, 1, 4) = '2018'
),
sales_calculation as (
    select
        sales_data.store_id,
        sum(
            cast(sales_data.units as bigint) 
            * cast(regexp_replace(sales_data.product_price, '[^0-9.]', '') as double)
        ) as total_sales
    from sales_data
    group by sales_data.store_id
)
select
    stores.store_name as `店铺名称`,
    sales_calculation.total_sales as `销售额`,
    rank() over(order by sales_calculation.total_sales desc) as `排名`
from sales_calculation
join ant_icube_dev.mexico_toy_stores stores
    on sales_calculation.store_id = stores.store_id;