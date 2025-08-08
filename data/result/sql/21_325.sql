with

-- 筛选工具类商品

tools_products as (

select productid

from ant_icube_dev.di_data_cleaning_for_customer_database_e_products

where category = 'Tools'

),

-- 筛选卡萨布兰卡客户

casablanca_customers as (

select customerid

from ant_icube_dev.di_data_cleaning_for_customer_database_e_customers

where city = 'Casablanca'

),

-- 关联有效订单

valid_orders as (

select

o.totalamount

from ant_icube_dev.di_data_cleaning_for_customer_database_e_orders o

inner join tools_products p on o.productid = p.productid

inner join casablanca_customers c on o.customerid = c.customerid

)

-- 统计总金额

select

sum(cast(totalamount as double)) as `总金额`

from valid_orders;