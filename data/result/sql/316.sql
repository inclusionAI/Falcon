select

p.category as `产品类别`,

sum(cast(o.totalamount as decimal)) as `总销售额`

from

ant_icube_dev.di_data_cleaning_for_customer_database_e_orders o

join

ant_icube_dev.di_data_cleaning_for_customer_database_e_products p

on

o.productid = p.productid

group by

p.category;