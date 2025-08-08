with product_sales as (
    select
        sale.`product_name` as `product_name`,
        sum(cast(sale.amount as bigint) * cast(price.price as bigint)) as `total_sales`
    from
        ant_icube_dev.bakery_sales_sale sale
    join ant_icube_dev.bakery_sales_price price
        on sale.product_name = price.name
    group by
        sale.`product_name`
),

-- 计算所有面包的总销售额
total_sales as (
    select
        sum(`total_sales`) as `overall_total`
    from
        product_sales
)

-- 计算每个产品的销售额占比
select
    ps.`product_name` as `product_name`,
    ps.`total_sales`,
    round(cast(ps.`total_sales` as double) / (SELECT overall_total as double FROM total_sales), 4) as `sales_ratio`
from
    product_sales ps