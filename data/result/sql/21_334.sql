with order_customer as (

select

o.totalamount,

c.city

from

ant_icube_dev.di_data_cleaning_for_customer_database_e_orders o

join ant_icube_dev.di_data_cleaning_for_customer_database_e_customers c on o.customerid = c.customerid

)

select

city as `城市`,

sum(cast(totalamount as double)) as `总金额`,

sum(cast(totalamount as double)) * 0.1 as `预估利润`

from

order_customer

group by

city;