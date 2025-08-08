with filtered_products as (
    select product_id
    from ant_icube_dev.ecommerce_order_products
    where product_category_name = 'toys'
),
sales_data as (
    select 
        c.customer_city,
        oo.order_purchase_timestamp,
        cast(oi.price as double) as price
    from ant_icube_dev.ecommerce_order_order_items oi
    join ant_icube_dev.ecommerce_order_orders oo on oi.order_id = oo.order_id
    join ant_icube_dev.ecommerce_order_customers c on oo.customer_id = c.customer_id
    join filtered_products fp on oi.product_id = fp.product_id
),
annual_sales as (
    select 
        customer_city,
        extract(year from cast(order_purchase_timestamp as timestamp)) as year,
        sum(price) as total_sales
    from sales_data
    group by customer_city, year
),
avg_2017_sales as (
    select
        avg(cast(total_sales as double)) as avg_sales
    from 
        annual_sales
    where
        year = 2017  
)
select distinct customer_city as `customer_city`
from annual_sales
where  annual_sales.total_sales > (select avg_sales from avg_2017_sales) * 1.10
and annual_sales.year = 2018