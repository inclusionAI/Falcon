with category_avg as (

select

category,

avg(cast(price as double)) as avg_price

from

ant_icube_dev.di_data_cleaning_for_customer_database_e_products

where

cast(stockquantity as bigint) > 0

group by

category

),

valid_products as (

select

p.category,

p.productid,

cast(p.price as double) as price

from

ant_icube_dev.di_data_cleaning_for_customer_database_e_products p

inner join

category_avg ca on p.category = ca.category

where

cast(p.price as double) >= ca.avg_price

and cast(p.stockquantity as bigint) > 0

),

valid_sales as (

select

vp.productid,

vp.category,

sum(cast(o.quantity as bigint) * vp.price) as valid_total

from

valid_products vp

inner join

ant_icube_dev.di_data_cleaning_for_customer_database_e_orders o on vp.productid = o.productid

group by

vp.category,

vp.productid

),

total_sales as (

select

p.category,

sum(cast(o.quantity as bigint) * cast(p.price as double)) as total

from

ant_icube_dev.di_data_cleaning_for_customer_database_e_products p

inner join

ant_icube_dev.di_data_cleaning_for_customer_database_e_orders o on p.productid = o.productid

group by

p.category

)

select

vs.productid as `productid`,

ts.category as `category`,

coalesce(vs.valid_total, 0.0) / ts.total as `销售金额占比`

from

total_sales ts

left join

valid_sales vs on ts.category = vs.category;