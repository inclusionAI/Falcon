with product_sales as (

select

s.productid,

p.categoryid,

sum(cast(s.quantity as bigint)) as total_quantity

from ant_icube_dev.grocery_sales_sales s

join ant_icube_dev.grocery_sales_products p

on s.productid = p.productid

group by s.productid, p.categoryid

),

category_avg as (

select

categoryid,

avg(total_quantity) as avg_quantity

from product_sales

group by categoryid

),

filtered_products as (

select

ps.productid,

ps.categoryid,

ps.total_quantity,

ca.avg_quantity

from product_sales ps

join category_avg ca

on ps.categoryid = ca.categoryid

where ps.total_quantity > ca.avg_quantity

),

ranked_products as (

select

productid,

categoryid,

total_quantity,

row_number() over (

partition by categoryid

order by total_quantity desc

) as sales_rank

from filtered_products

)

select

rp.productid as `productid`,

c.categoryname as `categoryname`,

rp.sales_rank as `销量排名`

from ranked_products rp

join ant_icube_dev.grocery_sales_categories c

on rp.categoryid = c.categoryid;