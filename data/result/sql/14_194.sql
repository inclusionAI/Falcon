with product_data as (
    select
        product_id,
        cast(trim(replace(product_price, '$', '')) as decimal(10,2)) as clean_price
    from ant_icube_dev.mexico_toy_products
),

store_filter as (
    select
        store_id
    from ant_icube_dev.mexico_toy_stores
    where store_city = 'San Luis Potosi'
),

sales_base as (
    select
        s.store_id,
        cast(s.units as int) * p.clean_price as sale_amount
    from ant_icube_dev.mexico_toy_sales s
    join product_data p
        on s.product_id = p.product_id
    join store_filter f
        on s.store_id = f.store_id
    where year(to_date(s.date)) = 2018
),

store_sales as (
    select
        s.store_id,
        sum(s.sale_amount) as total_sales
    from sales_base s
    group by s.store_id
),

ranked_sales as (
    select
        store_id,
        total_sales,
        row_number() over (order by total_sales desc) as sales_rank
    from store_sales
)

select
    store_id as `store_id`
from ranked_sales
where sales_rank <= 5;