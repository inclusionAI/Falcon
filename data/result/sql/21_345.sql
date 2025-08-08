with category_avg_stock as (

select

category,

avg(cast(stockquantity as bigint)) as avg_stock

from

ant_icube_dev.di_data_cleaning_for_customer_database_e_products

group by

category

),

low_stock_products as (

select

p.category,

p.productid

from

ant_icube_dev.di_data_cleaning_for_customer_database_e_products p

inner join

category_avg_stock c

on

p.category = c.category

where

cast(p.stockquantity as bigint) < c.avg_stock

),

product_max_order_date as (

select

productid,

max(orderdate) as latest_order_date

from

ant_icube_dev.di_data_cleaning_for_customer_database_e_orders

group by

productid

)

select

l.category as `category`,

count(distinct l.productid) as `low_stock_count`,

max(m.latest_order_date) as `latest_order_date`

from

low_stock_products l

left join

product_max_order_date m

on

l.productid = m.productid

group by

l.category;