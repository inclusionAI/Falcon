with order_items_cte as (
    select
        product_id,
        cast(price as DECIMAL(10,2)) as price,
        cast(shipping_charges as DECIMAL(10,2)) as shipping_charges
    from
        ant_icube_dev.ecommerce_order_order_items
),
products_cte as (
    select
        product_id,
        product_category_name
    from
        ant_icube_dev.ecommerce_order_products
),
joined_data as (
    select
        p.product_category_name,
        oi.price,
        oi.shipping_charges
    from
        order_items_cte oi
        join products_cte p on oi.product_id = p.product_id
),
category_totals as (
    select
        product_category_name,
        sum(price) as total_sales,
        sum(price - shipping_charges) as total_profit
    from
        joined_data
    group by
        product_category_name
)
select
    product_category_name as `产品类别`,
    total_sales as `总销售额`,
    total_profit as `总利润`
from
    category_totals
where
    total_sales > 5000;